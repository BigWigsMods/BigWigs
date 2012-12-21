-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("BossBlock")
if not plugin then return end

-------------------------------------------------------------------------------
-- Event Handlers
--

local function filter(_, _, msg)
	if plugin:IsSpam(msg) then return true end
end

function plugin:OnRegister()
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filter)
end

do
	local rwf = RaidWarningFrame
	local rbe = RaidBossEmoteFrame
	local hook = nil
	function plugin:OnPluginEnable()
		if not hook then
			hook = RaidNotice_AddMessage
			RaidNotice_AddMessage = function(frame, msg, ...)
				if frame == rwf and self:IsSpam(msg) then
					return
				elseif frame == rbe and not BigWigs.db.profile.showBlizzardWarnings then
					return
				end
				hook(frame, msg, ...)
			end
		end
	end
end

function plugin:IsSpam(text)
	if not BigWigs.db.profile.showBossmodChat and type(text) == "string" and text:find("***", nil, true) then
		return true
	end
end

