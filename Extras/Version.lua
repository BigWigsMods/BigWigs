--------------------------------------------------------------------------------
-- Addon Declaration
--

local plugin = BigWigs:NewPlugin("Version Checker", "$Revision$")
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

local bigwigsUsers = {
	[playername] = true
}
local notUsingBW = {}


local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Extras")

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
	for name, module in BigWigs:IterateBossModules() do
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
	if BigWigsLoader and BigWigsLoader.RegisterTooltipInfo then
		local ood = {}
		BigWigsLoader:RegisterTooltipInfo(function(tt)
			local addedInfo = nil
			if shouldUpdate then
				addedInfo = true
				tt:AddLine(" ")
				tt:AddLine(L["should_upgrade"], 0.6, 1, 0.2, 1)
			elseif next(outOfDateClients) then
				for player, rev in pairs(outOfDateClients) do
					if revisions[highestRevision] and rev < revisions[highestRevision] then
						table.insert(ood, coloredNames[player])
					end
				end
				if #ood > 0 then
					addedInfo = true
					tt:AddLine(" ")
					tt:AddLine(L["out_of_date"]:format(table.concat(ood, ", ")), 0.6, 1, 0.2, 1)
					wipe(ood)
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
	wipe(notUsingBW)
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
	self:RegisterMessage("BigWigs_ModuleRegistered", scanModules)
	self:RegisterMessage("BigWigs_JoinedGroup", newGroup)
	self:RegisterMessage("BigWigs_LeftGroup", updateBWUsers)
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
	BigWigs = true, -- Comm module
}

function plugin:CHAT_MSG_ADDON(event, prefix, message, distribution, sender)
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

