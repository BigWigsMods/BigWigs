
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Coiled Altar", 3004, 2883)
if not mod then return end
mod:RegisterEnableMob(257911, 259854) -- Zul'jan, Hex Lord Malacrass
mod:SetEncounterID(3429)
mod:SetRespawnTime(30)
mod:UseCustomTimers(true)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}

local durationEventCount = {}
local warnStageThree = false

local toxicDelugeCount = 1
local axegrinderCount = 1
local venomfangCount = 1
local guillotineCount = 1
local severCount = 1
local coiledAltarCount = 1 -- 100 energy abilities

local dreadmarchCount = 1
local eternalNightfallCount = 1
local spiritcackleCount = 1
local gloombombCount = 1

local gapTimer do
	local timersMythic = {
		[1299960] = { [1] = { [43] = 42 } }, -- Toxic Deluge
		[1283489] = { [1] = { [43] = 85 } }, -- Guillotine
		[1299680] = { [1] = { [17] = 31 } }, -- Sever
		[1282281] = { [1] = { [35] = 50 } }, -- Venomfang
		[1283832] = { [1] = { [12] = 85 } }, -- Axegrinder

		[1286441] = { [2] = { [33] = 52 } }, -- Spiritcackle
		[1286918] = { [2] = { [70] = 85 } }, -- Eternal Nightfall
		[1289900] = { [2] = { [34] = 51 } }, -- Dreadmarch
		[1286895] = { [2] = { [37] = 48 } }, -- Gloombomb
		[1286573] = { [2] = { [31] = 54 } }, -- Soul Sever
	}
	function gapTimer(spellId, duration)
		if mod:Mythic() then
			local stage = mod:GetStage()
			return timersMythic[spellId][stage] and timersMythic[spellId][stage][duration]
		end
	end
end

--------------------------------------------------------------------------------
-- Localization
--

-- local L = mod:SetDefaultLocale({
-- })

--------------------------------------------------------------------------------
-- Renames
--

mod:SetRenames({
	["stages"] = {CL.stage:format(1), CL.stage:format(2), CL.stage:format(3), CL.intermission, original = false}, -- stages
	[1282487] = {CL.pools}, -- Fangs of the Coiled Altar
	[1299960] = {CL.orbs}, -- Toxic Deluge
	[1283489] = {1283489}, -- Guillotine
	[1299680] = {CL.tank_frontal}, -- Sever
	[1282281] = {1282281}, -- Venomfang
	[1283832] = {1283832}, -- Axegrinder

	[1289900] = {1289900, CL.you:format(mod:SpellName(1289900)), notes = {CL.generalNote, CL.messageOnYouNote}}, -- Dreadmarch
	[1285911] = {CL.you:format(mod:SpellName(1285911))}, -- Unnerving Fixation
	[1286573] = {CL.tank_frontal}, -- Soul Sever
	[1286918] = {1286918}, -- Eternal Nightfall
	[1286441] = {CL.adds}, -- Spiritcackle
	[1286895] = {1286895, CL.you:format(mod:SpellName(1286895)), notes = {CL.generalNote, CL.messageOnYouNote}}, -- Gloombomb

	[1298381] = {CL.pools}, -- Defilement of the Coiled Altar
	[1299266] = {1299266}, -- Grim Guillotine
	[1307279] = {CL.tank_frontal}, -- Blighted Sever
})

--------------------------------------------------------------------------------
-- Options
--

mod:SetAuraData({
	-- important
	{1282419, soundOnApplied = "warning", duration = 5, header = CL.important}, -- Volatile Venom
	{1310498, soundOnApplied = "warning", duration = 5, mythic = true}, -- Mutagenic Venom
	{1283485, soundOnApplied = "warning", duration = 5, note = "Targeted"}, -- Guillotine
	{1297435, soundOnApplied = "warning", duration = 6, note = "Targeted"}, -- Dreadmarch XXX not applied to players?
	{1285911, soundOnApplied = "warning", duration = 7}, -- Unnerving Fixation
	{1286901, soundOnApplied = "warning", duration = 5}, -- Gloombomb
	{1286837, soundOnApplied = "alarm", duration = 11}, -- Gravebound
	{1299266, soundOnApplied = "warning", duration = 5, note = "Targeted"}, -- Grim Guillotine
	-- Zul'jan
	{1283345, soundOnApplied = "none", soundOnAppliedDose = "none", note = "Tank stacks", header = mod:SpellName(-35063)}, -- Twinfang Toxin
	{1283290, soundOnApplied = "none"}, -- Noxious Ground
	{1299838, soundOnApplied = "none", note = "DoT"}, -- Venom Rupture
	{1307425, soundOnApplied = "none", note = "Soaked"}, -- Guillotined
	{1301690, soundOnApplied = "none", note = "Tank cone"}, -- Sever
	{1306906, soundOnApplied = "none", duration = 14, note = "DoT"}, -- Venomfang
	{1285017, soundOnApplied = "none", note = "DoT"}, -- Axegrinder
	-- Malacrass
	{1297445, soundOnApplied = "none", note = "Possessed", header = mod:SpellName(-35062)}, -- Dreadmarch
	{1310744, soundOnApplied = "none", duration = 5, mythic = true}, -- Malevolent Resonance
	{1307959, soundOnApplied = "none", note = "Tank cone"}, -- Soul Sever
	{1286918, soundOnApplied = "none", duration = 15}, -- Eternal Nightfall
	{1286947, soundOnApplied = "none"}, -- Suffocating Darkness
	{1286399, soundOnApplied = "alarm", duration = 5, note = "Kick fail"}, -- Wail of Terror
	-- intermission
	{1300665, soundOnApplied = "none", soundOnAppliedDose = "none", mythic = true, header = CL.intermission}, -- Spirit Erasure
	-- p3
	{1298594, soundOnApplied = "none", header = CL.stage:format(3)}, -- Defilement of the Coiled Altar
	{1298795, soundOnApplied = "none", soundOnAppliedDose = "none", note = "Tank stacks"}, -- Corrupted Toxin
	{1298591, soundOnApplied = "none"}, -- Defiled Groound
	{1307652, soundOnApplied = "none", note = "Soaked"}, -- Guillotined
	{1307403, soundOnApplied = "none", note = "Tank cone"}, -- Blighted Sever
})

function mod:GetOptions()
	return {
		"stages",

		-- Stage One: Serpent's Bargain
		1282487, -- Fangs of the Coiled Altar
		1299960, -- Toxic Deluge
		1283489, -- Guillotine
		1299680, -- Sever
		1282281, -- Venomfang
		1283832, -- Axegrinder

		-- Stage Two: Usurper's Reprisal
		1289900, -- Dreadmarch
		1285911, -- Unnerving Fixation
		1286573, -- Soul Sever
		1286918, -- Eternal Nightfall
		1286895, -- Gloombomb
		1286441, -- Spiritcackle

		-- Intermission: The Claimed Vessel
		-- 1287722, -- Spirit Erasure

		-- Stage Three: Coiled Union
		-- Zul'jan
			1298381, -- Defilement of the Coiled Altar
			-- Toxic Deluge
			1299266, -- Grim Guillotine
			1307279, -- Blighted Sever
		-- Hex Lord Malacrass
			-- Dreadmarch
			-- Unnerving Fixation
			-- Eternal Nightfall
			-- Gloombomb
			-- Spiritcackle
	}, {
		{
			tabName = self:SpellName(-35584), -- Stage 1
			{ "stages", 1282487, 1299960, 1283489, 1299680, 1282281, 1283832 },
		},
		{
			tabName = self:SpellName(-35599), -- Stage 2
			 {"stages", 1289900, 1285911, 1286573, 1286918, 1286895, 1286441 },
		},
		{
			tabName = self:SpellName(-35403), -- Stage 3
			{ "stages",
			1298381, 1299960, 1299266, 1307279,
				1289900, 1285911, 1286918, 1286895, 1286441 },
		},
		-- [1287722] = -35533, -- Intermission
		[1282487] = -35063, -- Zul'jan
		[1298381] = -35063, -- Zul'jan
		[1289900] = -35062, -- Hex Lord Malacrass
		[1286441] = "mythic",
	}
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	backupBars = {}
	if self:Mythic() then
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "MythicTimeline")
	else
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "OtherTimeline")
	end
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
end

function mod:OnEncounterStart()
	activeBars = {}
	self:SetStage(1)
	durationEventCount = {}
	warnStageThree = false

	toxicDelugeCount = 1
	axegrinderCount = 1
	venomfangCount = 1
	guillotineCount = 1
	severCount = 1
	coiledAltarCount = 1

	dreadmarchCount = 1
	eternalNightfallCount = 1
	spiritcackleCount = 1
	gloombombCount = 1

	-- Starts the encounter by casting Fangs of the Coiled Altar
	self:Message(1282487, "red") -- CL.count:format(self:GetRename(1282487), 1) would starting the bar at count 2 be weird?

	-- self:RegisterBossEvent("boss2", "StartPhaseTwo")
	-- self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", nil, "boss2")
	self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", nil, "boss2")
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:MythicTimeline(_, eventInfo)
	local barInfo

	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	if warnStageThree then
		warnStageThree = false
		-- Starts with casting Defilement of the Coiled Altar
		self:Message(1298381, "red") -- CL.count:format(self:GetRename(1298381), 1) would starting the bar at count 2 be weird?
		self:PlaySound(1298381, "alarm")
	end

	local stage = self:GetStage()
	if stage == 1 then
		if rounded == 2 then
			barInfo = self:ToxicDeluge(duration)
		elseif rounded == 12 then
			barInfo = self:Axegrinder(duration)
		elseif rounded == 28 or rounded == 35 then
			barInfo = self:Venomfang(duration)
		elseif rounded == 43 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] % 2 == 1 then
				barInfo = self:Guillotine(duration)
			else
				barInfo = self:ToxicDeluge(duration)
			end
		elseif rounded == 20 or rounded == 17 then
			barInfo = self:Sever(duration)
		elseif rounded == 85 then
			barInfo = self:FangsOfTheCoiledAltar(duration)
		end

	elseif stage == 2 then
		if rounded == 13 or rounded == 33 then
			barInfo = self:Spiritcackle(duration)
		elseif rounded == 70 then
			barInfo = self:EternalNightfall(duration)
		elseif rounded == 6 then -- 5.5
			barInfo = self:Dreadmarch(duration)
		elseif rounded == 18 or rounded == 37 then
			barInfo = self:Gloombomb(duration)
		elseif rounded == 31 then
			barInfo = self:SoulSever(duration)
		elseif rounded == 34 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] % 2 == 1 then
				barInfo = self:SoulSever(duration)
			else
				barInfo = self:Dreadmarch(duration)
			end
		end

	elseif stage == 3 then
		barInfo = nil -- no p3 timers
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

function mod:OtherTimeline(_, eventInfo)
	local barInfo

	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	if warnStageThree then
		warnStageThree = false
		-- Starts with casting Defilement of the Coiled Altar
		self:Message(1298381, "red") -- CL.count:format(self:GetRename(1298381), 1) would starting the bar at count 2 be weird?
		self:PlaySound(1298381, "alarm")
	end

	local stage = self:GetStage()
	if stage == 1 then
		if rounded == 2 then
			barInfo = self:ToxicDeluge(duration)
		elseif rounded == 12 then
			barInfo = self:Axegrinder(duration)
		elseif rounded == 28 or rounded == 35 then
			barInfo = self:Venomfang(duration)
		elseif rounded == 42 or rounded == 43 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] % 2 == 1 then
				barInfo = self:Guillotine(duration)
			else
				barInfo = self:ToxicDeluge(duration)
			end
		elseif rounded == 20 or rounded == 16 or rounded == 17 then
			barInfo = self:Sever()
		elseif rounded == 80 then
			barInfo = self:FangsOfTheCoiledAltar(duration)
		end

	elseif stage == 2 then
		if rounded == 70 then
			barInfo = self:EternalNightfall()
		elseif rounded == 6 then -- 5.5
			barInfo = self:Dreadmarch(duration)
		elseif rounded == 22 or rounded == 38 then
			barInfo = self:Gloombomb(duration)
		elseif rounded == 31 then
			self:SoulSever(duration)
		elseif rounded == 34 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] % 2 == 1 then
				barInfo = self:SoulSever(duration)
			else
				barInfo = self:Dreadmarch(duration)
			end
		end

	elseif stage == 3 then
		if rounded == 34 or rounded == 22 then
			barInfo = self:EternalNightfall(duration)
		elseif rounded == 54 or rounded == 88 or rounded == 43 or rounded == 52 then -- 53.5
			barInfo = self:Dreadmarch(duration)
		elseif rounded == 2 or rounded == 41 or rounded == 50 or rounded == 37 then
			barInfo = self:ToxicDeluge(duration)
		elseif rounded == 29 or rounded == 28 or rounded == 30 or rounded == 33 then
			barInfo = self:BlightedSever(duration)
		elseif rounded == 92 or rounded == 91 then
			barInfo = self:DefilementOfTheCoiledAltar(duration)
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

	if barInfo and barInfo.key == 1282487 and state == 3 then -- Fangs of the Coiled Altar (Canceled)
		-- Normally canceled after the next set of timers are added
		self:StopBar(barInfo.msg)
		if coiledAltarCount > barInfo.count then
			-- next bar started, so it finished
			barInfo:onFinished()
		else
			-- actually ended early, so trigger next phase
			self:StartPhaseTwo()
		end
		activeBars[eventID] = nil
		barInfo = nil
	end

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

function mod:StartPhaseTwo()
	-- Fang was canceled early
	if self:GetStage() == 1 then
		-- self:UnregisterBossEvent("boss2")

		self:StopBar(CL.count:format(self:GetRename(1299960), toxicDelugeCount))
		self:StopBar(CL.count:format(self:GetRename(1283832), axegrinderCount))
		self:StopBar(CL.count:format(self:GetRename(1282281), venomfangCount))
		self:StopBar(CL.count:format(self:GetRename(1283489), guillotineCount))
		self:StopBar(CL.count:format(self:GetRename(1299680), severCount))
		self:StopBar(CL.count:format(self:GetRename(1282487), coiledAltarCount))

		self:SetStage(2)

		durationEventCount = {}

		toxicDelugeCount = 1
		axegrinderCount = 1
		venomfangCount = 1
		guillotineCount = 1
		severCount = 1
		coiledAltarCount = 1

		dreadmarchCount = 1
		eternalNightfallCount = 1
		spiritcackleCount = 1
		gloombombCount = 1

		self:Message("stages", "cyan", self:GetRename("stages", 2), false)
		self:PlaySound("stages", "long")
	end
end

function mod:StartIntermission()
	if self:GetStage() == 2 then
		self:StopBar(CL.count:format(self:GetRename(1286441), spiritcackleCount))
		self:StopBar(CL.count:format(self:GetRename(1286918), eternalNightfallCount))
		self:StopBar(CL.count:format(self:GetRename(1289900), dreadmarchCount))
		self:StopBar(CL.count:format(self:GetRename(1286895), gloombombCount))
		self:StopBar(CL.count:format(self:GetRename(1286573), severCount))

		self:SetStage(2.5)

		durationEventCount = {}

		toxicDelugeCount = 1
		axegrinderCount = 1
		venomfangCount = 1
		guillotineCount = 1
		severCount = 1
		coiledAltarCount = 1

		dreadmarchCount = 1
		eternalNightfallCount = 1
		spiritcackleCount = 1
		gloombombCount = 1

		self:Message("stages", "cyan", self:GetRename("stages", 4), false) -- Intermission
		self:PlaySound("stages", "long")
	end
end

-- function mod:UNIT_SPELLCAST_CHANNEL_START()
-- 	-- kinda late, but oh well.
-- 	if self:GetStage() == 2 and self:GetTimelineEventCount() == 0 then -- Soulbinding
-- 		self:StartIntermission()
-- 	end
-- end

function mod:UNIT_SPELLCAST_CHANNEL_STOP()
	if self:GetStage() == 2.5 then -- Soulbinding
		warnStageThree = true
		self:SetStage(3)

		self:Message("stages", "cyan", self:GetRename("stages", 3), false)
		self:PlaySound("stages", "long")
	end
end

-- Stage 1

function mod:ToxicDeluge(duration)
	local barText = CL.count:format(self:GetRename(1299960), toxicDelugeCount)
	toxicDelugeCount = toxicDelugeCount + 1

	-- show a bar for the next cast on end
	local barOnFinish = gapTimer(1299960, duration)
	-- short bar on phase restart, extend the bar we start
	local remaining, total = self:BarTimeLeft(barText)
	local newDuration = remaining > 1 and { duration, total } or duration

	return {
		duration = newDuration,
		msg = barText,
		key = 1299960,
		onFinished = function()
			self:StopBlizzMessages(1) -- The crucible begins to spew a [Toxic Deluge]!
			self:Message(1299960, "yellow", barText)
			self:PlaySound(1299960, "info")

			if barOnFinish then
				self:Bar(1299960, barOnFinish, CL.count:format(self:GetRename(1299960), toxicDelugeCount))
			end
		end,
	}
end

function mod:Axegrinder(duration)
	local barText = CL.count:format(self:GetRename(1283832), axegrinderCount)
	axegrinderCount = axegrinderCount + 1

	local barOnFinish = gapTimer(1283832, duration)
	local remaining, total = self:BarTimeLeft(barText)
	local newDuration = remaining > 1 and { duration, total } or nil

	return {
		duration = newDuration,
		msg = barText,
		key = 1283832,
		onFinished = function()
			self:Message(1283832, "yellow", barText)
			self:PlaySound(1283832, "alarm")

			if barOnFinish then
				self:Bar(1283832, barOnFinish, CL.count:format(self:GetRename(1283832), axegrinderCount))
			end
		end,
	}
end

function mod:Venomfang(duration)
	local barText = CL.count:format(self:GetRename(1282281), venomfangCount)
	venomfangCount = venomfangCount + 1

	local barOnFinish = gapTimer(1282281, duration)
	local remaining, total = self:BarTimeLeft(barText)
	local newDuration = remaining > 1 and { duration, total } or nil

	return {
		duration = newDuration,
		msg = barText,
		key = 1282281,
		onFinished = function()
			self:Message(1282281, "yellow", barText)
			self:PlaySound(1282281, "alarm")

			if barOnFinish then
				self:Bar(1282281, barOnFinish, CL.count:format(self:GetRename(1282281), venomfangCount))
			end
		end,
	}
end

function mod:Guillotine(duration)
	local barText = CL.count:format(self:GetRename(1283489), guillotineCount)
	guillotineCount = guillotineCount + 1

	local barOnFinish = gapTimer(1283489, duration)
	local remaining, total = self:BarTimeLeft(barText)
	local newDuration = remaining > 1 and { duration, total } or nil

	return {
		duration = newDuration,
		msg = barText,
		key = 1283489,
		onFinished = function()
			self:StopBlizzMessages(1) -- Zul'jan begins to cast [Guillotine]!
			self:Message(1283489, "orange", barText)
			self:PlaySound(1283489, "alert")

			if barOnFinish then
				self:Bar(1283489, barOnFinish, CL.count:format(self:GetRename(1283489), guillotineCount))
			end
		end,
	}
end

function mod:Sever(duration)
	local barText = CL.count:format(self:GetRename(1299680), severCount)
	severCount = severCount + 1

	local lastBar = not self:Mythic() or severCount % 4 == 1
	local barOnFinish = lastBar and gapTimer(1299680, duration)
	local remaining, total = self:BarTimeLeft(barText)
	local newDuration = remaining > 1 and { duration, total } or nil

	return {
		duration = newDuration,
		msg = barText,
		key = 1299680,
		onFinished = function()
			self:Message(1299680, "purple", barText)
			self:PlaySound(1299680, "alert")

			if barOnFinish then
				self:Bar(1299680, barOnFinish, CL.count:format(self:GetRename(1299680), severCount))
			end
		end,
	}
end

function mod:FangsOfTheCoiledAltar(duration)
	local barText = CL.count:format(self:GetRename(1282487), coiledAltarCount)
	coiledAltarCount = coiledAltarCount + 1

	return {
		msg = barText,
		key = 1282487,
		count = coiledAltarCount,
		onFinished = function()
			self:Message(1282487, "red", barText)
			self:PlaySound(1282487, "alarm")
		end,
	}
end

-- Stage 2

function mod:Spiritcackle(duration)
	local barText = CL.count:format(self:GetRename(1286441), spiritcackleCount)
	spiritcackleCount = spiritcackleCount + 1

	local barOnFinish = gapTimer(1286441, duration)
	local remaining, total = self:BarTimeLeft(barText)
	local newDuration = remaining > 1 and { duration, total } or nil

	return {
		duration = newDuration,
		msg = barText,
		key = 1286441,
		onFinished = function()
			self:Message(1286441, "cyan", barText)
			self:PlaySound(1286441, "info")

			if barOnFinish then
				self:Bar(1286441, barOnFinish, CL.count:format(self:GetRename(1286441), spiritcackleCount))
			end
		end,
	}
end

function mod:EternalNightfall(duration)
	local barText = CL.count:format(self:GetRename(1286918), eternalNightfallCount)
	eternalNightfallCount = eternalNightfallCount + 1

	local barOnFinish = gapTimer(1286918, duration)
	local remaining, total = self:BarTimeLeft(barText)
	local newDuration = remaining > 1 and { duration, total } or nil

	return {
		duration = newDuration,
		msg = barText,
		key = 1286918,
		onFinished = function()
			self:StopBlizzMessages(1) -- Malacrass begins to bring forth an [Eternal Nightfall]!
			self:Message(1286918, "red", barText)
			self:PlaySound(1286918, "alarm")

			if barOnFinish then
				self:Bar(1286918, barOnFinish, CL.count:format(self:GetRename(1286918), eternalNightfallCount))
			end
		end,
		onCanceled = function()
			if mod:GetStage() == 2 then
				-- if this cancels, it means the phase is over
				mod:StartIntermission()
			end
		end,
	}
end

function mod:Dreadmarch(duration)
	local barText = CL.count:format(self:GetRename(1289900), dreadmarchCount)
	dreadmarchCount = dreadmarchCount + 1

	local barOnFinish = gapTimer(1289900, duration)
	local remaining, total = self:BarTimeLeft(barText)
	local newDuration = remaining > 1 and { duration, total } or nil

	return {
		duration = newDuration,
		msg = barText,
		key = 1289900,
		onFinished = function()
			-- self:StopBlizzMessages(-3.5) -- Malacrass if about to afflict you with [Dreadmarch]
			self:Message(1289900, "orange", barText)
			self:PlaySound(1289900, "alert")

			if barOnFinish then
				self:Bar(1289900, barOnFinish, CL.count:format(self:GetRename(1289900), dreadmarchCount))
			end
		end,
	}
end

function mod:UnnervingFixationMessage()
	-- when Dreadmarch breaks :\
	-- ENCOUNTER_WARNING#4.0#Medium#A Manifestation of Dread sets its gaze upon you with an [Unnerving Fixation]!
	self:PersonalMessage(1285911)
end

function mod:Gloombomb(duration)
	local barText = CL.count:format(self:GetRename(1286895), gloombombCount)
	gloombombCount = gloombombCount + 1

	local barOnFinish = gapTimer(1286895, duration)
	local remaining, total = self:BarTimeLeft(barText)
	local newDuration = remaining > 1 and { duration, total } or nil

	return {
		duration = newDuration,
		offset = 2,
		msg = barText,
		key = 1286895,
		onFinished = function()
			-- self:StopBlizzMessages(1) -- Malacrass targets you with [Gloombomb]!
			local timer = self:ScheduleTimer(function() self:Message(1286895, "yellow", barText) end, 1)
			self:PersonalMessageFromBlizzMessage(1286895, 1, false, self:GetRename(1286895, 2), nil, nil, function() self:CancelTimer(timer) end)

			if barOnFinish then
				self:Bar(1286895, barOnFinish, CL.count:format(self:GetRename(1286895), gloombombCount))
			end
		end,
	}
end

function mod:SoulSever(duration)
	local barText = CL.count:format(self:GetRename(1286573), severCount)
	severCount = severCount + 1

	local barOnFinish = gapTimer(1286573, duration)
	local remaining, total = self:BarTimeLeft(barText)
	local newDuration = remaining > 1 and { duration, total } or nil

	return {
		duration = newDuration,
		msg = barText,
		key = 1286573,
		onFinished = function()
			self:Message(1286573, "purple", barText)
			self:PlaySound(1286573, "alert")

			if barOnFinish then
				self:Bar(1286573, barOnFinish, CL.count:format(self:GetRename(1286573), severCount))
			end
		end,
	}
end

-- Stage 3

function mod:DefilementOfTheCoiledAltar()
	local barText = CL.count:format(self:GetRename(1298381), coiledAltarCount)
	coiledAltarCount = coiledAltarCount + 1
	return {
		msg = barText,
		key = 1298381,
		onFinished = function()
			self:Message(1298381, "red", barText)
			self:PlaySound(1298381, "alarm")
		end,
	}
end

function mod:GrimGuillotine()
	local barText = CL.count:format(self:GetRename(1299266), guillotineCount)
	guillotineCount = guillotineCount + 1
	return {
		msg = barText,
		key = 1299266,
		onFinished = function()
			self:Message(1299266, "orange", barText)
			self:PlaySound(1299266, "alert")
		end,
	}
end

function mod:BlightedSever()
	local barText = CL.count:format(self:GetRename(1307279), severCount)
	severCount = severCount + 1
	return {
		msg = barText,
		key = 1307279,
		onFinished = function()
			self:Message(1307279, "purple", barText)
			self:PlaySound(1307279, "alert")
		end,
	}
end
