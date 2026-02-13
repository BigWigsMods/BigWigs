if not BigWigsLoader.isMidnight then return end -- XXX Only for Midnight
--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin, L = BigWigs:NewPlugin("Timeline")
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

local db = nil

--------------------------------------------------------------------------------
-- Profile
--

plugin.defaultDB = {
	show_bars = true,
	show_messages = true,
	play_sound = true,
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
end

--------------------------------------------------------------------------------
-- Options
--

do
	local inConfigureMode = false

	local function timelineDisabled()
		return not C_CVar.GetCVarBool("combatWarningsEnabled") or not C_CVar.GetCVarBool("encounterTimelineEnabled")
	end
	local function warningsDisabled()
		return not C_CVar.GetCVarBool("combatWarningsEnabled") or not C_CVar.GetCVarBool("encounterWarningsEnabled")
	end

	plugin.pluginOptions = {
		type = "group",
		name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Timeline:20|t ".. L.timeline,
		childGroups = "tab",
		order = 0.1,
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
			show_bars = {
				type = "toggle",
				name = L.blizzTimersAsBigWigsBars,
				desc = L.blizzTimersAsBigWigsBarsDesc,
				get = function(info)
					return db[info[#info]]
				end,
				set = function(info, value)
					db[info[#info]] = value
					if value then
						plugin:StartBars()
					else
						plugin:OnPluginDisable()
					end
				end,
				width = "full",
				order = 3,
			},
			show_messages = {
				type = "toggle",
				name = L.blizzWarningsAsBigWigsMessages,
				desc = L.blizzWarningsAsBigWigsMessagesDesc,
				get = function(info)
					return db[info[#info]]
				end,
				set = function(info, value)
					db[info[#info]] = value
				end,
				width = "full",
				order = 4,
			},
			play_sound = {
				type = "toggle",
				name = L.blizzAudioAsBigWigsAudio,
				desc = L.blizzAudioAsBigWigsAudioDesc,
				get = function(info)
					return db[info[#info]]
				end,
				set = function(info, value)
					db[info[#info]] = value
				end,
				width = "full",
				order = 5,
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
			warnings = {
				type = "group",
				name = L.blizzWarningSettings,
				get = function(info)
					local cvar = info[#info]
					return C_CVar.GetCVarBool(cvar)
				end,
				set = function(info, value)
					local cvar = info[#info]
					C_CVar.SetCVar(cvar, value and "1" or "0")
				end,
				order = 20,
				args = {
					header = {
						type = "description",
						name = L.blizzTimelineSettingsNote,
						order = 0,
					},
					encounterWarningsEnabled = {
						type = "toggle",
						name = L.enableBlizzWarnings,
						desc = L.enableBlizzWarningsDesc,
						width = 1.5,
						order = 1,
						disabled = function() return db.show_messages end,
					},
					encounterWarningsLevel = {
						type = "select",
						name = _G.COMBAT_WARNINGS_ENABLE_ENCOUNTER_WARNINGS_LABEL,
						desc = ("%s|n|n%s: %s|n|n%s: %s|N|n%s: %s"):format(_G.COMBAT_WARNINGS_ENABLE_ENCOUNTER_WARNINGS_TOOLTIP,
							NORMAL_FONT_COLOR:WrapTextInColorCode(_G.COMBAT_WARNINGS_TEXT_LEVEL_MINOR_LABEL), WHITE_FONT_COLOR:WrapTextInColorCode(_G.COMBAT_WARNINGS_TEXT_LEVEL_MINOR_TOOLTIP),
							NORMAL_FONT_COLOR:WrapTextInColorCode(_G.COMBAT_WARNINGS_TEXT_LEVEL_MEDIUM_LABEL), WHITE_FONT_COLOR:WrapTextInColorCode(_G.COMBAT_WARNINGS_TEXT_LEVEL_MEDIUM_TOOLTIP),
							NORMAL_FONT_COLOR:WrapTextInColorCode(_G.COMBAT_WARNINGS_TEXT_LEVEL_CRITICAL_LABEL), WHITE_FONT_COLOR:WrapTextInColorCode(_G.COMBAT_WARNINGS_TEXT_LEVEL_CRITICAL_TOOLTIP)
						),
						values = {
							[Enum.EncounterEventSeverity.Low] = _G.COMBAT_WARNINGS_TEXT_LEVEL_MINOR_LABEL,
							[Enum.EncounterEventSeverity.Medium] = _G.COMBAT_WARNINGS_TEXT_LEVEL_MEDIUM_LABEL,
							[Enum.EncounterEventSeverity.High] = _G.COMBAT_WARNINGS_TEXT_LEVEL_CRITICAL_LABEL,
						},
						get = function(info)
							local cvar = info[#info]
							return tonumber(C_CVar.GetCVar(cvar))
						end,
						set = function(info, value)
							local cvar = info[#info]
							C_CVar.SetCVar(cvar, tostring(value))
						end,
						disabled = warningsDisabled,
						width = 1,
						order = 2,
					},
					encounterWarningsHideIfNotTargetingPlayer = {
						type = "toggle",
						name = _G.COMBAT_WARNINGS_HIDE_IF_NOT_TARGETING_PLAYER_LABEL,
						desc = _G.COMBAT_WARNINGS_HIDE_IF_NOT_TARGETING_PLAYER_TOOLTIP,
						disabled = warningsDisabled,
						width = 2,
						order = 3,
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
		if db.show_messages then
			plugin:SendMessage("BigWigs_Message", plugin, nil, name, colors[severity], icon, false)
		end
		if db.play_sound then
			plugin:SendMessage("BigWigs_Sound", plugin, nil, sounds[severity])
		end
	end
end

--------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnRegister()
	self.displayName = L.timeline
	C_CVar.SetCVar("combatWarningsEnabled", "1")
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_StartConfigureMode")
	self:RegisterMessage("BigWigs_StopConfigureMode")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()

	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_ADDED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED")
	self:RegisterEvent("ENCOUNTER_TIMELINE_EVENT_REMOVED")

	self:RegisterEvent("ENCOUNTER_WARNING")

	if db.show_messages then
		C_CVar.SetCVar("encounterWarningsEnabled", "0")
	end

	self:StartBars()
end

function plugin:OnPluginDisable()
	for _, eventId in next, C_EncounterTimeline.GetEventList() do
		self:SendMessage("BigWigs_StopBar", nil, nil, eventId)
	end
end

function plugin:StartBars()
	for _, eventId in next, C_EncounterTimeline.GetEventList() do
		-- not crazy about this basically being :ENCOUNTER_TIMELINE_EVENT_ADDED
		local info = C_EncounterTimeline.GetEventInfo(eventId)
		local remaining = C_EncounterTimeline.GetEventTimeRemaining(eventId)
		local spellName = info.spellName
		if info.source == Enum.EncounterTimelineEventSource.EditMode then
			spellName = ("%s (%d)"):format(L.test, tonumber(strsub(eventId, -1)) + 1)
		end
		self:SendMessage("BigWigs_StartBar", nil, nil, spellName, remaining, info.iconFileID, info.maxQueueDuration, info.duration, eventId)

		local state = C_EncounterTimeline.GetEventState(eventId)
		if state == Enum.EncounterTimelineEventState.Paused then
			self:SendMessage("BigWigs_PauseBar", nil, nil, eventId)
		end
	end
end

-------------------------------------------------------------------------------
-- Bars

function plugin:ENCOUNTER_TIMELINE_EVENT_ADDED(_, eventInfo)
	if not db.show_bars then return end

	-- Not Secret
	local eventId = eventInfo.id
	local duration = eventInfo.duration
	local source = eventInfo.source
	local maxQueueDuration = eventInfo.maxQueueDuration

	-- Secret
	local spellId = eventInfo.spellID
	local spellName = eventInfo.spellName
	local icon = eventInfo.iconFileID
	-- local roleAndSpellIndicators = eventInfo.icons
	-- local severity = eventInfo.severity
	-- local isApproximate = eventInfo.isApproximate

	if source == Enum.EncounterTimelineEventSource.EditMode then
		-- EditMode spells all have the same name
		spellName = ("%s (%d)"):format(L.test, tonumber(strsub(eventId, -1)) + 1)
	end
	self:SendMessage("BigWigs_StartBar", nil, nil, spellName, duration, icon, maxQueueDuration, nil, eventId)

	local state = C_EncounterTimeline.GetEventState(eventId)
	if state == Enum.EncounterTimelineEventState.Paused then
		self:SendMessage("BigWigs_PauseBar", nil, nil, eventId)
	end
end

function plugin:ENCOUNTER_TIMELINE_EVENT_STATE_CHANGED(_, eventId)
	local newState = C_EncounterTimeline.GetEventState(eventId)
	if newState == Enum.EncounterTimelineEventState.Active then
		self:SendMessage("BigWigs_ResumeBar", nil, nil, eventId)

	elseif newState == Enum.EncounterTimelineEventState.Paused then
		self:SendMessage("BigWigs_PauseBar", nil, nil, eventId)

	elseif newState == Enum.EncounterTimelineEventState.Canceled then
		self:SendMessage("BigWigs_StopBar", nil, nil, eventId)

	elseif newState == Enum.EncounterTimelineEventState.Finished then
		local info = C_EncounterTimeline.GetEventInfo(eventId)
		if info.source == Enum.EncounterTimelineEventSource.EditMode then
			self:DoTestMessage(("%s (%d)"):format(info.spellName, tonumber(strsub(eventId, -1)) + 1), info.iconFileID)
		end
		self:SendMessage("BigWigs_StopBar", nil, nil, eventId)
	end
end

function plugin:ENCOUNTER_TIMELINE_EVENT_REMOVED(_, eventId)
	self:SendMessage("BigWigs_StopBar", nil, nil, eventId)
end


-------------------------------------------------------------------------------
-- Messages

function plugin:ENCOUNTER_WARNING(_, eventInfo)
	-- Not Secret
	-- local duration = eventInfo.duration
	local severity = eventInfo.severity
	local shouldPlaySound = eventInfo.shouldPlaySound
	-- local shouldShowChatMessage = eventInfo.shouldShowChatMessage
	local shouldShowWarning = eventInfo.shouldShowWarning

	-- Secret
	local text = eventInfo.text
	-- local casterGUID = eventInfo.casterGUID
	local casterName = eventInfo.casterName
	local targetGUID = eventInfo.targetGUID
	local targetName = eventInfo.targetName
	local iconFileID = eventInfo.iconFileID
	-- local tooltipSpellID = eventInfo.tooltipSpellID

	-- shouldShowWarning gets set to false if encounterWarningsEnabled is false
	-- we obviously can't check if the message is targeting the player, so we lose that functionality
	-- local shouldShowWarningBasedOnSeverity = severity >= tonumber(C_CVar.GetCVar("encounterWarningsLevel"))

	if db.show_messages then
		local messages = BigWigs:GetPlugin("Messages", true)
		local formattedTargetName = targetName
		if targetGUID and messages.db.profile.classcolor then
			local _, className = GetPlayerInfoByGUID(targetGUID)
			if className then
				local classColor = C_ClassColor.GetClassColor(className)
				if classColor then
					formattedTargetName = classColor:WrapTextInColorCode(targetName)
				end
			end
		end
		local formattedText = string.format(text, casterName, formattedTargetName)

		local severityColorMap = {
			[0] = "yellow",
			[1] = "orange",
			[2] = "red",
		}

		self:SendMessage("BigWigs_Message", nil, false, formattedText, severityColorMap[severity] or "yellow", iconFileID, false)
	end

	if shouldPlaySound and db.play_sound then
		local severitySoundMap = {
			[0] = "alert",
			[1] = "alarm",
			[2] = "warning",
		}

		self:SendMessage("BigWigs_Sound", nil, false, severitySoundMap[severity] or "alert")
	end
end
