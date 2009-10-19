BigWigs = LibStub("AceAddon-3.0"):NewAddon("BigWigs", "AceEvent-3.0", "AceTimer-3.0")
local addon = BigWigs
addon:SetEnabledState(false)
addon:SetDefaultModuleState(false)

-- locale stuff for BZ or BB conditionals
local LOCALE = BigWigsLoader.LOCALE
local BB, BZ

local GetSpellInfo = GetSpellInfo

local C

local AL = LibStub("AceLocale-3.0")
local L = AL:GetLocale("Big Wigs")

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
		-- XXX DEBUG
		-- module:SendMessage("BigWigs_Message", string.format(L["%s enabled"], module.displayName), "Core")
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
	--XXX 3.3 COMPAT REMOVE ME
	local id = QueryQuestsCompleted and tonumber((UnitGUID(unit)):sub(-12, -9), 16) or tonumber((UnitGUID(unit)):sub(-12, -7), 16)
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
local function targetChanged() targetCheck("target") end

local function zoneChanged()
	if enablezones[GetRealZoneText()] or enablezones[GetSubZoneText()] or enablezones[GetZoneText()] then
		if not monitoring then
			monitoring = true
			addon:RegisterEvent("CHAT_MSG_MONSTER_YELL", chatMsgMonsterYell)
			addon:RegisterEvent("PLAYER_TARGET_CHANGED", targetChanged)
			addon:RegisterEvent("UPDATE_MOUSEOVER_UNIT", updateMouseover)
		end
	elseif monitoring then
		monitoring = nil
		addon:UnregisterEvent("CHAT_MSG_MONSTER_YELL")
		addon:UnregisterEvent("PLAYER_TARGET_CHANGED")
		addon:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	end
end

do
	local function add(moduleName, tbl, entry)
		local t = type(tbl[entry])
		if t == "nil" then
			tbl[entry] = moduleName
		elseif t == "table" then
			tinsert(tbl[entry], moduleName)
		elseif t == "string" then
			local tmp = tbl[entry]
			tbl[entry] = { tmp, moduleName }
		else
			error("What the hell .. Unknown type in a enable trigger table.")
		end
	end
	function addon:RegisterEnableMob(module, ...)
		for i = 1, select("#", ...) do
			add(module.moduleName, enablemobs, (select(i, ...)))
		end
	end
	function addon:RegisterEnableYell(module, ...)
		for i = 1, select("#", ...) do
			add(module.moduleName, enableyells, (select(i, ...)))
		end
	end
	function addon:GetEnableMobs() return enablemobs end
	function addon:GetEnableYells() return enableyells end
end

-------------------------------------------------------------------------------
-- Testing
--

local bigWigsTest = nil
do
	local spells = nil
	local colors = {"Important", "Personal", "Urgent", "Attention", "Positive", "Bosskill", "Core"}
	local sounds = {"Long", "Info", "Alert", "Alarm", "Victory", false, false, false, false, false, false}
	local messageFormat = "%s: %s %s"

	local tests = {}

	local function sendTestMessage(message)
		if not tests[message] then return end -- spamming test can cause double messages due to the limited amount of spells
		addon:SendMessage("BigWigs_Message", unpack(tests[message]))
		if math.random(1,4) == 2 then addon:SendMessage("BigWigs_FlashShake") end
		wipe(tests[message])
		tests[message] = nil
	end

	function addon:Test()
		if not spells then
			spells = {}
			for i = 2, MAX_SKILLLINE_TABS do
				local _, _, offset, numSpells = GetSpellTabInfo(i)
				if not offset then break end
				for s = offset + 1, offset + numSpells do
					local spell = GetSpellName(s, BOOKTYPE_SPELL)
					tinsert(spells, spell)
				end
			end
		end
		local spell = spells[math.random(1, #spells)]
		local name, rank, icon = GetSpellInfo(spell.."()")
		local time = math.random(11, 45)
		local color = colors[math.random(1, #colors)]
		local sound = sounds[math.random(1, #sounds)]
		addon:SendMessage("BigWigs_StartBar", addon, name, time, icon)
		local formatted = messageFormat:format(color, name, sound and "("..sound..")" or "")
		tests[formatted] = { formatted, color, true, sound, nil, icon }
		addon:ScheduleTimer(sendTestMessage, time, formatted)
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
		
		-- MultiDeath is gone, but lets have it here for another release cycle for compat.
	elseif (sync == "Death" or sync == "MultiDeath") then
		local mod = addon:GetBossModule(moduleName, true)
		if mod and mod:IsEnabled() then
			mod:Message("bosskill", L["%s has been defeated"]:format(mod.displayName), "Bosskill", nil, "Victory")
			mod:PrimaryIcon(false)
			mod:SecondaryIcon(false)
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
	
	-- XXX We need to remove this error for release, since people can have boss modules that we don't have.
	-- XXX Either custom ones or ones that are in older instances, like MC, BWL, etc.
	-- local bossEngagedSyncError = "Got a BossEngaged sync for %q from %s, but there's no such module."

	local function onSync(sync, rest, nick)
		if not registered[sync] then return end
		if sync == "BossEngaged" then
			local m = addon:GetBossModule(rest, true)
			if not m then
				-- print(bossEngagedSyncError:format(rest, nick))
				return
			end
			m:UnregisterEvent("PLAYER_REGEN_DISABLED")
			-- XXX DEBUG
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

	function chatMsgAddon(event, prefix, message, type, sender)
		if prefix ~= "BigWigs" then return end
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
		if GetRealNumRaidMembers() == 0 or GetRealNumPartyMembers() == 0 then return end
		if not sync then return end
		if not times[sync] or GetTime() > (times[sync] + 2) then
			times[sync] = GetTime()
			SendAddonMessage("BigWigs", strjoin(" ", sync, ...), "RAID")
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
			flashshake = true,
			whisper = false,
			raidwarning = false,
			broadcast = false,
			showBlizzardWarnings = false,
		}
	}
	self.db = LibStub("AceDB-3.0"):New("BigWigs3DB", defaults, true)

	-- check for and load the babbles early if available, used for packed versions of bigwigs
	if LOCALE ~= "enUS" and ( not BZ or not BB ) and LibStub("LibBabble-Boss-3.0", true) and LibStub("LibBabble-Zone-3.0", true) then
		BZ = LibStub("LibBabble-Zone-3.0"):GetUnstrictLookupTable()
		BB = LibStub("LibBabble-Boss-3.0"):GetUnstrictLookupTable()
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
	if LOCALE ~= "enUS" and (not BZ or not BB) then
		BZ = LibStub("LibBabble-Zone-3.0"):GetUnstrictLookupTable()
		BB = LibStub("LibBabble-Boss-3.0"):GetUnstrictLookupTable()
	end
	self:RegisterEvent("CHAT_MSG_ADDON", chatMsgAddon)
	self:RegisterEvent("ZONE_CHANGED", zoneChanged)
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

function addon:Print(...)
	print("|cff33ff99BigWigs|r:", ...)
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


-------------------------------------------------------------------------------
-- Module handling
--

do
	function addon:New(module)
		error(("%q tried to use the deprecated :New() API. Please notify the author that he needs to update it for Big Wigs 3."):format(module))
	end

	local function new(core, module, zone, ...)
		if core:GetModule(module, true) then
			local oldM = core:GetModule(module)
			print(L["already_registered"]:format(module, core.moduleName))
		else
			local m = core:NewModule(module, ...)
			if zone then m.zoneName = zone end
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

	function addon:RegisterBossModule(module)
		if not C then C = self.C end
		if not self.defaultToggles then
			self.defaultToggles = setmetatable({
				berserk = C.BAR + C.MESSAGE,
				bosskill = C.MESSAGE,
				proximity = C.PROXIMITY
			}, {__index = function(self, key) 
				if not rawget(self, key) then
					return C.BAR + C.MESSAGE
				end
			end } )
		end
		if not module.displayName then module.displayName = module.moduleName end
		
		-- Translate the bossmodule if appropriate
		if LOCALE ~= "enUS" and BB and BZ then
			module.zoneName = BZ[module.zoneName] or module.zoneName
			if module.otherMenu then
				module.otherMenu = BZ[module.otherMenu]
			end
			if module.displayName and BB[module.displayName] then
				module.displayName = BB[module.displayName]
			end
			if module.optionHeaders then
				for k, v in pairs(module.optionHeaders) do
					if type(v) == "string" and BB[v] then
						module.optionHeaders[k] = BB[v]
					end
				end
			end
		end

		-- XXX Target monitor
		enablezones[module.zoneName] = true
		
		if module.optionHeaders then
			local CL = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
			for k, v in pairs(module.optionHeaders) do
				if type(v) == "string" and CL[v] then
					module.optionHeaders[k] = CL[v]
				end
			end
		end

		if module.toggleOptions then
			module.toggleDefaults = {}
			local bf
			for k, v in next, module.toggleOptions do
				bf = 0
				local t = type(v)
				if t == "table" then
					for i=2,#v,1 do
						if C[v[i]] and v[i] ~= "EMPHASIZE" then
							bf = bf + C[v[i]]
						else
							error(("%q tried to register '%q' as a bitflag for toggleoption '%q'"):format(module.moduleName, v[1], v[i]))
						end
					end
					v = v[1]
					t = type(v)
				end
				-- mix in default toggles for keys we know this allows for mod.toggleOptions = {1234, {"bosskill", "bar"}} while bosskill usually only has message
				for n, b in pairs(C) do
					if bit.band(self.defaultToggles[v], b) == b and bit.band(bf, b) ~= b then
						bf = bf + b
					end
				end
				if t == "string"  then
					module.toggleDefaults[v] = bf
				elseif t == "number" and v > 1 then
					local n = GetSpellInfo(v)
					if not n then error(("Invalid spell ID %d in the toggleOptions for module %s."):format(v, name)) end
					module.toggleDefaults[n] = bf
				end
			end
			module.db = self.db:RegisterNamespace(module.name, { profile = module.toggleDefaults })
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

