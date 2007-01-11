------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Instructor Razuvious"]
local understudy = AceLibrary("Babble-Boss-2.2")["Deathknight Understudy"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Razuvious",

	shout_cmd = "shout",
	shout_name = "Shout Alert",
	shout_desc = "Warn for disrupting shout",

	shieldwall_cmd = "shieldwall",
	shieldwall_name = "Shield Wall Timer",
	shieldwall_desc = "Show timer for shieldwall",

	startwarn = "Instructor Razuvious engaged! ~25sec to shout!",

	starttrigger1 = "The time for practice is over! Show me what you have learned!",
	starttrigger2 = "Sweep the leg... Do you have a problem with that?",
	starttrigger3 = "Show them no mercy!",
	starttrigger4 = "Do as I taught you!",

	shouttrigger = "Disrupting Shout",
	shout7secwarn = "7 sec to Disrupting Shout",
	shout3secwarn = "3 sec to Disrupting Shout!",
	shoutwarn = "Disrupting Shout!",
	noshoutwarn = "No shout! Next in ~20secs",
	shoutbar = "Disrupting Shout",

	shieldwalltrigger   = "Deathknight Understudy gains Shield Wall.",
	shieldwallbar       = "Shield Wall",
} end )

L:RegisterTranslations("deDE", function() return {
	shout_name = "Unterbrechungsruf",
	shout_desc = "Warnung, wenn Instruktor Razuvious Unterbrechungsruf wirkt.",

	shieldwall_name = "Schildwall",
	shieldwall_desc = "Timer f\195\188r Schildwall.",

	startwarn = "Instruktor Razuvious angegriffen! Unterbrechungsruf in ~25 Sekunden!",

	starttrigger1 = "Die Zeit des \195\156bens ist vorbei! Zeigt mir, was ihr gelernt habt!",
	starttrigger2 = "Streckt sie nieder... oder habt ihr ein Problem damit?",
	starttrigger3 = "Lasst keine Gnade walten!",
	starttrigger4 = "Befolgt meine Befehle!",

	shouttrigger = "Unterbrechungsruf",
	shout7secwarn = "Unterbrechungsruf in 7 Sekunden!",
	shout3secwarn = "Unterbrechungsruf in 3 Sekunden!",
	shoutwarn = "Unterbrechungsruf!",
	noshoutwarn = "Kein Ruf! N\195\164chster in ~20 Sekunden",
	shoutbar = "Unterbrechungsruf",

	shieldwalltrigger   = "Reservist der Todesritter bekommt 'Schildwall'.",
	shieldwallbar       = "Schildwall",
} end )

L:RegisterTranslations("koKR", function() return {
	shout_name = "외침 경고",
	shout_desc = "분열의 외침에 대한 경고",

	shieldwall_name = "방패의 벽 타이머",
	shieldwall_desc = "방패의 벽에 대한 타이머 표시",

	startwarn = "훈련교관 라주비어스 광폭화! 외침까지 25초!",

	starttrigger1 = "훈련은 끝났다!",
	starttrigger2 = "다리를 후려 차라! 무슨 문제 있나?",
	starttrigger3 = "절대 봐주지 마라!",
	starttrigger4 = "훈련받은 대로 해!",

	shouttrigger = "훈련교관 라주비어스|1이;가; 분열의 외침|1으로;로; (.+)에게 (.+)의 피해를 입혔습니다.",
	shout7secwarn = "7초후 분열의 외침!",
	shout3secwarn = "3초후 분열의 외침!",
	shoutwarn = "분열의 외침!",
	noshoutwarn = "외침 사라짐! 다음은 20초 후",
	shoutbar = "분열의 외침",

	shieldwalltrigger   = "죽음의 기사 수습생|1이;가; 방패의 벽 효과를 얻었습니다.", -- CHECK
	shieldwallbar       = "방패의 벽",
} end )

L:RegisterTranslations("zhCN", function() return {
	shout_name = "怒吼警报",
	shout_desc = "瓦解怒吼警报",

	shieldwall_name = "盾墙计时器",
	shieldwall_desc = "盾墙计时器",

	startwarn = "教官拉苏维奥斯已激活，~25秒后瓦解怒吼",

	starttrigger1 = "练习时间到此为止！都拿出真本事来！",
	starttrigger2 = "绊腿……有什么问题么？",
	starttrigger3 = "仁慈无用！",
	starttrigger4 = "按我教导的去做！",

	shouttrigger = "瓦解怒吼",
	shout7secwarn = "7秒后发动瓦解怒吼",
	shout3secwarn = "3秒后发动瓦解怒吼！",
	shoutwarn = "瓦解怒吼！",
	noshoutwarn = "没有怒吼，下次在~20秒后发动",
	shoutbar = "瓦解怒吼",

	shieldwalltrigger   = "死亡骑士学员获得了盾墙的效果。",
	shieldwallbar       = "盾墙",
} end )

L:RegisterTranslations("zhTW", function() return {
	shout_name = "怒吼警報",
	shout_desc = "混亂怒吼警報",

	shieldwall_name = "盾牆計時器",
	shieldwall_desc = "盾牆計時器",

	startwarn = "講師拉祖維斯已進入戰鬥 - 25 秒後混亂怒吼",

	starttrigger1 = "練習時間到此為止！都拿出真本事來！",
	starttrigger2 = "絆腿……有什麼問題嗎？",
	starttrigger3 = "仁慈無用！",
	starttrigger4 = "照我教你的做！",

	shouttrigger = "混亂怒吼",
	shout7secwarn = "7秒後發動混亂怒吼",
	shout3secwarn = "3秒後發動混亂怒吼！",
	shoutwarn = "混亂怒吼！",
	noshoutwarn = "沒吼！ 下次在 20 秒後發動",
	shoutbar = "混亂怒吼",

	shieldwalltrigger   = "死亡騎士實習者獲得了盾牆的效果。",
	shieldwallbar       = "盾牆",
} end )

L:RegisterTranslations("frFR", function() return {
	starttrigger1 = "Les cours sont termin\195\169s ! Montrez%-moi ce que vous avez appris !",
	starttrigger2 = "Frappe%-le \195\160 la jambe",
	starttrigger3 = "Pas de quartier !",
	starttrigger4 = "Faites ce que vous ai appris !",

	shouttrigger = "Cri perturbant",

	shieldwalltrigger   = "Doublure de chevalier de la mort gagne Mur protecteur.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsRazuvious = BigWigs:NewModule(boss)
BigWigsRazuvious.zonename = AceLibrary("Babble-Zone-2.2")["Naxxramas"]
BigWigsRazuvious.enabletrigger = { boss }
BigWigsRazuvious.wipemobs = { understudy }
BigWigsRazuvious.toggleoptions = {"shout", "shieldwall", "bosskill"}
BigWigsRazuvious.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsRazuvious:OnEnable()
	self.timeShout = 30
	self.prior = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Shout")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Shout")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Shout")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS", "Shieldwall")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS", "Shieldwall")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS", "Shieldwall")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "Shieldwall")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "RazuviousShout", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "RazuviousShieldwall", 5)
end

function BigWigsRazuvious:CHAT_MSG_MONSTER_YELL( msg )
	if msg == L["starttrigger1"] or msg == L["starttrigger2"] or msg == L["starttrigger3"] or msg == L["starttrigger4"] then
		if self.db.profile.shout then
			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Urgent", nil, "Alarm")
			self:ScheduleEvent("bwrazuviousshout7sec", "BigWigs_Message", 18, L["shout7secwarn"], "Attention")
			self:ScheduleEvent("bwrazuviousshout3sec", "BigWigs_Message", 22, L["shout3secwarn"], "Urgent", nil, "Alert")
			self:TriggerEvent("BigWigs_StartBar", self, L["shoutbar"], 25, "Interface\\Icons\\Ability_Warrior_WarCry")
		end
		self:ScheduleEvent("bwrazuviousnoshout", self.noShout, self.timeShout, self )
	end
end

function BigWigsRazuvious:BigWigs_Message(text)
	if text == L["shout7secwarn"] then self.prior = nil end
end

function BigWigsRazuvious:Shieldwall( msg ) 
	if msg:find(L["shieldwalltrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "RazuviousShieldwall")
	end
end

function BigWigsRazuvious:Shout( msg )
	if msg:find(L["shouttrigger"]) and not self.prior then
		self:TriggerEvent("BigWigs_SendSync", "RazuviousShout")
	end
end

function BigWigsRazuvious:noShout()	
	self:CancelScheduledEvent("bwrazuviousnoshout")
	self:ScheduleEvent("bwrazuviousnoshout", self.noShout, self.timeShout - 5, self )
	if self.db.profile.shout then
		self:TriggerEvent("BigWigs_Message", L["noshoutwarn"], "Attention")
		self:ScheduleEvent("bwrazuviousshout7sec", "BigWigs_Message", 13, L["shout7secwarn"], "Attention")
		self:ScheduleEvent("bwrazuviousshout3sec", "BigWigs_Message", 17, L["shout3secwarn"], "Urgent", nil, "Alert")
		self:TriggerEvent("BigWigs_StartBar", self, L["shoutbar"], 20, "Interface\\Icons\\Ability_Warrior_WarCry")
	end
end

function BigWigsRazuvious:BigWigs_RecvSync( sync )
	if sync == "RazuviousShout" then
		self:CancelScheduledEvent("bwrazuviousnoshout")
		self:ScheduleEvent("bwrazuviousnoshout", self.noShout, self.timeShout, self )
		if self.db.profile.shout then
			self:TriggerEvent("BigWigs_Message", L["shoutwarn"], "Urgent", nil, "Alarm")
			self:ScheduleEvent("bwrazuviousshout7sec", "BigWigs_Message", 18, L["shout7secwarn"], "Attention")
			self:ScheduleEvent("bwrazuviousshout3sec", "BigWigs_Message", 22, L["shout3secwarn"], "Urgent", nil, "Alert")
			self:TriggerEvent("BigWigs_StartBar", self, L["shoutbar"], 25, "Interface\\Icons\\Ability_Warrior_WarCry")
		end
		self.prior = true
	elseif sync == "RazuviousShieldwall" then
		if self.db.profile.shieldwall then
			self:TriggerEvent("BigWigs_StartBar", self, L["shieldwallbar"], 20, "Interface\\Icons\\Ability_Warrior_ShieldWall")
		end
	end
end
