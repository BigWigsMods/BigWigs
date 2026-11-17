--[[
	Visit: https://github.com/BigWigsMods/BigWigs/wiki/Custom-Bar-Styles
	for in-depth information on how to register new bar styles from 3rd party addons.
]]

do
	local L = BigWigsAPI:GetLocale("BigWigs")
	BigWigsAPI:RegisterBarStyle("Default", {
		barDecorationEnabled = true,
		--barSpacing = 1,
		--barHeight = 18,
		--expBarHeight = 22,
		--barHeightOffset = 0,
		--expBarHeightOffset = 0,
		--fontSizeNormal = 10,
		--fontSizeEmphasized = 13,
		--fontOutline = "NONE",
		--borderName = "None",
		--borderColor = { 0, 0, 0, 1 },
		--borderOffset = 0,
		--borderSize = 1,
		--backgroundName = "None",
		--backgroundColor = { 0, 0, 0, 1 },
		--iconPosition = "LEFT",
		--detachedIcon = false,
		--iconOffset = 2,
		--iconWidthOffset = 0,
		--iconZoom = 0.14,
		--iconKeepAspectRatio = true,
		--alignText = "LEFT",
		--textOffsetX = 0,
		--textOffsetY = 0,
		--alignTime = "RIGHT",
		--timeOffsetX = 0,
		--timeOffsetY = 0,
		--spellIndicatorsPosition = "LEFT",
		--spellIndicatorsOffset = 2,
		--barColor = { 0.25, 0.33, 0.68, 1 },
		--barEmphasized = { 1, 0, 0, 1 },
		--barBackground = { 0.5, 0.5, 0.5, 0.3 },
		--ApplyStyle = function(bar) end,
		--BarStopped = function(bar) end,
		GetStyleName = function()
			return L.bigWigsBarStyleName_Default
		end,
	})
end

if BigWigsLoader.isModern then
	local function removeStyle(bar)
		if bar.blizzIconMask then
			bar.candyBarIconFrame:RemoveMaskTexture(bar.blizzIconMask)
			bar.blizzIconOverlay:Hide()
		end

		local statusbar = bar.candyBarBar
		if statusbar.blizzSpark then
			statusbar.blizzSpark:Hide()
		end

		local statusBarTexture = statusbar:GetStatusBarTexture()
		statusBarTexture:SetTexCoord(0, 1, 0, 1)
		statusBarTexture:ClearTextureSlice()
		statusBarTexture:ClearVertexOffsets()

		local bg = bar.candyBarBackground
		bg:SetTexCoord(0, 1, 0, 1)
		bg:ClearTextureSlice()
		bg:ClearVertexOffsets()
		bg:SetAllPoints()
	end

	local function styleBar(bar)
		local icon = bar.candyBarIconFrame
		if not bar.blizzIconMask then
			local mask = bar:CreateMaskTexture(nil, "ARTWORK")
			mask:SetPoint("TOPLEFT", icon, "TOPLEFT", 0, -1)
			mask:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 0, 0)
			mask:SetAtlas("UI-HUD-CoolDownManager-Mask")
			bar.blizzIconMask = mask

			local overlay = bar:CreateTexture(nil, "OVERLAY")
			overlay:SetPoint("TOPLEFT", icon, "TOPLEFT", -7, 6)
			overlay:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 7, -7)
			overlay:SetAtlas("UI-HUD-CoolDownManager-IconOverlay")
			bar.blizzIconOverlay = overlay
		end
		if bar:IsIconVisible() then
			icon:AddMaskTexture(bar.blizzIconMask)
			bar.blizzIconOverlay:Show()
		else
			bar.blizzIconOverlay:Hide()
		end

		local statusbar = bar.candyBarBar
		for i = 1, statusbar:GetNumPoints() do
			local point, relFrame, relPoint, x, y = statusbar:GetPoint(i)
			if point == "TOPLEFT" or point == "TOPRIGHT" then
				statusbar:SetPoint(point, relFrame, relPoint, x, (y or 0) - 4)
			elseif point == "BOTTOMLEFT" or point == "BOTTOMRIGHT" then
				statusbar:SetPoint(point, relFrame, relPoint, x, (y or 0) + 4)
			end
		end

		local statusBarTexture = statusbar:GetStatusBarTexture()
		statusBarTexture:SetAtlas("UI-HUD-CoolDownManager-Bar")

		local spark = statusbar.blizzSpark
		if not spark then
			spark = statusbar:CreateTexture(nil, "OVERLAY")
			spark:SetAtlas("UI-HUD-CoolDownManager-Bar-Pip", true)
			spark:SetBlendMode("ADD")
			spark:SetPoint("CENTER", statusBarTexture, "RIGHT", 0, 0)
			statusbar.blizzSpark = spark
		end
		spark:Show()

		local bg = bar.candyBarBackground
		bg:SetPoint("TOPLEFT", statusbar, "TOPLEFT", -2, 3)
		bg:SetPoint("BOTTOMRIGHT", statusbar, "BOTTOMRIGHT", 6, -7)
		bg:SetAtlas("UI-HUD-CoolDownManager-Bar-BG")
	end

	local L = BigWigsAPI:GetLocale("BigWigs")
	BigWigsAPI:RegisterBarStyle("Blizzard", {
		barDecorationEnabled = true,
		barSpacing = 2,
		barHeight = 34,
		expBarHeight = 34,
		fontSizeNormal = 14,
		fontSizeEmphasized = 14,
		fontOutline = "OUTLINE",
		detachedIcon = true,
		iconOffset = 4,
		iconZoom = 0,
		textOffsetX = 3,
		timeOffsetX = -3,
		spellIndicatorsOffset = 6,
		barColor = { 0.8, 0.1, 0.1, 1 },
		barEmphasized = { 0.8, 0.1, 0.1, 1 },
		barBackground = { 1, 1, 1, 1 },
		ApplyStyle = styleBar,
		BarStopped = removeStyle,
		GetStyleName = function() return L.bigWigsBarStyleName_Blizzard end,
	})
end

do
	-- Beautycase styling, based on Beautycase by Neal "Neave" @ WowI, texture made by Game92 "Aftermathh" @ WowI
	BigWigsAPI:RegisterBarStyle("Beautycase", {
		barDecorationEnabled = true,
		barSpacing = 9,
		borderName = "Beautycase",
		borderColor = { 1, 1, 1, 1 },
		borderOffset = 4,
		borderSize = 12,
		backgroundName = "Solid",
		backgroundColor = { 0.1, 0.1, 0.1, 1 },
		timeOffsetX = -3,
		spellIndicatorsOffset = 6,
		GetStyleName = function() return "Beautycase" end,
	})
end

do
	-- MonoUI
	BigWigsAPI:RegisterBarStyle("MonoUI", {
		barDecorationEnabled = true,
		barSpacing = 6,
		barHeight = 20,
		barHeightOffset = -10,
		expBarHeightOffset = -11,
		fontSizeEmphasized = 11,
		borderName = "Solid",
		borderOffset = 2,
		backgroundName = "Solid",
		backgroundColor = { 0.1, 0.1, 0.1, 1 },
		detachedIcon = true,
		iconOffset = 6,
		textOffsetY = 12,
		timeOffsetY = 12,
		spellIndicatorsOffset = 8,
		GetStyleName = function() return "MonoUI" end,
	})
end

do
	-- NaowhUI
	BigWigsAPI:RegisterBarStyle("NaowhUI", {
		barDecorationEnabled = true,
		barSpacing = 4,
		barHeight = 20,
		barHeightOffset = -12,
		expBarHeightOffset = -13,
		texture = "NaowhGradient",
		fontName = "Naowh",
		fontSizeNormal = 14,
		fontSizeEmphasized = 14,
		fontOutline = "OUTLINE",
		borderName = "Solid",
		borderOffset = 1,
		backgroundName = "Solid",
		backgroundColor = { 0.1, 0.1, 0.1, 1 },
		iconPosition = "RIGHT",
		detachedIcon = true,
		iconOffset = 4,
		textOffsetY = 4,
		timeOffsetY = 4,
		spellIndicatorsOffset = 6,
		spellIndicatorsPosition = "RIGHT",
		GetStyleName = function() return "NaowhUI" end,
	})
end

do
	-- Tukui
	local borderBackdrop = {
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1 }
	}

	local function removeStyle(bar)
		local bd = bar.candyBarBackdrop
		if bd.tukiborder then
			bd.tukiborder:Hide()
			bd.tukoborder:Hide()
		end
		local iconBd = bar.candyBarIconFrameBackdrop
		if iconBd.tukiborder then
			iconBd.tukiborder:Hide()
			iconBd.tukoborder:Hide()
		end
	end

	local function styleBar(bar)
		local bd = bar.candyBarBackdrop
		if not bd.tukiborder then
			local tukiborder = CreateFrame("Frame", nil, bd, "BackdropTemplate")
			tukiborder:SetPoint("TOPLEFT", bd, "TOPLEFT", 1, -1)
			tukiborder:SetPoint("BOTTOMRIGHT", bd, "BOTTOMRIGHT", -1, 1)
			tukiborder:SetBackdrop(borderBackdrop)
			tukiborder:SetBackdropBorderColor(0, 0, 0)
			bd.tukiborder = tukiborder

			local tukoborder = CreateFrame("Frame", nil, bd, "BackdropTemplate")
			tukoborder:SetPoint("TOPLEFT", bd, "TOPLEFT", -1, 1)
			tukoborder:SetPoint("BOTTOMRIGHT", bd, "BOTTOMRIGHT", 1, -1)
			tukoborder:SetBackdrop(borderBackdrop)
			tukoborder:SetBackdropBorderColor(0, 0, 0)
			bd.tukoborder = tukoborder
		else
			bd.tukiborder:Show()
			bd.tukoborder:Show()
		end

		local iconBd = bar.candyBarIconFrameBackdrop
		if iconBd:IsShown() then
			if not iconBd.tukiborder then
				local iconTukiborder = CreateFrame("Frame", nil, iconBd, "BackdropTemplate")
				iconTukiborder:SetPoint("TOPLEFT", iconBd, "TOPLEFT", 1, -1)
				iconTukiborder:SetPoint("BOTTOMRIGHT", iconBd, "BOTTOMRIGHT", -1, 1)
				iconTukiborder:SetBackdrop(borderBackdrop)
				iconTukiborder:SetBackdropBorderColor(0, 0, 0)
				iconBd.tukiborder = iconTukiborder

				local iconTukoborder = CreateFrame("Frame", nil, iconBd, "BackdropTemplate")
				iconTukoborder:SetPoint("TOPLEFT", iconBd, "TOPLEFT", -1, 1)
				iconTukoborder:SetPoint("BOTTOMRIGHT", iconBd, "BOTTOMRIGHT", 1, -1)
				iconTukoborder:SetBackdrop(borderBackdrop)
				iconTukoborder:SetBackdropBorderColor(0, 0, 0)
				iconBd.tukoborder = iconTukoborder
			else
				iconBd.tukiborder:Show()
				iconBd.tukoborder:Show()
			end
		end
	end

	BigWigsAPI:RegisterBarStyle("TukUI", {
		barDecorationEnabled = true,
		barSpacing = 7,
		borderName = "Solid",
		borderColor = { 0.5, 0.5, 0.5, 1 },
		borderOffset = 2,
		backgroundName = "Solid",
		backgroundColor = { 0.1, 0.1, 0.1, 1 },
		spellIndicatorsOffset = 4,
		ApplyStyle = styleBar,
		BarStopped = removeStyle,
		GetStyleName = function() return "TukUI" end,
	})
end

do
	-- ElvUI
	BigWigsAPI:RegisterBarStyle("ElvUI", {
		barDecorationEnabled = true,
		barSpacing = 4,
		barHeight = 20,
		borderName = "Solid",
		borderOffset = 1,
		backgroundName = "Solid",
		backgroundColor = { 0.06, 0.06, 0.06, 0.8 },
		detachedIcon = true,
		iconOffset = 1,
		spellIndicatorsOffset = 4,
		GetStyleName = function() return "ElvUI" end,
	})
end

