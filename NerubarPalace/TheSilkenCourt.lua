--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Silken Court", 2657, 2608)
if not mod then return end
mod:RegisterEnableMob(217489, 217491) -- Anub'arash, Skeinspinner Takazj
mod:SetEncounterID(2921)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local scarabCollector = {}
local scarabMarks = {}

local piercingStrikeCount = 1
local impalingEruptionCount = 1
local callOfTheSwarmCount = 1
local recklessChargeCount = 1
local stingingSwarmCount = 1
local burrowedEruptionCount = 1

local skitteringLeapCount = 1
local venomousRainCount = 1
local webBombCount = 1
local strandsOfRealityCount = 1
local cataclysmicEntropyCount = 1
local intermissionSpellCount = 1

local SKIP_CAST_THRESHOLD = 2
local checkTimer = nil

local timersNormal = { -- 14:02 (enrage)
	{ -- Stage 1
		[438801] = {12.0, 54.0, 0}, -- Call of the Swarm
		[438218] = {10.1, 19.9, 28.0, 20.0, 39.0, 0}, -- Piercing Strike
		[440504] = {22.0, 38.0, 25.0, 0}, -- Impaling Eruption
		[441791] = {32.0, 57.9, 0}, -- Burrowed Eruption
		[440246] = {35.8, 58.0, 0}, -- Reckless Charge
		[438656] = {6.2, 37.9, 37.7, 36.1, 0}, -- Venomous Rain
		[450045] = {40.9, 58.3, 0}, -- Skittering Leap
		[439838] = {16.3, 59.2, 0}, -- Web Bomb
	},
	{ -- Stage 2
		[440504] = {18.0, 39.0, 39.0, 0}, -- Impaling Eruption
		[438218] = {16.0, 20.0, 26.0, 20.0, 20.0, 20.0, 0}, -- Piercing Strike
		[438801] = {12.0, 54.0, 0}, -- Call of the Swarm
		[438677] = {33.0, 58.0, 0}, -- Stinging Swarm
		[441782] = {24.3, 65.6, 0}, -- Strands of Reality
		[450483] = {42.7, 29.1, 25.6, 0}, -- Void Step
		[441626] = {31.7, 43.1, 0}, -- Web Vortex
		[450129] = {34.5, 43.2, 0}, -- Entropic Desolation
		[438355] = {45.8, 54.7, 0}, -- Cataclysmic Entropy
	},
	{ -- Stage 3
		[443068] = {45.0, 63.0, 63.0, 76.5, 63.0, 63.0, 0}, -- Spike Eruption
		[442994] = {30.0, 202.5, 0}, -- Unleashed Swarm
		[438218] = {25.0, 23.0, 40.0, 23.0, 56.0, 20.0, 40.5, 23.0, 40.0, 23.0, 56.0, 20.0, 0}, -- Piercing Strike
		[441791] = {55.0, 75.0, 127.5, 75.0, 0}, -- Burrowed Eruption
		[440246] = {59.0, 74.9, 127.5, 75.1, 0}, -- Reckless Charge
		[438677] = {75.0, 100.0, 102.5, 100.0, 0}, -- Stinging Swarm
		[450483] = {63.0, 25.2, 24.6, 26.2, 48.8, 77.7, 25.1, 24.6, 26.1, 49.0, 0}, -- Void Step
		[450129] = {44.7, 75.8, 126.6, 75.9, 0}, -- Entropic Desolation
		[441626] = {41.9, 75.8, 126.6, 75.9, 0}, -- Web Vortex
		[441782] = {26.3, 154.0, 48.9, 78.5, 75.1, 0}, -- Strands of Reality
		[438355] = {91.2, 99.6, 102.9, 99.7, 0}, -- Cataclysmic Entropy
	},
}

local timersHeroic = { -- 12:14
	{ -- Stage 1
		[438801] = {12.1, 54.0, 0}, -- Call of the Swarm
		[438218] = {10.1, 20.0, 27.0, 21.0, 38.0, 0}, -- Piercing Strike
		[440504] = {19.1, 40.0, 26.0, 33.0, 0}, -- Impaling Eruption
		[441791] = {32.0, 58.0, 0}, -- Burrowed Eruption
		[440246] = {35.3, 58.0, 0}, -- Reckless Charge
		[438656] = {6.2, 38.1, 36.1, 37.8, 0}, -- Venomous Rain
		[450045] = {39.3, 58.7, 0}, -- Skittering Leap
		[439838] = {16.3, 56.4, 0}, -- Web Bomb
	},
	{ -- Stage 2
		[440504] = {13.0, 40.0, 27.0, 30.0, 0}, -- Impaling Eruption
		[438218] = {18.0, 20.0, 20.0, 20.0, 20.0, 20.0, 0}, -- Piercing Strike
		[438801] = {20.0, 54.0, 0}, -- Call of the Swarm
		[438677] = {29.0, 58.0, 0}, -- Stinging Swarm
		[441782] = {31.6, 35.7, 25.5, 0}, -- Strands of Reality
		[450483] = {38.2, 34.2, 25.1, 29.1, 0}, -- Void Step
		[441626] = {20.3, 55.1, 0}, -- Web Vortex
		[450129] = {23.0, 55.1, 0}, -- Entropic Desolation
		[438355] = {41.2, 59.3, 0}, -- Cataclysmic Entropy
	},
	{ -- Stage 3
		[443068] = {40.1, 30.9, 64.0, 85.0, 31.0, 64.00}, -- Spike Eruption
		[442994] = {23.1, 75.0, 70.0, 35.0, 75.0, 70.0}, -- Unleashed Swarm
		[438218] = {20.1, 48.0, 20.0, 23.0, 19.9, 35.0, 34.0, 48.0, 20.0, 23.0, 20.0, 35.0}, -- Piercing Strike
		[441791] = {43.1, 97.9, 82.1, 98.0}, -- Burrowed Eruption
		[440246] = {46.0, 97.9, 82.0, 98.2}, -- Reckless Charge
		[438677] = {81.0, 57.1, 123.0, 57.0}, -- Stinging Swarm
		[450483] = {50.9, 38.9, 29.2, 29.5, 2.6, 79.7, 38.9, 29.1, 29.5, 2.8}, -- Void Step
		[450129] = {36.1, 97.7, 82.3, 97.6}, -- Entropic Desolation
		[441626] = {33.4, 97.6, 82.3, 97.6}, -- Web Vortex
		[441782] = {22.3, 33.2, 21.2, 47.3, 78.7, 32.7, 21.2, 47.2}, -- Strands of Reality
		[438355] = {92.8, 61.3, 118.6, 61.3}, -- Cataclysmic Entropy
	},
}

local timersMythic = {
	{ -- Stage 1
		[438801] = {22.9, 50.0, 0}, -- Call of the Swarm
		[438218] = {14.9, 23.0, 25.0, 24.0, 0}, -- Piercing Strike
		[440504] = {7.9, 24.0, 25.0, 23.0, 0}, -- Impaling Eruption
		[441791] = {39.9, 60.0, 0}, -- Burrowed Eruption
		[440246] = {42.8, 60.1, 0}, -- Reckless Charge
		[438656] = {15.1, 41.9, 32.8, 0}, -- Venomous Rain
		[450045] = {19.1, 27.3, 59.6, 0}, -- Skittering Leap
		[439838] = {31.3, 32.8, 28.3, 0}, -- Web Bomb
	},
	{ -- Stage 2
		[440504] = {0}, -- Impaling Eruption
		[438218] = {0}, -- Piercing Strike
		[438801] = {0}, -- Call of the Swarm
		[438677] = {0}, -- Stinging Swarm
		[441782] = {0}, -- Strands of Reality
		[450483] = {0}, -- Void Step
		[441626] = {0}, -- Web Vortex
		[450129] = {0}, -- Entropic Desolation
		[438355] = {0}, -- Cataclysmic Entropy
	},
	{ -- Stage 3
		[443068] = {0}, -- Spike Eruption
		[442994] = {0}, -- Unleashed Swarm
		[438218] = {0}, -- Piercing Strike
		[441791] = {0}, -- Burrowed Eruption
		[440246] = {0}, -- Reckless Charge
		[438677] = {0}, -- Stinging Swarm
		[450483] = {0}, -- Void Step
		[450129] = {0}, -- Entropic Desolation
		[441626] = {0}, -- Web Vortex
		[441782] = {0}, -- Strands of Reality
		[438355] = {0}, -- Cataclysmic Entropy
	},
}
local timers = mod:Mythic() and timersMythic or mod:Easy() and timersNormal or timersHeroic

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.skipped_cast = "Skipped %s (%d)"

	L.venomous_rain = "Rain"
	L.burrowed_eruption = "Burrow"
	L.stinging_swarm = "Dispel Debuffs"
	L.strands_of_reality = "Frontal [S]" -- S for Skeinspinner Takazj
	L.impaling_eruption = "Frontal [A]" -- A for Anub'arash
	L.entropic_desolation = "Run Out"
	L.cataclysmic_entropy = "Big Boom" -- Interrupt before it casts
	L.spike_eruption = "Spikes"
	L.unleashed_swarm = "Swarm"
end

--------------------------------------------------------------------------------
-- Initialization
--

local shattershellScarabMarker = mod:AddMarkerOption(true, "npc", 8, -30198, 8, 7, 6) -- Shattershell Scarab
function mod:GetOptions()
	return {
		"stages",
		-- Stage One: Clash of Rivals
			-- Anub'arash
			{440246, "CASTBAR"}, -- Reckless Charge
				440178, -- Reckless Impact
				440179, -- Entangled
			441791, -- Burrowed Eruption
			438801, -- Call of the Swarm
			shattershellScarabMarker,
			440504, -- Impaling Eruption
				449857, -- Impaled
			{438218, "TANK"}, -- Piercing Strike

			-- Skeinspinner Takazj
			439838, -- Web Bomb
			438656, -- Venomous Rain
				440001, -- Binding Webs
			450045, -- Skittering Leap
			{438200, "TANK"}, -- Poison Bolt

		-- Intermission: Void Ascension (Takazj)
		450980, -- Shatter Existence
		460600, -- Entropic Barrage

		-- Stage Two: Grasp of the Void
			-- Anub'arash
			{438677, "ME_ONLY_EMPHASIZE"}, -- Stinging Swarm
				-- 449993, -- Stinging Burst
				456245, -- Stinging Delirium

			-- Skeinspinner Takazj
			438355, -- Cataclysmic Entropy
			441626, -- Web Vortex
			450129, -- Entropic Desolation
			441782, -- Strands of Reality
			450483, -- Void Step
			{441772, "TANK"}, -- Void Bolt

		-- Intermission: Raging Fury (Anub'arash)
		451277, -- Spike Storm
		460364, -- Seismic Upheaval

		-- Stage Three: Unleashed Rage
			-- Anub'arash
			443068, -- Spike Eruption
			442994, -- Unleashed Swarm
			443598, -- Uncontrollable Rage

		-- Mythic
		455849, -- Mark of Paranoia
		460359, -- Void Degeneration
		455850, -- Mark of Rage
		460281, -- Burning Rage
		455863, -- Mark of Death
	}, {
		[440246] = -29011, -- Stage 1
		[439838] = "", -- boss split
		[450980] = -29726, -- Intermission 1
		[438677] = -29021, -- Stage 2
		[438355] = "", -- boss split
		[451277] = -29728, -- Intermission 2
		[443068] = -29022, -- Stage 3
		[455849] = "mythic",
	}, {
		[438801] = CL.adds, -- Call of the Swarm (Adds)
		[440246] = CL.charge, -- Reckless Charge (Charge)
		[441791] = L.burrowed_eruption, -- Burrowed Eruption (Burrow)
		[440504] = L.impaling_eruption, -- Impaling Eruption (Frontal [A])
		[438656] = L.venomous_rain, -- Venomous Rain (Rain)
		[450045] = CL.leap, -- Skittering Leap (Leap)
		[438677] = L.stinging_swarm, -- Stinging Swarm (Dispell Debuffs)
		[450129] = L.entropic_desolation, -- Entropic Desolation (Run Out)
		[441782] = L.strands_of_reality, -- Strands of Reality (Frontal [S])
		[450483] = CL.teleport, -- Void Step (Teleport)
		[438355] = L.cataclysmic_entropy, -- Cataclysmic Entropy (Big Boom)
		[443068] = L.spike_eruption, -- Spike Eruption (Spikes)
		[442994] = L.unleashed_swarm, -- Unleashed Swarm (Swarm)
	}
end

function mod:OnRegister()
	self:SetSpellRename(438801, CL.adds) -- Call of the Swarm (Adds)
	self:SetSpellRename(440246, CL.charge) -- Reckless Charge (Charge)
	self:SetSpellRename(441791, L.burrowed_eruption) -- Burrowed Eruption (Burrow)
	self:SetSpellRename(440504, L.impaling_eruption) -- Impaling Eruption (Frontal [A])
	self:SetSpellRename(450045, CL.leap) -- Skittering Leap (Leap)
	self:SetSpellRename(438677, L.stinging_swarm) -- Impaling Eruption (Frontal [A])
	self:SetSpellRename(450129, L.entropic_desolation) -- Entropic Desolation (Run Out)
	self:SetSpellRename(441782, L.strands_of_reality) -- Strands of Reality (Frontal [S])
	self:SetSpellRename(450483, CL.teleport) -- Void Step (Teleport)
	self:SetSpellRename(438355, L.cataclysmic_entropy) -- Cataclysmic Entropy (Big Boom)
	self:SetSpellRename(443068, L.spike_eruption) -- Spike Eruption (Spikes)
	self:SetSpellRename(442994, L.unleashed_swarm) -- Unleashed Swarm (Swarm)
end

function mod:OnBossEnable()
	-- Marking
	self:Log("SPELL_SUMMON", "ShattershellScarabSummon", 438249)

	-- Anub'arash
	self:Log("SPELL_CAST_START", "PiercingStrike", 438218)
	self:Log("SPELL_CAST_START", "ImpalingEruption", 440504)
	self:Log("SPELL_AURA_APPLIED", "ImpaledApplied", 449857)
	self:Log("SPELL_CAST_START", "CallOfTheSwarm", 438801)
	self:Log("SPELL_CAST_START", "BurrowedEruption", 441791)
	self:Log("SPELL_CAST_START", "RecklessCharge", 440246)
	self:Log("SPELL_AURA_APPLIED", "RecklessImpactApplied", 440178)
	self:Log("SPELL_AURA_REMOVED", "RecklessImpactRemoved", 440178)
	self:Log("SPELL_AURA_APPLIED", "EntangledApplied", 440179)
	self:Log("SPELL_AURA_REMOVED", "EntangledRemoved", 440179)

	self:Log("SPELL_CAST_START", "StingingSwarm", 438677)
	self:Log("SPELL_AURA_APPLIED", "StingingSwarmApplied", 438708)
	self:Log("SPELL_AURA_APPLIED_DOSE", "StingingSwarmApplied", 438708)
	self:Log("SPELL_AURA_REMOVED", "StingingSwarmRemoved", 438708)
	self:Log("SPELL_AURA_APPLIED", "StingingDeliriumApplied", 456245, 456235) -- boss/player
	self:Log("SPELL_AURA_REMOVED", "StingingDeliriumRemoved", 456245, 456235)

	self:Log("SPELL_AURA_APPLIED", "SpikeStormApplied", 451277)
	self:Log("SPELL_AURA_REMOVED", "SpikeStormRemoved", 451277)
	self:Log("SPELL_AURA_APPLIED", "SeismicUpheavalApplied", 460364)

	self:Log("SPELL_CAST_START", "BurrowTransition", 456174)
	self:Log("SPELL_CAST_START", "SpikeEruption", 443068)
	self:Log("SPELL_CAST_START", "UnleashedSwarm", 442994)

	self:Log("SPELL_CAST_START", "UncontrollableRage", 443598)
	self:Log("SPELL_CAST_SUCCESS", "UncontrollableRageSuccess", 443598)

	-- Skeinspinner Takazj
	self:Log("SPELL_AURA_APPLIED_DOSE", "PoisonBoltApplied", 438200)
	self:Log("SPELL_CAST_START", "VenomousRain", 438343)
	self:Log("SPELL_AURA_APPLIED", "VenomousRainApplied", 438656)
	self:Log("SPELL_AURA_REMOVED", "VenomousRainRemoved", 438656)
	self:Log("SPELL_CAST_START", "SkitteringLeap", 450045)
	self:Log("SPELL_CAST_START", "WebBomb", 439838)
	self:Log("SPELL_AURA_APPLIED", "BindingWebsApplied", 440001)
	self:Log("SPELL_AURA_REMOVED", "BindingWebsRemoved", 440001)

	self:Log("SPELL_AURA_APPLIED", "ShatterExistenceApplied", 450980)
	self:Log("SPELL_AURA_REMOVED", "ShatterExistenceRemoved", 450980)
	self:Log("SPELL_AURA_APPLIED", "EntropicBarrageApplied", 460600)
	self:Log("SPELL_AURA_REFRESH", "EntropicBarrageApplied", 460600)

	self:Log("SPELL_CAST_START", "VoidStep", 450483)
	self:Log("SPELL_CAST_START", "StrandsOfReality", 441782)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VoidBoltApplied", 441772)
	self:Log("SPELL_CAST_START", "EntropicDesolation", 450129)
	self:Log("SPELL_CAST_START", "WebVortex", 441626)
	self:Log("SPELL_CAST_START", "CataclysmicEntropy", 438355)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "MarkOfParanoiaApplied", 455849)
	self:Log("SPELL_AURA_APPLIED", "MarkOfRageApplied", 455850)
	self:Log("SPELL_AURA_APPLIED", "MoteStack", 460359, 460281) -- Void Degeneration, Burning Rage
	self:Log("SPELL_AURA_APPLIED_DOSE", "MoteStack", 460359, 460281)
	self:Log("SPELL_AURA_APPLIED", "MarkOfDeathApplied", 455863)
end

function mod:OnEngage()
	timers = self:Mythic() and timersMythic or self:Easy() and timersNormal or timersHeroic
	self:SetStage(1)

	-- Anub'arash
	callOfTheSwarmCount = 1
	piercingStrikeCount = 1
	impalingEruptionCount = 1
	burrowedEruptionCount = 1
	recklessChargeCount = 1
	stingingSwarmCount = 1

	self:Bar(438801, timers[1][438801][1], CL.count:format(CL.adds, callOfTheSwarmCount)) -- Call of the Swarm
	self:Bar(438218, timers[1][438218][1], CL.count:format(self:SpellName(438218), piercingStrikeCount)) -- Piercing Strike
	self:Bar(440504, timers[1][440504][1], CL.count:format(L.impaling_eruption, impalingEruptionCount)) -- Impaling Eruption
	self:Bar(441791, timers[1][441791][1], CL.count:format(L.burrowed_eruption, burrowedEruptionCount)) -- Burrowed Eruption
	self:Bar(440246, timers[1][440246][1], CL.count:format(CL.charge, recklessChargeCount)) -- Reckless Charge

	-- Skeinspinner Takazj
	venomousRainCount = 1
	skitteringLeapCount = 1
	webBombCount = 1
	strandsOfRealityCount = 1
	cataclysmicEntropyCount = 1
	intermissionSpellCount = 1

	self:Bar(438656, timers[1][438656][1], CL.count:format(L.venomous_rain, venomousRainCount)) -- Venomous Rain
	self:Bar(450045, timers[1][450045][1], CL.count:format(CL.leap, skitteringLeapCount)) -- Skittering Leap
	self:Bar(439838, timers[1][439838][1], CL.count:format(self:SpellName(439838), webBombCount)) -- Web Bomb
	self:CDBar("stages", self:Mythic() and 132.0 or 127.0, CL.count:format(CL.intermission, 1), 450980) -- Transition: Void Ascension (Void Step)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage 1

-- Anub'arash
function mod:PiercingStrike(args)
	self:StopBar(CL.count:format(args.spellName, piercingStrikeCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, piercingStrikeCount))
	piercingStrikeCount = piercingStrikeCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][piercingStrikeCount], CL.count:format(args.spellName, piercingStrikeCount))
end

function mod:ImpalingEruption(args)
	self:StopBar(CL.count:format(L.impaling_eruption, impalingEruptionCount))
	self:Message(args.spellId, "orange", CL.count:format(L.impaling_eruption, impalingEruptionCount))
	self:PlaySound(args.spellId, "alert") -- frontal cone
	impalingEruptionCount = impalingEruptionCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][impalingEruptionCount], CL.count:format(L.impaling_eruption, impalingEruptionCount))
end

function mod:ImpaledApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:CallOfTheSwarm(args)
	self:StopBar(CL.count:format(CL.adds, callOfTheSwarmCount))
	self:Message(args.spellId, "cyan", CL.count:format(CL.adds, callOfTheSwarmCount))
	self:PlaySound(args.spellId, "info") -- adds
	callOfTheSwarmCount = callOfTheSwarmCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][callOfTheSwarmCount], CL.count:format(CL.adds, callOfTheSwarmCount))
	if self:GetOption(shattershellScarabMarker) then
		scarabCollector = {}
		scarabMarks = {}
		self:RegisterTargetEvents("AddMarking")
	end
end

function mod:ShattershellScarabSummon(args)
	if self:GetOption(shattershellScarabMarker) then
		for i = 8, 6, -1 do -- 8, 7, 6
			if not scarabCollector[args.destGUID] and not scarabMarks[i] then
				scarabMarks[i] = args.destGUID
				scarabCollector[args.destGUID] = i
				return
			end
		end
	end
end

function mod:AddMarking(_, unit, guid)
	if scarabCollector[guid] then
		self:CustomIcon(shattershellScarabMarker, unit, scarabCollector[guid]) -- icon order from SPELL_SUMMON
		scarabCollector[guid] = nil
	end
end

function mod:BurrowedEruption(args)
	self:StopBar(CL.count:format(L.burrowed_eruption, burrowedEruptionCount))
	self:Message(args.spellId, "cyan", CL.count:format(L.burrowed_eruption, burrowedEruptionCount))
	--self:PlaySound(args.spellId, "alert")
	burrowedEruptionCount = burrowedEruptionCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][burrowedEruptionCount], CL.count:format(L.burrowed_eruption, burrowedEruptionCount))
end

function mod:RecklessCharge(args)
	local msg = CL.count:format(CL.charge, recklessChargeCount)
	self:StopBar(msg)
	self:Message(args.spellId, "red", msg)
	self:CastBar(args.spellId, 6, msg)
	self:PlaySound(args.spellId, "warning")
	recklessChargeCount = recklessChargeCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][recklessChargeCount], CL.count:format(CL.charge, recklessChargeCount))
end

function mod:RecklessImpactApplied(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm") -- failed
	self:Bar(args.spellId, 3)
end

function mod:RecklessImpactRemoved(args)
	self:StopBar(args.spellName)
	self:Message(args.spellId, "green", CL.over:format(args.spellName))
	self:PlaySound(args.spellId, "info")
end

function mod:EntangledApplied(args)
	self:Message(args.spellId, "green")
	self:PlaySound(args.spellId, "long") -- success
	self:Bar(args.spellId, 12)
end

function mod:EntangledRemoved(args)
	self:StopBar(args.spellName)
	self:Message(args.spellId, "green", CL.over:format(args.spellName))
	self:PlaySound(args.spellId, "info")
end

-- Skeinspinner Takazj

function mod:PoisonBoltApplied(args)
	if args.amount % 6 == 0 then -- every 20s?
		self:StackMessage(args.spellId, "purple", args.destName, args.amount, 24)
	end
end

function mod:VenomousRain()
	self:StopBar(CL.count:format(L.venomous_rain, venomousRainCount))
	self:Message(438656, "orange", CL.count:format(L.venomous_rain, venomousRainCount))
	venomousRainCount = venomousRainCount + 1
	self:Bar(438656, timers[1][438656][venomousRainCount], CL.count:format(L.venomous_rain, venomousRainCount))
end

function mod:VenomousRainApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:VenomousRainRemoved(args)
	-- if self:Me(args.destGUID) then
	-- 	self:PersonalMessage(args.spellId, "removed")
	-- 	self:PlaySound(args.spellId, "info")
	-- end
end

function mod:SkitteringLeap(args)
	self:StopBar(CL.count:format(CL.leap, skitteringLeapCount))
	self:Message(args.spellId, "cyan", CL.count:format(CL.leap, skitteringLeapCount))
	skitteringLeapCount = skitteringLeapCount + 1
	self:Bar(args.spellId, timers[1][args.spellId][skitteringLeapCount], CL.count:format(CL.leap, skitteringLeapCount))
end

function mod:WebBomb(args)
	self:StopBar(CL.count:format(args.spellName, webBombCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, webBombCount))
	webBombCount = webBombCount + 1
	self:Bar(args.spellId, timers[1][args.spellId][webBombCount], CL.count:format(args.spellName, webBombCount))
end

function mod:BindingWebsApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:BindingWebsRemoved(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, "removed")
		self:PlaySound(args.spellId, "info")
	end
end

-- Transistion: Void Ascension

function mod:VoidStepTransition()
	self:StopBar(CL.count:format(CL.intermission, 1))

	self:SetStage(1.5)
	self:Message("stages", "cyan", CL.count:format(CL.intermission, 1), false)
	self:PlaySound("stages", "long")

	intermissionSpellCount = 1
end

do
	local prev = 0
	function mod:EntropicBarrageApplied(args)
		if args.time - prev > 3 then
			prev = args.time
			self:StopBar(CL.count:format(args.spellName, intermissionSpellCount))
			intermissionSpellCount = intermissionSpellCount + 1
			self:Bar(args.spellId, self:LFR() and 16 or self:Normal() and 14 or 13, CL.count:format(args.spellName, intermissionSpellCount))
		end
	end
end

do
	local appliedTime = 0
	function mod:ShatterExistenceApplied(args)
		appliedTime = args.time
		self:Message(args.spellId, "cyan")
		self:PlaySound(args.spellId, "alert")
	end

	function mod:ShatterExistenceRemoved(args)
		self:StopBar(CL.count:format(self:SpellName(460600), intermissionSpellCount)) -- Entropic Barrage
		if args.amount == 0 then
			self:Message(args.spellId, "green", CL.removed_after:format(args.spellName, args.time - appliedTime))
			self:PlaySound(args.spellId, "long")

			self:SetStage(2)
			-- Skeinspinner Takazj
			strandsOfRealityCount = 1
			skitteringLeapCount = 1 -- Skittering Leap -> Void Step
			webBombCount = 1 -- Web Bomb -> Web Vortex
			venomousRainCount = 1 -- Venomus Rain -> Entropic Desolation
			cataclysmicEntropyCount = 1

			self:Bar(441782, timers[2][441782][1], CL.count:format(L.strands_of_reality, strandsOfRealityCount)) -- Strands of Reality
			self:Bar(450483, timers[2][450483][1], CL.count:format(CL.teleport, skitteringLeapCount)) -- Void Step
			self:Bar(441626, timers[2][441626][1], CL.count:format(self:SpellName(441626), webBombCount)) -- Web Vortex
			self:Bar(450129, timers[2][450129][1], CL.count:format(L.entropic_desolation, venomousRainCount)) -- Entropic Desolation
			self:Bar(438355, timers[2][438355][1], CL.count:format(L.cataclysmic_entropy, cataclysmicEntropyCount)) -- Cataclysmic Entropy
			checkTimer = self:ScheduleTimer("CataclysmicEntropyCheck", timers[2][438355][1] + SKIP_CAST_THRESHOLD, cataclysmicEntropyCount)
			self:CDBar("stages", 131.2, CL.count:format(CL.intermission, 2), 451277) -- Transition: Raging Fury (Spike Storm)

			-- Anub'arash
			impalingEruptionCount = 1
			piercingStrikeCount = 1
			callOfTheSwarmCount = 1
			stingingSwarmCount = 1

			self:Bar(440504, timers[2][440504][1], CL.count:format(L.impaling_eruption, impalingEruptionCount)) -- Impaling Eruption
			self:Bar(438218, timers[2][438218][1], CL.count:format(self:SpellName(438218), piercingStrikeCount)) -- Piercing Strike
			self:Bar(438801, timers[2][438801][1], CL.count:format(CL.adds, callOfTheSwarmCount)) -- Call of the Swarm
			self:Bar(438677, timers[2][438677][1], CL.count:format(L.stinging_swarm, stingingSwarmCount)) -- Stinging Swarm
		end
	end
end

-- Stage 2

-- Anub'arash
function mod:StingingSwarm(args)
	self:StopBar(CL.count:format(L.stinging_swarm, stingingSwarmCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.stinging_swarm, stingingSwarmCount))
	self:PlaySound(args.spellId, "alert") -- dispel
	stingingSwarmCount = stingingSwarmCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][stingingSwarmCount], CL.count:format(L.stinging_swarm, stingingSwarmCount))
end

function mod:StingingSwarmApplied(args)
	if self:Me(args.destGUID) then
		if not args.amount then
			self:PersonalMessage(438677)
		else
			self:StackMessage(438677, "blue", args.destName, args.amount, args.amount)
		end
		self:PlaySound(438677, "warning")
	end
end

function mod:StingingSwarmRemoved(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(438677, "removed")
		self:PlaySound(438677, "info")
	end
end

function mod:StingingDeliriumApplied(args)
	if self:MobId(args.destGUID) == 217491 then -- Takazj
		self:TargetMessage(456245, "green", args.destName)
		self:PlaySound(456245, "long")
	else
		self:TargetMessage(456245, "red", args.destName)
		self:PlaySound(456245, "alarm") -- fail
	end
end

function mod:StingingDeliriumRemoved(args)
	if self:MobId(args.destGUID) == 217491 then -- Takazj
		self:Message(456245, "green", CL.over:format(args.spellName))
		self:PlaySound(456245, "info")
	elseif self:Me(args.destGUID) then
		self:PersonalMessage(456245, "removed")
		self:PlaySound(456245, "info")
	end
end

-- Skeinspinner Takazj
--   Poison Bolt -> Void Bolt
--   Web Bomb -> Web Vortex
--   Venomus Rain -> Entropic Desolation
--   Skittering Leap -> Void Step

function mod:VoidStep(args)
	if self:GetStage() == 1 then -- Transition cast
		self:VoidStepTransition()
	else
		self:StopBar(CL.count:format(CL.teleport, skitteringLeapCount))
		self:Message(args.spellId, "cyan", CL.count:format(CL.teleport, skitteringLeapCount))
		skitteringLeapCount = skitteringLeapCount + 1
		self:Bar(args.spellId, timers[self:GetStage()][args.spellId][skitteringLeapCount], CL.count:format(CL.teleport, skitteringLeapCount))
	end
end

function mod:StrandsOfReality(args)
	self:StopBar(CL.count:format(L.strands_of_reality, strandsOfRealityCount))
	self:Message(args.spellId, "orange", CL.count:format(L.strands_of_reality, strandsOfRealityCount))
	self:PlaySound(args.spellId, "alert") -- frontal cone
	strandsOfRealityCount = strandsOfRealityCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][strandsOfRealityCount], CL.count:format(L.strands_of_reality, strandsOfRealityCount))
end

function mod:VoidBoltApplied(args)
	if args.amount % 6 == 0 then -- every 20s?
		self:StackMessage(args.spellId, "purple", args.destName, args.amount, 24)
	end
end

function mod:EntropicDesolation(args)
	self:StopBar(CL.count:format(L.entropic_desolation, venomousRainCount))
	self:Message(args.spellId, "orange", CL.count:format(L.entropic_desolation, venomousRainCount))
	self:PlaySound(args.spellId, "warning") -- gtfo
	venomousRainCount = venomousRainCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][venomousRainCount], CL.count:format(L.entropic_desolation, venomousRainCount))
end

function mod:WebVortex(args)
	self:StopBar(CL.count:format(args.spellName, webBombCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, webBombCount))
	self:PlaySound(args.spellId, "alert") -- pull in
	webBombCount = webBombCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][webBombCount], CL.count:format(args.spellName, webBombCount))
end

function mod:CataclysmicEntropyCheck(castCount) -- stunned for cast
	if castCount == cataclysmicEntropyCount then -- not on the next cast?
		self:StopBar(CL.count:format(L.cataclysmic_entropy, cataclysmicEntropyCount))
		self:Message(438355, "green", L.skipped_cast:format(L.cataclysmic_entropy, castCount))
		cataclysmicEntropyCount = castCount + 1
		local cd = timers[self:GetStage()][438355][cataclysmicEntropyCount]
		if cd and cd > 0 then
			self:Bar(438355, cd - SKIP_CAST_THRESHOLD, CL.count:format(L.cataclysmic_entropy, cataclysmicEntropyCount))
			checkTimer = self:ScheduleTimer("CataclysmicEntropyCheck", cd, cataclysmicEntropyCount)
		end
	end
end

function mod:CataclysmicEntropy(args)
	self:StopBar(CL.count:format(L.cataclysmic_entropy, cataclysmicEntropyCount))
	self:Message(args.spellId, "red", CL.count:format(L.cataclysmic_entropy, cataclysmicEntropyCount))
	self:PlaySound(args.spellId, "long")
	cataclysmicEntropyCount = cataclysmicEntropyCount + 1
	local cd = timers[self:GetStage()][args.spellId][cataclysmicEntropyCount]
	if cd and cd > 0 then
		self:Bar(args.spellId, cd, CL.count:format(L.cataclysmic_entropy, cataclysmicEntropyCount))
		checkTimer = self:ScheduleTimer("CataclysmicEntropyCheck", cd + SKIP_CAST_THRESHOLD, cataclysmicEntropyCount)
	end
end

-- Transistion: Raging Fury

function mod:BurrowTransition()
	self:StopBar(CL.count:format(CL.intermission, 2))
	self:CancelTimer(checkTimer)

	self:SetStage(2.5)
	self:Message("stages", "cyan", CL.count:format(CL.intermission, 2), false)
	self:PlaySound("stages", "long")

	intermissionSpellCount = 1
end

do
	local prev = 0
	function mod:SeismicUpheavalApplied(args)
		if args.time - prev > 3 then
			prev = args.time
			self:StopBar(CL.count:format(args.spellName, intermissionSpellCount))
			intermissionSpellCount = intermissionSpellCount + 1
			self:Bar(args.spellId, self:LFR() and 27 or self:Normal() and 24 or 20, CL.count:format(args.spellName, intermissionSpellCount))
		end
	end
end

do
	local appliedTime = 0
	function mod:SpikeStormApplied(args)
		appliedTime = args.time
		self:Message(args.spellId, "cyan")
		self:PlaySound(args.spellId, "alert")
	end

	function mod:SpikeStormRemoved(args)
		self:StopBar(CL.count:format(self:SpellName(460364), intermissionSpellCount)) -- Seismic Upheaval
		if args.amount == 0 then
			self:Message(args.spellId, "green", CL.removed_after:format(args.spellName, args.time - appliedTime))
			self:PlaySound(args.spellId, "long")

			self:SetStage(3)
			-- Anub'arash
			impalingEruptionCount = 1 -- Impaling Eruption -> Spike Eruption
			callOfTheSwarmCount = 1 -- Call of the Swarm -> Unleashed Swarm
			piercingStrikeCount = 1
			burrowedEruptionCount = 1
			recklessChargeCount = 1
			stingingSwarmCount = 1

			self:Bar(443068, timers[3][443068][1], CL.count:format(L.spike_eruption, impalingEruptionCount)) -- Spike Eruption
			self:Bar(442994, timers[3][442994][1], CL.count:format(L.unleashed_swarm, callOfTheSwarmCount)) -- Unleashed Swarm
			self:Bar(438218, timers[3][438218][1], CL.count:format(self:SpellName(438218), piercingStrikeCount)) -- Piercing Strike
			self:Bar(441791, timers[3][441791][1], CL.count:format(self:SpellName(460360), burrowedEruptionCount)) -- Burrowed Eruption
			self:Bar(440246, timers[3][440246][1], CL.count:format(CL.charge, recklessChargeCount)) -- Reckless Charge
			self:Bar(438677, timers[3][438677][1], CL.count:format(L.stinging_swarm, stingingSwarmCount)) -- Stinging Swarm
			if not self:LFR() then
				self:Bar(443598, self:Mythic() and 180 or 410) -- Uncontrollable Rage
			end

			-- Skeinspinner Takazj
			skitteringLeapCount = 1 -- Skittering Leap -> Void Step
			venomousRainCount = 1 -- Venomus Rain -> Entropic Desolation
			webBombCount = 1 -- Web Bomb -> Web Vortex
			strandsOfRealityCount = 1
			cataclysmicEntropyCount = 1

			self:Bar(450483, timers[3][450483][1], CL.count:format(CL.teleport, skitteringLeapCount)) -- Void Step
			self:Bar(450129, timers[3][450129][1], CL.count:format(L.entropic_desolation, venomousRainCount)) -- Entropic Desolation
			self:Bar(441626, timers[3][441626][1], CL.count:format(self:SpellName(441626), webBombCount)) -- Web Vortex
			self:Bar(441782, timers[3][441782][1], CL.count:format(L.strands_of_reality, strandsOfRealityCount)) -- Strands of Reality
			self:Bar(438355, timers[3][438355][1], CL.count:format(L.cataclysmic_entropy, cataclysmicEntropyCount)) -- Cataclysmic Entropy
			checkTimer = self:ScheduleTimer("CataclysmicEntropyCheck", timers[3][438355][1] + SKIP_CAST_THRESHOLD, cataclysmicEntropyCount)
		end
	end
end

-- Stage 3

-- Anub'arash
--  Impaling Eruption -> Spike Eruption
--  Call of the Swarm -> Unleashed Swarm

function mod:SpikeEruption(args)
	self:StopBar(CL.count:format(L.spike_eruption, impalingEruptionCount))
	self:Message(args.spellId, "orange", CL.count:format(L.spike_eruption, impalingEruptionCount))
	self:PlaySound(args.spellId, "alarm") -- dodge (dance?)
	impalingEruptionCount = impalingEruptionCount + 1
	self:Bar(args.spellId, timers[3][args.spellId][impalingEruptionCount], CL.count:format(L.spike_eruption, impalingEruptionCount))
end

function mod:UnleashedSwarm(args)
	self:StopBar(CL.count:format(L.unleashed_swarm, callOfTheSwarmCount))
	self:Message(args.spellId, "red", CL.count:format(L.unleashed_swarm, callOfTheSwarmCount))
	self:PlaySound(args.spellId, "alarm")
	callOfTheSwarmCount = callOfTheSwarmCount + 1
	self:Bar(args.spellId, timers[3][args.spellId][callOfTheSwarmCount], CL.count:format(L.unleashed_swarm, callOfTheSwarmCount))
end

function mod:UncontrollableRage(args)
	self:StopBar(args.spellName)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "long")
end

function mod:UncontrollableRageSuccess(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

-- Mythic

function mod:MarkOfParanoiaApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, _G.LIGHTBLUE_FONT_COLOR:WrapTextInColorCode(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:MarkOfRageApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, _G.DULL_RED_FONT_COLOR:WrapTextInColorCode(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

do
	local stacks = 0
	local scheduled = nil
	function mod:MoteStackMessage(spellId, player)
		self:StackMessage(spellId, "blue", player, stacks, 2) -- SetOption:460359,460281:
		if stacks < 3 then
			self:PlaySound(spellId, "info") -- SetOption:460359,460281:
		end
		scheduled = nil
	end

	function mod:MoteStack(args)
		if self:Me(args.destGUID) then
			stacks = args.amount or 1
			if stacks == 3 then
				if scheduled then
					self:CancelTimer(scheduled)
				end
				self:MoteStackMessage(args.spellId, args.destName)
			elseif not scheduled and stacks <= 3 then
				scheduled = self:ScheduleTimer("MoteStackMessage", 0.3, args.spellId, args.destName)
			end
		end
	end
end

function mod:MarkOfDeathApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "red", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "alarm") -- fail
	end
end
