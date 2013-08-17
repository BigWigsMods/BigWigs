--[[
TODO:
	Arcing Smash has double CLEU events, might loose one so pay attention if the spellId is gone and warning stops working
	keep an eye out for Imploding Energy events have only SPELL_DAMAGE atm 10N PTR
]]--

if GetBuildInfo() ~= "5.4.0" then return end -- 4th return is 50300 on the PTR ATM so can't use that
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Malkorok", 953, 846)
if not mod then return end
mod:RegisterEnableMob(71454)

--------------------------------------------------------------------------------
-- Locals
--

local smashCounter = 1
local slamCounter = 1
local breathCounter = 1
local arcingSmash = mod:SpellName(142826)
local marksUsed = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.custom_off_energy_marks = "Displaced Energy marker"
	L.custom_off_energy_marks_desc = "To help dispelling assignments, mark the people who have Displaced Energy on them with %s%s%s%s%s%s%s (in that order)(not all marks may be used), requires promoted or leader."
end
L = mod:GetLocale()
L.custom_off_energy_marks_desc = L.custom_off_energy_marks_desc:format(
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_1.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_2.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_3.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_4.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_5.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_6.blp:15\124t",
	"\124TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_7.blp:15\124t"
)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		142879, {142913, "FLASH", "PROXIMITY"}, -- Rage Phase
		"custom_off_energy_marks",
		142826, {142851, "PROXIMITY"}, {142842, "FLASH"}, 142986, {142990, "TANK"}, -- Non rage phase
		"berserk", "bosskill",
	}, {
		[142879] = 142879,
		["custom_off_energy_marks"] = L.custom_off_energy_marks,
		[142826] = -7896, -- Non rage phase
		["berserk"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	-- Rage Phase
	self:Log("SPELL_AURA_APPLIED", "DisplacedEnergyApplied", 142913)
	self:Log("SPELL_AURA_REMOVED", "DisplacedEnergyRemoved", 142913)
	self:Log("SPELL_CAST_SUCCESS", "DisplacedEnergy", 142913)
	self:Log("SPELL_CAST_START", "BloodRage", 142879)
	self:Log("SPELL_CAST_START", "ExpelMiasma", 143199) -- spell used at the end of rage phase
	-- Non rage phase
	self:Log("SPELL_AURA_APPLIED_DOSE" , "FatalStrike", 142990)
	self:Log("SPELL_CAST_START", "Breath", 142842)
	self:Log("SPELL_CAST_SUCCESS", "SeismicSlam", 142851)
	self:Log("SPELL_CAST_SUCCESS", "ArcingSmash", 142826)

	self:Death("Win", 71454)
end

function mod:OnEngage()
	wipe(marksUsed)
	self:Berserk(360)
	smashCounter = 1
	slamCounter = 1
	breathCounter = 1
	self:Bar(142826, 12, CL["count"]:format(arcingSmash, 1)) -- Arcing Smash
	self:Bar(142851, 5) -- Seismic Slam
	self:OpenProximity(142851, 5)
	self:Bar(142842, 59, CL["count"]:format(self:SpellName(142842), 1)) -- Breath
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Rage Phase

do
	function mod:DisplacedEnergyRemoved(args)
		if self:Me(args.destGUID) then
			self:CloseProximity(args.spellId)
		end
		if self.db.profile.custom_off_energy_marks then
			for i = 1, 7 do
				if marksUsed[i] == args.destName then
					marksUsed[i] = false
					SetRaidTarget(args.destName, 0)
				end
			end
		end
	end

	local function markEnergy(destName)
		for i = 1, 7 do
			if not marksUsed[i] then
				SetRaidTarget(destName, i)
				marksUsed[i] = destName
				return
			end
		end
	end
	local energyList, scheduled = mod:NewTargetList()
	local function warnDisplacedEnergy(spellId)
		mod:TargetMessage(spellId, energyList, "Urgent", "Alert")
		scheduled = nil
	end
	function mod:DisplacedEnergyApplied(args)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:OpenProximity(args.spellId, 8)
		end
		energyList[#energyList+1] = args.destName
		if not scheduled then
			self:ScheduleTimer(warnDisplacedEnergy, 0.1)
		end
		if self.db.profile.custom_off_energy_marks then
			markEnergy(args.destName)
		end
	end
end

function mod:DisplacedEnergy(args)
	self:Bar(args.spellId, 10)
end

function mod:BloodRage(args)
	wipe(marksUsed) -- just to be safe
	self:Message(args.spellId, "Neutral", "Long")
	self:StopBar(CL["count"]:format(self:SpellName(142842), breathCounter)) -- Breath
	self:CloseProximity(142851)
end

function mod:ExpelMiasma()
	self:Message(142879, "Neutral", "Long", CL["over"]:format(self:SpellName(142879)))
	self:OpenProximity(142851, 5)
	self:StopBar(142913) -- Displaced Energy
	breathCounter = 1
end

-- Non rage phase

function mod:FatalStrike(args)
	if args.amount > 8 and args.amount%3 == 0 then -- XXX this might need adjustment
		self:StackMessage(args.spellId, args.destName, args.amount, "Attention")
	end
end

function mod:Breath(args)
	self:Flash(args.spellId)
	self:Message(args.spellId, "Important", "Warning", CL["count"]:format(args.spellName, breathCounter))
	breathCounter = breathCounter + 1
	self:Bar(args.spellId, 59, CL["count"]:format(args.spellName, breathCounter))

	smashCounter = 1
	slamCounter = 1
	self:Bar(142826, 7, CL["count"]:format(arcingSmash, 1)) -- Arcing Smash
	self:Bar(142851, 5) -- Seismic Slam
end

do
	local slamTimers = {18, 18, 23}
	local slamTimer
	function mod:SeismicSlam(args)
		if not slamTimers[slamCounter] then return end -- don't do anything if we don't have timer
		if self:Heroic() then
			args.spellName = CL["add_spawned"]
		end
		-- don't think this needs a message
		-- if anything a soon message, since timers seem reliable
		slamTimer = self:ScheduleTimer("Message", slamTimers[slamCounter]-2, args.spellId, "Urgent", nil, CL["custom_sec"]:format(args.spellName, 2))
		self:Bar(args.spellId, slamTimers[slamCounter], args.spellName)
		slamCounter = slamCounter + 1
	end
end

function mod:ArcingSmash(args)
	self:Message(args.spellId, "Attention", nil, CL["count"]:format(args.spellName, smashCounter))
	smashCounter = smashCounter + 1
	self:CDBar(args.spellId, 17, CL["count"]:format(args.spellName, smashCounter))

	self:ScheduleTimer("Message", 4, 142986, "Urgent", "Alarm") -- Imploding Energy, don't wanna use SPELL_DAMAGE, and this seems accurate enough
	self:CDBar(142986, 9, self:SpellName(67792)) -- A bar with a text "Implosion" for when the damage actually happens, so people can time immunities. 67792 is just a random spell called "Implosion"
end

