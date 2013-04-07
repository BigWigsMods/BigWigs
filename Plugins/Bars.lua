
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

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")

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
		bgFile = [[Interface\Buttons\WHITE8x8]],
		insets = {top = 1, left = 1, bottom = 1, right = 1},
	}

	local function createBackgroundbc()
		local bgbc = CreateFrame("Frame")
		bgbc:SetBackdrop(backdropbc)
		bgbc:SetBackdropColor(.1, .1, .1, 1)
		bgbc:SetWidth(10)
		bgbc:SetHeight(10)
		return bgbc
	end

	local function createBorder(self)
		local border = UIParent:CreateTexture(nil, "OVERLAY")
		border:SetParent(self)
		border:SetTexture(textureNormal)
		border:SetWidth(12)
		border:SetHeight(12)
		border:SetVertexColor(1, 1, 1)
		return border
	end

	local freeBackgroundsbc = {}
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

		local bgbc = bar:Get("bigwigs:beautycase:bgbc")
		if bgbc then
			bgbc:SetParent(UIParent)
			bgbc:Hide()
			freeBackgroundsbc[#freeBackgroundsbc + 1] = bgbc
		end
	end

	local function styleBar(bar)
		local bgbc = nil
		if #freeBackgroundsbc > 0 then
			bgbc = tremove(freeBackgroundsbc)
		else
			bgbc = createBackgroundbc()
		end
		bgbc:SetParent(bar)
		bgbc:ClearAllPoints()
		bgbc:SetPoint("TOPLEFT", bar, "TOPLEFT", -1, 1)
		bgbc:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 1, -1)
		bgbc:SetFrameStrata("LOW")
		bgbc:Show()
		bar:Set("bigwigs:beautycase:bgbc", bgbc)

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
	-- TukUI Bar Styler

	local freeBackgrounds = {}

	local backdrop = {
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		tile = false, tileSize = 0, edgeSize = 0.64,
		insets = { left = -0.64, right = -0.64, top = -0.64, bottom = -0.64}
	}

	local function createBackground()
		local bg = CreateFrame("Frame")
		bg:SetBackdrop(backdrop)
		if IsAddOnLoaded("Tukui") then
			local F, C, L = unpack(Tukui) -- tukui support :)
			bg:SetBackdropColor(unpack(C["media"].backdropcolor))
			bg:SetBackdropBorderColor(unpack(C["media"].bordercolor))
		else
			bg:SetBackdropColor(.1,.1,.1,1)
			bg:SetBackdropBorderColor(.6,.6,.6,1)
		end
		return bg
	end

	local function freeStyle(bar)
		local bg = bar:Get("bigwigs:tukui:bg")
		if not bg then return end
		bg:SetParent(UIParent)
		bg:Hide()
		freeBackgrounds[#freeBackgrounds + 1] = bg
	end

	local function styleBar(bar)
		local bg = nil
		if #freeBackgrounds > 0 then
			bg = tremove(freeBackgrounds)
		else
			bg = createBackground()
		end
		bg:SetParent(bar)
		bg:ClearAllPoints()
		bg:SetPoint("TOPLEFT", bar, "TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 1, -1)
		bg:SetFrameStrata("BACKGROUND")
		bg:Show()
		bar:Set("bigwigs:tukui:bg", bg)
	end

	barStyles.TukUI = {
		apiVersion = 1,
		version = 1,
		GetSpacing = function(bar) return 4 end,
		ApplyStyle = styleBar,
		BarStopped = freeStyle,
		GetStyleName = function() return "TukUI" end,
	}
end

do
	-- MonoUI
	local buttonSize, backdropBorder = 15, {
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
		tile = false, tileSize = 0, edgeSize = 1,
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	}

	local backdropCache, iconCache = {}, {}

	local createbg = function()
		local f = CreateFrame("Frame")
		f:SetBackdrop(backdropBorder)
		f:SetBackdropColor(.1,.1,.1,1)
		f:SetBackdropBorderColor(0,0,0,1)
		return f
	end

	local function removeStyle(bar)
		bar:SetHeight(14)

		local bg = bar:Get("bigwigs:MonoUI:backdrop")
		if bg then
			bg:ClearAllPoints()
			bg:SetParent("UIParent")
			bg:Hide()
			backdropCache[#backdropCache + 1] = bg
		end

		local icon = bar:Get("bigwigs:MonoUI:icon")
		if icon then
			icon:ClearAllPoints()
			icon:SetParent("UIParent")
			icon:Hide()
			iconCache[#iconCache + 1] = icon
		end

		bar.candyBarDuration:ClearAllPoints()
		bar.candyBarDuration:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)

		bar.candyBarLabel:ClearAllPoints()
		bar.candyBarLabel:SetPoint("LEFT", bar.candyBarBar, "LEFT", 2, 0)
		bar.candyBarLabel:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 0)
	end

	local function styleBar(bar)
		bar:SetHeight(buttonSize/2.5)

		local bg = nil
		if #backdropCache > 0 then
			bg = tremove(backdropCache)
		else
			bg = createbg()
		end

		bg:SetParent(bar)
		bg:ClearAllPoints()
		bg:SetPoint("TOPLEFT", bar, "TOPLEFT", -2, 2)
		bg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 2, -2)
		bg:SetFrameStrata("BACKGROUND")
		bg:Show()
		bar:Set("bigwigs:MonoUI:backdrop", bg)

		if plugin.db.profile.icon then
			local icon = nil
			local tex = bar.candyBarIconFrame.icon
			bar:SetIcon(nil)
			if #iconCache > 0 then
				icon = tremove(iconCache)
			else
				icon = createbg()
				icon:SetSize(buttonSize+4, buttonSize+4)
				icon:SetFrameStrata("BACKGROUND")
				icon.iconTex = icon:CreateTexture(nil, "LOW")
				icon.iconTex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
				icon.iconTex:SetPoint("CENTER")
				icon.iconTex:SetSize(buttonSize, buttonSize)
			end
			icon.iconTex:SetTexture(tex)
			icon:SetParent(bar)
			icon:ClearAllPoints()
			icon:Show()
			icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -3, -2)
			bar:Set("bigwigs:MonoUI:icon", icon)
		end

		bar.candyBarLabel:SetJustifyH("LEFT")
		bar.candyBarLabel:ClearAllPoints()
		bar.candyBarLabel:SetPoint("LEFT", bar, "LEFT", 4, buttonSize/1.5)

		bar.candyBarDuration:SetJustifyH("RIGHT")
		bar.candyBarDuration:ClearAllPoints()
		bar.candyBarDuration:SetPoint("RIGHT", bar, "RIGHT", -4, buttonSize/1.5)

		bar:SetTexture(media:Fetch("statusbar", "Blizzard"))
	end

	barStyles.MonoUI = {
		apiVersion = 1,
		version = 2,
		GetSpacing = function(bar) return buttonSize end,
		ApplyStyle = styleBar,
		BarStopped = removeStyle,
		GetStyleName = function() return "MonoUI" end,
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
	outline = "NONE",
	growup = true,
	time = true,
	align = "LEFT",
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

local clickOptions = {
	emphasize = {
		type = "toggle",
		name = colorize[L["Super Emphasize"]],
		desc = L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."],
		descStyle = "inline",
		order = 1,
	},
	report = {
		type = "toggle",
		name = colorize[L["Report"]],
		desc = L["Reports the current bars status to the active group chat; either instance chat, raid, party or say, as appropriate."],
		descStyle = "inline",
		order = 2,
	},
	remove = {
		type = "toggle",
		name = colorize[L["Remove"]],
		desc = L["Temporarily removes the bar and all associated messages."],
		descStyle = "inline",
		order = 3,
	},
	removeOther = {
		type = "toggle",
		name = colorize[L["Remove other"]],
		desc = L["Temporarily removes all other bars (except this one) and associated messages."],
		descStyle = "inline",
		order = 4,
	},
	disable = {
		type = "toggle",
		name = colorize[L["Disable"]],
		desc = L["Permanently disables the boss encounter ability option that spawned this bar."],
		descStyle = "inline",
		order = 5,
	},
}

local function shouldDisable() return not plugin.db.profile.interceptMouse end

plugin.subPanelOptions = {
	key = "Big Wigs: Clickable Bars",
	name = L["Clickable Bars"],
	options = {
		name = L["Clickable Bars"],
		type = "group",
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
				name = L["Enable"],
				desc = L["Enables bars to receive mouse clicks."],
				order = 2,
				width = "full",
			},
			onlyInterceptOnKeypress = {
				type = "toggle",
				name = L["Only with modifier key"],
				desc = L["Allows bars to be click-through unless the specified modifier key is held down, at which point the mouse actions described below will be available."],
				order = 3,
				disabled = shouldDisable,
			},
			interceptKey = {
				type = "select",
				name = L["Modifier"],
				desc = L["Hold down the selected modifier key to enable click actions on the timer bars."],
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
}

do
	local pluginOptions = nil
	function plugin:GetPluginConfig()
		if not pluginOptions then
			pluginOptions = {
				type = "group",
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
				end,
				args = {
					font = {
						type = "select",
						name = L["Font"],
						order = 1,
						values = media:List("font"),
						--width = "full",
						itemControl = "DDI-Font",
					},
					outline = {
						type = "select",
						name = L["Outline"],
						order = 2,
						values = {
							NONE = L["None"],
							OUTLINE = L["Thin"],
							THICKOUTLINE = L["Thick"],
						},
						--width = "full",
					},
					fontSize = {
						type = "range",
						name = L["Font size"],
						order = 3,
						max = 40,
						min = 6,
						step = 1,
						width = "full",
					},
					texture = {
						type = "select",
						name = L["Texture"],
						order = 4,
						values = media:List("statusbar"),
						--width = "full",
						itemControl = "DDI-Statusbar",
					},
					barStyle = {
						type = "select",
						name = L["Style"],
						order = 5,
						values = barStyleRegister,
						--width = "full",
					},
					align = {
						type = "select",
						name = L["Align"],
						values = {
							LEFT = L["Left"],
							CENTER = L["Center"],
							RIGHT = L["Right"],
						},
						style = "radio",
						width = "half",
						order = 6,
					},
					icon = {
						type = "toggle",
						name = L["Icon"],
						desc = L["Shows or hides the bar icons."],
						order = 7,
						width = "half",
					},
					time = {
						type = "toggle",
						name = L["Time"],
						desc = L["Whether to show or hide the time left on the bars."],
						order = 8,
						width = "half",
					},
					fill = {
						type = "toggle",
						name = L["Fill"],
						desc = L["Fills the bars up instead of draining them."],
						order = 9,
						width = "half",
					},
					normal = {
						type = "group",
						name = L["Regular bars"],
						inline = true,
						width = "full",
						args = {
							growup = {
								type = "toggle",
								name = L["Grow upwards"],
								desc = L["Toggle bars grow upwards/downwards from anchor."],
								order = 1,
							},
							scale = {
								type = "range",
								name = L["Scale"],
								min = 0.2,
								max = 2.0,
								step = 0.1,
								order = 2,
								width = "full",
							},
						},
						order = 10,
					},
					emphasize = {
						type = "group",
						name = L["Emphasized bars"],
						inline = true,
						width = "full",
						args = {
							emphasize = {
								type = "toggle",
								name = L["Enable"],
								order = 1,
								width = "half",
							},
							emphasizeMove = {
								type = "toggle",
								name = L["Move"],
								desc = L.moveDesc,
								order = 2,
								width = "half",
							},
							emphasizeRestart = {
								type = "toggle",
								name = L["Restart"],
								desc = L["Restarts emphasized bars so they start from the beginning and count from 10."],
								order = 3,
								width = "half",
								disabled = function() return not db.emphasizeMove end,
							},
							emphasizeGrowup = {
								type = "toggle",
								name = L["Grow upwards"],
								desc = L["Toggle bars grow upwards/downwards from anchor."],
								order = 4,
							},
							emphasizeTime = {
								type = "range",
								name = L["Emphasize at... (seconds)"],
								order = 5,
								min = 6,
								max = 20,
								step = 1,
								width = "full",
							},
							emphasizeScale = {
								type = "range",
								name = L["Scale"],
								order = 6,
								min = 0.2,
								max = 2.0,
								step = 0.1,
								width = "full",
							},
						},
						order = 11,
					},
				},
			}
		end
		return pluginOptions
	end
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
		local lastDownBar, lastUpBar = nil, nil
		local up = nil
		if anchor == normalAnchor then up = db.growup else up = db.emphasizeGrowup end
		for i, bar in next, tmp do
			local spacing = currentBarStyler.GetSpacing(bar) or 0
			bar:ClearAllPoints()
			if up or (db.emphasizeGrowup and bar:Get("bigwigs:emphasized")) then
				bar:SetPoint("BOTTOMLEFT", lastUpBar or anchor, "TOPLEFT", 0, spacing)
				bar:SetPoint("BOTTOMRIGHT", lastUpBar or anchor, "TOPRIGHT", 0, spacing)
				lastUpBar = bar
			else
				bar:SetPoint("TOPLEFT", lastDownBar or anchor, "BOTTOMLEFT", 0, -spacing)
				bar:SetPoint("TOPRIGHT", lastDownBar or anchor, "BOTTOMRIGHT", 0, -spacing)
				lastDownBar = bar
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
	BigWigsEmphasizeAnchor = {"TOP", RaidWarningFrame, "BOTTOM", 0, -35}, --Below the default BigWigs message frame
}

local function onDragHandleMouseDown(self) self:GetParent():StartSizing("BOTTOMRIGHT") end
local function onDragHandleMouseUp(self, button) self:GetParent():StopMovingOrSizing() end
local function onResize(self, width)
	db[self.w] = width
	rearrangeBars(self)
end
local function onDragStart(self) self:StartMoving() end
local function onDragStop(self)
	self:StopMovingOrSizing()
	local s = self:GetEffectiveScale()
	db[self.x] = self:GetLeft() * s
	db[self.y] = self:GetTop() * s
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
	local bg = display:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints(display)
	bg:SetBlendMode("BLEND")
	bg:SetTexture(0, 0, 0, 0.3)
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
	normalAnchor = createAnchor("BigWigsAnchor", L["Bars"])
	emphasizeAnchor = createAnchor("BigWigsEmphasizeAnchor", L["Emphasized bars"])

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
	if normalAnchor then
		normalAnchor:RefixPosition()
		emphasizeAnchor:RefixPosition()
	end
	if not db.font then db.font = media:GetDefault("font") end
	if plugin:IsEnabled() then
		if not media:Fetch("statusbar", db.texture, true) then db.texture = "BantoBar" end
		plugin:SetBarStyle(db.barStyle)
		if BigWigs.db.profile.customDBMbars then
			RegisterAddonMessagePrefix("D4")
			plugin:RegisterMessage("DBM_AddonMessage", "OnDBMSync")
		end
	end
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

	self:RegisterMessage("BigWigs_StartBar")
	self:RegisterMessage("BigWigs_StopBar", "StopSpecificBar")
	self:RegisterMessage("BigWigs_StopBars", "StopModuleBars")
	self:RegisterMessage("BigWigs_OnBossDisable", "StopModuleBars")
	self:RegisterMessage("BigWigs_OnPluginDisable", "StopModuleBars")
	self:RegisterMessage("BigWigs_StartConfigureMode", showAnchors)
	self:RegisterMessage("BigWigs_SetConfigureTarget")
	self:RegisterMessage("BigWigs_StopConfigureMode", hideAnchors)
	self:RegisterMessage("BigWigs_ResetPositions", resetAnchors)
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)

	self:RefixClickIntercepts()
	self:RegisterEvent("MODIFIER_STATE_CHANGED", "RefixClickIntercepts")

	-- custom bars
	BigWigs:AddSyncListener(self, "BWCustomBar")
	BigWigs:AddSyncListener(self, "BWPull")
	if BigWigs.db.profile.customDBMbars then
		RegisterAddonMessagePrefix("D4")
		self:RegisterMessage("DBM_AddonMessage", "OnDBMSync")
	end

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
end

function plugin:BigWigs_SetConfigureTarget(event, module)
	if module == self then
		normalAnchor.background:SetTexture(0.2, 1, 0.2, 0.3)
		emphasizeAnchor.background:SetTexture(0.2, 1, 0.2, 0.3)
	else
		normalAnchor.background:SetTexture(0, 0, 0, 0.3)
		emphasizeAnchor.background:SetTexture(0, 0, 0, 0.3)
	end
end

--------------------------------------------------------------------------------
-- Bar styles API
--

do
	local currentAPIVersion = 1
	local errorWrongAPI = "The bar style API version is now %d; the bar style %q needs to be updated for this version of Big Wigs."
	local errorMismatchedData = "The given style data does not seem to be a Big Wigs bar styler."
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
	local errorNoStyle = "Big Wigs: No style with the ID %q has been registered. Reverting to default style."
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
					newBarStyler.ApplyStyle(bar)
				end
			end
			if emphasizeAnchor then
				for bar in next, emphasizeAnchor.bars do
					currentBarStyler.BarStopped(bar)
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
-- Stopping bars
--

function plugin:StopSpecificBar(_, module, text)
	if not normalAnchor then return end
	local dirty = nil
	for k in next, normalAnchor.bars do
		if k:Get("bigwigs:module") == module and k.candyBarLabel:GetText() == text then
			k:Stop()
			dirty = true
		end
	end
	if dirty then rearrangeBars(normalAnchor) dirty = nil end
	for k in next, emphasizeAnchor.bars do
		if k:Get("bigwigs:module") == module and k.candyBarLabel:GetText() == text then
			k:Stop()
			dirty = true
		end
	end
	if dirty then rearrangeBars(emphasizeAnchor) end
end

function plugin:StopModuleBars(_, module)
	if not normalAnchor then return end
	local dirty = nil
	for k in next, normalAnchor.bars do
		if k:Get("bigwigs:module") == module then
			k:Stop()
			dirty = true
		end
	end
	if dirty then rearrangeBars(normalAnchor) dirty = nil end
	for k in next, emphasizeAnchor.bars do
		if k:Get("bigwigs:module") == module then
			k:Stop()
			dirty = true
		end
	end
	if dirty then rearrangeBars(emphasizeAnchor) end
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
	bar.candyBarLabel:SetJustifyH(db.align == "CENTER" and "LEFT" or "CENTER")
	bar.candyBarBackground:SetVertexColor(1, 1, 1, 0.8)
end
local function barOnLeave(bar)
	bar.candyBarLabel:SetJustifyH(db.align)
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
	plugin:SendMessage("BigWigs_TempSuperEmphasize", bar:Get("bigwigs:module"), bar:Get("bigwigs:option"), bar.candyBarLabel:GetText(), bar.remaining)
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
	clickHandlers.report = function(bar)
		local text = ("%s: %s"):format(bar.candyBarLabel:GetText(), timeDetails(bar.remaining))
		SendChatMessage(text, (IsPartyLFG() and "INSTANCE_CHAT") or (IsInRaid() and "RAID") or (IsInGroup() and "PARTY") or "SAY")
	end
end

-- Removes the clicked bar
clickHandlers.remove = function(bar)
	local anchor = bar:Get("bigwigs:anchor")
	plugin:SendMessage("BigWigs_SilenceOption", bar:Get("bigwigs:option"), bar.remaining + 0.3)
	bar:Stop()
	rearrangeBars(anchor)
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
		rearrangeBars(normalAnchor)
	end
	if emphasizeAnchor then
		for k in next, emphasizeAnchor.bars do
			if k ~= bar then
				plugin:SendMessage("BigWigs_SilenceOption", k:Get("bigwigs:option"), k.remaining + 0.3)
				k:Stop()
			end
		end
		rearrangeBars(emphasizeAnchor)
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
	normalAnchor.bars[bar] = true
	bar.candyBarBackground:SetVertexColor(colors:GetColor("barBackground", module, key))
	bar:Set("bigwigs:module", module)
	bar:Set("bigwigs:anchor", normalAnchor)
	bar:Set("bigwigs:option", key)
	bar:SetColor(colors:GetColor("barColor", module, key))
	bar.candyBarLabel:SetTextColor(colors:GetColor("barText", module, key))
	bar.candyBarDuration:SetTextColor(colors:GetColor("barText", module, key))
	bar.candyBarLabel:SetShadowColor(colors:GetColor("barTextShadow", module, key))
	bar.candyBarDuration:SetShadowColor(colors:GetColor("barTextShadow", module, key))
	bar.candyBarLabel:SetJustifyH(db.align)
	local f = media:Fetch("font", db.font)
	bar.candyBarLabel:SetFont(f, db.fontSize, db.outline ~= "NONE" and db.outline)
	bar.candyBarDuration:SetFont(f, db.fontSize, db.outline ~= "NONE" and db.outline)
	bar:SetLabel(text)
	bar:SetClampedToScreen(true)
	bar:SetDuration(time, isApprox)
	bar:SetTimeVisibility(db.time)
	bar:SetIcon(db.icon and icon or nil)
	bar:SetScale(db.scale)
	bar:SetFill(db.fill)
	if db.emphasize and time < db.emphasizeTime then
		self:EmphasizeBar(bar)
	end
	if db.interceptMouse and not db.onlyInterceptOnKeypress then
		refixClickOnBar(true, bar)
	end
	currentBarStyler.ApplyStyle(bar)
	bar:Start()
	rearrangeBars(bar:Get("bigwigs:anchor"))
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
				plugin:EmphasizeBar(k)
				dirty = true
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

function plugin:EmphasizeBar(bar)
	if db.emphasizeMove then
		normalAnchor.bars[bar] = nil
		emphasizeAnchor.bars[bar] = true
		bar:Set("bigwigs:anchor", emphasizeAnchor)
		if db.emphasizeRestart then
			bar:Start() -- restart the bar -> remaining time is a full length bar again after moving it to the emphasize anchor
		end
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
	local timers = {}
	local prevBar, prevTime = "", 0
	function startCustomBar(bar, nick, localOnly, isDBM)
		local time, barText
		if localOnly then
			time, barText, nick = bar, localOnly, L["Local"]
		else
			if bar == prevBar and GetTime() - prevTime < 1 then return end -- Throttle
			prevBar, prevTime = bar, GetTime()
			if not UnitIsGroupLeader(nick) and not UnitIsGroupAssistant(nick) then return end
			time, barText = bar:match("(%S+) (.*)")
			time = parseTime(time)
			if type(time) ~= "number" or type(barText) ~= "string" or time < 0 then
				return
			end
			BigWigs:Print(L["Custom bar '%s' started by %s user '%s'."]:format(barText, isDBM and "DBM" or "Big Wigs", nick))
		end

		local id = "bwcb" .. nick .. barText
		if timers[id] then
			plugin:CancelTimer(timers[id])
			timers[id] = nil
		end

		nick = nick:gsub("%-.+", "*") -- Remove server name
		if time == 0 then
			plugin:SendMessage("BigWigs_StopBar", plugin, nick..": "..barText)
		else
			timers[id] = plugin:ScheduleTimer("SendMessage", time, "BigWigs_Message", false, false, L["%s: Timer [%s] finished."]:format(nick, barText), "Attention", false, "Interface\\Icons\\INV_Misc_PocketWatch_01")
			plugin:SendMessage("BigWigs_StartBar", plugin, id, nick..": "..barText, time, "Interface\\Icons\\INV_Misc_PocketWatch_01")
		end
	end
end

local startPull
do
	local timer, timeLeft = nil, 0
	local function printPull()
		timeLeft = timeLeft - 1
		if timeLeft == 0 then
			plugin:CancelTimer(timer)
			timer = nil
			plugin:SendMessage("BigWigs_Message", nil, nil, L["Pulling!"], "Attention", "Alarm", "Interface\\Icons\\ability_warrior_charge")
		elseif timeLeft < 11 then
			plugin:SendMessage("BigWigs_Message", nil, nil, L["Pull in %d sec"]:format(timeLeft), "Attention")
			if timeLeft < 6 and BigWigs.db.profile.sound then
				PlaySoundFile(("Interface\\AddOns\\BigWigs\\Sounds\\%d.mp3"):format(timeLeft), "Master")
			end
		end
	end
	function startPull(time, nick, isDBM)
		if not UnitIsGroupLeader(nick) and not UnitIsGroupAssistant(nick) then return end
		time = tonumber(time)
		if not time or time < 1 or time > 60 then return end
		time = floor(time)
		if timeLeft == time then return end -- Throttle
		timeLeft = time
		BigWigs:Print(L["Pull timer started by %s user '%s'."]:format(isDBM and "DBM" or "Big Wigs", nick))
		if timer then plugin:CancelTimer(timer) end
		timer = plugin:ScheduleRepeatingTimer(printPull, 1)
		plugin:SendMessage("BigWigs_Message", nil, nil, L["Pull in %d sec"]:format(timeLeft), "Attention", "Long")
		plugin:SendMessage("BigWigs_StartBar", plugin, nil, L["Pull"], time, "Interface\\Icons\\ability_warrior_charge")
	end
end

function plugin:OnDBMSync(_, sender, prefix, time, text)
	if prefix == "U" then
		startCustomBar(time.." "..text, sender, nil, true)
	elseif prefix == "PT" then
		startPull(time, sender, true)
	end
end

function plugin:OnSync(sync, rest, nick)
	if rest and nick then
		if sync == "BWCustomBar" then
			startCustomBar(rest, nick)
		elseif sync == "BWPull" then
			startPull(rest, nick)
		end
	end
end

-------------------------------------------------------------------------------
-- Slashcommand
--

do
	local times = {}
	SlashCmdList.BIGWIGSRAIDBAR = function(input)
		if not plugin:IsEnabled() then BigWigs:Enable() end

		if not UnitIsGroupLeader("player") and not UnitIsGroupAssistant("player") then BigWigs:Print(L["This function requires raid leader or raid assist."]) return end

		local time, barText = input:match("(%S+) (.*)")
		if not time or not barText then BigWigs:Print(L["Incorrect format. A correct example is: /raidbar 20 text"]) return end

		time = parseTime(time)
		if not time or time < 0 then BigWigs:Print(L["Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."]) return end

		local t = GetTime()
		if not times[input] or (times[input] and (times[input] + 2) < t) then
			times[input] = t
			BigWigs:Print(L["Sending custom bar '%s' to Big Wigs and DBM users."]:format(barText))
			BigWigs:Transmit("BWCustomBar", time, barText)
			SendAddonMessage("D4", ("U\t%d\t%s"):format(time, barText), IsPartyLFG() and "INSTANCE_CHAT" or "RAID") -- DBM message
		end
	end
	SLASH_BIGWIGSRAIDBAR1 = "/raidbar"
end

SlashCmdList.BIGWIGSLOCALBAR = function(input)
	if not plugin:IsEnabled() then BigWigs:Enable() end

	local time, barText = input:match("(%S+) (.*)")
	if not time or not barText then BigWigs:Print(L["Incorrect format. A correct example is: /raidbar 20 text"]:gsub("/raidbar", "/localbar")) return end

	time = parseTime(time)
	if not time then BigWigs:Print(L["Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."]) return end

	startCustomBar(time, UnitName("player"), barText)
end
SLASH_BIGWIGSLOCALBAR1 = "/localbar"

SlashCmdList.BIGWIGSPULL = function(input)
	if not plugin:IsEnabled() then BigWigs:Enable() end
	if IsEncounterInProgress() then BigWigs:Print(L["This function can't be used during an encounter."]) return end -- Doesn't make sense to allow this in combat
	if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") then
		local time = tonumber(input)
		if not time or time < 1 or time > 60 then BigWigs:Print(L["Must be between 1 and 60. A correct example is: /pull 5"]) return end

		BigWigs:Print(L["Sending a pull timer to Big Wigs and DBM users."])
		BigWigs:Transmit("BWPull", input)
		SendAddonMessage("D4", "PT\t".. input, IsPartyLFG() and "INSTANCE_CHAT" or "RAID") -- DBM message
	else
		BigWigs:Print(L["This function requires raid leader or raid assist."])
	end
end
SLASH_BIGWIGSPULL1 = "/pull"

SlashCmdList.BWLCB_SHORTHAND = function() BigWigs:Print(L.customBarSlashPrint) end
SLASH_BWLCB_SHORTHAND1 = "/bwlcb"
SlashCmdList.BWCB_SHORTHAND = function() BigWigs:Print(L.customBarSlashPrint) end
SLASH_BWCB_SHORTHAND1 = "/bwcb"

