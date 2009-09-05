-- Very empty atm

local BigWigs = BigWigs

local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs")

BigWigsOptions = LibStub("AceAddon-3.0"):NewAddon("BigWigsOptions", "AceEvent-3.0")
local options = BigWigsOptions

function options:Open()
	for i, button in ipairs(InterfaceOptionsFrameAddOns.buttons) do
		if button.element and button.element.name == "Big Wigs" and button.element.collapsed then
			OptionsListButtonToggle_OnClick(button.toggle)
		end
	end
	InterfaceOptionsFrame_OpenToCategory("Big Wigs")
end

