
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sha of Anger", 809, 691)
if not mod then return end
mod:RegisterEnableMob(60491)
mod.otherMenu = 6

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then

end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{119622, "FLASH", "PROXIMITY"}, 119626, 119488, {119610, "FLASH"},
		"bosskill",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "UnleashedWrath", 119488)
	self:Log("SPELL_AURA_APPLIED", "GrowingAngerApplied", 119622)
	self:Log("SPELL_AURA_REMOVED", "GrowingAngerRemoved", 119622)
	self:Log("SPELL_AURA_APPLIED", "AggressiveBehavior", 119626)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 60491)
end

function mod:OnEngage()
	--no CLEU for bitter thoughts? polling so it keeps beeping until you're out
	self:ScheduleRepeatingTimer("BitterThoughts", 0.5)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UnleashedWrath(args)
	self:Message(args.spellId, args.spellName, "Important", args.spellId)
	self:Bar(args.spellId, args.spellName, 25, args.spellId)
end

do
	local prev = 0
	local bitterThoughts = mod:SpellName(119610)
	function mod:BitterThoughts()
		if UnitDebuff("player", bitterThoughts) then
			local t = GetTime()
			if t-prev > 2 then -- throttle so the timer can catch it sooner
				prev = t
				self:LocalMessage(119610, CL["underyou"]:format(bitterThoughts), "Personal", 119610, "Info")
				self:Flash(119610)
			end
		end
	end
end

do
	local prev = 0
	function mod:GrowingAngerApplied(args)
		if UnitIsUnit(args.destName, "player") then
			self:OpenProximity(args.spellId, 5)
			self:Flash(args.spellId)
			self:LocalMessage(args.spellId, CL["you"]:format(args.spellName), "Personal", args.spellId, "Alert")
			self:Bar(args.spellId, CL["you"]:format(args.spellName), 6, args.spellId)
		else
			local t = GetTime()
			if t-prev > 6 then
				prev = t
				self:Message(119626, CL["soon"]:format(self:SpellName(119626)), "Attention", 119626, "Alarm") -- Aggressive Behavior
			end
		end
	end
	function mod:GrowingAngerRemoved(args)
		if UnitIsUnit(args.destName, "player") then
			self:CloseProximity(args.spellId)
		end
	end
end

do
	local aggressiveTargets, scheduled = mod:NewTargetList(), nil
	local function warnAggressiveBehavior(spellId)
		mod:TargetMessage(spellId, spellId, aggressiveTargets, "Urgent", spellId)
		scheduled = nil
	end
	function mod:AggressiveBehavior(args)
		aggressiveTargets[#aggressiveTargets + 1] = args.destName
		if not scheduled then
			scheduled = self:ScheduleTimer(warnAggressiveBehavior, 2, args.spellId)
		end
	end
end

