------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Akil'zon"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local CheckInteractDistance = CheckInteractDistance
local db = nil
local pName = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Akil'zon",

	engage_trigger = "I be da predator! You da prey...",
	engage_message = "%s Engaged - Storm in ~55sec!",

	elec = "Electrical Storm",
	elec_desc = "Warn who has Electrical Storm.",
	elec_trigger = "An electrical storm appears!",
	elec_bar = "~Storm Cooldown",
	elec_message = "Storm on %s!",
	elec_warning = "Storm soon!",

	ping = "Ping",
	ping_desc = "Ping your current location if you are afflicted by Electrical Storm.",
	ping_message = "Storm - Pinging your location!",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Target Icon on the player with Electrical Storm. (requires promoted or higher)",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "나는 사냥꾼이다! 너흰 먹잇감이고...",
	engage_message = "%s 전투 시작 - ~55초 이내 폭풍!",

	elec = "전하 폭풍",
	elec_desc = "전하 폭풍에 걸린 플레이어를 알립니다.",
	elec_trigger = "받아라, 전하 폭풍!",
	elec_bar = "~폭풍 대기 시간",
	elec_message = "%s에 전하 폭풍!",
	elec_warning = "잠시후 전하 폭풍!",

	ping = "미니맵 표시",
	ping_desc = "당신이 전하 폭풍에 걸렸을때 현재 위치를 미니맵에 표시합니다.",
	ping_message = "폭풍 - 현재 위치 미니맵에 찍는 중!",

	icon = "전술 표시",
	icon_desc = "전하 폭풍 대상이된 플레이어에 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Moi, chuis le prédateur ! Vous, z'êtes la proie…",
	engage_message = "%s engagé - Orage dans ~55 sec. !",

	elec = "Orage électrique",
	elec_desc = "Préviens quand un joueur subit les effets de l'Orage électrique.",
	elec_trigger = "Un orage électrique apparaît !",
	elec_bar = "~Cooldown Orage",
	elec_message = "Orage sur %s !",
	elec_warning = "Orage imminent !",

	ping = "Ping",
	ping_desc = "Indique votre position actuelle sur la minicarte si vous subissez les effets de l'Orage électrique.",
	ping_message = "Orage - Position signalée sur la minicarte !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par l'Orage électrique (nécessite d'être promu ou mieux).",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Ich bin der Jäger! Ihr seid die Beute...",
	engage_message = "%s angegriffen - Sturm in ~55sec!",

	elec = "Elektrischer Sturm",
	elec_desc = "Gib Warnung mit dem Spielernamen des Ziels von Elektrischer Sturm aus.",
	--elec_trigger = "^(%S+) (%S+) von Elektrischer Sturm betroffen%.$",
	elec_bar = "~Sturm Cooldown",
	elec_message = "Sturm auf %s!",
	elec_warning = "Sturm bald!",

	ping = "Ping",
	ping_desc = "Pinge deinen Standort, wenn du von Elektrischer Sturm betroffen bist.",
	ping_message = "Sturm - Pinge deinen Standort!",

	icon = "Schlachtzugsymbol",
	icon_desc = "Platziere ein Schlachtzugsymbol auf dem Spieler, der von Elektrischer Sturm betroffen ist (benötigt Assistent oder höher).",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "我是猎鹰，而你们，就是猎物！",
	engage_message = "%s 激活 - ~55秒 后电能风暴！",

	elec = "电能风暴",
	elec_desc = "当谁中了电能风暴发出警报。",
	--elec_trigger = "^(.+)受(.+)了电能风暴效果的影响。$",
	elec_bar = "<电能风暴 冷却>",
	elec_message = "电能风暴：>%s<！",
	elec_warning = "即将电能风暴！",

	ping = "点击",
	ping_desc = "若你受到电能风暴再你当前区域点击小地图发出警报。",
	ping_message = "风暴 - 本区域发动了~快在小地图上点你位置！",

	icon = "团队标记",
	icon_desc = "给中了电能风暴的玩家打上标记。(需要权限)",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "我是掠食者!而你們，就是獵物!",
	engage_message = "%s 開打了 - 55 秒後電荷風暴!",

	elec = "電荷風暴",
	elec_desc = "警告誰受到電荷風暴",
	elec_trigger = "出現一股電氣暴風!",
	elec_bar = "~電荷風暴冷卻",
	elec_message = "電荷風暴：[%s]",
	elec_warning = "電荷風暴即將來臨!",

	ping = "點擊",
	ping_desc = "若你中了電荷風暴，在小地圖點擊你的位置",
	ping_message = "電荷風暴 - 在小地圖點擊你的位置!",

	icon = "標記圖示",
	icon_desc = "為被電荷風暴的玩家設置團隊標記（需要權限）",
} end )

L:RegisterTranslations("esES", function() return {
	engage_trigger = "\194\161Yo soy el depredador! Vosotros la presa...",
	engage_message = "\194\161%s Activado - Tormenta en ~55seg!",

	elec = "Tormenta el\195\169ctrica",
	elec_desc = "Avisa quien Tormenta el\195\169ctrica.",
	--elec_trigger = "^(%S+) (%S+) sufre Tormenta el\195\169ctrica%.$",
	elec_bar = "~Regeneraci\195\179n de Tormenta",
	elec_message = "Tormenta en %s!",
	elec_warning = "\194\161Tormenta pronto!",

	ping = "Ping",
	ping_desc = "Se\195\177ala tu posici\195\179n actual si sufres Tormenta el\195\169ctrica.",
	ping_message = "\194\161Tormenta - Se\195\177alando tu posici\195\179n!",

	icon = "Icono de banda",
	icon_desc = "Coloca un icono de banda en el jugador conTormenta el\195\169ctrica. (requiere asistente o superior)",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"elec", "ping", "icon", "enrage", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	db = self.db.profile
	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		if db.enrage then
			self:DelayedMessage(300, L2["enrage_min"]:format(5), "Positive")
			self:DelayedMessage(420, L2["enrage_min"]:format(3), "Positive")
			self:DelayedMessage(540, L2["enrage_min"]:format(1), "Positive")
			self:DelayedMessage(570, L2["enrage_sec"]:format(30), "Positive")
			self:DelayedMessage(590, L2["enrage_sec"]:format(10), "Urgent")
			self:DelayedMessage(595, L2["enrage_sec"]:format(5), "Urgent")
			self:DelayedMessage(600, L2["enrage_end"]:format(boss), "Attention", nil, "Alarm")
			self:Bar(L2["enrage"], 600, "Spell_Shadow_UnholyFrenzy")
		end
		if db.elec then
			self:Message(L["engage_message"]:format(boss), "Positive")
			self:Bar(L["elec_bar"], 50, "Spell_Lightning_LightningBolt01")
			self:DelayedMessage(47, L["elec_warning"], "Urgent")
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, a, b, c, player)
	if not db.elec then return end

	if msg == L["elec_trigger"] then
		local show = L["elec_message"]:format(player)
		self:Message(show, "Attention")
		self:Bar(show, 8, "Spell_Nature_EyeOfTheStorm")
		self:Bar(L["elec_bar"], 55, "Spell_Lightning_LightningBolt01")
		self:DelayedMessage(48, L["elec_warning"], "Urgent")
		if player == pName and db.ping then
			Minimap:PingLocation()
			BigWigs:Print(L["ping_message"])
		end
		if db.icon then
			self:Icon(player)
			self:ScheduleEvent("BWRemoveAkilIcon", "BigWigs_RemoveRaidIcon", 10, self)
		end
	end
end
