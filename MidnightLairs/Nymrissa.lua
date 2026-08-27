
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
local swirlingWhirlpoolsCount = 1
local abyssalRainCount = 1
local icebladeFlurryCount = 1
local waterJetCount = 1

local spellChoiceCount = 1

--------------------------------------------------------------------------------
-- Localization
--

-- local L = mod:SetDefaultLocale({ -- SetOption:skip-locale
-- })

--------------------------------------------------------------------------------
-- Renames
--

mod:SetRenames({
	[1276710] = {CL.adds}, -- Alluring Bubble (Adds)
	[1257717] = {1257717}, -- Alluring Bubble
	[1258668] = {1258668}, -- Swirling Whirlpools
	[1260837] = {1260837}, -- Abyssal Rain
	[1282937] = {CL.tank_hit}, -- Iceblade Flurry (Tank Hit)
	[1313393] = {1313393}, -- Chilling Frost
	-- Mythic
	[1268562] = {CL.tank_hit}, -- Water Jet
})

--------------------------------------------------------------------------------
-- Options
--

mod:SetAuraData({
	{1313393, soundOnApplied = "warning", duration = 5, header = CL.important}, -- Chilling Frost
	{1258901, soundOnApplied = "warning", soundOnAppliedDose = "none", mythic = true}, -- Water Jet

	{1260843, soundOnApplied = "none", header = CL.general}, -- Abyssal Rain
	{1313448, soundOnApplied = "none", duration = 16}, -- Frost Orb
	{1257654, soundOnApplied = "none"}, -- Lingering Frost
	{1295086, soundOnApplied = "none"}, -- Unending Tides
	{1282947, soundOnApplied = "alarm", duration = 5}, -- Iceblade Flurry (DoT)
	{1282947, soundOnApplied = "none", note = CL.tank_debuff}, -- Iceblade Flurry (Vulnerability)
	{1260637, soundOnApplied = "none", mythic = true, note = CL.tank_debuff}, -- Water Jet (Vulnerability)
})

function mod:GetOptions()
	return {
		1276710, -- Alluring Bubble
		1257717, -- Alluring Bubble
		1258668, -- Swirling Whirlpools
		1260837, -- Abyssal Rain
		1282937, -- Iceblade Flurry
		1313393, -- Chilling Frost

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
	swirlingWhirlpoolsCount = 1
	abyssalRainCount = 1
	icebladeFlurryCount = 1
	waterJetCount = 1
	spellChoiceCount = 1
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:ENCOUNTER_TIMELINE_EVENT_ADDED(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo = nil

	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 0)

	if durationRounded == 44 then
		if spellChoiceCount == 1 then
			barInfo = self:AlluringBubbleAdds(eventInfo)
		elseif spellChoiceCount == 2 then
			barInfo = self:ChillingFrost(eventInfo)
		elseif spellChoiceCount == 3 then
			barInfo = self:AbyssalRain(eventInfo)
		end
		spellChoiceCount = spellChoiceCount + 1
		if spellChoiceCount > 3 then
			spellChoiceCount = 1
		end
	elseif duration == 18 then
		barInfo = self:AlluringBubble(eventInfo)
	elseif durationRounded == 8 or durationRounded == 23 or durationRounded == 33 then
		barInfo = self:AbyssalRain(eventInfo)
	elseif durationRounded == 22 or durationRounded == 27 or durationRounded == 9 then
		barInfo = self:IcebladeFlurry(eventInfo)
	elseif durationRounded == 25 or durationRounded == 7 then
		barInfo = self:AlluringBubbleAdds(eventInfo)
	elseif durationRounded == 107 or durationRounded == 89 then
		barInfo = self:SwirlingWhirlpools(eventInfo)
	elseif durationRounded == 35 or durationRounded == 17 then
		barInfo = self:ChillingFrost(eventInfo)
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

function mod:AlluringBubbleAdds(eventInfo) -- Adds
	local barText = CL.count:format(self:GetRename(1276710), alluringBubbleCount)
	alluringBubbleCount = alluringBubbleCount + 1
	self:ScheduleTimer(function() -- onFinished doesn't fire, timer just pauses until it expires
		self:Message(1276710, "cyan", barText)
		self:PlaySound(1276710, "info")
	end, eventInfo.duration)
	return {
		msg = barText,
		key = 1276710,
		onFinished = function()
			self:Message(1276710, "cyan", barText)
			self:PlaySound(1276710, "info")
		end
	}
end

function mod:AlluringBubble()
	local barText = CL.count:format(self:GetRename(1257717), alluringBubbleCount)
	alluringBubbleCount = alluringBubbleCount + 1
	return {
		msg = barText,
		key = 1257717,
		onFinished = function()
			self:Message(1257717, "cyan", barText)
		end
	}
end

function mod:SwirlingWhirlpools()
	local barText = CL.count:format(self:GetRename(1258668), swirlingWhirlpoolsCount)
	swirlingWhirlpoolsCount = swirlingWhirlpoolsCount + 1
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

function mod:IcebladeFlurry() -- Tank Hit
	local barText = CL.count:format(self:GetRename(1282937), icebladeFlurryCount)
	icebladeFlurryCount = icebladeFlurryCount + 1
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

function mod:ChillingFrost()
	local barText = CL.count:format(self:GetRename(1313393), waterJetCount)
	waterJetCount = waterJetCount + 1
	return {
		msg = barText,
		key = 1313393,
		onFinished = function()
			self:Message(1313393, "yellow", barText)
			-- self:PlaySound(1313393, "alarm")
		end
	}
end
