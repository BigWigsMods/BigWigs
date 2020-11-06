--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Grobbulus", 533)
if not mod then return end
mod:RegisterEnableMob(15931)
mod:SetAllowWin(true)
mod.engageId = 1111
mod.toggleOptions = {{28169, "WHISPER", "ICON", "FLASHSHAKE"}, 28240, "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.bossName = "Grobbulus"

	L.bomb_message = "Injection"
	L.bomb_message_other = "%s is Injected!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

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

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Inject(player, spellId)
	self:TargetMessage(28169, L["bomb_message"], player, "Personal", spellId, "Alert")
	if UnitIsUnit(player, "player") then self:FlashShake(28169) end
	self:Whisper(28169, player, L["bomb_message"])
	self:Bar(28169, L["bomb_message_other"]:format(player), 10, spellId)
	self:PrimaryIcon(28169, player)
end

function mod:Cloud(_, spellId, _, _, spellName)
	self:Message(28240, spellName, "Attention", spellId)
	self:Bar(28240, spellName, 15, spellId)
end

