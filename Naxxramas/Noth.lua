------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Noth the Plaguebringer")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "noth",

	blink_cmd = "blink",
	blink_name = "Blink Alert",
	blink_desc = "Warn for blink",

	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for teleport",

	curse_cmd = "curse",
	curse_name = "Curse Alert",
	curse_desc = "Warn for curse",

	starttrigger1 = "Die, trespasser!",
	starttrigger2 = "Glory to the master!",
	starttrigger3 = "Your life is forfeit!",
	startwarn = "Noth the Plaguebringer engaged! 90 seconds till teleport",
	
	addtrigger = "Rise, my soldiers! Rise and fight once more!",

	blinktrigger = "Noth the Plaguebringer gains Blink.",
	blinkwarn = "Blink! Stop DPS!",
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
} end )

L:RegisterTranslations("deDE", function() return {
	starttrigger1 = "Sterbt, Eindringling!",
	starttrigger2 = "Ehre unserem Meister!",
	starttrigger3 = "Euer Leben ist verwirkt!",
	startwarn = "Noth engaged! 90 Sekunden bis Teleport!",

	blinktrigger = "Noth der Seuchenf\195\188rst bekommt 'Blinzeln'.",
	blinkwarn = "Stop DPS!",
	blinkwarn2 = "Blink in ~5 s!",
	blinkbar = "Blink",

	teleportwarn = "Teleport! Er ist auf dem Balkon!",
	teleportwarn2 = "Teleport in 10 Sekunden!",

	teleportbar = "Teleport!",
	backbar = "R\195\188ckteleport!",
		
	backwarn = "Er ist wieder im Raum! DPS f\195\188r %d Sekunden.",
	backwarn2 = "10 Sekunden bis R\195\188ckteleport!",
    
	cursetrigger = "von Fluch des Seuchenf\195\188rsten betroffen",
	cursewarn	 = "Fluch! N\195\164chster in ~55 Sekunden",
	curse10secwarn = "Fluch in ~10 Sekunden",
		
	cursebar = "Fluch",
} end )

L:RegisterTranslations("koKR", function() return {
	starttrigger1 = "죽어라, 침입자들아!",
	starttrigger2 = "주인님께 영광을!",
	starttrigger3 = "너희 생명은 끝이다!",
	startwarn = "역병술사 노스와 전투 시작! 90초후 순간이동",		
	-- "이제 숨을 거두어라!",
	
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
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsNoth = BigWigs:NewModule(boss)
BigWigsNoth.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsNoth.enabletrigger = boss
BigWigsNoth.toggleoptions = {"blink", "teleport", "curse", "bosskill"}
BigWigsNoth.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsNoth:OnEnable()
	self.timeroom = 90
	self.timebalcony = 70
	self.cursetime = 55
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
end


function BigWigsNoth:Curse( msg )
	if string.find(msg, L"cursetrigger") and not self.prior then
		self:TriggerEvent("BigWigs_SendSync", "NothCurse")
	end
end

function BigWigsNoth:CHAT_MSG_MONSTER_YELL( msg )
	if msg == L"starttrigger1" or msg == L"starttrigger2" or msg == L"starttrigger3" then
		self.timeroom = 90
		self.timebalcony = 70
		
		if self.db.profile.teleport then
			self:TriggerEvent("BigWigs_Message", L"startwarn", "Red")
			self:ScheduleEvent("BigWigs_Message", self.timeroom-10, L"teleportwarn2", "Orange")
			self:TriggerEvent("BigWigs_StartBar", self, L"teleportbar", self.timeroom, 0, "Interface\\Icons\\Spell_Magic_LesserInvisibilty", "Green", "Yellow", "Orange", "Red")
		end
		self:ScheduleEvent(self.teleportToBalcony, self.timeroom, self)
	end
end

function BigWigsNoth:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if msg == L"blinktrigger" then
		self:TriggerEvent("BigWigs_SendSync", "NothBlink")
	end
end

function BigWigsNoth:BigWigs_RecvSync( sync )
	if sync == "NothCurse" then
		if self.db.profile.curse then
			self:TriggerEvent("BigWigs_Message", L"cursewarn", "Red", nil, "Alarm")
			self:ScheduleEvent("bwnothcurse", "BigWigs_Message", self.cursetime-10, L"curse10secwarn", "Orange")
			self:TriggerEvent("BigWigs_StartBar", self, L"cursebar", self.cursetime, 1, "Interface\\Icons\\Spell_Shadow_AnimateDead", "Green", "Yellow", "Orange", "Red")
		end
		self.prior = true
	elseif sync == "NothBlink" then
		if self.db.profile.blink then
			self:TriggerEvent("BigWigs_Message", L"blinkwarn", "Red")
			self:ScheduleEvent("bwnothblink", "BigWigs_Message", 25, L"blinkwarn2", "Yellow")
			self:TriggerEvent("BigWigs_StartBar", self, L"blinkbar", 30, 2, "Interface\\Icons\\Spell_Arcane_Blink", "Yellow", "Orange", "Red")
		end
	end
end

function BigWigsNoth:BigWigs_Message(text)
	if text == L"curse10secwarn" then self.prior = nil end
end


function BigWigsNoth:teleportToBalcony()
	if self.timeroom == 90 then
		self.timeroom = 110
	elseif self.timeroom == 110 then
		self.timeroom = 180
	end

	self:CancelScheduledEvent("bwnothblink")
	self:CancelScheduledEvent("bwnothcurse")
	self:TriggerEvent("BigWigs_StopBar", self, L"blinkbar")
	self:TriggerEvent("BigWigs_StopBar", self, L"cursebar")
	
	if self.db.profile.teleport then 
		self:TriggerEvent("BigWigs_Message", L"teleportwarn", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"backbar", self.timebalcony, 0, "Interface\\Icons\\Spell_Magic_LesserInvisibilty", "Green", "Yellow", "Orange", "Red")
		self:ScheduleEvent("bwnothback", "BigWigs_Message", self.timebalcony - 10, L"backwarn2", "Orange")
	end
	self:ScheduleEvent(self.teleportToRoom, self.timebalcony, self)
end

function BigWigsNoth:teleportToRoom()
	if self.timebalcony == 70 then
		self.timebalcony = 95
	elseif self.timebalcony == 95 then
		self.timebalcony = 120
	end	
	
	if self.db.profile.teleport then
		self:TriggerEvent("BigWigs_Message", string.format(L"backwarn", self.timeroom), "Red")
		self:TriggerEvent("BigWig_StartBar", self, L"teleportbar", self.timeroom, 0, "Interface\\Icons\\Spell_Magic_LesserInvisibilty", "Green", "Yellow", "Orange", "Red")
		self:ScheduleEvent("bwnothteleport", "BigWigs_Message", self.timeroom - 10, L"teleportwarn2", "Orange")
	end

	self:ScheduleEvent(self.teleportToBalcony, self.timeroom, self)
end
