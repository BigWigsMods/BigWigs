if not BigWigsLoader.isBeta then return end -- Beta check

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

local piercingStrikeCount = 1
local impalingEruptionCount = 1
local callOfTheSwarmCount = 1
local recklessChargeCount = 1
local stingingSwarmCount = 1
local unleashedSwarmCount = 1

local skitteringLeapCount = 1
local venomousRainCount = 1
local webBombCount = 1
local strandsOfRealityCount = 1
local cataclysmicEntropyCount = 1

-- local stingingSwarmTargets = {}
-- local stingingSwarmMarks = {5, 4, 3, 2, 1}

local timersHeroic = {
	{ -- Stage 1
		[438801] = {17.9, 65.0, 0}, -- Call of the Swarm
		[438218] = {15.0, 20.0, 28.0, 18.0, 0}, -- Piercing Strike
		[440504] = {20.9, 37.1, 28.9, 31.0, 0}, -- Impaling Eruption
		[440246] = {43.5, 60.0, 0}, -- Reckless Charge
		[438656] = {7.4, 31.5, 31.5, 29.6, 0}, -- Venomous Rain
		[450045] = {15.4, 31.9, 28.1, 15.7, 16.2, 0}, -- Skittering Leap
		[439838] = {25.2, 36.0, 0}, -- Web Bomb
	},
	{ -- Stage 2
		[440504] = {9.0, 40.0, 40.0, 0}, -- Impaling Eruption
		[438218] = {15.0, 24.4, 15.5, 19.0, 21.0, 0}, -- Piercing Strike
		[438801] = {31.0, 37.0, 0}, -- Call of the Swarm
		[438677] = {41.0, 35.0, 0}, -- Stinging Swarm
		[441782] = {14.2, 34.7, 32.8, 0}, -- Strands of Reality
		[450483] = {27.2, 25.2, 26.0, 24.2, 0}, -- Void Step
		[441626] = {32.2, 37.2, 36.2, 0}, -- Web Vortex
		[450129] = {36.1, 36.4, 36.2, 0}, -- Entropic Desolation
		[438355] = {55.6, 59.4, 0}, -- Cataclysmic Entropy
	},
	{ -- Stage 3
		[443068] = {20.0, 111.0}, -- Spike Eruption
		[442994] = {30.0, 89.0}, -- Unleashed Swarm
		[438218] = {25.0, 20.0, 30.0, 21.0, 20.0, 20.4, 19.6}, -- Piercing Strike
		[440246] = {59.2, 109.8}, -- Reckless Charge
		[438677] = {93.0, 69.0}, -- Stinging Swarm
		[451327] = {}, -- Raging Fury
		[450483] = {37.4, 26.1, 25.0, 25.7, 23.2, 25.1, 9.1, 13.3, 2.9}, -- Void Step
		[450129] = {45.6, 98.7}, -- Entropic Desolation
		[441626] = {42.7, 98.7}, -- Web Vortex
		[441782] = {28.6, 63.4, 58.4}, -- Strands of Reality
		[438355] = {115.3, 76.4}, -- Cataclysmic Entropy
	},
}
local timers = timersHeroic

--------------------------------------------------------------------------------
-- Localization
--

-- local L = mod:GetLocale()
-- if L then

-- end

--------------------------------------------------------------------------------
-- Initialization
--

-- local stingingSwarmMarker = mod:AddMarkerOption(false, "player", 1, 438677, 1, 2, 3, 4, 5) -- Stinging Swarm
function mod:GetOptions()
	return {
		"stages",
		-- Stage One: Clash of Rivals
			-- Anub'arash
			{438218, "TANK"}, -- Piercing Strike
			438801, -- Call of the Swarm
			{440246, "ICON", "SAY"}, -- Reckless Charge
				440178, -- Reckless Impact
				440179, -- Entangled
			440504, -- Impaling Eruption
				{449857, "SAY"}, -- Impaled

			-- Skeinspinner Takazj
			{438200, "TANK"}, -- Poison Bolt
			438656, -- Venomous Rain
			439838, -- Web Bomb
				440001, -- Binding Webs
			450045, -- Skittering Leap

		-- Transition: Void Ascension (Takazj)
		450980, -- Shatter Existence

		-- Stage Two: Grasp of the Void
			-- Anub'arash
			438677, -- Stinging Swarm
				-- 449993, -- Stinging Burst
				456245, -- Stinging Delirium
			-- stingingSwarmMarker,

			-- Skeinspinner Takazj
			{441772, "TANK"}, -- Void Bolt
			441626, -- Web Vortex
			450129, -- Entropic Desolation
			441782, -- Strands of Reality
			450483, -- Void Step
			438355, -- Cataclysmic Entropy

		-- Transition: Raging Fury (Anub'arash)
		451277, -- Spike Storm
		-- 451327, -- Raging Fury
			443598, -- Enraged Ferocity

		-- Stage Three: Unleashed Rage
			-- Anub'arash
			443068, -- Spike Eruption
			442994, -- Unleashed Swarm
	}, {
		[438218] = -29011, -- Stage 1
		[438200] = "", -- boss split
		[450980] = -29726, -- Intermission 1
		[438677] = -29021, -- Stage 2
		[441772] = "", -- boss split
		[451277] = -29728, -- Intermission 2
		[443068] = -29022, -- Stage 3
	}
end

function mod:OnBossEnable()
	-- Anub'arash
	self:Log("SPELL_CAST_START", "PiercingStrike", 438218)
	self:Log("SPELL_CAST_START", "ImpalingEruption", 440504)
	self:Log("SPELL_AURA_APPLIED", "ImpaledApplied", 449857)
	self:Log("SPELL_CAST_START", "CallOfTheSwarm", 438801)
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
	self:Log("SPELL_CAST_START", "SpikeEruption", 443068)
	self:Log("SPELL_CAST_START", "RagingFury", 451327)
	self:Log("SPELL_AURA_APPLIED", "EnragedFerocityApplied", 443598)
	self:Log("SPELL_AURA_REMOVED", "EnragedFerocityRemoved", 443598)
	self:Log("SPELL_CAST_START", "UnleashedSwarm", 442994)

	-- Skeinspinner Takazj
	self:Log("SPELL_AURA_APPLIED_DOSE", "PoisonBoltApplied", 438200)
	self:Log("SPELL_CAST_START", "VenomousRain", 438343)
	self:Log("SPELL_AURA_APPLIED", "VenomousRainApplied", 438656)
	self:Log("SPELL_AURA_REMOVED", "VenomousRainRemoved", 438656)
	self:Log("SPELL_CAST_START", "SkitteringLeap", 450045)
	self:Log("SPELL_CAST_START", "WebBomb", 439838)
	self:Log("SPELL_AURA_APPLIED", "BindingWebsApplied", 440001)
	self:Log("SPELL_AURA_REMOVED", "BindingWebsRemoved", 440001)

	self:Log("SPELL_CAST_START", "VoidStep", 450483)
	self:Log("SPELL_AURA_APPLIED", "ShatterExistenceApplied", 450980)
	self:Log("SPELL_AURA_REMOVED", "ShatterExistenceRemoved", 450980)
	self:Log("SPELL_CAST_START", "StrandsOfReality", 441782)

	self:Log("SPELL_AURA_APPLIED_DOSE", "VoidBoltApplied", 441772)
	self:Log("SPELL_CAST_START", "EntropicDesolation", 450129)
	self:Log("SPELL_CAST_START", "WebVortex", 441626)
	self:Log("SPELL_CAST_START", "CataclysmicEntropy", 438355)
end

function mod:OnEngage()
	timers = timersHeroic
	self:SetStage(1)

	-- Anub'arash
	piercingStrikeCount = 1
	impalingEruptionCount = 1
	callOfTheSwarmCount = 1
	recklessChargeCount = 1
	stingingSwarmCount = 1
	unleashedSwarmCount = 1

	-- stingingSwarmTargets = {}
	-- stingingSwarmMarks = {5, 4, 3, 2, 1}

	self:Bar(438801, timers[1][438801][1], CL.count:format(self:SpellName(438801), callOfTheSwarmCount)) -- Call of the Swarm
	self:Bar(438218, timers[1][438218][1], CL.count:format(self:SpellName(438218), piercingStrikeCount)) -- Piercing Strike
	self:Bar(440504, timers[1][440504][1], CL.count:format(self:SpellName(440504), impalingEruptionCount)) -- Impaling Eruption
	self:Bar(440246, timers[1][440246][1], CL.count:format(self:SpellName(440246), recklessChargeCount)) -- Reckless Charge

	-- Skeinspinner Takazj
	skitteringLeapCount = 1
	venomousRainCount = 1
	webBombCount = 1
	strandsOfRealityCount = 1
	cataclysmicEntropyCount = 1

	self:Bar(438656, timers[1][438656][1], CL.count:format(self:SpellName(438343), venomousRainCount)) -- Venomous Rain
	self:Bar(450045, timers[1][450045][1], CL.count:format(self:SpellName(450045), skitteringLeapCount)) -- Skittering Leap
	self:Bar(439838, timers[1][439838][1], CL.count:format(self:SpellName(439838), webBombCount)) -- Web Bomb
	self:Bar("stages", 127.3, CL.count:format(CL.intermission, 1), 450483) -- Transition: Void Ascension (Void Step)
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
	self:StopBar(CL.count:format(args.spellName, impalingEruptionCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, impalingEruptionCount))
	self:PlaySound(args.spellId, "alert") -- frontal cone
	impalingEruptionCount = impalingEruptionCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][impalingEruptionCount], CL.count:format(args.spellName, impalingEruptionCount))
end

function mod:ImpaledApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:CallOfTheSwarm(args)
	self:StopBar(CL.count:format(args.spellName, callOfTheSwarmCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, callOfTheSwarmCount))
	self:PlaySound(args.spellId, "info") -- adds
	callOfTheSwarmCount = callOfTheSwarmCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][callOfTheSwarmCount], CL.count:format(args.spellName, callOfTheSwarmCount))
end

function mod:Burrow(args)
	self:Message(440246, "yellow", CL.soon:format(self:SpellName(440246))) -- Reckless Charge
end

function mod:RecklessCharge(args)
	self:StopBar(CL.count:format(args.spellName, recklessChargeCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, recklessChargeCount))
	self:PlaySound(args.spellId, "warning")
	recklessChargeCount = recklessChargeCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][recklessChargeCount], CL.count:format(args.spellName, recklessChargeCount))
end

function mod:RecklessImpactApplied(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm") -- failed
	self:Bar(args.spellId, 3)
end

function mod:RecklessImpactRemoved(args)
	self:Message(args.spellId, "green", CL.over:format(args.spellName))
	self:PlaySound(args.spellId, "info")
end

function mod:EntangledApplied(args)
	self:Message(args.spellId, "green")
	self:PlaySound(args.spellId, "long") -- success
	self:Bar(args.spellId, 7)
end

function mod:EntangledRemoved(args)
	self:Message(args.spellId, "green", CL.over:format(args.spellName))
	self:PlaySound(args.spellId, "info")
end

-- Skeinspinner Takazj

function mod:PoisonBoltApplied(args)
	if args.amount % 6 == 0 then -- every 20s?
		self:StackMessage(args.spellId, "purple", args.destName, args.amount, 24)
	end
end

function mod:VenomousRain(args)
	self:StopBar(CL.count:format(args.spellName, venomousRainCount))
	self:Message(438656, "orange", CL.count:format(args.spellName, venomousRainCount))
	venomousRainCount = venomousRainCount + 1
	self:Bar(438656, timers[1][438656][venomousRainCount], CL.count:format(args.spellName, venomousRainCount))
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
	self:StopBar(CL.count:format(args.spellName, skitteringLeapCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, skitteringLeapCount))
	skitteringLeapCount = skitteringLeapCount + 1
	self:Bar(args.spellId, timers[1][args.spellId][skitteringLeapCount], CL.count:format(args.spellName, skitteringLeapCount))
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

do
	local appliedTime = 0
	function mod:ShatterExistenceApplied(args)
		appliedTime = args.time
		self:Message(args.spellId, "cyan")
		self:PlaySound(args.spellId, "info")
	end

	function mod:ShatterExistenceRemoved(args)
		if args.amount == 0 then
			self:Message(args.spellId, "green", CL.removed_after:format(args.spellName, args.time - appliedTime))
			self:PlaySound(args.spellId, "long")

			self:SetStage(2)
			-- Skeinspinner Takazj
			skitteringLeapCount = 1 -- Skittering Leap -> Void Step
			venomousRainCount = 1 -- Venomus Rain -> Entropic Desolation
			webBombCount = 1 -- Web Bomb -> Web Vortex
			strandsOfRealityCount = 1
			cataclysmicEntropyCount = 1

			self:Bar(441782, timers[2][441782][1], CL.count:format(self:SpellName(441782), strandsOfRealityCount)) -- Strands of Reality
			self:Bar(450483, timers[2][450483][1], CL.count:format(self:SpellName(450483), skitteringLeapCount)) -- Void Step
			self:Bar(441626, timers[2][441626][1], CL.count:format(self:SpellName(441626), webBombCount)) -- Web Vortex
			self:Bar(450129, timers[2][450129][1], CL.count:format(self:SpellName(450129), venomousRainCount)) -- Entropic Desolation
			self:Bar(438355, timers[2][438355][1], CL.count:format(self:SpellName(438355), cataclysmicEntropyCount)) -- Cataclysmic Entropy
			self:Bar("stages", 133.0, CL.count:format(CL.intermission, 2), 451327) -- Transition: Raging Fury (Raging Fury)

			-- Anub'arash
			piercingStrikeCount = 1
			impalingEruptionCount = 1
			callOfTheSwarmCount = 1
			stingingSwarmCount = 1

			self:Bar(440504, timers[2][440504][1], CL.count:format(self:SpellName(440504), impalingEruptionCount)) -- Impaling Eruption
			self:Bar(438218, timers[2][438218][1], CL.count:format(self:SpellName(438218), piercingStrikeCount)) -- Piercing Strike
			self:Bar(438801, timers[2][438801][1], CL.count:format(self:SpellName(438801), callOfTheSwarmCount)) -- Call of the Swarm
			self:Bar(438677, timers[2][438677][1], CL.count:format(self:SpellName(438677), stingingSwarmCount)) -- Stinging Swarm
		end
	end
end

-- Stage 2

-- Anub'arash

function mod:StingingSwarm(args)
	self:StopBar(CL.count:format(args.spellName, stingingSwarmCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, stingingSwarmCount))
	self:PlaySound(args.spellId, "alert") -- dispel
	stingingSwarmCount = stingingSwarmCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][stingingSwarmCount], CL.count:format(args.spellName, stingingSwarmCount))
end

do
	function mod:StingingSwarmApplied(args)
		if self:Me(args.destGUID) then
			self:StackMessage(438677, "blue", args.destName, args.amount or 1, 4)
			self:PlaySound(438677, "warning")
		end

		-- local icon = table.remove(stingingSwarmMarks) or false
		-- stingingSwarmTargets[args.destGUID] = icon
		-- if icon then
		-- 	self:CustomIcon(stingingSwarmMarker, args.destName, icon)
		-- end
	end
end

function mod:StingingSwarmRemoved(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(438677, "removed")
		self:PlaySound(438677, "info")
	end

	-- local icon = stingingSwarmTargets[args.destGUID]
	-- if icon then
	-- 	table.insert(stingingSwarmMarks, icon)
	-- 	self:CustomIcon(stingingSwarmMarker, args.destName)
	-- end
	-- stingingSwarmTargets[args.destGUID] = nil
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
		self:StopBar(CL.count:format(CL.intermission, 1))
		self:SetStage(1.5)

		self:Message("stages", "cyan", CL.count:format(CL.intermission, 1), false)
		self:PlaySound("stages", "long")
	else
		self:StopBar(CL.count:format(args.spellName, skitteringLeapCount))
		self:Message(args.spellId, "cyan", CL.count:format(args.spellName, skitteringLeapCount))
		skitteringLeapCount = skitteringLeapCount + 1
		self:Bar(args.spellId, timers[self:GetStage()][args.spellId][skitteringLeapCount], CL.count:format(args.spellName, skitteringLeapCount))
	end
end

function mod:StrandsOfReality(args)
	self:StopBar(CL.count:format(args.spellName, strandsOfRealityCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, strandsOfRealityCount))
	self:PlaySound(args.spellId, "alert") -- frontal cone
	strandsOfRealityCount = strandsOfRealityCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][strandsOfRealityCount], CL.count:format(args.spellName, strandsOfRealityCount))
end

function mod:VoidBoltApplied(args)
	if args.amount % 6 == 0 then -- every 20s?
		self:StackMessage(args.spellId, "purple", args.destName, args.amount, 24)
	end
end

function mod:EntropicDesolation(args)
	self:StopBar(CL.count:format(args.spellName, venomousRainCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, venomousRainCount))
	self:PlaySound(args.spellId, "warning") -- gtfo
	venomousRainCount = venomousRainCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][venomousRainCount], CL.count:format(args.spellName, venomousRainCount))
end

function mod:WebVortex(args)
	self:StopBar(CL.count:format(args.spellName, webBombCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, webBombCount))
	self:PlaySound(args.spellId, "alert") -- pull in
	webBombCount = webBombCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][webBombCount], CL.count:format(args.spellName, webBombCount))
end

function mod:CataclysmicEntropy(args)
	self:StopBar(CL.count:format(args.spellName, cataclysmicEntropyCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, cataclysmicEntropyCount))
	self:PlaySound(args.spellId, "long")
	cataclysmicEntropyCount = cataclysmicEntropyCount + 1
	self:Bar(args.spellId, timers[self:GetStage()][args.spellId][cataclysmicEntropyCount], CL.count:format(args.spellName, cataclysmicEntropyCount))
end

-- Transistion: Raging Fury

function mod:RagingFury(args)
	if self:GetStage() == 2 then -- Transition cast
		self:StopBar(CL.count:format(CL.intermission, 2))
		self:SetStage(2.5)

		self:Message("stages", "cyan", CL.count:format(CL.intermission, 2), false)
		self:PlaySound("stages", "long")

		self:Bar(443598, 18) -- Enraged Ferocity
	end
end

function mod:EnragedFerocityApplied(args)
	self:Message(args.spellId, "red", CL.onboss:format(args.spellName))
	if self:Dispeller("enrage", true) then
		self:PlaySound(args.spellId, "alert") -- dispel
	end
end

function mod:EnragedFerocityRemoved(args)
	self:Message(args.spellId, "green", CL.removed:format(args.spellName))
	self:PlaySound(args.spellId, "info")
end

do
	local appliedTime = 0
	function mod:SpikeStormApplied(args)
		appliedTime = args.time
		self:Message(args.spellId, "cyan")
		self:PlaySound(args.spellId, "info")

		impalingEruptionCount = 1
	end

	function mod:SpikeStormRemoved(args)
		if args.amount == 0 then
			self:Message(args.spellId, "green", CL.removed_after:format(args.spellName, args.time - appliedTime))
			self:PlaySound(args.spellId, "long")

			self:SetStage(3)
			-- Anub'arash
			impalingEruptionCount = 1 -- Impaling Eruption -> Spike Eruption
			callOfTheSwarmCount = 1 -- Call of the Swarm -> Unleashed Swarm
			piercingStrikeCount = 1
			recklessChargeCount = 1
			stingingSwarmCount = 1

			self:Bar(443068, timers[3][443068][1], CL.count:format(self:SpellName(443068), impalingEruptionCount)) -- Spike Eruption
			self:Bar(442994, timers[3][442994][1], CL.count:format(self:SpellName(442994), callOfTheSwarmCount)) -- Unleashed Swarm
			self:Bar(438218, timers[3][438218][1], CL.count:format(self:SpellName(438218), piercingStrikeCount)) -- Piercing Strike
			self:Bar(440246, timers[3][440246][1], CL.count:format(self:SpellName(440246), recklessChargeCount)) -- Reckless Charge
			self:Bar(438677, timers[3][438677][1], CL.count:format(self:SpellName(438677), stingingSwarmCount)) -- Stinging Swarm
			-- self:Bar("berserk", 129.0) -- hard enrage?

			-- Skeinspinner Takazj
			skitteringLeapCount = 1
			venomousRainCount = 1
			webBombCount = 1
			strandsOfRealityCount = 1
			cataclysmicEntropyCount = 1

			self:Bar(450483, timers[3][450483][1], CL.count:format(self:SpellName(450483), skitteringLeapCount)) -- Void Step
			self:Bar(450129, timers[3][450129][1], CL.count:format(self:SpellName(450129), venomousRainCount)) -- Entropic Desolation
			self:Bar(441626, timers[3][441626][1], CL.count:format(self:SpellName(441626), webBombCount)) -- Web Vortex
			self:Bar(441782, timers[3][441782][1], CL.count:format(self:SpellName(441782), strandsOfRealityCount)) -- Strands of Reality
			self:Bar(438355, timers[3][438355][1], CL.count:format(self:SpellName(438355), cataclysmicEntropyCount)) -- Cataclysmic Entropy
		end
	end
end

-- Stage 3

-- Anub'arash
--  Impaling Eruption -> Spike Eruption
--  Call of the Swarm -> Unleashed Swarm

function mod:SpikeEruption(args)
	self:StopBar(CL.count:format(args.spellName, impalingEruptionCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, impalingEruptionCount))
	self:PlaySound(args.spellId, "alarm") -- dodge (dance?)
	impalingEruptionCount = impalingEruptionCount + 1
	self:Bar(args.spellId, timers[3][args.spellId][impalingEruptionCount], CL.count:format(args.spellName, impalingEruptionCount))
end

function mod:UnleashedSwarm(args)
	self:StopBar(CL.count:format(args.spellName, callOfTheSwarmCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, callOfTheSwarmCount))
	self:PlaySound(args.spellId, "alarm")
	callOfTheSwarmCount = callOfTheSwarmCount + 1
	self:Bar(args.spellId, timers[3][args.spellId][callOfTheSwarmCount], CL.count:format(args.spellName, callOfTheSwarmCount))
end
