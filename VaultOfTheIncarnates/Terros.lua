--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Terros", 2522, 2500)
if not mod then return end
mod:RegisterEnableMob(190496) -- Terros
mod:SetEncounterID(2639)
mod:SetRespawnTime(30)
mod:SetStage(1)

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
	L.resonating_annihilation = "Annihilation"
	L.awakened_earth = "Pillar"
	L.shattering_impact = "Slam"
	L.concussive_slam = "Tank Line"
	L.infused_fallout = "Dust"

	L.custom_on_repeating_fallout = "Repeating Infused Fallout"
	L.custom_on_repeating_fallout_icon = 391592
	L.custom_on_repeating_fallout_desc = "Repeating Infused Fallout say messages with icon {rt7} to find a partner."
end

--------------------------------------------------------------------------------
-- Initialization
--

local awakenedEarthMarker = mod:AddMarkerOption(false, "player", 1, 381315, 1, 2, 3, 4, 5, 6, 7, 8) -- Awakened Earth
function mod:GetOptions()
	return {
		{380487, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Rock Blast
		{381315, "SAY", "SAY_COUNTDOWN"}, -- Awakened Earth
		awakenedEarthMarker,
		{377166, "CASTBAR", "CASTBAR_COUNTDOWN"}, -- Resonating Annihilation
		382458, -- Resonant Aftermath
		383073, -- Shattering Impact
		376279, -- Concussive Slam
		377505, -- Frenzied Devastation
		388393, -- Tectonic Barrage
		-- Mythic
		391592, -- Infused Fallout
		"custom_on_repeating_fallout",
	},{
		[391592] = CL.mythic,
	},{
		[380487] = CL.soak, -- Rock Blast (Soak)
		[377166] = L.resonating_annihilation, -- Resonating Annihilation (Annihilation)
		[381315] = L.awakened_earth, -- Awakened Earth (Pillar)
		[383073] = L.shattering_impact, -- Shattering Impact (Slam)
		[376279] = L.concussive_slam, -- Concussive Slam (Tank Line)
		[391592] = L.infused_fallout, -- Reactive Dust (Dust)
		["custom_on_repeating_fallout"] = L.infused_fallout, -- Repeating Infused Fallout (Dust)
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
	self:Log("SPELL_AURA_REMOVED", "InfusedFalloutRemoved", 391592)
end

function mod:OnEngage()
	rockBlastCount = 1
	shatteringImpactCount = 1
	concussiveSlamCount = 1
	resonatingAnnihilationCount = 1
	frenziedfDevastationCount = 1
	infusedFalloutCount = 1

	self:Bar(380487, self:Mythic() and 3 or 6, CL.count:format(CL.soak, rockBlastCount)) -- Rock Blast
	self:Bar(376279, self:Mythic() and 11 or 16, CL.count:format(L.concussive_slam, concussiveSlamCount)) -- Concussive Slam
	self:Bar(383073, self:Mythic() and 23 or 27, CL.count:format(L.shattering_impact, shatteringImpactCount)) -- Shattering Impact
	self:Bar(377166, self:Mythic() and 88 or 90, CL.count:format(L.resonating_annihilation, resonatingAnnihilationCount)) -- Resonating Annihilation
	if self:Mythic() then
		self:Bar(391592, 28.7, CL.count:format(L.infused_fallout, infusedFalloutCount)) -- Infused Fallout
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local count = 1
	function mod:RockBlast(args)
		self:StopBar(CL.count:format(CL.soak, rockBlastCount))
		rockBlastCount = rockBlastCount + 1
		if shatteringImpactCount < 9 then -- Soft Enrage after 8
			local cd
			if self:Mythic() then
				cd = rockBlastCount % 2 == 0 and 43.0 or 53.5
			else
				cd = rockBlastCount % 2 == 0 and 42.0 or 54.5
			end
			self:Bar(380487, cd, CL.count:format(CL.soak, rockBlastCount))
		end
		count = 1
	end

	function mod:RockBlastApplied(args)
		self:TargetMessage(380487, "orange", args.destName, CL.count:format(CL.soak, rockBlastCount-1))
		self:TargetBar(380487, 5.5, args.destName, CL.count:format(CL.soak, rockBlastCount-1))
		if self:Me(args.destGUID) then
			self:Yell(380487, CL.soak, nil, "Soak")
			self:YellCountdown(380487, 5.5)
			self:PlaySound(380487, "warning", nil, args.destName)
		else
			self:PlaySound(380487, "alert", nil, args.destName)
		end
	end

	function mod:AwakenedEarthApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(381315, nil , L.awakened_earth)
			self:PlaySound(381315, "warning")
			self:Say(381315, CL.count_rticon:format(L.awakened_earth, count, count), nil, ("Pillar (%d{rt%d})"):format(count, count))
			self:SayCountdown(381315, 6)
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
	self:CastBar(args.spellId, L.resonating_annihilation)
	resonatingAnnihilationCount = resonatingAnnihilationCount + 1
	if resonatingAnnihilationCount < 5 then -- Only 4
		self:Bar(args.spellId, 96.5, CL.count:format(L.resonating_annihilation, resonatingAnnihilationCount))
	end
	self:PlaySound(args.spellId, "long")
end

function mod:ShatteringImpact(args)
	self:StopBar(CL.count:format(L.shattering_impact, shatteringImpactCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.shattering_impact, shatteringImpactCount))
	self:PlaySound(args.spellId, "alarm")
	shatteringImpactCount = shatteringImpactCount + 1
	if shatteringImpactCount < 9 then -- Soft Enrage after 8
		self:Bar(args.spellId, shatteringImpactCount % 2 == 0 and 42.0 or 54.5, CL.count:format(L.shattering_impact, shatteringImpactCount))
	end
end

function mod:ConcussiveSlam(args)
	self:StopBar(CL.count:format(L.concussive_slam, concussiveSlamCount))
	self:Message(args.spellId, "purple", CL.count:format(L.concussive_slam, concussiveSlamCount))
	self:PlaySound(args.spellId, "alert")
	concussiveSlamCount = concussiveSlamCount + 1
	if concussiveSlamCount < 17 then -- Soft Enrage after 16
		local cd
		if self:Mythic() then
			cd = concussiveSlamCount % 2 == 0 and 23 or concussiveSlamCount % 4 == 1 and 31.5 or 19.0
		else
			cd = concussiveSlamCount % 4 == 1 and 36.5 or concussiveSlamCount % 4 == 3 and 24 or 18
		end
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
do
	local isOnMe = false
	local sayTimer = nil
	function mod:InfusedFallout(args)
		self:StopBar(CL.count:format(L.infused_fallout, infusedFalloutCount))
		self:Message(391592, "yellow", CL.count:format(L.infused_fallout, infusedFalloutCount))
		self:PlaySound(391592, "alert")
		infusedFalloutCount = infusedFalloutCount + 1
		if infusedFalloutCount < 12 then -- Soft Enrage after 11
			local cd = infusedFalloutCount % 3 == 1 and 29 or infusedFalloutCount % 3 == 2 and 42 or 25
			self:Bar(391592, cd, CL.count:format(L.infused_fallout, infusedFalloutCount))
		end
	end

	local function warnOnMe(self)
		if isOnMe then
			-- wasn't instantly cleared, show warnings for applied/removed
			self:PersonalMessage(391592, nil, L.infused_fallout)
			self:PlaySound(391592, "warning") -- debuffmove
			if self:GetOption("custom_on_repeating_fallout") then
				sayTimer = self:ScheduleRepeatingTimer("Say", 1.5, false, "{rt7}", true)
			end
		end
	end

	function mod:InfusedFalloutApplied(args)
		if self:Me(args.destGUID) then
			isOnMe = true
			self:ScheduleTimer(warnOnMe, 1, self)
		end
	end

	function mod:InfusedFalloutRemoved(args)
		if self:Me(args.destGUID) then
			if isOnMe then
				self:Message(391592, "green", CL.removed:format(L.infused_fallout))
				self:PlaySound(391592, "info")
				isOnMe = false
			end
			if sayTimer then
				self:CancelTimer(sayTimer)
				sayTimer = nil
			end
		end
	end
end
