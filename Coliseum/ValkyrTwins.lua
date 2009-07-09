--------------------------------------------------------------------------------
-- Module Declaration
--

local boss = "Val'kyr Twins"
local edyis = BB["Edyis Darkbane"]
local fjola = BB["Fjola Lightbane"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["The Argent Coliseum"]
mod.enabletrigger = { edyis, fjola }
--mod.guid = -1
mod.toggleoptions = {"bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	cmd = "ValkyrTwins",
} end)
L:RegisterTranslations("koKR", function() return {
} end)
L:RegisterTranslations("frFR", function() return {
} end)
L:RegisterTranslations("deDE", function() return {
} end)
L:RegisterTranslations("zhCN", function() return {
} end)
L:RegisterTranslations("zhTW", function() return {
} end)
L:RegisterTranslations("ruRU", function() return {
} end)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnEnable()
	--self:AddCombatListener("", "", 1)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	
	--self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("")
end

--------------------------------------------------------------------------------
-- Event Handlers
--


