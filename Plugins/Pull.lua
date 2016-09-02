-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Pull")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs: Plugins")


-------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	countType = "emphasized",
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
			--gearCheck = {
			--	type = "toggle",
			--	name = "Low Gear Check",
			--	order = 2,
			--	width = "full",
			--},
			--combatLog = {
			--	type = "select",
			--	name = "Automatic Combat logging",
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
end

-------------------------------------------------------------------------------
-- Event Handlers
--

local startPull
do
	local timer, timeLeft = nil, 0
	local function printPull()
		timeLeft = timeLeft - 1
		if timeLeft == 0 then
			plugin:CancelTimer(timer)
			timer = nil
			plugin:SendMessage("BigWigs_Message", plugin, nil, L.pulling, "Attention", "Interface\\Icons\\ability_warrior_charge")
			plugin:SendMessage("BigWigs_Sound", plugin, nil, "Alarm")
		elseif timeLeft > 2 and IsEncounterInProgress() then -- Cancel the pull timer if we ninja pulled
			startPull(0, COMBAT)
		elseif timeLeft < 11 then
			if plugin.db.profile.countType == "normal" then
				plugin:SendMessage("BigWigs_Message", plugin, nil, L.pullIn:format(timeLeft), "Attention")
			else
				plugin:SendMessage("BigWigs_EmphasizedCountdownMessage", timeLeft)
			end
			local module = BigWigs:GetPlugin("Sounds", true)
			if timeLeft < 6 and module and module.db.profile.sound then
				plugin:SendMessage("BigWigs_PlayCountdownNumber", plugin, timeLeft)
			end
		end
	end
	function startPull(seconds, nick, isDBM)
		if (not UnitIsGroupLeader(nick) and not UnitIsGroupAssistant(nick) and not UnitIsUnit(nick, "player")) or (IsEncounterInProgress() and nick ~= COMBAT) then return end
		seconds = tonumber(seconds)
		if not seconds or seconds < 0 or seconds > 60 then return end
		seconds = floor(seconds)
		if timeLeft == seconds then return end -- Throttle
		timeLeft = seconds
		if timer then
			plugin:CancelTimer(timer)
			if seconds == 0 then
				timeLeft = 0
				BigWigs:Print(L.pullStopped:format(nick))
				plugin:SendMessage("BigWigs_StopBar", plugin, L.pull)
				plugin:SendMessage("BigWigs_StopPull", plugin, seconds, nick, isDBM)
				return
			end
		end
		FlashClientIcon()
		BigWigs:Print(L.pullStarted:format(isDBM and "DBM" or "BigWigs", nick))
		timer = plugin:ScheduleRepeatingTimer(printPull, 1)
		plugin:SendMessage("BigWigs_Message", plugin, nil, L.pullIn:format(timeLeft), "Attention")
		plugin:SendMessage("BigWigs_Sound", plugin, nil, "Long")
		plugin:SendMessage("BigWigs_StartBar", plugin, nil, L.pull, seconds, "Interface\\Icons\\ability_warrior_charge")
		plugin:SendMessage("BigWigs_StartPull", plugin, seconds, nick, isDBM)
	end
end

function plugin:OnDBMSync(_, sender, prefix, seconds, text)
	if prefix == "PT" then
		startPull(seconds, sender, true)
	end
end

function plugin:OnSync(sync, seconds, nick)
	if seconds and nick then
		startPull(seconds, nick)
	end
end

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

