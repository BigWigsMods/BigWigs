--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Doom Lord Kazzak", -1944)
if not mod then return end
mod:RegisterEnableMob(18728)
mod:SetAllowWin(true)
mod.worldBoss = 18728
mod.otherMenu = -1945

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.name = "Doom Lord Kazzak"

	L.engage_trigger1 = "The Legion will conquer all!"
	L.engage_trigger2 = "All mortals will perish!"

	L.enrage_warning1 = "%s Engaged - Enrage in 50-60sec"
	L.enrage_warning2 = "Enrage soon!"
	L.enrage_message = "Enraged for 10sec!"
	L.enrage_finished = "Enrage over - Next in 50-60sec"
	L.enrage_bar = "~Enrage"
	L.enraged_bar = "<Enraged>"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {{32960, "FLASH"}, 21063, "berserk"}
end

function mod:OnRegister()
	self.displayName = L.name
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Mark", 32960)
	self:Log("SPELL_AURA_APPLIED", "Twisted", 21063)
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 32964)

	self:BossYell("Engage", L["engage_trigger1"], L["engage_trigger2"])

	self:Death("Win", 18728)
end

function mod:OnEngage()
	self:MessageOld("berserk", "yellow", nil, L["enrage_warning1"]:format(self.displayName), false)
	self:DelayedMessage("berserk", 49, "orange", L["enrage_warning2"])
	self:Bar("berserk", 60, L["enrage_bar"], 32964)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Mark(args)
	if self:Me(args.destGUID) then
		self:MessageOld(args.spellId, "blue", "alarm", CL["you"]:format(args.spellName))
		self:Flash(args.spellId)
	end
end

function mod:Twisted(args)
	self:TargetMessageOld(args.spellId, args.destName, "yellow")
end

function mod:Frenzy(args)
	self:MessageOld("berserk", "red", "alert", L["enrage_message"], args.spellId)
	self:DelayedMessage("berserk", 10, "green", L["enrage_finished"])
	self:Bar("berserk", 10, L["enraged_bar"], args.spellId)
	self:DelayedMessage("berserk", 49, "orange", L["enrage_warning2"])
	self:Bar("berserk", 60, L["enrage_bar"], args.spellId)
end

