------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Heigan the Unclean"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Heigan",

	starttrigger = "You are mine now.",
	starttrigger2 = "You... are next.",
	starttrigger3 = "I see you...",

	engage = "Engage",
	engage_desc = "Warn when Heigan is engaged.",
	engage_message = "Heigan the Unclean engaged! 90 sec to teleport!",

	teleport = "Teleport",
	teleport_desc = "Warn for Teleports.",
	teleport_trigger = "The end is upon you.",
	teleport_1min_message = "Teleport in 1 min",
	teleport_30sec_message = "Teleport in 30 sec",
	teleport_10sec_message = "Teleport in 10 sec!",
	on_platform_message = "Teleport! On platform for 45 sec!",

	to_floor_30sec_message = "Back in 30 sec",
	to_floor_10sec_message = "Back in 10 sec!",
	on_floor_message = "Back on the floor! 90 sec to next teleport!",

	teleport_bar = "Teleport!",
	back_bar = "Back on the floor!",

	["Eye Stalk"] = true,
	["Rotting Maggot"] = true,
} end )

L:RegisterTranslations("koKR", function() return {
	starttrigger = "이제 넌 내 것이다.",
	starttrigger2 = "다음은... 너다.",
	starttrigger3 = "네가 보인다...",

	engage = "전투 시작",
	engage_desc = "헤이건 전투 시작을 알립니다.",
	engage_message = "부정의 헤이건, 90초 후 단상으로 순간 이동",

	teleport = "순간이동",
	teleport_desc = "순간이동을 알립니다.",
	teleport_trigger = "여기가 너희 무덤이 되리라.",
	teleport_1min_message = "60초 후 순간이동!",
	teleport_30sec_message = "30초 후 순간이동!",
	teleport_10sec_message = "10초 후 순간이동!",
	on_platform_message = "순간이동! 45초간 단상!",

	to_floor_30sec_message = "30초 후 단상 내려옴!",
	to_floor_10sec_message = "10초 후 단상 내려옴!",
	on_floor_message = "헤이건 내려옴! 90초 후 순간이동!",

	teleport_bar = "순간이동!",
	back_bar = "단상으로 이동!",

	["Eye Stalk"] = "추적자의 눈",
	["Rotting Maggot"] = "썩어가는 구더기",
} end )

L:RegisterTranslations("deDE", function() return {
	teleport = "Teleport",
	teleport_desc = "Warnung vor Teleport.",

	engage = "Angriff",
	engage_desc = "Warnung, wenn Heigan angegriffen wird.",

	starttrigger = "Ihr geh\195\182rt mir...",
	starttrigger2 = "Ihr seid.... als n\195\164chstes dran.",
	starttrigger3 = "Ihr entgeht mir nicht...",
	teleport_trigger = "Euer Ende naht.",

	engage_message = "Heigan der Unreine angegriffen! Teleport in 90 Sekunden!",

	teleport_1min_message = "Teleport in 1 Minute",
	teleport_30sec_message = "Teleport in 30 Sekunden",
	teleport_10sec_message = "Teleport in 10 Sekunden",
	on_platform_message = "Teleport! Auf der Plattform f\195\188r 45 Sekunden!",

	to_floor_30sec_message = "Zur\195\188ck im Raum in 30 Sekunden",
	to_floor_10sec_message = "Zur\195\188ck im Raum in 10 Sekunden",
	on_floor_message = "Zur\195\188ck im Raum! N\195\164chster Teleport in 90 Sekunden!",

	teleport_bar = "Teleport!",
	back_bar = "R\195\188ckteleport!",

	["Eye Stalk"] = "Augenstrunk",
	["Rotting Maggot"] = "Faulende Made",
} end )

L:RegisterTranslations("zhCN", function() return {
	starttrigger = "你是我的了。",
	starttrigger2 = "你……就是下一个。",
	starttrigger3 = "我看到你了……",

	engage = "激怒警报",
	engage_desc = "激怒警报.",
	engage_message = "希尔盖已激活 - 90秒后传送！",
	
	teleport = "传送",
	teleport_desc = "当传送时发出警报。",
	teleport_1min_message = "1分钟后传送",
	teleport_30sec_message = "30秒后传送",
	teleport_10sec_message = "10秒后传送！",
	teleport_trigger = "你的生命正走向终结。",
	on_platform_message = "传送发动！45秒后希尔盖出现！",

	to_floor_30sec_message = "30秒后返回",
	to_floor_10sec_message = "10秒后返回！",
	on_floor_message = "返回！约90秒后再次传送！",

	teleport_bar = "<传送>",
	back_bar = "<出现>",

	["Eye Stalk"] = "眼柄",
	["Rotting Maggot"] = "腐烂之蛆",
} end )

L:RegisterTranslations("zhTW", function() return {
	teleport = "傳送警報",
	teleport_desc = "傳送警報",

	engage = "進入戰鬥警報",
	engage_desc = "海根進入戰鬥警告",

	-- [[ Triggers ]]--
	starttrigger = "你是我的了。",
	starttrigger2 = "你……就是下一個。",
	starttrigger3 = "我看到你了……",
	teleport_trigger = "你的生命正走向終結。",

	-- [[ Warnings ]]--
	engage_message = "海根已進入戰鬥 - 90 秒後傳送",
	teleport_1min_message = "1 分鐘後傳送",
	teleport_30sec_message = "30 秒後傳送",
	teleport_10sec_message = "10 秒後傳送",
	on_floor_message = "海根出現 - 90 秒後再次傳送",
	to_floor_30sec_message = "30 秒後海根出現",
	to_floor_10sec_message = "10 秒後海根出現",
	on_platform_message = "傳送發動！ - 45 秒後海根出現！",

	-- [[ Bars ]]--
	teleport_bar = "傳送！",
	back_bar = "出現！",

	-- [[ Dream Room Mobs ]] --
	["Eye Stalk"] = "眼柄",
	["Rotting Maggot"] = "腐爛的蛆蟲",
} end )

L:RegisterTranslations("frFR", function() return {
	starttrigger = "Vous êtes à moi, maintenant.",
	starttrigger2 = "Tu es… le suivant.",
	starttrigger3 = "Je vous vois…",

	engage = "Engagement",
	engage_desc = "Préviens quand Heigan est engagé.",
	engage_message = "Heigan l'Impur engagé ! 90 sec. avant téléportation !",

	teleport = "Téléportation",
	teleport_desc = "Préviens quand Heigan se téléporte.",
	teleport_trigger = "Votre fin est venue.",
	teleport_1min_message = "Téléportation dans 1 min.",
	teleport_30sec_message = "Téléportation dans 30 sec.",
	teleport_10sec_message = "Téléportation dans 10 sec. !",
	on_platform_message = "Téléportation ! Sur la plate-forme pendant 45 sec. !",

	to_floor_30sec_message = "De retour dans 30 sec.",
	to_floor_10sec_message = "De retour dans 10 sec. !",
	on_floor_message = "De retour sur le sol ! 90 sec. avant téléportation !",

	teleport_bar = "Téléportation",
	back_bar = "Retour sur le sol",

	["Eye Stalk"] = "Oeil pédonculé",
	["Rotting Maggot"] = "Asticot pourrissant",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15936
mod.wipemobs = {L["Eye Stalk"], L["Rotting Maggot"]}
mod.toggleoptions = {"engage", "teleport", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:AddCombatListener("UNIT_DIED", "BossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["starttrigger"]) or msg:find(L["starttrigger2"]) or msg:find(L["starttrigger3"]) then
		if self.db.profile.engage then
			self:Message(L["engage_message"], "Important")
		end
		if self.db.profile.teleport then
			self:Bar(L["teleport_bar"], 90, "Spell_Arcane_Blink")
			self:DelayedMessage(30, L["teleport_1min_message"], "Attention")
			self:DelayedMessage(60, L["teleport_30sec_message"], "Urgent")
			self:DelayedMessage(80, L["teleport_10sec_message"], "Important")
		end
	elseif msg:find(L["teleport_trigger"]) then
		self:ScheduleEvent("BWBackToRoom", self.BackToRoom, 45, self)

		if self.db.profile.teleport then
			self:Message(L["on_platform_message"], "Attention")
			self:DelayedMessage(15, L["to_floor_30sec_message"], "Urgent")
			self:DelayedMessage(35, L["to_floor_10sec_message"], "Important")
			self:Bar(L["back_bar"], 45, "Spell_Magic_LesserInvisibilty")
		end
	end
end

function mod:BackToRoom()
	if self.db.profile.teleport then
		self:Message(L["on_floor_message"], "Attention")
		self:DelayedMessage(60, L["teleport_30sec_message"], "Urgent")
		self:DelayedMessage(80, L["teleport_10sec_message"], "Important")
		self:Bar(L["teleport_bar"], 90, "Spell_Arcane_Blink")
	end
end
