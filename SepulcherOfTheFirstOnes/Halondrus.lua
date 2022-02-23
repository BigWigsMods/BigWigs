--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Halondrus the Reclaimer", 2481, 2463)
if not mod then return end
mod:RegisterEnableMob(180906) -- Halondrus
mod:SetEncounterID(2529)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local obeliskCount = 1
local scanCount = 1
local misslesCount = 1
local lanceCount = 1
local beamCount = 1
local prismCount = 1
local reclamationFormCount = 1
local relocationFormCount = 1
local detonationCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
end

--------------------------------------------------------------------------------
-- Initialization
--

local crushingPrismMarker = mod:AddMarkerOption(false, "player", 1, 365297, 1, 2, 3, 4) -- Crushing Prism
function mod:GetOptions()
	return {
		367079, -- Subterranean Scan
		365976, -- Ephemeral Burst
		361676, -- Earthbreaker Missiles
		360977, -- Lightshatter Beam
		365297, -- Crushing Prism
		crushingPrismMarker,
		359235, -- Reclamation Form
		359236, -- Relocation Form
		362056, -- Detonation
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "SubterraneanScan", 367079)
	self:Log("SPELL_AURA_APPLIED", "EphemeralBurstApplied", 365976)
	self:Log("SPELL_AURA_APPLIED_DOSE", "EphemeralBurstApplied", 365976)
	self:Log("SPELL_CAST_START", "EarthbreakerMissiles", 361676)
	self:Log("SPELL_CAST_SUCCESS", "LightshatterBeam", 360977)
	self:Log("SPELL_AURA_APPLIED", "LightshatterBeamApplied", 361309)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LightshatterBeamApplied", 361309)
	self:Log("SPELL_AURA_APPLIED", "CrushingPrismApplied", 365297)
	self:Log("SPELL_AURA_REMOVED", "CrushingPrismRemoved", 365297)
	self:Log("SPELL_CAST_START", "ReclamationForm", 359235)
	self:Log("SPELL_CAST_START", "RelocationForm", 359236)
	self:Log("SPELL_CAST_START", "Detonation", 362056)
end

function mod:OnEngage()
	obeliskCount = 1
	scanCount = 1
	misslesCount = 1
	lanceCount = 1
	beamCount = 1
	prismCount = 1
	reclamationFormCount = 1
	relocationFormCount = 1
	detonationCount = 1

	self:Bar(367079, 17.5, CL.count:format(self:SpellName(367079), scanCount))
	self:Bar(360977, 11.8, CL.count:format(self:SpellName(360977), beamCount))
	self:CDBar(361676, 35, CL.count:format(self:SpellName(361676), misslesCount))
	self:Bar(365297, 45.5, CL.count:format(self:SpellName(365297), prismCount))
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SubterraneanScan(args)
	self:StopBar(CL.count:format(args.spellName, scanCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, scanCount))
	self:PlaySound(args.spellId, "alert")
	scanCount = scanCount + 1
	self:Bar(args.spellId, 35, CL.count:format(args.spellName, scanCount))
end

function mod:EphemeralBurstApplied(args)
	if self:Me(args.destGUID) then
		self:NewStackMessage(args.spellId, "blue", args.destName, args.amount)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:EarthbreakerMissiles(args)
	self:StopBar(CL.count:format(args.spellName, misslesCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, misslesCount))
	self:PlaySound(args.spellId, "alert")
	misslesCount = misslesCount + 1
	self:CDBar(args.spellId, 35, CL.count:format(args.spellName, misslesCount))
end

function mod:LightshatterBeam(args)
	self:StopBar(CL.count:format(args.spellName, beamCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, beamCount))
	self:PlaySound(args.spellId, "alert")
	beamCount = beamCount + 1
	self:Bar(args.spellId, 15.8, CL.count:format(args.spellName, beamCount))
end

function mod:LightshatterBeamApplied(args)
	if self:Tank() and self:Tank(args.destName) then
		self:NewStackMessage(360977, "purple", args.destName)
		if not self:Me(args.destGUID) and not self:Tanking("boss1") then
			self:PlaySound(360977, "warning")
		end
	end
end


do
	local playerList = {}
	local prev = 0
	function mod:CrushingPrismApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			playerList = {}
			prismCount = prismCount + 1
			self:Bar(args.spellId, 42.7, CL.count:format(args.spellName, prismCount))
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(args.spellName, prismCount-1))
		self:CustomIcon(crushingPrismMarker, args.destName, count)
	end

	function mod:CrushingPrismRemoved(args)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "green", CL.removed:format(args.spellName))
			self:PlaySound(args.spellId, "info")
		end
		self:CustomIcon(crushingPrismMarker, args.destName, 0)
	end
end

function mod:ReclamationForm(args)
	self:StopBar(CL.count:format(args.spellName, reclamationFormCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, reclamationFormCount))
	self:PlaySound(args.spellId, "long")
	reclamationFormCount = reclamationFormCount + 1

	scanCount = 1
	beamCount = 1

	--self:Bar(367079, 17.5, CL.count:format(self:SpellName(367079), scanCount))
	--self:Bar(360977, 11.8, CL.count:format(self:SpellName(360977), beamCount))
	--self:Bar(365297, 45.5, CL.count:format(self:SpellName(365297), prismCount))
end

function mod:RelocationForm(args)
	self:StopBar(CL.count:format(args.spellName, relocationFormCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, relocationFormCount))
	self:PlaySound(args.spellId, "long")
	self:Bar(args.spellId, relocationFormCount == 1 and 63 or 80, CL.count:format(CL.intermission, detonationCount))
	relocationFormCount = relocationFormCount + 1

	self:StopBar(CL.count:format(self:SpellName(367079), scanCount))
	self:StopBar(CL.count:format(self:SpellName(360977), beamCount))
	self:StopBar(CL.count:format(self:SpellName(365297), prismCount))
end

function mod:Detonation(args)
	self:StopBar(CL.count:format(args.spellName, detonationCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, detonationCount))
	self:PlaySound(args.spellId, "long")
	detonationCount = detonationCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, detonationCount))
end

