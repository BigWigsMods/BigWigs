
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
	Timex:AddSchedule("BIGWIGS_BAR_DELAYEDSETCOLOR "..text..time, time, nil, nil, "BIGWIGS_BAR_SETCOLOR", text, color)
end


function BigWigsDelay:BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL(text, time)
	if not text or not time then return end
	Timex:DeleteSchedule("BIGWIGS_BAR_DELAYEDSETCOLOR "..text..time)
end


function BigWigsDelay:BIGWIGS_DELAYEDMESSAGE_START(text, time, color, noraidsay)
	if not text or not time then return end
	Timex:AddNamedSchedule("BIGWIGS_DELAYEDMESSAGE "..text, time, nil, nil, "BIGWIGS_MESSAGE", text, color, noraidsay)
end


function BigWigsDelay:BIGWIGS_DELAYEDMESSAGE_CANCEL(text)
	if not text then return end
	Timex:DeleteSchedule("BIGWIGS_DELAYEDMESSAGE "..text)
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsDelay:RegisterForLoad()
