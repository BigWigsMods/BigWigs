--------------------------------
--      Module Prototype      --
--------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs")
local BBR = LibStub("LibBabble-Boss-3.0"):GetReverseLookupTable()

local UnitExists = UnitExists
local UnitAffectingCombat = UnitAffectingCombat
local UnitName = UnitName
local count = 1
local GetSpellInfo = GetSpellInfo
local fmt = string.format

-- Provide some common translations here, so we don't have to replicate it in
-- every freaking module.
local commonWords = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
commonWords:RegisterTranslations("enUS", function() return {
	you = "You",
	are = "are",

	enrage_start = "%s Engaged - Enrage in %d min",
	enrage_end = "%s Enraged",
	enrage_min = "Enrage in %d min",
	enrage_sec = "Enrage in %d sec",
	enrage = "Enrage",

	berserk_start = "%s Engaged - Berserk in %d min",
	berserk_end = "%s goes Berserk",
	berserk_min = "Berserk in %d min",
	berserk_sec = "Berserk in %d sec",
	berserk = "Berserk",
} end)

commonWords:RegisterTranslations("deDE", function() return {
	you = "Ihr",
	are = "seid",

	enrage_start = "%s Angegriffen - Wütend in %dmin",
	enrage_end = "%s Wütend",
	enrage_min = "Wütend in %d min",
	enrage_sec = "Wütend in %d sek",
	enrage = "Wütend",

	berserk_start = "%s Angegriffen - Berserker in %d min",
	berserk_end = "%s wird zum Berserker",
	berserk_min = "Berserker in %d min",
	berserk_sec = "Berserker in %d sek",
	berserk = "Berserker",
} end )

commonWords:RegisterTranslations("koKR", function() return {
	you = "당신은",
	are = " ",

	enrage_start = "%s 전투 개시 - %d분 후 격노",
	enrage_end = "%s 격노",
	enrage_min = "%d분 후 격노",
	enrage_sec = "%d초 후 격노",
	enrage = "격노",

	berserk_start = "%s 전투 개시 - %d분 후 광폭화",
	berserk_end = "%s 광폭화",
	berserk_min = "%d분 후 광폭화",
	berserk_sec = "%d초 후 광폭화",
	berserk = "광폭화",
} end )

commonWords:RegisterTranslations("zhCN", function() return {
	you = "你",
	are = "到",

	enrage_start = "%s 激活 - %d分后激怒",
	enrage_end = "%s 已激怒",
	enrage_min = "%d分后激怒！",
	enrage_sec = "%d秒后激怒！",
	enrage = "激怒",

	berserk_start = "%s 激活 - 将在 %d 分后狂暴",
	berserk_end = "%s 进入 狂暴",
	berserk_min = "%d分后狂暴！",
	berserk_sec = "%d秒后狂暴！",
	berserk = "狂暴",
} end )

commonWords:RegisterTranslations("zhTW", function() return {
	you = "你",
	are = "到了",

	enrage_start = "%s 開戰 - %d 分後狂怒",
	enrage_end = "%s 已狂怒",
	enrage_min = "%d 分後狂怒",
	enrage_sec = "%d 秒後狂怒",
	enrage = "狂怒",

	berserk_start = "%s 開戰 - %d 分後狂暴",
	berserk_end = "%s 已狂暴",
	berserk_min = "%d 分後狂暴",
	berserk_sec = "%d 秒後狂暴",
	berserk = "狂暴",
} end )

commonWords:RegisterTranslations("frFR", function() return {
	you = "Vous",
	are = "subissez",

	enrage_start = "%s engagé - Enrager dans %d min.",
	enrage_end = "%s enragé",
	enrage_min = "Enrager dans %d min.",
	enrage_sec = "Enrager dans %d sec.",
	enrage = "Enrager",

	berserk_start = "%s engagé - Berserk dans %d min.",
	berserk_end = "%s devient berserk",
	berserk_min = "Berserk dans %d min.",
	berserk_sec = "Berserk dans %d sec.",
	berserk = "Berserk",
} end )

commonWords:RegisterTranslations("esES", function() return {
	you = "Tú",
	are = "estás",

	enrage_start = "%s Iniciado - Enfurecimiento en %d min",
	enrage_end = "%s Enfurecido",
	enrage_min = "Enfurecimiento en %d min",
	enrage_sec = "Enfurecimiento en %d seg",
	enrage = "Enfurecer",

	berserk_start = "%s Iniciado - Rabia en %d min",
	berserk_end = "%s entra en Rabia",
	berserk_min = "Rabia en %d min",
	berserk_sec = "Rabia en %d seg",
	berserk = "Rabia",
} end)
-- Translated by wow.playhard.ru translators
commonWords:RegisterTranslations("ruRU", function() return {
	you = "Вы",
	are = "",

	enrage_start = "%s Исступление - Исступление за %d мин",
	enrage_end = "%s вошел в состояние Исступления",
	enrage_min = "Исступление за %d мин",
	enrage_sec = "Исступление за %d сек",
	enrage = "Исступление",

	berserk_start = "%s Исступление - Берсерк за %d мин",
	berserk_end = "%s вошел в состояние Берсерка",
	berserk_min = "Берсерк за %d мин",
	berserk_sec = "Берсерк за %d сек",
	berserk = "Берсерк",
} end)

function BigWigs.modulePrototype:OnInitialize()
	-- Unconditionally register, this shouldn't happen from any other place
	-- anyway.
	BigWigs:RegisterModule(self)
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

function BigWigs.modulePrototype:COMBAT_LOG_EVENT_UNFILTERED(_, event, _, source, sFlags, dGUID, player, dFlags, spellId, spellName, _, secSpellId)
	local m = self.combatLogEventMap and self.combatLogEventMap[event]
	if m and (m[spellId] or m["*"]) then
		if event == "UNIT_DIED" then
			self[m["*"]](self, player, dGUID)
		else
			self[m[spellId] or m["*"]](self, player, spellId, source, secSpellId, spellName, event, sFlags, dFlags)
		end
	end
	local s = self.syncEventMap and self.syncEventMap[event]
	if s then
		for token, data in pairs(s) do
			if data.spellIds[spellId] then
				transmitSync(self, token, data.argumentList, player, spellId, source, secSpellId, spellName, event, sFlags, dFlags)
			end
		end
	end
end

-- XXX Proposed API, subject to change.
function BigWigs.modulePrototype:AddCombatListener(event, func, ...)
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
	if not self:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED") then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

local spellIds = {}
local function delTable(t)
	for k, v in pairs(t) do
		t[k] = nil
	end
end
-- XXX Proposed API, subject to change.
function BigWigs.modulePrototype:AddSyncListener(event, ...)
	if not self.syncEventMap then self.syncEventMap = {} end
	if not self.syncEventMap[event] then self.syncEventMap[event] = {} end
	local token = nil
	-- clean out old ids
	delTable(spellIds)
	local c = select("#", ...)
	for i = 1, c do
		local arg = select(i, ...)
		if type(arg) == "string" then
			token = arg
			if not self.syncEventMap[event][token] then self.syncEventMap[event][token] = {} end
			if self.syncEventMap[event][token].spellIds then
				delTable(self.syncEventMap[event][token].spellIds)
			else
				self.syncEventMap[event][token].spellIds = {}
			end
			for k, v in pairs(spellIds) do
				self.syncEventMap[event][token].spellIds[k] = spellIds[k]
			end
			if c > i then
				if self.syncEventMap[event][token].argumentList then
					delTable(self.syncEventMap[event][token].argumentList)
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
	if not self:IsEventRegistered("COMBAT_LOG_EVENT_UNFILTERED") then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

function BigWigs.modulePrototype:IsBossModule()
	return self.zonename and self.enabletrigger and true
end

function BigWigs.modulePrototype:GenericBossDeath(msg, multi)
	local b = self:ToString()
	if msg == b then
		if multi then
			self:Sync("MultiBossDeath " .. b)
		else
			self:Sync("BossDeath " .. b)
		end
	end
end

function BigWigs.modulePrototype:BossDeath(_, guid, multi)
	local b = self:ToString()
	if type(guid) == "string" then
		guid = tonumber((guid):sub(-12,-7),16)
	end

	if guid == self.guid then
		if multi then
			self:Sync("BWMultiBossDeath " .. b)
		else
			self:Sync("BWBossDeath " .. b)
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

function BigWigs.modulePrototype:Scan()
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

function BigWigs.modulePrototype:GetEngageSync()
	return "BossEngaged"
end

-- Really not much of a validation, but at least it validates that the sync is
-- remotely related to the module :P
function BigWigs.modulePrototype:ValidateEngageSync(sync, rest)
	if type(sync) ~= "string" or type(rest) ~= "string" then return false end
	if sync ~= self:GetEngageSync() then return false end
	if not self.scanTable then populateScanTable(self) end
	for mob in pairs(self.scanTable) do
		local translated = BBR[mob] or mob
		if translated == rest or mob == rest then return true end
	end

	local boss = BBR[rest] or rest
	return boss == self:ToString() or rest == self:ToString()
end

function BigWigs.modulePrototype:CheckForEngage()
	local go = self:Scan()
	if go then
		local mod = self:ToString()
		local moduleName = BBR[mod] or mod
		self:Sync(self:GetEngageSync().." "..moduleName)
	elseif UnitAffectingCombat("player") then
		self:ScheduleEvent(self.CheckForEngage, .5, self)
	end
end

function BigWigs.modulePrototype:CheckForWipe()
	if not UnitIsFeignDeath("player") then
		local go = self:Scan()
		if not go then
			self:TriggerEvent("BigWigs_RemoveRaidIcon")
			self:TriggerEvent("BigWigs_RebootModule", self)
			return
		end
	end

	if not UnitAffectingCombat("player") then
		self:ScheduleEvent(self.CheckForWipe, 2, self)
	end
end
-- Shortcuts for common actions.

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
	function BigWigs.modulePrototype:IfMessage(key, color, icon, sound, locale, ...)
		if locale and not self.db.profile[key] then return end
		local text = not locale and key or locale[keys[key]]:format(...)
		self:TriggerEvent("BigWigs_Message", text, color, nil, sound, nil, icon)
	end

	-- XXX Proposed API, subject to change.
	-- Outputs a local message only, no raid warning.
	function BigWigs.modulePrototype:LocalMessage(key, color, icon, sound, locale, ...)
		if locale and not self.db.profile[key] then return end
		local text = not locale and key or locale[keys[key]]:format(...)
		self:TriggerEvent("BigWigs_Message", text, color, true, sound, nil, icon)
	end

	-- XXX Proposed API, subject to change.
	-- Outputs a raid warning message only, no local message.
	function BigWigs.modulePrototype:WideMessage(key, locale, ...)
		if locale and not self.db.profile[key] then return end
		local text = not locale and key or locale[keys[key]]:format(...)
		self:TriggerEvent("BigWigs_Message", text, nil, nil, nil, true)
	end
end

function BigWigs.modulePrototype:Message(...)
	self:TriggerEvent("BigWigs_Message", ...)
end

function BigWigs.modulePrototype:DelayedMessage(delay, ...)
	if count == 100 then count = 1 end
	local id = fmt("%s%d", "BigWigs-DelayedMessage-", count)
	count = count + 1
	self:ScheduleEvent(id, "BigWigs_Message", delay, ...)
	return id
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

	function BigWigs.modulePrototype:Bar(text, length, icon, ...)
		self:TriggerEvent("BigWigs_StartBar", self, text, length, icons[icon], ...)
	end

	-- XXX Proposed API, subject to change.
	function BigWigs.modulePrototype:IfBar(key, length, icon, color, locale, ...)
		if not self.db.profile[key] then return end
		local text = locale[key .. "_bar"]:format(...)
		self:TriggerEvent("BigWigs_StartBar", self, text, length, icons[icon], color)
	end
end

function BigWigs.modulePrototype:Sync(...)
	self:TriggerEvent("BigWigs_SendSync", strjoin(" ", ...))
end

-- XXX 3rd argument is a proposed API change, and is subject to change/removal.
function BigWigs.modulePrototype:Whisper(player, text, key)
	if key and not self.db.profile[key] then return end
	self:TriggerEvent("BigWigs_SendTell", player, text)
end

-- XXX 2nd argument is a proposed API change, and is subject to change/removal.
function BigWigs.modulePrototype:Icon(player, key)
	if key and not self.db.profile[key] then return end
	self:TriggerEvent("BigWigs_SetRaidIcon", player)
end

function BigWigs.modulePrototype:Throttle(seconds, ...)
	self:TriggerEvent("BigWigs_ThrottleSync", seconds, ...)
end

do
	local berserk = {
		start = commonWords["berserk_start"],
		min = commonWords["berserk_min"],
		sec = commonWords["berserk_sec"],
		stop = commonWords["berserk_end"],
		bar = GetSpellInfo(43),
		icon = 20484,
	}
	local enrage = {
		start = commonWords["enrage_start"],
		min = commonWords["enrage_min"],
		sec = commonWords["enrage_sec"],
		stop = commonWords["enrage_end"],
		bar = GetSpellInfo(12880),
		icon = 12880,
	}
	function BigWigs.modulePrototype:Enrage(seconds, isBerserk, noEngageMessage)
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

