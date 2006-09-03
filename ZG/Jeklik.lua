------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("High Priestess Jeklik")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "jeklik",

	heal_cmd = "heal",
	heal_name = "Heal Alert",
	heal_desc = "Warn for healing",

	bomb_cmd = "bomb",
	bomb_name = "Bomb Bat Alert",
	bomb_desc = "Warn for Bomb Bats",

	trigger1 = "I command you to rain fire down upon these invaders!$",
	trigger2 = "begins to cast a Great Heal!$",
	warn1 = "Incoming bomb bats!",
	warn2 = "Casting heal!",
	
} end )

L:RegisterTranslations("frFR", function() return {
	trigger1 =  "Qu'une pluie de feu s'abatte sur les envahisseurs !",
	trigger2 = "commence \195\160 lancer un sort de Soins exceptionnels !",
	warn1 = "Chauve-souris en approche !",
	warn2 = "Commence \195\160 se soigner",
} end )

L:RegisterTranslations("deDE", function() return {
	heal_name = "Heilung",
	heal_desc = "Warnung, wenn Jeklik versucht sich zu heilen.",

	bomb_name = "Bomben",
	bomb_desc = "Warnung, wenn Fledermaus Bomben im Anflug sind.",

	trigger1 =  "Ich befehle Euch Feuer \195\188ber diese Eindringlinge regnen zu lassen!",
	trigger2 = "beginnt Gro\195\159es Heilen zu wirken!",
	warn1 = "Fledermaus Bomben im Anflug!",
	warn2 = "Jeklik versucht sich zu heilen! - Unterbrechen!",
} end )

L:RegisterTranslations("zhCN", function() return {
	heal_name = "治疗警报",
	heal_desc = "高阶祭司耶克里克使用治疗时发出警报",

	bomb_name = "炸弹蝙蝠警报",
	bomb_desc = "炸弹蝙蝠出现时发出警报",

	trigger1 = "我命令你把这些入侵者烧成灰烬！$",
	trigger2 = "开始释放强效治疗术！$",
	warn1 = "炸弹蝙蝠来了！",
	warn2 = "高阶祭司耶克里克正在施放治疗，赶快打断它！",
} end )

L:RegisterTranslations("koKR", function() return {
	trigger1 = "침략자들에게 뜨거운 맛을 보여줘라!$",
	trigger2 = "상급 치유를 시전하기 시작합니다!$",
	warn1 = "박쥐 소환!",
	warn2 = "치유 시전 - 시전 방해해주세요!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsJeklik = BigWigs:NewModule(boss)
BigWigsJeklik.zonename = AceLibrary("Babble-Zone-2.0")("Zul'Gurub")
BigWigsJeklik.enabletrigger = boss
BigWigsJeklik.toggleoptions = {"heal", "bomb", "bosskill"}
BigWigsJeklik.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsJeklik:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Events              --
------------------------------

function BigWigsJeklik:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.bomb and string.find(msg, L["trigger1"]) then
		self:TriggerEvent("BigWigs_Message", L["warn1"], "Yellow")
	end
end

function BigWigsJeklik:CHAT_MSG_MONSTER_EMOTE(msg)
	if self.db.profile.heal and string.find(msg, L["trigger2"]) then
		self:TriggerEvent("BigWigs_Message", L["warn2"], "Orange")
	end
end

