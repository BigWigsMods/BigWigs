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
local DoCountdown = BigWigsLoader.DoCountdown
local dbmPrefix = BigWigsLoader.dbmPrefix
local zoneTable = BigWigsLoader.zoneTbl
local isLogging = false
local IsEncounterInProgress = IsEncounterInProgress
local media = LibStub("LibSharedMedia-3.0")
local SOUND = media.MediaType and media.MediaType.SOUND or "sound"

-------------------------------------------------------------------------------
-- Options
--

do
	local voiceMap = {
		deDE = "deDE: Default (Female)",
		esES = "esES: Default (Female)",
		esMX = "esMX: Default (Female)",
		frFR = "frFR: Default (Female)",
		itIT = "itIT: Default (Female)",
		koKR = "koKR: Default (Female)",
		ptBR = "ptBR: Default (Female)",
		ruRU = "ruRU: Default (Female)",
		zhCN = "zhCN: Default (Female)",
		zhTW = "zhTW: Default (Female)",
	}
	plugin.defaultDB = {
		countType = "emphasized",
		countBegin = 5,
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

	local function voiceSorting()
		local list = BigWigsAPI:GetCountdownList()
		local sorted = {}
		for k in next, list do
			if k ~= L.none then
				sorted[#sorted + 1] = k
			end
		end
		sort(sorted, function(a, b) return list[a] < list[b] end)
		tinsert(sorted, 1, L.none)
		return sorted
	end

	plugin.pluginOptions = {
		name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Pull:20|t ".. L.pull,
		type = "group",
		childGroups = "tab",
		get = function(i) return plugin.db.profile[i[#i]] end,
		set = function(i, value) plugin.db.profile[i[#i]] = value end,
		order = 6,
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
			countBegin = {
				name = L.countdownBegins,
				desc = L.countdownBegins_desc,
				type = "range", min = 5, max = 10, step = 1,
				order = 2,
				width = 1.5
			},
			spacer1 = {
				type = "description",
				name = "\n",
				order = 3,
				width = "full",
			},
			engageSound = {
				type = "select",
				name = L.engageSoundTitle,
				order = 4,
				get = soundGet,
				set = soundSet,
				values = media:List(SOUND),
				width = 2.5,
				itemControl = "DDI-Sound",
			},
			spacer2 = {
				type = "description",
				name = "\n",
				order = 5,
				width = "full",
			},
			startPullSound = {
				type = "select",
				name = L.pullStartedSoundTitle,
				order = 6,
				get = soundGet,
				set = soundSet,
				values = media:List(SOUND),
				width = 2.5,
				itemControl = "DDI-Sound",
			},
			endPullSound = {
				type = "select",
				name = L.pullFinishedSoundTitle,
				order = 7,
				get = soundGet,
				set = soundSet,
				values = media:List(SOUND),
				width = 2.5,
				itemControl = "DDI-Sound",
			},
			voice = {
				name = L.countdownVoice,
				type = "select",
				values = BigWigsAPI.GetCountdownList,
				sorting = voiceSorting,
				order = 8,
				width = 2.5,
			},
			spacer3 = {
				type = "description",
				name = "\n",
				order = 9,
				width = "full",
			},
			combatLog = {
				type = "toggle",
				name = L.combatLog,
				desc = L.combatLogDesc,
				order = 10,
				width = "full",
			},
		},
	}
end

-------------------------------------------------------------------------------
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

		if db.countType ~= "normal" and db.countType ~= "emphasized" then
			db.countType = plugin.defaultDB.countType
		end
		if db.countBegin < 5 or db.countBegin > 10 then
			db.countBegin = plugin.defaultDB.countBegin
		end
	end

	function plugin:OnPluginEnable()
		self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
		updateProfile()

		self:RegisterMessage("BigWigs_PluginComm")
		self:RegisterMessage("DBM_AddonMessage")

		self:RegisterMessage("BigWigs_OnBossWin")
		self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossWin")

		self:RegisterMessage("BigWigs_OnBossEngage")

		self:RegisterMessage("Blizz_StartCountdown")
		self:RegisterMessage("Blizz_StopCountdown")
	end
end

function plugin:OnPluginDisable()
	if isLogging then
		isLogging = false
		LoggingCombat(isLogging)
	end
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
				self:SendMessage("BigWigs_StopCountdown", self, "pulling time") -- Remove the countdown text
			end
			local soundName = self.db.profile.endPullSound
			if soundName ~= "None" then
				local sound = media:Fetch(SOUND, soundName, true)
				if sound then
					self:PlaySoundFile(sound)
				end
			end
		elseif timeLeft > 1 and IsEncounterInProgress() then -- Cancel the pull timer if we ninja pulled
			self:CancelTimer(timer)
			timeLeft = 0
			BigWigs:Print(L.pullStoppedCombat)
			self:SendMessage("BigWigs_StopBar", self, L.pull)
			self:SendMessage("BigWigs_StopPull", self, "COMBAT")
			self:SendMessage("BigWigs_StopCountdown", self, "pulling time")
		elseif timeLeft <= self.db.profile.countBegin and self.db.profile.countType ~= "emphasized" then
			self:SendMessage("BigWigs_Message", self, nil, L.pullIn:format(timeLeft), "yellow")
		end
	end
	function plugin:StartPull(seconds, nick, isDBM)
		if IsEncounterInProgress() then return end -- Doesn't make sense to allow this in combat
		if not IsInGroup() or ((IsInGroup(2) or not IsInRaid()) and UnitGroupRolesAssigned(nick) == "TANK") or UnitIsGroupLeader(nick) or UnitIsGroupAssistant(nick) then
			local _, _, _, instanceId = UnitPosition("player")
			local _, _, _, tarInstanceId = UnitPosition(nick)
			if instanceId ~= tarInstanceId then -- Don't fire pull timers from people in different zones...
				local _, instanceType = GetInstanceInfo() -- ...unless you're in a raid instance and the sender isn't, to allow raid leaders outside to send you pull timers
				if not (instanceType == "raid" and not zoneTable[tarInstanceId]) then
					return
				end
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
			BigWigs:Print(L.pullStartedBy:format(nick))
			timer = self:ScheduleRepeatingTimer(printPull, 1, self)

			if self.db.profile.combatLog then
				isLogging = true
				LoggingCombat(isLogging)
			end

			self:SendMessage("BigWigs_StartCountdown", self, nil, "pulling time", timeLeft, self.db.profile.voice, self.db.profile.countBegin, self.db.profile.countType ~= "emphasized")
			self:SendMessage("BigWigs_Message", self, nil, L.pullIn:format(timeLeft), "yellow")
			self:SendMessage("BigWigs_StartBar", self, nil, L.pull, seconds, 132337) -- 132337 = "Interface\\Icons\\ability_warrior_charge"
			self:SendMessage("BigWigs_StartPull", self, seconds, nick, isDBM)
			local soundName = self.db.profile.startPullSound
			if soundName ~= "None" then
				local sound = media:Fetch(SOUND, soundName, true)
				if sound then
					self:PlaySoundFile(sound)
				end
			end
		end
	end

	function plugin:Blizz_StartCountdown(_, initiatedBy, timeSeconds, totalTime)
		if IsEncounterInProgress() then return end -- Doesn't make sense to allow this in combat
		local unitToken
		local _, instanceType, _, _, _, _, _, instanceId = GetInstanceInfo()
		for unit in self:IterateGroup(true) do
			if self:UnitGUID(unit) == initiatedBy then
				local _, _, _, tarInstanceId = UnitPosition(unit)
				-- Don't fire pull timers from people in different zones...
				-- ...unless you're in a raid instance and the sender isn't, to allow raid leaders outside to send you pull timers
				if instanceId ~= tarInstanceId and not (instanceType == "raid" and not zoneTable[tarInstanceId]) then
					return
				end
				unitToken = unit
				break
			end
		end

		local name = unitToken and self:UnitName(unitToken) or "?"
		if timer then
			self:CancelTimer(timer)
		end
		timeLeft = timeSeconds
		FlashClientIcon()
		BigWigs:Print(L.pullStartedBy:format(name))
		timer = self:ScheduleRepeatingTimer(printPull, 1, self)
		if self.db.profile.combatLog then
			isLogging = true
			LoggingCombat(isLogging)
		end
		self:SendMessage("BigWigs_StartCountdown", self, nil, "pulling time", timeLeft, self.db.profile.voice, self.db.profile.countBegin, self.db.profile.countType ~= "emphasized")
		self:SendMessage("BigWigs_Message", self, nil, L.pullIn:format(timeLeft), "yellow")
		self:SendMessage("BigWigs_StartBar", self, nil, L.pull, timeSeconds, 132337) -- 132337 = "Interface\\Icons\\ability_warrior_charge"
		self:SendMessage("BigWigs_StartPull", self, timeSeconds, name)
		local soundName = self.db.profile.startPullSound
		if soundName ~= "None" then
			local sound = media:Fetch(SOUND, soundName, true)
			if sound then
				self:PlaySoundFile(sound)
			end
		end
	end

	function plugin:Blizz_StopCountdown(_, initiatedBy)
		if timer then
			if initiatedBy then
				local unitToken
				local _, instanceType, _, _, _, _, _, instanceId = GetInstanceInfo()
				for unit in self:IterateGroup(true) do
					if self:UnitGUID(unit) == initiatedBy then
						local _, _, _, tarInstanceId = UnitPosition(unit)
						-- Don't fire pull timers from people in different zones...
						-- ...unless you're in a raid instance and the sender isn't, to allow raid leaders outside to send you pull timers
						if instanceId ~= tarInstanceId and not (instanceType == "raid" and not zoneTable[tarInstanceId]) then
							return
						end
						unitToken = unit
						break
					end
				end
				local name = unitToken and self:UnitName(unitToken) or "?"
				BigWigs:Print(L.pullStopped:format(name))
				self:SendMessage("BigWigs_StopPull", self, name)
			else
				BigWigs:Print(L.pullStoppedCombat)
				self:SendMessage("BigWigs_StopPull", self, "COMBAT")
			end
			self:CancelTimer(timer)
			timer = nil
			timeLeft = 0
			self:SendMessage("BigWigs_StopBar", self, L.pull)
			self:SendMessage("BigWigs_StopCountdown", self, "pulling time")
		end
	end
end

function plugin:DBM_AddonMessage(_, sender, prefix, seconds)
	if prefix == "PT" and not C_EventUtils.IsEventValid("START_PLAYER_COUNTDOWN") then
		self:StartPull(seconds, sender, true)
	end
end

function plugin:BigWigs_PluginComm(_, msg, seconds, sender)
	if msg == "Pull" and seconds and not C_EventUtils.IsEventValid("START_PLAYER_COUNTDOWN") then
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
	if module and (module:GetJournalID() or module:GetAllowWin()) then
		local soundName = self.db.profile.engageSound
		if soundName ~= "None" then
			local sound = media:Fetch(SOUND, soundName, true)
			if sound then
				self:PlaySoundFile(sound)
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Slash Handler
--

SlashCmdList.BIGWIGSPULL = function(input)
	if IsEncounterInProgress() then BigWigs:Print(L.encounterRestricted) return end -- Doesn't make sense to allow this in combat

	if not C_EventUtils.IsEventValid("START_PLAYER_COUNTDOWN") then
		if not IsInGroup() or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or ((IsInGroup(2) or not IsInRaid()) and UnitGroupRolesAssigned("player") == "TANK") then -- Solo or leader/assist or tank in LFG/5m
			if not plugin:IsEnabled() then BigWigs:Enable() end
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
				local name = plugin:UnitName("player")
				local realm = GetRealmName()
				local normalizedPlayerRealm = realm:gsub("[%s-]+", "") -- Has to mimic DBM code
				SendAddonMessage(dbmPrefix, ("%s-%s\t1\tPT\t%s\t%d"):format(name, normalizedPlayerRealm, input, instanceId), IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- DBM message
			end
		else
			BigWigs:Print(L.requiresLeadOrAssist)
		end
	else
		if not IsInGroup() or (IsInGroup(2) and UnitGroupRolesAssigned("player") == "TANK") or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or (IsInGroup(1) and not IsInRaid()) then -- Solo, tank in LFG, leader, assist, anyone in 5m
			if not plugin:IsEnabled() then BigWigs:Enable() end
			if input == "" then
				DoCountdown(10) -- Allow typing /pull to start a 10 second pull timer
			else
				local seconds = tonumber(input)
				if not seconds or seconds < 0 or seconds > 86400 then BigWigs:Print(L.wrongPullFormat) return end
				if seconds ~= 0 then
					BigWigs:Print(L.sendPull)
				end
				DoCountdown(seconds)
			end
		else
			BigWigs:Print(L.requiresLeadOrAssist)
		end
	end
end
SLASH_BIGWIGSPULL1 = "/pull"
