
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Mistress Alluradel", -1197, 1779)
if not mod then return end
mod:RegisterEnableMob(124625)
mod.otherMenu = 1779
mod.worldBoss = 124625

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		247549, -- Beguiling Charm
		247604, -- Fel Lash
		247517, -- Heart Breaker
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)

	self:Log("SPELL_CAST_START", "BeguilingCharm", 247549)
	self:Log("SPELL_CAST_START", "FelLash", 247604)
	self:Log("SPELL_CAST_SUCCESS", "HeartBreaker", 247517)
	self:Log("SPELL_AURA_APPLIED", "HeartBreakerApplied", 247517)

	self:Death("Win", 117239)
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
