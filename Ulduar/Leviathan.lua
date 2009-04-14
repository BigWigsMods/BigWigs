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
	shutdown_desc = "Warn when Flame Leviathan a Systems Shutdown",
	shutdown_message = "Systems Shutdown!",

	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "^적대적인 존재 감지.",
	engage_message = "%s 전투 시작!",

	flame = "화염 분출",
	flame_desc = "거대 화염전차으 화염 분출 시전을 알립니다.",
	flame_message = "화염 분출!",

	pursue = "추적",
	pursue_desc = "플레이어에게 거대 화염전차의 추적을 알립니다.",
	--pursue_trigger = "^%%s pursues"
	pursue_other = "%s 추적!",
	pursue_you = "당신을 추적!",

	shutdown = "시스템 작동 정지",
	shutdown_desc = "거대 화염전차의 시스템 작동 정지를 알립니다.",
	shutdown_message = "시스템 작동 정지!",

	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 transcriptor로 저장된 데이터 보내주시기 바랍니다.",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "^Entités hostiles détectées.",
	engage_message = "%s engagé !",

	flame = "Flots de flammes",
	flame_desc = "Prévient quand le Léviathan des flammes incante des Flots de flammes.",
	flame_message = "Flots de flammes !",

	pursue = "Poursuite",
	pursue_desc = "Prévient quand le Léviathan des flammes poursuit un joueur.",
	pursue_trigger = "^%%s examine",
	pursue_other = "Léviathan poursuit %s !",
	pursue_you = "Léviathan VOUS poursuit !",

	shutdown = "Extinction des systèmes",
	shutdown_desc = "Prévient quand le Léviathan des flammes éteint ses systèmes.",
	shutdown_message = "Extinction des systèmes !",

	log = "|cffff0000"..boss.."|r : ce boss a besoin de données, merci d'activer votre /combatlog ou Transcriptor et de nous transmettre les logs.",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "^Hostile entities detected.", -- need
	engage_message = "%s angegriffen!",

	flame = "Flammenstrahlen",
	flame_desc = "Warnung für Flammenstrahlen.",
	flame_message = "Flammenstrahlen!",

	pursue = "Verfolgung",
	pursue_desc = "Warnung wenn der Flammenleviathan einen Spieler verfolgt.",
	pursue_trigger = "^%%s verfolgt", -- check
	pursue_other = "Leviathan verfolgt %s!",
	pursue_you = "Leviathan verfolgt DICH!",

	shutdown = "Systemabschaltung",
	shutdown_desc = "Warnung für Systemabschaltung",
	shutdown_message = "Systemabschaltung!",

	log = "|cffff0000"..boss.."|r: Dieser Boss benötigt Daten, wenn möglich schalte bitte deinen /combatlog oder Transcriptor an, und übermittle die Daten.",
} end )

L:RegisterTranslations("zhCN", function() return {
--[[
	engage_trigger = "^Hostile entities detected.",
	engage_message = "%s已激怒！",

	flame = "Flame Jet",
	flame_desc = "当烈焰巨兽施放Flame Jet时发出警报。",
	flame_message = "Flame Jet！",

	pursue = "Pursuit",
	pursue_desc = "当烈焰巨兽pursues玩家时发出警报。",
	pursue_trigger = "^%%s pursues",
	pursue_other = "烈焰巨兽pursues：>%s<！",
	pursue_you = ">你< 烈焰巨兽pursues！",

	shutdown = "Systems Shutdown",
	shutdown_desc = "当烈焰巨兽Systems Shutdown时发出警报。",
	shutdown_message = "Systems Shutdown！",
]]
	log = "|cffff0000"..boss.."|r：缺乏数据，请考虑开启战斗记录（/combatlog）或 Transcriptor 记录并提交战斗记录，谢谢！",
} end )

L:RegisterTranslations("zhTW", function() return {
--	engage_trigger = "^Hostile entities detected.",
	engage_message = "%s已狂怒！",

	flame = "烈焰噴洩",
	flame_desc = "當烈焰戰輪施放烈焰噴洩時發出警報。",
	flame_message = "烈焰噴洩！",

	pursue = "獵殺",
	pursue_desc = "當烈焰戰輪獵殺玩家時發出警報。",
--	pursue_trigger = "^%%s pursues",
	pursue_other = "烈焰戰輪獵殺：>%s<！",
	pursue_you = ">你< 烈焰戰輪獵殺！",

	shutdown = "系統關閉",
	shutdown_desc = "當烈焰戰輪系統關閉時發出警報。",
	shutdown_message = "系統關閉！",

	log = "|cffff0000"..boss.."|r：缺乏數據，請考慮開啟戰斗記錄（/combatlog）或 Transcriptor 記錄并提交戰斗記錄，謝謝！",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Flame", 62396)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Shutdown", 62475)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	db = self.db.profile

	BigWigs:Print(L["log"])
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Flame()
	if db.flame then
		self:IfMessage(L["flame_message"], "Attention", 62396)
		self:Bar(L["flame"], 10, 62396)
	end
end

function mod:Shutdown()
	if db.shutdown then
		self:Message(L["shutdown_message"], "Attention")
		self:Bar(L["shutdown"], 20, 62475)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(message, unit, _, _, player)
	if unit == boss then
		if db.pursue and message:find(L["pursue_trigger"]) then
			local other = fmt(L["pursue_other"], player)
			if player == pName then
				self:LocalMessage(L["pursue_you"], "Important", 62374, "Long")
				self:WideMessage(other)
			else
				self:IfMessage(other, "Attention", 62374)
			end
			self:Bar(other, 30, 62374)
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L["engage_trigger"]) then
		self:Message(L["engage_message"], "Attention")
	end
end
