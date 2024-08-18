--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kazzara, the Hellforged", 2569, 2522)
if not mod then return end
mod:RegisterEnableMob(201261) -- Kazzara
mod:SetEncounterID(2688)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local nextHellsteelCarnageHealth = 84
local hellsteelCarnageCount = 1
local dreadRiftsCount = 1
local raysOfAnguishCount = 1
local hellbeamCount = 1
local wingsOfExtinctionCount = 1
local terrorClawsCount = 1

--------------------------------------------------------------------------------
-- Initialization
--

local dreadRiftMarker = mod:AddMarkerOption(false, "player", 1, 407196, 1, 2, 3, 4, 5, 6) -- Dread Rifts
function mod:GetOptions()
	return {
		401319, -- Hellsteel Carnage
		{407196, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Dread Rifts
		dreadRiftMarker,
		406530, -- Riftburn
		{407069, "SAY", "ME_ONLY_EMPHASIZE"}, -- Rays of Anguish
		402421, -- Molten Scar
		400430, -- Hellbeam
		403326, -- Wings of Extinction
		{404743, "TANK"}, -- Terror Claws
	},nil,{
		[407196] = CL.rift, -- Dread Rifts (Rift)
		[407069] = CL.lasers, -- Rays of Anguish (Lasers)
		[400430] = CL.breath, -- Hellbeam (Breath)
		[403326] = CL.pushback, -- Wings of Extinction (Pushback)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "HellsteelCarnage", 401316, 401318, 401319)
	self:Log("SPELL_CAST_START", "DreadRifts", 406516, 407198, 407199, 407200)
	self:Log("SPELL_AURA_APPLIED", "DreadRiftApplied", 406525)
	self:Log("SPELL_AURA_REMOVED", "DreadRiftRemoved", 406525)
	self:Log("SPELL_CAST_START", "RaysOfAnguish", 407069)
	self:Log("SPELL_AURA_APPLIED", "RaysOfAnguishApplied", 402253)
	self:Log("SPELL_CAST_START", "Hellbeam", 400430)
	self:Log("SPELL_CAST_START", "WingsOfExtinction", 403326)
	self:Log("SPELL_CAST_START", "TerrorClaws", 404744)
	self:Log("SPELL_AURA_APPLIED", "TerrorClawsApplied", 404743)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TerrorClawsApplied", 404743)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 402421, 406530) -- Molten Scar, Riftburn
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 402421, 406530)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 402421, 406530)
end

function mod:OnEngage()
	self:SetStage(1)
	nextHellsteelCarnageHealth = 84
	hellsteelCarnageCount = 1
	dreadRiftsCount = 1
	raysOfAnguishCount = 1
	hellbeamCount = 1
	wingsOfExtinctionCount = 1
	terrorClawsCount = 1

	self:Bar(404743, 3) -- Terror Claws
	self:Bar(407196, self:Easy() and 7 or 8, CL.count:format(self:SpellName(407196), dreadRiftsCount)) -- Dread Rifts
	self:Bar(403326, 14.5, CL.count:format(CL.pushback, wingsOfExtinctionCount)) -- Wings of Extinction
	self:Bar(407069, 24, CL.count:format(CL.lasers, raysOfAnguishCount)) -- Rays of Anguish
	self:Bar(400430, 30, CL.count:format(CL.breath, hellbeamCount)) -- Hellbeam

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < nextHellsteelCarnageHealth then --  At 80%, 60%, and 40%
		nextHellsteelCarnageHealth = nextHellsteelCarnageHealth - 20
		if nextHellsteelCarnageHealth < 30 then
			self:UnregisterUnitEvent(event, unit)
		end
		self:Message(401319, "cyan", CL.soon:format(self:SpellName(401319)), false) -- Hellsteel Carnage soon
		self:PlaySound(401319, "info")
	end
end

function mod:HellsteelCarnage(args)
	self:Message(401319, "yellow", CL.casting:format(args.spellName, hellsteelCarnageCount))
	self:PlaySound(401319, "long")
	hellsteelCarnageCount = hellsteelCarnageCount + 1

	local extendTime = self:Easy() and 8.6 or 9.6
	self:Bar(404743, self:BarTimeLeft(404743) + extendTime) -- Terror Claws
	self:Bar(407196, self:BarTimeLeft(CL.count:format(self:SpellName(407196), dreadRiftsCount)) + extendTime, CL.count:format(self:SpellName(407196), dreadRiftsCount)) -- Dread Rifts
	self:Bar(403326, self:BarTimeLeft(CL.count:format(CL.pushback, wingsOfExtinctionCount)) + extendTime, CL.count:format(CL.pushback, wingsOfExtinctionCount)) -- Wings of Extinction
	self:Bar(407069, self:BarTimeLeft(CL.count:format(CL.lasers, raysOfAnguishCount)) + extendTime, CL.count:format(CL.lasers, raysOfAnguishCount)) -- Rays of Anguish
	self:Bar(400430, self:BarTimeLeft(CL.count:format(CL.breath, hellbeamCount)) + extendTime, CL.count:format(CL.breath, hellbeamCount)) -- Hellbeam
end

do
	local count = 1
	function mod:DreadRifts(args)
		count = 1
		local msg = CL.count:format(args.spellName, dreadRiftsCount)
		self:StopBar(msg)
		self:Message(407196, "yellow", msg)
		self:PlaySound(407196, "alarm") -- spread
		dreadRiftsCount = dreadRiftsCount + 1
		self:Bar(407196, 35, CL.count:format(args.spellName, dreadRiftsCount))
	end

	function mod:DreadRiftApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(407196, nil, CL.rift)
			self:PlaySound(407196, "warning")
			self:Say(407196, CL.count_rticon:format(CL.rift, count, count), nil, ("Rift (%d{rt%d})"):format(count, count))
			self:SayCountdown(407196, 5, count)
		end
		self:CustomIcon(dreadRiftMarker, args.destName, count)
		count = count + 1
	end

	function mod:DreadRiftRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(407196)
		end
		self:CustomIcon(dreadRiftMarker, args.destName)
	end
end

function mod:RaysOfAnguish(args)
	local msg = CL.count:format(CL.lasers, raysOfAnguishCount)
	self:StopBar(msg)
	self:Message(args.spellId, "orange", msg)
	self:PlaySound(args.spellId, "alarm") -- spread
	raysOfAnguishCount = raysOfAnguishCount + 1
	self:Bar(args.spellId, 34.1, CL.count:format(CL.lasers, raysOfAnguishCount))
end

function mod:RaysOfAnguishApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(407069, nil, CL.laser)
		self:PlaySound(407069, "warning")
		self:Say(407069, CL.laser, nil, "Laser")
	end
end

function mod:Hellbeam(args)
	local msg = CL.count:format(CL.breath, hellbeamCount)
	self:StopBar(msg)
	self:Message(args.spellId, "red", msg)
	self:PlaySound(args.spellId, "alarm") -- frontal
	hellbeamCount = hellbeamCount + 1
	self:Bar(args.spellId, 36.5, CL.count:format(CL.breath, hellbeamCount))
end

function mod:WingsOfExtinction(args)
	local msg = CL.count:format(CL.pushback, wingsOfExtinctionCount)
	self:StopBar(msg)
	self:Message(args.spellId, "orange", msg)
	self:PlaySound(args.spellId, "alert")
	wingsOfExtinctionCount = wingsOfExtinctionCount + 1
	self:Bar(args.spellId, 35, CL.count:format(CL.pushback, wingsOfExtinctionCount))
end

function mod:TerrorClaws(args)
	self:Message(404743, "purple", CL.casting:format(args.spellName))
	self:PlaySound(404743, "info")
	terrorClawsCount = terrorClawsCount + 1
	self:Bar(404743, terrorClawsCount % 2 == 0 and 16 or 20) -- 15.8, 20.7 alternating
end

function mod:TerrorClawsApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	if bossUnit and self:Tank() and not self:Me(args.destGUID) and not self:Tanking(bossUnit) then
		self:PlaySound(args.spellId, "warning") -- tauntswap
	elseif self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) and args.time-prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou")
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end
