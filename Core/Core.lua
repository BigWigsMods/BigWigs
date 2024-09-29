-------------------------------------------------------------------------------
-- BigWigs API
-- @module BigWigs
-- @alias core

local core, plugins, bossPrototype, pluginPrototype
do
	local _, tbl =...
	core = tbl.core
	plugins = tbl.plugins
	bossPrototype = tbl.bossPrototype
	pluginPrototype = tbl.pluginPrototype

	core.name = "BigWigs"

	local at = LibStub("AceTimer-3.0")
	at:Embed(core)
	at:Embed(bossPrototype)
	at:Embed(pluginPrototype)
end

local adb = LibStub("AceDB-3.0")
local lds = LibStub("LibDualSpec-1.0", true)

local CL = BigWigsAPI:GetLocale("BigWigs: Common")
local loader = BigWigsLoader
core.SendMessage = loader.SendMessage

local mod, bosses = {}, {}
local coreEnabled = false

-- Try to grab unhooked copies of critical loading funcs (hooked by some crappy addons)
local GetBestMapForUnit = loader.GetBestMapForUnit
local SendAddonMessage = loader.SendAddonMessage
local GetInstanceInfo = loader.GetInstanceInfo
local UnitName = loader.UnitName
local UnitGUID = loader.UnitGUID
local UnitIsDeadOrGhost = loader.UnitIsDeadOrGhost

-- Upvalues
local next, type, setmetatable = next, type, setmetatable

local pName = UnitName("player")

-------------------------------------------------------------------------------
-- Event handling
--

do
	local noEvent = "Module %q tried to register/unregister an event without specifying which event."
	local noFunc = "Module %q tried to register an event with the function '%s' which doesn't exist in the module."

	local eventMap = {}
	local bwUtilityFrame = CreateFrame("Frame")
	bwUtilityFrame:SetScript("OnEvent", function(_, event, ...)
		for k,v in next, eventMap[event] do
			if type(v) == "function" then
				v(event, ...)
			else
				k[v](k, event, ...)
			end
		end
	end)

	function core:RegisterEvent(event, func)
		if type(event) ~= "string" then error((noEvent):format(self.moduleName)) end
		if (not func and not self[event]) or (type(func) == "string" and not self[func]) then error((noFunc):format(self.moduleName or "?", func or event)) end
		if not eventMap[event] then eventMap[event] = {} end
		eventMap[event][self] = func or event
		bwUtilityFrame:RegisterEvent(event)
	end
	function core:UnregisterEvent(event)
		if type(event) ~= "string" then error((noEvent):format(self.moduleName)) end
		if not eventMap[event] then return end
		eventMap[event][self] = nil
		if not next(eventMap[event]) then
			bwUtilityFrame:UnregisterEvent(event)
			eventMap[event] = nil
		end
	end

	local function UnregisterAllEvents(_, module)
		for k,v in next, eventMap do
			for j in next, v do
				if j == module then
					module:UnregisterEvent(k)
				end
			end
		end
	end
	loader.RegisterMessage(mod, "BigWigs_OnBossDisable", UnregisterAllEvents)
	loader.RegisterMessage(mod, "BigWigs_OnBossWipe", UnregisterAllEvents)
	loader.RegisterMessage(mod, "BigWigs_OnPluginDisable", UnregisterAllEvents)
end

-------------------------------------------------------------------------------
-- ENCOUNTER event handler
--

if loader.isRetail or loader.isCata then
	function mod:ENCOUNTER_START(_, id)
		for _, module in next, bosses do
			if module:GetEncounterID() == id and not module:IsEnabled() then
				module:Enable()
				if UnitGUID("boss1") then -- Only if _START fired after IEEU
					module:Engage()
				end
			end
		end
	end
else
	function mod:ENCOUNTER_START(_, id)
		for _, module in next, bosses do
			if module:GetEncounterID() == id then
				if not module:IsEnabled() then
					module:Enable()
				end
				module:Engage()
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Target monitoring
--

local enablezones, enablemobs = {}, {}
local function enableBossModule(module, sync)
	if not module:IsEnabled() then
		module:Enable()
		if sync and not module.worldBoss then
			module:Sync("Enable", module.moduleName)
		end
	end
end

local function shouldReallyEnable(unit, moduleName, mobId, sync)
	local module = bosses[moduleName]
	if not module or module:IsEnabled() then return end
	if (not module.VerifyEnable or module:VerifyEnable(unit, mobId, GetBestMapForUnit("player"))) then
		enableBossModule(module, sync)
	end
end

local function targetSeen(unit, targetModule, mobId, sync)
	if type(targetModule) == "string" then
		shouldReallyEnable(unit, targetModule, mobId, sync)
	else
		for i = 1, #targetModule do
			local module = targetModule[i]
			shouldReallyEnable(unit, module, mobId, sync)
		end
	end
end

local function targetCheck(unit, sync)
	local name = UnitName(unit)
	if not name or UnitIsCorpse(unit) or UnitIsDead(unit) or UnitPlayerControlled(unit) then return end
	local guid = UnitGUID(unit)
	if not guid then
		core:Error(("Found unit '%s' with name '%s' but no guid, tell the BigWigs authors."):format(unit, name))
		return
	end
	local _, _, _, _, _, mobId = strsplit("-", guid)
	local id = tonumber(mobId)
	if id and enablemobs[id] then
		targetSeen(unit, enablemobs[id], id, sync)
	end
end

local function updateMouseover() targetCheck("mouseover", true) end
local function unitTargetChanged(_, target)
	targetCheck(target .. "target")
end

function core:RegisterEnableMob(module, ...)
	for i = 1, select("#", ...) do
		local mobId = select(i, ...)
		if type(mobId) ~= "number" or mobId < 1 then
			core:Error(("Module %q tried to register the mobId %q, but it wasn't a valid number."):format(module.moduleName, tostring(mobId)))
		else
			module.enableMobs[mobId] = true -- Module specific list
			-- Global list
			local entryType = type(enablemobs[mobId])
			if entryType == "nil" then
				enablemobs[mobId] = module.moduleName
			elseif entryType == "table" then
				enablemobs[mobId][#enablemobs[mobId] + 1] = module.moduleName
			elseif entryType == "string" then -- Converting from 1 module registered to this mobId, to multiple modules
				local previousModuleEntry = enablemobs[mobId]
				enablemobs[mobId] = { previousModuleEntry, module.moduleName }
			else
				core:Error(("Unknown type in a enable trigger table at index %d for %q."):format(i, module.moduleName))
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Communication
--

local function bossComm(_, msg, extra, sender)
	if msg == "Enable" and extra then
		local m = bosses[extra]
		if m and not m:IsEnabled() and sender ~= pName then
			enableBossModule(m)
		end
	end
end

function mod:RAID_BOSS_WHISPER(_, msg) -- Purely for Transcriptor to assist in logging purposes.
	if msg ~= "" and IsInGroup() then
		local _, result = SendAddonMessage("Transcriptor", msg, IsInGroup(2) and "INSTANCE_CHAT" or "RAID")
		if type(result) == "number" and result ~= 0 then
			core:Error("Failed to send TS comm. Error code: ".. result)
		end
	end
end

-------------------------------------------------------------------------------
-- Initialization
--

local initModules = {}
do
	local function InitializeModules()
		local count = #initModules
		if count > 0 then
			for i = 1, count do
				initModules[i]:Initialize()
			end
			initModules = {}
		end
	end

	local function profileUpdate()
		core:SendMessage("BigWigs_ProfileUpdate")
	end

	local addonName = ...
	function mod:ADDON_LOADED(_, name)
		if name ~= addonName then return end

		local defaults = {
			profile = {
				showZoneMessages = true,
				fakeDBMVersion = false,
				englishSayMessages = false,
			},
			global = {
				optionShiftIndexes = {},
				watchedMovies = {},
			},
		}
		local db = adb:New("BigWigs3DB", defaults, true)
		if lds then
			lds:EnhanceDatabase(db, "BigWigs3DB")
		end

		db.RegisterCallback(mod, "OnProfileChanged", profileUpdate)
		db.RegisterCallback(mod, "OnProfileCopied", profileUpdate)
		db.RegisterCallback(mod, "OnProfileReset", profileUpdate)
		core.db = db

		mod.ADDON_LOADED = InitializeModules
		InitializeModules()
	end
	core.RegisterEvent(mod, "ADDON_LOADED")
end

do
	local function DisableModules()
		for _, module in next, bosses do
			if module:IsEngaged() and (module:GetJournalID() or module:GetAllowWin()) and UnitIsDeadOrGhost("player") then
				module:Wipe()
			end
			module:Disable()
		end
		for _, module in next, plugins do
			module:Disable()
		end
	end
	local function DisableCore()
		if coreEnabled then
			coreEnabled = false

			loader.UnregisterMessage(mod, "BigWigs_BossComm")
			core.UnregisterEvent(mod, "ZONE_CHANGED_NEW_AREA")
			core.UnregisterEvent(mod, "PLAYER_LEAVING_WORLD")
			core.UnregisterEvent(mod, "ENCOUNTER_START")
			core.UnregisterEvent(mod, "RAID_BOSS_WHISPER")
			core.UnregisterEvent(mod, "UPDATE_MOUSEOVER_UNIT")
			core.UnregisterEvent(mod, "UNIT_TARGET")

			core:CancelAllTimers()

			core:SendMessage("BigWigs_StopConfigureMode")
			if BigWigsOptions then
				BigWigsOptions:Close()
			end
			DisableModules()
			core:SendMessage("BigWigs_CoreDisabled")
		end
	end
	local function zoneChanged()
		-- Not if you released spirit on a world boss or if the GUI is open
		if not UnitIsDeadOrGhost("player") and (not BigWigsOptions or not BigWigsOptions:IsOpen()) then
			local bars = plugins.Bars
			if not bars or not bars:HasActiveBars() then -- Not if bars are showing
				DisableCore() -- Alive in a non-enable zone, disable
			end
		end
	end

	local function EnablePlugins()
		for _, module in next, plugins do
			module:Enable()
		end
	end
	local zoneList = loader.zoneTbl
	local function CheckIfLeavingDelve(_, oldId, newId)
		if zoneList[oldId] and not zoneList[newId] then
			DisableCore() -- Leaving a Delve
		elseif zoneList[newId] then
			-- Joining a delve but we were already enabled from something
			DisableCore()
			--core:Enable() -- We rely on the 0 second delay from the loader to re-enable the core
		end
	end
	function core:Enable(unit)
		if not coreEnabled then
			coreEnabled = true

			loader.RegisterMessage(mod, "BigWigs_BossComm", bossComm)
			core.RegisterEvent(mod, "ENCOUNTER_START")
			core.RegisterEvent(mod, "RAID_BOSS_WHISPER")
			core.RegisterEvent(mod, "UPDATE_MOUSEOVER_UNIT", updateMouseover)
			core.RegisterEvent(mod, "UNIT_TARGET", unitTargetChanged)
			core.RegisterEvent(mod, "PLAYER_LEAVING_WORLD", DisableCore) -- Simple disable when leaving instances
			if C_EventUtils.IsEventValid("PLAYER_MAP_CHANGED") then
				core.RegisterEvent(mod, "PLAYER_MAP_CHANGED", CheckIfLeavingDelve)
			end
			local _, instanceType = GetInstanceInfo()
			if instanceType == "none" then -- We don't want to be disabling in instances
				core.RegisterEvent(mod, "ZONE_CHANGED_NEW_AREA", zoneChanged) -- Special checks for disabling after world bosses
			end


			if IsLoggedIn() then
				EnablePlugins()
			else
				core.RegisterEvent(mod, "PLAYER_LOGIN", EnablePlugins)
			end

			core:SendMessage("BigWigs_CoreEnabled")
		end
		if type(unit) == "string" then
			targetCheck(unit) -- Mainly for the Loader to tell the core to enable a world boss after loading the world boss addon
		end
	end
end

function core:IsEnabled()
	return coreEnabled
end

function core:Print(msg)
	print("BigWigs: |cffffff00"..msg.."|r")
end

function core:Error(msg, noPrint)
	if not noPrint then
		core:Print(msg)
	end
	geterrorhandler()("BigWigs: ".. msg)
end

-------------------------------------------------------------------------------
-- API
--

do
	local currentLocale = GetLocale()
	if currentLocale == "enGB" then currentLocale = "enUS" end
	function core:NewBossLocale(moduleName, locale)
		local module = bosses[moduleName]
		if module and currentLocale == locale then
			return module:GetLocale()
		end
	end
end

-------------------------------------------------------------------------------
-- Module handling
--

do
	local errorAlreadyRegistered = "%q already exists as a module in BigWigs, but something is trying to register it again."
	local errorJournalIdInvalid = "%q is using the invalid journal id of %q."
	local bossMeta = { __index = bossPrototype, __metatable = false }
	local EJ_GetEncounterInfo = loader.isCata and function(key)
		return EJ_GetEncounterInfo(key) or BigWigsAPI:GetLocale("BigWigs: Encounters")[key]
	end or loader.isRetail and EJ_GetEncounterInfo or function(key)
		return BigWigsAPI:GetLocale("BigWigs: Encounters")[key]
	end
	function core:NewBoss(moduleName, zoneId, journalId)
		if bosses[moduleName] then
			core:Print(errorAlreadyRegistered:format(moduleName))
		else
			local m = setmetatable({
				name = "BigWigs_Bosses_"..moduleName, -- XXX AceAddon/AceDB backwards compat
				moduleName = moduleName,
				enableMobs = {},

				-- Embed callback handler
				RegisterMessage = loader.RegisterMessage,
				UnregisterMessage = loader.UnregisterMessage,
				SendMessage = loader.SendMessage,

				-- Embed event handler
				RegisterEvent = core.RegisterEvent,
				UnregisterEvent = core.UnregisterEvent,
			}, bossMeta)
			bosses[moduleName] = m
			initModules[#initModules+1] = m

			if journalId then
				local name = EJ_GetEncounterInfo(journalId)
				if name or journalId < 0 then
					m.journalId = journalId
					m.displayName = name or moduleName
				else
					m.displayName = moduleName
					core:Print(errorJournalIdInvalid:format(moduleName, journalId))
				end
			else
				m.displayName = moduleName
			end

			if type(zoneId) == "table" or zoneId > 0 then
				m.instanceId = zoneId
			else
				m.mapId = -zoneId
			end
			return m, CL
		end
	end

	local pluginMeta = { __index = pluginPrototype, __metatable = false }
	function core:NewPlugin(moduleName, globalFuncs)
		if plugins[moduleName] then
			core:Print(errorAlreadyRegistered:format(moduleName))
		else
			local m = setmetatable({
				name = "BigWigs_Plugins_"..moduleName, -- XXX AceAddon/AceDB backwards compat
				moduleName = moduleName,
				globalFuncs = globalFuncs or {"db"},

				-- Embed callback handler
				RegisterMessage = loader.RegisterMessage,
				UnregisterMessage = loader.UnregisterMessage,
				SendMessage = loader.SendMessage,

				-- Embed event handler
				RegisterEvent = core.RegisterEvent,
				UnregisterEvent = core.UnregisterEvent,
			}, pluginMeta)
			plugins[moduleName] = m
			initModules[#initModules+1] = m

			return m, CL
		end
	end
end

function core:IterateBossModules()
	return next, bosses
end

function core:GetBossModule(moduleName, silent)
	if not silent and not bosses[moduleName] then
		error(("No boss module named '%s' found."):format(moduleName))
	else
		return bosses[moduleName]
	end
end

function core:GetPluginOptions()
	local tbl = {}
	for moduleName,module in next, plugins do
		tbl[moduleName] = {module.pluginOptions, module.subPanelOptions}
	end
	return tbl
end

function core:GetPlugin(moduleName, silent)
	if not plugins[moduleName] then
		if not silent then
			error(("No plugin named '%s' found."):format(moduleName))
		else
			return
		end
	else
		local moduleTbl = {}
		for i = 1, #plugins[moduleName].globalFuncs do
			local entry = plugins[moduleName].globalFuncs[i]
			moduleTbl[entry] = plugins[moduleName][entry]
		end
		return moduleTbl
	end
end

do
	local C_EncounterJournal_GetSectionInfo = loader.isCata and function(key)
		return C_EncounterJournal.GetSectionInfo(key) or BigWigsAPI:GetLocale("BigWigs: Encounter Info")[key]
	end or loader.isRetail and C_EncounterJournal.GetSectionInfo or function(key)
		return BigWigsAPI:GetLocale("BigWigs: Encounter Info")[key]
	end
	local C = core.C -- Set from Constants.lua
	local standardFlag = C.BAR + C.CASTBAR + C.MESSAGE + C.ICON + C.SOUND + C.SAY + C.SAY_COUNTDOWN + C.PROXIMITY + C.FLASH + C.ALTPOWER + C.VOICE + C.INFOBOX + C.NAMEPLATE
	local defaultToggles = setmetatable({
		berserk = C.BAR + C.MESSAGE + C.SOUND,
		proximity = C.PROXIMITY,
		altpower = C.ALTPOWER,
		infobox = C.INFOBOX,
	}, {__index = function()
		return standardFlag
	end})

	local function setupOptions(module)
		if module.optionHeaders then
			for k, v in next, module.optionHeaders do
				if type(v) == "string" then
					if CL[v] then
						module.optionHeaders[k] = CL[v]
					end
				elseif type(v) == "number" then
					if v > 0 then
						local n = loader.GetSpellName(v)
						if not n then core:Error(("Invalid spell ID %d in the optionHeaders for module %s."):format(v, module.name)) end
						module.optionHeaders[k] = n or v
					else
						local tbl = C_EncounterJournal_GetSectionInfo(-v)
						if not tbl then core:Error(("Invalid journal ID (-)%d in the optionHeaders for module %s."):format(-v, module.name)) end
						module.optionHeaders[k] = tbl and tbl.title or v
					end
				end
			end
		end

		if module.toggleOptions then
			module.toggleDefaults = {}
			for k, v in next, module.toggleOptions do
				local bitflags = 0
				local disabled = false
				local t = type(v)
				if t == "table" then
					for i = 2, #v do
						local flagName = v[i]
						if C[flagName] then
							bitflags = bitflags + C[flagName]
						elseif flagName == "OFF" then
							disabled = true
							break
						else
							error(("%q tried to register '%q' as a bitflag for toggleoption '%q'"):format(module.moduleName, flagName, v[1]))
						end
					end
					v = v[1]
					t = type(v)
				end
				-- mix in default toggles for keys we know
				-- this allows for mod.toggleOptions = {{1234, "bar", "message"}}
				-- while option keys don't usually specify common features such as bar or message
				for _, b in next, C do
					if bit.band(defaultToggles[v], b) == b and bit.band(bitflags, b) ~= b then
						bitflags = bitflags + b
					end
				end
				if disabled then
					if not module.toggleDisabled then
						module.toggleDisabled = {}
					end
					module.toggleDisabled[v] = bitflags
					bitflags = 0
				end
				if t == "string" then
					local custom = v:match("^custom_(o[nf]f?)_.*")
					if custom then
						module.toggleDefaults[v] = custom == "on" and true or false
					else
						module.toggleDefaults[v] = bitflags
					end
				elseif t == "number" then
					if v > 0 then
						local n = loader.GetSpellName(v)
						if not n then core:Error(("Invalid spell ID %d in the toggleOptions for module %s."):format(v, module.name)) end
						module.toggleDefaults[v] = bitflags
					else
						local tbl = C_EncounterJournal_GetSectionInfo(-v)
						if not tbl then core:Error(("Invalid journal ID (-)%d in the toggleOptions for module %s."):format(-v, module.name)) end
						module.toggleDefaults[v] = bitflags
					end
				end
			end
			module.db = core.db:RegisterNamespace(module.name, { profile = module.toggleDefaults })
		end
	end

	local function moduleOptions(self)
		if self.GetOptions then
			local toggles, headers, altNames = self:GetOptions(CL)
			if toggles then self.toggleOptions = toggles end
			if headers then self.optionHeaders = headers end
			if altNames then self.altNames = altNames end
			self.GetOptions = nil
		end
		setupOptions(self)
		self.SetupOptions = nil
	end

	function core:RegisterBossModule(module)
		module.SetupOptions = moduleOptions

		-- Call the module's OnRegister (which is our OnInitialize replacement)
		if type(module.OnRegister) == "function" then
			module:OnRegister()
			module.OnRegister = nil
		end

		core:SendMessage("BigWigs_BossModuleRegistered", module.moduleName, module)

		local id = module.instanceId or -(module.mapId)
		if type(id) == "table" then
			for i = 1, #id do
				if not enablezones[id[i]] then
					enablezones[id[i]] = true
				end
			end
		elseif not enablezones[id] then
			enablezones[id] = true
		end
	end

	function core:RegisterPlugin(module)
		if type(module.defaultDB) == "table" then
			module.db = core.db:RegisterNamespace(module.name, { profile = module.defaultDB } )
		end

		-- Call the module's OnRegister (which is our OnInitialize replacement)
		if type(module.OnRegister) == "function" then
			module:OnRegister()
			module.OnRegister = nil
		end
		core:SendMessage("BigWigs_PluginOptionsReady", module.moduleName, module.pluginOptions, module.subPanelOptions)

		if coreEnabled then
			module:Enable() -- Support LoD plugins that load after we're enabled (e.g. zone based)
		end
	end
end

function core:AddColors(moduleName, options)
	local module = bosses[moduleName]
	if not module then
		-- core:Error(("AddColors: Invalid module %q."):format(moduleName))
		return
	end
	module.colorOptions = options
end

function core:AddSounds(moduleName, options)
	local module = bosses[moduleName]
	if not module then
		-- core:Error(("AddSounds: Invalid module %q."):format(moduleName))
		return
	end
	module.soundOptions = options
end

-------------------------------------------------------------------------------
-- Global
--

BigWigs = setmetatable({}, { __index = core, __newindex = function() end, __metatable = false })
