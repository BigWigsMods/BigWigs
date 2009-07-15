--------------------------------------------------------------------------------
-- Module Declaration
--
local boss = BB["Anub'arak"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["The Argent Coliseum"]
mod.enabletrigger = boss
--mod.guid = -1
mod.toggleoptions = {"bosskill", "burrow", "pursue"}

--------------------------------------------------------------------------------
-- Locals
--

local db
local phase

--------------------------------------------------------------------------------
-- Localization
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	cmd = "Anubarak",

	engage = "Engage",
	engage_trigger = "This place will serve as your tomb!",

	phase = "Phase",
	phase_desc = "Warn on phase transitions",
	phase_message = "Phase 2!",

	burrow = "Burrow",
	burrow_desc = "Show a timer for Anub'Arak's Burrow ability",
	burrow_message = "Burrow",
	burrow_cooldown = "Next Burrow",

	pursue = "Pursue",
	pursue_desc = "Show who Anub'Arak is pursuing",
	pursue_message = "Pursuing YOU!",
	pursue_other = "Pursuing %s",

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
	
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	db = self.db.profile
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(unit)
	if not db.phase then return end
	if UnitName(unit) == boss then
		if UnitHealth(unit) < 30 and phase ~= 2 then
			self:IfMessage(L["phase_message"], "Positive")
		elseif phase ==2 then
			phase = 1
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then
		phase = 1
	end
end

