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
local nextReclaim = 0

--------------------------------------------------------------------------------
-- Timers
--

local missleTimersP3 = {17, 25, 37, 13, 25} -- Earthbreaker Missiles

local intermissionTimers = {
	[364979] = { -- Shatter
		[1] = {25.3, 22.1, 0},
		[2] = {19.2, 24.1, 18.0, 0},
	},
	[365297] = { -- Crushing Prism
		["other"] = { -- Other
			[1] = {31.2, 0},
			[2] = {47, 0},
		},
		["mythic"] = { -- Mythic
			[1] = {6, 26.1, 14.1, 0},
			[2] = {14.1, 18.0, 18.1, 0},
		},
	},
	[361676] = { -- Earthbreaker Missiles
		[1] = {10.2, 26.1, 0},
		[2] = {6.1, 18.1, 26.1, 0},
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
	L.ephemeral_fissure = "Fissure"

	L.bomb_dropped = "Bomb dropped"
	L.volatile_charges_new = "New Bombs!"

	L.absorb_text = "%s (%.0f%%)"

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
		{360115, "INFOBOX"}, -- Reclaim
		367079, -- Seismic Tremors
		360114, -- Ephemeral Fissure
		361676, -- Earthbreaker Missiles
		369207, -- Planetcracker Beam
		{360977, "TANK"}, -- Lightshatter Beam
		{365297, "SAY"}, -- Crushing Prism
		crushingPrismMarker,
		368363, -- Shattered Prism
		364979, -- Shatter
		368529, -- Eternity Overdrive
		{368969, "SAY_COUNTDOWN"}, -- Volatile Charge
	},{
		["stages"] = "general",
		[360115] = -23915, -- Stage One: The Reclaimer
		[362056] = -23917, -- Stage Two: The Shimmering Cliffs
		[368529] = -24707, -- Stage Three: A Broken Cycle
		[368969] = "mythic",
	},{
		[367079] = L.seismic_tremors,
		[360114] = L.ephemeral_fissure,
		[361676] = L.earthbreaker_missiles,
		[360977] = CL.beam,
		[365297] = L.crushing_prism,
		[368969] = CL.bomb,
	}
end

function mod:VerifyEnable(unit)
	return UnitCanAttack("player", unit)
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "Reclaim", 360115)
	self:Log("SPELL_AURA_APPLIED", "ReclaimApplied", 360115)
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

	-- Planetcracker Beam, Shattered Prism, Ephemeral Fissure
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 369207, 368363, 360114)
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 369207, 368363, 360114)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 369207, 368363, 360114)

	self:Log("SPELL_AURA_APPLIED", "VolatileChargeApplied", 368969)
	self:Log("SPELL_AURA_REMOVED", "VolatileChargeRemoved", 368969)

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
	local reclaimCD = self:Mythic() and 63.1 or 61.2
	nextReclaim = GetTime() + reclaimCD
	if not self:Easy() then
		self:Bar(360977, 8, CL.count:format(CL.beam, beamCount))
	end
	self:Bar(367079, self:Mythic() and 4 or 8, CL.count:format(L.seismic_tremors, seismicTremorsCount))
	self:Bar(365297, self:Mythic() and 17.1 or 21.1, CL.count:format(L.crushing_prism, prismCount))
	self:Bar(361676, self:Mythic() and 11.2 or 43.1, CL.count:format(L.earthbreaker_missiles, misslesCount))
	self:Bar(360115, reclaimCD, CL.count:format(self:SpellName(360115), reclaimCount))

	if self:Mythic() then
		self:Bar(368969, 5.5, L.volatile_charges_new) -- Volatile Charges
		self:ScheduleTimer("Message", 5.5, 368969, "yellow", L.volatile_charges_new)
	end

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
		[360977] = true, -- Lightshatter Beam
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

do
	local timer, maxAbsorb = nil, 0
	local appliedTime = 0
	local function updateInfoBox(self)
		local absorb = UnitGetTotalAbsorbs("boss1")
		local absorbPercentage = absorb / maxAbsorb
		self:SetInfoBar(360115, 1, absorbPercentage)
		self:SetInfo(360115, 2, L.absorb_text:format(self:AbbreviateNumber(absorb), absorbPercentage * 100))
	end

	function mod:Reclaim(args)
		self:StopBar(CL.count:format(args.spellName, reclaimCount))
		self:StopBar(CL.count:format(L.earthbreaker_missiles, misslesCount))
		self:StopBar(CL.count:format(L.seismic_tremors, seismicTremorsCount))
		self:StopBar(CL.count:format(L.crushing_prism, prismCount))
		self:StopBar(CL.count:format(CL.beam, beamCount))

		self:Message(args.spellId, "red", CL.count:format(args.spellName, reclaimCount))
		self:PlaySound(args.spellId, "long")
		reclaimCount = reclaimCount + 1
		self:CastBar(args.spellId, 4, CL.count:format(args.spellName, reclaimCount))

		self:Bar(367079, 4.5, CL.count:format(L.seismic_tremors, seismicTremorsCount))
		self:Bar(360977, 8, CL.count:format(CL.beam, beamCount))
		self:Bar(365297, self:Mythic() and 17 or 8, CL.count:format(L.crushing_prism, prismCount))
		self:Bar(361676, 11, CL.count:format(L.earthbreaker_missiles, misslesCount))
		self:Bar(360115, 61.2, CL.count:format(self:SpellName(360115), reclaimCount))

		self:PauseBar(367079, CL.count:format(L.seismic_tremors, seismicTremorsCount))
		self:PauseBar(365297, CL.count:format(CL.beam, beamCount))
		self:PauseBar(365297, CL.count:format(L.crushing_prism, prismCount))
		self:PauseBar(361676, CL.count:format(L.earthbreaker_missiles, misslesCount))
		self:PauseBar(360115, CL.count:format(self:SpellName(360115), reclaimCount))
	end

	function mod:ReclaimApplied(args)
		appliedTime = args.time
		if self:CheckOption(args.spellId, "INFOBOX") then
			self:OpenInfo(args.spellId, args.spellName)
			self:SetInfoBar(args.spellId, 1, 1)
			self:SetInfo(args.spellId, 1, CL.absorb)
			maxAbsorb = UnitGetTotalAbsorbs("boss1")
			timer = self:ScheduleRepeatingTimer(updateInfoBox, 0.1, self)
		end
	end

	function mod:ReclaimRemoved(args)
		self:Message(args.spellId, "green", CL.removed_after:format(CL.count:format(args.spellName, reclaimCount-1), args.time - appliedTime))
		self:PlaySound(args.spellId, "info")

		local reclaimCD = 61.2
		nextReclaim = GetTime() + reclaimCD

		self:ResumeBar(367079, CL.count:format(L.seismic_tremors, seismicTremorsCount))
		self:ResumeBar(365297, CL.count:format(CL.beam, beamCount))
		self:ResumeBar(365297, CL.count:format(L.crushing_prism, prismCount))
		self:ResumeBar(361676, CL.count:format(L.earthbreaker_missiles, misslesCount))
		self:ResumeBar(360115, CL.count:format(self:SpellName(360115), reclaimCount))

		self:CloseInfo(args.spellId)
		if timer then
			self:CancelTimer(timer)
			timer = nil
		end
	end
end

function mod:SeismicTremors(args)
	self:StopBar(CL.count:format(L.seismic_tremors, seismicTremorsCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.seismic_tremors, seismicTremorsCount))
	self:PlaySound(args.spellId, "alert")
	seismicTremorsCount = seismicTremorsCount + 1
	if self:Mythic() then
		if seismicTremorsCount % 2 == 0 then
			self:Bar(args.spellId, 25.8, CL.count:format(L.seismic_tremors, seismicTremorsCount))
		end
	else
		if GetTime() + 26 < nextReclaim then
			self:Bar(args.spellId, 26, CL.count:format(L.seismic_tremors, seismicTremorsCount))
		end
	end
end

function mod:EarthbreakerMissiles(args)
	self:StopBar(CL.count:format(L.earthbreaker_missiles, misslesCount))
	self:Message(args.spellId, "orange", CL.count:format(L.earthbreaker_missiles, misslesCount))
	self:PlaySound(args.spellId, "alert")
	misslesCount = misslesCount + 1
	if intermission then
		self:CDBar(args.spellId, intermissionTimers[args.spellId][relocationFormCount-1][misslesCount], CL.count:format(L.earthbreaker_missiles, misslesCount))
	else
		if misslesCount % 2 == 0 or self:GetStage() == 3 then
			if self:GetStage() == 3 and (self:Mythic() and misslesCount > 3 or misslesCount > 4) then return end
			-- No more missles after 3rd in stage 3, mythic, 4 missles in other difficulties
			self:CDBar(args.spellId, self:GetStage() == 3 and missleTimersP3[misslesCount] or  26.4, CL.count:format(L.earthbreaker_missiles, misslesCount))
		end
	end
end

function mod:LightshatterBeam(args)
	self:StopBar(CL.count:format(CL.beam, beamCount))
	self:Message(args.spellId, "purple", CL.count:format(CL.beam, beamCount))
	self:PlaySound(args.spellId, "alert")
	beamCount = beamCount + 1
	if self:GetStage() == 3 or beamCount % 8 ~= 1 then -- 9, 17
		self:CDBar(args.spellId, 4.5, CL.count:format(CL.beam, beamCount))
	end
end

function mod:LightshatterBeamApplied(args)
	if self:Tank() then
		self:StackMessage(360977, "purple", args.destName, args.amount, 0, CL.beam)
		if not self:Me(args.destGUID) and not self:Tanking("boss1") then
			self:PlaySound(360977, "warning")
		end
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
			if intermission then
				local diff = self:Mythic() and "mythic" or "other"
				self:CDBar(args.spellId, intermissionTimers[args.spellId][diff][self:GetStage()][prismCount], CL.count:format(L.crushing_prism, prismCount))
			else
				if self:Mythic() then
					if prismCount % 2 == 0 then
						self:Bar(args.spellId, 27, CL.count:format(L.crushing_prism, prismCount))
					end
				else
					if GetTime() + 26 < nextReclaim then
						self:CDBar(args.spellId, 26, CL.count:format(L.crushing_prism, prismCount))
					end
				end
			end
		end
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
			self:Say(args.spellId, L.prism)
		end
		self:TargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(L.crushing_prism, prismCount-1))
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
	self:CastBar("stages", 6, CL.cast:format(args.spellName), args.spellId)
	reclamationFormCount = reclamationFormCount + 1
	intermission = false

	self:StopBar(CL.count:format(CL.intermission, reclamationFormCount))
	self:StopBar(CL.count:format(L.crushing_prism, prismCount))
	self:StopBar(CL.count:format(L.earthbreaker_missiles, misslesCount))
	self:StopBar(CL.count:format(self:SpellName(362056), shatterCount))
	self:StopBar(CL.count:format(CL.beam, beamCount))

	seismicTremorsCount = 1
	beamCount = 1
	misslesCount = 1
	prismCount = 1
	reclaimCount = 1

	if not self:Easy() then
		self:Bar(360977, 14.1, CL.count:format(CL.beam, beamCount))
	end
	if stage == 2 then
		self:Bar(367079, 10, CL.count:format(L.seismic_tremors, seismicTremorsCount)) -- Seismic Tremors
		self:Bar(361676, 18, CL.count:format(L.earthbreaker_missiles, misslesCount)) -- Earthbreaker Missiles
		self:Bar(365297, 23, CL.count:format(L.crushing_prism, prismCount)) -- Crushing Prism

		local reclaimCD = 69.4
		nextReclaim = GetTime() + reclaimCD
		self:Bar(360115, reclaimCD, CL.count:format(self:SpellName(360115), reclaimCount)) -- Reclaim
		if self:Mythic() then
			self:Bar(368969, 10.5, L.volatile_charges_new) -- Volatile Charges
			self:ScheduleTimer("Message", 5.5, 368969, "yellow", L.volatile_charges_new)
		end
	elseif stage == 3 then
		self:Bar(368529, 7.5) -- Eternity Overdrive
		self:Bar(361676, missleTimersP3[misslesCount], CL.count:format(L.earthbreaker_missiles, misslesCount)) -- Earthbreaker Missiles
	end
end

function mod:RelocationForm(args)
	self:Message("stages", "cyan", CL.count:format(CL.intermission, relocationFormCount), args.spellId)
	self:PlaySound("stages", "long")
	self:CastBar("stages", 5.5, CL.cast:format(args.spellName), args.spellId)
	self:CDBar("stages", relocationFormCount == 1 and 62 or 85, CL.stage:format(self:GetStage() + 1), args.spellId)
	relocationFormCount = relocationFormCount + 1
end

function mod:RelocationFormDone()
	-- Some timers can still trigger just after _START, using _SUCCESS to start bars instead
	self:StopBar(CL.count:format(L.earthbreaker_missiles, misslesCount))
	self:StopBar(CL.count:format(L.seismic_tremors, seismicTremorsCount))
	self:StopBar(CL.count:format(L.crushing_prism, prismCount))
	self:StopBar(CL.count:format(self:SpellName(360115), reclaimCount))
	self:StopBar(CL.count:format(CL.beam, beamCount))

	intermission = true
	misslesCount = 1
	shatterCount = 1
	prismCount = 1

	local diff = self:Mythic() and "mythic" or "other"
	self:CDBar(361676, intermissionTimers[361676][self:GetStage()][misslesCount], CL.count:format(L.earthbreaker_missiles, misslesCount))
	self:CDBar(364979, intermissionTimers[364979][self:GetStage()][shatterCount], CL.count:format(self:SpellName(364979), shatterCount))
	self:CDBar(365297, intermissionTimers[365297][diff][self:GetStage()][prismCount], CL.count:format(L.crushing_prism, prismCount))
end

function mod:Shatter(args)
	self:StopBar(CL.count:format(args.spellName, shatterCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, shatterCount))
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 6, CL.count:format(CL.knockback, shatterCount))
	shatterCount = shatterCount + 1
	self:Bar(args.spellId, intermissionTimers[args.spellId][relocationFormCount-1][shatterCount], CL.count:format(args.spellName, shatterCount))
end

function mod:EternityOverdrive(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "long")
end

do
	local prev = 0
	local message = {
		[368363] = L.prism, -- Shattered Prism (Prism)
		[360114] = L.ephemeral_fissure, -- Ephemeral Fissure (Fissure)
	}
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou", message[args.spellId])
			end
		end
	end
end

function mod:VolatileChargeApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.bomb)
		self:Bar(args.spellId, 30, CL.explosion)
		self:PlaySound(args.spellId, "alarm")
		self:YellCountdown(args.spellId, 30, nil, 2) -- dont say anything at 3
	end
end

function mod:VolatileChargeRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", L.bomb_dropped)
		self:StopBar(CL.explosion)
		self:PlaySound(args.spellId, "info")
		self:CancelYellCountdown(args.spellId)
	end
end
