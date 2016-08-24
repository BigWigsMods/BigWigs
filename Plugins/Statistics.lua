-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Statistics")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs: Plugins")
local activeDurations = {}
local difficultyTable = {false, false, "10", "25", "10h", "25h", "lfr", false, false, false, false, false, false, "normal", "heroic", "mythic", "LFR"}
local SPELL_DURATION_SEC = SPELL_DURATION_SEC -- "%.2f sec"

--[[
1. "Normal" (Dungeons)
2. "Heroic" (Dungeons)
3. "10 Player"
4. "25 Player"
5. "10 Player (Heroic)"
6. "25 Player (Heroic)"
7. "Looking For Raid" (Legacy LFRs; everything prior to Siege of Orgrimmar)
8. "Challenge Mode"
9. "40 Player"
10. nil
11. "Heroic Scenario"
12. "Normal Scenario"
13. nil
14. "Normal" (Raids)
15. "Heroic" (Raids)
16. "Mythic" (Raids)
17. "Looking For Raid"
18. "Event"
19. "Event"
20. "Event Scenario"
21. nil
22. nil
23. "Mythic" (Dungeons)
23. "Timewalker"
24. "PvP Scenario"
http://wow.gamepedia.com/DifficultyID
]]--

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
	showBar = false,
}

do
	local function checkDisabled() return not plugin.db.profile.enabled end
	plugin.pluginOptions = {
		name = LibStub("AceLocale-3.0"):GetLocale("BigWigs").statistics,
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
						name = L.printDefeatOption,
						order = 2,
					},
					printNewBestKill = {
						type = "toggle",
						name = L.printBestTimeOption,
						order = 3,
						disabled = function() return not plugin.db.profile.saveBestKill or not plugin.db.profile.enabled end,
					},
				},
			},
			saveKills = {
				type = "toggle",
				name = L.countDefeats,
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
				name = L.recordBestTime,
				order = 6,
				disabled = checkDisabled,
				width = "full",
			},
			showBar = {
				type = "toggle",
				name = L.createTimeBar,
				order = 7,
				disabled = checkDisabled,
				width = "full",
			},
		},
	}
end

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
		self:RegisterMessage("BigWigs_OnBossDisable")
		self:RegisterMessage("BigWigs_OnBossReboot", "BigWigs_OnBossDisable")
	end
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:BigWigs_OnBossEngage(event, module, diff)
	if module.journalId and module.zoneId and not module.worldBoss then -- Raid restricted for now
		activeDurations[module.journalId] = GetTime()

		if diff and difficultyTable[diff] then
			local sDB = BigWigsStatisticsDB
			if not sDB[module.zoneId] then sDB[module.zoneId] = {} end
			if not sDB[module.zoneId][module.journalId] then sDB[module.zoneId][module.journalId] = {} end
			sDB = sDB[module.zoneId][module.journalId]
			if not sDB[difficultyTable[diff]] then sDB[difficultyTable[diff]] = {} end

			local best = sDB[difficultyTable[diff]].best
			if self.db.profile.showBar and best then
				self:SendMessage("BigWigs_StartBar", self, nil, L.bestTimeBar, best, "Interface\\Icons\\spell_holy_borrowedtime")
			end
		end
	end
end

function plugin:BigWigs_OnBossWin(event, module)
	if module.journalId and activeDurations[module.journalId] then
		local elapsed = GetTime()-activeDurations[module.journalId]

		if self.db.profile.printKills then
			BigWigs:ScheduleTimer("Print", 1, L.bossDefeatDurationPrint:format(module.displayName, elapsed < 1 and SPELL_DURATION_SEC:format(elapsed) or SecondsToTime(elapsed)))
		end

		local diff = module:Difficulty()
		if difficultyTable[diff] then
			local sDB = BigWigsStatisticsDB[module.zoneId][module.journalId][difficultyTable[diff]]
			if self.db.profile.saveKills then
				sDB.kills = sDB.kills and sDB.kills + 1 or 1
			end

			if self.db.profile.saveBestKill and (not sDB.best or elapsed < sDB.best) then
				if self.db.profile.printNewBestKill and sDB.best then
					local t = sDB.best-elapsed
					BigWigs:ScheduleTimer("Print", 1.1, ("%s (-%s)"):format(L.newBestTime, t < 1 and SPELL_DURATION_SEC:format(t) or SecondsToTime(t)))
				end
				sDB.best = elapsed
			end
		end

		activeDurations[module.journalId] = nil
	end
end

function plugin:BigWigs_OnBossWipe(event, module)
	if module.journalId and activeDurations[module.journalId] then
		local elapsed = GetTime()-activeDurations[module.journalId]

		if elapsed > 30 then -- Fight must last longer than 30 seconds to be an actual wipe worth noting
			if self.db.profile.printWipes then
				BigWigs:Print(L.bossWipeDurationPrint:format(module.displayName, SecondsToTime(elapsed)))
			end

			local diff = module:Difficulty()
			if difficultyTable[diff] and self.db.profile.saveWipes then
				local sDB = BigWigsStatisticsDB[module.zoneId][module.journalId][difficultyTable[diff]]
				sDB.wipes = sDB.wipes and sDB.wipes + 1 or 1
			end
		end

		activeDurations[module.journalId] = nil
	end
end

function plugin:BigWigs_OnBossDisable()
	self:SendMessage("BigWigs_StopBar", self, L.bestTimeBar)
end

