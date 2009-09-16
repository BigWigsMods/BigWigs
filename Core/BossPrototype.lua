------------------------------------------------------------------------------
-- Prototype
--

local boss = {}
BigWigs.bossCore:SetDefaultModulePrototype(boss)
function boss:OnInitialize() BigWigs:RegisterBossModule(self) end
function boss:OnEnable()
	if type(self.OnBossEnable) == "function" then self:OnBossEnable() end
	self:SendMessage("BigWigs_OnBossEnable", self)
end
function boss:OnDisable()
	if type(self.OnBossDisable) == "function" then self:OnBossDisable() end
	self:CancelAllScheduledEvents()

	if self.combatLogEventMap then wipe(self.combatLogEventMap) end
	if self.exactYellMap then wipe(self.exactYellMap) end
	if self.yellMap then wipe(self.yellMap) end
	if self.deathMap then wipe(self.deathMap) end

	self:SendMessage("BigWigs_OnBossDisable", self)
end
function boss:GetOption(spellId)
	return self.db.profile[(GetSpellInfo(spellId))]
end
function boss:Reboot()
	self:Disable()
	self:Enable()
end

-------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")
local UnitExists = UnitExists
local UnitAffectingCombat = UnitAffectingCombat
local UnitName = UnitName
local GetSpellInfo = GetSpellInfo
local fmt = string.format
local pName = UnitName("player")

-------------------------------------------------------------------------------
-- Combat log related code
--

do
	local modMissingFunction = "Module %q got the event %q (%d), but it doesn't know how to handle it."
	local missingArgument = "Missing required argument when adding a listener to %q."
	local missingFunction = "%q tried to register a listener to method %q, but it doesn't exist in the module."

	local function yell(self, _, msg, ...)
		if self.exactYellMap and self.exactYellMap[msg] then
			self[self.exactYellMap[msg]](self, msg, ...)
		elseif self.yellMap then
			for yell, func in pairs(self.yellMap) do
				if msg:find(yell) then
					self[func](self, msg, ...)
				end
			end
		end
	end

	local function cleu(self, _, _, event, sGUID, source, sFlags, dGUID, player, dFlags, spellId, spellName, _, secSpellId)
		if event == "UNIT_DIED" then
			local numericId = tonumber(dGUID:sub(-12, -7), 16)
			local d = self.deathMap and self.deathMap[numericId]
			if not d then return end
			if type(d) == "function" then d(numericId, dGUID, player, dFlags)
			else self[d](self, numericId, dGUID, player, dFlags) end
		else
			local m = self.combatLogEventMap and self.combatLogEventMap[event]
			if m and (m[spellId] or m["*"]) then
				if not self.db or type(self.db.profile[spellName]) == "nil" or self.db.profile[spellName] then
					local func = m[spellId] or m["*"]
					if type(func) == "function" then
						func(player, spellId, source, secSpellId, spellName, event, sFlags, dFlags, dGUID)
					else
						self[func](self, player, spellId, source, secSpellId, spellName, event, sFlags, dFlags, dGUID)
					end
				end
			end
		end
	end

	function boss:Yell(func, exact, ...)
		if not func then error(missingArgument:format(self.moduleName)) end
		if type(func) ~= "function" and not self[func] then error(missingFunction:format(self.moduleName, func)) end
		if exact and not self.exactYellMap then self.exactYellMap = {} end
		if not exact and not self.yellMap then self.yellMap = {} end
		for i = 1, select("#", ...) do
			local y = (select(i, ...))
			if exact then
				self.exactYellMap[y] = func
			else
				self.yellMap[y] = func
			end
		end
		self:RegisterEvent("CHAT_MSG_MONSTER_YELL", yell, self)
	end
	function boss:Log(event, func, ...)
		if not event or not func then error(missingArgument:format(self.moduleName)) end
		if type(func) ~= "function" and not self[func] then error(missingFunction:format(self.moduleName, func)) end
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
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", cleu, self)
	end
	function boss:Death(func, ...)
		if not func then error(missingArgument:format(self.moduleName)) end
		if type(func) ~= "function" and not self[func] then error(missingFunction:format(self.moduleName, func)) end
		if not self.deathMap then self.deathMap = {} end
		for i = 1, select("#", ...) do
			self.deathMap[(select(i, ...))] = func
		end
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", cleu, self)
	end
end

-------------------------------------------------------------------------------
-- Engage / wipe checking + unit scanning
--

do
	local t = {"target", "focus", "mouseover"}
	for i = 1, 4 do t[#t+1] = fmt("party%dtarget", i) end
	for i = 1, 40 do t[#t+1] = fmt("raid%dtarget", i) end
	local function findTargetByGUID(id)
		local idType = type(id)
		for i, unit in next, t do
			if UnitExists(unit) and not UnitIsPlayer(unit) then
				local unitId = UnitGUID(unit)
				if idType == "number" then unitId = tonumber(unitId:sub(-12, -7), 16) end
				if unitId == id then return unit end
			end
		end
	end
	function boss:GetUnitIdByGUID(mob) return findTargetByGUID(mob) end

	local function scan(self)
		if type(self.enabletrigger) == "number" then
			local unit = findTargetByGUID(self.enabletrigger)
			if unit and UnitAffectingCombat(unit) then return unit end
		elseif type(self.enabletrigger) == "table" then
			for i, id in next, self.enabletrigger do
				local unit = findTargetByGUID(id)
				if unit and UnitAffectingCombat(unit) then return unit end
			end
		end
	end

	function boss:CheckForEngage()
		local go = scan(self)
		if go then
			self:Sync("BossEngaged", self.moduleName)
		else
			self:ScheduleTimer("CheckForEngage", .5)
		end
	end

	function boss:CheckForWipe()
		local go = scan(self)
		if not go then
			if self.OnWipe then self:OnWipe() end
			self:SendMessage("BigWigs_RemoveRaidIcon")
			self:Reboot()
		else
			self:ScheduleTimer("CheckForWipe", 2)
		end
	end

	function boss:Engage()
		if self.OnEngage then self:OnEngage() end
	end

	function boss:Win()
		if self.OnWin then self:OnWin() end
		self:Sync("Death", self.moduleName)
	end
end

-------------------------------------------------------------------------------
-- Ace2 ScheduleEvent Layer
--

local scheduledTimers = {}
local function clearTimer(id)
	if not id or not scheduledTimers[id] then return end
	if scheduledTimers[id].args then
		wipe(scheduledTimers[id].args)
	end
	wipe(scheduledTimers[id])
end

local args = {}
local function processScheduledTimer(id)
	local t = scheduledTimers[id]
	-- copy and clear incase we reschedule the same id from within the func
	local f = t.func
	local id = t.atid
	local m = t.module
	wipe(args)
	if t.args then
		for i, v in next, t.args do tinsert(args, v) end
	end
	if type(f) == "string" then
		if not m[f] then
			error(("Module %q tried to schedule an event for %s, but it doesn't exist."):format(m:GetName(), f))
		end
		m[f](m, unpack(args))
	else
		f(unpack(args))
	end
	clearTimer(id)
end

function boss:CancelScheduledEvent(id)
	if not scheduledTimers[id] then return end
	self:CancelTimer(scheduledTimers[id].atid, true)
	clearTimer(id)
end

function boss:CancelAllScheduledEvents()
	for id, args in pairs(scheduledTimers) do
		if args.module == self then
			self:CancelScheduledEvent(id)
		end
	end
end

function boss:ScheduleEvent(id, func, delay, ...)
	if scheduledTimers[id] then
		self:CancelScheduledEvent(id)
	else
		scheduledTimers[id] = {}
	end
	scheduledTimers[id].func = func
	scheduledTimers[id].module = self
	if scheduledTimers[id].args then
		for i = 1, select("#", ...) do
			tinsert(scheduledTimers[id].args, (select(i, ...)))
		end
	elseif select("#", ...) > 0 then
		scheduledTimers[id].args = { ... }
	end
	scheduledTimers[id].atid = self:ScheduleTimer(processScheduledTimer, delay, id)
	return id
end

-------------------------------------------------------------------------------
-- Boss module APIs for messages, bars, icons, etc.
--

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
			self:SendMessage("BigWigs_Message", text, color, nil, sound, nil, icon)
		else
			if player == pName then
				if ... then
					text = fmt(spellName, coloredNames[player], ...)
					self:SendMessage("BigWigs_Message", text, color, true, sound, nil, icon)
					self:SendMessage("BigWigs_Message", text, nil, nil, nil, true)
				else
					self:SendMessage("BigWigs_Message", fmt(L["you"], spellName), color, true, sound, nil, icon)
					self:SendMessage("BigWigs_Message", fmt(L["other"], spellName, player), nil, nil, nil, true)
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
				self:SendMessage("BigWigs_Message", text, color, nil, sound, nil, icon)
			end
		end
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

function boss:DelayedMessage(delay, text, ...) 
	return self:ScheduleEvent(text, "SendMessage", delay, "BigWigs_Message", text, ...)
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
end

function boss:Sync(...) BigWigs:Transmit(...) end

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

function boss:AddSyncListener(sync)
	BigWigs:AddSyncListener(self, sync)
end

function boss:Berserk(seconds, noEngageMessage, customBoss)
	local boss = customBoss or self.displayName
	if not noEngageMessage then
		-- Engage warning with minutes to enrage
		self:IfMessage(fmt(L["berserk_start"], boss, seconds / 60), "Attention")
	end

	-- Half-way to enrage warning.
	local half = seconds / 2
	local m = half % 60
	local halfMin = (half - m) / 60
	self:DelayedMessage(half + m, fmt(L["berserk_min"], halfMin), "Positive")

	self:DelayedMessage(seconds - 60, L["berserk_min"]:format(1), "Positive")
	self:DelayedMessage(seconds - 30, L["berserk_sec"]:format(30), "Urgent")
	self:DelayedMessage(seconds - 10, L["berserk_sec"]:format(10), "Urgent")
	self:DelayedMessage(seconds - 5, L["berserk_sec"]:format(5), "Important")
	self:DelayedMessage(seconds, L["berserk_end"]:format(boss), "Important", nil, "Alarm")

	-- There are many Berserks, but we use 26662 because Brutallus uses this one.
	-- Brutallus is da bomb.
	local berserk = GetSpellInfo(26662)
	self:Bar(berserk, seconds, 26662)
end

