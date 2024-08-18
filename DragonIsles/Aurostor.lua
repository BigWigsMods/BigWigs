--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Aurostor", -2200, 2562)
if not mod then return end
mod:RegisterEnableMob(209574)
mod.otherMenu = -1978
mod.worldBoss = 209574

--------------------------------------------------------------------------------
-- Locals
--

local tantrumCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.slumberous_roar = "3x %s - Jump to remove it"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		420895, -- Groggy Bash
		420925, -- Pulverizing Outburst
		421059, -- Cranky Tantrum
		421260, -- Slumberous Roar
	}
end

function mod:VerifyEnable(unit)
	return UnitCanAttack("player", unit)
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	--self:RegisterEvent("BOSS_KILL") - no event
	self:Log("SPELL_CAST_SUCCESS", "EncounterEvent", 181089) -- Added for win detection

	self:Log("SPELL_CAST_SUCCESS", "GroggyBash", 420895)
	self:Log("SPELL_CAST_START", "PulverizingOutburst", 420925)
	self:Log("SPELL_CAST_SUCCESS", "CrankyTantrumBegin", 421006)
	self:Log("SPELL_CAST_START", "CrankyTantrum", 421059)
	self:Log("SPELL_AURA_APPLIED", "SlumberousRoarApplied", 421260)
	self:Log("SPELL_AURA_REMOVED_DOSE", "SlumberousRoarStackRemoved", 421260)
	self:Log("SPELL_AURA_REMOVED", "SlumberousRoarRemoved", 421260)
end

function mod:OnEngage()
	self:CheckForWipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--function mod:BOSS_KILL(_, id)
--	if id == 2828 then
--		self:Win()
--	end
--end

function mod:EncounterEvent(args) -- Added for win detection
	if self:MobId(args.sourceGUID) == 209574 then
		self:Win()
	end
end

function mod:GroggyBash(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	self:CDBar(args.spellId, 33)
	if not self:Me(args.destGUID) and self:Tank() then
		self:PlaySound(args.spellId, "warning") -- tauntswap
	end
end

function mod:PulverizingOutburst(args)
	self:Message(args.spellId, "red", CL.incoming:format(args.spellName))
	self:PlaySound(args.spellId, "long")
end

function mod:CrankyTantrumBegin(args)
	tantrumCount = 1
end

function mod:CrankyTantrum(args)
	self:Message(args.spellId, "yellow", CL.count_amount:format(args.spellName, tantrumCount, 4))
	tantrumCount = tantrumCount + 1
	self:PlaySound(args.spellId, "info")
end

function mod:SlumberousRoarApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, false, L.slumberous_roar:format(args.spellName))
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:SlumberousRoarStackRemoved(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 0)
	end
end

function mod:SlumberousRoarRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
	end
end
