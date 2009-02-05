----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Grobbulus"]
local mod = BigWigs:New(boss, tonumber(("$Revision$"):sub(12, -3)))
if not mod then return end
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = boss
mod.guid = 15931
mod.toggleoptions = {"inject", "icon", "cloud", "berserk", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local started = nil
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	cmd = "Grobbulus",

	inject = "Injected",
	inject_desc = "Warn when Injected.",
	bomb_message_you = "You are Injected!",
	bomb_message_other = "%s is Injected!",

	icon = "Place Icon",
	icon_desc = "Place a raid icon on an Injected person. (Requires promoted or higher)",

	cloud = "Poison Cloud",
	cloud_desc = "Warn for Poison Clouds.",
	cloud_warn = "Poison Cloud! Next in ~15 sec!",
	cloud_bar = "Next Poison Cloud",
} end )

L:RegisterTranslations("ruRU", function() return {
	inject = "Вам сдедали укол",
	inject_desc = "Предупреждать об уколе.",
	bomb_message_you = "Вам сделали укол! Бегите от рейда!!",
	bomb_message_other = "%s сделали укол! Бегите от него! ",

	icon = "Помечать иконкой",
	icon_desc = "Помечать рейдовой иконкой игрока, которому был сделан укол (необходимо быть лидером группы или рейда).",

	cloud = "Ядовитое облако",
	cloud_desc = "Сообщать о ядовитом облаке.",
	cloud_warn = "Ядовитое облако! Следующее - через ~15 секунд!",
	cloud_bar = "Следующее ядовитое облако",
} end )

L:RegisterTranslations("deDE", function() return {
	inject = "Mutagene Injektion",
	inject_desc = "Warnt, wenn auf einen Spieler Mutagene Injektion gewirkt wird.",
	bomb_message_you = "DU bist verseucht!",
	bomb_message_other = "%s ist verseucht!",

	icon = "Schlachtzugs-Symbol",
	icon_desc = "Platziert ein Schlachtzugs-Symbol auf Spielern, auf die Mutagene Injektion gewirkt wird (benötigt Assistent oder höher).",

	cloud = "Giftwolke",
	cloud_desc = "Warnungen und Timer für Giftwolken.",
	cloud_warn = "Giftwolke! Nächste in ~15sek!",
	cloud_bar = "Giftwolke",
} end )

L:RegisterTranslations("koKR", function() return {
	inject = "돌연변이",
	inject_desc = "돌연변이를 알립니다.",
	bomb_message_you = "당신은 돌연변이 유발!",
	bomb_message_other = "돌연변이 유발: %s!",

	icon = "전술 표시",
	icon_desc = "돌연변이 유발 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	cloud = "독구름",
	cloud_desc = "독구름을 알립니다.",
	cloud_warn = "독구름! 다음은 약 15초 이내!",
	cloud_bar = "독구름",
} end )

L:RegisterTranslations("zhCN", function() return {
	inject = "变异注射",
	inject_desc = "当玩家中了变异注射时发出警报。",
	bomb_message_you = ">你< 变异注射！",
	bomb_message_other = "变异注射：>%s<！",

	icon = "团队标记",
	icon_desc = "为中了变异注射的玩家打上团队标记。（需要权限）",

	cloud = "毒性云雾",
	cloud_desc = "当施放毒性云雾时发出警报。",
	cloud_warn = "约15秒后，毒性云雾！",
	cloud_bar = "<毒性云雾>",
} end )

L:RegisterTranslations("zhTW", function() return {
	inject = "突變注射警報",
	inject_desc = "當玩家中了突變注射時發出警報。",
	bomb_message_you = ">你< 突變注射！",
	bomb_message_other = "突變注射：>%s<！",

	icon = "團隊標記",
	icon_desc = "為中了突變注射的玩家打上團隊標記。（需要權限）",

	cloud = "毒雲術",
	cloud_desc = "當施放毒雲術時發出警報。",
	cloud_warn = "約15秒後，毒雲術！",
	cloud_bar = "<毒雲術>",
} end )

L:RegisterTranslations("frFR", function() return {
	inject = "Injection mutante",
	inject_desc = "Prévient quand un joueur subit les effets de l'Injection mutante.",
	bomb_message_you = "Vous êtes injecté !",
	bomb_message_other = "%s est injecté !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par l'Injection mutante (nécessite d'être promu ou mieux).",

	cloud = "Nuage empoisonné",
	cloud_desc = "Prévient quand Globbulus lance ses nuages empoisonnés.",
	cloud_warn = "Nuage empoisonné ! Prochain dans ~15 sec. !",
	cloud_bar = "Prochain Nuage",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Inject", 28169)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Cloud", 28240)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	started = nil
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Inject(player, spellID)
	if self.db.profile.inject then
		local other = L["bomb_message_other"]:format(player)
		if player == pName then
			self:Message(L["bomb_message_you"], "Personal", true, "Alert", nil, spellID)
			self:Message(other, "Attention", nil, nil, true)
		else
			self:Message(other, "Attention", nil, nil, nil, spellID)
			self:Whisper(player, L["bomb_message_you"])
		end
		self:Bar(other, 10, spellID)
		if self.db.profile.icon then
			self:Icon(player, "icon")
		end
	end
end

function mod:Cloud(_, spellID)
	if self.db.profile.cloud then
		self:IfMessage(L["cloud_warn"], "Urgent", spellID)
		self:Bar(L["cloud_bar"], 15, spellID)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.berserk then
			self:Enrage(540, true)
		end
	end
end

