
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
local spellCount = {}

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
	local timersHeroic = {
		[1299960] = { [1] = { [43] = 42 } }, -- Toxic Deluge
		[1283489] = { [1] = { [43] = 85 } }, -- Guillotine
		[1299680] = { [1] = { [17] = 31 } }, -- Sever
		[1282281] = { [1] = { [35] = 50 } }, -- Venomfang
		[1283832] = { [1] = { [12] = 85 } }, -- Axegrinder

		[1286441] = { [2] = { [33] = 52 } }, -- Spiritcackle
		[1286918] = { [2] = { [70] = 85 } }, -- Eternal Nightfall
		[1289900] = { [2] = { [34] = 51 } }, -- Dreadmarch
		[1286895] = { [2] = { [38] = 47 } }, -- Gloombomb
		[1286573] = { [2] = { [31] = 54 } }, -- Soul Sever
	}
	local timersNormal = {
		[1299960] = { [1] = { [42] = 43 } }, -- Toxic Deluge
		[1283489] = { [1] = { [42] = 85 } }, -- Guillotine
		[1299680] = { [1] = { [16] = 31 } }, -- Sever
		[1282281] = { [1] = { [35] = 50 } }, -- Venomfang
		[1283832] = { [1] = { [12] = 85 } }, -- Axegrinder

		[1286918] = { [2] = { [70] = 85 } }, -- Eternal Nightfall
		[1289900] = { [2] = { [34] = 51 } }, -- Dreadmarch
		[1286895] = { [2] = { [40] = 45 } }, -- Gloombomb
		[1286573] = { [2] = { [33] = 52 } }, -- Soul Sever
	}
	function gapTimer(spellId, duration)
		local timers = mod:Mythic() and timersMythic or mod:Heroic() and timersHeroic or mod:Normal() and timersNormal
		if timers and timers[spellId] then
			if duration == true then
				return true
			end
			local stageTimers = timers[spellId][mod:GetStage()]
			return stageTimers and stageTimers[duration]
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
	[1285911] = {CL.you:format(mod:SpellName(41294)), original = CL.you:format(mod:SpellName(1285911))}, -- Unnerving Fixation (Fixate)
	[1286573] = {CL.tank_frontal}, -- Soul Sever
	[1286918] = {1286918}, -- Eternal Nightfall
	[1286441] = {CL.adds, CL.add, notes = {CL.mythicOnlyNote, CL.otherDifficultiesNote}}, -- Spiritcackle
	[1286895] = {1286895, CL.you:format(mod:SpellName(1286895)), notes = {CL.generalNote, CL.messageOnYouNote}}, -- Gloombomb

	[1298381] = {CL.pools}, -- Defilement of the Coiled Altar
	[1299266] = {1283489}, -- Grim Guillotine (Guillotine)
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
	{1286901, 1310881, soundOnApplied = "warning", duration = 5}, -- Gloombomb
	{1286837, soundOnApplied = "alarm", soundOnAppliedDose = "none", duration = 11}, -- Gravebound
	{1299266, soundOnApplied = "warning", duration = 5, note = "Targeted"}, -- Grim Guillotine
	-- Zul'jan
	{1283345, soundOnApplied = "none", soundOnAppliedDose = "none", note = "Tank stacks", header = mod:SpellName(-35063)}, -- Twinfang Toxin
	{1283290, soundOnApplied = "none"}, -- Noxious Ground
	{1299838, soundOnApplied = "none", soundOnAppliedDose = "none", note = "DoT"}, -- Venom Rupture
	{1307425, soundOnApplied = "none", soundOnAppliedDose = "none", note = "Soaked"}, -- Guillotined
	{1301690, soundOnApplied = "none", soundOnAppliedDose = "none", note = "Tank cone"}, -- Sever
	{1306906, soundOnApplied = "none", duration = 14, note = "DoT"}, -- Venomfang
	{1285017, soundOnApplied = "none", note = "DoT"}, -- Axegrinder
	-- Malacrass
	{1297445, soundOnApplied = "none", note = "Possessed", header = mod:SpellName(-35062)}, -- Dreadmarch
	{1310744, soundOnApplied = "none", duration = 5, mythic = true}, -- Malevolent Resonance
	{1307959, soundOnApplied = "none", soundOnAppliedDose = "none", note = "Tank cone"}, -- Soul Sever
	{1286918, soundOnApplied = "none", duration = 15}, -- Eternal Nightfall
	{1286947, soundOnApplied = "none"}, -- Suffocating Darkness
	{1286399, soundOnApplied = "alarm", duration = 5, note = "Kick fail"}, -- Wail of Terror
	-- intermission
	{1300665, soundOnApplied = "none", soundOnAppliedDose = "none", mythic = true, header = CL.intermission}, -- Spirit Erasure
	-- p3
	{1298594, soundOnApplied = "none", header = CL.stage:format(3)}, -- Defilement of the Coiled Altar
	{1298795, soundOnApplied = "none", soundOnAppliedDose = "none", note = "Tank stacks"}, -- Corrupted Toxin
	{1298591, soundOnApplied = "none"}, -- Defiled Groound
	{1307652, soundOnApplied = "none", soundOnAppliedDose = "none", note = "Soaked"}, -- Guillotined
	{1307403, soundOnApplied = "none", soundOnAppliedDose = "none", note = "Tank cone"}, -- Blighted Sever
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
		{1289900, "ME_ONLY_EMPHASIZE"}, -- Dreadmarch
		{1285911, "EMPHASIZE"}, -- Unnerving Fixation
		1286573, -- Soul Sever
		1286918, -- Eternal Nightfall
		1286441, -- Spiritcackle
		{1286895, "ME_ONLY_EMPHASIZE"}, -- Gloombomb

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
			-- Spiritcackle
			-- Gloombomb
	}, {
		{
			tabName = self:SpellName(-35584), -- Stage 1
			{ "stages", 1282487, 1299960, 1283489, 1299680, 1282281, 1283832 },
		},
		{
			tabName = self:SpellName(-35599), -- Stage 2
			 {"stages", 1289900, 1285911, 1286573, 1286918, 1286441, 1286895 },
		},
		{
			tabName = self:SpellName(-35403), -- Stage 3
			{ "stages",
				1298381, 1299960, 1299266, 1307279,
				1289900, 1285911, 1286918, 1286441, 1286895 },
		},
		-- [1287722] = -35533, -- Intermission
		[1282487] = -35063, -- Zul'jan
		[1298381] = -35063, -- Zul'jan
		[1289900] = -35062, -- Hex Lord Malacrass
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
	self:ResetCounts()
	warnStageThree = false

	-- Starts the encounter by casting Fangs of the Coiled Altar
	self:Message(1282487, "red")

	-- self:RegisterEvent("ENCOUNTER_WARNING")
	self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", nil, "boss2")
end

 function mod:ResetCounts()
	durationEventCount = {}
	spellCount = {
		[1299960] = 1, -- Toxic Deluge
		[1283832] = 1, -- Axegrinder
		[1282281] = 1, -- Venomfang
		[1283489] = 1, -- Guillotine
		[1299680] = 1, -- Sever
		[1282487] = 1, -- Fangs of the Coiled Altar

		[1289900] = 1, -- Dreadmarch
		[1286918] = 1, -- Eternal Nightfall
		[1286441] = 1, -- Spiritcackle
		[1286895] = 1, -- Gloombomb
		[1286573] = 1, -- Soul Sever

		[1298381] = 1, -- Defilement of the Coiled Altar
		[1299266] = 1, -- Grim Guillotine
		[1307279] = 1, -- Blighted Sever
	}
 end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:MythicTimeline(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo

	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	if warnStageThree then
		warnStageThree = false
		-- Starts with casting Defilement of the Coiled Altar
		self:Message(1298381, "red")
		self:PlaySound(1298381, "alarm")
	end

	local stage = self:GetStage()
	if stage == 1 then
		if rounded == 2 then
			barInfo = self:ToxicDeluge()
		elseif rounded == 12 then
			barInfo = self:Axegrinder()
		elseif rounded == 28 or rounded == 35 then
			barInfo = self:Venomfang()
		elseif rounded == 43 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] % 2 == 1 then
				barInfo = self:Guillotine()
			else
				barInfo = self:ToxicDeluge()
			end
		elseif rounded == 20 or rounded == 17 then
			barInfo = self:Sever()
		elseif rounded == 85 or rounded == 84 then
			barInfo = self:FangsOfTheCoiledAltar()
		end

	elseif stage == 2 then
		if rounded == 13 or rounded == 33 then
			barInfo = self:Spiritcackle()
		elseif rounded == 70 then
			barInfo = self:EternalNightfall()
		elseif rounded == 6 then -- 5.5
			barInfo = self:Dreadmarch(duration)
		elseif rounded == 18 or rounded == 37 then
			barInfo = self:Gloombomb()
		elseif rounded == 31 then
			barInfo = self:SoulSever()
		elseif rounded == 34 then
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] % 2 == 1 then
				barInfo = self:SoulSever()
			else
				barInfo = self:Dreadmarch(duration)
			end
		end

	elseif stage == 3 then
		barInfo = nil -- no p3 timers
	end

	self:HandleBar(barInfo, eventInfo)
end

function mod:OtherTimeline(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo

	local duration = eventInfo.duration
	local rounded = self:RoundNumber(duration, 0)

	if warnStageThree then
		warnStageThree = false
		-- Starts with casting Defilement of the Coiled Altar
		self:Message(1298381, "red")
		self:PlaySound(1298381, "alarm")
	end

	local stage = self:GetStage()
	if stage == 1 then
		if rounded == 2 then
			barInfo = self:ToxicDeluge()
		elseif rounded == 12 then
			barInfo = self:Axegrinder()
		elseif rounded == 28 or rounded == 35 then
			barInfo = self:Venomfang()
		elseif rounded == (self:Easy() and 42 or 43) then -- normal/heroic
			durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
			if durationEventCount[rounded] % 2 == 1 then
				barInfo = self:Guillotine()
			else
				barInfo = self:ToxicDeluge()
			end
		elseif rounded == 20 or rounded == 17 or rounded == 21 or rounded == 16 then
			barInfo = self:Sever()
		elseif rounded == 85 then
			barInfo = self:FangsOfTheCoiledAltar()
		end

	elseif stage == 2 then
		if self:Heroic() then
			if rounded == 13 or rounded == 33 then
				barInfo = self:Spiritcackle()
			elseif rounded == 70 then
				barInfo = self:EternalNightfall()
			elseif rounded == 6 then -- 5.5
				barInfo = self:Dreadmarch(duration)
			elseif rounded == 22 or rounded == 38 then
				barInfo = self:Gloombomb()
			elseif rounded == 31 then
				barInfo = self:SoulSever()
			elseif rounded == 34 then
				durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
				if durationEventCount[rounded] % 2 == 1 then
					barInfo = self:SoulSever()
				else
					barInfo = self:Dreadmarch(duration)
				end
			end
		else
			if rounded == 70 then
				barInfo = self:EternalNightfall()
			elseif rounded == 6 or rounded == 34 then -- 5.5
				barInfo = self:Dreadmarch(duration)
			elseif rounded == 20 or rounded == 40 then
				barInfo = self:Gloombomb()
			elseif rounded == 32 or rounded == 33 then
				barInfo = self:SoulSever()
			end
		end

	elseif stage == 3 then
		local rounded1 = self:RoundNumber(duration, 1)
		if self:Heroic() then
			if rounded == 61 or rounded == 101 or rounded == 44 or rounded == 108 then -- 61.49, 101.15, 43.68, 108.05
				barInfo = self:Dreadmarch(duration)
			elseif rounded == 39 or rounded == 100 then
				barInfo = self:EternalNightfall()
			elseif rounded == 26 or rounded == 51 or rounded == 67 or rounded == 86 then
				barInfo = self:Gloombomb()
			elseif rounded == 2 or rounded == 47 or rounded == 57 or rounded == 43 or rounded == 62 then
				barInfo = self:ToxicDeluge()
			elseif rounded == 32 or rounded == 34 or rounded == 38 then
				barInfo = self:BlightedSever()
			elseif rounded == 17 or rounded == 170 then
				barInfo = self:GrimGuillotine()
			elseif rounded == 106 or rounded == 105 then
				barInfo = self:DefilementOfTheCoiledAltar()
			elseif rounded == 33 then
				durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
				local count = durationEventCount[rounded]
				if count == 1 then
					barInfo = self:BlightedSever()
				elseif count == 2 then
					barInfo = self:Gloombomb()
				elseif count == 3 then
					barInfo = self:BlightedSever()
				end
			elseif rounded == 60 then -- 59.77
				durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
				local count = durationEventCount[rounded]
				if count == 1 then
					barInfo = self:DefilementOfTheCoiledAltar()
				elseif count == 2 then
					barInfo = self:ToxicDeluge()
				end
			end
		else
			if rounded == 87 or rounded == 66 then
				barInfo = self:EternalNightfall()
			elseif rounded1 == 53.5 or rounded == 88 or rounded == 38 or rounded == 49 or rounded == 43 then -- 53.5
				barInfo = self:Dreadmarch(duration)
			elseif rounded == 2 or rounded == 41 or rounded == 50 or rounded == 37 or rounded == 54 then
				barInfo = self:ToxicDeluge()
			elseif rounded == 29 or rounded == 28 or rounded == 30 or rounded == 33 then
				barInfo = self:BlightedSever()
			elseif rounded == 92 or rounded == 91 then
				barInfo = self:DefilementOfTheCoiledAltar()
			elseif rounded == 34 then
				durationEventCount[rounded] = (durationEventCount[rounded] or 0) + 1
				local count = durationEventCount[rounded]
				if count == 1 then
					barInfo = self:EternalNightfall()
				elseif count == 2 then
					barInfo = self:BlightedSever()
				end
			end
		end
	end

	self:HandleBar(barInfo, eventInfo)
end

function mod:HandleBar(barInfo, eventInfo)
	if barInfo and gapTimer(barInfo.key, true) then
		if not barInfo.skipGapTimer then
			-- blizzard fires sets of bars on an interval, bridge the gap with a normal bar
			barInfo.gapTimer = gapTimer(barInfo.key, self:RoundNumber(eventInfo.duration, 0))
		end
		-- if the normal bar is running, use the existing duration for max time
		local remaining, total = self:BarTimeLeft(barInfo.msg)
		barInfo.duration = remaining > 0 and { eventInfo.duration, total } or nil
	end

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

	if barInfo and barInfo.key == 1282487 and state == 3 then -- Fangs of the Coiled Altar (Canceled)
		-- Normally canceled after the next set of timers are added
		self:StopBar(barInfo.msg)
		if spellCount[1283832] > barInfo.count then -- 1283832 = Axegrinder, a once per Fangs ability
			-- next bar started, so it finished
			barInfo:onFinished()
		else
			-- actually ended early, so trigger next phase
			self:StartPhaseTwo()
		end
		activeBars[eventID] = nil
		barInfo = nil
	end

	if barInfo and barInfo.gapTimer and state == 2 then -- Finished
		self:Bar(barInfo.key, barInfo.gapTimer, CL.count:format(self:GetRename(barInfo.key, barInfo.renamePosition), spellCount[barInfo.key]))
	end

	if barInfo and not barInfo.skipState then
		if state == 2 then -- Finished
			activeBars[eventID] = nil
			self:StopBar(barInfo.msg)
			if barInfo.onFinished and self:ShouldShowBars() then
				barInfo:onFinished()
			end
		elseif state == 3 then -- Canceled
			activeBars[eventID] = nil
			self:StopBar(barInfo.msg)
			if barInfo.onCanceled and self:ShouldShowBars() then
				barInfo:onCanceled()
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

-- function mod:ENCOUNTER_WARNING(_, info)
-- 	if self:IsStoppingBlizzMessages() or self:GetStage() == 1 then return end

-- 	if info.severity == 1 and info.duration == 4 then
-- 		-- Dreadmarch and Unnerving Fixation are 4s, but Dreadmarch should be caught
-- 		self:UnnervingFixationMessage()
-- 	end
-- end

function mod:StartPhaseTwo()
	-- Fangs was canceled early
	if self:GetStage() == 1 then
		self:StopBar(CL.count:format(self:GetRename(1299960), spellCount[1299960])) -- Toxic Deluge
		self:StopBar(CL.count:format(self:GetRename(1283832), spellCount[1283832])) -- Axegrinder
		self:StopBar(CL.count:format(self:GetRename(1282281), spellCount[1282281])) -- Venomfang
		self:StopBar(CL.count:format(self:GetRename(1283489), spellCount[1283489])) -- Guillotine
		self:StopBar(CL.count:format(self:GetRename(1299680), spellCount[1299680])) -- Sever
		self:StopBar(CL.count:format(self:GetRename(1282487), spellCount[1282487])) -- Fangs of the Coiled Altar

		self:SetStage(2)
		self:ResetCounts()

		self:Message("stages", "cyan", self:GetRename("stages", 2), false)
		self:PlaySound("stages", "long")
	end
end

function mod:StartIntermission()
	if self:GetStage() == 2 then
		self:UnregisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "boss2")
		self:StopBar(CL.count:format(self:GetRename(1286441, self:Mythic() and 1 or 2), spellCount[1286441]))
		self:StopBar(CL.count:format(self:GetRename(1286918), spellCount[1286918]))
		self:StopBar(CL.count:format(self:GetRename(1289900), spellCount[1289900]))
		self:StopBar(CL.count:format(self:GetRename(1286895), spellCount[1286895]))
		self:StopBar(CL.count:format(self:GetRename(1286573), spellCount[1286573]))

		self:SetStage(2.5)
		self:ResetCounts()

		self:Message("stages", "cyan", self:GetRename("stages", 4), false) -- Intermission
		self:PlaySound("stages", "long")
	end
end

function mod:UNIT_SPELLCAST_CHANNEL_STOP()
	if self:GetStage() == 2.5 then -- Soulbinding
		warnStageThree = true
		self:SetStage(3)

		self:Message("stages", "cyan", self:GetRename("stages", 3), false)
		self:PlaySound("stages", "long")
	end
end

-- Stage 1

function mod:ToxicDeluge()
	local barText = CL.count:format(self:GetRename(1299960), spellCount[1299960])
	spellCount[1299960] = spellCount[1299960] + 1

	return {
		msg = barText,
		key = 1299960,
		onFinished = function()
			self:StopBlizzMessages(2) -- The crucible begins to spew a [Toxic Deluge]!
			self:Message(1299960, "yellow", barText)
			self:PlaySound(1299960, "info")
		end,
	}
end

function mod:Axegrinder()
	local barText = CL.count:format(self:GetRename(1283832), spellCount[1283832])
	spellCount[1283832] = spellCount[1283832] + 1

	return {
		msg = barText,
		key = 1283832,
		onFinished = function()
			self:Message(1283832, "yellow", barText)
			self:PlaySound(1283832, "alarm")
		end,
	}
end

function mod:Venomfang()
	local barText = CL.count:format(self:GetRename(1282281), spellCount[1282281])
	spellCount[1282281] = spellCount[1282281] + 1

	return {
		msg = barText,
		key = 1282281,
		onFinished = function()
			self:Message(1282281, "yellow", barText)
			self:PlaySound(1282281, "alarm")
		end,
	}
end

function mod:Guillotine()
	local barText = CL.count:format(self:GetRename(1283489), spellCount[1283489])
	spellCount[1283489] = spellCount[1283489] + 1

	return {
		msg = barText,
		key = 1283489,
		onFinished = function()
			self:StopBlizzMessages(1) -- Zul'jan begins to cast [Guillotine]!
			self:Message(1283489, "orange", barText)
			self:PlaySound(1283489, "alert")
		end,
	}
end

function mod:Sever()
	local barText = CL.count:format(self:GetRename(1299680), spellCount[1299680])
	spellCount[1299680] = spellCount[1299680] + 1

	return {
		msg = barText,
		key = 1299680,
		skipGapTimer = spellCount[1299680] % 4 ~= 1, -- 4 casts per cycle, only gap after the last
		onFinished = function()
			self:Message(1299680, "purple", barText)
			self:PlaySound(1299680, "alert")
		end,
	}
end

function mod:FangsOfTheCoiledAltar()
	local barText = CL.count:format(self:GetRename(1282487), spellCount[1282487])
	spellCount[1282487] = spellCount[1282487] + 1

	return {
		msg = barText,
		key = 1282487,
		count = spellCount[1282487],
		onFinished = function()
			self:Message(1282487, "red", barText)
			self:PlaySound(1282487, "alarm")
		end,
	}
end

-- Stage 2

function mod:Spiritcackle()
	local position = self:Mythic() and 1 or 2 -- multiple on mythic
	local barText = CL.count:format(self:GetRename(1286441, position), spellCount[1286441])
	spellCount[1286441] = spellCount[1286441] + 1

	return {
		msg = barText,
		key = 1286441,
		renamePosition = position,
		onFinished = function()
			self:Message(1286441, "cyan", barText)
			self:PlaySound(1286441, "info")
		end,
	}
end

function mod:EternalNightfall()
	local barText = CL.count:format(self:GetRename(1286918), spellCount[1286918])
	spellCount[1286918] = spellCount[1286918] + 1

	if self:GetStage() == 2 then
		self:UnregisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "boss2")
	end

	return {
		msg = barText,
		key = 1286918,
		onFinished = function()
			self:StopBlizzMessages(1) -- Malacrass begins to bring forth an [Eternal Nightfall]!
			self:Message(1286918, "red", barText)
			self:PlaySound(1286918, "alarm")

			if self:GetStage() == 2 then
				-- 5s gap until the phase resets, so listen for intermission channel until the next timer
				self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "StartIntermission", "boss2")
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

do
	local isOnMe = false
	function mod:Dreadmarch(duration)
		local barText = CL.count:format(self:GetRename(1289900), spellCount[1289900])
		spellCount[1289900] = spellCount[1289900] + 1
		isOnMe = false

		local barInfo = {
			msg = barText,
			key = 1289900,
			onFinished = function()
				self:Message(1289900, "orange", barText)
				if not isOnMe then
					self:PlaySound(1289900, "alert")
				end
			end,
			onCanceled = function(this)
				self:CancelTimer(this.timer)
			end,
		}
		-- The target message happens ~3 before the bar ends
		barInfo.timer = self:ScheduleTimer(function()
			-- self:StopBlizzMessages(1) -- Malacrass if about to afflict you with [Dreadmarch]
			self:PersonalMessageFromBlizzMessage(1289900, 1, false, self:GetRename(1289900, 2), nil, nil, function() isOnMe = true end)
		end, duration - 3.5)

		return barInfo
	end
end

function mod:UnnervingFixationMessage()
	-- A Manifestation of Dread sets its gaze upon you with an [Unnerving Fixation]!
	self:PersonalMessage(1285911, false)
end

function mod:Gloombomb()
	local barText = CL.count:format(self:GetRename(1286895), spellCount[1286895])
	spellCount[1286895] = spellCount[1286895] + 1

	return {
		msg = barText,
		key = 1286895,
		onFinished = function()
			-- self:StopBlizzMessages(3) -- Malacrass targets you with [Gloombomb]!
			local timer = self:ScheduleTimer(function() self:Message(1286895, "yellow", barText) end, 3)
			self:PersonalMessageFromBlizzMessage(1286895, 3, false, self:GetRename(1286895, 2), nil, nil, function() self:CancelTimer(timer) end)
		end,
	}
end

function mod:SoulSever()
	local barText = CL.count:format(self:GetRename(1286573), spellCount[1286573])
	spellCount[1286573] = spellCount[1286573] + 1

	return {
		msg = barText,
		key = 1286573,
		onFinished = function()
			self:Message(1286573, "purple", barText)
			self:PlaySound(1286573, "alert")
		end,
	}
end

-- Stage 3

function mod:DefilementOfTheCoiledAltar()
	local barText = CL.count:format(self:GetRename(1298381), spellCount[1298381])
	spellCount[1298381] = spellCount[1298381] + 1
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
	local barText = CL.count:format(self:GetRename(1299266), spellCount[1299266])
	spellCount[1299266] = spellCount[1299266] + 1
	return {
		msg = barText,
		key = 1299266,
		onFinished = function()
			self:StopBlizzMessages(1) -- Zul'jan begins to cast [Grim Guillotine]!
			self:Message(1299266, "orange", barText)
			self:PlaySound(1299266, "alert")
		end,
	}
end

function mod:BlightedSever()
	local barText = CL.count:format(self:GetRename(1307279), spellCount[1307279])
	spellCount[1307279] = spellCount[1307279] + 1
	return {
		msg = barText,
		key = 1307279,
		onFinished = function()
			self:Message(1307279, "purple", barText)
			self:PlaySound(1307279, "alert")
		end,
	}
end
