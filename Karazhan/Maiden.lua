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
	engage_message = "Maiden Engaged!",

	repentance_trigger = "Cast out your corrupt thoughts.",
	repentance_message = "Repentance!",
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
	engage_message = "Maid angegriffen!",

	repentance_trigger = "L\195\182st Euch von Euren verdorbenen Gedanken!",
	repentance_message = "Bu\195\159e!",
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
	if msg:find(L["engage_trigger"]) and self.db.profile.engage then
		self:TriggerEvent("BigWigs_Message", L["engage_message"], "Attention")
	elseif msg:find(L["repentance_trigger"]) and self.db.profile.repentance then
		self:TriggerEvent("BigWigs_Message", L["repentance_message"], "Important")
		self:ScheduleEvent("BigWigs_Message", 30, L["repentance_warning"], "Urgent", nil, "Alarm")
		self:TriggerEvent("BigWigs_StartBar", self, L["repentance_message"], 33, "Interface\\Icons\\Spell_Holy_PrayerOfHealing")
	end
end
