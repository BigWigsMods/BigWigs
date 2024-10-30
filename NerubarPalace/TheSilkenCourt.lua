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
local burrowedEruptionCount = 1
local recklessChargeCount = 1
local stingingSwarmCount = 1

local skitteringLeapCount = 1
local venomousRainCount = 1
local webBombCount = 1
local strandsOfRealityCount = 1
local cataclysmicEntropyCount = 1
local intermissionSpellCount = 1

local SKIP_CAST_THRESHOLD = 2
local checkTimer = nil

local timersLFR = { -- 9:27
	{ -- Stage 1
		[440504] = {29.4, 52.0, 30.6, 0}, -- Impaling Eruption
		[438218] = {13.4, 26.6, 38.7, 26.6, 52.0, 0}, -- Piercing Strike
		[438801] = {19.1, 0}, -- Call of the Swarm
		[441791] = {42.7, 77.4, 0}, -- Burrowed Eruption
		[440246] = {47.5, 77.4, 0}, -- Reckless Charge
		[438656] = {9.6, 68.6, 70.6, 0}, -- Venomous Rain
		[450045] = {51.9, 76.6, 0}, -- Skittering Leap
		[439838] = {23.1, 78.6, 0}, -- Web Bomb
	},
	{ -- Stage 2
		[440504] = {44.7, 0}, -- Impaling Eruption
		[438218] = {19.4, 33.3, 32.0, 26.7, 0}, -- Piercing Strike
		[438801] = {82.3, 0}, -- Call of the Swarm
		[438677] = {36.7, 81.3, 0}, -- Stinging Swarm
		[441782] = {27.5, 66.2, 0}, -- Strands of Reality
		[450483] = {37.6, 49.4, 30.1, 0}, -- Void Step
		[441626] = {106.4, 0}, -- Web Vortex
		[450129] = {109.2, 0}, -- Entropic Desolation
		[438355] = {41.5, 80.3, 0}, -- Cataclysmic Entropy
	},
	{ -- Stage 3 >.>
		[443068] = {61.4, 82.7}, -- Spike Eruption
		[442994] = {45.4}, -- Unleashed Swarm
		[438218] = {36.0, 29.3, 26.7, 40.0}, -- Piercing Strike
		[441791] = {96.0}, -- Burrowed Eruption
		[440246] = {100.9}, -- Reckless Charge
		[438677] = {}, -- Stinging Swarm
		[441782] = {40.3, 47.6, 46.3}, -- Strands of Reality
		[450483] = {106.0}, -- Void Step
		[441626] = {77.2}, -- Web Vortex
		[450129] = {79.9}, -- Entropic Desolation
		[438355] = {}, -- Cataclysmic Entropy
	},
}

local timersNormal = { -- 14:02 (enrage)
	{ -- Stage 1
		[440504] = {22.0, 38.0, 25.0, 0}, -- Impaling Eruption
		[438218] = {10.1, 19.9, 28.0, 20.0, 39.0, 0}, -- Piercing Strike
		[438801] = {15.0, 54.0, 0}, -- Call of the Swarm
		[441791] = {32.0, 57.9, 0}, -- Burrowed Eruption
		[440246] = {35.8, 58.0, 0}, -- Reckless Charge
		[438656] = {7.7, 37.9, 37.7, 36.1, 0}, -- Venomous Rain
		[450045] = {40.9, 58.3, 0}, -- Skittering Leap
		[439838] = {17.8, 59.2, 0}, -- Web Bomb
	},
	{ -- Stage 2
		[440504] = {18.0, 39.0, 39.0, 0}, -- Impaling Eruption
		[438218] = {16.0, 20.0, 26.0, 20.0, 20.0, 20.0, 0}, -- Piercing Strike
		[438801] = {15.0, 54.0, 0}, -- Call of the Swarm
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
		[441782] = {26.3, 154.0, 48.9, 78.5, 75.1, 0}, -- Strands of Reality
		[450483] = {63.0, 25.2, 24.6, 26.2, 48.8, 77.7, 25.1, 24.6, 26.1, 49.0, 0}, -- Void Step
		[441626] = {41.9, 75.8, 126.6, 75.9, 0}, -- Web Vortex
		[450129] = {44.7, 75.8, 126.6, 75.9, 0}, -- Entropic Desolation
		[438355] = {91.2, 99.6, 102.9, 99.7, 0}, -- Cataclysmic Entropy
	},
}

local timersHeroic = { -- 12:14
	{ -- Stage 1
		[440504] = {19.1, 40.0, 26.0, 33.0, 0}, -- Impaling Eruption
		[438218] = {10.1, 20.0, 27.0, 21.0, 38.0, 0}, -- Piercing Strike
		[438801] = {15.1, 54.0, 0}, -- Call of the Swarm
		[441791] = {32.0, 58.0, 0}, -- Burrowed Eruption
		[440246] = {35.3, 58.0, 0}, -- Reckless Charge
		[450045] = {39.3, 58.7, 0}, -- Skittering Leap
		[439838] = {17.8, 56.4, 0}, -- Web Bomb
		[438656] = {7.7, 38.1, 36.1, 37.8, 0}, -- Venomous Rain
	},
	{ -- Stage 2
		[440504] = {13.0, 40.0, 27.0, 30.0, 0}, -- Impaling Eruption
		[438218] = {18.0, 20.0, 20.0, 20.0, 20.0, 20.0, 0}, -- Piercing Strike
		[438801] = {23.0, 54.0, 0}, -- Call of the Swarm
		[438677] = {29.0, 58.0, 0}, -- Stinging Swarm
		[441782] = {31.6, 35.7, 25.5, 0}, -- Strands of Reality
		[450483] = {38.2, 34.2, 25.1, 29.1, 0}, -- Void Step
		[441626] = {20.3, 55.1, 0}, -- Web Vortex
		[450129] = {23.0, 55.1, 0}, -- Entropic Desolation
		[438355] = {41.2, 59.3, 0}, -- Cataclysmic Entropy
	},
	{ -- Stage 3
		[443068] = {40.1, 30.9, 64.0, 85.0, 31.0, 64.0}, -- Spike Eruption
		[438218] = {20.1, 48.0, 20.0, 23.0, 19.9, 35.0, 34.0, 48.0, 20.0, 23.0, 20.0, 35.0}, -- Piercing Strike
		[442994] = {23.1, 75.0, 70.0, 35.0, 75.0, 70.0}, -- Unleashed Swarm
		[441791] = {43.1, 97.9, 82.1, 98.0}, -- Burrowed Eruption
		[440246] = {46.0, 97.9, 82.0, 98.2}, -- Reckless Charge
		[438677] = {81.0, 57.1, 123.0, 57.0}, -- Stinging Swarm
		[441782] = {22.3, 33.2, 21.2, 47.3, 78.7, 32.7, 21.2, 47.2}, -- Strands of Reality
		[450483] = {50.9, 38.9, 29.2, 29.5, 2.6, 79.7, 38.9, 29.1, 29.5, 2.8}, -- Void Step
		[441626] = {33.4, 97.6, 82.3, 97.6}, -- Web Vortex
		[450129] = {36.1, 97.7, 82.3, 97.6}, -- Entropic Desolation
		[438355] = {92.8, 61.3, 118.6, 61.3}, -- Cataclysmic Entropy
	},
}

local timersMythic = {
	{ -- Stage 1
		[440504] = {8.0, 20.0, 34.0, 20.0, 0}, -- Impaling Eruption
		[438218] = {13.0, 20.0, 27.0, 20.0, 0}, -- Piercing Strike
		[438801] = {25.0, 53.0, 0}, -- Call of the Swarm
		[441791] = {35.0, 60.0, 0}, -- Burrowed Eruption
		[440246] = {38.5, 60.0, 0}, -- Reckless Charge
		[450045] = {42.1, 60.0, 0}, -- Skittering Leap
		[439838] = {16.7, 70.2, 0}, -- Web Bomb
		[438656] = {19.8, 33.3, 26.8, 0}, -- Venomous Rain
	},
	{ -- Stage 2
		[440504] = {11.0, 30.0, 30.0, 30.0, 0}, -- Impaling Eruption
		[438218] = {16.0, 20.0, 25.0, 15.0, 20.0, 25.0, 0}, -- Piercing Strike
		[438801] = {31.0, 61.0, 0}, -- Call of the Swarm
		[438677] = {25.0, 58.0, 0}, -- Stinging Swarm
		[441782] = {32.0, 36.0, 24.0, 0}, -- Strands of Reality
		[450483] = {38.7, 34.2, 23.6, 29.2, 0}, -- Void Step
		[441626] = {20.2, 55.8, 0}, -- Web Vortex
		[450129] = {25.4, 55.8, 0}, -- Entropic Desolation
		[438355] = {41.7, 57.9, 0}, -- Cataclysmic Entropy
	},
	{ -- Stage 3
		[443068] = {40.1, 31.0, 64.0}, -- Spike Eruption
		[438218] = {20.0, 17.0, 32.0, 20.0, 21.0, 20.0, 36.0}, -- Piercing Strike
		[442994] = {23.0, 75.0, 70.0, 37.0}, -- Unleashed Swarm
		[441791] = {43.0, 98.0}, -- Burrowed Eruption
		[440246] = {46.1, 98.0}, -- Reckless Charge
		[438677] = {81.1, 57.0}, -- Stinging Swarm
		[441782] = {22.2, 33.7, 24.9, 43.0, 33.8, 24.9, 43.0}, -- Strands of Reality
		[450483] = {49.3, 40.5, 29.1, 30.1, 2.6, 38.4, 29.2, 30.1, 2.7}, -- Void Step
		[441626] = {33.4, 33.7, 63.8, 33.7, 64.0}, -- Web Vortex
		[450129] = {38.7, 33.7, 63.8, 33.7, 64.0}, -- Entropic Desolation
		[438355] = {92.7, 61.8}, -- Cataclysmic Entropy
	},
}
local timers = mod:Mythic() and timersMythic or mod:Normal() and timersNormal or mod:LFR() and timersLFR or timersHeroic

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.skipped_cast = "Skipped %s (%d)"
	L.intermission_trigger = "Apex of power!" -- Skeinspinner Takazj 100 energy yell

	L.venomous_rain = "Rain"
	L.burrowed_eruption = "Burrow"
	L.stinging_swarm = "Dispel Debuffs"
	L.strands_of_reality = "Frontal [S]" -- S for Skeinspinner Takazj
	L.strands_of_reality_message = "Frontal [Skeinspinner Takazj]"
	L.impaling_eruption = "Frontal [A]" -- A for Anub'arash
	L.impaling_eruption_message = "Frontal [Anub'arash]"
	L.entropic_desolation = "Run Out"
	L.cataclysmic_entropy = "Big Boom" -- Interrupt before it casts
	L.spike_eruption = "Spikes"
	L.unleashed_swarm = "Swarm"
	L.void_degeneration = "Blue Orb"
	L.burning_rage = "Red Orb"
end

--------------------------------------------------------------------------------
-- Initialization
--

local shattershellScarabMarker = mod:AddMarkerOption(true, "npc", 8, -30198, 8, 7, 6) -- Shattershell Scarab
function mod:GetOptions()
	return {
		"stages",
		"berserk",
		-- Stage One: Clash of Rivals
			-- Anub'arash
			{440246, "CASTBAR"}, -- Reckless Charge
				440178, -- Reckless Impact
				440179, -- Entangled
			441791, -- Burrowed Eruption
			438801, -- Call of the Swarm
				shattershellScarabMarker,
				438749, -- Scarab Fixation
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
		[440179] = CL.weakened, -- Entangled (Weakened)
		[438801] = CL.adds, -- Call of the Swarm (Adds)
		[438749] = CL.fixate, -- Scarab Fixation (Fixate)
		[440246] = CL.charge, -- Reckless Charge (Charge)
		[441791] = L.burrowed_eruption, -- Burrowed Eruption (Burrow)
		[440504] = L.impaling_eruption, -- Impaling Eruption (Frontal [A])
		[438656] = L.venomous_rain, -- Venomous Rain (Rain)
		[450045] = CL.leap, -- Skittering Leap (Leap)
		[450980] = CL.shield, -- Shatter Existence (Shield)
		[438677] = L.stinging_swarm, -- Stinging Swarm (Dispell Debuffs)
		[456245] = CL.weakened, -- Stinging Delirium (Weakened)
		[450129] = L.entropic_desolation, -- Entropic Desolation (Run Out)
		[441782] = L.strands_of_reality, -- Strands of Reality (Frontal [S])
		[450483] = CL.teleport, -- Void Step (Teleport)
		[451277] = CL.shield, -- Spike Storm (Shield)
		[438355] = L.cataclysmic_entropy, -- Cataclysmic Entropy (Big Boom)
		[443068] = L.spike_eruption, -- Spike Eruption (Spikes)
		[442994] = L.unleashed_swarm, -- Unleashed Swarm (Swarm)
		[460359] = L.void_degeneration, -- (Blue Orb)
		[460281] = L.burning_rage, -- (Red Orb)
	}
end

function mod:OnRegister()
	self:SetSpellRename(440179, CL.weakened) -- Entangled (Weakened)
	self:SetSpellRename(438801, CL.adds) -- Call of the Swarm (Adds)
	self:SetSpellRename(438749, CL.fixate) -- Scarab Fixation (Fixate)
	self:SetSpellRename(440246, CL.charge) -- Reckless Charge (Charge)
	self:SetSpellRename(441791, L.burrowed_eruption) -- Burrowed Eruption (Burrow)
	self:SetSpellRename(440504, L.impaling_eruption) -- Impaling Eruption (Frontal [A])
	self:SetSpellRename(450045, CL.leap) -- Skittering Leap (Leap)
	self:SetSpellRename(450980, CL.shield) -- Shatter Existence (Shield)
	self:SetSpellRename(438677, L.stinging_swarm) -- Impaling Eruption (Frontal [A])
	self:SetSpellRename(450129, L.entropic_desolation) -- Entropic Desolation (Run Out)
	self:SetSpellRename(441782, L.strands_of_reality) -- Strands of Reality (Frontal [S])
	self:SetSpellRename(450483, CL.teleport) -- Void Step (Teleport)
	self:SetSpellRename(451277, CL.shield) -- Spike Storm (Shield)
	self:SetSpellRename(456245, CL.weakened) -- Stinging Delirium (Weakened)
	self:SetSpellRename(438355, L.cataclysmic_entropy) -- Cataclysmic Entropy (Big Boom)
	self:SetSpellRename(443068, L.spike_eruption) -- Spike Eruption (Spikes)
	self:SetSpellRename(442994, L.unleashed_swarm) -- Unleashed Swarm (Swarm)
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	-- Marking
	self:Log("SPELL_SUMMON", "ShattershellScarabSummon", 438249)

	-- Anub'arash
	self:Log("SPELL_CAST_START", "PiercingStrike", 438218)
	self:Log("SPELL_CAST_START", "ImpalingEruption", 440504)
	self:Log("SPELL_AURA_APPLIED", "ImpaledApplied", 449857)
	self:Log("SPELL_CAST_SUCCESS", "CallOfTheSwarm", 438801)
	self:Log("SPELL_AURA_APPLIED", "ScarabFixationApplied", 438749)
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
	self:Log("SPELL_CAST_SUCCESS", "VenomousRain", 438343)
	self:Log("SPELL_CAST_START", "SkitteringLeap", 450045)
	self:Log("SPELL_CAST_SUCCESS", "WebBomb", 439838)
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
	-- self:Log("SPELL_AURA_REMOVED", "MoteRemoved", 460359, 460281)
	self:Log("SPELL_AURA_APPLIED", "MarkOfDeathApplied", 455863)
end

function mod:OnEngage()
	timers = self:Mythic() and timersMythic or self:Normal() and timersNormal or self:LFR() and timersLFR or timersHeroic
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
	self:CDBar("stages", self:LFR() and 166 or 127, CL.count:format(CL.intermission, 1), 450980) -- Transition: Void Ascension (Void Step) XXX 127~133?
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage 1

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg == L.intermission_trigger then
		-- need to figure out why there's a 6s variance, stop gap but this seems consistent?
		self:CDBar("stages", {4.8,127}, CL.count:format(CL.intermission, 1), 450980)
	end
end

-- Anub'arash
function mod:PiercingStrike(args)
	self:StopBar(CL.count:format(args.spellName, piercingStrikeCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, piercingStrikeCount))
	piercingStrikeCount = piercingStrikeCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][piercingStrikeCount], CL.count:format(args.spellName, piercingStrikeCount))
end

function mod:ImpalingEruption(args)
	self:StopBar(CL.count:format(L.impaling_eruption, impalingEruptionCount))
	self:Message(args.spellId, "orange", CL.count:format(L.impaling_eruption_message, impalingEruptionCount))
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

function mod:ScarabFixationApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.fixate)
		self:PlaySound(args.spellId, "alarm")
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
	self:TargetMessage(args.spellId, "green", args.destName, CL.weakened)
	self:PlaySound(args.spellId, "long") -- success
	self:TargetBar(args.spellId, 12, args.destName, CL.weakened)
end

function mod:EntangledRemoved(args)
	self:StopBar(CL.weakened, args.destName)
	self:Message(args.spellId, "green", CL.over:format(CL.weakened))
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
	self:PlaySound(438656, "alarm")
	venomousRainCount = venomousRainCount + 1
	self:Bar(438656, timers[1][438656][venomousRainCount], CL.count:format(L.venomous_rain, venomousRainCount))
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

do
	local prev = 0
	local count, prevTarget, warnNext = 0, nil, false
	function mod:BindingWebsApplied(args)
		if self:GetStage() == 1 then
			if self:Me(args.destGUID) then
				self:PersonalMessage(args.spellId)
				self:PlaySound(args.spellId, "alarm")
			end
		else
			-- pairs are linked in the same order as the debuffs are applied
			if args.time - prev > 5 then
				prev = args.time
				count = 0
				prevTarget = nil
				warnNext = false
			end
			count = count + 1
			if self:Me(args.destGUID) then
				if count % 2 == 0 then
					self:PersonalMessage(args.spellId, false, CL.link_with:format(self:ColorName(prevTarget)))
					self:PlaySound(args.spellId, "alarm")
				else
					warnNext = true
				end
			elseif warnNext then
				warnNext = false
				self:PersonalMessage(args.spellId, false, CL.link_with:format(self:ColorName(args.destName)))
				self:PlaySound(args.spellId, "alarm")
			end
			prevTarget = args.destName
		end
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

	self:Bar(450980, 3.0) -- Shatter Existence
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
		self:TargetMessage(args.spellId, "cyan", args.destName, CL.shield)
		self:PlaySound(args.spellId, "alert")
	end

	function mod:ShatterExistenceRemoved(args)
		self:StopBar(CL.count:format(self:SpellName(460600), intermissionSpellCount)) -- Entropic Barrage
		if args.amount == 0 then
			self:Message(args.spellId, "green", CL.removed_after:format(CL.shield, args.time - appliedTime))
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
			self:CDBar("stages", self:LFR() and 126 or 131, CL.count:format(CL.intermission, 2), 451277) -- Transition: Raging Fury (Spike Storm)

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
		self:TargetMessage(456245, "green", args.destName, CL.weakened)
		self:PlaySound(456245, "long")
	else
		self:TargetMessage(456245, "red", args.destName)
		self:PlaySound(456245, "alarm") -- fail
	end
end

function mod:StingingDeliriumRemoved(args)
	if self:MobId(args.destGUID) == 217491 then -- Takazj
		self:Message(456245, "green", CL.over:format(CL.weakened))
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
	self:Message(args.spellId, "orange", CL.count:format(L.strands_of_reality_message, strandsOfRealityCount))
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

do
	local prev = 0
	function mod:WebVortex(args)
		if args.time - prev > 4 then -- XXX maybe show a bar for both casts?
			prev = args.time
			self:StopBar(CL.count:format(args.spellName, webBombCount))
			self:Message(args.spellId, "yellow", CL.count:format(args.spellName, webBombCount))
			self:PlaySound(args.spellId, "alert") -- pull in
			webBombCount = webBombCount + 1
			self:Bar(args.spellId, timers[self:GetStage()][args.spellId][webBombCount], CL.count:format(args.spellName, webBombCount))
		end
	end
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
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(L.cataclysmic_entropy, cataclysmicEntropyCount)))
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

	self:Bar(451277, 3.5) -- Spike Storm
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
		self:TargetMessage(args.spellId, "cyan", args.destName, CL.shield)
		self:PlaySound(args.spellId, "alert")
	end

	function mod:SpikeStormRemoved(args)
		self:StopBar(CL.count:format(self:SpellName(460364), intermissionSpellCount)) -- Seismic Upheaval
		if args.amount == 0 then
			self:Message(args.spellId, "green", CL.removed_after:format(CL.shield, args.time - appliedTime))
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
			self:Bar(441791, timers[3][441791][1], CL.count:format(self:SpellName(441791), burrowedEruptionCount)) -- Burrowed Eruption
			self:Bar(440246, timers[3][440246][1], CL.count:format(CL.charge, recklessChargeCount)) -- Reckless Charge
			if not self:LFR() then
				self:Bar(438677, timers[3][438677][1], CL.count:format(L.stinging_swarm, stingingSwarmCount)) -- Stinging Swarm
				self:Berserk(self:Mythic() and 180 or 410, 0) -- Uncontrollable Rage / Apex of Entropy
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
			if not self:LFR() then
				self:Bar(438355, timers[3][438355][1], CL.count:format(L.cataclysmic_entropy, cataclysmicEntropyCount)) -- Cataclysmic Entropy
				checkTimer = self:ScheduleTimer("CataclysmicEntropyCheck", timers[3][438355][1] + SKIP_CAST_THRESHOLD, cataclysmicEntropyCount)
			end
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
	self:Message(args.spellId, "red", CL.casting:format(CL.count:format(L.unleashed_swarm, callOfTheSwarmCount)))
	self:PlaySound(args.spellId, "alarm")
	callOfTheSwarmCount = callOfTheSwarmCount + 1
	self:Bar(args.spellId, timers[3][args.spellId][callOfTheSwarmCount], CL.count:format(L.unleashed_swarm, callOfTheSwarmCount))
end

function mod:UncontrollableRage(args)
	self:StopBar(26662)
	self:Message("berserk", "red", CL.casting:format(self:SpellName(26662)), args.spellId)
	self:PlaySound("berserk", "long")
end

function mod:UncontrollableRageSuccess(args)
	self:Message("berserk", "red", CL.custom_end:format(self.displayName, self:SpellName(26662)), args.spellId)
	self:PlaySound("berserk", "alarm")
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
		local spellName = spellId == 460359 and L.void_degeneration or L.burning_rage
		self:StackMessage(spellId, "blue", player, stacks, 3, spellName) -- SetOption:460359,460281:
		if stacks == 2 then
			self:PlaySound(spellId, "info") -- SetOption:460359,460281:
		elseif stacks == 3 then
			self:PlaySound(spellId, "warning") -- SetOption:460359,460281:
		end
		scheduled = nil
	end

	function mod:MoteStack(args)
		if self:Me(args.destGUID) then
			stacks = args.amount or 1
			if stacks == 4 then
				if scheduled then
					self:CancelTimer(scheduled)
				end
				self:MoteStackMessage(args.spellId, args.destName)
			elseif not scheduled and stacks <= 3 then
				scheduled = self:ScheduleTimer("MoteStackMessage", 0.3, args.spellId, args.destName)
			end
		end
	end

	-- function mod:MoteRemoved(args)
	-- 	if self:Me(args.destGUID) then
	-- 		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
	-- 		self:PlaySound(args.spellId, "info")
	-- 	end
	-- end
end

function mod:MarkOfDeathApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "red", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "alarm") -- fail
	end
end
