assert(BigWigs, "BigWigs not found!")

---------------------------------
--      Addon Declaration      --
---------------------------------

local plugin = BigWigs:New("Version Checker", tonumber(("$Revision$"):sub(12, -3)))
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
local oldVersionThreshold = 10 -- 10 revisions behind means it's time to update
local shouldUpdate = nil
local playername = UnitName("player")
local versionBroadcastsNotChecked = {}
local outOfDateClients = {}

---------------------------------
--      Localization           --
---------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsVersionChecker")
L:RegisterTranslations("enUS", function() return {
	["should_upgrade"] = "This seems to be an older version of Big Wigs. It is recommended that you upgrade before entering into combat with a boss.",
	["out_of_date"] = "The following players seem to be running an old version: %s.",
} end )

L:RegisterTranslations("koKR", function() return {
	["should_upgrade"] = "Big Wigs의 구버전이 있습니다. 보스와 전투를 시작하기전에 업데이트를 권장합니다.",
} end )

L:RegisterTranslations("deDE", function() return {
	["should_upgrade"] = "Dies scheint eine ältere Version von Big Wigs zu sein. Es wird ein Update empfohlen bevor du einen Kampf mit einem Boss beginnst.",
} end )

L:RegisterTranslations("zhCN", function() return {
	["should_upgrade"] = "这似乎是一个旧版本的 Big Wigs。建议您在与首领战斗之前升级。",
} end )

L:RegisterTranslations("zhTW", function() return {
	["should_upgrade"] = "這似乎是一個舊版本的 Big Wigs。建議您在與首領戰鬥之前升級。",
} end )

L:RegisterTranslations("frFR", function() return {
	["should_upgrade"] = "Il semblerait qu'il s'agisse d'une ancienne version de Big Wigs. Il est recommandé de vous mettre à jour avant d'engager un boss.",
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
			if shouldUpdate then
				tt:AddLine(" ")
				tt:AddLine(L["should_upgrade"], 0.6, 1, 0.2, 1)
				tt:AddLine(" ")
			elseif next(outOfDateClients) then
				local ood = {}
				for player, rev in pairs(outOfDateClients) do
					if rev < revisions[highestRevision] then
						table.insert(ood, coloredNames[player])
					end
				end
				if #ood > 0 then
					tt:AddLine(" ")
					tt:AddLine(L["out_of_date"]:format(table.concat(ood, ", ")), 0.6, 1, 0.2, 1)
					tt:AddLine(" ")
				end
			end
		end)
	end

	scanModules()
end

local function newGroup()
	if not highestRevision then return end
	broadcast("BWVB2", string.format("%s:%d", highestRevision, revisions[highestRevision]))
	if shouldUpdate then notify() end
end

function plugin:OnEnable()
	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterBucketEvent("BigWigs_ModuleRegistered", 2, scanModules)
	self:RegisterEvent("BigWigs_JoinedGroup", newGroup)
	newGroup()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:CHAT_MSG_ADDON(prefix, message, distribution, sender)
	if sender == playername then return end
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

