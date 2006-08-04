------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Ebonroc")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	trigger1 = "Ebonroc begins to cast Wing Buffet",
	trigger2 = "Ebonroc begins to cast Shadow Flame.",
	trigger3 = "^([^%s]+) ([^%s]+) afflicted by Shadow of Ebonroc",

	you = "You",
	are = "are",

	warn1 = "Ebonroc begins to cast Wing Buffet!",
	warn2 = "30 seconds till next Wing Buffet!",
	warn3 = "3 seconds before Ebonroc casts Wing Buffet!",
	warn4 = "Shadow Flame incoming!",
	warn5 = "You have Shadow of Ebonroc!",
	warn6 = " has Shadow of Ebonroc!",

	bar1text = "Wing Buffet",

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
} end)

L:RegisterTranslations("zhCN", function() return {
	trigger1 = "埃博诺克开始施放龙翼打击。",
	trigger2 = "埃博诺克开始施放暗影烈焰。",
	trigger3 = "^(.+)受(.+)了埃博诺克之影",

	you = "你",
	are = "到",

	warn1 = "埃博诺克开始施放龙翼打击！",
	warn2 = "龙翼打击 - 30秒后再次发动",
	warn3 = "3秒后发动龙翼打击！",
	warn4 = "暗影烈焰发动！",
	warn5 = "你中了埃博诺克之影！",
	warn6 = "中了埃博诺克之影！",

	bar1text = "龙翼打击",
} end)


L:RegisterTranslations("koKR", function() return {
	trigger1 = "에본로크|1이;가; 폭풍 날개|1을;를; 시전합니다.",
	trigger2 = "에본로크|1이;가; 암흑의 불길|1을;를; 시전합니다.",
	trigger3 = "(.*)에본로크의 그림자에 걸렸습니다.",

	you = "",
	are = "are",
	whopattern = "(.+)|1이;가; ",

	warn1 = "에본로크가 폭풍 날개를 시전합니다!",
	warn2 = "30초후 폭풍 날개!",
	warn3 = "3초후 폭풍 날개!",
	warn4 = "암흑의 불길 경고!",
	warn5 = "당신은 에본로크의 그림자에 걸렸습니다!",
	warn6 = "님이 에본로크의 그림자에 걸렸습니다!",

	bar1text = "폭풍 날개",
} end)

L:RegisterTranslations("deDE", function() return {
	trigger1 = "Schattenschwinge beginnt Fl\195\188gelsto\195\159 zu wirken.",
	trigger2 = "Schattenschwinge beginnt Schattenflamme zu wirken.",
	trigger3 = "^([^%s]+) ([^%s]+) betroffen von Schattenschwinges Schatten",

	you = "Ihr",
	are = "seid",

	warn1 = "Schattenschwinge beginnt Fl\195\188gelsto\195\159 zu wirken!",
	warn2 = "30 Sekunden bis zum n\195\164chsten Fl\195\188gelsto\195\159!",
	warn3 = "3 Sekunden bis Schattenschwinge Fl\195\188gelsto\195\159 zaubert!",
	warn4 = "Schattenflamme kommt!",
	warn5 = "Du hast Schattenschwinges Schatten!",
	warn6 = " hat Schattenschwinges Schatten!",

	bar1text = "Fluegelgelstoss",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsEbonroc = BigWigs:NewModule(boss)
BigWigsEbonroc.zonename = AceLibrary("Babble-Zone-2.0")("Blackwing Lair")
BigWigsEbonroc.enabletrigger = boss
BigWigsEbonroc.toggleoptions = { "youcurse", "elsecurse", "wingbuffet", "shadowflame", "bosskill"}
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
	self:TriggerEvent("BigWigs_ThrottleSync", "EbonrocWingBuffet", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "EbonrocShadowflame", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsEbonroc:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if (string.find(msg, L"trigger1")) then
		self:TriggerEvent("BigWigs_SendSync", "EbonrocWingBuffet")
	elseif msg == L"trigger2" then
		self:TriggerEvent("BigWigs_SendSync", "EbronrocShadowflame")
	end
end

function BigWigsEbonroc:BigWigs_RecvSync(sync)
	if sync == "EbonrocWingBuffet" and self.db.profile.wingbuffet then
		self:TriggerEvent("BigWigs_Message", L"warn1", "Red")
		self:TriggerEvent("BigWigs_Message", L"warn2", "Yellow")
		self:ScheduleEvent("BigWigs_Message", 29, L"warn3", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"bar1text", 32, 1, "Interface\\Icons\\Spell_Fire_SelfDestruct", "Yellow", "Orange", "Red")
	elseif sync == "EbronrocShadowflame" and self.db.profile.shadowflame then
		self:TriggerEvent("BigWigs_Message", L"warn4", "Red")
	end
end

if (GetLocale() == "koKR") then
	function BigWigsEbonroc:Event(msg)
		local _,_, EPlayer = string.find(msg, L"trigger3")
		if (EPlayer) then
			if (EPlayer == L"you" and self.db.profile.youcurse) then
				self:TriggerEvent("BigWigs_Message", L"warn5", "Red", true)
			elseif (self.db.profile.elsecurse) then
				local _,_, EWho = string.find(EPlayer, L"whopattern")
				self:TriggerEvent("BigWigs_Message", EWho .. L"warn6", "Yellow")
				self:TriggerEvent("BigWigs_SendTell", EWho, L"warn5")
			end
		end
	end
else
	function BigWigsEbonroc:Event(msg)
		local _,_, EPlayer, EType = string.find(msg, L"trigger3")
		if (EPlayer and EType) then
			if (EPlayer == L"you" and EType == L"are" and self.db.profile.youcurse) then
				self:TriggerEvent("BigWigs_Message", L"warn5", "Red", true)
			elseif (self.db.profile.elsecurse) then
				self:TriggerEvent("BigWigs_Message", EPlayer .. L"warn6", "Yellow")
				self:TriggerEvent("BigWigs_SendTell", EPlayer, L"warn5")
			end
		end
	end
end