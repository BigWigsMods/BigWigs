
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

local bossCore, pluginCore

-- Try to grab unhooked copies of critical loading funcs (hooked by some crappy addons)
local GetCurrentMapAreaID = BigWigsLoader.GetCurrentMapAreaID
local SetMapToCurrentZone = BigWigsLoader.SetMapToCurrentZone
local SendAddonMessage = BigWigsLoader.SendAddonMessage

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
		addon:ClearSyncListeners(module) -- Also remove sync events
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
			if not module.enabledState then module:Enable() end
			--module:Engage() -- No engaging until Blizzard fixes this event
		end
	end
end

-------------------------------------------------------------------------------
-- Target monitoring
--

local enablezones, enablemobs, enableyells = {}, {}, {}
local monitoring = nil

local function enableBossModule(module, noSync)
	if not module:IsEnabled() then
		module:Enable()
		if not noSync and not module.worldBoss then
			module:Sync("EnableModule", module:GetName())
		end
	end
end

local function shouldReallyEnable(unit, moduleName, mobId)
	local module = bossCore:GetModule(moduleName)
	if not module or module:IsEnabled() then return end
	-- If we pass the Verify Enable func (or it doesn't exist) and it's been > 150 seconds since the module was disabled, then enable it.
	if (not module.VerifyEnable or module:VerifyEnable(unit, mobId)) and (not module.lastKill or (GetTime() - module.lastKill) > 150) then
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
	local _, _, _, _, _, mobId = strsplit("-", (UnitGUID(unit)))
	local id = tonumber(mobId)
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
		for _, module in next, bossCore.modules do
			if module.isEngaged then module:Wipe() end
		end
	else
		SetMapToCurrentZone() -- Hack because Astrolabe likes to screw with map setting in rare situations, so we need to force an update.
	end
	local id = GetCurrentMapAreaID()
	if enablezones[id] then
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

	if id == 953 and addon.db.profile.blockmovies then -- Siege of Orgrimmar
		addon:SiegeOfOrgrimmarCinematics()
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
		[152] = true, -- Garrosh defeat
	}

	function addon:PLAY_MOVIE(_, id)
		if knownMovies[id] and self.db.profile.blockmovies then
			if self.db.global.watchedMovies[id] then
				self:Print(L.movieBlocked)
				MovieFrame:Hide()
			else
				self.db.global.watchedMovies[id] = true
			end
		end
	end

	-- Cinematic handling
	local cinematicZones = {
		["800:1"] = true, -- Firelands bridge lowering
		["875:1"] = true, -- Gate of the Setting Sun gate breach
		["930:3"] = true, -- Tortos cave entry -- Doesn't work, apparently Blizzard don't want us to skip this..?
		["930:7"] = true, -- Ra-Den room opening
		["953:2"] = true, -- After Immerseus, entry to Fallen Protectors
		["953:8"] = true, -- Blackfuse room opening, just outside the door
		["953:9"] = true, -- Blackfuse room opening, in Thok area
		["953:12"] = true, -- Mythic Garrosh Phase 4
		["964:1"] = true, -- Bloodmaul Slag Mines, activating bridge to Roltall
		["969:2"] = true, -- Shadowmoon Burial Grounds, final boss introduction
		-- 984:1 is Auchindoun, but it unfortunately has 2 cinematics. 1 before the first boss and 1 before the last boss. Workaround?
		["993:2"] = true, -- Grimrail Depot, boarding the train
		["993:4"] = true, -- Grimrail Depot, destroying the train
		["994:3"] = true, -- Highmaul, Kargath Death
	}

	-- Cinematic skipping hack to workaround an item (Vision of Time) that creates cinematics in Siege of Orgrimmar.
	function addon:SiegeOfOrgrimmarCinematics()
		local hasItem
		for i = 105930, 105935 do -- Vision of Time items
			local _, _, cd = GetItemCooldown(i)
			if cd > 0 then hasItem = true end -- Item is found in our inventory
		end
		if hasItem and not self.SiegeOfOrgrimmarCinematicsFrame then
			local tbl = {[149370] = true, [149371] = true, [149372] = true, [149373] = true, [149374] = true, [149375] = true}
			self.SiegeOfOrgrimmarCinematicsFrame = CreateFrame("Frame")
			-- frame:UNIT_SPELLCAST_SUCCEEDED:player:Vision of Time Scene 2::227:149371:
			self.SiegeOfOrgrimmarCinematicsFrame:SetScript("OnEvent", function(_, _, _, _, _, _, spellId)
				if tbl[spellId] then
					addon:UnregisterEvent("CINEMATIC_START")
					addon:ScheduleTimer("RegisterEvent", 10, "CINEMATIC_START")
				end
			end)
			self.SiegeOfOrgrimmarCinematicsFrame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
		end
	end

	function addon:CINEMATIC_START()
		if self.db.profile.blockmovies then
			SetMapToCurrentZone()
			local areaId = GetCurrentMapAreaID() or 0
			local areaLevel = GetCurrentMapDungeonLevel() or 0
			local id = ("%d:%d"):format(areaId, areaLevel)

			if cinematicZones[id] then
				if self.db.global.watchedMovies[id] then
					self:Print(L.movieBlocked)
					CinematicFrame_CancelCinematic()
				else
					self.db.global.watchedMovies[id] = true
				end
			end
		end
	end
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
				addon:Print(L.test .." - ".. (pulseColor or "") ..L.FLASH.. (pulseColor and "|r" or "") .." - ".. L.PULSE ..": |T".. messages[key] ..":15:15:0:0:64:64:4:60:4:60|t")
			end
			if sound then addon:Print(L.test .." - ".. L.sound ..": ".. sound) end
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
	if sync == "EnableModule" then
		local module = addon:GetBossModule(moduleName, true)
		if sender ~= pName and module then
			enableBossModule(module, true)
		end
	elseif sync == "Death" then
		local mod = addon:GetBossModule(moduleName, true)
		if mod and not mod.engageId and mod:IsEnabled() then
			mod:Message("bosskill", "Positive", "Victory", L.defeated:format(mod.displayName), false)
			mod.lastKill = GetTime() -- Add the kill time for the enable check.
			if mod.OnWin then mod:OnWin() end
			mod:SendMessage("BigWigs_OnBossWin", mod)
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

	function chatMsgAddon(event, prefix, message, nick)
		if prefix ~= "T" then return end
		local sync, rest = message:match("(%S+)%s*(.*)$")
		if sync and registered[sync] then
			local t = GetTime()
			if rest == "" then rest = nil end
			if sync == "BossEngaged" then
				if rest and (not times[sync] or t > (times[sync] + 2)) then
					local m = addon:GetBossModule(rest, true)
					if not m or m.isEngaged or m.engageId or not m:IsEnabled() then
						-- print(bossEngagedSyncError:format(rest, nick))
						return
					end
					times[sync] = t
					m:UnregisterEvent("PLAYER_REGEN_DISABLED")
					-- print("Engaging " .. tostring(rest) .. " based on engage sync from " .. tostring(nick) .. ".")
					m:Engage()
				end
			elseif sync == "EnableModule" or sync == "Death" then
				if rest and (not times[sync] or t > (times[sync] + 2)) then
					coreSync(sync, rest, nick)
					times[sync] = t
				end
			else
				for module, throttle in next, registered[sync] do
					if not times[sync] or t >= (times[sync] + throttle) then
						module:OnSync(sync, rest, nick)
						times[sync] = t
					end
				end
			end
		end
	end

	function addon:ClearSyncListeners(module)
		for sync, list in next, registered do
			if type(list) == "table" then
				registered[sync][module] = nil -- Remove module from listening to this sync event.
				if not next(registered[sync]) then
					registered[sync] = nil -- Remove sync event entirely if no modules are registered to it.
				end
			end
		end
	end
	function addon:AddSyncListener(module, sync, throttle)
		if not registered[sync] then registered[sync] = {} end
		if type(registered[sync]) ~= "table" then return end -- Prevent registering BossEngaged/Death/EnableModule
		registered[sync][module] = throttle or 5
	end
	function addon:Transmit(sync, ...)
		if sync then
			local msg = strjoin(" ", sync, ...)
			chatMsgAddon(nil, "T", msg, pName)
			if IsInGroup() then
				SendAddonMessage("BigWigs", "T:"..msg, IsInGroup(2) and "INSTANCE_CHAT" or "RAID")
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
			showZoneMessages = true,
			blockmovies = true,
			fakeDBMVersion = false,
			autoRole = true,
		},
		global = {
			optionShiftIndexes = {},
			watchedMovies = {},
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

	-- XXX temp cleanup
	if self.db.global.seenmovies then
		if self.db.global.seenmovies[152] then self.db.global.watchedMovies[152] = true end
		if self.db.global.seenmovies[953.2] then self.db.global.watchedMovies["953:2"] = true end
		if self.db.global.seenmovies[953.8] then self.db.global.watchedMovies["953:8"] = true end
		if self.db.global.seenmovies[953.9] then self.db.global.watchedMovies["953:9"] = true end
		if self.db.global.seenmovies[953.12] then self.db.global.watchedMovies["953:12"] = true end
		self.db.global.seenmovies = nil
	end
	--

	self:RegisterBossOption("bosskill", L.bosskill, L.bosskill_desc, nil, "Interface\\Icons\\ability_rogue_feigndeath")
	self:RegisterBossOption("berserk", L.berserk, L.berserk_desc, nil, "Interface\\Icons\\spell_shadow_unholyfrenzy")
	self:RegisterBossOption("altpower", L.altpower, L.altpower_desc, nil, "Interface\\Icons\\spell_arcane_invocation")
	self:RegisterBossOption("stages", L.stages, L.stages_desc)
	self:RegisterBossOption("warmup", L.warmup, L.warmup_desc)

	-- This should ALWAYS be the last action of OnInitialize, it will trigger the loader to
	-- enable other packs that want to be loaded when the core loads.
	self:SendMessage("BigWigs_CoreLoaded")
	self.OnInitialize = nil
end

function addon:OnEnable()
	self:RegisterMessage("BigWigs_AddonMessage", chatMsgAddon)
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", zoneChanged)
	self:RegisterEvent("CINEMATIC_START")
	self:RegisterEvent("PLAY_MOVIE")

	self:RegisterEvent("ENCOUNTER_START")

	pluginCore:Enable()
	bossCore:Enable()

	zoneChanged()
	self:SendMessage("BigWigs_CoreEnabled")
end

function addon:OnDisable()
	self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	self:UnregisterEvent("CINEMATIC_START")
	self:UnregisterEvent("PLAY_MOVIE")
	self:UnregisterMessage("BigWigs_AddonMessage")

	self:UnregisterEvent("ENCOUNTER_START")

	zoneChanged() -- Unregister zone events
	bossCore:Disable()
	pluginCore:Disable()
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
	local errorDeprecatedNew = "%q is using the deprecated :New() API. Please tell the author to fix it for Big Wigs 3."
	local errorAlreadyRegistered = "%q already exists as a module in Big Wigs, but something is trying to register it again. This usually means you have two copies of this module in your addons folder due to some addon updater failure. It is recommended that you delete any Big Wigs folders you have and then reinstall it from scratch."

	-- either you get me the hell out of these woods, or you'll know how my
	-- mother felt after drinking my chocolate milkshake
	-- did she make it for you?
	-- you're a dead man.
	function addon:New(module)
		self:Print(errorDeprecatedNew:format(module))
	end

	local function new(core, module, zoneId, journalId, ...)
		if core:GetModule(module, true) then
			addon:Print(errorAlreadyRegistered:format(module))
		else
			local m = core:NewModule(module, ...)

			-- Embed callback handler
			m.RegisterMessage = addon.RegisterMessage
			m.UnregisterMessage = addon.UnregisterMessage
			m.SendMessage = addon.SendMessage

			-- Embed event handler
			m.RegisterEvent = addon.RegisterEvent
			m.UnregisterEvent = addon.UnregisterEvent

			m.zoneId = zoneId
			m.journalId = journalId
			return m, CL
		end
	end

	-- A wrapper for :NewModule to present users with more information in the
	-- case where a module with the same name has already been registered.
	function addon:NewBoss(module, zoneId, ...)
		return new(bossCore, module, zoneId, ...)
	end
	function addon:NewPlugin(module, ...)
		return new(pluginCore, module, nil, nil, ...)
	end

	function addon:IterateBossModules() return bossCore:IterateModules() end
	function addon:GetBossModule(...) return bossCore:GetModule(...) end

	function addon:IteratePlugins() return pluginCore:IterateModules() end
	function addon:GetPlugin(...) return pluginCore:GetModule(...) end

	local defaultToggles = nil

	local hasVoice = GetAddOnEnableState(pName, "BigWigs_Voice") > 0

	local function setupOptions(module)
		if not C then C = addon.C end
		if not defaultToggles then
			defaultToggles = setmetatable({
				berserk = C.BAR + C.MESSAGE,
				bosskill = C.MESSAGE,
				proximity = C.PROXIMITY,
				altpower = C.ALTPOWER,
			}, {__index = function(self, key)
				return C.BAR + C.MESSAGE + (hasVoice and C.VOICE or 0)
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

		if not enablezones[module.zoneId] then
			enablezones[module.zoneId] = true
			-- We fire zoneChanged() as a backup for LoD users. In rare cases,
			-- ZONE_CHANGED_NEW_AREA fires before the first module can add its zoneId into the table,
			-- resulting in a failed check to register UPDATE_MOUSEOVER_UNIT, etc.
			zoneChanged()
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
	end
end

-------------------------------------------------------------------------------
-- Module cores
--

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

