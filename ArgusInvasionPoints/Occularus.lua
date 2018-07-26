
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Occularus", 1779, 2013)
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

	self:Log("SPELL_CAST_SUCCESS", "GushingWoundSuccess", 247318)
	self:Log("SPELL_AURA_APPLIED", "GushingWound", 247318)
	self:Log("SPELL_AURA_APPLIED_DOSE", "GushingWound", 247318)
	self:Log("SPELL_CAST_SUCCESS", "Lash", 247325)
	self:Log("SPELL_CAST_START", "SearingGaze", 247320)
	self:Log("SPELL_CAST_SUCCESS", "Phantasm", 247393)
	self:Log("SPELL_CAST_SUCCESS", "EyeSore", 247332)
	self:Log("SPELL_AURA_APPLIED", "GroundEffects", 247330, 247372) -- Eye Sore, Phantasm
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundEffects", 247330, 247372) -- Eye Sore, Phantasm
	self:Log("SPELL_PERIODIC_MISSED", "GroundEffects", 247330, 247372) -- Eye Sore, Phantasm

	self:Death("Win", 124492)
end

function mod:OnEngage()
	self:CheckForWipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:GushingWoundSuccess(args)
	self:CDBar(args.spellId, 8.5)
end

function mod:GushingWound(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "red", "Alarm")
end

function mod:Lash(args)
	self:Message(args.spellId, "yellow", "Info")
	self:CDBar(args.spellId, 18)
end

function mod:SearingGaze(args)
	self:Message(args.spellId, "orange", "Warning", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 8.5)
end

function mod:Phantasm(args)
	self:Message(args.spellId, "cyan", "Long", CL.incoming:format(args.spellName))
	self:CDBar(args.spellId, 40)
end

function mod:EyeSore(args)
	self:Message(args.spellId, "yellow", "Alert", CL.incoming:format(args.spellName))
	self:CDBar(args.spellId, 23)
end

do
	local prev = 0
	function mod:GroundEffects(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 1.5 then
				prev = t
				self:Message(args.spellId == 247330 and 247332 or 247393, "blue", "Alarm", CL.underyou:format(args.spellName), args.spellId)
			end
		end
	end
end
