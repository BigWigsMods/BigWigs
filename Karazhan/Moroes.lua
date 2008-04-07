------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Moroes"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
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
	vanish_message = "Vanished! Next in ~35sec!",
	vanish_warning = "Vanish Soon!",
	vanish_bar = "~Vanish Cooldown",

	garrote = "Garrote",
	garrote_desc = "Notify of players afflicted by Garrote.",
	garrote_message = "Garrote: %s",

	icon = "Icon",
	icon_desc = "Place a Raid Icon on the player afflicted by Garrote(requires promoted or higher).",

	enrage_message = "Enrage!",
	enrage_warning = "Enrage Soon!",
} end)

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Hum. Des visiteurs imprévus. Il va falloir se préparer.",
	engage_message = "Moroes engagé - Disparition dans ~35 sec. !",

	vanish = "Disparition",
	vanish_desc = "Préviens quand Moroes est susceptible de disparaître.",
	vanish_message = "Disparu ! Prochain dans ~35 sec. !",
	vanish_warning = "Disparition imminente !",
	vanish_bar = "~Cooldown Disparition",

	garrote = "Garrot",
	garrote_desc = "Préviens quand un joueur subit les effets du Garrot.",
	garrote_message = "Garrot : %s",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par le Garrot (nécessite d'être promu ou mieux).",

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

	vanish_message = "Verschwunden! N\195\164chste in ~35 Sek!",
	vanish_warning = "Verschwinden bald!",
	vanish_bar = "N\195\164chste Verschwinden",

	garrote_message = "Erdrosseln: %s",

	engage_trigger = "Hm, unangek\195\188ndigte Besucher. Es m\195\188ssen Vorbereitungen getroffen werden...",
	engage_message = "%s Engaged - Verschwinden in ~35 Sek!",

	enrage_message = "Enrage!",
	enrage_warning = "Enrage bald!",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "음, 예상치 못한 손님들이군. 준비를 해야겠어...",
	engage_message = "%s 전투 시작 - 약 35초 후 소멸!",

	vanish = "소멸",
	vanish_desc = "모로스의 다음 소멸에 대한 예상 타이머입니다.",
	vanish_message = "소멸! 다음은 약 35초 후!",
	vanish_warning = "잠시 후 소멸!", 
	vanish_bar = "~소멸 대기시간",

	garrote = "목조르기",
	garrote_desc = "목조르기에 걸린 사람을 알립니다.",
	garrote_message = "목조르기: %s",

	icon = "전술 표시",
	icon_desc = "목조르기에 걸린 사람에게 전술 표시를 지정합니다 (승급자 이상의 권한 필요).",

	enrage_message = "격노!",
	enrage_warning = "잠시 후 격노!",
} end)

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "啊，不速之客。我得准备一下……",
	engage_message = "%s 激活！约35秒后，消失！",

	vanish = "消失",
	vanish_desc = "消失预计冷却计时条。",
	vanish_message = "消失！约35秒后，再次消失！",
	vanish_warning = "即将 消失！",
	vanish_bar = "<消失 冷却>",

	garrote = "锁喉",
	garrote_desc = "当玩家受到锁喉时发送警告。",
	garrote_message = "锁喉：>%s<！",

	icon = "标记",
	icon_desc = "当队员受到锁喉时标上团队标记。（需要权限）",

	enrage_message = "激怒！",
	enrage_warning = "即将 激怒！",
} end)

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "嗯，突然上門的訪客。一定要做好準備……",
	engage_message = "%s 進入戰鬥 - 將於 35 秒後消失",

	vanish = "消失預警",
	vanish_desc = "顯示摩洛消失提示",
	vanish_message = "消失 - 35 秒再次消失",
	vanish_warning = "摩洛即將消失",
	vanish_bar = "消失倒數",

	garrote = "絞喉警告",
	garrote_desc = "當有玩家被絞喉時發送警告",
	garrote_message = "被絞喉：[%s]",

	icon = "標記圖示",
	icon_desc = "為被絞喉的玩家設置團隊標記（需要權限）",

	enrage_message = "憤怒",
	enrage_warning = "摩洛即將進入憤怒狀態",
} end)

L:RegisterTranslations("esES", function() return {
	engage_trigger = "Mm, visitantes inesperados. Hay que hacer preparativos...",
	engage_message = "%s Activado - Vanish en ~35sec!",

	vanish = "Vanish",
	vanish_desc = "Timers estimados para el Vanish.",
	vanish_message = "Vanished! Siguiente en ~35sec!",
	vanish_warning = "Vanish Pronto!",
	vanish_bar = "~Enfriamiento de Vanish",

	garrote = "Garrote",
	garrote_desc = "Notifica que jugador ha sido afectado por Garrote.",
	garrote_message = "Garrote: %s",

	icon = "Icono",
	icon_desc = "Pone un icono de Raid en el jugador afectado por Garrote(requiere promoted o mas alto).",

	enrage_message = "Enfurecido!",
	enrage_warning = "Enfurecimiento Pronto!",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Karazhan"]
mod.enabletrigger = boss
mod.toggleoptions = {"vanish", "enrage", -1, "garrote", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Garrote", 37066)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Enrage", 37023)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Vanish", 29448)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Garrote(player, spellID)
	if self.db.profile.garrote then
		self:IfMessage(L["garrote_message"]:format(player), "Attention", spellID)
		self:Icon(player, "icon")
	end
end

function mod:Enrage()
	if self.db.profile.enrage then
		self:IfMessage(L["enrage_message"], "Important", 37023, "Alarm")
	end
end

function mod:Vanish(_, spellID)
	if self.db.profile.vanish then
		self:IfMessage(L["vanish_message"], "Urgent", spellID, "Alert")
		self:Bar(L["vanish_bar"], 35, spellID)
		self:DelayedMessage(30, L["vanish_warning"], "Attention")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		enrageWarn = nil
		self:Message(L["engage_message"]:format(boss), "Attention")

		if self.db.profile.vanish then
			self:Bar(L["vanish_bar"], 35, 29448)
			self:DelayedMessage(30, L["vanish_warning"], "Attention")
		end
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

