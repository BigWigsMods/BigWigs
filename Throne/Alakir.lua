--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Al'Akir", 773)
if not mod then return end
mod:RegisterEnableMob(46753)

--------------------------------------------------------------------------------
-- Locals
--

local phase, lastWindburst = 1, 0
local cloud = GetSpellInfo(89588)
local windburst = GetSpellInfo(87770)
local shock = nil
local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local acidRainCounter, acidRainCounted = 1, nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.stormling = "Stormling adds"
	L.stormling_desc = "Summons Stormling."
	L.stormling_message = "Stormling incoming!"
	L.stormling_bar = "Next stormling"
	L.stormling_yell = "Storms! I summon you to my side!"

	L.acid_rain = "Acid Rain (%d)"

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
		"stormling",
		93279,
		{89668, "ICON", "FLASHSHAKE", "WHISPER"}, 89588, 93286, "proximity",
		93257,
		88427, "phase", "berserk", "bosskill"
	}, {
		[87770] = CL["phase"]:format(1),
		[87904] = CL["phase"]:format(2),
		[89668] = CL["phase"]:format(3),
		[93257] = "heroic",
		[88427] = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "Electrocute", 88427)
	self:Log("SPELL_CAST_START", "WindBurst1", 87770, 93261, 93262, 93263)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Feedback", 87904)
	self:Log("SPELL_AURA_APPLIED", "Feedback", 87904)
	self:Log("SPELL_AURA_APPLIED_DOSE", "AcidRain", 88301, 93279, 93280, 93281)
	self:Log("SPELL_DAMAGE", "Shock", 93257)
	-- Acid Rain is applied at P2 transition
	self:Log("SPELL_AURA_APPLIED", "Phase2", 88301, 93279, 93280, 93281)

	self:Yell("Stormling", L["stormling_yell"])
	self:Yell("Phase3", L["phase3_yell"])

	self:Log("SPELL_AURA_APPLIED", "LightningRod", 89668)
	self:Log("SPELL_AURA_REMOVED", "RodRemoved", 89668)
	self:Log("SPELL_DAMAGE", "WindBurst3", 93286)
	self:Log("SPELL_DAMAGE", "Cloud", 89588, 93299, 93298, 93297)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Death("Win", 46753)
end

function mod:OnEngage(diff)
	self:Berserk(600)
	self:Bar(87770, windburst, 22, 87770) -- accurate?
	phase, lastWindburst = 1, 0
	acidRainCounter, acidRainCounted = 1, nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local function Shocker(spellName)
		if phase == 1 then
			mod:Bar(93257, spellName, 10, 93257)
			mod:ScheduleTimer(Shocker, 10, spellName)
		end
	end
	function mod:Shock(_, _, _, _, spellName)
		if not shock then
			--Do we need a looping timer here?
			Shocker(spellName)
			shock = true
		end
	end
end

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

local function CloudSpawn()
	mod:Bar(89588, cloud, 10, 89588)
	mod:Message(89588, cloud, "Important", 89588, "Info")
	mod:ScheduleTimer(CloudSpawn, 10)
end

function mod:Phase3()
	if phase >= 3 then return end
	self:Message("phase", CL["phase"]:format(3), "Positive", 93279)
	self:Bar(93286, windburst, 24, 93286)
	self:Bar(89588, cloud, 16, 89588)
	self:ScheduleTimer(CloudSpawn, 16)
	self:SendMessage("BigWigs_StopBar", self, L["stormling_bar"])
	self:SendMessage("BigWigs_StopBar", self, (GetSpellInfo(87904))) -- Feedback
	self:SendMessage("BigWigs_StopBar", self, L["acid_rain"]:format(acidRainCounter))
	phase = 3
end

function mod:Feedback(_, spellId, _, _, spellName, stack)
	if not stack then
		stack = 1
	else
		self:SendMessage("BigWigs_StopBar", self, L["feedback_message"]:format(stack-1))
	end
	self:Bar(87904, L["feedback_message"]:format(stack), 20, spellId)
	self:Message(87904, L["feedback_message"]:format(stack), "Positive", spellId)
end

do
	local function clearCount()
		acidRainCounted = nil
	end
	function mod:AcidRain(_, spellId)
		if acidRainCounted then return end
		acidRainCounter, acidRainCounted = acidRainCounter + 1, true
		self:ScheduleTimer(clearCount, 12) -- 15 - 3
		self:Bar(93279, L["acid_rain"]:format(acidRainCounter), 15, spellId) -- do we really want counter on bar too?
		self:Message(93279, L["acid_rain"]:format(acidRainCounter), "Attention", spellId)
	end
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

function mod:Stormling()
	self:Bar("stormling", L["stormling_bar"], 20, 75096)
	self:Message("stormling", L["stormling_message"], "Important", 75096)
end

