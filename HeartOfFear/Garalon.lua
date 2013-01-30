
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Garalon", 897, 713)
if not mod then return end
mod:RegisterEnableMob(63191, 63053) -- Garalon, Garalon's Leg

-----------------------------------------------------------------------------------------
-- Locals
--

local legCounter, crushCounter = 4, 0
local healthCheck, mendLegTimerRunning = nil, nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.phase2_trigger = "Garalon's massive armor plating begins to crack and split!"

	L.removed = "%s removed!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		122735, 122754,
		122774, 123495, {122835, "ICON"}, 123120, 123081, "berserk", "bosskill",
		"ej:6294",
	}, {
		[122735] = INLINE_TANK_ICON..TANK,
		[122774] = "general",
		["ej:6294"] = "heroic",
	}
end

function mod:OnBossEnable()
	self:Emote("Crush", "spell:122774")
	self:Emote("Phase2", L["phase2_trigger"])

	self:Log("SPELL_AURA_APPLIED", "PheromonesApplied", 122835)
	self:Log("SPELL_AURA_REMOVED", "PheromonesRemoved", 122835)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Pungency", 123081)
	self:Log("SPELL_CAST_SUCCESS", "MendLeg", 123495)
	self:Log("SPELL_CAST_SUCCESS", "BrokenLeg", 122786)
	self:Log("SPELL_CAST_START", "FuriousSwipe", 122735)
	self:Log("SPELL_AURA_APPLIED", "Fury", 122754)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Fury", 122754)

	self:Log("SPELL_DAMAGE", "PheromoneTrail", 123120)
	self:Log("SPELL_MISSED", "PheromoneTrail", 123120)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 63191)
end

function mod:OnEngage(diff)
	legCounter, crushCounter = 4, 0
	healthCheck, mendLegTimerRunning = nil, nil

	self:Berserk(self:LFR() and 720 or 420)
	self:Bar(122735, 122735, 11, 122735) -- Furious Swipe
	if self:Heroic() then
		healthCheck = self:ScheduleRepeatingTimer("PrePhase2", 0.5) -- No boss5 support in health events
		self:Bar(122774, ("%s (%d)"):format(self:SpellName(122774), 1), 28, 122082) -- Crush
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:PheromoneTrail(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(args.spellId, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Alert") -- even tho we usually use Alarm, Alarm has been sued too much in the module
		end
	end
end

function mod:Crush(message, sender, _, _, target)
	if self:Heroic() and sender ~= target then -- someone running underneath (don't start new bars in heroic)
		self:Message(122774, CL["soon"]:format(self:SpellName(122774)), "Important", 122774, "Alarm") -- Crush
		self:Bar(122774, CL["cast"]:format(self:SpellName(122774)), 3.6, 122774) -- Crush
	else
		crushCounter = crushCounter + 1
		self:Message(122774, CL["soon"]:format(("%s (%d)"):format(self:SpellName(122774), crushCounter)), "Important", 122774, "Alarm") -- Crush
		self:Bar(122774, CL["cast"]:format(self:SpellName(122774)), 3.6, 122774) -- Crush
		if self:Heroic() then
			self:Bar(122774, ("%s (%d)"):format(self:SpellName(122774), crushCounter+1), 36, 122082) -- Crush
		end
	end
	self:Bar(122735, 122735, 9, 122735) --Furious Swipe
end

function mod:Fury(args)
	if self:GetCID(args.destGUID) == 63191 then -- only fire once
		self:Bar(args.spellId, args.spellName, self:LFR() and 15 or 30, 119622) -- Rage like icon (swipe and fury have the same)
		self:Message(args.spellId, ("%s (%d)"):format(args.spellName, args.amount or 1), "Urgent", 119622)
	end
end

function mod:PheromonesApplied(args)
	self:PrimaryIcon(args.spellId, args.destName)
	if UnitIsUnit("player", args.destName) then
		-- Local message with personal and info for when you gain the debuff, others don't care that you got it
		self:LocalMessage(args.spellId, CL["you"]:format(args.spellName), "Personal", args.spellId, "Info")
	elseif self:Healer() then
		self:LocalMessage(args.spellId, args.spellName, "Attention", args.spellId, nil, args.destName)
	end
end

function mod:PheromonesRemoved(args)
	if UnitIsUnit("player", args.destName) then
		-- Local message with important and alarm for when you loose the debuff, others don't care that you lost it
		self:LocalMessage(args.spellId, L["removed"]:format(args.spellName), "Important", args.spellId, "Alarm")
	end
end

function mod:Pungency(args)
	if args.amount > ((self:LFR() and 13) or (self:Heroic() and 3) or 7) and args.amount % 2 == 0 then
		self:TargetMessage(args.spellId, CL["stack"], args.destName, "Attention", args.spellId, nil, args.amount, args.spellName)
	end
end

function mod:MendLeg(args)
	legCounter = legCounter + 1
	if legCounter < 4 then -- don't start a timer if it has all 4 legs
		self:Message(args.spellId, args.spellName, "Urgent", args.spellId)
		self:Bar(args.spellId, "~"..args.spellName, 30, args.spellId)
	else
		-- all legs grew back, no need to start a bar, :BrokenLeg will start it
		mendLegTimerRunning = nil
	end
end

function mod:BrokenLeg()
	legCounter = legCounter - 1
	-- this is just a way to start the bar after 1st legs death
	if not mendLegTimerRunning then
		self:Bar(123495, "~"..self:SpellName(123495), 30, 123495) -- Mend Leg
		mendLegTimerRunning = true
	end
end

do
	-- Furious Swipe's cast time is 2.5ish seconds, with 8s between SPELL_CAST_STARTs
	local function nextSwipe(spellId)
		mod:Bar(spellId, spellId, 8, spellId)
	end
	function mod:FuriousSwipe(args)
		-- delay the bar so it ends when the damage occurs
		self:ScheduleTimer(nextSwipe, 2.5, args.spellId)
	end
end

function mod:PrePhase2()
	local hp = UnitHealth("boss5") / UnitHealthMax("boss5") * 100
	if hp < 38 then -- phase starts at 33
		self:Message("ej:6294", CL["soon"]:format(CL["phase"]:format(2)), "Positive", 108201, "Long") -- the correct icon
		self:CancelTimer(healthCheck)
	end
end

function mod:Phase2()
	self:Message("ej:6294", "33% - "..CL["phase"]:format(2), "Positive", 108201, "Info")
end

