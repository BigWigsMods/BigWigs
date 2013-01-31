--[[
TODO:
	Double check if proximity windows are opened and closed correctly
	keep en eye out for focused lightning in 25 man in case there are 2, because of ICON usage
	focused lightning removed is being kept track of with UNIT_AURA which is ugly expect CLEU events added for this ( not as of 10 N ptr )
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
		137313, "storm_duration", {137175, "PROXIMITY", "ICON"}, {139467, "FLASHSHAKE"},{"ej:7741", "PROXIMITY", "ICON", "SAY"}, 137162, {138375, "FLASHSHAKE"}, {138006, "FLASHSHAKE"}, "berserk", "bosskill",
	}, {
		[137313] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Log("SPELL_CAST_SUCCESS", "LightningStormDuration", 137313)
	self:Log("SPELL_CAST_START", "LightningStorm", 137313)
	self:Log("SPELL_AURA_REMOVED", "ThunderingThrowRemoved", 137371)
	self:Emote("ThunderingThrow", "137175") -- this seems to be the fastest way to determine which tank gets thrown, APPLIED is way too slow
	self:Log("SPELL_DAMAGE", "LightningFissure", 139467)
	self:Log("SPELL_CAST_SUCCESS", "FocusedLightning", 137399)
	self:Log("SPELL_CAST_SUCCESS", "StaticBurst", 137162)
	self:Log("SPELL_DAMAGE", "StaticWoundConduction", 138375)
	self:Log("SPELL_PERIODIC_DAMAGE", "ElectrifiedWaters", 138006)

	self:Death("Win", 69465)
end

function mod:OnEngage()
	self:Bar(137313, 137313, 93, 137313) -- Lightning Storm
	self:Bar(137175, 137175, 30, 137175) -- Thundering Throw
	self:Bar(137162, "~"..self:SpellName(137162), 7, 137162) -- Static Burst -- again, is there even a point for such a short bar?
	self:Berserk(420) -- XXX Soft enrage, at this point you should have 4 pools up leaving very little room for activities -- real Berserk is not yet confirmed
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:LightningStormDuration(args)
	self:Bar("storm_duration", CL["cast"]:format(args.spellName), 15, args.spellId) -- help with organizing raid cooldowns
end

function mod:LightningStorm(args)
	self:Message(args.spellId, args.spellName, "Important", args.spellId, "Long")
	self:Bar(args.spellId, args.spellName, 93, args.spellId)
end

function mod:ThunderingThrowRemoved()
	self:SecondaryIcon(137175)
	if UnitDebuff("player", self:SpellName(137162)) then -- Focused Lightning
		self:CloseProximity(137175)
		self:OpenProximity("ej:7741", 5)
	else
		self:CloseProximity(137175)
	end
end

function mod:ThunderingThrow(_, _, _, _, target)
	self:Message(137175, self:SpellName(137175), "Attention", 137175, "Alert")
	self:Bar(137175, self:SpellName(137175), 90, 137175)
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
			self:LocalMessage(args.spellId, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
			self:FlashShake(args.spellId)
		end
	end
end

function mod:FocusedLightningRemoved()
	if not UnitDebuff("player", self:SpellName(137162)) then
		self:PrimaryIcon("ej:7741") -- XXX Need to check if there can be 2 up in 25 man at same time
		self:CloseProximity("ej:7741")
		self:UnregisterUnitEvent("UNIT_AURA", "player")
	end
end

function mod:FocusedLightning(args)
	self:Bar("ej:7741", "~"..args.spellName, 11, args.spellId) -- XXX not sure if there is any point to have such a short bar for this
	self:TargetMessage("ej:7741", args.spellName, args.destName, "Urgent", args.spellId, "Alarm")
	self:PrimaryIcon("ej:7741", args.destName)
	if UnitIsUnit(args.destName, "player") then
		self:RegisterUnitEvent("UNIT_AURA", "FocusedLightningRemoved", "player") -- There is no APPLIED or REMOVED CLEU event for this yet and using the explosion damage to remove icon and close proximity could be innacurate
		self:Say("ej:7741", CL["say"]:format(args.spellName))
		self:OpenProximity("ej:7741", 5)
	end
end

function mod:StaticBurst(args)
	-- This is intentionally not a tank only warning!
	self:Message(args.spellId, args.spellName, "Attention", args.spellId)
	self:Bar(args.spellId, "~"..args.spellName, 23, args.spellId)
end

do
	local prev = 0
	function mod:StaticWoundConduction(args)
		if not UnitIsUnit(args.sourceName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(args.spellId, L["in_water"], "Personal", args.spellId, "Info")
			self:FlashShake(args.spellId)
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
			self:LocalMessage(args.spellId, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
			self:FlashShake(args.spellId)
		end
	end
end