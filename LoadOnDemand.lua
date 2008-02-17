------------------------------
--      Are you local?      --
------------------------------

local LC = AceLibrary("AceLocale-2.2"):new("BigWigs")
local BZ = nil
local grouped = nil

local loadWithCore = nil
local loadInZone = {}
local enableZones = {}

local BWRAID = 2
local BWPARTY = 1

------------------------------
--    Addon Declaration     --
------------------------------

local BigWigsLoD = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0")

------------------------------
--     Utility Functions    --
------------------------------

local function loadZone(zone)
	if loadInZone[zone] then
		-- Set two globals to make it easier on the boss modules.
		if not _G.BZ then _G.BZ = LibStub("LibBabble-Zone-3.0"):GetLookupTable() end
		if not _G.BB then _G.BB = LibStub("LibBabble-Boss-3.0"):GetLookupTable() end
		local addonsLoaded = {}
		for i, v in ipairs(loadInZone[zone]) do
			if not IsAddOnLoaded(v) then
				if LoadAddOn(v) then
					BigWigsLoD:TriggerEvent("BigWigs_ModulePackLoaded", v)
				else
					BigWigsLoD:TriggerEvent("BigWigs_ModulePackLoaded", v, true)
				end
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

		-- Just collect garbage right away, since we will discard lots of unused
		-- translations.
		collectgarbage("collect")
	end
end

local function hide(zone)
	return not loadInZone[zone] or #loadInZone[zone] == 0
end

local function addCoreMenu(zone)
	local opt = BigWigs.cmdtable.args
	if not opt[zone] then
		opt[zone] = {
			type = "group",
			name = zone,
			desc = LC["Options for bosses in %s."]:format(zone),
			args = {},
			disabled = "~IsActive",
		}
	end
	if not opt[zone].args[LC["Load"]] then
		opt[zone].args[LC["Load"]] = {
			type = "execute",
			name = LC["Load All"],
			desc = LC["Load all %s modules."]:format(zone),
			order = 1,
			passValue = zone,
			func = loadZone,
			hidden = hide,
		}
	end
end

local function registerEnableZone(zone, groupsize)
	if type(zone) == "string" then
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
		local z = (select(i, ...)):trim()
		local zone = BZ[z]
		assert(zone, ("The zone %s, specified by the %s addon, does not exist in Babble-Zone."):format(z, addon))

		-- register the zone for enabling.
		registerEnableZone(zone, partyContent and BWPARTY or BWRAID)
		
		if not loadInZone[zone] then loadInZone[zone] = {} end
		table.insert(loadInZone[zone], addon)

		if override then
			table.insert(loadInZone[override], addon)
		else
			addCoreMenu(zone)
		end
	end
end

------------------------------
--      Initialization      --
------------------------------

function BigWigsLoD:OnInitialize()
	local numAddons = GetNumAddOns()
	for i = 1, numAddons do
		local name, _, _, enabled = GetAddOnInfo(i)
		if enabled and not IsAddOnLoaded(i) and IsAddOnLoadOnDemand(i) then
			local meta = GetAddOnMetadata(i, "X-BigWigs-LoadInZone")
			if meta then
				if not BZ then BZ = LibStub("LibBabble-Zone-3.0"):GetUnstrictLookupTable() end
				-- X-BW-Menu can override showing the modules in the
				-- modules own specified zone submenu
				local menu = GetAddOnMetadata(i, "X-BigWigs-Menu")
				if menu then
					assert(BZ[menu], ("The menu key %s, specified by %s, does not exist in Babble-Zone."):format(menu, name))
					menu = BZ[menu]
					if not loadInZone[menu] then loadInZone[menu] = {} end
					-- Okay, so the addon wants to be put in a menu of
					-- its own, and not one directed by the module
					-- zones. This means we need a translation from BZ
					-- for the actual module name as well.
					addCoreMenu(menu)
				end
				local partyContent = GetAddOnMetadata(i, "X-BigWigs-LoadInParty")
				iterateZones(name, menu, partyContent, strsplit(",", meta))
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadWithCore")
			if meta then
				-- register this addon for loading with core
				if type(loadWithCore) ~= "table" then loadWithCore = {} end
				table.insert(loadWithCore, name)
			end
		end
	end
end

function BigWigsLoD:OnEnable()
	self:RegisterEvent("BigWigs_CoreEnabled")

	self:RegisterEvent("ZONE_CHANGED", "ZoneChanged")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChanged")
	self:RegisterEvent("BigWigs_JoinedGroup", "ZoneChanged")

	self:RegisterEvent("BigWigs_LeftGroup")

	if AceLibrary:HasInstance("Roster-2.1") then
		self:RegisterEvent("RosterLib_RosterUpdated", "CheckRoster")
	else
		self:RegisterBucketEvent({"RAID_ROSTER_UPDATE", "PARTY_MEMBERS_CHANGED"}, 1, "CheckRoster")
	end

	self:RegisterEvent("BigWigs_ModuleRegistered")
	for name, module in BigWigs:IterateModules() do
		if module.zonename then
			registerEnableZone(module.zonename, module.partyContent and BWPARTY or BWRAID)
		end
	end

	if AceLibrary("AceEvent-2.0"):IsFullyInitialized() then
		self:ZoneChanged()
	else
		self:RegisterEvent("AceEvent_FullyInitialized", "ZoneChanged")
	end
end

------------------------------
--     Event Handlers       --
------------------------------

function BigWigsLoD:BigWigs_CoreEnabled()
	if type(loadWithCore) == "table" then
		-- Set two globals to make it easier on the boss modules.
		if not _G.BZ then _G.BZ = LibStub("LibBabble-Zone-3.0"):GetLookupTable() end
		if not _G.BB then _G.BB = LibStub("LibBabble-Boss-3.0"):GetLookupTable() end
		for k, v in pairs(loadWithCore) do
			if not IsAddOnLoaded(v) then
				if LoadAddOn(v) then
					self:TriggerEvent("BigWigs_ModulePackLoaded", v)
				else
					self:TriggerEvent("BigWigs_ModulePackLoaded", v, true)
				end
			end
			loadWithCore[k] = nil
		end
		-- This only happens once.
		loadWithCore = nil

		-- Just collect garbage right away, since we will discard lots of unused
		-- translations.
		collectgarbage("collect")
	end

	loadZone(GetRealZoneText())
	loadZone(GetZoneText())
end

function BigWigsLoD:BigWigs_ModuleRegistered(name)
	local mod = BigWigs:GetModule(name)
	if mod and mod.zonename then
		registerEnableZone(mod.zonename, mod.partyContent and BWPARTY or BWRAID)
	end
end

function BigWigsLoD:ZoneChanged()
	if not grouped then return end

	local z1, z2 = GetRealZoneText(), GetZoneText()
	-- load party content in raid, but don't load raid content in a party...
	if (enableZones[z1] and enableZones[z1] <= grouped) or (enableZones[z2] and enableZones[z2] <= grouped) then
		if BigWigs:IsActive() and (loadInZone[z1] or loadInZone[z2]) then
			loadZone(z1)
			loadZone(z2)
		else
			-- BigWigs_CoreEnabled will check and load the zones.
			BigWigs:ToggleActive(true)
		end
	end

end

function BigWigsLoD:CheckRoster()
	local raid = GetNumRaidMembers()
	local party = GetNumPartyMembers()
	if not grouped and raid > 0 then
		grouped = BWRAID
		self:TriggerEvent("BigWigs_JoinedGroup", grouped)
	elseif not grouped and party > 0 then
		grouped = BWPARTY
		self:TriggerEvent("BigWigs_JoinedGroup", grouped)
	elseif grouped then
		if grouped == BWPARTY and raid > 0 then
			grouped = BWRAID
			self:TriggerEvent("BigWigs_JoinedGroup", grouped)
		elseif raid == 0 and party == 0 then
			grouped = nil
			self:TriggerEvent("BigWigs_LeftGroup")
		end
	end
end

function BigWigsLoD:BigWigs_LeftGroup()
	BigWigs:ToggleActive(false)
end

------------------------------
--     API                  --
------------------------------

function BigWigsLoD:HasAddOnsForZone(zone)
	return loadInZone[zone] and true or nil
end

