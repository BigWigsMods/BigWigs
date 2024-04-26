--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Raszageth the Storm-Eater", 2522, 2499)
if not mod then return end
mod:RegisterEnableMob(189492) -- Raszageth the Storm-Eater
mod:SetEncounterID(2607)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

-- Stage One: The Winds of Change
local hurricaneWingCount = 1
local staticChargeCount = 1
local volatileCurrentCount = 1
local thunderousBlastCount = 1
local lightningBreathCount = 1
-- Intermission: The Primalist Strike
local lightningDevastationCount = 1
local addDeathCount = 0
-- Stage Two: Surging Power
local stormsurgeCount = 1
local stormsurgeActive = nil
local tempestWingCount = 1
local fulminatingChargeCount = 1
local electrifiedJawsCount = 1
-- Intermission: The Vault Falters
local collasalStormFiendKilled = 0
local collasalStormFiendKillRequired = mod:Mythic() and 3 or mod:Heroic() and 2 or 1
local stormBreakCount = 1
local ballLightningCount = 1
-- Stage Three: Storm Incarnate
local magneticChargeCount = 1
-- Mythic
local stormEaterCount = 1
local addToNumber = {}
local flameswornFound = 0
local frostforgedZaelotFound = 0
local otherSideBreath = 1
local chargeOnMe = nil
local inversionCount = 1

local marksUsed = {}
local mobCollector = {}

--------------------------------------------------------------------------------
-- Timers
--

local timersEasy = {
	[1] = {
		[381615] = {15, 35, 40, 30, 35, 35, 40}, -- Static Charge
		[388643] = {85, 47, 58}, -- Volatile Current
		[377594] = {23, 39, 53, 52}, -- Lightning Breath
		[377612] = {35, 35, 35, 35, 35, 35}, -- Hurricane Wing
		[395906] = {5, 25, 25, 27, 21, 27, 30, 27, 21}, -- Electrified Jaws
	},
	[2] = {
		[388643] = {68.5, 50, 115}, -- Volatile Current
		[395906] = {38.5, 25, 23, 30, 25, 25, 37, 25}, -- Electrified Jaws
		[387261] = {8.5, 80, 80, 80}, -- Stormsurge
		[377467] = {52.5, 86, 80}, -- Fulminating Charge
		[385574] = {43.5, 35, 50, 25, 55}, -- Tempest Wing
	},
	[3] = {
		[377594] = {34.5, 41, 41.9, 75, 42}, -- Lightning Breath
		[385574] = {66.4, 58.9, 26.9, 31, 59}, -- Tempest Wing
		[377467] = {41.5, 60, 60, 57}, -- Fulminating Charge
		[386410] = {22.5, 30, 30, 30, 30, 30, 27, 30, 30}, -- Thunderous Blast
	},
}

local timersHeroic = {
	[1] = {
		[381615] = {15.0, 35.0, 37.0, 34, 34, 37, 34, 34, 37}, -- Static Charge
		[388643] = {80.0, 55.0, 50.0, 55, 50}, -- Volatile Current
		[377594] = {23.0, 39.0, 54.0, 51.0, 54, 51}, -- Lightning Breath
		[377612] = {35, 35, 35, 35, 35, 35, 35, 35, 35}, -- Hurricane Wing
		[395906] = {4.9, 25.0, 25.0, 30.0, 18.0, 27.0, 30.0, 30.0, 18, 27, 30, 30}, -- Electrified Jaws
	},
	[2] = {
		[388643] = {65.5, 57}, -- Volatile Current
		[395906] = {38.5, 25.0, 23.0, 30.0, 25.0, 25.0, 37}, -- Electrified Jaws
		[387261] = {8.6, 80.0, 80.0}, -- Stormsurge
		[377467] = {53.5, 83.0}, -- Fulminating Charge
		[385574] = {43.6, 30.0, 55.0, 20.0, 60}, -- Tempest Wing
	},
	[3] = {
		[377594] = {31.3, 43.5, 42.0}, -- Lightning Breath
		[385574] = {65.9, 64.0, 22.0, 31}, -- Tempest Wing
		[377467] = {40.9, 60.0, 60.0}, -- Fulminating Charge
		[386410] = {21.8, 30, 30, 30, 30, 30}, -- Thunderous Blast
		[399713] = {25.9, 63.0, 34.0}, -- Magnetic Charge
	},
}

local timersMythic = {
	[1] = {
		[381615] = {15, 35, 37, 33, 35, 37, 33}, -- Static Charge
		[388643] = {28, 53, 46, 59, 46}, -- Volatile Current
		[377594] = {20, 25, 19, 26, 24, 20, 16, 18, 27, 24, 20}, -- Lightning Breath
		[377612] = {35, 35, 35, 35, 35, 35, 35}, -- Hurricane Wing
		[395906] = {5, 27, 23, 30, 17, 30, 28, 30, 19, 28}, -- Electrified Jaws
	},
	[2] = {
		[388643] = {67.5, 61, 40}, -- Volatile Current
		[395906] = {44.5, 27.0, 21.0, 30.0, 25.0, 25.0}, -- Electrified Jaws
		[387261] = {14.5, 80.0, 80.0}, -- Stormsurge
		[377467] = {57.5, 87.0}, -- Fulminating Charge
		[385574] = {49.5, 30.0, 54.0, 20.0}, -- Tempest Wing
	},
	[3] = {
		[377594] = {38.2, 41.5, 44.0, 30.0, 43.0}, -- Lightning Breath
		[385574] = {70.7, 70.0, 20.0}, -- Tempest Wing
		[377467] = {43.3, 61.4, 67.0}, -- Fulminating Charge
		[386410] = {28.7, 29.0, 32.0, 59.0, 30.0, 28.0}, -- Thunderous Blast
		[399713] = {32.7, 30.0, 33.0, 33.1}, -- Magnetic Charge
	},
}

local timers = mod:Mythic() and timersMythic or mod:Heroic() and timersHeroic or timersEasy

-- Skipped code
local SKIP_CAST_THRESHOLD = 3
local checkTimer = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.lighting_devastation_trigger = "deep breath" -- Raszageth takes a deep breath...

	-- Stage One: The Winds of Change
	L.volatile_current = "Sparks"
	L.thunderous_blast = "Blast"
	L.lightning_strikes = "Strikes"
	L.electric_scales = "Raid Damage"
	L.electric_lash = "Lash"
	-- Stage Two: Surging Power
	L.absorb_text = "%s (%.0f%%)"
	L.stormsurge = "Absorb Shield"
	L.stormcharged = "Positive or Negative"
	L.positive = "Positive"
	L.negative = "Negative"
	L.focused_charge = "Damage Buff"
	L.tempest_wing = "Storm Wave"
	L.fulminating_charge = "Charges"
	L.fulminating_charge_debuff = "Charge"
	-- Intermission: The Vault Falters
	L.ball_lightning = "Balls"
	-- Stage Three: Storm Incarnate
	L.magnetic_charge = "Pull Charge"

	L.custom_on_repeating_stormcharged = "Repeating Positive or Negative"
	L.custom_on_repeating_stormcharged_desc = "Repeating Positive or Negative say messages with icons {rt1}, {rt3} to find matches to remove your debuffs."

	L.skipped_cast = "Skipped %s (%d)"

	L.custom_off_raidleader_devastation = "Lighting Devastation: Leader Mode"
	L.custom_off_raidleader_devastation_desc = "Show a bar for the Lighting Devastation (Breath) on the other side as well."
	L.custom_off_raidleader_devastation_icon = 385065
	L.breath_other = "%s [Opposite]" -- Breath on opposite platform
end

--------------------------------------------------------------------------------
-- Initialization
--

local staticChargeMarker = mod:AddMarkerOption(false, "player", 1, 381615, 1, 2, 3) -- Static Charge
local stormseekerAcolyteLeft = mod:AddMarkerOption(false, "npc", 8, -25641, 8, 7, 6) -- Stormseeker Acolyte
local stormseekerAcolyteRight = mod:AddMarkerOption(false, "npc", 4, 219878, 5, 4, 3) -- Acolyte // Seperate spellId since there is no support for using the same one twice.
local fulminatingChargeMarker = mod:AddMarkerOption(false, "player", 1, 377467, 1, 2, 3) -- Fulminating Charge
local magneticChargeMarker = mod:AddMarkerOption(false, "player", 4, 399713, 4) -- Magnetic Charge
function mod:GetOptions()
	return {
		"stages",
		-- Stage One: The Winds of Change
		{377612, "CASTBAR"}, -- Hurricane Wing
		{381615, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Static Charge
		staticChargeMarker,
		388643, -- Volatile Current
		{395906, "TANK"}, -- Electrified Jaws
		377594, -- Lightning Breath
		-- 376126, -- Lightning Strikes
		-- 381249, -- Electric Scales
		381251, -- Electric Lash
		{382434, "CASTBAR", "CASTBAR_COUNTDOWN"}, -- Storm Nova
		-- Intermission: The Primalist Strike
		385065, -- Lightning Devastation
		"custom_off_raidleader_devastation",
		{396037, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Surging Blast
		385553, -- Storm Bolt
		stormseekerAcolyteLeft,
		stormseekerAcolyteRight,
		397382, -- Shattering Shroud
		397387, -- Flame Shield
		-- Stage Two: Surging Power
		{387261, "INFOBOX"}, -- Stormsurge
		{391989, "SAY"}, -- Stormcharged
		"custom_on_repeating_stormcharged",
		394582, -- Focused Charge
		394583, -- Scattered Charge
		385574, -- Tempest Wing
		{377467, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Fulminating Charge
		fulminatingChargeMarker,
		-- Intermission: The Vault Falters
		389870, -- Storm Break
		389878, -- Fuse
		385068, -- Ball Lightning
		-- Stage Three: Storm Incarnate
		385569, -- Raging Storm
		395929, -- Storm's Spite
		{399713, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Magnetic Charge
		magneticChargeMarker,
		{386410, "SAY"}, -- Thunderous Blast
		{391285, "TANK"}, -- Melted Armor
		-- Mythic
		{394584, "SAY", "SAY_COUNTDOWN"}, -- Inversion
		395885, -- Storm Eater
	}, {
		["stages"] = "general",
		[377612] = -25244, -- Stage One: The Winds of Change
		[385065] = -25683, -- Intermission: The Primalist Strike
		[387261] = -25312, -- Stage Two: Surging Power
		[389870] = -25812, -- Intermission: The Vault Falters
		[385569] = -25477, -- Stage Three: Storm Incarnate
		[394584] = "mythic",
	},{
		-- Stage One: The Winds of Change
		[377612] = CL.pushback, -- Hurricane Wing (Pushback)
		[381615] = CL.bombs, -- Static Charge (Bombs)
		[388643] = L.volatile_current, -- Volatile Current (Sparks)
		[386410] = L.thunderous_blast, -- Thunderous Blast (Blast)
		[377594] = CL.breath, -- Lightning Breath (Breath)
		-- [376126] = L.lightning_strikes, -- Lightning Strikes (Strikes)
		-- [381249] = L.electric_scales, -- Electric Scaless (Raid Damage)
		[381251] = L.electric_lash, -- Lightning Strikes (Lash)
		-- Intermission: The Primalist Strike
		[385065] = CL.breath, -- Lightning Devastation (Breath)
		[396037] = CL.bombs, -- Surging Blast (Bombs)
		[397382] = CL.heal_absorb, -- Shattering Shroud (Heal Absorb)
		-- Stage Two: Surging Power
		[387261] = L.stormsurge, -- Stormsurge
		[391989] = L.stormcharged, -- Stormcharged (Positive or Negative)
		[394582] = L.focused_charge, -- Focused Charge (Damage Buff)
		[385574] = L.tempest_wing, -- Tempest Wing (Storm Wave)
		[377467] = L.fulminating_charge, -- Fulminating Charge (Charges)
		-- Intermission: The Vault Falters
		[389870] = CL.teleport, -- Storm Break (Teleport)
		[385068] = L.ball_lightning, -- Ball Lightning (Balls)
		-- Stage Three: Storm Incarnate
		[399713] = L.magnetic_charge, -- Magnetic Charge (Pull Charge)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1") -- Stage Events

	-- Stage One: The Winds of Change
	self:Log("SPELL_CAST_START", "HurricaneWing", 377612)
	self:Log("SPELL_AURA_APPLIED", "StaticChargeApplied", 381615)
	self:Log("SPELL_AURA_REMOVED", "StaticChargeRemoved", 381615)
	self:Log("SPELL_CAST_START", "VolatileCurrent", 388643)
	self:Log("SPELL_CAST_START", "ElectrifiedJaws", 377658)
	self:Log("SPELL_AURA_APPLIED", "ElectrifiedJawsApplied", 395906)
	self:Log("SPELL_CAST_START", "LightningBreath", 377594)
	self:Log("SPELL_AURA_APPLIED", "ElectricLashApplied", 381251)
	self:Log("SPELL_AURA_APPLIED", "StormShroudApplied", 396734) -- End of Stage 1 & Stage 2
	self:Log("SPELL_CAST_START", "StormNova", 382434)

	-- Intermission: The Primalist Strike
	self:Log("SPELL_CAST_SUCCESS", "StormNovaSuccess", 382434)
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE") -- Lightning Devastation (emote shows when over your platform)
	self:Log("SPELL_AURA_APPLIED", "LightningDevastationApplied", 388115)
	self:Log("SPELL_AURA_APPLIED", "SurgingBlastApplied", 396037)
	self:Log("SPELL_AURA_REMOVED", "SurgingBlastRemoved", 396037)
	self:Log("SPELL_CAST_START", "StormBolt", 385553)
	self:Log("SPELL_CAST_START", "ShatteringShroud", 397382)
	self:Log("SPELL_AURA_APPLIED", "ShatteringShroudApplied", 397382)
	self:Log("SPELL_AURA_REMOVED", "ShatteringShroudRemoved", 397382)
	self:Log("SPELL_AURA_APPLIED", "OverloadApplied", 389214) -- Add Spawned
	self:Log("SPELL_AURA_APPLIED", "FlameShieldApplied", 397387)
	self:Death("IntermissionAddDeaths", 193760, 194990, 199547, 199549) -- Surging Ruiner, Stormseeker Acolyte, Frostforged Zealot, Flamesworn Herald
	self:Log("SPELL_AURA_REMOVED", "RuinousShroudRemoved", 388431) -- End of Intermission 1

	-- Stage Two: Surging Power
	self:Log("SPELL_CAST_SUCCESS", "ElectricScales", 381249) -- Stage 2 Started
	self:Log("SPELL_CAST_START", "Stormsurge", 387261)
	self:Log("SPELL_AURA_APPLIED", "StormsurgeApplied", 388691)
	self:Log("SPELL_AURA_REMOVED", "StormsurgeRemoved", 388691)
	self:Log("SPELL_AURA_APPLIED", "PositiveOrNegativeChargeApplied", 394576, 394579) -- Positive, Negative
	self:Log("SPELL_AURA_REMOVED", "PositiveOrNegativeChargeRemoved", 394576, 394579, 394584) -- Positive, Negative, Inversion
	self:Log("SPELL_AURA_APPLIED", "FocusedChargeApplied", 394582)
	self:Log("SPELL_AURA_APPLIED", "ScatteredChargeApplied", 394583)
	self:Log("SPELL_CAST_START", "TempestWing", 385574)
	self:Log("SPELL_CAST_SUCCESS", "FulminatingCharge", 378829)
	self:Log("SPELL_AURA_APPLIED", "FulminatingChargeApplied", 377467)
	self:Log("SPELL_AURA_REMOVED", "FulminatingChargeRemoved", 377467)

	-- Intermission: The Vault Falters
	self:Log("SPELL_CAST_START", "StormBreak", 389870)
	self:Log("SPELL_AURA_APPLIED", "FuseStacks", 389878)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FuseStacks", 389878)
	self:Log("SPELL_CAST_START", "BallLightning", 385068)
	self:Death("StormfiendDeath", 197145, 200943) -- Colossal Stormfiend, Electrified (Mythic)
	self:Log("SPELL_CAST_START", "StormNovaP3", 390463)

	-- Stage Three: Storm Incarnate
	self:Log("SPELL_CAST_SUCCESS", "StormNovaSuccessP3", 390463)
	self:Log("SPELL_CAST_START", "RagingStorm", 385569)
	self:Log("SPELL_CAST_SUCCESS", "MagneticCharge", 399713)
	self:Log("SPELL_AURA_APPLIED", "MagneticChargeApplied", 399713)
	self:Log("SPELL_AURA_REMOVED", "MagneticChargeRemoved", 399713)
	self:Log("SPELL_CAST_START", "ThunderousBlast", 386410)
	self:Log("SPELL_AURA_APPLIED", "MeltedArmorApplied", 391285)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MeltedArmorApplied", 391285)
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 395929) -- Storm's Spite
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 395929)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 395929)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "InversionApplied", 394584)
	self:Log("SPELL_CAST_START", "StormEater", 395885)
end

function mod:OnEngage()
	marksUsed = {}
	mobCollector = {}

	timers = self:Mythic() and timersMythic or self:Heroic() and timersHeroic or timersEasy
	self:SetStage(1)
	-- Stage One: The Winds of Change
	hurricaneWingCount = 1
	staticChargeCount = 1
	volatileCurrentCount = 1
	thunderousBlastCount = 1
	lightningBreathCount = 1

	-- Intermission: The Primalist Strike
	lightningDevastationCount = 1
	addDeathCount = 0

	-- Stage Two: Surging Power
	stormsurgeCount = 1
	stormsurgeActive = nil
	tempestWingCount = 1
	fulminatingChargeCount = 1
	electrifiedJawsCount = 1

	-- Intermission: The Vault Falters
	stormBreakCount = 1
	ballLightningCount = 1
	collasalStormFiendKilled = 0
	collasalStormFiendKillRequired = mod:Mythic() and 3 or mod:Heroic() and 2 or 1

	-- Stage Three: Storm Incarnate
	magneticChargeCount = 1

	-- Mythic
	stormEaterCount = 1
	flameswornFound = 0
	frostforgedZaelotFound = 0
	otherSideBreath = 1
	addToNumber = {}

	self:Bar(395906, timers[1][395906][electrifiedJawsCount], CL.count:format(self:SpellName(395906), electrifiedJawsCount)) -- Electrified Jaws
	self:Bar(381615, timers[1][381615][staticChargeCount], CL.count:format(CL.bombs, staticChargeCount)) -- Static Charge
	local breathCd = timers[1][377594][lightningBreathCount]
	self:Bar(377594, breathCd, CL.count:format(CL.breath, lightningBreathCount)) -- Lightning Breath
	checkTimer = self:ScheduleTimer("BreathCheck", breathCd + SKIP_CAST_THRESHOLD, lightningBreathCount)
	self:Bar(377612, timers[1][377612][hurricaneWingCount], CL.count:format(CL.pushback, hurricaneWingCount)) -- Hurricane Wing
	self:Bar(388643, timers[1][388643][volatileCurrentCount], CL.count:format(L.volatile_current, volatileCurrentCount)) -- Volatile Current

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:AddMarking(_, unit, guid)
	if not mobCollector[guid] and self:MobId(guid) == 194990 and self:UnitWithinRange(unit, 100) then -- Stormseeker Acolyte
		if self:GetOption(stormseekerAcolyteLeft) then
			for i = 8, 6, -1 do -- 8, 7, 6
				if not marksUsed[i] then
					mobCollector[guid] = true
					marksUsed[i] = guid
					self:CustomIcon(stormseekerAcolyteLeft, unit, i)
					return
				end
			end
		elseif self:GetOption(stormseekerAcolyteRight) then
			for i = 5, 3, -1 do -- 5, 4, 3
				if not marksUsed[i] then
					mobCollector[guid] = true
					marksUsed[i] = guid
					self:CustomIcon(stormseekerAcolyteRight, unit, i)
					return
				end
			end
		end
	end
end

function mod:IntermissionAddDeaths(args)
	if args.mobId == 194990 then -- Stormseeker Acolyte
		if self:GetOption(stormseekerAcolyteLeft) or self:GetOption(stormseekerAcolyteRight) then
			for i = 8, 3, -1 do -- 8 -> 3
				if marksUsed[i] == args.destGUID then
					marksUsed[i] = nil
					return
				end
			end
		end
	elseif args.mobId == 199547 or addToNumber[args.sourceGUID] then -- Frostforged Zealot
		self:StopBar(CL.count:format(self:SpellName(397382), addToNumber[args.sourceGUID])) -- Shattering Shroud
	elseif args.mobId == 199549 or addToNumber[args.sourceGUID] then -- Flamesworn Herald
		self:StopBar(CL.count:format(self:SpellName(397387), addToNumber[args.sourceGUID])) -- Flame Shield
	elseif args.mobId == 193760 then -- Surging Ruiner
		addDeathCount = addDeathCount + 1
		self:Message("stages", "green", CL.add_killed:format(addDeathCount, 6), false)
	end
end

-- Phase Handlers
function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 398466 then -- End of Intermission 2 ([DNT] Clear Raszageth Auras on Players)
		self:Message(382434, "yellow", CL.soon:format(self:SpellName(382434)))
		self:Bar(382434, 4.8)
		self:StopBar(CL.count:format(CL.breath, lightningDevastationCount))
		self:StopBar(CL.count:format(L.ball_lightning, ballLightningCount))
		self:StopBar(CL.count:format(CL.teleport, stormBreakCount))
	end
end

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 67 then -- Intermission 1 at 65%
		self:UnregisterUnitEvent(event, unit)
		self:Message("stages", "green", CL.soon:format(CL.count:format(CL.intermission, 1)), false)
		self:PlaySound("stages", "info")
	end
end

-- Stage One: The Winds of Change
function mod:HurricaneWing(args)
	self:StopBar(CL.count:format(CL.pushback, hurricaneWingCount))
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(CL.pushback, hurricaneWingCount)))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 6+2.5+(hurricaneWingCount/2), CL.pushback) -- 6s cast, (2.5s+0.5s) base, +0.5s per cast
	hurricaneWingCount = hurricaneWingCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][hurricaneWingCount], CL.count:format(CL.pushback, hurricaneWingCount))
end

do
	local playerList = {}
	local prev = 0
	function mod:StaticChargeApplied(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Bar(args.spellId, 8, CL.count:format(CL.explosion, staticChargeCount))
			staticChargeCount = staticChargeCount + 1
			self:Bar(args.spellId, timers[self:GetStage()][args.spellId][staticChargeCount], CL.count:format(CL.bombs, staticChargeCount))
			playerList = {}
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.count_rticon:format(CL.bomb, count, count), nil, ("Bomb (%d{rt%d})"):format(count, count))
			self:SayCountdown(args.spellId, 8, count)
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, 3, CL.count:format(CL.bomb, staticChargeCount-1))
		self:CustomIcon(staticChargeMarker, args.destName, count)
	end

	function mod:StaticChargeRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(staticChargeMarker, args.destName)
	end
end

function mod:VolatileCurrent(args)
	self:StopBar(CL.count:format(L.volatile_current, volatileCurrentCount))
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(L.volatile_current, volatileCurrentCount)))
	self:PlaySound(args.spellId, "alert")
	volatileCurrentCount = volatileCurrentCount + 1
	local stage = self:GetStage()
	if stage == 1 or stage == 2 then -- It can trigger after intermission 2.5 has started, avoid starting bars
		self:Bar(args.spellId, timers[self:GetStage()][args.spellId][volatileCurrentCount], CL.count:format(L.volatile_current, volatileCurrentCount))
	end
end

function mod:ElectrifiedJaws(args)
	self:StopBar(CL.count:format(args.spellName, electrifiedJawsCount))
	self:Message(395906, "purple", CL.casting:format(CL.count:format(args.spellName, electrifiedJawsCount)))
	self:PlaySound(395906, "info")
	electrifiedJawsCount = electrifiedJawsCount + 1
	local stage = self:GetStage()
	if stage == 1 or stage == 2 then -- It can trigger after intermission 2.5 has started, avoid starting bars
		self:Bar(395906, timers[self:GetStage()][395906][electrifiedJawsCount], CL.count:format(args.spellName, electrifiedJawsCount))
	end
end

function mod:ElectrifiedJawsApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	if bossUnit and self:Tank() and not self:Me(args.destGUID) and not self:Tanking(bossUnit) then
		self:PlaySound(args.spellId, "warning") -- Taunt
	elseif self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	end
end

function mod:BreathCheck(castCount)
	local stage = self:GetStage()
	if castCount == lightningBreathCount and (stage == 1 or stage == 3) then -- not on the next cast?
		mod:StopBar(CL.count:format(CL.breath, lightningBreathCount))
		mod:Message(377594, "green", L.skipped_cast:format(CL.breath, castCount))
		lightningBreathCount = castCount + 1
		local cd = timers[self:GetStage()][377594][lightningBreathCount]
		if cd then
			mod:Bar(377594, cd - SKIP_CAST_THRESHOLD, CL.count:format(CL.breath, lightningBreathCount))
			checkTimer = mod:ScheduleTimer("BreathCheck", cd, lightningBreathCount)
		end
	end
end

function mod:LightningBreath(args)
	self:StopBar(CL.count:format(CL.breath, lightningBreathCount))
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(CL.breath, lightningBreathCount)))
	self:PlaySound(args.spellId, "alarm")
	lightningBreathCount = lightningBreathCount + 1
	local cd = timers[self:GetStage()][args.spellId][lightningBreathCount]
	self:Bar(args.spellId, cd, CL.count:format(CL.breath, lightningBreathCount))
	if cd then
		checkTimer = self:ScheduleTimer("BreathCheck", cd + SKIP_CAST_THRESHOLD, lightningBreathCount)
	end
end

function mod:ElectricLashApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.electric_lash)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:StormShroudApplied()
	if self:GetStage() == 1 then -- End of Stage 1
		self:StopBar(CL.count:format(self:SpellName(395906), electrifiedJawsCount)) -- Electrified Jaws
		self:StopBar(CL.count:format(CL.bombs, staticChargeCount)) -- Static Charge
		self:StopBar(CL.count:format(L.volatile_current, volatileCurrentCount)) -- Volatile Current
		self:StopBar(CL.count:format(CL.breath, lightningBreathCount)) -- Lightning Breath
		self:StopBar(CL.count:format(CL.pushback, hurricaneWingCount)) -- Hurricane Wing
		self:CancelTimer(checkTimer) -- Breath Skip check
		checkTimer = nil

		self:Message(382434, "yellow", CL.percent:format(65, CL.soon:format(self:SpellName(382434))))
		self:Bar(382434, 13.4) -- Storm Nova
	elseif self:GetStage() == 2 then -- End of Stage 2
		self:StopBar(CL.count:format(L.stormsurge, stormsurgeCount)) -- Storm Surge
		self:StopBar(CL.count:format(L.volatile_current, volatileCurrentCount)) -- Volatile Current
		self:StopBar(CL.count:format(L.tempest_wing, tempestWingCount)) -- Tempest Wing
		self:StopBar(CL.count:format(L.fulminating_charge, fulminatingChargeCount)) -- Fulminating Charge(s)
		self:StopBar(CL.count:format(self:SpellName(395906), electrifiedJawsCount)) -- Electified Jaws

		self:Message("stages", "cyan", CL.count:format(CL.intermission, 2), false)
		self:PlaySound("stages", "info")
		self:SetStage(2.5)

		lightningDevastationCount = 1
		stormBreakCount = 1
		ballLightningCount = 1
		collasalStormFiendKilled = 0
		collasalStormFiendKillRequired = mod:Mythic() and 3 or mod:Heroic() and 2 or 1

		self:Bar("stages", 11.5, CL.adds, "inv_10_elementalspiritfoozles_lightning")
		self:Bar(385065, self:Mythic() and 23.6 or 24.4, CL.count:format(CL.breath, lightningDevastationCount))

		self:Bar(385068, 21, CL.count:format(L.ball_lightning, ballLightningCount))
		self:Bar(389870, 34, CL.count:format(CL.teleport, stormBreakCount))
	end
end

function mod:StormNova(args)
	-- Stopping P1 Bars incase UNIT event is gone
	self:StopBar(CL.count:format(CL.bombs, staticChargeCount)) -- Static Charge
	self:StopBar(CL.count:format(L.thunderous_blast, thunderousBlastCount)) -- Thunderous Blast
	self:StopBar(CL.count:format(L.volatile_current, volatileCurrentCount)) -- Volatile Current
	self:StopBar(CL.count:format(CL.breath, lightningBreathCount)) -- Lightning Breath
	self:StopBar(CL.count:format(CL.pushback, hurricaneWingCount)) -- Hurricane Wing
	self:StopBar(382434) -- Storm Nova

	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 5)
end

-- Intermission: The Primalist Strike
function mod:PlatformBreathCheck(castCount)
	if castCount == lightningDevastationCount then -- You didn't get the emote, next breath here
		local cd = self:Mythic() and 9 or self:Heroic() and 12.3 or 13.5
		self:Bar(385065, cd - 1, CL.count:format(CL.breath, lightningDevastationCount))
		otherSideBreath = otherSideBreath + 1
	end
end

function mod:StormNovaSuccess(args)
	self:Message("stages", "cyan", CL.count:format(CL.intermission, 1), args.spellId)
	self:PlaySound("stages", "info")
	self:SetStage(1.5)
	self:Bar("stages", 98.5, CL.stage:format(2), 387261)

	lightningDevastationCount = 1
	flameswornFound = 0
	otherSideBreath = 1
	self:Bar(385065, 12.5, CL.count:format(CL.breath, lightningDevastationCount)) -- Time to Storm Jump (snap position), does the breath still change?
	checkTimer = mod:ScheduleTimer("PlatformBreathCheck", 13.5, lightningDevastationCount)
	if self:GetOption(stormseekerAcolyteLeft) or self:GetOption(stormseekerAcolyteRight) then
		self:RegisterTargetEvents("AddMarking")
		marksUsed = {}
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find(L.lighting_devastation_trigger, nil, true) then
		self:Message(385065, "yellow", CL.count:format(CL.breath, lightningDevastationCount))
		self:PlaySound(385065, "alert")
		lightningDevastationCount = lightningDevastationCount + 1
		local stage = self:GetStage()
		if stage == 2.5 or (stage == 1.5 and lightningDevastationCount < 5) then -- Only 4 on each platform in stage 1.5 (intermission 1)
			local cd
			if self:Easy() then
				cd = stage == 1.5 and 27 or 32.8
			elseif self:Mythic() then
				cd = stage == 1.5 and 17.9 or 27.3 -- -1.5 on the cooldown for 'baiting' the position of the breath
			else
				cd = stage == 1.5 and 24.6 or 31.3
			end
			self:Bar(385065, cd, CL.count:format(CL.breath, lightningDevastationCount))
		end
		if self:GetOption("custom_off_raidleader_devastation") and stage == 1.5 and otherSideBreath < 5 then -- Raidleader bars
			otherSideBreath = otherSideBreath + 1
			self:Bar(false, 9, L.breath_other:format(CL.count:format(CL.breath, otherSideBreath)), 385065)
		end
	end
end

function mod:LightningDevastationApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(385065)
		self:PlaySound(385065, "warning")
	end
end

function mod:SurgingBlastApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.bomb)
		self:Say(args.spellId, CL.bomb, nil, "Bomb")
		self:SayCountdown(args.spellId, 6)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:SurgingBlastRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:StormBolt(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo and ready then
		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:ShatteringShroud(args)
	self:Message(args.spellId, "yellow", CL.casting:format(CL.heal_absorb))
	if self:Healer() then
		self:PlaySound(args.spellId, "alert")
	end
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:UnitWithinRange(unit, 100) then
		self:Bar(args.spellId, 42.5, CL.count:format(args.spellName, addToNumber[args.sourceGUID]))
	end
end

function mod:ShatteringShroudApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.heal_absorb)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:ShatteringShroudRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(CL.heal_absorb))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:OverloadApplied(args)
	if self:MobId(args.destGUID) == 199549 then -- Flamesworn Herald
		flameswornFound = flameswornFound + 1
		addToNumber[args.destGUID] = flameswornFound
		local unit = self:UnitTokenFromGUID(args.destGUID)
		if unit and self:UnitWithinRange(unit, 100) then
			self:Bar(397387, 7.32, CL.count:format(self:SpellName(397387), flameswornFound)) -- Flame Shield
		end
	elseif self:MobId(args.destGUID) == 199547 then -- Frostforged Zealot
		frostforgedZaelotFound = frostforgedZaelotFound + 1
		addToNumber[args.destGUID] = frostforgedZaelotFound
		local unit = self:UnitTokenFromGUID(args.destGUID)
		if unit and self:UnitWithinRange(unit, 100) then
			self:Bar(397382, 7.32, CL.count:format(self:SpellName(397382), frostforgedZaelotFound)) -- Shattering Shroud
		end
	end
end

function mod:FlameShieldApplied(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:RuinousShroudRemoved(args)
	self:StopBar(CL.count:format(CL.breath, lightningDevastationCount))
	self:Message("stages", "cyan", CL.over:format(CL.count:format(CL.intermission, 1)), false)
	self:PlaySound("stages", "info")

	if not self:Easy() then -- Seems to instantly happen at the same time as Electric Scales in normal?
		self:Bar("stages", {self:Mythic() and 17 or 12, self:Mythic() and 92.08 or 93.5}, CL.stage:format(2), "achievement_raidprimalist_raszageth")
	end
end

-- Stage Two: Surging Power
function mod:ElectricScales(args)
	if self:GetStage() == 1.5 then -- Stage 2
		self:StopBar(CL.count:format(CL.breath, lightningDevastationCount))
		self:StopBar(CL.stage:format(2))
		self:Message("stages", "cyan", CL.stage:format(2), "achievement_raidprimalist_raszageth")
		self:PlaySound("stages", "info")
		self:SetStage(2)

		stormsurgeCount = 1
		volatileCurrentCount = 1
		tempestWingCount = 1
		fulminatingChargeCount = 1
		electrifiedJawsCount = 1
		chargeOnMe = nil
		stormsurgeActive = nil

		self:Bar(387261, timers[2][387261][stormsurgeCount], CL.count:format(L.stormsurge, stormsurgeCount))
		self:Bar(388643, timers[2][388643][volatileCurrentCount], CL.count:format(L.volatile_current, volatileCurrentCount))
		self:Bar(385574, timers[2][385574][tempestWingCount], CL.count:format(L.tempest_wing, tempestWingCount))
		self:Bar(377467, timers[2][377467][fulminatingChargeCount], CL.count:format(L.fulminating_charge, fulminatingChargeCount))
		self:Bar(395906, timers[2][395906][electrifiedJawsCount], CL.count:format(self:SpellName(395906), electrifiedJawsCount))
	end
end

do
	local timer, maxAbsorb = nil, 0
	local appliedTime = 0
	local function updateInfoBox(self)
		local absorb = UnitGetTotalAbsorbs("boss1")
		local absorbPercentage = absorb / maxAbsorb
		self:SetInfoBar(387261, 1, absorbPercentage)
		self:SetInfo(387261, 2, L.absorb_text:format(self:AbbreviateNumber(absorb), absorbPercentage * 100))
	end

	function mod:Stormsurge(args)
		self:Message(args.spellId, "yellow", CL.count:format(L.stormsurge, stormsurgeCount))
		self:PlaySound(args.spellId, "long")
		stormsurgeCount = stormsurgeCount + 1
		self:Bar(args.spellId, timers[2][args.spellId][stormsurgeCount], CL.count:format(L.stormsurge, stormsurgeCount))
		chargeOnMe = nil
		stormsurgeActive = true
		if self:Mythic() then
			inversionCount = 1
			self:Bar(394584, 8, CL.count:format(self:SpellName(394584), inversionCount)) -- Inversion
		end
	end

	function mod:StormsurgeApplied(args)
		appliedTime = args.time
		if self:CheckOption(387261, "INFOBOX") then
			self:OpenInfo(387261, L.stormsurge)
			self:SetInfoBar(387261, 1, 1)
			self:SetInfo(387261, 1, CL.absorb)
			maxAbsorb = UnitGetTotalAbsorbs("boss1")
			timer = self:ScheduleRepeatingTimer(updateInfoBox, 0.1, self)
		end
	end

	function mod:StormsurgeRemoved(args)
		self:Message(387261, "green", CL.removed_after:format(CL.count:format(L.stormsurge, stormsurgeCount-1), args.time - appliedTime))
		self:PlaySound(387261, "info")

		self:StopBar(CL.count:format(self:SpellName(394584), inversionCount)) -- Inversion
		self:CloseInfo(387261)
		stormsurgeActive = nil
		if timer then
			self:CancelTimer(timer)
			timer = nil
		end
	end
end

do
	local sayMessages = {"{rt6}","{rt7}"} -- Positive = Square/Blue, Negative = Cross/Red
	local sayTimer = nil
	local prev = 0
	function mod:PositiveOrNegativeChargeApplied(args)
		if self:Me(args.destGUID) then
			-- Positive is default
			local msg = L.positive
			local sayMsg = sayMessages[1] -- Square/Blue
			chargeOnMe = args.spellId
			if chargeOnMe == 394579 then -- Negative
				msg = L.negative
				sayMsg = sayMessages[2] -- Cross/Red
				self:Message(391989, "red", msg)
			else
				self:Message(391989, "blue", msg)
			end
			self:Say(391989, sayMsg, true)
			self:PlaySound(391989, "warning")
			if self:GetOption("custom_on_repeating_stormcharged") then
				sayTimer = self:ScheduleRepeatingTimer("Say", 1.5, false, sayMsg, true)
			end
		end
	end

	function mod:PositiveOrNegativeChargeRemoved(args)
		if self:Me(args.destGUID) then
			if sayTimer then
				self:CancelTimer(sayTimer)
				sayTimer = nil
			end
		end
	end

	local sayMessagesInversion = {">{rt6}<",">{rt7}<"} -- Positive = Square/Blue, Negative = Cross/Red
	function mod:InversionApplied(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:StopBar(CL.count:format(self:SpellName(394584), inversionCount)) -- Inversion
			inversionCount = inversionCount + 1
			if inversionCount < 4 then -- only 4 per shield, but last ones are in the end.
				self:Bar(args.spellId, 6, CL.count:format(args.spellName, inversionCount)) -- Inversion
			end
		end
		if self:Me(args.destGUID) then
			if sayTimer then
				self:CancelTimer(sayTimer)
				sayTimer = nil
			end
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning")
			-- Swap icon for debuffs
			local msg = L.negative
			local sayMsg = sayMessagesInversion[2] -- Square/Blue
			if chargeOnMe == 394579 then -- Negative
				msg = L.positive
				sayMsg = sayMessagesInversion[1] -- Cross/Red
			end
			self:Say(391989, sayMsg, true)
			if self:GetOption("custom_on_repeating_stormcharged") then
				sayTimer = self:ScheduleRepeatingTimer("Say", 1.5, false, sayMsg, true)
			end
		end
	end
end

do
	local prev = 0
	function mod:FocusedChargeApplied(args)
		if self:Me(args.destGUID) and stormsurgeActive then -- Check for shield, otherwise false positive
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:Message(args.spellId, "green", L.focused_charge)
				self:PlaySound(args.spellId, "info")
			end
		end
	end
end

do
	local prev = 0
	function mod:ScatteredChargeApplied(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:Message(args.spellId, "red")
				self:PlaySound(args.spellId, "alarm")
			end
		end
	end
end

function mod:TempestWing(args)
	self:StopBar(CL.count:format(L.tempest_wing, tempestWingCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.tempest_wing, tempestWingCount))
	self:PlaySound(args.spellId, "alert")
	tempestWingCount = tempestWingCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][tempestWingCount], CL.count:format(L.tempest_wing, tempestWingCount))
end

do
	local playerList = {}
	local prev = 0
	function mod:FulminatingCharge(args)
		self:StopBar(CL.count:format(L.fulminating_charge, fulminatingChargeCount))
		self:PlaySound(377467, "long")
		fulminatingChargeCount = fulminatingChargeCount + 1
		self:Bar(377467, timers[self:GetStage()][377467][fulminatingChargeCount], CL.count:format(L.fulminating_charge, fulminatingChargeCount))
	end

	function mod:FulminatingChargeApplied(args)
		if args.time - prev > 2 then
			-- reset count on jump
			prev = args.time
			playerList = {}
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, L.fulminating_charge_debuff, nil, "Charge")
			if self:Mythic() then
				self:SayCountdown(args.spellId, 3, nil, 2)
			else
				self:SayCountdown(args.spellId, self:Heroic() and 5 or 6)
			end
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, 3, CL.count:format(L.fulminating_charge, fulminatingChargeCount-1))
		self:CustomIcon(fulminatingChargeMarker, args.destName, count)
	end

	function mod:FulminatingChargeRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(fulminatingChargeMarker, args.destName)
	end
end

-- Intermission: The Vault Falters
do
	local prev = 0
	function mod:StormBreak(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:StopBar(CL.count:format(CL.teleport, stormBreakCount))
			self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(CL.teleport, stormBreakCount)))
			self:PlaySound(args.spellId, "alert")
			stormBreakCount = stormBreakCount + 1
			self:Bar(args.spellId, 25, CL.count:format(CL.teleport, stormBreakCount))
		end
	end
end

do
	local stacks = 0
	local scheduled = nil
	function mod:FuseStacksMessage()
		self:StackMessage(389878, "cyan", CL.big_add, stacks, 1)
		self:PlaySound(389878, "info")
		scheduled = nil
		stacks = 0
	end

	function mod:FuseStacks(args)
		stacks = stacks + 1
		if not scheduled then
			scheduled = self:ScheduleTimer("FuseStacksMessage", 2) -- Throttle here
		end
	end
end

do
	local prev = 0
	function mod:BallLightning(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:StopBar(CL.count:format(L.ball_lightning, ballLightningCount))
			self:Message(args.spellId, "orange", CL.count:format(L.ball_lightning, ballLightningCount))
			self:PlaySound(args.spellId, "alarm")
			ballLightningCount = ballLightningCount + 1
			self:Bar(args.spellId, ballLightningCount % 2 == 0 and 22 or 26, CL.count:format(L.ball_lightning, ballLightningCount))
		end
	end
end

function mod:StormfiendDeath()
	collasalStormFiendKilled = collasalStormFiendKilled + 1
	self:Message("stages", "green", CL.add_killed:format(collasalStormFiendKilled, collasalStormFiendKillRequired), false)
	if collasalStormFiendKilled == collasalStormFiendKillRequired then -- End of Intermission
		self:StopBar(CL.count:format(CL.breath, lightningDevastationCount))
		self:StopBar(CL.count:format(CL.teleport, stormBreakCount))
		self:StopBar(CL.count:format(L.ball_lightning, ballLightningCount))
	end
end

function mod:StormNovaP3(args)
	self:StopBar(CL.count:format(CL.breath, lightningDevastationCount))
	self:StopBar(CL.count:format(CL.teleport, stormBreakCount))
	self:StopBar(CL.count:format(L.ball_lightning, ballLightningCount))

	self:Message(382434, "red", CL.casting:format(args.spellName))
	self:PlaySound(382434, "warning")
	self:CastBar(382434, 5)
end

-- Stage Three: Storm Incarnate
function mod:StormNovaSuccessP3()
	self:Message("stages", "cyan", CL.stage:format(3), "achievement_raidprimalist_raszageth")
	self:PlaySound("stages", "info")
	self:SetStage(3)

	tempestWingCount = 1
	fulminatingChargeCount = 1
	lightningBreathCount = 1
	thunderousBlastCount = 1

	self:Bar(385574, timers[3][385574][tempestWingCount], CL.count:format(L.tempest_wing, tempestWingCount))
	self:Bar(377467, timers[3][377467][fulminatingChargeCount], CL.count:format(L.fulminating_charge, fulminatingChargeCount))
	self:Bar(386410, timers[3][386410][thunderousBlastCount], CL.count:format(L.thunderous_blast, thunderousBlastCount))
	self:Bar(377594, timers[3][377594][lightningBreathCount], CL.count:format(CL.breath, lightningBreathCount))
	self:Bar("stages", 6.9, CL.removed:format(self:SpellName(396734)), 396734) -- Storm Shroud Removed
	if not self:Easy() then
		magneticChargeCount = 1
		self:Bar(399713, timers[3][399713][magneticChargeCount], CL.count:format(L.magnetic_charge, magneticChargeCount))
	end
end

function mod:RagingStorm(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "info")
end

function mod:MagneticCharge(args)
	self:StopBar(CL.count:format(L.magnetic_charge, magneticChargeCount))
	magneticChargeCount = magneticChargeCount + 1
	self:Bar(args.spellId, timers[3][args.spellId][magneticChargeCount], CL.count:format(L.magnetic_charge, magneticChargeCount))
end

function mod:MagneticChargeApplied(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId, L.magnetic_charge, nil, "Pull Charge")
		self:SayCountdown(args.spellId, 8)
		self:PlaySound(args.spellId, "warning")
	end
	self:TargetMessage(args.spellId, "yellow", args.destName, CL.count:format(L.magnetic_charge, magneticChargeCount-1))
	self:TargetBar(args.spellId, 8, args.destName, CL.count:format(L.magnetic_charge, magneticChargeCount-1))
	self:CustomIcon(magneticChargeMarker, args.destName, 4)
end

function mod:MagneticChargeRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	self:CustomIcon(magneticChargeMarker, args.destName)
end

function mod:ThunderousBlast(args)
	self:StopBar(CL.count:format(L.thunderous_blast, thunderousBlastCount-1))
	self:Message(args.spellId, "purple", CL.casting:format(CL.count:format(L.thunderous_blast, thunderousBlastCount)))
	self:PlaySound(args.spellId, "alarm")
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	if bossUnit and self:Tanking(bossUnit) then
		self:Say(args.spellId, L.thunderous_blast, nil, "Blast")
	end
	thunderousBlastCount = thunderousBlastCount + 1
	self:Bar(args.spellId, timers[3][args.spellId][thunderousBlastCount], CL.count:format(L.thunderous_blast, thunderousBlastCount))
end

function mod:MeltedArmorApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 0)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	if bossUnit and not self:Tanking(bossUnit) then -- Taunt?
		self:PlaySound(args.spellId, "warning")
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end

-- Mythic
function mod:StormEater(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
end
