------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Noth the Plaguebringer")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Noth",

	blink_cmd = "blink",
	blink_name = "Blink Alert",
	blink_desc = "Warn for blink",

	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for teleport",

	curse_cmd = "curse",
	curse_name = "Curse Alert",
	curse_desc = "Warn for curse",

	wave_cmd = "wave",
	wave_name = "Wave Alert",
	wave_desc = "Warn for waves",

	starttrigger1 = "Die, trespasser!",
	starttrigger2 = "Glory to the master!",
	starttrigger3 = "Your life is forfeit!",
	startwarn = "Noth the Plaguebringer engaged! 90 seconds till teleport",

	addtrigger = "Rise, my soldiers! Rise and fight once more!",

	blinktrigger = "Noth the Plaguebringer gains Blink.",
	blinkwarn = "Blink!",
	blinkwarn2 = "Blink in ~5 seconds!",
	blinkbar = "Blink",

	teleportwarn = "Teleport! He's on the balcony!",
	teleportwarn2 = "Teleport in 10 seconds!",

	teleportbar = "Teleport!",
	backbar = "Back in room!",

	backwarn = "He's back in the room for %d seconds!",
	backwarn2 = "10 seconds until he's back in the room!",

	cursetrigger = "afflicted by Curse of the Plaguebringer",
	cursewarn	 = "Curse! next in ~55 seconds",
	curse10secwarn = "Curse in ~10 seconds",

	cursebar = "Next Curse",

	wave1bar = "Wave 1",
	wave2bar = "Wave 2",
} end )

L:RegisterTranslations("deDE", function() return {

	blink_name = "Blinzeln",
	blink_desc = "Warnung, wenn Noth Blinzeln wirkt.",

	teleport_name = "Teleport",
	teleport_desc = "Warnung vor Teleport.",

	curse_name = "Fluch",
	curse_desc = "Warnung, wenn Noth Fluch des Seuchenf\195\188rsten wirkt.",

	starttrigger1 = "Sterbt, Eindringling!",
	starttrigger2 = "Ehre unserem Meister!",
	starttrigger3 = "Euer Leben ist verwirkt!",
	startwarn = "Noth der Seuchenf\195\188rst angegriffen! 90 Sekunden bis Teleport!",

	addtrigger = "Erhebt euch, Soldaten! Erhebt euch und k\195\164mpft erneut!",

	blinktrigger = "Noth der Seuchenf\195\188rst bekommt 'Blinzeln'.",
	blinkwarn = "Blinzeln! Stop DPS!",
	blinkwarn2 = "Blinzeln in ~5 Sekunden!",
	blinkbar = "Blinzeln",

	teleportwarn = "Teleport! Er ist auf dem Balkon!",
	teleportwarn2 = "Teleport in 10 Sekunden!",

	teleportbar = "Teleport!",
	backbar = "R\195\188ckteleport!",

	backwarn = "Er ist wieder im Raum f\195\188r %d Sekunden.",
	backwarn2 = "10 Sekunden bis R\195\188ckteleport!",

	cursetrigger = "von Fluch des Seuchenf\195\188rsten betroffen",
	cursewarn	 = "Fluch! N\195\164chster in ~55 Sekunden",
	curse10secwarn = "Fluch in ~10 Sekunden",

	cursebar = "Fluch",
} end )


L:RegisterTranslations("koKR", function() return {

	blink_name = "점멸 경고",
	blink_desc = "점멸에 대한 경고",

	teleport_name = "순간이동 경고",
	teleport_desc = "순간이동에 대한 경고",

	curse_name = "저주 경고",
	curse_desc = "저주에 대한 경고",

	wave_name = "웨이브 알림",
	wave_desc = "웨이브에 대한 알림",

	starttrigger1 = "죽어라, 침입자들아!",
	starttrigger2 = "주인님께 영광을!",
	starttrigger3 = "너희 생명은 끝이다!",
	startwarn = "역병술사 노스와 전투 시작! 90초후 순간이동",

	addtrigger = "일어나라,병사들이여! 다시 일어나 싸워라!",

	blinktrigger = "역병술사 노스|1이;가; 점멸 효과를 얻었습니다.",
	blinkwarn = "점멸! 공격 금지!",
	blinkwarn2 = "점멸 약 5초후!",
	blinkbar = "점멸",

	teleportwarn = "순간이동! 발코니에 위치!",
	teleportwarn2 = "순간이동 10초후!",

	teleportbar = "순간이동!",
	backbar = "방으로 복귀!",

	backwarn = "방으로 복귀! %d 초간 최대한 공격!!",
	backwarn2 = "10초후 방으로 복귀!",

	cursetrigger = "(.+)|1이;가; 역병술사의 저주에 걸렸습니다.",
	cursewarn	 = "저주! 다음 저주 약 55초후",
	curse10secwarn = "저주 약 10초후",

	cursebar = "다음 저주",	

	wave1bar = "웨이브 1",
	wave2bar = "웨이브 2",
} end )

L:RegisterTranslations("zhCN", function() return {
	blink_name = "闪现术警报",
	blink_desc = "闪现术警报",

	teleport_name = "传送警报",
	teleport_desc = "传送警报",

	curse_name = "诅咒警报",
	curse_desc = "诅咒警报",

	wave_name = "小骷髅警报",
	wave_desc = "警报数波小骷髅",

	starttrigger1 = "死吧，入侵者！",
	starttrigger2 = "荣耀归于我主！",
	starttrigger3 = "我要没收你的生命！",
	startwarn = "瘟疫使者诺斯已激活 - 90秒后传送",

	addtrigger = "起来吧，我的战士们！起来，再为主人尽忠一次！",

	blinktrigger = "瘟疫使者诺斯获得了闪现术的效果。",
	blinkwarn = "闪现术！停止攻击！",
	blinkwarn2 = "5秒后发动闪现术！",
	blinkbar = "闪现术",

	teleportwarn = "传送发动！",
	teleportwarn2 = "10秒后发动传送！",

	teleportbar = "传送！",
	backbar = "回到房间！",

	backwarn = "诺斯回到房间 - %d后再次传送",
	backwarn2 = "10秒后诺斯回到房间！",

	cursetrigger = "受到了瘟疫使者的诅咒效果的影响",
	cursewarn	 = "诅咒 - 55秒后再次发动",
	curse10secwarn = "10秒后发动诅咒！",

	cursebar = "下一次诅咒",
	
	wave1bar = "第一波",
	wave2bar = "第二波",
} end )

L:RegisterTranslations("frFR", function() return {
	starttrigger1 = "Mourez, intrus !",
	starttrigger2 = "Gloire au ma\195\174tre !",
	starttrigger3 = "Vos vies ne valent plus rien !",

	addtrigger = "Rise, my soldiers! Rise and fight once more!", -- TO TRANSLATE need /chatlog

	blinktrigger = "Noth le Porte%-peste gagne Transfert.",

	cursetrigger = "les effets de Mal\195\169diction de Porte%-peste.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsNoth = BigWigs:NewModule(boss)
BigWigsNoth.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsNoth.enabletrigger = boss
BigWigsNoth.toggleoptions = {"blink", "teleport", "curse", "wave", "bosskill"}
BigWigsNoth.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsNoth:OnEnable()
	self.timeroom = 90
	self.timebalcony = 70
	self.cursetime = 55
	self.wave1time = 10
	self.wave2time = 40
	self.prior = nil

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "NothBlink", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "NothCurse", 5)

	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Curse")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Curse")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Curse")
end


function BigWigsNoth:Curse( msg )
	if string.find(msg, L["cursetrigger"]) and not self.prior then
		self:TriggerEvent("BigWigs_SendSync", "NothCurse")
	end
end

function BigWigsNoth:CHAT_MSG_MONSTER_YELL( msg )
	if msg == L["starttrigger1"] or msg == L["starttrigger2"] or msg == L["starttrigger3"] then
		self.timeroom = 90
		self.timebalcony = 70

		if self.db.profile.teleport then
			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Important")
			self:ScheduleEvent("BigWigs_Message", self.timeroom-10, L["teleportwarn2"], "Urgent")
			self:TriggerEvent("BigWigs_StartBar", self, L["teleportbar"], self.timeroom, "Interface\\Icons\\Spell_Magic_LesserInvisibilty")
		end
		self:ScheduleEvent("bwnothtobalcony", self.teleportToBalcony, self.timeroom, self)
	end
end

function BigWigsNoth:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if msg == L["blinktrigger"] then
		self:TriggerEvent("BigWigs_SendSync", "NothBlink")
	end
end

function BigWigsNoth:BigWigs_RecvSync( sync )
	if sync == "NothCurse" then
		if self.db.profile.curse then
			self:TriggerEvent("BigWigs_Message", L["cursewarn"], "Important", nil, "Alarm")
			self:ScheduleEvent("bwnothcurse", "BigWigs_Message", self.cursetime-10, L["curse10secwarn"], "Urgent")
			self:TriggerEvent("BigWigs_StartBar", self, L["cursebar"], self.cursetime, "Interface\\Icons\\Spell_Shadow_AnimateDead")
		end
		self.prior = true
	elseif sync == "NothBlink" then
		if self.db.profile.blink then
			self:TriggerEvent("BigWigs_Message", L["blinkwarn"], "Important")
			self:ScheduleEvent("bwnothblink", "BigWigs_Message", 25, L["blinkwarn2"], "Attention")
			self:TriggerEvent("BigWigs_StartBar", self, L["blinkbar"], 30, "Interface\\Icons\\Spell_Arcane_Blink")
		end
	end
end

function BigWigsNoth:BigWigs_Message(text)
	if text == L["curse10secwarn"] then self.prior = nil end
end

function BigWigsNoth:teleportToBalcony()
	if self.timeroom == 90 then
		self.timeroom = 110
	elseif self.timeroom == 110 then
		self.timeroom = 180
	end

	self:CancelScheduledEvent("bwnothblink")
	self:CancelScheduledEvent("bwnothcurse")
	self:TriggerEvent("BigWigs_StopBar", self, L["blinkbar"])
	self:TriggerEvent("BigWigs_StopBar", self, L["cursebar"])

	if self.db.profile.teleport then 
		self:TriggerEvent("BigWigs_Message", L["teleportwarn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["backbar"], self.timebalcony, "Interface\\Icons\\Spell_Magic_LesserInvisibilty")
		self:ScheduleEvent("bwnothback", "BigWigs_Message", self.timebalcony - 10, L["backwarn2"], "Urgent")
	end
	if self.db.profile.wave then
		self:TriggerEvent("BigWigs_StartBar", self, L["wave1bar"], self.wave1time )
		self:TriggerEvent("BigWigs_StartBar", self, L["wave2bar"], self.wave2time )
	end
	self:ScheduleEvent("bwnothtoroom", self.teleportToRoom, self.timebalcony, self)
	self.wave2time = self.wave2time + 15
end

function BigWigsNoth:teleportToRoom()
	if self.timebalcony == 70 then
		self.timebalcony = 95
	elseif self.timebalcony == 95 then
		self.timebalcony = 120
	end

	if self.db.profile.teleport then
		self:TriggerEvent("BigWigs_Message", string.format(L["backwarn"], self.timeroom), "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["teleportbar"], self.timeroom, "Interface\\Icons\\Spell_Magic_LesserInvisibilty")
		self:ScheduleEvent("bwnothteleport", "BigWigs_Message", self.timeroom - 10, L["teleportwarn2"], "Urgent")
	end
	self.prior = nil
	self:ScheduleEvent("bwnothtobalcony", self.teleportToBalcony, self.timeroom, self)
end

