if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Experimentation of Dracthyr", 2569, 2530)
if not mod then return end
mod:RegisterEnableMob(200912, 200913, 200918) -- Neldris, Thadrion, Rionthus
mod:SetEncounterID(2693)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local mutilationCount = 1
local massiveSlamCount = 1
local forcefulRoarCount = 1

local essenceMarksUsed = {}
local volatileSpewCount = 1
local uncontrollableFrenzyCount = 1

local deepBreathCount = 1
local temporalAnomalyCount = 1
local disintergrateCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
end

--------------------------------------------------------------------------------
-- Initialization
--

local mutilationMarker = mod:AddMarkerOption(true, "player", 8, 406358, 8, 7, 6) -- Mutilation
local unstableEssenceMarker = mod:AddMarkerOption(true, "player", 1, 407327, 1, 2, 3) -- Unstable Essence
function mod:GetOptions()
	return {
		-- General
		"stages",
		{406311, "TANK"}, -- Infused Strikes
		407302, -- Infused Explosion
		-- Neldris
		{406358, "SAY", "SAY_COUNTDOWN"}, -- Mutilation
		mutilationMarker,
		404472, -- Massive Slam
		404713, -- Forceful Roar
		-- Thadrion
		{407327, "SAY"}, -- Unstable Essence
		unstableEssenceMarker,
		405492, -- Volatile Spew
		405375, -- Uncontrollable Frenzy
		-- Rionthus
		406227, -- Deep Breath
		407552, -- Temporal Anomaly
		{405392, "SAY"}, -- Disintegrate
	}, {
		[406358] = -26316, -- Neldris
		[407327] = -26322, -- Thadrion
		[406227] = -26329, -- Rionthus
	}
end

function mod:OnBossEnable()
	-- General
	self:RegisterUnitEvent("UNIT_TARGETABLE_CHANGED", nil, "boss1", "boss2", "boss3")
	self:Death("Deaths", 200912, 200913, 200918)

	self:Log("SPELL_AURA_APPLIED", "InfusedStrikesApplied", 406311)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfusedStrikesApplied", 406311)
	self:Log("SPELL_AURA_APPLIED", "InfusedExplosionApplied", 407302)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfusedExplosionApplied", 407302)

	-- Neldris
	self:Log("SPELL_CAST_START", "Mutilation", 406358)
	self:Log("SPELL_AURA_APPLIED", "MutilationApplied", 406317)
	self:Log("SPELL_AURA_REMOVED", "MutilationRemoved", 406317)
	self:Log("SPELL_CAST_START", "MassiveSlam", 404472)
	self:Log("SPELL_CAST_START", "ForcefulRoar", 404713)

	-- Thadrion
	self:Log("SPELL_CAST_START", "UnstableEssence", 405042)
	self:Log("SPELL_AURA_APPLIED", "UnstableEssenceApplied", 407327)
	self:Log("SPELL_AURA_REMOVED", "UnstableEssenceRemoved", 407327)
	self:Log("SPELL_CAST_START", "VolatileSpew", 405492)
	self:Log("SPELL_CAST_START", "UncontrollableFrenzy", 405375)

	-- Rionthus
	self:Log("SPELL_CAST_START", "DeepBreath", 406227)
	self:Log("SPELL_CAST_START", "TemporalAnomaly", 407552)
	self:Log("SPELL_CAST_START", "Disintegrate", 405391)
	self:Log("SPELL_AURA_APPLIED", "DisintegrateApplied", 405392)
end

function mod:OnEngage()
	mutilationCount = 1
	massiveSlamCount = 1
	forcefulRoarCount = 1

	essenceMarksUsed = {}
	volatileSpewCount = 1
	uncontrollableFrenzyCount = 1

	deepBreathCount = 1
	temporalAnomalyCount = 1
	disintergrateCount = 1

	-- self:Bar(406358, 30, CL.count:format(self:SpellName(406358), mutilationCount)) -- Mutilation
	-- self:Bar(404472, 30, CL.count:format(self:SpellName(404472), massiveSlamCount)) -- Massive Slam
	-- self:Bar(404713, 30, CL.count:format(self:SpellName(404713), forcefulRoarCount)) -- Forceful Roar
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_TARGETABLE_CHANGED(_, unit)
	-- XXX maybe IEEU with flags for the bosses?
	local mobId = self:MobId(self:UnitGUID(unit))
	if mobId == 200913 then -- Thadrion
		if UnitCanAttack("player", unit) then
			self:Message("stages", "cyan", -26322, false)
			self:PlaySound("stages", "long")
			-- self:Bar(405492, 30, CL.count:format(self:SpellName(405492), volatileSpewCount)) -- Volatile Spew
			-- self:Bar(405375, 30, CL.count:format(self:SpellName(405375), uncontrollableFrenzyCount)) -- Uncontrollable Frenzy
		end
	elseif mobId == 200918 then -- Rionthus
		if UnitCanAttack("player", unit) then
			self:Message("stages", "cyan", -26329, false)
			self:PlaySound("stages", "long")
			-- self:Bar(406227, 30, CL.count:format(self:SpellName(406227), deepBreathCount)) -- Deep Breath
			-- self:Bar(407552, 30, CL.count:format(self:SpellName(407552), temporalAnomalyCount)) -- Temporal Anomaly
			-- self:Bar(405392, 30, CL.count:format(self:SpellName(405392), disintergrateCount)) -- Disintegrate
		end
	end
end

function mod:Deaths(args)
	if args.mobId == 200912 then -- Neldris
		self:StopBar(CL.count:format(self:SpellName(406358), mutilationCount)) -- Mutilation
		self:StopBar(CL.count:format(self:SpellName(404472), massiveSlamCount)) -- Massive Slam
		self:StopBar(CL.count:format(self:SpellName(404713), forcefulRoarCount)) -- Forceful Roar
	elseif args.mobId == 200913 then -- Thadrion
		self:StopBar(CL.count:format(self:SpellName(405492), volatileSpewCount)) -- Volatile Spew
		self:StopBar(CL.count:format(self:SpellName(405375), uncontrollableFrenzyCount)) -- Uncontrollable Frenzy
	elseif args.mobId == 200918 then -- Rionthus
		self:StopBar(CL.count:format(self:SpellName(406227), deepBreathCount)) -- Deep Breath
		self:StopBar(CL.count:format(self:SpellName(407552), temporalAnomalyCount)) -- Temporal Anomaly
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
	local count = 1
	local playerList = {}
	local onMe = false

	local function mutilationSound()
		if onMe then
			mod:PlaySound(406358, "warning")
		else
			mod:PlaySound(406358, "alarm")
		end
		onMe = false
	end

	function mod:Mutilation(args)
		self:StopBar(CL.count:format(args.spellName, mutilationCount))
		mutilationCount = mutilationCount + 1
		--self:Bar(args.spellId, 30, CL.count:format(args.spellName, mutilationCount))
		count = 8 -- Using 8, 7, 6
		playerList = {}
		self:SimpleTimer(mutilationSound, 0.1)
	end

	function mod:MutilationApplied(args)
		playerList[#playerList+1] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(406358, CL.rticon:format(args.spellName, count))
			self:SayCountdown(406358, 6, count)
			onMe = true
		end
		self:TargetsMessage(406358, "yellow", playerList, 3, CL.count:format(args.spellName, mutilationCount-1))
		self:CustomIcon(mutilationMarker, args.destName, count)
		count = count - 1
	end

	function mod:MutilationRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(406358)
			onMe = false
		end
		self:CustomIcon(mutilationMarker, args.destName)
	end
end

function mod:MassiveSlam(args)
	self:StopBar(CL.count:format(args.spellName, massiveSlamCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, massiveSlamCount))
	self:PlaySound(args.spellId, "alert")
	massiveSlamCount = massiveSlamCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, massiveSlamCount))
end

function mod:ForcefulRoar(args)
	self:StopBar(CL.count:format(args.spellName, forcefulRoarCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, forcefulRoarCount))
	self:PlaySound(args.spellId, "alarm")
	forcefulRoarCount = forcefulRoarCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, forcefulRoarCount))
end

-- Thadrion
function mod:UnstableEssence(args)
	self:Message(407327, "cyan", CL.casting:format(args.spellName))
end

function mod:UnstableEssenceApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm")
		self:Say(args.spellId)
	end
	for i = 1, 3, 1 do -- 1, 2, 3
		if not essenceMarksUsed[i] then
			essenceMarksUsed[i] = args.destGUID
			self:CustomIcon(unstableEssenceMarker, args.destName, i)
			return
		end
	end
end

function mod:UnstableEssenceRemoved(args)
	self:CustomIcon(mutilationMarker, args.destName)
	for i = 1, 3, 1 do -- 1, 2, 3
		if essenceMarksUsed[i] == args.destGUID then
			essenceMarksUsed[i] = nil
			return
		end
	end
end

function mod:VolatileSpew(args)
	self:StopBar(CL.count:format(args.spellName, volatileSpewCount))
	self:Message(args.spellId, "orange", CL.count:format(args.spellName, volatileSpewCount))
	self:PlaySound(args.spellId, "alarm")
	volatileSpewCount = volatileSpewCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, volatileSpewCount))
end

function mod:UncontrollableFrenzy(args)
	self:StopBar(CL.count:format(args.spellName, uncontrollableFrenzyCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, uncontrollableFrenzyCount))
	self:PlaySound(args.spellId, "long")
	uncontrollableFrenzyCount = uncontrollableFrenzyCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, uncontrollableFrenzyCount))
end

-- Rionthus
function mod:DeepBreath(args)
	self:StopBar(CL.count:format(args.spellName, deepBreathCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, deepBreathCount))
	self:PlaySound(args.spellId, "alert")
	deepBreathCount = deepBreathCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, deepBreathCount))
end

function mod:TemporalAnomaly(args)
	self:StopBar(CL.count:format(args.spellName, temporalAnomalyCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, temporalAnomalyCount))
	self:PlaySound(args.spellId, "info")
	temporalAnomalyCount = temporalAnomalyCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, temporalAnomalyCount))
end

function mod:Disintegrate(args)
	self:StopBar(CL.count:format(args.spellName, disintergrateCount))
	self:Message(405392, "orange", CL.count:format(args.spellName, disintergrateCount))
	disintergrateCount = disintergrateCount + 1
	--self:Bar(405392, 30, CL.count:format(args.spellName, disintergrateCount))
end

function mod:DisintegrateApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
	end
end
