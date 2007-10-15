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
	engage_trigger = "내가 끝장내리라! 네놈을 제물 삼아...",
	engage_message = "%s 전투 시작 - ~55초 이내 폭풍!",

	elec = "전기 폭풍",
	elec_desc = "전기 폭풍에 걸린 플레이어를 알립니다.",
	--elec_trigger = "^([^|;%s]*)(.*)전기 폭풍에 걸렸습니다%.$",
	elec_trigger = "^([^|;%s]*)(.*)Electrical Storm에 걸렸습니다%.$", -- 현재 PTR 서버, 스킬명 한글화 안되어 있음
	elec_bar = "~폭풍 대기 시간",
	elec_message = "%s에 폭풍!",
	elec_warning = "잠시후 폭풍!",

	ping = "미니맵 표시",
	ping_desc = "당신이 전기 폭풍에 걸렸을때 현재 위치를 미니맵에 표시합니다.",
	ping_message = "폭풍 - 현재 위치 미니맵에 찍는 중!",

	icon = "전술 표시",
	icon_desc = "전기 폭풍 대상이된 플레이어에 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Moi, chuis le prédateur ! Vous, z'êtes la proie…",
	engage_message = "%s engagé - Orage dans ~55 sec. !",

	elec = "Orage électrique",
	elec_desc = "Préviens quand un joueur subit les effets de l'Orage électrique.",
	elec_trigger = "^(%S+) (%S+) les effets .* Orage électrique%.$",
	elec_bar = "~Cooldown Orage",
	elec_message = "Orage sur %s !",
	--elec_warning = "Storm soon!",

	ping = "Ping",
	ping_desc = "Indique votre position actuelle sur la minicarte si vous subissez les effets de l'Orage électrique.",
	--ping_message = "Storm - Pinging your location!",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par l'Orage électrique (nécessite d'être promu ou mieux).",
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
				Minimap:PingLocation(CURSOR_OFFSET_X, CURSOR_OFFSET_Y)
				BigWigs:Print(L["ping_message"])
			end
		end
		self:Sync("AkilElec ", eplayer)
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
