
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Tarlna the Ageless", 949, 1211)
if not mod then return end
mod:RegisterEnableMob(81535)
mod.otherMenu = 962
mod.worldBoss = 81535

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		175973, 175979, 176013, {176004, "DISPEL"}, "bosskill"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "ColossalBlow", 175973)
	self:Log("SPELL_CAST_START", "Genesis", 175979)
	self:Log("SPELL_CAST_SUCCESS", "GrowMandragora", 176013)
	self:Log("SPELL_CAST_SUCCESS", "SavageVines", 176001)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Death("Win", 81535)
end

function mod:OnEngage()
	--
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ColossalBlow(args)
	self:Message(args.spellId, "Important", "Alarm")
end

function mod:Genesis(args)
	self:Message(args.spellId, "Attention", "Long")
	self:Bar(args.spellId, 8, CL.cast:format(args.spellName))
end

function mod:GrowMandragora(args)
	self:Message(args.spellId, "Urgent", nil, CL.big_add)
end

function mod:SavageVines(args)
	if self:Dispeller("magic", nil, args.spellId) then
		self:Message(args.spellId, "Personal", "Alert")
	end
end

