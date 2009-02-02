------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Noth the Plaguebringer"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local timeroom = 90
local timebalcony = 70
local cursetime = 55
local wave1time = 10
local wave2time = 41

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Noth",

	starttrigger1 = "Die, trespasser!",
	starttrigger2 = "Glory to the master!",
	starttrigger3 = "Your life is forfeit!",
	startwarn = "Noth the Plaguebringer engaged! 90 sec till teleport",

	blink = "Blink",
	blink_desc = "Warnings when Noth blinks.",
	blinktrigger = "%s blinks away!",
	blinkwarn = "Blink!",
	blinkwarn2 = "Blink in ~5 sec!",
	blinkbar = "Blink",

	teleport = "Teleport",
	teleport_desc = "Warnings and bars for teleport.",
	teleportbar = "Teleport!",
	backbar = "Back in room!",
	teleportwarn = "Teleport! He's on the balcony!",
	teleportwarn2 = "Teleport in 10 sec!",
	backwarn = "He's back in the room for %d sec!",
	backwarn2 = "10 sec until he's back in the room!",

	curse = "Curse",
	curse_desc = "Warn when Noth casts Curse of the Plaguebringer.",
	curseexplosion = "Curse explosion!",
	cursewarn = "Curse! next in ~55 sec",
	curse10secwarn = "Curse in ~10 sec",
	cursebar = "Next Curse",

	wave = "Waves",
	wave_desc = "Alerts for the different waves.",
	addtrigger = "Rise, my soldiers! Rise and fight once more!",
	wave1bar = "Wave 1",
	wave2bar = "Wave 2",
	wave2_message = "Wave 2 in 10 sec",
} end )

L:RegisterTranslations("ruRU", function() return {
	starttrigger1 = "Смерть чужакам!",  
	starttrigger2 = "Glory to the master!",  --correct this
	starttrigger3 = "Прощайся с жизнью!", 
	startwarn = "Нот Чумной разъярён! 90 секунд до телепорта",

	blink = "Опасность скачка",
	blink_desc = "Предупреждать, когда Нот использует скачок",
	--blinktrigger = "%s blinks away!",
	blinkwarn = "Скачок!",
	blinkwarn2 = "Скачок через 5 секунд!",
	blinkbar = "Скачок",

    teleport = "Телепорт",
	teleport_desc = "Предупреждать о телепорте.",
	teleportbar = "Телепорт!",
	backbar = "Назад в Команту!",
	teleportwarn = "Телепорт! Он на балконе!",
	teleportwarn2 = "Телепорт через 10 секунд!",
	backwarn = "Он вернётся в комнату через %d секунд!",
	backwarn2 = "10 секунд до возвращения в комнату!",

	curse = "Проклятие Чумного",
	curse_desc = "Сообщать когда Нот накладывает проклятие.",
	curseexplosion = "Проклятый взрыв!",
	cursewarn = "Проклятие через ~55 секунд",
	curse10secwarn = "Проклятие через ~10 секунд",
	cursebar = "Следующее проклятие",

	wave = "Волны",
	wave_desc = "Сообщать о волнах",
	addtrigger = "Встаньте, мои воины! Встаньте и сражайтесь вновь!", 
	wave1bar = "1-я волна",
	wave2bar = "2-я волна",
	wave2_message = "2-я волна через 10 сек",
} end )

L:RegisterTranslations("deDE", function() return {
	starttrigger1 = "Sterbt, Eindringling!",
	starttrigger2 = "Ehre unserem Meister!",
	starttrigger3 = "Euer Leben ist verwirkt!",
	startwarn = "Noth angegriffen! Teleport in 90 sek!",

	blink = "Blinzeln",
	blink_desc = "Warnungen und Timer für Blinzeln.",
	blinktrigger = "%s blinzelt sich davon!",
	blinkwarn = "Blinzeln!",
	blinkwarn2 = "Blinzeln in ~5 sek!",
	blinkbar = "Blinzeln",

	teleport = "Teleport",
	teleport_desc = "Warnungen und Timer für Teleport.",
	teleportbar = "Teleport",
	backbar = "Rückteleport",
	teleportwarn = "Teleport! Noth auf dem Balkon!",
	teleportwarn2 = "Teleport in 10 sek!",
	backwarn = "Noth zurück im Raum für %d sek!",
	backwarn2 = "Rückteleport in 10 sek!",

	curse = "Fluch",
	curse_desc = "Warnungen und Timer für Fluch des Seuchenfürsten.",
	curseexplosion = "Fluch Explosion!",
	cursewarn = "Fluch! Nächster in ~55 sek.",
	curse10secwarn = "Fluch in ~10 sek!",
	cursebar = "Nächster Fluch",

	wave = "Wellen",
	wave_desc = "Warnungen und Timer für die Gegnerwellen.",
	addtrigger = "Erhebt euch, Soldaten! Erhebt euch und kämpft erneut!",
	wave1bar = "Welle 1",
	wave2bar = "Welle 2",
	wave2_message = "Welle 2 in 10 sek!",
} end )


L:RegisterTranslations("koKR", function() return {
	starttrigger1 = "죽어라, 침입자들아!",
	starttrigger2 = "주인님께 영광을!",
	starttrigger3 = "너희 생명은 끝이다!",
	startwarn = "역병술사 노스와 전투 시작! 90초 후 순간이동",

	blink = "점멸",
	blink_desc = "점멸을 알립니다.",
	blinktrigger = "%s|1이;가; 눈 깜짝할 사이에 도망칩니다!",
	blinkwarn = "점멸! 어그로 초기화!",
	blinkwarn2 = "약 5초 이내 점멸!",
	blinkbar = "점멸",

	teleport = "순간이동",
	teleport_desc = "순간이동을 알립니다.",
	teleportwarn = "발코니로 순간이동!",
	teleportwarn2 = "10초 후 순간이동!",
	teleportbar = "순간이동!",
	backbar = "방으로 복귀!",
	backwarn = "방으로 복귀! %d 초간 최대한 공격!",
	backwarn2 = "10초 후 방으로 복귀!",

	curse = "저주",
	curse_desc = "저주를 알립니다.",
	curseexplosion = "역병술사의 저주!",
	cursewarn = "저주! 다음 저주 약 55초 이내",
	curse10secwarn = "약 10초 이내 저주",
	cursebar = "다음 저주",

	wave = "웨이브",
	wave_desc = "웨이브를 알립니다.",
	addtrigger = "일어나라,병사들이여! 다시 일어나 싸워라!",
	wave1bar = "웨이브 1",
	wave2bar = "웨이브 2",
	wave2_message = "10초 이내 웨이브 2",
} end )

L:RegisterTranslations("zhCN", function() return {
	starttrigger1 = "死吧，入侵者！",
	starttrigger2 = "荣耀归于我主！",
	starttrigger3 = "我要没收你的生命！",
	startwarn = "瘟疫使者诺斯已激活 - 90秒后，传送！",

	blink = "闪现术",
	blink_desc = "当施放闪现术时发出警报。",
	--blinktrigger = "%s blinks away!",
	blinkwarn = "闪现术！停止攻击！",
	blinkwarn2 = "约5秒后，闪现术！",
	blinkbar = "<闪现术>",

	teleport = "传送",
	teleport_desc = "当施放传送时发出警报。",
	teleportbar = "<传送>",
	backbar = "<回到房间>",
	teleportwarn = "传送！",
	teleportwarn2 = "10秒后，传送！",
	backwarn = "诺斯回到房间 - %d秒后，传送！",
	backwarn2 = "10秒后诺斯回到房间！",

	curse = "瘟疫使者的诅咒",
	curse_desc = "当施放瘟疫使者的诅咒时发出警报。",
	curseexplosion = "瘟疫使者的诅咒！",
	cursewarn = "约55秒后，瘟疫使者的诅咒！",
	curse10secwarn = "约10秒后，瘟疫使者的诅咒！",
	cursebar = "<下一瘟疫使者的诅咒>",

	wave = "骷髅",
	wave_desc = "当召唤骷髅时发出警报。",
	addtrigger = "起来吧，我的战士们！起来，再为主人尽忠一次！",
	wave1bar = "<第一波>",
	wave2bar = "<第二波>",
	wave2_message = "10秒后，第二波！",
} end )

L:RegisterTranslations("zhTW", function() return {
	starttrigger1 = "死吧，入侵者！",
	starttrigger2 = "榮耀歸於我主！",
	starttrigger3 = "我要沒收你的生命！",
	startwarn = "瘟疫者諾斯已進入戰斗 - 90秒後，傳送！",

	blink = "閃現術",
	blink_desc = "當施放閃現術時發出警報。",
	--blinktrigger = "%s blinks away!",
	blinkwarn = "閃現術！停止攻擊！",
	blinkwarn2 = "約5秒後，閃現術！",
	blinkbar = "<閃現術>",

	teleport = "傳送",
	teleport_desc = "當施放傳送時發出警報。",
	teleportbar = "<傳送>",
	backbar = "<回到房間>",
	teleportwarn = "傳送！",
	teleportwarn2 = "10秒後，傳送！",
	backwarn = "諾斯回到房間 - %d秒後，傳送！",
	backwarn2 = "10秒後諾斯回到房間！",

	curse = "瘟疫者詛咒",
	curse_desc = "當施放瘟疫者詛咒時發出警報。",
	curseexplosion = "瘟疫者詛咒！",
	cursewarn = "約55秒后，瘟疫者詛咒！",
	curse10secwarn = "約10秒後，瘟疫者詛咒！",
	cursebar = "<下一瘟疫者詛咒>",

	wave = "骷髏",
	wave_desc = "當召喚骷髏時發出警報。",
	addtrigger = "起來吧，我的戰士們！起來，再為主人盡忠一次！",
	wave1bar = "<第一波>",
	wave2bar = "<第二波>",
	wave2_message = "10秒後，第二波！",
} end )

L:RegisterTranslations("frFR", function() return {
	starttrigger1 = "Mourez, intrus !",
	starttrigger2 = "Gloire au maître !",
	starttrigger3 = "Vos vies ne valent plus rien !",
	startwarn = "Noth le Porte-peste engagé ! 90 sec. avant téléportation !",

	blink = "Transfert",
	blink_desc = "Prévient quand Noth utilise son Transfert.",
	blinktrigger = "%s se téléporte au loin !",
	blinkwarn = "Transfert !",
	blinkwarn2 = "Transfert dans ~5 sec. !",
	blinkbar = "Transfert",

	teleport = "Téléportation",
	teleport_desc = "Prévient quand Noth se téléporte.",
	teleportbar = "Téléportation",
	backbar = "Retour dans la salle !",
	teleportwarn = "Téléportation ! Il est sur le balcon !",
	teleportwarn2 = "Téléportation dans 10 sec. !",
	backwarn = "De retour dans la salle pendant %d sec. !",
	backwarn2 = "10 sec. avant son retour dans la salle !",

	curse = "Malédiction",
	curse_desc = "Prévient quand Noth incante sa Malédiction du Porte-peste.",
	curseexplosion = "Explosion des malé. !",
	cursewarn = "Malédiction ! Prochaine dans ~55 sec.",
	curse10secwarn = "Malédiction dans ~10 sec.",
	cursebar = "Prochaine malédiction",

	wave = "Vagues",
	wave_desc = "Prévient de l'arrivée des vagues.",
	addtrigger = "Levez-vous, soldats ! Levez-vous et combattez une fois encore !",
	wave1bar = "1ère vague",
	wave2bar = "2ème vague",
	wave2_message = "2ème vague dans 10 sec.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15954
mod.toggleoptions = {"blink", "teleport", "curse", "wave", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Curse", 29213, 54835)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Curse(_, spellID)
	if self.db.profile.curse then
		self:IfMessage(L["cursewarn"], "Important", spellID, "Alarm")
		self:ScheduleEvent("bwnothcurse", "BigWigs_Message", cursetime - 10, L["curse10secwarn"], "Urgent")
		self:Bar(L["cursebar"], cursetime, spellID)
		self:Bar(L["curseexplosion"], 10, spellID)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["blinktrigger"] then
		if self.db.profile.blink then
			self:IfMessage(L["blinkwarn"], "Important", 29208)
			self:DelayedMessage(34, L["blinkwarn2"], "Attention")
			self:Bar(L["blinkbar"], 39, 29208)
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["starttrigger1"] or msg == L["starttrigger2"] or msg == L["starttrigger3"] then
		timeroom = 90
		timebalcony = 70
		cursetime = 55
		wave1time = 10
		wave2time = 41

		if self.db.profile.teleport then
			self:Message(L["startwarn"], "Important")
			self:DelayedMessage(timeroom - 10, L["teleportwarn2"], "Urgent")
			self:Bar(L["teleportbar"], timeroom, "Spell_Magic_LesserInvisibilty")
		end
		if self.db.profile.blink then
			self:DelayedMessage(25, L["blinkwarn2"], "Attention")
			self:Bar(L["blinkbar"], 30, 29208)
		end
		self:ScheduleEvent("bwnothtobalcony", self.teleportToBalcony, timeroom, self)
	end
end

function mod:teleportToBalcony()
	if timeroom == 90 then
		timeroom = 110
	elseif timeroom == 110 then
		timeroom = 180
	end

	self:CancelScheduledEvent("bwnothblink")
	self:CancelScheduledEvent("bwnothcurse")
	self:TriggerEvent("BigWigs_StopBar", self, L["blinkbar"])
	self:TriggerEvent("BigWigs_StopBar", self, L["cursebar"])

	if self.db.profile.teleport then 
		self:Message(L["teleportwarn"], "Important")
		self:Bar(L["backbar"], timebalcony, "Spell_Magic_LesserInvisibilty")
		self:ScheduleEvent("bwnothback", "BigWigs_Message", timebalcony - 10, L["backwarn2"], "Urgent")
	end
	if self.db.profile.wave then
		self:Bar(L["wave1bar"], wave1time, "Spell_ChargePositive")
		self:Bar(L["wave2bar"], wave2time, "Spell_ChargePositive")
		self:ScheduleEvent("bwnothwave2inc", "BigWigs_Message", wave2time - 10, L["wave2_message"], "Urgent")
	end
	self:ScheduleEvent("bwnothtoroom", self.teleportToRoom, timebalcony, self)
	wave2time = wave2time + 15
end

function mod:teleportToRoom()
	if timebalcony == 70 then
		timebalcony = 95
	elseif timebalcony == 95 then
		timebalcony = 120
	end

	if self.db.profile.teleport then
		self:Message(L["backwarn"]:format(timeroom), "Important")
		self:Bar(L["teleportbar"], timeroom, "Spell_Magic_LesserInvisibilty")
		self:ScheduleEvent("bwnothteleport", "BigWigs_Message", timeroom - 10, L["teleportwarn2"], "Urgent")
	end
	self:ScheduleEvent("bwnothtobalcony", self.teleportToBalcony, timeroom, self)
end

