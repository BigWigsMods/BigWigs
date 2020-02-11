--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Broodlord Lashlayer", 469, 1531)
if not mod then return end
mod:RegisterEnableMob(12017)
mod.toggleOptions = {{40220, "ICON"}}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "MortalStrike", 24573)
	self:Log("SPELL_AURA_REMOVED", "MortalStrikeOver", 24573)

	self:Death("Win", 12017)
end

function mod:OnEngage()

end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MortalStrike(args)
	self:TargetMessage(40220, args.destName, "yellow")
	self:PrimaryIcon(40220, args.destName)
	self:TargetBar(40220, 5, args.destName)
end

function mod:MortalStrikeOver()
	self:PrimaryIcon(40220)
end

