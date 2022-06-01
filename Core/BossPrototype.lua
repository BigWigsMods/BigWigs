-------------------------------------------------------------------------------
-- Boss Prototype
-- The API of a module created from `BigWigs:NewBoss`.
--
--### BigWigs:NewBoss (moduleName, instanceId[, journalId])
--
--**Parameters:**
--  - `moduleName`:  [string] a unique module name, usually the boss name
--  - `instanceId`:  [number] the instance id for the zone the boss is located in. Negative ids are used to represent map ids using the map API (usually for world bosses)
--  - `journalId`:  [number] the journal id for the boss, used to translate the boss name (_optional_)
--
--**Returns:**
--  - boss module
--  - [common locale](https://github.com/BigWigsMods/BigWigs/blob/master/Core/Locales/common.enUS.lua) table which holds common locale strings
--
-- @module BossPrototype
-- @alias boss
-- @usage local mod, CL = BigWigs:NewBoss("Argus the Unmaker", 1712, 2031)

local boss = {}
local core
do
	local _, tbl =...
	core = tbl.core
	tbl.bossPrototype = boss
end

local L = BigWigsAPI:GetLocale("BigWigs: Common")
local LibSpec = LibStub("LibSpecialization")
local UnitAffectingCombat, UnitIsPlayer, UnitPosition, UnitIsConnected, UnitClass = UnitAffectingCombat, UnitIsPlayer, UnitPosition, UnitIsConnected, UnitClass
local C_EncounterJournal_GetSectionInfo, GetSpellInfo, GetSpellTexture, GetTime, IsSpellKnown = C_EncounterJournal.GetSectionInfo, GetSpellInfo, GetSpellTexture, GetTime, IsSpellKnown
local EJ_GetEncounterInfo, UnitGroupRolesAssigned = EJ_GetEncounterInfo, UnitGroupRolesAssigned
local SendChatMessage, GetInstanceInfo, Timer, SetRaidTarget = BigWigsLoader.SendChatMessage, BigWigsLoader.GetInstanceInfo, BigWigsLoader.CTimerAfter, BigWigsLoader.SetRaidTarget
local UnitName, UnitGUID, UnitHealth, UnitHealthMax = BigWigsLoader.UnitName, BigWigsLoader.UnitGUID, BigWigsLoader.UnitHealth, BigWigsLoader.UnitHealthMax
local UnitDetailedThreatSituation = BigWigsLoader.UnitDetailedThreatSituation
local format, find, gsub, band, tremove, twipe = string.format, string.find, string.gsub, bit.band, table.remove, table.wipe
local select, type, next, tonumber = select, type, next, tonumber
local C = core.C
local pName = UnitName("player")
local cpName
local hasVoice = BigWigsAPI:HasVoicePack()
local bossUtilityFrame = CreateFrame("Frame")
local petUtilityFrame = CreateFrame("Frame")
local enabledModules, bossTargetScans, unitTargetScans = {}, {}, {}
local allowedEvents = {}
local difficulty = 0
local UpdateDispelStatus, UpdateInterruptStatus = nil, nil
local myGUID, myRole, myRolePosition = nil, nil, nil
local myGroupGUIDs, myGroupRolePositions = {}, {}
local solo = false
local classColorMessages = true
local debugFunc = nil
local updateData = function(module)
	myGUID = UnitGUID("player")
	hasVoice = BigWigsAPI:HasVoicePack()

	local messages = core:GetPlugin("Messages", true)
	if messages and not messages.db.profile.classcolor then
		classColorMessages = false
	else
		classColorMessages = true
	end

	local _, role, position = LibSpec:MySpecialization()
	myRole, myRolePosition = role, position

	local _, _, diff = GetInstanceInfo()
	difficulty = diff

	UpdateDispelStatus()
	UpdateInterruptStatus()

	solo = true
	myGroupGUIDs = {}
	local _, _, _, instanceId = UnitPosition("player")
	for unit in module:IterateGroup() do
		local guid = UnitGUID(unit)
		myGroupGUIDs[guid] = true
		if solo and myGUID ~= guid and UnitIsConnected(unit) then
			solo = false
		end
	end
	debugFunc = type(TranscriptIgnore) == "table" and TranscriptIgnore.debug and Transcriptor or false
end

-------------------------------------------------------------------------------
-- Debug
--

local dbg = function(...)
	if debugFunc then
		debugFunc:AddCustomEvent("BigWigs_Debug", "BigWigs", ...)
	end
end

function boss:Debug(...)
	if Transcriptor then
		Transcriptor:AddCustomEvent("BigWigs_Debug", "BigWigs", ...)
	end
end

-------------------------------------------------------------------------------
-- Metatables
--

local metaMap = {__index = function(self, key) self[key] = {} return self[key] end}
local eventMap = setmetatable({}, metaMap)
local unitEventMap = setmetatable({}, metaMap)
local widgetEventMap = setmetatable({}, metaMap)
local icons = setmetatable({}, {__index =
	function(self, key)
		local value
		if type(key) == "number" then
			if key > 8 then
				value = GetSpellTexture(key)
				if not value then
					core:Print(format("An invalid spell id (%d) is being used in a boss module.", key))
				end
			elseif key > 0 then
				-- Texture id list for raid icons 1-8 is 137001-137008. Base texture path is Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_%d
				value = key + 137000
			else
				local tbl = C_EncounterJournal_GetSectionInfo(-key)
				if not tbl then
					core:Print(format("An invalid journal id (%d) is being used in a boss module.", key))
				else
					value = tbl.abilityIcon or false
				end
			end
		else
			value = "Interface\\Icons\\" .. key
		end
		self[key] = value
		return value
	end
})
local spells = setmetatable({}, {__index =
	function(self, key)
		local value
		if key > 0 then
			value = GetSpellInfo(key)
			if not value then
				value = "INVALID"
				core:Print(format("An invalid spell id (%d) is being used in a boss module.", key))
			end
		else
			local tbl = C_EncounterJournal_GetSectionInfo(-key)
			if not tbl then
				value = "INVALID"
				core:Print(format("An invalid journal id (%d) is being used in a boss module.", key))
			else
				value = tbl.title
			end
		end
		self[key] = value
		return value
	end
})
local bossNames = setmetatable({}, {__index =
	function(self, key)
		local name = EJ_GetEncounterInfo(key)
		if name then
			self[key] = name
			return name
		else
			core:Print(format("An invalid boss name id (%d) is being used in a boss module.", key))
			self[key] = ""
			return ""
		end
	end
})

-------------------------------------------------------------------------------
-- Core module functionality
-- @section core
--

--- Register the module to enable on mob id.
-- @number ... Any number of mob ids
function boss:RegisterEnableMob(...)
	self.enableMobs = {}
	core:RegisterEnableMob(self, ...)
end

--- Check if a specific mob id would enable this module.
-- @number mobId A singular specific mob id
-- @return true or nil
function boss:IsEnableMob(mobId)
	return self.enableMobs[mobId]
end

--- Set the encounter id as used by events ENCOUNTER_START, ENCOUNTER_END & BOSS_KILL.
-- If this is set, no engage or wipe checking is required. The module will use this id and all engage/wipe checking will be handled automatically.
-- @number encounterId The encounter id
-- @within Enable triggers
function boss:SetEncounterID(encounterId)
	if type(encounterId) == "number" then
		self.engageId = encounterId
	end
end

--- Set the time in seconds before the boss respawns after a wipe.
-- Used by the `Respawn` plugin to show a bar for the respawn time.
-- @number seconds The respawn time
-- @within Enable triggers
function boss:SetRespawnTime(seconds)
	if type(seconds) == "number" then
		self.respawnTime = seconds
	end
end

--- The NPC/mob id of the world boss.
-- Used to specify that a module is for a world boss, not an instance boss.
-- @within Enable triggers
boss.worldBoss = nil

--- The map id the boss should be listed under in the configuration menu, generally used for world bosses.
-- @within Enable triggers
boss.otherMenu = nil

--- Allow a module to activate the "win" functionality of BigWigs.
-- When a boss is defeated, this boolean will allow a module to "win" even if it doesn't have a valid journal ID.
-- @within Enable triggers
function boss:SetAllowWin(bool)
	if bool then
		self.allowWin = true
	else
		self.allowWin = nil
	end
end

--- Check if a module option is enabled.
-- This is a wrapper around the self.db.profile[key] table.
-- @return boolean or number, depending on option type
function boss:GetOption(key)
	return self.db.profile[key]
end

--- Module enabled check.
-- A module is either enabled or disabled.
-- @return true or nil
function boss:IsEnabled()
	return self.enabled
end

--- Module engaged check.
-- A module is either engaged in combat or not.
-- @return true or nil
function boss:IsEngaged()
	return self.isEngaged
end

--- Check what stage of the encounter the module is set to.
-- @return number
function boss:GetStage()
	return self.stage
end

--- Set a module to a specific stage of the encounter
-- @number stage the stage to set the module to
function boss:SetStage(stage)
	if stage > 0 then
		self.stage = stage
		if self:IsEngaged() then
			self:SendMessage("BigWigs_SetStage", self, stage)
		end
	end
end

function boss:Initialize() core:RegisterBossModule(self) end
function boss:Enable(isWipe)
	if not self.enabled then
		self.enabled = true

		local isWiping = isWipe == true
		dbg("Enabling module", self.engageId, self.moduleName)

		updateData(self)
		self.sayCountdowns = {}

		-- Update enabled modules list
		for i = #enabledModules, 1, -1 do
			local module = enabledModules[i]
			if module == self then return end
		end
		enabledModules[#enabledModules+1] = self

		if self.engageId then
			self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckForEncounterEngage")
			self:RegisterEvent("ENCOUNTER_END", "EncounterEnd")
		end
		local _, class = UnitClass("player")
		if class == "WARLOCK" or class == "HUNTER" then
			petUtilityFrame:RegisterUnitEvent("UNIT_PET", "player")
		end

		if self.SetupOptions then self:SetupOptions() end
		if type(self.OnBossEnable) == "function" then self:OnBossEnable() end

		if IsEncounterInProgress() and not isWiping then -- Safety. ENCOUNTER_END might fire whilst IsEncounterInProgress is still true and engage a module.
			self:CheckForEncounterEngage("NoEngage") -- Prevent engaging if enabling during a boss fight (after a DC)
		end

		if not isWiping then
			self:SendMessage("BigWigs_OnBossEnable", self)
		end
	end
end
function boss:Disable(isWipe)
	if self.enabled then
		self.enabled = nil

		local isWiping = isWipe == true
		dbg("Disabling module", "isWipe:", isWiping, self.engageId, self.moduleName)
		if type(self.OnBossDisable) == "function" then self:OnBossDisable() end

		-- Update enabled modules list
		for i = #enabledModules, 1, -1 do
			if self == enabledModules[i] then
				tremove(enabledModules, i)
			end
		end

		-- No enabled modules? Unregister the combat log!
		if #enabledModules == 0 then
			bossUtilityFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			petUtilityFrame:UnregisterEvent("UNIT_PET")
			bossTargetScans, unitTargetScans = {}, {}
		else
			for i = #bossTargetScans, 1, -1 do
				if self == bossTargetScans[i][1] then
					tremove(bossTargetScans, i)
				end
			end
			for i = #unitTargetScans, 1, -1 do
				if self == unitTargetScans[i][1] then
					tremove(unitTargetScans, i)
				end
			end
		end

		-- Unregister the Unit Events for this module
		for a, b in next, unitEventMap[self] do
			for k in next, b do
				self:UnregisterUnitEvent(a, k)
			end
		end

		-- Empty the event maps for this module
		eventMap[self] = nil
		unitEventMap[self] = nil
		widgetEventMap[self] = nil
		allowedEvents = {}

		-- Re-add allowed events if more than one module is enabled
		for _, b in next, eventMap do
			for k in next, b do
				allowedEvents[k] = true
			end
		end

		-- Cancel all say countdowns
		for _, tbl in next, self.sayCountdowns do
			tbl[1] = true
		end

		self.sayCountdowns = nil
		self.scheduledMessages = nil
		self.targetEventFunc = nil
		self.missing = nil
		self.isWiping = nil
		self.isEngaged = nil
		self.bossTargetChecks = nil

		self:CancelAllTimers()

		if not isWiping then
			self:SendMessage("BigWigs_OnBossDisable", self)
		end
	end
end
function boss:Reboot(isWipe)
	if self.enabled then
		dbg("Rebooting module", "isWipe:", isWipe, self.engageId, self.moduleName)
		if isWipe then
			-- Devs, in 99% of cases you'll want to use OnBossWipe
			self:SendMessage("BigWigs_OnBossWipe", self)
		end
		self:Disable(isWipe)
		self:Enable(isWipe)
	end
end

-------------------------------------------------------------------------------
-- Localization
-- @section localization
--

--- Get the current localization strings.
-- @return keyed table of localized strings
function boss:GetLocale()
	if not self.localization then
		self.localization = {}
	end
	return self.localization
end
boss.NewLocale = boss.GetLocale

--- Create a custom marking option
-- @bool state Boolean value to represent default state
-- @string markType The type of string to return (player, npc)
-- @number icon An icon id to be used for the option texture
-- @number id The spell id or journal id to be translated into a name for the returned string
-- @number ... a series of raid icons being used by the marker function e.g. (1, 2, 3)
-- @return an option string to be used in conjuction with :GetOption
function boss:AddMarkerOption(state, markType, icon, id, ...)
	local l = self:GetLocale()
	local str = ""
	for i = 1, select("#", ...) do
		local num = select(i, ...)
		local icon = format("|T13700%d:15|t", num)
		str = str .. icon
	end

	local option = format(state and "custom_on_%d" or "custom_off_%d", id)
	l[option] = format(L.marker, spells[id])
	l[option.."_desc"] = format(markType == "player" and L.marker_player_desc or L.marker_npc_desc, spells[id], str)
	if icon then
		l[option.."_icon"] = icon
	end
	return option
end

-------------------------------------------------------------------------------
-- Combat log functions
-- @section combat_events
--

do
	local missingArgument = "Missing required argument when adding a listener to %q."
	local missingFunction = "%q tried to register a listener to method %q, but it doesn't exist in the module."
	local invalidId = "Module %q tried to register an invalid spell id (%s) to event %q."
	local multipleRegistration = "Module %q registered the event %q with spell id %q multiple times."

	function boss:CHAT_MSG_RAID_BOSS_EMOTE(event, msg, ...)
		if eventMap[self][event][msg] then
			self[eventMap[self][event][msg]](self, msg, ...)
		else
			for emote, func in next, eventMap[self][event] do
				if find(msg, emote, nil, true) or find(msg, emote) then -- Preserve backwards compat by leaving in the 2nd check
					self[func](self, msg, ...)
				end
			end
		end
	end
	--- [DEPRECATED] Register a callback for CHAT_MSG_RAID_BOSS_EMOTE that matches text.
	-- @param func callback function, passed (module, message, sender, language, channel, target, [standard CHAT_MSG args]...)
	-- @param ... any number of strings to match
	function boss:Emote(func, ...)
		if not func then core:Print(format(missingArgument, self.moduleName)) return end
		if not self[func] then core:Print(format(missingFunction, self.moduleName, func)) return end
		if not eventMap[self].CHAT_MSG_RAID_BOSS_EMOTE then eventMap[self].CHAT_MSG_RAID_BOSS_EMOTE = {} end
		for i = 1, select("#", ...) do
			eventMap[self]["CHAT_MSG_RAID_BOSS_EMOTE"][(select(i, ...))] = func
		end
		self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	end

	function boss:CHAT_MSG_MONSTER_YELL(event, msg, ...)
		if eventMap[self][event][msg] then
			self[eventMap[self][event][msg]](self, msg, ...)
		else
			for yell, func in next, eventMap[self][event] do
				if find(msg, yell, nil, true) or find(msg, yell) then -- Preserve backwards compat by leaving in the 2nd check
					self[func](self, msg, ...)
				end
			end
		end
	end
	--- [DEPRECATED] Register a callback for CHAT_MSG_MONSTER_YELL that matches text.
	-- @param func callback function, passed (module, message, sender, language, channel, target, [standard CHAT_MSG args]...)
	-- @param ... any number of strings to match
	function boss:BossYell(func, ...)
		if not func then core:Print(format(missingArgument, self.moduleName)) return end
		if not self[func] then core:Print(format(missingFunction, self.moduleName, func)) return end
		if not eventMap[self].CHAT_MSG_MONSTER_YELL then eventMap[self].CHAT_MSG_MONSTER_YELL = {} end
		for i = 1, select("#", ...) do
			eventMap[self]["CHAT_MSG_MONSTER_YELL"][(select(i, ...))] = func
		end
		self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	end

	local args = {}
	local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
	bossUtilityFrame:SetScript("OnEvent", function()
		local time, event, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, _, extraSpellId, amount = CombatLogGetCurrentEventInfo()
		if allowedEvents[event] then
			if event == "UNIT_DIED" then
				local _, _, _, _, _, id = strsplit("-", destGUID)
				local mobId = tonumber(id)
				if mobId then
					for i = #enabledModules, 1, -1 do
						local self = enabledModules[i]
						local m = eventMap[self][event]
						if m and m[mobId] then
							local func = m[mobId]
							args.mobId, args.destGUID, args.destName, args.destFlags, args.destRaidFlags = mobId, destGUID, destName, destFlags, args.destRaidFlags
							if type(func) == "function" then
								func(args)
							else
								self[func](self, args)
							end
						end
					end
				end
			else
				for i = #enabledModules, 1, -1 do
					local self = enabledModules[i]
					local m = eventMap[self][event]
					if m and (m[spellId] or m["*"]) then
						local func = m[spellId] or m["*"]
						-- DEVS! Please ask if you need args attached to the table that we've missed out!
						args.sourceGUID, args.sourceName, args.sourceFlags, args.sourceRaidFlags = sourceGUID, sourceName, sourceFlags, sourceRaidFlags
						args.destGUID, args.destName, args.destFlags, args.destRaidFlags = destGUID, destName, destFlags, destRaidFlags
						args.time, args.spellId, args.spellName, args.extraSpellId, args.extraSpellName, args.amount = time, spellId, spellName, extraSpellId, amount, amount
						if type(func) == "function" then
							func(args)
						else
							self[func](self, args)
						end
					end
				end
			end
		end
	end)
	--- Register a callback for COMBAT_LOG_EVENT.
	-- @string event COMBAT_LOG_EVENT to fire for e.g. SPELL_CAST_START
	-- @param func callback function, passed a keyed table (sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, extraSpellId, extraSpellName, amount)
	-- @number ... any number of spell ids
	function boss:Log(event, func, ...)
		if not event or not func then core:Print(format(missingArgument, self.moduleName)) return end
		if type(func) ~= "function" and not self[func] then core:Print(format(missingFunction, self.moduleName, func)) return end
		if not eventMap[self][event] then eventMap[self][event] = {} end
		for i = 1, select("#", ...) do
			local id = select(i, ...)
			if (type(id) == "number" and GetSpellInfo(id)) or id == "*" then
				if eventMap[self][event][id] then
					core:Print(format(multipleRegistration, self.moduleName, event, id))
				end
				eventMap[self][event][id] = func
			else
				core:Print(format(invalidId, self.moduleName, tostring(id), event))
			end
		end
		allowedEvents[event] = true
		bossUtilityFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:SendMessage("BigWigs_OnBossLog", self, event, ...)
	end
	--- Remove a callback for COMBAT_LOG_EVENT.
	-- @string event COMBAT_LOG_EVENT to register for
	-- @number ... any number of spell ids
	function boss:RemoveLog(event, ...)
		if not event then core:Print(format(missingArgument, self.moduleName)) return end
		for i = 1, select("#", ...) do
			local id = select(i, ...)
			eventMap[self][event][id] = nil
		end
	end
	--- Register a callback for UNIT_DIED.
	-- @param func callback function, passed a keyed table (mobId, destGUID, destName, destFlags, destRaidFlags)
	-- @number ... any number of mob ids
	function boss:Death(func, ...)
		if not func then core:Print(format(missingArgument, self.moduleName)) return end
		if type(func) ~= "function" and not self[func] then core:Print(format(missingFunction, self.moduleName, func)) return end
		if not eventMap[self].UNIT_DIED then eventMap[self].UNIT_DIED = {} end
		for i = 1, select("#", ...) do
			eventMap[self]["UNIT_DIED"][(select(i, ...))] = func
		end
		allowedEvents.UNIT_DIED = true
		bossUtilityFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

-------------------------------------------------------------------------------
-- Unit-specific event update management
-- @section unit_events
--

do
	local noEvent = "Module %q tried to register/unregister a unit event without specifying which event."
	local noUnit = "Module %q tried to register/unregister a unit event without specifying any units."
	local noFunc = "Module %q tried to register a unit event with the function '%s' which doesn't exist in the module."

	local frameTbl = {}
	local eventFunc = function(_, event, unit, ...)
		for i = #enabledModules, 1, -1 do
			local self = enabledModules[i]
			local m = unitEventMap[self] and unitEventMap[self][event]
			if m and m[unit] then
				self[m[unit]](self, event, unit, ...)
			end
		end
	end

	--- Register a callback for a UNIT_* event for the specified units.
	-- @string event the event to register for
	-- @param func callback function, passed (unit, eventargs...)
	-- @string ... Any number of unit tokens
	function boss:RegisterUnitEvent(event, func, ...)
		if type(event) ~= "string" then core:Print(format(noEvent, self.moduleName)) return end
		if not ... then core:Print(format(noUnit, self.moduleName)) return end
		if (not func and not self[event]) or (func and not self[func]) then core:Print(format(noFunc, self.moduleName, func or event)) return end
		if not unitEventMap[self][event] then unitEventMap[self][event] = {} end
		for i = 1, select("#", ...) do
			local unit = select(i, ...)
			if not frameTbl[unit] then
				frameTbl[unit] = CreateFrame("Frame")
				frameTbl[unit]:SetScript("OnEvent", eventFunc)
			end
			unitEventMap[self][event][unit] = func or event
			frameTbl[unit]:RegisterUnitEvent(event, unit)
		end
	end
	--- Unregister a callback for unit bound events.
	-- @string event the event register for
	-- @string ... Any number of unit tokens
	function boss:UnregisterUnitEvent(event, ...)
		if type(event) ~= "string" then core:Print(format(noEvent, self.moduleName)) return end
		if not ... then core:Print(format(noUnit, self.moduleName)) return end
		if not unitEventMap[self][event] then return end
		for i = 1, select("#", ...) do
			local unit = select(i, ...)
			unitEventMap[self][event][unit] = nil
			local keepRegistered
			for j = #enabledModules, 1, -1 do
				local m = unitEventMap[enabledModules[j]][event]
				if m and m[unit] then
					keepRegistered = true
				end
			end
			if not keepRegistered then
				frameTbl[unit]:UnregisterEvent(event)
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Widget-specific event update management
-- @section widget_events
--

do
	local noID = "Module '%s' tried to register/unregister a widget event without specifying a widget id."
	local noFunc = "Module '%s' tried to register a widget event with the function '%s' which doesn't exist in the module."

	function boss:UPDATE_UI_WIDGET(_, tbl)
		local id = tbl.widgetID
		local func = widgetEventMap[self][id]
		if func then
			local typeInfo = UIWidgetManager:GetWidgetTypeInfo(tbl.widgetType)
			local info = typeInfo and typeInfo.visInfoDataFunction(id)
			if info then
				local value = info.text -- Remain compatible with older modules
				if (not value or value == "") and info.barValue then
					-- Type 2 (StatusBar) seems to be the most common modern widget we use and
					-- info.overrideBarText is used for the actual bar text, so pass the bar
					-- value to the callback for convenience.
					value = info.barValue
				end
				self[func](self, id, value, info)
			end
		end
	end

	--- Register a callback for a widget event for the specified widget id.
	-- @number id the id of the widget to listen to
	-- @param func callback function, passed (widgetId, widgetValue, widgetInfoTable)
	function boss:RegisterWidgetEvent(id, func)
		if type(id) ~= "number" then core:Print(format(noID, self.moduleName)) return end
		if type(func) ~= "string" or not self[func] then core:Print(format(noFunc, self.moduleName, tostring(func))) return end
		if not widgetEventMap[self][id] then widgetEventMap[self][id] = func end
		self:RegisterEvent("UPDATE_UI_WIDGET")
	end
	--- Unregister a callback for widget events.
	-- @number id the widget id to stop listening to
	function boss:UnregisterWidgetEvent(id)
		if type(id) ~= "number" then core:Print(format(noID, self.moduleName)) return end
		if not widgetEventMap[self][id] then return end
		widgetEventMap[self][id] = nil
		if not next(widgetEventMap[self]) then
			self:UnregisterEvent("UPDATE_UI_WIDGET")
		end
	end
end

-------------------------------------------------------------------------------
-- Engage/wipe checking and unit scanning
-- @section unit_scanning
--

do
	local function wipeCheck(module)
		if not IsEncounterInProgress() then
			dbg(":StartWipeCheck IsEncounterInProgress() is nil, wiped", module.engageId, module.moduleName)
			module:Wipe()
		end
	end

	-- Start checking for a wipe.
	-- Starts a repeating timer checking IsEncounterInProgress() and reboots the module if false.
	function boss:StartWipeCheck()
		self:StopWipeCheck()
		self.isWiping = self:ScheduleRepeatingTimer(wipeCheck, 1, self)
	end
	-- Stop checking for a wipe.
	-- Stops the repeating timer checking IsEncounterInProgress() if it is running.
	function boss:StopWipeCheck()
		if self.isWiping then
			self:CancelTimer(self.isWiping)
			self.isWiping = nil
		end
	end

	local bosses = {"boss1", "boss2", "boss3", "boss4", "boss5"}
	-- Update module engage status from querying boss units.
	-- Engages modules if boss1-boss5 matches an registered enabled mob,
	-- disables the module if set as engaged but has no boss match.
	-- noEngage if set to "NoEngage", the module is prevented from engaging if enabling during a boss fight (after a DC)
	function boss:CheckForEncounterEngage(noEngage)
		if not self:IsEngaged() then
			for i = 1, 5 do
				local boss = bosses[i]
				local guid = UnitGUID(boss)
				if guid and UnitHealth(boss) > 0 then
					local mobId = self:MobId(guid)
					if self:IsEnableMob(mobId) then
						self:Engage(noEngage == "NoEngage" and noEngage)
						return
					elseif not self.disableTimer then
						self.disableTimer = true
						self:SimpleTimer(function()
							self.disableTimer = nil
							if not self:IsEngaged() then
								self:Disable()
							end
						end, 3) -- 3 seconds should be enough time for the IEEU event to enable all the boss frames (fires once per boss frame)
					end
				end
			end
		end
	end

	-- Query boss units to update engage status.
	function boss:CheckBossStatus()
		local hasBoss = UnitHealth("boss1") > 0 or UnitHealth("boss2") > 0 or UnitHealth("boss3") > 0 or UnitHealth("boss4") > 0 or UnitHealth("boss5") > 0
		if not hasBoss and self:IsEngaged() then
			dbg(":CheckBossStatus wipeCheck scheduled", self.engageId, self.moduleName)
			self:ScheduleTimer(wipeCheck, 6, self)
		elseif not self:IsEngaged() and hasBoss then
			dbg(":CheckBossStatus called :CheckForEncounterEngage", self.engageId, self.moduleName)
			self:CheckForEncounterEngage()
		else
			dbg(":CheckBossStatus called with no result", "IsEngaged():", self:IsEngaged(), "hasBoss:", hasBoss, self.engageId, self.moduleName)
		end
	end
end

do
	local unitTable = {
		"boss1", "boss2", "boss3", "boss4", "boss5",
		"target", "targettarget",
		"mouseover", "mouseovertarget",
		"focus", "focustarget",
		"nameplate1", "nameplate2", "nameplate3", "nameplate4", "nameplate5", "nameplate6", "nameplate7", "nameplate8", "nameplate9", "nameplate10",
		"nameplate11", "nameplate12", "nameplate13", "nameplate14", "nameplate15", "nameplate16", "nameplate17", "nameplate18", "nameplate19", "nameplate20",
		"nameplate21", "nameplate22", "nameplate23", "nameplate24", "nameplate25", "nameplate26", "nameplate27", "nameplate28", "nameplate29", "nameplate30",
		"nameplate31", "nameplate32", "nameplate33", "nameplate34", "nameplate35", "nameplate36", "nameplate37", "nameplate38", "nameplate39", "nameplate40",
		"party1target", "party2target", "party3target", "party4target",
		"raid1target", "raid2target", "raid3target", "raid4target", "raid5target",
		"raid6target", "raid7target", "raid8target", "raid9target", "raid10target",
		"raid11target", "raid12target", "raid13target", "raid14target", "raid15target",
		"raid16target", "raid17target", "raid18target", "raid19target", "raid20target",
		"raid21target", "raid22target", "raid23target", "raid24target", "raid25target",
		"raid26target", "raid27target", "raid28target", "raid29target", "raid30target",
		"raid31target", "raid32target", "raid33target", "raid34target", "raid35target",
		"raid36target", "raid37target", "raid38target", "raid39target", "raid40target"
	}
	local unitTableCount = #unitTable
	local function findTargetByGUID(id)
		local isNumber = type(id) == "number"
		for i = 1, unitTableCount do
			local unit = unitTable[i]
			local guid = UnitGUID(unit)
			if guid and not UnitIsPlayer(unit) then
				if isNumber then
					local _, _, _, _, _, mobId = strsplit("-", guid)
					guid = tonumber(mobId)
				end
				if guid == id then return unit end
			end
		end
	end
	--- Fetches a unit id by scanning available targets.
	-- Scans through available targets such as bosses, nameplates and player targets
	-- in an attempt to find a valid unit id to return.
	-- @param id GUID or mob/npc id
	-- @return unit id if found, nil otherwise
	function boss:GetUnitIdByGUID(id) return findTargetByGUID(id) end

	--- Fetches a unit id by scanning boss units 1 to 5 only.
	-- @param id Either the GUID or the mob/npc id of the boss unit to find
	-- @return unit id if found, nil otherwise
	-- @return guid if found, nil otherwise
	function boss:GetBossId(id)
		local isNumber = type(id) == "number"
		for i = 1, 5 do
			local unit = unitTable[i]
			local guid = UnitGUID(unit)
			if id == guid then
				return unit, guid
			elseif guid and isNumber then
				local _, _, _, _, _, mobId = strsplit("-", guid)
				if id == tonumber(mobId) then
					return unit, guid
				end
			end
		end
	end

	local function unitScanner()
		for i = #unitTargetScans, 1, -1 do
			local self, func, tankCheckExpiry, guid = unitTargetScans[i][1], unitTargetScans[i][2], unitTargetScans[i][3], unitTargetScans[i][4]
			local elapsed = unitTargetScans[i][5] + 0.05
			unitTargetScans[i][5] = elapsed

			local unit = findTargetByGUID(guid)
			if unit then
				local unitTarget = unit.."target"
				local playerGUID = UnitGUID(unitTarget)
				if playerGUID and ((not UnitDetailedThreatSituation(unitTarget, unit) and not self:Tank(unitTarget)) or elapsed > tankCheckExpiry) then
					local name = self:UnitName(unitTarget)
					tremove(unitTargetScans, i)
					elapsed = 0
					func(self, name, playerGUID)
				end
			end

			if elapsed > 0.8 then
				tremove(unitTargetScans, i)
			end
		end

		if #unitTargetScans ~= 0 then
			Timer(0.05, unitScanner)
		end
	end

	--- Register a callback to get the first non-tank target of a mob.
	-- Looks for the unit as defined by the GUID and then returns the target of that unit.
	-- If the target is a tank, it will keep looking until the designated time has elapsed.
	-- @param func callback function, passed (module, playerName, playerGUID)
	-- @number tankCheckExpiry seconds to wait, if a tank is still the target after this time, it will return the tank as the target (max 0.8)
	-- @string guid GUID of the mob to get the target of
	function boss:GetUnitTarget(func, tankCheckExpiry, guid)
		if #unitTargetScans == 0 then
			Timer(0.05, unitScanner)
		end

		unitTargetScans[#unitTargetScans+1] = {self, func, solo and 0.1 or tankCheckExpiry, guid, 0} -- Tiny allowance when solo
	end

	local function scan(self)
		for mobId, entry in next, core:GetEnableMobs() do
			if type(entry) == "table" then
				for i = 1, #entry do
					local module = entry[i]
					if module == self.moduleName then
						local unit = findTargetByGUID(mobId)
						if unit and UnitAffectingCombat(unit) then return unit end
						break
					end
				end
			elseif entry == self.moduleName then
				local unit = findTargetByGUID(mobId)
				if unit and UnitAffectingCombat(unit) then return unit end
			end
		end
	end

	--- Start a repeating timer checking if your group is in combat with a boss.
	function boss:CheckForEngage()
		local go = scan(self)
		if go then
			dbg(":CheckForEngage() scan found active boss entities, calling :Engage", self.engageId, self.moduleName)
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
			self:Engage()
		else
			dbg(":CheckForEngage() scan found nothing, next scan in 0.5s", self.engageId, self.moduleName)
			self:ScheduleTimer("CheckForEngage", .5)
		end
	end

	-- What if we die and then get battleressed?
	-- First of all, the CheckForWipe every 2 seconds would continue scanning.
	-- Secondly, if the boss module registers for PLAYER_REGEN_DISABLED, it would
	-- trigger again, and CheckForEngage (possibly) invoked, which results in
	-- a new Engage sync -> :Engage -> :OnEngage on the module.
	-- Possibly a concern?

	--- Start a repeating timer checking if your group has left combat with a boss.
	-- @string[opt] first The event name when used as a callback
	function boss:CheckForWipe(first)
		local go = scan(self)
		if not first and not go then
			dbg(":CheckForWipe() found nothing active, rebooting module", self.engageId, self.moduleName)
			self:Wipe()
		else
			dbg(":CheckForWipe() found active bosses, waiting for next scan in 2s", "Boss:", go, self.engageId, self.moduleName)
			self:ScheduleTimer("CheckForWipe", 2)
		end
	end

	function boss:Engage(noEngage)
		if not self.isEngaged then
			self.isEngaged = true

			dbg(":Engage", "noEngage:", noEngage, self.engageId, self.moduleName)

			if not noEngage or noEngage ~= "NoEngage" then
				updateData(self)

				if self.OnEngage then
					self:OnEngage(difficulty)
				end

				self:SendMessage("BigWigs_OnBossEngage", self, difficulty)
			elseif noEngage == "NoEngage" then
				self:SendMessage("BigWigs_OnBossEngageMidEncounter", self, difficulty)
			end
		end
	end

	function boss:Win()
		dbg(":Win", self.engageId, self.moduleName)
		twipe(icons) -- Wipe icon cache
		twipe(spells)
		if self.OnWin then self:OnWin() end
		self:ScheduleTimer("Disable", 1) -- Delay a little to prevent re-enabling
		self:SendMessage("BigWigs_OnBossWin", self)
		self:SendMessage("BigWigs_VictorySound", self)
	end

	function boss:Wipe()
		self:Reboot(true)
		if self.OnWipe then self:OnWipe() end
	end
end

do
	local bosses = {"boss1", "boss2", "boss3", "boss4", "boss5"}
	local bossTargets = {"boss1target", "boss2target", "boss3target", "boss4target", "boss5target"}
	local function bossScanner()
		for i = #bossTargetScans, 1, -1 do
			local self, func, tankCheckExpiry, guid = bossTargetScans[i][1], bossTargetScans[i][2], bossTargetScans[i][3], bossTargetScans[i][4]
			local elapsed = bossTargetScans[i][5] + 0.05
			bossTargetScans[i][5] = elapsed

			for j = 1, 5 do
				local unit = bosses[j]
				if UnitGUID(unit) == guid then
					local bossTarget = bossTargets[j]
					local playerGUID = UnitGUID(bossTarget)
					if playerGUID and ((not UnitDetailedThreatSituation(bossTarget, unit) and not self:Tank(bossTarget)) or elapsed > tankCheckExpiry) then
						local name = self:UnitName(bossTarget)
						tremove(bossTargetScans, i)
						elapsed = 0
						func(self, name, playerGUID)
					end
					break
				end
			end

			if elapsed > 0.8 then
				tremove(bossTargetScans, i)
			end
		end

		if #bossTargetScans ~= 0 then
			Timer(0.05, bossScanner)
		end
	end
	--- Register a callback to get the first non-tank target of a boss (boss1 - boss5).
	-- Looks for the boss as defined by the GUID and then returns the target of that boss.
	-- If the target is a tank, it will keep looking until the designated time has elapsed.
	-- @param func callback function, passed (module, playerName, playerGUID)
	-- @number tankCheckExpiry seconds to wait, if a tank is still the target after this time, it will return the tank as the target (max 0.8)
	-- @string guid GUID of the mob to get the target of
	function boss:GetBossTarget(func, tankCheckExpiry, guid)
		if #bossTargetScans == 0 then
			Timer(0.05, bossScanner)
		end

		bossTargetScans[#bossTargetScans+1] = {self, func, solo and 0.1 or tankCheckExpiry, guid, 0} -- Tiny allowance when solo
	end


	function boss:NextTarget(event, unit)
		self:UnregisterUnitEvent(event, unit)
		local func = self.bossTargetChecks[unit]
		self.bossTargetChecks[unit] = nil
		local id = unit.."target"
		local playerGUID = UnitGUID(id)
		local name = self:UnitName(id)
		func(self, name, playerGUID)
	end
	--- Register a callback to get the next target a boss swaps to (boss1 - boss5).
	-- Looks for the boss as defined by the GUID and then returns the next target selected by that boss.
	-- Unlike the :GetBossTarget functionality, :GetNextBossTarget doesn't care what the target is, it will just fire the callback with whatever unit the boss targets next
	-- @param func callback function, passed (module, playerName, playerGUID)
	-- @string guid GUID of the mob to get the target of
	-- @number[opt] timeToWait seconds to wait for the boss to change target until giving up, if nil the default time of 0.3s is used
	function boss:GetNextBossTarget(func, guid, timeToWait)
		if not self.bossTargetChecks then
			self.bossTargetChecks = {}
		end

		for i = 1, 5 do
			local unit = bosses[i]
			if UnitGUID(unit) == guid then
				self.bossTargetChecks[unit] = func
				self:RegisterUnitEvent("UNIT_TARGET", "NextTarget", unit)
				Timer(timeToWait or 0.3, function()
					if self.bossTargetChecks[unit] then
						self:UnregisterUnitEvent("UNIT_TARGET", unit)
					end
				end)
				break
			end
		end
	end
end

do
	function boss:UPDATE_MOUSEOVER_UNIT(event)
		local guid = UnitGUID("mouseover")
		if not myGroupGUIDs[guid] then
			self[self.targetEventFunc](self, event, "mouseover", guid)
		end
	end
	function boss:UNIT_TARGET(event, unit)
		local unitTarget = unit.."target"
		local guid = UnitGUID(unitTarget)
		if not myGroupGUIDs[guid] then
			self[self.targetEventFunc](self, event, unitTarget, guid)
		end

		if self.targetEventFunc then -- Event is still registered, continue
			local guid = UnitGUID(unit)
			if not myGroupGUIDs[guid] then
				self[self.targetEventFunc](self, event, unit, guid)
			end
		end
	end
	function boss:NAME_PLATE_UNIT_ADDED(event, unit)
		local guid = UnitGUID(unit)
		if not myGroupGUIDs[guid] then
			self[self.targetEventFunc](self, event, unit, guid)
		end
	end
	--- Register a set of events commonly used for raid marking functionality and pass the unit to a designated function.
	-- UPDATE_MOUSEOVER_UNIT, UNIT_TARGET, NAME_PLATE_UNIT_ADDED, FORBIDDEN_NAME_PLATE_UNIT_ADDED.
	-- @param func callback function, passed (event, unit)
	function boss:RegisterTargetEvents(func)
		if self[func] then
			self.targetEventFunc = func
			self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
			self:RegisterEvent("UNIT_TARGET")
			self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
			self:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_ADDED", "NAME_PLATE_UNIT_ADDED")
		end
	end
	--- Unregister the events registered by `RegisterTargetEvents`.
	function boss:UnregisterTargetEvents()
		self.targetEventFunc = nil
		self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
		self:UnregisterEvent("UNIT_TARGET")
		self:UnregisterEvent("NAME_PLATE_UNIT_ADDED")
		self:UnregisterEvent("FORBIDDEN_NAME_PLATE_UNIT_ADDED")
	end
end

function boss:EncounterEnd(event, id, name, diff, size, status)
	if self.engageId == id and self.enabled then
		if status == 1 then
			if self.journalId or self.allowWin then
				self:Win() -- Official boss module
			else
				self:Disable() -- Custom external boss module
			end
		elseif status == 0 then
			self:SendMessage("BigWigs_StopBars", self)
			Timer(5, function() self:Wipe() end) -- Delayed due to issues with some multi-boss encounters showing/hiding the boss frames (IEEU) rapidly whilst wiping.
		end
		self:SendMessage("BigWigs_EncounterEnd", self, id, name, diff, size, status) -- Do NOT use this for wipe detection, use BigWigs_OnBossWipe.
	end
end

-------------------------------------------------------------------------------
-- Misc utility functions
-- @section utility
--

--- Get the current instance difficulty.
-- @return difficulty id
function boss:Difficulty()
	return difficulty
end

--- Check if in a Looking for Raid instance.
-- @return boolean
function boss:LFR()
	return difficulty == 7 or difficulty == 17
end

--- Check if in a Normal difficulty instance.
-- @return boolean
function boss:Normal()
	return difficulty == 1 or difficulty == 3 or difficulty == 4 or difficulty == 14
end

--- Check if in a Looking for Raid or Normal difficulty instance.
-- @return boolean
function boss:Easy()
	return difficulty == 14 or difficulty == 17 -- New normal mode or new LFR mode
end

--- Check if in a Heroic difficulty instance.
-- @return boolean
function boss:Heroic()
	return difficulty == 2 or difficulty == 5 or difficulty == 6 or difficulty == 15
end

--- Check if in a Mythic or Mythic+ difficulty instance.
-- @return boolean
function boss:Mythic()
	return difficulty == 16 or difficulty == 23 or difficulty == 8
end

--- Check if in a Mythic+ difficulty instance.
-- @return boolean
function boss:MythicPlus()
	return difficulty == 8
end

--- Get the mob/npc id from a GUID.
-- @string guid GUID of a mob/npc
-- @return mob/npc id
function boss:MobId(guid)
	if not guid then return 1 end
	local _, _, _, _, _, id = strsplit("-", guid)
	return tonumber(id) or 1
end

--- Get a localized name from an id. Positive ids for spells (GetSpellInfo) and negative ids for journal-based section entries (C_EncounterJournal.GetSectionInfo).
-- @number spellIdOrSectionId The spell id or the journal-based section id (as a negative number)
-- @return spell name
function boss:SpellName(spellIdOrSectionId)
	return spells[spellIdOrSectionId]
end

--- Get a localized boss name from a journal-based encounter id. (EJ_GetEncounterInfo)
-- @number journalEncounterId The journal-based encounter id
-- @return localized boss name
function boss:BossName(journalEncounterId)
	return bossNames[journalEncounterId]
end

--- Check if a GUID is you.
-- @string guid player GUID
-- @return boolean
function boss:Me(guid)
	return myGUID == guid
end

do
	--- Get the full name of a unit.
	-- @string unit unit token or name
	-- @return name name with the server appended if appropriate
	function boss:UnitName(unit)
		local name, server = UnitName(unit)
		if not name then
			return
		elseif server and server ~= "" then
			name = name .."-".. server
		end
		return name
	end
	--- Get the Globally Unique Identifier of a unit.
	-- @string unit unit token or name
	-- @return guid guid of the unit
	function boss:UnitGUID(unit)
		local guid = UnitGUID(unit)
		if guid then
			return guid
		end
	end
end

--- Get the health percentage of a unit.
-- @string unit unit token or name
-- @return hp health of the unit as a percentage between 0 and 100
function boss:GetHealth(unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	return hp
end

do
	local UnitAura = UnitAura
	local blacklist = {}
	--- Get the buff info of a unit.
	-- @string unit unit token or name
	-- @number spell the spell ID of the buff to scan for
	-- @return args
	function boss:UnitBuff(unit, spell, ...)
		if type(spell) == "string" then
			if ... then
				for i = 1, select("#", ...) do
					local blacklistSpell = select(i, ...)
					blacklist[blacklistSpell] = true
				end
			end
			local t1, t2, t3, t4, t5
			for i = 1, 100 do
				local name, _, stack, _, duration, expirationTime, _, _, _, spellId, _, _, _, _, _, value = UnitAura(unit, i, "HELPFUL")

				if name == spell then
					if not blacklist[spellId] then
						blacklist[spellId] = true
						BigWigs:Error(format("Found spell '%s' using id %d on %d, tell the authors!", name, spellId, self:Difficulty()))
					end
					t1, t2, t3, t4, t5 = name, stack, duration, expirationTime, value
				end

				if not spellId then
					return t1, t2, t3, t4, t5
				end
			end
		else
			for i = 1, 100 do
				local name, _, stack, auraType, duration, expirationTime, _, _, _, spellId, _, _, _, _, _, value = UnitAura(unit, i, "HELPFUL")

				if not spellId then
					return
				elseif not spell then
					local desiredType = ...
					if auraType == desiredType then
						return name, stack, duration, expirationTime
					end
				elseif spellId == spell then
					return name, stack, duration, expirationTime, value
				end
			end
		end
	end

	--- Get the debuff info of a unit.
	-- @string unit unit token or name
	-- @number spell the spell ID of the debuff to scan for
	-- @return args
	function boss:UnitDebuff(unit, spell, ...)
		if type(spell) == "string" then
			if ... then
				for i = 1, select("#", ...) do
					local blacklistSpell = select(i, ...)
					blacklist[blacklistSpell] = true
				end
			end
			local t1, t2, t3, t4, t5
			for i = 1, 100 do
				local name, _, stack, _, duration, expirationTime, _, _, _, spellId, _, _, _, _, _, value = UnitAura(unit, i, "HARMFUL")

				if name == spell then
					if not blacklist[spellId] then
						blacklist[spellId] = true
						BigWigs:Error(format("Found spell '%s' using id %d on %d, tell the authors!", name, spellId, self:Difficulty()))
					end
					t1, t2, t3, t4, t5 = name, stack, duration, expirationTime, value
				end

				if not spellId then
					return t1, t2, t3, t4, t5
				end
			end
		else
			for i = 1, 100 do
				local name, _, stack, auraType, duration, expirationTime, _, _, _, spellId, _, _, _, _, _, value = UnitAura(unit, i, "HARMFUL")

				if not spellId then
					return
				elseif not spell then
					local desiredType = ...
					if auraType == desiredType then
						return name, stack, duration, expirationTime
					end
				elseif spellId == spell then
					return name, stack, duration, expirationTime, value
				end
			end
		end
	end
end

--- Check if you're the only person inside an instance, despite being in a group or not.
-- @return boolean
function boss:Solo()
	return solo
end

do
	local GetOptions = C_GossipInfo.GetOptions
	local SelectOption = C_GossipInfo.SelectOption
	--- Request the gossip options of the selected NPC
	-- @return table A table result of all text strings in the form of { result1, result2, result3 }
	function boss:GetGossipOptions()
		local gossipOptions = GetOptions()
		if gossipOptions[1] then
			local gossipTbl = {}
			for i = 1, #gossipOptions do
				gossipTbl[#gossipTbl+1] = gossipOptions[i].name or ""
			end
			return gossipTbl
		end
	end

	--- Select a specific NPC gossip option
	-- @number optionNumber The number of the specific option to be selected
	-- @bool[opt] skipConfirmDialogBox If the pop up confirmation dialog box should be skipped
	function boss:SelectGossipOption(optionNumber, skipConfirmDialogBox)
		SelectOption(optionNumber, "", skipConfirmDialogBox) -- Don't think the text arg is something we will ever need
	end

end

-------------------------------------------------------------------------------
-- Group checking
-- @section group
--

do
	local raidList = { -- Not using a for loop because... REASONS. P.S. I love Torgue.
		"raid1", "raid2", "raid3", "raid4", "raid5", "raid6", "raid7", "raid8", "raid9", "raid10",
		"raid11", "raid12", "raid13", "raid14", "raid15", "raid16", "raid17", "raid18", "raid19", "raid20",
		"raid21", "raid22", "raid23", "raid24", "raid25", "raid26", "raid27", "raid28", "raid29", "raid30",
		"raid31", "raid32", "raid33", "raid34", "raid35", "raid36", "raid37", "raid38", "raid39", "raid40"
	}
	local partyList = {"player", "party1", "party2", "party3", "party4"}
	local GetNumGroupMembers, IsInRaid = GetNumGroupMembers, IsInRaid
	--- Iterate over your group.
	-- Automatically uses "party" or "raid" tokens depending on your group type.
	-- @bool[opt] noInstanceFilter If true then all group units are returned even if they are not in your instance
	-- @return iterator
	function boss:IterateGroup(noInstanceFilter)
		local _, _, _, instanceId = UnitPosition("player")
		local num = GetNumGroupMembers() or 0
		local i = 0
		local size = num > 0 and num+1 or 2
		local function iter(t)
			i = i + 1
			if i < size then
				if not noInstanceFilter then
					local _, _, _, tarInstanceId = UnitPosition(t[i])
					if instanceId ~= tarInstanceId then
						return iter(t)
					end
				end
				return t[i]
			end
		end
		return iter, IsInRaid() and raidList or partyList
	end
end

-------------------------------------------------------------------------------
-- Role checking
-- @section role

do
	local function update(_, _, position, player)
		myGroupRolePositions[player] = position
	end
	LibSpec:Register(BigWigsLoader, update)
end

--- Ask LibSpecialization to update the role positions of everyone in your group.
-- @string[opt="channel"] channel the specific addon comm channel to use, empty for automatic (recommended).
function boss:UpdateRolePositions(channel)
	LibSpec:RequestSpecialization(channel)
end

--- Check if your talent tree role is MELEE.
-- @string[opt="playerName"] playerName check if another player is MELEE.
-- @return boolean
function boss:Melee(playerName)
	if playerName then
		return myGroupRolePositions[playerName] == "MELEE"
	else
		return myRolePosition == "MELEE"
	end
end

--- Check if your talent tree role is RANGED.
-- @string[opt="playerName"] playerName check if another player is RANGED.
-- @return boolean
function boss:Ranged(playerName)
	if playerName then
		return myGroupRolePositions[playerName] == "RANGED"
	else
		return myRolePosition == "RANGED"
	end
end

--- Check if your talent tree role is TANK.
-- @string[opt="player"] unit check if the chosen role of another unit is set to TANK, or if that unit is listed in the MAINTANK frames.
-- @return boolean
function boss:Tank(unit)
	if unit then
		return GetPartyAssignment("MAINTANK", unit) or UnitGroupRolesAssigned(unit) == "TANK"
	else
		return myRole == "TANK"
	end
end

--- Check if you are tanking a specific NPC unit.
-- @string targetUnit the unit token of the NPC you wish to check
-- @string[opt="player"] sourceUnit If a player unit is specified, this unit will be checked to see if they are tanking, otherwise use nil to check yourself
-- @return boolean
function boss:Tanking(targetUnit, sourceUnit)
	return UnitDetailedThreatSituation(sourceUnit or "player", targetUnit)
end

--- Check if you have the highest threat on a specific NPC unit.
-- @string targetUnit the unit token of the NPC you wish to check
-- @string[opt="player"] sourceUnit the specific unit you want to check the threat level of, otherwise use nil to check yourself
-- @return boolean
function boss:TopThreat(targetUnit, sourceUnit)
	local _, status = UnitDetailedThreatSituation(sourceUnit or "player", targetUnit)
	if status == 1 or status == 3 then
		return true
	end
end

--- Check if your talent tree role is HEALER.
-- @string[opt="player"] unit check if the chosen role of another unit is set to HEALER.
-- @return boolean
function boss:Healer(unit)
	if unit then
		return UnitGroupRolesAssigned(unit) == "HEALER"
	else
		return myRole == "HEALER"
	end
end

--- Check if your talent tree role is DAMAGER.
-- @string[opt="player"] unit check if the chosen role of another unit is set to DAMAGER.
-- @return boolean
function boss:Damager(unit)
	if unit then
		return UnitGroupRolesAssigned(unit) == "DAMAGER"
	else
		if myRole == "DAMAGER" then
			return myRolePosition
		end
	end
end

petUtilityFrame:SetScript("OnEvent", function()
	UpdateDispelStatus()
	UpdateInterruptStatus()
end)

do
	local offDispel, defDispel = {}, {}
	function UpdateDispelStatus()
		offDispel, defDispel = {}, {}
		if IsSpellKnown(32375) or IsSpellKnown(528) or IsSpellKnown(370) or IsSpellKnown(30449) or IsSpellKnown(278326) or IsSpellKnown(19505, true) or IsSpellKnown(19801) then
			-- Mass Dispel (Priest), Dispel Magic (Priest), Purge (Shaman), Spellsteal (Mage), Consume Magic (Demon Hunter), Devour Magic (Warlock Felhunter), Tranquilizing Shot (Hunter)
			offDispel.magic = true
		end
		if IsSpellKnown(2908) or IsSpellKnown(19801) or IsSpellKnown(5938) then
			-- Soothe (Druid), Tranquilizing Shot (Hunter), Shiv (Rogue)
			offDispel.enrage = true
		end
		if IsSpellKnown(527) or IsSpellKnown(77130) or IsSpellKnown(115450) or IsSpellKnown(4987) or IsSpellKnown(88423) then -- XXX Add DPS priest mass dispel?
			-- Purify (Heal Priest), Purify Spirit (Heal Shaman), Detox (Heal Monk), Cleanse (Heal Paladin), Nature's Cure (Heal Druid)
			defDispel.magic = true
		end
		if IsSpellKnown(527) or IsSpellKnown(213634) or IsSpellKnown(115450) or IsSpellKnown(218164) or IsSpellKnown(4987) or IsSpellKnown(213644) then
			-- Purify (Heal Priest), Purify Disease (Shadow Priest), Detox (Heal Monk), Detox (DPS Monk), Cleanse (Heal Paladin), Cleanse Toxins (DPS Paladin)
			defDispel.disease = true
		end
		if IsSpellKnown(88423) or IsSpellKnown(115450) or IsSpellKnown(218164) or IsSpellKnown(4987) or IsSpellKnown(2782) or IsSpellKnown(213644) then
			-- Nature's Cure (Heal Druid), Detox (Heal Monk), Detox (DPS Monk), Cleanse (Heal Paladin), Remove Corruption (DPS Druid), Cleanse Toxins (DPS Paladin)
			defDispel.poison = true
		end
		if IsSpellKnown(88423) or IsSpellKnown(2782) or IsSpellKnown(77130) or IsSpellKnown(51886) or IsSpellKnown(475) then
			-- Nature's Cure (Heal Druid), Remove Corruption (DPS Druid), Purify Spirit (Heal Shaman), Cleanse Spirit (DPS Shaman), Remove Curse (Mage)
			defDispel.curse = true
		end
		if IsSpellKnown(1044) or IsSpellKnown(116841) then
			-- Blessing of Freedom (Paladin), Tiger's Lust (Monk)
			defDispel.movement = true
		end
	end
	--- Check if you can dispel.
	-- @string dispelType dispel type (magic, disease, poison, curse, movement)
	-- @bool[opt] isOffensive true if dispelling a buff from an enemy (magic), nil if dispelling a friendly
	-- @param[opt] key module option key to check
	-- @return boolean
	function boss:Dispeller(dispelType, isOffensive, key)
		if key then
			local o = self.db.profile[key]
			if not o then core:Print(format("Module %s uses %q as a dispel lookup, but it doesn't exist in the module options.", self.name, key)) return end
			if band(o, C.DISPEL) ~= C.DISPEL then return true end
		end
		local dispelTable = isOffensive and offDispel or defDispel
		return dispelTable[dispelType]
	end
end

do
	local GetSpellCooldown = GetSpellCooldown
	local canInterrupt = false
	local spellList = {
		106839, -- Skull Bash (Druid)
		78675, -- Solar Beam (Druid-Balance)
		116705, -- Spear Hand Strike (Monk)
		147362, -- Counter Shot (Hunter)
		187707, -- Muzzle (Hunter-Survival)
		57994, -- Wind Shear (Shaman)
		47528, -- Mind Freeze (Death Knight)
		96231, -- Rebuke (Paladin)
		15487, -- Silence (Priest)
		2139, -- Counterspell (Mage)
		1766, -- Kick (Rogue)
		6552, -- Pummel (Warrior)
		183752, -- Disrupt (Demon Hunter)
	}
	function UpdateInterruptStatus()
		if IsSpellKnown(19647, true) then -- Spell Lock (Warlock Felhunter)
			canInterrupt = 19647
			return
		end
		canInterrupt = false
		for i = 1, #spellList do
			local spell = spellList[i]
			if IsSpellKnown(spell) then
				canInterrupt = spell
				break
			end
		end
	end
	--- Check if you can interrupt.
	-- @string[opt] guid if not nil, will only return true if the GUID matches your target or focus.
	-- @return boolean, if the unit can interrupt
	-- @return boolean, if the interrupt is off cooldown and ready to use
	function boss:Interrupter(guid)
		if canInterrupt then
			local ready = true
			local start, duration = GetSpellCooldown(canInterrupt)
			if start > 0 then -- On cooldown currently
				local endTime = start + duration
				local t = GetTime()
				if endTime - t > 1 then -- Greater than 1 second remaining on cooldown, not ready
					ready = false
				end
			end

			if guid then
				if UnitGUID("target") == guid or UnitGUID("focus") == guid then
					return canInterrupt, ready
				end
				return
			end

			return canInterrupt, ready
		end
	end
end

do
	local COMBATLOG_OBJECT_REACTION_HOSTILE = COMBATLOG_OBJECT_REACTION_HOSTILE
	local COMBATLOG_OBJECT_REACTION_FRIENDLY = COMBATLOG_OBJECT_REACTION_FRIENDLY
	local COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER

	--- Check if the unit is hostile.
	-- @string flags unit bit flags
	-- @return boolean if the unit is hostile
	function boss:Hostile(flags)
		return band(flags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE
	end

	--- Check if the unit is friendly.
	-- @string flags unit bit flags
	-- @return boolean if the unit is friendly
	function boss:Friendly(flags)
		return band(flags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == COMBATLOG_OBJECT_REACTION_FRIENDLY
	end

	--- Check if the unit is a player.
	-- @string flags unit bit flags
	-- @return boolean if the unit is a player
	function boss:Player(flags)
		return band(flags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER
	end
end

-------------------------------------------------------------------------------
-- Option flag check
-- @section toggles
--

local checkFlag = nil
do
	local noDefaultError   = "Module %s uses %q as a toggle option, but it does not exist in the modules default values."
	local notNumberError   = "Module %s tried to access %q, but in the database it's a %s."
	local nilKeyError      = "Module %s tried to check the bitflags for a nil option key."
	local invalidFlagError = "Module %s tried to check for an invalid flag type %q (%q). Flags must be bits."
	local noDBError        = "Module %s does not have a .db property, which is weird."
	checkFlag = function(self, key, flag)
		if key == false then return true end -- Allow optionless abilities
		if type(key) == "nil" then core:Print(format(nilKeyError, self.moduleName)) return end
		if type(flag) ~= "number" then core:Print(format(invalidFlagError, self.moduleName, type(flag), tostring(flag))) return end
		if type(self.db) ~= "table" then local msg = format(noDBError, self.moduleName) core:Print(msg) error(msg) return end
		if type(self.db.profile[key]) ~= "number" then
			if not self.toggleDefaults[key] then
				core:Print(format(noDefaultError, self.moduleName, key))
				return
			end
			--if debug then
			--	core:Print(format(notNumberError, self.moduleName, key, type(self.db.profile[key])))
			--	return
			--end
			self.db.profile[key] = self.toggleDefaults[key]
		end

		local fullKey = self.db.profile[key]
		if band(fullKey, C.TANK) == C.TANK and not self:Tank() then return end
		if band(fullKey, C.HEALER) == C.HEALER and not self:Healer() then return end
		if band(fullKey, C.TANK_HEALER) == C.TANK_HEALER and not self:Tank() and not self:Healer() then return end
		return band(fullKey, flag) == flag
	end
	--- Check if an option has a flag set.
	-- @param key the option key
	-- @string flag the option flag
	-- @return boolean
	function boss:CheckOption(key, flag)
		return checkFlag(self, key, C[flag])
	end
end

-------------------------------------------------------------------------------
-- AltPower.
-- @section AltPower
--

--- Open the "Alternate Power" display.
-- @param key the option key to check
-- @param title the title of the window, either a spell id or string
-- @string[opt] sorting "ZA" for descending sort, "AZ" or nil for ascending sort
-- @bool[opt] sync if true, queries values from other players (for use if phasing prevents reliable updates)
function boss:OpenAltPower(key, title, sorting, sync)
	if checkFlag(self, key, C.ALTPOWER) then
		self:SendMessage("BigWigs_ShowAltPower", self, type(title) == "number" and spells[title] or title, sorting == "ZA" and sorting or "AZ", sync)
	end
	if sync then
		self:SendMessage("BigWigs_StartSyncingPower", self)
	end
end

--- Close the "Alternate Power" display.
-- @param[opt] key the option key to check ("altpower" if nil)
function boss:CloseAltPower(key)
	if checkFlag(self, key or "altpower", C.ALTPOWER) then
		self:SendMessage("BigWigs_HideAltPower", self)
	end
end

-------------------------------------------------------------------------------
-- InfoBox.
-- @section InfoBox
--

--- Update a specific line on the "Info Box" display.
-- @param key the option key to check
-- @number line the line to update
-- @string text the new text to show
function boss:SetInfo(key, line, text)
	if checkFlag(self, key, C.INFOBOX) then
		self:SendMessage("BigWigs_SetInfoBoxLine", self, line, text)
	end
end

--- Set the "Info Box" display to show a list of players and their assigned values in ascending order.
-- @param key the option key to check
-- @param[type=table] tbl a table in the format of {player = number}
-- @bool reverseOrder Set as true to sort in reverse (0 before 1)
function boss:SetInfoByTable(key, tbl, reverseOrder)
	if checkFlag(self, key, C.INFOBOX) then
		self:SendMessage("BigWigs_SetInfoBoxTable", self, tbl, reverseOrder)
	end
end

--- Set the "Info Box" display to show a list of players and their assigned values in ascending order with bars counting down a specified duration.
-- @param key the option key to check
-- @param[type=table] tbl a table in the format of {player = {amount, barDuration, startAt}}
-- @bool reverseOrder Set as true to sort in reverse (0 before 1, then by lowest time to expire)
function boss:SetInfoBarsByTable(key, tbl, reverseOrder)
	if checkFlag(self, key, C.INFOBOX) then
		self:SendMessage("BigWigs_SetInfoBoxTableWithBars", self, tbl, reverseOrder)
	end
end

--- Update the title of an already open "Info Box".
-- @param key the option key to check
-- @string title the title of the window
function boss:SetInfoTitle(key, title)
	if checkFlag(self, key, C.INFOBOX) then
		self:SendMessage("BigWigs_SetInfoBoxTitle", self, title)
	end
end

--- Show a background bar in an already open "Info Box".
-- @param key the option key to check
-- @number line the line to update, 1-10
-- @number percentage width of the bar between 0 and 1
-- @number[opt] r red part of rgb, 0-1
-- @number[opt] g green part of rgb, 0-1
-- @number[opt] b blue part of rgb, 0-1
-- @number[opt] a alpha, 0-1
function boss:SetInfoBar(key, line, percentage, r, g, b, a)
	if checkFlag(self, key, C.INFOBOX) then
		self:SendMessage("BigWigs_SetInfoBoxBar", self, line, percentage, r, g, b, a)
	end
end

--- Open the "Info Box" display.
-- @param key the option key to check
-- @string title the title of the window
-- @bool[opt] TEMP
function boss:OpenInfo(key, title, TEMP)
	if checkFlag(self, key, C.INFOBOX) then
		self:SendMessage("BigWigs_ShowInfoBox", self, title, TEMP)
	end
end

--- Close the "Info Box" display.
-- @param key the option key to check
function boss:CloseInfo(key)
	if checkFlag(self, key, C.INFOBOX) then
		self:SendMessage("BigWigs_HideInfoBox", self)
	end
end

-------------------------------------------------------------------------------
-- Proximity.
-- @section proximity
--

--- Open the proximity display.
-- @param key the option key to check
-- @number range the distance to check
-- @param[opt] player the player name for a target proximity or a table containing multiple players
-- @bool[opt] isReverse if true, reverse the logic to warn if not within range
function boss:OpenProximity(key, range, player, isReverse)
	if not solo and checkFlag(self, key, C.PROXIMITY) then
		if type(key) == "number" then
			self:SendMessage("BigWigs_ShowProximity", self, range, key, player, isReverse, spells[key], icons[key])
		else
			self:SendMessage("BigWigs_ShowProximity", self, range, key, player, isReverse)
		end
	end
end

--- Close the proximity display.
-- @param[opt] key the option key to check ("proximity" if nil)
function boss:CloseProximity(key)
	if not solo and checkFlag(self, key or "proximity", C.PROXIMITY) then
		self:SendMessage("BigWigs_HideProximity", self, key or "proximity")
	end
end

-------------------------------------------------------------------------------
-- Nameplates.
-- @section nameplates
--

--- Toggle showing hostile nameplates to the enabled state.
function boss:ShowPlates()
	self:SendMessage("BigWigs_EnableHostileNameplates", self)
end

--- Toggle showing hostile nameplates to the disabled state.
function boss:HidePlates()
	self:SendMessage("BigWigs_DisableHostileNameplates", self)
end

--- Add icon to hostile nameplate.
-- @number spellId the associated spell id
-- @string guid the hostile unit guid
-- @number[opt] duration the duration of the aura
-- @bool[opt] desaturate true if the texture should be desaturated
function boss:AddPlateIcon(spellId, guid, duration, desaturate)
	self:SendMessage("BigWigs_AddNameplateIcon", self, guid, icons[spellId], duration, desaturate)
end

--- Remove icon from hostile nameplate.
-- @number spellId the associated spell id, passing nil removes all icons
-- @string guid the hostile unit guid
function boss:RemovePlateIcon(spellId, guid)
	self:SendMessage("BigWigs_RemoveNameplateIcon", self, guid, spellId and icons[spellId])
end

-------------------------------------------------------------------------------
-- Messages.
-- @section messages
--

--- Cancel a delayed message.
-- @string text the text of the message to cancel
function boss:CancelDelayedMessage(text)
	if self.scheduledMessages and self.scheduledMessages[text] then
		self:CancelTimer(self.scheduledMessages[text])
		self.scheduledMessages[text] = nil
	end
end

--- Schedule a delayed message.
-- The messages are keyed by their text, so scheduling the same message will
-- overwrite the previous message's delay.
-- @param key the option key
-- @number delay the delay in seconds
-- @string color the message color category
-- @param[opt] text the message text (if nil, key is used)
-- @param[opt] icon the message icon (spell id or texture name)
-- @string[opt] sound the message sound
function boss:DelayedMessage(key, delay, color, text, icon, sound)
	if checkFlag(self, key, C.MESSAGE) then
		self:CancelDelayedMessage(text or key)
		if not self.scheduledMessages then self.scheduledMessages = {} end
		self.scheduledMessages[text or key] = self:ScheduleTimer("MessageOld", delay, key, color, sound, text, icon or false)
	end
end

--- Display a colored message.
-- @param key the option key
-- @string color the message color category
-- @string[opt] sound the message sound
-- @param[opt] text the message text (if nil, key is used)
-- @param[opt] icon the message icon (spell id or texture name)
function boss:MessageOld(key, color, sound, text, icon)
	if checkFlag(self, key, C.MESSAGE) then
		local textType = type(text)

		local isEmphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE
		self:SendMessage("BigWigs_Message", self, key, textType == "string" and text or spells[text or key], color, icon ~= false and icons[icon or textType == "number" and text or key], isEmphasized)
		if sound then
			if hasVoice and checkFlag(self, key, C.VOICE) then
				self:SendMessage("BigWigs_Voice", self, key, sound)
			else
				self:SendMessage("BigWigs_Sound", self, key, sound)
			end
		end
	end
end

function boss:Message(key, color, text, icon)
	if checkFlag(self, key, C.MESSAGE) then
		local isEmphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE
		self:SendMessage("BigWigs_Message", self, key, type(text) == "string" and text or spells[text or key], color, icon ~= false and icons[icon or key], isEmphasized)
	end
end

--- Display a personal message in blue.
-- @param key the option key
-- @param[opt] localeString if nil then the "%s on YOU" string will be used, if false then the text field will be printed directly, otherwise the common locale will be referenced via CL[localeString]
-- @param[opt] text the message text (if nil, key is used)
-- @param[opt] icon the message icon (spell id or texture name)
function boss:PersonalMessage(key, localeString, text, icon)
	if checkFlag(self, key, C.MESSAGE) then
		local str = localeString and L[localeString] or L.you
		local msg = localeString == false and text or format(str, type(text) == "string" and text or spells[text or key])
		local isEmphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE or band(self.db.profile[key], C.ME_ONLY_EMPHASIZE) == C.ME_ONLY_EMPHASIZE
		self:SendMessage("BigWigs_Message", self, key, msg, "blue", icon ~= false and icons[icon or key], isEmphasized)
	end
end

do
	local hexColors = {}
	for k, v in next, (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS) do
		hexColors[k] = format("|cff%02x%02x%02x", v.r * 255, v.g * 255, v.b * 255)
	end
	local coloredNames = setmetatable({}, {__index =
		function(self, key)
			if key then
				local shortKey = gsub(key, "%-.+", "*") -- Replace server names with *
				local _, class = UnitClass(key)
				if class then
					local newKey = hexColors[class] .. shortKey .. "|r"
					self[key] = newKey
					return newKey
				else
					return shortKey
				end
			end
		end
	})
	cpName = coloredNames[pName]

	local mt = {
		__newindex = function(self, key, value)
			rawset(self, key, coloredNames[value])
		end
	}
	--- Get a table that colors player names based on class.
	-- @return an empty table
	function boss:NewTargetList()
		return setmetatable({}, mt)
	end

	--- Color a player name based on class.
	-- @param player The player name, or a table containing a list of names
	-- @bool[opt] overwrite Ignore whatever the "class color message" feature is set to
	-- @return colored player name, or table containing colored names
	function boss:ColorName(player, overwrite)
		if classColorMessages or overwrite then
			if type(player) == "table" then
				local tmp = {}
				for i = 1, #player do
					tmp[i] = coloredNames[player[i]]
				end
				return tmp
			else
				return coloredNames[player]
			end
		else
			if type(player) == "table" then
				local tmp = {}
				for i = 1, #player do
					tmp[i] = gsub(player[i], "%-.+", "*") -- Replace server names with *
				end
				return tmp
			else
				return gsub(player, "%-.+", "*") -- Replace server names with *
			end
		end
	end

	--- Display a buff/debuff stack warning message.
	-- @param key the option key
	-- @string player the player to display
	-- @number stack the stack count
	-- @string color the message color category
	-- @string[opt] sound the message sound
	-- @param[opt] text the message text (if nil, key is used)
	-- @param[opt] icon the message icon (spell id or texture name)
	function boss:StackMessage(key, player, stack, color, sound, text, icon)
		if checkFlag(self, key, C.MESSAGE) then
			local textType = type(text)
			if player == pName then
				local isEmphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE or band(self.db.profile[key], C.ME_ONLY_EMPHASIZE) == C.ME_ONLY_EMPHASIZE
				self:SendMessage("BigWigs_Message", self, key, format(L.stackyou, stack or 1, textType == "string" and text or spells[text or key]), "blue", icon ~= false and icons[icon or textType == "number" and text or key], isEmphasized)
			elseif not checkFlag(self, key, C.ME_ONLY) then
				local isEmphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE
				self:SendMessage("BigWigs_Message", self, key, format(L.stack, stack or 1, textType == "string" and text or spells[text or key], self:ColorName(player)), color, icon ~= false and icons[icon or textType == "number" and text or key], isEmphasized)
			end
			if sound then
				if hasVoice and checkFlag(self, key, C.VOICE) then
					self:SendMessage("BigWigs_Voice", self, key, sound)
				else
					self:SendMessage("BigWigs_Sound", self, key, sound)
				end
			end
		end
	end

	--- Display a buff/debuff stack warning message.
	-- @param key the option key
	-- @string color the message color category
	-- @string player the player to display
	-- @number stack the stack count
	-- @number[opt] noEmphUntil prevent the emphasize function taking effect until this amount of stacks has been reached
	-- @param[opt] text the message text (if nil, key is used)
	-- @param[opt] icon the message icon (spell id or texture name)
	function boss:NewStackMessage(key, color, player, stack, noEmphUntil, text, icon)
		if checkFlag(self, key, C.MESSAGE) then
			local textType = type(text)
			local emphLimit = noEmphUntil or 0
			local amount = stack or 1
			if player == pName then
				local isEmphasized = (band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE or band(self.db.profile[key], C.ME_ONLY_EMPHASIZE) == C.ME_ONLY_EMPHASIZE) and amount >= emphLimit
				self:SendMessage("BigWigs_Message", self, key, format(L.stackyou, amount, textType == "string" and text or spells[text or key]), "blue", icon ~= false and icons[icon or textType == "number" and text or key], isEmphasized)
			elseif not checkFlag(self, key, C.ME_ONLY) then
				local isEmphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE and amount >= emphLimit
				self:SendMessage("BigWigs_Message", self, key, format(L.stack, amount, textType == "string" and text or spells[text or key], self:ColorName(player)), color, icon ~= false and icons[icon or textType == "number" and text or key], isEmphasized)
			end
		end
	end

	--- Display a target message.
	-- @param key the option key
	-- @string player the player to display
	-- @string color the message color category
	-- @string[opt] sound the message sound
	-- @param[opt] text the message text (if nil, key is used)
	-- @param[opt] icon the message icon (spell id or texture name)
	-- @bool[opt] alwaysPlaySound if true, play the sound even if player is not you
	function boss:TargetMessageOld(key, player, color, sound, text, icon, alwaysPlaySound)
		local textType = type(text)
		local msg = textType == "string" and text or spells[text or key]
		local texture = icon ~= false and icons[icon or textType == "number" and text or key]

		if type(player) == "table" then
			local list = table.concat(player, ", ")
			local meOnly = checkFlag(self, key, C.ME_ONLY)
			local onMe = find(list, pName, nil, true)
			if not onMe then
				if not checkFlag(self, key, C.MESSAGE) or meOnly then twipe(player) return end
				if not alwaysPlaySound then sound = nil end
			else
				if not checkFlag(self, key, C.MESSAGE) and not meOnly then twipe(player) return end
			end
			if meOnly or (onMe and #player == 1) then
				local isEmphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE or band(self.db.profile[key], C.ME_ONLY_EMPHASIZE) == C.ME_ONLY_EMPHASIZE
				self:SendMessage("BigWigs_Message", self, key, format(L.you, msg), "blue", texture, isEmphasized)
			else
				local isEmphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE
				self:SendMessage("BigWigs_Message", self, key, format(L.other, msg, list), color, texture, isEmphasized)
			end
			if sound then
				if hasVoice and checkFlag(self, key, C.VOICE) then
					self:SendMessage("BigWigs_Voice", self, key, sound)
				else
					self:SendMessage("BigWigs_Sound", self, key, sound)
				end
			end
			twipe(player)
		else
			if not player then
				if checkFlag(self, key, C.MESSAGE) then
					local isEmphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE
					self:SendMessage("BigWigs_Message", self, key, format(L.other, msg, "???"), color, texture, isEmphasized)
					if alwaysPlaySound then
						self:SendMessage("BigWigs_Sound", self, key, sound)
					end
				end
				return
			end
			if player == pName then
				if checkFlag(self, key, C.MESSAGE) or checkFlag(self, key, C.ME_ONLY) then
					local isEmphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE or band(self.db.profile[key], C.ME_ONLY_EMPHASIZE) == C.ME_ONLY_EMPHASIZE
					self:SendMessage("BigWigs_Message", self, key, format(L.you, msg), "blue", texture, isEmphasized)
					if sound then
						if hasVoice and checkFlag(self, key, C.VOICE) then
							self:SendMessage("BigWigs_Voice", self, key, sound, true)
						else
							self:SendMessage("BigWigs_Sound", self, key, sound)
						end
					end
				end
			else
				if checkFlag(self, key, C.MESSAGE) and not checkFlag(self, key, C.ME_ONLY) then
					local isEmphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE
					-- Change color and remove sound (if not alwaysPlaySound) when warning about effects on other players
					self:SendMessage("BigWigs_Message", self, key, format(L.other, msg, self:ColorName(player)), color, texture, isEmphasized)
					if sound then
						if alwaysPlaySound and hasVoice and checkFlag(self, key, C.VOICE) then
							self:SendMessage("BigWigs_Voice", self, key, sound)
						elseif alwaysPlaySound then
							self:SendMessage("BigWigs_Sound", self, key, sound)
						end
					end
				end
			end
		end
	end

	local markerIcons = {
		"|T137001:0|t",
		"|T137002:0|t",
		"|T137003:0|t",
		"|T137004:0|t",
		"|T137005:0|t",
		"|T137006:0|t",
		"|T137007:0|t",
		"|T137008:0|t",
	}
	local comma = (GetLocale() == "zhTW" or GetLocale() == "zhCN") and "，" or ", "
	local tconcat = table.concat
	do
		local function printTargets(self, key, playerTable, color, text, icon, markers)
			local playersInTable = #playerTable
			if playersInTable ~= 0 then -- Might fire twice (1st from timer, 2nd from reaching max playerCount)
				local textType = type(text)
				local msg = textType == "string" and text or spells[text or key]
				local texture = icon ~= false and icons[icon or textType == "number" and text or key]

				if playersInTable == 1 and playerTable[1] == cpName then
					local meEmphasized = band(self.db.profile[key], C.ME_ONLY_EMPHASIZE) == C.ME_ONLY_EMPHASIZE
					if not meEmphasized then -- We already did a ME_ONLY_EMPHASIZE print in :TargetsMessage
						local emphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE
						if markers then
							self:SendMessage("BigWigs_Message", self, key, format(L.you_icon, msg, markers[1]), "blue", texture, emphasized)
						else
							self:SendMessage("BigWigs_Message", self, key, format(L.you, msg), "blue", texture, emphasized)
						end
					end
				else
					if markers then
						for i = 1, playersInTable do
							playerTable[i] = markerIcons[markers[i]] .. playerTable[i]
						end
					end
					local list = tconcat(playerTable, comma, 1, playersInTable)
					-- Don't Emphasize if it's on other people when both EMPHASIZE and ME_ONLY_EMPHASIZE are enabled.
					local isEmphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE and band(self.db.profile[key], C.ME_ONLY_EMPHASIZE) ~= C.ME_ONLY_EMPHASIZE
					self:SendMessage("BigWigs_Message", self, key, format(L.other, msg, list), color, texture, isEmphasized)
				end
				twipe(playerTable)
				if markers then
					twipe(markers)
				end
			end
		end

		--- Display a target message of multiple players using a table.
		-- @param key the option key
		-- @string color the message color category
		-- @param playerTable a table containing the list of players
		-- @number playerCount the max amount of players you expect to be included, message will instantly print when this max is reached
		-- @param[opt] text the message text (if nil, key is used)
		-- @param[opt] icon the message icon (spell id or texture name, key is used if nil)
		-- @number[opt] customTime how long to wait to reach the max players in the table. If the max is not reached, it will print after this value (0.3s is used if nil)
		-- @param[opt] markers a table containing the markers that should be attached next to the player names e.g. {1, 2, 3}
		function boss:TargetsMessage(key, color, playerTable, playerCount, text, icon, customTime, markers)
			local playersInTable = #playerTable
			if band(self.db.profile[key], C.ME_ONLY) == C.ME_ONLY then -- We allow ME_ONLY even if MESSAGE off
				if playerTable[playersInTable] == cpName and checkFlag(self, key, C.ME_ONLY) then -- Use checkFlag for the role check
					local isEmphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE or band(self.db.profile[key], C.ME_ONLY_EMPHASIZE) == C.ME_ONLY_EMPHASIZE
					local textType = type(text)
					local msg = textType == "string" and text or spells[text or key]
					local texture = icon ~= false and icons[icon or textType == "number" and text or key]
					if markers then
						self:SendMessage("BigWigs_Message", self, key, format(L.you_icon, msg, markers[playersInTable]), "blue", texture, isEmphasized)
					else
						self:SendMessage("BigWigs_Message", self, key, format(L.you, msg), "blue", texture, isEmphasized)
					end
				end
				if playersInTable == playerCount then
					twipe(playerTable)
					if markers then twipe(markers) end
				elseif playersInTable == 1 then
					Timer(customTime or 0.3, function()
						twipe(playerTable)
						if markers then twipe(markers) end
					end)
				end
			elseif checkFlag(self, key, C.MESSAGE) then
				if playerTable[playersInTable] == cpName and band(self.db.profile[key], C.ME_ONLY_EMPHASIZE) == C.ME_ONLY_EMPHASIZE then
					local textType = type(text)
					local msg = textType == "string" and text or spells[text or key]
					local texture = icon ~= false and icons[icon or textType == "number" and text or key]
					if markers then
						self:SendMessage("BigWigs_Message", self, key, format(L.you_icon, msg, markers[playersInTable]), "blue", texture, true)
					else
						self:SendMessage("BigWigs_Message", self, key, format(L.you, msg), "blue", texture, true)
					end
				end
				if playersInTable == playerCount then
					printTargets(self, key, playerTable, color, text, icon, markers)
				elseif playersInTable == 1 then
					Timer(customTime or 0.3, function()
						printTargets(self, key, playerTable, color, text, icon, markers)
					end)
				end
			else
				if playersInTable == playerCount then
					twipe(playerTable)
					if markers then twipe(markers) end
				elseif playersInTable == 1 then
					Timer(customTime or 0.3, function()
						twipe(playerTable)
						if markers then twipe(markers) end
					end)
				end
			end
		end
	end

	do
		local function printTargets(self, key, playerTable, color, text, icon)
			local playersInTable = #playerTable
			if not playerTable.prevPlayersInTable or playerTable.prevPlayersInTable ~= playersInTable then
				local textType = type(text)
				local msg = textType == "string" and text or spells[text or key]
				local texture = icon ~= false and icons[icon or textType == "number" and text or key]

				local previousAmount = playerTable.prevPlayersInTable or 0
				if playersInTable-previousAmount == 1 and playerTable[playersInTable] == pName then
					local meEmphasized = band(self.db.profile[key], C.ME_ONLY_EMPHASIZE) == C.ME_ONLY_EMPHASIZE
					if not meEmphasized then -- We already did a ME_ONLY_EMPHASIZE print in :TargetsMessage
						local emphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE
						local marker = playerTable[pName]
						if marker then
							self:SendMessage("BigWigs_Message", self, key, format(L.you_icon, msg, marker), "blue", texture, emphasized)
						else
							self:SendMessage("BigWigs_Message", self, key, format(L.you, msg), "blue", texture, emphasized)
						end
					end
				else
					local startFromEntry = previousAmount+1
					local tbl = {}
					for i = startFromEntry, playersInTable do
						local name = playerTable[i]
						local hasMarker = playerTable[name]
						if hasMarker then
							tbl[#tbl+1] = markerIcons[hasMarker] .. self:ColorName(name)
						else
							tbl[#tbl+1] = self:ColorName(playerTable[i])
						end
					end
					local list = tconcat(tbl, comma, 1, #tbl)
					-- Don't Emphasize if it's on other people when both EMPHASIZE and ME_ONLY_EMPHASIZE are enabled.
					local isEmphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE and band(self.db.profile[key], C.ME_ONLY_EMPHASIZE) ~= C.ME_ONLY_EMPHASIZE
					self:SendMessage("BigWigs_Message", self, key, format(L.other, msg, list), color, texture, isEmphasized)
				end
				playerTable.prevPlayersInTable = playersInTable
			end
		end

		function boss:NewTargetsMessage(key, color, playerTable, playerCount, text, icon, customTime)
			local playersInTable = #playerTable
			if band(self.db.profile[key], C.ME_ONLY) == C.ME_ONLY then -- We allow ME_ONLY even if MESSAGE off
				if playerTable[playersInTable] == pName and checkFlag(self, key, C.ME_ONLY) then -- Use checkFlag for the role check
					local isEmphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE or band(self.db.profile[key], C.ME_ONLY_EMPHASIZE) == C.ME_ONLY_EMPHASIZE
					local textType = type(text)
					local msg = textType == "string" and text or spells[text or key]
					local texture = icon ~= false and icons[icon or textType == "number" and text or key]
					local marker = playerTable[pName]
					if marker then
						self:SendMessage("BigWigs_Message", self, key, format(L.you_icon, msg, marker), "blue", texture, isEmphasized)
					else
						self:SendMessage("BigWigs_Message", self, key, format(L.you, msg), "blue", texture, isEmphasized)
					end
				end
			elseif checkFlag(self, key, C.MESSAGE) then
				if playerTable[playersInTable] == pName and band(self.db.profile[key], C.ME_ONLY_EMPHASIZE) == C.ME_ONLY_EMPHASIZE then
					local textType = type(text)
					local msg = textType == "string" and text or spells[text or key]
					local texture = icon ~= false and icons[icon or textType == "number" and text or key]
					local marker = playerTable[pName]
					if marker then
						self:SendMessage("BigWigs_Message", self, key, format(L.you_icon, msg, marker), "blue", texture, true)
					else
						self:SendMessage("BigWigs_Message", self, key, format(L.you, msg), "blue", texture, true)
					end
				end
				local playersAddedSinceLastPrint = playersInTable - (playerTable.prevPlayersInTable or 0)
				if playersAddedSinceLastPrint == playerCount then
					printTargets(self, key, playerTable, color, text, icon)
				elseif playersAddedSinceLastPrint == 1 then
					Timer(customTime or 0.3, function()
						printTargets(self, key, playerTable, color, text, icon)
					end)
				end
			end
		end
	end

	--- Display a target message of a single player.
	-- @param key the option key
	-- @string color the message color category
	-- @string player the player name
	-- @param[opt] text the message text (if nil, key is used)
	-- @param[opt] icon the message icon (spell id or texture name, key is used if nil)
	function boss:TargetMessage(key, color, player, text, icon)
		local textType = type(text)
		local msg = textType == "string" and text or spells[text or key]
		local texture = icon ~= false and icons[icon or textType == "number" and text or key]

		if not player then
			if checkFlag(self, key, C.MESSAGE) then
				local isEmphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE
				self:SendMessage("BigWigs_Message", self, key, format(L.other, msg, "???"), color, texture, isEmphasized)
			end
		elseif player == pName then
			if checkFlag(self, key, C.MESSAGE) or checkFlag(self, key, C.ME_ONLY) then
				local isEmphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE or band(self.db.profile[key], C.ME_ONLY_EMPHASIZE) == C.ME_ONLY_EMPHASIZE
				self:SendMessage("BigWigs_Message", self, key, format(L.you, msg), "blue", texture, isEmphasized)
			end
		elseif checkFlag(self, key, C.MESSAGE) and not checkFlag(self, key, C.ME_ONLY) then
			-- Don't Emphasize if it's on other people when both EMPHASIZE and ME_ONLY_EMPHASIZE are enabled.
			local isEmphasized = band(self.db.profile[key], C.EMPHASIZE) == C.EMPHASIZE and band(self.db.profile[key], C.ME_ONLY_EMPHASIZE) ~= C.ME_ONLY_EMPHASIZE
			self:SendMessage("BigWigs_Message", self, key, format(L.other, msg, self:ColorName(player)), color, texture, isEmphasized)
		end
	end
end

-------------------------------------------------------------------------------
-- Bars.
-- @section bars
--

do
	local badBar = "Attempted to start bar %q without a valid time."
	local badTargetBar = "Attempted to start target bar %q without a valid time."
	local badNameplateBarStart = "Attempted to start nameplate bar %q without a valid unitGUID."
	local badNameplateBarStop = "Attempted to stop nameplate bar %q without a valid unitGUID."
	local badNameplateBarTimeLeft = "Attempted to get time left of nameplate bar %q without a valid unitGUID."
	local newBar = "New timer for %q at stage %d with placement %d and value %.2f on %d running ".. BigWigsLoader:GetVersionString() ..", tell the authors."

	--- Display a bar.
	-- @param key the option key
	-- @number length the bar duration in seconds
	-- @param[opt] text the bar text (if nil, key is used)
	-- @param[opt] icon the bar icon (spell id or texture name)
	function boss:Bar(key, length, text, icon)
		if not length then
			if not self.missing then self.missing = {} end
			if not self.missing[key] then
				local t = GetTime()
				self.missing[key] = {t}
			else
				local t, c = GetTime(), #self.missing[key]
				local new = t - self.missing[key][c]
				core:Print(format(newBar, key, self.stage or 0, c, new, self:Difficulty()))
				self.missing[key][c+1] = t
			end
			return
		elseif type(length) ~= "number" then
			core:Print(format(badBar, key))
			return
		elseif length == 0 then
			return
		elseif self.missing and self.missing[key] then
			self.missing[key] = nil
		end

		local textType = type(text)
		local msg = textType == "string" and text or spells[text or key]
		if checkFlag(self, key, C.BAR) then
			self:SendMessage("BigWigs_StartBar", self, key, msg, length, icons[icon or textType == "number" and text or key])
		end
		if checkFlag(self, key, C.COUNTDOWN) then
			self:SendMessage("BigWigs_StartCountdown", self, key, msg, length)
		end
	end

	--- Display a cooldown bar.
	-- Indicates an unreliable duration by prefixing the time with "~"
	-- @param key the option key
	-- @number length the bar duration in seconds
	-- @param[opt] text the bar text (if nil, key is used)
	-- @param[opt] icon the bar icon (spell id or texture name)
	function boss:CDBar(key, length, text, icon)
		if not length then
			if not self.missing then self.missing = {} end
			if not self.missing[key] then
				local t = GetTime()
				self.missing[key] = {t}
			else
				local t, c = GetTime(), #self.missing[key]
				local new = t - self.missing[key][c]
				core:Print(format(newBar, key, self.stage or 0, c, new, self:Difficulty()))
				self.missing[key][c+1] = t
			end
			return
		elseif type(length) ~= "number" then
			core:Print(format(badBar, key))
			return
		elseif length == 0 then
			return
		elseif self.missing and self.missing[key] then
			self.missing[key] = nil
		end

		local textType = type(text)
		local msg = textType == "string" and text or spells[text or key]
		if checkFlag(self, key, C.BAR) then
			self:SendMessage("BigWigs_StartBar", self, key, msg, length, icons[icon or textType == "number" and text or key], true)
		end
		if checkFlag(self, key, C.COUNTDOWN) then
			self:SendMessage("BigWigs_StartCountdown", self, key, msg, length)
		end
	end

	--- Display a target bar.
	-- @param key the option key
	-- @number length the bar duration in seconds
	-- @string player the player name to show on the bar
	-- @param[opt] text the bar text (if nil, key is used)
	-- @param[opt] icon the bar icon (spell id or texture name)
	function boss:TargetBar(key, length, player, text, icon)
		if type(length) ~= "number" or length == 0 then
			core:Print(format(badTargetBar, key))
			return
		end

		local textType = type(text)
		if not player and checkFlag(self, key, C.BAR) then
			self:SendMessage("BigWigs_StartBar", self, key, format(L.other, textType == "string" and text or spells[text or key], "???"), length, icons[icon or textType == "number" and text or key])
			return
		end
		if player == pName then
			local msg = format(L.you, textType == "string" and text or spells[text or key])
			if checkFlag(self, key, C.BAR) then
				self:SendMessage("BigWigs_StartBar", self, key, msg, length, icons[icon or textType == "number" and text or key])
			end
			if checkFlag(self, key, C.COUNTDOWN) then
				self:SendMessage("BigWigs_StartCountdown", self, key, msg, length)
			end
		elseif not checkFlag(self, key, C.ME_ONLY) and checkFlag(self, key, C.BAR) then
			self:SendMessage("BigWigs_StartBar", self, key, format(L.other, textType == "string" and text or spells[text or key], gsub(player, "%-.+", "*")), length, icons[icon or textType == "number" and text or key])
		end
	end

	--- Display a cast bar.
	-- @param key the option key
	-- @number length the bar duration in seconds
	-- @param[opt] text the bar text (if nil, key is used)
	-- @param[opt] icon the bar icon (spell id or texture name)
	function boss:CastBar(key, length, text, icon)
		if type(length) ~= "number" or length == 0 then
			core:Print(format(badBar, key))
			return
		end

		local textType = type(text)
		local msg = format(L.cast, textType == "string" and text or spells[text or key])
		if checkFlag(self, key, C.CASTBAR) then
			self:SendMessage("BigWigs_StartBar", self, key, msg, length, icons[icon or textType == "number" and text or key])
			if checkFlag(self, key, C.COUNTDOWN) then
				self:SendMessage("BigWigs_StartCountdown", self, key, msg, length)
			end
		end
	end

	--- Display a nameplate bar.
	-- @param key the option key
	-- @number length the bar duration in seconds
	-- @string guid Anchor to a unit's nameplate by GUID
	-- @param[opt] text the bar text (if nil, key is used)
	-- @param[opt] icon the bar icon (spell id or texture name)
	function boss:NameplateBar(key, length, guid, text, icon)
		if type(length) ~= "number" or length == 0 then
			core:Print(format(badBar, key))
			return
		end
		if type(guid) ~= "string" then
			core:Print(format(badNameplateBarStart, key))
			return
		end
		local textType = type(text)
		if checkFlag(self, key, C.NAMEPLATEBAR) then
			local msg = type(text) == "string" and text or spells[text or key]
			self:SendMessage("BigWigs_StartNameplateBar", self, key, msg, length, icons[icon or type(text) == "number" and text or key], false, guid)
		end
	end

	--- Display a nameplate cooldown bar.
	-- Indicates an unreliable duration by prefixing the time with "~"
	-- @param key the option key
	-- @number length the bar duration in seconds
	-- @string guid Anchor to a unit's nameplate by GUID
	-- @param[opt] text the bar text (if nil, key is used)
	-- @param[opt] icon the bar icon (spell id or texture name)
	function boss:NameplateCDBar(key, length, guid, text, icon)
		if type(length) ~= "number" or length == 0 then
			core:Print(format(badBar, key))
			return
		end
		if type(guid) ~= "string" then
			core:Print(format(badNameplateBarStart, key))
			return
		end
		local textType = type(text)
		if checkFlag(self, key, C.NAMEPLATEBAR) then
			local msg = type(text) == "string" and text or spells[text or key]
			self:SendMessage("BigWigs_StartNameplateBar", self, key, msg, length, icons[icon or type(text) == "number" and text or key], true, guid)
		end
	end

	--- Pause a nameplate bar.
	-- @param key the option key
	-- @param guid nameplate unit's guid
	-- @param[opt] text the bar text
	function boss:PauseNameplateBar(key, guid, text)
		if type(guid) ~= "string" then
			core:Print(format(badNameplateBarStop, key))
		end
		local msg = text or spells[key]
		self:SendMessage("BigWigs_PauseNameplateBar", self, msg, guid)
	end

	--- Resume a paused nameplate bar.
	-- @param key the option key
	-- @param guid nameplate unit's guid
	-- @param[opt] text the bar text
	function boss:ResumeNameplateBar(key, guid, text)
		if type(guid) ~= "string" then
			core:Print(format(badNameplateBarStart, key))
		end
		local msg = text or spells[key]
		self:SendMessage("BigWigs_ResumeNameplateBar", self, msg, guid)
	end

	--- Get the time left for a running nameplate bar.
	-- @param text the bar text
	-- @param guid nameplate unit's guid
	-- @return the remaining duration in seconds or 0
	function boss:NameplateBarTimeLeft(text, guid)
		if type(guid) ~= "string" then
			core:Print(format(badNameplateBarTimeLeft, text))
		end
		local bars = core:GetPlugin("Bars", true)
		if bars then
			return bars:GetNameplateBarTimeLeft(self, type(text) == "number" and spells[text] or text, guid)
		end
		return 0
	end

	--- Stop a nameplate bar.
	-- @param text the bar text, or a spellId which is converted into the spell name and used
	-- @string guid nameplate unit's guid
	function boss:StopNameplateBar(text, guid)
		if type(guid) ~= "string" then
			core:Print(format(badNameplateBarStop, text))
		end
		local msg = type(text) == "number" and spells[text] or text
		self:SendMessage("BigWigs_StopNameplateBar", self, msg, guid)
	end
end

--- Stop a bar.
-- @param text the bar text, or a spellId which is converted into the spell name and used
-- @string[opt] player the player name if stopping a target bar
function boss:StopBar(text, player)
	local msg = type(text) == "number" and spells[text] or text
	if player then
		if player == pName then
			msg = format(L.you, msg)
			self:SendMessage("BigWigs_StopBar", self, msg)
			self:SendMessage("BigWigs_StopCountdown", self, msg)
		else
			self:SendMessage("BigWigs_StopBar", self, format(L.other, msg, gsub(player, "%-.+", "*")))
		end
	else
		self:SendMessage("BigWigs_StopBar", self, msg)
		self:SendMessage("BigWigs_StopCountdown", self, msg)
	end
end

--- Pause a bar.
-- @param key the option key
-- @param[opt] text the bar text
function boss:PauseBar(key, text)
	local msg = text or spells[key]
	self:SendMessage("BigWigs_PauseBar", self, msg)
	self:SendMessage("BigWigs_StopCountdown", self, msg)
end

--- Resume a paused bar.
-- @param key the option key
-- @param[opt] text the bar text
function boss:ResumeBar(key, text)
	local msg = text or spells[key]
	self:SendMessage("BigWigs_ResumeBar", self, msg)
	if checkFlag(self, key, C.COUNTDOWN) then
		local length = self:BarTimeLeft(msg)
		if length > 0 then
			self:SendMessage("BigWigs_StartCountdown", self, key, msg, length)
		end
	end
end

--- Get the time left for a running bar.
-- @param text the bar text
-- @return the remaining duration in seconds or 0
function boss:BarTimeLeft(text)
	local bars = core:GetPlugin("Bars", true)
	if bars then
		return bars:GetBarTimeLeft(self, type(text) == "number" and spells[text] or text)
	end
	return 0
end

-------------------------------------------------------------------------------
-- Icons.
-- @section icons
--

--- Set the primary (skull by default) raid target icon. No icon will be set if the player already has one on them.
-- @param key the option key
-- @string[opt] player the player to mark (if nil, the icon is removed)
function boss:PrimaryIcon(key, player)
	if key and not checkFlag(self, key, C.ICON) then return end
	if not player then
		self:SendMessage("BigWigs_RemoveRaidIcon", 1)
	else
		self:SendMessage("BigWigs_SetRaidIcon", player, 1)
	end
end

--- Set the secondary (cross by default) raid target icon. No icon will be set if the player already has one on them.
-- @param key the option key
-- @string[opt] player the player to mark (if nil, the icon is removed)
function boss:SecondaryIcon(key, player)
	if key and not checkFlag(self, key, C.ICON) then return end
	if not player then
		self:SendMessage("BigWigs_RemoveRaidIcon", 2)
	else
		self:SendMessage("BigWigs_SetRaidIcon", player, 2)
	end
end

--- Directly set any raid target icon on a unit based on a custom option key.
-- @param key the option key
-- @string unit the unit (player/npc) to mark
-- @number[opt] icon the icon to mark the player with, numbering from 1-8 (if nil, the icon is removed)
function boss:CustomIcon(key, unit, icon)
	if key == false or self:GetOption(key) then
		if solo then -- setting the same icon twice while not in a group removes it
			SetRaidTarget(unit, 0)
		end
		SetRaidTarget(unit, icon or 0)
	end
end

-------------------------------------------------------------------------------
-- Chat.
-- @section chat
--

--- Send a message in SAY. Generally used for abilities where you need to spread out or run away.
-- @param key the option key
-- @param msg the message to say (if nil, key is used)
-- @bool[opt] directPrint if true, skip formatting the message and print the string directly to chat.
function boss:Say(key, msg, directPrint)
	if not checkFlag(self, key, C.SAY) then return end
	if directPrint then
		SendChatMessage(msg, "SAY")
	else
		SendChatMessage(format(L.on, msg and (type(msg) == "number" and spells[msg] or msg) or spells[key], pName), "SAY")
	end
end

--- Send a message in YELL. Generally used for abilities where you need to group up.
-- @param key the option key
-- @param msg the message to yell (if nil, key is used)
-- @bool[opt] directPrint if true, skip formatting the message and print the string directly to chat.
function boss:Yell(key, msg, directPrint)
	if not checkFlag(self, key, C.SAY) then return end
	if directPrint then
		SendChatMessage(msg, "YELL")
	else
		SendChatMessage(format(L.on, msg and (type(msg) == "number" and spells[msg] or msg) or spells[key], pName), "YELL")
	end
end

--- Cancel a countdown using say messages.
-- @param key the option key
function boss:CancelSayCountdown(key)
	if not checkFlag(self, key, C.SAY_COUNTDOWN) then return end
	local tbl = self.sayCountdowns[key]
	if tbl then
		tbl[1] = true
	end
end

--- Cancel a countdown using yell messages.
-- @param key the option key
function boss:CancelYellCountdown(key)
	if not checkFlag(self, key, C.SAY_COUNTDOWN) then return end
	local tbl = self.sayCountdowns[key]
	if tbl then
		tbl[1] = true
	end
end

do
	local iconList = {
		"{rt1}","{rt2}","{rt3}","{rt4}","{rt5}","{rt6}","{rt7}","{rt8}",
	}
	--- Start a countdown using say messages. Generally used for abilities where you need to spread out or run away.
	-- @param key the option key
	-- @number seconds the amount of time in seconds until the countdown expires
	-- @param[opt] textOrIcon Attach additional text to the countdown if passed a text string, attach a raid icon if passed a number [1-8]
	-- @number[opt] startAt When to start sending messages in say, default value is at 3 seconds remaining
	function boss:SayCountdown(key, seconds, textOrIcon, startAt)
		if not checkFlag(self, key, C.SAY_COUNTDOWN) then return end
		local start = startAt or 3
		local tbl = {false}
		local text = type(textOrIcon) == "number" and iconList[textOrIcon] or textOrIcon
		local function printTime()
			if not tbl[1] then
				SendChatMessage(text and format("%s %d", text, start) or start, "SAY")
				start = start - 1
			end
		end
		local startOffset = start + 0.2
		for i = 1.2, startOffset do
			Timer(seconds-i, printTime)
		end
		self.sayCountdowns[key] = tbl
	end

	--- Start a countdown using yell messages. Generally used for abilities where you need to group up.
	-- @param key the option key
	-- @number seconds the amount of time in seconds until the countdown expires
	-- @param[opt] textOrIcon Attach additional text to the countdown if passed a text string, attach a raid icon if passed a number [1-8]
	-- @number[opt] startAt When to start sending messages in yell, default value is at 3 seconds remaining
	function boss:YellCountdown(key, seconds, textOrIcon, startAt)
		if not checkFlag(self, key, C.SAY_COUNTDOWN) then return end
		local start = startAt or 3
		local tbl = {false}
		local text = type(textOrIcon) == "number" and iconList[textOrIcon] or textOrIcon
		local function printTime()
			if not tbl[1] then
				SendChatMessage(text and format("%s %d", text, start) or start, "YELL")
				start = start - 1
			end
		end
		local startOffset = start + 0.2
		for i = 1.2, startOffset do
			Timer(seconds-i, printTime)
		end
		self.sayCountdowns[key] = tbl
	end
end

-------------------------------------------------------------------------------
-- Misc.
-- @section misc
--

--- Trigger a function after a specific delay
-- @param func callback function to trigger after the delay
-- @number delay how long to wait until triggering the function
function boss:SimpleTimer(func, delay)
	Timer(delay, func)
end

--- Flash the screen edges.
-- @param key the option key
-- @param[opt] icon the icon to pulse if PULSE is set (if nil, key is used)
function boss:Flash(key, icon)
	if checkFlag(self, key, C.FLASH) then
		self:SendMessage("BigWigs_Flash", self, key)
	end
	if checkFlag(self, key, C.PULSE) then
		self:SendMessage("BigWigs_Pulse", self, key, icons[icon or key])
	end
end

--- Play a sound.
-- @param key the option key
-- @string sound the sound to play
-- @string[opt] voice command to play when using a voice pack
-- @param[opt] player either a string or a table of players to prevent playing a sound if ME_ONLY is enabled
function boss:PlaySound(key, sound, voice, player)
	if checkFlag(self, key, C.SOUND) then
		if player then
			local meOnly = checkFlag(self, key, C.ME_ONLY)
			if type(player) == "table" then
				if meOnly then
					if player[#player] == cpName then
						self:SendMessage("BigWigs_Sound", self, key, sound)
					end
				elseif #player == 1 then
					self:SendMessage("BigWigs_Sound", self, key, sound)
				end
			else
				if not meOnly or (meOnly and player == pName) then
					self:SendMessage("BigWigs_Sound", self, key, sound)
				end
			end
		else
			if hasVoice and checkFlag(self, key, C.VOICE) then
				self:SendMessage("BigWigs_Voice", self, key, sound)
			else
				self:SendMessage("BigWigs_Sound", self, key, sound)
			end
		end
	end
end

--- Request to play the victory sound.
function boss:PlayVictorySound()
	self:SendMessage("BigWigs_VictorySound", self)
end

do
	local SendAddonMessage, IsInGroup = BigWigsLoader.SendAddonMessage, IsInGroup
	--- Send an addon sync to other players.
	-- @param msg the sync message/prefix
	-- @param[opt] extra other optional value you want to send
	-- @usage self:Sync("abilityPrefix", data)
	-- @usage self:Sync("ability")
	function boss:Sync(msg, extra)
		if msg then
			self:SendMessage("BigWigs_BossComm", msg, extra, pName)
			if IsInGroup() then
				if extra then
					msg = "B^".. msg .."^".. extra
				else
					msg = "B^".. msg
				end
				SendAddonMessage("BigWigs", msg, IsInGroup(2) and "INSTANCE_CHAT" or "RAID")
			end
		end
	end
end

do
	local l = GetLocale()
	if l == "zhCN" or l == "zhTW" or l == "koKR" then
		function boss:AbbreviateNumber(amount)
			if amount >= 100000000 then -- 100,000,000
				return format(L.amount_one, amount/100000000)
			elseif amount >= 10000 then -- 10,000
				return format(L.amount_two, amount/10000)
			elseif amount >= 1000 then -- 1,000
				return format(L.amount_three, amount/1000)
			else
				return format("%d", amount)
			end
		end
	else
		--- Return a string as a formatted abbreviated number.
		-- @number amount the number you wish to abbreviate
		-- @return string the formatted string e.g. 10M or 10K
		function boss:AbbreviateNumber(amount)
			if amount >= 1000000000 then -- 1,000,000,000
				return format(L.amount_one, amount/1000000000)
			elseif amount >= 1000000 then -- 1,000,000
				return format(L.amount_two, amount/1000000)
			elseif amount >= 1000 then -- 1,000
				return format(L.amount_three, amount/1000)
			else
				return format("%d", amount)
			end
		end
	end
end

--- Start a "berserk" bar and show an engage message.
-- @number seconds the time before the boss enrages/berserks
-- @param[opt] noMessages if any value, don't display an engage message. If set to 0, don't display any messages
-- @string[opt] customBoss set a custom boss name
-- @string[opt] customBerserk set a custom berserk name (and icon if a spell id), defaults to "Berserk"
-- @string[opt] customFinalMessage set a custom message to display when the berserk timer finishes
-- @string[opt] customBarText set a custom text to display on the Berserk bar
function boss:Berserk(seconds, noMessages, customBoss, customBerserk, customFinalMessage, customBarText)
	local name = customBoss or self.displayName
	local key = "berserk"

	-- There are many Berserks, but we use 26662 because Brutallus uses this one.
	-- Brutallus is da bomb.
	local icon = 26662
	local berserk = spells[icon]
	if type(customBerserk) == "number" then
		key = customBerserk
		berserk = spells[customBerserk]
		icon = customBerserk
	elseif type(customBerserk) == "string" then
		berserk = customBerserk
	end

	self:Bar(key, seconds, customBarText or berserk, icon)

	if not noMessages then
		-- Engage warning with minutes to enrage
		self:MessageOld(key, "yellow", nil, format(L.custom_start, name, berserk, seconds / 60), false)
	end

	if noMessages ~= 0 then
		-- Half-way to enrage warning.
		local half = seconds / 2
		local m = half % 60
		local halfMin = (half - m) / 60
		self:DelayedMessage(key, half + m, "yellow", format(L.custom_min, berserk, halfMin))

		self:DelayedMessage(key, seconds - 60, "orange", format(L.custom_min, berserk, 1))
		self:DelayedMessage(key, seconds - 30, "orange", format(L.custom_sec, berserk, 30))
		self:DelayedMessage(key, seconds - 10, "orange", format(L.custom_sec, berserk, 10))
		self:DelayedMessage(key, seconds - 5, "orange", format(L.custom_sec, berserk, 5))
		self:DelayedMessage(key, seconds, "red", customFinalMessage or format(L.custom_end, name, berserk), icon, "Alarm")
	end
end
