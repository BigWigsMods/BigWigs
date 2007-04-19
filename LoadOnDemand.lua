
------------------------------
--      Are you local?      --
------------------------------

local LC = AceLibrary("AceLocale-2.2"):new("BigWigs")
local BZ = nil

local loadWithCore = nil
local loadInZone = {}

------------------------------
--    Addon Declaration     --
------------------------------

BigWigsLoD = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0")

------------------------------
--     Utility Functions    --
------------------------------

local function loadZone(zone)
	if loadInZone[zone] then
		local addonsLoaded = {}
		for i, v in ipairs( loadInZone[zone] ) do
			if not IsAddOnLoaded( v ) then
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
			handler = BigWigsLoD,
			func = loadZone,
			hidden = hide,
		}
	end
end

local function iterateZones(addon, override, ...)
	for i = 1, select("#", ...) do
		local z = (select(i, ...)):trim()
		local zone = BZ:HasTranslation(z) and BZ[z] or nil
		assert(zone, string.format("The zone %s, specified by the %s addon, does not exist in Babble-Zone.", z, addon))

		if not loadInZone[zone] then loadInZone[zone] = {} end
		table.insert( loadInZone[zone], addon)

		if override then
			table.insert( loadInZone[override], addon)
		else
			addCoreMenu(zone)
		end
	end
end

local function initialize()
	local numAddons = GetNumAddOns()
	for i = 1, numAddons do
		local name, _, _, enabled = GetAddOnInfo(i)
		if enabled and not IsAddOnLoaded(i) and IsAddOnLoadOnDemand(i) then
			local meta = GetAddOnMetadata(i, "X-BigWigs-LoadInZone")
			if meta then
				if not BZ then BZ = AceLibrary("Babble-Zone-2.2") end

				-- X-BW-Menu can override showing the modules in the
				-- modules own specified zone submenu
				local menu = GetAddOnMetadata(i, "X-BigWigs-Menu")
				if menu then
					assert(BZ:HasTranslation(menu), string.format("The menu key %s, specified by %s, does not exist in Babble-Zone.", menu, name))
					menu = BZ[menu]
					if not loadInZone[menu] then loadInZone[menu] = {} end

					-- Okay, so the addon wants to be put in a menu of
					-- its own, and not one directed by the module
					-- zones. This means we need a translation from BZ
					-- for the actual module name as well.

					addCoreMenu(menu)
					iterateZones(name, menu, strsplit(",", meta))
				else
					iterateZones(name, nil, strsplit(",", meta))
				end
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadWithCore")
			if meta then
				-- register this addon for loading with core
				if type(loadWithCore) ~= "table" then loadWithCore = {} end
				table.insert( loadWithCore, name )
			end
		end
	end
end

------------------------------
--      Initialization      --
------------------------------

function BigWigsLoD:OnInitialize()
	initialize()
end

function BigWigsLoD:OnEnable()
	self:RegisterEvent("BigWigs_CoreEnabled")

	self:RegisterEvent("ZONE_CHANGED", "ZoneChanged")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChanged")

	self:RegisterEvent("CHAT_MSG_SYSTEM")
	self:RegisterEvent("BigWigs_JoinedGroup")
	self:RegisterEvent("BigWigs_LeftGroup")

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
		local k, v
		for k, v in pairs( loadWithCore ) do
			if not IsAddOnLoaded( v ) then
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

function BigWigsLoD:ZoneChanged()
	if BigWigs:IsActive() then
		loadZone(GetRealZoneText())
		loadZone(GetZoneText())
	end
end

do
	local playerLeft = ERR_RAID_MEMBER_REMOVED_S:format(UnitName("player"))
	function BigWigsLoD:CHAT_MSG_SYSTEM( msg )
		if msg:find(ERR_RAID_YOU_LEFT) or msg:find(playerLeft) then
			self:TriggerEvent("BigWigs_LeftGroup")
		elseif msg:find(ERR_RAID_YOU_JOINED) then
			self:TriggerEvent("BigWigs_JoinedGroup")
		end
	end
end

function BigWigsLoD:BigWigs_JoinedGroup()
	BigWigs:ToggleActive(true)
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

