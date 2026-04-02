
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Lightblinded Vanguard", 2912, 2737)
if not mod then return end
mod:RegisterEnableMob(240431, 240437, 240438) -- Bellamy, Lightblood, Senn
mod:SetEncounterID(3180)
mod:SetRespawnTime(30)
mod:SetPrivateAuraSounds({
	{1276982, sound = "underyou"}, -- Divine Consecration
	{1248985, 1248994}, -- Execution Sentence (Targetted)
	{1249008, 1249024, sound = "none"}, -- Execution Sentence (Soaked Debuff)
	-- {1249122, 1249123} -- Execution Sentance (Unknown)
	{1272324, sound = "underyou"}, -- Divine Tempest
	{1246736, sound = "alarm"}, -- Judgement (Final Verdict)
	{1251857, sound = "alarm"}, -- Judgement (Shield of the Righteous)
	-- {1251840, sound = "alarm"}, -- Judgment of the Righteous, Used?
	{1248652, sound = "alarm"}, -- Divine Toll
	1246487, -- Avenger's Shield (Targetted)
	{1246502, sound = "alarm"}, -- Avenger's Shield (DoT Debuff)
	{1248721, sound = "alarm"}, -- Tyr's Wrath
	-- {1249130, sound = "info"}, -- Elekk Charge (Buff on the NPC's, lol)
	{1258514, sound = "alarm"}, -- Blinding Light
})
mod:UseCustomTimers(true, true)

--------------------------------------------------------------------------------
-- Locals
--

local pullTime = 0
local activeBars = {}
local backupBars = {}
local durationEventCount = {}
local timelineEventCount = 0
local storedTimelineEvents = {}
local scheduleBackups = nil

local auraWrathCount = 1
local executionCount = 1
local sacredTollCount = 1
local judgementRedCount = 1
local auraDevotionCount = 1
local divineTollCount = 1
local judgementBlueCount = 1
local auraPeaceCount = 1
local tyrsWrathCount = 1
local sacredShieldCount = 1
local zealousSpiritCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.aura_of_wrath = "Wrath" -- Short for Aura of Wrath
	L.execution_sentence = "Executes" -- Short for Execution Sentence
	L.executes_mythic = "Executes + Dodge"
	L.judgement_red = "Judgement [R]" -- Red for the red icon.
	L.aura_of_devotion = "Devotion" -- Short for Aura of Devotion
	L.judgement_blue = "Judgement [B]" -- Blue for the blue icon.
	L.aura_of_peace = "Peace" -- Short for Aura of Peace
	L.tyrs_wrath_mythic = "Absorbs + Executes"
	L.divine_toll_mythic = "Dodge + Absorbs"
	L.zealous_spirit = "Spirit" -- Short for Zealous Spirit

	L.empowered_searing_radiance = "Empowered Searing Radiance"
	L.empowered_searing_radiance_desc = "Show the timer for the empowered Searing Radiance"
	L.empowered_searing_radiance_icon = 1255738

	L.empowered_avengers_shield = "Empowered Avenger's Shield"
	L.empowered_avengers_shield_desc = "Show the timer for the empowered Avenger's Shield"
	L.empowered_avengers_shield_icon = 1246485

	L.empowered_divine_storm = "Empowered Divine Storm"
	L.empowered_divine_storm_desc = "Show the timer for the empowered Divine Storm"
	L.empowered_divine_storm_icon = 1246765
	L.tornadoes = "Tornadoes"

	L.empowered = "[E] %s" -- Empowered version of an ability, %s for the spell name.
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Commander Venel Lightblood
		1248449, -- Aura of Wrath
		1248983, -- Execution Sentence
		{1246765, "OFF"}, -- Divine Storm
		1246749, -- Sacred Toll
		{1246736, "TANK"}, -- Judgement (Red)
		-- General Amias Bellamy
		1246162, -- Aura of Devotion
		1248644, -- Divine Toll
		1246485, -- Avenger's Shield
		{1251857, "TANK"}, -- Judgement (Blue)
		-- War Chaplain Senn
		1248451, -- Aura of Peace
		1248710, -- Tyr's Wrath
		{1255738, "HEALER"}, -- Searing Radiance
		1248674, -- Sacred Shield
		-- Mythic
		{1276243, "OFF"}, -- Zealous Spirit
		"empowered_divine_storm",
		"empowered_avengers_shield",
		{"empowered_searing_radiance", "HEALER"},
	},{
		[1248449] = -33680, -- Commander Venel Lightblood
		[1246162] = -32195, -- General Amias Bellamy
		[1248451] = -33681, -- War Chaplain Senn
		[1276243] = "mythic",
	},{
		[1248449] = L.aura_of_wrath,
		[1248983] = L.execution_sentence,
		["empowered_divine_storm"] = L.tornadoes,
		[1246749] = CL.raid_damage,
		[1246736] = L.judgement_red,
		[1246162] = L.aura_of_devotion,
		[1248644] = CL.dodge,
		[1251857] = L.judgement_blue,
		[1248451] = L.aura_of_peace,
		[1248710] = CL.heal_absorbs,
		[1248674] = CL.shield,
		[1276243] = L.zealous_spirit,
	}
end

function mod:OnBossEnable()
	backupBars = {}
	if self:Mythic() then
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "TimersMythic")
	elseif self:Heroic() then
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "TimersHeroic")
	else
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED", "TimerOther")
	end
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
end

function mod:OnEncounterStart()
	activeBars = {}
	durationEventCount = {}
	timelineEventCount = 0
	storedTimelineEvents = {}
	scheduleBackups = nil

	zealousSpiritCount = 1
	auraWrathCount = 1
	executionCount = 1
	sacredTollCount = 1
	judgementRedCount = 1
	auraDevotionCount = 1
	divineTollCount = 1
	judgementBlueCount = 1
	auraPeaceCount = 1
	tyrsWrathCount = 1
	sacredShieldCount = 1
	pullTime = GetTime()
end

function mod:OnBossDisable()
	for eventID in next, backupBars do
		self:SendMessage("BigWigs_StopBar", nil, nil, eventID)
		backupBars[eventID] = nil
	end
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:StartBackupBar(eventInfo, delayedStart)
	if not eventInfo then return end -- if we started our own bar this will be nil

	self:ErrorForTimelineEvent(eventInfo)
	backupBars[eventInfo.id] = true
	local timer = eventInfo.duration
	if delayedStart then
		timer = timer - (GetTime() - eventInfo.timestamp)
	end
	self:SendMessage("BigWigs_StartBar", nil, nil, ("[B] %s"):format(eventInfo.spellName), timer, eventInfo.iconFileID, eventInfo.maxQueueDuration, nil, eventInfo.id, eventInfo.id)

	local state = C_EncounterTimeline.GetEventState(eventInfo.id)
	if state == 1 then -- Enum.EncounterTimelineEventState.Paused = 1
		self:SendMessage("BigWigs_PauseBar", nil, nil, eventInfo.id)
	end
end

function mod:TimersMythic(_, eventInfo)
	if eventInfo.source ~= 0 then return end
	timelineEventCount = timelineEventCount + 1
	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 2)
	eventInfo.durationRounded = durationRounded
	local barInfo = nil
	if timelineEventCount <= 19 then -- Pull Bars
		if durationRounded == 29 then -- Divine Toll
			barInfo = self:DivineToll(eventInfo)
			barInfo.skipTracking = true
		elseif durationRounded == 26 then -- Aura of Devotion / Judgement (Red)
			-- As these have the same duration, we will check which is the correct one to pass Judgement too onFinished.
			if judgementRedCount <= auraDevotionCount then
				barInfo = self:JudgementRed(eventInfo)
			else
				barInfo = self:AuraOfDevotion(eventInfo)
			end
			barInfo.JudgementOrDevotion = true -- These have the same on pull duration, we link the correct spell on next bar starts
		elseif durationRounded == 66 or durationRounded == 12 then -- Avenger's Shield
			barInfo = self:AvengersShield(eventInfo, durationRounded == 66)
		elseif durationRounded == 4 or durationRounded == 57 or durationRounded == 110 then -- Zealous Spirit
			barInfo = self:ZealousSpirit(eventInfo)
			barInfo.skipTracking = true
		elseif durationRounded == 22 then -- Judgement (Blue)
			barInfo = self:JudgementBlue(eventInfo)
		elseif durationRounded == 132 then -- Aura of Peace
			barInfo = self:AuraOfPeace(eventInfo)
		elseif durationRounded == 30 then -- Sacred Shield
			barInfo = self:SacredShield(eventInfo)
		elseif durationRounded == 135 then -- Tyr's Wrath
			barInfo = self:TyrsWrath(eventInfo)
			barInfo.skipTracking = true
		elseif durationRounded == 7 or durationRounded == 59 then -- Searing Radiance
			barInfo = self:SearingRadiance(eventInfo, durationRounded == 7)
		elseif durationRounded == 20 then -- Sacred Toll
			barInfo = self:SacredToll(eventInfo)
		elseif durationRounded == 15 or durationRounded == 123 then -- Divine Storm
			barInfo = self:DivineStorm(eventInfo, durationRounded == 123)
		elseif durationRounded == 82 then -- Execution Sentence
			barInfo = self:ExecutionSentence(eventInfo)
			barInfo.skipTracking = true
		elseif durationRounded == 79 then -- Aura of Wrath
			barInfo = self:AuraOfWrath(eventInfo)
			barInfo.skipTracking = true
		end
	else
		local combatTime = GetTime() - pullTime
		if combatTime > 179 and combatTime < 181 then
			-- Empowered Searing Radiance sometimes happens here based on spell queueing.
			-- If it is then the DurationRounded can possibly be 159.00. Capture it here to avoid it messing with the modulo rotation below.
			barInfo = self:SearingRadiance(eventInfo, true)
		elseif durationRounded == 159 then -- Some of these get delayed, handle it ourselves.
			-- Zaelous spirit sometimes has a late ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED,
			-- Because of this we cant rely on this event to pass along the next cast.
			-- By capturing all 159.00 durations we avoid any bars starting with the wrong spell.
			durationEventCount[durationRounded] = (durationEventCount[durationRounded] or 0) + 1
			if durationEventCount[durationRounded] % 8 == 1 or durationEventCount[durationRounded] % 8 == 4 or durationEventCount[durationRounded] % 8 == 7 then
				barInfo = self:ZealousSpirit(eventInfo)
			elseif durationEventCount[durationRounded] % 8 == 2 then
				barInfo = self:AuraOfDevotion(eventInfo)
			elseif durationEventCount[durationRounded] % 8 == 3 then
				barInfo = self:DivineToll(eventInfo)
			elseif durationEventCount[durationRounded] % 8 == 5 then
				barInfo = self:AuraOfWrath(eventInfo)
			elseif durationEventCount[durationRounded] % 8 == 6 then
				barInfo = self:ExecutionSentence(eventInfo)
			elseif durationEventCount[durationRounded] % 8 == 0 then
				barInfo = self:TyrsWrath(eventInfo)
			end
			barInfo.skipTracking = true
		else
			if combatTime > 107 and combatTime < 114 then
				-- At this point these 3 abilities can happen with a delayed ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED
				if durationRounded == 18 then
					barInfo = self:SacredToll(eventInfo)
				elseif durationRounded == 36 then
					barInfo = self:JudgementBlue(eventInfo)
				elseif durationRounded > 50 then
					barInfo = self:SearingRadiance(eventInfo, true)
				end
			else
				eventInfo.timestamp = GetTime()
				table.insert(storedTimelineEvents, eventInfo)
				if scheduleBackups then
					self:CancelTimer(scheduleBackups)
					scheduleBackups = nil
				end
				scheduleBackups = self:ScheduleTimer(function ()
					for _, event in next, storedTimelineEvents do
						if self:ShouldShowBars() and not self:IsWiping() then
							self:StartBackupBar(event, true)
						end
					end
					table.wipe(storedTimelineEvents)
				end, 0.5)
				return
			end
		end
	end
	if barInfo then
		activeBars[eventInfo.id] = barInfo
	elseif self:ShouldShowBars() and not self:IsWiping() then
		self:StartBackupBar(eventInfo)
	end
end

function mod:TimersHeroic(_, eventInfo)
	if eventInfo.source ~= 0 then return end
	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 0)
	eventInfo.durationRounded = durationRounded
	timelineEventCount = timelineEventCount + 1
	local barInfo = nil
	if timelineEventCount <= 12 then -- Pull Bars
		if durationRounded == 10 then -- Sacred Toll
			barInfo = self:SacredToll(eventInfo)
		elseif durationRounded == 15 then -- Avenger's Shield
			barInfo = self:AvengersShield(eventInfo)
		elseif durationRounded == 17 then -- Sacred Shield
			barInfo = self:SacredShield(eventInfo)
		elseif durationRounded == 18 then -- Divine Storm
			barInfo = self:DivineStorm(eventInfo)
		elseif durationRounded == 26 then -- Judgement Blue
			barInfo = self:JudgementBlue(eventInfo)
		elseif durationRounded == 30 and not self:IsWiping() then -- Judgement Red
			barInfo = self:JudgementRed(eventInfo)
		elseif durationRounded == 35 then -- Aura of Devotion
			barInfo = self:AuraOfDevotion(eventInfo)
		elseif durationRounded == 38 then -- Divine Toll
			barInfo = self:DivineToll(eventInfo)
		elseif durationRounded == 47 then -- Searing Radiance
			barInfo = self:SearingRadiance(eventInfo)
		elseif durationRounded == 83 then -- Aura of Wrath
			barInfo = self:AuraOfWrath(eventInfo)
		elseif durationRounded == 86 then -- Execution Sentence
			barInfo = self:ExecutionSentence(eventInfo)
		elseif durationRounded == 131 then -- Aura of Peace
			barInfo = self:AuraOfPeace(eventInfo)
		end
	else
		eventInfo.timestamp = GetTime()
		table.insert(storedTimelineEvents, eventInfo)
		if scheduleBackups then
			self:CancelTimer(scheduleBackups)
			scheduleBackups = nil
		end
		scheduleBackups = self:ScheduleTimer(function ()
			for _, event in next, storedTimelineEvents do
				if self:ShouldShowBars() and not self:IsWiping() then
					self:StartBackupBar(event, true)
				end
			end
			table.wipe(storedTimelineEvents)
		end, 0.5)
		return
	end
	if barInfo then
		activeBars[eventInfo.id] = barInfo
	elseif self:ShouldShowBars() and not self:IsWiping() then
		self:StartBackupBar(eventInfo)
	end
end

function mod:TimerOther(_, eventInfo)
	if eventInfo.source ~= 0 then return end
	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 0)
	eventInfo.durationRounded = durationRounded
	timelineEventCount = timelineEventCount + 1
	local barInfo = nil
	if timelineEventCount <= 10 then -- Pull Bars
		if durationRounded == 10 then -- Avenger's Shield
			barInfo = self:AvengersShield(eventInfo)
		elseif durationRounded == 17 then -- Sacred Shield
			barInfo = self:SacredShield(eventInfo)
		elseif durationRounded == 23 then -- Sacred Toll
			barInfo = self:SacredToll(eventInfo)
		elseif durationRounded == 26 then -- Judgement Blue
			barInfo = self:JudgementBlue(eventInfo)
		elseif durationRounded == 30 and not self:IsWiping() then -- Judgement Red
			barInfo = self:JudgementRed(eventInfo)
		elseif durationRounded == 35 then -- Aura of Devotion
			barInfo = self:AuraOfDevotion(eventInfo)
		elseif durationRounded == 38 then -- Divine Toll
			barInfo = self:DivineToll(eventInfo)
		elseif durationRounded == 83 then -- Aura of Wrath
			barInfo = self:AuraOfWrath(eventInfo)
		elseif durationRounded == 86 then -- Execution Sentence
			barInfo = self:ExecutionSentence(eventInfo)
		elseif durationRounded == 131 then -- Aura of Peace
			barInfo = self:AuraOfPeace(eventInfo)
		end
	else
		eventInfo.timestamp = GetTime()
		table.insert(storedTimelineEvents, eventInfo)
		if scheduleBackups then
			self:CancelTimer(scheduleBackups)
			scheduleBackups = nil
		end
		scheduleBackups = self:ScheduleTimer(function ()
			for _, event in next, storedTimelineEvents do
				if self:ShouldShowBars() and not self:IsWiping() then
					self:StartBackupBar(event, true)
				end
			end
			table.wipe(storedTimelineEvents)
		end, 0.5)
		return
	end
	if barInfo then
		activeBars[eventInfo.id] = barInfo
	elseif self:ShouldShowBars() and not self:IsWiping() then
		self:StartBackupBar(eventInfo)
	end
end

function mod:ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED(_, eventID)
	local barInfo = activeBars[eventID]
	if barInfo then
		local newState = C_EncounterTimeline.GetEventState(eventID)
		if newState == 2 or newState == 3 then -- Finished or Canceled
			self:StopBar(barInfo.msg)
			if newState == 2 then -- Finished
				if barInfo.onFinished then
					barInfo.onFinished()
				end
				if not barInfo.skipTracking then -- These are started with the intent to not re-start from their Finished states.
					local storedEventInfo = table.remove(storedTimelineEvents, 1)
					if storedEventInfo then
						if barInfo.JudgementOrDevotion then -- Decide which it is based on the duration
							if storedEventInfo.durationRounded < 50 then -- We already start the Devotion bar with a duration check in ADDED.
								barInfo = self:JudgementRed(storedEventInfo)
								activeBars[storedEventInfo.id] = barInfo
							end
						else
							activeBars[storedEventInfo.id] = barInfo.this(self, storedEventInfo, barInfo.empowered)
						end
					end
				end
			elseif newState == 3 then -- Canceled
				if barInfo.onCanceled then
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

function mod:JudgementBlue(eventInfo)
	local barText = CL.count:format(L.judgement_blue, judgementBlueCount)
	if self:ShouldShowBars() then
		self:CDBar(1251857, eventInfo.duration, barText, nil, eventInfo.id)
	end
	judgementBlueCount = judgementBlueCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1251857, "purple", barText)
				self:PlaySound(1251857, "info")
			end
		end,
		this = self.JudgementBlue
	}
end

function mod:JudgementRed(eventInfo)
	local barText = CL.count:format(L.judgement_red, judgementRedCount)
	if self:ShouldShowBars() then
		self:CDBar(1246736, eventInfo.duration, barText, nil, eventInfo.id)
	end
	judgementRedCount = judgementRedCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1246736, "purple", barText)
				self:PlaySound(1246736, "info")
			end
		end,
		this = self.JudgementRed
	}
end

function mod:SacredToll(eventInfo)
	local barText = CL.count:format(CL.raid_damage, sacredTollCount)
	if self:ShouldShowBars() then
		self:CDBar(1246749, eventInfo.duration, barText, nil, eventInfo.id)
	end
	sacredTollCount = sacredTollCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1246749, "yellow", barText)
				self:PlaySound(1246749, "warning") -- Deadly in Mythic
			end
		end,
		this = self.SacredToll
	}
end

function mod:AvengersShield(eventInfo, empowered)
	local barText = self:SpellName(1246485)
	if empowered then
		barText = L.empowered:format(self:SpellName(1246485))
	end
	if self:ShouldShowBars() then
		if empowered then
			self:CDBar("empowered_avengers_shield", eventInfo.duration, barText, 1246485, eventInfo.id)
		else
			self:CDBar(1246485, eventInfo.duration, barText, 1246485, eventInfo.id)
		end
	end
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				if empowered then
					self:Message("empowered_avengers_shield", "red", barText, 1246485)
				else
					self:Message(1246485, "yellow", barText)
				end
				-- Sound from PA's
			end
		end,
		this = self.AvengersShield,
		empowered = empowered
	}
end

function mod:DivineStorm(eventInfo, empowered)
	local barText = self:SpellName(1246765)
	if empowered then
		barText = L.empowered:format(L.tornadoes)
	end
	if self:ShouldShowBars() then
		if empowered then
			self:CDBar("empowered_divine_storm", eventInfo.duration, barText, 1246765, eventInfo.id)
		else
			self:CDBar(1246765, eventInfo.duration, barText, 1246765, eventInfo.id)
		end
	end
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() and empowered then
				self:Message("empowered_divine_storm", "red", barText, 1246765)
				self:PlaySound("empowered_divine_storm", "alarm")
			end
		end,
		this = self.DivineStorm,
		empowered = empowered
	}
end

function mod:SearingRadiance(eventInfo, empowered)
	local barText = self:SpellName(1255738)
	if empowered then
		barText = L.empowered:format(self:SpellName(1255738))
	end
	if self:ShouldShowBars() then
		if empowered then
			self:CDBar("empowered_searing_radiance", eventInfo.duration, barText, 1255738, eventInfo.id)
		else
			self:CDBar(1255738, eventInfo.duration, barText, 1255738, eventInfo.id)
		end
	end
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				if empowered then
					self:Message("empowered_searing_radiance", "orange", barText, 1255738)
					self:PlaySound("empowered_searing_radiance", "alert")
				else
					self:Message(1255738, "orange", barText)
					self:PlaySound(1255738, "alert")
				end
			end
		end,
		this = self.SearingRadiance,
		empowered = empowered
	}
end

function mod:SacredShield(eventInfo)
	local barText = CL.count:format(CL.shield, sacredShieldCount)
	if self:ShouldShowBars() then
		self:CDBar(1248674, eventInfo.duration, barText, nil, eventInfo.id)
	end
	sacredShieldCount = sacredShieldCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1248674, "yellow", CL.casting:format(barText))
				self:PlaySound(1248674, "alert") -- break shield
			end
		end,
		this = self.SacredShield
	}
end

function mod:ZealousSpirit(eventInfo)
	local barCount = zealousSpiritCount
	if zealousSpiritCount <= 3 then -- it spawns 3 timers on pull (lol)
		barCount = eventInfo.durationRounded == 4 and 1 or eventInfo.durationRounded == 57 and 2 or 3
	end
	local barText = CL.count:format(L.zealous_spirit, barCount)
	if self:ShouldShowBars() then
		self:CDBar(1276243, eventInfo.duration, barText, nil, eventInfo.id)
	end
	zealousSpiritCount = zealousSpiritCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1276243, "cyan", barText)
				self:PlaySound(1276243, "info") -- new empower
			end
		end,
		this = self.ZealousSpirit
	}
end

function mod:AuraOfWrath(eventInfo)
	local barText = CL.count:format(L.aura_of_wrath, auraWrathCount)
	if self:ShouldShowBars() then
		self:CDBar(1248449, eventInfo.duration, barText, nil, eventInfo.id)
	end
	auraWrathCount = auraWrathCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1248449, "cyan", barText)
				self:PlaySound(1248449, "long") -- Aura enabled
				self:StopBlizzMessages(0.5)
			end
		end,
		this = self.AuraOfWrath
	}
end

function mod:ExecutionSentence(eventInfo)
	local spellName = self:Mythic() and L.executes_mythic or L.execution_sentence
	local barText = CL.count:format(spellName, executionCount)
	if self:ShouldShowBars() then
		self:CDBar(1248983, eventInfo.duration, barText, nil, eventInfo.id)
	end
	executionCount = executionCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1248983, "red", barText)
				-- Sound on PA's
			end
		end,
		this = self.ExecutionSentence
	}
end

function mod:AuraOfDevotion(eventInfo)
	local barText = CL.count:format(L.aura_of_devotion, auraDevotionCount)
	if self:ShouldShowBars() then
		self:CDBar(1246162, eventInfo.duration, barText, nil, eventInfo.id)
	end
	auraDevotionCount = auraDevotionCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1246162, "cyan", barText)
				self:PlaySound(1246162, "long") -- Aura enabled
				self:StopBlizzMessages(0.5)
			end
		end,
		this = self.AuraOfDevotion
	}
end

function mod:DivineToll(eventInfo)
	local spellName = self:Mythic() and L.divine_toll_mythic or CL.dodge
	local barText = CL.count:format(spellName, divineTollCount)
	if self:ShouldShowBars() then
		self:CDBar(1248644, eventInfo.duration, barText, nil, eventInfo.id)
	end
	divineTollCount = divineTollCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1248644, "orange", barText)
				self:PlaySound(1248644, "warning") -- Dodge shields
			end
		end,
		this = self.DivineToll
	}
end

function mod:AuraOfPeace(eventInfo)
	local barText = CL.count:format(L.aura_of_peace, auraPeaceCount)
	if self:ShouldShowBars() then
		self:CDBar(1248451, eventInfo.duration, barText, nil, eventInfo.id)
	end
	auraPeaceCount = auraPeaceCount + 1
	local tyrsCD = eventInfo.duration + 5  -- always 5 seconds after Aura of Peace
	if not self:Mythic() then
		-- Tyr's Wrath is bugged and missing an event/timers, start it here for now.
		activeBars[-eventInfo.id] = self:TyrsWrath({
			duration = tyrsCD,
		})
	end
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1248451, "cyan", barText)
				self:PlaySound(1248451, "long")
				self:StopBlizzMessages(0.5)
			end
			if not self:Mythic() then
				if self:ShouldShowBars() then
					-- as this cast can be delayed, update the remaining time and cancel it in 5s
					self:CDBar(1248710, {5, tyrsCD}, CL.count:format(CL.heal_absorbs, tyrsWrathCount - 1))
				end
				self:ScheduleTimer(function()
					self:ENCOUNTER_TIMELINE_EVENT_REMOVED(nil, -eventInfo.id)
				end, 0.5)
			end
		end,
		onCanceled = function()
			if not self:Mythic() then
				-- if the event is canceled, remove the linked Tyr's Wrath timer
				self:ENCOUNTER_TIMELINE_EVENT_REMOVED(nil, -eventInfo.id)
			end
		end,
		this = self.AuraOfPeace
	}
end

function mod:TyrsWrath(eventInfo)
	local spellName = self:Mythic() and L.tyrs_wrath_mythic or CL.heal_absorbs
	local barText = CL.count:format(spellName, tyrsWrathCount)
	if self:ShouldShowBars() then
		self:CDBar(1248710, eventInfo.duration, barText, nil, eventInfo.id)
	end
	tyrsWrathCount = tyrsWrathCount + 1
	return {
		msg = barText,
		onFinished = function()
			if self:ShouldShowBars() then
				self:Message(1248710, "orange", barText)
				-- Sound on PA's
			end
		end,
		this = self.TyrsWrath
	}
end
