-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("BossBlock")
if not plugin then return end

-------------------------------------------------------------------------------
-- Database
--

plugin.defaultDB = {
	blockEmotes = true,
	blockMovies = true,
	blockGarrison = true,
	blockGuildChallenge = true,
	blockSpellErrors = true,
	blockQuestTrackingTooltips = true,
	hideObjectiveTracker = false,
}

--------------------------------------------------------------------------------
-- Locals
--

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
plugin.displayName = L.bossBlock
local SetMapToCurrentZone = BigWigsLoader.SetMapToCurrentZone
local GetCurrentMapAreaID = BigWigsLoader.GetCurrentMapAreaID
local GetCurrentMapDungeonLevel = BigWigsLoader.GetCurrentMapDungeonLevel
local questTrackingValue = 1 -- default 1 after dc

-------------------------------------------------------------------------------
-- Options
--

plugin.pluginOptions = {
	name = L.bossBlock,
	desc = L.bossBlockDesc,
	type = "group",
	get = function(info)
		return plugin.db.profile[info[#info]]
	end,
	set = function(info, value)
		if IsEncounterInProgress() then return end -- Don't allow toggling during an encounter.
		local entry = info[#info]
		plugin.db.profile[entry] = value
	end,
	args = {
		heading = {
			type = "description",
			name = L.bossBlockDesc.. "\n\n",
			order = 0,
			width = "full",
			fontSize = "medium",
		},
		blockEmotes = {
			type = "toggle",
			name = L.blockEmotes,
			desc = L.blockEmotesDesc,
			width = "full",
			order = 1,
		},
		blockMovies = {
			type = "toggle",
			name = L.blockMovies,
			desc = L.blockMoviesDesc,
			width = "full",
			order = 2,
		},
		blockGarrison = {
			type = "toggle",
			name = L.blockGarrison,
			desc = L.blockGarrisonDesc,
			width = "full",
			order = 3,
		},
		blockGuildChallenge = {
			type = "toggle",
			name = L.blockGuildChallenge,
			desc = L.blockGuildChallengeDesc,
			width = "full",
			order = 4,
		},
		blockSpellErrors = {
			type = "toggle",
			name = L.blockSpellErrors,
			desc = L.blockSpellErrorsDesc,
			width = "full",
			order = 5,
		},
		blockQuestTrackingTooltips = {
			type = "toggle",
			name = L.blockQuestTrackingTooltips,
			desc = L.blockQuestTrackingTooltipsDesc,
			width = "full",
			order = 6,
		},
		hideObjectiveTracker = {
			type = "toggle",
			name = L.hideObjectiveTracker,
			width = "full",
			order = 7,
		},
	},
}

--------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_OnBossEngage")
	self:RegisterMessage("BigWigs_OnBossWin")
	self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossWin")

	if IsEncounterInProgress() then -- Just assume we logged into an encounter after a DC
		self:BigWigs_OnBossEngage()
	end

	self:RegisterEvent("CINEMATIC_START")
	self:RegisterEvent("PLAY_MOVIE")
	self:SiegeOfOrgrimmarCinematics() -- Sexy hack until cinematics have an id system (never)
	questTrackingValue = GetCVar("showQuestTrackingTooltips")
end


function plugin:OnPluginDisable()
	if self.db.profile.blockQuestTrackingTooltips then
		SetCVar("showQuestTrackingTooltips", questTrackingValue)
	end
end

-------------------------------------------------------------------------------
-- Event Handlers
--

do
	local unregisteredEvents = {}
	local function KillEvent(frame, event)
		-- The user might be running an addon that permanently unregisters one of these events.
		-- Let's check that before we go re-registering that event and screwing with that addon.
		if frame:IsEventRegistered(event) then
			frame:UnregisterEvent(event)
			unregisteredEvents[event] = true
		end
	end
	local function RestoreEvent(frame, event)
		if unregisteredEvents[event] then
			frame:RegisterEvent(event)
			unregisteredEvents[event] = nil
		end
	end

	local objectiveTrackerWasCollapsed = false

	function plugin:BigWigs_OnBossEngage()
		if self.db.profile.blockEmotes and not IsTestBuild() then -- Don't block emotes on WoW beta.
			KillEvent(RaidBossEmoteFrame, "RAID_BOSS_EMOTE")
			KillEvent(RaidBossEmoteFrame, "RAID_BOSS_WHISPER")
		end
		if self.db.profile.blockGarrison then
			KillEvent(AlertFrame, "GARRISON_MISSION_FINISHED")
			KillEvent(AlertFrame, "GARRISON_BUILDING_ACTIVATABLE")
			KillEvent(AlertFrame, "GARRISON_FOLLOWER_ADDED")
			KillEvent(AlertFrame, "GARRISON_RANDOM_MISSION_ADDED")
		end
		if self.db.profile.blockGuildChallenge then
			KillEvent(AlertFrame, "GUILD_CHALLENGE_COMPLETED")
		end
		if self.db.profile.blockSpellErrors then
			KillEvent(UIErrorsFrame, "UI_ERROR_MESSAGE")
		end
		if self.db.profile.blockQuestTrackingTooltips then
			SetCVar("showQuestTrackingTooltips", 0)
		end
		if self.db.profile.hideObjectiveTracker and IsInRaid() then
			objectiveTrackerWasCollapsed = ObjectiveTrackerFrame.collapsed
			if not objectiveTrackerWasCollapsed then
				ObjectiveTracker_Collapse()
			end
		end
	end

	function plugin:BigWigs_OnBossWin()
		if self.db.profile.blockEmotes then
			RestoreEvent(RaidBossEmoteFrame, "RAID_BOSS_EMOTE")
			RestoreEvent(RaidBossEmoteFrame, "RAID_BOSS_WHISPER")
		end
		if self.db.profile.blockGarrison then
			RestoreEvent(AlertFrame, "GARRISON_MISSION_FINISHED")
			RestoreEvent(AlertFrame, "GARRISON_BUILDING_ACTIVATABLE")
			RestoreEvent(AlertFrame, "GARRISON_FOLLOWER_ADDED")
			RestoreEvent(AlertFrame, "GARRISON_RANDOM_MISSION_ADDED")
		end
		if self.db.profile.blockGuildChallenge then
			RestoreEvent(AlertFrame, "GUILD_CHALLENGE_COMPLETED")
		end
		if self.db.profile.blockSpellErrors then
			RestoreEvent(UIErrorsFrame, "UI_ERROR_MESSAGE")
		end
		if self.db.profile.blockQuestTrackingTooltips then
			SetCVar("showQuestTrackingTooltips", questTrackingValue)
		end
		if self.db.profile.hideObjectiveTracker and not objectiveTrackerWasCollapsed and IsInRaid() then
			ObjectiveTracker_Expand()
			ObjectiveTracker_Update()
		end
	end
end

do
	-- Movie blocking
	local knownMovies = {
		[16] = true, -- Lich King death
		[73] = true, -- Ultraxion death
		[74] = true, -- DeathwingSpine engage
		[75] = true, -- DeathwingSpine death
		[76] = true, -- DeathwingMadness death
		[152] = true, -- Garrosh defeat
		[294] = true, -- Archimonde portal
		[295] = true, -- Archimonde kill
		[549] = true, -- Gul'dan kill
		[656] = true, -- Kil'jaeden kill
		[682] = true, -- L'uras death
		[686] = true, -- Argus portal
		[688] = true, -- Argus kill
	}

	function plugin:PLAY_MOVIE(_, id)
		if knownMovies[id] and self.db.profile.blockMovies then
			if BigWigs.db.global.watchedMovies[id] then
				BigWigs:Print(L.movieBlocked)
				MovieFrame:Hide()
			else
				BigWigs.db.global.watchedMovies[id] = true
			end
		end
	end
end

do
	-- Cinematic blocking
	local cinematicZones = {
		["800:1"] = true, -- Firelands bridge lowering
		["875:1"] = true, -- Gate of the Setting Sun gate breach
		["930:3"] = true, -- Tortos cave entry -- Doesn't work, apparently Blizzard don't want us to skip this..?
		["930:7"] = true, -- Ra-Den room opening
		["953:2"] = true, -- After Immerseus, entry to Fallen Protectors
		["953:8"] = true, -- Blackfuse room opening, just outside the door
		["953:9"] = true, -- Blackfuse room opening, in Thok area
		["953:12"] = true, -- Mythic Garrosh Phase 4
		["964:1"] = true, -- Bloodmaul Slag Mines, activating bridge to Roltall
		["969:2"] = true, -- Shadowmoon Burial Grounds, final boss introduction
		["984:1"] = {false, -1, true}, -- Auchindoun has 2 cinematics. One before the 1st boss (false) and one after the 3rd boss (true), 2nd arg is garbage for the iterator to work.
		["993:2"] = true, -- Grimrail Depot, boarding the train
		["993:4"] = true, -- Grimrail Depot, destroying the train
		["994:3"] = true, -- Highmaul, Kargath Death
		["1042:1"] = true, -- Maw of Souls, after Ymiron
		["1147:6"] = true, -- Tomb of Sargeras, portal to Kil'jaeden
		["1188:1"] = true, -- Antorus, teleportation to "The exhaust"
		["1188:6"] = true, -- Antorus, teleportation to "The burning throne"
		["1188:9"] = true, -- Antorus, magni portal to argus room
	}

	-- Cinematic skipping hack to workaround an item (Vision of Time) that creates cinematics in Siege of Orgrimmar.
	function plugin:SiegeOfOrgrimmarCinematics()
		local hasItem
		for i = 105930, 105935 do -- Vision of Time items
			local _, _, cd = GetItemCooldown(i)
			if cd > 0 then hasItem = true end -- Item is found in our inventory
		end
		if hasItem and not self.SiegeOfOrgrimmarCinematicsFrame then
			local tbl = {[149370] = true, [149371] = true, [149372] = true, [149373] = true, [149374] = true, [149375] = true}
			self.SiegeOfOrgrimmarCinematicsFrame = CreateFrame("Frame")
			-- frame:UNIT_SPELLCAST_SUCCEEDED:player:Vision of Time Scene 2::227:149371:
			self.SiegeOfOrgrimmarCinematicsFrame:SetScript("OnEvent", function(_, _, _, _, _, _, spellId)
				if tbl[spellId] then
					plugin:UnregisterEvent("CINEMATIC_START")
					plugin:ScheduleTimer("RegisterEvent", 10, "CINEMATIC_START")
				end
			end)
			self.SiegeOfOrgrimmarCinematicsFrame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
		end
	end

	function plugin:CINEMATIC_START()
		if self.db.profile.blockMovies then
			SetMapToCurrentZone()
			local areaId = GetCurrentMapAreaID() or 0
			local areaLevel = GetCurrentMapDungeonLevel() or 0
			local id = ("%d:%d"):format(areaId, areaLevel)

			if cinematicZones[id] then
				if type(cinematicZones[id]) == "table" then -- For zones with more than 1 cinematic per floor
					if type(BigWigs.db.global.watchedMovies[id]) ~= "table" then BigWigs.db.global.watchedMovies[id] = {} end
					for i=#cinematicZones[id], 1, -1 do -- In reverse so for example: we don't trigger off the first boss when at the third boss
						local _, _, done = C_Scenario.GetCriteriaInfoByStep(1,i)
						if done == cinematicZones[id][i] then
							if BigWigs.db.global.watchedMovies[id][i] then
								BigWigs:Print(L.movieBlocked)
								CinematicFrame_CancelCinematic()
							else
								BigWigs.db.global.watchedMovies[id][i] = true
							end
							return
						end
					end
				else
					if BigWigs.db.global.watchedMovies[id] then
						BigWigs:Print(L.movieBlocked)
						CinematicFrame_CancelCinematic()
					else
						BigWigs.db.global.watchedMovies[id] = true
					end
				end
			end
		end
	end
end
