------------------------------
--      Are you local?    --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Doom Lord Kazzak"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Kazzak",

	enrage = "Enrage",
	enrage_desc = "Timers for enrage",

	mark = "Mark",
	mark_desc = "Warn for Mark of Kazzak on You",

	twist = "Twist",
	twist_desc = "Warn who has Twisted Reflection",

	enrage_trigger1 = "For the Legion! For Kil'Jaeden!",
	enrage_trigger2 = "%s becomes enraged!",
	enrage_warning1 = "%s Engaged - Enrage in 50-60sec",
	enrage_warning2 = "Enrage soon!",
	enrage_message = "Enraged for 10sec!",
	enrage_finished = "Enrage over - Next in 50-60sec",
	enrage_bar = "~Enrage",
	enraged_bar = "<Enraged>",

	mark_trigger = "You are afflicted by Mark of Kazzak.",
	mark_message = "Mark of Kazzak on You",

	twist_trigger = "^([^%s]+) ([^%s]+) afflicted by Twisted Reflection",
	twist_message = "Twisted Reflection: %s",
} end)

L:RegisterTranslations("frFR", function() return {
	enrage = "Alerte Enrager",
	enrage_desc = "D\195\169lais entre p\195\169riode enrag\195\169.",

	--mark = "Mark",
	--mark_desc = "Warn for Mark of Kazzak on You",

	--twist = "Twist",
	--twist_desc = "Warn who has Twisted Reflection",

	enrage_trigger1 = "Pour la L\195\169gion\194\160! Pour Kil'Jaeden\194\160!",
	enrage_trigger2 = "%s devient fou furieux\194\160!",
	enrage_warning1 = "%s Engag\195\169 - Enrag\195\169 dans 1min",
	--enrage_warning2 = "Enrag\195\169 dans 5 sec", --enUS changed
	enrage_message = "Enrag\195\169 pendant 10sec!",
	--enrage_finished = "Enrag\195\169 fini", --enUS changed
	enrage_bar = "Enrag\195\169",
	--enraged_bar = "<Enraged>",

	--mark_trigger = "You are afflicted by Mark of Kazzak.",
	--mark_message = "Mark of Kazzak on You",

	--twist_trigger = "^([^%s]+) ([^%s]+) afflicted by Twisted Reflection",
	--twist_message = "Twisted Reflection: %s",
} end)

L:RegisterTranslations("koKR", function() return {
	enrage = "격노",
	enrage_desc = "격노에 대한 타이머",

	mark = "징표",
	mark_desc = "당신에 카자크의 징표 알림",

	twist = "어긋난 반사",
	twist_desc = "어긋난 반사에 걸린 사람에 대한 경고",

	enrage_trigger1 = "불타는 군단과 킬제덴을 위하여!",
	enrage_trigger2 = "%s|1이;가; 분노에 휩싸입니다!",
	enrage_warning1 = "%s 전투 개시 - 50-60초 후 격노",
	enrage_warning2 = "잠시 후 격노!",
	enrage_message = "10초간 격노!",
	enrage_finished = "격노 종료 - 다음은 50-60초 후",
	enrage_bar = "격노",
	enraged_bar = "<격노>",

	mark_trigger = "당신은 카자크의 징표에 걸렸습니다.",
	mark_message = "당신에 카자크의 징표",

	twist_trigger = "^([^|;%s]*)(.*)어긋난 반사에 걸렸습니다%.$",
	twist_message = "어긋난 반사: %s",
} end)

----------------------------------
--   Module Declaration    --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Hellfire Peninsula"]
mod.otherMenu = "Outland"
mod.enabletrigger = boss
mod.toggleoptions = {"enrage", "mark", "twist", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "Twisted", 2)
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.enrage and msg == L["enrage_trigger1"] then
		self:Message(L["enrage_warning1"]:format(boss), "Attention")
		self:DelayedMessage(49, L["enrage_warning2"], "Urgent")
		self:Bar(L["enrage_bar"], 60, "Spell_Shadow_UnholyFrenzy")
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if self.db.profile.enrage and msg == L["enrage_trigger2"] then
		self:Message(L["enrage_message"], "Important", nil, "Alert")
		self:DelayedMessage(10, L["enrage_finished"], "Positive")
		self:Bar(L["enraged_bar"], 10, "Spell_Shadow_UnholyFrenzy")
		self:DelayedMessage(49, L["enrage_warning2"], "Urgent")
		self:Bar(L["enrage_bar"], 60, "Spell_Shadow_UnholyFrenzy")
	end
end

function mod:Event(msg)
	if self.db.profile.mark and msg == L["mark_trigger"] then
		self:Message(L["mark_message"], "Positive", true, "Alarm")
	end
	local tplayer, ttype = select(3, msg:find(L["twist_trigger"]))
	if tplayer and ttype then
		if tplayer == L2["you"] and ttype == L2["are"] then
			tplayer = UnitName("player")
		end
		self:Sync("Twisted "..tplayer)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "Twisted" and rest and self.db.profile.twist then
		self:Message(L["twist_message"]:format(rest), "Attention")
	end
end
