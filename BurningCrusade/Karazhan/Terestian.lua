--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Terestian Illhoof", 532, 1560)
if not mod then return end
mod:RegisterEnableMob(15688)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "^Ah, you're just in time."

	L.weak = "Weakened"
	L.weak_desc = "Warn for weakened state."
	L.weak_icon = 30065
	L.weak_message = "Weakened for ~45sec!"
	L.weak_warning1 = "Weakened over in ~5sec!"
	L.weak_warning2 = "Weakened over!"
	L.weak_bar = "~Weakened Fades"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"weak", {30115, "ICON"}, "berserk"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Sacrifice", 30115)
	self:Log("SPELL_AURA_REMOVED", "SacrificeRemoved", 30115)

	self:Log("SPELL_AURA_APPLIED", "Weakened", 30065)
	self:Log("SPELL_AURA_REMOVED", "WeakenedRemoved", 30065)

	self:BossYell("Engage", L["engage_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 15688)
end

function mod:OnEngage()
	self:Berserk(600)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Sacrifice(args)
	self:TargetMessageOld(args.spellId, args.destName, "yellow")
	self:TargetBar(args.spellId, 30, args.destName)
	self:DelayedMessage(args.spellId, 40, "orange", CL["soon"]:format(args.spellName))
	self:CDBar(args.spellId, 42)
	self:PrimaryIcon(args.spellId, args.destName)
end

function mod:SacrificeRemoved(args)
	self:StopBar(args.spellName, args.destName)
	self:PrimaryIcon(args.spellId)
end

function mod:Weakened(args)
	self:MessageOld("weak", "red", "alarm", L["weak_message"], args.spellId)
	self:DelayedMessage("weak", 40, "yellow", L["weak_warning1"])
	self:Bar("weak", 45, L["weak_bar"], args.spellId)
end

function mod:WeakenedRemoved()
	self:MessageOld("weak", "yellow", "info", L["weak_warning2"])
	self:CancelDelayedMessage(L["weak_warning1"])
	self:StopBar(L["weak_bar"])
end

