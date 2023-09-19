if not BigWigsLoader.onTestBuild then return end
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

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_repeating_yell_smoldering_suffocation = "Repeating Suffocation Health Yell"
	L.custom_on_repeating_yell_smoldering_suffocation_desc = "Repeating yell messages for Smoldering Suffocation to let others know when you are below 75% health."

	L.currentHealth = "%d%%"
	L.currentHealthIcon = "{rt%d}%d%%"
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
		417660, -- Scorching Roots
		{420546, "SAY"}, -- Scorching Pursuit
		426387, -- Scorching Bramblethorn
		418637, -- Furious Charge
		{423719, "TANK"}, -- Nature's Fury
		426206, -- Blazing Thorns
		426249, -- Blazing Coalescence (Player)
		426256, -- Blazing Coalescence (Boss)
		417634, -- Raging Inferno
		417632, -- Burning Ground
		-- Intermission: Unreborn Again
		421316, -- Consuming Flame
		-- Stage Two: Avatar of Ash
		421333, -- Falling Embers
		{421461, "SAY", "SAY_COUNTDOWN"}, -- Flash Fire
		{421463, "SAY"}, -- Encased in Ash
		421318, -- Smoldering Backdraft
		{421594, "SAY"}, -- Smoldering Suffocation
		"custom_on_repeating_yell_smoldering_suffocation",
		422461, -- Ashen Call
		421323, -- Searing Ash
	}
end

function mod:OnBossEnable()
	-- Stage One: The Cycle of Flame
	self:Log("SPELL_CAST_SUCCESS", "FieryForceOfNature", 417653)
	self:Log("SPELL_AURA_APPLIED", "BlisteringSplintersApplied", 418520)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BlisteringSplintersApplied", 418520)
	self:Log("SPELL_CAST_START", "FieryFlourish", 426524)
	self:Log("SPELL_CAST_SUCCESS", "ScorchingRoots", 417660)
	self:Log("SPELL_AURA_APPLIED", "ScorchingPursuit", 420546)
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
	self:Log("SPELL_CAST_SUCCESS", "FlashFire", 421326)
	self:Log("SPELL_AURA_APPLIED", "FlashFireApplied", 421461)
	self:Log("SPELL_AURA_REMOVED", "FlashFireRemoved", 421461)
	self:Log("SPELL_AURA_APPLIED", "EncasedInAshApplied", 421463)
	self:Log("SPELL_CAST_START", "SmolderingBackdraft", 421318)
	self:Log("SPELL_AURA_APPLIED", "SmolderingSuffocationApplied", 421594)
	self:Log("SPELL_AURA_REMOVED", "SmolderingSuffocationRemoved", 421594)
	self:Log("SPELL_CAST_SUCCESS", "AshenCall", 422461)
	self:Log("SPELL_AURA_APPLIED", "SearingAshApplied", 421323)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SearingAshApplied", 421323)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 417632, 421333) -- Burning Ground, Falling Embers XXX Check Falling Embers id
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 417632, 421333)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 417632, 421333)
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

	--self:Bar(417653, 30, CL.count:format(self:SpellName(417653), fieryForceOfNatureCount)) -- Fiery Force of Nature
	--self:Bar(417660, 30, CL.count:format(self:SpellName(417660), scorchingRootsCount)) -- Scorching Roots
	--self:Bar(418637, 30, CL.count:format(self:SpellName(418637), furiousChargeCount)) -- Furious Charge
	--self:Bar(426206, 30, CL.count:format(self:SpellName(426206), blazingThornsCount)) -- Blazing Thorns
	--self:Bar(417634, 30, CL.count:format(self:SpellName(417634), ragingInfernoCount)) -- Raging Inferno

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
	self:StopBar(CL.count:format(args.spellName, fieryForceOfNatureCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, fieryForceOfNatureCount))
	self:PlaySound(args.spellId, "info")
	fieryForceOfNatureCount = fieryForceOfNatureCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(args.spellName, fieryForceOfNatureCount))
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
	self:StopBar(CL.count:format(args.spellName, scorchingRootsCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, scorchingRootsCount))
	self:PlaySound(args.spellId, "alert")
	scorchingRootsCount = scorchingRootsCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(args.spellName, scorchingRootsCount))
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
	self:StopBar(CL.count:format(args.spellName, furiousChargeCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, furiousChargeCount))
	self:PlaySound(args.spellId, "alert")
	furiousChargeCount = furiousChargeCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(args.spellName, furiousChargeCount))
end

function mod:NaturesFuryApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 1)
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:BlazingThorns(args)
	self:StopBar(CL.count:format(args.spellName, blazingThornsCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, blazingThornsCount))
	self:PlaySound(args.spellId, "alert")
	blazingThornsCount = blazingThornsCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(args.spellName, blazingThornsCount))
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
	--self:Bar(args.spellId, 20, CL.count:format(args.spellName, ragingInfernoCount))
end


-- Intermission: Unreborn Again
function mod:ConsumingFlame(args)
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, ragingInfernoCount))
	self:PlaySound(args.spellId, "long")

	self:SetStage(1.5)
	self:StopBar(CL.count:format(self:SpellName(417653), fieryForceOfNatureCount)) -- Fiery Force of Nature
	self:StopBar(CL.count:format(self:SpellName(417660), scorchingRootsCount)) -- Scorching Roots
	self:StopBar(CL.count:format(self:SpellName(418637), furiousChargeCount)) -- Furious Charge
	self:StopBar(CL.count:format(self:SpellName(426206), blazingThornsCount)) -- Blazing Thorns
	self:StopBar(CL.count:format(self:SpellName(417634), ragingInfernoCount)) -- Raging Inferno

	self:Bar(args.spellId, 16)
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

	--self:Bar(421326, 30, CL.count:format(self:SpellName(421326), flashFireCount)) -- Flash Fire
	--self:Bar(421318, 30, CL.count:format(self:SpellName(421318), smolderingBackdraftCount)) -- Smoldering Backdraft
	--self:Bar(422461, 30, CL.count:format(self:SpellName(422461), ashenCallCount)) -- Ashen Call
end

do
	local playerList = {}
	function mod:FlashFire(args)
		playerList = {}
		self:StopBar(CL.count:format(args.spellName, flashFireCount))
		-- self:Message(421461, "yellow", CL.count:format(args.spellName, flashFireCount))
		-- self:PlaySound(421461, "alert")
		flashFireCount = flashFireCount + 1
		--self:Bar(414888, 20, CL.count:format(args.spellName, flashFireCount))
	end

	function mod:FlashFireApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 6)
		end
		self:TargetsMessage(args.spellId, "red", playerList, nil, CL.count:format(args.spellName, flashFireCount-1))
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
		self:StopBar(CL.count:format(args.spellName, smolderingBackdraftCount))
		self:Message(args.spellId, "purple", CL.count:format(args.spellName, smolderingBackdraftCount))
		self:PlaySound(args.spellId, "alarm")
		smolderingBackdraftCount = smolderingBackdraftCount + 1
		--self:Bar(args.spellId, 20, CL.count:format(args.spellName, smolderingBackdraftCount))
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
	self:StopBar(CL.count:format(args.spellName, ashenCallCount))
	self:Message(args.spellId, "cyan", CL.count:format(args.spellName, ashenCallCount))
	self:PlaySound(args.spellId, "info")
	ashenCallCount = ashenCallCount + 1
	--self:Bar(args.spellId, 20, CL.count:format(args.spellName, ashenCallCount))
end

function mod:SearingAshApplied(args)
	self:StackMessage(args.spellId, "yellow", args.destName, args.amount, 1)
	local stacks = args.amount or 1
	self:Bar(args.spellId, 12, CL.count:format(args.spellName, stacks + 1))
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
