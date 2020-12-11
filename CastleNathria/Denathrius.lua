--------------------------------------------------------------------------------
-- Remornia: Impale target order in say/message
--

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sire Denathrius", 2296, 2424)
if not mod then return end
mod:RegisterEnableMob(167406) -- Sire Denathrius
mod.engageId = 2407
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local intermission = nil
local nextStageWarning = 73
local burdenTracker = {}
local burdenStacksOnMe = 0
local cleansingPainCount = 1
local bloodPriceCount = 1
local nightHunterCount = 1
local ravageCount = 1
local impaleCount = 1
local wrackingPainCount = 1
local handCount = 1
local massacreCount = 1
local shatteringPainCount = 1
local fatalFinesseCount = 1
local addTimers = {0, 85, 55}
local addCount = 1

local nightHunterTimers = {12, 26, 30, 28, 30, 28}
local painTimers = {5.5, 21.3, 31.5, 22, 29.8, 22.6}
local impaleTimers = {23, 26.0, 27.0, 23.0, 32.0, 18.0, 39.0, 35.0}
local handTimers = {41.2, 40.3, 39.0, 56.1, 18.5, 57.2} -- Removed 1 from all timers second because he pre-casts the pull in 1 second earlier
local handTimersP3 = {27.7, 90.0, 31.6}
local fatalFinesseTimers = {18, 48, 6, 21, 27, 19}

--------------------------------------------------------------------------------
-- Initialization
--

local nightHunterMarker = mod:AddMarkerOption(false, "player", 1, 327796, 1, 2, 3) -- Night Hunter
local impaleMarker = mod:AddMarkerOption(false, "player", 1, 329951, 1, 2, 3) -- Impale
local fatalFinesseMarker = mod:AddMarkerOption(false, "player", 1, 332794, 1, 2, 3) -- Fatal Finesse
function mod:GetOptions()
	return {
		"stages",
		-- Stage One: Sinners Be Cleansed
		328936, -- Inevitable
		{326699, "INFOBOX"}, -- Burden of Sin
		326707, -- Cleansing Pain
		326851, -- Blood Price
		{327796, "SAY", "SAY_COUNTDOWN"}, -- Night Hunter
		nightHunterMarker,
		327122, -- Ravage
		327992, -- Desolation
		-- Intermission: March of the Penitent
		328276, -- March of the Penitent
		329906, -- Carnage
		{329951, "SAY", "SAY_COUNTDOWN"}, -- Impale
		329711, -- Adds XXX
		impaleMarker,
		335873, -- Rancor
		329181, -- Wracking Pain
		333932, -- Hand of Destruction
		330068, -- Massacre
		-- Stage Three: Indignation
		{332585, "TANK"}, -- Scorn
		332619, -- Shattering Pain
		{332794, "SAY", "SAY_COUNTDOWN"}, -- Fatal Finesse
		fatalFinesseMarker,
		336008, -- Smoldering Ire
		333979, -- Sinister Reflection
		332849, -- Ravage
		333980, -- Massacre
	},{
		["stages"] = "general",
		[328936] = -22016, -- Stage One: Sinners Be Cleansed
		[328276] = -22098, -- Intermission: March of the Penitent
		[329906] = -22059, -- Stage Two: The Crimson Chorus
		[332585] = -22195,-- Stage Three: Indignation
	}
end

function mod:OnBossEnable()
	-- Stage One: Sinners Be Cleansed
	self:Log("SPELL_CAST_SUCCESS", "Inevitable", 328936)
	self:Log("SPELL_AURA_APPLIED", "BurdenofSinStacks", 326699)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BurdenofSinStacks", 326699)
	self:Log("SPELL_AURA_REMOVED_DOSE", "BurdenofSinStacks", 326699)
	self:Log("SPELL_AURA_REMOVED", "BurdenofSinRemoved", 326699)
	self:Log("SPELL_CAST_START", "CleansingPain", 326707)
	self:Log("SPELL_CAST_SUCCESS", "CleansingPainSuccess", 326707)
	self:Log("SPELL_AURA_APPLIED", "BloodPriceApplied", 326851)
	self:Log("SPELL_AURA_APPLIED", "NightHunterApplied", 327796)
	self:Log("SPELL_AURA_REMOVED", "NightHunterRemoved", 327796)
	self:Log("SPELL_CAST_START", "Ravage", 327122)

	-- Intermission: March of the Penitent
	self:Log("SPELL_CAST_START", "MarchofthePenitentStart", 328117)
	self:Log("SPELL_AURA_REMOVED", "MarchofthePenitentRemoved", 328276)

	-- Stage Two: The Crimson Chorus
	self:Log("SPELL_CAST_SUCCESS", "BegintheChorus", 329697)
	self:Log("SPELL_CAST_START", "AddsCast", 329711)
	self:Log("SPELL_AURA_APPLIED", "CarnageApplied", 329906)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CarnageApplied", 329906)
	self:Log("SPELL_AURA_APPLIED", "ImpaleApplied", 329951)
	self:Log("SPELL_AURA_REMOVED", "ImpaleRemoved", 329951)
	self:Log("SPELL_CAST_START", "WrackingPain", 329181)
	self:Log("SPELL_AURA_APPLIED", "WrackingPainApplied", 329181)
	self:Log("SPELL_AURA_APPLIED_DOSE", "WrackingPainApplied", 329181)
	self:Log("SPELL_CAST_START", "HandofDestruction", 333932)
	self:Log("SPELL_CAST_SUCCESS", "Massacre", 330068)

	-- Stage Three: Indignation
	self:Log("SPELL_CAST_SUCCESS", "IndignationSuccess", 326005)
	self:Log("SPELL_AURA_APPLIED", "ScornApplied", 332585)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ScornApplied", 332585)
	self:Log("SPELL_CAST_SUCCESS", "ShatteringPain", 332619)
	self:Log("SPELL_AURA_APPLIED", "FatalFinesseApplied", 332794)
	self:Log("SPELL_AURA_REMOVED", "FatalFinesseRemoved", 332794)
	self:Log("SPELL_CAST_SUCCESS", "ReflectionRavage", 332849)
	self:Log("SPELL_CAST_SUCCESS", "ReflectionMassacre", 333980)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 327992, 335873) -- Desolation, Rancor
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 327992, 335873)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 327992, 335873)
end

function mod:OnEngage()
	stage = 1
	intermission = nil
	nextStageWarning = 73

	cleansingPainCount = 1
	bloodPriceCount = 1
	nightHunterCount = 1
	ravageCount = 1
	addCount = 1

	self:Bar(326707, painTimers[cleansingPainCount], CL.count:format(self:SpellName(326707), cleansingPainCount)) -- Cleansing Pain
	self:Bar(326851, 24.5, CL.count:format(self:SpellName(326851), bloodPriceCount)) -- Blood Price
	self:Bar(327796, 12, CL.count:format(self:SpellName(327796), nightHunterCount)) -- Night Hunter
	self:Bar(327122, 53, CL.count:format(self:SpellName(327122), ravageCount)) -- Ravage

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")

	burdenTracker = {}
	burdenStacksOnMe = 0

	self:OpenInfo(326699, self:SpellName(326699)) -- Burden of Sin
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:UNIT_HEALTH(event, unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < nextStageWarning then -- Stage changes at 70% and 40%
		local nextStage = stage == 1 and CL.intermission or CL.stage:format(stage + 1)
		self:Message("stages", "green", CL.soon:format(nextStage), false)
		nextStageWarning = nextStageWarning - 30
		if nextStageWarning < 30 then
			self:UnregisterUnitEvent(event, unit)
		end
	end
end

function mod:Inevitable(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

do
	local scheduled, name = nil, nil
	function mod:BurdenofSunStackMessage()
		mod:StackMessage(326699, name, burdenStacksOnMe, "blue")
		mod:PlaySound(326699, "alarm")
		scheduled = nil
		name = nil
	end

	function mod:BurdenofSinStacks(args)
		local _, amount = self:UnitDebuff(args.destName, args.spellId) -- no amount in the event
		burdenTracker[args.destName] = amount
		if self:Me(args.destGUID) then
			burdenStacksOnMe = amount
			name = args.destName
			if not scheduled then
				scheduled = self:ScheduleTimer("BurdenofSunStackMessage", 0.1)
			end
		end
		self:SetInfoByTable(args.spellId, burdenTracker)
	end

	function mod:BurdenofSinRemoved(args)
		if scheduled then
			self:CancelTimer(scheduled)
			scheduled = nil
		end
		burdenTracker[args.destName] = 0
		burdenStacksOnMe = 0
		if self:Me(args.destGUID) then
			self:Message(args.spellId, intermission and "green" or "red", CL.removed:format(args.spellName))
			self:PlaySound(args.spellId, intermission and "info" or "warning")
		end
		self:SetInfoByTable(args.spellId, burdenTracker)
	end
end

function mod:CleansingPain(args)
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, cleansingPainCount))
	self:PlaySound(args.spellId, "alert")
end

function mod:CleansingPainSuccess(args)
	cleansingPainCount = cleansingPainCount + 1
	self:Bar(args.spellId, painTimers[cleansingPainCount], CL.count:format(args.spellName, cleansingPainCount))
end

do
	local stackCounter, scheduled = {}, nil

	function mod:BloodPriceWarning()
		if stackCounter[burdenStacksOnMe] then
			local playerName = self:UnitName("player")
			mod:StackMessage(326851, playerName, stackCounter[burdenStacksOnMe], "blue")
			mod:PlaySound(326851, "alarm")
		end
		stackCounter = {}
		scheduled = nil
	end

	function mod:BloodPriceApplied(args)
		local burdenStacks = burdenTracker[args.destName]
		if burdenStacks then -- Keep track of how many stacks of burden the debuffed players have
			stackCounter[burdenStacks] = (stackCounter[burdenStacks] or 0) + 1
		end
		if not scheduled then
			scheduled = self:ScheduleTimer("BloodPriceWarning", 0.1)
			bloodPriceCount = bloodPriceCount + 1
			self:Bar(args.spellId, 58, CL.count:format(args.spellName, bloodPriceCount))
		end
	end
end

do
	local playerList, playerIcons = mod:NewTargetList(), {}
	function mod:NightHunterApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerIcons[count] = count
		if self:Me(args.destGUID)then
			self:Say(args.spellId, CL.count_rticon:format(args.spellName, count, count))
			self:SayCountdown(args.spellId, 6, count)
		end
		self:TargetsMessage(args.spellId, "orange", playerList, self:Mythic() and 3 or 2, CL.count:format(args.spellName, nightHunterCount), nil, nil, playerIcons)
		if count == 1 then
			self:CastBar(args.spellId, 6, CL.count:format(args.spellName, nightHunterCount))
			self:PlaySound(args.spellId, "warning")
			nightHunterCount = nightHunterCount + 1
			self:Bar(args.spellId, nightHunterTimers[nightHunterCount], CL.count:format(args.spellName, nightHunterCount))
		end
		if self:GetOption(nightHunterMarker) then
			SetRaidTarget(args.destName, count)
		end
	end

	function mod:NightHunterRemoved(args)
		if self:GetOption(nightHunterMarker) then
			SetRaidTarget(args.destName, 0)
		end
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end
function mod:Ravage(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, ravageCount))
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 6, CL.count:format(args.spellName, ravageCount))
	ravageCount = ravageCount + 1
	self:Bar(args.spellId, 58, CL.count:format(args.spellName, ravageCount))
end

-- Intermission: March of the Penitent
function mod:MarchofthePenitentStart(args)
	if stage == 1 then
		stage = stage + 1
		intermission = true
		self:Message("stages", "green", CL.intermission, false)
		self:PlaySound("stages", "long")
		self:CastBar("stages", 16.5, CL.intermission, 328276) -- March of the Penitent icon

		self:StopBar(CL.count:format(self:SpellName(326707), cleansingPainCount)) -- Cleansing Pain
		self:StopBar(CL.count:format(self:SpellName(326851), bloodPriceCount)) -- Blood Price
		self:StopBar(CL.count:format(self:SpellName(327796), nightHunterCount)) -- Night Hunter
		self:StopBar(CL.count:format(self:SpellName(327122), ravageCount)) -- Ravage
	end
end

function mod:MarchofthePenitentRemoved(args)
	intermission = nil
end

-- Stage Two: The Crimson Chorus
function mod:BegintheChorus(args)
	self:CloseInfo(326699)
	self:Message("stages", "green", CL.stage:format(stage), false)
	self:PlaySound("stages", "long")

	impaleCount = 1
	wrackingPainCount = 1
	handCount = 1
	massacreCount = 1
	addCount = 1

	self:Bar(329951, impaleTimers[impaleCount], CL.count:format(self:SpellName(329951), impaleCount)) -- Impale
	self:Bar(329181, 15.7, CL.count:format(self:SpellName(329181), wrackingPainCount)) -- Wracking Pain
	self:Bar(333932, handTimers[handCount], CL.count:format(self:SpellName(333932), handCount)) -- Hand of Destruction
	self:Bar(330068, 62, CL.count:format(self:SpellName(330068), massacreCount)) -- Massacre
end

do
	local prev = 0
	function mod:AddsCast(args)
		local t = args.time
		if t-prev > 20 and stage == 2 then
			prev = t
			self:Message(args.spellId, "yellow", CL.incoming:format(CL.count:format(CL.adds, addCount)))
			self:PlaySound(args.spellId, "alert")
			addCount = addCount + 1
			self:Bar(args.spellId, addTimers[addCount], CL.count:format(CL.adds, addCount))
		end
	end
end

function mod:CarnageApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, args.destName, args.amount, "blue")
		self:PlaySound(args.spellId, "alarm")
	end
end

do
	local playerList, playerIcons = mod:NewTargetList(), {}
	function mod:ImpaleApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerIcons[count] = count
		if self:Me(args.destGUID)then
			self:Say(args.spellId, CL.count_rticon:format(args.spellName, count, count))
			--self:SayCountdown(args.spellId, 6, count) -- Leave it out so it's obvious what nr you are
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "orange", playerList, 3, CL.count:format(args.spellName, impaleCount), nil, 2, playerIcons) -- debuffs are late
		if count == 1 then
			impaleCount = impaleCount + 1
			self:Bar(args.spellId, impaleTimers[impaleCount], CL.count:format(args.spellName, impaleCount))
		end
		if self:GetOption(impaleMarker) then
			SetRaidTarget(args.destName, count)
		end
	end

	function mod:ImpaleRemoved(args)
		if self:GetOption(impaleMarker) then
			SetRaidTarget(args.destName, 0)
		end
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:WrackingPain(args)
	self:Message(args.spellId, "yellow", CL.casting:format(CL.count:format(args.spellName, wrackingPainCount)))
	self:PlaySound(args.spellId, "alert")
	wrackingPainCount = wrackingPainCount + 1
	self:CDBar(args.spellId, 20, CL.count:format(args.spellName, wrackingPainCount))
end

function mod:WrackingPainApplied(args)
	if self:Tank(args.destName) and self:Tank() then
		self:TargetMessage(args.spellId, "purple", args.destName)
		self:PlaySound(args.spellId, "warning", args.destName)
	end
end

function mod:HandofDestruction(args)
	self:Message(args.spellId, "orange", CL.casting:format(CL.count:format(args.spellName, handCount)))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 6, CL.count:format(args.spellName, handCount))
	handCount = handCount + 1
	self:Bar(args.spellId, stage == 3 and handTimersP3[handCount] or handTimers[handCount], CL.count:format(args.spellName, handCount))
end

function mod:Massacre(args)
	self:Message(args.spellId, "red", CL.count:format(args.spellName, massacreCount))
	self:PlaySound(args.spellId, "alarm")
	massacreCount = massacreCount + 1
	self:Bar(args.spellId, 50, CL.count:format(args.spellName, massacreCount))
end

-- Stage Three: Indignation
function mod:IndignationSuccess(args)
	stage = stage + 1
	self:Message("stages", "green", CL.stage:format(stage), false)
	self:PlaySound("stages", "long")

	self:StopBar(CL.count:format(self:SpellName(329951), impaleCount)) -- Impale
	self:StopBar(CL.count:format(self:SpellName(329181), wrackingPainCount)) -- Wracking Pain
	self:StopBar(CL.count:format(self:SpellName(333932), handCount)) -- Hand of Destruction
	self:StopBar(CL.count:format(self:SpellName(330137), massacreCount)) -- Massacre
	self:StopBar(CL.count:format(CL.adds, addCount)) -- Ravage

	handCount = 1
	shatteringPainCount = 1
	fatalFinesseCount = 1
	massacreCount = 1
	ravageCount = 1

	self:Bar(333932, handTimersP3[handCount], CL.count:format(self:SpellName(333932), handCount)) -- Hand of Destruction
	self:Bar(332619, 14, CL.count:format(self:SpellName(332619), shatteringPainCount)) -- Shattering Pain
	self:Bar(332794, fatalFinesseTimers[fatalFinesseCount], CL.count:format(self:SpellName(332794), fatalFinesseCount)) -- Fatal Finesse
	self:Bar(332849, 90, CL.count:format(self:SpellName(330068), massacreCount)) -- Massacre
	self:Bar(333980, 50, CL.count:format(self:SpellName(332937), ravageCount)) -- Ravage
end

function mod:ScornApplied(args)
	local amount = args.amount or 1
	if amount % 3 == 0 or amount > 5 then -- 3, 6+
		self:StackMessage(args.spellId, args.destName, amount, "purple")
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:ShatteringPain(args)
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, shatteringPainCount))
	self:PlaySound(args.spellId, "alert")
	shatteringPainCount = shatteringPainCount + 1
	self:Bar(args.spellId, 24, CL.count:format(args.spellName, shatteringPainCount))
end

do
	local playerList, playerIcons, sphereSpawned = mod:NewTargetList(), {}, nil
	function mod:FatalFinesseApplied(args)
		sphereSpawned = nil
		local count = #playerList+1
		playerList[count] = args.destName
		playerIcons[count] = count
		if self:Me(args.destGUID)then
			self:Say(args.spellId, CL.count_rticon:format(args.spellName, count, count))
			self:SayCountdown(args.spellId, 5, count)
		end
		self:TargetsMessage(args.spellId, "orange", playerList, 3, CL.count:format(args.spellName, fatalFinesseCount), nil, nil, playerIcons)
		if count == 1 then
			self:CastBar(args.spellId, 5, CL.count:format(args.spellName, fatalFinesseCount))
			self:PlaySound(args.spellId, "warning")
			fatalFinesseCount = fatalFinesseCount + 1
			self:Bar(args.spellId, fatalFinesseTimers[fatalFinesseCount], CL.count:format(args.spellName, fatalFinesseCount))
		end
		if self:GetOption(fatalFinesseMarker) then
			SetRaidTarget(args.destName, count)
		end
	end

	function mod:FatalFinesseRemoved(args)
		if self:GetOption(fatalFinesseMarker) then
			SetRaidTarget(args.destName, 0)
		end
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		if not sphereSpawned then
			sphereSpawned = true
			self:CastBar(336008, 10) -- Smoldering Ire
		end
	end
end

function mod:ReflectionRavage(args)
	self:Message(args.spellId, "orange", CL.count:format(self:SpellName(332937), ravageCount))
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 6)
	ravageCount = ravageCount + 1
	self:Bar(args.spellId, 80, CL.count:format(self:SpellName(332937), ravageCount))
end

function mod:ReflectionMassacre(args)
	self:Message(args.spellId, "red", CL.count:format(self:SpellName(330068), massacreCount))
	self:PlaySound(args.spellId, "alarm")
	massacreCount = massacreCount + 1
	self:Bar(args.spellId, 80, CL.count:format(self:SpellName(330068), massacreCount))
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
