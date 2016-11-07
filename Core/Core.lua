-------------------------------------------------------------------------------
-- BigWigs API
-- @module BigWigs
-- @alias addon

local addon = LibStub("AceAddon-3.0"):NewAddon("BigWigs", "AceTimer-3.0")
addon:SetEnabledState(false)
addon:SetDefaultModuleState(false)

-- Embed callback handler
local loader = BigWigsLoader
addon.RegisterMessage = loader.RegisterMessage
addon.UnregisterMessage = loader.UnregisterMessage
addon.SendMessage = loader.SendMessage

local C -- = BigWigs.C, set from Constants.lua
local L = BigWigsAPI:GetLocale("BigWigs")
local CL = BigWigsAPI:GetLocale("BigWigs: Common")

local customBossOptions = {}
local pName = UnitName("player")
local bwUtilityFrame = CreateFrame("Frame")

local bossCore, pluginCore

-- Try to grab unhooked copies of critical loading funcs (hooked by some crappy addons)
local GetPlayerMapAreaID = loader.GetPlayerMapAreaID
local SendAddonMessage = loader.SendAddonMessage
local GetAreaMapInfo = loader.GetAreaMapInfo
local GetInstanceInfo = loader.GetInstanceInfo

-- Upvalues
local next, type = next, type

-------------------------------------------------------------------------------
-- Event handling
--

do
	local noEvent = "Module %q tried to register/unregister an event without specifying which event."
	local noFunc = "Module %q tried to register an event with the function '%s' which doesn't exist in the module."

	local eventMap = {}
	bwUtilityFrame:SetScript("OnEvent", function(_, event, ...)
		for k,v in next, eventMap[event] do
			if type(v) == "function" then
				v(event, ...)
			else
				k[v](k, event, ...)
			end
		end
	end)

	function addon:RegisterEvent(event, func)
		if type(event) ~= "string" then error((noEvent):format(self.moduleName)) end
		if (not func and not self[event]) or (type(func) == "string" and not self[func]) then error((noFunc):format(self.moduleName or "?", func or event)) end
		if not eventMap[event] then eventMap[event] = {} end
		eventMap[event][self] = func or event
		bwUtilityFrame:RegisterEvent(event)
	end
	function addon:UnregisterEvent(event)
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
	addon:RegisterMessage("BigWigs_OnBossDisable", UnregisterAllEvents)
	addon:RegisterMessage("BigWigs_OnBossReboot", UnregisterAllEvents)
	addon:RegisterMessage("BigWigs_OnPluginDisable", UnregisterAllEvents)
end

-------------------------------------------------------------------------------
-- ENCOUNTER event handler
--

function addon:ENCOUNTER_START(_, id)
	for _, module in next, bossCore.modules do
		if module.engageId == id then
			if not module.enabledState then
				module:Enable()
				module:Engage()
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Target monitoring
--

local enablezones, enablemobs = {}, {}
local monitoring = nil

local function enableBossModule(module, noSync)
	if not module:IsEnabled() and (not module.lastKill or (GetTime() - module.lastKill) > (module.worldBoss and 5 or 150)) then
		module:Enable()
		if not noSync and not module.worldBoss then
			module:Sync("Enable", module:GetName())
		end
	end
end

local function shouldReallyEnable(unit, moduleName, mobId, noSync)
	local module = bossCore:GetModule(moduleName)
	if not module or module:IsEnabled() then return end
	if (not module.VerifyEnable or module:VerifyEnable(unit, mobId)) then
		enableBossModule(module, noSync)
	end
end

local function targetSeen(unit, targetModule, mobId, noSync)
	if type(targetModule) == "string" then
		shouldReallyEnable(unit, targetModule, mobId, noSync)
	else
		for i, module in next, targetModule do
			shouldReallyEnable(unit, module, mobId, noSync)
		end
	end
end

local function targetCheck(unit, noSync)
	if not UnitName(unit) or UnitIsCorpse(unit) or UnitIsDead(unit) or UnitPlayerControlled(unit) then return end
	local _, _, _, _, _, mobId = strsplit("-", (UnitGUID(unit)))
	local id = tonumber(mobId)
	if id and enablemobs[id] then
		targetSeen(unit, enablemobs[id], id, noSync)
	end
end

local function updateMouseover() targetCheck("mouseover") end
local function unitTargetChanged(event, target)
	targetCheck(target .. "target", true)
end

local function zoneChanged()
	local id
	if not IsInInstance() then
		-- We may be hearthing whilst a module is enabled and engaged, only wipe if we're a ghost (released spirit from an old zone).
		if UnitIsDeadOrGhost("player") then
			for _, module in next, bossCore.modules do
				if module.isEngaged then
					module:Wipe()
				end
			end
		else
			id = -(GetPlayerMapAreaID("player") or 0)
		end
	else
		local _, _, _, _, _, _, _, instanceId = GetInstanceInfo()
		id = instanceId
	end
	if enablezones[id] then
		if not monitoring then
			monitoring = true
			addon:RegisterEvent("UPDATE_MOUSEOVER_UNIT", updateMouseover)
			addon:RegisterEvent("UNIT_TARGET", unitTargetChanged)
			targetCheck("target")
			targetCheck("mouseover")
		end
	elseif monitoring then
		monitoring = nil
		addon:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
		addon:UnregisterEvent("UNIT_TARGET")
	end
end

do
	local function add(moduleName, tbl, ...)
		for i = 1, select("#", ...) do
			local entry = select(i, ...)
			local t = type(tbl[entry])
			if t == "nil" then
				tbl[entry] = moduleName
			elseif t == "table" then
				tbl[entry][#tbl[entry] + 1] = moduleName
			elseif t == "string" then
				local tmp = tbl[entry]
				tbl[entry] = { tmp, moduleName }
			else
				error(("Unknown type in a enable trigger table at index %d for %q."):format(i, tostring(moduleName)))
			end
		end
	end
	function addon:RegisterEnableMob(module, ...) add(module.moduleName, enablemobs, ...) end
	function addon:GetEnableMobs() return enablemobs end
end

-------------------------------------------------------------------------------
-- Testing
--

do
	local callbackRegistered = nil
	local messages = {}
	local colors = {"Important", "Personal", "Urgent", "Attention", "Positive", "Neutral"}
	local sounds = {"Long", "Info", "Alert", "Alarm", "Warning", false, false, false, false, false}

	local function barStopped(event, bar)
		local a = bar:Get("bigwigs:anchor")
		local key = bar:GetLabel()
		if a and messages[key] then
			local color = colors[random(1, #colors)]
			local sound = sounds[random(1, #sounds)]
			if random(1, 4) == 2 then
				addon:SendMessage("BigWigs_Flash", addon, key)
			end
			addon:Print(L.test .." - ".. color ..": ".. key)
			addon:SendMessage("BigWigs_Message", addon, key, color..": "..key, color, messages[key])
			addon:SendMessage("BigWigs_Sound", addon, key, sound)
			messages[key] = nil
		end
	end

	function addon:Test()
		if not callbackRegistered then
			LibStub("LibCandyBar-3.0").RegisterCallback(self, "LibCandyBar_Stop", barStopped)
			callbackRegistered = true
		end

		local spell, icon
		local _, _, offset, numSpells = GetSpellTabInfo(2) -- Main spec
		for i = offset + 1, offset + numSpells do
			spell = GetSpellBookItemName(i, "spell")
			icon = GetSpellBookItemTexture(i, "spell")
			if not messages[spell] then break end
		end

		local time = random(11, 30)
		messages[spell] = icon

		addon:SendMessage("BigWigs_StartBar", addon, spell, spell, time, icon)
	end
end

-------------------------------------------------------------------------------
-- Communication
--

local function bossComm(_, msg, extra, sender)
	if msg == "Engage" and extra then
		local m = addon:GetBossModule(extra, true)
		if not m or m.isEngaged or m.engageId or not m:IsEnabled() then
			return
		end
		m:UnregisterEvent("PLAYER_REGEN_DISABLED")
		m:Engage()
	elseif msg == "Enable" and extra then
		local m = addon:GetBossModule(extra, true)
		if m and not m:IsEnabled() and sender ~= pName then
			enableBossModule(m, true)
		end
	end
end

function addon:RAID_BOSS_WHISPER(_, msg) -- Purely for Transcriptor to assist in logging purposes.
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
				local module = initModules[i]
				module:Initialize()
				initModules[i] = nil
			end
			-- For LoD users
			-- ZONE_CHANGED_NEW_AREA > LoadAddOn
			-- ADDON_LOADED > InitializeModules
			-- We're in a brand new zone that loaded a new addon and added modules.
			-- Now force a zone check to be able to enable those modules.
			zoneChanged()
		end
	end

	local function profileUpdate()
		addon:SendMessage("BigWigs_ProfileUpdate")
	end

	local addonName = ...
	function addon:ADDON_LOADED(_, name)
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
		local db = LibStub("AceDB-3.0"):New("BigWigs3DB", defaults, true)
		LibStub("LibDualSpec-1.0"):EnhanceDatabase(db, "BigWigs3DB")

		db.RegisterCallback(self, "OnProfileChanged", profileUpdate)
		db.RegisterCallback(self, "OnProfileCopied", profileUpdate)
		db.RegisterCallback(self, "OnProfileReset", profileUpdate)
		self.db = db

		self.db.profile.raidicon = nil -- XXX temp [v7.0]

		self.ADDON_LOADED = InitializeModules
		InitializeModules()
	end
	addon:RegisterEvent("ADDON_LOADED")
end

function addon:OnEnable()
	self:RegisterMessage("BigWigs_BossComm", bossComm)
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", zoneChanged)

	self:RegisterEvent("ENCOUNTER_START")

	self:RegisterEvent("RAID_BOSS_WHISPER")

	if IsLoggedIn() then
		self:EnableModules()
	else
		self:RegisterEvent("PLAYER_LOGIN", "EnableModules")
	end

	zoneChanged()
	self:SendMessage("BigWigs_CoreEnabled")
end

function addon:OnDisable()
	self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	self:UnregisterMessage("BigWigs_BossComm")

	self:UnregisterEvent("ENCOUNTER_START")

	self:UnregisterEvent("RAID_BOSS_WHISPER")

	zoneChanged() -- Unregister zone events
	bossCore:Disable()
	pluginCore:Disable()
	monitoring = nil
	self:SendMessage("BigWigs_CoreDisabled")
end

function addon:EnableModules()
	pluginCore:Enable()
	bossCore:Enable()
end

function addon:Print(msg)
	print("BigWigs: |cffffff00"..msg.."|r")
end

-------------------------------------------------------------------------------
-- API - if anything else is exposed on the BigWigs object, that's a mistake!
-- Well .. except the module API, obviously.
--

do
	function addon:RegisterBossOption(key, name, desc, func, icon)
		if customBossOptions[key] then
			error("The custom boss option %q has already been registered."):format(key)
		end
		customBossOptions[key] = { name, desc, func, icon }
	end

	-- Adding core generic toggles
	addon:RegisterBossOption("berserk", L.berserk, L.berserk_desc, nil, "Interface\\Icons\\spell_shadow_unholyfrenzy")
	addon:RegisterBossOption("altpower", L.altpower, L.altpower_desc, nil, "Interface\\Icons\\spell_arcane_invocation")
	addon:RegisterBossOption("infobox", L.infobox, L.infobox_desc)
	addon:RegisterBossOption("stages", L.stages, L.stages_desc)
	addon:RegisterBossOption("warmup", L.warmup, L.warmup_desc)
end

function addon:GetCustomBossOptions()
	return customBossOptions
end

do
	local L = GetLocale()
	if L == "enGB" then L = "enUS" end
	function addon:NewBossLocale(moduleName, locale)
		local module = addon:GetBossModule(moduleName, true)
		if module and L == locale then
			return module:GetLocale()
		end
	end
end

-------------------------------------------------------------------------------
-- Module handling
--

do
	local GetSpellInfo, EJ_GetSectionInfo = GetSpellInfo, EJ_GetSectionInfo

	local errorAlreadyRegistered = "%q already exists as a module in BigWigs, but something is trying to register it again."
	local function new(core, moduleName, mapId, journalId, ...)
		if core:GetModule(moduleName, true) then
			addon:Print(errorAlreadyRegistered:format(moduleName))
		else
			local m = core:NewModule(moduleName, ...)
			initModules[#initModules+1] = m

			-- Embed callback handler
			m.RegisterMessage = addon.RegisterMessage
			m.UnregisterMessage = addon.UnregisterMessage
			m.SendMessage = addon.SendMessage

			-- Embed event handler
			m.RegisterEvent = addon.RegisterEvent
			m.UnregisterEvent = addon.UnregisterEvent

			m.zoneId = mapId
			m.journalId = journalId
			return m, CL
		end
	end

	-- A wrapper for :NewModule to present users with more information in the
	-- case where a module with the same name has already been registered.
	function addon:NewBoss(moduleName, zoneId, ...)
		return new(bossCore, moduleName, zoneId, ...)
	end
	function addon:NewPlugin(moduleName, ...)
		return new(pluginCore, moduleName, nil, nil, ...)
	end

	function addon:IterateBossModules() return bossCore:IterateModules() end
	function addon:GetBossModule(...) return bossCore:GetModule(...) end

	function addon:IteratePlugins() return pluginCore:IterateModules() end
	function addon:GetPlugin(...) return pluginCore:GetModule(...) end

	local defaultToggles = nil

	local function setupOptions(module)
		if not C then C = addon.C end
		if not defaultToggles then
			defaultToggles = setmetatable({
				berserk = C.BAR + C.MESSAGE,
				bosskill = C.MESSAGE,
				proximity = C.PROXIMITY,
				altpower = C.ALTPOWER,
				infobox = C.INFOBOX,
			}, {__index = function(self, key)
				return C.BAR + C.MESSAGE + C.VOICE
			end})
		end

		if module.optionHeaders then
			for k, v in next, module.optionHeaders do
				if type(v) == "string" then
					if CL[v] then
						module.optionHeaders[k] = CL[v]
					end
				elseif type(v) == "number" then
					if v > 0 then
						local n = GetSpellInfo(v)
						if not n then error(("Invalid spell ID %d in the optionHeaders for module %s."):format(v, module.name)) end
						module.optionHeaders[k] = n
					else
						local n = EJ_GetSectionInfo(-v)
						if not n then error(("Invalid journal ID (-)%d in the optionHeaders for module %s."):format(-v, module.name)) end
						module.optionHeaders[k] = n
					end
				end
			end
		end

		if module.toggleOptions then
			module.toggleDefaults = {}
			for k, v in next, module.toggleOptions do
				local bitflags = 0
				local t = type(v)
				if t == "table" then
					for i = 2, #v do
						local flagName = v[i]
						if C[flagName] then
							bitflags = bitflags + C[flagName]
						else
							error(("%q tried to register '%q' as a bitflag for toggleoption '%q'"):format(module.moduleName, flagName, v[1]))
						end
					end
					v = v[1]
					t = type(v)
				end
				-- mix in default toggles for keys we know
				-- this allows for mod.toggleOptions = {1234, {"bosskill", "bar"}}
				-- while bosskill usually only has message
				for _, b in next, C do
					if bit.band(defaultToggles[v], b) == b and bit.band(bitflags, b) ~= b then
						bitflags = bitflags + b
					end
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
						if not n then error(("Invalid spell ID %d in the toggleOptions for module %s."):format(v, module.name)) end
						module.toggleDefaults[v] = bitflags
					else
						local n = EJ_GetSectionInfo(-v)
						if not n then error(("Invalid journal ID (-)%d in the toggleOptions for module %s."):format(-v, module.name)) end
						module.toggleDefaults[v] = bitflags
					end
				end
			end
			module.db = addon.db:RegisterNamespace(module.name, { profile = module.toggleDefaults })
		end
	end

	local function moduleOptions(self)
		if self.GetOptions then
			local toggles, headers = self:GetOptions(CL)
			if toggles then self.toggleOptions = toggles end
			if headers then self.optionHeaders = headers end
			self.GetOptions = nil
		end
		setupOptions(self)
		self.SetupOptions = nil
	end

	function addon:RegisterBossModule(module)
		if module.journalId then
			module.displayName = EJ_GetEncounterInfo(module.journalId)
		end
		if not module.displayName then module.displayName = module.moduleName end

		module.SetupOptions = moduleOptions

		-- Call the module's OnRegister (which is our OnInitialize replacement)
		if type(module.OnRegister) == "function" then
			module:OnRegister()
			module.OnRegister = nil
		end

		self:SendMessage("BigWigs_BossModuleRegistered", module.moduleName, module)

		local id = module.worldBoss and module.zoneId or GetAreaMapInfo(module.zoneId)
		if not enablezones[id] then
			enablezones[id] = true
		end
	end

	function addon:RegisterPlugin(module)
		if type(module.defaultDB) == "table" then
			module.db = self.db:RegisterNamespace(module.name, { profile = module.defaultDB } )
		end

		setupOptions(module)

		-- Call the module's OnRegister (which is our OnInitialize replacement)
		if type(module.OnRegister) == "function" then
			module:OnRegister()
			module.OnRegister = nil
		end
		self:SendMessage("BigWigs_PluginRegistered", module.moduleName, module)

		if pluginCore:IsEnabled() then
			module:Enable() -- Support LoD plugins that load after we're enabled (e.g. zone based)
		end
	end
end

-------------------------------------------------------------------------------
-- Module cores
--

-- @local
bossCore = addon:NewModule("Bosses")
bossCore:SetDefaultModuleLibraries("AceTimer-3.0")
bossCore:SetDefaultModuleState(false)
function bossCore:OnDisable()
	for name, mod in next, self.modules do
		mod:Disable()
	end
end

pluginCore = addon:NewModule("Plugins")
pluginCore:SetDefaultModuleLibraries("AceTimer-3.0")
pluginCore:SetDefaultModuleState(false)
function pluginCore:OnEnable()
	for name, mod in next, self.modules do
		mod:Enable()
	end
end
function pluginCore:OnDisable()
	for name, mod in next, self.modules do
		mod:Disable()
	end
end

BigWigs = addon -- Set global

