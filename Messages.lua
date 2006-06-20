
local cmdopt = {
	option = "msg",
	desc   = "Options for the message frame.",
	input  = true,
	args   = {
		{
			option = "anchor",
			desc   = "Show the message anchor frame.",
			method = "BIGWIGS_SHOW_ANCHORS",
		},
		{
			option = "err",
			desc   = "Toggle sending messages to the Blizzard error frame.",
			method = "ToggleErr",
		},
		{
			option = "white",
			desc   = "Toggles white only messages ignoring coloring.",
			method = "ToggleWhite",
		},
		{
			option = "scale",
			desc   = "Set the bar scale.",
			method = "SetScale",
			input  = true,
		},
	},
}

BigWigsMessages = AceAddon:new({
	name          = "BigWigsMessages",
	cmd           = AceChatCmd:new({}, {}),
	cmdOptions    = cmdopt,
})


function BigWigsMessages:Initialize()
	BigWigs:RegisterModule(self)

	self.anchorframe = BigWigsMsgAnchorFrame
	self.uierrorsframe = UIErrorsFrame

	self.msgframe = BigWigsTextFrame
	self.msgframe:SetWidth(512)
	self.msgframe:SetHeight(200)

	self.msgframe:SetPoint("TOP", self.anchorframe, "BOTTOM", 0, 0)
	self.msgframe:SetScale(self:GetOpt("scale") or 1)

	-- self.msgframe:SetJustifyV("TOP")
	-- self.msgframe:SetFrameStrata("HIGH")
	self.msgframe:SetFontObject(ErrorFont)
	self.msgframe:Show()
end


function BigWigsMessages:Enable()
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("BIGWIGS_SHOW_ANCHORS")
	self:RegisterEvent("BIGWIGS_HIDE_ANCHORS")
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


function BigWigsMessages:BIGWIGS_MESSAGE(text, color, noraidsay)
	if not text then return end
	local red, green, blue = ( (not self:GetOpt("White")) and BigWigs:GetColor(color) )
	local f = self:GetOpt("ToErr") and self.uierrorsframe or self.msgframe
	f:AddMessage(text, red or 1, green or 1, blue or 1, 1, UIERRORS_HOLD_TIME)
end


------------------------------
--      Slash Handlers      --
------------------------------

function BigWigsMessages:SetScale(msg)
	local scale = tonumber(msg)
	if scale and scale >= 0.25 and scale <= 5 then
		self:SetOpt(scale, "scale")
		self.msgframe:SetScale(scale)
		self.cmd:result(string.format("Scale is set to %s", scale))
	end
end


function BigWigsMessages:ToggleErr()
	local t = self:TogOpt("ToErr")
	self.cmd:msg("Messages now sent to: ".. (t and "Blizzard frame" or "BigWigs frame"))
end


function BigWigsMessages:ToggleWhite()
	local t = self:TogOpt("White")
	self.cmd:msg("Coloring all messages white is now: " .. (t and "On" or "Off"))
end

--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsMessages:RegisterForLoad()
