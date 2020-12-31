-------------------------------------------------------------------------------
-- BigWigs API
-- @module BigWigs
-- @alias core

local core, bossPrototype, pluginPrototype
do
	local _, tbl =...
	core = tbl.core
	bossPrototype = tbl.bossPrototype
	pluginPrototype = tbl.pluginPrototype

	core.name = "BigWigs"

	local at = LibStub("AceTimer-3.0")
	at:Embed(core)
	at:Embed(bossPrototype)
	at:Embed(pluginPrototype)
end

local adb = LibStub("AceDB-3.0")
local lds = LibStub("LibDualSpec-1.0")

local L = BigWigsAPI:GetLocale("BigWigs")
local CL = BigWigsAPI:GetLocale("BigWigs: Common")
local loader = BigWigsLoader
core.SendMessage = loader.SendMessage

local customBossOptions = {}

local mod, bosses, plugins = {}, {}, {}
local coreEnabled = false

-- Try to grab unhooked copies of critical loading funcs (hooked by some crappy addons)
local GetBestMapForUnit = loader.GetBestMapForUnit
local SendAddonMessage = loader.SendAddonMessage
local GetInstanceInfo = loader.GetInstanceInfo
local UnitName = BigWigsLoader.UnitName
local UnitGUID = BigWigsLoader.UnitGUID

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

function mod:ENCOUNTER_START(_, id)
	for _, module in next, bosses do
		if module.engageId == id then
			if not module.enabled then
				module:Enable()
				if UnitGUID("boss1") then -- Only if _START fired after IEEU
					module:Engage()
				end
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Target monitoring
--

local enablezones, enablemobs = {}, {}
local monitoring = false

local function enableBossModule(module, sync)
	if not module.enabled then
		module:Enable()
		if sync and not module.worldBoss then
			module:Sync("Enable", module.moduleName)
		end
	end
end

local function shouldReallyEnable(unit, moduleName, mobId, sync)
	local module = bosses[moduleName]
	if not module or module.enabled then return end
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
local function unitTargetChanged(event, target)
	targetCheck(target .. "target")
end

local function zoneChanged()
	local _, instanceType, _, _, _, _, _, id = GetInstanceInfo()
	if instanceType == "none" then
		local mapId = GetBestMapForUnit("player")
		if mapId then
			id = -mapId
		end
	end
	if enablezones[id] then
		if not monitoring then
			monitoring = true
			core.RegisterEvent(mod, "UPDATE_MOUSEOVER_UNIT", updateMouseover)
			core.RegisterEvent(mod, "UNIT_TARGET", unitTargetChanged)
			targetCheck("target")
			targetCheck("mouseover")
			targetCheck("boss1")
		end
	elseif monitoring then
		monitoring = false
		core.UnregisterEvent(mod, "UPDATE_MOUSEOVER_UNIT")
		core.UnregisterEvent(mod, "UNIT_TARGET")
	end
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

function core:GetEnableMobs()
	local t = {}
	for k,v in next, enablemobs do
		t[k] = v
	end
	return t
end

-------------------------------------------------------------------------------
-- Testing
--

do
	local callbackRegistered = false
	local messages = {}
	local count = 1
	local colors = {"green", "red", "orange", "yellow", "cyan", "blue", "blue", "purple"}
	local sounds = {"Long", "Warning", "Alert", "Alarm", "Info", "onyou", "underyou", false}

	local function barStopped(event, bar)
		local a = bar:Get("bigwigs:anchor")
		local key = bar:GetLabel()
		if a and messages[key] then
			if not colors[count] then count = 1 end
			local color = colors[count]
			local sound = sounds[count]
			local emphasized = count == 2
			if count == 6 then
				core:SendMessage("BigWigs_Flash", core, key)
			end
			core:Print(L.test .." - ".. color ..": ".. key)
			core:SendMessage("BigWigs_Message", core, key, color..": "..key, color, messages[key], emphasized)
			core:SendMessage("BigWigs_Sound", core, key, sound)
			count = count + 1
			messages[key] = nil
		end
	end

	local lastNamePlateBar = 0
	local lastSpell = 1
	local lastTest = 1
	function core:Test()
		if not callbackRegistered then
			LibStub("LibCandyBar-3.0").RegisterCallback(core, "LibCandyBar_Stop", barStopped)
			callbackRegistered = true
		end

		local msg = CL.count:format(L.test, lastTest)
		local icon = GetSpellTexture(lastSpell)
		while not icon or icon == 136243 do -- 136243 = cogwheel
			lastSpell = lastSpell + 1
			icon = GetSpellTexture(lastSpell)
		end
		lastSpell = lastSpell + 1
		lastTest = lastTest + 1

		local time = random(11, 30)
		messages[msg] = icon

		core:SendMessage("BigWigs_StartBar", core, msg, msg, time, icon)

		local guid = UnitGUID("target")
		if guid then
			local t = GetTime()
			if (t - lastNamePlateBar) > 25 then
				lastNamePlateBar = t
				core:Print(L.testNameplate)
				core:SendMessage("BigWigs_StartNameplateBar", core, msg, msg, 25, icon, false, guid)
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
		if m and not m.enabled and sender ~= pName then
			enableBossModule(m)
		end
	end
end

function mod:RAID_BOSS_WHISPER(_, msg) -- Purely for Transcriptor to assist in logging purposes.
	if IsInGroup() then
		SendAddonMessage("Transcriptor", msg, IsInGroup(2) and "INSTANCE_CHAT" or "RAID")
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
			-- For LoD users
			-- ZONE_CHANGED_NEW_AREA > LoadAddOn
			-- ADDON_LOADED > InitializeModules
			-- We're in a brand new zone that loaded a new addon and added modules.
			-- Now force a zone check to be able to enable those modules.
			zoneChanged()
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
				flash = true,
				showZoneMessages = true,
				fakeDBMVersion = false,
			},
			global = {
				optionShiftIndexes = {},
				watchedMovies = {},
			},
		}
		local db = adb:New("BigWigs3DB", defaults, true)
		lds:EnhanceDatabase(db, "BigWigs3DB")

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
	local function EnablePlugins()
		for _, module in next, plugins do
			module:Enable()
		end
	end
	function core:Enable()
		if not coreEnabled then
			coreEnabled = true

			loader.RegisterMessage(mod, "BigWigs_BossComm", bossComm)
			core.RegisterEvent(mod, "ZONE_CHANGED_NEW_AREA", zoneChanged)
			core.RegisterEvent(mod, "ENCOUNTER_START")
			core.RegisterEvent(mod, "RAID_BOSS_WHISPER")

			if IsLoggedIn() then
				EnablePlugins()
			else
				core.RegisterEvent(mod, "PLAYER_LOGIN", EnablePlugins)
			end

			zoneChanged()
			core:SendMessage("BigWigs_CoreEnabled")
		end
	end
end

do
	local function DisableModules()
		for _, module in next, bosses do
			module:Disable()
		end
		for _, module in next, plugins do
			module:Disable()
		end
	end
	function core:Disable()
		if coreEnabled then
			coreEnabled = false

			loader.UnregisterMessage(mod, "BigWigs_BossComm")
			core.UnregisterEvent(mod, "ZONE_CHANGED_NEW_AREA")
			core.UnregisterEvent(mod, "ENCOUNTER_START")
			core.UnregisterEvent(mod, "RAID_BOSS_WHISPER")

			self:CancelAllTimers()

			zoneChanged() -- Unregister zone events
			DisableModules()
			monitoring = false
			core:SendMessage("BigWigs_CoreDisabled")
		end
	end
end

function core:IsEnabled()
	return coreEnabled
end

function core:Print(msg)
	print("BigWigs: |cffffff00"..msg.."|r")
end

function core:Error(msg)
	core:Print(msg)
	geterrorhandler()(msg)
end

-------------------------------------------------------------------------------
-- API - if anything else is exposed on the BigWigs object, that's a mistake!
-- Well .. except the module API, obviously.
--

do
	function core:RegisterBossOption(key, name, desc, func, icon)
		if customBossOptions[key] then
			error("The custom boss option %q has already been registered."):format(key)
		end
		customBossOptions[key] = { name, desc, func, icon }
	end

	-- Adding core generic toggles
	core:RegisterBossOption("berserk", L.berserk, L.berserk_desc, nil, 136224) -- 136224 = "Interface\\Icons\\spell_shadow_unholyfrenzy"
	core:RegisterBossOption("altpower", L.altpower, L.altpower_desc, nil, 429383) -- 429383 = "Interface\\Icons\\spell_arcane_invocation"
	core:RegisterBossOption("infobox", L.infobox, L.infobox_desc, nil, 443374) -- Interface\\Icons\\INV_MISC_CAT_TRINKET05
	core:RegisterBossOption("stages", L.stages, L.stages_desc)
	core:RegisterBossOption("warmup", L.warmup, L.warmup_desc)
end

function core:GetCustomBossOptions()
	return customBossOptions
end

do
	local L = GetLocale()
	if L == "enGB" then L = "enUS" end
	function core:NewBossLocale(moduleName, locale)
		local module = bosses[moduleName]
		if module and L == locale then
			return module:GetLocale()
		end
	end
end

-------------------------------------------------------------------------------
-- Module handling
--

do
	local EJ_GetEncounterInfo = EJ_GetEncounterInfo
	local errorAlreadyRegistered = "%q already exists as a module in BigWigs, but something is trying to register it again."
	local errorJournalIdInvalid = "%q is using the invalid journal id of %q."
	local bossMeta = { __index = bossPrototype, __metatable = false }
	function core:NewBoss(moduleName, zoneId, journalId, instanceId)
		if bosses[moduleName] then
			core:Print(errorAlreadyRegistered:format(moduleName))
		else
			local m = setmetatable({
				name = "BigWigs_Bosses_"..moduleName, -- XXX AceAddon/AceDB backwards compat
				moduleName = moduleName,

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
				if name then
					m.journalId = journalId
					m.displayName = EJ_GetEncounterInfo(journalId)
				else
					m.displayName = moduleName
					core:Print(errorJournalIdInvalid:format(moduleName, journalId))
				end
			else
				m.displayName = moduleName
			end

			if zoneId > 0 then
				m.instanceId = zoneId
			else
				m.mapId = -zoneId
			end
			return m, CL
		end
	end

	local pluginMeta = { __index = pluginPrototype, __metatable = false }
	function core:NewPlugin(moduleName)
		if plugins[moduleName] then
			core:Print(errorAlreadyRegistered:format(moduleName))
		else
			local m = setmetatable({
				name = "BigWigs_Plugins_"..moduleName, -- XXX AceAddon/AceDB backwards compat
				moduleName = moduleName,

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

function core:IteratePlugins()
	return next, plugins
end

function core:GetPlugin(moduleName, silent)
	if not silent and not plugins[moduleName] then
		error(("No plugin named '%s' found."):format(moduleName))
	else
		return plugins[moduleName]
	end
end

do
	local GetSpellInfo, C_EncounterJournal_GetSectionInfo = GetSpellInfo, C_EncounterJournal.GetSectionInfo
	local C = core.C -- Set from Constants.lua
	local standardFlag = C.BAR + C.CASTBAR + C.MESSAGE + C.ICON + C.SOUND + C.SAY + C.SAY_COUNTDOWN + C.PROXIMITY + C.FLASH + C.ALTPOWER + C.VOICE + C.INFOBOX + C.NAMEPLATEBAR
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
						local n = GetSpellInfo(v)
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
						local n = GetSpellInfo(v)
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
		if not enablezones[id] then
			enablezones[id] = true
		end
	end

	local function profileUpdate()
		core:SendMessage("BigWigs_ProfileUpdate")
	end

	function core:RegisterPlugin(module)
		if type(module.defaultDB) == "table" then
			module.db = core.db:RegisterNamespace(module.name, { profile = module.defaultDB } )
			module.db.RegisterCallback(module, "OnProfileChanged", profileUpdate)
			module.db.RegisterCallback(module, "OnProfileCopied", profileUpdate)
			module.db.RegisterCallback(module, "OnProfileReset", profileUpdate)
		end

		setupOptions(module)

		-- Call the module's OnRegister (which is our OnInitialize replacement)
		if type(module.OnRegister) == "function" then
			module:OnRegister()
			module.OnRegister = nil
		end
		core:SendMessage("BigWigs_PluginRegistered", module.moduleName, module)

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
