--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Anduin Wrynn", 2481, 2469)
if not mod then return end
mod:RegisterEnableMob(181954) -- Anduin Wrynn
mod:SetEncounterID(2546)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local kingsmourneHungersCount = 1
local blasphemyCount = 1
local barrierCount = 1
local hopebreakerCount = 1
local dominationWordCount = 1
local armyCount = 1
local soulReaperCount = 1
local grimReflectionsCount = 1
local marchCount = 1
local hopelessnessCount = 1
local wickedStarCount = 1
local beaconCount = 1
local anduinsHopeMarks = {}
local grimReflectionMarks = {}
local grimReflectionCollector = {}
local mobCollector = {}

--------------------------------------------------------------------------------
-- Timer Tables
--

local timersHeroic = {
	[1] = {
		[361989] = {30.0, 50.0, 55.0, 0}, -- Blasphemy
		[362405] = {45.0, 60.0, 0}, -- Kingsmourne Hungers
		[365295] = {17.0, 52.0, 48.0, 0}, -- Befouled Barrier
		[361815] = {5.0, 32.0, 28.0, 30.0, 30.0, 0}, -- Hopebreaker
		[365021] = {55.0, 35.0, 30.0, 0}, -- Wicked Star
	},
	[2] = {
		[362405] = {48.5, 60, 0}, -- Kingsmourne Hungers
		[365295] = {80.5, 47, 0}, -- Befouled Barrier
		[361815] = {13.5, 22, 33, 29, 29, 0}, -- Hopebreaker
		[365021] = {18.5, 39.0, 26.0, 30.5, 19.0, 0}, -- Wicked Star
		[365120] = {8.5, 87}, -- Grim Reflections
	}
}

local timersMythic = {
	[1] = {
		[361989] = {30.0, 50.0, 55.0, 65.0}, -- Blasphemy
		[362405] = {45.0, 60.0, 65.1, 65.0}, -- Kingsmourne Hungers
		[365295] = {17.0, 53.0, 40.0, 65.0, 65.0}, -- Befouled Barrier
		[361815] = {5.0, 32.0, 28.0, 30.0, 30.0, 30.0, 35.0, 30.0}, -- Hopebreaker
		[365021] = {55, 30, 35}, -- Wicked Star
	},
	[2] = {
		[362405] = {53.5, 60}, -- Kingsmourne Hungers
		[365295] = {63.5, 55}, -- Befouled Barrier
		[361815] = {18, 25.3, 32.9, 26.8, 30.0}, -- Hopebreaker
		[365021] = {23, 55.0, 50.0, 15.0}, -- Wicked Star
		[365120] = {13, 80.0}, -- Grim Reflections
	}
}

local timers = mod:Mythic() and timersMythic or timersHeroic

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.custom_off_repeating_blasphemy = "Repeating Blasphemy"
	L.custom_off_repeating_blasphemy_desc = "Repeating Blasphemy say messages with icons {rt1}, {rt3} to find matches to remove your debuffs."

	L.kingsmourne_hungers = "Kingsmourne"
	L.blasphemy = "Marks"
	L.befouled_barrier = "Barrier"
	L.wicked_star = "Star"
	L.domination_word_pain = "DW:Pain"
	L.army_of_the_dead = "Army"
	L.grim_reflections = "Fear Adds"
	L.march_of_the_damned = "Walls"
	L.dire_blasphemy = "Marks"
	L.beacon_of_hope = "Beacon"

	L.remnant_active = "Remnant Active"
	L.march_counter = "%s (%d/8)"
end

--------------------------------------------------------------------------------
-- Initialization
--

local anduinsHopeMarker = mod:AddMarkerOption(false, "npc", 1, -24468, 1, 2) -- Anduin's Hope
local grimReflectionMarker = mod:AddMarkerOption(true, "npc", 8, 365120, 8, 7, 6, 5, 4)
function mod:GetOptions()
	return {
		"stages",
		362405, -- Kingsmourne Hungers
		anduinsHopeMarker,
		361989, -- Blasphemy
		"custom_off_repeating_blasphemy",
		365295, -- Befouled Barrier
		{365021, "SAY", "SAY_COUNTDOWN"}, -- Wicked Star
		361815, -- Hopebreaker
		366849, -- Domination Word: Pain
		{364248, "TANK"}, -- Dark Zeal
		{362771, "TANK"}, -- Soul Reaper
		362862, -- Army of the Dead
		363024, -- Necrotic Detonation
		365120, -- Grim Reflections
		grimReflectionMarker,
		363233, -- March of the Damned
		365872, -- Beacon of Hope
		365958, -- Hopelessness
	},{
		["stages"] = "general",
		[362405] = -24462, -- Stage One: Kingsmourne Hungers
		[362771] = -24494, -- Intermission: Remnant of a Fallen King
		[365120] = -24478, -- Stage Two: Grim Reflections
		[363233] = -24172, -- Intermission: March of the Damned
		[365872] = -24417, -- Stage Three: A Moment of Clarity
	},{
		[362405] = L.kingsmourne_hungers, -- Kingsmourne Hungers (Kingsmourne)
		[361989] = L.blasphemy, -- Blasphemy (Marks)
		[365295] = L.befouled_barrier, -- Befouled Barrier (Barrier)
		[365021] = L.wicked_star, -- Wicked Star (Star)
		[366849] = L.domination_word_pain, -- Domination Word: Pain (DW:Pain)
		[362862] = L.army_of_the_dead, -- Army of the Dead (Army)
		[365120] = L.grim_reflections, -- Grim Reflections (Fear Adds)
		[363233] = L.march_of_the_damned, -- March of the Damned (March)
		[365872] = L.beacon_of_hope, -- Beacon of Hope (Beacon)
		[365958] = L.dire_blasphemy, -- Dire Blasphemy (Marks)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_CAST_START", "KingsmourneHungers", 362405)
	self:Log("SPELL_CAST_START", "Blasphemy", 361989)
	self:Log("SPELL_AURA_APPLIED", "BlasphemyApplied", 361992, 361993) -- Overconfidence, Hopelessness
	self:Log("SPELL_AURA_REMOVED", "BlasphemyRemoved", 361992, 361993)
	self:Log("SPELL_CAST_START", "BefouledBarrier", 365295)
	self:Log("SPELL_CAST_SUCCESS", "WickedStar", 365030, 367631) -- Wicked Star, Empowered Wicked Star
	self:Log("SPELL_AURA_APPLIED", "WickedStarApplied", 365021, 367632) -- Wicked Star, Empowered Wicked Star
	self:Log("SPELL_AURA_REMOVED", "WickedStarRemoved", 365021, 367632)
	self:Log("SPELL_CAST_START", "Hopebreaker", 361815, 365805) -- Hopebreaker, Empowered Hopebreaker
	self:Log("SPELL_AURA_APPLIED", "DominationWordPainApplied", 366849)
	self:Log("SPELL_AURA_REMOVED", "DominationWordPainRemoved", 366849)
	self:Log("SPELL_AURA_APPLIED", "DarkZealApplied", 364248)
	self:Log("SPELL_AURA_APPLIED_DOSE", "DarkZealApplied", 364248)
	self:Log("SPELL_AURA_APPLIED", "DominationsGraspApplied", 365216)
	self:Log("SPELL_CAST_START", "SoulReaper", 362771)
	self:Log("SPELL_CAST_SUCCESS", "ArmyOfTheDead", 362862)
	self:Log("SPELL_CAST_START", "NecroticDetonation", 363024)
	self:Log("SPELL_AURA_REMOVED", "DominationsGraspRemoved", 365216)
	self:Log("SPELL_CAST_START", "GrimReflections", 365120)
	self:Log("SPELL_SUMMON", "GrimReflectionsSummon", 365039)
	self:Log("SPELL_CAST_SUCCESS", "MarchOfTheDamned", 363133)
	self:Log("SPELL_CAST_START", "BeaconOfHope", 365872)
	self:Log("SPELL_CAST_START", "Hopelessness", 365958)
	self:Log("SPELL_AURA_APPLIED", "HopelessnessApplied", 365966)
	self:Log("SPELL_AURA_REMOVED", "HopelessnessRemoved", 365966)
end

function mod:OnEngage()
	timers = self:Mythic() and timersMythic or timersHeroic
	stage = 1
	self:SetStage(stage)

	kingsmourneHungersCount = 1
	blasphemyCount = 1
	barrierCount = 1
	hopebreakerCount = 1
	dominationWordCount = 1
	wickedStarCount = 1

	anduinsHopeMarks = {}
	grimReflectionMarks = {}
	grimReflectionCollector = {}
	mobCollector = {}

	self:Bar(366849, 7.5, CL.count:format(L.domination_word_pain, dominationWordCount)) -- Domination Word: Pain
	self:Bar(361815, timers[stage][361815][hopebreakerCount], CL.count:format(self:SpellName(361815), hopebreakerCount)) -- Hopebreaker
	self:Bar(365021, timers[stage][365021][wickedStarCount], CL.count:format(L.wicked_star, wickedStarCount)) -- Wicked Star
	self:Bar(361989, timers[stage][361989][blasphemyCount], CL.count:format(L.blasphemy, blasphemyCount)) -- Blasphemy
	self:Bar(365295, timers[stage][365295][barrierCount], CL.count:format(L.befouled_barrier, barrierCount)) -- Befouled Barrier
	self:Bar(362405, timers[stage][362405][kingsmourneHungersCount], CL.count:format(L.kingsmourne_hungers, kingsmourneHungersCount)) -- Kingsmourne Hungers
	self:Bar("stages", self:Easy() and 161 or 151, CL.intermission, 365216) -- Domination's Grasp Icon
	if self:GetOption(grimReflectionMarker) or self:GetOption(anduinsHopeMarker) then
		self:RegisterTargetEvents("AddMarker")
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellId)
	if spellId == 363976 then -- Shadestep // Intermission
		self:StopBar(CL.count:format(L.domination_word_pain, dominationWordCount)) -- Domination Word: Pain
		self:StopBar(CL.count:format(self:SpellName(361815), hopebreakerCount)) -- Hopebreaker
		self:StopBar(CL.count:format(L.wicked_star, wickedStarCount)) -- Wicked Star
		self:StopBar(CL.count:format(L.blasphemy, blasphemyCount)) -- Blasphemy
		self:StopBar(CL.count:format(L.befouled_barrier, barrierCount)) -- Befouled Barrier
		self:StopBar(CL.count:format(L.kingsmourne_hungers, kingsmourneHungersCount)) -- Kingsmourne Hungers
		self:StopBar(CL.count:format(L.grim_reflections, grimReflectionsCount)) -- Grim Reflections
		self:StopBar(CL.intermission)

		self:Message("stages", "cyan", CL.intermission, false)
		self:PlaySound("stages", "long")
		self:Bar("stages", self:GetStage() == 2 and 10.7 or 9.3, L.remnant_active, 365216)

		armyCount = 1
		soulReaperCount = 1
		marchCount = 1
	end
end

function mod:KingsmourneHungers(args)
	self:StopBar(CL.count:format(L.kingsmourne_hungers, kingsmourneHungersCount))
	self:Message(args.spellId, "red", CL.count:format(L.kingsmourne_hungers, kingsmourneHungersCount))
	self:PlaySound(args.spellId, "alert")
	kingsmourneHungersCount = kingsmourneHungersCount + 1
	self:Bar(args.spellId, timers[stage][args.spellId][kingsmourneHungersCount], CL.count:format(L.kingsmourne_hungers, kingsmourneHungersCount))
	anduinsHopeMarks = {}
end

do
	local sayMessages = {"{rt1}{rt1}","{rt3}{rt3}{rt3}"} -- Overconfidence = Star, Hopelessness = Diamond
	local sayTimer = nil
	function mod:Blasphemy(args)
		self:StopBar(CL.count:format(L.blasphemy, blasphemyCount))
		self:Message(args.spellId, "yellow", CL.count:format(L.blasphemy, blasphemyCount))
		self:PlaySound(args.spellId, "alarm")
		blasphemyCount = blasphemyCount + 1
		self:Bar(args.spellId, timers[stage][args.spellId][blasphemyCount], CL.count:format(L.blasphemy, blasphemyCount))
	end

	function mod:BlasphemyApplied(args)
		if self:Me(args.destGUID) then
			local icon = args.spellId == 361992 and 1 or 2
			local text = sayMessages[icon]
			self:PersonalMessage(361989, nil, args.spellName, args.spellId)
			self:PlaySound(361989, "warning")
			if self:GetOption("custom_off_repeating_blasphemy") then
				self:Say(false, text, true)
				sayTimer = self:ScheduleRepeatingTimer("Say", 1.5, false, text, true)
			end
		end
	end

	function mod:BlasphemyRemoved(args)
		if self:Me(args.destGUID) then
			if sayTimer then
				self:CancelTimer(sayTimer)
				sayTimer = nil
			end
		end
	end
end

function mod:BefouledBarrier(args)
	self:StopBar(CL.count:format(L.befouled_barrier, barrierCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.befouled_barrier, barrierCount))
	self:PlaySound(args.spellId, "alert")
	barrierCount = barrierCount + 1
	self:Bar(args.spellId, timers[stage][args.spellId][barrierCount], CL.count:format(L.befouled_barrier, barrierCount))
end

do
	local prev = 0
	local starWaveCount = 0
	function mod:WickedStar(args)
		self:StopBar(CL.count:format(L.wicked_star, wickedStarCount))
		self:Message(365021, "cyan", CL.incoming:format(CL.count:format(L.wicked_star, wickedStarCount)))
		self:PlaySound(365021, "long")
		wickedStarCount = wickedStarCount + 1
		self:Bar(365021, self:GetStage() == 3 and 58.5 or timers[stage][365021][wickedStarCount], CL.count:format(L.wicked_star, wickedStarCount))
		starWaveCount = 0
	end

	function mod:WickedStarApplied(args)
		local t = args.time
		if t-prev > 1 then
			prev = t
			starWaveCount = starWaveCount + 1
		end
		if self:Me(args.destGUID) then
			self:PersonalMessage(365021, nil, L.wicked_star)
			self:PlaySound(365021, "warning")
			self:Say(365021, L.wicked_star)
			self:SayCountdown(365021, 4, starWaveCount)
		end
	end

	function mod:WickedStarRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(365021)
		end
	end
end

function mod:Hopebreaker(args)
	self:StopBar(CL.count:format(self:SpellName(361815), hopebreakerCount))
	self:Message(361815, "yellow", CL.count:format(self:SpellName(361815), hopebreakerCount))
	self:PlaySound(361815, "alarm")
	hopebreakerCount = hopebreakerCount + 1
	self:Bar(361815, self:GetStage() == 3 and 58.5 or timers[stage][361815][hopebreakerCount], CL.count:format(self:SpellName(361815), hopebreakerCount))
end

do
	local prev = 0
	local playerList = {}
	function mod:DominationWordPainApplied(args)
		local t = args.time
		if t-prev > 5 and self:Healer() then
			self:StopBar(CL.count:format(L.domination_word_pain, dominationWordCount))
			playerList = {}
			prev = t
			dominationWordCount = dominationWordCount + 1
			self:Bar(args.spellId, 12.5, CL.count:format(L.domination_word_pain, dominationWordCount))
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId, nil, L.domination_word_pain)
			self:PlaySound(args.spellId, "alarm")
		elseif self:Healer() then
			self:NewTargetsMessage(args.spellId, "yellow", playerList, nil, CL.count:format(L.domination_word_pain, dominationWordCount-1))
		end
	end

	function mod:DominationWordPainRemoved(args)
		if self:Me(args.destGUID) then
			self:Message(args.spellId, "green", CL.removed:format(L.domination_word_pain))
			self:PlaySound(args.spellId, "info")
		end
	end
end

function mod:DarkZealApplied(args)
	local amount = args.amount or 1
	if amount % 5 == 0 then -- 5, 10...
		self:NewStackMessage(args.spellId, "purple", args.destName, amount)
		self:PlaySound(args.spellId, "alert")
	end
end

function mod:DominationsGraspApplied(args)
	self:StopBar(CL.count:format(L.domination_word_pain, dominationWordCount)) -- Domination Word: Pain
	self:StopBar(CL.count:format(self:SpellName(361815), hopebreakerCount)) -- Hopebreaker
	self:StopBar(CL.count:format(L.wicked_star, wickedStarCount)) -- Wicked Star
	self:StopBar(CL.count:format(L.blasphemy, blasphemyCount)) -- Blasphemy
	self:StopBar(CL.count:format(L.befouled_barrier, barrierCount)) -- Befouled Barrier
	self:StopBar(CL.count:format(L.kingsmourne_hungers, kingsmourneHungersCount)) -- Kingsmourne Hungers
	self:StopBar(CL.count:format(L.grim_reflections, grimReflectionsCount)) -- Grim Reflections


	--self:Bar(362862, stage == 2 and 4.3 or 2.8, CL.count:format(L.army_of_the_dead, armyCount)) -- Army of the Dead
	self:Bar(362771, stage == 2 and 12 or 10.5, CL.count:format(self:SpellName(362771), soulReaperCount)) -- Soul Reaper
	self:Bar("stages", 69, CL.stage:format(self:GetStage()+1), 363976)
	if stage == 2 then -- Intermission 2
		self:Bar(363233, 4.5, CL.count:format(L.march_of_the_damned, marchCount)) -- March of the Damned
	end
end

function mod:SoulReaper(args)
	self:StopBar(CL.count:format(args.spellName, soulReaperCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, soulReaperCount))
	self:PlaySound(args.spellId, "alert")
	soulReaperCount = soulReaperCount + 1
	if soulReaperCount < 4 then
		self:Bar(args.spellId, 13.3, CL.count:format(args.spellName, soulReaperCount))
	end
end

function mod:ArmyOfTheDead(args)
	self:StopBar(CL.count:format(L.army_of_the_dead, armyCount))
	self:Message(args.spellId, "yellow", CL.count:format(L.army_of_the_dead, armyCount))
	self:PlaySound(args.spellId, "long")
	armyCount = armyCount + 1
	if armyCount < 3 then
		self:Bar(args.spellId, self:Easy() and 41.1 or 37, CL.count:format(L.army_of_the_dead, armyCount))
	end
end

function mod:NecroticDetonation(args)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:PlaySound(args.spellId, "warning")
end

function mod:DominationsGraspRemoved(args)
	self:StopBar(CL.intermission)
	stage = stage + 1
	self:SetStage(stage)
	self:Message("stages", "cyan", CL.stage:format(stage), false)
	self:PlaySound("stages", "long")

	dominationWordCount = 1
	hopebreakerCount = 1
	wickedStarCount = 1
	barrierCount = 1
	kingsmourneHungersCount = 1
	grimReflectionsCount = 1
	beaconCount = 1
	hopelessnessCount = 1

	if stage == 2 then
		self:Bar(365120, timers[stage][365120][grimReflectionsCount], CL.count:format(L.grim_reflections, grimReflectionsCount)) -- Grim Reflections
		self:Bar(366849, 11.5, CL.count:format(L.domination_word_pain, dominationWordCount)) -- Domination Word: Pain
		self:Bar(361815, timers[stage][361815][hopebreakerCount], CL.count:format(self:SpellName(361815), hopebreakerCount)) -- Hopebreaker
		self:Bar(365021, timers[stage][365021][wickedStarCount], CL.count:format(L.wicked_star, wickedStarCount)) -- Wicked Star
		self:Bar(362405, timers[stage][362405][kingsmourneHungersCount], CL.count:format(L.kingsmourne_hungers, kingsmourneHungersCount)) -- Kingsmourne Hungers
		self:Bar(365295, timers[stage][365295][barrierCount], CL.count:format(L.befouled_barrier, barrierCount)) -- Befouled Barrier
		self:Bar("stages", self:Easy() and 165 or 156, CL.intermission, 365216) -- Domination's Grasp Icon
	else -- stage 3
		self:Bar(361815, 12.5, CL.count:format(self:SpellName(361815), hopebreakerCount)) -- Hopebreaker
		self:Bar(365958, 22.7, CL.count:format(L.dire_blasphemy, hopelessnessCount)) -- Hopelessness
		self:Bar(365021, 42.0, CL.count:format(L.wicked_star, wickedStarCount)) -- Wicked Star
	end
end

function mod:GrimReflections(args)
	self:StopBar(CL.count:format(L.grim_reflections, grimReflectionsCount))
	self:Message(args.spellId, "orange", CL.count:format(L.grim_reflections, grimReflectionsCount))
	self:PlaySound(args.spellId, "alert")
	grimReflectionsCount = grimReflectionsCount + 1
	self:Bar(args.spellId, timers[stage][args.spellId][grimReflectionsCount], CL.count:format(L.grim_reflections, grimReflectionsCount))
	grimReflectionMarks = {}
	grimReflectionCollector = {}
end

function mod:GrimReflectionsSummon(args)
	if self:GetOption(grimReflectionMarker) then
		for i = 8, 5, -1 do -- 8, 7, 6, 5, 4
			if not grimReflectionCollector[args.destGUID] and not grimReflectionMarks[i] then
				grimReflectionMarks[i] = args.destGUID
				grimReflectionCollector[args.destGUID] = i
				return
			end
		end
	end
end

function mod:AddMarker(event, unit, guid)
	if guid and not mobCollector[guid] then
		local mobId = self:MobId(guid)
		if grimReflectionCollector[guid] then
			self:CustomIcon(grimReflectionMarker, unit, grimReflectionCollector[guid])
			mobCollector[guid] = true
			return
		elseif self:GetOption(anduinsHopeMarker) and mobId == 184493 then -- Anduin's Hope
			for i = 1, 2, 1 do -- 1, 2
				if not anduinsHopeMarks[i] then
					mobCollector[guid] = true
					anduinsHopeMarks[i] = guid
					self:CustomIcon(anduinsHopeMarker, unit, i)
					return
				end
			end
		end
	end
end

function mod:MarchOfTheDamned(args)
	self:Message(363233, "cyan", L.march_counter:format(L.march_of_the_damned, marchCount))
	self:PlaySound(363233, "info")
	marchCount = marchCount + 1
end

function mod:BeaconOfHope(args)
	self:StopBar(CL.count:format(L.beacon_of_hope, beaconCount))
	self:Message(args.spellId, "green", CL.count:format(L.beacon_of_hope, beaconCount))
	self:PlaySound(args.spellId, "long")
	beaconCount = beaconCount + 1
end

do
	function mod:Hopelessness(args)
		self:StopBar(CL.count:format(L.dire_blasphemy, hopelessnessCount))
		self:Message(args.spellId, "yellow", CL.count:format(L.dire_blasphemy, hopelessnessCount))
		self:PlaySound(args.spellId, "alert")
		hopelessnessCount = hopelessnessCount + 1
		self:Bar(args.spellId, 58.5, CL.count:format(L.dire_blasphemy, hopelessnessCount))
	end

	function mod:HopelessnessApplied(args)
		if self:Me(args.destGUID) then
			self:PersonalMessage(365958, nil, args.spellName, args.spellId)
			self:PlaySound(365958, "alarm")
		end
	end

	function mod:HopelessnessRemoved(args)
		if self:Me(args.destGUID) then
			self:Message(365958, "green", CL.removed:format(args.spellName))
			self:PlaySound(365958, "info")
		end
	end
end
