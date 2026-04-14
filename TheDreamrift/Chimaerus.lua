
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Chimaerus the Undreamt God", 2939, 2795)
if not mod then return end
mod:RegisterEnableMob(245569) -- Chimaerus
mod:SetEncounterID(3306)
mod:SetRespawnTime(30)
mod:SetStage(1)
mod:SetPrivateAuraSounds({
	{1245698, sound = "info"}, -- Alnsight
	-- 1253744, -- Rift Vulnerability (Applied at the same time as Alnsight)
	{1250953, sound = "none"}, -- Rift Sickness
	-- 1262020, -- Colossal Strikes, Used?
	{1265940, sound = "alarm"}, -- Fearsome Cry
	1264756, -- Rift Madness
	1257087, -- Consuming Miasma
	{1258192, sound = "none"}, -- Lingering Miasma
	{1246653, sound = "none"}, -- Caustic Phelgm
	{1272726, sound = "alarm"}, -- Rending Tear
})
mod:UseCustomTimers(true)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}
local durationCount = {}

local almdustUpheavalCount = 1
local riftEmergenceCount = 1
local riftMadnessCount = 1
local consumingMiasmaCount = 1
local causticPhlegmCount = 1
local rendingTearCount = 1
local consumeCount = 1
local corruptedDevastationCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.rift_madness = "Madness" -- Short for Rift Madness
	L.consuming_miasma = "Dispels" -- Move to common?
end

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		"stages",
		"berserk",
		-- Stage One: Insatiable Hunger
		1262289, -- Alndust Upheaval
		1258610, -- Rift Emergence
		1257087, -- Consuming Miasma
		{1246653, "HEALER"}, -- Caustic Phlegm
		1272726, -- Rending Tear
		1245396, -- Consume
		-- Stage Two: To The Skies
		1245486, -- Corrupted Devastation
		1245406, -- Ravenous Dive
		{1246621, "HEALER"}, -- Caustic Phlegm
		1257085, -- Consuming Miasma
		-- Mythic
		1264756, -- Rift Madness
	},{
		[1262289] = CL.stage:format(1),
		[1245486] = CL.stage:format(2),
		[1264756] = CL.mythic,
	},{
		[1262289] = CL.soak, -- Alndust Upheaval (Soak)
		[1258610] = CL.adds, -- Rift Emergence (Adds)
		[1264756] = L.rift_madness, -- Rift Madness (Madness)
		[1257087] = L.consuming_miasma, -- Consuming Miasma (Dispels)
		[1246653] = CL.raid_damage, -- Caustic Phlegm (Raid Damage)
		[1272726] = CL.frontal_cone, -- Rending Tear (Frontal Cone)
		[1245486] = CL.breath, -- Corrupted Devastation (Breath)
		[1245406] = CL.stage:format(1), -- Ravenous Dive (Stage 1)
		[1246621] = CL.raid_damage, -- Caustic Phlegm (Raid Damage)
		[1257085] = L.consuming_miasma, -- Consuming Miasma (Dispels)
	}
end

function mod:OnBossEnable()
	backupBars = {}
	if self:Mythic() then
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "TimersMythic")
	elseif self:Heroic() then
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "TimersHeroic")
	else -- Normal / LFR
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "TimersEasy")
	end
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
end

function mod:OnEncounterStart()
	self:SetStage(1)
	activeBars = {}
	durationCount = {}

	almdustUpheavalCount = 1
	riftEmergenceCount = 1
	riftMadnessCount = 1
	consumingMiasmaCount = 1
	causticPhlegmCount = 1
	rendingTearCount = 1
	consumeCount = 1
	corruptedDevastationCount = 1
end

function mod:OnBossDisable()
	for eventID in next, backupBars do
		self:SendMessage("BigWigs_StopBar", nil, nil, eventID)
	end
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--
function mod:TimersMythic(_, eventInfo)
	if eventInfo.source ~= 0 then return end
	local stage = self:GetStage()
	local durationRounded = self:RoundNumber(eventInfo.duration, 0)
	local barInfo = nil
	if stage == 1 then
		if durationRounded == 510 and self:ShouldShowBars() then -- Rift Cataclysm
			self:Berserk(eventInfo.duration, true)
			return -- no further checks needed
		elseif durationRounded == 39 then -- Rift Madness
			barInfo = self:RiftMadness(eventInfo)
		elseif durationRounded == 65 or durationRounded == 72 then -- Consume
			barInfo = self:Consume(eventInfo)
		elseif durationRounded == 36 then -- Rending Tear
			barInfo = self:RendingTear(eventInfo)
		elseif durationRounded == 6 then -- Rift Emergence
			barInfo = self:RiftEmergence(eventInfo)
		elseif durationRounded == 75  then -- Rift Emergence
			barInfo = self:RiftEmergence(eventInfo)
		elseif durationRounded == 73 then
			-- Alndust Upheaval > Rending Tear > Madness
			durationCount[durationRounded] = (durationCount[durationRounded] or 0) + 1
			if durationCount[durationRounded] == 1 then
				barInfo = self:AlndustUpheaval(eventInfo)
			elseif durationCount[durationRounded] == 2 then
				barInfo = self:RendingTear(eventInfo)
			elseif durationCount[durationRounded] == 3 then
				barInfo = self:RiftMadness(eventInfo)
			end
		elseif durationRounded == 14 then -- Alndust Upheaval
			barInfo = self:AlndustUpheaval(eventInfo)
		elseif durationRounded == 24 or durationRounded == 26 or durationRounded == 48 then -- Caustic Phlegm
			barInfo = self:CausticPhlegm(eventInfo)
		elseif durationRounded == 32 or durationRounded == 51 or durationRounded == 37 then -- Consuming Miasma
			barInfo = self:ConsumingMiasma(eventInfo)
			elseif durationRounded == 148 then -- Stage 2
			self:Bar("stages", eventInfo.duration, CL.stage:format(2), "spell_holy_borrowedtime", eventInfo.id)
			return -- no need to stop this, it gets corrected later 10s before the end.
		elseif durationRounded == 10 then -- Stage 2 (Updated)
			self:Bar("stages", {eventInfo.duration, 151}, CL.stage:format(2), "spell_holy_borrowedtime", eventInfo.id)
			self:ScheduleTimer(function()
				self:Message("stages", "cyan", CL.stage:format(2), false)
				self:PlaySound("stages", "long")
				self:SetStage(2)
				almdustUpheavalCount = 1
				riftEmergenceCount = 1
				riftMadnessCount = 1
				consumingMiasmaCount = 1
				causticPhlegmCount = 1
				rendingTearCount = 1
				corruptedDevastationCount = 1
				durationCount = {}
			end, eventInfo.duration)
			self:ScheduleTimer(function() -- Schedule an Alndust Upheaval warning for Mythic
				local barText = CL.count:format(CL.soak, almdustUpheavalCount)
				self:TargetMessageFromBlizzMessage(1, 1262289, "orange", barText)
				self:PlaySound(1262289, "warning") -- soak if assigned
			end, eventInfo.duration + 0.5)
			return
		end
	else -- Stage 2 timers
		if durationRounded == 18 or durationRounded == 9 then -- Caustic Phlegm
			barInfo = self:CausticPhlegmStage2(eventInfo)
		elseif durationRounded == 29 or durationRounded == 23 then -- Consuming Miasma
			barInfo = self:ConsumingMiasmaStage2(eventInfo)
		elseif durationRounded == 8 or durationRounded == 14 then -- Corrupted Devastation
			barInfo = self:CorruptedDevastation(eventInfo)
		elseif durationRounded == 20 or durationRounded == 1 then -- Ravenous Dive
			barInfo = self:RavenousDive(eventInfo, durationRounded == 1)
		elseif durationRounded == 12 then
			-- Corrupted Devastation > Caustic Phlegm > Corrupted Devastation > Caustic Phlegm
			durationCount[durationRounded] = (durationCount[durationRounded] or 0) + 1
			if durationCount[durationRounded] % 2 == 1 then
				barInfo = self:CorruptedDevastation(eventInfo)
			elseif durationCount[durationRounded] % 2 == 0 then
				barInfo = self:CausticPhlegmStage2(eventInfo)
			end
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
	local stage = self:GetStage()
	local durationRounded = self:RoundNumber(eventInfo.duration, 0)
	local barInfo = nil
	if stage == 1 then
		if durationRounded == 720 and self:ShouldShowBars() then -- Rift Cataclysm
			self:Berserk(eventInfo.duration, true)
			return -- no further checks needed
		elseif durationRounded == 65 then -- Consume
			barInfo = self:Consume(eventInfo)
		elseif durationRounded == 36 then -- Rending Tear
			barInfo = self:RendingTear(eventInfo)
		elseif durationRounded == 6 then -- Rift Emergence
			barInfo = self:RiftEmergence(eventInfo)
		elseif durationRounded == 75 then
			-- Rift Emergence > Consume
			durationCount[durationRounded] = (durationCount[durationRounded] or 0) + 1
			if durationCount[durationRounded] == 1 then
				barInfo = self:RiftEmergence(eventInfo)
			elseif durationCount[durationRounded] == 2 then
				barInfo = self:Consume(eventInfo)
			end
		elseif durationRounded == 73 then
			-- Alndust Upheaval > Rending Tear
			durationCount[durationRounded] = (durationCount[durationRounded] or 0) + 1
			if durationCount[durationRounded] == 1 then
				barInfo = self:AlndustUpheaval(eventInfo)
			elseif durationCount[durationRounded] == 2 then
				barInfo = self:RendingTear(eventInfo)
			end
		elseif durationRounded == 14 then -- Alndust Upheaval
			barInfo = self:AlndustUpheaval(eventInfo)
		elseif durationRounded == 24 or durationRounded == 26
		or durationRounded == 22 or durationRounded == 48 then -- Caustic Phlegm
			barInfo = self:CausticPhlegm(eventInfo)
		elseif durationRounded == 32 or durationRounded == 50  or durationRounded == 35 then -- Consuming Miasma
			barInfo = self:ConsumingMiasma(eventInfo)
		elseif durationRounded == 151 then -- Stage 2
			self:Bar("stages", eventInfo.duration, CL.stage:format(2), "spell_holy_borrowedtime", eventInfo.id)
			return -- no need to stop this, it gets corrected later 10s before the end.
		elseif durationRounded == 10 then -- Stage 2 (Updated)
			self:Bar("stages", {eventInfo.duration, 151}, CL.stage:format(2), "spell_holy_borrowedtime", eventInfo.id)
			self:ScheduleTimer(function()
				self:Message("stages", "cyan", CL.stage:format(2), false)
				self:PlaySound("stages", "long")
				self:SetStage(2)
				almdustUpheavalCount = 1
				riftEmergenceCount = 1
				riftMadnessCount = 1
				consumingMiasmaCount = 1
				causticPhlegmCount = 1
				rendingTearCount = 1
				corruptedDevastationCount = 1
				durationCount = {}
			end, eventInfo.duration)
			return
		end
	else -- Stage 2 timers
		if durationRounded == 18 or durationRounded == 3 then -- Caustic Phlegm
			barInfo = self:CausticPhlegmStage2(eventInfo)
		elseif durationRounded == 29 or durationRounded == 23 then -- Consuming Miasma
			barInfo = self:ConsumingMiasmaStage2(eventInfo)
		elseif durationRounded == 8 then -- Corrupted Devastation
			barInfo = self:CorruptedDevastation(eventInfo)
		elseif durationRounded == 30 or durationRounded == 1 then -- Ravenous Dive
			barInfo = self:RavenousDive(eventInfo, durationRounded == 1)
		elseif durationRounded == 12 then
			-- Corrupted Devastation > Caustic Phlegm > Corrupted Devastation > Caustic Phlegm
			durationCount[durationRounded] = (durationCount[durationRounded] or 0) + 1
			if durationCount[durationRounded] % 2 == 1 then
				barInfo = self:CorruptedDevastation(eventInfo)
			elseif durationCount[durationRounded] % 2 == 0 then
				barInfo = self:CausticPhlegmStage2(eventInfo)
			end
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

function mod:TimersEasy(_, eventInfo)
	if eventInfo.source ~= 0 then return end
	local stage = self:GetStage()
	local durationRounded = self:RoundNumber(eventInfo.duration, 0)
	local barInfo = nil
	if stage == 1 then
		if durationRounded == 720 and self:ShouldShowBars() then -- Rift Cataclysm
			self:Berserk(eventInfo.duration, true)
			return -- no further checks needed
		elseif durationRounded == 72 then -- Consume
			barInfo = self:Consume(eventInfo)
		elseif durationRounded == 40 then -- Rending Tear
			barInfo = self:RendingTear(eventInfo)
		elseif durationRounded == 7 or durationRounded == 82 then -- Rift Emergence
			barInfo = self:RiftEmergence(eventInfo)
		elseif durationRounded == 16 or durationRounded == 81 then -- Alndust Upheaval
			barInfo = self:AlndustUpheaval(eventInfo)
		elseif durationRounded == 26 or durationRounded == 29
		or durationRounded == 53 or durationRounded == 24 then -- Caustic Phlegm
			barInfo = self:CausticPhlegm(eventInfo)
		elseif durationRounded == 80 then
			-- Rending Tear > Consume
			durationCount[durationRounded] = (durationCount[durationRounded] or 0) + 1
			if durationCount[durationRounded] == 1 then
				barInfo = self:RendingTear(eventInfo)
			elseif durationCount[durationRounded] == 2 then
				barInfo = self:Consume(eventInfo)
			end
		elseif durationRounded == 165 then -- Stage 2
			self:Bar("stages", eventInfo.duration, CL.stage:format(2), "spell_holy_borrowedtime", eventInfo.id)
			return -- no need to stop this, it gets corrected later 10s before the end.
		elseif durationRounded == 10 then -- Stage 2 (Updated)
			self:Bar("stages", {eventInfo.duration, 165}, CL.stage:format(2), "spell_holy_borrowedtime", eventInfo.id)
			self:ScheduleTimer(function()
				self:Message("stages", "cyan", CL.stage:format(2), false)
				self:PlaySound("stages", "long")
				self:SetStage(2)
				almdustUpheavalCount = 1
				riftEmergenceCount = 1
				riftMadnessCount = 1
				consumingMiasmaCount = 1
				causticPhlegmCount = 1
				rendingTearCount = 1
				corruptedDevastationCount = 1
				durationCount = {}
			end, eventInfo.duration)
			return
		end
	else -- Stage 2 timers
		if durationRounded == 18 or durationRounded == 3 then -- Caustic Phlegm
			barInfo = self:CausticPhlegmStage2(eventInfo)
		elseif durationRounded == 29 or durationRounded == 23 then -- Consuming Miasma
			barInfo = self:ConsumingMiasmaStage2(eventInfo)
		elseif durationRounded == 8 or durationRounded == 2 then -- Corrupted Devastation
			barInfo = self:CorruptedDevastation(eventInfo, durationRounded)
		elseif durationRounded == 30 or durationRounded == 1 then -- Ravenous Dive
			barInfo = self:RavenousDive(eventInfo)
		elseif durationRounded == 12 then
			-- Corrupted Devastation > Caustic Phlegm > Corrupted Devastation > Caustic Phlegm
			durationCount[durationRounded] = (durationCount[durationRounded] or 0) + 1
			if durationCount[durationRounded] % 2 == 1 then
				barInfo = self:CorruptedDevastation(eventInfo)
			elseif durationCount[durationRounded] % 2 == 0 then
				barInfo = self:CausticPhlegmStage2(eventInfo)
			end
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

-- Stage One: Insatiable Hunger
-- Alndust Upheaval
function mod:AlndustUpheaval(eventInfo)
	local barText = CL.count:format(CL.soak, almdustUpheavalCount)
	if self:ShouldShowBars() then
		self:Bar(1262289, eventInfo.duration, barText, nil, eventInfo.id)
	end
	almdustUpheavalCount = almdustUpheavalCount + 1
	return {
		msg = barText,
		onFinished = function()
			-- self:Message(1262289, "yellow", barText)
			self:TargetMessageFromBlizzMessage(1, 1262289, "orange", barText)
			self:PlaySound(1262289, "warning") -- soak if assigned
		end
	}
end

-- Rift Emergence
function mod:RiftEmergence(eventInfo)
	local barText = CL.count:format(CL.adds, riftEmergenceCount)
	if self:ShouldShowBars() then
		self:Bar(1258610, eventInfo.duration, barText, nil, eventInfo.id)
	end
	riftEmergenceCount = riftEmergenceCount + 1
	return {
		msg = barText,
		onFinished = function()
			self:Message(1258610, "cyan", barText)
			self:PlaySound(1258610, "long") -- adds spawning
		end
	}
end

-- Rift Madness
function mod:RiftMadness(eventInfo)
	local barText = CL.count:format(L.rift_madness, riftMadnessCount)
	if self:ShouldShowBars() then
		self:Bar(1264756, eventInfo.duration, barText, nil, eventInfo.id)
	end
	riftMadnessCount = riftMadnessCount + 1
	return {
		msg = barText,
		onFinished = function()
			self:Message(1264756, "yellow", barText)
			self:PlaySound(1264756, "alert")
		end
	}
end

-- Consuming Miasma
function mod:ConsumingMiasma(eventInfo)
	local barText = CL.count:format(L.consuming_miasma, consumingMiasmaCount)
	if self:ShouldShowBars() then
		self:Bar(1257087, eventInfo.duration, barText, nil, eventInfo.id)
	end
	consumingMiasmaCount = consumingMiasmaCount + 1
	return {
		msg = barText,
		onFinished = function()
			self:Message(1257087, "yellow", barText)
			self:PlaySound(1257087, "alert")
		end
	}
end

-- Caustic Phlegm
function mod:CausticPhlegm(eventInfo)
	local barText = CL.count:format(CL.raid_damage, causticPhlegmCount)
	if self:ShouldShowBars() then
		self:Bar(1246653, eventInfo.duration, barText, nil, eventInfo.id)
	end
	causticPhlegmCount = causticPhlegmCount + 1
	return {
		msg = barText,
		onFinished = function()
			self:Message(1246653, "yellow", barText)
			self:PlaySound(1246653, "alert")
		end
	}
end

-- Rending Tear
function mod:RendingTear(eventInfo)
	local barText = CL.count:format(CL.frontal_cone, rendingTearCount)
	if self:ShouldShowBars() then
		self:Bar(1272726, eventInfo.duration, barText, nil, eventInfo.id)
	end
	rendingTearCount = rendingTearCount + 1
	return {
		msg = barText,
		onFinished = function()
			self:Message(1272726, "purple", barText)
			self:PlaySound(1272726, "alert") -- frontal
		end
	}
end

-- Consume
function mod:Consume(eventInfo)
	local barText = CL.count:format(self:SpellName(1245396), consumeCount)
	if self:ShouldShowBars() then
		self:Bar(1245396, eventInfo.duration, barText, nil, eventInfo.id)
	end
	consumeCount = consumeCount + 1
	return {
		msg = barText,
		onFinished = function()
			self:Message(1245396, "red", barText)
			self:PlaySound(1245396, "warning") -- finish adds
			self:StopBlizzMessages(0.2)
		end
	}
end

-- Stage Two: To The Skies

-- Corrupted Devastation
do
	local prevEventID = nil
	function mod:CorruptedDevastation(eventInfo, durationRounded)
		if durationRounded == 2 and prevEventID then -- LFR, when a breath gets restarted it's created with a new ID
			local barInfo = activeBars[prevEventID]
			if barInfo then
				self:StopBar(barInfo.msg)
				activeBars[prevEventID] = nil
			end
		end
		prevEventID = eventInfo.id

		local barText = CL.count:format(CL.breath, durationRounded == 2 and corruptedDevastationCount-1 or corruptedDevastationCount)
		if self:ShouldShowBars() then
			self:CDBar(1245486, eventInfo.duration, barText, nil, eventInfo.id)
		end
		if durationRounded ~= 2 then
			corruptedDevastationCount = corruptedDevastationCount + 1 -- LFR, 2 is a restarted breath, don't increment it
		end
		return {
			msg = barText,
			onFinished = function()
				self:Message(1245486, "red", barText)
				self:PlaySound(1245486, "warning") -- dodge
				self:StopBlizzMessages(0.4)
			end
		}
	end
end

-- Ravenous Dive
do
	local scheduledEnd = nil
	function mod:RavenousDive(eventInfo)
		if scheduledEnd then
			self:CancelTimer(scheduledEnd)
			scheduledEnd = nil
		end
		scheduledEnd = self:ScheduleTimer(function()
				if self:ShouldShowBars() then
					self:Message(1245406, "cyan", CL.stage:format(1), false)
					self:PlaySound(1245406, "long") -- next stage
					self:StopBlizzMessages(1.5)
				end
				self:SetStage(1)
				almdustUpheavalCount = 1
				riftEmergenceCount = 1
				riftMadnessCount = 1
				consumingMiasmaCount = 1
				causticPhlegmCount = 1
				rendingTearCount = 1
				corruptedDevastationCount = 1
				durationCount = {}
				scheduledEnd = nil
			end, eventInfo.duration)

		local barText = CL.stage:format(1) -- Do we want a count here?
		if self:ShouldShowBars() then
			self:Bar(1245406, eventInfo.duration, barText, nil, eventInfo.id)
		end
		return {
			msg = barText,
		}
	end
end

-- Caustic Phlegm (Stage 2)
function mod:CausticPhlegmStage2(eventInfo)
	local barText = CL.count:format(CL.raid_damage, causticPhlegmCount)
	if self:ShouldShowBars() then
		self:Bar(1246621, eventInfo.duration, barText, nil, eventInfo.id)
	end
	causticPhlegmCount = causticPhlegmCount + 1
	return {
		msg = barText,
		onFinished = function()
			self:Message(1246621, "red", barText)
			self:PlaySound(1246621, "alert")
		end
	}
end

-- Consuming Miasma (Stage 2)
function mod:ConsumingMiasmaStage2(eventInfo)
	local barText = CL.count:format(L.consuming_miasma, consumingMiasmaCount)
	if self:ShouldShowBars() then
		self:Bar(1257085, eventInfo.duration, barText, nil, eventInfo.id)
	end
	consumingMiasmaCount = consumingMiasmaCount + 1
	return {
		msg = barText,
		onFinished = function()
			self:Message(1257085, "red", barText)
			self:PlaySound(1257085, "info")
		end
	}
end
