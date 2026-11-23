local L, BigWigsLoader, BigWigsAPI
do
	local _, tbl = ...
	BigWigsAPI = tbl.API
	L = BigWigsAPI:GetLocale("BigWigs")
	BigWigsLoader = tbl.loaderPublic
end

--------------------------------------------------------------------------------
-- Locals
--

local bwTooltip = BigWigsAPI.GetTooltip()
local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local db
local ProfileUtils = {
	MinimumWidth = 30,
	MaximumWidth = 100,
	MinimumHeight = 16,
	MaximumHeight = 50,
	MinimumFontSize = 10,
}

local function IsValidCustomText(value)
	if not value:find("%s", nil, true) or value:find("%%[^s]") then -- Must contain %s and no other format characters
		return false
	else
		local success, newValue = pcall(string.format, value, L.hide)
		if not success then -- Must not produce errors
			return false
		elseif newValue:find("%s", nil, true) then -- Must not still contain %s after being formatted with text (shouldn't really happen)
			return false
		else
			return true
		end
	end
end

--------------------------------------------------------------------------------
-- Saved Settings
--

do
	local fontName = "Noto Sans Medium"
	do
		local locale = GetLocale()
		if locale == "koKR" or locale == "zhCN" or locale == "zhTW" then
			fontName = LibSharedMedia:GetDefault("font")
		end
	end

	local defaults = {
		-- Any Combat
		anyCombatDisabled = true,
		anyCombatLocked = false,
		anyCombatWidth = 50,
		anyCombatHeight = 24,
		anyCombatPosition = {"CENTER", "CENTER", 490, -150, "UIParent"},
		anyCombatFontName = fontName,
		anyCombatFontSize = 16,
		anyCombatMonochrome = false,
		anyCombatOutline = "OUTLINE",
		anyCombatAlign = "CENTER",
		anyCombatColor = {1, 1, 1, 1},
		anyCombatColorInactive = {1, 1, 1, 0.3},
		anyCombatBackgroundColor = {0, 0, 0, 0.5},
		anyCombatBackgroundColorInactive = {0, 0, 0, 0.3},
		anyCombatBorderColor = {0, 0, 0, 1},
		anyCombatBorderColorInactive = {0, 0, 0, 0.3},
		anyCombatBorderSize = 1,
		anyCombatBorderOffset = 0,
		anyCombatBorderName = "Solid",
		anyCombatBackgroundName = "Solid",
		anyCombatInactive = "NONE",
		anyCombatTextFormat = 1,
		anyCombatHistoryAmount = 10,
		anyCombatHistoryResetConditions = 7,
		anyCombatHistoryTimeFormat = 2,
		anyCombatHistoryHiddenInCombat = false,
		anyCombatCustomText = "%s",

		-- Boss Combat
		bossCombatDisabled = true,
		bossCombatLocked = false,
		bossCombatWidth = 60,
		bossCombatHeight = 24,
		bossCombatPosition = {"CENTER", "CENTER", 550, -150, "UIParent"},
		bossCombatFontName = fontName,
		bossCombatFontSize = 16,
		bossCombatMonochrome = false,
		bossCombatOutline = "OUTLINE",
		bossCombatAlign = "CENTER",
		bossCombatColor = {1, 1, 1, 1},
		bossCombatColorInactive = {1, 1, 1, 0.3},
		bossCombatBackgroundColor = {0, 0, 0, 0.5},
		bossCombatBackgroundColorInactive = {0, 0, 0, 0.3},
		bossCombatBorderColor = {0, 0, 0, 1},
		bossCombatBorderColorInactive = {0, 0, 0, 0.3},
		bossCombatBorderSize = 1,
		bossCombatBorderOffset = 0,
		bossCombatBorderName = "Solid",
		bossCombatBackgroundName = "Solid",
		bossCombatInactive = "NONE",
		bossCombatTextFormat = 2,
		bossCombatHistoryAmount = 10,
		bossCombatHistoryResetConditions = 1,
		bossCombatHistoryTimeFormat = 2,
		bossCombatCustomText = "%s",

		-- Boss Stages
		bossStagesDisabled = true,
		bossStagesLocked = false,
		bossStagesWidth = 60,
		bossStagesHeight = 24,
		bossStagesPosition = {"CENTER", "CENTER", 615, -150, "UIParent"},
		bossStagesFontName = fontName,
		bossStagesFontSize = 16,
		bossStagesMonochrome = false,
		bossStagesOutline = "OUTLINE",
		bossStagesAlign = "CENTER",
		bossStagesColor = {1, 1, 1, 1},
		bossStagesColorInactive = {1, 1, 1, 0.3},
		bossStagesBackgroundColor = {0, 0, 0, 0.5},
		bossStagesBackgroundColorInactive = {0, 0, 0, 0.3},
		bossStagesBorderColor = {0, 0, 0, 1},
		bossStagesBorderColorInactive = {0, 0, 0, 0.3},
		bossStagesBorderSize = 1,
		bossStagesBorderOffset = 0,
		bossStagesBorderName = "Solid",
		bossStagesBackgroundName = "Solid",
		bossStagesInactive = "NONE",
		bossStagesTextFormat = 2,
		bossStagesHistoryTimeFormat = 2,
		bossStagesCustomText = "%s",
	}

	db = BigWigsLoader.db:RegisterNamespace("CombatTimer", {profile = defaults})

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

	local timerPrefixes = {"anyCombat", "bossCombat", "bossStages"}

	ProfileUtils.ValidateMainSettings = function()
		for k, v in next, db.profile do
			local defaultType = type(defaults[k])
			if defaultType == "nil" then
				db.profile[k] = nil
			elseif type(v) ~= defaultType then
				if defaultType == "table" then
					db.profile[k] = CopyTable(defaults[k])
				else
					db.profile[k] = defaults[k]
				end
			end
		end

		for i = 1, #timerPrefixes do
			local prefix = timerPrefixes[i]

			local widthKey = prefix .. "Width"
			local width = db.profile[widthKey]
			if width < ProfileUtils.MinimumWidth or width > ProfileUtils.MaximumWidth or math.floor(width+0.5) ~= width then
				db.profile[widthKey] = defaults[widthKey]
			end

			local heightKey = prefix .. "Height"
			local height = db.profile[heightKey]
			if height < ProfileUtils.MinimumHeight or height > ProfileUtils.MaximumHeight or math.floor(height+0.5) ~= height then
				db.profile[heightKey] = defaults[heightKey]
			end

			local posKey = prefix .. "Position"
			local pos = db.profile[posKey]
			if type(pos[1]) ~= "string" or type(pos[2]) ~= "string"
			or type(pos[3]) ~= "number" or type(pos[4]) ~= "number"
			or type(pos[5]) ~= "string"
			or pos[3] < -10000 or pos[3] > 10000
			or pos[4] < -10000 or pos[4] > 10000
			or not BigWigsAPI.IsValidFramePoint(pos[1]) or not BigWigsAPI.IsValidFramePoint(pos[2]) then
				db.profile[posKey] = CopyTable(defaults[posKey])
			else
				local x = math.floor(pos[3]+0.5)
				if x ~= pos[3] then
					pos[3] = x
				end
				local y = math.floor(pos[4]+0.5)
				if y ~= pos[4] then
					pos[4] = y
				end
			end

			local fontSizeKey = prefix .. "FontSize"
			local fontSize = db.profile[fontSizeKey]
			if fontSize < ProfileUtils.MinimumFontSize or fontSize > 200 or math.floor(fontSize+0.5) ~= fontSize then
				db.profile[fontSizeKey] = defaults[fontSizeKey]
			end

			local outlineKey = prefix .. "Outline"
			local outline = db.profile[outlineKey]
			if outline ~= "NONE" and outline ~= "OUTLINE" and outline ~= "THICKOUTLINE" then
				db.profile[outlineKey] = defaults[outlineKey]
			end

			local alignKey = prefix .. "Align"
			local align = db.profile[alignKey]
			if align ~= "LEFT" and align ~= "CENTER" and align ~= "RIGHT" then
				db.profile[alignKey] = defaults[alignKey]
			end

			local borderSizeKey = prefix .. "BorderSize"
			local borderSize = db.profile[borderSizeKey]
			if borderSize < 1 or borderSize > 32 or math.floor(borderSize+0.5) ~= borderSize then
				db.profile[borderSizeKey] = defaults[borderSizeKey]
			end

			local borderOffsetKey = prefix .. "BorderOffset"
			local borderOffset = db.profile[borderOffsetKey]
			if borderOffset < 0 or borderOffset > 32 or math.floor(borderOffset+0.5) ~= borderOffset then
				db.profile[borderOffsetKey] = defaults[borderOffsetKey]
			end

			local inactiveKey = prefix .. "Inactive"
			local inactive = db.profile[inactiveKey]
			if inactive ~= "NONE" and inactive ~= "HIDE" and inactive ~= "COLOR" then
				db.profile[inactiveKey] = defaults[inactiveKey]
			end

			local textFormatKey = prefix .. "TextFormat"
			if db.profile[textFormatKey] ~= 1 and db.profile[textFormatKey] ~= 2 then
				db.profile[textFormatKey] = defaults[textFormatKey]
			end

			if prefix ~= "bossStages" then
				local historyAmountKey = prefix .. "HistoryAmount"
				local historyAmount = db.profile[historyAmountKey]
				if historyAmount < 5 or historyAmount > 30 or math.floor(historyAmount+0.5) ~= historyAmount then
					db.profile[historyAmountKey] = defaults[historyAmountKey]
				end

				local historyResetKey = prefix .. "HistoryResetConditions"
				local historyReset = db.profile[historyResetKey]
				if historyReset < 0 or historyReset > 7 or math.floor(historyReset+0.5) ~= historyReset then
					db.profile[historyResetKey] = defaults[historyResetKey]
				end
			end

			local historyTimeFormatKey = prefix .. "HistoryTimeFormat"
			if db.profile[historyTimeFormatKey] ~= 1 and db.profile[historyTimeFormatKey] ~= 2 then
				db.profile[historyTimeFormatKey] = defaults[historyTimeFormatKey]
			end

			local customTextKey = prefix .. "CustomText"
			if not IsValidCustomText(db.profile[customTextKey]) then
				db.profile[customTextKey] = defaults[customTextKey]
			end

			ValidateColor(db.profile[prefix .. "Color"], defaults[prefix .. "Color"], 0.3)
			ValidateColor(db.profile[prefix .. "ColorInactive"], defaults[prefix .. "ColorInactive"], 0.3)
			ValidateColor(db.profile[prefix .. "BackgroundColor"], defaults[prefix .. "BackgroundColor"], 0)
			ValidateColor(db.profile[prefix .. "BackgroundColorInactive"], defaults[prefix .. "BackgroundColorInactive"], 0)
			ValidateColor(db.profile[prefix .. "BorderColor"], defaults[prefix .. "BorderColor"], 0)
			ValidateColor(db.profile[prefix .. "BorderColorInactive"], defaults[prefix .. "BorderColorInactive"], 0)
		end
	end
	ProfileUtils.ValidateMediaSettings = function()
		for i = 1, #timerPrefixes do
			local prefix = timerPrefixes[i]
			local fontKey = prefix .. "FontName"
			local fontPath = LibSharedMedia:IsValid("font", db.profile[fontKey]) and LibSharedMedia:Fetch("font", db.profile[fontKey])
			if not fontPath or not BigWigsAPI.IsValidMediaPath(fontPath) then
				db.profile[fontKey] = defaults[fontKey]
			end
			local borderKey = prefix .. "BorderName"
			if db.profile[borderKey] ~= "None" then
				local borderPath = LibSharedMedia:IsValid("border", db.profile[borderKey]) and LibSharedMedia:Fetch("border", db.profile[borderKey])
				if not borderPath or not BigWigsAPI.IsValidMediaPath(borderPath) then
					db.profile[borderKey] = defaults[borderKey]
					db.profile[prefix .. "BorderSize"] = defaults[prefix .. "BorderSize"]
					db.profile[prefix .. "BorderOffset"] = defaults[prefix .. "BorderOffset"]
				end
			end
			local bgKey = prefix .. "BackgroundName"
			if db.profile[bgKey] ~= "None" then
				local bgPath = LibSharedMedia:IsValid("background", db.profile[bgKey]) and LibSharedMedia:Fetch("background", db.profile[bgKey])
				if not bgPath or not BigWigsAPI.IsValidMediaPath(bgPath) then
					db.profile[bgKey] = defaults[bgKey]
				end
			end
		end
	end
	ProfileUtils.ValidateAnchorFrames = function()
		for i = 1, #timerPrefixes do
			local posKey = timerPrefixes[i] .. "Position"
			if db.profile[posKey][5] ~= defaults[posKey][5] and not BigWigsAPI.IsValidFrame(db.profile[posKey][5]) then
				db.profile[posKey] = CopyTable(defaults[posKey])
			end
		end
	end

	ProfileUtils.ResetTimer = function(prefix)
		db.profile[prefix .. "Locked"] = defaults[prefix .. "Locked"]
		ProfileUtils.ResetGeneral(prefix)
		ProfileUtils.ResetAdvanced(prefix)
		ProfileUtils.ResetPosition(prefix)
	end
	ProfileUtils.ResetGeneral = function(prefix)
		db.profile[prefix .. "Width"] = defaults[prefix .. "Width"]
		db.profile[prefix .. "Height"] = defaults[prefix .. "Height"]
		db.profile[prefix .. "FontName"] = defaults[prefix .. "FontName"]
		db.profile[prefix .. "Outline"] = defaults[prefix .. "Outline"]
		db.profile[prefix .. "FontSize"] = defaults[prefix .. "FontSize"]
		db.profile[prefix .. "Monochrome"] = defaults[prefix .. "Monochrome"]
		db.profile[prefix .. "Align"] = defaults[prefix .. "Align"]
		db.profile[prefix .. "BorderName"] = defaults[prefix .. "BorderName"]
		db.profile[prefix .. "BackgroundName"] = defaults[prefix .. "BackgroundName"]
		db.profile[prefix .. "BorderSize"] = defaults[prefix .. "BorderSize"]
		db.profile[prefix .. "BorderOffset"] = defaults[prefix .. "BorderOffset"]
	end
	ProfileUtils.ResetAdvanced = function(prefix)
		db.profile[prefix .. "Color"] = CopyTable(defaults[prefix .. "Color"])
		db.profile[prefix .. "BackgroundColor"] = CopyTable(defaults[prefix .. "BackgroundColor"])
		db.profile[prefix .. "BorderColor"] = CopyTable(defaults[prefix .. "BorderColor"])
		ProfileUtils.ResetInactiveColors(prefix)
		db.profile[prefix .. "Inactive"] = defaults[prefix .. "Inactive"]
		db.profile[prefix .. "TextFormat"] = defaults[prefix .. "TextFormat"]
		db.profile[prefix .. "HistoryTimeFormat"] = defaults[prefix .. "HistoryTimeFormat"]
		db.profile[prefix .. "CustomText"] = defaults[prefix .. "CustomText"]
		if prefix ~= "bossStages" then
			db.profile[prefix .. "HistoryAmount"] = defaults[prefix .. "HistoryAmount"]
			db.profile[prefix .. "HistoryResetConditions"] = defaults[prefix .. "HistoryResetConditions"]
		end
		if prefix == "anyCombat" then
			db.profile.anyCombatHistoryHiddenInCombat = defaults.anyCombatHistoryHiddenInCombat
		end
	end
	ProfileUtils.ResetInactiveColors = function(prefix)
		db.profile[prefix .. "ColorInactive"] = CopyTable(defaults[prefix .. "ColorInactive"])
		db.profile[prefix .. "BackgroundColorInactive"] = CopyTable(defaults[prefix .. "BackgroundColorInactive"])
		db.profile[prefix .. "BorderColorInactive"] = CopyTable(defaults[prefix .. "BorderColorInactive"])
	end
	ProfileUtils.ResetPosition = function(prefix)
		db.profile[prefix .. "Position"] = CopyTable(defaults[prefix .. "Position"])
	end
end

--------------------------------------------------------------------------------
-- Common Code
--

local CreateTimerWidget
do
	local MAX_DURATION = 86400 -- 24 hours
	local pendingPropagateTimers = {}
	local combatDeferFrame = CreateFrame("Frame")
	combatDeferFrame:SetScript("OnEvent", function(self, event)
		self:UnregisterEvent(event)
		for timer, propagate in next, pendingPropagateTimers do
			pendingPropagateTimers[timer] = nil
			if timer.propagateClicks ~= propagate then
				timer.propagateClicks = propagate
				timer.frame:SetPropagateMouseClicks(propagate)
			end
		end
	end)

	local function OnDragStart(self)
		if self:IsMovable() then
			self:StartMoving()
			if bwTooltip:IsOwned(self) then
				bwTooltip:Hide()
			end
		end
	end

	local function OnLeave(self)
		if bwTooltip:IsOwned(self) then
			bwTooltip:Hide()
		end
	end

	local timerProto = {}
	local timerMeta = { __index = timerProto }

	function timerProto:ApplyColors(isActive)
		local prefix = self.prefix
		local suffix = (not isActive and db.profile[prefix .. "Inactive"] == "COLOR") and "Inactive" or ""

		local textColor = db.profile[prefix .. "Color" .. suffix]
		self.text:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])

		if db.profile[prefix .. "BackgroundName"] ~= "None" then
			local bgColor = db.profile[prefix .. "BackgroundColor" .. suffix]
			self.backdrop:SetBackdropColor(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
		end

		if db.profile[prefix .. "BorderName"] ~= "None" then
			local borderColor = db.profile[prefix .. "BorderColor" .. suffix]
			self.backdrop:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
		end
	end

	function timerProto:UpdateFormat()
		local prefix = self.prefix
		local customText = db.profile[prefix .. "CustomText"]
		local bp = self.breakpoints[1]

		if db.profile[prefix .. "TextFormat"] == 2 then
			bp.step = 0.1
			bp.rounding = 0 -- Enum.NumericRuleFormatRounding.Nearest = 0
			bp.format = customText:format("%d:%04.1f")
			bp.components[2].step = nil
		else
			bp.step = 1
			bp.rounding = 2 -- Enum.NumericRuleFormatRounding.Down = 2
			bp.format = customText:format("%d:%02d")
			bp.components[2].step = 1
		end

		self.formatter:SetBreakpoints(self.breakpoints)
		self.durationBinding:SetTextFormat("{}", self.formatComponents)
		local zeroText = self.formatter:FormatNumber(0)
		self.durationBinding:SetZeroDurationText(zeroText)

		if self.active then
			self.durationBinding:UpdateFontString()
		else
			local formatted = self.formatter:FormatNumber(self.lastElapsed)
			self.text:SetText(formatted)
		end
	end

	function timerProto:UpdateStyle()
		local prefix = self.prefix
		local frame = self.frame

		frame:SetSize(db.profile[prefix .. "Width"], db.profile[prefix .. "Height"])
		local pos = db.profile[prefix .. "Position"]
		local movable = not db.profile[prefix .. "Locked"] and pos[5] == "UIParent"
		if frame:IsDragging() then
			frame:StopMovingOrSizing()
		end
		frame:ClearAllPoints()
		frame:SetPoint(pos[1], pos[5], pos[2], pos[3], pos[4])
		frame:SetMovable(movable)
		local propagate = not movable
		if self.propagateClicks ~= propagate then
			if InCombatLockdown() then
				pendingPropagateTimers[self] = propagate
				combatDeferFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
			else
				pendingPropagateTimers[self] = nil
				self.propagateClicks = propagate
				frame:SetPropagateMouseClicks(propagate)
			end
		elseif pendingPropagateTimers[self] ~= nil then
			pendingPropagateTimers[self] = nil
		end

		local align = db.profile[prefix .. "Align"]
		self.text:ClearAllPoints()
		self.text:SetPoint(align, frame, align, align == "LEFT" and 1 or align == "RIGHT" and -1 or 0, 0)
		self.text:SetJustifyH(align)
		local monochrome = db.profile[prefix .. "Monochrome"]
		local outline = db.profile[prefix .. "Outline"]
		local flags = nil
		if monochrome and outline ~= "NONE" then
			flags = "MONOCHROME," .. outline
		elseif monochrome then
			flags = "MONOCHROME"
		elseif outline ~= "NONE" then
			flags = outline
		end
		self.text:SetFont(LibSharedMedia:Fetch("font", db.profile[prefix .. "FontName"]), db.profile[prefix .. "FontSize"], flags)
		self:UpdateFormat()

		local borderName = db.profile[prefix .. "BorderName"]
		local backgroundName = db.profile[prefix .. "BackgroundName"]
		local hasBorder = borderName ~= "None"
		local hasBackground = backgroundName ~= "None"
		if hasBorder or hasBackground then
			local borderSize = hasBorder and db.profile[prefix .. "BorderSize"] or nil
			local borderOffset = hasBorder and db.profile[prefix .. "BorderOffset"] or 0
			local inset = hasBorder and math.floor(borderSize / 4) or 0
			local backdropTable = {
				bgFile = hasBackground and LibSharedMedia:Fetch("background", backgroundName) or nil,
				edgeFile = hasBorder and LibSharedMedia:Fetch("border", borderName) or nil,
				edgeSize = borderSize,
				insets = { left = inset, right = inset, top = inset, bottom = inset },
			}
			self.backdrop:ClearAllPoints()
			self.backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", -borderOffset, borderOffset)
			self.backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", borderOffset, -borderOffset)
			self.backdrop:SetBackdrop(backdropTable)
		else
			self.backdrop:ClearBackdrop()
		end

		self:ApplyColors(self.active)
		if self.active or db.profile[prefix .. "Inactive"] ~= "HIDE" then
			frame:Show()
		else
			frame:Hide()
		end
	end

	function timerProto:Start(startTime)
		self.durationObject:SetTimeFromStart(startTime, MAX_DURATION)
		self:Resume()
	end

	function timerProto:Resume()
		self.active = true
		local inactiveMode = db.profile[self.prefix .. "Inactive"]
		if inactiveMode == "COLOR" then
			self:ApplyColors(true)
		end
		if inactiveMode == "HIDE" and not self.frame:IsShown() then
			self.frame:Show()
		elseif self.frame:IsVisible() then
			self.durationBinding:SetEnabled(true)
			self.durationBinding:UpdateFontString()
		end
	end

	function timerProto:Stop()
		local elapsed = self.durationObject:GetElapsedDuration()
		self.active = false
		self.lastElapsed = elapsed
		self.durationBinding:SetEnabled(false)
		local formatted = self.formatter:FormatNumber(elapsed)
		self.text:SetText(formatted)
		local inactiveMode = db.profile[self.prefix .. "Inactive"]
		if inactiveMode == "COLOR" then
			self:ApplyColors(false)
		elseif inactiveMode == "HIDE" then
			self.frame:Hide()
		end
		return elapsed
	end

	function timerProto:Reset()
		local wasActive = self.active
		self.active = false
		self.lastElapsed = 0
		self.durationBinding:SetEnabled(false)
		self.durationObject:Reset()
		local zeroText = self.formatter:FormatNumber(0)
		self.text:SetText(zeroText)
		if wasActive then
			local inactiveMode = db.profile[self.prefix .. "Inactive"]
			if inactiveMode == "COLOR" then
				self:ApplyColors(false)
			elseif inactiveMode == "HIDE" then
				self.frame:Hide()
			end
		end
	end

	function timerProto:SetStartTime(startTime)
		self.durationObject:SetTimeFromStart(startTime, MAX_DURATION)
		if self.active and self.frame:IsVisible() then
			self.durationBinding:UpdateFontString()
		end
	end

	function CreateTimerWidget(prefix, frameLevel)
		local main = CreateFrame("Frame", nil, UIParent)
		main:Hide()
		main:SetFrameStrata("MEDIUM")
		main:SetFixedFrameStrata(true)
		main:SetFrameLevel(frameLevel)
		main:SetFixedFrameLevel(true)
		main:SetClampedToScreen(true)
		main:EnableMouse(true)
		main:RegisterForDrag("LeftButton")
		main:SetScript("OnDragStart", OnDragStart)
		main:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing()
			local pos = db.profile[prefix .. "Position"]
			if self:IsMovable() and pos[5] == "UIParent" then
				local point, _, relPoint, x, y = self:GetPoint()
				x = math.floor(x+0.5)
				y = math.floor(y+0.5)
				pos[1] = point
				pos[2] = relPoint
				pos[3] = x
				pos[4] = y
				local acr = LibStub("AceConfigRegistry-3.0", true)
				if acr then
					acr:NotifyChange("BigWigsTools")
				end
			end
		end)
		main:SetScript("OnLeave", OnLeave)

		local backdrop = CreateFrame("Frame", nil, main, "BackdropTemplate")
		backdrop:SetAllPoints(main)
		backdrop:Show()

		local text = backdrop:CreateFontString(nil, "OVERLAY")

		local durationObject = C_DurationUtil.CreateDuration()
		local formatter = C_StringUtil.CreateNumericRuleFormatter()
		local breakpoints = {
			{
				threshold = 0,
				step = 1,
				rounding = 2, -- Enum.NumericRuleFormatRounding.Down = 2
				format = "%d:%02d",
				components = {
					{ div = 60, step = 1, rounding = 2 },
					{ mod = 60, step = 1, rounding = 2 },
				},
			},
		}

		local formatComponents = {
			{ property = 2, formatter = formatter }, -- Enum.DurationTextBindingProperty.ElapsedDuration = 2
		}

		local durationBinding = C_DurationUtil.CreateDurationTextBinding()
		durationBinding:SetFontString(text)
		durationBinding:SetDuration(durationObject)
		durationBinding:SetEnabled(false)

		local timer = setmetatable({
			prefix = prefix,
			frame = main,
			backdrop = backdrop,
			text = text,
			durationObject = durationObject,
			formatter = formatter,
			durationBinding = durationBinding,
			formatComponents = formatComponents,
			breakpoints = breakpoints,
			active = false,
			enabled = false,
			propagateClicks = false,
			lastElapsed = 0,
			historyTime = {},
			historyDuration = {},
		}, timerMeta)

		main:SetScript("OnShow", function()
			if timer.active then
				timer.durationBinding:SetEnabled(true)
				timer.durationBinding:UpdateFontString()
			end
		end)
		main:SetScript("OnHide", function(self)
			timer.durationBinding:SetEnabled(false)
			if self:IsDragging() then
				self:StopMovingOrSizing()
				local pos = db.profile[prefix .. "Position"]
				self:ClearAllPoints()
				self:SetPoint(pos[1], pos[5], pos[2], pos[3], pos[4])
			end
			if bwTooltip:IsOwned(self) then
				bwTooltip:Hide()
			end
		end)

		return timer
	end
end

--------------------------------------------------------------------------------
-- Widgets & Events
--

local widgets = {}

-- Any Combat
do
	local timer = CreateTimerWidget("anyCombat", 5020)
	widgets.anyCombat = timer

	timer.frame:SetScript("OnEnter", function(self)
		if db.profile.anyCombatHistoryHiddenInCombat and InCombatLockdown() then return end
		bwTooltip:SetOwner(self, "ANCHOR_TOP")
		bwTooltip:AddLine(L.anyCombatTimerTooltip)
		for i = 1, math.min(#timer.historyTime, db.profile.anyCombatHistoryAmount) do
			if i == 1 and timer.active then
				bwTooltip:AddDoubleLine(timer.historyTime[i], L.inProgress, 1, 1, 1, 0, 1, 0)
			else
				bwTooltip:AddDoubleLine(timer.historyTime[i], BigWigsAPI.SecondsToTime(timer.historyDuration[i], db.profile.anyCombatTextFormat == 1), 1, 1, 1, 0, 1, 0)
			end
		end
		bwTooltip:Show()
	end)

	local prevCombatEnd = nil
	local prevInstanceID = nil
	local function ResetHistory()
		prevCombatEnd = nil
		timer.historyTime = {}
		timer.historyDuration = {}
		timer:Reset()
	end

	widgets.anyCombatInit = function()
		local _, _, _, _, _, _, _, instanceID = BigWigsLoader.GetInstanceInfo()
		prevInstanceID = instanceID
	end

	widgets.anyCombatDisable = function()
		prevInstanceID = nil
		ResetHistory()
	end

	timer.frame:SetScript("OnEvent", function(_, event)
		if event == "PLAYER_ENTERING_WORLD" then
			local _, instanceType, _, _, _, _, _, instanceID = BigWigsLoader.GetInstanceInfo()
			if instanceID ~= prevInstanceID then
				prevInstanceID = instanceID
				if (instanceType == "raid" and bit.band(db.profile.anyCombatHistoryResetConditions, 1) == 1) or (instanceType == "party" and bit.band(db.profile.anyCombatHistoryResetConditions, 2) == 2) then
					ResetHistory()
				end
			end
		elseif event == "CHALLENGE_MODE_START" then
			if bit.band(db.profile.anyCombatHistoryResetConditions, 4) == 4 then
				ResetHistory()
			end
		elseif event == "PLAYER_REGEN_DISABLED" then
			if db.profile.anyCombatHistoryHiddenInCombat and bwTooltip:IsOwned(timer.frame) then
				bwTooltip:Hide()
			end
			if not timer.active then
				local t = GetTime()
				if prevCombatEnd and (t - prevCombatEnd) <= 2 and not timer.durationObject:IsZero() then -- If you re-enter combat within 2 sec then we don't consider it as ended
					timer:Resume()
				else
					local maxEntries = db.profile.anyCombatHistoryAmount
					while #timer.historyTime >= maxEntries do
						table.remove(timer.historyTime)
						table.remove(timer.historyDuration)
					end
					local timeText = BigWigsLoader.date(db.profile.anyCombatHistoryTimeFormat == 1 and "[%I:%M:%S %p]" or "[%H:%M:%S]")
					table.insert(timer.historyTime, 1, timeText)
					table.insert(timer.historyDuration, 1, 0)
					timer:Start(t)
				end
			end
		elseif event == "PLAYER_REGEN_ENABLED" and timer.active then
			prevCombatEnd = GetTime()
			timer.historyDuration[1] = timer:Stop()
		end
	end)
end

-- Boss Combat
do
	local timer = CreateTimerWidget("bossCombat", 5015)
	widgets.bossCombat = timer

	local encounterStatusTexts = {
		[0] = L.defeat,
		[1] = L.victory,
		[2] = L.inProgress,
	}
	timer.frame:SetScript("OnEnter", function(self)
		bwTooltip:SetOwner(self, "ANCHOR_TOP")
		bwTooltip:AddLine(L.bossCombatTimerTooltip)
		local now = GetTime()
		for i = 1, math.min(#timer.historyTime, db.profile.bossCombatHistoryAmount) do
			local durationEntry = timer.historyDuration[i]
			local duration = durationEntry[2] == 2 and (now - durationEntry[1]) or durationEntry[1]
			bwTooltip:AddDoubleLine(
				timer.historyTime[i][1],
				("%s [%s]"):format(BigWigsAPI.SecondsToTime(duration, db.profile.bossCombatTextFormat == 1), encounterStatusTexts[durationEntry[2]]),
				1, 1, 1,
				0, 1, 0
			)
		end
		bwTooltip:Show()
	end)

	local prevInstanceID = nil
	local function ResetHistory()
		timer.historyTime = {}
		timer.historyDuration = {}
		timer:Reset()
	end

	widgets.bossCombatInit = function()
		local _, _, _, _, _, _, _, instanceID = BigWigsLoader.GetInstanceInfo()
		prevInstanceID = instanceID
	end

	widgets.bossCombatDisable = function()
		prevInstanceID = nil
		ResetHistory()
	end

	timer.frame:SetScript("OnEvent", function(_, event, encounterID, encounterName, _, _, success)
		if event == "PLAYER_ENTERING_WORLD" then
			local _, instanceType, _, _, _, _, _, instanceID = BigWigsLoader.GetInstanceInfo()
			if instanceID ~= prevInstanceID then
				prevInstanceID = instanceID
				if (instanceType == "raid" and bit.band(db.profile.bossCombatHistoryResetConditions, 1) == 1) or (instanceType == "party" and bit.band(db.profile.bossCombatHistoryResetConditions, 2) == 2) then
					ResetHistory()
				end
			end
		elseif event == "CHALLENGE_MODE_START" then
			if bit.band(db.profile.bossCombatHistoryResetConditions, 4) == 4 then
				ResetHistory()
			end
		elseif event == "ENCOUNTER_START" then
			local t = GetTime()
			local closedStale = false
			for i = 1, #timer.historyTime do
				local tblTime = timer.historyTime[i]
				local tblDuration = timer.historyDuration[i]
				if tblTime[2] == encounterID and tblDuration[2] == 2 then -- Close stale duplicate if ENCOUNTER_END was somehow missed
					tblDuration[1] = t - tblDuration[1]
					tblDuration[2] = 0
					closedStale = true
				end
			end
			local maxEntries = db.profile.bossCombatHistoryAmount
			while #timer.historyTime >= maxEntries do
				table.remove(timer.historyTime)
				local removed = table.remove(timer.historyDuration)
				if removed[2] == 2 then
					closedStale = true
				end
			end
			local tooltipText = ("%s %s"):format(BigWigsLoader.date(db.profile.bossCombatHistoryTimeFormat == 1 and "[%I:%M:%S %p]" or "[%H:%M:%S]"), encounterName)
			table.insert(timer.historyTime, 1, {tooltipText, encounterID})
			table.insert(timer.historyDuration, 1, {t, 2})
			if not timer.active then
				timer:Start(t)
			elseif closedStale then
				for i = #timer.historyDuration, 1, -1 do
					local tblDuration = timer.historyDuration[i]
					if tblDuration[2] == 2 then
						timer:SetStartTime(tblDuration[1])
						break
					end
				end
			end
		elseif event == "ENCOUNTER_END" and timer.active then
			local t = GetTime()
			for i = 1, #timer.historyTime do
				local tblTime = timer.historyTime[i]
				local tblDuration = timer.historyDuration[i]
				if tblTime[2] == encounterID and tblDuration[2] == 2 then -- Find this encounter and change its status
					tblDuration[1] = t - tblDuration[1]
					tblDuration[2] = success == 1 and 1 or 0
					break
				end
			end
			for i = #timer.historyDuration, 1, -1 do
				local tblDuration = timer.historyDuration[i]
				if tblDuration[2] == 2 then -- Another encounter is still in progress
					timer:SetStartTime(tblDuration[1])
					return
				end
			end
			timer:Stop()
		elseif event == "PLAYER_LEAVING_WORLD" and timer.active then
			local t = GetTime()
			for i = 1, #timer.historyDuration do
				local tbl = timer.historyDuration[i]
				if tbl[2] == 2 then -- In progress
					tbl[1] = t - tbl[1]
					tbl[2] = 0
				end
			end
			timer:Stop()
		end
	end)
end

-- Boss Stages
do
	local timer = CreateTimerWidget("bossStages", 5010)
	widgets.bossStages = timer

	timer.frame:SetScript("OnEnter", function(self)
		bwTooltip:SetOwner(self, "ANCHOR_TOP")
		bwTooltip:AddLine(L.bossStagesTimerTooltip)
		for i = 1, #timer.historyTime do
			if i == 1 and timer.active then
				bwTooltip:AddDoubleLine(timer.historyTime[i], L.inProgress, 1, 1, 1, 0, 1, 0)
			else
				bwTooltip:AddDoubleLine(timer.historyTime[i], BigWigsAPI.SecondsToTime(timer.historyDuration[i], db.profile.bossStagesTextFormat == 1), 1, 1, 1, 0, 1, 0)
			end
		end
		bwTooltip:Show()
	end)

	local currentModule = nil
	widgets.bossStagesOnEngage = function(_, module)
		if module and module:GetStage() then
			currentModule = module
			timer.historyTime = {}
			timer.historyDuration = {}
			timer:Reset()
		end
	end

	widgets.bossStagesOnStageChange = function(_, module, stage)
		if not module or module:IsWiping() then return end
		if not currentModule then
			currentModule = module
			timer.historyTime = {}
			timer.historyDuration = {}
		end
		if module == currentModule then
			if timer.active then
				timer.historyDuration[1] = timer.durationObject:GetElapsedDuration()
			end
			local timeText = BigWigsLoader.date(db.profile.bossStagesHistoryTimeFormat == 1 and "[%I:%M:%S %p]" or "[%H:%M:%S]")
			local stageText = L.stage:format(stage)
			local tooltipText = ("%s %s"):format(timeText, stageText)
			table.insert(timer.historyTime, 1, tooltipText)
			table.insert(timer.historyDuration, 1, 0)
			local t = GetTime()
			timer:Start(t)
		end
	end

	widgets.bossStagesOnEnd = function(_, module)
		if module and module == currentModule then
			currentModule = nil
			if timer.active then
				timer.historyDuration[1] = timer:Stop()
			end
		end
	end

	widgets.bossStagesDisable = function()
		currentModule = nil
		timer.historyTime = {}
		timer.historyDuration = {}
		timer:Reset()
	end
end

--------------------------------------------------------------------------------
-- Options Table
--

local function UpdateAnyCombatWidget()
	local timer = widgets.anyCombat
	if not db.profile.anyCombatDisabled then
		if not timer.enabled then
			timer.enabled = true
			widgets.anyCombatInit()
			timer.frame:RegisterEvent("PLAYER_REGEN_DISABLED")
			timer.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
			timer.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
			timer.frame:RegisterEvent("CHALLENGE_MODE_START")
		end
		timer:UpdateStyle()
	elseif timer.enabled then
		timer.enabled = false
		timer.frame:UnregisterEvent("PLAYER_REGEN_DISABLED")
		timer.frame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		timer.frame:UnregisterEvent("PLAYER_ENTERING_WORLD")
		timer.frame:UnregisterEvent("CHALLENGE_MODE_START")
		widgets.anyCombatDisable()
		timer.frame:Hide()
	end
end

local function UpdateBossCombatWidget()
	local timer = widgets.bossCombat
	if not db.profile.bossCombatDisabled then
		if not timer.enabled then
			timer.enabled = true
			widgets.bossCombatInit()
			timer.frame:RegisterEvent("ENCOUNTER_START")
			timer.frame:RegisterEvent("ENCOUNTER_END")
			timer.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
			timer.frame:RegisterEvent("CHALLENGE_MODE_START")
			timer.frame:RegisterEvent("PLAYER_LEAVING_WORLD")
		end
		timer:UpdateStyle()
	elseif timer.enabled then
		timer.enabled = false
		timer.frame:UnregisterEvent("ENCOUNTER_START")
		timer.frame:UnregisterEvent("ENCOUNTER_END")
		timer.frame:UnregisterEvent("PLAYER_ENTERING_WORLD")
		timer.frame:UnregisterEvent("CHALLENGE_MODE_START")
		timer.frame:UnregisterEvent("PLAYER_LEAVING_WORLD")
		widgets.bossCombatDisable()
		timer.frame:Hide()
	end
end

local function UpdateBossStagesWidget()
	local timer = widgets.bossStages
	if not db.profile.bossStagesDisabled then
		if not timer.enabled then
			timer.enabled = true
			BigWigsLoader.RegisterMessage(timer.frame, "BigWigs_OnBossEngage", widgets.bossStagesOnEngage)
			BigWigsLoader.RegisterMessage(timer.frame, "BigWigs_OnBossEngageMidEncounter", widgets.bossStagesOnEngage)
			BigWigsLoader.RegisterMessage(timer.frame, "BigWigs_SetStage", widgets.bossStagesOnStageChange)
			BigWigsLoader.RegisterMessage(timer.frame, "BigWigs_OnBossWin", widgets.bossStagesOnEnd)
			BigWigsLoader.RegisterMessage(timer.frame, "BigWigs_OnBossWipe", widgets.bossStagesOnEnd)
			BigWigsLoader.RegisterMessage(timer.frame, "BigWigs_OnBossDisable", widgets.bossStagesOnEnd)
			BigWigsLoader.RegisterMessage(timer.frame, "BigWigs_EncounterEnd", widgets.bossStagesOnEnd)
		end
		timer:UpdateStyle()
	elseif timer.enabled then
		timer.enabled = false
		BigWigsLoader.UnregisterMessage(timer.frame, "BigWigs_OnBossEngage")
		BigWigsLoader.UnregisterMessage(timer.frame, "BigWigs_OnBossEngageMidEncounter")
		BigWigsLoader.UnregisterMessage(timer.frame, "BigWigs_SetStage")
		BigWigsLoader.UnregisterMessage(timer.frame, "BigWigs_OnBossWin")
		BigWigsLoader.UnregisterMessage(timer.frame, "BigWigs_OnBossWipe")
		BigWigsLoader.UnregisterMessage(timer.frame, "BigWigs_OnBossDisable")
		BigWigsLoader.UnregisterMessage(timer.frame, "BigWigs_EncounterEnd")
		widgets.bossStagesDisable()
		timer.frame:Hide()
	end
end

BigWigsAPI.RegisterToolOptions("CombatTimer", function()
	local tabWidgets = {
		all = widgets.anyCombat,
		boss = widgets.bossCombat,
		bossStages = widgets.bossStages,
	}

	local tabUpdateFuncs = {
		all = UpdateAnyCombatWidget,
		boss = UpdateBossCombatWidget,
		bossStages = UpdateBossStagesWidget,
	}

	local function GetTabTimer(info)
		return tabWidgets[info[#info - 1]] or tabWidgets[info[#info - 2]] or tabWidgets[info[#info - 3]]
	end

	local function GetOption(info)
		return db.profile[info[#info]]
	end

	local function SetOption(info, value)
		db.profile[info[#info]] = value
		local timer = GetTabTimer(info)
		if timer.enabled then
			timer:UpdateStyle()
		end
	end

	local function SetTooltipOption(info, value)
		db.profile[info[#info]] = value
	end

	local function SetDisabled(info, value)
		local tab = info[#info - 1]
		db.profile[info[#info]] = value
		if value then
			ProfileUtils.ResetTimer(tabWidgets[tab].prefix)
		end
		tabUpdateFuncs[tab]()
	end

	local function GetColor(info)
		local colorTable = db.profile[info[#info]]
		return colorTable[1], colorTable[2], colorTable[3], colorTable[4]
	end

	local function SetColor(info, r, g, b, a)
		local colorTable = db.profile[info[#info]]
		colorTable[1] = r
		colorTable[2] = g
		colorTable[3] = b
		colorTable[4] = a
		local timer = GetTabTimer(info)
		if timer.enabled then
			timer:ApplyColors(timer.active)
		end
	end

	local function SetColorRestrictedAlpha(info, r, g, b, a)
		local colorTable = db.profile[info[#info]]
		colorTable[1] = r
		colorTable[2] = g
		colorTable[3] = b
		colorTable[4] = a < 0.3 and 0.3 or a
		local timer = GetTabTimer(info)
		if timer.enabled then
			timer:ApplyColors(timer.active)
		end
	end

	local function ValidateCustomText(_, value)
		return IsValidCustomText(value)
	end

	local function ValidateFrameName(_, frameName)
		return BigWigsAPI.IsValidFrame(frameName)
	end

	local fontList = LibSharedMedia:List("font")
	local borderList = LibSharedMedia:List("border")
	local backgroundList = LibSharedMedia:List("background")

	local function GetFontName(info)
		local fontName = db.profile[info[#info]]
		for i, v in next, fontList do
			if v == fontName then return i end
		end
	end

	local function GetBorderName(info)
		local borderName = db.profile[info[#info]]
		for i, v in next, borderList do
			if v == borderName then return i end
		end
	end

	local function GetBackgroundName(info)
		local bgName = db.profile[info[#info]]
		for i, v in next, backgroundList do
			if v == bgName then return i end
		end
	end

	local function SetFontName(info, value)
		db.profile[info[#info]] = fontList[value]
		local timer = GetTabTimer(info)
		if timer.enabled then
			timer:UpdateStyle()
		end
	end

	local function SetBorderName(info, value)
		db.profile[info[#info]] = borderList[value]
		local timer = GetTabTimer(info)
		if timer.enabled then
			timer:UpdateStyle()
		end
	end

	local function SetBackgroundName(info, value)
		db.profile[info[#info]] = backgroundList[value]
		local timer = GetTabTimer(info)
		if timer.enabled then
			timer:UpdateStyle()
		end
	end

	local function SetInactive(info, value)
		db.profile[info[#info]] = value
		local timer = GetTabTimer(info)
		if value ~= "COLOR" then
			ProfileUtils.ResetInactiveColors(timer.prefix)
		end
		if timer.enabled then
			timer:UpdateStyle()
		end
	end

	local function GetHistoryResetCondition(info, entry)
		return bit.band(db.profile[info[#info]], entry) == entry
	end

	local function SetHistoryResetCondition(info, entry, value)
		local key = info[#info]
		if value then
			db.profile[key] = bit.bor(db.profile[key], entry)
		else
			db.profile[key] = bit.band(db.profile[key], bit.bnot(entry))
		end
	end

	local function GetPosX(info)
		return db.profile[GetTabTimer(info).prefix .. "Position"][3]
	end

	local function SetPosX(info, value)
		local timer = GetTabTimer(info)
		db.profile[timer.prefix .. "Position"][3] = value
		if timer.enabled then
			timer:UpdateStyle()
		end
	end

	local function GetPosY(info)
		return db.profile[GetTabTimer(info).prefix .. "Position"][4]
	end

	local function SetPosY(info, value)
		local timer = GetTabTimer(info)
		db.profile[timer.prefix .. "Position"][4] = value
		if timer.enabled then
			timer:UpdateStyle()
		end
	end

	local function GetCustomAnchorPoint(info)
		return db.profile[GetTabTimer(info).prefix .. "Position"][5]
	end

	local function SetCustomAnchorPoint(info, value)
		local timer = GetTabTimer(info)
		local prefix = timer.prefix
		if value ~= "UIParent" then
			local pos = db.profile[prefix .. "Position"]
			pos[1] = "CENTER"
			pos[2] = "CENTER"
			pos[3] = 0
			pos[4] = 0
			pos[5] = value
		else
			ProfileUtils.ResetPosition(prefix)
		end
		if timer.enabled then
			timer:UpdateStyle()
		end
	end

	local function GetCustomAnchorPointSource(info)
		return db.profile[GetTabTimer(info).prefix .. "Position"][1]
	end

	local function SetCustomAnchorPointSource(info, value)
		if BigWigsAPI.IsValidFramePoint(value) then
			local timer = GetTabTimer(info)
			db.profile[timer.prefix .. "Position"][1] = value
			if timer.enabled then
				timer:UpdateStyle()
			end
		end
	end

	local function GetCustomAnchorPointDestination(info)
		return db.profile[GetTabTimer(info).prefix .. "Position"][2]
	end

	local function SetCustomAnchorPointDestination(info, value)
		if BigWigsAPI.IsValidFramePoint(value) then
			local timer = GetTabTimer(info)
			db.profile[timer.prefix .. "Position"][2] = value
			if timer.enabled then
				timer:UpdateStyle()
			end
		end
	end

	local function ResetGeneralFunc(info)
		local timer = GetTabTimer(info)
		ProfileUtils.ResetGeneral(timer.prefix)
		if timer.enabled then
			timer:UpdateStyle()
		end
	end

	local function ResetTimerFunc(info)
		local timer = GetTabTimer(info)
		ProfileUtils.ResetTimer(timer.prefix)
		if timer.enabled then
			timer:UpdateStyle()
		end
	end

	local function ResetAdvancedFunc(info)
		local timer = GetTabTimer(info)
		ProfileUtils.ResetAdvanced(timer.prefix)
		if timer.enabled then
			timer:UpdateStyle()
		end
	end

	local function ResetPositionFunc(info)
		local timer = GetTabTimer(info)
		ProfileUtils.ResetPosition(timer.prefix)
		if timer.enabled then
			timer:UpdateStyle()
		end
	end

	local function IsTimerDisabled(info)
		return db.profile[GetTabTimer(info).prefix .. "Disabled"]
	end

	local function IsInactiveColorDisabled(info)
		local prefix = GetTabTimer(info).prefix
		return db.profile[prefix .. "Disabled"] or db.profile[prefix .. "Inactive"] ~= "COLOR"
	end

	local function IsBorderDisabled(info)
		local prefix = GetTabTimer(info).prefix
		return db.profile[prefix .. "Disabled"] or db.profile[prefix .. "BorderName"] == "None"
	end

	local function IsBackgroundDisabled(info)
		local prefix = GetTabTimer(info).prefix
		return db.profile[prefix .. "Disabled"] or db.profile[prefix .. "BackgroundName"] == "None"
	end

	local function IsAnchorPointDefaultDisabled(info)
		local prefix = GetTabTimer(info).prefix
		return db.profile[prefix .. "Disabled"] or db.profile[prefix .. "Position"][5] == "UIParent"
	end

	local function IsLockDisabled(info)
		local prefix = GetTabTimer(info).prefix
		return db.profile[prefix .. "Disabled"] or db.profile[prefix .. "Position"][5] ~= "UIParent"
	end

	local function IsBackgroundInactiveDisabled(info)
		local prefix = GetTabTimer(info).prefix
		return db.profile[prefix .. "Disabled"] or db.profile[prefix .. "Inactive"] ~= "COLOR" or db.profile[prefix .. "BackgroundName"] == "None"
	end

	local function IsBorderInactiveDisabled(info)
		local prefix = GetTabTimer(info).prefix
		return db.profile[prefix .. "Disabled"] or db.profile[prefix .. "Inactive"] ~= "COLOR" or db.profile[prefix .. "BorderName"] == "None"
	end

	local framePointList = BigWigsAPI.GetFramePointList()
	local outlineValues = {
		NONE = L.none,
		OUTLINE = L.thin,
		THICKOUTLINE = L.thick,
	}
	local outlineSorting = {
		"NONE",
		"OUTLINE",
		"THICKOUTLINE",
	}
	local alignValues = {
		LEFT = L.LEFT,
		CENTER = L.CENTER,
		RIGHT = L.RIGHT,
	}
	local alignSorting = {
		"LEFT",
		"CENTER",
		"RIGHT",
	}
	local inactiveValues = {
		NONE = L.doNothing,
		HIDE = L.hide,
		COLOR = L.colorFade,
	}
	local inactiveSorting = {
		"NONE",
		"HIDE",
		"COLOR",
	}
	local textFormatValues = {
		"1:23",
		"1:23.4",
	}
	local historyTimeFormatValues = {
		L.twelveHour,
		L.twentyFourHour,
	}
	local historyResetValues = {
		[1] = L.enteringRaid,
		[2] = L.enteringDungeon,
		[4] = L.startingMythicKeystone,
	}
	local function CreateTimerOptions(prefix, name, desc, order, explainerKey)
		local isBossStages = prefix == "bossStages"
		local isAnyCombat = prefix == "anyCombat"

		local advancedArgs = {
			[prefix .. "Colors"] = {
				type = "group",
				name = L.colors,
				inline = true,
				order = 1,
				args = {
					[prefix .. "Color"] = {
						type = "color",
						name = L.fontColor,
						width = 1,
						get = GetColor,
						set = SetColorRestrictedAlpha,
						hasAlpha = true,
						order = 1,
						disabled = IsTimerDisabled,
					},
					[prefix .. "BackgroundColor"] = {
						type = "color",
						name = L.backgroundColor,
						width = 1,
						get = GetColor,
						set = SetColor,
						hasAlpha = true,
						order = 2,
						disabled = IsBackgroundDisabled,
					},
					[prefix .. "BorderColor"] = {
						type = "color",
						name = L.borderColor,
						order = 3,
						hasAlpha = true,
						width = 1,
						get = GetColor,
						set = SetColor,
						disabled = IsBorderDisabled,
					},
					[prefix .. "ColorInactive"] = {
						type = "color",
						name = L.parentheses:format(L.fontColor, L.inactive),
						width = 1,
						get = GetColor,
						set = SetColorRestrictedAlpha,
						hasAlpha = true,
						order = 4,
						disabled = IsInactiveColorDisabled,
					},
					[prefix .. "BackgroundColorInactive"] = {
						type = "color",
						name = L.parentheses:format(L.backgroundColor, L.inactive),
						width = 1,
						get = GetColor,
						set = SetColor,
						hasAlpha = true,
						order = 5,
						disabled = IsBackgroundInactiveDisabled,
					},
					[prefix .. "BorderColorInactive"] = {
						type = "color",
						name = L.parentheses:format(L.borderColor, L.inactive),
						order = 6,
						hasAlpha = true,
						width = 1,
						get = GetColor,
						set = SetColor,
						disabled = IsBorderInactiveDisabled,
					},
				},
			},
			[prefix .. "Inactive"] = {
				type = "select",
				name = L.whenInactive,
				values = inactiveValues,
				sorting = inactiveSorting,
				style = "radio",
				order = 2,
				set = SetInactive,
				disabled = IsTimerDisabled,
			},
			[prefix .. "TextFormat"] = {
				type = "select",
				name = L.textFormat,
				width = isBossStages and 1.2 or nil,
				values = textFormatValues,
				order = 3,
				disabled = IsTimerDisabled,
			},
			[prefix .. "HistoryTimeFormat"] = {
				type = "select",
				name = L.historyTimeFormat,
				width = isBossStages and 1.2 or nil,
				values = historyTimeFormatValues,
				set = SetTooltipOption,
				order = 4,
				disabled = IsTimerDisabled,
			},
			[prefix .. "CustomText"] = {
				type = "input",
				validate = ValidateCustomText,
				name = L.customText,
				width = 1.2,
				order = isBossStages and 5 or 7,
				disabled = IsTimerDisabled,
			},
			resetHeader = {
				type = "header",
				name = "",
				order = isBossStages and 6 or (isAnyCombat and 10 or 8),
			},
			reset = {
				type = "execute",
				name = L.reset,
				desc = L.resetDesc,
				func = ResetAdvancedFunc,
				order = isBossStages and 7 or (isAnyCombat and 11 or 9),
				disabled = IsTimerDisabled,
			},
		}

		if not isBossStages then
			advancedArgs[prefix .. "HistoryAmount"] = {
				type = "range",
				name = L.tooltipHistoryMaxLines,
				desc = L.tooltipHistoryMaxLinesDesc,
				order = 5,
				min = 5,
				max = 30,
				step = 1,
				set = SetTooltipOption,
				disabled = IsTimerDisabled,
			}
			advancedArgs[prefix .. "HistoryResetConditions"] = {
				type = "multiselect",
				name = L.tooltipHistoryResetConditions,
				desc = L.tooltipHistoryResetConditionsDesc,
				order = 6,
				values = historyResetValues,
				get = GetHistoryResetCondition,
				set = SetHistoryResetCondition,
				disabled = IsTimerDisabled,
			}
		end

		if isAnyCombat then
			advancedArgs.anyCombatCustomTextSeparator = {
				type = "description",
				name = " ",
				order = 8,
				width = "full",
			}
			advancedArgs.anyCombatHistoryHiddenInCombat = {
				type = "toggle",
				name = L.hideTooltipInCombat,
				width = 1.5,
				set = SetTooltipOption,
				order = 9,
				disabled = IsTimerDisabled,
			}
		end

		return {
			name = name,
			type = "group",
			childGroups = "tab",
			order = order,
			args = {
				[explainerKey] = {
					type = "description",
					name = desc,
					order = 0,
					width = "full",
				},
				[prefix .. "Disabled"] = {
					type = "toggle",
					name = L.disabled,
					width = 1.5,
					order = 1,
					set = SetDisabled,
				},
				[prefix .. "Locked"] = {
					type = "toggle",
					name = L.lock,
					desc = L.lockDesc,
					width = 1.5,
					order = 2,
					disabled = IsLockDisabled,
				},
				[prefix .. "General"] = {
					type = "group",
					name = L.general,
					order = 3,
					args = {
						[prefix .. "Width"] = {
							type = "range",
							name = L.width,
							min = ProfileUtils.MinimumWidth,
							max = ProfileUtils.MaximumWidth,
							step = 1,
							order = 1,
							width = 1.5,
							disabled = IsTimerDisabled,
						},
						[prefix .. "Height"] = {
							type = "range",
							name = L.height,
							min = ProfileUtils.MinimumHeight,
							max = ProfileUtils.MaximumHeight,
							step = 1,
							order = 2,
							width = 1.5,
							disabled = IsTimerDisabled,
						},
						[prefix .. "FontName"] = {
							type = "select",
							name = L.font,
							order = 3,
							values = fontList,
							itemControl = "DDI-Font",
							get = GetFontName,
							set = SetFontName,
							width = 2,
							disabled = IsTimerDisabled,
						},
						[prefix .. "Outline"] = {
							type = "select",
							name = L.outline,
							order = 4,
							values = outlineValues,
							sorting = outlineSorting,
							disabled = IsTimerDisabled,
						},
						[prefix .. "FontSize"] = {
							type = "range",
							name = L.fontSize,
							desc = L.fontSizeDesc,
							order = 5,
							width = 2,
							softMax = 100, max = 200, min = ProfileUtils.MinimumFontSize, step = 1,
							disabled = IsTimerDisabled,
						},
						[prefix .. "Monochrome"] = {
							type = "toggle",
							name = L.monochrome,
							desc = L.monochromeDesc,
							order = 6,
							disabled = IsTimerDisabled,
						},
						[prefix .. "Align"] = {
							type = "select",
							name = L.align,
							values = alignValues,
							sorting = alignSorting,
							style = "radio",
							order = 7,
							disabled = IsTimerDisabled,
						},
						[prefix .. "BorderName"] = {
							type = "select",
							name = L.borderName,
							order = 8,
							values = borderList,
							get = GetBorderName,
							set = SetBorderName,
							width = 1.5,
							disabled = IsTimerDisabled,
						},
						[prefix .. "BackgroundName"] = {
							type = "select",
							name = L.background,
							order = 9,
							values = backgroundList,
							get = GetBackgroundName,
							set = SetBackgroundName,
							width = 1.5,
							disabled = IsTimerDisabled,
						},
						[prefix .. "BorderSize"] = {
							type = "range",
							name = L.borderSize,
							order = 10,
							min = 1,
							max = 32,
							step = 1,
							width = 1.5,
							disabled = IsBorderDisabled,
						},
						[prefix .. "BorderOffset"] = {
							type = "range",
							name = L.borderOffset,
							order = 11,
							min = 0,
							max = 32,
							step = 1,
							width = 1.5,
							disabled = IsBorderDisabled,
						},
						resetHeader = {
							type = "header",
							name = "",
							order = 12,
						},
						reset = {
							type = "execute",
							name = L.reset,
							desc = L.resetDesc,
							func = ResetGeneralFunc,
							order = 13,
							disabled = IsTimerDisabled,
						},
						resetAll = {
							type = "execute",
							name = L.resetAll,
							desc = L.resetAllDesc:format(name),
							func = ResetTimerFunc,
							order = 14,
							disabled = IsTimerDisabled,
						},
					},
				},
				[prefix .. "Advanced"] = {
					type = "group",
					name = L.advanced,
					order = 4,
					args = advancedArgs,
				},
				[prefix .. "ExactPositioning"] = {
					type = "group",
					name = L.positionExact,
					order = 5,
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
							get = GetPosX,
							set = SetPosX,
							disabled = IsTimerDisabled,
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
							get = GetPosY,
							set = SetPosY,
							disabled = IsTimerDisabled,
						},
						customAnchorPoint = {
							type = "input",
							get = GetCustomAnchorPoint,
							set = SetCustomAnchorPoint,
							validate = ValidateFrameName,
							name = L.customAnchorPoint,
							order = 3,
							width = 3,
							disabled = IsTimerDisabled,
						},
						customAnchorPointSource = {
							type = "select",
							get = GetCustomAnchorPointSource,
							set = SetCustomAnchorPointSource,
							values = framePointList,
							name = L.sourcePoint,
							order = 4,
							width = 1.5,
							disabled = IsAnchorPointDefaultDisabled,
						},
						customAnchorPointDestination = {
							type = "select",
							get = GetCustomAnchorPointDestination,
							set = SetCustomAnchorPointDestination,
							values = framePointList,
							name = L.destinationPoint,
							order = 5,
							width = 1.5,
							disabled = IsAnchorPointDefaultDisabled,
						},
						resetHeader = {
							type = "header",
							name = "",
							order = 6,
						},
						reset = {
							type = "execute",
							name = L.reset,
							desc = L.resetDesc,
							func = ResetPositionFunc,
							order = 7,
							disabled = IsTimerDisabled,
						},
					},
				},
			},
		}
	end

	return {
		type = "group",
		childGroups = "tab",
		name = L.combatTimerTitle,
		order = 2,
		get = GetOption,
		set = SetOption,
		args = {
			all = CreateTimerOptions("anyCombat", L.anyCombatTimer, L.anyCombatTimerDesc, 1, "explainAnyCombat"),
			boss = CreateTimerOptions("bossCombat", L.bossCombatTimer, L.bossCombatTimerDesc, 2, "explainBossCombat"),
			bossStages = CreateTimerOptions("bossStages", L.bossStagesTimer, L.bossStagesTimerDesc, 3, "explainBossStages"),
		},
	}
end)

--------------------------------------------------------------------------------
-- Login
--

do
	local function UpdateProfile()
		ProfileUtils.ValidateMainSettings()
		ProfileUtils.ValidateMediaSettings()
		ProfileUtils.ValidateAnchorFrames()
		UpdateAnyCombatWidget()
		UpdateBossCombatWidget()
		UpdateBossStagesWidget()
	end
	local loginFrame = CreateFrame("Frame")
	loginFrame:SetScript("OnEvent", function(self, event)
		self:UnregisterEvent(event)
		self:SetScript("OnEvent", nil)
		UpdateProfile()
		BigWigsLoader.RegisterMessage({}, "BigWigs_ProfileUpdate", UpdateProfile)
	end)
	loginFrame:RegisterEvent("PLAYER_ENTERING_WORLD") -- Using PEW instead of PLAYER_LOGIN as this module depends on instance IDs
	ProfileUtils.ValidateMainSettings()
end
