
-- TODO: Mark bomb adds: Darkfuse Technician / Giga-Juiced Technician

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Chrome King Gallywix", 2769, 2646)
if not mod then return end
mod:RegisterEnableMob(231075) -- XXX Confirm on Live
mod:SetEncounterID(3016)
mod:SetRespawnTime(30)
mod:SetPrivateAuraSounds({
	466155, -- Sapper's Satchel
	466344, -- Fused Canisters
	{ -- Overloaded Rockets
		1214760, 1214749, 1214750, 1214757, 1214758, 1214759, 1214761,
		1214762, 1214763, 1214764, 1214765, 1214766, 1214767
	},
	1219279, -- Gallybux Pest Eliminator
	1218550 -- Biggest Baddest Bomb Barrage
})
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local canistersCount = 1
local bigBadBunchaBombsCount = 1
local suppressionCount = 1
local ventingHeatCount = 1

local gigaCoilsCount = 1
local controlMeltdownCount = 1

local spawnedDuds = 0

local timersNormal = {
	{ -- Phase 1
		[466340] = { 0 }, -- Scatterblast Canisters
		[465952] = { 0 }, -- Big Bad Buncha Bombs
		[467182] = { 0 }, -- Suppression
		[466751] = { 0 }, -- Venting Heat
	},
	{ -- Phase 2
		[469286] = { 0 }, -- Giga Coils
		[466341] = { 0 }, -- Fused Canisters
		[465952] = { 0 }, -- Big Bad Buncha Bombs
		[467182] = { 0 }, -- Suppression
		[466751] = { 0 }, -- Venting Heat
	},
	{ -- Phase 3
		[469286] = { 0 }, -- Giga Coils
		[466342] = { 0 }, -- Tick-Tock Canisters
		[1214607] = { 0 }, -- Bigger Badder Bomb Blast
		[467182] = { 0 }, -- Suppression
		[466751] = { 0 }, -- Venting Heat
	}
}
local timers = timersNormal

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.scatterblast_canisters = "Cone Soak"
	L.fused_canisters = "Group Soaks"
	L.tick_tock_canisters = "Soaks"

	L.duds = "Duds" -- Short for 1500-Pound "Dud"
	L.all_duds_detontated = "All Duds Detonated!"
	L.duds_remaining = "%d |4Dud remains:Duds remaining;" -- 1 Dud Remains | 2 Duds Remaining
	L.duds_soak = "Soak Duds (%d left)"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		1220761, -- Mechengineer's Canisters

		-- Stage One: The House of Chrome
		466340, -- Scatterblast Canisters
				-- 474447, -- Canister Detonation
		465952, -- Big Bad Buncha Bombs
			466154, -- Blast Burns
			-- 466153, -- Bad Belated Boom
			-- {466155, "PRIVATE"}, -- Sapper's Satchel
				--1217290, -- Another in the Bag
			466165, -- 1500-Pound "Dud"
				466246, -- Focused Detonation
					1217292, -- Time-Release Crackle
			-- 466338, -- Zagging Zizzler
		467182, -- Suppression
		466751, -- Venting Heat
			--466753, -- Overheating
		-- Greedy Goblin's Armaments
		-- 471225, -- Gatling Cannon
		{1220290, "TANK"}, -- Trick Shots
		-- -- Stage Two: Mechanical Maniac
		469286, -- Giga Coils
			469327, -- Giga Blast
			469404, -- Giga BOOM!
		-- 	469297, -- Sabotaged Controls
				1220846, -- Control Meltdown
			1215209, -- Sabotage Zone
		-- 	1219313, -- Overloaded Bolts
		{466341, "PRIVATE"}, -- Fused Canisters
		-- -- Darkfuse Cronies
		-31482, -- Darkfuse Technician
			469362, -- Charged Giga Bomb
		-- 		469363, -- Fling Giga Bomb
		-- 		469767, -- Giga Bomb Detonation
			471352, -- Juice It!
		-- 	1223126, -- Party Crashing Rocket
		-- 	-- Sharpshot Sentry
			466834, -- Shock Barrage
		-- 	-- Darkfuse Wrenchmonger
			1216845, -- Wrench
			1216852, -- Lumbering Rage
		-- -- Intermission: Docked and Loaded
		1214226, -- Cratering
		1214229, -- Armageddon-class Plating
		-- 1219319, -- Radiant Electricity
		1214369, -- TOTAL DESTRUCTION!!!
		-- -- Stage Three: What an Arsenal!
		1214607, -- Bigger Badder Bomb Blast
		-- 	{1214755, "PRIVATE"}, -- Overloaded Rockets
		466342, -- Tick-Tock Canisters
		-- 1219333, -- Gallybux Finale Blast (Stage 3 Supression)
		-- -- Greedy Goblin's Armaments
			466958, -- Ego Check
				-- 467064, -- Checked Ego
	},{ -- Sections
		[466340] = -30490, -- Stage One: The House of Chrome
		[469286] = -30497, -- Stage Two: Mechanical Maniac
		[1214226] = -31558, -- Intermission: Docked and Loaded
		[1214607] = -31445, -- Stage Three: What an Arsenal!
	},{ -- Renames
		[466340] = L.scatterblast_canisters, -- Scatterblast Canisters (Cone Soak)
		[465952] = CL.bombs, -- Big Bad Buncha Bombs (Bombs)
		[466165] = L.duds, -- 1500-Pound "Dud" (Duds)
		[1217292] = CL.explosion, -- Time-Release Crackle (Explosion)
		[466341] = L.fused_canisters, -- Fused Canisters (Group Soaks)
		[1214607] = CL.bombs, -- Bigger Badder Bomb Blast (Bombs)
		[466342] = L.tick_tock_canisters, -- Tick-Tock Canisters (Soaks)
	}
end

function mod:OnRegister()
	self:SetSpellRename(466340, L.scatterblast_canisters) -- Scatterblast Canisters (Cone Soak)
	self:SetSpellRename(465952, CL.bombs) -- Big Bad Buncha Bombs (Bombs)
	self:SetSpellRename(466341, L.fused_canisters) -- Fused Canisters (Group Soaks)
	self:SetSpellRename(1214607, CL.bombs) -- Bigger Badder Bomb Blast (Bombs)
	self:SetSpellRename(466342, L.tick_tock_canisters) -- Tick-Tock Canisters (Soaks)
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 1215209) -- Sabotage Zone
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 1215209)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 1215209)

	-- Stage One: The House of Chrome
	self:Log("SPELL_CAST_START", "ScatterblastCanisters", 466340)
	self:Log("SPELL_AURA_APPLIED", "MechengineersCanistersApplied", 1220761)
	self:Log("SPELL_CAST_START", "BigBadBunchaBombs", 465952)
	self:Log("SPELL_AURA_APPLIED", "BlastBurnsApplied", 466154)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlastBurnsApplied", 466154)
	self:Log("SPELL_AURA_APPLIED", "FifteenHundredPoundDudApplied", 466165) -- Counts the bombs spawned?
	self:Log("SPELL_AURA_REMOVED", "FifteenHundredPoundDudRemoved", 466165) -- Counts the bombs soaked?
	self:Log("SPELL_AURA_APPLIED", "FocusedDetonationApplied", 466246)
	self:Log("SPELL_AURA_APPLIED_DOSE", "FocusedDetonationApplied", 466246)
	self:Log("SPELL_AURA_REMOVED", "FocusedDetonationRemoved", 466246)
	self:Log("SPELL_CAST_START", "Suppression", 467182)
	self:Log("SPELL_CAST_START", "VentingHeat", 466751)
	self:Log("SPELL_AURA_APPLIED", "TrickShotsApplied", 1220290)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TrickShotsApplied", 1220290)
	self:Log("SPELL_AURA_REMOVED", "TrickShotsRemoved", 1220290)

	-- Stage Two: Mechanical Maniac
	self:Log("SPELL_CAST_START", "GigaCoils", 469286)
	self:Log("SPELL_CAST_START", "GigaBlast", 469327)
	self:Log("SPELL_AURA_APPLIED", "ChargedGigaBombApplied", 469362)
	self:Log("SPELL_AURA_APPLIED", "GigaBOOMApplied", 469404)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GigaBOOMApplied", 469404)
	self:Log("SPELL_AURA_APPLIED", "ControlMeltdownApplied", 1220846)
	-- self:Log("SPELL_AURA_REMOVED", "ControlMeltdownRemoved", 1220846)
	self:Log("SPELL_CAST_START", "FusedCanisters", 466341)

	self:Death("TechnicianDeath", 231977) -- Darkfuse Technician
	self:Log("SPELL_CAST_START", "JuiceIt", 471352)
	self:Log("SPELL_CAST_START", "ShockBarrage", 466834)
	-- self:Log("SPELL_CAST_START", "Wrench", 1216845) -- XXX Nameplate icons?
	self:Log("SPELL_AURA_APPLIED", "WrenchApplied", 1216845)
	self:Log("SPELL_AURA_APPLIED_DOSE", "WrenchApplied", 1216845)
	self:Log("SPELL_AURA_APPLIED", "LumberingRageApplied", 1216852)
	self:Death("AddsDeath", 231978, 231939) -- Sharpshot Sentry, Darkfuse Wrenchmonger XXX confirm

	-- Intermission: Docked and Loaded
	self:Log("SPELL_CAST_START", "Cratering", 1214226)
	self:Log("SPELL_AURA_APPLIED", "ArmageddonClassPlatingApplied", 1214229)
	self:Log("SPELL_AURA_REMOVED", "ArmageddonClassPlatingRemoved", 1214229)
	self:Log("SPELL_INTERRUPT", "TOTALDESTRUCTIONInterrupted", 1214369)

	-- Stage Three: What an Arsenal!
	self:Log("SPELL_CAST_START", "BiggerBadderBombBlast", 1214607)
	self:Log("SPELL_CAST_START", "TickTockCanisters", 466342)
	self:Log("SPELL_CAST_START", "EgoCheck", 466958)
	self:Log("SPELL_AURA_APPLIED", "EgoCheckApplied", 467064)
	self:Log("SPELL_AURA_APPLIED_DOSE", "EgoCheckApplied", 467064) -- Stack or Refresh?
	self:Log("SPELL_AURA_REFRESH", "EgoCheckApplied", 467064)
end

function mod:OnEngage()
	self:SetStage(1)

	canistersCount = 1
	bigBadBunchaBombsCount = 1
	suppressionCount = 1
	ventingHeatCount = 1

	gigaCoilsCount = 1
	controlMeltdownCount = 1

	-- self:Bar(466340, timers[1][466340][1], CL.count:format(L.scatterblast_canisters, canistersCount)) -- Scatterblast Canisters
	-- self:Bar(465952, timers[1][465952][1], CL.count:format(CL.bombs, bigBadBunchaBombsCount)) -- Big Bad Buncha Bombs
	-- self:Bar(467182, timers[1][467182][1], CL.count:format(self:SpellName(467182), suppressionCount)) -- Suppression
	-- self:Bar(466751, timers[1][466751][1], CL.count:format(self:SpellName(466751), ventingHeatCount)) -- Venting Heat

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 53 then -- Intermission at 50%
		self:UnregisterUnitEvent(event, unit)
		self:Message("stages", "cyan", CL.soon:format(CL.intermission), false)
		self:PlaySound("stages", "info")
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end

-- Stage One: The House of Chrome
function mod:ScatterblastCanisters(args)
	self:StopBar(CL.count:format(L.scatterblast_canisters, canistersCount))
	self:Message(args.spellId, "cyan", CL.count:format(L.scatterblast_canisters, canistersCount))
	self:PlaySound(args.spellId, "long") -- catch
	canistersCount = canistersCount + 1
	--self:Bar(args.spellId, timers[1][args.spellId][canistersCount], CL.count:format(L.scatterblast_canisters, canistersCount))
end

function mod:MechengineersCanistersApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "info") -- healing absorb
	end
end

function mod:BigBadBunchaBombs(args)
	self:StopBar(CL.count:format(CL.bombs, bigBadBunchaBombsCount))
	self:Message(args.spellId, "red", CL.count:format(CL.bombs, bigBadBunchaBombsCount))
	self:PlaySound(args.spellId, "alert") -- bombs incoming
	bigBadBunchaBombsCount = bigBadBunchaBombsCount + 1
	local stage = self:GetStage()
	--self:Bar(args.spellId, timers[stage][args.spellId][bigBadBunchaBombsCount], CL.count:format(CL.bombs, bigBadBunchaBombsCount))

	spawnedDuds = 0
	-- self:Bar(466153, 13) -- Bad Belated Boom (explode all at once? in series?)
	-- self:Bar(466165, 18) -- 1500-Pound "Dud"
end

do
	local stacksOnMe = 0
	local scheduled = nil
	local playerName = mod:UnitName("player")
	function mod:BlastBurnsStackMessage()
		local emphAt = 3
		self:StackMessage(466154, "blue", playerName, stacksOnMe, emphAt)
		if stacksOnMe >= emphAt then
			self:PlaySound(466154, "alarm") -- larger dot
		else
			self:PlaySound(466154, "info") -- small dot
		end
		scheduled = nil
	end

	function mod:BlastBurnsApplied(args)
		if self:Me(args.destGUID) then
			stacksOnMe = args.amount or 1
			if not scheduled then
				scheduled = self:ScheduleTimer("BlastBurnsStackMessage", 0.1)
			end
		end
	end
end

do
	local prev = 0
	function mod:FifteenHundredPoundDudApplied(args)
		self:StopBar(L.duds_soak:format(spawnedDuds))
		spawnedDuds = spawnedDuds + 1
		if args.time - prev > 2 then
			prev = args.time
			self:Message(args.spellId, "red", CL.spawned:format(L.duds))
			self:Bar(args.spellId, 15, L.duds_soak:format(spawnedDuds))
		else
			local timeLeft = 15 - (args.time - prev)
			self:Bar(args.spellId, {timeLeft, 15}, L.duds_soak:format(spawnedDuds))
		end
	end

	function mod:FifteenHundredPoundDudRemoved(args)
		self:StopBar(L.duds_soak:format(spawnedDuds))
		spawnedDuds = spawnedDuds - 1
		self:Message(args.spellId, "green", L.duds_remaining:format(spawnedDuds))
		local timeLeft = 15 - (args.time - prev)
		if spawnedDuds > 0 and timeLeft > 0 then
			self:Bar(args.spellId, {timeLeft, 15}, L.duds_soak:format(spawnedDuds+1))
		elseif spawnedDuds <= 0 then
			self:Message(args.spellId, "green", L.all_duds_detontated)
			self:PlaySound(args.spellId, "info")
		end
	end
end

function mod:FocusedDetonationApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "purple", args.destName, args.amount, 2)
		self:PlaySound(args.spellId, "info") -- soaked bomb
	end
	self:TargetBar(1217292, 10, args.destName, CL.explosion) -- Time-Release Crackle
end

function mod:FocusedDetonationRemoved(args)
	self:StopBar(CL.explosion, args.destName) -- Time-Release Crackle
end

function mod:Suppression(args)
	self:StopBar(CL.count:format(args.spellName), suppressionCount)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, suppressionCount))
	self:PlaySound(args.spellId, "alarm") -- raid damage and avoid?
	suppressionCount = suppressionCount + 1
	local stage = self:GetStage()
	--self:Bar(args.spellId, timers[stage][args.spellId][suppressionCount], CL.count:format(args.spellName, suppressionCount))
end

function mod:VentingHeat(args)
	self:StopBar(CL.count:format(args.spellName), ventingHeatCount)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, ventingHeatCount))
	self:PlaySound(args.spellId, "alert") -- raid damage
	ventingHeatCount = ventingHeatCount + 1
	local stage = self:GetStage()
	--self:Bar(args.spellId, timers[stage][args.spellId][ventingHeatCount], CL.count:format(args.spellName, ventingHeatCount))
end

do
	local trickShotsAmount = 0
	local emphAt = 7
	function mod:TrickShotsApplied(args)
		self:StopBar(CL.count:format(args.spellName, trickShotsAmount + 1))
		trickShotsAmount = args.amount or 1
		self:StackMessage(args.spellId, "purple", args.destName, trickShotsAmount, emphAt)
		if trickShotsAmount >= emphAt then
			self:PlaySound(args.spellId, "warning") -- big damage on swap or at 10
		end
		self:Bar(args.spellId, 4, CL.count:format(args.spellName, trickShotsAmount + 1))
	end

	function mod:TrickShotsRemoved(args)
		self:StopBar(CL.count:format(args.spellName, trickShotsAmount + 1))
		trickShotsAmount = 0
	end
end

-- Stage Two: Mechanical Maniac
function mod:GigaCoils(args)
	if self:GetStage() == 1 then -- Should find an event before this
		self:SetStage(2)
		self:StopBar(CL.count:format(L.scatterblast_canisters, canistersCount)) -- Scatterblast Canisters
		self:StopBar(CL.count:format(CL.bombs, bigBadBunchaBombsCount)) -- Big Bad Buncha Bombs
		self:StopBar(CL.count:format(self:SpellName(467182), suppressionCount)) -- Suppression
		self:StopBar(CL.count:format(self:SpellName(466751), ventingHeatCount)) -- Venting Heat

		self:Message(args.spellId, "cyan")
		self:PlaySound(args.spellId, "long") -- stage 2?

		gigaCoilsCount = 1
		canistersCount = 1 -- re-used for Fused Canisters
		bigBadBunchaBombsCount = 1
		suppressionCount = 1
		ventingHeatCount = 1

		-- self:Bar(args.spellId, timers[2][args.spellId][1], CL.count:format(args.spellName, gigaCoilsCount)) -- Giga Coils
		-- self:Bar(466341, timers[2][466341][1], CL.count:format(L.fused_canisters, canistersCount)) -- Fused Canisters
		-- self:Bar(465952, timers[2][465952][1], CL.count:format(CL.bombs, bigBadBunchaBombsCount)) -- Big Bad Buncha Bombs
		-- self:Bar(467182, timers[2][467182][1], CL.count:format(self:SpellName(467182), suppressionCount)) -- Suppression
		-- self:Bar(466751, timers[2][466751][1], CL.count:format(self:SpellName(466751), ventingHeatCount)) -- Venting Heat
	else -- repeat cast / stage 3 casts
		self:Message(args.spellId, "yellow", CL.count:format(args.spellName, gigaCoilsCount))
		self:PlaySound(args.spellId, "alert")
		gigaCoilsCount = gigaCoilsCount + 1
		local stage = self:GetStage()
		--self:Bar(args.spellId, timers[stage][args.spellId][gigaCoilsCount], CL.count:format(args.spellName, gigaCoilsCount))
	end
end

function mod:GigaBlast(args)
	self:Message(args.spellId, "orange")
	-- self:PlaySound(args.spellId, "alert") -- Watch beam?
end

function mod:ChargedGigaBombApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:GigaBOOMApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "purple", args.destName, args.amount, 3)
		self:PlaySound(args.spellId, "alarm") -- dot
	end
end


function mod:ControlMeltdownApplied(args)
	self:Message(args.spellId, "green")
	self:PlaySound(args.spellId, "info")
	self:Bar(args.spellId, 15, CL.count:format(args.spellName, controlMeltdownCount))
	controlMeltdownCount = controlMeltdownCount + 1
end

function mod:FusedCanisters(args)
	self:StopBar(CL.count:format(L.fused_canisters, canistersCount))
	self:Message(args.spellId, "orange", CL.count:format(L.fused_canisters, canistersCount))
	self:PlaySound(args.spellId, "alert") -- soak
	canistersCount = canistersCount + 1
	-- self:Bar(args.spellId, timers[2][args.spellId][canistersCount], CL.count:format(L.fused_canisters, canistersCount))
end

function mod:JuiceIt(args)
	local unit = self:GetUnitIdByGUID(args.sourceGUID)
	if unit then
		local inRange = self:UnitWithinRange(unit, 10)
		if inRange then
			self:Message(args.spellId, "orange")
			self:PlaySound(args.spellId, "alarm") -- watch out
		end
	end
	--self:Nameplate(args.spellId, 20, args.sourceGUID)
end

function mod:TechnicianDeath(args)
	self:Message(-31482, "cyan", CL.killed:format(args.destName))
	self:PlaySound(-31482, "info")
	self:ClearNameplate(args.destGUID)
end

function mod:ShockBarrage(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo and ready then
		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alert")
	end
	-- self:Nameplate(466834, 10, args.sourceGUID)
end

-- function mod:Wrench(args)
	-- self:Nameplate(args.spellId, 30)
-- end

function mod:WrenchApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 1 and (not self:Tank() or amount < 6) then -- don't spam tanks if there are a lot of them
			self:StackMessage(args.spellId, "blue", args.destName, amount, 3)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:LumberingRageApplied(args)
	if self:Dispeller("enrage", true) then
		self:Message(args.spellId, "red")
		self:PlaySound(args.spellId, "warning") -- 200% damage increase and movement? DO IT
	end
end

function mod:AddsDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Intermission: Docked and Loaded

function mod:Cratering(args)
	self:UnregisterUnitEvent("UNIT_HEALTH", "boss1")

	self:Message(args.spellId, "red", CL.percent:format(50, args.spellName))
	self:PlaySound(args.spellId, "long")

	-- self:Bar(1214229, 5.0) -- Armageddon-class Plating
end

do
	local appliedTime = 0
	function mod:ArmageddonClassPlatingApplied(args)
		appliedTime = args.time
		self:SetStage(2.5) -- On Catering instead?

		-- does it alternate between stage 1/2?
		-- Stage 1 bars
		self:StopBar(CL.count:format(L.scatterblast_canisters, canistersCount)) -- Scatterblast Canisters
		self:StopBar(CL.count:format(CL.bombs, bigBadBunchaBombsCount)) -- Big Bad Buncha Bombs
		self:StopBar(CL.count:format(self:SpellName(467182), suppressionCount)) -- Suppression
		self:StopBar(CL.count:format(self:SpellName(466751), ventingHeatCount)) -- Venting Heat

		-- stage 2 bars
		self:StopBar(CL.count:format(self:SpellName(469286), gigaCoilsCount)) -- Giga Coils
		self:StopBar(CL.count:format(L.fused_canisters, canistersCount)) -- Fused Canisters
		self:StopBar(CL.count:format(CL.bombs, bigBadBunchaBombsCount)) -- Big Bad Buncha Bombs
		self:StopBar(CL.count:format(self:SpellName(467182), suppressionCount)) -- Suppression
		self:StopBar(CL.count:format(self:SpellName(466751), ventingHeatCount)) -- Venting Heat

		self:Message(args.spellId, "cyan", CL.onboss:format(CL.shield))
		self:PlaySound(args.spellId, "long") -- shield up
	end

	function mod:ArmageddonClassPlatingRemoved(args)
		if args.amount == 0 then
			self:Message(args.spellId, "green", CL.removed_after:format(args.spellName, args.time - appliedTime))
			self:PlaySound(args.spellId, "info")
		end
	end
end

function mod:TOTALDESTRUCTIONInterrupted(args)
	self:Message(args.spellId, "green", CL.interrupted_by:format(args.extraSpellName, self:ColorName(args.sourceName)))

	self:SetStage(3)
	self:Message("stages", "cyan", CL.stage:format(3), false)
	self:PlaySound("stages", "long") -- stage 3

	bigBadBunchaBombsCount = 1 -- re-used for Bigger Badder Bomb Blast
	canistersCount = 1 -- re-used for Tick-Tock Canisters
	gigaCoilsCount = 1
	suppressionCount = 1
	ventingHeatCount = 1

	-- self:Bar(469286, timers[3][469286][1], CL.count:format(self:SpellName(469286), gigaCoilsCount)) -- Giga Coils
	-- self:Bar(466341, timers[3][466340][1], CL.count:format(L.tick_tock_canisters, canistersCount)) -- Fused Canisters
	-- self:Bar(465952, timers[3][465952][1], CL.count:format(CL.bombs, bigBadBunchaBombsCount)) -- Big Bad Buncha Bombs
	-- self:Bar(467182, timers[3][467182][1], CL.count:format(self:SpellName(467182), suppressionCount)) -- Suppression
	-- self:Bar(466751, timers[3][466751][1], CL.count:format(self:SpellName(466751), ventingHeatCount)) -- Venting Heat
end

function mod:BiggerBadderBombBlast(args)
	self:StopBar(CL.count:format(CL.bombs, bigBadBunchaBombsCount))
	self:Message(args.spellId, "red", CL.count:format(CL.bombs, bigBadBunchaBombsCount))
	self:PlaySound(args.spellId, "warning") -- dodge
	bigBadBunchaBombsCount = bigBadBunchaBombsCount + 1
	-- self:Bar(args.spellId, timers[3][args.spellId][bigBadBunchaBombsCount], CL.count:format(CL.bombs, bigBadBunchaBombsCount))

	spawnedDuds = 0
	-- self:Bar(1214755, 9) -- Overloaded Rockets
	-- self:Bar(466153, 13) -- Bad Belated Boom (explode all at once? in series?)
	-- self:Bar(466165, 18) -- 1500-Pound "Dud"
end

function mod:TickTockCanisters(args)
	self:StopBar(CL.count:format(L.tick_tock_canisters, canistersCount))
	self:Message(args.spellId, "orange", CL.count:format(L.tick_tock_canisters, canistersCount))
	self:PlaySound(args.spellId, "alert")
	canistersCount = canistersCount + 1
	-- self:Bar(args.spellId, timers[3][args.spellId][canistersCount], CL.count:format(L.tick_tock_canisters, canistersCount))
end

function mod:EgoCheck(args)
	self:Message(args.spellId, "purple")
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:Tanking(unit) then
		self:PlaySound(args.spellId, "alarm") -- defensive
	end
	-- self:Bar(args.spellId, 18)
end

function mod:EgoCheckApplied(args)
	self:StackMessage(466958, "purple", args.destName, args.amount, 2)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and not self:Tanking(unit) then -- XXX Confirm swap on every cast?
		self:PlaySound(466958, "warning") -- tauntswap?
	end
end
