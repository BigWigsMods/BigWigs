

BigWigsComm = AceAddon:new({
	name          = "BigWigsComm",
	cmd           = AceChatCmd:new({}, {}),
})


function BigWigsComm:Enable()
	if oRA_Core then oRA_Core:AddCheck("BIGWIGS_SYNC_RECV","BIGWIGSSYNC") end
	self:RegisterEvent("BIGWIGS_SYNC_RECV")
	self:RegisterEvent("BIGWIGS_SYNC_SEND")
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

	local _, _,sync,rest  = string.find(msg, "^(%S+)%s*(.*)$")

	self:TriggerEvent("BIGWIGS_SYNC_"..sync, rest )
end


function BigWigsComm:BIGWIGS_SYNC_SEND(msg)
	if oRA_Core then oRA_Core:Send("BIGWIGSSYNC " .. msg) end
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsComm:RegisterForLoad()
