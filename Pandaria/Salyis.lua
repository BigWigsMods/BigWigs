
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
	self:Emote("CannonBarrage", "spell:121600")
	self:Emote("Stomp", "spell:121787")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 62346) --Galleon
end

function mod:OnEngage()
	self:Bar(121600, 121600, 24, 121600) -- Cannon Barrage
	self:Bar(121787, 121787, 50, 121787) -- Stomp
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CannonBarrage()
	self:Message(121600, CL["soon"]:format(self:SpellName(121600)), "Urgent", 121600) -- Cannon Barrage
	self:Bar(121600, 121600, 60, 121600) -- Cannon Barrage
end

function mod:Stomp()
	self:Message(121787, CL["soon"]:format(self:SpellName(121787)), "Important", 121787, "Alarm") -- Stomp
	self:Bar(121787, 121787, 60, 121787) -- Stomp
	self:DelayedMessage("adds", 10, L["adds"], "Attention", L.adds_icon)
end

