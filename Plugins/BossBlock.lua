-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("BossBlock")
if not plugin then return end

-------------------------------------------------------------------------------
-- Event Handlers
--

local function IsSpam(_, _, msg)
	if msg:find("***", nil, true) then
		return true
	end
end

local rwf = RaidWarningFrame
local RaidWarningFrame_OnEvent = RaidWarningFrame_OnEvent
local handler = CreateFrame("Frame")
handler:SetScript("OnEvent", function(_, event, msg, ...)
	if not IsSpam(nil, nil, msg) then
		RaidWarningFrame_OnEvent(rwf, event, msg, ...)
	end
end)

function plugin:OnPluginEnable()
	if not BigWigs.db.profile.showBlizzardWarnings then
		RaidBossEmoteFrame:UnregisterEvent("RAID_BOSS_EMOTE")
	end

	if not BigWigs.db.profile.showBossmodChat then
		RaidWarningFrame:UnregisterEvent("CHAT_MSG_RAID_WARNING")
		handler:RegisterEvent("CHAT_MSG_RAID_WARNING")

		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", IsSpam)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", IsSpam)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", IsSpam)
	end
end

function plugin:OnPluginDisable()
	if not BigWigs.db.profile.showBlizzardWarnings then
		RaidBossEmoteFrame:RegisterEvent("RAID_BOSS_EMOTE")
	end
	if not BigWigs.db.profile.showBossmodChat then
		RaidWarningFrame:RegisterEvent("CHAT_MSG_RAID_WARNING")
		handler:UnregisterEvent("CHAT_MSG_RAID_WARNING")

		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", IsSpam)
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_WARNING", IsSpam)
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", IsSpam)
	end
end

