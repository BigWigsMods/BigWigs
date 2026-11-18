if not BigWigsLoader.isRetail then return end -- Retail only module (temporarily)

--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin, L = BigWigs:NewPlugin("Timers", {
	"db",
})
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

plugin.displayName = L.bars

local currentBarStyler = nil
local SetBarStyle

local colors = nil
local candy = LibStub("LibCandyBar-3.0")
local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local FONT = LibSharedMedia.MediaType and LibSharedMedia.MediaType.FONT or "font"
local STATUSBAR = LibSharedMedia.MediaType and LibSharedMedia.MediaType.STATUSBAR or "statusbar"
local next = next
local db = nil
local normalAnchor, emphasizeAnchor = nil, nil
local rearrangeBars, getBar

local minBarWidth, minBarHeight, maxBarWidth, maxBarHeight = 120, 10, 550, 100

--------------------------------------------------------------------------------
-- Profile
--

plugin.defaultDB = {
	-- General
	fontName = plugin:GetDefaultFont(),
	monochrome = false,
	outline = "NONE",
	separateAnchors = true,
	mode = "BAR",
	modeExp = "BAR",

	-- Icons
	iconsFontSize = 10,
	iconsFontSizeExp = 13,
	iconsWidth = 18,
	iconsHeight = 18,
	iconsWidthExp = 26,
	iconsHeightExp = 26,
	iconsNormalPosition = {"CENTER", "CENTER", 450, 200, "UIParent"},
	iconsExpPosition = {"CENTER", "CENTER", 0, -100, "UIParent"},

	-- Bars
}

local function CopyTable(settingsTable)
	local copy = {}
	for key, value in next, settingsTable do
		if type(value) == "table" then
			copy[key] = CopyTable(value)
		else
			copy[key] = value
		end
	end
	return copy
end

local function updateProfile()
	db = plugin.db.profile

	for k, v in next, db do
		local defaultType = type(plugin.defaultDB[k])
		if defaultType == "nil" then
			db[k] = nil
		elseif type(v) ~= defaultType then
			if defaultType == "table" then
				db[k] = CopyTable(plugin.defaultDB[k])
			else
				db[k] = plugin.defaultDB[k]
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Options
--

do
	local function IsAnchorDisabled(info)
		local key = info[#info]
		local unitType = info[#info-1]
		local optionDB = db[unitType]

		if optionDB.disabled then
			return true
		end
		if key == "showCooldownText" then
			return not optionDB.showCooldown
		elseif key == "cooldownTextScale" then
			return not optionDB.showCooldown or not optionDB.showCooldownText
		end
	end
	plugin.pluginOptions = {
		type = "group",
		name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Bars:20|t ".. "XX Timers",
		childGroups = "tab",
		get = function(info) return plugin.db.profile[info[#info]] end,
		set = function(info, value)
			plugin.db.profile[info[#info]] = value
			updateProfile()
		end,
		order = 2.1,
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
					local time = math.random(11, 30)
					plugin:SendMessage("BigWigs_StartBar", plugin, nil, BigWigsAPI:GetLocale("BigWigs: Common").count:format(L.test, testCount), time, testIcons[(testCount%3)+1])
					plugin:SendMessage("BigWigs_Timer", plugin, nil, time, time, BigWigsAPI:GetLocale("BigWigs: Common").count:format(L.test, testCount), 0, testIcons[(testCount%3)+1], false, true)
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
						values = LibSharedMedia:List(FONT),
						itemControl = "DDI-Font",
						get = function()
							for i, v in next, LibSharedMedia:List(FONT) do
								if v == db.fontName then return i end
							end
						end,
						set = function(_, value)
							local list = LibSharedMedia:List(FONT)
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
								if type(style.spellIndicatorsOffset) == "number" and db.spellIndicatorsOffset > 0 and db.spellIndicatorsOffset <= 100 then
									db.spellIndicatorsOffset = style.spellIndicatorsOffset
								else
									db.spellIndicatorsOffset = plugin.defaultDB.spellIndicatorsOffset
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
						values = LibSharedMedia:List(STATUSBAR),
						itemControl = "DDI-Statusbar",
						get = function(info)
							for i, v in next, LibSharedMedia:List(STATUSBAR) do
								if v == db[info[#info]] then return i end
							end
						end,
						set = function(info, value)
							local list = LibSharedMedia:List(STATUSBAR)
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
							LEFT = L.LEFT,
							CENTER = L.CENTER,
							RIGHT = L.RIGHT,
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
							LEFT = L.LEFT,
							CENTER = L.CENTER,
							RIGHT = L.RIGHT,
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
							LEFT = L.LEFT,
							RIGHT = L.RIGHT,
						},
						disabled = function() return not db.icon end,
					},
					spellIndicators = {
						type = "multiselect",
						name = L.indicatorTitle,
						order = 18,
						width = 2,
						control = "Dropdown",
						values = {
							[1] = "|A:icons_16x16_deadly:16:16|a " .. L.indicatorType_Deadly,
							[2] = "|A:icons_16x16_enrage:16:16|a " .. BigWigsAPI:GetLocale("BigWigs: Common").enrage,
							[4] = "|A:icons_16x16_bleed:16:16|a " .. L.indicatorType_Bleed,
							[8] = "|A:icons_16x16_magic:16:16|a " .. L.indicatorType_Magic,
							[16] = "|A:icons_16x16_disease:16:16|a " .. BigWigsAPI:GetLocale("BigWigs: Common").disease,
							[32] = "|A:icons_16x16_curse:16:16|a " .. BigWigsAPI:GetLocale("BigWigs: Common").curse,
							[64] = "|A:icons_16x16_poison:16:16|a " .. BigWigsAPI:GetLocale("BigWigs: Common").poison,
							[128] = "|A:icons_16x16_tank:16:16|a " .. L.indicatorType_Tank,
							[256] = "|A:icons_16x16_heal:16:16|a " .. L.indicatorType_Healer,
							[512] = "|A:icons_16x16_damage:16:16|a " .. L.indicatorType_Damager,
						},
						get = function(info, entry)
							return bit.band(plugin.db.profile[info[#info]], entry) == entry
						end,
						set = function(info, entry, value)
							if value then
								plugin.db.profile[info[#info]] = plugin.db.profile[info[#info]] + entry
							else
								plugin.db.profile[info[#info]] = plugin.db.profile[info[#info]] - entry
							end
							updateProfile()
						end,
						hidden = HiddenOnRetail,
					},
					spellIndicatorsSize = {
						type = "select",
						name = L.spellIndicatorSize,
						order = 19,
						values = {
							L.spellIndicatorSizeDropdown_Large1,
							L.spellIndicatorSizeDropdown_Large2,
							L.spellIndicatorSizeDropdown_Large3,
							L.spellIndicatorSizeDropdown_Small4,
							L.spellIndicatorSizeDropdown_Small2,
						},
						hidden = HiddenOnRetail,
					},
					spellIndicatorsPosition = {
						type = "select",
						name = L.spellIndicatorsPosition,
						desc = L.spellIndicatorsPositionDesc,
						order = 20,
						width = 2,
						values = {
							LEFT = L.LEFT,
							RIGHT = L.RIGHT,
						},
						hidden = HiddenOnRetail,
					},
					spellIndicatorsOffset = {
						type = "range",
						name = L.spellIndicatorsOffset,
						desc = L.positionDesc,
						order = 21,
						max = 100,
						min = 0,
						step = 1,
						hidden = HiddenOnRetail,
					},
					resetHeader = {
						type = "header",
						name = "",
						order = 22,
					},
					reset = {
						type = "execute",
						name = L.resetAll,
						desc = L.resetBarsDesc,
						func = function() plugin.db:ResetProfile() updateProfile() end,
						order = 23,
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
								width = 3,
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
								width = 3,
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
								width = 1.5,
							},
							normalHeight = {
								type = "range",
								name = L.height,
								desc = L.sizeDesc,
								min = minBarHeight,
								max = maxBarHeight,
								step = 1,
								order = 4,
								width = 1.5,
							},
							normalCustomAnchorPoint = {
								type = "input",
								get = function()
									return db.normalPosition[5]
								end,
								set = function(_, value)
									if value ~= plugin.defaultDB.normalPosition[5] then
										db.normalPosition[1] = "CENTER"
										db.normalPosition[2] = "CENTER"
										db.normalPosition[3] = 0
										db.normalPosition[4] = 0
										db.normalPosition[5] = value
									else
										db.normalPosition[1] = plugin.defaultDB.normalPosition[1]
										db.normalPosition[2] = plugin.defaultDB.normalPosition[2]
										db.normalPosition[3] = plugin.defaultDB.normalPosition[3]
										db.normalPosition[4] = plugin.defaultDB.normalPosition[4]
										db.normalPosition[5] = plugin.defaultDB.normalPosition[5]
									end
									updateProfile()
								end,
								validate = function(_, value)
									local frame = _G[value]
									if type(frame) ~= "table" or type(frame.GetObjectType) ~= "function" or type(frame.IsForbidden) ~= "function" or frame:IsForbidden() then
										return false
									end
									return true
								end,
								name = L.customAnchorPoint,
								order = 5,
								width = 3,
							},
							normalCustomAnchorPointSource = {
								type = "select",
								get = function()
									return db.normalPosition[1]
								end,
								set = function(_, value)
									if BigWigsAPI.IsValidFramePoint(value) then
										db.normalPosition[1] = value
										updateProfile()
									end
								end,
								values = BigWigsAPI.GetFramePointList(),
								name = L.sourcePoint,
								order = 6,
								width = 1.5,
								disabled = IsNormalAnchorPointDefault,
							},
							normalCustomAnchorPointDestination = {
								type = "select",
								get = function()
									return db.normalPosition[2]
								end,
								set = function(_, value)
									if BigWigsAPI.IsValidFramePoint(value) then
										db.normalPosition[2] = value
										updateProfile()
									end
								end,
								values = BigWigsAPI.GetFramePointList(),
								name = L.destinationPoint,
								order = 7,
								width = 1.5,
								disabled = IsNormalAnchorPointDefault,
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
								width = 3,
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
								width = 3,
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
								width = 1.5,
							},
							expHeight = {
								type = "range",
								name = L.height,
								desc = L.sizeDesc,
								min = minBarHeight,
								max = maxBarHeight,
								step = 1,
								order = 4,
								width = 1.5,
							},
							expCustomAnchorPoint = {
								type = "input",
								get = function()
									return db.expPosition[5]
								end,
								set = function(_, value)
									if value ~= plugin.defaultDB.expPosition[5] then
										db.expPosition[1] = "CENTER"
										db.expPosition[2] = "CENTER"
										db.expPosition[3] = 0
										db.expPosition[4] = 0
										db.expPosition[5] = value
									else
										db.expPosition[1] = plugin.defaultDB.expPosition[1]
										db.expPosition[2] = plugin.defaultDB.expPosition[2]
										db.expPosition[3] = plugin.defaultDB.expPosition[3]
										db.expPosition[4] = plugin.defaultDB.expPosition[4]
										db.expPosition[5] = plugin.defaultDB.expPosition[5]
									end
									updateProfile()
								end,
								validate = function(_, value)
									local frame = _G[value]
									if type(frame) ~= "table" or type(frame.GetObjectType) ~= "function" or type(frame.IsForbidden) ~= "function" or frame:IsForbidden() then
										return false
									end
									return true
								end,
								name = L.customAnchorPoint,
								order = 5,
								width = 3,
							},
							expCustomAnchorPointSource = {
								type = "select",
								get = function()
									return db.expPosition[1]
								end,
								set = function(_, value)
									if BigWigsAPI.IsValidFramePoint(value) then
										db.expPosition[1] = value
										updateProfile()
									end
								end,
								values = BigWigsAPI.GetFramePointList(),
								name = L.sourcePoint,
								order = 6,
								width = 1.5,
								disabled = IsExpAnchorPointDefault,
							},
							expCustomAnchorPointDestination = {
								type = "select",
								get = function()
									return db.expPosition[2]
								end,
								set = function(_, value)
									if BigWigsAPI.IsValidFramePoint(value) then
										db.expPosition[2] = value
										updateProfile()
									end
								end,
								values = BigWigsAPI.GetFramePointList(),
								name = L.destinationPoint,
								order = 7,
								width = 1.5,
								disabled = IsExpAnchorPointDefault,
							},
						},
					},
				},
			},
		},
	}
--[[
	local prevScale = 1
	local function OnDragStart(self)
		local anchor = self.dragAnchor
		local anchorDB = plugin.db.profile[anchor.unitType]
		prevScale = anchorDB.cooldownTextScale
		anchorDB.cooldownTextScale = 1
		updateProfile()
		anchor:StartMoving()
	end
	local function OnDragStop(self)
		local anchor = self.dragAnchor
		anchor:StopMovingOrSizing()

		local point, _, relPoint, x, y = anchor:GetPoint()
		x = math.floor(x + 0.5)
		y = math.floor(y + 0.5)

		local anchorDB = plugin.db.profile[anchor.unitType]
		anchorDB.anchorPoint = point
		anchorDB.anchorRelPoint = relPoint
		anchorDB.anchorXOffset = x
		anchorDB.anchorYOffset = y
		anchorDB.cooldownTextScale = prevScale
		updateProfile()

		if BigWigsOptions and BigWigsOptions:IsOpen() then
			plugin:UpdateGUI()
		end
	end

	local function createDragAnchor(parent)
		local display = CreateFrame("Frame", nil, UIParent)
		display:SetPoint("TOPLEFT", parent)
		display:SetPoint("BOTTOMRIGHT", parent)
		display:Hide()
		display:SetFrameStrata("HIGH")
		display:SetFixedFrameStrata(true)
		display:SetFrameLevel(25)
		display:SetFixedFrameLevel(true)

		display:EnableMouse(true)
		display:RegisterForDrag("LeftButton")
		display:SetClampedToScreen(true)
		display:SetScript("OnDragStart", OnDragStart)
		display:SetScript("OnDragStop", OnDragStop)

		local bg = display:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(display)
		bg:SetColorTexture(0, 0, 0, parent.hasTestIcon and 0 or 0.3)
		display.bg = bg

		local header = display:CreateFontString(nil, "ARTWORK")
		header:SetFont(plugin:GetDefaultFont(12))
		header:SetShadowOffset(1, -1)
		header:SetTextColor(1, 0.82, 0, 1)
		header:SetPoint("CENTER", display, "CENTER")
		header:SetJustifyH("CENTER")
		header:SetJustifyV("MIDDLE")
		display.text = header

		return display
	end

	function plugin:BigWigs_StartConfigureMode(_, mode)
		if mode and mode ~= self.moduleName then return end
		inConfigureMode = true

		for unitType, unitAnchors in next, anchors do
			for i = 1, #unitAnchors do
				local anchor = unitAnchors[i]
				if not anchor.configModeFrame then
					anchor.configModeFrame = createDragAnchor(anchor)
					anchor.configModeFrame.text:SetText(anchor.hasTestIcon and "" or L.privateAurasTestAnchorText:format(i))
					anchor.configModeFrame.dragAnchor = unitAnchors[1]
				end
				anchor.configModeFrame:Show()
			end
		end
	end

	function plugin:BigWigs_StopConfigureMode(_, mode)
		if mode and mode ~= self.moduleName then return end
		inConfigureMode = false

		for _, unitAnchors in next, anchors do
			for i = 1, #unitAnchors do
				local anchor = unitAnchors[i]
				if anchor.configModeFrame then
					anchor.configModeFrame:Hide()
				end
			end
		end

		self:UpdateAllAnchors()
	end
]]
end
