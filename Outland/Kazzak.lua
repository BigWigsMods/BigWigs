------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Doom Lord Kazzak"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local pName = UnitName("player")
local db = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Kazzak",

	engage_trigger1 = "The Legion will conquer all!",
	engage_trigger2 = "All mortals will perish!",

	enrage_trigger = "%s becomes enraged!",
	enrage_warning1 = "%s Engaged - Enrage in 50-60sec",
	enrage_warning2 = "Enrage soon!",
	enrage_message = "Enraged for 10sec!",
	enrage_finished = "Enrage over - Next in 50-60sec",
	enrage_bar = "~Enrage",
	enraged_bar = "<Enraged>",

	mark = "Mark",
	mark_desc = "Warn for Mark of Kazzak on You.",
	mark_message = "Mark of Kazzak on You",

	twist = "Twist",
	twist_desc = "Warn who has Twisted Reflection.",
	twist_message = "Twisted Reflection: %s",
} end)

L:RegisterTranslations("esES", function() return {
	engage_trigger1 = "¡La Legión lo conquistará todo!",
	engage_trigger2 = "¡Todo mortal perecerá!",

	enrage_trigger = "%s se enfurece.",
	enrage_warning1 = "%s Activado - Enfurecer en 50-60seg",
	enrage_warning2 = "¡Enfurecer en breve!",
	enrage_message = "¡Efurecido durante 10seg!",
	enrage_finished = "Fin enfurecer - Próx. en 50-60seg",
	enrage_bar = "~Enfurecer",
	enraged_bar = "<Enfurecido>",

	mark = "Marca de Kazzak (Mark)",
	mark_desc = "Avisar sobre Marca de Kazzak en ti.",
	mark_message = "Marca de Kazzak en TI",

	twist = "Reflejo retorcido (Twisted Reflection)",
	twist_desc = "Avisar quién tiene Reflejo retorcido.",
	twist_message = "Reflejo retorcido: %s",
} end)

L:RegisterTranslations("frFR", function() return {
	engage_trigger1 = "La Légion envahira l'univers !",
	engage_trigger2 = "Que les mortels périssent tous !",

	enrage_trigger = "%s devient fou furieux !",
	enrage_warning1 = "%s engagé - Enrager dans 50-60 sec.",
	enrage_warning2 = "Enrager imminent !",
	enrage_message = "Enragé pendant 10 sec. !",
	enrage_finished = "Fin de l'Enrager - Prochain dans 50-60 sec.",
	enrage_bar = "~Enrager",
	enraged_bar = "<Enragé>",

	mark = "Marque",
	mark_desc = "Prévient quand vous avez la Marque de Kazzak.",
	mark_message = "Marque de Kazzak sur VOUS",

	twist = "Reflet tordu",
	twist_desc = "Prévient quand quelqu'un subit les effets de Reflet tordu.",
	twist_message = "Reflet tordu : %s",
} end)

L:RegisterTranslations("koKR", function() return {
	engage_trigger1 = "불타는 군단이 온 세상을 지배하리라!",
	engage_trigger2 = "필멸의 종족은 모두 멸망하리라!",

	enrage_trigger = "%s|1이;가; 분노에 휩싸입니다!",
	enrage_warning1 = "%s 전투 개시 - 50-60초 후 격노",
	enrage_warning2 = "잠시 후 격노!",
	enrage_message = "10초간 격노!",
	enrage_finished = "격노 종료 - 다음은 50-60초 후",
	enrage_bar = "~격노",
	enraged_bar = "<격노>",

	mark = "징표",
	mark_desc = "자신이 카자크의 징표에 걸렸을 때 알립니다.",
	mark_message = "당신은 카자크의 징표",

	twist = "어긋난 반사",
	twist_desc = "어긋난 반사에 걸린 사람에 대한 경고입니다.",
	twist_message = "어긋난 반사: %s",
} end)

L:RegisterTranslations("zhTW", function() return {
	engage_trigger1 = "燃燒軍團將征服一切!",
	engage_trigger2 = "所有的凡人都將死亡!",

	enrage_trigger = "%s變得憤怒了!",
	enrage_warning1 = "與 %s 進入戰鬥! 50-60 秒後狂怒!",
	enrage_warning2 = "即將狂怒!",
	enrage_message = "狂怒狀態 10 秒!",
	enrage_finished = "狂怒結束! 50-60 秒後再次狂怒!",
	enrage_bar = "<狂怒>",
	enraged_bar = "<已狂怒>",

	mark = "印記",
	mark_desc = "當你受到卡札克的印記時發出警報",
	mark_message = "你受到卡札克的印記!",

	twist = "扭曲反射",
	twist_desc = "當隊友受到扭曲反射時發出警報",
	twist_message = "扭曲反射: [%s]",
} end)

L:RegisterTranslations("zhCN", function() return {
	engage_trigger1 = "军团将会征服一切！",
	engage_trigger2 = "所有的凡人都将灭亡！",

	enrage_trigger = "%s变得愤怒了！",
	enrage_warning1 = "%s 激活 - 50-60秒后，激怒！",
	enrage_warning2 = "即将 激怒！",
	enrage_message = "10秒后，激怒！",
	enrage_finished = "激活结束！50-60秒后，再次发动。",
	enrage_bar = "<激怒>",
	enraged_bar = "<已激怒>",

	mark = "印记",
	mark_desc = "当你受到卡扎克的印记时发出警报。",
	mark_message = ">你< 卡扎克的印记！",

	twist = "扭曲反射",
	twist_desc = "当玩家受到扭曲反射时发出警报。",
	twist_message = "扭曲反射：>%s<！",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Hellfire Peninsula"]
mod.otherMenu = "Outland"
mod.enabletrigger = boss
mod.toggleoptions = {"enrage", "mark", "twist", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Mark", 32960)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Twisted", 21063)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Mark(player)
	if player == pName and db.mark then
		self:LocalMessage(L["mark_message"], "Personal", 32960, "Alarm")
	end
end

function mod:Twisted(player)
	if db.twist then
		self:IfMessage(L["twist_message"]:format(player), "Attention", 21063)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if db.enrage and (msg == L["engage_trigger1"] or msg == L["engage_trigger2"]) then
		self:Message(L["enrage_warning1"]:format(boss), "Attention")
		self:DelayedMessage(49, L["enrage_warning2"], "Urgent")
		self:Bar(L["enrage_bar"], 60, "Spell_Shadow_UnholyFrenzy")
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if db.enrage and msg == L["enrage_trigger"] then
		self:Message(L["enrage_message"], "Important", nil, "Alert")
		self:DelayedMessage(10, L["enrage_finished"], "Positive")
		self:Bar(L["enraged_bar"], 10, "Spell_Shadow_UnholyFrenzy")
		self:DelayedMessage(49, L["enrage_warning2"], "Urgent")
		self:Bar(L["enrage_bar"], 60, "Spell_Shadow_UnholyFrenzy")
	end
end

