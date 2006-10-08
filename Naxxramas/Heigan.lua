------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Heigan the Unclean")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Heigan",

	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for Teleports.",

	engage_cmd = "engage",
	engage_name = "Engage Alert",
	engage_desc = "Warn when Heigan is engaged.",

	-- [[ Triggers ]]--
	starttrigger = "You are mine now.",
	starttrigger2 = "You... are next.",
	starttrigger3 = "I see you...",
	teleporttrigger = "The end is upon you.",
	dietrigger = "%s takes his last breath.",
	-- [[ Warnings ]]--
	startwarn = "Heigan the Unclean engaged! 90 seconds till teleport",
	warn1 = "Teleport in 1 minute",
	warn2 = "Teleport in 30 seconds",
	warn3 = "Teleport in 10 seconds",
	backwarn = "He's back on the floor! 90 seconds till next teleport",
	teleportwarn2 = "Inc to floor in 30 seconds",
	teleportwarn3 = "Inc to floor in 10 seconds",
	teleportwarn1 = "Teleport! %d sec till back in room!",
	-- [[ Bars ]]--
	teleportbar = "Teleport!",
	backbar = "Back on floor!",
} end )

-- Korean Translation by gezta --
L:RegisterTranslations("koKR", function() return {

	teleport_name = "순간이동 경고",
	teleport_desc = "순간이동에 대한 경고",

	engage_name = "전투개시 알림",
	engage_desc = "헤이건 전투 개시 알림.",

	-- [[ Triggers ]]--
	starttrigger = "이제 넌 내 것이다.",
	starttrigger2 = "다음은... 너다.",
	starttrigger3 = "네가 보인다...",
	teleporttrigger = "여기가 너희 무덤이 되리라.",
	-- [[ Warnings ]]--
	startwarn = "부정의 헤이건, 단상으로 순간 이동까지 90초",
	warn1 = "순간이동 1 분전 !!!",
	warn2 = "순간이동 30초전 !!!",
	warn3 = "순간이동 10초전 !!!",
	backwarn = "헤이건 단상 아래!! 90초 후에 순간이동 !!!",
	teleportwarn2 = "내려오기까지 30초 전 !!!",
	teleportwarn3 = "내려오기까지 10초 전 !!!",
	teleportwarn1 = "순간이동! %d초 후 내려옵니다. !!!",
	-- [[ Bars ]]--
	teleportbar = "순간이동!",
	backbar = "단상으로 이동!",
} end )

L:RegisterTranslations("deDE", function() return {
	teleport_name = "Teleport",
	teleport_desc = "Warnung vor Teleport.",

	starttrigger = "Ihr geh\195\182rt mir...",
	starttrigger2 = "Ihr seid.... als n\195\164chstes dran.",
	starttrigger3 = "Ihr entgeht mir nicht...",
	teleporttrigger = "Euer Ende naht.",

	startwarn = "Heigan der Unsaubere angegriffen! 90 Sekunden bis Teleport!",
	warn1 = "Teleport in 1 Minute",
	warn2 = "Teleport in 30 Sekunden",
	warn3 = "Teleport in 10 Sekunden",
	backwarn = "Zur\195\188ck im Raum! N\195\164chster Teleport in 90 Sekunden!",
	teleportwarn2 = "Zur\195\188ck im Raum in 30 Sekunden",
	teleportwarn3 = "Zur\195\188ck im Raum in 10 Sekunden",
	teleportwarn1 = "Teleport! Zur\195\188ck im Raum in %d Sekunden!",

	teleportbar = "Teleport!",
	backbar = "R\195\188ckteleport!",
} end )

L:RegisterTranslations("zhCN", function() return {
	teleport_name = "传送警报",
	teleport_desc = "传送警报",

	engage_name = "激活警报",
	engage_desc = "希尔盖激活时警告",

	-- [[ Triggers ]]--
	starttrigger = "你是我的了。",
	starttrigger2 = "你……就是下一个。",
	starttrigger3 = "我看到你了……",
	teleporttrigger = "你的生命正走向终结。",
	dietrigger = "%s takes his last breath.",
	-- [[ Warnings ]]--
	startwarn = "希尔盖已激活 - 90秒后传送",
	warn1 = "1分钟后传送",
	warn2 = "30秒后传送",
	warn3 = "10秒后传送",
	backwarn = "希尔盖出现 - 90秒后再次传送",
	teleportwarn2 = "30秒后希尔盖出现",
	teleportwarn3 = "10秒后希尔盖出现",
	teleportwarn1 = "传送发动！ - %d秒后希尔盖出现！",
	-- [[ Bars ]]--
	teleportbar = "传送！",
	backbar = "出现！",
} end )

L:RegisterTranslations("frFR", function() return {
	-- [[ Triggers ]]--
	starttrigger = "Vous \195\170tes \195\160 moi, maintenant.",
	starttrigger2 = "Tu es%.%.%. le suivant.",
	starttrigger3 = "Je vous vois%.%.%.",
	teleporttrigger = "The end is upon you.",-- to translate need french /chatlog
} end )


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsHeigan = BigWigs:NewModule(boss)
BigWigsHeigan.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsHeigan.enabletrigger = boss
BigWigsHeigan.toggleoptions = {"engage", "teleport", "bosskill"}
BigWigsHeigan.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsHeigan:OnEnable()
	self.toRoomTime = 45
	self.toPlatformTime = 90
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "HeiganTeleport", 10)
end

function BigWigsHeigan:CHAT_MSG_MONSTER_EMOTE( msg )
	if msg == L["dietrigger"] then
		if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.0"):new("BigWigs")["%s has been defeated"], boss), "Bosskill", nil, "Victory") end
		self.core:ToggleModuleActive(self, false)
	end
end

function BigWigsHeigan:CHAT_MSG_MONSTER_YELL( msg )
	if msg == L["starttrigger"] or msg == L["starttrigger2"] or msg == L["starttrigger3"] then
		if self.db.profile.engage then
			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Important")
		end
		if self.db.profile.teleport then
			self:TriggerEvent("BigWigs_StartBar", self, L["teleportbar"], self.toPlatformTime, "Interface\\Icons\\Spell_Arcane_Blink")
			self:ScheduleEvent("bwheiganwarn1", "BigWigs_Message", self.toPlatformTime-60, L["warn1"], "Attention")
			self:ScheduleEvent("bwheiganwarn2", "BigWigs_Message", self.toPlatformTime-30, L["warn2"], "Urgent")
			self:ScheduleEvent("bwheiganwarn3", "BigWigs_Message", self.toPlatformTime-10, L["warn3"], "Important")
		end
	elseif string.find(msg, L["teleporttrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "HeiganTeleport")
	end
end

function BigWigsHeigan:BigWigs_RecvSync( sync )
	if sync ~= "HeiganTeleport" then return end

	self:ScheduleEvent( self.BackToRoom, self.toRoomTime, self )	

	if self.db.profile.teleport then
		self:TriggerEvent("BigWigs_Message", string.format(L["teleportwarn1"], self.toRoomTime), "Attention")
		self:ScheduleEvent("bwheiganwarn2","BigWigs_Message", self.toRoomTime-30, L["teleportwarn2"], "Urgent")
		self:ScheduleEvent("bwheiganwarn3","BigWigs_Message", self.toRoomTime-10, L["teleportwarn3"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["backbar"], self.toRoomTime, "Interface\\Icons\\Spell_Magic_LesserInvisibilty")
	end
end

function BigWigsHeigan:BackToRoom()
	if self.db.profile.teleport then
		self:TriggerEvent("BigWigs_Message", L["backwarn"], "Attention")
		self:ScheduleEvent("bwheiganwarn2","BigWigs_Message", self.toPlatformTime-30, L["warn2"], "Urgent")
		self:ScheduleEvent("bwheiganwarn3","BigWigs_Message", self.toPlatformTime-10, L["warn3"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["teleportbar"], self.toPlatformTime, "Interface\\Icons\\Spell_Arcane_Blink")
	end
end

