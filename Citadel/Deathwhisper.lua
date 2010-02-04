--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Lady Deathwhisper", "Icecrown Citadel")
if not mod then return end
--Deathwhisper, Cult Adherent, Reanimated Adherent, Cult Fanatic, Reanimated Fanatic, Deformed Fanatic
mod:RegisterEnableMob(36855, 37949, 38010, 37890, 38009, 38135)
mod.toggleOptions = {"adds", 70842, 71204, {71289, "ICON"}, {71001, "FLASHSHAKE"}, "berserk", "bosskill"}
local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
mod.optionHeaders = {
	adds = CL.phase:format(1),
	[71204] = CL.phase:format(2),
	[71289] = "general",
}

--------------------------------------------------------------------------------
--  Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "What is this disturbance?"
	L.phase2_message = "Barrier DOWN - Phase 2!"

	L.dnd_message = "Death and Decay on YOU!"

	L.adds = "Adds"
	L.adds_desc = "Show timers for when the adds spawn."
	L.adds_bar = "Next Adds"
	L.adds_warning = "New adds in 5 sec!"

	L.touch_message = "%2$dx Touch on %1$s"
	L.touch_bar = "Next Touch"

	L.deformed_yell = "I release you from the curse of flesh!"
	L.deformed_fanatic = "Deformed Fanatic!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "DnD", 71001, 72108, 72109, 72110)
	self:Log("SPELL_AURA_REMOVED", "Barrier", 70842)
	self:Log("SPELL_AURA_APPLIED", "DominateMind", 71289)
	self:Log("SPELL_AURA_APPLIED", "Touch", 71204)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Touch", 71204)
	self:Death("Win", 36855)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])
	self:Yell("Deformed", L["deformed_yell"])
end

local handle_Adds = nil
local function adds()
	mod:DelayedMessage("adds", 55, L["adds_warning"], "Attention")
	mod:Bar("adds", L["adds_bar"], 60, 70768)
	handle_Adds = mod:ScheduleTimer(adds, 60)
end

function mod:OnEngage()
	self:Berserk(600, true)

	self:DelayedMessage("adds", 62, L["adds_warning"], "Attention")
	self:Bar("adds", L["adds_bar"], 67, 70768)
	handle_Adds = self:ScheduleTimer(adds, 67)
end


--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:DnD(player, spellId)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(71001, L["dnd_message"], "Personal", spellId, "Alarm")
		self:FlashShake(71001)
	end
end

function mod:Barrier(_, spellId)
	self:CancelDelayedMessage(L["adds_warning"])
	self:CancelTimer(handle_Adds, true)
	self:SendMessage("BigWigs_StopBar", self, L["adds_bar"])
	self:Message(70842, L["phase2_message"], "Positive", spellId, "Info")
end

function mod:DominateMind(player, spellId, _, _, spellName)
	self:TargetMessage(71289, spellName, player, "Important", spellId, "Alert")
	self:PrimaryIcon(71289, player, "icon")
end

function mod:Touch(player, spellId, _, _, _, stack)
	if stack and stack > 1 then
		self:TargetMessage(71204, L["touch_message"], player, "Urgent", spellId, nil, stack)
	end
	self:Bar(71204, L["touch_bar"], 7, spellId)
end

function mod:Deformed()
	self:Message("adds", L["deformed_fanatic"], "Urgent", 70674)
end

