--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Occu'thar", 752, 140)
if not mod then return end
mod:RegisterEnableMob(52363)

local fireCount = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.shadows_bar = "~Shadows"
	L.destruction_bar = "<Explosion>"
	L.eyes_bar = "~Eyes"

	L.fire_message = "Lazer, Pew Pew"
	L.fire_bar = "~Lazer"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {96913, {96920, "FLASHSHAKE"}, 96884, "berserk", "bosskill"}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "SearingShadows", 96913, 101007) -- EJ/10m, 25m
	self:Log("SPELL_CAST_START", "Eyes", 96920, 101006) -- EJ/10m, 25m
	self:Log("SPELL_CAST_SUCCESS", "FocusedFire", 96884) -- EJ/10m/25m

	--No CheckBossStatus() here as event does not fire.
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 52363)
end

function mod:OnEngage()
	self:Bar(96920, L["eyes_bar"], 25, 96920)
	self:Bar(96884, L["fire_bar"], 13.1, 96884)
	self:Bar(96913, L["shadows_bar"], 6.5, 96913)
	fireCount = 3
	self:Berserk(300)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SearingShadows(player, spellId, _, _, spellName)
	self:TargetMessage(96913, spellName, player, "Important", spellId)
	self:Bar(96913, L["shadows_bar"], 24, spellId) --23-26
end

function mod:Eyes(_, spellId, _, _, spellName)
	self:FlashShake(96920)
	self:Message(96920, spellName, "Urgent", spellId, "Alert")
	self:Bar(96920, L["destruction_bar"], 10, 96968) -- 96968 is Occu'thar's Destruction
	self:Bar(96920, L["eyes_bar"], 58, spellId)
	fireCount = 0
	self:Bar(96884, L["fire_bar"], 18.5, spellId) --18.5-19.2
end

function mod:FocusedFire(_, spellId, _, _, spellName)
	self:Message(96884, L["fire_message"], "Attention", spellId)
	fireCount = fireCount + 1
	if fireCount < 3 then
		self:Bar(96884, L["fire_bar"], 15.7, spellId) --15.5-16
	end
end

