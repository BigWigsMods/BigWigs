if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lihuvim, Principal Architect", 2481, 2461)
if not mod then return end
mod:RegisterEnableMob(182169) -- Lihuvim
mod:SetEncounterID(2539)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local protoformCascadeCount = 1
local cosmicShiftCount = 1
local unstableMoteCount = 1
local deconstructingEnergyCount = 1
local syntesizeCount = 1
local nextSynthesize = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.protoform_cascade = "Frontal"
	L.cosmic_shift = "Pushback"
	L.unstable_mote = "Motes"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		364652, -- Protoform Cascade
		363088, -- Cosmic Shift
		362601, -- Unstable Mote
		{363795, "SAY", "SAY_COUNTDOWN"}, -- Deconstructing Energy
		363130, -- Synthesize
	},{

	},{
		[364652] = L.protoform_cascade, -- Protoform Cascade (Frontal)
		[363088] = L.cosmic_shift, -- Cosmic Shift (Pushback)
		[362601] = L.unstable_mote, -- Unstable Mote (Motes)
		[363795] = CL.bombs, -- Deconstructing Energy (Bombs)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "ProtoformCascade", 364652)
	self:Log("SPELL_CAST_START", "CosmicShift", 363088)
	self:Log("SPELL_CAST_START", "UnstableMote", 362601)
	self:Log("SPELL_CAST_SUCCESS", "DeconstructingEnergy", 363676)
	self:Log("SPELL_AURA_APPLIED", "DeconstructingEnergyApplied", 363795, 363676) -- DPS, TANK?
	self:Log("SPELL_AURA_REMOVED", "DeconstructingEnergyRemoved", 363795, 363676)
	self:Log("SPELL_CAST_START", "Synthesize", 363130)
	self:Log("SPELL_AURA_REMOVED", "SynthesizeRemoved", 363130)
end

function mod:OnEngage()
	protoformCascadeCount = 1
	cosmicShiftCount = 1
	unstableMoteCount = 1
	deconstructingEnergyCount = 1
	syntesizeCount = 1
	nextSynthesize = GetTime() + 101

	self:Bar(364652, 6) -- Protoform Cascade
	self:Bar(362601, 12) -- Unstable Mote
	self:Bar(363795, 20.5) -- Deconstructing Energy
	self:Bar(363088, 25.5) -- Cosmic Shift
	self:Bar(363130, 101) -- Synthesize
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ProtoformCascade(args)
	self:StopBar(CL.count:format(L.protoform_cascade, protoformCascadeCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.protoform_cascade, protoformCascadeCount))
	self:PlaySound(args.spellId, "alert")
	protoformCascadeCount = protoformCascadeCount + 1
	if nextSynthesize > GetTime() + 20.7 then
		self:Bar(args.spellId, protoformCascadeCount == 2 and 12 or 20.7, CL.count:format(L.protoform_cascade, protoformCascadeCount))
	end
end

function mod:CosmicShift(args)
	self:StopBar(CL.count:format(L.cosmic_shift, cosmicShiftCount))
	self:Message(args.spellId, "orange", CL.count:format(L.cosmic_shift, cosmicShiftCount))
	self:PlaySound(args.spellId, "alarm")
	cosmicShiftCount = cosmicShiftCount + 1
	if nextSynthesize > GetTime() + 20.7 then
		self:Bar(args.spellId, 20.7, CL.count:format(L.cosmic_shift, cosmicShiftCount))
	end
end

function mod:UnstableMote(args)
	self:StopBar(CL.count:format(L.unstable_mote, unstableMoteCount))
	self:Message(args.spellId, "orange", CL.count:format(L.unstable_mote, unstableMoteCount))
	self:PlaySound(args.spellId, "alarm")
	unstableMoteCount = unstableMoteCount + 1
	if nextSynthesize > GetTime() + 20.7 then
		self:Bar(args.spellId, 20.7, CL.count:format(L.unstable_mote, unstableMoteCount))
	end
end

do
	local playerList = {}
	function mod:DeconstructingEnergy(args)
		playerList = {}
		self:StopBar(CL.count:format(CL.bombs, deconstructingEnergyCount))
		deconstructingEnergyCount = deconstructingEnergyCount + 1
		if nextSynthesize > GetTime() + 26.8 then
			self:Bar(363795, deconstructingEnergyCount == 2 and 29.3 or deconstructingEnergyCount == 3 and 28 or 26.8, CL.count:format(CL.bombs, deconstructingEnergyCount))
		end
	end

	function mod:DeconstructingEnergyApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(363795, "warning")
			self:Say(363795, CL.bomb)
			self:SayCountdown(363795, 6)
		else
			self:PlaySound(363795, "alert")
		end
		self:TargetMessage(363795, "orange", args.destName, nil, CL.count:format(CL.bomb, deconstructingEnergyCount-1))
	end

	function mod:DeconstructingEnergyRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(363795)
		end
	end
end

function mod:Synthesize(args)
	self:StopBar(CL.count:format(args.spellName, syntesizeCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, syntesizeCount))
	self:PlaySound(args.spellId, "long")
	syntesizeCount = syntesizeCount + 1
	self:CastBar(args.spellId, 19.5, CL.count:format(args.spellName, syntesizeCount))
end

function mod:SynthesizeRemoved(args)
	self:Message(args.spellId, "cyan", CL.over:format(CL.count:format(args.spellName, syntesizeCount)))
	self:PlaySound(args.spellId, "long")

	self:Bar(362601, 20.5) -- Unstable Mote
	self:Bar(363795, 20.5) -- Deconstructing Energy
	self:Bar(363088, 26.5) -- Cosmic Shift
	self:Bar(364652, 35) -- Protoform Cascade

	local syntesizeCD = 85.5
	nextSynthesize = GetTime() + syntesizeCD
	self:Bar(363130, syntesizeCD, CL.count:format(args.spellName, syntesizeCount)) -- Synthesize
end
