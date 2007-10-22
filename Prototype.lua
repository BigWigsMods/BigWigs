--------------------------------
--      Module Prototype      --
--------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs")
local BB = AceLibrary("Babble-Boss-2.2")

local UnitExists = UnitExists
local UnitAffectingCombat = UnitAffectingCombat
local UnitName = UnitName
local count = 1
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

	RF = "Righteous Fury",
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

	RF = "Zorn der Gerechtigkeit",
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

	RF = "정의의 격노",
} end )

--Chinese Transalte by 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
commonWords:RegisterTranslations("zhCN", function() return {
	you = "你",
	are = "到",

	enrage_start = "%s 狂暴 - %d分后狂暴",
	enrage_end = "%s 已狂暴",
	enrage_min = "%d分后狂暴！",
	enrage_sec = "%d秒后狂暴！",
	enrage = "狂暴",

	--berserk_start = "%s Engaged - Berserk in %d min",
	--berserk_end = "%s goes Berserk",
	--berserk_min = "Berserk in %d min",
	--berserk_sec = "Berserk in %d sec",
	--berserk = "Berserk",

	RF = "正义之怒",
} end )

commonWords:RegisterTranslations("zhTW", function() return {
	you = "你",
	are = "到了",

	enrage_start = "%s 狂怒 - %d分後狂怒",
	enrage_end = "%s 已狂怒",
	enrage_min = "%d分後狂怒！",
	enrage_sec = "%d秒後狂怒！",
	enrage = "狂怒",

	--berserk_start = "%s Engaged - Berserk in %d min",
	--berserk_end = "%s goes Berserk",
	--berserk_min = "Berserk in %d min",
	--berserk_sec = "Berserk in %d sec",
	--berserk = "Berserk",

	RF = "正義之怒",
} end )

commonWords:RegisterTranslations("frFR", function() return {
	you = "Vous",
	are = "subissez",

	enrage_start = "%s engagé(e) - Enrager dans %d min.",
	enrage_end = "%s enragé(e)",
	enrage_min = "Enrager dans %d min.",
	enrage_sec = "Enrager dans %d sec.",
	enrage = "Enrager",

	--berserk_start = "%s Engaged - Berserk in %d min",
	--berserk_end = "%s goes Berserk",
	--berserk_min = "Berserk in %d min",
	--berserk_sec = "Berserk in %d sec",
	--berserk = "Berserk",

	RF = "Fureur vertueuse",
} end )

commonWords:RegisterTranslations("esES", function() return {
	you = "Tu",
	are = "estas",

	enrage_start = "%s Activado - Furor en %dmin",
	enrage_end = "%s Enfurecido",
	enrage_min = "Enfurecimiento en %d min",
	enrage_sec = "Enfurecimiento en %d sec",
	enrage = "Enfurecimiento",

	--berserk_start = "%s Engaged - Berserk in %d min",
	--berserk_end = "%s goes Berserk",
	--berserk_min = "Berserk in %d min",
	--berserk_sec = "Berserk in %d sec",
	--berserk = "Berserk",

	RF = "Furia justa",
} end)

function BigWigs.modulePrototype:OnInitialize()
	-- Unconditionally register, this shouldn't happen from any other place
	-- anyway.
	BigWigs:RegisterModule(self)
end

function BigWigs.modulePrototype:IsBossModule()
	return self.zonename and self.enabletrigger and true
end

function BigWigs.modulePrototype:GenericBossDeath(msg)
	if msg == fmt(UNITDIESOTHER, self:ToString()) then
		self:Sync("BossDeath " .. self:ToString())
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
		return true
	end

	if UnitExists("focus") and UnitAffectingCombat("focus") and self.scanTable[UnitName("focus")] then
		return true
	end

	local num = GetNumRaidMembers()
	if num == 0 then
		num = GetNumPartyMembers()
		for i = 1, num do
			local partyUnit = fmt("%s%d%s", "party", i, "target")
			if UnitExists(partyUnit) and UnitAffectingCombat(partyUnit) and self.scanTable[UnitName(partyUnit)] then
				return true
			end
		end
	else
		for i = 1, num do
			local raidUnit = fmt("%s%d%s", "raid", i, "target")
			if UnitExists(raidUnit) and UnitAffectingCombat(raidUnit) and self.scanTable[UnitName(raidUnit)] then
				return true
			end
		end
	end
	return false
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
		local translated = BB:HasReverseTranslation(mob) and BB:GetReverseTranslation(mob) or mob
		if translated == rest or mob == rest then return true end
	end

	local boss = BB:HasReverseTranslation(rest) and BB:GetReverseTranslation(rest) or rest
	return boss == self:ToString() or rest == self:ToString()
end

function BigWigs.modulePrototype:CheckForEngage()
	local go = self:Scan()
	if go then
		if BigWigs:IsDebugging() then
			BigWigs:Debug(self, "Scan returned true, engaging.")
		end
		local mod = self:ToString()
		local moduleName = BB:HasReverseTranslation(mod) and BB:GetReverseTranslation(mod) or mod
		self:Sync(self:GetEngageSync().." "..moduleName)
	elseif UnitAffectingCombat("player") then
		self:ScheduleEvent(self.CheckForEngage, .5, self)
	end
end

function BigWigs.modulePrototype:CheckForWipe()
	if not UnitIsFeignDeath("player") then
		local go = self:Scan()
		if not go then
			if BigWigs:IsDebugging() then
				BigWigs:Debug(self, "Rebooting module.")
			end
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
			self[key] = "Interface\\Icons\\" .. key
			return self[key]
		end
	})
	function BigWigs.modulePrototype:Bar(text, length, icon, ...)
		self:TriggerEvent("BigWigs_StartBar", self, text, length, icons[icon], ...)
	end
end

function BigWigs.modulePrototype:Sync(sync, b, ...)
	if b then
		local full = fmt("%s %s", sync, tostring(b))
		for i = 1, select("#", ...) do
			full = fmt("%s %s", full, tostring(select(i, ...)))
		end
		self:TriggerEvent("BigWigs_SendSync", full)
	else
		self:TriggerEvent("BigWigs_SendSync", sync)
	end
end

function BigWigs.modulePrototype:Whisper(player, text)
	self:TriggerEvent("BigWigs_SendTell", player, text)
end

function BigWigs.modulePrototype:Icon(player)
	self:TriggerEvent("BigWigs_SetRaidIcon", player)
end

