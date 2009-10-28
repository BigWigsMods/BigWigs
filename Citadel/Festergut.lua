--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Festergut", "Icecrown Citadel")
if not mod then return end

mod:RegisterEnableMob(36626)
mod.toggleOptions = {"berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Lord Marrowgar", "enUS", true)
if L then

end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Lord Marrowgar")
mod.locale = L

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Death("Win", 36612)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	self:Berserk(300, true)
end

