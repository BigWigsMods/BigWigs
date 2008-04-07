------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Teron Gorefiend"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local pName = UnitName("player")
local db = nil

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
} end )

L:RegisterTranslations("koKR", function() return {
	start_trigger = "복수는 나의 것이다!",

	shadow = "죽음의 어둠",
	shadow_desc = "죽음의 어둠에 걸린 사람을 알립니다.",
	shadow_other = "어둠: %s!",
	shadow_you = "당신에 죽음의 어둠!",

	ghost = "영혼",
	ghost_desc = "영혼 타이머입니다.",
	ghost_bar = "영혼: %s",

	icon = "전술 표시",
	icon_desc = "죽음의 어둠에 걸린 플레이어에게 전술 표시를 지정합니다 (승급자 이상 권한 요구).",
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
} end )

L:RegisterTranslations("zhCN", function() return {
	start_trigger = "我要复仇！",

	shadow = "死亡之影",
	shadow_desc = "当玩家中了死亡之影将告诉你。",
	shadow_other = "死亡之影：>%s<！",
	shadow_you = ">你< 死亡之影！",

	ghost = "复仇之魂",
	ghost_desc = "复仇之魂计时器。",
	ghost_bar = "<复仇之魂：%s>",

	icon = "团队标记",
	icon_desc = "给中了死亡之影的玩家打上团队标记。（需要权限）",
} end )

L:RegisterTranslations("zhTW", function() return {
	start_trigger = "我要復仇﹗",

	shadow = "死亡之影",
	shadow_desc = "當誰中了死亡之影將告訴你",
	shadow_other = "死亡之影：[%s]",
	shadow_you = "你 中了死亡之影!",

	ghost = "鬼魂",
	ghost_desc = "鬼魂計時器",
	ghost_bar = "鬼魂：[%s]",

	icon = "團隊標記",
	icon_desc = "給中了死亡之影的玩家打上團隊標記",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"shadow", "ghost", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Shadow", 40251)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	db = self.db.profile
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

