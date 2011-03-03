--------------------------------------------------------------------------------
-- Module Declaration
--

-- XXX This module needs a code review
local mod = BigWigs:NewBoss("Sinestra", "The Bastion of Twilight")
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

	L.slicer = "Possible Orb targets:"

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
local handle = nil
local orbList = mod:NewTargetList()
local orbWarned = nil
local whelpGUIDs = {}

-- XXX Local functions always start with a lowercased letter, so these should be
-- XXX isTank, isTargetableByOrb, populateOrbList, orbWarning and orbSpawn.
-- Although I think some of the functions could have better names.

local function IsTank(unit)
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

local function IsTargetableByOrb(unit)
	-- check tanks
	if IsTank(unit) then return false end
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

local function PopulateOrbList()
	wipe(orbList)
	for i = 1, GetNumRaidMembers() do
		-- do some checks for 25/10 man raid size so we don't warn for ppl who are not in the instance
		if GetInstanceDifficulty() == 3 and i > 10 then return end
		if GetInstanceDifficulty() == 4 and i > 25 then return end
		-- XXX Someone should test whether or not GetPartyAssignment and UnitGroupRolesAssigned
		-- XXX work on player names or not. If it does, we should use that directly.
		local unit = ("raid%d"):format(i)
		-- Tanking something, but not a tank (aka not tanking Sinestra or Whelps)
		if UnitThreatSituation(unit) == 3 and IsTargetableByOrb(unit) then
			orbList[#orbList + 1] = UnitName(unit)
		end
	end
end

local function wipeWhelpList(resetWarning)
	if resetWarning then orbWarned = nil end
	wipe(whelpGUIDs)
end

local function OrbWarning(source)
	for i, v in next, orbList do
		-- XXX We should just have a isPlayerInList boolean that we set in PopulateOrbList
		if v:find(UnitName("player")) then
			mod:FlashShake(92954)
		end
	end

	-- decolorize
	-- XXX What an awful hack. I'd rather we just use :Message instead of :TargetMessage
	-- XXX and colorize the names ourselves before firing it off.
	-- XXX :TargetMessage is a convenience method, not the only solution.
	if orbList[1] then mod:PrimaryIcon(92954, orbList[1]:sub(11,-3)) end
	if orbList[2] then mod:SecondaryIcon(92954, orbList[2]:sub(11,-3)) end

	if source == "spawn" then
		-- here #orbList can be 0 since we have no accurate way of timing this warning
		-- XXX if #orbList > 0 then ? Why else would you have such a comment above?
		if orbList then
			mod:TargetMessage(92954, L["slicer"], orbList, "Personal", 92954, "Alarm")
			-- if we could guess orb targets lets wipe the whelpGUIDs in 5 sec
			-- if not then we might as well just save them for next time
			mod:ScheduleTimer(wipeWhelpList, 5) -- might need to adjust this
		else
			mod:Message(92954, slicer, "Personal", 92954)
		end
	elseif source == "damage" then
		mod:TargetMessage(92954, L["slicer"], orbList, "Personal", 92954, "Alarm")
		mod:ScheduleTimer(wipeWhelpList, 10, true) -- might need to adjust this
	end
end

local function OrbSpawn()
	-- can't think of a better way to do it
	-- XXX do what?
	mod:Bar(92954, "~"..slicer, 30, 92954)
	PopulateOrbList()
	OrbWarning("spawn")
	handle = mod:ScheduleTimer(OrbSpawn, 30)
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
	if not roleCheckWarned then
		-- XXX What if tanks have already been set? Should we print this still?
		print("|cffff0000It is recommended that you set roles (tanks) and Blizzard Main Tanks for this encounter to improve the orb target detections.|r")
		roleCheckWarned = true
	end

	self:Log("SPELL_DAMAGE", "OrbDamage", 92954, 92959) -- twilight slicer, twlight pulse 25 man heroic spellIds
	self:Log("SWING_DAMAGE", "WhelpWatcher", "*")
	self:Log("SWING_MISS", "WhelpWatcher", "*")

	self:Log("SPELL_CAST_START", "Breath", 92944)

	self:Log("SPELL_AURA_REMOVED", "Egg", 87654)
	self:Log("SPELL_AURA_APPLIED", "Indomitable", 92946)
	self:Log("SPELL_CAST_START", "Extinction", 86227)

	self:Yell("EggTrigger", L["omelet_trigger"])
	self:Yell("Whelps", L["whelps_trigger"])

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Deaths", 45213, 46842) -- Sinestra, Pulsing Twilight Egg
end

function mod:OnEngage()
	self:Bar(92944, "~"..breath, 24, 92944)
	self:Bar(92954, "~"..slicer, 30, 92954)
	self:Bar("whelps", L["whelps"], 16, 69005) -- whelp like icon
	self:ScheduleTimer(OrbSpawn, 30)
	eggs = 0
	handle = nil -- XXX Why do we need to save the handle? Can't we just do :CancelAllTimers() at phase change?
	self:RegisterEvent("UNIT_HEALTH")
	whelpGUIDs = {} -- XXX Table is already initialized at declaration, can't we just wipe() it here?
	orbWarned = nil
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
	PopulateOrbList()
	if orbWarned then return end
	orbWarned = true
	OrbWarning("damage")
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
			self:Bar("whelps", L["whelps"], 50, 69005)
			self:Bar(92954, "~"..slicer, 30, 92954)
			self:Bar(92944, "~"..breath, 24, 92944)
			self:ScheduleTimer(OrbSpawn, 30)
		end
	elseif mobId == 45213 then
		self:Win()
	end
end
