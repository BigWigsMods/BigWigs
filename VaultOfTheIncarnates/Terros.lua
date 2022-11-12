
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Terros", 2522, 2500)
if not mod then return end
mod:RegisterEnableMob(190496) -- Terros
mod:SetEncounterID(2639)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local rockBlastCount = 1
local shatteringImpactCount = 1
local concussiveSlamCount = 1
local resonatingAnnihilationCount = 1
local frenziedfDevastationCount = 1
local infusedFalloutCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.rock_blast = "Soak"
	L.resonating_annihilation = "Annihilation"
	L.awakened_earth = "Pillar"
	L.shattering_impact = "Slam"
	L.concussive_slam = "Tank Line"
	L.infused_fallout = "Dust"
end

--------------------------------------------------------------------------------
-- Initialization
--

local awakenedEarthMarker = mod:AddMarkerOption(false, "player", 1, 381315, 1, 2, 3, 4, 5, 6, 7, 8) -- Awakened Earth
function mod:GetOptions()
	return {
		{380487, "SAY", "SAY_COUNTDOWN"}, -- Rock Blast
		{381315, "SAY", "SAY_COUNTDOWN"}, -- Awakened Earth
		awakenedEarthMarker,
		377166, -- Resonating Annihilation
		382458, -- Resonant Aftermath
		383073, -- Shattering Impact
		376279, -- Concussive Slam
		377505, -- Frenzied Devastation
		388393, -- Tectonic Barrage
		-- Mythic
		391592, -- Infused Fallout
	},{
		[391306] = CL.mythic,
	},{
		[380487] = L.rock_blast, -- Rock Blast (Soak)
		[377166] = L.resonating_annihilation, -- Resonating Annihilation (Annihilation)
		[381315] = L.awakened_earth, -- Awakened Earth (Pillar)
		[376279] = L.shattering_impact, -- Shattering Impact (Slam)
		[376279] = L.concussive_slam, -- Concussive Slam (Tank Line)
		[391592] = L.infused_fallout, -- Reactive Dust (Dust)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "RockBlast", 380487)
	self:Log("SPELL_AURA_APPLIED", "RockBlastApplied", 386352)
	self:Log("SPELL_AURA_APPLIED", "AwakenedEarthApplied", 381253)
	self:Log("SPELL_AURA_REMOVED", "AwakenedEarthRemoved", 381253)
	self:Log("SPELL_CAST_START", "ResonatingAnnihilation", 377166)
	self:Log("SPELL_CAST_START", "ShatteringImpact", 383073)
	self:Log("SPELL_CAST_START", "ConcussiveSlam", 376279)
	self:Log("SPELL_AURA_APPLIED", "ConcussiveSlamApplied", 376276)
	self:Log("SPELL_AURA_APPLIED_DOSE", "ConcussiveSlamApplied", 376276)
	self:Log("SPELL_CAST_START", "FrenziedDevastation", 377505)

	self:Log("SPELL_AURA_APPLIED", "TectonicBarrage", 388393)
	self:Log("SPELL_DAMAGE", "TectonicBarrage", 388393)
	self:Log("SPELL_MISSED", "TectonicBarrage", 388393)

	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 382458) -- Resonant Aftermath
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 382458)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 382458)

	-- Mythic
	self:Log("SPELL_CAST_START", "InfusedFallout", 396351)
	self:Log("SPELL_AURA_APPLIED", "InfusedFalloutApplied", 391592)
end

function mod:OnEngage()
	rockBlastCount = 1
	shatteringImpactCount = 1
	concussiveSlamCount = 1
	resonatingAnnihilationCount = 1
	frenziedfDevastationCount = 1
	infusedFalloutCount = 1

	self:Bar(380487, 6, CL.count:format(L.rock_blast, rockBlastCount)) -- Rock Blast
	self:Bar(376279, 14, CL.count:format(L.concussive_slam, concussiveSlamCount)) -- Concussive Slam
	self:Bar(383073, 27, CL.count:format(L.shattering_impact, shatteringImpactCount)) -- Shattering Impact
	self:Bar(377166, 90, CL.count:format(L.resonating_annihilation, resonatingAnnihilationCount)) -- Resonating Annihilation
	if self:Mythic() then
		self:Bar(391592, 28, CL.count:format(L.infused_fallout, infusedFalloutCount)) -- Infused Fallout
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local count = 1
	function mod:RockBlast(args)
		self:StopBar(CL.count:format(L.rock_blast, rockBlastCount))
		rockBlastCount = rockBlastCount + 1
		if shatteringImpactCount < 9 then -- Soft Enrage after
			self:Bar(args.spellId, rockBlastCount % 2 == 0 and 42.0 or 54.5, CL.count:format(L.rock_blast, rockBlastCount))
		end
		count = 1
	end

	function mod:RockBlastApplied(args)
		self:TargetMessage(380487, "orange", args.destName, CL.count:format(L.rock_blast, rockBlastCount-1))
		self:TargetBar(380487, 5.5, args.destName, CL.count:format(L.rock_blast, rockBlastCount-1))
		if self:Me(args.destGUID) then
			self:PersonalMessage(380487, nil, L.rock_blast)
			self:PlaySound(380487, "warning")
			self:Yell(380487, L.rock_blast)
			self:YellCountdown(380487, 5.5)
		else
			self:PlaySound(380487, "alert")
		end
	end

	function mod:AwakenedEarthApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(381315, nil , L.awakened_earth)
			self:PlaySound(381315, "warning")
			self:Say(381315, CL.count_rticon:format(L.awakened_earth, count, count))
			self:SayCountdown(381315, 6, count)
		end
		self:CustomIcon(awakenedEarthMarker, args.destName, count)
		count = count + 1
	end

	function mod:AwakenedEarthRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(381315)
		end
		self:CustomIcon(awakenedEarthMarker, args.destName)
	end
end

function mod:ResonatingAnnihilation(args)
	self:StopBar(CL.count:format(L.resonating_annihilation, resonatingAnnihilationCount))
	self:Message(args.spellId, "red", CL.count:format(L.resonating_annihilation, resonatingAnnihilationCount))
	self:PlaySound(args.spellId, "long")
	-- self:CastBar(args.spellId, 6.5)
	resonatingAnnihilationCount = resonatingAnnihilationCount + 1
	if resonatingAnnihilationCount < 5 then -- Only 4
		self:Bar(args.spellId, 96.5, CL.count:format(L.resonating_annihilation, resonatingAnnihilationCount))
	end
end

function mod:ShatteringImpact(args)
	self:StopBar(CL.count:format(L.shattering_impact, shatteringImpactCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.shattering_impact, shatteringImpactCount))
	self:PlaySound(args.spellId, "alarm")
	shatteringImpactCount = shatteringImpactCount + 1
	if shatteringImpactCount < 9 then -- Soft Enrage after
		self:Bar(args.spellId, shatteringImpactCount % 2 == 0 and 42.0 or 54.5, CL.count:format(L.shattering_impact, shatteringImpactCount))
	end
end

function mod:ConcussiveSlam(args)
	self:StopBar(CL.count:format(L.concussive_slam, concussiveSlamCount))
	self:Message(args.spellId, "purple", CL.count:format(L.concussive_slam, concussiveSlamCount))
	self:PlaySound(args.spellId, "alert")
	concussiveSlamCount = concussiveSlamCount + 1
	if concussiveSlamCount < 17 then -- Soft Enrage after
		local cd = concussiveSlamCount % 4 == 1 and 34.5 or concussiveSlamCount % 4 == 3 and 22 or 20
		self:Bar(args.spellId, cd, CL.count:format(L.concussive_slam, concussiveSlamCount))
	end
end

function mod:ConcussiveSlamApplied(args)
	if self:Tank() and self:Tank(args.destName) then
		self:StackMessage(376279, "purple", args.destName, args.amount, 0)
		self:PlaySound(376279, "warning")
	elseif self:Me(args.destGUID) then -- Not a tank
		self:StackMessage(376279, "blue", args.destName, args.amount, 0)
		self:PlaySound(376279, "warning")
	end
end

function mod:FrenziedDevastation(args)
	if frenziedfDevastationCount % 3 == 1 then -- 1, 4, 7...
		self:Message(args.spellId, "red", CL.count:format(args.spellName, frenziedfDevastationCount))
		self:PlaySound(args.spellId, "alarm")
	end
	frenziedfDevastationCount = frenziedfDevastationCount + 1
end

do
	local prev = 0
	function mod:TectonicBarrage(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message(args.spellId, "yellow")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 and resonatingAnnihilationCount < 5 then -- Don't spam after room is filled
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end

-- Mythic
function mod:InfusedFallout(args)
	self:StopBar(CL.count:format(L.infused_fallout, infusedFalloutCount))
	self:Message(391592, "yellow", CL.count:format(L.infused_fallout, infusedFalloutCount))
	self:PlaySound(391592, "alert")
	infusedFalloutCount = infusedFalloutCount + 1
	if infusedFalloutCount < 12 then -- Soft Enrage after
		local cd = infusedFalloutCount % 3 == 1 and 29 or infusedFalloutCount % 3 == 2 and 42 or 25
		self:Bar(391592, cd, CL.count:format(L.infused_fallout, infusedFalloutCount))
	end
end

function mod:InfusedFalloutApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId, nil, L.infused_fallout)
		self:PlaySound(args.spellId, "warning")
	end
end
