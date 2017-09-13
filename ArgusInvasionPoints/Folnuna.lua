
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Matron Folnuna", nil, 2010, 1779)
if not mod then return end
mod:RegisterEnableMob(124514)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{247361, "TANK"}, -- Infected Claws
		247379, -- Slumbering Gasp
		254147, -- Fel Blast
		247443, -- Grotesque Spawn
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)

	self:Log("SPELL_AURA_APPLIED", "InfectedClaws", 247361)
	self:Log("SPELL_AURA_APPLIED_DOSE", "InfectedClaws", 247361)
	self:Log("SPELL_CAST_START", "SlumberingGasp", 247379)
	self:Log("SPELL_CAST_START", "FelBlast", 254147)
	self:Log("SPELL_CAST_START", "GrotesqueSpawn", 247443)


	self:RegisterEvent("BOSS_KILL")
end

function mod:OnEngage()
	self:CheckForWipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:InfectedClaws(args)
	local amount = args.amount or 1
	if amount % 2 == 0 then
		self:StackMessage(args.spellId, args.destName, amount, "Neutral", amount > 5 and "Alarm")
	end
end

function mod:SlumberingGasp(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:CDBar(args.spellId, 55)
	self:CastBar(args.spellId, 17)
end

function mod:FelBlast(args)
	if self:Interrupter(args.sourceGUID) then
		self:Message(args.spellId, "Attention", "Alert")
	end
end

function mod:GrotesqueSpawn(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:CDBar(args.spellId, 34)
end

function mod:BOSS_KILL(_, id)
	if id == 2081 then
		self:Win()
	end
end
