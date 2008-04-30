------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Akil'zon"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local CheckInteractDistance = CheckInteractDistance
local db = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Akil'zon",

	engage_trigger = "I be da predator! You da prey...",
	engage_message = "%s Engaged - Storm in ~55sec!",

	elec = "Electrical Storm",
	elec_desc = "Warn who has Electrical Storm.",
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
	elec_bar = "~폭풍 대기 시간",
	elec_message = "%s에 전하 폭풍!",
	elec_warning = "잠시후 전하 폭풍!",

	ping = "미니맵 표시",
	ping_desc = "자신이 전하 폭풍에 걸렸을 때 현재 위치를 미니맵에 표시합니다.",
	ping_message = "폭풍 - 현재 위치 미니맵에 표시 중!",

	icon = "전술 표시",
	icon_desc = "전하 폭풍 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Moi, chuis le prédateur ! Vous, z'êtes la proie…",
	engage_message = "%s engagé - Orage dans ~55 sec. !",

	elec = "Orage électrique",
	elec_desc = "Prévient quand un joueur subit les effets de l'Orage électrique.",
	elec_bar = "~Recharge Orage",
	elec_message = "Orage sur %s !",
	elec_warning = "Orage imminent !",

	ping = "Ping",
	ping_desc = "Indique votre position actuelle sur la minicarte si vous subissez les effets de l'Orage électrique.",
	ping_message = "Orage - Position signalée sur la minicarte !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par l'Orage électrique (nécessite d'être promu ou mieux).",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Ich bin der Jäger! Ihr seid die Beute...",
	engage_message = "%s angegriffen - Sturm in ~55sec!",

	elec = "Elektrischer Sturm",
	elec_desc = "Gib Warnung mit dem Spielernamen des Ziels von Elektrischer Sturm aus.",
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
	engage_message = "%s 激活！ - 约55秒后，电能风暴！",

	elec = "电能风暴",
	elec_desc = "当玩家受到电能风暴时发出警报。",
	elec_bar = "<电能风暴 冷却>",
	elec_message = "电能风暴：>%s<！",
	elec_warning = "即将 电能风暴！",

	ping = "点击",
	ping_desc = "若你受到电能风暴再你当前区域点击小地图发出警报。",
	ping_message = "风暴！本区域发动了，快在小地图上点你位置！",

	icon = "团队标记",
	icon_desc = "给中了电能风暴的玩家打上标记。（需要权限）",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "我是掠食者!而你們，就是獵物!",
	engage_message = "%s 開打了 - 55 秒後電荷風暴!",

	elec = "電荷風暴",
	elec_desc = "警告誰受到電荷風暴",
	elec_bar = "<電荷風暴冷卻>",
	elec_message = "電荷風暴: [%s]",
	elec_warning = "電荷風暴即將來臨!",

	ping = "點擊",
	ping_desc = "若你中了電荷風暴，在小地圖點擊你的位置",
	ping_message = "電荷風暴 - 在小地圖點擊你的位置!",

	icon = "標記圖示",
	icon_desc = "為被電荷風暴的玩家設置團隊標記（需要權限）",
} end )

L:RegisterTranslations("esES", function() return {
	engage_trigger = "¡Yo soy el depredador! Vosotros la presa...",
	engage_message = "¡%s Activado - Tormenta en ~55seg!",

	elec = "Tormenta eléctrica (Electrical Storm)",
	elec_desc = "Avisa quién tiene Tormenta eléctrica.",
	elec_bar = "~Tormenta eléctrica",
	elec_message = "¡Tormenta en %s!",
	elec_warning = "Tormenta en breve",

	ping = "Señalar posición",
	ping_desc = "Señala tu posición actual si sufres Tormenta eléctrica.",
	ping_message = "¡Tormenta - Señalando tu posición!",

	icon = "Icono de banda",
	icon_desc = "Pone un icono de banda en el jugador con Tormenta eléctrica. (Requiere derechos de banda)",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"elec", "ping", "icon", "enrage", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Storm", 43648)
	self:AddCombatListener("SPELL_AURA_REMOVED", "RemoveIcon", 43648)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Storm(player, spellID)
	if not db.elec then return end

	local show = L["elec_message"]:format(player)
	self:IfMessage(show, "Attention", spellID)
	self:Bar(show, 8, spellID)
	self:Bar(L["elec_bar"], 55, spellID)
	self:DelayedMessage(48, L["elec_warning"], "Urgent")
	if UnitIsUnit(player, "player") and db.ping then
		Minimap:PingLocation()
		BigWigs:Print(L["ping_message"])
	end
	self:Icon(player, "icon")
end

function mod:RemoveIcon()
	self:TriggerEvent("BigWigs_RemoveRaidIcon")
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		if db.enrage then
			self:Enrage(600, true, true)
		end
		if db.elec then
			self:Message(L["engage_message"]:format(boss), "Positive")
			self:Bar(L["elec_bar"], 50, 43648)
			self:DelayedMessage(47, L["elec_warning"], "Urgent")
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
	end
end

