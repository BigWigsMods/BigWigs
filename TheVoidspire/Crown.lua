
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Crown of the Cosmos", 2912, 2738)
if not mod then return end
mod:RegisterEnableMob(240430, 243805, 243810, 243811) -- Alleria, Morium, Demiar, Vorelus
mod:SetEncounterID(3181)
mod:SetRespawnTime(30)
mod:UseCustomTimers(true)
mod:SetStage(1)

mod:SetPrivateAuraSounds({
	1233602, -- Silverstrike Arrow (Targetted)
	{1232470, 1260027, sound = "alert"}, -- Grasp of Emptiness
	1283236, -- Void Expulsion (Targetted)
	{1242553, sound = "underyou"}, -- Void Remnants
	{1233865, 1233887, sound = "alarm"}, -- Null Corona
	{1243753, sound = "alert"}, -- Ravenous Abyss
	{1243981, sound = "none"}, -- Silverstrike Barrage
	{1234570, sound = "alert"}, -- Stellar Emission
	{1246462, sound = "alarm"}, -- Rift Slash
	{1238206, sound = "underyou"}, -- Volatile Fissure
	{1237623, 1259861}, -- Ranger Captain's Mark (Targetted)
	{1237038, sound = "none"}, -- Voidstalker's Sting
	{1227557, sound = "underyou"}, -- Devouring Cosmos
	1239111, -- Aspect of the End
	{1255453, sound = "alarm"}, -- Gravity Collapse
	{1238708, sound = "info"}, -- Dark Rush
})

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}

local function getBarInfoFromKey(key)
	for _, barInfo in next, activeBars do
		if barInfo.key == key then
			return barInfo
		end
	end
end

local timelineEventCount = 0
local durationEventCount = {}
local stageStage = 1

local silverstrikeArrowCount = 1
local graspOfEmptinessCount = 1
local voidExpulsionCount = 1
local nullCoronaCount = 1
local darkHandCount = 1
local interruptingTremorCount = 1
local ravenousAbyssCount = 1

local silverstrikeBarrageCount = 1

local markCount = 1
local stingCount = 1
local callOfTheVoidCount = 1
local cosmicBarrierCount = 1
local riftSlashCount = 1

local devouringCosmosCount = 1
local aspectOfTheEndCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.silverstrike_arrow = "Arrows"
	L.grasp_of_emptiness = "Obelisks"
	L.interrupting_tremor = "Interrupt"
	L.ravenous_abyss = "Move Out"
	L.silverstrike_barrage = "Lines"
	L.cosmic_barrier = "Barrier"
	L.rangers_captains_mark = "Arrows"
	L.voidstalker_sting = "Stings"
	L.aspect_of_the_end = "Tethers"
	L.devouring_cosmos = "Next Platform"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",

		-- Stage One: The Void's Spire
		1233602, -- Silverstrike Arrow
		1232467, -- Grasp of Emptiness
		1255368, -- Void Expulsion
		1233865, -- Null Corona
		{1233787, "TANK"}, -- Dark Hand (Morium)
		1243743, -- Interrupting Tremor (Demiar)
		1243753, -- Ravenous Abyss (Vorelus)

		-- Intermission: Crushing Singularity
		1243982, -- Silverstrike Barrage
		-- {1234569, "PRIVATE"}, -- Stellar Emission
		-- 1235622, -- Singularity Eruption (Damage)

		-- Stage Two: The Severed Rift
		-- 1238206, -- Volatile Fissure (Damage)
		1237614, -- Ranger Captain's Mark
		-- 1255368, -- Void Expulsion
		1237038, -- Voidstalker's Sting
		1237837, -- Call of the Void
		1246918, -- Comsmic Barrier
		{1246461, "TANK"}, -- Rift Slash

		-- Intermission: Shattering Singularity
		-- 1243982, -- Silverstrike Barrage
		-- 1234569, -- Stellar Emission
		-- 1245874, -- Orbiting Matter

		-- Stage Three: The End of the End
		1238843, -- Devoiring Cosmos
		1239080, -- Aspect of the End
		-- 1232470, -- Grasp of Emptiness
		-- 1233865, -- Null Corona
		-- 1237038, -- Voidstalker's Sting
		-- 1238708, -- Dark Rush
	},{
		{ tabName = CL.stage:format(1), { "stages", 1233602, 1232467, 1255368, 1233865, 1233787, 1243743, 1243753, }, },
		{ tabName = CL.stage:format(2), { "stages", 1237614, 1255368, 1237038, 1237837, 1246918, 1246461, }, },
		{ tabName = CL.stage:format(3), { "stages", 1238843, 1239080, 1232467, 1233865, 1237038, }, },
		{ tabName = CL.intermission, { "stages", 1243982, }, },

		[1233787] = -32458, -- Morium
		[1243743] = -33152, -- Demiar
		[1243753] = -33153, -- Vorelus
		[1233602] = -32196, -- Stage 1
		-- [1243982] = -32454, -- Intermission 1
		[1237614] = -32455, -- Stage 2
		-- [1245874] = -33091, -- Intermission 2
		[1238843] = -32456, -- Stage 3
	},{
		[1233602] = L.silverstrike_arrow, -- Arrows
		[1232467] = L.grasp_of_emptiness, -- Obelisks
		-- [1255368] = L.void_expulsion, -- Bait
		[1233865] = CL.heal_absorb, -- Null Corona
		[1243743] = L.interrupting_tremor, -- Interrupt
		[1243753] = L.ravenous_abyss, -- Move Out
		[1243982] = L.silverstrike_barrage, -- Lines
		[1237614] = L.rangers_captains_mark, -- Arrows
		[1237038] = L.voidstalker_sting, -- Stings
		[1246918] = L.cosmic_barrier, -- Barrier
		[1238843] = L.devouring_cosmos, -- Next Platform
		[1239080] = L.aspect_of_the_end, -- Tethers
	}
end

function mod:OnBossEnable()
	backupBars = {}
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "TimersOther")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
end

function mod:OnEncounterStart()
	self:SetStage(1)

	timelineEventCount = 0
	durationEventCount = {}
	stageStage = 1

	silverstrikeArrowCount = 1
	graspOfEmptinessCount = 1
	voidExpulsionCount = 1
	nullCoronaCount = 1
	darkHandCount = 1
	interruptingTremorCount = 1
	ravenousAbyssCount = 1

	silverstrikeBarrageCount = 1

	markCount = 1
	stingCount = 1
	callOfTheVoidCount = 1
	cosmicBarrierCount = 1
	riftSlashCount = 1

	devouringCosmosCount = 1
	aspectOfTheEndCount = 1
end

function mod:OnBossDisable()
	for eventID in next, backupBars do
		self:SendMessage("BigWigs_StopBar", nil, nil, eventID)
	end
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

local prev = 0
function mod:TimersOther(_, eventInfo)
	if eventInfo.source ~= 0 then return end
	local barInfo

	timelineEventCount = timelineEventCount + 1
	local now = GetTime()
	local timeSinceLastEvent = now - prev
	prev = now

	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 1)

	local stage = self:GetStage()

	-- Silverstrike Barrage is always have after rp
	if durationRounded == 1.5 and timeSinceLastEvent > 1 then
		barInfo = self:SilverstrikeBarrage(duration)

	elseif stage == 1 then
		if durationRounded == 25 then -- Stage Two
			-- callback sets intermission, resets counts
			barInfo = self:StageEvent(duration)

		-- pull timers
		elseif durationRounded == 24 then
			barInfo = self:SilverstrikeArrow(duration)
		elseif durationRounded == 5 then
			barInfo = self:GraspOfEmptiness(duration)
		elseif durationRounded == (self:Easy() and 60 or 12) then
			barInfo = self:VoidExpulsion(duration)
		elseif durationRounded == 2 or durationRounded == 46.5 then
			barInfo = self:NullCorona(duration)
		elseif durationRounded == 4 then
			durationEventCount[durationRounded] = (durationEventCount[durationRounded] or 0) + 1
			local count = durationEventCount[durationRounded]
			if count == 1 then
				barInfo = self:InterruptingTremor(duration)
			elseif count == 2 then
				barInfo = self:DarkHand(duration)
			elseif count == 3 then
				barInfo = self:RavenousAbyss(duration)
			end
			-- the order of these can change, so just fire bars for them and we'll
			-- figure out the message on the next timer
			if self:ShouldShowBars() then
				self:CDBar(barInfo.key, duration, barInfo.msg)
			end
			return false -- don't want callback to fire

		-- repeating timers
		elseif (self:Easy() and durationRounded == 48) or durationRounded == 44.5 or durationRounded == 27 then
			barInfo = self:NullCorona(duration)
		elseif durationRounded == 48 then -- not self:Easy()
			if voidExpulsionCount % 3 == 2 then
				barInfo = self:VoidExpulsion(duration)
			else
				barInfo = self:NullCorona(duration)
			end
		elseif durationRounded == 21 or durationRounded == 23 then
			barInfo = self:SilverstrikeArrow(duration)
		elseif durationRounded == 28 or durationRounded == 32 or durationRounded == 31.5 then
			barInfo = self:GraspOfEmptiness(duration)
		elseif durationRounded == 39 then
			barInfo = self:VoidExpulsion(duration)
		elseif durationRounded == (self:Easy() and 17 or 26) then
			barInfo = self:DarkHand(duration)
		elseif durationRounded == 20 then
			barInfo = self:InterruptingTremor(duration)
		elseif durationRounded == 19.5 then
			barInfo = self:RavenousAbyss(duration)

		-- at 2min in p1, p1 restarts - 0.5 (excluding add timers), canceling and restarting active bars
		elseif durationRounded == 4.5 then
			local oldBarInfo = getBarInfoFromKey(1232467)
			if oldBarInfo then
				oldBarInfo.noStopBar = true
				barInfo = self:GraspOfEmptiness(duration, true)
				barInfo.duration = {duration, oldBarInfo.duration}
			else
				barInfo = self:GraspOfEmptiness(duration)
			end
		elseif durationRounded == (self:Easy() and 46 or 1.5) then
			local oldBarInfo = getBarInfoFromKey(1233865)
			if oldBarInfo then
				oldBarInfo.noStopBar = true
				barInfo = self:NullCorona(duration, true)
				barInfo.duration = {duration, oldBarInfo.duration}
			else
				barInfo = self:NullCorona(duration)
			end
		elseif durationRounded == (self:Easy() and 59.5 or 11.5) then
			barInfo = self:VoidExpulsion(duration)
		elseif durationRounded == 23.5 then
			barInfo = self:SilverstrikeArrow(duration)
		end

	elseif stage == 2 then
		if timelineEventCount == 1 and markCount == 1 then
			self:Message("stages", "cyan", CL.stage:format(stage), false)
			self:PlaySound("stages", "long")
		end

		if silverstrikeBarrageCount > 1 and durationRounded == 20 then -- Stage Three
			-- callback sets intermission, resets counts
			barInfo = self:StageEvent(duration)

		elseif durationRounded == 13 or durationRounded == 11 then
			barInfo = self:NullCorona(duration)
		elseif durationRounded == 21 or durationRounded == 19 then
			barInfo = self:RangerCaptainsMark(duration)
		elseif durationRounded == 16 or durationRounded == 14 then
			barInfo = self:VoidExpulsion(duration)
		elseif durationRounded == 8 then
			barInfo = self:VoidstalkerSting(duration)
		elseif (durationRounded == 12 and callOfTheVoidCount == 1) or durationRounded == 10 then
			barInfo = self:CallOfTheVoid(duration)
		elseif durationRounded == 24 or durationRounded == 22 then
			barInfo = self:CosmicBarrier(duration)
		elseif durationRounded == 20 then
			durationEventCount[durationRounded] = (durationEventCount[durationRounded] or 0) + 1
			if durationEventCount[durationRounded] == 1 then
				barInfo = self:VoidExpulsion(duration)
			else
				barInfo = self:VoidstalkerSting(duration)
			end
		elseif durationRounded == 6 then
			if riftSlashCount == 1 then
				barInfo = self:RiftSlash(duration)
			else
				barInfo = self:VoidstalkerSting(duration)
			end
		elseif durationRounded == 5 then
			barInfo = self:VoidstalkerSting(duration)
		elseif durationRounded == 12 then
			if riftSlashCount == 2 then
				-- fake, finishes with the first 6s cast
				return false
			end
			barInfo = self:RiftSlash(duration)
		end

	elseif stage == 3 then
		if timelineEventCount == 1 and devouringCosmosCount == 1 then
			self:Message("stages", "cyan", CL.stage:format(stage), false)
			self:PlaySound("stages", "long")
		end

		-- stage start timers
		if durationRounded == 60 or durationRounded == 59 then
			-- callback handles stageStage
			barInfo = self:DevouringCosmos(duration)
		elseif durationRounded == 30 or durationRounded == 29 then
			barInfo = self:NullCorona(duration)
		elseif durationRounded == 19 or durationRounded == 11 then
			barInfo = self:GraspOfEmptiness(duration)
		elseif durationRounded == 15 or durationRounded == 14 then
			barInfo = self:VoidstalkerSting(duration)
		elseif durationRounded == 9 or durationRounded == 8 then
			-- 8 is a refresh of previous 21s cast
			if durationRounded == 8 then
				local oldBarInfo = getBarInfoFromKey(1239080)
				if oldBarInfo then
					oldBarInfo.noStopBar = true
					barInfo = self:AspectOfTheEnd(duration, true)
					barInfo.duration = {duration, oldBarInfo.duration}
				end
			end
			if not barInfo then
				barInfo = self:AspectOfTheEnd(duration)
			end
		-- repeating timers
		elseif durationRounded == 18 then
			durationEventCount[durationRounded] = (durationEventCount[durationRounded] or 0) + 1
			if not self:Easy() or durationEventCount[durationRounded] % 2 == 1 then
				barInfo = self:VoidstalkerSting(duration)
			else
				barInfo = self:GraspOfEmptiness(duration)
			end
		elseif durationRounded == 12 then
			if not self:Easy() and graspOfEmptinessCount == 1 then
				barInfo = self:GraspOfEmptiness(duration)
			else
				barInfo = self:VoidstalkerSting(duration)
			end
		elseif durationRounded == 7 or durationRounded == 20 or durationRounded == 17 then
			barInfo = self:GraspOfEmptiness(duration)
		elseif durationRounded == 39 or durationRounded == 21 then
			barInfo = self:AspectOfTheEnd(duration)
		end

	else -- Intermission
		if durationRounded == 3 or durationRounded == 6 or durationRounded == 9.5 then
			barInfo = self:SilverstrikeBarrage(duration)
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
		if state == 1 then -- Enum.EncounterTimelineEventState.Paused = 1
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventInfo.id)
		end
	end
end

function mod:ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED(_, eventID)
	local barInfo = activeBars[eventID]
	if barInfo then
		local state = C_EncounterTimeline.GetEventState(eventID)
		-- This encounter had paused/resumed bars during the boss's full energy spell. We don't show those as it's confusing.
		if state == 2 or state == 3 then -- Finished or Canceled
			if not barInfo.noStopBar then
				self:StopBar(barInfo.msg)
			end

			if self:ShouldShowBars() then
				if state == 2 and barInfo.onFinished then -- Finished
					barInfo.onFinished()
				elseif state == 3 and barInfo.onCanceled then -- Canceled
					barInfo.onCanceled()
				end
			end

			activeBars[eventID] = nil
		end
	elseif backupBars[eventID] then
		local newState = C_EncounterTimeline.GetEventState(eventID)
		if newState == 0 then -- Enum.EncounterTimelineEventState.Active
			self:SendMessage("BigWigs_ResumeBar", nil, nil, eventID)
		elseif newState == 1 then -- Enum.EncounterTimelineEventState.Paused
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventID)
		elseif newState == 3 then -- Enum.EncounterTimelineEventState.Canceled
			self:SendMessage("BigWigs_StopBar", nil, nil, eventID)
		elseif newState == 2 then -- Enum.EncounterTimelineEventState.Finished
			local info = C_EncounterTimeline.GetEventInfo(eventID)
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

local function intermissionEnd()
	local stage = mod:GetStage() + 0.5
	mod:SetStage(stage)

	timelineEventCount = 0
	durationEventCount = {}
	stageStage = 1

	graspOfEmptinessCount = 1
	voidExpulsionCount = 1
	nullCoronaCount = 1

	silverstrikeBarrageCount = 1

	markCount = 1
	stingCount = 1
	callOfTheVoidCount = 1
	cosmicBarrierCount = 1
	riftSlashCount = 1
end

function mod:StageEvent(duration)
	local stage = self:GetStage()
	self:SetStage(stage + 0.5)
	self:Message("stages", "cyan", CL.count:format(CL.intermission, stage), false)
	self:PlaySound("stages", "long")
	return {
		msg = CL.stage:format(stage + 1),
		key = "stages",
		icon = 1280127,
		onFinished = intermissionEnd, -- Stage Three finishes
		onCanceled = intermissionEnd, -- Stage Two cancels
	}
end

function mod:SilverstrikeBarrage(duration)
	local barText = CL.count:format(L.silverstrike_barrage, silverstrikeBarrageCount)
	silverstrikeBarrageCount = silverstrikeBarrageCount + 1
	return {
		msg = barText,
		key = 1243982,
	}
end

-- Stage 1

function mod:SilverstrikeArrow(duration)
	local barText = CL.count:format(L.silverstrike_arrow, silverstrikeArrowCount)
	silverstrikeArrowCount = silverstrikeArrowCount + 1
	return {
		msg = barText,
		key = 1233602,
		onFinished = function()
			self:Message(1233602, "cyan", barText)
			self:TargetMessageFromBlizzMessage(0.5, 1233602, "blue", CL.you:format(L.silverstrike_arrow))
			-- PA target sound
		end,
	}
end

function mod:GraspOfEmptiness(duration, updateBar)
	local barText
	if updateBar then
		barText = CL.count:format(L.grasp_of_emptiness, graspOfEmptinessCount-1)
	else
		barText = CL.count:format(L.grasp_of_emptiness, graspOfEmptinessCount)
		graspOfEmptinessCount = graspOfEmptinessCount + 1
	end
	return {
		msg = barText,
		key = 1232467,
		onFinished = function()
			self:Message(1232467, "yellow", barText)
			-- PA target sound
		end,
	}
end

function mod:VoidExpulsion(duration)
	local barText = CL.count:format(self:SpellName(1255368), voidExpulsionCount)
	voidExpulsionCount = voidExpulsionCount + 1
	return {
		msg = barText,
		key = 1255368,
		onFinished = function(barInfo)
			self:StopBlizzMessages(1)
			self:Message(1255368, "red", barText)
			self:PlaySound(1255368, "alert") -- big damage
		end,
	}
end

function mod:NullCorona(duration, updateBar)
	local barText
	if updateBar then
		barText = CL.count:format(CL.heal_absorb, nullCoronaCount-1)
	else
		barText = CL.count:format(CL.heal_absorb, nullCoronaCount)
		nullCoronaCount = nullCoronaCount + 1
	end
	return {
		msg = barText,
		key = 1233865,
		onFinished = function()
			self:Message(1233865, "yellow", barText)
		end,
	}
end

function mod:DarkHand(duration)
	if darkHandCount == 2 then
		local text = CL.count:format(self:SpellName(1233787), 1)
		self:StopBar(text)

		self:Message(1233787, "purple", text)
	end

	local barText = CL.count:format(self:SpellName(1233787), darkHandCount)
	darkHandCount = darkHandCount + 1
	return {
		msg = barText,
		key = 1233787,
		onFinished = function()
			self:Message(1233787, "purple", barText)
		end,
	}
end

function mod:InterruptingTremor(duration)
	if interruptingTremorCount == 2 then
		local text = CL.count:format(L.interrupting_tremor, 1)
		self:StopBar(text)

		self:StopBlizzMessages(0.5)
		self:Message(1243743, "red", text)
		self:PlaySound(1243743, "alert")
	end

	local barText = CL.count:format(L.interrupting_tremor, interruptingTremorCount)
	interruptingTremorCount = interruptingTremorCount + 1
	return {
		msg = barText,
		key = 1243743,
		onFinished = function()
			self:StopBlizzMessages(1)
			self:Message(1243743, "orange", barText)
			self:PlaySound(1243743, "alert")
		end,
	}
end

function mod:RavenousAbyss(duration)
	if ravenousAbyssCount == 2 then
		local text = CL.count:format(L.ravenous_abyss, 1)
		self:StopBar(text)

		self:Message(1243753, "orange", text)
	end

	local barText = CL.count:format(L.ravenous_abyss, ravenousAbyssCount)
	ravenousAbyssCount = ravenousAbyssCount + 1
	return {
		msg = barText,
		key = 1243753,
		onFinished = function()
			self:Message(1243753, "orange", barText)
		end,
	}
end

-- Stage 2

function mod:RangerCaptainsMark(duration)
	local barText = CL.count:format(L.rangers_captains_mark, markCount)
	markCount = markCount + 1
	return {
		msg = barText,
		key = 1237614,
		onFinished = function()
			self:StopBlizzMessages(1)
			self:Message(1237614, "cyan", barText)
			-- self:PlaySound(1237614, "alarm", "spread") -- spread
		end,
	}
end

function mod:VoidstalkerSting(duration)
	local barText = CL.count:format(L.voidstalker_sting, stingCount)
	stingCount = stingCount + 1
	return {
		msg = barText,
		key = 1237038,
	}
end

function mod:CallOfTheVoid(duration)
	local barText = CL.count:format(self:SpellName(1237837), callOfTheVoidCount)
	callOfTheVoidCount = callOfTheVoidCount + 1
	return {
		msg = barText,
		key = 1237837,
		onFinished = function()
			self:Message(1237837, "cyan", barText)
			self:PlaySound(1237837, "info") -- adds
		end,
	}
end

function mod:CosmicBarrier(duration)
	local barText = CL.count:format(L.cosmic_barrier, cosmicBarrierCount)
	cosmicBarrierCount = cosmicBarrierCount + 1
	return {
		msg = barText,
		key = 1246918,
		onFinished = function()
			self:Message(1246918, "orange", barText)
			-- XXX gets held then canceled alot?
			self:StopBlizzMessages(0.5)
		end,
	}
end

function mod:RiftSlash(duration)
	local barText = CL.count:format(self:SpellName(1246461), riftSlashCount)
	riftSlashCount = riftSlashCount + 1
	return {
		msg = barText,
		key = 1246461,
		onFinished = function()
			self:Message(1246461, "purple", barText)
		end,
	}
end

-- Stage 3

function mod:DevouringCosmos(duration)
	local barText = CL.count:format(L.devouring_cosmos, devouringCosmosCount)
	devouringCosmosCount = devouringCosmosCount + 1
	return {
		msg = barText,
		key = 1238843,
		onFinished = function()
			timelineEventCount = 1
			durationEventCount = {}
			stageStage = stageStage + 1

			self:Message(1238843, "red", barText)
			self:PlaySound(1238843, "long")
			self:StopBlizzMessages(1)
		end,
	}
end

function mod:AspectOfTheEnd(duration, updateBar)
	local barText
	if updateBar then
		barText = CL.count:format(L.aspect_of_the_end, aspectOfTheEndCount-1)
	else
		barText = CL.count:format(L.aspect_of_the_end, aspectOfTheEndCount)
		aspectOfTheEndCount = aspectOfTheEndCount + 1
	end
	return {
		msg = barText,
		key = 1239080,
		onFinished = function()
			self:Message(1239080, "orange", barText)
			self:TargetMessageFromBlizzMessage(0.5, 1239080, "blue", CL.you:format(L.aspect_of_the_end))
		end,
	}
end
