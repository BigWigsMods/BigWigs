------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Moroes"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local enrageWarn = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Moroes",

	engage_trigger = "Hm, unannounced visitors. Preparations must be made...",
	engage_message = "%s Engaged - Vanish in ~35sec!",

	vanish = "Vanish",
	vanish_desc = "Estimated timers for when Moroes next vanishes.",
	vanish_trigger1 = "You rang?",
	vanish_trigger2 = "Now, where was I? Oh, yes...",
	vanish_message = "Vanished! Next in ~35sec!",
	vanish_warning = "Vanish Soon!",
	vanish_bar = "~Vanish Cooldown",

	garrote = "Garrote",
	garrote_desc = "Notify of players afflicted by Garrote.",
	garrote_trigger = "^(%S+) (%S+) afflicted by Garrote%.$",
	garrote_message = "Garrote: %s",

	icon = "Icon",
	icon_desc = "Place a Raid Icon on the player afflicted by Garrote(requires promoted or higher).",

	enrage_trigger = "%s becomes enraged!",
	enrage_message = "Enrage!",
	enrage_warning = "Enrage Soon!",
} end)

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Hum. Des visiteurs imprévus. Il va falloir se préparer.",
	engage_message = "Moroes engagé - Disparition dans ~35 sec. !",

	vanish = "Disparition",
	vanish_desc = "Préviens quand Moroes est susceptible de disparaître.",
	vanish_trigger1 = "Vous avez sonné ?",
	vanish_trigger2 = "Bon, où en étais-je ? Ah, oui…",
	vanish_message = "Disparu ! Prochain dans ~35 sec. !",
	vanish_warning = "Disparition imminente !",
	vanish_bar = "~Cooldown Disparition",

	garrote = "Garrot",
	garrote_desc = "Préviens quand un joueur subit les effets du Garrot.",
	garrote_trigger = "^(%S+) (%S+) les effets .* Garrot%.$",
	garrote_message = "Garrot : %s",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par le Garrot (nécessite d'être promu ou mieux).",

	enrage_trigger = "%s devient fou furieux !",
	enrage_message = "Enragé !",
	enrage_warning = "Bientôt enragé !",
} end)

L:RegisterTranslations("deDE", function() return {
	vanish = "Verschwinden",
	vanish_desc = "Ungef\195\164re Zeitangabe f\195\188r Verschwinden",

	garrote = "Erdrosseln",
	garrote_desc = "Warnt welche Spieler von Erdrosseln betroffen sind",

	icon = "Icon",
	icon_desc = "Platziert ein Schlachtzugssymbol bei dem Spieler, welcher von Erdrosseln betroffen ist (ben\195\182tigt 'bef\195\182rdert' oder h\195\182her)",

	vanish_trigger1 = "Ihr habt gel\195\164utet?",
	vanish_trigger2 = "Nun, wo war ich? Ah, ja...",
	vanish_message = "Verschwunden! N\195\164chste in ~35 Sek!",
	vanish_warning = "Verschwinden bald!",
	vanish_bar = "N\195\164chste Verschwinden",

	garrote_trigger = "^([^%s]+) ([^%s]+) von Erdrosseln betroffen%.$",
	garrote_message = "Erdrosseln: %s",

	engage_trigger = "Hm, unangek\195\188ndigte Besucher. Es m\195\188ssen Vorbereitungen getroffen werden...",
	engage_message = "%s Engaged - Verschwinden in ~35 Sek!",

	enrage_trigger = "%s wird w\195\188tend!",
	enrage_message = "Enrage!",
	enrage_warning = "Enrage bald!",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "음, 예상치 못한 손님들이군. 준비를 해야겠어...",
	engage_message = "%s 전투 시작 - 약 35초 후 소멸!",

	vanish = "소멸",
	vanish_desc = "모로스의 다음 소멸에 대한 예상 타이머입니다.",
	vanish_trigger1 = "절 부르셨습니까?",
	vanish_trigger2 = "어디까지 했죠? 아, 맞아...",
	vanish_message = "소멸! 다음은 약 35초 후!",
	vanish_warning = "잠시 후 소멸!", 
	vanish_bar = "~소멸 대기시간",

	garrote = "목조르기",
	garrote_desc = "목조르기에 걸린 사람을 알립니다.",
	garrote_trigger = "^([^|;%s]*)(.*)목조르기에 걸렸습니다%.$",
	garrote_message = "목조르기: %s",

	icon = "전술 표시",
	icon_desc = "목조르기에 걸린 사람에게 전술 표시를 지정합니다 (승급자 이상의 권한 필요).",

	enrage_trigger = "%s|1이;가; 분노에 휩싸입니다!",
	enrage_message = "격노!",
	enrage_warning = "잠시 후 격노!",
} end)

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "啊，不速之客。我得准备一下……",
	engage_message = "%s 激活 - ~35 秒后将 消失!",

	vanish = "消失",
	vanish_desc = "消失 预计冷却计时条.",
	vanish_trigger1 = "你叫我吗？",
	vanish_trigger2 = "我说到哪里了？哦，对了……",
	vanish_message = "消失! 35 秒后再次消失！",
	vanish_warning = "即将 消失！",
	vanish_bar = "消失 冷却",

	garrote = "锁喉",
	garrote_desc = "当队员受到锁喉时发送警告.",
	garrote_trigger = "^([^%s]+)受([^%s]+)了锁喉效果的影响。$",
	garrote_message = "锁喉: %s",

	icon = "标记",
	icon_desc = "当队员受到锁喉时，标上团队标记(需要团长或者助理).",

	enrage_trigger = "%s变得愤怒了！",--check
	enrage_message = "激怒!",
	enrage_warning = "即将 激怒!",
} end)

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "嗯，突然上門的訪客。一定要做好準備……",
	engage_message = "%s 進入戰鬥 - 將於 35 秒後消失",

	vanish = "消失預警",
	vanish_desc = "顯示摩洛消失提示",
	vanish_trigger1 = "你找我嗎?",
	vanish_trigger2 = "呃，我說到哪了?喔，對了……",
	vanish_message = "消失 - 35 秒再次消失",
	vanish_warning = "摩洛即將消失",
	vanish_bar = "消失倒數",

	garrote = "絞喉警告",
	garrote_desc = "當有玩家被絞喉時發送警告",
	garrote_trigger = "^(.+)受(到[了]*)絞喉效果的影響。",
	garrote_message = "被絞喉：[%s]",

	icon = "標記圖示",
	icon_desc = "為被絞喉的玩家設置團隊標記（需要權限）",

	enrage_trigger = "%s變得憤怒了!",--要抓 combatlog
	enrage_message = "憤怒",
	enrage_warning = "摩洛即將進入憤怒狀態",
} end)

L:RegisterTranslations("esES", function() return {
	engage_trigger = "Mm, visitantes inesperados. Hay que hacer preparativos...",
	engage_message = "%s Activado - Vanish en ~35sec!",

	vanish = "Vanish",
	vanish_desc = "Timers estimados para el Vanish.",
	vanish_trigger1 = "Has llamado?",
	vanish_trigger2 = "Bueno, por dónde iba? Ah, sí...",
	vanish_message = "Vanished! Siguiente en ~35sec!",
	vanish_warning = "Vanish Pronto!",
	vanish_bar = "~Enfriamiento de Vanish",

	garrote = "Garrote",
	garrote_desc = "Notifica que jugador ha sido afectado por Garrote.",
	garrote_trigger = "^([^%s]+) ([^%s]+) sufre Garrote%.$",
	garrote_message = "Garrote: %s",

	icon = "Icono",
	icon_desc = "Pone un icono de Raid en el jugador afectado por Garrote(requiere promoted o mas alto).",

	enrage_trigger = "%s gana Enfurecer.",
	enrage_message = "Enfurecido!",
	enrage_warning = "Enfurecimiento Pronto!",
} end)


----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = boss
mod.toggleoptions = {"vanish", "enrage", -1, "garrote", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "GarroteEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "GarroteEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "GarroteEvent")

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MoroesGarrote", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.vanish and (msg == L["vanish_trigger1"] or msg == L["vanish_trigger2"]) then
		self:Message(L["vanish_message"], "Urgent", nil, "Alert")
		self:NextVanish()
	elseif msg == L["engage_trigger"] then
		enrageWarn = nil
		self:Message(L["engage_message"]:format(boss), "Attention")

		if self.db.profile.vanish then
			self:NextVanish()
		end
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
		if health > 30 and health <= 34 and not enrageWarn then
			if self.db.profile.enrage then
				self:Message(L["enrage_warning"], "Positive", nil, "Info")
			end
			enrageWarn = true
		elseif health > 40 and enrageWarn then
			enrageWarn = nil
		end
	end
end

function mod:GarroteEvent(msg)
	local gplayer, gtype = select(3, msg:find(L["garrote_trigger"]))
	if gplayer and gtype then
		if gplayer == L2["you"] and gtype == L2["are"] then
			gplayer = UnitName("player")
		end
		self:Sync("MoroesGarrote", gplayer)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "MoroesGarrote" and rest and self.db.profile.garrote then
		self:Message(L["garrote_message"]:format(rest), "Attention")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	end
end
