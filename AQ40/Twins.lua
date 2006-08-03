------------------------------
--      Are you local?      --
------------------------------

local veklor = AceLibrary("Babble-Boss-2.0")("Emperor Vek'lor")
local veknilash = AceLibrary("Babble-Boss-2.0")("Emperor Vek'nilash")
local boss = AceLibrary("Babble-Boss-2.0")("The Twin Emperors")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs" .. boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Twins",

	bug_cmd = "bug",
	bug_name = "Exploding Bug Alert",
	bug_desc = "Warn for exploding bugs",

	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for Teleport",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",

	heal_cmd = "heal",
	heal_name = "Heal Alert",
	heal_desc = "Warn for Twins Healing",

	porttrigger = "casts Twin Teleport.",
	portwarn = "Teleport!",
	portdelaywarn = "Teleport in 5 seconds!",
	bartext = "Teleport",
	explodebugtrigger = "gains Explode Bug%.$",
	explodebugwarn = "Bug exploding nearby!",
	enragetrigger = "becomes enraged.",
	enragewarn = "Twins are enraged",
	healtrigger1 = "'s Heal Brother heals",
	healtrigger2 = " Heal Brother heals",
	healwarn = "Casting Heal Brother - Separate them fast!",
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

L:RegisterTranslations("zhCN", function() return {
	porttrigger = "施放了双子传送。",
	portwarn = "双子传送发动！",
	portdelaywarn = "5秒后发动双子传送！",
	bartext = "双子传送",
	explodebugtrigger = "获得了爆炸虫的效果。$",
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

L:RegisterTranslations("koKR", function() return {
	porttrigger = "(.+)|1이;가; 쌍둥이 순간이동|1을;를; 시전합니다.",
	portwarn = "순간 이동!",
	portdelaywarn = "5초후 순간 이동!",
	bartext = "순간 이동",
	explodebugtrigger = "(.+)|1이;가; 벌레 폭발 효과를 얻었습니다.",
	explodebugwarn = "벌레 폭발!",
	enragetrigger = "becomes enraged.",
	enragewarn = "Twins are Enraged",
	healtrigger1 = "(.+)|1이;가; 형제 치유|1을;를; 시전합니다.",
	healtrigger2 = "(.+)|1이;가; 형제 치유|1을;를; 시전합니다.",
	healwarn = "형제치유 시전중 - 쌍둥이 분리!",
	startwarn = "Twin Emperors Engaged! Enrage in 15 minutes!",
	enragebartext = "Enrage",
	warn1 = "Enrage in 10 minutes",
	warn2 = "Enrage in 5 minutes",
	warn3 = "Enrage in 3 minutes",
	warn4 = "Enrage in 90 seconds",
	warn5 = "Enrage in 60 seconds",
	warn6 = "Enrage in 30 seconds",
	warn7 = "Enrage in 10 seconds",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsTwins = BigWigs:NewModule(boss)
BigWigsTwins.zonename = AceLibrary("Babble-Zone-2.0")("Ahn'Qiraj")
BigWigsTwins.enabletrigger = {veklor, veknilash}
BigWigsTwins.toggleoptions = {"bug", "teleport", "enrage", "heal", "bosskill"}
BigWigsTwins.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsTwins:OnEnable()
	self.enragestarted = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "TwinsEnrage", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "TwinsTeleport", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsTwins:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, veklor) or msg == string.format(UNITDIESOTHER, veknilash) then
		if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.0"):new("BigWigs")("%s have been defeated"), boss), "Green", nil, "Victory") end
		self.core:ToggleModuleActive(self, false)
	end
end

function BigWigsTwins:PLAYER_REGEN_DISABLED()
	local go = self:Scan()
	local running = self:IsEventScheduled("Twins_CheckStart")
	if (go) then
		self:CancelScheduledEvent("Twins_CheckStart")
		self:TriggerEvent("BigWigs_SendSync", "TwinsEnrage")
	elseif not running then
		self:ScheduleRepeatingEvent("Twins_CheckStart", self.PLAYER_REGEN_DISABLED, .5, self)
	end

end

function BigWigsTwins:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	local running = self:IsEventScheduled("Twins_CheckWipe")
	if (not go) then
		self:TriggerEvent("BigWigs_RebootModule", self)
	elseif (not running) then
		self:ScheduleRepeatingEvent("Twins_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)
	end
end

function BigWigsTwins:Scan()
	if ( (UnitName("target") == veklor or UnitName("target") == veknilash) and UnitAffectingCombat("target")) then
		return true
	elseif ((UnitName("playertarget") == veklor or UnitName("playertarget") == veknilash) and UnitAffectingCombat("playertarget")) then
		return true
	else
		local i
		for i = 1, GetNumRaidMembers(), 1 do
			if ( (UnitName("Raid"..i.."target") == veklor or UnitName("Raid"..i.."target") == veknilash) and UnitAffectingCombat("Raid"..i.."target")) then
				return true
			end
		end
	end
	return false
end

function BigWigsTwins:BigWigs_RecvSync(sync)
	if sync == "TwinsEnrage" and not self.enragestarted then
		self.enragestarted = true
		if self.db.profile.teleport then
			self:ScheduleEvent("BigWigs_Message", 25, L"portdelaywarn", "Red")
			self:TriggerEvent("BigWigs_StartBar", self, L"bartext", 30, 1, "Interface\\Icons\\Spell_Arcane_Blink", "Yellow", "Orange", "Red")
		end
		if self.db.profile.enrage then
			self:TriggerEvent("BigWigs_Message", L"startwarn", "Red")
			self:TriggerEvent("BigWigs_StartBar", self, L"enragebartext", 900, 2, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy", "Green", "Yellow", "Orange", "Red")
			self:ScheduleEvent("bwtwinswarn1", "BigWigs_Message", 300, L"warn1", "Green")
			self:ScheduleEvent("bwtwinswarn2", "BigWigs_Message", 600, L"warn2", "Yellow")
			self:ScheduleEvent("bwtwinswarn3", "BigWigs_Message", 720, L"warn3", "Yellow")
			self:ScheduleEvent("bwtwinswarn4", "BigWigs_Message", 810, L"warn4", "Orange")
			self:ScheduleEvent("bwtwinswarn5", "BigWigs_Message", 840, L"warn5", "Orange")
			self:ScheduleEvent("bwtwinswarn6", "BigWigs_Message", 870, L"warn6", "Red")
			self:ScheduleEvent("bwtwinswarn7", "BigWigs_Message", 890, L"warn7", "Red")
		end
	elseif sync == "TwinsTeleport" and self.db.profile.teleport then
		self:TriggerEvent("BigWigs_Message", L"portwarn", "Yellow")
		self:ScheduleEvent("BigWigs_Message", 25, L"portdelaywarn", "Red")
		self:TriggerEvent("BigWigs_StartBar", self, L"bartext", 30, 1, "Interface\\Icons\\Spell_Arcane_Blink", "Yellow", "Orange", "Red")
	end
end

function BigWigsTwins:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if (string.find(msg, L"porttrigger")) then
		self:TriggerEvent("BigWigs_SendSync", "TwinsTeleport")
	end
end

function BigWigsTwins:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if (string.find(msg, L"explodebugtrigger") and self.db.profile.bug) then
		self:TriggerEvent("BigWigs_Message", L"explodebugwarn", "Red", true)
	end
end

function BigWigsTwins:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if (self.db.profile.heal and (string.find(msg, L"healtrigger1") or string.find(msg, L"healtrigger2")) and not self.prior) then
		self:TriggerEvent("BigWigs_Message", L"healwarn", "Red")
		self.prior = true
		self:ScheduleEvent(function() BigWigsTwins.prior = nil end, 10)
	end
end

function BigWigsTwins:CHAT_MSG_MONSTER_EMOTE(msg)
	if (string.find(msg, L"enragetrigger") and self.db.profile.enrage) then
		self:TriggerEvent("BigWigs_Message", L"enragewarn", "Red")
	end
end