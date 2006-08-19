------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Firemaw")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	trigger1 = "Firemaw begins to cast Wing Buffet",
	trigger2 = "Firemaw begins to cast Shadow Flame.",

	warn1 = "Firemaw begins to cast Wing Buffet!",
	warn2 = "30 seconds till next Wing Buffet!",
	warn3 = "3 seconds before Firemaw casts Wing Buffet!",
	warn4 = "Shadow Flame Incoming!",

	bar1text = "Wing Buffet",

	cmd = "Firemaw",
	
	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Wing Buffet alert",
	wingbuffet_desc = "Warn for Wing Buffet",
	
	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn for Shadow Flame",
} end)

L:RegisterTranslations("zhCN", function() return {
	trigger1 = "费尔默开始施放龙翼打击。",
	trigger2 = "费尔默开始施放暗影烈焰。",

	warn1 = "费尔默开始施放龙翼打击！",
	warn2 = "龙翼打击 - 30秒后再次发动",
	warn3 = "3秒后发动龙翼打击！",
	warn4 = "暗影烈焰发动！",

	bar1text = "龙翼打击",
	
	wingbuffet_name = "龙翼打击警报",
	wingbuffet_desc = "龙翼打击警报",
	
	shadowflame_name = "暗影烈焰警报",
	shadowflame_desc = "暗影烈焰警报",
} end)


L:RegisterTranslations("koKR", function() return {
	trigger1 = "화염아귀|1이;가; 폭풍 날개|1을;를; 시전합니다.",
	trigger2 = "화염아귀|1이;가; 암흑의 불길|1을;를; 시전합니다.",

	warn1 = "화염 아귀가 폭풍 날개를 시전합니다!",
	warn2 = "30초후 다음 폭풍 날개!",
	warn3 = "3초 후 폭풍 날개!",
	warn4 = "암흑 불길 경고!",

	bar1text = "폭풍 날개",
} end)

L:RegisterTranslations("deDE", function() return {
	trigger1 = "Feuerschwinge beginnt Fl\195\188gelsto\195\159 zu wirken.",
	trigger2 = "Feuerschwinge beginnt Schattenflamme zu wirken.",

	warn1 = "Fl\195\188gelsto\195\159!",
	warn2 = "30 Sekunden bis zum n\195\164chsten Fl\195\188gelsto\195\159!",
	warn3 = "3 Sekunden bis Fl\195\188gelsto\195\159!",
	warn4 = "Schattenflamme in K\195\188rze!",

	bar1text = "Fl\195\188gelsto\195\159",

	cmd = "Firemaw",
	
	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Fl\195\188gelsto\195\159",
	wingbuffet_desc = "Warnung, wenn Feuerschwinge Fl\195\188gelsto\195\159 wirkt.",
	
	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Schattenflamme",
	shadowflame_desc = "Warnung, wenn Feuerschwinge Schattenflamme wirkt.",
} end)

L:RegisterTranslations("frFR", function() return {
	trigger1 = "Gueule-de-feu commence \195\160 lancer Frappe des ailes.",
	trigger2 = "Gueule-de-feu commence \195\160 lancer Flamme d'ombre.",

	warn1 = "Gueule-de-feu commence \195\160 lancer Frappe des ailes!",
	warn2 = "30 sec avant prochain Frappe des ailes!",
	warn3 = "3 sec avant prochain Frappe des ailes!",
	warn4 = "Flamme d'ombre imminente!",

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
	self:TriggerEvent("BigWigs_ThrottleSync", "FiremawWingBuffet", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "FiremawShadowflame", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsFiremaw:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if (string.find(msg, L"trigger1")) then
		self:TriggerEvent("BigWigs_SendSync", "FiremawWingBuffet")
	elseif msg == L"trigger2" then 
		self:TriggerEvent("BigWigs_SendSync", "FiremawShadowflame")
	end
end

function BigWigsFiremaw:BigWigs_RecvSync(sync)
	if sync == "FiremawWingBuffet" and self.db.profile.wingbuffet then
		self:TriggerEvent("BigWigs_Message", L"warn1", "Red")
		self:TriggerEvent("BigWigs_Message", L"warn2", "Yellow")
		self:ScheduleEvent("BigWigs_Message", 29, L"warn3", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"bar1text", 32, "Interface\\Icons\\Spell_Fire_SelfDestruct", "Yellow", "Orange", "Red")
	elseif sync == "FiremawShadowflame" and self.db.profile.shadowflame then
		self:TriggerEvent("BigWigs_Message", L"warn4", "Red")
	end
end
