--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Prince Malchezaar", 532, 1563)
if not mod then return end
mod:RegisterEnableMob(15690)
mod:SetAllowWin(true)
mod:SetEncounterID(2453)

local nova = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.wipe_bar = "Respawn"

	L.phase = "Engage"
	L.phase_desc = "Alert when changing phases."
	L.phase1_trigger = "Madness has brought you here to me. I shall be your undoing!"
	L.phase2_trigger = "Simple fools! Time is the fire in which you'll burn!"
	L.phase3_trigger = "How can you hope to stand against such overwhelming power?"
	L.phase1_message = "Phase 1 - Infernal in ~40sec!"
	L.phase2_message = "60% - Phase 2"
	L.phase3_message = "30% - Phase 3 "

	L.infernal = "Infernals"
	L.infernal_desc = "Show cooldown timer for Infernal summons."
	L.infernal_icon = "INV_Stone_05"
	L.infernal_bar = "Incoming Infernal"
	L.infernal_warning = "Infernal incoming in 17sec!"
	L.infernal_message = "Infernal Landed! Hellfire in 5sec!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"phase", 30843, 30852, "infernal"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Enfeeble", 30843)
	self:Log("SPELL_AURA_APPLIED", "SelfEnfeeble", 30843)
	self:Log("SPELL_CAST_START", "Nova", 30852)
	self:Log("SPELL_CAST_SUCCESS", "Infernal", 30834)

	self:BossYell("Phase2", L["phase2_trigger"])
	self:BossYell("Phase3", L["phase3_trigger"])

	self:BossYell("Engage", L["phase1_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 15690)
end

function mod:OnEngage()
	nova = nil
	self:MessageOld("phase", "green", nil, L["phase1_message"], "achievement_boss_princemalchezaar_02")

	self:DelayedMessage(30843, 25, "yellow", CL["custom_sec"]:format(self:SpellName(30843), 5))
	self:Bar(30843, 30) -- Enfeeble
end

function mod:OnWipe()
	self:Bar("phase", 60, L["wipe_bar"], "achievement_boss_princemalchezaar_02")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Enfeeble(args)
	self:MessageOld(args.spellId, "red")
	self:DelayedMessage(args.spellId, 25, "orange", CL["custom_sec"]:format(args.spellName, 5))
	self:Bar(args.spellId, 30)
	self:Bar(30852, 52) -- Shadow Nova
end

function mod:SelfEnfeeble(args)
	if self:Me(args.destGUID) then
		self:MessageOld(args.spellId, "blue", "alarm", CL["you"]:format(args.spellName))
		self:TargetBar(args.spellId, 7, args.destName)
	end
end

function mod:Nova(args)
	self:MessageOld(args.spellId, "red", "info")
	self:Bar(args.spellId, 2, "<"..args.spellName..">")
	if nova then
		self:Bar(args.spellId, 20)
		self:DelayedMessage(args.spellId, 15, "yellow", CL["soon"]:format(args.spellName))
	end
end

function mod:Infernal()
	self:MessageOld("infernal", "red", nil, L["infernal_warning"], L.infernal_icon)
	self:DelayedMessage("infernal", 12, "orange", L["infernal_message"], false, "alert")
	self:Bar("infernal", 17, L["infernal_bar"], L.infernal_icon)
end

function mod:Phase2()
	self:MessageOld("phase", "green", nil, L["phase2_message"], "achievement_boss_princemalchezaar_02")
end

function mod:Phase3()
	self:MessageOld("phase", "green", nil, L["phase3_message"], "achievement_boss_princemalchezaar_02")
	self:CancelDelayedMessage(CL["custom_sec"]:format(self:SpellName(30843), 5))
	self:StopBar(30843) -- Enfeeble
	nova = true
end

