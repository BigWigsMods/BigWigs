
local addon = LibStub("AceAddon-3.0"):NewAddon("BigWigs", "AceTimer-3.0")
addon:SetEnabledState(false)
addon:SetDefaultModuleState(false)

-- Embed callback handler
addon.RegisterMessage = BigWigsLoader.RegisterMessage
addon.UnregisterMessage = BigWigsLoader.UnregisterMessage
addon.SendMessage = BigWigsLoader.SendMessage

local GetSpellInfo = GetSpellInfo

local C -- = BigWigs.C, set from Constants.lua
local AL = LibStub("AceLocale-3.0")
local L = AL:GetLocale("Big Wigs")
local CL = AL:GetLocale("Big Wigs: Common")

local customBossOptions = {}
local pName = UnitName("player")
local bwUtilityFrame = CreateFrame("Frame")

-- Try to grab unhooked copies of critical loading funcs (hooked by some crappy addons)
local GetCurrentMapAreaID = BigWigsLoader.GetCurrentMapAreaID
local SetMapToCurrentZone = BigWigsLoader.SetMapToCurrentZone

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
		if (not func and not self[event]) or (type(func) == "string" and not self[func]) then error((noFunc):format(self.moduleName, func or event)) end
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
	addon:RegisterMessage("BigWigs_OnPluginDisable", UnregisterAllEvents)
end

-------------------------------------------------------------------------------
-- Target monitoring
--

local enablezones, enablemobs, enableyells = {}, {}, {}
local monitoring = nil

local function enableBossModule(module, noSync)
	if not module:IsEnabled() then
		module:Enable()
		if not noSync then
			module:Sync("EnableModule", module:GetName())
		end
	end
end

local function shouldReallyEnable(unit, moduleName, mobId)
	local module = addon.bossCore:GetModule(moduleName)
	if not module or module:IsEnabled() then return end
	-- If we pass the Verify Enable func (or it doesn't exist) and it's been > 3 seconds since the module was disabled, then enable it.
	if (not module.VerifyEnable or module:VerifyEnable(unit, mobId)) and (not module.lastKill or (GetTime() - module.lastKill) > 3) then
		enableBossModule(module)
	end
end

local function targetSeen(unit, targetModule, mobId)
	if type(targetModule) == "string" then
		shouldReallyEnable(unit, targetModule, mobId)
	else
		for i, module in next, targetModule do
			shouldReallyEnable(unit, module, mobId)
		end
	end
end

local function targetCheck(unit)
	if not UnitName(unit) or UnitIsCorpse(unit) or UnitIsDead(unit) or UnitPlayerControlled(unit) then return end
	local id = tonumber((UnitGUID(unit)):sub(6, 10), 16)
	if id and enablemobs[id] then
		targetSeen(unit, enablemobs[id], id)
	end
end
local function chatMsgMonsterYell(event, msg)
	for yell, mod in next, enableyells do
		if yell == msg or msg:find(yell, nil, true) or msg:find(yell) then -- Preserve backwards compat by leaving in the 3rd check
			targetSeen("player", mod)
		end
	end
end
local function updateMouseover() targetCheck("mouseover") end
local function unitTargetChanged(event, target)
	targetCheck(target .. "target")
end

local function zoneChanged()
	if not IsInInstance() then
		for _, module in addon:IterateBossModules() do
			if module.isEngaged then module:Reboot(true) end
		end
	else
		SetMapToCurrentZone() -- Hack because Astrolabe likes to screw with map setting in rare situations, so we need to force an update.
	end
	if enablezones[GetCurrentMapAreaID()] then
		if not monitoring then
			monitoring = true
			addon:RegisterEvent("CHAT_MSG_MONSTER_YELL", chatMsgMonsterYell)
			addon:RegisterEvent("UPDATE_MOUSEOVER_UNIT", updateMouseover)
			addon:RegisterEvent("UNIT_TARGET", unitTargetChanged)
			targetCheck("target")
			targetCheck("mouseover")
		end
	elseif monitoring then
		monitoring = nil
		addon:UnregisterEvent("CHAT_MSG_MONSTER_YELL")
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
	function addon:RegisterEnableYell(module, ...) add(module.moduleName, enableyells, ...) end
	function addon:GetEnableMobs() return enablemobs end
	function addon:GetEnableYells() return enableyells end
end

-------------------------------------------------------------------------------
-- Movie Blocking
--

do
	local knownMovies = {
		[73] = true, -- Ultraxion death
		[74] = true, -- DeathwingSpine engage
		[75] = true, -- DeathwingSpine death
		[76] = true, -- DeathwingMadness death
	}

	-- We can't :HookScript as we need to prevent the movie starting to play in the first place
	local origMovieHandler = MovieFrame:GetScript("OnEvent")
	MovieFrame:SetScript("OnEvent", function(frame, event, id, ...)
		if event == "PLAY_MOVIE" and knownMovies[id] and addon.db.profile.blockmovies then
			if not addon.db.global.seenmovies then
				addon.db.global.seenmovies = {}
			end
			if addon.db.global.seenmovies[id] then
				addon:Print(L["Prevented boss movie '%d' from playing."]:format(id))
				return MovieFrame_OnMovieFinished(frame)
			else
				addon.db.global.seenmovies[id] = true
				return origMovieHandler(frame, event, id, ...)
			end
		else
			return origMovieHandler(frame, event, id, ...)
		end
	end)
end

-------------------------------------------------------------------------------
-- Testing
--

do
	local callbackRegistered = nil
	local messages = {}
	local colors = {"Important", "Personal", "Urgent", "Attention", "Positive", "Neutral"}
	local sounds = {"Long", "Info", "Alert", "Alarm", "Victory", "Warning", false, false, false, false, false}

	local function barStopped(event, bar)
		local a = bar:Get("bigwigs:anchor")
		local key = bar.candyBarLabel:GetText()
		if a and messages[key] then
			local color = colors[math.random(1, #colors)]
			local sound = sounds[math.random(1, #sounds)]
			if random(1, 2) == 2 then
				addon:SendMessage("BigWigs_Flash", addon, key)
				addon:SendMessage("BigWigs_Pulse", addon, key, messages[key])
				local colors = addon:GetPlugin("Colors", true)
				local pulseColor
				if colors then
					local r, g, b = colors:GetColor("flash")
					pulseColor = ("|cFF%02x%02x%02x"):format(r*255, g*255, b*255)
				end
				addon:Print(L.Test .." - ".. (pulseColor or "") ..L.FLASH.. (pulseColor and "|r" or "") .." - ".. L.PULSE ..": |T".. messages[key] ..":15:15:0:0:64:64:4:60:4:60|t")
			end
			if sound then addon:Print(L.Test .." - ".. L.Sound ..": ".. sound) end
			addon:SendMessage("BigWigs_Message", addon, key, color..": "..key, color, sound, messages[key])
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

		local time = math.random(11, 30)
		messages[spell] = icon

		addon:SendMessage("BigWigs_StartBar", addon, spell, spell, time, icon)
	end
end


-------------------------------------------------------------------------------
-- Core syncs
--

-- Since this is from addon comms, it's the only place where we allow the module NAME to be passed, instead of the
-- actual module object. ALL other APIs should take module objects as arguments.
local function coreSync(sync, moduleName, sender)
	if not moduleName then return end
	if sync == "EnableModule" then
		if sender == pName then return end
		local module = addon:GetBossModule(moduleName, true)
		if not module then return end
		enableBossModule(module, true)
	elseif sync == "Death" then
		local mod = addon:GetBossModule(moduleName, true)
		if mod and mod:IsEnabled() then
			mod:Message("bosskill", "Positive", "Victory", L["%s has been defeated"]:format(mod.displayName), false)
			if mod.OnWin then mod:OnWin() end
			mod.lastKill = GetTime() -- Add the kill time for the enable check.
			mod:Disable()
		end
	end
end

-------------------------------------------------------------------------------
-- Communication
--

local chatMsgAddon
do
	local times = {}
	local registered = {
		BossEngaged = true,
		Death = true,
		EnableModule = true,
	}

	-- local bossEngagedSyncError = "Got a BossEngaged sync for %q from %s, but there's no such module."

	local function onSync(sync, rest, nick)
		if not registered[sync] then return end
		if sync == "BossEngaged" then
			local m = addon:GetBossModule(rest, true)
			if not m or m.isEngaged then
				-- print(bossEngagedSyncError:format(rest, nick))
				return
			end
			m:UnregisterEvent("PLAYER_REGEN_DISABLED")
			-- print("Engaging " .. tostring(rest) .. " based on engage sync from " .. tostring(nick) .. ".")
			m:Engage()
		elseif sync == "EnableModule" or sync == "Death" then
			coreSync(sync, rest, nick)
		else
			for m in next, registered[sync] do
				m:OnSync(sync, rest, nick)
			end
		end
	end

	function chatMsgAddon(event, prefix, message, sender)
		if prefix ~= "T" then return end
		local sync, rest = message:match("(%S+)%s*(.*)$")
		if sync and (not times[sync] or GetTime() > (times[sync] + 2)) then
			times[sync] = GetTime()
			onSync(sync, rest, sender)
		end
	end

	function addon:ClearSyncListeners(module)
		if module.syncListeners then
			for i = 1, #module.syncListeners do
				local sync = module.syncListeners[i]
				if registered[sync] then
					registered[sync][module] = nil -- Remove module from listening to this sync event.
					if not next(registered[sync]) then
						registered[sync] = nil -- Remove sync event entirely if no modules are registered to it.
					end
				end
			end
			module.syncListeners = nil
		end
	end
	function addon:AddSyncListener(module, sync)
		if not registered[sync] then registered[sync] = {} end
		if type(registered[sync]) ~= "table" then return end -- Prevent registering BossEngaged/Death/EnableModule
		registered[sync][module] = true
	end
	function addon:Transmit(sync, ...)
		if sync and (not times[sync] or GetTime() > (times[sync] + 2)) then
			times[sync] = GetTime()
			onSync(sync, strjoin(" ", ...), pName)
			if IsInRaid() or IsInGroup() then
				SendAddonMessage("BigWigs", "T:"..strjoin(" ", sync, ...), IsPartyLFG() and "INSTANCE_CHAT" or "RAID")
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Initialization
--

function addon:OnInitialize()
	local defaults = {
		profile = {
			sound = true,
			raidicon = true,
			flash = true,
			showBlizzardWarnings = false,
			blockmovies = true,
			fakeDBMVersion = false,
			customDBMbars = true,
		},
		global = {
			optionShiftIndexes = {},
		},
	}
	local db = LibStub("AceDB-3.0"):New("BigWigs3DB", defaults, true)
	LibStub("LibDualSpec-1.0"):EnhanceDatabase(db, "BigWigs3DB")

	local function profileUpdate()
		addon:SendMessage("BigWigs_ProfileUpdate")
	end
	db.RegisterCallback(self, "OnProfileChanged", profileUpdate)
	db.RegisterCallback(self, "OnProfileCopied", profileUpdate)
	db.RegisterCallback(self, "OnProfileReset", profileUpdate)
	self.db = db

	self:RegisterBossOption("bosskill", L["bosskill"], L["bosskill_desc"], nil, "Interface\\Icons\\ability_rogue_feigndeath")
	self:RegisterBossOption("berserk", L["berserk"], L["berserk_desc"], nil, "Interface\\Icons\\spell_shadow_unholyfrenzy")
	self:RegisterBossOption("stages", L["stages"], L["stages_desc"])

	-- this should ALWAYS be the last action of OnInitialize, it will trigger the loader to
	-- enable the foreign language pack, and other packs that want to be loaded when the core loads
	self:SendMessage("BigWigs_CoreLoaded")
	self.OnInitialize = nil
end

function addon:OnEnable()
	self:RegisterMessage("BigWigs_AddonMessage", chatMsgAddon)
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", zoneChanged)

	self.pluginCore:Enable()
	self.bossCore:Enable()

	zoneChanged()
	self:SendMessage("BigWigs_CoreEnabled")
end

function addon:OnDisable()
	self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	self:UnregisterMessage("BigWigs_AddonMessage")
	zoneChanged() -- Unregister zone events
	self.bossCore:Disable()
	self.pluginCore:Disable()
	monitoring = nil
	self:SendMessage("BigWigs_CoreDisabled")
end

function addon:Print(msg)
	print("Big Wigs: |cffffff00"..msg.."|r")
end

-------------------------------------------------------------------------------
-- API - if anything else is exposed on the BigWigs object, that's a mistake!
-- Well .. except the module API, obviously.
--

function addon:RegisterBossOption(key, name, desc, func, icon)
	if customBossOptions[key] then
		error("The custom boss option %q has already been registered."):format(key)
	end
	customBossOptions[key] = { name, desc, func, icon }
end

function addon:GetCustomBossOptions()
	return customBossOptions
end

function addon:NewBossLocale(name, locale, default) return AL:NewLocale(("%s_%s"):format(self.bossCore.name, name), locale, default, true) end

-------------------------------------------------------------------------------
-- Module handling
--

do
	local errorDeprecatedNew = "%q is using the deprecated :New() API. Please tell the author to fix it for Big Wigs 3."
	local errorDeprecatedZone = "%q is using the old way of registering zones (%s), tell the author to fix it for Big Wigs 3.7."
	local errorAlreadyRegistered = "%q already exists as a module in Big Wigs, but something is trying to register it again. This usually means you have two copies of this module in your addons folder due to some addon updater failure. It is recommended that you delete any Big Wigs folders you have and then reinstall it from scratch."

	-- either you get me the hell out of these woods, or you'll know how my
	-- mother felt after drinking my chocolate milkshake
	-- did she make it for you?
	-- you're a dead man.
	function addon:New(module)
		self:Print(errorDeprecatedNew:format(module))
	end

	local function new(core, module, zone, encounterId, ...)
		if core:GetModule(module, true) then
			addon:Print(errorAlreadyRegistered:format(module))
		else
			if type(zone) == "string" then
				addon:Print(errorDeprecatedZone:format(module, tostring(zone)))
				return
			end
			local m = core:NewModule(module, ...)

			-- Embed callback handler
			m.RegisterMessage = addon.RegisterMessage
			m.UnregisterMessage = addon.UnregisterMessage
			m.SendMessage = addon.SendMessage

			-- Embed event handler
			m.RegisterEvent = addon.RegisterEvent
			m.UnregisterEvent = addon.UnregisterEvent

			m.zoneId = zone
			m.encounterId = encounterId
			return m, CL
		end
	end

	-- A wrapper for :NewModule to present users with more information in the
	-- case where a module with the same name has already been registered.
	function addon:NewBoss(module, zone, ...)
		return new(self.bossCore, module, zone, ...)
	end
	function addon:NewPlugin(module, ...)
		return new(self.pluginCore, module, nil, nil, ...)
	end

	function addon:IterateBossModules() return self.bossCore:IterateModules() end
	function addon:GetBossModule(...) return self.bossCore:GetModule(...) end

	function addon:IteratePlugins() return self.pluginCore:IterateModules() end
	function addon:GetPlugin(...) return self.pluginCore:GetModule(...) end

	local defaultToggles = nil

	local function setupOptions(module)
		if not C then C = addon.C end
		if not defaultToggles then
			defaultToggles = setmetatable({
				berserk = C.BAR + C.MESSAGE,
				bosskill = C.MESSAGE,
				proximity = C.PROXIMITY,
			}, {__index = function(self, key)
				return C.BAR + C.MESSAGE
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
						module.optionHeaders[k] = GetSpellInfo(v)
					else
						module.optionHeaders[k] = EJ_GetSectionInfo(-v)
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
						module.toggleDefaults[n] = bitflags
					else
						local n = EJ_GetSectionInfo(-v)
						if not n then error(("Invalid ej ID %d in the toggleOptions for module %s."):format(-v, module.name)) end
						module.toggleDefaults[v] = bitflags
					end
				end
			end
			module.db = addon.db:RegisterNamespace(module.name, { profile = module.toggleDefaults })
		end
	end

	function addon:RegisterBossModule(module)
		if module.encounterId then
			module.displayName = EJ_GetEncounterInfo(module.encounterId)
		end
		if not module.displayName then module.displayName = module.moduleName end
		if not enablezones[module.zoneId] then
			enablezones[module.zoneId] = true
			-- We fire zoneChanged() as a backup for LoD users. In rare cases,
			-- ZONE_CHANGED_NEW_AREA fires before the first module can add its zoneId into the table,
			-- resulting in a failed check to register UPDATE_MOUSEOVER_UNIT, etc.
			zoneChanged()
		end

		module.SetupOptions = function(self)
			if self.GetOptions then
				local toggles, headers = self:GetOptions(CL)
				if toggles then self.toggleOptions = toggles end
				if headers then self.optionHeaders = headers end
				self.GetOptions = nil
			end
			setupOptions(self)
			self.SetupOptions = nil
		end

		-- Call the module's OnRegister (which is our OnInitialize replacement)
		if type(module.OnRegister) == "function" then
			module:OnRegister()
			module.OnRegister = nil
		end
		self:SendMessage("BigWigs_BossModuleRegistered", module.moduleName, module)
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
	end
end

-------------------------------------------------------------------------------
-- Module cores
--

local bossCore = addon:NewModule("Bosses")
addon.bossCore = bossCore
bossCore:SetDefaultModuleLibraries("AceTimer-3.0")
bossCore:SetDefaultModuleState(false)
function bossCore:OnDisable()
	for name, mod in self:IterateModules() do
		mod:Disable()
	end
end

local pluginCore = addon:NewModule("Plugins")
addon.pluginCore = pluginCore
pluginCore:SetDefaultModuleLibraries("AceTimer-3.0")
pluginCore:SetDefaultModuleState(false)
function pluginCore:OnEnable()
	for name, mod in self:IterateModules() do
		mod:Enable()
	end
end
function pluginCore:OnDisable()
	for name, mod in self:IterateModules() do
		mod:Disable()
	end
end

BigWigs = addon -- Set global

