local sliderchange
local minscale, maxscale = 0.25, 2
local dewdrop = DewdropLib:GetInstance("1.0")

local cmdopt = GetLocale() == "koKR" and {
	option = "바",
	desc   = "Timex 바 옵션 조정.",
	input  = true,
	args   = {
		{
			option = "위치",
			desc   = "바 위치 조정 프레임 보이기.",
			method = "BIGWIGS_SHOW_ANCHORS",
		},
		{
			option = "크기",
			desc   = "바 크기 조절.",
			method = "SetScale",
			input  = true,
		},
		{
			option = "방향",
			desc   = "바 표시 순서를 위/아래로 조정.",
			method = "ToggleUp",
		},
	},
} or {
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

	loc = GetLocale() == "koKR" and {
		menutitle = "타이머 바",
		menuanchor = "앵커 보이기",
		menuup = "바 위로 자라기",
		menuscale = "크기",
	} or {
		menutitle = "Timex Bars",
		menuanchor = "Show anchor",
		menuup = "Grow bars upwards",
		menuscale = "Scale",
	},
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
--      Menu Functions      --
------------------------------

function BigWigsBars:MenuSettings(level, value)
	dewdrop:AddLine("text", self.loc.menuanchor, "func", self.BIGWIGS_SHOW_ANCHORS, "arg1", self)
	dewdrop:AddLine("text", self.loc.menuup, "func", self.ToggleUp, "arg1", self, "arg2", true, "checked", self:GetOpt("growup"))
	dewdrop:AddLine("text", self.loc.menuscale, "sliderFunc", sliderchange, "hasArrow", true, "hasSlider", true,
		"sliderTop", maxscale, "sliderBottom", minscale, "sliderValue", ((self:GetOpt("scale") or 1)-minscale)/(maxscale-minscale))
end


------------------------------
--      Slash Handlers      --
------------------------------

function BigWigsBars:SetScale(msg, supressreport)
	local scale = tonumber(msg)
	if scale and scale >= minscale and scale <= maxscale then
		self:SetOpt(scale, "scale")
		if not supressreport then self.cmd:result("Scale is set to "..scale) end
	end
end


sliderchange = function(value)
	BigWigsBars:SetScale(value*(maxscale-minscale) + minscale, true)
	return string.format("%.2f", value*(maxscale-minscale) + minscale)
end


function BigWigsBars:ToggleUp(supressreport)
	local t = self:TogOpt("growup")
	if not supressreport then self.cmd:result("Bars now grow ".. (t and "upwards." or "downwards.")) end
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsBars:RegisterForLoad()
