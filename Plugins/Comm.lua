
assert(BigWigs, "BigWigs not found!")


------------------------------
--      Are you local?      --
------------------------------

local throt, times = {}, {}


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsComm = BigWigs:NewModule("Comm")


------------------------------
--      Initialization      --
------------------------------

function BigWigsComm:OnEnable()
	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterEvent("BigWigs_SendSync")
	self:RegisterEvent("BigWigs_ThrottleSync")
end


------------------------------
--      Event Handlers      --
------------------------------

function BigWigsComm:CHAT_MSG_ADDON(prefix, message, type, sender)
	if (prefix ~= "BigWigs" or type ~= "RAID") then return end

	local _, _, sync, rest = string.find(message, "(%S+)%s*(.*)$")
	if not sync then return end

	if throt[sync] == nil then throt[sync] = 1 end
	if throt[sync] == 0 or not times[sync] or (times[sync] + throt[sync]) <= GetTime() then
		self:TriggerEvent("BigWigs_RecvSync", sync, rest, sender)
		times[sync] = GetTime()
	end
end


function BigWigsComm:BigWigs_SendSync(msg)
	SendAddonMessage("BigWigs", msg, "RAID")
	self:CHAT_MSG_ADDON("BigWigs", msg, "RAID", UnitName("player"))
end


function BigWigsComm:BigWigs_ThrottleSync(msg, time)
	assert(msg, "No message passed")
	throt[msg] = time
end
