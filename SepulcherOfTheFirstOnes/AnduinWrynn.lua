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
local grimReflectionMarks = {}
local grimReflectionCollector = {}

--------------------------------------------------------------------------------
-- Timer Tables
--

local timersHeroic = {
	[1] = {
		[366849] = {7.5}, -- DW: Pain
		[361989] = {30.0, 50.0, 55.0, 0}, -- Blasphemy
		[362405] = {45.0, 60.0, 0}, -- Kingsmourne Hungers
		[365295] = {17.0, 52.0, 48.0, 0}, -- Befouled Barrier
		[361815] = {5.0, 32.0, 28.0, 30.0, 30.0, 0}, -- Hopebreaker
		[365021] = {55.0, 35.0, 30.0, 0}, -- Wicked Star
		[362771] = {6.9, 12.0, 12.0, 12.0, 12.0, 0}, -- Soul Reaper
	},
	[2] = {
		[366849] = {11.5}, -- DW: Pain
		[362405] = {48.5, 60, 0}, -- Kingsmourne Hungers
		[365295] = {80.5, 47, 0}, -- Befouled Barrier
		[361815] = {13.5, 22, 33, 29, 29, 0}, -- Hopebreaker
		[365021] = {18.5, 39.0, 26.0, 30.5, 19.0, 0}, -- Wicked Star
		[365120] = {8.5, 87, 0}, -- Grim Reflections
		[362771] = {7.5, 14.1, 11.8, 10.0, 12.0, 0}, -- Soul Reaper
	}
}

local timersMythic = {
	[1] = {
		[366849] = {7.0, 13.0, 13.0, 10.0, 15.0, 13.0, 13.0, 13.0, 13.9, 12.0, 14.8, 0}, -- DW: Pain
		[361989] = {30.0, 50.0, 55.0, 0}, -- Blasphemy
		[362405] = {45.0, 60.0, 0}, -- Kingsmourne Hungers
		[365295] = {17.0, 52.0, 48.0, 0}, -- Befouled Barrier
		[361815] = {5.0, 32.0, 28.0, 30.0, 30.0, 0}, -- Hopebreaker
		[365021] = {55.0, 35.0, 30.0, 0}, -- Wicked Star
		[362771] = {8.2, 14.0, 12.0, 10.0, 12.0, 0}, -- Soul Reaper
	},
	[2] = {
		[366849] = {10.7, 13.0, 13.0, 17.8, 8.2, 13.0, 13.0, 14.5, 11.4, 12.1, 0}, -- DW: Pain
		[362405] = {48.7, 60.0, 0}, -- Kingsmourne Hungers
		[365295] = {80.7, 47.0, 0}, -- Befouled Barrier
		[361815] = {13.6, 25.0, 33.0, 29.0, 29.1, 0}, -- Hopebreaker
		[365021] = {18.7, 39.0, 26.0, 30.9, 19.1, 0}, -- Wicked Star
		[365120] = {8.7, 87.0, 0}, -- Grim Reflections
		[362771] = {7.5, 14.0, 12.0, 10.0, 12.0, 0}, -- Soul Reaper
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

	L.remnant_active = "Remnant Active"
	L.march_counter = "%s (%d/8)"
end

--------------------------------------------------------------------------------
-- Initialization
--

local anduinsHopeMarker = mod:AddMarkerOption(false, "npc", 1, -24468, 1, 2, 3, 4) -- Anduin's Hope
local grimReflectionMarker = mod:AddMarkerOption(true, "npc", 8, 365120, 8, 7, 6, 5)
function mod:GetOptions()
	return {
		"stages",
		362405, -- Kingsmourne Hungers
		362055, -- Lost Soul
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
		[365958] = L.dire_blasphemy, -- Dire Blasphemy (Marks)
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	self:Log("SPELL_CAST_START", "KingsmourneHungers", 362405)
	self:Log("SPELL_CAST_SUCCESS", "KingsmourneHungersSuccess", 362405)
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
	self:Log("SPELL_CAST_START", "SoulReaper", 362771)
	self:Log("SPELL_CAST_SUCCESS", "ArmyOfTheDead", 362862)
	self:Log("SPELL_CAST_START", "NecroticDetonation", 363024)
	self:Log("SPELL_AURA_REMOVED", "DominationsGraspRemoved", 362505)
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

	grimReflectionMarks = {}
	grimReflectionCollector = {}

	if self:Healer() then
		self:Bar(366849, timers[stage][366849][dominationWordCount], CL.count:format(L.domination_word_pain, dominationWordCount)) -- Domination Word: Pain
	end
	self:Bar(361815, timers[stage][361815][hopebreakerCount], CL.count:format(self:SpellName(361815), hopebreakerCount)) -- Hopebreaker
	self:Bar(365021, timers[stage][365021][wickedStarCount], CL.count:format(L.wicked_star, wickedStarCount)) -- Wicked Star
	self:Bar(361989, timers[stage][361989][blasphemyCount], CL.count:format(L.blasphemy, blasphemyCount)) -- Blasphemy
	self:Bar(365295, timers[stage][365295][barrierCount], CL.count:format(L.befouled_barrier, barrierCount)) -- Befouled Barrier
	self:Bar(362405, timers[stage][362405][kingsmourneHungersCount], CL.count:format(L.kingsmourne_hungers, kingsmourneHungersCount)) -- Kingsmourne Hungers
	self:Bar("stages", self:Easy() and 161 or 151, CL.intermission, 365216) -- Domination's Grasp Icon
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:GrimReflectionMarker(_, unit, guid)
	if grimReflectionCollector[guid] then
		self:CustomIcon(grimReflectionMarker, unit, grimReflectionCollector[guid]) -- icon order from SPELL_SUMMON
		grimReflectionCollector[guid] = nil
	end
end

-- Stage One

function mod:KingsmourneHungers(args)
	self:StopBar(CL.count:format(L.kingsmourne_hungers, kingsmourneHungersCount))
	self:Message(args.spellId, "red", CL.count:format(L.kingsmourne_hungers, kingsmourneHungersCount))
	self:PlaySound(args.spellId, "alert")
	kingsmourneHungersCount = kingsmourneHungersCount + 1
	self:Bar(args.spellId, timers[stage][args.spellId][kingsmourneHungersCount], CL.count:format(L.kingsmourne_hungers, kingsmourneHungersCount))
end

do
	local timer = nil
	function mod:HopeMarker()
		for boss = 2, 5 do
			local unit = ("boss%d"):format(boss)
			local guid = self:UnitGUID(unit)
			if self:MobId(guid) == 184493 then -- Anduin's Hope
				self:CustomIcon(anduinsHopeMarker, unit, boss - 1)
			end
		end
		timer = nil
	end

	function mod:KingsmourneHungersSuccess(args)
		if not timer and self:GetOption(anduinsHopeMarker) then
			timer = self:ScheduleTimer("HopeMarker", 0.3) -- not valid on IEEU
		end
	end
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
		if stage == 3 then
			self:Bar(365021, self:Mythic() and 65.5 or 58.5, CL.count:format(L.wicked_star, wickedStarCount))
		else
			self:Bar(365021, timers[stage][365021][wickedStarCount], CL.count:format(L.wicked_star, wickedStarCount))
		end
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
	self:Message(361815, "orange", CL.count:format(self:SpellName(361815), hopebreakerCount))
	self:PlaySound(361815, "alarm")
	hopebreakerCount = hopebreakerCount + 1
	if stage == 3 then
		self:Bar(361815, self:Mythic() and 65.5 or 58.5, CL.count:format(self:SpellName(361815), hopebreakerCount))
	else
		self:Bar(361815, timers[stage][361815][hopebreakerCount], CL.count:format(self:SpellName(361815), hopebreakerCount))
	end
end

do
	local prev = 0
	local playerList = {}
	function mod:DominationWordPainApplied(args)
		local t = args.time
		if t-prev > 5 then
			self:StopBar(CL.count:format(L.domination_word_pain, dominationWordCount))
			playerList = {}
			prev = t
			dominationWordCount = dominationWordCount + 1
			if self:Healer() then
				self:Bar(args.spellId, self:Mythic() and timers[stage][args.spellId][dominationWordCount] or 12.5, CL.count:format(L.domination_word_pain, dominationWordCount))
			end
		end
		playerList[#playerList+1] = args.destName
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId, nil, L.domination_word_pain)
			self:PlaySound(args.spellId, "alarm")
		elseif self:Healer() then
			self:NewTargetsMessage(args.spellId, "yellow", playerList, 3, CL.count:format(L.domination_word_pain, dominationWordCount-1))
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

-- Intermission

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
		self:UnregisterTargetEvents()

		self:Message("stages", "cyan", CL.intermission, false)
		self:PlaySound("stages", "long")

		armyCount = 1
		soulReaperCount = 1
		marchCount = 1

		-- seems like the add cast is 9.5 +/- 0.3 (+1.5 for p2)
		-- and army/march are around the same time, and soul reaper can vary if the mob has to run to the tank z.z
		local cd = stage == 2 and 11 or 9.5
		self:Bar("stages", cd, L.remnant_active, 365216)
		-- self:Bar(362862, cd, CL.count:format(L.army_of_the_dead, armyCount)) -- Army of the Dead
		-- if stage == 2 or self:Mythic() then
		-- 	self:Bar(363233, cd, CL.count:format(L.march_of_the_damned, marchCount)) -- March of the Damned
		-- end
		-- self:CDBar(362771, timers[stage][362771][soulReaperCount] + cd, CL.count:format(self:SpellName(362771), soulReaperCount)) -- Soul Reaper
		self:Bar("stages", (self:Mythic() and 76 or 74) + cd, CL.stage:format(stage + 1), 363021) -- 363021 = Return to Kingsmourne
	end
end

function mod:SoulReaper(args)
	self:StopBar(CL.count:format(args.spellName, soulReaperCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, soulReaperCount))
	self:PlaySound(args.spellId, "alert")
	soulReaperCount = soulReaperCount + 1
	self:Bar(args.spellId, timers[stage][args.spellId][soulReaperCount], CL.count:format(args.spellName, soulReaperCount))
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

function mod:MarchOfTheDamned(args)
	self:Message(363233, "cyan", L.march_counter:format(L.march_of_the_damned, marchCount))
	self:PlaySound(363233, "info")
	marchCount = marchCount + 1
	-- if marchCount < 9 then
	-- 	self:Bar(363233, 7.5, CL.count:format(L.march_of_the_damned, marchCount))
	-- end
end

-- Stage Two

function mod:DominationsGraspRemoved(args)
	stage = stage + 1
	self:StopBar(CL.stage:format(stage))
	self:SetStage(stage)
	self:Message("stages", "cyan", CL.stage:format(stage), false)
	self:PlaySound("stages", "long")

	dominationWordCount = 1
	hopebreakerCount = 1
	wickedStarCount = 1
	barrierCount = 1
	kingsmourneHungersCount = 1
	grimReflectionsCount = 1
	hopelessnessCount = 1

	if stage == 2 then
		if self:GetOption(grimReflectionMarker) then
			self:RegisterTargetEvents("GrimReflectionMarker")
		end

		if self:Healer() then
			self:Bar(366849, timers[stage][366849][dominationWordCount], CL.count:format(L.domination_word_pain, dominationWordCount)) -- Domination Word: Pain
		end
		self:Bar(365120, timers[stage][365120][grimReflectionsCount], CL.count:format(L.grim_reflections, grimReflectionsCount)) -- Grim Reflections
		self:Bar(361815, timers[stage][361815][hopebreakerCount], CL.count:format(self:SpellName(361815), hopebreakerCount)) -- Hopebreaker
		self:Bar(365021, timers[stage][365021][wickedStarCount], CL.count:format(L.wicked_star, wickedStarCount)) -- Wicked Star
		self:Bar(362405, timers[stage][362405][kingsmourneHungersCount], CL.count:format(L.kingsmourne_hungers, kingsmourneHungersCount)) -- Kingsmourne Hungers
		self:Bar(365295, timers[stage][365295][barrierCount], CL.count:format(L.befouled_barrier, barrierCount)) -- Befouled Barrier
		self:Bar("stages", self:Mythic() and 170 or 165, CL.intermission, 365216) -- Domination's Grasp Icon
	else -- stage 3
		self:Bar(361815, 11.1, CL.count:format(self:SpellName(361815), hopebreakerCount)) -- Hopebreaker
		self:Bar(365958, 21.1, CL.count:format(L.dire_blasphemy, hopelessnessCount)) -- Hopelessness
		self:Bar(365021, 41.1, CL.count:format(L.wicked_star, wickedStarCount)) -- Wicked Star
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
		for i = 8, 5, -1 do -- 8, 7, 6, 5
			if not grimReflectionCollector[args.destGUID] and not grimReflectionMarks[i] then
				grimReflectionMarks[i] = args.destGUID
				grimReflectionCollector[args.destGUID] = i
				return
			end
		end
	end
end

-- Stage Three

function mod:BeaconOfHope(args)
	if stage < 3 then
		-- Skipped intermission
		self:StopBar(CL.count:format(L.domination_word_pain, dominationWordCount)) -- Domination Word: Pain
		self:StopBar(CL.count:format(self:SpellName(361815), hopebreakerCount)) -- Hopebreaker
		self:StopBar(CL.count:format(L.wicked_star, wickedStarCount)) -- Wicked Star
		self:StopBar(CL.count:format(L.blasphemy, blasphemyCount)) -- Blasphemy
		self:StopBar(CL.count:format(L.befouled_barrier, barrierCount)) -- Befouled Barrier
		self:StopBar(CL.count:format(L.kingsmourne_hungers, kingsmourneHungersCount)) -- Kingsmourne Hungers
		self:StopBar(CL.count:format(L.grim_reflections, grimReflectionsCount)) -- Grim Reflections
		self:StopBar(CL.intermission)
		self:UnregisterTargetEvents()

		stage = 3
		self:SetStage(stage)
		hopebreakerCount = 1
		wickedStarCount = 1
		hopelessnessCount = 1

		self:Bar(361815, 11.5, CL.count:format(self:SpellName(361815), hopebreakerCount)) -- Hopebreaker
		self:Bar(365958, 21.7, CL.count:format(L.dire_blasphemy, hopelessnessCount)) -- Hopelessness
		self:Bar(365021, 41.0, CL.count:format(L.wicked_star, wickedStarCount)) -- Wicked Star
	end

	self:Message(args.spellId, "green")
	self:PlaySound(args.spellId, "long")
end

do
	function mod:Hopelessness(args)
		self:StopBar(CL.count:format(L.dire_blasphemy, hopelessnessCount))
		self:Message(args.spellId, "yellow", CL.count:format(L.dire_blasphemy, hopelessnessCount))
		self:PlaySound(args.spellId, "alert")
		hopelessnessCount = hopelessnessCount + 1
		self:Bar(args.spellId, self:Mythic() and 65.5 or 58.5, CL.count:format(L.dire_blasphemy, hopelessnessCount))
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
