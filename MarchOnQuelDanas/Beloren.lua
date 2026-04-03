
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Belo'ren, Child of Al'ar", 2913, 2739)
if not mod then return end
mod:RegisterEnableMob(240387) -- Belo'ren
mod:SetEncounterID(3182)
mod:SetRespawnTime(30)
mod:SetStage(1)
mod:SetPrivateAuraSounds({
	1241292, -- Light Dive
	1241339, -- Void Dive
	{1241840, sound = "underyou"}, -- Light Patch
	{1241841, sound = "underyou"}, -- Void Patch
	{1244348, sound = "alarm"}, -- Light Burn
	{1266404, sound = "alarm"}, -- Void Burn
	1241992, -- Light Quill
	1242091, -- Void Quill
	{1242803, sound = "underyou"}, -- Light Flames
	{1242815, sound = "underyou"}, -- Void Flames
})
mod:UseCustomTimers(true, true)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}

local durationEventCount = {}
local isIntermission = false
local phaseCount = 1

local embersCount = 1
local echosCount = 1
local edictCount = 1
local burnsCount = 1
local quillsCount = 1
local convergenceCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.infused_quills = "Quills"
	L.voidlight_convergence = "Color Swaps"

	L.light_void_dive = "Light/Void Dive"
	L.light_void_dive_desc = 1241292
	L.light_void_dive_icon = 1241292
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions() -- SetOption:skip-unused
	return {
		"stages",
		-- "berserk", -- 1241267 Voidlight Rage

		-- Stage 1
		1242515, -- Voidlight Convergence
		1241282, -- Embers of Del'ren
			"light_void_dive", -- Light/Void Dive
		1242981, -- Radiant Echoes
		1260763, -- Guardian's Edict
		1244344, -- Eternal Burns
		1242260, -- Infused Quills
		1246709, -- Death Drop

		-- Stage 2
		-- 1241313, -- Rebirth
		-- 1242792, -- Incubation of Flames
	}, {
		-- [1241282] = -33025, -- Stage One: Phoenix Reborn
		-- [1241313] = -32160, -- Stage Two: Ashen Shell
	}, {
		[1242515] = L.voidlight_convergence,
		[1241282] = CL.adds, -- Embers of Beloren
		["light_void_dive"] = CL.soaks,
		[1242981] = CL.orbs,
		[1260763] = CL.tank_combo, -- Guardian's Edict
		[1244344] = CL.heal_absorbs, -- Eternal Burns
		[1242260] = L.infused_quills,
		[1246709] = CL.landing, -- Death Drop
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
	self:SetStage(1)

	activeBars = {}
	durationEventCount = {}
	isIntermission = false
	phaseCount = 1

	embersCount = 1
	echosCount = 1
	edictCount = 1
	burnsCount = 1
	quillsCount = 1
	convergenceCount = 1
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
	local barInfo

	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 0)

	if not isIntermission then
		if durationRounded == 6 then
			durationEventCount[durationRounded] = (durationEventCount[durationRounded] or 0) + 1
			if durationEventCount[durationRounded] == 1 then -- gets reset every convergence unless canceled early
				barInfo = self:RadiantEchoes(duration)
			else
				barInfo = self:DeathDrop(duration)
			end
		elseif durationRounded == 8 then
			barInfo = self:EmbersOfBeloren(duration)
		elseif durationRounded == 10 then
			barInfo = self:InfusedQuills(duration)
		elseif durationRounded == 19 then
			barInfo = self:InfusedQuills(duration)
		elseif durationRounded == 16 or durationRounded == 20 then
			barInfo = self:GuardiansEdict(duration)
		elseif durationRounded == 30 and not self:IsWiping() then
			barInfo = self:EternalBurns(duration)
		elseif durationRounded == 50 then
			barInfo = self:VoidlightConvergence(duration)
		end
	else
		if durationRounded == 30 and not self:IsWiping() then
			barInfo = self:Rebirth(duration)
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

function mod:TimersOther(_, eventInfo)
	if eventInfo.source ~= 0 then return end
	local barInfo

	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 0)

	if not isIntermission then
		if durationRounded == 6 then
			durationEventCount[durationRounded] = (durationEventCount[durationRounded] or 0) + 1
			if durationEventCount[durationRounded] == 1 then -- gets reset every convergence unless canceled early
				barInfo = self:RadiantEchoes(duration)
			else
				barInfo = self:DeathDrop(duration)
			end
		elseif durationRounded == 10 then
			durationEventCount[durationRounded] = (durationEventCount[durationRounded] or 0) + 1
			if durationEventCount[durationRounded] == 1 then
				barInfo = self:EmbersOfBeloren(duration)
			else
				barInfo = self:InfusedQuills(duration)
			end
		elseif durationRounded == 20 or durationRounded == 18 then
			barInfo = self:GuardiansEdict(duration)
		elseif durationRounded == 21 then
			barInfo = self:InfusedQuills(duration)
		elseif durationRounded == 34 then
			barInfo = self:EternalBurns(duration)
		elseif durationRounded == 50 then
			barInfo = self:VoidlightConvergence(duration)
		end
	else
		if durationRounded == 30 and not self:IsWiping() then
			barInfo = self:Rebirth(duration)
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
			self:StopBar(barInfo.msg)
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

function mod:EmbersOfBeloren(duration)
	local barText = CL.count:format(CL.adds, embersCount)
	local diveBarText = CL.count:format(CL.soaks, embersCount)
	embersCount = embersCount + 1
	return {
		msg = barText,
		key = 1241282,
		onFinished = function()
			self:Message(1241282, "cyan", barText)
			self:PlaySound(1241282, "info", "adds")

			-- if the adds spawn, they don't do away on phase, so no need to stop this
			self:Bar("light_void_dive", 9, diveBarText, 1241292)
		end,
	}
end

function mod:RadiantEchoes(duration)
	local barText = CL.count:format(CL.orbs, echosCount)
	echosCount = echosCount + 1
	return {
		msg = barText,
		key = 1242981,
		onFinished = function()
			self:Message(1242981, "red", barText)
			-- self:PlaySound(1242981, "warning")
		end
	}
end

function mod:GuardiansEdict(duration)
	local barText = CL.count:format(CL.tank_combo, edictCount)
	edictCount = edictCount + 1
	return {
		msg = barText,
		key = 1260763,
		onFinished = function()
			self:Message(1260763, "purple", barText)
			if self:Tank() then
				self:PlaySound(1260763, "alert")
			end
		end
	}
end

function mod:EternalBurns(duration)
	local barText = CL.count:format(CL.heal_absorbs, burnsCount)
	burnsCount = burnsCount + 1
	return {
		msg = barText,
		key = 1244344,
		onFinished = function()
			self:Message(1244344, "yellow", barText)
			if self:Healer() then
				self:PlaySound(1244344, "alert") -- healer
			end
		end
	}
end

function mod:InfusedQuills(duration)
	local barText = CL.count:format(L.infused_quills, quillsCount)
	quillsCount = quillsCount + 1
	return {
		msg = barText,
		key = 1242260,
		onFinished = function()
			self:Message(1242260, "orange", barText)
			-- self:PlaySound(1242260, "alarm") -- dodge
		end
	}
end

function mod:VoidlightConvergence(duration)
	if self:ShouldShowBars() then
		self:Message(1242515, "cyan", CL.count:format(L.voidlight_convergence, convergenceCount))
		if convergenceCount > 1 or phaseCount > 1 then
			self:PlaySound(1242515, "long")
		end
	end
	local timer = self:ScheduleTimer(function() durationEventCount = {} end, duration - 0.5)
	convergenceCount = convergenceCount + 1
	local barText = CL.count:format(L.voidlight_convergence, convergenceCount)
	return {
		msg = barText,
		key = 1242515,
		onCanceled = function()
			self:CancelTimer(timer)
		end,
	}
end

function mod:DeathDrop(duration)
	-- SetStage here to match lr
	local stage = self:GetStage()
	self:SetStage(stage + 1)

	durationEventCount = {}
	isIntermission = true

	if self:ShouldShowBars() then
		self:Message("stages", "cyan", CL.count:format(CL.intermission, phaseCount), false)
		self:PlaySound("stages", "long")
	end
	return {
		msg = CL.landing,
		key = 1246709,
	}
end

-- Phase 2

function mod:Rebirth(duration)
	phaseCount = phaseCount + 1
	local barText = CL.count:format(CL.stage:format(1), phaseCount)

	embersCount = 1
	echosCount = 1
	edictCount = 1
	burnsCount = 1
	quillsCount = 1
	convergenceCount = 1

	return {
		msg = barText,
		key = "stages",
		startTime = GetTime(),
		onFinished = function()
			isIntermission = false
			self:Message("stages", "cyan", barText)
			self:PlaySound("stages", "info")

			self:Bar(1242515, 6, CL.count:format(L.voidlight_convergence, convergenceCount))
		end,
		onCanceled = function(barInfo)
			isIntermission = false
			if GetTime() - barInfo.startTime >= 30 then -- cancels at 30.0xx
				barInfo:onFinished()
			end
		end
	}
end
