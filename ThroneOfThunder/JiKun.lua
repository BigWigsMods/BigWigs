--[[
TODO:
	assume every 4th is upper nest
	maybe message should be in :CallForFood not :FeedYoung, someone maybe should look into if it is safe to do so
		as in: is the 10 sec ( the max flight time ) enough from :CallForFood to catch the slime?
]]--
if select(4, GetBuildInfo()) < 50200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ji-Kun", 930, 828)
if not mod then return end
mod:RegisterEnableMob(69712) -- Ji-Kun

--------------------------------------------------------------------------------
-- Locals
--
local nestCounter = 0
local feedingAllowed = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.flight_over = "Flight over"
	L.young_egg_hatching = "Young egg hatching"
	L.lower_hatch_trigger = "The eggs in one of the lower nests begin to hatch!"
	L.upper_hatch_trigger = "The eggs in one of the upper nests begin to hatch!"
	L.upper_nest = "|c00008000Upper|r nest"
	L.lower_nest = "|c00FF0000Lower|r nest"
	L.food_call_trigger = "Hatchling calls for food!"
	L.nest = "Nests"
	L.nest_desc = "Warnings related to the nests. |c00FF0000Untoggle this to turn off warnings, if you are not assigned to handle the nests!|r"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"nest", -- this controls a lot of things, so it is easier to turn off for people who don't handle the nests
		{"ej:7360", "FLASH"},
		{140092, "TANK"}, {134366, "TANK"}, {134380, "FLASH"}, 134370,
		"proximity", "berserk", "bosskill",
	}, {
		["nest"] = "ej:7348",
		[140092] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- eat for the hatchlings is intentionally not here, players can't do anything about it once it is casted, so we don't warn uselessly
	self:Log("SPELL_AURA_APPLIED", "FeedYoung", 137528)
	self:Emote("CallForFood", L["food_call_trigger"])
	self:Log("SPELL_AURA_APPLIED", "YoungEgg", 134347)
	self:Emote("HatchUpperNest", L["upper_hatch_trigger"])
	self:Emote("HatchLowerNest", L["lower_hatch_trigger"])
	self:Log("SPELL_AURA_APPLIED", "Flight", 133755)
	self:Log("SPELL_CAST_START", "DownDraft", 134370)
	self:Log("SPELL_CAST_START", "Quills", 134380)
	self:Log("SPELL_AURA_APPLIED", "TalonRake", 134366)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TalonRake", 134366)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfectedTalons", 140092)

	self:Death("Win", 69712)
end

function mod:OnEngage()
	self:OpenProximity("proximity", 8)
	self:Berserk(600) -- XXX assumed
	self:Bar(134380, 134380, 48, 134380) -- Quills
	self:Bar(134370, 134370, 93, 134370) -- Down Draft
	nestCounter = 0
	feedingAllowed = false
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FeedYoung(args)
	if not feedingAllowed then return end
	self:Message("nest", args.spellName, "Positive", args.spellId) -- Positive because it is green!
	feedingAllowed = false
end

function mod:CallForFood()
	feedingAllowed = true
end

do
	local prev = 0
	function mod:YoungEgg(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message("nest", L["young_egg_hatching"], "Attention", args.spellId) -- this might be redundant, if we use the emote to warn for hatching nests
			self:Bar("nest", L["young_egg_hatching"], 10, args.spellId) -- this is not redundant, keep this!
		end
	end
end

function mod:HatchUpperNest()
	nestCounter = nestCounter + 1
	self:Message("nest", L["upper_nest"], "Attention", "misc_arrowlup", "Alert")
	self:Bar("nest", L["lower_nest"], 30, "misc_arrowdown")
end

function mod:HatchLowerNest()
	nestCounter = nestCounter + 1
	self:Message("nest", L["lower_nest"], "Attention", "misc_arrowdown", "Alert")
	if nestCounter % 3 == 0 then -- XXX assume every 4th is upper nest
		self:Bar("nest", L["upper_nest"], 30, "misc_arrowlup")
	else
		self:Bar("nest", L["lower_nest"], 30, "misc_arrowdown")
	end
end

do
	local function flightMessage(remainingTime)
		mod:LocalMessage("ej:7360", CL["custom_sec"]:format(L["flight_over"], remainingTime), "Personal", 133755, (remainingTime<5) and "Info" or nil)
	end
	local function flightFlash()
		mod:Flash("ej:7360")
	end
	function mod:Flight(args)
		if not UnitIsUnit("player", args.destName) then return end
		self:ScheduleTimer(flightMessage, 5, 5)
		self:ScheduleTimer(flightMessage, 8, 2)
		self:ScheduleTimer(flightMessage, 9, 1) -- A bit of spam, but it is necessary!
		self:Bar("ej:7360", args.spellName, 10, args.spellId)
		self:ScheduleTimer(flightFlash, 8)
	end
end

function mod:DownDraft(args)
	self:Message(args.spellId, args.spellName, "Important", args.spellId, "Long")
	self:Bar(args.spellId, args.spellName, 93, args.spellId)
end

function mod:Quills(args)
	self:Flash(args.spellId)
	self:Message(args.spellId, args.spellName, "Important", args.spellId, "Long")
	self:Bar(args.spellId, args.spellName, 63, args.spellId)
end

function mod:TalonRake(args)
	args.amount = args.amount or 1
	self:LocalMessage(args.spellId, CL["stack"], "Attention", args.spellId, "Info", args.destName, args.amount, args.spellName)
	self:Bar(args.spellId, "~"..args.spellName, 15, args.spellId)
end

function mod:InfectedTalons(args)
	if args.amount % 2 ~= 0 then return end
	self:LocalMessage(args.spellId, CL["stack"], "Urgent", args.spellId, "Info", args.destName, args.amount, args.spellName)
end

