
local throt, times = {}, {}


BigWigsComm = AceAddon:new({
	name          = "BigWigsComm",
	cmd           = AceChatCmd:new({}, {}),
})


function BigWigsComm:Enable()
	self:RegisterEvent("CHAT_MSG_CHANNEL")
	self:RegisterEvent("BIGWIGS_SYNC_RECV")
	self:RegisterEvent("BIGWIGS_SYNC_SEND")
	self:RegisterEvent("BIGWIGS_SYNC_THROTTLE")
end


function BigWigsComm:Disable()
	self:UnregisterAllEvents()
end


------------------------------
--      Event Handlers      --
------------------------------

-- Handle inbound chatter when the user runs CTRA
function BigWigsComm:CHAT_MSG_CHANNEL()
	if not CT_RA_Channel or string.lower(arg9) ~= string.lower(CT_RA_Channel) then return end

	local cleanmsg = string.gsub(arg1, "%$", "s")
	cleanmsg = string.gsub(cleanmsg, "§", "S")
	if strsub(cleanmsg, strlen(cleanmsg)-7) == " ...hic!" then cleanmsg = strsub(cleanmsg, 1, strlen(cleanmsg)-8) end

	local _, _, sync, rest = string.find(cleanmsg, "^BIGWIGSSYNC (%S+)%s*(.*)$")
	if not sync then return end

	if not throt[sync] or not times[sync] or (times[sync] + throt[sync]) <= GetTime() then
		self:TriggerEvent("BIGWIGS_SYNC_"..sync, rest, arg2)
		times[sync] = GetTime()
	end
end


function BigWigsComm:BIGWIGS_SYNC_SEND(msg)
	if oRA_Core then oRA_Core:Send("BIGWIGSSYNC " .. msg)
	elseif CT_RA_AddMessage then CT_RA_AddMessage("BIGWIGSSYNC " .. msg) end
end


function BigWigsComm:BIGWIGS_SYNC_THROTTLE(msg, time)
	assert(msg, "No message passed")

	throt[msg] = time
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsComm:RegisterForLoad()
