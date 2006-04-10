

BigWigsAnchor = AceAddon:new({
	name          = "BigWigsAnchor",
	cmd           = AceChatCmd:new({}, {}),

	frame = getglobal("BigWigsAnchorFrame"),
	testbutton = getglobal("BigWigsAnchorFrameTest"),
	hidebutton = getglobal("BigWigsAnchorFrameHide"),
})


function BigWigsAnchor:Initialize()
	self.msgframe = CreateFrame("MessageFrame", nil, "UIParent")
	self.msgframe:SetWidth(512)
	self.msgframe:SetHeight(200)
	self.msgframe:SetPoint("TOP", self.frame, "BOTTOM")
	self.msgframe:SetJustifyV("TOP")
	self.msgframe:SetFrameStrata("HIGH")
	self.msgframe:SetFontObject(ErrorFont)
	self.msgframe:Show()
--	BigWigs.msgframe = self.msgframe
end


function BigWigsAnchor:Enable()
	self:RegisterEvent("BIGWIGS_MESSAGE")
end


function BigWigsAnchor:Disable()
end


function BigWigsAnchor:Hide()
  self.frame:Hide()
end


function BigWigsAnchor:Show()
  self.frame:Show()
end


function BigWigsAnchor:BIGWIGS_MESSAGE(text, color, noraidsay)
	if not text then return end
	local red, green, blue = BigWigs:GetColor(color)
	self.msgframe:AddMessage(text, red or 1, green or 1, blue or 1, 1, UIERRORS_HOLD_TIME)
end


function BigWigsAnchor:Test()
	self:TriggerEvent("BIGWIGS_BAR_START", "Test Bar", 15, 1, "Green", "Interface\\Icons\\Spell_Nature_ResistNature")
	self:TriggerEvent("BIGWIGS_MESSAGE", "Test", "Green")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", "OMG Bear!", 5, "Yellow")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", "*RAWR*", 10, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", "Test Bar", 5, "Yellow")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", "Test Bar", 7, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", "Test Bar", 10, "Red")

	self:TriggerEvent("BIGWIGS_BAR_START", "Test Bar 2", 6, 2, "Green", "Interface\\Icons\\Spell_Nature_ResistNature")
	self:TriggerEvent("BIGWIGS_BAR_START", "Test Bar 3", 7, 3, "Yellow", "Interface\\Icons\\Spell_Nature_ResistNature")
	self:TriggerEvent("BIGWIGS_BAR_START", "Test Bar 4", 7, 4, "Red", "Interface\\Icons\\Spell_Nature_ResistNature")
end


--[[--------------------------------------------------------------------------------
  Register the Addon
-----------------------------------------------------------------------------------]]

BigWigsAnchor:RegisterForLoad()
