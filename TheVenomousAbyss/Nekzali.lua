
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

local durationEventCount = {}
local repeaters = {}
local spellCount = {}

local ignitionCount = 1
local graspingDepthsCount = 1

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
	[1287426] = {1287426, CL.you:format(mod:SpellName(1287426)), notes = {CL.generalNote, CL.messageOnYouNote}}, -- Essence Rend
	[1295397] = {CL.adds}, -- Restless Amani
	[1287533] = {CL.adds_spawning}, -- Gravebound Advance
	[1292036] = {L.possession_barrage, CL.you:format(L.possession_barrage), CL.cast:format(L.possession_barrage), original = {1292036, CL.you:format(mod:SpellName(1292036)), CL.cast:format(mod:SpellName(1292036))}, notes = {CL.generalNote, CL.messageOnYouNote, CL.castTimerNote}}, -- Possession Barrage
	[1293212] = {1293212}, -- Grasping Depths
	[1305421] = {CL.soak, CL.cast:format(CL.soak), notes = {CL.generalNote, CL.castTimerNote}, original = {1305421, CL.cast:format(mod:SpellName(1305421))}}, -- Hungering Pyre
	[1299673] = {1299673, CL.cast:format(mod:SpellName(1299673)), notes = {CL.generalNote, CL.castTimerNote}}, -- Invoke
})

--------------------------------------------------------------------------------
-- Options
--

mod:SetAuraData({
	{1306666, soundOnApplied = "warning", soundOnAppliedDose = "none", header = CL.important}, -- Hungering Pyre
	{1284103, soundOnApplied = "warning"}, -- Possession Barrage
	{1284109, soundOnApplied = "none", soundOnAppliedDose = "none", note = CL.tank_debuff}, -- Hollowing Strikes -- Tank Stacks
	{1287434, soundOnApplied = "warning", dispel = "magic"}, -- Essence Rend
	{1293214, soundOnApplied = "none", soundOnAppliedDose = "none", difficulty = "mythic"}, -- Grasping Depths

	{1297624, soundOnApplied = "none", soundOnAppliedDose = "none", header = CL.general}, -- Ritual Burn
	{1288772, soundOnApplied = "none", soundOnAppliedDose = "none"}, -- Soulcoil Rite
	{1285623, soundOnApplied = "none"}, -- Soulcoil Well
	{1300524, 1300521, soundOnApplied = "none", difficulty = "mythic"}, -- Immortal Coil
	{1299988, soundOnApplied = "none", difficulty = "mythic"}, -- Immortal Coil
	{1290361, 1292751, soundOnApplied = "none", difficulty = "mythic"}, -- Soulcoiled
	{1300235, soundOnApplied = "none", difficulty = "mythic"}, -- Soul Exhaustion
	{1300239, soundOnApplied = "none", soundOnAppliedDose = "none", difficulty = "mythic"}, -- Swirling Spirit

	{1307939, soundOnApplied = "none", soundOnAppliedDose = "none", header = CL.intermission}, -- Corpse Blight
	{1289875, soundOnApplied = "none"}, -- Cremation
	{1288554, soundOnApplied = "none"}, -- Latent Cultist
	{1294933, soundOnApplied = "alarm"}, -- Slithering Flame -- Note: Failed Soaking
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
			1287533, -- Gravebound Advance
		{1292036, "CASTBAR"}, -- Possession Barrage

		-- Intermission: Ritual of Awakening
		{1305421, "CASTBAR"}, -- Hungering Pyre

		-- Stage Two: Uncoiling
		{1299673, "CASTBAR"}, -- Invoke
	}, {
		{
			tabName = self:SpellName(-36184), -- Stage 1
			{ "stages", 1285681, 1287426, 1295397, 1287533, 1292036, 1293212 },
		},
		{
			tabName = self:SpellName(-35255), -- Intermission
			 { "stages", 1305421, 1295397, 1287533, 1293212 },
		},
		{
			tabName = self:SpellName(-36195), -- Stage 2
			{ "stages", 1299673, 1287426, 1295397, 1287533, 1293212 },
		},
		[1293212] = "mythic",
	}
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	self:RegisterTimelineEvents()
end

function mod:OnEncounterStart()
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

	if self:ShouldShowBars() then
		ignitionCount = 1
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
	self:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "UNIT_SPELLCAST_SUCCEEDED", "boss1")
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:OnTimelineEventAdded(eventInfo)
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

	return barInfo
end

function mod:OnTimelineEventChanged(barInfo, eventID, state)
	if self:GetStage() == 1 and state == 3 and self:ShouldShowBars() and not self:IsWiping() and GetTime() - self.stageTime > 1 then -- Canceled
		-- stop p1 gap bars with blizzard bars
		self:CancelTimer(repeaters[1285681])
		self:StopBar(CL.count:format(self:GetRename(1285681), ignitionCount)) -- Soulcoil Ignition
		self:StopBar(CL.count:format(self:GetRename(1295397), spellCount[1295397])) -- Restless Amani
		self:StopBar(CL.count:format(self:GetRename(1287426), spellCount[1287426])) -- Essence Rend
		self:StopBar(CL.count:format(self:GetRename(1292036), spellCount[1292036])) -- Possession Barrage
		if self:Mythic() then
			self:CancelTimer(repeaters[1293212])
			self:StopBar(CL.count:format(self:GetRename(1293212), graspingDepthsCount)) -- Grasping Depths
	 	end
	end

	if barInfo and barInfo.gapTimer and state == 2 then -- Finished (reuse the eventID to set the spell indicator for the next bar)
		-- start gap bar
		self:Bar(barInfo.key, barInfo.gapTimer, CL.count:format(self:GetRename(barInfo.key), spellCount[barInfo.key]), nil, eventID)
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local startTime = 0
	function mod:UNIT_SPELLCAST_START()
		startTime = GetTime()
	end
	function mod:UNIT_SPELLCAST_SUCCEEDED(event, unit)
		if GetTime() - startTime < 2 or event == "UNIT_SPELLCAST_INTERRUPTED" then -- Ritual of Awakening 1.5s
			self:UnregisterUnitEvent("UNIT_SPELLCAST_START", unit)
			self:UnregisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", unit)
			self:UnregisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", unit)
			self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", nil, unit)

			self:EndPhaseOne()
		end
	end
end

function mod:UNIT_SPELLCAST_CHANNEL_START(event, unit)
	local stage = self:GetStage()
	if stage == 1 then -- Ritual of Awakening
		self:StartIntermission()

	elseif stage == 1.5 then -- Uncoiling
		self:UnregisterUnitEvent(event, unit)
		self:StartPhaseTwo()
	end
end

function mod:EndPhaseOne()
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

	if self:ShouldShowBars() then
		-- stage set in channel, which is ~1s later (runs to the well)
		self:Message("stages", "cyan", self:GetRename("stages", 1), false) -- Intermission
		self:PlaySound("stages", "long")
	end
end

function mod:StartIntermission()
	self:SetStage(1.5)

	if self:ShouldShowBars() then
		local gap = 16.5
		self:Bar(1305421, 11 + gap, CL.count:format(self:GetRename(1305421), spellCount[1305421])) -- Hungering Pyre
		self:Bar(1295397, (self:Mythic() and 25 or 30) + gap, CL.count:format(self:GetRename(1295397), spellCount[1295397])) -- Restless Amani

		if self:Mythic() then
			-- restart with the same count so down groups can stay consistent
			local ritualChannel = 20.5
			local graspingDepthsCD = ritualChannel + 23.5
			self:Bar(1293212, graspingDepthsCD, CL.count:format(self:GetRename(1293212), graspingDepthsCount)) -- Grasping Depths
			repeaters[1293212] = self:ScheduleTimer("GraspingDepthsRepeater", graspingDepthsCD)
		end
	end
end

function mod:StartPhaseTwo()
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

		if self:Mythic() then
			self:CancelTimer(repeaters[1293212])
			-- restart with the same count so down groups can stay consistent
			local graspingDepthsCD = 27.5
			self:Bar(1293212, graspingDepthsCD, CL.count:format(self:GetRename(1293212), graspingDepthsCount)) -- Grasping Depths
			repeaters[1293212] = self:ScheduleTimer("GraspingDepthsRepeater", graspingDepthsCD)
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

	-- XXX these are mean values with a few seconds of variance, what causes it x.x
	-- The two gaps don't overlap (73.7-75.3 and 68.7-71.7)
	local timers = { 3.0, 74.5, 70.5 }
	local cd = timers[ignitionCount]
	if cd then
		self:Bar(1285681, cd, CL.count:format(self:GetRename(1285681), ignitionCount))
		repeaters[1285681] = self:ScheduleTimer("SoulcoilIgnitionRepeater", cd)
	end
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

function mod:PossessionBarrage(duration)
	local barText = CL.count:format(self:GetRename(1292036), spellCount[1292036])
	spellCount[1292036] = spellCount[1292036] + 1
	return {
		msg = barText,
		key = 1292036,
		onFinished = function()
			local timer = self:ScheduleTimer(function()
				self:Message(1292036, "purple", barText)
				self:PlaySound(1292036, "alert")
			end, 1)
			self:PersonalMessageFromBlizzMessage(1284103, 1, false, self:GetRename(1292036, 2), nil, nil, function()
				self:CancelTimer(timer)
				self:PlaySound(1292036, "warning")
			end)
			self:CastBar(1292036, 6, 3)
		end
	}
end

function mod:GraspingDepthsRepeater()
	self:StopBar(CL.count:format(self:GetRename(1293212), graspingDepthsCount))
	self:Message(1293212, "cyan", CL.count:format(self:GetRename(1293212), graspingDepthsCount))
	self:PlaySound(1293212, "long")
	graspingDepthsCount = graspingDepthsCount + 1

	-- Measured over 9 mythic pulls. Stage 1 and stage 2 hold their interval exactly; the
	-- intermission is the loose one, sitting on 35 about half the time and drifting otherwise
	local stage = self:GetStage()
	local cd
	if stage == 1 then
		cd = 71
	elseif stage == 1.5 then
		cd = 35
	elseif stage == 2 then
		cd = 40
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
			self:CastBar(1305421, 7.5, 2)
			if not self:Tank() then
				self:PlaySound(1305421, "alert")
			end
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
			self:CastBar(1299673, 5, 2)
			self:PlaySound(1299673, "alarm")
		end
	}
end
