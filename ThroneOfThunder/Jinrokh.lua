--[[
TODO:
	Double check if proximity windows are opened and closed correctly
	Focused Lightning CD might be rested by Ionization ( or maybe its thundering throw too if the CDs are close enough )
]]--

if select(4, GetBuildInfo()) < 50200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Jin'rokh the Breaker", 930, 827)
if not mod then return end
mod:RegisterEnableMob(69465)

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.storm_duration = "Lightning Storm duration"
	L.storm_duration_desc = "A separate bar warning for the duration of the Lightning Storm cast."
	L.storm_duration_icon = 137313

	L.in_water = "You are in water!"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{138732, "PROXIMITY"},
		137313, "storm_duration", {137175, "PROXIMITY", "ICON"}, {139467, "FLASH"}, {-7741, "PROXIMITY", "ICON", "SAY"}, 137162, {138375, "FLASH"}, {138006, "FLASH"}, "berserk", "bosskill",
	}, {
		[138732] = "heroic",
		[137313] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Log("SPELL_AURA_REMOVED", "IonizationRemoved", 138732)
	self:Log("SPELL_AURA_APPLIED", "PersonalIonization", 138732) -- This is needed for personal bar
	self:Log("SPELL_CAST_START", "Ionization", 138732)
	self:Log("SPELL_CAST_SUCCESS", "LightningStormDuration", 137313)
	self:Log("SPELL_CAST_START", "LightningStorm", 137313)
	self:Log("SPELL_DAMAGE", "ThunderingThrowSafe", 137370) -- This spellId is the damage done to the tank ONLY
	self:Log("SPELL_MISS", "ThunderingThrowSafe", 137370) -- This spellId is the damage done to the tank ONLY
	self:Emote("ThunderingThrow", "137175") -- this seems to be the fastest way to determine which tank gets thrown, APPLIED is way too slow
	self:Log("SPELL_DAMAGE", "LightningFissure", 139467, 137485) -- 137485 is from 25 H PTR
	self:Log("SPELL_AURA_REMOVED", "FocusedLightningRemoved", 137422)
	self:Log("SPELL_CAST_START", "FocusedLightning", 137399) -- SUCCESS has destName, but this is so much earlier, and "boss1target" should be reliable for it
	self:Log("SPELL_CAST_SUCCESS", "StaticBurst", 137162)
	self:Log("SPELL_DAMAGE", "StaticWoundConduction", 138375)
	self:Log("SPELL_PERIODIC_DAMAGE", "ElectrifiedWaters", 138006)

	self:Death("Win", 69465)
end

function mod:OnEngage()
	self:Bar(137313, 93) -- Lightning Storm
	self:Bar(137175, 30) -- Thundering Throw
	self:CDBar(137162, 7) -- Static Burst -- again, is there even a point for such a short bar?
	if self:Heroic() then -- Ionization
		self:Berserk(360) -- Real berserk confirmed 25 H PTR
		self:Bar(138732, 60)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:IonizationRemoved(args)
	if not self:Me(args.destGUID) then return end
	self:StopBar(CL["you"]:format(args.spellName))
	self:CloseProximity(args.spellId)
	if UnitDebuff("player", self:SpellName(137422)) then -- Focused Lightning
		self:OpenProximity(-7741, 8) -- reopen it if we have lightning chasing us too
	end
end

function mod:PersonalIonization(args)
	if self:Me(args.destGUID) then
		self:Bar(args.spellId, 24, CL["you"]:format(args.spellName))
	end
end

function mod:Ionization(args)
	self:CDBar(-7741, 13) -- Focused Lightning
	self:Message(args.spellId, "Important", "Long")
	self:OpenProximity(args.spellId, 8)
	self:Bar(args.spellId, 92)
end


function mod:LightningStormDuration(args)
	self:Bar("storm_duration", 15, CL["cast"]:format(args.spellName), L.storm_duration_icon) -- help with organizing raid cooldowns
end

function mod:LightningStorm(args)
	self:Message(args.spellId, "Important", "Long")
	self:Bar(args.spellId, 93)
	self:Bar(-7741, self:Heroic() and 20 or 26) -- Focused Lightning -- XXX re check timers for non heroic
	self:Bar(137162, 20) -- Static Burst
	self:Bar(137175, 30) -- Thundering Throw
end

function mod:ThunderingThrowSafe()
	self:SecondaryIcon(137175)
	self:CloseProximity(137175)
	if UnitDebuff("player", self:SpellName(137162)) then -- Focused Lightning
		self:OpenProximity(-7741, 5)
	end
end

function mod:ThunderingThrow(_, _, _, _, target)
	self:TargetMessage(137175, target, "Attention", "Alert")
	self:SecondaryIcon(137175, target)
	if not UnitIsUnit(target, "player") then -- no point opening proximity for the thrown tank
		self:CloseProximity(-7741) -- close this before opening another ( in case it was open )
		self:OpenProximity(137175, 8, target)
	end
end

do
	local prev = 0
	function mod:LightningFissure(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

function mod:FocusedLightningRemoved()
	self:PrimaryIcon(-7741)
	if self:Me(args.destGUID) then
		self:CloseProximity(-7741)
	end
end

do
	local timer, fired = nil, 0
	local function warnFocusedLightning()
		fired = fired + 1
		local player = UnitName("boss1target")
		if player and (not UnitDetailedThreatSituation("boss1target", "boss1") or fired > 13) then
			mod:TargetMessage(-7741, player, "Urgent", "Alarm")
			mod:PrimaryIcon(-7741, player)
			if UnitIsUnit("boss1target", "player") then
				mod:Say(-7741)
				mod:OpenProximity(-7741, 8)
			end
			mod:CancelTimer(timer)
			timer = nil
			return
		end
		-- 19 == 0.95sec
		-- Safety check if the unit doesn't exist
		if fired > 18 then
			mod:CancelTimer(timer)
			timer = nil
		end
	end
	function mod:FocusedLightning(args)
		self:CDBar(-7741, 11)
		fired = 0
		if not timer then
			timer = self:ScheduleRepeatingTimer(warnFocusedLightning, 0.05)
		end
	end
end

function mod:StaticBurst(args)
	-- This is intentionally not a tank only warning!
	self:Message(args.spellId, "Attention")
	self:CDBar(args.spellId, 23)
end

do
	local prev = 0
	function mod:StaticWoundConduction(args)
		if not self:Me(args.sourceGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", L["in_water"])
			self:Flash(args.spellId)
		end
	end
end

do
	local prev = 0
	function mod:ElectrifiedWaters(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

