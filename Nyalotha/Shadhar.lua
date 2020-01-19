--------------------------------------------------------------------------------
-- TODO:
--
-- - Combine Breaths into 1 option/function

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Shad'har the Insatiable", 2217, 2367)
if not mod then return end
mod:RegisterEnableMob(157231) -- Shad'har the Insatiable
mod.engageId = 2335
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{307471, "TANK"}, -- Crush
		{307472, "TANK_HEALER"}, -- Dissolve
		312528, -- Volatile Breath
		312529, -- Bubbling Breath
		312530, -- Entropic Breath
		307358, -- Debilitating Spit
		306942, -- Frenzy
	}
end

function mod:OnBossEnable()
	--self:Log("SPELL_CAST_START", "CrushStart", 307471)
	self:Log("SPELL_CAST_SUCCESS", "CrushSuccess", 307471)
	self:Log("SPELL_AURA_APPLIED", "DissolveApplied", 307472)
	self:Log("SPELL_CAST_START", "VolatileBreath", 312528)
	self:Log("SPELL_CAST_START", "BubblingBreath", 312529)
	self:Log("SPELL_CAST_START", "EntropicBreath", 312530)
	self:Log("SPELL_CAST_SUCCESS", "DebilitatingSpit", 307358)

	self:Log("SPELL_AURA_APPLIED", "FrenzyApplied", 306942)
end

function mod:OnEngage()
	stage = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CrushSuccess(args)
	self:TargetMessage2(args.spellId, "purple", args.destName)
	self:PlaySound(args.spellId, "alarm")
	--self:Bar(args.spellId, 25)
end

function mod:DissolveApplied(args)
	self:TargetMessage2(args.spellId, "cyan", args.destName)
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 25)
end

function mod:VolatileBreath(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 25)
end

function mod:BubblingBreath(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 25)
end

function mod:EntropicBreath(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 25)
end

function mod:DebilitatingSpit(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 25)
end

function mod:FrenzyApplied(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 25)
end
