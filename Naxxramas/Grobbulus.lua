----------------------------------
--      Module Declaration      --
----------------------------------
local mod = BigWigs:NewBoss("Grobbulus", "Naxxramas")
if not mod then return end
mod:RegisterEnableMob(15931)
mod.toggleOptions = {{28169, "WHISPER", "ICON", "FLASHSHAKE"}, 28240, "berserk", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Grobbulus", "enUS", true)
if L then
	L.bomb_message = "Injection"
	L.bomb_message_other = "%s is Injected!"

	L.icon = "Place Icon"
	L.icon_desc = "Place a raid icon on an Injected person. (Requires promoted or higher)"
end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Grobbulus")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Inject", 28169)
	self:Log("SPELL_CAST_SUCCESS", "Cloud", 28240)
	self:Death("Win", 15931)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	self:Berserk(540)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Inject(player, spellId)
	self:TargetMessage(28169, L["bomb_message"], player, "Personal", spellId, "Alert")
	if player == pName then self:FlashShake(28169) end
	self:Whisper(28169, player, L["bomb_message"])
	self:Bar(28169, L["bomb_message_other"]:format(player), 10, spellId)
	self:PrimaryIcon(28169, player, "icon")
end

function mod:Cloud(_, spellId, _, _, spellName)
	self:Message(28240, spellName, "Attention", spellId)
	self:Bar(28240, spellName, 15, spellId)
end

