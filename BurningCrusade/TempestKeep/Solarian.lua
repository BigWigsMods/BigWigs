--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("High Astromancer Solarian", 550, 1575)
if not mod then return end
mod:RegisterEnableMob(18805)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Tal anu'men no sin'dorei!"

	L.phase = "Phase"
	L.phase_desc = "Warn for phase changes."
	L.phase1_message = "Phase 1 - Split in ~50sec"
	L.phase2_warning = "Phase 2 Soon!"
	L.phase2_trigger = "^I become"
	L.phase2_message = "20% - Phase 2"

	L.wrath_other = "Wrath"

	L.split = "Split"
	L.split_desc = "Warn for split & add spawn."
	L.split_trigger1 = "I will crush your delusions of grandeur!"
	L.split_trigger2 = "You are hopelessly outmatched!"
	L.split_bar = "~Next Split"
	L.split_warning = "Split in ~7 sec"

	L.agent_warning = "Split! - Agents in 6 sec"
	L.agent_bar = "Agents"
	L.priest_warning = "Priests/Solarian in 3 sec"
	L.priest_bar = "Priests/Solarian"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{42783, "ICON", "PROXIMITY"}, "phase", "split"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Wrath", 42783)
	self:Log("SPELL_AURA_REMOVED", "WrathRemove", 42783)

	self:BossYell("Engage", L["engage_trigger"])
	self:BossYell("Phase2", L["phase2_trigger"])
	self:BossYell("Split", L["split_trigger1"], L["split_trigger2"])

	self:Death("Win", 18805)
end

function mod:OnEngage()
	self:RegisterUnitEvent("UNIT_HEALTH", nil, "target", "focus")

	self:MessageOld("phase", "green", nil, L["phase1_message"], false)
	self:Bar("phase", 50, L["split_bar"], "Spell_Shadow_SealOfKings")
	self:DelayedMessage("phase", 43, "red", L["split_warning"])
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Wrath(args)
	self:TargetMessageOld(args.spellId, args.destName, "yellow", nil, L["wrath_other"])
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetBar(args.spellId, 6, args.destName, L["wrath_other"])
	if self:Me(args.destGUID) then
		self:OpenProximity(args.spellId, 10)
	end
end

function mod:WrathRemove(args)
	self:PrimaryIcon(args.spellId)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

function mod:UNIT_HEALTH(event, unit)
	if self:MobId(self:UnitGUID(unit)) == 18805 then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
		if hp > 21 and hp < 25 then
			self:MessageOld("phase", "green", nil, L["phase2_warning"], false)
			self:UnregisterUnitEvent(event, "target", "focus")
		end
	end
end

function mod:Phase2()
	self:MessageOld("phase", "red", nil, L["phase2_message"], false)
	self:CancelAllTimers()
	self:StopBar(L["split_bar"])
end

function mod:Split()
	--split is around 90 seconds after the previous
	self:Bar("split", 90, L["split_bar"], "Spell_Shadow_SealOfKings")
	self:DelayedMessage("split", 83, "red", L["split_warning"])

	-- Agents 6 seconds after the Split
	self:MessageOld("split", "red", nil, L["agent_warning"], false)
	self:Bar("split", 6, L["agent_bar"], "Ability_Creature_Cursed_01")

	-- Priests 22 seconds after the Split
	self:DelayedMessage("split", 19, "red", L["priest_warning"])
	self:Bar("split", 22, L["priest_bar"], "Spell_Holy_HolyBolt")
end

