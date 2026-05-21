if not BigWigsLoader.isNext then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Rotmire", 1592, 2711)
if not mod then return end
mod:RegisterEnableMob(254176)
mod:SetEncounterID(3159)
mod:SetRespawnTime(30)
mod:UseCustomTimers(true)

--------------------------------------------------------------------------------
-- Locals

local activeBars = {}
local backupBars = {}
local countForDuration = {}

local fungalBloomCount = 1
local awakenFungiCount = 1
local burstingPustulesCount = 1
local putridFistCount = 1
local festeringVinesCount = 1

--------------------------------------------------------------------------------
-- Localization
--

-- local L = mod:SetDefaultLocale({ -- SetOption:skip-locale
-- })

--------------------------------------------------------------------------------
-- Renames
--

--mod:SetRenames({
--	[1221622] = {}, -- Awaken Fungi ()
--	[1221637] = {}, -- Fungal Bloom ()
--	[1222088] = {}, -- Festering Vines ()
--	[1221787] = {}, -- Bursting Pustules ()
--	[1221781] = {}, -- Putrid Fist ()
--})

--------------------------------------------------------------------------------
-- Options
--

mod:SetPrivateAuraSounds({
	1221639, -- Shroomling fixate
	1299508, -- Fungling fixate
	{1222088, sound = "alarm"}, -- Festering Vines
	{1221714, sound = "none"}, -- Poison Burst
})

function mod:GetOptions()
	return {
		1221622, -- Awaken Fungi
		1221637, -- Fungal Bloom
		1222088, -- Festering Vines
		1221787, -- Bursting Pustules
		1221781, -- Putrid Fist
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
	countForDuration = {}

	fungalBloomCount = 1
	awakenFungiCount = 1
	burstingPustulesCount = 1
	putridFistCount = 1
	festeringVinesCount = 1
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:ENCOUNTER_TIMELINE_EVENT_ADDED(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo = nil

	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 0)


	if durationRounded == 8 or durationRounded == 21 then -- Bursting Pustules
		barInfo = self:BurstingPustules(duration)
	elseif durationRounded == 13 then
		countForDuration[durationRounded] = (countForDuration[durationRounded] or 0) + 1
		if countForDuration[durationRounded] % 2 == 1 then -- Awaken Fungi -> Putred Fist
			barInfo = self:AwakenFungi(duration)
		else
			barInfo = self:PutridFist(duration)
		end
	elseif durationRounded == 24 or durationRounded == 12 then -- Putrid Fist
		barInfo = self:PutridFist(duration)
	elseif durationRounded == 41 then -- Festering Vines
		barInfo = self:FesteringVines(duration)
	elseif durationRounded == 114 then -- Fungal Bloom
		barInfo = self:FungalBloom(duration)
	elseif durationRounded == 49 then
		countForDuration[durationRounded] = (countForDuration[durationRounded] or 0) + 1
		if countForDuration[durationRounded] % 3 == 1 then -- Awaken Fungi -> Bursting Pustules -> Festering Vines
			barInfo = self:AwakenFungi(duration)
		elseif countForDuration[durationRounded] % 3 == 2 then
			barInfo = self:BurstingPustules(duration)
		else
			barInfo = self:FesteringVines(duration)
		end
	end

	if barInfo then
		barInfo.eventID = eventInfo.id
		barInfo.duration = barInfo.duration or eventInfo.duration
		activeBars[eventInfo.id] = barInfo
		if self:ShouldShowBars() then
			self:Bar(barInfo.key, barInfo.duration, barInfo.msg, barInfo.icon, eventInfo.id)
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
		if state == 2 or state == 3 then -- Finished or Canceled
			self:StopBar(barInfo.msg)
			if self:ShouldShowBars() then
				if state == 2 and barInfo.onFinished then
					barInfo:onFinished()
				elseif state == 3 and barInfo.onCanceled then
					barInfo:onCanceled()
				end
			end

			activeBars[eventID] = nil
		end
	elseif backupBars[eventID] then
		local newState = C_EncounterTimeline.GetEventState(eventID)
		if newState == 0 then
			self:SendMessage("BigWigs_ResumeBar", nil, nil, eventID)
		elseif newState == 1 then
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventID)
		elseif newState == 2 or newState == 3 then
			self:SendMessage("BigWigs_StopBar", nil, nil, eventID)
		end
	end
end

function mod:ENCOUNTER_TIMELINE_EVENT_REMOVED(_, eventID)
	activeBars[eventID] = nil
	backupBars[eventID] = nil
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:AwakenFungi(duration)
	local barText = CL.count:format(self:SpellName(1221622), awakenFungiCount)
	awakenFungiCount = awakenFungiCount + 1
	return {
		msg = barText,
		key = 1221622,
		onFinished = function()
			self:Message(1221622, "cyan", barText)
			self:StopBlizzMessages(1)
			self:PlaySound(1221622, "info", "adds")
		end
	}
end

function mod:FungalBloom(duration)
	local barText = CL.count:format(self:SpellName(1221637), fungalBloomCount)
	fungalBloomCount = fungalBloomCount + 1
	return {
		msg = barText,
		key = 1221637,
		onFinished = function()
			self:Message(1221637, "yellow", barText)
			self:StopBlizzMessages(1)
			-- self:PlaySound(1221637, "alert")
		end
	}
end

function mod:FesteringVines(duration)
	local barText = CL.count:format(self:SpellName(1222088), festeringVinesCount)
	festeringVinesCount = festeringVinesCount + 1
	return {
		msg = barText,
		key = 1222088,
		onFinished = function()
			self:Message(1222088, "yellow", barText)
			self:PersonalMessageFromBlizzMessage(1222088, 0.5, nil, self:SpellName(1222088))
			-- self:PlaySound(1222088, "alert")
		end
	}
end

function mod:BurstingPustules(duration)
	local barText = CL.count:format(self:SpellName(1221787), burstingPustulesCount)
	burstingPustulesCount = burstingPustulesCount + 1
	return {
		msg = barText,
		key = 1221787,
		onFinished = function()
			self:Message(1221787, "yellow", barText)
			-- self:PlaySound(1221787, "alert")
		end
	}
end

function mod:PutridFist(duration)
	local barText = CL.count:format(self:SpellName(1221781), putridFistCount)
	putridFistCount = putridFistCount + 1
	return {
		msg = barText,
		key = 1221781,
		onFinished = function()
			self:Message(1221781, "purple", barText)
			-- self:PlaySound(1221781, "alert")
		end
	}
end
