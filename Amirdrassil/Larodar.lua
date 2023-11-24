--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Larodar, Keeper of the Flame", 2549, 2553)
if not mod then return end
mod:RegisterEnableMob(208445) -- Larodar, Keeper of the Flame
mod:SetEncounterID(2731)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--


local fieryForceOfNatureCount = 1
local scorchingRootsCount = 1
local furiousChargeCount = 1
local blazingThornsCount = 1
local ragingInfernoCount = 1
local ignitingGrowthCount = 1

local searingAshCount = 1
local fallingEmbersCount = 1
local flashFireCount = 1
local fireWhirlCount = 1
local smolderingBackdraftCount = 1
local ashenCallCount = 1
local ashenDevastationCount = 1
local ashenDevastationCount = 1

--------------------------------------------------------------------------------
-- Timers
--

local timersNormal = { -- 5:06 p1, 2:55 p2
	-- p1
	[417653] = { 6.6, 104.8, 98.6 }, -- Fiery Force of Nature
	[422614] = { 37.3, 110.3, 93.1 }, -- Scorching Roots
	[418637] = { 22.1, 21.8, 24.2, 35.6, 24.2, 28.6, 25.3, 43.6, 22.0, 24.3 }, -- Furious Charge
	[426206] = { 30.7, 24.2, 24.2, 37.8, 52.7, 64.5, 24.2, 24.2 }, -- Blazing Thorns
	-- p2
	[427252] = { 7.3, 26.7, 25.0, 23.3, 30.0, 20.0, 25.0 }, -- Falling Embers
	[427299] = { 29.1, 45.1, 41.8, 41.8, 50.1, 50.1 }, -- Flash Fire 1
	[427343] = { 54.0, 40.8, 32.5, 42.5 }, -- Fire Whirl
	[429973] = { 14.0, 25.9, 30.0, 19.1, 29.2, 25.8, 20.0 }, -- Smoldering Backdraft
	[421325] = { 20.7, 44.2, 42.5, 42.5 }, -- Ashen Call
}
local timersHeroic = { -- 4:51 p1, 3:45 p2
	-- p1
	[417653] = { 6.6, 105.5, 98.0 }, -- Fiery Force of Nature
	[422614] = { 37.4, 111.0, 92.5 }, -- Scorching Roots
	[418637] = { 22.0, 22.0, 24.2, 36.3, 24.2, 28.6, 25.2, 43.1, 22.1, 24.1 }, -- Furious Charge
	[426206] = { 30.8, 24.2, 24.2, 38.5, 52.7, 64.0, 24.2, 24.2 }, -- Blazing Thorns
	[417634] = { 91.1, 101.4 }, -- Raging Inferno
	-- p2
	[427252] = { 7.4, 26.7, 25.0, 23.3, 30.0, 20.0, 25.0, 25.0, 25.0 }, -- Falling Embers
	[427299] = { 29.1, 56.8, 43.5 }, -- Flash Fire
	[427343] = { 54.2, 40.9, 32.5, 36.7, 36.6 }, -- Fire Whirl
	[429973] = { 14.2, 25.9, 30.0, 19.1, 29.2, 20.8, 30.0, 24.1 }, -- Smoldering Backdraft
	[421325] = { 20.9, 44.2, 42.5, 42.5, 38.3 }, -- Ashen Call
}
local timersMythic = {
	-- p1
	[417653] = { 6.6, 104.9, 98.7 }, -- Fiery Force of Nature
	[422614] = { 37.3, 110.5, 93.2 }, -- Scorching Roots
	[418637] = { 22.0, 21.9, 24.2, 35.7, 24.2, 28.6, 25.3, 43.8, 22.0, 24.1 }, -- Furious Charge
	[426206] = { 30.8, 24.1, 24.2, 37.9, 52.7, 64.6, 24.2, 24.2  }, -- Blazing Thorns
	[425889] = { 14.2, 123.7, 80.0 }, -- Igniting Growth
	-- p2
	[428896] = { 45.5 }, -- Ashen Devastation
	[427252] = { 7.4, 26.7, 35.9, 21.7 }, -- Falling Embers
	[427299] = { 29.0, 51.8 }, -- Flash Fire
	[427343] = { 64.9, 32.6 }, -- Fire Whirl
	[429973] = { 14.0, 25.9, 19.2, 26.7, 16.7 }, -- Smoldering Backdraft
	[421325] = { 20.7, 55.1 }, -- Ashen Call
}
local timers = mod:Easy() and timersNormal or mod:Mythic() and timersMythic or timersHeroic

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_repeating_yell_smoldering_suffocation = "Repeating Suffocation Health Yell"
	L.custom_on_repeating_yell_smoldering_suffocation_desc = "Repeating yell messages for Smoldering Suffocation to let others know when you are below 75% health."

	L.scorching_roots = "Roots"
	L.furious_charge = "Charge"
	L.blazing_thorns = "Dodges"
	L.falling_embers = "Soaks"
	L.smoldering_backdraft = "Frontal"
	L.fire_whirl = "Tornadoes"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		"berserk",
		-- Stage One: The Cycle of Flame
		417653, -- Fiery Force of Nature
		418520, -- Blistering Splinters
		426524, -- Fiery Flourish
		422614, -- Scorching Roots
		{420544, "PRIVATE"}, -- Scorching Pursuit
		426387, -- Scorching Bramblethorn
		418637, -- Furious Charge
		{423719, "TANK"}, -- Nature's Fury
		426206, -- Blazing Thorns
		426249, -- Blazing Coalescence (Player)
		"blazing_coalescence_boss", -- Blazing Coalescence (Boss) 426256
		{417634, "CASTBAR", "CASTBAR_COUNTDOWN"}, -- Raging Inferno
		417632, -- Burning Ground
		-- Mythic
		425889, -- Igniting Growth
		429032, -- Everlasting Blaze

		-- Intermission: Unreborn Again
		{421316, "CASTBAR"}, -- Consuming Flame

		-- Stage Two: Avatar of Ash
		427252, -- Falling Embers
		{427299, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Flash Fire
		{427306, "SAY"}, -- Encased in Ash
		427343, -- Fire Whirl
		429973, -- Smoldering Backdraft
		{421594, "SAY"}, -- Smoldering Suffocation
		"custom_on_repeating_yell_smoldering_suffocation",
		421325, -- Ashen Call
		{421407, "HEALER"}, -- Searing Ash
		{428896, "PRIVATE"}, -- Ashen Devastation
	},{
		["stages"] = "general",
		[417653] = -27241, -- Stage One: The Cycle of Flame
		[421316] = -27242, -- Intermission: Unreborn Again
		[427252] = -27243, -- Stage Two: Avatar of Ash
	},{
		[417653] = CL.adds, -- Fiery Force of Nature (Adds)
		[422614] = L.scorching_roots, -- Scorching Roots (Roots)
		[418637] = L.furious_charge, -- Furious Charge (Charge)
		[426206] = L.blazing_thorns, -- Blazing Thorns (Dodges)
		[427252] = L.falling_embers, -- Falling Embers (Soaks)
		[427299] = CL.bombs, -- Flash Fire (Bombs)
		[427343] = L.fire_whirl, -- Fire Whirl (Tornadoes)
		[421325] = CL.adds, -- Ashen Call (Adds)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1") -- Ashen Devastation

	-- Stage One: The Cycle of Flame
	self:Log("SPELL_CAST_SUCCESS", "FieryForceOfNature", 417653)
	self:Log("SPELL_AURA_APPLIED", "BlisteringSplintersApplied", 418520)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlisteringSplintersApplied", 418520)
	self:Log("SPELL_CAST_START", "FieryFlourish", 426524)
	self:Log("SPELL_CAST_START", "ScorchingRoots", 422614)
	self:Log("SPELL_AURA_APPLIED", "ScorchingBramblethorn", 426387)
	self:Log("SPELL_CAST_START", "FuriousCharge", 418637)
	self:Log("SPELL_AURA_APPLIED", "NaturesFuryApplied", 423719)
	self:Log("SPELL_CAST_START", "BlazingThorns", 426206)
	self:Log("SPELL_AURA_APPLIED", "BlazingCoalescenceApplied", 426249)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlazingCoalescenceApplied", 426249)
	self:Log("SPELL_AURA_APPLIED", "BlazingCoalescenceAppliedOnBoss", 426256)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlazingCoalescenceAppliedOnBoss", 426256)
	self:Log("SPELL_CAST_START", "RagingInferno", 417634)
	-- Mythic
	self:Log("SPELL_CAST_START", "IgnitingGrowth", 425889)
	self:Log("SPELL_AURA_APPLIED", "EverlastingBlazeApplied", 429032)

	-- Intermission: Unreborn Again
	self:Log("SPELL_AURA_APPLIED", "ConsumingFlame", 421316)
	-- self:Log("SPELL_AURA_APPLIED", "ConsumingFlame", 421316)
	self:Log("SPELL_AURA_REMOVED", "ConsumingFlameRemoved", 421316)

	-- Stage Two: Avatar of Ash
	-- self:Log("SPELL_CAST_SUCCESS", "AshenDevastation", 428896)
	self:Log("SPELL_CAST_START", "FallingEmbers", 427252)
	-- self:Log("SPELL_CAST_SUCCESS", "FlashFire", 421326)
	self:Log("SPELL_CAST_SUCCESS", "FlashFireApplied", 427299)
	self:Log("SPELL_AURA_REMOVED", "FlashFireRemoved", 427299)
	self:Log("SPELL_AURA_APPLIED", "EncasedInAshApplied", 427306)
	self:Log("SPELL_CAST_START", "FireWhirl", 427343)
	self:Log("SPELL_CAST_START", "SmolderingBackdraft", 429973, 421318) -- heroic, mythic?
	self:Log("SPELL_AURA_APPLIED", "SmolderingSuffocationApplied", 421594)
	self:Log("SPELL_AURA_REMOVED", "SmolderingSuffocationRemoved", 421594)
	self:Log("SPELL_CAST_START", "AshenCall", 421325)
	self:Log("SPELL_CAST_SUCCESS", "SearingAsh", 421407)
	self:Log("SPELL_CAST_SUCCESS", "BerserkCast", 26662)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 417632) -- Burning Ground
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 417632)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 417632)
end

function mod:OnEngage()
	timers = self:Easy() and timersNormal or timersHeroic
	self:SetStage(1)
	fieryForceOfNatureCount = 1
	scorchingRootsCount = 1
	furiousChargeCount = 1
	blazingThornsCount = 1
	ragingInfernoCount = 1
	ignitingGrowthCount = 1

	searingAshCount = 1
	fallingEmbersCount = 1
	flashFireCount = 1
	fireWhirlCount = 1
	smolderingBackdraftCount = 1
	ashenCallCount = 1
	ashenDevastationCount = 1

	if self:Mythic() then
		self:Berserk(401, 0) -- ~6:41
	end
	self:Bar(417653, timers[417653][fieryForceOfNatureCount], CL.count:format(CL.adds, fieryForceOfNatureCount)) -- Fiery Force of Nature
	self:Bar(426206, timers[426206][blazingThornsCount], CL.count:format(L.blazing_thorns, blazingThornsCount)) -- Blazing Thorns
	self:Bar(418637, timers[418637][furiousChargeCount], CL.count:format(L.furious_charge, furiousChargeCount)) -- Furious Charge
	self:Bar(422614, timers[422614][scorchingRootsCount], CL.count:format(L.scorching_roots, scorchingRootsCount)) -- Scorching Roots
	self:Bar(417634, 90, CL.count:format(self:SpellName(417634), ragingInfernoCount)) -- Raging Inferno

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")

	self:SetPrivateAuraSound(420544) -- Scorching Pursuit
	-- self:SetPrivateAuraSound(427299, 421461, "alarm") -- Flash Fire
	if self:Mythic() then
		self:SetPrivateAuraSound(428896, 428901) -- Ashen Devastation
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 43 then -- Intermission at 40%
		self:UnregisterUnitEvent(event, unit)
		self:Message("stages", "cyan", CL.soon:format(CL.intermission), false)
		self:PlaySound("stages", "info")
	end
end

function mod:FieryForceOfNature(args)
	self:StopBar(CL.count:format(CL.adds, fieryForceOfNatureCount))
	self:Message(args.spellId, "cyan", CL.count:format(CL.adds, fieryForceOfNatureCount))
	self:PlaySound(args.spellId, "info")
	fieryForceOfNatureCount = fieryForceOfNatureCount + 1
	self:Bar(args.spellId, timers[args.spellId][fieryForceOfNatureCount], CL.count:format(CL.adds, fieryForceOfNatureCount))
end

function mod:BlisteringSplintersApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 1 then -- 1, 3, 5...
			self:StackMessage(args.spellId, "blue", args.destName, amount, 3)
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:FieryFlourish(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:ScorchingRoots(args)
	self:StopBar(CL.count:format(L.scorching_roots, scorchingRootsCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.scorching_roots, scorchingRootsCount))
	self:PlaySound(args.spellId, "alert")
	scorchingRootsCount = scorchingRootsCount + 1
	self:Bar(args.spellId, timers[args.spellId][scorchingRootsCount], CL.count:format(L.scorching_roots, scorchingRootsCount))
end

function mod:ScorchingBramblethorn(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:FuriousCharge(args)
	self:StopBar(CL.count:format(L.furious_charge, furiousChargeCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.furious_charge, furiousChargeCount))
	self:PlaySound(args.spellId, "alert")
	furiousChargeCount = furiousChargeCount + 1
	self:Bar(args.spellId, timers[args.spellId][furiousChargeCount], CL.count:format(L.furious_charge, furiousChargeCount))
end

function mod:NaturesFuryApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:BlazingThorns(args)
	self:StopBar(CL.count:format(L.blazing_thorns, blazingThornsCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.blazing_thorns, blazingThornsCount))
	self:PlaySound(args.spellId, "alert")
	blazingThornsCount = blazingThornsCount + 1
	self:Bar(args.spellId, timers[args.spellId][blazingThornsCount], CL.count:format(L.blazing_thorns, blazingThornsCount))
end

function mod:BlazingCoalescenceApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
		self:PlaySound(args.spellId, "info")
	end
end

function mod:BlazingCoalescenceAppliedOnBoss(args)
	self:StackMessage("blazing_coalescence_boss", "red", args.destName, args.amount, 1, args.spellId)
	self:PlaySound("blazing_coalescence_boss", "alarm")
end

function mod:RagingInferno(args)
	self:StopBar(CL.count:format(args.spellName, ragingInfernoCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, ragingInfernoCount))
	self:PlaySound(args.spellId, "long")
	ragingInfernoCount = ragingInfernoCount + 1
	self:Bar(args.spellId, 102, CL.count:format(args.spellName, ragingInfernoCount))
	self:CastBar(args.spellId, 4, args.spellName)
end

function mod:IgnitingGrowth(args)
	self:StopBar(CL.count:format(args.spellName, ignitingGrowthCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, ignitingGrowthCount))
	-- self:PlaySound(args.spellId, "alert")
	ignitingGrowthCount = ignitingGrowthCount + 1
	self:Bar(args.spellId, timers[args.spellId][ignitingGrowthCount], CL.count:format(args.spellName, ignitingGrowthCount))
end

function mod:EverlastingBlazeApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount or 1, 1)
		self:PlaySound(args.spellId, "alarm")
	end
end

-- Intermission: Unreborn Again
function mod:ConsumingFlame(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")

	self:SetStage(1.5)
	self:StopBar(CL.count:format(CL.adds, fieryForceOfNatureCount)) -- Fiery Force of Nature
	self:StopBar(CL.count:format(L.scorching_roots, scorchingRootsCount)) -- Scorching Roots
	self:StopBar(CL.count:format(L.furious_charge, furiousChargeCount)) -- Furious Charge
	self:StopBar(CL.count:format(L.blazing_thorns, blazingThornsCount)) -- Blazing Thorns
	self:StopBar(CL.count:format(self:SpellName(417634), ragingInfernoCount)) -- Raging Inferno

	self:CastBar(args.spellId, 16)
end

-- Stage Two: Avatar of Ash
function mod:ConsumingFlameRemoved(args)
	self:StopBar(args.spellId)

	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long")
	self:SetStage(2)

	flashFireCount = 1
	smolderingBackdraftCount = 1
	ashenCallCount = 1
	fallingEmbersCount = 1
	searingAshCount = 1
	fireWhirlCount = 1

	self:Bar(421407, 2.5, CL.count:format(self:SpellName(421407), searingAshCount)) -- Searing Ash
	self:Bar(427252, timers[427252][fallingEmbersCount], CL.count:format(L.falling_embers, fallingEmbersCount)) -- Falling Embers
	self:Bar(429973, timers[429973][smolderingBackdraftCount], CL.count:format(L.smoldering_backdraft, smolderingBackdraftCount)) -- Smoldering Backdraft
	self:Bar(421325, timers[421325][ashenCallCount], CL.count:format(CL.adds, ashenCallCount)) -- Ashen Call
	self:Bar(427299, timers[427299][flashFireCount], CL.count:format(CL.bombs, flashFireCount)) -- Flash Fire
	self:Bar(427343, timers[427343][fireWhirlCount], CL.count:format(L.fire_whirl, fireWhirlCount)) -- Fire Whirl
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 428896 then -- Ashen Devastation
		local spellName = self:SpellName(spellId)
		self:Message(428896, "orange", CL.count:format(spellName, ashenDevastationCount))
		-- self:PlaySound(428896, "alert")
		ashenDevastationCount = ashenDevastationCount + 1
		self:CDBar(428896, timers[428896][ashenDevastationCount] or (self:Easy() and 50), CL.count:format(spellName, ashenDevastationCount))
	end
end

function mod:FallingEmbers(args)
	self:StopBar(CL.count:format(L.falling_embers, fallingEmbersCount))
	self:Message(args.spellId, "red", CL.count:format(L.falling_embers, fallingEmbersCount))
	self:PlaySound(args.spellId, "long")
	fallingEmbersCount = fallingEmbersCount + 1
	self:Bar(args.spellId, timers[args.spellId][fallingEmbersCount], CL.count:format(L.falling_embers, fallingEmbersCount))
end

do
	local playerList = {}
	local prev = 0
	function mod:FlashFireApplied(args)
		local msg = CL.count:format(CL.bombs, flashFireCount)
		if args.time - prev > 2 then -- reset
			prev = args.time
			playerList = {}
			self:StopBar(msg)
			flashFireCount = flashFireCount + 1
			self:Bar(args.spellId, timers[args.spellId][flashFireCount] or (self:Easy() and 50), CL.count:format(CL.bombs, flashFireCount))
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			-- self:PersonalMessage(args.spellId, nil, CL.bomb)
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, CL.bomb)
			self:SayCountdown(args.spellId, 8)
		end
		self:TargetsMessage(args.spellId, "red", playerList, nil, msg)
	end

	function mod:FlashFireRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:EncasedInAshApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
	end
end

function mod:FireWhirl(args)
	self:StopBar(CL.count:format(L.fire_whirl, fireWhirlCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.fire_whirl, fireWhirlCount))
	self:PlaySound(args.spellId, "alert")
	fireWhirlCount = fireWhirlCount + 1
	self:Bar(args.spellId, timers[args.spellId][fireWhirlCount], CL.count:format(L.fire_whirl, fireWhirlCount))
end

do
	local smolderingSuffocationOnMe = false
	local function RepeatingChatMessages()
		if smolderingSuffocationOnMe then
			local currentHealthPercent = math.floor(mod:GetHealth("player"))
			if currentHealthPercent < 75 then -- Only let players know when you are below 75%
				local myIcon = GetRaidTargetIndex("player")
				if myIcon then
					mod:Yell(false, ("{rt%d}%d%%"):format(myIcon, currentHealthPercent), true)
				else
					mod:Yell(false, ("%d%%"):format(currentHealthPercent), true)
				end
			end
		else
			return -- Nothing had to be repeated, stop repeating
		end
		mod:SimpleTimer(RepeatingChatMessages, 2)
	end

	function mod:SmolderingBackdraft(args)
		self:StopBar(CL.count:format(L.smoldering_backdraft, smolderingBackdraftCount))
		self:Message(429973, "purple", CL.count:format(L.smoldering_backdraft, smolderingBackdraftCount))
		self:PlaySound(429973, "alarm")
		smolderingBackdraftCount = smolderingBackdraftCount + 1
		self:Bar(429973, timers[429973][smolderingBackdraftCount], CL.count:format(L.smoldering_backdraft, smolderingBackdraftCount))
	end

	function mod:SmolderingSuffocationApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning")
			self:Yell(args.spellId)
			smolderingSuffocationOnMe = true
			if self:GetOption("custom_on_repeating_yell_smoldering_suffocation") then
				self:SimpleTimer(RepeatingChatMessages, 2)
			end
		end
	end

	function mod:SmolderingSuffocationRemoved(args)
		if self:Me(args.destGUID) then
			smolderingSuffocationOnMe = false
		end
	end
end

function mod:AshenCall(args)
	self:StopBar(CL.count:format(CL.adds, ashenCallCount))
	self:Message(args.spellId, "cyan", CL.count:format(CL.adds, ashenCallCount))
	self:PlaySound(args.spellId, "info")
	ashenCallCount = ashenCallCount + 1
	self:Bar(args.spellId, timers[args.spellId][ashenCallCount], CL.count:format(CL.adds, ashenCallCount))
end

do
	local prev = 0
	function mod:SearingAsh(args)
		if args.time - prev > 2 then
			prev = args.time
			self:Message(args.spellId, "yellow", CL.count:format(args.spellName, searingAshCount))
			searingAshCount = searingAshCount + 1
			self:Bar(args.spellId, 12, CL.count:format(args.spellName, searingAshCount))
		end
	end
end

function mod:BerserkCast(args)
	self:StopBar(args.spellName)
	self:Message("berserk", "red", CL.custom_end:format(args.sourceName, args.spellName), args.spellId)
	self:PlaySound("berserk", "alarm")
end

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
