--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin, L = BigWigs:NewPlugin("Bars", {
	"db",
	"SendCustomBarToGroup",
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
	spellIndicators = 1023, -- Constants.EncounterTimelineIconMasks.EncounterTimelineAllIcons = 1023
	spellIndicatorsSize = 4,
	spellIndicatorsPosition = "LEFT",
	spellIndicatorsOffset = 2,
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

	if not LibSharedMedia:IsValid(FONT, db.fontName) then
		db.fontName = plugin.defaultDB.fontName
	end
	if not LibSharedMedia:IsValid(STATUSBAR, db.texture) then
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

	if db.spellIndicators < 0 or db.spellIndicators > plugin.defaultDB.spellIndicators then
		db.spellIndicators = plugin.defaultDB.spellIndicators
	end
	if db.spellIndicatorsSize < 0 or db.spellIndicatorsSize > 5 then
		db.spellIndicatorsSize = plugin.defaultDB.spellIndicatorsSize
	end
	if db.spellIndicatorsPosition ~= "LEFT" and db.spellIndicatorsPosition ~= "RIGHT" then
		db.spellIndicatorsPosition = plugin.defaultDB.spellIndicatorsPosition
	end
	if db.spellIndicatorsOffset < 0 or db.spellIndicatorsOffset > 100 then
		db.spellIndicatorsOffset = plugin.defaultDB.spellIndicatorsOffset
	end

	if type(db.normalPosition[1]) ~= "string" or type(db.normalPosition[2]) ~= "string"
	or type(db.normalPosition[3]) ~= "number" or type(db.normalPosition[4]) ~= "number"
	or not BigWigsAPI.IsValidFramePoint(db.normalPosition[1]) or not BigWigsAPI.IsValidFramePoint(db.normalPosition[2]) then
		db.normalPosition[1] = plugin.defaultDB.normalPosition[1]
		db.normalPosition[2] = plugin.defaultDB.normalPosition[2]
		db.normalPosition[3] = plugin.defaultDB.normalPosition[3]
		db.normalPosition[4] = plugin.defaultDB.normalPosition[4]
		db.normalPosition[5] = plugin.defaultDB.normalPosition[5]
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
			db.normalPosition[1] = plugin.defaultDB.normalPosition[1]
			db.normalPosition[2] = plugin.defaultDB.normalPosition[2]
			db.normalPosition[3] = plugin.defaultDB.normalPosition[3]
			db.normalPosition[4] = plugin.defaultDB.normalPosition[4]
			db.normalPosition[5] = plugin.defaultDB.normalPosition[5]
		end
	end

	if type(db.expPosition[1]) ~= "string" or type(db.expPosition[2]) ~= "string"
	or type(db.expPosition[3]) ~= "number" or type(db.expPosition[4]) ~= "number"
	or not BigWigsAPI.IsValidFramePoint(db.expPosition[1]) or not BigWigsAPI.IsValidFramePoint(db.expPosition[2]) then
		db.expPosition[1] = plugin.defaultDB.expPosition[1]
		db.expPosition[2] = plugin.defaultDB.expPosition[2]
		db.expPosition[3] = plugin.defaultDB.expPosition[3]
		db.expPosition[4] = plugin.defaultDB.expPosition[4]
		db.expPosition[5] = plugin.defaultDB.expPosition[5]
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
			db.expPosition[1] = plugin.defaultDB.expPosition[1]
			db.expPosition[2] = plugin.defaultDB.expPosition[2]
			db.expPosition[3] = plugin.defaultDB.expPosition[3]
			db.expPosition[4] = plugin.defaultDB.expPosition[4]
			db.expPosition[5] = plugin.defaultDB.expPosition[5]
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
	local font = LibSharedMedia:Fetch(FONT, db.fontName)
	local texture = LibSharedMedia:Fetch(STATUSBAR, db.texture)

	local lastIndicatorFrame = nil
	for bar in next, normalAnchor.bars do
		currentBarStyler.BarStopped(bar)
		local height
		if bar:Get("bigwigs:emphasized") then
			height = db.normalHeight * db.emphasizeMultiplier
			bar:SetHeight(height)
			bar:SetWidth(db.normalWidth * db.emphasizeMultiplier)
			bar:SetFont(font, db.fontSizeEmph, flags)
			if db.emphasizeMove then
				normalAnchor.bars[bar] = nil
				emphasizeAnchor.bars[bar] = true
				bar:Set("bigwigs:anchor", "expPosition")
			end
		else
			height = db.normalHeight
			bar:SetHeight(height)
			bar:SetWidth(db.normalWidth)
			bar:SetFont(font, db.fontSize, flags)
		end
		bar:SetTexture(texture)
		bar:SetFill(db.fill)
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
		local indicatorFrame = bar:Get("bigwigs:indicatorFrame")
		if indicatorFrame then
			lastIndicatorFrame = indicatorFrame
			indicatorFrame:ClearTextures()
			indicatorFrame:SetIndicatorSize(height)
			indicatorFrame:AddIndicators(bar:Get("bigwigs:eventId"))
		end
		currentBarStyler.ApplyStyle(bar)
	end

	local rerun = false
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
		if not db.emphasizeMove then
			rerun = true
			normalAnchor.bars[bar] = true
			emphasizeAnchor.bars[bar] = nil
			bar:Set("bigwigs:anchor", "normalPosition")
		end
		if not db.icon then
			bar:SetIcon(nil)
		else
			bar:SetIcon(bar:GetIcon() or "Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid.tga")
		end
		bar:SetIconPosition(db.iconPosition)
		local indicatorFrame = bar:Get("bigwigs:indicatorFrame")
		if indicatorFrame then
			lastIndicatorFrame = indicatorFrame
			indicatorFrame:ClearTextures()
			indicatorFrame:SetIndicatorSize(db.expHeight)
			indicatorFrame:AddIndicators(bar:Get("bigwigs:eventId"))
		end
		currentBarStyler.ApplyStyle(bar)
	end

	if lastIndicatorFrame then
		lastIndicatorFrame:UpdateAllIndicatorPoints()
	end

	rearrangeBars(normalAnchor)
	rearrangeBars(emphasizeAnchor)

	if rerun then
		updateProfile()
	end
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
	local function HiddenOnRetail() return not BigWigsLoader.isRetail end
	local function IsNormalAnchorPointDefault() return db.normalPosition[5] == plugin.defaultDB.normalPosition[5] end
	local function IsExpAnchorPointDefault() return db.expPosition[5] == plugin.defaultDB.expPosition[5] end
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
	local indicatorFrame = bar:Get("bigwigs:indicatorFrame")
	if indicatorFrame then
		indicatorFrame:RemoveIndicators()
	end
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
		if not self:IsShown() then return end
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
			local indicatorFrame = k:Get("bigwigs:indicatorFrame")
			if db.emphasizeMove then
				if self == normalAnchor then
					k:SetSize(db.normalWidth, db.normalHeight)
					if indicatorFrame then
						indicatorFrame:SetIndicatorSize(db.normalHeight)
					end
				else
					k:SetSize(db.expWidth, db.expHeight)
					if indicatorFrame then
						indicatorFrame:SetIndicatorSize(db.expHeight)
					end
				end
			elseif self == normalAnchor then
				-- Move is disabled and we are configuring the normal anchor. Don't apply normal bar sizes to emphasized bars
				if k:Get("bigwigs:emphasized") then
					local newHeight = db.normalHeight * db.emphasizeMultiplier
					k:SetSize(db.normalWidth * db.emphasizeMultiplier, newHeight)
					if indicatorFrame then
						indicatorFrame:SetIndicatorSize(newHeight)
					end
				else
					k:SetSize(db.normalWidth, db.normalHeight)
					if indicatorFrame then
						indicatorFrame:SetIndicatorSize(db.normalHeight)
					end
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
		GameTooltip_Hide()
	end
	local function OnMouseUp(self)
		self:GetParent():StopMovingOrSizing()
		if BigWigsOptions and BigWigsOptions:IsOpen() then
			plugin:UpdateGUI() -- Update X/Y if GUI is open
		end
	end
	local function OnEnter(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(L.dragToResize)
		GameTooltip:Show()
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
		drag:SetPoint("BOTTOMRIGHT", -1, 1)
		drag:EnableMouse(true)
		drag:SetScript("OnMouseDown", OnMouseDown)
		drag:SetScript("OnMouseUp", OnMouseUp)
		drag:SetScript("OnEnter", OnEnter)
		drag:SetScript("OnLeave", GameTooltip_Hide)
		local tex = drag:CreateTexture(nil, "OVERLAY")
		tex:SetTexture("Interface\\AddOns\\BigWigs\\Media\\Icons\\draghandle")
		tex:SetAllPoints(drag)
		tex:SetBlendMode("ADD")
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

function getBar(anchor, module, text, eventId)
	if not anchor then return end
	for bar in next, anchor.bars do
		if eventId then
			if bar:Get("bigwigs:eventId") == eventId then
				return bar
			end
		elseif text and bar:Get("bigwigs:module") == module and bar:GetLabel() == text then
			return bar
		end
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

function plugin:PauseBar(_, module, text, eventId)
	if not normalAnchor then return end
	local bar = getBar(normalAnchor, module, text, eventId)
	if bar then
		bar:Pause()
		return
	end
	bar = getBar(emphasizeAnchor, module, text, eventId)
	if bar then
		bar:Pause()
		return
	end
end

function plugin:ResumeBar(_, module, text, eventId)
	if not normalAnchor then return end
	local bar = getBar(normalAnchor, module, text, eventId)
	if bar then
		bar:Resume()
		return
	end
	bar = getBar(emphasizeAnchor, module, text, eventId)
	if bar then
		bar:Resume()
		return
	end
end

--------------------------------------------------------------------------------
-- Stopping bars
--

function plugin:StopSpecificBar(_, module, text, eventId)
	if not normalAnchor then return end
	local bar = getBar(normalAnchor, module, text, eventId)
	if bar then
		bar:Stop()
		return
	end
	bar = getBar(emphasizeAnchor, module, text, eventId)
	if bar then
		bar:Stop()
		return
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

function plugin:GetBarTimeLeft(module, text, eventId)
	if normalAnchor then
		local bar = getBar(normalAnchor, module, text, eventId)
		if bar then
			return bar.remaining
		end
		bar = getBar(emphasizeAnchor, module, text, eventId)
		if bar then
			return bar.remaining
		end
	end
	return 0
end

-----------------------------------------------------------------------
-- Start bars
--

do
	local GetBarIndicatorFrame
	do
		local function ClearTextures(self)
			self.textureLists[4][1]:SetTexture(nil)
			self.textureLists[4][2]:SetTexture(nil)
			self.textureLists[4][3]:SetTexture(nil)
			self.textureLists[4][4]:SetTexture(nil)
		end

		local function SetIndicatorSize(self, size)
			self:SetSize(size, size)
			if db.spellIndicatorsSize >= 4 then
				size = size / 2
			end
			self.textureLists[4][1]:SetSize(size, size)
			self.textureLists[4][2]:SetSize(size, size)
			self.textureLists[4][3]:SetSize(size, size)
			self.textureLists[4][4]:SetSize(size, size)
		end

		local function AddIndicators(self, eventId)
			self:ClearAllPoints()
			if db.spellIndicatorsPosition == "LEFT" then
				self:SetPoint("BOTTOMRIGHT", self.bar, "BOTTOMLEFT", -db.spellIndicatorsOffset, 0)
			else
				self:SetPoint("BOTTOMLEFT", self.bar, "BOTTOMRIGHT", db.spellIndicatorsOffset, 0)
			end
			C_EncounterTimeline.SetEventIconTextures(eventId, bit.band(1023, db.spellIndicators), self.textureLists[db.spellIndicatorsSize])
		end

		local indicatorList = {}
		local function UpdateAllIndicatorPoints()
			if db.spellIndicatorsSize >= 4 then
				if db.spellIndicatorsPosition == "LEFT" then
					for indicatorCount = 1, #indicatorList do
						local indicatorFrame = indicatorList[indicatorCount]
						indicatorFrame.textureLists[4][1]:ClearAllPoints()
						indicatorFrame.textureLists[4][2]:ClearAllPoints()
						indicatorFrame.textureLists[4][3]:ClearAllPoints()
						indicatorFrame.textureLists[4][4]:ClearAllPoints()
						indicatorFrame.textureLists[4][1]:SetPoint("TOPRIGHT")
						indicatorFrame.textureLists[4][2]:SetPoint("BOTTOMRIGHT")
						indicatorFrame.textureLists[4][3]:SetPoint("TOPLEFT")
						indicatorFrame.textureLists[4][4]:SetPoint("BOTTOMLEFT")
					end
				else
					for indicatorCount = 1, #indicatorList do
						local indicatorFrame = indicatorList[indicatorCount]
						indicatorFrame.textureLists[4][1]:ClearAllPoints()
						indicatorFrame.textureLists[4][2]:ClearAllPoints()
						indicatorFrame.textureLists[4][3]:ClearAllPoints()
						indicatorFrame.textureLists[4][4]:ClearAllPoints()
						indicatorFrame.textureLists[4][1]:SetPoint("TOPLEFT")
						indicatorFrame.textureLists[4][2]:SetPoint("BOTTOMLEFT")
						indicatorFrame.textureLists[4][3]:SetPoint("TOPRIGHT")
						indicatorFrame.textureLists[4][4]:SetPoint("BOTTOMRIGHT")
					end
				end
			else
				if db.spellIndicatorsPosition == "LEFT" then
					for indicatorCount = 1, #indicatorList do
						local indicatorFrame = indicatorList[indicatorCount]
						indicatorFrame.textureLists[4][1]:ClearAllPoints()
						indicatorFrame.textureLists[4][2]:ClearAllPoints()
						indicatorFrame.textureLists[4][3]:ClearAllPoints()
						indicatorFrame.textureLists[4][4]:ClearAllPoints()
						indicatorFrame.textureLists[4][1]:SetPoint("CENTER")
						indicatorFrame.textureLists[4][2]:SetPoint("RIGHT", indicatorFrame.textureLists[4][1], "LEFT", -2, 0)
						indicatorFrame.textureLists[4][3]:SetPoint("RIGHT", indicatorFrame.textureLists[4][2], "LEFT", -2, 0)
						indicatorFrame.textureLists[4][4]:SetPoint("RIGHT", indicatorFrame.textureLists[4][3], "LEFT", -2, 0)
					end
				else
					for indicatorCount = 1, #indicatorList do
						local indicatorFrame = indicatorList[indicatorCount]
						indicatorFrame.textureLists[4][1]:ClearAllPoints()
						indicatorFrame.textureLists[4][2]:ClearAllPoints()
						indicatorFrame.textureLists[4][3]:ClearAllPoints()
						indicatorFrame.textureLists[4][4]:ClearAllPoints()
						indicatorFrame.textureLists[4][1]:SetPoint("CENTER")
						indicatorFrame.textureLists[4][2]:SetPoint("LEFT", indicatorFrame.textureLists[4][1], "RIGHT", -2, 0)
						indicatorFrame.textureLists[4][3]:SetPoint("LEFT", indicatorFrame.textureLists[4][2], "RIGHT", -2, 0)
						indicatorFrame.textureLists[4][4]:SetPoint("LEFT", indicatorFrame.textureLists[4][3], "RIGHT", -2, 0)
					end
				end
			end
		end

		local indicatorCache = {}
		local function RemoveIndicators(self)
			self:ClearTextures()
			self:ClearAllPoints()
			self:SetParent(UIParent)
			self.bar = nil
			indicatorCache[#indicatorCache+1] = self
		end

		function GetBarIndicatorFrame()
			local indicatorFrame

			if next(indicatorCache) then
				indicatorFrame = table.remove(indicatorCache)
			else
				indicatorFrame = CreateFrame("Frame", nil, UIParent)
				indicatorList[#indicatorList+1] = indicatorFrame
				indicatorFrame:SetPoint("CENTER")
				indicatorFrame:Hide()
				indicatorFrame:SetSize(34,34)
				indicatorFrame.ClearTextures = ClearTextures
				indicatorFrame.RemoveIndicators = RemoveIndicators
				indicatorFrame.SetIndicatorSize = SetIndicatorSize
				indicatorFrame.AddIndicators = AddIndicators
				indicatorFrame.UpdateAllIndicatorPoints = UpdateAllIndicatorPoints

				local indicatorTexture1 = indicatorFrame:CreateTexture()
				indicatorTexture1:SetSnapToPixelGrid(false)
				indicatorTexture1:SetTexelSnappingBias(0)
				indicatorTexture1:SetSize(16,16)

				local indicatorTexture2 = indicatorFrame:CreateTexture()
				indicatorTexture2:SetSnapToPixelGrid(false)
				indicatorTexture2:SetTexelSnappingBias(0)
				indicatorTexture2:SetSize(16,16)

				local indicatorTexture3 = indicatorFrame:CreateTexture()
				indicatorTexture3:SetSnapToPixelGrid(false)
				indicatorTexture3:SetTexelSnappingBias(0)
				indicatorTexture3:SetSize(16,16)

				local indicatorTexture4 = indicatorFrame:CreateTexture()
				indicatorTexture4:SetSnapToPixelGrid(false)
				indicatorTexture4:SetTexelSnappingBias(0)
				indicatorTexture4:SetSize(16,16)

				indicatorFrame.textureLists = {
					{indicatorTexture1},
					{indicatorTexture1, indicatorTexture2},
					{indicatorTexture1, indicatorTexture2, indicatorTexture3},
					{indicatorTexture1, indicatorTexture2, indicatorTexture3, indicatorTexture4},
					{indicatorTexture1, indicatorTexture2},
				}

				if db.spellIndicatorsSize >= 4 then
					if db.spellIndicatorsPosition == "LEFT" then
						indicatorTexture1:SetPoint("TOPRIGHT")
						indicatorTexture2:SetPoint("BOTTOMRIGHT")
						indicatorTexture3:SetPoint("TOPLEFT")
						indicatorTexture4:SetPoint("BOTTOMLEFT")
					else
						indicatorTexture1:SetPoint("TOPLEFT")
						indicatorTexture2:SetPoint("BOTTOMLEFT")
						indicatorTexture3:SetPoint("TOPRIGHT")
						indicatorTexture4:SetPoint("BOTTOMRIGHT")
					end
				else
					if db.spellIndicatorsPosition == "LEFT" then
						indicatorTexture1:SetPoint("CENTER")
						indicatorTexture2:SetPoint("RIGHT", indicatorTexture1, "LEFT", -2, 0)
						indicatorTexture3:SetPoint("RIGHT", indicatorTexture2, "LEFT", -2, 0)
						indicatorTexture4:SetPoint("RIGHT", indicatorTexture3, "LEFT", -2, 0)
					else
						indicatorTexture1:SetPoint("CENTER")
						indicatorTexture2:SetPoint("LEFT", indicatorTexture1, "RIGHT", -2, 0)
						indicatorTexture3:SetPoint("LEFT", indicatorTexture2, "RIGHT", -2, 0)
						indicatorTexture4:SetPoint("LEFT", indicatorTexture3, "RIGHT", -2, 0)
					end
				end
			end

			return indicatorFrame
		end
	end

	local initial = true
	function plugin:CreateBar(module, key, text, time, icon, isApprox, eventId)
		local width, height
		width = db.normalWidth
		height = db.normalHeight
		local bar = candy:New(LibSharedMedia:Fetch(STATUSBAR, db.texture), width, height)
		local flags = nil
		if db.monochrome and db.outline ~= "NONE" then
			flags = "MONOCHROME," .. db.outline
		elseif db.monochrome then
			flags = "MONOCHROME"
		elseif db.outline ~= "NONE" then
			flags = db.outline
		end
		local f = LibSharedMedia:Fetch(FONT, db.fontName)
		bar:SetFont(f, db.fontSize, flags)
		bar:Set("bigwigs:module", module)
		bar:Set("bigwigs:option", key)
		if eventId then
			bar:Set("bigwigs:eventId", eventId)
		end
		bar:Set("bigwigs:anchor", "normalPosition")
		normalAnchor.bars[bar] = true
		if db.icon then
			bar:SetIcon(icon)
		else
			bar:SetIcon(nil)
		end
		if eventId then
			local indicatorFrame = GetBarIndicatorFrame()
			indicatorFrame:SetParent(bar)
			indicatorFrame:Show()
			indicatorFrame.bar = bar
			indicatorFrame:SetIndicatorSize(height)
			indicatorFrame:AddIndicators(eventId)
			bar:Set("bigwigs:indicatorFrame", indicatorFrame)
		end
		bar:SetDuration(time, not eventId and isApprox) -- isApprox is maxQueueDuration for timeline bars
		bar:SetColor(colors:GetColor("barColor", module, key))
		bar:SetBackgroundColor(colors:GetColor("barBackground", module, key))
		bar:SetTextColor(colors:GetColor("barText", module, key))
		bar:SetShadowColor(colors:GetColor("barTextShadow", module, key))
		bar.candyBarLabel:SetJustifyH(db.alignText)
		bar.candyBarDuration:SetJustifyH(db.alignTime)

		bar:SetTimeVisibility(db.time)
		bar:SetLabelVisibility(db.text)
		bar:SetIconPosition(db.iconPosition)
		bar:SetFill(db.fill)
		bar:SetLabel(text)
		if initial then
			-- Workaround for wow custom font loading issues
			self:SimpleTimer(function()
				initial = false
				if (not eventId and bar:GetLabel() == text) or (eventId and bar:Get("bigwigs:eventId") == eventId) then
					bar:SetLabel("-1")
					bar:SetLabel(text)
				end
			end, 0.3)
		end

		return bar
	end
end

do
	local function moveBar(bar)
		plugin:EmphasizeBar(bar)
		plugin:SendMessage("BigWigs_BarEmphasized", plugin, bar)
		rearrangeBars(normalAnchor)
		rearrangeBars(emphasizeAnchor)
	end

	function plugin:BigWigs_StartBar(_, module, key, text, time, icon, isApprox, maxTime, eventId)
		if (issecretvalue == nil or not issecretvalue(text)) and not text then text = "" end
		self:StopSpecificBar(nil, module, text, eventId)
		local bar = self:CreateBar(module, key, text, time, icon, isApprox, eventId)
		bar:SetPauseWhenDone(isApprox)
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
	local f = LibSharedMedia:Fetch(FONT, db.fontName)
	bar:SetFont(f, db.fontSizeEmph, flags)

	bar:SetColor(colors:GetColor("barEmphasized", module, key))
	local indicatorFrame = bar:Get("bigwigs:indicatorFrame")
	if db.emphasizeMove then
		local height = db.expHeight
		bar:SetHeight(height)
		bar:SetWidth(db.expWidth)
		if indicatorFrame then
			indicatorFrame:SetIndicatorSize(height)
		end
	else
		local height = db.normalHeight * db.emphasizeMultiplier
		bar:SetHeight(height)
		bar:SetWidth(db.normalWidth * db.emphasizeMultiplier)
		if indicatorFrame then
			indicatorFrame:SetIndicatorSize(height)
		end
	end
	bar:SetFrameLevel(105) -- Put emphasized bars just above normal bars (LibCandyBar 100)
	currentBarStyler.ApplyStyle(bar)
	bar:Set("bigwigs:emphasized", true)
end

--------------------------------------------------------------------------------
-- Custom Bars
--

local function ConvertTimeStringToSeconds(input)
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

local ReplaceIconWithTexture
do
	local markerIcons = {
		"|T137001:0|t",
		"|T137002:0|t",
		"|T137003:0|t",
		"|T137004:0|t",
		"|T137005:0|t",
		"|T137006:0|t",
		"|T137007:0|t",
		"|T137008:0|t",
	}

	function ReplaceIconWithTexture(msg)
		local id = tonumber(msg)
		if id and id >= 1 and id <= 8 then
			return markerIcons[id]
		else
			("{rt%s}"):format(msg)
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
			seconds = ConvertTimeStringToSeconds(seconds)
			if type(seconds) ~= "number" or type(barText) ~= "string" or seconds < 0 then
				return
			end
		end

		local id = "bwcb" .. nick .. barText
		if timers[id] then
			plugin:CancelTimer(timers[id])
			timers[id] = nil
		end

		barText = barText:gsub("{[Rr][Tt](%d)}", ReplaceIconWithTexture)
		if not localOnly then
			BigWigs:Print(L.customBarStarted:format(barText, isDBM and "DBM" or "BigWigs", nick))
		end
		nick = nick:gsub("%-.+", "*") -- Remove server name
		if seconds == 0 then
			plugin:SendMessage("BigWigs_StopBar", plugin, nick..": "..barText)
		else
			timers[id] = plugin:ScheduleTimer(function() plugin:SendMessage("BigWigs_Message", plugin, false, L.timerFinished:format(nick, barText), "yellow", 134376) end, seconds)
			local text = nick..": "..barText
			plugin:SendMessage("BigWigs_StartBar", plugin, id, text, seconds, 134376) -- 134376 = "Interface\\Icons\\INV_Misc_PocketWatch_01"
			plugin:SendMessage("BigWigs_Timer", plugin, id, 9, 9, text, 0, 134376, false, true)
		end
	end
end

function plugin:DBM_AddonMessage(_, sender, prefix, seconds, text)
	if prefix == "U" then
		startCustomBar(seconds.." "..text, sender, nil, true)
	end
end

function plugin:BigWigs_PluginComm(_, msg, seconds, sender)
	if seconds then
		if msg == "CBar" then
			startCustomBar(seconds, sender)
		end
	end
end

do
	local SendAddonMessage = BigWigsLoader.SendAddonMessage
	local dbmPrefix = BigWigsLoader.dbmPrefix
	local times
	function plugin:SendCustomBarToGroup(message, duration)
		if not duration or duration < 3 then BigWigs:Print(L.wrongTime) return end
		if not IsInGroup() or (not UnitIsGroupLeader("player") and not UnitIsGroupAssistant("player")) then BigWigs:Print(L.requiresLeadOrAssist) return end
		if not plugin:IsEnabled() then BigWigs:Enable() end

		if not times then times = {} end
		local t = GetTime()
		local id = duration .." ".. message
		if not times[id] or (times[id] and (times[id] + 1) < t) then
			times[id] = t
			local barTextForPrinting = message:gsub("{[Rr][Tt](%d)}", ReplaceIconWithTexture)
			BigWigs:Print(L.sendCustomBar:format(barTextForPrinting))
			plugin:Sync("CBar", id)
			local name = plugin:UnitName("player")
			local realm = GetRealmName()
			local normalizedPlayerRealm = realm:gsub("[%s-]+", "") -- Has to mimic DBM code
			local result = SendAddonMessage(dbmPrefix, ("%s-%s\t1\tU\t%d\t%s"):format(name, normalizedPlayerRealm, duration, message), IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- DBM message
			if type(result) == "number" and result ~= 0 then
				BigWigs:Error("BigWigs: Failed to send raid bar. Error code: ".. result)
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Slashcommand
--

BigWigsAPI.RegisterSlashCommand("/raidbar", function(input)
	local seconds, barText = input:match("(%S+) (.*)")
	if not seconds or not barText then BigWigs:Print(L.wrongCustomBarFormat) return end
	seconds = ConvertTimeStringToSeconds(seconds)
	plugin:SendCustomBarToGroup(barText, seconds)
end)

BigWigsAPI.RegisterSlashCommand("/localbar", function(input)
	if not plugin:IsEnabled() then BigWigs:Enable() end

	local seconds, barText = input:match("(%S+) (.*)")
	if not seconds or not barText then BigWigs:Print(L.wrongCustomBarFormat:gsub("/raidbar", "/localbar")) return end

	seconds = ConvertTimeStringToSeconds(seconds)
	if not seconds then BigWigs:Print(L.wrongTime) return end

	startCustomBar(seconds, plugin:UnitName("player"), barText)
end)
