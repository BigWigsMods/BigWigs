
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Chimaerus the Undreamt God", 2939, 2795)
if not mod then return end
mod:RegisterEnableMob(245569) -- Chimaerus
mod:SetEncounterID(3306)
-- mod:SetRespawnTime(30)
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
local durationCount = {}

local almdustUpheavalCount = 1
local riftEmergenceCount = 1
local riftMadnessCount = 1
local consumingMiasmaCount = 1
local causticPhlegmCount = 1
local rendingTearCount = 1
local consumeCount = 1
local corruptedDevastationCount = 1
local ravenousDiveCount = 1

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
		"berserk",
		-- Stage One: Insatiable Hunger
		1262289, -- Alndust Upheaval
		1258610, -- Rift Emergence
		1264756, -- Rift Madness
		1257087, -- Consuming Miasma
		1246653, -- Caustic Phlegm
		1272726, -- Rending Tear
		1245396, -- Consume
		-- Stage Two: To The Skies
		1245486, -- Corrupted Devastation
		1245406, -- Ravenous Dive
		1246621, -- Caustic Phlegm
		1257085, -- Consuming Miasma
	},{
		[1262289] = CL.stage:format(1),
		[1245486] = CL.stage:format(2),
	},{
		[1262289] = CL.soak, -- Alndust Upheaval (Soak)
		[1258610] = CL.adds, -- Rift Emergence (Adds)
		[1264756] = L.rift_madness, -- Rift Madness (Madness)
		[1257087] = L.consuming_miasma, -- Consuming Miasma (Dispels)
		[1246653] = CL.raid_damage, -- Caustic Phlegm (Raid Damage)
		[1272726] = CL.frontal_cone, -- Rending Tear (Frontal Cone)
		[1245396] = CL.stage:format(2), -- Consume (Stage 2)
		[1245486] = CL.breath, -- Corrupted Devastation (Breath)
		[1245406] = CL.stage:format(1), -- Ravenous Dive (Stage 1)
		[1246621] = CL.raid_damage, -- Caustic Phlegm (Raid Damage)
		[1257085] = L.consuming_miasma, -- Consuming Miasma (Dispels)
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED")
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
	ravenousDiveCount = 1
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

local backup = {}
function mod:ENCOUNTER_TIMELINE_EVENT_ADDED(_, eventInfo)
	if eventInfo.source ~= 0 then return end
	local stage = self:GetStage()
	local durationRounded = math.floor(eventInfo.duration + 0.5)
	local barInfo = nil
	if stage == 1 then
		if durationRounded == 540 and self:ShouldShowBars() then -- Rift Cataclysm
			self:Berserk(eventInfo.duration)
			return -- no further checks needed
		elseif durationRounded == 121 then -- Consume
			barInfo = self:Consume(eventInfo)
		elseif durationRounded == 36 then -- Rending Tear
			barInfo = self:RendingTear(eventInfo)
		elseif durationRounded == 6 then -- Rift Emergence
			barInfo = self:RiftEmergence(eventInfo)
		elseif durationRounded == 30 then -- Rift Madness
			barInfo = self:RiftMadness(eventInfo)
		elseif durationRounded == 53 then --  Alndust Upheaval or Rending Tear
			-- Alndust Upheaval > Rending Tear
			durationCount[durationRounded] = (durationCount[durationRounded] or 0) + 1
			if durationCount[durationRounded] % 2 == 1 then
				barInfo = self:AlndustUpheaval(eventInfo)
			else
				barInfo = self:RendingTear(eventInfo)
			end
		elseif durationRounded == 55 then -- Rift Emergence or Rift Madness
			-- Rift Emergence > Rift Madness
			durationCount[durationRounded] = (durationCount[durationRounded] or 0) + 1
			if durationCount[durationRounded] % 2 == 1 then
				barInfo = self:RiftEmergence(eventInfo)
			else
				barInfo = self:RiftMadness(eventInfo)
			end
		elseif durationRounded == 14 then -- Alndust Upheaval
			barInfo = self:AlndustUpheaval(eventInfo)
		elseif durationRounded == 26 or durationRounded == 28 or durationRounded == 23 or durationRounded == 24 then -- Caustic Phlegm
			barInfo = self:CausticPhlegm(eventInfo)
		elseif durationRounded == 32 or durationRounded == 33 or durationRounded == 35 then -- Consuming Miasma
			barInfo = self:ConsumingMiasma(eventInfo)
		end
	else -- Stage 2 timers
		if durationRounded == 18 or durationRounded == 9 then -- Caustic Phlegm
			barInfo = self:CausticPhlegmStage2(eventInfo)
		elseif durationRounded == 29 then -- Consuming Miasma
			barInfo = self:ConsumingMiasmaStage2(eventInfo)
		elseif durationRounded == 14 then -- Corrupted Devastation
			barInfo = self:CorruptedDevastation(eventInfo)
		elseif durationRounded == 84 then -- Ravenous Dive
			barInfo = self:RavenousDive(eventInfo)
		elseif durationRounded == 12 then -- Corrupted Devastation or Caustic Phlegm
			-- Corrupted Devastation > Caustic Phlegm
			durationCount[durationRounded] = (durationCount[durationRounded] or 0) + 1
			if durationCount[durationRounded] % 2 == 1 then
				barInfo = self:CorruptedDevastation(eventInfo)
			else
				barInfo = self:CausticPhlegmStage2(eventInfo)
			end
		elseif durationRounded == 23 then -- Consuming Miasma
			barInfo = self:ConsumingMiasmaStage2(eventInfo)
		elseif durationRounded == 30 then -- Ravenous Dive (updates initial timer?)
			barInfo = self:RavenousDive(eventInfo)
		end
	end
	if barInfo then
		activeBars[eventInfo.id] = barInfo
	elseif self:ShouldShowBars() and not self:IsWiping() then
		self:ErrorForTimelineEvent(eventInfo)
		backup[eventInfo.id] = true
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
			local spellId = barInfo.key

			if state == 2 and barInfo.callback and self:ShouldShowBars() then -- Finished
				barInfo.callback()
			end

			-- Stage logic
			if spellId == 1245396 then -- Consume, stage 2 coming
				self:SetStage(2)
				almdustUpheavalCount = 1
				riftEmergenceCount = 1
				riftMadnessCount = 1
				consumingMiasmaCount = 1
				causticPhlegmCount = 1
				rendingTearCount = 1
				corruptedDevastationCount = 1
				ravenousDiveCount = 1
			elseif spellId == 1245406 then -- Ravenous Dive, stage 2 ending
				self:SetStage(1)
				almdustUpheavalCount = 1
				riftEmergenceCount = 1
				riftMadnessCount = 1
				consumingMiasmaCount = 1
				causticPhlegmCount = 1
				rendingTearCount = 1
				corruptedDevastationCount = 1
				ravenousDiveCount = 1
			end

			activeBars[eventID] = nil
		end
	elseif backup[eventID] then
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
	elseif backup[eventID] then
		backup[eventID] = nil
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
		key = 1262289,
		callback = function()
			self:Message(1262289, "yellow", barText)
			self:PlaySound(1262289, "alert")
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
		key = 1258610,
		callback = function()
			self:Message(1258610, "yellow", barText)
			self:PlaySound(1258610, "alert")
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
		key = 1264756,
		callback = function()
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
		key = 1257087,
		callback = function()
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
		key = 1246653,
		callback = function()
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
		key = 1272726,
		callback = function()
			self:Message(1272726, "yellow", barText)
			self:PlaySound(1272726, "alert")
		end
	}
end

-- Consume
function mod:Consume(eventInfo)
	local barText = CL.count:format(CL.stage:format(2), consumeCount)
	if self:ShouldShowBars() then
		self:Bar(1245396, eventInfo.duration, barText, nil, eventInfo.id)
	end
	consumeCount = consumeCount + 1
	return {
		msg = barText,
		key = 1245396,
		callback = function()
			self:Message(1245396, "red", barText)
			self:PlaySound(1245396, "long")
		end
	}
end

-- Stage Two: To The Skies

-- Corrupted Devastation
function mod:CorruptedDevastation(eventInfo)
	local barText = CL.count:format(CL.breath, corruptedDevastationCount)
	if self:ShouldShowBars() then
		self:Bar(1245486, eventInfo.duration, barText, nil, eventInfo.id)
	end
	corruptedDevastationCount = corruptedDevastationCount + 1
	return {
		msg = barText,
		key = 1245486,
		callback = function()
			self:Message(1245486, "red", barText)
			self:PlaySound(1245486, "long")
		end
	}
end

-- Ravenous Dive
function mod:RavenousDive(eventInfo)
	local barText = CL.stage:format(1) -- No count needed? or handle bar restarting also.
	if self:ShouldShowBars() then
		self:Bar(1245406, eventInfo.duration, barText, nil, eventInfo.id)
	end
	-- only the 30s one means stage 2 is about to end, the other one was updating the timer.
	if eventInfo.duration == 30 then
		return {
			msg = barText,
			key = 1245406,
			callback = function()
				self:Message(1245406, "red", barText)
				self:PlaySound(1245406, "long")
			end
		}
	end
	return {msg = barText}
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
		key = 1246621,
		callback = function()
			self:Message(1246621, "red", barText)
			self:PlaySound(1246621, "long")
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
		key = 1257085,
		callback = function()
			self:Message(1257085, "red", barText)
			self:PlaySound(1257085, "long")
		end
	}
end
