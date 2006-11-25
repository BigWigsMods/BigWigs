
------------------------------
--      Are you local?      --
------------------------------

local LC = AceLibrary("AceLocale-2.2"):new("BigWigs")
local BZ = AceLibrary("Babble-Zone-2.2")

local withcore = {}
local inzone = {}
local zonelist = {}

local function Split(str, sep)
	local x, y = string.find(str, sep) or 0, string.len(sep) or 1
	return tonumber(string.sub(str, 1, x - 1)) or string.sub(str, 1, x - 1), tonumber(string.sub(str, x + y)) or string.sub(str, x + y)
end

local function Trim(str)
	str = string.gsub(str, "^%s*", "")
	str = string.gsub(str, "%s*$", "")
	return str
end

local function Explode(str, sep)
	local a, b = Split(str, sep)
	if not b or b == "" then return Trim(a) end
	if not string.find(b, sep) then return Trim(a), Trim(b) end
	return Trim(a), Explode(b, sep)
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

	local loaded = false
	for k,v in pairs( withcore ) do
		if not IsAddOnLoaded( v ) then
			loaded = true
			LoadAddOn( v )
		end
	end

	withcore = {}

	-- Fire an event to have the target monitor check its stuff
	if loaded then
		self:TriggerEvent("BigWigs_ModulePackLoaded")
	end
end

function BigWigsLoD:ZONE_CHANGED_NEW_AREA()
	self:LoadZone( GetRealZoneText() )
end

function BigWigsLoD:CHAT_MSG_SYSTEM( msg )
	if string.find(msg, "^"..ERR_RAID_YOU_LEFT) then
		self:TriggerEvent("BigWigs_LeftGroup")
	elseif string.find(msg, ERR_RAID_YOU_JOINED) then
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
		if not IsAddOnLoaded(i) and IsAddOnLoadOnDemand(i) then
			local meta = GetAddOnMetadata(i, "X-BigWigs-LoadInZone")
			if meta then
				local ignorezone = string.find( meta, LC["Outdoor Raid Bosses Zone"] )
				for k, v in pairs({Explode(meta, ",")}) do
					local zone
					if BZ:HasTranslation(v) then zone = BZ[v] end
					-- elseif LC:HasTranslation(v) then zone = LC[v] end
					if zone then
						if not inzone[zone] then inzone[zone] = {} end
						table.insert( inzone[zone], i)
						if not ignorezone then 
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
				table.insert( withcore, i )
			end
		end
	end
end

function BigWigsLoD:LoadZone( zone )
	if inzone[zone] then
		local loaded = false
		for k,v in pairs( inzone[zone] ) do
			if not IsAddOnLoaded( v ) then
				loaded = true
				LoadAddOn( v )
			end
		end
		inzone[zone] = nil
		zonelist[zone] = nil
		if loaded then
			self:TriggerEvent("BigWigs_ModulePackLoaded", zone)
		end
	end
end

function BigWigsLoD:GetZones()
	return zonelist
end

