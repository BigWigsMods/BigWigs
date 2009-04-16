assert(BigWigs, "BigWigs not found!")

--------------------------------------------------------------------------------
-- Addon Declaration
--

local plugin = BigWigs:New("Version Checker", "$Revision$")
if not plugin then return end
plugin.external = true

--------------------------------------------------------------------------------
-- Locals
--

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
			self[key] = "|cffcccccc"..key.."|r"
		end
		return self[key]
	end
})

local revisions = {}
local highestRevision = nil
local oldVersionThreshold = 5 -- 5 revisions behind means it's time to update
local shouldUpdate = nil
local playername = UnitName("player")
local versionBroadcastsNotChecked = {}
local outOfDateClients = {}

local bigwigsUsers = {
	[playername] = true
}
local notUsingBW = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigsVersionChecker")
L:RegisterTranslations("enUS", function() return {
	["should_upgrade"] = "This seems to be an older version of Big Wigs. It is recommended that you upgrade before entering into combat with a boss.",
	["out_of_date"] = "The following players seem to be running an old version: %s.",
	["not_using"] = "Group members not using Big Wigs: %s.",
} end )

L:RegisterTranslations("koKR", function() return {
	["should_upgrade"] = "Big Wigs가 구버전입니다. 보스와 전투를 시작하기전에 업데이트를 권장합니다.",
	["out_of_date"] = "구버전을 사용중인 플레이어: %s.",
	["not_using"] = "Big Wigs 미사용중인 그룹 멤버: %s.",
} end )

L:RegisterTranslations("deDE", function() return {
	["should_upgrade"] = "Dies scheint eine ältere Version von Big Wigs zu sein. Es wird ein Update empfohlen, bevor du einen Kampf mit einem Boss beginnst.",
	["out_of_date"] = "Die folgenden Spieler scheinen eine ältere Version zu haben: %s.",
	["not_using"] = "Gruppenmitglieder, die nicht Big Wigs benutzen: %s.",
} end )

L:RegisterTranslations("zhCN", function() return {
	["should_upgrade"] = "这似乎是一个旧版本的 Big Wigs。建议您在与首领战斗之前升级。",
	["out_of_date"] = "以下玩家似乎使用旧版本：%s。",
	["not_using"] = "团队成员没有使用 Big Wigs：%s。",
} end )

L:RegisterTranslations("zhTW", function() return {
	["should_upgrade"] = "這似乎是一個舊版本的 Big Wigs。建議您在與首領戰鬥之前升級。",
	["out_of_date"] = "以下玩家似乎使用舊版本：%s。",
	["not_using"] = "團隊成員沒有使用 Big Wigs：%s。",
} end )

L:RegisterTranslations("frFR", function() return {
	["should_upgrade"] = "Il semblerait que vous utilisez une ancienne version de Big Wigs. Il est recommandé de vous mettre à jour avant d'engager un boss.",
	["out_of_date"] = "Les joueurs suivants semblent utiliser une ancienne version : %s.",
	["not_using"] = "Membres n'utilisant pas Big Wigs : %s.",
} end )

L:RegisterTranslations("ruRU", function() return {
	["should_upgrade"] = "Это, кажется, старая версия Big Wigs. Мы рекомендуем вам обновить её перед началом боя с боссом.",
	["out_of_date"] = "Следующие игроки, похоже, используют старую версию: %s.",
	["not_using"] = "Участник группы не использующий Big Wigs: %s.",
} end )

--------------------------------------------------------------------------------
-- Local utility functions
--

local function broadcast(pre, m)
	local inGuild = IsInGuild()
	local inGroup = (GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0)
	if not inGuild and not inGroup then return end
	if inGroup then SendAddonMessage(pre, m, "RAID") end
	if inGuild then SendAddonMessage(pre, m, "GUILD") end
end

local function notify()
	broadcast("BWOOD", revisions[highestRevision])
	if shouldUpdate then return end
	shouldUpdate = true
	print(L["should_upgrade"])
end

local function scanModules()
	if shouldUpdate then return end
	local lastHighestRevision = highestRevision
	for name, module in BigWigs:IterateModules() do
		local rev = module.revision
		if rev then
			if not highestRevision or rev > revisions[highestRevision] then
				highestRevision = name
			end
			revisions[name] = rev
		end
	end
	if highestRevision ~= lastHighestRevision then
		broadcast("BWVB2", string.format("%s:%d", highestRevision, revisions[highestRevision]))
	end
	for module, rev in pairs(versionBroadcastsNotChecked) do
		if revisions[module] and rev > (revisions[module] + oldVersionThreshold) then
			notify()
			break
		end
	end
end

--------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnRegister()
	if BigWigsOptions and BigWigsOptions.RegisterTooltipInfo then
		BigWigsOptions:RegisterTooltipInfo(function(tt)
			local addedInfo = nil
			if shouldUpdate then
				addedInfo = true
				tt:AddLine(" ")
				tt:AddLine(L["should_upgrade"], 0.6, 1, 0.2, 1)
			elseif next(outOfDateClients) then
				local ood = {}
				for player, rev in pairs(outOfDateClients) do
					if rev < revisions[highestRevision] then
						table.insert(ood, coloredNames[player])
					end
				end
				if #ood > 0 then
					addedInfo = true
					tt:AddLine(" ")
					tt:AddLine(L["out_of_date"]:format(table.concat(ood, ", ")), 0.6, 1, 0.2, 1)
				end
			end
			if #notUsingBW > 0 then
				addedInfo = true
				tt:AddLine(" ")
				tt:AddLine(L["not_using"]:format(table.concat(notUsingBW, ", ")), 0.6, 1, 0.2, 1)
			end
			if addedInfo then tt:AddLine(" ") end
		end)
	end

	scanModules()
end

local function updateBWUsers()
	notUsingBW = wipe(notUsingBW)
	local num = GetNumRaidMembers()
	for i = 1, num do
		local n, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
		if n and online and not bigwigsUsers[n] then table.insert(notUsingBW, coloredNames[n]) end
	end
	table.sort(notUsingBW)
end

local function newGroup()
	if not highestRevision then return end
	for k in pairs(coloredNames) do coloredNames[k] = nil end
	broadcast("BWVB2", string.format("%s:%d", highestRevision, revisions[highestRevision]))
	if shouldUpdate then notify() end
	updateBWUsers()
end

function plugin:OnEnable()
	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterBucketEvent("BigWigs_ModuleRegistered", 2, scanModules)
	self:RegisterEvent("BigWigs_JoinedGroup", newGroup)
	self:RegisterEvent("BigWigs_LeftGroup", updateBWUsers)
	newGroup()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Include some old prefixes as well, so that we don't flag people running
-- slightly older versions as not having BW at all.
local bwPrefixes = {
	BWVB = true,
	BWVB2 = true,
	BWOOD = true,
	BWVQ = true,
	BWVR = true,
}

function plugin:CHAT_MSG_ADDON(prefix, message, distribution, sender)
	if sender == playername then return end
	if not bwPrefixes[prefix] then return end
	if not bigwigsUsers[sender] then
		bigwigsUsers[sender] = true
		updateBWUsers()
	end
	if prefix == "BWVB2" then
		local module, rev = select(3, message:find("(.*):(%d+)"))
		if not module or not rev then return end
		rev = tonumber(rev)
		if revisions[module] then
			if rev > (revisions[module] + oldVersionThreshold) then
				notify()
			end
		else
			versionBroadcastsNotChecked[module] = rev
		end
	elseif prefix == "BWOOD" then
		outOfDateClients[sender] = tonumber(message)
	end
end

