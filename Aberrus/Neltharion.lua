if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Neltharion", 2569, 2523)
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
local rushingShadowsCount = 1
local twistedEarthCount = 1
local calamitousStrikeCount = 1

-- Stage 2
local annihilatingShadowsCount = 1
local sweepingShadowsCount = 1
local corruptionCount = 1

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
	L.custom_on_repeating_shattered_reality = "Repeating Shattered Reality warning"
	L.custom_on_repeating_shattered_reality_desc = "Repeat a message during the Ebon Destruction cast until you get inside a portal."
	-- L.repeating_shattered_reality_icon = 407919
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
		403049, -- Shadow Barrier
		-- Stage 3
		407936, -- Shatter Reality
		407919, -- Shattered Reality
		"custom_on_repeating_shattered_reality",
		407917, -- Ebon Destruction
	}, {
		[402902] = -26192, -- Stage 1
		[403057] = -26421, -- Stage 2
		[407936] = -26422, -- Stage 3
	}
end

function mod:OnBossEnable()
	-- Stage 1
	self:Log("SPELL_CAST_START", "EchoingFissure", 403272)
	self:Log("SPELL_CAST_START", "RushingShadows", 407207)
	self:Log("SPELL_AURA_APPLIED", "RushingShadowsApplied", 407182)
	self:Log("SPELL_AURA_REMOVED", "RushingShadowsRemoved", 407182)
	self:Log("SPELL_CAST_SUCCESS", "TwistedEarth", 409241)
	self:Log("SPELL_CAST_START", "CalamitousStrike", 406222)
	self:Log("SPELL_AURA_APPLIED", "CalamitousStrikeApplied", 401998)

	-- Stage 2
	self:Log("SPELL_CAST_START", "SurrenderToCorruption", 403057)
	self:Log("SPELL_CAST_START", "Corruption", 401101) -- Corruption
	self:Log("SPELL_AURA_APPLIED", "ClassCorruption", 405484) -- Surrendering to Corruption
	-- self:Log("SPELL_AURA_APPLIED", "ClassCorruption", 401123, 401124, 401125, 401126, 401127, 401128, 401129, 401130, 401131, 401132, 401133, 401134, 401135) -- Warrior, Paladin, Hunter, Rogue, Priest, Death Knight, Shaman, Mage, Warlock, Monk, Druid, Demon Hunter, Evoker
	self:Log("SPELL_CAST_START", "AnnihilatingShadows", 405434)
	self:Log("SPELL_CAST_START", "SweepingShadows", 403528)
	self:Log("SPELL_CAST_START", "SunderShadow", 407790)
	self:Log("SPELL_AURA_APPLIED", "SunderedShadowApplied", 407728)
	self:Log("SPELL_AURA_APPLIED", "ShadowBarrier", 403049)
	self:Log("SPELL_AURA_REMOVED", "Stage2Over", 407088)

	-- Stage 3
	self:Log("SPELL_CAST_SUCCESS", "ShatterReality", 407936)
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
	calamitousStrikeCount = 1

	annihilatingShadowsCount = 1
	sweepingShadowsCount = 1

	shatteredRealityCount = 1
	ebonDestructionCount = 1
	rushingShadowsCount = 1
	shatteredRealityOnMe = false
	castingEbonDestruction =  false

	self:CDBar(407221, 10, CL.count:format(self:SpellName(407221), rushingShadowsCount)) -- Rushing Shadows
	self:CDBar(401998, 22) -- Calamitous Strike
	self:CDBar(402115, 24, CL.count:format(self:SpellName(402115), echoingFissureCount)) -- Echoing Fissure
	self:CDBar(402902, 32, CL.count:format(self:SpellName(402902), twistedEarthCount)) -- Twisted Earth

	self:RegisterUnitEvent("UNIT_HEALTH", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_HEALTH(event, unit)
	if self:GetHealth(unit) < 73 then -- P2 at 70%
		self:Message("stages", "cyan", CL.soon:format(CL.stage:format(2)), false)
		self:PlaySound("stages", "info")
		self:UnregisterUnitEvent(event, unit)
	end
end

-- General
function mod:CalamitousStrike(args)
	self:Message(401998, "purple", CL.casting:format(args.spellName))
	self:PlaySound(401998, "info")
	if self:GetStage() == 1 then
		self:CDBar(401998, 20) -- 20~22
	else
		self:CDBar(401998, calamitousStrikeCount % 2 == 0 and 25.5 or 26.8)
	end
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

do
	local playerList = {}
	function mod:RushingShadows(args)
		self:StopBar(CL.count:format(args.spellName, rushingShadowsCount))
		rushingShadowsCount = rushingShadowsCount + 1
		self:CDBar(407221, rushingShadowsCount % 2 == 0 and 32.8 or 29.2, CL.count:format(args.spellName, rushingShadowsCount))
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

-- Stage 1
function mod:EchoingFissure(args)
	self:StopBar(CL.count:format(args.spellName, echoingFissureCount))
	self:Message(402115, "orange", CL.count:format(args.spellName, echoingFissureCount))
	self:PlaySound(402115, "alarm")
	echoingFissureCount = echoingFissureCount + 1
	self:CDBar(402115, echoingFissureCount % 2 == 0 and 29.2 or 32.8, CL.count:format(args.spellName, echoingFissureCount))
end

function mod:TwistedEarth(args)
	self:StopBar(CL.count:format(args.spellName, twistedEarthCount))
	self:Message(402902, "yellow", CL.count:format(args.spellName, twistedEarthCount))
	self:PlaySound(402902, "alert")
	twistedEarthCount = twistedEarthCount + 1
	self:CDBar(402902, twistedEarthCount % 2 == 0 and 35.2 or 26.7, CL.count:format(args.spellName, twistedEarthCount)) -- XXX can skip?
end

-- Stage 2
function mod:SurrenderToCorruption(args)
	self:StopBar(401998) -- Calamitous Strike
	self:StopBar(CL.count:format(self:SpellName(402115), echoingFissureCount)) -- Echoing Fissure
	self:StopBar(CL.count:format(self:SpellName(407221), rushingShadowsCount)) -- Rushing Shadows
	self:StopBar(CL.count:format(self:SpellName(402902), twistedEarthCount)) -- Twisted Earth

	self:SetStage(2)
	self:Message("stages", "cyan", CL.stage:format(2), false)
	self:PlaySound("stages", "long")

	annihilatingShadowsCount = 1
	sweepingShadowsCount = 1
	corruptionCount = 1

	self:CDBar(403846, 18, CL.count:format(self:SpellName(403528), sweepingShadowsCount)) -- Sweeping Shadows
	self:CDBar(404045, 25, CL.count:format(self:SpellName(404045), annihilatingShadowsCount)) -- Annihilating Shadows
	self:CDBar(407790, 35) -- Sunder Shadow
	self:CDBar(401010, 43, CL.count:format(self:SpellName(401010), corruptionCount)) -- Corruption
end

do
	local warned = false
	function mod:Corruption(args)
		corruptionCount = corruptionCount + 1
		self:CDBar(401010, corruptionCount % 2 == 0 and 31 or 27) -- sequence? and cd is like +/- 1.5s
		warned = false
	end

	function mod:ClassCorruption(args)
		if not warned then
			warned = true
			local className, class = UnitClass(args.destName)
			if className then
				local classColor = RAID_CLASS_COLORS[class]
				className = classColor:WrapTextInColorCode(className)
			end
			self:Message(401010, "cyan", CL.other:format(args.spellName, className or "???"))
		end
		if self:Me(args.destGUID) then
			self:PlaySound(401010, "warning")
			self:Say(401010)
		end
	end
end

function mod:AnnihilatingShadows(args)
	self:StopBar(CL.count:format(args.spellName, annihilatingShadowsCount))
	self:Message(404045, "orange", CL.count:format(args.spellName, annihilatingShadowsCount))
	self:PlaySound(404045, "alarm")
	annihilatingShadowsCount = annihilatingShadowsCount + 1
	local cd = annihilatingShadowsCount < 6 and 29 or 10
	self:CDBar(404045, cd, CL.count:format(args.spellName, annihilatingShadowsCount))
end

function mod:SweepingShadows(args)
	self:StopBar(CL.count:format(args.spellName, sweepingShadowsCount))
	self:Message(403846, "yellow", CL.count:format(args.spellName, sweepingShadowsCount))
	self:PlaySound(403846, "alert")
	sweepingShadowsCount = sweepingShadowsCount + 1
	local cd = {18, 25.6, 31.7, 28.1, 30.5}
	self:CDBar(403846, cd[sweepingShadowsCount] or 30, CL.count:format(args.spellName, sweepingShadowsCount))
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

function mod:ShadowBarrier(args)
	self:Message(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

function mod:Stage2Over(args)
	self:StopBar(407790) -- Sunder Shadow
	self:StopBar(401010) -- Corruption
	self:StopBar(CL.count:format(self:SpellName(404045), annihilatingShadowsCount)) -- Annihilating Shadows
	self:StopBar(CL.count:format(self:SpellName(403528), sweepingShadowsCount)) -- Sweeping Shadows

	self:SetStage(3)
	self:Message("stages", "cyan", CL.stage:format(3), false)
	self:PlaySound("stages", "info")

	calamitousStrikeCount = 1
	shatteredRealityCount = 1
	ebonDestructionCount = 1
	rushingShadowsCount = 1
	shatteredRealityOnMe = false
	castingEbonDestruction =  false

	self:CDBar(407221, 17.1, CL.count:format(self:SpellName(407221), rushingShadowsCount)) -- Rushing Shadows
	self:CDBar(401998, 23) -- Calamitous Strike
	self:CDBar(407917, 31.7, CL.count:format(self:SpellName(407917), ebonDestructionCount)) -- Ebon Destruction
end

-- Stage 3
function mod:ShatterReality(args)
	self:StopBar(CL.count:format(args.spellName, shatteredRealityCount))
	self:Message(args.spellId, "yellow", CL.count:format(args.spellName, shatteredRealityCount))
	self:PlaySound(args.spellId, "alert")
	shatteredRealityCount = shatteredRealityCount + 1
	self:Bar(args.spellId, 26, CL.count:format(args.spellName, shatteredRealityCount))
end

do
	local shatteredRealityCheck = nil
	local function checkForShatteredReality()
		if mod:GetOption("custom_on_repeating_shattered_reality") then
			if not shatteredRealityOnMe then
				mod:Message(407919, "blue", CL.no:format(mod:SpellName(403908)), 403908)
				mod:PlaySound(407919, "warning")
			end
			shatteredRealityCheck = mod:ScheduleTimer(checkForShatteredReality, 1)
		else
			shatteredRealityCheck = nil
		end
	end

	local prev = 0
	function mod:ShatteredRealityApplied(args)
		if self:Me(args.destGUID) then
			shatteredRealityOnMe = true
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
		self:CDBar(args.spellId, 26, CL.count:format(args.spellName, ebonDestructionCount))
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
