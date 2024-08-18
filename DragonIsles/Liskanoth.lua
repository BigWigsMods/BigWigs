--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Liskanoth, The Futurebane", -2085, 2518)
if not mod then return end
mod:RegisterEnableMob(193533) -- Liskanoth
mod.otherMenu = -1978
mod.worldBoss = 193533

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{391026, "CASTBAR"}, -- Deep Freeze
		389960, -- Binding Ice
	}
end

function mod:OnBossEnable()
	--self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")

	self:Log("SPELL_CAST_START", "Ascend", 389496)
	self:Log("SPELL_CAST_START", "DeepFreeze", 391026)
	self:Log("SPELL_AURA_APPLIED", "BindingIce", 389960)
end

function mod:OnEngage()
	--self:CheckForWipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(_, id)
	if id == 2652 then
		self:Win()
	end
end

function mod:Ascend(args)
	self:Message(391026, "yellow", CL.incoming:format(self:SpellName(391026)))
	self:PlaySound(391026, "long")
end

function mod:DeepFreeze(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 3)
	self:CDBar(args.spellId, 92)
end

function mod:BindingIce(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alert")
	end
end
