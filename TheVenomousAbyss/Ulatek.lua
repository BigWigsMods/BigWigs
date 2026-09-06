
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ula'tek", 3004, 2895)
if not mod then return end
mod:RegisterEnableMob(257758)
mod:SetBlockedUnitsForWipeHealthCheck({
	[259555] = true, -- Gore Rattle
	[267460] = true, -- Venomous Heart
	[268164] = true, -- Doomscale Egg
	[263900] = true, -- Ravenous Doomscale
})
mod:SetEncounterID(3492)
mod:SetRespawnTime(30)
mod:UseCustomTimers(true)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}

local durationEventCount = {}
local checkStage = nil
local playerSide = nil

local rageCount = 1
local goreRattleCount = 1
local wavesCount = 1
local wrathCount = 1
local coilsCount = 1
local thrashCount = 1
local wombCount = 1
local incubationCount = 1

local spitCount = 1

local circlingPreyCount = 1
local callCount = 1
local submergeCount = 1
local biteCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:SetDefaultLocale({
	mephitic_thrash = "Sweep",
	call_of_the_serpent = "Eggs",
	gore_rattle = "Tail",
	grasping_fangs = "Tethers",
	circling_prey = "Platform Break",
	p3_knock_up = "Knock Up",

	toxic_womb = "Wretch Spawn",
	fester_burst = "Wretch Bubble",
	toxic_incubation = "Wretch Waves",

	count_amount_side = "%s (%d/%d) %s",
	count_side = "%s (%d) %s",
	fester_burst_count = "%s (%d-%d)",

	custom_select_limit_warnings = "Spectral Coils Group",
	custom_select_limit_warnings_desc = "Only show bars for your soak group (left or right).  Right side is first in stage one, left side is first in intermission.",
	custom_select_limit_warnings_icon = "misc_arrowlup",
	custom_select_limit_warnings_value1 = "Show warnings for both sides.",
	custom_select_limit_warnings_value2 = "Show warnings for left side only.",
	custom_select_limit_warnings_value3 = "Show warnings for right side only.",
	custom_select_limit_warnings_value4 = "Odd groups left, even groups right.",
	custom_select_limit_warnings_value5 = "Mythic: Groups 1 & 2 go left, groups 3 & 4 go right. Others: Groups 1/2/3 go left, groups 4/5/6 go right.",
})

--------------------------------------------------------------------------------
-- Renames
--

mod:SetRenames({
	["stages"] = {
		 CL.intermission, CL.stage:format(2), CL.stage:format(3), CL.gate_open, L.p3_knock_up,
		original = false,
		notes = { CL.intermission, CL.stage:format(2), CL.stage:format(3)},
	},

	[1310738] = {L.toxic_womb}, -- Toxic Womb
	[1310763] = {L.fester_burst}, -- Fester Burst
	[1299757] = {L.toxic_incubation}, -- Toxic Incubation

	[1292188] = {CL.waves}, -- Caustic Waves
	[1300751] = {L.call_of_the_serpent}, -- Call of the Serpent
	[1298367] = {CL.tank_knockback}, -- Mother's Wrath
	[1298559] = {L.gore_rattle}, -- Gore Rattle
	[1296301] = { -- Mephitic Thrash
		L.mephitic_thrash, CL.cast:format(L.mephitic_thrash),
		original = {1296301, CL.cast:format(mod:SpellName(1296301))},
		notes = {CL.generalNote, CL.castTimerNote},
	},
	[1300530] = {CL.soaks, CL.left, CL.right}, -- Spectral Coils
	[1292999] = {1292999}, -- Submerge
	[1286860] = { -- Rage of the Shackled
		CL.weakened, CL.cast:format(CL.weakened), CL.over:format(CL.weakened),
		original = {1286860, CL.cast:format(mod:SpellName(1286860)), CL.over:format(mod:SpellName(1286860))},
		notes = {CL.generalNote, CL.castTimerNote, CL.messageCastOverNote},
	},

	[1302982] = {1302982}, -- Virulent Spit
	[1301117] = {L.grasping_fangs}, -- Grasping Fangs
	[1290779] = {1290779}, -- Malice
	[1301213] = {CL.teleport}, -- Shadow Molt
	[1290990] = {1290990}, -- Writhing Gestation

	[1295905] = {CL.soaks}, -- Serpent's Bite
	[1300635] = {1300635}, -- Submerge
	[1301510] = { -- Circling Prey
		L.circling_prey, CL.cast:format(L.circling_prey),
		original = {1301510, CL.cast:format(mod:SpellName(1301510))},
		notes = {CL.generalNote, CL.castTimerNote},
	},
	[1286905] = {1286905}, -- Fury Unleashed
})

--------------------------------------------------------------------------------
-- Options
--

mod:SetAuraData({
	{1311611, soundOnApplied = "alarm", header = CL.important}, -- Grasping Fangs
	{1288879, soundOnApplied = "warning"}, -- Serpent's Bite
	{1313529, soundOnApplied = "info"}, -- Ingested Venom
	{1312967, soundOnApplied = "alarm", soundOnAppliedDose = "none"}, -- Volatile Purge
	{1300685}, -- Soul Constrictor

	{1292403, soundOnAppliedDose = "none", header = CL.general}, -- Caustic Waves
	{1297338}, -- Deadly Venom
	{1316356, soundOnAppliedDose = "none", note = "DoT"}, -- Volatile Purge
	{1306119, soundOnApplied = "alarm", note = "Petrified"}, -- Calcified Corpse
	{1298367}, -- Mother's Wrath
	{1298417, soundOnAppliedDose = "none", note = CL.tank_debuff}, -- Stone Venom
	{1300938}, -- Hobbled
	{1296301}, -- Mephitic Thrash
	{1302842, soundOnAppliedDose = "none", mythic = true, note = "Toxic Incubation"}, -- Toxic Burn

	{1295360, soundOnAppliedDose = "none", header = CL.adds}, -- Malignant Shell
	{1307612, soundOnAppliedDose = "none", mythic = true}, -- Noxious Shell
	{1307635, mythic = true}, -- Noxious Splash
	{1312150, mythic = true}, -- Rancid Yolk
	{1301268, soundOnAppliedDose = "none"}, -- Putrid Membrane
	{1287036, soundOnAppliedDose = "none"}, -- Poisonous Bite
	{1301800, soundOnAppliedDose = "none"}, -- Acidic Burst
	{1305163, soundOnApplied = "warning", note = "Targeted"}, -- Petrifying Sting
	{1303414, soundOnApplied = "alarm", note = "Petrified"}, -- Petrifying Sting
	{1300312}, -- Doomscale Shell
	{1305775, soundOnApplied = "alarm", note = "Stunned"}, -- Dread Roar
	{1305650, soundOnApplied = "alarm", note = "Stunned"}, -- Anguished Cry
	{1305709}, -- Desperate Thrash
	{1311609, soundOnAppliedDose = "none"}, -- Blight Vein
	{1306858}, -- Warden's Protection

	{1306388, soundOnApplied = "info", header = "Achievement?"}, -- Greasy Hatchling
	{1306393, soundOnApplied = "info"}, -- Butter Fingers
})

function mod:GetOptions()
	return {
		"custom_select_limit_warnings",

		"stages",

		-- Stage One: Fury of the Serpent Mother
		1292188, -- Caustic Waves
		1300751, -- Call of the Serpent
		{1298367, "TANK"}, -- Mother's Wrath
		1298559, -- Gore Rattle
			{1296301, "CASTBAR"}, -- Mephitic Thrash
			1300530, -- Spectral Coils (1287265)
			1292999, -- Submerge (P1)
		{1286860, "CASTBAR"}, -- Rage of the Shackled,

		1310738, -- Toxic Womb
		1310763, -- Fester Burst
		1299757, -- Toxic Incubation

		-- Stage Two: Children of the Doomscale
		1302982, -- Virulent Spit
		-- Rage of the Shackled
		-- Doomscale Warden
			-- 1301117, -- Grasping Fangs
			-- 1290779, -- Malice
			-- 1301213, -- Shadow Molt
			-- 1290990, -- Writhing Gestation

		-- Intermission: The Shattering
		-- Spectral Coils

		-- Stage Three: Ula'tek's Ascension
		{1301510, "CASTBAR"}, -- Circling Prey
			{1300635, "OFF"}, -- Submerge (P3)
		-- Caustic Waves
		-- Call of the Serpent
		1295905, -- Serpent's Bite
		-- Mother's Wrath
		-- Rage of the Shackled
		1286905, -- Fury Unleashed
	}, {
		{
			tabName = self:SpellName(-35561), -- Stage 1
			{ "stages", 1292188, 1300751, 1298367, 1298559, 1296301, 1300530, 1292999, 1286860, 1310738, 1310763, 1299757 },
		},
		{
			tabName = self:SpellName(-36171), -- Stage 2
			{ "stages", 1302982, 1286860--[[,1301117, 1290779, 1301213 ]] },
		},
		{
			tabName = self:SpellName(-36320), -- Intermission
			{ "stages", 1300530 },
		},
		{
			tabName = self:SpellName(-36323), -- Stage 3
			{ "stages", 1301510, 1300635, 1292188, 1300751, 1295905, 1298367, 1286860, 1286905 },
		},
		-- [1301117] = -36292, -- Doomscale Warden
		[1310738] = CL.mythic,
	}, {
		[1292999] = CL.stage1Only,
		[1300635] = CL.stage3Only,
	}
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	backupBars = {}
	if self:Mythic() then
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "MythicTimeline")
	elseif self:Heroic() then
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "HeroicTimeline")
	else
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "EasyTimeline")
	end
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
end

function mod:OnEncounterStart()
	activeBars = {}
	self:SetStage(1)
	self:SetPlayerSide()
	self:ResetCounts()
	checkStage = nil
	rageCount = 1

	self:RegisterUnitEvent("UNIT_TARGETABLE_CHANGED", nil, "boss1")
end

function mod:ResetCounts()
	durationEventCount = {}

	goreRattleCount = 1
	wavesCount = 1
	wrathCount = 1
	coilsCount = 1
	thrashCount = 1
	wombCount = 1
	incubationCount = 1

	spitCount = 1
	circlingPreyCount = 1
	callCount = 1
	submergeCount = 1
	biteCount = 1
end

function mod:SetPlayerSide()
	playerSide = nil
	L.custom_select_limit_warnings_icon = "misc_arrowlup"

	local num = self:GetOption("custom_select_limit_warnings")
	if num == 2 then -- left
		playerSide = "left"
		L.custom_select_limit_warnings_icon = "misc_arrowleft"
	elseif num == 3 then -- right
		playerSide = "right"
		L.custom_select_limit_warnings_icon = "misc_arrowright"
	elseif num ~= 1 then
		local raidIndex = UnitInRaid("player")
		if not raidIndex then return end

		if num == 4 then -- odds left, evens right
			local _, _, subgroup = GetRaidRosterInfo(raidIndex)
			if subgroup % 2 == 0 then
				playerSide = "right"
				L.custom_select_limit_warnings_icon = "misc_arrowright"
			else
				playerSide = "left"
				L.custom_select_limit_warnings_icon = "misc_arrowleft"
			end
		elseif num == 5 then -- 1/2/(3) left, (3)/4/5/6 right
			local _, _, subgroup = GetRaidRosterInfo(raidIndex)
			if subgroup == 1 or subgroup == 2 or (not self:Mythic() and subgroup == 3) then
				playerSide = "left"
				L.custom_select_limit_warnings_icon = "misc_arrowleft"
			else
				playerSide = "right"
				L.custom_select_limit_warnings_icon = "misc_arrowright"
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:MythicTimeline(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo = nil

	local stage = self:GetStage()
	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	if stage == 1 and rounded == 118 then -- Rage of the Shackled = Phase 2 (backup for UNIT_TARGETABLE_CHANGED)
		self:PhaseTwoStart(true)
		stage = 2

	elseif stage == 2 and rounded == 10 then -- Spectral Coils is the only bar in the intermission
		self:IntermissionStart()
		stage = 2.5

	elseif stage == 2.5 and checkStage then
		self:PhaseThreeStart()
		stage = 3
	end

	if stage == 1 or stage == 2 then
		if rounded == 20 or rounded == 90 then
			-- both are added on the pull, so the counts are out of order
			local count = goreRattleCount < 3 and (rounded == 90 and 2 or rounded == 20 and 1) or nil
			barInfo = self:GoreRattle(count)
		elseif rounded == 22 then
			barInfo = self:MothersWrath()
		elseif rounded == 33 or rounded == 94 then
			barInfo = self:SpectralCoilsMythic(duration)
		elseif rounded == 45 then
			barInfo = self:MephiticThrash()
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
		elseif rounded == 50 then
			barInfo = self:CausticWaves()
		elseif rounded == 69 then
			barInfo = self:ToxicIncubation()
			barInfo.ignoreState = true
			barInfo.duration = duration + 14 -- 83
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, barInfo.duration)
		elseif rounded == 77 then
			barInfo = self:SubmergeP1()
		elseif rounded == 139 or rounded == 118 then -- p1, p2
			barInfo = self:RageOfTheShackled()
		elseif rounded == 1 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			local count = durationEventCount[rounded]
			if count == 1 then
				barInfo = self:ToxicIncubation()
				barInfo.ignoreState = true
				barInfo.duration = duration + 14 -- 15
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, barInfo.duration)
			elseif count == 2 then
				local wombCD = duration + 2.1
				local wombBarInfo = self:ToxicWomb(wombCD)
				self:HandleBar(wombBarInfo, {duration = wombCD})
				wombBarInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(wombBarInfo, true) end, wombCD)

				barInfo = self:CallOfTheSerpent()
				barInfo.ignoreState = true
				barInfo.duration = duration + 3 -- 5
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, barInfo.duration)
			end
		elseif rounded == 57 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			local count = durationEventCount[rounded]
			if count == 1 then
				barInfo = self:MephiticThrash()
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			elseif count == 2 then
				barInfo = self:CausticWaves()
			end
		elseif rounded == 70 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			local count = durationEventCount[rounded]
			if count == 1 then
				local wombCD = duration + 1.3
				local wombBarInfo = self:ToxicWomb(wombCD)
				self:HandleBar(wombBarInfo, {duration = wombCD})
				wombBarInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(wombBarInfo, true) end, wombCD)

				barInfo = self:CallOfTheSerpent()
				barInfo.ignoreState = true
				barInfo.duration = duration -- + 3 -- 71
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, barInfo.duration)
			elseif count == 2 then
				barInfo = self:MothersWrath()
			end

	-- stage 2
		elseif rounded == 30 or rounded == 40 then
			barInfo = self:VirulentSpit(rounded)
		end

	-- intermission
	elseif stage == 2.5 then
		if rounded == 10 then
			barInfo = self:SpectralCoilsIntermissionMythic()
		end

	-- stage 3
	elseif stage == 3 then
		durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
		local count = durationEventCount[rounded]

		if count == 1 and (rounded == 235 or rounded == 205 or rounded == 67 or rounded == 60
			or rounded == 55 or rounded == 50 or rounded == 25 or rounded == 10 or rounded == 5)
		then
			return nil -- the whole opening set is added twice, the first is canceled

		elseif rounded == 235 then
			barInfo = self:FuryUnleashed()
		elseif rounded == 205 then
			barInfo = self:RageOfTheShackled()
		elseif rounded == 5 or rounded == 30 or rounded == 98 then
			if rounded == 5 then
				local wombCD = 57
				local wombBarInfo = self:ToxicWomb(wombCD)
				self:HandleBar(wombBarInfo, {duration = wombCD})
				wombBarInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(wombBarInfo, true) end, wombCD)
			end

			barInfo = self:CallOfTheSerpent()
			-- barInfo.ignoreState = true
			-- barInfo.duration = duration + 3 -- 5
			-- barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, barInfo.duration)
		elseif rounded == 10 or rounded == 85 or rounded == 68 then
			barInfo = self:MothersWrath()
		elseif rounded == 25 or rounded == 64 or rounded == 104 then
			barInfo = self:SerpentsBite()
		elseif rounded == 55 then
			if count == 2 then
				barInfo = self:ToxicIncubation()
				barInfo.ignoreState = true
				barInfo.duration = duration + 14 -- 15
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, barInfo.duration)
			elseif count == 3 then
				barInfo = self:CausticWaves()
			end
		elseif rounded == 50 or rounded == 44 then
			barInfo = self:CausticWaves()
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
		elseif rounded == 51 or rounded == 61 then
			barInfo = self:CirclingPrey(duration)
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
		elseif rounded == 67 or rounded == 53 then
			barInfo = self:SubmergeP3()
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)

		elseif rounded == 60 then
			if count == 2 then
				barInfo = self:CirclingPrey(duration)
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			elseif count == 3 then
				barInfo = self:SubmergeP3()
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			end
		end
	end

	return self:HandleBar(barInfo, eventInfo)
end

function mod:HeroicTimeline(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo = nil

	local stage = self:GetStage()
	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	if stage == 1 and rounded == 118 then -- Rage of the Shackled = Phase 2 (backup for UNIT_TARGETABLE_CHANGED)
		self:PhaseTwoStart(true)
		stage = 2

	elseif stage == 2 and rounded == 10 then -- Spectral Coils is the only bar in the intermission
		self:IntermissionStart()
		stage = 2.5

	elseif stage == 2.5 and checkStage then
		self:PhaseThreeStart()
		stage = 3
	end

	-- so many events cancel instead of finish x.x if they don't fix these I guess i'll move the timer to the handler
	if stage == 1 or stage == 2 then
		if rounded == 5 or rounded == 70 then
			local count = goreRattleCount < 3 and (rounded == 70 and 2 or rounded == 5 and 1) or nil
			barInfo = self:GoreRattle(count)
		elseif rounded == 10 or rounded == 37 or rounded == 67 then
			barInfo = self:MothersWrath()
		elseif rounded == 20 or rounded == 94 or rounded == 95 then
			barInfo = self:SpectralCoils(duration)
		elseif rounded == 35 then
			barInfo = self:MephiticThrash()
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
		elseif rounded == 42 then
			barInfo = self:CausticWaves()
		elseif rounded == 62 then
			barInfo = self:SubmergeP1()
		elseif rounded == 72 then
			barInfo = self:CallOfTheSerpent()
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
		elseif rounded == 129 or rounded == 118 then -- p1, p2
			barInfo = self:RageOfTheShackled()
		elseif rounded == 52 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			local count = durationEventCount[rounded]
			if count == 1 then
				barInfo = self:MephiticThrash()
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			elseif count == 2 then
				barInfo = self:CausticWaves()
			end

		-- stage 2
		elseif rounded == 30 or rounded == 40 then
			barInfo = self:VirulentSpit(rounded)
		end

	-- intermission
	elseif stage == 2.5 then
		if rounded == 10 then
			barInfo = self:SpectralCoilsIntermission()
		end

	-- stage 3
	else
		durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
		local count = durationEventCount[rounded]

		if (rounded == 235 or rounded == 205 or rounded == 67 or rounded == 60 or
			 rounded == 50 or rounded == 25 or rounded == 10 or rounded == 5) and count == 1
		then
			return nil -- the whole opening set is added twice, the first is canceled
		end

		if rounded == 235 then
			barInfo = self:FuryUnleashed()
		elseif rounded == 205 then
			barInfo = self:RageOfTheShackled()
		elseif rounded == 5 or rounded == 30 or rounded == 45 then
			barInfo = self:CallOfTheSerpent()
		elseif rounded == 10 or rounded == 75 or rounded == 76 then
			barInfo = self:MothersWrath()
		elseif rounded == 25 or rounded == 71 or rounded == 37 then
			barInfo = self:SerpentsBite()
		elseif rounded == 50 or rounded == 55 or rounded == 44 then
			barInfo = self:CausticWaves()
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
		elseif rounded == 51 or rounded == 61 or rounded == 52 then
			barInfo = self:CirclingPrey(duration)
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
		elseif rounded == 67 or rounded == 53 then
			barInfo = self:SubmergeP3()
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)

		elseif rounded == 60 then
			if count == 2 then
				barInfo = self:CirclingPrey(duration)
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			elseif count == 3 then
				barInfo = self:CallOfTheSerpent()
			elseif count == 4 then
				barInfo = self:SubmergeP3()
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			elseif count == 5 then
				barInfo = self:SerpentsBite()
			end
		end
	end

	self:HandleBar(barInfo, eventInfo)
end

function mod:EasyTimeline(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo = nil

	local stage = self:GetStage()
	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	if stage == 1 and rounded == 118 then -- Rage of the Shackled = Phase 2 (backup for UNIT_TARGETABLE_CHANGED)
		self:PhaseTwoStart(true)
		stage = 2

	elseif stage == 2 and rounded == 10 then -- Spectral Coils is the only bar in the intermission
		self:IntermissionStart()
		stage = 2.5

	elseif stage == 2.5 and checkStage then
		self:PhaseThreeStart()
		stage = 3
	end

	if stage == 1 or stage == 2 then
		if rounded == 42 then
			barInfo = self:CausticWaves()
		elseif rounded == 10 or rounded == 62 then
			barInfo = self:MothersWrath()
		elseif rounded == 20 or rounded == 84 then
			barInfo = self:SpectralCoils(duration)
		elseif rounded == 130 or rounded == 118 then
			barInfo = self:RageOfTheShackled()
		elseif rounded == 5 then
			barInfo = self:GoreRattle()
		elseif rounded == 62 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			local count = durationEventCount[rounded]
			if count == 1 then
				barInfo = self:MothersWrath()
			elseif count == 2 then
				barInfo = self:CallOfTheSerpent()
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			end
		elseif rounded == 35 or rounded == 41 then
			barInfo = self:MephiticThrash()
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)

		elseif rounded == 30 or rounded == 40 then
			barInfo = self:VirulentSpit()
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
		end

	-- intermission
	elseif stage == 2.5 then
		if rounded == 10 then
			barInfo = self:SpectralCoilsIntermission()
		end

	-- stage 3
	else
		durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
		local count = durationEventCount[rounded]

		if (rounded == 230 or rounded == 40 or rounded == 25 or rounded == 200 or
			 rounded == 10 or rounded == 57 or rounded == 5 or rounded == 50) and count == 1
		then
			return nil -- first bar is canceled
		end

		if rounded == 230 then
			barInfo = self:FuryUnleashed()
		elseif rounded == 60 then
			barInfo = self:CausticWaves()
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
		elseif rounded == 25 or rounded == 61 then
			barInfo = self:SerpentsBite()
		elseif rounded == 200 then
			barInfo = self:RageOfTheShackled()
		elseif rounded == 10 or rounded == 86 then
			barInfo = self:MothersWrath()
		elseif rounded == 57 then
			barInfo = self:SubmergeP3()
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
		elseif rounded == 5 or rounded == 63 then
			barInfo = self:CallOfTheSerpent()

		elseif rounded == 50 then
			if count == 2 then
				barInfo = self:CirclingPrey(duration)
			elseif count == 3 then
				barInfo = self:CausticWaves()
			end
			if barInfo then
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			end
		elseif rounded == 65 then
			if count == 1 then
				barInfo = self:CallOfTheSerpent()
			elseif count == 2 then
				barInfo = self:MothersWrath()
			end
		elseif rounded == 56 then
			if count == 1 then
				barInfo = self:CirclingPrey(duration)
			elseif count == 2 then
				barInfo = self:SubmergeP3()
			end
			if barInfo then
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			end
		elseif rounded == 40 then
			if count == 2 then
				barInfo = self:CausticWaves()
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			elseif count == 3 then
				barInfo = self:SerpentsBite()
			end
		elseif rounded == 66 then
			if count == 1 then
				barInfo = self:CirclingPrey(duration)
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			elseif count == 2 then
				barInfo = self:SubmergeP3()
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			elseif count == 3 then
				barInfo = self:SerpentsBite()
			end
		end
	end

	self:HandleBar(barInfo, eventInfo)
end

function mod:HandleBar(barInfo, eventInfo, noAfterBossError)
	local eventID = eventInfo and eventInfo.id or 0
	if barInfo then
		local duration = barInfo.duration or (eventInfo and eventInfo.duration)
		-- offset extends the duration and postpones the onFinished callback (ie, to correspond to the end of a cast instead of the start)
		local offset = barInfo.offset or 0
		if offset ~= 0 then
			if type(duration) == "table" then
				duration[1] = duration[1] + offset
			else
				duration = duration + offset
			end
		end
		local spellIndicators = eventID > 0 and eventID -- don't try to show indicators for fake events

		if self:ShouldShowBars() then
			self:CDBar(barInfo.key, duration, barInfo.msg, barInfo.icon, spellIndicators)
		end

		barInfo.eventID = eventID
		barInfo.state = 0
		if eventID ~= 0 then
			activeBars[eventID] = barInfo
		end

	elseif barInfo == nil and self:ShouldShowBars() then
		if not noAfterBossError then
			self:ErrorForTimelineEvent(eventInfo)
		end
		backupBars[eventID] = true
		self:SendMessage("BigWigs_StartBar", nil, nil, ("[B] %s"):format(eventInfo.spellName), eventInfo.duration, eventInfo.iconFileID, eventInfo.maxQueueDuration, nil, eventID, eventID)

		local state = C_EncounterTimeline.GetEventState(eventID)
		if state == 1 then -- Paused
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventID)
		end
	end
end

function mod:ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED(_, eventID)
	local state = C_EncounterTimeline.GetEventState(eventID)
	local barInfo = activeBars[eventID]
	if barInfo and not barInfo.ignoreState then
		if state == 2 then -- Finished
				if barInfo.offset then
					if barInfo.onOffset then
						barInfo:onOffset()
					end
					barInfo.offsetTimer = self:ScheduleTimer(function()
						self:StopTimelineBar(barInfo, true)
					end, barInfo.offset)
				else
					self:StopBar(barInfo.msg)
					if barInfo.onFinished and self:ShouldShowBars() then
						barInfo:onFinished()
					end
					barInfo.state = state
					activeBars[eventID] = nil
				end
		elseif state == 3 then -- Canceled
			self:StopBar(barInfo.msg)
			if barInfo.onCanceled and self:ShouldShowBars() then
				barInfo:onCanceled()
			end
			barInfo.state = state
			activeBars[eventID] = nil
		end
	elseif backupBars[eventID] then
		if state == 0 then -- Enum.EncounterTimelineEventState.Active
			self:SendMessage("BigWigs_ResumeBar", nil, nil, eventID)
		elseif state == 1 then -- Enum.EncounterTimelineEventState.Paused
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventID)
		elseif state == 2 or state == 3 then -- Enum.EncounterTimelineEventState.Finished / Enum.EncounterTimelineEventState.Canceled
			self:SendMessage("BigWigs_StopBar", nil, nil, eventID)
		end
	end
end

function mod:ENCOUNTER_TIMELINE_EVENT_REMOVED(_, eventID)
	activeBars[eventID] = nil
	backupBars[eventID] = nil
end

function mod:StopTimelineBar(barInfo, isFinished)
	if not barInfo then return end

	if isFinished and barInfo.offset and not barInfo.offsetTimer then
		if barInfo.onOffset then
			barInfo:onOffset()
		end
		barInfo.offsetTimer = self:ScheduleTimer(function()
			self:StopTimelineBar(barInfo, isFinished)
		end, barInfo.offset)

		barInfo.ignoreState = true -- don't get canceled
		return
	elseif not isFinished and barInfo.offsetTimer then
		self:CancelTimer(barInfo.offsetTimer)
		barInfo.offsetTimer = nil
	end

	self:StopBar(barInfo.msg)
	if isFinished and barInfo.onFinished and (not barInfo.state or barInfo.state < 2) and self:ShouldShowBars() and not self:IsWiping() then
		barInfo:onFinished()
	end
	barInfo.state = isFinished and 2 or 3 -- Finished/Canceled
	if barInfo.eventID then
		activeBars[barInfo.eventID] = nil
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_TARGETABLE_CHANGED(_, unit)
	if checkStage and not UnitCanAttack("player", unit) and not self:IsWiping() then
		self:PhaseTwoStart()
	end
end

function mod:PhaseTwoStart(isTimelineEvent)
	self:UnregisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	self:UnregisterUnitEvent("UNIT_TARGETABLE_CHANGED", "boss1")
	checkStage = false

	self:SetStage(2)
	self:ResetCounts()

	if self:ShouldShowBars() then
		self:Message("stages", "cyan", CL.stage:format(2), false)
		self:PlaySound("stages", "long")

		local barrierCD = isTimelineEvent and 4.1 or 8.1
		self:Bar("stages", barrierCD, self:GetRename("stages", 4), 1313355) -- 1313355 = Doomscale Cauldron
	end
end

function mod:IntermissionStart()
	self:SetStage(2.5)
	self:ResetCounts()

	if self:ShouldShowBars() then
		self:Message("stages", "cyan", self:GetRename("stages", 1), false) -- Intermission
		self:PlaySound("stages", "long")

		self:Bar("stages", 44.3, self:GetRename("stages", 5), "spell_fire_felhellfire") -- Knockup
		self:Bar("stages", 53, self:GetRename("stages", 3), "inv_offhand_1h_ulatek_d_01") -- Stage 3
	end
end

function mod:PhaseThreeStart()
	self:SetStage(3)
	self:ResetCounts()
	checkStage = false

	if self:ShouldShowBars() then
		self:Message("stages", "cyan", self:GetRename("stages", 3), false)
		self:PlaySound("stages", "long")
	end
end

--------------------------------------------------------------------------------
-- Bar Event Handlers
--

-- Stage One: Fury of the Serpent Mother

function mod:CausticWaves()
	local barText = CL.count:format(self:GetRename(1292188), wavesCount)
	wavesCount = wavesCount + 1
	return {
		msg = barText,
		key = 1292188,
		onFinished = function()
			self:StopBlizzMessages(1) -- Ula'tek prepares a surge of [Caustic Waves]!
			self:Message(1292188, "red", barText)
			self:PlaySound(1292188, "warning")
		end,
	}
end

function mod:CallOfTheSerpent()
	local barText = CL.count:format(self:GetRename(1300751), callCount)
	callCount = callCount + 1
	return {
		msg = barText,
		key = 1300751,
		onFinished = function()
			self:Message(1300751, "yellow", barText)
			self:PlaySound(1300751, "alarm")
		end,
	}
end

function mod:MothersWrath()
	local barText = CL.count:format(self:GetRename(1298367), wrathCount)
	wrathCount = wrathCount + 1
	return {
		msg = barText,
		key = 1298367,
		onFinished = function()
			self:Message(1298367, "purple", barText)
			self:PlaySound(1298367, "alert")
		end,
	}
end

function mod:GoreRattle(count)
	local barText = self:GetRename(1298559)
	if not self:Easy() then
		barText = CL.count:format(barText, count or goreRattleCount)
	end
	goreRattleCount = goreRattleCount + 1
	return {
		msg = barText,
		key = 1298559,
		onFinished = function()
			self:Message(1298559, "cyan", barText)
			self:PlaySound(1298559, "info")
		end,
	}
end

function mod:MephiticThrash()
	local barText = CL.count:format(self:GetRename(1296301), thrashCount)
	thrashCount = thrashCount + 1
	return {
		msg = barText,
		key = 1296301,
		onFinished = function()
			self:Message(1296301, "yellow", barText)
			self:CastBar(1296301, 4, 2)
			self:PlaySound(1296301, "alarm")
		end,
	}
end

function mod:SpectralCoils(duration)
	local barText = CL.count:format(self:GetRename(1300530), coilsCount)
	local messageText = CL.soon:format(barText)
	coilsCount = coilsCount + 1

	local barInfo = {
		msg = barText,
		key = 1300530,
		onFinished = function()
			self:StopBlizzMessages(1) -- The temple shudders as [Spectral Coils] erupt from the venom!
			self:Message(1300530, "orange", messageText)
			self:PlaySound(1300530, "alert")

			self:Bar(1300530,  7.3, L.count_amount_side:format(self:GetRename(1300530), 1, 2, self:GetRename(1300530, 3))) -- right
			self:Bar(1300530, 10.5, L.count_amount_side:format(self:GetRename(1300530), 2, 2, self:GetRename(1300530, 2))) -- left
		end,
	}
	barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
	return barInfo
end

function mod:SpectralCoilsMythic(duration)
	local barText = CL.count:format(self:GetRename(1300530), coilsCount)
	local messageText = CL.soon:format(barText)

	local showOtherSide = not playerSide
	local offset = nil
	if playerSide == "right" then
		offset = 7.6
		barText = L.count_side:format(self:GetRename(1300530), coilsCount, self:GetRename(1300530, 3))
		if showOtherSide then
			self:Bar(1300530, duration + 10.9, L.count_side:format(self:GetRename(1300530), coilsCount, self:GetRename(1300530, 2)))
		end
	elseif playerSide == "left" then
		offset = 10.9
		barText = L.count_side:format(self:GetRename(1300530), coilsCount, self:GetRename(1300530, 2))
		if showOtherSide then
			self:Bar(1300530, duration + 7.6, L.count_side:format(self:GetRename(1300530), coilsCount, self:GetRename(1300530, 3)))
		end
	end
	coilsCount = coilsCount + 1

	local barInfo = {
		msg = barText,
		key = 1300530,
		offset = offset,
		onOffset = function()
			self:StopBlizzMessages(1) -- The temple shudders as [Spectral Coils] erupt from the venom!
			self:Message(1300530, "orange", messageText)
			self:PlaySound(1300530, "alert")
		end,
	}
	barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
	return barInfo
end

function mod:SubmergeP1()
	local barText = CL.count:format(self:GetRename(1292999), submergeCount)
	submergeCount = submergeCount + 1
	return {
		msg = barText,
		key = 1292999,
	}
end

function mod:RageOfTheShackled()
	local barText = CL.count:format(self:GetRename(1286860), rageCount)
	rageCount = rageCount + 1
	return {
		msg = barText,
		key = 1286860,
		offset = 6.5, -- 6.5s for cast
		onFinished = function()
			self:Message(1286860, "green", barText)
			self:PlaySound(1286860, "long")
			self:CastBar(1286860, 20, self:GetRename(1286860, 2))
			self:ScheduleTimer(function()
				if not self:IsWiping() then
					self:Message(1286860, "green", self:GetRename(1286860, 3))
					self:PlaySound(1286860, "info")
				end
			end, 20)
			if self:GetStage() == 1 then
				checkStage = true
			end
		end,
	}
end

-- Mythic

function mod:ToxicWomb(duration)
	local barText = CL.count:format(self:GetRename(1310738), wombCount)
	wombCount = wombCount + 1
	return {
		msg = barText,
		key = 1310738,
		onFinished = function()
			-- local wretchesAlive = wretchesAlive + 1
			self:Message(1310738, "cyan", barText)
			self:PlaySound(1310738, "info")
		end,
	}
end

function mod:FesterBurst(wretchCount, count)
	local barText = L.fester_burst_count:format(self:GetRename(1310763), wretchCount, count)
	return {
		msg = barText,
		key = 1310763,
		onFinished = function()
			self:Message(1310763, "green", barText)
			self:PlaySound(1310763, "info")
		end,
	}
end

function mod:ToxicIncubation()
	local barText = CL.count:format(self:GetRename(1299757), incubationCount)
	incubationCount = incubationCount + 1
	return {
		msg = barText,
		key = 1299757,
		onFinished = function()
			self:Message(1299757, "purple", barText)
			self:PlaySound(1299757, "alarm")
		end,
	}
end

-- Stage Two: Children of the Doomscale

function mod:VirulentSpit(duration, count)
	local barText, offset
	if not duration then
		barText = CL.count:format(self:GetRename(1302982), spitCount)
	else
		if duration == 30 then
			barText = CL.count:format(self:GetRename(1302982), 1)
			offset = 3.5
			count = 1
		elseif duration == 40 then
			barText = CL.count:format(self:GetRename(1302982), 3)
			offset = 3.5
			count = 3
		else
			barText = CL.count:format(self:GetRename(1302982), count)
		end
	end
	spitCount = spitCount + 1

	local barInfo = {
		msg = barText,
		key = 1302982,
		offset = offset,
		count = count,
		onFinished = function(this)
			self:Message(1302982, "yellow", barText)
			self:PlaySound(1302982, "alarm")
			if this.count == 1 or this.count == 3 then
				self:HandleBar(self:VirulentSpit(20, this.count + 1), { duration = 20 })
			end
		end,
	}
	if duration then
		self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
	end

	return barInfo
end

-- Intermission

function mod:SpectralCoilsIntermission()
	local barText = CL.count:format(self:GetRename(1300530), coilsCount)
	coilsCount = coilsCount + 1
	return {
		msg = barText,
		key = 1300530,
		onFinished = function()
			self:StopBlizzMessages(1) -- The temple shudders as [Spectral Coils] erupt from the venom!
			self:Message(1300530, "orange", barText)
			self:PlaySound(1300530, "alert")

			checkStage = true

			local name = self:GetRename(1300530)
			if self:Heroic() then
				-- red = right, blue = left
				if playerSide == "left" or not playerSide then
					self:Bar(1300530, 7.3, L.count_amount_side:format(name, 1, 3, self:GetRename(1300530, 2)))
					self:Bar(1300530, 14.5, L.count_amount_side:format(name, 2, 3, self:GetRename(1300530, 2)))
					self:Bar(1300530, 21.8, L.count_amount_side:format(name, 3, 3, self:GetRename(1300530, 2)))
				end
				if playerSide == "right" or not playerSide then
					self:Bar(1300530, 10.4, L.count_amount_side:format(name, 1, 3, self:GetRename(1300530, 3)))
					self:Bar(1300530, 17.4, L.count_amount_side:format(name, 2, 3, self:GetRename(1300530, 3)))
					self:Bar(1300530, 25.0, L.count_amount_side:format(name, 3, 3, self:GetRename(1300530, 3)))
				end
			elseif self:Normal() then
				self:Bar(1300530, 7.3, CL.count_amount:format(name, 1, 3))
				self:Bar(1300530, 17.4, CL.count_amount:format(name, 2, 3))
				self:Bar(1300530, 25.5, CL.count_amount:format(name, 3, 3))
			end
		end,
	}
end

function mod:SpectralCoilsIntermissionMythic(duration)
	local barText = self:GetRename(1300530)
	return {
		msg = barText,
		key = 1300530,
		onFinished = function()
			self:StopBlizzMessages(1) -- The temple shudders as [Spectral Coils] erupt from the venom!
			self:Message(1300530, "orange", barText)
			self:PlaySound(1300530, "alert")

			checkStage = true
		end,
	}
end

-- Stage Three: Ula'tek's Ascension

function mod:CirclingPrey(duration)
	local barText = CL.count:format(self:GetRename(1301510), circlingPreyCount)
	circlingPreyCount = circlingPreyCount + 1
	return {
		msg = barText,
		key = 1301510,
		-- offset = 8, -- 8s for cast
		onFinished = function()
			self:Message(1301510, "red", CL.casting:format(barText))
			self:CastBar(1301510, 8, 2)
			self:PlaySound(1301510, "long")
		end,
	}
end

function mod:SubmergeP3()
	local barText = CL.count:format(self:GetRename(1300635), submergeCount)
	submergeCount = submergeCount + 1
	return {
		msg = barText,
		key = 1300635,
	}
end

function mod:SerpentsBite()
	local barText = CL.count:format(self:GetRename(1295905), biteCount)
	biteCount = biteCount + 1
	return {
		msg = barText,
		key = 1295905,
		onFinished = function()
			self:Message(1295905, "orange", barText)
			self:PlaySound(1295905, "alert")
		end,
	}
end

function mod:FuryUnleashed()
	local barText = self:GetRename(1286905)
	return {
		msg = barText,
		key = 1286905,
		onFinished = function()
			self:Message(1286905, "red", barText)
			self:PlaySound(1286905, "alarm")
		end,
	}
end
