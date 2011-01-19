--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Al'Akir", "Throne of the Four Winds")
if not mod then return end
mod:RegisterEnableMob(46753)
local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")

--------------------------------------------------------------------------------
-- Locals
--

local phase = 1
local lastWindburst = 0
local windburst = GetSpellInfo(87770)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phase3_yell = "Enough! I will no longer be contained!"

	L.phase = "Phase change"
	L.phase_desc = "Announce phase changes."

	L.cloud_message = "Franklin would be proud!"
	L.feedback_message = "%dx Feedback"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
		87770,
		87904,
		{89668, "ICON", "FLASHSHAKE", "WHISPER"}, 89588, 93286, "proximity",
		88427, "phase", "bosskill"
	}, {
		[87770] = CL["phase"]:format(1),
		[87904] = CL["phase"]:format(2),
		[89668] = CL["phase"]:format(3),
		[88427] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Electrocute", 88427)
	self:Log("SPELL_CAST_START", "WindBurst1", 87770, 93261, 93263)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Feedback", 87904)
	self:Log("SPELL_AURA_APPLIED", "Feedback", 87904)
	-- Acid Rain is applied at P2 transition
	self:Log("SPELL_AURA_APPLIED", "Phase2", 88301, 93279)

	self:Yell("Phase3", L["phase3_yell"])

	self:Log("SPELL_AURA_APPLIED", "LightningRod", 89668)
	self:Log("SPELL_AURA_REMOVED", "RodRemoved", 89668)
	self:Log("SPELL_DAMAGE", "WindBurst3", 93286)
	self:Log("SPELL_DAMAGE", "Cloud", 89588, 93299, 93298, 93297)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Death("Win", 46753)
end

function mod:OnEngage(diff)
	self:Bar(87770, windburst, 22, 87770) -- this is a try to guess the Wind Burst cooldown at fight start
	phase = 1
	lastWindburst = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Cloud(player, spellId)
	if not UnitIsUnit(player, "player") then return end
	self:LocalMessage(89588, L["cloud_message"], "Urgent", spellId, "Alarm")
end

function mod:LightningRod(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:FlashShake(89668)
		self:OpenProximity(20)
	end
	self:TargetMessage(89668, spellName, player, "Personal", spellId, "Long")
	self:Whisper(89668, player, spellName)
	self:PrimaryIcon(89668, player)
end

function mod:RodRemoved(player)
	self:PrimaryIcon(89668) -- De-mark
	if UnitIsUnit(player, "player") then
		self:CloseProximity()
	end
end

function mod:Phase2(_, spellId)
	if phase >= 2 then return end
	self:Message("phase", CL["phase"]:format(2), "Positive", spellId, "Info")
	self:SendMessage("BigWigs_StopBar", self, windburst)
	phase = 2
end

function mod:Phase3()
	if phase >= 3 then return end
	self:Message("phase", CL["phase"]:format(3), "Positive", 93279)
	self:Bar(93286, windburst, 24, 93286)
	phase = 3
end

function mod:Feedback(_, spellId, _, _, spellName, stack)
	self:Bar(87904, spellName, 20, spellId)
	if not stack then stack = 1 end
	self:Message(87904, L["feedback_message"]:format(stack), "Positive", spellId, "Info")
end

function mod:Electrocute(player, spellId, _, _, spellName)
	self:TargetMessage(88427, spellName, player, "Personal", spellId)
end

function mod:WindBurst1(_, spellId, _, _, spellName)
	self:Bar(87770, spellName, 26, spellId)
	self:Message(87770, spellName, "Important", spellId, "Alert")
end

function mod:WindBurst3(_, spellId, _, _, spellName)
	if (GetTime() - lastWindburst) > 5 then
		self:Bar(93286, spellName, 19, spellId) -- 22 was too long, 19 should work
		self:Message(93286, spellName, "Attention", spellId)
	end
	lastWindburst = GetTime()
end

