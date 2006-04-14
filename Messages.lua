

BigWigsMessages = AceAddon:new({
	name          = "BigWigsMessages",
	cmd           = AceChatCmd:new({}, {}),

--	sendtoerrors = true,
})


function BigWigsMessages:Initialize()
	self.anchorframe = getglobal("BigWigsAnchorFrame")
	self.uierrorsframe = getglobal("UIErrorsFrame")

	self.msgframe = getglobal("BigWigsTextFrame")
	self.msgframe:SetWidth(512)
	self.msgframe:SetHeight(200)
	self.msgframe:SetPoint("TOP", self.anchorframe, "BOTTOM")
	self.msgframe:SetJustifyV("TOP")
	self.msgframe:SetFrameStrata("HIGH")
	self.msgframe:SetFontObject(ErrorFont)
	self.msgframe:Show()
end


function BigWigsMessages:Enable()
	self:RegisterEvent("BIGWIGS_MESSAGE")
end


function BigWigsMessages:Disable()
	self:UnregisterAllEvents()
end


function BigWigsMessages:BIGWIGS_MESSAGE(text, color, noraidsay)
	if not text then return end
	local red, green, blue = BigWigs:GetColor(color)
	local f = self.sendtoerrors and self.uierrorsframe or self.msgframe
	f:AddMessage(text, red or 1, green or 1, blue or 1, 1, UIERRORS_HOLD_TIME)
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsMessages:RegisterForLoad()
