--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Sinestra", "The Bastion of Twilight")
if not mod then return end
mod:RegisterEnableMob(45213)
local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")

--------------------------------------------------------------------------------
-- Locals
--

local breath, slicer = (GetSpellInfo(92944)), (GetSpellInfo(92954))
local orbTimer = 28
local eggs = 0
local handle = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.egg_vulnerable = "Omelet time!"

	L.omelet_trigger = "You mistake this for weakness?  Fool!"

	L.phase13 = "Phase 1 and 3"
	L.phase = "Phase"
	L.phase_desc = "Warning for phase changes"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
	-- Phase 1 and 3
		92944, -- Breath
		92954, -- Twilight Slicer
		86227, -- Extinction

	-- Phase 2
		87654, -- Omelet Time
		{92946, "FLASHSHAKE"}, -- Indomitable

	-- General
		"phase",
		"bosskill",
	}, {
		[92944] = L["phase13"],
		[87654] = CL["phase"]:format(2),
		phase = "general",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Breath", 92944)

	self:Log("SPELL_AURA_REMOVED", "Egg", 87654)
	self:Log("SPELL_AURA_APPLIED", "Indomitable", 92946)
	self:Log("SPELL_CAST_START", "Extinction", 86227)

	self:Yell("EggTrigger", L["omelet_trigger"])

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Deaths", 45213, 46842) -- Sinestra, Pulsing Twilight Egg
end

local function orbSpawn() -- can't think of a better way to do it
	mod:Message(92954, slicer, "Personal", 92954)
	mod:Bar(92954, "~"..slicer, orbTimer, 92954)
	handle = mod:ScheduleTimer(orbSpawn, orbTimer)
end

function mod:OnEngage()
	self:Bar(92944, "~"..breath, 24, 92944)
	self:Bar(92954, "~"..slicer, orbTimer, 92954)
	self:ScheduleTimer(orbSpawn, orbTimer)
	orbTimer = 30
	eggs = 0
	handle = nil
	self:RegisterEvent("UNIT_HEALTH")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Extinction(_, spellId, _, _, spellName)
	self:Bar(86227, spellName, 15, spellId)
end

do
	local scheduled = nil
	local function EggMessage(spellId)
		mod:Message(87654, L["egg_vulnerable"], "Important", spellId, "Alert")
		scheduled = nil
	end
	function mod:Egg(_, spellId)
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(EggMessage, 0.1, spellId)
		end
	end
end

function mod:EggTrigger()
	self:Bar(87654, L["egg_vulnerable"], 5, 87654)
end

function mod:Indomitable(player, spellId, _, _, spellName)
	self:Message(92946, spellName, "Urgent", spellId)
	local _, class = UnitClass("player")
	if class == "HUNTER" or class == "ROGUE" then
		self:FlashShake(92946)
	end
end

function mod:UNIT_HEALTH()
	local hp = UnitHealth("boss1") / UnitHealthMax("boss1") * 100
	if hp <= 30.5 then
		self:Message("phase", CL["phase"]:format(2), "Positive", 86226, "Info")
		self:UnregisterEvent("UNIT_HEALTH")
		self:CancelTimer(handle)
		self:SendMessage("BigWigs_StopBar", self, "~"..slicer)
		self:SendMessage("BigWigs_StopBar", self, "~"..breath)
	end
end

function mod:Breath(_, spellId, _, _, spellName)
	self:Bar(92944, "~"..spellName, 24, spellId)
	self:Message(92944, spellName, "Urgent", spellId)
end

function mod:Deaths(mobId)
	if mobId == 46842 then
		eggs = eggs + 1
		if eggs == 2 then
			self:Message("phase", CL["phase"]:format(3), "Positive", 51070, "Info") -- broken egg icon
			self:Bar(92954, "~"..slicer, orbTimer, 92954)
			self:Bar(92944, "~"..breath, 24, 92944)
			self:ScheduleTimer(orbSpawn, orbTimer)
		end
	elseif mobId == 45213 then
		self:Win()
	end
end
