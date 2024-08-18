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
	L.energy_gained = "Energy Gained (-17s)" -- When you fail, you lose 17 seconds, the boss reaches full energy faster

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
		{402994, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Molten Spittle
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
		{411182, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Explosive Magma
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

function mod:VerifyEnable(unit)
	return UnitCanAttack("player", unit)
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

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "ExplosiveMagmaApplied", 411149) -- Molten Spittle Special ID
	self:Log("SPELL_AURA_REMOVED", "ExplosiveMagmaRemoved", 411149)
end

function mod:OnEngage()
	moltenSpittleCount = 1
	ignitingRoarCount = 1
	overpoweringStompCount = 1
	blazingBreathCount = 1
	incineratingMawsCount = 1

	self:Bar(403740, self:Mythic() and 5.6 or self:Easy() and 8.9 or 6.2, CL.count:format(CL.roar, ignitingRoarCount)) -- Igniting Roar
	self:Bar(402994, self:Mythic() and 15.9 or self:Easy() and 18.1 or 17.7, CL.count:format(CL.pools, moltenSpittleCount)) -- Molten Spittle
	self:Bar(404846, self:Mythic() and 22.2 or self:Easy() and 22.2 or 25) -- Incinerating Maws
	self:Bar(409093, self:Mythic() and 28.9 or self:Easy() and 33.4 or 31.2, CL.count:format(CL.breath, blazingBreathCount)) -- Blazing Breath
	self:Bar(403671, self:Mythic() and 43.3 or self:Easy() and 76.6 or 89.9, CL.count:format(CL.knockback, overpoweringStompCount)) -- Overpowering Stomp

	self:Bar(408358, 336, CL.full_energy) -- Catastrophic Eruption

	self:RegisterUnitEvent("UNIT_POWER_UPDATE", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local lastEnergy = 0
	function mod:UNIT_POWER_UPDATE(_, unit)
		local energy = UnitPower(unit)
		local energyDiff = energy-lastEnergy
		if energyDiff > 2 then -- uhoh
			local catastrophicEruptionTimeLeft = self:BarTimeLeft(CL.full_energy) -- Catastrophic Eruption
			if catastrophicEruptionTimeLeft > 18 then -- Update timer
				self:StopBar(CL.full_energy) -- Catastrophic Eruption
				self:Message(407879, "cyan", L.energy_gained)
				local newTimeLeft = catastrophicEruptionTimeLeft - 17 -- 17 s reduction from 5% energy
				self:Bar(408358, {newTimeLeft, 336}, CL.full_energy) -- Catastrophic Eruption
			else -- No bar left
				self:StopBar(CL.full_energy) -- Catastrophic Eruption
			end
		end
		lastEnergy = energy
	end
end

function mod:CatastrophicEruption(args)
	self:StopBar(CL.full_energy) -- Catastrophic Eruption
	self:StopBar(CL.count:format(CL.roar, ignitingRoarCount)) -- Igniting Roar
	self:StopBar(CL.count:format(CL.pools, moltenSpittleCount)) -- Molten Spittle
	self:StopBar(404846) -- Incinerating Maws
	self:StopBar(CL.count:format(CL.breath, blazingBreathCount)) -- Blazing Breath
	self:StopBar(CL.count:format(CL.knockback, overpoweringStompCount)) -- Overpowering Stomp

	self:Message(args.spellId, "red", CL.full_energy)
	self:PlaySound(args.spellId, "warning")
end

do
	local playerList = {}
	local easyTimers = { 41.1, 32.2, 40.0 } -- 32.2, 40.0, 41.1 repeating
	local heroicTimers = { 32.5, 37.5, 30.0 } -- 37.5, 30.0, 32.5 repeating
	function mod:MoltenSpittle()
		playerList = {}
		self:StopBar(CL.count:format(CL.pools, moltenSpittleCount))
		moltenSpittleCount = moltenSpittleCount + 1
		local cd
		if self:Easy() then
			cd = easyTimers[(moltenSpittleCount % 3) + 1]
		elseif self:Mythic() then
			cd = moltenSpittleCount % 2 == 0 and 40 or 26.7
		else -- Heroic
			cd = heroicTimers[(moltenSpittleCount % 3) + 1]
		end
		self:Bar(402994, cd, CL.count:format(CL.pools, moltenSpittleCount))
	end

	function mod:MoltenSpittleApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(402994, "warning")
			self:Say(402994, CL.rticon:format(CL.pool, count), nil, ("Pool ({rt%d})"):format(count))
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

do
	local easyTimers = { 44.5, 28.9, 40.0 } -- 28.9, 40.0, 44.5 repeating
	function mod:IgnitingRoar(args)
		local msg = CL.count:format(CL.roar, ignitingRoarCount)
		self:StopBar(msg)
		self:Message(args.spellId, "yellow", msg)
		self:PlaySound(args.spellId, "alert")
		ignitingRoarCount = ignitingRoarCount + 1
		local cd = 50 -- Heroic
		if self:Easy() then
			cd = easyTimers[(ignitingRoarCount % 3) + 1]
		elseif self:Mythic() then
			cd = ignitingRoarCount % 2 == 0 and 41.8 or 24.9
		end
		self:Bar(args.spellId, cd, CL.count:format(CL.roar, ignitingRoarCount))
	end
end

function mod:OverpoweringStomp(args)
	local msg = CL.count:format(CL.knockback, overpoweringStompCount)
	self:StopBar(msg)
	self:Message(args.spellId, "orange", msg)
	self:PlaySound(args.spellId, "long")
	overpoweringStompCount = overpoweringStompCount + 1
	self:Bar(args.spellId, self:Mythic() and 66.7 or self:Easy() and 113.4 or 100.0, CL.count:format(CL.knockback, overpoweringStompCount))
end

do
	local easyTimers = { 42.2, 43.3, 27.7 } -- 43.3, 27.8, 42.2 repeating
	function mod:BlazingBreath(args)
		local msg = CL.count:format(CL.breath, blazingBreathCount)
		self:StopBar(msg)
		self:Message(args.spellId, "red", msg)
		self:PlaySound(args.spellId, "alert")
		blazingBreathCount = blazingBreathCount + 1
		local cd
		if self:Easy() then
			cd = easyTimers[(blazingBreathCount % 3) + 1]
		elseif self:Mythic() then
			cd = blazingBreathCount % 2 == 0 and 35.6 or 31.1
		else -- Heroic
			cd = blazingBreathCount % 2 == 0 and 35 or 65
		end
		self:Bar(args.spellId, cd, CL.count:format(CL.breath, blazingBreathCount))
	end
end

do
	local mythicTimers = { 24.4, 27.8, 14.5 } -- 27.8, 14.5, 24.4 repeating
	function mod:IncineratingMaws(args)
		self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
		incineratingMawsCount = incineratingMawsCount + 1
		local cd = 25 -- Heroic
		if self:Mythic() then
			cd = mythicTimers[(incineratingMawsCount % 3) + 1]
		elseif self:Easy() then
			cd = 22.3
		end
		self:Bar(args.spellId, cd)
	end
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
		self:Yell(411182, CL.rticon:format(L.explosive_magma, 8), nil, "Explosive Magma ({rt8})")
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
