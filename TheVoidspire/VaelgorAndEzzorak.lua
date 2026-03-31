
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
local storedTimelineEvents = {}
local scheduleBackups = nil
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
		[1280458] = L.grappling_maw,
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
	storedTimelineEvents = {}

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

function mod:IsIntermission()
	return self:GetStage() % 1 == 0.5
end

function mod:StartBackupBar(eventInfo, timerAdjustment)
	if not eventInfo then return end -- if we started our own bar this will be nil
	if not self:IsBeforeRadiantBarrier(eventInfo.duration, eventInfo.customBuffer) then return end

	self:ErrorForTimelineEvent(eventInfo)
	backupBars[eventInfo.id] = true
	local timer = eventInfo.duration
	if timerAdjustment then
		timer = timer - (GetTime() - eventInfo.timestamp)
	end
	self:SendMessage("BigWigs_StartBar", nil, nil, ("[B] %s"):format(eventInfo.spellName), timer, eventInfo.iconFileID, eventInfo.maxQueueDuration, nil, eventInfo.id, eventInfo.id)

	local state = C_EncounterTimeline.GetEventState(eventInfo.id)
	if state == 1 then -- Enum.EncounterTimelineEventState.Paused = 1
		self:SendMessage("BigWigs_PauseBar", nil, nil, eventInfo.id)
	end
end

-- Allowing a custom buffer so it can be tweaked per ability.
function mod:IsBeforeRadiantBarrier(duration, customBuffer)
	local buffer = customBuffer or 0
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
	local time = GetTime()

	if durationRounded == 8 and time - 5 > lastStaged and not self:IsIntermission()  then -- Midnight Flames Cast
		stage = stage + 0.5
		self:SetStage(stage)
		lastStaged = time
		if self:ShouldShowBars() then
			self:Message("stages", "cyan", CL.intermission, false)
			self:PlaySound("stages", "long")
			self:Bar("stages", 40, CL.stage:format(stage + 0.5), 1249748)
			self:StopBlizzMessages(1) -- Radiant Barrier Message
		end
	elseif time - 5 > lastStaged and self:IsIntermission() then
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

	if not self:IsIntermission() then -- 1, 2, 3+
		local initialTimers = stage == 2 and 8 or 7
		if timelineEventCount <= initialTimers then -- Initial timers
			if stage == 1 then -- Initial Pull Timers
				if durationRounded == 6 then -- Vaelwing
					barInfo = self:Vaelwing(eventInfo)
				elseif durationRounded == 12 then -- Rakfang
					barInfo = self:Rakfang(eventInfo)
				elseif durationRounded == 7 then -- Dread Breath
					barInfo = self:DreadBreath(eventInfo)
				elseif durationRounded == 30 then -- Nullbeam
					barInfo = self:Nullbeam(eventInfo)
				elseif durationRounded == 35 then -- Void Howl
					barInfo = self:VoidHowl(eventInfo)
				elseif durationRounded == 10 then -- Gloom
					barInfo = self:Gloom(eventInfo)
				elseif durationRounded == 120 then -- Radiant Barrier
					barInfo = self:RadiantBarrier(eventInfo)
				end
			elseif stage == 2 then -- Round 2
				if durationRounded == 19 then -- Vaelwing
					barInfo = self:Vaelwing(eventInfo)
				elseif durationRounded == 18 then -- Nullbeam
					barInfo = self:Nullbeam(eventInfo)
				elseif durationRounded == 25 then -- Dread Breath or Rakfang
					countForDuration[durationRounded] = (countForDuration[durationRounded] or 0) + 1
					if countForDuration[durationRounded] == 1 then
						barInfo = self:DreadBreath(eventInfo)
					elseif countForDuration[durationRounded] == 2 then
						barInfo = self:Rakfang(eventInfo)
					end
					barInfo.BreathOfRakfang = true
				elseif durationRounded == 48 then -- Gloom
					barInfo = self:Gloom(eventInfo)
				elseif durationRounded == 43 or durationRounded == 8 then -- Void Howl (2x timers)
					barInfo = self:VoidHowl(eventInfo)
				elseif durationRounded == 128 then -- Radiant Barrier
					barInfo = self:RadiantBarrier(eventInfo)
				end
			elseif stage == 3 then -- Round 3
				if durationRounded == 21 then -- Vaelwing
					barInfo = self:Vaelwing(eventInfo)
				elseif durationRounded == 45 then -- Nullbeam
					barInfo = self:Nullbeam(eventInfo)
				elseif durationRounded == 32 then -- Dread Breath
					barInfo = self:DreadBreath(eventInfo)
				elseif durationRounded == 27 then -- Rakfang
					barInfo = self:Rakfang(eventInfo)
				elseif durationRounded == 25 then -- Gloom
					barInfo = self:Gloom(eventInfo)
				elseif durationRounded == 40 then -- Void Howl
					barInfo = self:VoidHowl(eventInfo)
				elseif durationRounded == 125 then -- Radiant Barrier
					barInfo = self:RadiantBarrier(eventInfo)
				end
			end
		else
			eventInfo.timestamp = GetTime()
			table.insert(storedTimelineEvents, eventInfo)
			if scheduleBackups then
				self:CancelTimer(scheduleBackups)
				scheduleBackups = nil
			end
			scheduleBackups = self:ScheduleTimer(function ()
				for _, event in next, storedTimelineEvents do
					if self:ShouldShowBars() and not self:IsWiping() then
						self:StartBackupBar(event, true)
					end
				end
				table.wipe(storedTimelineEvents)
			end, 0.5)
			return
		end
	else -- Intermissions
		if durationRounded == 8 then -- Midnight Flames,should be the last timer starting in Mythic
			barInfo = self:MidnightFlames(eventInfo)
			-- this bar is the last one started so we can start all our own now.
			for _, event in next, storedTimelineEvents do
				if self:ShouldShowBars() and not self:IsWiping() then
					if stage == 1.5 then -- start our own timers
						if event.durationRounded == 13 or event.durationRounded == 23 then -- Dread Breath
							if event.durationRounded == 23 then
								event.duration = 25 -- Correct blizzard timer
							end
							activeBars[event.id] = self:DreadBreath(event)
						elseif event.durationRounded == 18 then -- Nullbeam
							activeBars[event.id] = self:Nullbeam(event)
						else
							self:StartBackupBar(event, true)
						end
					elseif stage == 2.5 then
						if event.durationRounded == 13 then -- Void Howl
							activeBars[event.id] = self:VoidHowl(event)
						elseif event.durationRounded == 18 then -- Gloom
							activeBars[event.id] = self:Gloom(event)
						elseif event.durationRounded == 23 then -- Dread Breath
							event.duration = 25 -- Correct blizzard timer
							activeBars[event.id] = self:DreadBreath(event)
						else
							self:StartBackupBar(event, true)
						end
					end
				end
			end
			table.wipe(storedTimelineEvents)
		end
	end

	if barInfo then
		activeBars[eventInfo.id] = barInfo
	elseif self:ShouldShowBars() and not self:IsWiping() then
		self:StartBackupBar(eventInfo)
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

	if not self:IsIntermission() and durationRounded == 8 and time - 5 > lastStaged then -- Midnight Flames Cast
		stage = stage + 0.5
		self:SetStage(stage)
		lastStaged = time
		if self:ShouldShowBars() then
			self:Message("stages", "cyan", CL.intermission, false)
			self:PlaySound("stages", "long")
			self:Bar("stages", 25, CL.stage:format(stage + 0.5), 1249748)
			self:StopBlizzMessages(1) -- Radiant Barrier Message
		end
	elseif self:IsIntermission() and time - 5 > lastStaged then
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

	if not self:IsIntermission() then -- 1, 2, 3+
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
		else -- handle next events
			eventInfo.timestamp = GetTime()
			table.insert(storedTimelineEvents, eventInfo)
			if scheduleBackups then
				self:CancelTimer(scheduleBackups)
				scheduleBackups = nil
			end
			scheduleBackups = self:ScheduleTimer(function ()
				for _, event in next, storedTimelineEvents do
					if self:ShouldShowBars() and not self:IsWiping() then
						self:StartBackupBar(event, true)
					end
				end
				table.wipe(storedTimelineEvents)
			end, 1.5) -- Long capture to grab delayed cancels. Still happens sometimes.
			return
		end
	else -- Intermissions
		if durationRounded == 8 then -- Midnight Flames
			barInfo = self:MidnightFlames(eventInfo)
		end
	end

	if barInfo then
		activeBars[eventInfo.id] = barInfo
	elseif self:ShouldShowBars() and not self:IsWiping() then
		self:StartBackupBar(eventInfo)
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

	if not self:IsIntermission() and durationRounded == 8 and time - 5 > lastStaged then -- Midnight Flames Cast
		stage = stage + 0.5
		self:SetStage(stage)
		lastStaged = time
		if self:ShouldShowBars() then
			self:Message("stages", "cyan", CL.intermission, false)
			self:PlaySound("stages", "long")
			self:Bar("stages", 26.5, CL.stage:format(stage + 0.5), 1249748)
			self:StopBlizzMessages(1) -- Radiant Barrier Message
		end
	elseif self:IsIntermission() and time - 5 > lastStaged then
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

	if not self:IsIntermission() then -- 1, 2, 3+
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
			eventInfo.timestamp = GetTime()
			table.insert(storedTimelineEvents, eventInfo)
			if scheduleBackups then
				self:CancelTimer(scheduleBackups)
				scheduleBackups = nil
			end
			scheduleBackups = self:ScheduleTimer(function ()
				for _, event in next, storedTimelineEvents do
					if self:ShouldShowBars() and not self:IsWiping() then
						self:StartBackupBar(event, true)
					end
				end
				table.wipe(storedTimelineEvents)
			end, 1.5) -- Long capture to grab delayed cancels. Still happens sometimes.
			return
		end
	else -- Intermissions
		if durationRounded == 8 then -- Midnight Flames
			barInfo = self:MidnightFlames(eventInfo)
		end
	end

	if barInfo then
		activeBars[eventInfo.id] = barInfo
	elseif self:ShouldShowBars() and not self:IsWiping() then
		self:StartBackupBar(eventInfo)
	end
end

function mod:ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED(_, eventID)
	local newState = C_EncounterTimeline.GetEventState(eventID)
	local barInfo = activeBars[eventID]
	if barInfo then
		if newState == 2 or newState == 3 then
			self:StopBar(barInfo.msg)
			if newState == 2 then -- Finished
				if barInfo.onFinished then
					barInfo.onFinished()
				end
				local storedEventInfo = table.remove(storedTimelineEvents, 1)
				if storedEventInfo and storedEventInfo.duration then
					if self:IsBeforeRadiantBarrier(storedEventInfo.duration, storedEventInfo.customBuffer) then
						if barInfo.BreathOfRakfang then -- Decide which it is.
							if storedEventInfo.durationRounded > 30 then -- Dread Breath
								activeBars[storedEventInfo.id] = self:DreadBreath(storedEventInfo)
							else -- Rakfang
								activeBars[storedEventInfo.id] = self:Rakfang(storedEventInfo)
							end
						else
							activeBars[storedEventInfo.id] = barInfo.this(self, storedEventInfo)
						end
					end
				end
			elseif newState == 3 then -- Canceled
				if barInfo.onCanceled then
					barInfo.onCanceled()
				end
			end
			activeBars[eventID] = nil
		end
	elseif backupBars[eventID] then
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
		end,
		this = self.MidnightFlames
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
		end,
		this = self.GrapplingMaw
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
		end,
		this = self.Nullbeam
	}
end

function mod:DreadBreath(eventInfo)
	local barText = CL.count:format(CL.breath, dreadBreathCount)
	if self:ShouldShowBars() then
		self:CDBar(1244221, eventInfo.duration, barText, nil, eventInfo.id)
	end
	dreadBreathCount = dreadBreathCount + 1
	return {
		customBuffer = 5,
		msg = barText,
		onFinished = function()
			self:TargetMessageFromBlizzMessage(1, 1244221, "orange", barText)
			-- PA Sounds
		end,
		this = self.DreadBreath
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
		end,
		this = self.Vaelwing
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
		end,
		this = self.Gloom
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
		end,
		this = self.VoidHowl
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
		end,
		this = self.Rakfang
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
		this = self.RadiantBarrier
	}
end
