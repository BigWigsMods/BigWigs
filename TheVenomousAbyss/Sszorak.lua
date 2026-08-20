
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Sszorak", 3004, 2871)
if not mod then return end
mod:RegisterEnableMob(257347)
mod:SetEncounterID(3420)
mod:SetRespawnTime(30)
mod:UseCustomTimers(true)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}

local durationEventCount = {}

local maelstromCount = 1
local predatorCount = 1
local surgeCount = 1
local crosswindsCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:SetDefaultLocale({
	raging_crosswinds = "Winds",
})

--------------------------------------------------------------------------------
-- Renames
--

mod:SetRenames({
	[1285732] = {1285732}, -- Howling Maelstrom
	[1296898] = {26662, CL.custom_end:format(mod.displayName, mod:SpellName(26662)), notes = {CL.timerNote, CL.messageNote}}, -- Unbound Ferocity
	[1277025] = {CL.tank_combo}, -- Apex Predator
	[1305959] = { -- Venomous Surge
		CL.bombs, CL.you:format(CL.bomb),
		notes = {CL.generalNote, CL.messageOnYouNote},
		original = {1305959, CL.you:format(mod:SpellName(1305959))}
	},
	[1285425] = { -- Raging Crosswinds
		L.raging_crosswinds, CL.you:format(L.raging_crosswinds),
		notes = {CL.generalNote, CL.messageOnYouNote},
		original = {1285425, CL.you:format(mod:SpellName(1285425))}
	},
})

--------------------------------------------------------------------------------
-- Options
--

mod:SetAuraData({
	{1277105, soundOnApplied = "none", soundOnAppliedDose = "none", note = CL.tank_frontal}, -- Ravage
	{1277051, soundOnApplied = "none", duration = 22, note = "Frontal soaked"}, -- Mutilated Gash
	{1287083, soundOnApplied = "alarm", soundOnAppliedDose = "none"}, -- Tempest
	{1305963, soundOnApplied = "warning", duration = 10}, -- Venomous Surge
	{1296667, soundOnApplied = "underyou"}, -- Caustic Residue
	{1285425, soundOnApplied = "none", duration = 8, note = CL.north}, -- Raging Crosswinds (North)
	{1285453, soundOnApplied = "none", duration = 8, note = CL.south}, -- Raging Crosswinds (South)
	{1297096, soundOnApplied = "none", duration = 8, note = CL.east}, -- Raging Crosswinds (East)
	{1297111, soundOnApplied = "none", duration = 8, note = CL.west}, -- Raging Crosswinds (West)
	{1305621, soundOnApplied = "warning", mythic = true}, -- Serpent's Fury,
	{1297707, soundOnApplied = "warning", duration = 5, note = CL.left, mythic = true}, -- Virulence (Left)
	{1299899, soundOnApplied = "warning", duration = 5, note = CL.right, mythic = true}, -- Virulence (Right)
})

function mod:GetOptions()
	return {
		1285732, -- Howling Maelstrom
		1277025, -- Apex Predator
		1305959, -- Venomous Surge
		1285425, -- Raging Crosswinds
		-- Mythic
		1296898, -- Unbound Ferocity
	}, {
		[1296898] = "mythic",
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
	durationEventCount = {}

	maelstromCount = 1
	predatorCount = 1
	surgeCount = 1
	crosswindsCount = 1
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:ENCOUNTER_TIMELINE_EVENT_ADDED(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo = nil

	-- local stage = self:GetStage()
	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	-- mythic / heroic / normal
	if rounded == 100 or rounded == 111 or rounded == 125 then
		barInfo = self:HowlingMaelstrom()
	elseif rounded == 5 or rounded == 6 then
		barInfo = self:ApexPredator()
	elseif rounded == 29 or rounded == 32 or rounded == 36 then
		barInfo = self:VenomousSurge()
	elseif rounded == 39 or rounded == 43 or rounded == 49 then
		barInfo = self:RagingCrosswinds()
	elseif rounded == 47 or rounded == 52 or rounded == 59 then
		durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
		local count = durationEventCount[rounded]
		if count % 3 == 1 then
			barInfo = self:ApexPredator()
		elseif count % 3 == 2 then
			barInfo = self:VenomousSurge()
		else -- if count % 3 == 0 then
			-- this gets finished when the debuffs go out for the previous cast x.x
			barInfo = self:RagingCrosswinds()
			barInfo.skipState = true
			self:ScheduleTimer(function()
				self:StopBar(barInfo.msg)
				barInfo:onFinished()
			end, duration)
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
	local state = C_EncounterTimeline.GetEventState(eventID)

	local barInfo = activeBars[eventID]
	if barInfo and not barInfo.skipState then
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

function mod:UnboundFerocityMessage()
	self:Message(1296898, "red", self:GetRename(1296898, 2)) -- Unbound Ferocity
	self:PlaySound(1296898, "alarm")
end

function mod:HowlingMaelstrom()
	local barText = CL.count:format(self:GetRename(1285732), maelstromCount)
	maelstromCount = maelstromCount + 1
	return {
		msg = barText,
		key = 1285732,
		onFinished = function()
			self:Message(1285732, "red", barText)
			self:PlaySound(1285732, "long")
		end,
		onCanceled = function() -- XXX gets canceled instead of finished
			self:Message(1285732, "red", barText)
			self:PlaySound(1285732, "long")
		end,
	}
end

function mod:ApexPredator()
	local barText = CL.count:format(self:GetRename(1277025), predatorCount)
	predatorCount = predatorCount + 1
	return {
		msg = barText,
		key = 1277025,
		onFinished = function()
			self:Message(1277025, "purple", barText)
			self:PlaySound(1277025, "alert")
		end,
	}
end

function mod:VenomousSurge()
	local barText = CL.count:format(self:GetRename(1305959), surgeCount)
	surgeCount = surgeCount + 1
	return {
		msg = barText,
		key = 1305959,
		onFinished = function()
			-- 2 Viscous Cyst targets over the duration of the channel
			-- Unbound Ferocity (100 energy mythic enrage) can trigger during casts and channels, both of these are severity 2 :\
			self:Message(1305959, "yellow", barText)
			self:PlaySound(1305959, "alarm")
		end,
	}
end

function mod:RagingCrosswinds()
	local barText = CL.count:format(self:GetRename(1285425), crosswindsCount)
	crosswindsCount = crosswindsCount + 1
	return {
		msg = barText,
		key = 1285425,
		onFinished = function()
			self:PersonalMessageFromBlizzMessage(1285425, 1, false, self:GetRename(1285425, 2))

			self:Message(1285425, "orange", barText)
			-- self:PlaySound(1285425, "alert")
		end,
	}
end
