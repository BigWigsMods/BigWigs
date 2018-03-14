
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Mistress Alluradel", 1779, 2011)
if not mod then return end
mod:RegisterEnableMob(124625)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{247549, "EMPHASIZE"}, -- Beguiling Charm
		247604, -- Fel Lash
		247517, -- Heart Breaker
		{247544, "TANK"}, -- Sadist
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)

	self:Log("SPELL_CAST_START", "BeguilingCharm", 247549)
	self:Log("SPELL_CAST_START", "FelLash", 247604)
	self:Log("SPELL_CAST_SUCCESS", "HeartBreaker", 247517)
	self:Log("SPELL_AURA_APPLIED", "HeartBreakerApplied", 247517)
	self:Log("SPELL_AURA_APPLIED", "Sadist", 247544)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Sadist", 247544)

	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	self:CheckForWipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BeguilingCharm(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:CDBar(args.spellId, 37.5)
	self:CastBar(args.spellId, 4.5)
end

function mod:FelLash(args)
	self:Message(args.spellId, "Attention", "Alarm")
	self:CDBar(args.spellId, 32)
end

function mod:HeartBreaker(args)
	self:CDBar(args.spellId, 21.9)
end

function mod:HeartBreakerApplied(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Info")
	end
end

function mod:Sadist(args)
	local amount = args.amount or 1
	if amount % 2 == 0 then
		self:StackMessage(args.spellId, args.destName, amount, "Urgent", amount > 5 and "Alert")
	end
end

function mod:BOSS_KILL(_, id)
	if id == 2083 then
		self:Win()
	end
end

