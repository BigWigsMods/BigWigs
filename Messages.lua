
local sendtoerrors = false

BigWigsMessages = AceAddon:new({
	name          = "BigWigsMessages",
	cmd           = AceChatCmd:new({}, {}),
})


function BigWigsMessages:Initialize()
	self.anchorframe = BigWigsMsgAnchorFrame
	self.uierrorsframe = UIErrorsFrame

	self.msgframe = BigWigsTextFrame
	self.msgframe:SetWidth(512)
	self.msgframe:SetHeight(200)

	self.msgframe:SetPoint("TOP", self.anchorframe, "BOTTOM", 0, 0)
	self:BIGWIGS_SCALE(BigWigs:GetOpt("nScale") or 1)

	-- self.msgframe:SetJustifyV("TOP")
	-- self.msgframe:SetFrameStrata("HIGH")
	self.msgframe:SetFontObject(ErrorFont)
	self.msgframe:Show()
end

function BigWigsMessages:Enable()
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("BIGWIGS_SHOW_ANCHORS")
	self:RegisterEvent("BIGWIGS_HIDE_ANCHORS")
	self:RegisterEvent("BIGWIGS_SCALE")
end


function BigWigsMessages:Disable()
	self:UnregisterAllEvents()
end


------------------------------
--      Event Handlers      --
------------------------------

function BigWigsMessages:BIGWIGS_SHOW_ANCHORS()
	self.anchorframe:Show()
end


function BigWigsMessages:BIGWIGS_HIDE_ANCHORS()
	self.anchorframe:Hide()
end


function BigWigsMessages:BIGWIGS_SCALE(scale)
	self.msgframe:SetScale(scale)
end


function BigWigsMessages:BIGWIGS_MESSAGE(text, color, noraidsay)
	if not text then return end
	local red, green, blue = BigWigs:GetColor(color)
	local f = sendtoerrors and self.uierrorsframe or self.msgframe
	f:AddMessage(text, red or 1, green or 1, blue or 1, 1, UIERRORS_HOLD_TIME)
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsMessages:RegisterForLoad()
