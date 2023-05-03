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

local thadrionEngaged = false
local rionthusEngaged = false

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

local timers = {
	[407327] = {18, 52.4, 29.2, 31.6, 29.2, 34.0}, -- Unstable Essence
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.rending_charge_single = "1st Charge"
	L.massive_slam = "Frontal Cone"
	L.unstable_essence_new = "New Bomb"
	L.custom_on_unstable_essence_high = "High Stacks Unstable Essence Say Messages"
	L.custom_on_unstable_essence_high_icon = 407327
	L.custom_on_unstable_essence_high_desc = "Say messages with the amount of stacks for your Unstable Essence debuff when they are high enough."
	L.volatile_spew = "Dodges"
	L.volatile_eruption = "Eruption"
	L.temporal_anomaly = "Heal Orb"
	L.temporal_anomaly_knocked = "Heal Orb Knocked!"
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
		{406358, "ICON", "SAY", "SAY_COUNTDOWN"}, -- Rending Charge
		404472, -- Massive Slam
		404713, -- Bellowing Roar
		-- Thadrion
		{407327, "SAY"}, -- Unstable Essence
		"custom_on_unstable_essence_high",
		unstableEssenceMarker,
		405492, -- Volatile Spew
		405375, -- Violent Eruption
		-- Rionthus
		406227, -- Deep Breath
		407552, -- Temporal Anomaly
		{405392, "SAY"}, -- Disintegrate
	}, {
		[406358] = -26316, -- Neldris
		[407327] = -26322, -- Thadrion
		[406227] = -26329, -- Rionthus
	},{
		[404472] = L.massive_slam, -- Massive Slam (Frontal Cone)
		[404713] = CL.roar, -- Bellowing Roar (Roar)
		[407327] = L.unstable_essence_new, -- Unstable Essence (New Bomb)
		[405492] = L.volatile_spew, -- Volatile Spew (Dodges)
		[405375] = L.volatile_eruption, -- Violent Eruption (Raid Damage)
		[407552] = L.temporal_anomaly, -- Temporal Anomaly (Heal Orb)
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
	self:Log("SPELL_CAST_START", "MassiveSlam", 404472, 407733) -- Does the second Id have a different effect?
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
	self:SetStage(1)
	thadrionEngaged = false
	rionthusEngaged = false
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")

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

	self:Bar(404713, self:Mythic() and 36 or 5, CL.count:format(CL.roar, bellowingRoarCount)) -- Bellowing Roar
	self:Bar(406358, self:Mythic() and 14 or 14.5, CL.count:format(self:SpellName(406358), rendingChargeCount)) -- Rending Charge
	self:Bar(404472, self:Mythic() and 6 or 30, CL.count:format(L.massive_slam, massiveSlamCount)) -- Massive Slam
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	-- XXX better event? initial timers have quite a bit of variance
	if not thadrionEngaged then
		if self:GetBossId(200913) then -- Thadrion
			thadrionEngaged = true
			self:Message("stages", "cyan", -26322, false)
			self:PlaySound("stages", "long")

			self:CDBar(405492, 5, CL.count:format(L.volatile_spew, volatileSpewCount)) -- Volatile Spew
			self:CDBar(407327, 18, CL.count:format(L.unstable_essence_new, unstableEssenceCount)) -- Unstable Essence
			self:CDBar(405375, 46, CL.count:format(L.volatile_eruption, violentEruptionCount)) -- Violent Eruption
		end
	elseif not rionthusEngaged then
		if self:GetBossId(200918) then -- Rionthus
			rionthusEngaged = true
			self:Message("stages", "cyan", -26329, false)
			self:PlaySound("stages", "long")

			self:CDBar(405392, 7.8, CL.count:format(self:SpellName(405392), disintergrateCount)) -- Disintegrate
			self:CDBar(407552, 18.0, CL.count:format(L.temporal_anomaly, temporalAnomalyCount)) -- Temporal Anomaly
			self:CDBar(406227, 33.8, CL.count:format(self:SpellName(406227), deepBreathCount)) -- Deep Breath
		end
	end
end

function mod:Deaths(args)
	if args.mobId == 200912 then -- Neldris
		self:StopBar(CL.count:format(self:SpellName(406358), rendingChargeCount)) -- Rending Charge
		self:StopBar(CL.count:format(L.massive_slam, massiveSlamCount)) -- Massive Slam
		self:StopBar(CL.count:format(CL.roar, bellowingRoarCount)) -- Bellowing Roar
	elseif args.mobId == 200913 then -- Thadrion
		self:StopBar(CL.count:format(L.unstable_essence_new, unstableEssenceCount)) -- Unstable Essence
		self:StopBar(CL.count:format(L.volatile_spew, volatileSpewCount)) -- Volatile Spew
		self:StopBar(CL.count:format(L.volatile_eruption, violentEruptionCount)) -- Violent Eruption
	elseif args.mobId == 200918 then -- Rionthus
		self:StopBar(CL.count:format(self:SpellName(406227), deepBreathCount)) -- Deep Breath
		self:StopBar(CL.count:format(L.temporal_anomaly, temporalAnomalyCount)) -- Temporal Anomaly
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
			self:PlaySound(406358, "warning")
			self:Say(406358, L.rending_charge_single)
			self:SayCountdown(406358, 5)
		end
		self:PrimaryIcon(406358, player)
	end

	function mod:RendingCharge(args)
		self:StopBar(CL.count:format(args.spellId, rendingChargeCount))
		self:Message(406358, "red", CL.count:format(args.spellId, rendingChargeCount))
		self:PlaySound(406358, "alert")
		rendingChargeCount = rendingChargeCount + 1
		self:Bar(args.spellId, self:Mythic() and (rendingChargeCount % 2 == 1 and 18 or 37) or (rendingChargeCount == 2 and 34 or 45), CL.count:format(args.spellId, rendingChargeCount))
		self:GetBossTarget(printTarget, 1, args.sourceGUID) -- 1st target is from boss
	end
end

function mod:RendingChargeSuccess(args)
	self:PrimaryIcon(406358)
end

function mod:MassiveSlam(args)
	self:StopBar(CL.count:format(L.massive_slam, massiveSlamCount))
	self:Message(404472, "yellow", CL.count:format(L.massive_slam, massiveSlamCount))
	self:PlaySound(404472, "alert")
	massiveSlamCount = massiveSlamCount + 1
	self:Bar(404472, self:Mythic() and 18.0 or (massiveSlamCount == 2 and 49.3 or 46.2), CL.count:format(L.massive_slam, massiveSlamCount))
end

function mod:BellowingRoar(args)
	self:StopBar(CL.count:format(CL.roar, bellowingRoarCount))
	self:Message(args.spellId, "orange", CL.count:format(CL.roar, bellowingRoarCount))
	self:PlaySound(args.spellId, "alarm")
	bellowingRoarCount = bellowingRoarCount + 1
	self:Bar(args.spellId, self:Mythic() and 55 or (bellowingRoarCount == 2 and 35.5 or 23.1), CL.count:format(CL.roar, bellowingRoarCount))
end

-- Thadrion
do
	local prev = 0
	function mod:UnstableEssence(args)
		self:StopBar(CL.count:format(L.unstable_essence_new, unstableEssenceCount))
		self:Message(407327, "cyan", CL.casting:format(L.unstable_essence_new))
		unstableEssenceCount = unstableEssenceCount + 1
		local timeSinceLast = args.time - prev
		prev = args.time
		self:Bar(407327, self:Mythic() and (timeSinceLast > 25 and 21 or 34) or timers[407327][unstableEssenceCount], CL.count:format(L.unstable_essence_new, unstableEssenceCount))
	end
end

function mod:UnstableEssenceApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.bomb)
		self:PlaySound(args.spellId, "alarm")
		self:Say(args.spellId, CL.bomb)
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
		local icon = GetRaidTargetIndex("player")
		local sayText = args.amount
		if icon then
			sayText = "{rt"..icon.."} "..args.amount.." {rt"..icon.."}"
		end
		self:Say(args.spellId, sayText, true)
	end
end

function mod:UnstableEssenceRemoved(args)
	self:CustomIcon(unstableEssenceMarker, args.destName)
	for i = 1, 3, 1 do -- 1, 2, 3
		if essenceMarksUsed[i] == args.destGUID then
			essenceMarksUsed[i] = nil
			return
		end
	end
end

do
	local prev = 0
	function mod:VolatileSpew(args)
		self:StopBar(CL.count:format(L.volatile_spew, volatileSpewCount))
		self:Message(args.spellId, "orange", CL.count:format(L.volatile_spew, volatileSpewCount))
		self:PlaySound(args.spellId, "alarm")
		volatileSpewCount = volatileSpewCount + 1
		local timeSinceLast = args.time - prev
		prev = args.time
		self:CDBar(args.spellId, self:Mythic() and (timeSinceLast > 22 and 20 or 35) or (volatileSpewCount % 2 == 0 and 26 or 30), CL.count:format(L.volatile_spew, volatileSpewCount))
	end
end

function mod:ViolentEruption(args)
	self:StopBar(CL.count:format(L.volatile_eruption, violentEruptionCount))
	self:Message(405375, "yellow", CL.count:format(L.volatile_eruption, violentEruptionCount))
	self:PlaySound(405375, "long")
	violentEruptionCount = violentEruptionCount + 1
	self:Bar(405375, self:Mythic() and 55 or 69.3, CL.count:format(L.volatile_eruption, violentEruptionCount))
end

-- Rionthus
function mod:DeepBreath(args)
	self:StopBar(CL.count:format(args.spellName, deepBreathCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, deepBreathCount))
	self:PlaySound(args.spellId, "alert")
	deepBreathCount = deepBreathCount + 1
	self:Bar(args.spellId, self:Mythic() and 55 or 43.5, CL.count:format(args.spellName, deepBreathCount))
end

do
	local prev = 0
	function mod:TemporalAnomaly(args)
		self:StopBar(CL.count:format(L.temporal_anomaly, temporalAnomalyCount))
		self:Message(args.spellId, "yellow", CL.count:format(L.temporal_anomaly, temporalAnomalyCount))
		self:PlaySound(args.spellId, "info")
		temporalAnomalyCount = temporalAnomalyCount + 1
		local timeSinceLast = args.time - prev
		prev = args.time
		self:Bar(args.spellId, self:Mythic() and (timeSinceLast > 24 and 22 or 33) or 43.8, CL.count:format(L.temporal_anomaly, temporalAnomalyCount))
	end
end

function mod:TemporalAnomalyKnocked(args)
	if self:Me(args.destGUID) then
		self:Message(407552, "blue", L.temporal_anomaly_knocked)
		self:PlaySound(407552, "underyou") -- You touched it
	end
end

function mod:Disintegrate(args)
	self:StopBar(CL.count:format(args.spellName, disintergrateCount))
	self:Message(405392, "orange", CL.count:format(args.spellName, disintergrateCount))
	disintergrateCount = disintergrateCount + 1
	self:Bar(405392, self:Mythic() and 55 or 43.8, CL.count:format(args.spellName, disintergrateCount))
end

function mod:DisintegrateApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
	end
end
