--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Bars")
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
plugin.displayName = L.bars

local startBreak -- Break timer function

local currentBarStyler = nil
local SetBarStyle

local colors = nil
local candy = LibStub("LibCandyBar-3.0")
local media = LibStub("LibSharedMedia-3.0")
local FONT = media.MediaType and media.MediaType.FONT or "font"
local STATUSBAR = media.MediaType and media.MediaType.STATUSBAR or "statusbar"
local next = next
local db = nil
local normalAnchor, emphasizeAnchor = nil, nil
local rearrangeBars

local validFramePoints = {
	["TOPLEFT"] = L.TOPLEFT, ["TOPRIGHT"] = L.TOPRIGHT, ["BOTTOMLEFT"] = L.BOTTOMLEFT, ["BOTTOMRIGHT"] = L.BOTTOMRIGHT,
	["TOP"] = L.TOP, ["BOTTOM"] = L.BOTTOM, ["LEFT"] = L.LEFT, ["RIGHT"] = L.RIGHT, ["CENTER"] = L.CENTER,
}
local minBarWidth, minBarHeight, maxBarWidth, maxBarHeight = 120, 10, 550, 100

--------------------------------------------------------------------------------
-- Profile
--

plugin.defaultDB = {
	fontName = plugin:GetDefaultFont(),
	fontSize = 10,
	fontSizeEmph = 13,
	texture = "BantoBar",
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
	spacing = 1,
	visibleBarLimit = 100,
	visibleBarLimitEmph = 100,
	normalWidth = 180,
	normalHeight = 18,
	expWidth = 260,
	expHeight = 22,
	normalPosition = {"CENTER", "CENTER", 450, 200, "UIParent"},
	expPosition = {"CENTER", "CENTER", 0, -100, "UIParent"},
}

local function updateProfile()
	db = plugin.db.profile

	for k, v in next, db do
		local defaultType = type(plugin.defaultDB[k])
		if defaultType == "nil" then
			db[k] = nil
		elseif type(v) ~= defaultType then
			db[k] = plugin.defaultDB[k]
		end
	end

	SetBarStyle(db.barStyle)

	if not media:IsValid(FONT, db.fontName) then
		db.fontName = plugin:GetDefaultFont()
	end
	if not media:IsValid(STATUSBAR, db.texture) then
		db.texture = plugin.defaultDB.texture
	end
	if db.fontSize < 10 or db.fontSize > 200 then
		db.fontSize = plugin.defaultDB.fontSize
	end
	if db.fontSizeEmph < 10 or db.fontSizeEmph > 200 then
		db.fontSizeEmph = plugin.defaultDB.fontSizeEmph
	end
	if db.outline ~= "NONE" and db.outline ~= "OUTLINE" and db.outline ~= "THICKOUTLINE" then
		db.outline = plugin.defaultDB.outline
	end
	if db.alignText ~= "LEFT" and db.alignText ~= "CENTER" and db.alignText ~= "RIGHT" then
		db.alignText = plugin.defaultDB.alignText
	end
	if db.alignTime ~= "LEFT" and db.alignTime ~= "CENTER" and db.alignTime ~= "RIGHT" then
		db.alignTime = plugin.defaultDB.alignTime
	end
	if db.iconPosition ~= "LEFT" and db.iconPosition ~= "RIGHT" then
		db.iconPosition = plugin.defaultDB.iconPosition
	end
	if db.emphasizeTime < 6 or db.emphasizeTime > 60 then
		db.emphasizeTime = plugin.defaultDB.emphasizeTime
	end
	if db.emphasizeMultiplier < 1 or db.emphasizeMultiplier > 3 then
		db.emphasizeMultiplier = plugin.defaultDB.emphasizeMultiplier
	end
	if db.spacing < 0 or db.spacing > 20 then
		db.spacing = plugin.defaultDB.spacing
	end
	if db.visibleBarLimit < 1 or db.visibleBarLimit > 100 then
		db.visibleBarLimit = plugin.defaultDB.visibleBarLimit
	end
	if db.visibleBarLimitEmph < 1 or db.visibleBarLimitEmph > 100 then
		db.visibleBarLimitEmph = plugin.defaultDB.visibleBarLimitEmph
	end
	if db.normalWidth < minBarWidth or db.normalWidth > maxBarWidth then
		db.normalWidth = plugin.defaultDB.normalWidth
	end
	if db.normalHeight < minBarHeight or db.normalHeight > maxBarHeight then
		db.normalHeight = plugin.defaultDB.normalHeight
	end
	if db.expWidth < minBarWidth or db.expWidth > maxBarWidth then
		db.expWidth = plugin.defaultDB.expWidth
	end
	if db.expHeight < minBarHeight or db.expHeight > maxBarHeight then
		db.expHeight = plugin.defaultDB.expHeight
	end

	if type(db.normalPosition[1]) ~= "string" or type(db.normalPosition[2]) ~= "string"
	or type(db.normalPosition[3]) ~= "number" or type(db.normalPosition[4]) ~= "number"
	or not validFramePoints[db.normalPosition[1]] or not validFramePoints[db.normalPosition[2]] then
		db.normalPosition = plugin.defaultDB.normalPosition
	else
		local x = math.floor(db.normalPosition[3]+0.5)
		if x ~= db.normalPosition[3] then
			db.normalPosition[3] = x
		end
		local y = math.floor(db.normalPosition[4]+0.5)
		if y ~= db.normalPosition[4] then
			db.normalPosition[4] = y
		end
	end
	if db.normalPosition[5] ~= plugin.defaultDB.normalPosition[5] then
		local frame = _G[db.normalPosition[5]]
		if type(frame) ~= "table" or type(frame.GetObjectType) ~= "function" or type(frame.IsForbidden) ~= "function" or frame:IsForbidden() then
			db.normalPosition = plugin.defaultDB.normalPosition
		end
	end

	if type(db.expPosition[1]) ~= "string" or type(db.expPosition[2]) ~= "string"
	or type(db.expPosition[3]) ~= "number" or type(db.expPosition[4]) ~= "number"
	or not validFramePoints[db.expPosition[1]] or not validFramePoints[db.expPosition[2]] then
		db.expPosition = plugin.defaultDB.expPosition
	else
		local x = math.floor(db.expPosition[3]+0.5)
		if x ~= db.expPosition[3] then
			db.expPosition[3] = x
		end
		local y = math.floor(db.expPosition[4]+0.5)
		if y ~= db.expPosition[4] then
			db.expPosition[4] = y
		end
	end
	if db.expPosition[5] ~= plugin.defaultDB.expPosition[5] then
		local frame = _G[db.expPosition[5]]
		if type(frame) ~= "table" or type(frame.GetObjectType) ~= "function" or type(frame.IsForbidden) ~= "function" or frame:IsForbidden() then
			db.expPosition = plugin.defaultDB.expPosition
		end
	end

	normalAnchor:SetWidth(db.normalWidth)
	normalAnchor:SetHeight(db.normalHeight)
	emphasizeAnchor:SetWidth(db.expWidth)
	emphasizeAnchor:SetHeight(db.expHeight)
	normalAnchor:RefixPosition()
	emphasizeAnchor:RefixPosition()

	local flags = nil
	if db.monochrome and db.outline ~= "NONE" then
		flags = "MONOCHROME," .. db.outline
	elseif db.monochrome then
		flags = "MONOCHROME"
	elseif db.outline ~= "NONE" then
		flags = db.outline
	end
	local font = media:Fetch(FONT, db.fontName)
	local texture = media:Fetch(STATUSBAR, db.texture)

	for bar in next, normalAnchor.bars do
		currentBarStyler.BarStopped(bar)
		if db.emphasizeMove then
			bar:SetHeight(db.normalHeight)
			bar:SetWidth(db.normalWidth)
		elseif bar:Get("bigwigs:emphasized") then
			bar:SetHeight(db.normalHeight * db.emphasizeMultiplier)
			bar:SetWidth(db.normalWidth * db.emphasizeMultiplier)
		end
		bar:SetTexture(texture)
		bar:SetFill(db.fill)
		bar:SetFont(font, db.fontSize, flags)
		bar:SetLabelVisibility(db.text)
		bar.candyBarLabel:SetJustifyH(db.alignText)
		bar:SetTimeVisibility(db.time)
		bar.candyBarDuration:SetJustifyH(db.alignTime)
		if not db.icon then
			bar:SetIcon(nil)
		else
			bar:SetIcon(bar:GetIcon() or "Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid.tga")
		end
		bar:SetIconPosition(db.iconPosition)
		currentBarStyler.ApplyStyle(bar)
	end
	for bar in next, emphasizeAnchor.bars do
		currentBarStyler.BarStopped(bar)
		bar:SetHeight(db.expHeight)
		bar:SetWidth(db.expWidth)
		bar:SetTexture(texture)
		bar:SetFill(db.fill)
		bar:SetFont(font, db.fontSizeEmph, flags)
		bar:SetLabelVisibility(db.text)
		bar.candyBarLabel:SetJustifyH(db.alignText)
		bar:SetTimeVisibility(db.time)
		bar.candyBarDuration:SetJustifyH(db.alignTime)
		if not db.icon then
			bar:SetIcon(nil)
		else
			bar:SetIcon(bar:GetIcon() or "Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid.tga")
		end
		bar:SetIconPosition(db.iconPosition)
		currentBarStyler.ApplyStyle(bar)
	end

	rearrangeBars(normalAnchor)
	rearrangeBars(emphasizeAnchor)
end

--------------------------------------------------------------------------------
-- Options
--

local inConfigureMode = false
do
	local testCount = 0
	local testIcons = {
		"Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_legacy.tga",
		"Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid.tga",
		"Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_party.tga",
	}
	plugin.pluginOptions = {
		type = "group",
		name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Bars:20|t ".. L.bars,
		childGroups = "tab",
		get = function(info)
			return db[info[#info]]
		end,
		set = function(info, value)
			db[info[#info]] = value
			updateProfile()
		end,
		order = 1,
		args = {
			anchorsButton = {
				type = "execute",
				name = function()
					if inConfigureMode then
						return L.toggleAnchorsBtnHide
					else
						return L.toggleAnchorsBtnShow
					end
				end,
				desc = function()
					if inConfigureMode then
						return L.toggleAnchorsBtnHide_desc
					else
						return L.toggleBarsAnchorsBtnShow_desc
					end
				end,
				func = function()
					if inConfigureMode then
						plugin:SendMessage("BigWigs_StopConfigureMode", "Bars")
					else
						plugin:SendMessage("BigWigs_StartConfigureMode", "Bars")
					end
				end,
				width = 1.5,
				order = 0.2,
			},
			testButton = {
				type = "execute",
				name = L.testBarsBtn,
				desc = L.testBarsBtn_desc,
				func = function()
					testCount = testCount + 1
					plugin:SendMessage("BigWigs_StartBar", plugin, nil, BigWigsAPI:GetLocale("BigWigs: Common").count:format(L.test, testCount), random(11, 30), testIcons[(testCount%3)+1])
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
						get = function()
							for i, v in next, media:List(FONT) do
								if v == db.fontName then return i end
							end
						end,
						set = function(_, value)
							local list = media:List(FONT)
							db.fontName = list[value]
							updateProfile()
						end,
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
									db.normalHeight = style.barHeight
									local expHeight = style.barHeight * 1.1
									expHeight = math.floor(expHeight+0.5)
									db.expHeight = expHeight
								else
									db.normalHeight = plugin.defaultDB.normalHeight
									db.expHeight = plugin.defaultDB.expHeight
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

								plugin:UpdateGUI()
							end
							updateProfile()
						end,
					},
					spacing = {
						type = "range",
						name = L.spacing,
						desc = L.spacingDesc,
						order = 6,
						min = 0,
						max = 20,
						step = 1,
						width = 2,
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
							updateProfile()
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
						func = function() plugin.db:ResetProfile() updateProfile() end,
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
						width = 2,
					},
					fontSize = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						width = 2,
						order = 2,
						softMax = 100, max = 200, min = 10, step = 1,
					},
					visibleBarLimit = {
						type = "range",
						name = L.visibleBarLimit,
						desc = L.visibleBarLimitDesc,
						width = 2,
						order = 3,
						max = 100,
						min = 1,
						step = 1,
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
						disabled = function() return not db.emphasizeMove end, -- Disable when using 1 anchor
					},
					emphasizeMove = {
						type = "toggle",
						name = L.move,
						desc = L.moveDesc,
						order = 4,
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
						disabled = function() return db.emphasizeMove end, -- Disable when using 2 anchors
					},
					emphasizeTime = {
						type = "range",
						name = L.emphasizeAt,
						width = 2,
						order = 6,
						min = 6,
						max = 60, softMax = 30, -- Don't encourage bars longer than 30s in the GUI
						step = 1,
					},
					fontSizeEmph = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						width = 2,
						order = 7,
						softMax = 100, max = 200, min = 10, step = 1,
					},
					visibleBarLimitEmph = {
						type = "range",
						name = L.visibleBarLimit,
						desc = L.visibleBarLimitDesc,
						width = 2,
						order = 8,
						max = 100,
						min = 1,
						step = 1,
					},
				},
			},
			exactPositioning = {
				type = "group",
				name = L.positionExact,
				order = 4,
				childGroups = "tab",
				args = {
					normalPositioning = {
						type = "group",
						name = L.bars,
						order = 1,
						args = {
							posx = {
								type = "range",
								name = L.positionX,
								desc = L.positionDesc,
								min = -2048,
								max = 2048,
								step = 1,
								order = 1,
								width = 3.2,
								get = function()
									return db.normalPosition[3]
								end,
								set = function(_, value)
									db.normalPosition[3] = value
									normalAnchor:RefixPosition()
								end,
							},
							posy = {
								type = "range",
								name = L.positionY,
								desc = L.positionDesc,
								min = -2048,
								max = 2048,
								step = 1,
								order = 2,
								width = 3.2,
								get = function()
									return db.normalPosition[4]
								end,
								set = function(_, value)
									db.normalPosition[4] = value
									normalAnchor:RefixPosition()
								end,
							},
							normalWidth = {
								type = "range",
								name = L.width,
								desc = L.sizeDesc,
								min = minBarWidth,
								max = maxBarWidth,
								step = 1,
								order = 3,
								width = 1.6,
							},
							normalHeight = {
								type = "range",
								name = L.height,
								desc = L.sizeDesc,
								min = minBarHeight,
								max = maxBarHeight,
								step = 1,
								order = 4,
								width = 1.6,
							},
							normalCustomAnchorPoint = {
								type = "input",
								get = function()
									return db.normalPosition[5]
								end,
								set = function(_, value)
									local frame = _G[value]
									if type(frame) ~= "table" or type(frame.GetObjectType) ~= "function" or type(frame.IsForbidden) ~= "function" or frame:IsForbidden() then
										return
									end
									if value ~= plugin.defaultDB.normalPosition[5] then
										db.normalPosition = {"CENTER", "CENTER", 0, 0, value}
									else
										db.normalPosition = plugin.defaultDB.normalPosition
									end
									updateProfile()
								end,
								name = L.customAnchorPoint,
								order = 5,
								width = 3.2,
							},
							normalCustomAnchorPointSource = {
								type = "select",
								get = function()
									return db.normalPosition[1]
								end,
								set = function(_, value)
									if validFramePoints[value] then
										db.normalPosition[1] = value
										updateProfile()
									end
								end,
								values = validFramePoints,
								name = L.sourcePoint,
								order = 6,
								width = 1.6,
								hidden = function() return db.normalPosition[5] == plugin.defaultDB.normalPosition[5] end,
							},
							normalCustomAnchorPointDestination = {
								type = "select",
								get = function()
									return db.normalPosition[2]
								end,
								set = function(_, value)
									if validFramePoints[value] then
										db.normalPosition[2] = value
										updateProfile()
									end
								end,
								values = validFramePoints,
								name = L.destinationPoint,
								order = 7,
								width = 1.6,
								hidden = function() return db.normalPosition[5] == plugin.defaultDB.normalPosition[5] end,
							},
						},
					},
					expPositioning = {
						type = "group",
						name = L.emphasizedBars,
						order = 2,
						args = {
							posx = {
								type = "range",
								name = L.positionX,
								desc = L.positionDesc,
								min = -2048,
								max = 2048,
								step = 1,
								order = 1,
								width = 3.2,
								get = function()
									return plugin.db.profile.expPosition[3]
								end,
								set = function(_, value)
									plugin.db.profile.expPosition[3] = value
									emphasizeAnchor:RefixPosition()
								end,
							},
							posy = {
								type = "range",
								name = L.positionY,
								desc = L.positionDesc,
								min = -2048,
								max = 2048,
								step = 1,
								order = 2,
								width = 3.2,
								get = function()
									return plugin.db.profile.expPosition[4]
								end,
								set = function(_, value)
									plugin.db.profile.expPosition[4] = value
									emphasizeAnchor:RefixPosition()
								end,
							},
							expWidth = {
								type = "range",
								name = L.width,
								desc = L.sizeDesc,
								min = minBarWidth,
								max = maxBarWidth,
								step = 1,
								order = 3,
								width = 1.6,
							},
							expHeight = {
								type = "range",
								name = L.height,
								desc = L.sizeDesc,
								min = minBarHeight,
								max = maxBarHeight,
								step = 1,
								order = 4,
								width = 1.6,
							},
							expCustomAnchorPoint = {
								type = "input",
								get = function()
									return db.expPosition[5]
								end,
								set = function(_, value)
									local frame = _G[value]
									if type(frame) ~= "table" or type(frame.GetObjectType) ~= "function" or type(frame.IsForbidden) ~= "function" or frame:IsForbidden() then
										return
									end
									if value ~= plugin.defaultDB.expPosition[5] then
										db.expPosition = {"CENTER", "CENTER", 0, 0, value}
									else
										db.expPosition = plugin.defaultDB.expPosition
									end
									updateProfile()
								end,
								name = L.customAnchorPoint,
								order = 5,
								width = 3.2,
							},
							expCustomAnchorPointSource = {
								type = "select",
								get = function()
									return db.expPosition[1]
								end,
								set = function(_, value)
									if validFramePoints[value] then
										db.expPosition[1] = value
										updateProfile()
									end
								end,
								values = validFramePoints,
								name = L.sourcePoint,
								order = 6,
								width = 1.6,
								hidden = function() return db.expPosition[5] == plugin.defaultDB.expPosition[5] end,
							},
							expCustomAnchorPointDestination = {
								type = "select",
								get = function()
									return db.expPosition[2]
								end,
								set = function(_, value)
									if validFramePoints[value] then
										db.expPosition[2] = value
										updateProfile()
									end
								end,
								values = validFramePoints,
								name = L.destinationPoint,
								order = 7,
								width = 1.6,
								hidden = function() return db.expPosition[5] == plugin.defaultDB.expPosition[5] end,
							},
						},
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
		if not anchor or not next(anchor.bars) then return end

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

local function barStopped(event, bar)
	local anchorText = bar:Get("bigwigs:anchor")
	if anchorText then
		local anchor = anchorText == "expPosition" and emphasizeAnchor or normalAnchor
		if anchor and anchor.bars and anchor.bars[bar] then
			currentBarStyler.BarStopped(bar)
			anchor.bars[bar] = nil
			rearrangeBars(anchor)
		end
	end
end

--------------------------------------------------------------------------------
-- Anchors
--

do
	local function OnSizeChanged(self, width, height)
		width = math.floor(width+0.5)
		height = math.floor(height+0.5)
		if self == normalAnchor then
			db.normalWidth = width
			db.normalHeight = height
		else
			db.expWidth = width
			db.expHeight = height
		end
		for k in next, self.bars do
			currentBarStyler.BarStopped(k)
			if db.emphasizeMove then
				if self == normalAnchor then
					k:SetSize(db.normalWidth, db.normalHeight)
				else
					k:SetSize(db.expWidth, db.expHeight)
				end
			elseif self == normalAnchor then
				-- Move is disabled and we are configuring the normal anchor. Don't apply normal bar sizes to emphasized bars
				if k:Get("bigwigs:emphasized") then
					k:SetSize(db.normalWidth * db.emphasizeMultiplier, db.normalHeight * db.emphasizeMultiplier)
				else
					k:SetSize(db.normalWidth, db.normalHeight)
				end
			end
			currentBarStyler.ApplyStyle(k)
			rearrangeBars(self)
		end
	end

	local positionDBToUse = {}
	local function OnDragStart(self)
		if db[positionDBToUse[self]][5] == plugin.defaultDB[positionDBToUse[self]][5] then
			self:StartMoving()
		end
	end
	local function OnDragStop(self)
		if db[positionDBToUse[self]][5] == plugin.defaultDB[positionDBToUse[self]][5] then
			self:StopMovingOrSizing()
			local point, _, relPoint, x, y = self:GetPoint()
			x = math.floor(x+0.5)
			y = math.floor(y+0.5)
			plugin.db.profile[positionDBToUse[self]] = {point, relPoint, x, y, plugin.defaultDB[positionDBToUse[self]][5]}
			self:RefixPosition()
			if BigWigsOptions and BigWigsOptions:IsOpen() then
				plugin:UpdateGUI() -- Update X/Y if GUI is open
			end
		end
	end
	local function RefixPosition(self)
		self:ClearAllPoints()
		local point, relPoint = plugin.db.profile[positionDBToUse[self]][1], plugin.db.profile[positionDBToUse[self]][2]
		local x, y = plugin.db.profile[positionDBToUse[self]][3], plugin.db.profile[positionDBToUse[self]][4]
		self:SetPoint(point, db[positionDBToUse[self]][5], relPoint, x, y)
	end
	local function OnMouseDown(self)
		self:GetParent():StartSizing("BOTTOMRIGHT")
	end
	local function OnMouseUp(self)
		self:GetParent():StopMovingOrSizing()
		if BigWigsOptions and BigWigsOptions:IsOpen() then
			plugin:UpdateGUI() -- Update X/Y if GUI is open
		end
	end

	local function createAnchor(position, title, frameLevel, width, height)
		local display = CreateFrame("Frame", nil, UIParent)
		display:EnableMouse(true)
		display:SetClampedToScreen(true)
		display:SetMovable(true)
		display:SetResizable(true)
		display:RegisterForDrag("LeftButton")
		display:SetResizeBounds(minBarWidth, minBarHeight, maxBarWidth, maxBarHeight)
		display:SetFrameStrata("HIGH")
		display:SetFixedFrameStrata(true)
		display:SetFrameLevel(frameLevel)
		display:SetFixedFrameLevel(true)
		display:SetWidth(width)
		display:SetHeight(height)
		positionDBToUse[display] = position
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
		drag:SetScript("OnMouseDown", OnMouseDown)
		drag:SetScript("OnMouseUp", OnMouseUp)
		local tex = drag:CreateTexture(nil, "OVERLAY")
		tex:SetTexture("Interface\\AddOns\\BigWigs\\Media\\Icons\\draghandle")
		tex:SetWidth(16)
		tex:SetHeight(16)
		tex:SetBlendMode("ADD")
		tex:SetPoint("CENTER", drag)
		display.bars = {}
		display.RefixPosition = RefixPosition
		local point, relPoint = plugin.defaultDB[position][1], plugin.defaultDB[position][2]
		local x, y = plugin.defaultDB[position][3], plugin.defaultDB[position][4]
		display:SetPoint(point, plugin.defaultDB[position][5], relPoint, x, y)
		display:Hide()
		display:SetScript("OnSizeChanged", OnSizeChanged)
		display:SetScript("OnDragStart", OnDragStart)
		display:SetScript("OnDragStop", OnDragStop)
		return display
	end

	normalAnchor = createAnchor("normalPosition", L.bars, 10, plugin.defaultDB.normalWidth, plugin.defaultDB.normalHeight)
	emphasizeAnchor = createAnchor("expPosition", L.emphasizedBars, 15, plugin.defaultDB.expWidth, plugin.defaultDB.expHeight)
end

local function showAnchors(_, mode)
	if not mode or mode == "Bars" then
		inConfigureMode = true
		normalAnchor:Show()
		emphasizeAnchor:Show()
	end
end

local function hideAnchors(_, mode)
	if not mode or mode == "Bars" then
		inConfigureMode = false
		normalAnchor:Hide()
		emphasizeAnchor:Hide()
	end
end

--------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	colors = BigWigs:GetPlugin("Colors")
	updateProfile()
	candy.RegisterCallback(self, "LibCandyBar_Stop", barStopped)

	self:RegisterMessage("BigWigs_StartBar")
	self:RegisterMessage("BigWigs_PauseBar", "PauseBar")
	self:RegisterMessage("BigWigs_ResumeBar", "ResumeBar")
	self:RegisterMessage("BigWigs_StopBar", "StopSpecificBar")
	self:RegisterMessage("BigWigs_StopBars", "StopModuleBars")
	self:RegisterMessage("BigWigs_OnBossDisable", "StopModuleBars")
	self:RegisterMessage("BigWigs_OnBossWipe", "StopModuleBars")
	self:RegisterMessage("BigWigs_OnPluginDisable", "StopModuleBars")
	self:RegisterMessage("BigWigs_StartConfigureMode", showAnchors)
	self:RegisterMessage("BigWigs_StopConfigureMode", hideAnchors)
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)

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

-----------------------------------------------------------------------
-- Start bars
--

function plugin:CreateBar(module, key, text, time, icon, isApprox)
	local width, height
	width = db.normalWidth
	height = db.normalHeight
	local bar = candy:New(media:Fetch(STATUSBAR, db.texture), width, height)
	bar:Set("bigwigs:module", module)
	bar:Set("bigwigs:option", key)
	bar:Set("bigwigs:anchor", "normalPosition")
	normalAnchor.bars[bar] = true
	bar:SetIcon(db.icon and icon or nil)
	bar:SetLabel(text)
	bar:SetDuration(time, isApprox)
	bar:SetColor(colors:GetColor("barColor", module, key))
	bar:SetBackgroundColor(colors:GetColor("barBackground", module, key))
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
	bar:SetFont(f, db.fontSize, flags)

	bar:SetTimeVisibility(db.time)
	bar:SetLabelVisibility(db.text)
	bar:SetIconPosition(db.iconPosition)
	bar:SetFill(db.fill)

	return bar
end

do
	local function moveBar(bar)
		plugin:EmphasizeBar(bar)
		plugin:SendMessage("BigWigs_BarEmphasized", plugin, bar)
		rearrangeBars(normalAnchor)
		rearrangeBars(emphasizeAnchor)
	end

	function plugin:BigWigs_StartBar(_, module, key, text, time, icon, isApprox, maxTime)
		if not text then text = "" end
		self:StopSpecificBar(nil, module, text)
		local bar = self:CreateBar(module, key, text, time, icon, isApprox)
		if isApprox then
			bar:SetPauseWhenDone(true)
		end
		if db.emphasize and time < db.emphasizeTime then
			if db.emphasizeRestart and maxTime and maxTime > db.emphasizeTime then
				bar:Start(db.emphasizeTime)
			else
				bar:Start(maxTime)
			end
			self:EmphasizeBar(bar, true)
		else
			bar:Start(maxTime)
			currentBarStyler.ApplyStyle(bar)
			if db.emphasize then
				bar:SetTimeCallback(moveBar, db.emphasizeTime)
			end
		end
		local anchor = bar:Get("bigwigs:anchor") == "expPosition" and emphasizeAnchor or normalAnchor
		rearrangeBars(anchor)
		self:SendMessage("BigWigs_BarCreated", self, bar, module, key, text, time, icon, isApprox)
		-- Check if :EmphasizeBar(bar) was run and trigger the callback.
		-- Bit of a roundabout method to approaching this so that we purposely keep callbacks firing last.
		if bar:Get("bigwigs:emphasized") then
			self:SendMessage("BigWigs_BarEmphasized", self, bar)
		end
	end
end

--------------------------------------------------------------------------------
-- Emphasize
--

function plugin:EmphasizeBar(bar, freshBar)
	if db.emphasizeMove then
		normalAnchor.bars[bar] = nil
		emphasizeAnchor.bars[bar] = true
		bar:Set("bigwigs:anchor", "expPosition")
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
	bar:SetFont(f, db.fontSizeEmph, flags)

	bar:SetColor(colors:GetColor("barEmphasized", module, key))
	if db.emphasizeMove then
		bar:SetHeight(db.expHeight)
		bar:SetWidth(db.expWidth)
	else
		bar:SetHeight(db.normalHeight * db.emphasizeMultiplier)
		bar:SetWidth(db.normalWidth * db.emphasizeMultiplier)
	end
	bar:SetFrameLevel(105) -- Put emphasized bars just above normal bars (LibCandyBar 100)
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
-- Slashcommand
--

local SendAddonMessage = BigWigsLoader.SendAddonMessage
local dbmPrefix = BigWigsLoader.dbmPrefix
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
			local name = plugin:UnitName("player")
			local realm = GetRealmName()
			local normalizedPlayerRealm = realm:gsub("[%s-]+", "") -- Has to mimic DBM code
			SendAddonMessage(dbmPrefix, ("%s-%s\t1\tU\t%d\t%s"):format(name, normalizedPlayerRealm, seconds, barText), IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- DBM message
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
			local name = plugin:UnitName("player")
			local realm = GetRealmName()
			local normalizedPlayerRealm = realm:gsub("[%s-]+", "") -- Has to mimic DBM code
			SendAddonMessage(dbmPrefix, ("%s-%s\t1\tBT\t%d"):format(name, normalizedPlayerRealm, seconds), IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- DBM message
		end
	else
		BigWigs:Print(L.requiresLeadOrAssist)
	end
end
SLASH_BIGWIGSBREAK1 = "/break"
