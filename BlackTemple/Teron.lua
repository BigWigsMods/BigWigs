------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Teron Gorefiend"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local pName = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Teron",

	start_trigger = "Vengeance is mine!",

	shadow = "Shadow of Death",
	shadow_desc = "Tells you who has Shadow of Death.",
	shadow_trigger = "^(%S+) (%S+) afflicted by Shadow of Death%.$",
	shadow_other = "Shadow of Death: %s!",
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
	shadow_trigger = "^([^%s]+) ([^%s]+) von Schatten des Todes betroffen%.$",
	shadow_other = "Schatten des Todes: %s!",
	shadow_you = "Schatten des Todes auf DIR!",

	--ghost = "Ghost",
	--ghost_desc = "Ghost timers.",
	--ghost_bar = "Ghost: %s",

	icon = "Icon",
	icon_desc = "Plaziert ein Schlachtzug Icon auf dem Spieler mit Schatten des Todes.",
} end )

L:RegisterTranslations("koKR", function() return {
	start_trigger = "복수는 나의 것이다!",

	shadow = "죽음의 어둠",
	shadow_desc = "죽음의 어둠에 걸린 사람을 알립니다.",
	shadow_trigger = "^([^|;%s]*)(.*)죽음의 어둠에 걸렸습니다%.$",
	shadow_other = "죽음의 어둠: %s!",
	shadow_you = "당신에 죽음의 어둠!",

	ghost = "영혼",
	ghost_desc = "영혼 타이머.",
	ghost_bar = "영혼: %s",

	icon = "전술 표시",
	icon_desc = "죽음의 어둠에 걸린 플레이어에게 전술 표시를 지정합니다 (승급자 이상 권한 요구).",
} end )

L:RegisterTranslations("frFR", function() return {
	start_trigger = "À moi la vengeance !",

	shadow = "Ombre de la mort",
	shadow_desc = "Préviens quand un joueur subit les effets de l'Ombre de la mort.",
	shadow_trigger = "^(%S+) (%S+) les effets .* Ombre de la mort%.$",
	shadow_other = "Ombre de la mort : %s !",
	shadow_you = "Ombre de la mort sur VOUS !",

	ghost = "Fantôme",
	ghost_desc = "Indique la durée restante de la forme fantôme de chaque joueur.",
	ghost_bar = "Fantôme : %s",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par l'Ombre de la mort (nécessite d'être promu ou mieux).",
} end )

--塔隆·血魔
--Ananhaid Updated 10/28 22:00
L:RegisterTranslations("zhCN", function() return {
	start_trigger = "我要复仇！",

	shadow = "死亡之影",
	shadow_desc = "当谁中了死亡之影将告诉你",
	shadow_trigger = "^(%S+)受(%S+)了死亡之影效果的影响。$",
	shadow_other = "死亡之影: %s!",
	shadow_you = "你 中了死亡之影!",

	ghost = "复仇之魂",
	ghost_desc = "复仇之魂计时器。",
	ghost_bar = "复仇之魂: %s",

	icon = "团队标记",
	icon_desc = "给中了死亡之影的玩家打上团队标记",
} end )

L:RegisterTranslations("zhTW", function() return {
	start_trigger = "我要復仇﹗", -- Vengeance is mine!

	shadow = "死亡之影",
	shadow_desc = "當誰中了死亡之影將告訴你",
	shadow_trigger = "^(.+)受(到[了]*)死亡之影效果的影響。$",
	shadow_other = "死亡之影：[%s]",
	shadow_you = "你 中了死亡之影!",

	--ghost = "Ghost",
	--ghost_desc = "Ghost timers.",
	--ghost_bar = "Ghost: %s",

	icon = "團隊標記",
	icon_desc = "給中了死亡之影的玩家打上團隊標記",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"shadow", "ghost", "icon", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "SoD")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "SoD")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "SoD")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "TeronShadow", 3)
	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:SoD(msg)
	local splayer, stype = select(3, msg:find(L["shadow_trigger"]))
	if splayer and stype then
		if splayer == L2["you"] and stype == L2["are"] then
			splayer = pName
		end
		self:Sync("TeronShadow", splayer)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "TeronShadow" and rest and self.db.profile.shadow then
		local other = L["shadow_other"]:format(rest)
		if rest == pName then
			self:Message(L["shadow_you"], "Personal", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
			self:Bar(other, 55, "Spell_Arcane_PrismaticCloak")
		else
			self:Message(other, "Attention")
			self:Bar(other, 55, "Spell_Arcane_PrismaticCloak")
		end
		self:ScheduleEvent("BWTeronGhost"..rest, self.Ghost, 55, self, rest)
		if self.db.profile.icon then
			self:Icon(rest)
		end
	end
end

function mod:Ghost(rest)
	self:Bar(L["ghost_bar"]:format(rest), 60, "Ability_Druid_Dreamstate")
end
