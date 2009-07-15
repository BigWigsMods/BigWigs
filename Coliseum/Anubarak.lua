--------------------------------------------------------------------------------
-- Module Declaration
--
local boss = BB["Anub'arak"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["The Argent Coliseum"]
mod.enabletrigger = boss
mod.guid = 34564
mod.toggleoptions = {"bosskill", "burrow", "pursue", "phase"}

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
	burrow_emote = "FIXME",
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
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	self:AddCombatListener("SPELL_AURA_APPLIED", "Pursue", 67574)
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	db = self.db.profile
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Pursue(unit)
	if db.pursue then
		if unit == "player" then
			self:IfMessage(L["pursue_message"], "Important")
		else
			self:IfMessage(L["pursue_other"], "Attention")
		end
	end
end

function mod:UNIT_HEALTH(unit)
	if db.phase then
		if UnitName(unit) == boss then
			if UnitHealth(unit) < 30 and phase ~= 2 then
				self:IfMessage(L["phase_message"], "Positive")
			elseif phase ==2 then
				phase = 1
			end
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then
		phase = 1
		if db.burrow then
			--self:Bar(L["burrow_cooldown"], 90, 67322)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if db.burrow then
		if msg:find(L["burrow_emote"]) then
			--self:IfMessage(L["burrow"])	
			--self:Bar(L["burrow"], 30, 67322)
			--self:Bar(L["burrow_cooldown"], 90, 67322)
		end
	end
end
