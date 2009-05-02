assert(BigWigs, "BigWigs not found!")

----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:New("Comm", "$Revision$")
if not plugin then return end

------------------------------
--      Are you local?      --
------------------------------

local throt, times = {}, {}
local playerName = UnitName("player")

local coreSyncs = {
	BossEngaged = 5,
	BossDeath = 5,
	MultiBossDeath = 5,
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
	self:RegisterEvent("BigWigs_SendSync")
	self:RegisterEvent("BigWigs_ThrottleSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function plugin:CHAT_MSG_ADDON(prefix, message, type, sender)
	if prefix ~= "BigWigs" then return end
	local sync, rest = select(3, message:find("(%S+)%s*(.*)$"))
	if not sync then return end

	if throt[sync] == nil then throt[sync] = 1 end
	if throt[sync] == 0 or not times[sync] or (times[sync] + throt[sync]) <= GetTime() then
		self:TriggerEvent("BigWigs_RecvSync", sync, rest, sender)
		times[sync] = GetTime()
	end
end

function plugin:BigWigs_SendSync(msg)
	local sync, rest = select(3, msg:find("(%S+)%s*(.*)$"))
	if not sync then return end

	if throt[sync] == nil then throt[sync] = 1 end
	if throt[sync] == 0 or not times[sync] or (times[sync] + throt[sync]) <= GetTime() then	
		times[sync] = GetTime()
		SendAddonMessage("BigWigs", msg, "RAID")
		self:TriggerEvent("BigWigs_RecvSync", sync, rest, playerName)
	end
end

function plugin:BigWigs_ThrottleSync(msg, ...)
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

