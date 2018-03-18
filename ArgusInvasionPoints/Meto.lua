
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Inquisitor Meto", 1779, 2012)
if not mod then return end
mod:RegisterEnableMob(124592)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		247492, -- Reap
		247495, -- Sow
		247585, -- Seed of Chaos
		247632, -- Death Field
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "target", "nameplate1", "nameplate2") -- Try to grab the spellcast
	self:Log("SPELL_AURA_APPLIED", "SeedofChaosDamage", 247592)
	self:Log("SPELL_PERIODIC_DAMAGE", "SeedofChaosDamage", 247592)
	self:Log("SPELL_PERIODIC_MISSED", "SeedofChaosDamage", 247592)

	self:ScheduleTimer("CheckForEngage", 1)

	self:Log("SPELL_CAST_START", "Reap", 247492)
	self:Log("SPELL_AURA_APPLIED", "ReapApplied", 247492)
	self:Log("SPELL_CAST_START", "Sow", 247495)
	self:Log("SPELL_AURA_APPLIED", "SowApplied", 247495)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SowApplied", 247495)
	self:Log("SPELL_CAST_START", "DeathField", 247632)
	self:Log("SPELL_AURA_APPLIED", "DeathFieldApplied", 247632)

	self:Death("Win", 124592)
end

function mod:OnEngage()
	self:CheckForWipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local prev = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, spellName, _, _, spellId)
		if spellId == 247585 then -- Seed of Chaos
			local t = GetTime()
			if t-prev > 1.5 then
				prev = t
				self:Message(spellId, "Urgent", "Long", spellName)
				self:CDBar(spellId, 30)
			end
		end
	end
end

do
	local prev = 0
	function mod:SeedofChaosDamage(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 1.5 then
				prev = t
				self:Message(247585, "Positive", "Info", args.spellName, args.spellId)
			end
		end
	end
end

function mod:Reap(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:CDBar(args.spellId, 20)
end

function mod:ReapApplied(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
	end
end

function mod:Sow(args)
	self:Message(args.spellId, "Attention", "Alert")
	self:CDBar(args.spellId, 15)
end

function mod:SowApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		self:StackMessage(args.spellId, args.destName, amount, "Personal", "Warning")
	end
end

function mod:DeathField(args)
	self:CDBar(args.spellId, 15)
end

function mod:DeathFieldApplied(args)
	if self:Me(args.destGUID) then
		self:TargetMessage(args.spellId, args.destName, "Personal", "Alarm")
	end
end
