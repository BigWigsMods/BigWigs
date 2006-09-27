------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Flamegor")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	wingbuffet_trigger = "Flamegor begins to cast Wing Buffet",
	shadowflame_trigger = "Flamegor begins to cast Shadow Flame.",
	frenzy_trigger = "%s goes into a frenzy!",

	wingbuffet_message = "Wing Buffet! 30sec to next!",
	wingbuffet_warning = "3sec to Wing Buffet!",
	shadowflame_warning = "Shadow Flame incoming!",
	frenzy_message = "Frenzy - Tranq Shot!",

	wingbuffet_bar = "Wing Buffet",

	cmd = "Flamegor",

	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Wing Buffet alert",
	wingbuffet_desc = "Warn for Wing Buffet",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn for Shadow Flame",

	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy alert",
	frenzy_desc = "Warn when for frenzy",
} end)

L:RegisterTranslations("zhCN", function() return {
	wingbuffet_trigger = "弗莱格尔开始施放龙翼打击。",
	shadowflame_trigger = "弗莱格尔开始施放暗影烈焰。",
	frenzy_trigger = "变得狂暴起来！",

	wingbuffet_message = "龙翼打击 - 30秒后再次发动",
	wingbuffet_warning = "3秒后发动龙翼打击！",
	shadowflame_warning = "暗影烈焰发动！",
	frenzy_message = "狂暴警报 - 猎人立刻使用宁神射击！",

	wingbuffet_bar = "龙翼打击",

	wingbuffet_name = "龙翼打击警报",
	wingbuffet_desc = "龙翼打击警报",

	shadowflame_name = "暗影烈焰警报",
	shadowflame_desc = "暗影烈焰警报",

	frenzy_name = "狂暴警报",
	frenzy_desc = "狂暴警报",
} end)


L:RegisterTranslations("koKR", function() return {
	wingbuffet_trigger = "플레임고르|1이;가; 폭풍 날개|1을;를; 시전합니다.",
	shadowflame_trigger = "플레임고르|1이;가; 암흑의 불길|1을;를; 시전합니다.",
	frenzy_trigger = "%s|1이;가; 광란의 상태에 빠집니다!",

	wingbuffet_message = "폭풍 날개! 다음은 30초 후!",
	wingbuffet_warning = "3초후 폭풍 날개!",
	shadowflame_warning = "암흑의 불길 경보!",
	frenzy_message = "광란 - 평정 사격!",

	wingbuffet_bar = "폭풍 날개",
	
	wingbuffet_name = "폭풍 날개 경고",
	wingbuffet_desc = "폭풍 날개에 대한 경고",
	
	shadowflame_name = "암흑의 불길 경고",
	shadowflame_desc = "암흑의 불길에 대한 경고",
	
	frenzy_name = "광란 경고",
	frenzy_desc = "광란에 대한 경고",
} end)

L:RegisterTranslations("deDE", function() return {
	wingbuffet_trigger = "Flammenmaul beginnt Fl\195\188gelsto\195\159 zu wirken.",
	shadowflame_trigger = "Flammenmaul beginnt Schattenflamme zu wirken.",
	frenzy_trigger = "%s ger\195\164t in Raserei!",

	wingbuffet_message = "Fl\195\188gelsto\195\159!",
	wingbuffet_warning = "Fl\195\188gelsto\195\159 in 3 Sekunden!",
	shadowflame_warning = "Schattenflamme in K\195\188rze!",
	frenzy_message = "Raserei - Einlullender Schuss!",

	wingbuffet_bar = "Fl\195\188gelsto\195\159",

	wingbuffet_name = "Fl\195\188gelsto\195\159",
	wingbuffet_desc = "Warnung, wenn Flammenmaul Fl\195\188gelsto\195\159 wirkt.",

	shadowflame_name = "Schattenflamme",
	shadowflame_desc = "Warnung, wenn Flammenmaul Schattenflamme wirkt.",

	frenzy_name = "Raserei",
	frenzy_desc = "Warnung, wenn Flammenmaul in Raserei ger\195\164t.",
} end)

L:RegisterTranslations("frFR", function() return {
	wingbuffet_trigger = "Flamegor commence \195\160 lancer Frappe des ailes.",
	shadowflame_trigger = "Flamegor commence \195\160 lancer Flamme d'ombre.",
	frenzy_trigger = "est pris de fr\195\169n\195\169sie !",

	wingbuffet_warning = "3 sec avant prochaine Frappe des ailes!",
	shadowflame_warning = "Flamme d'ombre imminente!",
	frenzy_message = "Frenzy - Tranq Shot!",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsFlamegor = BigWigs:NewModule(boss)
BigWigsFlamegor.zonename = AceLibrary("Babble-Zone-2.0")("Blackwing Lair")
BigWigsFlamegor.enabletrigger = boss
BigWigsFlamegor.toggleoptions = {"wingbuffet", "shadowflame", "frenzy", "bosskill"}
BigWigsFlamegor.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsFlamegor:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "FlamegorWingBuffet2", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "FlamegorShadowflame", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsFlamegor:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["wingbuffet_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "FlamegorWingBuffet2")
	elseif msg == L["shadowflame_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "FlamegorShadowflame")
	end
end

function BigWigsFlamegor:BigWigs_RecvSync(sync)
	if sync == "FlamegorWingBuffet2" and self.db.profile.wingbuffet then
		self:TriggerEvent("BigWigs_Message", L["wingbuffet_message"], "Red")
		self:ScheduleEvent("BigWigs_Message", 29, L["wingbuffet_warning"], "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L["wingbuffet_bar"], 32, "Interface\\Icons\\Spell_Fire_SelfDestruct", "Yellow", "Orange", "Red")
	elseif sync == "FlamegorShadowflame" and self.db.profile.shadowflame then
		self:TriggerEvent("BigWigs_Message", L["shadowflame_warning"], "Red")
	end
end

function BigWigsFlamegor:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["frenzy_trigger"] and self.db.profile.frenzy then
		self:TriggerEvent("BigWigs_Message", L["frenzy_message"], "Red")
	end
end
