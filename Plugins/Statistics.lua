-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Statistics")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
local activeDurations = {}
local healthPools = {}
local units = {"boss1", "boss2", "boss3", "boss4", "boss5"}
local difficultyTable = {[9] = "raid", [148] = "raid"} -- raid40, raid20
local SPELL_DURATION_SEC = SPELL_DURATION_SEC -- "%.2f sec"
local GetTime = GetTime

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
	printHealth = true,
	showBar = false,
}

do
	local function checkDisabled() return not plugin.db.profile.enabled end
	plugin.pluginOptions = {
		name = BigWigsAPI:GetLocale("BigWigs").statistics,
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
					-- printHealth = {
					-- 	type = "toggle",
					-- 	name = L.printHealthOption,
					-- 	order = 3,
					-- },
					printNewBestKill = {
						type = "toggle",
						name = L.printBestTimeOption,
						order = 4,
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
	if not BigWigsStatsClassicDB then
		BigWigsStatsClassicDB = {}
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

do
	local UnitHealth, UnitHealthMax, UnitName, IsEncounterInProgress = UnitHealth, UnitHealthMax, UnitName, IsEncounterInProgress
	local function StoreHealth(module)
		if IsEncounterInProgress() then
			for i = 1, 5 do
				local unit = units[i]
				local rawHealth = UnitHealth(unit)
				if rawHealth > 0 then
					local maxHealth = UnitHealthMax(unit)
					local health = rawHealth / maxHealth
					healthPools[module.engageId][unit] = health
					healthPools[module.engageId].names[unit] = UnitName(unit)
				elseif healthPools[module.engageId][unit] then
					healthPools[module.engageId][unit] = nil
				end
			end
		end
	end
	function plugin:BigWigs_OnBossEngage(event, module, diff)
		local id = module.instanceId

		if module.engageId and module.allowWin and id and id > 0 and not module.worldBoss then -- Raid restricted for now
			activeDurations[module.engageId] = GetTime()

			if diff and difficultyTable[diff] then
				local sDB = BigWigsStatsClassicDB
				if not sDB[id] then sDB[id] = {} end
				if not sDB[id][module.engageId] then sDB[id][module.engageId] = {} end
				sDB = sDB[id][module.engageId]
				if not sDB[difficultyTable[diff]] then sDB[difficultyTable[diff]] = {} end

				local best = sDB[difficultyTable[diff]].best
				if self.db.profile.showBar and best then
					self:SendMessage("BigWigs_StartBar", self, nil, L.bestTimeBar, best, 134377) -- 237538 = "Interface\\Icons\\inv_misc_pocketwatch_02"
				end
			end

			-- if self.db.profile.printHealth then
			-- 	healthPools[module.engageId] = {
			-- 		names = {},
			-- 		timer = self:ScheduleRepeatingTimer(StoreHealth, 2, module),
			-- 	}
			-- end
		end
	end
end

local function Stop(self, module)
	if module.engageId and module.allowWin then
		activeDurations[module.engageId] = nil
		if healthPools[module.engageId] then
			self:CancelTimer(healthPools[module.engageId].timer)
			healthPools[module.engageId] = nil
		end

		self:SendMessage("BigWigs_StopBar", self, L.bestTimeBar)
	end
end

function plugin:BigWigs_OnBossWin(event, module)
	if module.engageId and module.allowWin and activeDurations[module.engageId] then
		local elapsed = GetTime()-activeDurations[module.engageId]

		if self.db.profile.printKills then
			BigWigs:ScheduleTimer("Print", 1, L.bossDefeatDurationPrint:format(module.displayName, elapsed < 1 and SPELL_DURATION_SEC:format(elapsed) or SecondsToTime(elapsed)))
		end

		local diff = module:Difficulty()
		if difficultyTable[diff] then
			local sDB = BigWigsStatsClassicDB[module.instanceId][module.engageId][difficultyTable[diff]]
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
	end

	Stop(self, module)
end

function plugin:BigWigs_OnBossWipe(event, module)
	if module.engageId and module.allowWin and activeDurations[module.engageId] then
		local elapsed = GetTime()-activeDurations[module.engageId]

		if elapsed > 30 then -- Fight must last longer than 30 seconds to be an actual wipe worth noting
			if self.db.profile.printWipes then
				BigWigs:Print(L.bossWipeDurationPrint:format(module.displayName, SecondsToTime(elapsed)))
			end

			local diff = module:Difficulty()
			if difficultyTable[diff] and self.db.profile.saveWipes then
				local sDB = BigWigsStatsClassicDB[module.instanceId][module.engageId][difficultyTable[diff]]
				sDB.wipes = sDB.wipes and sDB.wipes + 1 or 1
			end

			if healthPools[module.engageId] then
				local total = ""
				for i = 1, 5 do
					local unit = units[i]
					local hp = healthPools[module.engageId][unit]
					if hp then
						if total == "" then
							total = L.healthFormat:format(healthPools[module.engageId].names[unit], hp*100)
						else
							total = total .. L.comma .. L.healthFormat:format(healthPools[module.engageId].names[unit], hp*100)
						end
					end
				end
				if total ~= "" then
					BigWigs:Print(L.healthPrint:format(total))
				end
			end
		end
	end

	Stop(self, module)
end

