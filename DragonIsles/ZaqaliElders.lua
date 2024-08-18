--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Zaqali Elders", -2133, 2531)
if not mod then return end
mod:RegisterEnableMob(199853, 199855) -- Gholna, Vakan
mod.otherMenu = -1978
mod.worldBoss = {199853, 199855}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		403772, -- Umbral Smash
		403779, -- Burning Shadows
		404171, -- Enveloping Darkness
		402793, -- Burning Strike
		402824, -- Searing Touch
		402985, -- Lava Geyser
		403384, -- Molten Pool
		{402983, "CASTBAR"}, -- Incineration
	},{
		[403772] = -26374, -- Vakan
		[402793] = -26383, -- Gholna
	},{
		[403772] = CL.frontal_cone, -- Umbral Smash (Frontal Cone)
		[402793] = CL.frontal_cone, -- Burning Strike (Frontal Cone)
		[403384] = CL.underyou:format(403384), -- Molten Pool (Molten Pool under YOU)
		[402983] = CL.full_energy, -- Incineration (Full Energy)
	}
end

function mod:OnBossEnable()
	self:ScheduleTimer("CheckForEngage", 1)
	self:RegisterEvent("BOSS_KILL")

	self:Log("SPELL_CAST_START", "UmbralSmashBurningStrike", 403772, 402793)
	self:Log("SPELL_AURA_APPLIED", "BurningShadowsSearingTouchApplied", 403779, 402824)
	self:Log("SPELL_AURA_APPLIED_DOSE", "BurningShadowsSearingTouchApplied", 403779, 402824)
	self:Log("SPELL_CAST_START", "EnvelopingDarknessLavaGeyser", 404171, 402985)
	self:Log("SPELL_AURA_APPLIED", "MoltenPoolDamage", 403384)
	self:Log("SPELL_PERIODIC_DAMAGE", "MoltenPoolDamage", 403384)
	self:Log("SPELL_PERIODIC_MISSED", "MoltenPoolDamage", 403384)
	self:Log("SPELL_CAST_START", "Incineration", 402983)
	self:Log("SPELL_AURA_APPLIED", "IncinerationApplied", 402983)
end

function mod:OnEngage()
	self:CheckForWipe()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BOSS_KILL(event, id)
	if id == 2696 then
		self:UnregisterEvent(event) -- Twice, once per boss
		self:Win()
	end
end

function mod:UmbralSmashBurningStrike(args)
	local unit = self:GetUnitIdByGUID(args.sourceGUID)
	if (unit and self:UnitWithinRange(unit, 45)) or args.sourceGUID == self:UnitGUID("target") then
		self:Message(args.spellId, "purple", CL.frontal_cone)
		self:CDBar(args.spellId, 26.7, CL.frontal_cone)
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:BurningShadowsSearingTouchApplied(args)
	if self:Me(args.destGUID) then
		self:StackMessage(args.spellId, "blue", args.destName, args.amount, 2)
		if args.amount then -- 2+
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:EnvelopingDarknessLavaGeyser(args)
	local unit = self:GetUnitIdByGUID(args.sourceGUID)
	if (unit and self:UnitWithinRange(unit, 45)) or args.sourceGUID == self:UnitGUID("target") then
		self:Message(args.spellId, "red")
		--self:CDBar(args.spellId, 26.7)
		self:PlaySound(args.spellId, "warning")
	end
end

do
	local prev = 0
	function mod:MoltenPoolDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou")
		end
	end
end

function mod:Incineration(args)
	local unit = self:GetUnitIdByGUID(args.sourceGUID)
	if (unit and self:UnitWithinRange(unit, 45)) or args.sourceGUID == self:UnitGUID("target") then
		self:Message(args.spellId, "orange", CL.full_energy)
		self:PlaySound(args.spellId, "long")
	end
end

function mod:IncinerationApplied(args)
	local unit = self:GetUnitIdByGUID(args.sourceGUID)
	if (unit and self:UnitWithinRange(unit, 45)) or args.sourceGUID == self:UnitGUID("target") then
		self:CastBar(args.spellId, 20)
	end
end
