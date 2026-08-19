
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ula'tek", 3004, 2895)
if not mod then return end
-- mod:RegisterEnableMob(0)
mod:SetEncounterID(3492)
mod:SetRespawnTime(30)
mod:UseCustomTimers(true)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}

local durationEventCount = {}

local rageCount = 1
local goreRattleCount = 1
local wavesCount = 1
local wrathCount = 1
local coilsCount = 1
local thrashCount = 1

local spitCount = 1

local circlingPreyCount = 1
local callCount = 1
local submergeCount = 1
local biteCount = 1

--------------------------------------------------------------------------------
-- Localization
--

-- local L = mod:SetDefaultLocale({
-- 	rage_of_the_shackled = "Damage Amp",
-- 	circling_prey = "Next Platform",
-- })

--------------------------------------------------------------------------------
-- Renames
--

mod:SetRenames({
	["stages"] = {CL.stage:format(1), CL.stage:format(2), CL.stage:format(3), CL.intermission, original = false},

	[1292188] = {CL.waves}, -- Caustic Waves
	[1300751] = {1300751}, -- Call of the Serpent
	[1298367] = {CL.tank_knockback}, -- Mother's Wrath
	[1298559] = {1298559}, -- Gore Rattle
	[1296301] = {CL.knockback}, -- Mephitic Thrash
	[1300530] = {CL.soaks}, -- Spectral Coils
	[1286860] = {1286860}, -- Rage of the Shackled

	[1302982] = {1302982}, -- Virulent Spit

	[1292999] = {1292999}, -- Submerge
	[1301510] = {1301510}, -- Circling Prey
	[1295905] = {1295905}, -- Serpent's Bite
	[1286905] = {1286905}, -- Fury Unleashed
})

--------------------------------------------------------------------------------
-- Options
--

mod:SetAuraData({
	{1311611, soundOnApplied = "alarm", header = CL.important}, -- Grasping Fangs
	{1288879, soundOnApplied = "warning"}, -- Serpent's Bite
	{1312967, soundOnApplied = "alarm", soundOnAppliedDose = "none", note = "You'll Volatile Purge on expiration!"}, -- Volatile Purge
	{1313529, soundOnApplied = "info"}, -- Ingested Venom
	{1300685}, -- Soul Constrictor

	{1292403, soundOnAppliedDose = "none", header = CL.general}, -- Caustic Waves
	{1297338}, -- Deadly Venom
	{1316356, soundOnAppliedDose = "none", note = "DoT"}, -- Volatile Purge
	{1306119, soundOnApplied = "alarm", note = "Petrified"}, -- Calcified Corpse
	{1298367}, -- Mother's Wrath
	{1298417, soundOnAppliedDose = "none", note = CL.tank_debuff}, -- Stone Venom
	{1300938}, -- Hobbled
	{1296301}, -- Mephitic Thrash

	{1295360, header = CL.adds}, -- Malignant Shell
	{1307612, mythic = true}, -- Noxious Shell
	{1301268}, -- Putrid Membrane
	{1287036, soundOnAppliedDose = "none"}, -- Poisonous Bite
	{1301800}, -- Acidic Burst
	{1305163, soundOnApplied = "warning", note = "Targeted"}, -- Petrifying Sting
	{1303414, soundOnApplied = "alarm", note = "Petrified"}, -- Petrifying Sting
	{1300312}, -- Doomscale Shell
	{1305775, soundOnApplied = "alarm", note = "Stunned"}, -- Dread Roar
	{1305650, soundOnApplied = "alarm", note = "Stunned"}, -- Anguished Cry
	{1305709}, -- Desperate Thrash
	{1311609, soundOnAppliedDose = "none"}, -- Blight Vein
	{1306858}, -- Warden's Protection

	{1306388, soundOnApplied = "info", header = "Achievement?"}, -- Greasy Hatchling
	{1306393, soundOnApplied = "info"}, -- Butter Fingers
})

function mod:GetOptions()
	return {
		"stages",
		-- Submerge

		-- Stage One: Fury of the Serpent Mother
		1292188, -- Caustic Waves
		1300751, -- Call of the Serpent
		{1298367, "TANK"}, -- Mother's Wrath
		1298559, -- Gore Rattle
			1296301, -- Mephitic Thrash
			1300530, -- Spectral Coils (1287265)
		1286860, -- Rage of the Shackled

		-- Stage Two: Children of the Doomscale
		1302982, -- Virulent Spit
		-- Rage of the Shackled

		-- Intermission: The Shattering
		-- Spectral Coils

		-- Stage Three: Ula'tek's Ascension
		1301510, -- Circling Prey
			1292999, -- Submerge
		-- Caustic Waves
		-- Call of the Serpent
		1295905, -- Serpent's Bite
		-- Mother's Wrath
		-- Rage of the Shackled
		1286905, -- Fury Unleashed
	}, {
		{
			tabName = self:SpellName(-35561), -- Stage 1
			{ "stages", 1292999, 1292188, 1300751, 1298367, 1298559, 1296301, 1300530, 1286860 },
		},
		{
			tabName = self:SpellName(-36171), -- Stage 2
			{ "stages", 1302982, 1286860 },
		},
		{
			tabName = self:SpellName(-36320), -- Intermission
			{ "stages", 1300530 },
		},
		{
			tabName = self:SpellName(-36323), -- Stage 3
			{ "stages", 1301510, 1292999, 1292188, 1300751, 1295905, 1298367, 1286860, 1286905 },
		},

		-- [1292188] = -35561, -- Stage 1
		-- [1302982] = -36171, -- Stage 2
		-- [] = -36320, -- Intermission,
		-- [1301510] = -36323, -- Stage 3
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

	rageCount = 1
	goreRattleCount = 1
	wavesCount = 1
	wrathCount = 1
	coilsCount = 1
	thrashCount = 1

	spitCount = 1
	callCount = 1
	submergeCount = 1
	biteCount = 1
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:MythicTimeline(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	return self:HandleBars(nil, eventInfo) -- no data for mythic
end

function mod:HeroicTimeline(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end

	if spitCount == 3 then -- out of data
		return nil
	end

	local barInfo

	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	if rounded == 118 then -- New Rage of the Shackled = Phase 2
		self:SetStage(2)

		durationEventCount = {}

		wavesCount = 1
		wrathCount = 1
		coilsCount = 1
		thrashCount = 1

		self:Message("stages", "cyan", self:GetRename("stages", 2), false)
		self:PlaySound("stages", "long")
	end

	-- so many events cancel instead of finish x.x if they don't fix these I guess i'll move the timer to the handler
	if rounded == 5 or rounded == 70 then
		local count = goreRattleCount < 3 and (rounded == 70 and 2 or rounded == 5 and 1) or nil
		barInfo = self:GoreRattle(count)
	elseif rounded == 10 or rounded == 37 or rounded == 67 then
		barInfo = self:MothersWrath()
	elseif rounded == 20 or rounded == 94 then
		barInfo = self:SpectralCoils()
		barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
	elseif rounded == 35 then
		barInfo = self:MephiticThrash()
		barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
	elseif rounded == 42 then
		barInfo = self:CausticWaves()
	elseif rounded == 62 then
		barInfo = self:Submerge()
	elseif rounded == 72 then
		barInfo = self:CallOfTheSerpent()
		barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
	elseif rounded == 129 or rounded == 118 then
		barInfo = self:RageOfTheShackled()
	elseif rounded == 30 or rounded == 40 then
		barInfo = self:VirulentSpit()

	elseif rounded == 52 then
		durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
		local count = durationEventCount[rounded]
		if count == 1 then
			barInfo = self:MephiticThrash()
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
		elseif count == 2 then
			barInfo = self:CausticWaves()
		end
	end

	self:HandleBars(barInfo, eventInfo)
end

function mod:EasyTimeline(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end

	local barInfo

	local stage = self:GetStage()
	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	if rounded == 118 then -- New Rage of the Shackled = Phase 2
		stage = 2
		self:SetStage(stage)

		wavesCount = 1
		wrathCount = 1
		coilsCount = 1
		thrashCount = 1

		self:Message("stages", "cyan", self:GetRename("stages", 2), false)
		self:PlaySound("stages", "long")

	elseif stage == 2 and rounded == 10 then -- Spectral Coils is the only bar in the intermission
		stage = 2.5
		self:SetStage(stage)

		self:Message("stages", "cyan", self:GetRename("stages", 4), false) -- intermission
		self:PlaySound("stages", "long")

	elseif rounded == 200 then -- New Rage of the Shackled = Phase 3
		stage = 3
		self:SetStage(stage)

		durationEventCount = {}

		wavesCount = 1
		wrathCount = 1
		coilsCount = 1
		thrashCount = 1

		callCount = 1
		submergeCount = 1
		biteCount = 1

		self:Message("stages", "cyan", self:GetRename("stages", 3), false)
		self:PlaySound("stages", "long")
	end

	if stage < 3 then
		if rounded == 42 then
			barInfo = self:CausticWaves()
		elseif rounded == 10 or rounded == 62 then
			barInfo = self:MothersWrath()
		elseif rounded == 20 or rounded == 84 or rounded == 10 then
			barInfo = self:SpectralCoils()
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
		elseif rounded == 130 or rounded == 118 then
			barInfo = self:RageOfTheShackled()
		elseif rounded == 5 then
			barInfo = self:GoreRattle()
		elseif rounded == 62 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			local count = durationEventCount[rounded]
			if count == 1 then
				barInfo = self:MothersWrath()
			elseif count == 2 then
				barInfo = self:CallOfTheSerpent()
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			end
		elseif rounded == 35 or rounded == 41 then
			barInfo = self:MephiticThrash()
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
		elseif rounded == 30 or rounded == 40 then
			barInfo = self:VirulentSpit()
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
		end

	-- stage 3
	else
		durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
		local count = durationEventCount[rounded]

		if (rounded == 230 or rounded == 40 or rounded == 25 or rounded == 200 or
			 rounded == 10 or rounded == 57 or rounded == 5 or rounded == 50) and count == 1
		then
			return false -- first bar is canceled
		 end

		if rounded == 230 then
			barInfo = self:FuryUnleashed()
		elseif rounded == 60 then
			barInfo = self:CausticWaves()
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
		elseif rounded == 25 or rounded == 61 then
			barInfo = self:SerpentsBite()
		elseif rounded == 200 then
			barInfo = self:RageOfTheShackled()
		elseif rounded == 10 or rounded == 86 then
			barInfo = self:MothersWrath()
		elseif rounded == 57 then
			barInfo = self:Submerge()
			barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
		elseif rounded == 5 or rounded == 63 then
			barInfo = self:CallOfTheSerpent()

		elseif rounded == 50 then
			if count == 2 then
				barInfo = self:CirclingPrey()
			elseif count == 3 then
				barInfo = self:CausticWaves()
			end
			if barInfo then
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			end
		elseif rounded == 65 then
			if count == 1 then
				barInfo = self:CallOfTheSerpent()
			elseif count == 2 then
				barInfo = self:MothersWrath()
			end
		elseif rounded == 56 then
			if count == 1 then
				barInfo = self:CirclingPrey()
			elseif count == 2 then
				barInfo = self:Submerge()
			end
			if barInfo then
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			end
		elseif rounded == 40 then
			if count == 2 then
				barInfo = self:CausticWaves()
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			elseif count == 3 then
				barInfo = self:SerpentsBite()
			end
		elseif rounded == 66 then
			if count == 1 then
				barInfo = self:CirclingPrey()
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			elseif count == 2 then
				barInfo = self:Submerge()
				barInfo.timer = self:ScheduleTimer(function() self:StopTimelineBar(barInfo, true) end, duration)
			elseif count == 3 then
				barInfo = self:SerpentsBite()
			end
		end
	end

	self:HandleBars(barInfo, eventInfo)
end

function mod:HandleBars(barInfo, eventInfo)
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

function mod:StopTimelineBar(barInfo, finished)
	if barInfo then
		self:StopBar(barInfo.msg)
		if finished and barInfo.onFinished and self:ShouldShowBars() and not self:IsWiping() then
			barInfo:onFinished()
		end
		activeBars[barInfo.eventID] = nil
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: Fury of the Serpent Mother

function mod:CausticWaves()
	local barText = CL.count:format(self:GetRename(1292188), wavesCount)
	wavesCount = wavesCount + 1
	return {
		msg = barText,
		key = 1292188,
		onFinished = function()
			self:Message(1292188, "red", barText)
			self:PlaySound(1292188, "warning")
		end,
	}
end

function mod:CallOfTheSerpent()
	local barText = CL.count:format(self:GetRename(1300751), callCount)
	callCount = callCount + 1
	return {
		msg = barText,
		key = 1300751,
		onFinished = function()
			self:Message(1300751, "yellow", barText)
			self:PlaySound(1300751, "alarm")
		end,
	}
end

function mod:MothersWrath()
	local barText = CL.count:format(self:GetRename(1298367), wrathCount)
	wrathCount = wrathCount + 1
	return {
		msg = barText,
		key = 1298367,
		onFinished = function()
			self:Message(1298367, "purple", barText)
			self:PlaySound(1298367, "alert")
		end,
	}
end

function mod:GoreRattle(count)
	local barText = self:GetRename(1298559)
	if not self:Easy() then
		barText = CL.count:format(barText, count or goreRattleCount)
	end
	goreRattleCount = goreRattleCount + 1
	return {
		msg = barText,
		key = 1298559,
		onFinished = function()
			self:Message(1298559, "cyan", barText)
			self:PlaySound(1298559, "info")
		end,
	}
end

function mod:MephiticThrash()
	local barText = CL.count:format(self:GetRename(1296301), thrashCount)
	thrashCount = thrashCount + 1
	return {
		msg = barText,
		key = 1296301,
		onFinished = function()
			self:Message(1296301, "yellow", barText)
			self:PlaySound(1296301, "alarm")
		end,
	}
end

function mod:SpectralCoils()
	local barText = CL.count:format(self:GetRename(1300530), coilsCount)
	coilsCount = coilsCount + 1
	return {
		msg = barText,
		key = 1300530,
		onFinished = function()
			self:Message(1300530, "orange", barText)
			self:PlaySound(1300530, "alert")
		end,
	}
end

function mod:RageOfTheShackled()
	local barText = CL.count:format(self:GetRename(1286860), rageCount)
	rageCount = rageCount + 1
	return {
		msg = barText,
		key = 1286860,
		onFinished = function()
			self:Message(1286860, "green", barText)
			self:PlaySound(1286860, "long")
		end,
	}
end

-- Stage Two: Children of the Doomscale

function mod:VirulentSpit()
	local barText = CL.count:format(self:GetRename(1302982), spitCount)
	spitCount = spitCount + 1
	return {
		msg = barText,
		key = 1302982,
		onFinished = function()
			self:Message(1302982, "yellow", barText)
			self:PlaySound(1302982, "alarm")
		end,
	}
end

-- Stage Three: Ula'tek's Ascension

function mod:CirclingPrey()
	local barText = CL.count:format(self:GetRename(1301510), circlingPreyCount)
	circlingPreyCount = circlingPreyCount + 1
	return {
		msg = barText,
		key = 1301510,
		onFinished = function()
			self:Message(1301510, "red", barText)
			self:PlaySound(1301510, "long")
		end,
	}
end

function mod:Submerge()
	local barText = CL.count:format(self:GetRename(1292999), submergeCount)
	submergeCount = submergeCount + 1
	return {
		msg = barText,
		key = 1292999,
		offset = 3.5, -- 1s for prey to finish, 2.5s for cast
		onFinished = function()
			self:Message(1292999, "cyan", barText)
			self:PlaySound(1292999, "info")
		end,
	}
end

function mod:SerpentsBite()
	local barText = CL.count:format(self:GetRename(1295905), biteCount)
	biteCount = biteCount + 1
	return {
		msg = barText,
		key = 1295905,
		onFinished = function()
			self:Message(1295905, "orange", barText)
			self:PlaySound(1295905, "alert")
		end,
	}
end

function mod:FuryUnleashed()
	local barText = self:GetRename(1286905)
	return {
		msg = barText,
		key = 1286905,
		onFinished = function()
			self:Message(1286905, "red", barText)
			self:PlaySound(1286905, "alarm")
		end,
	}
end
