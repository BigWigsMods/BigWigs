-------------------------------------------------------------------------------
--  Module Declaration
--

local mod, CL = BigWigs:NewBoss("Akil'zon", 568, 186)
if not mod then return end
mod:RegisterEnableMob(23574)
mod:SetEncounterID(1189)
mod:SetRespawnTime(60)

-------------------------------------------------------------------------------
--  Initialization
--

function mod:GetOptions()
	return {
		{43622, "PROXIMITY"}, -- Static Disruption
		{43648, "PROXIMITY", "ICON"}, -- Electrical Storm
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "ElectricalStorm", 43648)
	self:Log("SPELL_AURA_REMOVED", "ElectricalStormRemoved", 43648)
end

function mod:OnEngage()
	self:CDBar(43648, 50) -- Electrical Storm
	self:OpenProximity(43622, 5) -- Static Disruption
	self:Berserk(600)
end

-------------------------------------------------------------------------------
--  Event Handlers
--

function mod:ElectricalStorm(args)
	self:CloseProximity(43622) -- Static Disruption
	if not self:Me(args.destGUID) then
		self:OpenProximity(args.spellId, 20, args.destName, true)
	end
	self:TargetMessageOld(args.spellId, args.destName, "red", "alert")
	self:Bar(args.spellId, 8)
	self:PrimaryIcon(args.spellId, args.destName)
end

function mod:ElectricalStormRemoved(args)
	self:CloseProximity(args.spellId)
	self:OpenProximity(43622, 5) -- Static Disruption
	self:PrimaryIcon(args.spellId)
	self:CDBar(args.spellId, 40)
end

