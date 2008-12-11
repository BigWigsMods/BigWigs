------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Instructor Razuvious"]
local understudy = BB["Death knight Understudy"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Razuvious",

	knife = "Jagged Knife",
	knife_desc = "Warn who has Jagged Knife.",
	knife_message = "%s: Jagged Knife",

	taunt = "Taunt",
	taunt_desc = "Warn for taunt.",
	taunt_warning = "Taunt done in 5sec!",
	
	shieldwall = "Shield Wall",
	shieldwall_desc = "Warn for shieldwall.",
	shieldwall_warning = "Shield Wall done in 5sec!",
} end )

L:RegisterTranslations("deDE", function() return {
	--knife = "Jagged Knife",
	--knife_desc = "Warn who has Jagged Knife.",
	--knife_message = "%s: Jagged Knife",
	
	--taunt = "Taunt",
	--taunt_desc = "Warn for taunt.",
	--taunt_warning = "Taunt done in 5sec!",

	--shieldwall = "Shield Wall",
	--shieldwall_desc = "Warn for shieldwall.",
	--shieldwall_warning = "Shield Wall done in 5sec!",
} end )

L:RegisterTranslations("koKR", function() return {
	knife = "뾰족한 나이프",
	knife_desc = "뾰족한 나이프에 걸린 플레이어를 알립니다.",
	knife_message = "뾰족한 나이프: %s",

	taunt = "도발",
	taunt_desc = "도발에 대하여 알립니다.",
	taunt_warning = "5초 후 도발 종료!",
	
	shieldwall = "방패의 벽",
	shieldwall_desc = "방패의 벽에 대하여 알립니다",
	shieldwall_warning = "5초 후 방패의 벽 종료!",
} end )

L:RegisterTranslations("zhCN", function() return {
	knife = "裂纹小刀",
	knife_desc = "当玩家中了裂纹小刀时发出警报。",
	knife_message = ">%s<：裂纹小刀！",

	taunt = "嘲讽",
	taunt_desc = "当见习死亡骑士施放嘲讽时发出警报。",
	--taunt_warning = "Taunt done in 5sec!",
	
	shieldwall = "白骨屏障",
	shieldwall_desc = "当见习死亡骑士施放白骨屏障时发出警报。",
	--shieldwall_warning = "Shield Wall done in 5sec!",
} end )

L:RegisterTranslations("zhTW", function() return {
	knife = "鋸齒刀",
	knife_desc = "當玩家中了鋸齒刀時發出警報。",
	knife_message = ">%s<：鋸齒刀！",

	taunt = "嘲諷",
	taunt_desc = "當死亡騎士實習者施放嘲諷時發出警報。",
	--taunt_warning = "Taunt done in 5sec!",
	
	shieldwall = "骸骨屏障",
	shieldwall_desc = "當死亡騎士實習者施放骸骨屏障時發出警報。",
	--shieldwall_warning = "Shield Wall done in 5sec!",
} end )

L:RegisterTranslations("frFR", function() return {
	knife = "Couteau dentelé",
	knife_desc = "Prévient quand un joueur subit les effets du Couteau dentelé.",
	knife_message = "%s : Couteau dentelé",

	taunt = "Provocation",
	taunt_desc = "Prévient de l'arrivée des Provocations.",
	--taunt_warning = "Taunt done in 5sec!",

	shieldwall = "Mur protecteur",
	shieldwall_desc = "Prévient de l'arrivée des Murs protecteurs.",
	--shieldwall_warning = "Shield Wall done in 5sec!",
} end )

L:RegisterTranslations("ruRU", function() return {
	--knife = "Jagged Knife",
	--knife_desc = "Warn who has Jagged Knife.",
	--knife_message = "%s: Jagged Knife",

	--taunt = "Taunt",
	--taunt_desc = "Warn for taunt.",
	--taunt_warning = "Taunt done in 5sec!",
	
	--shieldwall = "Shield Wall",
	--shieldwall_desc = "Warn for shieldwall.",
	--shieldwall_warning = "Shield Wall done in 5sec!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = {boss, understudy}
mod.guid = 16061
mod.toggleoptions = {"knife", -1, "shieldwall", "taunt", "bosskill",}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Taunt", 29060)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Knife", 55550)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "ShieldWall", 29061)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:ShieldWall(_, spellID, _, _, spellName)
	if self.db.profile.shieldwall then
		self:Message(spellName, "Positive", nil, nil, nil, spellID)
		self:Bar(spellName, 20, spellID)
		self:DelayedMessage(15, L["taunt_warning"], "Attention")
	end
end

function mod:Taunt(_, spellID, _, _, spellName)
	if self.db.profile.taunt then
		self:Message(spellName, "Positive", nil, nil, nil, spellID)
		self:Bar(spellName, 20, spellID)
		self:DelayedMessage(15, L["shieldwall_warning"], "Attention")
	end
end

function mod:Knife(unit, spellID)
	if self.db.profile.knife then
		self:Message(L["knife_message"]:format(unit), "Important", nil, nil, nil, spellID)
	end
end
