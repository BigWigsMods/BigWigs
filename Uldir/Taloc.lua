if not C_ChatInfo then return end -- XXX Don't load outside of 8.0

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Taloc", 1861, 2168)
if not mod then return end
mod:RegisterEnableMob(137119)
mod.engageId = 2144
mod.respawnTime = 16

--------------------------------------------------------------------------------
-- Locals
--

local plasmaCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		{271224, "SAY"}, -- Plasma Discharge
		270290, -- Blood Storm
		271296, -- Cudgel of Gore
		271728, -- Retrieve Cudgel
		271895, -- Sanguine Static
		271965, -- Powered Down
		275270, -- Fixate
		275432, -- Uldir Defensive Beam
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "PlasmaDischarge", 271224)
	self:Log("SPELL_AURA_APPLIED", "PlasmaDischargeApplied", 271224)
	self:Log("SPELL_AURA_REMOVED", "PlasmaDischargeRemoved", 271224)
	self:Log("SPELL_CAST_START", "CudgelofGore", 271296)
	self:Log("SPELL_CAST_START", "RetrieveCudgel", 271728)
	self:Log("SPELL_CAST_SUCCESS", "SanguineStatic", 271895)
	self:Log("SPELL_AURA_APPLIED", "PoweredDown", 271965)
	self:Log("SPELL_AURA_REMOVED", "PoweredDownRemoved", 271965)
	self:Log("SPELL_AURA_APPLIED", "Fixate", 275270)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 270290, 275432) -- Blood Storm, Uldir Defensive Beam
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 270290, 275432)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 270290, 275432)
end

function mod:OnEngage()
	plasmaCount = 1
	self:Bar(271224, 6) -- Plasma Discharge
	self:Bar(271895, 20.5) -- Sanguine Static
	self:Bar(271296, 31.5) -- Cudgel of Gore
	self:Bar(271728, 53.5) -- Retrieve Cudgel

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH_FREQUENT(unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < 63 then -- Intermission at 60%
		self:Message("stages", "green", nil, CL.soon:format(CL.intermission), false)
		self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
	end
end

function mod:PlasmaDischarge(args)
	plasmaCount = plasmaCount + 1
	self:Bar(args.spellId, plasmaCount == 2 and 42.5 or 30.5)
end

do
	local playerList = mod:NewTargetList()
	function mod:PlasmaDischargeApplied(args)
		playerList[#playerList+1] = args.destName
		self:PlaySound(args.spellId, "warning", nil, playerList)
		self:TargetsMessage(args.spellId, "yellow", playerList)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			--self:SayCountdown(args.spellId, 6) XXX Countdown until you start dropping pools instead
		end
	end

	function mod:PlasmaDischargeRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:CudgelofGore(args)
	self:PlaySound(args.spellId, "warning")
	self:Message(args.spellId, "red")
	self:CastBar(args.spellId, 4.5)
	self:CDBar(args.spellId, 59)
end

function mod:RetrieveCudgel(args)
	self:PlaySound(args.spellId, "alarm")
	self:Message(args.spellId, "orange")
	self:CDBar(args.spellId, 59)
end

function mod:SanguineStatic(args)
	self:PlaySound(args.spellId, "alert")
	self:Message(args.spellId, "yellow")
	self:CDBar(args.spellId, 61)
end

function mod:PoweredDown(args)
	self:PlaySound(args.spellId, "long")
	self:Message(args.spellId, "green")
	self:StopBar(271224) -- Plasma Discharge
	self:StopBar(271895) -- Sanguine Static
	self:StopBar(271296) -- Cudgel of Gore
	self:StopBar(271728) -- Retrieve Cudgel

	self:CDBar(args.spellId, 88.8, CL.intermission)
end

function mod:PoweredDownRemoved(args)
	self:PlaySound(args.spellId, "long")
	self:Message(args.spellId, "green", nil, CL.over:format(CL.intermission))

	self:Bar(271224, 6) -- Plasma Discharge
	self:Bar(271895, 20.5) -- Sanguine Static
	self:Bar(271296, 31.5) -- Cudgel of Gore
	self:Bar(271728, 53.5) -- Retrieve Cudgel
end

function mod:Fixate(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:TargetMessage2(args.spellId, "blue", args.destName)
	end
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
