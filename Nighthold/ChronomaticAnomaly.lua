

--------------------------------------------------------------------------------
-- TODO List:
-- - Fix remaining spellId guesses
-- - Respawn time
-- - Tuning sounds / message colors
-- - Remove alpha engaged message
-- - check Power Overwhelming duration
-- - fix stages (auras were hidden in the last testing)

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Chronomatic Anomaly", 1088, 1725)
if not mod then return end
mod:RegisterEnableMob(105248) -- fix me
mod.engageId = 1865
--mod.respawnTime = 0

--------------------------------------------------------------------------------
-- Locals
--

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
		206614, -- Burst of Time
		206609, -- Time Release
		{206617, "SAY"}, -- Time Bomb
		207871, -- Vortex (standing in stuff)
		212099, -- Temporal Charge
		212115, -- Temporal Smash
		211927, -- Power Overwhelming
		207976, -- Full Power (Berserk?)
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Stages", 207011, 207012, 207013) -- Pre alpha test spellId
	self:Log("SPELL_AURA_APPLIED", "ChronometricParticles", 206607)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ChronometricParticles", 206607)
	self:Log("SPELL_CAST_SUCCESS", "BurstOfTime", 206614)
	self:Log("SPELL_AURA_APPLIED", "TimeRelease", 206609)
	self:Log("SPELL_AURA_REMOVED", "TimeReleaseRemoved", 206609)
	self:Log("SPELL_AURA_APPLIED", "TimeBomb", 206617)
	self:Log("SPELL_AURA_APPLIED", "VortexDamage", 207871)
	self:Log("SPELL_PERIODIC_DAMAGE", "VortexDamage", 207871)
	self:Log("SPELL_PERIODIC_MISSED", "VortexDamage", 207871)
	self:Log("SPELL_AURA_APPLIED", "TemporalCharge", 212099)
	self:Log("SPELL_AURA_APPLIED", "TemporalSmash", 212115)
	self:Log("SPELL_CAST_START", "PowerOverwhelming", 211927)
	self:Log("SPELL_AURA_APPLIED", "FullPower", 207976) -- Pre alpha test spellId
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Chronomatic Anomaly (Alpha) Engaged (Post Alpha Heroic Test Mod)")
	self:Bar(211927, 60)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Stages(args)
	self:Message("stages", "Neutral", "Info", args.spellName, args.spellId)
end

function mod:ChronometricParticles(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 7 and "Warning") -- something bad happens at 10 stacks?!
end

function mod:BurstOfTime(args)
	self:Message(args.spellId, "Attention", "Alarm")
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
	self:StopBar(args.spellId, args.destName)
end

function mod:TimeBomb(args)
	local _, _, _, _, _, _, expires = UnitDebuff(args.destName, args.spellName)
	local remaining = expires-GetTime()
	self:TargetMessage(args.spellId, args.destName, "Important")
	self:TargetBar(args.spellId, remaining, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:ScheduleTimer("Say", remaining-3, args.spellId, 3, true)
		self:ScheduleTimer("Say", remaining-2, args.spellId, 2, true)
		self:ScheduleTimer("Say", remaining-1, args.spellId, 1, true)
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
	self:TargetMessage(args.spellId, args.destName, "Positive")
end

function mod:TemporalSmash(args)
	self:Message(args.spellId, "Positive", "Info")
end

function mod:PowerOverwhelming(args)
	self:Message(args.spellId, "Attention", "Long", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 65, CL.cast:format(args.spellName))
end

function mod:FullPower(args)
	self:TargetMessage(args.spellId, args.destName, "Neutral")
end
