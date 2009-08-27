----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Flame Leviathan"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33113
mod.toggleOptions = {68605, 62396, "pursue", 62475, "bosskill"}
mod.consoleCmd = "Leviathan"

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	engage_trigger = "^Hostile entities detected.",
	engage_message = "%s Engaged!",

	pursue = "Pursuit",
	pursue_desc = "Warn when Flame Leviathan pursues a player.",
	pursue_trigger = "^%%s pursues",
	pursue_other = "Leviathan pursues %s!",

	shutdown_message = "Systems down!",
} end)

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "^적대적인 존재 감지.",
	engage_message = "%s 전투 시작!",

	pursue = "추격",
	pursue_desc = "플레이어에게 거대 화염전차의 추적을 알립니다.",
	pursue_trigger = "([^%s]+)|1을;를; 쫓습니다.$",
	pursue_other = "%s 추격!",

	shutdown_message = "시스템 작동 정지!",
} end)

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "^Entités hostiles détectées.",
	engage_message = "%s engagé !",

	pursue = "Poursuite",
	pursue_desc = "Prévient quand le Léviathan des flammes poursuit un joueur.",
	pursue_trigger = "^%%s poursuit",
	pursue_other = "Poursuivi(e) : %s",

	shutdown_message = "Extinction des systèmes !",
} end)

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "^Feindeinheiten erkannt",
	engage_message = "%s angegriffen!",

	pursue = "Verfolgung",
	pursue_desc = "Warnt, wenn der Flammenleviathan einen Spieler verfolgt.",
	pursue_trigger = "^%%s verfolgt",
	pursue_other = "%s wird verfolgt!",

	shutdown_message = "Systemabschaltung!",
} end)

L:RegisterTranslations("zhCN", function() return {
--	engage_trigger = "^Hostile entities detected.",
	engage_message = "%s已激怒！",

	pursue = "追踪",
	pursue_desc = "当烈焰巨兽追踪玩家时发出警报。",
--	pursue_trigger = "^%%s被追踪",
	pursue_other = "烈焰巨兽追踪：>%s<！",

	shutdown_message = "系统关闭！",
} end)

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "發現敵意實體。啟動威脅評估協定。首要目標接近中。30秒後將再度評估。",
	engage_message = "%s已狂怒！",

	pursue = "獵殺",
	pursue_desc = "當烈焰戰輪獵殺玩家時發出警報。",
	pursue_trigger = "^%%s緊追",
	pursue_other = "烈焰戰輪獵殺：>%s<！",

	shutdown_message = "系統關閉！",
} end)

L:RegisterTranslations("ruRU", function() return {
	engage_trigger = "^Обнаружены противники.",
	engage_message = "%s вступает в бой!",

	pursue = "Погоня",
	pursue_desc = "Сообщать когда Огненный Левиафан преследует игрока.",
	pursue_trigger = "^%%s наводится на",
	pursue_other = "Левиафан преследует |3-3(%s)!",

	shutdown_message = "Отключение системы!",
} end)

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Flame", 62396)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Shutdown", 62475)
	self:AddCombatListener("SPELL_AURA_REMOVED", "FlameFailed", 62396)

	self:AddCombatListener("SPELL_AURA_APPLIED", "Pyrite", 68605)
	self:AddCombatListener("SPELL_AURA_APPLIED_DOSE", "Pyrite", 68605)
	self:AddCombatListener("SPELL_AURA_REFRESH", "Pyrite", 68605)

	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Pyrite(_, spellId, _, _, spellName, _, sFlags)
	if bit.band(sFlags, COMBATLOG_OBJECT_AFFILIATION_MINE or 0x1) ~= 0 then
		self:Bar(spellName, 10, spellId)
	end
end

function mod:Flame(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Urgent", spellId)
	self:Bar(spellName, 10, spellId)
end

function mod:FlameFailed(_, _, _, _, spellName)
	self:TriggerEvent("BigWigs_StopBar", self, spellName)
end

function mod:Shutdown(unit, spellId, _, _, spellName)
	if unit ~= boss then return end
	self:IfMessage(L["shutdown_message"], "Positive", spellId, "Long")
	self:Bar(spellName, 20, spellId)
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(message, unit, _, _, player)
	if unit == boss and self.db.profile.pursue and message:find(L["pursue_trigger"]) then
		self:TargetMessage(L["pursue"], player, "Personal", 62374, "Alarm")
		self:Bar(L["pursue_other"]:format(player), 30, 62374)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then
		self:IfMessage(L["engage_message"]:format(boss), "Attention")
	end
end

