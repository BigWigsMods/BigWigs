------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Maiden of Virtue"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Maiden",

	engage_cmd = "engage",
	engage_name = "Engage Warning",
	engage_desc = "Alert when the Maiden of Virtue is engaged",

	repentance_cmd = "repentance",
	repentance_name = "Repentance Alert",
	repentance_desc = "Estimated timer of Repentance",

	engage_trigger = "Your behavior will not be tolerated.",
	engage_message = "Maiden Engaged! Repentance in ~33sec",

	repentance_trigger = "Cast out your corrupt thoughts.",
	repentance_trigger_2 = "Your impurity must be cleansed.",
	repentance_message = "Repentance! Next in ~33sec",
	repentance_warning = "Repentance Soon!",
} end)

L:RegisterTranslations("deDE", function() return {
	engage_cmd = "engage",
	engage_name = "Engage Warning",
	engage_desc = "Alarm wenn Tugendhafte Maid angegriffen wird.",

	repentance_cmd = "Bu\195\159e",
	repentance_name = "Bu\195\159e Alarm",
	repentance_desc = "Timer von Bu\195\159e",

	engage_trigger = "Euer Verhalten wird nicht toleriert.",
	--engage_message = "Maid angegriffen!", --changed enUS, re-translate

	repentance_trigger = "L\195\182st Euch von Euren verdorbenen Gedanken!",
	--repentance_trigger_2 = "Your impurity must be cleansed.", --translate 2nd repentance yell
	--repentance_message = "Bu\195\159e!", --changed enUS, re-translate
	repentance_warning = "Bu\195\159e kommt",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMaiden = BigWigs:NewModule(boss)
BigWigsMaiden.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsMaiden.enabletrigger = boss
BigWigsMaiden.toggleoptions = {"engage", "repentance", "bosskill"}
BigWigsMaiden.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMaiden:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsMaiden:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.engage and msg == L["engage_trigger"] then
		self:TriggerEvent("BigWigs_Message", L["engage_message"], "Attention")
		self:NextRepentance()
	elseif self.db.profile.repentance and (msg == L["repentance_trigger"] or msg == L["repentance_trigger_2"]) then
		self:TriggerEvent("BigWigs_Message", L["repentance_message"], "Important")
		self:NextRepentance()
	end
end

function BigWigsMaiden:NextRepentance()
	self:ScheduleEvent("BigWigs_Message", 28, L["repentance_warning"], "Urgent", nil, "Alarm")
	self:TriggerEvent("BigWigs_StartBar", self, L["repentance_message"], 33, "Interface\\Icons\\Spell_Holy_PrayerOfHealing")
end
