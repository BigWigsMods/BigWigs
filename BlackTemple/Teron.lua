------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Teron Gorefiend"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local pName = UnitName("player")
local db = nil
local beingCrushed = {}

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Teron",

	start_trigger = "Vengeance is mine!",

	shadow = "Shadow of Death",
	shadow_desc = "Tells you who has Shadow of Death.",
	shadow_other = "Shadow: %s!",
	shadow_you = "Shadow of Death on YOU!",

	ghost = "Ghost",
	ghost_desc = "Ghost timers.",
	ghost_bar = "Ghost: %s",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on players with Shadow of Death.",

	crush = "Crushing Shadows",
	crush_desc = "Warn who gets crushing shadows.",
	crush_warn = "Crushed: %s",
} end )

L:RegisterTranslations("esES", function() return {
	start_trigger = "¡La venganza es mía!",

	shadow = "Sombra de muerte (Shadow of Death)",
	shadow_desc = "Avisar quién tiene Sombra de muerte.",
	shadow_other = "Sombra de muerte: ¡%s!",
	shadow_you = "¡Tienes Sombra de muerte!",

	ghost = "Fantasma",
	ghost_desc = "Temporizadores para Fantasma.",
	ghost_bar = "Fantasma: %s",

	icon = "Icono de banda",
	icon_desc = "Poner un icono de banda sobre jugadores con Sombra de muerte.",

	crush = "Sombras aplastantes (Crushing Shadows)",
	crush_desc = "Avisar quién tiene Sombras aplastantes.",
	crush_warn = "Sombras aplastantes: %s",
} end )

L:RegisterTranslations("deDE", function() return {
	start_trigger = "Die Rache ist mein!",

	shadow = "Schatten des Todes",
	shadow_desc = "Informiert Euch, wer Schatten des Todes bekommt.",
	shadow_other = "Schatten des Todes: %s!",
	shadow_you = "Schatten des Todes auf DIR!",

	ghost = "Geist",
	ghost_desc = "Geist Timer.",
	ghost_bar = "Geist: %s",

	icon = "Schlachtzug Symbol",
	icon_desc = "Plaziert ein Schlachtzug Icon auf dem Spieler mit Schatten des Todes (benötigt Assistent oder höher).",

	--crush = "Crushing Shadows",
	--crush_desc = "Warn who gets crushing shadows.",
	--crush_warn = "Crushed: %s",
} end )

L:RegisterTranslations("koKR", function() return {
	start_trigger = "복수는 나의 것이다!",

	shadow = "죽음의 어둠",
	shadow_desc = "죽음의 어둠에 걸린 플레이어를 알립니다.",
	shadow_other = "어둠: %s!",
	shadow_you = "당신에 죽음의 어둠!",

	ghost = "영혼",
	ghost_desc = "영혼 타이머입니다.",
	ghost_bar = "영혼: %s",

	icon = "전술 표시",
	icon_desc = "죽음의 어둠에 걸린 플레이어에게 전술 표시를 지정합니다 (승급자 이상 권한 요구).",

	crush = "밀어닥치는 어둠",
	crush_desc = "밀어닥치는 어둠에 걸린 플레이어를 알립니다..",
	crush_warn = "밀어닥치는 어둠: %s",
} end )

L:RegisterTranslations("frFR", function() return {
	start_trigger = "À moi la vengeance !",

	shadow = "Ombre de la mort",
	shadow_desc = "Préviens quand un joueur subit les effets de l'Ombre de la mort.",
	shadow_other = "Ombre : %s !",
	shadow_you = "Ombre de la mort sur VOUS !",

	ghost = "Fantôme",
	ghost_desc = "Indique la durée restante de la forme fantôme de chaque joueur.",
	ghost_bar = "Fantôme : %s",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par l'Ombre de la mort (nécessite d'être promu ou mieux).",

	crush = "Ombres écrasantes",
	crush_desc = "Préviens quand un joueur subit les effets des Ombres écrasantes.",
	crush_warn = "Écrasé(s) : %s",
} end )

L:RegisterTranslations("zhCN", function() return {
	start_trigger = "我要复仇！",

	shadow = "死亡之影",
	shadow_desc = "当玩家受到死亡之影时将告诉你。",
	shadow_other = "死亡之影：>%s<！",
	shadow_you = ">你< 死亡之影！",

	ghost = "复仇之魂",
	ghost_desc = "复仇之魂计时器。",
	ghost_bar = "<复仇之魂：%s>",

	icon = "团队标记",
	icon_desc = "给中了死亡之影的玩家打上团队标记。（需要权限）",

	--crush = "Crushing Shadows",
	--crush_desc = "Warn who gets crushing shadows.",
	--crush_warn = "Crushed: %s",
} end )

L:RegisterTranslations("zhTW", function() return {
	start_trigger = "我要復仇﹗",

	shadow = "死亡之影",
	shadow_desc = "警報誰中了死亡之影",
	shadow_other = "死亡之影: [%s]",
	shadow_you = "你 中了死亡之影!",

	ghost = "鬼魂",
	ghost_desc = "鬼魂計時器",
	ghost_bar = "鬼魂: [%s]",

	icon = "團隊標記",
	icon_desc = "給中了死亡之影的玩家打上團隊標記",

	crush = "暗影魄力",
	crush_desc = "警報誰中了暗影魄力",
	crush_warn = "暗影魄力: [%s]",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"shadow", "ghost", "icon", "crush", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Shadow", 40251)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Crushed", 40243)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	db = self.db.profile
	for k in pairs(beingCrushed) do beingCrushed[k] = nil end
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Shadow(player, spellID)
	if db.shadow then
		local other = L["shadow_other"]:format(player)
		if player == pName then
			self:LocalMessage(L["shadow_you"], "Personal", spellID, "Long")
			self:WideMessage(other)
		else
			self:IfMessage(other, "Attention", spellID)
		end
		self:ScheduleEvent("BWTeronGhost_"..player, self.Ghost, 55, self, player)
		self:Bar(other, 55, spellID)
		self:Icon(player, "icon")
	end
end

function mod:Ghost(player)
	self:Bar(L["ghost_bar"]:format(player), 60, "Ability_Druid_Dreamstate")
end

function mod:Crushed(player, spellID, _, _, spellName)
	if self.db.profile.crush then
		beingCrushed[player] = true
		self:ScheduleEvent("BWTeronCrushWarn", self.CrushWarn, 0.3, self)
		self:Bar(spellName, 15, spellID)
	end
end

function mod:CrushWarn()
	local msg = nil
	for k in pairs(beingCrushed) do
		if not msg then
			msg = k
		else
			msg = msg .. ", " .. k
		end
	end
	self:IfMessage(L["crush_warn"]:format(msg), "Important", 40243, "Alert")
	for k in pairs(beingCrushed) do beingCrushed[k] = nil end
end

