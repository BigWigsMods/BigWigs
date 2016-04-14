--------------------------------------------------------------------------------
-- TODO List:
-- - Remove all unnecessary spellIds (guesses from wowhead) and throw in some args.spellId instead
-- - Respawn time
-- - Tuning sounds / message colors
-- - Remove alpha engaged message

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Chronomatic Anomaly", 1033, 1725)
if not mod then return end
mod:RegisterEnableMob(105248) -- fix me
--mod.engageId = 1000000
--mod.respawnTime = 0

--------------------------------------------------------------------------------
-- Locals
--
local temporalChargeOnMe = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		206607, -- Chronometric Particles
		206614, -- Burst of Time
		206609, -- Time Release
		{206617, "SAY"}, -- Time Bomb
		207871, -- Vortex (standing in stuff)
		207063, -- Tachyon Burst
		212099, -- Temporal Charge
		{211927, "FLASH"}, -- Power Overwhelming
		207976, -- Full Power (Berserk?)
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "ChronometricParticles", 206607) -- Pre alpha test spellId
	self:Log("SPELL_AURA_APPLIED_DOSE", "ChronometricParticles", 206607) -- Pre alpha test spellId
	self:Log("SPELL_CAST_SUCCESS", "BurstOfTime", 206614, 214050, 206612, 206613, 214049) -- ALL THE (pre alpha) SPELLIDS!
	self:Log("SPELL_AURA_APPLIED", "TimeRelease", 206608, 206609, 206610, 207051, 207052) -- Pre alpha test spellId, like all of them
	self:Log("SPELL_AURA_APPLIED", "TimeBomb", 212845, 206618, 206617, 206615) -- Pre alpha test spellId, betting 1 curse point on 206617
	self:Log("SPELL_AURA_APPLIED", "VortexDamage", 207871) -- Pre alpha test spellId
	self:Log("SPELL_PERIODIC_DAMAGE", "VortexDamage", 207871) -- Pre alpha test spellId
	self:Log("SPELL_PERIODIC_MISSED", "VortexDamage", 207871) -- Pre alpha test spellId
	self:Log("SPELL_CAST_START", "TachyonBurst", 207063) -- Pre alpha test spellId
	self:Log("SPELL_AURA_APPLIED", "TemporalCharge", 212099) -- Pre alpha test spellId
	self:Log("SPELL_AURA_REMOVED", "TemporalChargeRemoved", 212099) -- Pre alpha test spellId
	self:Log("SPELL_CAST_START", "PowerOverwhelming", 211927) -- Pre alpha test spellId
	self:Log("SPELL_AURA_APPLIED", "FullPower", 207976) -- Pre alpha test spellId
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Chronomatic Anomaly (Alpha) Engaged (Pre Alpha Test Mod)")
	temporalChargeOnMe = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ChronometricParticles(args)
	local amount = args.amount or 1
	-- if amount > 7 or tank...
	self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 7 and "Warning") -- something bad happens at 10 stacks?!
end

function mod:BurstOfTime(args)
	self:Message(206614, "Attention") -- might be spammy. like a lot of spam, dunno
end

function mod:TimeRelease(args)
	-- target needs to be healed, so message and bar should be healer and target only later
	self:TargetMessage(206609, args.destName, "Urgent")
	self:TargetBar(206609, 30, args.destName)
	-- messages of absorb remaining, might be useful?
end

function mod:TimeBomb(args)
	local _, _, _, _, _, _, expires = UnitDebuff(args.destName, args.spellName)
	local remaining = expires-GetTime()
	self:TargetMessage(206617, args.destName, "Important")
	self:TargetBar(206617, remaining, args.destName)

	self:Say(206617)
	self:ScheduleTimer("Say", remaining-3, 206617, 3, true)
	self:ScheduleTimer("Say", remaining-2, 206617, 2, true)
	self:ScheduleTimer("Say", remaining-1, 206617, 1, true)
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

function mod:TachyonBurst(args)
	self:Message(args.spellId, "Urgent", nil, CL.incoming:format(args.spellName))
end

function mod:TemporalCharge(args)
	self:TargetMessage(args.spellId, args.spellName, "Positive")
	temporalChargeOnMe = true
end

function mod:TemporalChargeRemoved(args)
	temporalChargeOnMe = nil
end

function mod:PowerOverwhelming(args)
	self:Message(args.spellId, "Attention", "Long", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 5, CL.cast:format(args.spellName))
	if temporalChargeOnMe then
		self:Flash(args.spellId)
		self:Message(args.spellId, "Personal", nil, "Move to the thing to stop the cast or something, just do it!") -- alpha message
	end
end

function mod:FullPower(args)
	self:TargetMessage(args.spellId, args.destName, "Neutral")
end