if not BigWigsLoader.isNext then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nymrissa Wavecaller", 2987, 2849)
if not mod then return end
mod:RegisterEnableMob(252959) -- Verify
mod:SetEncounterID(3379)
mod:SetRespawnTime(30)
mod:UseCustomTimers(true)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}

local alluringBubbleCount = 1
local frostBarrageCount = 1
local tidepiercersRushCount = 1
local abyssalRainCount = 1
local waterFlurryCount = 1
local waterJetCount = 1

--------------------------------------------------------------------------------
-- Localization
--

-- local L = mod:SetDefaultLocale({ -- SetOption:skip-locale
-- })

--------------------------------------------------------------------------------
-- Renames
--

mod:SetRenames({
	[1257717] = {1257717}, -- Alluring Bubble
	[1257608] = {1257608}, -- Frost Barrage
	[1258668] = {1258668}, -- Tidepiercer's Rush
	[1260837] = {1260837}, -- Abyssal Rain
	[1282937] = {1282937}, -- Water Flurry
	-- Mythic
	[1268562] = {CL.tank_hit}, -- Water Jet
})

--------------------------------------------------------------------------------
-- Options
--

mod:SetAuraData({
    {1257608, soundOnApplied = "warning", header = CL.important}, -- Frost Barrage
    {1282937, soundOnApplied = "warning"}, -- Water Flurry
    {1282404, soundOnApplied = "none", header = CL.general}, -- Drenched
    {1257651, soundOnApplied = "none"}, -- Drifting Globules
    {1257644, soundOnApplied = "none"}, -- Frost Barrage
    {1257654, soundOnApplied = "none"}, -- Lingering Frost
    {1295086, soundOnApplied = "none"}, -- Unending Tides
    {1282947, soundOnApplied = "none"}, -- Water Flurry
    {1258901, soundOnApplied = "none", header = CL.mythic}, -- Water Jet
})

function mod:GetOptions()
	return {
		1257717, -- Alluring Bubble
		1257608, -- Frost Barrage
		1258668, -- Tidepiercer's Rush
		1260837, -- Abyssal Rain
		1282937, -- Water Flurry

		-- Mythic
		{1268562, "TANK"}, -- Water Jet
	}
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	backupBars = {}
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
end

function mod:OnEncounterStart()
	activeBars = {}

	alluringBubbleCount = 1
	frostBarrageCount = 1
	tidepiercersRushCount = 1
	abyssalRainCount = 1
	waterFlurryCount = 1
	waterJetCount = 1
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:ENCOUNTER_TIMELINE_EVENT_ADDED(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo = nil

	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 0)

	if durationRounded == 3 then
		if self:Mythic() then -- Frost Barrage on Mythic
			barInfo = self:FrostBarrage()
		else
			barInfo = self:AbyssalRain()
		end
	elseif durationRounded == 9 then -- Mythic
		barInfo = self:AbyssalRain()
	elseif durationRounded == 13 or durationRounded == 30 or durationRounded == 49 then
		barInfo = self:WaterFlurry()
	elseif durationRounded == 27 then
		barInfo = self:AlluringBubble()
	elseif durationRounded == 33 or durationRounded == 20 or durationRounded == 51
		or durationRounded == 31 or durationRounded == 24 or durationRounded == 46 then -- 31/24/46 Mythic
		barInfo = self:FrostBarrage()
	elseif durationRounded == 64 or durationRounded == 68 then -- 68 Mythic
		barInfo = self:TidepiercersRush()
	elseif durationRounded == 17 or durationRounded == 29 or durationRounded == 40 then -- Mythic
		barInfo = self:WaterJet()
	end

	if barInfo then
		activeBars[eventInfo.id] = barInfo
		if self:ShouldShowBars() then
			self:CDBar(barInfo.key, barInfo.duration or eventInfo.duration, barInfo.msg, barInfo.icon, eventInfo.id)
		end
	elseif barInfo == nil and self:ShouldShowBars() then
		self:ErrorForTimelineEvent(eventInfo)
		backupBars[eventInfo.id] = true
		self:SendMessage("BigWigs_StartBar", nil, nil, ("[B] %s"):format(eventInfo.spellName), eventInfo.duration, eventInfo.iconFileID, eventInfo.maxQueueDuration, nil, eventInfo.id, eventInfo.id)

		local state = C_EncounterTimeline.GetEventState(eventInfo.id)
		if state == 1 then -- Paused
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventInfo.id)
		end
	end
end

function mod:ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED(_, eventID)
	local barInfo = activeBars[eventID]
	if barInfo then
		local state = C_EncounterTimeline.GetEventState(eventID)
		if state == 2 then -- Finished
			activeBars[eventID] = nil
			self:StopBar(barInfo.msg)
			if barInfo.onFinished and self:ShouldShowBars() then
				barInfo.onFinished()
			end
		elseif state == 3 then -- Canceled
			activeBars[eventID] = nil
			self:StopBar(barInfo.msg)
			if barInfo.onCanceled and self:ShouldShowBars() then
				barInfo.onCanceled()
			end
		end
	elseif backupBars[eventID] then
		local state = C_EncounterTimeline.GetEventState(eventID)
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

function mod:AlluringBubble()
	local barText = CL.count:format(self:GetRename(1257717), alluringBubbleCount)
	alluringBubbleCount = alluringBubbleCount + 1
	return {
		msg = barText,
		key = 1257717,
		onFinished = function()
			self:Message(1257717, "cyan", barText)
			self:PlaySound(1257717, "info")
		end
	}
end

function mod:FrostBarrage()
	local barText = CL.count:format(self:GetRename(1257608), frostBarrageCount)
	frostBarrageCount = frostBarrageCount + 1
	return {
		msg = barText,
		key = 1257608,
		onFinished = function()
			self:Message(1257608, "yellow", barText)
			self:PlaySound(1257608, "alert")
		end
	}
end

function mod:TidepiercersRush()
	local barText = CL.count:format(self:GetRename(1258668), tidepiercersRushCount)
	tidepiercersRushCount = tidepiercersRushCount + 1
	return {
		msg = barText,
		key = 1258668,
		onFinished = function()
			self:Message(1258668, "orange", barText)
			self:PlaySound(1258668, "alarm") -- dodge
		end
	}
end

function mod:AbyssalRain()
	local barText = CL.count:format(self:GetRename(1260837), abyssalRainCount)
	abyssalRainCount = abyssalRainCount + 1
	return {
		msg = barText,
		key = 1260837,
		onFinished = function()
			self:Message(1260837, "yellow", barText)
			self:PlaySound(1260837, "long")
		end
	}
end

function mod:WaterFlurry()
	local barText = CL.count:format(self:GetRename(1282937), waterFlurryCount)
	waterFlurryCount = waterFlurryCount + 1
	return {
		msg = barText,
		key = 1282937,
		onFinished = function()
			self:Message(1282937, "yellow", barText)
			self:PlaySound(1282937, "alert")
		end
	}
end

function mod:WaterJet()
	local barText = CL.count:format(self:GetRename(1268562), waterJetCount)
	waterJetCount = waterJetCount + 1
	return {
		msg = barText,
		key = 1268562,
		onFinished = function()
			self:Message(1268562, "purple", barText)
			-- self:PlaySound(1268562, "alarm") -- tank hit
		end
	}
end
