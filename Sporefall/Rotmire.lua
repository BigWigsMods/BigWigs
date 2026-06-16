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
--

local activeBars = {}
local backupBars = {}
local countForDuration = {}

local fungalBloomCount = 1
local awakenFungiCount = 1
local burstingPustulesCount = 1
local putridFistCount = 1
local festeringVinesCount = 1

--------------------------------------------------------------------------------
-- Renames
--

mod:SetRenames({
	[1221622] = {CL.adds}, -- Awaken Fungi (Adds)
	[1221637] = {CL.full_energy}, -- Fungal Bloom (Full Energy)
	[1222088] = {CL.debuffs, CL.you:format(CL.vines), notes = {CL.generalNote, CL.messageOnYouNote}, original = {1222088, CL.you:format(mod:SpellName(1222088))}}, -- Festering Vines (Debuffs)
	[1221787] = {CL.raid_damage}, -- Bursting Pustules (Raid Damage)
	[1221781] = {CL.tank_hit}, -- Putrid Fist (Tank Hit)
})

--------------------------------------------------------------------------------
-- Options
--

mod:SetPrivateAuraSounds({
	{1221639, sound = "warning", note = CL.fixate}, -- Shroomling fixate
	{1299508, sound = "warning", note = CL.fixate}, -- Fungling fixate
	{1222088, sound = "warning", note = CL.vines}, -- Festering Vines
	{1221714, sound = "none"}, -- Poison Burst
	{1221787, sound = "none"}, -- Bursting Pustules
	{1222495, sound = "none", mythic = "true"}, -- Bursting Doom Shroom
})

function mod:GetOptions()
	return {
		1221622, -- Awaken Fungi
		1221637, -- Fungal Bloom
		1222088, -- Festering Vines
		1221787, -- Bursting Pustules
		{1221781, "TANK"}, -- Putrid Fist
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
		barInfo = self:BurstingPustules()
	elseif durationRounded == 13 then
		countForDuration[durationRounded] = (countForDuration[durationRounded] or 0) + 1
		if countForDuration[durationRounded] % 2 == 1 then -- Awaken Fungi -> Putred Fist
			barInfo = self:AwakenFungi()
		else
			barInfo = self:PutridFist()
		end
	elseif durationRounded == 24 or durationRounded == 12 then -- Putrid Fist
		barInfo = self:PutridFist()
	elseif durationRounded == 41 then -- Festering Vines
		barInfo = self:FesteringVines()
	elseif durationRounded == 114 then -- Fungal Bloom
		barInfo = self:FungalBloom()
	elseif durationRounded == 49 then
		countForDuration[durationRounded] = (countForDuration[durationRounded] or 0) + 1
		if countForDuration[durationRounded] % 3 == 1 then -- Awaken Fungi -> Bursting Pustules -> Festering Vines
			barInfo = self:AwakenFungi()
		elseif countForDuration[durationRounded] % 3 == 2 then
			barInfo = self:BurstingPustules()
		else
			barInfo = self:FesteringVines()
		end
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

function mod:AwakenFungi() -- Adds
	local barText = CL.count:format(self:GetRename(1221622), awakenFungiCount)
	awakenFungiCount = awakenFungiCount + 1
	return {
		msg = barText,
		key = 1221622,
		onFinished = function()
			self:Message(1221622, "cyan", barText)
			self:StopBlizzMessages(1)
			self:PlaySound(1221622, "info")
		end
	}
end

function mod:FungalBloom() -- Full Energy
	local barText = CL.count:format(self:GetRename(1221637), fungalBloomCount)
	fungalBloomCount = fungalBloomCount + 1
	return {
		msg = barText,
		key = 1221637,
		onFinished = function()
			self:Message(1221637, "red", barText)
			self:StopBlizzMessages(1)
			self:PlaySound(1221637, "long")
		end
	}
end

function mod:FesteringVines() -- Debuffs
	local barText = CL.count:format(self:GetRename(1222088), festeringVinesCount)
	festeringVinesCount = festeringVinesCount + 1
	return {
		msg = barText,
		key = 1222088,
		onFinished = function()
			-- XXX would be better to finish on cast end when the debuffs go out :\
			self:Message(1222088, "yellow", barText)
			self:PersonalMessageFromBlizzMessage(1222088, 2.5, false, self:GetRename(1222088, 2)) -- 2s cast + 0.5s leeway
			--self:PlaySound(1222088, "warning") -- PA sound
		end
	}
end

function mod:BurstingPustules() -- Raid Damage
	local barText = CL.count:format(self:GetRename(1221787), burstingPustulesCount)
	burstingPustulesCount = burstingPustulesCount + 1
	return {
		msg = barText,
		key = 1221787,
		onFinished = function()
			self:Message(1221787, "orange", barText)
			self:PlaySound(1221787, "alarm")
		end
	}
end

function mod:PutridFist() -- Tank Hit
	local barText = CL.count:format(self:GetRename(1221781), putridFistCount)
	putridFistCount = putridFistCount + 1
	return {
		msg = barText,
		key = 1221781,
		onFinished = function()
			self:Message(1221781, "purple", barText)
			if self:Tank() then
				self:PlaySound(1221781, "alert")
			end
		end
	}
end
