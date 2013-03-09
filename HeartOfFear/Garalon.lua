
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
local mendLegTimerRunning = nil

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
		-6294,
		122735, 122754,
		122774, 123495, {122835, "ICON"}, 123120, 123081, "berserk", "bosskill",
	}, {
		[-6294] = "heroic",
		[122735] = INLINE_TANK_ICON..TANK,
		[122774] = "general",
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

	self:Death("Win", 62164, 63191)
end

function mod:OnEngage(diff)
	legCounter, crushCounter = 4, 0
	mendLegTimerRunning = nil

	self:Berserk(self:LFR() and 720 or 420)
	self:Bar(122735, 11) -- Furious Swipe
	if self:Heroic() then
		self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "PrePhase2", "boss1", "boss2", "boss3", "boss4", "boss5")
		self:Bar(122774, 28, CL["count"]:format(self:SpellName(122774), 1), 122082) -- Crush
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:PheromoneTrail(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", not UnitBuff("player", self:SpellName(122835)) and "Alert", CL["underyou"]:format(args.spellName)) -- even tho we usually use Alarm, Alarm has been used too much in the module
		end
	end
end

function mod:Crush(message, sender, _, _, target)
	if self:Heroic() and sender ~= target then -- someone running underneath (don't start new bars in heroic)
		self:Message(122774, "Important", "Alarm", CL["soon"]:format(self:SpellName(122774))) -- Crush
		self:Bar(122774, 3.6, CL["cast"]:format(self:SpellName(122774))) -- Crush
	else
		crushCounter = crushCounter + 1
		self:Message(122774, "Important", "Alarm", CL["soon"]:format(CL["count"]:format(self:SpellName(122774), crushCounter))) -- Crush
		self:Bar(122774, 3.6, CL["cast"]:format(self:SpellName(122774))) -- Crush
		if self:Heroic() then
			self:Bar(122774, 36, CL["count"]:format(self:SpellName(122774), crushCounter+1), 122082) -- Crush
		end
	end
	self:Bar(122735, 9) --Furious Swipe
end

function mod:Fury(args)
	if self:MobId(args.destGUID) == 63191 then -- only fire once
		self:Bar(args.spellId, self:LFR() and 15 or 30, nil, 119622) -- Rage like icon (swipe and fury have the same)
		self:Message(args.spellId, "Urgent", nil, CL["count"]:format(args.spellName, args.amount or 1), 119622)
	end
end

function mod:PheromonesApplied(args)
	self:PrimaryIcon(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		-- Local message with personal and info for when you gain the debuff, others don't care that you got it
		self:Message(args.spellId, "Personal", "Info", CL["you"]:format(args.spellName))
	elseif self:Healer() then
		self:TargetMessage(args.spellId, args.destName, "Attention", nil, nil, nil, true)
	end
end

function mod:PheromonesRemoved(args)
	if self:Me(args.destGUID) then
		-- Local message with important and alarm for when you loose the debuff, others don't care that you lost it
		self:Message(args.spellId, "Important", "Alarm", L["removed"]:format(args.spellName))
	end
end

function mod:Pungency(args)
	if args.amount % 2 == 0 and args.amount > ((self:LFR() and 13) or (self:Heroic() and 3) or 7) then
		self:StackMessage(args.spellId, args.destName, args.amount, "Attention")
	end
end

function mod:MendLeg(args)
	legCounter = legCounter + 1
	if legCounter < 4 then -- don't start a timer if it has all 4 legs
		self:Message(args.spellId, "Urgent")
		self:CDBar(args.spellId, 30)
	else
		-- all legs grew back, no need to start a bar, :BrokenLeg will start it
		mendLegTimerRunning = nil
	end
end

function mod:BrokenLeg()
	legCounter = legCounter - 1
	-- this is just a way to start the bar after 1st legs death
	if not mendLegTimerRunning then
		self:CDBar(123495, 30) -- Mend Leg
		mendLegTimerRunning = true
	end
end

function mod:FuriousSwipe(args)
	-- delay the bar so it ends when the damage occurs
	-- Furious Swipe's cast time is 2.5ish seconds, with 8s between SPELL_CAST_STARTs
	self:ScheduleTimer("Bar", 2.5, args.spellId, 8)
end

function mod:PrePhase2(unitId)
	local id = self:MobId(UnitGUID(unitId))
	if id == 62164 or id == 63191 then
		local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
		if hp < 38 then -- phase starts at 33
			self:Message(-6294, "Positive", "Long", CL["soon"]:format(CL["phase"]:format(2)), false)
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", "boss1", "boss2", "boss3", "boss4", "boss5")
		end
	end
end

function mod:Phase2()
	self:Message(-6294, "Positive", "Info", "33% - "..CL["phase"]:format(2))
end

