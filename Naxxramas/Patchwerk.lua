------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Patchwerk")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "patchwerk",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",

	enragetrigger = "goes into a berserker rage!",

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
	cmd = "patchwerk",

	enrage_cmd = "enrage",
	enrage_name = "Wutanfall",
	enrage_desc = "Warnung, wenn Flickwerk w\195\188tend wird.",

	enragetrigger = "f\195\164llt in Berserkerwut!", -- ? "wird w\195\188tend",

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
	enragetrigger = "goes into a berserker rage!", -- 사용되지 않음

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

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsPatchwerk = BigWigs:NewModule(boss)
BigWigsPatchwerk.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsPatchwerk.enabletrigger = boss
BigWigsPatchwerk.toggleoptions = {"enrage", "bosskill"}
BigWigsPatchwerk.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsPatchwerk:OnEnable()
	self.enrageStarted = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
end

function BigWigsPatchwerk:Scan()
	if (UnitName("target") == boss and UnitAffectingCombat("target")) then
		return true
	elseif (UnitName("playertarget") == boss and UnitAffectingCombat("playertarget")) then
		return true
	else
		local i
		for i = 1, GetNumRaidMembers(), 1 do
			if (UnitName("raid"..i.."target") == boss and UnitAffectingCombat("raid"..i.."target")) then
				return true
			end
		end
	end
	return false
end

function BigWigsPatchwerk:CHAT_MSG_MONSTER_YELL( msg )
	if self.db.profile.enrage and ( msg == L"starttrigger1" or msg == L"starttrigger2" ) then
		self:TriggerEvent("BigWigs_Message", L"startwarn", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"enragebartext", 420, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy", "Green", "Yellow", "Orange", "Red")
		self:ScheduleEvent("bwpatchwarn1", "BigWigs_Message", 120, L"warn1", "Green")
		self:ScheduleEvent("bwpatchwarn2", "BigWigs_Message", 240, L"warn2", "Yellow")
		self:ScheduleEvent("bwpatchwarn3", "BigWigs_Message", 330, L"warn3", "Orange")
		self:ScheduleEvent("bwpatchwarn4", "BigWigs_Message", 360, L"warn4", "Orange")
		self:ScheduleEvent("bwpatchwarn5", "BigWigs_Message", 390, L"warn5", "Red")
		self:ScheduleEvent("bwpatchwarn6", "BigWigs_Message", 410, L"warn6", "Red")
	end
end

function BigWigsPatchwerk:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	local running = self:IsEventScheduled("Patchwerk_CheckWipe")
	if (not go) then
		self:TriggerEvent("BigWigs_RebootModule", self)
	elseif (not running) then
		self:ScheduleRepeatingEvent("Patchwerk_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
	end
end

function BigWigsPatchwerk:CHAT_MSG_MONSTER_EMOTE( msg )
	if msg == L"enragetrigger" then
		if self.db.profile.enrage then
			self:TriggerEvent("BigWigs_Message", L"enragewarn", "Red")
		end
		self:TriggerEvent("BigWigs_StopBar", self, L"enragebartext")
		self:CancelScheduledEvent("bwpatchwarn1")
		self:CancelScheduledEvent("bwpatchwarn2")
		self:CancelScheduledEvent("bwpatchwarn3")
		self:CancelScheduledEvent("bwpatchwarn4")
		self:CancelScheduledEvent("bwpatchwarn5")
		self:CancelScheduledEvent("bwpatchwarn6")
	end
end
