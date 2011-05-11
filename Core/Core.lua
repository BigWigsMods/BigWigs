BigWigs = LibStub("AceAddon-3.0"):NewAddon("BigWigs", "AceEvent-3.0")
local addon = BigWigs
addon:SetEnabledState(false)
addon:SetDefaultModuleState(false)

-- locale stuff for BB conditionals
local LOCALE = BigWigsLoader.LOCALE
local BB

local GetSpellInfo = GetSpellInfo

local C -- = BigWigs.C, set from Constants.lua
local AL = LibStub("AceLocale-3.0")
local L = AL:GetLocale("Big Wigs")
local CL = AL:GetLocale("Big Wigs: Common")

local customBossOptions = {}
local pName = UnitName("player")

-------------------------------------------------------------------------------
-- Target monitoring
--

local enablezones, enablemobs, enableyells = {}, {}, {}
local monitoring = nil

local function enableBossModule(module, noSync)
	if not module:IsEnabled() then
		module:Enable()
		-- module:SendMessage("BigWigs_Message", module, "bosskill", string.format("%s enabled", module.displayName), "Core")
		if not noSync then
			module:Sync("EnableModule", module:GetName())
		end
	end
end

local function shouldReallyEnable(unit, moduleName)
	local module = addon.bossCore:GetModule(moduleName)
	if not module or module:IsEnabled() then return end
	if not module.VerifyEnable or module:VerifyEnable(unit) then
		enableBossModule(module)
	end
end

local function targetSeen(unit, targetModule)
	if type(targetModule) == "string" then
		shouldReallyEnable(unit, targetModule)
	else
		for i, module in next, targetModule do
			shouldReallyEnable(unit, module)
		end
	end
end

local function targetCheck(unit)
	if not UnitName(unit) or UnitIsCorpse(unit) or UnitIsDead(unit) or UnitPlayerControlled(unit) then return end
	local id = tonumber((UnitGUID(unit)):sub(7, 10), 16)
	if id and enablemobs[id] then
		targetSeen(unit, enablemobs[id])
	end
end
local function chatMsgMonsterYell(event, msg, source)
	for yell, mod in pairs(enableyells) do
		if yell == msg or msg:find(yell) then
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
			if module.isEngaged then module:Reboot() end
		end
	end
	if enablezones[GetCurrentMapAreaID()] then
		if not monitoring then
			monitoring = true
			addon:RegisterEvent("CHAT_MSG_MONSTER_YELL", chatMsgMonsterYell)
			addon:RegisterEvent("UPDATE_MOUSEOVER_UNIT", updateMouseover)
			addon:RegisterEvent("UNIT_TARGET", unitTargetChanged)
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
-- Testing
--

do
	local callbackRegistered = nil
	local spells = nil
	local messages = {}
	local colors = {"Important", "Personal", "Urgent", "Attention", "Positive"}
	local sounds = {"Long", "Info", "Alert", "Alarm", "Victory", false, false, false, false, false, false}
	local messageFormat = "%s: %s %s"

	local function barStopped(event, bar)
		local a = bar:Get("bigwigs:anchor")
		local key = bar.candyBarLabel:GetText()
		if a and messages[key] then
			local color = colors[math.random(1, #colors)]
			local sound = sounds[math.random(1, #sounds)]
			local formatted = messageFormat:format(color, key, sound and "("..sound..")" or "")
			addon:SendMessage("BigWigs_Message", addon, key, formatted, color, true, sound, nil, messages[key])
			if math.random(1, 4) == 2 then addon:SendMessage("BigWigs_FlashShake") end
			messages[key] = nil
		end
	end

	function addon:Test()
		if not spells then
			spells = {}
			for i = 1, GetNumSpellTabs() do
				local _, _, offset, numSpells = GetSpellTabInfo(i)
				for s = offset + 1, offset + numSpells do
					local spell = GetSpellBookItemName(s, BOOKTYPE_SPELL)
					local name = GetSpellInfo(spell .. "()")
					if name then spells[#spells+1] = name end
				end
			end
		end
		if not callbackRegistered then
			LibStub("LibCandyBar-3.0").RegisterCallback(self, "LibCandyBar_Stop", barStopped)
			callbackRegistered = true
		end
		local spell = spells[math.random(1, #spells)]
		-- Try not to run the same spell twice.
		if messages[spell] then
			for i = 1, #spells do
				if not messages[spells[i]] then
					spell = spells[i]
					break
				end
			end
		end
		local name, rank, icon = GetSpellInfo(spell.."()")
		local time = math.random(11, 45)
		addon:SendMessage("BigWigs_StartBar", addon, name, name, time, icon)
		messages[spell] = icon
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
			mod:Message("bosskill", L["%s has been defeated"]:format(mod.displayName), "Positive", nil, "Victory")
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
			for m in pairs(registered[sync]) do
				m:OnSync(sync, rest, nick)
			end
		end
	end

	function chatMsgAddon(event, prefix, message, sender)
		if prefix ~= "T" then return end
		local sync, rest = select(3, message:find("(%S+)%s*(.*)$"))
		if not sync then return end
		if not times[sync] or GetTime() > (times[sync] + 2) then
			times[sync] = GetTime()
			onSync(sync, rest, sender)
		end
	end

	function addon:AddSyncListener(module, sync)
		if not registered[sync] then registered[sync] = {} end
		registered[sync][module] = true
	end
	function addon:Transmit(sync, ...)
		if GetRealNumRaidMembers() == 0 and GetRealNumPartyMembers() == 0 then return end
		if not sync then return end
		if not times[sync] or GetTime() > (times[sync] + 2) then
			times[sync] = GetTime()
			SendAddonMessage("BigWigs", "T:"..strjoin(" ", sync, ...), "RAID")
			onSync(sync, strjoin(" ", ...), pName)
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
			shake = true,
			whisper = false,
			raidwarning = false,
			broadcast = false,
			showBlizzardWarnings = false,
		},
		global = {
			optionShiftIndexes = {},
		},
	}
	local db = LibStub("AceDB-3.0"):New("BigWigs3DB", defaults, true)
	local function profileUpdate()
		addon:SendMessage("BigWigs_ProfileUpdate")
	end
	db.RegisterCallback(self, "OnProfileChanged", profileUpdate)
	db.RegisterCallback(self, "OnProfileCopied", profileUpdate)
	db.RegisterCallback(self, "OnProfileReset", profileUpdate)
	self.db = db

	-- check for and load the babbles early if available, used for packed versions of bigwigs
	if LOCALE ~= "enUS" and not BB then
		local lbb = LibStub("LibBabble-Boss-3.0", true)
		if lbb then BB = lbb:GetUnstrictLookupTable() end
	end

	self:RegisterBossOption("bosskill", L["bosskill"], L["bosskill_desc"])
	self:RegisterBossOption("berserk", L["berserk"], L["berserk_desc"])

	-- this should ALWAYS be the last action of OnInitialize, it will trigger the loader to
	-- enable the foreign language pack, and other packs that want to be loaded when the core loads
	self:SendMessage("BigWigs_CoreLoaded")
	self.OnInitialize = nil
end

function addon:OnEnable()
	-- load the babbles, used for unpacked versions of bigwigs.
	if LOCALE ~= "enUS" and not BB then
		BB = LibStub("LibBabble-Boss-3.0"):GetUnstrictLookupTable()
	end
	self:RegisterMessage("BigWigs_AddonMessage", chatMsgAddon)
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", zoneChanged)

	self:SendMessage("BigWigs_CoreEnabled")
	self.pluginCore:Enable()
	self.bossCore:Enable()

	zoneChanged()
end

function addon:OnDisable()
	self:SendMessage("BigWigs_CoreDisabled")
	self.pluginCore:Disable()
	self.bossCore:Disable()
	monitoring = nil
end

do
	local outputFormat = "|cffffff00%s|r"
	function addon:Print(msg)
		print("Big Wigs:", outputFormat:format(msg))
	end
end

-------------------------------------------------------------------------------
-- API - if anything else is exposed on the BigWigs object, that's a mistake!
-- Well .. except the module API, obviously.
--

function addon:Translate(boss)
	if LOCALE ~= "enUS" and BB and BB[boss] then return BB[boss] end
	return boss
end

function addon:RegisterBossOption(key, name, desc, func)
	if customBossOptions[key] then
		error("The custom boss option %q has already been registered."):format(key)
	end
	customBossOptions[key] = { name, desc, func }
end

function addon:GetCustomBossOptions()
	return customBossOptions
end

function addon:NewBossLocale(name, locale, default) return AL:NewLocale(string.format("%s_%s", self.bossCore.name, name), locale, default) end

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

	local function new(core, module, zone, ...)
		if core:GetModule(module, true) then
			addon:Print(errorAlreadyRegistered:format(module))
		else
			if type(zone) == "string" then
				addon:Print(errorDeprecatedZone:format(module, tostring(zone)))
				return
			end
			local m = core:NewModule(module, ...)
			m.zoneId = zone
			return m
		end
	end

	-- A wrapper for :NewModule to present users with more information in the
	-- case where a module with the same name has already been registered.
	function addon:NewBoss(module, zone, ...)
		return new(self.bossCore, module, zone, ...)
	end
	function addon:NewPlugin(module, ...)
		return new(self.pluginCore, module, nil, ...)
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
			for k, v in pairs(module.optionHeaders) do
				if type(v) == "string" then
					if LOCALE ~= "enUS" and BB and BB[v] then
						module.optionHeaders[k] = BB[v]
					elseif CL[v] then
						module.optionHeaders[k] = CL[v]
					end
				elseif type(v) == "number" then
					module.optionHeaders[k] = GetSpellInfo(v)
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
						if C[flagName] and flagName ~= "EMPHASIZE" then
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
				for _, b in pairs(C) do
					if bit.band(defaultToggles[v], b) == b and bit.band(bitflags, b) ~= b then
						bitflags = bitflags + b
					end
				end
				if t == "string" then
					module.toggleDefaults[v] = bitflags
				elseif t == "number" and v > 1 then
					local n = GetSpellInfo(v)
					if not n then error(("Invalid spell ID %d in the toggleOptions for module %s."):format(v, module.name)) end
					module.toggleDefaults[n] = bitflags
				end
			end
			module.db = addon.db:RegisterNamespace(module.name, { profile = module.toggleDefaults })
		end
	end

	function addon:RegisterBossModule(module)
		if not module.displayName then module.displayName = module.moduleName end
		if LOCALE ~= "enUS" then
			if BB then
				if module.displayName and BB[module.displayName] then
					module.displayName = BB[module.displayName]
				end
			end
		end
		enablezones[module.zoneId] = true

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
		end
		self:SendMessage("BigWigs_PluginRegistered", module.moduleName, module)
	end
end

-------------------------------------------------------------------------------
-- Module cores
--

local bossCore = addon:NewModule("Bosses")
addon.bossCore = bossCore
bossCore:SetDefaultModuleLibraries("AceEvent-3.0", "AceTimer-3.0")
bossCore:SetDefaultModuleState(false)
function bossCore:OnDisable()
	for name, mod in self:IterateModules() do
		mod:Disable()
	end
end

local pluginCore = addon:NewModule("Plugins")
addon.pluginCore = pluginCore
pluginCore:SetDefaultModuleLibraries("AceEvent-3.0", "AceTimer-3.0")
pluginCore:SetDefaultModuleState(false)
function pluginCore:OnEnable()
	for name, mod in self:IterateModules() do
		mod:Enable()
	end
end

