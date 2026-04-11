
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

local function stopBar(barInfo, isFinished)
	if not barInfo then return end
	mod:StopBar(barInfo.msg)
	if isFinished and barInfo.onFinished and not mod:IsWiping() then
		barInfo:onFinished()
	end
	activeBars[barInfo.eventID] = nil
end

local function updateBar(key, callback, duration)
	local barInfo
	local oldBarInfo = getBarInfoFromKey(key)
	if oldBarInfo then
		stopBar(oldBarInfo)
		barInfo = oldBarInfo
		barInfo.duration = {duration, oldBarInfo.duration}
	else
		barInfo = mod[callback](mod, duration)
	end
	return barInfo
end


local timelineEventCount = 0
local durationEventCount = {}
local substage = 1

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
local riftSimulacrumCount = 1

local devouringCosmosCount = 1
local aspectOfTheEndCount = 1
local cosmicPortalCount = 1

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
		{1233865, "HEALER"}, -- Null Corona
		{1233787, "TANK"}, -- Dark Hand (Morium)
		1243743, -- Interrupting Tremor (Demiar)
		1243753, -- Ravenous Abyss (Vorelus)

		-- Intermission: Crushing Singularity
		1243982, -- Silverstrike Barrage

		-- Stage Two: The Severed Rift
		1237614, -- Ranger Captain's Mark
		{1237038, "OFF"}, -- Voidstalker's Sting
		1237837, -- Call of the Void
		1246918, -- Comsmic Barrier
		{1246461, "TANK"}, -- Rift Slash

		1261016, -- Rift Simulacrum

		-- Stage Three: The End of the End
		1238843, -- Devoiring Cosmos
		1239080, -- Aspect of the End

		1261339, -- Cosmic Portal
	},{
		{ tabName = CL.stage:format(1), { "stages", 1233602, 1232467, 1255368, 1233865, 1233787, 1243743, 1243753 }, },
		{ tabName = CL.stage:format(2), { "stages", 1237614, 1255368, 1237038, 1237837, 1246918, 1246461, 1261016 }, },
		{ tabName = CL.stage:format(3), { "stages", 1238843, 1239080, 1232467, 1233865, 1237038, 1261016, 1261339 }, },
		{ tabName = CL.intermission, { "stages", 1243982, }, },

		[1233787] = -32458, -- Morium
		[1243743] = -33152, -- Demiar
		[1243753] = -33153, -- Vorelus
		[1233602] = -32196, -- Stage 1
		[1237614] = -32455, -- Stage 2
		[1261016] = "mythic",
		[1238843] = -32456, -- Stage 3
	},{
		[1233602] = L.silverstrike_arrow, -- Arrows
		[1232467] = L.grasp_of_emptiness, -- Obelisks
		[1233865] = CL.heal_absorb, -- Null Corona
		[1243743] = L.interrupting_tremor, -- Interrupt
		[1243753] = L.ravenous_abyss, -- Move Out
		[1243982] = L.silverstrike_barrage, -- Lines
		[1237614] = L.rangers_captains_mark, -- Arrows
		[1237038] = L.voidstalker_sting, -- Stings
		[1246918] = L.cosmic_barrier, -- Barrier
		[1238843] = L.devouring_cosmos, -- Next Platform
		[1239080] = L.aspect_of_the_end, -- Tethers
		[1261339] = CL.big_add, -- Cosmic Portal
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
	self:ResetCounts()

	substage = 1
	devouringCosmosCount = 1
end

function mod:ResetCounts()
	timelineEventCount = 0
	durationEventCount = {}

	graspOfEmptinessCount = 1
	voidExpulsionCount = 1
	nullCoronaCount = 1

	silverstrikeBarrageCount = 1

	markCount = 1
	stingCount = 1
	callOfTheVoidCount = 1
	cosmicBarrierCount = 1
	riftSlashCount = 1
	riftSimulacrumCount = 1

	aspectOfTheEndCount = 1
	cosmicPortalCount = 1
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
function mod:TimersMythic(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo

	timelineEventCount = timelineEventCount + 1
	local now = GetTime()
	local timeSinceLastEvent = now - prev
	prev = now

	local stage = self:GetStage()
	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 0)
	local durationRoundedOne = self:RoundNumber(duration, 1)

	if stage == 2 and timelineEventCount == 1 then
		-- set by IntermissionEnd
		if self:ShouldShowBars() then
			self:Message("stages", "cyan", CL.stage:format(stage), false)
			self:PlaySound("stages", "long")
		end

	elseif stage == 2 and timeSinceLastEvent > 15 then
		stage = 3
		self:SetStage(stage)

		if self:ShouldShowBars() then
			self:Message("stages", "cyan", CL.stage:format(stage), false)
			self:PlaySound("stages", "long")
		end

		self:ResetCounts()
		timelineEventCount = 1
	end

	if stage == 1 then
		-- intermision start
		if durationRoundedOne == 1.5 then
			barInfo = self:SilverstrikeBarrage(duration)
		elseif durationRoundedOne == 25 then -- Stage Two
			-- callback sets intermission, resets counts
			barInfo = self:IntermissionEvent(duration)
			barInfo.timer = self:ScheduleTimer(barInfo.onEnd, duration)

		-- pull timers
		elseif durationRoundedOne == 20 then
			durationEventCount[durationRoundedOne] = (durationEventCount[durationRoundedOne] or 0) + 1
			if durationEventCount[durationRoundedOne] == 1 then
				barInfo = self:SilverstrikeArrow(duration)
			else
				barInfo = self:InterruptingTremor(duration)
			end
		elseif durationRoundedOne == 4.2 or durationRoundedOne == 103.8 then
			barInfo = self:GraspOfEmptiness(duration)
		elseif durationRoundedOne == 10 then
			barInfo = self:VoidExpulsion(duration)
		elseif durationRoundedOne == 1.7 then
			barInfo = self:NullCorona(duration)
		elseif durationRoundedOne == 4 then
			durationEventCount[durationRoundedOne] = (durationEventCount[durationRoundedOne] or 0) + 1
			local count = durationEventCount[durationRoundedOne]
			if count == 1 then
				barInfo = self:InterruptingTremor(duration)
			elseif count == 2 then
				barInfo = self:DarkHand(duration)
			elseif count == 3 then
				-- this only gets cast when someone is in range, so the timer events are weird
				barInfo = self:RavenousAbyss(duration)
			end
			-- the order of these can change, so just fire bars for them and we'll
			-- figure out the message on the next timer
			if barInfo then
				if self:ShouldShowBars() then
					self:CDBar(barInfo.key, duration, barInfo.msg)
				end
				return false -- don't want callback to fire
			end

		-- repeating timers
		elseif durationRoundedOne == 17.5 or durationRoundedOne == 19.2 or durationRoundedOne == 19.6 then
			barInfo = self:SilverstrikeArrow(duration)
		elseif durationRoundedOne == 23.3 or durationRoundedOne == 26.7 or durationRoundedOne == 26.3 or durationRoundedOne == 3.8 or durationRoundedOne == 103.3 then
			if durationRoundedOne == 3.8 then
				barInfo = updateBar(1232467, "GraspOfEmptiness", duration)
			else
				barInfo = self:GraspOfEmptiness(duration)
			end
		elseif durationRoundedOne == 40 then
			durationEventCount[durationRoundedOne] = (durationEventCount[durationRoundedOne] or 0) + 1
			if durationEventCount[durationRoundedOne] % 2 == 0 then
				barInfo = self:NullCorona(duration)
			else
				barInfo = self:VoidExpulsion(duration)
			end
		elseif durationRoundedOne == 32.5 or durationRoundedOne == 9.6 then
			barInfo = self:VoidExpulsion(duration)
		elseif durationRoundedOne == 37.1 or durationRoundedOne == 22.5 or durationRoundedOne == 1.3 then
			if durationRoundedOne == 1.3 then
				barInfo = updateBar(1233865, "NullCorona", duration)
			else
				barInfo = self:NullCorona(duration)
			end
		elseif durationRoundedOne == 26 then
			barInfo = self:DarkHand(duration)
		elseif durationRoundedOne == 19.5 then
			barInfo = self:RavenousAbyss(duration)
		end

	elseif stage == 2 then
		if durationRounded == 13 or durationRounded == 11 then
			barInfo = self:GraspOfEmptiness(duration)
		elseif durationRounded == 12 or durationRounded == 16 then
			if durationRounded == 12 and stingCount == 1 then -- p2 initial timer
				barInfo = self:VoidstalkerSting(duration)
			else
				barInfo = self:RiftSlash(duration)
			end
		elseif durationRounded == 27 then
			barInfo = self:RangerCaptainsMark(duration)
		elseif durationRounded == 20 or durationRounded == 18 then
			barInfo = self:VoidExpulsion(duration)
		elseif durationRoundedOne == 1.5 then
			barInfo = self:RiftSimulacrum(duration)
		elseif durationRounded == 50 then
			barInfo = self:CallOfTheVoid(duration)
		elseif durationRounded == 2 or durationRounded == 10 or durationRounded == 23 then
			barInfo = self:VoidstalkerSting(duration)
		elseif durationRounded == 25 then
			durationEventCount[durationRounded] = (durationEventCount[durationRounded] or 0) + 1
			local count = durationEventCount[durationRounded]
			if count % 4 == 1 then
				barInfo = self:GraspOfEmptiness(duration)
			elseif count % 4 == 2 then
				barInfo = self:VoidExpulsion(duration)
			else
				barInfo = self:RangerCaptainsMark(duration)
			end
		elseif durationRounded == 6 or durationRounded == 4 then
			durationEventCount[durationRounded] = (durationEventCount[durationRounded] or 0) + 1
			local count = durationEventCount[durationRounded]
			if count % 2 == 1 then -- Rift Slash
				barInfo = updateBar(1246461, "RiftSlash", duration)
			else -- Call of the Void
				barInfo = updateBar(1237837, "CallOfTheVoid", duration)
			end
		end

	elseif stage == 3 then
		if durationRounded == 60 or durationRounded == 59 then
			-- callback handles substage
			barInfo = self:DevouringCosmos(duration)

		elseif durationRounded == 10 or durationRounded == 9 or durationRounded == 35 then
			-- Grasp of Emptiness
			if durationRounded == 9 then
				barInfo = updateBar(1232467, "GraspOfEmptiness", duration)
			else
				barInfo = self:GraspOfEmptiness(duration)
			end
		elseif durationRounded == 7 or durationRounded == 6 or durationRounded == 41 or durationRounded == 19 then
			-- Aspect of the End
			if durationRounded == 6 then
				barInfo = updateBar(1239080, "AspectOfTheEnd", duration)
			else
				barInfo = self:AspectOfTheEnd(duration)
			end
		elseif durationRounded == 37 or durationRounded == 36 then
			barInfo = self:VoidExpulsion(duration)
		elseif durationRounded == 16 then
			if stingCount == 1 then -- initial p3 timer
				barInfo = self:VoidstalkerSting(duration)
			else
				barInfo = self:GraspOfEmptiness(duration)
			end
		elseif durationRounded == 15 then
			if cosmicPortalCount == 1 then -- initial p3 timer
				barInfo = self:CosmicPortal(duration)
			else
				barInfo = self:VoidstalkerSting(duration)
			end
		elseif durationRounded == 17 and stingCount == 2 then -- first recast
			barInfo = self:VoidstalkerSting(duration)
		elseif durationRounded == 30 or durationRounded == 29 then
			barInfo = self:NullCorona(duration)
		elseif durationRounded == 11 then
			barInfo = self:RiftSimulacrum(duration)
		elseif durationRounded == 12 then
			if riftSimulacrumCount == 1 then -- initial p3 timer
				barInfo = self:RiftSimulacrum(duration)
			else
				barInfo = self:VoidstalkerSting(duration)
			end
		elseif durationRounded == 14 then
			durationEventCount[durationRounded] = (durationEventCount[durationRounded] or 0) + 1
			local count = durationEventCount[durationRounded]
			if substage > 1 and count == 1 then  -- stage timer
				barInfo = self:CosmicPortal(duration)
			elseif substage == 3 and count % 2 == 0 then
				-- XXX if add is killed before the first cast, Voidstalker Sting will use this
				barInfo = self:DarkHand(duration)
			else
				barInfo = self:VoidstalkerSting(duration)
			end

		-- add casts, bad things probably happen if you have multiple up
		elseif riftSimulacrumCount == 2 and (durationRounded == 8 or durationRounded == 17) then -- actually 16.5 but the only other 17 cast is sting 2 which should already be caught
			barInfo = self:RavenousAbyss(duration)
		elseif riftSimulacrumCount == 3 and (durationRounded == 8 or durationRounded == 17) then -- all but the first 17 for substage 2
			barInfo = self:InterruptingTremor(duration)
		elseif durationRounded == 20 then
			if riftSimulacrumCount == 4 then
				barInfo = self:DarkHand(duration)
			elseif riftSimulacrumCount == 5 then
				interruptingTremorCount = 1
				barInfo = self:InterruptingTremor(duration)
			end
		elseif riftSimulacrumCount == 5 and durationRounded == 8 then -- all adds are up again
			durationEventCount[durationRounded] = (durationEventCount[durationRounded] or 0) + 1
			local count = durationEventCount[durationRounded]
			if count == 1 then
				ravenousAbyssCount = 1
				barInfo = self:RavenousAbyss(duration)
			elseif count == 2 then
				darkHandCount = 1
				barInfo = self:DarkHand(duration)
			end
			if barInfo then
				-- same as initial p1 add casts
				if self:ShouldShowBars() then
					self:CDBar(barInfo.key, duration, barInfo.msg)
				end
				return false
			end
		end

	else -- Intermission
		if durationRounded == 6 then
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
	elseif barInfo == nil and self:ShouldShowBars() then
		self:ErrorForTimelineEvent(eventInfo)
		backupBars[eventInfo.id] = true
		self:SendMessage("BigWigs_StartBar", nil, nil, ("[B] %s"):format(eventInfo.spellName), eventInfo.duration, eventInfo.iconFileID, eventInfo.maxQueueDuration, nil, eventInfo.id, eventInfo.id)

		local state = C_EncounterTimeline.GetEventState(eventInfo.id)
		if state == 1 then -- Enum.EncounterTimelineEventState.Paused = 1
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventInfo.id)
		end
	end
end

function mod:TimersOther(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo

	timelineEventCount = timelineEventCount + 1
	local now = GetTime()
	local timeSinceLastEvent = now - prev
	prev = now

	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 1)

	local stage = self:GetStage()

	-- counts reset on intermission end, show phase message with first new timer
	if stage == 2 and timelineEventCount == 1 then
		if self:ShouldShowBars() then
			self:Message("stages", "cyan", CL.stage:format(stage), false)
			self:PlaySound("stages", "long")
		end

	elseif stage == 3 and timelineEventCount == 1 then
		if self:ShouldShowBars() then
			self:Message("stages", "cyan", CL.stage:format(stage), false)
			self:PlaySound("stages", "long")
		end
	end

	if stage == 1 then
		if durationRounded == 1.5 and timeSinceLastEvent > 1 then
			-- Silverstrike Barrage is always have after rp
			barInfo = self:SilverstrikeBarrage(duration)
		elseif durationRounded == 25 then -- Stage Two
			-- callback sets intermission, resets counts
			barInfo = self:IntermissionEvent(duration)
			barInfo.timer = self:ScheduleTimer(barInfo.onEnd, duration)

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
			barInfo = updateBar(1232467, "GraspOfEmptiness", duration)
		elseif durationRounded == (self:Easy() and 46 or 1.5) then
			barInfo = updateBar(1233865, "NullCorona", duration)
		elseif durationRounded == (self:Easy() and 59.5 or 11.5) then
			barInfo = self:VoidExpulsion(duration)
		elseif durationRounded == 23.5 then
			barInfo = self:SilverstrikeArrow(duration)
		end

	elseif stage == 2 then
		if durationRounded == 1.5 then
			barInfo = self:SilverstrikeBarrage(duration)
		elseif silverstrikeBarrageCount > 1 and durationRounded == 20 then -- Stage Three
			-- callback sets intermission, resets counts
			barInfo = self:IntermissionEvent(duration)
			barInfo.timer = self:ScheduleTimer(barInfo.onEnd, duration)

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
		-- stage start timers
		if durationRounded == 60 or durationRounded == 59 then
			-- callback handles substage
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
				barInfo = updateBar(1239080, "AspectOfTheEnd", duration)
			else
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
	elseif barInfo == nil and self:ShouldShowBars() then
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
		if state == 2 or state == 3 then
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

function mod:IntermissionEvent(duration)
	local stage = self:GetStage()
	self:SetStage(stage + 0.5)

	if self:ShouldShowBars() then
		if self:Mythic() then
			self:Message("stages", "cyan", CL.intermission, false)
		else
			self:Message("stages", "cyan", CL.count:format(CL.intermission, stage), false)
		end
		self:PlaySound("stages", "long")
	end

	return {
		msg = CL.stage:format(stage + 1),
		key = "stages",
		icon = 1280127,
		onEnd = function()
			self:SetStage(self:GetStage() + 0.5)
			self:ResetCounts()
		end,
	}
end

function mod:SilverstrikeBarrage()
	local barText = CL.count:format(L.silverstrike_barrage, silverstrikeBarrageCount)
	silverstrikeBarrageCount = silverstrikeBarrageCount + 1
	return {
		msg = barText,
		key = 1243982,
	}
end

-- Stage 1

function mod:SilverstrikeArrow()
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

function mod:GraspOfEmptiness()
	local barText = CL.count:format(L.grasp_of_emptiness, graspOfEmptinessCount)
	graspOfEmptinessCount = graspOfEmptinessCount + 1
	return {
		msg = barText,
		key = 1232467,
		onFinished = function()
			self:Message(1232467, "yellow", barText)
			-- PA target sound
		end,
	}
end

function mod:VoidExpulsion()
	local barText = CL.count:format(self:SpellName(1255368), voidExpulsionCount)
	voidExpulsionCount = voidExpulsionCount + 1
	return {
		msg = barText,
		key = 1255368,
		onFinished = function()
			self:StopBlizzMessages(1)
			self:Message(1255368, "red", barText)
			self:PlaySound(1255368, "alert") -- big damage
		end,
	}
end

function mod:NullCorona()
	local barText = CL.count:format(CL.heal_absorb, nullCoronaCount)
	nullCoronaCount = nullCoronaCount + 1
	return {
		msg = barText,
		key = 1233865,
		onFinished = function()
			self:Message(1233865, "yellow", barText)
		end,
	}
end

function mod:DarkHand()
	if darkHandCount == 2 and (self:GetStage() == 1 or riftSimulacrumCount == 5) and self:ShouldShowBars() then
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

function mod:InterruptingTremor()
	if interruptingTremorCount == 2 and (self:GetStage() == 1 or riftSimulacrumCount == 5) and self:ShouldShowBars() then
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

function mod:RavenousAbyss()
	if ravenousAbyssCount == 2 and ((self:GetStage() == 1 and not self:Mythic()) or riftSimulacrumCount == 5) and self:ShouldShowBars() then
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

function mod:RangerCaptainsMark()
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

function mod:VoidstalkerSting()
	local barText = L.voidstalker_sting
	stingCount = stingCount + 1
	return {
		msg = barText,
		key = 1237038,
		onEnd = function() -- not used, just for the parser
			self:Message(1237038, "yellow", barText)
		end,
	}
end

function mod:CallOfTheVoid()
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

function mod:CosmicBarrier()
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

function mod:RiftSlash()
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

function mod:RiftSimulacrum()
	local barText = CL.count:format(self:SpellName(1261016), riftSimulacrumCount)
	riftSimulacrumCount = riftSimulacrumCount + 1
	return {
		msg = barText,
		key = 1261016,
		onFinished = function()
			self:Message(1261016, "cyan", barText)
			self:PlaySound(1261016, "info")
		end,
	}
end

-- Stage 3

function mod:DevouringCosmos()
	local barText = CL.count:format(L.devouring_cosmos, devouringCosmosCount)
	devouringCosmosCount = devouringCosmosCount + 1
	return {
		msg = barText,
		key = 1238843,
		onFinished = function()
			durationEventCount = {}
			substage = substage + 1
			stingCount = 1

			self:Message(1238843, "red", barText)
			self:PlaySound(1238843, "long")
			self:StopBlizzMessages(1)
		end,
	}
end

function mod:AspectOfTheEnd()
	local barText = CL.count:format(L.aspect_of_the_end, aspectOfTheEndCount)
	aspectOfTheEndCount = aspectOfTheEndCount + 1
	return {
		msg = barText,
		key = 1239080,
		onFinished = function()
			self:Message(1239080, "orange", barText)
			self:TargetMessageFromBlizzMessage(0.5, 1239080, "blue", CL.you:format(L.aspect_of_the_end))
		end,
	}
end

function mod:CosmicPortal()
	local barText = CL.count:format(CL.big_add, cosmicPortalCount)
	cosmicPortalCount = cosmicPortalCount + 1
	return {
		msg = barText,
		key = 1261339,
		onFinished = function()
			self:Message(1261339, "orange", barText)
			self:PlaySound(1261339, "info")
		end,
	}
end
