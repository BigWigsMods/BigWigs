
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Midnight Falls", 2913, 2740)
if not mod then return end
mod:RegisterEnableMob(240391) -- L'ura
mod:SetEncounterID(3183)
mod:SetRespawnTime(30)
mod:SetStage(1)
mod:SetPrivateAuraSounds({
	{1282027, sound = "underyou"}, -- The Darkwell
	{1282470, sound = "underyou"}, -- Dark Quasar
	1249609, -- Dark Rune
	{1253031, sound = "info"}, -- Glimmering
	{1265842, sound = "alarm"}, -- Impaled
	{1279512, 1285510}, -- Starsplinter
	1284527, -- Galvanize
	{1281184, mythic = true}, -- Criticality
	{1263514, sound = "underyou"}, -- Midnight
})
mod:UseCustomTimers(true, true)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}
local durationEventCount = {}

local quasarCount = 1
local glaivesCount = 1
local dirgeCount = 1
local prismCount = 1
local lanceCount = 1

local harvestCount = 1
local galvanizeCount = 1

local playerSide = nil
local siphonCount = 1
local archangelCount = 1
local constellationCount = 1

local starsplinterCount = 1
local heavenHellCount = 1

local INTERMISSION_DARK_QUASAR_INFO = {
	[14] = { -- normal 10, 17, 25, 33
		count = 4,
		duration = 7.5,
	},
	[15] = { -- heroic 10.6, 16.7, 23.0, 29.2, 35.5
		count = 5,
		duration = 6.2,
	},
	[16] = { -- mythic 10.4, 15.5, 20.6, 25.7, 30.8, 35.9
		count = 6,
		duration = 5.1,
	},
}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.deaths_dirge = "Memory Game"
	L.heavens_glaives = "Glaives"
	L.heavens_lance = "Lance"
	L.prism_kicks = "Kicks"
	L.dark_constellation = "Stars"
	L.the_dark_archangel = "Big Boom"
	L.dark_rune = "Memory Mark"
	L.dark_rune_bar = "Solve the Game"

	L.starsplinter = "Blazes" -- Mythic intermission and P4 bar text
	L.starsplinter_you = "Blaze"

	L.left = "[L] %s" -- left/west group bars in p3
	L.right = "[R] %s" -- right/east group bars in p3

	L.custom_off_select_limit_warnings = "Mythic Stage Three Group"
	L.custom_off_select_limit_warnings_desc = "When set, only warnings for abilities on your side of the room will be shown."
	L.custom_off_select_limit_warnings_value1 = "West/Left"
	L.custom_off_select_limit_warnings_value2 = "East/Right"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		"berserk", -- Shattered Sky (1249796) / Midnight Perpetual (1287447)

		-- Stage 1
		1253915, -- Heaven's Glaives
		1279420, -- Dark Quasar
		1249620, -- Death's Dirge
			1249609, -- Dark Rune
		1251386, -- Safeguard Prism
		{1267049, "TANK"}, --- Heaven's Lance
		-- Mythic
		1284980, -- Grim Symphony
		1284931, -- Termination Prism

		-- Intermission
		1282441, -- Starsplinter

		-- Stage 2
		1284525, -- Galvanize
		1282412, -- Core Harvest
		1281194, -- Dark Meltdown

		-- Stage 3
		"custom_off_select_limit_warnings",
		1250898, -- The Dark Archangel
		1266388, -- Dark Constellation
		1266897, -- Light Siphon
		-- Mythic
		1273158, -- Death's Requiem
		1276525, -- Heaven & Hell
	},{
		{ tabName = CL.stage:format(1), { "stages", 1253915, 1279420, 1249620, 1249609, 1251386, 1267049, 1284980, 1284931, } },
		{ tabName = CL.intermission,    { "stages", 1282441, 1279420, } },
		{ tabName = CL.stage:format(2), { "stages", 1284525, 1282412, 1267049, 1281194, } },
		{ tabName = CL.stage:format(3), { "stages", "berserk", 1250898, 1266388, 1266897, 1267049, 1273158, 1276525, } },
		[1253915] = -32197, -- Stage One: Final Tolls
		[1284525] = -33638, -- Stage Two: The Dark Reactor
		[1250898] = -33639, -- Stage Three: Midnight Falls
	},{
		[1253915] = L.heavens_glaives,
		[1279420] = CL.beams, -- Dark Quasar
		[1249620] = L.deaths_dirge,
		[1249609] = L.dark_rune,
		[1251386] = L.prism_kicks, -- Safeguard Prism
		[1267049] = L.heavens_lance,

		[1284525] = CL.beams, -- Galvanize
		[1282412] = CL.dodge, -- Core Harvest
		[1281194] = CL.knockback, -- Dark Meltdown
		[1266388] = L.dark_constellation,
		[1250898] = L.the_dark_archangel,
		[1266897] = CL.soaks, -- Light Siphon

		[1284980] = L.deaths_dirge, -- Grim Symphony
		[1284931] = L.prism_kicks, -- Termination Prism
		[1273158] = L.deaths_dirge, -- Death's Requiem
	}
end

function mod:GetName(key)
	return self.notes and self.notes[key] or self:SpellName(key)
end

function mod:OnBossEnable()
	backupBars = {}
	if self:Mythic() then
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "TimersMythic")
	else
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "TimersOther") -- Normal/Heroic
	end
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
end

function mod:OnEncounterStart()
	self:SetStage(1)
	self:ResetCounts()

	local optionSide = self:GetOption("custom_off_select_limit_warnings")
	playerSide = optionSide == 1 and "left" or optionSide == 2 and "right" or nil

	if self:ShouldShowBars() then
		self:SendMessage("BigWigs_BlockBlizzMessages")
		self:RegisterEvent("ENCOUNTER_WARNING")
	end
end

function mod:OnBossDisable()
	self:SendMessage("BigWigs_AllowBlizzMessages")
	for eventID in next, backupBars do
		self:SendMessage("BigWigs_StopBar", nil, nil, eventID)
	end
end

function mod:ResetCounts()
	durationEventCount = {}

	quasarCount = 1
	glaivesCount = 1
	dirgeCount = 1
	prismCount = 1
	lanceCount = 1

	harvestCount = 1
	galvanizeCount = 1

	siphonCount = 1
	archangelCount = 1
	constellationCount = 1
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:TimersMythic(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo

	local stage = self:GetStage()
	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
	local count = durationEventCount[rounded]

	if stage == 1 then
		-- pull timers (get immediately canceled and restarted)
		if rounded == 3 then
			if count == 1 then return false end
			barInfo = self:TerminationPrism(duration)
		elseif rounded == 31 then
			if count == 1 then return false end
			barInfo = self:GrimSymphony(duration)
		elseif rounded == 20 and (count == 1 or count == 2) then
			if count == 1 then return false end
			barInfo = self:HeavensLance(duration)
		elseif rounded == 26 then
			if count == 1 then return false end
			barInfo = self:HeavensGlaives(duration)
		elseif rounded == 57 then
			if count == 1 then return false end
			barInfo = self:DarkQuasar(duration)
		elseif rounded == 180 then
			if count == 1 then return false end
			barInfo = self:TotalEclipse(duration)

		elseif rounded == 62 then
			if count % 4 == 1 then
				barInfo = self:TerminationPrism(duration)
			elseif count % 4 == 2 then
				barInfo = self:HeavensGlaives(duration)
			elseif count % 4 == 3 then
				barInfo = self:GrimSymphony(duration)
			else
				barInfo = self:DarkQuasar(duration)
			end
		elseif rounded == 20 then
			barInfo = self:HeavensLance(duration)

		elseif rounded == 45 then
			barInfo = self:IntoTheDarkwell(duration)
		end

	elseif stage == 2 then
		if rounded == 97 then
			barInfo = self:DarkMeltdown(duration)
		elseif rounded == 33 then
			barInfo = self:CoreHarvest(duration)
		elseif rounded == 13 or rounded == 30 then
			if count % 2 == 1 then
				barInfo = self:Galvanize(duration)
			else
				barInfo = self:CoreHarvest(duration)
			end
		elseif rounded == 20 then
			barInfo = self:HeavensLance(duration)
		end

	elseif stage == 3 then
		if rounded == 18 then
			if count == 1 then
				barInfo = self:LightSiphon(duration)
			elseif count == 2 then
				barInfo = self:DeathsRequiem(duration)
			end
			if barInfo then
				-- Death's Requiem is the one that cancels, but it always fires with Light Siphon and the order isn't consistent
				barInfo.maxQueueDuration = 0
				barInfo.timer = self:ScheduleTimer(barInfo.onEnd, duration)
			end
		elseif (rounded == 20 and count == 1) or rounded == 23 or rounded == 4 or rounded == 6 or rounded == 7 then
			barInfo = self:DarkConstellationMythic(rounded)
		elseif rounded == 57 or rounded == 55 then
			barInfo = self:TheDarkArchangel(duration)
		elseif rounded == 40 or rounded == 30 then
			barInfo = self:HeavensLance(duration)

		elseif rounded == 20 or rounded == 35 then
			if count % 2 == 0 then
				barInfo = self:LightSiphon(duration)
			else
				barInfo = self:DeathsRequiem(duration)
			end
			if barInfo then
				barInfo.maxQueueDuration = 0
				barInfo.timer = self:ScheduleTimer(barInfo.onEnd, duration)
			end
		elseif rounded == 180 then
			self:Bar("stages", 12, 1276202) -- Severance
			self:ScheduleTimer(function()
				-- start watching for p4
				self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckForPhaseFour")
			end, 13)

			self:Bar("berserk", duration, 1249796) -- Shattered Sky
			return false -- timer finishes immediately
		end
	end

	if barInfo then
		barInfo.eventID = eventInfo.id
		barInfo.duration = barInfo.duration or eventInfo.duration
		activeBars[eventInfo.id] = barInfo
		if self:ShouldShowBars() then
			self:Bar(barInfo.key, barInfo.duration, barInfo.msg, barInfo.icon, eventInfo.id)
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

function mod:TimersOther(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo

	local stage = self:GetStage()
	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
	local count = durationEventCount[rounded]

	if stage == 1 and rounded == 97 then
		-- skipped intermission
		stage = 2
		self:SetStage(stage)
		self:ResetCounts()
	end

	if stage == 1 then
		-- pull timers (get immediately canceled and restarted x.x)
		if rounded == 40 then
			if count == 1 then return false end
			barInfo = self:DarkQuasar(duration)
		elseif rounded == 20 and (count == 1 or count == 2) then
			if count == 1 then return false end
			barInfo = self:HeavensLance(duration)
		elseif rounded == 10 then
			if count == 1 then return false end
			barInfo = self:DeathsDirge(duration)
		elseif rounded == 35 then
			if count == 1 then return false end
			barInfo = self:HeavensGlaives(duration)
		elseif rounded == 55 then
			if count == 1 then return false end
			barInfo = self:SafeguardPrism(duration)
		elseif rounded == 180 then
			if count == 1 then return false end
			barInfo = self:TotalEclipse(duration)

		elseif rounded == 70 then
			if count % 4 == 1 then
				barInfo = self:DeathsDirge(duration)
			elseif count % 4 == 2 then
				barInfo = self:HeavensGlaives(duration)
			elseif count % 4 == 3 then
				barInfo = self:DarkQuasar(duration)
			else
				barInfo = self:SafeguardPrism(duration)
			end
		elseif rounded == 20 then
			barInfo = self:HeavensLance(duration)

		-- intermission start
		elseif rounded == 45 then
			barInfo = self:IntoTheDarkwell(duration)
		end

	elseif stage == 2 then
		if rounded == 97 then
			barInfo = self:DarkMeltdown(duration)
		elseif rounded == 33 then
			barInfo = self:CoreHarvest(duration)
		elseif rounded == 13 or rounded == 30 then
			if count % 2 == 1 then
				barInfo = self:Galvanize(duration)
			else
				barInfo = self:CoreHarvest(duration)
			end
		elseif rounded == 20 then
			barInfo = self:HeavensLance(duration)
		end

	elseif stage == 3 then
		if rounded == 31 then
			barInfo = self:LightSiphon(duration)
			if barInfo then
				barInfo.maxQueueDuration = 0
				barInfo.timer = self:ScheduleTimer(barInfo.onEnd, duration)
			end
		elseif rounded == 33 or rounded == 6 or rounded == 26 then
			if rounded == 6 then
				barInfo = self:DarkConstellation(duration, count % 2 == 1 and 2 or 3, 3)
			else
				barInfo = self:DarkConstellation(duration)
			end
		elseif rounded == 14 then
			barInfo = self:TheDarkArchangel(duration)
		elseif rounded == 23 or rounded == 20 then
			barInfo = self:HeavensLance(duration)
		elseif rounded == 38 then
			if count % 2 == 1 or self:Easy() then
				barInfo = self:TheDarkArchangel(duration)
			else
				barInfo = self:LightSiphon(duration)
				if barInfo then
					barInfo.maxQueueDuration = 0
					barInfo.timer = self:ScheduleTimer(barInfo.onEnd, duration)
				end
			end
		elseif rounded == 180 then
			self:Bar("berserk", duration, 1249796) -- Shattered Sky
			return false -- timer finishes immediately
		end
	end

	if barInfo then
		barInfo.eventID = eventInfo.id
		barInfo.duration = barInfo.duration or eventInfo.duration
		activeBars[eventInfo.id] = barInfo
		if self:ShouldShowBars() then
			self:Bar(barInfo.key, barInfo.duration, barInfo.msg, barInfo.icon, eventInfo.id)
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
	local barInfo = activeBars[eventID]
	if barInfo then
		local state = C_EncounterTimeline.GetEventState(eventID)
		if state == 2 or state == 3 then -- Finished or Canceled
			if not barInfo.noStopBar then
				self:StopBar(barInfo.msg)
			end
			if self:ShouldShowBars() then
				if state == 2 and barInfo.onFinished then
					barInfo:onFinished()
				elseif state == 3 and barInfo.onCanceled then
					barInfo:onCanceled()
				end
			end

			activeBars[eventID] = nil
		end
	elseif backupBars[eventID] then
		local newState = C_EncounterTimeline.GetEventState(eventID)
		if newState == 0 then
			self:SendMessage("BigWigs_ResumeBar", nil, nil, eventID)
		elseif newState == 1 then
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventID)
		elseif newState == 2 or newState == 3 then
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

function mod:ENCOUNTER_WARNING(_, info)
	local stage = self:GetStage()
	if stage == 1 or stage == 3 then
		if info.severity == 2 then -- Dark Rune
			self:PersonalMessage(1249609)
			-- self:Bar(1249609, stage == 1 and 10 or 15, L.dark_rune_bar)
		end
	elseif stage == 2 or stage == 4 then
		if info.severity == 2 then -- Galvanize
			self:PersonalMessage(1284525)
		elseif info.severity == 1 then -- Starsplinter
			-- (p2 is set on intermission start)
			self:PersonalMessage(1282441, nil, L.starsplinter_you)
			-- self:Bar(1282441, 3, CL.you:format(L.starsplinter_you))
		end
	end
end

-- Stage 1

function mod:DarkQuasar(duration)
	local barText = CL.count:format(self:GetName(1279420), quasarCount)
	quasarCount = quasarCount + 1
	return {
		msg = barText,
		key = 1279420,
		onFinished = function()
			self:Message(1279420, "yellow", barText)
			self:PlaySound(1279420, "info")
		end
	}
end

function mod:HeavensGlaives(duration)
	local barText = CL.count:format(self:GetName(1253915), glaivesCount)
	glaivesCount = glaivesCount + 1
	return {
		msg = barText,
		key = 1253915,
		onFinished = function()
			self:Message(1253915, "orange", barText)
			self:PlaySound(1253915, "alarm")
		end
	}
end

function mod:DeathsDirge(duration)
	local barText = CL.count:format(self:GetName(1249620), dirgeCount)
	dirgeCount = dirgeCount + 1
	return {
		msg = barText,
		key = 1249620,
		onFinished = function()
			self:Message(1249620, "red", barText)
			self:PlaySound(1249620, "warning")
		end
	}
end

function mod:SafeguardPrism(duration)
	local barText = CL.count:format(self:GetName(1251386), prismCount)
	prismCount = prismCount + 1
	return {
		msg = barText,
		key = 1251386,
		offset = 4,
		onFinished = function()
			self:Message(1251386, "yellow", barText)
			self:PlaySound(1251386, "alert")
		end
	}
end

function mod:HeavensLance(duration)
	local barText = CL.count:format(self:GetName(1267049), lanceCount)
	lanceCount = lanceCount + 1
	return {
		msg = barText,
		key = 1267049,
		onFinished = function()
			self:Message(1267049, "purple", barText)
			if self:Tank() then
				self:PlaySound(1267049, "alert")
			end
		end
	}
end

function mod:TotalEclipse(duration)
	return {
		msg = CL.intermission,
		key = "stages",
		icon = 1261871,
		endTime = GetTime() + duration,
		onFinished = function()
			self:Message("stages", "cyan", CL.intermission, false)
			self:PlaySound("stages", "long")
		end,
		onCanceled = function(barInfo)
			if math.abs(GetTime() - barInfo.endTime) < 0.1 then
				barInfo:onFinished()
			end
		end
	}
end

-- Mythic

function mod:GrimSymphony(duration)
	local barText = CL.count:format(self:GetName(1284980), dirgeCount)
	dirgeCount = dirgeCount + 1
	return {
		msg = barText,
		key = 1284980,
		onFinished = function(barInfo)
			self:Message(1284980, "red", barText)
			self:PlaySound(1284980, "warning")
		end,
	}
end

function mod:TerminationPrism(duration)
	local barText = CL.count:format(self:GetName(1284931), prismCount)
	prismCount = prismCount + 1
	return {
		msg = barText,
		key = 1284931,
		offset = 3,
		onFinished = function()
			self:Message(1284931, "yellow", barText)
			self:PlaySound(1284931, "alert")
		end
	}
end


-- Intermission

function mod:IntoTheDarkwell(duration)
	self:SetStage(2) -- just set it here, no other events
	self:ResetCounts()

	if self:ShouldShowBars() then
		self:Bar(1279420, 10.5, CL.count:format(self:GetName(1279420), quasarCount))
		self:ScheduleTimer("IntermissionDarkQuasar", 10.5)
		if self:Mythic() then
			self:Bar(1282441, 38, L.starsplinter)
		end
	end

	return {
		msg = CL.stage:format(2),
		key = "stages",
		icon = 1282047,
	}
end

function mod:IntermissionDarkQuasar()
	local info = INTERMISSION_DARK_QUASAR_INFO[self:Difficulty()]
	if not info then return end

	self:Message(1279420, "yellow", CL.count_amount:format(self:GetName(1279420), quasarCount, info.count))
	self:PlaySound(1279420, "alert")
	quasarCount = quasarCount + 1

	if quasarCount <= info.count then
		self:Bar(1279420, info.duration, CL.count_amount:format(self:GetName(1279420), quasarCount, info.count))
		self:ScheduleTimer("IntermissionDarkQuasar", info.duration)
	end
end

-- Phase 2

function mod:DarkMeltdown(duration)
	quasarCount = 1
	if self:ShouldShowBars() then
		self:Message("stages", "cyan", CL.stage:format(2), false)
		self:PlaySound("stages", "long")
	end
	return {
		msg = CL.stage:format(3),
		key = "stages",
		icon = 1281194,
		onFinished = function()
			self:SetStage(3)
			self:Message("stages", "cyan", CL.stage:format(3), false)
			self:PlaySound("stages", "long")

			self:ResetCounts()

			self:Bar(1281194, 8, self:GetName(1281194)) -- Dark Meltdown
		end
	}
end

function mod:Galvanize(duration)
	local barText = CL.count:format(self:GetName(1284525), galvanizeCount)
	galvanizeCount = galvanizeCount + 1
	return {
		msg = barText,
		key = 1284525,
		onFinished = function()
			self:Message(1284525, "orange", barText)
			self:PlaySound(1284525, "alert") -- soak
		end
	}
end

function mod:CoreHarvest(duration)
	local barText = CL.count:format(self:GetName(1282412), harvestCount)
	harvestCount = harvestCount + 1
	return {
		msg = barText,
		key = 1282412,
		offset = 2.5,
		onFinished = function()
			self:Message(1282412, "yellow", barText)
			self:PlaySound(1282412, "alarm") --dodge
		end
	}
end

-- Phase 3

function mod:LightSiphon(duration)
	local barText

	if self:Mythic() then
		local sides = { "left", "right", "right", "left", "left", "right" }
		local side = sides[siphonCount]

		barText = CL.count:format(self:GetName(1266897), siphonCount)
		siphonCount = siphonCount + 1

		if side then
			if playerSide and side ~= playerSide then
				return false
			end
			barText = L[side]:format(barText)
		end
	else
		barText = CL.count:format(self:GetName(1266897), siphonCount)
		siphonCount = siphonCount + 1
	end

	return {
		msg = barText,
		key = 1266897,
		onEnd = function()
			if self:ShouldShowBars() and not self:IsWiping() then
				self:Message(1266897, "orange", barText)
				self:PlaySound(1266897, "alert") -- soak
			end
		end
	}
end

function mod:TheDarkArchangel(duration)
	local barText = CL.count:format(self:GetName(1250898), archangelCount)
	archangelCount = archangelCount + 1
	return {
		msg = barText,
		key = 1250898,
		onFinished = function()
			self:Message(1250898, "red", barText)
			self:PlaySound(1250898, "warning") -- jazz hands
		end
	}
end

function mod:DarkConstellation(duration, count, totalCount)
	local barText
	if count then
		barText = CL.count_amount:format(self:GetName(1266388), count, totalCount)
	else
		barText = CL.count:format(self:GetName(1266388), constellationCount)
		constellationCount = constellationCount + 1
	end
	return {
		msg = barText,
		key = 1266388,
		onFinished = function()
			self:Message(1266388, "yellow", barText)
			-- self:PlaySound(1266388, "alarm") -- dodge
		end
	}
end

-- Mythic

function mod:DarkConstellationMythic(duration)
	local side = constellationCount % 2 == 1 and "left" or "right"
	local barText = L[side]:format(self:GetName(1266388))

	local durations = {
		20, 4, 4, 4, 4, 4, 4, 4, 4,
		23, 4, 4, 4, 4, 4, 4, 4, 4,
		23, 7, 7, 6, 7, 7,
	}
	local updatedDuration = nil
	if playerSide and constellationCount > 2 and self:BarTimeLeft(barText) > 0 then
		self:StopBar(barText) -- Bar -> TimelineBar
		local maxTime = duration + durations[constellationCount - 1]
		updatedDuration = {duration, maxTime}
	end

	constellationCount = constellationCount + 1

	-- Show the timer for the next cast on your side
	if playerSide and side ~= playerSide then
		local nextDuration = durations[constellationCount]
		if nextDuration then
			self:Bar(1266388, duration + nextDuration, L[playerSide]:format(self:GetName(1266388)))
		end
		return false
	end

	return {
		msg = barText,
		key = 1266388,
		duration = updatedDuration,
		onFinished = function()
			self:Message(1266388, "yellow", barText)
			self:PlaySound(1266388, "info")
		end
	}
end

function mod:DeathsRequiem(duration)
	local sides = { "right", "left", "left", "right", "right", "left" }
	local side = sides[dirgeCount]

	local barText = CL.count:format(self:GetName(1273158), dirgeCount)
	dirgeCount = dirgeCount + 1

	if side then
		if playerSide and side ~= playerSide then
			return false
		end
		barText = L[side]:format(barText)
	end

	return {
		msg = barText,
		key = 1273158,
		onEnd = function()
			if self:ShouldShowBars() and not self:IsWiping() then
				self:Message(1273158, "red", barText)
				self:PlaySound(1273158, "warning")
			end
		end,
	}
end

-- Phase 4

function mod:CheckForPhaseFour()
	if self:GetStage() == 3 and UnitExists("boss1") and not UnitExists("boss2") and self:ShouldShowBars() and not self:IsWiping() then
		self:UnregisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
		self:StopBar(self:GetName(1249796))

		self:SetStage(4)
		self:Message("stages", "cyan", CL.stage:format(4), false)
		self:PlaySound("stages", "long")

		starsplinterCount = 1
		heavenHellCount = 1

		self:Bar(1282441, 12.7, CL.count:format(self:GetName(1282441), starsplinterCount))
		self:ScheduleTimer("StarsplinterRepeater", 12.7)

		self:Bar(1276525, 19.9, CL.count:format(self:GetName(1276525), heavenHellCount))
		self:ScheduleTimer("HeavenHellRepeater", 19.9)

		-- Midnight Perpetual
		self:Bar("berserk", 79, 1287447)
		self:ScheduleTimer(function()
			self:Message("berserk", "red", CL.casting:format(self:GetName(1287447)), 1287447)
			self:PlaySound("berserk", "alarm")
		end, 79-4)
	end
end

function mod:StarsplinterRepeater()
	self:Message(1282441, "orange", CL.count:format(self:GetName(1282441), starsplinterCount))
	starsplinterCount = starsplinterCount + 1
	self:Bar(1282441, 20, CL.count:format(self:GetName(1282441), starsplinterCount))
	self:ScheduleTimer("StarsplinterRepeater", 20)
end

function mod:HeavenHellRepeater()
	self:Message(1276525, "red", CL.count:format(self:GetName(1276525), heavenHellCount))
	heavenHellCount = heavenHellCount + 1
	self:Bar(1276525, 20, CL.count:format(self:GetName(1276525), heavenHellCount))
	self:ScheduleTimer("HeavenHellRepeater", 20)
end
