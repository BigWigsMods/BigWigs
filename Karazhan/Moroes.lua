------------------------------
--     Are you local?     --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Moroes"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local enrageannounced

----------------------------
--      Localization     --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Moroes",

	engage_cmd = "engage",
	engage_name = "Engage",
	engage_desc = ("Warn when %s is pulled"):format(boss),

	vanish_cmd = "vanish",
	vanish_name = "Vanish",
	vanish_desc = "Vanish estimated timers",

	garrote_cmd = "garrote",
	garrote_name = "Garrote",
	garrote_desc = "Notify of players afflicted by Garrote",

	enrage_cmd = "enrage",
	enrage_name = "Enrage",
	enrage_desc = ("Warn when %s becomes enraged"):format(boss),

	icon_cmd = "icon",
	icon_name = "Icon",
	icon_desc = "Place a Raid Icon on the player afflicted by Garrote(requires promoted or higher)",

	vanish_trigger1 = "You rang?",
	vanish_trigger2 = "Now, where was I? Oh, yes...",
	vanish_message = "Vanished! Next in ~35sec!",
	vanish_warning = "Vanish Soon!",
	vanish_bar = "Next Vanish",

	garrote_trigger = "^([^%s]+) ([^%s]+) afflicted by Garrote",
	garrote_message = "Garrote: %s",

	engage_trigger = "Hm, unannounced visitors. Preparations must be made...",
	engage_message = "%s Engaged - Vanish in ~35sec!",

	enrage_trigger = "%s becomes enraged!",
	enrage_message = "Enrage!",
	enrage_warning = "Enrage Soon!",

	you = "You",
} end)

L:RegisterTranslations("frFR", function() return {
	engage_name = "Alerte Engagement",
	engage_desc = "Pr\195\169viens du d\195\169but du combat.",

	vanish_name = "Alerte Disparition",
	vanish_desc = "Pr\195\169viens quand Moroes disparait.",

	garrote_name = "Alerte Garrot",
	garrote_desc = "Pr\195\169viens des joueurs qui subissent le Garrot.",

	enrage_name = "Alerte Enrager",
	enrage_desc = "Pr\195\169viens quand Moroes devient enrag\195\169.",

	vanish_trigger1 = "Vous avez sonn\195\169\194\160?",
	vanish_trigger2 = "Bon, o\195\185 en \195\169tais-je\194\160? Ah, oui\226\128\166",
	vanish_message = "Disparu ! Prochain dans ~35 secondes !",
	vanish_warning = "Disparition imminente !",
	vanish_bar = "Prochaine Disparition",

	garrote_trigger = "^([^%s]+) ([^%s]+) les effets de Garrot",
	garrote_message = "Garrot: %s",

	engage_trigger = "Hum. Des visiteurs impr\195\169vus. Il va falloir se pr\195\169parer.",
	engage_message = "Moroes Engag\195\169 - Disparition dans ~35 secondes !",

	enrage_trigger = "%s devient fou furieux\194\160!",
	enrage_message = "Enrag\195\169 !",
	enrage_warning = "Enrag\195\169 Imminent !",

	you = "Vous",
} end)

L:RegisterTranslations("deDE", function() return {
	vanish_name = "Verschwinden",
	vanish_desc = "Ungef\195\164re Zeitangabe f\195\188r Verschwinden",

	garrote_name = "Erdrosseln",
	garrote_desc = "Warnt welche Spieler von Erdrosseln betroffen sind",

	enrage_name = "Enrage",
	enrage_desc = ("Warnt wenn %s w\195\188tend wird"):format(boss),

	icon_name = "Icon",
	icon_desc = "Platziert ein Schlachtzugssymbol bei dem Spieler, welcher von Erdrosseln betroffen ist (ben\195\182tigt 'bef\195\182rdert' oder h\195\182her)",

	vanish_trigger1 = "Ihr habt gel\195\164utet?",
	vanish_trigger2 = "Nun, wo war ich? Ah, ja...",
	vanish_message = "Verschwunden! N\195\164chste in ~35 Sek!",
	vanish_warning = "Verschwinden bald!",
	vanish_bar = "N\195\164chste Verschwinden",

	garrote_trigger = "^([^%s]+) ([^%s]+) von Erdrosseln betroffen",
	garrote_message = "Erdrosseln: %s",

	engage_trigger = "Hm, unangek\195\188ndigte Besucher. Es m\195\188ssen Vorbereitungen getroffen werden...",
	engage_message = "%s Engaged - Verschwinden in ~35 Sek!",

	enrage_trigger = "%s wird w\195\188tend!",
	enrage_message = "Enrage!",
	enrage_warning = "Enrage bald!",

	you = "Ihr",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_name = "전투시작",
	engage_desc = ("%s 전투 시작 알림"):format(boss),

	vanish_name = "소멸",
	vanish_desc = "소멸 예상 시간",

	garrote_name = "목조르기",
	garrote_desc = "목조르기에 걸린 사람 알림",

	enrage_name = "광폭화",
	enrage_desc = ("%s 광폭화시 알림"):format(boss),

	icon_name = "아이콘",
	icon_desc = "목조르기에 걸린 사람에게 공격대 아이콘 지정(승급자 이상의 권한 필요)",

	vanish_trigger1 = "You rang?", -- check
	vanish_trigger2 = "Now, where was I? Oh, yes...", -- check
	vanish_message = "사라짐! 다음은 약 35초 후!",
	vanish_warning = "잠시후 사라짐!", 
	vanish_bar = "다음 사라짐",

	garrote_trigger = "^([^|;%s]*)(.*)목조르기에 걸렸습니다%.$", -- "^([^%s]+) ([^%s]+) afflicted by Garrote", -- check
	garrote_message = "목조르기: %s",

	engage_trigger = "Hm, unannounced visitors. Preparations must be made...", -- check
	engage_message = "%s 전투 시작 - 약 35초 후 사라짐!",

	enrage_trigger = "%s|1이;가; 격노 효과를 얻었습니다." -- "%s becomes enraged!", -- check
	enrage_message = "격노!",
	enrage_warning = "잠시 후 격노!",

	you = "당신은",
} end)

----------------------------------
--   Module Declaration    --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = boss
mod.toggleoptions = {"engage", "vanish", "enrage", -1, "garrote", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	enrageannounced = nil

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "GarroteEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "GarroteEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "GarroteEvent")

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MoroesGarrote", 5)
end

------------------------------
--    Event Handlers     --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.vanish and (msg == L["vanish_trigger1"] or msg == L["vanish_trigger2"]) then
		self:Message(L["vanish_message"], "Urgent", nil, "Alert")
		self:NextVanish()
	elseif self.db.profile.engage and msg == L["engage_trigger"] then
		self:Message(L["engage_message"]:format(boss), "Attention")
		self:NextVanish()
	end
end

function mod:NextVanish()
	self:Bar(L["vanish_bar"], 35, "Ability_Vanish")
	self:DelayedMessage(30, L["vanish_warning"], "Attention")
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if self.db.profile.enrage and msg == L["enrage_trigger"] then
		self:Message(L["enrage_message"], "Important", nil, "Alarm")
	end
end

function mod:UNIT_HEALTH(msg)
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 30 and health <= 34 and not enrageannounced then
			if self.db.profile.enrage then
				self:Message(L["enrage_warning"], "Positive", nil, "Info")
			end
			enrageannounced = true
		elseif health > 40 and enrageannounced then
			enrageannounced = nil
		end
	end
end

function mod:GarroteEvent(msg)
	local gplayer, gtype = select(3, msg:find(L["garrote_trigger"]))
	if gplayer then
		if gplayer == L["you"] then
			gplayer = UnitName("player")
		end
		self:Sync("MoroesGarrote "..gplayer)
	end
end

function mod:BigWigs_RecvSync( sync, rest, nick )
	if sync == "MoroesGarrote" and rest and self.db.profile.garrote then
		self:Message(L["garrote_message"]:format(rest), "Attention")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	end
end
