if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- TODO:
--
--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Prophet Skitra", 2217, 2369)
if not mod then return end
mod:RegisterEnableMob(157620) -- Prophet Skitra
mod.engageId = 2334
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local phsycheCount = 1
local nextStageWarning = 83

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		{308059, "TANK"}, -- Shadow Shock
		{307950, "SAY", "SAY_COUNTDOWN", "FLASH"}, -- Shred Psyche
		309687, -- Psychic Outburst
		313239, -- Images of Absolution
		307725, -- Illusionary Projection
	}
end

function mod:OnBossEnable()
	-- Stage 1
	self:Log("SPELL_AURA_APPLIED", "ShadowShockApplied", 308059)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ShadowShockApplied", 308059)
	self:Log("SPELL_CAST_SUCCESS", "ShredPsycheSuccess", 307950)
	self:Log("SPELL_AURA_APPLIED", "ShredPsycheApplied", 307950)
	self:Log("SPELL_AURA_REMOVED", "ShredPsycheRemoved", 307950)
	self:Log("SPELL_CAST_START", "PsychicOutburst", 309687)
	self:Log("SPELL_CAST_SUCCESS", "ImagesofAbsolution", 313239)

	self:Log("SPELL_CAST_START", "IllusionaryProjection", 307725)
	self:Log("SPELL_CAST_SUCCESS", "IllusionaryProjectionSuccess", 307725)
	self:Log("SPELL_AURA_APPLIED", "IllusionaryProjectionDebuffsApplied", 307784, 307785) -- Clouded Mind, Twisted Mind
end

function mod:OnEngage()
	phsycheCount = 1
	nextStageWarning = 83

	self:Bar(307950, 12.5, CL.count:format(self:SpellName(307950), phsycheCount)) -- Shred Psyche
	self:Bar(313239, 31.5) -- Images of Absolution

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < nextStageWarning then
		self:Message2("stages", "green", CL.soon:format(self:SpellName(307725)), false)
		nextStageWarning = nextStageWarning - 20
		if nextStageWarning < 20 then
			self:UnregisterUnitEvent(event, unit)
		end
	end
end

function mod:ShadowShockApplied(args)
	local amount = args.amount or 1
	if amount > 10 or amount % 3 == 0 then
		self:StackMessage(args.spellId, args.destName, amount, "purple")
		self:PlaySound(args.spellId, amount > 10 and "warning" or "alarm", nil, args.destName)
	end
end

function mod:ShredPsycheSuccess(args)
	phsycheCount = phsycheCount + 1
	self:Bar(args.spellId, 32.5, CL.count:format(args.spellName, phsycheCount))
end

do
	local playerList = mod:NewTargetList()
	function mod:ShredPsycheApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 5)
			self:Flash(args.spellId)
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "orange", playerList, CL.count:format(args.spellName, phsycheCount-1))
	end

	function mod:ShredPsycheRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

do
	local prev = 0
	function mod:PsychicOutburst(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:CastBar(args.spellId, 5)
		end
	end
end

function mod:ImagesofAbsolution(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 85)
end

function mod:IllusionaryProjection(args)
	self:Message2(args.spellId, "green")
	self:PlaySound(args.spellId, "long")

	self:StopBar(CL.count:format(self:SpellName(307950), phsycheCount)) -- Shred Psyche
	self:StopBar(313239) -- Images of Absolution
end

function mod:IllusionaryProjectionSuccess()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
end

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	local guid = UnitGUID("boss1")
	if guid then -- Boss 1 can only be Skitra, so the boss has returned
		self:UnregisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
		self:Message2(307725, "green", CL.over:format(self:SpellName(307725))) -- Illusionary Projection
		self:PlaySound(307725, "long")

		self:Bar(307950, 15, CL.count:format(self:SpellName(307950), phsycheCount)) -- Shred Psyche
		self:Bar(313239, 32.5) -- Images of Absolution
	end
end

function mod:IllusionaryProjectionDebuffsApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(307725, nil, args.spellName, args.spellId)
	end
end