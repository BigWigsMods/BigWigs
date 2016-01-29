--------------------------------------------------------------------------------
-- TODO List:
-- - The whole fight (this mod is based on dungeon journal / wowhead guessing)

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nythendra", 1520)
if not mod then return end
mod:RegisterEnableMob(102672, 103160) -- fix me (i think 102672 is normal model and 103160 the model during Heart of the Swarm)
--mod.engageId = 1000000
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
		202977, -- Infested Breath
		{203096, "SAY", "FLASH", "PROXIMITY"}, -- Rot
		{204463, "SAY", "FLASH"}, -- Volatile Rot
		203552, -- Heart of the Swarm
		203045, -- Infested Ground
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "InfestedBreath", 202977) -- Pre alpha testing spellId
	self:Log("SPELL_AURA_APPLIED", "Rot", 203096) -- Pre alpha testing spellId
	self:Log("SPELL_AURA_REMOVED", "RotRemoved", 203096) -- Pre alpha testing spellId
	self:Log("SPELL_AURA_APPLIED", "VolatileRot", 204463) -- Pre alpha testing spellId
	self:Log("SPELL_CAST_START", "HeartOfTheSwarm", 203552) -- Pre alpha testing spellId
	self:Log("SPELL_AURA_APPLIED", "InfestedGroundDamage", 203045) -- Pre alpha testing spellId
	self:Log("SPELL_PERIODIC_DAMAGE", "InfestedGroundDamage", 203045) -- Pre alpha testing spellId
	self:Log("SPELL_PERIODIC_MISSED", "InfestedGroundDamage", 203045) -- Pre alpha testing spellId
end

function mod:OnEngage()
	self:Message("berserk", "Neutral", nil, "Nythendra (Alpha) Engaged (Pre Alpha Test Mod)", 23074) -- some red dragon icon
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:InfestedBreath(args)
	self:Message(args.spellId, "Urgent", "Alarm", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 7, CL.cast:format(args.spellName)) -- wowhead says cast time 2s + 5s channel
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:Rot(args)
	self:TargetMessage(args.spellId, args.destName, "Important", "Alert", nil, nil, true)
	self:TargetBar(args.spellId, 9, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:Flash(args.spellId)
		self:OpenProximity(args.spellId, 10)
	end
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:RotRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:VolatileRot(args)
	self:TargetMessage(args.spellId, args.destName, "Urgent", "Info", nil, nil, self:Tank())
	self:TargetBar(args.spellId, 8, args.destName)
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
		self:Flash(args.spellId)
	end
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
function mod:HeartOfTheSwarm(args)
	self:Message(args.spellId, "Attention", "Long", CL.casting:format(args.spellName))
	self:Bar(args.spellId, 22.5, CL.cast:format(args.spellName)) -- wowhead says cast time 2.5s + 20s channel
end

-- This function is from pre alpha testing. Please fix it or remove this comment if it's working
do
	local prev = 0
	function mod:InfestedGroundDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(args.spellId, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end