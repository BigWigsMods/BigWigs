if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Broodkeeper Diurna", 2522, 2493)
if not mod then return end
mod:RegisterEnableMob(190245) -- Broodkeeper Diurna
mod:SetEncounterID(2614)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.eggs_remaining = "%d Eggs Remaining!"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Stage One: The Primalist Clutch
		375809, -- Broodkeeper's Bond
		380175, -- Greatstaff of the Broodkeeper
		{375889, "SAY"}, -- Greatstaff's Wrath
		375829, -- Clutchwatcher's Rage
		376073, -- Rapid Incubation
		{389049, "EMPHASIZE"}, -- Incubating Seed XXX INFOBOX WITH STACK COUNTS?
		375871, -- Wildfire
		388716, -- Icy Shroud
		{375870, "TANK_HEALER"},
		{378782, "TANK"}, -- Mortal Wounds
		-- Primalist Mage
		375716, -- Ice Barrage
		-- Tarasek Earthreaver
		{376266, "TANK"}, -- Burrowing Strike
		376257, -- Tremors
		-- Dragonspawn Flamebender
		375485, -- Cauterizing Flashflames
		375575, -- Flame Sentry
		-- Juvenile Frost Proto-Dragon
		{375475, "TANK"}, -- Rending Bite
		375457, -- Chilling Tantrum
		-- Drakonid Stormbringer
		375653, -- Static Jolt
		{375630, "SAY"}, -- Ionizing Charge
		-- Stage Two: A Broodkeeper Scorned
		375879, -- Broodkeeper's Fury
		392194, -- Empowered Greatstaff of the Broodkeeper
		{380483, "SAY"}, -- Empowered Greatstaff's Wrath
		388918, -- Frozen Shroud
	}, {
		[375809] = -25119, -- Stage One: The Primalist Clutch
		[375716] = -25144, -- Primalist Mage
		[376266] = -25130, -- Tarasek Earthreaver
		[375485] = -25133, -- Dragonspawn Flamebender
		[375475] = -25136, -- Juvenile Frost Proto-Dragon
		[375653] = -25139, -- Drakonid Stormbringer
		[375879] = -25146, -- Stage Two: A Broodkeeper Scorned
	}
end

function mod:OnBossEnable()
	-- Stage One: The Primalist Clutch
	self:Log("SPELL_AURA_REMOVED_DOSE", "BroodkeepersBondStacks", 375809)
	self:Log("SPELL_AURA_REMOVED", "BroodkeepersBondRemoved", 375809)
	self:Log("SPELL_CAST_SUCCESS", "GreatstaffOfTheBroodkeeper", 380175, 392194) -- Stage 1, Stage 2 (Empowered)
	self:Log("SPELL_AURA_APPLIED", "GreatstaffsWrathApplied", 375889, 380483) -- Stage 1, Stage 2 (Empowered)
	self:Log("SPELL_AURA_APPLIED", "ClutchwatchersRage", 375829)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ClutchwatchersRage", 375829)
	self:Log("SPELL_CAST_START", "RapidIncubation", 376073)
	self:Log("SPELL_AURA_APPLIED", "IncubatingSeed", 389049)
	self:Log("SPELL_AURA_APPLIED_DOSE", "IncubatingSeed", 389049)
	self:Log("SPELL_CAST_START", "Wildfire", 375871)
	self:Log("SPELL_CAST_START", "IcyShroud", 388716, 388918) -- Stage 1, Stage 2 (Frozen Shroud)
	self:Log("SPELL_CAST_START", "MortalStoneclaws", 375870)
	self:Log("SPELL_AURA_APPLIED", "MortalWounds", 378782)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MortalWounds", 378782)
	-- Primalist Mage
	self:Log("SPELL_CAST_START", "IceBarrage", 375716)
	-- Tarasek Earthreaver
	self:Log("SPELL_CAST_SUCCESS", "BurrowingStrike", 376266)
	self:Log("SPELL_AURA_APPLIED", "BurrowingStrikeApplied", 376266)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BurrowingStrikeApplied", 376266)
	self:Log("SPELL_CAST_START", "Tremors", 376257)
	-- Dragonspawn Flamebender
	self:Log("SPELL_CAST_START", "CauterizingFlashflames", 375485)
	self:Log("SPELL_CAST_START", "FlameSentry", 375575)
	-- Juvenile Frost Proto-Dragon
	self:Log("SPELL_CAST_SUCCESS", "RendingBite", 375475)
	self:Log("SPELL_AURA_APPLIED", "RendingBiteApplied", 375475)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RendingBiteApplied", 375475)
	self:Log("SPELL_CAST_START", "ChillingTantrum", 375457)
	-- Drakonid Stormbringer
	self:Log("SPELL_CAST_START", "StaticJolt", 375653)
	self:Log("SPELL_CAST_START", "IonizingCharge", 375630)
	self:Log("SPELL_AURA_APPLIED", "IonizingChargeApplied", 375630)

	-- Stage Two: A Broodkeeper Scorned
	self:Log("SPELL_AURA_APPLIED", "BroodkeepersFury", 375879)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BroodkeepersFury", 375879)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 375575) -- Flame Sentry
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 375575)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 375575)
end

function mod:OnEngage()

end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: The Primalist Clutch
do
	local stacks = 0
	local scheduled = nil
	function mod:BroodkeepersBondMessage()
		mod:Message(375809, "cyan", L.eggs_remaining:format(stacks))
		mod:PlaySound(375809, "info")
		scheduled = nil
	end

	function mod:BroodkeepersBondStacks(args)
		stacks = args.amount or 0
		if not scheduled then
			scheduled = self:ScheduleTimer("BroodkeepersBondMessage", 2) -- Throttle here
		end
	end

	function mod:BroodkeepersBondRemoved(args)
		if scheduled then
			self:CancelTimer(scheduled)
			scheduled = nil
		end
		self:Message(args.spellId, "green", L.eggs_remaining:format(0))
		self:PlaySound(args.spellId, "long")
	end
end

function mod:GreatstaffOfTheBroodkeeper(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 20)
end

function mod:GreatstaffsWrathApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
	end
end

function mod:ClutchwatchersRage(args)
	self:StackMessage(args.spellId, "orange", args.destName, args.amount, args.amount)
	self:PlaySound(args.spellId, "alarm")
end

function mod:RapidIncubation(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 19.9)
	-- XXX Say chat if you have 3 seed stack and are within 40 yards of the boss? Warn others that you're spawning an add
end

function mod:IncubatingSeed(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, "orange", args.destName, amount, 3) -- Important you dont get 4th
		self:PlaySound(args.spellId, amount == 3 and "warning" or "alarm")
	end
end

do
	local prev = 0
	function mod:Wildfire(args)
		local t = args.time
		if t-prev > 10 then -- Double casts in stage 2
			prev = t
			self:Message(args.spellId, "yellow")
			self:PlaySound(args.spellId, "alert")
			self:Bar(args.spellId, 24)
		end
	end
end

function mod:IcyShroud(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 40.5)
end

function mod:MortalStoneclaws(args)
	self:Message(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 20) -- stage 2: 10?
end

function mod:MortalWounds(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, args.amount)
	self:PlaySound(args.spellId, "warning")
end

-- Primalist Mage
function mod:IceBarrage(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

-- Tarasek Earthreaver
function mod:BurrowingStrike(args)
	--self:Bar(args.spellId, 20)
end

function mod:BurrowingStrikeApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, args.amount)
	if amount > 2 then -- Swap on 3+ XXX Check this
		self:PlaySound(args.spellId, "warning")
	elseif self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:Tremors(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, 20)
end

-- Dragonspawn Flamebender
function mod:CauterizingFlashflames(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 20)
end

function mod:FlameSentry(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 20)
end

-- Juvenile Frost Proto-Dragon
function mod:RendingBite(args)
	--self:Bar(args.spellId, 20)
end

function mod:RendingBiteApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, args.amount)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:ChillingTantrum(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 20)
end

-- Drakonid Stormbringer
function mod:StaticJolt(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message(args.spellId, "yellow")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

do
	local playerList = {}
	function mod:IonizingCharge()
		playerList = {}
	end

	function mod:IonizingChargeApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
	end
end

-- Stage Two: A Broodkeeper Scorned
function mod:BroodkeepersFury(args)
	local amount = args.amount or 1
	self:StopBar(CL.count:format(args.spellName, amount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, amount))
	self:PlaySound(args.spellId, "info")
	self:Bar(args.spellId, 30, CL.count:format(args.spellName, amount+1))
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
