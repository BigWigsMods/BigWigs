if not BigWigsLoader.isNext then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kith'ix", 3095, 2896)
if not mod then return end
mod:RegisterEnableMob(267861) -- Kith'ix
mod:SetEncounterID(3513)
mod:SetRespawnTime(30)
mod:SetStage(1)
mod:UseCustomTimers(true)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}

local durationEventCount = {}
local trackedBars = {}

local voidswarmCount = 1
local appendageCount = 1
local devastationCount = 1
local extinguishCount = 1
local horrorsCount = 1
local darknessCount = 1
local radianceCount = 1
local graspCount = 1
local nullGateCount = 1
local negationCount = 1

--------------------------------------------------------------------------------
-- Renames
--

mod:SetRenames({
	["stages"] = {CL.stage:format(2), original = CL.stage:format(2)},
	[1301511] = {CL.adds}, -- Voidswarm
	[1303681] = {CL.tentacles}, -- Twisted Appendage
	[1304930] = {CL.tank_bomb, CL.cast:format(CL.tank_bomb), notes = {CL.generalNote, CL.castTimerNote}, original = {mod:SpellName(1304930), CL.cast:format(mod:SpellName(1304930))}}, -- Dark Devastation
	[1304424] = {1304424}, -- Extinguish
	[1304508] = {CL.orbs}, -- Light's Embrace
	[1304045] = {CL.debuffs}, -- Unspeakable Horrors
	[1302951] = {CL.intermission}, -- Suffocating Darkness XXX Full Energy?
	[1303169] = {CL.stage:format(1)}, -- Divine Radiance XXX Full Energy? Weakened? Boss Stunned?
	[1303406] = {CL.heal_absorbs}, -- Abyssal Grasp
	[1308873] = {1308873}, -- Null Gate
	[1318467] = {CL.tank_debuff}, -- Negation
	[1301479] = {1301479}, -- Eightfold Eclipse
})

--------------------------------------------------------------------------------
-- Options
--

mod:SetAuraData({
	{1304045, soundOnApplied = "alarm", note = CL.preDebuffNote, header = CL.important}, -- Unspeakable Horrors
	{1304046, soundOnApplied = "info", note = CL.postDebuffNote:format(mod:SpellName(1304045)), mechanic = "fleeing"}, -- Overwhelming Fear
	{1303406, soundOnApplied = "warning"}, -- Abyssal Grasp
	{1304948, soundOnApplied = "alarm"}, -- Devastated (tank)
	{1308873, soundOnApplied = "warning"}, -- Null Gate
	{1318467, soundOnApplied = "warning"}, -- Negation (tank)
	{1308875, soundOnApplied = "warning", soundOnAppliedDose = "warning"}, -- Nullify
	-- Adds
	{1302319, soundOnAppliedDose = "none", header = CL.adds}, -- Digestive Juice (Bomber Beetle)
	{1304040, mechanic = "stunned"}, -- Mindsting (Mindstinger)
	{1302334}, -- Voidweave (Voidweaver)
	{1302728, soundOnAppliedDose = "none"}, -- Nightfall (Voidweaver)
	-- General
	{1304526, soundOnApplied = "info", header = CL.general}, -- Light's Embrace
	{1303165}, -- Suffocating Darkness
	{1303257, soundOnApplied = "alarm"}, -- Suffocation
	{1308674}, -- Eclipse Fragment
	{1308675}, -- Lost Refulgence
	{1301110, mechanic = "stunned"}, -- Stygian Howl (Phase 2)
	{1305428, soundOnApplied = "info"}, -- Luminous Grace
})

function mod:GetOptions()
	return {
		"stages",

		-- Stage One: Darkness' Domain
		1301511, -- Voidswarm
		1304424, -- Extinguish
		1304508, -- Light's Embrace
		1304045, -- Unspeakable Horrors
		1303681, -- Twisted Appendage
		{1304930, "CASTBAR"}, -- Dark Devastation

		-- Intermission: Suffocating Darkness
		1302951, -- Suffocating Darkness
		1303406, -- Abyssal Grasp
		1303169, -- Divine Radiance

		-- Stage Two: Last Light
		1308873, -- Null Gate
		1318467, -- Negation
		1301479, -- Eightfold Eclipse
	}, {
		[1301511] = -36392, -- Stage 1
		[1302951] = ("%s: %s"):format(CL.intermission, mod:SpellName(1302951)), -- Intermission
		[1308873] = -36394, -- Stage 2
	}
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	backupBars = {}
	if self:Mythic() then
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "MythicTimeline")
	else
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "HeroicTimeline")
	end
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
end

function mod:OnEncounterStart()
	activeBars = {}
	self:SetStage(1)
	durationEventCount = {}
	trackedBars = {}

	voidswarmCount = 1
	appendageCount = 1
	devastationCount = 1
	extinguishCount = 1
	horrorsCount = 1
	darknessCount = 1
	radianceCount = 1
	graspCount = 1
	nullGateCount = 1
	negationCount = 1
end

-- function mod:ResetCounts()
-- 	voidswarmCount = 1
-- 	appendageCount = 1
-- 	devastationCount = 1
-- 	extinguishCount = 1
-- 	horrorsCount = 1
-- 	graspCount = 1
-- end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

-- Some events are Finished immediately and we need to be able to cancel them on phase change
local function trackBar(barInfo)
	barInfo.ignoreState = true
	barInfo.finishOnDuration = true
	trackedBars[#trackedBars + 1] = barInfo
	return barInfo
end

function mod:MythicTimeline(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo = nil

	local stage = self:GetStage()
	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	if stage == 1 and rounded == 1 then -- Null Gate = Stage 2
		self:StageTwoStart(true)
		stage = 2
	end

	if stage == 1 then
		if rounded == 5 then
			barInfo = self:Voidswarm()
		elseif rounded == 12 or rounded == 15 or rounded == 16 or rounded == 18 then
			barInfo = self:TwistedAppendage()
		elseif rounded == 19 or rounded == 20 or rounded == 23 or rounded == 66 then
			barInfo = self:DarkDevastation()
		elseif rounded == 42 or rounded == 67 then
			barInfo = self:Extinguish(duration)
		elseif rounded == 37 then
			barInfo = self:UnspeakableHorrors()
		elseif rounded == 47 then
			barInfo = trackBar(self:UnspeakableHorrors())
		elseif rounded == 52 then
			barInfo = self:SuffocatingDarkness()
		elseif rounded == 40 then
			barInfo = self:DivineRadiance()
		elseif rounded == 27 or rounded == 82 then
			barInfo = trackBar(self:AbyssalGrasp())
		elseif rounded == 29 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			local count = durationEventCount[rounded]
			if count == 1 then -- on pull
				barInfo = self:Extinguish(duration)
			else
				barInfo = self:TwistedAppendage()
			end
		elseif rounded == 62 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			local count = durationEventCount[rounded]
			if count == 1 then -- on pull
				barInfo = self:AbyssalGrasp()
			else
				barInfo = trackBar(self:UnspeakableHorrors())
			end
		elseif rounded == 109 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			local count = durationEventCount[rounded]
			if count % 2 == 1 then
				barInfo = self:Voidswarm()
			else
				barInfo = self:SuffocatingDarkness()
			end
		end

	elseif stage == 2 then
		if rounded == 1 then
			barInfo = self:NullGate()
		elseif rounded == 16 then
			barInfo = self:Negation()
		elseif rounded == 10 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			local count = durationEventCount[rounded]
			if count == 1 then -- on stage start
				barInfo = self:Negation()
			else
			barInfo = trackBar(self:NullGate())
			end
		elseif rounded == 61 then
			barInfo = self:EightfoldEclipse()
		end
	end

	self:HandleBar(barInfo, eventInfo)
end

function mod:HeroicTimeline(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo = nil

	local stage = self:GetStage()
	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	if stage == 1 and rounded == 3 then -- Null Gate = Stage 2
		self:StageTwoStart(true)
		stage = 2
	end

	if stage == 1 then
		if rounded == 5 then
			barInfo = self:Voidswarm()
		elseif rounded == 12 or rounded == 15 or rounded == 18 or rounded == 32 then
			barInfo = self:TwistedAppendage()
		elseif rounded == 20 or rounded == 22 or rounded == 69 then
			barInfo = self:DarkDevastation()
		elseif rounded == 57 then
			barInfo = self:Extinguish(duration)
		elseif rounded == 37 then
			barInfo = self:UnspeakableHorrors()
		elseif rounded == 33 or rounded == 76 then
			barInfo = trackBar(self:UnspeakableHorrors())
		elseif rounded == 40 then
			barInfo = self:DivineRadiance()
		elseif rounded == 62 then
			barInfo = self:AbyssalGrasp()
		elseif rounded == 27 or rounded == 82 then
			barInfo = trackBar(self:AbyssalGrasp())
		elseif rounded == 29 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			local count = durationEventCount[rounded]
			if count == 1 then -- on pull
				barInfo = self:Extinguish(duration)
			else
				barInfo = self:TwistedAppendage()
			end
		elseif rounded == 52 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			local count = durationEventCount[rounded]
			if count == 1 then -- on pull
				barInfo = self:SuffocatingDarkness()
			else
				barInfo = self:Extinguish(duration)
			end
		elseif rounded == 109 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			local count = durationEventCount[rounded]
			if count % 2 == 1 then
				barInfo = self:Voidswarm()
			else
				barInfo = self:SuffocatingDarkness()
			end
		end

	elseif stage == 2 then
		if rounded == 3 then
			barInfo = self:NullGate()
		elseif rounded == 15 then
			barInfo = self:Negation()
		elseif rounded == 10 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			local count = durationEventCount[rounded]
			if count == 1 then -- on stage start
				barInfo = self:Negation()
			else
				barInfo = trackBar(self:NullGate())
			end
		elseif rounded == 61 then
			barInfo = self:EightfoldEclipse()
		end
	end

	self:HandleBar(barInfo, eventInfo)
end

-- function mod:EasyTimeline(_, eventInfo)
-- 	if eventInfo.source ~= 0 or self:IsWiping() then return end
-- 	local barInfo = nil

-- 	-- Straight to backup bars
-- 	self:HandleBar(barInfo, eventInfo, true)
-- end

function mod:HandleBar(barInfo, eventInfo, noAfterBossError)
	local eventID = eventInfo and eventInfo.id or 0
	if barInfo then
		local duration = barInfo.duration or (eventInfo and eventInfo.duration)
		-- delay extends the duration (ie, to correspond to the end of a cast instead of the start)
		local delay = barInfo.delay or 0
		if delay ~= 0 then
			if type(duration) == "table" then
				duration[1] = duration[1] + delay
			else
				duration = duration + delay
			end
		end
		local spellIndicators = eventID > 0 and eventID -- don't try to show indicators for fake events

		if barInfo.finishOnDuration then
			local finishDuration = (type(duration) == "table" and duration[1] or duration) - delay
			barInfo._stopTimer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, finishDuration)
		end

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

	-- everything is canceled when stage 1 ends, but the queued bars aren't tied to their events anymore
	if state == 3 and self:GetStage() == 1 and next(trackedBars) then -- Canceled
		self:StopTrackedBars()
		-- self:StageTwoStart() -- XXX if this is reliable, we can start the p2 bars early
	end

	if barInfo and not barInfo.ignoreState then
		if state == 2 then -- Finished
				if barInfo.delay then
					if barInfo.onFinished and self:ShouldShowBars() and not self:IsWiping() then
						barInfo:onFinished()
					end
					barInfo._delayTimer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, barInfo.delay)
				else
					self:StopBar(barInfo.msg)
					if barInfo.onFinished and self:ShouldShowBars() and not self:IsWiping() then
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
	if barInfo.state == 2 or barInfo.state == 3 then return end -- already ended

	-- Clean up barInfo.finishOnDuration
	if barInfo._stopTimer then
		self:CancelTimer(barInfo._stopTimer)
		barInfo._stopTimer = nil
	end

	-- Handle delayed events: onFinished called on normal finish, onFinishedDelayed called after the delay
	if isFinished and barInfo.delay and not barInfo._delayTimer then
		if barInfo.onFinished and self:ShouldShowBars() and not self:IsWiping() then
			barInfo:onFinished()
		end
		barInfo._delayTimer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, isFinished) end, barInfo.delay)
		barInfo.ignoreState = true -- don't get canceled
		return

	elseif not isFinished and barInfo._delayTimer then
		self:CancelTimer(barInfo._delayTimer)
		barInfo._delayTimer = nil
	end

	self:StopBar(barInfo.msg)
	local callback = barInfo.delay and "onFinishedDelayed" or "onFinished"
	if isFinished and barInfo[callback] and self:ShouldShowBars() and not self:IsWiping() then
		barInfo[callback](barInfo)
	end

	barInfo.state = isFinished and 2 or 3 -- Finished/Canceled
	if barInfo.eventID then
		activeBars[barInfo.eventID] = nil
	end
end

function mod:StopTrackedBars()
	for i = #trackedBars, 1, -1 do
		self:StopTimelineBar(trackedBars[i])
		trackedBars[i] = nil
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:StageTwoStart(isTimelineEvent)
	self:StopTrackedBars()
	self:SetStage(2)
	durationEventCount = {}

	if self:ShouldShowBars() then
		self:Message("stages", "cyan", self:GetRename("stages"), false) -- Stage 2
		self:PlaySound("stages", "long")

		-- if not isTimelineEvent then
		-- 	local offset = 8 -- 8s from _ADDED
		-- 	self:Bar(1308873, 1 + offset, CL.count:format(self:GetRename(1308873), 1)) -- Null Gate
		-- 	self:Bar(1318467, 10 + offset, CL.count:format(self:GetRename(1318467), 1)) -- Negation
		-- end
	end
end

-- Stage One

function mod:Voidswarm()
	local barText = CL.count:format(self:GetRename(1301511), voidswarmCount)
	voidswarmCount = voidswarmCount + 1
	return {
		msg = barText,
		key = 1301511,
		onFinished = function()
			self:StopBlizzMessages(1)
			self:Message(1301511, "cyan", CL.incoming:format(barText))
			self:PlaySound(1301511, "info")
		end,
	}
end

function mod:TwistedAppendage()
	local barText = CL.count:format(self:GetRename(1303681), appendageCount)
	appendageCount = appendageCount + 1
	return {
		msg = barText,
		key = 1303681,
		onFinished = function()
			self:Message(1303681, "yellow", barText)
			self:PlaySound(1303681, "alarm")
		end,
	}
end

function mod:DarkDevastation()
	local barText = CL.count:format(self:GetRename(1304930), devastationCount)
	devastationCount = devastationCount + 1
	local delay = not self:Tank() and 4 or nil -- show timer to the damage for non-tanks
	return {
		msg = barText,
		key = 1304930,
		delay = delay,
		onFinished = function()
			self:Message(1304930, "purple", CL.casting:format(barText))
			self:PlaySound(1304930, "alert")
			if self:Tank() then
				self:CastBar(1304930, 4, 2)
			end
		end,
	}
end

function mod:Extinguish(duration)
	local count = extinguishCount
	local barText = CL.count:format(self:GetRename(1304424), count)
	extinguishCount = extinguishCount + 1

	if self:ShouldShowBars() then
		self:Bar(1304508, duration + 2, CL.count:format(self:GetRename(1304508), count)) -- Light's Embrace
	end

	return {
		msg = barText,
		key = 1304424,
		delay = self:Mythic() and 7 or 8, -- show timer to the damage
		count = count,
		onFinished = function()
			self:StopBlizzMessages(1)
			self:Message(1304424, "red", CL.casting:format(barText))
			self:PlaySound(1304424, "alarm")
		end,
		onCanceled = function(this)
			self:StopBar(CL.count:format(self:GetRename(1304508), this.count)) -- Light's Embrace
		end,
	}
end

function mod:UnspeakableHorrors()
	local barText = CL.count:format(self:GetRename(1304045), horrorsCount)
	horrorsCount = horrorsCount + 1
	return {
		msg = barText,
		key = 1304045,
		onFinished = function()
			-- self:PersonalMessageFromBlizzMessage
			self:Message(1304045, "orange", barText)
			if self:Healer() then
				self:PlaySound(1304045, "alert")
			end
		end,
	}
end

function mod:SuffocatingDarkness()
	local barText = CL.count:format(self:GetRename(1302951), darknessCount)
	darknessCount = darknessCount + 1
	return {
		msg = barText,
		key = 1302951,
		onFinished = function()
			self:StopBlizzMessages(1)
			self:Message(1302951, "cyan", barText)
			self:PlaySound(1302951, "long")
		end,
	}
end

function mod:AbyssalGrasp()
	local barText = CL.count:format(self:GetRename(1303406), graspCount)
	graspCount = graspCount + 1
	return {
		msg = barText,
		key = 1303406,
		onFinished = function()
			-- self:PersonalMessageFromBlizzMessage
			self:Message(1303406, "yellow", barText)
			if self:Healer() then
				self:PlaySound(1303406, "alert")
			end
		end,
	}
end

function mod:DivineRadiance()
	local barText = CL.count:format(self:GetRename(1303169), radianceCount)
	radianceCount = radianceCount + 1
	return {
		msg = barText,
		key = 1303169,
		delay = 4, -- timer to when boss is stunned
		-- onFinished = function()
		-- 	mod:ResetCounts()
		-- end,
		onFinishedDelayed = function()
			self:Message(1303169, "cyan", barText)
			self:PlaySound(1303169, "long")
		end,
	}
end

-- Stage Two

function mod:NullGate()
	local barText = CL.count:format(self:GetRename(1308873), nullGateCount)
	nullGateCount = nullGateCount + 1
	return {
		msg = barText,
		key = 1308873,
		onFinished = function()
			self:Message(1308873, "yellow", barText)
			self:PlaySound(1308873, "alarm")
		end,
	}
end

function mod:Negation()
	local barText = CL.count:format(self:GetRename(1318467), negationCount)
	negationCount = negationCount + 1
	return {
		msg = barText,
		key = 1318467,
		onFinished = function()
			self:Message(1318467, "purple", barText)
			self:PlaySound(1318467, "alert")
		end,
	}
end

function mod:EightfoldEclipse()
	local barText = self:GetRename(1301479)
	return {
		msg = barText,
		key = 1301479,
		onFinished = function()
			self:Message(1301479, "red", barText)
			self:PlaySound(1301479, "long")
		end,
	}
end
