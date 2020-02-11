--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Vaelastrasz the Corrupt", 469)
if not mod then return end
mod:RegisterEnableMob(13020)
mod:SetAllowWin(true)
mod.engageId = 611

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{18173, "ICON"}, -- Burning Adrenaline
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Adrenaline", self:SpellName(18173))

	self:Death("Win", 13020)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Adrenaline(args)
	self:TargetMessage(18173, args.destName, "yellow", "Alarm")
	self:PrimaryIcon(18173, args.destName)
	self:TargetBar(18173, 20, args.destName, 67729, 18173) -- Explode
end

