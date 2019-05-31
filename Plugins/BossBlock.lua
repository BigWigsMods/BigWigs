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
	blockTooltipQuests = true,
	blockObjectiveTracker = true,
	disableSfx = false,
}

--------------------------------------------------------------------------------
-- Locals
--

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
plugin.displayName = L.bossBlock
local GetBestMapForUnit = BigWigsLoader.GetBestMapForUnit
local GetSubZoneText = GetSubZoneText
local SetCVar = C_CVar.SetCVar

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
			name = L.blockFollowerMission,
			desc = L.blockFollowerMissionDesc,
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
		blockTooltipQuests = {
			type = "toggle",
			name = L.blockTooltipQuests,
			desc = L.blockTooltipQuestsDesc,
			width = "full",
			order = 6,
		},
		blockObjectiveTracker = {
			type = "toggle",
			name = L.blockObjectiveTracker,
			desc = L.blockObjectiveTrackerDesc,
			width = "full",
			order = 7,
		},
		disableSfx = {
			type = "toggle",
			name = L.disableSfx,
			desc = L.disableSfxDesc,
			width = "full",
			order = 8,
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

	-- Enable these CVars every time we load just in case some kind of disconnect/etc during the fight left it permanently disabled
	if self.db.profile.disableSfx then
		SetCVar("Sound_EnableSFX", "1")
	end
	if self.db.profile.blockTooltipQuests then
		SetCVar("showQuestTrackingTooltips", "1")
	end

	if IsEncounterInProgress() then -- Just assume we logged into an encounter after a DC
		self:BigWigs_OnBossEngage()
	end

	self:RegisterEvent("CINEMATIC_START")
	self:RegisterEvent("PLAY_MOVIE")
	self:SiegeOfOrgrimmarCinematics() -- Sexy hack until cinematics have an id system (never)
	self:ToyCheck() -- Sexy hack until cinematics have an id system (never)

	-- XXX temp 8.1.5
	for id in next, BigWigs.db.global.watchedMovies do
		if type(id) == "string" then
			BigWigs.db.global.watchedMovies[id] = nil
		end
	end
	BigWigs.db.global.watchedMovies[-593] = nil -- Auchindoun temp reset
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

	local restoreObjectiveTracker = false
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
		if self.db.profile.disableSfx then
			SetCVar("Sound_EnableSFX", "0")
		end
		if self.db.profile.blockTooltipQuests then
			SetCVar("showQuestTrackingTooltips", "0")
		end
		-- Never hide when tracking achievements or in Mythic+
		local _, _, diff = GetInstanceInfo()
		if self.db.profile.blockObjectiveTracker and not GetTrackedAchievements() and diff ~= 8
		and ObjectiveTrackerFrame and ObjectiveTrackerFrame:IsShown() and not ObjectiveTrackerFrame.collapsed then
			restoreObjectiveTracker = true
			ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:Click()
			local _, id = PlaySound(856, nil, false)
			StopSound(id - 1)
			StopSound(id)
			ObjectiveTrackerFrame.HeaderMenu:SetAlpha(0)
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
		if self.db.profile.disableSfx then
			SetCVar("Sound_EnableSFX", "1")
		end
		if self.db.profile.blockTooltipQuests then
			SetCVar("showQuestTrackingTooltips", "1")
		end
		if restoreObjectiveTracker then
			restoreObjectiveTracker = false
			ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:Click()
			local _, id = PlaySound(856, nil, false)
			StopSound(id - 1)
			StopSound(id)
			ObjectiveTrackerFrame.HeaderMenu:SetAlpha(1)
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
		[875] = true, -- Killing King Rastakhan
		[876] = true, -- Entering Battle of Dazar'alor
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
		[-323] = true, -- Throne of the Tides, zapping the squid after Lazy Naz'jar
		[-367] = true, -- Firelands bridge lowering
		[-437] = true, -- Gate of the Setting Sun gate breach
		[-510] = true, -- Tortos cave entry -- Doesn't work, apparently Blizzard don't want us to skip this..?
		[-514] = true, -- Ra-Den room opening
		[-557] = true, -- After Immerseus, entry to Fallen Protectors
		[-563] = true, -- Blackfuse room opening, just outside the door
		[-564] = true, -- Blackfuse room opening, in Thok area
		[-567] = true, -- Mythic Garrosh Phase 4
		[-573] = true, -- Bloodmaul Slag Mines, activating bridge to Roltall
		[-575] = true, -- Shadowmoon Burial Grounds, final boss introduction
		[-593] = { -- Auchindoun
			"", -- "": Before the 1st boss, the tunnel doesn't have a sub zone
			L.subzone_eastern_transept, -- Eastern Transept: After the 3rd boss, Teren'gor porting in
		},
		[-607] = true, -- Grimrail Depot, boarding the train
		[-609] = true, -- Grimrail Depot, destroying the train
		[-612] = true, -- Highmaul, Kargath Death
		[-706] = true, -- Maw of Souls, after Ymiron
		[-855] = true, -- Tomb of Sargeras, portal to Kil'jaeden
		[-909] = true, -- Antorus, teleportation to "The exhaust"
		[-914] = true, -- Antorus, teleportation to "The burning throne"
		[-917] = true, -- Antorus, magni portal to argus room
		[-1004] = true, -- Kings' Rest, before the last boss "Dazar"
		[-1151] = true, -- Uldir, raising stairs for Zul (Zek'voz)
		[-1152] = true, -- Uldir, raising stairs for Zul (Vectis)
		[-1153] = true, -- Uldir, raising stairs for Zul (Fetid Devourer)
		[-1345] = true, -- Crucible of Storms, after killing first boss
		[-1352] = { -- Battle of Dazar'alor
			L.subzone_grand_bazaar, -- Grand Bazaar: After killing 2nd boss, Bwonsamdi (Alliance side only)
			L.subzone_port_of_zandalar, -- Port of Zandalar: After killing blockade, boat arriving
		},
		[-1358] = true, -- Battle of Dazar'alor, after killing 1st boss, Bwonsamdi (Horde side only)
		--[-1364] = true, -- Battle of Dazar'alor, Jaina stage 1 intermission (unskippable)
	}

	-- Cinematic skipping hack to workaround an item (Vision of Time) that creates cinematics in Siege of Orgrimmar.
	function plugin:SiegeOfOrgrimmarCinematics()
		local hasItem
		for i = 105930, 105935 do -- Vision of Time items
			local count = GetItemCount(i)
			if count > 0 then hasItem = true break end -- Item is found in our inventory
		end
		if hasItem and not self.SiegeOfOrgrimmarCinematicsFrame then
			local tbl = {[149370] = true, [149371] = true, [149372] = true, [149373] = true, [149374] = true, [149375] = true}
			self.SiegeOfOrgrimmarCinematicsFrame = CreateFrame("Frame")
			-- frame:UNIT_SPELLCAST_SUCCEEDED:player:Cast-GUID:149371:
			self.SiegeOfOrgrimmarCinematicsFrame:SetScript("OnEvent", function(_, _, _, _, spellId)
				if tbl[spellId] and plugin:IsEnabled() then
					plugin:UnregisterEvent("CINEMATIC_START")
					plugin:ScheduleTimer("RegisterEvent", 10, "CINEMATIC_START")
				end
			end)
			self.SiegeOfOrgrimmarCinematicsFrame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
		end
	end

	-- Cinematic skipping hack to workaround specific toys that create cinematics.
	function plugin:ToyCheck()
		local toys = { -- Classed as items not toys
			133542, -- Tosselwrench's Mega-Accurate Simulation Viewfinder
		}
		for i = 1, #toys do
			if PlayerHasToy(toys[i]) and not self.toysFrame then
				local tbl = {
					[201179] = true -- Deathwing Simulator
				}
				self.toysFrame = CreateFrame("Frame")
				-- frame:UNIT_SPELLCAST_SUCCEEDED:player:Cast-GUID:149371:
				self.toysFrame:SetScript("OnEvent", function(_, _, _, _, spellId)
					if tbl[spellId] and plugin:IsEnabled() then
						plugin:UnregisterEvent("CINEMATIC_START")
						plugin:ScheduleTimer("RegisterEvent", 5, "CINEMATIC_START")
					end
				end)
				self.toysFrame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
			end
		end
	end

	function plugin:CINEMATIC_START()
		if self.db.profile.blockMovies then
			local id = -(GetBestMapForUnit("player") or 0)

			if cinematicZones[id] then
				if type(cinematicZones[id]) == "table" then -- For zones with more than 1 cinematic per map id
					if type(BigWigs.db.global.watchedMovies[id]) ~= "table" then BigWigs.db.global.watchedMovies[id] = {} end
					for i = 1, #cinematicZones[id] do
						local subZone = cinematicZones[id][i]
						if subZone == GetSubZoneText() then
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

