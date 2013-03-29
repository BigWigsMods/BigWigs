-------------------------------------------------------------------------------
-- Prototype
--

local AL = LibStub("AceLocale-3.0")
local L = AL:GetLocale("Big Wigs: Common")
local UnitExists = UnitExists
local UnitAffectingCombat = UnitAffectingCombat
local GetSpellInfo = GetSpellInfo
local format = string.format
local type = type
local next = next
local core = BigWigs
local C = core.C
local band = bit.band
local pName = UnitName("player")
local bossUtilityFrame = CreateFrame("Frame")
local enabledModules = {}
local allowedEvents = {}
local difficulty = 3
local UpdateDispelStatus = nil
local UpdateMapData = nil
local myGUID = nil

-------------------------------------------------------------------------------
-- Debug
--

local debug = false -- Set to true to get (very spammy) debug messages.
local dbg = function(self, msg) print(format("[DBG:%s] %s", self.displayName, msg)) end

-------------------------------------------------------------------------------
-- Metatables
--

local metaMap = {__index = function(self, key) self[key] = {} return self[key] end}
local eventMap = setmetatable({}, metaMap)
local unitEventMap = setmetatable({}, metaMap)
local icons = setmetatable({}, {__index =
	function(self, key)
		local _, value
		if type(key) == "number" then
			if key > 0 then
				_, _, value = GetSpellInfo(key)
				if not value then
					print(format("Big Wigs: An invalid spell id (%d) is being used in a bar/message.", key))
				end
			else
				local _, _, _, abilityIcon = EJ_GetSectionInfo(-key)
				if abilityIcon and abilityIcon:trim():len() > 0 then
					value = abilityIcon
				else
					value = false
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
		else
			value = EJ_GetSectionInfo(-key)
		end
		self[key] = value
		return value
	end
})

-------------------------------------------------------------------------------
-- Core module functionality
--

local boss = {}
core.bossCore:SetDefaultModulePrototype(boss)
function boss:IsBossModule() return true end
function boss:OnInitialize() core:RegisterBossModule(self) end
function boss:OnEnable()
	if debug then dbg(self, "OnEnable()") end

	myGUID = UnitGUID("player")

	if IsEncounterInProgress() then
		self:CheckBossStatus("NoEngage") -- Prevent engaging if enabling during a boss fight (after a DC)
	end

	if self.SetupOptions then self:SetupOptions() end
	if type(self.OnBossEnable) == "function" then self:OnBossEnable() end

	-- Update Difficulty
	local _, _, diff = GetInstanceInfo()
	difficulty = diff

	-- Update Dispel Status
	UpdateDispelStatus()

	-- Update enabled modules list
	for i = #enabledModules, 1, -1 do
		local module = enabledModules[i]
		if module == self then return end
	end
	enabledModules[#enabledModules+1] = self

	self:SendMessage("BigWigs_OnBossEnable", self)
end
function boss:OnDisable()
	if debug then dbg(self, "OnDisable()") end
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
	wipe(allowedEvents)

	-- Re-add allowed events if more than one module is enabled
	for a, b in next, eventMap do
		for k in next, b do
			allowedEvents[k] = true
		end
	end

	-- Remove any registered sync listeners
	core:ClearSyncListeners(self)

	self.scheduledMessages = nil
	self.isWiping = nil
	self.isEngaged = nil

	self:SendMessage("BigWigs_OnBossDisable", self)
end
function boss:GetOption(spellId)
	return self.db.profile[spells[spellId]]
end
function boss:Reboot(isWipe)
	if debug then dbg(self, ":Reboot()") end
	-- Reboot covers everything including hard module reboots (clicking the minimap icon)
	self:SendMessage("BigWigs_OnBossReboot", self)
	if isWipe then
		-- Devs, in 99% of cases you'll want to use OnBossWipe
		self:SendMessage("BigWigs_OnBossWipe", self)
	end
	self:Disable()
	self:Enable()
end

function boss:NewLocale(locale, default) return AL:NewLocale(self.name, locale, default, "raw") end
function boss:GetLocale(state) return AL:GetLocale(self.name, state) end

-------------------------------------------------------------------------------
-- Enable triggers
--

function boss:RegisterEnableMob(...) core:RegisterEnableMob(self, ...) end
function boss:RegisterEnableYell(...) core:RegisterEnableYell(self, ...) end

-------------------------------------------------------------------------------
-- Combat log related code
--

do
	local modMissingFunction = "Module %q got the event %q (%d), but it doesn't know how to handle it."
	local missingArgument = "Missing required argument when adding a listener to %q."
	local missingFunction = "%q tried to register a listener to method %q, but it doesn't exist in the module."
	local invalidId = "Module %q tried to register an invalid spell id (%d) to event %q."

	function boss:CHAT_MSG_RAID_BOSS_EMOTE(event, msg, ...)
		if eventMap[self][event][msg] then
			self[eventMap[self][event][msg]](self, msg, ...)
		else
			for emote, func in next, eventMap[self][event] do
				if msg:find(emote, nil, true) or msg:find(emote) then -- Preserve backwards compat by leaving in the 2nd check
					self[func](self, msg, ...)
				end
			end
		end
	end
	function boss:Emote(func, ...)
		if not func then error(format(missingArgument, self.moduleName)) end
		if not self[func] then error(format(missingFunction, self.moduleName, func)) end
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
				if msg:find(yell, nil, true) or msg:find(yell) then -- Preserve backwards compat by leaving in the 2nd check
					self[func](self, msg, ...)
				end
			end
		end
	end
	function boss:Yell(func, ...)
		if not func then error(format(missingArgument, self.moduleName)) end
		if not self[func] then error(format(missingFunction, self.moduleName, func)) end
		if not eventMap[self].CHAT_MSG_MONSTER_YELL then eventMap[self].CHAT_MSG_MONSTER_YELL = {} end
		for i = 1, select("#", ...) do
			eventMap[self]["CHAT_MSG_MONSTER_YELL"][(select(i, ...))] = func
		end
		self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	end

	local args = {}
	bossUtilityFrame:SetScript("OnEvent", function(_, _, _, event, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, _, extraSpellId, amount)
		if allowedEvents[event] then
			if event == "UNIT_DIED" then
				local mobId = tonumber(destGUID:sub(6, 10), 16)
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
			else
				for i = #enabledModules, 1, -1 do
					local self = enabledModules[i]
					local m = eventMap[self][event]
					if m and (m[spellId] or m["*"]) then
						local func = m[spellId] or m["*"]
						-- DEVS! Please ask if you need args attached to the table that we've missed out!
						args.sourceGUID, args.sourceName, args.sourceFlags, args.sourceRaidFlags = sourceGUID, sourceName, sourceFlags, sourceRaidFlags
						args.destGUID, args.destName, args.destFlags, args.destRaidFlags = destGUID, destName, destFlags, destRaidFlags
						args.spellId, args.spellName, args.extraSpellId, args.extraSpellName, args.amount = spellId, spellName, extraSpellId, amount, amount
						if type(func) == "function" then
							func(args)
						else
							self[func](self, args)
							if debug then dbg(self, "Firing func: "..func) end
						end
					end
				end
			end
		end
	end)
	function boss:Log(event, func, ...)
		if not event or not func then error(format(missingArgument, self.moduleName)) end
		if type(func) ~= "function" and not self[func] then error(format(missingFunction, self.moduleName, func)) end
		if not eventMap[self][event] then eventMap[self][event] = {} end
		for i = 1, select("#", ...) do
			local id = (select(i, ...))
			eventMap[self][event][id] = func
			if type(id) == "number" and not GetSpellInfo(id) then
				print(format(invalidId, self.moduleName, id, event))
			end
		end
		allowedEvents[event] = true
		bossUtilityFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
	function boss:Death(func, ...)
		if not func then error(format(missingArgument, self.moduleName)) end
		if type(func) ~= "function" and not self[func] then error(format(missingFunction, self.moduleName, func)) end
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
				self[m[unit]](self, unit, ...)
			end
		end
	end

	function boss:RegisterUnitEvent(event, func, ...)
		if type(event) ~= "string" then error(format(noEvent, self.moduleName)) end
		if not ... then error(format(noUnit, self.moduleName)) end
		if (not func and not self[event]) or (func and not self[func]) then error(format(noFunc, self.moduleName, func or event)) end
		if not unitEventMap[self][event] then unitEventMap[self][event] = {} end
		for i = 1, select("#", ...) do
			local unit = select(i, ...)
			if not frameTbl[unit] then
				frameTbl[unit] = CreateFrame("Frame")
				frameTbl[unit]:SetScript("OnEvent", eventFunc)
			end
			unitEventMap[self][event][unit] = func or event
			frameTbl[unit]:RegisterUnitEvent(event, unit)
			if debug then dbg(self, "Adding: "..event..", "..unit) end
		end
	end
	function boss:UnregisterUnitEvent(event, ...)
		if type(event) ~= "string" then error(format(noEvent, self.moduleName)) end
		if not ... then error(format(noUnit, self.moduleName)) end
		if not unitEventMap[self][event] then return end
		for i = 1, select("#", ...) do
			local unit = select(i, ...)
			unitEventMap[self][event][unit] = nil
			local keepRegistered
			for i = #enabledModules, 1, -1 do
				local m = unitEventMap[enabledModules[i]][event]
				if m and m[unit] then
					keepRegistered = true
				end
			end
			if not keepRegistered then
				if debug then dbg(self, "Removing: "..event..", "..unit) end
				frameTbl[unit]:UnregisterEvent(event)
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Engage / wipe checking + unit scanning
--

do
	local function wipeCheck(module)
		if not IsEncounterInProgress() then
			if debug then dbg(module, "Wipe!") end
			module:Reboot(true)
		end
	end

	function boss:StartWipeCheck()
		self:StopWipeCheck()
		self.isWiping = self:ScheduleRepeatingTimer(wipeCheck, 1, self)
	end
	function boss:StopWipeCheck()
		if self.isWiping then
			self:CancelTimer(self.isWiping)
			self.isWiping = nil
		end
	end

	function boss:CheckBossStatus(noEngage)
		local hasBoss = UnitHealth("boss1") > 100 or UnitHealth("boss2") > 100 or UnitHealth("boss3") > 100 or UnitHealth("boss4") > 100 or UnitHealth("boss5") > 100
		if not hasBoss and self.isEngaged then
			if debug then dbg(self, ":CheckBossStatus wipeCheck scheduled.") end
			self:ScheduleTimer(wipeCheck, 2, self)
		elseif not self.isEngaged and hasBoss then
			if debug then dbg(self, ":CheckBossStatus Engage called.") end
			local guid = UnitGUID("boss1") or UnitGUID("boss2") or UnitGUID("boss3") or UnitGUID("boss4") or UnitGUID("boss5")
			local module = core:GetEnableMobs()[tonumber(guid:sub(6, 10), 16)]
			local modType = type(module)
			if modType == "string" then
				if module == self.moduleName then
					self:Engage(noEngage == "NoEngage" and noEngage)
				else
					self:Disable()
				end
			elseif modType == "table" then
				for i = 1, #module do
					if module[i] == self.moduleName then
						self:Engage(noEngage == "NoEngage" and noEngage)
						break
					end
				end
				if not self.isEngaged then self:Disable() end
			end
		end
		if debug then dbg(self, ":CheckBossStatus called with no result. Engaged = "..tostring(self.isEngaged).." hasBoss = "..tostring(hasBoss)) end
	end
end

do
	local t = nil
	local function buildTable()
		t = {
			"boss1", "boss2", "boss3", "boss4", "boss5",
			"target", "targettarget",
			"focus", "focustarget",
			"party1target", "party2target", "party3target", "party4target",
			"mouseover", "mouseovertarget"
		}
		for i = 1, 25 do t[#t+1] = format("raid%dtarget", i) end
		buildTable = nil
	end
	local function findTargetByGUID(id)
		if not t then buildTable() end
		for i, unit in next, t do
			local guid = UnitGUID(unit)
			if guid and not UnitIsPlayer(unit) then
				if type(id) == "number" then guid = tonumber(guid:sub(6, 10), 16) end
				if guid == id then return unit end
			end
		end
	end
	function boss:GetUnitIdByGUID(id) return findTargetByGUID(id) end

	local function scan(self)
		for mobId, entry in next, core:GetEnableMobs() do
			if type(entry) == "table" then
				for i, module in next, entry do
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

	function boss:CheckForEngage()
		if debug then dbg(self, ":CheckForEngage initiated.") end
		local go = scan(self)
		if go then
			if debug then dbg(self, "Engage scan found active boss entities, transmitting engage sync.") end
			self:Sync("BossEngaged", self.moduleName)
		else
			if debug then dbg(self, "Engage scan did NOT find any active boss entities. Re-scheduling another engage check in 0.5 seconds.") end
			self:ScheduleTimer("CheckForEngage", .5)
		end
	end

	-- XXX What if we die and then get battleressed?
	-- XXX First of all, the CheckForWipe every 2 seconds would continue scanning.
	-- XXX Secondly, if the boss module registers for PLAYER_REGEN_DISABLED, it would
	-- XXX trigger again, and CheckForEngage (possibly) invoked, which results in
	-- XXX a new BossEngaged sync -> :Engage -> :OnEngage on the module.
	-- XXX Possibly a concern?
	function boss:CheckForWipe()
		if debug then dbg(self, ":CheckForWipe initiated.") end
		local go = scan(self)
		if not go then
			if debug then dbg(self, "Wipe scan found no active boss entities, rebooting module.") end
			self:Reboot(true)
			if self.OnWipe then self:OnWipe() end
		else
			if debug then dbg(self, "Wipe scan found active boss entities (" .. tostring(go) .. "). Re-scheduling another wipe check in 2 seconds.") end
			self:ScheduleTimer("CheckForWipe", 2)
		end
	end

	function boss:Engage(noEngage)
		-- Engage
		self.isEngaged = true

		-- Prevent rare combat log bug
		CombatLogClearEntries()

		if debug then dbg(self, ":Engage") end

		if not noEngage or noEngage ~= "NoEngage" then
			myGUID = UnitGUID("player")

			-- Update Difficulty
			local _, _, diff = GetInstanceInfo()
			difficulty = diff

			-- Update Dispel Status
			UpdateDispelStatus()

			-- Update map size
			UpdateMapData()

			if self.OnEngage then
				self:OnEngage(diff)
			end

			self:SendMessage("BigWigs_OnBossEngage", self, diff)
		end
	end

	function boss:Win()
		if debug then dbg(self, ":Win") end
		self:Sync("Death", self.moduleName)
		wipe(icons) -- Wipe icon cache
		wipe(spells)
		self:SendMessage("BigWigs_OnBossWin", self)
	end
end

-------------------------------------------------------------------------------
-- Misc utility functions
--

function boss:Difficulty()
	return difficulty
end

function boss:LFR()
	return difficulty == 7
end

function boss:Heroic()
	return difficulty == 5 or difficulty == 6
end

function boss:MobId(guid)
	return guid and tonumber(guid:sub(6, 10), 16) or -1
end

function boss:SpellName(spellId)
	return spells[spellId]
end

function boss:Me(guid)
	return myGUID == guid
end

do
	local SetMapToCurrentZone = BigWigsLoader.SetMapToCurrentZone
	local GetPlayerMapPosition = GetPlayerMapPosition

	local activeMap, mapWidth, mapHeight = nil, 0, 0

	function UpdateMapData()
		activeMap = nil
		local mapName = GetMapInfo()
		local mapData = core:GetPlugin("Proximity"):GetMapData()
		if not mapData[mapName] then return end

		local currentFloor = GetCurrentMapDungeonLevel()
		if currentFloor == 0 then currentFloor = 1 end

		local id = mapData[mapName][currentFloor]
		if id then
			activeMap = true
			mapWidth, mapHeight = id[1], id[2]
		end
	end

	function boss:Range(player)
		if not activeMap then return 200 end

		SetMapToCurrentZone()
		local tx, ty = GetPlayerMapPosition(player)
		if tx == 0 and ty == 0 then return 200 end -- position is unknown or unit is invalid
		local px, py = GetPlayerMapPosition("player")

		local dx = (tx - px) * mapWidth
		local dy = (ty - py) * mapHeight
		local distance = (dx * dx + dy * dy) ^ 0.5

		return distance
	end
end

-------------------------------------------------------------------------------
-- Role checking
--

function boss:Tank(unit)
	if unit then
		return GetPartyAssignment("MAINTANK", unit) or UnitGroupRolesAssigned(unit) == "TANK"
	else
		local tree = GetSpecialization()
		local role = GetSpecializationRole(tree)
		return role == "TANK"
	end
end

function boss:Healer()
	local tree = GetSpecialization()
	local role = GetSpecializationRole(tree)
	return role == "HEALER"
end

--[[
function boss:Damager()
	if core.db.profile.ignorerole then return true end
	local tree = GetSpecialization()
	local role
	local _, class = UnitClass("player")
	if
		class == "MAGE" or class == "WARLOCK" or class == "HUNTER" or (class == "DRUID" and tree == 1) or
		(class == "PRIEST" and tree == 3) or (class == "SHAMAN" and tree == 1)
	then
		role = "RANGED"
	elseif
		class == "ROGUE" or (class == "WARRIOR" and tree ~= 3) or (class == "DEATHKNIGHT" and tree ~= 1) or
		(class == "PALADIN" and tree == 3) or (class == "DRUID" and tree == 2) or (class == "SHAMAN" and tree == 2)
	then
		role = "MELEE"
	end
	return role
end
]]

do
	local offDispel, defDispel = "", ""
	function UpdateDispelStatus()
		offDispel, defDispel = "", ""
		if IsSpellKnown(19801) or IsSpellKnown(2908) or IsSpellKnown(5938) then
			-- Tranq (Hunter), Soothe (Druid), Shiv (Rogue)
			offDispel = offDispel .. "enrage,"
		end
		if IsSpellKnown(19801) or IsSpellKnown(32375) or IsSpellKnown(528) or IsSpellKnown(370) or IsSpellKnown(30449) or IsSpellKnown(110707) or IsSpellKnown(110802) then
			-- Tranq (Hunter), Mass Dispel (Priest), Dispel Magic (Priest), Purge (Shaman), Spellsteal (Mage), Mass Dispel (Symbiosis), Purge (Symbiosis)
			offDispel = offDispel .. "magic,"
		end
		if IsSpellKnown(527) or IsSpellKnown(77130) or (IsSpellKnown(115450) and IsSpellKnown(115451)) or (IsSpellKnown(4987) and IsSpellKnown(53551)) or IsSpellKnown(88423) then
			-- Purify (Priest), Purify Spirit (Shaman), Detox (Monk-Modifier), Cleanse (Paladin-Modifier), Nature's Cure (Resto Druid)
			defDispel = defDispel .. "magic,"
		end
		if IsSpellKnown(527) or IsSpellKnown(115450) or IsSpellKnown(4987) then
			-- Purify (Priest), Detox (Monk), Cleanse (Paladin)
			defDispel = defDispel .. "disease,"
		end
		if IsSpellKnown(88423) or IsSpellKnown(115450) or IsSpellKnown(4987) or IsSpellKnown(2782) then
			-- Nature's Cure (Resto Druid), Detox (Monk), Cleanse (Paladin), Remove Corruption (Druid)
			defDispel = defDispel .. "poison,"
		end
		if IsSpellKnown(88423) or IsSpellKnown(2782) or IsSpellKnown(77130) or IsSpellKnown(475) then
			-- Nature's Cure (Resto Druid), Remove Corruption (Druid), Purify Spirit (Shaman), Remove Curse (Mage)
			defDispel = defDispel .. "curse,"
		end
	end
	function boss:Dispeller(dispelType, isOffensive, key)
		if key then
			if type(key) == "number" and key > 0 then key = spells[key] end
			if band(self.db.profile[key], C.DISPEL) ~= C.DISPEL then return true end
		end
		if isOffensive then
			if offDispel:find(dispelType, nil, true) then
				return true
			end
		else
			if defDispel:find(dispelType, nil, true) then
				return true
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Option silencer
--

local silencedOptions = {}
do
	bossUtilityFrame:Hide()
	BigWigsLoader:RegisterMessage("BigWigs_SilenceOption", function(event, key, time)
		if key ~= nil then -- custom bars have a nil key
			silencedOptions[key] = time
			bossUtilityFrame:Show()
		end
	end)
	local total = 0
	bossUtilityFrame:SetScript("OnUpdate", function(self, elapsed)
		total = total + elapsed
		if total >= 0.5 then
			for k, t in next, silencedOptions do
				local newT = t - total
				if newT < 0 then
					silencedOptions[k] = nil
				else
					silencedOptions[k] = newT
				end
			end
			if not next(silencedOptions) then
				self:Hide()
			end
			total = 0
		end
	end)
end

-------------------------------------------------------------------------------
-- Boss module APIs for messages, bars, icons, etc.
--

local checkFlag = nil
do
	local noDefaultError   = "Module %s uses %q as a toggle option, but it does not exist in the modules default values."
	local notNumberError   = "Module %s tried to access %q, but in the database it's a %s."
	local nilKeyError      = "Module %s tried to check the bitflags for a nil option key."
	local invalidFlagError = "Module %s tried to check for an invalid flag type %q (%q). Flags must be bits."
	local noDBError        = "Module %s does not have a .db property, which is weird."
	checkFlag = function(self, key, flag)
		if type(key) == "nil" then error(format(nilKeyError, self.name)) end
		if type(flag) ~= "number" then error(format(invalidFlagError, self.name, type(flag), tostring(flag))) end
		if silencedOptions[key] then return end
		if type(key) == "number" and key > 0 then key = spells[key] end
		if type(self.db) ~= "table" then error(format(noDBError, self.name)) end
		if type(self.db.profile[key]) ~= "number" then
			if not self.toggleDefaults[key] then
				error(format(noDefaultError, self.name, key))
			end
			if debug then
				error(format(notNumberError, self.name, key, type(self.db.profile[key])))
			end
			self.db.profile[key] = self.toggleDefaults[key]
		end

		local fullKey = self.db.profile[key]
		if band(fullKey, C.TANK) == C.TANK and not self:Tank() then return end
		if band(fullKey, C.HEALER) == C.HEALER and not self:Healer() then return end
		if band(fullKey, C.TANK_HEALER) == C.TANK_HEALER and not self:Tank() and not self:Healer() then return end
		return band(fullKey, flag) == flag
	end
end

-- PROXIMITY
function boss:OpenProximity(key, range, player, isReverse)
	if checkFlag(self, key, C.PROXIMITY) then
		self:SendMessage("BigWigs_ShowProximity", self, range, key, player, isReverse)
	end
end

function boss:CloseProximity(key)
	if checkFlag(self, key or "proximity", C.PROXIMITY) then
		self:SendMessage("BigWigs_HideProximity", self, key or "proximity")
	end
end

-- MESSAGES
function boss:CancelDelayedMessage(text)
	if self.scheduledMessages and self.scheduledMessages[text] then
		self:CancelTimer(self.scheduledMessages[text])
		self.scheduledMessages[text] = nil
	end
end

function boss:DelayedMessage(key, delay, color, text, icon, sound)
	if checkFlag(self, key, C.MESSAGE) then
		self:CancelDelayedMessage(text or key)
		if not self.scheduledMessages then self.scheduledMessages = {} end
		self.scheduledMessages[text or key] = self:ScheduleTimer("Message", delay, key, color, sound, text, icon or false)
	end
end

function boss:Message(key, color, sound, text, icon)
	if checkFlag(self, key, C.MESSAGE) then
		local textType = type(text)
		self:SendMessage("BigWigs_Message", self, key, textType == "string" and text or spells[text or key], color, sound, icon ~= false and icons[icon or textType == "number" and text or key])
	end
end

function boss:RangeMessage(key, color, sound, text, icon)
	if not checkFlag(self, key, C.MESSAGE) then return end
	local textType = type(text)
	self:SendMessage("BigWigs_Message", self, key, format(L.near, textType == "string" and text or spells[text or key]), color == nil and "Personal" or color, sound == nil and "Alarm" or sound, icon ~= false and icons[icon or textType == "number" and text or key])
end

do
	local hexColors = {}
	for k, v in next, (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS) do
		hexColors[k] = "|cff" .. format("%02x%02x%02x", v.r * 255, v.g * 255, v.b * 255)
	end
	local coloredNames = setmetatable({}, {__index =
		function(self, key)
			if type(key) == "nil" then return nil end
			local _, class = UnitClass(key)
			if class then
				self[key] = hexColors[class] .. key:gsub("%-.+", "*") .. "|r" -- Replace server names with *
			else
				return key
			end
			return self[key]
		end
	})

	local mt = {
		__newindex = function(self, key, value)
			rawset(self, key, coloredNames[value])
		end
	}
	function boss:NewTargetList()
		return setmetatable({}, mt)
	end

	function boss:StackMessage(key, player, stack, color, sound, text, icon)
		if checkFlag(self, key, C.MESSAGE) then
			local textType = type(text)
			self:SendMessage("BigWigs_Message", self, key, format(L.stack, stack or 1, textType == "string" and text or spells[text or key], coloredNames[player]), color, sound, icon ~= false and icons[icon or textType == "number" and text or key])
		end
	end

	function boss:TargetMessage(key, player, color, sound, text, icon, alwaysPlaySound)
		local textType = type(text)
		local msg = textType == "string" and text or spells[text or key]
		local texture = icon ~= false and icons[icon or textType == "number" and text or key]

		if type(player) == "table" then
			local list = table.concat(player, ", ")
			if not list:find(pName, nil, true) then
				if not checkFlag(self, key, C.MESSAGE) or checkFlag(self, key, C.ME_ONLY) then wipe(player) return end
				if not alwaysPlaySound then sound = nil end
			else
				if not checkFlag(self, key, C.MESSAGE) and not checkFlag(self, key, C.ME_ONLY) then wipe(player) return end
			end
			self:SendMessage("BigWigs_Message", self, key, format(L.other, msg, list), color, sound, texture)
			wipe(player)
		else
			if not player then
				if checkFlag(self, key, C.MESSAGE) then
					self:SendMessage("BigWigs_Message", self, key, format(L.other, msg, "???"), color == "Personal" and "Important" or color, alwaysPlaySound and sound, texture)
				end
				return
			end
			if UnitIsUnit(player, "player") then
				if checkFlag(self, key, C.MESSAGE) or checkFlag(self, key, C.ME_ONLY) then
					self:SendMessage("BigWigs_Message", self, key, format(L.you, msg), "Personal", sound, texture)
				end
			else
				if checkFlag(self, key, C.MESSAGE) and not checkFlag(self, key, C.ME_ONLY) then
					-- Change color and remove sound (if not alwaysPlaySound) when warning about effects on other players
					self:SendMessage("BigWigs_Message", self, key, format(L.other, msg, coloredNames[player]), color == "Personal" and "Important" or color, alwaysPlaySound and sound, texture)
				end
			end
		end
	end
end

-- BARS
function boss:Bar(key, length, text, icon)
	local textType = type(text)
	if checkFlag(self, key, C.BAR) then
		self:SendMessage("BigWigs_StartBar", self, key, textType == "string" and text or spells[text or key], length, icons[icon or textType == "number" and text or key])
	end
	if checkFlag(self, key, C.EMPHASIZE) then
		self:SendMessage("BigWigs_StartEmphasize", self, key, textType == "string" and text or spells[text or key], length)
	end
end

function boss:CDBar(key, length, text, icon)
	local textType = type(text)
	if checkFlag(self, key, C.BAR) then
		self:SendMessage("BigWigs_StartBar", self, key, textType == "string" and text or spells[text or key], length, icons[icon or textType == "number" and text or key], true)
	end
	if checkFlag(self, key, C.EMPHASIZE) then
		self:SendMessage("BigWigs_StartEmphasize", self, key, textType == "string" and text or spells[text or key], length)
	end
end

function boss:TargetBar(key, length, player, text, icon)
	if checkFlag(self, key, C.BAR) then
		local textType = type(text)
		if UnitIsUnit(player, "player") then
			self:SendMessage("BigWigs_StartBar", self, key, format(L.you, textType == "string" and text or spells[text or key]), length, icons[icon or textType == "number" and text or key])
		else
			self:SendMessage("BigWigs_StartBar", self, key, format(L.other, textType == "string" and text or spells[text or key], player:gsub("%-.+", "*")), length, icons[icon or textType == "number" and text or key])
		end
	end
end

function boss:StopBar(text, player)
	if player then
		if UnitIsUnit(player, "player") then
			self:SendMessage("BigWigs_StopBar", self, format(L.you, type(text) == "number" and spells[text] or text))
		else
			self:SendMessage("BigWigs_StopBar", self, format(L.other, type(text) == "number" and spells[text] or text, player:gsub("%-.+", "*")))
		end
	else
		self:SendMessage("BigWigs_StopBar", self, type(text) == "number" and spells[text] or text)
		self:SendMessage("BigWigs_StopEmphasize", self, key, type(text) == "string" and text or spells[text or key])
	end
end

-- ICONS
function boss:PrimaryIcon(key, player)
	if key and not checkFlag(self, key, C.ICON) then return end
	if not player then
		self:SendMessage("BigWigs_RemoveRaidIcon", 1)
	else
		self:SendMessage("BigWigs_SetRaidIcon", player, 1)
	end
end

function boss:SecondaryIcon(key, player)
	if key and not checkFlag(self, key, C.ICON) then return end
	if not player then
		self:SendMessage("BigWigs_RemoveRaidIcon", 2)
	else
		self:SendMessage("BigWigs_SetRaidIcon", player, 2)
	end
end

-- MISC
function boss:Flash(key, icon)
	if checkFlag(self, key, C.FLASH) then
		self:SendMessage("BigWigs_Flash", self, key)
	end
	if checkFlag(self, key, C.PULSE) then
		self:SendMessage("BigWigs_Pulse", self, key, icons[icon or key])
	end
end

function boss:Say(key, msg, directPrint)
	if not checkFlag(self, key, C.SAY) then return end
	if directPrint then
		SendChatMessage(msg, "SAY")
	else
		SendChatMessage(format(L.on, msg and (type(msg) == "number" and spells[msg] or msg) or spells[key], pName), "SAY")
	end
end

function boss:PlaySound(key, sound)
	if not checkFlag(self, key, C.MESSAGE) then return end
	self:SendMessage("BigWigs_Sound", sound)
end

-- Examples of API use in a module:
-- self:Sync("abilityPrefix", playerName)
-- self:Sync("ability")
function boss:Sync(...) core:Transmit(...) end

function boss:AddSyncListener(sync)
	if not self.syncListeners then self.syncListeners = {} end
	self.syncListeners[#self.syncListeners+1] = sync
	core:AddSyncListener(self, sync)
end

function boss:Berserk(seconds, noEngageMessage, customBoss, customBerserk, customFinalMessage)
	local boss = customBoss or self.displayName
	local key = "berserk"

	-- There are many Berserks, but we use 26662 because Brutallus uses this one.
	-- Brutallus is da bomb.
	local berserk, icon = (GetSpellInfo(26662)), 26662
	-- XXX "Interface\\EncounterJournal\\UI-EJ-Icons" ?
	-- http://static.wowhead.com/images/icons/ej-enrage.png
	if type(customBerserk) == "number" then
		key = customBerserk
		berserk, icon = (GetSpellInfo(customBerserk)), customBerserk
	elseif type(customBerserk) == "string" then
		berserk = customBerserk
	end

	if not noEngageMessage then
		-- Engage warning with minutes to enrage
		self:Message(key, "Attention", nil, format(L.custom_start, boss, berserk, seconds / 60), false)
	end

	-- Half-way to enrage warning.
	local half = seconds / 2
	local m = half % 60
	local halfMin = (half - m) / 60
	self:DelayedMessage(key, half + m, "Positive", format(L.custom_min, berserk, halfMin))

	self:DelayedMessage(key, seconds - 60, "Positive", format(L.custom_min, berserk, 1))
	self:DelayedMessage(key, seconds - 30, "Urgent", format(L.custom_sec, berserk, 30))
	self:DelayedMessage(key, seconds - 10, "Urgent", format(L.custom_sec, berserk, 10))
	self:DelayedMessage(key, seconds - 5, "Important", format(L.custom_sec, berserk, 5))
	self:DelayedMessage(key, seconds, "Important", customFinalMessage or format(L.custom_end, boss, berserk), icon, "Alarm")

	self:Bar(key, seconds, berserk, icon)
end

