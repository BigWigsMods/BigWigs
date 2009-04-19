----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Auriaya"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33515
mod.toggleoptions = {"fear", "sentinel", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local started = nil

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Auriaya",

	fear = "Terrifying Screech",
	fear_desc = "Warn when about Horrifying Screech.",
	fear_warning = "Fear soon!",
	fear_message = "Casting Fear!",
	fear_bar = "~Fear Cooldown",

	sentinel = "Sentinel Blast",
	sentinel_desc = "Warn when Auriaya casts a Sentinel Blast.",
	sentinel_message = "Sentinel Blast!",
} end )

L:RegisterTranslations("koKR", function() return {
	fear = "공포의 비명소리",
	fear_desc = "공포의 비명소리에 대해 알립니다.",
	fear_warning = "곧 공포!",
	fear_message = "공포 시전!",
	fear_bar = "~공포 대기시간",

	sentinel = "파수꾼 폭발",
	sentinel_desc = "아우리아야의 파수꾼 폭발 시전을 알립니다.",
	sentinel_message = "파수꾼 폭발!",
	} end )

L:RegisterTranslations("frFR", function() return {
	fear = "Hurlement terrifiant",
	fear_desc = "Prévient de l'arrivée des Hurlements terrifiants.",
	fear_warning = "Hurlement imminent !",
	fear_message = "Hurlement en incantation !",
	fear_bar = "~Recharge Hurlement",

	sentinel = "Déflagration du factionnaire",
	sentinel_desc = "Prévient quand Auriaya incante une Déflagration du factionnaire.",
	sentinel_message = "Déflagration du factionnaire !",
} end )

L:RegisterTranslations("deDE", function() return {
	fear = "Schreckliches Kreischen",
	fear_desc = "Warnungen und Timer für Schreckliches Kreischen.",
	fear_warning = "Furcht bald!",
	fear_message = "Furcht!",
	fear_bar = "~Furcht",

	sentinel = "Schildwachenschlag",
	sentinel_desc = "Warnt, wenn Auriaya Schildwachenschlag wirkt.",
	sentinel_message = "Schildwachenschlag!",
} end )

L:RegisterTranslations("zhCN", function() return {
	fear = "恐吓尖啸",
	fear_desc = "当施放恐吓尖啸时发出警报。",
	fear_warning = "即将 恐吓尖啸！",
	fear_message = "正在施放 恐吓尖啸！",
	fear_bar = "<恐吓尖啸 冷却>",

	sentinel = "戒卫冲击",
	sentinel_desc = "当欧尔莉亚施放戒卫冲击时发出警报。",
	sentinel_message = "戒卫冲击！",
} end )

L:RegisterTranslations("zhTW", function() return {
	fear = "恐嚇尖嘯",
	fear_desc = "當施放恐嚇尖嘯時發出警報。",
	fear_warning = "即將 恐嚇尖嘯！",
	fear_message = "正在施放 恐嚇尖嘯！",
	fear_bar = "<恐嚇尖嘯 冷卻>",

	sentinel = "哨兵衝擊",
	sentinel_desc = "當奧芮雅施放哨兵沖擊時發出警報。",
	sentinel_message = "哨兵沖擊！",
} end )

L:RegisterTranslations("ruRU", function() return {
	fear = "Ужасающий вопль",
	fear_desc = "Предупреждать об Ужасающем вопле.",
	fear_warning = "Скоро Ужасающий вопль!",
	fear_message = "Применение страха!",
	fear_bar = "~перезарядка страха",

	sentinel = "Удар часового",
	sentinel_desc = "Предупреждать когда Ауриайя применяет Удар часового.",
	sentinel_message = "Удар часового!",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Fear", 64386)
	self:AddCombatListener("SPELL_CAST_START", "Sentinel", 64389, 64678)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")

	db = self.db.profile
	started = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Fear(_, spellID)
	if db.fear then
		self:IfMessage(L["fear_message"], "Attention", spellID)
		self:Bar(L["fear_bar"], 35, spellID)
		self:DelayedMessage(32, L["fear_warning"], "Attention")
	end
end

function mod:Sentinel(_, spellID)
	if db.sentinel then
		self:IfMessage(L["sentinel_message"], "Attention", spellID)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then 
			self:UnregisterEvent("PLAYER_REGEN_DISABLED") 
		end
	end
end

