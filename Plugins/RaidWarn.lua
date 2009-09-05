----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewPlugin("RaidWarning", "$Revision$")
if not plugin then return end

------------------------------
--      Are you local?      --
------------------------------

local sentWhispers = {}
local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Plugins")

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	whisper = true,
}
plugin.consoleCmd = L["RaidWarning"]
plugin.advancedOptions = {
	type = "group",
	name = L["RaidWarning"],
	desc = L["raidwarning_desc"],
	args = {
		whisper = {
			type = "toggle",
			name = L["Whisper"],
			desc = L["Toggle whispering warnings to players."],
			get = function() return plugin.db.profile.whisper end,
			set = function(v) plugin.db.profile.whisper = v end,
		},
	},
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
	sentWhispers = wipe(sentWhispers)
end

function plugin:BigWigs_SendTell(event, player, msg)
	if not self.db.profile.whisper or not player or not msg then return end
	if not UnitIsPlayer(player) then return end
	if UnitInRaid("player") and not IsRaidLeader() and not IsRaidOfficer() then return end
	sentWhispers[msg] = true
	SendChatMessage(msg, "WHISPER", nil, player)
end

