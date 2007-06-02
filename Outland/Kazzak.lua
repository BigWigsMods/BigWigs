------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Doom Lord Kazzak"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Kazzak",

	enrage = "Enrage",
	enrage_desc = "Timers for enrage.",
	enrage_trigger1 = "For the Legion! For Kil'Jaeden!",
	enrage_trigger2 = "%s becomes enraged!",
	enrage_warning1 = "%s Engaged - Enrage in 50-60sec",
	enrage_warning2 = "Enrage soon!",
	enrage_message = "Enraged for 10sec!",
	enrage_finished = "Enrage over - Next in 50-60sec",
	enrage_bar = "~Enrage",
	enraged_bar = "<Enraged>",

	mark = "Mark",
	mark_desc = "Warn for Mark of Kazzak on You.",
	mark_trigger = "You are afflicted by Mark of Kazzak.",
	mark_message = "Mark of Kazzak on You",

	twist = "Twist",
	twist_desc = "Warn who has Twisted Reflection.",
	twist_trigger = "^([^%s]+) ([^%s]+) afflicted by Twisted Reflection.$",
	twist_message = "Twisted Reflection: %s",
} end)

L:RegisterTranslations("frFR", function() return {
	enrage = "Enrager",
	enrage_desc = "Préviens quand Kazzak est suceptible de devenir enragé.",
	enrage_trigger1 = "Pour la Légion ! Pour Kil'Jaeden !",
	enrage_trigger2 = "%s devient fou furieux !",
	enrage_warning1 = "%s engagé - Enragé dans 50-60 sec.",
	enrage_warning2 = "Bientôt enragé !",
	enrage_message = "Enragé pendant 10 sec. !",
	enrage_finished = "Fin de l'Enrager - Prochain dans 50-60 sec.",
	enrage_bar = "~Enrager",
	enraged_bar = "<Enragé>",

	mark = "Marque",
	mark_desc = "Préviens quand vous avez la Marque de Kazzak.",
	mark_trigger = "Vous subissez les effets de Marque de Kazzak.",
	mark_message = "Marque de Kazzak sur VOUS",

	twist = "Reflet tordu",
	twist_desc = "Préviens quand quelqu'un subit les effets de Reflet tordu.",
	twist_trigger = "^([^%s]+) ([^%s]+) les effets .* Reflet tordu.$",
	twist_message = "Reflet tordu : %s",
} end)

L:RegisterTranslations("koKR", function() return {
	enrage = "격노",
	enrage_desc = "격노에 대한 타이머.",
	enrage_trigger1 = "불타는 군단과 킬제덴을 위하여!",
	enrage_trigger2 = "%s|1이;가; 분노에 휩싸입니다!",
	enrage_warning1 = "%s 전투 개시 - 50-60초 후 격노",
	enrage_warning2 = "잠시 후 격노!",
	enrage_message = "10초간 격노!",
	enrage_finished = "격노 종료 - 다음은 50-60초 후",
	enrage_bar = "~격노",
	enraged_bar = "<격노>",

	mark = "징표",
	mark_desc = "당신에 카자크의 징표 알림.",
	mark_trigger = "당신은 카자크의 징표에 걸렸습니다.",
	mark_message = "당신에 카자크의 징표",

	twist = "어긋난 반사",
	twist_desc = "어긋난 반사에 걸린 사람에 대한 경고.",
	twist_trigger = "^([^|;%s]*)(.*)어긋난 반사에 걸렸습니다%.$",
	twist_message = "어긋난 반사: %s",
} end)

L:RegisterTranslations("zhTW", function() return {
	enrage = "狂怒",
	enrage_desc = "狂怒計時",

	mark = "印記",
	mark_desc = "當你受到卡札克的印記時發出警報",

	twist = "扭曲反射",
	twist_desc = "當隊友受到扭曲反射時發出警報",

	enrage_trigger1 = "為了軍團!為了基爾加德!",
	enrage_trigger2 = "%s變得憤怒了!",
	enrage_warning1 = "與 %s 進入戰鬥！ 50-60 秒後狂怒！",
	enrage_warning2 = "即將狂怒！",
	enrage_message = "狂怒狀態 10 秒！",
	enrage_finished = "狂怒結束！ 50-60 秒後再次狂怒！",
	enrage_bar = "狂怒",
	enraged_bar = "已狂怒",

	mark_trigger = "你受到卡札克的印記",
	mark_message = "你受到卡札克的印記！",

	twist_trigger = "(.+)受到(.*)扭曲反射",
	twist_message = "扭曲反射: %s",
} end)

----------------------------------
--      Module Declaration      --
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

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "Twisted", 2)
end

------------------------------
--      Event Handlers      --
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
