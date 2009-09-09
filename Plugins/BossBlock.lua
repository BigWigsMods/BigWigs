----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewPlugin("BossBlock", "$Revision$", "AceHook-3.0")
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

function plugin:OnPluginEnable()
	self:RawHook("RaidNotice_AddMessage", "RWAddMessage", true)
	self:RegisterMessage("BigWigs_OnBossEnable")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
end

do
	local bossNames = {}
	local bossId = {}

	local function checkId(unit)
		if UnitIsPlayer(unit) then return end
		local n = UnitName(unit)
		if not n or bossNames[n] then return end
		local id = tonumber((UnitGUID(unit)):sub(-12, -7), 16)
		if not id then return end
		if bossId[id] then
			bossNames[n] = true
			bossId[id] = nil
		end
	end
	function plugin:UPDATE_MOUSEOVER_UNIT() checkId("mouseover") end
	function plugin:PLAYER_TARGET_CHANGED() checkId("target") end

	function plugin:BigWigs_OnBossEnable(message, mod)
		local t = type(mod.enabletrigger)
		if t == "table" then
			for i, v in next, mod.enabletrigger do bossId[v] = true end
		elseif t == "number" then
			bossId[mod.enabletrigger] = true
		end
		t = mod.blockEmotes and type(mod.blockEmotes) or nil
		if not t then return end
		if t == "table" then
			for i, v in next, mod.blockEmotes do bossNames[BigWigs:GetLocalBossName(v)] = true end
		elseif t == "string" then
			bossNames[BigWigs:GetLocalBossName(mod.blockEmotes)] = true
		end
	end

	local rwf = _G.RaidWarningFrame
	local rbe = _G.RaidBossEmoteFrame
	function plugin:RWAddMessage(frame, message, colorInfo)
		if frame == rwf and self:IsSpam(message) then
			return
		elseif frame == rbe and type(arg2) == "string" and bossNames[arg2] then
			return
		end
		self.hooks["RaidNotice_AddMessage"](frame, message, colorInfo)
	end
end

function plugin:IsSpam(text)
	if type(text) ~= "string" then return end
	if fnd(text, "%*%*%*") then return true end
end

