--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Magmorax", 2569, 2527)
if not mod then return end
mod:RegisterEnableMob(201579) -- Magmorax
mod:SetEncounterID(2683)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local moltenSpittleCount = 1
local ignitingRoarCount = 1
local overpoweringStompCount = 1
local blazingBreathCount = 1
local incineratingMawsCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.energy_gained = "Energy Gained! (-17s)" -- When you fail, you lose 17s on until the boss reaches full energy

	-- Mythic
	L.explosive_magma = "Soak Pool"
end

--------------------------------------------------------------------------------
-- Initialization
--

local moltenSpittleMarker = mod:AddMarkerOption(true, "player", 1, 402994, 1, 2, 3, 8) -- Molten Spittle
function mod:GetOptions()
	return {
		408358, -- Catastrophic Eruption
		{402994, "SAY", "SAY_COUNTDOWN"}, -- Molten Spittle
		moltenSpittleMarker,
		408839, -- Searing Heat
		407879, -- Blazing Tantrum
		403740, -- Igniting Roar
		403671, -- Overpowering Stomp
		409093, -- Blazing Breath
		{404846, "TANK"}, -- Incinerating Maws
		406712, -- Lava
		411633, -- Burning Chains
		-- Mythic
		{411182, "SAY", "SAY_COUNTDOWN"}, -- Explosive Magma
	},{
		[411182] = "mythic",
	},{
		[408358] = CL.full_energy, -- Catastrophic Eruption (Full Energy)
		[402994] = CL.pools,  -- Molten Spittle (Pools)
		[403740] = CL.roar, -- Igniting Roar (Roar)
		[403671] = CL.knockback, -- Overpowering Stomp (Knockback)
		[409093] = CL.breath, -- Blazing Breath (Breath)
		[411182] = L.explosive_magma, -- Explosive Magma (Soak Pool)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "CatastrophicEruption", 408358)
	self:Log("SPELL_CAST_SUCCESS", "MoltenSpittle", 402989)
	self:Log("SPELL_AURA_APPLIED", "MoltenSpittleApplied", 402994)
	self:Log("SPELL_AURA_REMOVED", "MoltenSpittleRemoved", 402994)
	self:Log("SPELL_AURA_APPLIED", "SearingHeatApplied", 408839)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SearingHeatApplied", 408839)
	self:Log("SPELL_CAST_START", "IgnitingRoar", 403740)
	self:Log("SPELL_CAST_START", "OverpoweringStomp", 403671)
	self:Log("SPELL_CAST_START", "BlazingBreath", 409093)
	self:Log("SPELL_CAST_START", "IncineratingMaws", 404846)
	self:Log("SPELL_AURA_APPLIED", "IncineratingMawsApplied", 404846)
	self:Log("SPELL_AURA_APPLIED_DOSE", "IncineratingMawsApplied", 404846)

	-- Ground Effects
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 406712, 411633) -- Lava, Burning Chains
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 406712, 411633)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 406712, 411633)

	self:RegisterUnitEvent("UNIT_POWER_UPDATE", nil, "boss1")

	self:Log("SPELL_AURA_APPLIED", "ExplosiveMagmaApplied", 411149) -- Molten Spittle Special ID
	self:Log("SPELL_AURA_REMOVED", "ExplosiveMagmaRemoved", 411149)
end

function mod:OnEngage()
	moltenSpittleCount = 1
	ignitingRoarCount = 1
	overpoweringStompCount = 1
	blazingBreathCount = 1
	incineratingMawsCount = 1

	self:Bar(403740, self:Easy() and 9 or 5, CL.count:format(CL.roar, ignitingRoarCount)) -- Igniting Roar
	self:Bar(402994, self:Easy() and 16.5 or 14.5, CL.count:format(CL.pools, moltenSpittleCount)) -- Molten Spittle
	self:Bar(404846, self:Easy() and 22 or 20, CL.count:format(self:SpellName(401348), incineratingMawsCount)) -- Incinerating Maws
	self:Bar(409093, self:Easy() and 33.3 or 26, CL.count:format(CL.breath, blazingBreathCount)) -- Blazing Breath
	self:Bar(403671, self:Easy() and 76.5 or 69, CL.count:format(CL.knockback, overpoweringStompCount)) -- Overpowering Stomp

	self:Bar(408358, 340, CL.full_energy) -- Catastrophic Eruption
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- function mod:BlazingTantrum(args)
-- 	self:TargetMessage(args.spellId, "red", args.sourceName)
-- 	self:PlaySound(args.spellId, "warning")
-- end

do
	local lastEnergy = 0
	function mod:UNIT_POWER_UPDATE(_, unit)
		local energy = UnitPower(unit)
		local energyDiff = energy-lastEnergy
		if energyDiff > 2 then -- uhoh
			local catastrophicEruptionTimeLeft = self:BarTimeLeft(CL.full_energy) -- Catastrophic Eruption
			if catastrophicEruptionTimeLeft > 18 then -- Update timer
				self:StopBar(CL.full_energy) -- Catastrophic Eruption
				self:Message(407879, "red", L.energy_gained)
				local newTimeLeft = catastrophicEruptionTimeLeft - 17 -- 17 s reduction from 5% energy
				self:Bar(408358, {newTimeLeft, 340}, CL.full_energy) -- Catastrophic Eruption
			else -- No bar left
				self:StopBar(CL.full_energy) -- Catastrophic Eruption
			end
		end
		lastEnergy = energy
	end
end

function mod:CatastrophicEruption(args)
	self:StopBar(CL.full_energy) -- Catastrophic Eruption
	self:Message(args.spellId, "red", CL.full_energy)
	self:PlaySound(args.spellId, "warning")
end

do
	local playerList = {}
	function mod:MoltenSpittle(args)
		self:StopBar(CL.count:format(CL.pools, moltenSpittleCount))
		moltenSpittleCount = moltenSpittleCount + 1
		local cd = {25.0, 27.0, 24.0, 26.0} -- Repeating
		if self:Easy() then
			cd = {41.1, 32.2, 40.0}
		end
		local cast = (moltenSpittleCount % #cd) + 1 -- 1, 2, 3...
		self:Bar(402994, cd[cast], CL.count:format(CL.pools, moltenSpittleCount))
		playerList = {}
	end

	function mod:MoltenSpittleApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(402994, "warning")
			self:Say(402994, CL.rticon:format(CL.pool, count))
			self:SayCountdown(402994, 6, count)
		end
		self:CustomIcon(moltenSpittleMarker, args.destName, count)
		self:TargetsMessage(402994, "cyan", playerList, 3, CL.count:format(CL.pools, moltenSpittleCount-1))
	end

	function mod:MoltenSpittleRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(402994)
		end
		self:CustomIcon(moltenSpittleMarker, args.destName)
	end
end

function mod:SearingHeatApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 5 == 0 or amount == 1 then -- 1, 5, 10, 15 ...
			self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
			self:PlaySound(args.spellId, "underyou")
		end
	end
end

function mod:IgnitingRoar(args)
	self:StopBar(CL.count:format(CL.roar, ignitingRoarCount))
	self:Message(args.spellId, "yellow", CL.count:format(CL.roar, ignitingRoarCount))
	self:PlaySound(args.spellId, "alert")
	ignitingRoarCount = ignitingRoarCount + 1
	local cd = {39.0, 23.0, 40.0} -- Repeating
	if self:Easy() then
		cd = {44.4, 28.9, 40.0} -- 2, 3, 1 of cast count
	end
	local cast = (ignitingRoarCount % 3) + 1 -- 1, 2, 3
	self:Bar(args.spellId, cd[cast], CL.count:format(CL.roar, ignitingRoarCount))
end

function mod:OverpoweringStomp(args)
	self:StopBar(CL.count:format(CL.knockback, overpoweringStompCount))
	self:Message(args.spellId, "orange", CL.count:format(CL.knockback, overpoweringStompCount))
	self:PlaySound(args.spellId, "long")
	overpoweringStompCount = overpoweringStompCount + 1
	self:Bar(args.spellId, self:Easy() and 113.3 or 102, CL.count:format(CL.knockback, overpoweringStompCount))
end

function mod:BlazingBreath(args)
	self:StopBar(CL.count:format(CL.breath, blazingBreathCount))
	self:Message(args.spellId, "red", CL.count:format(CL.breath, blazingBreathCount))
	self:PlaySound(args.spellId, "alert")
	blazingBreathCount = blazingBreathCount + 1
	local cd = {41.0, 33.0, 28.0} -- Repeating
	if self:Easy() then
		cd = {42.2, 43.3, 27.8} -- 2, 3, 1 of cast count
	end
	local cast = (blazingBreathCount % 3) + 1 -- 1, 2, 3
	self:Bar(args.spellId, cd[cast], CL.count:format(CL.breath, blazingBreathCount))
end

function mod:IncineratingMaws(args)
	self:StopBar(CL.count:format(args.spellName, incineratingMawsCount))
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	incineratingMawsCount = incineratingMawsCount + 1
	local cd = 22.3 -- Why does he sometimes skip?
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, incineratingMawsCount))
end

function mod:IncineratingMawsApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm")
	elseif amount > 1 then -- Tank Swap?
		self:PlaySound(args.spellId, "warning")
	else
		self:PlaySound(args.spellId, "info")
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

function mod:ExplosiveMagmaApplied(args)
	self:TargetMessage(411182, "red", args.destName, CL.count:format(L.explosive_magma, moltenSpittleCount-1))
	if self:Me(args.destGUID) then
		self:PlaySound(411182, "warning")
		self:Yell(411182, CL.rticon:format(L.explosive_magma, 8))
		self:YellCountdown(411182, 6, 8)
	end
	self:CustomIcon(moltenSpittleMarker, args.destName, 8)
end

function mod:ExplosiveMagmaRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(411182)
	end
	self:CustomIcon(moltenSpittleMarker, args.destName)
end
