----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewPlugin("Broadcast")
if not plugin then return end

------------------------------
--      Are you local?      --
------------------------------

local sentWhispers = {}
local output = "*** %s ***"
local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	whisper = true,
	broadcast = false,
	useraidchannel = false,
}

------------------------------
--      Initialization      --
------------------------------

local function filter(self, event, msg) if sentWhispers[msg] then return true end end
function plugin:OnRegister()
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filter)
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_SendTell")
	self:RegisterMessage("BigWigs_Message")
	sentWhispers = wipe(sentWhispers)
end

function plugin:BigWigs_Message(msg, color, noraidsay)
	if not msg or noraidsay or not self.db.profile.broadcast then return end

	local inRaid = UnitInRaid("player")
	-- In a 5-man group, everyone can use the raid warning channel.
	if inRaid and not IsRaidLeader() and not IsRaidOfficer() then
		return
	elseif GetNumPartyMembers() == 0 and not inRaid then
		return
	end

	local clean = msg:gsub("(|c%x%x%x%x%x%x%x%x)", ""):gsub("(|r)", "")
	local o = output:format(clean)
	if self.db.profile.useraidchannel then
		SendChatMessage(o, inRaid and "RAID" or "PARTY")
	else
		SendChatMessage(o, "RAID_WARNING")
	end
end

function plugin:BigWigs_SendTell(event, player, msg)
	if not self.db.profile.whisper or not player or not msg then return end
	if not UnitIsPlayer(player) then return end
	if UnitInRaid("player") and not IsRaidLeader() and not IsRaidOfficer() then return end
	sentWhispers[msg] = true
	SendChatMessage(msg, "WHISPER", nil, player)
end

