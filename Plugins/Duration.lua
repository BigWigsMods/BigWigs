-------------------------------------------------------------------------------
-- Module Declaration
--

-- XXX EXPERIMENTAL MODULE, ALL CODE/FEATURES MAY CHANGE

local plugin = BigWigs:NewPlugin("Duration")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

--local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")
local SecondsToTime = SecondsToTime
local activeDurations = nil

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	if not BigWigsDurationDB then
		BigWigsDurationDB = {}
	end

	if not activeDurations then
		activeDurations = {}
	end

	self:RegisterMessage("BigWigs_OnBossEngage")
	self:RegisterMessage("BigWigs_OnBossWin")
	self:RegisterMessage("BigWigs_OnBossReboot")
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:BigWigs_OnBossEngage(event, module)
	if module.encounterId then
		activeDurations[module.encounterId] = GetTime()
	end
end

function plugin:BigWigs_OnBossWin(event, module)
	if module.encounterId and activeDurations[module.encounterId] then
		print("Big Wigs Experimental: Boss", module.moduleName, "defeated after", SecondsToTime(GetTime()-activeDurations[module.encounterId]))
		activeDurations[module.encounterId] = nil
	end
end

function plugin:BigWigs_OnBossReboot(event, module)
	if module.encounterId and activeDurations[module.encounterId] then
		print("Big Wigs Experimental: Boss", module.moduleName, "wiped after", SecondsToTime(GetTime()-activeDurations[module.encounterId]))
		activeDurations[module.encounterId] = nil
	end
end

