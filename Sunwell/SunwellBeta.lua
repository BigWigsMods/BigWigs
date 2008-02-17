local SunwellBeta = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceEvent-2.0")

local warnedThisSession = nil

function SunwellBeta:OnEnable()
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	if GetRealZoneText() == BZ["Sunwell Plateau"] then
		self:ZONE_CHANGED_NEW_AREA()
	end
end

function SunwellBeta:ZONE_CHANGED_NEW_AREA()
	if GetRealZoneText() ~= BZ["Sunwell Plateau"] or warnedThisSession then return end
	warnedThisSession = true
	self:Print("The BigWigs boss modules for Sunwell are in Beta! Timers may be wrong and bugs may appear!")
	self:Print("Please refer to the forum page at http://www.wowace.com/forums/index.php?topic=11354")
	self:Print("for info on how you can help us!")
end
