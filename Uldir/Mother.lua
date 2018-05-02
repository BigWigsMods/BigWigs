--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("MOTHER", 1861, 2167)
if not mod then return end
mod:RegisterEnableMob(135452) -- MOTHER
mod.engageId = 2141
mod.respawnTime = 20

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		267821, -- Defense Grid
		268198, -- Clinging Corruption
		274205, -- Depleted Energy
		268095, -- Cleaning Purge
		{267787, "TANK"}, -- Sundering Scalpel
		267803, -- Purifying Flame
		267878, -- Wind Tunnel
		268253, -- Surgical Beam
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED_DOSE", "DefenseGridStacks", 267821)
	self:Log("SPELL_CAST_START", "ClingingCorruption", 268198)
	self:Log("SPELL_AURA_APPLIED", "DepletedEnergy", 274205)
	self:Log("SPELL_AURA_APPLIED", "CleansingPurge", 268095)
	-- self:Log("SPELL_CAST_SUCCESS", "SunderingScalpel", 267787)
	self:Log("SPELL_AURA_APPLIED", "SunderingScalpelApplied", 267787)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SunderingScalpelApplied", 267787)
	-- self:Log("SPELL_CAST_START", "PurifyingFlame", 267803)
	self:Log("SPELL_CAST_SUCCESS", "WindTunnel", 267878)
	self:Log("SPELL_CAST_SUCCESS", "SurgicalBeam", 268253)
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 268253) -- Surgical Beam
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 268253, 267803) -- Surgical Beam, Purifying Flame
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 268253, 267803)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:DefenseGridStacks(args)
	local _, _, _, _, _, _, _, _, playersInRaid = GetInstanceInfo()
	if args.amount % 5 == 0 or args.amount > playersInRaid then
		self:Message(args.spellId, "cyan", nil, CL.count:format(args.spellName, args.amount))
		self:PlaySound(args.spellId, args.amount > 16 and "alarm" or "info")
	end
end

function mod:ClingingCorruption(args)
	self:Message(args.spellId, "orange")
	if self:Interrupter() then
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:DepletedEnergy(args)
	self:TargetMessage2(args.spellId, "green", args.destName)
	self:PlaySound(args.spellId, "long")
end

function mod:CleansingPurge(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "info")
end

-- function mod:SunderingScalpel(args)
-- 	self:Bar(args.spellId, 10)
-- end

function mod:SunderingScalpelApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, args.amount, "red")
	if self:Me(args.destGUID) or amount > 1 then
		self:PlaySound(args.spellId, "alarm", args.destName)
	end
end

function mod:SurgicalBeam(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

-- function mod:PurifyingFlame(args)
-- 	self:Message(args.spellId, "yellow")
-- 	self:PlaySound(args.spellId, "alert")
-- end

function mod:WindTunnel(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, 11)
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
