
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
mod:UseCustomTimers(true)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}
local prevAdded = 0

local durationEventCount = {}
local isIntermission = false

local embersCount = 1
local echosCount = 1
local edictCount = 1
local burnsCount = 1
local quillsCount = 1
local convergenceCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:SetDefaultLocale({ -- SetOption:skip-locale
	color_swaps = "Color Swaps",

	["1241292"] = "Light/Void Dive",
})

--------------------------------------------------------------------------------
-- Renames
--

do
	local dive = ("%s/%s"):format(mod:SpellName(1241292), mod:SpellName(1241339)) -- Light Dive/Void Dive
	mod:SetRenames({
		["stages"] = {CL.stage:format(1), original = false, notes = {CL.stage:format(1)}}, -- Stages
		[1242515] = {L.color_swaps}, -- Voidlight Convergence (Color Swaps)
		[1241282] = {CL.adds}, -- Embers of Beloren (Adds)
		[1241292] = { -- Light/Void Dive (Soaks)
			CL.soaks, CL.you:format(CL.soak), CL.cast:format(CL.soaks),
			notes = {CL.generalNote, CL.messageOnYouNote, CL.castTimerNote},
			original = {dive, CL.you:format(dive), CL.cast:format(dive)},
		},
		[1242981] = {CL.orbs}, -- Radiant Echoes (Orbs)
		[1260763] = {CL.tank_combo}, -- Guardian's Edict (Tank Combo)
		[1244344] = {CL.heal_absorbs}, -- Eternal Burns (Heal Absorbs)
		[1242260] = {CL.quills, CL.you:format(CL.quills), notes = {CL.generalNote, CL.messageOnYouNote}, original = {1242260, CL.you:format(mod:SpellName(1242260))}}, -- Infused Quills (Quills)
		[1246709] = {CL.landing}, -- Death Drop (Landing)
		[1241313] = {1241313}, -- Rebirth
	})
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",

		-- Stage 1
		1242515, -- Voidlight Convergence
		1241282, -- Embers of Belo'ren
		{1241292, "CASTBAR", "ME_ONLY_EMPHASIZE"}, -- Light/Void Dive
		1242981, -- Radiant Echoes
		1260763, -- Guardian's Edict
		1244344, -- Eternal Burns
		{1242260, "ME_ONLY_EMPHASIZE"}, -- Infused Quills
		{1246709, "COUNTDOWN"}, -- Death Drop

		-- Stage 2
		{1241313, "COUNTDOWN"}, -- Rebirth
	},{
		[1242515] = -33025, -- Stage One: Phoenix Reborn
		[1241313] = -32160, -- Stage Two: Ashen Shell
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
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo

	local now = GetTime()
	local timeSinceLastEvent = now - prevAdded
	prevAdded = now

	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 0)

	-- Death Drop is a standalone timer 4.4s after canceled timers, Radiant Echoes is in the middle of a block of new timers
	if durationRounded == 6 and timeSinceLastEvent > 3 then
		isIntermission = true
	end

	if durationRounded == 8 then
		barInfo = self:EmbersOfBeloren(duration)
	elseif durationRounded == 19 or durationRounded == 10 then
		barInfo = self:InfusedQuills(duration)
	elseif durationRounded == 16 or durationRounded == 20 then
		barInfo = self:GuardiansEdict(duration)
	elseif durationRounded == 30 then
		barInfo = self:EternalBurns(duration)
	elseif durationRounded == 50 then
		barInfo = self:VoidlightConvergence(duration)
	elseif durationRounded == 40 then
		barInfo = self:Rebirth()
	elseif durationRounded == 6 then
		if not isIntermission then
			barInfo = self:RadiantEchoes(duration)
		else
			barInfo = self:DeathDrop(duration)
		end
	end

	if barInfo then
		barInfo.eventID = eventInfo.id
		barInfo.duration = barInfo.duration or eventInfo.duration
		activeBars[eventInfo.id] = barInfo
		if self:ShouldShowBars() then
			self:CDBar(barInfo.key, barInfo.duration, barInfo.msg, barInfo.icon, eventInfo.id)
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

	local now = GetTime()
	local timeSinceLastEvent = now - prevAdded
	prevAdded = now

	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 0)

	-- Death Drop is a standalone timer 4.4s after canceled timers, Radiant Echoes is in the middle of a block of new timers
	if durationRounded == 6 and timeSinceLastEvent > 3 then
		isIntermission = true
	end

	if durationRounded == 10 then
		durationEventCount[durationRounded] = (durationEventCount[durationRounded] or 0) + 1
		if self:Easy() or durationEventCount[durationRounded] % 3 == 1 then -- resets on Death Drop
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
	elseif durationRounded == 40 then
		barInfo = self:Rebirth()
	elseif durationRounded == 6 then
		if not isIntermission then
			barInfo = self:RadiantEchoes(duration)
		else
			barInfo = self:DeathDrop(duration)
		end
	end

	if barInfo then
		barInfo.eventID = eventInfo.id
		barInfo.duration = barInfo.duration or eventInfo.duration
		activeBars[eventInfo.id] = barInfo
		if self:ShouldShowBars() then
			self:CDBar(barInfo.key, barInfo.duration, barInfo.msg, barInfo.icon, eventInfo.id)
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

function mod:EmbersOfBeloren(duration) -- Soaks / Adds
	local addsText = CL.count:format(self:GetRename(1241282), embersCount)
	local soaksText = CL.count:format(self:GetRename(1241292), embersCount)
	embersCount = embersCount + 1
	return {
		msg = soaksText,
		key = 1241292,
		icon = 1241292,
		onFinished = function()
			self:Message(1241292, "red")
			self:PersonalMessageFromBlizzMessage(1241292, 1, false, self:GetRename(1241292, 2))
			-- if the adds spawn, they don't go away on phase, so no need to stop this
			self:CastBar(1241292, 9, 3)

			self:ScheduleTimer(function()
				self:Message(1241282, "cyan", addsText)
				self:PlaySound(1241282, "info", "adds")
			end, 9)
		end,
	}
end

function mod:RadiantEchoes(duration) -- Orbs
	local barText = CL.count:format(self:GetRename(1242981), echosCount)
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

function mod:GuardiansEdict(duration) -- Tank Combo
	local barText = CL.count:format(self:GetRename(1260763), edictCount)
	edictCount = edictCount + 1
	return {
		msg = barText,
		key = 1260763,
		onFinished = function()
			self:StopBlizzMessages(0.5)
			self:Message(1260763, "purple", barText)
			if self:Tank() then
				self:PlaySound(1260763, "alert")
			end
		end
	}
end

function mod:EternalBurns(duration) -- Heal Absorbs
	local barText = CL.count:format(self:GetRename(1244344), burnsCount)
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

function mod:InfusedQuills(duration) -- Quills
	local barText = CL.count:format(self:GetRename(1242260), quillsCount)
	quillsCount = quillsCount + 1
	return {
		msg = barText,
		key = 1242260,
		onFinished = function()
			self:PersonalMessageFromBlizzMessage(1242260, 1, false, self:GetRename(1242260, 2))
			self:Message(1242260, "orange", barText)
		end
	}
end

function mod:VoidlightConvergence(duration) -- Color Swaps
	if self:ShouldShowBars() then
		self:Message(1242515, "cyan", CL.count:format(self:GetRename(1242515), convergenceCount))
		if convergenceCount > 1 or self:GetStage() > 1 then
			self:PlaySound(1242515, "long")
		end
	end
	convergenceCount = convergenceCount + 1
	local barText = CL.count:format(self:GetRename(1242515), convergenceCount)
	return {
		msg = barText,
		key = 1242515,
	}
end

function mod:DeathDrop(duration) -- Landing
	-- SetStage here to match lr
	self:SetStage(self:GetStage() + 1)

	durationEventCount = {}
	isIntermission = true

	embersCount = 1
	echosCount = 1
	edictCount = 1
	burnsCount = 1
	quillsCount = 1
	convergenceCount = 1

	if self:ShouldShowBars() then
		self:Message(1246709, "red")
		self:PlaySound(1246709, "warning")
	end
	return {
		msg = self:GetRename(1246709),
		key = 1246709,
		onEnd = function() -- not used, just for the parser
			mod:Bar(1246709, 10)
		end,
	}
end

-- Phase 2
function mod:UNIT_SPELLCAST_START(event, unit)
	self:UnregisterUnitEvent(event, unit)
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, unit)
	if self:ShouldShowBars() then
		self:StopBlizzMessages(0.5)
		self:Message(1241313, "cyan")
		self:Bar(1241313, 40)
		self:PlaySound(1241313, "long")
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(event, unit)
	isIntermission = false
	self:UnregisterUnitEvent(event, unit)
	if self:ShouldShowBars() and not self:IsWiping() then
		self:Bar(1242515, 4.5, CL.count:format(self:GetRename(1242515), convergenceCount)) -- Voidlight Convergence (Color Swaps)

		self:Message("stages", "cyan", nil, false)
		self:PlaySound("stages", "info")
	end
end

function mod:Rebirth()
	self:RegisterUnitEvent("UNIT_SPELLCAST_START", nil, "boss1")
	return false
end
