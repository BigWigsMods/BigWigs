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
local drowsyExpulsionCount = 1
local threadsOfLifeCount = 1
local threadedBlastCount = 1
local weaversBurdenCount = 1
local viridianRainCount = 1

local inflorescenceOnMe = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.placeholder = "placeholder"
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
		413442, -- Drowsy Expulsion
		{425745, "SAY"}, -- Threads of Life
		{426147, "TANK"}, -- Threaded Blast
		{426520, "SAY", "SAY_COUNTDOWN"}, -- Weaver's Burden
		420907, -- Viridian Rain
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Continuum", 420846)
	self:Log("SPELL_AURA_APPLIED", "VerdantMatrixApplied", 420554)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VerdantMatrixApplied", 420554)
	self:Log("SPELL_CAST_START", "ViolentFlora", 424477)
	self:Log("SPELL_AURA_APPLIED", "InflorescenceApplied", 423195)
	self:Log("SPELL_AURA_REMOVED", "InflorescenceRemoved", 423195)
	self:Log("SPELL_AURA_APPLIED", "DrowsyExpulsionApplied", 413442)
	self:Log("SPELL_CAST_SUCCESS", "ThreadsOfLife", 418490)
	self:Log("SPELL_AURA_APPLIED", "ThreadsOfLifeApplied", 425745)
	self:Log("SPELL_CAST_START", "ThreadedBlast", 426147)
	self:Log("SPELL_CAST_SUCCESS", "WeaversBurden", 426520)
	self:Log("SPELL_AURA_APPLIED", "WeaversBurdenApplied", 426520)
	self:Log("SPELL_AURA_REMOVED", "WeaversBurdenRemoved", 426520)
	self:Log("SPELL_CAST_SUCCESS", "ViridianRain", 420907)
end

function mod:OnEngage()
	continuumCount = 1
	violentFloraCount = 1
	drowsyExpulsionCount = 1
	threadsOfLifeCount = 1
	threadedBlastCount = 1
	weaversBurdenCount = 1
	viridianRainCount = 1

	inflorescenceOnMe = false

	-- self:Bar(420846, 30, CL.count:format(self:SpellName(420846), continuumCount)) -- Continuum
	-- self:Bar(424477, 30, CL.count:format(self:SpellName(424477), violentFloraCount)) -- Violent Flora
	-- self:Bar(413442, 30, CL.count:format(self:SpellName(413442), drowsyExpulsionCount)) -- Drowsy Expulsion
	-- self:Bar(425745, 30, CL.count:format(self:SpellName(425745), threadsOfLifeCount)) -- Threads of Life
	-- self:Bar(426147, 30, CL.count:format(self:SpellName(426147), threadedBlastCount)) -- Threaded Blast
	-- self:Bar(426520, 30, CL.count:format(self:SpellName(426520), weaversBurdenCount)) -- Weaver's Burden
	-- self:Bar(420907, 30, CL.count:format(self:SpellName(420907), viridianRainCount)) -- Viridian Rain
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Continuum(args)
	self:StopBar(CL.count:format(args.spellName, continuumCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, continuumCount))
	self:PlaySound(args.spellId, "info")
	continuumCount = continuumCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(args.spellName, continuumCount))
end

function mod:VerdantMatrixApplied(args)
	if self:Me(args.destGUID) then
		if inflorescenceOnMe and args.spellId == 420554 then return end -- Don't warn when protected from Verdant Matrix with Inflorescence
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
		self:PlaySound(args.spellId, "underyou")
	end
end

function mod:ViolentFlora(args)
	self:StopBar(CL.count:format(args.spellName, violentFloraCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, violentFloraCount))
	self:PlaySound(args.spellId, "long")
	violentFloraCount = violentFloraCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(args.spellName, violentFloraCount))
end

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

do
	local prev = 0
	function mod:DrowsyExpulsionApplied(args)
		if args.time - prev > 2 then -- reset
			prev = args.time
			self:StopBar(CL.count:format(args.spellName, drowsyExpulsionCount))
			self:Message(args.spellId, "orange", CL.count:format(args.spellName, drowsyExpulsionCount))
			drowsyExpulsionCount = drowsyExpulsionCount + 1
			--self:Bar(args.spellId, 30, CL.count:format(args.spellName, drowsyExpulsionCount))
		end

		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
		end
	end
end

function mod:ThreadsOfLife(args)
	self:StopBar(CL.count:format(args.spellName, threadsOfLifeCount))
	self:Message(425745, "yellow", CL.count:format(args.spellName, threadsOfLifeCount))
	self:PlaySound(425745, "alert")
	threadsOfLifeCount = threadsOfLifeCount + 1
	--self:Bar(425745, 20, CL.count:format(args.spellName, threadsOfLifeCount))
end

function mod:ThreadsOfLifeApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
	end
end

function mod:ThreadedBlast(args)
	self:StopBar(CL.count:format(args.spellName, threadedBlastCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, threadedBlastCount))
	self:PlaySound(args.spellId, "alert")
	threadedBlastCount = threadedBlastCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(args.spellName, threadedBlastCount))
end

function mod:WeaversBurden(args)
	self:StopBar(CL.count:format(args.spellName, weaversBurdenCount))
	weaversBurdenCount = weaversBurdenCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(args.spellName, weaversBurdenCount))
end

function mod:WeaversBurdenApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	self:TargetBar(args.spellId, 12, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 12)
	end
end

function mod:WeaversBurdenRemoved(args)
	self:StopBar(args.spellId, args.destName)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:ViridianRain(args)
	self:StopBar(CL.count:format(args.spellName, viridianRainCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, viridianRainCount))
	self:PlaySound(args.spellId, "alarm")
	viridianRainCount = viridianRainCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(args.spellName, viridianRainCount))
end
