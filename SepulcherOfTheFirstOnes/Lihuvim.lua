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
	L.mote = "Mote"

	L.custom_on_nameplate_fixate = "Fixate Nameplate Icon"
	L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate on Acquisitions Automa that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."
	L.custom_on_nameplate_fixate_icon = 210130
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		364652, -- Protoform Cascade
		363088, -- Cosmic Shift
		{362622, "SAY", "SAY_COUNTDOWN"}, -- Unstable Mote
		{363795, "SAY", "SAY_COUNTDOWN"}, -- Deconstructing Energy
		363130, -- Synthesize
		360869, -- Requisitioned
		"custom_on_nameplate_fixate",
		{366012, "SAY", "SAY_COUNTDOWN"}, -- Terminal Mote
	},{
		[366012] = "mythic",
	},{
		[364652] = L.protoform_cascade, -- Protoform Cascade (Frontal)
		[363088] = L.cosmic_shift, -- Cosmic Shift (Pushback)
		[362601] = L.unstable_mote, -- Unstable Mote (Motes)
		[363795] = CL.bombs, -- Deconstructing Energy (Bombs)
		[360869] = CL.fixate, -- Requisitioned (Fixate)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "ProtoformCascade", 364652)
	self:Log("SPELL_CAST_START", "CosmicShift", 363088)
	self:Log("SPELL_CAST_START", "UnstableMote", 362601)
	self:Log("SPELL_AURA_APPLIED", "MoteApplied", 362622, 366012) -- Unstable Mote, Terminal Mote
	self:Log("SPELL_AURA_REMOVED", "MoteRemoved", 362622, 366012)
	self:Log("SPELL_CAST_SUCCESS", "DeconstructingEnergy", 363676)
	self:Log("SPELL_AURA_APPLIED", "DeconstructingEnergyApplied", 363795, 363676) -- DPS, TANK?
	self:Log("SPELL_AURA_REMOVED", "DeconstructingEnergyRemoved", 363795, 363676)
	self:Log("SPELL_CAST_START", "Synthesize", 363130)
	self:Log("SPELL_AURA_REMOVED", "SynthesizeRemoved", 363130)
	self:Log("SPELL_AURA_APPLIED", "FixateApplied", 360869) -- Requisitioned
	self:Log("SPELL_AURA_REMOVED", "FixateRemoved", 360869) -- Requisitioned
end

function mod:OnEngage()
	protoformCascadeCount = 1
	cosmicShiftCount = 1
	unstableMoteCount = 1
	deconstructingEnergyCount = 1
	syntesizeCount = 1
	nextSynthesize = GetTime() + 31.5

	self:Bar(364652, 6, CL.count:format(L.protoform_cascade, protoformCascadeCount)) -- Protoform Cascade
	self:Bar(362622, 12, CL.count:format(L.unstable_mote, unstableMoteCount)) -- Unstable Mote
	self:Bar(363795, 20.5, CL.count:format(CL.bombs, deconstructingEnergyCount)) -- Deconstructing Energy
	self:Bar(363088, 28, CL.count:format(L.cosmic_shift, cosmicShiftCount)) -- Cosmic Shift
	self:Bar(363130, 31.5, CL.count:format(self:SpellName(363130), syntesizeCount)) -- Synthesize
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ProtoformCascade(args)
	self:StopBar(CL.count:format(L.protoform_cascade, protoformCascadeCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.protoform_cascade, protoformCascadeCount))
	self:PlaySound(args.spellId, "alert")
	protoformCascadeCount = protoformCascadeCount + 1
	local cd = protoformCascadeCount == 3 and 14.5 or 11
	if nextSynthesize > GetTime() + cd then
		self:Bar(args.spellId, cd, CL.count:format(L.protoform_cascade, protoformCascadeCount))
	end
end

function mod:CosmicShift(args)
	self:StopBar(CL.count:format(L.cosmic_shift, cosmicShiftCount))
	self:Message(args.spellId, "orange", CL.count:format(L.cosmic_shift, cosmicShiftCount))
	self:PlaySound(args.spellId, "alarm")
	cosmicShiftCount = cosmicShiftCount + 1
	local cd = cosmicShiftCount == 2 and 28 or 32.5
	if nextSynthesize > GetTime() + cd then
		self:Bar(args.spellId, cd, CL.count:format(L.cosmic_shift, cosmicShiftCount))
	end
end

function mod:UnstableMote(args)
	self:StopBar(CL.count:format(L.unstable_mote, unstableMoteCount))
	self:Message(362622, "orange", CL.count:format(L.unstable_mote, unstableMoteCount))
	self:PlaySound(362622, "alarm")
	unstableMoteCount = unstableMoteCount + 1
	if nextSynthesize > GetTime() + 32.8 then
		self:Bar(362622, 32.8, CL.count:format(L.unstable_mote, unstableMoteCount))
	end
end

do
	function mod:MoteApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, L.mote)
			self:SayCountdown(args.spellId, args.spellId == 366012 and 4 or 5) -- Terminal Mote is 4s
		end
	end

	function mod:MoteRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

do
	local playerList = {}
	function mod:DeconstructingEnergy(args)
		playerList = {}
		self:StopBar(CL.count:format(CL.bombs, deconstructingEnergyCount))
		deconstructingEnergyCount = deconstructingEnergyCount + 1
		if nextSynthesize > GetTime() + 42.6 then
			self:Bar(363795, 42.6, CL.count:format(CL.bombs, deconstructingEnergyCount))
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
		self:TargetsMessage(363795, "orange", playerList, nil, CL.count:format(CL.bomb, deconstructingEnergyCount-1))
	end

	function mod:DeconstructingEnergyRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(363795)
		end
	end
end

function mod:Synthesize(args)
	-- Incase of fuckups
	self:StopBar(CL.count:format(L.protoform_cascade, protoformCascadeCount)) -- Protoform Cascade
	self:StopBar(CL.count:format(L.unstable_mote, unstableMoteCount)) -- Unstable Mote
	self:StopBar(CL.count:format(CL.bombs, deconstructingEnergyCount)) -- Deconstructing Energy
	self:StopBar(CL.count:format(L.cosmic_shift, cosmicShiftCount)) -- Cosmic Shift

	self:StopBar(CL.count:format(args.spellName, syntesizeCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, syntesizeCount))
	self:PlaySound(args.spellId, "long")
	syntesizeCount = syntesizeCount + 1
	self:CastBar(args.spellId, 19.5, CL.count:format(args.spellName, syntesizeCount))
end

function mod:SynthesizeRemoved(args)
	self:Message(args.spellId, "cyan", CL.over:format(CL.count:format(args.spellName, syntesizeCount)))
	self:PlaySound(args.spellId, "long")

	protoformCascadeCount = 1
	cosmicShiftCount = 1
	unstableMoteCount = 1
	deconstructingEnergyCount = 1

	self:Bar(364652, 36.5, CL.count:format(L.protoform_cascade, protoformCascadeCount)) -- Protoform Cascade
	self:Bar(362622, 42.5, CL.count:format(L.unstable_mote, unstableMoteCount)) -- Unstable Mote
	self:Bar(363795, 51, CL.count:format(CL.bombs, deconstructingEnergyCount)) -- Deconstructing Energy
	self:Bar(363088, 58.5, CL.count:format(L.cosmic_shift, cosmicShiftCount)) -- Cosmic Shift

	local syntesizeCD = 131
	nextSynthesize = GetTime() + syntesizeCD
	self:Bar(363130, syntesizeCD, CL.count:format(args.spellName, syntesizeCount)) -- Synthesize
end

function mod:FixateApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.fixate)
		self:PlaySound(args.spellId, "alarm")
		if self:GetOption("custom_on_nameplate_fixate") then
			self:AddPlateIcon(210130, args.sourceGUID) -- 210130 = ability_fixated_state_red
		end
	end
end

function mod:FixateRemoved(args)
	if self:Me(args.destGUID) and self:GetOption("custom_on_nameplate_fixate") then
		self:RemovePlateIcon(210130, args.sourceGUID)
	end
end
