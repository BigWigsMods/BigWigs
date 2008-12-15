------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Gothik the Harvester"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Gothik",

	room = "Room Arrival Warnings",
	room_desc = "Warn for Gothik's arrival",

	add = "Add Warnings",
	add_desc = "Warn for adds",

	adddeath = "Add Death Alert",
	adddeath_desc = "Alerts when an add dies.",

	starttrigger1 = "Foolishly you have sought your own demise.",
	starttrigger2 = "Teamanare shi rikk mannor rikk lok karkun",
	startwarn = "Gothik the Harvester engaged! 4:30 till he's in the room.",

	rider = "Unrelenting Rider",
	spectral_rider = "Spectral Rider",
	deathknight = "Unrelenting Deathknight",
	spectral_deathknight = "Spektral Deathknight",
	trainee = "Unrelenting Trainee",
	spectral_trainee = "Spectral Trainee",

	riderdiewarn = "Rider dead!",
	dkdiewarn = "Death Knight dead!",

	warn1 = "In room in 3 min",
	warn2 = "In room in 90 sec",
	warn3 = "In room in 60 sec",
	warn4 = "In room in 30 sec",
	warn5 = "Gothik Incoming in 10 sec",

	wave = "%d: ",

	trawarn = "Trainees in 3 sec",
	dkwarn = "Deathknight in 3 sec",
	riderwarn = "Rider in 3 sec",

	trabar = "Trainee - %d",
	dkbar = "Deathknight - %d",
	riderbar = "Rider - %d",

	inroomtrigger = "I have waited long enough. Now you face the harvester of souls.",
	inroomwarn = "He's in the room!",

	inroombartext = "In Room",
} end )

L:RegisterTranslations("ruRU", function() return {
	room = "Прибытие Готика",
	room_desc = "Сообщать о прибытии Готика",

	add = "Появление помощников",
	add_desc = "Сообщать о появлении помощников",

	adddeath = "Помощник уничтожен",
	adddeath_desc = "Сообщать о смерти аддов.",

	starttrigger1 = "Добро пожаловать в страну дураков таких же, как вы.",  --check this
	starttrigger2 = "Я очень долго ждал. Положите свою душу в мой комбайн и будем вам дерево с золотыми монетами.",  --check this
	startwarn = "Готик в ярости! 4:30 до входа в комнату.",

	rider = "Неодолимый всадник",
	spectral_rider = "Призрачный всадник",
	deathknight = "Безжалостный Рыцарь Смерти",
	spectral_deathknight = "Призрачный рыцарь Смерти",
	trainee = "Жестокий новобранец",
	spectral_trainee = "Призрачный ученик",

	riderdiewarn = "Всадник мёртв!",
	dkdiewarn = "Рыцарь смерти мёртв!",

	warn1 = "В комнате через 3 минуты",
	warn2 = "В комнате через 90 секунд",
	warn3 = "В комнате через 60 секунд",
	warn4 = "В комнате через 30 секунд",
	warn5 = "Готик появится через 10 секунд",

	wave = "%d/25: ",
	
	trawarn = "Ученик через 3 секунды",
	dkwarn = "Рыцарь Смерти через 3 секунды",
	riderwarn = "Всадник через 3 секунды",

	trabar = "Ученик - %d",
	dkbar = "Рыцарь Смерти - %d",
	riderbar = "Всадник - %d",

	inroomtrigger = "Я очень долго ждал. Положите свою душу в мой комбайн и будем вам дерево с золотыми.",  --check this
	inroomwarn = "Он в комнате!!",

	inroombartext = "В комнате",
} end )

L:RegisterTranslations("koKR", function() return {
	room = "고딕 등장 알림",
	room_desc = "고딕 등장을 알립니다.",

	add = "추가 몹 알림",
	add_desc = "추가 몹을 알립니다.",

	adddeath = "추가 몹 죽음 알림",
	adddeath_desc = "추가된 몹 죽음을 알립니다.",

	starttrigger1 = "어리석은 것들, 스스로 죽음을 자초하다니!",
	starttrigger2 = "Teamanare shi rikk mannor rikk lok karkun", -- CHECK
	startwarn = "영혼 착취자 고딕 전투 시작! 4:30 후 고딕 등장.",

	rider = "무자비한 죽음의 기병",
	spectral_rider = "기병 망령",
	deathknight = "무자비한 죽음의 기사",
	spectral_deathknight = "죽음의 기사 망령",
	trainee = "무자비한 수습생",
	spectral_trainee = "수습생 유령",

	riderdiewarn = "기병 죽음! 무덤조 긴장하세요!",
	dkdiewarn = "죽음의 기사 죽음!",

	warn1 = "고딕 등장 3분 전",
	warn2 = "고딕 등장 90초 전",
	warn3 = "고딕 등장 60초 전",
	warn4 = "고딕 등장 30초 전",
	warn5 = "고딕 등장 10초 전",

	wave = "%d/25: ",

	trawarn = "수습생 3초 후 등장",
	dkwarn = "죽음의 기사 3초 후 등장",
	riderwarn = "기병 3초 후 등장",

	trabar = "수습생 - %d",
	dkbar = "죽음의 기사 - %d",
	riderbar = "기병 - %d",

	inroomtrigger = "오랫동안 기다렸다. 이제 영혼 착취자를 만날 차례다.",
	inroomwarn = "고딕 등장!!",

	inroombartext = "고딕 등장",
} end )

L:RegisterTranslations("deDE", function() return {
	room = "Ankunft",
	room_desc = "Warnung, wenn Gothik in den Raum kommt.",

	add = "Adds",
	add_desc = "Warnung vor Adds.",

	adddeath = "Add Stirbt",
	adddeath_desc = "Warnung, wenn ein Add stirbt.",

	starttrigger1 = "Ihr Narren habt euren eigenen Untergang heraufbeschworen.",
	starttrigger2 = "Maz Azgala veni kamil toralar Naztheros zennshinagas.",
	startwarn = "Gothik der Seelenj\195\164ger angegriffen! Im Raum in 4:30 Minuten!",

	rider = "Unerbittlicher Reiter",
	spectral_rider = "Spektraler Reiter",
	deathknight = "Unerbittlicher Todesritter",
	spectral_deathknight = "Spektraler Todesritter",
	trainee = "Unerbittlicher Lehrling",
	spectral_trainee = "Spektraler Lehrling",

	riderdiewarn = "Reiter tot!",
	dkdiewarn = "Todesritter tot!",

	warn1 = "Im Raum in 3 Minuten",
	warn2 = "Im Raum in 90 Sekunden",
	warn3 = "Im Raum in 60 Sekunden",
	warn4 = "Im Raum in 30 Sekunden",
	warn5 = "Gothik im Raum in 10 Sekunden",

	wave = "%d/25: ",

	trawarn = "Lehrlinge in 3 Sekunden",
	dkwarn = "Todesritter in 3 Sekunden",
	riderwarn = "Reiter in 3 Sekunden",

	trabar = "Lehrling - %d",
	dkbar = "Todesritter - %d",
	riderbar = "Reiter - %d",

	inroomtrigger = "Ich habe lange genug gewartet. Stellt euch dem Seelenj\195\164ger.",
	inroomwarn = "Gothik im Raum!",

	inroombartext = "Im Raum",
} end )

L:RegisterTranslations("zhCN", function() return {
	room = "进入房间",
	room_desc = "当收割者戈提克进入房间时发出警报。",

	add = "增援",
	add_desc = "当增援时发出警报。",
	
	adddeath = "增援死亡",
	adddeath_desc = "当增援死亡时发出警报。",

	starttrigger1 = "你们这些蠢货已经主动步入了陷阱。",
	starttrigger2 = "Teamanare shi rikk mannor rikk lok karkun",
	startwarn = "收割者戈提克已激活 - 4:30后，进入房间！",

	rider = "冷酷的骑兵",
	spectral_rider = "骑兵",
	deathknight = "冷酷的死亡骑士",
	spectral_deathknight = "死亡骑士",
	trainee = "冷酷的学徒",
	spectral_trainee = "学徒",

	riderdiewarn = "骑兵已死亡！",
	dkdiewarn = "死亡骑士已死亡！",

	warn1 = "3分钟后进入房间",
	warn2 = "90秒后进入房间",
	warn3 = "60秒后进入房间",
	warn4 = "30秒后进入房间",
	warn5 = "收割者戈提克10秒后进入房间！",
	
	wave = "%d/25：",

	trawarn = "3秒后学徒出现",
	dkwarn = "3秒后死亡骑士出现",
	riderwarn = "3秒后骑兵出现",

	trabar = "学徒 - %d",
	dkbar = "死亡骑士 - %d",
	riderbar = "骑兵 - %d",

	inroomtrigger = "我已经等待很久了。现在你们将面对灵魂的收割者。",
	inroomwarn = "收割者戈提克进入了房间！",

	inroombartext = "<进入房间>",
} end )

L:RegisterTranslations("zhTW", function() return {
	room = "進入房間警報",
	room_desc = "當收割者高希進入房間時發出警報。",

	add = "增援警報",
	add_desc = "當增援時發出警報。",

	adddeath = "增援死亡",
	adddeath_desc = "當增援死亡時發出警報。",

	starttrigger1 = "你們這些蠢貨已經主動步入了陷阱。",
	starttrigger2 = "我已經等待很久了。現在你們將面對靈魂的收割者。", --?
	startwarn = "收割者高希已進入戰鬥 - 4:30後，進入房間！",

	rider = "無情的騎兵",
	spectral_rider = "騎兵",
	deathknight = "無情的死騎",
	spectral_deathknight = "死騎",
	trainee = "無情的訓練師",
	spectral_trainee = "訓練師",

	riderdiewarn = "騎兵已死亡！",
	dkdiewarn = "死亡騎士已死亡！",

	warn1 = "3分鐘後進入房間！",
	warn2 = "90秒後進入房間！",
	warn3 = "60秒後進入房間！",
	warn4 = "30秒後進入房間！",
	warn5 = "10秒後進入房間！",
	
	wave = "%d/25：",

	trawarn = "3秒後訓練師出現",
	dkwarn = "3秒後死亡騎士出現",
	riderwarn = "3秒後騎兵出現",

	trabar = "訓練師 - %d",
	dkbar = "死亡騎士 - %d",
	riderbar = "騎兵 - %d",

	inroomtrigger = "我已經等待很久了。現在你們將面對靈魂的收割者。",
	inroomwarn = "收割者高希進入了房間！",

	inroombartext = "<進入房間>",
} end )

L:RegisterTranslations("frFR", function() return {
	room = "Arrivée dans la salle",
	room_desc = "Prévient quand Gothik arrive dans la salle.",

	add = "Arrivée des renforts",
	add_desc = "Prévient quand des renforts se joignent au combat.",

	adddeath = "Mort des renforts",
	adddeath_desc = "Prévient quand un des renforts meurt.",

	starttrigger1 = "Dans votre folie, vous avez provoqué votre propre mort.",
	starttrigger2 = "Teamanare shi rikk mannor rikk lok karkun",
	startwarn = "Gothik le moissonneur engagé ! 4:30 avant son arrivée dans la salle.",

	rider = "Cavalier tenace",
	spectral_rider = "Cavalier spectral",
	deathknight = "Chevalier de la mort tenace",
	spectral_deathknight = "Chevalier de la mort spectral",
	trainee = "Jeune recrue tenace",
	spectral_trainee = "Jeune recrue spectral",

	riderdiewarn = "Cavalier mort !",
	dkdiewarn = "Chevalier mort !",

	warn1 = "Dans la salle dans 3 min.",
	warn2 = "Dans la salle dans 90 sec.",
	warn3 = "Dans la salle dans 60 sec.",
	warn4 = "Dans la salle dans 30 sec.",
	warn5 = "Arrivée de Gothik dans 10 sec.",

	wave = "%d/25 : ",

	trawarn = "Jeune recrue dans 3 sec.",
	dkwarn = "Chevalier de la mort dans 3 sec.",
	riderwarn = "Cavalier dans 3 sec.",

	trabar = "Jeune recrue - %d",
	dkbar = "Chevalier de la mort - %d",
	riderbar = "Cavalier - %d",

	inroomtrigger = "J'ai attendu assez longtemps. Maintenant, vous affrontez le moissonneur d'âmes.",
	inroomwarn = "Il est dans la salle !",

	inroombartext = "Dans la salle",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = { boss }
mod.guid = 16060
mod.wipemobs = {
	L["rider"], L["deathknight"], L["trainee"],
	L["spectral_rider"], L["spectral_deathknight"], L["spectral_trainee"]
}
mod.toggleoptions = { "room", -1, "add", "adddeath", "bosskill" }
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self.wave = 0
	self.tratime = 27
	self.dktime = 77
	self.ridertime = 137

	self:AddCombatListener("UNIT_DIED", "Deaths")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Deaths(unit)
	if self.db.profile.adddeath and unit == L["rider"] then
		self:Message(L["riderdiewarn"], "Important")
	elseif self.db.profile.adddeath and unit == L["deathknight"] then
		self:Message(L["dkdiewarn"], "Important")
	elseif unit == boss then
		self:BossDeath(nil, self.guid)
	end
end

function mod:StopRoom()
	self:TriggerEvent("BigWigs_StopBar", self, L["inroombartext"])
	self:CancelScheduledEvent("bwgothikwarn1")
	self:CancelScheduledEvent("bwgothikwarn2")
	self:CancelScheduledEvent("bwgothikwarn3")
	self:CancelScheduledEvent("bwgothikwarn4")
	self:CancelScheduledEvent("bwgothikwarn5")
	if self.tranum and self.dknum and self.ridernum then
		self:TriggerEvent("BigWigs_StopBar", self, L["trabar"]:format(self.tranum - 1))
		self:TriggerEvent("BigWigs_StopBar", self, L["dkbar"]:format(self.dknum - 1))
		self:TriggerEvent("BigWigs_StopBar", self, L["riderbar"]:format(self.ridernum - 1))
	end
	self:CancelScheduledEvent("bwgothiktrawarn")
	self:CancelScheduledEvent("bwgothikdkwarn")
	self:CancelScheduledEvent("bwgothikriderwarn")
	self:CancelScheduledEvent("bwgothiktrarepop")
	self:CancelScheduledEvent("bwgothikdkrepop")
	self:CancelScheduledEvent("bwgothikriderrepop")
end

function mod:WaveWarn(message, L, color)
	self.wave = self.wave + 1
	if self.wave < 26 then
		if self.db.profile.add then 
			self:Message(L["wave"]:format(self.wave) .. message, color) 
		end
	end
end

function mod:Trainee()
	if self.db.profile.add then
		self:Bar(L["trabar"]:format(self.tranum), self.tratime, "Ability_Seal")
	end
	self:ScheduleEvent("bwgothiktrawarn", self.WaveWarn, self.tratime - 3, self, L["trawarn"], L, "Attention")
	self:ScheduleRepeatingEvent("bwgothiktrarepop", self.Trainee, self.tratime, self)
	self.tranum = self.tranum + 1
end

function mod:DeathKnight()
	if self.db.profile.add then
		self:Bar(L["dkbar"]:format(self.dknum), self.dktime, "INV_Boots_Plate_08")
	end
	self:ScheduleEvent("bwgothikdkwarn", self.WaveWarn, self.dktime - 3, self, L["dkwarn"], L, "Urgent")
	self:ScheduleRepeatingEvent("bwgothikdkrepop", self.DeathKnight, self.dktime, self)
	self.dknum = self.dknum + 1
end

function mod:Rider()
	if self.db.profile.add then
		self:Bar(L["riderbar"]:format(self.ridernum), self.ridertime, "Spell_Shadow_DeathPact")
	end
	self:ScheduleEvent("bwgothikriderwarn", self.WaveWarn, self.ridertime - 3, self, L["riderwarn"], L, "Important")
	self:ScheduleRepeatingEvent("bwgothikriderrepop", self.Rider, self.ridertime, self)
	self.ridernum = self.ridernum + 1
end

function mod:CHAT_MSG_MONSTER_YELL( msg )
	if msg == L["starttrigger1"] or msg == L["starttrigger2"] then
		if self.db.profile.room then
			self:Message(L["startwarn"], "Important")
			self:Bar(L["inroombartext"], 270, "Spell_Magic_LesserInvisibilty")
			self:ScheduleEvent("bwgothikwarn1", "BigWigs_Message", 90, L["warn1"], "Attention")
			self:ScheduleEvent("bwgothikwarn2", "BigWigs_Message", 180, L["warn2"], "Attention")
			self:ScheduleEvent("bwgothikwarn3", "BigWigs_Message", 210, L["warn3"], "Urgent")
			self:ScheduleEvent("bwgothikwarn4", "BigWigs_Message", 240, L["warn4"], "Important")
			self:ScheduleEvent("bwgothikwarn5", "BigWigs_Message", 260, L["warn5"], "Important")
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
		if self.db.profile.room then self:Message(L["inroomwarn"], "Important") end
		self:StopRoom()
	end
end

