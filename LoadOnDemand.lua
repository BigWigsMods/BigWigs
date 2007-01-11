
------------------------------
--      Are you local?      --
------------------------------

local LC = AceLibrary("AceLocale-2.2"):new("BigWigs")
local BZ = AceLibrary("Babble-Zone-2.2")

local withcore = {}
local inzone = {}
local zonelist = {}

local function Split(str, sep)
	local x, y = str:find(sep) or 0, sep:len() or 1
	return tonumber(str:sub(1, x - 1)) or str:sub(1, x - 1), tonumber(str:sub(x + y)) or str:sub(x + y)
end

local function Explode(str, sep)
	local a, b = Split(str, sep)
	if not b or b == "" then return a:trim() end
	if not b:find(sep) then return a:trim(), b:trim() end
	return a:trim(), Explode(b, sep)
end

local function LoadBigWigsAddon(addon)
	if IsAddOnLoaded(addon) then return end

	local loaded, reason = LoadAddOn(addon)

	if not loaded and reason == "DEP_MISSING" then
		local deps = {GetAddOnDependencies(addon)}
		if not deps then return end
		for i, dep in ipairs(deps) do
			if not IsAddOnLoaded(dep) then LoadAddOn(dep) end
		end
		loaded, reason = LoadAddOn(addon)
	end
	return loaded
end

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
			if LoadBigWigsAddon(v) then
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
	if msg:find("^"..ERR_RAID_YOU_LEFT) then
		self:TriggerEvent("BigWigs_LeftGroup")
	elseif msg:find(ERR_RAID_YOU_JOINED) then
		self:TriggerEvent("BigWigs_JoinedGroup")
	end
end

function BigWigsLoD:BigWigs_JoinedGroup()
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
		if not IsAddOnLoaded(i) and IsAddOnLoadOnDemand(i) and enabled then
			local meta = GetAddOnMetadata(i, "X-BigWigs-LoadInZone")
			if meta then
				for k, v in pairs({Explode(meta, ",")}) do
					local zone = BZ:HasTranslation(v) and BZ[v] or nil
					if zone then
						if not inzone[zone] then inzone[zone] = {} end
						table.insert( inzone[zone], name)
						if LC:HasTranslation(v) then
							zonelist[zone] = true
						else
							if not zonelist[LC["Other"]] then zonelist[LC["Other"]] = {} end
							zonelist[LC["Other"]][zone] = true
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
	
	if zonelist[zone] then
		menu = LC:HasTranslation(zone) and LC[zone] or zone
	elseif zonelist[LC["Other"]] and zonelist[LC["Other"]][zone] then
		menu = LC["Other"]
	else
		return
	end

	if type(BigWigs.cmdtable.args[menu]) == "table" and type(BigWigs.cmdtable.args[menu].args) == "table" then
		BigWigs.cmdtable.args[menu].args[LC["Load"]] = nil
	end

	if type(zonelist[zone]) == "table" then
		for k, v in pairs( zonelist[zone] ) do
			self:LoadZone( k )
		end
	else
		if inzone[zone] then
			for k,v in pairs( inzone[zone] ) do
				if not IsAddOnLoaded( v ) then
					if LoadBigWigsAddon(v) then
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

