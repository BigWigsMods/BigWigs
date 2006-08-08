------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Flamegor")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	trigger1 = "Flamegor begins to cast Wing Buffet",
	trigger2 = "Flamegor begins to cast Shadow Flame.",
	trigger3 = "goes into a frenzy!",

	warn1 = "Flamegor begins to cast Wing Buffet!",
	warn2 = "30 seconds till next Wing Buffet!",
	warn3 = "3 seconds before Flamegor casts Wing Buffet!",
	warn4 = "Shadow Flame incoming!",
	warn5 = "Frenzy - Tranq Shot!",
	bosskill = "Flamegor has been defeated!",

	bar1text = "Wing Buffet",

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
	trigger1 = "弗莱格尔开始施放龙翼打击。",
	trigger2 = "弗莱格尔开始施放暗影烈焰。",
	trigger3 = "变得狂暴起来！",

	warn1 = "弗莱格尔开始施放龙翼打击！",
	warn2 = "龙翼打击 - 30秒后再次发动",
	warn3 = "3秒后发动龙翼打击！",
	warn4 = "暗影烈焰发动！",
	warn5 = "狂暴警报 - 猎人立刻使用宁神射击！",
	bosskill = "弗莱格尔被击败了！",

	bar1text = "龙翼打击",
	
	wingbuffet_name = "龙翼打击警报",
	wingbuffet_desc = "龙翼打击警报",
	
	shadowflame_name = "暗影烈焰警报",
	shadowflame_desc = "暗影烈焰警报",
	
	frenzy_name = "狂暴警报",
	frenzy_desc = "狂暴警报",
} end)


L:RegisterTranslations("koKR", function() return {
	trigger1 = "플레임고르|1이;가; 폭풍 날개|1을;를; 시전합니다.",
	trigger2 = "플레임고르|1이;가; 암흑의 불길|1을;를; 시전합니다.",
	trigger3 = "광란의 상태에 빠집니다!",

	warn1 = "플레임고르가 폭풍 날개를 시전합니다!",
	warn2 = "30초후 폭풍 날개!",
	warn3 = "3초후 폭풍 날개!",
	warn4 = "암흑의 불길 경보!",
	warn5 = "광란 - 평정 사격!",
	bosskill = "플레임고르를 물리쳤습니다!",

	bar1text = "폭풍 날개",
} end)

L:RegisterTranslations("deDE", function() return {
	trigger1 = "Flammenmaul beginnt Fl\195\188gelsto\195\159 zu wirken.",
	trigger2 = "Flammenmaul beginnt Schattenflamme zu wirken.",
	trigger3 = "ger\195\164t in Raserei!",

	warn1 = "Flammenmaul beginnt Fl\195\188gelsto\195\159 zu wirken!",
	warn2 = "30 Sekunden bis zum n\195\64chsten Fl\195\188gelsto\195\159!",
	warn3 = "3 Sekunden bis Fl\195\188gelsto\195\159!",
	warn4 = "Schattenflamme kommt!",
	warn5 = "Raserei - Einlullender Schuss!",
	bosskill = "Flammenmaul wurde besiegt!",

	bar1text = "Fl\195\188gelsto\195\159",
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
	self:TriggerEvent("BigWigs_ThrottleSync", "FlamegorWingBuffet", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "FlamegorShadowflame", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsFlamegor:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if (string.find(msg, L"trigger1")) then
		self:TriggerEvent("BigWigs_SendSync", "FlamegorWingBuffet")
	elseif msg == L"trigger2" then
		self:TriggerEvent("BigWigs_SendSync", "FlamegorShadowflame")
	end
end

function BigWigsFlamegor:BigWigs_RecvSync(sync)
	if (sync == "FlamegorWingBuffet" and self.db.profile.wingbuffet) then
		self:TriggerEvent("BigWigs_Message", L"warn1", "Red")
		self:TriggerEvent("BigWigs_Message", L"warn2", "Yellow")
		self:ScheduleEvent("BigWigs_Message", 29, L"warn3", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"bar1text", 32, 1, "Interface\\Icons\\Spell_Fire_SelfDestruct", "Yellow", "Orange", "Red")
	elseif sync == "FlamegorShadowflame" and self.db.profile.shadowflame then
		self:TriggerEvent("BigWigs_Message", L"warn4", "Red")
	end
end

function BigWigsFlamegor:CHAT_MSG_MONSTER_EMOTE(msg)
	if (msg == L"trigger3" and self.db.profile.frenzy) then
		self:TriggerEvent("BigWigs_Message", L"warn5", "Red")
	end
end