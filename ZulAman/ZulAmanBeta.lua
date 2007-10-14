ZulAmanBeta = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceEvent-2.0")

local BZ = AceLibrary("Babble-Zone-2.2")
local warnedThisSession = nil

function ZulAmanBeta:OnEnable()
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	if GetRealZoneText() == BZ["Zul'Aman"] then
		self:ZONE_CHANGED_NEW_AREA()
	end
end

function ZulAmanBeta:ZONE_CHANGED_NEW_AREA()
	if GetRealZoneText() ~= BZ["Zul'Aman"] or warnedThisSession then return end
	warnedThisSession = true
	self:Print("The BigWigs boss modules for Zul'Aman are in Beta! Timers may be wrong and bugs may appear!")
end
