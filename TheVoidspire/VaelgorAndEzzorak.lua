
-- TODO:
-- Look at breath 3/4 around 1min into the encounter, any ways to cover blizzard?

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vaelgor & Ezzorak", 2912, 2735)
if not mod then return end
mod:RegisterEnableMob(242056, 244552) -- Vaelgor, Ezzorak
mod:SetEncounterID(3178)
mod:SetRespawnTime(30)
mod:SetStage(1)
mod:SetPrivateAuraSounds({
	{1262656, 1262676, 1262999, sound = "alarm"}, -- Nullbeam
	{1244672, sound = "underyou"}, -- Nullzone
	{1252157, sound = "alert"}, -- Nullzone Implosion
	1255612, -- Dread Breath (Targetted)
	{1264467, sound = "underyou"}, -- Tail Lash
	{1245554, sound = "alert"},-- Gloomtouched
	{1270852, sound = "none"}, -- Diminish
	{1245421, sound = "underyou"}, -- Gloomfield
	{1245059, sound = "alarm"}, -- Void Howl
	{1245175, sound = "none"}, -- Voidbolt
	-- {1280355, sound = "none"}, -- Rakfang
	1265152, -- Impale
	{1248865, 1249595, sound = "info"}, -- Radiant Barrier
	1270497, -- Shadowmark
})
mod:UseCustomTimers(true)

--------------------------------------------------------------------------------
-- Locals
--

local timelineEventCount = 0
local activeBars = {}
local backupBars = {}
local countForDuration = {}
local lastStaged = 0
local nextRadiantBarrier = 0

local midnightFlamesCount = 1
local nullbeamCount = 1
local dreadBreathCount = 1
local vaelwingCount = 1
local gloomCount = 1
local voidHowlCount = 1
local rakfangCount = 1
local radiantBarrierCount = 1
local grapplingMawCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.grappling_maw = "Tank Grip"
end

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		"stages",
		1249748, -- Midnight Flames
		{1280458, "TANK"}, -- Grappling Maw
		-- Vaelgor
		1262623, -- Nullbeam
		1244221, -- Dread Breath
		{1265131, "TANK"}, -- Vaelwing
		-- Ezzorak
		1245391, -- Gloom
		1244917, -- Void Howl
		{1245645, "TANK"}, -- Rakfang
	},{
		["stages"] = "general",
		[1262623] = -33241, -- Vaelgor
		[1245391] = -33255, -- Ezzorak
	},{
		[1249748] = CL.raid_damage,
		[1244221] = CL.breath,
		[1244917] = CL.orbs,
	}
end

function mod:OnBossEnable()
	backupBars = {}
	if self:Mythic() then
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "TimersMythic")
	elseif self:Heroic() then
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "TimersHeroic")
	else
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "TimerOther")
	end
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
end

function mod:OnEncounterStart()
	self:SetStage(1)
	countForDuration = {}
	timelineEventCount = 0
	activeBars = {}

	midnightFlamesCount = 1
	nullbeamCount = 1
	dreadBreathCount = 1
	vaelwingCount = 1
	gloomCount = 1
	voidHowlCount = 1
	rakfangCount = 1
	radiantBarrierCount = 1
	grapplingMawCount = 1
end

function mod:OnBossDisable()
	for eventID in next, backupBars do
		self:SendMessage("BigWigs_StopBar", nil, nil, eventID)
	end
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

local nextBarrierBuffer = 8
-- Allowing a custom buffer so it can be tweaked per ability.
function mod:IsBeforeRadiantBarrier(duration, customBuffer)
	local buffer = customBuffer or nextBarrierBuffer
	if (GetTime() + duration) > (nextRadiantBarrier + buffer) then -- Don't show timers which won't happen, small buffer incase of a delay
		return false
	end
	return true
end

function mod:TimersMythic(_, eventInfo)
	if eventInfo.source ~= 0 then return end
	timelineEventCount = timelineEventCount + 1
	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 0)
	eventInfo.durationRounded = durationRounded
	local barInfo
	local stage = self:GetStage()

	if stage % 1 == 0 and durationRounded == 8 then -- Midnight Flames Cast and in an stage 1
		stage = stage + 0.5
		self:SetStage(stage)
		if self:ShouldShowBars() then
			self:Message("stages", "cyan", CL.intermission, false) -- Blizzard Radiant Barrier Message
			self:PlaySound("stages", "long")
			self:Bar("stages", 40, CL.stage:format(stage + 0.5), 1249748)
			self:StopBlizzMessages(1) -- Radiant Barrier Message
		end
	elseif stage % 1 == 0.5 then
		stage = stage + 0.5
		self:SetStage(stage)
		if self:ShouldShowBars() then
			self:Message("stages", "cyan", CL.stage:format(stage), false)
			self:PlaySound("stages", "long")
		end
		timelineEventCount = 1
		countForDuration = {}

		nullbeamCount = 1
		dreadBreathCount = 1
		vaelwingCount = 1
		gloomCount = 1
		voidHowlCount = 1
		rakfangCount = 1
	end

	if timelineEventCount <= 7 then -- Initial timers
		if stage == 1 then -- Initial Pull Timers
			if durationRounded == 6 then -- Vaelwing
				barInfo = self:Vaelwing(eventInfo)
			elseif durationRounded == 11 then -- Rakfang
				barInfo = self:Rakfang(eventInfo)
			elseif durationRounded == 12 then -- Dread Breath
				barInfo = self:DreadBreath(eventInfo)
			elseif durationRounded == 15 then -- Nullbeam
				barInfo = self:Nullbeam(eventInfo)
			elseif durationRounded == 25 then -- Void Howl
				barInfo = self:VoidHowl(eventInfo)
			elseif durationRounded == 40 then -- Gloom
				barInfo = self:Gloom(eventInfo)
			elseif durationRounded == 120 then -- Radiant Barrier
				barInfo = self:RadiantBarrier(eventInfo)
			end
		elseif stage == 2 then -- Round 2
			if durationRounded == 19 then -- Vaelwing
				barInfo = self:Vaelwing(eventInfo)
			elseif durationRounded == 23 then -- Nullbeam
				barInfo = self:Nullbeam(eventInfo)
			elseif durationRounded == 34 then -- Dread Breath
				barInfo = self:DreadBreath(eventInfo)
			elseif durationRounded == 25 then -- Rakfang
				barInfo = self:Rakfang(eventInfo)
			elseif durationRounded == 28 then -- Gloom
				barInfo = self:Gloom(eventInfo)
			elseif durationRounded == 48 then -- Void Howl
				barInfo = self:VoidHowl(eventInfo)
			elseif durationRounded == 128 then -- Radiant Barrier
				barInfo = self:RadiantBarrier(eventInfo)
			end
		elseif stage == 3 then -- Round 3
			if durationRounded == 21 then -- Vaelwing
				barInfo = self:Vaelwing(eventInfo)
			elseif durationRounded == 20 then -- Nullbeam
				barInfo = self:Nullbeam(eventInfo)
			elseif durationRounded == 46 then -- Dread Breath
				barInfo = self:DreadBreath(eventInfo)
			elseif durationRounded == 27 then -- Rakfang
				barInfo = self:Rakfang(eventInfo)
			elseif durationRounded == 55 then -- Gloom
				barInfo = self:Gloom(eventInfo)
			elseif durationRounded == 15 then -- Void Howl
				barInfo = self:VoidHowl(eventInfo)
			elseif durationRounded == 125 then -- Radiant Barrier
				barInfo = self:RadiantBarrier(eventInfo)
			end
		end
	else
		if durationRounded == 45 then -- Dread Breath
			if not self:IsBeforeRadiantBarrier(eventInfo.duration, 10) then return end -- Debuff is may be applied well before the timer ends
			barInfo = self:DreadBreath(eventInfo)
		elseif durationRounded == 25 then -- Vaelwing > Rakfang
			if not self:IsBeforeRadiantBarrier(eventInfo.duration) then return end
			countForDuration[duration] = (countForDuration[duration] or 0) + 1
			if countForDuration[duration] % 2 == 0 then
				barInfo = self:Rakfang(eventInfo)
			else
				barInfo = self:Vaelwing(eventInfo)
			end
		elseif durationRounded == 45 then -- Dread Breath or Void Howl
			countForDuration[duration] = (countForDuration[duration] or 0) + 1
			local breathMod = stage == 3 and 0 or 1 -- Alternate rotation in 3rd stage 1
			if countForDuration[duration] % 2 == breathMod then
				if not self:IsBeforeRadiantBarrier(eventInfo.duration, 10) then return end -- Debuff is may be applied well before the timer ends
				barInfo = self:DreadBreath(eventInfo)
			else
				if not self:IsBeforeRadiantBarrier(eventInfo.duration) then return end
				barInfo = self:VoidHowl(eventInfo)
			end
		elseif durationRounded == 50 then -- Gloom
			if not self:IsBeforeRadiantBarrier(eventInfo.duration) then return end
			barInfo = self:Gloom(eventInfo)
		elseif durationRounded == 60 then -- Nullbeam
			if not self:IsBeforeRadiantBarrier(eventInfo.duration) then return end
			barInfo = self:Nullbeam(eventInfo)
		elseif durationRounded == 8 then -- Midnight Flames
			barInfo = self:MidnightFlames(eventInfo)
		end
	end

	if barInfo then
		activeBars[eventInfo.id] = barInfo
	elseif self:ShouldShowBars() and not self:IsWiping() then
		self:ErrorForTimelineEvent(eventInfo)
		backupBars[eventInfo.id] = true
		self:SendMessage("BigWigs_StartBar", nil, nil, ("[B] %s"):format(eventInfo.spellName), eventInfo.duration, eventInfo.iconFileID, eventInfo.maxQueueDuration, nil, eventInfo.id, eventInfo.id)

		local state = C_EncounterTimeline.GetEventState(eventInfo.id)
		if state == 1 then -- Enum.EncounterTimelineEventState.Paused = 1
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventInfo.id)
		end
	end
end

function mod:TimersHeroic(_, eventInfo)
	if eventInfo.source ~= 0 then return end
	timelineEventCount = timelineEventCount + 1
	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 0)
	eventInfo.durationRounded = durationRounded
	local barInfo
	local stage = self:GetStage()
	local time = GetTime()

	if stage % 1 == 0 and durationRounded == 8 and time - 5 > lastStaged then -- Midnight Flames Cast
		stage = stage + 0.5
		self:SetStage(stage)
		lastStaged = time
		if self:ShouldShowBars() then
			self:Message("stages", "cyan", CL.intermission, false)
			self:PlaySound("stages", "long")
			self:Bar("stages", 25, CL.stage:format(stage + 0.5), 1249748)
			self:StopBlizzMessages(1) -- Radiant Barrier Message
		end
	elseif stage % 1 == 0.5 and time - 5 > lastStaged then
		stage = stage + 0.5
		self:SetStage(stage)
		lastStaged = time
		if self:ShouldShowBars() then
			self:Message("stages", "cyan", CL.stage:format(stage), false)
			self:PlaySound("stages", "long")
		end
		timelineEventCount = 1
		countForDuration = {}

		nullbeamCount = 1
		dreadBreathCount = 1
		vaelwingCount = 1
		gloomCount = 1
		voidHowlCount = 1
		rakfangCount = 1
		grapplingMawCount = 1
	end

	local initialTimers = stage == 3 and 7 or 8
	if timelineEventCount <= initialTimers then -- Initial timers
		if stage == 1 then -- Initial Pull Timers
			if durationRounded == 6 then -- Vaelwing
				barInfo = self:Vaelwing(eventInfo)
			elseif durationRounded == 12 then -- Rakfang
				barInfo = self:Rakfang(eventInfo)
			elseif durationRounded == 27 then -- Dread Breath
				barInfo = self:DreadBreath(eventInfo)
			elseif durationRounded == 10 then -- Nullbeam
				barInfo = self:Nullbeam(eventInfo)
			elseif durationRounded == 30 and not self:IsWiping() then -- Void Howl
				barInfo = self:VoidHowl(eventInfo)
			elseif durationRounded == 18 then -- Grappling Maw
				barInfo = self:GrapplingMaw(eventInfo)
			elseif durationRounded == 50 then -- Gloom
				barInfo = self:Gloom(eventInfo)
			elseif durationRounded == 105 then -- Radiant Barrier
				barInfo = self:RadiantBarrier(eventInfo)
			end
		elseif stage == 2 then -- Round 2
			if durationRounded == 18 then -- Grappling Maw
				barInfo = self:GrapplingMaw(eventInfo)
			elseif durationRounded == 45 then -- Nullbeam
				barInfo = self:Nullbeam(eventInfo)
			elseif durationRounded == 27 then -- Dread Breath
				barInfo = self:DreadBreath(eventInfo)
			elseif durationRounded == 6 then -- Rakfang
				barInfo = self:Rakfang(eventInfo)
			elseif durationRounded == 12 then -- Vaelwing
				barInfo = self:Vaelwing(eventInfo)
			elseif durationRounded == 10 then -- Gloom
				barInfo = self:Gloom(eventInfo)
			elseif durationRounded == 15 then -- Void Howl
				barInfo = self:VoidHowl(eventInfo)
			elseif durationRounded == 105 then -- Radiant Barrier
				barInfo = self:RadiantBarrier(eventInfo)
			end
		elseif stage >= 3 then -- Round 3+
			if durationRounded == 8 then -- Vaelwing
				barInfo = self:Vaelwing(eventInfo)
			elseif durationRounded == 13 then -- Nullbeam
				barInfo = self:Nullbeam(eventInfo)
			elseif durationRounded == 65 then -- Dread Breath
				barInfo = self:DreadBreath(eventInfo)
			elseif durationRounded == 15 then -- Rakfang
				barInfo = self:Rakfang(eventInfo)
			elseif durationRounded == 50 then -- Gloom
				barInfo = self:Gloom(eventInfo)
			elseif durationRounded == 25 then -- Void Howl
				barInfo = self:VoidHowl(eventInfo)
			elseif durationRounded == 225 then -- Radiant Barrier
				barInfo = self:RadiantBarrier(eventInfo)
			end
		end
	else
		countForDuration[duration] = (countForDuration[duration] or 0) + 1
		if durationRounded == 20 or durationRounded == 81 or durationRounded == 16 or durationRounded == 76 then -- Dread Breath
			if not self:IsBeforeRadiantBarrier(eventInfo.duration, 10) then return end -- Debuff is may be applied well before the timer ends\
			barInfo = self:DreadBreath(eventInfo)
		elseif durationRounded == 25 or durationRounded == 24 or durationRounded == 23 then -- 3/24/26: added 24 since timers seem differentl now?
			if not self:IsBeforeRadiantBarrier(eventInfo.duration) then return end
			local count = (countForDuration[25] or 0) + (countForDuration[24] or 0) + (countForDuration[23] or 0) -- combine these until we can safely split them again
			if stage == 1 then -- Vaelwing, Rakfang, Grappling Maw
				if count % 3 == 1 then
					barInfo = self:Vaelwing(eventInfo)
				elseif count % 3 == 2 then
					barInfo = self:Rakfang(eventInfo)
				else
					barInfo = self:GrapplingMaw(eventInfo)
				end
			elseif stage == 2 then -- Rakfang, Vaelwing, Void Howl, Grapping Maw
				if count % 4 == 1 then
					barInfo = self:Rakfang(eventInfo)
				elseif count % 4 == 2 then
					barInfo = self:Vaelwing(eventInfo)
				elseif count % 4 == 3 then
					barInfo = self:VoidHowl(eventInfo)
				else
					barInfo = self:GrapplingMaw(eventInfo)
				end
			end
		elseif durationRounded == 30 and not self:IsWiping() then -- Grapplin Maw
			if not self:IsBeforeRadiantBarrier(eventInfo.duration) then return end
			barInfo = self:GrapplingMaw(eventInfo)
		elseif durationRounded == 31 then -- Vaelwing, Rakfang
			if countForDuration[duration] % 2 == 1 then
				barInfo = self:Vaelwing(eventInfo)
			else
				barInfo = self:Rakfang(eventInfo)
			end
		elseif durationRounded == 45 or durationRounded == 51 or durationRounded == 46 then -- Void Howl
			if not self:IsBeforeRadiantBarrier(eventInfo.duration) then return end
			barInfo = self:VoidHowl(eventInfo)
		elseif durationRounded == 50 or durationRounded == 49 then -- Nullbeam, Dread Breath, Gloom
			local count = (countForDuration[50] or 0) + (countForDuration[49] or 0)
			if stage == 1 then
				if not self:IsBeforeRadiantBarrier(eventInfo.duration) then return end
				barInfo = self:Nullbeam(eventInfo)
			elseif stage == 2 then
				if count % 2 == 1 then
					if not self:IsBeforeRadiantBarrier(eventInfo.duration) then return end
					barInfo = self:Gloom(eventInfo)
				else
					if not self:IsBeforeRadiantBarrier(eventInfo.duration, 10) then return end -- Debuff is may be applied well before the timer ends
					barInfo = self:DreadBreath(eventInfo)
				end
			end
		elseif durationRounded == 63 or durationRounded == 62 or durationRounded == 61 then -- Nullbeam, Gloom
			if not self:IsBeforeRadiantBarrier(eventInfo.duration) then return end
			local count = (countForDuration[63] or 0) + (countForDuration[62] or 0) + (countForDuration[61] or 0)
			if count % 2 == 1 then
				barInfo = self:Nullbeam(eventInfo)
			else
				barInfo = self:Gloom(eventInfo)
			end
		elseif durationRounded == 90 or durationRounded == 85 then -- Nullbeam, Gloom
			if not self:IsBeforeRadiantBarrier(eventInfo.duration) then return end
			if stage == 1 then
				barInfo = self:Gloom(eventInfo)
			elseif stage == 2 then
				barInfo = self:Nullbeam(eventInfo)
			end
		elseif durationRounded == 8 then -- Midnight Flames
			barInfo = self:MidnightFlames(eventInfo)
		end
	end

	if barInfo then
		activeBars[eventInfo.id] = barInfo
	elseif self:ShouldShowBars() and not self:IsWiping() then
		self:ErrorForTimelineEvent(eventInfo)
		backupBars[eventInfo.id] = true
		self:SendMessage("BigWigs_StartBar", nil, nil, ("[B] %s"):format(eventInfo.spellName), eventInfo.duration, eventInfo.iconFileID, eventInfo.maxQueueDuration, nil, eventInfo.id, eventInfo.id)

		local state = C_EncounterTimeline.GetEventState(eventInfo.id)
		if state == 1 then -- Enum.EncounterTimelineEventState.Paused = 1
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventInfo.id)
		end
	end
end

function mod:TimerOther(_, eventInfo)
	if eventInfo.source ~= 0 then return end
	timelineEventCount = timelineEventCount + 1
	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 0)
	eventInfo.durationRounded = durationRounded
	local barInfo
	local stage = self:GetStage()
	local time = GetTime()

	if stage % 1 == 0 and durationRounded == 8 and time - 5 > lastStaged then -- Midnight Flames Cast
		stage = stage + 0.5
		self:SetStage(stage)
		lastStaged = time
		if self:ShouldShowBars() then
			self:Message("stages", "cyan", CL.intermission, false)
			self:PlaySound("stages", "long")
			self:Bar("stages", 26.5, CL.stage:format(stage + 0.5), 1249748)
			self:StopBlizzMessages(1) -- Radiant Barrier Message
		end
	elseif stage % 1 == 0.5 and time - 5 > lastStaged then
		stage = stage + 0.5
		self:SetStage(stage)
		lastStaged = time
		if self:ShouldShowBars() then
			self:Message("stages", "cyan", CL.stage:format(stage), false)
			self:PlaySound("stages", "long")
		end
		timelineEventCount = 1
		countForDuration = {}

		nullbeamCount = 1
		dreadBreathCount = 1
		vaelwingCount = 1
		gloomCount = 1
		voidHowlCount = 1
		rakfangCount = 1
		grapplingMawCount = 1
	end

	local initialTimers = stage == 3 and 7 or 8
	if timelineEventCount <= initialTimers then -- Initial timers
		if stage == 1 then -- Initial Pull Timers
			if durationRounded == 6 then -- Vaelwing
				barInfo = self:Vaelwing(eventInfo)
			elseif durationRounded == 13 then -- Rakfang
				barInfo = self:Rakfang(eventInfo)
			elseif durationRounded == 28 then -- Dread Breath
				barInfo = self:DreadBreath(eventInfo)
			elseif durationRounded == 11 then -- Nullbeam
				barInfo = self:Nullbeam(eventInfo)
			elseif durationRounded == 32 then -- Void Howl
				barInfo = self:VoidHowl(eventInfo)
			elseif durationRounded == 19 then -- Grappling Maw
				barInfo = self:GrapplingMaw(eventInfo)
			elseif durationRounded == 53 then -- Gloom
				barInfo = self:Gloom(eventInfo)
			elseif durationRounded == 111 then -- Radiant Barrier
				barInfo = self:RadiantBarrier(eventInfo)
			end
		elseif stage == 2 then -- Round 2
			if durationRounded == 19 then -- Grappling Maw
				barInfo = self:GrapplingMaw(eventInfo)
			elseif durationRounded == 47 then -- Nullbeam
				barInfo = self:Nullbeam(eventInfo)
			elseif durationRounded == 28 then -- Dread Breath
				barInfo = self:DreadBreath(eventInfo)
			elseif durationRounded == 6 then -- Rakfang
				barInfo = self:Rakfang(eventInfo)
			elseif durationRounded == 13 then -- Vaelwing
				barInfo = self:Vaelwing(eventInfo)
			elseif durationRounded == 11 then -- Gloom
				barInfo = self:Gloom(eventInfo)
			elseif durationRounded == 16 then -- Void Howl
				barInfo = self:VoidHowl(eventInfo)
			elseif durationRounded == 111 then -- Radiant Barrier
				barInfo = self:RadiantBarrier(eventInfo)
			end
		elseif stage >= 3 then -- Round 3+
			if durationRounded == 8 then -- Vaelwing
				barInfo = self:Vaelwing(eventInfo)
			elseif durationRounded == 13 then -- Nullbeam
				barInfo = self:Nullbeam(eventInfo)
			elseif durationRounded == 65 then -- Dread Breath
				barInfo = self:DreadBreath(eventInfo)
			elseif durationRounded == 15 then -- Rakfang
				barInfo = self:Rakfang(eventInfo)
			elseif durationRounded == 50 then -- Gloom
				barInfo = self:Gloom(eventInfo)
			elseif durationRounded == 25 then -- Void Howl
				barInfo = self:VoidHowl(eventInfo)
			elseif durationRounded == 225 then -- Radiant Barrier
				barInfo = self:RadiantBarrier(eventInfo)
			end
		end
	else
		countForDuration[duration] = (countForDuration[duration] or 0) + 1
		if durationRounded == 21 then -- Dread Breath
			if not self:IsBeforeRadiantBarrier(eventInfo.duration, 10) then return end -- Debuff is may be applied well before the timer ends
			barInfo = self:DreadBreath(eventInfo)
		elseif durationRounded == 26 then
			if not self:IsBeforeRadiantBarrier(eventInfo.duration) then return end
			if stage == 1 then -- Vaelwing, Rakfang, Grappling Maw
				if countForDuration[duration] % 3 == 1 then
					barInfo = self:Vaelwing(eventInfo)
				elseif countForDuration[duration] % 3 == 2 then
					barInfo = self:Rakfang(eventInfo)
				else
					barInfo = self:GrapplingMaw(eventInfo)
				end
			elseif stage == 2 then -- Rakfang, Vaelwing, Void Howl, Grapping Maw
				if countForDuration[duration] % 4 == 1 then
					barInfo = self:Rakfang(eventInfo)
				elseif countForDuration[duration] % 4 == 2 then
					barInfo = self:Vaelwing(eventInfo)
				elseif countForDuration[duration] % 4 == 3 then
					barInfo = self:VoidHowl(eventInfo)
				else
					barInfo = self:GrapplingMaw(eventInfo)
				end
			end
		elseif durationRounded == 47 then -- Void Howl
			if not self:IsBeforeRadiantBarrier(eventInfo.duration) then return end
			barInfo = self:VoidHowl(eventInfo)
		elseif durationRounded == 53 then -- Nullbeam, Dread Breath, Gloom
			if not self:IsBeforeRadiantBarrier(eventInfo.duration) then return end
			if stage == 1 then
				barInfo = self:Nullbeam(eventInfo)
			elseif stage == 2 then
				if countForDuration[duration] % 2 == 1 then
					barInfo = self:Gloom(eventInfo)
				else
					if not self:IsBeforeRadiantBarrier(eventInfo.duration, 10) then return end -- Debuff is may be applied well before the timer ends
					barInfo = self:DreadBreath(eventInfo)
				end
			end
		elseif durationRounded ==  95 then -- Nullbeam, Gloom
			if not self:IsBeforeRadiantBarrier(eventInfo.duration) then return end
			if stage == 1 then
				barInfo = self:Gloom(eventInfo)
			elseif stage == 2 then
				barInfo = self:Nullbeam(eventInfo)
			end
		elseif durationRounded == 31 then -- Vaelwing, Rakfang
			if not self:IsBeforeRadiantBarrier(eventInfo.duration) then return end
			if countForDuration[duration] % 2 == 1 then
				barInfo = self:Vaelwing(eventInfo)
			else
				barInfo = self:Rakfang(eventInfo)
			end
		elseif durationRounded == 63 then -- Nullbeam, Gloom
			if not self:IsBeforeRadiantBarrier(eventInfo.duration) then return end
			if countForDuration[duration] % 2 == 1 then
				barInfo = self:Nullbeam(eventInfo)
			else
				barInfo = self:Gloom(eventInfo)
			end
		elseif durationRounded == 51 then -- Void Howl
			if not self:IsBeforeRadiantBarrier(eventInfo.duration) then return end
			barInfo = self:VoidHowl(eventInfo)
		elseif durationRounded == 81 then -- Dread Breath
			if not self:IsBeforeRadiantBarrier(eventInfo.duration, 10) then return end -- Debuff is may be applied well before the timer ends
			barInfo = self:DreadBreath(eventInfo)
		elseif durationRounded == 8 then -- Midnight Flames
			barInfo = self:MidnightFlames(eventInfo)
		end
	end

	if barInfo then
		activeBars[eventInfo.id] = barInfo
	elseif self:ShouldShowBars() and not self:IsWiping() then
		self:ErrorForTimelineEvent(eventInfo)
		backupBars[eventInfo.id] = true
		self:SendMessage("BigWigs_StartBar", nil, nil, ("[B] %s"):format(eventInfo.spellName), eventInfo.duration, eventInfo.iconFileID, eventInfo.maxQueueDuration, nil, eventInfo.id, eventInfo.id)

		local state = C_EncounterTimeline.GetEventState(eventInfo.id)
		if state == 1 then -- Enum.EncounterTimelineEventState.Paused = 1
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventInfo.id)
		end
	end
end

function mod:ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED(_, eventID)
	local barInfo = activeBars[eventID]
	if barInfo then
		local state = C_EncounterTimeline.GetEventState(eventID)
		if state == 2 or state == 3 then -- Finished or Canceled
			self:StopBar(barInfo.msg)

			if state == 2 and barInfo.onFinished and self:ShouldShowBars() then -- Finished
				barInfo.onFinished()
			end

			activeBars[eventID] = nil
		end
	elseif backupBars[eventID] then
		local newState = C_EncounterTimeline.GetEventState(eventID)
		if newState == 0 then -- Enum.EncounterTimelineEventState.Active
			self:SendMessage("BigWigs_ResumeBar", nil, nil, eventID)
		elseif newState == 1 then -- Enum.EncounterTimelineEventState.Paused
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventID)
		elseif newState == 3 then -- Enum.EncounterTimelineEventState.Canceled
			self:SendMessage("BigWigs_StopBar", nil, nil, eventID)
		elseif newState == 2 then -- Enum.EncounterTimelineEventState.Finished
			local info = C_EncounterTimeline.GetEventInfo(eventID)
			self:SendMessage("BigWigs_StopBar", nil, nil, eventID)
		end
	end
end

function mod:ENCOUNTER_TIMELINE_EVENT_REMOVED(_, eventID)
	local barInfo = activeBars[eventID]
	if barInfo then
		self:StopBar(barInfo.msg)
		activeBars[eventID] = nil
	elseif backupBars[eventID] then
		backupBars[eventID] = nil
		self:SendMessage("BigWigs_StopBar", nil, nil, eventID)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:MidnightFlames(eventInfo)
	local barText = CL.count:format(CL.raid_damage, midnightFlamesCount)
	if self:ShouldShowBars() then
		self:CDBar(1249748, eventInfo.duration, barText, nil, eventInfo.id)
	end
	midnightFlamesCount = midnightFlamesCount + 1
	return {
		msg = barText,
		onFinished = function()
			self:Message(1249748, "yellow", barText)
			self:PlaySound(1249748, "alert")
			self:StopBlizzMessages(0.2)
		end
	}
end

function mod:GrapplingMaw(eventInfo)
	local barText = CL.count:format(L.grappling_maw, grapplingMawCount)
	if self:ShouldShowBars() then
		self:CDBar(1280458, eventInfo.duration, barText, nil, eventInfo.id)
	end
	grapplingMawCount = grapplingMawCount + 1
	return {
		msg = barText,
		onFinished = function()
			self:Message(1280458, "purple", barText)
			-- Sound needed?
		end
	}
end

-- Vaelgor
function mod:Nullbeam(eventInfo)
	local barText = CL.count:format(self:SpellName(1262623), nullbeamCount)
	if self:ShouldShowBars() then
		self:CDBar(1262623, eventInfo.duration, barText, nil, eventInfo.id)
	end
	nullbeamCount = nullbeamCount + 1
	return {
		msg = barText,
		onFinished = function()
			self:Message(1262623, "yellow", barText)
			self:PlaySound(1262623, "alert")
			self:StopBlizzMessages(0.2)
		end
	}
end

function mod:DreadBreath(eventInfo)
	local barText = CL.count:format(CL.breath, dreadBreathCount)
	if self:ShouldShowBars() then
		self:CDBar(1244221, eventInfo.duration, barText, nil, eventInfo.id)
	end
	dreadBreathCount = dreadBreathCount + 1
	return {
		msg = barText,
		onFinished = function()
			-- self:Message(1244221, "red", barText) -- Blizzard Message has a target.
			self:TargetMessageFromBlizzMessage(1, 1244221, "red", barText)
			-- PA Sounds
		end
	}
end

function mod:Vaelwing(eventInfo)
	local barText = CL.count:format(self:SpellName(1265131), vaelwingCount)
	if self:ShouldShowBars() then
		self:CDBar(1265131, eventInfo.duration, barText, nil, eventInfo.id)
	end
	vaelwingCount = vaelwingCount + 1
	return {
		msg = barText,
		onFinished = function()
			self:Message(1265131, "purple", barText)
			if self:ThreatTarget("player", "boss1") then -- this assumed Vaelgor boss1
				self:PlaySound(1265131, "alarm")
			end
		end
	}
end

-- Ezzorak
function mod:Gloom(eventInfo)
	local barText = CL.count:format(self:SpellName(1245391), gloomCount)
	if self:ShouldShowBars() then
		self:CDBar(1245391, eventInfo.duration, barText, nil, eventInfo.id)
	end
	gloomCount = gloomCount + 1
	return {
		msg = barText,
		onFinished = function()
			self:Message(1245391, "orange", barText)
			self:PlaySound(1245391, "alert") -- possibly soak
			self:StopBlizzMessages(0.2)
		end
	}
end

function mod:VoidHowl(eventInfo)
	local barText = CL.count:format(CL.orbs, voidHowlCount)
	if self:ShouldShowBars() then
		self:CDBar(1244917, eventInfo.duration, barText, nil, eventInfo.id)
	end
	voidHowlCount = voidHowlCount + 1
	return {
		msg = barText,
		onFinished = function()
			self:Message(1244917, "orange", barText)
			self:PlaySound(1244917, "alarm") -- spread
		end
	}
end

function mod:Rakfang(eventInfo)
	local barText = CL.count:format(self:SpellName(1245645), rakfangCount)
	if self:ShouldShowBars() then
		self:CDBar(1245645, eventInfo.duration, barText, nil, eventInfo.id)
	end
	rakfangCount = rakfangCount + 1
	return {
		msg = barText,
		onFinished = function()
			self:Message(1245645, "purple", barText)
			-- if self:ThreatTarget("player", "boss2") then -- this assumed Ezzorak boss2
			-- 	self:PlaySound(1245645, "alarm")
			-- end
		end
	}
end

-- Lightbound Vanguard
function mod:RadiantBarrier(eventInfo)
	local barText = CL.count:format(CL.intermission, radiantBarrierCount)
	if self:ShouldShowBars() then
		self:CDBar("stages", eventInfo.duration, barText, 1248847, eventInfo.id) -- Radiant Barrier icon
	end
	nextRadiantBarrier = GetTime() + eventInfo.duration
	radiantBarrierCount = radiantBarrierCount + 1
	return {
		msg = barText,
	}
end
