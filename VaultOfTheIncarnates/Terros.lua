if not IsTestBuild() then return end
-- XXX Debuffs are missing for rock blast
-- XXX use _success for bar starts incase of recasts? can that happen?
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

local SKIP_CAST_THRESHOLD = 2
local checkTimer = nil


--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.skipped_cast = "Skipped %s (%d)"

	L.resonating_annihilation = "Annihilation"
	L.shattering_impact = "Slam + Rubble"
	L.concussive_slam = "Tank Line"
	L.reactive_dust = "Dust"
end

--------------------------------------------------------------------------------
-- Initialization
--

local awakenedEarthMarker = mod:AddMarkerOption(true, "player", 1, 381315, 1, 2, 3, 4, 5, 6, 7, 8) -- Awakened Earth
local reactiveDustMarker = mod:AddMarkerOption(true, "player", 1, 391306, 8, 7, 6, 5, 4, 3, 2, 1) -- Reactive Dust
function mod:GetOptions()
	return {
		{380487, "ICON", "SAY", "SAY_COUNTDOWN"}, -- Rock Blast
		{381315, "SAY", "SAY_COUNTDOWN"}, -- Awakened Earth
		awakenedEarthMarker,
		377166, -- Resonating Annihilation
		382458, -- Resonant Aftermath
		383073, -- Shattering Impact
		376279, -- Concussive Slam
		377505, -- Frenzied Devastation
		388393, -- Tectonic Barrage
		-- Mythic
		{391306, "SAY"}, -- Reactive Dust
		reactiveDustMarker,
	},{
		[391306] = CL.mythic,
	},{
		[377166] = L.resonating_annihilation, -- Resonating Annihilation (Annihilation)
		[376279] = L.shattering_impact, -- Shattering Impact (Slam + Rubble)
		[376279] = L.concussive_slam, -- Concussive Slam (Tank Line)
		[391306] = L.reactive_dust, -- Reactive Dust (Dust)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "RockBlast", 380487)
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
	self:Log("SPELL_AURA_APPLIED", "ReactiveDustApplied", 391306)
	self:Log("SPELL_AURA_REMOVED", "ReactiveDustRemoved", 391306)
end

function mod:OnEngage()
	rockBlastCount = 1
	shatteringImpactCount = 1
	concussiveSlamCount = 1
	resonatingAnnihilationCount = 1
	frenziedfDevastationCount = 1

	self:Bar(380487, 6, CL.count:format(self:SpellName(380487), rockBlastCount)) -- Rock Blast
	self:Bar(376279, 14, CL.count:format(L.concussive_slam, concussiveSlamCount)) -- Concussive Slam
	checkTimer = self:ScheduleTimer("ConcussiveSlamCheck", 14 + SKIP_CAST_THRESHOLD, concussiveSlamCount)
	self:Bar(383073, 27, CL.count:format(L.shattering_impact, shatteringImpactCount)) -- Shattering Impact
	self:Bar(377166, 90, CL.count:format(L.resonating_annihilation, resonatingAnnihilationCount)) -- Resonating Annihilation
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	-- XXX until they unhide Rock Blast -> Awakened Earth
	local function printTarget(self, destName, destGUID)
		if self:Tanking("boss1", destName) then
			-- didn't switch? just do a generic warning if on the tank
			self:Message(380487, "orange", CL.count:format(self:SpellName(380487), rockBlastCount-1))
			self:Bar(380487, 5.5, CL.other:format(CL.count:format(self:SpellName(380487), rockBlastCount-1), "???"))
			self:PlaySound(380487, "alert")
		else
			self:TargetMessage(380487, "orange", destName, CL.count:format(self:SpellName(380487), rockBlastCount-1))
			self:TargetBar(380487, 5.5, destName, CL.count:format(self:SpellName(380487), rockBlastCount-1))
			if self:Me(destGUID) then
				self:PlaySound(380487, "warning")
				self:Say(380487)
				self:SayCountdown(380487, 5.5)
			else
				self:PlaySound(380487, "alert")
			end
			self:SecondaryIcon(380487, destName)
			self:ScheduleTimer("SecondaryIcon", 5, 380487)
		end
	end

	local count = 1
	function mod:RockBlast(args)
		self:StopBar(CL.count:format(args.spellName, rockBlastCount))
		self:GetBossTarget(printTarget, 0.3, args.sourceGUID)
		rockBlastCount = rockBlastCount + 1
		if shatteringImpactCount < 9 then -- Soft Enrage after
			self:Bar(args.spellId, rockBlastCount % 2 == 0 and 42.0 or 54.5, CL.count:format(args.spellName, rockBlastCount))
		end
		count = 1
	end

	function mod:AwakenedEarthApplied(args)
		if self:Me(args.destGUID) then
			self:PlaySound(381315, "warning")
			self:Say(381315)
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

do
	function mod:ConcussiveSlamCheck(castCount)
		if castCount == concussiveSlamCount then -- not on the next cast?
			self:StopBar(CL.count:format(L.concussive_slam, concussiveSlamCount))
			mod:Message(376279, "purple", L.skipped_cast:format(L.concussive_slam, castCount))
			concussiveSlamCount = castCount + 1
			if concussiveSlamCount < 17 then -- Soft Enrage after
				local cd = concussiveSlamCount % 4 == 1 and 34.5 or concussiveSlamCount % 4 == 3 and 22 or 20
				mod:Bar(376279, cd - SKIP_CAST_THRESHOLD, CL.count:format(L.concussive_slam, concussiveSlamCount))
				checkTimer = mod:ScheduleTimer("ConcussiveSlamCheck", cd, concussiveSlamCount)
			end
		end
	end

	function mod:ConcussiveSlam(args)
		self:CancelTimer(checkTimer)
		self:StopBar(CL.count:format(L.concussive_slam, concussiveSlamCount))
		self:Message(args.spellId, "purple", CL.count:format(L.concussive_slam, concussiveSlamCount))
		self:PlaySound(args.spellId, "alert")
		concussiveSlamCount = concussiveSlamCount + 1
		-- XXX can skip, casts on next cd
		if concussiveSlamCount < 17 then -- Soft Enrage after
			local cd = concussiveSlamCount % 4 == 1 and 34.5 or concussiveSlamCount % 4 == 3 and 22 or 20
			self:Bar(args.spellId, cd, CL.count:format(L.concussive_slam, concussiveSlamCount))
			checkTimer = self:ScheduleTimer("ConcussiveSlamCheck", cd + SKIP_CAST_THRESHOLD, concussiveSlamCount)
		end
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
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "underyou")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end

-- Mythic
do
	local playerList = {}
	local prev = 0
	function mod:ReactiveDustApplied(args)
		local t = args.time -- new set of debuffs
		if t-prev > 5 then
			prev = t
			playerList = {}
		end
		playerList[#playerList+1] = args.destName
		local mark = 9 - #playerList
		playerList[args.destName] = mark -- Set raid marker
		if self:Me(args.destGUID) then
			self:Say(args.spellId, CL.rticon:format(L.reactive_dust, mark))
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "orange", playerList, nil, L.reactive_dust)
		self:CustomIcon(reactiveDustMarker, args.destName, mark)
	end

	function mod:ReactiveDustRemoved(args)
		self:CustomIcon(reactiveDustMarker, args.destName)
	end
end
