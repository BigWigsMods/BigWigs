
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
	1279512, -- Starsplinter
	1284527, -- Galvanize
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
local safeguardPrismCount = 1
local lanceCount = 1

local harvestCount = 1
local galvanizeCount = 1

local siphonCount = 1
local archangelCount = 1
local constellationCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.deaths_dirge = "Memory Game"
	L.heavens_glaives = "Glaives"
	L.heavens_lance = "Lance"
	L.dark_constellation = "Lines"
	L.the_dark_archangel = "Archangel"
end

--------------------------------------------------------------------------------
-- Initialization
--


function mod:GetOptions()
	return {
		"stages",

		-- Stage 1
		1279420, -- Dark Quasar
		1253915, -- Heaven's Glaives
		1249620, -- Death's Dirge
		1251386, -- Safeguard Prism
		{1267049, "TANK"}, --- Heaven's Lance

		-- Stage 2
		1284525, -- Galvanize
		1282412, -- Core Harvest

		-- Stage 3
		1250898, -- The Dark Archangel
		1266388, -- Dark Constellation
		1266897, -- Light Siphon
		1249796, -- Shattered Sky
	},{
		{ tabName = CL.stage:format(1), { "stages", 1279420, 1253915, 1249620, 1251386, 1267049, } },
		{ tabName = CL.stage:format(2), { "stages", 1284525, 1282412, 1267049, } },
		{ tabName = CL.stage:format(3), { "stages", 1250898, 1266388, 1266897, 1267049, 1249796, } },
		[1279420] = -32197, -- Stage One: Final Tolls
		[1284525] = -33638, -- Stage Two: The Dark Reactor
		[1250898] = -33639, -- Stage Three: Midnight Falls
	},{
		[1249620] = L.deaths_dirge,
		[1253915] = L.heavens_glaives,
		[1267049] = L.heavens_lance,
		[1279420] = CL.beams,
		[1251386] = CL.shield,
		[1284525] = CL.beams,
		[1282412] = CL.dodge,
		[1266388] = L.dark_constellation,
		[1250898] = L.the_dark_archangel,
		[1266897] = CL.soaks,
	}
end

function mod:GetName(key)
	return self.notes and self.notes[key] or self:SpellName(key)
end

function mod:OnBossEnable()
	backupBars = {}
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "TimersOther") -- Normal/Heroic
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
end

function mod:OnEncounterStart()
	self:SetStage(1)
	self:ResetCounts()
end

function mod:ResetCounts()
	durationEventCount = {}

	quasarCount = 1
	glaivesCount = 1
	dirgeCount = 1
	safeguardPrismCount = 1
	lanceCount = 1

	harvestCount = 1
	galvanizeCount = 1

	siphonCount = 1
	archangelCount = 1
	constellationCount = 1
end

function mod:OnBossDisable()
	for eventID in next, backupBars do
		self:SendMessage("BigWigs_StopBar", nil, nil, eventID)
	end
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:TimersOther(_, eventInfo)
	if eventInfo.source ~= 0 then return end
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
				-- XXX was finishing early, not an issue now?
				barInfo.noStopBar = true
				barInfo.finishTimer = self:ScheduleTimer(function() barInfo:onEnd() end, duration)
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

	-- XXX all normal logs skipped p3 >.>
	elseif stage == 3 then
		if rounded == 31 then
			barInfo = self:LightSiphon(duration)
		elseif rounded == 33 or rounded == 6 or rounded == 26 then
			barInfo = self:DarkConstellation(duration)
		elseif rounded == 14 then
			barInfo = self:TheDarkArchangel(duration)
		elseif rounded == 23 or rounded == 20 then
			barInfo = self:HeavensLance(duration)
		elseif rounded == 38 then
			if count % 2 == 1 or self:Easy() then -- XXX check longer logs for this / Light Siphon doesn't exist in normal
				barInfo = self:TheDarkArchangel(duration)
			else
				barInfo = self:LightSiphon(duration)
			end
		elseif rounded == 180 then
			self:Berserk(duration, 0, nil, 1249796) -- Shattered Sky
			return -- timer finishes immediately anyway
		end
	end

	if barInfo then
		barInfo.eventID = eventInfo.id
		barInfo.duration = barInfo.duration or eventInfo.duration
		activeBars[eventInfo.id] = barInfo
		if self:ShouldShowBars() then
			self:Bar(barInfo.key, barInfo.duration, barInfo.msg, barInfo.icon, eventInfo.id)
		end
	elseif self:ShouldShowBars() and not self:IsWiping() then
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
		onCanceled = function(barInfo)
			self:StopBar(barText)
			self:CancelTimer(barInfo.finishTimer)
		end,
		onEnd = function()
			self:Message(1249620, "red", barText)
			self:PlaySound(1249620, "warning")
		end
	}
end

function mod:SafeguardPrism(duration)
	local barText = CL.count:format(self:GetName(1251386), safeguardPrismCount)
	safeguardPrismCount = safeguardPrismCount + 1
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
		onFinished = function()
			self:Message("stages", "cyan", CL.intermission, false)
			self:PlaySound("stages", "long")
		end,
		onCanceled = function()
			self:Message("stages", "cyan", CL.intermission, false)
			self:PlaySound("stages", "long")
		end
	}
end

-- Intermission

function mod:IntoTheDarkwell(duration)
	self:SetStage(2) -- just set it here, no other events
	self:ResetCounts()
	return {
		msg = CL.stage:format(2),
		key = "stages",
		icon = 1282047,
	}
end

-- Phase 2

function mod:DarkMeltdown(duration)
	if self:ShouldShowBars() then
		self:Message("stages", "cyan", CL.stage:format(2), false)
		self:PlaySound("stages", "long")
	end
	local barText = CL.stage:format(3)
	self:ScheduleTimer(function() self:SetStage(3) end, duration) -- don't offset this
	return {
		msg = barText,
		key = "stages",
		icon = 1281194,
		offset = 8, -- bar ends on cast>channel, bleh
		onFinished = function()
			self:Message("stages", "cyan", barText, false)
			self:PlaySound("stages", "long")
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
	local barText = CL.count:format(self:GetName(1266897), siphonCount)
	siphonCount = siphonCount + 1
	return {
		msg = barText,
		key = 1266897,
		onFinished = function()
			self:Message(1266897, "orange", barText)
			self:PlaySound(1266897, "alert") -- soak
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

function mod:DarkConstellation(duration)
	local barText = CL.count:format(self:GetName(1266388), constellationCount)
	constellationCount = constellationCount + 1
	return {
		msg = barText,
		key = 1266388,
		-- offset = 4,
		onFinished = function()
			self:Message(1266388, "yellow", barText)
			-- self:PlaySound(1266388, "alarm") -- dodge
		end
	}
end
