------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Maiden of Virtue"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization     --
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

	repentance_trigger1 = "Cast out your corrupt thoughts.",
	repentance_trigger2 = "Your impurity must be cleansed.",
	repentance_message = "Repentance! Next in ~33sec",
	repentance_warning = "Repentance Soon!",
} end)

L:RegisterTranslations("deDE", function() return {
	engage_cmd = "engage",
	engage_name = "Engage Warning",
	engage_desc = "Alarm wenn Tugendhafte Maid angegriffen wird.",

	repentance_cmd = "Bu\195\159e",
	repentance_name = "Alarm f\195\188r Bu\195\159e",
	repentance_desc = "Ungef\195\164re Zeitangabe von Bu\195\159e",

	engage_trigger = "Euer Verhalten wird nicht toleriert.",
	engage_message = "Maid angegriffen! Bu\195\159e in ~33sek.",

	repentance_trigger1 = "L\195\182st Euch von Euren verdorbenen Gedanken!",
	repentance_trigger2 = "Eure Unreinheit muss gel\195\164utert werden.",
	repentance_message = "Bu\195\159e! N\195\164chster in ~33sek",
	repentance_warning = "Bu\195\159e kommt.",
} end)

----------------------------------
--   Module Declaration    --
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
--    Event Handlers     --
------------------------------

function BigWigsMaiden:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.engage and msg == L["engage_trigger"] then
		self:Message(L["engage_message"], "Attention")
		self:NextRepentance()
	elseif self.db.profile.repentance and (msg == L["repentance_trigger1"] or msg == L["repentance_trigger2"]) then
		self:Message(L["repentance_message"], "Important")
		self:NextRepentance()
	end
end

function BigWigsMaiden:NextRepentance()
	self:DelayedMessage(L["repentance_warning"], "Urgent", 28, nil, "Alarm")
	self:Bar(self, L["repentance_message"], 33, "Spell_Holy_PrayerOfHealing")
end
