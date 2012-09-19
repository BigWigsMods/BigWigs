--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sinestra", 758, 168)
if not mod then return end
mod:RegisterEnableMob(45213)

--------------------------------------------------------------------------------
-- Localization
--

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

local breath, slicer = (GetSpellInfo(90125)), (GetSpellInfo(92852))
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
	for i = 1, GetNumGroupMembers() do
		local n, _, g = GetRaidRosterInfo(i)
		-- do some checks for 25/10 man raid size so we don't warn for ppl who are not in the instance
		if (mod:Difficulty() == 5 and g < 3) or (mod:Difficulty() == 6 and g < 6) then
			-- Tanking something, but not a tank (aka not tanking Sinestra or Whelps)
			if UnitThreatSituation(n) == 3 and isTargetableByOrb(n) then
				if UnitIsUnit(n, "player") then playerInList = true end
				-- orbList is not created by :NewTargetList
				-- so we don't have to decolorize when we set icons,
				-- instead we colorize targets in the module
				orbList[#orbList + 1] = n
			end
		end
	end
end

local function wipeWhelpList(resetWarning)
	if resetWarning then orbWarned = nil end
	playerInList = nil
	wipe(whelpGUIDs)
end

-- since we don't use :NewTargetList we have to color the targets
local hexColors = {}
for k, v in pairs(CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS) do
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
	if playerInList then mod:FlashShake(92852) end

	-- this is why orbList can't be created by :NewTargetList
	if orbList[1] then mod:PrimaryIcon(92852, orbList[1]) end
	if orbList[2] then mod:SecondaryIcon(92852, orbList[2]) end

	if source == "spawn" then
		if #orbList > 0 then
			mod:TargetMessage(92852, L["slicer_message"], colorize(orbList), "Personal", 92852, "Alarm")
			-- if we could guess orb targets lets wipe the whelpGUIDs in 5 sec
			-- if not then we might as well just save them for next time
			mod:ScheduleTimer(wipeWhelpList, 5) -- might need to adjust this
		else
			mod:Message(92852, slicer, "Personal", 92852)
		end
	elseif source == "damage" then
		mod:TargetMessage(92852, L["slicer_message"], colorize(orbList), "Personal", 92852, "Alarm")
		mod:ScheduleTimer(wipeWhelpList, 10, true) -- might need to adjust this
	end
end

-- this gets run every 30 sec
-- need to change it once there is a proper trigger for orbs
local function nextOrbSpawned()
	mod:Bar(92852, "~"..slicer, 28, 92852)
	populateOrbList()
	orbWarning("spawn")
	mod:ScheduleTimer(nextOrbSpawned, 28)
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions(CL)
	return {
	-- Phase 1 and 3
		90125, -- Breath
		{92852, "FLASHSHAKE", "ICON"}, -- Twilight Slicer
		86227, -- Extinction
		"whelps",

	-- Phase 2
		87654, -- Omelet Time
		{90045, "FLASHSHAKE"}, -- Indomitable

	-- General
		"phase",
		"bosskill",
	}, {
		[90125] = L["phase13"],
		[87654] = CL["phase"]:format(2),
		phase = "general",
	}
end

function mod:OnBossEnable()
	if not roleCheckWarned and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
		BigWigs:Print("It is recommended that your raid has proper main tanks set for this encounter to improve orb target detection.")
		roleCheckWarned = true
	end

	self:Log("SPELL_DAMAGE", "OrbDamage", 92852, 92958) -- twilight slicer, twilight pulse [May be wrong since MoP id changes]
	self:Log("SWING_DAMAGE", "WhelpWatcher", "*")
	self:Log("SWING_MISS", "WhelpWatcher", "*")

	self:Log("SPELL_CAST_START", "Breath", 90125)

	self:Log("SPELL_AURA_REMOVED", "Egg", 87654)
	self:Log("SPELL_AURA_APPLIED", "Indomitable", 90045)
	self:Log("SPELL_CAST_START", "Extinction", 86227)

	self:Yell("EggTrigger", L["omelet_trigger"])
	self:Yell("Whelps", L["whelps_trigger"])

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Deaths", 45213, 46842) -- Sinestra, Pulsing Twilight Egg
end

function mod:OnEngage()
	self:Bar(90125, "~"..breath, 24, 90125)
	self:Bar(92852, "~"..slicer, 29, 92852)
	self:Bar("whelps", L["whelps"], 16, 69005) -- whelp like icon
	self:ScheduleTimer(nextOrbSpawned, 29)
	eggs = 0
	self:RegisterEvent("UNIT_HEALTH_FREQUENT")
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
	self:Message(90045, spellName, "Urgent", spellId)
	local _, class = UnitClass("player")
	if class == "HUNTER" or class == "ROGUE" then
		self:PlaySound(90045, "Info")
		self:FlashShake(90045)
	end
end

function mod:UNIT_HEALTH_FREQUENT(_, unit)
	if unit ~= "boss1" then return end
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp <= 30.5 then
		self:Message("phase", CL["phase"]:format(2), "Positive", 86226, "Info")
		self:UnregisterEvent("UNIT_HEALTH_FREQUENT")
		self:CancelAllTimers()
		self:SendMessage("BigWigs_StopBar", self, "~"..slicer)
		self:SendMessage("BigWigs_StopBar", self, "~"..breath)
	end
end

function mod:Breath(_, spellId, _, _, spellName)
	self:Bar(90125, "~"..spellName, 24, spellId)
	self:Message(90125, spellName, "Urgent", spellId)
end

function mod:Deaths(mobId)
	if mobId == 46842 then
		eggs = eggs + 1
		if eggs == 2 then
			self:Message("phase", CL["phase"]:format(3), "Positive", 51070, "Info") -- broken egg icon
			self:Bar("whelps", L["whelps"], 50, 69005)
			self:Bar(92852, "~"..slicer, 30, 92852)
			self:Bar(90125, "~"..breath, 24, 90125)
			self:ScheduleTimer(nextOrbSpawned, 30)
		end
	elseif mobId == 45213 then
		self:Win()
	end
end

