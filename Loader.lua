-- This whole deal is pretty much a straight copy frmo the old BigWigs2 LoadOnDemand, with some subtle changes.
-- main change is no requirement for babbleboss/zone for enUS and enGB locale

--[[ DOCUMENTATION

Loading Order:

BigWigs packed
	Loader:OnInit
	BW:OnInit
	.. packed module oninits ..
	... possible module oninits that were loaded due to CoreLoaded....
	Loader:OnEnable
	BW:OnEnable -- only called if needed

	
BigWigs unpacked
	Loader:OnInit
	Loader:OnEnable
	.. user enters a party or enables BW3 in another way
	BW:OnInit
	... possible module onInits that were loaded due to CoreLoaded....
	BW:OnEnable -- only called if needed
	
	
BigWigs:OnInitialize fires BigWigs_CoreLoaded message as its last action


Conditions:

The loader will load/enable the core when certain conditions are met
- Player enters party -> zone of player is checked -> load -> enable
- Player is in a party -> zone of player is checked on ZONE_CHANGED -> load -> enable

--]]

local pName = UnitName("player")
local ALPHA = "ALPHA"
local RELEASE = "RELEASE"

do
	-- XXX localize these? We'll see.
	local L_RELEASE = "You are running an official release of Big Wigs 3.0 (revision %d)"
	local L_ALPHA = "You are running an ALPHA RELEASE of Big Wigs 3.0 (revision %d)"
	local L_SOURCE = "You are running a source checkout of Big Wigs 3.0 directly from the repository."

	-- START: MAGIC WOWACE VOODOO VERSION STUFF
	local releaseType = RELEASE
	local releaseRevision = nil
	local releaseString = nil
	--@alpha@
	-- The following code will only be present in alpha ZIPs.
	releaseType = ALPHA
	--@end-alpha@

	-- This will (in ZIPs), be replaced by the highest revision number in the source tree.
	releaseRevision = "@project-revision@"
	releaseRevision = tonumber(releaseRevision)

	-- If the releaseRevision ends up NOT being a number, it means we're running a SVN copy.
	-- In which case, we also have to set the releaseType to ALPHA manually.
	if type(releaseRevision) ~= "number" then
		releaseRevision = -1
		releaseType = ALPHA
	end

	-- Then build the release string, which we can add to the interface option panel.
	if releaseRevision == -1 then
		releaseString = L_SOURCE
	elseif releaseType == RELEASE then
		releaseString = L_RELEASE:format(releaseRevision)
	elseif releaseType == ALPHA then
		releaseString = L_ALPHA:format(releaseRevision)
	end
	_G.BIGWIGS_RELEASE_TYPE = releaseType
	_G.BIGWIGS_RELEASE_REVISION = releaseRevision
	_G.BIGWIGS_RELEASE_STRING = releaseString
	-- END:   MAGIC WOWACE VOODOO VERSION STUFF
end

BigWigsLoader = LibStub("AceAddon-3.0"):NewAddon("BigWigsLoader", "AceEvent-3.0")
local loader = BigWigsLoader

local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs")

local ldb

-- locals
local BWRAID = 2
local BWPARTY = 1
local grouped = nil

local BZ -- BabbleZone-3.0 lookup table, will only be used if the foreign language pack is loaded aka LBZ-3.0 and LBB-3.0
local BB -- BabbleBoss-3.0 lookup table, will only be used if the foreign language pack is loaded aka LBZ-3.0 and LBB-3.0

local loadOnCoreEnabled = {} -- BigWigs modulepacks that should load when a hostile zone is entered or the core is manually enabled, this would be the default plugins Bars, Messages etc
local loadInZone = {} -- BigWigs modulepack that should load on a specific zone
local loadOnCoreLoaded = {} -- BigWigs modulepacks that should load when the core is loaded

local menus = {} -- contains the main menus for BigWigs, once the core is loaded they will get injected

local enableZones = {} -- contains the zones in which BigWigs will enable

local LOCALE = GetLocale()
if LOCALE == "enGB" then
	LOCALE = "enUS"
end

-- XXX Not sure if this should be here or in Extras\Version, we need to flesh out how to work this version check thing.
-- XXX If it remains here it'll be added to the BigWigs locale files in the end.
local L_OLD_VERSION = "There is a new release of Big Wigs available. You can visit curse.com, wowinterface.com, wowace.com or use the Curse Updater to get the new release."
if LOCALE == "deDE" then
	-- L_OLD_VERSION = ...
elseif LOCALE == "frFR" then
	-- L_OLD_VERSION = ...
--elseif etc...
end

local function loadZone(zone)
	if not zone then return end
	if loadInZone[zone] then
		local addonsLoaded = {}
		for i, v in next, loadInZone[zone] do
			if not IsAddOnLoaded(v) then
				LoadAddOn(v)
				loader:SendMessage("BigWigs_ModulePackLoaded", v)
			end
			table.insert(addonsLoaded, v)
			loadInZone[zone][i] = nil
		end
		if #loadInZone[zone] == 0 then
			loadInZone[zone] = nil
		end

		-- Remove all already loaded addons from the loadInZone table so that
		-- the "Load all" options for the zone menus that are affected by these
		-- addons are hidden.
		for i, addon in next, addonsLoaded do
			for k in pairs(loadInZone) do
				for j, z in next, loadInZone[k] do
					if z == addon or IsAddOnLoaded(z) then
						loadInZone[k][j] = nil
					end
				end
				if #loadInZone[k] == 0 then
					loadInZone[k] = nil
				end
			end
			addonsLoaded[i] = nil
		end
		addonsLoaded = nil
	end
end

local function registerEnableZone(zone, groupsize)
	if type(zone) == "string" then
		if BZ then zone = BZ[zone] or zone end
		-- only update enablezones if content is of lower level than before.
		-- if someone adds a party module to a zone that is already in the table as a raid, set the level of that zone to party
		if not enableZones[zone] or (enableZones[zone] and enableZones[zone] > groupsize) then
			enableZones[zone] = tonumber(groupsize) -- needs to be a number.
		end
	elseif type(zone) == "table" then
		for _,z in pairs(zone) do
			registerEnableZone(z, groupsize)
		end
	end
end

local function iterateZones(addon, override, partyContent, ...)
	for i = 1, select("#", ...) do
		local zone = (select(i, ...)):trim()

		-- register the zone for enabling.
		registerEnableZone(zone, partyContent and BWPARTY or BWRAID)
		
		if not loadInZone[zone] then loadInZone[zone] = {} end
		table.insert(loadInZone[zone], addon)

		if override then
			table.insert(loadInZone[override], addon)
		else
			menus[zone] = true
		end
	end
end
local zoneAddon = {}
function loader:OnInitialize()
	local numAddons = GetNumAddOns()
	
	for i = 1, numAddons do
		local name, _, _, enabled = GetAddOnInfo(i)
		if enabled and not IsAddOnLoaded(i) and IsAddOnLoadOnDemand(i) then
			local meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-CoreEnabled")
			if meta then -- this pack wants to be loaded when we enable the core
				table.insert(loadOnCoreEnabled, name)
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-CoreLoaded")
			if meta then
				table.insert(loadOnCoreLoaded, name)
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-Zone")
			if meta then
				table.insert(zoneAddon, name)
			end
		end
	end
	
	-- register for these messages OnInit so we receive these messages when the core and modules oninitialize fires
	self:RegisterMessage("BigWigs_BossModuleRegistered")
	self:RegisterMessage("BigWigs_CoreLoaded")

	local icon = LibStub("LibDBIcon-1.0", true)
	if icon then
		if not BigWigs3IconDB then BigWigs3IconDB = {} end
		icon:Register("BigWigs", ldb, BigWigs3IconDB)
	end
end

function loader:OnEnable()
	self:LoadForeign()
	-- From this point onward BZ and BB should be available for non-english locales
	if zoneAddon then
		for k, name in pairs(zoneAddon) do
			meta = GetAddOnMetadata(name, "X-BigWigs-LoadOn-Zone")
			local menu = GetAddOnMetadata(name, "X-BigWigs-Menu")
			if menu then
				if BZ then menu = BZ[menu] or menu end
				if not loadInZone[menu] then loadInZone[menu] = {} end
				menus[menu] = true
			end
			local partyContent = GetAddOnMetadata(name, "X-BigWigs-PartyContent")
			iterateZones(name, menu, partyContent, strsplit(",", meta))
		end
		zoneAddon = nil -- garbage collect
	end

	self:RegisterEvent("ZONE_CHANGED", "ZoneChanged")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChanged")
	self:RegisterEvent("RAID_ROSTER_UPDATE", "CheckRoster")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED", "CheckRoster")
	
	self:RegisterEvent("CHAT_MSG_ADDON")
	
	self:RegisterMessage("BigWigs_JoinedGroup", "ZoneChanged")
	self:RegisterMessage("BigWigs_LeftGroup")
	self:RegisterMessage("BigWigs_CoreEnabled")
	self:RegisterMessage("BigWigs_CoreDisabled")
	
	self:CheckRoster()
	self:ZoneChanged()
end

--[[
-- XXX We need to discuss and resolve the whole version checking thing before "first" release.
-- Basically many people want the ability to see if anyone in their raid is not running BW
-- at all. Personally I say this is too nazi, but it's very often requested and moaned about.
-- The code below won't really let you do that.
--
-- So we have to decide on a message protocol for everything and what we should allow and not.
--]]
function loader:CHAT_MSG_ADDON(event, prefix, message, distribution, sender)
	if prefix == "BWVQ3" then
		if BIGWIGS_RELEASE_TYPE == ALPHA then return end
		SendAddonMessage("BWVR3", BIGWIGS_RELEASE_REVISION, distribution)
	elseif prefix == "BWOOD3" then
		if not tonumber(message) then return end
		if tonumber(message) > BIGWIGS_RELEASE_REVISION then
			-- We're running an old version.
			-- No point in listening any more.
			self:UnregisterEvent("CHAT_MSG_ADDON")
			print(L_OLD_VERSION)
		end
	elseif prefix == "BWVR3" and sender ~= pName then
		if not tonumber(message) then return end
		if BIGWIGS_RELEASE_REVISION > tonumber(message) then
			-- The sender is running an old version.
			SendAddonMessage("BWOOD3", BIGWIGS_RELEASE_REVISION, "WHISPER", sender)
		end
	end
end

function loader:Print(...)
	print("|cff33ff99BigWigsLoader|r:", ...)
end

local tooltipFunctions = {}
function loader:RegisterTooltipInfo(func)
	for i, v in next, tooltipFunctions do
		if v == func then
			error(("The function %q has already been registered."):format(func))
		end
	end
	table.insert(tooltipFunctions, func)
end

function loader:LoadZone(zone)
	loadZone(zone)
end

function loader:ZoneChanged()
	if not grouped then return end
	local z1, z2 = GetRealZoneText(), GetZoneText()
	-- load party content in raid, but don't load raid content in a party...
	if (enableZones[z1] and enableZones[z1] <= grouped) or (enableZones[z2] and enableZones[z2] <= grouped) then
		if self:LoadCore() then
			if BigWigs:IsEnabled() and (loadInZone[z1] or loadInZone[z2]) then
				loadZone(z1)
				loadZone(z2)
			else
				BigWigs:Enable()
			end
		end
	end	
end

function loader:CheckRoster()
	local raid = GetNumRaidMembers()
	local party = GetNumPartyMembers()
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
	if module and module.zoneName then
		registerEnableZone(module.zoneName, module.partyContent and BWPARTY or BWRAID)
	end	
end

function loader:BigWigs_CoreEnabled()
	if ldb then
		ldb.icon = "Interface\\AddOns\\BigWigs\\Icons\\core-enabled"
	end
	
	for k, v in pairs(loadOnCoreEnabled) do
		if not IsAddOnLoaded(v) then LoadAddOn(v) end
		loadOnCoreEnabled[k] = nil
	end
	-- core is enabled, unconditionally load the zones
	loadZone(GetRealZoneText())
	loadZone(GetZoneText())	
end

function loader:BigWigs_CoreDisabled()
	if ldb then
		ldb.icon = "Interface\\AddOns\\BigWigs\\Icons\\core-disabled"
	end
end


function loader:BigWigs_CoreLoaded()
	for k, v in pairs(loadOnCoreLoaded) do
		if not IsAddOnLoaded(v) then LoadAddOn(v) end
		loadOnCoreLoaded[k] = nil
	end
	-- FIXME: do sometihng with this?
	BigWigs:SetZoneMenus(menus)
end

function loader:BigWigs_LeftGroup()
	-- BigWigs might not have loaded yet, fringe case, but better prevent errors
	if BigWigs then
		BigWigs:Disable()
	end
end

function loader:LoadCore()
	if BigWigs or LibStub("AceAddon-3.0"):GetAddon("BigWigs", true) then return true end -- return true, so if self:LoadCore() checks work properly
	-- time to load the core
	local core = "BigWigs_Core"
	-- Verify that the addon isn't disabled
	local enabled = select(4, GetAddOnInfo(core))
	if not enabled then 
		self:Print("Error loading " .. core .. " ("..core.." is not enabled)")
		return
	end
	-- Load the addon
	local succ, err = LoadAddOn(core)
	if not succ then
		self:Print("Error loading " .. core .. " (" .. err .. ")")
		return false, err
	end
	return true
end

function loader:LoadForeign()
	if LOCALE == "enUS" or ( BB and BZ ) then return true end
	if not LibStub("LibBabble-Boss-3.0", true) or not LibStub("LibBabble-Zone-3.0", true) then
		local core = "BigWigs_Foreign"
		local enabled = select(4, GetAddOnInfo(core))
		if not enabled then 
			self:Print("Error loading " .. core .. " ("..core.." is not enabled)")
			return
		end
		local succ, err = LoadAddOn(core)
		if not succ then
			self:Print("Error loading " .. core .. " (" .. tostring(err) .. ")")
		end
	end
	-- check again and error if you can't find
	if not LibStub("LibBabble-Zone-3.0", true) or not LibStub("LibBabble-Boss-3.0", true) then
		self:Print("Error retrieving LibBabble-Zone-3.0 and LibBabble-Boss-3.0, please reinstall BigWigs")
	else
		BZ = LibStub("LibBabble-Zone-3.0"):GetUnstrictLookupTable()
		BB = LibStub("LibBabble-Boss-3.0"):GetUnstrictLookupTable()
	end
end

ldb = LibStub("LibDataBroker-1.1"):GetDataObjectByName("BigWigs")

if not ldb then
	ldb = LibStub("LibDataBroker-1.1"):NewDataObject("BigWigs", {
		type = "launcher",
		label = "Big Wigs",
		icon = "Interface\\AddOns\\BigWigs\\Icons\\core-disabled",
	})
else
	ldb.label = "Big Wigs"
end
loader.ldb = ldb

function ldb.OnClick(self, button)
	local bw3 = BigWigs or LibStub("AceAddon-3.0"):GetAddon("BigWigs", true)
	if bw3 and bw3:IsEnabled() then
		if button == "RightButton" then
			BigWigsOptions:Open()
		else
			if IsAltKeyDown() then
				if IsControlKeyDown() then
					bw3:Disable()
				else
					for name, module in bw3:IterateBossModules() do
						if module:IsEnabled() then
							module:Disable()
						end
					end
					bw3:Print(L["All running modules have been disabled."])
				end
			else
				for name, module in bw3:IterateBossModules() do
					if module:IsEnabled() then
						bw3:BigWigs_RebootModule(nil, module)
					end
				end
				bw3:Print(L["All running modules have been reset."])
			end
		end
	elseif bw3 then
		bw3:Enable()
		if button == "RightButton" then
			BigWigsOptions:Open()
		end
	elseif loader:LoadCore() then
		BigWigs:Enable()
		if button == "RightButton" then
			BigWigsOptions:Open()
		end
	end
end

function ldb.OnTooltipShow(tt)
	tt:AddLine("Big Wigs")
	local h = nil
	local bw3 = BigWigs or LibStub("AceAddon-3.0"):GetAddon("BigWigs", true)
	if bw3 and bw3:IsEnabled() then
		local added = nil
		for name, module in bw3:IterateBossModules() do
			if module:IsEnabled() then
				if not added then
					tt:AddLine(L["Active boss modules:"], 1, 1, 1)
					added = true
				end
				tt:AddLine(module.displayName)
			end
		end
		h = L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."]
	else
		tt:AddLine(L["Big Wigs is currently disabled."])
		h = L["|cffeda55fClick|r to enable."]
	end
	for i, v in next, tooltipFunctions do
		v(tt)
	end
	tt:AddLine(h, 0.2, 1, 0.2, 1)
end

local function slashfunction(text)
	if loader:LoadCore() then
		BigWigsOptions:Open()
	end
end


hash_SlashCmdList['/bw'] = nil
hash_SlashCmdList['/bigwigs'] = nil
SLASH_BIGWIGSS1 = "/bw"
SLASH_BIGWIGSS2 = "/bigwigs"
SlashCmdList.BIGWIGSS = slashfunction

-- interface options
local frame = CreateFrame("Frame", nil, UIParent)
frame.name = "Big Wigs"
frame:Hide()

frame:SetScript("OnShow", function(frame)
	for k, f in next, INTERFACEOPTIONS_ADDONCATEGORIES do
		if f == frame then
			tremove(INTERFACEOPTIONS_ADDONCATEGORIES, k)
			break
		end
	end
	if loader:LoadCore() then
		BigWigs:Enable()
		BigWigsOptions:Open()
	end
end)

if AddonLoader and AddonLoader.RemoveInterfaceOptions then
	AddonLoader:RemoveInterfaceOptions("Big Wigs")
end
InterfaceOptions_AddCategory(frame)

function loader:RemoveInterfaceOptions()
	for k, f in next, INTERFACEOPTIONS_ADDONCATEGORIES do
		if f == frame then
			tremove(INTERFACEOPTIONS_ADDONCATEGORIES, k)
			break
		end
	end
end

