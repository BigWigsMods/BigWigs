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

local bwTooltip = BigWigsAPI.GetTooltip()
local colors = nil
local candy = LibStub("LibCandyBar-3.0")
local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local FONT = LibSharedMedia.MediaType and LibSharedMedia.MediaType.FONT or "font"
local STATUSBAR = LibSharedMedia.MediaType and LibSharedMedia.MediaType.STATUSBAR or "statusbar"
local BORDER = LibSharedMedia.MediaType and LibSharedMedia.MediaType.BORDER or "border"
local BACKGROUND = LibSharedMedia.MediaType and LibSharedMedia.MediaType.BACKGROUND or "background"
local next = next
local db = nil
local normalAnchor, emphasizeAnchor = nil, nil
local rearrangeBars, getBar, UpdateAllIndicatorPoints
local inConfigureMode = false
local backdropTbl = {}

local minBarWidth, minBarHeight, maxBarWidth, maxBarHeight = 120, 10, 550, 100

local function OnEnterIcon(self)
	if self.bwID then
		bwTooltip:SetOwner(self, "ANCHOR_TOP")
		bwTooltip:SetSpellByID(self.bwID, false, true)
		bwTooltip:Show()
	end
end

local function OnLeaveIcon()
	bwTooltip:Hide()
end

local function GetIconTexCoord(width, height)
	local zoom = 1 - db.iconZoom
	local zoomedOffset = 1 - ((1 - zoom) / 2)
	local offsetX, offsetY = zoomedOffset, zoomedOffset

	if db.iconKeepAspectRatio then
		if width > height then
			offsetY = 1 - (1 - (height / width) * zoom) / 2
		elseif height > width then
			offsetX = 1 - (1 - (width / height) * zoom) / 2
		end
	end

	return 1 - offsetX, offsetX, 1 - offsetY, offsetY
end

--------------------------------------------------------------------------------
-- Profile
--

local updateProfile
local activeFrameNormal, activeFrameExp = nil, nil
do
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
		textOffsetX = 0,
		textOffsetY = 0,
		timeOffsetX = 0,
		timeOffsetY = 0,
		timeDecimals = 10,
		icon = true,
		iconTooltip = true,
		iconPosition = "LEFT",
		detachedIcon = false,
		iconOffset = 2,
		iconWidthOffset = 0,
		iconZoom = 0.14,
		iconKeepAspectRatio = true,
		fill = false,
		barStyle = "Default",
		borderName = "None",
		borderColor = {0, 0, 0, 1},
		borderOffset = 0,
		borderSize = 1,
		backgroundName = "None",
		backgroundColor = {0, 0, 0, 1},
		emphasize = true,
		emphasizeMove = true,
		emphasizeGrowup = false,
		emphasizeRestart = true,
		emphasizeTime = 11,
		spacing = 1,
		visibleBarLimit = 100,
		visibleBarLimitEmph = 100,
		normalWidth = 180,
		normalHeight = 18,
		normalBarHeightOffset = 0,
		expWidth = 260,
		expHeight = 22,
		expBarHeightOffset = 0,
		spellIndicators = 1023, -- Constants.EncounterTimelineIconMasks.EncounterTimelineAllIcons = 1023
		spellIndicatorsSize = 4,
		spellIndicatorsPosition = "LEFT",
		spellIndicatorsOffset = 2,
		normalPosition = {"CENTER", "CENTER", 450, 200, "UIParent"},
		expPosition = {"CENTER", "CENTER", 0, -100, "UIParent"},
		normalCopyCustomAnchorWidth = false,
		expCopyCustomAnchorWidth = false,
		barStyleMigrated = false, -- XXX temp 12.1.5
	}

	local function HookScriptNormal(self, width)
		if self == activeFrameNormal then
			width = math.floor(width+0.5)
			if width < minBarWidth then
				width = minBarWidth
			elseif width > maxBarWidth then
				width = maxBarWidth
			end
			if width ~= db.normalWidth then
				db.normalWidth = width
				normalAnchor:SetWidth(width)
			end
		end
	end
	local function HookScriptExp(self, width)
		if self == activeFrameExp then
			width = math.floor(width+0.5)
			if width < minBarWidth then
				width = minBarWidth
			elseif width > maxBarWidth then
				width = maxBarWidth
			end
			if width ~= db.expWidth then
				db.expWidth = width
				emphasizeAnchor:SetWidth(width)
			end
		end
	end
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
	local function ValidateColor(current, default, alphaLimit)
		for i = 1, 3 do
			local n = current[i]
			if type(n) ~= "number" or n < 0 or n > 1 then
				current[1] = default[1] -- If 1 entry is bad, reset the whole table
				current[2] = default[2]
				current[3] = default[3]
				current[4] = default[4]
				return
			end
		end
		if alphaLimit then
			if type(current[4]) ~= "number" or current[4] < alphaLimit or current[4] > 1 then
				current[4] = default[4]
			end
		elseif current[4] then
			current[4] = nil
		end
	end
	local hookedFrameNormal, hookedFrameExp = {}, {}
	function updateProfile()
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

		local styleToApply = BigWigsAPI:GetBarStyle(db.barStyle)
		if not styleToApply then
			db.barStyle = plugin.defaultDB.barStyle
			styleToApply = BigWigsAPI:GetBarStyle(db.barStyle)
		end

		if not db.barStyleMigrated then -- XXX temp 12.1.5
			db.barStyleMigrated = true
			if db.barStyle ~= "Default" then
				if type(styleToApply.barHeightOffset) == "number" and styleToApply.barHeightOffset <= 0 and styleToApply.barHeightOffset >= -100 then
					db.normalBarHeightOffset = styleToApply.barHeightOffset
				end
				if type(styleToApply.expBarHeightOffset) == "number" and styleToApply.expBarHeightOffset <= 0 and styleToApply.expBarHeightOffset >= -100 then
					db.expBarHeightOffset = styleToApply.expBarHeightOffset
				end
				if type(styleToApply.borderName) == "string" and LibSharedMedia:IsValid(BORDER, styleToApply.borderName) and (styleToApply.borderName == "None" or BigWigsAPI.IsValidMediaPath(LibSharedMedia:Fetch(BORDER, styleToApply.borderName))) then
					db.borderName = styleToApply.borderName
				end
				if type(styleToApply.borderColor) == "table"
				and type(styleToApply.borderColor[1]) == "number" and styleToApply.borderColor[1] >= 0 and styleToApply.borderColor[1] <= 1
				and type(styleToApply.borderColor[2]) == "number" and styleToApply.borderColor[2] >= 0 and styleToApply.borderColor[2] <= 1
				and type(styleToApply.borderColor[3]) == "number" and styleToApply.borderColor[3] >= 0 and styleToApply.borderColor[3] <= 1
				and type(styleToApply.borderColor[4]) == "number" and styleToApply.borderColor[4] >= 0 and styleToApply.borderColor[4] <= 1 then
					db.borderColor = {
						styleToApply.borderColor[1],
						styleToApply.borderColor[2],
						styleToApply.borderColor[3],
						styleToApply.borderColor[4],
					}
				end
				if type(styleToApply.borderOffset) == "number" and styleToApply.borderOffset >= 0 and styleToApply.borderOffset <= 32 then
					db.borderOffset = styleToApply.borderOffset
				end
				if type(styleToApply.borderSize) == "number" and styleToApply.borderSize >= 1 and styleToApply.borderSize <= 32 then
					db.borderSize = styleToApply.borderSize
				end
				if type(styleToApply.backgroundName) == "string" and LibSharedMedia:IsValid(BACKGROUND, styleToApply.backgroundName) and (styleToApply.backgroundName == "None" or BigWigsAPI.IsValidMediaPath(LibSharedMedia:Fetch(BACKGROUND, styleToApply.backgroundName))) then
					db.backgroundName = styleToApply.backgroundName
				end
				if type(styleToApply.backgroundColor) == "table"
				and type(styleToApply.backgroundColor[1]) == "number" and styleToApply.backgroundColor[1] >= 0 and styleToApply.backgroundColor[1] <= 1
				and type(styleToApply.backgroundColor[2]) == "number" and styleToApply.backgroundColor[2] >= 0 and styleToApply.backgroundColor[2] <= 1
				and type(styleToApply.backgroundColor[3]) == "number" and styleToApply.backgroundColor[3] >= 0 and styleToApply.backgroundColor[3] <= 1
				and type(styleToApply.backgroundColor[4]) == "number" and styleToApply.backgroundColor[4] >= 0 and styleToApply.backgroundColor[4] <= 1 then
					db.backgroundColor = {
						styleToApply.backgroundColor[1],
						styleToApply.backgroundColor[2],
						styleToApply.backgroundColor[3],
						styleToApply.backgroundColor[4],
					}
				end
				if type(styleToApply.detachedIcon) == "boolean" then
					db.detachedIcon = styleToApply.detachedIcon
				end
				if type(styleToApply.iconOffset) == "number" and styleToApply.iconOffset >= 1 and styleToApply.iconOffset <= 100 then
					db.iconOffset = styleToApply.iconOffset
				end
				if type(styleToApply.iconWidthOffset) == "number" and styleToApply.iconWidthOffset >= -50 and styleToApply.iconWidthOffset <= 50 then
					db.iconWidthOffset = styleToApply.iconWidthOffset
				end
				if type(styleToApply.iconZoom) == "number" and styleToApply.iconZoom >= 0 and styleToApply.iconZoom <= 0.5 then
					db.iconZoom = styleToApply.iconZoom
				end
				if type(styleToApply.iconKeepAspectRatio) == "boolean" then
					db.iconKeepAspectRatio = styleToApply.iconKeepAspectRatio
				end
				if type(styleToApply.textOffsetX) == "number" and styleToApply.textOffsetX >= -100 and styleToApply.textOffsetX <= 100 then
					db.textOffsetX = styleToApply.textOffsetX
				end
				if type(styleToApply.textOffsetY) == "number" and styleToApply.textOffsetY >= -100 and styleToApply.textOffsetY <= 100 then
					db.textOffsetY = styleToApply.textOffsetY
				end
				if type(styleToApply.timeOffsetX) == "number" and styleToApply.timeOffsetX >= -100 and styleToApply.timeOffsetX <= 100 then
					db.timeOffsetX = styleToApply.timeOffsetX
				end
				if type(styleToApply.timeOffsetY) == "number" and styleToApply.timeOffsetY >= -100 and styleToApply.timeOffsetY <= 100 then
					db.timeOffsetY = styleToApply.timeOffsetY
				end
				if type(styleToApply.barColor) == "table"
				and type(styleToApply.barColor[1]) == "number" and styleToApply.barColor[1] >= 0 and styleToApply.barColor[1] <= 1
				and type(styleToApply.barColor[2]) == "number" and styleToApply.barColor[2] >= 0 and styleToApply.barColor[2] <= 1
				and type(styleToApply.barColor[3]) == "number" and styleToApply.barColor[3] <= 1 and styleToApply.barColor[3] >= 0
				and type(styleToApply.barColor[4]) == "number" and styleToApply.barColor[4] >= 0 and styleToApply.barColor[4] <= 1 then
					colors.db.profile.barColor.BigWigs_Plugins_Colors.default = {
						styleToApply.barColor[1],
						styleToApply.barColor[2],
						styleToApply.barColor[3],
						styleToApply.barColor[4],
					}
				end
				if type(styleToApply.barEmphasized) == "table"
				and type(styleToApply.barEmphasized[1]) == "number" and styleToApply.barEmphasized[1] >= 0 and styleToApply.barEmphasized[1] <= 1
				and type(styleToApply.barEmphasized[2]) == "number" and styleToApply.barEmphasized[2] >= 0 and styleToApply.barEmphasized[2] <= 1
				and type(styleToApply.barEmphasized[3]) == "number" and styleToApply.barEmphasized[3] >= 0 and styleToApply.barEmphasized[3] <= 1
				and type(styleToApply.barEmphasized[4]) == "number" and styleToApply.barEmphasized[4] >= 0 and styleToApply.barEmphasized[4] <= 1 then
					colors.db.profile.barEmphasized.BigWigs_Plugins_Colors.default = {
						styleToApply.barEmphasized[1],
						styleToApply.barEmphasized[2],
						styleToApply.barEmphasized[3],
						styleToApply.barEmphasized[4],
					}
				end
				if type(styleToApply.barBackground) == "table"
				and type(styleToApply.barBackground[1]) == "number" and styleToApply.barBackground[1] >= 0 and styleToApply.barBackground[1] <= 1
				and type(styleToApply.barBackground[2]) == "number" and styleToApply.barBackground[2] >= 0 and styleToApply.barBackground[2] <= 1
				and type(styleToApply.barBackground[3]) == "number" and styleToApply.barBackground[3] >= 0 and styleToApply.barBackground[3] <= 1
				and type(styleToApply.barBackground[4]) == "number" and styleToApply.barBackground[4] >= 0 and styleToApply.barBackground[4] <= 1 then
					colors.db.profile.barBackground.BigWigs_Plugins_Colors.default = {
						styleToApply.barBackground[1],
						styleToApply.barBackground[2],
						styleToApply.barBackground[3],
						styleToApply.barBackground[4],
					}
				end
			end
		end
		if not LibSharedMedia:IsValid(FONT, db.fontName) or not BigWigsAPI.IsValidMediaPath(LibSharedMedia:Fetch(FONT, db.fontName)) then
			db.fontName = plugin.defaultDB.fontName
		end
		if not LibSharedMedia:IsValid(STATUSBAR, db.texture) or not BigWigsAPI.IsValidMediaPath(LibSharedMedia:Fetch(STATUSBAR, db.texture)) then
			db.texture = plugin.defaultDB.texture
		end
		if not LibSharedMedia:IsValid(BORDER, db.borderName) or (db.borderName ~= "None" and not BigWigsAPI.IsValidMediaPath(LibSharedMedia:Fetch(BORDER, db.borderName))) then
			db.borderName = plugin.defaultDB.borderName -- If the border is suddenly invalid then reset the size and offset also
			db.borderSize = plugin.defaultDB.borderSize
			db.borderOffset = plugin.defaultDB.borderOffset
		end
		ValidateColor(db.borderColor, plugin.defaultDB.borderColor, 0)
		if db.borderOffset < 0 or db.borderOffset > 32 or math.floor(db.borderOffset+0.5) ~= db.borderOffset then
			db.borderOffset = plugin.defaultDB.borderOffset
		end
		if db.borderSize < 1 or db.borderSize > 32 or math.floor(db.borderSize+0.5) ~= db.borderSize then
			db.borderSize = plugin.defaultDB.borderSize
		end
		if not LibSharedMedia:IsValid(BACKGROUND, db.backgroundName) or (db.backgroundName ~= "None" and not BigWigsAPI.IsValidMediaPath(LibSharedMedia:Fetch(BACKGROUND, db.backgroundName))) then
			db.backgroundName = plugin.defaultDB.backgroundName
		end
		ValidateColor(db.backgroundColor, plugin.defaultDB.backgroundColor, 0)
		if db.fontSize < 10 or db.fontSize > 200 or math.floor(db.fontSize+0.5) ~= db.fontSize then
			db.fontSize = plugin.defaultDB.fontSize
		end
		if db.fontSizeEmph < 10 or db.fontSizeEmph > 200 or math.floor(db.fontSizeEmph+0.5) ~= db.fontSizeEmph then
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
		if db.iconOffset < 1 or db.iconOffset > 100 or math.floor(db.iconOffset+0.5) ~= db.iconOffset then
			db.iconOffset = plugin.defaultDB.iconOffset
		end
		if db.iconWidthOffset < -50 or db.iconWidthOffset > 50 or math.floor(db.iconWidthOffset+0.5) ~= db.iconWidthOffset then
			db.iconWidthOffset = plugin.defaultDB.iconWidthOffset
		end
		if db.iconZoom < 0 or db.iconZoom > 0.5 then
			db.iconZoom = plugin.defaultDB.iconZoom
		end
		if db.textOffsetX < -100 or db.textOffsetX > 100 or math.floor(db.textOffsetX+0.5) ~= db.textOffsetX then
			db.textOffsetX = plugin.defaultDB.textOffsetX
		end
		if db.textOffsetY < -100 or db.textOffsetY > 100 or math.floor(db.textOffsetY+0.5) ~= db.textOffsetY then
			db.textOffsetY = plugin.defaultDB.textOffsetY
		end
		if db.timeOffsetX < -100 or db.timeOffsetX > 100 or math.floor(db.timeOffsetX+0.5) ~= db.timeOffsetX then
			db.timeOffsetX = plugin.defaultDB.timeOffsetX
		end
		if db.timeOffsetY < -100 or db.timeOffsetY > 100 or math.floor(db.timeOffsetY+0.5) ~= db.timeOffsetY then
			db.timeOffsetY = plugin.defaultDB.timeOffsetY
		end
		if db.timeDecimals < 0 or db.timeDecimals > 60 or math.floor(db.timeDecimals+0.5) ~= db.timeDecimals then
			db.timeDecimals = plugin.defaultDB.timeDecimals
		end
		if db.emphasizeTime < 6 or db.emphasizeTime > 60 or math.floor(db.emphasizeTime+0.5) ~= db.emphasizeTime then
			db.emphasizeTime = plugin.defaultDB.emphasizeTime
		end
		if db.spacing < 0 or db.spacing > 20 or math.floor(db.spacing+0.5) ~= db.spacing then
			db.spacing = plugin.defaultDB.spacing
		end
		if db.visibleBarLimit < 1 or db.visibleBarLimit > 100 or math.floor(db.visibleBarLimit+0.5) ~= db.visibleBarLimit then
			db.visibleBarLimit = plugin.defaultDB.visibleBarLimit
		end
		if db.visibleBarLimitEmph < 1 or db.visibleBarLimitEmph > 100 or math.floor(db.visibleBarLimitEmph+0.5) ~= db.visibleBarLimitEmph then
			db.visibleBarLimitEmph = plugin.defaultDB.visibleBarLimitEmph
		end
		if db.normalWidth < minBarWidth or db.normalWidth > maxBarWidth or math.floor(db.normalWidth+0.5) ~= db.normalWidth then
			db.normalWidth = plugin.defaultDB.normalWidth
		end
		if db.normalHeight < minBarHeight or db.normalHeight > maxBarHeight or math.floor(db.normalHeight+0.5) ~= db.normalHeight then
			db.normalHeight = plugin.defaultDB.normalHeight
		end
		if db.normalBarHeightOffset < -100 or db.normalBarHeightOffset > 0 or math.floor(db.normalBarHeightOffset+0.5) ~= db.normalBarHeightOffset then
			db.normalBarHeightOffset = plugin.defaultDB.normalBarHeightOffset
		end
		if db.expWidth < minBarWidth or db.expWidth > maxBarWidth or math.floor(db.expWidth+0.5) ~= db.expWidth then
			db.expWidth = plugin.defaultDB.expWidth
		end
		if db.expHeight < minBarHeight or db.expHeight > maxBarHeight or math.floor(db.expHeight+0.5) ~= db.expHeight then
			db.expHeight = plugin.defaultDB.expHeight
		end
		if db.expBarHeightOffset < -100 or db.expBarHeightOffset > 0 or math.floor(db.expBarHeightOffset+0.5) ~= db.expBarHeightOffset then
			db.expBarHeightOffset = plugin.defaultDB.expBarHeightOffset
		end

		if db.spellIndicators < 0 or db.spellIndicators > plugin.defaultDB.spellIndicators or math.floor(db.spellIndicators+0.5) ~= db.spellIndicators then
			db.spellIndicators = plugin.defaultDB.spellIndicators
		end
		if db.spellIndicatorsSize < 1 or db.spellIndicatorsSize > 5 or math.floor(db.spellIndicatorsSize+0.5) ~= db.spellIndicatorsSize then
			db.spellIndicatorsSize = plugin.defaultDB.spellIndicatorsSize
		end
		if db.spellIndicatorsPosition ~= "LEFT" and db.spellIndicatorsPosition ~= "RIGHT" then
			db.spellIndicatorsPosition = plugin.defaultDB.spellIndicatorsPosition
		end
		if db.spellIndicatorsOffset < 0 or db.spellIndicatorsOffset > 100 or math.floor(db.spellIndicatorsOffset+0.5) ~= db.spellIndicatorsOffset then
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
			db.normalCopyCustomAnchorWidth = plugin.defaultDB.normalCopyCustomAnchorWidth
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
		activeFrameNormal = nil
		if db.normalPosition[5] ~= plugin.defaultDB.normalPosition[5] then
			if not BigWigsAPI.IsValidFrame(db.normalPosition[5]) then
				db.normalPosition[1] = plugin.defaultDB.normalPosition[1]
				db.normalPosition[2] = plugin.defaultDB.normalPosition[2]
				db.normalPosition[3] = plugin.defaultDB.normalPosition[3]
				db.normalPosition[4] = plugin.defaultDB.normalPosition[4]
				db.normalPosition[5] = plugin.defaultDB.normalPosition[5]
				db.normalCopyCustomAnchorWidth = plugin.defaultDB.normalCopyCustomAnchorWidth
				db.normalWidth = plugin.defaultDB.normalWidth
			elseif db.normalCopyCustomAnchorWidth then
				local frame = _G[db.normalPosition[5]]
				activeFrameNormal = frame
				if not hookedFrameNormal[frame] then
					hookedFrameNormal[frame] = true
					normalAnchor.HookScript(frame, "OnSizeChanged", HookScriptNormal)
				end

				local width = math.floor(frame:GetWidth()+0.5)
				if width < minBarWidth then
					width = minBarWidth
				elseif width > maxBarWidth then
					width = maxBarWidth
				end
				db.normalWidth = width
			end
		else
			if db.normalCopyCustomAnchorWidth then
				db.normalCopyCustomAnchorWidth = plugin.defaultDB.normalCopyCustomAnchorWidth
				db.normalWidth = plugin.defaultDB.normalWidth
			end
		end

		if not db.emphasizeMove or type(db.expPosition[1]) ~= "string" or type(db.expPosition[2]) ~= "string"
		or type(db.expPosition[3]) ~= "number" or type(db.expPosition[4]) ~= "number"
		or not BigWigsAPI.IsValidFramePoint(db.expPosition[1]) or not BigWigsAPI.IsValidFramePoint(db.expPosition[2]) then
			db.expPosition[1] = plugin.defaultDB.expPosition[1]
			db.expPosition[2] = plugin.defaultDB.expPosition[2]
			db.expPosition[3] = plugin.defaultDB.expPosition[3]
			db.expPosition[4] = plugin.defaultDB.expPosition[4]
			db.expPosition[5] = plugin.defaultDB.expPosition[5]
			if db.expCopyCustomAnchorWidth then
				db.expCopyCustomAnchorWidth = plugin.defaultDB.expCopyCustomAnchorWidth
				db.expWidth = plugin.defaultDB.expWidth
			end
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
		activeFrameExp = nil
		if db.expPosition[5] ~= plugin.defaultDB.expPosition[5] then
			if not BigWigsAPI.IsValidFrame(db.expPosition[5]) then
				db.expPosition[1] = plugin.defaultDB.expPosition[1]
				db.expPosition[2] = plugin.defaultDB.expPosition[2]
				db.expPosition[3] = plugin.defaultDB.expPosition[3]
				db.expPosition[4] = plugin.defaultDB.expPosition[4]
				db.expPosition[5] = plugin.defaultDB.expPosition[5]
				db.expCopyCustomAnchorWidth = plugin.defaultDB.expCopyCustomAnchorWidth
				db.expWidth = plugin.defaultDB.expWidth
			elseif db.expCopyCustomAnchorWidth then
				local frame = _G[db.expPosition[5]]
				activeFrameExp = frame
				if not hookedFrameExp[frame] then
					hookedFrameExp[frame] = true
					emphasizeAnchor.HookScript(frame, "OnSizeChanged", HookScriptExp)
				end

				local width = math.floor(frame:GetWidth()+0.5)
				if width < minBarWidth then
					width = minBarWidth
				elseif width > maxBarWidth then
					width = maxBarWidth
				end
				db.expWidth = width
			end
		else
			if db.expCopyCustomAnchorWidth then
				db.expCopyCustomAnchorWidth = plugin.defaultDB.expCopyCustomAnchorWidth
				db.expWidth = plugin.defaultDB.expWidth
			end
		end

		if not currentBarStyler then currentBarStyler = styleToApply end -- Would be nil the first time the plugin loads
		local previousBarStyler = currentBarStyler -- Clarify intent with a different name

		local normalFunc = normalAnchor:GetScript("OnSizeChanged")
		normalAnchor:SetScript("OnSizeChanged", nil)
		normalAnchor:SetSize(db.normalWidth, db.normalHeight)

		local expFunc = emphasizeAnchor:GetScript("OnSizeChanged")
		emphasizeAnchor:SetScript("OnSizeChanged", nil)
		emphasizeAnchor:SetSize(db.expWidth, db.expHeight)

		normalAnchor:RefixPosition()
		emphasizeAnchor:RefixPosition()

		normalAnchor:SetScript("OnSizeChanged", normalFunc)
		emphasizeAnchor:SetScript("OnSizeChanged", expFunc)

		if inConfigureMode then
			if db.emphasizeMove then
				emphasizeAnchor:Show()
			else
				emphasizeAnchor:Hide()
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
		local font = LibSharedMedia:Fetch(FONT, db.fontName)
		local texture = LibSharedMedia:Fetch(STATUSBAR, db.texture)
		local inset = db.borderName ~= "None" and math.floor(db.borderSize / 4) or 0
		backdropTbl = {
			bgFile = db.backgroundName ~= "None" and LibSharedMedia:Fetch(BACKGROUND, db.backgroundName) or nil,
			edgeFile = db.borderName ~= "None" and LibSharedMedia:Fetch(BORDER, db.borderName) or nil,
			edgeSize = db.borderName ~= "None" and db.borderSize or nil,
			insets = { left = inset, right = inset, top = inset, bottom = inset },
		}

		if not db.emphasizeMove or not db.emphasize then
			for bar in next, emphasizeAnchor.bars do
				normalAnchor.bars[bar] = true
				emphasizeAnchor.bars[bar] = nil
				bar:Set("bigwigs:anchor", "normalPosition")
			end
		else
			for bar in next, normalAnchor.bars do
				if bar:Get("bigwigs:emphasized") then
					normalAnchor.bars[bar] = nil
					emphasizeAnchor.bars[bar] = true
					bar:Set("bigwigs:anchor", "expPosition")
				end
			end
		end

		for bar in next, normalAnchor.bars do
			previousBarStyler.BarStopped(bar)

			local module = bar:Get("bigwigs:module")
			local key = bar:Get("bigwigs:option")
			local height
			if bar:Get("bigwigs:emphasized") and db.emphasize then
				height = db.expHeight
				bar:SetSize(db.expWidth, height)
				bar:SetFont(font, db.fontSizeEmph, flags)
				bar:SetColor(colors:GetColor("barEmphasized", module, key))
			else
				height = db.normalHeight
				bar:SetSize(db.normalWidth, height)
				bar:SetFont(font, db.fontSize, flags)
				bar:SetColor(colors:GetColor("barColor", module, key))
				if bar:Get("bigwigs:emphasized") then
					bar:Set("bigwigs:emphasized", nil)
					bar:SetFrameLevel(100)
				end
				if db.emphasize then
					bar:SetTimeCallback(bar:Get("bigwigs:move"), db.emphasizeTime)
				else
					bar:SetTimeCallback(nil, nil)
				end
			end
			bar:SetTexture(texture)
			bar:SetFill(db.fill)
			bar:SetLabelVisibility(db.text)
			bar.candyBarLabel:SetJustifyH(db.alignText)
			bar:SetTimeVisibility(db.time)
			bar:SetDecimalsThreshold(db.timeDecimals)
			bar.candyBarDuration:SetJustifyH(db.alignTime)
			bar:SetIconVisibility(db.icon)
			bar:SetIconPosition(db.iconPosition)
			bar:SetBackgroundColor(colors:GetColor("barBackground", module, key))
			bar:SetTextColor(colors:GetColor("barText", module, key))
			bar:SetShadowColor(colors:GetColor("barTextShadow", module, key))
			if db.icon and db.iconTooltip and type(key) == "number" and key > 0 then
				bar.candyBarIconFrame.bwID = key
				bar:Set("bigwigs:tooltip", key)
				bar.candyBarIconFrame:SetScript("OnEnter", OnEnterIcon)
				bar.candyBarIconFrame:SetScript("OnLeave", OnLeaveIcon)
				bar.candyBarIconFrame:EnableMouse(not bar:Get("bigwigs:notvisible"))
			elseif bar:Get("bigwigs:tooltip") then
				bar.candyBarIconFrame.bwID = nil
				bar:Set("bigwigs:tooltip", nil)
				bar.candyBarIconFrame:SetScript("OnEnter", nil)
				bar.candyBarIconFrame:SetScript("OnLeave", nil)
				bar.candyBarIconFrame:EnableMouse(false)
			end
			local iconWidth = height
			if db.icon and styleToApply.barDecorationEnabled and db.iconWidthOffset ~= 0 then
				iconWidth = math.max(height + db.iconWidthOffset, 1)
				bar.candyBarIconFrame:SetWidth(iconWidth)
			end
			local barHeightOffset = 0
			if db.icon and db.detachedIcon then
				barHeightOffset = bar:Get("bigwigs:emphasized") and db.expBarHeightOffset or db.normalBarHeightOffset
				if -barHeightOffset >= height then
					barHeightOffset = 0
				end
				bar.candyBarIconFrame:ClearAllPoints()
				bar.candyBarBar:ClearAllPoints()
				if db.iconPosition == "LEFT" then
					bar.candyBarIconFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", -db.iconOffset, 0)
					bar.candyBarIconFrame:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", -db.iconOffset, 0)
					bar.candyBarBar:SetPoint("TOPLEFT", bar, "TOPLEFT", iconWidth, barHeightOffset)
					bar.candyBarBar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", iconWidth, 0)
					bar.candyBarBar:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, barHeightOffset)
					bar.candyBarBar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
				else
					bar.candyBarIconFrame:SetPoint("TOPRIGHT", bar, "TOPRIGHT", db.iconOffset, 0)
					bar.candyBarIconFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", db.iconOffset, 0)
					bar.candyBarBar:SetPoint("TOPRIGHT", bar, "TOPRIGHT", -iconWidth, barHeightOffset)
					bar.candyBarBar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -iconWidth, 0)
					bar.candyBarBar:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, barHeightOffset)
					bar.candyBarBar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
				end
			elseif db.icon and styleToApply.barDecorationEnabled and db.iconWidthOffset ~= 0 then
				bar.candyBarBar:ClearAllPoints()
				if db.iconPosition == "LEFT" then
					bar.candyBarBar:SetPoint("TOPLEFT", bar, "TOPLEFT", iconWidth, 0)
					bar.candyBarBar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", iconWidth, 0)
					bar.candyBarBar:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
					bar.candyBarBar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
				else
					bar.candyBarBar:SetPoint("TOPRIGHT", bar, "TOPRIGHT", -iconWidth, 0)
					bar.candyBarBar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -iconWidth, 0)
					bar.candyBarBar:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
					bar.candyBarBar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
				end
			end
			-- For SetJustifyH to update, it requires a SetText with different text.
			-- So we store the value, reset the text, and set it again.
			local labelText = bar:GetLabel()
			bar.candyBarLabel:ClearText()
			bar.candyBarLabel:ClearAllPoints()
			bar.candyBarLabel:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2 + db.textOffsetX, -barHeightOffset / 2 + db.textOffsetY)
			bar.candyBarLabel:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2 + db.textOffsetX, barHeightOffset / 2 + db.textOffsetY)
			bar:SetLabel(labelText)
			bar.candyBarDuration:ClearAllPoints()
			bar.candyBarDuration:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2 + db.timeOffsetX, -barHeightOffset / 2 + db.timeOffsetY)
			bar.candyBarDuration:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2 + db.timeOffsetX, barHeightOffset / 2 + db.timeOffsetY)
			local indicatorFrame = bar:Get("bigwigs:indicatorFrame")
			if indicatorFrame then
				indicatorFrame:ClearTextures()
				indicatorFrame:SetIndicatorSize(height)
				indicatorFrame:AddIndicators(bar:Get("bigwigs:indicators"))
			end
			if db.borderName ~= "None" or db.backgroundName ~= "None" then
				local border = bar.candyBarBackdrop
				border:ClearAllPoints()
				local borderOffset = db.borderName ~= "None" and db.borderOffset or 0
				if db.icon and db.detachedIcon then
					border:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", -borderOffset, borderOffset)
					border:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", borderOffset, -borderOffset)
					local iconBorder = bar.candyBarIconFrameBackdrop
					iconBorder:ClearAllPoints()
					if db.iconPosition == "LEFT" then
						iconBorder:SetPoint("TOPLEFT", bar, "TOPLEFT", -db.iconOffset - borderOffset, borderOffset)
						iconBorder:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -db.iconOffset + iconWidth + borderOffset, -borderOffset)
					else
						iconBorder:SetPoint("TOPLEFT", bar, "TOPRIGHT", db.iconOffset - iconWidth - borderOffset, borderOffset)
						iconBorder:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", db.iconOffset + borderOffset, -borderOffset)
					end
					iconBorder:Show()
					iconBorder:SetBackdrop(backdropTbl)
					if db.backgroundName ~= "None" then
						iconBorder:SetBackdropColor(db.backgroundColor[1], db.backgroundColor[2], db.backgroundColor[3], db.backgroundColor[4])
					end
					if db.borderName ~= "None" then
						iconBorder:SetBackdropBorderColor(db.borderColor[1], db.borderColor[2], db.borderColor[3], db.borderColor[4])
					end
				else
					bar.candyBarIconFrameBackdrop:ClearBackdrop()
					bar.candyBarIconFrameBackdrop:Hide()
					border:SetPoint("TOPLEFT", bar, "TOPLEFT", -borderOffset, borderOffset)
					border:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", borderOffset, -borderOffset)
				end
				border:Show()
				border:SetBackdrop(backdropTbl)
				if db.backgroundName ~= "None" then
					border:SetBackdropColor(db.backgroundColor[1], db.backgroundColor[2], db.backgroundColor[3], db.backgroundColor[4])
				end
				if db.borderName ~= "None" then
					border:SetBackdropBorderColor(db.borderColor[1], db.borderColor[2], db.borderColor[3], db.borderColor[4])
				end
			else
				bar.candyBarBackdrop:ClearBackdrop()
				bar.candyBarBackdrop:Hide()
				bar.candyBarIconFrameBackdrop:ClearBackdrop()
				bar.candyBarIconFrameBackdrop:Hide()
			end
			styleToApply.ApplyStyle(bar)
			bar.candyBarIconFrame:SetTexCoord(GetIconTexCoord(iconWidth, height))
		end

		for bar in next, emphasizeAnchor.bars do
			previousBarStyler.BarStopped(bar)

			local module = bar:Get("bigwigs:module")
			local key = bar:Get("bigwigs:option")
			bar:SetSize(db.expWidth, db.expHeight)
			bar:SetTexture(texture)
			bar:SetFill(db.fill)
			bar:SetFont(font, db.fontSizeEmph, flags)
			bar:SetLabelVisibility(db.text)
			bar.candyBarLabel:SetJustifyH(db.alignText)
			bar:SetTimeVisibility(db.time)
			bar:SetDecimalsThreshold(db.timeDecimals)
			bar.candyBarDuration:SetJustifyH(db.alignTime)
			bar:SetIconVisibility(db.icon)
			bar:SetIconPosition(db.iconPosition)
			bar:SetColor(colors:GetColor("barEmphasized", module, key))
			bar:SetBackgroundColor(colors:GetColor("barBackground", module, key))
			bar:SetTextColor(colors:GetColor("barText", module, key))
			bar:SetShadowColor(colors:GetColor("barTextShadow", module, key))
			if db.icon and db.iconTooltip and type(key) == "number" and key > 0 then
				bar.candyBarIconFrame.bwID = key
				bar:Set("bigwigs:tooltip", key)
				bar.candyBarIconFrame:SetScript("OnEnter", OnEnterIcon)
				bar.candyBarIconFrame:SetScript("OnLeave", OnLeaveIcon)
				bar.candyBarIconFrame:EnableMouse(not bar:Get("bigwigs:notvisible"))
			elseif bar:Get("bigwigs:tooltip") then
				bar.candyBarIconFrame.bwID = nil
				bar:Set("bigwigs:tooltip", nil)
				bar.candyBarIconFrame:SetScript("OnEnter", nil)
				bar.candyBarIconFrame:SetScript("OnLeave", nil)
				bar.candyBarIconFrame:EnableMouse(false)
			end
			local iconWidth = db.expHeight
			if db.icon and styleToApply.barDecorationEnabled and db.iconWidthOffset ~= 0 then
				iconWidth = math.max(db.expHeight + db.iconWidthOffset, 1)
				bar.candyBarIconFrame:SetWidth(iconWidth)
			end
			local barHeightOffset = 0
			if db.icon and db.detachedIcon then
				barHeightOffset = db.expBarHeightOffset
				if -barHeightOffset >= db.expHeight then
					barHeightOffset = 0
				end
				bar.candyBarIconFrame:ClearAllPoints()
				bar.candyBarBar:ClearAllPoints()
				if db.iconPosition == "LEFT" then
					bar.candyBarIconFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", -db.iconOffset, 0)
					bar.candyBarIconFrame:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", -db.iconOffset, 0)
					bar.candyBarBar:SetPoint("TOPLEFT", bar, "TOPLEFT", iconWidth, barHeightOffset)
					bar.candyBarBar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", iconWidth, 0)
					bar.candyBarBar:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, barHeightOffset)
					bar.candyBarBar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
				else
					bar.candyBarIconFrame:SetPoint("TOPRIGHT", bar, "TOPRIGHT", db.iconOffset, 0)
					bar.candyBarIconFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", db.iconOffset, 0)
					bar.candyBarBar:SetPoint("TOPRIGHT", bar, "TOPRIGHT", -iconWidth, barHeightOffset)
					bar.candyBarBar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -iconWidth, 0)
					bar.candyBarBar:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, barHeightOffset)
					bar.candyBarBar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
				end
			elseif db.icon and styleToApply.barDecorationEnabled and db.iconWidthOffset ~= 0 then
				bar.candyBarBar:ClearAllPoints()
				if db.iconPosition == "LEFT" then
					bar.candyBarBar:SetPoint("TOPLEFT", bar, "TOPLEFT", iconWidth, 0)
					bar.candyBarBar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", iconWidth, 0)
					bar.candyBarBar:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
					bar.candyBarBar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
				else
					bar.candyBarBar:SetPoint("TOPRIGHT", bar, "TOPRIGHT", -iconWidth, 0)
					bar.candyBarBar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -iconWidth, 0)
					bar.candyBarBar:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
					bar.candyBarBar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
				end
			end
			-- For SetJustifyH to update, it requires a SetText with different text.
			-- So we store the value, reset the text, and set it again.
			local labelText = bar:GetLabel()
			bar.candyBarLabel:ClearText()
			bar.candyBarLabel:ClearAllPoints()
			bar.candyBarLabel:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2 + db.textOffsetX, -barHeightOffset / 2 + db.textOffsetY)
			bar.candyBarLabel:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2 + db.textOffsetX, barHeightOffset / 2 + db.textOffsetY)
			bar:SetLabel(labelText)
			bar.candyBarDuration:ClearAllPoints()
			bar.candyBarDuration:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2 + db.timeOffsetX, -barHeightOffset / 2 + db.timeOffsetY)
			bar.candyBarDuration:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2 + db.timeOffsetX, barHeightOffset / 2 + db.timeOffsetY)
			local indicatorFrame = bar:Get("bigwigs:indicatorFrame")
			if indicatorFrame then
				indicatorFrame:ClearTextures()
				indicatorFrame:SetIndicatorSize(db.expHeight)
				indicatorFrame:AddIndicators(bar:Get("bigwigs:indicators"))
			end
			if db.borderName ~= "None" or db.backgroundName ~= "None" then
				local border = bar.candyBarBackdrop
				border:ClearAllPoints()
				local borderOffset = db.borderName ~= "None" and db.borderOffset or 0
				if db.icon and db.detachedIcon then
					border:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", -borderOffset, borderOffset)
					border:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", borderOffset, -borderOffset)
					local iconBorder = bar.candyBarIconFrameBackdrop
					iconBorder:ClearAllPoints()
					if db.iconPosition == "LEFT" then
						iconBorder:SetPoint("TOPLEFT", bar, "TOPLEFT", -db.iconOffset - borderOffset, borderOffset)
						iconBorder:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -db.iconOffset + iconWidth + borderOffset, -borderOffset)
					else
						iconBorder:SetPoint("TOPLEFT", bar, "TOPRIGHT", db.iconOffset - iconWidth - borderOffset, borderOffset)
						iconBorder:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", db.iconOffset + borderOffset, -borderOffset)
					end
					iconBorder:Show()
					iconBorder:SetBackdrop(backdropTbl)
					if db.backgroundName ~= "None" then
						iconBorder:SetBackdropColor(db.backgroundColor[1], db.backgroundColor[2], db.backgroundColor[3], db.backgroundColor[4])
					end
					if db.borderName ~= "None" then
						iconBorder:SetBackdropBorderColor(db.borderColor[1], db.borderColor[2], db.borderColor[3], db.borderColor[4])
					end
				else
					bar.candyBarIconFrameBackdrop:ClearBackdrop()
					bar.candyBarIconFrameBackdrop:Hide()
					border:SetPoint("TOPLEFT", bar, "TOPLEFT", -borderOffset, borderOffset)
					border:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", borderOffset, -borderOffset)
				end
				border:Show()
				border:SetBackdrop(backdropTbl)
				if db.backgroundName ~= "None" then
					border:SetBackdropColor(db.backgroundColor[1], db.backgroundColor[2], db.backgroundColor[3], db.backgroundColor[4])
				end
				if db.borderName ~= "None" then
					border:SetBackdropBorderColor(db.borderColor[1], db.borderColor[2], db.borderColor[3], db.borderColor[4])
				end
			else
				bar.candyBarBackdrop:ClearBackdrop()
				bar.candyBarBackdrop:Hide()
				bar.candyBarIconFrameBackdrop:ClearBackdrop()
				bar.candyBarIconFrameBackdrop:Hide()
			end
			styleToApply.ApplyStyle(bar)
			bar.candyBarIconFrame:SetTexCoord(GetIconTexCoord(iconWidth, db.expHeight))
		end

		currentBarStyler = styleToApply -- Always swap AFTER everything has been applied

		UpdateAllIndicatorPoints()

		rearrangeBars(normalAnchor)
		rearrangeBars(emphasizeAnchor)
	end
end

--------------------------------------------------------------------------------
-- Options
--

do
	local testCount = 0
	local testIcons = {
		"Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_legacy.tga",
		"Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid.tga",
		"Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_party.tga",
	}
	local function HiddenOnRetail() return not BigWigsLoader.isRetail end
	local function IsNormalAnchorPointDefault() return db.normalPosition[5] == plugin.defaultDB.normalPosition[5] end
	local function IsExpAnchorPointDefault()
		if not db.emphasize then
			return true
		end
		if not db.emphasizeMove then
			return IsNormalAnchorPointDefault()
		end
		return db.expPosition[5] == plugin.defaultDB.expPosition[5]
	end
	local function IsEmphasizeDisabled() return not db.emphasize end
	local function IsBarDecorationDisabled() return not currentBarStyler.barDecorationEnabled end
	local function IsBarDecorationDisabledOrBorderSetToNone() return not currentBarStyler.barDecorationEnabled or db.borderName == "None" end
	local function IsBarDecorationDisabledOrBackgroundSetToNone() return not currentBarStyler.barDecorationEnabled or db.backgroundName == "None" end
	local function IsBarDecorationDisabledOrTextDisabled() return not db.text or not currentBarStyler.barDecorationEnabled end
	local function IsBarDecorationDisabledOrTimeDisabled() return not db.time or not currentBarStyler.barDecorationEnabled end
	local function IsBarDecorationDisabledOrIconDisabled() return not db.icon or not currentBarStyler.barDecorationEnabled end
	local function IsDetachedIconDisabled() return not db.icon or not db.detachedIcon or not currentBarStyler.barDecorationEnabled end

	local inTestMode = false
	local StartTest, StopTest
	do
		local timer = nil
		local function QueueEditModeEvents()
			local duration = C_EncounterTimeline.AddEditModeEvents()
			timer = plugin:ScheduleTimer(QueueEditModeEvents, duration)
		end

		function StartTest()
			inTestMode = true
			if not timer then
				QueueEditModeEvents()
			end
		end

		function StopTest()
			inTestMode = false
			if timer then
				plugin:CancelTimer(timer)
				timer = nil
				C_EncounterTimeline.CancelEditModeEvents()
			end
		end
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
			testButton = BigWigsLoader.isRetail and {
				type = "execute",
				name = function()
					if inTestMode then
						return L.stopTest
					else
						return L.startTest
					end
				end,
				func = function()
					if inTestMode then
						StopTest()
					else
						StartTest()
					end
				end,
				width = 1.5,
				order = 0.4,
			} or {
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
					barStyle = {
						type = "select",
						name = L.style,
						order = 1,
						width = 1,
						values = function() return BigWigsAPI:GetBarStyleList() end,
						set = function(info, value)
							db[info[#info]] = value
							local style = BigWigsAPI:GetBarStyle(value)
							if style then
								if type(style.barSpacing) == "number" and style.barSpacing >= 0 and style.barSpacing <= 20 then
									db.spacing = style.barSpacing
								else
									db.spacing = plugin.defaultDB.spacing
								end
								if type(style.barHeight) == "number" and style.barHeight >= minBarHeight and style.barHeight <= maxBarHeight then
									db.normalHeight = style.barHeight
								else
									db.normalHeight = plugin.defaultDB.normalHeight
								end
								if type(style.expBarHeight) == "number" and style.expBarHeight >= minBarHeight and style.expBarHeight <= maxBarHeight then
									db.expHeight = style.expBarHeight
								else
									db.expHeight = plugin.defaultDB.expHeight
								end
								if type(style.barHeightOffset) == "number" and style.barHeightOffset <= 0 and style.barHeightOffset >= -100 then
									db.normalBarHeightOffset = style.barHeightOffset
								else
									db.normalBarHeightOffset = plugin.defaultDB.normalBarHeightOffset
								end
								if type(style.expBarHeightOffset) == "number" and style.expBarHeightOffset <= 0 and style.expBarHeightOffset >= -100 then
									db.expBarHeightOffset = style.expBarHeightOffset
								else
									db.expBarHeightOffset = plugin.defaultDB.expBarHeightOffset
								end
								if type(style.fontSizeNormal) == "number" and style.fontSizeNormal >= 10 and style.fontSizeNormal <= 200 then
									db.fontSize = style.fontSizeNormal
								else
									db.fontSize = plugin.defaultDB.fontSize
								end
								if type(style.fontSizeEmphasized) == "number" and style.fontSizeEmphasized >= 10 and style.fontSizeEmphasized <= 200 then
									db.fontSizeEmph = style.fontSizeEmphasized
								else
									db.fontSizeEmph = plugin.defaultDB.fontSizeEmph
								end
								if type(style.fontOutline) == "string" and (style.fontOutline == "NONE" or style.fontOutline == "OUTLINE" or style.fontOutline == "THICKOUTLINE") then
									db.outline = style.fontOutline
								else
									db.outline = plugin.defaultDB.outline
								end
								if type(style.monochrome) == "boolean" then
									db.monochrome = style.monochrome
								else
									db.monochrome = plugin.defaultDB.monochrome
								end
								if type(style.fill) == "boolean" then
									db.fill = style.fill
								else
									db.fill = plugin.defaultDB.fill
								end
								if type(style.borderName) == "string" and LibSharedMedia:IsValid(BORDER, style.borderName) and (style.borderName == "None" or BigWigsAPI.IsValidMediaPath(LibSharedMedia:Fetch(BORDER, style.borderName))) then
									db.borderName = style.borderName
								else
									db.borderName = plugin.defaultDB.borderName
								end
								if type(style.borderColor) == "table"
								and type(style.borderColor[1]) == "number" and style.borderColor[1] >= 0 and style.borderColor[1] <= 1
								and type(style.borderColor[2]) == "number" and style.borderColor[2] >= 0 and style.borderColor[2] <= 1
								and type(style.borderColor[3]) == "number" and style.borderColor[3] >= 0 and style.borderColor[3] <= 1
								and type(style.borderColor[4]) == "number" and style.borderColor[4] >= 0 and style.borderColor[4] <= 1 then
									db.borderColor = {
										style.borderColor[1],
										style.borderColor[2],
										style.borderColor[3],
										style.borderColor[4],
									}
								else
									db.borderColor = {
										plugin.defaultDB.borderColor[1],
										plugin.defaultDB.borderColor[2],
										plugin.defaultDB.borderColor[3],
										plugin.defaultDB.borderColor[4],
									}
								end
								if type(style.borderOffset) == "number" and style.borderOffset >= 0 and style.borderOffset <= 32 then
									db.borderOffset = style.borderOffset
								else
									db.borderOffset = plugin.defaultDB.borderOffset
								end
								if type(style.borderSize) == "number" and style.borderSize >= 1 and style.borderSize <= 32 then
									db.borderSize = style.borderSize
								else
									db.borderSize = plugin.defaultDB.borderSize
								end
								if type(style.backgroundName) == "string" and LibSharedMedia:IsValid(BACKGROUND, style.backgroundName) and (style.backgroundName == "None" or BigWigsAPI.IsValidMediaPath(LibSharedMedia:Fetch(BACKGROUND, style.backgroundName))) then
									db.backgroundName = style.backgroundName
								else
									db.backgroundName = plugin.defaultDB.backgroundName
								end
								if type(style.backgroundColor) == "table"
								and type(style.backgroundColor[1]) == "number" and style.backgroundColor[1] >= 0 and style.backgroundColor[1] <= 1
								and type(style.backgroundColor[2]) == "number" and style.backgroundColor[2] >= 0 and style.backgroundColor[2] <= 1
								and type(style.backgroundColor[3]) == "number" and style.backgroundColor[3] >= 0 and style.backgroundColor[3] <= 1
								and type(style.backgroundColor[4]) == "number" and style.backgroundColor[4] >= 0 and style.backgroundColor[4] <= 1 then
									db.backgroundColor = {
										style.backgroundColor[1],
										style.backgroundColor[2],
										style.backgroundColor[3],
										style.backgroundColor[4],
									}
								else
									db.backgroundColor = {
										plugin.defaultDB.backgroundColor[1],
										plugin.defaultDB.backgroundColor[2],
										plugin.defaultDB.backgroundColor[3],
										plugin.defaultDB.backgroundColor[4],
									}
								end
								if type(style.icon) == "boolean" then
									db.icon = style.icon
								else
									db.icon = plugin.defaultDB.icon
								end
								if type(style.detachedIcon) == "boolean" then
									db.detachedIcon = style.detachedIcon
								else
									db.detachedIcon = plugin.defaultDB.detachedIcon
								end
								if type(style.iconOffset) == "number" and style.iconOffset >= 1 and style.iconOffset <= 100 then
									db.iconOffset = style.iconOffset
								else
									db.iconOffset = plugin.defaultDB.iconOffset
								end
								if type(style.iconWidthOffset) == "number" and style.iconWidthOffset >= -50 and style.iconWidthOffset <= 50 then
									db.iconWidthOffset = style.iconWidthOffset
								else
									db.iconWidthOffset = plugin.defaultDB.iconWidthOffset
								end
								if type(style.iconZoom) == "number" and style.iconZoom >= 0 and style.iconZoom <= 0.5 then
									db.iconZoom = style.iconZoom
								else
									db.iconZoom = plugin.defaultDB.iconZoom
								end
								if type(style.iconKeepAspectRatio) == "boolean" then
									db.iconKeepAspectRatio = style.iconKeepAspectRatio
								else
									db.iconKeepAspectRatio = plugin.defaultDB.iconKeepAspectRatio
								end
								if style.alignText == "LEFT" or style.alignText == "CENTER" or style.alignText == "RIGHT" then
									db.alignText = style.alignText
								else
									db.alignText = plugin.defaultDB.alignText
								end
								if style.alignTime == "LEFT" or style.alignTime == "CENTER" or style.alignTime == "RIGHT" then
									db.alignTime = style.alignTime
								else
									db.alignTime = plugin.defaultDB.alignTime
								end
								if type(style.textOffsetX) == "number" and style.textOffsetX >= -100 and style.textOffsetX <= 100 then
									db.textOffsetX = style.textOffsetX
								else
									db.textOffsetX = plugin.defaultDB.textOffsetX
								end
								if type(style.textOffsetY) == "number" and style.textOffsetY >= -100 and style.textOffsetY <= 100 then
									db.textOffsetY = style.textOffsetY
								else
									db.textOffsetY = plugin.defaultDB.textOffsetY
								end
								if type(style.timeOffsetX) == "number" and style.timeOffsetX >= -100 and style.timeOffsetX <= 100 then
									db.timeOffsetX = style.timeOffsetX
								else
									db.timeOffsetX = plugin.defaultDB.timeOffsetX
								end
								if type(style.timeOffsetY) == "number" and style.timeOffsetY >= -100 and style.timeOffsetY <= 100 then
									db.timeOffsetY = style.timeOffsetY
								else
									db.timeOffsetY = plugin.defaultDB.timeOffsetY
								end
								if type(style.spellIndicatorsOffset) == "number" and style.spellIndicatorsOffset >= 0 and style.spellIndicatorsOffset <= 100 then
									db.spellIndicatorsOffset = style.spellIndicatorsOffset
								else
									db.spellIndicatorsOffset = plugin.defaultDB.spellIndicatorsOffset
								end
								if type(style.spellIndicatorsSize) == "number" and style.spellIndicatorsSize >= 1 and style.spellIndicatorsSize <= 5 then
									db.spellIndicatorsSize = style.spellIndicatorsSize
								else
									db.spellIndicatorsSize = plugin.defaultDB.spellIndicatorsSize
								end
								if style.iconPosition == "RIGHT" then
									db.iconPosition = style.iconPosition
								else
									db.iconPosition = plugin.defaultDB.iconPosition
								end
								if style.spellIndicatorsPosition == "RIGHT" then
									db.spellIndicatorsPosition = style.spellIndicatorsPosition
								else
									db.spellIndicatorsPosition = plugin.defaultDB.spellIndicatorsPosition
								end
								if type(style.fontName) == "string" and LibSharedMedia:IsValid(FONT, style.fontName) and BigWigsAPI.IsValidMediaPath(LibSharedMedia:Fetch(FONT, style.fontName)) then
									db.fontName = style.fontName
								else
									db.fontName = plugin.defaultDB.fontName
								end
								if type(style.texture) == "string" and LibSharedMedia:IsValid(STATUSBAR, style.texture) and BigWigsAPI.IsValidMediaPath(LibSharedMedia:Fetch(STATUSBAR, style.texture)) then
									db.texture = style.texture
								else
									db.texture = plugin.defaultDB.texture
								end
								if type(style.barColor) == "table"
								and type(style.barColor[1]) == "number" and style.barColor[1] >= 0 and style.barColor[1] <= 1
								and type(style.barColor[2]) == "number" and style.barColor[2] >= 0 and style.barColor[2] <= 1
								and type(style.barColor[3]) == "number" and style.barColor[3] <= 1 and style.barColor[3] >= 0
								and type(style.barColor[4]) == "number" and style.barColor[4] >= 0 and style.barColor[4] <= 1 then
									colors.db.profile.barColor.BigWigs_Plugins_Colors.default = {
										style.barColor[1],
										style.barColor[2],
										style.barColor[3],
										style.barColor[4],
									}
								else
									colors.db.profile.barColor.BigWigs_Plugins_Colors.default = nil
								end
								if type(style.barEmphasized) == "table"
								and type(style.barEmphasized[1]) == "number" and style.barEmphasized[1] >= 0 and style.barEmphasized[1] <= 1
								and type(style.barEmphasized[2]) == "number" and style.barEmphasized[2] >= 0 and style.barEmphasized[2] <= 1
								and type(style.barEmphasized[3]) == "number" and style.barEmphasized[3] >= 0 and style.barEmphasized[3] <= 1
								and type(style.barEmphasized[4]) == "number" and style.barEmphasized[4] >= 0 and style.barEmphasized[4] <= 1 then
									colors.db.profile.barEmphasized.BigWigs_Plugins_Colors.default = {
										style.barEmphasized[1],
										style.barEmphasized[2],
										style.barEmphasized[3],
										style.barEmphasized[4],
									}
								else
									colors.db.profile.barEmphasized.BigWigs_Plugins_Colors.default = nil
								end
								if type(style.barBackground) == "table"
								and type(style.barBackground[1]) == "number" and style.barBackground[1] >= 0 and style.barBackground[1] <= 1
								and type(style.barBackground[2]) == "number" and style.barBackground[2] >= 0 and style.barBackground[2] <= 1
								and type(style.barBackground[3]) == "number" and style.barBackground[3] >= 0 and style.barBackground[3] <= 1
								and type(style.barBackground[4]) == "number" and style.barBackground[4] >= 0 and style.barBackground[4] <= 1 then
									colors.db.profile.barBackground.BigWigs_Plugins_Colors.default = {
										style.barBackground[1],
										style.barBackground[2],
										style.barBackground[3],
										style.barBackground[4],
									}
								else
									colors.db.profile.barBackground.BigWigs_Plugins_Colors.default = nil
								end
							end
							updateProfile()
							plugin:UpdateGUI()
						end,
					},
					spacing = {
						type = "range",
						name = L.spacing,
						desc = L.spacingDesc,
						order = 2,
						min = 0,
						max = 20,
						step = 1,
						width = 1,
					},
					fill = {
						type = "toggle",
						name = L.fill,
						desc = L.fillDesc,
						order = 3,
						width = 1,
					},
					texture = {
						type = "select",
						name = L.texture,
						order = 4,
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
					borderSpacer = {
						type = "description",
						name = "\n\n",
						order = 5,
						width = "full",
					},
					borderHeader = {
						type = "header",
						name = L.border,
						order = 6,
					},
					borderName = {
						type = "select",
						name = L.borderName,
						order = 7,
						values = LibSharedMedia:List(BORDER),
						get = function()
							for i, v in next, LibSharedMedia:List(BORDER) do
								if v == db.borderName then return i end
							end
						end,
						set = function(_, value)
							local list = LibSharedMedia:List(BORDER)
							db.borderName = list[value]
							updateProfile()
						end,
						width = 1.5,
						disabled = IsBarDecorationDisabled,
					},
					borderColor = {
						type = "color",
						name = L.borderColor,
						order = 8,
						hasAlpha = true,
						width = 1.5,
						get = function()
							return db.borderColor[1], db.borderColor[2], db.borderColor[3], db.borderColor[4]
						end,
						set = function(_, r, g, b, a)
							db.borderColor = {r, g, b, a}
							updateProfile()
						end,
						disabled = IsBarDecorationDisabledOrBorderSetToNone,
					},
					borderSize = {
						type = "range",
						name = L.borderSize,
						order = 9,
						min = 1,
						max = 32,
						step = 1,
						width = 1.5,
						disabled = IsBarDecorationDisabledOrBorderSetToNone,
					},
					borderOffset = {
						type = "range",
						name = L.borderOffset,
						order = 10,
						min = 0,
						max = 32,
						step = 1,
						width = 1.5,
						disabled = IsBarDecorationDisabledOrBorderSetToNone,
					},
					backgroundSpacer = {
						type = "description",
						name = "\n\n",
						order = 11,
						width = "full",
					},
					backgroundHeader = {
						type = "header",
						name = L.background,
						order = 12,
					},
					backgroundName = {
						type = "select",
						name = L.background,
						order = 13,
						values = LibSharedMedia:List(BACKGROUND),
						get = function()
							for i, v in next, LibSharedMedia:List(BACKGROUND) do
								if v == db.backgroundName then return i end
							end
						end,
						set = function(_, value)
							local list = LibSharedMedia:List(BACKGROUND)
							db.backgroundName = list[value]
							updateProfile()
						end,
						width = 1.5,
						disabled = IsBarDecorationDisabled,
					},
					backgroundColor = {
						type = "color",
						name = L.backgroundColor,
						order = 14,
						hasAlpha = true,
						width = 1.5,
						get = function()
							return db.backgroundColor[1], db.backgroundColor[2], db.backgroundColor[3], db.backgroundColor[4]
						end,
						set = function(_, r, g, b, a)
							db.backgroundColor = {r, g, b, a}
							updateProfile()
						end,
						disabled = IsBarDecorationDisabledOrBackgroundSetToNone,
					},
					resetSpacer = {
						type = "description",
						name = "\n\n",
						order = 15,
						width = "full",
					},
					resetHeader = {
						type = "header",
						name = "",
						order = 16,
					},
					reset = {
						type = "execute",
						name = L.reset,
						desc = L.resetDesc,
						func = function()
							db.barStyle = plugin.defaultDB.barStyle
							db.spacing = plugin.defaultDB.spacing
							db.fill = plugin.defaultDB.fill
							db.texture = plugin.defaultDB.texture
							db.borderName = plugin.defaultDB.borderName
							db.borderColor = {
								plugin.defaultDB.borderColor[1],
								plugin.defaultDB.borderColor[2],
								plugin.defaultDB.borderColor[3],
								plugin.defaultDB.borderColor[4],
							}
							db.borderSize = plugin.defaultDB.borderSize
							db.borderOffset = plugin.defaultDB.borderOffset
							db.backgroundName = plugin.defaultDB.backgroundName
							db.backgroundColor = {
								plugin.defaultDB.backgroundColor[1],
								plugin.defaultDB.backgroundColor[2],
								plugin.defaultDB.backgroundColor[3],
								plugin.defaultDB.backgroundColor[4],
							}
							colors.db.profile.barColor.BigWigs_Plugins_Colors.default = nil
							colors.db.profile.barEmphasized.BigWigs_Plugins_Colors.default = nil
							colors.db.profile.barBackground.BigWigs_Plugins_Colors.default = nil
							updateProfile()
						end,
						order = 17,
					},
					resetAll = {
						type = "execute",
						name = L.resetAll,
						desc = L.resetAllDesc:format(L.bars),
						func = function()
							plugin.db:ResetProfile()
							-- Since we are resetting the bar style, we also need to reset the colors that those styles might have changed
							colors.db.profile.barColor.BigWigs_Plugins_Colors.default = nil
							colors.db.profile.barEmphasized.BigWigs_Plugins_Colors.default = nil
							colors.db.profile.barBackground.BigWigs_Plugins_Colors.default = nil
							updateProfile()
						end,
						order = 18,
					},
				},
			},
			text = {
				type = "group",
				name = L.text,
				order = 2,
				args = {
					fontName = {
						type = "select",
						name = L.font,
						order = 1,
						width = 1,
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
						width = 1,
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
						width = 1,
					},
					textSpacer = {
						type = "description",
						name = "\n\n",
						order = 4,
						width = "full",
					},
					textHeader = {
						type = "header",
						name = L.text,
						order = 5,
					},
					text = {
						type = "toggle",
						name = L.text,
						desc = L.textDesc,
						order = 6,
						width = 1.5,
					},
					alignText = {
						type = "select",
						name = L.alignText,
						order = 7,
						width = 1.5,
						values = {
							LEFT = L.LEFT,
							CENTER = L.CENTER,
							RIGHT = L.RIGHT,
						},
						set = function(_, value)
							db.alignText = value
							db.textOffsetX = plugin.defaultDB.textOffsetX
							updateProfile()
						end,
						disabled = function() return not db.text end,
					},
					textOffsetX = {
						type = "range",
						name = L.positionX,
						desc = L.positionDesc,
						order = 8,
						width = 1.5,
						min = -100,
						max = 100,
						step = 1,
						disabled = IsBarDecorationDisabledOrTextDisabled,
					},
					textOffsetY = {
						type = "range",
						name = L.positionY,
						desc = L.positionDesc,
						order = 9,
						width = 1.5,
						min = -100,
						max = 100,
						step = 1,
						disabled = IsBarDecorationDisabledOrTextDisabled,
					},
					timeSpacer = {
						type = "description",
						name = "\n\n",
						order = 10,
						width = "full",
					},
					timeHeader = {
						type = "header",
						name = L.time,
						order = 11,
					},
					time = {
						type = "toggle",
						name = L.time,
						desc = L.timeDesc,
						order = 12,
						width = 1.5,
					},
					alignTime = {
						type = "select",
						name = L.alignTime,
						order = 13,
						width = 1.5,
						values = {
							LEFT = L.LEFT,
							CENTER = L.CENTER,
							RIGHT = L.RIGHT,
						},
						set = function(_, value)
							db.alignTime = value
							db.timeOffsetX = plugin.defaultDB.textOffsetX
							updateProfile()
						end,
						disabled = function() return not db.time end,
					},
					timeOffsetX = {
						type = "range",
						name = L.positionX,
						desc = L.positionDesc,
						order = 14,
						width = 1.5,
						min = -100,
						max = 100,
						step = 1,
						disabled = IsBarDecorationDisabledOrTimeDisabled,
					},
					timeOffsetY = {
						type = "range",
						name = L.positionY,
						desc = L.positionDesc,
						order = 15,
						width = 1.5,
						min = -100,
						max = 100,
						step = 1,
						disabled = IsBarDecorationDisabledOrTimeDisabled,
					},
					timeDecimals = {
						type = "range",
						name = L.cooldownDecimalsThreshold,
						desc = L.cooldownDecimalsThresholdDesc,
						order = 16,
						width = 3,
						min = 0,
						max = 60,
						step = 1,
						disabled = function() return not db.time end,
					},
					resetSpacer = {
						type = "description",
						name = "\n\n",
						order = 17,
						width = "full",
					},
					resetHeader = {
						type = "header",
						name = "",
						order = 18,
					},
					reset = {
						type = "execute",
						name = L.reset,
						desc = L.resetDesc,
						func = function()
							db.fontName = plugin.defaultDB.fontName
							db.outline = plugin.defaultDB.outline
							db.monochrome = plugin.defaultDB.monochrome
							db.text = plugin.defaultDB.text
							db.alignText = plugin.defaultDB.alignText
							db.textOffsetX = plugin.defaultDB.textOffsetX
							db.textOffsetY = plugin.defaultDB.textOffsetY
							db.time = plugin.defaultDB.time
							db.alignTime = plugin.defaultDB.alignTime
							db.timeOffsetX = plugin.defaultDB.timeOffsetX
							db.timeOffsetY = plugin.defaultDB.timeOffsetY
							db.timeDecimals = plugin.defaultDB.timeDecimals
							updateProfile()
						end,
						order = 19,
					},
				},
			},
			icon = {
				type = "group",
				name = L.icon,
				order = 3,
				args = {
					icon = {
						type = "toggle",
						name = L.icon,
						desc = L.iconDesc,
						order = 1,
						width = 1,
					},
					iconTooltip = {
						type = "toggle",
						name = L.iconTooltip,
						desc = L.iconTooltipDesc,
						order = 2,
						width = 1,
						disabled = function() return not db.icon end,
					},
					iconKeepAspectRatio = {
						type = "toggle",
						name = L.keepAspectRatio,
						desc = L.keepAspectRatioDesc,
						order = 3,
						width = 1,
						disabled = IsBarDecorationDisabledOrIconDisabled,
					},
					iconPosition = {
						type = "select",
						name = L.iconPosition,
						desc = L.iconPositionDesc,
						order = 4,
						width = 1,
						values = {
							LEFT = L.LEFT,
							RIGHT = L.RIGHT,
						},
						disabled = function() return not db.icon end,
					},
					iconWidthOffset = {
						type = "range",
						name = L.iconWidthOffset,
						order = 5,
						width = 1,
						min = -50,
						max = 50,
						step = 1,
						disabled = IsBarDecorationDisabledOrIconDisabled,
					},
					iconZoom = {
						type = "range",
						name = L.zoom,
						desc = L.zoomDesc,
						order = 6,
						width = 1,
						min = 0,
						max = 0.5,
						step = 0.01,
						isPercent = true,
						disabled = IsBarDecorationDisabledOrIconDisabled,
					},
					detachedIcon = {
						type = "toggle",
						name = L.detachedIcon,
						order = 7,
						width = 1.5,
						disabled = IsBarDecorationDisabledOrIconDisabled,
					},
					iconOffset = {
						type = "range",
						name = L.iconOffset,
						desc = L.positionDesc,
						order = 8,
						width = 1.5,
						min = 1,
						max = 100,
						step = 1,
						disabled = IsDetachedIconDisabled,
					},
					spellIndicatorsSpacer = {
						type = "description",
						name = "\n\n",
						order = 9,
						width = "full",
						hidden = HiddenOnRetail,
					},
					spellIndicatorsHeader = {
						type = "header",
						name = L.indicatorTitle,
						order = 10,
						hidden = HiddenOnRetail,
					},
					spellIndicators = {
						type = "multiselect",
						name = L.indicatorTitle,
						order = 11,
						width = 1.5,
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
						order = 12,
						width = 1.5,
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
						order = 13,
						width = 1.5,
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
						order = 14,
						width = 1.5,
						max = 100,
						min = 0,
						step = 1,
						hidden = HiddenOnRetail,
					},
					resetSpacer = {
						type = "description",
						name = "\n\n",
						order = 15,
						width = "full",
					},
					resetHeader = {
						type = "header",
						name = "",
						order = 16,
					},
					reset = {
						type = "execute",
						name = L.reset,
						desc = L.resetDesc,
						func = function()
							db.icon = plugin.defaultDB.icon
							db.iconTooltip = plugin.defaultDB.iconTooltip
							db.iconKeepAspectRatio = plugin.defaultDB.iconKeepAspectRatio
							db.iconPosition = plugin.defaultDB.iconPosition
							db.iconWidthOffset = plugin.defaultDB.iconWidthOffset
							db.iconZoom = plugin.defaultDB.iconZoom
							db.detachedIcon = plugin.defaultDB.detachedIcon
							db.iconOffset = plugin.defaultDB.iconOffset
							db.spellIndicators = plugin.defaultDB.spellIndicators
							db.spellIndicatorsSize = plugin.defaultDB.spellIndicatorsSize
							db.spellIndicatorsPosition = plugin.defaultDB.spellIndicatorsPosition
							db.spellIndicatorsOffset = plugin.defaultDB.spellIndicatorsOffset
							updateProfile()
						end,
						order = 17,
					},
				},
			},
			normal = {
				type = "group",
				name = L.bars,
				order = 4,
				args = {
					growup = {
						type = "toggle",
						name = L.growingUpwards,
						desc = L.growingUpwardsDesc,
						order = 1,
						width = 1,
					},
					fontSize = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						width = 1,
						order = 2,
						softMax = 100, max = 200, min = 10, step = 1,
					},
					visibleBarLimit = {
						type = "range",
						name = L.visibleBarLimit,
						desc = L.visibleBarLimitDesc,
						width = 1,
						order = 3,
						max = 100,
						min = 1,
						step = 1,
					},
					sizeSpacer = {
						type = "description",
						name = "\n\n",
						order = 4,
						width = "full",
					},
					sizeHeader = {
						type = "header",
						name = L.size,
						order = 5,
					},
					normalWidth = {
						type = "range",
						name = L.width,
						desc = L.sizeDesc,
						min = minBarWidth,
						max = maxBarWidth,
						step = 1,
						order = 6,
						width = 1,
					},
					normalHeight = {
						type = "range",
						name = L.height,
						desc = L.sizeDesc,
						min = minBarHeight,
						max = maxBarHeight,
						step = 1,
						order = 7,
						width = 1,
					},
					normalBarHeightOffset = {
						type = "range",
						name = L.barHeightOffset,
						min = -100,
						max = 0,
						step = 1,
						order = 8,
						width = 1,
						disabled = IsDetachedIconDisabled,
					},
					positionSpacer = {
						type = "description",
						name = "\n\n",
						order = 9,
						width = "full",
					},
					positionHeader = {
						type = "header",
						name = L.positionExact,
						order = 10,
					},
					posx = {
						type = "range",
						name = L.positionX,
						desc = L.positionDesc,
						min = -2048,
						max = 2048,
						step = 1,
						order = 11,
						width = 1.5,
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
						order = 12,
						width = 1.5,
						get = function()
							return db.normalPosition[4]
						end,
						set = function(_, value)
							db.normalPosition[4] = value
							normalAnchor:RefixPosition()
						end,
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
								if db.normalCopyCustomAnchorWidth then
									db.normalCopyCustomAnchorWidth = plugin.defaultDB.normalCopyCustomAnchorWidth
									db.normalWidth = plugin.defaultDB.normalWidth
								end
							end
							updateProfile()
						end,
						validate = function(_, frameName)
							return BigWigsAPI.IsValidFrame(frameName)
						end,
						name = L.customAnchorPoint,
						order = 13,
						width = 1,
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
						order = 14,
						width = 1,
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
						order = 15,
						width = 1,
						disabled = IsNormalAnchorPointDefault,
					},
					normalCopyCustomAnchorWidth = {
						type = "toggle",
						name = L.copyCustomAnchorWidth,
						desc = L.copyCustomAnchorWidthDesc,
						width = "full",
						set = function(_, value)
							if not value then
								db.normalWidth = plugin.defaultDB.normalWidth
							end
							db.normalCopyCustomAnchorWidth = value
							updateProfile()
						end,
						order = 16,
						disabled = IsNormalAnchorPointDefault,
					},
					resetSpacer = {
						type = "description",
						name = "\n\n",
						order = 17,
						width = "full",
					},
					resetHeader = {
						type = "header",
						name = "",
						order = 18,
					},
					reset = {
						type = "execute",
						name = L.reset,
						desc = L.resetDesc,
						func = function()
							db.growup = plugin.defaultDB.growup
							db.fontSize = plugin.defaultDB.fontSize
							db.visibleBarLimit = plugin.defaultDB.visibleBarLimit
							db.normalWidth = plugin.defaultDB.normalWidth
							db.normalHeight = plugin.defaultDB.normalHeight
							db.normalBarHeightOffset = plugin.defaultDB.normalBarHeightOffset
							db.normalPosition = {
								plugin.defaultDB.normalPosition[1],
								plugin.defaultDB.normalPosition[2],
								plugin.defaultDB.normalPosition[3],
								plugin.defaultDB.normalPosition[4],
								plugin.defaultDB.normalPosition[5],
							}
							db.normalCopyCustomAnchorWidth = plugin.defaultDB.normalCopyCustomAnchorWidth
							updateProfile()
						end,
						order = 19,
					},
				},
			},
			emphasize = {
				type = "group",
				name = L.emphasizedBars,
				order = 5,
				args = {
					emphasize = {
						type = "toggle",
						name = L.enable,
						order = 1,
						width = 1.5,
					},
					emphasizeMove = {
						type = "toggle",
						name = L.move,
						desc = L.moveDesc,
						order = 2,
						width = 1.5,
						disabled = IsEmphasizeDisabled,
					},
					emphasizeRestart = {
						type = "toggle",
						name = L.restart,
						desc = L.restartDesc,
						order = 3,
						width = 1.5,
						disabled = IsEmphasizeDisabled,
					},
					emphasizeGrowup = {
						type = "toggle",
						name = L.growingUpwards,
						desc = L.growingUpwardsDesc,
						order = 4,
						width = 1.5,
						disabled = function() return not db.emphasizeMove or not db.emphasize end, -- Disable when using 1 anchor or when emphasize is disabled
					},
					emphasizeTime = {
						type = "range",
						name = L.emphasizeAt,
						width = 1,
						order = 5,
						min = 6,
						max = 60, softMax = 30, -- Don't encourage bars longer than 30s in the GUI
						step = 1,
						disabled = IsEmphasizeDisabled,
					},
					fontSizeEmph = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						width = 1,
						order = 6,
						softMax = 100, max = 200, min = 10, step = 1,
						disabled = IsEmphasizeDisabled,
					},
					visibleBarLimitEmph = {
						type = "range",
						name = L.visibleBarLimit,
						desc = L.visibleBarLimitDesc,
						width = 1,
						order = 7,
						max = 100,
						min = 1,
						step = 1,
						disabled = IsEmphasizeDisabled,
					},
					sizeSpacer = {
						type = "description",
						name = "\n\n",
						order = 8,
						width = "full",
					},
					sizeHeader = {
						type = "header",
						name = L.size,
						order = 9,
					},
					expWidth = {
						type = "range",
						name = L.width,
						desc = L.sizeDesc,
						min = minBarWidth,
						max = maxBarWidth,
						step = 1,
						order = 10,
						width = 1,
						disabled = IsEmphasizeDisabled,
					},
					expHeight = {
						type = "range",
						name = L.height,
						desc = L.sizeDesc,
						min = minBarHeight,
						max = maxBarHeight,
						step = 1,
						order = 11,
						width = 1,
						disabled = IsEmphasizeDisabled,
					},
					expBarHeightOffset = {
						type = "range",
						name = L.barHeightOffset,
						min = -100,
						max = 0,
						step = 1,
						order = 12,
						width = 1,
						disabled = function() return not db.emphasize or IsDetachedIconDisabled() end,
					},
					positionSpacer = {
						type = "description",
						name = "\n\n",
						order = 13,
						width = "full",
					},
					positionHeader = {
						type = "header",
						name = L.positionExact,
						order = 14,
					},
					posx = {
						type = "range",
						name = L.positionX,
						desc = L.positionDesc,
						min = -2048,
						max = 2048,
						step = 1,
						order = 15,
						width = 1.5,
						get = function()
							return db.emphasizeMove and db.expPosition[3] or db.normalPosition[3]
						end,
						set = function(_, value)
							if db.emphasizeMove then
								db.expPosition[3] = value
								emphasizeAnchor:RefixPosition()
							else
								db.normalPosition[3] = value
								normalAnchor:RefixPosition()
							end
						end,
						disabled = IsEmphasizeDisabled,
					},
					posy = {
						type = "range",
						name = L.positionY,
						desc = L.positionDesc,
						min = -2048,
						max = 2048,
						step = 1,
						order = 16,
						width = 1.5,
						get = function()
							return db.emphasizeMove and db.expPosition[4] or db.normalPosition[4]
						end,
						set = function(_, value)
							if db.emphasizeMove then
								db.expPosition[4] = value
								emphasizeAnchor:RefixPosition()
							else
								db.normalPosition[4] = value
								normalAnchor:RefixPosition()
							end
						end,
						disabled = IsEmphasizeDisabled,
					},
					expCustomAnchorPoint = {
						type = "input",
						get = function()
							return db.emphasizeMove and db.expPosition[5] or db.normalPosition[5]
						end,
						set = function(_, value)
							if db.emphasizeMove then
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
									if db.expCopyCustomAnchorWidth then
										db.expCopyCustomAnchorWidth = plugin.defaultDB.expCopyCustomAnchorWidth
										db.expWidth = plugin.defaultDB.expWidth
									end
								end
							else
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
									if db.normalCopyCustomAnchorWidth then
										db.normalCopyCustomAnchorWidth = plugin.defaultDB.normalCopyCustomAnchorWidth
										db.normalWidth = plugin.defaultDB.normalWidth
									end
								end
							end
							updateProfile()
						end,
						validate = function(_, frameName)
							return BigWigsAPI.IsValidFrame(frameName)
						end,
						name = L.customAnchorPoint,
						order = 17,
						width = 1,
						disabled = IsEmphasizeDisabled,
					},
					expCustomAnchorPointSource = {
						type = "select",
						get = function()
							return db.emphasizeMove and db.expPosition[1] or db.normalPosition[1]
						end,
						set = function(_, value)
							if BigWigsAPI.IsValidFramePoint(value) then
								if db.emphasizeMove then
									db.expPosition[1] = value
								else
									db.normalPosition[1] = value
								end
								updateProfile()
							end
						end,
						values = BigWigsAPI.GetFramePointList(),
						name = L.sourcePoint,
						order = 18,
						width = 1,
						disabled = IsExpAnchorPointDefault,
					},
					expCustomAnchorPointDestination = {
						type = "select",
						get = function()
							return db.emphasizeMove and db.expPosition[2] or db.normalPosition[2]
						end,
						set = function(_, value)
							if BigWigsAPI.IsValidFramePoint(value) then
								if db.emphasizeMove then
									db.expPosition[2] = value
								else
									db.normalPosition[2] = value
								end
								updateProfile()
							end
						end,
						values = BigWigsAPI.GetFramePointList(),
						name = L.destinationPoint,
						order = 19,
						width = 1,
						disabled = IsExpAnchorPointDefault,
					},
					expCopyCustomAnchorWidth = {
						type = "toggle",
						name = L.copyCustomAnchorWidth,
						desc = L.copyCustomAnchorWidthDesc,
						order = 20,
						width = "full",
						get = function()
							if db.emphasizeMove then
								return db.expCopyCustomAnchorWidth
							else
								return db.normalCopyCustomAnchorWidth
							end
						end,
						set = function(_, value)
							if db.emphasizeMove then
								if not value then
									db.expWidth = plugin.defaultDB.expWidth
								end
								db.expCopyCustomAnchorWidth = value
							else
								if not value then
									db.normalWidth = plugin.defaultDB.normalWidth
								end
								db.normalCopyCustomAnchorWidth = value
							end
							updateProfile()
						end,
						disabled = IsExpAnchorPointDefault,
					},
					resetSpacer = {
						type = "description",
						name = "\n\n",
						order = 21,
						width = "full",
					},
					resetHeader = {
						type = "header",
						name = "",
						order = 22,
					},
					reset = {
						type = "execute",
						name = L.reset,
						desc = L.resetDesc,
						func = function()
							db.emphasize = plugin.defaultDB.emphasize
							db.emphasizeMove = plugin.defaultDB.emphasizeMove
							db.emphasizeRestart = plugin.defaultDB.emphasizeRestart
							db.emphasizeGrowup = plugin.defaultDB.emphasizeGrowup
							db.emphasizeTime = plugin.defaultDB.emphasizeTime
							db.fontSizeEmph = plugin.defaultDB.fontSizeEmph
							db.visibleBarLimitEmph = plugin.defaultDB.visibleBarLimitEmph
							db.expWidth = plugin.defaultDB.expWidth
							db.expHeight = plugin.defaultDB.expHeight
							db.expBarHeightOffset = plugin.defaultDB.expBarHeightOffset
							db.expPosition = {
								plugin.defaultDB.expPosition[1],
								plugin.defaultDB.expPosition[2],
								plugin.defaultDB.expPosition[3],
								plugin.defaultDB.expPosition[4],
								plugin.defaultDB.expPosition[5],
							}
							db.expCopyCustomAnchorWidth = plugin.defaultDB.expCopyCustomAnchorWidth
							updateProfile()
						end,
						order = 23,
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
		return a:GetRemainingTime() < b:GetRemainingTime()
	end
	local sortedTable = {}
	rearrangeBars = function(anchor)
		for bar in next, anchor.bars do
			sortedTable[#sortedTable + 1] = bar
		end
		if not sortedTable[1] then return end

		table.sort(sortedTable, barSorter)
		local lastBar = nil
		local up
		if anchor == emphasizeAnchor then
			up = db.emphasizeGrowup
		else
			up = db.growup
		end
		local spacing = db.spacing
		local numEmp, numNormal = 0, 0
		for i = 1, #sortedTable do
			local bar = sortedTable[i]
			sortedTable[i] = nil
			local hideBar
			if bar:Get("bigwigs:emphasized") then
				numEmp = numEmp + 1
				if numEmp > db.visibleBarLimitEmph then
					hideBar = true
				end
			else
				numNormal = numNormal + 1
				if numNormal > db.visibleBarLimit then
					hideBar = true
				end
			end
			bar:ClearAllPoints()
			if hideBar then
				bar:SetAlpha(0)
				if bar:Get("bigwigs:tooltip") then -- Icon tooltips are enabled and one exists for this bar
					bar.candyBarIconFrame:EnableMouse(false)
				end
				bar:Set("bigwigs:notvisible", true)
				bar:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT")
			else
				if bar:Get("bigwigs:notvisible") then
					bar:SetAlpha(1)
					if bar:Get("bigwigs:tooltip") then
						bar.candyBarIconFrame:EnableMouse(true)
					end
					bar:Set("bigwigs:notvisible", nil)
				end
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
end

local function barStopped(_, bar)
	if bar.candyBarIconFrame.bwID then
		bar.candyBarIconFrame.bwID = nil
		bar.candyBarIconFrame:SetScript("OnEnter", nil)
		bar.candyBarIconFrame:SetScript("OnLeave", nil)
		bar.candyBarIconFrame:EnableMouse(false)
	end
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
		if not self:IsShown() and ((self == normalAnchor and not activeFrameNormal) or (self == emphasizeAnchor and not activeFrameExp)) then return end
		width = math.floor(width+0.5)
		height = math.floor(height+0.5)
		if self == normalAnchor then
			db.normalWidth = width
			db.normalHeight = height
		else
			db.expWidth = width
			db.expHeight = height
		end
		for k in next, (db.emphasizeMove and self.bars or normalAnchor.bars) do
			currentBarStyler.BarStopped(k)
			local indicatorFrame = k:Get("bigwigs:indicatorFrame")
			local barHeight, barHeightOffset
			if k:Get("bigwigs:emphasized") then
				barHeight = db.expHeight
				barHeightOffset = db.expBarHeightOffset
				k:SetSize(db.expWidth, barHeight)
			else
				barHeight = db.normalHeight
				barHeightOffset = db.normalBarHeightOffset
				k:SetSize(db.normalWidth, barHeight)
			end
			if indicatorFrame then
				indicatorFrame:SetIndicatorSize(barHeight)
			end
			local iconWidth = barHeight
			if db.icon and currentBarStyler.barDecorationEnabled and db.iconWidthOffset ~= 0 then
				iconWidth = math.max(barHeight + db.iconWidthOffset, 1)
				k.candyBarIconFrame:SetWidth(iconWidth)
			end
			if db.icon and db.detachedIcon then
				if -barHeightOffset >= barHeight then
					barHeightOffset = 0
				end
				k.candyBarIconFrame:ClearAllPoints()
				k.candyBarBar:ClearAllPoints()
				if db.iconPosition == "LEFT" then
					k.candyBarIconFrame:SetPoint("TOPLEFT", k, "TOPLEFT", -db.iconOffset, 0)
					k.candyBarIconFrame:SetPoint("BOTTOMLEFT", k, "BOTTOMLEFT", -db.iconOffset, 0)
					k.candyBarBar:SetPoint("TOPLEFT", k, "TOPLEFT", iconWidth, barHeightOffset)
					k.candyBarBar:SetPoint("BOTTOMLEFT", k, "BOTTOMLEFT", iconWidth, 0)
					k.candyBarBar:SetPoint("TOPRIGHT", k, "TOPRIGHT", 0, barHeightOffset)
					k.candyBarBar:SetPoint("BOTTOMRIGHT", k, "BOTTOMRIGHT", 0, 0)
				else
					k.candyBarIconFrame:SetPoint("TOPRIGHT", k, "TOPRIGHT", db.iconOffset, 0)
					k.candyBarIconFrame:SetPoint("BOTTOMRIGHT", k, "BOTTOMRIGHT", db.iconOffset, 0)
					k.candyBarBar:SetPoint("TOPRIGHT", k, "TOPRIGHT", -iconWidth, barHeightOffset)
					k.candyBarBar:SetPoint("BOTTOMRIGHT", k, "BOTTOMRIGHT", -iconWidth, 0)
					k.candyBarBar:SetPoint("TOPLEFT", k, "TOPLEFT", 0, barHeightOffset)
					k.candyBarBar:SetPoint("BOTTOMLEFT", k, "BOTTOMLEFT", 0, 0)
				end
				if db.borderName ~= "None" or db.backgroundName ~= "None" then
					local borderOffset = db.borderName ~= "None" and db.borderOffset or 0
					local iconBorder = k.candyBarIconFrameBackdrop
					if db.iconPosition == "LEFT" then
						iconBorder:SetPoint("TOPLEFT", k, "TOPLEFT", -db.iconOffset - borderOffset, borderOffset)
						iconBorder:SetPoint("BOTTOMRIGHT", k, "BOTTOMLEFT", -db.iconOffset + iconWidth + borderOffset, -borderOffset)
					else
						iconBorder:SetPoint("TOPLEFT", k, "TOPRIGHT", db.iconOffset - iconWidth - borderOffset, borderOffset)
						iconBorder:SetPoint("BOTTOMRIGHT", k, "BOTTOMRIGHT", db.iconOffset + borderOffset, -borderOffset)
					end
				end
			else
				barHeightOffset = 0
				if db.icon and currentBarStyler.barDecorationEnabled and db.iconWidthOffset ~= 0 then
					k.candyBarBar:ClearAllPoints()
					if db.iconPosition == "LEFT" then
						k.candyBarBar:SetPoint("TOPLEFT", k, "TOPLEFT", iconWidth, 0)
						k.candyBarBar:SetPoint("BOTTOMLEFT", k, "BOTTOMLEFT", iconWidth, 0)
						k.candyBarBar:SetPoint("TOPRIGHT", k, "TOPRIGHT", 0, 0)
						k.candyBarBar:SetPoint("BOTTOMRIGHT", k, "BOTTOMRIGHT", 0, 0)
					else
						k.candyBarBar:SetPoint("TOPRIGHT", k, "TOPRIGHT", -iconWidth, 0)
						k.candyBarBar:SetPoint("BOTTOMRIGHT", k, "BOTTOMRIGHT", -iconWidth, 0)
						k.candyBarBar:SetPoint("TOPLEFT", k, "TOPLEFT", 0, 0)
						k.candyBarBar:SetPoint("BOTTOMLEFT", k, "BOTTOMLEFT", 0, 0)
					end
				end
			end
			k.candyBarLabel:ClearAllPoints()
			k.candyBarLabel:SetPoint("TOPLEFT", k.candyBarBar, "TOPLEFT", 2 + db.textOffsetX, -barHeightOffset / 2 + db.textOffsetY)
			k.candyBarLabel:SetPoint("BOTTOMRIGHT", k.candyBarBar, "BOTTOMRIGHT", -2 + db.textOffsetX, barHeightOffset / 2 + db.textOffsetY)
			k.candyBarDuration:ClearAllPoints()
			k.candyBarDuration:SetPoint("TOPLEFT", k.candyBarBar, "TOPLEFT", 2 + db.timeOffsetX, -barHeightOffset / 2 + db.timeOffsetY)
			k.candyBarDuration:SetPoint("BOTTOMRIGHT", k.candyBarBar, "BOTTOMRIGHT", -2 + db.timeOffsetX, barHeightOffset / 2 + db.timeOffsetY)
			currentBarStyler.ApplyStyle(k)
			k.candyBarIconFrame:SetTexCoord(GetIconTexCoord(iconWidth, barHeight))
		end
		rearrangeBars(self)
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
		bwTooltip:Hide()
	end
	local function OnMouseUp(self)
		self:GetParent():StopMovingOrSizing()
		if BigWigsOptions and BigWigsOptions:IsOpen() then
			plugin:UpdateGUI() -- Update X/Y if GUI is open
		end
	end
	local function OnEnter(self)
		bwTooltip:SetOwner(self, "ANCHOR_RIGHT")
		bwTooltip:AddLine(L.dragToResize)
		bwTooltip:Show()
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
		display:SetSize(width, height)
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
		drag:SetSize(16, 16)
		drag:SetPoint("BOTTOMRIGHT", -1, 1)
		drag:EnableMouse(true)
		drag:SetScript("OnMouseDown", OnMouseDown)
		drag:SetScript("OnMouseUp", OnMouseUp)
		drag:SetScript("OnEnter", OnEnter)
		drag:SetScript("OnLeave", function() bwTooltip:Hide() end)
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
		if db.emphasizeMove then
			emphasizeAnchor:Show()
		end
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
	for bar in next, anchor.bars do
		if eventId then
			if bar:Get("bigwigs:eventId") == eventId then
				return bar
			end
		elseif text and not bar:Get("bigwigs:eventId") and bar:Get("bigwigs:module") == module and bar:GetLabel() == text then
			return bar
		end
	end
end

--------------------------------------------------------------------------------
-- Initialization
--

do
	local function updateColors()
		for bar in next, normalAnchor.bars do
			local module = bar:Get("bigwigs:module")
			local key = bar:Get("bigwigs:option")
			if bar:Get("bigwigs:emphasized") and db.emphasize then
				bar:SetColor(colors:GetColor("barEmphasized", module, key))
			else
				bar:SetColor(colors:GetColor("barColor", module, key))
			end
			bar:SetBackgroundColor(colors:GetColor("barBackground", module, key))
			bar:SetTextColor(colors:GetColor("barText", module, key))
			bar:SetShadowColor(colors:GetColor("barTextShadow", module, key))
		end
		for bar in next, emphasizeAnchor.bars do
			local module = bar:Get("bigwigs:module")
			local key = bar:Get("bigwigs:option")
			bar:SetColor(colors:GetColor("barEmphasized", module, key))
			bar:SetBackgroundColor(colors:GetColor("barBackground", module, key))
			bar:SetTextColor(colors:GetColor("barText", module, key))
			bar:SetShadowColor(colors:GetColor("barTextShadow", module, key))
		end
	end

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
		self:RegisterMessage("BigWigs_UpdateColors", updateColors)

		-- custom bars
		self:RegisterMessage("BigWigs_PluginComm")
		self:RegisterMessage("DBM_AddonMessage")
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
-- Pausing bars
--

function plugin:PauseBar(_, module, text, eventId)
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
	local bar = getBar(normalAnchor, module, text, eventId)
	if bar then
		return bar:GetRemainingTime()
	end
	bar = getBar(emphasizeAnchor, module, text, eventId)
	if bar then
		return bar:GetRemainingTime()
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
		function UpdateAllIndicatorPoints()
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
			self:Hide()
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
	function plugin:CreateBar(module, key, text, time, eventId, spellIndicators)
		local width, height = db.normalWidth, db.normalHeight
		local bar = candy:New(LibSharedMedia:Fetch(STATUSBAR, db.texture), width, height)
		bar:SetDuration(time)
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
		bar:SetIconVisibility(db.icon)
		bar:SetColor(colors:GetColor("barColor", module, key))
		bar:SetBackgroundColor(colors:GetColor("barBackground", module, key))
		bar:SetTextColor(colors:GetColor("barText", module, key))
		bar:SetShadowColor(colors:GetColor("barTextShadow", module, key))
		bar.candyBarLabel:SetJustifyH(db.alignText)
		bar.candyBarDuration:SetJustifyH(db.alignTime)

		bar:SetTimeVisibility(db.time)
		bar:SetDecimalsThreshold(db.timeDecimals)
		bar:SetLabelVisibility(db.text)
		bar:SetIconPosition(db.iconPosition)
		bar:SetFill(db.fill)
		local indicators = spellIndicators or eventId
		if indicators then
			local indicatorFrame = GetBarIndicatorFrame()
			indicatorFrame:SetParent(bar)
			indicatorFrame:Show()
			indicatorFrame.bar = bar
			indicatorFrame:SetIndicatorSize(height)
			indicatorFrame:AddIndicators(indicators)
			bar:Set("bigwigs:indicatorFrame", indicatorFrame)
			bar:Set("bigwigs:indicators", indicators)
		end
		normalAnchor.bars[bar] = true
		if initial then
			-- Workaround for wow custom font loading issues
			self:SimpleTimer(function()
				initial = false
				if time > 1 and bar.running and ((not self:IsSecret(text) and not self:IsSecret(bar:GetLabel()) and bar:GetLabel() == text) or (eventId and bar:Get("bigwigs:eventId") == eventId)) then
					bar:SetLabel("-1")
					bar:SetLabel(text)
				end
			end, 0.3)
		end

		return bar
	end
end

do
	local isRetail = BigWigsLoader.isRetail
	local isForever = BigWigsLoader.isForever
	local function moveBar(bar)
		plugin:EmphasizeBar(bar)
		if isRetail or isForever then
			plugin:SendMessage("BigWigs_BarEmphasized", plugin, bar)
		end
		rearrangeBars(normalAnchor)
		rearrangeBars(emphasizeAnchor)
	end

	function plugin:BigWigs_StartBar(_, module, key, text, time, icon, maxQueueDuration, maxTime, eventId, spellIndicators)
		if not text then text = "" end
		if not eventId and self:IsSecret(text) then
			BigWigs:Error("Cannot start a bar with secrets when no eventId is specified.")
			return
		end
		self:StopSpecificBar(nil, module, text, eventId)
		local bar = self:CreateBar(module, key, text, time, eventId, spellIndicators)
		bar:Set("bigwigs:move", moveBar)
		if db.icon and db.iconTooltip and type(key) == "number" and key > 0 then
			bar.candyBarIconFrame.bwID = key
			bar:Set("bigwigs:tooltip", key)
			bar.candyBarIconFrame:SetScript("OnEnter", OnEnterIcon)
			bar.candyBarIconFrame:SetScript("OnLeave", OnLeaveIcon)
			bar.candyBarIconFrame:EnableMouse(true)
		end
		bar:SetPauseWhenDone(maxQueueDuration)
		if db.emphasize and time < db.emphasizeTime then
			if db.emphasizeRestart and maxTime and maxTime > db.emphasizeTime then
				bar:Start(db.emphasizeTime)
			else
				bar:Start(maxTime)
			end
			self:EmphasizeBar(bar, true)
		else
			bar:Start(maxTime)
			local iconWidth = db.normalHeight
			if db.icon and currentBarStyler.barDecorationEnabled and db.iconWidthOffset ~= 0 then
				iconWidth = math.max(db.normalHeight + db.iconWidthOffset, 1)
				bar.candyBarIconFrame:SetWidth(iconWidth)
			end
			local barHeightOffset = 0
			if db.icon and db.detachedIcon then
				barHeightOffset = db.normalBarHeightOffset
				if -barHeightOffset >= db.normalHeight then
					barHeightOffset = 0
				end
				bar.candyBarIconFrame:ClearAllPoints()
				bar.candyBarBar:ClearAllPoints()
				if db.iconPosition == "LEFT" then
					bar.candyBarIconFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", -db.iconOffset, 0)
					bar.candyBarIconFrame:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", -db.iconOffset, 0)
					bar.candyBarBar:SetPoint("TOPLEFT", bar, "TOPLEFT", iconWidth, barHeightOffset)
					bar.candyBarBar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", iconWidth, 0)
					bar.candyBarBar:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, barHeightOffset)
					bar.candyBarBar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
				else
					bar.candyBarIconFrame:SetPoint("TOPRIGHT", bar, "TOPRIGHT", db.iconOffset, 0)
					bar.candyBarIconFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", db.iconOffset, 0)
					bar.candyBarBar:SetPoint("TOPRIGHT", bar, "TOPRIGHT", -iconWidth, barHeightOffset)
					bar.candyBarBar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -iconWidth, 0)
					bar.candyBarBar:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, barHeightOffset)
					bar.candyBarBar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
				end
			elseif db.icon and currentBarStyler.barDecorationEnabled and db.iconWidthOffset ~= 0 then
				bar.candyBarBar:ClearAllPoints()
				if db.iconPosition == "LEFT" then
					bar.candyBarBar:SetPoint("TOPLEFT", bar, "TOPLEFT", iconWidth, 0)
					bar.candyBarBar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", iconWidth, 0)
					bar.candyBarBar:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
					bar.candyBarBar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
				else
					bar.candyBarBar:SetPoint("TOPRIGHT", bar, "TOPRIGHT", -iconWidth, 0)
					bar.candyBarBar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -iconWidth, 0)
					bar.candyBarBar:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
					bar.candyBarBar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
				end
			end
			if db.textOffsetX ~= 0 or db.textOffsetY ~= 0 or barHeightOffset ~= 0 then
				bar.candyBarLabel:ClearAllPoints()
				bar.candyBarLabel:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2 + db.textOffsetX, -barHeightOffset / 2 + db.textOffsetY)
				bar.candyBarLabel:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2 + db.textOffsetX, barHeightOffset / 2 + db.textOffsetY)
			end
			if db.timeOffsetX ~= 0 or db.timeOffsetY ~= 0 or barHeightOffset ~= 0 then
				bar.candyBarDuration:ClearAllPoints()
				bar.candyBarDuration:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2 + db.timeOffsetX, -barHeightOffset / 2 + db.timeOffsetY)
				bar.candyBarDuration:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2 + db.timeOffsetX, barHeightOffset / 2 + db.timeOffsetY)
			end
			if db.borderName ~= "None" or db.backgroundName ~= "None" then
				local border = bar.candyBarBackdrop
				local borderOffset = db.borderName ~= "None" and db.borderOffset or 0
				if db.icon and db.detachedIcon then
					border:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", -borderOffset, borderOffset)
					border:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", borderOffset, -borderOffset)
					local iconBorder = bar.candyBarIconFrameBackdrop
					if db.iconPosition == "LEFT" then
						iconBorder:SetPoint("TOPLEFT", bar, "TOPLEFT", -db.iconOffset - borderOffset, borderOffset)
						iconBorder:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -db.iconOffset + iconWidth + borderOffset, -borderOffset)
					else
						iconBorder:SetPoint("TOPLEFT", bar, "TOPRIGHT", db.iconOffset - iconWidth - borderOffset, borderOffset)
						iconBorder:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", db.iconOffset + borderOffset, -borderOffset)
					end
					iconBorder:Show()
					iconBorder:SetBackdrop(backdropTbl)
					if db.backgroundName ~= "None" then
						iconBorder:SetBackdropColor(db.backgroundColor[1], db.backgroundColor[2], db.backgroundColor[3], db.backgroundColor[4])
					end
					if db.borderName ~= "None" then
						iconBorder:SetBackdropBorderColor(db.borderColor[1], db.borderColor[2], db.borderColor[3], db.borderColor[4])
					end
				else
					border:SetPoint("TOPLEFT", bar, "TOPLEFT", -borderOffset, borderOffset)
					border:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", borderOffset, -borderOffset)
				end
				border:Show()
				border:SetBackdrop(backdropTbl)
				if db.backgroundName ~= "None" then
					border:SetBackdropColor(db.backgroundColor[1], db.backgroundColor[2], db.backgroundColor[3], db.backgroundColor[4])
				end
				if db.borderName ~= "None" then
					border:SetBackdropBorderColor(db.borderColor[1], db.borderColor[2], db.borderColor[3], db.borderColor[4])
				end
			end
			currentBarStyler.ApplyStyle(bar)
			if db.emphasize then
				bar:SetTimeCallback(moveBar, db.emphasizeTime)
			end
		end
		local anchor = bar:Get("bigwigs:anchor") == "expPosition" and emphasizeAnchor or normalAnchor
		rearrangeBars(anchor)
		local height = bar:Get("bigwigs:emphasized") and db.expHeight or db.normalHeight
		local iconWidth = (db.icon and currentBarStyler.barDecorationEnabled and db.iconWidthOffset ~= 0) and math.max(height + db.iconWidthOffset, 1) or height
		-- Text and icon can potentially be secret so apply them last
		bar:SetLabel(text)
		bar:SetIcon(icon, GetIconTexCoord(iconWidth, height))
		if isRetail or isForever then -- The following callbacks are now deprecated and will eventually be entirely removed
			self:SendMessage("BigWigs_BarCreated", self, bar, module, key, text, time, icon, maxQueueDuration)
			-- Check if :EmphasizeBar(bar) was run and trigger the callback.
			-- Bit of a roundabout method to approaching this so that we purposely keep callbacks firing last.
			if bar:Get("bigwigs:emphasized") then
				self:SendMessage("BigWigs_BarEmphasized", self, bar)
			end
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
	local height = db.expHeight
	local barHeightOffset = db.expBarHeightOffset
	bar:SetSize(db.expWidth, height)
	local indicatorFrame = bar:Get("bigwigs:indicatorFrame")
	if indicatorFrame then
		indicatorFrame:SetIndicatorSize(height)
	end
	local iconWidth = height
	if db.icon and currentBarStyler.barDecorationEnabled and db.iconWidthOffset ~= 0 then
		iconWidth = math.max(height + db.iconWidthOffset, 1)
		bar.candyBarIconFrame:SetWidth(iconWidth)
	end
	if db.icon and db.detachedIcon then
		if -barHeightOffset >= height then
			barHeightOffset = 0
		end
		bar.candyBarIconFrame:ClearAllPoints()
		bar.candyBarBar:ClearAllPoints()
		if db.iconPosition == "LEFT" then
			bar.candyBarIconFrame:SetPoint("TOPLEFT", bar, "TOPLEFT", -db.iconOffset, 0)
			bar.candyBarIconFrame:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", -db.iconOffset, 0)
			bar.candyBarBar:SetPoint("TOPLEFT", bar, "TOPLEFT", iconWidth, barHeightOffset)
			bar.candyBarBar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", iconWidth, 0)
			bar.candyBarBar:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, barHeightOffset)
			bar.candyBarBar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
		else
			bar.candyBarIconFrame:SetPoint("TOPRIGHT", bar, "TOPRIGHT", db.iconOffset, 0)
			bar.candyBarIconFrame:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", db.iconOffset, 0)
			bar.candyBarBar:SetPoint("TOPRIGHT", bar, "TOPRIGHT", -iconWidth, barHeightOffset)
			bar.candyBarBar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -iconWidth, 0)
			bar.candyBarBar:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, barHeightOffset)
			bar.candyBarBar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
		end
	else
		barHeightOffset = 0
		if db.icon and currentBarStyler.barDecorationEnabled and db.iconWidthOffset ~= 0 then
			bar.candyBarBar:ClearAllPoints()
			if db.iconPosition == "LEFT" then
				bar.candyBarBar:SetPoint("TOPLEFT", bar, "TOPLEFT", iconWidth, 0)
				bar.candyBarBar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", iconWidth, 0)
				bar.candyBarBar:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
				bar.candyBarBar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
			else
				bar.candyBarBar:SetPoint("TOPRIGHT", bar, "TOPRIGHT", -iconWidth, 0)
				bar.candyBarBar:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -iconWidth, 0)
				bar.candyBarBar:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
				bar.candyBarBar:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
			end
		end
	end
	if not freshBar or db.textOffsetX ~= 0 or db.textOffsetY ~= 0 or barHeightOffset ~= 0 then
		bar.candyBarLabel:ClearAllPoints()
		bar.candyBarLabel:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2 + db.textOffsetX, -barHeightOffset / 2 + db.textOffsetY)
		bar.candyBarLabel:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2 + db.textOffsetX, barHeightOffset / 2 + db.textOffsetY)
	end
	if not freshBar or db.timeOffsetX ~= 0 or db.timeOffsetY ~= 0 or barHeightOffset ~= 0 then
		bar.candyBarDuration:ClearAllPoints()
		bar.candyBarDuration:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2 + db.timeOffsetX, -barHeightOffset / 2 + db.timeOffsetY)
		bar.candyBarDuration:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2 + db.timeOffsetX, barHeightOffset / 2 + db.timeOffsetY)
	end
	if db.borderName ~= "None" or db.backgroundName ~= "None" then
		local borderOffset = db.borderName ~= "None" and db.borderOffset or 0
		if freshBar then
			local border = bar.candyBarBackdrop
			if db.icon and db.detachedIcon then
				border:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", -borderOffset, borderOffset)
				border:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", borderOffset, -borderOffset)
				local iconBorder = bar.candyBarIconFrameBackdrop
				if db.iconPosition == "LEFT" then
					iconBorder:SetPoint("TOPLEFT", bar, "TOPLEFT", -db.iconOffset - borderOffset, borderOffset)
					iconBorder:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -db.iconOffset + iconWidth + borderOffset, -borderOffset)
				else
					iconBorder:SetPoint("TOPLEFT", bar, "TOPRIGHT", db.iconOffset - iconWidth - borderOffset, borderOffset)
					iconBorder:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", db.iconOffset + borderOffset, -borderOffset)
				end
				iconBorder:Show()
				iconBorder:SetBackdrop(backdropTbl)
				if db.backgroundName ~= "None" then
					iconBorder:SetBackdropColor(db.backgroundColor[1], db.backgroundColor[2], db.backgroundColor[3], db.backgroundColor[4])
				end
				if db.borderName ~= "None" then
					iconBorder:SetBackdropBorderColor(db.borderColor[1], db.borderColor[2], db.borderColor[3], db.borderColor[4])
				end
			else
				border:SetPoint("TOPLEFT", bar, "TOPLEFT", -borderOffset, borderOffset)
				border:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", borderOffset, -borderOffset)
			end
			border:Show()
			border:SetBackdrop(backdropTbl)
			if db.backgroundName ~= "None" then
				border:SetBackdropColor(db.backgroundColor[1], db.backgroundColor[2], db.backgroundColor[3], db.backgroundColor[4])
			end
			if db.borderName ~= "None" then
				border:SetBackdropBorderColor(db.borderColor[1], db.borderColor[2], db.borderColor[3], db.borderColor[4])
			end
		elseif db.icon and db.detachedIcon then
			local iconBorder = bar.candyBarIconFrameBackdrop
			if db.iconPosition == "LEFT" then
				iconBorder:SetPoint("TOPLEFT", bar, "TOPLEFT", -db.iconOffset - borderOffset, borderOffset)
				iconBorder:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -db.iconOffset + iconWidth + borderOffset, -borderOffset)
			else
				iconBorder:SetPoint("TOPLEFT", bar, "TOPRIGHT", db.iconOffset - iconWidth - borderOffset, borderOffset)
				iconBorder:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", db.iconOffset + borderOffset, -borderOffset)
			end
		end
	end
	bar:SetFrameLevel(105) -- Put emphasized bars just above normal bars (LibCandyBar 100)
	currentBarStyler.ApplyStyle(bar)
	if not freshBar then
		bar.candyBarIconFrame:SetTexCoord(GetIconTexCoord(iconWidth, height))
	end
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
			timers[id] = plugin:ScheduleTimer(function()
				timers[id] = nil
				plugin:SendMessage("BigWigs_Message", plugin, false, L.timerFinished:format(nick, barText), "yellow", 134376)
			end, seconds)
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
