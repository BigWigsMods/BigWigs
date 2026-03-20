
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Fallen-King Salhadaar", 2912, 2736)
if not mod then return end
mod:RegisterEnableMob(240432) -- Fallen-King Salhadaar
mod:SetEncounterID(3179)
mod:SetRespawnTime(30)
mod:SetPrivateAuraSounds({
	{1250828, sound = "underyou"}, -- Void Exposure
	{1250991, sound = "alarm"}, -- Dark Radiation
	1245960, -- Void Infusion
	{1245592, sound = "underyou"}, -- Torturous Extract
	{1260030, sound = "underyou"}, -- Umbral Beams
	{1253024, 1268992}, -- Shattering Twilight (tank, others)
	{1251213, sound = "underyou"}, -- Twilight Spikes
	1248697, -- Despotic Command
	{1248709, sound = "alarm"}, -- Oppressive Darkness
	{1250686, sound = "none"}, -- Twisting Obscurity (Raid damage/dot)
	{1271577, sound = "alarm"}, -- Destabilizing Strikes
})
mod:UseCustomTimers(true)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}

local nextEntropicUnraveling = 0

local voidConvergenceCount = 1
local entropicUnravelingCount = 1
local shatteringTwilightCount = 1
local fracturedProjectionCount = 1
local despoticCommandCount = 1
local twistingObscurityCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.fractured_projection = "Kicks" -- Move this to common?
end

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		"berserk",
		1247738, -- Void Convergence
		1246175, -- Entropic Unraveling
		1250803, -- Shattering Twilight
		1254081, -- Fractured Projection
		1248697, -- Despotic Command
		1250686, -- Twisting Obscurity
	},{

	},{
		[1247738] = CL.orbs, -- Void Convergence (Orbs)
		[1246175] = CL.full_energy, -- Entropic Unraveling (Full Energy)
		[1250803] = CL.spikes, -- Shattering Twilight (Spikes)
		[1254081] = L.fractured_projection, -- Fractured Projection (Kicks)
		[1248697] = CL.pools, -- Despotic Command (Pools)
		[1250686] = CL.raid_damage, -- Twisting Obscurity (Raid Damage)
	}
end

function mod:OnBossEnable()
	backupBars = {}
	if self:Mythic() then
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "TimersMythic")
	else
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "TimersOther")
	end
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
end


function mod:OnEncounterStart()
	activeBars = {}

	nextEntropicUnraveling = 0

	voidConvergenceCount = 1
	entropicUnravelingCount = 1
	shatteringTwilightCount = 1
	fracturedProjectionCount = 1
	despoticCommandCount = 1
	twistingObscurityCount = 1
end

function mod:OnBossDisable()
	for eventID in next, backupBars do
		self:SendMessage("BigWigs_StopBar", nil, nil, eventID)
	end
	if self.errorChatPrints then
		self:Error(("TL event version info: %d#%s"):format(BigWigsAPI.GetVersion(), BigWigsAPI.GetVersionHash()), true)
	end
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

do
	local function isBeforeUnraveling(duration)
		local time = GetTime()
		if nextEntropicUnraveling - (time + duration) > 0 then -- it'll happen
			return true
		end
	end

	local prev = 0
	function mod:TimersMythic(_, eventInfo)
		if eventInfo.source ~= 0 then return end
		local duration = eventInfo.duration
		local durationRounded = self:RoundNumber(duration, 1)
		eventInfo.durationRounded = durationRounded
		local barInfo

		-- Pull / Timer Restart Events
		if durationRounded == 11 then -- Void Convergence
			barInfo = self:VoidConvergence(eventInfo)
		elseif durationRounded == 15 then -- Twisting Obscurity
			barInfo = self:TwistingObscurity(eventInfo)
		elseif durationRounded == 23 then -- Despotic Command
			barInfo = self:DespoticCommand(eventInfo)
		elseif durationRounded == 26 then -- Fractured Projection
			barInfo = self:FracturedProjection(eventInfo)
		elseif durationRounded == 44 then -- Shattering Twilight
			barInfo = self:ShatteringTwilight(eventInfo)
		elseif durationRounded == 100 then -- Entropic Unraveling
			local time = GetTime()
			if time - prev > 2 then -- Throttle as it triggers 2x when timers reset
				self:EntropicUnraveling(eventInfo)
				nextEntropicUnraveling = time + duration
				prev = time
			end
			return -- skipping barInfo checks since this is a special case
		-- During Encounter Timers
		elseif durationRounded == 46.5 then -- Void Convergence
			if not isBeforeUnraveling(duration) then return end
			barInfo = self:VoidConvergence(eventInfo)
		elseif durationRounded == 45.5 then -- Twisting Obscurity
			if not isBeforeUnraveling(duration) then return end
			barInfo = self:TwistingObscurity(eventInfo)
		elseif durationRounded == 46 then -- Despotic Command
			if not isBeforeUnraveling(duration) then return end
			barInfo = self:DespoticCommand(eventInfo)
		elseif durationRounded == 45 then -- Fractured Projection or Shattering Twilight
			if not isBeforeUnraveling(duration) then return end
			-- These two alternate, so we need to check which one is next
			if shatteringTwilightCount <= fracturedProjectionCount then
				barInfo = self:FracturedProjection(eventInfo)
			else
				barInfo = self:ShatteringTwilight(eventInfo)
			end
		elseif durationRounded == 370 then -- Berserk
			if self:ShouldShowBars() then
				self:Berserk(370, 0)
			end
			return -- no need to check for barInfo
		end

		if barInfo then
			activeBars[eventInfo.id] = barInfo
		elseif self:ShouldShowBars() and not self:IsWiping() then
			self:ErrorForTimelineEvent(eventInfo)
			backupBars[eventInfo.id] = true
			self:SendMessage("BigWigs_StartBar", nil, nil, eventInfo.spellName, eventInfo.duration, eventInfo.iconFileID, eventInfo.maxQueueDuration, nil, eventInfo.id, eventInfo.id)

			local state = C_EncounterTimeline.GetEventState(eventInfo.id)
			if state == 1 then -- Enum.EncounterTimelineEventState.Paused = 1
				self:SendMessage("BigWigs_PauseBar", nil, nil, eventInfo.id)
			end
		end
	end

	function mod:TimersOther(_, eventInfo)
		if eventInfo.source ~= 0 then return end
		local duration = eventInfo.duration
		local durationRounded = self:RoundNumber(duration, 1)
		eventInfo.durationRounded = durationRounded
		local barInfo

		-- on pull / restart
		if durationRounded == 11 then -- Void Convergence
			barInfo = self:VoidConvergence(eventInfo)
		elseif durationRounded == 15 then -- Twisting Obscurity
			barInfo = self:TwistingObscurity(eventInfo)
		elseif durationRounded == 27 then -- Despotic Command
			barInfo = self:DespoticCommand(eventInfo)
		elseif durationRounded == 18 then -- Fractured Projection
			barInfo = self:FracturedProjection(eventInfo)
		elseif durationRounded == 42 then -- Shattering Twilight
			barInfo = self:ShatteringTwilight(eventInfo)
		elseif durationRounded == 100 then -- Entropic Unraveling
			local time = GetTime()
			if time - prev > 2 then -- Throttle as it triggers 2x when timers reset
				self:EntropicUnraveling(eventInfo)
				nextEntropicUnraveling = time + duration
				prev = time
			end
			return -- skipping barInfo checks since this is a special case

		-- repeating
		elseif durationRounded == 46.5 then -- Void Convergence
			if not isBeforeUnraveling(duration) then return end
			barInfo = self:VoidConvergence(eventInfo)
		elseif durationRounded == 46 then -- Despotic Command
			if not isBeforeUnraveling(duration) then return end
			barInfo =  self:DespoticCommand(eventInfo)
		elseif durationRounded == 45 then -- Twisting Obscurity -> Fractured Projection -> Shattering Twilight
			if not isBeforeUnraveling(duration) then return end
			-- Twisting Obscurity -> Fractured Projection -> Shattering Twilight
			if fracturedProjectionCount > shatteringTwilightCount then
				barInfo = self:ShatteringTwilight(eventInfo)
			elseif twistingObscurityCount > fracturedProjectionCount then
				barInfo = self:FracturedProjection(eventInfo)
			else
				barInfo = self:TwistingObscurity(eventInfo)
			end

		-- enrage
		elseif durationRounded == 490 then
			if self:ShouldShowBars() then
				self:Berserk(490, 0)
			end
			return -- no need to check for barInfo
		end

		if barInfo then
			activeBars[eventInfo.id] = barInfo
		elseif self:ShouldShowBars() and not self:IsWiping() then
			self:ErrorForTimelineEvent(eventInfo)
			backupBars[eventInfo.id] = true
			self:SendMessage("BigWigs_StartBar", nil, nil, eventInfo.spellName, eventInfo.duration, eventInfo.iconFileID, eventInfo.maxQueueDuration, nil, eventInfo.id, eventInfo.id)

			local state = C_EncounterTimeline.GetEventState(eventInfo.id)
			if state == 1 then -- Enum.EncounterTimelineEventState.Paused = 1
				self:SendMessage("BigWigs_PauseBar", nil, nil, eventInfo.id)
			end
		end
	end
end

function mod:ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED(_, eventID)
	local barInfo = activeBars[eventID]
	if barInfo then
		local state = C_EncounterTimeline.GetEventState(eventID)
		-- This encounter had paused/resumed bars during the boss's full energy spell. We don't show those as it's confusing.
		if state == 2 or state == 4 then -- Finished or Canceled
			self:StopBar(barInfo.msg)

			if state == 2 and self:ShouldShowBars() and barInfo.callback then -- Finished
				barInfo.callback()
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

function mod:VoidConvergence(eventInfo)
	local barText = CL.count:format(CL.orbs, voidConvergenceCount)
	if self:ShouldShowBars() then
		self:Bar(1247738, eventInfo.duration, barText, nil, eventInfo.id)
	end
	voidConvergenceCount = voidConvergenceCount + 1
	return {
		msg = barText,
		key = 1247738,
		callback = function()
			self:Message(1247738, "orange", barText)
			self:PlaySound(1247738, "alarm")
		end
	}
end

function mod:EntropicUnraveling(eventInfo)
	local barText = CL.count:format(CL.full_energy, entropicUnravelingCount)
	if self:ShouldShowBars() then
		self:Bar(1246175, eventInfo.duration, barText, nil, eventInfo.id)
	end
	entropicUnravelingCount = entropicUnravelingCount + 1
	if self:ShouldShowBars() then
		-- Scheduling instead of using the callback since these were getting started and canceled right away during tests.
		self:ScheduleTimer("Message", eventInfo.duration, 1246175, "red", barText)
		self:ScheduleTimer("PlaySound", eventInfo.duration, 1246175, "warning")
	end
end

function mod:ShatteringTwilight(eventInfo)
	local barText = CL.count:format(CL.spikes, shatteringTwilightCount)
	if self:ShouldShowBars() then
		self:Bar(1250803, eventInfo.duration, barText, nil, eventInfo.id)
	end
	shatteringTwilightCount = shatteringTwilightCount + 1
	return {
		msg = barText,
		key = 1250803,
		callback = function()
			self:Message(1250803, "purple", barText)
			-- Sound on PAs
		end
	}
end

function mod:FracturedProjection(eventInfo)
	local barText = CL.count:format(L.fractured_projection, fracturedProjectionCount)
	if self:ShouldShowBars() then
		self:Bar(1254081, eventInfo.duration, barText, nil, eventInfo.id)
	end
	fracturedProjectionCount = fracturedProjectionCount + 1
	return {
		msg = barText,
		key = 1254081,
		callback = function()
			self:Message(1254081, "red", barText)
			self:PlaySound(1254081, "warning")
		end
	}
end

function mod:DespoticCommand(eventInfo)
	local barText = CL.count:format(CL.pools, despoticCommandCount)
	if self:ShouldShowBars() then
		self:Bar(1248697, eventInfo.duration, barText, nil, eventInfo.id)
	end
	despoticCommandCount = despoticCommandCount + 1
	return {
		msg = barText,
		key = 1248697,
		callback = function()
			self:Message(1248697, "yellow", barText)
			-- Sound on PAs
		end
	}
end

function mod:TwistingObscurity(eventInfo)
	local barText = CL.count:format(CL.raid_damage, twistingObscurityCount)
	if self:ShouldShowBars() then
		self:Bar(1250686, eventInfo.duration, barText, nil, eventInfo.id)
	end
	twistingObscurityCount = twistingObscurityCount + 1
	return {
		msg = barText,
		key = 1250686,
		callback = function()
			self:Message(1250686, "yellow", barText)
			self:PlaySound(1250686, "alert")
		end
	}
end
