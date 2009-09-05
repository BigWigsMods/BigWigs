--------------------------------
--      Module Prototype      --
--------------------------------
local boss = {} -- our prototype
-- add this to BigWigs
BigWigs.bossCore:SetDefaultModulePrototype(boss)

local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Common")

local UnitExists = UnitExists
local UnitAffectingCombat = UnitAffectingCombat
local UnitName = UnitName
local count = 1
local GetSpellInfo = GetSpellInfo
local fmt = string.format
local pName = UnitName("player")

function boss:OnInitialize()
	-- Unconditionally register, this shouldn't happen from any other place
	-- anyway.
	BigWigs:RegisterBossModule(self)
end

function boss:OnEnable()
	if type(self.OnBossEnable) == "function" then
		self:OnBossEnable()
	end
	self:SendMessage("BigWigs_OnBossEnable", self)
end

function boss:OnDisable()
	if type(self.OnBossDisable) == "function" then
		self:OnBossDisable()
	end
	self:SendMessage("BigWigs_OnBossDisable", self)
end


function boss:GetOption(spellId)
	return self.db.profile[(GetSpellInfo(spellId))]
end

local function transmitSync(self, token, arguments, ...)
	if not arguments then
		self:Sync(token)
	else
		local argString = ""
		for i = 1, #arguments do
			argString = " " .. tostring((select(arguments[i], ...)))
		end
		self:Sync(token .. argString)
	end
end

local modMissingFunction = "BigWigs Module Error: Module %q got the event %q (%d), but it doesn't know how to handle it."
function boss:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, _, source, sFlags, dGUID, player, dFlags, spellId, spellName, _, secSpellId)
	local m = self.combatLogEventMap and self.combatLogEventMap[event]
	if m and (m[spellId] or m["*"]) then
		if event == "UNIT_DIED" then
			self[m["*"]](self, player, dGUID)
		else
			local f = self[m[spellId] or m["*"]]
			if f then
				if not self.db or type(self.db.profile[spellName]) == "nil" or self.db.profile[spellName] then
					f(self, player, spellId, source, secSpellId, spellName, event, sFlags, dFlags, dGUID)
				end
			else
				print(modMissingFunction:format(self:ToString(), event, spellId))
			end
		end
	end
	local s = self.syncEventMap and self.syncEventMap[event]
	if s then
		for token, data in pairs(s) do
			if data.spellIds[spellId] then
				transmitSync(self, token, data.argumentList, player, spellId, source, secSpellId, spellName, event, sFlags, dFlags, dGUID)
			end
		end
	end
end

-- XXX Proposed API, subject to change.
function boss:AddCombatListener(event, func, ...)
	if not event or not func then
		error(("Missing an argument to %q:AddCombatListener."):format(self:ToString()))
	end
	if not self[func] then
		error(("%s tried to register the combat event %q to the method %q, but it doesn't exist in the module."):format(self:ToString(), event, func))
	end
	if not self.combatLogEventMap then self.combatLogEventMap = {} end
	if not self.combatLogEventMap[event] then self.combatLogEventMap[event] = {} end
	local c = select("#", ...)
	if c > 0 then
		for i = 1, c do
			self.combatLogEventMap[event][(select(i, ...))] = func
		end
	else
		self.combatLogEventMap[event]["*"] = func
	end
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local spellIds = {}
-- XXX Proposed API, subject to change.
function boss:AddSyncListener(event, ...)
	if not self.syncEventMap then self.syncEventMap = {} end
	if not self.syncEventMap[event] then self.syncEventMap[event] = {} end
	local token = nil
	-- clean out old ids
	wipe(spellIds)
	local c = select("#", ...)
	for i = 1, c do
		local arg = select(i, ...)
		if type(arg) == "string" then
			token = arg
			if not self.syncEventMap[event][token] then self.syncEventMap[event][token] = {} end
			if self.syncEventMap[event][token].spellIds then
				wipe(self.syncEventMap[event][token].spellIds)
			else
				self.syncEventMap[event][token].spellIds = {}
			end
			for k, v in pairs(spellIds) do
				self.syncEventMap[event][token].spellIds[k] = spellIds[k]
			end
			if c > i then
				if self.syncEventMap[event][token].argumentList then
					wipe(self.syncEventMap[event][token].argumentList)
				else
					self.syncEventMap[event][token].argumentList = {}
				end
			end
		else
			if not token then
				spellIds[arg] = true
			else
				table.insert(self.syncEventMap[event][token].argumentList, arg)
			end
		end
	end
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function boss:BossDeath(_, guid, multi)
	local b = self:ToString()
	if type(guid) == "string" then
		guid = tonumber((guid):sub(-12,-7),16)
	end

	if guid == self.guid then
		if multi then
			self:Sync("MultiDeath " .. b)
		else
			self:Sync("Death " .. b)
		end
	end
end

local function populateScanTable(mod)
	if type(mod.scanTable) == "table" then return end
	mod.scanTable = {}

	local x = mod.enabletrigger
	if type(x) == "string" then
		mod.scanTable[x] = true
	elseif type(x) == "table" then
		for i, v in ipairs(x) do
			mod.scanTable[v] = true
		end
	end

	local a = mod.wipemobs
	if type(a) == "string" then
		mod.scanTable[a] = true
	elseif type(a) == "table" then
		for i, v in ipairs(a) do
			mod.scanTable[v] = true
		end
	end
end

function boss:Scan()
	if not self.scanTable then populateScanTable(self) end

	if UnitExists("target") and UnitAffectingCombat("target") and self.scanTable[UnitName("target")] then
		return "target"
	end

	if UnitExists("focus") and UnitAffectingCombat("focus") and self.scanTable[UnitName("focus")] then
		return "focus"
	end

	local num = GetNumRaidMembers()
	if num == 0 then
		num = GetNumPartyMembers()
		for i = 1, num do
			local partyUnit = fmt("%s%d%s", "party", i, "target")
			if UnitExists(partyUnit) and UnitAffectingCombat(partyUnit) and self.scanTable[UnitName(partyUnit)] then
				return partyUnit
			end
		end
	else
		for i = 1, num do
			local raidUnit = fmt("%s%d%s", "raid", i, "target")
			if UnitExists(raidUnit) and UnitAffectingCombat(raidUnit) and self.scanTable[UnitName(raidUnit)] then
				return raidUnit
			end
		end
	end
end

function boss:GetEngageSync()
	return "BossEngaged"
end

-- Really not much of a validation, but at least it validates that the sync is
-- remotely related to the module :P
function boss:ValidateEngageSync(sync, rest)
	if type(sync) ~= "string" or type(rest) ~= "string" then return false end
	if sync ~= self:GetEngageSync() then return false end
	if not self.scanTable then populateScanTable(self) end
	for mob in pairs(self.scanTable) do
		if mob == rest then return true end
	end
	return rest == self:ToString()
end

function boss:CheckForEngage()
	local go = self:Scan()
	if go then
		local moduleName = self:ToString()
		self:Sync(self:GetEngageSync().." "..moduleName)
	elseif UnitAffectingCombat("player") then
		self:ScheduleTimer(self.CheckForEngage, .5, self)
	end
end

function boss:CheckForWipe()
	if not UnitIsFeignDeath("player") then
		local go = self:Scan()
		if not go then
			self:SendMessage("BigWigs_RemoveRaidIcon")
			self:SendMessage("BigWigs_RebootModule", self)
			return
		end
	end

	if not UnitAffectingCombat("player") then
		self:ScheduleTimer(self.CheckForWipe, 2, self)
	end
end

do
	local keys = setmetatable({}, {__index =
		function(self, key)
			if not key then return end
			self[key] = key .. "_message"
			return self[key]
		end
	})
	-- XXX Proposed API, subject to change/remove.
	-- Outputs a normal message including a raid warning if possible.
	function boss:IfMessage(key, color, icon, sound, locale, ...)
		if locale and not self.db.profile[key] then return end
		local text = not locale and key or locale[keys[key]]:format(...)
		self:SendMessage("BigWigs_Message", text, color, nil, sound, nil, icon)
	end

	local hexColors = {}
	for k, v in pairs(RAID_CLASS_COLORS) do
		hexColors[k] = "|cff" .. string.format("%02x%02x%02x", v.r * 255, v.g * 255, v.b * 255)
	end
	local coloredNames = setmetatable({}, {__index =
		function(self, key)
			if type(key) == "nil" then return nil end
			local class = select(2, UnitClass(key))
			if class then
				self[key] = hexColors[class]  .. key .. "|r"
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

	function boss:TargetMessage(spellName, player, color, icon, sound, ...)
		local text = nil
		if type(player) == "table" then
			text = fmt(L["other"], spellName, table.concat(player, ", "))
			wipe(player)
		else
			if player == pName then
				if ... then
					text = fmt(spellName, coloredNames[player], ...)
				else
					text = fmt(L["you"], spellName)
				end
			else
				--change colors and remove sound when warning about effects on other players
				if color == "Personal" then color = "Important" end
				sound = nil
				if ... then
					text = fmt(spellName, coloredNames[player], ...)
				else
					text = fmt(L["other"], spellName, coloredNames[player])
				end
			end
		end
		self:SendMessage("BigWigs_Message", text, color, nil, sound, nil, icon)
	end

	-- XXX Proposed API, subject to change.
	-- Outputs a local message only, no raid warning.
	function boss:LocalMessage(key, color, icon, sound, locale, ...)
		if locale and not self.db.profile[key] then return end
		local text = not locale and key or locale[keys[key]]:format(...)
		self:SendMessage("BigWigs_Message", text, color, true, sound, nil, icon)
	end
end

function boss:Message(...)
	self:SendMessage("BigWigs_Message", ...)
end

local scheduledTimers = {}
local function clearTimer( self, id )
	-- FIXME: leaky?
	wipe( scheduledTimers[self][id].args )
	wipe( scheduledTimers[self][id] )
	scheduledTimers[self][id] = nil
end

function boss:ProcessScheduledTimer( id )
	if not scheduledTimers[self] or not scheduledTimers[self][id] then return end
	local t = scheduledTimers[self][id]
	if type(t.func) == "string" then
		self[t.func]( self, unpack(t.args) )
	elseif type(t.func) == "function" then
		t.func( unpack(t.args) )
	end
	clearTimer(self, id)
end

function boss:CancelScheduledEvent( id )
	if not scheduledTimers[self] or not scheduledTimers[self][id] then return end
	self:CancelTimer( scheduledTimers[self][id].atid )
	clearTimer(self, id)
end

function boss:ScheduleEvent( id, delay, func, ...)
	if not scheduledTimers[self] then
		scheduledTimers[self] = {}
	end
	if scheduledTimers[self][id] then
		-- cancel the old one
		self:CancelScheduledEvent( id )
	end
	scheduledTimers[self][id].func = func
	scheduledTimers[self][id].args = { ... }
	scheduledTimers[self][id].atid = self:ScheduleTimer( "ProcessScheduledTimer", delay, id )
end

function boss:DelayedMessage(delay, text, ...) 
	return self:ScheduleEvent(text, delay, "SendMessage", "BigWigs_Message", text, ...)
end

do
	local icons = setmetatable({}, {__index =
		function(self, key)
			if not key then return end
			local value = nil
			if type(key) == "number" then value = select(3, GetSpellInfo(key))
			else value = "Interface\\Icons\\" .. key end
			self[key] = value
			return value
		end
	})

	function boss:Bar(text, length, icon, ...)
		self:SendMessage("BigWigs_StartBar", self, text, length, icons[icon], ...)
	end

	-- XXX Proposed API, subject to change.
	function boss:IfBar(key, length, icon, color, locale, ...)
		if not self.db.profile[key] then return end
		local text = locale[key .. "_bar"]:format(...)
		self:SendMessage("BigWigs_StartBar", self, text, length, icons[icon], color)
	end
end

function boss:Sync(...)
	self:SendMessage("BigWigs_SendSync", strjoin(" ", ...))
end

-- XXX 3rd argument is a proposed API change, and is subject to change/removal.
function boss:Whisper(player, spellName, noName)
	if player == pName then return end
	self:SendMessage("BigWigs_SendTell", player, noName and spellName or fmt(L["you"], spellName))
end

-- XXX 2nd argument is a proposed API change, and is subject to change/removal.
function boss:PrimaryIcon(player, key)
	if key and not self.db.profile[key] then return end
	if not player then
		self:SendMessage("BigWigs_RemoveRaidIcon", 1)
	else
		self:SendMessage("BigWigs_SetRaidIcon", player, 1)
	end
end

-- XXX 2nd argument is a proposed API change, and is subject to change/removal.
function boss:SecondaryIcon(player, key)
	if key and not self.db.profile[key] then return end
	if not player then
		self:SendMessage("BigWigs_RemoveRaidIcon", 2)
	else
		self:SendMessage("BigWigs_SetRaidIcon", player, 2)
	end
end

-- XXX 2nd argument is a proposed API change, and is subject to change/removal.
function boss:Icon(player, key)
	if key and not self.db.profile[key] then return end
	self:SendMessage("BigWigs_SetRaidIcon", player)
end

function boss:Throttle(seconds, ...)
	self:SendMessage("BigWigs_ThrottleSync", seconds, ...)
end

do
	local berserk = {
		start = L["berserk_start"],
		min = L["berserk_min"],
		sec = L["berserk_sec"],
		stop = L["berserk_end"],
		bar = GetSpellInfo(43),
		icon = 20484,
	}
	local enrage = {
		start = L["enrage_start"],
		min = L["enrage_min"],
		sec = L["enrage_sec"],
		stop = L["enrage_end"],
		bar = GetSpellInfo(12880),
		icon = 12880,
	}
	function boss:Enrage(seconds, isBerserk, noEngageMessage)
		local w = isBerserk and berserk or enrage
		local boss = self:ToString()

		if not noEngageMessage then
			-- Engage warning with minutes to enrage
			self:Message(fmt(w.start, boss, seconds / 60), "Attention")
		end

		-- Half-way to enrage warning.
		local half = seconds / 2
		local m = half % 60
		local halfMin = (half - m) / 60
		self:DelayedMessage(half + m, fmt(w.min, halfMin), "Positive")

		self:DelayedMessage(seconds - 60, fmt(w.min, 1), "Positive")
		self:DelayedMessage(seconds - 30, fmt(w.sec, 30), "Positive")
		self:DelayedMessage(seconds - 10, fmt(w.sec, 10), "Urgent")
		self:DelayedMessage(seconds - 5, fmt(w.sec, 5), "Urgent")
		self:DelayedMessage(seconds, fmt(w.stop, boss), "Attention", nil, "Alarm")
		self:Bar(w.bar, seconds, w.icon)
	end
end

