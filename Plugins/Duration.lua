-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Statistics")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")
local activeDurations = {}

-------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	enabled = true,
	--countKills = true,
	--countWipes = true,
	--printKills = true,
	--printWipes = true,
	--bestKillTime = true,
}

plugin.subPanelOptions = {
	key = "Big Wigs: Boss Statistics",
	name = L.bossStatistics,
	options = {
		name = L.bossStatistics,
		type = "group",
		--childGroups = "tab",
		get = function(i) return plugin.db.profile[i[#i]] end,
		set = function(i, value) plugin.db.profile[i[#i]] = value end,
		args = {
			heading = {
				type = "description",
				name = "Description",
				order = 1,
				width = "full",
				fontSize = "medium",
			},
			--enabled = {
			--	type = "toggle",
			--	name = "Enable Statistics",
			--	desc = "Enables stats.",
			--	order = 2,
			--	width = "full",
			--	set = function(i, value)
			--		plugin.db.profile[i[#i]] = value
			--		plugin:Disable()
			--		plugin:Enable()
			--	end,
			--},
		},
	},
}

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	if not BigWigsStatisticsDB then
		BigWigsStatisticsDB = {}
	end

	if self.db.profile.enabled then
		self:RegisterMessage("BigWigs_OnBossEngage")
		self:RegisterMessage("BigWigs_OnBossWin")
		self:RegisterMessage("BigWigs_OnBossReboot")
	end
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

