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
local SetCVar = SetCVar

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
		--blockMovies = {
		--	type = "toggle",
		--	name = L.blockMovies,
		--	desc = L.blockMoviesDesc,
		--	width = "full",
		--	order = 2,
		--},
		--blockGarrison = {
		--	type = "toggle",
		--	name = L.blockFollowerMission,
		--	desc = L.blockFollowerMissionDesc,
		--	width = "full",
		--	order = 3,
		--},
		--blockGuildChallenge = {
		--	type = "toggle",
		--	name = L.blockGuildChallenge,
		--	desc = L.blockGuildChallengeDesc,
		--	width = "full",
		--	order = 4,
		--},
		blockSpellErrors = {
			type = "toggle",
			name = L.blockSpellErrors,
			desc = L.blockSpellErrorsDesc,
			width = "full",
			order = 5,
		},
		--blockTooltipQuests = {
		--	type = "toggle",
		--	name = L.blockTooltipQuests,
		--	desc = L.blockTooltipQuestsDesc,
		--	width = "full",
		--	order = 6,
		--},
		--blockObjectiveTracker = {
		--	type = "toggle",
		--	name = L.blockObjectiveTracker,
		--	desc = L.blockObjectiveTrackerDesc,
		--	width = "full",
		--	order = 7,
		--},
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

	if IsEncounterInProgress() then -- Just assume we logged into an encounter after a DC
		self:BigWigs_OnBossEngage()
	end
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

	local restoreObjectiveTracker = nil
	function plugin:BigWigs_OnBossEngage()
		if self.db.profile.blockEmotes and not IsTestBuild() then -- Don't block emotes on WoW beta.
			KillEvent(RaidBossEmoteFrame, "RAID_BOSS_EMOTE")
			KillEvent(RaidBossEmoteFrame, "RAID_BOSS_WHISPER")
		end
		if self.db.profile.blockSpellErrors then
			KillEvent(UIErrorsFrame, "UI_ERROR_MESSAGE")
		end
		if self.db.profile.disableSfx then
			SetCVar("Sound_EnableSFX", "0")
		end
	end

	function plugin:BigWigs_OnBossWin()
		if self.db.profile.blockEmotes then
			RestoreEvent(RaidBossEmoteFrame, "RAID_BOSS_EMOTE")
			RestoreEvent(RaidBossEmoteFrame, "RAID_BOSS_WHISPER")
		end
		if self.db.profile.blockSpellErrors then
			RestoreEvent(UIErrorsFrame, "UI_ERROR_MESSAGE")
		end
		if self.db.profile.disableSfx then
			SetCVar("Sound_EnableSFX", "1")
		end
	end
end
