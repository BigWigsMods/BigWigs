-------------------------------------------------------------------------------
-- Module Declaration
--

-- XXX EXPERIMENTAL MODULE, ALL CODE/FEATURES MAY CHANGE

local plugin = BigWigs:NewPlugin("Duration")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")
local lastTime = nil
local curModule = nil

-------------------------------------------------------------------------------
-- Initialization
--

local dev = true
function plugin:OnPluginEnable()
	if not dev then
		self:RegisterMessage("BigWigs_OnBossEngage")
		self:RegisterMessage("BigWigs_OnBossWin")
		self:RegisterMessage("BigWigs_OnBossReboot")
	end
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:BigWigs_OnBossEngage(event, module)
	if not lastTime and module.encounterId then
		curModule = module.moduleName
		lastTime = GetTime()
	end
end

function plugin:BigWigs_OnBossEngage(event, module)
	if lastTime and module.encounterId and module.moduleName == curModule then
		print("Boss", module.moduleName, "defeated after", SecondsToTime(GetTime()-lastTime))
		lastTime, curModule = nil, nil
	end
end

function plugin:BigWigs_OnBossReboot(event, module)
	if lastTime and module.encounterId and module.moduleName == curModule then
		print("Boss", module.moduleName, "wiped after", SecondsToTime(GetTime()-lastTime))
		lastTime, curModule = nil, nil
	end
end

