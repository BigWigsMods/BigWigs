--[[
TODO:
	on 10 H/25N PTR - food_call_trigger was gone, could not find anything to replace it, rethink how the warning should work later
	maybe message should be in :CallForFood not :FeedYoung, someone maybe should look into if it is safe to do so
		as in: is the 10 sec ( the max flight time ) enough from :CallForFood to catch the slime?
	people NOT on the main platform should have proximity closed
	need lots of TRANSCRIPTOR logs to figure out nest orders
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
	L.lower_upper_nest = "|c00FF0000Lower|r + |c00008000Upper|r nest"
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
		{-7360, "FLASH"}, 140741,
		{140092, "TANK"}, {134366, "TANK"}, {134380, "FLASH"}, 134370,
		"proximity", "berserk", "bosskill",
	}, {
		["nest"] = -7348,
		[140092] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- eat for the hatchlings is intentionally not here, players can't do anything about it once it is casted, so we don't warn uselessly
	self:Log("SPELL_AURA_APPLIED", "FeedYoung", 137528)
	self:Emote("CallForFood", L["food_call_trigger"])
	self:Log("SPELL_AURA_APPLIED", "YoungEgg", 134347) -- XXX This is was not there on 10 H ptr, consider removing it
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:Log("SPELL_AURA_APPLIED", "PrimalNutriment", 140741)
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
	self:Bar(134380, self:Heroic() and 63 or 48) -- Quills
	self:Bar(134370, 90) -- Down Draft
	nestCounter = 0
	feedingAllowed = false
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FeedYoung(args)
	if not feedingAllowed then return end
	self:Message("nest", "Positive", nil, args.spellId) -- Positive because it is green!
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
			self:Message("nest", "Attention", nil, L["young_egg_hatching"], args.spellId) -- this might be redundant, if we use the emote to warn for hatching nests
			self:Bar("nest", 10, L["young_egg_hatching"], args.spellId) -- this is not redundant, keep this!
		end
	end
end

-- lower, lower, lower, upper, upper, upper, -- 10 N/H
-- lower, lower, lower, lower, {lower, upper}, upper, upper, {lower, upper}, {lower, upper}, lower, upper, upper, {lower, upper} -- 25 N
function mod:CHAT_MSG_MONSTER_EMOTE(_, msg)
	local diff = self:Difficulty()
	if msg:find(L["upper_hatch_trigger"]) or msg:find(L["lower_hatch_trigger"]) then
		nestCounter = nestCounter + 1
		local text = (msg:find(L["upper_hatch_trigger"])) and L["upper_nest"] or L["lower_nest"]
		local icon = (msg:find(L["upper_hatch_trigger"])) and "misc_arrowlup" or "misc_arrowdown"
		if diff == 3 or diff == 5 then -- 10 man N/H
			if nestCounter % 6 > 2 then -- first 3 down, second 3 up
				self:Bar("nest", 30, L["upper_nest"], "misc_arrowlup")
			else
				self:Bar("nest", 30, L["lower_nest"], "misc_arrowdown")
			end
			self:Message("nest", "Attention", "Alert", text, icon)
		else
			-- XXX figure out order in LFR
			-- XXX this is correct for 25 N (up to 17, need trascriptor logs for better logic)
			if nestCounter % 17 < 4 or nestCounter % 17 == 12 then
				self:Bar("nest", 30, L["lower_nest"], "misc_arrowdown")
				self:Message("nest", "Attention", "Alert", text, icon)
			elseif nestCounter % 17 == 4 or nestCounter % 17 == 8 or nestCounter % 17 == 10 or nestCounter % 17 == 15 then -- up and down at same time
				text, icon = L["lower_upper_nest"], 134347 -- egg icon
				self:Bar("nest", 30, text, icon)
				self:Message("nest", "Attention", "Alert", text, icon)
			elseif nestCounter % 17 == 6 or nestCounter % 12 == 7 or nestCounter % 12 == 13 or nestCounter % 12 == 14 then
				self:Bar("nest", 30, L["upper_nest"], "misc_arrowlup")
				self:Message("nest", "Attention", "Alert", text, icon)
			end
		end
	end
end

function mod:PrimalNutriment(args)
	if not UnitIsUnit("player", args.destName) then return end
	self:Message(args.spellId, "Positive")
	self:Bar(args.spellId, 30, CL["you"]:format(args.spellName))
end

do
	local function flightMessage(remainingTime)
		mod:Message(-7360, "Personal", (remainingTime<5) and "Info" or nil, CL["custom_sec"]:format(L["flight_over"], remainingTime), 133755)
	end
	function mod:Flight(args)
		if not UnitIsUnit("player", args.destName) then return end
		self:ScheduleTimer(flightMessage, 5, 5)
		self:ScheduleTimer(flightMessage, 8, 2)
		self:ScheduleTimer(flightMessage, 9, 1) -- A bit of spam, but it is necessary!
		self:Bar(-7360, 10, args.spellId)
		self:ScheduleTimer("Flash", 8, -7360)
	end
end

function mod:DownDraft(args)
	self:Message(args.spellId, "Important", "Long")
	self:Bar(args.spellId, 93)
end

function mod:Quills(args)
	self:Flash(args.spellId)
	self:Message(args.spellId, "Important", "Long")
	self:Bar(args.spellId, 63)
end

function mod:TalonRake(args)
	args.amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, args.amount, "Attention", "Info")
	self:CDBar(args.spellId, 15)
end

function mod:InfectedTalons(args)
	if args.amount % 2 ~= 0 then return end
	self:StackMessage(args.spellId, args.destName, args.amount, "Urgent", "Info")
end

