
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
		{119622, "FLASHSHAKE", "PROXIMITY"}, 119626, 119488, {119610, "FLASHSHAKE"},
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

function mod:UnleashedWrath(_, spellId, _, _, spellName)
	self:Message(spellId, spellName, "Important", spellId)
	self:Bar(spellId, spellName, 25, spellId)
end

do
	local prev = 0
	local spellName = mod:SpellName(119610)
	function mod:BitterThoughts()
		if UnitDebuff("player", spellName) then
			local t = GetTime()
			if t-prev > 2 then -- throttle so the timer can catch it sooner
				prev = t
				self:LocalMessage(119610, CL["underyou"]:format(spellName), "Personal", 119610, "Info")
				self:FlashShake(119610)
			end
		end
	end
end

local first, last = nil, 0
do
	local prev = 0
	function mod:GrowingAngerApplied(player, spellId, _, _, spellName)
		local t = GetTime()
		if not first then first = t
		else last = t end

		if UnitIsUnit(player, "player") then
			self:OpenProximity(5, spellId)
			self:FlashShake(spellId)
			self:LocalMessage(spellId, CL["you"]:format(spellName), "Personal", spellId, "Alert")
			self:Bar(spellId, CL["you"]:format(spellName), 6, spellId)
		else
			if t-prev > 6 then
				prev = t
				self:Message(119626, CL["soon"]:format(self:SpellName(119626)), "Attention", 119626, "Alarm") -- Aggressive Behavior
			end
		end
	end
	function mod:GrowingAngerRemoved(player, spellId)
		if UnitIsUnit(player, "player") then
			self:CloseProximity(spellId)
		end
	end
end

do
	local aggressiveTargets, scheduled = mod:NewTargetList(), nil
	local function warnAggressiveBehavior(spellId)
		mod:TargetMessage(spellId, spellId, aggressiveTargets, "Urgent", spellId)
		scheduled = nil
		print("! time diff", (last-first))
		first, last = nil, 0
	end
	function mod:AggressiveBehavior(player, spellId, _, _, spellName)
		aggressiveTargets[#aggressiveTargets + 1] = player
		if not scheduled then
			scheduled = self:ScheduleTimer(warnAggressiveBehavior, 2, spellId)
		end
	end
end

