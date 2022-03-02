--------------------------------------------------------------------------------
-- WCL Queries:
-- (ability.id = 360977 or ability.id = 359235 or ability.id = 359236) and type = "begincast"
-- (ability.id = 361676 or ability.id = 359235 or ability.id = 359236) and type = "begincast"
-- (ability.id = 367079 or ability.id = 359235 or ability.id = 359236) and type = "begincast"
-- (ability.id = 365297 and type = "applydebuff") or ((ability.id = 359235 or ability.id = 359236) and type = "begincast")
-- (ability.id = 360115 or ability.id = 359235 or ability.id = 359236) and type = "begincast"
-- (ability.id = 364979 or ability.id = 359235 or ability.id = 359236) and type = "begincast"
--
-- Normal: X
-- Heroic: X
-- Mythic: X
--

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

local reclaimCount = 1
local seismicTremorsCount = 1
local misslesCount = 1
local beamCount = 1
local prismCount = 1
local reclamationFormCount = 1
local relocationFormCount = 1
local shatterCount = 1
local intermission = false
local nextStageWarning = 82

--------------------------------------------------------------------------------
-- Timers
--

local missleTimersP3 = {17, 24.5, 37.2, 13} -- Earthbreaker Missiles
local intermissionTimers = {
	[364979] = { -- Shatter
		[1] = {36, 22.1, 0},
		[2] = {29.9, 24.1, 18.0, 0},
	},
	[365297] = { -- Crushing Prism
		[1] = {31.2, 0},
		[2] = {47, 0},
	},
	[361676] = { -- Earthbreaker Missiles
		[1] = {10.2, 26.1},
		[2] = {6.1, 18.1, 26.1},
	}
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.seismic_tremors = "Motes + Tremors" -- Seismic Tremors
	L.earthbreaker_missiles = "Missiles" -- Earthbreaker Missiles
	L.crushing_prism = "Prisms" -- Crushing Prism
	L.prism = "Prism"

	L.custom_on_stop_timers = "Always show ability bars"
	L.custom_on_stop_timers_desc = "Halondrus can delay its abilities. When this option is enabled, the bars for those abilities will stay on your screen."
end

--------------------------------------------------------------------------------
-- Initialization
--

local crushingPrismMarker = mod:AddMarkerOption(false, "player", 1, 365297, 1, 2, 3, 4) -- Crushing Prism
function mod:GetOptions()
	return {
		"stages",
		"custom_on_stop_timers",
		360115, -- Reclaim XXX Shield tracker
		367079, -- Seismic Tremors
		361676, -- Earthbreaker Missiles
		369207, -- Planetcracker Beam
		{360977, "TANK"}, -- Lightshatter Beam
		{365297, "SAY"}, -- Crushing Prism
		crushingPrismMarker,
		364979, -- Shatter
		368529, -- Eternity Overdrive
	},{
		["stages"] = "general",
		[360115] = -23915, -- Stage One: The Reclaimer
		[362056] = -23917, -- Stage Two: The Shimmering Cliffs
		[368529] = -24707, -- Stage Three: A Broken Cycle
	},{
		[367079] = L.seismic_tremors,
		[361676] = L.earthbreaker_missiles,
		[360977] = CL.beam,
		[365297] = L.crushing_prism,
	}
end

function mod:VerifyEnable(unit)
	return UnitCanAttack("player", unit)
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Reclaim", 360115)
	self:Log("SPELL_AURA_REMOVED", "ReclaimRemoved", 360115)
	self:Log("SPELL_CAST_START", "SeismicTremors", 367079)
	self:Log("SPELL_CAST_START", "EarthbreakerMissiles", 361676)
	self:Log("SPELL_CAST_START", "LightshatterBeam", 360977)
	self:Log("SPELL_AURA_APPLIED", "LightshatterBeamApplied", 361309)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LightshatterBeamApplied", 361309)
	self:Log("SPELL_AURA_APPLIED", "CrushingPrismApplied", 365297)
	self:Log("SPELL_AURA_REMOVED", "CrushingPrismRemoved", 365297)
	self:Log("SPELL_CAST_START", "ReclamationForm", 359235)
	self:Log("SPELL_CAST_START", "RelocationForm", 359236)
	self:Log("SPELL_CAST_SUCCESS", "RelocationFormDone", 359236)
	self:Log("SPELL_CAST_START", "Shatter", 364979)
	self:Log("SPELL_CAST_START", "EternityOverdrive", 368529)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 369207) -- Planetcracker Beam
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 369207)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 369207)

	self:RegisterMessage("BigWigs_BarCreated", "BarCreated")
end

function mod:OnEngage()
	self:SetStage(1)
	seismicTremorsCount = 1
	reclaimCount = 1
	misslesCount = 1
	beamCount = 1
	prismCount = 1
	reclamationFormCount = 1
	relocationFormCount = 1
	shatterCount = 1
	intermission = false
	nextStageWarning = 79.5

	self:Bar(367079, 8, CL.count:format(L.seismic_tremors, seismicTremorsCount))
	self:Bar(365297, 21.1, CL.count:format(L.crushing_prism, prismCount))
	self:Bar(361676, 43.1, CL.count:format(L.earthbreaker_missiles, misslesCount))
	self:Bar(360115, 61.2, CL.count:format(self:SpellName(360115), reclaimCount))

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	local currentHealth = self:GetHealth(unit)
	if currentHealth < nextStageWarning then -- Intermission at 77.5% and 45%
		self:Message("stages", "green", CL.soon:format(CL.intermission), false)
		nextStageWarning = nextStageWarning - 32.5
		if nextStageWarning < 40 then
			self:UnregisterUnitEvent(event, unit)
		end
	end
end

do
	local abilitysToPause = {
		[361676] = true, -- Earthbreaker Missiles
		[365297] = true, -- Crushing Prism
		[367079] = true, -- Seismic Tremors
		[360115] = true, -- Reclaim
	}

	local castPattern = CL.cast:gsub("%%s", ".+")

	local function stopAtZeroSec(bar)
		if bar.remaining < 0.15 then -- Pause at 0.0
			bar:SetDuration(0.01) -- Make the bar look full
			bar:Start()
			bar:Pause()
			bar:SetTimeVisibility(false)
		end
	end

	function mod:BarCreated(_, _, bar, _, key, text)
		if self:GetOption("custom_on_stop_timers") and abilitysToPause[key] and not text:match(castPattern) then
			bar:AddUpdateFunction(stopAtZeroSec)
		end
	end
end

function mod:Reclaim(args)
	self:StopBar(CL.count:format(L.earthbreaker_missiles, misslesCount))
	self:StopBar(CL.count:format(L.seismic_tremors, seismicTremorsCount))
	self:StopBar(CL.count:format(L.crushing_prism, prismCount))
	self:StopBar(CL.count:format(args.spellName, reclaimCount))

	self:Message(args.spellId, "red", CL.count:format(args.spellName, reclaimCount))
	self:PlaySound(args.spellId, "long")
	reclaimCount = reclaimCount + 1
end

function mod:ReclaimRemoved(args)
	self:Message(args.spellId, "green", CL.removed:format(CL.count:format(args.spellName, reclaimCount)))
	self:PlaySound(args.spellId, "info")

	self:Bar(367079, 4.5, CL.count:format(L.seismic_tremors, seismicTremorsCount))
	self:Bar(365297, 8, CL.count:format(L.crushing_prism, prismCount))
	self:Bar(361676, 11, CL.count:format(L.earthbreaker_missiles, misslesCount))
	self:Bar(360115, 61.2, CL.count:format(self:SpellName(360115), reclaimCount))
end

function mod:SeismicTremors(args)
	self:StopBar(CL.count:format(L.seismic_tremors, seismicTremorsCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.seismic_tremors, seismicTremorsCount))
	self:PlaySound(args.spellId, "alert")
	seismicTremorsCount = seismicTremorsCount + 1
	self:Bar(args.spellId, 26, CL.count:format(L.seismic_tremors, seismicTremorsCount))
end

function mod:EarthbreakerMissiles(args)
	self:StopBar(CL.count:format(L.earthbreaker_missiles, misslesCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.earthbreaker_missiles, misslesCount))
	self:PlaySound(args.spellId, "alert")
	misslesCount = misslesCount + 1
	if intermission then
		self:CDBar(args.spellId, intermissionTimers[args.spellId][relocationFormCount-1][misslesCount], CL.count:format(L.earthbreaker_missiles, misslesCount))
	else
		self:CDBar(args.spellId, self:GetStage() == 3 and missleTimersP3[misslesCount] or  26, CL.count:format(L.earthbreaker_missiles, misslesCount))
	end
end

function mod:LightshatterBeam(args)
	self:Message(args.spellId, "purple", CL.count:format(CL.beam, beamCount))
	self:PlaySound(args.spellId, "alert")
	beamCount = beamCount + 1
end

function mod:LightshatterBeamApplied(args)
	self:NewStackMessage(360977, "purple", args.destName, CL.beam)
	if not self:Me(args.destGUID) and not self:Tanking("boss1") then
		self:PlaySound(360977, "warning")
	end
end

do
	local prev = 0
	local playerList = {}
	function mod:CrushingPrismApplied(args)
		local t = args.time
		if t-prev > 5 then
			prev = t
			self:StopBar(CL.count:format(L.crushing_prism, prismCount))
			prismCount = prismCount + 1
			playerList = {}
			if intermission == true then
				self:CDBar(args.spellId, intermissionTimers[args.spellId][relocationFormCount-1][prismCount], CL.count:format(L.crushing_prism, prismCount))
			else
				self:CDBar(args.spellId, 26, CL.count:format(L.crushing_prism, prismCount))
			end
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
			self:Say(args.spellId)
		end
		self:NewTargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(L.crushing_prism, prismCount-1))
		self:CustomIcon(crushingPrismMarker, args.destName, count)
	end

	function mod:CrushingPrismRemoved(args)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "green", CL.removed:format(L.prism))
			self:PlaySound(args.spellId, "info")
		end
		self:CustomIcon(crushingPrismMarker, args.destName, 0)
	end
end

function mod:ReclamationForm(args)
	if not self:IsEngaged() then return end -- Casts it after respawning

	local stage = self:GetStage()
	stage = stage + 1
	self:SetStage(stage)
	self:Message("stages", "cyan", CL.stage:format(stage), false)
	self:PlaySound("stages", "long")
	reclamationFormCount = reclamationFormCount + 1
	intermission = false

	self:StopBar(CL.count:format(CL.intermission, reclamationFormCount))
	self:StopBar(CL.count:format(L.crushing_prism, prismCount))
	self:StopBar(CL.count:format(L.earthbreaker_missiles, misslesCount))
	self:StopBar(CL.count:format(self:SpellName(362056), shatterCount))

	seismicTremorsCount = 1
	beamCount = 1
	misslesCount = 1
	prismCount = 1
	reclaimCount = 1

	self:Bar(361676, stage == 3 and missleTimersP3[misslesCount] or 18, CL.count:format(L.earthbreaker_missiles, misslesCount))
	if stage == 2 then
		self:Bar(367079, 10, CL.count:format(L.seismic_tremors, seismicTremorsCount))
		self:Bar(365297, 23, CL.count:format(L.crushing_prism, prismCount))
		self:Bar(360115, 69.4, CL.count:format(self:SpellName(360115), reclaimCount))
	end
end

function mod:RelocationForm(args)
	self:Message("stages", "yellow", CL.count:format(args.spellName, relocationFormCount), args.spellId)
	self:PlaySound("stages", "long")
	self:CDBar("stages", relocationFormCount == 1 and 62 or 85, CL.count:format(CL.intermission, relocationFormCount), args.spellId)
	relocationFormCount = relocationFormCount + 1
end

function mod:RelocationFormDone() -- Some timers can still trigger just after _START, using _SUCCESS to start bars instead
	intermission = true

	self:StopBar(CL.count:format(L.earthbreaker_missiles, misslesCount))
	self:StopBar(CL.count:format(L.seismic_tremors, seismicTremorsCount))
	self:StopBar(CL.count:format(L.crushing_prism, prismCount))
	self:StopBar(CL.count:format(self:SpellName(360115), reclaimCount))

	misslesCount = 1
	shatterCount = 1
	prismCount = 1

	self:CDBar(361676, intermissionTimers[361676][relocationFormCount-1][misslesCount], CL.count:format(L.earthbreaker_missiles, misslesCount))
	self:CDBar(364979, intermissionTimers[364979][relocationFormCount-1][shatterCount], CL.count:format(self:SpellName(364979), shatterCount))
	self:CDBar(365297, intermissionTimers[365297][relocationFormCount-1][prismCount], CL.count:format(L.crushing_prism, prismCount))
end

function mod:Shatter(args)
	self:StopBar(CL.count:format(args.spellName, shatterCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, shatterCount))
	self:PlaySound(args.spellId, "long")
	shatterCount = shatterCount + 1
	self:Bar(args.spellId, intermissionTimers[args.spellId][relocationFormCount-1][shatterCount], CL.count:format(args.spellName, shatterCount))
end

function mod:EternityOverdrive(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
