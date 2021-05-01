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
	blockTalkingHeads = {
		false, -- Normal & Heroic Dungeons
		true, -- Mythic & Mythic+ Dungeons
		true, -- Raids
		false, -- Timewalking (Dungeons & Raids)
		true, -- Scenarios
	},
	blockGarrison = true,
	blockGuildChallenge = true,
	blockSpellErrors = true,
	blockTooltipQuests = true,
	blockObjectiveTracker = true,
	disableSfx = false,
	disableMusic = false,
	disableAmbience = false,
	disableErrorSpeech = false,
}

--------------------------------------------------------------------------------
-- Locals
--

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
plugin.displayName = L.bossBlock
local GetBestMapForUnit = BigWigsLoader.GetBestMapForUnit
local GetInstanceInfo = BigWigsLoader.GetInstanceInfo
local GetSubZoneText = GetSubZoneText
local TalkingHeadLineInfo = C_TalkingHead.GetCurrentLineInfo
local IsEncounterInProgress = IsEncounterInProgress
local SetCVar = C_CVar.SetCVar
local GetCVar = C_CVar.GetCVar
local CheckElv = nil
local RestoreAll

-------------------------------------------------------------------------------
-- Options
--

plugin.pluginOptions = {
	name = L.bossBlock,
	desc = L.bossBlockDesc,
	type = "group",
	childGroups = "tab",
	get = function(info)
		return plugin.db.profile[info[#info]]
	end,
	set = function(info, value)
		local entry = info[#info]
		plugin.db.profile[entry] = value
	end,
	disabled = function() return IsEncounterInProgress() end, -- Don't allow toggling during an encounter.
	args = {
		general = {
			type = "group",
			name = L.general,
			order = 1,
			args = {
				heading = {
					type = "description",
					name = L.bossBlockDesc,
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
					hidden = function() return true end, -- XXX Do we want to hack the tooltip?
				},
				blockObjectiveTracker = {
					type = "toggle",
					name = L.blockObjectiveTracker,
					desc = L.blockObjectiveTrackerDesc,
					width = "full",
					order = 7,
				},
				blockTalkingHeads = {
					type = "multiselect",
					name = L.blockTalkingHead,
					desc = L.blockTalkingHeadDesc,
					control = "Dropdown",
					values = {
						L.blockTalkingHeadDungeons,
						L.blockTalkingHeadMythics,
						L.blockTalkingHeadRaids,
						L.blockTalkingHeadTimewalking,
						L.blockTalkingHeadScenarios,
					},
					get = function(info, entry)
						return plugin.db.profile[info[#info]][entry]
					end,
					set = function(info, entry, value)
						plugin.db.profile[info[#info]][entry] = value
					end,
					width = 2,
					order = 8,
				},
			},
		},
		audio = {
			type = "group",
			name = L.audio,
			order = 2,
			args = {
				heading = {
					type = "description",
					name = L.bossBlockAudioDesc,
					order = 0,
					width = "full",
					fontSize = "medium",
				},
				disableMusic = {
					type = "toggle",
					name = L.disableMusic,
					desc = L.disableAudioDesc:format(L.music),
					width = "full",
					order = 1,
					disabled = function()
						if IsEncounterInProgress() then
							return true
						elseif GetCVar("Sound_EnableMusic") == "0" and not plugin.db.profile.disableMusic then
							return true
						end
					end,
				},
				disableAmbience = {
					type = "toggle",
					name = L.disableAmbience,
					desc = L.disableAudioDesc:format(L.ambience),
					width = "full",
					order = 2,
					disabled = function()
						if IsEncounterInProgress() then
							return true
						elseif GetCVar("Sound_EnableAmbience") == "0" and not plugin.db.profile.disableAmbience then
							return true
						end
					end,
				},
				disableErrorSpeech = {
					type = "toggle",
					name = L.disableErrorSpeech,
					desc = L.disableAudioDesc:format(L.errorSpeech),
					width = "full",
					order = 3,
					disabled = function()
						if IsEncounterInProgress() then
							return true
						elseif GetCVar("Sound_EnableErrorSpeech") == "0" and not plugin.db.profile.disableErrorSpeech then
							return true
						end
					end,
				},
				disableSfx = {
					type = "toggle",
					name = L.disableSfx,
					desc = L.disableAudioDesc:format(L.sfx),
					width = "full",
					order = 4,
					disabled = function()
						if IsEncounterInProgress() then
							return true
						elseif GetCVar("Sound_EnableSFX") == "0" and not plugin.db.profile.disableSfx then
							return true
						end
					end,
				},
			},
		},
	},
}

--------------------------------------------------------------------------------
-- Initialization
--

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

		for i = 1, #db.blockTalkingHeads do
			local n = db.blockTalkingHeads[i]
			if type(n) ~= "boolean" then
				db.blockTalkingHeads = plugin.defaultDB.blockTalkingHeads
				break
			end
		end
	end

	function plugin:OnPluginEnable()
		self:RegisterMessage("BigWigs_OnBossEngage", "OnEngage")
		self:RegisterMessage("BigWigs_OnBossEngageMidEncounter", "OnEngage")
		self:RegisterMessage("BigWigs_OnBossWin", "OnWinOrWipe")
		self:RegisterMessage("BigWigs_OnBossWipe", "OnWinOrWipe")
		self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
		updateProfile()

		-- Enable these CVars every time we load just in case some kind of disconnect/etc during the fight left it permanently disabled
		if self.db.profile.disableSfx then
			SetCVar("Sound_EnableSFX", "1")
		end
		--if self.db.profile.blockTooltipQuests then
		--	SetCVar("showQuestTrackingTooltips", "1")
		--end
		if self.db.profile.disableMusic then
			SetCVar("Sound_EnableMusic", "1")
		end
		if self.db.profile.disableAmbience then
			SetCVar("Sound_EnableAmbience", "1")
		end
		if self.db.profile.disableErrorSpeech then
			SetCVar("Sound_EnableErrorSpeech", "1")
		end

		self:RegisterEvent("TALKINGHEAD_REQUESTED")
		self:RegisterEvent("CINEMATIC_START")
		self:RegisterEvent("PLAY_MOVIE")
		self:SiegeOfOrgrimmarCinematics() -- Sexy hack until cinematics have an id system (never)
		self:ToyCheck() -- Sexy hack until cinematics have an id system (never)

		CheckElv(self)
	end
end

function plugin:OnPluginDisable()
	RestoreAll(self)
end

-------------------------------------------------------------------------------
-- Event Handlers
--

do
	local trackerHider = CreateFrame("Frame")
	trackerHider:Hide()
	local unregisteredEvents = {}
	local function KillEvent(frame, event)
		-- The user might be running an addon that permanently unregisters one of these events.
		-- Let's check that before we go re-registering that event and screwing with that addon.
		if trackerHider.IsEventRegistered(frame, event) then
			trackerHider.UnregisterEvent(frame, event)
			unregisteredEvents[event] = true
		end
	end
	local function RestoreEvent(frame, event)
		if unregisteredEvents[event] then
			trackerHider.RegisterEvent(frame, event)
			unregisteredEvents[event] = nil
		end
	end

	function CheckElv(self)
		-- Undo damage by ElvUI (This frame makes the Objective Tracker protected)
		if type(ObjectiveTrackerFrame.AutoHider) == "table" and trackerHider.GetParent(ObjectiveTrackerFrame.AutoHider) == ObjectiveTrackerFrame then
			if InCombatLockdown() or UnitAffectingCombat("player") then
				self:RegisterEvent("PLAYER_REGEN_ENABLED", function()
					trackerHider.SetParent(ObjectiveTrackerFrame.AutoHider, (CreateFrame("Frame")))
					self:UnregisterEvent("PLAYER_REGEN_ENABLED")
				end)
			else
				trackerHider.SetParent(ObjectiveTrackerFrame.AutoHider, (CreateFrame("Frame")))
			end
		end
	end

	local restoreObjectiveTracker = nil
	function plugin:OnEngage(event, module)
		if not module or not module.journalId or module.worldBoss then return end

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
		--if self.db.profile.blockTooltipQuests then
		--	SetCVar("showQuestTrackingTooltips", "0")
		--end
		if self.db.profile.disableMusic then
			SetCVar("Sound_EnableMusic", "0")
		end
		if self.db.profile.disableAmbience then
			SetCVar("Sound_EnableAmbience", "0")
		end
		if self.db.profile.disableErrorSpeech then
			SetCVar("Sound_EnableErrorSpeech", "0")
		end

		CheckElv(self)
		-- Never hide when tracking achievements or in Mythic+
		local _, _, diff = GetInstanceInfo()
		if not restoreObjectiveTracker and self.db.profile.blockObjectiveTracker and not GetTrackedAchievements() and diff ~= 8 and not trackerHider.IsProtected(ObjectiveTrackerFrame) then
			restoreObjectiveTracker = trackerHider.GetParent(ObjectiveTrackerFrame)
			if restoreObjectiveTracker then
				trackerHider.SetFixedFrameStrata(ObjectiveTrackerFrame, true) -- Changing parent would change the strata & level, lock it first
				trackerHider.SetFixedFrameLevel(ObjectiveTrackerFrame, true)
				trackerHider.SetParent(ObjectiveTrackerFrame, trackerHider)
			end
		end
	end

	function RestoreAll(self)
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
		--if self.db.profile.blockTooltipQuests then
		--	SetCVar("showQuestTrackingTooltips", "1")
		--end
		if self.db.profile.disableMusic then
			SetCVar("Sound_EnableMusic", "1")
		end
		if self.db.profile.disableAmbience then
			SetCVar("Sound_EnableAmbience", "1")
		end
		if self.db.profile.disableErrorSpeech then
			SetCVar("Sound_EnableErrorSpeech", "1")
		end
		if restoreObjectiveTracker then
			trackerHider.SetParent(ObjectiveTrackerFrame, restoreObjectiveTracker)
			trackerHider.SetFixedFrameStrata(ObjectiveTrackerFrame, false)
			trackerHider.SetFixedFrameLevel(ObjectiveTrackerFrame, false)
			restoreObjectiveTracker = nil
		end
	end

	function plugin:OnWinOrWipe(event, module)
		if not module or not module.journalId or module.worldBoss then return end
		RestoreAll(self)
	end
end

do
	-- Talking Head blocking
	local known = {
		-- De Other Side
		[163828]=true,[163830]=true,[163831]=true,[163822]=true,[163823]=true,[163824]=true,[163834]=true,
		[163835]=true,[163836]=true,[163837]=true,[163819]=true,[163820]=true,[163821]=true,
		-- The Necrotic Wake
		[155159]=true,[155160]=true,[155161]=true,[154899]=true,[162802]=true,
		[162803]=true,[154900]=true,[155162]=true,[154573]=true,
		-- Mists of Tirna Scithe
		[154205]=true,[157818]=true,[157678]=true,[154209]=true,[154206]=true,[154208]=true,[154207]=true,
		[154211]=true,[157817]=true,[154210]=true,
		-- Sanguine Depths
		[157755]=true,[157747]=true,[157748]=true,[153689]=true,[157761]=true,[153688]=true,
		[153690]=true,[157762]=true,[157752]=true,[157672]=true,[157760]=true,
		-- Spires of Ascension
		[155736]=true,[155737]=true,[155738]=true,[155739]=true,[155740]=true,[155741]=true,[155742]=true,[155743]=true,
		[155744]=true,[155745]=true,[155746]=true,[155747]=true,[155748]=true,[155749]=true,[155750]=true,[155751]=true,
		[155752]=true,[155753]=true,[155754]=true,[160654]=true,[155756]=true,[155757]=true,[155758]=true,[155759]=true,
		-- Theater of Pain
		[152417]=true,[152416]=true,[152415]=true,[152414]=true,[152410]=true,[152409]=true,[152408]=true,[152505]=true,[154933]=true,
		[152533]=true,[154937]=true,[152517]=true,[154942]=true,[154943]=true,[154938]=true,[154939]=true,[154940]=true,[154941]=true,
		-- Plaguefall
		[152641]=true,[152640]=true,[152639]=true,[152615]=true,[152614]=true,[152638]=true,
		[152637]=true,[152636]=true,[152635]=true,[153196]=true,[153197]=true,
	}

	local lookup = {
		[1] = 1, -- Normal Dungeon
		[2] = 1, -- Heroic Dungeon
		[8] = 2, -- Mythic+ Keystone Dungeon
		[23] = 2, -- Mythic Dungeon
		[14] = 3, -- Normal Raid
		[15] = 3, -- Heroic Raid
		[16] = 3, -- Mythic Raid
		[17] = 3, -- LFR
		[24] = 4, -- Timewalking Dungeon
	}
	function plugin:TALKINGHEAD_REQUESTED()
		local _, _, diff = GetInstanceInfo()
		local entry = lookup[diff]
		if entry and self.db.profile.blockTalkingHeads[entry] then
			local _, _, soundKitId = TalkingHeadLineInfo()
			if known[soundKitId] and TalkingHeadFrame and TalkingHeadFrame:IsShown() then
				TalkingHeadFrame:Hide()
			end
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
		[886] = true, -- Queen Azshara defeat
		[927] = true, -- Wrathion introduction to Carapace of N'Zoth
		[926] = true, -- N'Zoth defeat
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
		[-1597] = true, -- N'Zoth defeat
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

