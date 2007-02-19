
------------------------------
--      Are you local?      --
------------------------------

local LC = AceLibrary("AceLocale-2.2"):new("BigWigs")
local BZ = nil

local withcore = {}
local inzone = {}
local zonelist = {}

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
	for k,v in pairs( withcore ) do
		if not IsAddOnLoaded( v ) then
			if LoadAddOn(v) then
				self:TriggerEvent("BigWigs_ModulePackLoaded", v)
			else
				self:TriggerEvent("BigWigs_ModulePackLoaded", v, true)
			end
		end
	end

	withcore = {}

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
	for i = 1, numAddons do
		local name, _, _, enabled = GetAddOnInfo(i)
		if enabled and not IsAddOnLoaded(i) and IsAddOnLoadOnDemand(i) then
			local meta = GetAddOnMetadata(i, "X-BigWigs-LoadInZone")
			if meta then
				for k, v in pairs({strsplit(",", meta)}) do
					v = v:trim()
					if not BZ then BZ = AceLibrary("Babble-Zone-2.2") end
					local zone = BZ:HasTranslation(v) and BZ[v] or nil
					if zone then
						if not inzone[zone] then inzone[zone] = {} end
						table.insert( inzone[zone], name)
						if LC:HasTranslation(v) then
							zonelist[zone] = true
							self:AddCoreMenu(zone)
						else
							local menu = GetAddOnMetadata(i, "X-BigWigs-Menu")
							assert(menu, string.format("%s either need to have a direct link to the core translation table or X-BigWigs-Menu set.", name))
							local translatedMenu = LC[menu]
							assert(translatedMenu, string.format("No translation exists for the menu key %s from %s.", menu, name))
							if not zonelist[translatedMenu] then zonelist[translatedMenu] = {} end
							zonelist[translatedMenu][zone] = true
							self:AddCoreMenu(translatedMenu)
						end
					end
				end
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadWithCore")
			if meta then
				-- register this addon for loading with core
				table.insert( withcore, name )
			end
		end
	end
end

function BigWigsLoD:LoadZone( zone )

	-- Remove the "Load All" menu item from the core option table.
	local menu = zone
	
	if not zonelist[zone] then
		for k, v in pairs(zonelist) do
			if type(v) == "table" and v[zone] then
				menu = k
			end
		end
	end

	local opt = BigWigs.cmdtable.args[menu]
	if type(opt) == "table" and type(opt.args) == "table" then
		opt.args[LC["Load"]] = nil
	end

	if type(zonelist[zone]) == "table" then
		for k, v in pairs( zonelist[zone] ) do
			self:LoadZone( k )
		end
	else
		if inzone[zone] then
			for k,v in pairs( inzone[zone] ) do
				if not IsAddOnLoaded( v ) then
					if LoadAddOn(v) then
						self:TriggerEvent("BigWigs_ModulePackLoaded", v)
					else
						self:TriggerEvent("BigWigs_ModulePackLoaded", v, true)
					end
				end
			end
			inzone[zone] = nil
			zonelist[zone] = nil
			if loaded then
				self:TriggerEvent("BigWigs_ModulePackLoaded", zone)
			end
		end
	end
end

function BigWigsLoD:GetZones()
	return zonelist
end

-- AddCoreMenu gets passed the translated zonename for the menu.
function BigWigsLoD:AddCoreMenu( zone )
	if not zone then return end
	local opt = BigWigs.cmdtable.args
	if not opt[zone] then
		opt[zone] = {
			type = "group",
			name = zone,
			desc = string.format(LC["Options for bosses in %s."], zone),
			args = {},
			disabled = function() return not BigWigs:IsActive() end,
		}
	end
	if not opt[zone].args[LC["Load"]] then
		opt[zone].args[LC["Load"]] = {
			type = "execute",
			name = LC["Load All"],
			desc = string.format( LC["Load all %s modules."], zone ),
			order = 1,
			func = function() BigWigsLoD:LoadZone( zone ) end,
		}
	end
end

