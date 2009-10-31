if not QueryQuestsCompleted then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Valithria Dreamwalker", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36789)
mod.toggleOptions = {"bosskill"}

local boss = "Valithria Dreamwalker"

--------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Valithria Dreamwalker", "enUS", true)
if L then

end
local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Valithria Dreamwalker")
mod.locale = L

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	boss = BigWigs:Translate(boss)
end

function mod:OnBossEnable()

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 36789)
end

--------------------------------------------------------------------------------
-- Event Handlers
--