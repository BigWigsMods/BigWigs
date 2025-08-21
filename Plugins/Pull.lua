-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin, L = BigWigs:NewPlugin("Pull")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local GetInstanceInfo = BigWigsLoader.GetInstanceInfo
local DoCountdown = BigWigsLoader.DoCountdown
local zoneTable = BigWigsLoader.zoneTbl
local isLogging = false
local IsEncounterInProgress = IsEncounterInProgress
local media = LibStub("LibSharedMedia-3.0")
local SOUND = media.MediaType and media.MediaType.SOUND or "sound"

local BWPull = CreateFrame("Button", "BWPull")
BWPull:SetSize(1, 1)
BWPull:Hide()
BWPull:SetScript("OnClick", function()
	DoCountdown(10)
end)
BWPull:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	ClearOverrideBindings(self)
	if plugin.db.profile.keybind ~= "" then
		SetOverrideBindingClick(self, true, plugin.db.profile.keybind, "BWPull")
	end
end)

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
		keybind = "",
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
			if k ~= "none" and k ~= "simple" then
				sorted[#sorted + 1] = k
			end
		end
		table.sort(sorted, function(a, b) return list[a] < list[b] end)
		table.insert(sorted, 1, "none")
		table.insert(sorted, 2, "simple")
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
					normal = L.expiring_normal,
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
			explainer = {
				type = "description",
				name = L.pullExplainer,
				order = 11,
				width = "full",
				fontSize = "medium",
			},
			keybind = {
				type = "keybinding",
				name = L.keybinding,
				desc = L.pullKeybindingDesc,
				order = 12,
				set = function(a, key)
					plugin.db.profile.keybind = key
					if not InCombatLockdown() then
						ClearOverrideBindings(BWPull)
						if key ~= "" then
							SetOverrideBindingClick(BWPull, true, key, "BWPull")
						end
					else
						BWPull:RegisterEvent("PLAYER_REGEN_ENABLED")
					end
				end,
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

		if not InCombatLockdown() then
			ClearOverrideBindings(BWPull)
			if plugin.db.profile.keybind ~= "" then
				SetOverrideBindingClick(BWPull, true, plugin.db.profile.keybind, "BWPull")
			end
		else
			BWPull:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
	end

	function plugin:OnPluginEnable()
		self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
		updateProfile()

		self:RegisterMessage("BigWigs_OnBossWin")
		self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossWin")

		self:RegisterMessage("BigWigs_OnBossEngage")

		self:RegisterMessage("Blizz_StartCountdown")
		self:RegisterMessage("Blizz_StopCountdown")

		if BigWigsLoader.isRetail then
			self:RegisterEvent("CHALLENGE_MODE_START")
		end
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
	local function printPull()
		timeLeft = timeLeft - 1
		if timeLeft == 0 then
			plugin:CancelTimer(timer)
			timer = nil
			if plugin.db.profile.countType == "emphasized" then
				plugin:SendMessage("BigWigs_StopCountdown", plugin, "pulling time") -- Remove the countdown text
			end
			local soundName = plugin.db.profile.endPullSound
			if soundName ~= "None" then
				local sound = media:Fetch(SOUND, soundName, true)
				if sound then
					plugin:PlaySoundFile(sound)
				end
			end
		elseif timeLeft > 1 and IsEncounterInProgress() then -- Cancel the pull timer if we ninja pulled
			plugin:CancelTimer(timer)
			timeLeft = 0
			BigWigs:Print(L.pullStoppedCombat)
			plugin:SendMessage("BigWigs_StopBar", plugin, L.pull)
			plugin:SendMessage("BigWigs_StopPull", plugin, "COMBAT")
			plugin:SendMessage("BigWigs_StopCountdown", plugin, "pulling time")
		elseif timeLeft <= plugin.db.profile.countBegin and plugin.db.profile.countType ~= "emphasized" then
			plugin:SendMessage("BigWigs_Message", plugin, nil, L.pullIn:format(timeLeft), "yellow")
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
		timer = self:ScheduleRepeatingTimer(printPull, 1)
		if self.db.profile.combatLog then
			isLogging = true
			LoggingCombat(isLogging)
		end
		self:SendMessage("BigWigs_StartCountdown", self, nil, "pulling time", timeLeft, nil, self.db.profile.voice, self.db.profile.countBegin, self.db.profile.countType ~= "emphasized")
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
	function plugin:CHALLENGE_MODE_START()
		self:Blizz_StopCountdown() -- Stop any active pull timers when a Mythic+ countdown is started
	end
end

function plugin:BigWigs_OnBossWin()
	if isLogging then
		isLogging = false
		self:SimpleTimer(function() LoggingCombat(false) end, 2) -- Delay to prevent any death events being cut out the log
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

BigWigsAPI.RegisterSlashCommand("/pull", function(input)
	if IsEncounterInProgress() then BigWigs:Print(L.encounterRestricted) return end -- Doesn't make sense to allow this in combat

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
end)
