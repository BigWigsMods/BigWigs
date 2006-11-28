assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local throt, times = {}, {}
local playerName = nil

local coreSyncs = {
	["BossEngaged"] = 5,
}

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsComm = BigWigs:NewModule("Comm")

------------------------------
--      Initialization      --
------------------------------

function BigWigsComm:OnRegister()
	playerName = UnitName("player")

	for k, v in pairs(coreSyncs) do
		self:BigWigs_ThrottleSync(k, v)
	end
end

function BigWigsComm:OnEnable()
	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterEvent("BigWigs_SendSync")
	self:RegisterEvent("BigWigs_ThrottleSync")
end


------------------------------
--      Event Handlers      --
------------------------------

function BigWigsComm:CHAT_MSG_ADDON(prefix, message, type, sender)
	if prefix ~= "BigWigs" or type ~= "RAID" then return end

	local _, _, sync, rest = string.find(message, "(%S+)%s*(.*)$")
	if not sync then return end

	if throt[sync] == nil then throt[sync] = 1 end
	if throt[sync] == 0 or not times[sync] or (times[sync] + throt[sync]) <= GetTime() then
		self:TriggerEvent("BigWigs_RecvSync", sync, rest, sender)
		times[sync] = GetTime()
	end
end


function BigWigsComm:BigWigs_SendSync(msg)
	local _, _, sync, rest = string.find(msg, "(%S+)%s*(.*)$")

	if not sync then return end

	if throt[sync] == nil then throt[sync] = 1 end
	if throt[sync] == 0 or not times[sync] or (times[sync] + throt[sync]) <= GetTime() then	
		SendAddonMessage("BigWigs", msg, "RAID")
		self:CHAT_MSG_ADDON("BigWigs", msg, "RAID", playerName)
	end
end


function BigWigsComm:BigWigs_ThrottleSync(msg, time)
	assert(msg, "No message passed")
	throt[msg] = time
end

function BigWigsComm:GetThrottleTable() return throt end
function BigWigsComm:GetTimesTable() return times end

