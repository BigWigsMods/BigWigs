
--[[
See BigWigs/Docs/BarStyles.txt for in-depth information on how to register new
bar styles from 3rd party addons.
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
local next = next
local tremove = tremove
local db = nil
local normalAnchor, emphasizeAnchor = nil, nil
local empUpdate = nil -- emphasize updater frame

local clickHandlers = {}

--------------------------------------------------------------------------------
-- Bar styles setup
--

local currentBarStyler = nil

local barStyles = {
	Default = {
		apiVersion = 1,
		version = 1,
		--GetSpacing = function(bar) end,
		--ApplyStyle = function(bar) end,
		--BarStopped = function(bar) end,
		GetStyleName = function()
			return L.bigWigsBarStyleName_Default
		end,
	},
}
local barStyleRegister = {}

do
	-- !Beautycase styling, based on !Beatycase by Neal "Neave" @ WowI, texture made by Game92 "Aftermathh" @ WowI

	local textureNormal = "Interface\\AddOns\\BigWigs\\Textures\\beautycase"

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
		for i, border in next, borders do
			if i == 1 then
				border:SetTexCoord(0, 1/3, 0, 1/3)
				border:SetPoint("TOPLEFT", -18, 4)
			elseif i == 2 then
				border:SetTexCoord(2/3, 1, 0, 1/3)
				border:SetPoint("TOPRIGHT", 4, 4)
			elseif i == 3 then
				border:SetTexCoord(0, 1/3, 2/3, 1)
				border:SetPoint("BOTTOMLEFT", -18, -4)
			elseif i == 4 then
				border:SetTexCoord(2/3, 1, 2/3, 1)
				border:SetPoint("BOTTOMRIGHT", 4, -4)
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

	barStyles.BeautyCase = {
		apiVersion = 1,
		version = 1,
		GetSpacing = function(bar) return 10 end,
		ApplyStyle = styleBar, -- function(bar) return end
		BarStopped = freeStyle,
		GetStyleName = function() return "!Beautycase" end,
	}
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
		bar:SetHeight(14)
		bar.candyBarBackdrop:Hide()

		local tex = bar:Get("bigwigs:restoreicon")
		if tex then
			local icon = bar.candyBarIconFrame
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT")
			icon:SetPoint("BOTTOMLEFT")
			bar:SetIcon(tex)

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
		bar:SetHeight(6)

		local bd = bar.candyBarBackdrop

		bd:SetBackdrop(backdropBorder)
		bd:SetBackdropColor(.1,.1,.1,1)
		bd:SetBackdropBorderColor(0,0,0,1)

		bd:ClearAllPoints()
		bd:SetPoint("TOPLEFT", bar, "TOPLEFT", -2, 2)
		bd:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 2, -2)
		bd:Show()

		if plugin.db.profile.icon then
			local icon = bar.candyBarIconFrame
			local tex = icon.icon
			bar:SetIcon(nil)
			icon:SetTexture(tex)
			icon:ClearAllPoints()
			icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -5, 0)
			icon:SetSize(16, 16)
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
		bar.candyBarLabel:SetPoint("LEFT", bar.candyBarBar, "LEFT", 2, 10)
		bar.candyBarLabel:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 10)

		bar.candyBarDuration:ClearAllPoints()
		bar.candyBarDuration:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 10)
		bar.candyBarDuration:SetPoint("LEFT", bar.candyBarBar, "LEFT", 2, 10)
	end

	barStyles.MonoUI = {
		apiVersion = 1,
		version = 2,
		GetSpacing = function(bar) return 15 end,
		ApplyStyle = styleBar,
		BarStopped = removeStyle,
		GetStyleName = function() return "MonoUI" end,
	}
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
		bd.tukiborder:Hide()
		bd.tukoborder:Hide()
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
			local border = CreateFrame("Frame", nil, bd)
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
			local border = CreateFrame("Frame", nil, bd)
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

	barStyles.TukUI = {
		apiVersion = 1,
		version = 3,
		GetSpacing = function(bar) return 7 end,
		ApplyStyle = styleBar,
		BarStopped = removeStyle,
		GetStyleName = function() return "TukUI" end,
	}
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
		bar:SetHeight(14)

		local bd = bar.candyBarBackdrop
		bd:Hide()
		if bd.iborder then
			bd.iborder:Hide()
			bd.oborder:Hide()
		end

		local tex = bar:Get("bigwigs:restoreicon")
		if tex then
			local icon = bar.candyBarIconFrame
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT")
			icon:SetPoint("BOTTOMLEFT")
			bar:SetIcon(tex)

			local iconBd = bar.candyBarIconFrameBackdrop
			iconBd:Hide()
			if iconBd.iborder then
				iconBd.iborder:Hide()
				iconBd.oborder:Hide()
			end
		end
	end

	local function styleBar(bar)
		bar:SetHeight(20)

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

		if plugin.db.profile.icon then
			local icon = bar.candyBarIconFrame
			local tex = icon.icon
			bar:SetIcon(nil)
			icon:SetTexture(tex)
			icon:ClearAllPoints()
			icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", E and (E.PixelMode and -1 or -5) or -1, 0)
			icon:SetSize(20, 20)
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

	barStyles.ElvUI = {
		apiVersion = 1,
		version = 2,
		GetSpacing = function(bar) return E and (E.PixelMode and 4 or 8) or 4 end,
		ApplyStyle = styleBar,
		BarStopped = removeStyle,
		GetStyleName = function() return "ElvUI" end,
	}
end

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	scale = 1.0,
	fontSize = 10,
	texture = "BantoBar",
	font = nil,
	monochrome = nil,
	outline = "NONE",
	growup = true,
	time = true,
	alignText = "LEFT",
	alignTime = "RIGHT",
	icon = true,
	fill = nil,
	barStyle = "Default",
	emphasize = true,
	emphasizeMove = true,
	emphasizeScale = 1.5,
	emphasizeGrowup = nil,
	emphasizeRestart = true,
	emphasizeTime = 11,
	BigWigsAnchor_width = 200,
	BigWigsEmphasizeAnchor_width = 300,
	interceptMouse = nil,
	onlyInterceptOnKeypress = nil,
	interceptKey = "CTRL",
	LeftButton = {
		report = true,
	},
	MiddleButton = {
		remove = true,
	},
	RightButton = {
		emphasize = true,
	},
}

do
	local clickOptions = {
		emphasize = {
			type = "toggle",
			name = colorize[L.superEmphasize],
			desc = L.tempEmphasize,
			descStyle = "inline",
			order = 1,
		},
		report = {
			type = "toggle",
			name = colorize[L.report],
			desc = L.reportDesc,
			descStyle = "inline",
			order = 2,
		},
		remove = {
			type = "toggle",
			name = colorize[L.remove],
			desc = L.removeDesc,
			descStyle = "inline",
			order = 3,
		},
		removeOther = {
			type = "toggle",
			name = colorize[L.removeOther],
			desc = L.removeOtherDesc,
			descStyle = "inline",
			order = 4,
		},
		disable = {
			type = "toggle",
			name = colorize[L.disable],
			desc = L.disableDesc,
			descStyle = "inline",
			order = 5,
		},
	}

	local function shouldDisable() return not plugin.db.profile.interceptMouse end
	plugin.pluginOptions = {
		type = "group",
		name = L.bars,
		childGroups = "tab",
		get = function(info)
			local key = info[#info]
			if key == "texture" then
				for i, v in next, media:List("statusbar") do
					if v == db.texture then return i end
				end
			elseif key == "font" then
				for i, v in next, media:List("font") do
					if v == db.font then return i end
				end
			end
			return db[key]
		end,
		set = function(info, value)
			local key = info[#info]
			if key == "texture" then
				local list = media:List("statusbar")
				db.texture = list[value]
			elseif key == "font" then
				local list = media:List("font")
				db.font = list[value]
			elseif key == "barStyle" then
				plugin:SetBarStyle(value)
			else
				db[key] = value
			end
			if BigWigsAnchor then
				BigWigsAnchor:RefixPosition()
				BigWigsEmphasizeAnchor:RefixPosition()
			end
		end,
		args = {
			custom = {
				type = "group",
				name = L.general,
				order = 1,
				args = {
					font = {
						type = "select",
						name = L.font,
						order = 1,
						values = media:List("font"),
						itemControl = "DDI-Font",
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
					},
					monochrome = {
						type = "toggle",
						name = L.monochrome,
						desc = L.monochromeDesc,
						order = 3,
					},
					fontSize = {
						type = "range",
						name = L.fontSize,
						width = "double",
						order = 4,
						max = 200, softMax = 72,
						min = 1,
						step = 1,
					},
					header1 = {
						type = "header",
						name = "",
						order = 5,
					},
					fill = {
						type = "toggle",
						name = L.fill,
						desc = L.fillDesc,
						order = 6,
						set = function(info, value)
							local key = info[#info]
							db[key] = value
							-- XXX broaden this to all options
							for k in next, normalAnchor.bars do
								k:SetFill(value)
							end
							for k in next, emphasizeAnchor.bars do
								k:SetFill(value)
							end
						end,
					},
					alignText = {
						type = "select",
						name = L.alignText,
						order = 7,
						values = {
							LEFT = L.left,
							CENTER = L.center,
							RIGHT = L.right,
						},
					},
					alignTime = {
						type = "select",
						name = L.alignTime,
						order = 8,
						values = {
							LEFT = L.left,
							CENTER = L.center,
							RIGHT = L.right,
						},
					},
					texture = {
						type = "select",
						name = L.texture,
						order = 9,
						values = media:List("statusbar"),
						itemControl = "DDI-Statusbar",
					},
					barStyle = {
						type = "select",
						name = L.style,
						order = 10,
						values = barStyleRegister,
					},
					header2 = {
						type = "header",
						name = "",
						order = 11,
					},
					icon = {
						type = "toggle",
						name = L.icon,
						desc = L.iconDesc,
						order = 12,
					},
					time = {
						type = "toggle",
						name = L.time,
						desc = L.timeDesc,
						order = 13,
					},
				},
			},
			normal = {
				type = "group",
				name = L.regularBars,
				order = 2,
				args = {
					growup = {
						type = "toggle",
						name = L.growingUpwards,
						desc = L.growingUpwardsDesc,
						order = 1,
					},
					scale = {
						type = "range",
						name = L.scale,
						min = 0.2,
						max = 2.0,
						step = 0.1,
						order = 2,
						width = "double",
					},
					exactPositioning = {
						type = "group",
						name = L.positionExact,
						order = 3,
						inline = true,
						args = {
							BigWigsAnchor_x = {
								type = "range",
								name = L.positionX,
								desc = L.positionDesc,
								min = 0,
								max = 2048,
								step = 1,
								order = 1,
								width = "full",
							},
							BigWigsAnchor_y = {
								type = "range",
								name = L.positionY,
								desc = L.positionDesc,
								min = 0,
								max = 2048,
								step = 1,
								order = 2,
								width = "full",
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
					emphasizeMove = {
						type = "toggle",
						name = L.move,
						desc = L.moveDesc,
						order = 2,
					},
					emphasizeRestart = {
						type = "toggle",
						name = L.restart,
						desc = L.restartDesc,
						order = 3,
					},
					emphasizeGrowup = {
						type = "toggle",
						name = L.growingUpwards,
						desc = L.growingUpwardsDesc,
						order = 4,
					},
					emphasizeTime = {
						type = "range",
						name = L.emphasizeAt,
						order = 5,
						min = 6,
						max = 20,
						step = 1,
					},
					emphasizeScale = {
						type = "range",
						name = L.scale,
						order = 6,
						min = 0.2,
						max = 2.0,
						step = 0.1,
					},
					exactPositioning = {
						type = "group",
						name = L.positionExact,
						order = 7,
						inline = true,
						args = {
							BigWigsEmphasizeAnchor_x = {
								type = "range",
								name = L.positionX,
								desc = L.positionDesc,
								min = 0,
								max = 2048,
								step = 1,
								order = 1,
								width = "full",
							},
							BigWigsEmphasizeAnchor_y = {
								type = "range",
								name = L.positionY,
								desc = L.positionDesc,
								min = 0,
								max = 2048,
								step = 1,
								order = 2,
								width = "full",
							},
						},
					},
				},
				order = 3,
			},
			clicking = {
				name = L.clickableBars,
				type = "group",
				order = 4,
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
							CTRL = CTRL_KEY_TEXT or "Ctrl",
							ALT = ALT_KEY or "Alt",
							SHIFT = SHIFT_KEY_TEXT or "Shift",
						},
						order = 4,
						disabled = function()
							return not plugin.db.profile.interceptMouse or not plugin.db.profile.onlyInterceptOnKeypress
						end,
					},
					left = {
						type = "group",
						name = KEY_BUTTON1 or "Left",
						order = 10,
						args = clickOptions,
						disabled = shouldDisable,
						get = function(info) return plugin.db.profile.LeftButton[info[#info]] end,
						set = function(info, value) plugin.db.profile.LeftButton[info[#info]] = value end,
					},
					middle = {
						type = "group",
						name = KEY_BUTTON3 or "Middle",
						order = 11,
						args = clickOptions,
						disabled = shouldDisable,
						get = function(info) return plugin.db.profile.MiddleButton[info[#info]] end,
						set = function(info, value) plugin.db.profile.MiddleButton[info[#info]] = value end,
					},
					right = {
						type = "group",
						name = KEY_BUTTON2 or "Right",
						order = 12,
						args = clickOptions,
						disabled = shouldDisable,
						get = function(info) return plugin.db.profile.RightButton[info[#info]] end,
						set = function(info, value) plugin.db.profile.RightButton[info[#info]] = value end,
					},
				},
			},
		},
	}
end

--------------------------------------------------------------------------------
-- Bar arrangement
--

local rearrangeBars
do
	local function barSorter(a, b)
		return a.remaining < b.remaining and true or false
	end
	local tmp = {}
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

		wipe(tmp)
		for bar in next, anchor.bars do
			tmp[#tmp + 1] = bar
		end
		table.sort(tmp, barSorter)
		local lastBar = nil
		local up = nil
		if anchor == normalAnchor then up = db.growup else up = db.emphasizeGrowup end
		for i = 1, #tmp do
			local bar = tmp[i]
			local spacing = currentBarStyler.GetSpacing(bar) or 0
			bar:ClearAllPoints()
			if up or (db.emphasizeGrowup and bar:Get("bigwigs:emphasized")) then
				if lastBar then -- Growing from a bar
					bar:SetPoint("BOTTOMLEFT", lastBar, "TOPLEFT", 0, spacing)
					bar:SetPoint("BOTTOMRIGHT", lastBar, "TOPRIGHT", 0, spacing)
				else -- Growing from the anchor
					bar:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT", 0, 0)
					bar:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", 0, 0)
				end
				lastBar = bar
			else
				if lastBar then -- Growing from a bar
					bar:SetPoint("TOPLEFT", lastBar, "BOTTOMLEFT", 0, -spacing)
					bar:SetPoint("TOPRIGHT", lastBar, "BOTTOMRIGHT", 0, -spacing)
				else -- Growing from the anchor
					bar:SetPoint("TOPLEFT", anchor, "TOPLEFT", 0, 0)
					bar:SetPoint("TOPRIGHT", anchor, "TOPRIGHT", 0, 0)
				end
				lastBar = bar
			end
		end
	end
end

local function barStopped(event, bar)
	local a = bar:Get("bigwigs:anchor")
	if a and a.bars and a.bars[bar] then
		currentBarStyler.BarStopped(bar)
		a.bars[bar] = nil
		rearrangeBars(a)
	end
end

local function findBar(module, key)
	for k in next, normalAnchor.bars do
		if k:Get("bigwigs:module") == module and k:Get("bigwigs:option") == key then
			return k
		end
	end
	for k in next, emphasizeAnchor.bars do
		if k:Get("bigwigs:module") == module and k:Get("bigwigs:option") == key then
			return k
		end
	end
end

--------------------------------------------------------------------------------
-- Anchors
--

local defaultPositions = {
	BigWigsAnchor = {"CENTER", "UIParent", "CENTER", 0, -120},
	BigWigsEmphasizeAnchor = {"TOP", RaidWarningFrame, "BOTTOM", 0, -35}, --Below the Blizzard "Raid Warning" frame
}

local function onDragHandleMouseDown(self) self:GetParent():StartSizing("BOTTOMRIGHT") end
local function onDragHandleMouseUp(self, button) self:GetParent():StopMovingOrSizing() end
local function onResize(self, width)
	db[self.w] = width
end
local function onDragStart(self) self:StartMoving() end
local function onDragStop(self)
	self:StopMovingOrSizing()
	local s = self:GetEffectiveScale()
	db[self.x] = self:GetLeft() * s
	db[self.y] = self:GetTop() * s
	plugin:UpdateGUI() -- Update X/Y if GUI is open.
end

local function createAnchor(frameName, title)
	local display = CreateFrame("Frame", frameName, UIParent)
	display.w, display.x, display.y = frameName .. "_width", frameName .. "_x", frameName .. "_y"
	display:EnableMouse(true)
	display:SetClampedToScreen(true)
	display:SetMovable(true)
	display:SetResizable(true)
	display:RegisterForDrag("LeftButton")
	display:SetHeight(20)
	display:SetMinResize(80, 20)
	display:SetMaxResize(1920, 20)
	display:SetFrameLevel(20)
	local bg = display:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints(display)
	bg:SetColorTexture(0, 0, 0, 0.3)
	display.background = bg
	local header = display:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	header:SetText(title)
	header:SetAllPoints(display)
	header:SetJustifyH("CENTER")
	header:SetJustifyV("MIDDLE")
	local drag = CreateFrame("Frame", nil, display)
	drag:SetFrameLevel(display:GetFrameLevel() + 10)
	drag:SetWidth(16)
	drag:SetHeight(16)
	drag:SetPoint("BOTTOMRIGHT", display, -1, 1)
	drag:EnableMouse(true)
	drag:SetScript("OnMouseDown", onDragHandleMouseDown)
	drag:SetScript("OnMouseUp", onDragHandleMouseUp)
	drag:SetAlpha(0.5)
	local tex = drag:CreateTexture(nil, "OVERLAY")
	tex:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\draghandle")
	tex:SetWidth(16)
	tex:SetHeight(16)
	tex:SetBlendMode("ADD")
	tex:SetPoint("CENTER", drag)
	display:SetScript("OnSizeChanged", onResize)
	display:SetScript("OnDragStart", onDragStart)
	display:SetScript("OnDragStop", onDragStop)
	display:SetScript("OnMouseUp", function(self, button)
		if button ~= "LeftButton" then return end
		plugin:SendMessage("BigWigs_SetConfigureTarget", plugin)
	end)
	display.bars = {}
	display.Reset = function(self)
		db[self.x] = nil
		db[self.y] = nil
		db[self.w] = nil
		self:RefixPosition()
	end
	display.RefixPosition = function(self)
		self:ClearAllPoints()
		if db[self.x] and db[self.y] then
			local s = self:GetEffectiveScale()
			self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", db[self.x] / s, db[self.y] / s)
		else
			self:SetPoint(unpack(defaultPositions[self:GetName()]))
		end
		self:SetWidth(db[self.w] or plugin.defaultDB[self.w])
	end
	display:RefixPosition()
	display:Hide()
	return display
end

local function createAnchors()
	normalAnchor = createAnchor("BigWigsAnchor", L.bars)
	emphasizeAnchor = createAnchor("BigWigsEmphasizeAnchor", L.emphasizedBars)

	createAnchors = nil
	createAnchor = nil
end

local function showAnchors()
	if createAnchors then createAnchors() end
	normalAnchor:Show()
	emphasizeAnchor:Show()
end

local function hideAnchors()
	normalAnchor:Hide()
	emphasizeAnchor:Hide()
end

local function resetAnchors()
	normalAnchor:Reset()
	emphasizeAnchor:Reset()
end

local function updateProfile()
	db = plugin.db.profile
	if not db.font then db.font = media:GetDefault("font") end
	if normalAnchor then
		normalAnchor:RefixPosition()
		emphasizeAnchor:RefixPosition()
	end
	if plugin:IsEnabled() then
		if not media:Fetch("statusbar", db.texture, true) then db.texture = "BantoBar" end
		plugin:SetBarStyle(db.barStyle)
		plugin:RegisterMessage("DBM_AddonMessage")
	end
	-- XXX temp cleanup [7.0]
	db.align = nil
end

--------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnRegister()
	media:Register("statusbar", "Otravi", "Interface\\AddOns\\BigWigs\\Textures\\otravi")
	media:Register("statusbar", "Smooth", "Interface\\AddOns\\BigWigs\\Textures\\smooth")
	media:Register("statusbar", "Glaze", "Interface\\AddOns\\BigWigs\\Textures\\glaze")
	media:Register("statusbar", "Charcoal", "Interface\\AddOns\\BigWigs\\Textures\\Charcoal")
	media:Register("statusbar", "BantoBar", "Interface\\AddOns\\BigWigs\\Textures\\default")
	candy.RegisterCallback(self, "LibCandyBar_Stop", barStopped)

	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()

	for k, v in next, barStyles do
		barStyleRegister[k] = v:GetStyleName()
	end
end

function plugin:OnPluginEnable()
	colors = BigWigs:GetPlugin("Colors")

	if not media:Fetch("statusbar", db.texture, true) then db.texture = "BantoBar" end
	if currentBarStyler and currentBarStyler.GetStyleName then
		for k, v in next, barStyleRegister do
			if currentBarStyler.GetStyleName() == v then
				self:SetBarStyle(k)
			end
		end
	else
		self:SetBarStyle(db.barStyle)
	end

	self:RegisterMessage("BigWigs_StartBar")
	self:RegisterMessage("BigWigs_PauseBar", "PauseBar")
	self:RegisterMessage("BigWigs_ResumeBar", "ResumeBar")
	self:RegisterMessage("BigWigs_StopBar", "StopSpecificBar")
	self:RegisterMessage("BigWigs_StopBars", "StopModuleBars")
	self:RegisterMessage("BigWigs_OnBossDisable", "StopModuleBars")
	self:RegisterMessage("BigWigs_OnBossReboot", "StopModuleBars")
	self:RegisterMessage("BigWigs_OnPluginDisable", "StopModuleBars")
	self:RegisterMessage("BigWigs_StartConfigureMode", showAnchors)
	self:RegisterMessage("BigWigs_SetConfigureTarget")
	self:RegisterMessage("BigWigs_StopConfigureMode", hideAnchors)
	self:RegisterMessage("BigWigs_ResetPositions", resetAnchors)
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)

	self:RefixClickIntercepts()
	self:RegisterEvent("MODIFIER_STATE_CHANGED", "RefixClickIntercepts")

	-- custom bars
	self:RegisterMessage("BigWigs_PluginComm")
	self:RegisterMessage("DBM_AddonMessage")

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

function plugin:BigWigs_SetConfigureTarget(event, module)
	if module == self then
		normalAnchor.background:SetColorTexture(0.2, 1, 0.2, 0.3)
		emphasizeAnchor.background:SetColorTexture(0.2, 1, 0.2, 0.3)
	else
		normalAnchor.background:SetColorTexture(0, 0, 0, 0.3)
		emphasizeAnchor.background:SetColorTexture(0, 0, 0, 0.3)
	end
end

--------------------------------------------------------------------------------
-- Bar styles API
--

do
	local currentAPIVersion = 1
	local errorWrongAPI = "The bar style API version is now %d; the bar style %q needs to be updated for this version of BigWigs."
	local errorMismatchedData = "The given style data does not seem to be a BigWigs bar styler."
	local errorAlreadyExist = "Trying to register %q as a bar styler, but it already exists."
	function plugin:RegisterBarStyle(key, styleData)
		if type(key) ~= "string" then error(errorMismatchedData) end
		if type(styleData) ~= "table" then error(errorMismatchedData) end
		if type(styleData.version) ~= "number" then error(errorMismatchedData) end
		if type(styleData.apiVersion) ~= "number" then error(errorMismatchedData) end
		if type(styleData.GetStyleName) ~= "function" then error(errorMismatchedData) end
		if styleData.apiVersion ~= currentAPIVersion then error(errorWrongAPI:format(currentAPIVersion, key)) end
		if barStyles[key] and barStyles[key].version == styleData.version then error(errorAlreadyExist:format(key)) end
		if not barStyles[key] or barStyles[key].version < styleData.version then
			barStyles[key] = styleData
			barStyleRegister[key] = styleData:GetStyleName()
		end
	end
end

do
	local errorNoStyle = "BigWigs: No style with the ID %q has been registered. Reverting to default style."
	local function noop() end
	function plugin:SetBarStyle(style)
		if type(style) ~= "string" or not barStyles[style] then
			print(errorNoStyle:format(tostring(style)))
			style = "Default"
		end
		local newBarStyler = barStyles[style]
		if not newBarStyler.ApplyStyle then newBarStyler.ApplyStyle = noop end
		if not newBarStyler.BarStopped then newBarStyler.BarStopped = noop end
		if not newBarStyler.GetSpacing then newBarStyler.GetSpacing = noop end

		-- Iterate all running bars
		if currentBarStyler then
			if normalAnchor then
				for bar in next, normalAnchor.bars do
					currentBarStyler.BarStopped(bar)
					bar.candyBarBackdrop:Hide()
					newBarStyler.ApplyStyle(bar)
				end
			end
			if emphasizeAnchor then
				for bar in next, emphasizeAnchor.bars do
					currentBarStyler.BarStopped(bar)
					bar.candyBarBackdrop:Hide()
					newBarStyler.ApplyStyle(bar)
				end
			end
		end
		currentBarStyler = newBarStyler

		rearrangeBars(normalAnchor)
		rearrangeBars(emphasizeAnchor)

		if db then
			db.barStyle = style
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
end

--------------------------------------------------------------------------------
-- Bar utility functions
--

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

--------------------------------------------------------------------------------
-- Clickable bars
--

local function barClicked(bar, button)
	for action, enabled in next, plugin.db.profile[button] do
		if enabled then clickHandlers[action](bar) end
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
		refixClickOnBar(intercept, bar)
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

-- Super Emphasize the clicked bar
clickHandlers.emphasize = function(bar)
	-- Add 0.2sec here to catch messages for this option triggered when the bar ends.
	plugin:SendMessage("BigWigs_TempSuperEmphasize", bar:Get("bigwigs:module"), bar:Get("bigwigs:option"), bar:GetLabel(), bar.remaining)
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
	local anchor = bar:Get("bigwigs:anchor")
	plugin:SendMessage("BigWigs_SilenceOption", bar:Get("bigwigs:option"), bar.remaining + 0.3)
	bar:Stop()
end

-- Removes all bars EXCEPT the clicked one
clickHandlers.removeOther = function(bar)
	if normalAnchor then
		for k in next, normalAnchor.bars do
			if k ~= bar then
				plugin:SendMessage("BigWigs_SilenceOption", k:Get("bigwigs:option"), k.remaining + 0.3)
				k:Stop()
			end
		end
	end
	if emphasizeAnchor then
		for k in next, emphasizeAnchor.bars do
			if k ~= bar then
				plugin:SendMessage("BigWigs_SilenceOption", k:Get("bigwigs:option"), k.remaining + 0.3)
				k:Stop()
			end
		end
	end
end

-- Disables the option that launched this bar
clickHandlers.disable = function(bar)
	local m = bar:Get("bigwigs:module")
	if m and m.db and m.db.profile and bar:Get("bigwigs:option") then
		m.db.profile[bar:Get("bigwigs:option")] = 0
	end
end

-----------------------------------------------------------------------
-- Start bars
--

function plugin:BigWigs_StartBar(_, module, key, text, time, icon, isApprox)
	if createAnchors then createAnchors() end
	if not text then text = "" end
	self:StopSpecificBar(nil, module, text)
	local bar = candy:New(media:Fetch("statusbar", db.texture), 200, 14)
	bar.candyBarBackground:SetVertexColor(colors:GetColor("barBackground", module, key))
	bar:Set("bigwigs:module", module)
	bar:Set("bigwigs:anchor", normalAnchor)
	bar:Set("bigwigs:option", key)
	bar:SetColor(colors:GetColor("barColor", module, key))
	bar:SetTextColor(colors:GetColor("barText", module, key))
	bar:SetShadowColor(colors:GetColor("barTextShadow", module, key))
	bar.candyBarLabel:SetJustifyH(db.alignText)
	bar.candyBarDuration:SetJustifyH(db.alignTime)
	normalAnchor.bars[bar] = true

	local flags = nil
	if db.monochrome and db.outline ~= "NONE" then
		flags = "MONOCHROME," .. db.outline
	elseif db.monochrome then
		flags = "MONOCHROME"
	elseif db.outline ~= "NONE" then
		flags = db.outline
	end
	local f = media:Fetch("font", db.font)
	bar.candyBarLabel:SetFont(f, db.fontSize, flags)
	bar.candyBarDuration:SetFont(f, db.fontSize, flags)

	bar:SetLabel(text)
	bar:SetDuration(time, isApprox)
	bar:SetTimeVisibility(db.time)
	bar:SetIcon(db.icon and icon or nil)
	bar:SetScale(db.scale)
	bar:SetFill(db.fill)
	if db.interceptMouse and not db.onlyInterceptOnKeypress then
		refixClickOnBar(true, bar)
	end
	currentBarStyler.ApplyStyle(bar)

	if db.emphasize and time < db.emphasizeTime then
		self:EmphasizeBar(bar, true)
	else
		bar:Start() -- Don't fire :Start twice when emphasizeRestart is on
	end
	rearrangeBars(bar:Get("bigwigs:anchor"))

	self:SendMessage("BigWigs_BarCreated", self, bar, module, key, text, time, icon, isApprox)
	-- Check if :EmphasizeBar(bar) was run and trigger the callback.
	-- Bit of a roundabout method to approaching this so that we purposely keep callbacks firing last.
	if bar:Get("bigwigs:emphasized") then
		self:SendMessage("BigWigs_BarEmphasized", self, bar)
	end
end

--------------------------------------------------------------------------------
-- Emphasize
--

do
	local dirty = nil
	empUpdate = CreateFrame("Frame"):CreateAnimationGroup()
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

function plugin:EmphasizeBar(bar, start)
	if db.emphasizeMove then
		normalAnchor.bars[bar] = nil
		emphasizeAnchor.bars[bar] = true
		bar:Set("bigwigs:anchor", emphasizeAnchor)
	end
	if start or db.emphasizeRestart then
		bar:Start() -- restart the bar -> remaining time is a full length bar again after moving it to the emphasize anchor
	end
	local module = bar:Get("bigwigs:module")
	local key = bar:Get("bigwigs:option")
	bar:SetColor(colors:GetColor("barEmphasized", module, key))
	bar:SetScale(db.emphasizeScale)
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
			timers[id] = plugin:ScheduleTimer("SendMessage", seconds, "BigWigs_Message", plugin, false, L.timerFinished:format(nick, barText), "Attention", "Interface\\Icons\\INV_Misc_PocketWatch_01")
			plugin:SendMessage("BigWigs_StartBar", plugin, id, nick..": "..barText, seconds, "Interface\\Icons\\INV_Misc_PocketWatch_01")
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

		timerTbl = {
			plugin:ScheduleTimer("SendMessage", seconds - 30, "BigWigs_Message", plugin, nil, L.breakSeconds:format(30), "Urgent", "Interface\\Icons\\inv_misc_fork&knife"),
			plugin:ScheduleTimer("SendMessage", seconds - 10, "BigWigs_Message", plugin, nil, L.breakSeconds:format(10), "Urgent", "Interface\\Icons\\inv_misc_fork&knife"),
			plugin:ScheduleTimer("SendMessage", seconds - 5, "BigWigs_Message", plugin, nil, L.breakSeconds:format(5), "Important", "Interface\\Icons\\inv_misc_fork&knife"),
			plugin:ScheduleTimer("SendMessage", seconds, "BigWigs_Message", plugin, nil, L.breakFinished, "Important", "Interface\\Icons\\inv_misc_fork&knife"),
			plugin:ScheduleTimer("SendMessage", seconds, "BigWigs_Sound", plugin, nil, "Long"),
			plugin:ScheduleTimer(function() BigWigs3DB.breakTime = nil timerTbl = nil end, seconds)
		}
		if seconds > 119 then -- 2min
			timerTbl[#timerTbl+1] = plugin:ScheduleTimer("SendMessage", seconds - 60, "BigWigs_Message", plugin, nil, L.breakMinutes:format(1), "Positive", "Interface\\Icons\\inv_misc_fork&knife")
		end
		if seconds > 239 then -- 4min
			local half = seconds / 2
			local m = half % 60
			local halfMin = (half - m) / 60
			timerTbl[#timerTbl+1] = plugin:ScheduleTimer("SendMessage", half + m, "BigWigs_Message", plugin, nil, L.breakMinutes:format(halfMin), "Positive", "Interface\\Icons\\inv_misc_fork&knife")
		end

		plugin:SendMessage("BigWigs_Message", plugin, nil, L.breakMinutes:format(seconds/60), "Attention", "Interface\\Icons\\inv_misc_fork&knife")
		plugin:SendMessage("BigWigs_Sound", plugin, nil, "Long")
		plugin:SendMessage("BigWigs_StartBar", plugin, nil, L.breakBar, seconds, "Interface\\Icons\\inv_misc_fork&knife")
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
