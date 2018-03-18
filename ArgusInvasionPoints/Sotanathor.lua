
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sothanar", 1779, 2014)
if not mod then return end
mod:RegisterEnableMob(124555)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		247698, -- Silence
		{247410, "TANK"}, -- Soul Cleave
		247416, -- Cavitation
		{247437, "SAY", "FLASH"}, -- Seed of Destruction
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)

	self:Log("SPELL_CAST_START", "Silence", 247698)
	self:Log("SPELL_CAST_START", "SoulCleave", 247410)
	self:Log("SPELL_AURA_APPLIED", "ClovenSoul", 247444)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ClovenSoul", 247444)
	self:Log("SPELL_CAST_SUCCESS", "Cavitation", 247416)
	self:Log("SPELL_CAST_SUCCESS", "SeedofDestruction", 247437)
	self:Log("SPELL_AURA_APPLIED", "SeedofDestructionApplied", 247437)
	self:Log("SPELL_AURA_REMOVED", "SeedofDestructionRemoved", 247437)

	self:Death("Win", 124555)
end

function mod:OnEngage()
	self:CheckForWipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Silence(args)
	self:Message(args.spellId, "Attention", "Long", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 25)
end

function mod:SoulCleave(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:CDBar(args.spellId, 25)
end

function mod:ClovenSoul(args)
	local amount = args.amount or 1
	self:StackMessage(247410, args.destName, amount, "Neutral", amount > 1 and "Warning" or "Info", args.spellId)
end

function mod:Cavitation(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:CDBar(args.spellId, 25)
end

function mod:SeedofDestruction(args)
	self:CDBar(args.spellId, 18)
end

do
	local playerList = mod:NewTargetList()
	function mod:SeedofDestructionApplied(args)
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 4)
		end
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Urgent", "Warning", nil, nil, true)
		end
	end

	function mod:SeedofDestructionRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end
