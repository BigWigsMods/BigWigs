if not QueryQuestsCompleted then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Valithria Dreamwalker", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36789, 37868, 36791, 37934, 37886, 37950, 37985)
mod.toggleOptions = {71730, 71733, {71741, "FLASHSHAKE"}, "portal", "bosskill"}
--68168 lay waste (buff)
-- 71733 Acid Burst
--  71741 Manavoid

--------------------------------------------------------------------------------
-- Locals
--

local pName = UnitName("player")
--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.manavoid_message = "Mana Void on YOU!"
	L.portal = "Nightmare Portal"
	L.portal_desc = "Warns when Valithria opens a Portal."
	L.portal_message = "Portal up!"
	L.portal_trigger = "I have opened a portal into the Dream. Your salvation lies within, heroes..."
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "ManaVoid", 71741, 71743)
	self:Log("SPELL_CAST_SUCCESS", "LayWaste", 71730)
	self:Log("SPELL_CAST_START", "AcidBurst", 71733)
	self:Log("SPELL_CAST_START", "Win", 71189)

	self:Yell("Portal", L["portal_trigger"])
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:LayWaste(_, spellId, _, _, spellName)
	self:Message(71730, spellName, "Attention", spellId)
	self:Bar(71730, spellName, 12, spellId)
end

function mod:Portal()
	self:Message("portal", L["portal_message"], "Important")
end

function mod:AcidBurst(_, spellId, _, _, spellName)
	self:Message(71733, spellName, "Attention", spellId)
	self:Bar(71733, spellName, 20, spellId)
end

function mod:ManaVoid(player, spellId)
	if player == pName then
		self:LocalMessage(71741, L["manavoid_message"], "Personal", spellId, "Alarm")
		self:FlashShake(71741)
	end
end
