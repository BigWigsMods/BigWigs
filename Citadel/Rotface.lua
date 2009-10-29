if not QueryQuestsCompleted then return end
--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Rotface", "Icecrown Citadel")
if not mod then return end

mod:RegisterEnableMob(36627)
mod.toggleOptions = {"bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Rotface", "enUS", true)
if L then

end
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Rotface")
mod.locale = L

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Death("Win", 36627)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end
