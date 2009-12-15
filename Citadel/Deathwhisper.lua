--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Lady Deathwhisper", "Icecrown Citadel")
if not mod then return end
--Deathwhisper, Cult Adherent, Reanimated Adherent, Cult Fanatic, Reanimated Fanatic, Deformed Fanatic
mod:RegisterEnableMob(36855, 37949, 38010, 37890, 38009, 38135)
mod.toggleOptions = {"adds", {71289, "ICON"}, 70842, {71001, "FLASHSHAKE"}, "berserk", "bosskill"}

--------------------------------------------------------------------------------
--  Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.dnd_message = "Death and Decay on YOU!"
	L.phase2_message = "Barrier DOWN - Phase 2!"
	L.engage_trigger = "What is this disturbance?"

	L.adds = "Adds"
	L.adds_desc = "Show timers for when the adds spawn."
	L.adds_bar = "Next Adds"
	L.adds_warning = "New adds in 5 sec!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "DnD", 71001)
	self:Log("SPELL_AURA_REMOVED", "Barrier", 70842)
	self:Log("SPELL_AURA_APPLIED", "DominateMind", 71289)
	self:Death("Win", 36855)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])
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
-- Event handlers
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

