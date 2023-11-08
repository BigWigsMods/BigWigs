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
local flashFireCount = 1
local smolderingBackdraftCount = 1
local ashenCallCount = 1
local fallingEmbersCount = 1
local searingAshCount = 1
local fireWhirlCount = 1

--------------------------------------------------------------------------------
-- Timers
--

local timers = {
	[1] = {
		[417653] = {6.0, 113.4, 44.0, 64.7, 114.5}, -- Fiery Force of Nature
		[422614] = {30.1, 113.3, 108.7}, -- Scorching Roots
		[418637] = {20.0, 20.0, 20.1, 52.5, 19.9, 20.0, 20.0, 69.6, 20.0, 20.0, 53.5}, -- Furious Charge
		[426206] = {14.0, 36.0, 74.5, 111.6, 36.0, 75.6}, -- Blazing Thorns
	},
	[2] = {
		[427252] = {7.4, 35.1, 20.0, 33.4, 16.7, 33.4, 25.0, 33.4, 16.7, 33.4, 16.7, 41.7, 16.7, 33.4, 16.7, 33.4}, -- Falling Embers
		[427299] = {34.1, 45.0, 41.7, 41.8, 50.1, 50.1, 41.7, 41.7, 41.8}, -- Flash Fire
		[427343] = {54.1, 50.1, 50.1, 41.7, 41.8, 41.8, 41.7, 50.1}, -- Fire Whirl
		[421318] = {17.4, 53.4, 58.4, 50.1, 50.1, 58.5, 50.0, 58.5}, -- Smoldering Backdraft
		[421325] = {25.8, 61.7, 50.1, 50.1, 58.5, 50.1, 58.4, 50.1}, -- Ashen Call
	},
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_repeating_yell_smoldering_suffocation = "Repeating Suffocation Health Yell"
	L.custom_on_repeating_yell_smoldering_suffocation_desc = "Repeating yell messages for Smoldering Suffocation to let others know when you are below 75% health."

	L.currentHealth = "%d%%"
	L.currentHealthIcon = "{rt%d}%d%%"

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
		-- Stage One: The Cycle of Flame
		417653, -- Fiery Force of Nature
		418520, -- Blistering Splinters
		426524, -- Fiery Flourish
		422614, -- Scorching Roots
		{420544, "SAY"}, -- Scorching Pursuit
		426387, -- Scorching Bramblethorn
		418637, -- Furious Charge
		{423719, "TANK"}, -- Nature's Fury
		426206, -- Blazing Thorns
		426249, -- Blazing Coalescence (Player)
		426256, -- Blazing Coalescence (Boss)
		417634, -- Raging Inferno
		417632, -- Burning Ground
		-- Intermission: Unreborn Again
		{421316, "CASTBAR"}, -- Consuming Flame
		-- Stage Two: Avatar of Ash
		427252, -- Falling Embers
		{427299, "SAY", "SAY_COUNTDOWN"}, -- Flash Fire
		{427306, "SAY"}, -- Encased in Ash
		427343, -- Fire Whirl
		421318, -- Smoldering Backdraft
		{421594, "SAY"}, -- Smoldering Suffocation
		"custom_on_repeating_yell_smoldering_suffocation",
		421325, -- Ashen Call
		{421407, "HEALER"}, -- Searing Ash
	},{
		["stages"] = "general",
		[417653] = -27241, -- Stage One: The Cycle of Flame
		[421316] = -27242, -- Intermission: Unreborn Again
		[421333] = -27243, -- Stage Two: Avatar of Ash
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
	-- Stage One: The Cycle of Flame
	self:Log("SPELL_CAST_SUCCESS", "FieryForceOfNature", 417653)
	self:Log("SPELL_AURA_APPLIED", "BlisteringSplintersApplied", 418520)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlisteringSplintersApplied", 418520)
	self:Log("SPELL_CAST_START", "FieryFlourish", 426524)
	self:Log("SPELL_CAST_START", "ScorchingRoots", 422614)
	self:Log("SPELL_AURA_APPLIED", "ScorchingPursuit", 420544)
	self:Log("SPELL_AURA_APPLIED", "ScorchingBramblethorn", 426387)
	self:Log("SPELL_CAST_START", "FuriousCharge", 418637)
	self:Log("SPELL_AURA_APPLIED", "NaturesFuryApplied", 423719)
	self:Log("SPELL_CAST_START", "BlazingThorns", 426206)
	self:Log("SPELL_AURA_APPLIED", "BlazingCoalescenceApplied", 426249)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlazingCoalescenceApplied", 426249)
	self:Log("SPELL_AURA_APPLIED", "BlazingCoalescenceAppliedOnBoss", 426256)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlazingCoalescenceAppliedOnBoss", 426256)
	self:Log("SPELL_CAST_START", "RagingInferno", 417634)

	-- Intermission: Unreborn Again
	self:Log("SPELL_AURA_APPLIED", "ConsumingFlame", 421316)
	self:Log("SPELL_AURA_REMOVED", "ConsumingFlameRemoved", 421316)

	-- Stage Two: Avatar of Ash
	self:Log("SPELL_CAST_START", "FallingEmbers", 427252)
	self:Log("SPELL_CAST_SUCCESS", "FlashFireApplied", 427299)
	self:Log("SPELL_AURA_REMOVED", "FlashFireRemoved", 427299)
	self:Log("SPELL_AURA_APPLIED", "EncasedInAshApplied", 427306)
	self:Log("SPELL_CAST_START", "FireWhirl", 427343)
	self:Log("SPELL_CAST_START", "SmolderingBackdraft", 421318)
	self:Log("SPELL_AURA_APPLIED", "SmolderingSuffocationApplied", 421594)
	self:Log("SPELL_AURA_REMOVED", "SmolderingSuffocationRemoved", 421594)
	self:Log("SPELL_CAST_START", "AshenCall", 421325)
	self:Log("SPELL_CAST_SUCCESS", "SearingAsh", 421407)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 417632) -- Burning Ground
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 417632)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 417632)
end

function mod:OnEngage()
	self:SetStage(1)
	fieryForceOfNatureCount = 1
	scorchingRootsCount = 1
	furiousChargeCount = 1
	blazingThornsCount = 1
	ragingInfernoCount = 1
	flashFireCount = 1
	smolderingBackdraftCount = 1
	ashenCallCount = 1
	fallingEmbersCount = 1
	searingAshCount = 1
	fireWhirlCount = 1

	self:Bar(417653, timers[1][417653][fieryForceOfNatureCount], CL.count:format(CL.adds, fieryForceOfNatureCount)) -- Fiery Force of Nature
	self:Bar(426206, timers[1][426206][blazingThornsCount], CL.count:format(L.blazing_thorns, blazingThornsCount)) -- Blazing Thorns
	self:Bar(418637, timers[1][418637][furiousChargeCount], CL.count:format(L.furious_charge, furiousChargeCount)) -- Furious Charge
	self:Bar(422614, timers[1][422614][scorchingRootsCount], CL.count:format(L.scorching_roots, scorchingRootsCount)) -- Scorching Roots
	self:Bar(417634, 100, CL.count:format(self:SpellName(417634), ragingInfernoCount)) -- Raging Inferno

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
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
	self:Bar(args.spellId, timers[1][args.spellId][fieryForceOfNatureCount], CL.count:format(CL.adds, fieryForceOfNatureCount))
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
	self:Bar(args.spellId, timers[1][args.spellId][scorchingRootsCount], CL.count:format(L.scorching_roots, scorchingRootsCount))
end

function mod:ScorchingPursuit(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
	end
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
	self:Bar(args.spellId, timers[1][args.spellId][furiousChargeCount], CL.count:format(L.furious_charge, furiousChargeCount))
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
	self:Bar(args.spellId, timers[1][args.spellId][blazingThornsCount], CL.count:format(L.blazing_thorns, blazingThornsCount))
end

function mod:BlazingCoalescenceApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:BlazingCoalescenceAppliedOnBoss(args)
	self:StackMessage(args.spellId, "red", args.destName, args.amount, 1)
	self:PlaySound(args.spellId, "alert")
end

function mod:RagingInferno(args)
	self:StopBar(CL.count:format(args.spellName, ragingInfernoCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, ragingInfernoCount))
	self:PlaySound(args.spellId, "long")
	ragingInfernoCount = ragingInfernoCount + 1
	self:Bar(args.spellId, 111, CL.count:format(args.spellName, ragingInfernoCount))
end

-- Intermission: Unreborn Again
function mod:ConsumingFlame(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, ragingInfernoCount))
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
	self:Bar(427252, timers[2][427252][fallingEmbersCount], CL.count:format(L.falling_embers, fallingEmbersCount)) -- Falling Embers
	self:Bar(421318, timers[2][421318][smolderingBackdraftCount], CL.count:format(L.smoldering_backdraft, smolderingBackdraftCount)) -- Smoldering Backdraft
	self:Bar(421325, timers[2][421325][ashenCallCount], CL.count:format(CL.adds, ashenCallCount)) -- Ashen Call
	self:Bar(427299, timers[2][427299][flashFireCount], CL.count:format(CL.bombs, flashFireCount)) -- Flash Fire
	self:Bar(427343, timers[2][427343][fireWhirlCount], CL.count:format(L.fire_whirl, fireWhirlCount)) -- Fire Whirl
end

function mod:FallingEmbers(args)
	self:StopBar(CL.count:format(L.falling_embers, fallingEmbersCount))
	self:Message(args.spellId, "red", CL.count:format(L.falling_embers, fallingEmbersCount))
	self:PlaySound(args.spellId, "long")
	fallingEmbersCount = fallingEmbersCount + 1
	self:Bar(args.spellId, timers[2][args.spellId][fallingEmbersCount], CL.count:format(L.falling_embers, fallingEmbersCount))
end

do
	local playerList = {}
	local prev = 0
	function mod:FlashFireApplied(args)
		local msg = CL.count:format(CL.bombs, flashFireCount)
		if args.time - prev > 2 then -- reset
			playerList = {}
			prev = args.time
			self:StopBar(msg)
			--self:Message(args.spellId, "yellow", msg)
			playerList = {}
			-- self:Message(args.spellId, "yellow", CL.count:format(CL.bombs, flashFireCount))
			-- self:PlaySound(args.spellId, "alert")
			flashFireCount = flashFireCount + 1
			self:Bar(args.spellId, timers[2][args.spellId][flashFireCount], CL.count:format(CL.bombs, flashFireCount))
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, CL.bomb)
			self:SayCountdown(args.spellId, 6)
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
	self:Bar(args.spellId, timers[2][args.spellId][fireWhirlCount], CL.count:format(L.fire_whirl, fireWhirlCount))
end

do
	local smolderingSuffocationOnMe = false
	local function RepeatingChatMessages()
		if smolderingSuffocationOnMe then
			local currentHealthPercent = math.floor(mod:GetHealth("player"))
			if currentHealthPercent < 75 then -- Only let players know when you are below 75%
				local myIcon = GetRaidTargetIndex("player")
				local msg = myIcon and L.currentHealthIcon:format(myIcon, currentHealthPercent) or L.currentHealth:format(currentHealthPercent)
				mod:Yell(false, msg, true)
			end
		else
			return -- Nothing had to be repeated, stop repeating
		end
		mod:SimpleTimer(RepeatingChatMessages, 2)
	end

	function mod:SmolderingBackdraft(args)
		self:StopBar(CL.count:format(L.smoldering_backdraft, smolderingBackdraftCount))
		self:Message(args.spellId, "purple", CL.count:format(L.smoldering_backdraft, smolderingBackdraftCount))
		self:PlaySound(args.spellId, "alarm")
		smolderingBackdraftCount = smolderingBackdraftCount + 1
		self:Bar(args.spellId, timers[2][args.spellId][smolderingBackdraftCount], CL.count:format(L.smoldering_backdraft, smolderingBackdraftCount))
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
	self:Bar(args.spellId, timers[2][args.spellId][ashenCallCount], CL.count:format(CL.adds, ashenCallCount))
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
