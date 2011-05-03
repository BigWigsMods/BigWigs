--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Sinestra", 758)
if not mod then return end
mod:RegisterEnableMob(45213)

--------------------------------------------------------------------------------
-- Localization
--

local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local L = mod:NewLocale("enUS", true)
if L then
	L.whelps = "Whelps"
	L.whelps_desc = "Warning for the whelp waves."

	L.slicer_message = "Possible Orb targets"

	L.egg_vulnerable = "Omelet time!"

	L.whelps_trigger = "Feed, children!  Take your fill from their meaty husks!"
	L.omelet_trigger = "You mistake this for weakness?  Fool!"

	L.phase13 = "Phase 1 and 3"
	L.phase = "Phase"
	L.phase_desc = "Warning for phase changes."
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Locals
--

local breath, slicer = (GetSpellInfo(92944)), (GetSpellInfo(92954))
local roleCheckWarned = nil
local eggs = 0
local orbList = {}
local orbWarned = nil
local playerInList = nil
local whelpGUIDs = {}

local function isTank(unit)
	-- 1. check blizzard tanks first
	-- 2. check blizzard roles second
	if GetPartyAssignment("MAINTANK", unit, 1) then
		return true
	end
	if UnitGroupRolesAssigned(unit) == "TANK" then
		return true
	end
	return false
end

local function isTargetableByOrb(unit)
	-- check tanks
	if isTank(unit) then return false end
	-- check sinestra's target too
	if UnitIsUnit("boss1target", unit) then return false end
	-- and maybe do a check for whelp targets
	-- not 100% sure if whelp "tanks" can be targeted by the orb or not
	for k, v in pairs(whelpGUIDs) do
		local whelp = mod:GetUnitIdByGUID(k)
		if whelp then
			if UnitIsUnit(whelp.."target", unit) then return false end
		end
	end
	return true
end

local function populateOrbList()
	wipe(orbList)
	for i = 1, GetNumRaidMembers() do
		-- do some checks for 25/10 man raid size so we don't warn for ppl who are not in the instance
		if GetInstanceDifficulty() == 3 and i > 10 then return end
		if GetInstanceDifficulty() == 4 and i > 25 then return end
		local n = GetRaidRosterInfo(i)
		-- Tanking something, but not a tank (aka not tanking Sinestra or Whelps)
		if UnitThreatSituation(n) == 3 and isTargetableByOrb(n) then
			if UnitIsUnit(n, "player") then playerInList = true end
			orbList[#orbList + 1] = n
		end
	end
end

local function wipeWhelpList(resetWarning)
	if resetWarning then orbWarned = nil end
	playerInList = nil
	wipe(whelpGUIDs)
end

local hexColors = {}
for k, v in pairs(RAID_CLASS_COLORS) do
	hexColors[k] = "|cff" .. string.format("%02x%02x%02x", v.r * 255, v.g * 255, v.b * 255)
end

local function colorize(tbl)
	for i, v in next, tbl do
		local class = select(2, UnitClass(v))
		if class then
			tbl[i] = hexColors[class]  .. v .. "|r"
		end
	end
	return tbl
end

local function orbWarning(source)
	if playerInList then mod:FlashShake(92954) end

	if orbList[1] then mod:PrimaryIcon(92954, orbList[1]) end
	if orbList[2] then mod:SecondaryIcon(92954, orbList[2]) end

	if source == "spawn" then
		if #orbList > 0 then
			mod:TargetMessage(92954, L["slicer_message"], colorize(orbList), "Personal", 92954, "Alarm")
			-- if we could guess orb targets lets wipe the whelpGUIDs in 5 sec
			-- if not then we might as well just save them for next time
			mod:ScheduleTimer(wipeWhelpList, 5) -- might need to adjust this
		else
			mod:Message(92954, slicer, "Personal", 92954)
		end
	elseif source == "damage" then
		mod:TargetMessage(92954, L["slicer_message"], colorize(orbList), "Personal", 92954, "Alarm")
		mod:ScheduleTimer(wipeWhelpList, 10, true) -- might need to adjust this
	end
end

-- this gets run every 30 sec
-- need to change it once there is a proper trigger for orbs
local function nextOrbSpawned()
	mod:Bar(92954, "~"..slicer, 28, 92954)
	populateOrbList()
	orbWarning("spawn")
	mod:ScheduleTimer(nextOrbSpawned, 28)
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
	-- Phase 1 and 3
		92944, -- Breath
		{92954, "FLASHSHAKE", "ICON"}, -- Twilight Slicer
		86227, -- Extinction
		"whelps",

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
	if not roleCheckWarned and (IsRaidLeader() or IsRaidOfficer()) then
		BigWigs:Print("It is recommended that your raid has proper main tanks set for this encounter to improve orb target detection.")
		roleCheckWarned = true
	end

	self:Log("SPELL_DAMAGE", "OrbDamage", 92954, 92959) -- twilight slicer, twlight pulse 25 man heroic spellIds
	self:Log("SWING_DAMAGE", "WhelpWatcher", "*")
	self:Log("SWING_MISS", "WhelpWatcher", "*")

	self:Log("SPELL_CAST_START", "Breath", 90125, 92944)

	self:Log("SPELL_AURA_REMOVED", "Egg", 87654)
	self:Log("SPELL_AURA_APPLIED", "Indomitable", 90045, 92946)
	self:Log("SPELL_CAST_START", "Extinction", 86227)

	self:Yell("EggTrigger", L["omelet_trigger"])
	self:Yell("Whelps", L["whelps_trigger"])

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Deaths", 45213, 46842) -- Sinestra, Pulsing Twilight Egg
end

function mod:OnEngage()
	self:Bar(92944, "~"..breath, 24, 92944)
	self:Bar(92954, "~"..slicer, 29, 92954)
	self:Bar("whelps", L["whelps"], 16, 69005) -- whelp like icon
	self:ScheduleTimer(nextOrbSpawned, 29)
	eggs = 0
	self:RegisterEvent("UNIT_HEALTH")
	wipe(whelpGUIDs)
	orbWarned = nil
	playerInList = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local whelpIds = {
		47265,
		48047,
		48048,
		48049,
		48050,
	}
	function mod:WhelpWatcher(...)
		local sGUID = select(11, ...)
		local mobId = tonumber(sGUID:sub(7, 10), 16)
		for i, v in next, whelpIds do
			if mobId == v then whelpGUIDs[sGUID] = true end
		end
	end
end

function mod:OrbDamage()
	populateOrbList()
	if orbWarned then return end
	orbWarned = true
	orbWarning("damage")
end

function mod:Whelps()
	self:Bar("whelps", L["whelps"], 50, 69005)
	self:Message("whelps", L["whelps"], "Important", 69005)
end

function mod:Extinction(_, spellId, _, _, spellName)
	self:Bar(86227, spellName, 15, spellId)
end

do
	local scheduled = nil
	local function EggMessage(spellId)
		mod:Message(87654, L["egg_vulnerable"], "Important", spellId, "Alert")
		mod:Bar(87654, L["egg_vulnerable"], 30, 87654)
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
		self:PlaySound(92946, "Info")
		self:FlashShake(92946)
	end
end

function mod:UNIT_HEALTH()
	local hp = UnitHealth("boss1") / UnitHealthMax("boss1") * 100
	if hp <= 30.5 then
		self:Message("phase", CL["phase"]:format(2), "Positive", 86226, "Info")
		self:UnregisterEvent("UNIT_HEALTH")
		self:CancelAllTimers()
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
			self:Bar("whelps", L["whelps"], 50, 69005)
			self:Bar(92954, "~"..slicer, 30, 92954)
			self:Bar(92944, "~"..breath, 24, 92944)
			self:ScheduleTimer(nextOrbSpawned, 30)
		end
	elseif mobId == 45213 then
		self:Win()
	end
end

