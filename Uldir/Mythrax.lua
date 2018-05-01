--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Mythrax the Unraveler", 1861, 2194)
if not mod then return end
mod:RegisterEnableMob(134546, 134591, 134593, 136383) -- XXX All are Mythrax the Unraveler, check which is needed
mod.engageId = 2135
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{273282, "TANK"}, -- Essence Shear
		273554, -- Obliteration Wave
		272407, -- Oblivion Sphere
		{272536, "SAY"}, -- Imminent Ruin
		273810, -- Xalzaix's Awakening
		272115, -- Obliteration Beam
		273951, -- Visions of Madness
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "EssenceShear", 273282)
	self:Log("SPELL_AURA_APPLIED", "EssenceShearApplied", 274693)
	self:Log("SPELL_CAST_SUCCESS", "ObliterationWave", 273554)
	self:Log("SPELL_CAST_SUCCESS", "OblivionSphere", 272407)
	self:Log("SPELL_AURA_APPLIED", "ImminentRuinApplied", 272536)
	self:Log("SPELL_AURA_REMOVED", "ImminentRuinRemoved", 272536)
	self:Log("SPELL_CAST_START", "XalzaixsAwakening", 273810)
	self:Log("SPELL_CAST_START", "ObliterationBeam", 272115)
	self:Log("SPELL_CAST_SUCCESS", "VisionsofMadness", 273951)
end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:EssenceShear(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
end

function mod:EssenceShearApplied(args)
	self:TargetMessage2(273282, "purle", args.destName)
	self:PlaySound(273282, "alarm", nil, args.destName)
end

function mod:ObliterationWave(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
end

function mod:OblivionSphere(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end

do
	local playerList = mod:NewTargetList()
	function mod:ImminentRuinApplied(args)
		playerList[#playerList+1] = args.destName
		self:PlaySound(args.spellId, "alert")
		self:TargetsMessage(args.spellId, "yellow", playerList, 2)
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 5)
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

function mod:ObliterationBeam(args)
	self:Message(args.spellId, "orange")
	self:PlaySound(args.spellId, "alert")
end

function mod:VisionsofMadness(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
end
