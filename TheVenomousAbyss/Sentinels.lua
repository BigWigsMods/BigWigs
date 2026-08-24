
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Entombed Sentinels", 3004, 2874)
if not mod then return end
mod:RegisterEnableMob(258557, 258556) -- Breath of Ula'tek, Blood of Ula'tek
mod:SetEncounterID(3445)
mod:SetRespawnTime(30)
mod:UseCustomTimers(true)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}

local durationEventCount = {}
local isIntermission = nil
local berserkCD = 0
local nextStasis = 0

local dropletsCount = 1
local coagulationCount = 1
local slamCount = 1
local miasmaCount = 1
local bloodCount = 1
local injectionCount = 1
local protovenomCount = 1

--------------------------------------------------------------------------------
-- Localization
--

-- local L = mod:SetDefaultLocale({
-- })

--------------------------------------------------------------------------------
-- Renames
--

mod:SetRenames({
	["berserk"] = {26662, CL.custom_end:format(mod.displayName, mod:SpellName(26662)), notes = {CL.timerNote, CL.messageNote}}, -- Berserk
	[1284588] = {CL.intermission, CL.over:format(CL.intermission), original = {1284588, CL.over:format(mod:SpellName(1284588))}}, -- Vitriolic Stasis
	[1296878] = {1296878, CL.soon:format(mod:SpellName(1296878)), original = false}, -- Shifting Protovenom
	[1284251] = {CL.add, CL.add_spawning, original = false}, -- Venom Coagulation
	[1284434] = {1284434}, -- Toxic Droplets
	[1284458] = {1284458}, -- Empowering Slam
	[1284483] = {CL.dispels}, -- Blighted Blood
	[1288232] = {CL.soak, CL.you:format(CL.soak), original = {1288232, CL.you:format(mod:SpellName(1288232))}, notes = {CL.generalNote, CL.messageOnYouNote}}, -- Unstable Miasma
	[1284487] = {1284487}, -- Bloodvenom Injection
})

--------------------------------------------------------------------------------
-- Options
--

mod:SetAuraData({
	{1284590, soundOnApplied = "warning", soundOnAppliedDose = "none", header = CL.important}, -- Helical Toxins
	{1296880, soundOnApplied = "warning", mythic = true, note = CL.mythic}, -- Shifting Protovenom
	{1288260, soundOnApplied = "warning"}, -- Unstable Miasma
	{1284471, soundOnApplied = "alarm", header = CL.general}, -- Blighted Blood -- DoT; Drops pool when removed
	{1284210, soundOnApplied = "underyou"}, -- Blood Venom -- Standing in bad
	{1284491, soundOnApplied = "none", soundOnAppliedDose = "none", note = CL.tank_debuff}, -- Bloodvenom Injection -- Tank stacks; Drops pool when expires
	{1288297, soundOnApplied = "none", soundOnAppliedDose = "none"}, -- Clinging Murk -- Soaked Miasma; Drops pool when expires
	{1284947, soundOnApplied = "none"}, -- Cultivated Burst -- Fail DoT
	{1284500, soundOnApplied = "none", soundOnAppliedDose = "none"}, -- Mark of Acid
	{1284506, soundOnApplied = "none", soundOnAppliedDose = "none"}, -- Mark of Blood
})

function mod:GetOptions()
	return {
		1284588, -- Vitriolic Stasis
		"berserk",

		-- Vashnik the Malignant (Mythic)
		1296878, -- Shifting Protovenom

		-- Breath of Ula'tek
		1284251, -- Venom Coagulation
		1284434, -- Toxic Droplets
		{1284458, "TANK"}, -- Empowering Slam

		-- Blood of Ula'tek
		1284483, -- Blighted Blood
		1288232, -- Unstable Miasma
		{1284487, "TANK"}, -- Bloodvenom Injection
	}, {
		[1284251] = -34951, -- Breath of Ula'tek
		[1284483] = -34953, -- Blood of Ula'tek
		[1296878] = CL.mythic, -- -35867, -- Vashnik the Malignant
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
	isIntermission = nil

	dropletsCount = 1
	coagulationCount = 1
	slamCount = 1
	miasmaCount = 1
	bloodCount = 1
	injectionCount = 1
	protovenomCount = 1

	local stasisCD = 46
	self:Bar(1284588, stasisCD, CL.count:format(self:GetRename(1284588), 1)) -- Vitriolic Stasis
	nextStasis = self.stageTime + stasisCD

	berserkCD = 0
	if self:Heroic() then
		berserkCD = 540
		self:Bar("berserk", berserkCD, self:GetRename("berserk"), 26662)
	elseif self:Mythic() then
		self:Bar(1296878, 36, CL.count:format(self:GetRename(1296878), protovenomCount)) -- Shifting Protovenom
		berserkCD = 420
		self:Bar("berserk", berserkCD, self:GetRename("berserk"), 26662)
	end
end

-- Blizzard adds then cancels a few seconds later if they aren't going to happen which messes up counts.
local function isBeforeVitriolicStasis(duration)
	return GetTime() + duration < nextStasis
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

-- Mythic/Heroic/Normal were the same in testing
function mod:ENCOUNTER_TIMELINE_EVENT_ADDED(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo = nil

	local stage = self:GetStage()
	local duration = eventInfo.duration
	local rounded1 = self:RoundNumber(duration, 1)
	local rounded = self:RoundNumber(rounded1, 0)

	if isIntermission then
		-- local elapsed = GetTime() - nextStasis
		self:Message(1284588, "green", self:GetRename(1284588, 2), false)
		self:PlaySound(1284588, "long")

		isIntermission = nil
		stage = stage + 1
		self:SetStage(stage)

		local stasisCD = 91
		nextStasis = self.stageTime + stasisCD
		if self:ShouldShowBars() then
			self:Bar(1284588, stasisCD, CL.count:format(self:GetRename(1284588), stage)) -- Vitriolic Stasis

			if self:Mythic() then
				self:Bar(1296878, 39.9, CL.count:format(self:GetRename(1296878), protovenomCount)) -- Shifting Protovenom
			end
		end
	end

	durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1

	-- Blizzard adds the initial stage (not on pull, though) timers three times, first two sets get canceled
	local initalTimers = {
		[12] = true, -- Toxic Droplets
		[8] = true, -- Venom Coagulation
		[4] = true, -- Empowering Slam
		[16] = true, -- Unstable Miasma
		[40] = true, -- Blighted Blood
		[6] = true, -- Bloodvenom Injection
	}
	if stage > 1 and initalTimers[rounded] and durationEventCount[rounded] < 3 then
		return false
	end

	-- Don't show events that will get canceled (skipping Vitriolic Stasis itself)
	if duration ~= 20 and duration ~= 15 and not isBeforeVitriolicStasis(duration) then
		return false
	end

	if rounded == 12 or rounded == 32 then
		barInfo = self:ToxicDroplets()
	elseif rounded == 8 or rounded == 10 or rounded1 == 51.5 then -- rounded (52) same as Blighted Blood
		-- XX 8=>10 on normal
		barInfo = self:VenomCoagulation()
	elseif rounded == 4 then
		barInfo = self:EmpoweringSlam()

	elseif rounded == 16 or rounded == 41 then
		barInfo = self:UnstableMiasma()
	elseif rounded == 40 or rounded == 52 then
		barInfo = self:BlightedBlood()
	elseif rounded == 6 then
		barInfo = self:BloodvenomInjection()
	elseif rounded == 15 then
		barInfo = self:BerserkEvent()
		if berserkCD > 0 then
			-- replace our bar with the blizzard one
			barInfo.duration = { duration, berserkCD }
		end

	elseif rounded == 20 then
		if stage == 1 then
			if durationEventCount[rounded] % 2 > 0 and self:Mythic() then
				barInfo = self:ShiftingProtovenom()
			else
				barInfo = self:VitriolicStasis(duration)
			end
		else
			if durationEventCount[rounded] % 3 > 0 and self:Mythic() then
				barInfo = self:ShiftingProtovenom()
			else
				barInfo = self:VitriolicStasis(duration)
			end
		end

	elseif rounded == 22 then -- 21.5
		-- XXX these can flip if you delay Slam by running around, should probably use UNIT_SPELLCAST_START to track which one starts
		if durationEventCount[rounded] % 2 == 1 then
			barInfo = self:EmpoweringSlam()
		else
			barInfo = self:BloodvenomInjection()
		end
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
	if barInfo then

		if barInfo.key == 1296878 and state == 2 and self:ShouldShowBars() then -- Shifting Protovenom Finished
			self:StopBlizzMessages(0.3) -- Vashnik infects players with a [Shifting Protovenom]!
			-- self:Message(1296878, "red", self:GetRename(1296878, 2))
			self:ScheduleTimer(function()
				self:StopBar(barInfo.msg)
				barInfo:onFinished()
			end, 5)
			return true -- skip state
		end

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

function mod:BerserkEvent()
	local barText = self:GetRename("berserk")

	return {
		msg = barText,
		icon = 26662,
		key = "berserk",
		onFinished = function()
			self:StopBlizzMessages(2)
			self:Message("berserk", "red", self:GetRename("berserk", 2), 26662)
			self:PlaySound("berserk", "alarm")
		end,
	}
end

function mod:ShiftingProtovenom()
	local barText = CL.count:format(self:GetRename(1296878), protovenomCount)
	protovenomCount = protovenomCount + 1

	-- event duration is 20. finishes at 18, Vashnik yells and "casts" for 4s, debuffs apply 1s later at 23
	-- show timer/message for when debuffs go out
	local duration = 23
	-- event fires mid fight, extend the bar we start
	local remaining, total = self:BarTimeLeft(barText)
	local newDuration = remaining > 1 and { duration, total } or duration
	-- show a bar for the next cast on end (since blizzard doesn't)
	local barOnFinish = self:GetStage() > 1 and protovenomCount < 3 and 41 or nil -- debuff to debuff time

	-- finish is handled in OnTimelineEventChanged
	return {
		duration = newDuration,
		msg = barText,
		key = 1296878,
		onFinished = function()
			-- self:StopBlizzMessages(0.3) -- Vashnik infects players with a [Shifting Protovenom]!
			self:Message(1296878, "red", barText)
			-- self:PlaySound(1296878, "warning")

			if barOnFinish then
				self:Bar(1296878, barOnFinish, CL.count:format(self:GetRename(1296878), protovenomCount))
			end
		end,
	}
end

function mod:VitriolicStasis(duration)
	local barText = CL.count:format(self:GetRename(1284588), self:GetStage())

	-- event fires once mid fight, correct the bar we start
	local newDuration = { duration, nextStasis - self.stageTime }
	nextStasis = GetTime() + duration

	local barInfo = {
		duration = newDuration,
		msg = barText,
		key = 1284588,
		onFinished = function(this)
			self:CancelTimer(this.blocktimer)
			self:CancelTimer(this.timer)
			if isIntermission then return end

			isIntermission = true
			durationEventCount = {}

			dropletsCount = 1
			coagulationCount = 1
			slamCount = 1
			miasmaCount = 1
			bloodCount = 1
			injectionCount = 1
			protovenomCount = 1

			self:StopBlizzMessages(6) -- The Golems of Ula'tek infect players with [Helical Toxins]!
			self:Message(1284588, "cyan", barText)
			self:PlaySound(1284588, "long")
		end,
	}
	-- can bug out finishing on time (gets delayed ~1s), but the cancel event is way later (~5s) if that happens
	barInfo.timer = self:ScheduleTimer(function()
		self:StopBar(barInfo.msg)
		barInfo:onFinished()
	end, duration + 1)
	-- always try blocking when it should start (to cover the gap in the above)
	barInfo.blocktimer = self:ScheduleTimer(function()
		self:StopBlizzMessages(1)
	end, duration)

	return barInfo
end

-- Breath of Ula'tek

function mod:ToxicDroplets()
	local barText = CL.count:format(self:GetRename(1284434), dropletsCount)
	dropletsCount = dropletsCount + 1

	return {
		msg = barText,
		key = 1284434,
		onFinished = function()
			self:Message(1284434, "yellow", barText)
			-- self:PlaySound(1284434, "alarm")
		end,
	}
end

function mod:VenomCoagulation()
	local barText = CL.count:format(self:GetRename(1284251), coagulationCount)
	local messageText = CL.soon:format(barText)
	coagulationCount = coagulationCount + 1

	return {
		msg = barText,
		key = 1284251,
		onFinished = function()
			self:StopBlizzMessages(0.4) -- Breath of Ula'tek hurls forth a [Venom Coagulation]!
			self:Message(1284251, "cyan", messageText)
			self:CDBar(1284251, 5.5, self:GetRename(1284251, 2)) -- Add spawning
			self:PlaySound(1284251, "info")

			self:RegisterBossEvent("boss3", function() -- catch the next IEEU
				self:StopBar(self:GetRename(1284251, 2))
				self:UnregisterBossEvent("boss3")
			end)
		end,
	}
end

function mod:EmpoweringSlam()
	local barText = CL.count:format(self:GetRename(1284458), slamCount)
	slamCount = slamCount + 1

	return {
		msg = barText,
		key = 1284458,
		onFinished = function()
			if self:ThreatTarget("player", "boss1") then
				self:Message(1284458, "purple", barText)
				self:PlaySound(1284458, "alert")
			end
		end,
	}
end

-- Blood of Ula'tek

function mod:UnstableMiasma()
	local barText = CL.count:format(self:GetRename(1288232), miasmaCount)
	miasmaCount = miasmaCount + 1

	return {
		msg = barText,
		key = 1288232,
		onFinished = function()
			-- Blood of Ula'tek targets you with [Unstable Miasma]!
			-- 1.5s from begincast to applydebuff
			self:PersonalMessageFromBlizzMessage(1288232, 2, false, self:GetRename(1288232, 2))

			self:Message(1288232, "orange", barText)
			self:PlaySound(1288232, "alert")
		end,
	}
end

function mod:BlightedBlood()
	local barText = CL.count:format(self:GetRename(1284483), bloodCount)
	bloodCount = bloodCount + 1

	return {
		msg = barText,
		key = 1284483,
		onFinished = function()
			self:Message(1284483, "yellow", barText)
			if self:Dispeller("magic") then
				self:PlaySound(1284483, "alert")
			end
		end,
	}
end

function mod:BloodvenomInjection()
	local barText = CL.count:format(self:GetRename(1284487), injectionCount)
	injectionCount = injectionCount + 1

	return {
		msg = barText,
		key = 1284487,
		onFinished = function()
			if self:ThreatTarget("player", "boss2") then
				self:Message(1284487, "purple", barText)
				self:PlaySound(1284487, "alert")
			end
		end,
	}
end
