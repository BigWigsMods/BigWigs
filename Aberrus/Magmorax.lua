if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Magmorax", 2569, 2527)
if not mod then return end
mod:RegisterEnableMob(201579) -- Magmorax
mod:SetEncounterID(2683)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local moltenSpittleCount = 1
local ignitingRoarCount = 1
local overpoweringStompCount = 1
local blazingBreathCount = 1
local incineratingMawsCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
end

--------------------------------------------------------------------------------
-- Initialization
--

local moltenSpittleMarker = mod:AddMarkerOption(true, "player", 1, 402994, 1, 2, 3) -- Molten Spittle
function mod:GetOptions()
	return {
		408358, -- Catastrophic Eruption
		{402994, "SAY", "SAY_COUNTDOWN"}, -- Molten Spittle
		moltenSpittleMarker,
		408839, -- Searing Heat
		407879, -- Blazing Tantrum
		403740, -- Igniting Roar
		403671, -- Overpowering Stomp
		409093, -- Blazing Breath
		{404846, "TANK"}, -- Incinerating Maws
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "CatastrophicEruption", 408358)
	self:Log("SPELL_CAST_SUCCESS", "MoltenSpittle", 402989)
	self:Log("SPELL_AURA_APPLIED", "MoltenSpittleApplied", 402994)
	self:Log("SPELL_AURA_REMOVED", "MoltenSpittleRemoved", 402994)
	self:Log("SPELL_AURA_APPLIED", "SearingHeatApplied", 408839)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SearingHeatApplied", 408839)
	self:Log("SPELL_CAST_SUCCESS", "BlazingTantrum", 407879)
	self:Log("SPELL_CAST_START", "IgnitingRoar", 403740)
	self:Log("SPELL_CAST_START", "OverpoweringStomp", 403671)
	self:Log("SPELL_CAST_START", "BlazingBreath", 409093)
	self:Log("SPELL_CAST_START", "IncineratingMaws", 404846)
	self:Log("SPELL_AURA_APPLIED", "IncineratingMawsApplied", 404846)
	self:Log("SPELL_AURA_APPLIED_DOSE", "IncineratingMawsApplied", 404846)
end

function mod:OnEngage()
	moltenSpittleCount = 1
	ignitingRoarCount = 1
	overpoweringStompCount = 1
	blazingBreathCount = 1
	incineratingMawsCount = 1

	self:Bar(403740, 5, CL.count:format(self:SpellName(403740), ignitingRoarCount)) -- Igniting Roar
	self:Bar(402994, 14.5, CL.count:format(self:SpellName(402994), moltenSpittleCount)) -- Molten Spittle
	self:Bar(404846, 20, CL.count:format(self:SpellName(401348), incineratingMawsCount)) -- Incinerating Maws
	self:Bar(409093, 26, CL.count:format(self:SpellName(409093), blazingBreathCount)) -- Blazing Breath
	self:Bar(403671, 69, CL.count:format(self:SpellName(403671), overpoweringStompCount)) -- Overpowering Stomp

	self:Bar(408358, 340) -- Catastrophic Eruption
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CatastrophicEruption(args)
	self:StopBar(408358) -- Catastrophic Eruption
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

do
	local playerList = {}
	function mod:MoltenSpittle(args)
		self:StopBar(CL.count:format(args.spellName, moltenSpittleCount))
		moltenSpittleCount = moltenSpittleCount + 1
		local cd = {25.0, 27.0, 24.0, 26.0} -- Repeating
		local cast = (moltenSpittleCount % 4) + 1 -- 1, 2, 3, 4
		self:Bar(402994, cd[cast], CL.count:format(args.spellName, moltenSpittleCount))
		playerList = {}
	end

	function mod:MoltenSpittleApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, CL.rticon:format(args.spellName, count))
			self:SayCountdown(args.spellId, 6, count)
		end
		self:CustomIcon(moltenSpittleMarker, args.destName, count)
		self:TargetsMessage(args.spellId, "cyan", playerList, 3, CL.count:format(args.spellName, moltenSpittleCount-1))
	end

	function mod:MoltenSpittleRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(moltenSpittleMarker, args.destName)
	end
end

function mod:SearingHeatApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 3 == 1 then -- 1, 4, 7, 10, ...
			self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
			self:PlaySound(args.spellId, "underyou")
		end
	end
end

function mod:BlazingTantrum(args)
	self:TargetMessage(args.spellId, "red", args.destName)
	self:PlaySound(args.spellId, "warning")

	local catastrophicEruptionTimeLeft = self:BarTimeLeft(408358) -- Catastrophic Eruption
	if catastrophicEruptionTimeLeft > 18 then -- Update timer
		self:Bar(408358, catastrophicEruptionTimeLeft - 17) -- Catastrophic Eruption
	end
end

function mod:IgnitingRoar(args)
	self:StopBar(CL.count:format(args.spellName, ignitingRoarCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, ignitingRoarCount))
	self:PlaySound(args.spellId, "alert")
	ignitingRoarCount = ignitingRoarCount + 1
	local cd = {39.0, 23.0, 40.0} -- Repeating
	local cast = (ignitingRoarCount % 3) + 1 -- 1, 2, 3
	self:Bar(args.spellId, cd[cast], CL.count:format(args.spellName, ignitingRoarCount))
end

function mod:OverpoweringStomp(args)
	self:StopBar(CL.count:format(args.spellName, overpoweringStompCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, overpoweringStompCount))
	self:PlaySound(args.spellId, "long")
	overpoweringStompCount = overpoweringStompCount + 1
	self:Bar(args.spellId, 102, CL.count:format(args.spellName, overpoweringStompCount))
end

function mod:BlazingBreath(args)
	self:StopBar(CL.count:format(args.spellName, blazingBreathCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, blazingBreathCount))
	self:PlaySound(args.spellId, "alert")
	blazingBreathCount = blazingBreathCount + 1
	local cd = {41.0, 33.0, 28.0} -- Repeating
	local cast = (blazingBreathCount % 3) + 1 -- 1, 2, 3
	self:Bar(args.spellId, blazingBreathCount % 3 == 0 and 41 or blazingBreathCount % 3 == 1 and 33 or 28, CL.count:format(args.spellName, blazingBreathCount))
end

function mod:IncineratingMaws(args)
	self:StopBar(CL.count:format(args.spellName, incineratingMawsCount))
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	incineratingMawsCount = incineratingMawsCount + 1
	local cd = incineratingMawsCount == 10 and 22 or incineratingMawsCount == 5 and 42 or 20
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, incineratingMawsCount))
end

function mod:IncineratingMawsApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm")
	elseif amount > 1 then -- Tank Swap?
		self:PlaySound(args.spellId, "warning")
	else
		self:PlaySound(args.spellId, "info")
	end
end
