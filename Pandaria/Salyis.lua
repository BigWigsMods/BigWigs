
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Salyis's Warband", 807, 725)
if not mod then return end
mod:RegisterEnableMob(62346)
mod.otherMenu = 6

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.adds, L.adds_desc = EJ_GetSectionInfo(6200)
	L.adds_icon = 121747
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		121600, 121787, "adds",
		"bosskill",
	}
end

function mod:OnBossEnable()
	self:Emote("spell:121600", "CannonBarrage")
	self:Emote("spell:121787", "Stomp")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 62346) --Galleon
end

function mod:OnEngage()
	self:Bar(121600, 121600, 24, spellId) -- Cannon Barrage
	self:Bar(121787, 121787, 50, spellId) -- Stomp
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CannonBarrage(_, spellId, _, _, spellName)
	self:Message(spellId, CL["soon"]:format(spellName), "Important", spellId, self:Tank() and "Info" or nil)
	self:Bar(spellId, spellName, 60, spellId)
end

function mod:Stomp(_, spellId, _, _, spellName)
	self:Message(spellId, CL["soon"]:format(spellName), "Important", spellId, "Alarm")
	self:Bar(spellId, spellName, 60, spellId)
	self:DelayedMessage("adds", 10, L["adds"], "Attention", L.adds_icon)
end

