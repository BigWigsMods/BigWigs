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
local difficultyTable = BigWigsLoader.isRetail and {
	[3] = "10N", -- 10N
	[4] = "25N", -- 25N
	[5] = "10H", -- 10H
	[6] = "25H", -- 25H
	[7] = "LFR", -- Old LFR (Dragon Soul)
	--[9] = "normal", -- raid40 (molten core/BWL/AQ40)
	[14] = "normal",
	[15] = "heroic",
	[16] = "mythic",
	[17] = "LFR",
} or {
	[3] = "10N", -- 10N
	[4] = "25N", -- 25N
	[5] = "10H", -- 10H
	[6] = "25H", -- 25H
	[7] = "LFR", -- Old LFR (Dragon Soul)
	[9] = "normal", -- raid40 (molten core/BWL/AQ40)
	--[175] = "normal", -- raid10 (karazhan) -- move from 3 (fake) to 175 (guessed)
	--[148] = "normal", -- raid20
	--[176] = "normal", -- raid 25 (sunwell)
	[198] = "normal", -- raid10 (Blackfathom Deeps/Gnomeregan - Classic Season of Discovery)
	[215] = "normal", -- raid20 (Sunken Temple - Classic Season of Discovery)
}
local SPELL_DURATION_SEC = SPELL_DURATION_SEC -- "%.2f sec"
local GetTime = GetTime
local dontPrint = { -- Don't print a warning message for these difficulties
	[1] = true, -- Normal Dungeon
	[2] = true, -- Heroic Dungeon
	[8] = true, -- Mythic+ Dungeon
	[23] = true, -- Mythic Dungeon
	[24] = true, -- Timewalking
}

--[[
10.2.7
1. Normal
2. Heroic
3. 10 Player
4. 25 Player
5. 10 Player (Heroic)
6. 25 Player (Heroic)
7. Looking For Raid
8. Mythic Keystone
9. 40 Player
11. Heroic Scenario
12. Normal Scenario
14. Normal
15. Heroic
16. Mythic
17. Looking For Raid
18. Event
19. Event
20. Event Scenario
23. Mythic
24. Timewalking
25. World PvP Scenario
29. PvEvP Scenario
30. Event
32. World PvP Scenario
33. Timewalking
34. PvP
38. Normal
39. Heroic
40. Mythic
45. PvP
147. Normal
149. Heroic
150. Normal
151. Looking For Raid
152. Visions of N'Zoth
153. Teeming Island
167. Torghast
168. Path of Ascension: Courage
169. Path of Ascension: Loyalty
170. Path of Ascension: Wisdom
171. Path of Ascension: Humility
172. World Boss
192. Challenge Level 1
205. Follower

4.4.0
1. Normal
2. Heroic
3. 10 Player
4. 25 Player
5. 10 Player (Heroic)
6. 25 Player (Heroic)
9. 40 Player
148. 20 Player
173. Normal
174. Heroic
175. 10 Player
176. 25 Player
193. 10 Player (Heroic)
194. 25 Player (Heroic)

1.15.2
1. Normal
9. 40 Player
148. 20 Player
184. Normal
185. 20 Player
186. 40 Player
197. 10 Player
198. Normal
201. Normal
202. Difficulty A
203. Difficulty B
204. Difficulty C
207. Normal
213. Infinite
214. DNT - Internal only
215. Normal

/run for i=1, 1000 do local n = GetDifficultyInfo(i) if n then print(i..".", n) end end
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
	printHealth = true,
	showBar = false,
}

do
	local function checkDisabled() return not plugin.db.profile.enabled end
	plugin.pluginOptions = {
		name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Stats:20|t ".. BigWigsAPI:GetLocale("BigWigs").statistics,
		type = "group",
		childGroups = "tab",
		order = 12,
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
						width = 1.5,
					},
					printKills = {
						type = "toggle",
						name = L.printDefeatOption,
						order = 2,
						width = 1.5,
					},
					printHealth = {
						type = "toggle",
						name = L.printHealthOption,
						order = 3,
						width = 1.5,
					},
					printNewBestKill = {
						type = "toggle",
						name = L.printBestTimeOption,
						order = 4,
						width = 1.5,
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

function plugin:OnRegister()
	if type(BigWigsStatsDB) ~= "table" then
		BigWigsStatsDB = {}
	end
end

do
	local function updateProfile()
		local db = plugin.db.profile

		for k, v in next, db do
			local defaultType = type(plugin.defaultDB[k])
			if defaultType == "nil" then
				db[k] = nil
			elseif type(v) ~= defaultType then
				db[k] = plugin.defaultDB[k]
			end
		end
	end

	function plugin:OnPluginEnable()
		if self.db.profile.enabled then
			self:RegisterMessage("BigWigs_OnBossEngage")
			self:RegisterMessage("BigWigs_OnBossWin")
			self:RegisterMessage("BigWigs_OnBossWipe")
			self:RegisterMessage("BigWigs_OnBossDisable")
		end

		self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
		updateProfile()
	end
end

function plugin:OnPluginDisable()
	activeDurations = {}
	healthPools = {}
end

-------------------------------------------------------------------------------
-- Event Handlers
--

do
	local UnitHealth, UnitHealthMax, IsEncounterInProgress = UnitHealth, UnitHealthMax, IsEncounterInProgress
	local function StoreHealth(module)
		if IsEncounterInProgress() then
			for i = 1, 5 do
				local unit = units[i]
				local rawHealth = UnitHealth(unit)
				local journalId = module:GetJournalID()
				if rawHealth > 0 then
					local maxHealth = UnitHealthMax(unit)
					local health = rawHealth / maxHealth
					healthPools[journalId][unit] = health
					healthPools[journalId].names[unit] = module:UnitName(unit)
				elseif healthPools[journalId][unit] then
					healthPools[journalId][unit] = nil
				end
			end
		end
	end
	function plugin:BigWigs_OnBossEngage(event, module, diff)
		local id = module.instanceId
		local journalId = module:GetJournalID()

		if journalId and id and id > 0 and not module.worldBoss then -- Raid restricted for now
			activeDurations[journalId] = GetTime()

			if diff and difficultyTable[diff] then
				local sDB = BigWigsStatsDB
				if not sDB[id] then sDB[id] = {} end
				if not sDB[id][journalId] then sDB[id][journalId] = {} end
				sDB = sDB[id][journalId]
				if not sDB[difficultyTable[diff]] then sDB[difficultyTable[diff]] = {} end

				local best = sDB[difficultyTable[diff]].best
				if self.db.profile.showBar and best then
					self:SendMessage("BigWigs_StartBar", self, nil, L.bestTimeBar, best, 237538) -- 237538 = "Interface\\Icons\\spell_holy_borrowedtime"
				end
			end

			if self.db.profile.printHealth then
				healthPools[journalId] = {
					names = {},
					timer = self:ScheduleRepeatingTimer(StoreHealth, 2, module),
				}
			end
		end
	end
end

local function Stop(self, module)
	local journalId = module:GetJournalID()
	if journalId then
		activeDurations[journalId] = nil
		if healthPools[journalId] then
			self:CancelTimer(healthPools[journalId].timer)
			healthPools[journalId] = nil
		end

		self:SendMessage("BigWigs_StopBar", self, L.bestTimeBar)
	end
end

function plugin:BigWigs_OnBossWin(event, module)
	local journalId = module:GetJournalID()
	if journalId and activeDurations[journalId] then
		local elapsed = GetTime()-activeDurations[journalId]

		if self.db.profile.printKills then
			BigWigs:ScheduleTimer("Print", 1, L.bossDefeatDurationPrint:format(module.displayName, elapsed < 1 and SPELL_DURATION_SEC:format(elapsed) or SecondsToTime(elapsed)))
		end

		local diff = module:Difficulty()
		if difficultyTable[diff] then
			local sDB = BigWigsStatsDB[module.instanceId][journalId][difficultyTable[diff]]
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
		elseif IsInRaid() and not dontPrint[diff] then
			BigWigs:Error("Tell the devs, the stats for this boss were not recorded because a new difficulty id was found: "..diff)
		end
	end

	Stop(self, module)
end

function plugin:BigWigs_OnBossWipe(event, module)
	local journalId = module:GetJournalID()
	if journalId and activeDurations[journalId] then
		local elapsed = GetTime()-activeDurations[journalId]

		if elapsed > 30 then -- Fight must last longer than 30 seconds to be an actual wipe worth noting
			if self.db.profile.printWipes then
				BigWigs:Print(L.bossWipeDurationPrint:format(module.displayName, SecondsToTime(elapsed)))
			end

			local diff = module:Difficulty()
			if not difficultyTable[diff] and IsInRaid() and not dontPrint[diff] then
				BigWigs:Error("Tell the devs, the stats for this boss were not recorded because a new difficulty id was found: "..diff)
			elseif difficultyTable[diff] and self.db.profile.saveWipes then
				local sDB = BigWigsStatsDB[module.instanceId][journalId][difficultyTable[diff]]
				sDB.wipes = sDB.wipes and sDB.wipes + 1 or 1
			end

			if healthPools[journalId] then
				local total = ""
				for i = 1, 5 do
					local unit = units[i]
					local hp = healthPools[journalId][unit]
					if hp then
						if total == "" then
							total = L.healthFormat:format(healthPools[journalId].names[unit], hp*100)
						else
							total = total .. L.comma .. L.healthFormat:format(healthPools[journalId].names[unit], hp*100)
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

function plugin:BigWigs_OnBossDisable(event, module) -- Manual disable or reboot of the boss module
	Stop(self, module)
end
