------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Firemaw")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	wingbuffet_trigger = "Firemaw begins to cast Wing Buffet",
	shadowflame_trigger = "Firemaw begins to cast Shadow Flame.",

	wingbuffet_message = "Wing Buffet! 30sec to next!",
	wingbuffet_warning = "3sec to Wing Buffet!",
	shadowflame_warning = "Shadow Flame Incoming!",

	wingbuffet_bar = "Wing Buffet",

	cmd = "Firemaw",

	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Wing Buffet alert",
	wingbuffet_desc = "Warn for Wing Buffet",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn for Shadow Flame",
} end)

L:RegisterTranslations("zhCN", function() return {
	wingbuffet_trigger = "费尔默开始施放龙翼打击。",
	shadowflame_trigger = "费尔默开始施放暗影烈焰。",

	wingbuffet_warning = "3秒后发动龙翼打击！",
	shadowflame_warning = "暗影烈焰发动！",

	wingbuffet_bar = "龙翼打击",

	wingbuffet_name = "龙翼打击警报",
	wingbuffet_desc = "龙翼打击警报",

	shadowflame_name = "暗影烈焰警报",
	shadowflame_desc = "暗影烈焰警报",
} end)


L:RegisterTranslations("koKR", function() return {
	wingbuffet_trigger = "화염아귀|1이;가; 폭풍 날개|1을;를; 시전합니다.",
	shadowflame_trigger = "화염아귀|1이;가; 암흑의 불길|1을;를; 시전합니다.",

	wingbuffet_message = "폭풍 날개! 다음은 30초 후!",
	wingbuffet_warning = "3초 후 폭풍 날개!",
	shadowflame_warning = "암흑 불길 경고!",

	wingbuffet_bar = "폭풍 날개",
	
	wingbuffet_name = "폭풍 날개 경고",
	wingbuffet_desc = "폭풍 날개에 대한 경고",
	
	shadowflame_name = "암흑의 불길 경고",
	shadowflame_desc = "암흑의 불길에 대한 경고",
} end)

L:RegisterTranslations("deDE", function() return {
	wingbuffet_trigger = "Feuerschwinge beginnt Fl\195\188gelsto\195\159 zu wirken.",
	shadowflame_trigger = "Feuerschwinge beginnt Schattenflamme zu wirken.",

	wingbuffet_warning = "3 Sekunden bis Fl\195\188gelsto\195\159!",
	shadowflame_warning = "Schattenflamme in K\195\188rze!",

	wingbuffet_bar = "Fl\195\188gelsto\195\159",

	wingbuffet_name = "Fl\195\188gelsto\195\159",
	wingbuffet_desc = "Warnung, wenn Feuerschwinge Fl\195\188gelsto\195\159 wirkt.",

	shadowflame_name = "Schattenflamme",
	shadowflame_desc = "Warnung, wenn Feuerschwinge Schattenflamme wirkt.",
} end)

L:RegisterTranslations("frFR", function() return {
	wingbuffet_trigger = "Gueule-de-feu commence \195\160 lancer Frappe des ailes.",
	shadowflame_trigger = "Gueule-de-feu commence \195\160 lancer Flamme d'ombre.",

	wingbuffet_warning = "3 sec avant prochain Frappe des ailes!",
	shadowflame_warning = "Flamme d'ombre imminente!",

} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsFiremaw = BigWigs:NewModule(boss)
BigWigsFiremaw.zonename = AceLibrary("Babble-Zone-2.0")("Blackwing Lair")
BigWigsFiremaw.enabletrigger = boss
BigWigsFiremaw.toggleoptions = {"wingbuffet", "shadowflame", "bosskill"}
BigWigsFiremaw.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsFiremaw:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "FiremawWingBuffet2", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "FiremawShadowflame", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsFiremaw:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["wingbuffet_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "FiremawWingBuffet2")
	elseif msg == L["shadowflame_trigger"] then 
		self:TriggerEvent("BigWigs_SendSync", "FiremawShadowflame")
	end
end

function BigWigsFiremaw:BigWigs_RecvSync(sync)
	if sync == "FiremawWingBuffet2" and self.db.profile.wingbuffet then
		self:TriggerEvent("BigWigs_Message", L["wingbuffet_message"], "Red")
		self:ScheduleEvent("BigWigs_Message", 29, L["wingbuffet_warning"], "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L["wingbuffet_bar"], 32, "Interface\\Icons\\Spell_Fire_SelfDestruct", "Yellow", "Orange", "Red")
	elseif sync == "FiremawShadowflame" and self.db.profile.shadowflame then
		self:TriggerEvent("BigWigs_Message", L["shadowflame_warning"], "Red")
	end
end

