------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Patchwerk"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Patchwerk",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",

	enragetrigger = "%s goes into a berserker rage!",

	enragewarn = "Enrage!",
	starttrigger1 = "Patchwerk want to play!",
	starttrigger2 = "Kel'thuzad make Patchwerk his avatar of war!",
	startwarn = "Patchwerk Engaged! Enrage in 7 minutes!",
	enragebartext = "Enrage",
	warn1 = "Enrage in 5 minutes",
	warn2 = "Enrage in 3 minutes",
	warn3 = "Enrage in 90 seconds",
	warn4 = "Enrage in 60 seconds",
	warn5 = "Enrage in 30 seconds",
	warn6 = "Enrage in 10 seconds",
} end )


L:RegisterTranslations("deDE", function() return {
	enrage_name = "Wutanfall",
	enrage_desc = "Warnung, wenn Flickwerk w\195\188tend wird.",

	enragetrigger = "%s f\195\164llt in Berserkerwut!", -- ? "wird w\195\188tend",

	enragewarn = "Wutanfall!",
	starttrigger1 = "Flickwerk spielen m\195\182chte!", -- ?
	starttrigger2 = "Kel'thuzad macht Flickwerk zu seinem Abgesandten von Krieg!", -- ?
	startwarn = "Flickwerk angegriffen! Wutanfall in 7 Minuten!",
	enragebartext = "Wutanfall",
	warn1 = "Wutanfall in 5 Minuten",
	warn2 = "Wutanfall in 3 Minuten",
	warn3 = "Wutanfall in 90 Sekunden",
	warn4 = "Wutanfall in 60 Sekunden",
	warn5 = "Wutanfall in 30 Sekunden",
	warn6 = "Wutanfall in 10 Sekunden",
} end )

L:RegisterTranslations("koKR", function() return {

	enrage_name = "격노 경고",
	enrage_desc = "격노에 대한 경고",

	enragetrigger = "%s|1이;가; 광폭해집니다!",

	enragewarn = "격노!",
	starttrigger1 = "패치워크랑 놀아줘!",
	starttrigger2 = "켈투자드님이 패치워크 싸움꾼으로 만들었다.",
	startwarn = "패치워크 전투시작! 격노 7분후!",
	enragebartext = "격노",
	warn1 = "격노 5분후",
	warn2 = "격노 3분후",
	warn3 = "격노 90초후",
	warn4 = "격노 60초후",
	warn5 = "격노 30초후",
	warn6 = "격노 10초후",	
} end )

L:RegisterTranslations("zhCN", function() return {
	enrage_name = "激怒警报",
	enrage_desc = "激怒警报",

	enragetrigger = "变得愤怒了！",

	enragewarn = "激怒！",
	starttrigger1 = "帕奇维克要跟你玩！",
	starttrigger2 = "帕奇维克是克尔苏加德的战神！",
	startwarn = "帕奇维克已激活 - 7分钟后激怒",
	enragebartext = "激怒",
	warn1 = "5分钟后激怒",
	warn2 = "3分钟后激怒",
	warn3 = "90秒后激怒",
	warn4 = "60秒后激怒",
	warn5 = "30秒后激怒",
	warn6 = "10秒后激怒",
} end )

L:RegisterTranslations("zhTW", function() return {
	-- Patchwerk 縫補者
	enrage_name = "狂怒警報",
	enrage_desc = "狂怒警報",

	enragetrigger = "變得極度狂暴而憤怒！",

	enragewarn = "狂怒！***",
	starttrigger1 = "縫補者要跟你玩！",
	starttrigger2 = "縫補者是科爾蘇加德的戰神！",
	startwarn = "*** 縫補者已進入鬥 - 7 分鐘後狂怒 ***",
	enragebartext = "狂怒",
	warn1 = "*** 5 分鐘後狂怒 ***",
	warn2 = "*** 3 分鐘後狂怒 ***",
	warn3 = "*** 90 秒後狂怒 ***",
	warn4 = "*** 60 秒後狂怒 ***",
	warn5 = "*** 30 秒後狂怒 ***",
	warn6 = "*** 10 秒後激怒 ***",
} end )

L:RegisterTranslations("frFR", function() return {
	enrage_name = "Alerte Enrager",
	enrage_desc = "Préviens régulièrement quand Le Recousu devient enragé.",
	
	enragetrigger = "%s devient fou furieux !",
	
	enragewarn = "Enragé !",
	starttrigger1 = "R'cousu veut jouer !",
	starttrigger2 = "R'cousu avatar de guerre pour Kel'Thuzad !",
	startwarn = "Le Recousu engagé ! Enrager dans 7 min. !",
	enragebartext = "Enrager",
	warn1 = "Enrager dans 5 min.",
	warn2 = "Enrager dans 3 min.",
	warn3 = "Enrager dans 90 sec.",
	warn4 = "Enrager dans 60 sec.",
	warn5 = "Enrager dans 30 sec.",
	warn6 = "Enrager dans 10 sec.",	
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsPatchwerk = BigWigs:NewModule(boss)
BigWigsPatchwerk.zonename = AceLibrary("Babble-Zone-2.2")["Naxxramas"]
BigWigsPatchwerk.enabletrigger = boss
BigWigsPatchwerk.toggleoptions = {"enrage", "bosskill"}
BigWigsPatchwerk.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsPatchwerk:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

function BigWigsPatchwerk:CHAT_MSG_MONSTER_YELL( msg )
	if self.db.profile.enrage and ( msg == L["starttrigger1"] or msg == L["starttrigger2"] ) then
		self:TriggerEvent("BigWigs_Message", L["startwarn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["enragebartext"], 420, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
		self:ScheduleEvent("bwpatchwarn1", "BigWigs_Message", 120, L["warn1"], "Attention")
		self:ScheduleEvent("bwpatchwarn2", "BigWigs_Message", 240, L["warn2"], "Attention")
		self:ScheduleEvent("bwpatchwarn3", "BigWigs_Message", 330, L["warn3"], "Urgent")
		self:ScheduleEvent("bwpatchwarn4", "BigWigs_Message", 360, L["warn4"], "Urgent")
		self:ScheduleEvent("bwpatchwarn5", "BigWigs_Message", 390, L["warn5"], "Important")
		self:ScheduleEvent("bwpatchwarn6", "BigWigs_Message", 410, L["warn6"], "Important")
	end
end

function BigWigsPatchwerk:CHAT_MSG_MONSTER_EMOTE( msg )
	if msg == L["enragetrigger"] then
		if self.db.profile.enrage then
			self:TriggerEvent("BigWigs_Message", L["enragewarn"], "Important")
		end
		self:TriggerEvent("BigWigs_StopBar", self, L["enragebartext"])
		self:CancelScheduledEvent("bwpatchwarn1")
		self:CancelScheduledEvent("bwpatchwarn2")
		self:CancelScheduledEvent("bwpatchwarn3")
		self:CancelScheduledEvent("bwpatchwarn4")
		self:CancelScheduledEvent("bwpatchwarn5")
		self:CancelScheduledEvent("bwpatchwarn6")
	end
end
