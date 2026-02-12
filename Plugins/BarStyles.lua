--[[
	Visit: https://github.com/BigWigsMods/BigWigs/wiki/Custom-Bar-Styles
	for in-depth information on how to register new bar styles from 3rd party addons.
]]

do
	local L = BigWigsAPI:GetLocale("BigWigs")
	BigWigsAPI:RegisterBarStyle("Default", {
		apiVersion = 1,
		version = 1,
		--barSpacing = 1,
		--barHeight = 16,
		--fontSizeNormal = 10,
		--fontSizeEmphasized = 13,
		--fontOutline = "NONE",
		spellIndicatorsOffset = 2,
		--GetSpacing = function(bar) end,
		--ApplyStyle = function(bar) end,
		--BarStopped = function(bar) end,
		GetStyleName = function()
			return L.bigWigsBarStyleName_Default
		end,
	})
end

if BigWigsLoader.isRetail then
	local atlasInfo = { -- from C_Texture.GetAtlasInfo
		["UI-HUD-CoolDownManager-Bar"] = {"Interface/AddOns/BigWigs/Media/Textures/UICooldownManager2x", 0.341796875, 0.826177875, 00.16015625, 0.23828125, 0, 8, 10, 8, 8},
		["UI-HUD-CoolDownManager-Bar-BG"] = {"Interface/AddOns/BigWigs/Media/Textures/UICooldownManager2x", 0.341796875, 0.857421875, 0.00390625, 0.15234375, 1, 242, 14, 20, 22},
		["UI-HUD-CoolDownManager-IconOverlay"] = {"Interface/AddOns/BigWigs/Media/Textures/UICooldownManager2x", 0.001953125, 0.337890625, 0.00390625, 0.67578125},
		["UI-HUD-CoolDownManager-Mask"] = {"Interface/AddOns/BigWigs/Media/Textures/UICooldownManagerMask", 0, 1, 0, 1},
	}
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
		bg:SetAllPoints(bar)
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

		-- Replicating the layering in the template was annoying, so just create our own icon frame
		local iconTexture = bar:GetIcon()
		bar.candyBarIconFrame:Hide()

		local iconFrame = tremove(iconFramePool)
		if not iconFrame then
			iconFrame = CreateFrame("Frame")

			local mask = iconFrame:CreateMaskTexture(nil, "ARTWORK")
			mask:SetPoint("TOPLEFT", 0, -1)
			mask:SetPoint("BOTTOMRIGHT", 0, 0)
			-- mask:SetTexture("Interface/AddOns/BigWigs/Media/UICooldownManagerMask")
			SetTexureFromAtlas(mask, "UI-HUD-CoolDownManager-Mask")

			local icon = iconFrame:CreateTexture(nil, "ARTWORK")
			icon:SetPoint("TOPLEFT", 0, 0)
			icon:SetPoint("BOTTOMRIGHT", 0, 0)
			icon:AddMaskTexture(mask)
			iconFrame.icon = icon

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
		iconFrame.icon:SetTexture(iconTexture)
		iconFrame:SetShown(iconTexture and true)

		local statusbar = bar.candyBarBar
		statusbar:ClearAllPoints()
		if iconTexture then
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

	local backdropbc = {
		bgFile = "Interface\\Buttons\\WHITE8x8",
		insets = {top = 1, left = 1, bottom = 1, right = 1},
	}

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
		bar.candyBarBackdrop:Hide()
		local borders = bar:Get("bigwigs:beautycase:borders")
		if borders then
			for i, border in next, borders do
				border:SetParent(UIParent)
				border:Hide()
			end
			freeBorderSets[#freeBorderSets + 1] = borders
		end
	end

	local function styleBar(bar)
		local bd = bar.candyBarBackdrop
		bd:ClearAllPoints()
		bd:SetBackdrop(backdropbc)
		bd:SetBackdropColor(.1, .1, .1, 1)
		bd:SetPoint("TOPLEFT", bar, "TOPLEFT", -1, 1)
		bd:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 1, -1)
		bd:Show()

		local borders
		if #freeBorderSets > 0 then
			borders = tremove(freeBorderSets)
			for i, border in next, borders do
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
		spellIndicatorsOffset = 6,
		ApplyStyle = styleBar,
		BarStopped = freeStyle,
		GetStyleName = function() return "!Beautycase" end,
	})
end

do
	-- MonoUI
	local backdropBorder = {
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
		tile = false, tileSize = 0, edgeSize = 1,
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	}

	local function removeStyle(bar)
		bar.candyBarBackdrop:Hide()
		bar.candyBarIconFrameBackdrop:Hide()
		local height = bar:Get("bigwigs:restoreheight")
		if height then
			bar:SetHeight(height) -- Note, calling SetHeight resets all the points for the statusbar and the icon, so we don't need to do it
		end

		local statusbar = bar.candyBarBar
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

		bar:Set("bigwigs:restoreheight", barHeight)
		bar:SetHeight(barHeight / 2)

		bar.candyBarLabel:ClearAllPoints()
		bar.candyBarDuration:ClearAllPoints()
		local statusbar = bar.candyBarBar
		statusbar:ClearAllPoints()

		local bd = bar.candyBarBackdrop
		if bd.SetToDefaults then
			bd:SetToDefaults()
			bd:SetFrameLevel(0)
		end
		bd:ClearAllPoints()
		bd:SetBackdrop(backdropBorder)
		bd:SetBackdropColor(.1,.1,.1,1)
		bd:SetBackdropBorderColor(0,0,0,1)
		bd:SetPoint("TOPLEFT", statusbar, "TOPLEFT", -2, 2)
		bd:SetPoint("BOTTOMRIGHT", statusbar, "BOTTOMRIGHT", 2, -2)
		bd:Show()

		local iconTexture = bar:GetIcon()
		if iconTexture then
			local reApplyIcon = false
			local iconFrame = bar.candyBarIconFrame
			local iconBd = bar.candyBarIconFrameBackdrop
			if iconFrame.IsAnchoringSecret and iconFrame:IsAnchoringSecret() then
				iconFrame:SetToDefaults()
				iconBd:SetToDefaults()
				iconBd:SetFrameLevel(0)
				reApplyIcon = true
			end

			iconFrame:ClearAllPoints()
			iconBd:ClearAllPoints()

			if bar:GetIconPosition() == "RIGHT" then
				iconFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -2, 0)

				statusbar:SetPoint("TOPRIGHT", iconFrame, "LEFT", -6, 0)
				statusbar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 2, 0)
			else
				iconFrame:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 2, 0)

				statusbar:SetPoint("TOPLEFT", iconFrame, "RIGHT", 6, 0)
				statusbar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -2, 0)
			end
			iconFrame:SetSize(barHeight, barHeight)

			iconBd:SetBackdrop(backdropBorder)
			iconBd:SetBackdropColor(.1,.1,.1,1)
			iconBd:SetBackdropBorderColor(0,0,0,1)
			iconBd:SetPoint("TOPLEFT", iconFrame, "TOPLEFT", -2, 2)
			iconBd:SetPoint("BOTTOMRIGHT", iconFrame, "BOTTOMRIGHT", 2, -2)
			iconBd:Show()

			if reApplyIcon then
				iconFrame:SetTexture(iconTexture)
				iconFrame:SetTexCoord(0.07, 0.93, 0.07, 0.93)
			end
		end

		bar.candyBarLabel:SetPoint("BOTTOMLEFT", statusbar, "TOPLEFT", 2, 2)
		bar.candyBarDuration:SetPoint("BOTTOMRIGHT", statusbar, "TOPRIGHT", -2, 2)
	end

	BigWigsAPI:RegisterBarStyle("MonoUI", {
		apiVersion = 1,
		version = 10,
		barHeight = 20,
		fontSizeNormal = 10,
		fontSizeEmphasized = 11,
		spellIndicatorsOffset = 2,
		GetSpacing = function(bar) return bar:GetHeight()+6 end,
		ApplyStyle = styleBar,
		BarStopped = removeStyle,
		GetStyleName = function() return "MonoUI" end,
	})
end

do
	-- Tukui
	local C = Tukui and Tukui[2]
	local backdrop = {
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		tile = false, tileSize = 0, edgeSize = 1,
	}
	local borderBackdrop = {
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1 }
	}

	local function removeStyle(bar)
		local bd = bar.candyBarBackdrop
		bd:Hide()
		if bd.tukiborder then
			bd.tukiborder:Hide()
			bd.tukoborder:Hide()
		end
	end

	local function styleBar(bar)
		local bd = bar.candyBarBackdrop
		bd:ClearAllPoints()
		bd:SetBackdrop(backdrop)
		if C then
			bd:SetBackdropColor(unpack(C.Medias.BackdropColor))
			bd:SetBackdropBorderColor(unpack(C.Medias.BorderColor))
			bd:SetOutside(bar)
		else
			bd:SetBackdropColor(0.1,0.1,0.1)
			bd:SetBackdropBorderColor(0.5,0.5,0.5)
			bd:ClearAllPoints()
			bd:SetPoint("TOPLEFT", bar, "TOPLEFT", -2, 2)
			bd:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 2, -2)
		end

		if not bd.tukiborder then
			local border = CreateFrame("Frame", nil, bd, "BackdropTemplate")
			if C then
				border:SetInside(bd, 1, 1)
			else
				border:SetPoint("TOPLEFT", bd, "TOPLEFT", 1, -1)
				border:SetPoint("BOTTOMRIGHT", bd, "BOTTOMRIGHT", -1, 1)
			end
			border:SetBackdrop(borderBackdrop)
			border:SetBackdropBorderColor(0, 0, 0)
			bd.tukiborder = border
		else
			bd.tukiborder:Show()
		end

		if not bd.tukoborder then
			local border = CreateFrame("Frame", nil, bd, "BackdropTemplate")
			if C then
				border:SetOutside(bd, 1, 1)
			else
				border:SetPoint("TOPLEFT", bd, "TOPLEFT", -1, 1)
				border:SetPoint("BOTTOMRIGHT", bd, "BOTTOMRIGHT", 1, -1)
			end
			border:SetBackdrop(borderBackdrop)
			border:SetBackdropBorderColor(0, 0, 0)
			bd.tukoborder = border
		else
			bd.tukoborder:Show()
		end

		bd:Show()
	end

	BigWigsAPI:RegisterBarStyle("TukUI", {
		apiVersion = 1,
		version = 10,
		barSpacing = 7,
		spellIndicatorsOffset = 4,
		ApplyStyle = styleBar,
		BarStopped = removeStyle,
		GetStyleName = function() return "TukUI" end,
	})
end

do
	-- ElvUI
	local E = ElvUI and ElvUI[1]
	local backdropBorder = {
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		tile = false, tileSize = 0, edgeSize = 1,
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	}

	local function removeStyle(bar)
		local bd = bar.candyBarBackdrop
		bd:Hide()
		if bd.iborder then
			bd.iborder:Hide()
			bd.oborder:Hide()
		end

		local restore = bar:Get("bigwigs:restoreicon")
		if restore then
			local iconBd = bar.candyBarIconFrameBackdrop
			iconBd:Hide()
			if iconBd.iborder then
				iconBd.iborder:Hide()
				iconBd.oborder:Hide()
			end
		end
	end

	local function styleBar(bar)
		local bd = bar.candyBarBackdrop
		bd:ClearAllPoints()
		if E then
			bd:SetTemplate("Transparent")
			bd:SetOutside(bar)
			if not E.PixelMode and bd.iborder then
				bd.iborder:Show()
				bd.oborder:Show()
			end
		else
			bd:SetBackdrop(backdropBorder)
			bd:SetBackdropColor(0.06, 0.06, 0.06, 0.8)
			bd:SetBackdropBorderColor(0, 0, 0)
			bd:SetPoint("TOPLEFT", bar, "TOPLEFT", -1, 1)
			bd:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 1, -1)
		end
		bd:Show()

		local iconTexture = bar:GetIcon()
		if iconTexture then
			local reApplyIcon = false
			local statusbar = bar.candyBarBar
			local iconFrame = bar.candyBarIconFrame
			local iconBd = bar.candyBarIconFrameBackdrop
			if iconFrame.IsAnchoringSecret and iconFrame:IsAnchoringSecret() then
				iconFrame:SetToDefaults()
				iconBd:SetToDefaults()
				iconBd:SetFrameLevel(0)
				reApplyIcon = true
			end
			statusbar:ClearAllPoints()
			iconFrame:ClearAllPoints()
			iconBd:ClearAllPoints()

			if bar:GetIconPosition() == "RIGHT" then
				--iconFrame:SetPoint("BOTTOMLEFT", bar, "BOTTOMRIGHT", E and (E.PixelMode and 1 or 5) or 1, 0)
				iconFrame:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
				iconFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)

				statusbar:SetPoint("TOPRIGHT", iconFrame, "TOPLEFT", -1, 0)
				statusbar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
			else
				--iconFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", E and (E.PixelMode and -1 or -5) or -1, 0)
				iconFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
				iconFrame:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)

				statusbar:SetPoint("TOPLEFT", iconFrame, "TOPRIGHT", 1, 0)
				statusbar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
			end
			iconFrame:SetSize(bar:GetHeight(), bar:GetHeight())

			bar:Set("bigwigs:restoreicon", true)
			if E then
				iconBd:SetTemplate("Transparent")
				iconBd:SetOutside(iconFrame)
				if not E.PixelMode and iconBd.iborder then
					iconBd.iborder:Show()
					iconBd.oborder:Show()
				end
			else
				iconBd:SetBackdrop(backdropBorder)
				iconBd:SetBackdropColor(0.06, 0.06, 0.06, 0.8)
				iconBd:SetBackdropBorderColor(0, 0, 0)
				iconBd:SetPoint("TOPLEFT", iconFrame, "TOPLEFT", -1, 1)
				iconBd:SetPoint("BOTTOMRIGHT", iconFrame, "BOTTOMRIGHT", 1, -1)
			end
			iconBd:Show()

			if reApplyIcon then
				iconFrame:SetTexture(iconTexture)
				iconFrame:SetTexCoord(0.07, 0.93, 0.07, 0.93)
			end
		end
	end

	BigWigsAPI:RegisterBarStyle("ElvUI", {
		apiVersion = 1,
		version = 10,
		barSpacing = E and (E.PixelMode and 4 or 8) or 4,
		barHeight = 20,
		spellIndicatorsOffset = 2,
		ApplyStyle = styleBar,
		BarStopped = removeStyle,
		GetStyleName = function() return "ElvUI" end,
	})
end

