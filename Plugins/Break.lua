-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin, L = BigWigs:NewPlugin("Break")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

--local GetInstanceInfo = BigWigsLoader.GetInstanceInfo
--local DoCountdown = BigWigsLoader.DoCountdown
--local zoneTable = BigWigsLoader.zoneTbl
--local IsEncounterInProgress = IsEncounterInProgress
--local media = LibStub("LibSharedMedia-3.0")
--local SOUND = media.MediaType and media.MediaType.SOUND or "sound"

-------------------------------------------------------------------------------
-- Options
--

-------------------------------------------------------------------------------
-- Initialization
--

do
	--[[local function updateProfile()
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
	end]]

	function plugin:OnPluginEnable()
		--self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
		--updateProfile()

		self:RegisterMessage("BigWigs_PluginComm")
		self:RegisterMessage("DBM_AddonMessage")

		local tbl = BigWigs3DB.breakTime
		if tbl then -- Break time present, resume it
			self:SimpleTimer(function() -- Timers aren't fully functional until 1 frame after loading is done, we need to make sure we're not in an initial loading screen
				self:SimpleTimer(function()
					local prevTime, seconds, nick, isDBM = tbl[1], tbl[2], tbl[3], tbl[4]
					local curTime = time()
					if curTime-prevTime > seconds then
						BigWigs3DB.breakTime = nil
					else
						self:StartBreak(seconds-(curTime-prevTime), nick, isDBM, true)
					end
				end, 0)
			end, 0)
		end
	end
end

-------------------------------------------------------------------------------
-- Event Handlers
--

do
	local function Print60()
		plugin:SendMessage("BigWigs_Message", plugin, nil, L.breakMinutes:format(1), "yellow", 134062)
	end
	local function Print30()
		plugin:SendMessage("BigWigs_Message", plugin, nil, L.breakSeconds:format(30), "orange", 134062)
	end
	local function Print10()
		plugin:SendMessage("BigWigs_Message", plugin, nil, L.breakSeconds:format(10), "orange", 134062)
	end
	local function Print5()
		plugin:SendMessage("BigWigs_Message", plugin, nil, L.breakSeconds:format(5), "orange", 134062)
	end
	local function PrintFinished()
		plugin:SendMessage("BigWigs_Message", plugin, nil, L.breakFinished, "red", 134062)
		plugin:SendMessage("BigWigs_Sound", plugin, nil, "Long")
		BigWigs3DB.breakTime = nil
	end

	local lastBreak = 0
	function plugin:StartBreak(seconds, nick, isDBM, reboot)
		if not reboot then
			if (not UnitIsGroupLeader(nick) and not UnitIsGroupAssistant(nick) and not UnitIsUnit(nick, "player")) or IsEncounterInProgress() then return end
			seconds = tonumber(seconds)
			if not seconds or seconds < 0 or seconds > 3600 or (seconds > 0 and seconds < 60) then return end -- 1h max, 1m min

			local t = GetTime()
			if t-lastBreak < 0.5 then return else lastBreak = t end -- Throttle
		end

		if BigWigs3DB.breakTime then
			self:CancelAllTimers()
			if seconds == 0 then
				BigWigs3DB.breakTime = nil
				BigWigs:Print(L.breakStopped:format(nick))
				plugin:SendMessage("BigWigs_StopBar", plugin, L.breakBar)
				plugin:SendMessage("BigWigs_StopBreak", plugin, seconds, nick, isDBM, reboot)
				return
			end
		elseif seconds == 0 then
			return
		end

		if not reboot then
			BigWigs3DB.breakTime = {time(), seconds, nick, isDBM}
		end

		BigWigs:Print(L.breakStarted:format(isDBM and "DBM" or "BigWigs", nick))

		if seconds > 30 then
			plugin:ScheduleTimer(Print30, seconds - 30) -- 134062 = "Interface\\Icons\\inv_misc_fork&knife"
		end
		if seconds > 10 then
			plugin:ScheduleTimer(Print10, seconds - 10)
		end
		if seconds > 5 then
			plugin:ScheduleTimer(Print5, seconds - 5)
		end
		plugin:ScheduleTimer(PrintFinished, seconds)

		if seconds > 119 then -- 2min
			plugin:ScheduleTimer(Print60, seconds - 60)
		end
		if seconds > 239 then -- 4min
			local half = seconds / 2
			local m = half % 60
			local halfMin = (half - m) / 60
			plugin:ScheduleTimer(function() self:SendMessage("BigWigs_Message", plugin, nil, L.breakMinutes:format(halfMin), "yellow", 134062) end, half + m)
		end

		plugin:SendMessage("BigWigs_Message", plugin, nil, seconds < 61 and L.breakSeconds:format(seconds) or L.breakMinutes:format(seconds/60), "green", 134062)
		if not reboot then
			plugin:SendMessage("BigWigs_Sound", plugin, nil, "Long")
		end
		plugin:SendMessage("BigWigs_StartBar", plugin, nil, L.breakBar, seconds, 134062)
		plugin:SendMessage("BigWigs_StartBreak", plugin, seconds, nick, isDBM, reboot, L.breakBar, 134062)
	end
end

function plugin:DBM_AddonMessage(_, sender, prefix, seconds, text)
	if prefix == "BT" then
		self:StartBreak(seconds, sender, true)
	end
end

function plugin:BigWigs_PluginComm(_, msg, seconds, sender)
	if seconds then
		if msg == "Break" then
			self:StartBreak(seconds, sender)
		end
	end
end

-------------------------------------------------------------------------------
-- Slash Handler
--

local SendAddonMessage = BigWigsLoader.SendAddonMessage
local dbmPrefix = BigWigsLoader.dbmPrefix
BigWigsAPI.RegisterSlashCommand("/break", function(input)
	if not plugin:IsEnabled() then BigWigs:Enable() end
	if IsEncounterInProgress() then BigWigs:Print(L.encounterRestricted) return end -- Doesn't make sense to allow this in combat
	if not IsInGroup() or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then -- Solo or leader/assist
		local minutes = tonumber(input)
		if not minutes or minutes < 0 or minutes > 60 or (minutes > 0 and minutes < 1) then BigWigs:Print(L.wrongBreakFormat) return end -- 1h max, 1m min

		if minutes ~= 0 then
			BigWigs:Print(L.sendBreak)
		end
		local seconds = minutes * 60
		plugin:Sync("Break", seconds)

		if IsInGroup() then
			local name = plugin:UnitName("player")
			local realm = GetRealmName()
			local normalizedPlayerRealm = realm:gsub("[%s-]+", "") -- Has to mimic DBM code
			local result = SendAddonMessage(dbmPrefix, ("%s-%s\t1\tBT\t%d"):format(name, normalizedPlayerRealm, seconds), IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- DBM message
			if type(result) == "number" and result ~= 0 then
				BigWigs:Error("BigWigs: Failed to send break timer. Error code: ".. result)
			end
		end
	else
		BigWigs:Print(L.requiresLeadOrAssist)
	end
end)
