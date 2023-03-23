if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Neltharion", 2569, 2523)
if not mod then return end
mod:RegisterEnableMob(203133) -- Echo of Neltharion
mod:SetEncounterID(2684)
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

-- Stage 1
local echoingFissureCount = 1
local rushingShadowsCount = 1
local twistedEarthCount = 1

-- Stage 2
local stageTwoCount = 1
local surrenderToCorruptionCount = 1
local annihilatingShadowsCount = 1
local sweepingShadowsCount = 1

-- Stage 3
local shatteredRealityCount = 1
local ebonDestructionCount = 1
local rushingShadowsCount = 1
local shatteredRealityOnMe = false
local castingEbonDestruction = false

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_on_repeating_shattered_reality = "Repeating Shattered Reality"
	L.custom_on_repeating_shattered_reality_desc = "Repeating message during the Ebon Destruction cast to get inside a portal."
	L.custom_on_repeating_shattered_reality_icon = 407919
end

--------------------------------------------------------------------------------
-- Initialization
--

local rushingShadowsMarker = mod:AddMarkerOption(true, "player", 1, 407182, 1, 2, 3) -- Rushing Shadows
function mod:GetOptions()
	return {
		"stages",
		{407221, "SAY", "SAY_COUNTDOWN"}, -- Rushing Shadows
		rushingShadowsMarker,
		{401998, "TANK_HEALER"}, -- Calamitous Strike
		-- Stage 1
		402902, -- Twisted Earth
		402115, -- Echoing Fissure
		-- Stage 2
		403057, -- Surrender to Corruption
		{401010, "SAY"}, -- (Class) Corruption
		404045, -- Annihilating Shadows
		403846, -- Sweeping Shadows
		{407790, "TANK_HEALER"}, -- Sunder Shadow
		-- Stage 3
		403908, -- Shattered Reality
		"custom_on_repeating_shattered_reality",
		407917, -- Ebon Destruction
	}, {
		[402902] = -26192, -- Stage 1
		[403057] = -26421, -- Stage 2
		[403908] = -26422, -- Stage 3
	}
end

function mod:OnBossEnable()
	-- Stage 1
	self:Log("SPELL_CAST_START", "EchoingFissure", 403272)
	self:Log("SPELL_CAST_START", "RushingShadows", 407207)
	self:Log("SPELL_AURA_APPLIED", "RushingShadowsApplied", 407182)
	self:Log("SPELL_AURA_REMOVED", "RushingShadowsRemoved", 407182)
	self:Log("SPELL_CAST_SUCCESS", "TwistedEarth", 402902)
	self:Log("SPELL_CAST_START", "CalamitousStrike", 406222)
	self:Log("SPELL_AURA_APPLIED", "CalamitousStrikeApplied", 401998)

	-- Stage 2
	self:Log("SPELL_AURA_APPLIED", "Stage2Start", 407088)
	self:Log("SPELL_CAST_START", "SurrenderToCorruption", 403057)
	self:Log("SPELL_AURA_APPLIED", "ClassCorruption", 401123, 401124, 401125, 401126, 401127, 401128, 401129, 401130, 401131, 401132, 401133, 401134, 401135) -- Warrior, Paladin, Hunter, Rogue, Priest, Death Knight, Shaman, Mage, Warlock, Monk, Druid, Demon Hunter, Evoker
	self:Log("SPELL_CAST_START", "AnnihilatingShadows", 405436, 405434, 405433, 404038) -- 10s, 7.5s, 5s, 2.5s
	self:Log("SPELL_CAST_START", "SweepingShadows", 403528)
	self:Log("SPELL_CAST_START", "SunderShadow", 407790)
	self:Log("SPELL_AURA_APPLIED", "SunderedShadowApplied", 407728)
	self:Log("SPELL_AURA_REMOVED", "Stage2Over", 407088)

	-- Stage 3
	self:Log("SPELL_CAST_SUCCESS", "ShatteredReality", 403908)
	self:Log("SPELL_AURA_APPLIED", "ShatteredRealityApplied", 407919)
	self:Log("SPELL_PERIODIC_DAMAGE", "ShatteredRealityApplied", 407919)
	self:Log("SPELL_PERIODIC_MISSED", "ShatteredRealityApplied", 407919)
	self:Log("SPELL_AURA_REMOVED", "ShatteredRealityRemoved", 407919)
	self:Log("SPELL_CAST_START", "EbonDestruction", 407917)
	self:Log("SPELL_CAST_SUCCESS", "EbonDestructionSuccess", 407917)

end

function mod:OnEngage()
	self:SetStage(1)
	echoingFissureCount = 1
	rushingShadowsCount = 1
	twistedEarthCount = 1

	surrenderToCorruptionCount = 1
	annihilatingShadowsCount = 1
	sweepingShadowsCount = 1
	stageTwoCount = 1

	shatteredRealityCount = 1
	ebonDestructionCount = 1
	rushingShadowsCount = 1
	shatteredRealityOnMe = false
	castingEbonDestruction =  false

	--self:Bar(401998, 10) -- Calamitous Strike
	--self:Bar(402115, 10, CL.count:format(self:SpellName(402115), echoingFissureCount)) -- Echoing Fissure
	--self:Bar(407221, 10, CL.count:format(self:SpellName(407221), rushingShadowsCount)) -- Rushing Shadows
	--self:Bar(402902, 10, CL.count:format(self:SpellName(402902), twistedEarthCount)) -- Twisted Earth
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage 1
function mod:EchoingFissure(args)
	self:StopBar(CL.count:format(args.spellName, echoingFissureCount))
	self:Message(402115, "orange", CL.count:format(args.spellName, echoingFissureCount))
	self:PlaySound(402115, "alarm")
	echoingFissureCount = echoingFissureCount + 1
	--self:Bar(402115, 30, CL.count:format(args.spellName, echoingFissureCount))
end

do
	local playerList = {}
	function mod:RushingShadows(args)
		self:StopBar(CL.count:format(args.spellName, rushingShadowsCount))
		rushingShadowsCount = rushingShadowsCount + 1
		--self:Bar(407221, 30, CL.count:format(args.spellName, rushingShadowsCount))
		playerList = {}
	end

	function mod:RushingShadowsApplied(args)
		local count = #playerList+1
		playerList[count] = args.destName
		playerList[args.destName] = count -- Set raid marker
		if self:Me(args.destGUID) then
			self:PlaySound(407221, "warning")
			self:Say(407221, CL.rticon:format(args.spellName, count))
			self:SayCountdown(407221, 5, count)
		end
		self:CustomIcon(rushingShadowsMarker, args.destName, count)
		self:TargetsMessage(407221, "yellow", playerList, 3, CL.count:format(args.spellName, rushingShadowsCount-1))
	end

	function mod:RushingShadowsRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(407221)
		end
		self:CustomIcon(rushingShadowsMarker, args.destName)
	end
end

function mod:TwistedEarth(args)
	self:StopBar(CL.count:format(args.spellName, twistedEarthCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, twistedEarthCount))
	self:PlaySound(args.spellId, "alert")
	twistedEarthCount = twistedEarthCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, twistedEarthCount))
end

function mod:CalamitousStrike(args)
	self:Message(401998, "purple", CL.casting:format(args.spellName))
	self:PlaySound(401998, "info")
	--self:Bar(401998, 30)
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

function mod:Stage2Start(args)
	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "info")

	self:StopBar(401998) -- Calamitous Strike
	self:StopBar(CL.count:format(self:SpellName(402115), echoingFissureCount)) -- Echoing Fissure
	self:StopBar(CL.count:format(self:SpellName(407221), rushingShadowsCount)) -- Rushing Shadows
	self:StopBar(CL.count:format(self:SpellName(402902), twistedEarthCount)) -- Twisted Earth

	surrenderToCorruptionCount = 1
	annihilatingShadowsCount = 1
	sweepingShadowsCount = 1

	--self:Bar(407790, 10) -- Sunder Shadow
	--self:Bar(403057, 10, CL.count:format(self:SpellName(403057), surrenderToCorruptionCount)) -- Surrender to Corruption
	--self:Bar(404045, 10, CL.count:format(self:SpellName(404045), annihilatingShadowsCount)) -- Annihilating Shadows
	--self:Bar(403846, 10, CL.count:format(self:SpellName(403528), sweepingShadowsCount)) -- Sweeping Shadows
end

function mod:SurrenderToCorruption(args)
	self:StopBar(CL.count:format(args.spellName, surrenderToCorruptionCount))
	self:Message(args.spellId, "red", CL.count:format(args.spellName, surrenderToCorruptionCount))
	self:PlaySound(args.spellId, "long")
	surrenderToCorruptionCount = surrenderToCorruptionCount + 1
	--self:Bar(args.spellId, 30, CL.count:format(args.spellName, surrenderToCorruptionCount))
end

function mod:ClassCorruption(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(401010)
		self:PlaySound(401010, "warning")
		self:Say(401010)
	end
end

function mod:AnnihilatingShadows(args)
	self:StopBar(CL.count:format(args.spellName, annihilatingShadowsCount))
	self:Message(404045, "orange", CL.count:format(args.spellName, annihilatingShadowsCount))
	self:PlaySound(404045, "alarm")
	annihilatingShadowsCount = annihilatingShadowsCount + 1
	--self:Bar(404045, 30, CL.count:format(args.spellName, annihilatingShadowsCount))
end

function mod:SweepingShadows(args)
	self:StopBar(CL.count:format(args.spellName, sweepingShadowsCount))
	self:Message(403846, "yellow", CL.count:format(args.spellName, sweepingShadowsCount))
	self:PlaySound(403846, "alert")
	sweepingShadowsCount = sweepingShadowsCount + 1
	--self:Bar(403846, 30, CL.count:format(args.spellName, sweepingShadowsCount))
end

function mod:SunderShadow(args)
	self:Message(args.spellId, "purple", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 30)
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

function mod:Stage2Over(args)
	local stage = 1
	if stageTwoCount > 2 then -- Stage 3
		self:SetStage(3)
		stage = 3

		shatteredRealityCount = 1
		ebonDestructionCount = 1
		rushingShadowsCount = 1
		shatteredRealityOnMe = false
		castingEbonDestruction =  false

		--self:Bar(401998, 10) -- Calamitous Strike
		--self:Bar(403908, 10, CL.count:format(self:SpellName(403908), shatteredRealityCount)) -- Shattered Reality
		--self:Bar(407221, 10, CL.count:format(self:SpellName(407221), rushingShadowsCount)) -- Rushing Shadows
		--self:Bar(407917, 10, CL.count:format(self:SpellName(407917), ebonDestructionCount)) -- Ebon Destruction
	else -- Stage 1 again
		self:SetStage(1)
		echoingFissureCount = 1
		rushingShadowsCount = 1
		twistedEarthCount = 1

		--self:Bar(401998, 10) -- Calamitous Strike
		--self:Bar(402115, 10, CL.count:format(self:SpellName(402115), echoingFissureCount)) -- Echoing Fissure
		--self:Bar(407221, 10, CL.count:format(self:SpellName(407221), rushingShadowsCount)) -- Rushing Shadows
		--self:Bar(402902, 10, CL.count:format(self:SpellName(402902), twistedEarthCount)) -- Twisted Earth
	end

	self:Message("stages", "cyan", CL.stage:format(stage), false)
	self:PlaySound("stages", "info")

	stageTwoCount = stageTwoCount + 1
end

-- Stage 3
do
	local prev = 0
	local shatteredRealityCheck = nil
	local function checkForShatteredReality()
		if mod:GetOption("custom_on_repeating_shattered_reality") then
			if not shatteredRealityOnMe then
				mod:Message(403908, "blue", CL.no:format(mod:SpellName(407919)), 407919)
				mod:PlaySound(403908, "warning")
			end
			shatteredRealityCheck = mod:ScheduleTimer(checkForShatteredReality, 1)
		else
			shatteredRealityCheck = nil
		end
	end

	function mod:ShatteredReality(args)
		self:StopBar(CL.count:format(args.spellName, shatteredRealityCount))
		self:Message(args.spellId, "cyan", CL.count:format(args.spellName, shatteredRealityCount))
		self:PlaySound(args.spellId, "alert")
		shatteredRealityCount = shatteredRealityCount + 1
		--self:Bar(args.spellId, 30, CL.count:format(args.spellName, shatteredRealityCount))
	end

	function mod:ShatteredRealityApplied(args)
		if self:Me(args.destGUID) then
			shatteredRealityOnMe = true
			if castingEbonDestruction then
				self:Message(403908, "green", CL.you:format(args.spellName), 407919)
				self:PlaySound(403908, "info")
			else -- Ground Effect
				local t = args.time
				if t-prev > 2 then
					prev = t
					self:PersonalMessage(403908, "underyou", nil, 407919)
					self:PlaySound(403908, "underyou")
				end
			end
		end
	end

	function mod:ShatteredRealityRemoved(args)
		if self:Me(args.destGUID) then
			shatteredRealityOnMe = false
		end
	end

	function mod:EbonDestruction(args)
		self:StopBar(CL.count:format(args.spellName, ebonDestructionCount))
		self:Message(args.spellId, "red", CL.count:format(args.spellName, ebonDestructionCount))
		self:PlaySound(args.spellId, "warning")
		ebonDestructionCount = ebonDestructionCount + 1
		--self:Bar(args.spellId, 30, CL.count:format(args.spellName, ebonDestructionCount))
		castingEbonDestruction = true
		shatteredRealityCheck = mod:ScheduleTimer(checkForShatteredReality, 1)
	end

	function mod:EbonDestructionSuccess()
		castingEbonDestruction = false
		if shatteredRealityCheck then
			self:CancelTimer(shatteredRealityCheck)
			shatteredRealityCheck = nil
		end
	end
end
