-------------------------------------------------------------------------------
-- Prototype
--

local debug = false -- Set to true to get (very spammy) debug messages.
local dbgStr = "[DBG:%s] %s"
local function dbg(self, msg) print(dbgStr:format(self.displayName, msg)) end

local AL = LibStub("AceLocale-3.0")
local core = BigWigs
local C = core.C
local metaMap = {__index = function(t, k) t[k] = {} return t[k] end}
local combatLogMap = setmetatable({}, metaMap)
local yellMap = setmetatable({}, metaMap)
local emoteMap = setmetatable({}, metaMap)
local deathMap = setmetatable({}, metaMap)

local boss = {}
core.bossCore:SetDefaultModulePrototype(boss)
function boss:IsBossModule() return true end
function boss:OnInitialize() core:RegisterBossModule(self) end
function boss:OnEnable()
	if debug then dbg(self, "OnEnable()") end
	if self.SetupOptions then self:SetupOptions() end
	if type(self.OnBossEnable) == "function" then self:OnBossEnable() end
	self:SendMessage("BigWigs_OnBossEnable", self)
end
function boss:OnDisable()
	if debug then dbg(self, "OnDisable()") end
	if type(self.OnBossDisable) == "function" then self:OnBossDisable() end

	wipe(combatLogMap[self])
	wipe(yellMap[self])
	wipe(emoteMap[self])
	wipe(deathMap[self])
	self.isEngaged = nil

	self:SendMessage("BigWigs_OnBossDisable", self)
end
function boss:GetOption(spellId)
	return self.db.profile[(GetSpellInfo(spellId))]
end
function boss:Reboot()
	if debug then dbg(self, ":Reboot()") end
	self:Disable()
	self:Enable()
end

function boss:NewLocale(locale, default) return AL:NewLocale(self.name, locale, default) end
function boss:GetLocale() return AL:GetLocale(self.name) end

-------------------------------------------------------------------------------
-- Enable triggers
--

function boss:RegisterEnableMob(...) core:RegisterEnableMob(self, ...) end
function boss:RegisterEnableYell(...) core:RegisterEnableYell(self, ...) end

-------------------------------------------------------------------------------
-- Locals
--

local L = AL:GetLocale("Big Wigs: Common")
local UnitExists = UnitExists
local UnitAffectingCombat = UnitAffectingCombat
local GetSpellInfo = GetSpellInfo
local fmt = string.format

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
	function boss:CHAT_MSG_RAID_BOSS_EMOTE(_, msg, ...)
		if emoteMap[self][msg] then
			self[emoteMap[self][msg]](self, msg, ...)
		else
			for emote, func in pairs(emoteMap[self]) do
				if msg:find(emote) then
					self[func](self, msg, ...)
				end
			end
		end
	end

	local function cleuHandler(self, event, _, sGUID, source, sFlags, dGUID, player, dFlags, spellId, spellName, _, secSpellId, buffStack)
		if event == "UNIT_DIED" then
			local numericId = tonumber(dGUID:sub(7, 10), 16)
			local d = deathMap[self][numericId]
			if not d then return end
			if type(d) == "function" then d(numericId, dGUID, player, dFlags)
			else self[d](self, numericId, dGUID, player, dFlags) end
		else
			local m = combatLogMap[self][event]
			if m and (m[spellId] or m["*"]) then
				local func = m[spellId] or m["*"]
				if type(func) == "function" then
					func(player, spellId, source, secSpellId, spellName, buffStack, event, sFlags, dFlags, dGUID, sGUID)
				else
					self[func](self, player, spellId, source, secSpellId, spellName, buffStack, event, sFlags, dFlags, dGUID, sGUID)
				end
			end
		end
	end
	local is42 = tonumber((select(4, GetBuildInfo()))) > 40100
	if is42 then
		function boss:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, _, sGUID, source, sFlags, _, dGUID, player, dFlags, _, spellId, spellName, _, secSpellId, buffStack, ...)
			cleuHandler(self, event, nil, sGUID, source, sFlags, dGUID, player, dFlags, spellId, spellName, nil, secSpellId, buffStack)
		end
	else
		function boss:COMBAT_LOG_EVENT_UNFILTERED(_, _, ...)
			cleuHandler(self, ...)
		end
	end

	function boss:Emote(func, ...)
		if not func then error(missingArgument:format(self.moduleName)) end
		if not self[func] then error(missingFunction:format(self.moduleName, func)) end
		for i = 1, select("#", ...) do
			emoteMap[self][(select(i, ...))] = func
		end
		self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
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

function boss:CheckBossStatus()
	local hasBoss = UnitHealth("boss1") > 100 or UnitHealth("boss2") > 100 or UnitHealth("boss3") > 100 or UnitHealth("boss4") > 100
	if not hasBoss and self.isEngaged then
		if debug then dbg(self, ":CheckBossStatus Reboot called.") end
		self:Reboot()
	elseif not self.isEngaged and hasBoss then
		if debug then dbg(self, ":CheckBossStatus Engage called.") end
		local guid = UnitGUID("boss1") or UnitGUID("boss2") or UnitGUID("boss3") or UnitGUID("boss4")
		local module = core:GetEnableMobs()[tonumber(guid:sub(7, 10), 16)]
		local modType = type(module)
		if modType == "string" then
			if module == self.moduleName then
				self:Engage()
			else
				self:Disable()
			end
		elseif modType == "table" then
			for i = 1, #module do
				if module[i] == self.moduleName then
					self:Engage()
					break
				end
			end
			if not self.isEngaged then self:Disable() end
		end
	end
	if debug then dbg(self, ":CheckBossStatus called with no result. Engaged = "..tostring(self.isEngaged).." hasBoss = "..tostring(hasBoss)) end
end

do
	local t = nil
	local function buildTable()
		t = {
			"boss1", "boss2", "boss3", "boss4",
			"target", "targettarget",
			"focus", "focustarget",
			"mouseover", "mouseovertarget",
			"party1target", "party2target", "party3target", "party4target"
		}
		for i = 1, 25 do t[#t+1] = fmt("raid%dtarget", i) end
	end
	local function findTargetByGUID(id)
		local idType = type(id)
		if not t then buildTable() end
		for i, unit in next, t do
			if UnitExists(unit) and not UnitIsPlayer(unit) then
				local unitId = UnitGUID(unit)
				if idType == "number" then unitId = tonumber(unitId:sub(7, 10), 16) end
				if unitId == id then return unit end
			end
		end
	end
	function boss:GetUnitIdByGUID(mob) return findTargetByGUID(mob) end

	local function scan(self)
		for mobId, entry in pairs(core:GetEnableMobs()) do
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
			if self.OnWipe then self:OnWipe() end
			self:Reboot()
		else
			if debug then dbg(self, "Wipe scan found active boss entities (" .. tostring(go) .. "). Re-scheduling another wipe check in 2 seconds.") end
			self:ScheduleTimer("CheckForWipe", 2)
		end
	end

	function boss:GetInstanceDifficulty()
		local diff = select(3, GetInstanceInfo())
		return diff
	end

	function boss:Engage()
		if debug then dbg(self, ":Engage") end
		CombatLogClearEntries()
		self.isEngaged = true
		if self.OnEngage then
			self:OnEngage(self:GetInstanceDifficulty())
		end
	end

	function boss:Win()
		if debug then dbg(self, ":Win") end
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
			return true
		end
	end

	-- ... = color, icon, sound, noraidsay, broadcastonly
	function boss:DelayedMessage(key, delay, text, ...)
		if type(delay) ~= "number" then error(string.format("Module %s tried to schedule a delayed message with delay as type %q, but it must be a number.", self.name, type(delay))) end
		self:CancelDelayedMessage(text)

		local id = self:ScheduleTimer("ProcessDelayedMessage", delay, text)
		scheduledMessages[text] = {id, key, text, ...}
		return id
	end
end

-------------------------------------------------------------------------------
-- Boss module APIs for messages, bars, icons, etc.
--
local silencedOptions = {}
do
	local bwOptionSilencer = CreateFrame("Frame")
	bwOptionSilencer:Hide()
	LibStub("AceEvent-3.0"):Embed(bwOptionSilencer)
	bwOptionSilencer:RegisterMessage("BigWigs_SilenceOption", function(event, key, time)
		if key ~= nil then -- custom bars have a nil key
			silencedOptions[key] = time
			bwOptionSilencer:Show()
		end
	end)
	local total = 0
	bwOptionSilencer:SetScript("OnUpdate", function(self, elapsed)
		total = total + elapsed
		if total >= 0.5 then
			for k, t in pairs(silencedOptions) do
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

local checkFlag = nil
do
	local noDefaultError   = "Module %s uses %q as a toggle option, but it does not exist in the modules default values."
	local notNumberError   = "Module %s tried to access %q, but in the database it's a %s."
	local nilKeyError      = "Module %s tried to check the bitflags for a nil option key."
	local invalidFlagError = "Module %s tried to check for an invalid flag type %q (%q). Flags must be bits."
	checkFlag = function(self, key, flag)
		if type(key) == "nil" then error(nilKeyError:format(self.name)) end
		if type(flag) ~= "number" then error(invalidFlagError:format(self.name, type(flag), tostring(flag))) end
		if silencedOptions[key] then return end
		if type(key) == "number" then key = GetSpellInfo(key) end
		if type(self.db.profile[key]) ~= "number" then
			if not self.toggleDefaults[key] then
				error(noDefaultError:format(self.name, key))
			end
			if debug then
				error(notNumberError:format(self.name, key, type(self.db.profile[key])))
			end
			self.db.profile[key] = self.toggleDefaults[key]
		end
		return bit.band(self.db.profile[key], flag) == flag
	end
end

-- XXX the monitor should probably also get a button to turn off the proximity bitflag
-- XXX for the given key.
function boss:OpenProximity(range, key)
	if not checkFlag(self, key or "proximity", C.PROXIMITY) then return end
	self:SendMessage("BigWigs_ShowProximity", self, range, key or "proximity")
end
function boss:CloseProximity(key)
	if not checkFlag(self, key or "proximity", C.PROXIMITY) then return end
	self:SendMessage("BigWigs_HideProximity", self, key or "proximity")
end

function boss:Message(key, text, color, icon, sound, noraidsay, broadcastonly)
	if not checkFlag(self, key, C.MESSAGE) then return end
	self:SendMessage("BigWigs_Message", self, key, text, color, noraidsay, sound, broadcastonly, icon)
end

-- Outputs a local message only, no raid warning.
function boss:LocalMessage(key, text, color, icon, sound)
	if not checkFlag(self, key, C.MESSAGE) then return end
	self:SendMessage("BigWigs_Message", self, key, text, color, true, sound, nil, icon)
end

do
	local hexColors = {}
	for k, v in pairs(RAID_CLASS_COLORS) do
		hexColors[k] = "|cff" .. fmt("%02x%02x%02x", v.r * 255, v.g * 255, v.b * 255)
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
		if type(player) == "table" then
			local list = table.concat(player, ", ")
			if not (list):find(UnitName("player")) then sound = nil end
			local text = fmt(L["other"], spellName, list)
			self:SendMessage("BigWigs_Message", self, key, text, color, nil, sound, nil, icon)
			wipe(player)
		else
			if UnitIsUnit(player, "player") then
				if ... then
					local text = fmt(spellName, coloredNames[player], ...)
					self:SendMessage("BigWigs_Message", self, key, text, color, true, sound, nil, icon)
					self:SendMessage("BigWigs_Message", self, key, text, nil, nil, nil, true)
				else
					self:SendMessage("BigWigs_Message", self, key, fmt(L["you"], spellName), "Personal", true, sound, nil, icon)
					self:SendMessage("BigWigs_Message", self, key, fmt(L["other"], spellName, player), nil, nil, nil, true)
				end
			else
				-- Change color and remove sound when warning about effects on other players
				if color == "Personal" then color = "Important" end
				local text = nil
				if ... then
					text = fmt(spellName, coloredNames[player], ...)
				else
					text = fmt(L["other"], spellName, coloredNames[player])
				end
				self:SendMessage("BigWigs_Message", self, key, text, color, nil, nil, nil, icon)
			end
		end
	end
end

function boss:FlashShake(key, r, g, b)
	if not checkFlag(self, key, C.FLASHSHAKE) then return end
	self:SendMessage("BigWigs_FlashShake", self, key)
end

function boss:Say(key, msg)
	if not checkFlag(self, key, C.SAY) then return end
	SendChatMessage(msg, "SAY")
end

function boss:PlaySound(key, sound)
	if not checkFlag(self, key, C.MESSAGE) then return end
	self:SendMessage("BigWigs_Sound", sound)
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

	function boss:Bar(key, text, length, icon, barColor, barEmphasized, barText, barBackground, ...)
		if checkFlag(self, key, C.BAR) then
			self:SendMessage("BigWigs_StartBar", self, key, text, length, icons[icon], ...)
		end
	end
end

function boss:Sync(...) core:Transmit(...) end

do
	local sentWhispers = {}
	local function filter(self, event, msg) if sentWhispers[msg] or msg:find("^<BW>") or msg:find("^<DBM>") then return true end end
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filter)

	function boss:Whisper(key, player, spellName, noName)
		self:SendMessage("BigWigs_Whisper", self, key, player, spellName, noName)
		if not checkFlag(self, key, C.WHISPER) then return end
		local msg = noName and spellName or fmt(L["you"], spellName)
		sentWhispers[msg] = true
		if UnitIsUnit(player, "player") or not UnitIsPlayer(player) or not core.db.profile.whisper then return end
		if UnitInRaid("player") and not IsRaidLeader() and not IsRaidOfficer() then return end
		SendChatMessage("<BW> " .. msg, "WHISPER", nil, player)
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

	self:DelayedMessage("berserk", seconds - 60, fmt(L["berserk_min"], 1), "Positive")
	self:DelayedMessage("berserk", seconds - 30, fmt(L["berserk_sec"], 30), "Urgent")
	self:DelayedMessage("berserk", seconds - 10, fmt(L["berserk_sec"], 10), "Urgent")
	self:DelayedMessage("berserk", seconds - 5, fmt(L["berserk_sec"], 5), "Important")
	self:DelayedMessage("berserk", seconds, fmt(L["berserk_end"], boss), "Important", nil, "Alarm")

	-- There are many Berserks, but we use 26662 because Brutallus uses this one.
	-- Brutallus is da bomb.
	local berserk = GetSpellInfo(26662)
	self:Bar("berserk", berserk, seconds, 26662)
end

