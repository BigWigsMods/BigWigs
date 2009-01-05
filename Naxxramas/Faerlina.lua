------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Grand Widow Faerlina"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started = nil
local enraged = nil
local enrageName = GetSpellInfo(28798)
local enrageMessageId = nil
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Faerlina",

	silence = "Silence",
	silence_desc = "Warn for silence",

	starttrigger1 = "Kneel before me, worm!",
	starttrigger2 = "Slay them in the master's name!",
	starttrigger3 = "You cannot hide from me!",
	starttrigger4 = "Run while you still can!",

	startwarn = "Faerlina engaged, 60 sec to frenzy!",
	enragewarn15sec = "15 sec to frenzy!",
	enragewarn = "Frenzied!",
	enragewarn2 = "Frenzied Soon!",
	enrageremovewarn = "Frenzy removed! ~60 sec until next!",

	silencewarn = "Silenced!",
	silencewarn5sec = "Silence ends in 5 sec",
	silencebar = "Silence",

	rain = "Rain of Fire on You",
	rain_desc = "Warn when you are in a Rain of Fire.",
	rain_message = "Rain of Fire on YOU!",
} end )

L:RegisterTranslations("ruRU", function() return {
	silence = "Безмолвие",
	silence_desc = "Предупреждать о безмолвии",

	starttrigger1 = "Стань на колени, червь!",  --check this
	starttrigger2 = "Убейте их во имя господина!",  --!!check this again
	starttrigger3 = "Вам не скрыться от меня!",  
	starttrigger4 = "Бегите, пока еще можете!!",  

	startwarn = "Великая вдова Фарлина злится, 60 секунд до бешенства!",
	enragewarn15sec = "15 секунд до Бешенства!",
	enragewarn = "Бешенство!",
	enragewarn2 = "Скоро бешенство!",
	enrageremovewarn = "Бешенство снято! ~60 секунд до следующего!",

	silencewarn = "Безмолвие! Задержка ярости!",
	silencewarn5sec = "Безмолвие закончится через 5 секунд",
	silencebar = "Безмолвие",

	rain = "Огненный ливень на Вас!",
	rain_desc = "Предупреждать об Огненном ливне.",
	rain_message = "Огненный ливень на ВАС!",
} end )

L:RegisterTranslations("deDE", function() return {
	silence = "Stille",
	silence_desc = "Warnung vor Stille",

	starttrigger1 = "Kniet nieder, Wurm!",
	starttrigger2 = "T\195\182tet sie im Namen des Meisters!",
	starttrigger3 = "Ihr k\195\182nnt euch nicht vor mir verstecken!",
	starttrigger4 = "Flieht, solange ihr noch k\195\182nnt.",

	startwarn = "Gro\195\159witwe Faerlina angegriffen! Wutanfall in 60 Sekunden!",
	enragewarn15sec = "Wutanfall in 15 Sekunden!",
	enragewarn = "Wutanfall!",
	enrageremovewarn = "Wutanfall vorbei! N\195\164chster in ~60 Sekunden!",
	silencewarn = "Stille! Wutanfall verz\195\182gert!",
	enragewarn2 = "Wutanfall bald!",
	silencewarn5sec = "Stille endet in 5 Sekunden",

	silencebar = "Stille",

	rain = "Feuerregen auf dir",
	rain_desc = "Warnung, wenn du in einem Feuerregen bist.",
	rain_message = "Feuerregen auf DIR!",
} end )

L:RegisterTranslations("koKR", function() return {
	silence = "침묵",
	silence_desc = "침묵을 알립니다.",

	starttrigger1 = "내 앞에 무릎을 꿇어라, 벌레들아!",
	starttrigger2 = "주인님의 이름으로 처단하라!",
	starttrigger3 = "나에게서 도망칠 수는 없다!",
	starttrigger4 = "두 발이 성할 때 도망쳐라!",

	startwarn = "귀부인 팰리나 전투 시작! 60초 후 격노!",
	enragewarn15sec = "15초 후 격노!",
	enragewarn = "격노!",
	enragewarn2 = "잠시 후 격노!",
	enrageremovewarn = "격노 사라짐! 약 ~60초 후 다음 격노",

	silencewarn = "침묵!",
	silencewarn5sec = "5초 후 침묵 종료!",
	silencebar = "침묵",

	rain = "자신의 불의 비",
	rain_desc = "자신이 불의 비에 걸렸을 때 알립니다.",
	rain_message = "당신은 불의 비!",
} end )

L:RegisterTranslations("zhCN", function() return {
	silence = "沉默",
	silence_desc = "当施放沉默时发出警报。",

	starttrigger1 = "跪下求饶吧，懦夫！",
	starttrigger2 = "以主人之名，杀了他们！",
	starttrigger3 = "休想从我面前逃掉！",
	starttrigger4 = "逃啊！有本事就逃啊！",

	startwarn = "黑女巫法琳娜已激活 - 60秒后，激怒！",
	enragewarn15sec = "15秒后，激怒！",
	enragewarn = "激怒！",
	enragewarn2 = "即将 激怒！",
	enrageremovewarn = "激怒已移除 - 约60后，激怒！",
	silencewarn = "沉默！延缓了激怒！",
	silencewarn5sec = "5秒后沉默结束！",

	silencebar = "<沉默>",

	rain = "自身火焰之雨",
	rain_desc = "当你中了火焰之雨时发出自身警报。",
	rain_message = ">你< 火焰之雨！",
} end )

L:RegisterTranslations("zhTW", function() return {
	silence = "沉默",
	silence_desc = "當施放沉默時發出警報。",

	starttrigger1 = "跪下求饒吧，懦夫！",
	starttrigger2 = "以主人之名，殺了他們！",
	starttrigger3 = "休想從我面前逃掉！",
	starttrigger4 = "逃啊！有本事就逃啊！",

	startwarn = "大寡婦費琳娜已進入戰鬥 - 60秒後，狂怒！",
	enragewarn15sec = "15秒後，狂怒！",
	enragewarn = "狂怒！",
	enragewarn2 = "即將 狂怒！",
	enrageremovewarn = "狂怒已移除 - 約60秒後，狂怒！",
	silencewarn = "沉默！延緩了狂怒！",
	silencewarn5sec = "5秒後沉默結束！",

	silencebar = "<沉默>",

	rain = "自身火焰之雨",
	rain_desc = "當你中了火焰之雨時發出自身警報。",
	rain_message = ">你< 火焰之雨！",
} end )

L:RegisterTranslations("frFR", function() return {
	silence = "Silence",
	silence_desc = "Prévient de l'arrivée des silences.",

	starttrigger1 = "À genoux, vermisseau !",
	starttrigger2 = "Tuez-les au nom du maître !",
	starttrigger3 = "Vous ne pouvez pas m'échapper !",
	starttrigger4 = "Fuyez tant que vous le pouvez !",

	startwarn = "Grande veuve Faerlina engagée, 60 sec. avant Frénésie !",
	enragewarn15sec = "15 sec. avant Frénésie !",
	enragewarn = "Frénésie !",
	enragewarn2 = "Frénésie imminente !",
	enrageremovewarn = "Frénésie enlevée ! %d sec. avant la suivante !",

	silencewarn = "Réduite au silence !",
	silencewarn5sec = "Fin du silence dans 5 sec.",
	silencebar = "Silence",

	rain = "Pluie de feu sur vous",
	rain_desc = "Prévient quand vous vous trouvez sous une Pluie de feu.",
	rain_message = "Pluie de feu sur VOUS !",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15953
mod.toggleoptions = {"silence", "rain", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Silence", 28732, 54097)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Rain", 28794, 54099)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Enrage", 28798, 54100) --Norm/Heroic
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	started = nil

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Silence(unit, spellID)
	if not UnitIsUnit(unit, boss) then return end
	if not enraged then
		-- preemptive, 30s silence
		if self.db.profile.silence then
			self:IfMessage(L["silencewarn"], "Positive", spellID)
			self:Bar(L["silencebar"], 30, spellID)
			self:DelayedMessage(25, L["silencewarn5sec"], "Urgent")
		end
	else
		-- Reactive enrage removed
		if self.db.profile.enrage then
			self:Message(L["enrageremovewarn"], "Positive")
			enrageMessageId = self:DelayedMessage(45, L["enragewarn2"], "Important")
			self:Bar(enrageName, 60, 28798)
		end
		if self.db.profile.silence then
			self:Bar(L["silencebar"], 30, spellID)
			self:DelayedMessage(25, L["silencewarn5sec"], "Urgent")
 		end
		enraged = nil
	end
end

function mod:Rain(player)
	if player == pName and self.db.profile.rain then
		self:LocalMessage(L["rain_message"], "Personal", 54099, "Alarm")
	end
end

function mod:Enrage(unit, spellID, _, _, spellName)
	if not UnitIsUnit(unit, boss) then return end
	if self.db.profile.enrage then
		self:IfMessage(L["enragewarn"], "Urgent", spellID)
	end
	self:TriggerEvent("BigWigs_StopBar", self, enrageName)
	self:CancelScheduledEvent(enrageMessageId) 
	enraged = true
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if not started and (msg == L["starttrigger1"] or msg == L["starttrigger2"] or msg == L["starttrigger3"] or msg == L["starttrigger4"]) then
		self:Message(L["startwarn"], "Urgent")
		if self.db.profile.enrage then
			enrageMessageId = self:DelayedMessage(45, L["enragewarn2"], "Important")
			self:Bar(enrageName, 60, 28798)
		end
		started = true --If I remember right, we need this as she sometimes uses an engage trigger mid-fight
		enraged = nil
	end
end


