local UlduarBeta = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceEvent-2.0")
local warnedThisSession = nil

function UlduarBeta:OnEnable()
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	if GetRealZoneText() == BZ["Ulduar"] then
		self:ZONE_CHANGED_NEW_AREA()
	end
end

function UlduarBeta:ZONE_CHANGED_NEW_AREA()
	if GetRealZoneText() ~= BZ["Ulduar"] or warnedThisSession then return end
	warnedThisSession = true
	self:Print("The BigWigs boss modules for Ulduar are in Beta! Timers may be wrong and bugs may appear!")
	self:Print("Please refer to the forum page at http://forums.wowace.com/showthread.php?t=1797")
	self:Print("for info on how you can help us!")
end
