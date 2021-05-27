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
--local TalkingHeadLineInfo = C_TalkingHead.GetCurrentLineInfo
local IsEncounterInProgress = IsEncounterInProgress
local SetCVar = SetCVar
local GetCVar = GetCVar
local CheckElv = nil
local RestoreAll

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
				blockSpellErrors = {
					type = "toggle",
					name = L.blockSpellErrors,
					desc = L.blockSpellErrorsDesc,
					width = "full",
					order = 5,
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
		if self.db.profile.disableMusic then
			SetCVar("Sound_EnableMusic", "1")
		end
		if self.db.profile.disableAmbience then
			SetCVar("Sound_EnableAmbience", "1")
		end
		if self.db.profile.disableErrorSpeech then
			SetCVar("Sound_EnableErrorSpeech", "1")
		end
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

	function plugin:OnEngage(event, module)
		if not module or not module.journalId or module.worldBoss then return end

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
	end

	function RestoreAll(self)
		if self.db.profile.blockSpellErrors then
			RestoreEvent(UIErrorsFrame, "UI_ERROR_MESSAGE")
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
	end

	function plugin:OnWinOrWipe(event, module)
		if not module or not module.journalId or module.worldBoss then return end
		RestoreAll(self)
	end
end
