-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("BossBlock", "AceHook-3.0")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local fnd = string.find
local type = type

-------------------------------------------------------------------------------
-- Event Handlers
--

local function filter(self, event, msg)
	if plugin:IsSpam(msg) then return true end
end

function plugin:OnRegister()
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filter)
end

function plugin:OnPluginEnable()
	self:RawHook("RaidNotice_AddMessage", "RWAddMessage", true)
end

local rwf = _G.RaidWarningFrame
local rbe = _G.RaidBossEmoteFrame
function plugin:RWAddMessage(frame, message, colorInfo)
	if frame == rwf and self:IsSpam(message) then
		return
	elseif frame == rbe and not BigWigs.db.profile.showBlizzardWarnings then
		return
	end
	self.hooks["RaidNotice_AddMessage"](frame, message, colorInfo)
end

function plugin:IsSpam(text)
	if BigWigs.db.profile.showBossmodChat then return end
	if type(text) ~= "string" then return end
	if fnd(text, "%*%*%*") then return true end
end
