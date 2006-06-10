
local metro = Metrognome:GetInstance("1")


BigWigsDelay = AceAddon:new({
	name          = "BigWigsDelay",
	cmd           = AceChatCmd:new({}, {}),
})


function BigWigsDelay:Enable()
	self:RegisterEvent("BIGWIGS_DELAYEDMESSAGE_START")
	self:RegisterEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL")
	self:RegisterEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START")
	self:RegisterEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL")
end


function BigWigsDelay:Disable()
	self:UnregisterAllEvents()
end


------------------------------
--      Event Handlers      --
------------------------------

function BigWigsDelay:BIGWIGS_BAR_DELAYEDSETCOLOR_START(text, time, color)
	if not text or not time then return end
	self:debug(string.format("BIGWIGS_BAR_DELAYEDSETCOLOR | %s | %s | %s", text, time, type(color) == "string" and color or type(color)))
	local id = "BIGWIGS_BAR_DELAYEDSETCOLOR "..text..time
	metro:Unregister(id)
	metro:Register(id, self.TriggerEvent, time, self, "BIGWIGS_BAR_SETCOLOR", text, color)
	metro:Start(id, 1)
end


function BigWigsDelay:BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL(text, time)
	if not text or not time then return end
	metro:Unregister("BIGWIGS_BAR_DELAYEDSETCOLOR "..text..time)
end


function BigWigsDelay:BIGWIGS_DELAYEDMESSAGE_START(text, time, color, noraidsay, sound)
	if not text or not time then return end
	local id = "BIGWIGS_DELAYEDMESSAGE "..text
	metro:Unregister(id)
	metro:Register(id, self.TriggerEvent, time, self, "BIGWIGS_MESSAGE", text, color, noraidsay, sound)
	metro:Start(id, 1)
end


function BigWigsDelay:BIGWIGS_DELAYEDMESSAGE_CANCEL(text)
	if not text then return end
	metro:Unregister("BIGWIGS_DELAYEDMESSAGE "..text)
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsDelay:RegisterForLoad()
