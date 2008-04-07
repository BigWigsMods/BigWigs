------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Hex Lord Malacrass"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local pName = UnitName("player")
local db = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Malacrass",

	engage_trigger = "Da shadow gonna fall on you....",

	bolts = "Spirit Bolts",
	bolts_desc = "Warn when Malacrass starts channelling Spirit Bolts.",
	bolts_message = "Incoming Spirit Bolts!",
	bolts_warning = "Spirit Bolts in 5 sec!",
	bolts_nextbar = "Next Spirit Bolts",

	soul = "Siphon Soul",
	soul_desc = "Warn who is afflicted by Siphon Soul.",
	soul_message = "Siphon: %s",

	totem = "Totem",
	totem_desc = "Warn when a Fire Nova Totem is casted.",
	totem_message = "Fire Nova Totem!",

	heal = "Heal",
	heal_desc = "Warn when Malacrass casts a heal.",
	heal_message = "Casting Heal!",

	consecration = "Consecration",
	consecration_desc = "Warn when Consecration is cast.",
	consecration_bar = "Consecration (%d)",
	consecration_warn = "Casted Consecration!",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Der Schatten wird Euch verschlingen...",

	bolts = "Geistblitze",
	bolts_desc = "Warnt wenn Geistblitze gecastet werden.",
	bolts_message = "Geistblitze!",
	bolts_warning = "Geistblitze in 5 Sek!",
	bolts_nextbar = "N\195\164chsten Geistblitze",

	soul = "Seele entziehen",
	soul_desc = "Warnt wer von Seele entziehen betroffen ist.",
	soul_message = "Seele entziehen: %s",

	totem = "Totem",
	totem_desc = "Warnt wenn Feuernova Totem gestellt wird.",
	totem_message = "Feuernova Totem!",

	heal = "Heilung",
	heal_desc = "Warnt wenn eine Heilung gecastet wird.",
	heal_message = "Heilung!",

	--consecration = "Consecration",
	--consecration_desc = "Warn when Consecration is cast.",
	--consecration_bar = "Consecration (%d)",
	--consecration_warn = "Casted Consecration!",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "너희에게 그림자가 드리우리라...",

	bolts = "영혼의 화살",
	bolts_desc = "말라크라스의 영혼의 화살 시전을 알립니다.",
	bolts_message = "영혼의 화살 시전!",
	bolts_warning = "5초후 영혼의 화살!",
	bolts_nextbar = "다음 영혼의 화살",

	soul = "영혼 착취",
	soul_desc = "누가 영혼 착취에 걸렸는지 알립니다.",
	soul_message = "착취: %s",

	totem = "토템",
	totem_desc = "불꽃 회오리 토템 시전시 알립니다.",
	totem_message = "불꽃 회오리 토템!",

	heal = "치유",
	heal_desc = "말라크라스의 치유 마법 시전을 알립니다.",
	heal_message = "치유 마법 시전!",

	--consecration = "Consecration",
	--consecration_desc = "Warn when Consecration is cast.",
	--consecration_bar = "Consecration (%d)",
	--consecration_warn = "Casted Consecration!",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "L'ombre, elle va vous tomber dessus.",

	bolts = "Eclairs spirituels",
	bolts_desc = "Préviens quand Malacrass commence à canaliser ses Eclairs spirituels.",
	bolts_message = "Arrivée des Eclairs spirituels !",
	bolts_warning = "Eclairs spirituels dans 5 sec. !",
	bolts_nextbar = "Prochains Eclairs spirituels",

	soul = "Siphonner l'âme",
	soul_desc = "Préviens quand un joueur subit les effets de Siphonner l'âme.",
	soul_message = "Siphon : %s",

	totem = "Totem",
	totem_desc = "Préviens quand un Totem Nova de feu est incanté.",
	totem_message = "Totem Nova de feu !",

	heal = "Soin",
	heal_desc = "Préviens quand Malacrass incante un soin.",
	heal_message = "Incante un soin !",

	--consecration = "Consecration",
	--consecration_desc = "Warn when Consecration is cast.",
	--consecration_bar = "Consecration (%d)",
	--consecration_warn = "Casted Consecration!",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "阴影将会降临在你们头上……",

	bolts = "灵魂之箭",
	bolts_desc = "当玛拉卡斯开始引导灵魂之箭时发出警报。",
	bolts_message = "即将 灵魂之箭！",
	bolts_warning = "5秒后，灵魂之箭！",
	bolts_nextbar = "<下一灵魂之箭>",

	soul = "灵魂虹吸",
	soul_desc = "当受到灵魂虹吸时发出警报。",
	soul_message = "灵魂虹吸：>%s<！",

	totem = "图腾",
	totem_desc = "当火焰新星图腾被施放发出警报。",
	totem_message = "火焰新星图腾！",

	heal = "治疗",
	heal_desc = "当妖术领主玛拉卡斯施放治疗发出警报。",
	heal_message = "正在施放治疗！打断！",

	consecration = "奉献",
	consecration_desc = "当施放奉献时发出警报。",
	consecration_bar = "<奉献：%d>",
	consecration_warn = "已施放 奉献！",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "陰影將會降臨在你們頭上......",

	bolts = "靈魂箭",
	bolts_desc = "警告瑪拉克雷斯施放靈魂箭",
	bolts_message = "靈魂箭即將來臨",
	bolts_warning = "5 秒後靈魂箭!",
	bolts_nextbar = "下次靈魂箭",

	soul = "虹吸靈魂",
	soul_desc = "警告誰受到虹吸靈魂",
	soul_message = "虹吸靈魂：[%s]",

	totem = "圖騰",
	totem_desc = "警告火焰新星圖騰被施放了",
	totem_message = "火焰新星圖騰!",

	heal = "治療",
	heal_desc = "警告瑪拉克雷斯施放治療",
	heal_message = "施放治療! - 快中斷",

	--consecration = "Consecration",
	--consecration_desc = "Warn when Consecration is cast.",
	--consecration_bar = "Consecration (%d)",
	--consecration_warn = "Casted Consecration!",
} end )

L:RegisterTranslations("esES", function() return {
	engage_trigger = "Las sombras caer\195\161n sobre vosotros...",

	bolts = "Descargas de esp\195\173ritu",
	bolts_desc = "Avisa cuando Malacrass comienza a canalizar Descargas de esp\195\173ritu.",
	bolts_message = "\194\161Descargas de esp\195\173ritu!",
	bolts_warning = "Descargas de esp\195\173ritu en 5 seg!",
	bolts_nextbar = "Descargas de esp\195\173ritu siguientes",

	soul = "Succionar alma",
	soul_desc = "Avisa quien est\195\161 afectado por Succionar alma.",
	soul_message = "Succionar: %s",

	totem = "T\195\179tem",
	totem_desc = "Avisa cuando un T\195\179tem de Nova de Fuego es lanzado.",
	totem_message = "\194\161T\195\179tem de Nova de Fuego!",

	heal = "Curaci\195\179n",
	heal_desc = "Avisa cuando Malacrass lanza una curaci\195\179n.",
	heal_message = "\194\161Lanzando cura!",

	--consecration = "Consecration",
	--consecration_desc = "Warn when Consecration is cast.",
	--consecration_bar = "Consecration (%d)",
	--consecration_warn = "Casted Consecration!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"bolts", "soul", "totem", "heal", "consecration", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "SoulSiphon", 43501)
	self:AddCombatListener("SPELL_CAST_START", "Heal", 43548, 43451, 43431) --Healing Wave, Holy Light, Flash Heal
	self:AddCombatListener("SPELL_SUMMON", "Totem", 43436)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Bolts", 43383)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Consecration", 43429)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:SoulSiphon(player, spellID)
	if db.soul then
		self:IfMessage(L["soul_message"]:format(player), "Urgent", spellID)
	end
end

function mod:Heal(_, spellID)
	if db.heal then
		local show = L["heal_message"]
		self:IfMessage(show, "Positive", spellID)
		self:Bar(show, 2, spellID)
	end
end

function mod:Totem()
	if db.totem then
		self:IfMessage(L["totem_message"], "Urgent", 43436)
	end
end

function mod:Bolts(_, spellID)
	if db.bolts then
		self:IfMessage(L["bolts_message"], "Important", spellID)
		self:Bar(L["bolts"], 10, spellID)
		self:Bar(L["bolts_nextbar"], 40, spellID)
		self:DelayedMessage(35, L["bolts_warning"], "Attention")
	end
end

local count = 0
function mod:Consecration(_, spellID)
	if self.db.profile.consecration then
		self:IfMessage(L["consecration_warn"], "Positive", spellID)
		count = count + 1
		self:Bar(L["consecration_bar"]:format(count), 20, spellID)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] and db.bolts then
		self:Bar(L["bolts_nextbar"], 30, 43383)
		self:DelayedMessage(25, L["bolts_warning"], "Attention")
	end
end

