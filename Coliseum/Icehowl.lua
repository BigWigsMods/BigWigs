--------------------------------------------------------------------------------
-- Module Declaration
--

local boss = BB["Icehowl"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Trial of the Crusader"]	--need the add name translated, maybe add to BabbleZone.
mod.otherMenu = "The Argent Coliseum"
mod.enabletrigger = boss
mod.guid = 34797
mod.toggleoptions = {"bosskill"}

--------------------------------------------------------------------------------
-- Locals
--
local db
local pName = UnitName("player")

--------------------------------------------------------------------------------
-- Localization
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	cmd = "Icehowl",
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
	
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	db = self.db.profile
end

--------------------------------------------------------------------------------
-- Event Handlers
--


