
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Mug'Zee, Heads of Security", 2769, 2645)
if not mod then return end
mod:RegisterEnableMob(229953)
mod:SetEncounterID(3015)
mod:SetPrivateAuraSounds({
	472354, -- Fixate (Unstable Crawler Mines)
})
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local earthershakerGaolCount = 1
local frostshatterBootsCount = 1
local fingerGunCount = 1
local moltenGoldKnucklesCount = 1

local unstableCrawlerMinesCount = 1
local goblinGuidedRocketsCount = 1
local sprayAndPrayCount = 1
local doubleWhammyShotCount = 1
local electroShockerDead = 0

local staticChargeCount = 1

local mobCollector, mobMarks = {}, {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.earthshaker_gaol = "Prisons"
	L.frostshatter_boots = "Frost Boots" -- Short for Frostshatter Boots
	L.frostshatter_spear = "Frost Spears" -- Short for Frostshatter Spears
	L.stormfury_finger_gun = "Finger Gun" -- Short for Stormfury Finger Gun
	L.molten_gold_knuckles = "Tank Frontal"
	L.unstable_crawler_mines = "Mines"
	L.goblin_guided_rocket = "Rocket"
	L.double_whammy_shot = "Tank Soak"
end

--------------------------------------------------------------------------------
-- Initialization
--

local electroShockerMarker = mod:AddMarkerOption(false, "npc", 8, -31766, 8, 7)
local unstableCrawlerMinesMarker = mod:AddMarkerOption(false, "npc", 1, 466539, 1, 2, 3, 4, 5, 6)
function mod:GetOptions()
	return {
		"stages",
		electroShockerMarker,
		unstableCrawlerMinesMarker,
		466385, -- Moxie
		1216142, -- Double-Minded Fury

		-- Mug
		{472631, "SAY", "SAY_COUNTDOWN", "CASTBAR"}, -- Earthshaker Gaol
			1214623, -- Enraged
			472782, -- Pay Respects
			470910, -- Gaol Break
		466476, -- Frostshatter Boots
			466480, -- Frostshatter Spear
		466509, -- Stormfury Finger Gun
		466518, -- Molten Gold Knuckles (tank frontal)
			467202, -- Golden Drip

		-- Zee
		466539, -- Unstable Crawler Mines
			469043, -- Searing Shrapnel
		467380, -- Goblin-guided Rocket
		466545, -- Spray and Pray
		-31766, -- Mk II Electro Shocker
			1215595, -- Faulty Wiring
		469491, -- Double Whammy Shot (tank) "SAY", "SAY_COUNTDOWN"
			469391, -- Perforating Wound

		-- Intermission (40%)
		1215953, -- Static Charge
			-- Storming Impact
		{471574, "CASTBAR"}, -- Bulletstorm

		-- Mug'Zee
		463967, -- Bloodlust
	},{
		[472631] = -31677, -- Mug
		[466539] = -31693, -- Zee
		[1215953] = -30517, -- Intermission
		[463967] = -30510, -- Stage 2
	},{
		[1216142] = CL.full_energy,
		[472631] = L.earthshaker_gaol,
		[466476] = L.frostshatter_boots,
		[466480] = L.frostshatter_spear,
		[466509] = L.stormfury_finger_gun,
		[466518] = L.molten_gold_knuckles,
		[466539] = L.unstable_crawler_mines,
		[467380] = L.goblin_guided_rocket,
		[469491] = L.double_whammy_shot,
		[1215953] = CL.charge,
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1") -- Double Whammy Shot

	self:Log("SPELL_AURA_APPLIED_DOSE", "MoxieApplied", 466385)
	self:Log("SPELL_CAST_START", "DoubleMindedFury", 1216142)
	-- Mug
	self:Log("SPELL_CAST_SUCCESS", "MugTakingCharge", 468728)
	self:Log("SPELL_AURA_APPLIED", "EarthshakerGaolApplied", 472631)
	self:Log("SPELL_AURA_APPLIED", "EnragedApplied", 1214623) -- USCS:1214630 but no buff
	self:Log("SPELL_CAST_START", "PayRespects", 472782)
	self:Log("SPELL_CAST_START", "GaolBreak", 470910)
	self:Log("SPELL_AURA_APPLIED", "FrostshatterBootsApplied", 466476)
	self:Log("SPELL_CAST_START", "StormfuryFingerGun", 466509)
	self:Log("SPELL_CAST_START", "MoltenGoldKunckles", 466518)
	self:Log("SPELL_AURA_APPLIED", "GoldenDripApplied", 467202)
	self:Log("SPELL_AURA_REMOVED", "GoldenDripRemoved", 467202)
	-- Zee
	self:Log("SPELL_CAST_SUCCESS", "ZeeTakingCharge", 468794)
	self:Log("SPELL_CAST_SUCCESS", "FaultyWiringApplied", 1215595)
	self:Log("SPELL_CAST_SUCCESS", "UnstableCrawlerMines", 472458)
	self:Log("SPELL_AURA_APPLIED", "SearingShrapnelApplied", 469043)
	-- self:Log("SPELL_CAST_SUCCESS", "GoblinGuidedRocket", 467379)
	self:Log("SPELL_AURA_APPLIED", "GoblinGuidedRocketApplied", 467380) -- XXX wasn't shown in log in heroic
	self:Log("SPELL_CAST_START", "SprayAndPray", 466545)
	-- self:Log("SPELL_CAST_START", "DoubleWhammyShot", 469491) -- USCS
	-- self:Log("SPELL_AURA_APPLIED", "DoubleWhammyShotApplied", 469491) -- XXX not shown in log
	self:Log("SPELL_AURA_APPLIED", "PerforatingWoundApplied", 469391)
	self:Log("SPELL_AURA_REMOVED", "PerforatingWoundRemoved", 469391)
	self:Death("ElectroShockerDeath", 230316)
	-- Intermission
	self:Log("SPELL_CAST_START", "StaticChargeStart", 1215953)
	self:Log("SPELL_CAST_SUCCESS", "Bulletstorm", 471574)
	-- Stage 2
	self:Log("SPELL_CAST_START", "Bloodlust", 463967)
	self:Log("SPELL_CAST_SUCCESS", "BloodlustSuccess", 463967)
end

function mod:OnEngage()
	self:SetStage(1)

	staticChargeCount = 1
	mobCollector = {}
	mobMarks = {}

	-- MugTakingCharge/ZeeTakingCharge start the phase

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
	self:RegisterUnitEvent("UNIT_POWER_UPDATE", nil, "boss1")
	if self:GetOption(electroShockerMarker) then
		self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	end
	if self:GetOption(unstableCrawlerMinesMarker) then
		self:RegisterTargetEvents("AddMarking")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	for i = 1, 8 do
		local unit = ("boss%d"):format(i)
		local guid = self:UnitGUID(unit)
		if guid then
			local mobId = self:MobId(guid)
			if mobId == 230316 and not mobCollector[guid] then -- Mk II Electro Shocker
				mobCollector[guid] = true
				local icon = mobMarks[mobId] or 8
				self:CustomIcon(electroShockerMarker, unit, icon)
				mobMarks[mobId] = icon - 1
			end
		end
	end
end

function mod:AddMarking(_, unit, guid)
	if self:MobId(guid) == 231788 and not mobCollector[guid] then -- Unstable Crawler Mine
		mobCollector[guid] = true
		local icon = mobMarks[231788] or 1
		self:CustomIcon(unstableCrawlerMinesMarker, unit, icon)
		mobMarks[231788] = icon + 1
	end
end

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 43 then -- Intermission at 40%
		self:UnregisterUnitEvent(event, unit)
		self:Message("stages", "cyan", CL.soon:format(CL.intermission), false)
		self:PlaySound("stages", "info")
	end
end

function mod:UNIT_POWER_UPDATE(event, unit)
	-- XXX no other events for this?
	-- another option is use Head Honcho:Mug/Zug buffs and transition if there is no new gain
	local power = UnitPower(unit)
	if power == 0 and self:GetHealth(unit) < 40 then
		self:UnregisterUnitEvent(event, unit)
		self:IntermissionStart()
	end
end

function mod:MoxieApplied(args)
	-- XXX probably not terribly useful info to show since you'll probably be going off of double-minded fury
	if args.amount >= 15 and args.amount % 5 == 0 then
		self:Message(args.spellId, "red", CL.count:format(args.spellName, args.amount))
	end
end

function mod:DoubleMindedFury(args)
	self:Message(args.spellId, "red", CL.full_energy)
	self:PlaySound(args.spellId, "alarm") -- fail
end

-- Mug

function mod:MugTakingCharge(args)
	self:StopBar(CL.full_energy) -- Double-Minded Fury
	self:StopBar(CL.count:format(L.unstable_crawler_mines, unstableCrawlerMinesCount)) -- Unstable Crawler Mines
	self:StopBar(CL.count:format(L.goblin_guided_rocket, goblinGuidedRocketsCount)) -- Goblin-guided Rockets
	self:StopBar(CL.count:format(self:SpellName(466545), sprayAndPrayCount)) -- Spray and Pray
	self:StopBar(CL.count:format(L.double_whammy_shot, doubleWhammyShotCount)) -- Double Whammy Shot

	self:SetStage(1)
	self:Message("stages", "cyan", self:SpellName(468728), false) -- 468728 = Mug Taking Charge
	self:PlaySound("stages", "long")

	earthershakerGaolCount = 1
	frostshatterBootsCount = 1
	fingerGunCount = 1
	moltenGoldKnucklesCount = 1

	self:Bar(472631, 10.4, CL.count:format(L.earthshaker_gaol, earthershakerGaolCount)) -- Earthshaker Gaol
	self:Bar(466518, 20, CL.count:format(L.molten_gold_knuckles, moltenGoldKnucklesCount)) -- Molten Gold Knuckles
	self:Bar(466476, 27.1, CL.count:format(L.frostshatter_boots, frostshatterBootsCount)) -- Frostshatter Boots
	self:Bar(466509, 36.1, CL.count:format(L.stormfury_finger_gun, fingerGunCount)) -- Stormfury Finger Gun
	self:Bar(1216142, self:Mythic() and 64.7 or 79.4, CL.full_energy) -- Double-Minded Fury
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

			self:StopBar(CL.count:format(L.earthshaker_gaol, earthershakerGaolCount))
			self:CastBar(args.spellId, 6, CL.count:format(L.earthshaker_gaol, earthershakerGaolCount))
			earthershakerGaolCount = earthershakerGaolCount + 1
			if not self:Mythic() and self:GetStage() < 3 and earthershakerGaolCount < 3 then -- 2 per in heroic/normal, 1 in mythic
				self:Bar(args.spellId, 34.7, CL.count:format(L.earthshaker_gaol, earthershakerGaolCount))
			elseif self:GetStage() == 3 and earthershakerGaolCount < 3 then -- 2 per in heroic/normal
				self:Bar(args.spellId, 72.0, CL.count:format(L.earthshaker_gaol, earthershakerGaolCount))
			end
		end
		playerList[#playerList + 1] = args.destName
		if self:Me(args.destGUID) then
			gaolOnMe = true
			self:Say(args.spellId, nil, nil, "Earthshaker Gaol")
			self:SayCountdown(args.spellId, 6)
		end
		local count = self:Mythic() and 4 or 2
		self:TargetsMessage(args.spellId, "orange", playerList, count, L.earthshaker_gaol)
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
	-- only show for your goon
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
	function mod:FrostshatterBootsApplied(args)
		if args.time - prev > 3 then
			prev = args.time
			self:StopBar(CL.count:format(L.frostshatter_boots, frostshatterBootsCount))
			self:Message(args.spellId, "red", CL.count:format(L.frostshatter_boots, frostshatterBootsCount))
			self:Bar(466480, 8, L.frostshatter_spear) -- Frostshatter Spear
			frostshatterBootsCount = frostshatterBootsCount + 1
			if not self:Mythic() and self:GetStage() < 3 and frostshatterBootsCount < 3 then -- 2 per in heroic/normal, 1 in mythic
				self:Bar(args.spellId, 30.0, CL.count:format(L.frostshatter_boots, frostshatterBootsCount))
			end
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId, nil, L.frostshatter_boots)
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:StormfuryFingerGun(args)
	self:StopBar(CL.count:format(L.stormfury_finger_gun, fingerGunCount))
	self:Message(args.spellId, "orange", CL.count:format(L.stormfury_finger_gun, fingerGunCount))
	self:PlaySound(args.spellId, "alert") -- frontal
	fingerGunCount = fingerGunCount + 1
	if not self:Mythic() and self:GetStage() < 3 and fingerGunCount < 3 then -- 2 per in heroic/normal, 1 in mythic
		self:Bar(args.spellId, 30.0, CL.count:format(L.stormfury_finger_gun, fingerGunCount))
	end
end

function mod:MoltenGoldKunckles(args)
	self:StopBar(CL.count:format(L.molten_gold_knuckles, moltenGoldKnucklesCount))
	self:Message(args.spellId, "purple", CL.count:format(L.molten_gold_knuckles, moltenGoldKnucklesCount))
	self:PlaySound(args.spellId, "alert") -- frontal
	moltenGoldKnucklesCount = moltenGoldKnucklesCount + 1
	if not self:Mythic() and self:GetStage() < 3 and moltenGoldKnucklesCount < 3 then -- 2 per in heroic/normal, 1 in mythic
		self:Bar(args.spellId, 40.0, CL.count:format(L.molten_gold_knuckles, moltenGoldKnucklesCount))
	elseif self:GetStage() == 3 then
		local timer = { 40.0, 6.0, 56.0, 16.0, 0 }
		self:Bar(args.spellId, timer[moltenGoldKnucklesCount], CL.count:format(L.molten_gold_knuckles, moltenGoldKnucklesCount))
	end
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

function mod:ZeeTakingCharge(args)
	self:StopBar(CL.full_energy) -- Double-Minded Fury
	self:StopBar(CL.count:format(L.earthshaker_gaol, earthershakerGaolCount)) -- Earthshaker Gaol
	self:StopBar(CL.count:format(L.molten_gold_knuckles, moltenGoldKnucklesCount)) -- Molten Gold Knuckles
	self:StopBar(CL.count:format(L.frostshatter_boots, frostshatterBootsCount)) -- Frostshatter Boots
	self:StopBar(CL.count:format(L.stormfury_finger_gun, fingerGunCount)) -- Stormfury Finger Gun

	self:SetStage(2)
	self:Message("stages", "cyan", self:SpellName(468794), false) -- 468728 = Zee Taking Charge
	self:PlaySound("stages", "long")

	doubleWhammyShotCount = 1
	unstableCrawlerMinesCount = 1
	goblinGuidedRocketsCount = 1
	sprayAndPrayCount = 1
	electroShockerDead = 0
	mobMarks = {}

	self:Bar(466539, 13.9, CL.count:format(L.unstable_crawler_mines, unstableCrawlerMinesCount)) -- Unstable Crawler Mines
	self:Bar(467380, 27.8, CL.count:format(L.goblin_guided_rocket, goblinGuidedRocketsCount)) -- Goblin-guided Rockets
	self:Bar(469491, 42.4, CL.count:format(L.double_whammy_shot, doubleWhammyShotCount)) -- Double Whammy Shot
	self:Bar(466545, 50.0, CL.count:format(self:SpellName(466545), sprayAndPrayCount)) -- Spray and Pray
	self:Bar(1216142, self:Mythic() and 61.4 or 79.4, CL.full_energy) -- Double-Minded Fury
end

function mod:FaultyWiringApplied(args)
	local icon = self:GetIconTexture(self:GetIcon(args.destRaidFlags)) or ""
	self:Message(args.spellId, "green", args.spellName .. icon)
	self:PlaySound(args.spellId, "info")
end

function mod:ElectroShockerDeath(args)
	electroShockerDead = electroShockerDead + 1
	self:Message(-31766, "green", CL.mob_killed:format(args.destName, electroShockerDead, 2), false)
	self:PlaySound(-31766, "info")
end

function mod:UnstableCrawlerMines(args)
	self:StopBar(CL.count:format(L.unstable_crawler_mines, unstableCrawlerMinesCount))
	self:Message(466539, "yellow", CL.count:format(L.unstable_crawler_mines, unstableCrawlerMinesCount))
	unstableCrawlerMinesCount = unstableCrawlerMinesCount + 1
	if self:GetStage() < 3 and unstableCrawlerMinesCount < 3 then -- 2 per in heroic/normal/mythic
		self:Bar(466539, 44.0, CL.count:format(L.unstable_crawler_mines, unstableCrawlerMinesCount))
	elseif self:GetStage() == 3 and unstableCrawlerMinesCount < 3 then -- 2 per in heroic/normal
		self:Bar(466539, 72.0, CL.count:format(L.unstable_crawler_mines, unstableCrawlerMinesCount))
	end
end

function mod:SearingShrapnelApplied(args)
	if self:Me(args.destGUID) then
		self:Personal(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

-- function mod:GoblinGuidedRocket(args)
-- 	self:Message(467380, "orange", CL.count:format(L.goblin_guided_rocket, goblinGuidedRocketsCount))
-- 	self:PlaySound(467380, "alert")
-- 	goblinGuidedRocketsCount = goblinGuidedRocketsCount + 1
-- 	if self:GetStage() < 3 and goblinGuidedRocketsCount < 3 then -- 2 per in heroic/normal
-- 		self:Bar(467380, 42.1, CL.count:format(L.goblin_guided_rocket, goblinGuidedRocketsCount))
-- 	end
-- end

function mod:GoblinGuidedRocketApplied(args)
	self:StopBar(CL.count:format(L.goblin_guided_rocket, goblinGuidedRocketsCount))
	self:TargetMessage(args.spellId, "orange", args.destName, CL.count:format(L.goblin_guided_rocket, goblinGuidedRocketsCount))
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
	else
		self:PlaySound(args.spellId, "alert", nil, args.destName)
	end
	goblinGuidedRocketsCount = goblinGuidedRocketsCount + 1
	if not self:Mythic() and  self:GetStage() < 3 and goblinGuidedRocketsCount < 3 then -- 2 per in heroic/normal, 1 in mythic
		self:Bar(args.spellId, 42.1, CL.count:format(L.goblin_guided_rocket, goblinGuidedRocketsCount))
	end
end

function mod:SprayAndPray(args)
	self:StopBar(CL.count:format(args.spellName, sprayAndPrayCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, sprayAndPrayCount))
	self:PlaySound(args.spellId, "alert") -- frontal
	if not self:Mythic() and self:GetStage() == 3 and sprayAndPrayCount < 3 then -- 2 per in heroic/normal, 1 in mythic
		self:Bar(args.spellId, 78.2, CL.count:format(args.spellName, sprayAndPrayCount))
	end
end

do
	local woundOnMe = false

	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
		if spellId == 469490 then -- Double Whammy Shot, someone has debuff
			self:DoubleWhammyShot()
		end
	end

	function mod:DoubleWhammyShot()
		self:StopBar(CL.count:format(L.double_whammy_shot, doubleWhammyShotCount))
		self:Message(469491, "purple", CL.count:format(L.double_whammy_shot, doubleWhammyShotCount))
		self:TargetBar(469491, 6, "???", CL.count:format(L.double_whammy_shot, doubleWhammyShotCount))
		if self:Tank() and not woundOnMe then
			self:PlaySound(469491, "warning") -- soak
		end
		doubleWhammyShotCount = doubleWhammyShotCount + 1
	end

	-- function mod:DoubleWhammyShotApplied(args)
	-- 	self:TargetMessage(args.spellId, "purple", args.destName, CL.count:format(L.double_whammy_shot, doubleWhammyShotCount))
	-- 	if self:Me(args.destGUID) or self:Tank() then
	-- 		self:TargetBar(args.spellId, 6, args.destName, CL.count:format(L.double_whammy_shot, doubleWhammyShotCount))
	-- 		if not woundOnMe then
	-- 			self:PlaySound(args.spellId, "warning") -- soak
	-- 		end
	-- 		-- self:Say(args.spellId, L.double_whammy_shot, nil, "Tank Soak")
	-- 		-- self:SayCountdown(args.spellId, 6)
	-- 	end
	-- doubleWhammyShotCount = doubleWhammyShotCount + 1
	-- 	-- self:Bar(args.spellId, 30, CL.count:format(L.double_whammy_shot, doubleWhammyShotCount)) -- 1 per in heroic
	-- end

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

function mod:IntermissionStart(skip)
	self:UnregisterUnitEvent("UNIT_HEALTH", "boss1")
	self:StopBar(CL.full_energy) -- Double-Minded Fury
	self:StopBar(CL.count:format(L.unstable_crawler_mines, unstableCrawlerMinesCount)) -- Unstable Crawler Mines
	self:StopBar(CL.count:format(L.goblin_guided_rocket, goblinGuidedRocketsCount)) -- Goblin-guided Rockets
	self:StopBar(CL.count:format(self:SpellName(466545), sprayAndPrayCount)) -- Spray and Pray
	self:StopBar(CL.count:format(L.double_whammy_shot, doubleWhammyShotCount)) -- Double Whammy Shot
	self:StopBar(CL.count:format(L.earthshaker_gaol, earthershakerGaolCount)) -- Earthshaker Gaol
	self:StopBar(CL.count:format(L.molten_gold_knuckles, moltenGoldKnucklesCount)) -- Molten Gold Knuckles
	self:StopBar(CL.count:format(L.frostshatter_boots, frostshatterBootsCount)) -- Frostshatter Boots
	self:StopBar(CL.count:format(L.stormfury_finger_gun, fingerGunCount)) -- Stormfury Finger Gun

	self:SetStage(2.5)
	self:Message("stages", "cyan", CL.intermission, false)

	if not skip then
		self:PlaySound("stages", "long")
		-- "<306.90 00:18:39> [UNIT_POWER_UPDATE] boss1#Mug'Zee#TYPE:ENERGY/3#MAIN:0/100#ALT:0/0",
		-- "<316.90 00:18:49> [CLEU] SPELL_CAST_START#Creature-0-5770-2769-13207-229953-00000D94EE#Mug'Zee(37.6%-0.0%)##nil#1215953#Static Charge#nil#nil#nil#nil#nil#nil",
		-- "<364.88 00:19:37> [CLEU] SPELL_CAST_START#Creature-0-5770-2769-13207-229953-00000D94EE#Mug'Zee(26.7%-0.0%)##nil#463967#Bloodlust#nil#nil#nil#nil#nil#nil",
		self:Bar(1215953, 10.0, CL.count:format(CL.charge, staticChargeCount)) -- Static Charge
		self:Bar("stages", 64.0, CL.stage:format(2), "inv_111_raid_achievement_mugzeeheadsofsecurity")
	end
end

function mod:StaticChargeStart(args)
	if self:GetStage() < 2.5 then -- just in case
		self:IntermissionStart(true)
		self:Bar("stages", 54.0, CL.stage:format(2), "inv_111_raid_achievement_mugzeeheadsofsecurity")
	end
	self:StopBar(CL.count:format(CL.charge, staticChargeCount))
	self:Message(args.spellId, "orange", CL.count_amount:format(CL.charge, staticChargeCount, 3))
	self:PlaySound(args.spellId, "alert", nil, args.destName) -- watch out
	staticChargeCount = staticChargeCount + 1
	if staticChargeCount < 4 then -- 3 in normal/heroic/mythic
		self:Bar(args.spellId, 18.0, CL.count:format(CL.charge, staticChargeCount))
	end
end

function mod:Bulletstorm(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert") -- cones
	self:CastBar(args.spellId, 8)
end

-- Stage 2

function mod:Bloodlust()
	self:SetStage(3)
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long")

	earthershakerGaolCount = 1
	frostshatterBootsCount = 1
	fingerGunCount = 1
	moltenGoldKnucklesCount = 1

	unstableCrawlerMinesCount = 1
	goblinGuidedRocketsCount = 1
	sprayAndPrayCount = 1
	doubleWhammyShotCount = 1
	mobMarks = {}

	self:Bar(466539, 17.2, CL.count:format(L.unstable_crawler_mines, unstableCrawlerMinesCount)) -- Unstable Crawler Mines
	self:Bar(472631, 22.0, CL.count:format(L.earthshaker_gaol, earthershakerGaolCount)) -- Earthshaker Gaol
	self:Bar(466545, 30.0, CL.count:format(CL.frontal_cone, sprayAndPrayCount)) -- Spray and Pray
	self:Bar(466518, 40.1, CL.count:format(L.molten_gold_knuckles, moltenGoldKnucklesCount)) -- Molten Gold Knuckles
	self:Bar(469491, 54.2, CL.count:format(L.double_whammy_shot, doubleWhammyShotCount)) -- Double Whammy Shot
	self:Bar(466509, 60.1, CL.count:format(CL.frontal_cone, fingerGunCount)) -- Stormfury Finger Gun
	self:Bar(467380, 69.7, CL.count:format(L.goblin_guided_rocket, goblinGuidedRocketsCount)) -- Goblin-guided Rockets
	self:Bar(466476, 79.5, CL.count:format(L.frostshatter_boots, frostshatterBootsCount)) -- Frostshatter Boots
	self:Bar(1216142, 125.6, CL.full_energy) -- Double-Minded Fury
end

function mod:BloodlustSuccess(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alarm")
end
