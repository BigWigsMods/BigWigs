if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kazzara", 2569, 2522)
if not mod then return end
mod:RegisterEnableMob(201261) -- Kazzara
mod:SetEncounterID(2688)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local hellsteelCarnageCount = 1
local dreadRiftsCount = 1
local raysOfAnguishCount = 1
local hellbeamCount = 1
local wingsOfExtinctionCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
end

--------------------------------------------------------------------------------
-- Initialization
--

local dreadRiftMarker = mod:AddMarkerOption(false, "player", 1, 407196, 1, 2, 3, 4) -- Dread Rifts
function mod:GetOptions()
	return {
		401319, -- Hellsteel Carnage
		{407196, "SAY", "SAY_COUNTDOWN"}, -- Dread Rifts
		dreadRiftMarker,
		406530, -- Riftburn
		{407069, "SAY"}, -- Rays of Anguish
		402421, -- Molten Scar
		400430, -- Hellbeam
		403326, -- Wings of Extinction
		404743, -- Terror Claws
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "HellsteelCarnage", 401319)
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
	hellsteelCarnageCount = 1
	dreadRiftsCount = 1
	raysOfAnguishCount = 1
	hellbeamCount = 1
	wingsOfExtinctionCount = 1

	--self:Bar(404743, 30) -- Terror Claws
	--self:Bar(407196, 30, CL.count:format(self:SpellName(407196), dreadRiftsCount)) -- Dread Rifts
	--self:Bar(407069, 30, CL.count:format(self:SpellName(407069), raysOfAnguishCount)) -- Rays of Anguish
	--self:Bar(400430, 30, CL.count:format(self:SpellName(400430), hellbeamCount)) -- Hellbeam
	--self:Bar(403326, 30, CL.count:format(self:SpellName(403326), wingsOfExtinctionCount)) -- Wings of Extinction
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:HellsteelCarnage(args)
	self:Message(args.spellId, "yellow", CL.casting:format(args.spellName, hellsteelCarnageCount))
	self:PlaySound(args.spellId, "long")
	hellsteelCarnageCount = hellsteelCarnageCount + 1
end

do
	local count = 1
	function mod:DreadRifts(args)
		self:StopBar(CL.count:format(args.spellName, dreadRiftsCount))
		self:Message(407196, "yellow", CL.count:format(args.spellName, dreadRiftsCount))
		self:PlaySound(407196, "alert")
		dreadRiftsCount = dreadRiftsCount + 1
		--self:Bar(407196, 30, CL.count:format(args.spellName, dreadRiftsCount))
		count = 1
	end


	function mod:DreadRiftApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(407196)
			self:PlaySound(407196, "warning")
			self:Say(407196, CL.count_rticon:format(args.spellName, count, count))
			self:SayCountdown(407196, 4, count)
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
	self:StopBar(CL.count:format(args.spellName, raysOfAnguishCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, raysOfAnguishCount))
	self:PlaySound(args.spellId, "alert")
	raysOfAnguishCount = raysOfAnguishCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, raysOfAnguishCount))
end

function mod:RaysOfAnguishApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(407069)
		self:PlaySound(407069, "warning")
		self:Say(407069)
	end
end

function mod:Hellbeam(args)
	self:StopBar(CL.count:format(args.spellName, hellbeamCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, hellbeamCount))
	self:PlaySound(args.spellId, "alert")
	hellbeamCount = hellbeamCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, hellbeamCount))
end

function mod:WingsOfExtinction(args)
	self:StopBar(CL.count:format(args.spellName, wingsOfExtinctionCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, wingsOfExtinctionCount))
	self:PlaySound(args.spellId, "alert")
	wingsOfExtinctionCount = wingsOfExtinctionCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, wingsOfExtinctionCount))
end

function mod:TerrorClaws(args)
	self:Message(404743, "purple", CL.casting:format(args.spellName))
	self:PlaySound(404743, "alert")
	--self:CDBar(404743, 30)
end

function mod:TerrorClawsApplied(args)
	self:StackMessage(args.spellId, "purple", args.destName, args.amount, 1)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	if bossUnit and self:Tank() and not self:Me(args.destGUID) and not self:Tanking(bossUnit) then
		self:PlaySound(args.spellId, "warning")
	elseif self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm")
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
