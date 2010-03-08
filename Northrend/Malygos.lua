--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Malygos", "The Eye of Eternity")
if not mod then return end
mod.otherMenu = "Northrend"
mod:RegisterEnableMob(28859)
mod.toggleOptions = {"phase", "sparks", "sparkbuff", "vortex", "breath", {"surge", "FLASHSHAKE"}, 57429, "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local phase = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.sparks = "Spark Spawns"
	L.sparks_desc = "Warns on Power Spark spawns."
	L.sparks_message = "Power Spark spawns!"
	L.sparks_warning = "Power Spark in ~5sec!"

	L.sparkbuff = "Power Spark on Malygos"
	L.sparkbuff_desc = "Warns when Malygos gets a Power Spark."
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
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Static", 57429)
	self:Log("SPELL_AURA_APPLIED", "Spark", 56152)
	self:Log("SPELL_CAST_SUCCESS", "Vortex", 56105)
	self:Death("Win", 28859)

	self:Yell("Phase2", L["phase2_trigger"])
	self:Yell("P2End", L["phase2_end_trigger"])
	self:Yell("Phase3", L["phase3_trigger"])

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER")
	-- Since we don't have the actual emotes here we can't use :Emote
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
end

function mod:OnEngage()
	phase = 1
	self:Bar("vortex", L["vortex_next"], 29, 56105)
	self:DelayedMessage("vortex", 24, L["vortex_warning"], "Attention")
	self:Bar("sparks", L["sparks"], 25, 56152)
	self:DelayedMessage("sparks", 20, L["sparks_warning"], "Attention")
	self:Berserk(600)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Spark(unit, spellId)
	if unit == self.displayName then
		self:Message("sparkbuff", L["sparkbuff_message"], "Important", spellId)
	end
end

function mod:Static(target, spellId, _, _, spellName)
	if UnitIsUnit(target, "player") then
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

function mod:Phase2()
	phase = 2
	self:CancelDelayedMessage(L["vortex_warning"])
	self:CancelDelayedMessage(L["sparks_warning"])
	self:SendMessage("BigWigs_StopBar", self, L["sparks"])
	self:SendMessage("BigWigs_StopBar", self, L["vortex_next"])
	self:Message("phase", L["phase2_message"], "Attention")
	self:Bar("breath", L["breath"], 92, 43810)
	self:DelayedMessage("breath", 87, L["breath_warning"], "Attention")
end

function mod:P2End()
	self:CancelDelayedMessage(L["breath_warning"])
	self:SendMessage("BigWigs_StopBar", self, L["breath"])
	self:Message("phase", L["phase3_warning"], "Attention")
end

function mod:Phase3()
	phase = 3
	self:Message("phase", L["phase3_message"], "Attention")
end

function mod:UNIT_HEALTH(event, msg)
	if phase ~= 1 then return end
	if UnitName(msg) == self.displayName then
		local hp = UnitHealth(msg) / UnitHealthMax(msg) * 100
		if hp > 51 and hp <= 54 then
			self:Message("phase", L["phase2_warning"], "Attention")
			self:UnregisterEvent("UNIT_HEALTH")
		end
	end
end

