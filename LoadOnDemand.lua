
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
--      Initialization      --
------------------------------

function BigWigsLoD:OnInitialize()
	self:InitializeLoD()
end

function BigWigsLoD:OnEnable()
	self:RegisterEvent("BigWigs_CoreEnabled")

	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("CHAT_MSG_SYSTEM")
	self:RegisterEvent("BigWigs_JoinedGroup")
	self:RegisterEvent("BigWigs_LeftGroup")

	if AceLibrary("AceEvent-2.0"):IsFullyInitialized() then
		self:ZONE_CHANGED_NEW_AREA()
	else
		self:RegisterEvent("AceEvent_FullyInitialized", "ZONE_CHANGED_NEW_AREA")
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
	end

	self:LoadZone( GetRealZoneText() )
end

function BigWigsLoD:ZONE_CHANGED_NEW_AREA()
	if BigWigs:IsActive() then
		self:LoadZone( GetRealZoneText() )
	end
end

function BigWigsLoD:CHAT_MSG_SYSTEM( msg )
	if msg:find("^"..ERR_RAID_YOU_LEFT) or msg:find(string.format(ERR_RAID_MEMBER_REMOVED_S, UnitName("player"))) then
		self:TriggerEvent("BigWigs_LeftGroup")
	elseif msg:find(ERR_RAID_YOU_JOINED) then
		self:TriggerEvent("BigWigs_JoinedGroup")
	end
end

local battlegrounds = nil
local function InBattleground()
	if not battlegrounds then
		if not BZ then BZ = AceLibrary("Babble-Zone-2.2") end
		battlegrounds = {
			[BZ["Alterac Valley"]] = true,
			[BZ["Arathi Basin"]] = true,
			[BZ["Warsong Gulch"]] = true,
			[BZ["Nagrand Arena"]] = true,
			[BZ["Eye of the Storm"]] = true,
			[BZ["Blade's Edge Arena"]] = true,
		}
	end
	return battlegrounds[GetRealZoneText()] or battlegrounds[GetZoneText()] or nil
end

function BigWigsLoD:BigWigs_JoinedGroup()
	if InBattleground() then return end
	BigWigs:ToggleActive(true)
end

function BigWigsLoD:BigWigs_LeftGroup()
	BigWigs:ToggleActive(false)
end

------------------------------
--     Utility Functions    --
------------------------------

function BigWigsLoD:InitializeLoD()
	local numAddons = GetNumAddOns()
	local i, k, v
	for i = 1, numAddons do
		local name, _, _, enabled = GetAddOnInfo(i)
		if enabled and not IsAddOnLoaded(i) and IsAddOnLoadOnDemand(i) then
			local meta = GetAddOnMetadata(i, "X-BigWigs-LoadInZone")
			if meta then
				-- X-BW-Menu can override showing the modules in the
				-- modules own specified zone submenu
				local menu = GetAddOnMetadata(i, "X-BigWigs-Menu")
				local menuConsoleCommand = nil
				if menu then
					assert(LC:HasTranslation(menu), string.format("The menu key %s, specified by %s, does not exist in the core translation table.", menu, name))
					menuConsoleCommand = LC[menu]
				end

				for k, v in pairs({strsplit(",", meta)}) do
					v = v:trim()
					if not BZ then BZ = AceLibrary("Babble-Zone-2.2") end
					local zone = BZ:HasTranslation(v) and BZ[v] or nil
					assert(zone, string.format("The zone %s, specified by the %s addon, does not exist in Babble-Zone.", v, name))

					if not loadInZone[zone] then loadInZone[zone] = {} end
					table.insert( loadInZone[zone], name)
	
					if menuConsoleCommand then
						-- Okay, so the addon wants to be put in a menu of
						-- its own, and not one directed by the module
						-- zones. This means we need a translation from BZ
						-- for the actual module name as well.
						local guiKey = BZ:HasTranslation(menu) and BZ[menu] or nil
						assert(guiKey, string.format("%s's X-BigWigs-Menu (%s) has no translation available in Babble-Zone.", name, menu))
						self:AddCoreMenu(menuConsoleCommand, guiKey)
						if not loadInZone[guiKey] then loadInZone[guiKey] = {} end
						table.insert( loadInZone[guiKey], name)
					else
						-- consoleZone is basically the zonename we want to show
						-- in the console command options, like "MC" for Molten
						-- Core, for example.
						local consoleZone = LC:HasTranslation(zone) and LC[zone] or nil
						assert(consoleZone, string.format("%s's zone, %s, has no translation appropriate for console usage.", name, zone))
						self:AddCoreMenu(consoleZone, zone)
					end
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

function BigWigsLoD:LoadZone( zone )
	if loadInZone[zone] then
		local i, v, k, z, j, addon
		local addonsLoaded = {}
		for i, v in ipairs( loadInZone[zone] ) do
			if not IsAddOnLoaded( v ) then
				if LoadAddOn(v) then
					self:TriggerEvent("BigWigs_ModulePackLoaded", v)
				else
					self:TriggerEvent("BigWigs_ModulePackLoaded", v, true)
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
	end
end

function BigWigsLoD:AddCoreMenu(consoleCommand, guiCommand)
	local opt = BigWigs.cmdtable.args
	if not opt[consoleCommand] then
		opt[consoleCommand] = {
			type = "group",
			name = guiCommand,
			desc = string.format(LC["Options for bosses in %s."], guiCommand),
			args = {},
			disabled = function() return not BigWigs:IsActive() end,
		}
	end
	if not opt[consoleCommand].args[LC["Load"]] then
		opt[consoleCommand].args[LC["Load"]] = {
			type = "execute",
			name = LC["Load All"],
			desc = string.format( LC["Load all %s modules."], guiCommand ),
			order = 1,
			func = function() BigWigsLoD:LoadZone( guiCommand ) end,
			hidden = function() return not loadInZone[guiCommand] or #loadInZone[guiCommand] == 0 end,
		}
	end
end

