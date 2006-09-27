------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Ebonroc")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	wingbuffet_trigger = "Ebonroc begins to cast Wing Buffet",
	shadowflame_trigger = "Ebonroc begins to cast Shadow Flame.",
	shadowcurse_trigger = "^([^%s]+) ([^%s]+) afflicted by Shadow of Ebonroc",

	you = "You",
	are = "are",

	wingbuffet_message = "Wing Buffet! 30sec to next!",
	wingbuffet_warning = "3sec to Wing Buffet!",
	shadowflame_warning = "Shadow Flame incoming!",
	shadowflame_message_you = "You have Shadow of Ebonroc!",
	shadowflame_message_other = " has Shadow of Ebonroc!",

	wingbuffet_bar = "Wing Buffet",
	shadowcurse_bar = "%s - Shadow of Ebonroc",

	cmd = "Ebonroc",

	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Wing Buffet alert",
	wingbuffet_desc = "Warn for Wing Buffet",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn for Shadow Flame",

	youcurse_cmd = "youcurse",
	youcurse_name = "Shadow of Ebonroc on you alert",
	youcurse_desc = "Warn when you got Shadow of Ebonroc",

	elsecurse_cmd = "elsecurse",
	elsecurse_name = "Shadow of Ebonroc on others alert",
	elsecurse_desc = "Warn when others got Shadow of Ebonroc",

	shadowbar_cmd = "cursebar",
	shadowbar_name = "Shadow of Ebonroc timer bar",
	shadowbar_desc = "Shows a timer bar when someone gets Shadow of Ebonroc",
} end)

L:RegisterTranslations("zhCN", function() return {
	wingbuffet_trigger = "埃博诺克开始施放龙翼打击。",
	shadowflame_trigger = "埃博诺克开始施放暗影烈焰。",
	shadowcurse_trigger = "^(.+)受(.+)了埃博诺克之影",

	you = "你",
	are = "到",

	wingbuffet_message = "埃博诺克开始施放龙翼打击！",
	wingbuffet_warning = "3秒后发动龙翼打击！",
	shadowflame_warning = "暗影烈焰发动！",
	shadowflame_message_you = "你中了埃博诺克之影！",
	shadowflame_message_other = "中了埃博诺克之影！",
	
	shadowcurse_bar = "%s - 埃博诺克之影",

	wingbuffet_bar = "龙翼打击",

	wingbuffet_name = "龙翼打击警报",
	wingbuffet_desc = "龙翼打击警报",

	shadowflame_name = "暗影烈焰警报",
	shadowflame_desc = "暗影烈焰警报",

	youcurse_name = "玩家埃博诺克之影警报",
	youcurse_desc = "你中了埃博诺克之影时发出警报",

	elsecurse_name = "队友埃博诺克之影警报",
	elsecurse_desc = "队友中了埃博诺克之影时发出警报",
} end)


L:RegisterTranslations("koKR", function() return {
	wingbuffet_trigger = "에본로크|1이;가; 폭풍 날개|1을;를; 시전합니다.",
	shadowflame_trigger = "에본로크|1이;가; 암흑의 불길|1을;를; 시전합니다.",
	shadowcurse_trigger = "^([^|;%s]*)(.*)에본로크의 그림자에 걸렸습니다%.$",

	you = "",
	are = "",

	wingbuffet_message = "폭풍 날개! 다음은 30초 후!",
	wingbuffet_warning = "3초후 폭풍 날개!",
	shadowflame_warning = "암흑의 불길 경고!",
	shadowflame_message_you = "당신은 에본로크의 그림자에 걸렸습니다!",
	shadowflame_message_other = "님이 에본로크의 그림자에 걸렸습니다!",

	wingbuffet_bar = "폭풍 날개",
	shadowcurse_bar = "%s - 에본로크의 그림자",
	
	wingbuffet_name = "폭풍 날개 경고",
	wingbuffet_desc = "폭풍 날개에 대한 경고",
	
	shadowflame_name = "암흑의 불길 경고",
	shadowflame_desc = "암흑의 불길에 대한 경고",
	
	youcurse_name = "자신의 에본로크의 그림자 경고",
	youcurse_desc = "자신이 에본로크의 그림자에 걸렸을 때 경고",
	
	elsecurse_name = "타인의 에본로크의 그림자 경고",
	elsecurse_desc = "타인이 에본로크의 그림자에 걸렸을 때 경고",

	shadowbar_name = "에본로크의 그림자 타이머 바",
	shadowbar_desc = "에본로크의 그림자가 걸렸을 때 타이머 바 표시",
} end)

L:RegisterTranslations("deDE", function() return {
	wingbuffet_trigger = "Schattenschwinge beginnt Fl\195\188gelsto\195\159 zu wirken.",
	shadowflame_trigger = "Schattenschwinge beginnt Schattenflamme zu wirken.",
	shadowcurse_trigger = "^([^%s]+) (%w+) von Schattenschwinges Schatten betroffen.",

	you = "Ihr",
	are = "seid",

	wingbuffet_message = "Fl\195\188gelsto\195\159!",
	wingbuffet_warning = "Fl\195\188gelsto\195\159 in 3 Sekunden!",
	shadowflame_warning = "Schattenflamme in K\195\188rze!",
	shadowflame_message_you = "Du hast Schattenschwinges Schatten!",
	shadowflame_message_other = " hat Schattenschwinges Schatten!",

	wingbuffet_bar = "Fl\195\188gelsto\195\159",

	wingbuffet_name = "Fl\195\188gelsto\195\159",
	wingbuffet_desc = "Warnung, wenn Schattenschwinge Fl\195\188gelsto\195\159 wirkt.",

	shadowflame_name = "Schattenflamme",
	shadowflame_desc = "Warnung, wenn Schattenschwinge Schattenflamme wirkt.",

	youcurse_name = "Schatten auf Dir",
	youcurse_desc = "Warnung, wenn Du Schattenschwinges Schatten hast.",

	elsecurse_name = "Schatten auf Anderen",
	elsecurse_desc = "Warnung, wenn andere Spieler Schattenschwinges Schatten haben.",

	shadowcurse_bar = "%s - Schattenschwinges Schatten",
	shadowbar_name = "Schattenschwinges Schatten",
	shadowbar_desc = "Zeigt einen Anzeigebalken wenn jemand Schattenschwinges Schatten hat.",
} end)

L:RegisterTranslations("frFR", function() return {
	wingbuffet_trigger = "Roch\195\169b\195\168ne commence \195\160 lancer Frappe des ailes.",
	shadowflame_trigger = "Roch\195\169b\195\168ne commence \195\160 lancer Flamme d'ombre.",
	shadowcurse_trigger = "^([^%s]+) ([^%s]+) les effets de Ombre de Roch\195\169b\195\168ne",

	you = "Vous",
	are = "subissez",

	wingbuffet_warning = "3 sec avant prochaine Frappe des ailes!",
	shadowflame_warning = "Flamme d'ombre imminente!",
	shadowflame_message_you = "Vous avez l'Ombre de Roch\195\169b\195\168nec!",
	shadowflame_message_other = " a l'Ombre de Roch\195\169b\195\168ne!",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsEbonroc = BigWigs:NewModule(boss)
BigWigsEbonroc.zonename = AceLibrary("Babble-Zone-2.0")("Blackwing Lair")
BigWigsEbonroc.enabletrigger = boss
BigWigsEbonroc.toggleoptions = { "youcurse", "elsecurse", "shadowbar", -1, "wingbuffet", "shadowflame", -1, "bosskill" }
BigWigsEbonroc.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsEbonroc:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "EbonrocWingBuffet2", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "EbonrocShadowflame", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsEbonroc:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["shadowflame_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "EbonrocShadowflame")
	elseif string.find(msg, L["wingbuffet_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "EbonrocWingBuffet2")
	end
end

function BigWigsEbonroc:BigWigs_RecvSync(sync)
	if sync == "EbonrocWingBuffet2" and self.db.profile.wingbuffet then
		self:TriggerEvent("BigWigs_Message", L["wingbuffet_message"], "Red")
		self:ScheduleEvent("BigWigs_Message", 29, L["wingbuffet_warning"], "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L["wingbuffet_bar"], 32, "Interface\\Icons\\Spell_Fire_SelfDestruct", "Yellow", "Orange", "Red")
	elseif sync == "EbonrocShadowflame" and self.db.profile.shadowflame then
		self:TriggerEvent("BigWigs_Message", L["shadowflame_warning"], "Red")
	end
end

function BigWigsEbonroc:Event(msg)
	local _,_, EPlayer, EType = string.find(msg, L["shadowcurse_trigger"])
	if (EPlayer and EType) then
		if (EPlayer == L["you"] and EType == L["are"] and self.db.profile.youcurse) then
			self:TriggerEvent("BigWigs_Message", L["shadowflame_message_you"], "Red", true)
		elseif (self.db.profile.elsecurse) then
			self:TriggerEvent("BigWigs_Message", EPlayer .. L["shadowflame_message_other"], "Yellow")
			self:TriggerEvent("BigWigs_SendTell", EPlayer, L["shadowflame_message_you"])
		end
		if self.db.profile.shadowbar then
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["shadowcurse_bar"], EPlayer), 8, "Interface\\Icons\\Spell_Shadow_GatherShadows", "Red")
		end
	end
end

