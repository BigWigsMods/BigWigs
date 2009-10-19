------------------------------------------------------------------------------
-- Prototype
--

local core = BigWigs
local C = core.C
local metaMap = {__index = function(t, k) t[k] = {} return t[k] end}
local combatLogMap = setmetatable({}, metaMap)
local yellMap = setmetatable({}, metaMap)
local deathMap = setmetatable({}, metaMap)

local boss = {}
core.bossCore:SetDefaultModulePrototype(boss)
function boss:OnInitialize() core:RegisterBossModule(self) end
function boss:OnEnable()
	if type(self.OnBossEnable) == "function" then self:OnBossEnable() end
	self:SendMessage("BigWigs_OnBossEnable", self)
end
function boss:OnDisable()
	if type(self.OnBossDisable) == "function" then self:OnBossDisable() end

	wipe(combatLogMap[self])
	wipe(yellMap[self])
	wipe(deathMap[self])

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
-- Enable triggers
--

function boss:RegisterEnableMob(...) core:RegisterEnableMob(self, ...) end
function boss:RegisterEnableYell(...) core:RegisterEnableYell(self, ...) end

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

	function boss:CHAT_MSG_MONSTER_YELL(_, msg, ...)
		if yellMap[self][msg] then
			self[yellMap[self][msg]](self, msg, ...)
		else
			for yell, func in pairs(yellMap[self]) do
				if msg:find(yell) then
					self[func](self, msg, ...)
				end
			end
		end
	end

	function boss:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, sGUID, source, sFlags, dGUID, player, dFlags, spellId, spellName, _, secSpellId)
		if event == "UNIT_DIED" then
			--XXX 3.3 COMPAT REMOVE ME
			local numericId = QueryQuestsCompleted and tonumber(dGUID:sub(-12, -9), 16) or tonumber(dGUID:sub(-12, -7), 16)
			local d = deathMap[self][numericId]
			if not d then return end
			if type(d) == "function" then d(numericId, dGUID, player, dFlags)
			else self[d](self, numericId, dGUID, player, dFlags) end
		else
			local m = combatLogMap[self][event]
			if m and m[spellId] then
				local func = m[spellId]
				if type(func) == "function" then
					func(player, spellId, source, secSpellId, spellName, event, sFlags, dFlags, dGUID)
				else
					self[func](self, player, spellId, source, secSpellId, spellName, event, sFlags, dFlags, dGUID)
				end
			end
		end
	end

	function boss:Yell(func, ...)
		if not func then error(missingArgument:format(self.moduleName)) end
		if not self[func] then error(missingFunction:format(self.moduleName, func)) end
		for i = 1, select("#", ...) do
			yellMap[self][(select(i, ...))] = func
		end
		self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	end
	function boss:Log(event, func, ...)
		if not event or not func then error(missingArgument:format(self.moduleName)) end
		if type(func) ~= "function" and not self[func] then error(missingFunction:format(self.moduleName, func)) end
		if not combatLogMap[self][event] then combatLogMap[self][event] = {} end
		for i = 1, select("#", ...) do
			combatLogMap[self][event][(select(i, ...))] = func
		end
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
	function boss:Death(func, ...)
		if not func then error(missingArgument:format(self.moduleName)) end
		if type(func) ~= "function" and not self[func] then error(missingFunction:format(self.moduleName, func)) end
		for i = 1, select("#", ...) do
			deathMap[self][(select(i, ...))] = func
		end
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
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
				--XXX 3.3 COMPAT REMOVE ME
				if idType == "number" then unitId = QueryQuestsCompleted and tonumber(unitId:sub(-12, -9), 16) or tonumber(unitId:sub(-12, -7), 16) end
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
-- Delayed message handling
--

do
	local scheduledMessages = {}
	local function wrapper(module, _, ...) module:Message(...) end
	-- This should've been a local function, but if we do it this way then AceTimer passes in the correct module for us.
	function boss:ProcessDelayedMessage(text)
		wrapper(self, unpack(scheduledMessages[text]))
		scheduledMessages[text] = nil
	end

	function boss:CancelDelayedMessage(text)
		if scheduledMessages[text] then
			self:CancelTimer(scheduledMessages[text][1], true)
			scheduledMessages[text] = nil
		end
	end

	-- ... = color, icon, sound, noraidsay, broadcastonly
	function boss:DelayedMessage(key, delay, text, ...)
		self:CancelDelayedMessage(text)
		scheduledMessages[text] = {}

		local id = self:ScheduleTimer("ProcessDelayedMessage", delay, text)
		tinsert(scheduledMessages[text], id)
		tinsert(scheduledMessages[text], key)
		tinsert(scheduledMessages[text], text)
		for i = 1, select("#", ...) do
			tinsert(scheduledMessages[text], (select(i, ...)))
		end
		return id
	end
end

-------------------------------------------------------------------------------
-- Boss module APIs for messages, bars, icons, etc.
--
local function checkFlag(self, key, flag)
	if type(key) == "number" then key = GetSpellInfo(key) end
	-- XXX 
	if type(self.db.profile[key]) ~= "number" then
		print(("The boss encounter script for %q tried to access the option %q as a bit flag setting, but in the database it's represented as something else (%s). Please report this in #bigwigs."):format(self.displayName, key, type(self.db.profile[key])))
		return self.db.profile[key]
	end
	return bit.band(self.db.profile[key], flag) == flag
end

function boss:OpenProximity(range)
	if not checkFlag(self, "proximity", C.PROXIMITY) then return end
	self:SendMessage("BigWigs_ShowProximity", self, range)
end
function boss:CloseProximity()
	if not checkFlag(self, "proximity", C.PROXIMITY) then return end
	self:SendMessage("BigWigs_HideProximity")
end

do
	local keys = setmetatable({}, {__index =
		function(self, key)
			if not key then return end
			self[key] = key .. "_message"
			return self[key]
		end
	})

	function boss:Message(dbkey, text, color, icon, sound, noraidsay, broadcastonly)
		if not checkFlag(self, dbkey, C.MESSAGE) then return end
		self:SendMessage("BigWigs_Message", text, color, noraidsay, sound, broadcastonly, icon)
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

	function boss:TargetMessage(key, spellName, player, color, icon, sound, ...)
		if not checkFlag(self, key, C.MESSAGE) then return end
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

	-- Outputs a local message only, no raid warning.
	function boss:LocalMessage(dbkey, text, color, icon, sound)
		if not checkFlag(self, dbkey, C.MESSAGE) then return end
		self:SendMessage("BigWigs_Message", text, color, true, sound, nil, icon)
	end
end

function boss:FlashShake(key, r, g, b)
	if checkFlag(self, key, C.FLASHSHAKE) then
		self:SendMessage("BigWigs_FlashShake", r, g, b)
	end
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

	function boss:Bar(key, text, length, icon, ...)
		if checkFlag(self, key, C.BAR) then
			self:SendMessage("BigWigs_StartBar", self, text, length, icons[icon], ...)
		end
	end
end

function boss:Sync(...) core:Transmit(...) end

do
	local sentWhispers = {}
	local function filter(self, event, msg) if sentWhispers[msg] or msg:find("^<DBM>") then return true end end
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filter)

	function boss:Whisper(key, player, spellName, noName)
		if not checkFlag(self, key, C.WHISPER) then return end
		local msg = noName and spellName or fmt(L["you"], spellName)
		sentWhispers[msg] = true
		if player == pName or not UnitIsPlayer(player) or not core.db.profile.whisper then return end
		if UnitInRaid("player") and not IsRaidLeader() and not IsRaidOfficer() then return end
		SendChatMessage(msg, "WHISPER", nil, player)
	end
end

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

function boss:AddSyncListener(sync)
	core:AddSyncListener(self, sync)
end

function boss:Berserk(seconds, noEngageMessage, customBoss)
	local boss = customBoss or self.displayName
	if not noEngageMessage then
		-- Engage warning with minutes to enrage
		self:Message("berserk", fmt(L["berserk_start"], boss, seconds / 60), "Attention")
	end

	-- Half-way to enrage warning.
	local half = seconds / 2
	local m = half % 60
	local halfMin = (half - m) / 60
	self:DelayedMessage("berserk", half + m, fmt(L["berserk_min"], halfMin), "Positive")

	self:DelayedMessage("berserk", seconds - 60, L["berserk_min"]:format(1), "Positive")
	self:DelayedMessage("berserk", seconds - 30, L["berserk_sec"]:format(30), "Urgent")
	self:DelayedMessage("berserk", seconds - 10, L["berserk_sec"]:format(10), "Urgent")
	self:DelayedMessage("berserk", seconds - 5, L["berserk_sec"]:format(5), "Important")
	self:DelayedMessage("berserk", seconds, L["berserk_end"]:format(boss), "Important", nil, "Alarm")

	-- There are many Berserks, but we use 26662 because Brutallus uses this one.
	-- Brutallus is da bomb.
	local berserk = GetSpellInfo(26662)
	self:Bar("berserk", berserk, seconds, 26662)
end

