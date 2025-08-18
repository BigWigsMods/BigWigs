-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin, L = BigWigs:NewPlugin("Statistics")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local activeDurations = {}
local healthPools = {}
local units = {"boss1", "boss2", "boss3", "boss4", "boss5"}
local difficultyTable = {
	[3] = "N10", -- 10 Player
	[4] = "N25", -- 25 Player
	[5] = "H10", -- 10 Player (Heroic)
	[6] = "H25", -- 25 Player (Heroic)
	[7] = "LFR", -- Looking For Raid (Old - Dragon Soul & some MoP raids)
	[9] = "normal", -- 40 Player (MC/BWL/AQ40)
	[14] = "normal", -- Normal
	[15] = "heroic", -- Heroic
	[16] = "mythic", -- Mythic
	[17] = "LFR", -- Looking For Raid
	[33] = "timewalk", -- Timewalking (raids)
	[148] = "normal", -- 20 Player (AQ20/ZG)
	[175] = "N10", -- 10 Player (Ulduar 10 & Karazhan)
	[176] = "N25", -- 25 Player (Ulduar 25 & TBC raids)
	[185] = "SOD", -- 20 Player (AQ20 - Classic Season of Discovery)
	[186] = "SOD", -- 40 Player (Onyxia & BWL - Classic Season of Discovery)
	[198] = "SOD", -- Normal (10 player Blackfathom Deeps/Gnomeregan - Classic Season of Discovery)
	[215] = "SOD", -- Normal (20 player Sunken Temple - Classic Season of Discovery)
	[220] = "story", -- Story
	[226] = "SOD", -- 20 Player (Molten Core & ZG - Classic Season of Discovery)
}
local SPELL_DURATION_SEC = SPELL_DURATION_SEC -- "%.2f sec"
local GetTime, date = GetTime, BigWigsLoader.date
local dontPrint = { -- Don't print a warning message for these difficulties
	[0] = true, -- Outside
	[1] = true, -- Normal Dungeon
	[2] = true, -- Heroic Dungeon
	[8] = true, -- Mythic+ Dungeon
	[9] = true, -- 40 Player (MC/BWL/AQ40)
	[23] = true, -- Mythic Dungeon
	[24] = true, -- Timewalking
	[208] = true, -- Delves
}

--[[
11.2.0
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
150. Normal Scaling (1-5)
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
208. Delves
216. Quest
220. Story
230. Heroic
232. Event
236. Lorewalking

5.5.0
1. Normal
2. Heroic
3. 10 Player
4. 25 Player
5. 10 Player (Heroic)
6. 25 Player (Heroic)
7. Looking For Raid
8. Challenge Mode
9. 40 Player
11. Heroic Scenario
12. Normal Scenario
14. Flexible
148. 20 Player
173. Normal
174. Heroic
175. 10 Player
176. 25 Player
193. 10 Player (Heroic)
194. 25 Player (Heroic)

4.4.2
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

1.15.7
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
226. 20 Player
231. Normal

/run for i=1, 1000 do local n = GetDifficultyInfo(i) if n then print(i..".", n) end end
]]--

-------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	disabled = false,
	printVictory = true,
	printDefeat = true,
	printNewFastestVictory = true,
	printHealth = true,
	showBar = false,
}

do
	local function checkDisabled() return plugin.db.profile.disabled end
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
			printGroup = {
				type = "group",
				name = L.chatMessages,
				order = 2,
				disabled = checkDisabled,
				inline = true,
				args = {
					printDefeat = {
						type = "toggle",
						name = L.defeatOption,
						order = 1,
						width = 1.5,
					},
					printVictory = {
						type = "toggle",
						name = L.victoryOption,
						order = 2,
						width = 1.5,
					},
					printHealth = {
						type = "toggle",
						name = L.bossHealthOption,
						order = 3,
						width = 1.5,
					},
					printNewFastestVictory = {
						type = "toggle",
						name = L.newFastestVictoryOption,
						order = 4,
						width = 1.5,
					},
				},
			},
			showBar = {
				type = "toggle",
				name = L.createTimeBar,
				order = 3,
				disabled = checkDisabled,
				width = "full",
			},
			spacer = {
				type = "description",
				name = "\n\n",
				order = 4,
				width = "full",
				fontSize = "medium",
			},
			disabled = {
				type = "toggle",
				name = L.disabled,
				order = 5,
				confirm = function(_, value)
					if value then
						return L.disableDesc:format(L.bossStatistics)
					end
				end,
				set = function(i, value)
					plugin.db.profile[i[#i]] = value
					plugin:Disable()
					plugin:Enable()
				end,
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
		if not self.db.profile.disabled then
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

local function GetModuleID(bossMod)
	local journalID = bossMod:GetJournalID()
	if journalID then
		return journalID
	elseif not journalID and bossMod:GetAllowWin() and bossMod:GetEncounterID() then
		return -(bossMod:GetEncounterID()) -- Fallback to record stats for modules with no journal ID, but set to allow win
	end
end

do
	local UnitHealth, UnitHealthMax, IsEncounterInProgress = UnitHealth, UnitHealthMax, IsEncounterInProgress
	local function StoreHealth(module)
		if IsEncounterInProgress() then
			local journalID = GetModuleID(module)
			for i = 1, 5 do
				local unit = units[i]
				local rawHealth = UnitHealth(unit)
				if rawHealth > 0 then
					local maxHealth = UnitHealthMax(unit)
					local health = rawHealth / maxHealth
					healthPools[journalID][unit] = health
					healthPools[journalID].names[unit] = module:UnitName(unit)
				elseif healthPools[journalID][unit] then
					healthPools[journalID][unit] = nil
				end
			end
		end
	end
	local function GetDifficultyText(module)
		local diff = module:Difficulty()
		if diff then
			if diff == 208 then -- Delves
				-- Only record stats for solo Nemesis delves
				if module:Solo() then
					local info = C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo(6184) -- ? Difficulty
					if info and info.shownState == 1 then
						return "solotier8"
					end
					info = C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo(6185) -- ?? Difficulty
					if info and info.shownState == 1 then
						return "solotier11"
					end
				end
			elseif diff == 226 then -- SOD
				if module:GetPlayerAura(458841) then -- Sweltering Heat
					return "level1"
				elseif module:GetPlayerAura(458842) then -- Blistering Heat
					return "level2"
				elseif module:GetPlayerAura(458843) then -- Molten Heat
					return "level3"
				end
			elseif diff == 9 or diff == 148 then -- normal
				local season = module:GetSeason()
				if season == 3 or season == 12 then
					return "hardcore"
				elseif season == 2 and diff == 9 then
					return "SOD"
				end
			end
			return difficultyTable[diff]
		end
	end
	function plugin:BigWigs_OnBossEngage(event, module)
		local instanceID = module:GetZoneID()
		local journalID = GetModuleID(module)

		if journalID and instanceID and instanceID > 0 and not module.worldBoss then -- Raid restricted for now
			local t = GetTime()
			activeDurations[journalID] = {t}

			local difficultyText = GetDifficultyText(module)
			if difficultyText then
				local sDB = BigWigsStatsDB
				if not sDB[instanceID] then sDB[instanceID] = {} end
				if not sDB[instanceID][journalID] then sDB[instanceID][journalID] = {} end
				sDB = sDB[instanceID][journalID]
				if not sDB[difficultyText] then sDB[difficultyText] = {} end
				activeDurations[journalID][2] = difficultyText

				local best = sDB[difficultyText].best
				if self.db.profile.showBar and best then
					self:SendMessage("BigWigs_StartBar", self, nil, L.bestTimeBar, best, 237538) -- 237538 = "Interface\\Icons\\spell_holy_borrowedtime"
					self:SendMessage("BigWigs_Timer", self, nil, best, best, L.bestTimeBar, 0, 237538, false, true)
				end
			end

			if self.db.profile.printHealth then
				healthPools[journalID] = {
					names = {},
					timer = self:ScheduleRepeatingTimer(function() StoreHealth(module) end, 2),
				}
			end
		end
	end
end

local function Stop(self, module)
	local journalID = GetModuleID(module)
	if journalID then
		activeDurations[journalID] = nil
		if healthPools[journalID] then
			self:CancelTimer(healthPools[journalID].timer)
			healthPools[journalID] = nil
		end

		self:SendMessage("BigWigs_StopBar", self, L.bestTimeBar)
	end
end

function plugin:BigWigs_OnBossWin(event, module)
	local journalID = GetModuleID(module)
	if journalID and activeDurations[journalID] then
		local elapsed = GetTime()-activeDurations[journalID][1]
		local difficultyText = activeDurations[journalID][2]

		if self.db.profile.printVictory then
			self:SimpleTimer(function() BigWigs:Print(L.bossVictoryPrint:format(module.displayName, elapsed < 1 and SPELL_DURATION_SEC:format(elapsed) or SecondsToTime(elapsed))) end, 1)
		end

		local diff = module:Difficulty()
		if difficultyText then
			local instanceID = module:GetZoneID()
			local sDB = BigWigsStatsDB[instanceID][journalID][difficultyText]
			if not sDB.kills then
				sDB.kills = 1
				if sDB.wipes then
					sDB.fkWipes = sDB.wipes
				end
				sDB.fkDuration = elapsed
				sDB.fkDate = date("%Y/%m/%d")
			else
				sDB.kills = sDB.kills + 1
			end

			if not sDB.best or elapsed < sDB.best then
				if self.db.profile.printNewFastestVictory and sDB.best then
					local t = sDB.best-elapsed
					self:SimpleTimer(function() BigWigs:Print(L.newFastestVictoryPrint:format(t < 1 and SPELL_DURATION_SEC:format(t) or SecondsToTime(t))) end, 1.1)
				end
				sDB.best = elapsed
				sDB.bestDate = date("%Y/%m/%d")
			end
		elseif IsInRaid() and not dontPrint[diff] then
			BigWigs:Error("Tell the devs, the stats for this boss were not recorded because a new difficulty id was found: "..diff)
		end
	end

	Stop(self, module)
end

do
	local function GetMinimumEncounterDuration(module)
		local diff = module:Difficulty()
		if diff == 208 then -- Delves
			-- As solo content, Delve encounters can be over quickly
			return 5
		end
		-- Raid encounters must last longer than 30 seconds to be an actual wipe worth noting
		return 30
	end
	function plugin:BigWigs_OnBossWipe(event, module)
		local journalID = GetModuleID(module)
		if journalID and activeDurations[journalID] then
			local elapsed = GetTime()-activeDurations[journalID][1]
			local difficultyText = activeDurations[journalID][2]

			if elapsed > GetMinimumEncounterDuration(module) then
				if self.db.profile.printDefeat then
					BigWigs:Print(L.bossDefeatPrint:format(module.displayName, SecondsToTime(elapsed)))
				end

				local diff = module:Difficulty()
				if not difficultyText and IsInRaid() and not dontPrint[diff] then
					BigWigs:Error("Tell the devs, the stats for this boss were not recorded because a new difficulty id was found: "..diff)
				elseif difficultyText then
					local instanceID = module:GetZoneID()
					local sDB = BigWigsStatsDB[instanceID][journalID][difficultyText]
					sDB.wipes = sDB.wipes and sDB.wipes + 1 or 1
				end

				if healthPools[journalID] then
					local total = ""
					for i = 1, 5 do
						local unit = units[i]
						local hp = healthPools[journalID][unit]
						if hp then
							if total == "" then
								total = L.healthFormat:format(healthPools[journalID].names[unit], hp*100)
							else
								total = total .. L.comma .. L.healthFormat:format(healthPools[journalID].names[unit], hp*100)
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
end

function plugin:BigWigs_OnBossDisable(event, module) -- Manual disable or reboot of the boss module
	Stop(self, module)
end
