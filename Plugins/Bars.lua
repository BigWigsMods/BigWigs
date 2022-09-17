
--[[
Visit: https://github.com/BigWigsMods/BigWigs/wiki/Custom-Bar-Styles
for in-depth information on how to register new bar styles from 3rd party addons.
]]

--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Bars")
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

local colorize = nil
do
	local r, g, b
	colorize = setmetatable({}, { __index =
		function(self, key)
			if not r then r, g, b = GameFontNormal:GetTextColor() end
			self[key] = "|cff" .. ("%02x%02x%02x"):format(r * 255, g * 255, b * 255) .. key .. "|r"
			return self[key]
		end
	})
end

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
plugin.displayName = L.bars

local startBreak -- Break timer function

local colors = nil
local candy = LibStub("LibCandyBar-3.0")
local media = LibStub("LibSharedMedia-3.0")
local FONT = media.MediaType and media.MediaType.FONT or "font"
local STATUSBAR = media.MediaType and media.MediaType.STATUSBAR or "statusbar"
local next = next
local tremove = tremove
local db = nil
local normalAnchor, emphasizeAnchor = nil, nil
local nameplateBars = {}
local empUpdate = nil -- emphasize updater frame
local rearrangeBars
local rearrangeNameplateBars
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit

local clickHandlers = {}

local findUnitByGUID = nil
do
	local unitTable = {
		"nameplate1", "nameplate2", "nameplate3", "nameplate4", "nameplate5", "nameplate6", "nameplate7", "nameplate8", "nameplate9", "nameplate10",
		"nameplate11", "nameplate12", "nameplate13", "nameplate14", "nameplate15", "nameplate16", "nameplate17", "nameplate18", "nameplate19", "nameplate20",
		"nameplate21", "nameplate22", "nameplate23", "nameplate24", "nameplate25", "nameplate26", "nameplate27", "nameplate28", "nameplate29", "nameplate30",
		"nameplate31", "nameplate32", "nameplate33", "nameplate34", "nameplate35", "nameplate36", "nameplate37", "nameplate38", "nameplate39", "nameplate40",
	}
	local unitTableCount = #unitTable
	findUnitByGUID = function(id)
		for i = 1, unitTableCount do
			local unit = unitTable[i]
			local guid = plugin:UnitGUID(unit)
			if guid == id then
				return unit
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Bar styles setup
--

local currentBarStyler = nil
local SetBarStyle

BigWigsAPI:RegisterBarStyle("Default", {
	apiVersion = 1,
	version = 1,
	--barSpacing = 1,
	--barHeight = 16,
	--fontSizeNormal = 10,
	--fontSizeEmphasized = 13,
	--fontOutline = "NONE",
	--GetSpacing = function(bar) end,
	--ApplyStyle = function(bar) end,
	--BarStopped = function(bar) end,
	GetStyleName = function()
		return L.bigWigsBarStyleName_Default
	end,
})

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

		bd:SetBackdrop(backdropbc)
		bd:SetBackdropColor(.1, .1, .1, 1)

		bd:ClearAllPoints()
		bd:SetPoint("TOPLEFT", bar, "TOPLEFT", -1, 1)
		bd:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 1, -1)
		bd:Show()

		local borders = nil
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
		local height = bar:Get("bigwigs:restoreheight")
		if height then
			bar:SetHeight(height)
		end

		local tex = bar:Get("bigwigs:restoreicon")
		if tex then
			bar:SetIcon(tex)
			bar:Set("bigwigs:restoreicon", nil)

			bar.candyBarIconFrameBackdrop:Hide()
		end

		bar.candyBarDuration:ClearAllPoints()
		bar.candyBarDuration:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2, 0)
		bar.candyBarDuration:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2, 0)

		bar.candyBarLabel:ClearAllPoints()
		bar.candyBarLabel:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2, 0)
		bar.candyBarLabel:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2, 0)
	end

	local function styleBar(bar)
		local height = bar:GetHeight()
		bar:Set("bigwigs:restoreheight", height)
		bar:SetHeight(height/2)

		local bd = bar.candyBarBackdrop

		bd:SetBackdrop(backdropBorder)
		bd:SetBackdropColor(.1,.1,.1,1)
		bd:SetBackdropBorderColor(0,0,0,1)

		bd:ClearAllPoints()
		bd:SetPoint("TOPLEFT", bar, "TOPLEFT", -2, 2)
		bd:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 2, -2)
		bd:Show()

		local tex = bar:GetIcon()
		if tex then
			local icon = bar.candyBarIconFrame
			bar:SetIcon(nil)
			icon:SetTexture(tex)
			icon:Show()
			if bar.iconPosition == "RIGHT" then
				icon:SetPoint("BOTTOMLEFT", bar, "BOTTOMRIGHT", 5, 0)
			else
				icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -5, 0)
			end
			icon:SetSize(height, height)
			bar:Set("bigwigs:restoreicon", tex)

			local iconBd = bar.candyBarIconFrameBackdrop
			iconBd:SetBackdrop(backdropBorder)
			iconBd:SetBackdropColor(.1,.1,.1,1)
			iconBd:SetBackdropBorderColor(0,0,0,1)

			iconBd:ClearAllPoints()
			iconBd:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, 2)
			iconBd:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)
			iconBd:Show()
		end

		bar.candyBarLabel:ClearAllPoints()
		bar.candyBarLabel:SetPoint("BOTTOMLEFT", bar.candyBarBar, "TOPLEFT", 2, 2)

		bar.candyBarDuration:ClearAllPoints()
		bar.candyBarDuration:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "TOPRIGHT", -2, 2)
	end

	BigWigsAPI:RegisterBarStyle("MonoUI", {
		apiVersion = 1,
		version = 10,
		barHeight = 20,
		fontSizeNormal = 10,
		fontSizeEmphasized = 11,
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
			border:SetFrameLevel(3)
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
			border:SetFrameLevel(3)
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

		local tex = bar:Get("bigwigs:restoreicon")
		if tex then
			bar:SetIcon(tex)
			bar:Set("bigwigs:restoreicon", nil)

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

			bd:ClearAllPoints()
			bd:SetPoint("TOPLEFT", bar, "TOPLEFT", -1, 1)
			bd:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 1, -1)
		end

		local tex = bar:GetIcon()
		if tex then
			local icon = bar.candyBarIconFrame
			bar:SetIcon(nil)
			icon:SetTexture(tex)
			icon:Show()
			if bar.iconPosition == "RIGHT" then
				icon:SetPoint("BOTTOMLEFT", bar, "BOTTOMRIGHT", E and (E.PixelMode and 1 or 5) or 1, 0)
			else
				icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", E and (E.PixelMode and -1 or -5) or -1, 0)
			end
			icon:SetSize(bar:GetHeight(), bar:GetHeight())
			bar:Set("bigwigs:restoreicon", tex)

			local iconBd = bar.candyBarIconFrameBackdrop

			if E then
				iconBd:SetTemplate("Transparent")
				iconBd:SetOutside(bar.candyBarIconFrame)
				if not E.PixelMode and iconBd.iborder then
					iconBd.iborder:Show()
					iconBd.oborder:Show()
				end
			else
				iconBd:SetBackdrop(backdropBorder)
				iconBd:SetBackdropColor(0.06, 0.06, 0.06, 0.8)
				iconBd:SetBackdropBorderColor(0, 0, 0)

				iconBd:ClearAllPoints()
				iconBd:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
				iconBd:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
			end
			iconBd:Show()
		end

		bd:Show()
	end

	BigWigsAPI:RegisterBarStyle("ElvUI", {
		apiVersion = 1,
		version = 10,
		barSpacing = E and (E.PixelMode and 4 or 8) or 4,
		barHeight = 20,
		ApplyStyle = styleBar,
		BarStopped = removeStyle,
		GetStyleName = function() return "ElvUI" end,
	})
end

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	fontName = plugin:GetDefaultFont(),
	fontSize = 10,
	fontSizeEmph = 13,
	fontSizeNameplate = 7,
	texture = "BantoBar",
	font = nil,
	monochrome = false,
	outline = "NONE",
	growup = false,
	text = true,
	time = true,
	alignText = "LEFT",
	alignTime = "RIGHT",
	icon = true,
	iconPosition = "LEFT",
	fill = false,
	barStyle = "Default",
	emphasize = true,
	emphasizeMove = true,
	emphasizeGrowup = false,
	emphasizeRestart = true,
	emphasizeTime = 11,
	emphasizeMultiplier = 1.1,
	BigWigsAnchor_width = 220,
	BigWigsAnchor_height = 16,
	BigWigsEmphasizeAnchor_width = 320,
	BigWigsEmphasizeAnchor_height = 22,
	nameplateWidth = 100,
	nameplateAutoWidth = true,
	nameplateHeight = 12,
	nameplateAlpha = 0.7,
	nameplateOffsetY = 30,
	nameplateGrowUp = true,
	spacing = 1,
	visibleBarLimit = 100,
	visibleBarLimitEmph = 100,
	interceptMouse = false,
	onlyInterceptOnKeypress = true,
	interceptKey = "CTRL",
	LeftButton = "report",
	MiddleButton = "remove",
	RightButton = "countdown",
}

do
	local function shouldDisable() return not plugin.db.profile.interceptMouse end
	local clickOptions = {
		countdown = {
			type = "toggle",
			name = colorize[L.countdown],
			desc = L.temporaryCountdownDesc,
			descStyle = "inline",
			order = 1,
			width = "full",
			disabled = shouldDisable,
		},
		report = {
			type = "toggle",
			name = colorize[L.report],
			desc = L.reportDesc,
			descStyle = "inline",
			order = 2,
			width = "full",
			disabled = shouldDisable,
		},
		remove = {
			type = "toggle",
			name = colorize[L.remove],
			desc = L.removeBarDesc,
			descStyle = "inline",
			order = 3,
			width = "full",
			disabled = shouldDisable,
		},
		removeOther = {
			type = "toggle",
			name = colorize[L.removeOther],
			desc = L.removeOtherBarDesc,
			descStyle = "inline",
			order = 4,
			width = "full",
			disabled = shouldDisable,
		},
	}

	local function updateFont(info, value)
		if info then
			local key = info[#info]
			if key == "fontName" then
				local list = media:List(FONT)
				db[key] = list[value]
			else
				db[key] = value
			end
		end

		local flags = nil
		if db.monochrome and db.outline ~= "NONE" then
			flags = "MONOCHROME," .. db.outline
		elseif db.monochrome then
			flags = "MONOCHROME"
		elseif db.outline ~= "NONE" then
			flags = db.outline
		end
		local f = media:Fetch(FONT, db.fontName)
		for bar in next, normalAnchor.bars do
			bar.candyBarLabel:SetFont(f, db.fontSize, flags)
			bar.candyBarDuration:SetFont(f, db.fontSize, flags)
		end
		for bar in next, emphasizeAnchor.bars do
			bar.candyBarLabel:SetFont(f, db.fontSizeEmph, flags)
			bar.candyBarDuration:SetFont(f, db.fontSizeEmph, flags)
		end
	end

	local function sortBars(info, value)
		db[info[#info]] = value
		rearrangeBars(normalAnchor)
		rearrangeBars(emphasizeAnchor)
	end

	plugin.pluginOptions = {
		type = "group",
		name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Bars:20|t ".. L.bars,
		childGroups = "tab",
		get = function(info)
			return db[info[#info]]
		end,
		set = function(info, value)
			db[info[#info]] = value
			if BigWigsAnchor then
				BigWigsAnchor:RefixPosition()
				BigWigsEmphasizeAnchor:RefixPosition()
			end
		end,
		order = 1,
		args = {
			anchorsButton = {
				type = "execute",
				name = function()
					local BL = BigWigsAPI:GetLocale("BigWigs")
					if BigWigsOptions:InConfigureMode() then
						return BL.toggleAnchorsBtnHide
					else
						return BL.toggleAnchorsBtnShow
					end
				end,
				desc = function()
					local BL = BigWigsAPI:GetLocale("BigWigs")
					if BigWigsOptions:InConfigureMode() then
						return BL.toggleAnchorsBtnHide_desc
					else
						return BL.toggleAnchorsBtnShow_desc
					end
				end,
				func = function()
					if not BigWigs:IsEnabled() then BigWigs:Enable() end
					if BigWigsOptions:InConfigureMode() then
						plugin:SendMessage("BigWigs_StopConfigureMode")
					else
						plugin:SendMessage("BigWigs_StartConfigureMode")
					end
				end,
				width = 1.5,
				order = 0.2,
			},
			testButton = {
				type = "execute",
				name = BigWigsAPI:GetLocale("BigWigs").testBarsBtn,
				desc = BigWigsAPI:GetLocale("BigWigs").testBarsBtn_desc,
				func = function()
					BigWigs:Test()
				end,
				width = 1.5,
				order = 0.4,
			},
			custom = {
				type = "group",
				name = L.general,
				order = 1,
				args = {
					fontName = {
						type = "select",
						name = L.font,
						order = 1,
						values = media:List(FONT),
						itemControl = "DDI-Font",
						get = function(info)
							for i, v in next, media:List(FONT) do
								if v == db.fontName then return i end
							end
						end,
						set = updateFont,
					},
					outline = {
						type = "select",
						name = L.outline,
						order = 2,
						values = {
							NONE = L.none,
							OUTLINE = L.thin,
							THICKOUTLINE = L.thick,
						},
						set = updateFont,
					},
					monochrome = {
						type = "toggle",
						name = L.monochrome,
						desc = L.monochromeDesc,
						order = 3,
						set = updateFont,
					},
					header1 = {
						type = "header",
						name = "",
						order = 4,
					},
					barStyle = {
						type = "select",
						name = L.style,
						order = 5,
						values = function() return BigWigsAPI:GetBarStyleList() end,
						set = function(info, value)
							db[info[#info]] = value
							SetBarStyle(value)
							local style = BigWigsAPI:GetBarStyle(value)
							if style then
								if type(style.barSpacing) == "number" and style.barSpacing > 0 and style.barSpacing < 101 then
									db.spacing = style.barSpacing
								else
									db.spacing = plugin.defaultDB.spacing
								end
								rearrangeBars(normalAnchor)
								rearrangeBars(emphasizeAnchor)

								if type(style.barHeight) == "number" and style.barHeight > 0 and style.barHeight < 201 then
									db.BigWigsAnchor_height = style.barHeight
									db.BigWigsEmphasizeAnchor_height = style.barHeight * 1.1
								else
									db.BigWigsAnchor_height = plugin.defaultDB.BigWigsAnchor_height
									db.BigWigsEmphasizeAnchor_height = plugin.defaultDB.BigWigsEmphasizeAnchor_height
								end
								if type(style.fontSizeNormal) == "number" and style.fontSizeNormal > 0 and style.fontSizeNormal < 201 then
									db.fontSize = style.fontSizeNormal
								else
									db.fontSize = plugin.defaultDB.fontSize
								end
								if type(style.fontSizeEmphasized) == "number" and style.fontSizeEmphasized > 0 and style.fontSizeEmphasized < 201 then
									db.fontSizeEmph = style.fontSizeEmphasized
								else
									db.fontSizeEmph = plugin.defaultDB.fontSizeEmph
								end
								if type(style.fontOutline) == "string" and (style.fontOutline == "NONE" or style.fontOutline == "OUTLINE" or style.fontOutline == "THICKOUTLINE") then
									db.outline = style.fontOutline
								else
									db.outline = plugin.defaultDB.outline
								end
								updateFont()

								for bar in next, normalAnchor.bars do
									currentBarStyler.BarStopped(bar)
									bar:SetHeight(db.BigWigsAnchor_height)
									currentBarStyler.ApplyStyle(bar)
								end
								for bar in next, emphasizeAnchor.bars do
									currentBarStyler.BarStopped(bar)
									bar:SetHeight(db.BigWigsEmphasizeAnchor_height)
									currentBarStyler.ApplyStyle(bar)
								end

								BigWigsAnchor:RefixPosition()
								BigWigsEmphasizeAnchor:RefixPosition()
								plugin:UpdateGUI()
							end
						end,
					},
					spacing = {
						type = "range",
						name = L.spacing,
						desc = L.spacingDesc,
						order = 6,
						softMax = 30,
						min = 0,
						max = 100,
						step = 1,
						width = 2,
						set = sortBars,
						disabled = function()
							-- Just throw in a random frame (normalAnchor) instead of a bar to see if it returns a value since we noop() styles that don't have a .GetSpacing entry
							return currentBarStyler.GetSpacing(normalAnchor)
						end,
					},
					fill = {
						type = "toggle",
						name = L.fill,
						desc = L.fillDesc,
						order = 7,
						set = function(info, value)
							db[info[#info]] = value
							for bar in next, normalAnchor.bars do
								bar:SetFill(value)
							end
							for bar in next, emphasizeAnchor.bars do
								bar:SetFill(value)
							end
						end,
					},
					texture = {
						type = "select",
						name = L.texture,
						order = 8,
						width = 2,
						values = media:List(STATUSBAR),
						itemControl = "DDI-Statusbar",
						get = function(info)
							for i, v in next, media:List(STATUSBAR) do
								if v == db[info[#info]] then return i end
							end
						end,
						set = function(info, value)
							local list = media:List(STATUSBAR)
							local tex = list[value]
							db[info[#info]] = tex
							for bar in next, normalAnchor.bars do
								currentBarStyler.BarStopped(bar)
								bar:SetTexture(media:Fetch(STATUSBAR, tex))
								currentBarStyler.ApplyStyle(bar)
							end
							for bar in next, emphasizeAnchor.bars do
								currentBarStyler.BarStopped(bar)
								bar:SetTexture(media:Fetch(STATUSBAR, tex))
								currentBarStyler.ApplyStyle(bar)
							end
						end,
					},
					header2 = {
						type = "header",
						name = "",
						order = 9,
					},
					text = {
						type = "toggle",
						name = L.text,
						desc = L.textDesc,
						order = 10,
						set = function(info, value)
							db[info[#info]] = value
							for bar in next, normalAnchor.bars do
								currentBarStyler.BarStopped(bar)
								bar:SetLabelVisibility(value)
								currentBarStyler.ApplyStyle(bar)
							end
							for bar in next, emphasizeAnchor.bars do
								currentBarStyler.BarStopped(bar)
								bar:SetLabelVisibility(value)
								currentBarStyler.ApplyStyle(bar)
							end
						end,
					},
					alignText = {
						type = "select",
						name = L.alignText,
						order = 11,
						values = {
							LEFT = L.left,
							CENTER = L.center,
							RIGHT = L.right,
						},
						set = function(info, value)
							db[info[#info]] = value
							for bar in next, normalAnchor.bars do
								currentBarStyler.BarStopped(bar)
								bar.candyBarLabel:SetJustifyH(value)
								currentBarStyler.ApplyStyle(bar)
							end
							for bar in next, emphasizeAnchor.bars do
								currentBarStyler.BarStopped(bar)
								bar.candyBarLabel:SetJustifyH(value)
								currentBarStyler.ApplyStyle(bar)
							end
						end,
					},
					textSpacer = {
						type = "description",
						name = " ",
						order = 12,
					},
					time = {
						type = "toggle",
						name = L.time,
						desc = L.timeDesc,
						order = 13,
						set = function(info, value)
							db[info[#info]] = value
							for bar in next, normalAnchor.bars do
								currentBarStyler.BarStopped(bar)
								bar:SetTimeVisibility(value)
								currentBarStyler.ApplyStyle(bar)
							end
							for bar in next, emphasizeAnchor.bars do
								currentBarStyler.BarStopped(bar)
								bar:SetTimeVisibility(value)
								currentBarStyler.ApplyStyle(bar)
							end
						end,
					},
					alignTime = {
						type = "select",
						name = L.alignTime,
						order = 14,
						values = {
							LEFT = L.left,
							CENTER = L.center,
							RIGHT = L.right,
						},
						set = function(info, value)
							db[info[#info]] = value
							for bar in next, normalAnchor.bars do
								currentBarStyler.BarStopped(bar)
								bar.candyBarDuration:SetJustifyH(value)
								currentBarStyler.ApplyStyle(bar)
							end
							for bar in next, emphasizeAnchor.bars do
								currentBarStyler.BarStopped(bar)
								bar.candyBarDuration:SetJustifyH(value)
								currentBarStyler.ApplyStyle(bar)
							end
						end,
					},
					timeSpacer = {
						type = "description",
						name = " ",
						order = 15,
					},
					icon = {
						type = "toggle",
						name = L.icon,
						desc = L.iconDesc,
						order = 16,
						set = function(info, value)
							db[info[#info]] = value
							for bar in next, normalAnchor.bars do
								currentBarStyler.BarStopped(bar)
								if value then
									bar:SetIcon(bar:Get("bigwigs:iconoptionrestore") or 134337) -- Interface/Icons/INV_Misc_Orb_05
								else
									bar:Set("bigwigs:iconoptionrestore", bar:GetIcon())
									bar:SetIcon(nil)
								end
								currentBarStyler.ApplyStyle(bar)
							end
							for bar in next, emphasizeAnchor.bars do
								currentBarStyler.BarStopped(bar)
								if value then
									bar:SetIcon(bar:Get("bigwigs:iconoptionrestore") or 134337) -- Interface/Icons/INV_Misc_Orb_05
								else
									bar:Set("bigwigs:iconoptionrestore", bar:GetIcon())
									bar:SetIcon(nil)
								end
								currentBarStyler.ApplyStyle(bar)
							end
						end,
					},
					iconPosition = {
						type = "select",
						name = L.iconPosition,
						desc = L.iconPositionDesc,
						order = 17,
						values = {
							LEFT = L.left,
							RIGHT = L.right,
						},
						set = function(info, value)
							db[info[#info]] = value
							for bar in next, normalAnchor.bars do
								currentBarStyler.BarStopped(bar)
								bar:SetIconPosition(value)
								currentBarStyler.ApplyStyle(bar)
							end
							for bar in next, emphasizeAnchor.bars do
								currentBarStyler.BarStopped(bar)
								bar:SetIconPosition(value)
								currentBarStyler.ApplyStyle(bar)
							end
						end,
						disabled = function() return not db.icon end,
					},
					header3 = {
						type = "header",
						name = "",
						order = 18,
					},
					reset = {
						type = "execute",
						name = L.resetAll,
						desc = L.resetBarsDesc,
						func = function() plugin.db:ResetProfile() end,
						order = 19,
					},
				},
			},
			normal = {
				type = "group",
				name = L.bars,
				order = 2,
				args = {
					growup = {
						type = "toggle",
						name = L.growingUpwards,
						desc = L.growingUpwardsDesc,
						order = 1,
						set = sortBars,
					},
					visibleBarLimit = {
						type = "range",
						name = L.visibleBarLimit,
						desc = L.visibleBarLimitDesc,
						order = 2,
						max = 100,
						min = 1,
						step = 1,
						set = sortBars,
					},
					fontSize = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						width = 2,
						order = 3,
						max = 200, softMax = 72,
						min = 1,
						step = 1,
						set = updateFont,
					},
					exactPositioning = {
						type = "group",
						name = L.positionExact,
						order = 4,
						inline = true,
						args = {
							BigWigsAnchor_x = {
								type = "range",
								name = L.positionX,
								desc = L.positionDesc,
								min = -2048,
								softMax = 2048,
								step = 1,
								order = 1,
								width = 3.2,
							},
							BigWigsAnchor_y = {
								type = "range",
								name = L.positionY,
								desc = L.positionDesc,
								min = -2048,
								softMax = 2048,
								step = 1,
								order = 2,
								width = 3.2,
							},
							BigWigsAnchor_width = {
								type = "range",
								name = L.width,
								desc = L.sizeDesc,
								min = 80,
								softMax = 2000,
								step = 1,
								order = 3,
								width = 1.6,
							},
							BigWigsAnchor_height = {
								type = "range",
								name = L.height,
								desc = L.sizeDesc,
								min = 8,
								softMax = 150,
								step = 1,
								order = 4,
								width = 1.6,
							},
						},
					},
				},
			},
			emphasize = {
				type = "group",
				name = L.emphasizedBars,
				order = 3,
				args = {
					emphasize = {
						type = "toggle",
						name = L.enable,
						order = 1,
					},
					emphasizeRestart = {
						type = "toggle",
						name = L.restart,
						desc = L.restartDesc,
						order = 2,
					},
					emphasizeGrowup = {
						type = "toggle",
						name = L.growingUpwards,
						desc = L.growingUpwardsDesc,
						order = 3,
						set = sortBars,
						disabled = function() return not db.emphasizeMove end, -- Disable when using 1 anchor
					},
					emphasizeMove = {
						type = "toggle",
						name = L.move,
						desc = L.moveDesc,
						order = 4,
						set = function(_, value)
							db.emphasizeMove = value
							if not value then
								db.BigWigsEmphasizeAnchor_width = db.BigWigsAnchor_width*db.emphasizeMultiplier
								db.BigWigsEmphasizeAnchor_height = db.BigWigsAnchor_height*db.emphasizeMultiplier
							else
								db.BigWigsEmphasizeAnchor_width = BigWigsEmphasizeAnchor:GetWidth()
								db.BigWigsEmphasizeAnchor_height = BigWigsEmphasizeAnchor:GetHeight()
							end
						end,
					},
					emphasizeMultiplier = {
						type = "range",
						name = L.emphasizeMultiplier,
						desc = L.emphasizeMultiplierDesc,
						width = 2,
						order = 5,
						max = 3,
						min = 1,
						step = 0.01,
						set = function(_, value)
							db.emphasizeMultiplier = value
							db.BigWigsEmphasizeAnchor_width = db.BigWigsAnchor_width*value
							db.BigWigsEmphasizeAnchor_height = db.BigWigsAnchor_height*value
						end,
						disabled = function() return db.emphasizeMove end, -- Disable when using 2 anchors
					},
					emphasizeTime = {
						type = "range",
						name = L.emphasizeAt,
						order = 6,
						min = 6,
						max = 30,
						step = 1,
					},
					fontSizeEmph = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						order = 7,
						max = 200, softMax = 72,
						min = 1,
						step = 1,
						set = updateFont,
					},
					visibleBarLimitEmph = {
						type = "range",
						name = L.visibleBarLimit,
						desc = L.visibleBarLimitDesc,
						order = 8,
						max = 100,
						min = 1,
						step = 1,
						set = sortBars,
					},
					exactPositioning = {
						type = "group",
						name = L.positionExact,
						order = 9,
						inline = true,
						args = {
							BigWigsEmphasizeAnchor_x = {
								type = "range",
								name = L.positionX,
								desc = L.positionDesc,
								min = -2048,
								softMax = 2048,
								step = 1,
								order = 1,
								width = 3.2,
							},
							BigWigsEmphasizeAnchor_y = {
								type = "range",
								name = L.positionY,
								desc = L.positionDesc,
								min = -2048,
								softMax = 2048,
								step = 1,
								order = 2,
								width = 3.2,
							},
							BigWigsEmphasizeAnchor_width = {
								type = "range",
								name = L.width,
								desc = L.sizeDesc,
								min = 80,
								softMax = 2000,
								step = 1,
								order = 3,
								width = 1.6,
							},
							BigWigsEmphasizeAnchor_height = {
								type = "range",
								name = L.height,
								desc = L.sizeDesc,
								min = 8,
								softMax = 150,
								step = 1,
								order = 4,
								width = 1.6,
							},
						},
					},
				},
			},
			nameplateBars = {
				name = L.nameplateBars,
				type = "group",
				order = 4,
				set = function(info, value)
					db[info[#info]] = value
					if plugin:UnitGUID("target") then
						plugin:NAME_PLATE_UNIT_REMOVED(nil, "target")
						plugin:NAME_PLATE_UNIT_ADDED(nil, "target")
					end
				end,
				args = {
					nameplateWidth = {
						type = "range",
						name = L.width,
						order = 1,
						min = 75,
						softMax = 200,
						step = 1,
						width = 1.6,
						disabled = function() return db.nameplateAutoWidth end,
					},
					nameplateHeight = {
						type = "range",
						name = L.height,
						order = 2,
						min = 8,
						softMax = 50,
						step = 1,
						width = 1.6,
					},
					nameplateAutoWidth = {
						type = "toggle",
						name = L.nameplateAutoWidth,
						desc = L.nameplateAutoWidthDesc,
						order = 3,
						width = 1.6,
					},
					nameplateOffsetY = {
						type = "range",
						name = L.nameplateOffsetY,
						desc = L.nameplateOffsetYDesc,
						order = 4,
						min = 0,
						max = 400,
						step = 1,
						width = 1.6,
					},
					nameplateGrowUp = {
						type = "toggle",
						name = L.growingUpwards,
						desc = L.growingUpwardsDesc,
						order = 5,
						width = 1.6,
					},
					fontSizeNameplate = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						order = 6,
						max = 200, softMax = 72,
						min = 1,
						step = 1,
						width = 1.6,
					},
					nameplateAlpha = {
						type = "range",
						name = L.transparency,
						desc = L.nameplateAlphaDesc,
						order = 7,
						max = 1,
						min = 0.4,
						step = 0.1,
						width = 1.6,
					},
				},
			},
			clicking = {
				name = L.clickableBars,
				type = "group",
				order = 5,
				childGroups = "tab",
				get = function(i) return plugin.db.profile[i[#i]] end,
				set = function(i, value)
					local key = i[#i]
					plugin.db.profile[key] = value
					if key == "interceptMouse" then
						plugin:RefixClickIntercepts()
					end
				end,
				args = {
					heading = {
						type = "description",
						name = L.clickableBarsDesc,
						order = 1,
						width = "full",
						fontSize = "medium",
					},
					interceptMouse = {
						type = "toggle",
						name = L.enable,
						desc = L.interceptMouseDesc,
						order = 2,
						width = "full",
					},
					onlyInterceptOnKeypress = {
						type = "toggle",
						name = L.modifierKey,
						desc = L.modifierKeyDesc,
						order = 3,
						disabled = shouldDisable,
					},
					interceptKey = {
						type = "select",
						name = L.modifier,
						desc = L.modifierDesc,
						values = {
							CTRL = _G.CTRL_KEY,
							ALT = _G.ALT_KEY,
							SHIFT = _G.SHIFT_KEY,
						},
						order = 4,
						disabled = function()
							return not plugin.db.profile.interceptMouse or not plugin.db.profile.onlyInterceptOnKeypress
						end,
					},
					LeftButton = {
						type = "group",
						name = KEY_BUTTON1 or "Left",
						order = 10,
						args = clickOptions,
						get = function(info) return plugin.db.profile.LeftButton == info[#info] end,
						set = function(info, value) plugin.db.profile.LeftButton = value and info[#info] or nil end,
					},
					MiddleButton = {
						type = "group",
						name = KEY_BUTTON3 or "Middle",
						order = 11,
						args = clickOptions,
						get = function(info) return plugin.db.profile.MiddleButton == info[#info] end,
						set = function(info, value) plugin.db.profile.MiddleButton = value and info[#info] or nil end,
					},
					RightButton = {
						type = "group",
						name = KEY_BUTTON2 or "Right",
						order = 12,
						args = clickOptions,
						get = function(info) return plugin.db.profile.RightButton == info[#info] end,
						set = function(info, value) plugin.db.profile.RightButton = value and info[#info] or nil end,
					},
				},
			},
		},
	}
end

--------------------------------------------------------------------------------
-- Bar arrangement
--

do
	local function barSorter(a, b)
		return a.remaining < b.remaining and true or false
	end
	rearrangeBars = function(anchor)
		if not anchor then return end
		if anchor == normalAnchor then -- only show the empupdater when there are bars on the normal anchor running
			if next(anchor.bars) and db.emphasize then
				empUpdate:Play()
			else
				empUpdate:Stop()
			end
		end
		if not next(anchor.bars) then return end

		local tmp = {}
		for bar in next, anchor.bars do
			tmp[#tmp + 1] = bar
		end
		table.sort(tmp, barSorter)
		local lastBar = nil
		local up, barLimit
		if anchor == normalAnchor then
			up = db.growup
			barLimit = db.visibleBarLimit
		else
			up = db.emphasizeGrowup
			barLimit = db.visibleBarLimitEmph
		end
		for i = 1, #tmp do
			local bar = tmp[i]
			if i > barLimit then
				bar:SetAlpha(0)
				bar:EnableMouse(false)
			elseif barLimit ~= 100 then
				bar:SetAlpha(1)
				if db.interceptMouse and not db.onlyInterceptOnKeypress then
					bar:EnableMouse(true)
				end
			end
			local spacing = currentBarStyler.GetSpacing(bar) or db.spacing
			bar:ClearAllPoints()
			if up then
				if lastBar then -- Growing from a bar
					bar:SetPoint("BOTTOMLEFT", lastBar, "TOPLEFT", 0, spacing)
				else -- Growing from the anchor
					bar:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT")
				end
				lastBar = bar
			else
				if lastBar then -- Growing from a bar
					bar:SetPoint("TOPLEFT", lastBar, "BOTTOMLEFT", 0, -spacing)
				else -- Growing from the anchor
					bar:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT")
				end
				lastBar = bar
			end
		end
	end
end

do
	-- returns table of bar texts ordered by time remaining
	local function getOrder(bars)
		local barTexts = {}
		for text, _ in pairs(bars) do
			barTexts[#barTexts+1] = text
		end
		table.sort(barTexts, function(a, b)
			return bars[a].bar.remaining < bars[b].bar.remaining
		end)
		return barTexts
	end

	rearrangeNameplateBars = function(guid)
		local unit = findUnitByGUID(guid)
		if not unit then return end
		local nameplate = GetNamePlateForUnit(unit)
		local unitBars = nameplateBars[guid]
		if unitBars then
			local sorted = getOrder(nameplateBars[guid])
			local offset = db.nameplateOffsetY
			local barPoint = db.nameplateGrowUp and "BOTTOM" or "TOP"
			local nameplatePoint = db.nameplateGrowUp and "TOP" or "BOTTOM"
			for i, text in ipairs(sorted) do
				local bar = unitBars[text].bar
				bar:ClearAllPoints()
				bar:SetParent(nameplate)
				bar:SetPoint(barPoint, nameplate, nameplatePoint, 0, db.nameplateGrowUp and offset or -offset)
				offset = offset + db.spacing + bar:GetHeight()
			end
		end
	end
end

local function nameplateCascadeDelete(guid, text)
	nameplateBars[guid][text] = nil
	if not next(nameplateBars[guid]) then
		nameplateBars[guid] = nil
	end
end

local function createDeletionTimer(barInfo)
	return C_Timer.NewTimer(barInfo.exp - GetTime(), function()
		nameplateCascadeDelete(barInfo.unitGUID, barInfo.text)
	end)
end

local function barStopped(event, bar)
	local countdown = bar:Get("bigwigs:stopcountdown")
	if countdown then
		plugin:SendMessage("BigWigs_StopCountdown", plugin, countdown)
	end
	local a = bar:Get("bigwigs:anchor")
	local unitGUID = bar:Get("bigwigs:unitGUID")
	if a and a.bars and a.bars[bar] then
		currentBarStyler.BarStopped(bar)
		a.bars[bar] = nil
		rearrangeBars(a)
	elseif unitGUID then
		currentBarStyler.BarStopped(bar)
		local text = bar:GetLabel()
		nameplateBars[unitGUID][text].bar = nil
		if not bar:Get("bigwigs:offscreen") then
			nameplateCascadeDelete(unitGUID, text)
			rearrangeNameplateBars(unitGUID)
		end
	end
end

--------------------------------------------------------------------------------
-- Anchors
--

local defaultPositions = {
	BigWigsAnchor = {"CENTER", UIParent, "CENTER", 450, 200},
	BigWigsEmphasizeAnchor = {"CENTER", UIParent, "CENTER", 0, -100}, --Below the Emphasized Message frame, ish
}

local function onDragHandleMouseDown(self) self:GetParent():StartSizing("BOTTOMRIGHT") end
local function onDragHandleMouseUp(self) self:GetParent():StopMovingOrSizing() end
local onResize
do
	local throttle = false
	function onResize(self, width, height)
		db[self.w] = width
		db[self.h] = height
		if self == normalAnchor and not db.emphasizeMove then
			-- Move is disabled and we are configuring the normal anchor. Make sure to update the emphasized bars also.
			db[emphasizeAnchor.w] = width * db.emphasizeMultiplier
			db[emphasizeAnchor.h] = height * db.emphasizeMultiplier
		end
		if not throttle then
			throttle = true
			plugin:ScheduleTimer(function()
				for k in next, self.bars do
					currentBarStyler.BarStopped(k)
					if db.emphasizeMove then
						k:SetSize(db[self.w], db[self.h]) -- Move enabled, set the size no matter which anchor we are configuring
					elseif self == normalAnchor then
						-- Move is disabled and we are configuring the normal anchor. Don't apply normal bar sizes to emphasized bars
						if k:Get("bigwigs:emphasized") then
							k:SetSize(db[emphasizeAnchor.w], db[emphasizeAnchor.h])
						else
							k:SetSize(db[self.w], db[self.h])
						end
					end
					currentBarStyler.ApplyStyle(k)
					rearrangeBars(self)
				end
				if self:IsMouseOver() then -- Only if we're dragging the drag handle, not sliding the GUI slider
					plugin:UpdateGUI() -- Update width/height if GUI is open
				end
				throttle = false
			end, 0.1)
		end
	end
end
local function onDragStart(self) self:StartMoving() end
local function onDragStop(self)
	self:StopMovingOrSizing()
	local s = self:GetEffectiveScale()
	db[self.x] = self:GetLeft() * s
	db[self.y] = self:GetTop() * s
	plugin:UpdateGUI() -- Update X/Y if GUI is open
end

do
	local function createAnchor(frameName, title)
		local display = CreateFrame("Frame", frameName, UIParent)
		display.w, display.h, display.x, display.y = frameName .. "_width", frameName .. "_height", frameName .. "_x", frameName .. "_y"
		display:EnableMouse(true)
		display:SetClampedToScreen(true)
		display:SetMovable(true)
		display:SetResizable(true)
		display:RegisterForDrag("LeftButton")
		if display.SetResizeBounds then -- XXX Dragonflight compat
			display:SetResizeBounds(80, 8)
		else
			display:SetMinResize(80, 8)
		end
		display:SetFrameStrata("HIGH")
		display:SetFixedFrameStrata(true)
		display:SetFrameLevel(title == "BigWigsAnchor" and 10 or 15)
		display:SetFixedFrameLevel(true)
		local bg = display:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(display)
		bg:SetColorTexture(0, 0, 0, 0.3)
		display.background = bg
		local header = display:CreateFontString(nil, "ARTWORK")
		header:SetFont(plugin:GetDefaultFont(12))
		header:SetShadowOffset(1, -1)
		header:SetTextColor(1,0.82,0,1)
		header:SetText(title)
		header:SetPoint("CENTER", display, "CENTER")
		header:SetJustifyH("CENTER")
		header:SetJustifyV("MIDDLE")
		local drag = CreateFrame("Frame", nil, display)
		drag:SetWidth(16)
		drag:SetHeight(16)
		drag:SetPoint("BOTTOMRIGHT", display, -1, 1)
		drag:EnableMouse(true)
		drag:SetScript("OnMouseDown", onDragHandleMouseDown)
		drag:SetScript("OnMouseUp", onDragHandleMouseUp)
		local tex = drag:CreateTexture(nil, "OVERLAY")
		tex:SetTexture("Interface\\AddOns\\BigWigs\\Media\\Icons\\draghandle")
		tex:SetWidth(16)
		tex:SetHeight(16)
		tex:SetBlendMode("ADD")
		tex:SetPoint("CENTER", drag)
		display:SetScript("OnSizeChanged", onResize)
		display:SetScript("OnDragStart", onDragStart)
		display:SetScript("OnDragStop", onDragStop)
		display.bars = {}
		display.RefixPosition = function(self)
			self:ClearAllPoints()
			if db[self.x] and db[self.y] then
				local s = self:GetEffectiveScale()
				self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", db[self.x] / s, db[self.y] / s)
			else
				self:SetPoint(unpack(defaultPositions[self:GetName()]))
			end
			self:SetWidth(db[self.w] or plugin.defaultDB[self.w])
			self:SetHeight(db[self.h] or plugin.defaultDB[self.h])
		end
		display:Hide()
		return display
	end

	normalAnchor = createAnchor("BigWigsAnchor", L.bars)
	emphasizeAnchor = createAnchor("BigWigsEmphasizeAnchor", L.emphasizedBars)
end

local function showAnchors()
	normalAnchor:Show()
	emphasizeAnchor:Show()
end

local function hideAnchors()
	normalAnchor:Hide()
	emphasizeAnchor:Hide()
end

local function updateProfile()
	db = plugin.db.profile
	normalAnchor:RefixPosition()
	emphasizeAnchor:RefixPosition()
	if plugin:IsEnabled() then
		if not media:Fetch(STATUSBAR, db.texture, true) then db.texture = "BantoBar" end
		SetBarStyle(db.barStyle)
		plugin:RegisterMessage("DBM_AddonMessage")
	end
	-- XXX temp 9.0.2
	if type(db.LeftButton) ~= "string" then
		db.LeftButton = "report"
	end
	if type(db.MiddleButton) ~= "string" then
		db.MiddleButton = "remove"
	end
	if type(db.RightButton) ~= "string" then
		db.RightButton = "countdown"
	end
end

--------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnRegister()
	candy.RegisterCallback(self, "LibCandyBar_Stop", barStopped)

	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()
end

function plugin:OnPluginEnable()
	colors = BigWigs:GetPlugin("Colors")
	updateProfile()

	self:RegisterMessage("BigWigs_StartBar")
	self:RegisterMessage("BigWigs_StartNameplateBar")
	self:RegisterMessage("BigWigs_PauseBar", "PauseBar")
	self:RegisterMessage("BigWigs_PauseNameplateBar", "PauseNameplateBar")
	self:RegisterMessage("BigWigs_ResumeBar", "ResumeBar")
	self:RegisterMessage("BigWigs_ResumeNameplateBar", "ResumeNameplateBar")
	self:RegisterMessage("BigWigs_StopBar", "StopSpecificBar")
	self:RegisterMessage("BigWigs_StopNameplateBar", "StopNameplateBar")
	self:RegisterMessage("BigWigs_StopBars", "StopModuleBars")
	self:RegisterMessage("BigWigs_OnBossDisable", "StopModuleBars")
	self:RegisterMessage("BigWigs_OnBossWipe", "StopModuleBars")
	self:RegisterMessage("BigWigs_OnPluginDisable", "StopModuleBars")
	self:RegisterMessage("BigWigs_StartConfigureMode", showAnchors)
	self:RegisterMessage("BigWigs_StopConfigureMode", hideAnchors)
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)

	self:RefixClickIntercepts()
	self:RegisterEvent("MODIFIER_STATE_CHANGED", "RefixClickIntercepts")

	-- Nameplate bars
	self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

	-- custom bars
	self:RegisterMessage("BigWigs_PluginComm")
	self:RegisterMessage("DBM_AddonMessage")

	-- XXX temporary workaround for wow custom font loading issues, start a dummy bar to force load the selected font into memory
	self:SendMessage("BigWigs_StartBar", self, nil, "test", 0.01, 134376)

	local tbl = BigWigs3DB.breakTime
	if tbl then -- Break time present, resume it
		local prevTime, seconds, nick, isDBM = tbl[1], tbl[2], tbl[3], tbl[4]
		local curTime = time()
		if curTime-prevTime > seconds then
			BigWigs3DB.breakTime = nil
		else
			startBreak(seconds-(curTime-prevTime), nick, isDBM, true)
		end
	end
end

function plugin:OnPluginDisable()
	for k in next, normalAnchor.bars do
		k:Stop()
	end
	for k in next, emphasizeAnchor.bars do
		k:Stop()
	end
end

--------------------------------------------------------------------------------
-- Bar styles API
--

do
	local errorDeprecated = "An addon registered the bar style '%s' using the old method. Visit github.com/BigWigsMods/BigWigs/wiki/Custom-Bar-Styles to learn how to do it correctly."
	function plugin:RegisterBarStyle(key, styleData)
		BigWigs:Print(errorDeprecated:format(key))
		BigWigsAPI:RegisterBarStyle(key, styleData)
	end
end

do
	function plugin:SetBarStyle(styleName)
		-- Ask users to select your bar styles. Forcing a selection is deprecated.
		-- This is to allow users to install multiple styles gracefully, and to encourage authors to use new style entry APIs like `.barHeight` or `.fontSizeNormal`
		-- Want more style API entries? We're open to suggestions!
		BigWigs:Print(("SetBarStyle is deprecated, bar style '%s' was not set automatically, you may need to set it yourself."):format(styleName))
	end
	local errorNoStyle = "No style with the ID %q has been registered. Reverting to default style."
	function SetBarStyle(styleName)
		local style = BigWigsAPI:GetBarStyle(styleName)
		if not style then
			BigWigs:Print(errorNoStyle:format(styleName))
			styleName = "Default"
		end
		style = BigWigsAPI:GetBarStyle(styleName)

		-- Iterate all running bars
		if currentBarStyler then
			if normalAnchor then
				for bar in next, normalAnchor.bars do
					currentBarStyler.BarStopped(bar)
					bar.candyBarBackdrop:Hide()
					style.ApplyStyle(bar)
				end
			end
			if emphasizeAnchor then
				for bar in next, emphasizeAnchor.bars do
					currentBarStyler.BarStopped(bar)
					bar.candyBarBackdrop:Hide()
					style.ApplyStyle(bar)
				end
			end
		end
		currentBarStyler = style

		rearrangeBars(normalAnchor)
		rearrangeBars(emphasizeAnchor)

		if db then
			db.barStyle = styleName
		end
	end
end

--------------------------------------------------------------------------------
-- Pausing bars
--

function plugin:PauseBar(_, module, text)
	if not normalAnchor then return end
	for k in next, normalAnchor.bars do
		if k:Get("bigwigs:module") == module and k:GetLabel() == text then
			k:Pause()
			return
		end
	end
	for k in next, emphasizeAnchor.bars do
		if k:Get("bigwigs:module") == module and k:GetLabel() == text then
			k:Pause()
			return
		end
	end
end

function plugin:PauseNameplateBar(_, module, text, unitGUID)
	local barInfo = nameplateBars[unitGUID] and nameplateBars[unitGUID][text]
	if barInfo and not barInfo.paused then
		barInfo.paused = true
		if barInfo.bar then
			barInfo.bar:Pause()
		else
			barInfo.deletionTimer:Cancel()
		end
		barInfo.remaining = barInfo.exp - GetTime()
	end
end

function plugin:ResumeBar(_, module, text)
	if not normalAnchor then return end
	for k in next, normalAnchor.bars do
		if k:Get("bigwigs:module") == module and k:GetLabel() == text then
			k:Resume()
			return
		end
	end
	for k in next, emphasizeAnchor.bars do
		if k:Get("bigwigs:module") == module and k:GetLabel() == text then
			k:Resume()
			return
		end
	end
end

function plugin:ResumeNameplateBar(_, module, text, unitGUID)
	local barInfo = nameplateBars[unitGUID] and nameplateBars[unitGUID][text]
	if barInfo and barInfo.paused then
		barInfo.paused = false
		barInfo.exp = GetTime() + barInfo.remaining
		if barInfo.bar then
			barInfo.bar:Resume()
		else
			barInfo.deletionTimer = createDeletionTimer(barInfo)
		end
		barInfo.remaining = nil
	end
end

--------------------------------------------------------------------------------
-- Stopping bars
--

function plugin:StopSpecificBar(_, module, text)
	if not normalAnchor then return end
	for k in next, normalAnchor.bars do
		if k:Get("bigwigs:module") == module and k:GetLabel() == text then
			k:Stop()
		end
	end
	for k in next, emphasizeAnchor.bars do
		if k:Get("bigwigs:module") == module and k:GetLabel() == text then
			k:Stop()
		end
	end
end

function plugin:StopNameplateBar(_, module, text, guid)
	if not nameplateBars[guid] then return end
	local barInfo = nameplateBars[guid][text]
	if barInfo and barInfo.module == module then
		if barInfo.bar then
			barInfo.bar:Stop()
		else
			barInfo.deletionTimer:Cancel()
			nameplateCascadeDelete(guid, text)
		end
	end
end

function plugin:StopModuleBars(_, module)
	if not normalAnchor then return end
	for k in next, normalAnchor.bars do
		if k:Get("bigwigs:module") == module then
			k:Stop()
		end
	end
	for k in next, emphasizeAnchor.bars do
		if k:Get("bigwigs:module") == module then
			k:Stop()
		end
	end
	for _, bars in next, nameplateBars do
		for _, barInfo in next, bars do
			if barInfo.module == module then
				if barInfo.bar then
					barInfo.bar:Stop()
				else
					barInfo.deletionTimer:Cancel()
					nameplateCascadeDelete(barInfo.unitGUID, barInfo.text)
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Bar utility functions
--

function plugin:HasActiveBars()
	if next(normalAnchor.bars) then
		return true
	end
	if next(emphasizeAnchor.bars) then
		return true
	end
	return false
end

function plugin:GetBarTimeLeft(module, text)
	if normalAnchor then
		for k in next, normalAnchor.bars do
			if k:Get("bigwigs:module") == module and k:GetLabel() == text then
				return k.remaining
			end
		end
		for k in next, emphasizeAnchor.bars do
			if k:Get("bigwigs:module") == module and k:GetLabel() == text then
				return k.remaining
			end
		end
	end
	return 0
end

function plugin:GetNameplateBarTimeLeft(module, text, guid)
	if nameplateBars[guid] then
		local barInfo = nameplateBars[guid][text]
		local bar = barInfo and barInfo.bar
		if bar and bar:Get("bigwigs:module") == module then
			return bar.remaining
		else
			return barInfo.paused and barInfo.remaining or barInfo.exp - GetTime()
		end
	end
	return 0
end

--------------------------------------------------------------------------------
-- Clickable bars
--

local function barClicked(bar, button)
	local action = plugin.db.profile[button]
	if action and clickHandlers[action] then
		clickHandlers[action](bar)
	end
end

local function barOnEnter(bar)
	bar.candyBarBackground:SetVertexColor(1, 1, 1, 0.8)
end
local function barOnLeave(bar)
	local module = bar:Get("bigwigs:module")
	local key = bar:Get("bigwigs:option")
	bar.candyBarBackground:SetVertexColor(colors:GetColor("barBackground", module, key))
end

local function refixClickOnBar(intercept, bar)
	if intercept then
		bar:EnableMouse(true)
		bar:SetScript("OnMouseDown", barClicked)
		bar:SetScript("OnEnter", barOnEnter)
		bar:SetScript("OnLeave", barOnLeave)
	else
		bar:EnableMouse(false)
		bar:SetScript("OnMouseDown", nil)
		bar:SetScript("OnEnter", nil)
		bar:SetScript("OnLeave", nil)
	end
end
local function refixClickOnAnchor(intercept, anchor)
	for bar in next, anchor.bars do
		if not intercept or bar:GetAlpha() > 0 then -- Don't enable for hidden bars
			refixClickOnBar(intercept, bar)
		end
	end
end

do
	local keymap = {
		LALT = "ALT", RALT = "ALT",
		LSHIFT = "SHIFT", RSHIFT = "SHIFT",
		LCTRL = "CTRL", RCTRL = "CTRL",
	}
	function plugin:RefixClickIntercepts(event, key, state)
		if not db.interceptMouse or not normalAnchor then return end
		if not db.onlyInterceptOnKeypress or (db.onlyInterceptOnKeypress and type(key) == "string" and db.interceptKey == keymap[key] and state == 1) then
			refixClickOnAnchor(true, normalAnchor)
			refixClickOnAnchor(true, emphasizeAnchor)
		else
			refixClickOnAnchor(false, normalAnchor)
			refixClickOnAnchor(false, emphasizeAnchor)
		end
	end
end

-- Enable countdown on the clicked bar
clickHandlers.countdown = function(bar)
	-- Add 0.2sec here to catch messages for this option triggered when the bar ends.
	local text = bar:GetLabel()
	bar:Set("bigwigs:stopcountdown", text)
	plugin:SendMessage("BigWigs_StartCountdown", plugin, nil, text, bar.remaining)
end

-- Report the bar status to the active group type (raid, party, solo)
do
	local tformat1 = "%d:%02d"
	local tformat2 = "%1.1f"
	local tformat3 = "%.0f"
	local function timeDetails(t)
		if t >= 3600 then -- > 1 hour
			local h = floor(t/3600)
			local m = t - (h*3600)
			return tformat1:format(h, m)
		elseif t >= 60 then -- 1 minute to 1 hour
			local m = floor(t/60)
			local s = t - (m*60)
			return tformat1:format(m, s)
		elseif t < 10 then -- 0 to 10 seconds
			return tformat2:format(t)
		else -- 10 seconds to one minute
			return tformat3:format(floor(t + .5))
		end
	end
	local SendChatMessage = BigWigsLoader.SendChatMessage
	clickHandlers.report = function(bar)
		local text = ("%s: %s"):format(bar:GetLabel(), timeDetails(bar.remaining))
		SendChatMessage(text, (IsInGroup(2) and "INSTANCE_CHAT") or (IsInRaid() and "RAID") or (IsInGroup() and "PARTY") or "SAY")
	end
end

-- Removes the clicked bar
clickHandlers.remove = function(bar)
	bar:Stop()
end

-- Removes all bars EXCEPT the clicked one
clickHandlers.removeOther = function(bar)
	if normalAnchor then
		for k in next, normalAnchor.bars do
			if k ~= bar then
				k:Stop()
			end
		end
	end
	if emphasizeAnchor then
		for k in next, emphasizeAnchor.bars do
			if k ~= bar then
				k:Stop()
			end
		end
	end
end

-----------------------------------------------------------------------
-- Start bars
--

function plugin:CreateBar(module, key, text, time, icon, isApprox, unitGUID)
	local width, height
	if unitGUID then
		width, height = db.nameplateWidth, db.nameplateHeight
		if db.nameplateAutoWidth then
			local unit = findUnitByGUID(unitGUID)
			if unit then
				local nameplate = GetNamePlateForUnit(unit)
				local npWidth = nameplate and nameplate:GetWidth() or 110
				if npWidth < 111 then
					width = npWidth
				else
					width = 110
				end
			end
		end
	else
		width, height = db.BigWigsAnchor_width, db.BigWigsAnchor_height
	end
	local bar = candy:New(media:Fetch(STATUSBAR, db.texture), width, height)
	bar.candyBarBackground:SetVertexColor(colors:GetColor("barBackground", module, key))
	bar:Set("bigwigs:module", module)
	bar:Set("bigwigs:option", key)
	if unitGUID then
		bar:Set("bigwigs:unitGUID", unitGUID)
	else
		bar:Set("bigwigs:anchor", normalAnchor)
		normalAnchor.bars[bar] = true
	end
	bar:SetIcon(db.icon and icon or nil)
	bar:SetLabel(text)
	bar:SetDuration(time, isApprox)
	bar:SetColor(colors:GetColor("barColor", module, key))
	bar:SetTextColor(colors:GetColor("barText", module, key))
	bar:SetShadowColor(colors:GetColor("barTextShadow", module, key))
	bar.candyBarLabel:SetJustifyH(db.alignText)
	bar.candyBarDuration:SetJustifyH(db.alignTime)
	local flags = nil
	if db.monochrome and db.outline ~= "NONE" then
		flags = "MONOCHROME," .. db.outline
	elseif db.monochrome then
		flags = "MONOCHROME"
	elseif db.outline ~= "NONE" then
		flags = db.outline
	end
	local f = media:Fetch(FONT, db.fontName)
	if unitGUID then
		bar.candyBarLabel:SetFont(f, db.fontSizeNameplate, flags)
		bar.candyBarDuration:SetFont(f, db.fontSizeNameplate, flags)
		bar:SetAlpha(db.nameplateAlpha)
	else
		bar.candyBarLabel:SetFont(f, db.fontSize, flags)
		bar.candyBarDuration:SetFont(f, db.fontSize, flags)
	end

	bar:SetTimeVisibility(db.time)
	bar:SetLabelVisibility(db.text)
	bar:SetIconPosition(db.iconPosition)
	bar:SetFill(db.fill)

	if db.interceptMouse and not db.onlyInterceptOnKeypress and not unitGUID then
		refixClickOnBar(true, bar)
	end

	return bar
end

function plugin:BigWigs_StartBar(_, module, key, text, time, icon, isApprox, maxTime)
	if not text then text = "" end
	self:StopSpecificBar(nil, module, text)

	local bar = self:CreateBar(module, key, text, time, icon, isApprox)
	bar:Start(maxTime)
	if db.emphasize and time < db.emphasizeTime then
		self:EmphasizeBar(bar, true)
	else
		currentBarStyler.ApplyStyle(bar)
	end
	rearrangeBars(bar:Get("bigwigs:anchor"))

	self:SendMessage("BigWigs_BarCreated", self, bar, module, key, text, time, icon, isApprox)
	-- Check if :EmphasizeBar(bar) was run and trigger the callback.
	-- Bit of a roundabout method to approaching this so that we purposely keep callbacks firing last.
	if bar:Get("bigwigs:emphasized") then
		self:SendMessage("BigWigs_BarEmphasized", self, bar)
	end
end

function plugin:BigWigs_StartNameplateBar(_, module, key, text, time, icon, isApprox, unitGUID)
	if not text then text = "" end
	self:StopNameplateBar(nil, module, text, unitGUID)

	if not nameplateBars[unitGUID] then nameplateBars[unitGUID] = {} end
	local barInfo = {
		module = module,
		key = key,
		text = text,
		time = time,
		exp = GetTime() + time,
		icon = icon,
		isApprox = isApprox,
		unitGUID = unitGUID,
	}
	nameplateBars[unitGUID][text] = barInfo

	local unit = findUnitByGUID(unitGUID)
	if unit then
		local bar = self:CreateBar(module, key, text, time, icon, isApprox, unitGUID)
		barInfo.bar = bar
		bar:Start()
		rearrangeNameplateBars(unitGUID)
	else
		barInfo.deletionTimer = createDeletionTimer(barInfo)
	end
end

--------------------------------------------------------------------------------
-- Emphasize
--

do
	local dirty = nil
	local frame = CreateFrame("Frame")
	empUpdate = frame:CreateAnimationGroup()
	empUpdate:SetScript("OnLoop", function()
		for k in next, normalAnchor.bars do
			if k.remaining < db.emphasizeTime and not k:Get("bigwigs:emphasized") then
				dirty = true
				plugin:EmphasizeBar(k)
				plugin:SendMessage("BigWigs_BarEmphasized", plugin, k)
			end
		end
		if dirty then
			rearrangeBars(normalAnchor)
			rearrangeBars(emphasizeAnchor)
			dirty = nil
		end
	end)
	empUpdate:SetLooping("REPEAT")

	local anim = empUpdate:CreateAnimation()
	anim:SetDuration(0.2)
end

function plugin:EmphasizeBar(bar, freshBar)
	if db.emphasizeMove then
		normalAnchor.bars[bar] = nil
		emphasizeAnchor.bars[bar] = true
		bar:Set("bigwigs:anchor", emphasizeAnchor)
	end
	if not freshBar then
		currentBarStyler.BarStopped(bar) -- Only call BarStopped on bars that have already started (ApplyStyle was called on them first)
		if db.emphasizeRestart then
			bar:Start() -- restart the bar -> remaining time is a full length bar again after moving it to the emphasize anchor
		end
	end
	local module = bar:Get("bigwigs:module")
	local key = bar:Get("bigwigs:option")

	local flags = nil
	if db.monochrome and db.outline ~= "NONE" then
		flags = "MONOCHROME," .. db.outline
	elseif db.monochrome then
		flags = "MONOCHROME"
	elseif db.outline ~= "NONE" then
		flags = db.outline
	end
	local f = media:Fetch(FONT, db.fontName)
	bar.candyBarLabel:SetFont(f, db.fontSizeEmph, flags)
	bar.candyBarDuration:SetFont(f, db.fontSizeEmph, flags)

	bar:SetColor(colors:GetColor("barEmphasized", module, key))
	bar:SetHeight(db.BigWigsEmphasizeAnchor_height)
	bar:SetWidth(db.BigWigsEmphasizeAnchor_width)
	currentBarStyler.ApplyStyle(bar)
	bar:Set("bigwigs:emphasized", true)
end

--------------------------------------------------------------------------------
-- Custom Bars
--

local function parseTime(input)
	if type(input) == "nil" then return end
	if tonumber(input) then return tonumber(input) end
	if type(input) == "string" then
		input = input:trim()
		if input:find(":") then
			local _, _, m, s = input:find("^(%d+):(%d+)$")
			if not tonumber(m) or not tonumber(s) then return end
			return (tonumber(m) * 60) + tonumber(s)
		elseif input:find("^%d+mi?n?$") then
			local _, _, t = input:find("^(%d+)mi?n?$")
			return tonumber(t) * 60
		end
	end
end

local startCustomBar
do
	local timers, prevBars
	function startCustomBar(bar, nick, localOnly, isDBM)
		if not timers then timers, prevBars = {}, {} end

		local seconds, barText
		if localOnly then
			seconds, barText, nick = bar, localOnly, L.localTimer
		else
			if prevBars[bar] and GetTime() - prevBars[bar] < 1.2 then return end -- Throttle
			prevBars[bar] = GetTime()
			if not UnitIsGroupLeader(nick) and not UnitIsGroupAssistant(nick) then return end
			seconds, barText = bar:match("(%S+) (.*)")
			seconds = parseTime(seconds)
			if type(seconds) ~= "number" or type(barText) ~= "string" or seconds < 0 then
				return
			end
			BigWigs:Print(L.customBarStarted:format(barText, isDBM and "DBM" or "BigWigs", nick))
		end

		local id = "bwcb" .. nick .. barText
		if timers[id] then
			plugin:CancelTimer(timers[id])
			timers[id] = nil
		end

		nick = nick:gsub("%-.+", "*") -- Remove server name
		if seconds == 0 then
			plugin:SendMessage("BigWigs_StopBar", plugin, nick..": "..barText)
		else
			timers[id] = plugin:ScheduleTimer("SendMessage", seconds, "BigWigs_Message", plugin, false, L.timerFinished:format(nick, barText), "yellow", 134376)
			plugin:SendMessage("BigWigs_StartBar", plugin, id, nick..": "..barText, seconds, 134376) -- 134376 = "Interface\\Icons\\INV_Misc_PocketWatch_01"
		end
	end
end

do
	local timerTbl, lastBreak = nil, 0
	function startBreak(seconds, nick, isDBM, reboot)
		if not reboot then
			if (not UnitIsGroupLeader(nick) and not UnitIsGroupAssistant(nick) and not UnitIsUnit(nick, "player")) or IsEncounterInProgress() then return end
			seconds = tonumber(seconds)
			if not seconds or seconds < 0 or seconds > 3600 or (seconds > 0 and seconds < 60) then return end -- 1h max, 1m min

			local t = GetTime()
			if t-lastBreak < 0.5 then return else lastBreak = t end -- Throttle
		end

		if timerTbl then
			for i = 1, #timerTbl do
				plugin:CancelTimer(timerTbl[i])
			end
			if seconds == 0 then
				timerTbl = nil
				BigWigs3DB.breakTime = nil
				BigWigs:Print(L.breakStopped:format(nick))
				plugin:SendMessage("BigWigs_StopBar", plugin, L.breakBar)
				plugin:SendMessage("BigWigs_StopBreak", plugin, seconds, nick, isDBM, reboot)
				return
			end
		end

		if not reboot then
			BigWigs3DB.breakTime = {time(), seconds, nick, isDBM}
		end

		BigWigs:Print(L.breakStarted:format(isDBM and "DBM" or "BigWigs", nick))

		timerTbl = {}
		if seconds > 30 then
			timerTbl[#timerTbl+1] = plugin:ScheduleTimer("SendMessage", seconds - 30, "BigWigs_Message", plugin, nil, L.breakSeconds:format(30), "orange", 134062) -- 134062 = "Interface\\Icons\\inv_misc_fork&knife"
		end
		if seconds > 10 then
			timerTbl[#timerTbl+1] = plugin:ScheduleTimer("SendMessage", seconds - 10, "BigWigs_Message", plugin, nil, L.breakSeconds:format(10), "orange", 134062)
		end
		if seconds > 5 then
			timerTbl[#timerTbl+1] = plugin:ScheduleTimer("SendMessage", seconds - 5, "BigWigs_Message", plugin, nil, L.breakSeconds:format(5), "orange", 134062)
		end
		timerTbl[#timerTbl+1] = plugin:ScheduleTimer("SendMessage", seconds, "BigWigs_Message", plugin, nil, L.breakFinished, "red", 134062)
		timerTbl[#timerTbl+1] = plugin:ScheduleTimer("SendMessage", seconds, "BigWigs_Sound", plugin, nil, "Long")
		timerTbl[#timerTbl+1] = plugin:ScheduleTimer(function() BigWigs3DB.breakTime = nil timerTbl = nil end, seconds)

		if seconds > 119 then -- 2min
			timerTbl[#timerTbl+1] = plugin:ScheduleTimer("SendMessage", seconds - 60, "BigWigs_Message", plugin, nil, L.breakMinutes:format(1), "yellow", 134062)
		end
		if seconds > 239 then -- 4min
			local half = seconds / 2
			local m = half % 60
			local halfMin = (half - m) / 60
			timerTbl[#timerTbl+1] = plugin:ScheduleTimer("SendMessage", half + m, "BigWigs_Message", plugin, nil, L.breakMinutes:format(halfMin), "yellow", 134062)
		end

		plugin:SendMessage("BigWigs_Message", plugin, nil, seconds < 61 and L.breakSeconds:format(seconds) or L.breakMinutes:format(seconds/60), "green", 134062)
		if not reboot then
			plugin:SendMessage("BigWigs_Sound", plugin, nil, "Long")
		end
		plugin:SendMessage("BigWigs_StartBar", plugin, nil, L.breakBar, seconds, 134062)
		plugin:SendMessage("BigWigs_StartBreak", plugin, seconds, nick, isDBM, reboot)
	end
end

function plugin:DBM_AddonMessage(_, sender, prefix, seconds, text)
	if prefix == "U" then
		startCustomBar(seconds.." "..text, sender, nil, true)
	elseif prefix == "BT" then
		startBreak(seconds, sender, true)
	end
end

function plugin:BigWigs_PluginComm(_, msg, seconds, sender)
	if seconds then
		if msg == "CBar" then
			startCustomBar(seconds, sender)
		elseif msg == "Break" then
			startBreak(seconds, sender)
		end
	end
end

-------------------------------------------------------------------------------
-- Nameplate bar management
--

function plugin:NAME_PLATE_UNIT_ADDED(_, unit)
	local guid = plugin:UnitGUID(unit)
	local unitBars = nameplateBars[guid]
	if not unitBars then return end
	for _, barInfo in next, unitBars do
		local time = barInfo.paused and barInfo.remaining or barInfo.exp - GetTime()
		local bar = plugin:CreateBar(
			barInfo.module,
			barInfo.key,
			barInfo.text,
			time,
			barInfo.icon,
			barInfo.isApprox,
			barInfo.unitGUID
		)
		barInfo.bar = bar
		barInfo.deletionTimer:Cancel()
		barInfo.deletionTimer = nil
		bar:Start(barInfo.time)
		if barInfo.paused then
			bar:Pause()
		end
	end
	rearrangeNameplateBars(guid)
end

function plugin:NAME_PLATE_UNIT_REMOVED(_, unit)
	local guid = plugin:UnitGUID(unit)
	local unitBars = nameplateBars[guid]
	if not unitBars then return end

	for _, barInfo in next, unitBars do
		barInfo.bar:Set("bigwigs:offscreen", true)
		barInfo.bar:Stop()
		if not barInfo.paused then
			barInfo.deletionTimer = createDeletionTimer(barInfo)
		end
	end
end

-------------------------------------------------------------------------------
-- Slashcommand
--

local SendAddonMessage = BigWigsLoader.SendAddonMessage
do
	local times
	SlashCmdList.BIGWIGSRAIDBAR = function(input)
		if not plugin:IsEnabled() then BigWigs:Enable() end

		if not IsInGroup() or (not UnitIsGroupLeader("player") and not UnitIsGroupAssistant("player")) then BigWigs:Print(L.requiresLeadOrAssist) return end

		local seconds, barText = input:match("(%S+) (.*)")
		if not seconds or not barText then BigWigs:Print(L.wrongCustomBarFormat) return end

		seconds = parseTime(seconds)
		if not seconds or seconds < 0 then BigWigs:Print(L.wrongTime) return end

		if not times then times = {} end
		local t = GetTime()
		if not times[input] or (times[input] and (times[input] + 2) < t) then
			times[input] = t
			BigWigs:Print(L.sendCustomBar:format(barText))
			plugin:Sync("CBar", input)
			SendAddonMessage("D4", ("U\t%d\t%s"):format(seconds, barText), IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- DBM message
		end
	end
	SLASH_BIGWIGSRAIDBAR1 = "/raidbar"
end

SlashCmdList.BIGWIGSLOCALBAR = function(input)
	if not plugin:IsEnabled() then BigWigs:Enable() end

	local seconds, barText = input:match("(%S+) (.*)")
	if not seconds or not barText then BigWigs:Print(L.wrongCustomBarFormat:gsub("/raidbar", "/localbar")) return end

	seconds = parseTime(seconds)
	if not seconds then BigWigs:Print(L.wrongTime) return end

	startCustomBar(seconds, plugin:UnitName("player"), barText)
end
SLASH_BIGWIGSLOCALBAR1 = "/localbar"

SlashCmdList.BIGWIGSBREAK = function(input)
	if not plugin:IsEnabled() then BigWigs:Enable() end
	if IsEncounterInProgress() then BigWigs:Print(L.encounterRestricted) return end -- Doesn't make sense to allow this in combat
	if not IsInGroup() or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then -- Solo or leader/assist
		local minutes = tonumber(input)
		if not minutes or minutes < 0 or minutes > 60 or (minutes > 0 and minutes < 1) then BigWigs:Print(L.wrongBreakFormat) return end -- 1h max, 1m min

		if minutes ~= 0 then
			BigWigs:Print(L.sendBreak)
		end
		local seconds = minutes * 60
		plugin:Sync("Break", seconds)

		if IsInGroup() then
			SendAddonMessage("D4", ("BT\t%d"):format(seconds), IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- DBM message
		end
	else
		BigWigs:Print(L.requiresLeadOrAssist)
	end
end
SLASH_BIGWIGSBREAK1 = "/break"
