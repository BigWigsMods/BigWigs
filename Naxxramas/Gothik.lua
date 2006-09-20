------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Gothik the Harvester")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Gothik",

	room_cmd = "room",
	room_name = "Room Arrival Warnings",
	room_desc = "Warn for Gothik's arrival",

	add_cmd = "add",
	add_name = "Add Warnings",
	add_desc = "Warn for adds",

	adddeath_cmd = "adddeath",
	adddeath_name = "Add Death Alert",
	adddeath_desc = "Alerts when an add dies.",

	disabletrigger = "I... am... undone.",

	starttrigger1 = "Foolishly you have sought your own demise.",
	starttrigger2 = "Teamanare shi rikk mannor rikk lok karkun",
	startwarn = "Gothik the Harvester engaged! 4:30 till he's in the room.",

	rider_name = "Unrelenting Rider",
	spectral_rider_name = "Spectral Rider",
	deathknight_name = "Unrelenting Deathknight",
	spectral_deathknight_name = "Spektral Deathknight",
	trainee_name = "Unrelenting Trainee",
	spectral_trainee_name = "Spectral Trainee",

	riderdiewarn = "Rider dead!",
	dkdiewarn = "Death Knight dead!",

	warn1 = "In room in 3 minutes",
	warn2 = "In room in 90 seconds",
	warn3 = "In room in 60 seconds",
	warn4 = "In room in 30 seconds",
	warn5 = "Gothik Incoming in 10 seconds",

	wave = "%d/26: ",

	trawarn = "Trainees in 3 seconds",
	dkwarn = "Deathknight in 3 seconds",
	riderwarn = "Rider in 3 seconds",

	trabar = "Trainee - %d",
	dkbar = "Deathknight - %d",
	riderbar = "Rider - %d",

	inroomtrigger = "I have waited long enough. Now you face the harvester of souls.",
	inroomwarn = "He's in the room!",

	inroombartext = "In Room",
} end )

L:RegisterTranslations("koKR", function() return {

	room_name = "고딕 등장 경고",
	room_desc = "고딕 등장에 대한 경고",

	add_name = "애드 경고",
	add_desc = "애드에 대한 경고",

	adddeath_name = "애드 죽음 알림",
	adddeath_desc = "애드가 죽었을 때 알림.",

	disabletrigger = "내가... 죽는구나.", -- CHECK

	starttrigger1 = "어리석은 것들, 스스로 죽음을 자초하다니!",
	starttrigger2 = "Teamanare shi rikk mannor rikk lok karkun", -- CHECK
	startwarn = "영혼의 착취자 고딕 전투 시작! 4:30 후 고딕 등장.",

	rider_name = "무자비한 죽음의 기병",
	spectral_rider_name = "Spectral 죽음의 기병", -- CHECK
	deathknight_name = "무자비한 죽음의 기사",
	spectral_deathknight_name = "Spektral 죽음의 기사", -- CHECK
	trainee_name = "무자비한 훈련생", -- CHECK
	spectral_trainee_name = "Spectral 훈련생", -- CHECK

	riderdiewarn = "기병 죽음! 무덤조 긴장하세요!",
	dkdiewarn = "죽음의 기사 죽음!",
	
	warn1 = "고딕 등장 3분 전",
	warn2 = "고딕 등장 90초 전",
	warn3 = "고딕 등장 60초 전",
	warn4 = "고딕 등장 30초 전",
	warn5 = "고딕 등장 10초 전",
	
	wave = "%d/26: ",
	
	trawarn = "훈련생 3초후 등장",
	dkwarn = "죽음의 기사 3초후 등장",
	riderwarn = "기병 3초후 등장",

	trabar = "훈련병 - %d",
	dkbar = "죽음의 기사 - %d",
	riderbar = "기병 - %d",
	
	inroomtrigger = "오랫동안 기다려 왔다. 이제 영혼의 착취자를 만날 차례다.", -- CHECK
	inroomwarn = "고딕 등장!!",
	
	inroombartext = "고딕 등장",
} end )

L:RegisterTranslations("deDE", function() return {
	room_name = "Ankunft",
	room_desc = "Warnung, wenn Gothik in den Raum kommt.",

	add_name = "Adds",
	add_desc = "Warnung vor Adds.",

	disabletrigger = "I... am... undone.", -- ?

	starttrigger1 = "Ihr Narren habt euren eigenen Untergang heraufbeschworen.",
	starttrigger2 = "Maz Azgala veni kamil toralar Naztheros zennshinagas.", -- ?
	startwarn = "Gothik der Ernter angegriffen! 4:30 bis er in den Raum kommt!",

	rider_name = "Unerbittlicher Reiter",
	deathknight_name = "Unerbittlicher Todesritter",

	riderdiewarn = "Reiter tot!",
	dkdiewarn = "Todesritter tot!",

	warn1 = "Im Raum in 3 Minuten",
	warn2 = "Im Raum in 90 Sekunden",
	warn3 = "Im Raum in 60 Sekunden",
	warn4 = "Im Raum in 30 Sekunden",
	warn5 = "Gothik im Raum in 10 Sekunden",

	wave = "%d/26: ",

	trawarn = "Lehrlinge in 3 Sekunden",
	dkwarn = "Todesritter in 3 Sekunden",
	riderwarn = "Reiter in 3 Sekunden",

	trabar = "Lehrlinge - %d",
	dkbar = "Todesritter - %d",
	riderbar = "Reiter - %d",

	inroomtrigger = "Ich habe lange genug gewartet. Stellt euch dem Seelenj\195\164ger.", -- ?
	inroomwarn = "Er ist im Raum!",

	inroombartext = "Im Raum",
} end )

L:RegisterTranslations("zhCN", function() return {
	room_name = "进入房间警报",
	room_desc = "收割者戈提克进入房间时发出警报",

	add_name = "增援警报",
	add_desc = "增援警报",

	disabletrigger = "I... am... undone.",

	starttrigger1 = "你愚蠢地寻找自己的困境。",
	starttrigger2 = "Teamanare shi rikk mannor rikk lok karkun",
	startwarn = "收割者戈提克已激活 - 4:30后进入房间",

	riderdiewarn = "骑兵已死亡！",
	dkdiewarn = "死亡骑士已死亡！",

	warn1 = "3分钟后进入房间",
	warn2 = "90秒后进入房间",
	warn3 = "60秒后进入房间",
	warn4 = "30秒后进入房间",
	warn5 = "收割者戈提克10后进入房间！",

	trawarn = "3秒后学徒出现",
	dkwarn = "3秒后死亡骑士出现",
	riderwarn = "3秒后骑兵出现",

	trabar = "学徒 - %d",
	dkbar = "死亡骑士 - %d",
	riderbar = "骑兵 - %d",

	inroomtrigger = "我等待了太久。现在你面对灵魂收割机。",
	inroomwarn = "收割者戈提克进入了房间！",

	inroombartext = "进入房间",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGothik = BigWigs:NewModule(boss)
BigWigsGothik.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsGothik.enabletrigger = { boss, L["rider_name"], L["deathknight_name"], L["trainee_name"],
								L["spectral_rider_name"], L["spectral_deathknight_name"], L["spectral_trainee_name"] }
BigWigsGothik.toggleoptions = { "room", -1, "add", "adddeath", "bosskill" }
BigWigsGothik.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsGothik:OnEnable()
	self.wave = 0
	self.tratime = 27
	self.dktime = 77
	self.ridertime = 137

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

function BigWigsGothik:CHAT_MSG_COMBAT_HOSTILE_DEATH( msg )
	if self.db.profile.adddeath and msg == string.format(UNITDIESOTHER, L["rider_name"]) then
		self:TriggerEvent("BigWigs_Message", L["riderdiewarn"], "Red")
	elseif self.db.profile.adddeath and msg == string.format(UNITDIESOTHER, L["deathknight_name"]) then
		self:TriggerEvent("BigWigs_Message", L["dkdiewarn"], "Red")
	end
end

function BigWigsGothik:StopRoom()
	self:TriggerEvent("BigWigs_StopBar", self, L["inroombartext"])
	self:CancelScheduledEvent("bwgothikwarn1")
	self:CancelScheduledEvent("bwgothikwarn2")
	self:CancelScheduledEvent("bwgothikwarn3")
	self:CancelScheduledEvent("bwgothikwarn4")
	self:CancelScheduledEvent("bwgothikwarn5")
	self:TriggerEvent("BigWigs_StopBar", self, L["trabar"])
	self:TriggerEvent("BigWigs_StopBar", self, L["dkbar"])
	self:TriggerEvent("BigWigs_StopBar", self, L["riderbar"])
	self:CancelScheduledEvent("bwgothiktrawarn")
	self:CancelScheduledEvent("bwgothikdkwarn")
	self:CancelScheduledEvent("bwgothikriderwarn")
	self:CancelScheduledEvent("bwgothiktrarepop")
	self:CancelScheduledEvent("bwgothikdkrepop")
	self:CancelScheduledEvent("bwgothikriderrepop")
end

function BigWigsGothik:WaveWarn(message, L, color)
	self.wave = self.wave + 1
	if self.db.profile.add then self:TriggerEvent("BigWigs_Message", string.format(L["wave"], self.wave) .. message, color) end
end

function BigWigsGothik:Trainee()
	if self.db.profile.add then
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["trabar"], self.tranum), self.tratime, "Interface\\Icons\\Ability_Seal", "Yellow", "Orange", "Red")
	end
	self:ScheduleEvent("bwgothiktrawarn", self.WaveWarn, self.tratime - 3, self, L["trawarn"], L, "Yellow")
	self:ScheduleRepeatingEvent("bwgothiktrarepop", self.Trainee, self.tratime, self)
	self.tranum = self.tranum + 1
end

function BigWigsGothik:DeathKnight()
	if self.db.profile.add then
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["dkbar"], self.dknum), self.dktime, "Interface\\Icons\\INV_Boots_Plate_08", "Yellow", "Orange", "Red")
	end
	self:ScheduleEvent("bwgothikdkwarn", self.WaveWarn, self.dktime - 3, self, L["dkwarn"], L, "Orange")
	self:ScheduleRepeatingEvent("bwgothikdkrepop", self.DeathKnight, self.dktime, self)
	self.dknum = self.dknum + 1
end

function BigWigsGothik:Rider()
	if self.db.profile.add then
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["riderbar"], self.ridernum), self.ridertime, "Interface\\Icons\\Spell_Shadow_DeathPact", "Yellow", "Orange", "Red")
	end
	self:ScheduleEvent("bwgothikriderwarn", self.WaveWarn, self.ridertime - 3, self, L["riderwarn"], L, "Red")
	self:ScheduleRepeatingEvent("bwgothikriderrepop", self.Rider, self.ridertime, self)
	self.ridernum = self.ridernum + 1
end

function BigWigsGothik:CHAT_MSG_MONSTER_YELL( msg )
	if msg == L["starttrigger1"] or msg == L["starttrigger2"] then
		if self.db.profile.room then
			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Red")
			self:TriggerEvent("BigWigs_StartBar", self, L["inroombartext"], 270, "Interface\\Icons\\Spell_Magic_LesserInvisibilty", "Green", "Yellow", "Orange", "Red")
			self:ScheduleEvent("bwgothikwarn1", "BigWigs_Message", 90, L["warn1"], "Green")
			self:ScheduleEvent("bwgothikwarn2", "BigWigs_Message", 180, L["warn2"], "Yellow")
			self:ScheduleEvent("bwgothikwarn3", "BigWigs_Message", 210, L["warn3"], "Orange")
			self:ScheduleEvent("bwgothikwarn4", "BigWigs_Message", 240, L["warn4"], "Red")
			self:ScheduleEvent("bwgothikwarn5", "BigWigs_Message", 260, L["warn5"], "Red")
		end
		self.tranum = 1
		self.dknum = 1
		self.ridernum = 1
		if self.db.profile.add then
			self:Trainee()
			self:DeathKnight()
			self:Rider()
		end
		-- set the new times
		self.tratime = 20
		self.dktime = 25
		self.ridertime = 30
	elseif msg == L["inroomtrigger"] then
		if self.db.profile.room then self:TriggerEvent("BigWigs_Message", L["inroomwarn"], "Red") end
		self:StopRoom()
	elseif string.find(msg, L["disabletrigger"]) then
		if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.0"):new("BigWigs")("%s has been defeated"), boss), "Green", nil, "Victory") end
		self.core:ToggleModuleActive(self, false)
	end
end

