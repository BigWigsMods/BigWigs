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
local difficultyTable = {"5", "5h", "10", "25", "10h", "25h", "lfr"}

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
		get = function(i) return plugin.db.profile[i[#i]] end,
		set = function(i, value) plugin.db.profile[i[#i]] = value end,
		args = {
			heading = {
				type = "description",
				name = L.bossStatsDescription,
				order = 1,
				width = "full",
				fontSize = "medium",
			},
			enabled = {
				type = "toggle",
				name = L.enableStats,
				order = 2,
				width = "full",
				set = function(i, value)
					plugin.db.profile[i[#i]] = value
					plugin:Disable()
					plugin:Enable()
				end,
			},
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

function plugin:BigWigs_OnBossEngage(event, module, diff)
	if module.encounterId and diff and diff > 2 and diff < 8 then -- Raid restricted for now
		activeDurations[module.encounterId] = GetTime()

		--local sDB = BigWigsStatisticsDB
		--if not sDB[module.zoneId] then sDB[module.zoneId] = {} end
		--if not sDB[module.zoneId][module.encounterId] then sDB[module.zoneId][module.encounterId] = {} end
		--sDB = sDB[module.zoneId][module.encounterId]
		--if not sDB[difficultyTable[diff]] then sDB[difficultyTable[diff]] = {} end
	end
end

function plugin:BigWigs_OnBossWin(event, module)
	if module.encounterId and activeDurations[module.encounterId] then
		local elapsed = GetTime()-activeDurations[module.encounterId]
		BigWigs:Print(L.bossKillDurationPrint:format(module.moduleName, SecondsToTime(elapsed)))
		--local sDB = BigWigsStatisticsDB[module.zoneId][module.encounterId][difficultyTable[module:Difficulty()]]
		--sDB.kills = sDB.kills and sDB.kills + 1 or 1
		--if not sDB.best or (sDB.best and elapsed < sDB.best) then
		--	sDB.best = elapsed
		--	BigWigs:Print(L.newBestKill)
		--end
		activeDurations[module.encounterId] = nil
	end
end

function plugin:BigWigs_OnBossReboot(event, module, isWipe)
	if isWipe and module.encounterId and activeDurations[module.encounterId] then
		local elapsed = GetTime()-activeDurations[module.encounterId]
		BigWigs:Print(L.bossWipeDurationPrint:format(module.moduleName, SecondsToTime(elapsed)))
		--local sDB = BigWigsStatisticsDB[module.zoneId][module.encounterId][difficultyTable[module:Difficulty()]]
		--sDB.wipes = sDB.wipes and sDB.wipes + 1 or 1
		activeDurations[module.encounterId] = nil
	end
end

