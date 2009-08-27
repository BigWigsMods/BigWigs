----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Auriaya"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33515
--Feral Defender = 34035
mod.toggleOptions = {64386, 64389, 64396, 64422, "defender", "berserk", "bosskill"}
mod.consoleCmd = "Auriaya"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local started = nil
local pName = UnitName("player")
local count = 9
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	fear_warning = "Fear soon!",
	fear_message = "Casting Fear!",
	fear_bar = "~Fear",

	swarm_other = "Swarm on %s!",
	swarm_you = "Swarm on YOU!",
	swarm_bar = "~Swarm",

	defender = "Feral Defender",
	defender_desc = "Warn for Feral Defender lives.",
	defender_message = "Defender up %d/9!",

	sonic_bar = "~Sonic",
} end )

L:RegisterTranslations("koKR", function() return {
	fear_warning = "곧 공포!",
	fear_message = "공포 시전!",
	fear_bar = "~공포 대기시간",

	swarm_other = "무리 수호자: %s!",
	swarm_you = "당신은 무리 수호자!",
	swarm_bar = "~무리 대기시간",

	defender = "수호 야수",
	defender_desc = "수호 야수의 남은 생명 횟수를 알립니다.",
	defender_message = "수호 야수 (생명: %d/9)!",

	sonic_bar = "~음파 대기시간",
} end )

L:RegisterTranslations("frFR", function() return {
	fear_warning = "Hurlement terrifiant imminent !",
	fear_message = "Hurlement terrifiant en incantation !",
	fear_bar = "~H. terrifiant",

	swarm_other = "Essaim : %s",
	swarm_you = "Essaim gardien sur VOUS !",
	swarm_bar = "~Essaim",

	defender = "Défenseur farouche",
	defender_desc = "Prévient quand le Défenseur farouche apparaît et quand il perd une vie.",
	defender_message = "Défenseur actif %d/9 !",

	sonic_bar = "~H. sonore",
} end )

L:RegisterTranslations("deDE", function() return {
	fear_warning = "Furcht bald!",
	fear_message = "Furcht!",
	fear_bar = "~Furcht",

	swarm_other = "Wächterschwarm: %s!",
	swarm_you = "Wächterschwarm auf DIR!",
	swarm_bar = "~Wächterschwarm",

	defender = "Wilder Verteidiger",
	defender_desc = "Warnt, wieviele Leben der Wilder Verteidiger noch hat.",
	defender_message = "Verteidiger da %d/9!",

	sonic_bar = "~Überschallkreischen",
} end )

L:RegisterTranslations("zhCN", function() return {
	fear_warning = "即将 惊骇尖啸！",
	fear_message = "正在施放 惊骇尖啸！",
	fear_bar = "<惊骇尖啸 冷却>",

	swarm_other = "守护虫群：>%s<！",
	swarm_you = ">你< 守护虫群！",
	swarm_bar = "<守护虫群 冷却>",

	defender = "野性防御者",
	defender_desc = "当野性防御者出现时发出警报。",
	defender_message = "野性防御者（%d/9）！",

	sonic_bar = "<音速尖啸>",
} end )

L:RegisterTranslations("zhTW", function() return {
	fear_warning = "即將 恐嚇尖嘯！",
	fear_message = "正在施放 恐嚇尖嘯！",
	fear_bar = "<恐嚇尖嘯 冷卻>",

	swarm_other = "守護貓群：>%s<！",
	swarm_you = ">你< 守護貓群！",
	swarm_bar = "<守護貓群 冷卻>",

	defender = "野性防衛者",
	defender_desc = "當野性防衛者出現時發出警報。",
	defender_message = "野性防衛者（%d/9）！",

	sonic_bar = "<音速尖嘯>",
} end )

L:RegisterTranslations("ruRU", function() return {
	fear_warning = "Скоро Ужасающий вопль!",
	fear_message = "Применение страха!",
	fear_bar = "~страх",

	swarm_other = "Страж выбрал |3-3(%s)!",
	swarm_you = "Страж выбрал ВАС!",
	swarm_bar = "~стража",

	defender = "Дикий защитник",
	defender_desc = "Сообщать о жизни Дикого защитника.",
	defender_message = "Защитник (%d/9)!",

	sonic_bar = "~перезарядка визга",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	db = self.db.profile
	started = nil

	self:AddCombatListener("SPELL_CAST_START", "Sonic", 64422, 64688)
	self:AddCombatListener("SPELL_CAST_START", "Fear", 64386)
	self:AddCombatListener("SPELL_CAST_START", "Sentinel", 64389, 64678)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Swarm", 64396)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Defender", 64455)
	self:AddCombatListener("SPELL_AURA_REMOVED_DOSE", "DefenderKill", 64455)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Sonic(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Attention", spellId)
	self:Bar(L["sonic_bar"], 28, spellId)
end

function mod:Defender(_, spellId)
	if db.defender then
		self:IfMessage(L["defender_message"]:format(count), "Attention", spellId)
	end
end

function mod:DefenderKill(_, spellId)
	count = count - 1
	if db.defender then
		self:Bar(L["defender_message"]:format(count), 34, spellId)
	end
end

function mod:Swarm(player, spell)
	if player == pName then
		mod:LocalMessage(L["swarm_you"], "Attention", spell)
	else
		mod:TargetMessage(L["swarm_other"], player, "Attention", spell)
	end
	mod:Bar(L["swarm_bar"], 37, spell)
end

function mod:Fear(_, spellId)
	self:IfMessage(L["fear_message"], "Urgent", spellId)
	self:Bar(L["fear_bar"], 35, spellId)
	self:DelayedMessage(32, L["fear_warning"], "Attention")
end

function mod:Sentinel(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Important", spellId)
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		count = 9
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then 
			self:UnregisterEvent("PLAYER_REGEN_DISABLED") 
		end
		if self:GetOption(64455) then
			self:Bar(L["defender_message"]:format(count), 60, 64455)
		end
		if self:GetOption(64386) then
			self:Bar(L["fear_bar"], 32, 64386)
			self:DelayedMessage(32, L["fear_warning"], "Attention")
		end
		if db.berserk then
			self:Enrage(600, true)
		end
	end
end

