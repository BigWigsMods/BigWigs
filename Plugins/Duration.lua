-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Duration")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")
local activeDurations = {}

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	if not BigWigsDurationDB then
		BigWigsDurationDB = {}
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
		BigWigs:Print(L.bossKillDurationPrint:format(module.moduleName, SecondsToTime(GetTime()-activeDurations[module.encounterId])))
		activeDurations[module.encounterId] = nil
	end
end

function plugin:BigWigs_OnBossReboot(event, module)
	if module.encounterId and activeDurations[module.encounterId] then
		BigWigs:Print(L.bossWipeDurationPrint:format(module.moduleName, SecondsToTime(GetTime()-activeDurations[module.encounterId])))
		activeDurations[module.encounterId] = nil
	end
end

