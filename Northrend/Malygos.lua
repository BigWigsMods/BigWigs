----------------------------------
--      Module Declaration      --
----------------------------------

local boss = "Malygos"
local mod = BigWigs:NewBoss(boss, "$Revision$")
if not mod then return end
mod.bossName = "Malygos"
mod.zoneName = "The Eye of Eternity"
mod.otherMenu = "Northrend"
mod.enabletrigger = 28859
mod.guid = 28859
mod.toggleOptions = {"phase", -1, "sparks", 56152, "vortex", -1, "breath", -1, "surge", 57429, "berserk", "bosskill"}
mod.consoleCmd = "Malygos"

------------------------------
--      Are you local?      --
------------------------------

local UnitName = UnitName
local pName = UnitName("player")
local db = nil
local started = nil
local phase = nil
local fmt = string.format

------------------------------
--      English Locale      --
------------------------------
L = LibStub("AceLocale-3.0"):NewLocale("BigWigsMalygos", "enUS", true)
if L then
	L.sparks = "Spark Spawns"
	L.sparks_desc = "Warns on Power Spark spawns."
	L.sparks_message = "Power Spark spawns!"
	L.sparks_warning = "Power Spark in ~5sec!"

	L.sparkbuff_message = "Malygos gains Power Spark!"
	
	L.vortex = "Vortex"
	L.vortex_desc = "Warn for Vortex in phase 1."
	L.vortex_message = "Vortex!"
	L.vortex_warning = "Possible Vortex in ~5sec!"
	L.vortex_next = "Vortex Cooldown"
	
	L.breath = "Deep Breath"
	L.breath_desc = "Warn when Malygos is using Deep Breath in phase 2."
	L.breath_message = "Deep Breath!"
	L.breath_warning = "Deep Breath in ~5sec!"

	L.surge = "Surge of Power"
	L.surge_desc = "Warn when Malygos uses Surge of Power on you in phase 3."
	L.surge_you = "Surge of Power on YOU!"
	L.surge_trigger = "%s fixes his eyes on you!"

	L.phase = "Phases"
	L.phase_desc = "Warn for phase changes."
	L.phase2_warning = "Phase 2 soon!"
	L.phase2_trigger = "I had hoped to end your lives quickly"
	L.phase2_message = "Phase 2 - Nexus Lord & Scion of Eternity!"
	L.phase2_end_trigger = "ENOUGH! If you intend to reclaim Azeroth's magic"
	L.phase3_warning = "Phase 3 soon!"
	L.phase3_trigger = "Now your benefactors make their"
	L.phase3_message = "Phase 3!"
end
L = LibStub("AceLocale-3.0"):GetLocale("BigWigs"..boss)
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Static", 57429)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Spark", 56152)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "Vortex", 56105)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterMessage("BigWigs_RecvSync")

	started = nil
	db = self.db.profile
	phase = 0
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Spark(player, spellId)
	if player == self.bossName and phase == 1 then
		self:IfMessage(L["sparkbuff_message"], "Important", spellId)
	end
end

function mod:Static(target, spellId, _, _, spellName)
	if target == pName then
		self:LocalMessage(spellName, "Urgent", spellId)
	end
end

function mod:Vortex(_, spellId)
	if db.vortex then
		self:Bar(L["vortex"], 10, 56105)
		self:IfMessage(L["vortex_message"], "Attention", spellId)
		self:Bar(L["vortex_next"], 59, 56105)
		self:DelayedMessage(54, L["vortex_warning"], "Attention")
		if db.sparks then
			self:Bar(L["sparks"], 17, 56152)
			self:DelayedMessage(12, L["sparks_warning"], "Attention")
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_WHISPER(event, msg, mob)
	if phase == 3 and db.surge and msg == L["surge_trigger"] then
		self:LocalMessage(L["surge_you"], "Personal", 60936, "Alarm") -- 60936 for phase 3, not 56505
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg)
	if phase == 1 then
		if db.sparks then
			self:Message(L["sparks_message"], "Important", 56152, "Alert")
			self:Bar(L["sparks"], 30, 56152)
			self:DelayedMessage(25, L["sparks_warning"], "Attention")
		end
	elseif phase == 2 then
		if db.breath then
			-- 43810 Frost Wyrm, looks like a dragon breathing 'deep breath' :)
			-- Correct spellId for 'breath" in phase 2 is 56505
			self:Message(L["breath_message"], "Important", 43810, "Alert")
			self:Bar(L["breath"], 59, 43810)
			self:DelayedMessage(54, L["breath_warning"], "Attention")
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg:find(L["phase2_trigger"]) then
		phase = 2
		self:CancelAllScheduledEvents()
		self:TriggerEvent("BigWigs_StopBar", self, L["sparks"])
		self:TriggerEvent("BigWigs_StopBar", self, L["vortex_next"])
		self:Message(L["phase2_message"], "Attention")
		if db.breath then
			self:Bar(L["breath"], 92, 43810)
			self:DelayedMessage(87, L["breath_warning"], "Attention")
		end
	elseif msg:find(L["phase2_end_trigger"]) then
		self:CancelAllScheduledEvents()
		self:TriggerEvent("BigWigs_StopBar", self, L["breath"])
		self:Message(L["phase3_warning"], "Attention")
	elseif msg:find(L["phase3_trigger"]) then
		phase = 3
		self:Message(L["phase3_message"], "Attention")
	end
end

function mod:UNIT_HEALTH(event, msg)
	if phase ~= 1 or not db.phase then return end
	if UnitName(msg) == self.bossName then
		local hp = UnitHealth(msg)
		if hp > 51 and hp <= 54 then
			self:Message(L["phase2_warning"], "Attention")
		end
	end
end

function mod:BigWigs_RecvSync(event, sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		phase = 1
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if db.vortex then
			self:Bar(L["vortex_next"], 29, 56105)
			self:ScheduleEvent("VortexWarn", "BigWigs_Message", 24, L["vortex_warning"], "Attention")
		end
		if db.sparks then
			self:Bar(L["sparks"], 25, 56152)
			self:ScheduleEvent("SparkWarn", "BigWigs_Message", 20, L["sparks_warning"], "Attention")
		end
		if db.berserk then
			self:Enrage(600, true)
		end
	end
end

