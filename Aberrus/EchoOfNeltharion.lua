--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Echo of Neltharion", 2569, 2523)
if not mod then return end
mod:RegisterEnableMob(201668) -- Neltharion
mod:SetEncounterID(2684)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

-- Stage 1
local echoingFissureCount = 1
local rushingDarknessCount = 1
local volcanicHeartCount = 1
local twistedEarthCount = 1

-- Stage 2
local umbralAnnihilationCount = 1
local sweepingShadowsCount = 1
local corruptionCount = 1

-- Stage 3
local sunderRealityCount = 1
local ebonDestructionCount = 1
local rushingDarknessCount = 1
local shatteredRealityOnMe = false
local castingEbonDestruction = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_repeating_sunder_reality = "Repeating Sunder Reality Warning"
	L.custom_on_repeating_shattered_reality_desc = "Repeat a message during the Ebon Destruction cast until you get inside a portal."
	-- L.repeating_shattered_reality_icon = 407919

	L.twisted_earth = "Walls"
	L.echoing_fissure = "Fissure"
	L.rushing_darkness = "Knock Lines"

	L.umbral_annihilation = "Annihilation"
	L.sunder_reality = "Portals"
	L.ebon_destruction = "Big Bang"
end

--------------------------------------------------------------------------------
-- Initialization
--

local volcanicHeartMarker = mod:AddMarkerOption(true, "player", 1, 410966, 1, 2, 3) -- Volcanic Heart
local rushingDarknessMarker = mod:AddMarkerOption(true, "player", 4, 407182, 4, 5, 6) -- Rushing Darkness
function mod:GetOptions()
	return {
		"stages",
		{410966, "SAY", "SAY_COUNTDOWN"}, -- Volcanic Heart
		volcanicHeartMarker,
		{407221, "SAY", "SAY_COUNTDOWN"}, -- Rushing Darkness
		rushingDarknessMarker,
		{401998, "TANK_HEALER"}, -- Calamitous Strike
		-- Stage 1
		402902, -- Twisted Earth
		402115, -- Echoing Fissure
		-- Stage 2
		403057, -- Surrender to Corruption
		{401010, "SAY"}, -- Corruption
		405433, -- Umbral Annihilation
		{407790, "TANK_HEALER"}, -- Sunder Shadow
		403049, -- Shadow Barrier
		-- Stage 3
		407936, -- Sunder Reality
		407919, -- Shattered Reality
		"custom_on_repeating_sunder_reality",
		407917, -- Ebon Destruction
	}, {
		[402902] = -26192, -- Stage 1
		[403057] = -26421, -- Stage 2
		[407936] = -26422, -- Stage 3
	},{
		[407221] = L.rushing_darkness, -- Rushing Darkness (Knock Lines)
		[402902] = L.twisted_earth, -- Twisted Earth (Walls)
		[402115] = L.echoing_fissure, -- Echoing Fissure (Fissure)
		[402902] = L.umbral_annihilation, -- Umbral Annihilation (Annihilation)
		[402902] = L.sunder_reality, -- Sunder Reality (Portals)
		[402902] = L.ebon_destruction, -- Ebon Destruction (Big Bang)
	}
end

function mod:OnBossEnable()
	-- Stage 1
	self:Log("SPELL_CAST_SUCCESS", "VolcanicHeart", 410968)
	self:Log("SPELL_AURA_APPLIED", "VolcanicHeartApplied", 410966)
	self:Log("SPELL_AURA_REMOVED", "VolcanicHeartRemoved", 410966)
	self:Log("SPELL_CAST_START", "EchoingFissure", 403272)
	self:Log("SPELL_CAST_START", "RushingDarkness", 407207)
	self:Log("SPELL_AURA_APPLIED", "RushingDarknessApplied", 407182)
	self:Log("SPELL_AURA_REMOVED", "RushingDarknessRemoved", 407182)
	self:Log("SPELL_CAST_SUCCESS", "TwistedEarth", 409241)
	self:Log("SPELL_CAST_START", "CalamitousStrike", 406222)
	self:Log("SPELL_AURA_APPLIED", "CalamitousStrikeApplied", 401998)

	-- Intermission
	self:Log("SPELL_CAST_START", "RazeTheEarth", 409313)

	-- Stage 2
	self:Log("SPELL_CAST_START", "SurrenderToCorruption", 403057)
	self:Log("SPELL_AURA_APPLIED", "CorruptionPreDebuff", 405484) -- Surrendering to Corruption
	self:Log("SPELL_CAST_START", "UmbralAnnihilation", 405433)
	self:Log("SPELL_CAST_START", "SunderShadow", 407790)
	self:Log("SPELL_AURA_APPLIED", "SunderedShadowApplied", 407728)
	self:Log("SPELL_AURA_REMOVED_DOSE", "AddKilled", 407088)
	self:Log("SPELL_AURA_APPLIED", "ShadowBarrier", 403049)
	self:Log("SPELL_AURA_REMOVED", "Stage2Over", 407088)

	-- Stage 3
	self:Log("SPELL_CAST_START", "SunderReality", 407936)
	self:Log("SPELL_AURA_APPLIED", "ShatteredRealityApplied", 407919)
	self:Log("SPELL_PERIODIC_DAMAGE", "ShatteredRealityDamage", 407919)
	self:Log("SPELL_PERIODIC_MISSED", "ShatteredRealityDamage", 407919)
	self:Log("SPELL_AURA_REMOVED", "ShatteredRealityRemoved", 407919)
	self:Log("SPELL_CAST_START", "EbonDestruction", 407917)
	self:Log("SPELL_CAST_SUCCESS", "EbonDestructionSuccess", 407917)
end

function mod:OnEngage()
	self:SetStage(1)
	echoingFissureCount = 1
	rushingDarknessCount = 1
	twistedEarthCount = 1
	volcanicHeartCount = 1

	umbralAnnihilationCount = 1
	sweepingShadowsCount = 1

	sunderRealityCount = 1
	ebonDestructionCount = 1
	rushingDarknessCount = 1
	shatteredRealityOnMe = false
	castingEbonDestruction =  false

	self:CDBar(410966, self:Mythic() and 15.5 or 14.5, CL.count:format(CL.bombs, volcanicHeartCount))
	self:CDBar(407221, self:Mythic() and 10.5 or 9.5, CL.count:format(L.rushing_darkness, rushingDarknessCount)) -- Rushing Darkness
	if not self:Easy() then
		self:CDBar(402902, 20, CL.count:format(L.twisted_earth, twistedEarthCount)) -- Twisted Earth
	end
	self:CDBar(401998, self:Mythic() and 24 or 24.5) -- Calamitous Strike
	self:CDBar(402115, 30.5, CL.count:format(L.echoing_fissure, echoingFissureCount)) -- Echoing Fissure

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- General
function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 73 then -- P2 at 70%
		self:Message("stages", "cyan", CL.soon:format(CL.stage:format(2)), false)
		self:PlaySound("stages", "info")
		self:UnregisterUnitEvent(event, unit)
	end
end

-- Stage 1
do
	local playerList = {}
	function mod:VolcanicHeart(args)
		self:StopBar(CL.count:format(CL.bombs, volcanicHeartCount))
		volcanicHeartCount = volcanicHeartCount + 1
		playerList = {}
		if self:GetStage() == 2 and volcanicHeartCount > 8 then return end -- Only 8 waves in P2
		self:CDBar(410966, self:GetStage() == 1 and 34 or 16, CL.count:format(CL.bombs, volcanicHeartCount))
	end

	function mod:VolcanicHeartApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "warning")
			self:Say(args.spellId, CL.rticon:format(CL.bomb, count))
			self:SayCountdown(args.spellId, 7, count)
		end
		self:CustomIcon(volcanicHeartMarker, args.destName, count)
		self:TargetsMessage(args.spellId, "orange", playerList, 3, CL.count:format(CL.bombs, volcanicHeartCount-1))
	end

	function mod:VolcanicHeartRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(410966)
		end
		self:CustomIcon(volcanicHeartMarker, args.destName)
	end
end

function mod:TwistedEarth(args)
	self:StopBar(CL.count:format(L.twisted_earth, twistedEarthCount))
	self:Message(402902, "yellow", CL.count:format(L.twisted_earth, twistedEarthCount))
	self:PlaySound(402902, "alert")
	twistedEarthCount = twistedEarthCount + 1
	-- Was only once in normal
	if not self:Easy() then
		self:CDBar(402902, self:GetStage() == 1 and 17 or 29, CL.count:format(L.twisted_earth, twistedEarthCount))
	end
end

function mod:EchoingFissure(args)
	self:StopBar(CL.count:format(L.echoing_fissure, echoingFissureCount))
	self:Message(402115, "orange", CL.count:format(L.echoing_fissure, echoingFissureCount))
	self:PlaySound(402115, "alarm")
	echoingFissureCount = echoingFissureCount + 1
	self:CDBar(402115, self:GetStage() == 1 and 34 or 30, CL.count:format(L.echoing_fissure, echoingFissureCount))
end

do
	local playerList = {}
	function mod:RushingDarkness(args)
		self:StopBar(CL.count:format(L.rushing_darkness, rushingDarknessCount))
		rushingDarknessCount = rushingDarknessCount + 1
		playerList = {}
		if self:GetStage() == 2 and rushingDarknessCount > 4 then return end -- Only 4 waves in P2
		self:CDBar(407221, self:GetStage() == 1 and 34 or 30.4, CL.count:format(L.rushing_darkness, rushingDarknessCount))
	end

	function mod:RushingDarknessApplied(args)
		local count = #playerList+1
		local icon = count + 3
		playerList[count] = args.destName
		playerList[args.destName] = icon -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(407221, "warning")
			self:Say(407221, CL.rticon:format(L.rushing_darkness, icon))
			self:SayCountdown(407221, 5, icon)
		end
		self:CustomIcon(rushingDarknessMarker, args.destName, icon)
		self:TargetsMessage(407221, "yellow", playerList, 3, CL.count:format(L.rushing_darkness, rushingDarknessCount-1))
	end

	function mod:RushingDarknessRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(407221)
		end
		self:CustomIcon(rushingDarknessMarker, args.destName)
	end
end

function mod:CalamitousStrike(args)
	self:Message(401998, "purple", CL.casting:format(args.spellName))
	self:PlaySound(401998, "info")
	self:CDBar(401998, self:GetStage() == 1 and 34.0 or 30.4)
end

function mod:CalamitousStrikeApplied(args)
	self:TargetMessage(args.spellId, "purple", args.destName)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	if bossUnit and self:Tank() and not self:Me(args.destGUID) and not self:Tanking(bossUnit) then
		self:PlaySound(args.spellId, "warning") -- Taunt
	elseif self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm") -- On you
	end
end

-- Intermission
function mod:RazeTheEarth()
	self:StopBar(401998) -- Calamitous Strike
	self:StopBar(CL.count:format(L.echoing_fissure, echoingFissureCount)) -- Echoing Fissure
	self:StopBar(CL.count:format(L.rushing_darkness, rushingDarknessCount)) -- Rushing Darkness
	self:StopBar(CL.count:format(CL.bombs, volcanicHeartCount)) -- Volcanic Heart
	self:StopBar(CL.count:format(L.twisted_earth, twistedEarthCount)) -- Twisted Earth

	self:Message("stages", "cyan", CL.intermission, false)
	self:PlaySound("stages", "long")

	self:CDBar("stages", 7, CL.stage:format(2), 403057) -- Stage 2, Surrender To Corruption Icon
end

-- Stage 2

function mod:SurrenderToCorruption()
	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long")

	volcanicHeartCount = 1
	umbralAnnihilationCount = 1
	rushingDarknessCount = 1
	corruptionCount = 1

	-- No corruption timer, that happens during this cast
	self:CDBar(407790, 15.2) -- Sunder Shadow
	self:CDBar(410966, 21, CL.count:format(CL.bombs, volcanicHeartCount))
	self:CDBar(405433, 26.2, CL.count:format(L.umbral_annihilation, umbralAnnihilationCount)) -- Umbral Annihilation
	self:CDBar(407221, 31, CL.count:format(L.rushing_darkness, rushingDarknessCount)) -- Rushing Darkness
	if not self:Easy() then
		self:CDBar(402902, 40, CL.count:format(L.twisted_earth, twistedEarthCount))
	end
end

do
	local playerList = {}
	local prev = 0
	function mod:CorruptionPreDebuff(args)
		if args.time - prev > 2 then -- reset
			corruptionCount = corruptionCount + 1
			if corruptionCount < 4 then -- 3 sets
				self:CDBar(401010, 45, CL.count:format(self:SpellName(401010), corruptionCount))
			end
			playerList = {}
			prev = args.time
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(401010, "warning")
			self:Say(401010, self:SpellName(401010))
		end
		self:TargetsMessage(401010, "yellow", playerList, nil, CL.count:format(self:SpellName(401010), corruptionCount-1))
	end
end

function mod:UmbralAnnihilation(args)
	self:StopBar(CL.count:format(L.umbral_annihilation, umbralAnnihilationCount))
	self:Message(args.spellId, "orange", CL.count:format(L.umbral_annihilation, umbralAnnihilationCount))
	self:PlaySound(args.spellId, "alarm")
	umbralAnnihilationCount = umbralAnnihilationCount + 1
	-- 6+ are spam casted
	self:CDBar(args.spellId, umbralAnnihilationCount > 5 and 11 or 30, CL.count:format(L.umbral_annihilation, umbralAnnihilationCount))
end

function mod:SunderShadow(args)
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "info")
	self:CDBar(args.spellId, 30)
end

function mod:SunderedShadowApplied(args)
	self:TargetMessage(407790, "purple", args.destName)
	local bossUnit = self:UnitTokenFromGUID(args.sourceGUID)
	if bossUnit and self:Tank() and not self:Me(args.destGUID) and not self:Tanking(bossUnit) then
		self:PlaySound(407790, "warning") -- Taunt
	elseif self:Me(args.destGUID) then
		self:PlaySound(407790, "alarm") -- On you
	end
end

function mod:AddKilled(args)
	local killed = 3-args.amount
	self:Message("stages", "cyan", CL.add_killed:format(killed, 3), false)
end

function mod:ShadowBarrier(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:Stage2Over(args)
	self:StopBar(407790) -- Sunder Shadow
	self:StopBar(CL.count:format(self:SpellName(401010), corruptionCount)) -- Corruption
	self:StopBar(CL.count:format(L.umbral_annihilation, umbralAnnihilationCount)) -- Umbral Annihilation
	self:StopBar(CL.count:format(L.rushing_darkness, rushingDarknessCount)) -- Rushing Darkness
	self:StopBar(CL.count:format(CL.bombs, volcanicHeartCount)) -- Volcanic Heart
	self:StopBar(CL.count:format(L.twisted_earth, twistedEarthCount)) -- Twisted Earth

	self:SetStage(3)
	self:Message("stages", "cyan", CL.stage:format(3), false)
	self:PlaySound("stages", "info")

	sunderRealityCount = 1
	ebonDestructionCount = 1
	rushingDarknessCount = 1
	shatteredRealityOnMe = false
	castingEbonDestruction =  false

	self:CDBar(407936, 21.4, CL.count:format(L.sunder_reality, sunderRealityCount)) -- Sunder Reality
	self:CDBar(407221, 27.6, CL.count:format(L.rushing_darkness, rushingDarknessCount)) -- Rushing Darkness
	self:CDBar(401998, 35.4) -- Calamitous Strike
	self:CDBar(407917, 41.5, CL.count:format(L.ebon_destruction, ebonDestructionCount)) -- Ebon Destruction
end

-- Stage 3
function mod:SunderReality(args)
	self:StopBar(CL.count:format(L.sunder_reality, sunderRealityCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.sunder_reality, sunderRealityCount))
	self:PlaySound(args.spellId, "alert")
	sunderRealityCount = sunderRealityCount + 1
	self:Bar(args.spellId, 30.4, CL.count:format(L.sunder_reality, sunderRealityCount))
end

do
	local sunderRealityCheck = nil
	local function checkForSunderedReality()
		if mod:GetOption("custom_on_repeating_sunder_reality") then
			if not shatteredRealityOnMe and not UnitIsDead("player") then
				mod:Message(407919, "blue", CL.no:format(mod:SpellName(403908)), 403908)
				mod:PlaySound(407919, "warning")
			end
			sunderRealityCheck = mod:ScheduleTimer(checkForSunderedReality, 2)
		else
			sunderRealityCheck = nil
		end
	end

	local prev = 0
	function mod:ShatteredRealityApplied(args)
		if self:Me(args.destGUID) then
			if castingEbonDestruction then
				self:Message(407919, "green", CL.you:format(args.spellName))
				self:PlaySound(407919, "info")
			else -- Ground Effect
				local t = args.time
				if t-prev > 2 then
					prev = t
					self:PersonalMessage(407919, "underyou")
					self:PlaySound(407919, "underyou")
				end
			end
		end
	end

	function mod:ShatteredRealityDamage(args)
		if self:Me(args.destGUID) and not castingEbonDestruction then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PersonalMessage(407919, "underyou")
				self:PlaySound(407919, "underyou")
			end
		end
	end

	function mod:ShatteredRealityRemoved(args)
		if self:Me(args.destGUID) then
			shatteredRealityOnMe = false
		end
	end

	function mod:EbonDestruction(args)
		self:StopBar(CL.count:format(L.ebon_destruction, ebonDestructionCount))
		self:Message(args.spellId, "red", CL.count:format(L.ebon_destruction, ebonDestructionCount))
		self:PlaySound(args.spellId, "warning")
		ebonDestructionCount = ebonDestructionCount + 1
		self:CDBar(args.spellId, 30.4, CL.count:format(L.ebon_destruction, ebonDestructionCount))
		castingEbonDestruction = true
		sunderRealityCheck = mod:ScheduleTimer(checkForSunderedReality, 2)
	end

	function mod:EbonDestructionSuccess()
		castingEbonDestruction = false
		if sunderRealityCheck then
			self:CancelTimer(sunderRealityCheck)
			sunderRealityCheck = nil
		end
	end
end
