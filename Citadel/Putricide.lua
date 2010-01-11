--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Professor Putricide", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36678)
mod.toggleOptions = {{70447, "ICON", "WHISPER"}, {72455, "ICON", "WHISPER"}, 71966, 71255, {72295, "ICON", "SAY", "FLASHSHAKE"}, 72451, "phase", "berserk", "bosskill"}
local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
mod.optionHeaders = {
	[70447] = CL.phase:format(1),
	[71255] = CL.phase:format(2),
	[72451] = CL.phase:format(3),
	phase = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local p2, p3 = nil, nil
local pName = UnitName("player")

--------------------------------------------------------------------------------
--  Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phase = "Phases"
	L.phase_desc = "Warn for phase changes."
	L.phase2_trigger = "Hmm. I don't feel a thing. Whaa...? Where'd those come from?"
	L.phase3_trigger = "Tastes like... Cherry! Oh! Excuse me!"

	L.engage_trigger = "Good news, everyone!"

	L.ball_message = "bouncing goo ball on %s!"
	L.ball_bar = "Next bouncing goo ball"
	L.ball_say = "Bouncing goo ball on me!"

	L.experiment_bar = "Next add"
	L.blight_message = "Red ooze"
	L.violation_message = "Green ooze"

	L.plague_message = "%2$dx plague on %1$s"
	L.plague_bar = "Next plague"

	L.phase2_warning = "Phase 2 soon!"
	L.phase2_message = "Phase 2!"
	L.phase3_warning = "Phase 3 soon!"
	L.phase3_message = "Phase 3!"

	L.gasbomb_bar = "More yellow gas bombs!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "ChasedByRedOoze", 72455, 70672)
	self:Log("SPELL_AURA_APPLIED", "StunnedByGreenOoze", 70447, 72836, 72837, 72838)
	self:Log("SPELL_CAST_START", "Experiment", 70351, 71966)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Plague", 72451)
	self:Log("SPELL_CAST_SUCCESS", "GasBomb", 71255)
	self:Log("SPELL_CAST_SUCCESS", "BouncingGooBall", 72295, 72615, 72296)

	self:RegisterEvent("UNIT_HEALTH")

	self:Death("RedOozeDeath", 37562)
	self:Death("Win", 36678)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])
	self:Yell("Phase2", L["phase2_trigger"])
	self:Yell("Phase3", L["phase3_trigger"])
end

function mod:OnEngage()
	self:Berserk(600)
	p2, p3 = nil, nil
	self:Bar(70351, L["experiment_bar"], 25, 70351)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Plague(player, spellId, _, _, _, stack)
	if stack > 1 then
		self:TargetMessage(72451, L["plague_message"], player, "Urgent", spellId, "Info", stack)
		self:Bar(72451, L["plague_bar"], 10, spellId)
	end
end

function mod:Phase2()
	self:Message("phase", L["phase2_message"], "Attention")
	self:Bar(70351, L["experiment_bar"], 25, 70351)
	self:Bar(71255, L["gasbomb_bar"], 20, 71255)
	self:Bar(72295, L["ball_bar"], 9, 72295)
end

function mod:Phase3()
	self:Message("phase", L["phase3_message"], "Attention")
	self:SendMessage("BigWigs_StopBar", self, L["experiment_bar"])
	self:Bar(71255, L["gasbomb_bar"], 35, 71255)
	self:Bar(72295, L["ball_bar"], 9, 72295)
end

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

function mod:Experiment(_, spellId, _, _, spellName)
	self:Message(70351, spellName, "Important", spellId, "Alert")
	self:Bar(70351, L["experiment_bar"], 38, spellId)
end

function mod:GasBomb(_, spellId, _, _, spellName)
	self:Message(71255, spellName, "Attention", spellId)
	self:Bar(71255, L["gasbomb_bar"], 35, spellId)
end

do
	local id, name, handle = nil, nil, nil
	local function scanTarget()
		local bossId = mod:GetUnitIdByGUID(32906)
		if not bossId then return end
		local target = UnitName(bossId .. "target")
		if target then
			if target == pName then
				mod:FlashShake(72295)
				if bit.band(mod.db.profile[(GetSpellInfo(72295))], BigWigs.C.SAY) == BigWigs.C.SAY then
					SendChatMessage(L["ball_say"], "SAY")
				end
			end
			mod:TargetMessage(72295, L["ball_message"], player, "Attention", spellId)
			mod:SecondaryIcon(72295, target)
		end
		handle = nil
	end

	function mod:BouncingGooBall(_, spellId, _, _, spellName)
		id, name = spellId, spellName
		self:CancelTimer(handle, true)
		handle = self:ScheduleTimer(scanTarget, 0.1)
		self:Bar(72295, L["ball_bar"], 25, spellId)
	end
end

