
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
		268198, -- Clinging Corruption
		274205, -- Depleted Energy
		269051, -- Cleansing Purge
		{267787, "TANK"}, -- Sundering Scalpel
		267795, -- Purifying Flame
		267878, -- Wind Tunnel
		268253, -- Surgical Beam
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "ClingingCorruption", 268198)
	self:Log("SPELL_AURA_APPLIED", "DepletedEnergy", 274205)
	self:Log("SPELL_CAST_SUCCESS", "CleansingPurge", 269051)
	self:Log("SPELL_CAST_SUCCESS", "CleansingPurgeFinished", 268089)
	self:Log("SPELL_CAST_START", "SunderingScalpelStart", 267787)
	self:Log("SPELL_CAST_SUCCESS", "SunderingScalpel", 267787)
	self:Log("SPELL_AURA_APPLIED", "SunderingScalpelApplied", 267787)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SunderingScalpelApplied", 267787)
	self:Log("SPELL_CAST_SUCCESS", "PurifyingFlame", 267795)
	self:Log("SPELL_PERIODIC_DAMAGE", "PurifyingFlameDamage", 268277)
	self:Log("SPELL_PERIODIC_MISSED", "PurifyingFlameDamage", 268277)
	self:Log("SPELL_CAST_SUCCESS", "WindTunnel", 267945, 267885, 267878) -- Room 1, Room 2 Left, Room 2 Right (Need to confirm which side is wich)
	self:Log("SPELL_CAST_SUCCESS", "SurgicalBeam", 269827)
	self:Log("SPELL_PERIODIC_DAMAGE", "SurgicalBeamDamage", 268253)
	self:Log("SPELL_PERIODIC_MISSED", "SurgicalBeamDamage", 268253)
end

function mod:OnEngage()
	self:Bar(267787, 5.8) -- Sundering Scalpel _start
	self:Bar(267795, 10.5) -- Purifying Flame
	self:Bar(267878, 20.5) -- Wind Tunnel
end

--------------------------------------------------------------------------------
-- Event Handlers
--

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
	local room = 0
	if self:MobId(args.sourceGUID) == 136429 then -- Room 1
		room = 1
	elseif self:MobId(args.sourceGUID) == 137022 then -- Room 2
		room = 2
	elseif self:MobId(args.sourceGUID) == 137023 then -- Room 3
		room = 3
	end
	self:Message(args.spellId, "cyan", nil, CL.count:format(args.spellName, room))
	self:PlaySound(args.spellId, "info")
	self:Bar(args.spellId, 182, CL.count:format(args.spellName, room))
end

function mod:CleansingPurgeFinished(args)
	local room = 0
	if self:MobId(args.sourceGUID) == 136429 then -- Room 1
		room = 1
	elseif self:MobId(args.sourceGUID) == 137022 then -- Room 2
		room = 2
	elseif self:MobId(args.sourceGUID) == 137023 then -- Room 3
		room = 3
	end
	self:Message(269051, "red", nil, CL.casting:format(CL.count:format(args.spellName, room))) -- XXX Casting or Activating?
	self:PlaySound(269051, "alarm")
end

function mod:SunderingScalpelStart(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:SunderingScalpel(args)
	self:Bar(args.spellId, 20.2) -- Cooldown until _start
end

function mod:SunderingScalpelApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "red")
	self:PlaySound(args.spellId, "alarm")
end

function mod:PurifyingFlame(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 23.2)
end

do
	local prev = 0
	function mod:PurifyingFlameDamage(args)
		if self:Me(args.destGUID) then
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:PlaySound(267795, "alarm")
				self:TargetMessage2(267795, "blue", args.destName, true)
			end
		end
	end
end

do
	local prev = 0
	function mod:WindTunnel(args) -- XXX We can track only the casts for room 1 if we do not need directions in room 2
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(267878, "red")
			self:PlaySound(267878, "warning")
			self:CastBar(267878, 11)
			self:Bar(267878, 40.5)
		end
	end
end

function mod:SurgicalBeam(args)
	self:Message(268253, "yellow")
	self:PlaySound(268253, "alert")
	self:Bar(268253, 30.5)
end

do
	local prev = 0
	function mod:SurgicalBeamDamage(args)
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
