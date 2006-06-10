

BigWigsSound = AceAddon:new({
	name          = "BigWigsSound",
	cmd           = AceChatCmd:new({}, {}),
})


function BigWigsSound:Enable()
	self:RegisterEvent("BIGWIGS_MESSAGE")
end


function BigWigsSound:Disable()
	self:UnregisterAllEvents()
end


function BigWigsSound:BIGWIGS_MESSAGE(text, color, noraidsay, sound)
	if not text or sound == 0 then return end
	PlaySoundFile("Interface\\AddOns\\BigWigs\\msg.wav")
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsSound:RegisterForLoad()
