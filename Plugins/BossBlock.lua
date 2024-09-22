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
	blockZoneChanges = true,
	blockTooltipQuestText = true,
	blockObjectiveTracker = true,
	disableSfx = false,
	disableMusic = false,
	disableAmbience = false,
	disableErrorSpeech = false,
	redirectTheToasts = true,
	toastsColor = {0.2, 1, 1},
	blockZoneInToasts = true,
}

--------------------------------------------------------------------------------
-- Locals
--

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
plugin.displayName = L.bossBlock
local GetBestMapForUnit = BigWigsLoader.GetBestMapForUnit
local GetInstanceInfo = BigWigsLoader.GetInstanceInfo
local zoneList = BigWigsLoader.zoneTbl
local isTestBuild = BigWigsLoader.isTestBuild
local isClassic = BigWigsLoader.isClassic
local isVanilla = BigWigsLoader.isVanilla
local GetSubZoneText = GetSubZoneText
local TalkingHeadLineInfo = C_TalkingHead and C_TalkingHead.GetCurrentLineInfo
local GetNextToastToDisplay = C_EventToastManager and C_EventToastManager.GetNextToastToDisplay
local RemoveCurrentToast = C_EventToastManager and C_EventToastManager.RemoveCurrentToast
local IsEncounterInProgress = IsEncounterInProgress
local SetCVar = C_CVar.SetCVar
local GetCVar = C_CVar.GetCVar
local GetTime = GetTime
local CheckElv = nil
local RestoreAll
local hideQuestTrackingTooltips = false
local activatedModules = {}
local latestKill = {}
local bbFrame = CreateFrame("Frame")
bbFrame:Hide()

-------------------------------------------------------------------------------
-- Options
--

plugin.pluginOptions = {
	name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Block:20|t ".. L.bossBlock,
	desc = L.bossBlockDesc,
	type = "group",
	childGroups = "tab",
	order = 10,
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
					hidden = isVanilla,
				},
				blockGarrison = {
					type = "toggle",
					name = L.blockFollowerMission,
					desc = L.blockFollowerMissionDesc,
					width = "full",
					order = 3,
					hidden = isClassic,
				},
				blockGuildChallenge = {
					type = "toggle",
					name = L.blockGuildChallenge,
					desc = L.blockGuildChallengeDesc,
					width = "full",
					order = 4,
					hidden = isClassic,
				},
				blockSpellErrors = {
					type = "toggle",
					name = L.blockSpellErrors,
					desc = L.blockSpellErrorsDesc,
					width = "full",
					order = 5,
				},
				blockZoneChanges = {
					type = "toggle",
					name = L.blockZoneChanges,
					desc = L.blockZoneChangesDesc,
					width = "full",
					order = 6,
				},
				blockTooltipQuestText = {
					type = "toggle",
					name = L.blockTooltipQuests,
					desc = L.blockTooltipQuestsDesc,
					width = "full",
					order = 7,
					hidden = GameTooltip and not GameTooltip.IsTooltipType, -- TooltipDataProcessor doesn't exist on classic
				},
				blockObjectiveTracker = {
					type = "toggle",
					name = L.blockObjectiveTracker,
					desc = L.blockObjectiveTrackerDesc,
					width = "full",
					order = 8,
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
					order = 9,
					hidden = isClassic,
				},
				blockZoneInToasts = {
					type = "toggle",
					name = L.blockDungeonPopups,
					desc = L.blockDungeonPopupsDesc,
					width = "full",
					order = 10,
					hidden = isClassic,
				},
				toastsCategory = {
					type = "group",
					name = " ",
					order = 11,
					inline = true,
					hidden = isClassic,
					args = {
						redirectTheToasts = {
							type = "toggle",
							name = L.redirectPopups,
							desc = L.redirectPopupsDesc,
							width = "full",
							order = 1,
						},
						toastsColor = {
							type = "color",
							name = L.redirectPopupsColor,
							get = function()
								return plugin.db.profile.toastsColor[1], plugin.db.profile.toastsColor[2], plugin.db.profile.toastsColor[3]
							end,
							set = function(_, r, g, b)
								plugin.db.profile.toastsColor = {r, g, b}
							end,
							width = "full",
							order = 2,
							disabled = function()
								return not plugin.db.profile.redirectTheToasts
							end,
						},
					},
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
	local function ShouldFilterQuestProgress(tooltip)
		if tooltip == GameTooltip and tooltip:IsTooltipType(2) then -- Enum.TooltipDataType.Unit
			return hideQuestTrackingTooltips
		end
	end
	function plugin:OnRegister()
		if TooltipDataProcessor and GameTooltip and GameTooltip.IsTooltipType then
			TooltipDataProcessor.AddLinePreCall(8, ShouldFilterQuestProgress) -- Enum.TooltipDataLineType.QuestObjective
			TooltipDataProcessor.AddLinePreCall(17, ShouldFilterQuestProgress) -- Enum.TooltipDataLineType.QuestTitle
			TooltipDataProcessor.AddLinePreCall(18, ShouldFilterQuestProgress) -- Enum.TooltipDataLineType.QuestPlayer
		end
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

		for i = 1, #db.blockTalkingHeads do
			local n = db.blockTalkingHeads[i]
			if type(n) ~= "boolean" then
				db.blockTalkingHeads = plugin.defaultDB.blockTalkingHeads
				break -- If 1 entry is bad, reset the whole table
			end
		end
		for i = 1, 3 do
			local n = db.toastsColor[i]
			if type(n) ~= "number" or n < 0 or n > 1 then
				db.toastsColor = plugin.defaultDB.toastsColor
				break -- If 1 entry is bad, reset the whole table
			end
		end
	end

	function plugin:OnPluginEnable()
		self:RegisterMessage("BigWigs_OnBossEngage", "OnEngage")
		self:RegisterMessage("BigWigs_OnBossEngageMidEncounter", "OnEngage")
		self:RegisterMessage("BigWigs_OnBossWin")
		self:RegisterMessage("BigWigs_OnBossDisable")
		self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossDisable")
		self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
		updateProfile()

		-- Enable these CVars every time we load just in case some kind of disconnect/etc during the fight left it permanently disabled
		-- Additionally, notify the user if a CVar has been force enabled by BossBlock.
		if self.db.profile.disableSfx then
			local sfx = GetCVar("Sound_EnableSFX")
			if sfx == "0" then
				BigWigs:Print(L.userNotifySfx)
			end
			SetCVar("Sound_EnableSFX", "1")
		end
		if self.db.profile.disableMusic then
			local music = GetCVar("Sound_EnableMusic")
			if music == "0" then
				BigWigs:Print(L.userNotifyMusic)
			end
			SetCVar("Sound_EnableMusic", "1")
		end
		if self.db.profile.disableAmbience then
			local ambience = GetCVar("Sound_EnableAmbience")
			if ambience == "0" then
				BigWigs:Print(L.userNotifyAmbience)
			end
			SetCVar("Sound_EnableAmbience", "1")
		end
		if self.db.profile.disableErrorSpeech then
			local errorSpeech = GetCVar("Sound_EnableErrorSpeech")
			if errorSpeech == "0" then
				BigWigs:Print(L.userNotifyErrorSpeech)
			end
			SetCVar("Sound_EnableErrorSpeech", "1")
		end

		if not isVanilla then
			self:RegisterEvent("CINEMATIC_START")
			self:RegisterEvent("PLAY_MOVIE")
			self:SiegeOfOrgrimmarCinematics() -- Sexy hack until cinematics have an id system (never)
			self:ToyCheck() -- Sexy hack until cinematics have an id system (never)
		end

		if not isClassic then
			local _, _, _, _, _, _, _, id = GetInstanceInfo()
			if zoneList[id] then -- Instances only
				local registeredToasts = {GetFramesRegisteredForEvent("DISPLAY_EVENT_TOASTS")}
				for i = 1, #registeredToasts do
					bbFrame.UnregisterEvent(registeredToasts[i], "DISPLAY_EVENT_TOASTS")
				end
				self:RegisterEvent("DISPLAY_EVENT_TOASTS")
				for i = 1, #registeredToasts do
					bbFrame.RegisterEvent(registeredToasts[i], "DISPLAY_EVENT_TOASTS")
				end
			end
			self:RegisterEvent("TALKINGHEAD_REQUESTED")
			local frame = ObjectiveTrackerFrame
			if type(frame) == "table" and type(frame.GetObjectType) == "function" then
				CheckElv(self, frame)
			end
		elseif not isVanilla then
			local frame = WatchFrame
			if type(frame) == "table" and type(frame.GetObjectType) == "function" then
				CheckElv(self, frame)
			end
		end
	end
end

function plugin:OnPluginDisable()
	activatedModules = {}
	latestKill = {}
	RestoreAll(self)
end

-------------------------------------------------------------------------------
-- Event Handlers
--

do
	local delayedTbl = nil
	local levelUpTbl, gainLifeTbl = nil, nil
	local CL = BigWigsAPI:GetLocale("BigWigs: Common")
	local function printMessage(self, tbl)
		if delayedTbl and tbl == delayedTbl then
			plugin:UnregisterEvent("ITEM_DATA_LOAD_RESULT")
			local concatTbl = {}
			for i = 1, #delayedTbl do
				local entryTbl = delayedTbl[i]
				if entryTbl.subtitle then
					concatTbl[#concatTbl+1] = entryTbl.subtitle
				end
			end
			if concatTbl[1] then
				local itemLevels = table.concat(concatTbl, L.comma, 1, #concatTbl)
				local msg = CL.other:format(tbl.title, itemLevels)
				self:SendMessage("BigWigs_Message", self, nil, msg, self.db.profile.toastsColor, nil, nil, tbl.bwDuration)
				if type(tbl.showSoundKitID) == "number" then
					PlaySound(tbl.showSoundKitID)
				end
			end
			delayedTbl = nil
			return
		end

		local icon = type(tbl.iconFileID) == "number" and tbl.iconFileID or nil
		if type(tbl.title) == "string" and #tbl.title > 2 then
			self:SendMessage("BigWigs_Message", self, nil, (tbl.title):upper(), self.db.profile.toastsColor, icon, nil, tbl.bwDuration)
		end
		if type(tbl.subtitle) == "string" and #tbl.subtitle > 2 then
			self:SendMessage("BigWigs_Message", self, nil, tbl.subtitle, self.db.profile.toastsColor, icon, nil, tbl.bwDuration)
		end
		if type(tbl.instructionText) == "string" and #tbl.instructionText > 2 then
			self:SendMessage("BigWigs_Message", self, nil, tbl.instructionText, self.db.profile.toastsColor, icon, nil, tbl.bwDuration)
		end
		if type(tbl.showSoundKitID) == "number" then
			PlaySound(tbl.showSoundKitID)
		end
	end
	local branSkills = {
		[222]=true,[217]=true,[212]=true,[260]=true,[220]=true,[219]=true,[218]=true,[221]=true,[223]=true,
		[213]=true,[215]=true,[178]=true,[209]=true,[214]=true,[216]=true,
		[208]=true,[211]=true,[224]=true,[225]=true,[210]=true,
	}
	function plugin:DISPLAY_EVENT_TOASTS()
		local tbl = GetNextToastToDisplay()
		if tbl then
			if tbl.eventToastID == 5 then -- Zone in popup
				if self.db.profile.blockZoneInToasts then
					-- We just kill zone in toasts, nothing useful to redirect
					RemoveCurrentToast()
					self:DISPLAY_EVENT_TOASTS()
				end
			elseif self.db.profile.redirectTheToasts then
				if tbl.eventToastID == 184 then -- Vault unlocked
					-- tbl.title is "GREAT VAULT SLOT UNLOCKED"
					-- tbl.subtitle is "Complete 3 Delves or World Activities"
					tbl.subtitle = CL.other:format(tbl.title, tbl.subtitle) -- Combine, without uppercase
					tbl.title = nil
					tbl.bwDuration = 4
					self:SimpleTimer(function() printMessage(self, tbl) end, 5) -- Delay a little bit after the boss dies
				elseif tbl.eventToastID == 185 then -- Vault upgraded
					-- tbl.title is "GREAT VAULT SLOT UPGRADED"
					-- tbl.subtitle is a random item to fetch ilvl info from "[Leggings of the Greatlynx]"
					if type(tbl.subtitle) == "string" then
						local itemID = C_Item.GetItemIDForItemInfo(tbl.subtitle)
						if type(itemID) == "number" then
							self:RegisterEvent("ITEM_DATA_LOAD_RESULT")
							if not delayedTbl then
								delayedTbl = {title = tbl.title, showSoundKitID = tbl.showSoundKitID, bwDuration = 4}
							end
							tbl.title = tbl.subtitle
							tbl.subtitle = nil
							delayedTbl[#delayedTbl+1] = tbl
							tbl.bwItemID = itemID
							C_Item.RequestLoadItemDataByID(itemID)
						end
					end
				elseif tbl.eventToastID == 1 then -- Level up
					-- tbl.title is "Level 42"
					-- tbl.subtitle is "You've Reached"
					tbl.subtitle = nil -- Remove "You've Reached" text
					tbl.bwDuration = 4.5
					levelUpTbl = tbl
					self:SimpleTimer(function() levelUpTbl = nil printMessage(self, tbl) end, 0.5) -- Delay to allow time for the talent point toast to merge, if one is rewarded
				elseif tbl.eventToastID == 156 or tbl.eventToastID == 200 then -- Talent point, Hero talent point
					-- tbl.title is "New Talent Point Available" / "New Hero Talent Point Available"
					-- tbl.subtitle is "Your power increased!"
					if levelUpTbl then -- We merge this into the level up toast
						levelUpTbl.subtitle = CL.other:format((levelUpTbl.title):upper(), tbl.title) -- Combine, without uppercase
						levelUpTbl.title = nil
						levelUpTbl.iconFileID = tbl.iconFileID
					end
				elseif tbl.eventToastID == 3 then -- New ability
					-- tbl.title is "Imprison"
					-- tbl.subtitle is "New Ability Unlocked!"
					tbl.subtitle = CL.other:format(tbl.subtitle, tbl.title) -- Combine, without uppercase
					tbl.title = nil
					tbl.bwDuration = 4.5
					self:SimpleTimer(function() printMessage(self, tbl) end, 0.6) -- Show after the level up toast
				elseif tbl.eventToastID == 2 or tbl.eventToastID == 51 then -- Dungeon, Battleground
					-- tbl.title is "Ara-Kara, City of Echoes" / "Twin Peaks"
					-- tbl.subtitle is "Dungeon Unlocked!" / "Battleground Unlocked!"
					tbl.subtitle = CL.other:format(tbl.subtitle, tbl.title) -- Combine, without uppercase
					tbl.title = nil
					tbl.bwDuration = 2.5
					self:SimpleTimer(function() printMessage(self, tbl) end, 5) -- Show after the level up and ability toast
				elseif tbl.eventToastID == 183 then -- Discovery
					-- tbl.title is "Discovery"
					-- tbl.subtitle is "Respawn Point Unlocked!"
					tbl.title = nil -- Remove title, keep subtitle only
					tbl.bwDuration = 4
					gainLifeTbl = tbl
					self:SimpleTimer(function() gainLifeTbl = nil printMessage(self, tbl) end, 0.5) -- Delay to allow time for the +1 life toast to merge, if one is rewarded
				elseif tbl.eventToastID == 263 then -- +1 Life
					-- tbl.title is "+1 Life"
					if gainLifeTbl then -- We merge this into the discovery/respawn toast
						gainLifeTbl.subtitle = CL.extra:format(gainLifeTbl.subtitle, tbl.title) -- Combine
						gainLifeTbl.iconFileID = tbl.iconFileID
					end
				elseif tbl.eventToastID == 256 or tbl.eventToastID == 258 then -- 0 lives / 1 life remaining
					-- tbl.title is "0 Lives Remaining" / "One Life Remaining!"
					tbl.subtitle = tbl.title
					tbl.title = nil
					tbl.bwDuration = 3
					printMessage(self, tbl)
				elseif branSkills[tbl.eventToastID] then -- Brann Ability, Brann power increase
					-- tbl.title is "Combat Curios" / "Explorer's Ammunition Journal"
					-- tbl.subtitle is "Brann Ability Unlocked!" / "Brann's power increased!"
					tbl.subtitle = CL.other:format(tbl.subtitle, tbl.title) -- Combine, without uppercase
					tbl.title = nil
					tbl.bwDuration = 3
					printMessage(self, tbl)
				elseif tbl.eventToastID == 199 then -- Feature unlock
					-- tbl.title is "Hero Talents"
					-- tbl.subtitle is "Feature Unlocked!"
					-- We just hide this as we already show that you unlocked a point alongside the level up message
					tbl.title = nil
				else -- Something we don't support, pass to Blizz to process
					return
				end
				RemoveCurrentToast()
				self:DISPLAY_EVENT_TOASTS()
			end
		end
	end
	local GetDetailedItemLevelInfo = C_Item and C_Item.GetDetailedItemLevelInfo or GetDetailedItemLevelInfo
	function plugin:ITEM_DATA_LOAD_RESULT(_, id, success)
		if delayedTbl then
			for i = 1, #delayedTbl do
				local tbl = delayedTbl[i]
				if tbl.bwItemID == id and not tbl.bwDone then
					tbl.bwDone = true
					if not delayedTbl.bwTimer then
						delayedTbl.bwTimer = true
						self:SimpleTimer(function() printMessage(self, delayedTbl) end, 5)
					end
					local itemLevel = success and GetDetailedItemLevelInfo(tbl.title) or 0
					tbl.subtitle = L.itemLevel:format(itemLevel)
					return
				end
			end
		end
	end
end

do
	local unregisteredEvents = {}
	local function KillEvent(frame, event)
		-- The user might be running an addon that permanently unregisters one of these events.
		-- Let's check that before we go re-registering that event and screwing with that addon.
		if bbFrame.IsEventRegistered(frame, event) then
			bbFrame.UnregisterEvent(frame, event)
			unregisteredEvents[event] = true
		end
	end
	local function RestoreEvent(frame, event)
		if unregisteredEvents[event] then
			bbFrame.RegisterEvent(frame, event)
			unregisteredEvents[event] = nil
		end
	end

	function CheckElv(self, targetFrame)
		-- Undo damage by ElvUI (This frame makes the Objective Tracker protected)
		if type(targetFrame.AutoHider) == "table" and type(targetFrame.AutoHider.GetObjectType) == "function" and bbFrame.GetParent(targetFrame.AutoHider) == targetFrame then
			if InCombatLockdown() or UnitAffectingCombat("player") then
				self:RegisterEvent("PLAYER_REGEN_ENABLED", function()
					bbFrame.SetParent(targetFrame.AutoHider, (CreateFrame("Frame")))
					self:UnregisterEvent("PLAYER_REGEN_ENABLED")
				end)
			else
				bbFrame.SetParent(targetFrame.AutoHider, (CreateFrame("Frame")))
			end
		end
	end

	local function EditEmotesOnPTR(event, msg, ...)
		msg = "BigWigs PTR [E]: ".. msg
		RaidBossEmoteFrame_OnEvent(RaidBossEmoteFrame, event, msg, ...)
	end

	local function EditWhispersOnPTR(event, msg, ...)
		msg = "BigWigs PTR [W]: ".. msg
		RaidBossEmoteFrame_OnEvent(RaidBossEmoteFrame, event, msg, ...)
	end

	local restoreObjectiveTracker = nil
	function plugin:OnEngage(_, module)
		if not module or (not module:GetJournalID() and not module:GetAllowWin()) or module.worldBoss then return end
		if next(activatedModules) then
			activatedModules[module] = true
			return
		else
			activatedModules[module] = true
		end

		if isTestBuild then -- Don't block emotes on WoW PTR
			KillEvent(RaidBossEmoteFrame, "RAID_BOSS_EMOTE")
			KillEvent(RaidBossEmoteFrame, "RAID_BOSS_WHISPER")
			self:RegisterEvent("RAID_BOSS_EMOTE", EditEmotesOnPTR)
			self:RegisterEvent("RAID_BOSS_WHISPER", EditWhispersOnPTR)
		elseif self.db.profile.blockEmotes then
			KillEvent(RaidBossEmoteFrame, "RAID_BOSS_EMOTE")
			KillEvent(RaidBossEmoteFrame, "RAID_BOSS_WHISPER")
		end
		if self.db.profile.blockGarrison and not isClassic then
			KillEvent(AlertFrame, "GARRISON_MISSION_FINISHED")
			KillEvent(AlertFrame, "GARRISON_BUILDING_ACTIVATABLE")
			KillEvent(AlertFrame, "GARRISON_FOLLOWER_ADDED")
			KillEvent(AlertFrame, "GARRISON_RANDOM_MISSION_ADDED")
		end
		if self.db.profile.blockGuildChallenge and not isClassic then
			KillEvent(AlertFrame, "GUILD_CHALLENGE_COMPLETED")
		end
		if self.db.profile.blockSpellErrors then
			KillEvent(UIErrorsFrame, "UI_ERROR_MESSAGE")
		end
		if self.db.profile.blockZoneChanges then
			KillEvent(ZoneTextFrame, "ZONE_CHANGED")
			KillEvent(ZoneTextFrame, "ZONE_CHANGED_INDOORS")
			KillEvent(ZoneTextFrame, "ZONE_CHANGED_NEW_AREA")
		end
		if self.db.profile.blockTooltipQuestText then
			hideQuestTrackingTooltips = true
		end
		if self.db.profile.disableSfx then
			SetCVar("Sound_EnableSFX", "0")
		end
		if self.db.profile.disableMusic then
			SetCVar("Sound_EnableMusic", "0")
		end
		if self.db.profile.disableAmbience then
			SetCVar("Sound_EnableAmbience", "0")
		end
		if self.db.profile.disableErrorSpeech then
			SetCVar("Sound_EnableErrorSpeech", "0")
		end

		if not isClassic then
			local frame = ObjectiveTrackerFrame
			if type(frame) == "table" and type(frame.GetObjectType) == "function" then
				CheckElv(self, frame)
				-- Never hide when tracking achievements or in Mythic+
				local _, _, diff = GetInstanceInfo()
				local trackedAchievements = C_ContentTracking.GetTrackedIDs(2) -- Enum.ContentTrackingType.Achievement = 2
				if not restoreObjectiveTracker and self.db.profile.blockObjectiveTracker and not next(trackedAchievements) and diff ~= 8 and not bbFrame.IsProtected(frame) then
					restoreObjectiveTracker = true
					frame:SetAlpha(0) -- XXX FIXME
				end
			end
		elseif not isVanilla then
			local frame = Questie_BaseFrame or WatchFrame
			if type(frame) == "table" and type(frame.GetObjectType) == "function" then
				if frame == WatchFrame then
					CheckElv(self, frame)
				end
				local trackedAchievements = GetTrackedAchievements and GetTrackedAchievements()
				if not restoreObjectiveTracker and self.db.profile.blockObjectiveTracker and not trackedAchievements and not bbFrame.IsProtected(frame) then
					restoreObjectiveTracker = bbFrame.GetParent(frame)
					if restoreObjectiveTracker then
						bbFrame.SetFixedFrameStrata(frame, true) -- Changing parent would change the strata & level, lock it first
						bbFrame.SetFixedFrameLevel(frame, true)
						bbFrame.SetParent(frame, bbFrame)
					end
				end
			end
		elseif isVanilla then
			local frame = Questie_BaseFrame or QuestWatchFrame
			if type(frame) == "table" and type(frame.GetObjectType) == "function" then
				if not restoreObjectiveTracker and self.db.profile.blockObjectiveTracker and not bbFrame.IsProtected(frame) then
					restoreObjectiveTracker = bbFrame.GetParent(frame)
					if restoreObjectiveTracker then
						bbFrame.SetFixedFrameStrata(frame, true) -- Changing parent would change the strata & level, lock it first
						bbFrame.SetFixedFrameLevel(frame, true)
						bbFrame.SetParent(frame, bbFrame)
					end
				end
			end
		end
	end

	function RestoreAll(self)
		-- blockEmotes
		RestoreEvent(RaidBossEmoteFrame, "RAID_BOSS_EMOTE")
		RestoreEvent(RaidBossEmoteFrame, "RAID_BOSS_WHISPER")
		if isTestBuild then
			self:UnregisterEvent("RAID_BOSS_EMOTE")
			self:UnregisterEvent("RAID_BOSS_WHISPER")
		end
		-- blockGarrison
		RestoreEvent(AlertFrame, "GARRISON_MISSION_FINISHED")
		RestoreEvent(AlertFrame, "GARRISON_BUILDING_ACTIVATABLE")
		RestoreEvent(AlertFrame, "GARRISON_FOLLOWER_ADDED")
		RestoreEvent(AlertFrame, "GARRISON_RANDOM_MISSION_ADDED")
		-- blockGuildChallenge
		RestoreEvent(AlertFrame, "GUILD_CHALLENGE_COMPLETED")
		-- blockSpellErrors
		RestoreEvent(UIErrorsFrame, "UI_ERROR_MESSAGE")
		-- blockZoneChanges
		RestoreEvent(ZoneTextFrame, "ZONE_CHANGED")
		RestoreEvent(ZoneTextFrame, "ZONE_CHANGED_INDOORS")
		RestoreEvent(ZoneTextFrame, "ZONE_CHANGED_NEW_AREA")

		if self.db.profile.blockTooltipQuestText then
			hideQuestTrackingTooltips = false
		end
		if self.db.profile.disableSfx then
			SetCVar("Sound_EnableSFX", "1")
		end
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
			local frame = not isClassic and ObjectiveTrackerFrame or Questie_BaseFrame or WatchFrame or QuestWatchFrame
			if not isClassic then
				frame:SetAlpha(1) -- XXX FIXME
			else
				bbFrame.SetParent(frame, restoreObjectiveTracker)
				bbFrame.SetFixedFrameStrata(frame, false)
				bbFrame.SetFixedFrameLevel(frame, false)
			end
			restoreObjectiveTracker = nil
		end
	end

	function plugin:BigWigs_OnBossDisable(_, module)
		if not module or (not module:GetJournalID() and not module:GetAllowWin()) or module.worldBoss then return end
		activatedModules[module] = nil
		if not next(activatedModules) then
			activatedModules = {}
			RestoreAll(self)
		end
	end
end

function plugin:BigWigs_OnBossWin(event, module)
	local journalId = module:GetJournalID()
	if journalId then
		latestKill = {journalId, (GetTime())}
	end
end

do
	-- Talking Head blocking
	local known = {
		-- Black Rook Hold
		[54567]=true,[54552]=true,[54566]=true,[54511]=true,[57890]=true,[54540]=true,
		[54527]=true,[70619]=true,[70621]=true,[70623]=true,[70625]=true,[70627]=true,
		-- Court of Stars
		[70615]=true,[70199]=true,[70198]=true,[70197]=true,[70193]=true,
		[70195]=true,[70196]=true,[70192]=true,[70194]=true,
		-- Darkheart Thicket
		[54459]=true,[54460]=true,[54461]=true,[54462]=true,[54463]=true,
		[54464]=true,[54465]=true,[54466]=true,[54467]=true,[70601]=true,
		[70603]=true,[70607]=true,
		-- Halls of Valor
		[57160]=true,[57159]=true,[57162]=true,[68701]=true,[57161]=true,
		-- Neltharion's Lair
		[54610]=true,[54608]=true,[54697]=true,[54708]=true,[54709]=true,
		[54718]=true,[54719]=true,[54720]=true,[58102]=true,[58104]=true,

		-- Atal'Dazar
		[97376]=true,[97377]=true,[97373]=true,[97374]=true,[97375]=true,[97372]=true,
		[106402]=true,[106404]=true,[106406]=true,[106411]=true,[106412]=true,[106413]=true,
		-- Freehold
		[104684]=true,[104682]=true,[104685]=true,[104690]=true,
		-- Siege of Boralus
		[101137]=true,[102115]=true,[106663]=true,[106674]=true,[106675]=true,[106676]=true,[106677]=true,
		[106659]=true,[106660]=true,[106661]=true,[106662]=true,[106664]=true,[106667]=true,[106668]=true,
		[106669]=true,[106670]=true,[106671]=true,
		-- The Underrot
		[112206]=true,[106857]=true,[106858]=true,[106852]=true,[106876]=true,[110728]=true,[112208]=true,
		[106877]=true,[106853]=true,[106855]=true,[106856]=true,[106434]=true,[110781]=true,
		-- Waycrest Manor
		[105953]=true,[105954]=true,[105955]=true,[105956]=true,[105962]=true,[105963]=true,[105964]=true,
		[106722]=true,[104219]=true,[104220]=true,[104228]=true,[104229]=true,[103811]=true,[104628]=true,
		[103812]=true,[104208]=true,[104209]=true,[106718]=true,[106720]=true,

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

		-- Algeth'ar Academy
		[208061]=true,[208063]=true,[208065]=true,
		-- Brackenhide Hollow
		[203481]=true,[203482]=true,[203483]=true,[203484]=true,[203457]=true,[203453]=true,[203452]=true,
		-- Ruby Life Pools
		[204740]=true,[204739]=true,[204738]=true,[204737]=true,[204736]=true,
		-- The Nokhud Offensive
		[205509]=true,[205547]=true,[205502]=true,[205503]=true,[205768]=true,[205769]=true,
		[205770]=true,[205555]=true,[205554]=true,[205838]=true,[205839]=true,[205840]=true,
		[205831]=true,[205832]=true,[205833]=true,[205841]=true,[205851]=true,[205856]=true,
		[205504]=true,[205505]=true,[205506]=true,[205507]=true,[205842]=true,[205508]=true,
		[205814]=true,[205815]=true,[205567]=true,[205852]=true,
		-- Uldaman: Legacy of Tyr
		[203125]=true,[203126]=true,[203127]=true,

		-- Ara-Kara
		[247684]=true,[250798]=true,
		-- Cinderbrew Meadery
		[251845]=true,[251846]=true,
		-- City of Threads
		[250773]=true,[250774]=true,[250775]=true,[250776]=true,[250777]=true,[250778]=true,[250779]=true,[250780]=true,
		[250781]=true,[250782]=true,[250790]=true,[250791]=true,[250795]=true,
		-- Priory of the Sacred Flame
		[251154]=true,[251155]=true,[251156]=true,[251157]=true,[251162]=true,[251163]=true,[251169]=true,[251170]=true,
		[251171]=true,[251176]=true,[251177]=true,
		-- The Dawnbreaker
		[251195]=true,[251196]=true,[251197]=true,[251198]=true,[247638]=true,[251199]=true,[251200]=true,[251201]=true,
		[251202]=true,[251203]=true,[251204]=true,[251205]=true,[251206]=true,[251207]=true,[251208]=true,[251184]=true,
		[251209]=true,[251210]=true,[251211]=true,[251189]=true,[251212]=true,[251213]=true,[251214]=true,
		-- The Stonevault
		[250849]=true,[250850]=true,[250845]=true,[250851]=true,[250852]=true,[250853]=true,[250854]=true,[250855]=true,
		[250856]=true,[250857]=true,[250858]=true,[250860]=true,[250861]=true,[250862]=true,[250863]=true,
	}

	local lookup = {
		[1] = 1, -- Normal Dungeon
		[2] = 1, -- Heroic Dungeon
		[8] = 2, -- Mythic+ Keystone Dungeon
		[14] = 3, -- Normal Raid
		[15] = 3, -- Heroic Raid
		[16] = 3, -- Mythic Raid
		[17] = 3, -- LFR
		[23] = 2, -- Mythic Dungeon
		[24] = 4, -- Timewalking Dungeon
		[205] = 1, -- Follower Dungeon
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
		[952] = true, -- Sylvanas defeat
		[956] = true, -- Anduin defeat
		[957] = true, -- Jailer intro
		[958] = true, -- Jailer defeat
		[964] = true, -- Raszageth defeat
		[991] = true, -- Iridikron (DotI) defeat
		[992] = true, -- Chrono-Lord Deios (DotI) defeat
		[1003] = true, -- Amirdrassil, Fyrakk defeat
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
			function() return GetSubZoneText() == "" end, -- "": Before the 1st boss, the tunnel doesn't have a sub zone
			function() return GetSubZoneText() == L.subzone_eastern_transept end, -- Eastern Transept: After the 3rd boss, Teren'gor porting in
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
			function() return GetSubZoneText() == L.subzone_grand_bazaar end, -- Grand Bazaar: After killing 2nd boss, Bwonsamdi (Alliance side only)
			function() return GetSubZoneText() == L.subzone_port_of_zandalar end, -- Port of Zandalar: After killing blockade, boat arriving
		},
		[-1358] = true, -- Battle of Dazar'alor, after killing 1st boss, Bwonsamdi (Horde side only)
		--[-1364] = true, -- Battle of Dazar'alor, Jaina stage 1 intermission (unskippable)
		[-1597] = true, -- N'Zoth defeat
		[-2000] = true, -- Soulrender Dormazain defeat
		[-2002] = true, -- Sylvanas stage 2
		[-2004] = true, -- Sylvanas defeat
		[-2170] = true, -- Aberrus, Sarkareth defeat
		[-2233] = true, -- Amirdrassil, Smolderon defeat
		[-2234] = true, -- After killing Tindral, flying into the tree, usually 2238 but rarely can be 2234
		[-2238] = { -- Amirdrassil
			function() return latestKill[1] == 2565 end, -- After killing Tindral, flying into the tree
			function() return latestKill[1] == 2519 and GetTime()-latestKill[2] < 6 end, -- After killing Fyrakk, but don't trigger when talking to the NPC after killing him
		},
		[-2292] = true, -- Nerub-ar Palace, Ulgrax defeat
		[-2296] = true, -- Nerub-ar Palace, Ansurek defeat
	}

	-- Cinematic skipping hack to workaround an item (Vision of Time) that creates cinematics in Siege of Orgrimmar.
	function plugin:SiegeOfOrgrimmarCinematics()
		local hasItem
		local GetItemCount = C_Item and C_Item.GetItemCount or GetItemCount -- XXX Wrath compat
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
						local func = cinematicZones[id][i]
						if func() then
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
