--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Professor Putricide", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36678)
mod.toggleOptions = {{70447, "ICON", "WHISPER"}, {72455, "ICON", "WHISPER"}, 71966, "phase", "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local p2, p3 = nil, nil

--------------------------------------------------------------------------------
--  Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.phase = "Phases"
	L.phase_desc = "Warn for phase changes."

	L.engage_trigger = "Good news, everyone!"

	L.add_message = "Ooze add incoming!"
	L.blight_message = "Red ooze"
	L.violation_message = "Green ooze"

	L.phase2_warning = "Phase 2 soon!"
	L.phase3_warning = "Phase 3 soon!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "ChasedByRedOoze", 72455)
	self:Log("SPELL_AURA_APPLIED", "StunnedByGreenOoze", 70447)
	self:Log("SPELL_CAST_START", "Experiment", 70351, 71966)

	self:RegisterEvent("UNIT_HEALTH")

	self:Death("RedOozeDeath", 37562)
	self:Death("Win", 36678)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])
end

function mod:OnEngage()
	self:Berserk(600)
	p2, p3 = nil, nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, msg)
	if p2 and p3 then
		self:UnregisterEvent("UNIT_HEALTH")
		return
	end
	if UnitName(msg) == self.displayName then
		local hp = UnitHealth(msg)
		if hp <= 83 and not p2 then
			self:Message("phase", L["phase2_warning"], "Positive")
			p2 = true
		elseif hp <= 37 and not p3 then
			self:Message("phase", L["phase3_warning"], "Positive")
			p3 = true
		end
	end
end

do
	local barText = nil
	function mod:ChasedByRedOoze(player, spellId)
		self:TargetMessage(72455, L["blight_message"], player, "Personal", spellId)
		self:Whisper(72455, player, L["blight_message"])
		self:PrimaryIcon(72455, player)
		barText = CL.other:format(L["blight_message"], player)
		self:Bar(72455, barText, 20, spellId)
	end
	function mod:RedOozeDeath()
		self:SendMessage("BigWigs_StopBar", self, barText)
	end
end

function mod:StunnedByGreenOoze(player, spellId)
	self:TargetMessage(70447, L["violation_message"], player, "Personal", spellId)
	self:Whisper(70447, player, L["violation_message"])
	self:PrimaryIcon(70447, player)
end

function mod:Experiment(_, spellId)
	self:Message(71966, L["add_message"], "Attention", spellId)
end

