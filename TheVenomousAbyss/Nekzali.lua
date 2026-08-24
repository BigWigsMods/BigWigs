
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
local spellCount = {}

local ignitionCount = 1
local graspingDepthsCount = 1
local graspingDepthsCountStart = 1

local gapTimer do
	local timers = {
		[1295397] = {  -- Restless Amani
			[1] = { [40] = 71 },
			[1.5] = { [30] = 40 },
			[2] = { [40] = 40 },
		},
		[1287426] = { -- Essence Rend
			[1] = { [40] = 31 },
			[2] = { [49.5] = 80 },
		},
		[1292036] = { -- Possession Barrage
			[1] = { [36] = 35 },
			[2] = { [28] = 52 },
		},
		[1305421] = { -- Hungering Pyre
			[1.5] = { [11] = 40 },
		},
		[1299673] = { -- Invoke
			[2] = { [48] = 32 },
		},
	}
	local mythicIntermission = {
		[1295397] = { [25] = 35 }, -- Restless Amani
		[1305421] = { [11] = 35 }, -- Hungering Pyre
	}
	function gapTimer(spellId, duration)
		local spellTimers = timers[spellId]
		if not spellTimers then return end
		if duration == true then
			return true
		end

		local stage = mod:GetStage()
		local stageTimers = spellTimers[stage]
		if stage == 1.5 and mod:Mythic() then
			stageTimers = mythicIntermission[spellId]
		end
		return stageTimers and stageTimers[duration]
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
	-- [1289696] = {CL.big_adds}, -- Tether of Awakening
	[1293212] = {1293212}, -- Grasping Depths
	[1305421] = {CL.soak}, -- Hungering Pyre
	[1299673] = {1299673}, -- Invoke
})

--------------------------------------------------------------------------------
-- Options
--

mod:SetAuraData({
	{1306666, soundOnApplied = "warning", soundOnAppliedDose = "none", duration = 7.5, header = CL.important}, -- Hungering Pyre
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
		-- 1289696, -- Tether of Awakening
		1305421, -- Hungering Pyre
		-- Restless Amani

		-- Stage Two: Uncoiling
		1299673, -- Invoke
		-- Possession Barrage
	}, {
		[1293212] = "mythic",
		[1285681] = -36184, -- Stage 1
		[1305421] = -35255, -- Intermission
		[1299673] = -36195, -- Stage 2
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
	self:SetStage(1)
	durationEventCount = {}

	spellCount = {
		[1287426] = 1, -- Essence Rend
		[1295397] = 1, -- Restless Amani
		[1292036] = 1, -- Possession Barrage
		[1305421] = 1, -- Hungering Pyre
		[1299673] = 1, -- Invoke
		[1293212] = 1, -- Grasping Depths
	}
	-- ignitionCount = 1
	-- graspingDepthsCount = 1
	-- graspingDepthsCountStart = 1

	-- if self:ShouldShowBars() then
	-- 	self:Bar(1285681, 3, CL.count:format(self:GetRename(1285681), ignitionCount)) -- Soulcoil Ignition
	-- 	repeaters[1285681] = self:ScheduleTimer("SoulcoilIgnitionRepeater", 3)

	-- 	if self:Mythic() then
	-- 		self:Bar(1293212, 42.5, CL.count:format(self:GetRename(1293212), graspingDepthsCount)) -- Grasping Depths
	-- 		repeaters[1293212] = self:ScheduleTimer("GraspingDepthsRepeater", 42.5)
	-- 	end
	-- end

	self:RegisterUnitEvent("UNIT_SPELLCAST_START", nil, "boss1")
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:ENCOUNTER_TIMELINE_EVENT_ADDED(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo = nil

	local stage = self:GetStage()
	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	-- stage 1
	if stage < 2 then
		if rounded == 40 or rounded == 28 or rounded == 15 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] == 1 then
				return false -- first bar is cancelled
			end
		end

		if rounded == 40 then
			if durationEventCount[rounded] % 2 == 0 then -- swapped due to the canceled timer
				barInfo = self:RestlessAmani()
			else
				barInfo = self:EssenceRend()
			end
		elseif rounded == 28 or rounded == 36 then
			barInfo = self:PossessionBarrage()
		elseif rounded == 15 then
			barInfo = self:EssenceRend()

		-- intermission
		elseif rounded == (self:Mythic() and 25 or 30) then
			barInfo = self:RestlessAmani()
		elseif rounded == 11 then
			barInfo = self:HungeringPyre()
		end

	-- stage 2
	else
		if rounded == 8 or rounded == 48 then
			barInfo = self:Invoke()
		elseif rounded == 28 then
			barInfo = self:PossessionBarrage()
		elseif rounded == 40 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] % 2 == 1 then
				barInfo = self:PossessionBarrage()
			else
				barInfo = self:RestlessAmani()
			end
		elseif rounded == 50 then
			barInfo = self:EssenceRend()
		elseif rounded == 20 then
			barInfo = self:RestlessAmani()
		end
	end

	if barInfo and gapTimer(barInfo.key, true) then
		-- blizzard fires sets of bars on an interval, bridge the gap with a normal bar
		barInfo.gapTimer = gapTimer(barInfo.key, self:RoundNumber(eventInfo.duration, 1))
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

	if barInfo and barInfo.gapTimer and state == 2 then -- Finished
		self:Bar(barInfo.key, barInfo.gapTimer, CL.count:format(self:GetRename(barInfo.key), spellCount[barInfo.key]))
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
			self:StopBar(CL.count:format(self:GetRename(1295397), spellCount[1295397])) -- Restless Amani
			self:StopBar(CL.count:format(self:GetRename(1287426), spellCount[1287426])) -- Essence Rend
			self:StopBar(CL.count:format(self:GetRename(1292036), spellCount[1292036])) -- Possession Barrage
			if self:Mythic() then
				self:CancelTimer(repeaters[1293212])
				self:StopBar(CL.count:format(self:GetRename(1293212), graspingDepthsCount)) -- Grasping Depths
			end

			durationEventCount = {}

			spellCount[1287426] = 1 -- Essence Rend
			spellCount[1295397] = 1 -- Restless Amani
			spellCount[1292036] = 1 -- Possession Barrage

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
			-- self:Bar(1289696, 20) -- Tether of Awakening
			if not self:Mythic() then
				local gap = 16.5
				self:Bar(1305421, 11 + gap, CL.count:format(self:GetRename(1305421), spellCount[1305421])) -- Hungering Pyre
				self:Bar(1295397, 30 + gap, CL.count:format(self:GetRename(1295397), spellCount[1295397])) -- Restless Amani
			elseif self:Mythic() then
				self:Bar(1305421, 7, CL.count:format(self:GetRename(1305421), spellCount[1305421])) -- Hungering Pyre
				self:Bar(1295397, 26, CL.count:format(self:GetRename(1295397), spellCount[1295397])) -- Restless Amani

				-- restart with the same count so down groups can stay consistent
				-- self:Bar(1293212, 23.5, CL.count:format(self:GetRename(1293212), graspingDepthsCount)) -- Grasping Depths
				-- repeaters[1293212] = self:ScheduleTimer("GraspingDepthsRepeater", 23.5)
				-- graspingDepthsCountStart = graspingDepthsCount
			end
		end

	elseif stage == 1.5 then -- Uncoiling
		self:UnregisterUnitEvent(event, unit)

		self:StopBar(CL.count:format(self:GetRename(1295397), spellCount[1295397])) -- Restless Amani
		self:StopBar(CL.count:format(self:GetRename(1305421), spellCount[1305421])) -- Hungering Pyre

		durationEventCount = {}

		spellCount[1287426] = 1 -- Essence Rend
		spellCount[1295397] = 1 -- Restless Amani
		spellCount[1292036] = 1 -- Possession Barrage

		self:SetStage(2)
		if self:ShouldShowBars() then
			self:Message("stages", "cyan", self:GetRename("stages", 2), false) -- Stage 2
			self:PlaySound("stages", "long")

			local gap = 5
			self:Bar(1299673, 8 + gap, CL.count:format(self:GetRename(1299673), spellCount[1299673])) -- Invoke
			self:Bar(1292036, 40 + gap, CL.count:format(self:GetRename(1292036), spellCount[1292036])) -- Possession Barrage
			self:Bar(1287426, 49.5 + gap, CL.count:format(self:GetRename(1287426), spellCount[1287426])) -- Essence Rend
			self:Bar(1295397, 20 + gap, CL.count:format(self:GetRename(1295397), spellCount[1295397])) -- Restless Amani

			-- if self:Mythic() then
			-- 	self:CancelTimer(repeaters[1293212])
			-- 	-- restart with the same count so down groups can stay consistent
			-- 	self:Bar(1293212, 27.5, CL.count:format(self:GetRename(1293212), graspingDepthsCount)) -- Grasping Depths
			-- 	repeaters[1293212] = self:ScheduleTimer("GraspingDepthsRepeater", 27.5)
			-- 	graspingDepthsCountStart = graspingDepthsCount
			-- end
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

	local cd = 74.9
	self:Bar(1285681, cd, CL.count:format(self:GetRename(1285681), ignitionCount))
	repeaters[1285681] = self:ScheduleTimer("SoulcoilIgnitionRepeater", cd)
end

function mod:EssenceRend()
	local barText = CL.count:format(self:GetRename(1287426), spellCount[1287426])
	spellCount[1287426] = spellCount[1287426] + 1

	return {
		msg = barText,
		key = 1287426,
		onFinished = function()
			local timer = self:ScheduleTimer(function() self:Message(1287426, "yellow", barText) end, 0.35)
			self:PersonalMessageFromBlizzMessage(1287426, 0.3, false, self:GetRename(1287426, 2), nil, nil, function() self:CancelTimer(timer) end)
		end
	}
end

function mod:RestlessAmani()
	local barText = CL.count:format(self:GetRename(1295397), spellCount[1295397])
	local messageText = CL.soon:format(barText)
	spellCount[1295397] = spellCount[1295397] + 1

	return {
		msg = barText,
		key = 1295397,
		onFinished = function()
			self:StopBlizzMessages(0.5)
			self:Message(1295397, "cyan", messageText)
			self:PlaySound(1295397, "info")

			-- x3 12.6, x3 14.2, x1 15.7 (p1)
			self:Bar(1287533, 12.6, self:GetRename(1287533)) -- Gravebound Advance
		end
	}
end

function mod:PossessionBarrage()
	local barText = CL.count:format(self:GetRename(1292036), spellCount[1292036])
	spellCount[1292036] = spellCount[1292036] + 1

	return {
		msg = barText,
		key = 1292036,
		onFinished = function()
			self:Message(1292036, "purple", barText)
			-- self:PlaySound(1292036, "alert")
			-- 6s cast on current target, then 2s channel
		end
	}
end

function mod:GraspingDepthsRepeater()
	self:StopBar(CL.count:format(self:GetRename(1293212), graspingDepthsCount))
	self:Message(1293212, "cyan", CL.count:format(self:GetRename(1293212), graspingDepthsCount))
	self:PlaySound(1293212, "long")
	graspingDepthsCount = graspingDepthsCount + 1

	-- we don't reset the count, but the cd increases with each cast so we need a starting point
	local stage = self:GetStage()
	local cd
	if stage == 1 then
		-- 42.5, 71.0, 71.0
		cd = 71
	elseif stage == 1.5 then
		local timers = { 23.5, 35.0, 74.9 }
		local count = graspingDepthsCount - graspingDepthsCountStart
		cd = timers[count]
	elseif stage == 2 then
		local timers = { 27.5, 40.0, 80.0 }
		local count = graspingDepthsCount - graspingDepthsCountStart
		cd = timers[count]
	end
	if cd then
		self:Bar(1293212, cd, CL.count:format(self:GetRename(1293212), graspingDepthsCount))
		repeaters[1293212] = self:ScheduleTimer("GraspingDepthsRepeater", cd)
	end
end

-- Intermission

function mod:HungeringPyre()
	local barText = CL.count:format(self:GetRename(1305421), spellCount[1305421])
	spellCount[1305421] = spellCount[1305421] + 1

	return {
		msg = barText,
		key = 1305421,
		onFinished = function()
			self:Message(1305421, "orange", barText)
			-- self:PlaySound(1305421, "alert")
		end
	}
end

-- Stage 2

function mod:Invoke()
	local barText = CL.count:format(self:GetRename(1299673), spellCount[1299673])
	local messageText = CL.casting:format(barText)
	spellCount[1299673] = spellCount[1299673] + 1

	return {
		msg = barText,
		key = 1299673,
		onFinished = function()
			self:Message(1299673, "orange", messageText)
			self:PlaySound(1299673, "alarm")
		end
	}
end
