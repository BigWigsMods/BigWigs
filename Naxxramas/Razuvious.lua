------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Instructor Razuvious"]
local understudy = BB["Death knight Understudy"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Razuvious",

	shout = "Disrupting Shout",
	shout_desc = "Warn for Disrupting Shout.",
	shout_warning = "Disrupting Shout in 5sec!",
	shout_next = "Shout Cooldown",

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
	--shout = "Disrupting Shout",
	--shout_desc = "Warn for Disrupting Shout.",
	--shout_warning = "Disrupting Shout in 5sec!",
	--shout_next = "Shout Cooldown",

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
	shout = "분열의 외침",
	shout_desc = "분열의 외침을 알립니다.",
	shout_warning = "5초 후 분열의 외침!",
	shout_next = "분열 대기시간",

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
	shout = "瓦解怒吼",
	shout_desc = "当施放瓦解怒吼时发出警报。",
	shout_warning = "5秒后，瓦解怒吼！",
	shout_next = "瓦解怒吼冷却！",

	knife = "裂纹小刀",
	knife_desc = "当玩家中了裂纹小刀时发出警报。",
	knife_message = "裂纹小刀：>%s<！",

	taunt = "嘲讽",
	taunt_desc = "当见习死亡骑士施放嘲讽时发出警报。",
	taunt_warning = "5秒后，可以嘲讽！",
	
	shieldwall = "白骨屏障",
	shieldwall_desc = "当见习死亡骑士施放白骨屏障时发出警报。",
	shieldwall_warning = "5秒后，可以白骨屏障！",
} end )

L:RegisterTranslations("zhTW", function() return {
	shout = "混亂怒吼",
	shout_desc = "當施放混亂怒吼時發出警報。",
	shout_warning = "5秒后，混亂怒吼！",
	shout_next = "混亂怒吼冷卻！",

	knife = "鋸齒刀",
	knife_desc = "當玩家中了鋸齒刀時發出警報。",
	knife_message = "鋸齒刀：>%s<！",

	taunt = "嘲諷",
	taunt_desc = "當死亡騎士實習者施放嘲諷時發出警報。",
	taunt_warning = "5秒后，可以嘲諷！",

	shieldwall = "骸骨屏障",
	shieldwall_desc = "當死亡騎士實習者施放骸骨屏障時發出警報。",
	shieldwall_warning = "5秒后，可以骸骨屏障！",
} end )

L:RegisterTranslations("frFR", function() return {
	shout = "Cri perturbant",
	shout_desc = "Prévient de l'arrivée des Cris perturbant.",
	shout_warning = "Cri perturbant dans 5 sec. !",
	shout_next = "Recharge Cri",

	knife = "Couteau dentelé",
	knife_desc = "Prévient quand un joueur subit les effets du Couteau dentelé.",
	knife_message = "%s : Couteau dentelé",

	taunt = "Provocation",
	taunt_desc = "Prévient de l'arrivée des Provocations.",
	taunt_warning = "Provocation terminée dans 5 sec. !",

	shieldwall = "Mur protecteur",
	shieldwall_desc = "Prévient de l'arrivée des Murs protecteurs.",
	shieldwall_warning = "Mur protecteur terminé dans 5 sec. !",
} end )

L:RegisterTranslations("ruRU", function() return {
	shout = "Разрушительный крик",
	shout_desc = "Предупреждать о  Разрушительном крике.",
	shout_warning = "Разрушительный крик через 5сек!",
	shout_next = "перезарядка крика",

	knife = "Зазубренный нож",
	knife_desc = "Предупреждать, в кого будет брошен Зазубренный нож.",
	knife_message = "Зазубренный нож: %s",

	taunt = "Провокация",
	taunt_desc = "Предупреждать о провокации.",
	taunt_warning = "Провокация закончится через 5сек!",

	shieldwall = "Преграда из костей",
	shieldwall_desc = "Предупреждать о Преграде из костей.",
	shieldwall_warning = "Преграда из костей закончится через 5сек!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Naxxramas"]
mod.enabletrigger = {boss, understudy}
mod.guid = 16061
mod.toggleoptions = {"shout", "knife", -1, "shieldwall", "taunt", "bosskill",}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Shout", 29107, 55543)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Taunt", 29060)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Knife", 55550)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "ShieldWall", 29061)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	
	started = nil
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Shout()
	if self.db.profile.shout then
		self:IfMessage(L["shout"], "Important", 55543)
		self:Bar(L["shout_next"], 15, 55543)
		self:DelayedMessage(12, L["shout_warning"], "Attention")
	end
end

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

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.shout then
			self:Shout()
		end
	end
end
