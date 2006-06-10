

BigWigsBars = AceAddon:new({
	name          = "BigWigsBars",
	cmd           = AceChatCmd:new({}, {}),
})


function BigWigsBars:Initialize()
	self.frame = BigWigsAnchorFrame
	-- self.testbutton = getglobal("BigWigsAnchorFrameTest")
	-- self.hidebutton = getglobal("BigWigsAnchorFrameHide")
end


function BigWigsBars:Enable()
	self:RegisterEvent("BIGWIGS_SHOW_ANCHORS")
	self:RegisterEvent("BIGWIGS_HIDE_ANCHORS")
	self:RegisterEvent("BIGWIGS_BAR_START")
	self:RegisterEvent("BIGWIGS_BAR_CANCEL")
	self:RegisterEvent("BIGWIGS_BAR_SETCOLOR")
end


function BigWigsBars:Disable()
	self:UnregisterAllEvents()
end


------------------------------
--      Event Handlers      --
------------------------------

function BigWigsBars:BIGWIGS_SHOW_ANCHORS()
	self.frame:Show()
end


function BigWigsBars:BIGWIGS_HIDE_ANCHORS()
	self.frame:Hide()
end


function BigWigsBars:BIGWIGS_BAR_START(text, time, bar, color, texture)
	if not text or not time then return end

	local red, green, blue = BigWigs:GetColor(color)
	local id = "BigWigsBar "..text
	TimexBar:Get(id)
	TimexBar:SetText(id, text)
	TimexBar:SetTexture(id, texture)
	TimexBar:SetColor(id, red or 0, green or 0, blue or 0)
	TimexBar:SetPoint(id, "TOP", "BigWigsAnchorFrame", "BOTTOM", 0, ((bar or 0) * (-15) + 5))
	TimexBar:SetScale(id, BigWigs:GetOpt("nScale"))
	TimexBar:Start(id, time)
end


function BigWigsBars:BIGWIGS_BAR_CANCEL(text)
	if not text then return end

	TimexBar:Stop("BigWigsBar "..text)
end


function BigWigsBars:BIGWIGS_BAR_SETCOLOR(text, color)
	if not text then return end
	self:debug(string.format("BIGWIGS_BAR_SETCOLOR | %s | %s", text, type(color) == "string" and color or type(color)))

	local red, green, blue = BigWigs:GetColor(color)
	local id = "BigWigsBar "..text
	TimexBar:SetColor(id, red or 0, green or 0, blue or 0)
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsBars:RegisterForLoad()
