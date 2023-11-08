--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nymue, Weaver of the Cycle", 2549, 2556)
if not mod then return end
mod:RegisterEnableMob(206172) -- Nymue
mod:SetEncounterID(2708)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local viridianRainCount = 1
local continuumCount = 1
local weaversBurdenCount = 1
local impedingLoomCount = 1
local surgingGrowthCount = 1
local fullBloomCount = 1
local inflorescenceOnMe = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.continuum = "New Lines"
	L.impending_loom = "Dodges"
	L.viridian_rain = "Raid Damage"
	L.lumbering_slam = "Frontal Cone"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		420554, -- Verdant Matrix
		423195, -- Inflorescence
		-- Stage One: Rapid Iteration
		420846, -- Continuum
		429615, -- Impending Loom
		--420971, -- Surging Growth
		420907, -- Viridian Rain
		{426519, "SAY", "SAY_COUNTDOWN"}, -- Weaver's Burden
		-- Stage Two: Creation Complete
		426855, -- Full Bloom (Stage 2)
		429108, -- Lumbering Slam
		425370, -- Radial Flourish
	},{
		["stages"] = "general",
		[420846] = -28355, -- Stage One: Rapid Iteration
		[426855] = -28356, -- Stage Two: Creation Complete
	},{
		[420846] = L.continuum, -- Continuum (New Lines)
		[429615] = L.impending_loom, -- Impeding Loom (Dodges)
		[420907] = L.viridian_rain, -- Viridian Rain (Raid Damage)
		[426519] = CL.bombs, -- Weaver's Burden (Tank Seed)
		[426855] = CL.stage:format(2), -- Full Bloom (Stage 2)
		[429108] = L.lumbering_slam, -- Lumbering Slam (Frontal Cone)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	-- Stage One: Rapid Iteration
	self:Log("SPELL_AURA_APPLIED", "VerdantMatrixApplied", 420554)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VerdantMatrixApplied", 420554)
	self:Log("SPELL_CAST_START", "Continuum", 420846)
	self:Log("SPELL_CAST_START", "ImpendingLoom", 429615)
	-- self:Log("SPELL_CAST_SUCCESS", "SurgingGrowth", 420971)
	self:Log("SPELL_CAST_SUCCESS", "ViridianRain", 420907)
	-- self:Log("SPELL_CAST_SUCCESS", "WeaversBurden", 426519) -- USCS
	self:Log("SPELL_AURA_APPLIED", "InflorescenceApplied", 423195)
	self:Log("SPELL_AURA_REMOVED", "InflorescenceRemoved", 423195)

	-- Stage Two: Creation Complete
	self:Log("SPELL_CAST_START", "FullBloom", 426855)
	self:Log("SPELL_CAST_START", "LumberingSlam", 429108)
	self:Log("SPELL_CAST_SUCCESS", "RadialFlourish", 425370)
end

function mod:OnEngage()
	viridianRainCount = 1
	continuumCount = 1
	weaversBurdenCount = 1
	impedingLoomCount = 1
	fullBloomCount = 1
	inflorescenceOnMe = false

	self:Bar(426519, 20.4, CL.count:format(CL.bombs, weaversBurdenCount)) -- Weaver's Burden
	self:Bar(420907, 20, CL.count:format(L.viridian_rain, viridianRainCount)) -- Viridian Rain
	self:Bar(429615, 24.0, CL.count:format(L.impending_loom, impedingLoomCount)) -- Impeding Loom
	self:Bar(426855, 76.1, CL.stage:format(2)) -- Full Bloom
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
		if spellId == 426519 then -- Weaver's Burden
			self:StopBar(CL.count:format(CL.bombs, weaversBurdenCount))
			self:Message(spellId, "yellow", CL.count:format(CL.bombs, weaversBurdenCount))
			self:PlaySound(spellId, "alert")
			weaversBurdenCount = weaversBurdenCount + 1
			if (fullBloomCount == 1 and weaversBurdenCount < 5) or weaversBurdenCount < 4 then
				self:Bar(spellId, 18, CL.count:format(CL.bombs, weaversBurdenCount)) -- Weaver's Burden
			end
		end
	end
end

-- Stage One: Rapid Iteration
function mod:VerdantMatrixApplied(args)
	if self:Me(args.destGUID) then
		if inflorescenceOnMe and args.spellId == 420554 then return end -- Don't warn when protected from Verdant Matrix with Inflorescence
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
		self:PlaySound(args.spellId, "underyou")
	end
end

function mod:Continuum(args)
	self:Message(args.spellId, "cyan", CL.count:format(L.continuum, continuumCount))
	self:PlaySound(args.spellId, "info")
	continuumCount = continuumCount + 1

	self:SetStage(1)
	impedingLoomCount = 1
	weaversBurdenCount = 1
	viridianRainCount = 1
	self:Bar(420907, 36.6, CL.count:format(L.viridian_rain, viridianRainCount)) -- Viridian Rain
	self:Bar(426519, 36.6, CL.count:format(CL.bombs, weaversBurdenCount)) -- Weaver's Burden
	self:Bar(429615, 41.5, CL.count:format(L.impending_loom, impedingLoomCount)) -- Impeding Loom
	self:Bar(426855, 87.5, CL.stage:format(2)) -- Full Bloom
end

function mod:ImpendingLoom(args)
	self:StopBar(CL.count:format(L.impending_loom, impedingLoomCount))
	self:Message(args.spellId, "cyan", CL.count:format(L.impending_loom, impedingLoomCount))
	self:PlaySound(args.spellId, "info")
	impedingLoomCount = impedingLoomCount + 1
	if (fullBloomCount == 1 and impedingLoomCount < 4) or impedingLoomCount < 3 then
		self:Bar(args.spellId, 24, CL.count:format(L.impending_loom, impedingLoomCount))
	end
end

-- function mod:SurgingGrowth(args)
-- 	self:StopBar(CL.count:format(L.surging_growth, surgingGrowthCount))
-- 	self:Message(args.spellId, "cyan", CL.count:format(L.surging_growth, surgingGrowthCount))
-- 	self:PlaySound(args.spellId, "info")
-- 	surgingGrowthCount = surgingGrowthCount + 1
-- 	--self:Bar(args.spellId, 90, CL.count:format(L.surging_growth, surgingGrowthCount))
-- end

function mod:ViridianRain(args)
	self:StopBar(CL.count:format(L.viridian_rain, viridianRainCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.viridian_rain, viridianRainCount))
	self:PlaySound(args.spellId, "alarm")
	viridianRainCount = viridianRainCount + 1
	if viridianRainCount < 4 then
		self:Bar(args.spellId, 20, CL.count:format(L.viridian_rain, viridianRainCount))
	end
end

-- function mod:WeaversBurden(args)
-- 	self:StopBar(CL.count:format(CL.bombs, weaversBurdenCount))
-- 	self:Message(args.spellId, "purple", CL.count:format(CL.bombs, weaversBurdenCount))
-- 	--self:PlaySound(args.spellId, "alert")
-- 	weaversBurdenCount = weaversBurdenCount + 1
-- 	--self:Bar(args.spellId, 20, CL.count:format(CL.bombs, weaversBurdenCount))
-- end

function mod:InflorescenceApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info")
		inflorescenceOnMe = true
	end
end

function mod:InflorescenceRemoved(args)
	if self:Me(args.destGUID) then
		inflorescenceOnMe = false
	end
end

-- Stage Two: Creation Complete
function mod:FullBloom(args)
	self:StopBar(CL.count:format(CL.bombs, weaversBurdenCount)) -- Weaver's Burden
	self:StopBar(CL.count:format(L.viridian_rain, viridianRainCount)) -- Viridian Rain
	self:StopBar(CL.count:format(L.impending_loom, impedingLoomCount)) -- Impeding Loom
	self:StopBar(CL.stage:format(2)) -- Full Bloom

	self:StopBar(CL.stage:format(2))
	self:Message(args.spellId, "green", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "long")
	fullBloomCount = fullBloomCount + 1
	self:SetStage(2)
end

function mod:LumberingSlam(args)
	-- Add a Range check
	self:Message(args.spellId, "orange", L.lumbering_slam)
	self:PlaySound(args.spellId, "alarm")
end

function mod:RadialFlourish(args) -- make it into a 'I got hit' warning?
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "alert")
end
