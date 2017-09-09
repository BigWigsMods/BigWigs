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

local diabolicBombCount = 1
local forgingStrikeCount = 1
local reverberatingStrikeCount = 1
local ruinerCount = 1
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

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Stage: Deployment ]]--
		{244312, "TANK"}, -- Forging Strike
		248475, -- Reverberating Strike
		246779, -- Diabolic Bomb
		246840, -- Ruiner
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
	self:Log("SPELL_CAST_SUCCESS", "ForgingStrike", 244312)
	self:Log("SPELL_CAST_START", "ReverberatingStrike", 248475)
	self:Log("SPELL_CAST_SUCCESS", "Ruiner", 246840)

	--[[ Stage: Construction ]]--
	self:Log("SPELL_AURA_APPLIED", "ApocalypseProtocol", 246516)
	self:Log("SPELL_AURA_REMOVED", "ApocalypseProtocolOver", 246516)

	--[[ Adds ]]--
	self:Log("SPELL_CAST_SUCCESS", "Initializing", 246504)
	self:Log("SPELL_AURA_APPLIED", "Demolish", 246698)
	self:Death("AddDeaths", 123906, 123929, 123921) -- Garothi Annihilator, Garothi Demolisher, Garothi Decimator
end

function mod:OnEngage()
	forgingStrikeCount = 1
	reverberatingStrikeCount = 1
	diabolicBombCount = 1
	ruinerCount = 1
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

	self:Bar(244312, 7.1) -- Forging Strike
	self:Bar(246779, 10.8) -- Diabolic Bomb
	self:Bar(248475, 14.5) -- Reverberating Strike
	self:Bar(246840, 24.3) -- Ruiner
	self:Bar(246516, 33) -- Apocalypse Protocol
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
	if spellId == 248214 then -- Diabolic Bomb
		self:Message(246779, "Attention", "Alert")
		diabolicBombCount = diabolicBombCount + 1
		self:CDBar(246779, diabolicBombCount % 4 == 2 and 63.2 or diabolicBombCount % 4 == 3 and 25.8 or 20.3)
	elseif spellId == 246686 then -- Decimation
		local guid = UnitGUID(unit)
		local mobId = self:MobId(guid)
		local mobText = getMobNumber(mobId, guid)
		self:Message(spellId, "Urgent", "Warning")
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
	forgingStrikeCount = forgingStrikeCount + 1
	self:CDBar(args.spellId, 28) -- XXX Unreliable atm, needs further fixing
end

function mod:ReverberatingStrike(args)
	self:Message(args.spellId, "Urgent", "Alarm")
	reverberatingStrikeCount = reverberatingStrikeCount + 1
	self:CDBar(args.spellId, reverberatingStrikeCount == 2 and 65 or reverberatingStrikeCount % 3 == 2 and 72 or reverberatingStrikeCount % 3 == 0 and 22.5 or 27)
end

function mod:Ruiner(args)
	self:Message(args.spellId, "Attention", "Alert")
	ruinerCount = ruinerCount + 1
	self:CDBar(args.spellId, ruinerCount % 3 == 2 and 70.6 or 29.2)
end

--[[ Stage: Construction ]]--
function mod:ApocalypseProtocol(args)
	self:Message(args.spellId, "Positive", "Long")
	self:CastBar(args.spellId, 40) -- XXX Maybe some other text, Shield Active/Construction Phase?
	self:Bar(args.spellId, 120)
end

function mod:ApocalypseProtocolOver(args)
	self:Message(args.spellId, "Neutral", "Info", CL.over:format(args.spellName))
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
