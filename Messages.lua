
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
			option = "rw",
			desc   = "Toggle sending messages to the RaidWarnings frame.",
			method = "ToggleRW",
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
local rwframe, frame
local dewdrop = DewdropLib:GetInstance("1.0")

BigWigsMessages = AceAddon:new({
	name          = "BigWigsMessages",
	cmd           = AceChatCmd:new({}, {}),
	cmdOptions    = cmdopt,

	loc = {
		menutitle = "Message frame",
	}
})


function BigWigsMessages:Initialize()
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
	self.anchorframe, rwframe = BigWigsMsgAnchorFrame, RaidWarningFrame
	frame = self:GetOpt("NotRW") and self:CreateMsgFrame() or RaidWarningFrame
end


function BigWigsMessages:Enable()
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("BIGWIGS_SHOW_ANCHORS")
	self:RegisterEvent("BIGWIGS_HIDE_ANCHORS")
end


function BigWigsMessages:Disable()
	self:UnregisterAllEvents()
end


function BigWigsMessages:CreateMsgFrame()
	self.msgframe = CreateFrame("MessageFrame")
	self.msgframe:SetWidth(512)
	self.msgframe:SetHeight(40)

	self.msgframe:SetPoint("TOP", self.anchorframe, "BOTTOM", 0, 0)
	self.msgframe:SetScale(self:GetOpt("scale") or 1)
	self.msgframe:SetInsertMode("TOP")
	self.msgframe:SetFrameStrata("HIGH")
	self.msgframe:SetToplevel(true)
	self.msgframe:SetFontObject(GameFontNormalHuge)
	self.msgframe:Show()

	return self.msgframe
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


function BigWigsMessages:BIGWIGS_MESSAGE(text, color)
	if not text then return end
	if self:GetOpt("White") then red,green,blue = BigWigs:GetColor("White")
	else red,green,blue = BigWigs:GetColor(color) end
	local f = self:GetOpt("NotRW") and self.msgframe or rwframe
	frame:AddMessage(text, red or 1, green or 1, blue or 1, 1, UIERRORS_HOLD_TIME)
end


------------------------------
--      Menu Functions      --
------------------------------

function BigWigsMessages:MenuSettings(level, value)
	dewdrop:AddLine("text", "Show anchor", "func", self.BIGWIGS_SHOW_ANCHORS, "arg1", self)
	dewdrop:AddLine("text", "Send messages to RaidWarning frame", "func", self.ToggleRW, "arg1", self, "arg2", true, "checked", not self:GetOpt("NotRW"))
	dewdrop:AddLine("text", "Colorize messages", "func", self.ToggleWhite, "arg1", self, "arg2", true, "checked", not self:GetOpt("White"))
--~~ 	dewdrop:AddLine("text", "Blah", "func", self.somthing, "arg1", self, "arg2", true, "checked", self:GetOpt("White"))
end


------------------------------
--      Slash Handlers      --
------------------------------

function BigWigsMessages:SetScale(msg, supressreport)
	local scale = tonumber(msg)
	if scale and scale >= 0.25 and scale <= 5 then
		self:SetOpt(scale, "scale")
		if self.msgframe then self.msgframe:SetScale(scale) end
		if not supressreport then self.cmd:result(string.format("Scale is set to %s", scale)) end
	end
end


function BigWigsMessages:ToggleRW(supressreport)
	local t = self:TogOpt("NotRW")
	if t and not self.msgframe then self:CreateMsgFrame() end
	if not supressreport then self.cmd:msg("Messages now sent to: ".. (t and "BigWigs frame" or "RaidWarning frame")) end
	frame = t and self.msgframe or RaidWarningFrame
end


function BigWigsMessages:ToggleWhite(supressreport)
	local t = self:TogOpt("White")
	if not supressreport then self.cmd:msg("Coloring all messages white is now: " .. (t and "On" or "Off")) end
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsMessages:RegisterForLoad()
