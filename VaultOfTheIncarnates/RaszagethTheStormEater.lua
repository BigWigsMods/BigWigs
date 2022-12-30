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
local tempestWingCount = 1
local fulminatingChargeCount = 1
local electrifiedJawsCount = 1
-- Intermission: The Vault Falters
local stormBreakCount = 1
local ballLightningCount = 1
-- Stage Three: Storm Incarnate
local magneticChargeCount = 1
-- Mythic
local stormEaterCount = 1


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
		[388643] = {68.5, 50}, -- Volatile Current
		[395906] = {38.5, 24.9, 22.9, 30, 25, 25, 37}, -- Electrified Jaws
		[387261] = {8.5, 80, 80, 80}, -- Stormsurge
		[377467] = {52.5, 85.9}, -- Fulminating Charge
		[385574] = {43.5, 35, 49.9, 24.9, 55}, -- Tempest Wing
	},
	[3] = {
		[377594] = {34.5, 41, 41.9}, -- Lightning Breath
		[385574] = {66.4, 58.9, 26.9}, -- Tempest Wing
		[377467] = {41.5, 60}, -- Fulminating Charge
		[386410] = {22.5, 30, 30, 30, 30}, -- Thunderous Blast
	},
}

local timersHeroic = {
	[1] = {
		[381615] = {15.0, 35.0, 37.0, 34, 34, 37}, -- Static Charge
		[388643] = {80.0, 55.0, 50.0}, -- Volatile Current
		[377594] = {23.0, 39.0, 54.0, 51.0}, -- Lightning Breath
		[377612] = {35, 35, 35, 35, 35}, -- Hurricane Wing
		[395906] = {4.9, 25.0, 25.0, 30.0, 18.0, 27.0, 30.0, 30.0}, -- Electrified Jaws
	},
	[2] = {
		[388643] = {65.5, 57}, -- Volatile Current
		[395906] = {38.5, 25.0, 23.0, 30.0, 25.0, 25.0}, -- Electrified Jaws
		[387261] = {8.6, 80.0, 80.0}, -- Stormsurge
		[377467] = {53.5, 83.0}, -- Fulminating Charge
		[385574] = {43.6, 30.0, 55.0, 20.0}, -- Tempest Wing
	},
	[3] = {
		[377594] = {31.3, 43.5, 42.0}, -- Lightning Breath
		[385574] = {65.9, 64.0, 22.0}, -- Tempest Wing
		[377467] = {40.9, 60.0, 60.0}, -- Fulminating Charge
		[386410] = {21.8, 30.0, 30.0, 30.0, 30.0}, -- Thunderous Blast
		[399713] = {25.9, 63.0, 34.0}, -- Magnetic Charge
	},
}

local timers = mod:Easy() and timersEasy or timersHeroic

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.lighting_devastation_trigger = "deep breath" -- Raszageth takes a deep breath...

	-- Stage One: The Winds of Change
	L.hurricane_wing = "Pushback"
	L.volatile_current = "Sparks"
	L.thunderous_blast = "Blast"
	L.lightning_breath = "Breath"
	L.lightning_strikes = "Strikes"
	L.electric_scales = "Raid Damage"
	L.electric_lash = "Lash"
	-- Intermission: The Primalist Strike
	L.lightning_devastation = "Breath"
	L.shattering_shroud = "Heal Absorb"
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
	L.storm_break = "Teleport"
	L.ball_lightning = "Balls"
	-- Stage Three: Storm Incarnate
	L.magnetic_charge = "Pull Charge"
	-- Mythic
	L.storm_eater = "Storm Eater"
end

--------------------------------------------------------------------------------
-- Initialization
--

local staticChargeMarker = mod:AddMarkerOption(false, "player", 1, 381615, 1, 2, 3) -- Static Charge
local fulminatingChargeMarker = mod:AddMarkerOption(false, "player", 1, 377467, 1, 2, 3) -- Fulminating Charge
local magneticChargeMarker = mod:AddMarkerOption(false, "player", 4, 399713, 4) -- Magnetic Charge
function mod:GetOptions()
	return {
		"stages",
		-- Stage One: The Winds of Change
		377612, -- Hurricane Wing
		{381615, "SAY", "SAY_COUNTDOWN"}, -- Static Charge
		staticChargeMarker,
		388643, -- Volatile Current
		{395906, "TANK"}, -- Electrified Jaws
		377594, -- Lightning Breath
		-- 376126, -- Lightning Strikes
		-- 381249, -- Electric Scales
		381251, -- Electric Lash
		382434, -- Storm Nova
		-- Intermission: The Primalist Strike
		385065, -- Lightning Devastation
		{396037, "SAY", "SAY_COUNTDOWN"}, -- Surging Blast
		385553, -- Storm Bolt
		397382, -- Shattering Shroud
		397387, -- Flame Shield
		-- Stage Two: Surging Power
		{387261, "INFOBOX"}, -- Stormsurge
		{391989, "SAY"}, -- Stormcharged
		394582, -- Focused Charge
		394583, -- Scattered Charge
		385574, -- Tempest Wing
		{377467, "SAY", "SAY_COUNTDOWN"}, -- Fulminating Charge
		fulminatingChargeMarker,
		-- Intermission: The Vault Falters
		389870, -- Storm Break
		389878, -- Fuse
		385068, -- Ball Lightning
		-- Stage Three: Storm Incarnate
		385569, -- Raging Storm
		395929, -- Storm's Spite
		{399713, "SAY", "SAY_COUNTDOWN"}, -- Magnetic Charge
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
		[377612] = L.hurricane_wing, -- Hurricane Wing (Pushback)
		[381615] = CL.bombs, -- Static Charge (Bombs)
		[388643] = L.volatile_current, -- Volatile Current (Sparks)
		[386410] = L.thunderous_blast, -- Thunderous Blast (Blast)
		[377594] = L.lightning_breath, -- Lightning Breath (Breath)
		[376126] = L.lightning_strikes, -- Lightning Strikes (Strikes)
		[381249] = L.electric_scales, -- Electric Scaless (Raid Damage)
		[381251] = L.electric_lash, -- Lightning Strikes (Lash)
		-- Intermission: The Primalist Strike
		[385065] = L.lightning_devastation, -- Lightning Devastation (Breath)
		[396037] = CL.bombs, -- Surging Blast (Bombs)
		[397382] = L.shattering_shroud, -- Shattering Shroud (Heal Absorb)
		-- Stage Two: Surging Power
		[387261] = L.stormsurge, -- Stormsurge
		[391989] = L.stormcharged, -- Stormcharged (Positive or Negative)
		[394582] = L.focused_charge, -- Focused Charge (Damage Buff)
		[385574] = L.tempest_wing, -- Tempest Wing (Storm Wave)
		[377467] = L.fulminating_charge, -- Fulminating Charge (Charges)
		-- Intermission: The Vault Falters
		[389870] = L.storm_break, -- Storm Break (Teleport)
		[385068] = L.ball_lightning, -- Ball Lightning (Balls)
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
	self:Log("SPELL_CAST_START", "StormNova", 382434, 390463)

	-- Intermission: The Primalist Strike
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE") -- Lightning Devastation (emote shows when over your platform)
	-- self:Log("SPELL_CAST_START", "LightningDevastation", 385065)
	self:Log("SPELL_AURA_APPLIED", "LightningDevastationApplied", 388115)
	self:Log("SPELL_AURA_APPLIED", "SurgingBlastApplied", 396037)
	self:Log("SPELL_AURA_REMOVED", "SurgingBlastRemoved", 396037)
	self:Log("SPELL_CAST_START", "StormBolt", 385553)
	self:Log("SPELL_CAST_START", "ShatteringShroud", 397382)
	self:Log("SPELL_AURA_APPLIED", "ShatteringShroudApplied", 397382)
	self:Log("SPELL_AURA_REMOVED", "ShatteringShroudRemoved", 397382)
	self:Log("SPELL_AURA_APPLIED", "FlameShieldApplied", 397387)
	self:Death("IntermissionAddDeaths", 193760, 199547, 199549) -- Surging Ruiner, Frostforged Zealot, Flamesworn Herald

	-- Stage Two: Surging Power
	self:Log("SPELL_CAST_START", "Stormsurge", 387261)
	self:Log("SPELL_AURA_APPLIED", "StormsurgeApplied", 388691)
	self:Log("SPELL_AURA_REMOVED", "StormsurgeRemoved", 388691)
	self:Log("SPELL_AURA_APPLIED", "PositiveOrNegativeChargeApplied", 394576, 394579) -- Positive, Negative
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
	self:Death("StormfiendDeath", 197145) -- Colossal Stormfiend

	-- Stage Three: Storm Incarnate
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
	timers = self:Easy() and timersEasy or timersHeroic
	self:SetStage(1)
	-- Stage One: The Winds of Change
	hurricaneWingCount = 1
	staticChargeCount = 1
	volatileCurrentCount = 1
	thunderousBlastCount = 1
	lightningBreathCount = 1

	-- Intermission: The Primalist Strike
	lightningDevastationCount = 1

	-- Stage Two: Surging Power
	stormsurgeCount = 1
	tempestWingCount = 1
	fulminatingChargeCount = 1
	electrifiedJawsCount = 1

	-- Intermission: The Vault Falters
	stormBreakCount = 1
	ballLightningCount = 1

	-- Stage Three: Storm Incarnate
	magneticChargeCount = 1

	-- Mythic
	stormEaterCount = 1

	self:Bar(395906, timers[1][395906][electrifiedJawsCount], CL.count:format(self:SpellName(395906), electrifiedJawsCount))
	self:Bar(381615, timers[1][381615][staticChargeCount], CL.count:format(CL.bomb, staticChargeCount))
	self:Bar(377594, timers[1][377594][lightningBreathCount], CL.count:format(L.lightning_breath, lightningBreathCount))
	self:Bar(377612, timers[1][377612][hurricaneWingCount], CL.count:format(L.hurricane_wing, hurricaneWingCount))
	self:Bar(388643, timers[1][388643][volatileCurrentCount], CL.count:format(L.volatile_current, volatileCurrentCount))

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Phase Handlers
function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellId)
	if spellId == 396734 then -- Storm Shroud (Intermission start)
		if self:GetStage() == 1 then
			-- Storm Shroud -> Storm Nova -> Ruinous Shroud(388431) -> EE2(+24.38)

			self:SetStage(1.5)
			addDeathCount = 0
			lightningDevastationCount = 1

			self:StopBar(CL.count:format(self:SpellName(395906), electrifiedJawsCount)) -- Electrified Jaws
			self:StopBar(CL.count:format(L.lightning_breath, lightningBreathCount)) -- Lightning Breath
			self:StopBar(CL.count:format(L.volatile_current, volatileCurrentCount)) -- Volatile Current
			self:StopBar(CL.count:format(CL.bomb, staticChargeCount)) -- Static Charge
			self:StopBar(CL.count:format(L.hurricane_wing, hurricaneWingCount)) -- Hurricane Wing

			self:Message("stages", "cyan", CL.count:format(CL.intermission, 1), false)
			self:PlaySound("stages", "info") -- phase

			self:Bar(382434, 18.4) -- Storm Nova
			-- wait for the emote to get the timing for the platform you're on
			-- self:Bar(388115, self:Easy() and 38.2 or 36.7, L.lightning_devastation) -- Lightning Devastation

		elseif self:GetStage() == 2 then
			-- EE4(-1.54) -> Storm Shroud -> Lightning Strikes

			self:SetStage(2.5)
			addDeathCount = 0
			lightningDevastationCount = 1
			stormBreakCount = 1
			ballLightningCount = 1

			self:StopBar(CL.count:format(self:SpellName(395906), electrifiedJawsCount)) -- Electrified Jaws
			self:StopBar(CL.count:format(L.volatile_current, volatileCurrentCount)) -- Volatile Current
			self:StopBar(CL.count:format(L.fulminating_charge, fulminatingChargeCount)) -- Fulminating Charge
			self:StopBar(CL.count:format(L.tempest_wing, tempestWingCount)) -- Tempest Wing
			self:StopBar(CL.count:format(L.stormsurge, stormsurgeCount)) -- Stormsurge

			self:Message("stages", "cyan", CL.count:format(CL.intermission, 2), false)
			self:PlaySound("stages", "info") -- phase

			-- self:Bar(391402, 3.6) -- Lightning Strikes
			self:Bar(389870, self:Easy() and 25.6 or 19.5, CL.count:format(L.ball_lightning, ballLightningCount)) -- Ball Lightning
			self:Bar(385065, 29.2, CL.count:format(L.lightning_devastation, lightningDevastationCount)) -- Lightning Devastation
			self:Bar(389870, self:Easy() and 31.9 or 33, CL.count:format(L.storm_break, stormBreakCount)) -- Storm Break
		end
	elseif spellId == 392802 then -- Localized Storm Eater (Intermission 1 end)
		-- Localized Storm Eater -> Electric Scales -> Ruinous Shroud(398817) -> EE3(+14.61)

		self:StopBar(CL.count:format(L.lightning_devastation, lightningDevastationCount)) -- Lightning Devastation

		self:SetStage(2)
		stormsurgeCount = 1
		fulminatingChargeCount = 1
		volatileCurrentCount = 1
		tempestWingCount = 1
		electrifiedJawsCount = 1

		self:Message("stages", "cyan", CL.stage:format(2), false)
		self:PlaySound("stages", "info") -- phase

		self:Bar(387261, 14.6, CL.count:format(L.stormsurge, stormsurgeCount)) -- Stormsurge
		self:Bar(395906, 46.1, CL.count:format(self:SpellName(395906), electrifiedJawsCount)) -- Electrified Jaws
		self:Bar(385574, 49.6, CL.count:format(L.tempest_wing, tempestWingCount)) -- Tempest Wing
		self:Bar(385574, self:Easy() and 58.6 or 59.6, CL.count:format(L.fulminating_charge, fulminatingChargeCount)) -- Fulminating Charge
		self:Bar(388643, self:Easy() and 74.6 or 71.7, CL.count:format(L.volatile_current, volatileCurrentCount)) -- Volatile Current
	elseif spellId == 398466 then -- [DNT] Clear Raszageth Auras on Players (Intermission 2 end)
		-- Clear -> Storm Nova -> Raging Storm + EE5(+15.8)

		self:StopBar(CL.count:format(L.lightning_devastation, lightningDevastationCount)) -- Lightning Devastation
		self:StopBar(391402) -- Lightning Strikes

		self:SetStage(3)
		stormEaterCount = 1
		magneticChargeCount = 1
		fulminatingChargeCount = 1
		tempestWingCount = 1
		thunderousBlastCount = 1
		lightningBreathCount = 1

		self:Message("stages", "cyan", CL.stage:format(3), false)
		self:PlaySound("stages", "info") -- phase

		self:Bar(382434, 9.8) -- Storm Nova
		self:Bar(385569, 15.8) -- Raging Storm

		self:Bar(386410, 32.8, CL.count:format(L.thunderous_blast, thunderousBlastCount)) -- Thunderous Blast
		self:Bar(377594, self:Easy() and 44.8 or 42.2, CL.count:format(L.lightning_breath, lightningBreathCount)) -- Lightning Breath
		self:Bar(385574, 51.8, CL.count:format(L.fulminating_charge, fulminatingChargeCount)) -- Fulminating Charge
		self:Bar(385574, 76.8, CL.count:format(L.tempest_wing, tempestWingCount)) -- Tempest Wing
		if not self:Easy() then
			self:Bar(399713, 36.7, CL.count:format(L.magnetic_charge, magneticChargeCount)) -- Magnetic Charge
		end
		-- if self:Mythic() then
		-- 	self:Bar(395885, 40, CL.count:format(L.stormeater, stormEaterCount)) -- Storm-Eater
		-- end
	end
end

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 67 then -- Intermission 1 at 65%
		self:Message("stages", "green", CL.soon:format(CL.count:format(CL.intermission, 1)), false)
		self:PlaySound("stages", "info")
		self:UnregisterUnitEvent(event, unit)
	end
end

-- Stage One: The Winds of Change
function mod:HurricaneWing(args)
	self:StopBar(CL.count:format(L.hurricane_wing, hurricaneWingCount))
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(L.hurricane_wing, hurricaneWingCount)))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 6+1+hurricaneWingCount, CL.count:format(L.hurricane_wing, hurricaneWingCount)) -- 6s cast,  (1s+1s) base, +1s per cast
	hurricaneWingCount = hurricaneWingCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][hurricaneWingCount], CL.count:format(L.hurricane_wing, hurricaneWingCount))
end

do
	local playerList = {}
	local prev = 0
	function mod:StaticChargeApplied(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:CastBar(args.spellId, 8, CL.explosion)
			staticChargeCount = staticChargeCount + 1
			self:Bar(args.spellId, timers[self:GetStage()][args.spellId][staticChargeCount], CL.count:format(CL.bombs, staticChargeCount))
			playerList = {}
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.bomb)
			self:SayCountdown(args.spellId, 8)
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
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][volatileCurrentCount], CL.count:format(L.volatile_current, volatileCurrentCount))
end

function mod:ElectrifiedJaws(args)
	self:StopBar(CL.count:format(args.spellName, electrifiedJawsCount))
	self:Message(395906, "purple", CL.casting:format(CL.count:format(args.spellName, electrifiedJawsCount)))
	self:PlaySound(395906, "info")
	electrifiedJawsCount = electrifiedJawsCount + 1
	self:Bar(395906, timers[self:GetStage()][395906][electrifiedJawsCount], CL.count:format(args.spellName, electrifiedJawsCount))
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

function mod:LightningBreath(args)
	self:StopBar(CL.count:format(L.lightning_breath, lightningBreathCount))
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(L.lightning_breath, lightningBreathCount)))
	self:PlaySound(args.spellId, "alarm")
	lightningBreathCount = lightningBreathCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][lightningBreathCount], CL.count:format(L.lightning_breath, lightningBreathCount))
end

function mod:ElectricLashApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.electric_lash)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:StormNova(args)
	self:Message(382434, "yellow", CL.casting:format(args.spellName))
	self:PlaySound(382434, "alert")
	self:Bar(382434, {5, self:GetStage() == 1.5 and 18.4 or 9.8})
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find(L.lighting_devastation_trigger, nil, true) then
		self:Message(385065, "yellow", CL.count:format(L.lightning_devastation, lightningDevastationCount))
		self:PlaySound(385065, "alert")
		local cd = 0
		if self:Easy() then
			cd = self:GetStage() == 1.5 and 27 or 32.8
		else--if self:Heroic() then
			cd = self:GetStage() == 1.5 and 24.6 or 31.3
		end
		self:Bar(385065, cd, CL.count:format(L.lightning_devastation, lightningDevastationCount))
	end
end

-- function mod:LightningDevastation(args)
-- 	self:StopBar(CL.count:format(L.lightning_devastation, lightningDevastationCount))
-- 	self:Message(args.spellId, "yellow", CL.count:format(L.lightning_devastation, lightningDevastationCount))
-- 	self:PlaySound(args.spellId, "alert")
-- 	lightningDevastationCount = lightningDevastationCount + 1
-- 	self:Bar(args.spellId, self:GetStage() > 2 and 22 or 13.3, CL.count:format(L.lightning_devastation, lightningDevastationCount))
-- end

function mod:LightningDevastationApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(385065)
		self:PlaySound(385065, "warning")
	end
end

function mod:SurgingBlastApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.bomb)
		self:Say(args.spellId, CL.bomb)
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
	self:Message(args.spellId, "yellow", CL.casting:format(L.shattering_shroud))
	if self:Healer() then
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:ShatteringShroudApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.shattering_shroud)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:ShatteringShroudRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(L.shattering_shroud))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:FlameShieldApplied(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:IntermissionAddDeaths(args)
	if args.mobId == 193760 then -- Surging Ruiner
		addDeathCount = addDeathCount + 1
		self:Message("stages", "green", CL.add_killed:format(addDeathCount, 6), false)
	end
end

-- Stage Two: Surging Power
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

		self:CloseInfo(387261)
		if timer then
			self:CancelTimer(timer)
			timer = nil
		end
	end
end

function mod:PositiveOrNegativeChargeApplied(args)
	if self:Me(args.destGUID) then
		-- Positive is default
		local msg = L.positive
		local sayMsg = "{rt6}" -- Square/Blue
		if args.spellId == 391991 or args.spellId == 394575 or args.spellId == 394579 then -- Negative
			msg = L.negative
			sayMsg = "{rt7}" -- Cross/Red
			self:Message(391989, "red", msg)
		else
			self:Message(391989, "blue", msg)
		end
		self:Say(391989, sayMsg, true)
		self:PlaySound(391989, "warning")
	end
end

do
	local prev = 0
	function mod:FocusedChargeApplied(args)
		if self:Me(args.destGUID) then
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
	function mod:FulminatingCharge(args)
		self:StopBar(CL.count:format(L.fulminating_charge, fulminatingChargeCount))
		--self:Message(377467, "yellow", CL.count:format(L.fulminating_charge, fulminatingChargeCount))
		self:PlaySound(377467, "long")
		fulminatingChargeCount = fulminatingChargeCount + 1
		self:Bar(377467, timers[self:GetStage()][377467][fulminatingChargeCount], CL.count:format(L.fulminating_charge, fulminatingChargeCount))
		playerList = {}
	end

	function mod:FulminatingChargeApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, L.fulminating_charge_debuff)
			self:SayCountdown(args.spellId, 5)
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, 3, CL.count:format(L.fulminating_charge, fulminatingChargeCount-1))
		self:CustomIcon(fulminatingChargeCount, args.destName, count)
	end

	function mod:FulminatingChargeRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(fulminatingChargeCount, args.destName)
	end
end

do
	local prev = 0
	function mod:StormBreak(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:StopBar(CL.count:format(L.storm_break, stormBreakCount))
			self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(L.storm_break, stormBreakCount)))
			self:PlaySound(args.spellId, "alert")
			stormBreakCount = stormBreakCount + 1
			self:Bar(args.spellId, 25, CL.count:format(L.storm_break, stormBreakCount))
		end
	end
end

function mod:FuseStacks(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, "purple", args.destName, amount, amount)
	self:PlaySound(args.spellId, "alarm")
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
			self:Bar(args.spellId, 22, CL.count:format(L.ball_lightning, ballLightningCount))
		end
	end
end

function mod:StormfiendDeath(args)
	addDeathCount = addDeathCount + 1
	if self:Easy() or addDeathCount == 2 then
		self:StopBar(CL.count:format(L.storm_break, stormBreakCount))
		self:StopBar(CL.count:format(L.ball_lightning, ballLightningCount))
	end
end

-- Stage Three: Storm Incarnate
function mod:RagingStorm(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "info")
end

function mod:MagneticCharge(args)
	magneticChargeCount = magneticChargeCount + 1
	self:Bar(args.spellId, timers[3][args.spellId][magneticChargeCount], CL.count:format(L.magnetic_charge, magneticChargeCount))
end

function mod:MagneticChargeApplied(args)
	if self:Me(args.destGUID) then
		self:Say(args.spellId, L.magnetic_charge)
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
		self:Say(args.spellId, L.thunderous_blast)
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
function mod:InversionApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:Say(args.spellId, nil, true)
		self:SayCountdown(args.spellId, 6)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:StormEater(args)
	self:StopBar(CL.count:format(L.storm_eater, stormEaterCount))
	self:Message(args.spellId, "orange", CL.count:format(L.storm_eater, stormEaterCount))
	self:PlaySound(args.spellId, "alert")
	stormEaterCount = stormEaterCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(L.storm_eater, stormEaterCount))
end
