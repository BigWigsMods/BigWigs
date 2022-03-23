--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Rygelon", 2481, 2467)
if not mod then return end
mod:RegisterEnableMob(182777) -- Rygelon
mod:SetEncounterID(2549)
mod:SetRespawnTime(30)
mod:SetStage(1)

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

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.celestial_collapse = "Quasars" -- Celestial Collapse
	L.manifest_cosmos = "Cores" -- Manifest Cosmos
	L.stellar_shroud = "Heal Absorb" -- Stellar Shroud

	L.knock = "Knock" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

--------------------------------------------------------------------------------
-- Initialization
--

local darkEclipseMarker = mod:AddMarkerOption(false, "player", 1, 361548, 1, 2, 3, 4) -- Dark Eclipse
function mod:GetOptions()
	return {
		{362806, "SAY_COUNTDOWN"}, -- Dark Eclipse
		darkEclipseMarker,
		362275, -- Celestial Collapse
		{362206, "SAY_COUNTDOWN"}, -- Event Horizon
		362390, -- Manifest Cosmos
		{362184, "TANK"}, -- Corrupted Strikes
		{362172, "TANK"}, -- Corrupted Wound
		363533, -- Massive Bang
		364386, -- Gravitational Collapse
		366606, -- Radiant Plasma
		362207, -- The Singularity
		364114, -- Shatter Sphere
		-- Mythic
		{362088, "SAY"}, -- Cosmic Irregularity
		366379, -- Stellar Shroud
		362798, -- Cosmic Radiation
		{368080, "SAY_COUNTDOWN"}, -- Dark Quasar
	},{
		[361548] = -24245, -- Rygelon
		[362088] = "mythic",
	},{
		[362275] = L.celestial_collapse, -- Celestial Collapse
		[362390] = L.manifest_cosmos, -- Manifest Cosmos
		[366379] = L.stellar_shroud -- Stellar Shroud
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "DarkEclipse", 362806)
	self:Log("SPELL_AURA_APPLIED", "DarkEclipseApplied", 362806, 361548) -- Other, Mythic
	self:Log("SPELL_AURA_REMOVED", "DarkEclipseRemoved", 362806, 361548)
	self:Log("SPELL_CAST_START", "CelestialCollapse", 362275)
	self:Log("SPELL_AURA_APPLIED", "EventHorizonApplied", 362206)
	self:Log("SPELL_AURA_REMOVED", "EventHorizonRemoved", 362206)
	self:Log("SPELL_CAST_START", "ManifestCosmos", 362390)
	self:Log("SPELL_CAST_START", "CorruptedStrikes", 362184)
	self:Log("SPELL_AURA_APPLIED", "CorruptedWoundApplied", 362172)
	self:Log("SPELL_CAST_START", "MassiveBang", 363533)
	self:Log("SPELL_CAST_SUCCESS", "MassiveBangSuccess", 363533)
	self:Log("SPELL_CAST_START", "GravitationalCollapse", 364386)
	self:Log("SPELL_CAST_START", "RadiantPlasma", 366606)
	self:Log("SPELL_AURA_APPLIED", "TheSingularityApplied", 362207)
	self:Log("SPELL_CAST_START", "ShatterSphere", 364114)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 362798) -- Cosmic Radiation
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 362798)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 362798)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "CosmicIrregularityApplied", 362088)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CosmicIrregularityApplied", 362088)
	self:Log("SPELL_CAST_START", "StellarShroud", 366379)
	self:Log("SPELL_AURA_APPLIED", "DarkQuasarApplied", 368080)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DarkQuasarApplied", 368080)
	self:Log("SPELL_AURA_REMOVED", "DarkQuasarRemoved", 368080)
	self:Log("SPELL_AURA_APPLIED", "DarkQuasarPlayerApplied", 368082)
	self:Log("SPELL_AURA_REMOVED", "DarkQuasarPlayerRemoved", 368082)
end

function mod:OnEngage()
	self:SetStage(1)
	darkEclipseCount = 1
	celestialCollapseCount = 1
	manifestCosmosCount = 1
	celestialTerminatorCount = 1
	massiveBangCount = 1
	shatterSphereCount = 1

	stellarShroudCount = 1
	darkQuasarCount = 1

	self:Bar(362806, self:Mythic() and 8 or 6.2, CL.count:format(self:SpellName(362806), darkEclipseCount)) -- Dark Eclipse
	self:Bar(362275, self:Mythic() and 9.5 or 8.6, CL.count:format(L.celestial_collapse, celestialCollapseCount)) -- Celestial Collapse
	self:Bar(362390, self:Mythic() and 20.5 or 15.4, CL.count:format(L.manifest_cosmos, manifestCosmosCount)) -- Manifest Cosmos
	self:Bar(363533, self:Mythic() and 65.5 or 61, CL.count:format(self:SpellName(363533), massiveBangCount)) -- Massive Bang

	if self:Mythic() then
		self:Bar(366379, 8.3, CL.count:format(L.stellar_shroud, stellarShroudCount)) -- Stellar Shroud
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
		if self:Mythic() then
			if darkEclipseCount < 4 then -- 3 before a Massive Bang
					self:Bar(args.spellId, 21.9, CL.count:format(args.spellName, darkEclipseCount))
			end
		else
			if darkEclipseCount < 6 then -- 5 before a Massive Bang
				self:Bar(args.spellId, 11, CL.count:format(args.spellName, darkEclipseCount))
			end
		end
	end

	function mod:DarkEclipseApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(362806, "warning")
			self:YellCountdown(362806, self:Mythic() and 15 or 18)
		end
		self:NewTargetsMessage(362806, "cyan", playerList, self:Mythic() and 4 or 3, CL.count:format(args.spellName, darkEclipseCount-1), nil, 1) -- travel time
		self:CustomIcon(darkEclipseMarker, args.destName, count)
	end

	function mod:DarkEclipseRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelYellCountdown(362806)
		end
	end
end

function mod:CelestialCollapse(args)
	self:StopBar(CL.count:format(L.celestial_collapse, celestialCollapseCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.celestial_collapse, celestialCollapseCount))
	self:PlaySound(args.spellId, "alert")
	celestialCollapseCount = celestialCollapseCount + 1
	if celestialCollapseCount < 3 then -- 2 before a Massive Bang
		self:CDBar(args.spellId, self:Mythic() and 23.1 or 21, CL.count:format(L.celestial_collapse, celestialCollapseCount))
	end
end

function mod:EventHorizonApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.you:format(args.spellName))
		self:PlaySound(args.spellId, "info")
		self:TargetBar(args.spellId, self:Mythic() and 9 or 5, args.destName)
		self:SayCountdown(args.spellId, self:Mythic() and 9 or 5, L.knock)
		self:CancelYellCountdown(362806) -- Dark Eclipse
	end
end

function mod:EventHorizonRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	self:CustomIcon(darkEclipseMarker, args.destName, 0)
end

function mod:ManifestCosmos(args)
	self:StopBar(CL.count:format(L.manifest_cosmos, manifestCosmosCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.manifest_cosmos, manifestCosmosCount))
	self:PlaySound(args.spellId, "alert")
	manifestCosmosCount = manifestCosmosCount + 1
	if self:Mythic() then
		if manifestCosmosCount < 4 then -- 3 before a Massive Bang
			self:CDBar(args.spellId, 12.2, CL.count:format(L.manifest_cosmos, manifestCosmosCount))
		end
	else
		if manifestCosmosCount < 3 then -- 2 before a Massive Bang
			self:CDBar(args.spellId, 24.5, CL.count:format(L.manifest_cosmos, manifestCosmosCount))
		end
	end
end

function mod:CorruptedStrikes(args)
	self:StopBar(args.spellName)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 6.1)
end

function mod:CorruptedWoundApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	if not self:Me(args.destGUID) and not self:Tanking("boss1") then
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:MassiveBang(args)
	self:StopBar(CL.count:format(args.spellName, massiveBangCount))
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(args.spellName, massiveBangCount)))
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, self:Mythic() and (massiveBangCount == 4 and 30 or 10) or 10, CL.count:format(args.spellName, massiveBangCount))
	massiveBangCount = massiveBangCount + 1
end

function mod:MassiveBangSuccess(args)
	self:Bar(364114, 30.2, CL.count:format(self:SpellName(364114), shatterSphereCount)) -- Shatter Sphere
end

function mod:GravitationalCollapse(args)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "warning")
end

function mod:RadiantPlasma(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end

function mod:TheSingularityApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green")
		self:PlaySound(args.spellId, "info")
	end
end

function mod:ShatterSphere(args)
	self:SetStage(self:GetStage()+1)
	self:StopBar(CL.count:format(args.spellName, shatterSphereCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, shatterSphereCount))
	self:PlaySound(args.spellId, "alert")
	shatterSphereCount = shatterSphereCount + 1

	celestialCollapseCount = 1
	darkEclipseCount = 1
	manifestCosmosCount = 1
	stellarShroudCount = 1

	self:Bar(362806, 10.9, CL.count:format(self:SpellName(362806), darkEclipseCount)) -- Dark Eclipse
	self:Bar(362275, self:Mythic() and 14.6 or 13.4, CL.count:format(L.celestial_collapse, celestialCollapseCount)) -- Celestial Collapse
	self:Bar(362390, self:Mythic() and 25.5 or 21.1, CL.count:format(L.manifest_cosmos, manifestCosmosCount)) -- Manifest Cosmos
	self:Bar(363533, self:Mythic() and 70.6 or 65.5, CL.count:format(self:SpellName(363533), massiveBangCount)) -- Massive Bang

	if self:Mythic() then
		self:Bar(366379, 13.4, CL.count:format(L.stellar_shroud, stellarShroudCount)) -- Stellar Shroud
	end
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
		if amount == 3 or amount > 4 then -- 3, 5, 6
			self:NewStackMessage(args.spellId, "blue", args.destName, args.amount)
			self:PlaySound(args.spellId, "alarm")
		end
		if amount > 2 then -- Yell: stack amount, extra emphasize on 6
			self:Yell(args.spellId, amount == 6 and "{rt8} 6 {rt8}" or amount, true)
		end
	end
end

function mod:StellarShroud(args)
	self:StopBar(CL.count:format(L.stellar_shroud, stellarShroudCount))
	self:Message(args.spellId, "orange", CL.count:format(L.stellar_shroud, stellarShroudCount))
	self:PlaySound(args.spellId, "alert")
	stellarShroudCount = stellarShroudCount + 1
	if stellarShroudCount < 5 then -- 4 before a Massive Bang
		self:Bar(args.spellId, stellarShroudCount == 3 and 14.6 or 17, CL.count:format(L.stellar_shroud, stellarShroudCount))
	end
end

do
	local scheduled, destName, stacks = nil, nil, 0
	function mod:DarkQuasarStackMessage()
		mod:NewStackMessage(368080, "yellow", destName, stacks)
		mod:PlaySound(368080, "alert")
		scheduled = nil
	end

	function mod:DarkQuasarApplied(args)
		stacks = args.amount or 1
		destName = args.destName
		if not scheduled then -- Delay message to only warn for highest stack
			scheduled = self:ScheduleTimer("DarkQuasarStackMessage", 0.1, args.destName)
		end
	end

	function mod:DarkQuasarRemoved(args)
		self:Message(args.spellId, "green", CL.over:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

function mod:DarkQuasarPlayerApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(368080)
		self:PlaySound(368080, "warning")
		self:SayCountdown(368080, 3, nil, 2)
	end
end

function mod:DarkQuasarPlayerRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(368080)
	end
end
