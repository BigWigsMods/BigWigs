--[[
	Visit: https://github.com/BigWigsMods/BigWigs/wiki/Custom-Bar-Styles
	for in-depth information on how to register new bar styles from 3rd party addons.
]]

do
	local L = BigWigsAPI:GetLocale("BigWigs")
	BigWigsAPI:RegisterBarStyle("Default", {
		apiVersion = 1,
		version = 1,
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
		--iconZoom = 0,
		--iconKeepAspectRatio = true,
		--textOffsetX = 0,
		--textOffsetY = 0,
		--timeOffsetX = 0,
		--timeOffsetY = 0,
		--spellIndicatorsPosition = "LEFT",
		spellIndicatorsOffset = 2,
		--ApplyStyle = function(bar) end,
		--BarStopped = function(bar) end,
		GetStyleName = function()
			return L.bigWigsBarStyleName_Default
		end,
	})
end

if BigWigsLoader.isModern then
	--local atlasInfo = { -- from C_Texture.GetAtlasInfo
	--	["UI-HUD-CoolDownManager-Bar"] = {"Interface/AddOns/BigWigs/Media/Textures/UICooldownManager2x", 0.341796875, 0.826177875, 00.16015625, 0.23828125, 0, 8, 10, 8, 8},
	--	["UI-HUD-CoolDownManager-Bar-BG"] = {"Interface/AddOns/BigWigs/Media/Textures/UICooldownManager2x", 0.341796875, 0.857421875, 0.00390625, 0.15234375, 1, 242, 14, 20, 22},
	--	["UI-HUD-CoolDownManager-IconOverlay"] = {"Interface/AddOns/BigWigs/Media/Textures/UICooldownManager2x", 0.001953125, 0.337890625, 0.00390625, 0.67578125},
	--	["UI-HUD-CoolDownManager-Mask"] = {"Interface/AddOns/BigWigs/Media/Textures/UICooldownManagerMask", 0, 1, 0, 1},
	--}
	local function SetTexureFromAtlas(texture, atlas)
		texture:SetAtlas(atlas)
		-- XXX slice margins aren't saving so it's stretching the bg, statusbar is just fucked. not sure where things are getting messed up
		-- local file, left, right, top, bottom, sliceMode, marginLeft, marginTop, marginRight, marginBottom = unpack(atlasInfo[atlas])
		-- texture:SetTexture(file)
		-- texture:SetTexCoord(left, right, top, bottom)
		-- if sliceMode then
		-- 	texture:SetTextureSliceMode(sliceMode)
		-- 	texture:SetTextureSliceMargins(marginLeft, marginTop, marginRight, marginBottom)
		-- end
	end

	local iconFramePool = {}

	local function removeStyle(bar)
		local iconFrame = bar:Get("bigwigs:blizzardtimeline:icon")
		if iconFrame then
			bar:Set("bigwigs:blizzardtimeline:icon", nil)
			bar.candyBarIconFrame:RemoveMaskTexture(iconFrame.mask)
			iconFrame:SetParent(nil)
			iconFrame:ClearAllPoints()
			iconFrame:Hide()
			iconFramePool[#iconFramePool + 1] = iconFrame
		end

		local barHeight = bar:GetHeight()
		local statusbar = bar.candyBarBar

		local barTexture = bar:Get("bigwigs:restorebartexture")
		if barTexture then
			bar:SetTexture(barTexture)
		end
		statusbar:GetStatusBarTexture():SetTexCoord(0, 1, 0, 1)
		statusbar:GetStatusBarTexture():ClearTextureSlice()
		statusbar:GetStatusBarTexture():ClearVertexOffsets()

		local bg = bar.candyBarBackground
		bg:SetTexCoord(0, 1, 0, 1)
		bg:ClearTextureSlice()
		bg:ClearVertexOffsets()
		bg:SetAllPoints()
		local bgColor = bar:Get("bigwigs:restorebarcolor")
		if bgColor then
			bar:SetBackgroundColor(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
		end

		bar:SetHeight(barHeight) -- Note, calling SetHeight resets all the points for the statusbar and the icon, so we don't need to do it

		local duration = bar.candyBarDuration
		duration:ClearAllPoints()
		duration:SetPoint("TOPLEFT", statusbar, "TOPLEFT", 2, 0)
		duration:SetPoint("BOTTOMRIGHT", statusbar, "BOTTOMRIGHT", -2, 0)

		local label = bar.candyBarLabel
		label:ClearAllPoints()
		label:SetPoint("TOPLEFT", statusbar, "TOPLEFT", 2, 0)
		label:SetPoint("BOTTOMRIGHT", statusbar, "BOTTOMRIGHT", -2, 0)
	end

	local function styleBar(bar)
		local barHeight = bar:GetHeight()

		local iconFrame = tremove(iconFramePool)
		if not iconFrame then
			iconFrame = CreateFrame("Frame")

			local mask = iconFrame:CreateMaskTexture(nil, "ARTWORK")
			mask:SetPoint("TOPLEFT", 0, -1)
			mask:SetPoint("BOTTOMRIGHT", 0, 0)
			-- mask:SetTexture("Interface/AddOns/BigWigs/Media/UICooldownManagerMask")
			SetTexureFromAtlas(mask, "UI-HUD-CoolDownManager-Mask")
			iconFrame.mask = mask

			local overlay = iconFrame:CreateTexture(nil, "OVERLAY")
			overlay:SetPoint("TOPLEFT", iconFrame, "TOPLEFT", -7, 6)
			overlay:SetPoint("BOTTOMRIGHT", iconFrame, "BOTTOMRIGHT", 7, -7)
			SetTexureFromAtlas(overlay, "UI-HUD-CoolDownManager-IconOverlay")
		end
		bar:Set("bigwigs:blizzardtimeline:icon", iconFrame)
		iconFrame:SetParent(bar)
		iconFrame:ClearAllPoints()
		if bar:GetIconPosition() == "RIGHT" then
			iconFrame:SetPoint("TOPRIGHT", bar, "TOPRIGHT", -2, 0)
			iconFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -2, 0)
		else
			iconFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", 2, 0)
			iconFrame:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 2, 0)
		end
		iconFrame:SetWidth(barHeight)
		iconFrame:SetShown(bar:IsIconVisible())

		local icon = bar.candyBarIconFrame
		icon:ClearAllPoints()
		icon:SetAllPoints(iconFrame)
		icon:AddMaskTexture(iconFrame.mask)

		local statusbar = bar.candyBarBar
		statusbar:ClearAllPoints()
		if bar:IsIconVisible() then
			if bar:GetIconPosition() == "RIGHT" then
				statusbar:SetPoint("TOPRIGHT", iconFrame, "TOPLEFT", -4, -4)
				statusbar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 4, 4)
			else
				statusbar:SetPoint("TOPLEFT", iconFrame, "TOPRIGHT", 4, -4)
				statusbar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -4, 4)
			end
		else
			statusbar:SetPoint("TOPLEFT", bar, "TOPLEFT", 6, -4)
			statusbar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -4, 4)
		end
		-- statusbar:SetStatusBarTexture("UI-HUD-CoolDownManager-Bar")
		SetTexureFromAtlas(statusbar:GetStatusBarTexture(), "UI-HUD-CoolDownManager-Bar")

		local bg = bar.candyBarBackground
		bar:Set("bigwigs:restorebartexture", bg:GetTexture())
		bg:ClearAllPoints()
		bg:SetPoint("LEFT", statusbar, "LEFT", -2, -2)
		bg:SetPoint("RIGHT", statusbar, "RIGHT", 6, -2)
		bar:Set("bigwigs:restorebarcolor", {bg:GetVertexColor()})
		SetTexureFromAtlas(bg, "UI-HUD-CoolDownManager-Bar-BG")
		bar:SetBackgroundColor(1, 1, 1, 1)
		-- Since this is offset vertically, just scale the height instead of trying to adjust the points to match the texture
		bg:SetHeight(barHeight * 1.06) -- 36/34

		local duration = bar.candyBarDuration
		duration:ClearAllPoints()
		duration:SetPoint("RIGHT", statusbar, "RIGHT", -5, 0)

		local name = bar.candyBarLabel
		name:SetWordWrap(false) -- Force truncating since there is no height
		name:ClearAllPoints()
		name:SetPoint("LEFT", statusbar, "LEFT", 5, 0)
		name:SetPoint("RIGHT", duration, "LEFT", -10, 0)
	end

	local L = BigWigsAPI:GetLocale("BigWigs")
	BigWigsAPI:RegisterBarStyle("Blizzard", {
		apiVersion = 1,
		version = 1,
		barSpacing = 2,
		barHeight = 34,
		expBarHeight = 37,
		fontSizeNormal = 14,
		fontSizeEmphasized = 14,
		spellIndicatorsOffset = 2,
		fontOutline = "OUTLINE",
		ApplyStyle = styleBar,
		BarStopped = removeStyle,
		GetStyleName = function() return L.bigWigsBarStyleName_Blizzard end,
	})
end

do
	-- !Beautycase styling, based on !Beatycase by Neal "Neave" @ WowI, texture made by Game92 "Aftermathh" @ WowI

	local textureNormal = "Interface\\AddOns\\BigWigs\\Media\\Textures\\beautycase"

	local function createBorder(self)
		local border = UIParent:CreateTexture(nil, "OVERLAY")
		border:SetParent(self)
		border:SetTexture(textureNormal)
		border:SetWidth(12)
		border:SetHeight(12)
		border:SetVertexColor(1, 1, 1)
		return border
	end

	local freeBorderSets = {}

	local function freeStyle(bar)
		local borders = bar:Get("bigwigs:beautycase:borders")
		if borders then
			for i = 1, #borders do
				local border = borders[i]
				border:SetParent(UIParent)
				border:Hide()
			end
			freeBorderSets[#freeBorderSets + 1] = borders
		end
	end

	local function styleBar(bar)
		local borders
		if #freeBorderSets > 0 then
			borders = tremove(freeBorderSets)
			for i = 1, #borders do
				local border = borders[i]
				border:SetParent(bar.candyBarBar)
				border:ClearAllPoints()
				border:Show()
			end
		else
			borders = {}
			for i = 1, 8 do
				borders[i] = createBorder(bar.candyBarBar)
			end
		end
		for i = 1, #borders do
			local border = borders[i]
			if i == 1 then
				border:SetTexCoord(0, 1/3, 0, 1/3)
				border:SetPoint("TOPLEFT", bar, "TOPLEFT", -4, 4)
			elseif i == 2 then
				border:SetTexCoord(2/3, 1, 0, 1/3)
				border:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 4, 4)
			elseif i == 3 then
				border:SetTexCoord(0, 1/3, 2/3, 1)
				border:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", -4, -3)
			elseif i == 4 then
				border:SetTexCoord(2/3, 1, 2/3, 1)
				border:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 4, -3)
			elseif i == 5 then
				border:SetTexCoord(1/3, 2/3, 0, 1/3)
				border:SetPoint("TOPLEFT", borders[1], "TOPRIGHT")
				border:SetPoint("TOPRIGHT", borders[2], "TOPLEFT")
			elseif i == 6 then
				border:SetTexCoord(1/3, 2/3, 2/3, 1)
				border:SetPoint("BOTTOMLEFT", borders[3], "BOTTOMRIGHT")
				border:SetPoint("BOTTOMRIGHT", borders[4], "BOTTOMLEFT")
			elseif i == 7 then
				border:SetTexCoord(0, 1/3, 1/3, 2/3)
				border:SetPoint("TOPLEFT", borders[1], "BOTTOMLEFT")
				border:SetPoint("BOTTOMLEFT", borders[3], "TOPLEFT")
			elseif i == 8 then
				border:SetTexCoord(2/3, 1, 1/3, 2/3)
				border:SetPoint("TOPRIGHT", borders[2], "BOTTOMRIGHT")
				border:SetPoint("BOTTOMRIGHT", borders[4], "TOPRIGHT")
			end
		end

		bar:Set("bigwigs:beautycase:borders", borders)
	end

	BigWigsAPI:RegisterBarStyle("BeautyCase", {
		apiVersion = 1,
		version = 10,
		barSpacing = 8,
		backgroundName = "Solid",
		backgroundColor = { 0.1, 0.1, 0.1, 1 },
		spellIndicatorsOffset = 6,
		ApplyStyle = styleBar,
		BarStopped = freeStyle,
		GetStyleName = function() return "!Beautycase" end,
	})
end

do
	-- MonoUI
	BigWigsAPI:RegisterBarStyle("MonoUI", {
		apiVersion = 1,
		version = 10,
		barDecorationEnabled = true,
		barSpacing = 6,
		barHeight = 20,
		expBarHeight = 22,
		barHeightOffset = -10,
		expBarHeightOffset = -11,
		fontSizeNormal = 10,
		fontSizeEmphasized = 11,
		borderName = "Solid",
		borderColor = { 0, 0, 0, 1 },
		borderOffset = 2,
		borderSize = 1,
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
		apiVersion = 1,
		version = 10,
		barDecorationEnabled = true,
		barSpacing = 4,
		barHeight = 20,
		expBarHeight = 22,
		barHeightOffset = -12,
		expBarHeightOffset = -13,
		texture = "NaowhGradient",
		fontName = "Naowh",
		fontSizeNormal = 14,
		fontSizeEmphasized = 14,
		fontOutline = "OUTLINE",
		borderName = "Solid",
		borderColor = { 0, 0, 0, 1 },
		borderOffset = 1,
		borderSize = 1,
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
		apiVersion = 1,
		version = 10,
		barDecorationEnabled = true,
		barSpacing = 7,
		borderName = "Solid",
		borderColor = { 0.5, 0.5, 0.5, 1 },
		borderOffset = 2,
		borderSize = 1,
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
		apiVersion = 1,
		version = 10,
		barDecorationEnabled = true,
		barSpacing = 4,
		barHeight = 20,
		expBarHeight = 22,
		borderName = "Solid",
		borderColor = { 0, 0, 0, 1 },
		borderOffset = 1,
		borderSize = 1,
		backgroundName = "Solid",
		backgroundColor = { 0.06, 0.06, 0.06, 0.8 },
		detachedIcon = true,
		iconOffset = 1,
		spellIndicatorsOffset = 4,
		GetStyleName = function() return "ElvUI" end,
	})
end

