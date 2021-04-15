--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Rage Winterchill", 534, 1577)
if not mod then return end
mod:RegisterEnableMob(17767)
mod:SetAllowWin(true)
mod:SetEncounterID(2468)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{31258, "FLASH"}, {31249, "ICON"}, "berserk"
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Icebolt", 31249)
	self:Log("SPELL_AURA_APPLIED", "DeathAndDecay", 31258)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	self:Death("Win", 17767)
end

function mod:OnEngage()
	self:Berserk(600)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Icebolt(args)
	self:TargetMessageOld(args.spellId, args.destName, "red", "alert")
	self:PrimaryIcon(args.spellId, args.destName)
end

function mod:DeathAndDecay(args)
	if self:Me(args.destGUID) then
		self:MessageOld(args.spellId, "blue", "alarm")
		self:Flash(args.spellId)
	end
end

