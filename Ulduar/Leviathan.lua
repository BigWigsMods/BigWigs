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
	engage_trigger = "^Entités hostiles détectées.", -- à vérifier
	engage_message = "%s engagé !",

	flame = "Flots de flammes",
	flame_desc = "Prévient quand le Léviathan des flammes incante des Flots de flammes.",
	flame_message = "Flots de flammes !",

	pursue = "Poursuite",
	pursue_desc = "Prévient quand le Léviathan des flammes poursuit un joueur.",
	--pursue_trigger = "^%%s pursues"
	pursue_other = "Léviathan poursuit %s !",
	pursue_you = "Léviathan VOUS poursuit !",

	shutdown = "Extinction des systèmes",
	shutdown_desc = "Prévient quand le Léviathan des flammes éteint ses systèmes.",
	shutdown_message = "Extinction des systèmes !",

	log = "|cffff0000"..boss.."|r : ce boss a besoin de données, merci d'activer votre /combatlog ou Transcriptor et de nous transmettre les logs.",
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
