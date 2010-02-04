--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Valithria Dreamwalker", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36789, 37868, 36791, 37934, 37886, 37950, 37985)
mod.toggleOptions = {71730, {71741, "FLASHSHAKE"}, "suppresser", "portal", "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "Intruders have breached the inner sanctum. Hasten the destruction of the green dragon!"

	L.portal = "Nightmare Portals"
	L.portal_desc = "Warns when Valithria opens portals."
	L.portal_message = "Portals up!"
	L.portal_trigger = "I have opened a portal into the Dream. Your salvation lies within, heroes..."
	L.portal_bar = "Next Portal"

	L.manavoid_message = "Mana Void on YOU!"

	L.suppresser = "Suppressers spawn"
	L.suppresser_desc = "Warns when a pack of Suppressers spawn."
	L.suppresser_message = "~Suppressers"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "ManaVoid", 71741, 71743)
	self:Log("SPELL_AURA_APPLIED", "LayWaste", 69325, 71730) -- 10man, ??
	self:Log("SPELL_AURA_REMOVED", "LayWasteRemoved", 69325, 71730) -- 10man, ??
	self:Log("SPELL_CAST_START", "Win", 71189)

	self:Yell("Portal", L["portal_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])
end

local function adds()
	--XXX more testing
	mod:Bar("suppresser", L["suppresser_message"], 58, 70588)
	mod:ScheduleTimer(adds, 58)
end

function mod:OnEngage()
	--self:Berserk(420, true)
	self:Bar("suppresser", L["suppresser_message"], 29, 70588)
	self:Bar("portal", L["portal_bar"], 46, 72482)
	self:ScheduleTimer(adds, 29)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:LayWaste(_, spellId, _, _, spellName)
	self:Message(71730, spellName, "Attention", spellId)
	self:Bar(71730, spellName, 12, spellId)
end

function mod:LayWasteRemoved(_, _, _, _, spellName)
	self:SendMessage("BigWigs_StopBar", self, spellName)
end

function mod:Portal()
	self:Message("portal", L["portal_message"], "Important")
	self:Bar("portal", L["portal_bar"], 46, 72482)
end

function mod:ManaVoid(player, spellId)
	if UnitIsUnit(player, "player") then
		self:LocalMessage(71741, L["manavoid_message"], "Personal", spellId, "Alarm")
		self:FlashShake(71741)
	end
end

