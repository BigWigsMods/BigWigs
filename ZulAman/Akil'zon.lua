------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Akil'zon"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

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
	elec_trigger = "^(%S+) (%S+) afflicted by Electrical Storm%.$",
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
	engage_trigger = "나는 사냥꾼이다! 너흰 먹이감이고...",
	engage_message = "%s 전투 시작 - ~55초 이내 폭풍!",

	elec = "전하 폭풍",
	elec_desc = "전하 폭풍에 걸린 플레이어를 알립니다.",
	elec_trigger = "^([^|;%s]*)(.*)전하 폭풍에 걸렸습니다%.$",
	elec_bar = "~폭풍 대기 시간",
	elec_message = "%s에 전하 폭풍!",
	elec_warning = "잠시후 전하 폭풍!",

	ping = "미니맵 표시",
	ping_desc = "당신이 전기 폭풍에 걸렸을때 현재 위치를 미니맵에 표시합니다.",
	ping_message = "폭풍 - 현재 위치 미니맵에 찍는 중!",

	icon = "전술 표시",
	icon_desc = "전하 폭풍 대상이된 플레이어에 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Moi, chuis le prédateur ! Vous, z'êtes la proie…",
	engage_message = "%s engagé - Orage dans ~55 sec. !",

	elec = "Orage électrique",
	elec_desc = "Préviens quand un joueur subit les effets de l'Orage électrique.",
	elec_trigger = "^(%S+) (%S+) les effets .* Orage électrique%.$",
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
	elec_trigger = "^(%S+) (%S+) von Elektrischer Sturm betroffen%.$",
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
	engage_trigger = "I be da predator! You da prey...",
	engage_message = "%s 激活 - ~55秒后 风暴!",

	elec = "电场风暴",
	elec_desc = "当谁中了电场风暴发出警报.",
	elec_trigger = "^(%S+)受(%S+)了Electrical Storm效果的影响。$",
	elec_bar = "~风暴冷却",
	elec_message = "风暴 于 >%s<!",
	elec_warning = "即将风暴!",

	ping = "Ping",
	ping_desc = "Ping your current location if you are afflicted by Electrical Storm.",
	ping_message = "风暴 - Pinging your location!",

	icon = "团队标记",
	icon_desc = "给中了电场风暴的玩家打上标记. (需要权限)",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"elec", "ping", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Storm")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Storm")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Storm")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "AkilElec", 10)

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Storm(msg)
	if not self.db.profile.elec then return end

	local eplayer, etype = select(3, msg:find(L["elec_trigger"]))
	if eplayer and etype then
		if eplayer == L2["you"] and etype == L2["are"] then
			eplayer = pName
			if self.db.profile.ping then
				Minimap:PingLocation()
				BigWigs:Print(L["ping_message"])
			end
		end
		self:Sync("AkilElec", eplayer)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if not self.db.profile.elec then return end

	if msg == L["engage_trigger"] then
		self:Message(L["engage_message"]:format(boss), "Positive")
		self:Bar(L["elec_bar"], 55, "Spell_Lightning_LightningBolt01")
		self:DelayedMessage(43, L["elec_warning"], "Urgent")
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "AkilElec" and rest and self.db.profile.elec then
		local show = L["elec_message"]:format(rest)
		self:Message(show, "Attention")
		self:Bar(show, 8, "Spell_Nature_EyeOfTheStorm")
		self:Bar(L["elec_bar"], 55, "Spell_Lightning_LightningBolt01")
		self:DelayedMessage(48, L["elec_warning"], "Urgent")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	end
end
