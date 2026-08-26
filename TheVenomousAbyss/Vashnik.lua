
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vashnik the Malignant", 3004, 2882)
if not mod then return end
mod:RegisterEnableMob(259181) -- Vashnik <The Malignant>
mod:SetEncounterID(3455)
mod:SetRespawnTime(30)
mod:UseCustomTimers(true)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}
local durationEventCount = {}
local spellCount = {}

local gapTimer do
	-- blizzard fires sets of bars on an 84s interval, these bridge the gap
	-- between the last bar of a set and the first bar of the next set
	local timersHeroic = {
		[1283164] = { -- Imbibe
			[20] = 84, -- pull
			[80] = 84,
		},
		[1282525] = { -- Malignant Catalyst
			[39] = 45,
		},
		[1281907] = { -- Plague Froth
			[13] = 41, -- pull
			[33] = 51,
		},
		[1280935] = { -- Dripping Fangs
			[8] = 29, -- pull
			[28] = 29,
		},
		[1282117] = { -- Adaptive Infection
			[52] = 32,
		},
	}
	local timersNormal = {
		[1283164] = { -- Imbibe
			[20] = 84, -- pull
			[80] = 84,
		},
		[1281907] = { -- Plague Froth
			[13] = 21, -- pull
			[26] = 22,
		},
		[1280935] = { -- Dripping Fangs
			[8] = 18, -- pull
			[30] = 21,
		},
		[1282117] = { -- Adaptive Infection
			[32] = 52,
		},
	}
	function gapTimer(spellId, duration)
		local timers = mod:Easy() and timersNormal or timersHeroic
		if timers and timers[spellId] then
			if duration == true then
				return timers[spellId] ~= nil
			end
			return timers[spellId][duration]
		end
	end
end

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:SetDefaultLocale({
	malignant_catalyst = "Catalyst", -- Short for Malignant Catalyst
})

--------------------------------------------------------------------------------
-- Renames
--

mod:SetRenames({
	[1283164] = {1283164}, -- Imbibe
	[1282525] = {L.malignant_catalyst}, -- Malignant Catalyst
	[1282117] = {CL.debuffs}, -- Adaptive Infection
	[1281907] = {CL.waves}, -- Plague Froth
	[1280935] = {CL.tank_hit}, -- Dripping Fangs
})

--------------------------------------------------------------------------------
-- Options
--

mod:SetAuraData({
	{1295173, soundOnApplied = "warning", soundOnAppliedDose = "none", header = CL.important, note = CL.dispel}, -- Exploding Infection
	{1281908, 1281913, soundOnApplied = "warning", duration = 6}, -- Plague Froth (Heroic & Mythic)
	{1295224, soundOnApplied = "warning"}, -- Siphoning Infection (Main debuff)
	{1280934, soundOnApplied = "none", soundOnAppliedDose = "none", header = CL.general, note = CL.tank_debuff}, -- Dripping Fangs
	{1295380, soundOnApplied = "info"}, -- Siphoning Infection (Healing main debuffed player)
	{1294994, soundOnApplied = "none"}, -- Stygian Infection
	{1282117, soundOnApplied = "none", duration = 10}, -- Adaptive Infection
	{1304459, soundOnApplied = "none", soundOnAppliedDose = "none", mythic = true, note = CL.mythic}, -- Malignance
	{1297338, soundOnApplied = "underyou"}, -- Deadly Venom (Standing in venom?)
	{1291461, soundOnApplied = "underyou"}, -- Virulent Fumes
	{1285979, soundOnApplied = "none", soundOnAppliedDose = "none", header = CL.adds}, -- Caustic Surge
	{1280189, soundOnApplied = "none", soundOnAppliedDose = "none"}, -- Malignant Burst
	{1305833, soundOnApplied = "none", soundOnAppliedDose = "none"}, -- Congealing Bolt
})


function mod:GetOptions()
	return {
		1283164, -- Imbibe ,"CASTBAR", "CASTBAR_COUNTDOWN"}
		1282525, -- Malignant Catalyst
		1281907, -- Plague Froth
		{1280935, "TANK"}, -- Dripping Fangs
		1282117, -- Adaptive Infection
	}
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	backupBars = {}
	if self:Easy() then
	   self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "EasyTimeline")
	else
	   self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "OtherTimeline")
	end
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
end

function mod:OnEncounterStart()
	activeBars = {}
	durationEventCount = {}

	spellCount = {
		[1283164] = 1, -- Imbibe
		[1282525] = 1, -- Malignant Catalyst
		[1281907] = 1, -- Plague Froth
		[1280935] = 1, -- Dripping Fangs
		[1282117] = 1, -- Adaptive Infection
	}
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:OtherTimeline(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo

	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	if rounded == 13 then -- Plague Froth on the pull, Dripping Fangs in every set after
		durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
		if durationEventCount[rounded] == 1 then
			barInfo = self:PlagueFroth()
		else
			barInfo = self:DrippingFangs()
		end
	elseif rounded == 20 or rounded == 80 then
		barInfo = self:Imbibe()
	elseif rounded == 30 or rounded == 33 then
		barInfo = self:PlagueFroth()
	elseif rounded == 8 or rounded == 27 or rounded == 28 then
		barInfo = self:DrippingFangs()
	elseif rounded == 18 or rounded == 52 then
		barInfo = self:AdaptiveInfection()
	elseif rounded == 6 or rounded == 39 then
		barInfo = self:MalignantCatalyst()
	end

	self:HandleBar(barInfo, eventInfo)
end

function mod:EasyTimeline(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo

	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	if rounded == 20 or rounded == 80 then
		barInfo = self:Imbibe()
	elseif rounded == 13 or rounded == 10 or rounded == 17 or rounded == 36 or rounded == 26 then
		barInfo = self:PlagueFroth()
	elseif rounded == 6 or rounded == 39 then
		barInfo = self:MalignantCatalyst()
	elseif rounded == 2 or rounded == 30 or rounded == 33 then
		barInfo = self:DrippingFangs()
	elseif rounded == 32 then
		barInfo = self:AdaptiveInfection()
	elseif rounded == 8 then
		durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
		if durationEventCount[rounded] == 1 then
			barInfo = self:DrippingFangs()
		else
			barInfo = self:AdaptiveInfection()
		end
	end

	self:HandleBar(barInfo, eventInfo)
end

function mod:HandleBar(barInfo, eventInfo)
	if barInfo and gapTimer(barInfo.key, true) then
		-- blizzard fires sets of bars on an interval, bridge the gap with a normal bar
		barInfo.gapTimer = gapTimer(barInfo.key, self:RoundNumber(eventInfo.duration, 0))
		-- if the normal bar is running, use the existing duration for max time
		local remaining, total = self:BarTimeLeft(barInfo.msg)
		barInfo.duration = remaining > 0 and { eventInfo.duration, total } or nil
	end

	if barInfo then
		barInfo.eventID = eventInfo.id
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
	local state = C_EncounterTimeline.GetEventState(eventID)
	local barInfo = activeBars[eventID]

	if barInfo and barInfo.gapTimer and state == 2 then -- Finished (reuse the eventID to set the spell indicator for the next bar)
		self:Bar(barInfo.key, barInfo.gapTimer, CL.count:format(self:GetRename(barInfo.key, barInfo.renamePosition), spellCount[barInfo.key]), nil, eventID)
	end

	if barInfo then
		if state == 2 then -- Finished
			activeBars[eventID] = nil
			self:StopBar(barInfo.msg)
			if barInfo.onFinished and self:ShouldShowBars() then
				barInfo:onFinished()
			end
		elseif state == 3 then -- Canceled
			activeBars[eventID] = nil
			self:StopBar(barInfo.msg)
			if barInfo.onCanceled and self:ShouldShowBars() then
				barInfo:onCanceled()
			end
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

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Imbibe()
	local barText = CL.count:format(self:GetRename(1283164), spellCount[1283164])
	spellCount[1283164] = spellCount[1283164] + 1

	return {
		msg = barText,
		key = 1283164,
		onFinished = function()
			self:Message(1283164, "cyan", barText)
			-- self:CastBar(1283164, 6, self:GetRename(1283164, 2))
			self:PlaySound(1283164, "long")
			self:StopBlizzMessages(2) -- Vashnik creates venom from Fountains of Ula'tek!
		end
	}
end

function mod:MalignantCatalyst()
	local barText = CL.count:format(self:GetRename(1282525), spellCount[1282525])
	local messageText = CL.casting:format(barText)
	spellCount[1282525] = spellCount[1282525] + 1

	return {
		msg = barText,
		key = 1282525,
		onFinished = function()
			self:Message(1282525, "orange", messageText)
			self:PlaySound(1282525, "alert")
			self:StopBlizzMessages(2) -- Vashnik conjures an orb of venom above the Malignant Pit!
		end
	}
end

function mod:AdaptiveInfection()
	local barText = CL.count:format(self:GetRename(1282117), spellCount[1282117])
	spellCount[1282117] = spellCount[1282117] + 1

	return {
		msg = barText,
		key = 1282117,
		onFinished = function()
			self:Message(1282117, "red", barText)
			-- self:PlaySound(1282117, "alert")
		end,
	}
end

function mod:PlagueFroth()
	local barText = CL.count:format(self:GetRename(1281907), spellCount[1281907])
	spellCount[1281907] = spellCount[1281907] + 1

	return {
		msg = barText,
		key = 1281907,
		onFinished = function()
			self:Message(1281907, "yellow", barText)
			-- self:PlaySound(1281907, "alarm")
		end,
	}
end

function mod:DrippingFangs()
	local barText = CL.count:format(self:GetRename(1280935), spellCount[1280935])
	spellCount[1280935] = spellCount[1280935] + 1

	return {
		msg = barText,
		key = 1280935,
		onFinished = function()
			self:Message(1280935, "purple", barText)
			-- self:PlaySound(1280935, "alarm") -- tank hit
		end
	}
end
