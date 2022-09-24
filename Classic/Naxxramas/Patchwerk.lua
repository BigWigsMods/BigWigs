--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Patchwerk", 533, 1610)
if not mod then return end
mod:RegisterEnableMob(16028)
mod:SetEncounterID(1118)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		28131, -- Enrage
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Frenzy", 28131)
end

function mod:OnEngage()
	self:Berserk(420)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Frenzy(args)
	self:Message(28131, "orange", CL.percent:format(5, args.spellName))
	self:PlaySound(28131, "alarm")
end
