
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
	{1255979, sound = "alarm"}, -- Dread Breath (Feared)
	{1264467, sound = "underyou"}, -- Tail Lash
	{1245554, sound = "alert"},-- Gloomtouched
	{1270852, sound = "none"}, -- Diminish
	{1245421, sound = "underyou"}, -- Gloomfield
	{1245059, sound = "alarm"}, -- Void Howl
	{1245175, sound = "none"}, -- Voidbolt
	-- {1280355, sound = "alarm"}, -- Rakfang Too spammy?
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
local stageOneCount = 1
local stageTwoStartTime = 0
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
		[1262623] = CL.beam,
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
	stageOneCount = 1
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
	nextRadiantBarrier = GetTime() + 600 -- fallback for timers incase the radiant barrier detection is broken
end

function mod:OnBossDisable()
	for eventID in next, backupBars do
		self:SendMessage("BigWigs_StopBar", nil, nil, eventID)
	end
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

local nextBarrierBuffer = 5
function mod:TimersMythic(_, eventInfo)
	if eventInfo.source ~= 0 then return end
	timelineEventCount = timelineEventCount + 1
	local duration = eventInfo.duration
	local rounded = math.floor(duration + 0.5)
	local barInfo
	local stage = self:GetStage()

	if stage == 1 and rounded == 8 then -- Stage 2
		self:SetStage(2)
		stage = 2
		stageTwoStartTime = GetTime()
		if self:ShouldShowBars() then
			-- self:Message("stages", "cyan", CL.stage:format(2), false) -- Blizzard Radiant Barrier Message
			self:PlaySound("stages", "long")
			self:Bar("stages", 40, CL.stage:format(1), 1249748)
		end
	elseif stage == 2 and GetTime() - stageTwoStartTime > 15 then
		self:SetStage(1)
		if self:ShouldShowBars() then
			self:Message("stages", "cyan", CL.stage:format(1), false)
			self:PlaySound("stages", "long")
		end
		timelineEventCount = 1
		stage = 1
		stageOneCount = stageOneCount + 1
		countForDuration = {}

		nullbeamCount = 1
		dreadBreathCount = 1
		vaelwingCount = 1
		gloomCount = 1
		voidHowlCount = 1
		rakfangCount = 1
	end

	if stage == 1 then
		if timelineEventCount <= 7 then -- Initial timers
			if stageOneCount == 1 then -- Initial Pull Timers
				if rounded == 6 then -- Vaelwing
					barInfo = self:Vaelwing(eventInfo)
				elseif rounded == 11 then -- Rakfang
					barInfo = self:Rakfang(eventInfo)
				elseif rounded == 12 then -- Dread Breath
					barInfo = self:DreadBreath(eventInfo)
				elseif rounded == 15 then -- Nullbeam
					barInfo = self:Nullbeam(eventInfo)
				elseif rounded == 25 then -- Void Howl
					barInfo = self:VoidHowl(eventInfo)
				elseif rounded == 40 then -- Gloom
					barInfo = self:Gloom(eventInfo)
				elseif rounded == 120 then -- Radiant Barrier
					barInfo = self:RadiantBarrier(eventInfo)
				end
			elseif stageOneCount == 2 then -- Round 2
				if rounded == 19 then -- Vaelwing
					barInfo = self:Vaelwing(eventInfo)
				elseif rounded == 23 then -- Nullbeam
					barInfo = self:Nullbeam(eventInfo)
				elseif rounded == 34 then -- Dread Breath
					barInfo = self:DreadBreath(eventInfo)
				elseif rounded == 25 then -- Rakfang
					barInfo = self:Rakfang(eventInfo)
				elseif rounded == 28 then -- Gloom
					barInfo = self:Gloom(eventInfo)
				elseif rounded == 48 then -- Void Howl
					barInfo = self:VoidHowl(eventInfo)
				elseif rounded == 128 then -- Radiant Barrier
					barInfo = self:RadiantBarrier(eventInfo)
				end
			elseif stageOneCount == 3 then -- Round 3
				if rounded == 21 then -- Vaelwing
					barInfo = self:Vaelwing(eventInfo)
				elseif rounded == 20 then -- Nullbeam
					barInfo = self:Nullbeam(eventInfo)
				elseif rounded == 46 then -- Dread Breath
					barInfo = self:DreadBreath(eventInfo)
				elseif rounded == 27 then -- Rakfang
					barInfo = self:Rakfang(eventInfo)
				elseif rounded == 55 then -- Gloom
					barInfo = self:Gloom(eventInfo)
				elseif rounded == 15 then -- Void Howl
					barInfo = self:VoidHowl(eventInfo)
				elseif rounded == 125 then -- Radiant Barrier
					barInfo = self:RadiantBarrier(eventInfo)
				end
			end
		else
			if (GetTime() + duration) > (nextRadiantBarrier + nextBarrierBuffer) then -- Don't show timers which won't happen, small buffer incase of a delay
				return
			end
			if rounded == 45 then -- Dread Breath
				barInfo = self:DreadBreath(eventInfo)
			elseif rounded == 25 then -- Vaelwing > Rakfang
				countForDuration[duration] = (countForDuration[duration] or 0) + 1
				if countForDuration[duration] % 2 == 0 then
					barInfo = self:Rakfang(eventInfo)
				else
					barInfo = self:Vaelwing(eventInfo)
				end
			elseif rounded == 45 then -- Dread Breath or Void Howl
				countForDuration[duration] = (countForDuration[duration] or 0) + 1
				local breathMod = stageOneCount == 3 and 0 or 1 -- Alternate rotation in 3rd stage 1
				if countForDuration[duration] % 2 == breathMod then
					barInfo = self:DreadBreath(eventInfo)
				else
					barInfo = self:VoidHowl(eventInfo)
				end
			elseif rounded == 50 then -- Gloom
				barInfo = self:Gloom(eventInfo)
			elseif rounded == 60 then -- Nullbeam
				barInfo = self:Nullbeam(eventInfo)
			end
		end
	elseif stage == 2 then
		if rounded == 8 then -- Midnight Flames
			barInfo = self:MidnightFlames(eventInfo)
		end
	end

	if barInfo then
		activeBars[eventInfo.id] = barInfo
	elseif self:ShouldShowBars() and not self:IsWiping() then
		self:ErrorForTimelineEvent(eventInfo)
		backupBars[eventInfo.id] = true
		self:SendMessage("BigWigs_StartBar", nil, nil, eventInfo.spellName, eventInfo.duration, eventInfo.iconFileID, eventInfo.maxQueueDuration, nil, eventInfo.id, eventInfo.id)

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
	local rounded = math.floor(duration + 0.5)
	local barInfo
	local stage = self:GetStage()

	if stage == 1 and duration == 8 then -- Stage 2
		self:SetStage(2)
		stage = 2
		stageTwoStartTime = GetTime()
		if self:ShouldShowBars() then
			-- self:Message("stages", "cyan", CL.stage:format(2), false) -- Blizzard Radiant Barrier Message
			self:PlaySound("stages", "long")
			self:Bar("stages", 25, CL.stage:format(1), 1249748)
		end
	elseif stage == 2 and GetTime() - stageTwoStartTime > 15 then
		self:SetStage(1)
		if self:ShouldShowBars() then
			self:Message("stages", "cyan", CL.stage:format(1), false)
			self:PlaySound("stages", "long")
		end
		timelineEventCount = 1
		stage = 1
		stageOneCount = stageOneCount + 1
		countForDuration = {}

		nullbeamCount = 1
		dreadBreathCount = 1
		vaelwingCount = 1
		gloomCount = 1
		voidHowlCount = 1
		rakfangCount = 1
		grapplingMawCount = 1
	end

	if stage == 1 then
		if timelineEventCount <= 7 then -- Initial timers
			if stageOneCount == 1 then -- Initial Pull Timers
				if rounded == 6 then -- Vaelwing
					barInfo = self:Vaelwing(eventInfo)
				elseif rounded == 27 then -- Dread Breath
					barInfo = self:DreadBreath(eventInfo)
				elseif rounded == 10 then -- Nullbeam
					barInfo = self:Nullbeam(eventInfo)
				elseif rounded == 30 and not self:IsWiping() then -- Void Howl
					barInfo = self:VoidHowl(eventInfo)
				elseif rounded == 18 then -- Grappling Maw
					barInfo = self:GrapplingMaw(eventInfo)
				elseif rounded == 50 then -- Gloom
					barInfo = self:Gloom(eventInfo)
				elseif rounded == 105 then -- Radiant Barrier
					barInfo = self:RadiantBarrier(eventInfo)
				end
			elseif stageOneCount == 2 then -- Round 2
				if rounded == 18 then -- Grappling Maw
					barInfo = self:GrapplingMaw(eventInfo)
				elseif rounded == 45 then -- Nullbeam
					barInfo = self:Nullbeam(eventInfo)
				elseif rounded == 27 then -- Dread Breath
					barInfo = self:DreadBreath(eventInfo)
				elseif rounded == 6 then -- Rakfang
					barInfo = self:Rakfang(eventInfo)
				elseif rounded == 10 then -- Gloom
					barInfo = self:Gloom(eventInfo)
				elseif rounded == 15 then -- Void Howl
					barInfo = self:VoidHowl(eventInfo)
				elseif rounded == 105 then -- Radiant Barrier
					barInfo = self:RadiantBarrier(eventInfo)
				end
			elseif stageOneCount >= 3 then -- Round 3+
				if rounded == 8 then -- Vaelwing
					barInfo = self:Vaelwing(eventInfo)
				elseif rounded == 13 then -- Nullbeam
					barInfo = self:Nullbeam(eventInfo)
				elseif rounded == 65 then -- Dread Breath
					barInfo = self:DreadBreath(eventInfo)
				elseif rounded == 15 then -- Rakfang
					barInfo = self:Rakfang(eventInfo)
				elseif rounded == 50 then -- Gloom
					barInfo = self:Gloom(eventInfo)
				elseif rounded == 25 then -- Void Howl
					barInfo = self:VoidHowl(eventInfo)
				elseif rounded == 225 then -- Radiant Barrier
					barInfo = self:RadiantBarrier(eventInfo)
				end
			end
		else
			if (GetTime() + duration) > (nextRadiantBarrier + nextBarrierBuffer) then -- Don't show timers which won't happen, small buffer incase of a delay
				return
			end
			countForDuration[duration] = (countForDuration[duration] or 0) + 1
			if rounded == 20 or rounded == 81 then -- Dread Breath
				barInfo = self:DreadBreath(eventInfo)
			elseif rounded == 25 then
				if stageOneCount == 1 then -- Vaelwing, Grappling Maw
					if countForDuration[duration] % 2 == 1 then
						barInfo = self:Vaelwing(eventInfo)
					else
						barInfo = self:GrapplingMaw(eventInfo)
					end
				elseif stageOneCount == 2 then -- Rakfang, Void Howl, Grapping Maw
					if countForDuration[duration] % 3 == 1 then
						barInfo = self:Rakfang(eventInfo)
					elseif countForDuration[duration] % 3 == 2 then
						barInfo = self:VoidHowl(eventInfo)
					else
						barInfo = self:GrapplingMaw(eventInfo)
					end
				end
			elseif rounded == 30 and not self:IsWiping() then -- Grapplin Maw stage 1.4
				barInfo = self:GrapplingMaw(eventInfo)
			elseif rounded == 31 then -- Vaelwing, Rakfang
				if countForDuration[duration] % 2 == 1 then
					barInfo = self:Vaelwing(eventInfo)
				else
					barInfo = self:Rakfang(eventInfo)
				end
			elseif rounded == 45 or rounded == 51 then -- Void Howl
				barInfo = self:VoidHowl(eventInfo)
			elseif rounded == 50 then -- Nullbeam, Dread Breath, Gloom
				if stageOneCount == 1 then
					barInfo = self:Nullbeam(eventInfo)
				elseif stageOneCount == 2 then
					if countForDuration[duration] % 2 == 1 then
						barInfo = self:Gloom(eventInfo)
					else
						barInfo = self:DreadBreath(eventInfo)
					end
				end
			elseif rounded == 63 then -- Nullbeam, Gloom
				if countForDuration[duration] % 2 == 1 then
					barInfo = self:Nullbeam(eventInfo)
				else
					barInfo = self:Gloom(eventInfo)
				end
			elseif rounded == 90 then -- Nullbeam, Gloom
				if stageOneCount == 1 then
					barInfo = self:Gloom(eventInfo)
				elseif stageOneCount == 2 then
					barInfo = self:Nullbeam(eventInfo)
				end
			end
		end
	elseif stage == 2 then
		if rounded == 8 then -- Midnight Flames
			barInfo = self:MidnightFlames(eventInfo)
		end
	end

	if barInfo then
		activeBars[eventInfo.id] = barInfo
	elseif self:ShouldShowBars() and not self:IsWiping() then
		self:ErrorForTimelineEvent(eventInfo)
		backupBars[eventInfo.id] = true
		self:SendMessage("BigWigs_StartBar", nil, nil, eventInfo.spellName, eventInfo.duration, eventInfo.iconFileID, eventInfo.maxQueueDuration, nil, eventInfo.id, eventInfo.id)

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
	local rounded = math.floor(duration + 0.5)
	local barInfo
	local stage = self:GetStage()

	if stage == 1 and duration == 8 then -- Stage 2
		self:SetStage(2)
		stage = 2
		stageTwoStartTime = GetTime()
		if self:ShouldShowBars() then
			-- self:Message("stages", "cyan", CL.stage:format(2), false) -- Blizzard Radiant Barrier Message
			self:PlaySound("stages", "long")
			self:Bar("stages", 26.5, CL.stage:format(1), 1249748)
		end
	elseif stage == 2 and GetTime() - stageTwoStartTime > 15 then
		self:SetStage(1)
		if self:ShouldShowBars() then
			self:Message("stages", "cyan", CL.stage:format(1), false)
			self:PlaySound("stages", "long")
		end
		timelineEventCount = 1
		stage = 1
		stageOneCount = stageOneCount + 1
		countForDuration = {}

		nullbeamCount = 1
		dreadBreathCount = 1
		vaelwingCount = 1
		gloomCount = 1
		voidHowlCount = 1
		rakfangCount = 1
		grapplingMawCount = 1
	end

	if stage == 1 then
		if timelineEventCount <= 7 then -- Initial timers
			if stageOneCount == 1 then -- Initial Pull Timers
				if rounded == 6 then -- Vaelwing
					barInfo = self:Vaelwing(eventInfo)
				elseif rounded == 28 then -- Dread Breath
					barInfo = self:DreadBreath(eventInfo)
				elseif rounded == 11 then -- Nullbeam
					barInfo = self:Nullbeam(eventInfo)
				elseif rounded == 32 then -- Void Howl
					barInfo = self:VoidHowl(eventInfo)
				elseif rounded == 19 then -- Grappling Maw
					barInfo = self:GrapplingMaw(eventInfo)
				elseif rounded == 53 then -- Gloom
					barInfo = self:Gloom(eventInfo)
				elseif rounded == 111 then -- Radiant Barrier
					barInfo = self:RadiantBarrier(eventInfo)
				end
			elseif stageOneCount == 2 then -- Round 2
				if rounded == 19 then -- Grappling Maw
					barInfo = self:GrapplingMaw(eventInfo)
				elseif rounded == 47 then -- Nullbeam
					barInfo = self:Nullbeam(eventInfo)
				elseif rounded == 28 then -- Dread Breath
					barInfo = self:DreadBreath(eventInfo)
				elseif rounded == 6 then -- Rakfang
					barInfo = self:Rakfang(eventInfo)
				elseif rounded == 11 then -- Gloom
					barInfo = self:Gloom(eventInfo)
				elseif rounded == 16 then -- Void Howl
					barInfo = self:VoidHowl(eventInfo)
				elseif rounded == 111 then -- Radiant Barrier
					barInfo = self:RadiantBarrier(eventInfo)
				end
			end
		else
			if (GetTime() + duration) > (nextRadiantBarrier + nextBarrierBuffer) then -- Don't show timers which won't happen, small buffer incase of a delay
				return
			end
			countForDuration[duration] = (countForDuration[duration] or 0) + 1
			if rounded == 21 then -- Dread Breath
				barInfo = self:DreadBreath(eventInfo)
			elseif rounded == 26 then
				if stageOneCount == 1 then -- Vaelwing, Grappling Maw
					if countForDuration[duration] % 2 == 1 then
						barInfo = self:Vaelwing(eventInfo)
					else
						barInfo = self:GrapplingMaw(eventInfo)
					end
				elseif stageOneCount == 2 then -- Rakfang, Void Howl, Grapping Maw
					if countForDuration[duration] % 3 == 1 then
						barInfo = self:Rakfang(eventInfo)
					elseif countForDuration[duration] % 3 == 2 then
						barInfo = self:VoidHowl(eventInfo)
					else
						barInfo = self:GrapplingMaw(eventInfo)
					end
				end
			elseif rounded == 47 then -- Void Howl
				barInfo = self:VoidHowl(eventInfo)
			elseif rounded == 53 then -- Nullbeam, Dread Breath, Gloom
				if stageOneCount == 1 then
					barInfo = self:Nullbeam(eventInfo)
				elseif stageOneCount == 2 then
					if countForDuration[duration] % 2 == 1 then
						barInfo = self:Gloom(eventInfo)
					else
						barInfo = self:DreadBreath(eventInfo)
					end
				end
			elseif rounded ==  95 then -- Nullbeam, Gloom
				if stageOneCount == 1 then
					barInfo = self:Gloom(eventInfo)
				elseif stageOneCount == 2 then
					barInfo = self:Nullbeam(eventInfo)
				end
			end
		end
	elseif stage == 2 then
		if rounded == 8 then -- Midnight Flames
			barInfo = self:MidnightFlames(eventInfo)
		end
	end

	if barInfo then
		activeBars[eventInfo.id] = barInfo
	elseif self:ShouldShowBars() and not self:IsWiping() then
		self:ErrorForTimelineEvent(eventInfo)
		backupBars[eventInfo.id] = true
		self:SendMessage("BigWigs_StartBar", nil, nil, eventInfo.spellName, eventInfo.duration, eventInfo.iconFileID, eventInfo.maxQueueDuration, nil, eventInfo.id, eventInfo.id)

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

			if state == 2 and self:ShouldShowBars() and barInfo.callback then -- Finished
				barInfo.callback()
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
		callback = function()
			self:Message(1249748, "yellow", barText)
			self:PlaySound(1249748, "alert")
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
		callback = function()
			self:Message(1280458, "purple", barText)
			-- Sound needed?
		end
	}
end

-- Vaelgor
function mod:Nullbeam(eventInfo)
	local barText = CL.count:format(CL.beam, nullbeamCount)
	if self:ShouldShowBars() then
		self:CDBar(1262623, eventInfo.duration, barText, nil, eventInfo.id)
	end
	nullbeamCount = nullbeamCount + 1
	return {
		msg = barText,
		callback = function()
			-- self:Message(1262623, "yellow", barText) -- Blizzard Message
			self:PlaySound(1262623, "alert")
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
		callback = function()
			-- self:Message(1244221, "red", barText) -- Blizzard Message
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
		callback = function()
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
		callback = function()
			-- self:Message(1245391, "orange", barText) -- Blizzard Message.
			self:PlaySound(1245391, "alert")-- possibly soak
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
		callback = function()
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
		callback = function()
			self:Message(1245645, "purple", barText)
			if self:ThreatTarget("player", "boss2") then -- this assumed Ezzorak boss2
				self:PlaySound(1245645, "alarm")
			end
		end
	}
end

-- Lightbound Vanguard
function mod:RadiantBarrier(eventInfo)
	local barText = CL.count:format(CL.stage:format(2), radiantBarrierCount)
	if self:ShouldShowBars() then
		self:CDBar("stages", eventInfo.duration, barText, 1248847, eventInfo.id) -- Radiant Barrier icon
	end
	nextRadiantBarrier = GetTime() + eventInfo.duration
	radiantBarrierCount = radiantBarrierCount + 1
	return {
		msg = barText,
	}
end
