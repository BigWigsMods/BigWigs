--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Broodkeeper Diurna", 2522, 2493)
if not mod then return end
mod:RegisterEnableMob(190245) -- Broodkeeper Diurna
mod:SetEncounterID(2614)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local mobCollector = {}
local marksUsed = {}
local greatstaffCount = 1
local rapidIncubationCount = 1
local wildfireCount = 1
local icyShroudCount = 1
local primalReinforcementsCount = 1
local stormFissureCount = 1
local showFissures = false
local stoneClawsCount = 1
local detonatingStoneslamCount = 1
local encounterStartTime = 0
local lastShroud = 0
local lastStaff = 0

local timersEasy = {
	-- Primalist Reinforcements // Throttled with 10s
	[-25129] = {35.5, 25.0, 36.5, 25.0, 43.0, 25.0, 37.0, 25.0, 44.5, 24.0},
}

local timersHeroic = {
	-- Primalist Reinforcements // Throttled with 10s
	[-25129] = {35.5, 20.0, 36.5, 20.0, 43.5, 20.0, 37.0, 20.0, 43.0, 20.0},
}

local timersMythic = {
	-- Primalist Reinforcements // Throttled with 10s
	-- Adjustments made to time they can be attacked (vs log event)
	-- Adds 3: -4s
	-- Adds 4: -2.6s
	-- Adds 6: -3s
	-- Adds 7: -3s
	[-25129] = {32.3, 15.0, 45.2, 11.6, 41.6, 15.3, 42.0, 12.3, 41.7, 18.5, 40.5, 16},
	-- (Empowered) Greatstaff of the Broodkeeper
	-- Table based on combat time since pull so we can fix timers depening on push time
	[380175] = {16.2, 41.2, 66.2, 91.2, 118.6, 141.2, 166.2, 191.2, 216.2, 241.2, 266.2, 292.8, 322.7, 348.3, 366.2, 391.2, 416.2, 441.2, 473.8, 491.2, 522.3, 541.2, 566.2, 591.2},
	-- Mortal Stoneclaws / Mortal Stoneslam
	-- Table based on combat time since pull so we can fix timers depening on push time
	[375870] = {3.3, 31.8, 51.3, 75.3, 99.3, 123.3, 147.3, 171.3, 195.3, 219.3, 243.3, 267.3, 293.8, 315.3, 340.8, 363.3, 388.3, 413.3, 438.3, 463.3, 485.8, 507.3, 531.3, 557.8, 580.3},
	-- Wildfire
	-- (This spell is not affected by delays due to transition)
	[375871] = {8.2, 25.9, 24.1, 25.0, 25.0, 25.0, 25.0, 25.0, 25.0, 25.0, 25.0, 25.0, 25.0, 25.0, 25.0, 25.0, 25.0, 25.0, 25.0, 25.0, 26.5, 24.0, 26.2, 23.3},
	-- Icy Shroud / Frozen Shroud
	--  (This spell is not affected by delays due to transition)
	[388716] = {26.0, 44.0, 45.5, 45.0, 43.0, 42.5, 44.0, 48.0, 42.0, 42.0, 44.0, 48.5, 40.5, 43.0}
}
local timers = mod:Mythic() and timersMythic or mod:Heroic() and timersHeroic or timersEasy


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.eggs_remaining = "%d Eggs Remaining!"
	L.broodkeepers_bond = "Eggs Remaining"
	L.greatstaff_of_the_broodkeeper = "Greatstaff"
	L.clutchwatchers_rage = "Rage"
	L.rapid_incubation = "Infuse Eggs"
	L.broodkeepers_fury = "Fury"
	L.frozen_shroud = "Root Absorb"
	L.detonating_stoneslam = "Tank Soak"
end

--------------------------------------------------------------------------------
-- Initialization
--

local primalistMageMarker = mod:AddMarkerOption(false, "npc", 1, -25144, 6, 5, 4) -- Primalist Mage
local stormBringerMarker = mod:AddMarkerOption(false, "npc", 8, -25139, 8, 7) -- Drakonid Stormbringer
function mod:GetOptions()
	return {
		-- Stage One: The Primalist Clutch
		375809, -- Broodkeeper's Bond
		380175, -- Greatstaff of the Broodkeeper
		{375889, "SAY"}, -- Greatstaff's Wrath
		375829, -- Clutchwatcher's Rage
		376073, -- Rapid Incubation
		375871, -- Wildfire
		388716, -- Icy Shroud
		{375870, "TANK"}, -- Mortal Stoneclaws
		{378782, "TANK_HEALER"}, -- Mortal Wounds

		-25129, -- Primalist Reinforcements
		-- Primalist Mage
		375716, -- Ice Barrage
		primalistMageMarker,
		-- Tarasek Earthreaver
		{376266, "TANK"}, -- Burrowing Strike
		{376257}, -- Tremors
		-- Dragonspawn Flamebender
		{375485}, -- Cauterizing Flashflames
		{375575}, -- Flame Sentry
		-- Juvenile Frost Proto-Dragon
		{375475, "TANK"}, -- Rending Bite
		{375457}, -- Chilling Tantrum
		-- Drakonid Stormbringer
		375653, -- Static Jolt
		{375620, "ME_ONLY", "SAY", "ME_ONLY_EMPHASIZE"}, -- Ionizing Charge
		stormBringerMarker,

		-- Stage Two: A Broodkeeper Scorned
		375879, -- Broodkeeper's Fury
		392194, -- Empowered Greatstaff of the Broodkeeper
		{380483, "SAY"}, -- Empowered Greatstaff's Wrath
		388918, -- Frozen Shroud

		-- Mythic
		396779, -- Storm Fissure
		396269, -- Mortal Stoneslam
		{396266, "TANK_HEALER"}, -- Mortal Suffering
		{396264, "SAY", "SAY_COUNTDOWN"}, -- Detonating Stoneslam
		"berserk",
	}, {
		[375809] = -25119, -- Stage One: The Primalist Clutch
		[375716] = -25144, -- Primalist Mage
		[376266] = -25130, -- Tarasek Earthreaver
		[375485] = -25133, -- Dragonspawn Flamebender
		[375475] = -25136, -- Juvenile Frost Proto-Dragon
		[375653] = -25139, -- Drakonid Stormbringer
		[375879] = -25146, -- Stage Two: A Broodkeeper Scorned
		[396269] = "mythic", -- Mythic
	}, {
		[375809] = L.broodkeepers_bond, -- Broodkeeper's Bond (Eggs Remaining)
		[380175] = L.greatstaff_of_the_broodkeeper, -- Greatstaff of the Broodkeeper (Greatstaff)
		[375889] = CL.laser, -- Greatstaff's Wrath (Laser)
		[375829] = L.clutchwatchers_rage, -- Clutchwatcher's Rage (Rage)
		[376073] = L.rapid_incubation, -- Rapid Incubation (Infuse Eggs)
		[388716] = CL.heal_absorb, -- Icy Shroud (Heal Absorb)
		[-25129] = CL.adds, -- Primalist Reinforcements (Adds)
		[375879] = L.broodkeepers_fury, --  Broodkeeper's Fury (Fury)
		[392194] = L.greatstaff_of_the_broodkeeper, -- Empowered Greatstaff of the Broodkeeper (Greatstaff)
		[380483] = CL.laser, -- Empowered Greatstaff's Wrath (Laser)
		[388918] = L.frozen_shroud, -- Frozen Shroud (Root Absorb)
		[396264] = L.detonating_stoneslam, -- Detonating Stoneslam (Tank Soak)
	}
end

function mod:OnBossEnable()
	-- Stage One: The Primalist Clutch
	self:Log("SPELL_AURA_REMOVED_DOSE", "BroodkeepersBondStacks", 375809)
	self:Log("SPELL_AURA_REMOVED", "BroodkeepersBondRemoved", 375809)
	self:Log("SPELL_CAST_SUCCESS", "GreatstaffOfTheBroodkeeper", 380175, 392194) -- Stage 1, Stage 2 (Empowered)
	self:Log("SPELL_AURA_APPLIED", "GreatstaffsWrathApplied", 375889, 380483) -- Stage 1, Stage 2 (Empowered)
	self:Log("SPELL_AURA_APPLIED", "ClutchwatchersRage", 375829)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ClutchwatchersRage", 375829)
	self:RegisterUnitEvent("UNIT_SPELLCAST_START", nil, "boss1") -- Rapid Incubation-376073
	-- self:Log("SPELL_CAST_START", "RapidIncubation", 376073) -- hidden z.z?
	self:Log("SPELL_CAST_START", "Wildfire", 375871)
	self:Log("SPELL_CAST_START", "IcyShroud", 388716, 388918) -- Stage 1, Stage 2 (Frozen Shroud)
	self:Log("SPELL_CAST_START", "MortalStoneclaws", 375870)
	self:Log("SPELL_AURA_APPLIED", "MortalWounds", 378782)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MortalWounds", 378782)

	self:Log("SPELL_CAST_SUCCESS", "AddSpawns", 181113)
	self:Death("AddDeaths", 191206, 191232) -- Primalist Mage, Drakonid Stormbringer
	-- Primalist Mage
	self:Log("SPELL_CAST_START", "IceBarrage", 375716)
	-- Tarasek Earthreaver
	self:Log("SPELL_CAST_SUCCESS", "BurrowingStrike", 376266)
	self:Log("SPELL_AURA_APPLIED", "BurrowingStrikeApplied", 376266)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BurrowingStrikeApplied", 376266)
	self:Log("SPELL_CAST_START", "Tremors", 376257)
	-- Dragonspawn Flamebender
	self:Log("SPELL_CAST_START", "CauterizingFlashflames", 375485)
	self:Log("SPELL_CAST_START", "FlameSentry", 375575)
	-- Juvenile Frost Proto-Dragon
	self:Log("SPELL_CAST_SUCCESS", "RendingBite", 375475)
	self:Log("SPELL_AURA_APPLIED", "RendingBiteApplied", 375475)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RendingBiteApplied", 375475)
	self:Log("SPELL_CAST_START", "ChillingTantrum", 375457)
	-- Drakonid Stormbringer
	self:Log("SPELL_CAST_START", "StaticJolt", 375653)
	self:Log("SPELL_CAST_START", "IonizingCharge", 375630)
	self:Log("SPELL_AURA_APPLIED", "IonizingChargeApplied", 375620)
	self:Log("SPELL_AURA_REMOVED", "IonizingChargeRemoved", 375620)
	self:Log("SPELL_DAMAGE", "IonizingChargeDamage", 375634)
	self:Log("SPELL_MISSED", "IonizingChargeDamage", 375634)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 375575) -- Flame Sentry
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 375575)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 375575)

	-- Stage Two: A Broodkeeper Scorned
	self:Log("SPELL_AURA_APPLIED", "BroodkeepersFury", 375879)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BroodkeepersFury", 375879)

	-- Mythic
	self:Log("SPELL_CAST_START", "StormFissure", 396779)
	self:Log("SPELL_CAST_SUCCESS", "MortalStoneslam", 396269)
	self:Log("SPELL_AURA_APPLIED", "DetonatingStoneslamApplied", 396264)
	self:Log("SPELL_AURA_REMOVED", "DetonatingStoneslamRemoved", 396264)
	self:Log("SPELL_AURA_APPLIED", "MortalSuffering", 396266)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MortalSuffering", 396266)
end

function mod:OnEngage()
	self:SetStage(1)
	timers = self:Mythic() and timersMythic or self:Heroic() and timersHeroic or timersEasy
	encounterStartTime = GetTime()
	mobCollector = {}
	marksUsed = {}
	greatstaffCount = 1
	rapidIncubationCount = 1
	wildfireCount = 1
	icyShroudCount = 1
	stoneClawsCount = 1
	primalReinforcementsCount = 1
	stormFissureCount = 1
	showFissures = false

	self:Bar(375870, 4.7) -- Mortal Stoneclaws
	self:CDBar(375871, 8.5, CL.count:format(self:SpellName(375871), wildfireCount)) -- Wildfire
	self:CDBar(376073, 13, CL.count:format(L.rapid_incubation, rapidIncubationCount)) -- Rapid Incubation
	self:CDBar(380175, 17, CL.count:format(L.greatstaff_of_the_broodkeeper, greatstaffCount)) -- Greatstaff of the Broodkeeper
	self:CDBar(-25129, self:Easy() and 35.7 or 33, CL.count:format(CL.adds, primalReinforcementsCount), "inv_dragonwhelpproto_blue") -- Primalist Reinforcements / Adds
	self:CDBar(388716, 26.5, CL.count:format(CL.heal_absorb, icyShroudCount)) -- Icy Shroud
	self:Bar(375879, self:Easy() and 317 or 300, CL.stage:format(2)) -- Broodkeeper's Fury

	if self:Mythic() then
		self:Berserk(600, true)
	end
	if self:GetOption(primalistMageMarker) or self:GetOption(stormBringerMarker) then
		self:RegisterTargetEvents("AddMarking")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_START(_, _, _, spellId)
	if spellId == 376073 then -- Rapid Incubation
		self:RapidIncubation()
	end
end

function mod:AddMarking(_, unit, guid)
	if not mobCollector[guid] then
		local mobId = self:MobId(guid)
		if mobId == 191206 then -- Primalist Mage
			for i = 6, 4, -1 do -- 6, 5, 4
				if not marksUsed[i] then
					mobCollector[guid] = true
					marksUsed[i] = guid
					self:CustomIcon(primalistMageMarker, unit, i)
					return
				end
			end
		elseif mobId == 191232 then -- Drakonid Stormbringer
			for i = 8, 7, -1 do -- 8, 7
				if not marksUsed[i] then
					mobCollector[guid] = true
					marksUsed[i] = guid
					self:CustomIcon(stormBringerMarker, unit, i)
					return
				end
			end
		end
	end
end

function mod:AddDeaths(args)
	if args.mobId == 191206 and self:GetOption(primalistMageMarker) then
		for i = 6, 4, -1 do -- 6, 5, 4
			if marksUsed[i] == args.destGUID then
				marksUsed[i] = nil
				return
			end
		end
	elseif args.mobId == 191232 and self:GetOption(stormBringerMarker) then
		for i = 8, 7, -1 do -- 8, 7
			if marksUsed[i] == args.destGUID then
				marksUsed[i] = nil
				break
			end
		end
	end
end

-- Stage One: The Primalist Clutch
do
	local stacks = 0
	local scheduled = nil
	function mod:BroodkeepersBondMessage()
		mod:Message(375809, "cyan", L.eggs_remaining:format(stacks))
		mod:PlaySound(375809, "info")
		scheduled = nil
	end

	function mod:BroodkeepersBondStacks(args)
		stacks = args.amount or 0
		if not scheduled then
			scheduled = self:ScheduleTimer("BroodkeepersBondMessage", 2) -- Throttle here
		end
		if stacks < 4 then -- 3 eggs left, start showing timer for Storm Fissure
			showFissures = true
		end
	end

	function mod:BroodkeepersBondRemoved(args)
		if scheduled then
			self:CancelTimer(scheduled)
			scheduled = nil
		end
		self:Message(args.spellId, "green", L.eggs_remaining:format(0))
		self:PlaySound(args.spellId, "long")
	end
end

function mod:GreatstaffOfTheBroodkeeper(args)
	self:StopBar(CL.count:format(L.greatstaff_of_the_broodkeeper, greatstaffCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.greatstaff_of_the_broodkeeper, greatstaffCount), 380175) -- Same icon for stage 1 + 2
	self:PlaySound(args.spellId, "alert")
	greatstaffCount = greatstaffCount + 1
	local cd = 25
	if self:Mythic() then -- Adjust for inaccuracies
		cd = timers[380175][greatstaffCount] - (GetTime() - encounterStartTime)
	end
	self:Bar(args.spellId, cd, CL.count:format(L.greatstaff_of_the_broodkeeper, greatstaffCount), 380175) -- Same icon for stage 1 + 2
	lastStaff = args.time
end

function mod:GreatstaffsWrathApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.laser)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId, CL.laser, nil, "Laser")
	end
end

function mod:ClutchwatchersRage(args)
	local amount = args.amount or 1
	self:Message(args.spellId, "orange", CL.count:format(L.clutchwatchers_rage, amount))
	if amount == 1 then
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:RapidIncubation()
	self:StopBar(CL.count:format(L.rapid_incubation, rapidIncubationCount))
	self:Message(376073, "yellow", CL.count:format(L.rapid_incubation, rapidIncubationCount))
	self:PlaySound(376073, "alert")
	rapidIncubationCount = rapidIncubationCount + 1
	self:Bar(376073, self:Easy() and 27 or 25, CL.count:format(L.rapid_incubation, rapidIncubationCount))
end

do
	local prev = 0
	function mod:Wildfire(args)
		local t = args.time
		if t-prev > 10 then -- Double casts in stage 2
			prev = t
			self:StopBar(CL.count:format(args.spellName, wildfireCount))
			self:Message(args.spellId, "yellow")
			self:PlaySound(args.spellId, "alert")
			wildfireCount = wildfireCount + 1
			local cd = 25
			if self:Heroic() then
				-- delayed by shroud
				if wildfireCount == 7 then
					cd = 27.6
				elseif wildfireCount == 8 then
					cd = 22.5
				end
			elseif self:Mythic() then
				cd = timers[args.spellId][wildfireCount]
			end
			self:Bar(args.spellId, cd, CL.count:format(args.spellName, wildfireCount))
		end
	end
end

function mod:IcyShroud(args)
	self:StopBar(CL.count:format(CL.heal_absorb, icyShroudCount))
	self:StopBar(CL.count:format(L.frozen_shroud, icyShroudCount))
	local text = self:GetStage() == 2 and L.frozen_shroud or CL.heal_absorb
	self:Message(args.spellId, "yellow", CL.count:format(text, icyShroudCount))
	self:PlaySound(args.spellId, "alert")
	icyShroudCount = icyShroudCount + 1
	local cd = 44
	-- delayed by wildfire/greatstaff
	if self:Heroic() then
		if icyShroudCount == 3 or icyShroudCount == 8 then
			cd = 47
		elseif icyShroudCount == 4 then
			cd = 41
		elseif icyShroudCount == 9 then
			cd = 40
		end
	elseif self:Mythic() then
		cd = timers[388716][icyShroudCount]
	end
	self:Bar(args.spellId, cd, CL.count:format(text, icyShroudCount))
	lastShroud = args.time
end

function mod:MortalStoneclaws(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	local cd = 24
	stoneClawsCount = stoneClawsCount + 1
	if self:Mythic() then -- Adjust for inaccuracies
		cd = timers[375870][stoneClawsCount] - (GetTime() - encounterStartTime)
	end
	self:CDBar(args.spellId, cd)
end

function mod:MortalWounds(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	if self:Tank() and not self:Me(args.destGUID) and not self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then
		self:PlaySound(args.spellId, "warning") -- tauntswap
	elseif self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	end
end

do
	local prev = 0
	function mod:AddSpawns(args)
		local t = args.time
		if t-prev > 10 then -- Have seen some late spawns in a wave, 10 for safety
			prev = t
			self:StopBar(CL.count:format(CL.adds, primalReinforcementsCount))
			self:Message(-25129, "yellow", CL.count:format(CL.adds, primalReinforcementsCount), "inv_dragonwhelpproto_blue")
			self:PlaySound(-25129, "long")
			primalReinforcementsCount = primalReinforcementsCount + 1
			self:CDBar(-25129, timers[-25129][primalReinforcementsCount], CL.count:format(CL.adds, primalReinforcementsCount), "inv_dragonwhelpproto_blue")
		end
	end
end

-- Primalist Mage
function mod:IceBarrage(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

-- Tarasek Earthreaver
function mod:BurrowingStrike(args)
	--self:NameplateBar(args.spellId, 8.8, args.sourceGUID)
end

function mod:BurrowingStrikeApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "purple", args.destName, amount, 1)
		if amount > 2 then -- Pay attention on 3+
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	local prev = 0
	function mod:Tremors(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "orange")
			self:PlaySound(args.spellId, "alert")
		end
		--self:NameplateBar(args.spellId, 11.0, args.sourceGUID)
	end
end

-- Dragonspawn Flamebender
do
	local prev = 0
	function mod:CauterizingFlashflames(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "red")
			self:PlaySound(args.spellId, "alarm")
		end
		--self:NameplateBar(args.spellId, 11.5, args.sourceGUID)
	end
end

do
	local prev = 0
	function mod:FlameSentry(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "cyan")
			self:PlaySound(args.spellId, "info")
		end
		--self:NameplateBar(args.spellId, 11.5, args.sourceGUID)
	end
end

-- Juvenile Frost Proto-Dragon
function mod:RendingBite(args)
	--self:NameplateBar(args.spellId, 11.5, args.sourceGUID)
end

function mod:RendingBiteApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm")
	end
end

do
	local prev = 0
	function mod:ChillingTantrum(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "yellow")
			self:PlaySound(args.spellId, "alarm")
		end
		--self:NameplateBar(args.spellId, 11.5, args.sourceGUID)
	end
end

-- Drakonid Stormbringer
function mod:StaticJolt(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

do
	local playerList = {}
	local onMe = false
	function mod:IonizingCharge()
		playerList = {}
	end

	function mod:IonizingChargeApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			onMe = true
			self:Say(args.spellId, nil, nil, "Ionizing Charge")
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end

	function mod:IonizingChargeRemoved(args)
		if self:Me(args.destGUID) then
			onMe = false
		end
	end

	function mod:IonizingChargeDamage(args)
		if self:Me(args.destGUID) and not onMe then
			self:PlaySound(375620, "underyou")
		end
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

-- Stage Two: A Broodkeeper Scorned
function mod:BroodkeepersFury(args)
	local amount = args.amount or 1
	if amount == 1 then
		self:StopBar(CL.stage:format(2))
		self:StopBar(CL.count:format(CL.adds, primalReinforcementsCount))
		self:StopBar(CL.count:format(L.rapid_incubation, rapidIncubationCount))
		self:StopBar(CL.count:format(L.greatstaff_of_the_broodkeeper, greatstaffCount)) -- Greatstaff of the Broodkeeper
		self:StopBar(CL.count:format(CL.heal_absorb, icyShroudCount)) -- Icy Shroud

		self:SetStage(2)
		showFissures = true
		self:Message(args.spellId, "cyan", ("%s - %s"):format(CL.stage:format(2), CL.count:format(L.broodkeepers_fury, amount)))
		self:PlaySound(args.spellId, "long") -- phase

		-- Restart timers for the empowered / adjusted abilities
		local nextShroud = 44 - (args.time - lastShroud) -- Improve for Heroic and below
		if self:Mythic() then -- Adjust for inaccuracies
			nextShroud = timers[388716][icyShroudCount] - (args.time - lastShroud)
		end
		self:Bar(388918, {nextShroud, 44}, CL.count:format(L.frozen_shroud, icyShroudCount)) -- 44 is an approximation

		local nextStaff = 25 - (args.time - lastStaff)
		if self:Mythic() then -- Adjust for inaccuracies
			nextStaff = timers[380175][greatstaffCount] - (GetTime() - encounterStartTime)
			if greatstaffCount == 12 then -- Add 5s
				nextStaff = nextStaff + 5
			end
		end
		self:Bar(args.spellId, nextStaff, CL.count:format(L.greatstaff_of_the_broodkeeper, greatstaffCount), 380175)

		if self:Mythic() then
			self:StopBar(375870) -- Mortal Stoneclaws
			local nextClaws = timers[375870][stoneClawsCount] - (GetTime() - encounterStartTime)
			if greatstaffCount == 12 then -- Add 7s
				nextClaws = nextClaws + 7
			end
			detonatingStoneslamCount = 1
			self:Bar(396269, nextClaws, CL.count:format(L.detonating_stoneslam, detonatingStoneslamCount))
		end
	else
		self:StopBar(CL.count:format(L.broodkeepers_fury, amount))
		self:Message(args.spellId, "cyan", CL.count:format(L.broodkeepers_fury, amount))
	end
	self:Bar(args.spellId, 30, CL.count:format(L.broodkeepers_fury, amount + 1))
end

function mod:StormFissure(args)
	if showFissures then
		self:StopBar(CL.count:format(args.spellName, stormFissureCount))
		self:Message(args.spellId, "yellow", CL.count:format(args.spellName, stormFissureCount))
		self:PlaySound(args.spellId, "alert")
		self:CDBar(args.spellId, 24, CL.count:format(args.spellName, stormFissureCount+1))
	end
	stormFissureCount = stormFissureCount + 1
end

function mod:MortalStoneslam(args)
	-- tank message from Mortal Suffering, raid message from Detonating Stoneslam
	stoneClawsCount = stoneClawsCount + 1
	detonatingStoneslamCount = detonatingStoneslamCount + 1
	local cd = nil
	if timers[375870][stoneClawsCount] then
		cd = timers[375870][stoneClawsCount] - (GetTime() - encounterStartTime)
	end
	self:Bar(args.spellId, cd, CL.count:format(L.detonating_stoneslam, detonatingStoneslamCount))
end

function mod:DetonatingStoneslamApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName, CL.count:format(L.detonating_stoneslam, detonatingStoneslamCount-1))
	self:TargetBar(args.spellId, 6, args.destName, CL.count:format(L.detonating_stoneslam, detonatingStoneslamCount-1))
	if self:Me(args.destGUID) then
		self:Say(args.spellId, L.detonating_stoneslam, nil, "Tank Soak")
		self:SayCountdown(args.spellId, 6)
	else
		self:PlaySound(args.spellId, "warning") -- danger
	end
end

function mod:MortalSuffering(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	if self:Tank() and not self:Me(args.destGUID) and not self:Tanking(self:UnitTokenFromGUID(args.sourceGUID)) then
		self:PlaySound(args.spellId, "warning") -- tauntswap
	elseif self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	end
end

function mod:DetonatingStoneslamRemoved(args)
	self:StopBar(CL.count:format(L.detonating_stoneslam, detonatingStoneslamCount-1), args.destName)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end
