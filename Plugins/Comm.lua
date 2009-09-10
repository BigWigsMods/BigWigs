----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewPlugin("Comm")
if not plugin then return end

------------------------------
--      Are you local?      --
------------------------------

local throt, times = {}, {}
local playerName = UnitName("player")

local coreSyncs = {
	BossEngaged = 5,
	Death = 5,
}

------------------------------
--      Initialization      --
------------------------------

function plugin:OnRegister()
	for k, v in pairs(coreSyncs) do
		self:BigWigs_ThrottleSync(k, v)
	end
end

function plugin:OnEnable()
	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterMessage("BigWigs_SendSync")
	self:RegisterMessage("BigWigs_ThrottleSync")
	self:RegisterMessage("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function plugin:BigWigs_RecvSync(event, sync, rest, nick)
	if sync ~= "BossEngaged" then return end
	local m = BigWigs:GetBossModule(rest, true)
	if not m then error("Got a BossEngaged sync for " .. tostring(rest) .. ", but there's no such module.") end
	m:UnregisterEvent("PLAYER_REGEN_DISABLED")
	m:OnEngageWrapper(nick)
end

function plugin:CHAT_MSG_ADDON(event, prefix, message, type, sender)
	if prefix ~= "BigWigs" then return end
	local sync, rest = select(3, message:find("(%S+)%s*(.*)$"))
	if not sync then return end

	if throt[sync] == nil then throt[sync] = 1 end
	if throt[sync] == 0 or not times[sync] or (times[sync] + throt[sync]) <= GetTime() then
		self:SendMessage("BigWigs_RecvSync", sync, rest, sender)
		times[sync] = GetTime()
	end
end

function plugin:BigWigs_SendSync(event, msg)
	local sync, rest = select(3, msg:find("(%S+)%s*(.*)$"))
	if not sync then return end

	if throt[sync] == nil then throt[sync] = 1 end
	if throt[sync] == 0 or not times[sync] or (times[sync] + throt[sync]) <= GetTime() then	
		times[sync] = GetTime()
		SendAddonMessage("BigWigs", msg, "RAID")
		self:SendMessage("BigWigs_RecvSync", sync, rest, playerName)
	end
end

function plugin:BigWigs_ThrottleSync(event, msg, ...)
	if type(msg) == "number" then
		for i = 1, select("#", ...) do
			throt[(select(i, ...))] = msg
		end
	else
		throt[msg] = select(1, ...)
	end
end

function plugin:GetThrottleTable() return throt end
function plugin:GetTimesTable() return times end

