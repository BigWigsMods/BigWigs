--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Professor Putricide", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36678)
mod.toggleOptions = {{70447, "ICON"}, {72455, "ICON", "WHISPER"}, 71966, 71255, {72295, "ICON", "SAY", "FLASHSHAKE"}, 72451, "phase", "berserk", "bosskill"}
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

local p2, p3, first = nil, nil, nil
local gooTargets = mod:NewTargetList()

--------------------------------------------------------------------------------
--  Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phase = "Phases"
	L.phase_desc = "Warn for phase changes."
	L.phase_warning = "Phase %d soon!"

	L.engage_trigger = "I think I've perfected a plague"

	L.ball_bar = "Next bouncing goo ball"
	L.ball_say = "Goo ball incoming!"

	L.experiment_message = "Ooze add incoming!"
	L.experiment_bar = "Next ooze"
	L.blight_message = "Red ooze"
	L.violation_message = "Green ooze"

	L.plague_message = "%2$dx plague on %1$s"
	L.plague_bar = "Next plague"

	L.gasbomb_bar = "More yellow gas bombs"
	L.gasbomb_message = "Yellow bombs!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "ChasedByRedOoze", 72455, 70672)
	self:Log("SPELL_AURA_APPLIED", "StunnedByGreenOoze", 70447, 72836, 72837, 72838)
	self:Log("SPELL_CAST_START", "Experiment", 70351, 71966)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Plague", 72451, 72463, 72464)
	self:Log("SPELL_CAST_SUCCESS", "GasBomb", 71255)
	self:Log("SPELL_CAST_SUCCESS", "BouncingGooBall", 72295, 72615, 72296)
	self:Log("SPELL_AURA_APPLIED", "TearGas", 71615)

	self:RegisterEvent("UNIT_HEALTH")

	self:Death("RedOozeDeath", 37562)
	self:Death("Win", 36678)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])
end

function mod:OnEngage()
	self:Berserk(600)
	p2, p3, first = nil, nil, nil
	self:Bar(70351, L["experiment_bar"], 25, 70351)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local stop = nil
	local function nextPhase()
		stop = nil
		if not first then
			mod:Message("phase", CL.phase:format(2), "Positive")
			mod:Bar(70351, L["experiment_bar"], 25, 70351)
			mod:Bar(71255, L["gasbomb_bar"], 20, 71255)
			mod:Bar(72295, L["ball_bar"], 9, 72295)
			first = true
		else
			mod:Message("phase", CL.phase:format(3), "Positive")
			mod:SendMessage("BigWigs_StopBar", mod, L["experiment_bar"])
			mod:Bar(71255, L["gasbomb_bar"], 35, 71255)
			mod:Bar(72295, L["ball_bar"], 9, 72295)
			first = nil
		end
	end
	function mod:TearGas(_, spellId, _, _, spellName)
		if stop then return end
		stop = true
		self:Bar("phase", spellName, 18, spellId)
		self:ScheduleTimer(nextPhase, 18)
	end
end

function mod:Plague(player, spellId, _, _, _, stack)
	if stack > 1 then
		self:TargetMessage(72451, L["plague_message"], player, "Urgent", spellId, "Info", stack)
		self:Bar(72451, L["plague_bar"], 10, spellId)
	end
end

function mod:UNIT_HEALTH(_, unit)
	if p2 and p3 then
		self:UnregisterEvent("UNIT_HEALTH")
		return
	end
	if UnitName(unit) == self.displayName then
		local hp = UnitHealth(unit) / UnitHealthMax(unit)
		if hp <= 0.83 and not p2 then
			self:Message("phase", L["phase_warning"]:format(2), "Positive")
			p2 = true
		elseif hp <= 0.37 and not p3 then
			self:Message("phase", L["phase_warning"]:format(3), "Positive")
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
	self:PrimaryIcon(70447, player)
end

function mod:Experiment(_, spellId)
	self:Message(70351, L["experiment_message"], "Important", spellId, "Alert")
	self:Bar(70351, L["experiment_bar"], 38, spellId)
end

function mod:GasBomb(_, spellId)
	self:Message(71255, L["gasbomb_message"], "Attention", spellId)
	self:Bar(71255, L["gasbomb_bar"], 35, spellId)
end

do
	local scheduled = nil
	local function scanTarget(spellName)
		scheduled = nil
		local bossId = mod:GetUnitIdByGUID(36678)
		if not bossId then return end
		local target = UnitName(bossId .. "target")
		if target then
			if UnitIsUnit(target, "player") then
				mod:FlashShake(72295)
				if bit.band(mod.db.profile[(GetSpellInfo(72295))], BigWigs.C.SAY) == BigWigs.C.SAY then
					SendChatMessage(L["ball_say"], "SAY")
				end
			end
			mod:TargetMessage(72295, spellName, target, "Attention", 72295)
			mod:SecondaryIcon(72295, target)
		end
	end
	function mod:BouncingGooBall(_, spellId, _, _, spellName)
		if not scheduled then
			self:ScheduleTimer(scanTarget, 0.2, spellName)
			self:Bar(72295, L["ball_bar"], 25, spellId)
		end
	end
end

