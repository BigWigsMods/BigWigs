-------------------------------------------------------------------------------
-- Prototype
--

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local UnitAffectingCombat, UnitIsPlayer, UnitGUID, UnitPosition, UnitDistanceSquared, UnitIsConnected = UnitAffectingCombat, UnitIsPlayer, UnitGUID, UnitPosition, UnitDistanceSquared, UnitIsConnected
local EJ_GetSectionInfo, GetSpellInfo, GetSpellTexture, IsSpellKnown = EJ_GetSectionInfo, GetSpellInfo, GetSpellTexture, IsSpellKnown
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local SendChatMessage = BigWigsLoader.SendChatMessage
local format, find, sub, gsub, band = string.format, string.find, string.sub, string.gsub, bit.band
local type, next, tonumber = type, next, tonumber
local core = BigWigs
local C = core.C
local pName = UnitName("player")
local hasVoice = GetAddOnEnableState(pName, "BigWigs_Voice") > 0
local bossUtilityFrame = CreateFrame("Frame")
local enabledModules = {}
local allowedEvents = {}
local difficulty = 0
local UpdateDispelStatus, UpdateInterruptStatus = nil, nil
local myGUID, myRole, myDamagerRole = nil, nil, nil
local solo = false
local updateData = function(module)
	myGUID = UnitGUID("player")

	local tree = GetSpecialization()
	if tree then
		myRole = GetSpecializationRole(tree)
		myDamagerRole = nil
		if IsSpellKnown(152276) and UnitBuff("player", (GetSpellInfo(156291))) then -- Gladiator Stance
			myRole = "DAMAGER"
		end
		if myRole == "DAMAGER" then
			local _, class = UnitClass("player")
			if
				class == "MAGE" or class == "WARLOCK" or class == "HUNTER" or (class == "DRUID" and tree == 1) or
				(class == "PRIEST" and tree == 3) or (class == "SHAMAN" and tree == 1)
			then
				myDamagerRole = "RANGED"
			elseif
				class == "ROGUE" or class == "WARRIOR" or (class == "DEATHKNIGHT" and tree ~= 1) or
				(class == "PALADIN" and tree == 3) or (class == "DRUID" and tree == 2) or (class == "SHAMAN" and tree == 2) or
				(class == "MONK" and tree == 3)
			then
				myDamagerRole = "MELEE"
			end
		end
	end

	local _, _, diff = GetInstanceInfo()
	difficulty = diff

	solo = true
	local _, _, _, mapId = UnitPosition("player")
	for unit in module:IterateGroup() do
		local _, _, _, tarMapId = UnitPosition(unit)
		if tarMapId == mapId and myGUID ~= UnitGUID(unit) and UnitIsConnected(unit) then
			solo = false
			break
		end
	end

	UpdateDispelStatus()
	UpdateInterruptStatus()
end

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
		local value
		if type(key) == "number" then
			if key > 0 then
				value = GetSpellTexture(key)
				if not value then
					core:Print(format("An invalid spell id (%d) is being used in a bar/message.", key))
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
core:GetModule("Bosses"):SetDefaultModulePrototype(boss)
function boss:IsBossModule() return true end
function boss:Initialize() core:RegisterBossModule(self) end
function boss:OnEnable(isWipe)
	if debug then dbg(self, isWipe and "OnEnable() via Wipe()" or "OnEnable()") end

	updateData(self)

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

	if self.SetupOptions then self:SetupOptions() end
	if type(self.OnBossEnable) == "function" then self:OnBossEnable() end

	if IsEncounterInProgress() and not isWipe then -- Safety. ENCOUNTER_END might fire whilst IsEncounterInProgress is still true and engage a module.
		self:CheckForEncounterEngage("NoEngage") -- Prevent engaging if enabling during a boss fight (after a DC)
	end

	if not isWipe then
		self:SendMessage("BigWigs_OnBossEnable", self)
	end
end
function boss:OnDisable(isWipe)
	if debug then dbg(self, isWipe and "OnDisable() via Wipe()" or "OnDisable()") end
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

	self.scheduledMessages = nil
	self.scheduledScans = nil
	self.scheduledScansCounter = nil
	self.isWiping = nil
	self.isEngaged = nil

	if not isWipe then
		self:SendMessage("BigWigs_OnBossDisable", self)
	end
end
function boss:GetOption(key)
	return self.db.profile[key]
end
function boss:Reboot(isWipe)
	if debug then dbg(self, ":Reboot()") end
	-- Reboot covers everything including hard module reboots (clicking the minimap icon)
	self:SendMessage("BigWigs_OnBossReboot", self)
	if isWipe then
		-- Devs, in 99% of cases you'll want to use OnBossWipe
		self:SendMessage("BigWigs_OnBossWipe", self)
	end
	self:OnDisable(isWipe)
	self:CancelAllTimers()
	self:OnEnable(isWipe)
end

-------------------------------------------------------------------------------
-- Localization
--

function boss:GetLocale()
	if not self.localization then
		self.localization = {}
	end
	return self.localization
end
boss.NewLocale = boss.GetLocale

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
	local invalidId = "Module %q tried to register an invalid spell id (%s) to event %q."

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
	function boss:Yell(func, ...)
		if not func then core:Print(format(missingArgument, self.moduleName)) return end
		if not self[func] then core:Print(format(missingFunction, self.moduleName, func)) return end
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
		if not event or not func then core:Print(format(missingArgument, self.moduleName)) return end
		if type(func) ~= "function" and not self[func] then core:Print(format(missingFunction, self.moduleName, func)) return end
		if not eventMap[self][event] then eventMap[self][event] = {} end
		for i = 1, select("#", ...) do
			local id = select(i, ...)
			if (type(id) == "number" and GetSpellInfo(id)) or id == "*" then
				eventMap[self][event][id] = func
			else
				core:Print(format(invalidId, self.moduleName, tostring(id), event))
			end
		end
		allowedEvents[event] = true
		bossUtilityFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:SendMessage("BigWigs_OnBossLog", self, event, ...)
	end
	function boss:RemoveLog(event, ...)
		if not event then core:Print(format(missingArgument, self.moduleName)) return end
		for i = 1, select("#", ...) do
			local id = select(i, ...)
			eventMap[self][event][id] = nil
		end
	end
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
			if debug then dbg(self, "Adding: "..event..", "..unit) end
		end
	end
	function boss:UnregisterUnitEvent(event, ...)
		if type(event) ~= "string" then core:Print(format(noEvent, self.moduleName)) return end
		if not ... then core:Print(format(noUnit, self.moduleName)) return end
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
			if debug then dbg(module, "IsEncounterInProgress() is nil, wiped.") end
			module:Wipe()
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

	function boss:CheckForEncounterEngage(noEngage)
		local hasBoss = UnitHealth("boss1") > 0 or UnitHealth("boss2") > 0 or UnitHealth("boss3") > 0 or UnitHealth("boss4") > 0 or UnitHealth("boss5") > 0
		if not self.isEngaged and hasBoss then
			local guid = UnitGUID("boss1") or UnitGUID("boss2") or UnitGUID("boss3") or UnitGUID("boss4") or UnitGUID("boss5")
			local module = core:GetEnableMobs()[self:MobId(guid)]
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
	end

	function boss:CheckBossStatus()
		local hasBoss = UnitHealth("boss1") > 0 or UnitHealth("boss2") > 0 or UnitHealth("boss3") > 0 or UnitHealth("boss4") > 0 or UnitHealth("boss5") > 0
		if not hasBoss and self.isEngaged then
			if debug then dbg(self, ":CheckBossStatus wipeCheck scheduled.") end
			self:ScheduleTimer(wipeCheck, 6, self)
		elseif not self.isEngaged and hasBoss then
			if debug then dbg(self, ":CheckBossStatus Engage called.") end
			self:CheckForEncounterEngage()
		end
		if debug then dbg(self, ":CheckBossStatus called with no result. Engaged = "..tostring(self.isEngaged).." hasBoss = "..tostring(hasBoss)) end
	end
end

do
	local unitTable = {
		"boss1", "boss2", "boss3", "boss4", "boss5",
		"target", "targettarget",
		"mouseover", "mouseovertarget",
		"focus", "focustarget",
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
	local function findTargetByGUID(id)
		local isNumber = type(id) == "number"
		for i = 1, #unitTable do
			local unit = unitTable[i]
			local guid = UnitGUID(unit)
			if guid and not UnitIsPlayer(unit) then
				if isNumber then
					local _, _, _, _, _, id = strsplit("-", guid)
					guid = tonumber(id)
				end
				if guid == id then return unit end
			end
		end
	end
	function boss:GetUnitIdByGUID(id) return findTargetByGUID(id) end

	local function unitScanner(self, func, tankCheckExpiry, guid)
		local elapsed = self.scheduledScansCounter[guid] + 0.05

		local unit = findTargetByGUID(guid)
		if unit then
			local unitTarget = unit.."target"
			local playerGUID = UnitGUID(unitTarget)
			if playerGUID and ((not UnitDetailedThreatSituation(unitTarget, unit) and not self:Tank(unitTarget)) or elapsed > tankCheckExpiry) then
				local name = self:UnitName(unitTarget)
				self:CancelTimer(self.scheduledScans[guid])
				func(self, name, playerGUID, elapsed)
				self.scheduledScans[guid] = nil
			end
		end

		if elapsed > 0.8 then
			self:CancelTimer(self.scheduledScans[guid])
			self.scheduledScans[guid] = nil
		end

		self.scheduledScansCounter[guid] = elapsed
	end

	function boss:GetUnitTarget(func, tankCheckExpiry, guid)
		if not self.scheduledScans then
			self.scheduledScans, self.scheduledScansCounter = {}, {}
		end

		if self.scheduledScans[guid] then
			self:CancelTimer(self.scheduledScans[guid]) -- Should never be needed, safety
		end

		self.scheduledScansCounter[guid] = 0
		self.scheduledScans[guid] = self:ScheduleRepeatingTimer(unitScanner, 0.05, self, func, solo and 0.1 or tankCheckExpiry, guid) -- Tiny allowance when solo
	end

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
			self:Wipe()
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
			updateData(self)

			if self.OnEngage then
				self:OnEngage(difficulty)
			end

			self:SendMessage("BigWigs_OnBossEngage", self, difficulty)
		end
	end

	function boss:Win()
		if debug then dbg(self, ":Win") end
		self.lastKill = GetTime() -- Add the kill time for the enable check.
		if self.OnWin then self:OnWin() end
		self:SendMessage("BigWigs_OnBossWin", self)
		self:Disable()
		wipe(icons) -- Wipe icon cache
		wipe(spells)
	end

	function boss:Wipe()
		self:Reboot(true)
		if self.OnWipe then self:OnWipe() end
	end
end

do
	local bosses = {"boss1", "boss2", "boss3", "boss4", "boss5"}
	local bossTargets = {"boss1target", "boss2target", "boss3target", "boss4target", "boss5target"}
	local UnitDetailedThreatSituation = UnitDetailedThreatSituation
	local function bossScanner(self, func, tankCheckExpiry, guid)
		local elapsed = self.scheduledScansCounter[guid] + 0.05

		for i = 1, 5 do
			local boss = bosses[i]
			if UnitGUID(boss) == guid then
				local bossTarget = bossTargets[i]
				local playerGUID = UnitGUID(bossTarget)
				if playerGUID and ((not UnitDetailedThreatSituation(bossTarget, boss) and not self:Tank(bossTarget)) or elapsed > tankCheckExpiry) then
					local name = self:UnitName(bossTarget)
					self:CancelTimer(self.scheduledScans[guid])
					func(self, name, playerGUID, elapsed)
					self.scheduledScans[guid] = nil
				end
				break
			end
		end

		if elapsed > 0.8 then
			self:CancelTimer(self.scheduledScans[guid])
			self.scheduledScans[guid] = nil
		end

		self.scheduledScansCounter[guid] = elapsed
	end
	function boss:GetBossTarget(func, tankCheckExpiry, guid)
		if not self.scheduledScans then
			self.scheduledScans, self.scheduledScansCounter = {}, {}
		end

		if self.scheduledScans[guid] then
			self:CancelTimer(self.scheduledScans[guid]) -- Should never be needed, safety
		end

		self.scheduledScansCounter[guid] = 0
		self.scheduledScans[guid] = self:ScheduleRepeatingTimer(bossScanner, 0.05, self, func, solo and 0.1 or tankCheckExpiry, guid) -- Tiny allowance when solo
	end
end

function boss:EncounterEnd(event, id, name, diff, size, status)
	if self.engageId == id and self.enabledState then
		if status == 1 then
			if self.journalId then
				self:Win() -- Official boss module
			else
				self:Disable() -- Custom external boss module
			end
		elseif status == 0 then
			self:SendMessage("BigWigs_StopBars", self)
			self:ScheduleTimer("Wipe", 5) -- Delayed for now due to issues with certain encounters and using IEEU for engage.
		end
		self:SendMessage("BigWigs_EncounterEnd", self, id, name, diff, size, status) -- Do NOT use this for wipe detection, use BigWigs_OnBossWipe.
	end
end

-------------------------------------------------------------------------------
-- Misc utility functions
--

function boss:Difficulty()
	return difficulty
end

function boss:LFR()
	return difficulty == 7 or difficulty == 17
end

function boss:Normal()
	return difficulty == 1 or difficulty == 3 or difficulty == 4 or difficulty == 14
end

function boss:Easy()
	return difficulty == 14 or difficulty == 17 -- New normal mode or new LFR mode
end

function boss:Heroic()
	return difficulty == 2 or difficulty == 5 or difficulty == 6 or difficulty == 15
end

function boss:Mythic()
	return difficulty == 16
end

function boss:MobId(guid)
	if not guid then return 1 end
	local _, _, _, _, _, id = strsplit("-", guid)
	return tonumber(id) or 1
end

function boss:SpellName(spellId)
	return spells[spellId]
end

function boss:Me(guid)
	return myGUID == guid
end

do
	local UnitName = UnitName
	function boss:UnitName(unit)
		local name, server = UnitName(unit)
		if not name then
			return
		elseif server and server ~= "" then
			name = name .."-".. server
		end
		return name
	end
end

function boss:Range(player, otherPlayer)
	if not otherPlayer then
		local distanceSquared = UnitDistanceSquared(player)
		return distanceSquared == 0 and 200 or distanceSquared ^ 0.5
	else
		local ty, tx = UnitPosition(player)
		local py, px = UnitPosition(otherPlayer)
		local dx = tx - px
		local dy = ty - py
		local distance = (dx * dx + dy * dy) ^ 0.5
		return distance
	end
end

function boss:Solo()
	return solo
end

-------------------------------------------------------------------------------
-- Group checking
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
	function boss:IterateGroup()
		local num = GetNumGroupMembers() or 0
		local i = 0
		local size = num > 0 and num+1 or 2
		local function iter(t)
			i = i + 1
			if i < size then
				return t[i]
			end
		end
		return iter, IsInRaid() and raidList or partyList
	end
end

-------------------------------------------------------------------------------
-- Role checking
--

function boss:Melee()
	return myRole == "TANK" or myDamagerRole == "MELEE"
end

function boss:Ranged()
	return myRole == "HEALER" or myDamagerRole == "RANGED"
end

function boss:Tank(unit)
	if unit then
		return GetPartyAssignment("MAINTANK", unit) or UnitGroupRolesAssigned(unit) == "TANK"
	else
		return myRole == "TANK"
	end
end

function boss:Healer(unit)
	if unit then
		return UnitGroupRolesAssigned(unit) == "HEALER"
	else
		return myRole == "HEALER"
	end
end

function boss:Damager(unit)
	if unit then
		return UnitGroupRolesAssigned(unit) == "DAMAGER"
	else
		return myDamagerRole
	end
end

do
	local offDispel, defDispel = "", ""
	function UpdateDispelStatus()
		offDispel, defDispel = "", ""
		if IsSpellKnown(19801) or IsSpellKnown(2908) or IsSpellKnown(5938) then
			-- Tranq (Hunter), Soothe (Druid), Shiv (Rogue)
			offDispel = offDispel .. "enrage,"
		end
		if IsSpellKnown(19801) or IsSpellKnown(32375) or IsSpellKnown(528) or IsSpellKnown(370) or IsSpellKnown(30449) then
			-- Tranq (Hunter), Mass Dispel (Priest), Dispel Magic (Priest), Purge (Shaman), Spellsteal (Mage)
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
		for i = 2, 6, 2 do -- 2/4/6 = major glyphs, NUM_GLYPH_SLOTS = 6
			local _, _, _, spellId = GetGlyphSocketInfo(i)
			if spellId == 58375 or spellId == 58631 then
				-- Glyph of Shield Slam (Warrior), Glyph of Icy Touch (Death Knight)
				offDispel = offDispel .. "magic,"
			end
		end
	end
	function boss:Dispeller(dispelType, isOffensive, key)
		if key then
			local o = self.db.profile[key]
			if not o then core:Print(format("Module %s uses %q as a dispel lookup, but it doesn't exist in the module options.", self.name, key)) return end
			if band(o, C.DISPEL) ~= C.DISPEL then return true end
		end
		if isOffensive then
			if find(offDispel, dispelType, nil, true) then
				return true
			end
		else
			if find(defDispel, dispelType, nil, true) then
				return true
			end
		end
	end
end

do
	local canInterrupt = false
	local spellList = {
		106839, -- Skull Bash (Druid)
		116705, -- Spear Hand Strike (Monk)
		147362, -- Counter Shot (Hunter)
		78675, -- Solar Beam (Druid)
		57994, -- Wind Shear (Shaman)
		47528, -- Mind Freeze (Death Knight)
		96231, -- Rebuke (Paladin)
		15487, -- Silence (Priest)
		2139, -- Counterspell (Mage)
		1766, -- Kick (Rogue)
		6552, -- Pummel (Warrior)
	}
	function UpdateInterruptStatus()
		canInterrupt = false
		for i = 1, #spellList do
			local spell = spellList[i]
			if IsSpellKnown(spell) then
				canInterrupt = spell -- XXX check for cooldown also?
			end
		end
	end
	function boss:Interrupter(guid)
		-- We will probably need to make this smarter
		if canInterrupt and guid and (UnitGUID("target") == guid or UnitGUID("focus") == guid) then
			return true
		end
		return canInterrupt
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
		if key == false then return true end -- Allow optionless abilities
		if type(key) == "nil" then core:Print(format(nilKeyError, self.moduleName)) return end
		if type(flag) ~= "number" then core:Print(format(invalidFlagError, self.moduleName, type(flag), tostring(flag))) return end
		if silencedOptions[key] then return end
		if type(self.db) ~= "table" then local msg = format(noDBError, self.moduleName) core:Print(msg) error(msg) return end
		if type(self.db.profile[key]) ~= "number" then
			if not self.toggleDefaults[key] then
				core:Print(format(noDefaultError, self.moduleName, key))
				return
			end
			if debug then
				core:Print(format(notNumberError, self.moduleName, key, type(self.db.profile[key])))
				return
			end
			self.db.profile[key] = self.toggleDefaults[key]
		end

		local fullKey = self.db.profile[key]
		if band(fullKey, C.TANK) == C.TANK and not self:Tank() then return end
		if band(fullKey, C.HEALER) == C.HEALER and not self:Healer() then return end
		if band(fullKey, C.TANK_HEALER) == C.TANK_HEALER and not self:Tank() and not self:Healer() then return end
		return band(fullKey, flag) == flag
	end
	function boss:CheckOption(key, flag)
		return checkFlag(self, key, C[flag])
	end
end

-- ALT POWER
function boss:OpenAltPower(key, title, sorting, sync)
	if checkFlag(self, key, C.ALTPOWER) then
		self:SendMessage("BigWigs_ShowAltPower", self, type(title) == "number" and spells[title] or title, sorting == "ZA" and sorting or "AZ", sync)
	end
	if sync then
		self:SendMessage("BigWigs_StartSyncingPower", self)
	end
end

function boss:CloseAltPower(key)
	if checkFlag(self, key or "altpower", C.ALTPOWER) then
		self:SendMessage("BigWigs_HideAltPower", self)
	end
end

-- PROXIMITY
function boss:OpenProximity(key, range, player, isReverse)
	if not solo and checkFlag(self, key, C.PROXIMITY) then
		if type(key) == "number" then
			self:SendMessage("BigWigs_ShowProximity", self, range, key, player, isReverse, spells[key], icons[key])
		else
			self:SendMessage("BigWigs_ShowProximity", self, range, key, player, isReverse)
		end
	end
end

function boss:CloseProximity(key)
	if not solo and checkFlag(self, key or "proximity", C.PROXIMITY) then
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

		local temp = (icon == false and 0) or (icon ~= false and icon) or (textType == "number" and text) or key
		if temp == key and type(key) == "string" then
			BigWigs:Print(("Message '%s' doesn't have an icon set."):format(textType == "string" and text or spells[text or key])) -- XXX temp
		end

		self:SendMessage("BigWigs_Message", self, key, textType == "string" and text or spells[text or key], color, icon ~= false and icons[icon or textType == "number" and text or key])
		if sound then
			if hasVoice and checkFlag(self, key, C.VOICE) then
				self:SendMessage("BigWigs_Voice", self, key, sound)
			else
				self:SendMessage("BigWigs_Sound", self, key, sound)
			end
		end
	end
end

function boss:RangeMessage(key, color, sound, text, icon)
	if not checkFlag(self, key, C.MESSAGE) then return end
	local textType = type(text)
	self:SendMessage("BigWigs_Message", self, key, format(L.near, textType == "string" and text or spells[text or key]), color == nil and "Personal" or color, icon ~= false and icons[icon or textType == "number" and text or key])
	self:SendMessage("BigWigs_Sound", self, key, sound == nil and "Alarm" or sound)
end

do
	local hexColors = {}
	for k, v in next, (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS) do
		hexColors[k] = "|cff" .. format("%02x%02x%02x", v.r * 255, v.g * 255, v.b * 255)
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

	local mt = {
		__newindex = function(self, key, value)
			rawset(self, key, coloredNames[value])
		end
	}
	function boss:NewTargetList()
		return setmetatable({}, mt)
	end

	local tmp = {}
	function boss:ColorName(player)
		if type(player) == "table" then
			wipe(tmp)
			for i, v in ipairs(player) do
				tmp[i] = coloredNames[v]
			end
			return tmp
		else
			return coloredNames[player]
		end
	end

	function boss:StackMessage(key, player, stack, color, sound, text, icon)
		if checkFlag(self, key, C.MESSAGE) then
			local textType = type(text)
			if player == pName then
				self:SendMessage("BigWigs_Message", self, key, format(L.stackyou, stack or 1, textType == "string" and text or spells[text or key]), "Personal", icon ~= false and icons[icon or textType == "number" and text or key])
			else
				self:SendMessage("BigWigs_Message", self, key, format(L.stack, stack or 1, textType == "string" and text or spells[text or key], coloredNames[player]), color, icon ~= false and icons[icon or textType == "number" and text or key])
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

	function boss:TargetMessage(key, player, color, sound, text, icon, alwaysPlaySound)
		local textType = type(text)
		local msg = textType == "string" and text or spells[text or key]
		local texture = icon ~= false and icons[icon or textType == "number" and text or key]

		if type(player) == "table" then
			local list = table.concat(player, ", ")
			local meOnly = checkFlag(self, key, C.ME_ONLY)
			local onMe = find(list, pName, nil, true)
			if not onMe then
				if not checkFlag(self, key, C.MESSAGE) or meOnly then wipe(player) return end
				if not alwaysPlaySound then sound = nil end
			else
				if not checkFlag(self, key, C.MESSAGE) and not meOnly then wipe(player) return end
			end
			if meOnly or (onMe and #player == 1) then
				self:SendMessage("BigWigs_Message", self, key, format(L.you, msg), "Personal", texture)
			else
				self:SendMessage("BigWigs_Message", self, key, format(L.other, msg, list), color, texture)
			end
			if sound then
				if hasVoice and checkFlag(self, key, C.VOICE) then
					self:SendMessage("BigWigs_Voice", self, key, sound)
				else
					self:SendMessage("BigWigs_Sound", self, key, sound)
				end
			end
			wipe(player)
		else
			if not player then
				if checkFlag(self, key, C.MESSAGE) then
					self:SendMessage("BigWigs_Message", self, key, format(L.other, msg, "???"), color == "Personal" and "Important" or color, texture)
					if alwaysPlaySound then
						self:SendMessage("BigWigs_Sound", self, key, sound)
					end
				end
				return
			end
			if player == pName then
				if checkFlag(self, key, C.MESSAGE) or checkFlag(self, key, C.ME_ONLY) then
					self:SendMessage("BigWigs_Message", self, key, format(L.you, msg), "Personal", texture)
					if hasVoice and checkFlag(self, key, C.VOICE) then
						self:SendMessage("BigWigs_Voice", self, key, sound, true)
					else
						self:SendMessage("BigWigs_Sound", self, key, sound)
					end
				end
			else
				if checkFlag(self, key, C.MESSAGE) and not checkFlag(self, key, C.ME_ONLY) then
					-- Change color and remove sound (if not alwaysPlaySound) when warning about effects on other players
					self:SendMessage("BigWigs_Message", self, key, format(L.other, msg, coloredNames[player]), color == "Personal" and "Important" or color, texture)
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

-- BARS
function boss:Bar(key, length, text, icon)
	local textType = type(text)
	if checkFlag(self, key, C.BAR) then
		self:SendMessage("BigWigs_StartBar", self, key, textType == "string" and text or spells[text or key], length, icons[icon or textType == "number" and text or key])
	end
	if checkFlag(self, key, C.COUNTDOWN) then
		self:SendMessage("BigWigs_StartEmphasize", self, key, textType == "string" and text or spells[text or key], length)
	end
end

function boss:CDBar(key, length, text, icon)
	local textType = type(text)
	if checkFlag(self, key, C.BAR) then
		self:SendMessage("BigWigs_StartBar", self, key, textType == "string" and text or spells[text or key], length, icons[icon or textType == "number" and text or key], true)
	end
	if checkFlag(self, key, C.COUNTDOWN) then
		self:SendMessage("BigWigs_StartEmphasize", self, key, textType == "string" and text or spells[text or key], length)
	end
end

function boss:TargetBar(key, length, player, text, icon)
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
			self:SendMessage("BigWigs_StartEmphasize", self, key, msg, length)
		end
	elseif not checkFlag(self, key, C.ME_ONLY) and checkFlag(self, key, C.BAR) then
		self:SendMessage("BigWigs_StartBar", self, key, format(L.other, textType == "string" and text or spells[text or key], gsub(player, "%-.+", "*")), length, icons[icon or textType == "number" and text or key])
	end
end

function boss:StopBar(text, player)
	if player then
		if player == pName then
			local msg = format(L.you, type(text) == "number" and spells[text] or text)
			self:SendMessage("BigWigs_StopBar", self, msg)
			self:SendMessage("BigWigs_StopEmphasize", self, msg)
		else
			self:SendMessage("BigWigs_StopBar", self, format(L.other, type(text) == "number" and spells[text] or text, gsub(player, "%-.+", "*")))
		end
	else
		self:SendMessage("BigWigs_StopBar", self, type(text) == "number" and spells[text] or text)
		self:SendMessage("BigWigs_StopEmphasize", self, type(text) == "string" and text or spells[text])
	end
end

function boss:PauseBar(key, text)
	local msg = text or spells[key]
	self:SendMessage("BigWigs_PauseBar", self, msg)
	self:SendMessage("BigWigs_StopEmphasize", self, msg)
end

function boss:ResumeBar(key, text)
	local msg = text or spells[key]
	self:SendMessage("BigWigs_ResumeBar", self, msg)
	if checkFlag(self, key, C.COUNTDOWN) then
		local length = self:BarTimeLeft(msg)
		if length > 0 then
			self:SendMessage("BigWigs_StartEmphasize", self, key, msg, length)
		end
	end
end

function boss:BarTimeLeft(text)
	local bars = core:GetPlugin("Bars")
	if bars then
		return bars:GetBarTimeLeft(self, type(text) == "number" and spells[text] or text)
	end
	return 0
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
	if hasVoice and checkFlag(self, key, C.VOICE) then
		self:SendMessage("BigWigs_Voice", self, key, sound)
	else
		self:SendMessage("BigWigs_Sound", self, key, sound)
	end
end

-- Examples of API use in a module:
-- self:Sync("abilityPrefix", playerName)
-- self:Sync("ability")
function boss:Sync(...) core:Transmit(...) end

function boss:AddSyncListener(sync, throttle)
	core:AddSyncListener(self, sync, throttle)
end

function boss:Berserk(seconds, noEngageMessage, customBoss, customBerserk, customFinalMessage)
	local boss = customBoss or self.displayName
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

	self:Bar(key, seconds, berserk, icon)

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
end

