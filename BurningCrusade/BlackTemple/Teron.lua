
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Teron Gorefiend", 564, 1585)
if not mod then return end
mod:RegisterEnableMob(22871)
mod:SetEncounterID(604)
mod:SetAllowWin(true)
--mod:SetRespawnTime(0) -- Resets, doesn't respawn

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{40251, "ICON"}, -- Shadow of Death
		40243, -- Crushing Shadows
		"berserk",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "ShadowOfDeath", 40251)
	self:Log("SPELL_AURA_APPLIED", "ShadowOfDeathApplied", 40251)
	self:Log("SPELL_AURA_REMOVED", "ShadowOfDeathRemoved", 40251)
	self:Log("SPELL_CAST_SUCCESS", "CrushingShadows", 40243)
	self:Log("SPELL_AURA_APPLIED", "CrushingShadowsApplied", 40243)
end

function mod:OnEngage()
	self:Berserk(600)
	self:CDBar(40251, 12.8) -- Shadow of Death
	self:CDBar(40243, 16.2) -- Crushing Shadows
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ShadowOfDeath(args)
	self:CDBar(args.spellId, 32) -- 32-40
end

function mod:ShadowOfDeathApplied(args)
	self:TargetMessageOld(args.spellId, args.destName, "red", "warning")
	self:TargetBar(args.spellId, 55, args.destName, nil, "ability_rogue_feigndeath")
	self:PrimaryIcon(args.spellId, args.destName)
end

function mod:ShadowOfDeathRemoved(args)
	self:TargetBar(40251, 60, args.destName, nil, "ability_vanish")
end

function mod:CrushingShadows(args)
	self:CDBar(args.spellId, 16.2) -- 16-24, shenanigans to skip? some logs have huge variance
end

do
	local list = mod:NewTargetList()
	function mod:CrushingShadowsApplied(args)
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessageOld", 0.3, args.spellId, list, "orange", "alert")
		end
	end
end
