-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin, L = BigWigs:NewPlugin("Auras") -- Retail & Forever only module
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

local LibSharedMedia = LibStub("LibSharedMedia-3.0")
plugin.displayName = L.auras

local db
local containers = {}
local anchors = {}
local activatedModules = {}
local inConfigureMode = false
local previouslyFoundUnit = nil

local updateProfile
local UpdateAllAnchors, UpdateAnchor
local UpdateAuraContainer
local CreateTestAura, UpdateTestAuras, ReleaseTestAuras
local ShowHelpTip, HideHelpTip

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

local function MergeTables(t, ...)
	for i = 1, select("#", ...) do
		local src = select(i, ...)
		for k, v in pairs(src) do
			if type(v) == "table" then
				t[k] = CopyTable(v)
			else
				t[k] = v
			end
		end
	end
	return t
end

--------------------------------------------------------------------------------
-- Profile
--

do
	local sharedDefaults = {
		onlyActiveDuringBosses = false,
		width = 64,
		height = 64,
		zoom = 0.14,
		spacing = 6,
		showCooldown = true,
		showTooltip = true,
		keepAspectRatio = true,

		showDispelType = true,
		dispelTypeSize = 24,
		dispelTypeAnchorPoint = "TOPRIGHT",
		dispelTypeAnchorXOffset = 8,
		dispelTypeAnchorYOffset = 8,

		borderName = "Solid",
		borderColor = {0, 0, 0, 1},
		borderOffset = 0,
		borderSize = 2,
		borderDispelColor = true,

		showCooldownText = true,
		cooldownTextFontName = "Noto Sans Medium", -- Only dealing with numbers so we can use this on all locales
		cooldownTextFontSize = 16,
		cooldownTextOutline = "OUTLINE",
		cooldownTextMonochrome = false,
		cooldownTextSlug = true,
		cooldownTextAnchorPoint = "CENTER",
		cooldownTextAnchorXOffset = 0,
		cooldownTextAnchorYOffset = 0,
		cooldownTextColor = {1, 1, 1, 1},
		cooldownTextDecimals = 3,
		cooldownEmphasizeTime = 0,
		cooldownEmphasizeColor = {1, 1, 1, 1},
		cooldownEmphasizeFontSize = 16,

		showCountText = true,
		countTextFontName = "Noto Sans Medium",
		countTextFontSize = 20,
		countTextOutline = "OUTLINE",
		countTextMonochrome = false,
		countTextSlug = true,
		countTextAnchorPoint = "BOTTOMRIGHT",
		countTextAnchorXOffset = -2,
		countTextAnchorYOffset = 2,
		countTextColor = {1, 1, 1, 1},

		growthDirection = "LEFT",
		maxIcons = 3,

		anchorPoint = "CENTER",
		anchorRelPoint = "CENTER",
		anchorXOffset = -300,
		anchorYOffset = 200,
		anchorRelativeTo = "UIParent",
	}

	plugin.defaultDB = {
		player = MergeTables(CopyTable(sharedDefaults), {
			disabled = false,
		}),
		other = MergeTables(CopyTable(sharedDefaults), {
			disabled = true,
			anchorYOffset = 120,

			showTankIndicator = true,
			tankIndicatorSize = 24,
			tankIndicatorAnchorPoint = "TOP",
			tankIndicatorAnchorXOffset = 0,
			tankIndicatorAnchorYOffset = 10,
		}),
		otherPlayerType = "tank",
		onlyWhenYouAreTank = false,
		otherPlayerName = "",
		sounds = {}, -- XXX remove me 12.1.5
	}
end

plugin.defaultGlobalDB = {
	showHelpTip = true,
}

do
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

	local function ValidateAnchor(unitType, pointDB, relativeToDB, relPointDB, xOffsetDB, yOffsetDB, minOffset, maxOffset)
		if not BigWigsAPI.IsValidFramePoint(db[unitType][pointDB]) or (relPointDB and not BigWigsAPI.IsValidFramePoint(db[unitType][relPointDB])) then
			db[unitType][pointDB] = plugin.defaultDB[unitType][pointDB]
			if relPointDB then
				db[unitType][relPointDB] = plugin.defaultDB[unitType][relPointDB]
			end
			db[unitType][xOffsetDB] = plugin.defaultDB[unitType][xOffsetDB]
			db[unitType][yOffsetDB] = plugin.defaultDB[unitType][yOffsetDB]
			if relativeToDB then
				db[unitType][relativeToDB] = plugin.defaultDB[unitType][relativeToDB]
			end
		end

		if db[unitType][xOffsetDB] < minOffset or db[unitType][xOffsetDB] > maxOffset or math.floor(db[unitType][xOffsetDB]+0.5) ~= db[unitType][xOffsetDB] then
			db[unitType][xOffsetDB] = plugin.defaultDB[unitType][xOffsetDB]
		end
		if db[unitType][yOffsetDB] < minOffset or db[unitType][yOffsetDB] > maxOffset or math.floor(db[unitType][yOffsetDB]+0.5) ~= db[unitType][yOffsetDB] then
			db[unitType][yOffsetDB] = plugin.defaultDB[unitType][yOffsetDB]
		end

		if relativeToDB and db[unitType][relativeToDB] ~= plugin.defaultDB[unitType][relativeToDB] and not BigWigsAPI.IsValidFrame(db[unitType][relativeToDB]) then
			db[unitType][pointDB] = plugin.defaultDB[unitType][pointDB]
			if relPointDB then
				db[unitType][relPointDB] = plugin.defaultDB[unitType][relPointDB]
			end
			db[unitType][xOffsetDB] = plugin.defaultDB[unitType][xOffsetDB]
			db[unitType][yOffsetDB] = plugin.defaultDB[unitType][yOffsetDB]
			db[unitType][relativeToDB] = plugin.defaultDB[unitType][relativeToDB]
		end
	end

	local profileUnits = {"player", "other"}
	local validGrowthDirections = {
		LEFT = true,
		RIGHT = true,
		UP = true,
		DOWN = true,
		CENTER_HORIZONTAL = true,
		CENTER_VERTICAL = true,
	}

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
			elseif type(v) == "table" and k ~= "sounds" then -- XXX remove sounds check, 12.1.5
				for subKey, subValue in next, db[k] do
					defaultType = type(plugin.defaultDB[k][subKey])
					if defaultType == "nil" then
						db[k][subKey] = nil
					elseif type(subValue) ~= defaultType then
						if defaultType == "table" then
							db[k][subKey] = CopyTable(plugin.defaultDB[k][subKey])
						else
							db[k][subKey] = plugin.defaultDB[k][subKey]
						end
					end
				end
			end
		end

		-- XXX temp 12.1.5
		if type(db.sounds) == "table" and next(db.sounds) then
			local auraSoundDB = BigWigsLoader.db:GetNamespace("AuraSounds", true)
			if auraSoundDB then
				auraSoundDB.profile.sounds = CopyTable(db.sounds)
				db.sounds = {}
				plugin:SimpleTimer(function() BigWigs:SendMessage("BigWigs_ProfileUpdate") end, 0)
			else
				BigWigs:Error("Couldn't locate the AuraSounds namespace.")
			end
		end

		local globalDB = plugin.db.global
		for k, v in next, globalDB do
			local defaultType = type(plugin.defaultGlobalDB[k])
			if defaultType == "nil" then
				globalDB[k] = nil
			elseif type(v) ~= defaultType then
				if defaultType == "table" then
					globalDB[k] = CopyTable(plugin.defaultGlobalDB[k])
				else
					globalDB[k] = plugin.defaultGlobalDB[k]
				end
			end
		end

		for _, unitType in next, profileUnits do
			if not validGrowthDirections[db[unitType].growthDirection] then
				db[unitType].growthDirection = plugin.defaultDB[unitType].growthDirection
			end
			if db[unitType].width < 24 or db[unitType].width > 256 or math.floor(db[unitType].width+0.5) ~= db[unitType].width then
				db[unitType].width = plugin.defaultDB[unitType].width
			end
			if db[unitType].height < 24 or db[unitType].height > 256 or math.floor(db[unitType].height+0.5) ~= db[unitType].height then
				db[unitType].height = plugin.defaultDB[unitType].height
			end
			if db[unitType].zoom < 0 or db[unitType].zoom > 0.5 then
				db[unitType].zoom = plugin.defaultDB[unitType].zoom
			end
			if db[unitType].spacing < 0 or db[unitType].spacing > 50 or math.floor(db[unitType].spacing+0.5) ~= db[unitType].spacing then
				db[unitType].spacing = plugin.defaultDB[unitType].spacing
			end
			if not LibSharedMedia:IsValid("font", db[unitType].cooldownTextFontName) or not BigWigsAPI.IsValidMediaPath(LibSharedMedia:Fetch("font", db[unitType].cooldownTextFontName)) then
				db[unitType].cooldownTextFontName = plugin.defaultDB[unitType].cooldownTextFontName
			end
			if db[unitType].cooldownTextFontSize < 8 or db[unitType].cooldownTextFontSize > 200 or math.floor(db[unitType].cooldownTextFontSize+0.5) ~= db[unitType].cooldownTextFontSize then
				db[unitType].cooldownTextFontSize = plugin.defaultDB[unitType].cooldownTextFontSize
			end
			if db[unitType].cooldownTextOutline ~= "NONE" and db[unitType].cooldownTextOutline ~= "OUTLINE" and db[unitType].cooldownTextOutline ~= "THICKOUTLINE" then
				db[unitType].cooldownTextOutline = plugin.defaultDB[unitType].cooldownTextOutline
			end
			ValidateColor(db[unitType].cooldownTextColor, plugin.defaultDB[unitType].cooldownTextColor, 0)
			if db[unitType].cooldownEmphasizeTime < 0 or db[unitType].cooldownEmphasizeTime > 30 or math.floor(db[unitType].cooldownEmphasizeTime+0.5) ~= db[unitType].cooldownEmphasizeTime then
				db[unitType].cooldownEmphasizeTime = plugin.defaultDB[unitType].cooldownEmphasizeTime
			end
			if db[unitType].cooldownEmphasizeFontSize < 10 or db[unitType].cooldownEmphasizeFontSize > 200 or math.floor(db[unitType].cooldownEmphasizeFontSize+0.5) ~= db[unitType].cooldownEmphasizeFontSize then
				db[unitType].cooldownEmphasizeFontSize = plugin.defaultDB[unitType].cooldownEmphasizeFontSize
			end
			if db[unitType].cooldownTextDecimals < 0 or db[unitType].cooldownTextDecimals > 60 or math.floor(db[unitType].cooldownTextDecimals+0.5) ~= db[unitType].cooldownTextDecimals then
				db[unitType].cooldownTextDecimals = plugin.defaultDB[unitType].cooldownTextDecimals
			end
			ValidateColor(db[unitType].cooldownEmphasizeColor, plugin.defaultDB[unitType].cooldownEmphasizeColor, 0)
			if not LibSharedMedia:IsValid("font", db[unitType].countTextFontName) or not BigWigsAPI.IsValidMediaPath(LibSharedMedia:Fetch("font", db[unitType].countTextFontName)) then
				db[unitType].countTextFontName = plugin.defaultDB[unitType].countTextFontName
			end
			if db[unitType].countTextFontSize < 8 or db[unitType].countTextFontSize > 200 or math.floor(db[unitType].countTextFontSize+0.5) ~= db[unitType].countTextFontSize then
				db[unitType].countTextFontSize = plugin.defaultDB[unitType].countTextFontSize
			end
			if db[unitType].countTextOutline ~= "NONE" and db[unitType].countTextOutline ~= "OUTLINE" and db[unitType].countTextOutline ~= "THICKOUTLINE" then
				db[unitType].countTextOutline = plugin.defaultDB[unitType].countTextOutline
			end
			ValidateColor(db[unitType].countTextColor, plugin.defaultDB[unitType].countTextColor, 0)
			ValidateColor(db[unitType].borderColor, plugin.defaultDB[unitType].borderColor, 0)
			if not LibSharedMedia:IsValid("border", db[unitType].borderName) or (db[unitType].borderName ~= "None" and not BigWigsAPI.IsValidMediaPath(LibSharedMedia:Fetch("border", db[unitType].borderName))) then
				db[unitType].borderName = plugin.defaultDB[unitType].borderName
				db[unitType].borderSize = plugin.defaultDB[unitType].borderSize
				db[unitType].borderOffset = plugin.defaultDB[unitType].borderOffset
			end
			if db[unitType].borderSize < 1 or db[unitType].borderSize > 32 or math.floor(db[unitType].borderSize+0.5) ~= db[unitType].borderSize then
				db[unitType].borderSize = plugin.defaultDB[unitType].borderSize
			end
			if db[unitType].borderOffset < 0 or db[unitType].borderOffset > 32 or math.floor(db[unitType].borderOffset+0.5) ~= db[unitType].borderOffset then
				db[unitType].borderOffset = plugin.defaultDB[unitType].borderOffset
			end
			if db[unitType].dispelTypeSize < 1 or db[unitType].dispelTypeSize > 64 or math.floor(db[unitType].dispelTypeSize+0.5) ~= db[unitType].dispelTypeSize then
				db[unitType].dispelTypeSize = plugin.defaultDB[unitType].dispelTypeSize
			end

			ValidateAnchor(unitType, "anchorPoint", "anchorRelativeTo", "anchorRelPoint", "anchorXOffset", "anchorYOffset", -2048, 2048)
			ValidateAnchor(unitType, "countTextAnchorPoint", nil, nil, "countTextAnchorXOffset", "countTextAnchorYOffset", -100, 100)
			ValidateAnchor(unitType, "cooldownTextAnchorPoint", nil, nil, "cooldownTextAnchorXOffset", "cooldownTextAnchorYOffset", -100, 100)
			ValidateAnchor(unitType, "dispelTypeAnchorPoint", nil, nil, "dispelTypeAnchorXOffset", "dispelTypeAnchorYOffset", -100, 100)

			if db[unitType].maxIcons < 1 or db[unitType].maxIcons > 5 or math.floor(db[unitType].maxIcons+0.5) ~= db[unitType].maxIcons then
				db[unitType].maxIcons = plugin.defaultDB[unitType].maxIcons
			end
		end

		if db.other.tankIndicatorSize < 1 or db.other.tankIndicatorSize > 64 or math.floor(db.other.tankIndicatorSize+0.5) ~= db.other.tankIndicatorSize then
			db.other.tankIndicatorSize = plugin.defaultDB.other.tankIndicatorSize
		end
		ValidateAnchor("other", "tankIndicatorAnchorPoint", nil, nil, "tankIndicatorAnchorXOffset", "tankIndicatorAnchorYOffset", -100, 100)

		if db.otherPlayerType ~= "tank" and db.otherPlayerType ~= "player" then
			db.otherPlayerType = plugin.defaultDB.otherPlayerType
		end

		UpdateAllAnchors()
		if inConfigureMode then -- Update visible anchors
			plugin:BigWigs_StartConfigureMode(nil, plugin.moduleName)
		end
	end
end

--------------------------------------------------------------------------------
-- Options
--

do
	local function IsAnchorDisabled(info)
		local unitType = info[3]
		return db[unitType].disabled
	end
	local roleIcons = {
		["TANK"] = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Role_Tank:0|t",
		["HEALER"] = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Role_Healer:0|t",
		["DAMAGER"] = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Role_Damage:0|t",
		["NONE"] = "",
	}
	local function FindTank()
		for unit in plugin:IterateGroup(true) do
			if not UnitIsUnit("player", unit) and UnitGroupRolesAssigned(unit) == "TANK" then
				local name = plugin:UnitName(unit)
				if name then
					local colorTbl = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
					local _, class = UnitClass(unit)
					local tbl = class and colorTbl[class] or GRAY_FONT_COLOR
					return ("%s|cFF%02x%02x%02x%s|r"):format(roleIcons.TANK, tbl.r*255, tbl.g*255, tbl.b*255, name)
				end
			end
		end
	end
	local function IsFeatureEntirelyDisabled()
		if db.player.disabled and db.other.disabled then
			return true
		end
	end

	local sharedUnitOptions = {
		icon = {
			type = "group",
			name = L.icon,
			order = 2,
			disabled = IsAnchorDisabled,
			args = {
				maxIcons = {
					type = "range",
					name = L.maxIcons,
					order = 1,
					width = 1.5,
					desc = L.maxIconsDesc,
					min = 1,
					max = 5,
					step = 1,
				},
				growthDirection = {
					type = "select",
					name = L.growthDirection,
					order = 2,
					width = 1.5,
					values = {
						LEFT = L.LEFT,
						RIGHT = L.RIGHT,
						UP = L.UP,
						DOWN = L.DOWN,
						CENTER_HORIZONTAL = L.CENTER_HORIZONTAL,
						CENTER_VERTICAL = L.CENTER_VERTICAL,
					},
				},
				width = {
					type = "range",
					name = L.width,
					order = 3,
					width = 1.5,
					min = 24,
					max = 256,
					step = 1,
				},
				height = {
					type = "range",
					name = L.height,
					order = 4,
					width = 1.5,
					min = 24,
					max = 256,
					step = 1,
				},
				zoom = {
					type = "range",
					name = L.zoom,
					desc = L.zoomDesc,
					order = 5,
					width = 1.5,
					min = 0,
					max = 0.5,
					step = 0.01,
					isPercent = true,
				},
				spacing = {
					type = "range",
					name = L.iconSpacing,
					order = 6,
					width = 1.5,
					min = 0,
					max = 50,
					step = 1,
				},
				spacer1 = {
					type = "description",
					name = "",
					order = 7,
					width = 1.5,
				},
				keepAspectRatio = {
					type = "toggle",
					name = L.keepAspectRatio,
					desc = L.keepAspectRatioDesc,
					order = 8,
				},
				spacer2 = {
					type = "description",
					name = "",
					order = 9,
					width = 1.5,
				},
				showTooltip = {
					type = "toggle",
					name = L.iconTooltip,
					desc = L.iconTooltipDesc,
					order = 10,
				},
				spacer3 = {
					type = "description",
					name = "",
					order = 11,
					width = 1.5,
				},
				showCooldown = {
					type = "toggle",
					name = L.showCooldown,
					desc = L.showCooldownSwipeDesc,
					order = 12,
				},
				resetHeader = {
					type = "header",
					name = "",
					order = 100,
				},
				reset = {
					type = "execute",
					name = L.reset,
					desc = L.resetDesc,
					order = 101,
					func = function(info)
						local unitType = info[#info - 2]
						local optionDB = db[unitType]
						local defaultDB = plugin.defaultDB[unitType]
						optionDB.maxIcons = defaultDB.maxIcons
						optionDB.growthDirection = defaultDB.growthDirection
						optionDB.width = defaultDB.width
						optionDB.height = defaultDB.height
						optionDB.zoom = defaultDB.zoom
						optionDB.spacing = defaultDB.spacing
						optionDB.keepAspectRatio = defaultDB.keepAspectRatio
						optionDB.showTooltip = defaultDB.showTooltip
						optionDB.showCooldown = defaultDB.showCooldown
						updateProfile()
					end,
				},
			},
		},
		border = {
			type = "group",
			name = L.border,
			order = 3,
			disabled = IsAnchorDisabled,
			args = {
				borderName = {
					type = "select",
					name = L.borderName,
					order = 1,
					values = LibSharedMedia:List("border"),
					get = function(info)
						local unitType = info[#info - 2]
						for i, v in next, LibSharedMedia:List("border") do
							if v == db[unitType].borderName then return i end
						end
					end,
					set = function(info, value)
						local unitType = info[#info - 2]
						local list = LibSharedMedia:List("border")
						db[unitType].borderName = list[value]
						updateProfile()
					end,
					width = 1,
				},
				borderSize = {
					type = "range",
					name = L.borderSize,
					order = 2,
					min = 1,
					max = 32,
					step = 1,
					disabled = function(info)
						local unitType = info[#info - 2]
						return db[unitType].borderName == "None"
					end,
				},
				borderOffset = {
					type = "range",
					name = L.borderOffset,
					order = 3,
					min = 0,
					max = 32,
					step = 1,
					disabled = function(info)
						local unitType = info[#info - 2]
						return db[unitType].borderName == "None"
					end,
				},
				borderDispelColor = {
					type = "toggle",
					name = L.borderDispelColor,
					order = 4,
					width = 1.5,
					disabled = function(info)
						local unitType = info[#info - 2]
						return db[unitType].borderName == "None"
					end,
				},
				borderColor = {
					type = "color",
					name = L.borderColor,
					order = 5,
					get = function(info)
						local unitType = info[#info - 2]
						local colorTable = db[unitType].borderColor
						return colorTable[1], colorTable[2], colorTable[3], colorTable[4]
					end,
					set = function(info, r, g, b, a)
						local unitType = info[#info - 2]
						db[unitType].borderColor = {r, g, b, a}
						updateProfile()
					end,
					hasAlpha = true,
					disabled = function(info)
						local unitType = info[#info - 2]
						return db[unitType].borderName == "None" or db[unitType].borderDispelColor
					end,
				},
				resetHeader = {
					type = "header",
					name = "",
					order = 100,
				},
				reset = {
					type = "execute",
					name = L.reset,
					desc = L.resetDesc,
					order = 101,
					func = function(info)
						local unitType = info[#info - 2]
						local optionDB = db[unitType]
						local defaultDB = plugin.defaultDB[unitType]
						optionDB.borderName = defaultDB.borderName
						optionDB.borderSize = defaultDB.borderSize
						optionDB.borderOffset = defaultDB.borderOffset
						optionDB.borderDispelColor = defaultDB.borderDispelColor
						optionDB.borderColor = CopyTable(defaultDB.borderColor)
						updateProfile()
					end,
				},
			},
		},
		cooldown = {
			type = "group",
			name = L.cooldown,
			order = 4,
			disabled = IsAnchorDisabled,
			args = {
				showCooldownText = {
					type = "toggle",
					name = L.showCooldownText,
					order = 1,
				},
				spacer = {
					type = "description",
					name = "",
					order = 2,
					width = 1.5,
				},
				cooldownTextFontName = {
					type = "select",
					name = L.font,
					order = 3,
					values = LibSharedMedia:List("font"),
					itemControl = "DDI-Font",
					get = function(info)
						local unitType = info[#info - 2]
						for i, v in next, LibSharedMedia:List("font") do
							if v == db[unitType].cooldownTextFontName then
								return i
							end
						end
					end,
					set = function(info, value)
						local unitType = info[#info - 2]
						local list = LibSharedMedia:List("font")
						db[unitType].cooldownTextFontName = list[value]
						updateProfile()
					end,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCooldownText
					end,
				},
				cooldownTextFontSize = {
					type = "range",
					name = L.fontSize,
					desc = L.fontSizeDesc,
					order = 4,
					softMax = 100,
					min = 8,
					max = 200,
					step = 1,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCooldownText
					end,
				},
				cooldownTextOutline = {
					type = "select",
					name = L.outline,
					order = 5,
					values = {
						NONE = L.none,
						OUTLINE = L.thin,
						THICKOUTLINE = L.thick,
					},
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCooldownText
					end,
				},
				cooldownTextMonochrome = {
					type = "toggle",
					name = L.monochrome,
					desc = L.monochromeDesc,
					order = 6,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCooldownText
					end,
				},
				cooldownTextSlug = {
					type = "toggle",
					name = L.slugRendering,
					desc = L.slugRenderingDesc,
					order = 7,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCooldownText
					end,
				},
				cooldownTextAnchorPoint = {
					type = "select",
					name = L.position,
					order = 8,
					values = BigWigsAPI.GetFramePointList(),
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCooldownText
					end,
				},
				cooldownTextAnchorXOffset = {
					type = "range",
					name = L.offsetX,
					order = 9,
					min = -100,
					max = 100,
					step = 1,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCooldownText
					end,
				},
				cooldownTextAnchorYOffset = {
					type = "range",
					name = L.offsetY,
					order = 10,
					min = -100,
					max = 100,
					step = 1,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCooldownText
					end,
				},
				cooldownTextColor = {
					type = "color",
					name = L.fontColor,
					order = 11,
					hasAlpha = true,
					get = function(info)
						local unitType = info[#info - 2]
						local colorTable = db[unitType].cooldownTextColor
						return colorTable[1], colorTable[2], colorTable[3], colorTable[4]
					end,
					set = function(info, r, g, b, a)
						local unitType = info[#info - 2]
						db[unitType].cooldownTextColor = {r, g, b, a}
						updateProfile()
					end,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCooldownText
					end,
				},
				cooldownTextDecimals = {
					type = "range",
					name = L.cooldownDecimalsThreshold,
					desc = L.cooldownDecimalsThresholdDesc,
					order = 12,
					width = 1.5,
					min = 0,
					max = 60,
					step = 1,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCooldownText
					end,
				},
				cooldownEmphasizeHeader = {
					type = "header",
					name = L.emphasize,
					order = 13,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCooldownText
					end,
				},
				cooldownEmphasizeHeading = {
					type = "description",
					name = L.cooldownEmphasizeHeader,
					order = 14,
					width = "full",
					fontSize = "medium",
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCooldownText
					end,
				},
				cooldownEmphasizeTime = {
					type = "range",
					name = L.emphasizeAt,
					order = 15,
					width = "full",
					min = 0,
					max = 30,
					step = 1,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCooldownText
					end,
				},
				cooldownEmphasizeColor = {
					type = "color",
					name = L.fontColor,
					order = 16,
					hasAlpha = true,
					get = function(info)
						local unitType = info[#info - 2]
						local colorTable = db[unitType].cooldownEmphasizeColor
						return colorTable[1], colorTable[2], colorTable[3], colorTable[4]
					end,
					set = function(info, r, g, b, a)
						local unitType = info[#info - 2]
						db[unitType].cooldownEmphasizeColor = {r, g, b, a}
						updateProfile()
					end,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCooldownText or db[unitType].cooldownEmphasizeTime == 0
					end,
				},
				cooldownEmphasizeFontSize = {
					type = "range",
					name = L.fontSize,
					desc = L.fontSizeDesc,
					order = 17,
					min = 10,
					softMax = 100,
					max = 200,
					step = 1,
					disabled = true, -- not currently possible
				},
				resetHeader = {
					type = "header",
					name = "",
					order = 100,
				},
				reset = {
					type = "execute",
					name = L.reset,
					desc = L.resetDesc,
					order = 101,
					func = function(info)
						local unitType = info[#info - 2]
						local optionDB = db[unitType]
						local defaultDB = plugin.defaultDB[unitType]
						optionDB.showCooldownText = defaultDB.showCooldownText
						optionDB.cooldownTextFontName = defaultDB.cooldownTextFontName
						optionDB.cooldownTextFontSize = defaultDB.cooldownTextFontSize
						optionDB.cooldownTextOutline = defaultDB.cooldownTextOutline
						optionDB.cooldownTextMonochrome = defaultDB.cooldownTextMonochrome
						optionDB.cooldownTextSlug = defaultDB.cooldownTextSlug
						optionDB.cooldownTextAnchorPoint = defaultDB.cooldownTextAnchorPoint
						optionDB.cooldownTextAnchorXOffset = defaultDB.cooldownTextAnchorXOffset
						optionDB.cooldownTextAnchorYOffset = defaultDB.cooldownTextAnchorYOffset
						optionDB.cooldownTextColor = CopyTable(defaultDB.cooldownTextColor)
						optionDB.cooldownTextDecimals = defaultDB.cooldownTextDecimals
						optionDB.cooldownEmphasizeTime = defaultDB.cooldownEmphasizeTime
						optionDB.cooldownEmphasizeColor = CopyTable(defaultDB.cooldownEmphasizeColor)
						optionDB.cooldownEmphasizeFontSize = defaultDB.cooldownEmphasizeFontSize
						updateProfile()
					end,
				},
			},
		},
		dispelType = {
			type = "group",
			name = L.dispelType,
			order = 5,
			disabled = IsAnchorDisabled,
			args = {
				showDispelType = {
					type = "toggle",
					name = L.showDispelType,
					desc = L.showDispelTypeDesc,
					order = 1,
					width = 1.2,
				},
				spacer = {
					type = "description",
					name = "",
					order = 2,
					width = 1.5,
				},
				dispelTypeSize = {
					type = "range",
					name = L.iconSize,
					order = 3,
					width = 1.5,
					min = 1,
					max = 64,
					step = 1,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showDispelType
					end,
				},
				dispelTypeAnchorPoint = {
					type = "select",
					name = L.position,
					order = 5,
					width = 1.5,
					values = BigWigsAPI.GetFramePointList(),
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showDispelType
					end,
				},
				dispelTypeAnchorXOffset = {
					type = "range",
					name = L.offsetX,
					order = 6,
					min = -100,
					max = 100,
					step = 1,
					width = 1.5,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showDispelType
					end,
				},
				dispelTypeAnchorYOffset = {
					type = "range",
					name = L.offsetY,
					order = 7,
					min = -100,
					max = 100,
					step = 1,
					width = 1.5,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showDispelType
					end,
				},
				resetHeader = {
					type = "header",
					name = "",
					order = 100,
				},
				reset = {
					type = "execute",
					name = L.reset,
					desc = L.resetDesc,
					order = 101,
					func = function(info)
						local unitType = info[#info - 2]
						local optionDB = db[unitType]
						local defaultDB = plugin.defaultDB[unitType]
						optionDB.showDispelType = defaultDB.showDispelType
						optionDB.dispelTypeSize = defaultDB.dispelTypeSize
						optionDB.dispelTypeAnchorPoint = defaultDB.dispelTypeAnchorPoint
						optionDB.dispelTypeAnchorXOffset = defaultDB.dispelTypeAnchorXOffset
						optionDB.dispelTypeAnchorYOffset = defaultDB.dispelTypeAnchorYOffset
						updateProfile()
					end,
				},
			},
		},
		applications = {
			type = "group",
			name = L.countText,
			order = 7,
			disabled = IsAnchorDisabled,
			args = {
				showCountText = {
					type = "toggle",
					name = L.showCountText,
					order = 1,
				},
				spacer = {
					type = "description",
					name = "",
					order = 2,
					width = 1.5,
				},
				countTextFontName = {
					type = "select",
					name = L.font,
					order = 3,
					values = LibSharedMedia:List("font"),
					itemControl = "DDI-Font",
					get = function(info)
						local unitType = info[#info - 2]
						for i, v in next, LibSharedMedia:List("font") do
							if v == db[unitType].countTextFontName then return i end
						end
					end,
					set = function(info, value)
						local unitType = info[#info - 2]
						local list = LibSharedMedia:List("font")
						db[unitType].countTextFontName = list[value]
						updateProfile()
					end,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCountText
					end,
				},
				countTextFontSize = {
					type = "range",
					name = L.fontSize,
					desc = L.fontSizeDesc,
					order = 4,
					min = 8,
					softMax = 100,
					max = 200,
					step = 1,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCountText
					end,
				},
				countTextOutline = {
					type = "select",
					name = L.outline,
					order = 5,
					values = {
						NONE = L.none,
						OUTLINE = L.thin,
						THICKOUTLINE = L.thick,
					},
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCountText
					end,
				},
				countTextMonochrome = {
					type = "toggle",
					name = L.monochrome,
					desc = L.monochromeDesc,
					order = 6,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCountText
					end,
				},
				countTextSlug = {
					type = "toggle",
					name = L.slugRendering,
					desc = L.slugRenderingDesc,
					order = 7,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCountText
					end,
				},
				countTextAnchorPoint = {
					type = "select",
					name = L.position,
					order = 8,
					values = BigWigsAPI.GetFramePointList(),
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCountText
					end,
				},
				countTextAnchorXOffset = {
					type = "range",
					name = L.offsetX,
					order = 9,
					min = -100,
					max = 100,
					step = 1,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCountText
					end,
				},
				countTextAnchorYOffset = {
					type = "range",
					name = L.offsetY,
					order = 10,
					min = -100,
					max = 100,
					step = 1,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCountText
					end,
				},
				countTextColor = {
					type = "color",
					name = L.fontColor,
					order = 11,
					get = function(info)
						local unitType = info[#info - 2]
						local colorTable = db[unitType].countTextColor
						return colorTable[1], colorTable[2], colorTable[3], colorTable[4]
					end,
					set = function(info, r, g, b, a)
						local unitType = info[#info - 2]
						db[unitType].countTextColor = {r, g, b, a}
						updateProfile()
					end,
					hasAlpha = true,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCountText
					end,
				},
				resetHeader = {
					type = "header",
					name = "",
					order = 100,
				},
				reset = {
					type = "execute",
					name = L.reset,
					desc = L.resetDesc,
					order = 101,
					func = function(info)
						local unitType = info[#info - 2]
						local optionDB = db[unitType]
						local defaultDB = plugin.defaultDB[unitType]
						optionDB.showCountText = defaultDB.showCountText
						optionDB.countTextFontName = defaultDB.countTextFontName
						optionDB.countTextFontSize = defaultDB.countTextFontSize
						optionDB.countTextOutline = defaultDB.countTextOutline
						optionDB.countTextMonochrome = defaultDB.countTextMonochrome
						optionDB.countTextSlug = defaultDB.countTextSlug
						optionDB.countTextAnchorPoint = defaultDB.countTextAnchorPoint
						optionDB.countTextAnchorXOffset = defaultDB.countTextAnchorXOffset
						optionDB.countTextAnchorYOffset = defaultDB.countTextAnchorYOffset
						optionDB.countTextColor = CopyTable(defaultDB.countTextColor)
						updateProfile()
					end,
				},
			},
		},
		position = {
			type = "group",
			name = L.positionExact,
			order = 8,
			set = function(info, value)
				local unitType = info[#info - 2]
				db[unitType][info[#info]] = value
				local anchor = anchors[unitType]
				if anchor then
					anchor:UpdateAnchorPosition()
				end
			end,
			disabled = IsAnchorDisabled,
			args = {
				anchorXOffset = {
					type = "range",
					name = L.positionX,
					desc = L.positionDesc,
					order = 1,
					width = 3,
					min = -2048,
					max = 2048,
					step = 1,
				},
				anchorYOffset = {
					type = "range",
					name = L.positionY,
					desc = L.positionDesc,
					order = 2,
					width = 3,
					min = -2048,
					max = 2048,
					step = 1,
				},
				anchorRelativeTo = {
					type = "input",
					name = L.customAnchorPoint,
					order = 3,
					width = 3,
					set = function(info, value)
						local unitType = info[#info-2]
						local anchorDB = db[unitType]
						local defaultDB = plugin.defaultDB[unitType]
						if value ~= defaultDB.anchorRelativeTo then
							anchorDB.anchorPoint = "CENTER"
							anchorDB.anchorRelPoint = "CENTER"
							anchorDB.anchorXOffset = 0
							anchorDB.anchorYOffset = 0
							anchorDB.anchorRelativeTo = value
						else
							anchorDB.anchorPoint = defaultDB.anchorPoint
							anchorDB.anchorRelPoint = defaultDB.anchorRelPoint
							anchorDB.anchorXOffset = defaultDB.anchorXOffset
							anchorDB.anchorYOffset = defaultDB.anchorYOffset
							anchorDB.anchorRelativeTo = defaultDB.anchorRelativeTo
						end
						local anchor = anchors[unitType]
						if anchor then
							anchor:UpdateAnchorPosition()
						end
					end,
					validate = function(_, frameName)
						return BigWigsAPI.IsValidFrame(frameName)
					end,
				},
				anchorPoint = {
					type = "select",
					name = L.sourcePoint,
					values = BigWigsAPI.GetFramePointList(),
					order = 4,
					width = 1.5,
					disabled = function(info)
						local unitType = info[#info-2]
						return db[unitType].anchorRelativeTo == plugin.defaultDB[unitType].anchorRelativeTo
					end,
				},
				anchorRelPoint = {
					type = "select",
					name = L.destinationPoint,
					values = BigWigsAPI.GetFramePointList(),
					order = 5,
					width = 1.5,
					disabled = function(info)
						local unitType = info[#info-2]
						return db[unitType].anchorRelativeTo == plugin.defaultDB[unitType].anchorRelativeTo
					end,
				},
				resetHeader = {
					type = "header",
					name = "",
					order = 100,
				},
				reset = {
					type = "execute",
					name = L.reset,
					desc = L.resetDesc,
					order = 101,
					func = function(info)
						local unitType = info[#info - 2]
						local optionDB = db[unitType]
						local defaultDB = plugin.defaultDB[unitType]
						optionDB.anchorPoint = defaultDB.anchorPoint
						optionDB.anchorRelPoint = defaultDB.anchorRelPoint
						optionDB.anchorXOffset = defaultDB.anchorXOffset
						optionDB.anchorYOffset = defaultDB.anchorYOffset
						optionDB.anchorRelativeTo = defaultDB.anchorRelativeTo
						updateProfile()
					end,
				},
			},
		},
	}

	plugin.pluginOptions = {
		type = "group",
		name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Flash:20|t ".. L.auras,
		childGroups = "tab",
		handler = plugin,
		order = 4,
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
				func = function()
					if inConfigureMode then
						plugin:SendMessage("BigWigs_StopConfigureMode", plugin.moduleName)
					else
						plugin:SendMessage("BigWigs_StartConfigureMode", plugin.moduleName)
					end
				end,
				width = 1.5,
				order = 1,
				disabled = IsFeatureEntirelyDisabled,
			},
			testButton = {
				type = "execute",
				name = L.createTestAura,
				func = function() CreateTestAura() end,
				width = 1.5,
				order = 2,
				disabled = IsFeatureEntirelyDisabled,
			},
			player = {
				type = "group",
				name = L.bossDebuffsOnYou,
				order = 4,
				childGroups = "tab",
				get = function(info)
					return db.player[info[#info]]
				end,
				set = function(info, value)
					db.player[info[#info]] = value
					updateProfile()
				end,
				args = {
					general = {
						type = "group",
						name = L.general,
						order = 1,
						args = {
							desc = {
								type = "description",
								name = L.aurasDesc,
								order = 1,
								width = "full",
								fontSize = "medium",
							},
							disabled = {
								type = "toggle",
								name = L.disabled,
								order = 2,
								width = "full",
								set = function(_, value)
									if value then
										MergeTables(db.player, plugin.defaultDB.player)
										db.player.disabled = true
									else
										db.player.disabled = false
									end
									updateProfile()
								end,
							},
							onlyActiveDuringBosses = {
								type = "toggle",
								name = L.onlyActiveDuringBosses,
								desc = L.onlyActiveDuringBossesDesc,
								order = 3,
								width = "full",
								disabled = IsAnchorDisabled,
							},
							resetHeader = {
								type = "header",
								name = "",
								order = 100,
							},
							reset = {
								type = "execute",
								name = L.resetAll,
								desc = L.resetAllDesc:format(L.bossDebuffsOnYou),
								order = 101,
								func = function()
									MergeTables(db.player, plugin.defaultDB.player)
									updateProfile()
								end,
							},
						},
					},
					icon = CopyTable(sharedUnitOptions.icon),
					border = CopyTable(sharedUnitOptions.border),
					cooldown = CopyTable(sharedUnitOptions.cooldown),
					dispelType = CopyTable(sharedUnitOptions.dispelType),
					applications = CopyTable(sharedUnitOptions.applications),
					position = CopyTable(sharedUnitOptions.position),
				},
			},
			other = {
				type = "group",
				name = L.bossDebuffsOnTank,
				order = 5,
				childGroups = "tab",
				get = function(info)
					return db.other[info[#info]]
				end,
				set = function(info, value)
					db.other[info[#info]] = value
					updateProfile()
				end,
				args = {
					general = {
						type = "group",
						name = L.general,
						order = 1,
						args = {
							desc = {
								type = "description",
								name = L.aurasOnAnotherDesc,
								order = 1,
								width = "full",
								fontSize = "medium",
							},
							disabled = {
								type = "toggle",
								name = L.disabled,
								order = 2,
								width = "full",
								set = function(_, value)
									if value then
										MergeTables(db.other, plugin.defaultDB.other)
										db.otherPlayerType = plugin.defaultDB.otherPlayerType
										db.onlyWhenYouAreTank = plugin.defaultDB.onlyWhenYouAreTank
										db.otherPlayerName = plugin.defaultDB.otherPlayerName
									else
										db.other.disabled = false
									end
									updateProfile()
								end,
							},
							onlyActiveDuringBosses = {
								type = "toggle",
								name = L.onlyActiveDuringBosses,
								desc = L.onlyActiveDuringBossesDesc,
								order = 3,
								width = "full",
								disabled = IsAnchorDisabled,
							},
							otherPlayerType = {
								type = "select",
								name = L.chooseAPlayer,
								order = 4,
								width = 1.3,
								values = {
									tank = L.theOtherTank,
									player = L.playerInYourGroup,
								},
								get = function()
									return db.otherPlayerType
								end,
								set = function(_, value)
									db.otherPlayerType = value
									db.otherPlayerName = ""
									UpdateAnchor("other")
								end,
								disabled = IsAnchorDisabled,
							},
							smallseparator = {
								type = "description",
								name = "",
								order = 5,
								width = 0.1,
							},
							otherPlayerName = {
								type = "select",
								name = L.playerInYourGroup,
								order = 6,
								width = 1.5,
								values = function()
									local playerList = {}
									local colorTbl = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
									for unit in plugin:IterateGroup(true) do
										if not UnitIsUnit("player", unit) and not UnitInPartyIsAI(unit) then
											local name = plugin:UnitName(unit)
											if name then
												local _, class = UnitClass(unit)
												local tbl = class and colorTbl[class] or GRAY_FONT_COLOR
												playerList[name] = ("%s|cFF%02x%02x%02x%s|r"):format(roleIcons[UnitGroupRolesAssigned(unit)], tbl.r*255, tbl.g*255, tbl.b*255, name)
											end
										end
									end
									return playerList
								end,
								get = function()
									return db.otherPlayerName
								end,
								set = function(_, value)
									db.otherPlayerName = value
									UpdateAnchor("other")
								end,
								hidden = function()
									return db.otherPlayerType == "tank"
								end,
								disabled = IsAnchorDisabled,
							},
							otherPlayerIsTankLabel = {
								type = "description",
								order = 7,
								width = 1.5,
								name = function()
									return L.theOtherTankDesc:format(FindTank() or L.none)
								end,
								hidden = function()
									return db.otherPlayerType == "player"
								end,
								disabled = IsAnchorDisabled,
							},
							onlyWhenYouAreTank = {
								type = "toggle",
								name = L.onlyWhenYouAreTank,
								order = 8,
								width = "full",
								get = function()
									return db.onlyWhenYouAreTank
								end,
								set = function(_, value)
									db.onlyWhenYouAreTank = value
									updateProfile()
								end,
								hidden = function()
									return db.otherPlayerType == "player"
								end,
								disabled = IsAnchorDisabled,
							},
							resetHeader = {
								type = "header",
								name = "",
								order = 100,
							},
							reset = {
								type = "execute",
								name = L.resetAll,
								desc = L.resetAllDesc:format(L.bossDebuffsOnTank),
								order = 101,
								func = function()
									MergeTables(db.other, plugin.defaultDB.other)
									db.otherPlayerType = plugin.defaultDB.otherPlayerType
									db.onlyWhenYouAreTank = plugin.defaultDB.onlyWhenYouAreTank
									db.otherPlayerName = plugin.defaultDB.otherPlayerName
									updateProfile()
								end,
							},
						},
					},
					icon = CopyTable(sharedUnitOptions.icon),
					border = CopyTable(sharedUnitOptions.border),
					cooldown = CopyTable(sharedUnitOptions.cooldown),
					dispelType = CopyTable(sharedUnitOptions.dispelType),
					applications = CopyTable(sharedUnitOptions.applications),
					tankIndicator = {
						type = "group",
						name = L.tankIndicator,
						order = 6,
						disabled = IsAnchorDisabled,
						args = {
							showTankIndicator = {
								type = "toggle",
								name = L.tankIndicator,
								order = 1,
								width = 1.2,
							},
							spacer = {
								type = "description",
								name = "",
								order = 2,
								width = 1.5,
							},
							tankIndicatorSize = {
								type = "range",
								name = L.iconSize,
								order = 3,
								width = 1.5,
								min = 1,
								max = 64,
								step = 1,
								disabled = function(info)
									local unitType = info[#info - 2]
									return not db[unitType].showTankIndicator
								end,
							},
							tankIndicatorAnchorPoint = {
								type = "select",
								name = L.position,
								order = 4,
								width = 1.5,
								values = BigWigsAPI.GetFramePointList(),
								disabled = function(info)
									local unitType = info[#info - 2]
									return not db[unitType].showTankIndicator
								end,
							},
							tankIndicatorAnchorXOffset = {
								type = "range",
								name = L.offsetX,
								order = 5,
								min = -100,
								max = 100,
								step = 1,
								width = 1.5,
								disabled = function(info)
									local unitType = info[#info - 2]
									return not db[unitType].showTankIndicator
								end,
							},
							tankIndicatorAnchorYOffset = {
								type = "range",
								name = L.offsetY,
								order = 6,
								min = -100,
								max = 100,
								step = 1,
								width = 1.5,
								disabled = function(info)
									local unitType = info[#info - 2]
									return not db[unitType].showTankIndicator
								end,
							},
							resetHeader = {
								type = "header",
								name = "",
								order = 100,
							},
							reset = {
								type = "execute",
								name = L.reset,
								desc = L.resetDesc,
								order = 101,
								func = function(info)
									local unitType = info[#info - 2]
									local optionDB = db[unitType]
									local defaultDB = plugin.defaultDB[unitType]
									optionDB.showTankIndicator = defaultDB.showTankIndicator
									optionDB.tankIndicatorSize = defaultDB.tankIndicatorSize
									optionDB.tankIndicatorAnchorPoint = defaultDB.tankIndicatorAnchorPoint
									optionDB.tankIndicatorAnchorXOffset = defaultDB.tankIndicatorAnchorXOffset
									optionDB.tankIndicatorAnchorYOffset = defaultDB.tankIndicatorAnchorYOffset
									updateProfile()
								end,
							},
						},
					},
					position = CopyTable(sharedUnitOptions.position),
				},
			},
		},
	}
end

do
	local createDragAnchor
	do
		local function OnDragStart(self)
			local anchor = self.dragAnchor
			local unitType = anchor.unitType
			if db[unitType].anchorRelativeTo == plugin.defaultDB[unitType].anchorRelativeTo then
				anchor:StartMoving()
			end
		end
		local function OnDragStop(self)
			local anchor = self.dragAnchor
			local unitType = anchor.unitType
			if db[unitType].anchorRelativeTo == plugin.defaultDB[unitType].anchorRelativeTo then
				anchor:StopMovingOrSizing()

				local point, _, relPoint, x, y = anchor:GetPoint()
				x = math.floor(x + 0.5)
				y = math.floor(y + 0.5)

				local anchorDB = db[unitType]
				anchorDB.anchorPoint = point
				anchorDB.anchorRelPoint = relPoint
				anchorDB.anchorXOffset = x
				anchorDB.anchorYOffset = y
				updateProfile()

				if BigWigsOptions and BigWigsOptions:IsOpen() then
					plugin:UpdateGUI()
				end
			end
		end

		local ARROW = [[Interface\AddOns\BigWigs\Media\Icons\arrows_up]]
		function createDragAnchor(parent)
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

			local bg = display:CreateTexture(nil, "BACKGROUND", nil, 2)
			bg:SetAllPoints(display)
			bg:SetColorTexture(0, 0, 0, 0.3)
			display.bg = bg

			local header = display:CreateFontString()
			header:SetFont(plugin:GetDefaultFont(12))
			header:SetShadowOffset(1, -1)
			header:SetTextColor(1, 0.82, 0, 1)
			header:SetPoint("CENTER", display, "CENTER")
			header:SetJustifyH("CENTER")
			header:SetJustifyV("MIDDLE")
			display.text = header

			local directionBox = CreateFrame("Frame", nil, display)
			display.directionBox = directionBox

			local directionUp = directionBox:CreateTexture(nil, "BACKGROUND", nil, 1)
			directionUp:SetTexture(ARROW)
			directionUp:SetPoint('CENTER', directionBox, 'TOP')
			directionUp:SetSize(20, 20)
			display.directionUp = directionUp

			local directionRight = directionBox:CreateTexture(nil, "BACKGROUND", nil, 1)
			directionRight:SetTexture(ARROW)
			directionRight:SetPoint('CENTER', directionBox, 'RIGHT')
			directionRight:SetSize(20, 20)
			directionRight:SetTexCoord(1, 1, 0, 1, 1, 0, 0, 0)
			display.directionRight = directionRight

			local directionDown = directionBox:CreateTexture(nil, "BACKGROUND", nil, 1)
			directionDown:SetTexture(ARROW)
			directionDown:SetPoint('CENTER', directionBox, 'BOTTOM')
			directionDown:SetSize(20, 20)
			directionDown:SetTexCoord(0, 1, 0, 0, 1, 1, 1, 0)
			display.directionDown = directionDown

			local directionLeft = directionBox:CreateTexture(nil, "BACKGROUND", nil, 1)
			directionLeft:SetTexture(ARROW)
			directionLeft:SetPoint('CENTER', directionBox, 'LEFT')
			directionLeft:SetSize(20, 20)
			directionLeft:SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1)
			display.directionLeft = directionLeft

			return display
		end
	end

	function plugin:BigWigs_StartConfigureMode(_, mode)
		if mode and mode ~= self.moduleName then return end
		if db.player.disabled and db.other.disabled then
			inConfigureMode = false
			for _, anchor in next, anchors do
				if anchor.configModeFrame then
					anchor.configModeFrame:Hide()
				end
			end
			return
		end
		inConfigureMode = true
		HideHelpTip(true)

		for unitType, anchor in next, anchors do
			local anchorDB = db[unitType]
			if anchorDB.disabled then
				if anchor.configModeFrame then
					anchor.configModeFrame:Hide()
				end
			else
				if not anchor.configModeFrame then
					anchor.configModeFrame = createDragAnchor(anchor)
					anchor.configModeFrame.text:SetText(anchor.unitType == "player" and L.aurasTestAnchorText or L.aurasTestTankAnchorText)
					anchor.configModeFrame.dragAnchor = anchor
				end

				local numTestIcons = anchor.numTestIcons or 0
				local spacing = numTestIcons > 1 and anchorDB.spacing or 0
				local direction = anchorDB.growthDirection
				anchor.configModeFrame.directionBox:ClearAllPoints()
				if numTestIcons == 0 then
					anchor.configModeFrame.directionBox:SetAllPoints()
				elseif direction == "UP" then
					anchor.configModeFrame.directionBox:SetSize(anchorDB.width, (numTestIcons * (anchorDB.height + spacing)) - spacing)
					anchor.configModeFrame.directionBox:SetPoint("BOTTOM", anchor.configModeFrame)
				elseif direction == "DOWN" then
					anchor.configModeFrame.directionBox:SetSize(anchorDB.width, (numTestIcons * (anchorDB.height + spacing)) - spacing)
					anchor.configModeFrame.directionBox:SetPoint("TOP", anchor.configModeFrame)
				elseif direction == "CENTER_VERTICAL" then
					anchor.configModeFrame.directionBox:SetSize(anchorDB.width, (numTestIcons * (anchorDB.height + spacing)) - spacing)
					anchor.configModeFrame.directionBox:SetPoint("CENTER", anchor.configModeFrame)
				elseif direction == "LEFT" then
					anchor.configModeFrame.directionBox:SetSize((numTestIcons * (anchorDB.width + spacing)) - spacing, anchorDB.height)
					anchor.configModeFrame.directionBox:SetPoint("RIGHT", anchor.configModeFrame)
				elseif direction == "RIGHT" then
					anchor.configModeFrame.directionBox:SetSize((numTestIcons * (anchorDB.width + spacing)) - spacing, anchorDB.height)
					anchor.configModeFrame.directionBox:SetPoint("LEFT", anchor.configModeFrame)
				elseif direction == "CENTER_HORIZONTAL" then
					anchor.configModeFrame.directionBox:SetSize((numTestIcons * (anchorDB.width + spacing)) - spacing, anchorDB.height)
					anchor.configModeFrame.directionBox:SetPoint("CENTER", anchor.configModeFrame)
				end

				anchor.configModeFrame.directionUp:SetShown(direction == "UP" or direction == "CENTER_VERTICAL")
				anchor.configModeFrame.directionRight:SetShown(direction == "RIGHT" or direction == "CENTER_HORIZONTAL")
				anchor.configModeFrame.directionDown:SetShown(direction == "DOWN" or direction == "CENTER_VERTICAL")
				anchor.configModeFrame.directionLeft:SetShown(direction == "LEFT" or direction == "CENTER_HORIZONTAL")
				anchor.configModeFrame.bg:SetAlpha(numTestIcons > 0 and 0 or 1)
				anchor.configModeFrame.text:SetAlpha(numTestIcons > 0 and 0 or 1)
				anchor.configModeFrame:Show()
			end
		end
	end
end

function plugin:BigWigs_StopConfigureMode(_, mode)
	if mode and mode ~= self.moduleName then return end
	inConfigureMode = false

	for _, anchor in next, anchors do
		if anchor.configModeFrame then
			anchor.configModeFrame:Hide()
		end
	end
end

--------------------------------------------------------------------------------
-- Initialization
--

do
	local tip, helpTipTimer
	function HideHelpTip(dismiss)
		if helpTipTimer then
			plugin:CancelTimer(helpTipTimer)
			helpTipTimer = nil
		end
		if tip then
			tip:Hide()
		end
		if dismiss then
			plugin.db.global.showHelpTip = false
		end
	end
	function ShowHelpTip()
		if not tip then
			tip = CreateFrame("Frame", nil, UIParent, "GlowBoxTemplate")
			tip:SetSize(260, 120)
			tip:SetFrameStrata("DIALOG")
			tip:SetFixedFrameStrata(true)
			tip:SetFrameLevel(100)
			tip:SetFixedFrameLevel(true)
			tip:SetClampedToScreen(true)
			tip:SetPoint("BOTTOM", anchors.player, "TOP", 0, 20)
			local arrow = CreateFrame("Frame", nil, tip, "GlowBoxArrowTemplate")
			arrow:SetPoint("TOP", tip, "BOTTOM", 0, 5)
			local tipText = tip:CreateFontString(nil, "OVERLAY", "GameFontHighlightLeft")
			tipText:SetJustifyH("LEFT")
			tipText:SetJustifyV("TOP")
			tipText:SetSize(240, 0)
			tipText:SetPoint("TOPLEFT", 10, -10)
			tipText:SetText(L.aurasHelpTip)
			local button = CreateFrame("Button", nil, tip, "SharedButtonTemplate")
			button:SetSize(130, 32)
			button:SetPoint("BOTTOM", 0, 6)
			button:SetText(L.settings)
			button:SetScript("OnClick", function()
				HideHelpTip(true)
				plugin:SendMessage("BigWigs_StartConfigureMode", plugin.moduleName)
				BigWigsAPI.OpenConfigToPanel("Auras")
			end)
		end
		tip:Show()
		CreateTestAura()
		if helpTipTimer then
			plugin:CancelTimer(helpTipTimer)
		end
		helpTipTimer = plugin:ScheduleRepeatingTimer(CreateTestAura, 10.2)
	end
end

function plugin:OnPluginEnable()
	previouslyFoundUnit = nil
	self:RegisterMessage("BigWigs_OnBossEngage", "OnEngage")
	self:RegisterMessage("BigWigs_OnBossEngageMidEncounter", "OnEngage")
	self:RegisterMessage("BigWigs_OnBossDisable")
	self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossDisable")
	self:RegisterMessage("BigWigs_StartConfigureMode")
	self:RegisterMessage("BigWigs_StopConfigureMode")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()

	self:RegisterEvent("GROUP_ROSTER_UPDATE")

	if not db.player.disabled and self.db.global.showHelpTip and anchors.player then
		ShowHelpTip()
	end
end

function plugin:OnPluginDisable()
	inConfigureMode = false
	activatedModules = {}
	HideHelpTip()
	-- Hide aura icon anchors
	for unitType, anchor in next, anchors do
		anchor:ClearAllPoints()
		anchor:Hide()
		if anchor.configModeFrame then
			anchor.configModeFrame:Hide()
		end
		ReleaseTestAuras(unitType)
	end
	-- Disable aura icon containers
	for _, auraContainer in next, containers do
		auraContainer:SetEnabled(false)
	end
end

function plugin:OnEngage(_, module)
	if module:IsWorldModule() or module:IsTrashModule() or (not module:GetJournalID() and not module:GetAllowWin()) then return end
	if next(activatedModules) then
		activatedModules[module] = true
		return
	else
		activatedModules[module] = true
	end
	HideHelpTip()

	if not db.player.disabled and db.player.onlyActiveDuringBosses and containers.player then
		containers.player:SetEnabled(true)
	end
	if not db.other.disabled and db.other.onlyActiveDuringBosses and containers.other and previouslyFoundUnit then
		containers.other:SetEnabled(true)
	end
end

function plugin:BigWigs_OnBossDisable(_, module)
	if activatedModules[module] then
		activatedModules[module] = nil
		if not next(activatedModules) then
			activatedModules = {}
			if db.player.onlyActiveDuringBosses and containers.player then
				containers.player:SetEnabled(false)
			end
			if db.other.onlyActiveDuringBosses and containers.other then
				containers.other:SetEnabled(false)
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Anchors
--

do
	local function GetUnitToken(playerType, playerName)
		if playerType == "tank" then
			if not db.onlyWhenYouAreTank or UnitGroupRolesAssigned("player") == "TANK" then
				for unit in plugin:IterateGroup(true) do
					if not UnitIsUnit("player", unit) and UnitGroupRolesAssigned(unit) == "TANK" then
						return unit
					end
				end
			end
		elseif playerName and playerName ~= "" and UnitExists(playerName) then
			for unit in plugin:IterateGroup(true) do
				if UnitIsUnit(playerName, unit) then
					return unit
				end
			end
		end
	end

	function plugin:GROUP_ROSTER_UPDATE()
		if not db.other.disabled then
			local token = GetUnitToken(db.otherPlayerType, db.otherPlayerName)
			if token ~= previouslyFoundUnit then
				previouslyFoundUnit = token
				UpdateAnchor("other", token)
			end
		end
	end

	do
		local function UpdateAnchorPosition(anchor)
			local anchorDB = db[anchor.unitType]

			local scale = anchor:GetScale()
			anchor:ClearAllPoints()

			local relativeTo = anchorDB.anchorRelativeTo
			local point, relPoint = anchorDB.anchorPoint, anchorDB.anchorRelPoint
			local x, y = anchorDB.anchorXOffset, anchorDB.anchorYOffset
			anchor:SetPoint(point, relativeTo, relPoint, x / scale, y / scale)
		end

		function UpdateAnchor(unitType, unitToken)
			local anchor = anchors[unitType]
			if not anchor then
				anchor = CreateFrame("Frame", "BigWigsAurasAnchor" .. (unitType:gsub("^%l", string.upper)), UIParent)
				anchor:SetFrameStrata("MEDIUM")
				anchor:SetFixedFrameStrata(true)
				anchor:SetFrameLevel(1000)
				anchor:SetFixedFrameLevel(true)
				anchor:SetMovable(true)
				anchor:SetClampedToScreen(true)

				anchor.unitType = unitType
				anchor.UpdateAnchorPosition = UpdateAnchorPosition

				anchors[unitType] = anchor
			end

			local anchorDB = db[unitType]
			if anchorDB.disabled then
				anchor:ClearAllPoints()
				anchor:Hide()
				if unitType == "other" then
					previouslyFoundUnit = nil
				else
					HideHelpTip()
				end
				if containers[unitType] then
					containers[unitType]:SetEnabled(false)
				end
				ReleaseTestAuras(unitType)
				return
			end

			anchor:SetSize(anchorDB.width, anchorDB.height)
			anchor:UpdateAnchorPosition()
			anchor:Show()

			if unitType == "other" then
				if not unitToken then
					unitToken = GetUnitToken(db.otherPlayerType, db.otherPlayerName)
				end
				previouslyFoundUnit = unitToken
			end
			UpdateAuraContainer(unitType, unitToken, anchor)
			UpdateTestAuras(unitType)
		end
	end
end

function UpdateAllAnchors()
	UpdateAnchor("player", "player")
	UpdateAnchor("other")
end

--------------------------------------------------------------------------------
-- Container & Test Auras
--

do
	local InitializeAuraFrame, UpdateAuraFrame

	do
		local durationBindings = {
			player = C_DurationUtil.CreateDurationTextBinding(),
			other = C_DurationUtil.CreateDurationTextBinding(),
		}
		local borderTables = {}

		do
			local durationOptions = {
				player = { binding = durationBindings.player },
				other = { binding = durationBindings.other },
			}

			local function BorderGetWidth(border)
				return border.plainWidth
			end

			local function BorderGetHeight(border)
				return border.plainHeight
			end

			function InitializeAuraFrame(unitType, aura)
				aura.unitType = unitType

				local icon = aura:CreateTexture(nil, "BACKGROUND")
				icon:SetAllPoints()
				aura:SetIcon(icon)
				aura.icon = icon

				local cooldown = CreateFrame("Cooldown", nil, aura, "CooldownFrameTemplate")
				cooldown:SetAllPoints()
				cooldown:SetReverse(true)
				cooldown:SetDrawEdge(false)
				cooldown:SetDrawBling(false)
				cooldown:SetHideCountdownNumbers(true)
				aura.cooldown = cooldown
				aura:SetDurationCooldown(cooldown)

				local duration = cooldown:CreateFontString(nil, "OVERLAY")
				duration:SetPoint("CENTER")
				aura.duration = duration
				aura.durationOptions = durationOptions[unitType]

				-- local cooldownBar = CreateFrame("StatusBar", nil, aura)
				-- aura.cooldownBar = cooldownBar
				-- if optionsDB.showCooldownBar then
				-- 	aura:SetDurationBar(cooldownBar)
				-- else
				-- 	cooldownBar:Hide()
				-- end

				local overlayFrame = CreateFrame("Frame", nil, aura)
				overlayFrame:SetAllPoints()
				overlayFrame:SetFrameLevel(aura:GetFrameLevel() + 10)

				local border = CreateFrame("Frame", nil, aura, "BackdropTemplate")
				border:SetFrameLevel(border:GetFrameLevel() + 1) -- show the border above the cooldown swipe
				-- The widget GetWidth/GetHeight return secrets for anything anchored to the aura,
				-- explicit size or not, and SetBackdrop does arithmetic on them
				border.GetWidth = BorderGetWidth
				border.GetHeight = BorderGetHeight
				aura.border = border

				local dispelIcon = border:CreateTexture(nil, "OVERLAY")
				aura.dispelIcon = dispelIcon

				local stacks = overlayFrame:CreateFontString(nil, "ARTWORK")
				aura.stacks = stacks

				if unitType == "other" then
					local tankIndicator = overlayFrame:CreateTexture(nil, "OVERLAY")
					aura.tankIndicator = tankIndicator
				end
			end
		end

		do
			local function GetFontFlags(monochrome, outline, slug)
				local flags
				if monochrome and outline ~= "NONE" then
					flags = "MONOCHROME," .. outline
				elseif monochrome then
					flags = "MONOCHROME"
				elseif outline ~= "NONE" then
					flags = outline
				end
				if slug then
					if not flags then
						flags = "SLUG"
					else
						flags = flags .. ",SLUG"
					end
				end
				return flags
			end

			local borderOptions = {
				style = 3, -- Enum.CustomAuraButtonDispelTypeTextureStyle.PreserveAsset = 3
				showWhenHarmful = true,
				showWhenHelpful = true,
				showWithoutDispelType = true,
			}

			local dispelIconOptions = {
				style = 2, -- Enum.CustomAuraButtonDispelTypeTextureStyle.Icon = 2
			}

			local backdropPieces = { -- keys from Blizzard_SharedXML/Backdrop.lua
				"TopLeftCorner",
				"TopRightCorner",
				"BottomLeftCorner",
				"BottomRightCorner",
				"TopEdge",
				"BottomEdge",
				"LeftEdge",
				"RightEdge",
			}

			function UpdateAuraFrame(aura, optionsDB)
				aura:EnableMouse(optionsDB.showTooltip)
				aura:SetSize(optionsDB.width, optionsDB.height)

				do
					-- icon aspect ratio and zoom calcs
					local zoom = 1 - optionsDB.zoom
					local zoomedOffset = 1 - ((1 - zoom) / 2)
					local offsetX, offsetY = zoomedOffset, zoomedOffset

					if optionsDB.keepAspectRatio then
						local width, height = optionsDB.width, optionsDB.height
						if width > height then
							offsetY = 1 - (1 - (height / width) * zoom) / 2
						elseif height > width then
							offsetX = 1 - (1 - (width / height) * zoom) / 2
						end
					end

					local left, right, top, bottom = 1 - offsetX, offsetX, 1 - offsetY, offsetY
					aura.icon:SetTexCoord(left, right, top, bottom)
				end

				local cooldown = aura:GetDurationCooldown()
				cooldown:SetDrawSwipe(optionsDB.showCooldown)

				local duration = aura.duration
				duration:SetFont(LibSharedMedia:Fetch("font", optionsDB.cooldownTextFontName), optionsDB.cooldownTextFontSize, GetFontFlags(optionsDB.cooldownTextMonochrome, optionsDB.cooldownTextOutline, optionsDB.cooldownTextSlug))
				if optionsDB.showCooldownText then
					local point = optionsDB.cooldownTextAnchorPoint
					duration:ClearAllPoints()
					duration:SetPoint(point, aura, point, optionsDB.cooldownTextAnchorXOffset, optionsDB.cooldownTextAnchorYOffset)

					if point == "RIGHT" or point == "TOPRIGHT" or point == "BOTTOMRIGHT" then
						duration:SetJustifyH("RIGHT")
					elseif point == "LEFT" or point == "TOPLEFT" or point == "BOTTOMLEFT" then
						duration:SetJustifyH("LEFT")
					else
						duration:SetJustifyH("CENTER")
					end

					aura:SetDurationText(duration, aura.durationOptions)
					duration:Show()
				else
					aura:ClearDurationText()
					duration:Hide()
				end

				aura:ClearDispelTypeTextures()

				if optionsDB.borderName ~= "None" then
					local borderWidth = optionsDB.width + optionsDB.borderOffset * 2
					local borderHeight = optionsDB.height + optionsDB.borderOffset * 2
					aura.border.plainWidth = borderWidth
					aura.border.plainHeight = borderHeight
					aura.border:ClearAllPoints()
					aura.border:SetPoint("CENTER")
					aura.border:SetSize(borderWidth, borderHeight)
					aura.border:SetBackdrop(borderTables[aura.unitType])

					if optionsDB.borderDispelColor then
						aura.border.hasDispelTextures = true
						for i = 1, #backdropPieces do
							local borderRegion = aura.border[backdropPieces[i]]
							if borderRegion then
								aura:AddDispelTypeTexture(borderRegion, borderOptions)
							end
						end
					else
						if aura.border.hasDispelTextures then
							aura.border.hasDispelTextures = nil
							for i = 1, #backdropPieces do
								local borderRegion = aura.border[backdropPieces[i]]
								if borderRegion then
									borderRegion:Show()
								end
							end
						end
						local color = optionsDB.borderColor
						aura.border:SetBackdropBorderColor(color[1], color[2], color[3], color[4])
					end
				else
					aura.border.hasDispelTextures = nil
					aura.border:ClearBackdrop()
				end

				if optionsDB.showDispelType then
					aura.dispelIcon:ClearAllPoints()
					aura.dispelIcon:SetPoint(optionsDB.dispelTypeAnchorPoint, aura, optionsDB.dispelTypeAnchorPoint, optionsDB.dispelTypeAnchorXOffset, optionsDB.dispelTypeAnchorYOffset)
					aura.dispelIcon:SetSize(optionsDB.dispelTypeSize, optionsDB.dispelTypeSize)
					aura:AddDispelTypeTexture(aura.dispelIcon, dispelIconOptions)
				else
					aura.dispelIcon:SetTexture(nil)
				end

				local stacks = aura.stacks
				stacks:SetFont(LibSharedMedia:Fetch("font", optionsDB.countTextFontName), optionsDB.countTextFontSize, GetFontFlags(optionsDB.countTextMonochrome, optionsDB.countTextOutline, optionsDB.countTextSlug))
				if optionsDB.showCountText then
					local point = optionsDB.countTextAnchorPoint
					stacks:ClearAllPoints()
					stacks:SetPoint(point, aura, point, optionsDB.countTextAnchorXOffset, optionsDB.countTextAnchorYOffset)

					if point == "RIGHT" or point == "TOPRIGHT" or point == "BOTTOMRIGHT" then
						stacks:SetJustifyH("RIGHT")
					elseif point == "LEFT" or point == "TOPLEFT" or point == "BOTTOMLEFT" then
						stacks:SetJustifyH("LEFT")
					else
						stacks:SetJustifyH("CENTER")
					end

					local textColor = optionsDB.countTextColor
					stacks:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
					stacks:Show()
					aura:SetApplicationCount(stacks)
				else
					stacks:Hide()
					aura:ClearApplicationCount()
				end

				if aura.tankIndicator then
					if optionsDB.showTankIndicator then
						local size = optionsDB.tankIndicatorSize
						aura.tankIndicator:ClearAllPoints()
						aura.tankIndicator:SetPoint(optionsDB.tankIndicatorAnchorPoint, aura, optionsDB.tankIndicatorAnchorPoint, optionsDB.tankIndicatorAnchorXOffset, optionsDB.tankIndicatorAnchorYOffset)
						aura.tankIndicator:SetSize(size, size)
						aura.tankIndicator:SetAtlas(size > 36 and "icons_64x64_tank" or "icons_16x16_tank")
						aura.tankIndicator:Show()
					else
						aura.tankIndicator:Hide()
					end
				end
			end
		end

		local UpdateDurationBindingAndBorderTable
		do
			local noDecimalBreakpoints = {
				{
					threshold = 0,
					format = ""
				},
				{
					threshold = 0.001,
					format = "%d",
				},
				{
					threshold = 0.0011,
					format = "%d",
				},
			}

			for _, binding in next, durationBindings do
				binding.breakpoints = {
					{
						threshold = 0,
						format = ""
					},
					{
						threshold = 0.001,
						format = "",
					},
					{
						threshold = 0.0011,
						format = "%0.1f",
					},
					{
						threshold = 2.999,
						format = "%0.1f",
					},
					{
						threshold = 3,
						format = "%d",
					},
				}

				local formatter = C_StringUtil.CreateNumericRuleFormatter()
				formatter:SetBreakpoints(binding.breakpoints)
				binding:SetFormatter(formatter)
				binding.formatter = formatter -- there's no 'binding:GetFormatter()'

				local colorCurve = C_CurveUtil.CreateColorCurve()
				colorCurve:SetType(1) -- Enum.LuaCurveType.Step = 1
				binding:SetTextColorCurve(colorCurve, 0) -- Enum.DurationTextBindingProperty.RemainingDuration = 0
				binding.colorCurve = colorCurve
			end

			function UpdateDurationBindingAndBorderTable(unitType, optionsDB)
				local binding = durationBindings[unitType]
				local formatter = binding.formatter
				if optionsDB.cooldownTextDecimals > 0 then
					binding.breakpoints[4].threshold = optionsDB.cooldownTextDecimals - 0.001
					binding.breakpoints[5].threshold = optionsDB.cooldownTextDecimals
					formatter:SetBreakpoints(binding.breakpoints)
				else
					formatter:SetBreakpoints(noDecimalBreakpoints)
				end
				binding:SetFormatter(formatter)

				local curve = binding.colorCurve
				curve:ClearPoints()
				local textColor = { r = optionsDB.cooldownTextColor[1], g = optionsDB.cooldownTextColor[2], b = optionsDB.cooldownTextColor[3], a = optionsDB.cooldownTextColor[4] }
				if optionsDB.cooldownEmphasizeTime > 0 then
					local emphasizedColor = { r = optionsDB.cooldownEmphasizeColor[1], g = optionsDB.cooldownEmphasizeColor[2], b = optionsDB.cooldownEmphasizeColor[3], a = optionsDB.cooldownEmphasizeColor[4] }
					curve:AddPoint(0.1, emphasizedColor)
					curve:AddPoint(optionsDB.cooldownEmphasizeTime - 0.1, emphasizedColor)
					curve:AddPoint(optionsDB.cooldownEmphasizeTime, textColor)
				else
					curve:AddPoint(0, textColor)
				end
				binding:SetTextColorCurve(curve, 0) -- Enum.DurationTextBindingProperty.RemainingDuration = 0

				if optionsDB.borderName ~= "None" then
					local edgeFile = LibSharedMedia:Fetch("border", optionsDB.borderName)
					local edgeSize = optionsDB.borderSize
					local tbl = borderTables[unitType]
					if not tbl or tbl.edgeFile ~= edgeFile or tbl.edgeSize ~= edgeSize then
						borderTables[unitType] = {
							edgeFile = edgeFile,
							edgeSize = edgeSize,
						}
					end
				end
			end
		end

		function UpdateAuraContainer(unitType, unitToken, parent)
			local optionsDB = db[unitType]
			UpdateDurationBindingAndBorderTable(unitType, optionsDB)

			local auraContainer = containers[unitType]
			if not auraContainer then
				auraContainer = CreateFrame("AuraContainer", "BigWigsAuraContainer"..(unitType:gsub("^%l", string.upper)), parent, "CustomAuraContainerTemplate")

				auraContainer:AddAuraGroup("debuffs", "HARMFUL", {
					maxFrameCount = optionsDB.maxIcons,
					initializeFrame = function(aura)
						InitializeAuraFrame(unitType, aura)
						UpdateAuraFrame(aura, db[unitType])
					end,
					sortMethod = 5, -- AuraContainerSortMethod.ExpirationOnly
					sortDirection = 0, -- AuraContainerSortDirection.Normal
					candidateFilters = {
						isFromPlayerOrPlayerPet = false,
						excludeSpellIDs = {
							-- LFG debuffs
							[26013] = true, -- Deserter
							[71041] = true, -- Dungeon Deserter
							[206151] = true, -- Challenger's Burden
							[1313593] = true, -- Deserter
							-- Bloodlust/Heroism debuffs
							[57723] = true, -- Exhaustion
							[57724] = true, -- Sated
							[80354] = true, -- Temporal Displacement
							[95809] = true, -- Insanity
							[160455] = true, -- Fatigued
							[264689] = true, -- Insanity
							-- Other debuffs
							[124255] = true, -- Stagger
						},
					},
					layout = {
						elementSpacing = optionsDB.spacing,
						elementWidth = optionsDB.width,
						elementHeight = optionsDB.height,
					},
				})

				containers[unitType] = auraContainer
			else
				-- These won't trigger a container update, so update them first
				for index = 1, auraContainer:GetAuraGroupFrameCount("debuffs") do
					local aura = auraContainer:GetAuraGroupFrame("debuffs", index)
					if aura:CanBeAccessedInContext() then
						UpdateAuraFrame(aura, optionsDB)
					end
				end

				auraContainer:SetAuraGroupMaxFrameCount("debuffs", optionsDB.maxIcons)
				auraContainer:SetAuraGroupLayout("debuffs", {
					elementSpacing = optionsDB.spacing,
					elementWidth = optionsDB.width,
					elementHeight = optionsDB.height,
				})
			end

			if unitToken then
				auraContainer:SetUnit(unitToken)
			end

			if optionsDB.onlyActiveDuringBosses then
				auraContainer:SetEnabled(not optionsDB.disabled and unitToken ~= nil and next(activatedModules) ~= nil)
			else
				auraContainer:SetEnabled(not optionsDB.disabled and unitToken ~= nil)
			end

			auraContainer:ClearAllPoints()
			local axis, point, x, y
			-- AnchorUtil.FlowLayoutAxis.Horizontal = 0, Vertical = 1
			-- AnchorUtil.FlowDirection.Left = -1, Right = 1, Up = 1, Down = -1
			if optionsDB.growthDirection == "RIGHT" or optionsDB.growthDirection == "CENTER_HORIZONTAL" then
				axis = 0
				point, x, y = "LEFT", 1, -1
			elseif optionsDB.growthDirection == "LEFT" then
				axis = 0
				point, x, y = "RIGHT", -1, -1
			elseif optionsDB.growthDirection == "UP" or optionsDB.growthDirection == "CENTER_VERTICAL" then
				axis = 1
				point, x, y = "BOTTOM", 1, 1
			elseif optionsDB.growthDirection == "DOWN" then
				axis = 1
				point, x, y = "TOP", 1, -1
			end
			auraContainer:SetFlowLayoutAxis(axis)
			auraContainer:SetFlowLayoutAnchorPoint(point)
			auraContainer:SetFlowLayoutGrowthDirection(x, y)

			if optionsDB.growthDirection == "CENTER_HORIZONTAL" or optionsDB.growthDirection == "CENTER_VERTICAL" then
				auraContainer:SetPoint("CENTER")
			else
				auraContainer:SetPoint(point)
			end
		end
	end

	--------------------------------------------------------------------------------
	-- Test Auras
	--

	local activeAuras = {
		player = {},
		other = {},
	}
	local inactiveAuras = {
		player = {},
		other = {},
	}

	local function releaseTestAura(aura)
		aura:ClearAllPoints()
		aura:Hide()
		aura.cooldown:Clear()
		aura.durationBinding:SetEnabled(false)
		local inactive = inactiveAuras[aura.unitType]
		inactive[#inactive + 1] = aura
	end

	function ReleaseTestAuras(unitType)
		local active = activeAuras[unitType]
		for i = #active, 1, -1 do
			releaseTestAura(active[i])
			active[i] = nil
		end
		if anchors[unitType] then
			anchors[unitType].numTestIcons = 0
		end
	end

	function UpdateTestAuras(unitType)
		local anchor = anchors[unitType]
		local active = activeAuras[unitType]
		local numActive = #active
		local maxIcons = db[unitType].maxIcons
		while numActive > maxIcons do
			releaseTestAura(table.remove(active))
			numActive = #active
		end
		if numActive > 0 then
			local optionsDB = db[unitType]
			local scale = anchor:GetScale()
			local point, relPoint
			local x, y = 0, 0
			if optionsDB.growthDirection == "RIGHT" then
				point, relPoint = "LEFT", "RIGHT"
				x = optionsDB.spacing
			elseif optionsDB.growthDirection == "LEFT" then
				point, relPoint = "RIGHT", "LEFT"
				x = -optionsDB.spacing
			elseif optionsDB.growthDirection == "UP" then
				point, relPoint = "BOTTOM", "TOP"
				y = optionsDB.spacing
			elseif optionsDB.growthDirection == "DOWN" then
				point, relPoint = "TOP", "BOTTOM"
				y = -optionsDB.spacing
			elseif optionsDB.growthDirection == "CENTER_HORIZONTAL" then
				point = "CENTER"
			elseif optionsDB.growthDirection == "CENTER_VERTICAL" then
				point = "CENTER"
			end

			local lastAura
			for index = 1, numActive do
				local aura = active[index]
				aura:ClearAllPoints()
				if relPoint then
					if index == 1 then
						aura:SetPoint("CENTER")
					else
						aura:SetPoint(point, lastAura, relPoint, x / scale, y / scale)
					end
				else
					local centerIndex = (numActive + 1) / 2
					if optionsDB.growthDirection == "CENTER_HORIZONTAL" then
						local offset = (index - centerIndex) * (optionsDB.width + optionsDB.spacing)
						aura:SetPoint(point, anchor, point, offset / scale, 0)
					elseif optionsDB.growthDirection == "CENTER_VERTICAL" then
						local offset = (index - centerIndex) * (optionsDB.height + optionsDB.spacing)
						aura:SetPoint(point, anchor, point, 0, offset / scale)
					end
				end

				UpdateAuraFrame(aura, optionsDB)
				lastAura = aura
			end
		end

		anchor.numTestIcons = numActive
	end

	do
		local activateTestAura
		do
			local createTestAura
			do
				local methods = { -- pretty annoying
					GetApplicationBar = false,
					SetApplicationBar = false,
					ClearApplicationBar = false,
					GetApplicationCount = false,
					SetApplicationCount = function(self, fontString) fontString:SetText(self.applications) end,
					ClearApplicationCount = false,
					GetDispelTypeTextureCount = false,
					GetDispelTypeTexture = false,
					AddDispelTypeTexture = function(self, region, options)
						local dispelInfo = self.dispelInfo
						if options.style == 2 then -- Enum.CustomAuraButtonDispelTypeTextureStyle.Icon = 2
							if dispelInfo.atlas then
								region:SetAtlas(dispelInfo.atlas, false)
								region:SetVertexColor(1, 1, 1, 1)
							else
								region:SetTexture(nil)
							end
						elseif options.style == 3 then -- Enum.CustomAuraButtonDispelTypeTextureStyle.PreserveAsset = 3
							region:SetVertexColor(dispelInfo.r, dispelInfo.g, dispelInfo.b, 1)
						end
					end,
					RemoveDispelTypeTexture = false,
					ClearDispelTypeTextures = false,
					GetDispelTypeText = false,
					SetDispelTypeText = false,
					ClearDispelTypeText = false,
					GetDurationCooldown = function(self) return self.cooldown end,
					SetDurationCooldown = false,
					ClearDurationCooldown = false,
					GetDurationText = false,
					SetDurationText = function(self, fontString, options)
						local duration = self.durationBinding:GetDuration()
						self.durationBinding:Assign(options.binding)
						self.durationBinding:SetFontString(fontString)
						if duration then
							self.durationBinding:SetDuration(duration)
						end
						self.durationBinding:SetEnabled(true)
					end,
					ClearDurationText = function(self) self.durationBinding:SetEnabled(false) end,
					GetDurationBar = false,
					SetDurationBar = false,
					ClearDurationBar = false,
					GetIcon = false,
					SetIcon = false,
					ClearIcon = false,
					GetSpellName = false,
					SetSpellName = false,
					ClearSpellName = false,
					GetAuraBorder = false,
					SetAuraBorder = false,
					ClearAuraBorder = false,
					EnableMouse = false,
				}
				local noop = function() end

				local function finishTestAura(cooldown)
					local aura = cooldown:GetParent()
					local unitType = aura.unitType
					local active = activeAuras[unitType]
					for i = 1, #active do
						if active[i] == aura then
							table.remove(active, i)
							break
						end
					end
					releaseTestAura(aura)
					UpdateTestAuras(unitType)
					if inConfigureMode then
						plugin:BigWigs_StartConfigureMode(nil, plugin.moduleName)
					end
				end

				function createTestAura(unitType)
					local aura = CreateFrame("Frame", nil, anchors[unitType])
					aura:SetFrameStrata("MEDIUM")
					aura:SetFixedFrameStrata(true)
					aura:SetFrameLevel(1000)
					aura:SetFixedFrameLevel(true)
					aura:Hide()

					for name, func in next, methods do
						aura[name] = func or noop
					end

					aura.durationBinding = C_DurationUtil.CreateDurationTextBinding()
					InitializeAuraFrame(unitType, aura)
					aura.cooldown:SetScript("OnCooldownDone", finishTestAura)

					return aura
				end
			end

			local CONFIG_MODE_DURATION = 10
			local dispelTypeList = {
				{ atlas = "RaidFrame-Icon-DebuffMagic", r = 0, g = 0.506, b = 1 }, -- DEBUFF_TYPE_MAGIC_COLOR
				{ atlas = "RaidFrame-Icon-DebuffCurse", r = 0.624, g = 0.024, b = 0.894 }, -- DEBUFF_TYPE_CURSE_COLOR
				{ atlas = "RaidFrame-Icon-DebuffDisease", r = 0.945, g = 0.416, b = 0.035 }, -- DEBUFF_TYPE_DISEASE_COLOR
				{ atlas = "RaidFrame-Icon-DebuffPoison", r = 0.482, g = 0.78, b = 0 }, -- DEBUFF_TYPE_POISON_COLOR
				{ atlas = "RaidFrame-Icon-DebuffBleed", r = 0.722, g = 0, b = 0.059 }, -- DEBUFF_TYPE_BLEED_COLOR
				{ atlas = nil, r = 0.8, g = 0, b = 0 }, -- DEBUFF_TYPE_NONE_COLOR
			}
			local testSpellTextures = { 4914668, 4048815, 4914673, 4914674, 4630415 }

			function activateTestAura(unitType)
				local aura = table.remove(inactiveAuras[unitType])
				if not aura then
					aura = createTestAura(unitType)
				end
				local active = activeAuras[unitType]
				active[#active + 1] = aura

				-- Setup test aura info
				local icon = testSpellTextures[math.random(#testSpellTextures)]
				local dispelInfo = dispelTypeList[math.random(#dispelTypeList)]
				local applications = math.random(0, 5)

				local duration = C_DurationUtil.CreateDuration()
				duration:SetTimeFromStart(GetTime(), CONFIG_MODE_DURATION)

				aura.icon:SetTexture(icon)
				aura.cooldown:SetCooldownFromDurationObject(duration)
				aura.durationBinding:SetDuration(duration)
				aura.applications = applications > 1 and applications or ""
				aura.dispelInfo = dispelInfo

				aura:Show()
			end
		end

		function CreateTestAura()
			for unitType in next, anchors do
				if not db[unitType].disabled then
					if #activeAuras[unitType] < db[unitType].maxIcons then
						activateTestAura(unitType)
						UpdateTestAuras(unitType)
					end
				end
			end
			if inConfigureMode then
				plugin:BigWigs_StartConfigureMode(nil, plugin.moduleName)
			end
		end
	end
end
