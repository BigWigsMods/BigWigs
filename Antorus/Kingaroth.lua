--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kin'garoth", nil, 2004, 1712)
if not mod then return end
mod:RegisterEnableMob(122578)
mod.engageId = 2088
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local reverberatingStrikeCount = 1
local nextApocalypseProtocol = 0
local mobTable = {
	[123906] = {}, -- Garothi Annihilator
	[123929] = {}, -- Garothi Demolisher
	[123921] = {}, -- Garothi Decimator
}
local mobCount = {
	[123906] = 0, -- Garothi Annihilator
	[123929] = 0, -- Garothi Demolisher
	[123921] = 0, -- Garothi Decimator
}

local empBomb = nil
local empRuiner = nil
local empStrike = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.empowered = "(E) %s" -- (E) Ruiner
	L.gains = "Kin'garoth gains %s"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Stage: Deployment ]]--
		{254919, "TANK"}, -- Forging Strike
		254926, -- Reverberating Strike
		248214, -- Diabolic Bomb
		246833, -- Ruiner
		248375, -- Shattering Strike

		--[[ Stage: Construction ]]--
		246516, -- Apocalypse Protocol

		--[[ Adds ]]--
		246657, -- Annihilation
		246686, -- Decimation
		{246698, "SAY"}, -- Demolish
	},{
		[244312] = -16151, -- Stage: Deployment
		[246516] = -16152, -- Stage: Construction
		[246657] = CL.adds,
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4")

	--[[ Stage: Deployment ]]--
	self:Log("SPELL_CAST_START", "ForgingStrike", 254919)
	self:Log("SPELL_AURA_APPLIED", "ForgingStrikeApplied", 254919)
	self:Log("SPELL_CAST_START", "ReverberatingStrike", 254926)
	self:Log("SPELL_CAST_SUCCESS", "DiabolicBomb", 248214)
	self:Log("SPELL_CAST_START", "Ruiner", 246833)

	--[[ Stage: Construction ]]--
	self:Log("SPELL_AURA_APPLIED", "ApocalypseProtocol", 246516)
	self:Log("SPELL_AURA_REMOVED", "ApocalypseProtocolOver", 246516)

	--[[ Adds ]]--
	self:Log("SPELL_CAST_SUCCESS", "Initializing", 246504)
	self:Log("SPELL_AURA_APPLIED", "Decimation", 246687)
	self:Log("SPELL_AURA_APPLIED", "Demolish", 246698)
	self:Death("AddDeaths", 123906, 123929, 123921) -- Garothi Annihilator, Garothi Demolisher, Garothi Decimator

	--[[ Mythic ]]--
	self:Log("SPELL_AURA_APPLIED", "EmpoweredReverberatingStrike ", 254795)
	self:Log("SPELL_AURA_APPLIED", "EmpoweredDiabolicBomb", 254796)
	self:Log("SPELL_AURA_APPLIED", "EmpoweredRuiner", 254797)

	self:Log("SPELL_AURA_APPLIED", "ReverberatingDecimation", 249680)
end

function mod:OnEngage()
	reverberatingStrikeCount = 1
	mobTable = {
		[123906] = {}, -- Garothi Annihilator
		[123929] = {}, -- Garothi Demolisher
		[123921] = {}, -- Garothi Decimator
	}
	mobCount = {
		[123906] = 0, -- Garothi Annihilator
		[123929] = 0, -- Garothi Demolisher
		[123921] = 0, -- Garothi Decimator
	}
	empBomb = nil
	empRuiner = nil
	empStrike = nil

	self:Bar(254919, 7.5) -- Forging Strike
	self:Bar(248214, 10.5) -- Diabolic Bomb
	self:Bar(254926, 14.5) -- Reverberating Strike
	self:Bar(246833, 21.5) -- Ruiner

	nextApocalypseProtocol = GetTime() + 32.5
	self:Bar(246516, 32.5) -- Apocalypse Protocol
end

--------------------------------------------------------------------------------
-- Local Functions
--

local function getMobNumber(mobId, guid)
	if mobTable[mobId][guid] then return mobTable[mobId][guid] end
	mobCount[mobId] = mobCount[mobId] + 1
	mobTable[mobId][guid] = mobCount[mobId]
	return mobCount[mobId]
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 246686 then -- Decimation
		local guid = UnitGUID(unit)
		local mobId = self:MobId(guid)
		local mobText = getMobNumber(mobId, guid)
		self:Bar(spellId, 15.8, CL.count:format(spellName, mobText))
	elseif spellId == 246657 then -- Annihilation
		local guid = UnitGUID(unit)
		local mobId = self:MobId(guid)
		local mobText = getMobNumber(mobId, guid)
		self:Message(spellId, "Important", "Alarm")
		self:Bar(spellId, 15.8, CL.count:format(spellName, mobText))
	elseif spellId == 248375 then -- Shattering Strike
		self:Message(spellId, "Urgent", "Warning")
	end
end

--[[ Stage: Deployment ]]--
function mod:ForgingStrike(args)
	self:Message(args.spellId, "Attention", "Alert")
	local cooldown = 28
	if nextApocalypseProtocol > GetTime() + cooldown then
		self:CDBar(args.spellId, cooldown)
	end
end

function mod:ForgingStrikeApplied(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Warning", nil, nil, self:Tank())
end

function mod:ReverberatingStrike(args)
	self:Message(args.spellId, "Attention", "Alert")
	reverberatingStrikeCount = reverberatingStrikeCount + 1
	if reverberatingStrikeCount <= 3 then
		if empStrike then -- Empowered
			self:CDBar(args.spellId, reverberatingStrikeCount == 2 and 25 or 28, L.empowered:format(args.spellName))
		else
			self:CDBar(args.spellId, reverberatingStrikeCount == 2 and 25 or 28)
		end
	end
end

function mod:DiabolicBomb(args)
	self:Message(args.spellId, "Important", "Alarm")
	local cooldown = 28
	if nextApocalypseProtocol > GetTime() + cooldown then
		if empBomb then -- Empowered
			self:CDBar(args.spellId, cooldown, L.empowered:format(args.spellName))
		else
			self:CDBar(args.spellId, cooldown)
		end
	end
end

function mod:Ruiner(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
	local cooldown = 25.5
	if nextApocalypseProtocol > GetTime() + cooldown then
		if empRuiner then -- Empowered
			self:CDBar(args.spellId, cooldown, L.empowered:format(args.spellName))
		else
			self:CDBar(args.spellId, cooldown)
		end
	end
end

--[[ Stage: Construction ]]--
function mod:ApocalypseProtocol(args)
	self:StopBar(254919) -- Forging Strike
	self:StopBar(248214) -- Diabolic Bomb
	self:StopBar(254926) -- Reverberating Strike
	self:StopBar(246833) -- Ruiner
	self:StopBar(L.empowered:format(self:SpellName(248214))) -- (E) Diabolic Bomb
	self:StopBar(L.empowered:format(self:SpellName(254926))) -- (E) Reverberating Strike
	self:StopBar(L.empowered:format(self:SpellName(246833))) -- (E) Ruiner
	self:Message(args.spellId, "Positive", "Long")
	self:CastBar(args.spellId, 40)
	nextApocalypseProtocol = GetTime() + 129
	self:Bar(args.spellId, 129)
end

function mod:ApocalypseProtocolOver(args)
	self:Message(args.spellId, "Neutral", "Info", CL.over:format(args.spellName))
	reverberatingStrikeCount = 1
	self:Bar(248214, 0.5, empBomb and L.empowered:format(self:SpellName(248214))) -- Diabolic Bomb
	self:Bar(254919, 2) -- Forging Strike
	self:Bar(254926, 3, empStrike and L.empowered:format(self:SpellName(254926))) -- Reverberating Strike
	self:Bar(246833, 20.5, empRuiner and L.empowered:format(self:SpellName(246833))) -- Ruiner
end

--[[ Adds ]]--
function mod:Initializing(args)
	local mobId = self:MobId(args.sourceGUID)
	local mobText = getMobNumber(mobId, args.sourceGUID)
	if mobId == 123906 then -- Garothi Annihilator
		self:CDBar(246657, 45, CL.count:format(self:SpellName(246657), mobText)) -- Annihilation
	elseif mobId == 123929 then -- Garothi Demolisher
		self:CDBar(246698, 47.5, CL.count:format(self:SpellName(246698), mobText)) -- Demolish
	elseif mobId == 123921 then -- Garothi Decimator
		self:CDBar(246686, 45, CL.count:format(self:SpellName(246686), mobText)) -- Decimation
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:Demolish(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 6)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Urgent", "Warning")
			local mobId = self:MobId(args.sourceGUID)
			local mobText = getMobNumber(mobId, args.sourceGUID)
			self:Bar(args.spellId, 15.8, CL.count:format(args.spellName, mobText))
		end
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:Decimation(args)
		if self:Me(args.destGUID) then
			self:Say(246686)
			self:SayCountdown(246686, 6)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, 246686, playerList, "Urgent", "Warning")
		end
	end
end

function mod:AddDeaths(args)
	local mobText = getMobNumber(args.mobId, args.destGUID)
	if args.mobId == 123906 then -- Garothi Annihilator
		self:StopBar(CL.count:format(self:SpellName(246657), mobText)) -- Annihilation
	elseif args.mobId == 123929 then -- Garothi Demolisher
		self:StopBar(CL.count:format(self:SpellName(246698), mobText)) -- Demolish
	elseif args.mobId == 123921 then -- Garothi Decimator
		self:StopBar(CL.count:format(self:SpellName(246686), mobText)) -- Decimation
	end
end

--[[ Mythic ]]--
function mod:EmpoweredRuiner(args)
	self:Message(246833, "Neutral", "Info", L.gains:format(args.spellName))
	empRuiner = true
	self:Bar(246833, self:BarTimeLeft(self:SpellName(246833)), L.empowered:format(self:SpellName(246833))) -- (E) Ruiner
	self:StopBar(246833)
end

function mod:EmpoweredReverberatingStrike(args)
	self:Message(254926, "Neutral", "Info", L.gains:format(args.spellName))
	empStrike = true
	self:Bar(254926, self:BarTimeLeft(self:SpellName(254926)), L.empowered:format(self:SpellName(254926))) -- (E) Reverberating Strike
	self:StopBar(254926)
end

function mod:EmpoweredDiabolicBomb(args)
	self:Message(248214, "Neutral", "Info", L.gains:format(args.spellName))
	empBomb = true
	self:Bar(248214, self:BarTimeLeft(self:SpellName(248214)), L.empowered:format(self:SpellName(248214))) -- (E) Diabolic Bomb
	self:StopBar(248214)
end

do
	local playerList = mod:NewTargetList()
	function mod:ReverberatingDecimation(args)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 4)
		end
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Urgent", "Warning")
		end
	end
end
