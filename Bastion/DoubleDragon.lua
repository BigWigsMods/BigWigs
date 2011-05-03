--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Valiona and Theralion", 758)
if not mod then return end
mod:RegisterEnableMob(45992, 45993)

--------------------------------------------------------------------------------
-- Locals
--

local phaseCount = 0
local marked, blackout, deepBreath = GetSpellInfo(88518), GetSpellInfo(86788), GetSpellInfo(86059)
local theralion, valiona = BigWigs:Translate("Theralion"), BigWigs:Translate("Valiona")
local emTargets = mod:NewTargetList()
local markWarned = false
local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phase_switch = "Phase Switch"
	L.phase_switch_desc = "Warning for phase switches."

	L.phase_bar = "%s landing"
	L.breath_message = "Deep Breaths incoming!"
	L.dazzling_message = "Swirly zones incoming!"

	L.blast_message = "Falling Blast" --Sounds better and makes more sense than Twilight Blast (the user instantly knows something is coming from the sky at them)
	L.engulfingmagic_say = "Engulf on ME!"
	L.engulfingmagic_cooldown = "~Engulfing Magic"

	L.devouringflames_cooldown = "~Devouring Flames"

	L.valiona_trigger = "Theralion, I will engulf the hallway. Cover their escape!"
	L.win_trigger = "At least... Theralion dies with me..."

	L.twilight_shift = "%2$dx shift on %1$s"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{86788, "ICON", "FLASHSHAKE", "WHISPER"}, {88518, "FLASHSHAKE"}, 86059, 86840,
		{86622, "FLASHSHAKE", "SAY", "WHISPER"}, 86408, 92898, 93051,
		"proximity", "phase_switch", "berserk", "bosskill"
	}, {
		[86788] = "Valiona",
		[86622] = "Theralion",
		[93051] = "heroic",
		proximity = "general",
	}
end

function mod:OnBossEnable()
	-- Heroic
	self:Log("SPELL_AURA_APPLIED_DOSE", "TwilightShift", 93051)

	-- Phase Switch -- should be able to do this easier once we get Transcriptor logs
	self:Log("SPELL_CAST_START", "DazzlingDestruction", 86408)
	self:Yell("DeepBreath", L["valiona_trigger"])
	self:Emote("DeepBreathCast", deepBreath)

	self:Log("SPELL_AURA_APPLIED", "BlackoutApplied", 86788, 92877, 92876, 92878)
	self:Log("SPELL_AURA_REMOVED", "BlackoutRemoved", 86788, 92877, 92876, 92878)
	self:Log("SPELL_CAST_START", "DevouringFlames", 86840)

	self:Log("SPELL_AURA_APPLIED", "EngulfingMagicApplied", 86622, 95640, 95639, 95641)
	self:Log("SPELL_AURA_REMOVED", "EngulfingMagicRemoved", 86622, 95640, 95639, 95641)

	self:Log("SPELL_CAST_START", "TwilightBlast", 86369, 95416, 92898, 92899, 92900)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:RegisterEvent("UNIT_AURA")

	self:Death("Deaths", 45992, 45993)
end

function mod:OnEngage(diff)
	markWarned = false
	self:Bar(86840, L["devouringflames_cooldown"], 25, 86840)
	self:Bar(86788, blackout, 11, 86788)
	self:Bar("phase_switch", L["phase_bar"]:format(theralion), 103, 60639)
	self:OpenProximity(8)
	self:Berserk(600)
	phaseCount = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local function checkTarget(sGUID)
		local bossId = UnitGUID("boss2") == sGUID and "boss2target" or "boss1target"
		if not UnitName(bossId) then return end --The first is sometimes delayed longer than 0.3
		if UnitIsUnit(bossId, "player") then
			mod:LocalMessage(92898, CL["you"]:format(L["blast_message"]), "Personal", 92898, "Long")
		end
	end
	function mod:TwilightBlast(...)
		local sGUID = select(11, ...)
		self:ScheduleTimer(checkTarget, 0.3, sGUID)
	end
end

local function valionaHasLanded()
	mod:SendMessage("BigWigs_StopBar", mod, L["engulfingmagic_cooldown"])
	mod:Message("phase_switch", L["phase_bar"]:format(valiona), "Positive", 60639)
	mod:Bar(86840, L["devouringflames_cooldown"], 26, 86840)
	mod:Bar(86788, blackout, 11, 86788)
	mod:OpenProximity(8)
end

local function theralionHasLanded()
	mod:SendMessage("BigWigs_StopBar", mod, blackout)
	mod:SendMessage("BigWigs_StopBar", mod, L["devouringflames_cooldown"])
	mod:Bar("phase_switch", L["phase_bar"]:format(valiona), 130, 60639)
	mod:CloseProximity()
end

function mod:TwilightShift(player, spellId, _, _, spellName, stack)
	self:Bar(93051, spellName, 20, 93051)
	if stack > 3 then
		self:TargetMessage(93051, L["twilight_shift"], player, "Important", spellId, nil, stack)
	end
end

-- When Theralion is landing he casts DD 3 times, with a 5 second interval.
function mod:DazzlingDestruction()
	phaseCount = phaseCount + 1
	if phaseCount == 1 then
		self:Message(86408, L["dazzling_message"], "Important", 86408, "Alarm")
	elseif phaseCount == 3 then
		self:ScheduleTimer(theralionHasLanded, 5)
		self:Message("phase_switch", L["phase_bar"]:format(theralion), "Positive", 60639)
		phaseCount = 0
	end
end

-- She emotes 3 times, every time she does a breath
function mod:DeepBreathCast()
	phaseCount = phaseCount + 1
	self:Message(86059, L["breath_message"], "Important", 92194, "Alarm")
	if phaseCount == 3 then
		self:Bar("phase_switch", L["phase_bar"]:format(theralion), 105, 60639)
		phaseCount = 0
	end
end

-- Valiona does this when she fires the first deep breath and begins the landing phase
-- It only triggers once from her yell, not 3 times.
function mod:DeepBreath()
	self:Bar("phase_switch", L["phase_bar"]:format(valiona), 40, 60639)
	self:ScheduleTimer(valionaHasLanded, 40)
end

function mod:BlackoutApplied(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:FlashShake(86788)
	else
		self:PlaySound(86788, "Alert")
	end
	self:TargetMessage(86788, spellName, player, "Personal", spellId, "Alert")
	self:Bar(86788, spellName, 45, spellId)
	self:Whisper(86788, player, spellName)
	self:PrimaryIcon(86788, player)
	self:CloseProximity()
end

function mod:BlackoutRemoved(player, spellId, _, _, spellName)
	self:OpenProximity(8)
	self:Bar(86788, spellName, 40, spellId) -- make sure to remove bar when it takes off
end

local function markRemoved()
	markWarned = false
end

function mod:UNIT_AURA(event, unit)
	if unit == "player" and not markWarned and UnitDebuff("player", marked) then
		self:FlashShake(88518)
		self:LocalMessage(88518, CL["you"]:format(marked), "Personal", 88518, "Long")
		markWarned = true
		self:ScheduleTimer(markRemoved, 7)
	end
end

function mod:DevouringFlames(_, spellId, _, _, spellName)
	self:Bar(86840, L["devouringflames_cooldown"], 42, spellId) -- make sure to remove bar when it takes off
	self:Message(86840, spellName, "Important", spellId, "Alert")
end

do
	local scheduled = nil
	local function emWarn(spellName)
		mod:TargetMessage(86622, spellName, emTargets, "Personal", 86622, "Alarm")
		mod:Bar(86622, L["engulfingmagic_cooldown"], 37, 86622)
		scheduled = nil
	end
	function mod:EngulfingMagicApplied(player, spellId, _, _, spellName)
		if UnitIsUnit(player, "player") then
			self:Say(86622, L["engulfingmagic_say"])
			self:FlashShake(86622)
			self:OpenProximity(10)
		end
		emTargets[#emTargets + 1] = player
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(emWarn, 0.3, spellName)
		end
		self:Whisper(86622, player, spellName)
	end
end

function mod:EngulfingMagicRemoved(player)
	if UnitIsUnit(player, "player") then
		self:CloseProximity()
	end
end

do
	local count = 0
	function mod:Deaths()
		--Prevent the module from re-enabling in the second or so after 1 boss dies
		count = count + 1
		if count == 2 then
			self:Win()
		end
	end
end

