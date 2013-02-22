--[[
TODO:
	Double check if proximity windows are opened and closed correctly
	focused lightning removed is being kept track of with UNIT_AURA which is ugly expect CLEU events added for this ( not as of 25 N ptr )
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
	L.storm_duration_desc = "A separate bar warning for the duration of the Lightning Storm cast"
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
		137313, "storm_duration", {137175, "PROXIMITY", "ICON"}, {139467, "FLASH"},{"ej:7741", "PROXIMITY", "ICON", "SAY"}, 137162, {138375, "FLASH"}, {138006, "FLASH"}, "berserk", "bosskill",
	}, {
		[138732] = "heroic",
		[137313] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Log("SPELL_AURA_REMOVED", "IonizationRemoved", 138732)
	self:Log("SPELL_CAST_START", "Ionization", 138732)
	self:Log("SPELL_CAST_SUCCESS", "LightningStormDuration", 137313)
	self:Log("SPELL_CAST_START", "LightningStorm", 137313)
	self:Log("SPELL_DAMAGE", "ThunderingThrowSafe", 137370) -- This spellId is the damage done to the tank ONLY
	self:Emote("ThunderingThrow", "137175") -- this seems to be the fastest way to determine which tank gets thrown, APPLIED is way too slow
	self:Log("SPELL_DAMAGE", "LightningFissure", 139467)
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
	self:Berserk(420) -- XXX Soft enrage, at this point you should have 4 pools up leaving very little room for activities -- real Berserk is not yet confirmed
	if self:Heroic() then self:Bar(138732, 60) end -- Ionization
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:IonizationRemoved(args)
	-- we could make this a bit more complicated check, to help raid awareness, but lets just leave it simple as this and see if we need to complicate thigns in 25 H
	if not UnitIsUnit("player", args.destName) then return end
	self:CloseProximity(args.spellId)
	if UnitDebuff("player", self:SpellName(137422)) then -- Focused Lightning
		self:OpenProximity("ej:7741", 8) -- reopen it if we have lightning chasing us too
	end
end

function mod:Ionization(args)
	self:Message(args.spellId, "Important", "Long")
	self:OpenProximity(args.spellId, 8)
	self:Bar(args.spellId, 92)
end


function mod:LightningStormDuration(args)
	self:Bar("storm_duration", 15, CL["cast"]:format(args.spellName), args.spellId) -- help with organizing raid cooldowns
end

function mod:LightningStorm(args)
	self:Message(args.spellId, "Important", "Long")
	self:Bar(args.spellId, 93)
	self:Bar("ej:7741", 26, 137399) -- Focused Lightning
	self:Bar(137162, 20) -- Static Burst
	self:Bar(137175, 30) -- Thundering Throw
end

function mod:ThunderingThrowSafe()
	self:SecondaryIcon(137175)
	self:CloseProximity(137175)
	if UnitDebuff("player", self:SpellName(137162)) then -- Focused Lightning
		self:OpenProximity("ej:7741", 5)
	end
end

function mod:ThunderingThrow(_, _, _, _, target)
	self:Message(137175, "Attention", "Alert")
	self:SecondaryIcon(137175, target)
	if not UnitIsUnit(target, "player") then -- no point opening proximity for the thrown tank
		self:CloseProximity("ej:7741") -- close this before opening another ( in case it was open )
		self:OpenProximity(137175, 14, target)
	end
end

do
	local prev = 0
	function mod:LightningFissure(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

function mod:FocusedLightningRemoved()
	if not UnitDebuff("player", self:SpellName(137422)) then
		self:PrimaryIcon("ej:7741") -- XXX Need to check if there can be 2 up in 25 man at same time
		self:CloseProximity("ej:7741")
		self:UnregisterUnitEvent("UNIT_AURA", "player")
	end
end

do
	local function warnFocusedLightning(spellId)
		local target = UnitName("boss1target")
		if not target then return end
		mod:TargetMessage("ej:7741", target, "Urgent", "Alarm", spellId)
		mod:PrimaryIcon("ej:7741", target)
		if UnitIsUnit(target, "player") then
			mod:RegisterUnitEvent("UNIT_AURA", "FocusedLightningRemoved", "player") -- There is no APPLIED or REMOVED CLEU event for this yet and using the explosion damage to remove icon and close proximity could be innacurate
			mod:Say("ej:7741", spellId)
			mod:OpenProximity("ej:7741", 8)
		end
	end
	function mod:FocusedLightning(args)
		self:CDBar("ej:7741", 11, args.spellId) -- XXX not sure if there is any point to have such a short bar for this
		self:ScheduleTimer(warnFocusedLightning, 0.2, args.spellId) -- if reliable enough this is lot faster then the next reliable event (cast is 1 sec so with 0.2 we gain 0.8 sec)
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
		if not UnitIsUnit(args.sourceName, "player") then return end
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
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end