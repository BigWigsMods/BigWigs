if not C_ChatInfo then return end -- XXX Don't load outside of 8.0

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

local annihilationList = {}

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{272146, "INFOBOX"}, -- Annihilation
		{273282, "TANK"}, -- Essence Shear
		273538, -- Obliteration Wave
		272404, -- Oblivion Sphere
		{272536, "SAY"}, -- Imminent Ruin
		273810, -- Xalzaix's Awakening
		274230, -- Oblivion's Veil
		272115, -- Obliteration Beam
		273949, -- Visions of Madness
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "Annihilation", 272146)
	self:Log("SPELL_AURA_APPLIED_DOSE", "Annihilation", 272146)
	self:Log("SPELL_AURA_REMOVED", "Annihilation", 272146)
	self:Log("SPELL_AURA_REMOVED_DOSE", "Annihilation", 272146)

	self:Log("SPELL_CAST_START", "EssenceShear", 273282)
	self:Log("SPELL_AURA_APPLIED", "EssenceShearApplied", 274693)
	self:Log("SPELL_CAST_SUCCESS", "ObliterationBlast", 273538)
	self:Log("SPELL_CAST_SUCCESS", "OblivionSphere", 272404)
	self:Log("SPELL_CAST_SUCCESS", "ImminentRuin", 272533)
	self:Log("SPELL_AURA_APPLIED", "ImminentRuinApplied", 272536)
	self:Log("SPELL_AURA_REMOVED", "ImminentRuinRemoved", 272536)
	self:Log("SPELL_CAST_START", "XalzaixsAwakening", 273810)
	self:Log("SPELL_AURA_REMOVED", "OblivionsVeilRemoved", 274230)
	self:Log("SPELL_CAST_START", "ObliterationBeam", 272115)
	self:Log("SPELL_CAST_SUCCESS", "VisionsofMadness", 273949)
end

function mod:OnEngage()
	wipe(annihilationList)

	self:OpenInfo(272146) -- Annihilation

	self:Bar(273538, 9.5) -- Obliteration Blast
	self:Bar(272404, 9) -- Oblivion Sphere
	self:Bar(273282, 20) -- Essence Shear

end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Annihilation(args)
	local amount = args.amount or 1
	annihilationList[args.destName] = amount
	self:SetInfoByTable(args.spellId, annihilationList)
end

function mod:EssenceShear(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	if self:MobId(args.sourceGUID) == 134546 then -- Mythrax the Unraveler
		self:Bar(args.spellId, 20)
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

do
	local prev = 0
	function mod:OblivionSphere(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "red")
			self:PlaySound(args.spellId, "warning")
			self:Bar(args.spellId, 15)
		end
	end
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

	self:StopBar(272536) -- Imminent Ruin
	self:StopBar(273282) -- Essence Shear
	self:StopBar(273538) -- Obliteration Wave
	self:StopBar(272404) -- Oblivion Sphere

	self:Bar(273949, 11.5) -- Visions of Madness
	self:Bar(272115, 21) -- Obliteration Beam

end

function mod:OblivionsVeilRemoved(args)
	self:Message(args.spellId, "green", nil, CL.removed:format(args.spellName))
	self:PlaySound(args.spellId, "long")

	self:Bar(273282, 3) -- Essence Shear
	-- XXX Need Data
	--self:Bar(273538, 9.5) -- Obliteration Wave
	--self:Bar(272404, 20) -- Oblivion Sphere
	--self:Bar(272536, 20) -- Imminent Ruin
end

function mod:ObliterationBeam(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 11)
end

function mod:VisionsofMadness(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	self:Bar(args.spellId, 20)
end
