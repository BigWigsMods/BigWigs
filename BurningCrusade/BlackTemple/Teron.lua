
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewBoss("Teron Gorefiend", 564, 1585)
if not mod then return end
mod:RegisterEnableMob(22871)
mod.engageId = 604
--mod.respawnTime = 0 -- Resets, doesn't respawn

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
	self:CDBar(40251, 10) -- Shadow of Death
	self:CDBar(40243, 15.7) -- Crushing Shadows
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:ShadowOfDeath(args)
	self:Bar(args.spellId, 62)
end

function mod:ShadowOfDeathApplied(args)
	self:TargetMessageOld(args.spellId, args.destName, "red", "warning")
	-- Used to be 55s, wowhead says 55s, timewalking logs say 30s
	self:TargetBar(args.spellId, 30, args.destName, 54224) -- 54224 = "Death" / ability_rogue_feigndeath / icon 132293
	self:PrimaryIcon(args.spellId, args.destName)
end

function mod:ShadowOfDeathRemoved(args)
	self:TargetBar(40251, 60, args.destName, 221641) -- 221641 = "Ghost" / achievement_halloween_ghost_01 / icon 236548
end

function mod:CrushingShadows(args)
	self:CDBar(args.spellId, 15.7) -- 15-21
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
