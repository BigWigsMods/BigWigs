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

-------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	countType = "emphasized",
	combatLog = false,
	--gearCheck = true,
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
				name = L.countdownType,
				order = 1,
				values = {
					normal = L.normal,
					emphasized = L.emphasized,
				},
			},
			desc1 = {
				type = "description",
				name = "\n",
				order = 1.1,
				width = "full",
			},
			combatLog = {
				type = "toggle",
				name = L.combatLog,
				desc = L.combatLogDesc,
				order = 2,
				width = "full",
			},
			--desc2 = {
			--	type = "description",
			--	name = "",
			--	order = 2.1,
			--	width = "full",
			--},
			--gearCheck = {
			--	type = "toggle",
			--	name = "Bad Gear Check",
			--	desc = "Scan your equipped gear for potentially bad items when starting a pull timer.",
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
	self:RegisterMessage("BigWigs_PluginComm")
	self:RegisterMessage("DBM_AddonMessage")

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
			if self.db.profile.countType == "emphasized" then
				self:SendMessage("BigWigs_EmphasizedCountdownMessage", "")
			end
		elseif timeLeft > 2 and IsEncounterInProgress() then -- Cancel the pull timer if we ninja pulled
			self:CancelTimer(timer)
			timeLeft = 0
			BigWigs:Print(L.pullStopped:format(COMBAT))
			self:SendMessage("BigWigs_StopBar", self, L.pull)
			self:SendMessage("BigWigs_StopPull", self, COMBAT)
		elseif timeLeft < 11 then
			if self.db.profile.countType == "emphasized" then
				self:SendMessage("BigWigs_EmphasizedCountdownMessage", timeLeft)
			else
				self:SendMessage("BigWigs_Message", self, nil, L.pullIn:format(timeLeft), "Attention")
			end
			local module = BigWigs:GetPlugin("Sounds", true)
			if timeLeft < 6 and module and module.db.profile.sound then
				self:SendMessage("BigWigs_PlayCountdownNumber", self, timeLeft)
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

			--if self.db.profile.gearCheck then
			--	local _, zoneType = GetInstanceInfo()
			--	if zoneType == "raid" and IsInRaid() then
			--		for i = 1, 18 do
			--			-- 0 Poor/Grey, 1 Common/White, 2 Uncommon/Green, 3 Rare/Blue, 4 Epic/Purple, 5 Legendary, 6 Artifact, 7 Heirloom
			--			local quality = GetInventoryItemQuality("player", i)
			--			local itemId = GetInventoryItemID("player", i)
			--			local _, _, _, iLevel = GetItemInfo(itemId or 0) -- XXX this doesn't compensate for items that drop with multiple item levels
			--			if quality and (quality < 2 or iLevel < 300) then
			--				local msg = ("Bad Item Equipped: %s"):format(GetInventoryItemLink("player", i))
			--				BigWigs:Print(msg)
			--				self:SendMessage("BigWigs_Message", self, nil, msg, "Personal")
			--			end
			--		end
			--	end
			--end

			self:SendMessage("BigWigs_Message", self, nil, L.pullIn:format(timeLeft), "Attention")
			self:SendMessage("BigWigs_Sound", self, nil, "Long")
			self:SendMessage("BigWigs_StartBar", self, nil, L.pull, seconds, 132337) -- 132337 = "Interface\\Icons\\ability_warrior_charge"
			self:SendMessage("BigWigs_StartPull", self, seconds, nick, isDBM)
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

-------------------------------------------------------------------------------
-- Slash Handler
--

SlashCmdList.BIGWIGSPULL = function(input)
	if not plugin:IsEnabled() then BigWigs:Enable() end
	if IsEncounterInProgress() then BigWigs:Print(L.encounterRestricted) return end -- Doesn't make sense to allow this in combat
	if not IsInGroup() or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or ((IsInGroup(2) or not IsInRaid()) and UnitGroupRolesAssigned("player") == "TANK") then -- Solo or leader/assist or tank in LFG/5m
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
