if not IsTestBuild() then return end
if UnitFactionGroup("player") ~= "Alliance" then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Grong the Revenant", 2070, 2340)
if not mod then return end
mod:RegisterEnableMob(144638)
mod.engageId = 2263
--mod.respawnTime = 31

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Localization
--

--local L = mod:GetLocale()
--if L then
--
--end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Grong ]]--
		282399, -- Death Knel
		{285671, "TANK"}, -- Crushed
		{285875, "TANK"}, -- Rending Bite
		282543, -- Deathly Slam
		285994, -- Ferocious Roar.
		--[[ Death Specter ]]--
		282471, -- Voodoo Blast
		282533, -- Death Empowerment
		286434, -- Shadow Core
		286435, -- Discharge Shadow Core
	}
end

function mod:OnBossEnable()
	--[[ Grong ]]--
	self:Log("SPELL_CAST_START", "DeathKnel", 282399)
	self:Log("SPELL_AURA_APPLIED", "CrushedApplied", 285671)
	self:Log("SPELL_AURA_APPLIED_DOSE", "CrushedApplied", 285671)
	self:Log("SPELL_AURA_APPLIED", "RendingBiteApplied", 285875)
	self:Log("SPELL_AURA_APPLIED_DOSE", "RendingBiteApplied", 285875)
	self:Log("SPELL_CAST_SUCCESS", "DeathlySlam", 282543)
	self:Log("SPELL_CAST_START", "FerociousRoar", 285994)
	--[[ Death Specter ]]--
	self:Log("SPELL_CAST_SUCCESS", "VoodooBlast", 282471)
	self:Log("SPELL_CAST_START", "DeathEmpowerment", 282533)
	self:Log("SPELL_AURA_APPLIED", "ShadowCore", 286434)
	self:Log("SPELL_CAST_START", "DischargeShadowCore", 286435)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:DeathKnel(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
	self:CastBar(args.spellId, 5) -- 1s + 4s Channel
end

function mod:CrushedApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alarm", nil, args.destName)
end

function mod:RendingBiteApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alert", nil, args.destName)
end

function mod:DeathlySlam(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:FerociousRoar(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

function mod:VoodooBlast(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:DeathEmpowerment(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:ShadowCore(args)
	self:TargetMessage2(args.spellId, "green", args.destName)
end

function mod:DischargeShadowCore(args)
	self:Message2(args.spellId, "green")
	self:PlaySound(args.spellId, "info")
end