-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("AutoReply")
if not plugin then return end

-------------------------------------------------------------------------------
-- Database
--

plugin.defaultDB = {
	disabled = true,
}

--------------------------------------------------------------------------------
-- Locals
--

local SendChatMessage = BigWigsLoader.SendChatMessage
local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
plugin.displayName = L.autoReply
local curDiff = 0
local curModule = nil
local throttle = {}

-------------------------------------------------------------------------------
-- Options
--

plugin.pluginOptions = {
	name = L.autoReply,
	desc = L.autoReplyDesc,
	type = "group",
	get = function(info)
		return plugin.db.profile[info[#info]]
	end,
	set = function(info, value)
		local entry = info[#info]
		plugin.db.profile[entry] = value
	end,
	args = {
		heading = {
			type = "description",
			name = L.autoReplyDesc.. "\n\n",
			order = 0,
			width = "full",
			fontSize = "medium",
		},
		disabled = {
			type = "toggle",
			name = L.disabled,
			width = "full",
			order = 1,
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
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:BigWigs_OnBossEngage(module, difficulty)
	if self.db.profile.enabled then
		curDiff = difficulty
		curModule = module
		throttle = {}
		self:RegisterEvent("CHAT_MSG_WHISPER")
	end
end

function plugin:BigWigs_OnBossWin()
	if self.db.profile.enabled then
		curDiff = 0
		curModule = nil
		self:UnregisterEvent("CHAT_MSG_WHISPER")
	end
end

function plugin:CHAT_MSG_WHISPER(event, msg, sender)
	if curDiff > 0 then
		if not throttle[sender] or GetTime() - throttle[sender] > 5 then
			local msg = L.autoReplyBasic:format(curModule.displayName)
			SendChatMessage(msg, "WHISPER", sender)
		end
	end
end
