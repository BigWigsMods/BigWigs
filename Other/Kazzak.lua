------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Lord Kazzak"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local supremetime = 180

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Kazzak",

	supreme_cmd = "supreme",
	supreme_name = "Supreme Alert",
	supreme_desc = "Warn for Supreme Mode",

	starttrigger = "For the Legion! For Kil'Jaeden!",

	engagewarn	 = "Lord Kazzak engaged, 3mins until Supreme!",

	supreme1min	 = "Supreme mode in 1 minute!",
	supreme30sec = "Supreme mode in 30 seconds!",
	supreme10sec = "Supreme mode in 10 seconds!",

	bartext = "Supreme mode",
} end )

L:RegisterTranslations("deDE", function() return {
	supreme_name = "Supreme Mode",
	supreme_desc = "Warnung vor Supreme Mode.",

	starttrigger = "F\195\188r die Legion! F\195\188r Kil'jaeden!",

	engagewarn	 = "Lord Kazzak angegriffen! Supreme Mode in 3 Minuten!",

	supreme1min  = "Supreme Mode in 1 Minute!",
	supreme30sec = "Supreme Mode in 30 Sekunden!",
	supreme10sec = "Supreme Mode in 10 Sekunden!",

	bartext = "Supreme Mode",
} end )

L:RegisterTranslations("zhCN", function() return {
	supreme_name = "无敌警报",
	supreme_desc = "无敌警报",

	starttrigger = "为了燃烧军团！为了基尔加丹！",

	engagewarn	 = "卡扎克已激活 - 3分钟后无敌！",

	supreme1min	 = "1分钟后无敌！",
	supreme30sec = "30秒后无敌！",
	supreme10sec = "10秒后无敌！",

	bartext = "无敌模式",
} end )

L:RegisterTranslations("koKR", function() return {
	supreme_name = "무적 경고",
	supreme_desc = "무적 모드에 대한 경고",

	starttrigger = "군단을 위하여! 킬제덴을 위하여!", --CHECK

	engagewarn	 = "카쟈크 전투 개시, 3분 후 무적!",

	supreme1min	 = "무적 모드 - 1 분전!",
	supreme30sec = "무적 모드 - 30 초전!",
	supreme10sec = "무적 모드 - 10 초전!",

	bartext = "무적 모드",
} end )

L:RegisterTranslations("frFR", function() return {
	supreme_name = "Alerte Suprême",
	supreme_desc = "Préviens régulièrement de l'approche du mode Suprême.",

	starttrigger = "Pour la Légion ! Pour Kil'Jaeden !",

	engagewarn	 = "Seigneur Kazzak engagé - 3 min. avant Suprême !",

	supreme1min	 = "Mode Suprême dans 1 min. !",
	supreme30sec = "Mode Suprême dans 30 sec. !",
	supreme10sec = "Mode Suprême dans 10 sec. !",

	bartext = "Mode Suprême",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsKazzak = BigWigs:NewModule(boss)
BigWigsKazzak.zonename = { AceLibrary("AceLocale-2.2"):new("BigWigs")["Outdoor Raid Bosses Zone"], AceLibrary("Babble-Zone-2.2")["Blasted Lands"] }
BigWigsKazzak.enabletrigger = boss
BigWigsKazzak.toggleoptions = {"supreme", "bosskill"}
BigWigsKazzak.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsKazzak:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

function BigWigsKazzak:CHAT_MSG_MONSTER_YELL( msg )
	if self.db.profile.supreme and msg == L["starttrigger"] then 
		self:TriggerEvent("BigWigs_Message", L["engagewarn"], "Red")
		self:ScheduleEvent("BigWigs_Message", supremetime - 60, L["supreme1min"], "Attention")
		self:ScheduleEvent("BigWigs_Message", supremetime - 30, L["supreme30sec"], "Urgent")
		self:ScheduleEvent("BigWigs_Message", supremetime - 10, L["supreme10sec"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["bartext"], supremetime, "Interface\\Icons\\Spell_Shadow_ShadowWordPain", "Green", "Yellow", "Orange", "Red")
	end
end

