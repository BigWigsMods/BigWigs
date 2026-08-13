if not BigWigsLoader.isTestBuild then return end

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vashnik the Malignant", 3004, 2882)
if not mod then return end
mod:RegisterEnableMob(259181) -- Vashnik <The Malignant>
mod:SetEncounterID(3455)
mod:SetRespawnTime(30)
mod:UseCustomTimers(true)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}

local imbibeCount = 1
local malignantCatalystCount = 1
local adaptiveInfectionCount = 1
local plagueFrothCount = 1
local drippingFangsCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:SetDefaultLocale({ -- SetOption:skip-locale
	malignant_catalyst = "Catalyst", -- Short for Malignant Catalyst
})

--------------------------------------------------------------------------------
-- Renames
--

mod:SetRenames({
	[1283164] = {1283164}, -- Imbibe
	[1282525] = {L.malignant_catalyst}, -- Malignant Catalyst
	[1282117] = {CL.debuffs}, -- Adaptive Infection
	[1281907] = {CL.waves}, -- Plague Froth
	[1280935] = {CL.tank_hit}, -- Dripping Fangs
})

--------------------------------------------------------------------------------
-- Options
--

mod:SetAuraData({
	{1295173, soundOnApplied = "warning", header = CL.important, note = CL.dispel}, -- Exploding Infection
	{1281908, 1281913, soundOnApplied = "warning"}, -- Plague Froth (Heroic & Mythic)
	{1295224, soundOnApplied = "warning"}, -- Siphoning Infection (Main debuff)
	{1280934, soundOnApplied = "none", soundOnAppliedDose = "none", header = CL.general, note = CL.tank_debuff}, -- Dripping Fangs
	{1295380, soundOnApplied = "info"}, -- Siphoning Infection (Healing main debuffed player)
	{1294994, soundOnApplied = "none"}, -- Stygian Infection
	{1282117, soundOnApplied = "none"}, -- Adaptive Infection
	{1304459, soundOnApplied = "none", soundOnAppliedDose = "none", mythic = true, note = CL.mythic}, -- Malignance
	{1297338, soundOnApplied = "underyou"}, -- Deadly Venom (Standing in venom?)
	{1291461, soundOnApplied = "underyou"}, -- Virulent Fumes
	{1285979, soundOnApplied = "none", soundOnAppliedDose = "none", header = CL.adds}, -- Caustic Surge
	{1280189, soundOnApplied = "none", soundOnAppliedDose = "none"}, -- Malignant Burst
	{1305833, soundOnApplied = "none", soundOnAppliedDose = "none"}, -- Congealing Bolt
})


function mod:GetOptions()
	return {
		1283164, -- Imbibe
		1282525, -- Malignant Catalyst
		1282117, -- Adaptive Infection
		1281907, -- Plague Froth
		{1280935, "TANK"}, -- Dripping Fangs
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

	imbibeCount = 1
	malignantCatalystCount = 1
	adaptiveInfectionCount = 1
	plagueFrothCount = 1
	drippingFangsCount = 1
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:ENCOUNTER_TIMELINE_EVENT_ADDED(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo = nil

	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 0)

	if durationRounded == 20 or durationRounded == 80 then
		barInfo = self:Imbibe()
	elseif durationRounded == 10 or durationRounded == 16
		or durationRounded == 21 or durationRounded == 31 then
		barInfo = self:PlagueFroth()
	elseif durationRounded == 8 or durationRounded == 11 or durationRounded == 22 then
		barInfo = self:DrippingFangs()
	elseif durationRounded == 23 or durationRounded == 24 then
		barInfo = self:AdaptiveInfection()
	elseif durationRounded == 6 or durationRounded == 44 then
		barInfo = self:MalignantCatalyst()
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
	local barInfo = activeBars[eventID]
	if barInfo then
		local state = C_EncounterTimeline.GetEventState(eventID)
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
		local state = C_EncounterTimeline.GetEventState(eventID)
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

function mod:Imbibe()
	local barText = CL.count:format(self:GetRename(1283164), imbibeCount)
	imbibeCount = imbibeCount + 1
	return {
		msg = barText,
		key = 1283164,
		onFinished = function()
			self:Message(1283164, "cyan", barText)
			self:PlaySound(1283164, "long")
			self:StopBlizzMessages(2)
		end
	}
end

function mod:MalignantCatalyst()
	local barText = CL.count:format(self:GetRename(1282525), malignantCatalystCount)
	malignantCatalystCount = malignantCatalystCount + 1
	return {
		msg = barText,
		key = 1282525,
		onFinished = function()
			self:Message(1282525, "red", barText)
			self:PlaySound(1282525, "warning") -- raid damage
			self:StopBlizzMessages(2)
		end
	}
end

function mod:AdaptiveInfection()
	local barText = CL.count:format(self:GetRename(1282117), adaptiveInfectionCount)
	adaptiveInfectionCount = adaptiveInfectionCount + 1
	return {
		msg = barText,
		key = 1282117,
		onFinished = function()
			self:Message(1282117, "yellow", barText)
			self:PlaySound(1282117, "alert") -- debuffs
		end
	}
end

function mod:PlagueFroth()
	local barText = CL.count:format(self:GetRename(1281907), plagueFrothCount)
	plagueFrothCount = plagueFrothCount + 1
	return {
		msg = barText,
		key = 1281907,
		onFinished = function()
			self:Message(1281907, "yellow", barText)
			self:PlaySound(1281907, "alert") -- waves after debuffs
		end
	}
end

function mod:DrippingFangs()
	local barText = CL.count:format(self:GetRename(1280935), drippingFangsCount)
	drippingFangsCount = drippingFangsCount + 1
	return {
		msg = barText,
		key = 1280935,
		onFinished = function()
			self:Message(1280935, "purple", barText)
			-- self:PlaySound(1280935, "alarm") -- tank hit
		end
	}
end
