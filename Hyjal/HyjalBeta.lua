HyjalBeta = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceEvent-2.0")

local BZ = AceLibrary("Babble-Zone-2.2")
local warnedThisSession = nil

function HyjalBeta:OnEnable()
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	if GetRealZoneText() == BZ["Hyjal Summit"] then
		self:ZONE_CHANGED_NEW_AREA()
	end
end

function HyjalBeta:ZONE_CHANGED_NEW_AREA()
	if GetRealZoneText() ~= BZ["Hyjal Summit"] or warnedThisSession then return end
	warnedThisSession = true
	if not IsAddOnLoaded("BigWigs_Debugger") then
		self:Print("The BigWigs boss modules for Hyjal are not complete yet, by far, and we need your help.")
		self:Print("Please download and install BigWigs_Debugger from http://files.wowace.com/BigWigs_Debugger/")
		self:Print("It records what happens during an encounter, and you can then post the log on our forums.")
		self:Print("Thanks!")
	else
		self:Print("Thanks for running BigWigs_Debugger! Please remember to click the icon so it glows red.")
	end
end
