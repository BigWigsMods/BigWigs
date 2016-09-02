-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Pull")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs: Plugins")
local isLogging = false

-------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	countType = "emphasized",
	combatLog = false,
}

do
	plugin.pluginOptions = {
		name = "Pull",
		type = "group",
		childGroups = "tab",
		get = function(i) return plugin.db.profile[i[#i]] end,
		set = function(i, value) plugin.db.profile[i[#i]] = value end,
		args = {
			countType = {
				type = "select",
				name = "Countdown Type",
				order = 1,
				values = {
					normal = "Normal",
					emphasized = "Emphasized",
				},
				width = "full",
			},
			combatLog = {
				type = "select",
				name = "Automatic Combat logging",
				order = 2,
				width = "full",
			},
			--gearCheck = {
			--	type = "toggle",
			--	name = "Low Gear Check",
			--	order = 3,
			--	width = "full",
			--},
		},
	}
end

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	BigWigs:AddSyncListener(self, "BWPull", 0)
	self:RegisterMessage("DBM_AddonMessage", "OnDBMSync")

	self:RegisterMessage("BigWigs_OnBossWin")
	self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossWin")
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
			self:SendMessage("BigWigs_Message", self, nil, L.pulling, "Attention", "Interface\\Icons\\ability_warrior_charge")
			self:SendMessage("BigWigs_Sound", self, nil, "Alarm")
		elseif timeLeft > 2 and IsEncounterInProgress() then -- Cancel the pull timer if we ninja pulled
			startPull(0, COMBAT)
		elseif timeLeft < 11 then
			if self.db.profile.countType == "normal" then
				self:SendMessage("BigWigs_Message", self, nil, L.pullIn:format(timeLeft), "Attention")
			else
				self:SendMessage("BigWigs_EmphasizedCountdownMessage", timeLeft)
			end
			local module = BigWigs:GetPlugin("Sounds", true)
			if timeLeft < 6 and module and module.db.profile.sound then
				self:SendMessage("BigWigs_PlayCountdownNumber", self, timeLeft)
			end
		end
	end
	function plugin:StartPull(seconds, nick, isDBM)
		if (not UnitIsGroupLeader(nick) and not UnitIsGroupAssistant(nick) and not UnitIsUnit(nick, "player")) or (IsEncounterInProgress() and nick ~= COMBAT) then return end
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
				self:SendMessage("BigWigs_StopPull", self, seconds, nick, isDBM)
				return
			end
		end
		FlashClientIcon()

		if self.db.profile.combatLog then
			isLogging = true
			LoggingCombat(isLogging)
		end

		BigWigs:Print(L.pullStarted:format(isDBM and "DBM" or "BigWigs", nick))
		timer = self:ScheduleRepeatingTimer(printPull, 1, self)
		self:SendMessage("BigWigs_Message", self, nil, L.pullIn:format(timeLeft), "Attention")
		self:SendMessage("BigWigs_Sound", self, nil, "Long")
		self:SendMessage("BigWigs_StartBar", self, nil, L.pull, seconds, "Interface\\Icons\\ability_warrior_charge")
		self:SendMessage("BigWigs_StartPull", self, seconds, nick, isDBM)
	end
end

function plugin:OnDBMSync(_, sender, prefix, seconds, text)
	if prefix == "PT" then
		self:StartPull(seconds, sender, true)
	end
end

function plugin:OnSync(sync, seconds, nick)
	if seconds and nick then
		self:StartPull(seconds, nick)
	end
end

function plugin:BigWigs_OnBossWin()
	if isLogging then
		isLogging = false
		LoggingCombat(isLogging)
	end
end

-------------------------------------------------------------------------------
-- Slash Handler
--

SlashCmdList.BIGWIGSPULL = function(input)
	if not plugin:IsEnabled() then BigWigs:Enable() end
	if IsEncounterInProgress() then BigWigs:Print(L.encounterRestricted) return end -- Doesn't make sense to allow this in combat
	if not IsInGroup() or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then -- Solo or leader/assist
		local s, respawn = input:match("(%d-) (.*)")
		if respawn and respawn:lower() == "true" then
			local bars = BigWigs:GetPlugin("Bars")
			local respawn = BigWigs:GetPlugin("Respawn")
			if bars and respawn then
				input = bars:GetBarTimeLeft(respawn, L.respawn)
			end
			input = plugin:GetRespawnTimeLeft() + tonumber(s)
		end
		local seconds = tonumber(input)
		if not seconds or seconds < 0 or seconds > 60 then BigWigs:Print(L.wrongPullFormat) return end

		if seconds ~= 0 then
			BigWigs:Print(L.sendPull)
		end
		BigWigs:Transmit("BWPull", input)

		if IsInGroup() then
			local _, _, _, _, _, _, _, mapID = GetInstanceInfo()
			SendAddonMessage("D4", ("PT\t%s\t%d"):format(input, mapID or 0), IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- DBM message
		end
	else
		BigWigs:Print(L.requiresLeadOrAssist)
	end
end
SLASH_BIGWIGSPULL1 = "/pull"

