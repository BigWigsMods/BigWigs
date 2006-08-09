------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Battleguard Sartura")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Sartura",
	enrage_cmd = "enrage",
	enrage_name = "Enrage Alerts",
	enrage_desc = "Warn for Enrage",

	whirlwind_cmd = "whirlwind",
	whirlwind_name = "Whirlwind Alert",
	whirlwind_desc = "Warn for Whirlwind",

	starttrigger = "defiling these sacred grounds",
	startwarn = "Sartura engaged - 10 minutes until Enrage",
	enragetrigger = "becomes enraged",
	enragewarn = "Enrage - Enrage - Enrage",
	bartext = "Enrage",
	warn1 = "Enrage in 8 minutes",
	warn2 = "Enrage in 5 minutes",
	warn3 = "Enrage in 3 minutes",
	warn4 = "Enrage in 90 seconds",
	warn5 = "Enrage in 60 seconds",
	warn6 = "Enrage in 30 seconds",
	warn7 = "Enrage in 10 seconds",
	whirlwindon = "Battleguard Sartura gains Whirlwind.",
	whirlwindoff = "Whirlwind fades from Battleguard Sartura.",
	whirlwindonwarn = "Whirlwind - Battleguard Sartura - Whirlwind",
	whirlwindoffwarn = "Whirlwind faded. Spank! Spank! Spank!",
	whirlwindbartext = "Whirlwind",
} end )

L:RegisterTranslations("deDE", function() return {
	starttrigger = "Ihr habt heiligen Boden entweiht",
	startwarn = "Kampf mit Sartura hat begonnen - 10 Minuten bis Rage",
	enragetrigger = "ger\195\164t in t\195\182dliche Raserei",
	enragewarn = "Rage - Rage - Rage",
	bartext = "Rage",
	warn1 = "Rage in 8 Minuten",
	warn2 = "Rage in 5 Minuten",
	warn3 = "Rage in 3 Minuten",
	warn4 = "Rage in 90 Sekunden",
	warn5 = "Rage in 60 Sekunden",
	warn6 = "Rage in 30 Sekunden",
	warn7 = "Rage in 10 Sekunden",
	whirlwindon = "Schlachtwache Sartura bekommt 'Wirbelwind'.",
	whirlwindoff = "Wirbelwind schwindet von Schlachtwache Sartura.",
	whirlwindonwarn = "Wirbelwind - Schlachtwache Sartura - Wirbelwind",
	whirlwindoffwarn = "Wirbelwind verschwunden. Draufhauen! Draufhauen! Draufhauen!",
	whirlwindbartext = "Whirlwind",
} end )

L:RegisterTranslations("zhCN", function() return {
	enrage_name = "激怒警报",
	enrage_desc = "激怒警报",

	whirlwind_name = "旋风斩警报",
	whirlwind_desc = "旋风斩警报",
	
	starttrigger = "我宣判你死刑",
	startwarn = "沙尔图拉已激活 - 10分钟后进入激怒状态",
	enragetrigger = "沙尔图拉进入激怒状态！",
	enragewarn = "激怒 - 激怒 - 激怒",
	bartext = "激怒",
	warn1 = "8分钟后激怒",
	warn2 = "5分钟后激怒",
	warn3 = "3分钟后激怒",
	warn4 = "90秒后激怒",
	warn5 = "60秒后激怒",
	warn6 = "30秒后激怒",
	warn7 = "10秒后激怒",
	whirlwindon = "沙尔图拉获得了旋风斩的效果。",
	whirlwindoff = "旋风斩效果从沙尔图拉身上消失。",
	whirlwindonwarn = "旋风斩 - 沙尔图拉 - 旋风斩",
	whirlwindoffwarn = "旋风斩消失！",
	whirlwindbartext = "旋风斩",
} end )

L:RegisterTranslations("koKR", function() return {
	starttrigger = "성스러운 땅을 더럽힌 죄값을 받게 되리라. 고대의 법률은 거스를 수 없다! 침입자들을 처단하라!",
	startwarn = "살투라 격노 - 10분후 다음 격노",
	enragetrigger = "전투감시병 살투라|1이;가; 격노 효과를 얻었습니다.",
	enragewarn = "격노 - 격노 - 격노",
	bartext = "격노",
	warn1 = "격노 - 8분후",
	warn2 = "격노 - 5분후",
	warn3 = "격노 - 3분후",
	warn4 = "격노 - 90초",
	warn5 = "격노 - 60초",
	warn6 = "격노 - 30초",
	warn7 = "격노 - 10초",
	whirlwindon = "전투감시병 살투라|1이;가; 소용돌이 효과를 얻었습니다.",
	whirlwindoff = "전투감시병 살투라의 몸에서 소용돌이 효과가 사라졌습니다.",
	whirlwindonwarn = "소용돌이 - 전투감시병 살투라 - 소용돌이",
	whirlwindoffwarn = "소용돌이 사라짐. 스턴! 스턴! 스턴!",
	whirlwindbartext = "소용돌이",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsSartura = BigWigs:NewModule(boss)
BigWigsSartura.zonename = AceLibrary("Babble-Zone-2.0")("Ahn'Qiraj")
BigWigsSartura.enabletrigger = boss
BigWigsSartura.toggleoptions = {"enrage", "whirlwind", "bosskill"}
BigWigsSartura.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsSartura:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "SarturaWhirlwind", 3)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsSartura:BigWigs_RecvSync(sync)
	if sync == "SarturaWhirlwind" and self.db.profile.whirlwind then
		self:TriggerEvent("BigWigs_Message", L"whirlwindonwarn", "Red")
		self:ScheduleEvent("BigWigs_Message", 15, L"whirlwindoffwarn", "Yellow")
		self:TriggerEvent("BigWigs_StartBar", self, L"whirlwindbartext", 15, "Interface\\Icons\\Ability_Whirlwind", "Yellow", "Orange", "Red")
	end
end

function BigWigsSartura:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L"whirlwindon" then
		self:TriggerEvent("BigWigs_SendSync", "SarturaWhirlwind")
	end
end

function BigWigsSartura:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.enrage and string.find(msg, L"starttrigger") then
		self:TriggerEvent("BigWigs_Message", L"startwarn", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"bartext", 600, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy", "Green", "Yellow", "Orange", "Red")
		self:ScheduleEvent("BigWigs_Message", 120, L"warn1", "Green")
		self:ScheduleEvent("BigWigs_Message", 300, L"warn2", "Yellow")
		self:ScheduleEvent("BigWigs_Message", 420, L"warn3", "Yellow")
		self:ScheduleEvent("BigWigs_Message", 510, L"warn4", "Orange")
		self:ScheduleEvent("BigWigs_Message", 540, L"warn5", "Orange")
		self:ScheduleEvent("BigWigs_Message", 570, L"warn6", "Red")
		self:ScheduleEvent("BigWigs_Message", 590, L"warn7", "Red")
	end
end

function BigWigsSartura:CHAT_MSG_MONSTER_EMOTE(msg)
	if self.db.profile.enrage and string.find(msg, L"enragetrigger") then
		self:TriggerEvent("BigWigs_Message", L"enragewarn", "Yellow")
	end
end
