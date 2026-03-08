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
}

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
		anyCombatPosition = {"CENTER", "CENTER", 500, -150, "UIParent"},
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
		anyCombatInactive = "NONE",
		anyCombatTextFormat = 1,

		-- Boss Combat
		bossCombatDisabled = true,
		bossCombatLocked = false,
		bossCombatWidth = 50,
		bossCombatHeight = 24,
		bossCombatPosition = {"CENTER", "CENTER", 555, -150, "UIParent"},
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
		bossCombatInactive = "NONE",
		bossCombatTextFormat = 1,

		-- Instance Timer
		instanceTimerDisabled = true,
		instanceTimerLocked = false,
		instanceTimerWidth = 50,
		instanceTimerHeight = 24,
		instanceTimerPosition = {"CENTER", "CENTER", 610, -150, "UIParent"},
		instanceTimerFontName = fontName,
		instanceTimerFontSize = 16,
		instanceTimerMonochrome = false,
		instanceTimerOutline = "OUTLINE",
		instanceTimerAlign = "CENTER",
		instanceTimerColor = {1, 1, 1, 1},
		instanceTimerColorInactive = {1, 1, 1, 0.3},
		instanceTimerBackgroundColor = {0, 0, 0, 0.5},
		instanceTimerBackgroundColorInactive = {0, 0, 0, 0.3},
		instanceTimerBorderColor = {0, 0, 0, 1},
		instanceTimerBorderColorInactive = {0, 0, 0, 0.3},
		instanceTimerBorderSize = 1,
		instanceTimerBorderOffset = 0,
		instanceTimerBorderName = "Solid",
		instanceTimerInactive = "NONE",
		instanceTimerTextFormat = 1,
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

	ProfileUtils.ValidateMainSettings = function()
		for k, v in next, db.profile do
			local defaultType = type(defaults[k])
			if defaultType == "nil" then
				db.profile[k] = nil
			elseif type(v) ~= defaultType then
				db.profile[k] = defaults[k]
			end
		end

		if db.profile.anyCombatWidth < ProfileUtils.MinimumWidth or db.profile.anyCombatWidth > ProfileUtils.MaximumWidth then
			db.profile.anyCombatWidth = defaults.anyCombatWidth
		end
		if db.profile.anyCombatHeight < ProfileUtils.MinimumHeight or db.profile.anyCombatHeight > ProfileUtils.MaximumHeight then
			db.profile.anyCombatHeight = defaults.anyCombatHeight
		end
		if type(db.profile.anyCombatPosition[1]) ~= "string" or type(db.profile.anyCombatPosition[2]) ~= "string"
		or type(db.profile.anyCombatPosition[3]) ~= "number" or type(db.profile.anyCombatPosition[4]) ~= "number"
		or not BigWigsAPI.IsValidFramePoint(db.profile.anyCombatPosition[1]) or not BigWigsAPI.IsValidFramePoint(db.profile.anyCombatPosition[2]) then
			db.profile.anyCombatPosition = CopyTable(defaults.anyCombatPosition)
		else
			local x = math.floor(db.profile.anyCombatPosition[3]+0.5)
			if x ~= db.profile.anyCombatPosition[3] then
				db.profile.anyCombatPosition[3] = x
			end
			local y = math.floor(db.profile.anyCombatPosition[4]+0.5)
			if y ~= db.profile.anyCombatPosition[4] then
				db.profile.anyCombatPosition[4] = y
			end
		end
		if db.profile.anyCombatPosition[5] ~= defaults.anyCombatPosition[5] then
			local frame = _G[db.profile.anyCombatPosition[5]]
			if type(frame) ~= "table" or type(frame.GetObjectType) ~= "function" or type(frame.IsForbidden) ~= "function" or frame:IsForbidden() then
				db.profile.anyCombatPosition = CopyTable(defaults.anyCombatPosition)
			end
		end
		if db.profile.anyCombatFontSize < 14 or db.profile.anyCombatFontSize > 200 then
			db.profile.anyCombatFontSize = defaults.anyCombatFontSize
		end
		if db.profile.anyCombatOutline ~= "NONE" and db.profile.anyCombatOutline ~= "OUTLINE" and db.profile.anyCombatOutline ~= "THICKOUTLINE" then
			db.profile.anyCombatOutline = defaults.anyCombatOutline
		end
		if db.profile.anyCombatAlign ~= "LEFT" and db.profile.anyCombatAlign ~= "CENTER" and db.profile.anyCombatAlign ~= "RIGHT" then
			db.profile.anyCombatAlign = defaults.anyCombatAlign
		end
		if db.profile.anyCombatBorderSize < 1 or db.profile.anyCombatBorderSize > 32 then
			db.profile.anyCombatBorderSize = defaults.anyCombatBorderSize
		end
		if db.profile.anyCombatBorderOffset < 0 or db.profile.anyCombatBorderOffset > 32 then
			db.profile.anyCombatBorderOffset = defaults.anyCombatBorderOffset
		end
		if db.profile.anyCombatInactive ~= "NONE" and db.profile.anyCombatInactive ~= "HIDE" and db.profile.anyCombatInactive ~= "COLOR" then
			db.profile.anyCombatInactive = defaults.anyCombatInactive
		end
		if db.profile.anyCombatTextFormat ~= 1 and db.profile.anyCombatTextFormat ~= 2 then
			db.profile.anyCombatTextFormat = defaults.anyCombatTextFormat
		end

		ValidateColor(db.profile.anyCombatColor, defaults.anyCombatColor, 0.3)
		ValidateColor(db.profile.anyCombatColorInactive, defaults.anyCombatColorInactive, 0.3)
		ValidateColor(db.profile.anyCombatBackgroundColor, defaults.anyCombatBackgroundColor, 0)
		ValidateColor(db.profile.anyCombatBackgroundColorInactive, defaults.anyCombatBackgroundColorInactive, 0)
		ValidateColor(db.profile.anyCombatBorderColor, defaults.anyCombatBorderColor, 0)
		ValidateColor(db.profile.anyCombatBorderColorInactive, defaults.anyCombatBorderColorInactive, 0)

		if db.profile.bossCombatWidth < ProfileUtils.MinimumWidth or db.profile.bossCombatWidth > ProfileUtils.MaximumWidth then
			db.profile.bossCombatWidth = defaults.bossCombatWidth
		end
		if db.profile.bossCombatHeight < ProfileUtils.MinimumHeight or db.profile.bossCombatHeight > ProfileUtils.MaximumHeight then
			db.profile.bossCombatHeight = defaults.bossCombatHeight
		end
		if type(db.profile.bossCombatPosition[1]) ~= "string" or type(db.profile.bossCombatPosition[2]) ~= "string"
		or type(db.profile.bossCombatPosition[3]) ~= "number" or type(db.profile.bossCombatPosition[4]) ~= "number"
		or not BigWigsAPI.IsValidFramePoint(db.profile.bossCombatPosition[1]) or not BigWigsAPI.IsValidFramePoint(db.profile.bossCombatPosition[2]) then
			db.profile.bossCombatPosition = CopyTable(defaults.bossCombatPosition)
		else
			local x = math.floor(db.profile.bossCombatPosition[3]+0.5)
			if x ~= db.profile.bossCombatPosition[3] then
				db.profile.bossCombatPosition[3] = x
			end
			local y = math.floor(db.profile.bossCombatPosition[4]+0.5)
			if y ~= db.profile.bossCombatPosition[4] then
				db.profile.bossCombatPosition[4] = y
			end
		end
		if db.profile.bossCombatPosition[5] ~= defaults.bossCombatPosition[5] then
			local frame = _G[db.profile.bossCombatPosition[5]]
			if type(frame) ~= "table" or type(frame.GetObjectType) ~= "function" or type(frame.IsForbidden) ~= "function" or frame:IsForbidden() then
				db.profile.bossCombatPosition = CopyTable(defaults.bossCombatPosition)
			end
		end
		if db.profile.bossCombatFontSize < 14 or db.profile.bossCombatFontSize > 200 then
			db.profile.bossCombatFontSize = defaults.bossCombatFontSize
		end
		if db.profile.bossCombatOutline ~= "NONE" and db.profile.bossCombatOutline ~= "OUTLINE" and db.profile.bossCombatOutline ~= "THICKOUTLINE" then
			db.profile.bossCombatOutline = defaults.bossCombatOutline
		end
		if db.profile.bossCombatAlign ~= "LEFT" and db.profile.bossCombatAlign ~= "CENTER" and db.profile.bossCombatAlign ~= "RIGHT" then
			db.profile.bossCombatAlign = defaults.bossCombatAlign
		end
		if db.profile.bossCombatBorderSize < 1 or db.profile.bossCombatBorderSize > 32 then
			db.profile.bossCombatBorderSize = defaults.bossCombatBorderSize
		end
		if db.profile.bossCombatBorderOffset < 0 or db.profile.bossCombatBorderOffset > 32 then
			db.profile.bossCombatBorderOffset = defaults.bossCombatBorderOffset
		end
		if db.profile.bossCombatInactive ~= "NONE" and db.profile.bossCombatInactive ~= "HIDE" and db.profile.bossCombatInactive ~= "COLOR" then
			db.profile.bossCombatInactive = defaults.bossCombatInactive
		end
		if db.profile.bossCombatTextFormat ~= 1 and db.profile.bossCombatTextFormat ~= 2 then
			db.profile.bossCombatTextFormat = defaults.bossCombatTextFormat
		end

		ValidateColor(db.profile.bossCombatColor, defaults.bossCombatColor, 0.3)
		ValidateColor(db.profile.bossCombatColorInactive, defaults.bossCombatColorInactive, 0.3)
		ValidateColor(db.profile.bossCombatBackgroundColor, defaults.bossCombatBackgroundColor, 0)
		ValidateColor(db.profile.bossCombatBackgroundColorInactive, defaults.bossCombatBackgroundColorInactive, 0)
		ValidateColor(db.profile.bossCombatBorderColor, defaults.bossCombatBorderColor, 0)
		ValidateColor(db.profile.bossCombatBorderColorInactive, defaults.bossCombatBorderColorInactive, 0)

		if db.profile.instanceTimerWidth < ProfileUtils.MinimumWidth or db.profile.instanceTimerWidth > ProfileUtils.MaximumWidth then
			db.profile.instanceTimerWidth = defaults.instanceTimerWidth
		end
		if db.profile.instanceTimerHeight < ProfileUtils.MinimumHeight or db.profile.instanceTimerHeight > ProfileUtils.MaximumHeight then
			db.profile.instanceTimerHeight = defaults.instanceTimerHeight
		end
		if type(db.profile.instanceTimerPosition[1]) ~= "string" or type(db.profile.instanceTimerPosition[2]) ~= "string"
		or type(db.profile.instanceTimerPosition[3]) ~= "number" or type(db.profile.instanceTimerPosition[4]) ~= "number"
		or not BigWigsAPI.IsValidFramePoint(db.profile.instanceTimerPosition[1]) or not BigWigsAPI.IsValidFramePoint(db.profile.instanceTimerPosition[2]) then
			db.profile.instanceTimerPosition = CopyTable(defaults.instanceTimerPosition)
		else
			local x = math.floor(db.profile.instanceTimerPosition[3]+0.5)
			if x ~= db.profile.instanceTimerPosition[3] then
				db.profile.instanceTimerPosition[3] = x
			end
			local y = math.floor(db.profile.instanceTimerPosition[4]+0.5)
			if y ~= db.profile.instanceTimerPosition[4] then
				db.profile.instanceTimerPosition[4] = y
			end
		end
		if db.profile.instanceTimerPosition[5] ~= defaults.instanceTimerPosition[5] then
			local frame = _G[db.profile.instanceTimerPosition[5]]
			if type(frame) ~= "table" or type(frame.GetObjectType) ~= "function" or type(frame.IsForbidden) ~= "function" or frame:IsForbidden() then
				db.profile.instanceTimerPosition = CopyTable(defaults.instanceTimerPosition)
			end
		end
		if db.profile.instanceTimerFontSize < 14 or db.profile.instanceTimerFontSize > 200 then
			db.profile.instanceTimerFontSize = defaults.instanceTimerFontSize
		end
		if db.profile.instanceTimerOutline ~= "NONE" and db.profile.instanceTimerOutline ~= "OUTLINE" and db.profile.instanceTimerOutline ~= "THICKOUTLINE" then
			db.profile.instanceTimerOutline = defaults.instanceTimerOutline
		end
		if db.profile.instanceTimerAlign ~= "LEFT" and db.profile.instanceTimerAlign ~= "CENTER" and db.profile.instanceTimerAlign ~= "RIGHT" then
			db.profile.instanceTimerAlign = defaults.instanceTimerAlign
		end
		if db.profile.instanceTimerBorderSize < 1 or db.profile.instanceTimerBorderSize > 32 then
			db.profile.instanceTimerBorderSize = defaults.instanceTimerBorderSize
		end
		if db.profile.instanceTimerBorderOffset < 0 or db.profile.instanceTimerBorderOffset > 32 then
			db.profile.instanceTimerBorderOffset = defaults.instanceTimerBorderOffset
		end
		if db.profile.instanceTimerInactive ~= "NONE" and db.profile.instanceTimerInactive ~= "HIDE" and db.profile.instanceTimerInactive ~= "COLOR" then
			db.profile.instanceTimerInactive = defaults.instanceTimerInactive
		end
		if db.profile.instanceTimerTextFormat ~= 1 and db.profile.instanceTimerTextFormat ~= 2 then
			db.profile.instanceTimerTextFormat = defaults.instanceTimerTextFormat
		end

		ValidateColor(db.profile.instanceTimerColor, defaults.instanceTimerColor, 0.3)
		ValidateColor(db.profile.instanceTimerColorInactive, defaults.instanceTimerColorInactive, 0.3)
		ValidateColor(db.profile.instanceTimerBackgroundColor, defaults.instanceTimerBackgroundColor, 0)
		ValidateColor(db.profile.instanceTimerBackgroundColorInactive, defaults.instanceTimerBackgroundColorInactive, 0)
		ValidateColor(db.profile.instanceTimerBorderColor, defaults.instanceTimerBorderColor, 0)
		ValidateColor(db.profile.instanceTimerBorderColorInactive, defaults.instanceTimerBorderColorInactive, 0)
	end
	ProfileUtils.ValidateMediaSettings = function()
		if not LibSharedMedia:IsValid("font", db.profile.anyCombatFontName) then
			db.profile.anyCombatFontName = defaults.anyCombatFontName
		end
		if not LibSharedMedia:IsValid("border", db.profile.anyCombatBorderName) then -- If the border is suddenly invalid then reset the size and offset also
			db.profile.anyCombatBorderName = defaults.anyCombatBorderName
			db.profile.anyCombatBorderSize = defaults.anyCombatBorderSize
			db.profile.anyCombatBorderOffset = defaults.anyCombatBorderOffset
		end

		if not LibSharedMedia:IsValid("font", db.profile.bossCombatFontName) then
			db.profile.bossCombatFontName = defaults.bossCombatFontName
		end
		if not LibSharedMedia:IsValid("border", db.profile.bossCombatBorderName) then -- If the border is suddenly invalid then reset the size and offset also
			db.profile.bossCombatBorderName = defaults.bossCombatBorderName
			db.profile.bossCombatBorderSize = defaults.bossCombatBorderSize
			db.profile.bossCombatBorderOffset = defaults.bossCombatBorderOffset
		end

		if not LibSharedMedia:IsValid("font", db.profile.instanceTimerFontName) then
			db.profile.instanceTimerFontName = defaults.instanceTimerFontName
		end
		if not LibSharedMedia:IsValid("border", db.profile.instanceTimerBorderName) then -- If the border is suddenly invalid then reset the size and offset also
			db.profile.instanceTimerBorderName = defaults.instanceTimerBorderName
			db.profile.instanceTimerBorderSize = defaults.instanceTimerBorderSize
			db.profile.instanceTimerBorderOffset = defaults.instanceTimerBorderOffset
		end
	end

	ProfileUtils.ResetAnyCombat = function()
		db.profile.anyCombatLocked = defaults.anyCombatLocked
		db.profile.anyCombatWidth = defaults.anyCombatWidth
		db.profile.anyCombatHeight = defaults.anyCombatHeight
		db.profile.anyCombatPosition = CopyTable(defaults.anyCombatPosition)
		db.profile.anyCombatFontName = defaults.anyCombatFontName
		db.profile.anyCombatFontSize = defaults.anyCombatFontSize
		db.profile.anyCombatMonochrome = defaults.anyCombatMonochrome
		db.profile.anyCombatOutline = defaults.anyCombatOutline
		db.profile.anyCombatAlign = defaults.anyCombatAlign
		db.profile.anyCombatColor = CopyTable(defaults.anyCombatColor)
		db.profile.anyCombatColorInactive = CopyTable(defaults.anyCombatColorInactive)
		db.profile.anyCombatBackgroundColor = CopyTable(defaults.anyCombatBackgroundColor)
		db.profile.anyCombatBackgroundColorInactive = CopyTable(defaults.anyCombatBackgroundColorInactive)
		db.profile.anyCombatBorderColor = CopyTable(defaults.anyCombatBorderColor)
		db.profile.anyCombatBorderColorInactive = CopyTable(defaults.anyCombatBorderColorInactive)
		db.profile.anyCombatBorderSize = defaults.anyCombatBorderSize
		db.profile.anyCombatBorderOffset = defaults.anyCombatBorderOffset
		db.profile.anyCombatBorderName = defaults.anyCombatBorderName
		db.profile.anyCombatInactive = defaults.anyCombatInactive
		db.profile.anyCombatTextFormat = defaults.anyCombatTextFormat
	end
	ProfileUtils.ResetAnyCombatBorder = function()
		db.profile.anyCombatBorderColor = CopyTable(defaults.anyCombatBorderColor)
		db.profile.anyCombatBorderColorInactive = CopyTable(defaults.anyCombatBorderColorInactive)
		db.profile.anyCombatBorderSize = defaults.anyCombatBorderSize
		db.profile.anyCombatBorderOffset = defaults.anyCombatBorderOffset
	end
	ProfileUtils.ResetAnyCombatInactiveColors = function()
		db.profile.anyCombatColorInactive = CopyTable(defaults.anyCombatColorInactive)
		db.profile.anyCombatBackgroundColorInactive = CopyTable(defaults.anyCombatBackgroundColorInactive)
		db.profile.anyCombatBorderColorInactive = CopyTable(defaults.anyCombatBorderColorInactive)
	end
	ProfileUtils.ResetAnyCombatPosition = function()
		db.profile.anyCombatPosition = CopyTable(defaults.anyCombatPosition)
	end

	ProfileUtils.ResetBossCombat = function()
		db.profile.bossCombatLocked = defaults.bossCombatLocked
		db.profile.bossCombatWidth = defaults.bossCombatWidth
		db.profile.bossCombatHeight = defaults.bossCombatHeight
		db.profile.bossCombatPosition = CopyTable(defaults.bossCombatPosition)
		db.profile.bossCombatFontName = defaults.bossCombatFontName
		db.profile.bossCombatFontSize = defaults.bossCombatFontSize
		db.profile.bossCombatMonochrome = defaults.bossCombatMonochrome
		db.profile.bossCombatOutline = defaults.bossCombatOutline
		db.profile.bossCombatAlign = defaults.bossCombatAlign
		db.profile.bossCombatColor = CopyTable(defaults.bossCombatColor)
		db.profile.bossCombatColorInactive = CopyTable(defaults.bossCombatColorInactive)
		db.profile.bossCombatBackgroundColor = CopyTable(defaults.bossCombatBackgroundColor)
		db.profile.bossCombatBackgroundColorInactive = CopyTable(defaults.bossCombatBackgroundColorInactive)
		db.profile.bossCombatBorderColor = CopyTable(defaults.bossCombatBorderColor)
		db.profile.bossCombatBorderColorInactive = CopyTable(defaults.bossCombatBorderColorInactive)
		db.profile.bossCombatBorderSize = defaults.bossCombatBorderSize
		db.profile.bossCombatBorderOffset = defaults.bossCombatBorderOffset
		db.profile.bossCombatBorderName = defaults.bossCombatBorderName
		db.profile.bossCombatInactive = defaults.bossCombatInactive
		db.profile.bossCombatTextFormat = defaults.bossCombatTextFormat
	end
	ProfileUtils.ResetBossCombatBorder = function()
		db.profile.bossCombatBorderColor = CopyTable(defaults.bossCombatBorderColor)
		db.profile.bossCombatBorderColorInactive = CopyTable(defaults.bossCombatBorderColorInactive)
		db.profile.bossCombatBorderSize = defaults.bossCombatBorderSize
		db.profile.bossCombatBorderOffset = defaults.bossCombatBorderOffset
	end
	ProfileUtils.ResetBossCombatInactiveColors = function()
		db.profile.bossCombatColorInactive = CopyTable(defaults.bossCombatColorInactive)
		db.profile.bossCombatBackgroundColorInactive = CopyTable(defaults.bossCombatBackgroundColorInactive)
		db.profile.bossCombatBorderColorInactive = CopyTable(defaults.bossCombatBorderColorInactive)
	end
	ProfileUtils.ResetBossCombatPosition = function()
		db.profile.bossCombatPosition = CopyTable(defaults.bossCombatPosition)
	end

	ProfileUtils.ResetInstanceTimer = function()
		db.profile.instanceTimerLocked = defaults.instanceTimerLocked
		db.profile.instanceTimerWidth = defaults.instanceTimerWidth
		db.profile.instanceTimerHeight = defaults.instanceTimerHeight
		db.profile.instanceTimerPosition = CopyTable(defaults.instanceTimerPosition)
		db.profile.instanceTimerFontName = defaults.instanceTimerFontName
		db.profile.instanceTimerFontSize = defaults.instanceTimerFontSize
		db.profile.instanceTimerMonochrome = defaults.instanceTimerMonochrome
		db.profile.instanceTimerOutline = defaults.instanceTimerOutline
		db.profile.instanceTimerAlign = defaults.instanceTimerAlign
		db.profile.instanceTimerColor = CopyTable(defaults.instanceTimerColor)
		db.profile.instanceTimerColorInactive = CopyTable(defaults.instanceTimerColorInactive)
		db.profile.instanceTimerBackgroundColor = CopyTable(defaults.instanceTimerBackgroundColor)
		db.profile.instanceTimerBackgroundColorInactive = CopyTable(defaults.instanceTimerBackgroundColorInactive)
		db.profile.instanceTimerBorderColor = CopyTable(defaults.instanceTimerBorderColor)
		db.profile.instanceTimerBorderColorInactive = CopyTable(defaults.instanceTimerBorderColorInactive)
		db.profile.instanceTimerBorderSize = defaults.instanceTimerBorderSize
		db.profile.instanceTimerBorderOffset = defaults.instanceTimerBorderOffset
		db.profile.instanceTimerBorderName = defaults.instanceTimerBorderName
		db.profile.instanceTimerInactive = defaults.instanceTimerInactive
		db.profile.instanceTimerTextFormat = defaults.instanceTimerTextFormat
	end
	ProfileUtils.ResetInstanceTimerBorder = function()
		db.profile.instanceTimerBorderColor = CopyTable(defaults.instanceTimerBorderColor)
		db.profile.instanceTimerBorderColorInactive = CopyTable(defaults.instanceTimerBorderColorInactive)
		db.profile.instanceTimerBorderSize = defaults.instanceTimerBorderSize
		db.profile.instanceTimerBorderOffset = defaults.instanceTimerBorderOffset
	end
	ProfileUtils.ResetInstanceTimerInactiveColors = function()
		db.profile.instanceTimerColorInactive = CopyTable(defaults.instanceTimerColorInactive)
		db.profile.instanceTimerBackgroundColorInactive = CopyTable(defaults.instanceTimerBackgroundColorInactive)
		db.profile.instanceTimerBorderColorInactive = CopyTable(defaults.instanceTimerBorderColorInactive)
	end
	ProfileUtils.ResetInstanceTimerPosition = function()
		db.profile.instanceTimerPosition = CopyTable(defaults.instanceTimerPosition)
	end
end

--------------------------------------------------------------------------------
-- Widgets & Events
--

local widgets = {
	anyCombatActive = false,
	anyCombatHistoryTime = {},
	anyCombatHistoryDuration = {},

	bossCombatActive = false,
	bossCombatHistoryTime = {},
	bossCombatHistoryDuration = {},

	instanceTimerActive = false,
	instanceTimerHistoryTime = {},
	instanceTimerHistoryDuration = {},
}

-- Any Combat
do
	local main = CreateFrame("Frame", nil, UIParent)
	main:Hide()
	main:SetFrameStrata("MEDIUM")
	main:SetFixedFrameStrata(true)
	main:SetFrameLevel(5010)
	main:SetFixedFrameLevel(true)
	main:SetClampedToScreen(true)
	main:EnableMouse(true)
	main:RegisterForDrag("LeftButton")
	main:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	main:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local point, _, relPoint, x, y = self:GetPoint()
		x = math.floor(x+0.5)
		y = math.floor(y+0.5)
		db.profile.anyCombatPosition[1] = point
		db.profile.anyCombatPosition[2] = relPoint
		db.profile.anyCombatPosition[3] = x
		db.profile.anyCombatPosition[4] = y
		local acr = LibStub("AceConfigRegistry-3.0", true)
		if acr then
			acr:NotifyChange("BigWigsTools")
		end
	end)
	main:SetScript("OnEnter", function(self)
		bwTooltip:SetOwner(self, "ANCHOR_TOP")
		bwTooltip:AddLine(L.anyCombatTimerTooltip)
		for i = 1, #widgets.anyCombatHistoryTime do
			bwTooltip:AddDoubleLine(widgets.anyCombatHistoryTime[i], SecondsToTime(widgets.anyCombatHistoryDuration[i]), 1, 1, 1, 0, 1, 0)
		end
		bwTooltip:Show()
	end)
	main:SetScript("OnLeave", function(self)
		bwTooltip:Hide()
	end)
	widgets.anyCombat = main

	local bg = main:CreateTexture()
	bg:SetAllPoints(main)
	bg:Show()
	widgets.anyCombatBG = bg

	local border = CreateFrame("Frame", nil, main, "BackdropTemplate")
	border:Show()
	widgets.anyCombatBorder = border

	local text = main:CreateFontString()
	widgets.anyCombatText = text

	local current = 0
	local increment = 1
	local updater = main:CreateAnimationGroup()
	updater:SetLooping("REPEAT")
	updater:SetScript("OnLoop", function()
		current = current + increment
		widgets.anyCombatHistoryDuration[1] = current
		local m = current/60
		local s = current % 60
		text:SetFormattedText(db.profile.anyCombatTextFormat == 2 and "%d:%04.1f" or "%d:%02d", m, s)
	end)
	local anim = updater:CreateAnimation()
	anim:SetDuration(1)
	local prevCombatEnd = 0
	main:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_REGEN_DISABLED" then
			widgets.anyCombatActive = true
			local t = GetTime()
			local elapsed = t-prevCombatEnd
			if elapsed <= 2 then -- If you re-enter combat within 2 sec then we don't consider it as ended
				local secondsToAdd = 0
				if db.profile.anyCombatTextFormat == 2 then
					local roundedText = string.format("%.1f", elapsed)
					local rounded = tonumber(roundedText)
					if rounded then
						secondsToAdd = rounded
					end
				else
					local rounded = math.floor(elapsed+0.5)
					secondsToAdd = rounded
				end
				current = current + secondsToAdd
			else
				current = 0
				table.insert(widgets.anyCombatHistoryTime, 1, date("[%I:%M:%S %p]"))
				table.insert(widgets.anyCombatHistoryDuration, 1, current)
				-- Limit to 10 entries
				widgets.anyCombatHistoryTime[11] = nil
				widgets.anyCombatHistoryDuration[11] = nil
				text:SetText(db.profile.anyCombatTextFormat == 2 and "0:00.0" or "0:00")
			end
			if db.profile.anyCombatTextFormat == 2 then
				anim:SetDuration(0.1)
				increment = 0.1
			else
				anim:SetDuration(1)
				increment = 1
			end
			updater:Play()
			if db.profile.anyCombatInactive == "COLOR" then
				local textColor = db.profile.anyCombatColor
				text:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
				local bgColor = db.profile.anyCombatBackgroundColor
				bg:SetColorTexture(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
				local borderColor = db.profile.anyCombatBorderColor
				border:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
			elseif db.profile.anyCombatInactive == "HIDE" then
				self:Show()
			end
		elseif event == "PLAYER_REGEN_ENABLED" then
			widgets.anyCombatActive = false
			updater:Stop()
			prevCombatEnd = GetTime()
			if db.profile.anyCombatInactive == "COLOR" then
				local textColor = db.profile.anyCombatColorInactive
				text:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
				local bgColor = db.profile.anyCombatBackgroundColorInactive
				bg:SetColorTexture(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
				local borderColor = db.profile.anyCombatBorderColorInactive
				border:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
			elseif db.profile.anyCombatInactive == "HIDE" then
				self:Hide()
			end
		end
	end)
end

-- Boss Combat
do
	local main = CreateFrame("Frame", nil, UIParent)
	main:Hide()
	main:SetFrameStrata("MEDIUM")
	main:SetFixedFrameStrata(true)
	main:SetFrameLevel(5005)
	main:SetFixedFrameLevel(true)
	main:SetClampedToScreen(true)
	main:EnableMouse(true)
	main:RegisterForDrag("LeftButton")
	main:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	main:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local point, _, relPoint, x, y = self:GetPoint()
		x = math.floor(x+0.5)
		y = math.floor(y+0.5)
		db.profile.bossCombatPosition[1] = point
		db.profile.bossCombatPosition[2] = relPoint
		db.profile.bossCombatPosition[3] = x
		db.profile.bossCombatPosition[4] = y
		local acr = LibStub("AceConfigRegistry-3.0", true)
		if acr then
			acr:NotifyChange("BigWigsTools")
		end
	end)
	local encounterStatusTexts = {
		[0] = L.defeat,
		[1] = L.victory,
		[2] = L.inProgress,
	}
	main:SetScript("OnEnter", function(self)
		bwTooltip:SetOwner(self, "ANCHOR_TOP")
		bwTooltip:AddLine(L.bossCombatTimerTooltip)
		for i = 1, #widgets.bossCombatHistoryTime do
			bwTooltip:AddDoubleLine(
				widgets.bossCombatHistoryTime[i][1],
				("%s [%s]"):format(SecondsToTime(widgets.bossCombatHistoryDuration[i][1]), encounterStatusTexts[widgets.bossCombatHistoryDuration[i][2]]),
				1, 1, 1,
				0, 1, 0
			)
		end
		bwTooltip:Show()
	end)
	main:SetScript("OnLeave", function(self)
		bwTooltip:Hide()
	end)
	widgets.bossCombat = main

	local bg = main:CreateTexture()
	bg:SetAllPoints(main)
	bg:Show()
	widgets.bossCombatBG = bg

	local border = CreateFrame("Frame", nil, main, "BackdropTemplate")
	border:Show()
	widgets.bossCombatBorder = border

	local text = main:CreateFontString()
	widgets.bossCombatText = text

	local increment = 1
	local updater = main:CreateAnimationGroup()
	updater:SetLooping("REPEAT")
	updater:SetScript("OnLoop", function()
		for i = 1, #widgets.bossCombatHistoryDuration do
			local tbl = widgets.bossCombatHistoryDuration[i]
			if tbl[2] == 2 then
				local current = tbl[1] + increment
				tbl[1] = current
				local m = current/60
				local s = current % 60
				text:SetFormattedText(db.profile.bossCombatTextFormat == 2 and "%d:%04.1f" or "%d:%02d", m, s)
			end
		end
	end)
	local anim = updater:CreateAnimation()
	anim:SetDuration(1)
	main:SetScript("OnEvent", function(self, event, encounterID, encounterName, _, _, success)
		if event == "ENCOUNTER_START" then
			local tooltipText = ("%s %s"):format(date("[%I:%M:%S %p]"), encounterName)
			table.insert(widgets.bossCombatHistoryTime, 1, {tooltipText, encounterID})
			table.insert(widgets.bossCombatHistoryDuration, 1, {0, 2})
			-- Limit to 10 entries
			widgets.bossCombatHistoryTime[11] = nil
			widgets.bossCombatHistoryDuration[11] = nil
			if not widgets.bossCombatActive then
				widgets.bossCombatActive = true
				if db.profile.bossCombatTextFormat == 2 then
					anim:SetDuration(0.1)
					increment = 0.1
					text:SetText("0:00.0")
				else
					anim:SetDuration(1)
					increment = 1
					text:SetText("0:00")
				end
				updater:Play()
				if db.profile.bossCombatInactive == "COLOR" then
					local textColor = db.profile.bossCombatColor
					text:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
					local bgColor = db.profile.bossCombatBackgroundColor
					bg:SetColorTexture(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
					local borderColor = db.profile.bossCombatBorderColor
					border:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
				elseif db.profile.bossCombatInactive == "HIDE" then
					self:Show()
				end
			end
		elseif event == "ENCOUNTER_END" then
			for i = 1, #widgets.bossCombatHistoryTime do
				local tblTime = widgets.bossCombatHistoryTime[i]
				local tblDuration = widgets.bossCombatHistoryDuration[i]
				if tblTime[2] == encounterID and tblDuration[2] == 2 then -- Find this encounter and change its status
					tblDuration[2] = success
					break
				end
			end
			for i = 1, #widgets.bossCombatHistoryDuration do
				if widgets.bossCombatHistoryDuration[i][2] == 2 then -- Another encounter is still in progress
					return
				end
			end
			widgets.bossCombatActive = false
			updater:Stop()
			if db.profile.bossCombatInactive == "COLOR" then
				local textColor = db.profile.bossCombatColorInactive
				text:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
				local bgColor = db.profile.bossCombatBackgroundColorInactive
				bg:SetColorTexture(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
				local borderColor = db.profile.bossCombatBorderColorInactive
				border:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
			elseif db.profile.bossCombatInactive == "HIDE" then
				self:Hide()
			end
		elseif event == "PLAYER_LEAVING_WORLD" then -- Classic support, allows you to release during encounter combat :(
			for i = 1, #widgets.bossCombatHistoryDuration do
				local tbl = widgets.bossCombatHistoryDuration[i]
				if tbl[2] == 2 then -- In progress
					tbl[2] = 0
				end
			end
			widgets.bossCombatActive = false
			updater:Stop()
			if db.profile.bossCombatInactive == "COLOR" then
				local textColor = db.profile.bossCombatColorInactive
				text:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
				local bgColor = db.profile.bossCombatBackgroundColorInactive
				bg:SetColorTexture(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
				local borderColor = db.profile.bossCombatBorderColorInactive
				border:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
			elseif db.profile.bossCombatInactive == "HIDE" then
				self:Hide()
			end
		end
	end)
end

-- Instance Timer
do
	local main = CreateFrame("Frame", nil, UIParent)
	main:Hide()
	main:SetFrameStrata("MEDIUM")
	main:SetFixedFrameStrata(true)
	main:SetFrameLevel(5000)
	main:SetFixedFrameLevel(true)
	main:SetClampedToScreen(true)
	main:EnableMouse(true)
	main:RegisterForDrag("LeftButton")
	main:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	main:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local point, _, relPoint, x, y = self:GetPoint()
		x = math.floor(x+0.5)
		y = math.floor(y+0.5)
		db.profile.instanceTimerPosition[1] = point
		db.profile.instanceTimerPosition[2] = relPoint
		db.profile.instanceTimerPosition[3] = x
		db.profile.instanceTimerPosition[4] = y
		local acr = LibStub("AceConfigRegistry-3.0", true)
		if acr then
			acr:NotifyChange("BigWigsTools")
		end
	end)
	main:SetScript("OnEnter", function(self)
		bwTooltip:SetOwner(self, "ANCHOR_TOP")
		bwTooltip:AddLine(L.instanceTimerTooltip)
		for i = 1, #widgets.instanceTimerHistoryTime do
			bwTooltip:AddDoubleLine(widgets.instanceTimerHistoryTime[i], SecondsToTime(widgets.instanceTimerHistoryDuration[i]), 1, 1, 1, 0, 1, 0)
		end
		bwTooltip:Show()
	end)
	main:SetScript("OnLeave", function(self)
		bwTooltip:Hide()
	end)
	widgets.instanceTimer = main

	local bg = main:CreateTexture()
	bg:SetAllPoints(main)
	bg:Show()
	widgets.instanceTimerBG = bg

	local border = CreateFrame("Frame", nil, main, "BackdropTemplate")
	border:Show()
	widgets.instanceTimerBorder = border

	local text = main:CreateFontString()
	widgets.instanceTimerText = text

	local increment = 1
	local updater = main:CreateAnimationGroup()
	updater:SetLooping("REPEAT")
	updater:SetScript("OnLoop", function()
		local current = widgets.instanceTimerHistoryDuration[1] + increment
		widgets.instanceTimerHistoryDuration[1] = current
		local m = current/60
		local s = current % 60
		text:SetFormattedText(db.profile.instanceTimerTextFormat == 2 and "%d:%04.1f" or "%d:%02d", m, s)
	end)
	local anim = updater:CreateAnimation()
	anim:SetDuration(1)
	widgets.instanceTimerEnterWorldFunc = function()
		local _, instanceType, difficultyID, _, _, _, _, instanceID = BigWigsLoader.GetInstanceInfo()
		if instanceType ~= "none" and not widgets.instanceTimerActive then
			widgets.instanceTimerActive = true
			local difficultyName = GetDifficultyInfo(difficultyID)
			if not difficultyName then
				difficultyName = instanceType
			end
			local zoneAndDifficulty = L.parentheses:format(GetRealZoneText(instanceID), difficultyName)
			local tooltipText = ("%s %s"):format(date("[%I:%M:%S %p]"), zoneAndDifficulty)
			table.insert(widgets.instanceTimerHistoryTime, 1, tooltipText)
			table.insert(widgets.instanceTimerHistoryDuration, 1, 0)
			-- Limit to 10 entries
			widgets.instanceTimerHistoryTime[11] = nil
			widgets.instanceTimerHistoryDuration[11] = nil
			if db.profile.instanceTimerTextFormat == 2 then
				anim:SetDuration(0.1)
				increment = 0.1
				text:SetText("0:00.0")
			else
				anim:SetDuration(1)
				increment = 1
				text:SetText("0:00")
			end
			updater:Play()
			if db.profile.instanceTimerInactive == "COLOR" then
				local textColor = db.profile.instanceTimerColor
				text:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
				local bgColor = db.profile.instanceTimerBackgroundColor
				bg:SetColorTexture(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
				local borderColor = db.profile.instanceTimerBorderColor
				border:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
			elseif db.profile.instanceTimerInactive == "HIDE" then
				main:Show()
			end
		end
	end
	main:SetScript("OnEvent", function(self, event)
		if event == "PLAYER_ENTERING_WORLD" then
			BigWigsLoader.CTimerAfter(0, widgets.instanceTimerEnterWorldFunc) -- Difficulty info isn't accurate until 1 frame after PEW
		elseif event == "PLAYER_LEAVING_WORLD" then
			if widgets.instanceTimerActive then
				widgets.instanceTimerActive = false
				updater:Stop()
				if db.profile.instanceTimerInactive == "COLOR" then
					local textColor = db.profile.instanceTimerColorInactive
					text:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
					local bgColor = db.profile.instanceTimerBackgroundColorInactive
					bg:SetColorTexture(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
					local borderColor = db.profile.instanceTimerBorderColorInactive
					border:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
				elseif db.profile.instanceTimerInactive == "HIDE" then
					self:Hide()
				end
			end
		end
	end)
end

--------------------------------------------------------------------------------
-- Options Table
--

local function UpdateAnyCombatWidget()
	if not db.profile.anyCombatDisabled then
		widgets.anyCombat:RegisterEvent("PLAYER_REGEN_DISABLED")
		widgets.anyCombat:RegisterEvent("PLAYER_REGEN_ENABLED")

		widgets.anyCombat:SetSize(db.profile.anyCombatWidth, db.profile.anyCombatHeight)
		local point, relPoint = db.profile.anyCombatPosition[1], db.profile.anyCombatPosition[2]
		local x, y = db.profile.anyCombatPosition[3], db.profile.anyCombatPosition[4]
		widgets.anyCombat:ClearAllPoints()
		widgets.anyCombat:SetPoint(point, db.profile.anyCombatPosition[5], relPoint, x, y)
		if db.profile.anyCombatLocked then
			widgets.anyCombat:SetMovable(false)
			widgets.anyCombat:SetPropagateMouseClicks(true)
		else
			widgets.anyCombat:SetMovable(true)
			widgets.anyCombat:SetPropagateMouseClicks(false)
		end

		widgets.anyCombatText:ClearAllPoints()
		widgets.anyCombatText:SetPoint(db.profile.anyCombatAlign, db.profile.anyCombatAlign == "LEFT" and 1 or db.profile.anyCombatAlign == "RIGHT" and -1 or 0, 0)
		widgets.anyCombatText:SetJustifyH(db.profile.anyCombatAlign)
		local flags = nil
		if db.profile.anyCombatMonochrome and db.profile.anyCombatOutline ~= "NONE" then
			flags = "MONOCHROME," .. db.profile.anyCombatOutline
		elseif db.profile.anyCombatMonochrome then
			flags = "MONOCHROME"
		elseif db.profile.anyCombatOutline ~= "NONE" then
			flags = db.profile.anyCombatOutline
		end
		widgets.anyCombatText:SetFont(LibSharedMedia:Fetch("font", db.profile.anyCombatFontName), db.profile.anyCombatFontSize, flags)
		widgets.anyCombatText:SetText(db.profile.anyCombatTextFormat == 2 and "0:00.0" or "0:00")

		local borderTable = {
			edgeFile = LibSharedMedia:Fetch("border", db.profile.anyCombatBorderName),
			edgeSize = db.profile.anyCombatBorderSize,
		}

		widgets.anyCombatBorder:SetBackdrop(borderTable)
		widgets.anyCombatBorder:ClearAllPoints()
		widgets.anyCombatBorder:SetPoint("TOPLEFT", widgets.anyCombat, "TOPLEFT", -db.profile.anyCombatBorderOffset, db.profile.anyCombatBorderOffset)
		widgets.anyCombatBorder:SetPoint("BOTTOMRIGHT", widgets.anyCombat, "BOTTOMRIGHT", db.profile.anyCombatBorderOffset, -db.profile.anyCombatBorderOffset)

		if widgets.anyCombatActive then
				local textColor = db.profile.anyCombatColor
				widgets.anyCombatText:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
				local bgColor = db.profile.anyCombatBackgroundColor
				widgets.anyCombatBG:SetColorTexture(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
				local borderColor = db.profile.anyCombatBorderColor
				widgets.anyCombatBorder:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
				widgets.anyCombat:Show()
		else
			if db.profile.anyCombatInactive == "COLOR" then
				local textColor = db.profile.anyCombatColorInactive
				widgets.anyCombatText:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
				local bgColor = db.profile.anyCombatBackgroundColorInactive
				widgets.anyCombatBG:SetColorTexture(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
				local borderColor = db.profile.anyCombatBorderColorInactive
				widgets.anyCombatBorder:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
				widgets.anyCombat:Show()
			else
				local textColor = db.profile.anyCombatColor
				widgets.anyCombatText:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
				local bgColor = db.profile.anyCombatBackgroundColor
				widgets.anyCombatBG:SetColorTexture(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
				local borderColor = db.profile.anyCombatBorderColor
				widgets.anyCombatBorder:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
				if db.profile.anyCombatInactive == "HIDE" then
					widgets.anyCombat:Hide()
				else
					widgets.anyCombat:Show()
				end
			end
		end
	else
		widgets.anyCombat:UnregisterEvent("PLAYER_REGEN_DISABLED")
		widgets.anyCombat:UnregisterEvent("PLAYER_REGEN_ENABLED")
		widgets.anyCombat:Hide()
	end
end

local function UpdateBossCombatWidget()
	if not db.profile.bossCombatDisabled then
		widgets.bossCombat:RegisterEvent("ENCOUNTER_START")
		widgets.bossCombat:RegisterEvent("ENCOUNTER_END")
		if BigWigsLoader.isClassic then
			widgets.bossCombat:RegisterEvent("PLAYER_LEAVING_WORLD")
		end

		widgets.bossCombat:SetSize(db.profile.bossCombatWidth, db.profile.bossCombatHeight)
		local point, relPoint = db.profile.bossCombatPosition[1], db.profile.bossCombatPosition[2]
		local x, y = db.profile.bossCombatPosition[3], db.profile.bossCombatPosition[4]
		widgets.bossCombat:ClearAllPoints()
		widgets.bossCombat:SetPoint(point, db.profile.bossCombatPosition[5], relPoint, x, y)
		if db.profile.bossCombatLocked then
			widgets.bossCombat:SetMovable(false)
			widgets.bossCombat:SetPropagateMouseClicks(true)
		else
			widgets.bossCombat:SetMovable(true)
			widgets.bossCombat:SetPropagateMouseClicks(false)
		end

		widgets.bossCombatText:ClearAllPoints()
		widgets.bossCombatText:SetPoint(db.profile.bossCombatAlign, db.profile.bossCombatAlign == "LEFT" and 1 or db.profile.bossCombatAlign == "RIGHT" and -1 or 0, 0)
		widgets.bossCombatText:SetJustifyH(db.profile.bossCombatAlign)
		local flags = nil
		if db.profile.bossCombatMonochrome and db.profile.bossCombatOutline ~= "NONE" then
			flags = "MONOCHROME," .. db.profile.bossCombatOutline
		elseif db.profile.bossCombatMonochrome then
			flags = "MONOCHROME"
		elseif db.profile.bossCombatOutline ~= "NONE" then
			flags = db.profile.bossCombatOutline
		end
		widgets.bossCombatText:SetFont(LibSharedMedia:Fetch("font", db.profile.bossCombatFontName), db.profile.bossCombatFontSize, flags)
		widgets.bossCombatText:SetText(db.profile.bossCombatTextFormat == 2 and "0:00.0" or "0:00")

		local borderTable = {
			edgeFile = LibSharedMedia:Fetch("border", db.profile.bossCombatBorderName),
			edgeSize = db.profile.bossCombatBorderSize,
		}

		widgets.bossCombatBorder:SetBackdrop(borderTable)
		widgets.bossCombatBorder:ClearAllPoints()
		widgets.bossCombatBorder:SetPoint("TOPLEFT", widgets.bossCombat, "TOPLEFT", -db.profile.bossCombatBorderOffset, db.profile.bossCombatBorderOffset)
		widgets.bossCombatBorder:SetPoint("BOTTOMRIGHT", widgets.bossCombat, "BOTTOMRIGHT", db.profile.bossCombatBorderOffset, -db.profile.bossCombatBorderOffset)

		if widgets.bossCombatActive then
				local textColor = db.profile.bossCombatColor
				widgets.bossCombatText:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
				local bgColor = db.profile.bossCombatBackgroundColor
				widgets.bossCombatBG:SetColorTexture(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
				local borderColor = db.profile.bossCombatBorderColor
				widgets.bossCombatBorder:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
				widgets.bossCombat:Show()
		else
			if db.profile.bossCombatInactive == "COLOR" then
				local textColor = db.profile.bossCombatColorInactive
				widgets.bossCombatText:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
				local bgColor = db.profile.bossCombatBackgroundColorInactive
				widgets.bossCombatBG:SetColorTexture(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
				local borderColor = db.profile.bossCombatBorderColorInactive
				widgets.bossCombatBorder:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
				widgets.bossCombat:Show()
			else
				local textColor = db.profile.bossCombatColor
				widgets.bossCombatText:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
				local bgColor = db.profile.bossCombatBackgroundColor
				widgets.bossCombatBG:SetColorTexture(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
				local borderColor = db.profile.bossCombatBorderColor
				widgets.bossCombatBorder:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
				if db.profile.bossCombatInactive == "HIDE" then
					widgets.bossCombat:Hide()
				else
					widgets.bossCombat:Show()
				end
			end
		end
	else
		widgets.bossCombat:UnregisterEvent("ENCOUNTER_START")
		widgets.bossCombat:UnregisterEvent("ENCOUNTER_END")
		if BigWigsLoader.isClassic then
			widgets.bossCombat:UnregisterEvent("PLAYER_LEAVING_WORLD")
		end
		widgets.bossCombat:Hide()
	end
end

local function UpdateInstanceTimerWidget()
	if not db.profile.instanceTimerDisabled then
		widgets.instanceTimer:RegisterEvent("PLAYER_ENTERING_WORLD")
		widgets.instanceTimer:RegisterEvent("PLAYER_LEAVING_WORLD")

		widgets.instanceTimer:SetSize(db.profile.instanceTimerWidth, db.profile.instanceTimerHeight)
		local point, relPoint = db.profile.instanceTimerPosition[1], db.profile.instanceTimerPosition[2]
		local x, y = db.profile.instanceTimerPosition[3], db.profile.instanceTimerPosition[4]
		widgets.instanceTimer:ClearAllPoints()
		widgets.instanceTimer:SetPoint(point, db.profile.instanceTimerPosition[5], relPoint, x, y)
		if db.profile.instanceTimerLocked then
			widgets.instanceTimer:SetMovable(false)
			widgets.instanceTimer:SetPropagateMouseClicks(true)
		else
			widgets.instanceTimer:SetMovable(true)
			widgets.instanceTimer:SetPropagateMouseClicks(false)
		end

		widgets.instanceTimerText:ClearAllPoints()
		widgets.instanceTimerText:SetPoint(db.profile.instanceTimerAlign, db.profile.instanceTimerAlign == "LEFT" and 1 or db.profile.instanceTimerAlign == "RIGHT" and -1 or 0, 0)
		widgets.instanceTimerText:SetJustifyH(db.profile.instanceTimerAlign)
		local flags = nil
		if db.profile.instanceTimerMonochrome and db.profile.instanceTimerOutline ~= "NONE" then
			flags = "MONOCHROME," .. db.profile.instanceTimerOutline
		elseif db.profile.instanceTimerMonochrome then
			flags = "MONOCHROME"
		elseif db.profile.instanceTimerOutline ~= "NONE" then
			flags = db.profile.instanceTimerOutline
		end
		widgets.instanceTimerText:SetFont(LibSharedMedia:Fetch("font", db.profile.instanceTimerFontName), db.profile.instanceTimerFontSize, flags)
		widgets.instanceTimerText:SetText(db.profile.instanceTimerTextFormat == 2 and "0:00.0" or "0:00")

		local borderTable = {
			edgeFile = LibSharedMedia:Fetch("border", db.profile.instanceTimerBorderName),
			edgeSize = db.profile.instanceTimerBorderSize,
		}

		widgets.instanceTimerBorder:SetBackdrop(borderTable)
		widgets.instanceTimerBorder:ClearAllPoints()
		widgets.instanceTimerBorder:SetPoint("TOPLEFT", widgets.instanceTimer, "TOPLEFT", -db.profile.instanceTimerBorderOffset, db.profile.instanceTimerBorderOffset)
		widgets.instanceTimerBorder:SetPoint("BOTTOMRIGHT", widgets.instanceTimer, "BOTTOMRIGHT", db.profile.instanceTimerBorderOffset, -db.profile.instanceTimerBorderOffset)

		if widgets.instanceTimerActive then
				local textColor = db.profile.instanceTimerColor
				widgets.instanceTimerText:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
				local bgColor = db.profile.instanceTimerBackgroundColor
				widgets.instanceTimerBG:SetColorTexture(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
				local borderColor = db.profile.instanceTimerBorderColor
				widgets.instanceTimerBorder:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
				widgets.instanceTimer:Show()
		else
			if db.profile.instanceTimerInactive == "COLOR" then
				local textColor = db.profile.instanceTimerColorInactive
				widgets.instanceTimerText:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
				local bgColor = db.profile.instanceTimerBackgroundColorInactive
				widgets.instanceTimerBG:SetColorTexture(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
				local borderColor = db.profile.instanceTimerBorderColorInactive
				widgets.instanceTimerBorder:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
				widgets.instanceTimer:Show()
			else
				local textColor = db.profile.instanceTimerColor
				widgets.instanceTimerText:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
				local bgColor = db.profile.instanceTimerBackgroundColor
				widgets.instanceTimerBG:SetColorTexture(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
				local borderColor = db.profile.instanceTimerBorderColor
				widgets.instanceTimerBorder:SetBackdropBorderColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
				if db.profile.instanceTimerInactive == "HIDE" then
					widgets.instanceTimer:Hide()
				else
					widgets.instanceTimer:Show()
				end
			end
		end
	else
		widgets.instanceTimer:UnregisterEvent("PLAYER_ENTERING_WORLD")
		widgets.instanceTimer:UnregisterEvent("PLAYER_LEAVING_WORLD")
		widgets.instanceTimer:Hide()
	end
end

do
	local function GetColor(info)
		local colorTable = db.profile[info[#info]]
		return colorTable[1], colorTable[2], colorTable[3], colorTable[4]
	end

	local function SetColor(info, r, g, b, a)
		local key = info[#info]
		db.profile[key] = {r, g, b, a}
		UpdateAnyCombatWidget()
		UpdateBossCombatWidget()
		UpdateInstanceTimerWidget()
	end

	local function SetColorRestrictedAlpha(info, r, g, b, a)
		local key = info[#info]
		db.profile[key] = {r, g, b, a < 0.3 and 0.3 or a}
		UpdateAnyCombatWidget()
		UpdateBossCombatWidget()
		UpdateInstanceTimerWidget()
	end

	local function AnyCombatDisabled()
		return db.profile.anyCombatDisabled
	end

	local function BossCombatDisabled()
		return db.profile.bossCombatDisabled
	end

	local function InstanceTimerDisabled()
		return db.profile.instanceTimerDisabled
	end

	local function AnyCombatDisabledOrNoSeparateInactiveColors()
		return db.profile.anyCombatDisabled or db.profile.anyCombatInactive ~= "COLOR"
	end

	local function BossCombatDisabledOrNoSeparateInactiveColors()
		return db.profile.bossCombatDisabled or db.profile.bossCombatInactive ~= "COLOR"
	end

	local function InstanceTimerDisabledOrNoSeparateInactiveColors()
		return db.profile.instanceTimerDisabled or db.profile.instanceTimerInactive ~= "COLOR"
	end

	local function AnyCombatDisabledOrBorderSetToNone()
		return db.profile.anyCombatDisabled or db.profile.anyCombatBorderName == "None"
	end

	local function BossCombatDisabledOrBorderSetToNone()
		return db.profile.bossCombatDisabled or db.profile.bossCombatBorderName == "None"
	end

	local function InstanceTimerDisabledOrBorderSetToNone()
		return db.profile.instanceTimerDisabled or db.profile.instanceTimerBorderName == "None"
	end

	local function AnyCombatDisabledOrAnchorPointDefault()
		return db.profile.anyCombatDisabled or db.profile.anyCombatPosition[5] == "UIParent"
	end

	local function BossCombatDisabledOrAnchorPointDefault()
		return db.profile.bossCombatDisabled or db.profile.bossCombatPosition[5] == "UIParent"
	end

	local function InstanceTimerDisabledOrAnchorPointDefault()
		return db.profile.instanceTimerDisabled or db.profile.instanceTimerPosition[5] == "UIParent"
	end

	BigWigsAPI.RegisterToolOptions("CombatTimer", {
		type = "group",
		childGroups = "tab",
		name = L.combatTimerTitle,
		order = 2,
		get = function(info)
			return db.profile[info[#info]]
		end,
		args = {
			all = {
				name = L.anyCombatTimer,
				type = "group",
				childGroups = "tab",
				set = function(info, value)
					local key = info[#info]
					db.profile[key] = value
					UpdateAnyCombatWidget()
				end,
				order = 1,
				args = {
					explainAnyCombat = {
						type = "description",
						name = L.anyCombatTimerDesc,
						order = 0,
						width = "full",
					},
					anyCombatDisabled = {
						type = "toggle",
						name = L.disabled,
						width = 1.1,
						order = 1,
						set = function(info, value)
							local key = info[#info]
							db.profile[key] = value
							if value then
								ProfileUtils.ResetAnyCombat()
							end
							UpdateAnyCombatWidget()
						end,
					},
					anyCombatLocked = {
						type = "toggle",
						name = L.lock,
						desc = L.lockDesc,
						width = 1.1,
						order = 2,
						disabled = AnyCombatDisabled,
					},
					anyCombatReset = {
						type = "execute",
						name = L.reset,
						desc = L.resetDesc,
						width = 1,
						func = function()
							ProfileUtils.ResetAnyCombat()
							UpdateAnyCombatWidget()
						end,
						order = 3,
						disabled = AnyCombatDisabled,
					},
					anyCombatGeneral = {
						type = "group",
						name = L.general,
						order = 4,
						args = {
							anyCombatWidth = {
								type = "range",
								name = L.width,
								desc = L.sizeDesc,
								min = ProfileUtils.MinimumWidth,
								max = ProfileUtils.MaximumWidth,
								step = 1,
								order = 1,
								width = 1.5,
								disabled = AnyCombatDisabled,
							},
							anyCombatHeight = {
								type = "range",
								name = L.height,
								desc = L.sizeDesc,
								min = ProfileUtils.MinimumHeight,
								max = ProfileUtils.MaximumHeight,
								step = 1,
								order = 2,
								width = 1.5,
								disabled = AnyCombatDisabled,
							},
							anyCombatFontName = {
								type = "select",
								name = L.font,
								order = 3,
								values = LibSharedMedia:List("font"),
								itemControl = "DDI-Font",
								get = function()
									for i, v in next, LibSharedMedia:List("font") do
										if v == db.profile.anyCombatFontName then return i end
									end
								end,
								set = function(_, value)
									local list = LibSharedMedia:List("font")
									db.profile.anyCombatFontName = list[value]
									UpdateAnyCombatWidget()
								end,
								width = 2,
								disabled = AnyCombatDisabled,
							},
							anyCombatOutline = {
								type = "select",
								name = L.outline,
								order = 4,
								values = {
									NONE = L.none,
									OUTLINE = L.thin,
									THICKOUTLINE = L.thick,
								},
								sorting = {
									"NONE",
									"OUTLINE",
									"THICKOUTLINE",
								},
								disabled = AnyCombatDisabled,
							},
							anyCombatFontSize = {
								type = "range",
								name = L.fontSize,
								desc = L.fontSizeDesc,
								order = 5,
								width = 2,
								softMax = 100, max = 200, min = 14, step = 1,
								disabled = AnyCombatDisabled,
							},
							anyCombatMonochrome = {
								type = "toggle",
								name = L.monochrome,
								desc = L.monochromeDesc,
								order = 6,
								disabled = AnyCombatDisabled,
							},
							anyCombatAlign = {
								type = "select",
								name = L.align,
								values = {
									LEFT = L.LEFT,
									CENTER = L.CENTER,
									RIGHT = L.RIGHT,
								},
								sorting = {
									"LEFT",
									"CENTER",
									"RIGHT",
								},
								style = "radio",
								order = 7,
								disabled = AnyCombatDisabled,
							},
							anyCombatBorderName = {
								type = "select",
								name = L.borderName,
								order = 8,
								values = LibSharedMedia:List("border"),
								get = function()
									for i, v in next, LibSharedMedia:List("border") do
										if v == db.profile.anyCombatBorderName then return i end
									end
								end,
								set = function(_, value)
									local list = LibSharedMedia:List("border")
									db.profile.anyCombatBorderName = list[value]
									if db.profile.anyCombatBorderName == "None" then
										ProfileUtils.ResetAnyCombatBorder()
									end
									UpdateAnyCombatWidget()
								end,
								width = 1,
								disabled = AnyCombatDisabled,
							},
							anyCombatBorderSize = {
								type = "range",
								name = L.borderSize,
								order = 9,
								min = 1,
								max = 32,
								step = 1,
								width = 1,
								disabled = AnyCombatDisabledOrBorderSetToNone,
							},
							anyCombatBorderOffset = {
								type = "range",
								name = L.borderOffset,
								order = 10,
								min = 0,
								max = 32,
								step = 1,
								width = 1,
								disabled = AnyCombatDisabledOrBorderSetToNone,
							},
						},
					},
					anyCombatAdvanced = {
						type = "group",
						name = L.advanced,
						order = 5,
						args = {
							anyCombatColors = {
								type = "group",
								name = L.colors,
								inline = true,
								order = 1,
								args = {
									anyCombatColor = {
										type = "color",
										name = L.fontColor,
										width = 1,
										get = GetColor,
										set = SetColorRestrictedAlpha,
										hasAlpha = true,
										order = 1,
										disabled = AnyCombatDisabled,
									},
									anyCombatBackgroundColor = {
										type = "color",
										name = L.backgroundColor,
										width = 1,
										get = GetColor,
										set = SetColor,
										hasAlpha = true,
										order = 2,
										disabled = AnyCombatDisabled,
									},
									anyCombatBorderColor = {
										type = "color",
										name = L.borderColor,
										order = 3,
										hasAlpha = true,
										width = 1,
										get = GetColor,
										set = SetColor,
										disabled = function() return AnyCombatDisabled() or db.profile.anyCombatBorderName == "None" end,
									},
									anyCombatColorInactive = {
										type = "color",
										name = L.parentheses:format(L.fontColor, L.inactive),
										width = 1,
										get = GetColor,
										set = SetColorRestrictedAlpha,
										hasAlpha = true,
										order = 4,
										disabled = AnyCombatDisabledOrNoSeparateInactiveColors,
									},
									anyCombatBackgroundColorInactive = {
										type = "color",
										name = L.parentheses:format(L.backgroundColor, L.inactive),
										width = 1,
										get = GetColor,
										set = SetColor,
										hasAlpha = true,
										order = 5,
										disabled = AnyCombatDisabledOrNoSeparateInactiveColors,
									},
									anyCombatBorderColorInactive = {
										type = "color",
										name = L.parentheses:format(L.borderColor, L.inactive),
										order = 6,
										hasAlpha = true,
										width = 1,
										get = GetColor,
										set = SetColor,
										disabled = function() return AnyCombatDisabledOrNoSeparateInactiveColors() or db.profile.anyCombatBorderName == "None" end,
									},
								},
							},
							anyCombatInactive = {
								type = "select",
								name = L.whenInactive,
								values = {
									NONE = L.doNothing,
									HIDE = L.hide,
									COLOR = L.colorFade,
								},
								sorting = {
									"NONE",
									"HIDE",
									"COLOR",
								},
								style = "radio",
								order = 2,
								set = function(info, value)
									local key = info[#info]
									db.profile[key] = value
									if value ~= "COLOR" then
										ProfileUtils.ResetAnyCombatInactiveColors()
									end
									UpdateAnyCombatWidget()
								end,
								disabled = AnyCombatDisabled,
							},
							anyCombatTextFormat = {
								type = "select",
								name = L.textFormat,
								values = {
									"1:23",
									"1:23.4",
								},
								order = 3,
							},
						},
					},
					anyCombatExactPositioning = {
						type = "group",
						name = L.positionExact,
						order = 6,
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
									return db.profile.anyCombatPosition[3]
								end,
								set = function(_, value)
									db.profile.anyCombatPosition[3] = value
									UpdateAnyCombatWidget()
								end,
								disabled = AnyCombatDisabled,
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
									return db.profile.anyCombatPosition[4]
								end,
								set = function(_, value)
									db.profile.anyCombatPosition[4] = value
									UpdateAnyCombatWidget()
								end,
								disabled = AnyCombatDisabled,
							},
							customAnchorPoint = {
								type = "input",
								get = function()
									return db.profile.anyCombatPosition[5]
								end,
								set = function(_, value)
									if value ~= "UIParent" then
										db.profile.anyCombatPosition[1] = "CENTER"
										db.profile.anyCombatPosition[2] = "CENTER"
										db.profile.anyCombatPosition[3] = 0
										db.profile.anyCombatPosition[4] = 0
										db.profile.anyCombatPosition[5] = value
									else
										ProfileUtils.ResetAnyCombatPosition()
									end
									UpdateAnyCombatWidget()
								end,
								validate = function(_, value)
									local frame = _G[value]
									if type(frame) ~= "table" or type(frame.GetObjectType) ~= "function" or type(frame.IsForbidden) ~= "function" or frame:IsForbidden() then
										return false
									end
									return true
								end,
								name = L.customAnchorPoint,
								order = 3,
								width = 3,
								disabled = AnyCombatDisabled,
							},
							customAnchorPointSource = {
								type = "select",
								get = function()
									return db.profile.anyCombatPosition[1]
								end,
								set = function(_, value)
									if BigWigsAPI.IsValidFramePoint(value) then
										db.profile.anyCombatPosition[1] = value
										UpdateAnyCombatWidget()
									end
								end,
								values = BigWigsAPI.GetFramePointList(),
								name = L.sourcePoint,
								order = 4,
								width = 1.5,
								disabled = AnyCombatDisabledOrAnchorPointDefault,
							},
							customAnchorPointDestination = {
								type = "select",
								get = function()
									return db.profile.anyCombatPosition[2]
								end,
								set = function(_, value)
									if BigWigsAPI.IsValidFramePoint(value) then
										db.profile.anyCombatPosition[2] = value
										UpdateAnyCombatWidget()
									end
								end,
								values = BigWigsAPI.GetFramePointList(),
								name = L.destinationPoint,
								order = 5,
								width = 1.5,
								disabled = AnyCombatDisabledOrAnchorPointDefault,
							},
							anyCombatPositionResetHeader = {
								type = "header",
								name = "",
								order = 6,
							},
							anyCombatPositionReset = {
								type = "execute",
								name = L.reset,
								desc = L.resetDesc,
								func = function()
									ProfileUtils.ResetAnyCombatPosition()
									UpdateAnyCombatWidget()
								end,
								order = 7,
								disabled = AnyCombatDisabled,
							},
						},
					},
				},
			},
			boss = {
				name = L.bossCombatTimer,
				type = "group",
				childGroups = "tab",
				set = function(info, value)
					local key = info[#info]
					db.profile[key] = value
					UpdateBossCombatWidget()
				end,
				order = 1,
				args = {
					explainBossCombat = {
						type = "description",
						name = L.bossCombatTimerDesc,
						order = 0,
						width = "full",
					},
					bossCombatDisabled = {
						type = "toggle",
						name = L.disabled,
						width = 1.1,
						order = 1,
						set = function(info, value)
							local key = info[#info]
							db.profile[key] = value
							if value then
								ProfileUtils.ResetBossCombat()
							end
							UpdateBossCombatWidget()
						end,
					},
					bossCombatLocked = {
						type = "toggle",
						name = L.lock,
						desc = L.lockDesc,
						width = 1.1,
						order = 2,
						disabled = BossCombatDisabled,
					},
					bossCombatReset = {
						type = "execute",
						name = L.reset,
						desc = L.resetDesc,
						width = 1,
						func = function()
							ProfileUtils.ResetBossCombat()
							UpdateBossCombatWidget()
						end,
						order = 3,
						disabled = BossCombatDisabled,
					},
					bossCombatGeneral = {
						type = "group",
						name = L.general,
						order = 4,
						args = {
							bossCombatWidth = {
								type = "range",
								name = L.width,
								desc = L.sizeDesc,
								min = ProfileUtils.MinimumWidth,
								max = ProfileUtils.MaximumWidth,
								step = 1,
								order = 1,
								width = 1.5,
								disabled = BossCombatDisabled,
							},
							bossCombatHeight = {
								type = "range",
								name = L.height,
								desc = L.sizeDesc,
								min = ProfileUtils.MinimumHeight,
								max = ProfileUtils.MaximumHeight,
								step = 1,
								order = 2,
								width = 1.5,
								disabled = BossCombatDisabled,
							},
							bossCombatFontName = {
								type = "select",
								name = L.font,
								order = 3,
								values = LibSharedMedia:List("font"),
								itemControl = "DDI-Font",
								get = function()
									for i, v in next, LibSharedMedia:List("font") do
										if v == db.profile.bossCombatFontName then return i end
									end
								end,
								set = function(_, value)
									local list = LibSharedMedia:List("font")
									db.profile.bossCombatFontName = list[value]
									UpdateBossCombatWidget()
								end,
								width = 2,
								disabled = BossCombatDisabled,
							},
							bossCombatOutline = {
								type = "select",
								name = L.outline,
								order = 4,
								values = {
									NONE = L.none,
									OUTLINE = L.thin,
									THICKOUTLINE = L.thick,
								},
								sorting = {
									"NONE",
									"OUTLINE",
									"THICKOUTLINE",
								},
								disabled = BossCombatDisabled,
							},
							bossCombatFontSize = {
								type = "range",
								name = L.fontSize,
								desc = L.fontSizeDesc,
								order = 5,
								width = 2,
								softMax = 100, max = 200, min = 14, step = 1,
								disabled = BossCombatDisabled,
							},
							bossCombatMonochrome = {
								type = "toggle",
								name = L.monochrome,
								desc = L.monochromeDesc,
								order = 6,
								disabled = BossCombatDisabled,
							},
							bossCombatAlign = {
								type = "select",
								name = L.align,
								values = {
									LEFT = L.LEFT,
									CENTER = L.CENTER,
									RIGHT = L.RIGHT,
								},
								sorting = {
									"LEFT",
									"CENTER",
									"RIGHT",
								},
								style = "radio",
								order = 7,
								disabled = BossCombatDisabled,
							},
							bossCombatBorderName = {
								type = "select",
								name = L.borderName,
								order = 8,
								values = LibSharedMedia:List("border"),
								get = function()
									for i, v in next, LibSharedMedia:List("border") do
										if v == db.profile.bossCombatBorderName then return i end
									end
								end,
								set = function(_, value)
									local list = LibSharedMedia:List("border")
									db.profile.bossCombatBorderName = list[value]
									if db.profile.bossCombatBorderName == "None" then
										ProfileUtils.ResetBossCombatBorder()
									end
									UpdateBossCombatWidget()
								end,
								width = 1,
								disabled = BossCombatDisabled,
							},
							bossCombatBorderSize = {
								type = "range",
								name = L.borderSize,
								order = 9,
								min = 1,
								max = 32,
								step = 1,
								width = 1,
								disabled = BossCombatDisabledOrBorderSetToNone,
							},
							bossCombatBorderOffset = {
								type = "range",
								name = L.borderOffset,
								order = 10,
								min = 0,
								max = 32,
								step = 1,
								width = 1,
								disabled = BossCombatDisabledOrBorderSetToNone,
							},
						},
					},
					bossCombatAdvanced = {
						type = "group",
						name = L.advanced,
						order = 5,
						args = {
							bossCombatColors = {
								type = "group",
								name = L.colors,
								inline = true,
								order = 1,
								args = {
									bossCombatColor = {
										type = "color",
										name = L.fontColor,
										width = 1,
										get = GetColor,
										set = SetColorRestrictedAlpha,
										hasAlpha = true,
										order = 1,
										disabled = BossCombatDisabled,
									},
									bossCombatBackgroundColor = {
										type = "color",
										name = L.backgroundColor,
										width = 1,
										get = GetColor,
										set = SetColor,
										hasAlpha = true,
										order = 2,
										disabled = BossCombatDisabled,
									},
									bossCombatBorderColor = {
										type = "color",
										name = L.borderColor,
										order = 3,
										hasAlpha = true,
										width = 1,
										get = GetColor,
										set = SetColor,
										disabled = function() return BossCombatDisabled() or db.profile.bossCombatBorderName == "None" end,
									},
									bossCombatColorInactive = {
										type = "color",
										name = L.parentheses:format(L.fontColor, L.inactive),
										width = 1,
										get = GetColor,
										set = SetColorRestrictedAlpha,
										hasAlpha = true,
										order = 4,
										disabled = BossCombatDisabledOrNoSeparateInactiveColors,
									},
									bossCombatBackgroundColorInactive = {
										type = "color",
										name = L.parentheses:format(L.backgroundColor, L.inactive),
										width = 1,
										get = GetColor,
										set = SetColor,
										hasAlpha = true,
										order = 5,
										disabled = BossCombatDisabledOrNoSeparateInactiveColors,
									},
									bossCombatBorderColorInactive = {
										type = "color",
										name = L.parentheses:format(L.borderColor, L.inactive),
										order = 6,
										hasAlpha = true,
										width = 1,
										get = GetColor,
										set = SetColor,
										disabled = function() return BossCombatDisabledOrNoSeparateInactiveColors() or db.profile.bossCombatBorderName == "None" end,
									},
								},
							},
							bossCombatInactive = {
								type = "select",
								name = L.whenInactive,
								values = {
									NONE = L.doNothing,
									HIDE = L.hide,
									COLOR = L.colorFade,
								},
								sorting = {
									"NONE",
									"HIDE",
									"COLOR",
								},
								style = "radio",
								order = 2,
								set = function(info, value)
									local key = info[#info]
									db.profile[key] = value
									if value ~= "COLOR" then
										ProfileUtils.ResetBossCombatInactiveColors()
									end
									UpdateBossCombatWidget()
								end,
								disabled = BossCombatDisabled,
							},
							bossCombatTextFormat = {
								type = "select",
								name = L.textFormat,
								values = {
									"1:23",
									"1:23.4",
								},
								order = 3,
							},
						},
					},
					bossCombatExactPositioning = {
						type = "group",
						name = L.positionExact,
						order = 6,
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
									return db.profile.bossCombatPosition[3]
								end,
								set = function(_, value)
									db.profile.bossCombatPosition[3] = value
									UpdateBossCombatWidget()
								end,
								disabled = BossCombatDisabled,
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
									return db.profile.bossCombatPosition[4]
								end,
								set = function(_, value)
									db.profile.bossCombatPosition[4] = value
									UpdateBossCombatWidget()
								end,
								disabled = BossCombatDisabled,
							},
							customAnchorPoint = {
								type = "input",
								get = function()
									return db.profile.bossCombatPosition[5]
								end,
								set = function(_, value)
									if value ~= "UIParent" then
										db.profile.bossCombatPosition[1] = "CENTER"
										db.profile.bossCombatPosition[2] = "CENTER"
										db.profile.bossCombatPosition[3] = 0
										db.profile.bossCombatPosition[4] = 0
										db.profile.bossCombatPosition[5] = value
									else
										ProfileUtils.ResetBossCombatPosition()
									end
									UpdateBossCombatWidget()
								end,
								validate = function(_, value)
									local frame = _G[value]
									if type(frame) ~= "table" or type(frame.GetObjectType) ~= "function" or type(frame.IsForbidden) ~= "function" or frame:IsForbidden() then
										return false
									end
									return true
								end,
								name = L.customAnchorPoint,
								order = 3,
								width = 3,
								disabled = BossCombatDisabled,
							},
							customAnchorPointSource = {
								type = "select",
								get = function()
									return db.profile.bossCombatPosition[1]
								end,
								set = function(_, value)
									if BigWigsAPI.IsValidFramePoint(value) then
										db.profile.bossCombatPosition[1] = value
										UpdateBossCombatWidget()
									end
								end,
								values = BigWigsAPI.GetFramePointList(),
								name = L.sourcePoint,
								order = 4,
								width = 1.5,
								disabled = BossCombatDisabledOrAnchorPointDefault,
							},
							customAnchorPointDestination = {
								type = "select",
								get = function()
									return db.profile.bossCombatPosition[2]
								end,
								set = function(_, value)
									if BigWigsAPI.IsValidFramePoint(value) then
										db.profile.bossCombatPosition[2] = value
										UpdateBossCombatWidget()
									end
								end,
								values = BigWigsAPI.GetFramePointList(),
								name = L.destinationPoint,
								order = 5,
								width = 1.5,
								disabled = BossCombatDisabledOrAnchorPointDefault,
							},
							bossCombatPositionResetHeader = {
								type = "header",
								name = "",
								order = 6,
							},
							bossCombatPositionReset = {
								type = "execute",
								name = L.reset,
								desc = L.resetDesc,
								func = function()
									ProfileUtils.ResetBossCombatPosition()
									UpdateBossCombatWidget()
								end,
								order = 7,
								disabled = BossCombatDisabled,
							},
						},
					},
				},
			},
			instance = {
				name = L.instanceTimer,
				type = "group",
				childGroups = "tab",
				set = function(info, value)
					local key = info[#info]
					db.profile[key] = value
					UpdateInstanceTimerWidget()
				end,
				order = 1,
				args = {
					explainInstanceTimer = {
						type = "description",
						name = L.instanceTimerDesc,
						order = 0,
						width = "full",
					},
					instanceTimerDisabled = {
						type = "toggle",
						name = L.disabled,
						width = 1.1,
						order = 1,
						set = function(info, value)
							local key = info[#info]
							db.profile[key] = value
							if value then
								ProfileUtils.ResetInstanceTimer()
							end
							UpdateInstanceTimerWidget()
						end,
					},
					instanceTimerLocked = {
						type = "toggle",
						name = L.lock,
						desc = L.lockDesc,
						width = 1.1,
						order = 2,
						disabled = InstanceTimerDisabled,
					},
					instanceTimerReset = {
						type = "execute",
						name = L.reset,
						desc = L.resetDesc,
						width = 1,
						func = function()
							ProfileUtils.ResetInstanceTimer()
							UpdateInstanceTimerWidget()
						end,
						order = 3,
						disabled = InstanceTimerDisabled,
					},
					instanceTimerGeneral = {
						type = "group",
						name = L.general,
						order = 4,
						args = {
							instanceTimerWidth = {
								type = "range",
								name = L.width,
								desc = L.sizeDesc,
								min = ProfileUtils.MinimumWidth,
								max = ProfileUtils.MaximumWidth,
								step = 1,
								order = 1,
								width = 1.5,
								disabled = InstanceTimerDisabled,
							},
							instanceTimerHeight = {
								type = "range",
								name = L.height,
								desc = L.sizeDesc,
								min = ProfileUtils.MinimumHeight,
								max = ProfileUtils.MaximumHeight,
								step = 1,
								order = 2,
								width = 1.5,
								disabled = InstanceTimerDisabled,
							},
							instanceTimerFontName = {
								type = "select",
								name = L.font,
								order = 3,
								values = LibSharedMedia:List("font"),
								itemControl = "DDI-Font",
								get = function()
									for i, v in next, LibSharedMedia:List("font") do
										if v == db.profile.instanceTimerFontName then return i end
									end
								end,
								set = function(_, value)
									local list = LibSharedMedia:List("font")
									db.profile.instanceTimerFontName = list[value]
									UpdateInstanceTimerWidget()
								end,
								width = 2,
								disabled = InstanceTimerDisabled,
							},
							instanceTimerOutline = {
								type = "select",
								name = L.outline,
								order = 4,
								values = {
									NONE = L.none,
									OUTLINE = L.thin,
									THICKOUTLINE = L.thick,
								},
								sorting = {
									"NONE",
									"OUTLINE",
									"THICKOUTLINE",
								},
								disabled = InstanceTimerDisabled,
							},
							instanceTimerFontSize = {
								type = "range",
								name = L.fontSize,
								desc = L.fontSizeDesc,
								order = 5,
								width = 2,
								softMax = 100, max = 200, min = 14, step = 1,
								disabled = InstanceTimerDisabled,
							},
							instanceTimerMonochrome = {
								type = "toggle",
								name = L.monochrome,
								desc = L.monochromeDesc,
								order = 6,
								disabled = InstanceTimerDisabled,
							},
							instanceTimerAlign = {
								type = "select",
								name = L.align,
								values = {
									LEFT = L.LEFT,
									CENTER = L.CENTER,
									RIGHT = L.RIGHT,
								},
								sorting = {
									"LEFT",
									"CENTER",
									"RIGHT",
								},
								style = "radio",
								order = 7,
								disabled = InstanceTimerDisabled,
							},
							instanceTimerBorderName = {
								type = "select",
								name = L.borderName,
								order = 8,
								values = LibSharedMedia:List("border"),
								get = function()
									for i, v in next, LibSharedMedia:List("border") do
										if v == db.profile.instanceTimerBorderName then return i end
									end
								end,
								set = function(_, value)
									local list = LibSharedMedia:List("border")
									db.profile.instanceTimerBorderName = list[value]
									if db.profile.instanceTimerBorderName == "None" then
										ProfileUtils.ResetInstanceTimerBorder()
									end
									UpdateInstanceTimerWidget()
								end,
								width = 1,
								disabled = InstanceTimerDisabled,
							},
							instanceTimerBorderSize = {
								type = "range",
								name = L.borderSize,
								order = 9,
								min = 1,
								max = 32,
								step = 1,
								width = 1,
								disabled = InstanceTimerDisabledOrBorderSetToNone,
							},
							instanceTimerBorderOffset = {
								type = "range",
								name = L.borderOffset,
								order = 10,
								min = 0,
								max = 32,
								step = 1,
								width = 1,
								disabled = InstanceTimerDisabledOrBorderSetToNone,
							},
						},
					},
					instanceTimerAdvanced = {
						type = "group",
						name = L.advanced,
						order = 5,
						args = {
							instanceTimerColors = {
								type = "group",
								name = L.colors,
								inline = true,
								order = 1,
								args = {
									instanceTimerColor = {
										type = "color",
										name = L.fontColor,
										width = 1,
										get = GetColor,
										set = SetColorRestrictedAlpha,
										hasAlpha = true,
										order = 1,
										disabled = InstanceTimerDisabled,
									},
									instanceTimerBackgroundColor = {
										type = "color",
										name = L.backgroundColor,
										width = 1,
										get = GetColor,
										set = SetColor,
										hasAlpha = true,
										order = 2,
										disabled = InstanceTimerDisabled,
									},
									instanceTimerBorderColor = {
										type = "color",
										name = L.borderColor,
										order = 3,
										hasAlpha = true,
										width = 1,
										get = GetColor,
										set = SetColor,
										disabled = function() return InstanceTimerDisabled() or db.profile.instanceTimerBorderName == "None" end,
									},
									instanceTimerColorInactive = {
										type = "color",
										name = L.parentheses:format(L.fontColor, L.inactive),
										width = 1,
										get = GetColor,
										set = SetColorRestrictedAlpha,
										hasAlpha = true,
										order = 4,
										disabled = InstanceTimerDisabledOrNoSeparateInactiveColors,
									},
									instanceTimerBackgroundColorInactive = {
										type = "color",
										name = L.parentheses:format(L.backgroundColor, L.inactive),
										width = 1,
										get = GetColor,
										set = SetColor,
										hasAlpha = true,
										order = 5,
										disabled = InstanceTimerDisabledOrNoSeparateInactiveColors,
									},
									instanceTimerBorderColorInactive = {
										type = "color",
										name = L.parentheses:format(L.borderColor, L.inactive),
										order = 6,
										hasAlpha = true,
										width = 1,
										get = GetColor,
										set = SetColor,
										disabled = function() return InstanceTimerDisabledOrNoSeparateInactiveColors() or db.profile.instanceTimerBorderName == "None" end,
									},
								},
							},
							instanceTimerInactive = {
								type = "select",
								name = L.whenInactive,
								values = {
									NONE = L.doNothing,
									HIDE = L.hide,
									COLOR = L.colorFade,
								},
								sorting = {
									"NONE",
									"HIDE",
									"COLOR",
								},
								style = "radio",
								order = 2,
								set = function(info, value)
									local key = info[#info]
									db.profile[key] = value
									if value ~= "COLOR" then
										ProfileUtils.ResetInstanceTimerInactiveColors()
									end
									UpdateInstanceTimerWidget()
								end,
								disabled = InstanceTimerDisabled,
							},
							instanceTimerTextFormat = {
								type = "select",
								name = L.textFormat,
								values = {
									"1:23",
									"1:23.4",
								},
								order = 3,
							},
						},
					},
					instanceTimerExactPositioning = {
						type = "group",
						name = L.positionExact,
						order = 6,
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
									return db.profile.instanceTimerPosition[3]
								end,
								set = function(_, value)
									db.profile.instanceTimerPosition[3] = value
									UpdateInstanceTimerWidget()
								end,
								disabled = InstanceTimerDisabled,
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
									return db.profile.instanceTimerPosition[4]
								end,
								set = function(_, value)
									db.profile.instanceTimerPosition[4] = value
									UpdateInstanceTimerWidget()
								end,
								disabled = InstanceTimerDisabled,
							},
							customAnchorPoint = {
								type = "input",
								get = function()
									return db.profile.instanceTimerPosition[5]
								end,
								set = function(_, value)
									if value ~= "UIParent" then
										db.profile.instanceTimerPosition[1] = "CENTER"
										db.profile.instanceTimerPosition[2] = "CENTER"
										db.profile.instanceTimerPosition[3] = 0
										db.profile.instanceTimerPosition[4] = 0
										db.profile.instanceTimerPosition[5] = value
									else
										ProfileUtils.ResetInstanceTimerPosition()
									end
									UpdateInstanceTimerWidget()
								end,
								validate = function(_, value)
									local frame = _G[value]
									if type(frame) ~= "table" or type(frame.GetObjectType) ~= "function" or type(frame.IsForbidden) ~= "function" or frame:IsForbidden() then
										return false
									end
									return true
								end,
								name = L.customAnchorPoint,
								order = 3,
								width = 3,
								disabled = InstanceTimerDisabled,
							},
							customAnchorPointSource = {
								type = "select",
								get = function()
									return db.profile.instanceTimerPosition[1]
								end,
								set = function(_, value)
									if BigWigsAPI.IsValidFramePoint(value) then
										db.profile.instanceTimerPosition[1] = value
										UpdateInstanceTimerWidget()
									end
								end,
								values = BigWigsAPI.GetFramePointList(),
								name = L.sourcePoint,
								order = 4,
								width = 1.5,
								disabled = InstanceTimerDisabledOrAnchorPointDefault,
							},
							customAnchorPointDestination = {
								type = "select",
								get = function()
									return db.profile.instanceTimerPosition[2]
								end,
								set = function(_, value)
									if BigWigsAPI.IsValidFramePoint(value) then
										db.profile.instanceTimerPosition[2] = value
										UpdateInstanceTimerWidget()
									end
								end,
								values = BigWigsAPI.GetFramePointList(),
								name = L.destinationPoint,
								order = 5,
								width = 1.5,
								disabled = InstanceTimerDisabledOrAnchorPointDefault,
							},
							instanceTimerPositionResetHeader = {
								type = "header",
								name = "",
								order = 6,
							},
							instanceTimerPositionReset = {
								type = "execute",
								name = L.reset,
								desc = L.resetDesc,
								func = function()
									ProfileUtils.ResetInstanceTimerPosition()
									UpdateInstanceTimerWidget()
								end,
								order = 7,
								disabled = InstanceTimerDisabled,
							},
						},
					},
				},
			},
		},
	})
end

--------------------------------------------------------------------------------
-- Login
--

do
	local function UpdateProfile()
		ProfileUtils.ValidateMainSettings()
		ProfileUtils.ValidateMediaSettings()
		if not db.profile.anyCombatDisabled and not db.profile.anyCombatLocked then
			db.profile.anyCombatLocked = true
		end
		if not db.profile.bossCombatDisabled and not db.profile.bossCombatLocked then
			db.profile.bossCombatLocked = true
		end
		if not db.profile.instanceTimerDisabled and not db.profile.instanceTimerLocked then
			db.profile.instanceTimerLocked = true
		end
		UpdateAnyCombatWidget()
		UpdateBossCombatWidget()
		UpdateInstanceTimerWidget()
		if not db.profile.instanceTimerDisabled then
			BigWigsLoader.CTimerAfter(0, widgets.instanceTimerEnterWorldFunc) -- Difficulty info isn't accurate until 1 frame after PEW
		end
	end
	local loginFrame = CreateFrame("Frame")
	loginFrame:SetScript("OnEvent", function(self, event)
		self:UnregisterEvent(event)
		self:SetScript("OnEvent", nil)
		UpdateProfile()
		BigWigsLoader.RegisterMessage({}, "BigWigs_ProfileUpdate", UpdateProfile)
	end)
	loginFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
end
