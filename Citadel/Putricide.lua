--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Professor Putricide", "Icecrown Citadel")
if not mod then return end
mod:RegisterEnableMob(36678)
mod.toggleOptions = {{70447, "ICON", "WHISPER"}, {72455, "ICON", "WHISPER"}, 71966, 72451, "phase", "berserk", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--

local p2, p3 = nil, nil
local phase = nil

--------------------------------------------------------------------------------
--  Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.phase = "Phases"
	L.phase_desc = "Warn for phase changes."
	L.phase2_trigger = "Hmm. I don't feel a thing. Whaa...? Where'd those come from?"
	L.phase3_trigger = "Tastes like... Cherry! Oh! Excuse me!"

	L.engage_trigger = "Good news, everyone!"

	L.add_message = "Ooze add incoming!"
	L.blight_message = "Red ooze"
	L.violation_message = "Green ooze"

	L.plague_message = "%2$dx plague on %1$s"

	L.phase2_warning = "Phase 2 soon!"
	L.phase3_warning = "Phase 3 soon!"
	
	L.gasbomb_bar = "Next Gas Bomb"
	
	L.goo_bar = "~Next Goo"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "ChasedByRedOoze", 72455)
	self:Log("SPELL_AURA_APPLIED", "StunnedByGreenOoze", 70447)
	self:Log("SPELL_CAST_START", "Experiment", 70351, 71966)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Plague", 72451)
	self:Log("SPELL_CAST_SUCCESS", "GasBomb", 71255)
	self:Log("SPELL_CAST_SUCCESS", "Goo", 72295)

	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:Death("RedOozeDeath", 37562)
	self:Death("Win", 36678)

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Yell("Engage", L["engage_trigger"])
end

function mod:OnEngage()
	self:Berserk(600)
	p2, p3 = nil, nil
	local phase = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Plague(player, spellId, _, _, spellName)
	local _, _, icon, stack = UnitDebuff(player, spellName)
	if stack and stack > 1 then
		self:TargetMessage(72451, L["plague_message"], player, "Urgent", icon, "Info", stack)
	end
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
	self:Message(71966, spellName, "Important", spellId)
	self:Bar(70351, L["experiment_bar"], 38, 70351)
end

function mod:GasBomb(_, spellId, _, _, spellName)
	self:Message(71255, spellName, "Attention", spellId)
	self:Bar(71255, L["gasbomb_bar"], 35, 71255)
end

function mod:Goo(_, spellId, _, _, spellName)
	self:Message(72295, spellName, "Urgent", spellId)
	self:Bar(72295, L["goo_bar"], 25, 72295)
end

function mod:CHAT_MSG_MONSTER_YELL(event, msg)
	if msg:find(L["phase2_trigger"]) then
		phase = 2
		self:Bar(70351, L["experiment_bar"], 25, 70351)
		self:Bar(71255, L["gasbomb_bar"], 20, 71255)
		self:Bar(72295, L["goo_bar"], 9, 72295)
	elseif msg:find(L["phase3_trigger"]) then
		phase = 3
		self:SendMessage("BigWigs_StopBar", self, L["experiment_bar"])
		self:Bar(71255, L["gasbomb_bar"], 35, 71255)
		self:Bar(72295, L["goo_bar"], 9, 72295)
	end
end
