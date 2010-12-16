--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Halfus Wyrmbreaker", "The Bastion of Twilight")
if not mod then return end
mod:RegisterEnableMob(44600)
mod.toggleOptions = {86169, "berserk", "bosskill"}
mod.optionHeaders = {
	berserk = "general",
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
	self:Log("SPELL_CAST_START", "FuriousRoar", 86169, 86170)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:Death("Win", 44600)
end


function mod:OnEngage(diff)
	self:Berserk(360)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FuriousRoar(_, spellId, _, _, spellName)
	self:Message(86169, spellName, "Urgent", spellId)
	self:Bar(86169, spellName, 25, 86169)
end

