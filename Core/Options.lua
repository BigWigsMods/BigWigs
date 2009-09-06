-- Very empty atm

BigWigsOptions = {}

function BigWigsOptions:Open()
	for i, button in ipairs(InterfaceOptionsFrameAddOns.buttons) do
		if button.element and button.element.name == "Big Wigs" and button.element.collapsed then
			OptionsListButtonToggle_OnClick(button.toggle)
		end
	end
	InterfaceOptionsFrame_OpenToCategory("Big Wigs")
end

