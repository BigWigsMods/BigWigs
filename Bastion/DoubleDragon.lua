--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Valiona and Theralion", "The Bastion of Twilight")
if not mod then return end
mod:RegisterEnableMob(45992, 45993)
mod.toggleOptions = {93051, {86788, "ICON", "FLASHSHAKE", "WHISPER"}, {88518, "FLASHSHAKE"}, 86059, 86840, {86622, "ICON", "FLASHSHAKE", "WHISPER"}, "proximity", "phase_switch", "bosskill"}
mod.optionHeaders = {
	[93051] = "heroic",
	[86788] = "Valiona",
	[86622] = "Theralion",
	proximity = "general",
}

--------------------------------------------------------------------------------
-- Locals
--

local marked, blackout, deepBreath = GetSpellInfo(88518), GetSpellInfo(86788), GetSpellInfo(86059)
local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local theralion, valiona = BigWigs:Translate("Theralion"), BigWigs:Translate("Valiona")
local markWarned = false
local count = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phase_switch = "Phase Switch"
	L.phase_switch_desc = "Warning for Phase Switches"

	L.phase_bar = "%s landing"

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
	self:Bar("phase_switch", L["phase_bar"]:format(theralion), 95, 60639)
	self:OpenProximity(8)
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

do
	local lastDestruction = 0
	function mod:DazzlingDestruction()
		local time = GetTime()
		if (time - lastDestruction) > 6 then
			self:SendMessage("BigWigs_StopBar", self, blackout)
			self:SendMessage("BigWigs_StopBar", self, L["devouringflames_cooldown"])
			self:Bar("phase_switch", L["phase_bar"]:format(valiona), 113, 60639)
		end
		lastDestruction = time
		count = 0
		self:Bar(86059, deepBreath, 110, 92194) -- looks like a dragon 'deep breath' :)
	end
end

function mod:DeepBreath()
	self:Message(86059, deepBreath, "Important", 92194, "Alert")
	self:Bar("phase_switch", L["phase_bar"]:format(valiona), 137, 60639)
	self:Bar(86788, deepBreath, 60, 86788) -- probably inaccurate
	self:Bar(86840, L["devouringflames_cooldown"], 75, 86840) -- probably inaccurate
end

function mod:BlackoutApplied(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:FlashShake(86788)
	end
	self:TargetMessage(86788, spellName, player, "Personal", spellId, "Alarm")
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
			self:LocalMessage(88518, CL["you"]:format(marked), "Personal", 88518, "Alarm")
			markWarned = true
			self:ScheduleTimer(markRemoved, 7)
		end
	end
end

function mod:DevouringFlames(_, spellId, _, _, spellName)
	self:Bar(86840, L["devouringflames_cooldown"], 42, spellId) -- make sure to remove bar when it takes off
	self:Message(86840, spellName, "Important", spellId, "Alert")
end

function mod:EngulfingMagicApplied(player, spellId, _, _, spellName)
	if UnitIsUnit(player, "player") then
		self:Say(86622, L["engulfingmagic_say"])
		self:FlashShake(86622)
		self:CloseProximity()
		self:OpenProximity(10)
	end
	self:TargetMessage(86622, spellName, player, "Personal", spellId, "Alarm")
	self:Whisper(86622, player, spellName)
	self:PrimaryIcon(86622, player)
	count = count + 1
	if count < 4 then
		self:Bar(86622, L["engulfingmagic_cooldown"], 37, 86622)
	end
end

function mod:EngulfingMagicRemoved(player)
	if UnitIsUnit(player, "player") then
		self:CloseProximity()
		self:OpenProximity(8)
	end
end

