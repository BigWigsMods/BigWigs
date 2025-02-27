
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
})
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local canistersCount = 1
local bigBadBunchaBombsCount = 1
local suppressionCount = 1
local ventingHeatCount = 1

local spawnedBombs = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.canisters = "Canisters"
	L.bombs_remaining = "%d |4Bomb:Bombs; remaining" -- 1 Bomb Remaning, 2 Bombs Remaining.. etc
	L.bombs_soak = "Soak Bombs (%d left)"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Stage One: The House of Chrome
		466340, -- Scatterblast Canisters
			1220761, -- Mechengineer's Canisters
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
		-- 469286, -- Giga Coils
		-- 	469327, -- Giga Blast
		-- 	469404, -- Giga BOOM!
		-- 	469297, -- Sabotaged Controls
		-- 		1220846, -- Control Meltdown
		-- 	1215209, -- Sabotage Zone
		-- 	1219313, -- Overloaded Bolts
		-- 466341, -- Fused Canisters
		-- -- Darkfuse Cronies
		-- 	-- Darkfuse Technician
		-- 	469362, -- Charged Giga Bomb
		-- 		469363, -- Fling Giga Bomb
		-- 		469767, -- Giga Bomb Detonation
		-- 	471352, -- Juice It!
		-- 	1223126, -- Party Crashing Rocket
		-- 	-- Sharpshot Sentry
		-- 	466834, -- Shock Barrage
		-- 	-- Darkfuse Wrenchmonger
		-- 	1216845, -- Wrench
		-- 	1216852, -- Lumbering Rage
		-- -- Intermission: Docked and Loaded
		-- 1214226, -- Cratering
		-- 1214229, -- Armageddon-class Plating
		-- 1219319, -- Radiant Electricity
		-- 1214369, -- TOTAL DESTRUCTION!!!
		-- -- Stage Three: What an Arsenal!
		-- 1214607, -- Bigger Badder Bomb Blast
		-- 	1214755, -- Overloaded Rockets
		-- 466342, -- Tick-Tock Canisters
		-- 1219333, -- Gallybux Finale Blast (Stage 3)
		-- -- Greedy Goblin's Armaments
		-- 	466958, -- Ego Check
		-- 		467064, -- Checked Ego
	},{ -- Sections
		[466340] = -30490, -- Stage One: The House of Chrome
		-- [469286] = -30497, -- Stage Two: Mechanical Maniac
		-- [1214226] = -31558, -- Intermission: Docked and Loaded
		-- [1214607] = -31445, -- Stage Three: What an Arsenal!
	},{ -- Renames
		[466340] = L.canisters, -- Scatterblast Canisters
		[465952] = CL.bombs, -- Big Bad Buncha Bombs (Bombs)
		[466165] = CL.bombs, -- 1500-Pound "Dud" (Bombs)
		[1217292] = CL.explosion, -- Time-Release Crackle (Explosion)
	}
end

function mod:OnRegister()
	self:SetSpellRename(466340, L.canisters) -- Big Bad Buncha Bombs (Bombs)
	self:SetSpellRename(465952, CL.bombs) -- Big Bad Buncha Bombs (Bombs)
end

function mod:OnBossEnable()
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
	self:Log("SPELL_CAST_START", "Suppression", 467182)
	self:Log("SPELL_CAST_START", "VentingHeat", 466751)
	self:Log("SPELL_AURA_APPLIED", "TrickShotsApplied", 1220290)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TrickShotsApplied", 1220290)
	self:Log("SPELL_AURA_REMOVED", "TrickShotsRemoved", 1220290)

	-- Stage Two: Mechanical Maniac
end

function mod:OnEngage()
	self:SetStage(1)

	canistersCount = 1
	bigBadBunchaBombsCount = 1
	suppressionCount = 1
	ventingHeatCount = 1

	-- self:Bar(466340, 10, CL.count:format(L.canisters, canistersCount)) -- Scatterblast Canisters
	-- self:Bar(465952, 20, CL.count:format(CL.bombs, bigBadBunchaBombsCount)) -- Big Bad Buncha Bombs
	-- self:Bar(467182, 30, CL.count:format(self:SpellName(467182), suppressionCount)) -- Suppression
	-- self:Bar(466751, 30, CL.count:format(self:SpellName(466751), ventingHeatCount)) -- Venting Heat
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: The House of Chrome
function mod:ScatterblastCanisters(args)
	self:StopBar(CL.count:format(L.canisters, canistersCount))
	self:Message(args.spellId, "cyan", CL.count:format(L.canisters, canistersCount))
	self:PlaySound(args.spellId, "long") -- catch
	canistersCount = canistersCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(L.canisters, canistersCount))
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
	--self:Bar(args.spellId, 30, CL.count:format(CL.bombs, bigBadBunchaBombsCount))

	spawnedBombs = 0
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
		self:StopBar(L.bombs_soak:format(spawnedBombs))
		spawnedBombs = spawnedBombs + 1
		if args.time - prev > 2 then
			prev = args.time
			self:Message(args.spellId, "red", CL.spawned:format(CL.bombs))
			self:Bar(args.spellId, 15, L.bombs_soak:format(spawnedBombs))
		else
			local timeLeft = 15 - (args.time - prev)
			self:Bar(args.spellId, {timeLeft, 15}, L.bombs_soak:format(spawnedBombs))
		end
	end

	function mod:FifteenHundredPoundDudRemoved(args)
		self:StopBar(L.bombs_soak:format(spawnedBombs))
		spawnedBombs = spawnedBombs - 1
		self:Message(args.spellId, "green", L.bombs_remaining:format(spawnedBombs))
		local timeLeft = 15 - (args.time - prev)
		if spawnedBombs > 0 and timeLeft > 0 then
			self:Bar(args.spellId, {timeLeft, 15}, L.bombs_soak:format(spawnedBombs+1))
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

function mod:Suppression(args)
	self:StopBar(CL.count:format(args.spellName), suppressionCount)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, suppressionCount))
	self:PlaySound(args.spellId, "alarm") -- raid damage and avoid?
	suppressionCount = suppressionCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, suppressionCount))
end

function mod:VentingHeat(args)
	self:StopBar(CL.count:format(args.spellName), ventingHeatCount)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, ventingHeatCount))
	self:PlaySound(args.spellId, "alert") -- raid damage
	ventingHeatCount = ventingHeatCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, ventingHeatCount))
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
