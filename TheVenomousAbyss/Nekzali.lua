
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nek'zali the Soulcoiler", 3004, 2888)
if not mod then return end
mod:RegisterEnableMob(259927, 263050) -- Nek'zali, Echo of Jawae
mod:SetEncounterID(3470)
mod:SetRespawnTime(30)
mod:UseCustomTimers(true)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}

local durationEventCount = {}
local repeaters = {}

local graspingDepthsCount = 1
local ignitionCount = 1
local rendCount = 1
local amaniCount = 1
local barrageCount = 1
local pyreCount = 1
local tollCount = 1
local invokeCount = 1

local gapTimer
do
	-- XXX using counts in the bar handler would have probably been better than
	-- duration. will probably switch to that if i feel like adding this for
	-- non-mythic and the durations aren't unique.

	-- mythic
	local timers = {
		[1295397] = { -- Restless Amani
			[1] = { [40] = 71 },
			[1.5] = { [20] = 35 },
			[2] = { [40] = 31 },
		},
		[1287426] = { -- Essence Rend
			[1] = { [40.5] = 30.5 },
			[2] = { [49.5] = 80 },
		},
		[1292036] = { -- Possession Barrage
			[1] = { [36] = 35 },
			[2] = { [28] = 52 },
		},
		[1305421] = { -- Hungering Pyre
			[1.5] = { [16] = 30 },
		},
		[1299673] = { -- Invoke
			[2] = { [50] = 30 },
		},
	}
	function gapTimer(spellId, duration)
		if not mod:Mythic() then return end

		local stage = mod:GetStage()
		return timers[spellId][stage] and timers[spellId][stage][duration]
	end
end

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:SetDefaultLocale({
	possession_barrage = "Barrage",
})

--------------------------------------------------------------------------------
-- Renames
--

mod:SetRenames({
	["stages"] = { CL.intermission, CL.stage:format(2), original = false, notes = {CL.intermission, CL.stage:format(2)}}, -- Stages
	-- [1284034] = {26662, CL.custom_end:format(mod.displayName, mod:SpellName(26662)), notes = {false, CL.messageNote}}, -- Uncoiled Rage
	[1285681] = {CL.dodge}, -- Soulcoil Ignition
	[1287426] = {1287426, CL.you:format(mod:SpellName(1287426)), notes = {CL.generalNote, CL.messageOnYouNote}}, -- Essence Rend  original = {1287426, CL.you:format(mod:SpellName(1287426))},
	[1295397] = {CL.adds}, -- Restless Amani
	[1287533] = {CL.adds_spawning}, -- Gravebound Advance
	[1292036] = {L.possession_barrage}, -- Possession Barrage
	[1289696] = {CL.big_adds}, -- Tether of Awakening
	[1293212] = {1293212}, -- Grasping Depths
	[1305421] = {CL.soak}, -- Hungering Pyre
	[1305993] = {1305993}, -- Residual Toll
	[1299673] = {1299673}, -- Invoke
	-- [1293497] = {1293497}, -- Entwined Step
})

--------------------------------------------------------------------------------
-- Options
--

mod:SetAuraData({
	{1306666, soundOnApplied = "warning", duration = 7.5, header = CL.important}, -- Hungering Pyre
	{1284103, soundOnApplied = "warning", duration = 2}, -- Possession Barrage
	{1284109, soundOnApplied = "none", soundOnAppliedDose = "none", note = CL.tank_debuff}, -- Hollowing Strikes -- Tank Stacks
	{1287434, soundOnApplied = "warning", duration = 15}, -- Essence Rend
	{1298698, soundOnApplied = "none", duration = 12, header = CL.general}, -- Residual Toll
	{1297624, soundOnApplied = "none", soundOnAppliedDose = "none"}, -- Ritual Burn
	{1288772, soundOnApplied = "none", soundOnAppliedDose = "none"}, -- Soulcoil Rite
	{1285623, soundOnApplied = "none"}, -- Soulcoil Well
	{1293214, soundOnApplied = "none", soundOnAppliedDose = "none", mythic = true, note = CL.mythic}, -- Grasping Depths
	{1300524, 1300521, soundOnApplied = "none", mythic = true, note = CL.mythic}, -- Immortal Coil
	{1299988, soundOnApplied = "none", mythic = true, note = CL.mythic}, -- Immortal Coil
	{1290361, 1292751, soundOnApplied = "none", mythic = true, note = CL.mythic}, -- Soulcoiled
	{1300235, soundOnApplied = "none", mythic = true, note = CL.mythic}, -- Soul Exhaustion
	{1300239, soundOnApplied = "none", soundOnAppliedDose = "none", mythic = true, note = CL.mythic}, -- Swirling Spirit
	{1307939, soundOnApplied = "none", soundOnAppliedDose = "none", header = CL.intermission}, -- Corpse Blight
	{1289875, soundOnApplied = "none", duration = 3}, -- Cremation
	{1288554, soundOnApplied = "none"}, -- Latent Cultist
	{1294933, soundOnApplied = "alarm", duration = 8}, -- Slithering Flame -- Note: Failed Soaking
})

function mod:GetOptions()
	return {
		"stages",
		-- 1284034, -- Uncoiled Rage

		-- Mythic
		1293212, -- Grasping Depths

		-- Stage One: Soulcoiler Initiation
		1285681, -- Soulcoil Ignition
		1287426, -- Essence Rend
		1295397, -- Restless Amani
			1287533,  -- Gravebound Advance
		1292036, -- Possession Barrage

		-- Intermission: Ritual of Awakening
		1289696, -- Tether of Awakening
		1305421, -- Hungering Pyre
		-- Restless Amani
			1305993, -- Residual Toll -- XXX removed?

		-- Stage Two: Uncoiling
		1299673, -- Invoke
			-- 1293497, -- Entwined Step
		-- Possession Barrage
	}, {
		[1293212] = "mythic",
		[1285681] = -36184, -- Stage 1
		[1289696] = -35255, -- Intermission
		[1299673] = -36195, -- Stage 2
	}
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	backupBars = {}
	if self:Mythic() then
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "MythicTimeline")
	elseif self:Heroic() then
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "HeroicTimeline")
	else
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "EasyTimeline")
	end
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
end

function mod:OnEncounterStart()
	activeBars = {}
	self:SetStage(1)
	durationEventCount = {}

	ignitionCount = 1
	rendCount = 1
	amaniCount = 1
	barrageCount = 1
	pyreCount = 1
	tollCount = 1
	invokeCount = 1

	if self:ShouldShowBars() then
		self:Bar(1285681, 3, CL.count:format(self:GetRename(1285681), ignitionCount)) -- Soulcoil Ignition
		repeaters[1285681] = self:ScheduleTimer("SoulcoilIgnitionRepeater", 3)

		if self:Mythic() then
			graspingDepthsCount = 1
			self:Bar(1293212, 42.5, CL.count:format(self:GetRename(1293212), graspingDepthsCount)) -- Grasping Depths
			repeaters[1293212] = self:ScheduleTimer("GraspingDepthsRepeater", 42.5)
		end
	end

	self:RegisterUnitEvent("UNIT_SPELLCAST_START", nil, "boss1")
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:MythicTimeline(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo = nil

	local stage = self:GetStage()
	local duration = eventInfo.duration
	local rounded1 = self:RoundNumber(duration, 1)
	local rounded = self:RoundNumber(rounded1, 0)

	-- stage 1
	if stage < 2 then
		if rounded == 40 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] == 1 then
				return false -- first bar is cancelled
			end
			barInfo = self:RestlessAmani(duration)
		elseif rounded == 28 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] == 1 then
				return false -- first bar is cancelled
			end
			barInfo = self:PossessionBarrage(duration)
		elseif rounded1 == 14.5 then -- 14.5
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] == 1 then
				return false -- first bar is cancelled
			end
			barInfo = self:EssenceRend(duration)
		elseif rounded1 == 40.5 then
			barInfo = self:EssenceRend(duration)
		elseif rounded == 36 then
			barInfo = self:PossessionBarrage(duration)

		-- intermission
		elseif rounded == 20 then
			barInfo = self:RestlessAmani(duration)
		elseif rounded == 16 then
			barInfo = self:HungeringPyre(duration)
		elseif rounded == 30 then
			barInfo = self:ResidualToll(duration)
		end

	-- stage 2
	else
		if rounded1 == 49.5 then
			barInfo = self:EssenceRend(duration)
		elseif rounded == 6 or rounded == 50 then
			barInfo = self:Invoke(duration)
		elseif rounded == 28 then
			barInfo = self:PossessionBarrage(duration)
		elseif rounded == 20 then
			barInfo = self:RestlessAmani(duration)
		elseif rounded == 40 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] % 2 == 1 then
				barInfo = self:PossessionBarrage(duration)
			else
				barInfo = self:RestlessAmani(duration)
			end
		end
	end

	self:HandleBars(barInfo, eventInfo)
end


function mod:HeroicTimeline(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo = nil

	local stage = self:GetStage()
	local duration = eventInfo.duration
	local rounded = self:RoundNumber(self:RoundNumber(duration, 1), 0)

	if stage == 1 then
		if rounded == 44 then -- 43.64
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] == 1 then
				return false -- first bar is cancelled
			end
			barInfo = self:RestlessAmani(duration)
		elseif rounded == 13 then -- 12.73
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] == 1 then
				return false -- first bar is cancelled
			end
			barInfo = self:EssenceRend(duration)
		elseif rounded == 29 then -- 29.09
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] == 1 then
				return false -- first bar is cancelled
			end
			barInfo = self:PossessionBarrage(duration)

		elseif rounded == 58 then -- 58.18
			barInfo = self:EssenceRend(duration)
		elseif rounded == 34 then -- 33.64
			barInfo = self:RestlessAmani(duration)
		end

	elseif stage == 1.5 then
		-- these are mostly timed completely wrong.
		if rounded == 3 or rounded == 35 or rounded == 10 then
			barInfo = self:ResidualToll(duration)
		elseif rounded == 8 or rounded == 24 or rounded == 20 then
			barInfo = self:RestlessAmani(duration)
		elseif rounded == 22 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] % 4 == 2 then
				barInfo = self:ResidualToll(duration)
			else
				barInfo = self:HungeringPyre(duration)
			end
		elseif rounded == 19 then
			barInfo = self:HungeringPyre(duration)
		end

	elseif stage == 2 then
		if rounded == 12 or rounded == 28 then
			barInfo = self:Invoke(duration)
		elseif rounded == 45 then
			barInfo = self:PossessionBarrage(duration)
		elseif rounded == 30 then
			barInfo = self:RestlessAmani(duration)
		end
	end

	self:HandleBars(barInfo, eventInfo)
end

function mod:EasyTimeline(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo = nil

	local stage = self:GetStage()
	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	-- stage 1
	if stage < 2 then
		if rounded == 50 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] == 1 then
				return false -- first bar is cancelled
			end
			barInfo = self:RestlessAmani(duration)
		elseif rounded == 36 then -- 35.555
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] == 1 then
				return false -- first bar is cancelled
			end
			barInfo = self:PossessionBarrage(duration)
		elseif rounded == 16 or rounded == 48 then -- 15.555, 47.777
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if rounded == 16 and durationEventCount[rounded] == 1 then
				return false -- first bar is cancelled
			end
			barInfo = self:EssenceRend(duration)

		-- intermission
		elseif rounded == 20 or rounded == 33 then -- 20, 33.333
			barInfo = self:RestlessAmani(duration)
		elseif rounded == 17 or rounded == 19 then -- 16.666, 18.888
			barInfo = self:HungeringPyre(duration)
		elseif rounded == 6 or rounded == 21 then -- 5.555, 21.111
			barInfo = self:ResidualToll(duration)
		end

	-- stage 2
	else
		if rounded == 20 or rounded == 24 then -- 20, 24.444
			barInfo = self:Invoke(duration)
		elseif rounded == 28 then -- 27.777
			barInfo = self:PossessionBarrage(duration)
		elseif rounded == 6 or rounded == 31 then -- 5.555, 31.111
			barInfo = self:EssenceRend(duration)
		elseif rounded == 53 then -- 53.333
			barInfo = self:RestlessAmani(duration)
		end
	end

	self:HandleBars(barInfo, eventInfo)
end

function mod:HandleBars(barInfo, eventInfo)
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

	-- Stop p1 bars with blizzard bars
	-- if self:GetStage() == 1 and state == 3 and self:ShouldShowBars() and not self:IsWiping() and GetTime() - self.stageTime > 1 then -- cancelled
	-- 	self:CancelTimer(repeaters[1285681])
	-- 	self:StopBar(CL.count:format(self:GetRename(1285681), ignitionCount)) -- Soulcoil Ignition
	-- 	self:StopBar(CL.count:format(self:GetRename(1295397), amaniCount)) -- Restless Amani
	-- 	self:StopBar(CL.count:format(self:GetRename(1287426), rendCount)) -- Essence Rend
	-- 	self:StopBar(CL.count:format(self:GetRename(1292036), barrageCount)) -- Possession Barrage
	-- 	if self:Mythic() then
	-- 		self:CancelTimer(repeaters[1293212])
	-- 		self:StopBar(CL.count:format(self:GetRename(1293212), graspingDepthsCount)) -- Grasping Depths
	-- 	end
	-- end

	local barInfo = activeBars[eventID]
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

do
	-- P1 restarts every 71s (there are no timers up for 8s between sets).
	-- To catch the intermission we watch for a 1.5s Ritual of Awakening cast.
	-- Intermission restarts every 30s (if Residual Toll is removed, there's a 10s gap).
	-- P2 starts with the next channeled spell (Uncoiling) after the Ritual of Awakening channel.
	-- P2 restarts every 80s (there are no timers up for 12s between sets).

	local startTime = 0
	function mod:UNIT_SPELLCAST_START(_, _, _, _, castID)
		startTime = GetTime()
	end

	function mod:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, _, castID)
		if GetTime() - startTime < 2 then -- Ritual of Awakening 1.5s
			self:UnregisterUnitEvent("UNIT_SPELLCAST_START", unit)
			self:UnregisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", unit)
			self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", nil, unit)

			self:CancelTimer(repeaters[1285681])
			self:StopBar(CL.count:format(self:GetRename(1285681), ignitionCount)) -- Soulcoil Ignition
			self:StopBar(CL.count:format(self:GetRename(1295397), amaniCount)) -- Restless Amani
			self:StopBar(CL.count:format(self:GetRename(1287426), rendCount)) -- Essence Rend
			self:StopBar(CL.count:format(self:GetRename(1292036), barrageCount)) -- Possession Barrage
			if self:Mythic() then
				self:CancelTimer(repeaters[1293212])
				self:StopBar(CL.count:format(self:GetRename(1293212), graspingDepthsCount)) -- Grasping Depths
			end

			durationEventCount = {}

			rendCount = 1
			amaniCount = 1
			barrageCount = 1

			-- stage set in channel, which is ~1s later (runs to the well)
			self:Message("stages", "cyan", self:GetRename("stages", 1), false) -- Intermission
			self:PlaySound("stages", "long")
		end
	end
end

function mod:UNIT_SPELLCAST_CHANNEL_START(event, unit, _, _, castID)
	local stage = self:GetStage()
	if stage == 1 then -- Ritual of Awakening
		self:SetStage(1.5)

		if self:ShouldShowBars() then
			self:Bar(1289696, 20) -- Tether of Awakening
			if self:Mythic() then
				local gap = 18
				self:Bar(1295397, 20 + gap, CL.count:format(self:GetRename(1295397), amaniCount)) -- Restless Amani
				self:Bar(1305421, 16 + gap, CL.count:format(self:GetRename(1305421), pyreCount)) -- Hungering Pyre
				self:Bar(1305993, 30 + gap, CL.count:format(self:GetRename(1305993), tollCount)) -- Residual Toll

				-- restart with the same count so down groups can stay consistent
				self:Bar(1293212, 41.5, CL.count:format(self:GetRename(1293212), graspingDepthsCount)) -- Grasping Depths
				repeaters[1293212] = self:ScheduleTimer("GraspingDepthsRepeater", 41.5)
			end
		end

	elseif stage == 1.5 then -- Uncoiling
		self:UnregisterUnitEvent(event, unit)

		self:StopBar(CL.count:format(self:GetRename(1295397), amaniCount)) -- Restless Amani
		self:StopBar(CL.count:format(self:GetRename(1305421), pyreCount)) -- Hungering Pyre

		durationEventCount = {}

		rendCount = 1
		amaniCount = 1
		barrageCount = 1

		self:SetStage(2)
		if self:ShouldShowBars() then
			self:Message("stages", "cyan", self:GetRename("stages", 2), false) -- Stage 2
			self:PlaySound("stages", "long")

			if self:Mythic() then
				local gap = 5
				self:Bar(1299673, 6 + gap, CL.count:format(self:GetRename(1299673), invokeCount)) -- Invoke
				self:Bar(1292036, 40 + gap, CL.count:format(self:GetRename(1292036), barrageCount)) -- Possession Barrage
				self:Bar(1287426, 49.5 + gap, CL.count:format(self:GetRename(1287426), rendCount)) -- Essence Rend
				self:Bar(1295397, 20 + gap, CL.count:format(self:GetRename(1295397), amaniCount)) -- Restless Amani

				self:CancelTimer(repeaters[1293212])
				-- restart with the same count so down groups can stay consistent
				self:Bar(1293212, 27.5, CL.count:format(self:GetRename(1293212), graspingDepthsCount)) -- Grasping Depths
				repeaters[1293212] = self:ScheduleTimer("GraspingDepthsRepeater", 27.5)
			end
		end
	end
end

-- Stage 1

-- XXX the same 3.5s severity 2 ENCOUNTER_WARNING as Restless Amani that can happen anytime. but meh, it's already red
-- function mod:UncoiledRageMessage()
-- 	self:Message(1284034, "red", self:GetRename(1284034, 2), false) -- Nek'zali goes Berserk
-- end

function mod:SoulcoilIgnitionRepeater()
	self:StopBar(CL.count:format(self:GetRename(1285681), ignitionCount))
	-- self:Message(1285681, "yellow", CL.count:format(self:GetRename(1285681), ignitionCount))
	-- self:PlaySound(1285681, "alarm")
	ignitionCount = ignitionCount + 1

	local cd = self:Mythic() and 73 or self:Heroic() and 85 or 100
	self:Bar(1285681, cd, CL.count:format(self:GetRename(1285681), ignitionCount))
	repeaters[1285681] = self:ScheduleTimer("SoulcoilIgnitionRepeater", cd)
end

function mod:EssenceRend(duration)
	local barText = CL.count:format(self:GetRename(1287426), rendCount)
	rendCount = rendCount + 1

	-- blizzard fires sets of bars on an interval, bridge the gap with a normal bar
	local barOnFinish = gapTimer(1287426, self:RoundNumber(duration, 1))
	-- if the normal bar is running, use the existing duration for max time
	local remaining, total = self:BarTimeLeft(barText)
	local newDuration = remaining > 1 and { duration, total } or nil

	return {
		duration = newDuration,
		msg = barText,
		key = 1287426,
		onFinished = function()
			local timer = self:ScheduleTimer(function() self:Message(1287426, "yellow", barText) end, 0.35)
			self:PersonalMessageFromBlizzMessage(1287426, 0.3, false, self:GetRename(1287426, 2), nil, nil, function() self:CancelTimer(timer) end)

			if barOnFinish then
				self:Bar(1287426, barOnFinish, CL.count:format(self:GetRename(1287426), rendCount))
			end
		end
	}
end

function mod:RestlessAmani(duration)
	local barText = CL.count:format(self:GetRename(1295397), amaniCount)
	local messageText = CL.soon:format(barText)
	amaniCount = amaniCount + 1

	local barOnFinish = gapTimer(1295397, duration)
	local remaining, total = self:BarTimeLeft(barText)
	local newDuration = remaining > 1 and { duration, total } or nil

	return {
		duration = newDuration,
		msg = barText,
		key = 1295397,
		onFinished = function()
			self:StopBlizzMessages(0.5)
			self:Message(1295397, "cyan", messageText)
			self:PlaySound(1295397, "info")

			-- x3 12.6, x3 14.2, x1 15.7 (p1)
			self:Bar(1287533, 12.6, self:GetRename(1287533)) -- Gravebound Advance

			if barOnFinish then
				self:Bar(1295397, barOnFinish, CL.count:format(self:GetRename(1295397), amaniCount))
			end
		end
	}
end

function mod:PossessionBarrage(duration)
	local barText = CL.count:format(self:GetRename(1292036), barrageCount)
	barrageCount = barrageCount + 1

	local barOnFinish = gapTimer(1292036, duration)
	local remaining, total = self:BarTimeLeft(barText)
	local newDuration = remaining > 1 and { duration, total } or nil

	return {
		duration = newDuration,
		msg = barText,
		key = 1292036,
		onFinished = function()
			self:Message(1292036, "purple", barText)
			-- self:PlaySound(1292036, "alert")
			-- 6s cast on current target, then 2s channel

			if barOnFinish then
				self:Bar(1292036, barOnFinish, CL.count:format(self:GetRename(1292036), barrageCount))
			end
		end
	}
end

function mod:GraspingDepthsRepeater()
	self:StopBar(CL.count:format(self:GetRename(1293212), graspingDepthsCount))
	self:Message(1293212, "cyan", CL.count:format(self:GetRename(1293212), graspingDepthsCount))
	self:PlaySound(1293212, "long")
	graspingDepthsCount = graspingDepthsCount + 1

	self:Bar(1293212, 60.1, CL.count:format(self:GetRename(1293212), graspingDepthsCount))
	repeaters[1293212] = self:ScheduleTimer("GraspingDepthsRepeater", 60.1)
end

-- Intermission

function mod:HungeringPyre(duration)
	local barText = CL.count:format(self:GetRename(1305421), pyreCount)
	pyreCount = pyreCount + 1

	local barOnFinish = gapTimer(1305421, duration)
	local remaining, total = self:BarTimeLeft(barText)
	local newDuration = remaining > 1 and { duration, total } or nil

	return {
		duration = newDuration,
		msg = barText,
		key = 1305421,
		onFinished = function()
			self:Message(1305421, "orange", barText)
			-- self:PlaySound(1305421, "alert")

			if barOnFinish then
				self:Bar(1305421, barOnFinish, CL.count:format(self:GetRename(1305421), pyreCount))
			end
		end
	}
end

function mod:ResidualToll(duration)
	local barText = CL.count:format(self:GetRename(1305993), tollCount)
	tollCount = tollCount + 1

	local remaining, total = self:BarTimeLeft(barText)
	local newDuration = remaining > 1 and { duration, total } or nil

	return {
		duration = newDuration,
		msg = barText,
		key = 1305993,
	}
end

-- Stage 2

function mod:Invoke(duration)
	local barText = CL.count:format(self:GetRename(1299673), invokeCount)
	local messageText = CL.casting:format(barText)
	invokeCount = invokeCount + 1

	local barOnFinish = gapTimer(1299673, duration)
	local remaining, total = self:BarTimeLeft(barText)
	local newDuration = remaining > 1 and { duration, total } or nil

	return {
		duration = newDuration,
		msg = barText,
		key = 1299673,
		onFinished = function()
			self:Message(1299673, "orange", messageText)
			self:PlaySound(1299673, "alarm")

			-- self:Bar(1293497, 5) -- Entwined Step

			if barOnFinish then
				self:Bar(1299673, barOnFinish, CL.count:format(self:GetRename(1299673), invokeCount))
			end
		end
	}
end
