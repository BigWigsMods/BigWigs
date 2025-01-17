if not BigWigsLoader.isTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Mug'Zee, Heads of Security", 2769, 2645)
if not mod then return end
mod:RegisterEnableMob(229953) -- XXX confirm
mod:SetEncounterID(3015)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local electroShockerCount = 0
local staticChargeCount = 1

--------------------------------------------------------------------------------
-- Localization
--

-- local L = mod:GetLocale()
-- if L then
-- end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		466385, -- Moxie
		1216142, -- Double-Minded Fury (danger)

		-- Mug
			472631, -- Earthshaker Gaol (ult) "SAY", "SAY_COUNTDOWN"
				1214623, -- Enraged
				-- Shakedown (spammed?)
				472782, -- Pay Respects
				470910, -- Gaol Break
					474554, -- Shaken Earth (damage)
			466476, -- Iceblock Boots (intercept soak)
				466480, -- Frostshatter Spear
			466509, -- Stormfury Finger Gun
			466518, -- Motlen Gold Knuckles (tank)
				467202, -- Golden Drip
				470089, -- Molten Golden Pool (damage)

		-- Zee
			466539, -- Unstable Crawler Mines (ult)
				469043, -- Searing Shrapnel
			467381, -- Goblin-guided Rocket (meteor soak)
				472057, -- Hot Mess (damage)
			466545, -- Spray and Pray
			-31712, -- Mk II Electro Shocker
				1215591, -- Faulty Wiring
			469490, -- Double Whammy Shot (tank) "SAY", "SAY_COUNTDOWN"
				469391, -- Perforating Wound

		-- Intermission (40%)
			{1215898, "CASTBAR"}, -- Static Charge (line soak) "SAY", "SAY_COUNTDOWN"
				-- Storming Impact (knockback)
			{471574, "CASTBAR"}, -- Bulletstorm

		-- Mug'Zee
			463967, -- Bloodlust
	},{
		[472631] = -31677, -- Mug
		[466539] = -31693, -- Zee
		[1215898] = -30517, -- Intermission
		[463967] = -30510, -- Stage 2
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED_DOSE", "MoxieApplied", 466385)
	self:Log("SPELL_CAST_START", "DoubleMindedFury", 1216142)
	-- Mug
	self:Log("SPELL_CAST_SUCCESS", "ElementalCarnage", 468658)
	self:Log("SPELL_CAST_START", "EarthshakerGaolApplied", 472631)
	self:Log("SPELL_AURA_APPLIED", "EnragedApplied", 1214623)
	self:Log("SPELL_CAST_START", "PayRespects", 472782)
	self:Log("SPELL_CAST_START", "GaolBreak", 470910)
	self:Log("SPELL_AURA_APPLIED", "IceblockBootsApplied", 466476)
	self:Log("SPELL_CAST_START", "StormfuryFingerGun", 466509)
	self:Log("SPELL_CAST_START", "MoltenGoldKunckles", 466518)
	self:Log("SPELL_AURA_APPLIED", "GoldenDripApplied", 467202)
	self:Log("SPELL_AURA_REMOVED", "GoldenDripRemoved", 467202)
	-- Zee
	self:Log("SPELL_CAST_SUCCESS", "UncontrollableDestruction", 468694)
	self:Log("SPELL_AURA_APPLIED", "FaultyWiringApplied", 1215591)
	self:Log("SPELL_CAST_SUCCESS", "UnstableCrawlerMines", 466539) -- targeted debuff? probably a generic "Fixate" spell
	self:Log("SPELL_AURA_APPLIED", "SearingShrapnelApplied", 469043)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SearingShrapnelApplied", 469043)
	self:Log("SPELL_CAST_SUCCESS", "GoblinGuidedRocket", 467381)
	self:Log("SPELL_AURA_APPLIED", "GoblinGuidedRocketApplied", 467380)
	self:Log("SPELL_CAST_START", "SprayAndPray", 466545)
	self:Log("SPELL_AURA_APPLIED", "DoubleWhammyShotApplied", 469490)
	self:Log("SPELL_AURA_APPLIED", "PerforatingWoundApplied", 469391)
	self:Log("SPELL_AURA_REMOVED", "PerforatingWoundRemoved", 469391)
	self:Death("ElectroShockerDeath", 230316)
	-- Intermission
	self:Log("SPELL_AURA_APPLIED", "StaticChargeApplied", 1215898)
	self:Log("SPELL_CAST_SUCCESS", "BulletStorm", 471574)
	-- Stage 2
	self:Log("SPELL_CAST_START", "Bloodlust", 463967)
	-- self:Log("SPELL_AURA_REMOVED", "BloodlustRemoved", 463967)


	-- Shaken Earth, Molten Golden Pool, Hot Mess
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 474554, 470089, 472057)
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 474554, 470089, 472057)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 474554, 470089, 472057)

end

function mod:OnEngage()
	self:SetStage(1)
	electroShockerCount = 0

	-- ElementalCarnage/UncontrollableDestruction start the phase
	-- XXX fixed ult/soak/tank sequence regardless of side (ie, kurog)?

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellId)
	if spellId == 468927 then -- Head Honcho
		self:HeadHoncho()
	end
end

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 43 then -- Intermission at 40%
		self:UnregisterUnitEvent(event, unit)
		self:Message("stages", "cyan", CL.soon:format(CL.intermission), false)
		self:PlaySound("stages", "info")
	end
end

function mod:MoxieApplied(args)
	-- XXX probably not terribly useful info to show since you'll probably be going off of double-minded fury
	if args.amount >= 15 and args.amount % 5 == 0 then
		self:Message(args.spellId, "red", CL.count:format(args.spellName, args.amount))
	end
end

function mod:DoubleMindedFury(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm") -- fail
end

-- Mug

function mod:ElementalCarnage(args)
	-- self:StopBar(1216142) -- Double-Minded Fury
	-- self:StopBar(466539) -- Unstable Crawler Mines
	-- self:StopBar(467381) -- Goblin-guided Rockets
	-- self:StopBar(466545) -- Spray and Pray
	-- self:StopBar(469490) -- Double Whanny Shot

	self:Message("stages", "cyan", self:SpellName(468728), false) -- 468728 = Mug Taking Charge
	self:PlaySound("stages", "long")

	-- self:Bar(1216142, 70) -- Double-Minded Fury
	-- self:Bar(472631, 20) -- Earthshaker Gaol
	-- self:Bar(466476, 20) -- Iceblock Boots
	-- self:Bar(466509, 20) -- Stormfury Finger Gun
	-- self:Bar(466518, 20) -- Molten Gold Knuckles
end

do
	local playerList = {}
	local prev = 0
	local gaolOnMe = false

	function mod:EarthshakerGaolApplied(args)
		if args.time - prev > 3 then
			prev = args.time
			playerList = {}
			gaolOnMe = false
			-- self:Bar(args.spellId, 30)
		end
		playerList[#playerList + 1] = args.destName
		if self:Me(args.destGUID) then
			gaolOnMe = true
			-- self:Say(args.spellId, nil, nil, "Earthshaker Gaol")
			-- self:SayCountdown(args.spellId, 6)
		end
		local count = self:Mythic() and 4 or 2
		self:TargetsMessage(args.spellId, "orange", playerList, count)
		if #playerList == count then
			if gaolOnMe then
				self:PlaySound(args.spellId, "warning") -- stack
			elseif not self:CheckOption(args.spellId, "ME_ONLY") then
				self:PlaySound(args.spellId, "alert") -- stack
			end
		end
	end

	function mod:EarthshakerGaolRemoved(args)
		if self:Me(args.destGUID) then
			gaolOnMe = false
		end
	end
end

function mod:EnragedApplied(args)
	-- no throttle, multiple messages is probably fine
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm") -- fail
end

function mod:PayRespects(args)
	-- only show for your goon (assume it starts casting this immediately after the splitting damage)
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:UnitWithinRange(unit, 10) then
		local canDo, ready = self:Interrupter(args.sourceGUID)
		if canDo and ready then
			self:Message(args.spellId, "yellow")
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:GaolBreak(args)
	-- only show for your goon
	local unit = self:UnitTokenFromGUID(args.sourceGUID)
	if unit and self:UnitWithinRange(unit, 10) then
		self:Message(args.spellId, "orange")
		self:PlaySound(args.spellId, "alarm")
	end
end

do
	local prev = 0
	function mod:IceblockBootsApplied(args)
		if args.time - prev > 3 then
			prev = args.time
			self:Message(args.spellId, "red")
			self:Bar(466480, 8) -- Frostshatter Spear
			-- self:Bar(args.spellId, 30)
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:StormfuryFingerGun(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert") -- frontal
	-- self:Bar(args.spellId, 30)
end

function mod:MoltenGoldKunckles(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert") -- frontal
	-- self:Bar(args.spellId, 30)
end

function mod:GoldenDripApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	elseif self:Tank() and self:Tank(args.destName) then
		self:TargetMessage(args.spellId, "purple", args.destName)
		self:PlaySound(args.spellId, "warning") -- tauntswap
	end
end

function mod:GoldenDripRemoved(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "green", CL.removed:format(args.spellName))
		self:PlaySound(args.spellId, "info")
	end
end

-- Zee

function mod:UncontrollableDestruction(args)
	-- self:StopBar(1216142) -- Double-Minded Fury
	-- self:StopBar(472631) -- Earthshaker Gaol
	-- self:StopBar(466476) -- Iceblock Boots
	-- self:StopBar(466509) -- Stormfury Finger Gun
	-- self:StopBar(466518) -- Molten Gold Knuckles

	self:Message("stages", "cyan", self:SpellName(468794), false) -- 468728 = Zee Taking Charge
	self:PlaySound("stages", "long")

	electroShockerCount = electroShockerCount + 2

	-- self:Bar(1216142, 70) -- Double-Minded Fury
	-- self:Bar(466539, 20) -- Unstable Crawler Mines
	-- self:Bar(467381, 20) -- Goblin-guided Rockets
	-- self:Bar(466545, 20) -- Spray and Pray
	-- self:Bar(469490, 20) -- Double Whanny Shot
end

function mod:FaultyWiringApplied(args)
	local icon = self:GetIcon(args.destRaidFlags) or ""
	self:Message(args.spellId, "green", icon..args.spellName)
	self:PlaySound(args.spellId, "info")
end

function mod:ElectroShockerDeath(args)
	electroShockerCount = math.max(0, electroShockerCount - 1)
	self:Message(-31712, "green", CL.killed:format(args.destName), false)
	self:PlaySound(-31712, "info")
end

function mod:UnstableCrawlerMines(args)
	self:Message(args.spellId, "yellow")
	-- self:Bar(args.spellId, 30)
end

do
	local scheduled = nil
	local stacks = 0
	function mod:SearingShrapnelMessage()
		self:Message(469043, "blue", CL.stackyou:format(stacks, self:SpellName(469043)))
		self:PlaySound(469043, "alarm")
		scheduled = nil
	end
	function mod:SearingShrapnelApplied(args)
		if self:Me(args.destGUID) then
			stacks = args.amount or 1
			if scheduled then
				self:CancelTimer(scheduled)
			end
			scheduled = self:ScheduleTimer("SearingShrapnelMessage", 2)
		end
	end
end

function mod:GoblinGuidedRocket(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert") -- soak
end

function mod:GoblinGuidedRocketApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(467381)
		self:PlaySound(467381, "warning")
	end
end

function mod:SprayAndPray(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert") -- frontal
	-- self:Bar(args.spellId, 30)
end

do
	local woundOnMe = false
	function mod:DoubleWhammyShotApplied(args)
		self:TargetMessage(args.spellId, "orange", args.destName)
		if self:Me(args.destGUID) or self:Tank() then
			self:TargetBar(args.spellId, 6, args.destName)
			if not woundOnMe then
				self:PlaySound(args.spellId, "warning") -- taunt?
			end
			-- self:Say(args.spellId, nil, nil, "Double Whammy Shot")
			-- self:SayCountdown(args.spellId, 6)
		end
		-- self:Bar(args.spellId, 30)
	end

	function mod:PerforatingWoundApplied(args)
		if self:Me(args.destGUID) then
			woundOnMe = true
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "alarm")
		end
	end

	function mod:PerforatingWoundRemoved(args)
		if self:Me(args.destGUID) then
			woundOnMe = false
		end
	end
end

-- Intermission

function mod:StaticChargeApplied(args)
	if self:GetStage() == 1 then -- temp transition handler
		self:UnregisterUnitEvent("UNIT_HEALTH", "boss1")
	-- self:StopBar(1216142) -- Double-Minded Fury
	-- self:StopBar(466539) -- Unstable Crawler Mines
	-- self:StopBar(467381) -- Goblin-guided Rockets
	-- self:StopBar(466545) -- Spray and Pray
	-- self:StopBar(469490) -- Double Whanny Shot
	-- self:StopBar(472631) -- Earthshaker Gaol
	-- self:StopBar(466476) -- Iceblock Boots
	-- self:StopBar(466509) -- Stormfury Finger Gun
	-- self:StopBar(466518) -- Molten Gold Knuckles

		self:SetStage(1.5)
		self:Message("stages", "cyan", CL.intermission, false)
		self:PlaySound("stages", "long")
		staticChargeCount = 1
	end

	self:TargetMessage(args.spellId, "orange", args.destName, CL.count:format(args.spellName, staticChargeCount))
	self:CastBar(args.spellId, 5, CL.count:format(args.spellName, staticChargeCount))
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		-- self:Say(args.spellId, nil, nil, "Static Charge")
		-- self:SayCountdown(args.spellId, 5)
	else
		self:PlaySound(args.spellId, "alert", nil, args.destName)
	end
	staticChargeCount = staticChargeCount + 1
	-- if staticChargeCount < 9 then
	-- 	self:Bar(args.spellId, 15, CL.count:format(args.spellName, staticChargeCount))
	-- end
end

function mod:BulletStorm(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert") -- dodgable? either healer or (frontal) cones
	self:CastBar(args.spellId, 8)
end

-- Stage 2

function mod:HeadHoncho()
	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long")

	-- electroShockerCount = 2

	-- self:Bar(472631, 20) -- Earthshaker Gaol
	-- self:Bar(466476, 20) -- Iceblock Boots
	-- self:Bar(466509, 20) -- Stormfury Finger Gun
	-- self:Bar(466518, 20) -- Molten Gold Knuckles
	-- self:Bar(466539, 20) -- Unstable Crawler Mines
	-- self:Bar(467381, 20) -- Goblin-guided Rockets
	-- self:Bar(466545, 20) -- Spray and Pray
	-- self:Bar(469490, 20) -- Double Whanny Shot

	-- self:Bar(463967, 70) -- Bloodlust
	-- self:Bar(1216142, 110) -- Double-Minded Fury
end

function mod:Bloodlust(args)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "alarm")
end

-- function mod:BloodlustRemoved(args)
-- 	self:Message(args.spellId, "green", CL.removed:format(args.spellName))
-- 	self:PlaySound(args.spellId, "info")
-- end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end
