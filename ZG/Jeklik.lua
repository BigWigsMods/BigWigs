------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["High Priestess Jeklik"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Jeklik",

	heal = "Heal Alert",
	heal_desc = "Warn for healing",

	bomb = "Bomb Bat Alert",
	bomb_desc = "Warn for Bomb Bats",

	swarm = "Bat Swarm Alert",
	swarm_desc = "Warn for the Bat swarms",

	swarm_trigger = "emits a deafening shriek",
	bomb_trigger = "I command you to rain fire down upon these invaders!$",
	heal_trigger = "begins to cast a Great Heal!$",

	swarm_message = "Incoming bat swarm!",
	bomb_message = "Incoming bomb bats!",
	heal_message = "Casting heal!",
} end )

L:RegisterTranslations("frFR", function() return {
	bomb_trigger =  "Qu'une pluie de feu s'abatte sur les envahisseurs !",
	heal_trigger = "commence \195\160 lancer un sort de Soins exceptionnels !",
	swarm_trigger = "pousse un hurlement assourdissant !",

	swarm_message = "Pack de Chauve-souris en approche !",
	bomb_message = "Chauve-souris bombardier en approche !",
	heal_message = "Commence \195\160 se soigner !",

	heal = "Alerte Soins",
	heal_desc = "Pr\195\169viens lorsque le boss tente de se soigner.",

	bomb = "Alerte Bombardier",
	bomb_desc = "Pr\195\169viens des pops de chauve-souris bombardier.",

	swarm = "Alerte Pack de chauve-souris",
	swarm_desc = "Pr\195\169viens des pops de pack de chauve-souris",
} end )

L:RegisterTranslations("deDE", function() return {
	heal = "Heilung",
	heal_desc = "Warnung, wenn Jeklik versucht sich zu heilen.",

	bomb = "Fledermaus-Bomben",
	bomb_desc = "Warnung, wenn Fledermaus-Bomben im Anflug sind.",

	swarm = "Fledermaus-Schwarm",
	swarm_desc = "Warnung, wenn Fledermaus-Schwarm im Anflug.",

	swarm_trigger = "emits a deafening shriek", -- ?
	bomb_trigger = "Ich befehle Euch Feuer \195\188ber diese Eindringlinge regnen zu lassen!",
	heal_trigger = "beginnt Gro\195\159es Heilen zu wirken!",

	swarm_message = "Fledermaus-Schwarm im Anflug!",
	bomb_message = "Fledermaus-Bomben im Anflug!",
	heal_message = "Jeklik versucht sich zu heilen!",
} end )

L:RegisterTranslations("zhCN", function() return {
	heal = "治疗警报",
	heal_desc = "高阶祭司耶克里克使用治疗时发出警报",

	bomb = "炸弹蝙蝠警报",
	bomb_desc = "炸弹蝙蝠出现时发出警报",

	swarm = "蝙蝠群警报",
	swarm_desc = "蝙蝠群出现时发出警报",

	swarm_trigger = "发出刺耳尖啸",
	bomb_trigger = "我命令你把这些入侵者烧成灰烬！$",
	heal_trigger = "开始释放强效治疗术！$",

	swarm_message = "蝙蝠群来了！",
	bomb_message = "炸弹蝙蝠来了！",
	heal_message = "高阶祭司耶克里克正在施放治疗，赶快打断它！",
} end )

L:RegisterTranslations("zhTW", function() return {
	heal = "治療警報",
	heal_desc = "高階祭司耶克里克使用治療時發出警報",

	bomb = "炸彈蝙蝠警報",
	bomb_desc = "炸彈蝙蝠出現時發出警報",

	bomb_trigger = "我命令你把這些入侵者燒成灰燼！$",
	heal_trigger = "開始施放強效治療術！$",
	bomb_message = "火焰投擲！ 注意閃躲！",
	heal_message = "補血 -  馬上中斷！",

	swarm = "蝙蝠群警報",
	swarm_desc = "蝙蝠群出現時發出警報",
	swarm_trigger = "發出了震耳欲聾的尖嘯聲",
	swarm_message = "蝙蝠群來了！",
} end )

L:RegisterTranslations("koKR", function() return {
	heal = "치유 경고",
	heal_desc = "치유에 대한 경고",

	bomb = "폭탄 박쥐 경고",
	bomb_desc = "폭탄 박쥐에 대한 경고",

	swarm = "박쥐 떼 경고",
	swarm_desc = "박쥐 떼에 대한 경고",

	swarm_trigger = "emits a deafening shriek", -- CHECK
	bomb_trigger = "침략자들에게 뜨거운 맛을 보여줘라!$",
	heal_trigger = "상급 치유를 시전하기 시작합니다!$",

	swarm_message = "박쥐 떼 소환!",
	bomb_message = "폭탄 박쥐 소환!",
	heal_message = "치유 시전 - 시전 방해해주세요!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Zul'Gurub"]
mod.enabletrigger = boss
mod.toggleoptions = {"swarm", "heal", "bomb", "bosskill"}
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Events              --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.bomb and msg:find(L["bomb_trigger"]) then
		self:Message(L["bomb_message"], "Attention")
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if self.db.profile.heal and msg:find(L["heal_trigger"]) then
		self:Message(L["heal_message"], "Urgent")
	elseif self.db.profile.swarm and msg:find(L["swarm_trigger"]) then
		self:Message(L["swarm_message"], "Urgent")
	end
end
