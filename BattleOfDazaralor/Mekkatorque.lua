if not IsTestBuild() then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("High Tinker Mekkatorque", 2070, 2334)
if not mod then return end
mod:RegisterEnableMob(0)
mod.engageId = 2276
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
		-- General
		282153, -- Buster Cannon
		282205, -- Blast Off
		{283409, "SAY", "SAY_COUNTDOWN"}, -- Gigavolt Charge
		287952, -- Dimensional Ripper XL
		284042, -- Deploy Spark Bot
		288049, -- Shrink Ray
		286051, -- Hyperdrive
		-- Intermission
		287929, -- Signal Exploding Sheep
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "BusterCannon", 282153)
	self:Log("SPELL_CAST_START", "BlastOff", 282205)
	self:Log("SPELL_AURA_APPLIED", "GigavoltChargeApplied", 283409)
	self:Log("SPELL_AURA_REMOVED", "GigavoltChargeRemoved", 283409)
	self:Log("SPELL_CAST_START", "DimensionalRipperXL", 287952)
	self:Log("SPELL_CAST_SUCCESS", "DeploySparkBot", 284042)
	self:Log("SPELL_CAST_START", "ShrinkRay", 288049)
	self:Log("SPELL_AURA_APPLIED", "Hyperdrive", 286051)
	self:Log("SPELL_CAST_START", "SignalExplodingSheep", 287929)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BusterCannon(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:BlastOff(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:GigavoltChargeApplied(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, 15)
	end
end

function mod:GigavoltChargeRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:DimensionalRipperXL(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
end

function mod:DeploySparkBot(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:ShrinkRay(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
end

function mod:Hyperdrive(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:SignalExplodingSheep(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
end
