--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Forgotten Experiments", 2569, 2530)
if not mod then return end
mod:RegisterEnableMob(200912, 200913, 200918) -- Neldris, Thadrion, Rionthus
mod:SetEncounterID(2693)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local pullTime = 0
local lastCast = {}
local thadrionEngaged = false
local rionthusEngaged = false
local killedCount = 0

local rendingChargeCount = 1
local massiveSlamCount = 1
local bellowingRoarCount = 1

local unstableEssenceCount = 1
local essenceMarksUsed = {}
local volatileSpewCount = 1
local violentEruptionCount = 1

local deepBreathCount = 1
local temporalAnomalyCount = 1
local disintergrateCount = 1

-- mythic timers are static for all three bosses, these cover 10min
local timersMythic = {
	-- Thadrion
	[405492] = { 14, 34, 69, 89, 124, 144, 179, 199, 234, 254, 289, 309, 344, 364, 399, 419, 454, 474, 509, 529, 564, 584 }, -- Volatile Spew
	[407327] = { 3, 24, 58, 79, 113, 134, 168, 189, 223, 244, 278, 299, 333, 354, 388, 409, 443, 464, 498, 519, 553, 574 }, -- Unstable Essence
	[405375] = { 45, 100, 155, 210, 265, 320, 375, 430, 485, 540, 595 }, -- Volatile Eruption
	-- Rionthus
	[405392] = { 5, 60, 115, 170, 225, 280, 335, 390, 445, 500, 555 }, -- Disintegrate
	[407552] = { 50, 105, 160, 215, 270, 325, 380, 435, 490, 545, 600 }, -- Temporal Anomaly
	[406227] = { 31, 86, 141, 196, 251, 306, 361, 416, 471, 526, 581 }, -- Deep Breath
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_unstable_essence_high = "High Stacks Unstable Essence Say Messages"
	L.custom_on_unstable_essence_high_icon = 407327
	L.custom_on_unstable_essence_high_desc = "Say messages with the amount of stacks for your Unstable Essence debuff when they are high enough."

	L.rending_charge_single = "First Charge"
	L.unstable_essence_new = "New Bomb"
	L.volatile_spew = "Dodges"
	L.volatile_eruption = "Eruption"
	L.temporal_anomaly_knocked = "Heal Orb Knocked"
end

--------------------------------------------------------------------------------
-- Initialization
--

local unstableEssenceMarker = mod:AddMarkerOption(true, "player", 1, 407327, 1, 2, 3, 4, 5, 6, 7, 8) -- Unstable Essence
function mod:GetOptions()
	return {
		-- General
		"stages",
		{406311, "TANK"}, -- Infused Strikes
		407302, -- Infused Explosion
		-- Neldris
		{406358, "ICON", "SAY", "SAY_COUNTDOWN", "PRIVATE", "ME_ONLY_EMPHASIZE"}, -- Rending Charge
		404472, -- Massive Slam
		404713, -- Bellowing Roar
		-- Thadrion
		{407327, "ME_ONLY_EMPHASIZE"}, -- Unstable Essence
		"custom_on_unstable_essence_high",
		unstableEssenceMarker,
		405492, -- Volatile Spew
		405375, -- Violent Eruption
		-- Rionthus
		406227, -- Deep Breath
		407552, -- Temporal Anomaly
		{405392, "SAY", "ME_ONLY_EMPHASIZE"}, -- Disintegrate
	}, {
		[406358] = -26316, -- Neldris
		[407327] = -26322, -- Thadrion
		[406227] = -26329, -- Rionthus
	},{
		[404472] = CL.frontal_cone, -- Massive Slam (Frontal Cone)
		[404713] = CL.roar, -- Bellowing Roar (Roar)
		[407327] = L.unstable_essence_new, -- Unstable Essence (New Bomb)
		[405492] = L.volatile_spew, -- Volatile Spew (Dodges)
		[405375] = L.volatile_eruption, -- Violent Eruption (Raid Damage)
		[407552] = CL.orb, -- Temporal Anomaly (Orb)
	}
end

function mod:OnBossEnable()
	-- General
	self:Death("Deaths", 200912, 200913, 200918)

	self:Log("SPELL_AURA_APPLIED", "InfusedStrikesApplied", 406311)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfusedStrikesApplied", 406311)
	self:Log("SPELL_AURA_APPLIED", "InfusedExplosionApplied", 407302)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfusedExplosionApplied", 407302)

	-- Neldris
	self:Log("SPELL_CAST_START", "RendingCharge", 406358)
	self:Log("SPELL_CAST_SUCCESS", "RendingChargeSuccess", 406358)
	self:Log("SPELL_CAST_START", "MassiveSlam", 404472, 407733, 412117) -- Multiple Id's used, unkown why
	self:Log("SPELL_CAST_START", "BellowingRoar", 404713)

	-- Thadrion
	self:Log("SPELL_CAST_START", "UnstableEssence", 405042)
	self:Log("SPELL_AURA_APPLIED", "UnstableEssenceApplied", 407327)
	self:Log("SPELL_AURA_APPLIED_DOSE", "UnstableEssenceAppliedStacks", 407327)
	self:Log("SPELL_AURA_REMOVED", "UnstableEssenceRemoved", 407327)
	self:Log("SPELL_CAST_START", "VolatileSpew", 405492)
	self:Log("SPELL_CAST_START", "ViolentEruption", 405375, 407775)

	-- Rionthus
	self:Log("SPELL_CAST_START", "DeepBreath", 406227)
	self:Log("SPELL_CAST_START", "TemporalAnomaly", 407552)
	self:Log("SPELL_DAMAGE", "TemporalAnomalyKnocked", 410608)
	self:Log("SPELL_CAST_START", "Disintegrate", 405391)
	self:Log("SPELL_AURA_APPLIED", "DisintegrateApplied", 405392)
end

function mod:OnEngage()
	lastCast = {}
	thadrionEngaged = false
	rionthusEngaged = false
	killedCount = 0

	rendingChargeCount = 1
	massiveSlamCount = 1
	bellowingRoarCount = 1

	unstableEssenceCount = 1
	essenceMarksUsed = {}
	volatileSpewCount = 1
	violentEruptionCount = 1

	deepBreathCount = 1
	temporalAnomalyCount = 1
	disintergrateCount = 1
	pullTime = GetTime()
	self:SetStage(1)
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")

	self:Bar(404713, self:Mythic() and 6 or 11, CL.count:format(CL.roar, bellowingRoarCount)) -- Bellowing Roar
	self:Bar(406358, self:Mythic() and 14 or 19, CL.count:format(self:SpellName(406358), rendingChargeCount)) -- Rending Charge
	self:Bar(404472, self:Mythic() and 24 or 35, CL.count:format(CL.frontal_cone, massiveSlamCount)) -- Massive Slam

	self:SetPrivateAuraSound(406358, 406317) -- Rending Charge
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function getCastCD(key)
	local t = GetTime()
	local duration = t - pullTime

	-- find the next cast based on the combat time
	local index = 1
	while timersMythic[key][index] < duration do
		index = index + 1
		if not timersMythic[key][index] then
			return 0 -- you went over 10min? o.O
		end
	end
	-- set the last cast using the previous index for pairs of cds
	if index > 1 then
		local prev = duration - timersMythic[key][index - 1]
		if prev > 0 then
			lastCast[key] = t - prev
		end
	end
	-- return the time remaining for the next cast
	return timersMythic[key][index] - duration
end

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	if not thadrionEngaged then
		if self:GetBossId(200913) then -- Thadrion
			thadrionEngaged = true
			self:Message("stages", "cyan", -26322, false)
			self:PlaySound("stages", "long")
			self:SetStage(2)

			self:CDBar(405492, self:Mythic() and getCastCD(405492) or 6, CL.count:format(L.volatile_spew, volatileSpewCount)) -- Volatile Spew
			self:CDBar(407327, self:Mythic() and getCastCD(407327) or 17.3, CL.count:format(L.unstable_essence_new, unstableEssenceCount)) -- Unstable Essence
			self:CDBar(405375, self:Mythic() and getCastCD(405375) or 40, CL.count:format(L.volatile_eruption, violentEruptionCount)) -- Violent Eruption
		end
	elseif not rionthusEngaged then
		if self:GetBossId(200918) then -- Rionthus
			rionthusEngaged = true
			self:Message("stages", "cyan", -26329, false)
			self:PlaySound("stages", "long")
			self:SetStage(3)

			self:CDBar(405392, self:Mythic() and getCastCD(405392) or 6.4, CL.count:format(self:SpellName(405392), disintergrateCount)) -- Disintegrate
			self:CDBar(407552, self:Mythic() and getCastCD(407552) or 17.5, CL.count:format(CL.orb, temporalAnomalyCount)) -- Temporal Anomaly
			self:CDBar(406227, self:Mythic() and getCastCD(406227) or 33.1, CL.count:format(self:SpellName(406227), deepBreathCount)) -- Deep Breath
		end
	end
end

function mod:Deaths(args)
	killedCount = killedCount + 1
	if killedCount < 3 then
		self:Message("stages", "green", CL.mob_killed:format(args.destName, killedCount, 3), false)
	end
	if args.mobId == 200912 then -- Neldris
		self:StopBar(CL.count:format(self:SpellName(406358), rendingChargeCount)) -- Rending Charge
		self:StopBar(CL.count:format(CL.frontal_cone, massiveSlamCount)) -- Massive Slam
		self:StopBar(CL.count:format(CL.roar, bellowingRoarCount)) -- Bellowing Roar
	elseif args.mobId == 200913 then -- Thadrion
		self:StopBar(CL.count:format(L.unstable_essence_new, unstableEssenceCount)) -- Unstable Essence
		self:StopBar(CL.count:format(L.volatile_spew, volatileSpewCount)) -- Volatile Spew
		self:StopBar(CL.count:format(L.volatile_eruption, violentEruptionCount)) -- Violent Eruption
	elseif args.mobId == 200918 then -- Rionthus
		self:StopBar(CL.count:format(self:SpellName(406227), deepBreathCount)) -- Deep Breath
		self:StopBar(CL.count:format(CL.orb, temporalAnomalyCount)) -- Temporal Anomaly
		self:StopBar(CL.count:format(self:SpellName(405392), disintergrateCount)) -- Disintegrate
	end
end

-- General
function mod:InfusedStrikesApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 3 or amount > 15 then
			self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
			if amount > 15 then -- Reset Maybe?
				self:PlaySound(args.spellId, "warning")
			else
				self:PlaySound(args.spellId, "info")
			end
		end
	end
end

function mod:InfusedExplosionApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
		if amount > 1 then -- Tank Oops
			self:PlaySound(args.spellId, "warning")
		else
			self:PlaySound(args.spellId, "info")
		end
	end
end

-- Neldris
do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:PersonalMessage(406358, nil, L.rending_charge_single)
			--self:PlaySound(406358, "warning") -- The private aura sound should play
			self:Say(406358, L.rending_charge_single, nil, "First Charge")
			self:SayCountdown(406358, 5)
		end
		self:PrimaryIcon(406358, player)
	end

	function mod:RendingCharge(args)
		local msg = CL.count:format(args.spellName, rendingChargeCount)
		self:StopBar(msg)
		self:Message(args.spellId, "red", msg)
		self:PlaySound(args.spellId, "alert")
		rendingChargeCount = rendingChargeCount + 1
		local cd = rendingChargeCount % 2 == 1 and 38 or 35
		if self:Mythic() then
			cd = rendingChargeCount % 2 == 1 and 18 or 37
		end
		self:Bar(args.spellId, cd, CL.count:format(args.spellName, rendingChargeCount))
		self:GetBossTarget(printTarget, 1, args.sourceGUID) -- 1st target is from boss
	end
end

function mod:RendingChargeSuccess(args)
	self:PrimaryIcon(args.spellId)
end

function mod:MassiveSlam()
	local msg = CL.count:format(CL.frontal_cone, massiveSlamCount)
	self:StopBar(msg)
	self:Message(404472, "yellow", msg)
	self:PlaySound(404472, "alert")
	massiveSlamCount = massiveSlamCount + 1
	local cd = massiveSlamCount % 2 == 0 and 9.7 or 38.8
	if self:Mythic() then
		cd = massiveSlamCount % 2 == 0 and 18.0 or 37.0
	end
	self:Bar(404472, cd, CL.count:format(CL.frontal_cone, massiveSlamCount))
end

function mod:BellowingRoar(args)
	local msg = CL.count:format(CL.roar, bellowingRoarCount)
	self:StopBar(msg)
	self:Message(args.spellId, "orange", msg)
	self:PlaySound(args.spellId, "alarm")
	bellowingRoarCount = bellowingRoarCount + 1
	local cd = bellowingRoarCount == 2 and 57.5 or 38.9 -- 10.7, 57.5, 38.9 wtb 4rd cast
	if self:Mythic() then
		cd = bellowingRoarCount % 2 == 0 and 30 or 25
	end
	self:Bar(args.spellId, cd, CL.count:format(CL.roar, bellowingRoarCount))
end

-- Thadrion
function mod:UnstableEssence()
	local msg = CL.count:format(L.unstable_essence_new, unstableEssenceCount)
	self:StopBar(msg)
	self:Message(407327, "cyan", CL.casting:format(msg))
	unstableEssenceCount = unstableEssenceCount + 1

	local t = GetTime()
	local timeSinceLast = t - (lastCast[407327] or 0)
	lastCast[407327] = t

	self:Bar(407327, self:Mythic() and (timeSinceLast > 25 and 21 or 34) or (timeSinceLast > 32 and 28 or 39), CL.count:format(L.unstable_essence_new, unstableEssenceCount))
end

function mod:UnstableEssenceApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.bomb)
		self:PlaySound(args.spellId, "alarm")
	end
	for i = 1, 8, 1 do -- Good luck to anyone with 8 bombs
		if not essenceMarksUsed[i] then
			essenceMarksUsed[i] = args.destGUID
			self:CustomIcon(unstableEssenceMarker, args.destName, i)
			return
		end
	end
end

function mod:UnstableEssenceAppliedStacks(args)
	if self:Me(args.destGUID) and self:GetOption("custom_on_unstable_essence_high") and args.amount > 10 then -- Say messages above 10
		local icon = self:GetIcon(args.destRaidFlags)
		local sayText = args.amount
		if icon then
			sayText = "{rt"..icon.."} "..args.amount.." {rt"..icon.."}"
		end
		self:Say(false, sayText, true)
	end
end

function mod:UnstableEssenceRemoved(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, false, CL.removed:format(CL.bomb))
		self:PlaySound(args.spellId, "alarm")
	end
	self:CustomIcon(unstableEssenceMarker, args.destName)
	for i = 1, 3, 1 do -- 1, 2, 3
		if essenceMarksUsed[i] == args.destGUID then
			essenceMarksUsed[i] = nil
			return
		end
	end
end

function mod:VolatileSpew(args)
	local msg = CL.count:format(L.volatile_spew, volatileSpewCount)
	self:StopBar(msg)
	self:Message(args.spellId, "orange", msg)
	self:PlaySound(args.spellId, "alarm")
	volatileSpewCount = volatileSpewCount + 1

	local t = GetTime()
	local timeSinceLast = t - (lastCast[405492] or 0)
	lastCast[405492] = t

	local cd = volatileSpewCount == 2 and 22 or volatileSpewCount % 2 == 0 and 30 or 37 -- heroic: 15.2, 21.8, 37.6, 30.4, 37.6
	if self:Mythic() then
		cd = timeSinceLast > 22 and 20 or 35
	end
	self:CDBar(args.spellId, cd, CL.count:format(L.volatile_spew, volatileSpewCount))
end

function mod:ViolentEruption()
	local msg = CL.count:format(L.volatile_eruption, violentEruptionCount)
	self:StopBar(msg)
	self:Message(405375, "yellow", msg)
	self:PlaySound(405375, "long")
	violentEruptionCount = violentEruptionCount + 1
	self:Bar(405375, self:Mythic() and 55 or 69.3, CL.count:format(L.volatile_eruption, violentEruptionCount))
end

-- Rionthus
function mod:DeepBreath(args)
	local msg = CL.count:format(args.spellName, deepBreathCount)
	self:StopBar(msg)
	self:Message(args.spellId, "red", msg)
	self:PlaySound(args.spellId, "alert")
	deepBreathCount = deepBreathCount + 1
	self:Bar(args.spellId, self:Mythic() and 55 or 43, CL.count:format(args.spellName, deepBreathCount))
end

function mod:TemporalAnomaly(args)
	local msg = CL.count:format(CL.orb, temporalAnomalyCount)
	self:StopBar(msg)
	self:Message(args.spellId, "yellow", msg)
	self:PlaySound(args.spellId, "info")
	temporalAnomalyCount = temporalAnomalyCount + 1
	self:Bar(args.spellId, self:Mythic() and 55 or (temporalAnomalyCount == 2 and 46.3 or 43.8), CL.count:format(CL.orb, temporalAnomalyCount))
end

function mod:TemporalAnomalyKnocked(args)
	if self:Me(args.destGUID) then
		self:Message(407552, "blue", L.temporal_anomaly_knocked)
		self:PlaySound(407552, "underyou") -- You touched it
	end
end

function mod:Disintegrate(args)
	local msg = CL.count:format(args.spellName, disintergrateCount)
	self:StopBar(msg)
	self:Message(405392, "orange", msg)
	disintergrateCount = disintergrateCount + 1
	self:Bar(405392, self:Mythic() and 55 or 44, CL.count:format(args.spellName, disintergrateCount))
end

function mod:DisintegrateApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId, nil, nil, "Disintegrate")
	end
end
