--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Netherspite", 532, 1561)
if not mod then return end
mod:RegisterEnableMob(15689)

local voidcount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phase = "Phases"
	L.phase_desc = "Warns when Netherspite changes from one phase to another."
	L.phase1_message = "Withdrawal - Netherbreaths Over"
	L.phase1_bar = "~Possible Withdrawal"
	L.phase1_trigger = "%s cries out in withdrawal, opening gates to the nether."
	L.phase2_message = "Rage - Incoming Netherbreaths!"
	L.phase2_bar = "~Possible Rage"
	L.phase2_trigger = "%s goes into a nether-fed rage!"

	L.voidzone_warn = "Void Zone (%d)!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"phase", 37063, 38523, "berserk"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "VoidZone", 37063)
	self:Log("SPELL_CAST_START", "Netherbreath", 38523)

	self:Emote("Phase1", L["phase1_trigger"])
	self:Emote("Phase2", L["phase2_trigger"])

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 15689)
end

function mod:OnEngage()
	voidcount = 1
	self:Bar("phase", 60, L["phase2_bar"], "Spell_ChargePositive")
	self:Berserk(540)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:VoidZone(args)
	self:MessageOld(args.spellId, "yellow", nil, L["voidzone_warn"]:format(voidcount))
	voidcount = voidcount + 1
end

function mod:Netherbreath(args)
	self:MessageOld(args.spellId, "orange")
	self:Bar(args.spellId, 2.5, "<"..args.spellName..">")
end

function mod:Phase1()
	self:StopBar("<"..self:SpellName(38523)..">")
	self:MessageOld("phase", "red", nil, L["phase1_message"], "Spell_ChargePositive")
	self:Bar("phase", 58, L["phase2_bar"], "Spell_ChargePositive")
end

function mod:Phase2()
	self:MessageOld("phase", "red", nil, L["phase2_message"], "Spell_ChargeNegative")
	self:Bar("phase", 30, L["phase1_bar"], "Spell_ChargeNegative")
end

