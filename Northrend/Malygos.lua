----------------------------------
--      Module Declaration      --
----------------------------------
local mod = BigWigs:NewBoss("Malygos", "The Eye of Eternity")
if not mod then return end
mod.otherMenu = "Northrend"
mod:RegisterEnableMob(28859)
mod.toggleOptions = {"phase", "sparks", 56152, "vortex", "breath", {"surge", "FLASHSHAKE"}, 57429, "berserk", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local pName = UnitName("player")
local phase = nil

------------------------------
--      English Locale      --
------------------------------
local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Malygos", "enUS", true)
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
L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Malygos")
mod.locale = L

------------------------------
--      Initialization      --
------------------------------

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Static", 57429)
	self:Log("SPELL_AURA_APPLIED", "Spark", 56152)
	self:Log("SPELL_CAST_SUCCESS", "Vortex", 56105)
	self:Death("Win", 28859)

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnBossDisable()
	phase = 0
end

function mod:OnEngage()
	phase = 1
	self:Bar("vortex", L["vortex_next"], 29, 56105)
	self:DelayedMessage("vortex", 24, L["vortex_warning"], "Attention")
	self:Bar("sparks", L["sparks"], 25, 56152)
	self:DelayedMessage("sparks", 20, L["sparks_warning"], "Attention")
	self:Berserk(600)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Spark(unit, spellId, _, _, _, _, _, _, dGUID)
	if phase ~= 1 then return end
	local target = QueryQuestsCompleted and tonumber(dGUID:sub(-12, -9), 16) or tonumber(dGUID:sub(-12, -7), 16)
	if target == 28859 then
		self:Message(56152, L["sparkbuff_message"], "Important", spellId)
	end
end

function mod:Static(target, spellId, _, _, spellName)
	if target == pName then
		self:LocalMessage(57429, spellName, "Urgent", spellId)
	end
end

function mod:Vortex(_, spellId)
	self:Bar("vortex", L["vortex"], 10, 56105)
	self:Message("vortex", L["vortex_message"], "Attention", spellId)
	self:Bar("vortex", L["vortex_next"], 59, 56105)
	self:DelayedMessage("vortex", 54, L["vortex_warning"], "Attention")

	self:Bar("sparks", L["sparks"], 17, 56152)
	self:DelayedMessage("sparks", 12, L["sparks_warning"], "Attention")
end

function mod:CHAT_MSG_RAID_BOSS_WHISPER(event, msg, mob)
	if phase == 3 and msg == L["surge_trigger"] then
		self:LocalMessage("surge", L["surge_you"], "Personal", 60936, "Alarm") -- 60936 for phase 3, not 56505
		self:FlashShake("surge")
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(event, msg)
	if phase == 1 then
		self:Message("sparks", L["sparks_message"], "Important", 56152, "Alert")
		self:Bar("sparks", L["sparks"], 30, 56152)
		self:DelayedMessage("sparks", 25, L["sparks_warning"], "Attention")
	elseif phase == 2 then
		-- 43810 Frost Wyrm, looks like a dragon breathing 'deep breath' :)
		-- Correct spellId for 'breath" in phase 2 is 56505
		self:Message("breath", L["breath_message"], "Important", 43810, "Alert")
		self:Bar("breath", L["breath"], 59, 43810)
		self:DelayedMessage("breath", 54, L["breath_warning"], "Attention")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg:find(L["phase2_trigger"]) then
		phase = 2
		self:CancelScheduledEvent(L["vortex_warning"])
		self:CancelScheduledEvent(L["sparks_warning"])
		self:SendMessage("BigWigs_StopBar", self, L["sparks"])
		self:SendMessage("BigWigs_StopBar", self, L["vortex_next"])
		self:Message("phase", L["phase2_message"], "Attention")
		self:Bar("breath", L["breath"], 92, 43810)
		self:DelayedMessage("breath", 87, L["breath_warning"], "Attention")
	elseif msg:find(L["phase2_end_trigger"]) then
		self:CancelScheduledEvent(L["breath_warning"])
		self:SendMessage("BigWigs_StopBar", self, L["breath"])
		self:Message("phase", L["phase3_warning"], "Attention")
	elseif msg:find(L["phase3_trigger"]) then
		phase = 3
		self:Message("phase", L["phase3_message"], "Attention")
	end
end

function mod:UNIT_HEALTH(event, msg)
	if phase ~= 1 then return end
	if UnitName(msg) == self.displayName then
		local hp = UnitHealth(msg)
		if hp > 51 and hp <= 54 then
			self:Message("phase", L["phase2_warning"], "Attention")
		end
	end
end

