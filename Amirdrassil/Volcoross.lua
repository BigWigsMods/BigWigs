if not BigWigsLoader.onTestBuild then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Volcoross", 2549, 2557)
if not mod then return end
mod:RegisterEnableMob(208478) -- Volcoross
mod:SetEncounterID(2737)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local serpentsFuryCount = 1
local floodOfTheFirelandsCount = 1
local volcanicDisgorgeCount = 1
local scorchtailCrashCount = 1
local cataclysmJawsCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.flood_of_the_firelands = "Soaks"
	L.scorchtail_crash = "Tail Slam"
	L.serpents_fury = "Flames"
	L.coiling_flames_single = "Flames" -- Do we need a single locale for this?
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		421082, -- Hellboil
		421672, -- Serpent's Fury
		{421207, "SAY", "SAY_COUNTDOWN"}, -- Coiling Flames
		420933, -- Flood of the Firelands
		{421616, "SAY"}, -- Volcanic Disgorge
		420415, -- Scorchtail Crash
		423494, -- Tidal Blaze
		{419054, "TANK"}, -- Molten Venom
		{423117, "TANK"}, -- Cataclysm Jaws
		421703, -- Serpent's Wrath
		424218, -- Combusting Rage
	}, nil, {
		[421672] = L.serpents_fury, -- Serpent's Fury (Flames)
		[420933] = L.flood_of_the_firelands, -- Flood of the Firelands (Soaks)
		[421616] = CL.pools, -- Volcanic Disgorge (Pools)
		[420415] = L.scorchtail_crash, -- Scorchtail Crash (Tail Slam)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1") -- Scorchtail Crash

	self:Log("SPELL_CAST_START", "SerpentsFury", 421672)
	self:Log("SPELL_AURA_APPLIED", "CoilingFlamesApplied", 421207)
	self:Log("SPELL_AURA_REMOVED", "CoilingFlamesRemoved", 421207)
	self:Log("SPELL_CAST_START", "FloodOfTheFirelands", 420933)
	self:Log("SPELL_CAST_START", "VolcanicDisgorge", 421616)
	-- self:Log("SPELL_CAST_START", "ScorchtailCrash", 420415)
	self:Log("SPELL_AURA_APPLIED", "MoltenVenomApplied", 419054)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MoltenVenomApplied", 419054)
	self:Log("SPELL_CAST_START", "CataclysmJaws", 423117)
	self:Log("SPELL_CAST_START", "SerpentsWrath", 421703)
	self:Log("SPELL_AURA_APPLIED", "CombustingRage", 424218)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 421082, 423494) -- Hellboil, Tidal Blaze
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 421082, 423494)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 421082, 423494)
end

function mod:OnEngage()
	serpentsFuryCount = 1
	floodOfTheFirelandsCount = 1
	volcanicDisgorgeCount = 1
	scorchtailCrashCount = 1
	cataclysmJawsCount = 1

	self:Bar(423117, 5, CL.count:format(self:SpellName(423117), cataclysmJawsCount)) -- Cataclysm Jaws
	self:Bar(421672, 10, CL.count:format(L.serpents_fury, serpentsFuryCount)) -- Serpent's Fury
	self:Bar(420415, 20, CL.count:format(L.scorchtail_crash, scorchtailCrashCount)) -- Scorchtail Crash
	self:Bar(421616, 30, CL.count:format(CL.pools, volcanicDisgorgeCount)) -- Volcanic Disgorge
	self:Bar(420933, 70, CL.count:format(L.flood_of_the_firelands, floodOfTheFirelandsCount)) -- Flood of the Firelands
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 421356 or spellId == 421359 or spellId == 421684 then -- Scorchtail Crash
		self:StopBar(CL.count:format(L.scorchtail_crash, scorchtailCrashCount))
		self:Message(420415, "red", CL.count:format(L.scorchtail_crash, scorchtailCrashCount))
		self:PlaySound(420415, "alarm")
		scorchtailCrashCount = scorchtailCrashCount + 1
		local cd = 20
		if scorchtailCrashCount == 4 or scorchtailCrashCount == 9 or scorchtailCrashCount == 14 then
			cd = 30
		elseif scorchtailCrashCount < 14 and scorchtailCrashCount > 4 then -- Raid Split Up
			cd = 10
		end
		self:Bar(420415, cd, CL.count:format(L.scorchtail_crash, scorchtailCrashCount)) -- Scorchtail Crash
	end
end

function mod:SerpentsFury(args)
	self:StopBar(CL.count:format(L.serpents_fury, serpentsFuryCount))
	self:Message(args.spellId, "cyan", CL.count:format(L.serpents_fury, serpentsFuryCount))
	self:PlaySound(args.spellId, "alert")
	serpentsFuryCount = serpentsFuryCount + 1
	self:Bar(args.spellId, 70, CL.count:format(L.serpents_fury, serpentsFuryCount))
end

do
	function mod:CoilingFlamesApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId)
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, L.coiling_flames_single)
			self:SayCountdown(args.spellId, 10)
		end
	end

	function mod:CoilingFlamesRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:FloodOfTheFirelands(args)
	self:StopBar(CL.count:format(L.flood_of_the_firelands, floodOfTheFirelandsCount))
	self:Message(args.spellId, "orange", CL.count:format(L.flood_of_the_firelands, floodOfTheFirelandsCount))
	self:PlaySound(args.spellId, "long")
	floodOfTheFirelandsCount = floodOfTheFirelandsCount + 1
	self:Bar(args.spellId, 70, CL.count:format(L.flood_of_the_firelands, floodOfTheFirelandsCount))
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(421616, "yellow", name, CL.count:format(CL.pools, volcanicDisgorgeCount-1))
		if self:Me(guid) then
			self:PlaySound(421616, "warning") -- move
			self:Say(421616, CL.pools)
		else
			self:PlaySound(421616, "alert")
		end
	end

	function mod:VolcanicDisgorge(args)
		self:StopBar(CL.count:format(CL.pools, volcanicDisgorgeCount))
		--self:Message(args.spellId, "yellow", CL.count:format(CL.pools, volcanicDisgorgeCount))
		--self:PlaySound(args.spellId, "alert")
		self:GetBossTarget(printTarget, 0.1, args.sourceGUID)
		volcanicDisgorgeCount = volcanicDisgorgeCount + 1
		local cd = 20
		if volcanicDisgorgeCount == 3 or volcanicDisgorgeCount == 13 then
			cd = 40
		elseif volcanicDisgorgeCount == 8 then
			cd = 30
		elseif volcanicDisgorgeCount < 13 and volcanicDisgorgeCount > 3 then -- Raid Split Up
			cd = 10
		end
		self:Bar(args.spellId, cd, CL.count:format(CL.pools, volcanicDisgorgeCount))
	end
end

-- function mod:ScorchtailCrash(args)
-- 	self:StopBar(CL.count:format(args.spellName, scorchtailCrashCount))
-- 	self:Message(args.spellId, "red", CL.count:format(args.spellName, scorchtailCrashCount))
-- 	self:PlaySound(args.spellId, "alarm")
-- 	scorchtailCrashCount = scorchtailCrashCount + 1
-- 	--self:Bar(args.spellId, 20, CL.count:format(args.spellName, scorchtailCrashCount))
-- end

function mod:MoltenVenomApplied(args)
	local amount = args.amount or 1
	if amount % 3 == 0 then
		self:StackMessage(args.spellId, "purple", args.destName, args.amount, 6)
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm") -- On you
		end
	end
end

function mod:CataclysmJaws(args)
	self:StopBar(CL.count:format(args.spellName, cataclysmJawsCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, cataclysmJawsCount))
	self:PlaySound(args.spellId, "alarm")
	cataclysmJawsCount = cataclysmJawsCount + 1
	local cdTable = {
		[4] = 40,
		[6] = 40,
		[8] = 25,
		[9] = 25,
		[10] = 20,
	}
	self:Bar(args.spellId, cdTable[cataclysmJawsCount] or 30, CL.count:format(args.spellName, cataclysmJawsCount))
end

function mod:SerpentsWrath(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:CombustingRage(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
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
