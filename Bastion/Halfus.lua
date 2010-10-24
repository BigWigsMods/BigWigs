if not GetSpellInfo(90000) then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Halfus Wyrmbreaker", "The Bastion of Twilight")
if not mod then return end
mod:RegisterEnableMob(44600)
mod.toggleOptions = {83709, "bosskill"}
mod.optionHeaders = {
	bosskill = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()

	self:Log("SPELL_AURA_APPLIED", "SpinningSlash", 83709)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 44600)
end


function mod:OnEngage(diff)

end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SpinningSlash(_, spellId, _, _, spellName)
	self:Message(83709, spellName, "Important", spellId, "Alert")
end