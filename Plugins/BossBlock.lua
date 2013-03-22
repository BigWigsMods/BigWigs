-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("BossBlock")
if not plugin then return end

-------------------------------------------------------------------------------
-- Event Handlers
--

local function chatFilter(_, _, msg)
	if msg:find("***", nil, true) then
		return true
	end
end

function plugin:OnPluginEnable()
	if not BigWigs.db.profile.showBlizzardWarnings then
		RaidBossEmoteFrame:UnregisterEvent("RAID_BOSS_EMOTE")
		RaidBossEmoteFrame:UnregisterEvent("RAID_BOSS_WHISPER")
	end

	RaidWarningFrame:UnregisterEvent("CHAT_MSG_RAID_WARNING")
	self:RegisterEvent("CHAT_MSG_RAID_WARNING")

	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", chatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", chatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", chatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", chatFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", chatFilter)
end

function plugin:OnPluginDisable()
	if not BigWigs.db.profile.showBlizzardWarnings then
		RaidBossEmoteFrame:RegisterEvent("RAID_BOSS_EMOTE")
		RaidBossEmoteFrame:RegisterEvent("RAID_BOSS_WHISPER")
	end

	RaidWarningFrame:RegisterEvent("CHAT_MSG_RAID_WARNING")

	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", chatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_WARNING", chatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", chatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", chatFilter)
	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", chatFilter)
end

do
	-- We still need this to block DBM's stupid countdown broadcast
	local RaidWarningFrame = RaidWarningFrame
	local RaidWarningFrame_OnEvent = RaidWarningFrame_OnEvent
	function plugin:CHAT_MSG_RAID_WARNING(event, msg, ...)
		if not msg:find("***", nil, true) then
			RaidWarningFrame_OnEvent(RaidWarningFrame, event, msg, ...)
		end
	end
end

