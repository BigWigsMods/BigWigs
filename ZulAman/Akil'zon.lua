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

	ping = "Ping",
	ping_desc = "Ping your current location if you are afflicted by Electrical Storm.",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Target Icon on the player with Electrical Storm. (requires promoted or higher)",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "내가 끝장내리라! 네놈을 제물 삼아...",
	engage_message = "%s 전투 시작 - ~55이내 폭풍!",

	elec = "전기 폭풍",
	elec_desc = "부화사 등장에 대한 경고입니다.",
	elec_trigger = "^([^|;%s]*)(.*)전기 폭풍에 걸렸습니다%.$",
	elec_bar = "~폭풍 대기 시간",
	elec_message = "%s에 폭풍!",

	ping = "미니맵 표시",
	ping_desc = "당신이 전기 폭풍에 걸렸을때 현재 위치를 미니맵에 표시합니다.",

	icon = "전술 표시",
	icon_desc = "전기 폭풍 대상이된 플레이어에 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
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
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "AkilElec" and rest and self.db.profile.elec then
		local show = L["elec_message"]:format(rest)
		self:Message(show, "Attention")
		self:Bar(show, 8, "Spell_Nature_EyeOfTheStorm")
		self:Bar(L["elec_bar"], 55, "Spell_Lightning_LightningBolt01")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	end
end
