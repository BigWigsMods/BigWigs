
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Imperator Averzian", 2912, 2733)
if not mod then return end
mod:RegisterEnableMob(240435) -- Imperator Averzian
mod:SetEncounterID(3176)
mod:SetRespawnTime(30)
mod:SetPrivateAuraSounds({
	{1255680, sound = "alarm"}, -- Gnashing Void
	{1275059, sound = "alert"}, -- Black Miasma
	{1249265, 1260203}, -- Umbral Collapse (Targetted)
	-- {1249309, sound = "alarm"}, -- Umbral Collapse (DoT effect), still used?
	-- {1249716, 1265398}, -- Umbral Collapse (Unknown Aura)
	1280023, -- Void Marked
	{1280075, sound = "info"}, -- Lingering Darkness (DoT effect after dispel)
	{1260981, sound = "underyou"}, -- March of the Endless
	{1265540, sound = "alarm"}, -- Blackening Wounds
	1283069, -- Weakened
})
mod:UseCustomTimers(true)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}
local durationEventCount = {}

local shadowAdvanceCount = 1
local umbralCollapseCount = 1
local voidMarkedCount = 1
local oblivionsWrathCount = 1
local voidFallCount = 1
local darkUpheavalCount = 1

--------------------------------------------------------------------------------
-- Initialization
--
function mod:GetOptions()
	return {
		1251361, -- Shadow's Advance
		1262036, -- Void Rupture
		1249262, -- Umbral Collapse
		1280015, -- Void Marked
		1260712, -- Oblivion's Wrath
		1258883, -- Void Fall
		1249251, -- Dark Upheaval
	},{

	},
	{
		[1251361] = CL.adds, -- Shadow's Advance (Adds)
		[1262036] = CL.beams, -- Void Rupture (Beams)
		[1249262] = CL.soak, -- Umbral Collapse (Soak)
		[1280015] = CL.marks, -- Void Marked (Marks)
		[1260712] = CL.dodge, -- Oblivion's Wrath (Dodge)
		[1258883] = CL.knockback, -- Void Fall (Knockback)
		[1249251] = CL.raid_damage, -- Dark Upheaval (Raid Damage)
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
	durationEventCount = {}

	shadowAdvanceCount = 1
	umbralCollapseCount = 1
	voidMarkedCount = 1
	oblivionsWrathCount = 1
	voidFallCount = 1
	darkUpheavalCount = 1
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
	local durationRounded = self:RoundNumber(eventInfo.duration, 0)
	eventInfo.durationRounded = durationRounded
	local barInfo

	if durationRounded == 160 then -- Void Fall
		barInfo = self:VoidFall(eventInfo)
		-- This starts a new rotation, reset counters
		durationEventCount = {}
	elseif durationRounded == 94 or durationRounded == 14 then -- Shadow's Advance
		barInfo = self:ShadowsAdvance(eventInfo)
	elseif durationRounded == 20 then -- Void Marked
		barInfo = self:VoidMarked(eventInfo)
	elseif durationRounded == 4 or durationRounded == 48 or durationRounded == 36 then -- Dark Upheaval
		barInfo = self:DarkUpheaval(eventInfo)
	elseif durationRounded == 32 then -- Umbral Collapse
		barInfo = self:UmbralCollapse(eventInfo)
	elseif durationRounded == 60 or durationRounded == 18 then -- Oblivion's Wrath
		barInfo = self:OblivionsWrath(eventInfo)
	elseif durationRounded == 80 then -- Void Marked, Umbral Collapse, Shadow's Advance (after first stage)
		durationEventCount[durationRounded] = (durationEventCount[durationRounded] or 0) + 1
		if (voidFallCount == 2 and durationEventCount[durationRounded] == 1)
		or (voidFallCount >= 3 and durationEventCount[durationRounded] == 2) then -- Void Marked
			barInfo = self:VoidMarked(eventInfo)
		elseif (voidFallCount == 2 and durationEventCount[durationRounded] == 2)
		or (voidFallCount >= 3 and durationEventCount[durationRounded] == 3) then -- Umbral Collapse
			barInfo = self:UmbralCollapse(eventInfo)
		elseif voidFallCount >= 3 and durationEventCount[durationRounded] == 1 then -- Shadow's Advance
			barInfo = self:ShadowsAdvance(eventInfo)
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

function mod:DummyUmbralEvent(eventInfo) -- Blizzard cancels this timer, but it does happen. We Schedule it ourselves.
	local duration = eventInfo.duration
	local fakeEventInfo = {
		id = -eventInfo.id, -- Negative ID to avoid conflicts with real bars
		duration = duration,
	}
	local fakeInfo = self:UmbralCollapse(eventInfo)
	activeBars[fakeEventInfo.id] = fakeInfo
	self:ScheduleTimer(function()
		self:ENCOUNTER_TIMELINE_EVENT_REMOVED(nil, fakeEventInfo.id)
		if self:ShouldShowBars() and fakeInfo.onFinished then
			fakeInfo.onFinished()
		end
	end, duration)
end

function mod:TimersOther(_, eventInfo)
	if eventInfo.source ~= 0 then return end
	local durationRounded = self:RoundNumber(eventInfo.duration, 0)
	eventInfo.durationRounded = durationRounded
	local barInfo

	if durationRounded == 125 then -- Void Fall
		barInfo = self:VoidFall(eventInfo)
		-- This starts a new rotation, reset counters
		durationEventCount = {}
	elseif durationRounded == 84 or durationRounded == 12 then -- Shadow's Advance
		barInfo = self:ShadowsAdvance(eventInfo)
	elseif durationRounded == 4 or durationRounded == 36 then -- Dark Upheaval
		barInfo = self:DarkUpheaval(eventInfo)
	elseif durationRounded == 20 then -- Umbral Collapse
		barInfo = self:UmbralCollapse(eventInfo)
	elseif durationRounded == 48 or durationRounded == 18 then -- Oblivion's Wrath
		barInfo = self:OblivionsWrath(eventInfo)
	elseif durationRounded == 72 then -- Umbral Collapse, Shadow's Advance (after first stage)
		durationEventCount[durationRounded] = (durationEventCount[durationRounded] or 0) + 1
		if voidFallCount == 2 then -- 2 because we already incremented the count by 1 on pull
				self:DummyUmbralEvent(eventInfo)
			return
		else
			if durationEventCount[durationRounded] == 1 then -- Shadow's Advance
				barInfo = self:ShadowsAdvance(eventInfo)
			elseif durationEventCount[durationRounded] == 2 then -- Umbral Collapse
				self:DummyUmbralEvent(eventInfo)
				return
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

			if state == 2 and self:ShouldShowBars() and barInfo.onFinished then -- Finished
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

function mod:ShadowsAdvance(eventInfo)
	local count = shadowAdvanceCount
	-- 94 and 14 appear on pull - where 94 should be bar number 2 and 14 should be bar number 1
	-- 14 also apears every reset
	if eventInfo.durationRounded == 94 or eventInfo.durationRounded == 84 then -- two initial timers 94+14 / 84+12
		count = 2
	elseif (eventInfo.durationRounded == 14 or eventInfo.durationRounded == 12) and shadowAdvanceCount <= 2 then
		count = 1
	end
	local barText = CL.count:format(CL.adds, count)
	if self:ShouldShowBars() then
		self:Bar(1251361, eventInfo.duration, barText, nil, eventInfo.id)
	end
	shadowAdvanceCount = shadowAdvanceCount + 1
	return {
		msg = barText,
		key = 1251361,
		onFinished = function()
			self:Message(1251361, "cyan", barText)
			self:PlaySound(1251361, "long")
			self:Bar(1262036, self:Mythic() and 38.5 or 23.5, CL.count:format(CL.beams, count)) -- Void Rupture
		end
	}
end

function mod:UmbralCollapse(eventInfo)
	local barText = CL.count:format(CL.soak, umbralCollapseCount)
	if self:ShouldShowBars() then
		self:Bar(1249262, eventInfo.duration, barText, nil, math.abs(eventInfo.id)) -- make any id positive to handle our own started bar
	end
	umbralCollapseCount = umbralCollapseCount + 1
	return {
		msg = barText,
		key = 1249262,
		onFinished = function()
			self:Message(1249262, "orange", barText)
			self:PlaySound(1249262, "warning")
		end
	}
end

function mod:VoidMarked(eventInfo)
	local barText = CL.count:format(CL.marks, voidMarkedCount)
	if self:ShouldShowBars() then
		self:Bar(1280015, eventInfo.duration, barText, nil, eventInfo.id)
	end
	voidMarkedCount = voidMarkedCount + 1
	return {
		msg = barText,
		key = 1280015,
		onFinished = function()
			self:Message(1280015, "yellow", barText)
			-- Sound on PAs
		end
	}
end

function mod:OblivionsWrath(eventInfo)
	local barText = CL.count:format(CL.dodge, oblivionsWrathCount)
	if self:ShouldShowBars() then
		self:Bar(1260712, eventInfo.duration, barText, nil, eventInfo.id)
	end
	oblivionsWrathCount = oblivionsWrathCount + 1
	return {
		msg = barText,
		key = 1260712,
		onFinished = function()
			self:Message(1260712, "purple", barText)
			self:PlaySound(1260712, "alarm")
		end
	}
end

function mod:VoidFall(eventInfo)
	local barText = CL.count:format(CL.knockback, voidFallCount)
	if self:ShouldShowBars() then
		self:Bar(1258883, eventInfo.duration, barText, nil, eventInfo.id)
	end
	voidFallCount = voidFallCount + 1
	return {
		msg = barText,
		key = 1258883,
		onFinished = function()
			self:Message(1258883, "cyan", barText)
			self:PlaySound(1258883, "long")
		end
	}
end

function mod:DarkUpheaval(eventInfo)
	local barText = CL.count:format(CL.raid_damage, darkUpheavalCount)
	if self:ShouldShowBars() then
		self:Bar(1249251, eventInfo.duration, barText, nil, eventInfo.id)
	end
	darkUpheavalCount = darkUpheavalCount + 1
	return {
		msg = barText,
		key = 1249251,
		onFinished = function()
			self:Message(1249251, "yellow", barText)
			self:PlaySound(1249251, "alert")
		end
	}
end
