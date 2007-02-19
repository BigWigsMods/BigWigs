SCBeta = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceEvent-2.0")

local BZ = AceLibrary("Babble-Zone-2.2")
local warnedThisSession = nil

function SCBeta:OnEnable()
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	if GetRealZoneText() == BZ["Coilfang Reservoir"] then
		self:ZONE_CHANGED_NEW_AREA()
	end
end

function SCBeta:ZONE_CHANGED_NEW_AREA()
	if GetRealZoneText() ~= BZ["Coilfang Reservoir"] or warnedThisSession then return end
	warnedThisSession = true
	if not IsAddOnLoaded("Transcriptor") then
		self:Print("The BigWigs boss modules for Serpentshrine Cavern are not complete yet, by far, and we need your help.")
		self:Print("Please download and install Transcriptor from http://files.wowace.com/Transcriptor/")
		self:Print("It records what happens during an encounter, and you can then post the log on our forums.")
		self:Print("Thanks!")
	else
		self:Print("Thanks for running Transcriptor! Please remember to click the icon so it glows red.")
	end
end
