--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Volcoross", 2549, 2557)
if not mod then return end
mod:RegisterEnableMob(208478) -- Volcoross
mod:SetEncounterID(2737)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local serpentsFuryCount = 1
local floodOfTheFirelandsCount = 1
local volcanicDisgorgeCount = 1
local scorchtailCrashCount = 1
local cataclysmJawsCount = 1
local explosionCount = 1
local playerSide = "all"
local showAllCasts = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_off_all_scorchtail_crash = "Show All Casts"
	L.custom_off_all_scorchtail_crash_desc = "Show timers and messages for all Scorchtail Crash casts instead of just for your side."

	L.flood_of_the_firelands_single_wait = "Wait" -- Wait 3, Wait 2, Wait 1 countdown before soak debuff is applied
	L.scorchtail_crash = "Tail Slam"
	L.serpents_fury = "Flames"
	L.coiling_flames_single = "Flames"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"custom_off_all_scorchtail_crash",
		421082, -- Hellboil
		421672, -- Serpent's Fury
		{421207, "SAY", "SAY_COUNTDOWN"}, -- Coiling Flames
		420933, -- Flood of the Firelands
		{421616, "SAY"}, -- Volcanic Disgorge
		420415, -- Scorchtail Crash
		423494, -- Tidal Blaze
		{419054, "TANK"}, -- Molten Venom
		{423117, "TANK", "EMPHASIZE"}, -- Cataclysm Jaws
		421703, -- Serpent's Wrath
		424218, -- Combusting Rage
		{427201, "SAY", "SAY_COUNTDOWN"}, -- Coiling Eruption
	},{
		[427201] = "mythic",
	},{
		[421672] = L.serpents_fury, -- Serpent's Fury (Flames)
		[420933] = CL.soaks, -- Flood of the Firelands (Soaks)
		[421616] = CL.pools, -- Volcanic Disgorge (Pools)
		[420415] = L.scorchtail_crash, -- Scorchtail Crash (Tail Slam)
		[427201] = CL.explosion, -- Coiling Eruption (Explosion)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1") -- Scorchtail Crash
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "PlayerCasts", "player")

	self:Log("SPELL_CAST_START", "SerpentsFury", 421672)
	self:Log("SPELL_AURA_APPLIED", "CoilingFlamesApplied", 421207)
	self:Log("SPELL_AURA_REMOVED", "CoilingFlamesRemoved", 421207)
	self:Log("SPELL_CAST_START", "FloodOfTheFirelands", 420933)
	self:Log("SPELL_CAST_START", "VolcanicDisgorge", 421616)
	-- self:Log("SPELL_CAST_START", "ScorchtailCrash", 420415)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MoltenVenomApplied", 419054)
	self:Log("SPELL_CAST_START", "CataclysmJaws", 423117)
	self:Log("SPELL_CAST_START", "SerpentsWrath", 421703)
	self:Log("SPELL_AURA_APPLIED", "CombustingRage", 424218)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 421082, 423494) -- Hellboil, Tidal Blaze
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 421082, 423494)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 421082, 423494)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "CoilingEruptionApplied", 427201)
	self:Log("SPELL_AURA_REMOVED", "CoilingEruptionRemoved", 427201)
end

function mod:OnEngage()
	serpentsFuryCount = 1
	floodOfTheFirelandsCount = 1
	volcanicDisgorgeCount = 1
	scorchtailCrashCount = 1
	cataclysmJawsCount = 1
	explosionCount = 1
	playerSide = "all"
	showAllCasts = self:GetOption("custom_off_all_scorchtail_crash")

	self:Bar(423117, 5, CL.count:format(self:SpellName(423117), cataclysmJawsCount)) -- Cataclysm Jaws
	self:Bar(421672, 10, CL.count:format(L.serpents_fury, serpentsFuryCount)) -- Serpent's Fury
	self:Bar(420415, 20, CL.count:format(L.scorchtail_crash, scorchtailCrashCount)) -- Scorchtail Crash
	self:Bar(421616, 30, CL.count:format(CL.pools, volcanicDisgorgeCount)) -- Volcanic Disgorge
	self:Bar(420933, 70, CL.count:format(CL.soaks, floodOfTheFirelandsCount)) -- Flood of the Firelands
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local last = 0
	-- local side = { "both", "both", "both", "left", "right", "left", "right", "left", "right", "left", "right", "left", "right", "both", "both", "both" }
	local timer = {
		["all"] = { 20.0, 20.0, 20.0, 30.0, 10.0, 10.0, 10.0, 10.0, 30.0, 10.0, 10.0, 10.0, 10.0, 30.0, 20.0, 20.0 },
		[421359] = { 20.0, 20.0, 20.0, 40.0, 20.0, 40.0, 20.0, 20.0, 30.0, 20.0, 20.0 },
		[421356] = { 20.0, 20.0, 20.0, 30.0, 20.0, 20.0, 40.0, 20.0, 40.0, 20.0, 20.0 },
	}

	function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellId)
		if spellId == 421356 or spellId == 421359 or spellId == 421684 then -- Scorchtail Crash (left, right, either)
			if showAllCasts or playerSide == "all" then
				-- raid leader mode
				local msg = CL.count:format(L.scorchtail_crash, scorchtailCrashCount)
				self:StopBar(msg)
				self:Message(420415, "red", msg)
				if spellId == 421684 or spellId == playerSide then
					self:PlaySound(420415, "alarm")
				end
				scorchtailCrashCount = scorchtailCrashCount + 1
				self:CDBar(420415, timer["all"][scorchtailCrashCount], CL.count:format(L.scorchtail_crash, scorchtailCrashCount))
			elseif floodOfTheFirelandsCount == 1 or spellId == 421684 or spellId == playerSide then
				last = GetTime()
				self:StopBar(CL.count:format(L.scorchtail_crash, scorchtailCrashCount))
				self:Message(420415, "red", CL.count:format(L.scorchtail_crash, scorchtailCrashCount))
				self:PlaySound(420415, "alarm")
				scorchtailCrashCount = scorchtailCrashCount + 1
				self:CDBar(420415, timer[playerSide][scorchtailCrashCount], CL.count:format(L.scorchtail_crash, scorchtailCrashCount))
			end
			-- if cd then
			-- 	local t = GetTime()
			-- 	local offset = nextScorchtailCrash - t -- +/-2s auto correcting
			-- 	cd = cd + offset
			-- 	self:CDBar(420415, cd, CL.count:format(L.scorchtail_crash, scorchtailCrashCount))
			-- 	nextScorchtailCrash = t + cd
			-- end
		end
	end

	function mod:PlayerCasts(_, unit, _, spellId)
		if scorchtailCrashCount < 5 and (spellId == 421330 or spellId == 421331) then -- Left Side / Right Side
			local oldSide = playerSide
			if spellId == 421330 then -- Left Side
				playerSide = 421356
			elseif spellId == 421331 then -- Right Side
				playerSide = 421359
			end
			-- XXX this could use some work, first side after soaking (every soak?) is apparently random
			-- first soak is between the 3rd and 4th cast, which forces the split (second: 8/9, third: 13/14)
			-- so should leave cast 4/9/14 as 30s for both sides and then correct the next cast for your side (like raszageth deep breaths)
			if scorchtailCrashCount == 4 and oldSide ~= playerSide and not showAllCasts then
				local cd = timer[playerSide][scorchtailCrashCount]
				local remaining = cd - (GetTime() - last)
				self:CDBar(420415, {remaining, cd}, CL.count:format(L.scorchtail_crash, scorchtailCrashCount))
			end
		end
	end
end

function mod:SerpentsFury(args)
	self:StopBar(CL.count:format(L.serpents_fury, serpentsFuryCount))
	self:Message(args.spellId, "cyan", CL.count:format(L.serpents_fury, serpentsFuryCount))
	self:PlaySound(args.spellId, "alert")
	serpentsFuryCount = serpentsFuryCount + 1
	if serpentsFuryCount < 5 then
		self:Bar(args.spellId, 70, CL.count:format(L.serpents_fury, serpentsFuryCount))
	elseif serpentsFuryCount == 5 then
		self:Bar(421703, 78) -- Serpent's Wrath
	end
	-- self:Bar(421207, 7.5) -- Coiling Flames
end

do
	local prev = 0
	function mod:CoilingFlamesApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId, nil, L.coiling_flames_single)
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, L.coiling_flames_single, nil, "Flames")
			if self:Mythic() then
				self:SayCountdown(args.spellId, 12, L.flood_of_the_firelands_single_wait, nil, "Wait") -- Wait countdown for Mythic, soak after
			elseif not self:LFR() then
				self:SayCountdown(args.spellId, 10)
			end
		end
		if self:Mythic() and args.time - prev > 2 then
			prev = args.time
			self:Bar(427201, 16, CL.count:format(CL.explosion, explosionCount))
			explosionCount = explosionCount + 1
		end
	end

	function mod:CoilingFlamesRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:FloodOfTheFirelands(args)
	self:StopBar(CL.count:format(CL.soaks, floodOfTheFirelandsCount))
	self:Message(args.spellId, "orange", CL.count:format(CL.soaks, floodOfTheFirelandsCount))
	self:PlaySound(args.spellId, "long")
	floodOfTheFirelandsCount = floodOfTheFirelandsCount + 1
	self:Bar(args.spellId, 70, CL.count:format(CL.soaks, floodOfTheFirelandsCount))
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(421616, "yellow", name, CL.count:format(CL.pools, volcanicDisgorgeCount-1))
		if self:Me(guid) then
			self:PlaySound(421616, "warning") -- move
			self:Say(421616, CL.pools, nil, "Pools")
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
	if args.amount % 3 == 0 then
		self:StackMessage(args.spellId, "purple", args.destName, args.amount, 6)
	end
end

do
	local cdTable = {
		[4] = 40,
		[6] = 40,
		[8] = 25,
		[9] = 25,
		[10] = 20,
	}
	function mod:CataclysmJaws(args)
		self:StopBar(CL.count:format(args.spellName, cataclysmJawsCount))
		self:Message(args.spellId, "purple", CL.count:format(args.spellName, cataclysmJawsCount))
		self:PlaySound(args.spellId, "alarm")
		cataclysmJawsCount = cataclysmJawsCount + 1
		self:Bar(args.spellId, cdTable[cataclysmJawsCount] or 30, CL.count:format(args.spellName, cataclysmJawsCount))
	end
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

-- Mythic

function mod:CoilingEruptionApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, CL.soak)
		self:PlaySound(args.spellId, "warning")
		self:Yell(args.spellId, CL.soak, nil, "Soak")
		self:YellCountdown(args.spellId, 4, CL.soak, nil, "Soak") -- Soak in 4
	end
end

function mod:CoilingEruptionRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelYellCountdown(args.spellId)
	end
end
