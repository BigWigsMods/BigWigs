--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Valiona and Theralion", "The Bastion of Twilight")
if not mod then return end
mod:RegisterEnableMob(45992, 45993)
mod.toggleOptions = {{86788, "ICON", "FLASHSHAKE", "WHISPER"}, {88518, "FLASHSHAKE"}, 86059, 86840, {86622, "FLASHSHAKE", "WHISPER"}, 86408, 93051, "proximity", "phase_switch", "bosskill"}
mod.optionHeaders = {
	[86788] = "Valiona",
	[86622] = "Theralion",
	[93051] = "heroic",
	proximity = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local phaseCount = 0
local marked, blackout, deepBreath = GetSpellInfo(88518), GetSpellInfo(86788), GetSpellInfo(86059)
local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local theralion, valiona = BigWigs:Translate("Theralion"), BigWigs:Translate("Valiona")
local emTargets = mod:NewTargetList()
local markWarned = false

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

	L.engulfingmagic_say = "Engulf on ME!"
	L.engulfingmagic_cooldown = "~Engulfing Magic"

	L.devouringflames_cooldown = "~Devouring Flames"

	L.valiona_trigger = "Theralion, I will engulf the hallway. Cover their escape!"

	L.twilight_shift = "%2$dx shift on %1$s"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

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

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:RegisterEvent("UNIT_AURA")

	self:Death("Win", 45992) -- They Share HP, they die at the same time
end

function mod:OnEngage(diff)
	markWarned = false
	self:Bar(86840, L["devouringflames_cooldown"], 25, 86840)
	self:Bar(86788, blackout, 11, 86788)
	self:Bar("phase_switch", L["phase_bar"]:format(theralion), 105, 60639)
	self:OpenProximity(8)
	phaseCount = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

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
		self:SendMessage("BigWigs_StopBar", self, blackout)
		self:SendMessage("BigWigs_StopBar", self, L["devouringflames_cooldown"])
		-- XXX Phase timer is probably inaccurate
		self:Bar("phase_switch", L["phase_bar"]:format(valiona), 135, 60639)
		self:Message("phase_switch", L["phase_bar"]:format(theralion), "Positive", 60639)
		phaseCount = 0
	end
end

-- She emotes 3 times, every time she does a breath
function mod:DeepBreathCast()
	phaseCount = phaseCount + 1
	self:Message(86059, L["breath_message"], "Important", 92194, "Alarm")
	if phaseCount == 3 then
		-- XXX Probably inaccurate
		self:Bar("phase_switch", L["phase_bar"]:format(theralion), 105, 60639)
		phaseCount = 0
	end
end

-- Valiona does this when she fires the first deep breath and begins the landing phase
-- It only triggers once from her yell, not 3 times.
function mod:DeepBreath()
	-- XXX Not sure exactly how long it takes Valiona to land after the yell
	-- XXX Most certainly inaccurate, need to confirm next raid.

	-- XXX Should this be a "Deep Breaths incoming" bar instead?
	-- XXX Like it is now, it just readjusts the phase change bar.
	self:Bar("phase_switch", L["phase_bar"]:format(valiona), 40, 60639)

	self:DelayedMessage("phase_switch", 40, L["phase_bar"]:format(valiona), "Positive", 60639)
	--self:SendMessage("BigWigs_StopBar", self, L["engulfingmagic_cooldown"]) --XXX check this, as far as I'm aware, he no longer casts it after DB

	-- XXX Need to confirm these as well.
	self:Bar(86840, L["devouringflames_cooldown"], 66, 86840)
	self:Bar(86788, blackout, 51, 86788)
end

function mod:BlackoutApplied(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:FlashShake(86788)
	end
	self:TargetMessage(86788, spellName, player, "Personal", spellId, "Alert")
	self:Whisper(86788, player, spellName)
	self:PrimaryIcon(86788, player)
	self:Bar(86788, spellName, 45, 86788)
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
	if unit == "player" then
		if UnitDebuff("player", marked) and not markWarned then
			self:FlashShake(88518)
			self:LocalMessage(88518, CL["you"]:format(marked), "Personal", 88518, "Long")
			markWarned = true
			self:ScheduleTimer(markRemoved, 7)
		end
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
		self:OpenProximity(8)
	end
end

