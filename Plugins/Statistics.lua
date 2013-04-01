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
	saveKills = true,
	saveWipes = true,
	saveBestKill = true,
	printKills = true,
	printWipes = true,
	printNewBestKill = true,
}

local function checkDisabled() return not plugin.db.profile.enabled end
plugin.subPanelOptions = {
	key = "Big Wigs: Boss Statistics",
	name = L.bossStatistics,
	options = {
		name = L.bossStatistics,
		type = "group",
		childGroups = "tab",
		get = function(i) return plugin.db.profile[i[#i]] end,
		set = function(i, value) plugin.db.profile[i[#i]] = value end,
		args = {
			heading = {
				type = "description",
				name = L.bossStatsDescription.."\n\n",
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
			printGroup = {
				type = "group",
				name = L.chatMessages,
				order = 3,
				disabled = checkDisabled,
				inline = true,
				args = {
					printWipes = {
						type = "toggle",
						name = L.printWipeOption,
						order = 1,
					},
					printKills = {
						type = "toggle",
						name = L.printKillOption,
						order = 2,
					},
					printNewBestKill = {
						type = "toggle",
						name = L.printBestKillOption,
						order = 3,
						disabled = function() return not plugin.db.profile.saveBestKill or not plugin.db.profile.enabled end,
					},
				},
			},
			saveKills = {
				type = "toggle",
				name = L.countKills,
				order = 4,
				disabled = checkDisabled,
				width = "full",
			},
			saveWipes = {
				type = "toggle",
				name = L.countWipes,
				order = 5,
				disabled = checkDisabled,
				width = "full",
			},
			saveBestKill = {
				type = "toggle",
				name = L.recordBestKills,
				order = 6,
				disabled = checkDisabled,
				width = "full",
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
		self:RegisterMessage("BigWigs_OnBossWipe")
	end
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:BigWigs_OnBossEngage(event, module, diff)
	if module.encounterId and diff and diff > 2 and diff < 8 and not module.worldBoss then -- Raid restricted for now
		activeDurations[module.encounterId] = GetTime()

		local sDB = BigWigsStatisticsDB
		if not sDB[module.zoneId] then sDB[module.zoneId] = {} end
		if not sDB[module.zoneId][module.encounterId] then sDB[module.zoneId][module.encounterId] = {} end
		sDB = sDB[module.zoneId][module.encounterId]
		if not sDB[difficultyTable[diff]] then sDB[difficultyTable[diff]] = {} end
	end
end

function plugin:BigWigs_OnBossWin(event, module)
	if module.encounterId and activeDurations[module.encounterId] then
		local elapsed = GetTime()-activeDurations[module.encounterId]
		local sDB = BigWigsStatisticsDB[module.zoneId][module.encounterId][difficultyTable[module:Difficulty()]]

		if self.db.profile.printKills then
			BigWigs:Print(L.bossKillDurationPrint:format(module.displayName, SecondsToTime(elapsed)))
		end

		if self.db.profile.saveKills then
			sDB.kills = sDB.kills and sDB.kills + 1 or 1
		end

		if self.db.profile.saveBestKill and (not sDB.best or elapsed < sDB.best) then
			sDB.best = elapsed
			if self.db.profile.printNewBestKill then
				BigWigs:Print(L.newBestKill)
			end
		end

		activeDurations[module.encounterId] = nil
	end
end

function plugin:BigWigs_OnBossWipe(event, module)
	if module.encounterId and activeDurations[module.encounterId] then
		local elapsed = GetTime()-activeDurations[module.encounterId]

		if elapsed > 30 then -- Fight must last longer than 30 seconds to be an actual wipe worth noting
			if self.db.profile.printWipes then
				BigWigs:Print(L.bossWipeDurationPrint:format(module.displayName, SecondsToTime(elapsed)))
			end

			if self.db.profile.saveWipes then
				local sDB = BigWigsStatisticsDB[module.zoneId][module.encounterId][difficultyTable[module:Difficulty()]]
				sDB.wipes = sDB.wipes and sDB.wipes + 1 or 1
			end
		end

		activeDurations[module.encounterId] = nil
	end
end

