
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ula'tek", 3004, 2895)
if not mod then return end
-- mod:RegisterEnableMob(0)
mod:SetEncounterID(3492)
mod:SetRespawnTime(30)
mod:UseCustomTimers(true, true)

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
	-- "stages",
	[1292999] = {1292999}, -- Submerge
	[1292188] = {1292188}, -- Caustic Waves
	[1300751] = {1300751}, -- Call of the Serpent
	[1298367] = {1298367}, -- Mother's Wrath
	[1298559] = {1298559}, -- Gore Rattle
	[1296301] = {1296301}, -- Mephitic Thrash
	[1300530] = {1300530}, -- Spectral Coils
	[1286860] = {1286860}, -- Rage of the Shackled
	[1302982] = {1302982}, -- Virulent Spit
	[1301510] = {1301510}, -- Demolish
	[1295905] = {1295905}, -- Serpent's Bite
	[1286905] = {1286905}, -- Fury Unleashed
})

--------------------------------------------------------------------------------
-- Options
--

mod:SetAuraData({
	-- 1308466, -- Call of the Serpent
	{1295360, soundOnApplied = "none", note = "DoT"}, -- Malignant Shell
	{1307612, soundOnApplied = "none", note = "DoT"}, -- Noxious Shell
	{1300312, soundOnApplied = "none", note = "DoT"}, -- Doomscale Shell
	{1301268, soundOnApplied = "none", note = "DoT"}, -- Putrid Membrane
	{1287036, soundOnApplied = "none", note = "DoT"}, -- Poisonous Bite
	-- {1287248, 1302365, tooltip = 1298367}, -- Mother's Wrath
	{1298417, soundOnApplied = "none", soundOnAppliedDose = "none", note = "Tank stacks"}, -- Stone Venom
	-- {1295844, 1295840, soundOnApplied = "none", tooltip = 1295905}, -- Serpent's Bite
	{1306119, soundOnApplied = "alarm", note = "Petrified"}, -- Calcified Corpse
	-- Not in EJ
	{1306388, soundOnApplied = "warning", note = "Achievement"}, -- Greasy Hatchling
	{1306393, soundOnApplied = "warning", note = "Achievement"}, -- Butter Fingers
})

function mod:GetOptions() -- SetOption:skip-unused
	return {
		"stages",
		1292999, -- Submerge

		-- Stage One: Fury of the Serpent Mother
		1292188, -- Caustic Waves
		1300751, -- Call of the Serpent
		1298367, -- Mother's Wrath
		1298559, -- Gore Rattle
			1296301, -- Mephitic Thrash
			1300530, -- Spectral Coils
		1286860, -- Rage of the Shackled

		-- Stage Two: Children of the Doomscale
		1302982, -- Virulent Spit
		-- Rage of the Shackled

		-- Intermission: The Shattering
		-- Spectral Coils

		-- Stage Three: Ula'tek's Ascension
		1301510, -- Demolish
		-- Caustic Waves
		-- Call of the Serpent
		1295905, -- Serpent's Bite
		-- Mother's Wrath
		-- Rage of the Shackled
		1286905, -- Fury Unleashed
	}, {
		[1292188] = -35561, -- Stage 1
		[1302982] = -36171, -- Stage 2
		-- [] = Intermission,
		[1301510] = -36323, -- Stage 3
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
