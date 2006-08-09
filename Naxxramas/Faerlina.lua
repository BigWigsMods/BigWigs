------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Grand Widow Faerlina")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "faerlina",

	silence_cmd = "silence",
	silence_name = "Silence Alert",
	silence_desc = "Warn for silence",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",

	starttrigger1 = "Kneel before me, worm!",
	starttrigger2 = "Slay them in the master's name!",
	starttrigger3 = "You cannot hide from me!",
	starttrigger4 = "Run while you still can!",

	silencetrigger = "Grand Widow Faerlina is afflicted by Widow's Embrace.", -- EDITED it affects her too.
	enragetrigger = "Grand Widow Faerlina gains Enrage.",
	enragefade = "Enrage fades from Grand Widow Faerlina.",

	startwarn = "Start or Enrage!",
	enragewarn15sec = "15 seconds until enrage!",
	enragewarn = "Enrage!",
	enrageremovewarn = "Enrage removed! %d seconds until next!", -- added
	silencewarn = "Silence! Delaying Enrage!",
	silencewarnnodelay = "Silence!",

	enragebar = "Enrage",
	silencebar = "Silence",
} end )

L:RegisterTranslations("deDE", function() return {
	starttrigger1 = "Kniet nieder, Wurm!",
	starttrigger2 = "T\195\182tet sie im Namen des Meisters!",
	starttrigger3 = "Ihr k\195\182nnt euch nicht vor mir verstecken!",
	starttrigger4 = "Flieht, solange ihr noch k\195\182nnt.",

	silencetrigger = "J\195\188nger von Naxxramas ist von Umarmung der Witwe betroffen.",
	enragetrigger = "Gro\195\159witwe Faerlina bekommt 'Wutanfall'.",

	startwarn = "Start oder Enrage!",
	enragewarn15sec = "15 s bis Enrage!",
	enragewarn = "Enrage!",
	silencewarn = "Silence! Enrage verz\195\182gert!",

	enragebar = "Enrage",
} end )

L:RegisterTranslations("koKR", function() return {
	starttrigger1 = "내 앞에 무릎을 꿇어라, 벌레들아!",
	starttrigger2 = "주인님의 이름으로 처단하라!",
	starttrigger3 = "나에게서 도망칠 수는 없다!",
	starttrigger4 = "두 발이 성할 때 도망쳐라!",
	
	silencetrigger = "낙스라마스 숭배자|1이;가; 귀부인의 은총에 걸렸습니다.",
	enragetrigger = "귀부인 팰리나|1이;가; 격노 효과를 얻었습니다.",
	
	startwarn = "시작 또는 격노!",
	enragewarn15sec = "15초후 격노!",
	enragewarn = "격노!",
	silencewarn = "침묵! 격노 연기!",

	enragebar = "Enrage",
} end )

L:RegisterTranslations("zhCN", function() return {
	silence_name = "沉默警报",
	silence_desc = "沉默警报",

	enrage_name = "激怒警报",
	enrage_desc = "激怒警报",

	starttrigger1 = "跪下求饶吧，懦夫！",
	starttrigger2 = "以主人之名，杀了他们！",
	starttrigger3 = "休想从我面前逃掉！",
	starttrigger4 = "逃啊！有本事就逃啊！",

	silencetrigger = "黑女巫法琳娜受到了黑女巫的拥抱效果的影响。", -- EDITED it affects her too.
	enragetrigger = "黑女巫法琳娜获得了激怒的效果。",
	enragefade = "激怒效果从黑女巫法琳娜身上消失。",

	startwarn = "Start or Enrage!",
	enragewarn15sec = "15秒后激怒！",
	enragewarn = "激怒！",
	enrageremovewarn = "激怒已移除 - %d后再次激怒", -- added
	silencewarn = "沉默！延缓了激怒！",
	silencewarnnodelay = "沉默！",

	enragebar = "激怒",
	silencebar = "沉默",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsFaerlina = BigWigs:NewModule(boss)
BigWigsFaerlina.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsFaerlina.enabletrigger = boss
BigWigsFaerlina.toggleoptions = {"silence", "enrage", "bosskill"}
BigWigsFaerlina.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsFaerlina:OnEnable()
	self.enragetime = 60
	self.enrageTimerStarted = 0
	self.silencetime = 30
	self.enraged = nil
	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "FaerlinaEnrage", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "FaerlinaSilence", 5)
end

function BigWigsFaerlina:CHAT_MSG_MONSTER_YELL( msg )
	if self.db.profile.enrage and ( msg == L"starttrigger1" or msg == L"starttrigger2" or msg == L"starttrigger3" or msg == L"starttrigger4" ) then
		self:TriggerEvent("BigWigs_Message", L"startwarn", "Orange")
		self:ScheduleEvent("bwfaerlinaenrage15", "BigWigs_Message", self.enragetime - 15, L"enragewarn15sec", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"enragebar", self.enragetime, 1, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy", "Green", "Yellow", "Orange", "Red")
		self.enrageTimerStarted = GetTime()
	end
end

function BigWigsFaerlina:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if msg == L"enragetrigger" then
		self:TriggerEvent("BigWigs_SendSync", "FaerlinaEnrage")
	end
end

function BigWigsFaerlina:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE( msg )
	if msg == L"silencetrigger" then
		self:TriggerEvent("BigWigs_SendSync", "FaerlinaSilence")
	end
end

function BigWigsFaerlina:BigWigs_RecvSync( sync )
	if sync == "FaerlinaEnrage" then
		if self.db.profile.enrage then
			self:TriggerEvent("BigWigs_Message", L"enragewarn", "Orange")
		end
		self:TriggerEvent("BigWigs_StopBar", self, L"enragebar")
		self:CancelScheduledEvent("bwfaerlinaenrage15") 
		self.enraged = true
	elseif sync == "FaerlinaSilence" then
		if not self.enraged then -- preemptive, 30s silence
		
			--[[ The enrage timer should only be reset if it's less than 30sec
			to her next enrage, because if you silence her when there's 30+
			sec to the enrage, it won't actually stop her from enraging. ]]

			local currentTime = GetTime()

			if self.db.profile.enrage then
				if (self.enrageTimerStarted + 30) > currentTime then
					-- We SHOULD reset the enrage timer, since it's more than 30
					-- sec since enrage started.
					self:TriggerEvent("BigWigs_StopBar", self, L"enragebar")
					self:CancelScheduledEvent("bwfaerlinaenrage15")
					self:ScheduleEvent( "bwfaerlinaenrage15", "BigWigs_Message", self.silencetime - 15, L"enragewarn15sec", "Red")
					self:TriggerEvent("BigWigs_StartBar", self, L"enragebar", self.silencetime, 1, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy", "Yellow", "Orange", "Red")
					self.enrageTimerStarted = currentTime
				end
			end

			if self.db.profile.silence then
				if (self.enrageTimerStarted + 30) > currentTime then
					self:TriggerEvent("BigWigs_Message", L"silencewarnnodelay", "Orange")
				else
					self:TriggerEvent("BigWigs_Message", L"silencewarn", "Orange")
				end
				self:TriggerEvent("BigWigs_StartBar", self, L"silencebar", self.silencetime, 2, "Interface\\Icons\\Spell_Holy_Silence", "Green", "Yellow", "Orange", "Red")
			end
		else -- Reactive enrage removed
			if self.db.profile.enrage then
				self:TriggerEvent("BigWigs_Message", string.format(L"enrageremovewarn", self.enragetime), "Orange")
				self:ScheduleEvent("bwfaerlinaenrage15", "BigWigs_Message", self.enragetime - 15, L"enragewarn15sec", "Red")
				self:TriggerEvent("BigWigs_StartBar", self, L"enragebar", self.enragetime, 1, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy", "Green", "Yellow", "Orange", "Red")
				self.enrageTimerStarted = GetTime()
			end
			if self.db.profile.silence then
				self:TriggerEvent("BigWigs_StartBar", self, L"silencebar", self.silencetime, 2, "Interface\\Icons\\Spell_Holy_Silence", "Green", "Yellow", "Orange", "Red")
 			end			
			self.enraged = nil
		end
	end
end
