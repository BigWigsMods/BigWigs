----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Flame Leviathan"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33113
mod.toggleoptions = {"flame", "pursue", "shutdown", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local started = nil
local pName = UnitName("player")
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Leviathan",

	engage_trigger = "^Hostile entities detected.",
	engage_message = "%s Engaged!",

	flame = "Flame Jet",
	flame_desc = "Warn when Flame Leviathan casts a Flame Jet.",
	flame_message = "Flame Jet!",

	pursue = "Pursuit",
	pursue_desc = "Warn when Flame Leviathan pursues a player.",
	pursue_trigger = "^%%s pursues",
	pursue_other = "Leviathan pursues %s!",
	pursue_you = "Leviathan pursues YOU!",

	shutdown = "Systems Shutdown",
	shutdown_desc = "Warn when the systems shut down.",
	shutdown_message = "Systems down!",
	--overload_trigger = "%s's curcuits overloaded.",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "^적대적인 존재 감지.",
	engage_message = "%s 전투 시작!",

	flame = "화염 분출",
	flame_desc = "거대 화염전차으 화염 분출 시전을 알립니다.",
	flame_message = "화염 분출!",

	pursue = "추격",
	pursue_desc = "플레이어에게 거대 화염전차의 추적을 알립니다.",
	pursue_trigger = "([^%s]+)|1을;를; 쫓습니다.$",
	pursue_other = "%s 추격!",
	pursue_you = "당신을 추격!",

	shutdown = "시스템 작동 정지",
	shutdown_desc = "거대 화염전차의 시스템 작동 정지를 알립니다.",
	shutdown_message = "시스템 작동 정지!",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "^Entités hostiles détectées.",
	engage_message = "%s engagé !",

	flame = "Décharges de flammes",
	flame_desc = "Prévient quand le Léviathan des flammes incante des Décharges de flammes.",
	flame_message = "Décharges de flammes !",

	pursue = "Poursuite",
	pursue_desc = "Prévient quand le Léviathan des flammes poursuit un joueur.",
	pursue_trigger = "^%%s poursuit",
	pursue_other = "Poursuivi(e) : %s",
	pursue_you = "Léviathan des flammes VOUS poursuit !",

	shutdown = "Extinction des systèmes",
	shutdown_desc = "Prévient quand le Léviathan des flammes éteint ses systèmes.",
	shutdown_message = "Extinction des systèmes !",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "^Feindeinheiten erkannt",
	engage_message = "%s angegriffen!",

	flame = "Flammenstrahl",
	flame_desc = "Warnung und Timer für Flammenstrahl.",
	flame_message = "Flammenstrahl!",

	pursue = "Verfolgung",
	pursue_desc = "Warnt, wenn der Flammenleviathan einen Spieler verfolgt.",
	pursue_trigger = "^%%s verfolgt",
	pursue_other = "%s wird verfolgt!",
	pursue_you = "DU wirst verfolgt!",

	shutdown = "Systemabschaltung",
	shutdown_desc = "Warnung für Systemabschaltung.",
	shutdown_message = "Systemabschaltung!",
} end )

L:RegisterTranslations("zhCN", function() return {
--	engage_trigger = "^Hostile entities detected.",
	engage_message = "%s已激怒！",

	flame = "Flame Jet",
	flame_desc = "当烈焰巨兽施放Flame Jet时发出警报。",
	flame_message = "Flame Jet！",

	pursue = "Pursuit",
	pursue_desc = "当烈焰巨兽pursues玩家时发出警报。",
--	pursue_trigger = "^%%s pursues",
	pursue_other = "烈焰巨兽pursues：>%s<！",
	pursue_you = ">你< 烈焰巨兽pursues！",

	shutdown = "Systems Shutdown",
	shutdown_desc = "当烈焰巨兽Systems Shutdown时发出警报。",
	shutdown_message = "Systems Shutdown！",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "發現敵意實體。啟動威脅評估協定。首要目標接近中。30秒後將再度評估。",
	engage_message = "%s已狂怒！",

	flame = "烈焰噴洩",
	flame_desc = "當烈焰戰輪施放烈焰噴洩時發出警報。",
	flame_message = "烈焰噴洩！",

	pursue = "獵殺",
	pursue_desc = "當烈焰戰輪獵殺玩家時發出警報。",
	pursue_trigger = "^%%s緊追",
	pursue_other = "烈焰戰輪獵殺：>%s<！",
	pursue_you = ">你< 烈焰戰輪獵殺！",

	shutdown = "系統關閉",
	shutdown_desc = "當烈焰戰輪系統關閉時發出警報。",
	shutdown_message = "系統關閉！",
} end )

L:RegisterTranslations("ruRU", function() return {
	engage_trigger = "^Обнаружены противники.",
	engage_message = "%s вступает в бой!",

	flame = "Огненная струя",
	flame_desc = "Сообщать когда Огненный Левиафан применяет огненную струю.",
	flame_message = "Огненная струя!",

	pursue = "Погоня",
	pursue_desc = "Сообщать когда Огненный Левиафан преследует игрока.",
	pursue_trigger = "^%%s наводится на",
	pursue_other = "Левиафан преследует |3-3(%s)!",
	pursue_you = "Левиафан преследует ВАС!",

	shutdown = "Отключение системы",
	shutdown_desc = "Сообщать когда Огненный Левиафан отключает системы",
	shutdown_message = "Отключение системы!",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Flame", 62396)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Shutdown", 62475)
	self:AddCombatListener("SPELL_AURA_REMOVED", "FlameFailed", 62396)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Flame()
	if db.flame then
		self:IfMessage(L["flame_message"], "Urgent", 62396)
		self:Bar(L["flame"], 10, 62396)
	end
end

function mod:FlameFailed()
	self:TriggerEvent("BigWigs_StopBar", self, L["flame"])
end

function mod:Shutdown()
	if db.shutdown then
		self:IfMessage(L["shutdown_message"], "Positive", 62475, "Long")
		self:Bar(L["shutdown"], 20, 62475)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(message, unit, _, _, player)
	if unit == boss and db.pursue and message:find(L["pursue_trigger"]) then
		if player == pName then
			self:LocalMessage(L["pursue_you"], "Personal", 62374, "Alarm")
			self:WideMessage(L["pursue_other"]:format(player))
		else
			self:TargetMessage(L["pursue_other"], player, "Attention", 62374)
		end
		self:Bar(L["pursue_other"]:format(player), 30, 62374)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then
		self:IfMessage(L["engage_message"]:format(boss), "Attention")
	end
end

