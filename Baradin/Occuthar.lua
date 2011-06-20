if tonumber((select(4, GetBuildInfo()))) < 40200 then return end
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
	L.destruction_bar = "Explosion incoming"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {96913, {96920, "FLASHSHAKE"}, 96883, "berserk", "bosskill"}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "SearingShadows", 96913)
	self:Log("SPELL_CAST_START", "Eyes", 96920)
	self:Log("SPELL_CAST_SUCCESS", "FocusedFire", 96882, 96883, 96884) -- XXX It's just one of them, confirm.

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 52363)
end

function mod:OnEngage()
	self:Berserk(300) -- XXX guestimate
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SearingShadows(_, spellId, _, _, spellName)
	self:Message(96913, spellName, "Important", spellId)
	self:Bar(96913, spellName, 30, spellId) -- XXX guestimate
end

function mod:Eyes(_, spellId, _, _, spellName)
	self:Message(96920, spellName, "Urgent", spellId, "Alert")
	self:FlashShake(96920)
	self:Bar(96920, L["destruction_bar"], 10, 96968) -- 96968 is Occu'thar's Destruction
end

function mod:FocusedFire(_, spellId, _, _, spellName)
	self:Message(96883, spellName, "Important", spellId)
end

