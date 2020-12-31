-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Pull")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
local GetInstanceInfo = BigWigsLoader.GetInstanceInfo
local SendAddonMessage = BigWigsLoader.SendAddonMessage
local isLogging = false
local IsEncounterInProgress, PlaySoundFile = IsEncounterInProgress, PlaySoundFile
local media = LibStub("LibSharedMedia-3.0")
local SOUND = media.MediaType and media.MediaType.SOUND or "sound"

-------------------------------------------------------------------------------
-- Options
--

do
	local voiceMap = {
		deDE = "Deutsch: Heroes of the Storm",
		esES = "Español: Heroes of the Storm",
		esMX = "Español: Heroes of the Storm",
		frFR = "Français: Heroes of the Storm",
		ruRU = "Русский: Heroes of the Storm",
		koKR = "한국어: Heroes of the Storm",
		itIT = "Italiano: Heroes of the Storm",
		ptBR = "Português: Heroes of the Storm",
		zhCN = "简体中文: Heroes of the Storm",
		zhTW = "繁體中文: Heroes of the Storm",
	}
	plugin.defaultDB = {
		countType = "emphasized",
		combatLog = false,
		engageSound = "None",
		startPullSound = "BigWigs: Long",
		endPullSound = "BigWigs: Alarm",
		voice = voiceMap[GetLocale()] or "English: Amy",
	}
end

do
	local function soundGet(info)
		for i, v in next, media:List(SOUND) do
			if v == plugin.db.profile[info[#info]] then
				return i
			end
		end
	end
	local function soundSet(info, value)
		plugin.db.profile[info[#info]] = media:List(SOUND)[value]
	end

	plugin.pluginOptions = {
		name = L.pull,
		type = "group",
		childGroups = "tab",
		get = function(i) return plugin.db.profile[i[#i]] end,
		set = function(i, value) plugin.db.profile[i[#i]] = value end,
		args = {
			countType = {
				type = "select",
				name = L.countdownType,
				order = 1,
				values = {
					normal = L.normal,
					emphasized = L.emphasized,
				},
			},
			spacer1 = {
				type = "description",
				name = "\n",
				order = 1.1,
				width = "full",
			},
			engageSound = {
				type = "select",
				name = L.engageSoundTitle,
				order = 2,
				get = soundGet,
				set = soundSet,
				values = media:List(SOUND),
				width = 2,
				itemControl = "DDI-Sound",
			},
			spacer2 = {
				type = "description",
				name = "\n",
				order = 2.1,
				width = "full",
			},
			startPullSound = {
				type = "select",
				name = L.pullStartedSoundTitle,
				order = 3,
				get = soundGet,
				set = soundSet,
				values = media:List(SOUND),
				width = 2,
				itemControl = "DDI-Sound",
			},
			endPullSound = {
				type = "select",
				name = L.pullFinishedSoundTitle,
				order = 4,
				get = soundGet,
				set = soundSet,
				values = media:List(SOUND),
				width = 2,
				itemControl = "DDI-Sound",
			},
			voice = {
				name = L.countdownVoice,
				type = "select",
				values = function() return BigWigsAPI:GetCountdownList() end,
				order = 5,
				width = 2,
			},
			spacer3 = {
				type = "description",
				name = "\n",
				order = 5.1,
				width = "full",
			},
			combatLog = {
				type = "toggle",
				name = L.combatLog,
				desc = L.combatLogDesc,
				order = 6,
				width = "full",
			},
		},
	}
end

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_PluginComm")
	self:RegisterMessage("DBM_AddonMessage")

	self:RegisterMessage("BigWigs_OnBossWin")
	self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossWin")

	self:RegisterMessage("BigWigs_OnBossEngage")
end

-------------------------------------------------------------------------------
-- Event Handlers
--

do
	local timer, timeLeft = nil, 0
	local function printPull(self)
		timeLeft = timeLeft - 1
		if timeLeft == 0 then
			self:CancelTimer(timer)
			timer = nil
			if self.db.profile.countType == "emphasized" then
				self:SendMessage("BigWigs_StopCountdown", self, "pulling time") -- Make the countdown text clear
			end
			local soundName = self.db.profile.endPullSound
			if soundName ~= "None" then
				local sound = media:Fetch(SOUND, soundName, true)
				if sound then
					PlaySoundFile(sound, "Master")
				end
			end
		elseif timeLeft > 2 and IsEncounterInProgress() then -- Cancel the pull timer if we ninja pulled
			self:CancelTimer(timer)
			timeLeft = 0
			BigWigs:Print(L.pullStoppedCombat)
			self:SendMessage("BigWigs_StopBar", self, L.pull)
			self:SendMessage("BigWigs_StopPull", self, "COMBAT")
			self:SendMessage("BigWigs_StopCountdown", self, "pulling time")
		elseif timeLeft < 11 then
			if self.db.profile.countType ~= "emphasized" then
				self:SendMessage("BigWigs_Message", self, nil, L.pullIn:format(timeLeft), "yellow")
			end
		end
	end
	function plugin:StartPull(seconds, nick, isDBM)
		if not IsInGroup() or ((IsInGroup(2) or not IsInRaid()) and UnitGroupRolesAssigned(nick) == "TANK") or UnitIsGroupLeader(nick) or UnitIsGroupAssistant(nick) then
			local _, _, _, instanceId = UnitPosition("player")
			local _, _, _, tarInstanceId = UnitPosition(nick)
			if instanceId ~= tarInstanceId then -- Don't fire pull timers from people in different zones
				return
			end

			seconds = tonumber(seconds)
			if not seconds or seconds < 0 or seconds > 60 then return end
			seconds = floor(seconds)
			if timeLeft == seconds then return end -- Throttle
			timeLeft = seconds
			if timer then
				self:CancelTimer(timer)
				if seconds == 0 then
					timeLeft = 0
					BigWigs:Print(L.pullStopped:format(nick))
					self:SendMessage("BigWigs_StopBar", self, L.pull)
					self:SendMessage("BigWigs_StopPull", self, nick, isDBM)
					self:SendMessage("BigWigs_StopCountdown", self, "pulling time")
					return
				end
			end
			FlashClientIcon()
			BigWigs:Print(L.pullStarted:format(isDBM and "DBM" or "BigWigs", nick))
			timer = self:ScheduleRepeatingTimer(printPull, 1, self)

			if self.db.profile.combatLog then
				isLogging = true
				LoggingCombat(isLogging)
			end

			self:SendMessage("BigWigs_StartCountdown", self, nil, "pulling time", timeLeft, self.db.profile.voice, self.db.profile.countType ~= "emphasized")
			self:SendMessage("BigWigs_Message", self, nil, L.pullIn:format(timeLeft), "yellow")
			self:SendMessage("BigWigs_StartBar", self, nil, L.pull, seconds, 132337) -- 132337 = "Interface\\Icons\\ability_warrior_charge"
			self:SendMessage("BigWigs_StartPull", self, seconds, nick, isDBM)
			local soundName = self.db.profile.startPullSound
			if soundName ~= "None" then
				local sound = media:Fetch(SOUND, soundName, true)
				if sound then
					PlaySoundFile(sound, "Master")
				end
			end
		end
	end
end

function plugin:DBM_AddonMessage(_, sender, prefix, seconds)
	if prefix == "PT" then
		self:StartPull(seconds, sender, true)
	end
end

function plugin:BigWigs_PluginComm(_, msg, seconds, sender)
	if msg == "Pull" and seconds then
		self:StartPull(seconds, sender)
	end
end

function plugin:BigWigs_OnBossWin()
	if isLogging then
		isLogging = false
		self:ScheduleTimer(LoggingCombat, 2, isLogging) -- Delay to prevent any death events being cut out the log
	end
end

function plugin:BigWigs_OnBossEngage(_, module)
	if module and module.journalId then
		local soundName = self.db.profile.engageSound
		if soundName ~= "None" then
			local sound = media:Fetch(SOUND, soundName, true)
			if sound then
				PlaySoundFile(sound, "Master")
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Slash Handler
--

SlashCmdList.BIGWIGSPULL = function(input)
	if not plugin:IsEnabled() then BigWigs:Enable() end
	if IsEncounterInProgress() then BigWigs:Print(L.encounterRestricted) return end -- Doesn't make sense to allow this in combat
	if not IsInGroup() or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or ((IsInGroup(2) or not IsInRaid()) and UnitGroupRolesAssigned("player") == "TANK") then -- Solo or leader/assist or tank in LFG/5m
		if input == "" then
			input = "10" -- Allow typing /pull to start a 10 second pull timer
		else
			local seconds = tonumber(input)
			if not seconds or seconds < 0 or seconds > 60 then BigWigs:Print(L.wrongPullFormat) return end
			if seconds ~= 0 then
				BigWigs:Print(L.sendPull)
			end
		end

		plugin:Sync("Pull", input)

		if IsInGroup() then
			local _, _, _, _, _, _, _, id = GetInstanceInfo()
			local instanceId = tonumber(id) or 0
			SendAddonMessage("D4", ("PT\t%s\t%d"):format(input, instanceId), IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- DBM message
		end
	else
		BigWigs:Print(L.requiresLeadOrAssist)
	end
end
SLASH_BIGWIGSPULL1 = "/pull"
