--[[
TODO:
	think about some more if we could use multi target proximity on heroic too
	handle Windstorm over message on Quet'zal death
	keep revisitng the idea of targeted spear warning
]]--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Iron Qon", 930, 817)
if not mod then return end
mod:RegisterEnableMob(68078, 68079, 68080, 68081) -- Iron Qon, Ro'shak, Quet'zal, Dam'ren

--------------------------------------------------------------------------------
-- Locals
--
local UnitDebuff = UnitDebuff
local arcingLightning = {}
local openedForMe = nil
local smashCounter = 1
local spearTimer = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.molten_energy = "Molten Energy"
	L.molten_energy_desc = EJ_GetSectionInfo(6973)
	L.molten_energy_icon = 137221

	L.overload_casting = "Molten Overload casting"
	L.overload_casting_desc = "Warning for when Molten Overload is casting"
	L.overload_casting_icon = 137221

	L.arcing_lightning_cleared = "Raid is clear of Arcing Lightning"

	L.custom_off_spear_target = "Throw Spear Target"
	L.custom_off_spear_target_desc = "Try to warn for the Throw Spear target. This method is high on CPU usage and sometimes displays the wrong target so it is disabled by default.\n|cFFADFF2FTIP: Setting up TANK roles should help to increase the accuracy of the warning.|r"
	L.possible_spear_target = "Possible Spear"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"custom_off_spear_target",
		-6914, 136520, 139180, 135145,
		-6877, {137669, "FLASH"}, {136192, "ICON", "PROXIMITY"}, 77333,
		137221, "overload_casting", {-6870, "PROXIMITY"}, -6871, {137668, "FLASH"},
		134926, {134691, "TANK_HEALER"}, "molten_energy", -6917, "berserk", "bosskill",
	}, {
		["custom_off_spear_target"] = L.custom_off_spear_target,
		[-6914] = -6867, -- Dam'ren
		[-6877] = -6866, -- Quet'zal
		[137221] = -6865, -- Ro'shak
		[134926] = "general",
	}
end

function mod:OnBossEnable()
	-- Dam'ren
	self:Log("SPELL_AURA_APPLIED", "Freeze", 135145)
	self:Log("SPELL_DAMAGE", "FrozenBlood", 136520)
	self:Log("SPELL_CAST_SUCCESS", "DeadZone", 137226, 137227, 137228, 137229, 137230, 137231) -- figure out why it has so many spellIds
	-- Quet'zal
	self:Log("SPELL_AURA_REMOVED", "ArcingLightningRemoved", 136193)
	self:Log("SPELL_AURA_APPLIED", "ArcingLightningApplied", 136193)
	self:Log("SPELL_AURA_APPLIED", "LightningStormApplied", 136192)
	self:Log("SPELL_AURA_REMOVED", "LightningStormRemoved", 136192)
	self:Log("SPELL_DAMAGE", "StormCloud", 137669)
	self:Log("SPELL_AURA_APPLIED", "Windstorm", 136577)
	-- Ro'shak
	self:Log("SPELL_DAMAGE", "BurningCinders", 137668)
	self:Log("SPELL_AURA_APPLIED", "Scorched", 134647)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Scorched", 134647)
	self:Log("SPELL_AURA_APPLIED", "MoltenOverloadApplied", 137221)
	self:Log("SPELL_AURA_REMOVED", "MoltenOverloadRemoved", 137221)
	-- General
	self:Log("SPELL_SUMMON", "ThrowSpear", 134926)
	self:Log("SPELL_AURA_APPLIED", "Impale", 134691)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Impale", 134691)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4", "boss5")

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Deaths", 68079, 68080, 68081) -- Ro'shak, Quet'zal, Dam'ren
	self:Death("Win", 68078) -- Iron Qon
end

function mod:OnEngage()
	openedForMe = nil
	self:Berserk(720)
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "PowerWarn", "boss2")
	self:OpenProximity(-6870, 10)
	self:CDBar(134926, 33) -- Throw spear
	wipe(arcingLightning)
	if self:Heroic() then
		self:CloseProximity(-6870)
		self:OpenProximity(136192, 12) -- Lightning Storm
		self:Bar(77333, 17) -- Whirling Winds
		self:Bar(136192, 20) -- Arcing Lightning
	end
	smashCounter = 1
	if self.db.profile.custom_off_spear_target then
		spearTimer = nil
		self:ScheduleTimer("StartSpearScan", 20) -- start watching boss1target in 20 sec
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	-- Spear scanning
	local UnitIsUnit, UnitExists = UnitIsUnit, UnitExists
	local boss1target, prev = "n", 0 -- "n" as in none, so I don't have to bother with nil checks
	local function watchBoss1TargetChange()
		-- every check in new line to help debugging
		if not UnitExists("boss1target") then return end
		if UnitIsUnit(boss1target, "boss2target") then return end -- mount tank can't be spear target
		if UnitIsUnit(boss1target, "boss1target") then return end -- boss1target have not changed yet, so probably not the spear target ( not sure if they are valid target )
		if mod:Tank("boss1target") then return end -- this should not be needed, but ohh well, lets just get shit working first, right now at least it clears up the false tank warnings
		-- XXX mess around with these if you want further testing, I could not get them working
		--if UnitExists("boss2target") and UnitThreatSituation(boss1target, "boss2target") == 3 then return end     -- does not seem to work
		--if UnitExists("boss3target") and UnitThreatSituation(boss1target, "boss3target") == 3 then return end     -- does not seem to work
		--if UnitExists("boss4target") and UnitThreatSituation(boss1target, "boss4target") == 3 then return end     -- does not seem to work
		--if UnitThreatSituation("boss1target") == 3 then return end -- having agro on something, persumably boss1, however boss1 is not a valid unit so can't specifically check for that
		-- assuming spear targets don't jump to top of threat list or make UnitThreatSituation("player") return 3

		-- at this point boss1target has changed

		boss1target = UnitName("boss1target")
		local t = GetTime() -- throttle as we have no timer cancelling at the moment
		if t-prev > 0.5 then
			mod:TargetMessage(134926, boss1target, "Urgent", nil, L["possible_spear_target"])
			prev = t
		end
		-- XXX add icon, flash, sound once the warning is working

		-- commented for now because sometimes the 2nd warning is the accurate for some reason
		-- uncomment to test when to cancel and unregister stuff
		--mod:CancelTimer(spearTimer)
		--spearTimer = nil
	end
	function mod:StartSpearScan()
		boss1target = (UnitName("boss1target")) or "n"
		if not spearTimer then
			spearTimer = mod:ScheduleRepeatingTimer(watchBoss1TargetChange, 0.05)
		end
	end
	function mod:ThrowSpear(args)
		if UnitExists("boss1") then return end -- don't warn in last phase
		self:CDBar(args.spellId, 33)
		self:Message(args.spellId, "Urgent") -- keep this in case TargetMessage fails to find a target
		if self.db.profile.custom_off_spear_target then
			self:CancelTimer(spearTimer)
			spearTimer = nil
			self:ScheduleTimer("StartSpearScan", 25) -- start watching boss1target in 25 sec
		end
	end
end

local function closeLightningStormProximity()
	for i=1, GetNumGroupMembers() do
		local name = GetRaidRosterInfo(i)
		if UnitDebuff(name, mod:SpellName(136193)) then -- don't close the proximity if someone can spread the debuff
			return
		end
	end
	mod:CloseProximity(136192)
	if mod:MobId(UnitGUID("boss2")) == 68079 or (mod:Heroic() and mod:MobId(UnitGUID("boss4")) == 68081) then -- p1 or heroic p3
		mod:OpenProximity(-6870, 10)
	end
	mod:Message(136192, "Positive", nil, L["arcing_lightning_cleared"])
end

-- Dam'ren

function mod:Freeze(args)
	local _, _, _, _, _, duration = UnitDebuff(args.destName, args.spellName)
	self:Bar(args.spellId, duration) -- so people can use personal cooldowns for when the damage happens
end

do
	local prev = 0
	function mod:FrozenBlood(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

function mod:DeadZone(args)
	self:Message(-6914, "Attention")
	self:Bar(-6914, 16)
end

-- Quet'zal

function mod:ArcingLightningRemoved(args)
	if not self:Heroic() then
		for i, v in next, arcingLightning do
			if v == args.destName then
				tremove(arcingLightning, i)
				break
			end
		end
		if self:Me(args.destGUID) then
			openedForMe = nil
		end
		if not openedForMe then
			self:OpenProximity(136192, 12, arcingLightning)
		end
	end
	closeLightningStormProximity()
end

function mod:ArcingLightningApplied(args)
	if self:Heroic() then return end -- XXX don't forget to remove this if we decided to use multi target proximity on heroic too
	if self:Me(args.destGUID) then
		openedForMe = true
		self:OpenProximity(136192, 12)
	else
		arcingLightning[#arcingLightning+1] = args.destName
		if not openedForMe then
			self:OpenProximity(136192, 12, arcingLightning)
		end
	end
end

function mod:LightningStormApplied(args)
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetMessage(args.spellId, args.destName, "Urgent") -- no point for sound since the guy stunned can't do anything
	-- XXX we could potentially be intelligent when using a message here and only warn for the closet person to free the stormed guy, but we need :IsInRange for that
	self:Bar(args.spellId, self:MobId(UnitGUID("boss3")) == 68080 and 20 or 40)
end

function mod:LightningStormRemoved(args)
	self:PrimaryIcon(args.spellId)
end

do
	local prev = 0
	function mod:StormCloud(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

function mod:Windstorm(args)
	if self:Me(args.destGUID) then
		self:Message(-6877, "Attention") -- lets leave it here to warn people who fail and step back into the windstorm
	end
end

-- Ro'shak

do
	local prev = 0
	function mod:BurningCinders(args)
		if not self:Me(args.destGUID) then return end
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "Personal", "Info", CL["underyou"]:format(args.spellName))
			self:Flash(args.spellId)
		end
	end
end

function mod:Scorched(args)
	if self:Me(args.destGUID) then
		self:Message(-6871, "Important", nil, CL["count"]:format(args.spellName, args.amount or 1))
	end
	if self:Heroic() and self:MobId(UnitGUID("boss4")) == 68081 then -- Dam'ren is active and heroic
		self:Bar(-6870, 16) -- Unleashed Flame
	else
		self:CDBar(-6870, 6) -- this is good so people know how much time they have to gather/spread
	end
end

do
	local prevPower = 0
	function mod:MoltenOverloadRemoved()
		prevPower = 0
		self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "PowerWarn", "boss2")
	end
	function mod:PowerWarn(unitId)
		local power = UnitPower(unitId)
		if power > 64 and prevPower == 0 then
			prevPower = 65
			self:Message("molten_energy", "Attention", nil, ("%s (%d%%)"):format(L["molten_energy"], power), L.molten_energy_icon)
		elseif power > 74 and prevPower == 65 then
			prevPower = 75
			self:Message("molten_energy", "Urgent", nil, ("%s (%d%%)"):format(L["molten_energy"], power), L.molten_energy_icon)
		elseif power > 84 and prevPower == 75 then
			prevPower = 85
			self:Message("molten_energy", "Important", nil, ("%s (%d%%)"):format(L["molten_energy"], power), L.molten_energy_icon)
		elseif power > 94 and prevPower == 85 then
			prevPower = 95
			self:Message("molten_energy", "Important", nil, ("%s (%d%%)"):format(L["molten_energy"], power), L.molten_energy_icon)
		end
	end
end

function mod:MoltenOverloadApplied(args)
	self:Message("overload_casting", "Important", "Alert", args.spellId)
	self:Bar("overload_casting", 10, CL["cast"]:format(args.spellName), args.spellId) -- XXX don't think there is any point to this, maybe coordinating raid cooldowns?
	self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "boss2")
end

-- General

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 139172 then -- Whirling Wind
		self:Message(77333, "Attention")
		self:Bar(77333, 30)
	elseif spellId == 139181 then -- Frost Spike
		self:Message(139180, "Attention")
		self:CDBar(139180, 13)
	elseif spellId == 137656 then -- Rushing Winds - start Wind Storm bar here, should be more accurate then unitaura on player
		self:Message(-6877, "Positive", nil, CL["over"]:format(self:SpellName(136577)), 136577) -- Wind Storm -- XXX This fires when Quet'zal dies, should maybe try prevent that, sadly this happens before UNIT_DIED or ENGAGE with nil
		self:Bar(-6877, 70) -- Wind Storm
	elseif spellId == 50630 then -- Eject All Passangers aka heroic phase change
		if unit == "boss2" then -- Ro'shak
			self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "boss2")
			self:CloseProximity(-6870)
			self:StopBar(137221) -- Molten Overload
			self:StopBar(134628) -- Unleashed Flame
			self:Bar(-6877, 50) -- Windstorm
			self:Bar(136192, 17) -- Arcing Lightning -- XXX not sure if it has to be restarted here for heroic
			self:OpenProximity(136192, 12) -- Lightning Storm -- assume 10 (use 12 to be safe)
			self:StopBar(77333) -- Whirling Wind
		elseif unit == "boss3" then
			self:StopBar(-6877) -- Windstorm
			self:StopBar(136192) -- Arcing Lightning
			closeLightningStormProximity()
			self:OpenProximity(-6870, 10)
			self:Bar(-6914, 7) -- Dead Zone
			self:StopBar(139180) -- Frost Spike
			self:CDBar(-6870, 17)
		elseif unit == "boss4" then
			self:StopBar(134628) -- Unleashed Flame
			self:StopBar(-6914) -- Dead zone
			self:OpenProximity(136192, 12) -- Lightning Storm -- assume 10 (use 12 to be safe)
			self:Bar(-6917, 63, ("%s (%d)"):format(self:SpellName(136146), 1)) -- Fist Smash -- timer verified
		end
	elseif spellId == 136146 then -- Fist Smash
		self:Message(-6917, "Urgent", "Alarm", ("%s (%d)"):format(spellName, smashCounter))
		smashCounter = smashCounter + 1
		self:Bar(-6917, 7.5, CL["cast"]:format(spellName))
		if self:Heroic() then
			self:CDBar(-6917, 25, ("%s (%d)"):format(spellName, smashCounter)) -- 25 - 30
		else
			self:Bar(-6917, 20, ("%s (%d)"):format(spellName, smashCounter))
		end
	end
end

function mod:Impale(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "Positive")
	self:CDBar(args.spellId, 20)
end

function mod:ThrowSpear(args)
	if not UnitExists("boss1") then -- don't warn in last phase
		self:CDBar(args.spellId, 33)
		self:Message(args.spellId, "Urgent")
	end
end

function mod:Deaths(args)
	if args.mobId == 68079 and not self:Heroic() then -- Ro'shak
		self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "boss2")
		self:CloseProximity(-6870)
		self:StopBar(137221) -- Molten Overload
		self:StopBar(134628) -- Unleashed Flame
		self:Bar(-6877, 50) -- Windstorm
		self:Bar(136192, 17) -- Arcing Lightning
		self:OpenProximity(136192, 12) -- Lightning Storm -- assume 10 (use 12 to be safe)
	elseif args.mobId == 68080 then -- Quet'zal
		if not self:Heroic() then
			self:StopBar(-6877) -- Windstorm
			self:StopBar(136192) -- Arcing Lightning
			self:Bar(-6914, 7) -- Dead Zone
		end
		closeLightningStormProximity()
	elseif args.mobId == 68081 then -- Dam'ren
		self:StopBar(-6914) -- Dead zone
		self:Bar(-6917, 30) -- Fist Smash
	end
end
