------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Instructor Razuvious"]
local understudy = BB["Deathknight Understudy"]
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
	taunt_message = "%s - taunt",
	
	shieldwall = "Shield Wall",
	shieldwall_desc = "Warn for shieldwall.",
	shieldwall_message = "%s - Shield Wall",
} end )

L:RegisterTranslations("deDE", function() return {
	--knife = "Jagged Knife",
	--knife_desc = "Warn who has Jagged Knife.",
	--knife_message = "%s: Jagged Knife",
	
	--taunt = "Taunt",
	--taunt_desc = "Warn for taunt.",
	--taunt_message = "%s - taunt",

	--shieldwall = "Shield Wall",
	--shieldwall_desc = "Warn for shieldwall.",
	--shieldwall_message = "%s - Shield Wall",
} end )

L:RegisterTranslations("koKR", function() return {
	knife = "뾰족한 나이프",
	knife_desc = "뾰족한 나이프에 걸린 플레이어를 알립니다.",
	knife_message = "뾰족한 나이프: %s",

	taunt = "도발",
	taunt_desc = "도발에 대하여 알립니다.",
	taunt_message = "%s - 도발",
	
	shieldwall = "방패의 벽",
	shieldwall_desc = "방패의 벽에 대하여 알립니다",
	shieldwall_message = "%s - 방패의 벽",
} end )

L:RegisterTranslations("zhCN", function() return {
	--knife = "Jagged Knife",
	--knife_desc = "Warn who has Jagged Knife.",
	--knife_message = "%s: Jagged Knife",

	--taunt = "Taunt",
	--taunt_desc = "Warn for taunt.",
	--taunt_message = "%s - taunt",
	
	--shieldwall = "Shield Wall",
	--shieldwall_desc = "Warn for shieldwall.",
	--shieldwall_message = "%s - Shield Wall",
} end )

L:RegisterTranslations("zhTW", function() return {
	--knife = "Jagged Knife",
	--knife_desc = "Warn who has Jagged Knife.",
	--knife_message = "%s: Jagged Knife",
	
	--taunt = "Taunt",
	--taunt_desc = "Warn for taunt.",
	--taunt_message = "%s - taunt",

	--shieldwall = "Shield Wall",
	--shieldwall_desc = "Warn for shieldwall.",
	--shieldwall_message = "%s - Shield Wall",
} end )

L:RegisterTranslations("frFR", function() return {
	knife = "Couteau dentelé",
	knife_desc = "Prévient quand un joueur subit les effets du Couteau dentelé.",
	knife_message = "%s : Couteau dentelé",

	taunt = "Provocation",
	taunt_desc = "Prévient de l'arrivée des Provocations.",
	taunt_message = "%s - Provocation",

	shieldwall = "Mur protecteur",
	shieldwall_desc = "Prévient de l'arrivée des Murs protecteurs.",
	shieldwall_message = "%s - Mur protecteur",
} end )

L:RegisterTranslations("ruRU", function() return {
	--knife = "Jagged Knife",
	--knife_desc = "Warn who has Jagged Knife.",
	--knife_message = "%s: Jagged Knife",

	--taunt = "Taunt",
	--taunt_desc = "Warn for taunt.",
	--taunt_message = "%s - taunt",
	
	--shieldwall = "Shield Wall",
	--shieldwall_desc = "Warn for shieldwall.",
	--shieldwall_message = "%s - Shield Wall",
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

function mod:ShieldWall(unit, spellID)
	if unit == understudy and self.db.profile.shieldwall then
		self:Message(L["shieldwall_message"]:format(unit), "Positive", nil, nil, nil, spellID)
		self:Bar(L["shieldwall_message"]:format(unit), 20, spellID)
	end
end

function mod:Taunt(unit, spellID)
	if unit == understudy and self.db.profile.taunt then
		self:Message(L["taunt_message"]:format(unit), "Positive", nil, nil, nil, spellID)
		self:Bar(L["taunt_message"]:format(unit), 20, spellID)
	end
end

function mod:Knife(unit, spellID)
	if self.db.profile.knife then
		self:Message(L["knife_message"]:format(unit), "Important", nil, nil, nil, spellID)
	end
end

