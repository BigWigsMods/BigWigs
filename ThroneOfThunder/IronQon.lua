
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Iron Qon", 930, 817)
if not mod then return end
mod:RegisterEnableMob(68078, 68079, 68080, 68081) -- Iron Qon, Ro'shak, Quet'zal, Dam'ren

--------------------------------------------------------------------------------
-- Locals
--

local arcingLightning = mod:SpellName(136193)
local phase, smashCounter = 1, 1
local quetzalDead = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.molten_energy = "Molten Energy"
	L.molten_energy_desc = select(2, EJ_GetSectionInfo(6973))
	L.molten_energy_icon = 137221

	L.arcing_lightning_cleared = "Raid clear of Arcing Lightning"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-6914, 136520, 139180, 135145,
		-6877, {137669, "FLASH"}, {136192, "ICON", "PROXIMITY", "SAY"}, {136193, "PROXIMITY"}, 77333,
		"molten_energy", 137221, {-6870, "PROXIMITY"}, -6871, {137668, "FLASH"},
		{134926, "FLASH", "ICON", "SAY"}, {134691, "TANK_HEALER"}, -6917, "berserk", "bosskill",
	}, {
		[-6914] = -6867, -- Dam'ren
		[-6877] = -6866, -- Quet'zal
		["molten_energy"] = -6865, -- Ro'shak
		[134926] = "general",
	}
end

function mod:OnBossEnable()
	-- Dam'ren
	self:Log("SPELL_AURA_APPLIED", "Freeze", 135145)
	self:Log("SPELL_DAMAGE", "FrozenBlood", 136520)
	self:Log("SPELL_MISSED", "FrozenBlood", 136520)
	self:Log("SPELL_CAST_SUCCESS", "DeadZone", 137226, 137227, 137228, 137229, 137230, 137231) -- all dem shields
	-- Quet'zal
	self:Log("SPELL_AURA_APPLIED", "ArcingLightningApplied", 136193)
	self:Log("SPELL_AURA_REMOVED", "ArcingLightningRemoved", 136193)
	self:Log("SPELL_AURA_APPLIED", "LightningStormApplied", 136192)
	self:Log("SPELL_AURA_REMOVED", "LightningStormRemoved", 136192)
	self:Log("SPELL_DAMAGE", "StormCloud", 137669)
	self:Log("SPELL_MISSED", "StormCloud", 137669)
	self:Log("SPELL_AURA_APPLIED", "Windstorm", 136577)
	-- Ro'shak
	self:Log("SPELL_DAMAGE", "BurningCinders", 137668)
	self:Log("SPELL_MISSED", "BurningCinders", 137668)
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
	self:Berserk(720)
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "PowerWarn", "boss2")
	self:CDBar(134926, 33) -- Throw Spear
	self:ScheduleTimer("StartSpearScan", 25)
	if self:Heroic() then
		self:OpenProximity(136192, 12) -- Lightning Storm (12 to be safe)
		self:Bar(136192, 20) -- Lightning Storm
		self:Bar(77333, 17) -- Whirling Winds
	else
		self:OpenProximity(-6870, 10) -- Unleashed Flame
	end
	phase, smashCounter = 1, 1
	quetzalDead = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	-- Spear target scanning
	local UnitDetailedThreatSituation, UnitExists, UnitIsUnit = UnitDetailedThreatSituation, UnitExists, UnitIsUnit
	local spearTimer, spearStartTimer = nil, nil
	local initialTarget = nil
	local function checkSpearTarget()
		if not UnitExists("boss1target") or mod:Tank("boss1target") or UnitDetailedThreatSituation("boss1target", "boss2") then return end

		-- healer aggro in p1
		local tanking, status = UnitDetailedThreatSituation("boss1target", "boss1")
		if tanking or status == 3 then return end
		if initialTarget and UnitIsUnit("boss1target", initialTarget) then return end

		-- blizzard decided to let eminence healing be safe
		local _, class = UnitClass("boss1target")
		if class == "MONK" and mod:Range("boss1target", "boss2target") < 15 then return end

		local name = mod:UnitName("boss1target")
		mod:TargetMessage(134926, name, "Urgent", "Alarm", nil, nil, true)
		mod:SecondaryIcon(134926, name)
		if UnitIsUnit("player", "boss1target") then
			mod:Flash(134926)
			mod:Say(134926)
		end
		mod:StopSpearScan()
	end

	function mod:StartSpearScan()
		if not spearTimer then
			if phase == 1 and UnitExists("boss1target") and UnitGroupRolesAssigned("boss1target") ~= "DAMAGER" then -- unassigned or healer (or tank, but they're already ignored)
				initialTarget = self:UnitName("boss1target")
			else
				initialTarget = nil
			end
			spearTimer = self:ScheduleRepeatingTimer(checkSpearTarget, 0.2)
		end
	end
	function mod:StopSpearScan()
		self:CancelTimer(spearStartTimer)
		self:CancelTimer(spearTimer)
		spearTimer = nil
	end

	function mod:ThrowSpear(args)
		if phase == 4 then return end -- don't warn in last phase
		if spearTimer then -- didn't find a target
			self:Message(args.spellId, "Urgent", "Alarm")
		end
		self:StopSpearScan()
		self:CDBar(args.spellId, 33)
		spearStartTimer = self:ScheduleTimer("StartSpearScan", 25)
		self:ScheduleTimer("SecondaryIcon", 3, args.spellId) -- wait until the lines go out (mark is quicker to spot than the spear in the ground)
	end
end

-- Dam'ren

function mod:Freeze(args)
	local _, _, _, _, _, duration = UnitDebuff(args.destName, args.spellName)
	self:Bar(args.spellId, duration, CL["incoming"]:format(args.spellName)) -- so people can use personal cooldowns for when the damage happens
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

do
	local everyoneElse, scheduled = {}, nil
	local function checkArcLightning(spellName, checkOpen)
		local debuffs = nil
		wipe(everyoneElse)
		-- seems easier than table searching/removing/inserting. multi-target should take a name-keyed table ;[
		if not mod.isEngaged then return end -- This can run after wipe, so check if the encounter is engaged
		for unit in mod:IterateGroup() do
			if UnitDebuff(unit, spellName) then
				debuffs = true
			elseif UnitAffectingCombat(unit) then -- XXX doesn't update for bres/ss/reincarnate
				everyoneElse[#everyoneElse+1] = mod:UnitName(unit)
			end
		end
		if not debuffs then
			mod:Message(136193, "Positive", nil, L["arcing_lightning_cleared"], false)
		end
		scheduled = nil
		if mod:LFR() then return end

		if UnitDebuff("player", spellName) then
			mod:OpenProximity(136193, 12, everyoneElse) -- open multi-target proximity if you have Arcing Lighning
		elseif checkOpen then
			mod:CloseProximity(136193) -- close multi-target
			-- reopen Lightning Storm/Unleashed Flame
			if not mod:Heroic() then
				if phase == 2 then
					mod:OpenProximity(136192, 12) -- Lightning Storm
				end
			elseif phase == 3 then -- Dam'ren + Ro'shak
				mod:OpenProximity(-6870, 10) -- Unleashed Flame
			elseif not quetzalDead then
				mod:OpenProximity(136192, 12) -- Lightning Storm
			end
		end
	end

	function mod:ArcingLightningRemoved(args)
		if not scheduled then
			scheduled = self:ScheduleTimer(checkArcLightning, 0.5, args.spellName, true)
		end
	end

	function mod:ArcingLightningApplied(args)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "Personal", "Alert", CL["you"]:format(args.spellName))
			self:TargetBar(args.spellId, 30, args.destName)
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(checkArcLightning, 0.5, args.spellName)
		end
	end
end

function mod:LightningStormApplied(args)
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetMessage(args.spellId, args.destName, "Urgent") -- no point for sound since the guy stunned can't do anything
	self:Bar(args.spellId, 20)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
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
		self:StopBar(136192) -- Lightning Storm
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

do
	local prev = 0
	function mod:Scorched(args)
		if self:Me(args.destGUID) then
			local amount = args.amount or 1
			self:Message(-6871, "Important", amount > 1 and "Warning", CL["count"]:format(args.spellName, amount))
		end
		local t = GetTime()
		if t-prev > 1 then
			self:CDBar(-6870, phase == 3 and 33 or 8) -- apparently won't happen during Dead Zone, so can be quite delayed while Dam'ren is up
			prev = t
		end
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
			self:Message("molten_energy", "Important", "Long", ("%s (%d%%)"):format(L["molten_energy"], power), L.molten_energy_icon)
		elseif power > 94 and prevPower == 85 then
			prevPower = 95
			self:Message("molten_energy", "Important", "Long", ("%s (%d%%)"):format(L["molten_energy"], power), L.molten_energy_icon)
		end
	end
end

function mod:MoltenOverloadApplied(args)
	self:Message(args.spellId, "Important") -- message should be WIPE IT!
	self:Bar(args.spellId, 10, CL["cast"]:format(args.spellName))
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
	elseif spellId == 137656 then -- Rushing Winds
		if phase == 2 then
			self:Message(-6877, "Positive", nil, CL["over"]:format(self:SpellName(-6877))) -- Windstorm
			self:Bar(-6877, 70) -- Windstorm
			self:CDBar(136192, 17) -- Lightning Storm
		end
	elseif spellId == 50630 then -- Eject All Passangers (Heroic phase change)
		self:StopSpearScan()
		if unit == "boss2" then -- Ro'shak
			phase = 2
			self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "boss2")
			self:StopBar(137221) -- Molten Overload
			self:StopBar(-6870) -- Unleashed Flame
			self:StopBar(77333) -- Whirling Wind
			self:CDBar(134926, 33) -- Throw Spear
			self:ScheduleTimer("StartSpearScan", 25)
			self:Bar(-6877, 50) -- Windstorm
		elseif unit == "boss3" then -- Quet'zal
			phase = 3
			self:StopBar(139180) -- Frost Spike
			self:StopBar(-6877) -- Windstorm
			self:StopBar(136192) -- Lightning Storm
			if not UnitDebuff("player", arcingLightning) then
				self:CloseProximity(136192) -- Lightning Storm
				self:OpenProximity(-6870, 10) -- Unleashed Flame
			end
			self:CDBar(-6870, 17) -- Unleashed Flame
			self:CDBar(134926, 33) -- Throw Spear
			self:ScheduleTimer("StartSpearScan", 25)
			self:Bar(-6914, 7) -- Dead Zone
		elseif unit == "boss4" then -- Dam'ren
			phase = 4
			self:StopBar(-6870) -- Unleashed Flame
			self:StopBar(-6914) -- Dead Zone
			if not UnitDebuff("player", arcingLightning) then
				self:CloseProximity(-6870) -- Unleashed Flame
				self:OpenProximity(136192, 12) -- Lightning Storm (12 to be safe)
			end
			self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "PowerWarn", "boss2") -- Ro'shak comes down after 12 seconds
			self:Bar(136192, 10) -- Lightning Storm
			self:Bar(-6917, 63, CL["count"]:format(self:SpellName(136146), 1)) -- Fist Smash
		end
	elseif spellId == 136146 then -- Fist Smash
		self:Message(-6917, "Urgent", "Alarm", ("%s (%d)"):format(spellName, smashCounter))
		smashCounter = smashCounter + 1
		self:Bar(-6917, 7.5, CL["cast"]:format(spellName))
		if self:Heroic() then
			self:CDBar(-6917, 25, CL["count"]:format(spellName, smashCounter)) -- 25 - 30
		else
			self:Bar(-6917, 20, CL["count"]:format(spellName, smashCounter))
		end
	end
end

function mod:Impale(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Positive", amount > 1 and "Warning")
	self:CDBar(args.spellId, 20)
end

function mod:Deaths(args)
	if not self:Heroic() then
		phase = phase + 1
		self:StopSpearScan()
		self:ScheduleTimer("StartSpearScan", 25)
	end
	if args.mobId == 68079 then
		-- Ro'shak
		self:UnregisterUnitEvent("UNIT_POWER_FREQUENT", "boss2")
		self:StopBar(-6870) -- Unleashed Flame
		if not self:Heroic() then
			self:StopBar(137221) -- Molten Overload
			self:CloseProximity(-6870) -- Unleashed Flame
			self:OpenProximity(136192, 12) -- Lightning Storm (12 to be safe)
			self:CDBar(134926, 33) -- Throw Spear
			self:Bar(-6877, 50) -- Windstorm
			self:Bar(136192, 17) -- Lightning Storm
		end
	elseif args.mobId == 68080 then
		-- Quet'zal
		self:StopBar(136192) -- Lightning Storm
		if not UnitDebuff("player", arcingLightning) or self:LFR() then
			self:CloseProximity(136192) -- Lightning Storm
		end
		if not self:Heroic() then
			self:StopBar(-6877) -- Windstorm
			self:CDBar(134926, 33) -- Throw Spear
			self:Bar(-6914, 7) -- Dead Zone
		end
		quetzalDead = true
	elseif args.mobId == 68081 then
		-- Dam'ren
		self:StopBar(-6914) -- Dead Zone
		if not self:Heroic() then
			self:Bar(-6917, 20, CL["count"]:format(self:SpellName(136146), 1)) -- Fist Smash
		end
	end
end
