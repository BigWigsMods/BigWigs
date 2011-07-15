--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Occu'thar", 752, 140)
if not mod then return end
mod:RegisterEnableMob(52363)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.shadows_bar = "~Searing Shadows"
	L.destruction_bar = "Explosion incoming"
	L.eyes_bar = "~Next Eyes"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {96913, {96920, "FLASHSHAKE"}, 96884, "berserk", "bosskill"}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "SearingShadows", 96913, 101007) -- EJ/10m, 25m
	self:Log("SPELL_CAST_START", "Eyes", 96920, 101006) -- EJ/10m, 25m
	self:Log("SPELL_CAST_SUCCESS", "FocusedFire", 96884) -- EJ/10m/25m

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 52363)
end

function mod:OnEngage()
	self:Bar(96920, L["eyes_bar"], 25, 96920)
	self:Berserk(300) -- XXX guestimate
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SearingShadows(_, spellId, _, _, spellName)
	self:Message(96913, spellName, "Important", spellId)
	self:Bar(96913, L["shadows_bar"], 23, spellId)
end

function mod:Eyes(_, spellId, _, _, spellName)
	self:FlashShake(96920)
	self:Message(96920, spellName, "Urgent", spellId, "Alert")
	self:Bar(96920, L["destruction_bar"], 10, 96968) -- 96968 is Occu'thar's Destruction
	self:Bar(96920, L["eyes_bar"], 58, spellId)
end

function mod:FocusedFire(_, spellId, _, _, spellName)
	self:Message(96884, spellName, "Attention", spellId)
end

