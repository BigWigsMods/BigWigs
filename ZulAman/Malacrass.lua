------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Hex Lord Malacrass"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

local pName = nil
local db = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Malacrass",

	engage_trigger = "Da shadow gonna fall on you....",

	bolts = "Spirit Bolts",
	bolts_desc = "Warn when Malacrass starts channelling Spirit Bolts.",
	bolts_trigger = "Your soul gonna bleed!",
	bolts_message = "Incoming Spirit Bolts!",
	bolts_warning = "Spirit Bolts in 5 sec!",
	bolts_nextbar = "Next Spirit Bolts",

	soul = "Siphon Soul",
	soul_desc = "Warn who is afflicted by Siphon Soul.",
	soul_trigger = "^(%S+) (%S+) afflicted by Siphon Soul%.$",
	soul_message = "Siphon: %s",

	totem = "Totem",
	totem_desc = "Warn when a Fire Nova Totem is casted.",
	totem_trigger = "Hex Lord Malacrass casts Fire Nova Totem.",
	totem_message = "Fire Nova Totem!",

	heal = "Heal",
	heal_desc = "Warn when Malacrass casts a heal.",
	heal_flash = "Hex Lord Malacrass begins to cast Flash Heal.",
	heal_light = "Hex Lord Malacrass begins to cast Holy Light.",
	heal_wave = "Hex Lord Malacrass begins to cast Healing Wave.",
	heal_message = "Casting Heal!",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "너희에게 그림자가 드리우리라...",

	bolts = "영혼의 화살",
	bolts_desc = "말라크라스의 영혼의 화살 시전을 알립니다.",
	bolts_trigger = "네 영혼이 피를 흘리리라!",
	bolts_message = "영혼의 화살 시전!",
	bolts_warning = "5초후 영혼의 화살!",
	bolts_nextbar = "다음 영혼의 화살",

	soul = "영혼 착취",
	soul_desc = "누가 영혼 착취에 걸렸는지 알립니다.",
	soul_trigger = "^([^|;%s]*)(.*)영혼 착취에 걸렸습니다%.$",
	soul_message = "착취: %s",

	totem = "토템",
	totem_desc = "불꽃 회오리 토템 시전시 알립니다.",
	totem_trigger = "주술 군주 말라크라스|1이;가; 불꽃 회오리 토템|1을;를; 시전합니다.",
	totem_message = "불꽃 회오리 토템!",

	heal = "치유",
	heal_desc = "말라크라스의 치유 마법 시전을 알립니다.",
	heal_flash = "주술 군주 말라크라스|1이;가; 순간 치유 시전을 시작합니다.",
	heal_light = "주술 군주 말라크라스|1이;가; 성스러운 빛 시전을 시작합니다.",
	heal_wave = "주술 군주 말라크라스|1이;가; 치유의 물결 시전을 시작합니다.",
	heal_message = "치유 마법 시전!",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "L'ombre, elle va vous tomber dessus.",

	bolts = "Eclairs spirituels",
	bolts_desc = "Préviens quand Malacrass commence à canaliser ses Eclairs spirituels.",
	bolts_trigger = "Ton âme, elle va saigner !",
	bolts_message = "Arrivée des Eclairs spirituels !",
	bolts_warning = "Eclairs spirituels dans 5 sec. !",
	bolts_nextbar = "Prochains Eclairs spirituels",

	soul = "Siphonner l'âme",
	soul_desc = "Préviens quand un joueur subit les effets de Siphonner l'âme.",
	soul_trigger = "^(%S+) (%S+) les effets .* Siphonner l'âme%.$",
	soul_message = "Siphon : %s",

	totem = "Totem",
	totem_desc = "Préviens quand un Totem Nova de feu est incanté.",
	totem_trigger = "Seigneur des maléfices Malacrass lance Totem Nova de feu.",
	totem_message = "Totem Nova de feu !",

	heal = "Soin",
	heal_desc = "Préviens quand Malacrass incante un soin.",
	heal_flash = "Seigneur des maléfices Malacrass commence à lancer Soins rapides.",
	heal_light = "Seigneur des maléfices Malacrass commence à lancer Lumière sacrée.",
	heal_wave = "Seigneur des maléfices Malacrass commence à lancer Vague de soins.",
	heal_message = "Incante un soin !",
} end )

L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "阴影将会降临在你们头上……",

	bolts = "灵魂之箭",
	bolts_desc = "当玛拉卡斯开始引导灵魂之箭时发出警报.",
	bolts_trigger = "你的灵魂在流血！",
	bolts_message = "即将 - 灵魂之箭!",
	bolts_warning = "5秒后 灵魂之箭 !",
	bolts_nextbar = "下一次灵魂之箭",

	soul = "灵魂虹吸",
	soul_desc = "受到灵魂虹吸时发出警报.",
	soul_trigger = "^(%S+)受(%S+)了灵魂虹吸效果的影响。$",
	soul_message = "灵魂虹吸: %s",

	totem = "图腾",
	totem_desc = "当火焰新星图腾被施放发出警报.",
	totem_trigger = "妖术领主玛拉卡斯施放了火焰新星图腾。",
	totem_message = "火焰新星图腾!",

	heal = "治疗",
	heal_desc = "当妖术领主玛拉卡斯施放治疗发出警报.",
	heal_flash = "妖术领主玛拉卡斯开始施放快速治疗。$",
	heal_light = "妖术领主玛拉卡斯开始施放圣光术。$",
	heal_wave = "妖术领主玛拉卡斯开始施放治疗波。$",
	heal_message = "正在施放 => 治疗! 打断!",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "陰影將會降臨在你們頭上......",

	bolts = "靈魂箭",
	bolts_desc = "警告瑪拉克雷斯施放靈魂箭",
	bolts_trigger = "你的靈魂將會受到傷害!",
	bolts_message = "靈魂箭即將來臨",
	--bolts_warning = "Spirit Bolts in 5 sec!",
	--bolts_nextbar = "Next Spirit Bolts",

	soul = "虹吸靈魂",
	soul_desc = "警告誰受到虹吸靈魂",
	soul_trigger = "^(.+)受(到[了]*)虹吸靈魂效果的影響。$",
	soul_message = "虹吸靈魂：[%s]",

	totem = "圖騰",
	totem_desc = "警告火焰新星圖騰被施放了",
	totem_trigger = "妖術領主瑪拉克雷斯施放了火焰新星圖騰。",
	totem_message = "火焰新星圖騰!",

	heal = "治療",
	heal_desc = "警告瑪拉克雷斯施放治療",
	heal_flash = "妖術領主瑪拉克雷斯開始施放快速治療。",
	heal_light = "妖術領主瑪拉克雷斯開始施放聖光術。",
	heal_wave = "妖術領主瑪拉克雷斯開始施放治療波。",
	heal_message = "施放治療! - 快中斷",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Aman"]
mod.enabletrigger = boss
mod.toggleoptions = {"bolts", "soul", "totem", "heal", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Siphon")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Siphon")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Siphon")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	pName = UnitName("player")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MalaHeal", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "MalaTotem", 5)
	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if not db.bolts then return end

	if msg == L["bolts_trigger"] then
		self:Message(L["bolts_message"], "Important")
		self:Bar(L["bolts"], 10, "Spell_Shadow_ShadowBolt")
		self:Bar(L["bolts_nextbar"], 40, "Spell_Shadow_ShadowBolt")
		self:DelayedMessage(35, L["bolts_warning"], "Attention")
	elseif msg == L["engage_trigger"] then
		self:Bar(L["bolts_nextbar"], 40, "Spell_Shadow_ShadowBolt")
		self:DelayedMessage(35, L["bolts_warning"], "Attention")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["totem_trigger"] then
		self:Sync("MalaTotem")
	elseif msg == L["heal_flash"] or msg == L["heal_wave"] or msg == L["heal_light"] then
		self:Sync("MalaHeal")
	end
end

function mod:Siphon(msg)
	if not db.soul then return end

	local splayer, stype = select(3, msg:find(L["soul_trigger"]))
	if splayer and stype then
		if splayer == L2["you"] and stype == L2["are"] then
			splayer = pName
		end
		self:Message(L["soul_message"]:format(splayer), "Urgent")
	end
end

function mod:BigWigs_RecvSync(sync)
	if sync == "MalaHeal" and db.heal then
		local show = L["heal_message"]
		self:Message(show, "Positive")
		self:Bar(show, 2, "Spell_Nature_MagicImmunity")
	elseif sync == "MalaTotem" and db.totem then
		self:Message(L["totem_message"], "Urgent")
	end
end
