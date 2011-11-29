local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs")

-- XXX Awful, awful hack to prevent the TotR from showing right after login in a
-- XXX LoD setup.
_G.BIGWIGS_LOADER_TIME = GetTime()

-----------------------------------------------------------------------
-- Generate our version variables
--

local REPO = "REPO"
local ALPHA = "ALPHA"
local RELEASE = "RELEASE"
local UNKNOWN = "UNKNOWN"

do
	-- START: MAGIC WOWACE VOODOO VERSION STUFF
	local releaseType = RELEASE
	local releaseRevision = nil
	local releaseString = nil
	--@alpha@
	-- The following code will only be present in alpha ZIPs.
	releaseType = ALPHA
	--@end-alpha@

	-- This will (in ZIPs), be replaced by the highest revision number in the source tree.
	releaseRevision = tonumber("@project-revision@")

	-- If the releaseRevision ends up NOT being a number, it means we're running a SVN copy.
	if type(releaseRevision) ~= "number" then
		releaseRevision = -1
		releaseType = REPO
	end

	-- Then build the release string, which we can add to the interface option panel.
	local majorVersion = GetAddOnMetadata("BigWigs", "Version") or "3.?"
	if releaseType == REPO then
		releaseString = L["You are running a source checkout of Big Wigs %s directly from the repository."]:format(majorVersion)
	elseif releaseType == RELEASE then
		releaseString = L["You are running an official release of Big Wigs %s (revision %d)"]:format(majorVersion, releaseRevision)
	elseif releaseType == ALPHA then
		releaseString = L["You are running an ALPHA RELEASE of Big Wigs %s (revision %d)"]:format(majorVersion, releaseRevision)
	end
	_G.BIGWIGS_RELEASE_TYPE = releaseType
	_G.BIGWIGS_RELEASE_REVISION = releaseRevision
	_G.BIGWIGS_RELEASE_STRING = releaseString
	-- END:   MAGIC WOWACE VOODOO VERSION STUFF
end

BigWigsLoader = LibStub("AceAddon-3.0"):NewAddon("BigWigsLoader", "AceEvent-3.0")
local loader = BigWigsLoader

local LOCALE = GetLocale()
if LOCALE == "enGB" then
	LOCALE = "enUS"
end
-- uncomment next line to debug Foreign Loading
-- LOCALE = "Foreignese"
loader.LOCALE = LOCALE

-----------------------------------------------------------------------
-- Locals
--

local ldb = nil
local pName = UnitName("player")

local tooltipFunctions = {}

-- Grouping
local BWRAID = 2
local BWPARTY = 1
local grouped = nil

-- Version
local usersAlpha = {}
local usersRelease = {}
local usersUnknown = {}
-- Only set highestReleaseRevision if we're actually using a release of BigWigs.
-- If we set this as an alpha user we will alert release users with out-of-date warnings
-- and class them as out-of-date in /bwv (if our alpha version is higher). But they may be
-- using the latest available release version of BigWigs. This method ensures they are
-- classed as up-to-date in /bwv if they use the latest available release of BigWigs
-- even if our alpha is revisions ahead.
local highestReleaseRevision = _G.BIGWIGS_RELEASE_TYPE == RELEASE and _G.BIGWIGS_RELEASE_REVISION or -1
-- The highestAlphaRevision is so we can alert old alpha users (we didn't previously)
local highestAlphaRevision = _G.BIGWIGS_RELEASE_TYPE == ALPHA and _G.BIGWIGS_RELEASE_REVISION or -1
local warnedOutOfDate = nil

-- Loading
local loadOnZoneAddons = {} -- Will contain all names of addons with an X-BigWigs-LoadOn-Zone directive. Filled in OnInitialize, garbagecollected in OnEnable.
local BB -- BabbleBoss-3.0 lookup table, will only be used if the foreign language pack is loaded aka LBB-3.0
local loadOnCoreEnabled = {} -- BigWigs modulepacks that should load when a hostile zone is entered or the core is manually enabled, this would be the default plugins Bars, Messages etc
local loadOnZone = {} -- BigWigs modulepack that should load on a specific zone
local loadOnCoreLoaded = {} -- BigWigs modulepacks that should load when the core is loaded
-- XXX shouldn't really be named "menus", it's actually panels in interface options now
local menus = {} -- contains the main menus for BigWigs, once the core is loaded they will get injected
local enableZones = {} -- contains the zones in which BigWigs will enable

-----------------------------------------------------------------------
-- Utility
--

--[[
function GetMapID(name)
	for i=1,1000 do
		local fetchedName = GetMapNameByID(i)
		if name == fetchedName then return i end
	end
end
function GetBossID(name)
	for i=1,1000 do
		local fetchedName, _, id = EJ_GetEncounterInfo(i)
		if fetchedName and (fetchedName):find(name) then print(fetchedName, i) end
	end
end
function PrintNewBossIDs() 
	for i=200,1000 do
		local n,_,id = EJ_GetEncounterInfo(i)
		if n then print(n,id) end
	end
end
]]

local printFormat = "|cffffff00%s|r"
local function sysprint(msg) print(printFormat:format(msg)) end

local getGroupMembers = nil
do
	local members = {}
	function getGroupMembers()
		local raid = GetRealNumRaidMembers()
		local party = GetRealNumPartyMembers()
		if raid == 0 and party == 0 then return end
		wipe(members)
		if raid > 0 then
			for i = 1, raid do
				local n = GetRaidRosterInfo(i)
				if n then members[#members + 1] = n end
			end
		elseif party > 0 then
			members[#members + 1] = pName
			for i = 1, 4 do
				local n = UnitName("party" .. i)
				if n then members[#members + 1] = n end
			end
		end
		return members
	end
end

local function registerEnableZone(zone, groupsize)
	-- only update enablezones if content is of lower level than before.
	-- if someone adds a party module to a zone that is already in the table as a raid, set the level of that zone to party
	if not enableZones[zone] or (enableZones[zone] and enableZones[zone] > groupsize) then
		enableZones[zone] = tonumber(groupsize) -- needs to be a number.
	end
end

local errorInvalidZoneID = "The zone ID %q from the addon %q was not parsable."
local function iterateZones(addon, override, partyContent, ...)
	for i = 1, select("#", ...) do
		local rawZone = select(i, ...)
		local zone = tonumber(rawZone:trim())
		if zone then
			-- register the zone for enabling.
			registerEnableZone(zone, partyContent and BWPARTY or BWRAID)

			if not loadOnZone[zone] then loadOnZone[zone] = {} end
			loadOnZone[zone][#loadOnZone[zone] + 1] = addon

			if override then
				loadOnZone[override][#loadOnZone[override] + 1] = addon
			else
				menus[zone] = true
			end
		else
			sysprint(errorInvalidZoneID:format(tostring(rawZone), tostring(addon)))
		end
	end
end

local function load(obj, name)
	if obj then return true end
	-- Verify that the addon isn't disabled
	local enabled = select(4, GetAddOnInfo(name))
	if not enabled then
		sysprint("Error loading " .. name .. " ("..name.." is not enabled)")
		return
	end
	-- Load the addon
	local succ, err = LoadAddOn(name)
	if not succ then
		sysprint("Error loading " .. name .. " (" .. err .. ")")
		return
	end
	return true
end

local function loadAddons(tbl)
	if not tbl then return end
	for i, addon in next, tbl do
		if not IsAddOnLoaded(addon) and load(nil, addon) then
			loader:SendMessage("BigWigs_ModulePackLoaded", addon)
		end
	end
	tbl = nil
end

local function loadZone(zone)
	if not zone then return end
	loadAddons(loadOnZone[zone])
end

local function loadAndEnableCore()
	load(BigWigs, "BigWigs_Core")
	if not BigWigs then return end
	BigWigs:Enable()
end

local function loadCoreAndOpenOptions()
	loadAndEnableCore()
	load(BigWigsOptions, "BigWigs_Options")
	if not BigWigsOptions then return end
	BigWigsOptions:Open()
end

-----------------------------------------------------------------------
-- Version listing functions
--

local function versionTooltipFunc(tt)
	-- Try to avoid calling getGroupMembers as long as possible.
	-- XXX We should just get a file-local boolean flag that we update
	-- whenever we receive a version reply from someone. That way we
	-- reduce the processing required to open a simple tooltip.
	local add = nil
	for player, version in pairs(usersRelease) do
		if version < highestReleaseRevision then
			add = true
			break
		end
	end
	if not add then
		for player, version in pairs(usersAlpha) do
			-- If this person's alpha version isn't SVN (-1) and it's lower than the highest found release version minus 1 because
			-- of tagging, or it's lower than the highest found alpha version (with a 10 revision leeway) then that person is out-of-date
			if version ~= -1 and (version < (highestReleaseRevision - 1) or version < (highestAlphaRevision - 10)) then
				add = true
				break
			end
		end
	end
	if not add and next(usersUnknown) then
		add = true
	end
	if not add then
		local m = getGroupMembers()
		if m then
			for i, player in next, m do
				if not usersRelease[player] and not usersAlpha[player] then
					add = true
					break
				end
			end
		end
	end
	if add then
		tt:AddLine(L["There are people in your group with older versions or without Big Wigs. You can get more details with /bwv."], 1, 0, 0, 1)
	end
end

-----------------------------------------------------------------------
-- Loader initialization
--

local reqFuncAddons = {
	BigWigs_Core = true,
	BigWigs_Options = true,
	BigWigs_Plugins = true,
}

function loader:OnInitialize()
	for i = 1, GetNumAddOns() do
		local name, _, _, enabled = GetAddOnInfo(i)
		if enabled and not IsAddOnLoaded(i) and IsAddOnLoadOnDemand(i) then
			local meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-CoreEnabled")
			if meta then
				loadOnCoreEnabled[#loadOnCoreEnabled + 1] = name
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-CoreLoaded")
			if meta then
				loadOnCoreLoaded[#loadOnCoreLoaded + 1] = name
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-ZoneId")
			if meta then
				loadOnZoneAddons[#loadOnZoneAddons + 1] = name
			end
		elseif not enabled and reqFuncAddons[name] then
			sysprint(L["coreAddonDisabled"])
		end
	end

	-- register for these messages OnInit so we receive these messages when the core and modules oninitialize fires
	self:RegisterMessage("BigWigs_BossModuleRegistered")
	self:RegisterMessage("BigWigs_CoreLoaded")

	local icon = LibStub("LibDBIcon-1.0", true)
	if icon and ldb then
		if not BigWigs3IconDB then BigWigs3IconDB = {} end
		icon:Register("BigWigs", ldb, BigWigs3IconDB)
	end
	self:RegisterTooltipInfo(versionTooltipFunc)
end

function loader:OnEnable()
	if LOCALE ~= "enUS" and not BB then
		if not LibStub("LibBabble-Boss-3.0", true) then
			load(nil, "BigWigs_Foreign")
		end
		-- check again and error if you can't find
		if not LibStub("LibBabble-Boss-3.0", true) then
			sysprint("Error retrieving LibBabble-Boss-3.0, please reinstall Big Wigs.")
		else
			BB = LibStub("LibBabble-Boss-3.0"):GetUnstrictLookupTable()
		end
	end

	if loadOnZoneAddons then
		-- From this point onward BB should be available for non-english locales
		for i, name in next, loadOnZoneAddons do
			local menu = tonumber(GetAddOnMetadata(name, "X-BigWigs-Menu"))
			if menu then
				if not loadOnZone[menu] then loadOnZone[menu] = {} end
				menus[menu] = true
			end
			local zones = GetAddOnMetadata(name, "X-BigWigs-LoadOn-ZoneId")
			if zones then
				local partyContent = GetAddOnMetadata(name, "X-BigWigs-PartyContent")
				iterateZones(name, menu, partyContent, strsplit(",", zones))
			end
		end
		loadOnZoneAddons = nil
	end

	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChanged")
	self:RegisterEvent("RAID_ROSTER_UPDATE", "CheckRoster")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED", "CheckRoster")

	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterMessage("BigWigs_AddonMessage")
	RegisterAddonMessagePrefix("BigWigs")

	self:RegisterMessage("BigWigs_JoinedGroup")
	self:RegisterMessage("BigWigs_LeftGroup")
	self:RegisterMessage("BigWigs_CoreEnabled")
	self:RegisterMessage("BigWigs_CoreDisabled")

	-- XXX Hack to make the zone ID available when reloading/relogging inside an instance
	SetMapToCurrentZone()

	self:CheckRoster()
	self:ZoneChanged()
end

-----------------------------------------------------------------------
-- Events
--

function loader:CHAT_MSG_ADDON(event, prefix, message, distribution, sender)
	if prefix ~= "BigWigs" then return end
	local bwPrefix = (message):gsub("^(%u-):.+", "%1")
	if not bwPrefix then return end
	message = (message):gsub("^%u-:(.+)", "%1")
	self:SendMessage("BigWigs_AddonMessage", bwPrefix, message, sender)
end

do
	local delayTransmitter = CreateFrame("Frame")
	delayTransmitter:Hide()
	delayTransmitter:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		if self.elapsed > 5 then
			self:Hide()
			if BIGWIGS_RELEASE_TYPE == RELEASE then
				SendAddonMessage("BigWigs", "VR:"..BIGWIGS_RELEASE_REVISION, "RAID")
			else
				SendAddonMessage("BigWigs", "VRA:"..BIGWIGS_RELEASE_REVISION, "RAID")
			end
		end
	end)

	function loader:BigWigs_AddonMessage(event, prefix, message, sender)
		if prefix == "VQ" then
			if not usersRelease[sender] and not usersAlpha[sender] then
				usersUnknown[sender] = true
			end
			delayTransmitter.elapsed = 0
			delayTransmitter:Show()
		elseif prefix == "OOD" then
			if not tonumber(message) or warnedOutOfDate then return end
			if tonumber(message) > BIGWIGS_RELEASE_REVISION then
				warnedOutOfDate = true
				-- Adapt the out-of-date nag according to release type
				if BIGWIGS_RELEASE_TYPE == RELEASE then
					sysprint(L["There is a new release of Big Wigs available(/bwv). You can visit curse.com, wowinterface.com, wowace.com or use the Curse Updater to get the new release."])
				elseif BIGWIGS_RELEASE_TYPE == ALPHA then
					sysprint(L["Your alpha version of Big Wigs is out of date(/bwv)."])
				end
			end
		elseif prefix == "VR" then
			message = tonumber(message)
			if not message then return end
			usersRelease[sender] = message
			usersAlpha[sender] = nil
			usersUnknown[sender] = nil
			-- Harvest the highest release version we can find then use that
			-- to make sure others are up-to-date. Since releases are generally
			-- many revisions apart, we just warn anyone under the highest revision found
			-- instead of leaving any leeway (e.g. 10 revisions for alpha)
			if message > highestReleaseRevision then highestReleaseRevision = message end
			if sender ~= pName and highestReleaseRevision > message then
				SendAddonMessage("BigWigs", "OOD:"..highestReleaseRevision, "WHISPER", sender)
			end
		elseif prefix == "VRA" then
			message = tonumber(message)
			if not message then return end
			usersAlpha[sender] = message
			usersRelease[sender] = nil
			usersUnknown[sender] = nil
			-- Harvest the highest alpha version we can find then use that to make sure
			-- others are up-to-date. We allow upto a 10 revision leeway before sending a nag
			-- Also compare that alpha version against the highest release version for a situation
			-- where there is only 1 alpha in the raid and it is majorly out-of-date
			if message > highestAlphaRevision then highestAlphaRevision = message end
			if sender ~= pName and message ~= -1 and ((highestAlphaRevision - 10) > message or (highestReleaseRevision - 10) > message) then
				SendAddonMessage("BigWigs", "OOD:"..highestAlphaRevision, "WHISPER", sender)
			end
		end
	end
end

function loader:ZoneChanged()
	if not grouped then return end
	local id = GetCurrentMapAreaID()
	-- load party content in raid, but don't load raid content in a party...
	if enableZones[id] and enableZones[id] <= grouped then
		if load(BigWigs, "BigWigs_Core") then
			if BigWigs:IsEnabled() and loadOnZone[id] then
				loadZone(id)
			else
				BigWigs:Enable()
			end
		end
	end
end

function loader:CheckRoster()
	local raid = GetRealNumRaidMembers()
	local party = GetRealNumPartyMembers()
	if not grouped and raid > 0 then
		grouped = BWRAID
		self:SendMessage("BigWigs_JoinedGroup", grouped)
	elseif not grouped and party > 0 then
		grouped = BWPARTY
		self:SendMessage("BigWigs_JoinedGroup", grouped)
	elseif grouped then
		if grouped == BWPARTY and raid > 0 then
			grouped = BWRAID
			self:SendMessage("BigWigs_JoinedGroup", grouped)
		elseif raid == 0 and party == 0 then
			grouped = nil
			self:SendMessage("BigWigs_LeftGroup")
		end
	end
end

function loader:BigWigs_BossModuleRegistered(message, name, module)
	registerEnableZone(module.zoneId, module.partyContent and BWPARTY or BWRAID)
end

function loader:BigWigs_CoreEnabled()
	if ldb then
		ldb.icon = "Interface\\AddOns\\BigWigs\\Textures\\icons\\core-enabled"
	end

	loadAddons(loadOnCoreEnabled)

	-- core is enabled, unconditionally load the zones
	loadZone(GetCurrentMapAreaID())
end

function loader:BigWigs_CoreDisabled()
	if ldb then
		ldb.icon = "Interface\\AddOns\\BigWigs\\Textures\\icons\\core-disabled"
	end
end

function loader:BigWigs_CoreLoaded()
	loadAddons(loadOnCoreLoaded)
end

function loader:BigWigs_JoinedGroup()
	self:ZoneChanged()
	SendAddonMessage("BigWigs", "VQ:"..BIGWIGS_RELEASE_REVISION, "RAID")
end

function loader:BigWigs_LeftGroup()
	wipe(usersRelease)
	wipe(usersAlpha)
	wipe(usersUnknown)
	-- BigWigs might not have loaded yet, fringe case, but better prevent errors
	if BigWigs then
		BigWigs:Disable()
	end
end

-----------------------------------------------------------------------
-- API
--

function loader:RegisterTooltipInfo(func)
	for i, v in next, tooltipFunctions do
		if v == func then
			error(("The function %q has already been registered."):format(func))
		end
	end
	tinsert(tooltipFunctions, func)
end

function loader:GetZoneMenus()
	return menus
end

function loader:LoadZone(zone)
	loadZone(zone)
end

-----------------------------------------------------------------------
-- LDB Plugin
--

local ldb11 = LibStub("LibDataBroker-1.1", true)
if ldb11 then
	ldb = ldb11:NewDataObject("BigWigs", {
		type = "launcher",
		label = "Big Wigs",
		icon = "Interface\\AddOns\\BigWigs\\Textures\\icons\\core-disabled",
	})

	function ldb.OnClick(self, button)
		if button == "RightButton" then
			loadCoreAndOpenOptions()
		else
			loadAndEnableCore()
			if IsAltKeyDown() then
				if IsControlKeyDown() then
					BigWigs:Disable()
				else
					for name, module in BigWigs:IterateBossModules() do
						if module:IsEnabled() then module:Disable() end
					end
					sysprint(L["All running modules have been disabled."])
				end
			else
				for name, module in BigWigs:IterateBossModules() do
					if module:IsEnabled() then module:Reboot() end
				end
				sysprint(L["All running modules have been reset."])
			end
		end
	end

	function ldb.OnTooltipShow(tt)
		tt:AddLine("Big Wigs")
		local h = nil
		if BigWigs and BigWigs:IsEnabled() then
			local added = nil
			for name, module in BigWigs:IterateBossModules() do
				if module:IsEnabled() then
					if not added then
						tt:AddLine(L["Active boss modules:"], 1, 1, 1)
						added = true
					end
					tt:AddLine(module.displayName)
				end
			end
		end
		for i, v in next, tooltipFunctions do
			v(tt)
		end
		tt:AddLine(L.tooltipHint, 0.2, 1, 0.2, 1)
	end
end

-----------------------------------------------------------------------
-- Slash commands
--

hash_SlashCmdList["/bw"] = nil
hash_SlashCmdList["/bigwigs"] = nil
SLASH_BigWigs1 = "/bw"
SLASH_BigWigs2 = "/bigwigs"
SlashCmdList.BigWigs = loadCoreAndOpenOptions

do
	local hexColors = nil
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
	local function coloredNameVersion(name, version, alpha)
		if version == -1 then version = "svn" alpha = nil end
		return string.format("%s|cffcccccc(%s%s)|r", coloredNames[name], version or "unknown", alpha and "-alpha" or "")
	end
	local function showVersions()
		local m = getGroupMembers()
		if not m then return end
		if not hexColors then
			hexColors = {}
			for k, v in pairs(CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS) do
				hexColors[k] = "|cff" .. string.format("%02x%02x%02x", v.r * 255, v.g * 255, v.b * 255)
			end
		end
		local good = {} -- highest release users
		local ugly = {} -- old version users
		local bad  = {} -- non-bw users
		for i, player in next, m do
			if usersRelease[player] then
				if usersRelease[player] < highestReleaseRevision then
					ugly[#ugly + 1] = coloredNameVersion(player, usersRelease[player])
				else
					good[#good + 1] = coloredNameVersion(player, usersRelease[player])
				end
			elseif usersUnknown[player] then
				ugly[#ugly + 1] = coloredNames[player]
			elseif usersAlpha[player] then
				-- If this person's alpha version isn't SVN (-1) and it's higher or the same as the highest found release version minus 1 because
				-- of tagging, or it's higher or the same as the highest found alpha version (with a 10 revision leeway) then that person's good
				if (usersAlpha[player] >= (highestReleaseRevision - 1) and usersAlpha[player] >= (highestAlphaRevision - 10)) or usersAlpha[player] == -1 then
					good[#good + 1] = coloredNameVersion(player, usersAlpha[player], ALPHA)
				else
					ugly[#ugly + 1] = coloredNameVersion(player, usersAlpha[player], ALPHA)
				end
			else
				bad[#bad + 1] = coloredNames[player]
			end
		end
		if #good > 0 then print(L["Up to date:"], unpack(good)) end
		if #ugly > 0 then print(L["Out of date:"], unpack(ugly)) end
		if #bad > 0 then print(L["No Big Wigs 3.x:"], unpack(bad)) end
		good, bad, ugly = nil, nil, nil
	end

	SLASH_BIGWIGSVERSION1 = "/bwv"
	SlashCmdList.BIGWIGSVERSION = showVersions
end

-----------------------------------------------------------------------
-- Interface options
--
do
	local frame = CreateFrame("Frame", nil, UIParent)
	frame.name = "Big Wigs"
	frame:Hide()
	local function removeFrame()
		for k, f in next, INTERFACEOPTIONS_ADDONCATEGORIES do
			if f == frame then
				tremove(INTERFACEOPTIONS_ADDONCATEGORIES, k)
				break
			end
		end
	end
	frame:SetScript("OnShow", function()
		removeFrame()
		loadCoreAndOpenOptions()
	end)

	if AddonLoader and AddonLoader.RemoveInterfaceOptions then
		AddonLoader:RemoveInterfaceOptions("Big Wigs")
	end
	InterfaceOptions_AddCategory(frame)
	loader.RemoveInterfaceOptions = removeFrame
end

