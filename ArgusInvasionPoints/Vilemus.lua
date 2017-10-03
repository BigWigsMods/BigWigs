
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Pit Lord Vilemus", nil, 2015, 1779)
if not mod then return end
mod:RegisterEnableMob(124719)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{247739, "TANK"}, -- Drain
		247733, -- Stomp
		247731, -- Fel Breath
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)

	self:Log("SPELL_AURA_APPLIED", "Drain", 247739)
	self:Log("SPELL_CAST_START", "Stomp", 247733)
	self:Log("SPELL_CAST_START", "FelBreath", 247731)

	self:Death("Win", 124719)
end

function mod:OnEngage()
	self:CheckForWipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Drain(args)
	self:TargetMessage(args.spellId, args.destName, "Attention", "Alert", nil, nil, true)
	--self:CDBar(args.spellId, 34)
end


function mod:Stomp(args)
	self:Message(args.spellId, "Urgent", "Warning")
	--self:CDBar(args.spellId, 34)
end

function mod:FelBreath(args)
	self:Message(args.spellId, "Important", "Long")
	--self:CDBar(args.spellId, 34)
end
