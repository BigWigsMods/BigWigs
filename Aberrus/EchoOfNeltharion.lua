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
local twistedEarthCount = 1
local echoingFissureCount = 1
local rushingDarknessCount = 1
local volcanicHeartCount = 1

-- Stage 2
local umbralAnnihilationCount = 1
local corruptionCount = 1
local addDeaths = 0

-- Stage 3
local sunderRealityCount = 1
local ebonDestructionCount = 1
local castingEbonDestruction = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.twisted_earth = "Walls"
	L.echoing_fissure = "Fissure"
	L.rushing_darkness = "Knock Lines"

	L.umbral_annihilation = "Annihilation"
	L.ebon_destruction = "Big Bang"

	L.wall_breaker = "Wall Breaker (Mythic)"
	L.wall_breaker_desc = "A player targeted by Rushing Darkness will be chosen as the wall breaker. They will be marked ({rt6}) and send a message in say chat. This is restricted to Mythic difficulty on stage 1."
	L.wall_breaker_icon = 6
	L.wall_breaker_message = "Wall Breaker"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		{410953, "PRIVATE"}, -- Volcanic Heart
		{407221, "PRIVATE"}, -- Rushing Darkness
		{"wall_breaker", "SAY", "SAY_COUNTDOWN", "ICON", "ME_ONLY", "ME_ONLY_EMPHASIZE"},
		{401998, "TANK_HEALER"}, -- Calamitous Strike
		-- Stage 1
		402902, -- Twisted Earth
		402115, -- Echoing Fissure
		-- Stage 2
		{401010, "SAY", "ME_ONLY_EMPHASIZE"}, -- Corruption
		407036, -- Hidden in Void
		405433, -- Umbral Annihilation
		{407790, "TANK_HEALER"}, -- Sunder Shadow
		403049, -- Shadow Barrier
		-- Stage 3
		407936, -- Sunder Reality
		407919, -- Sundered Reality
		{407917, "CASTBAR", "CASTBAR_COUNTDOWN"}, -- Ebon Destruction
	},{
		[402902] = -26192, -- Stage 1
		[401010] = -26421, -- Stage 2
		[407936] = -26422, -- Stage 3
	},{
		[407221] = L.rushing_darkness, -- Rushing Darkness (Knock Lines)
		[402902] = L.twisted_earth, -- Twisted Earth (Walls)
		[402115] = L.echoing_fissure, -- Echoing Fissure (Fissure)
		[405433] = L.umbral_annihilation, -- Umbral Annihilation (Annihilation)
		[407936] = CL.portals, -- Sunder Reality (Portals)
		[407917] = L.ebon_destruction, -- Ebon Destruction (Big Bang)
	}
end

function mod:OnBossEnable()
	-- Stage 1
	self:Log("SPELL_CAST_SUCCESS", "VolcanicHeart", 410968)
	self:Log("SPELL_CAST_START", "EchoingFissure", 403272)
	self:Log("SPELL_CAST_START", "RushingDarkness", 407207)
	self:Log("SPELL_CAST_SUCCESS", "RushingDarknessEnd", 407207)
	self:Log("SPELL_CAST_SUCCESS", "TwistedEarth", 409241)
	self:Log("SPELL_CAST_START", "CalamitousStrike", 401022)
	self:Log("SPELL_AURA_APPLIED", "CalamitousStrikeApplied", 401998)

	-- Intermission
	self:Log("SPELL_CAST_START", "RazeTheEarth", 409313)

	-- Stage 2
	self:Log("SPELL_CAST_START", "SurrenderToCorruption", 403057)
	self:Log("SPELL_AURA_APPLIED", "CorruptionPreDebuff", 405484) -- Surrendering to Corruption
	self:Log("SPELL_AURA_REMOVED", "HiddenInVoidRemoved", 407036)
	self:Log("SPELL_CAST_START", "UmbralAnnihilation", 405433)
	self:Log("SPELL_CAST_START", "SunderShadow", 407790)
	self:Log("SPELL_AURA_APPLIED", "SunderedShadowApplied", 407728)
	self:Death("AddKilled", 203812) -- Voice From Beyond
	self:Log("SPELL_AURA_APPLIED", "ShadowBarrier", 403049)

	-- Stage 3
	self:Log("SPELL_CAST_START", "SunderReality", 407936)
	self:Log("SPELL_AURA_APPLIED", "SunderedRealityApplied", 407919)
	self:Log("SPELL_PERIODIC_DAMAGE", "SunderedRealityDamage", 407919)
	self:Log("SPELL_PERIODIC_MISSED", "SunderedRealityDamage", 407919)
	self:Log("SPELL_CAST_START", "EbonDestruction", 407917)
	self:Log("SPELL_CAST_SUCCESS", "EbonDestructionSuccess", 407917)
end

function mod:OnEngage()
	self:SetStage(1)
	twistedEarthCount = 1
	echoingFissureCount = 1
	rushingDarknessCount = 1
	volcanicHeartCount = 1

	self:CDBar(407221, 11, CL.count:format(L.rushing_darkness, rushingDarknessCount)) -- Rushing Darkness
	self:CDBar(410953, 15.8, CL.count:format(CL.bombs, volcanicHeartCount)) -- Volcanic Heart
	self:CDBar(401998, 24.5) -- Calamitous Strike
	self:CDBar(402115, 33.5, CL.count:format(L.echoing_fissure, echoingFissureCount)) -- Echoing Fissure
	if not self:Easy() then
		self:Bar(402902, self:Mythic() and 23 or 42.5, CL.count:format(L.twisted_earth, twistedEarthCount)) -- Twisted Earth
	end

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
	self:SetPrivateAuraSound(410953, 410966) -- Volcanic Heart
	self:SetPrivateAuraSound(407221, 407182) -- Rushing Darkness
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- General
function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 63 then -- P2 at 60%
		self:UnregisterUnitEvent(event, unit)
		self:Message("stages", "cyan", CL.soon:format(CL.stage:format(2)), false)
		self:PlaySound("stages", "info")
	end
end

-- Stage 1
do
	local timer = {21.4, 15.6, 17.0, 17.0, 17.4, 16.6, 19.5, 14.5, 0} -- Stage 2
	local timerLFR = {27.9, 16.1, 17.0} -- 27.9, 16.1, 17.0, 17.0, 12.0, 17.0, 12.0 ..

	local SKIP_CAST_THRESHOLD = 1 -- pretty much no variance, but leave some buffer
	local function checkCast(castCount)
		if castCount == volcanicHeartCount then -- not on the next cast?
			local msg = CL.count:format(CL.bombs, volcanicHeartCount)
			mod:StopBar(msg)
			mod:Message(410953, "orange", msg)
			volcanicHeartCount = volcanicHeartCount + 1
			local cd = timer[volcanicHeartCount]
			mod:CDBar(410953, cd - SKIP_CAST_THRESHOLD, CL.count:format(CL.bombs, volcanicHeartCount))
		end
	end

	function mod:VolcanicHeart()
		local msg = CL.count:format(CL.bombs, volcanicHeartCount)
		self:StopBar(msg)
		self:Message(410953, "orange", msg)
		volcanicHeartCount = volcanicHeartCount + 1

		local cd = 0
		if self:GetStage() == 1 then
			cd = 36.5
		elseif self:GetStage() == 2 then
			if self:LFR() then
				cd = timerLFR[volcanicHeartCount] or volcanicHeartCount % 2 == 0 and 17 or 12
			else
				cd = timer[volcanicHeartCount]
			end
		end
		self:CDBar(410953, cd, CL.count:format(CL.bombs, volcanicHeartCount))

		if volcanicHeartCount == 6 and self:GetStage() == 2 and not self:LFR() then
			-- XXX the 6th cast doesn't have a log entry and blizzard removed the unit events
			self:ScheduleTimer(checkCast, cd + SKIP_CAST_THRESHOLD, volcanicHeartCount)
		end
	end
end

do
	local timer = {41.6, 18.2, 12.2, 29.2, 13.4, 14.6}
	function mod:TwistedEarth()
		local msg = CL.count:format(L.twisted_earth, twistedEarthCount)
		self:StopBar(msg)
		-- kind of noisy and irrelevant to play a sound/show a message in mythic/heroic
		-- self:Message(402902, "yellow", msg)
		-- self:PlaySound(402902, "alert")
		twistedEarthCount = twistedEarthCount + 1
		local cd = self:GetStage() == 1 and 36.6 or 57.1
		if self:Mythic() then
			cd = self:GetStage() == 1 and 18.5 or timer[twistedEarthCount]
		end
		self:Bar(402902, cd, CL.count:format(L.twisted_earth, twistedEarthCount))
	end
end

function mod:EchoingFissure()
	local msg = CL.count:format(L.echoing_fissure, echoingFissureCount)
	self:StopBar(msg)
	self:Message(402115, "orange", msg)
	self:PlaySound(402115, "alarm")
	echoingFissureCount = echoingFissureCount + 1
	self:CDBar(402115, 37, CL.count:format(L.echoing_fissure, echoingFissureCount))
end

do
	local markedPlayer = nil
	local function printTarget(self, player, guid)
		markedPlayer = player
		self:TargetMessage("wall_breaker", "yellow", player, L.wall_breaker_message, 407221)
		if self:Me(guid) then
			self:Say("wall_breaker", CL.rticon:format(L.wall_breaker_message, 6), nil, "Wall Breaker ({rt%6})")
			self:SayCountdown("wall_breaker", 5)
		end
		if self:CheckOption("wall_breaker", "ICON") then
			self:CustomIcon(false, player, 6)
		end
	end

	local timer = {38, 29, 28, 30} -- Stage 2
	function mod:RushingDarkness(args)
		local msg = CL.count:format(L.rushing_darkness, rushingDarknessCount)
		self:StopBar(msg)
		if self:Mythic() and self:GetStage() == 1 then
			self:GetBossTarget(printTarget, 1, args.sourceGUID) -- boss targets a player during the cast
		else
			self:Message(407221, "yellow", msg)
		end
		rushingDarknessCount = rushingDarknessCount + 1

		local cd
		if self:GetStage() == 1 then
			cd = 36.6
		elseif self:GetStage() == 2 then
			cd = timer[rushingDarknessCount] or (self:LFR() and 29 or 0)
		else -- stage 3
			cd = 29.1
		end
		self:CDBar(407221, cd, CL.count:format(L.rushing_darkness, rushingDarknessCount))
	end

	function mod:RushingDarknessEnd()
		if markedPlayer then
			self:CustomIcon(false, markedPlayer)
			markedPlayer = nil
		end
	end
end

function mod:CalamitousStrike(args)
	self:Message(401998, "purple", CL.casting:format(args.spellName))
	self:PlaySound(401998, "info")
	self:CDBar(401998, self:GetStage() == 1 and 37 or 30)
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
	self:StopBar(CL.count:format(L.twisted_earth, twistedEarthCount)) -- Twisted Earth
	self:StopBar(401998) -- Calamitous Strike
	self:StopBar(CL.count:format(L.echoing_fissure, echoingFissureCount)) -- Echoing Fissure
	self:StopBar(CL.count:format(L.rushing_darkness, rushingDarknessCount)) -- Rushing Darkness
	self:StopBar(CL.count:format(CL.bombs, volcanicHeartCount)) -- Volcanic Heart

	self:Message("stages", "cyan", CL.intermission, false)
	self:PlaySound("stages", "long")

	self:Bar("stages", 7, CL.stage:format(2), 403057) -- Stage 2, Surrender To Corruption Icon
end

-- Stage 2
function mod:SurrenderToCorruption()
	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long")

	twistedEarthCount = 1
	volcanicHeartCount = 1
	umbralAnnihilationCount = 1
	rushingDarknessCount = 1
	corruptionCount = 1
	addDeaths = 0

	self:CDBar(407790, 14.9) -- Sunder Shadow
	self:CDBar(410953, 20.7, CL.count:format(CL.bombs, volcanicHeartCount)) -- Volcanic Heart
	self:CDBar(405433, 25, CL.count:format(L.umbral_annihilation, umbralAnnihilationCount)) -- Umbral Annihilation
	self:CDBar(407221, 32, CL.count:format(L.rushing_darkness, rushingDarknessCount)) -- Rushing Darkness
	if not self:Easy() then
		self:Bar(402902, 41.5, CL.count:format(L.twisted_earth, twistedEarthCount))
		self:Bar(401010, 7, CL.count:format(self:SpellName(401010), corruptionCount)) -- Corruption
	end
end

do
	local playerList = {}
	local prev = 0
	function mod:CorruptionPreDebuff(args)
		local msg = CL.count:format(self:SpellName(401010), corruptionCount)
		if args.time - prev > 2 then -- reset
			playerList = {}
			prev = args.time
			self:StopBar(msg)
			corruptionCount = corruptionCount + 1
			if corruptionCount < 4 then -- 3 sets
				self:CDBar(401010, 43, CL.count:format(self:SpellName(401010), corruptionCount))
			end
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PlaySound(401010, "warning")
			self:Say(401010, nil, nil, "Corruption")
		end
		self:TargetsMessage(401010, "yellow", playerList, nil, msg)
	end
end

function mod:HiddenInVoidRemoved(args)
	self:Message(args.spellId, "green", CL.removed:format(args.spellName))
	self:PlaySound(args.spellId, "long")
end

function mod:UmbralAnnihilation(args)
	local msg = CL.count:format(L.umbral_annihilation, umbralAnnihilationCount)
	self:StopBar(msg)
	self:Message(args.spellId, "orange", msg)
	self:PlaySound(args.spellId, "alarm")
	umbralAnnihilationCount = umbralAnnihilationCount + 1
	-- 6+ are spam casted
	local cd = (umbralAnnihilationCount < 6 or self:LFR()) and 30 or 11
	self:CDBar(args.spellId, cd, CL.count:format(L.umbral_annihilation, umbralAnnihilationCount))
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

function mod:AddKilled()
	addDeaths = addDeaths + 1
	if addDeaths == 3 then
		self:Stage2Over()
	else
		self:Message("stages", "green", CL.add_killed:format(addDeaths, 3), false)
	end
end

function mod:ShadowBarrier(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:Stage2Over()
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
	castingEbonDestruction =  false

	self:CDBar(407936, 21.2, CL.count:format(CL.portals, sunderRealityCount)) -- Sunder Reality
	self:CDBar(407221, 27.6, CL.count:format(L.rushing_darkness, rushingDarknessCount)) -- Rushing Darkness
	self:CDBar(401998, 35.4) -- Calamitous Strike
	self:CDBar(407917, 41.5, CL.count:format(L.ebon_destruction, ebonDestructionCount)) -- Ebon Destruction
	self:Bar(402902, self:Mythic() and 49.2 or 79.1, L.twisted_earth) -- Twisted Earth
end

-- Stage 3
function mod:SunderReality(args)
	local msg = CL.count:format(CL.portals, sunderRealityCount)
	self:StopBar(msg)
	self:Message(args.spellId, "yellow", msg)
	self:PlaySound(args.spellId, "alert")
	sunderRealityCount = sunderRealityCount + 1
	if sunderRealityCount < (self:Easy() and 8 or 5) then -- 4 sets heroic/mythic, 7 sets normal/lfr
		self:CDBar(args.spellId, 35.2, CL.count:format(CL.portals, sunderRealityCount))
	end
end

do
	local prev = 0
	function mod:SunderedRealityApplied(args)
		if self:Me(args.destGUID) then
			if castingEbonDestruction then
				self:Message(args.spellId, "green", CL.you:format(args.spellName))
				self:PlaySound(args.spellId, "info")
			elseif args.time-prev > 2 then  -- Ground Effect
				prev = args.time
				self:PersonalMessage(args.spellId, "underyou")
				self:PlaySound(args.spellId, "underyou")
			end
		end
	end

	function mod:SunderedRealityDamage(args)
		if self:Me(args.destGUID) and not castingEbonDestruction and args.time-prev > 2 then
			prev = args.time
			self:PersonalMessage(args.spellId, "underyou")
			self:PlaySound(args.spellId, "underyou")
		end
	end

	function mod:EbonDestruction(args)
		local msg = CL.count:format(L.ebon_destruction, ebonDestructionCount)
		self:StopBar(msg)
		self:Message(args.spellId, "red", CL.casting:format(msg))
		self:PlaySound(args.spellId, "warning")
		self:CastBar(args.spellId, 12, L.ebon_destruction)
		ebonDestructionCount = ebonDestructionCount + 1
		-- 8+ are spam casted (7.3 cd)
		if ebonDestructionCount < 8 then
			self:CDBar(args.spellId, 36.5, CL.count:format(L.ebon_destruction, ebonDestructionCount))
		end
		castingEbonDestruction = true
	end

	function mod:EbonDestructionSuccess()
		castingEbonDestruction = false
	end
end
