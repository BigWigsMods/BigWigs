
if GetBuildInfo() == "1.12" then return end
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
	self:RegisterEvent("CHAT_MSG_CHANNEL")
	self:RegisterEvent("BigWigs_SendSync")
	self:RegisterEvent("BigWigs_ThrottleSync")
end


------------------------------
--      Event Handlers      --
------------------------------

-- Handle inbound chatter when the user runs CTRA
function BigWigsComm:CHAT_MSG_CHANNEL(msg, sender, sschan, arg4, arg5, arg6, arg7, arg8, chan)
	if sschan ~= "SelfSync" and (not CT_RA_Channel or string.lower(chan) ~= string.lower(CT_RA_Channel)) then return end

	local cleanmsg = string.gsub(msg, "%$", "s")
	cleanmsg = string.gsub(cleanmsg, "§", "S")
	if strsub(cleanmsg, strlen(cleanmsg)-7) == " ...hic!" then cleanmsg = strsub(cleanmsg, 1, strlen(cleanmsg)-8) end

	local msgarr = self:SplitMessage(cleanmsg, "#")
	
 	for _, c in msgarr do
		local _, _, sync, rest = string.find(c, "^BigWigsSync (%S+)%s*(.*)$")
		if sync and not throt[sync] or not times[sync] or (times[sync] + throt[sync]) <= GetTime() then
			self:TriggerEvent("BigWigs_RecvSync", sync, rest, sender)
			times[sync] = GetTime()
		end
	end
end

function BigWigsComm:BigWigs_SendSync(msg)
	if oRA_Core then oRA_Core:Send("BigWigsSync " .. msg)
	elseif CT_RA_AddMessage then CT_RA_AddMessage("BigWigsSync " .. msg) end
	self:CHAT_MSG_CHANNEL("BigWigsSync " .. msg, UnitName("player"), "SelfSync")
end


function BigWigsComm:BigWigs_ThrottleSync(msg, time)
	assert(msg, "No message passed")

	throt[msg] = time
end


function BigWigsComm:SplitMessage( msg, char )
	local arr = { }
	while (string.find(msg, char) ) do
		local iStart, iEnd = string.find(msg, char)
		table.insert(arr, strsub(msg, 1, iStart-1))
		msg = strsub(msg, iEnd+1, strlen(msg))
	end
	if ( strlen(msg) > 0 ) then
		table.insert(arr, msg)
	end
	return arr
end
