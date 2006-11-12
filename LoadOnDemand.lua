
------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsLoD")

local withcore = {}
local inzone = {}

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
			self:Print( "Loading addon: "..v )
			LoadAddOn( v )
		end
	end	

	withcore = {}

	-- Fire an event to have the target monitor check it's stuff
	self:TriggerEvent("BigWigs_ModulePackLoaded")
end

function BigWigsLoD:ZONE_CHANGED_NEW_AREA()
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
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadWithCore")
			if meta then
				-- register this addon for loading with core
				table.insert( withcore, i )
			end
		end
	end
end
