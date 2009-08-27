----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:New("BossBlock", "$Revision$", "AceHook-2.1")
if not plugin then return end

----------------------------
--      Localization      --
----------------------------

local fnd = string.find
local type = type

------------------------------
--      Event Handlers      --
------------------------------

local function filter(self, event, msg)
	if plugin:IsSpam(msg) then return true end
end

function plugin:OnRegister()
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filter)
end

function plugin:OnEnable()
	self:Hook("RaidNotice_AddMessage", "RWAddMessage", true)
	self:RegisterEvent("Ace2_AddonEnabled", "BossModEnableDisable")
	self:RegisterEvent("Ace2_AddonDisabled", "BossModEnableDisable")
end

do
	local bossmobs = {}

	function plugin:BossModEnableDisable(mod)
		local t = mod and mod.enabletrigger and type(mod.enabletrigger) or nil
		if not t then return end
		if t == "table" then
			for i, v in ipairs(mod.enabletrigger) do
				bossmobs[v] = not bossmobs[v] and true or nil
			end
		elseif t == "string" then
			bossmobs[mod.enabletrigger] = not bossmobs[mod.enabletrigger] and true or nil
		end
	end

	do
		local rwf = _G.RaidWarningFrame
		local rbe = _G.RaidBossEmoteFrame
		function plugin:RWAddMessage(frame, message, colorInfo)
			if frame == rwf and self:IsSpam(message) then
				return
			elseif frame == rbe and type(arg2) == "string" and bossmobs[arg2] then
				return
			end
			self.hooks["RaidNotice_AddMessage"](frame, message, colorInfo)
		end
	end
end

function plugin:IsSpam(text)
	if type(text) ~= "string" then return end
	if fnd(text, "%*%*%*") then return true end
end

