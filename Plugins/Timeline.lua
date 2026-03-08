if not BigWigsLoader.isRetail then return end -- Retail only module
--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin, L = BigWigs:NewPlugin("Timeline")
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

local db = nil
local hasCustomTimers = {}

--------------------------------------------------------------------------------
-- Profile
--

plugin.defaultDB = {
	timer_mode = "enhanced",
}

local function updateProfile()
	db = plugin.db.profile

	for k, v in next, db do
		local defaultType = type(plugin.defaultDB[k])
		if defaultType == "nil" then
			db[k] = nil
		elseif type(v) ~= defaultType then
			db[k] = plugin.defaultDB[k]
		end
	end

	if db.timer_mode ~= "enhanced" and db.timer_mode ~= "blizzbars" and db.timer_mode ~= "blizztimeline" and db.timer_mode ~= "dev" then
		db.timer_mode = plugin.defaultDB.timer_mode
	end
end

--------------------------------------------------------------------------------
-- Options
--

do
	local inConfigureMode = false

	local function timelineDisabled()
		return not C_CVar.GetCVarBool("combatWarningsEnabled") or not C_CVar.GetCVarBool("encounterTimelineEnabled")
	end

	plugin.pluginOptions = {
		type = "group",
		name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Timeline:20|t ".. L.timeline,
		childGroups = "tab",
		order = 5,
		args = {
			anchorsButton = {
				type = "execute",
				name = function()
					if inConfigureMode then
						return L.stopTest
					else
						return L.startTest
					end
				end,
				func = function()
					if inConfigureMode then
						plugin:SendMessage("BigWigs_StopConfigureMode", "Timeline")
					else
						plugin:SendMessage("BigWigs_StartConfigureMode", "Timeline")
					end
				end,
				width = 1.5,
				order = 1,
			},
			spacer1 = {
				type = "description",
				name = "",
				width = "full",
				order = 2,
			},
			timer_mode = {
				type = "select",
				name = L.show_bars,
				values = {
					enhanced = L.bigwigsEnhancedTimers,
					blizzbars = L.blizzBasicAsBars,
					blizztimeline = L.blizzBasicAsBlizzTimeline,
					dev = (BigWigsLoader.isTestBuild or BigWigsLoader.usingBigWigsAlpha or BigWigsLoader.usingBigWigsGuild) and L.developerMode or nil,
				},
				sorting = {
					"enhanced",
					"blizzbars",
					"blizztimeline",
					(BigWigsLoader.isTestBuild or BigWigsLoader.usingBigWigsAlpha or BigWigsLoader.usingBigWigsGuild) and "dev" or nil,
				},
				get = function(info)
					return db[info[#info]]
				end,
				set = function(info, value)
					db[info[#info]] = value
					plugin:UpdateBarsShown()
				end,
				width = 3,
				order = 3,
			},
			timeline = {
				type = "group",
				name = L.blizzTimelineSettings,
				get = function(info)
					local cvar = info[#info]
					return C_CVar.GetCVarBool(cvar)
				end,
				set = function(info, value)
					local cvar = info[#info]
					C_CVar.SetCVar(cvar, value and "1" or "0")
				end,
				order = 10,
				args = {
					header = {
						type = "description",
						name = L.blizzTimelineSettingsNote,
						order = 0,
					},
					encounterTimelineEnabled = {
						type = "toggle",
						name = L.enableBlizzTimeline,
						desc = L.enableBlizzTimelineDesc,
						width = 2,
						order = 1,
					},
					encounterTimelineHideLongCountdowns = {
						type = "toggle",
						name = _G.COMBAT_WARNINGS_HIDE_LONG_COUNTDOWNS_LABEL,
						desc = _G.COMBAT_WARNINGS_HIDE_LONG_COUNTDOWNS_TOOLTIP,
						disabled = timelineDisabled,
						width = 2,
						order = 2,
					},
					encounterTimelineHideQueuedCountdowns = {
						type = "toggle",
						name = _G.COMBAT_WARNINGS_HIDE_QUEUED_COUNTDOWNS_LABEL,
						desc = _G.COMBAT_WARNINGS_HIDE_QUEUED_COUNTDOWNS_TOOLTIP,
						disabled = timelineDisabled,
						width = 2,
						order = 3,
					},
					encounterTimelineHideForOtherRoles = {
						type = "toggle",
						name = _G.COMBAT_WARNINGS_HIDE_FOR_OTHER_ROLES_LABEL,
						desc = _G.COMBAT_WARNINGS_HIDE_FOR_OTHER_ROLES_TOOLTIP,
						disabled = timelineDisabled,
						width = 2,
						order = 4,
					},
					encounterTimelineIconographyEnabled = {
						type = "toggle",
						name = _G.COMBAT_WARNINGS_SPELL_SUPPORT_ICONOGRAPHY_LABEL,
						desc = _G.COMBAT_WARNINGS_SPELL_SUPPORT_ICONOGRAPHY_TOOLTIP,
						disabled = timelineDisabled,
						width = 2,
						order = 5,
					},
					encounterTimelineIconographyHiddenMask = {
						type = "multiselect",
						name = _G.COMBAT_WARNINGS_SPELL_SUPPORT_ICONOGRAPHY_LABEL,
						desc = _G.COMBAT_WARNINGS_SPELL_SUPPORT_ICONOGRAPHY_TOOLTIP,
						values = {
							[Enum.EncounterTimelineIconSet.TankAlert] = "|A:icons_16x16_tank:19:19|a" .. L.indicatorType_Tank,
							[Enum.EncounterTimelineIconSet.HealerAlert] = "|A:icons_16x16_heal:19:19|a" .. L.indicatorType_Healer,
							[Enum.EncounterTimelineIconSet.DamageAlert] = "|A:icons_16x16_damage:19:19|a" .. L.indicatorType_Damager,
							[Enum.EncounterTimelineIconSet.Dispel] = "|A:icons_16x16_magic:16:16|a" .. "|A:icons_16x16_curse:16:16|a" .. "|A:icons_16x16_disease:16:16|a" .. "|A:icons_16x16_poison:16:16|a" .. L.indicatorType_Dispels,
							[Enum.EncounterTimelineIconSet.Enrage] = "|A:icons_16x16_enrage:19:19|a" .. BigWigsAPI:GetLocale("BigWigs: Common").enrage,
							[Enum.EncounterTimelineIconSet.Deadly] = "|A:icons_16x16_deadly:19:19|a" .. L.indicatorType_Deadly,
						},
						get = function(info, key)
							local cvar = info[#info]
							local value = C_CVar.GetCVarBitfield(cvar, key)
							return not value -- values are inverted
						end,
						set = function(info, key, value)
							local cvar = info[#info]
							C_CVar.SetCVarBitfield(cvar, key, not value) -- values are inverted
						end,
						disabled = function()
							return timelineDisabled() or not C_CVar.GetCVarBool("encounterTimelineIconographyEnabled")
						end,
						order = 6,
					},
				},
			},
		},
	}

	local timer = nil
	local function queueEditModeEvents()
		local duration = C_EncounterTimeline.AddEditModeEvents()
		timer = C_Timer.NewTimer(duration, queueEditModeEvents)
	end

	function plugin:BigWigs_StartConfigureMode(_, mode)
		if mode and mode ~= "Timeline" then return end
		inConfigureMode = true

		if not timer then
			queueEditModeEvents()
		end
	end

	function plugin:BigWigs_StopConfigureMode(_, mode)
		if mode and mode ~= "Timeline" then return end
		inConfigureMode = false

		if timer then
			timer:Cancel()
			timer = nil
			C_EncounterTimeline.CancelEditModeEvents()
		end
	end
end

do
	local colors = {"red", "orange", "yellow"}
	local sounds = {"Warning", "Alarm", "Alert"}

	function plugin:DoTestMessage(name, icon)
		local severity = math.random(1, 3)
		plugin:SendMessage("BigWigs_Message", plugin, nil, name, colors[severity], icon, false)
		plugin:SendMessage("BigWigs_Sound", plugin, nil, sounds[severity])
	end
end

function plugin:UpdateBarsShown(event, module)
	local showBlizzardBars = db.timer_mode ~= "blizztimeline" -- True unless set to "blizztimeline" mode (no bars)

	local encounterID = module and module:GetEncounterID()
	if encounterID and showBlizzardBars then -- If module has encounter ID and we're not set to "blizztimeline" mode (no bars)
		if event == "BigWigs_OnBossEngage" or event == "BigWigs_OnBossEngageMidEncounter" then
			if db.timer_mode == "enhanced" then
				if module.useCustomTimers then
					hasCustomTimers[encounterID] = true
					showBlizzardBars = false
				elseif next(hasCustomTimers) then
					showBlizzardBars = false
				end
			end
		elseif db.timer_mode == "enhanced" then -- BigWigs_OnBossDisable
			hasCustomTimers[encounterID] = nil
			if next(hasCustomTimers) then
				showBlizzardBars = false
			end
		end
	elseif next(hasCustomTimers) then -- Compensate for this function being called manually, outside of BigWigs_OnBossEngage/BigWigs_OnBossDisable
		showBlizzardBars = false
	end

	if showBlizzardBars then
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED")
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
		self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
		self:StartBars()
	else
		self:UnregisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED")
		self:UnregisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
		self:UnregisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")
		self:StopBars()
	end
end

--------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnRegister()
	self.displayName = L.timeline
	C_CVar.SetCVar("combatWarningsEnabled", "1")
	C_CVar.SetCVar("encounterWarningsEnabled", "0")
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_StartConfigureMode")
	self:RegisterMessage("BigWigs_StopConfigureMode")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()

	self:RegisterMessage("BigWigs_OnBossEngage", "UpdateBarsShown")
	self:RegisterMessage("BigWigs_OnBossEngageMidEncounter", "UpdateBarsShown")
	self:RegisterMessage("BigWigs_OnBossDisable", "UpdateBarsShown")
	self:UpdateBarsShown()

	C_CVar.SetCVar("combatWarningsEnabled", "1")
	C_CVar.SetCVar("encounterWarningsEnabled", "0")
end

function plugin:OnPluginDisable()
	self:StopBars()
end

function plugin:StartBars()
	for _, eventId in next, C_EncounterTimeline.GetEventList() do
		local state = C_EncounterTimeline.GetEventState(eventId)
		if state == Enum.EncounterTimelineEventState.Paused or state == Enum.EncounterTimelineEventState.Active then
			local info = C_EncounterTimeline.GetEventInfo(eventId)
			local remaining = C_EncounterTimeline.GetEventTimeRemaining(eventId)
			local spellName = info.spellName
			if info.source == Enum.EncounterTimelineEventSource.EditMode then
				spellName = ("%s (%d)"):format(L.test, tonumber(strsub(eventId, -1)) + 1)
			end
			self:SendMessage("BigWigs_StartBar", nil, nil, spellName, remaining, info.iconFileID, info.maxQueueDuration, info.duration, eventId)

			if state == Enum.EncounterTimelineEventState.Paused then
				self:SendMessage("BigWigs_PauseBar", nil, nil, eventId)
			end
		end
	end
end

function plugin:StopBars()
	for _, eventId in next, C_EncounterTimeline.GetEventList() do
		self:SendMessage("BigWigs_StopBar", nil, nil, eventId)
	end
end

-------------------------------------------------------------------------------
-- Bars

local validIDs = {}
function plugin:ENCOUNTER_TIMELINE_EVENT_ADDED(_, eventInfo)
	-- Not Secret
	local source = eventInfo.source
	if source == 1 then return end -- Enum.EncounterTimelineEventSource.Script = 1
	local eventId = eventInfo.id
	validIDs[eventId] = true
	local duration = eventInfo.duration
	local maxQueueDuration = eventInfo.maxQueueDuration

	-- Secret
	local spellId = eventInfo.spellID
	local spellName = eventInfo.spellName
	local icon = eventInfo.iconFileID
	-- local roleAndSpellIndicators = eventInfo.icons
	-- local severity = eventInfo.severity
	-- local isApproximate = eventInfo.isApproximate

	if source == 2 then -- Enum.EncounterTimelineEventSource.EditMode = 2
		-- EditMode spells all have the same name
		spellName = ("%s (%d)"):format(L.test, tonumber(strsub(eventId, -1)) + 1)
	end
	self:SendMessage("BigWigs_StartBar", nil, nil, spellName, duration, icon, maxQueueDuration, nil, eventId, eventId)

	local state = C_EncounterTimeline.GetEventState(eventId)
	if state == Enum.EncounterTimelineEventState.Paused then
		self:SendMessage("BigWigs_PauseBar", nil, nil, eventId)
	end
end

function plugin:ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED(_, eventId)
	if not validIDs[eventId] then return end

	local newState = C_EncounterTimeline.GetEventState(eventId)
	if newState == Enum.EncounterTimelineEventState.Active then
		self:SendMessage("BigWigs_ResumeBar", nil, nil, eventId)

	elseif newState == Enum.EncounterTimelineEventState.Paused then
		self:SendMessage("BigWigs_PauseBar", nil, nil, eventId)

	elseif newState == Enum.EncounterTimelineEventState.Canceled then
		self:SendMessage("BigWigs_StopBar", nil, nil, eventId)

	elseif newState == Enum.EncounterTimelineEventState.Finished then
		local info = C_EncounterTimeline.GetEventInfo(eventId)
		if info.source == 2 then -- Enum.EncounterTimelineEventSource.EditMode = 2
			self:DoTestMessage(("%s (%d)"):format(L.test, tonumber(strsub(eventId, -1)) + 1), info.iconFileID)
		end
		self:SendMessage("BigWigs_StopBar", nil, nil, eventId)
	end
end

function plugin:ENCOUNTER_TIMELINE_EVENT_REMOVED(_, eventId)
	if validIDs[eventId] then
		validIDs[eventId] = nil
		self:SendMessage("BigWigs_StopBar", nil, nil, eventId)
	end
end
