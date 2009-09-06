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
	self:CancelAllScheduledEvents()
	self:SendMessage("BigWigs_OnBossDisable", self)
end


function boss:GetOption(spellId)
	return self.db.profile[(GetSpellInfo(spellId))]
end

local modMissingFunction = "Module %q got the event %q (%d), but it doesn't know how to handle it."
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
				error(modMissingFunction:format(self.displayName, event, spellId))
			end
		end
	end
end

-- XXX Proposed API, subject to change.
function boss:AddCombatListener(event, func, ...)
	if not event or not func then
		error(("Missing an argument to %q:AddCombatListener."):format(self.displayName))
	end
	if not self[func] then
		error(("%s tried to register the combat event %q to the method %q, but it doesn't exist in the module."):format(self.displayName, event, func))
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

function boss:BossDeath(_, guid, multi)
	if type(guid) == "string" then
		guid = tonumber((guid):sub(-12,-7),16)
	end

	if guid == self.guid then
		if multi then
			self:Sync("MultiDeath " .. self.moduleName)
		else
			self:Sync("Death " .. self.moduleName)
		end
	end
end

local function scan(self)
	if UnitExists("target") and UnitAffectingCombat("target") then return "target" end
	if UnitExists("focus") and UnitAffectingCombat("focus") then return "focus" end
	if UnitExists("mouseover") and UnitAffectingCombat("mouseover") then return "mouseover" end
	local num = GetNumRaidMembers()
	if num == 0 then
		num = GetNumPartyMembers()
		for i = 1, num do
			local partyUnit = fmt("%s%d", "party", i)
			if UnitExists(partyUnit) and UnitAffectingCombat(partyUnit) then
				return partyUnit
			end
		end
	else
		for i = 1, num do
			local raidUnit = fmt("%s%d", "raid", i)
			if UnitExists(raidUnit) and UnitAffectingCombat(raidUnit) then
				return raidUnit
			end
		end
	end
end

function boss:GetEngageSync() return "BossEngaged" end
function boss:ValidateEngageSync(sync, rest)
	if type(sync) ~= "string" or type(rest) ~= "string" then return end
	if sync ~= self:GetEngageSync() then return end
	return rest == self.moduleName
end

function boss:CheckForEngage()
	local go = scan(self)
	if go then
		self:Sync(self:GetEngageSync(), self.moduleName)
	elseif UnitAffectingCombat("player") then
		self:ScheduleTimer(self.CheckForEngage, .5, self)
	end
end

function boss:CheckForWipe()
	if not UnitIsFeignDeath("player") then
		local go = scan(self)
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
			self:SendMessage("BigWigs_Message", text, color, nil, sound, nil, icon)
		else
			if player == pName then
				if ... then
					text = fmt(spellName, coloredNames[player], ...)
				else
					text = fmt(L["you"], spellName)
				end
				self:SendMessage("BigWigs_Message", text, color, true, sound, nil, icon)
				self:SendMessage("BigWigs_Message", text, nil, nil, nil, true)
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

function boss:Berserk(seconds, noEngageMessage)
	local boss = self.displayName
	if not noEngageMessage then
		-- Engage warning with minutes to enrage
		self:Message(fmt(L["berserk_start"], boss, seconds / 60), "Attention")
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
	local berserk, _, icon = GetSpellInfo(26662)
	self:Bar(berserk, seconds, icon)
end

