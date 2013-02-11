--[[
TODO:
	figure out/verify real lingering gaze range
	there are no CLEU events for blue and red ray controllers as of 10 N PTR, so keep an eye out for these
	verify that red ray controller gets 3 debuffs too with same names
	consider maybe if remaining red add is 0 don't announce it
	somehow verify overall life drain duration
	disintegration beam message might be too long, shorten it maybe?
	figure out where to start ForceOfWill in the DisintegrationBeam phase
]]--
if select(4, GetBuildInfo()) < 50200 then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Durumu the Forgotten", 930, 818)
if not mod then return end
mod:RegisterEnableMob(68036)

--------------------------------------------------------------------------------
-- Locals
--
local forceOfWill = mod:SpellName(136932)
local blueRayController, redRayController = nil, nil
local pName = UnitName("player")
local redAddLeft = 3
local lifedranJumps = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.rays_spawn = "Rays spawn"
	L.ray_controller = "Ray controller"
	L.ray_controller_desc = "Announce the ray direction controllers for the red and blue rays."
	L.ray_controller_icon = 22581 -- hopefully some fitting icon
	L.red_ray_controller = "You are the |c000000FFBlue|r ray controller"
	L.blue_ray_controller = "You are the |c00FF0000Red|r ray controller"
	L.red_spawn_trigger = "The Infrared Light reveals a Crimson Fog!"
	L.blue_spawn_trigger = "The Blue Rays reveal an Azure Eye!"
	L.red_add = "|c00FF0000Red|r add"
	L.blue_add = "|c000000FFBlue|r add"
	L.clockwise = "Clockwise"
	L.counter_clockwise = "Counter clockwise"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{133767, "TANK"}, {133765, "TANK_HEALER"}, {138467, "PROXIMITY", "FLASH"}, {136932, "FLASH"}, {"ej:6891", "FLASH"}, "ej:6898", "ej:6892",
		{133798, "ICON"}, "ej:6882", 140502,
		"berserk", "bosskill",
	}, {
		[133767] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_PERIODIC_DAMAGE", "EyeSore", 140502)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "DisintegrationBeam", "boss1")
	self:Log("SPELL_AURA_REMOVED", "LifeDrainRemoved", 133798)
	self:Log("SPELL_AURA_APPLIED", "LifeDrainApplied", 133798)
	self:Emote("HungryEyeStart", "133795") -- this is faster than CLEU
	self:Log("SPELL_CAST_SUCCESS", "CrimsonBloom", 136122)
	self:Emote("RedAdd", L["red_spawn_trigger"])
	self:Emote("BlueAdd", L["blue_spawn_trigger"])
	self:Log("SPELL_AURA_APPLIED", "RedRayController", 133732) -- this is the stacking debuff, because there is no similar CLEU like the for blue
	self:Log("SPELL_AURA_APPLIED_DOSE", "RedRayController", 133732)
	self:Log("SPELL_AURA_APPLIED", "BlueRayController", 133675) -- this is the one that keept racks of you being in ray
	self:Emote("BlueRay", "134122")
	self:Emote("RedRay", "134123")
	self:Emote("YellowRay", "134124")
	self:Log("SPELL_CAST_SUCCESS", "ForceOfWill", 136932)
	self:Log("SPELL_DAMAGE", "LingeringGazeDamage", 134044)
	self:Log("SPELL_CAST_START", "LingeringGaze", 138467)
	self:Log("SPELL_CAST_START", "HardStare", 133765) -- the reason we have this too is to help healers pre shield, and if shield fully absorbs, Serious Wound does not happen
	self:Log("SPELL_AURA_APPLIED_DOSE", "SeriousWound", 133767) -- this is for the tanks
	self:Log("SPELL_AURA_APPLIED", "SeriousWound", 133767)
	self:Death("Deaths", 68036, 69052, 69050) -- Boss, Blue add, Red add
end

function mod:OnEngage()
	self:Berserk(600) -- XXX Assumed
	self:Bar(138467, "~"..self:SpellName(138467), 15, 138467) -- Lingering Gaze
	self:Bar(136932, forceOfWill, 31, 136932)
	blueRayController, redRayController = nil, nil
	redAddLeft = 3
	lifedranJumps = 0
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:EyeSore(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:LocalMessage(args.spellId, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
			self:Flash(args.spellId)
		end
	end
end

function mod:DisintegrationBeam(_, spellName, _, _, spellId)
	if spellId == 136316 then -- clokwise
		self:Message("ej:6892", ("%s - %s"):format(spellName, L["clockwise"]), "Attention", 133778)
	elseif spellId == 133775 then -- counter clokwise
		self:Message("ej:6892", ("%s - %s"):format(spellName, L["counter_clockwise"]), "Attention", 133778)
	end
end

function mod:LifeDrainRemoved(args)
	self:PrimaryIcon(args.spellId)
end

function mod:LifeDrainApplied(args)
	self:PrimaryIcon(args.spellId, args.destName)
	lifedranJumps = lifedranJumps + 1
	self:TargetMessage(args.spellId, ("%s - %d%%"):format(args.spellName, lifedranJumps*60), args.destName, "Important", args.spellId, "Alert") -- maybe this should just be the amount of jumps
end

function mod:HungryEyeStart(_, _, _, _, target)
	self:TargetMessage(133798, 133798, target, "Important", 133798, "Alert")
	self:Bar(133798, CL["cast"]:format(self:SpellName(133798)), 15, 133798) -- XXX somehow verify overall 15 sec duration
	self:PrimaryIcon(133798, target)
end

local function annonunceRemainingAdds()
	mod:Message("ej:6892", ("%s (%d)"):format(L["red_add"], redAddLeft), "Urgent", 136154)
end

function mod:CrimsonBloom(args)
	redAddLeft = redAddLeft - 1
	annonunceRemainingAdds()
end

function mod:RedAdd(_, sender)
	self:Message("ej:6892", L["red_add"], "Urgent", 136154)
end

function mod:BlueAdd(_, sender)
	self:Message("ej:6898",L["blue_add"], "Urgent", 136177)
end

function mod:RedRayController(args)
	-- since CLEUs are messed up, we count the amount of debuffs with same name to determine the ray controller
	-- 3 debuffs with same name means you are the controller
	local amount = 0
	for i=1, 100 do
		if UnitDebuff("player", i) == self:SpellName(133732) then -- XXX verify that the method used for blue works for red too
			amount = amount + 1
		end
	end
	if amount == 3 and redRayController ~= pName then -- try not warn if we know already that we are the controller
		redRayController = pName
		self:LocalMessage("ray_controller", L["red_ray_controller"], "Attention", args.spellId, "Long") -- can't be "Personal" cuz that'd make it too blue
	elseif amount ~= 3 then
		redRayController = nil -- we are not the ray controller
	end
end

function mod:BlueRayController(args)
	-- since CLEUs are messed up, we count the amount of debuffs with same name to determine the ray controller
	-- 3 debuffs with same name means you are the controller
	local amount = 0
	for i=1, 100 do
		if UnitDebuff("player", i) == self:SpellName(133675) then
			amount = amount + 1
		end
	end
	if amount == 3 and blueRayController ~= pName then -- try not warn if we know already that we are the controller
		blueRayController = pName
		self:LocalMessage("ray_controller", L["blue_ray_controller"], "Attention", args.spellId, "Long") -- can't be "Personal" cuz that'd make it too blue
	elseif amount ~= 3 then
		blueRayController = nil -- we are not the ray controller
	end
end

function mod:YellowRay(_, sender, _, _, target)
	self:StopBar(136932) -- Force of Will -- XXX double check if this is not too early to stop the bar
	self:Bar("ej:6891", L["rays_spawn"], 10, "inv_misc_gem_variety_02") -- only spawn this bar in one of the functions
	if UnitIsUnit("player", target) then
		self:LocalMessage("ej:6891", CL["you"]:format("|c00FFFF00"..sender.."|r"), "Positive", 134124, "Alert")
	end
end

function mod:RedRay(_, sender, _, _, target)
	if UnitIsUnit("player", target) then
		self:LocalMessage("ej:6891", CL["you"]:format("|c00FF0000"..sender.."|r"), "Positive", 134123, "Alert")
	end
end

function mod:BlueRay(_, sender, _, _, target)
	if UnitIsUnit("player", target) then
		self:LocalMessage("ej:6891", CL["you"]:format("|c000000FF"..sender.."|r"), "Positive", 134122, "Alert")
	end
end


function mod:ForceOfWill(args)
	if UnitIsUnit("player", args.destName) then
		self:LocalMessage(args.spellId, CL["you"]:format(args.spellName), "Personal", args.spellId, "Long")
	else
		self:Message(args.spellId, args.spellName, "Attention", args.spellId)
	end
	self:Bar(args.spellId, args.spellName, 20, args.spellId)
end

do
	local prev = 0
	function mod:LingeringGazeDamage(args)
		if not UnitIsUnit(args.destName, "player") then return end
		local t = GetTime()
		if t-prev > 1 then -- use 1 sec instead of the usual 2, getting out this fast matters
			prev = t
			self:LocalMessage(138467, CL["underyou"]:format(args.spellName), "Personal", args.spellId, "Info")
			self:Flash(138467)
		end
	end
end

do
	local function closeLingeringProximity(spellId)
		mod:CloseProximity(spellId)
	end
	function mod:LingeringGaze(args)
		self:Message(args.spellId, args.spellName, "Urgent", args.spellId, "Alarm")
		self:Bar(args.spellId, "~"..args.spellName, 25, args.spellId)
		self:OpenProximity(args.spellId, 8) -- EJ says 15 but looks lot less
		self:ScheduleTimer(closeLingeringProximity, 3, args.spellId) -- cast is 2 sec according to tooltip, but lets add an extra sec for travel time
	end
end

function mod:HardStare(args)
	self:Bar(args.spellId, args.spellName, 12, args.spellId)
end

function mod:SeriousWound(args)
	args.amount = args.amount or 1
	self:LocalMessage(args.spellId, CL["stack"], "Attention", args.spellId, "Info", args.destName, args.amount, args.spellName)
end

function mod:Deaths(args)
	if args.mobId == 68036 then -- Boss
		self:Win()
	elseif args.mobId == 69050 then -- Red add
		redAddLeft = redAddLeft - 1
		annonunceRemainingAdds()
	end
end
