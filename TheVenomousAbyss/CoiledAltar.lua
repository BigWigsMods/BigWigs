
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Coiled Altar", 3004, 2883)
if not mod then return end
mod:RegisterEnableMob(257911, 259854) -- Zul'jan, Hex Lord Malacrass
mod:SetEncounterID(3429)
mod:SetRespawnTime(30)
mod:UseCustomTimers(true)

--------------------------------------------------------------------------------
-- Locals
--

local activeBars = {}
local backupBars = {}

--------------------------------------------------------------------------------
-- Localization
--

-- local L = mod:SetDefaultLocale({
-- })

--------------------------------------------------------------------------------
-- Renames
--

mod:SetRenames({
	[1282487] = {1282487}, -- Fangs of the Crucible
	[1299960] = {1299960}, -- Toxic Deluge
	[1283489] = {1283489}, -- Guillotine
	[1299680] = {1299680}, -- Sever
	[1282281] = {1282281}, -- Venomfang
	[1283832] = {1283832}, -- Axegrinder
	[1289900] = {1289900}, -- Dreadmarch
	[1285911] = {1285911}, -- Unnerving Fixation
	[1286573] = {1286573}, -- Soul Sever
	[1286918] = {1286918}, -- Eternal Nightfall
	[1286441] = {1286441}, -- Spiritcackle
	[1286895] = {1286895}, -- Gloombomb
	[1298381] = {1298381}, -- Defilement of the Crucible
	[1299266] = {1299266}, -- Grim Guillotine
	[1307279] = {1307279}, -- Blighted Sever
})

--------------------------------------------------------------------------------
-- Options
--

mod:SetPrivateAuraSounds({
	{1283345, sound = "none", note = "Tank stacks"}, -- Twinfang Toxin
	-- {1282283, sound = "none", note = "DoT", toolip = 1282287}, -- Venomfang
	{1285017, sound = "none", note = "DoT"}, -- Axegrinder
	{1285640, 1297435, 1285647, 1297445, sound = "warning"}, -- Dreadmarch
	{1285911, sound = "warning"}, -- Unnerving Fixation
	-- {1286326, 1286310, sound = "none"}, -- Shadowfang
	{1286399, sound = "alarm", note = "Kick fail"}, -- Wail of Terror
	{1286901, sound = "warning"}, -- Gloombomb
	{1300665, sound = "alarm", mythic = true}, -- Spirit Erasure
	{1298594, sound = "none"}, -- Defilement of the Crucible
	-- Not in EJ
	{1287227, sound = "none", note = "DoT"}, -- Blighted Toxin
})

function mod:GetOptions() -- SetOption:skip-unused
	return {
		"stages",

		-- Stage One: Serpent's Bargain
		1282487, -- Fangs of the Crucible
		1299960, -- Toxic Deluge
		1283489, -- Guillotine
		1299680, -- Sever
		1282281, -- Venomfang
		1283832, -- Axegrinder

		-- Stage Two: Usurper's Reprisal
		1289900, -- Dreadmarch
		1285911, -- Unnerving Fixation
		1286573, -- Soul Sever
		1286918, -- Eternal Nightfall
		1286441, -- Spiritcackle
		1286895, -- Gloombomb

		-- Intermission: The Claimed Vessel

		-- Stage Three: Coiled Union
		-- Zul'jan
			1298381, -- Defilement of the Crucible
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
		[1282487] = -35584, -- Stage 1
		[1289900] = -35599, -- Stage 2
		-- [] = -35533, -- Intermission
		[1298381] = -35403, -- Stage 3
		-- [1298381] = -35063, -- Zul'jan
		-- [1289900] = -35062, -- Hex Lord Malacrass
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
	self:Message("stages", "yellow", self.moduleName .. " engaged")
end

--------------------------------------------------------------------------------
-- Timeline Event Handlers
--

function mod:ENCOUNTER_TIMELINE_EVENT_ADDED(_, eventInfo)
	if eventInfo.source ~= 0 or self:IsWiping() then return end
	local barInfo = nil

	local duration = eventInfo.duration
	local durationRounded = self:RoundNumber(duration, 0)

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
