
local throt, times = {}, {}


BigWigsComm = AceAddon:new({
	name          = "BigWigsComm",
	cmd           = AceChatCmd:new({}, {}),
})


function BigWigsComm:Enable()
	if oRA_Core then oRA_Core:AddCheck("BIGWIGS_SYNC_RECV","BIGWIGSSYNC") end
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

function BigWigsComm:BIGWIGS_SYNC_RECV(a1, a2, a3, a4, a5, a6, a7, a8 )
	local msg = oRA_Core:Clean(a1)
	local _, _, msg = string.find(msg, "^BIGWIGSSYNC (.*)$")
	local nick = a2

	if not msg then return end

	local _, _, sync, rest = string.find(msg, "^(%S+)%s*(.*)$")

	if not throt[msg] or not times[msg] or (times[msg] + throt[msg]) <= GetTime() then
		self:TriggerEvent("BIGWIGS_SYNC_"..sync, rest, nick)
		times[msg] = GetTime()
	end
end


function BigWigsComm:BIGWIGS_SYNC_SEND(msg)
	if oRA_Core then oRA_Core:Send("BIGWIGSSYNC " .. msg) end
end


function BigWigsComm:BIGWIGS_SYNC_THROTTLE(msg, time)
	assert(msg, "No message passed")
	assert(time, "No time passed")

	throt[msg] = time
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsComm:RegisterForLoad()
