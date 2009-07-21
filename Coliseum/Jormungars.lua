--------------------------------------------------------------------------------
-- Module Declaration
--

local acidmaw = BB["Acidmaw"]
local dreadscale = BB["Dreadscale"]
local boss = BB["Jormungars"]	--need the add name translated, maybe add to BabbleBoss.
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Trial of the Crusader"]	--need the add name translated, maybe add to BabbleZone.
mod.otherMenu = "The Argent Coliseum"
mod.enabletrigger = { acidmaw, dreadscale }
mod.guid = 34799--Dreadscale, 35144 = Acidmaw
mod.toggleoptions = {"bosskill"}

--------------------------------------------------------------------------------
-- Locals
--
local db = nil
local deaths = 0
local pName = UnitName("player")
local fmt = string.format

--------------------------------------------------------------------------------
-- Localization
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	cmd = "Jormungars",
	
	enrage = "Enrage",
	enrage_desc = "Warn for Enrage.",
	enrage_message = "Enrage!",
	
	jormungars_dies = "%s dead",
} end)
L:RegisterTranslations("koKR", function() return {
	enrage = "격노",
	enrage_desc = "격노를 알립니다.",
	enrage_message = "격노!",
	
	jormungars_dies = "%s 죽음",
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
	self:AddCombatListener("SPELL_AURA_APPLIED", "Enraged", 68335)
	self:AddCombatListener("UNIT_DIED", "Deaths")
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	db = self.db.profile
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Enraged(_, spellID)
	if db.enrage then
		self:IfMessage(L["enrage_message"], "Attention", spellID, "Alarm")
	end
end

function mod:Deaths(unit, guid)
	guid = tonumber((guid):sub(-12,-7),16)
	if guid == self.guid or guid == 35144 then
		deaths = deaths + 1
		if deaths < 2 then
			self:IfMessage(L["jormungars_dies"]:format(unit), "Positive")
		end
	end
	if deaths == 2 then
		self:BossDeath(nil, self.guid)
	end
end
