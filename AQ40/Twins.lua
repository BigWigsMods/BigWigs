------------------------------
--      Are you local?      --
------------------------------

local veklor = AceLibrary("Babble-Boss-2.2")["Emperor Vek'lor"]
local veknilash = AceLibrary("Babble-Boss-2.2")["Emperor Vek'nilash"]
local boss = AceLibrary("Babble-Boss-2.2")["The Twin Emperors"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs" .. boss)

local started = nil
local cachedUnitId = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Twins",

	bug_name = "Exploding Bug Alert",
	bug_desc = "Warn for exploding bugs",

	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for Teleport",

	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",

	heal_name = "Heal Alert",
	heal_desc = "Warn for Twins Healing",

	porttrigger = "Twin Teleport",
	portwarn = "Teleport!",
	portdelaywarn = "Teleport in ~5 seconds!",
	portdelaywarn2 = "Teleport in ~10 seconds!",
	bartext = "Teleport",
	explodebugtrigger = "gains Explode Bug%.$",
	explodebugwarn = "Bug exploding nearby!",
	enragetrigger = "becomes enraged.",
	enragewarn = "Twins are enraged",
	healtrigger1 = "'s Heal Brother heals",
	healtrigger2 = " Heal Brother heals",
	healwarn = "Casting Heal!",
	startwarn = "Twin Emperors engaged! Enrage in 15 minutes!",
	enragebartext = "Enrage",
	warn1 = "Enrage in 10 minutes",
	warn2 = "Enrage in 5 minutes",
	warn3 = "Enrage in 3 minutes",
	warn4 = "Enrage in 90 seconds",
	warn5 = "Enrage in 60 seconds",
	warn6 = "Enrage in 30 seconds",
	warn7 = "Enrage in 10 seconds",
} end )

L:RegisterTranslations("deDE", function() return {
	bug_name = "Explodierende K\195\164fer",
	bug_desc = "Warnung vor explodierenden K\195\164fern.",

	teleport_name = "Teleport",
	teleport_desc = "Warnung, wenn die Zwillings Imperatoren sich teleportieren.",

	enrage_name = "Wutanfall",
	enrage_desc = "Warnung, wenn die Zwillings Imperatoren w\195\188tend werden.",

	heal_name = "Heilung",
	heal_desc = "Warnung, wenn die Zwillings Imperatoren sich heilen.",

	porttrigger = "wirkt Zwillingsteleport.",
	portwarn = "Teleport!",
	portdelaywarn = "Teleport in ~5 Sekunden!",
	portdelaywarn2 = "Teleport in ~10 Sekunden!",
	bartext = "Teleport",
	explodebugtrigger = "bekommt 'K\195\164fer explodieren lassen'",
	explodebugwarn = "K\195\164fer explodiert!",
	enragetrigger = "wird w\195\188tend.", -- ? "bekommt 'Wutanfall'"
	enragewarn = "Zwillings Imperatoren sind w\195\188tend!",
	healtrigger1 = "'s Bruder heilen heilt",
	healtrigger2 = " Bruder heilen heilt",
	healwarn = "Heilung gewirkt!",
	startwarn = "Zwillings Imperatoren angegriffen! Wutanfall in 15 Minuten!",
	enragebartext = "Wutanfall",
	warn1 = "Wutanfall in 10 Minuten",
	warn2 = "Wutanfall in 5 Minuten",
	warn3 = "Wutanfall in 3 Minuten",
	warn4 = "Wutanfall in 90 Sekunden",
	warn5 = "Wutanfall in 60 Sekunden",
	warn6 = "Wutanfall in 30 Sekunden",
	warn7 = "Wutanfall in 10 Sekunden",
} end )

L:RegisterTranslations("zhCN", function() return {
	bug_name = "爆炸虫警报",
	bug_desc = "爆炸虫警报",

	teleport_name = "传送警报",
	teleport_desc = "传送警报",

	enrage_name = "激怒警报",
	enrage_desc = "激怒警报",

	heal_name = "治疗警报",
	heal_desc = "双子皇帝互相治疗时发出警报",

	porttrigger = "施放了双子传送。",
	portwarn = "双子传送发动！",
	portdelaywarn = "5秒后发动双子传送！",
	portdelaywarn2 = "10秒后发动双子传送！",
	bartext = "双子传送",
	explodebugtrigger = "(.+)获得了爆炸虫",
	explodebugwarn = "爆炸虫即将出现！",
	enragetrigger = "获得了激怒的效果。",
	enragewarn = "双子皇帝获得了激怒的效果！",
	healtrigger1 = "的治疗兄弟为",
	healtrigger2 = "的治疗兄弟为",
	healwarn = "正在施放治疗兄弟 - 快将他们分开！",
	startwarn = "双子皇帝已激活 - 15分钟后进入激怒状态",
	enragebartext = "激怒",
	warn1 = "10分钟后激怒",
	warn2 = "5分钟后激怒",
	warn3 = "3分钟后激怒",
	warn4 = "90秒后激怒",
	warn5 = "60秒后激怒",
	warn6 = "30秒后激怒",
	warn7 = "10秒后激怒",
} end )

L:RegisterTranslations("zhTW", function() return {
	bug_name = "爆炸蟲警報",
	bug_desc = "雙子皇帝施放爆炸蟲時發出警報",

	teleport_name = "傳送警報",
	teleport_desc = "雙子皇帝施放雙子傳送時發出警報",

	enrage_name = "狂怒警報",
	enrage_desc = "雙子皇帝的狂怒倒數計時與時警報",

	heal_name = "治療警報",
	heal_desc = "雙子皇帝互相治療時發出警報",

	porttrigger = "施放了雙子傳送。",
	portwarn = "雙子傳送發動！",
	portdelaywarn = "5 秒後發動雙子傳送！",
	portdelaywarn2 = "10 秒後發動雙子傳送！",
	bartext = "雙子傳送",
	explodebugtrigger = "(.+)獲得了爆炸蟲的效果。$",
	explodebugwarn = "爆炸蟲即將出現！",
	enragetrigger = "獲得了狂怒的效果。",
	enragewarn = "開始狂怒！",
	healtrigger1 = "的治療兄弟為",
	healtrigger2 = "的治療兄弟為",
	healwarn = "正在施放治療兄弟 - 快拉開！",
	startwarn = "雙子皇帝已進入戰鬥 - 15分鐘後進入狂怒狀態",
	enragebartext = "狂怒",
	warn1 = "10 分鐘後狂怒",
	warn2 = "5 分鐘後狂怒",
	warn3 = "3 分鐘後狂怒",
	warn4 = "90 秒後狂怒",
	warn5 = "60 秒後狂怒",
	warn6 = "30 秒後狂怒",
	warn7 = "10 秒後狂怒",
} end )

L:RegisterTranslations("koKR", function() return {
	bug_name = "벌레 폭발 경고",
	bug_desc = "벌레 폭발에 대한 경고",

	teleport_name = "순간이동 경고",
	teleport_desc = "순간이동에 대한 경고",

	enrage_name = "격노 경고",
	enrage_desc = "격노에 대한 경고",

	heal_name = "치유 경고",
	heal_desc = "형제 치유에 대한 경고",

	porttrigger = "쌍둥이 순간이동|1을;를; 시전합니다.",
	portwarn = "순간 이동!",
	portdelaywarn = "약 5초후 순간 이동!",
	portdelaywarn2 = "약 10초후 순간 이동!",
	bartext = "순간 이동",
	explodebugtrigger = "(.+)|1이;가; 벌레 폭발 효과를 얻었습니다.",
	explodebugwarn = "벌레 폭발!",
	enragetrigger = "%s|1이;가; 격노 효과를 얻었습니다.", -- CHECK
	enragewarn = "쌍둥이 격노!!",
	healtrigger1 = "(.+)|1이;가; 형제 치유|1을;를;",
	healtrigger2 = "(.+)의 형제 치유|1으로;로;",

	healwarn = "형제 치유 시전중 - 쌍둥이 분리!",
	startwarn = "쌍둥이 제왕 전투 시작! 15분 후 격노!",
	enragebartext = "격노",
	warn1 = "격노 - 10 분전",
	warn2 = "격노 - 5 분전",
	warn3 = "격노 - 3 분전",
	warn4 = "격노 - 90 초전",
	warn5 = "격노 - 60 초전",
	warn6 = "격노 - 30 초전",
	warn7 = "격노 - 10 초전",
} end )

L:RegisterTranslations("frFR", function() return {
	bug_name = "Alerte explosion d'insecte",
	bug_desc = "Pr\195\169viens de l'explosion des insectes.",

	teleport_name = "Alerte T\195\169l\195\169portation",
	teleport_desc = "Pr\195\169viens des t\195\169l\195\169portations.",

	enrage_name =  "Alerte Enrag\195\169s",
	enrage_desc = "Pr\195\169viens quand les jumeaux sont enrag\195\169s.",

	heal_name = "Alerte soins",
	heal_desc = "Pr\195\169viens quand les jumeaux se soignent.",

	portwarn = "T\195\169l\195\169portation !",
	portdelaywarn = "T\195\169l\195\169portation dans ~5 secondes !",
	portdelaywarn2 = "T\195\169l\195\169portation dans ~10 secondes !",
	bartext = "T\195\169l\195\169portation",
	explodebugwarn = "Explosion d'insecte proche !",
	enragewarn = "Les jumeaux sont enrag\195\169s !",
	healwarn = "Incantation de soins !",
	startwarn = "Les empereurs jumeaux engag\195\169s ! Enrag\195\169s dans 15 minutes",
	enragebartext = "Enrag\195\169s",
	warn1 = "Enrag\195\169s dans 10 minutes",
	warn2 = "Enrag\195\169s dans 5 minutes",
	warn3 = "Enrag\195\169s dans 3 minutes",
	warn4 = "Enrag\195\169s dans 90 secondes",
	warn5 = "Enrag\195\169s dans 60 secondes",
	warn6 = "Enrag\195\169s dans 30 secondes",
	warn7 = "Enrag\195\169s dans 10 secondes",

	porttrigger = "lance T\195\169l\195\169portation des jumeaux.",
	explodebugtrigger = "gagne Explosion de l'insecte%.$",
	enragetrigger = "devient fou furieux.",-- not sure at all
	healtrigger1 = "Soigner fr\195\168re (.+) gu\195\169rit",
	healtrigger2 = "Soigner fr\195\168re (.+) soigne", 
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"]
mod.enabletrigger = {veklor, veknilash}
mod.toggleoptions = {"bug", "teleport", "enrage", "heal", "bosskill"}
mod.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	started = nil
	cachedUnitId = nil

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "TwinsTeleport", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, veklor) or msg == string.format(UNITDIESOTHER, veknilash) then
		if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.2"):new("BigWigs")["%s have been defeated"], boss), "Bosskill", nil, "Victory") end
		self.core:ToggleModuleActive(self, false)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.teleport then
			self:ScheduleEvent("BigWigs_Message", 20, L["portdelaywarn2"], "Urgent")
			self:ScheduleEvent("BigWigs_Message", 25, L["portdelaywarn"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["bartext"], 30, "Interface\\Icons\\Spell_Arcane_Blink")

			self:ScheduleEvent("bwtwinscannercooldown", self.StartTargetScanner, 20, self)
		end
		if self.db.profile.enrage then
			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["enragebartext"], 900, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
			self:ScheduleEvent("bwtwinswarn1", "BigWigs_Message", 300, L["warn1"], "Attention")
			self:ScheduleEvent("bwtwinswarn2", "BigWigs_Message", 600, L["warn2"], "Attention")
			self:ScheduleEvent("bwtwinswarn3", "BigWigs_Message", 720, L["warn3"], "Attention")
			self:ScheduleEvent("bwtwinswarn4", "BigWigs_Message", 810, L["warn4"], "Urgent")
			self:ScheduleEvent("bwtwinswarn5", "BigWigs_Message", 840, L["warn5"], "Urgent")
			self:ScheduleEvent("bwtwinswarn6", "BigWigs_Message", 870, L["warn6"], "Important")
			self:ScheduleEvent("bwtwinswarn7", "BigWigs_Message", 890, L["warn7"], "Important")
		end
	elseif sync == "TwinsTeleport" and self.db.profile.teleport then
		self:CancelScheduledEvent("bwtwinscanner")
		self:CancelScheduledEvent("bwtwinscannercooldown")

		self:TriggerEvent("BigWigs_Message", L["portwarn"], "Attention")
		self:ScheduleEvent("BigWigs_Message", 20, L["portdelaywarn2"], "Urgent")
		self:ScheduleEvent("BigWigs_Message", 25, L["portdelaywarn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["bartext"], 30, "Interface\\Icons\\Spell_Arcane_Blink")

		self:ScheduleEvent("bwtwinscannercooldown", self.StartTargetScanner, 20, self)
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["porttrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "TwinsTeleport")
	end
end

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg:find(L["explodebugtrigger"]) and self.db.profile.bug then
		self:TriggerEvent("BigWigs_Message", L["explodebugwarn"], "Personal", true)
	elseif msg:find(L["porttrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "TwinsTeleport")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if not self.prior and (msg:find(L["healtrigger1"]) or msg:find(L["healtrigger2"])) and self.db.profile.heal then
		self:TriggerEvent("BigWigs_Message", L["healwarn"], "Important")
		self.prior = true
		self:ScheduleEvent(function() mod.prior = nil end, 10)
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if (msg:find(L["enragetrigger"]) and self.db.profile.enrage) then
		self:TriggerEvent("BigWigs_Message", L["enragewarn"], "Important")
	end
end

-------------------------------
--      Target Scanner       --
-- (Because Blizz Fucked Up) --
-------------------------------

function mod:StartTargetScanner()
	if self:IsEventScheduled("bwtwinscanner") or not started then return end
	self:CancelScheduledEvent("bwtwinscannercooldown")
	self:ScheduleRepeatingEvent("bwtwinscanner", self.RepeatedScanner, 0.5, self)
end

local function validateTarget(unitId)
	return
		(UnitName(unitId) == veknilash or UnitName(unitId) == veklor) and
		UnitAffectingCombat(unitId) and CheckInteractDistance(unitId, 4)
end

function mod:RepeatedScanner()
	if not UnitAffectingCombat("player") then
		self:CancelScheduledEvent("bwtwinscanner")
		self:CancelScheduledEvent("bwtwinscannercooldown")
		return
	end

	if not started then return end
	local found = nil

	-- If we have a cached unit (which we will if we found someone with the boss
	-- as target), then check if he still has the same target
	if cachedUnitId and validateTarget(cachedUnitId) then
		found = true
	end

	-- Check the players target
	if not found and validateTarget("target") then
		cachedUnitId = "target"
		found = true
	end

	if not found and validateTarget("focus") then
		cachedUnitId = "focus"
		found = true
	end

	-- Loop the raid roster
	if not found then
		local num = GetNumRaidMembers()
		for i = 1, num do
			local unit = "raid"..i.."target"
			if validateTarget(unit) then
				cachedUnitId = unit
				found = true
				break
			end
		end
	end

	local targetTarget = nil

	-- Alright, we've got a valid unitId with the boss as target, now check if
	-- the boss has a target. If it does, we're not porting.
	if found then targetTarget = UnitName(cachedUnitId .. "target") end

	-- We've checked everything. If nothing was found, just return home.
	-- We basically shouldn't return here, because someone should always have
	-- him targetted.
	if not found or targetTarget then return end

	self:CancelScheduledEvent("bwtwinscanner")
	self:TriggerEvent("BigWigs_SendSync", "TwinsTeleport")
end

