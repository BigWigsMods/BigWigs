------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Battleguard Sartura"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Sartura",
	enrage = "Enrage Alerts",
	enrage_desc = "Warn for Enrage",

	whirlwind = "Whirlwind Alert",
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
	whirlwindoffwarn = "Whirlwind faded!",
	whirlwindbartext = "Whirlwind",
} end )

L:RegisterTranslations("frFR", function() return {
	enrage = "Alerte Enrag\195\169",
	enrage_desc = "Pr\195\169viens quand Sartura est enrag\195\169.",

	whirlwind = "Alerte Tourbillon",
	whirlwind_desc = "Pr\195\169viens des tourbillons.",

	starttrigger = "Je vous condamne \195\160 mort !",
	startwarn = "Sartura engag\195\169 - 10 minutes avant Enrag\195\169",
	enragetrigger = "devient fou furieux !",
	enragewarn = "Enrag\195\169 ! Enrag\195\169 ! Enrag\195\169 !",
	bartext = "Enrag\195\169",

	warn1 = "Enrag\195\169 dans 8 minutes",
	warn2 = "Enrag\195\169 dans 5 minutes",
	warn3 = "Enrag\195\169 dans 3 minutes",
	warn4 = "Enrag\195\169 dans 90 secondes",
	warn5 = "Enrag\195\169 dans 60 secondes",
	warn6 = "Enrag\195\169 dans 30 secondes",
	warn7 = "Enrag\195\169 dans 10 secondes",

	whirlwindon = "Garde de guerre Sartura gagne Tourbillon.",
	whirlwindoff = "Tourbillon sur Garde de guerre Sartura vient de se dissiper.",
	whirlwindonwarn = "Tourbillon - "..boss.." - Tourbillon",
	whirlwindoffwarn = "Tourbillon fini. Assomez-le !",
	whirlwindbartext = "Tourbillon",
} end )

L:RegisterTranslations("deDE", function() return {
	enrage = "Wutanfall",
	enrage_desc = "Warnung, wenn Sartura w\195\188tend wird.",

	whirlwind = "Wirbelwind",
	whirlwind_desc = "Warnung, wenn Sartura Wirbelwind wirkt.",

	starttrigger = "Ihr habt heiligen Boden entweiht",
	startwarn = "Sartura angegriffen! Wutanfall in 10 Minuten!",
	enragetrigger = "%s wird w\195\188tend!",
	enragewarn = "Sartura ist w\195\188tend!",
	bartext = "Wutanfall",
	warn1 = "Wutanfall in 8 Minuten",
	warn2 = "Wutanfall in 5 Minuten",
	warn3 = "Wutanfall in 3 Minuten",
	warn4 = "Wutanfall in 90 Sekunden",
	warn5 = "Wutanfall in 60 Sekunden",
	warn6 = "Wutanfall in 30 Sekunden",
	warn7 = "Wutanfall in 10 Sekunden",
	whirlwindon = "Schlachtwache Sartura bekommt 'Wirbelwind'.",
	whirlwindoff = "Wirbelwind schwindet von Schlachtwache Sartura.",
	whirlwindonwarn = "Wirbelwind!",
	whirlwindoffwarn = "Wirbelwind vorbei!",
	whirlwindbartext = "Wirbelwind",
} end )

L:RegisterTranslations("zhCN", function() return {
	enrage = "激怒警报",
	enrage_desc = "激怒警报",

	whirlwind = "旋风斩警报",
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
	whirlwindonwarn = "沙尔图拉施放 旋风斩！",
	whirlwindoffwarn = "旋风斩消失！",
	whirlwindbartext = "旋风斩",
} end )

L:RegisterTranslations("zhTW", function() return {
	enrage = "狂暴警報",
	enrage_desc = "當沙爾圖拉狂暴時發出警報",

	whirlwind = "旋風斬警報",
	whirlwind_desc = "當沙爾圖拉施放旋風斬發出警報",

	starttrigger = "玷汙這些神聖之地",
	startwarn = "沙爾圖拉已進入戰鬥 - 10分鐘後進入狂暴狀態",
	enragetrigger = "沙爾圖拉獲得了狂怒的效果。",
	enragewarn = "狂暴！狂暴！狂暴！",
	bartext = "狂暴",
	warn1 = "8 分鐘後狂暴",
	warn2 = "5 分鐘後狂暴",
	warn3 = "3 分鐘後狂暴",
	warn4 = "90 秒後狂暴",
	warn5 = "60 秒後狂暴",
	warn6 = "30 秒後狂暴",
	warn7 = "10 秒後狂暴",
	whirlwindon = "沙爾圖拉獲得了旋風斬的效果。",
	whirlwindoff = "旋風斬效果從沙爾圖拉身上消失。",
	whirlwindonwarn = "沙爾圖拉施放 旋風斬！",
	whirlwindoffwarn = "旋風斬消失！",
	whirlwindbartext = "旋風斬",
} end )

L:RegisterTranslations("koKR", function() return {
	enrage = "격노 경고",
	enrage_desc = "격노에 대한 경고",

	whirlwind = "소용돌이 경고",
	whirlwind_desc = "소용돌이에 대한 경고",

	starttrigger = "성스러운 땅을 더럽힌 죗값을 받게 되리라. 고대의 법률은 거스를 수 없다! 침입자들을 처단하라!",
	startwarn = "살투라 전투 시작! - 10분후 격노",
	enragetrigger = "%s|1이;가; 격노 효과를 얻었습니다.",
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

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"]
mod.enabletrigger = boss
mod.toggleoptions = {"enrage", "whirlwind", "bosskill"}
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
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

function mod:BigWigs_RecvSync(sync)
	if sync == "SarturaWhirlwind" and self.db.profile.whirlwind then
		self:TriggerEvent("BigWigs_Message", L["whirlwindonwarn"], "Important")
		self:ScheduleEvent("BigWigs_Message", 15, L["whirlwindoffwarn"], "Attention")
		self:TriggerEvent("BigWigs_StartBar", self, L["whirlwindbartext"], 15, "Interface\\Icons\\Ability_Whirlwind")
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["whirlwindon"] then
		self:TriggerEvent("BigWigs_SendSync", "SarturaWhirlwind")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.enrage and msg:find(L["starttrigger"]) then
		self:TriggerEvent("BigWigs_Message", L["startwarn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["bartext"], 600, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
		self:ScheduleEvent("BigWigs_Message", 120, L["warn1"], "Attention")
		self:ScheduleEvent("BigWigs_Message", 300, L["warn2"], "Attention")
		self:ScheduleEvent("BigWigs_Message", 420, L["warn3"], "Attention")
		self:ScheduleEvent("BigWigs_Message", 510, L["warn4"], "Urgent")
		self:ScheduleEvent("BigWigs_Message", 540, L["warn5"], "Urgent")
		self:ScheduleEvent("BigWigs_Message", 570, L["warn6"], "Important")
		self:ScheduleEvent("BigWigs_Message", 590, L["warn7"], "Important")
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if self.db.profile.enrage and msg:find(L["enragetrigger"]) then
		self:TriggerEvent("BigWigs_Message", L["enragewarn"], "Attention")
	end
end
