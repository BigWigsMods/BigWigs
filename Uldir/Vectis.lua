--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vectis", 1861, 2166)
if not mod then return end
mod:RegisterEnableMob(134442) -- Blood of G'huun
mod.engageId = 2088
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{265178, "TANK"}, -- Mutagenic Pathogen
		{265212, "SAY", "ICON"}, -- Gestate
		265217, -- Liquefy
		266948, -- Hypergenesis
	}
end

function mod:OnBossEnable()
	--self:Log("SPELL_CAST_SUCCESS", "MutagenicPathogen", 265178)
	self:Log("SPELL_AURA_APPLIED", "MutagenicPathogenApplied", 265178)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MutagenicPathogenApplied", 265178)
	self:Log("SPELL_AURA_APPLIED", "GestateApplied", 265212)
	self:Log("SPELL_AURA_REMOVED", "GestateRemoved", 265212)
	self:Log("SPELL_CAST_START", "Liquefy", 265217)
	self:Log("SPELL_CAST_SUCCESS", "Hypergenesis", 266948)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- function mod:MutagenicPathogen(args)
-- 	self:Bar(args.spellId, 10)
-- end

function mod:MutagenicPathogenApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alert", args.destName)
end

function mod:GestateApplied(args) -- XXX Proximity open
	self:TargetMessage2(args.spellId, "orange", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alert")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 5)
	end
	self:PrimaryIcon(args.spellId, args.destName)
end

function mod:GestateApplied(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	self:PrimaryIcon(args.spellId)
end

function mod:Liquefy(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
end

function mod:Hypergenesis(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end
