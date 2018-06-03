--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kin'garoth", 1712, 2004)
if not mod then return end
mod:RegisterEnableMob(122578)
mod.engageId = 2088
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

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
local apocalypseCount = 1
local empBomb = nil
local empRuiner = nil
local empStrike = nil
local numDecimation = mod:LFR() and 2 or mod:Normal() and 3 or mod:Heroic() and 4 or 5
local numDemolish = mod:Easy() and 1 or mod:Heroic() and 2 or 3

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
		{254926, "SAY", "FLASH"}, -- Reverberating Strike
		248214, -- Diabolic Bomb
		246833, -- Ruiner
		248375, -- Shattering Strike

		--[[ Stage: Construction ]]--
		246516, -- Apocalypse Protocol

		--[[ Adds ]]--
		246664, -- Annihilation
		246686, -- Decimation
		{246698, "SAY"}, -- Demolish

		--[[ Mythic ]]--
		{249680, "SAY"}, -- Reverberating Decimation
	},{
		[244312] = -16151, -- Stage: Deployment
		[246516] = -16152, -- Stage: Construction
		[246664] = -16143, -- Garothi Annihilator
		[246686] = -16144, -- Garothi Decimator
		[246698] = -16145, -- Garothi Demolisher
		[249680] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4")

	--[[ Stage: Deployment ]]--
	self:Log("SPELL_CAST_START", "ForgingStrike", 257978, 254919) -- LFR, others
	self:Log("SPELL_AURA_APPLIED", "ForgingStrikeApplied", 257978, 254919)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ForgingStrikeApplied", 257978, 254919)
	self:Log("SPELL_CAST_START", "ReverberatingStrike", 257997, 254926) -- LFR, others
	self:Log("SPELL_CAST_SUCCESS", "DiabolicBomb", 248214)
	self:Log("SPELL_CAST_START", "Ruiner", 246833)

	--[[ Stage: Construction ]]--
	self:Log("SPELL_AURA_APPLIED", "ApocalypseProtocol", 246516)
	self:Log("SPELL_AURA_REMOVED", "ApocalypseProtocolOver", 246516)

	--[[ Adds ]]--
	self:Log("SPELL_CAST_SUCCESS", "Initializing", 246504)
	self:Log("SPELL_AURA_APPLIED", "Decimation", 246687)
	self:Log("SPELL_AURA_APPLIED", "Demolish", 246698)
	self:Log("SPELL_CAST_SUCCESS", "DemolishSuccess", 246692)
	self:Death("AddDeaths", 123906, 123929, 123921) -- Garothi Annihilator, Garothi Demolisher, Garothi Decimator

	--[[ Mythic ]]--
	self:Log("SPELL_AURA_APPLIED", "EmpoweredReverberatingStrike", 254795)
	self:Log("SPELL_AURA_APPLIED", "EmpoweredDiabolicBomb", 254796)
	self:Log("SPELL_AURA_APPLIED", "EmpoweredRuiner", 254797)

	self:Log("SPELL_AURA_APPLIED", "ReverberatingDecimation", 249680)
end

function mod:OnEngage()
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
	apocalypseCount = 1
	numDecimation = self:LFR() and 2 or self:Normal() and 3 or self:Heroic() and 4 or 5
	numDemolish = self:Easy() and 1 or self:Heroic() and 2 or 3

	self:Bar(254919, 5.5) -- Forging Strike
	self:Bar(248214, 12.5) -- Diabolic Bomb
	self:Bar(254926, 14.5) -- Reverberating Strike
	self:Bar(246833, 25) -- Ruiner

	self:Bar(246516, 37.5, CL.count:format(self:SpellName(246516), apocalypseCount)) -- Apocalypse Protocol
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
		self:Message(246664, "red", "Alarm")
		self:Bar(246664, 15.8, CL.count:format(spellName, mobText))
	elseif spellId == 248375 then -- Shattering Strike
		self:Message(spellId, "orange", "Warning")
	end
end

--[[ Stage: Deployment ]]--
function mod:ForgingStrike(args)
	self:Message(254919, "yellow", "Alert")
	self:CDBar(254919, 14.5)
end

function mod:ForgingStrikeApplied(args)
	local amount = args.amount or 1
	self:StackMessage(254919, args.destName, amount, "orange", "Warning")
end

do
	local function printTarget(self, name, guid)
		self:PlaySound(254926, "Alert", nil, name)
		self:TargetMessage2(254926, "yellow", name)
		if self:Me(guid) and not self:LFR() then
			self:Say(254926)
			self:Flash(254926)
		end
	end

	function mod:ReverberatingStrike(args)
		self:GetBossTarget(printTarget, 0.5, args.sourceGUID)
		self:CDBar(254926, 30, empStrike and L.empowered:format(args.spellName))
	end
end

function mod:DiabolicBomb(args)
	self:Message(args.spellId, "red", "Alarm")
	self:CDBar(args.spellId, 20.5, empBomb and L.empowered:format(args.spellName))
end

function mod:Ruiner(args)
	self:Message(args.spellId, "orange", "Warning", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 9)
	self:CDBar(args.spellId, 30, empRuiner and L.empowered:format(args.spellName))
end

--[[ Stage: Construction ]]--
do
	local forginTimeLeft, bombTimeLeft, reverberatingTimeLeft, ruinerTimeLeft = 0, 0, 0, 0
	local function restartTimers()
		forginTimeLeft = forginTimeLeft + 10
		bombTimeLeft = bombTimeLeft + 10
		reverberatingTimeLeft = reverberatingTimeLeft + 10
		ruinerTimeLeft = ruinerTimeLeft + 10

		mod:Message(246516, "cyan", "Info", CL.soon:format(CL.stage:format(1)), false)
		mod:CDBar(254919, forginTimeLeft)  -- Forging Strike
		mod:CDBar(248214, bombTimeLeft, empBomb and L.empowered:format(mod:SpellName(248214))) -- Diabolic Bomb
		mod:CDBar(254926, reverberatingTimeLeft, empStrike and L.empowered:format(mod:SpellName(254926))) -- Reverberating Strike
		mod:CDBar(246833, ruinerTimeLeft, empRuiner and L.empowered:format(mod:SpellName(246833))) -- Ruiner
	end

	function mod:ApocalypseProtocol(args)
		forginTimeLeft = self:BarTimeLeft(254919) -- Forging Strike
		bombTimeLeft = empBomb and self:BarTimeLeft(L.empowered:format(self:SpellName(248214))) or self:BarTimeLeft(248214) -- Diabolic Bomb
		reverberatingTimeLeft = empStrike and self:BarTimeLeft(L.empowered:format(self:SpellName(254926))) or self:BarTimeLeft(254926) -- Reverberating Strike
		ruinerTimeLeft = empRuiner and self:BarTimeLeft(L.empowered:format(self:SpellName(246833))) or self:BarTimeLeft(246833) -- Ruiner

		self:StopBar(254919) -- Forging Strike
		self:StopBar(248214) -- Diabolic Bomb
		self:StopBar(254926) -- Reverberating Strike
		self:StopBar(246833) -- Ruiner
		self:StopBar(L.empowered:format(self:SpellName(248214))) -- (E) Diabolic Bomb
		self:StopBar(L.empowered:format(self:SpellName(254926))) -- (E) Reverberating Strike
		self:StopBar(L.empowered:format(self:SpellName(246833))) -- (E) Ruiner

		mod:ScheduleTimer(restartTimers, 30) -- 10 seconds before end

		self:Message(args.spellId, "green", "Long", CL.count:format(args.spellName, apocalypseCount))
		self:CastBar(args.spellId, 40, CL.count:format(args.spellName, apocalypseCount))
		self:StopBar(CL.count:format(args.spellName, apocalypseCount))
		apocalypseCount = apocalypseCount + 1
		self:Bar(args.spellId, 120, CL.count:format(args.spellName, apocalypseCount))
	end

	function mod:ApocalypseProtocolOver(args)
		self:Message(args.spellId, "cyan", "Info", CL.over:format(CL.count:format(args.spellName, apocalypseCount-1)))
	end
end

--[[ Adds ]]--
function mod:Initializing(args)
	local mobId = self:MobId(args.sourceGUID)
	local mobText = getMobNumber(mobId, args.sourceGUID)
	if mobId == 123906 then -- Garothi Annihilator
		self:CDBar(246664, 45, CL.count:format(self:SpellName(246664), mobText)) -- Annihilation
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
			self:PlaySound(args.spellId, "Warning")
		end
		playerList[#playerList+1] = args.destName
		self:TargetsMessage(args.spellId, "orange", playerList, numDemolish, nil, nil, 0.5)
	end

	function mod:DemolishSuccess(args)
		local mobId = self:MobId(args.sourceGUID)
		local mobText = getMobNumber(mobId, args.sourceGUID)
		self:Bar(246698, 15.8, CL.count:format(args.spellName, mobText))
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:Decimation(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(246686)
			self:SayCountdown(246686, 6)
			self:PlaySound(246686, "Warning")
		end
		self:TargetsMessage(246686, "orange", playerList, numDecimation)
	end
end

function mod:AddDeaths(args)
	local mobText = getMobNumber(args.mobId, args.destGUID)
	if args.mobId == 123906 then -- Garothi Annihilator
		self:StopBar(CL.count:format(self:SpellName(246664), mobText)) -- Annihilation
	elseif args.mobId == 123929 then -- Garothi Demolisher
		self:StopBar(CL.count:format(self:SpellName(246698), mobText)) -- Demolish
	elseif args.mobId == 123921 then -- Garothi Decimator
		self:StopBar(CL.count:format(self:SpellName(246686), mobText)) -- Decimation
	end
end

--[[ Mythic ]]--
function mod:EmpoweredRuiner(args)
	self:Message(246833, "cyan", "Info", L.gains:format(args.spellName))
	empRuiner = true
	self:Bar(246833, self:BarTimeLeft(self:SpellName(246833)), L.empowered:format(self:SpellName(246833))) -- (E) Ruiner
	self:StopBar(246833)
end

function mod:EmpoweredReverberatingStrike(args)
	self:Message(254926, "cyan", "Info", L.gains:format(args.spellName))
	empStrike = true
	self:Bar(254926, self:BarTimeLeft(self:SpellName(254926)), L.empowered:format(self:SpellName(254926))) -- (E) Reverberating Strike
	self:StopBar(254926)
end

function mod:EmpoweredDiabolicBomb(args)
	self:Message(248214, "cyan", "Info", L.gains:format(args.spellName))
	empBomb = true
	self:Bar(248214, self:BarTimeLeft(self:SpellName(248214)), L.empowered:format(self:SpellName(248214))) -- (E) Diabolic Bomb
	self:StopBar(248214)
end

do
	local playerList = mod:NewTargetList()
	function mod:ReverberatingDecimation(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 4)
			self:PlaySound(args.spellId, "Warning")
		end
		self:TargetsMessage(args.spellId, "orange", playerList, numDecimation)
	end
end
