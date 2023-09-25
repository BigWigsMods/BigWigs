if not BigWigsLoader.onTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nymue, Weaver of the Cycle", 2549, 2556)
if not mod then return end
mod:RegisterEnableMob(206172) -- Nymue <Weaver of the Cycle>
mod:SetEncounterID(2708)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local continuumCount = 1
local violentFloraCount = 1
local threadsOfLifeCount = 1
local weaversBurdenCount = 1
local viridianRainCount = 1

local inflorescenceOnMe = false

local timers = {
	[424477] = {15.1, 13.4, 14.4, 12.1, 8.5, 13.5, 33.0, 20.0, 20.1, 21.5, 26.6, 9.9, 15.5, 12.0, 8.0, 12.0, 32.1, 10.4, 15.0, 14.0, 4.9}, -- Violent Flora
	[426520] = {27.0, 26.6, 23.5, 65.1, 25.5, 64.4, 25.6, 69.5}, -- Weaver's Burden
	[425745] = {35.0, 13.0, 12.0, 18.7, 39.4, 8.0, 12.0, 19.5, 10.4, 31.0, 11.0, 18.0, 12.0, 18.0, 29.6, 2.1, 10.3, 18.0, 12.0}, -- Threads of Life
	[420907] = {7.0, 33.0, 37.0, 33.0, 15.0, 20.5, 29.5, 23.1, 7.9, 13.6, 8.0, 10.4, 9.6, 10.5, 7.9}, -- Viridian Rain
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.threads_of_life = "Daggers"
	L.viridian_rain = "Raid Damage"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		420846, -- Continuum
		420554, -- Verdant Matrix
		424477, -- Violent Flora
		423195, -- Inflorescence
		{425745, "SAY"}, -- Threads of Life
		{426147, "TANK"}, -- Threaded Blast
		{426520, "SAY", "SAY_COUNTDOWN"}, -- Weaver's Burden
		420907, -- Viridian Rain
	},nil,{
		[420846] = CL.adds, -- Continuum (Adds)
		[424477] = CL.pools, -- Violent Flora (Pools)
		[425745] = L.threads_of_life, -- Threads of Life (Daggers)
		[426520] = CL.bomb, -- Weaver's Burden (Bomb)
		[420907] = L.viridian_rain, -- Viridian Rain (Raid Damage)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1") -- Violent Flora, Weaver's Burden

	self:Log("SPELL_CAST_START", "Continuum", 420846)
	self:Log("SPELL_AURA_APPLIED", "VerdantMatrixApplied", 420554)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VerdantMatrixApplied", 420554)
	--self:Log("SPELL_CAST_START", "ViolentFlora", 424477) -- USCS
	self:Log("SPELL_AURA_APPLIED", "InflorescenceApplied", 423195)
	self:Log("SPELL_AURA_REMOVED", "InflorescenceRemoved", 423195)
	self:Log("SPELL_CAST_SUCCESS", "ThreadsOfLife", 423094)
	self:Log("SPELL_AURA_APPLIED", "ThreadsOfLifeApplied", 425745)
	self:Log("SPELL_CAST_START", "ThreadedBlast", 426147)
	--self:Log("SPELL_CAST_SUCCESS", "WeaversBurden", 426520) -- USCS
	self:Log("SPELL_AURA_APPLIED", "WeaversBurdenApplied", 426520)
	self:Log("SPELL_AURA_REMOVED", "WeaversBurdenRemoved", 426520)
	self:Log("SPELL_CAST_SUCCESS", "ViridianRain", 420907)
end

function mod:OnEngage()
	continuumCount = 1
	violentFloraCount = 1
	threadsOfLifeCount = 1
	weaversBurdenCount = 1
	viridianRainCount = 1

	inflorescenceOnMe = false

	self:Bar(420907, 7, CL.count:format(L.viridian_rain, viridianRainCount)) -- Viridian Rain
	self:Bar(424477, 15, CL.count:format(CL.pools, violentFloraCount)) -- Violent Flora
	self:Bar(426520, 27, CL.count:format(CL.bomb, weaversBurdenCount)) -- Weaver's Burden
	self:Bar(425745, 35, CL.count:format(L.threads_of_life, threadsOfLifeCount)) -- Threads of Life
	self:Bar(420846, 90, CL.count:format(CL.adds, continuumCount)) -- Continuum
end

--------------------------------------------------------------------------------
-- Event Handlers
--


function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 423858 then -- Violent Flora
		self:StopBar(CL.count:format(CL.pools, violentFloraCount))
		self:Message(424477, "yellow", CL.count:format(CL.pools, violentFloraCount))
		self:PlaySound(424477, "long")
		violentFloraCount = violentFloraCount + 1
		self:Bar(424477, timers[424477][violentFloraCount], CL.count:format(CL.pools, violentFloraCount))
	elseif spellId == 426519 then -- Weaver's Burden
		self:StopBar(CL.count:format(CL.bomb, weaversBurdenCount))
		weaversBurdenCount = weaversBurdenCount + 1
		self:Bar(426520, timers[424477][weaversBurdenCount], CL.count:format(CL.bomb, weaversBurdenCount))
	end
end

function mod:Continuum(args)
	self:StopBar(CL.count:format(CL.adds, continuumCount))
	self:Message(args.spellId, "cyan", CL.count:format(CL.adds, continuumCount))
	self:PlaySound(args.spellId, "info")
	continuumCount = continuumCount + 1
	self:Bar(args.spellId, 90, CL.count:format(CL.adds, continuumCount))
end

function mod:VerdantMatrixApplied(args)
	if self:Me(args.destGUID) then
		if inflorescenceOnMe and args.spellId == 420554 then return end -- Don't warn when protected from Verdant Matrix with Inflorescence
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
		self:PlaySound(args.spellId, "underyou")
	end
end

-- function mod:ViolentFlora(args)
-- 	self:StopBar(CL.count:format(CL.pools, violentFloraCount))
-- 	self:Message(args.spellId, "yellow", CL.count:format(CL.pools, violentFloraCount))
-- 	self:PlaySound(args.spellId, "long")
-- 	violentFloraCount = violentFloraCount + 1
-- 	--self:Bar(args.spellId, 20, CL.count:format(CL.pools, violentFloraCount))
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

function mod:ThreadsOfLife(args)
	self:StopBar(CL.count:format(L.threads_of_life, threadsOfLifeCount))
	self:Message(425745, "yellow", CL.count:format(L.threads_of_life, threadsOfLifeCount))
	self:PlaySound(425745, "alert")
	threadsOfLifeCount = threadsOfLifeCount + 1
	self:Bar(425745, timers[425745][threadsOfLifeCount], CL.count:format(L.threads_of_life, threadsOfLifeCount))
end

function mod:ThreadsOfLifeApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
	end
end

function mod:ThreadedBlast(args)
	self:Message(args.spellId, "purple")
	--self:PlaySound(args.spellId, "alert")
end

function mod:WeaversBurdenApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName, CL.bomb)
	self:TargetBar(args.spellId, 12, args.destName, CL.bomb)
	if self:Me(args.destGUID) then
		self:Say(args.spellId, CL.bomb)
		self:SayCountdown(args.spellId, 12)
	end
end

function mod:WeaversBurdenRemoved(args)
	self:StopBar(CL.bomb, args.destName)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:ViridianRain(args)
	self:StopBar(CL.count:format(L.viridian_rain, viridianRainCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.viridian_rain, viridianRainCount))
	self:PlaySound(args.spellId, "alarm")
	viridianRainCount = viridianRainCount + 1
	self:Bar(args.spellId, timers[args.spellId][viridianRainCount], CL.count:format(L.viridian_rain, viridianRainCount))
end
