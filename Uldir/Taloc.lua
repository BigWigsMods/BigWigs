--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Taloc", 1861, 2168)
if not mod then return end
mod:RegisterEnableMob(137119)
mod.engageId = 2144
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		271222, -- Plasma Discharge
		270290, -- Blood Storm
		{271296, "TANK"}, -- Cudgel of Gore
		271728, -- Retrieve Cudgel
		272582, -- Sanguine Static
		271965, -- Powered Down
		275432, -- Uldir Defensive Beam
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "PlasmaDischarge", 271222)
	self:Log("SPELL_CAST_START", "CudgelofGore", 271296)
	self:Log("SPELL_CAST_START", "RetrieveCudgel", 271728)
	self:Log("SPELL_CAST_SUCCESS", "SanguineStatic", 272582)
	self:Log("SPELL_AURA_APPLIED", "PoweredDown", 271965)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 270290, 275432) -- Blood Storm, Uldir Defensive Beam
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 270290, 275432)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 270290, 275432)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:PlasmaDischarge(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:CudgelofGore(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 4.5)
end

function mod:RetrieveCudgel(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:SanguineStatic(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:PoweredDown(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:TargetMessage2(args.spellId, "blue", args.destName, true)
			end
		end
	end
end
