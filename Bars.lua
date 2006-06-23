
local cmdopt = {
	option = "bars",
	desc   = "Options for the Timex Bars.",
	input  = true,
	args   = {
		{
			option = "anchor",
			desc   = "Show the bar anchor frame.",
			method = "BIGWIGS_SHOW_ANCHORS",
		},
		{
			option = "scale",
			desc   = "Set the bar scale.",
			method = "SetScale",
			input  = true,
		},
		{
			option = "up",
			desc   = "Toggle bars grow upwards/downwards from anchor.",
			method = "ToggleUp",
		},
	},
}


BigWigsBars = AceAddon:new({
	name          = "BigWigsBars",
	cmd           = AceChatCmd:new({}, {}),
	cmdOptions    = cmdopt,
})


function BigWigsBars:Initialize()
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)

	self.frame = BigWigsAnchorFrame
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
	local u = self:GetOpt("growup")
	TimexBar:Get(id)
	TimexBar:SetText(id, text)
	TimexBar:SetTexture(id, texture)
	TimexBar:SetColor(id, red or 0, green or 0, blue or 0)
	TimexBar:SetPoint(id, u and "BOTTOM" or "TOP", "BigWigsAnchorFrame", u and "TOP" or "BOTTOM", 0, (u and (-1) or 1) * ((bar or 0) * (-15) + 5))
	TimexBar:SetScale(id, self:GetOpt("scale"))
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


------------------------------
--      Slash Handlers      --
------------------------------

function BigWigsBars:SetScale(msg)
	local scale = tonumber(msg)
	if scale and scale >= 0.25 and scale <= 5 then
		self:SetOpt(scale, "scale")
		self.cmd:result("Scale is set to "..scale)
	end
end


function BigWigsBars:ToggleUp()
	local t = self:TogOpt("growup")
	self.cmd:result("Bars now grow ".. (t and "upwards." or "downwards."))
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsBars:RegisterForLoad()
