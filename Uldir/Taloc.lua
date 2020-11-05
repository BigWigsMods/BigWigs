
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Taloc", 1861, 2168)
if not mod then return end
mod:RegisterEnableMob(137119)
mod.engageId = 2144
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local plasmaCount = 1
local defensiveBeamCount = 1
local timersUldirDefensiveBeam = {28, 15, 15, 15}
local cudgelCount = 1
local arteriesCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		{271224, "SAY", "SAY_COUNTDOWN"}, -- Plasma Discharge
		270290, -- Blood Storm
		271296, -- Cudgel of Gore
		271728, -- Retrieve Cudgel
		{271895, "SAY"}, -- Sanguine Static
		275270, -- Fixate
		275432, -- Uldir Defensive Beam
		{275189, "SAY_COUNTDOWN", "FLASH"}, -- Hardened Arteries
		{275205, "SAY", "SAY_COUNTDOWN", "FLASH"}, -- Enlarged Heart
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "PlasmaDischarge", 271224, 278888) -- Stage 1, Stage 2
	self:Log("SPELL_AURA_APPLIED", "PlasmaDischargeApplied", 271224, 278888)
	self:Log("SPELL_AURA_REMOVED", "PlasmaDischargeRemoved", 271224, 278888)
	self:Log("SPELL_CAST_START", "CudgelofGore", 271296)
	self:Log("SPELL_CAST_START", "RetrieveCudgel", 271728)
	self:Log("SPELL_CAST_START", "SanguineStaticStart", 271895)
	self:Log("SPELL_CAST_SUCCESS", "SanguineStatic", 271895)
	self:Log("SPELL_AURA_APPLIED", "PoweredDown", 271965)
	self:Log("SPELL_AURA_REMOVED", "PoweredDownRemoved", 271965)
	self:Log("SPELL_AURA_APPLIED", "Fixate", 275270)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "HardenedArteriesApplied", 275189)
	self:Log("SPELL_AURA_REMOVED", "HardenedArteriesRemoved", 275189)

	self:Log("SPELL_CAST_SUCCESS", "EnlargedHeart", 275205)
	self:Log("SPELL_AURA_APPLIED", "EnlargedHeartApplied", 275205)
	self:Log("SPELL_AURA_REMOVED", "EnlargedHeartRemoved", 275205)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 270290, 275432) -- Blood Storm, Uldir Defensive Beam
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 270290, 275432)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 270290, 275432)
end

function mod:OnEngage()
	stage = 1
	plasmaCount = 1
	cudgelCount = 1
	arteriesCount = 1

	self:Bar(271224, 6) -- Plasma Discharge
	self:Bar(271895, 22.5) -- Sanguine Static
	self:Bar(271296, self:Mythic() and 35.1 or 31.5, CL.count:format(self:SpellName(271296), cudgelCount)) -- Cudgel of Gore
	self:Bar(271728, 52) -- Retrieve Cudgel
	if self:Mythic() then
		self:Bar(275189, 25, CL.count:format(self:SpellName(275189), arteriesCount)) -- Hardened Arteries
		self:Bar(275205, 25) -- Enlarged Heart
	end
	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < 38 then -- Intermission at 35%
		self:Message2("stages", "green", CL.soon:format(CL.intermission), false)
		self:UnregisterUnitEvent(event, unit)
	end
end

do
	local prev = 0
	function mod:PlasmaDischarge(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			plasmaCount = plasmaCount + 1
			self:Bar(271224, plasmaCount == 2 and 42.5 or 30.5)
		end
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:PlasmaDischargeApplied(args)
		playerList[#playerList+1] = args.destName
		self:PlaySound(271224, "warning", nil, playerList)
		self:TargetsMessage(271224, "yellow", playerList)
		if self:Me(args.destGUID) then
			self:Say(271224)
			self:SayCountdown(271224, 3.5)
		end
	end

	function mod:PlasmaDischargeRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(271224)
		end
	end
end

function mod:CudgelofGore(args)
	self:PlaySound(args.spellId, "warning")
	self:Message2(args.spellId, "red", CL.count:format(args.spellName, cudgelCount))
	self:StopBar(CL.count:format(args.spellName, cudgelCount))
	self:CastBar(args.spellId, 4.5, CL.count:format(args.spellName, cudgelCount))
	cudgelCount = cudgelCount + 1
	if self:Mythic() then
		-- Mythic (both stages) the 2nd cast seems to be 65.5s after 1st
		self:CDBar(args.spellId, cudgelCount == 2 and 65.5 or 59, CL.count:format(args.spellName, cudgelCount))
	else
		self:CDBar(args.spellId, 57, CL.count:format(args.spellName, cudgelCount)) -- Between 57 and 59
	end
end

function mod:RetrieveCudgel(args)
	self:PlaySound(args.spellId, "alarm")
	self:Message2(args.spellId, "orange")
	self:CDBar(args.spellId, 59)
end

do
	local function printTarget(self, name, guid)
		self:PlaySound(271895, "alert", nil, name)
		self:TargetMessage(271895, "yellow", name)
		if self:Me(guid) then
			self:Say(271895)
		end
	end

	function mod:SanguineStaticStart(args)
		self:GetBossTarget(printTarget, 0.5, args.sourceGUID)
	end
end

function mod:SanguineStatic(args)
	self:CDBar(args.spellId, 61)
end

function mod:PoweredDown(args)
	self:PlaySound("stages", "long")
	self:Message2("stages", "green", CL.intermission, false)
	self:StopBar(271224) -- Plasma Discharge
	self:StopBar(271895) -- Sanguine Static
	self:StopBar(CL.count:format(self:SpellName(271296), cudgelCount)) -- Cudgel of Gore
	self:StopBar(271728) -- Retrieve Cudgel
	self:StopBar(275205) -- Enlarged Heart
	self:StopBar(CL.count:format(self:SpellName(275189), arteriesCount)) -- Hardened Arteries

	self:CDBar("stages", 87.5, CL.intermission, 271965) -- Powered Down

	if not self:Easy() then
		defensiveBeamCount = 1
		self:StartDefensiveBeamTimer(timersUldirDefensiveBeam[defensiveBeamCount])
	end
end

function mod:StartDefensiveBeamTimer(timer)
	self:Bar(275432, timer, CL.count:format(self:SpellName(275432), defensiveBeamCount))
	self:ScheduleTimer("Message", timer, 275432, "red", nil, CL.incoming:format(self:SpellName(275432), defensiveBeamCount))
	self:ScheduleTimer("PlaySound", timer, 275432, "long")
	defensiveBeamCount = defensiveBeamCount + 1
	if timersUldirDefensiveBeam[defensiveBeamCount] then
		self:ScheduleTimer("StartDefensiveBeamTimer", timer, timersUldirDefensiveBeam[defensiveBeamCount])
	end
end

function mod:PoweredDownRemoved(args)
	stage = 2
	self:PlaySound("stages", "long")
	self:Message2("stages", "green", CL.stage:format(stage), false)

	arteriesCount = 1
	cudgelCount = 1

	self:Bar(271224, 12.8) -- Plasma Discharge
	self:Bar(271895, 27.5) -- Sanguine Static
	self:Bar(271296, 37, CL.count:format(self:SpellName(271296), cudgelCount)) -- Cudgel of Gore
	self:Bar(271728, 57.5) -- Retrieve Cudgel
	if self:Mythic() then
		self:Bar(275189, 31, CL.count:format(self:SpellName(275189), arteriesCount)) -- Hardened Arteries
		self:Bar(275205, 31) -- Enlarged Heart
	end
end

function mod:Fixate(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:PersonalMessage(args.spellId)
	end
end

do
	local prev = 0
	function mod:HardenedArteriesApplied(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message2(args.spellId, "yellow", CL.count:format(args.spellName, arteriesCount))
			self:PlaySound(args.spellId, "alert")
			arteriesCount = arteriesCount + 1
			self:CDBar(args.spellId, 60.5, CL.count:format(args.spellName, arteriesCount))
		end
		if self:Me(args.destGUID) then
			self:Flash(args.spellId)
			self:SayCountdown(args.spellId, 6)
		end
	end

	function mod:HardenedArteriesRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:EnlargedHeart(args)
	self:CDBar(args.spellId, 60.5)
end

function mod:EnlargedHeartApplied(args)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "warning")
		self:Flash(args.spellId)
		self:SayCountdown(args.spellId, 6)
	end
	self:TargetMessage(args.spellId, "orange", args.destName)
	self:TargetBar(args.spellId, 6, args.destName)
end

function mod:EnlargedHeartRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
	self:StopBar(args.spellId, args.destName)
end

do
	local prev = 0
	function mod:GroundDamage(args)
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
