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

local loadOnCoreEnabled = {} -- BigWigs3 modulepacks that should load when a hostile zone is entered or the core is manually enabled, this would be the default plugins Bars, Messages etc
local loadInZone = {} -- BigWigs3 modulepack that should load on a specific zone
local loadOnCoreLoaded = {} -- BigWigs3 modulepacks that should load when the core is loaded
local loadForeign = {} -- BigWigs3 foreign language packs

local menus = {} -- contains the main menus for BigWigs3, once the core is loaded they will get injected

local enableZones = {} -- contains the zones in which BigWigs3 will enable

local LOCALE = GetLocale()
if LOCALE == "enGB" then
	LOCALE = "enUS"
end

local function loadZone(zone)
	if loadInZone[zone] then
		local addonsLoaded = {}
		for i, v in ipairs(loadInZone[zone]) do
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
		for i, addon in ipairs(addonsLoaded) do
			for k in pairs(loadInZone) do
				for j, z in ipairs(loadInZone[k]) do
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

function loader:OnInitialize()
	local numAddons = GetNumAddOns()
	local zoneAddon = {}
	for i = 1, numAddons do
		local name, _, _, enabled = GetAddOnInfo(i)
		if enabled and not IsAddOnLoaded(i) and IsAddOnLoadOnDemand(i) then
			local meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-CoreEnabled")
			if meta then -- this pack wants to be loaded when we enable the core
				table.insert(loadOnCoreEnabled, name)
			end
			if LOCALE ~= "enUS" then -- only do something with foreign stuff if we really need to, yay no BabbleBoss and Zone for english users!
				meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-Foreign")
				if meta then LoadAddOn(name) end -- imediately load that stuff, this WILL trigger another ADDON_LOADED, which is NO issue when BigWigs3 is fully packed or unpacked.
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-CoreLoaded")
			if meta then
				table.insert(loadOnCoreLoaded, name)
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadIn-Zone")
			if meta then
				table.insert(zoneAddon, name)
			end
		end
	end
	if LOCALE ~= "enUS" then
		BZ = LibStub("LibBabble-Zone-3.0"):GetLookupTable()
		BB = LibStub("LibBabble-Boss-3.0"):GetLookupTable()
	end
	-- From this point onward BZ and BB should be available for non-english locales
	for k, name in pairs(zoneAddon) do
		meta = GetAddOnMetadata(name, "X-BigWigs-LoadIn-Zone")
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
	
	-- register for these messages OnInit so we receive these messages when the core and modules oninitialize fires
	self:RegisterMessage("BigWigs_BossModuleRegistered")
	self:RegisterMessage("BigWigs_CoreLoaded")
end

function loader:OnEnable()
	self:RegisterEvent("ZONE_CHANGED", "ZoneChanged")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChanged")
	self:RegisterEvent("RAID_ROSTER_UPDATE", "CheckRoster")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED", "CheckRoster")
	
	self:RegisterMessage("BigWigs_JoinedGroup", "ZoneChanged")
	self:RegisterMessage("BigWigs_LeftGroup")
	self:RegisterMessage("BigWigs_CoreEnabled")
	self:RegisterMessage("BigWigs_CoreDisabled")
	
	self:CheckRoster()
	self:ZoneChanged()
end

function loader:Print(...)
	print("|cff33ff99BigWigsLoader|r:", ...)
end

local tooltipFunctions = {}
function loader:RegisterTooltipInfo(func)
	for i, v in ipairs(tooltipFunctions) do
		if v == func then
			error(("The function %q has already been registered."):format(func))
		end
	end
	table.insert(tooltipFunctions, func)
end


function loader:ZoneChanged()
	if not grouped then return end
	local z1, z2 = GetRealZoneText(), GetZoneText()
	-- load party content in raid, but don't load raid content in a party...
	if (enableZones[z1] and enableZones[z1] <= grouped) or (enableZones[z2] and enableZones[z2] <= grouped) then
		if self:LoadCore() then
			if BigWigs3:IsEnabled() and (loadInZone[z1] or loadInZone[z2]) then
				loadZone(z1)
				loadZone(z2)
			else
				BigWigs3:Enable()
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
	BigWigs3 = LibStub("AceAddon-3.0"):GetAddon("BigWigs")

	for k, v in pairs(loadOnCoreLoaded) do
		if not IsAddOnLoaded(v) then LoadAddOn(v) end
		loadOnCoreLoaded[k] = nil
	end
	
	-- FIXME: do sometihng with this?
	-- BigWigs:SetZoneMenus(menus)
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
	local core = "BigWigs3_Core"
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
	for i, v in ipairs(tooltipFunctions) do
		v(tt)
	end
	tt:AddLine(h, 0.2, 1, 0.2, 1)
end

local function slashfunction(text)
	if loader:LoadCore() then
		BigWigs:HandleSlashCommand(text)
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
	for k, f in ipairs(INTERFACEOPTIONS_ADDONCATEGORIES) do
		if f == frame then
			tremove(INTERFACEOPTIONS_ADDONCATEGORIES, k)
			break
		end
	end
	loader:LoadCore()
	BigWigsOptions:Open()
end)

if AddonLoader and AddonLoader.RemoveInterfaceOptions then
	AddonLoader:RemoveInterfaceOptions("Big Wigs")
end
InterfaceOptions_AddCategory(frame)

function loader:RemoveInterfaceOptions()
	for k, f in ipairs(INTERFACEOPTIONS_ADDONCATEGORIES) do
		if f == frame then
			tremove(INTERFACEOPTIONS_ADDONCATEGORIES, k)
			break
		end
	end
end