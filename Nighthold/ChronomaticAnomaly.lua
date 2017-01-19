
--------------------------------------------------------------------------------
-- TODO List:
-- - Respawn time
-- - Timers are an absolute nightmare. Each phase is different.
-- - timeBombCountdown is experimental
-- - TimeRelease aura could be hidden from cleu now, check on live

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Chronomatic Anomaly", 1088, 1725)
if not mod then return end
mod:RegisterEnableMob(104415)
mod.engageId = 1865
mod.respawnTime = 30 -- could be wrong

--------------------------------------------------------------------------------
-- Locals
--

local normalPhase = 1
local fastPhase = 1
local slowPhase = 1
local bombCount = 1
local releaseCount = 1
local bombSayTimers = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages", -- Speed: Slow / Normal / Fast
		{206607, "TANK"}, -- Chronometric Particles
		206609, -- Time Release
		{206617, "SAY"}, -- Time Bomb
		207871, -- Vortex (standing in stuff)
		212099, -- Temporal Charge
		211927, -- Power Overwhelming
		207976, -- Full Power (Berserk?)
		-13022, -- Waning Time Particle
		207228, -- Wrap Nightwell
	}, {
		["stages"] = "general",
		[-13022] = -13022,
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
	self:Log("SPELL_AURA_APPLIED", "ChronometricParticles", 206607)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ChronometricParticles", 206607)
	self:Log("SPELL_AURA_APPLIED", "TimeRelease", 206609)
	self:Log("SPELL_AURA_REMOVED", "TimeReleaseRemoved", 206609)
	self:Log("SPELL_CAST_SUCCESS", "TimeReleaseSuccess", 206610)
	self:Log("SPELL_AURA_APPLIED", "TimeBomb", 206617)
	self:Log("SPELL_AURA_APPLIED", "VortexDamage", 207871)
	self:Log("SPELL_PERIODIC_DAMAGE", "VortexDamage", 207871)
	self:Log("SPELL_PERIODIC_MISSED", "VortexDamage", 207871)
	self:Log("SPELL_AURA_APPLIED", "TemporalCharge", 212099)
	self:Log("SPELL_CAST_START", "PowerOverwhelming", 211927)
	self:Log("SPELL_CAST_START", "WarpNightwell", 207228)
	self:Log("SPELL_AURA_APPLIED", "FullPower", 207976) -- Pre alpha test spellId
end

function mod:OnEngage()
	-- Timers are in UNIT_SPELLCAST_SUCCEEDED
	normalPhase = 1
	fastPhase = 1
	slowPhase = 1
	bombCount = 1
	releaseCount = 1
	wipe(bombSayTimers)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function timeBombCountdown(self)
	local me = self:UnitName("player")
	local name, _, _, _, _, _, expires, _, _, _, _, _, _, _, _, timeMod = UnitDebuff("player", self:SpellName(206617))
	for _,timer in pairs(bombSayTimers) do
		self:CancelTimer(timer)
	end
	wipe(bombSayTimers)
	self:StopBar(206617, me)

	if not name then return end
	-- TODO experimental, needs work
	local remaining = floor(expires - GetTime()) -- floor((expires - GetTime()) / timeMod)
	self:TargetBar(206617, remaining, me)
	for i = 1, 3 do
		if remaining-i > 0 then
			bombSayTimers[#bombSayTimers+1] = self:ScheduleTimer("Say", remaining-i, 206617, i, true)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(unit, spellName, _, _, spellId)
	if spellId == 207012 then -- Speed: Normal
		self:Message("stages", "Neutral", "Info", spellName, spellId)

		timeBombCountdown(self)
		bombCount = 1
		releaseCount = 1

		if normalPhase == 1 then
			self:Bar(206609, 5) -- Time Release
			self:Bar(206617, 31.5) -- Time Bomb
			self:Bar(-13022, 25, CL.add, 207228) -- Big Add
		elseif normalPhase == 2 then
			--self:Bar(206609, ???) -- Time Release < unkown timer
			self:Bar(206617, 3) -- Time Bomb
			self:Bar(-13022, 16, CL.add, 207228) -- Big Add
		end

		normalPhase = normalPhase + 1
	elseif spellId == 207011 then -- Speed: Slow
		self:Message("stages", "Neutral", "Info", spellName, spellId)

		timeBombCountdown(self)
		bombCount = 1
		releaseCount = 1

		if slowPhase == 1 then
			self:Bar(206609, 10) -- Time Release
			self:Bar(206617, 15) -- Time Bomb
			self:Bar(-13022, 43, CL.add, 207228) -- Big Add
		end

		slowPhase = slowPhase + 1
	elseif spellId == 207013 then -- Speed: Fast
		self:Message("stages", "Neutral", "Info", spellName, spellId)

		timeBombCountdown(self)
		bombCount = 1
		releaseCount = 1

		if fastPhase == 1 then
			self:Bar(206609, 5) -- Time Release
			self:Bar(206617, 21) -- Time Bomb
			self:Bar(-13022, 38, CL.add, 207228) -- Big Add
		end

		fastPhase = fastPhase + 1
	elseif spellId == 206700 then -- Summon Slow Add
		self:Message(-13022, "Neutral", "Info", CL.spawning:format(CL.add), false)
	end
end

function mod:ChronometricParticles(args)
	local amount = args.amount or 1
	if amount % 2 == 0 or amount > 6 then -- might be different for each speed
		self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 6 and "Warning")
	end
end

do
	local list = mod:NewTargetList()
	function mod:TimeRelease(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.1, args.spellId, list, "Urgent")
		end

		if self:Me(args.destGUID) then
			local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
			if expires and expires > 0 then
				local timeLeft = expires - GetTime()
				self:TargetBar(args.spellId, timeLeft, args.destName)
			end
		end
	end
end

function mod:TimeReleaseRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(args.spellId, args.destName)
	end
end

function mod:TimeReleaseSuccess(args)
	self:Message(args.spellId, "Attention", "Alarm", CL.incoming:format(args.spellName))
	releaseCount = releaseCount + 1
	if normalPhase == 1 and releaseCount < 4 then
		self:Bar(206609, releaseCount == 3 and 25 or 15)
	elseif slowPhase == 1 and releaseCount < 3 then
		self:Bar(206609, 20)
	elseif fastPhase == 1 and releaseCount < 6 then
		self:Bar(206609, releaseCount == 2 and 7 or releaseCount == 3 and 13 or 5)
	end
end

do
	local list = mod:NewTargetList()
	function mod:TimeBomb(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.2, args.spellId, list, "Important", "Alert")
			bombCount = bombCount + 1
			if slowPhase == 1 then
				self:Bar(args.spellId, bombCount == 3 and 20 or 15)
			elseif normalPhase == 2 then
				self:Bar(args.spellId, 10)
			end
		end

		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			timeBombCountdown(self)
		end
	end
end

do
	local prev = 0
	function mod:VortexDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end

function mod:TemporalCharge(args)
	if UnitIsPlayer(args.destName) then
		self:TargetMessage(args.spellId, args.destName, "Positive", "Info")
	end
end

function mod:PowerOverwhelming(args)
	self:Message(args.spellId, "Attention", "Long", CL.casting:format(args.spellName))
	self:StopBar(206609) -- Time Release
	self:StopBar(206617) -- Time Bomb
end

function mod:WarpNightwell(args)
	self:Message(args.spellId, "Urgent", self:Interrupter(args.sourceGUID) and "Alert")
end

function mod:FullPower(args)
	self:TargetMessage(args.spellId, args.destName, "Neutral", "Long")
end
