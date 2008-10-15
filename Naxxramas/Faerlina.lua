------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Grand Widow Faerlina"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started = nil
local enragetime = 60
local enrageTimerStarted = 0
local silencetime = 30
local enraged = nil
local enrageName = GetSpellInfo(5228)

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

	startwarn = "Grand Widow Faerlina engaged, 60 seconds to enrage!",
	enragewarn15sec = "15 seconds until enrage!",
	enragewarn = "Enrage!",
	enrageremovewarn = "Enrage removed! %d seconds until next!",
	silencewarn = "Silence! Delaying Enrage!",
	silencewarnnodelay = "Silence!",
	silencewarn5sec = "Silence ends in 5 sec",

	silencebar = "Silence",
} end )

L:RegisterTranslations("deDE", function() return {
	silence = "Stille",
	silence_desc = "Warnung vor Stille",

	starttrigger1 = "Kniet nieder, Wurm!",
	starttrigger2 = "T\195\182tet sie im Namen des Meisters!",
	starttrigger3 = "Ihr k\195\182nnt euch nicht vor mir verstecken!",
	starttrigger4 = "Flieht, solange ihr noch k\195\182nnt",

	startwarn = "Gro\195\159witwe Faerlina angegriffen! Wutanfall in 60 Sekunden!",
	enragewarn15sec = "Wutanfall in 15 Sekunden!",
	enragewarn = "Wutanfall!",
	enrageremovewarn = "Wutanfall vorbei! N\195\164chster in %d Sekunden!",
	silencewarn = "Stille! Wutanfall verz\195\182gert!",
	silencewarnnodelay = "Stille!",
	silencewarn5sec = "Stille endet in 5 Sekunden",

	silencebar = "Stille",
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
	enrageremovewarn = "격노 사라짐! 약 %d초 후 다음 격노",
	silencewarn = "침묵! 격노 지연!",
	silencewarnnodelay = "침묵!",
	silencewarn5sec = "5초 후 침묵 종료!",

	silencebar = "침묵",
} end )

L:RegisterTranslations("zhCN", function() return {
	silence = "沉默",
	silence_desc = "当施放沉默时发出警报。",

	starttrigger1 = "跪下求饶吧，懦夫！",
	starttrigger2 = "以主人之名，杀了他们！",
	starttrigger3 = "休想从我面前逃掉！",
	starttrigger4 = "逃啊！有本事就逃啊！",

	startwarn = "黑女巫法琳娜已激活 - 60秒后激怒！",
	enragewarn15sec = "15秒后激怒！",
	enragewarn = "激怒！",
	enrageremovewarn = "激怒已移除 - %d后激怒！",
	silencewarn = "沉默！延缓了激怒！",
	silencewarnnodelay = "沉默！",
	silencewarn5sec = "5秒后沉默结束！",

	silencebar = "<沉默>",
} end )

L:RegisterTranslations("zhTW", function() return {
	silence = "沉默警報",
	silence_desc = "沉默警報",

	starttrigger1 = "跪下求饒吧，懦夫！",
	starttrigger2 = "以主人之名，殺了他們！",
	starttrigger3 = "休想從我面前逃掉！",
	starttrigger4 = "逃啊！有本事就逃啊！",

	startwarn = "大寡婦費琳娜已進入戰鬥 - 60 秒後狂怒！",
	enragewarn15sec = "15 秒後狂怒！",
	enragewarn = "狂怒！",
	enrageremovewarn = "狂怒已移除 - %d 秒後再次狂怒",
	silencewarn = "沉默！延緩了狂怒！",
	silencewarnnodelay = "沉默！",
	silencewarn5sec = "5 秒後沉默結束！",

	silencebar = "沉默",
} end )

L:RegisterTranslations("frFR", function() return {
	silence = "Silence",
	silence_desc = "Préviens de l'arrivée des Silences.",

	starttrigger1 = "À genoux, vermisseau !",
	starttrigger2 = "Tuez-les au nom du maître !",
	starttrigger3 = "Vous ne pouvez pas m'échapper !",
	starttrigger4 = "Fuyez tant que vous le pouvez !",

	startwarn = "Grande veuve Faerlina engagée, 60 sec. avant Enrager !",
	enragewarn15sec = "15 sec. avant Enrager !",
	enragewarn = "Enragée !",
	enrageremovewarn = "Enrager enlevé ! %d sec. avant le suivant !",
	silencewarn = "Silence ! Enrager retardé !",
	silencewarnnodelay = "Silence !",
	silencewarn5sec = "Silence dans 5 sec.",

	silencebar = "Silence",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15953
mod.toggleoptions = {"silence", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Silence", 28732)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Enrage", 28798)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	enragetime = 60
	enrageTimerStarted = 0
	silencetime = 30
	enraged = nil
	started = nil

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Silence(unit, spellID)
	if not UnitIsUnit(unit, boss) then return end

	if not enraged then -- preemptive, 30s silence

		--[[ The enrage timer should only be reset if it's less than 30sec
		to her next enrage, because if you silence her when there's 30+
		sec to the enrage, it won't actually stop her from enraging. ]]

		local currentTime = GetTime()

		if self.db.profile.silence then
			if (enrageTimerStarted + 30) < currentTime then
				self:IfMessage(L["silencewarnnodelay"], "Urgent", spellID)
			else
				self:IfMessage(L["silencewarn"], "Urgent", spellID)
			end
			self:Bar(L["silencebar"], silencetime, spellID)
			self:ScheduleEvent("bwfaerlinasilence5", "BigWigs_Message", silencetime -5, L["silencewarn5sec"], "Urgent")
		end
		if (enrageTimerStarted + 30) < currentTime then
			if self.db.profile.enrage then
				-- We SHOULD reset the enrage timer, since it's more than 30
				-- sec since enrage started. This is only visuals ofcourse.
				self:TriggerEvent("BigWigs_StopBar", self, enrageName)
				self:CancelScheduledEvent("bwfaerlinaenrage15")
				self:ScheduleEvent("bwfaerlinaenrage15", "BigWigs_Message", silencetime - 15, L["enragewarn15sec"], "Important")
				self:Bar(enrageName, silencetime, spellID)
			end
			enrageTimerStarted = currentTime
		end
	else -- Reactive enrage removed
		if self.db.profile.enrage then
			self:Message(L["enrageremovewarn"]:format(enragetime), "Urgent")
		end
		if self.db.profile.silence then
			self:Bar(L["silencebar"], silencetime, spellID)
			self:ScheduleEvent("bwfaerlinasilence5", "BigWigs_Message", silencetime -5, L["silencewarn5sec"], "Urgent")
 		end
		enraged = nil
	end
end

function mod:Enrage(unit, spellID, _, _, spellName)
	if not UnitIsUnit(unit, boss) then return end
	if spellName ~= enrageName then return end
	BigWigs:Print("Post this on forums: "..spellID)

	if self.db.profile.enrage then
		self:IfMessage(L["enragewarn"], "Urgent", spellID)
	end
	self:TriggerEvent("BigWigs_StopBar", self, enrageName)
	self:CancelScheduledEvent("bwfaerlinaenrage15") 
	if self.db.profile.enrage then
		self:Bar(enrageName, enragetime, spellID)
		self:ScheduleEvent("bwfaerlinaenrage15", "BigWigs_Message", enragetime - 15, L["enragewarn15sec"], "Important")
	end
	enrageTimerStarted = GetTime()
	enraged = true
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if not started and (msg == L["starttrigger1"] or msg == L["starttrigger2"] or msg == L["starttrigger3"] or msg == L["starttrigger4"]) then
		enragetime = 60
		enrageTimerStarted = 0
		silencetime = 30
		enraged = nil
		self:Message(L["startwarn"], "Urgent")
		if self.db.profile.enrage then
			self:ScheduleEvent("bwfaerlinaenrage15", "BigWigs_Message", enragetime - 15, L["enragewarn15sec"], "Important")
			self:Bar(enrageName, enragetime, "Spell_Shadow_UnholyFrenzy")
		end
		enrageTimerStarted = GetTime()
		started = true --If I remember right, we need this as she sometimes uses an engage trigger mid-fight
	end
end

