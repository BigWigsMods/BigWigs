------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Flamegor"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started 

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	wingbuffet_trigger = "Flamegor begins to cast Wing Buffet",
	shadowflame_trigger = "Flamegor begins to cast Shadow Flame.",
	frenzy_trigger = "%s goes into a frenzy!",

	wingbuffet_message = "Wing Buffet! 30sec to next!",
	wingbuffet_warning = "3sec to Wing Buffet!",
	wingbuffet_approx = "~5sec to first Wing Buffet!",
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
	frenzy_trigger = "%s变得狂怒无比！",

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

L:RegisterTranslations("zhTW", function() return {
	wingbuffet_trigger = "弗萊格爾開始施放龍翼打擊。",
	shadowflame_trigger = "弗萊格爾開始施放暗影烈焰。",
	frenzy_trigger = "%s變得狂暴起來！",

	wingbuffet_message = "龍翼打擊！ 30 秒後再次發動！",
	wingbuffet_warning = "3 秒後龍翼打擊！",
	shadowflame_warning = "暗影烈焰發動！",
	frenzy_message = "狂暴警報！獵人立刻使用寧神射擊！",

	wingbuffet_bar = "龍翼打擊",

	wingbuffet_name = "龍翼打擊警報",
	wingbuffet_desc = "當弗萊格爾施放龍翼打擊時發出警報",

	shadowflame_name = "暗影烈焰警報",
	shadowflame_desc = "當弗萊格爾施放暗影烈焰時發出警報",

	frenzy_name = "狂暴警報",
	frenzy_desc = "狂暴警報",
} end)

L:RegisterTranslations("koKR", function() return {
	wingbuffet_trigger = "플레임고르|1이;가; 폭풍 날개|1을;를; 시전합니다.",
	shadowflame_trigger = "플레임고르|1이;가; 암흑의 불길|1을;를; 시전합니다.",
	frenzy_trigger = "%s|1이;가; 광란의 상태에 빠집니다!",

	wingbuffet_message = "폭풍 날개! 다음은 30초 후!",
	wingbuffet_warning = "3초후 폭풍 날개!",
	wingbuffet_approx = "첫 폭풍 날개 까지 약 5초!",
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

	wingbuffet_message = "Fl\195\188gelsto\195\159! N\195\164chster in 30 Sekunden!",
	wingbuffet_warning = "Fl\195\188gelsto\195\159 in 3 Sekunden!",
	shadowflame_warning = "Schattenflamme!",
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

	wingbuffet_message = "Frappe des ailes ! 30 sec. avant la prochaine !",
	wingbuffet_warning = "3 sec. avant la Frappe des ailes !",
	shadowflame_warning = "Flamme d'ombre imminente !",
	frenzy_message = "Fr\195\169n\195\169sie - Tir tranquillisant !",

	wingbuffet_bar = "Frappe des ailes",

	wingbuffet_name = "Alerte Frappe des ailes",
	wingbuffet_desc = "Pr\195\169viens quand Flamegor effectue sa Frappe des ailes.",

	shadowflame_name = "Alerte Flamme d'ombre",
	shadowflame_desc = "Pr\195\169viens quand l'incantation de la Flamme d'ombre est imminente.",

	frenzy_name = "Alerte Fr\195\169n\195\169sie",
	frenzy_desc = "Pr\195\169viens quand Flamegor est pris de fr\195\169n\195\169sie.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsFlamegor = BigWigs:NewModule(boss)
BigWigsFlamegor.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsFlamegor.enabletrigger = boss
BigWigsFlamegor.toggleoptions = {"wingbuffet", "shadowflame", "frenzy", "bosskill"}
BigWigsFlamegor.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsFlamegor:OnEnable()
	started = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "FlamegorWingBuffet2", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "FlamegorShadowflame", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsFlamegor:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["wingbuffet_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "FlamegorWingBuffet2")
	elseif msg == L["shadowflame_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "FlamegorShadowflame")
	end
end

function BigWigsFlamegor:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.wingbuffet then
			self:ScheduleEvent("BigWigs_Message", 24, L["wingbuffet_approx"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["wingbuffet_bar"], 29, "Interface\\Icons\\Spell_Fire_SelfDestruct")
		end
	elseif sync == "FlamegorWingBuffet2" and self.db.profile.wingbuffet then
		self:TriggerEvent("BigWigs_Message", L["wingbuffet_message"], "Important")
		self:ScheduleEvent("BigWigs_Message", 29, L["wingbuffet_warning"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["wingbuffet_bar"], 32, "Interface\\Icons\\Spell_Fire_SelfDestruct")
	elseif sync == "FlamegorShadowflame" and self.db.profile.shadowflame then
		self:TriggerEvent("BigWigs_Message", L["shadowflame_warning"], "Important")
	end
end

function BigWigsFlamegor:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["frenzy_trigger"] and self.db.profile.frenzy then
		self:TriggerEvent("BigWigs_Message", L["frenzy_message"], "Important")
	end
end
