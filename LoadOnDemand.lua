
------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsLoD")
local BZ = AceLibrary("Babble-Zone-2.2")

local withcore = {}
local inzone = {}

local function Split(string, sep)
	if (not string or type(string) ~= "string") then error("Bad String was a " .. type(string) .. "value: " .. (string or "nil"), 2) end
	local x, y = (strfind(string, sep) or 0), (strlen(sep) or 1)
	return (tonumber(strsub(string, 1, x-1)) or strsub(string, 1, x-1)), (tonumber(strsub(string, x+y)) or strsub(string, x+y))
end

local function Trim(str)
	str = gsub(str, "^%s*", "")
	str = gsub(str, "%s*$", "")
	return str
end

local function Explode(string, sep)
	if (not string) then return     end
	if (type(string) ~= "string") then error("Bad String was a " .. type(string) .. "value: " .. (string or "nil"), 2) end
	local a, b = Split(string, sep)
	if (not b or b == "") then return Trim(a) end
	if (not strfind(b, sep)) then return Trim(a), Trim(b) end
	return Trim(a), Explode(b, sep)
end


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
} end )

------------------------------
--    Addon Declaration     --
------------------------------

BigWigsLoD = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0")

------------------------------
--      Initialization      --
------------------------------

function BigWigsLoD:OnInitialize()
	self:InitializeLoD()
	self:RegisterEvent("BigWigs_CoreEnabled")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
end

------------------------------
--     Event Handlers       --
------------------------------

function BigWigsLoD:BigWigs_CoreEnabled()

	for k,v in pairs( withcore ) do
		if not IsAddOnLoaded( v ) then
			LoadAddOn( v )
		end
	end	

	withcore = {}

	-- Fire an event to have the target monitor check it's stuff
	self:TriggerEvent("BigWigs_ModulePackLoaded")
end

function BigWigsLoD:ZONE_CHANGED_NEW_AREA()
	local zone = GetRealZoneText()
	if inzone[zone] then
		for k,v in pairs( inzone[zone] ) do
			if not IsAddOnLoaded( v ) then
				LoadAddOn( v )
			end
		end
		inzone[zone] = nil
		self:TriggerEvent("BigWigs_ModulePackLoaded")
	end	
end

------------------------------
--     Utility Functions    --
------------------------------

function BigWigsLoD:InitializeLoD()
	for i = 1, GetNumAddOns() do
		if not IsAddOnLoaded(i) and IsAddOnLoadOnDemand(i) then
			local meta = GetAddOnMetadata(i, "X-BigWigs-LoadInZone")
			if meta then
				-- register this zone
				for k, v in {Explode(z, ",")} do
					local zone = BZ[v]
					if not inzone[zone] then inzone[zone] = {} end
					table.insert( inzone[zone], i)
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
