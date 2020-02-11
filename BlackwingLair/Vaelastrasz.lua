--------------------------------------------------------------------------------
-- Module declaration
--

local mod = BigWigs:NewBoss("Vaelastrasz the Corrupt", 469, 1530)
if not mod then return end
mod:RegisterEnableMob(13020)
mod.toggleOptions = {{18173, "ICON"}}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Adrenaline", 18173)

	self:Death("Win", 13020)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Adrenaline(args)
	self:TargetMessage(args.spellId, args.destName, "yellow", "Alarm")
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetBar(args.spellId, 20, args.destName, 67729, args.spellId) -- Explode
end

