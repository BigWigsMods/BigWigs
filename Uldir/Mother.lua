
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("MOTHER", 1861, 2167)
if not mod then return end
mod:RegisterEnableMob(135452) -- MOTHER
mod.engageId = 2141
mod.respawnTime = 26

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local nextBeam = nil

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.sideLaser = "(Side) Beams" -- short for: (location) Uldir Defensive Beam
	L.upLaser = "(Roof) Beams"
	L.mythic_beams = "Beams"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		268198, -- Clinging Corruption
		274205, -- Depleted Energy
		269051, -- Cleansing Purge
		267787, -- Sanitizing Strike
		267795, -- Purifying Flame
		267878, -- Wind Tunnel
		268253, -- Uldir Defensive Beam
		-- Mythic
		{279662, "SAY", "SAY_COUNTDOWN", "FLASH"}, -- Endemic Virus
	},{
		[268198] = CL.general,
		[279662] = CL.mythic,
	}
end

function mod:VerifyEnable(unit)
	local hp = UnitHealthMax(unit)
	return hp > 0 and (UnitHealth(unit) / hp) > 0.2 -- 20%
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4")

	self:Log("SPELL_CAST_START", "ClingingCorruption", 268198)
	self:Log("SPELL_AURA_APPLIED", "DepletedEnergy", 274205)
	self:Log("SPELL_CAST_SUCCESS", "CleansingPurgeFinished", 268089)
	self:Log("SPELL_CAST_START", "SanitizingStrikeStart", 267787)
	self:Log("SPELL_CAST_SUCCESS", "SanitizingStrike", 267787)
	self:Log("SPELL_AURA_APPLIED", "SanitizingStrikeApplied", 267787)
	self:Log("SPELL_AURA_APPLIED_DOSE", "SanitizingStrikeApplied", 267787)
	self:Log("SPELL_CAST_SUCCESS", "PurifyingFlame", 267795)
	self:Log("SPELL_PERIODIC_DAMAGE", "PurifyingFlameDamage", 268277)
	self:Log("SPELL_PERIODIC_MISSED", "PurifyingFlameDamage", 268277)
	self:Log("SPELL_CAST_SUCCESS", "WindTunnel", 267945)
	self:Log("SPELL_CAST_SUCCESS", "UldirDefensiveBeam", 277973, 277742, 269827) -- Sideways Beams, Room 2 Roof Beams, Room 3 Roof Beams
	self:Log("SPELL_PERIODIC_DAMAGE", "UldirDefensiveBeamDamage", 268253)
	self:Log("SPELL_PERIODIC_MISSED", "UldirDefensiveBeamDamage", 268253)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "EndemicVirusApplied", 279662)
	self:Log("SPELL_AURA_REMOVED", "EndemicVirusRemoved", 279662)
end

function mod:OnEngage()
	stage = 1
	self:Bar(267787, 5.8) -- Sanitizing Strike _start
	self:Bar(267795, 10.5) -- Purifying Flame
	self:Bar(267878, 20.5) -- Wind Tunnel
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellId)
	if spellId == 269051 then -- Cleansing Purge
		local sourceGUID = UnitGUID(unit)
		local room = 0
		if self:MobId(sourceGUID) == 136429 then -- Room 1
			room = 1
		elseif self:MobId(sourceGUID) == 137022 then -- Room 2
			room = 2
			if self:Mythic() then
				nextBeam = L.mythic_beams
				self:CDBar(268253, 11, L.mythic_beams)
			else
				nextBeam = L.sideLaser
				self:CDBar(268253, 20, L.sideLaser)
			end
		elseif self:MobId(sourceGUID) == 137023 then -- Room 3
			room = 3
			stage = 3
			self:StopBar(L.sideLaser)
			self:StopBar(L.upLaser)
			self:StopBar(L.mythic_beams)
			nextBeam = self:Mythic() and L.mythic_beams or L.sideLaser
			self:CDBar(268253, 10, self:Mythic() and L.mythic_beams or L.sideLaser)
		end
		self:Message2(spellId, "cyan", CL.count:format(self:SpellName(spellId), room), "ability_mage_firestarter")
		self:PlaySound(spellId, "info")
		self:Bar(spellId, self:Mythic() and 121.5 or 182, CL.count:format(self:SpellName(spellId), room), "ability_mage_firestarter")
	end
end

function mod:ClingingCorruption(args)
	self:Message2(args.spellId, "orange")
	local _, ready = self:Interrupter()
	if ready then
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:DepletedEnergy(args)
	self:TargetMessage2(args.spellId, "green", args.destName) -- Cast on herself
	self:PlaySound(args.spellId, "long")
end

function mod:CleansingPurgeFinished(args)
	local room = 0
	if self:MobId(args.sourceGUID) == 136429 then -- Room 1
		room = 1
	elseif self:MobId(args.sourceGUID) == 137022 then -- Room 2: Triggers on the pull, but that's okay.
		room = 2
	elseif self:MobId(args.sourceGUID) == 137023 then -- Room 3
		room = 3
	end
	self:Message2(269051, "red", CL.casting:format(CL.count:format(args.spellName, room)), "ability_mage_firestarter") -- XXX Casting or Activating?
	self:PlaySound(269051, "alarm")
end

function mod:SanitizingStrikeStart(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
end

function mod:SanitizingStrike(args)
	self:Bar(args.spellId, 20.2) -- Cooldown until _start
end

function mod:SanitizingStrikeApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "red")
	self:PlaySound(args.spellId, "alarm", nil, args.destName)
end

function mod:PurifyingFlame(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 23.2)
end

do
	local prev = 0
	function mod:PurifyingFlameDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(267795, "alarm")
				self:PersonalMessage(267795, "underyou")
			end
		end
	end
end

function mod:WindTunnel(args)
	self:Message2(267878, "red")
	self:PlaySound(267878, "warning")
	self:CastBar(267878, 11)
	self:CDBar(267878, 42.5)
	if stage > 1 and self:BarTimeLeft(nextBeam) < 11 then -- No beams during winds
		self:CDBar(268253, 11, nextBeam)
	end
end

function mod:UldirDefensiveBeam(args)
	local beamType, castTime, timer = nil, nil, nil
	if self:Easy() then
		beamType = L.sideLaser
		castTime = 4
		nextBeam = L.sideLaser
		timer = 31.5
	elseif self:Mythic() then
		beamType = L.mythic_beams
		castTime = 4
		nextBeam = L.mythic_beams
		timer = stage == 3 and 23 or 51
	elseif args.spellId == 277973 then
		beamType = L.sideLaser
		castTime = 4
		nextBeam = L.upLaser
		timer = stage == 3 and 30 or 24
	else
		beamType = L.upLaser
		castTime = 8
		nextBeam = L.sideLaser
		timer = stage == 3 and 16 or 17
	end
	self:StopBar(L.sideLaser)
	self:StopBar(L.upLaser)
	self:Message2(268253, "yellow", beamType)
	self:PlaySound(268253, "alert")
	self:CastBar(268253, castTime, beamType)
	self:CDBar(268253, timer, nextBeam)
	if self:BarTimeLeft(self:SpellName(267878)) < 8 then -- No winds during beams
		self:CDBar(267878, 8) -- Wind Tunnel
	end
end

do
	local prev = 0
	function mod:UldirDefensiveBeamDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end

-- Mythic
do
	local playerList = mod:NewTargetList()
	function mod:EndemicVirusApplied(args)
		playerList[#playerList+1] = args.destName
		self:PlaySound(args.spellId, "warning", nil, playerList)
		self:TargetsMessage(args.spellId, "yellow", playerList)
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 20)
		end
	end

	function mod:EndemicVirusRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end
