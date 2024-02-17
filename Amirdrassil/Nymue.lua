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
local impendingLoomCount = 1
local surgingGrowthCount = 1
local ephemeralFloraCount = 1
local fullBloomCount = 1
local radialFlourishCount = 1
local inflorescenceOnMe = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.mythic_add_death = "%s Killed"

	L.continuum = "New Lines"
	L.surging_growth = "New Soaks"
	L.ephemeral_flora = "Red Soak"
	L.viridian_rain = "Damage + Bombs"
	L.threads = "Threads" -- From the spell description of Impending Loom (429615) "threads of energy"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		420554, -- Verdant Matrix
		-- Stage One: Rapid Iteration
		420846, -- Continuum
		429615, -- Impending Loom
		429983, -- Surging Growth
		{426519, "TANK", "SAY", "ME_ONLY_EMPHASIZE", "PRIVATE"}, -- Weaver's Burden
		-- Mythic
		430563, -- Ephemeral Flora
		420907, -- Viridian Rain
		-- Stage Two: Creation Complete
		426855, -- Full Bloom (Stage 2)
		413443, -- Life Ward
		429108, -- Lumbering Slam
		422721, -- Radial Flourish
		429798, -- Verdent Rend
		-- Mythic
		-28482, -- Manifested Dream
		428471, -- Waking Decimation
	},{
		[420554] = "general",
		[420846] = -28355, -- Stage One: Rapid Iteration
		[430563] = "mythic",
		[426855] = -28356, -- Stage Two: Creation Complete
		[413443] = -27432, -- Cycle Warden
		[-28482] = "mythic", -- Manifested Dream (Mythic)
	},{
		[420846] = L.continuum, -- Continuum (New Lines)
		[429615] = L.threads, -- Impending Loom (Threads)
		[420907] = L.viridian_rain, -- Viridian Rain (Raid Damage)
		[430563] = L.ephemeral_flora, -- Ephmeral Flora (Red Soak)
		[426519] = CL.bombs, -- Weaver's Burden (Bombs)
		[426855] = CL.stage:format(2), -- Full Bloom (Stage 2)
		[429108] = CL.frontal_cone, -- Lumbering Slam (Frontal Cone)
	}
end

function mod:OnBossEnable()
	-- Stage One: Rapid Iteration
	self:Log("SPELL_CAST_SUCCESS", "WeaversBurden", 426519)

	self:Log("SPELL_AURA_APPLIED", "VerdantMatrixApplied", 420554)
	self:Log("SPELL_AURA_APPLIED_DOSE", "VerdantMatrixApplied", 420554)
	self:Log("SPELL_CAST_START", "Continuum", 420846)
	self:Log("SPELL_CAST_START", "ImpendingLoom", 429615)
	self:Log("SPELL_CAST_SUCCESS", "ViridianRain", 420907)
	self:Log("SPELL_AURA_APPLIED", "InflorescenceApplied", 423195)
	self:Log("SPELL_AURA_REMOVED", "InflorescenceRemoved", 423195)

	-- Stage Two: Creation Complete
	self:Log("SPELL_CAST_START", "FullBloom", 426855)
	self:Log("SPELL_AURA_APPLIED", "LifeWardApplied", 413443)
	self:Log("SPELL_AURA_REMOVED_DOSE", "LifeWardRemoved", 413443)
	self:Log("SPELL_CAST_START", "LumberingSlam", 429108)
	self:Log("SPELL_CAST_SUCCESS", "RadialFlourish", 422721)
	self:Log("SPELL_AURA_APPLIED", "VerdantRendApplied", 429798)
	self:Log("SPELL_CAST_START", "WakingDecimation", 428471)
end

function mod:OnEngage()
	viridianRainCount = 1
	continuumCount = 1
	impendingLoomCount = 1
	ephemeralFloraCount = 1
	fullBloomCount = 1
	radialFlourishCount = 1
	inflorescenceOnMe = false
	self:SetStage(1)

	self:Bar(429983, 11.2, L.surging_growth) -- Surging Growth
	self:Bar(420907, 20, CL.count:format(L.viridian_rain, viridianRainCount)) -- Viridian Rain
	self:Bar(429615, 24.0, CL.count:format(L.threads, impendingLoomCount)) -- Impending Loom
	self:CDBar(426855, 70.4, CL.stage:format(2)) -- Full Bloom
	if self:Mythic() then
		self:Bar(430563, 29, CL.count:format(L.ephemeral_flora, ephemeralFloraCount)) -- Ephemeral Flora
		self:ScheduleTimer("EphemeralFlora", 29)
	end

	self:SetPrivateAuraSound(426519, 427722) -- Weaver's Burden
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: Rapid Iteration
function mod:WeaversBurden(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.bomb)
		self:Say(args.spellId, CL.bomb, nil, "Bomb")
		--self:PlaySound(args.spellId, "warning") -- Handled by the private aura sound
	else
		self:TargetMessage(args.spellId, "purple", args.destName, CL.bomb)
		self:PlaySound(args.spellId, "warning")
	end
end

function mod:VerdantMatrixApplied(args)
	if self:Me(args.destGUID) and not inflorescenceOnMe then -- Don't warn when you should be crossing
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, amount, 3)
		self:PlaySound(args.spellId, "underyou")
		if amount > 2 then
			self:PlaySound(args.spellId, "underyou")
		end
	end
end

function mod:Continuum(args)
	self:Message(args.spellId, "cyan", CL.count:format(L.continuum, continuumCount))
	self:PlaySound(args.spellId, "info")
	continuumCount = continuumCount + 1

	self:StopBar(CL.frontal_cone) -- Lumbering Slam
	self:StopBar(422721) -- Radial Flourish

	self:SetStage(1)
	impendingLoomCount = 1
	viridianRainCount = 1
	ephemeralFloraCount = 1

	self:Bar(429983, 28.4, L.surging_growth) -- Surging Growth
	self:Bar(420907, 36.6, CL.count:format(L.viridian_rain, viridianRainCount)) -- Viridian Rain
	self:Bar(429615, 41.5, CL.count:format(L.threads, impendingLoomCount)) -- Impending Loom
	self:CDBar(426855, 87.5, CL.stage:format(2)) -- Full Bloom
	if self:Mythic() then
		self:Bar(430563, 46, CL.count:format(L.ephemeral_flora, ephemeralFloraCount)) -- Ephemeral Flora
		self:ScheduleTimer("EphemeralFlora", 46)
	end
end

function mod:ImpendingLoom(args)
	self:StopBar(CL.count:format(L.threads, impendingLoomCount))
	self:Message(args.spellId, "cyan", CL.soon:format(CL.count:format(L.threads, impendingLoomCount)))
	self:PlaySound(args.spellId, "info")
	impendingLoomCount = impendingLoomCount + 1
	if impendingLoomCount < 3 then
		self:Bar(args.spellId, 24, CL.count:format(L.threads, impendingLoomCount))
	end
end

function mod:EphemeralFlora()
	self:StopBar(CL.count:format(L.ephemeral_flora, ephemeralFloraCount))
	self:Message(430563, "red", CL.count:format(L.ephemeral_flora, ephemeralFloraCount))
	self:PlaySound(430563, "alert")
	ephemeralFloraCount = ephemeralFloraCount + 1
	if ephemeralFloraCount < 3 then -- 2 per
		self:Bar(430563, 26.5, CL.count:format(L.ephemeral_flora, ephemeralFloraCount))
		self:ScheduleTimer("EphemeralFlora", 26.5)
	end
end

function mod:ViridianRain(args)
	self:StopBar(CL.count:format(L.viridian_rain, viridianRainCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.viridian_rain, viridianRainCount))
	self:PlaySound(args.spellId, "alarm")
	viridianRainCount = viridianRainCount + 1
	if viridianRainCount < 4 then
		self:Bar(args.spellId, 20, CL.count:format(L.viridian_rain, viridianRainCount))
	end
end

function mod:InflorescenceApplied(args)
	if self:Me(args.destGUID) then
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
	self:StopBar(CL.stage:format(2)) -- Full Bloom
	self:StopBar(CL.count:format(L.viridian_rain, viridianRainCount)) -- Viridian Rain
	self:StopBar(CL.count:format(L.threads, impendingLoomCount)) -- Impending Loom

	self:Message(args.spellId, "green", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "long")
	fullBloomCount = fullBloomCount + 1
	self:SetStage(2)

	radialFlourishCount = 1

	self:Bar(413443, 6.9) -- Life Ward
	self:Bar(422721, 12.6) -- Radial Flourish
	self:Bar(429108, 19, CL.frontal_cone) -- Lumbering Slam
	if self:Mythic() then
		-- self:Bar(-28482, 4.0, nil, "ability_xavius_dreamsimulacrum") -- Manifested Dream
		self:Bar(428471, 35.2) -- Waking Decimation
	end
end

function mod:LifeWardApplied(args)
	self:Message(args.spellId, "yellow", CL.onboss:format(args.spellName))
	self:PlaySound(args.spellId, "info")
end

function mod:LifeWardRemoved(args)
	local total = 2
	self:Message(args.spellId, "green", ("%s (%d/%d)"):format(CL.removed:format(args.spellName), total - args.amount, total))
	self:PlaySound(args.spellId, "info")
end

function mod:MythicAddDeath(args)
	self:Message(-28482, "green", L.mythic_add_death:format(args.destName), "ability_xavius_dreamsimulacrum")
	self:PlaySound(-28482, "info")
	self:StopBar(428471) -- Waking Decimation
end

function mod:LumberingSlam(args)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if not unit or self:UnitWithinRange(unit, 45) then
		self:Message(args.spellId, "orange", CL.frontal_cone)
		self:PlaySound(args.spellId, "alert")
		self:Bar(args.spellId, 19.5, CL.frontal_cone) -- 19~20
	end
end

function mod:RadialFlourish(args)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if not unit or self:UnitWithinRange(unit, 45) then
		self:Message(args.spellId, "yellow")
		self:PlaySound(args.spellId, "alarm")
		radialFlourishCount = radialFlourishCount + 1
		self:Bar(args.spellId, 6) -- 2 casts in ~12.8, can skip one, annoying queueing with slam
	end
end

function mod:VerdantRendApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "red")
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:WakingDecimation(args)
	self:StopBar(args.spellName)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alarm") -- death
end
