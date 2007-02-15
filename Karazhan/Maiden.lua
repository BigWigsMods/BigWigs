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
	engage_name = "Engage",
	engage_desc = "Alert when the Maiden of Virtue is engaged",

	repentance_cmd = "repentance",
	repentance_name = "Repentance",
	repentance_desc = "Estimated timer of Repentance",

	holyfire_cmd = "holyfire",
	holyfire_name = "Holy Fire",
	holyfire_desc = "Alert when people are afflicted by Holy Fire",

	icon_cmd = "icon",
	icon_name = "Icon",
	icon_desc = "Place a Raid Icon on the player afflicted by Holy Fire(requires promoted or higher)",

	engage_trigger = "Your behavior will not be tolerated.",
	engage_message = "Maiden Engaged! Repentance in ~33sec",

	repentance_trigger1 = "Cast out your corrupt thoughts.",
	repentance_trigger2 = "Your impurity must be cleansed.",
	repentance_message = "Repentance! Next in ~33sec",
	repentance_warning = "Repentance Soon!",
	repentance_bar = "Repentance",
	repentance_nextbar = "Next Repentance",

	holyfire_trigger = "^([^%s]+) ([^%s]+) afflicted by Holy Fire",
	holyfire_message = "Holy Fire: %s",

	you = "You",
} end)

L:RegisterTranslations("deDE", function() return {
	engage_name = "Engage",
	engage_desc = "Alarm wenn Tugendhafte Maid angegriffen wird.",

	repentance_name = "Alarm f\195\188r Bu\195\159e",
	repentance_desc = "Ungef\195\164re Zeitangabe von Bu\195\159e",

	engage_trigger = "Euer Verhalten wird nicht toleriert.",
	engage_message = "Maid angegriffen! Bu\195\159e in ~33sek.",

	repentance_trigger1 = "L\195\182st Euch von Euren verdorbenen Gedanken!",
	repentance_trigger2 = "Eure Unreinheit muss gel\195\164utert werden.",
	repentance_message = "Bu\195\159e! N\195\164chster in ~33sek",
	repentance_warning = "Bu\195\159e kommt.",

	holyfire_name = "Alarm f\195\188r Heiliges Feuer",
	holyfire_desc = "Warnt wenn Personen von Heiliges Feuer betroffen sind",

	holyfire_trigger = "^([^%s]+) ([^%s]+) von Heiliges Feuer betroffen.",
	holyfire_message = "Heiliges Feuer: %s",

	you = "Ihr",
} end)

----------------------------------
--   Module Declaration    --
----------------------------------

BigWigsMaiden = BigWigs:NewModule(boss)
BigWigsMaiden.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
BigWigsMaiden.enabletrigger = boss
BigWigsMaiden.toggleoptions = {"engage", "repentance", -1, "holyfire", "icon", "bosskill"}
BigWigsMaiden.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMaiden:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "HolyFireEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "HolyFireEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "HolyFireEvent")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MaidenHolyFire", 3)
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

function BigWigsMaiden:HolyFireEvent(msg)
	local bplayer, btype = select(3, msg:find(L["holyfire_trigger"]))
	if bplayer then
		if bplayer == L["you"] then
			bplayer = UnitName("player")
		end
		self:Sync("MaidenHolyFire "..bplayer)
	end
end

function BigWigsMaiden:NextRepentance()
	self:DelayedMessage(28, L["repentance_warning"], "Urgent", nil, "Alarm")
	self:Bar(L["repentance_nextbar"], 33, "Spell_Holy_PrayerOfHealing")
	self:Bar(L["repentance_bar"], 8, "Spell_Holy_PrayerOfHealing")
end

function BigWigsMaiden:BigWigs_RecvSync( sync, rest, nick )
	if sync == "MaidenHolyFire" and rest and self.db.profile.holyfire then
		self:Message(L["holyfire_message"]:format(rest), "Important")
	end
	if self.db.profile.icon then
		self:SetRaidIcon(rest)
	end
end
