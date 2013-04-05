--[[
TODO:
	on 10 H/25N PTR - food_call_trigger was gone, could not find anything to replace it, rethink how the warning should work later
	maybe message should be in :CallForFood not :FeedYoung, someone maybe should look into if it is safe to do so
		as in: is the 10 sec ( the max flight time ) enough from :CallForFood to catch the slime?
	people NOT on the main platform should have proximity closed
	need lots of TRANSCRIPTOR logs to figure out nest orders
]]--

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
local quillCounter = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.lower_hatch_trigger = "The eggs in one of the lower nests begin to hatch!"
	L.upper_hatch_trigger = "The eggs in one of the upper nests begin to hatch!"

	L.nest = "Nests"
	L.nest_desc = "Warnings related to the nests. |cffff0000Untoggle this to turn off warnings if you are not assigned to handle the nests!|r"

	L.flight_over = "Flight over in %d sec!"
	L.upper_nest = "|cff008000Upper|r nest"
	L.lower_nest = "|cffff0000Lower|r nest"
	L.up = "UP"
	L.down = "DOWN"
	L.add = "Add"
	L.big_add_message = "Big add at %s"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"nest", -- this controls a lot of things, so it is easier to turn off for people who don't handle the nests
		{-7360, "FLASH"}, 140741, 137528,
		{140092, "TANK_HEALER"}, {134366, "TANK_HEALER"}, {134380, "FLASH"}, 134370, 138923,
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
	self:Log("SPELL_AURA_APPLIED", "PrimalNutriment", 140741)
	self:Log("SPELL_AURA_APPLIED", "Flight", 133755)
	self:Log("SPELL_CAST_START", "Caw", 138923)
	self:Log("SPELL_CAST_START", "DownDraft", 134370)
	self:Log("SPELL_CAST_START", "Quills", 134380)
	self:Log("SPELL_AURA_APPLIED", "TalonRake", 134366)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TalonRake", 134366)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfectedTalons", 140092)

	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:Death("Win", 69712)
end

function mod:OnEngage(diff)
	if not self:LFR() then
		self:OpenProximity("proximity", 8)
	end
	self:Berserk(600) -- XXX assumed
	local is25 = diff == 4 or diff == 6
	self:Bar(134380, is25 and 41 or 60) -- Quills
	self:Bar(134370, 90) -- Down Draft
	nestCounter = 0
	quillCounter = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FeedYoung(args)
	self:Message(args.spellId, "Positive", "Info") -- Positive because it is green!
	self:CDBar(args.spellId, 30)
end

function mod:Caw(args)
	self:Message(args.spellId, "Attention", nil, CL["incoming"]:format(args.spellName)) -- no z-axis info for range check to ignore for nest people :\
	--self:CDBar(args.spellId, 18) -- 18-30s
end

function mod:CHAT_MSG_MONSTER_EMOTE(_, msg)
	if not msg:find(L["upper_hatch_trigger"], nil, true) and not msg:find(L["lower_hatch_trigger"], nil, true) then return end

	local diff = self:Difficulty()
	nestCounter = nestCounter + 1

	local color, text, icon
	if msg:find(L["upper_hatch_trigger"]) then
		color = "Attention"
		text = CL["count"]:format(L["upper_nest"], nestCounter)
		icon = "misc_arrowlup"
	else
		color = "Urgent"
		text = CL["count"]:format(L["lower_nest"], nestCounter)
		icon = "misc_arrowdown"
	end

	if diff == 5 and (nestCounter == 2 or nestCounter == 4 or nestCounter == 8 or nestCounter == 12) then  
		text = L["big_add_message"]:format(text)
	end
	self:Message("nest", color, "Alert", text, icon) -- XXX keep this here till all the nest rotations are 100% figured out

	local nextNest = nestCounter + 1
	if diff == 3 or diff == 7 then -- 10 N / LFR
		-- first 3 lower, second 3 upper
		if nestCounter % 6 > 2 then
			self:Bar("nest", 40, ("(%d) %s"):format(nextNest, L["upper_nest"]), "misc_arrowlup")
		else
			self:Bar("nest", 40, ("(%d) %s"):format(nextNest, L["lower_nest"]), "misc_arrowdown")
		end
	elseif diff == 5 then -- 10 H
		-- first 3 lower, second 3 upper
		-- big adds at 2, 4, 8, 12 (no data past 17)
		if nestCounter % 6 > 2 then
			if nestCounter == 3 or nestCounter == 11 then
				self:Bar("nest", 30, ("(%d) %s (%s)"):format(nextNest, L["up"], L["add"]), "misc_arrowlup")
			else
				self:Bar("nest", 30, ("(%d) %s"):format(nextNest, L["upper_nest"]), "misc_arrowlup")
			end
		else
			if nestCounter == 1 or nestCounter == 7 then
				self:Bar("nest", 30, ("(%d) %s (%s)"):format(nextNest, L["down"], L["add"]), "misc_arrowdown")
			else
				self:Bar("nest", 30, ("(%d) %s"):format(nextNest, L["lower_nest"]), "misc_arrowdown")
			end
		end
	elseif diff == 4 then -- 25 N
		-- 1 lower, 2 lower, 3 lower, 4 lower, 5 {lower, 6 upper}, 7 upper, 8 upper, 9 {lower, 10 upper}, 11 {lower, 12 upper}, 13 lower, 14 lower, 15 {lower, 16 upper},
		-- 17 upper, 18 {lower, 19 upper}, 20 {lower, 21 upper}, 22 {lower, 23 upper}, 24 lower, 25 {lower, 26 upper}, 27 {lower, 28 upper}
		if nestCounter % 28 < 4 or nestCounter % 28 == 12 or nestCounter % 28 == 13 or nestCounter % 28 == 23 then
			self:Bar("nest", 30, ("(%d) %s"):format(nextNest, L["lower_nest"]), "misc_arrowdown")
		elseif nestCounter % 28 == 4 or nestCounter % 28 == 8 or nestCounter % 28 == 10 or nestCounter % 28 == 14 or nestCounter % 28 == 17 or nestCounter % 28 == 19 or nestCounter % 28 == 21 or nestCounter % 28 == 24 or nestCounter % 28 == 26 then -- up and down at same time
			self:Bar("nest", 30, ("(%d)%s+(%d)%s"):format(nextNest, L["down"], nextNest+1, L["up"]), 134347)
		elseif nestCounter % 28 == 6 or nestCounter % 28 == 7 or nestCounter % 28 == 16 then
			self:Bar("nest", 30, ("(%d) %s"):format(nextNest, L["upper_nest"]), "misc_arrowlup")
		end
	elseif diff == 6 then -- 25 H
		-- 1 lower, 2 lower, 3 lower, 4 {lower, 5 upper}, 6 {lower, 7 upper}, 8 upper, 9 {lower, 10 upper}, 11 {lower, 12 upper}, 13 lower, 14 {upper, 15 lower}, 16 {upper, 17 lower}
		-- 18 {lower, 19 upper}, 20 {lower, 21 upper}, 22 {upper, 23 lower, 24 upper}, 25 {upper, 26 lower}, 27 {lower, 28 upper, 29 lower}, 30 {lower, 31 upper}, 32 {upper, 33 lower, 34 upper}
		-- 35 {lower, 36 upper, 37 lower}
		-- there are intentionally no spaces on some bars so text fits
		if nestCounter < 3 or nestCounter == 12 then
			self:Bar("nest", 30, ("(%d) %s"):format(nextNest, L["down"]), "misc_arrowdown")
		elseif nestCounter == 3 or nestCounter == 8 or nestCounter == 17 or nestCounter == 19 or nestCounter == 29 then
			self:Bar("nest", 30, ("(%d)%s+(%d)%s"):format(nextNest, L["down"], nextNest+1, L["up"]), 134347)
		elseif nestCounter == 13 or nestCounter == 15 or nestCounter == 24 then
			self:Bar("nest", 30, ("(%d)%s+(%d)%s"):format(nextNest, L["up"], nextNest+1, L["down"]), 134347) -- this is intentional, because this is how blizzard announces it too!
		elseif nestCounter == 7 then
			self:Bar("nest", 30, ("(%d) %s"):format(nextNest, L["up"]), "misc_arrowlup")
		elseif nestCounter == 1 then
			self:Bar("nest", 30, ("(%d) %s (%s)"):format(nextNest, L["down"], L["add"]), "misc_arrowdown")
		elseif nestCounter == 5 then
			self:Bar("nest", 30, ("(%d)%s(%s)+(%d)%s"):format(nextNest, L["down"], L["add"], nextNest+1, L["up"]), 134347)
		elseif nestCounter == 10 then
			self:Bar("nest", 30, ("(%d)%s+(%d)%s(%s)"):format(nextNest, L["down"], nextNest+1, L["up"], L["add"]), 134347)
		elseif nestCounter == 21 then
			self:Bar("nest", 30, ("(%d)%s+(%d)%s(%s)+(%d)%s"):format(nextNest, L["up"], nextNest+1, L["down"], L["add"], nextNest+2, L["up"]), 134347) -- XXX keep an eye out for this if it fits on the bar
		elseif nestCounter == 26 or nestCounter == 34 then
			self:Bar("nest", 30, ("(%d)%s+(%d)%s+(%d)%s"):format(nextNest, L["down"], nextNest+1, L["up"], nextNest+2, L["down"]), 134347)
		elseif nestCounter == 31 then
			self:Bar("nest", 30, ("(%d)%s+(%d)%s+(%d)%s"):format(nextNest, L["up"], nextNest+1, L["down"], nextNest+2, L["up"]), 134347)
		end
		-- big adds at 2, 6, 12, 23 (there might be more between 23 and 37)
		if nestCounter == 2 or nestCounter == 6 or nestCounter == 23 then
			self:Message("nest", "Urgent", "Alert", L["big_add_message"]:format(L["lower_nest"]), 134367)
		elseif nestCounter == 12 or nestCounter == 16 then
			self:Message("nest", "Attention", "Alert", L["big_add_message"]:format(L["upper_nest"]), 134367)
		end
	end
end

function mod:PrimalNutriment(args)
	if not self:Me(args.destGUID) then return end
	self:Message(args.spellId, "Positive")
	self:Bar(args.spellId, 30, CL["you"]:format(args.spellName))
end

do
	local function flightMessage(remainingTime)
		mod:Message(-7360, "Personal", remainingTime < 5 and "Info", L["flight_over"]:format(remainingTime), 133755)
	end
	function mod:Flight(args)
		if not self:Me(args.destGUID) then return end
		self:ScheduleTimer(flightMessage, 5, 5)
		self:ScheduleTimer(flightMessage, 8, 2)
		self:ScheduleTimer(flightMessage, 9, 1) -- A bit of spam, but it is necessary!
		self:ScheduleTimer("Flash", 8, -7360)
		self:Bar(-7360, 10)
	end
end

function mod:DownDraft(args)
	self:Message(args.spellId, "Important", "Long")
	self:Bar(args.spellId, 93)
end

function mod:Quills(args)
	self:Message(args.spellId, "Important", "Warning")
	self:Flash(args.spellId)
	local diff = self:Difficulty()
	quillCounter = quillCounter + 1
	if diff == 4 or diff == 6 then -- 25 N/H
		self:Bar(args.spellId, 63)
	else -- 10 N/H + LFR
		if quillCounter == 4 then
			self:Bar(args.spellId, 91)
		elseif quillCounter == 7 then
			self:Bar(args.spellId, 44) -- soft enrage it looks like
		elseif quillCounter < 7 then
			self:Bar(args.spellId, 81)
		else
			self:Bar(args.spellId, 81) -- XXX need more data ( logs beyond 10 min )
		end
	end
end

function mod:TalonRake(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Urgent", "Info")
	self:CDBar(args.spellId, 22)
end

function mod:InfectedTalons(args)
	if args.amount % 2 == 0 then
		self:StackMessage(args.spellId, args.destName, args.amount, "Attention")
	end
end

