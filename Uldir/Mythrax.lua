
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Mythrax the Unraveler", 1861, 2194)
if not mod then return end
mod:RegisterEnableMob(134546)
mod.engageId = 2135
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local nextStageWarning = 69
local annihilationList = {}
local visionCount = 1
local beamCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.destroyer_cast = "%s (N'raqi Destroyer)" -- npc id: 139381
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		{272146, "INFOBOX"}, -- Annihilation
		{273282, "TANK"}, -- Essence Shear
		273538, -- Obliteration Blast
		272404, -- Oblivion Sphere
		{272536, "SAY", "SAY_COUNTDOWN"}, -- Imminent Ruin
		273810, -- Xalzaix's Awakening
		274230, -- Oblivion's Veil
		272115, -- Obliteration Beam
		273949, -- Visions of Madness
		279013, -- Essence Shatter
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_AURA_APPLIED", "Annihilation", 272146)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Annihilation", 272146)
	self:Log("SPELL_AURA_REMOVED", "Annihilation", 272146)
	self:Log("SPELL_AURA_REMOVED_DOSE", "Annihilation", 272146)

	self:Log("SPELL_CAST_START", "EssenceShear", 273282)
	self:Log("SPELL_AURA_APPLIED", "EssenceShearApplied", 274693)
	self:Log("SPELL_CAST_START", "ObliterationBlast", 273538)
	self:Log("SPELL_CAST_SUCCESS", "OblivionSphere", 272404)
	self:Log("SPELL_CAST_SUCCESS", "ImminentRuin", 272533)
	self:Log("SPELL_AURA_APPLIED", "ImminentRuinApplied", 272536)
	self:Log("SPELL_AURA_REMOVED", "ImminentRuinRemoved", 272536)
	self:Log("SPELL_CAST_START", "XalzaixsAwakening", 273810)
	self:Log("SPELL_AURA_REMOVED", "OblivionsVeilRemoved", 274230)
	self:Log("SPELL_CAST_START", "ObliterationBeam", 272115)
	self:Log("SPELL_CAST_SUCCESS", "VisionsofMadness", 273949)
	self:Log("SPELL_CAST_START", "EssenceShatter", 279013)
end

function mod:OnEngage()
	stage = 1
	nextStageWarning = 69
	wipe(annihilationList)

	self:OpenInfo(272146) -- Annihilation

	self:Bar(272536, 5) -- Imminent Ruin
	self:Bar(272404, 9) -- Oblivion Sphere
	self:Bar(273538, 15) -- Obliteration Blast
	self:Bar(273282, 20.5) -- Essence Shear

	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH_FREQUENT(event, unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < nextStageWarning then -- Intermission at 66% & 33%
		self:Message("stages", "green", nil, CL.stage:format(2), false)
		nextStageWarning = nextStageWarning - 33
		if nextStageWarning < 33 then
			self:UnregisterUnitEvent(event, unit)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 279749 then -- Intermission Start
		stage = 2
		self:PlaySound("stages", "long")
		self:Message("stages", "cyan", nil, CL.stage:format(stage), false)

		self:StopBar(272536) -- Imminent Ruin
		self:StopBar(273282) -- Essence Shear
		self:StopBar(273538) -- Obliteration Blast
		self:StopBar(272404) -- Oblivion Sphere

		visionCount = 1
		beamCount = 1

		self:CDBar("stages", 84, CL.intermission)

		self:CDBar(272115, 23) -- Obliteration Beam
		self:CDBar(273949, 34) -- Visions of Madness
	elseif spellId == 279748 then -- Intermission End
		stage = 1
		self:PlaySound("stages", "long")
		self:Message("stages", "cyan", nil, CL.stage:format(stage), false)

		self:Bar(272536, 5) -- Imminent Ruin
		self:Bar(272404, 9) -- Oblivion Sphere
		self:Bar(273538, 15) -- Obliteration Blast
		self:Bar(273282, 20.5) -- Essence Shear
	end
end

function mod:Annihilation(args)
	local amount = args.amount or 1
	annihilationList[args.destName] = amount
	self:SetInfoByTable(args.spellId, annihilationList)
end

do
	local prev = 0
	function mod:EssenceShear(args)
		self:Message(args.spellId, "purple")
		self:PlaySound(args.spellId, "alert")
		if self:MobId(args.sourceGUID) == 134546 then -- Mythrax the Unraveler
			self:Bar(args.spellId, 20.5)
		else -- Intermission Adds
			local t = GetTime()
			if t-prev > 2 then
				prev = t
				self:CDBar(args.spellId, 20.5, L.destroyer_cast:format(args.spellName))
			end
		end
	end
end

function mod:EssenceShearApplied(args)
	if self:Tank(args.destName) then
		self:TargetMessage2(273282, "red", args.destName)
		self:PlaySound(273282, "alarm")
	end
end

function mod:ObliterationBlast(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	self:Bar(args.spellId, 15)
end

function mod:OblivionSphere(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:Bar(args.spellId, 15)
end

function mod:ImminentRuin()
	self:Bar(272536, 15)
end

do
	local playerList = mod:NewTargetList()
	function mod:ImminentRuinApplied(args)
		playerList[#playerList+1] = args.destName
		self:PlaySound(args.spellId, "alert")
		self:TargetsMessage(args.spellId, "yellow", playerList, 2)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 12)
		end
	end
end

function mod:ImminentRuinRemoved(args)
	if self:Me(args.destGUID) then
		self:CancelSayCountdown(args.spellId)
	end
end

function mod:XalzaixsAwakening(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 8) -- 2s cast, 6s channel
end

function mod:OblivionsVeilRemoved(args)
	self:Message(args.spellId, "green", nil, CL.removed:format(args.spellName))
	self:PlaySound(args.spellId, "info")
end

function mod:ObliterationBeam(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	self:CastBar(args.spellId, 7.5) -- 2.5s cast, 5s channel

	beamCount = beamCount + 1
	if beamCount <= 5 then
		self:CDBar(args.spellId, 12)
	end
end

function mod:VisionsofMadness(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	visionCount = visionCount + 1
	if visionCount <= 2 then
		self:Bar(args.spellId, 20)
	end
end

function mod:EssenceShatter(args)
	self:Message(args.spellId, "red", nil, CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "long")
end
