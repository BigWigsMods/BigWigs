
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Occularus", nil, 2013, 1779)
if not mod then return end
mod:RegisterEnableMob(124492)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{247318, "TANK"}, -- Gushing Wound
		{247325, "TANK"}, -- Lash
		247320, -- Searing Gaze
		247393, -- Phantasm
		247332, -- Eye Sore
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)

	self:Log("SPELL_AURA_APPLIED", "GushingWound", 247318)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GushingWound", 247318)
	self:Log("SPELL_CAST_SUCCESS", "Lash", 247325)
	self:Log("SPELL_CAST_START", "SearingGaze", 247320)
	self:Log("SPELL_CAST_SUCCESS", "Phantasm", 247393)
	self:Log("SPELL_CAST_SUCCESS", "EyeSore", 247332)

	self:Death("Win", 124492)
end

function mod:OnEngage()
	self:CheckForWipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--
function mod:GushingWound(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "Important", "Alarm")
end

function mod:Lash(args)
	self:Message(args.spellId, "Attention", "Info")
	--self:CDBar(args.spellId, 20)
end

function mod:SearingGaze(args)
	self:Message(args.spellId, "Urgent", "Warning", CL.casting:format(args.spellName))
	--self:CDBar(args.spellId, 15)
end

function mod:Phantasm(args)
	self:Message(args.spellId, "Neutral", "Long", CL.incoming:format(args.spellName))
	--self:CDBar(args.spellId, 20)
end

function mod:EyeSore(args)
	self:Message(args.spellId, "Attention", "Alert")
	--self:CDBar(args.spellId, 20)
end
