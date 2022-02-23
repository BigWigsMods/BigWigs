--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Rygelon", 2481, 2467)
if not mod then return end
mod:RegisterEnableMob(182777) -- Rygelon
mod:SetEncounterID(2549)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local darkEclipseCount = 1
local celestialCollapseCount = 1
local manifestCosmosCount = 1
local celestialTerminatorCount = 1
local massiveBangCount = 1
local shatterSphereCount = 1
local stellarShroudCount = 1
local darkQuasarCount = 1

local singularityOnMe = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
end

--------------------------------------------------------------------------------
-- Initialization
--

local darkEclipseMarker = mod:AddMarkerOption(false, "player", 1, 361548, 1, 2, 3, 4) -- Dark Eclipse
function mod:GetOptions()
	return {
		361548, -- Dark Eclipse
		darkEclipseMarker,
		362275, -- Celestial Collapse
		{362206, "SAY_COUNTDOWN"}, -- Event Horizon
		362390, -- Manifest Cosmos
		{362184, "TANK"}, -- Corrupted Strikes
		{362172, "TANK"}, -- Corrupted Wound
		363109, -- Celestial Terminator
		363533, -- Massive Bang
		366606, -- Radiant Plasma
		362207, -- The Singularity
		364114, -- Shatter Sphere
		-- Mythic
		{362088, "SAY"}, -- Cosmic Irregularity
		366379, -- Stellar Shroud
		362798, -- Cosmic Radiation
		368080, -- Dark Quasar
	},{
		[361548] = -24245, -- Rygelon
		[362088] = "mythic",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "DarkEclipse", 361548)
	self:Log("SPELL_AURA_APPLIED", "DarkEclipseApplied", 361548)
	self:Log("SPELL_AURA_REMOVED", "DarkEclipseRemoved", 361548)
	self:Log("SPELL_CAST_START", "CelestialCollapse", 362275)
	self:Log("SPELL_AURA_APPLIED", "EventHorizonApplied", 362206)
	self:Log("SPELL_AURA_REMOVED", "EventHorizonRemoved", 362206)
	self:Log("SPELL_CAST_START", "ManifestCosmos", 362390)
	self:Log("SPELL_CAST_START", "CorruptedStrikes", 362184)
	self:Log("SPELL_AURA_APPLIED", "CorruptedWoundApplied", 362172)
	self:Log("SPELL_CAST_SUCCESS", "CelestialTerminator", 363109)
	self:Log("SPELL_CAST_START", "MassiveBang", 363533)
	self:Log("SPELL_CAST_START", "RadiantPlasma", 366606)
	self:Log("SPELL_AURA_APPLIED", "TheSingularityApplied", 362207)
	self:Log("SPELL_AURA_REMOVED", "TheSingularityRemoved", 362207)
	self:Log("SPELL_CAST_START", "ShatterSphere", 364114)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 362798) -- Cosmic Radiation
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 362798)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 362798)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "CosmicIrregularityApplied", 362088)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CosmicIrregularityApplied", 362088)
	self:Log("SPELL_CAST_START", "StellarShroud", 366379)
	self:Log("SPELL_CAST_SUCCESS", "DarkQuasar", 368080)
	self:Log("SPELL_AURA_APPLIED", "DarkQuasarApplied", 368080)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DarkQuasarApplied", 368080)
end

function mod:OnEngage()
	darkEclipseCount = 1
	celestialCollapseCount = 1
	manifestCosmosCount = 1
	celestialTerminatorCount = 1
	massiveBangCount = 1

	stellarShroudCount = 1
	darkQuasarCount = 1

	--self:Bar(361548, 30, CL.count:format(self:SpellName(361548), darkEclipseCount)) -- Dark Eclipse
	--self:Bar(362275, 30, CL.count:format(self:SpellName(362275), celestialCollapseCount)) -- Celestial Collapse
	--self:Bar(362390, 30, CL.count:format(self:SpellName(362390), manifestCosmosCount)) -- Manifest Cosmos
	--self:Bar(363109, 30, CL.count:format(self:SpellName(363109), celestialTerminatorCount)) -- Celestial Terminator
	--self:Bar(363533, 30, CL.count:format(self:SpellName(363533), massiveBangCount)) -- Massive Bang

	if self:Mythic() then
		--self:Bar(366379, 30, CL.count:format(self:SpellName(366379), stellarShroudCount)) -- Stellar Shroud
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local playerList = {}
	function mod:DarkEclipse(args)
		playerList = {}
		darkEclipseCount = darkEclipseCount + 1
		--self:Bar(args.spellId, 30, CL.count:format(args.spellName, darkEclipseCount))
	end

	function mod:DarkEclipseApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
		end
		self:NewTargetsMessage(args.spellId, "cyan", playerList, nil, CL.count:format(args.spellName, darkEclipseCount-1))
		self:CustomIcon(darkEclipseMarker, args.destName, count)
	end

	function mod:DarkEclipseRemoved(args)
		self:CustomIcon(darkEclipseMarker, args.destName, 0)
	end
end

function mod:CelestialCollapse(args)
	self:StopBar(CL.count:format(args.spellName, celestialCollapseCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, celestialCollapseCount))
	self:PlaySound(args.spellId, "alert")
	celestialCollapseCount = celestialCollapseCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, celestialCollapseCount))
end

function mod:EventHorizonApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info")
		self:TargetBar(args.spellId, 9, args.destName)
		self:SayCountdown(args.spellId, 9)
	end
end

function mod:EventHorizonRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:ManifestCosmos(args)
	self:StopBar(CL.count:format(args.spellName, manifestCosmosCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, manifestCosmosCount))
	self:PlaySound(args.spellId, "alert")
	manifestCosmosCount = manifestCosmosCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, manifestCosmosCount))
end

function mod:CorruptedStrikes(args)
	self:StopBar(args.spellName)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 14.5)
end

function mod:CorruptedWoundApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	if not self:Me(args.destGUID) and not self:Tanking("boss1") then
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:CelestialTerminator(args)
	self:StopBar(CL.count:format(args.spellName, celestialTerminatorCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, celestialTerminatorCount))
	self:PlaySound(args.spellId, "alert")
	celestialTerminatorCount = celestialTerminatorCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, celestialTerminatorCount))
end

do
	local singularityCheck, debuffName = nil, mod:SpellName(362207)
	local function checkForSingularity()
		if not singularityOnMe then
			mod:Message(362207, "blue", CL.no:format(debuffName))
			mod:PlaySound(362207, "warning")
			singularityCheck = mod:ScheduleTimer(checkForSingularity, 1.5)
		end
	end

	function mod:MassiveBang(args)
		self:StopBar(CL.count:format(args.spellName, massiveBangCount))
		self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(args.spellName, massiveBangCount)))
		self:PlaySound(args.spellId, "alert")
		self:CastBar(args.spellId, 10)
		massiveBangCount = massiveBangCount + 1
		--self:Bar(args.spellId, 30, CL.count:format(args.spellName, massiveBangCount))
		checkForSingularity()
	end

	function mod:MassiveBangSuccess(args)
		if singularityCheck then
			self:CancelTimer(singularityCheck)
		end
	end
end

function mod:RadiantPlasma(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

function mod:TheSingularityApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info")
		singularityOnMe = true
	end
end

function mod:TheSingularityRemoved(args)
	if self:Me(args.destGUID) then
		singularityOnMe = false
	end
end

function mod:ShatterSphere(args)
	self:StopBar(CL.count:format(args.spellName, shatterSphereCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, shatterSphereCount))
	self:PlaySound(args.spellId, "alert")
	shatterSphereCount = shatterSphereCount + 1
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

-- Mythic
function mod:CosmicIrregularityApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:NewStackMessage(args.spellId, "blue", args.destName, args.amount)
		self:PlaySound(args.spellId, "alarm")
		if amount > 3 then -- Yell: stack amount, extra emphasize on 6
			self:Yell(args.spellId, amount == 6 and "{rt8} 6 {rt8}" or amount, true)
		end
	end
end

function mod:StellarShroud(args)
	self:StopBar(CL.count:format(args.spellName, stellarShroudCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, stellarShroudCount))
	self:PlaySound(args.spellId, "alert")
	stellarShroudCount = stellarShroudCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, stellarShroudCount))
end

do
	local scheduled, destName, stacks = nil, nil, 0
	function mod:DarkQuasarStackMessage()
		mod:NewStackMessage(368080, "yellow", destName, stacks)
		mod:PlaySound(368080, "alert")
		scheduled = nil
	end

	function mod:DarkQuasar(args)
		self:StopBar(CL.count:format(args.spellName, darkQuasarCount))
		darkQuasarCount = darkQuasarCount + 1
		--self:Bar(args.spellId, 30, CL.count:format(args.spellName, darkQuasarCount))
	end

	function mod:DarkQuasarApplied(args)
		stacks = args.amount or 1
		destName = args.destName
		if not scheduled then -- Delay message to only warn for highest stack
			scheduled = self:ScheduleTimer("DarkQuasarStackMessage", 0.1, args.destName)
		end
	end
end
