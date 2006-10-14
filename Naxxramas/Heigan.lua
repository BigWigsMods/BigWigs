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
	teleport_trigger = "The end is upon you.",
	die_trigger = "%s takes his last breath.",

	-- [[ Warnings ]]--
	engage_message = "Heigan the Unclean engaged! 90 sec to teleport!",

	teleport_1min_message = "Teleport in 1 min",
	teleport_30sec_message = "Teleport in 30 sec",
	teleport_10sec_message = "Teleport in 10 sec!",
	on_platform_message = "Teleport! On platform for %d sec!",

	to_floor_30sec_message = "Back in 30 sec",
	to_floor_10sec_message = "Back in 10 sec!",
	on_floor_message = "Back on the floor! 90 sec to next teleport!",

	-- [[ Bars ]]--
	teleport_bar = "Teleport!",
	back_bar = "Back on the floor!",

	-- [[ Dream Room Mobs ]] --
	["Eye Stalk"] = true,
	["Rotting Maggot"] = true,
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
	teleport_trigger = "여기가 너희 무덤이 되리라.",
	die_trigger = "%s|%1이;가; 마지막 숨결을 얻었습니다.", -- "%s takes his last breath.", -- check

	-- [[ Warnings ]]--
	engage_message = "부정의 헤이건, 단상으로 순간 이동까지 90초",

	teleport_1min_message = "순간이동 1 분전 !!!",
	teleport_30sec_message = "순간이동 30초전 !!!",
	teleport_10sec_message = "순간이동 10초전 !!!",
	on_platform_message = "순간이동! %d초 후 내려옵니다. !!!",

	to_floor_30sec_message = "내려오기까지 30초 전 !!!",
	to_floor_10sec_message = "내려오기까지 10초 전 !!!",
	on_floor_message = "헤이건 단상 아래!! 90초 후에 순간이동 !!!",

	-- [[ Bars ]]--
	teleport_bar = "순간이동!",
	back_bar = "단상으로 이동!",

	-- [[ Dream Room Mobs ]] --
	["Eye Stalk"] = "Eye Stalk",
	["Rotting Maggot"] = "Rotting Maggot",
} end )

L:RegisterTranslations("deDE", function() return {
	teleport_name = "Teleport",
	teleport_desc = "Warnung vor Teleport.",

	starttrigger = "Ihr geh\195\182rt mir...",
	starttrigger2 = "Ihr seid.... als n\195\164chstes dran.",
	starttrigger3 = "Ihr entgeht mir nicht...",
	teleport_trigger = "Euer Ende naht.",

	engage_message = "Heigan der Unsaubere angegriffen! 90 Sekunden bis Teleport!",
	teleport_1min_message = "Teleport in 1 Minute",
	teleport_30sec_message = "Teleport in 30 Sekunden",
	teleport_10sec_message = "Teleport in 10 Sekunden",
	on_floor_message = "Zur\195\188ck im Raum! N\195\164chster Teleport in 90 Sekunden!",
	to_floor_30sec_message = "Zur\195\188ck im Raum in 30 Sekunden",
	to_floor_10sec_message = "Zur\195\188ck im Raum in 10 Sekunden",
	on_platform_message = "Teleport! Zur\195\188ck im Raum in %d Sekunden!",

	teleport_bar = "Teleport!",
	back_bar = "R\195\188ckteleport!",
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
	teleport_trigger = "你的生命正走向终结。",
	die_trigger = "%s takes his last breath.",
	-- [[ Warnings ]]--
	engage_message = "希尔盖已激活 - 90秒后传送",
	teleport_1min_message = "1分钟后传送",
	teleport_30sec_message = "30秒后传送",
	teleport_10sec_message = "10秒后传送",
	on_floor_message = "希尔盖出现 - 90秒后再次传送",
	to_floor_30sec_message = "30秒后希尔盖出现",
	to_floor_10sec_message = "10秒后希尔盖出现",
	on_platform_message = "传送发动！ - %d秒后希尔盖出现！",
	-- [[ Bars ]]--
	teleport_bar = "传送！",
	back_bar = "出现！",
	-- [[ Dream Room Mobs ]] --
	["Eye Stalk"] = "眼柄",
	["Rotting Maggot"] = "腐烂之蛆",
} end )

L:RegisterTranslations("frFR", function() return {
	-- [[ Triggers ]]--
	starttrigger = "Vous \195\170tes \195\160 moi, maintenant.",
	starttrigger2 = "Tu es%.%.%. le suivant.",
	starttrigger3 = "Je vous vois%.%.%.",
	teleport_trigger = "The end is upon you.",-- to translate need french /chatlog
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsHeigan = BigWigs:NewModule(boss)
BigWigsHeigan.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsHeigan.enabletrigger = boss
BigWigsHeigan.wipemobs = { L["Eye Stalk"], L["Rotting Maggot"] }
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
	if msg == L["die_trigger"] then
		if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.0"):new("BigWigs")["%s has been defeated"], boss), "Bosskill", nil, "Victory") end
		self.core:ToggleModuleActive(self, false)
	end
end

function BigWigsHeigan:CHAT_MSG_MONSTER_YELL( msg )
	if msg == L["starttrigger"] or msg == L["starttrigger2"] or msg == L["starttrigger3"] then
		if self.db.profile.engage then
			self:TriggerEvent("BigWigs_Message", L["engage_message"], "Important")
		end
		if self.db.profile.teleport then
			self:TriggerEvent("BigWigs_StartBar", self, L["teleport_bar"], self.toPlatformTime, "Interface\\Icons\\Spell_Arcane_Blink")
			self:ScheduleEvent("bwheiganwarn1", "BigWigs_Message", self.toPlatformTime-60, L["teleport_1min_message"], "Attention")
			self:ScheduleEvent("bwheiganwarn2", "BigWigs_Message", self.toPlatformTime-30, L["teleport_30sec_message"], "Urgent")
			self:ScheduleEvent("bwheiganwarn3", "BigWigs_Message", self.toPlatformTime-10, L["teleport_10sec_message"], "Important")
		end
	elseif string.find(msg, L["teleport_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "HeiganTeleport")
	end
end

function BigWigsHeigan:BigWigs_RecvSync( sync )
	if sync ~= "HeiganTeleport" then return end

	self:ScheduleEvent( self.BackToRoom, self.toRoomTime, self )

	if self.db.profile.teleport then
		self:TriggerEvent("BigWigs_Message", string.format(L["on_platform_message"], self.toRoomTime), "Attention")
		self:ScheduleEvent("bwheiganwarn2","BigWigs_Message", self.toRoomTime-30, L["to_floor_30sec_message"], "Urgent")
		self:ScheduleEvent("bwheiganwarn3","BigWigs_Message", self.toRoomTime-10, L["to_floor_10sec_message"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["back_bar"], self.toRoomTime, "Interface\\Icons\\Spell_Magic_LesserInvisibilty")
	end
end

function BigWigsHeigan:BackToRoom()
	if self.db.profile.teleport then
		self:TriggerEvent("BigWigs_Message", L["on_floor_message"], "Attention")
		self:ScheduleEvent("bwheiganwarn2","BigWigs_Message", self.toPlatformTime-30, L["teleport_30sec_message"], "Urgent")
		self:ScheduleEvent("bwheiganwarn3","BigWigs_Message", self.toPlatformTime-10, L["teleport_10sec_message"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["teleport_bar"], self.toPlatformTime, "Interface\\Icons\\Spell_Arcane_Blink")
	end
end

