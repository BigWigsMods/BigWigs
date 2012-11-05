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
local core = BigWigs
local C = core.C
local difficulty = 3

-------------------------------------------------------------------------------
-- Debug
--

local debug = false -- Set to true to get (very spammy) debug messages.
local dbg = function(self, msg) print(format("[DBG:%s] %s", self.displayName, msg)) end

-------------------------------------------------------------------------------
-- Metatables
--

local metaMap = {__index = function(t, k) t[k] = {} return t[k] end}
local combatLogMap = setmetatable({}, metaMap)
local yellMap = setmetatable({}, metaMap)
local emoteMap = setmetatable({}, metaMap)
local deathMap = setmetatable({}, metaMap)
local icons = setmetatable({}, {__index =
	function(self, key)
		local _, value
		if type(key) == "number" then
			_, _, value = GetSpellInfo(key)
			if not value then
				print(format("Big Wigs: An invalid spell id (%d) is being used in a bar/message.", key))
			end
		else
			value = "Interface\\Icons\\" .. key
		end
		self[key] = value
		return self[key]
	end
})
local spells = setmetatable({}, {__index =
	function(self, key)
		local value = GetSpellInfo(key)
		self[key] = value
		return self[key]
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
	if self.SetupOptions then self:SetupOptions() end
	if type(self.OnBossEnable) == "function" then self:OnBossEnable() end
	self:SendMessage("BigWigs_OnBossEnable", self)
	local _, _, diff = GetInstanceInfo()
	difficulty = diff
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
	return self.db.profile[spells[spellId]]
end
function boss:Reboot()
	if debug then dbg(self, ":Reboot()") end
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
	function boss:RAID_BOSS_EMOTE(_, msg, ...)
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

	function boss:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, _, sGUID, source, sFlags, _, dGUID, player, dFlags, _, spellId, spellName, _, secSpellId, buffStack, ...)
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

	function boss:Emote(func, ...)
		if not func then error(format(missingArgument, self.moduleName)) end
		if not self[func] then error(format(missingFunction, self.moduleName, func)) end
		for i = 1, select("#", ...) do
			emoteMap[self][(select(i, ...))] = func
		end
		self:RegisterEvent("RAID_BOSS_EMOTE")
	end
	function boss:Yell(func, ...)
		if not func then error(format(missingArgument, self.moduleName)) end
		if not self[func] then error(format(missingFunction, self.moduleName, func)) end
		for i = 1, select("#", ...) do
			yellMap[self][(select(i, ...))] = func
		end
		self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	end
	function boss:Log(event, func, ...)
		if not event or not func then error(format(missingArgument, self.moduleName)) end
		if type(func) ~= "function" and not self[func] then error(format(missingFunction, self.moduleName, func)) end
		if not combatLogMap[self][event] then combatLogMap[self][event] = {} end
		for i = 1, select("#", ...) do
			local id = (select(i, ...))
			combatLogMap[self][event][id] = func
			if type(id) == "number" and not GetSpellInfo(id) then
				print(format(invalidId, self.moduleName, id, event))
			end
		end
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
	function boss:Death(func, ...)
		if not func then error(format(missingArgument, self.moduleName)) end
		if type(func) ~= "function" and not self[func] then error(format(missingFunction, self.moduleName, func)) end
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
	local function wipeCheck(module)
		if not IsEncounterInProgress() then
			if debug then dbg(module, "Wipe!") end
			module:Reboot()
		end
	end
	function boss:CheckBossStatus()
		local hasBoss = UnitHealth("boss1") > 100 or UnitHealth("boss2") > 100 or UnitHealth("boss3") > 100 or UnitHealth("boss4") > 100 or UnitHealth("boss5") > 100
		if not hasBoss and self.isEngaged then
			if debug then dbg(self, ":CheckBossStatus wipeCheck scheduled.") end
			self:ScheduleTimer(wipeCheck, 2, self)
		elseif not self.isEngaged and hasBoss then
			if debug then dbg(self, ":CheckBossStatus Engage called.") end
			local guid = UnitGUID("boss1") or UnitGUID("boss2") or UnitGUID("boss3") or UnitGUID("boss4") or UnitGUID("boss5")
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
	end
	local function findTargetByGUID(id)
		if not t then buildTable() end
		for i, unit in next, t do
			local guid = UnitGUID(unit)
			if guid and not UnitIsPlayer(unit) then
				if type(id) == "number" then guid = tonumber(guid:sub(7, 10), 16) end
				if guid == id then return unit end
			end
		end
	end
	function boss:GetUnitIdByGUID(id) return findTargetByGUID(id) end

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
			self:Reboot()
			if self.OnWipe then self:OnWipe() end
		else
			if debug then dbg(self, "Wipe scan found active boss entities (" .. tostring(go) .. "). Re-scheduling another wipe check in 2 seconds.") end
			self:ScheduleTimer("CheckForWipe", 2)
		end
	end

	function boss:Engage()
		if debug then dbg(self, ":Engage") end
		local _, _, diff = GetInstanceInfo()
		difficulty = diff
		CombatLogClearEntries()
		self.isEngaged = true
		if self.OnEngage then
			self:OnEngage(diff)
		end
	end

	function boss:Win()
		if debug then dbg(self, ":Win") end
		self:Sync("Death", self.moduleName)
		wipe(icons) -- Wipe icon cache
		wipe(spells)
	end
end

-------------------------------------------------------------------------------
-- Misc utility functions
--

function boss:Difficulty()
	return difficulty
end
boss.GetInstanceDifficulty = boss.Difficulty

function boss:LFR()
	return difficulty == 7
end

function boss:Heroic()
	return difficulty == 5 or difficulty == 6
end

function boss:GetCID(guid)
	local creatureId = tonumber(guid:sub(7, 10), 16)
	return creatureId
end

function boss:SpellName(spellId)
	return spells[spellId]
end

-------------------------------------------------------------------------------
-- Role checking
--

function boss:Tank()
	if core.db.profile.ignorerole then return true end
	local tree = GetSpecialization()
	local role = GetSpecializationRole(tree)
	if role == "TANK" then return true end
end

function boss:Healer()
	if core.db.profile.ignorerole then return true end
	local tree = GetSpecialization()
	local role = GetSpecializationRole(tree)
	if role == "HEALER" then return true end
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

-------------------------------------------------------------------------------
-- Delayed message handling
--

do
	local scheduledMessages = {}
	local function wrapper(module, _, ...) module:Message(...) end -- Use a wrapper or select(), same thing but faster.
	-- This should've been a local function, but if we do it this way then AceTimer passes in the correct module for us.
	function boss:ProcessDelayedMessage(text)
		wrapper(self, unpack(scheduledMessages[text]))
		wipe(scheduledMessages[text])
		scheduledMessages[text] = nil
	end

	function boss:CancelDelayedMessage(text)
		if scheduledMessages[text] then
			self:CancelTimer(scheduledMessages[text][1], true)
			wipe(scheduledMessages[text])
			scheduledMessages[text] = nil
			return true
		end
	end

	-- ... = color, icon, sound, noraidsay, broadcastonly
	function boss:DelayedMessage(key, delay, text, ...)
		if type(delay) ~= "number" then error(format("Module '%s' tried to schedule a delayed message with delay as type %q, but it must be a number.", self.moduleName, type(delay))) end
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
	local noDBError        = "Module %s does not have a .db property, which is weird."
	checkFlag = function(self, key, flag)
		if type(key) == "nil" then error(format(nilKeyError, self.name)) end
		if type(flag) ~= "number" then error(format(invalidFlagError, self.name, type(flag), tostring(flag))) end
		if silencedOptions[key] then return end
		if type(key) == "number" then key = spells[key] end
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
	self:SendMessage("BigWigs_Message", self, key, type(text) == "number" and spells[text] or text, color, noraidsay, sound, broadcastonly, icon and icons[icon])
end

do
	local hexColors = {}
	for k, v in pairs(CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS) do
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

	-- Outputs a local message only, no raid warning.
	function boss:LocalMessage(key, text, color, icon, sound, player, stack)
		if not checkFlag(self, key, C.MESSAGE) then return end
		if player then
			if stack then
				text = format(text, coloredNames[player], stack)
			else
				text = format(L["other"], text, coloredNames[player])
			end
		end
		self:SendMessage("BigWigs_Message", self, key, text, color, true, sound, nil, icon and icons[icon])
	end

	function boss:TargetMessage(key, spellName, player, color, icon, sound, ...)
		if not checkFlag(self, key, C.MESSAGE) then return end
		if type(player) == "table" then
			local list = table.concat(player, ", ")
			wipe(player)
			if not (list):find(UnitName("player")) then sound = nil end
			local text = format(L["other"], spellName, list)
			self:SendMessage("BigWigs_Message", self, key, text, color, nil, sound, nil, icon and icons[icon])
		else
			if UnitIsUnit(player, "player") then
				if ... then
					local text = format(spellName, coloredNames[player], ...)
					self:SendMessage("BigWigs_Message", self, key, text, color, true, sound, nil, icon and icons[icon])
					self:SendMessage("BigWigs_Message", self, key, text, nil, nil, nil, true)
				else
					self:SendMessage("BigWigs_Message", self, key, format(L["you"], spellName), "Personal", true, sound, nil, icon and icons[icon])
					self:SendMessage("BigWigs_Message", self, key, format(L["other"], spellName, player), nil, nil, nil, true)
				end
			else
				-- Change color and remove sound when warning about effects on other players
				if color == "Personal" then color = "Important" end
				local text = nil
				if ... then
					text = format(spellName, coloredNames[player], ...)
				else
					text = format(L["other"], spellName, coloredNames[player])
				end
				self:SendMessage("BigWigs_Message", self, key, text, color, nil, nil, nil, icon and icons[icon])
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


function boss:Bar(key, text, length, icon)
	if checkFlag(self, key, C.BAR) then
		self:SendMessage("BigWigs_StartBar", self, key, type(text) == "number" and spells[text] or text, length, icon and icons[icon])
	end
end

function boss:TargetBar(key, text, player, length, icon)
	if checkFlag(self, key, C.BAR) then
		if UnitIsUnit(player, "player") then
			self:SendMessage("BigWigs_StartBar", self, key, format(L["you"], type(text) == "number" and spells[text] or text), length, icon and icons[icon])
		else
			self:SendMessage("BigWigs_StartBar", self, key, format(L["other"], type(text) == "number" and spells[text] or text, player:gsub("%-.+", "*")), length, icon and icons[icon])
		end
	end
end

function boss:StopBar(text, player)
	if player then
		if UnitIsUnit(player, "player") then
			self:SendMessage("BigWigs_StopBar", self, format(L["you"], type(text) == "number" and spells[text] or text))
		else
			self:SendMessage("BigWigs_StopBar", self, format(L["other"], type(text) == "number" and spells[text] or text, player:gsub("%-.+", "*")))
		end
	else
		self:SendMessage("BigWigs_StopBar", self, type(text) == "number" and spells[text] or text)
	end
end

-- Examples of API use in a module:
-- self:Sync("abilityPrefix", playerName)
-- self:Sync("ability")
function boss:Sync(...) core:Transmit(...) end

do
	local sentWhispers = {}
	local function filter(self, event, msg) if sentWhispers[msg] or msg:find("^<BW>") or msg:find("^<DBM>") then return true end end
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filter)

	function boss:Whisper(key, player, spellName, noName)
		self:SendMessage("BigWigs_Whisper", self, key, player, spellName, noName)
		if not checkFlag(self, key, C.WHISPER) then return end
		local msg = noName and spellName or format(L["you"], spellName)
		sentWhispers[msg] = true
		if UnitIsUnit(player, "player") or not UnitIsPlayer(player) or not core.db.profile.whisper then return end
		if UnitInRaid("player") and not UnitIsGroupLeader("player") and not UnitIsGroupAssistant("player") then return end
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

function boss:Berserk(seconds, noEngageMessage, customBoss, customBerserk)
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
		self:Message(key, format(L["custom_start"], boss, berserk, seconds / 60), "Attention")
	end

	-- Half-way to enrage warning.
	local half = seconds / 2
	local m = half % 60
	local halfMin = (half - m) / 60
	self:DelayedMessage(key, half + m, format(L["custom_min"], berserk, halfMin), "Positive")

	self:DelayedMessage(key, seconds - 60, format(L["custom_min"], berserk, 1), "Positive")
	self:DelayedMessage(key, seconds - 30, format(L["custom_sec"], berserk, 30), "Urgent")
	self:DelayedMessage(key, seconds - 10, format(L["custom_sec"], berserk, 10), "Urgent")
	self:DelayedMessage(key, seconds - 5, format(L["custom_sec"], berserk, 5), "Important")
	self:DelayedMessage(key, seconds, format(L["custom_end"], boss, berserk), "Important", icon, "Alarm")

	self:Bar(key, berserk, seconds, icon)
end

