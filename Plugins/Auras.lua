if not BigWigsLoader.isRetail then return end -- 12.1+ only module

-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin, L = BigWigs:NewPlugin("Auras")
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local FONT = LibSharedMedia.MediaType and LibSharedMedia.MediaType.FONT or "font"
local SOUND = LibSharedMedia.MediaType and LibSharedMedia.MediaType.SOUND or "sound"
local ARROW = [[Interface\AddOns\BigWigs\Media\Icons\arrows_up]]

local CONFIG_MODE_DURATION = 10

local db
local containers = {}
local anchors = {}
local inConfigureMode = false
local previouslyFoundUnit = nil

local InitializeAuraFrame, UpdateAuraFrame, UpdateTestAuras
local UpdateAuraContainer
local UpdateSoundOptions, UpdateRegisteredSounds
local AddAuraSound, RemoveAuraSound, AddAllAuraSounds, RemoveAllAuraSounds

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
			t[k] = v
		end
	end
	return t
end

--------------------------------------------------------------------------------
-- Profile
--

do
	local sharedDefaults = {
		disabled = true,

		width = 64,
		height = 64,
		zoom = 0,
		spacing = 6,
		showCooldown = true,
		showTooltip = true,
		keepAspectRatio = true,

		showDispelType = true,
		dispelTypeSize = 24,
		dispelTypeAnchorPoint = "TOPRIGHT",
		dispelTypeAnchorRelPoint = "TOPRIGHT",
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
		cooldownTextMillisecondsThreshold = 3,
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
			disabled = true,
		}),
		other = MergeTables(CopyTable(sharedDefaults), {
			disabled = false,
			anchorYOffset = 120,
		}),
		otherPlayerType = "tank",
		onlyWhenYouAreTank = false,
		otherPlayerName = "",
		tankIndicator = true,
		sounds = {},
	}
end

plugin.defaultGlobalDB = {
	showHelpTip = true,
}

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

local profileUnits = {"player", "other"}

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
		elseif type(v) == "table" and k ~= "sounds" then
			for subKey, subValue in next, db[k] do
				defaultType = type(plugin.defaultDB[k][subKey])
				if defaultType == "nil" then
					db[k][subKey] = nil
				elseif type(subValue) ~= defaultType then
					db[k][subKey] = plugin.defaultDB[k][subKey]
				end
			end
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
		if not db[unitType].tempSizeMigrate and db[unitType].size then -- XXX 12.1.0
			db[unitType].width = db[unitType].size
			db[unitType].height = db[unitType].size
			db[unitType].tempSizeMigrate = true
		end

		if db[unitType].width < 24 or db[unitType].width > 256 then
			db[unitType].width = plugin.defaultDB[unitType].width
		end
		if db[unitType].height < 24 or db[unitType].height > 256 then
			db[unitType].height = plugin.defaultDB[unitType].height
		end
		if db[unitType].zoom < 0 or db[unitType].zoom > 0.5 then
			db[unitType].zoom = plugin.defaultDB[unitType].zoom
		end
		if db[unitType].spacing < 0 or db[unitType].spacing > 50 then
			db[unitType].spacing = plugin.defaultDB[unitType].spacing
		end
		if db[unitType].cooldownTextFontSize < 8 or db[unitType].cooldownTextFontSize > 200 then
			db[unitType].cooldownTextFontSize = plugin.defaultDB[unitType].cooldownTextFontSize
		end
		ValidateColor(db[unitType].cooldownTextColor, plugin.defaultDB[unitType].cooldownTextColor, 0)
		if db[unitType].cooldownEmphasizeTime < 0 or db[unitType].cooldownEmphasizeTime > 30 then
			db[unitType].cooldownEmphasizeTime = plugin.defaultDB[unitType].cooldownEmphasizeTime
		end
		if db[unitType].cooldownTextFontSize < 10 or db[unitType].cooldownTextFontSize > 200 then
			db[unitType].cooldownTextFontSize = plugin.defaultDB[unitType].cooldownTextFontSize
		end
		if db[unitType].cooldownTextDecimals < 0 or db[unitType].cooldownTextDecimals > 60 then
			db[unitType].cooldownTextDecimals = plugin.defaultDB[unitType].cooldownTextDecimals
		end
		ValidateColor(db[unitType].cooldownEmphasizeColor, plugin.defaultDB[unitType].cooldownEmphasizeColor, 0)
		if db[unitType].countTextFontSize < 8 or db[unitType].countTextFontSize > 200 then
			db[unitType].countTextFontSize = plugin.defaultDB[unitType].countTextFontSize
		end
		ValidateColor(db[unitType].countTextColor, plugin.defaultDB[unitType].countTextColor, 0)
		ValidateColor(db[unitType].borderColor, plugin.defaultDB[unitType].borderColor, 0)
		if db[unitType].borderSize < 1 or db[unitType].borderSize > 32 then
			db[unitType].borderSize = plugin.defaultDB[unitType].borderSize
		end
		if db[unitType].borderOffset < 0 or db[unitType].borderOffset > 32 then
			db[unitType].borderOffset = plugin.defaultDB[unitType].borderOffset
		end
		do
			if not BigWigsAPI.IsValidFramePoint(db[unitType].anchorPoint) or not BigWigsAPI.IsValidFramePoint(db[unitType].anchorRelPoint) then
				db[unitType].anchorPoint = plugin.defaultDB[unitType].anchorPoint
				db[unitType].anchorRelPoint = plugin.defaultDB[unitType].anchorRelPoint
				db[unitType].anchorXOffset = plugin.defaultDB[unitType].anchorXOffset
				db[unitType].anchorYOffset = plugin.defaultDB[unitType].anchorYOffset
				db[unitType].anchorRelativeTo = plugin.defaultDB[unitType].anchorRelativeTo
			end

			local x = math.floor(db[unitType].anchorXOffset+0.5)
			if x ~= db[unitType].anchorXOffset then
				db[unitType].anchorXOffset = x
			end
			local y = math.floor(db[unitType].anchorYOffset+0.5)
			if y ~= db[unitType].anchorYOffset then
				db[unitType].anchorYOffset = y
			end

			if db[unitType].anchorRelativeTo ~= plugin.defaultDB[unitType].anchorRelativeTo then
				local frame = _G[db[unitType].anchorRelativeTo]
				if type(frame) ~= "table" or type(frame.GetObjectType) ~= "function" or type(frame.IsForbidden) ~= "function" or frame:IsForbidden() then
					db[unitType].anchorPoint = plugin.defaultDB[unitType].anchorPoint
					db[unitType].anchorRelPoint = plugin.defaultDB[unitType].anchorRelPoint
					db[unitType].anchorXOffset = plugin.defaultDB[unitType].anchorXOffset
					db[unitType].anchorYOffset = plugin.defaultDB[unitType].anchorYOffset
					db[unitType].anchorRelativeTo = plugin.defaultDB[unitType].anchorRelativeTo
				end
			end
		end

		if db[unitType].maxIcons < 1 or db[unitType].maxIcons > 5 then
			db[unitType].maxIcons = plugin.defaultDB[unitType].maxIcons
		else
			local maxIcons = math.floor(db[unitType].maxIcons+0.5)
			if maxIcons ~= db[unitType].maxIcons then
				db[unitType].maxIcons = maxIcons
			end
		end
	end

	if db.otherPlayerType ~= "tank" and db.otherPlayerType ~= "player" then
		db.otherPlayerType = plugin.defaultDB.otherPlayerType
	end

	plugin:UpdateAllAnchors()
	if inConfigureMode then -- Update visible anchors
		plugin:BigWigs_StartConfigureMode(nil, plugin.moduleName)
	end
end

--------------------------------------------------------------------------------
-- Options
--

do
	local function IsAnchorDisabled(info)
		local unitType = info[#info-2]
		local optionDB = db[unitType]

		if optionDB.disabled then
			return true
		end
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
				local colorTbl = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
				local name = plugin:UnitName(unit)
				local _, class = UnitClass(unit)
				local tbl = class and colorTbl[class] or GRAY_FONT_COLOR
				return ("%s|cFF%02x%02x%02x%s|r"):format(roleIcons.TANK, tbl.r*255, tbl.g*255, tbl.b*255, name)
			end
		end
	end
	local function IsFeatureEntirelyDisabled()
		if db.player.disabled and db.other.disabled then
			return true
		end
	end

	-- local followerShortNameMap = {
	-- 	[L.garrick] = L.garrick_short,
	-- 	[L.meredy] = L.meredy_short,
	-- 	[L.shuja] = L.shuja_short,
	-- 	[L.crenna] = L.crenna_short,
	-- 	[L.austin] = L.austin_short,
	-- 	[L.breka] = L.breka_short,
	-- 	[L.henry] = L.henry_short,
	-- }

	function UpdateSoundOptions(forceNotify)
		plugin.pluginOptions.args.sounds.args = {}
		local options = plugin.pluginOptions.args.sounds.args

		options.header = {
			type = "description",
			name = L.addAuraSpellDesc,
			fontSize = "medium",
			order = 1,
		}
		options.add = {
			type = "input",
			name = L.addAuraSpell,
			get = false,
			set = function(_, value)
				local spellID = C_Spell.GetSpellIDForSpellIdentifier(value)
				table.insert(db.sounds, {
					enabled = true,
					spellID = spellID,
					trigger = 0,
					unit = "player",
					sound = LibSharedMedia:GetDefault(SOUND),
				})
				UpdateSoundOptions()
			end,
			validate = function(_, value)
				if not C_Spell.GetSpellIDForSpellIdentifier(value) then
					return ("%s: %s"):format(L.auras, L.invalidSpell)
				end
				return true
			end,
			order = 2,
		}

		local function get(info)
			local index = tonumber(info[#info - 1])
			if not db.sounds[index] then return false end
			local key = info[#info]
			return db.sounds[index][key]
		end

		local function set(info, value)
			local index = tonumber(info[#info - 1])
			local auraDB = db.sounds[index]
			local key = info[#info]
			auraDB[key] = value

			if key == "trigger" and value ~= 3 then
				auraDB.sound = auraDB.sound or LibSharedMedia:GetDefault(SOUND)
				auraDB.voice = nil
				auraDB.duration = nil
			elseif key == "trigger" and value == 3 then
				auraDB.sound = nil
				auraDB.voice = "Amy"
				auraDB.duration = 0
			end
			if key == "unit" and value ~= "name" then
				auraDB.playerName = nil
			end

			AddAuraSound(index)
		end

		local order = 0
		for soundIndex = #db.sounds, 1, -1 do
			order = order + 1
			local soundInfo = db.sounds[soundIndex]
			local spellInfo = C_Spell.GetSpellInfo(soundInfo.spellID)
			options[tostring(soundIndex)] = {
				type = "group",
				name = " ",
				inline = true,
				order = order + 10,
				get = get,
				set = set,
				args = {
					enabled = {
						type = "toggle",
						name = ("|cfffed000%s|r (%d)"):format(spellInfo and spellInfo.name or L.unknown, soundInfo.spellID),
						image = spellInfo and spellInfo.iconID or 134400, -- question mark
						width = 2.6,
						order = 1,
					},
					remove = {
						type = "execute",
						name = L.remove,
						func = function(info)
							GameTooltip:Hide()
							local index = tonumber(info[#info - 1])
							RemoveAuraSound(index, true)
							UpdateSoundOptions()
						end,
						width = 0.6,
						order = 2,
					},
					trigger = {
						type = "select",
						name = L.trigger,
						values = {
							[0] = L.onApplied,
							[1] = L.onDose,
							[2] = L.onRemoved,
							[3] = L.countdown,
						},
						width = 1.4,
						order = 3,
					},
					sound = {
						type = "select",
						name = L.sound,
						get = function(info)
							local index = tonumber(info[#info - 1])
							if not db.sounds[index] then return end
							local sound = db.sounds[index].sound
							for i, v in next, LibSharedMedia:List(SOUND) do
								if v == sound then
									return i
								end
							end
						end,
						set = function(info, value) set(info, LibSharedMedia:List(SOUND)[value]) end,
						values = LibSharedMedia:List(SOUND),
						dialogControl = "BigWigsSharedDropdown",
						itemControl = "DDI-Sound",
						hidden = function() return db.sounds[soundIndex].trigger == 3 end,
						width = 1.8,
						order = 4,
					},
					voice = {
						type = "select",
						name = L.countdownVoice,
						values = {
							Amy = "English: Amy",
							-- David = "English: David",
							-- Jim = "English: Jim",
						},
						hidden = function() return db.sounds[soundIndex].trigger ~= 3 end,
						width = 1.1,
						order = 4,
					},
					duration = {
						type = "range",
						name = L.auraDuration,
						desc = L.auraDurationDesc,
						min = 1, max = 30, step = 1,
						hidden = function() return db.sounds[soundIndex].trigger ~= 3 end,
						width = 0.6,
						order = 5,
					},
					unit = {
						type = "select",
						name = L.selectPlayer,
						values = {
							player = L.myself,
							tank = L.indicatorType_Tank,
							name = L.playerInYourGroup,
						},
						sorting = { "player", "tank", "name" },
						width = 1,
						order = 6,
					},
					playerName = {
						type = "select",
						name = L.playerInYourGroup,
						values = function()
							local playerList = {}
							local colorTbl = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
							for unit in plugin:IterateGroup(true) do
								if not UnitInPartyIsAI(unit) then
									local name = plugin:UnitName(unit)
									local _, class = UnitClass(unit)
									local tbl = class and colorTbl[class] or GRAY_FONT_COLOR
									playerList[name] = ("%s|cFF%02x%02x%02x%s|r"):format(roleIcons[UnitGroupRolesAssigned(unit)], tbl.r*255, tbl.g*255, tbl.b*255, name)
								end
							end
							return playerList
						end,
						hidden = function() return db.sounds[soundIndex].unit ~= "name" end,
						width = 1.6,
						order = 7,
					},
					unitTarget = {
						type = "description",
						name = function()
							local unitType = db.sounds[soundIndex].unit
							if unitType == "player" then
								return ""
							end
							local name = L.none
							local unit = plugin:GetUnitToken(unitType, db.sounds[soundIndex].playerName)
							if unit then
								name = plugin:UnitName(unit)
								-- name = followerShortNameMap[name] or name
								local _, class = UnitClass(unit)
								local color = C_ClassColor.GetClassColor(class) or GRAY_FONT_COLOR
								-- local role = UnitGroupRolesAssigned(unit)
								-- name = ("%s%s%s|r"):format(roleIcons[role] or "", color:GenerateHexColorMarkup(), name)
								name = color:WrapTextInColorCode(name)
							end
							return "  "..L.currentUnit:format(name)
						end,
						width = 1.2,
						order = 8,
					},
				},
			}
		end

		if forceNotify then
			plugin:UpdateGUI()
		end
	end

	local sharedUnitOptions = {
		icon = {
			type = "group",
			name = L.icon,
			order = 2,
			disabled = function(info)
				local unitType = info[#info - 1]
				return db[unitType].disabled
			end,
			args = {
				maxIcons = {
					type = "range",
					name = L.maxIcons,
					order = 1,
					width = 1.6,
					desc = L.maxIconsDesc,
					min = 1,
					max = 5,
					step = 1,
					disabled = false,
				},
				growthDirection = {
					type = "select",
					name = L.growthDirection,
					order = 2,
					width = 1.6,
					values = {
						LEFT = L.LEFT,
						RIGHT = L.RIGHT,
						UP = L.UP,
						DOWN = L.DOWN,
						CENTER_HORIZONTAL = L.CENTER_HORIZONTAL,
						CENTER_VERTICAL = L.CENTER_VERTICAL,
					},
					disabled = false,
				},
				keepAspectRatio = {
					type = "toggle",
					name = L.keepAspectRatio,
					desc = L.keepAspectRatioDesc,
					order = 3,
					set = function(info, value)
						local unitType = info[#info - 2]
						db[unitType].keepAspectRatio = value
						if value then
							db[unitType].height = db[unitType].width
						end
						updateProfile()
					end,
					disabled = false,
				},
				width = {
					type = "range",
					name = L.width,
					order = 4,
					width = 1.1,
					min = 24,
					max = 256,
					step = 1,
					set = function(info, value)
						local unitType = info[#info - 2]
						db[unitType].width = value
						if db[unitType].keepAspectRatio then
							db[unitType].height = value
						end
						updateProfile()
					end,
					disabled = false,
				},
				height = {
					type = "range",
					name = L.height,
					order = 5,
					width = 1.1,
					min = 24,
					max = 256,
					step = 1,
					get = function(info)
						local unitType = info[#info - 2]
						if db[unitType].keepAspectRatio then
							return db[unitType].width
						end
						return db[unitType].height
					end,
					disabled = function(info)
						local unitType = info[#info - 2]
						return db[unitType].keepAspectRatio
					end,
				},
				zoom = {
					type = "range",
					name = L.zoom,
					desc = L.zoomDesc,
					order = 6,
					width = 1.6,
					min = 0,
					max = 0.5,
					step = 0.01,
					isPercent = true,
					disabled = false,
				},
				spacing = {
					type = "range",
					name = L.iconSpacing,
					order = 7,
					width = 1.6,
					min = 0,
					max = 50,
					step = 1,
					disabled = false,
				},
				spacer1 = {
					type = "description",
					name = "",
					order = 8,
					width = 1.6,
					disabled = false,
				},
				showTooltip = {
					type = "toggle",
					name = L.iconTooltip,
					desc = L.iconTooltipDesc,
					order = 9,
					disabled = false,
				},
				spacer2 = {
					type = "description",
					name = "",
					order = 10,
					width = 1.6,
					disabled = false,
				},
				showCooldown = {
					type = "toggle",
					name = L.showCooldown,
					desc = L.showCooldownSwipeDesc,
					order = 11,
					disabled = false,
				},
			},
		},
		border = {
			type = "group",
			name = L.border,
			order = 3,
			disabled = function(info)
				local unitType = info[#info - 1]
				return db[unitType].disabled
			end,
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
					disabled = false,
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
						return db[unitType].borderDispelColor
					end,
				},
			},
		},
		cooldown = {
			type = "group",
			name = L.cooldown,
			order = 4,
			disabled = function(info)
				local unitType = info[#info - 1]
				return db[unitType].disabled
			end,
			args = {
				showCooldownText = {
					type = "toggle",
					name = L.showCooldownText,
					order = 1,
					disabled = false,
				},
				spacer = {
					type = "description",
					name = "",
					order = 2,
					width = 1.5,
					disabled = false
				},
				cooldownTextFontName = {
					type = "select",
					name = L.font,
					order = 3,
					values = LibSharedMedia:List(FONT),
					itemControl = "DDI-Font",
					get = function(info)
						local unitType = info[#info - 2]
						for i, v in next, LibSharedMedia:List(FONT) do
							if v == db[unitType].cooldownTextFontName then
								return i
							end
						end
					end,
					set = function(info, value)
						local unitType = info[#info - 2]
						local list = LibSharedMedia:List(FONT)
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
				cooldownTextColor = {
					type = "color",
					name = L.fontColor,
					order = 8,
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
					order = 9,
					width = 1.6,
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
					order = 10,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCooldownText
					end,
				},
				cooldownEmphasizeHeading = {
					type = "description",
					name = L.cooldownEmphasizeHeader,
					order = 11,
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
					order = 12,
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
					order = 13,
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
						return not db[unitType].showCooldownText or not db[unitType].showCooldownText or db[unitType].cooldownEmphasizeTime == 0
					end,
				},
				cooldownEmphasizeFontSize = {
					type = "range",
					name = L.fontSize,
					desc = L.fontSizeDesc,
					order = 14,
					min = 10,
					softMax = 100,
					max = 200,
					step = 1,
					disabled = true, -- not currently possible
				},
			},
		},
		dispelType = {
			type = "group",
			name = L.dispelType,
			order = 5,
			disabled = function(info)
				local unitType = info[#info - 1]
				return db[unitType].disabled
			end,
			args = {
				showDispelType = {
					type = "toggle",
					name = L.showDispelType,
					desc = L.showDispelTypeDesc,
					order = 1,
					width = 1.2,
					disabled = false,
				},
				spacer = {
					type = "description",
					name = "",
					order = 2,
					width = 1.5,
					disabled = false
				},
				dispelTypeSize = {
					type = "range",
					name = L.iconSize,
					order = 3,
					width = "full",
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
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showDispelType
					end,
				},
			},
		},
		applications = {
			type = "group",
			name = L.countText,
			order = 6,
			disabled = function(info)
				local unitType = info[#info - 1]
				return db[unitType].disabled
			end,
			args = {
				showCountText = {
					type = "toggle",
					name = L.showCountText,
					order = 1,
					disabled = false,
				},
				spacer = {
					type = "description",
					name = "",
					order = 2,
					width = 1.5,
					disabled = false
				},
				countTextFontName = {
					type = "select",
					name = L.font,
					order = 3,
					values = LibSharedMedia:List(FONT),
					itemControl = "DDI-Font",
					get = function()
						for i, v in next, LibSharedMedia:List(FONT) do
							if v == db.player.countTextFontName then return i end
						end
					end,
					set = function(_, value)
						local list = LibSharedMedia:List(FONT)
						db.player.countTextFontName = list[value]
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
						local colorTable = db.player.countTextColor
						return colorTable[1], colorTable[2], colorTable[3], colorTable[4]
					end,
					set = function(_, r, g, b, a)
						db.player.countTextColor  = {r, g, b, a}
						updateProfile()
					end,
					hasAlpha = true,
					disabled = function(info)
						local unitType = info[#info - 2]
						return not db[unitType].showCountText
					end,
				},
			},
		},
		position = {
			type = "group",
			name = L.positionExact,
			order = 7,
			set = function(info, value)
				local unitType = info[#info - 2]
				db[unitType][info[#info]] = value
				local anchor = anchors[unitType]
				if anchor then
					anchor:UpdateAnchorPosition()
				end
			end,
			disabled = function(info)
				local unitType = info[#info - 1]
				return db[unitType].disabled
			end,
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
					disabled = false,
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
					disabled = false,
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
					validate = function(_, value)
						local frame = _G[value]
						if type(frame) ~= "table" or type(frame.GetObjectType) ~= "function" or type(frame.IsForbidden) ~= "function" or frame:IsForbidden() then
							return false
						end
						return true
					end,
					disabled = false,
				},
				anchorPoint = {
					type = "select",
					name = L.sourcePoint,
					values = BigWigsAPI.GetFramePointList(),
					order = 4,
					width = 1.5,
					disabled = function(info)
						local unitType = info[#info-2]
						return db[unitType].disabled or db[unitType].anchorRelativeTo == plugin.defaultDB[unitType].anchorRelativeTo
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
						return db[unitType].disabled or db[unitType].anchorRelativeTo == plugin.defaultDB[unitType].anchorRelativeTo
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
				func = "CreateTestAura",
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
								func = function()
									MergeTables(plugin.db.profile.player, plugin.defaultDB.player)
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
							},
							otherPlayerType = {
								type = "select",
								name = L.chooseAPlayer,
								order = 3,
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
									plugin:UpdateAnchor("other")
								end,
								disabled = IsAnchorDisabled,
							},
							smallseparator = {
								type = "description",
								name = "",
								order = 4,
								width = 0.1,
							},
							otherPlayerName = {
								type = "select",
								name = L.playerInYourGroup,
								order = 5,
								width = 1.6,
								values = function()
									local playerList = {}
									local colorTbl = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
									for unit in plugin:IterateGroup(true) do
										if not UnitInPartyIsAI(unit) then
											local name = plugin:UnitName(unit)
											local _, class = UnitClass(unit)
											local tbl = class and colorTbl[class] or GRAY_FONT_COLOR
											playerList[name] = ("%s|cFF%02x%02x%02x%s|r"):format(roleIcons[UnitGroupRolesAssigned(unit)], tbl.r*255, tbl.g*255, tbl.b*255, name)
										end
									end
									return playerList
								end,
								get = function()
									return db.otherPlayerName
								end,
								set = function(_, value)
									db.otherPlayerName = value
									plugin:UpdateAnchor("other")
								end,
								hidden = function()
									return db.otherPlayerType == "tank"
								end,
								disabled = IsAnchorDisabled,
							},
							otherPlayerIsTankLabel = {
								type = "description",
								order = 6,
								width = 1.6,
								name = function()
									return L.theOtherTankDesc:format(FindTank("tank") or L.none)
								end,
								hidden = function()
									return db.otherPlayerType == "player"
								end,
								disabled = IsAnchorDisabled,
							},
							onlyWhenYouAreTank = {
								type = "toggle",
								name = L.onlyWhenYouAreTank,
								order = 7,
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
							showTankIndicator = {
								type = "toggle",
								name = L.tankIndicator,
								order = 8,
								get = function()
									return db.tankIndicator
								end,
								set = function(_, value)
									db.tankIndicator = value
									updateProfile()
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
								name = L.reset,
								desc = L.resetDesc,
								order = 101,
								func = function()
									MergeTables(plugin.db.profile.other, plugin.defaultDB.other)
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
			sounds = {
				type = "group",
				name = L.auraSounds,
				order = 6,
				args = {
				},
			},
		},
	}

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

	function plugin:BigWigs_StartConfigureMode(_, mode)
		if mode and mode ~= self.moduleName then return end
		inConfigureMode = true

		for unitType, anchor in next, anchors do
			if not anchor.configModeFrame then
				anchor.configModeFrame = createDragAnchor(anchor)
				anchor.configModeFrame.text:SetText(anchor.unitType == "player" and L.aurasTestAnchorText or L.aurasTestTankAnchorText)
				anchor.configModeFrame.dragAnchor = anchor
			end

			local anchorDB = db[unitType]
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

	function plugin:BigWigs_StopConfigureMode(_, mode)
		if mode and mode ~= self.moduleName then return end
		inConfigureMode = false

		for _, anchor in next, anchors do
			if anchor.configModeFrame then
				anchor.configModeFrame:Hide()
			end
		end

		self:UpdateAllAnchors()
	end
end

--------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnRegister()
	self.displayName = L.auras
end

local function ShowHelpTip()
	local tip = CreateFrame("Frame", nil, UIParent, "GlowBoxTemplate")
	tip:Show()
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
	button:SetScript("OnClick", function(self)
		self:GetParent():Hide()
		plugin:CancelAllTimers()
		plugin:SendMessage("BigWigs_StartConfigureMode", plugin.moduleName)
		BigWigsAPI.OpenConfigToPanel("Auras")
		plugin.db.global.showHelpTip = false
	end)
	ShowHelpTip = nil
end

function plugin:OnPluginEnable()
	previouslyFoundUnit = nil
	self:RegisterMessage("BigWigs_StartConfigureMode")
	self:RegisterMessage("BigWigs_StopConfigureMode")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()
	UpdateSoundOptions()

	self:RegisterEvent("GROUP_ROSTER_UPDATE")

	AddAllAuraSounds()

	if not db.player.disabled and self.db.global.showHelpTip and anchors.player then
		self:CreateTestAura()
		self:ScheduleRepeatingTimer(function() plugin:CreateTestAura() end, 10.2)
		if ShowHelpTip then
			ShowHelpTip()
		end
	end
end

function plugin:OnPluginDisable()
	-- Hide aura icon anchors
	for _, anchor in next, anchors do
		anchor:ClearAllPoints()
		anchor:Hide()
	end
	-- Disable aura icon containers
	for _, auraContainer in next, containers do
		auraContainer:SetEnabled(false)
	end
	-- Remove aura sounds
	RemoveAllAuraSounds()
end

--------------------------------------------------------------------------------
-- Anchors
--

local function UpdateAnchorPosition(anchor)
	local anchorDB = plugin.db.profile[anchor.unitType]

	local scale = anchor:GetScale()
	anchor:ClearAllPoints()

	local relativeTo = anchorDB.anchorRelativeTo
	local point, relPoint = anchorDB.anchorPoint, anchorDB.anchorRelPoint
	local x, y = anchorDB.anchorXOffset, anchorDB.anchorYOffset
	anchor:SetPoint(point, relativeTo, relPoint, x / scale, y / scale)
end

function plugin:UpdateAllAnchors()
	self:UpdateAnchor("player", "player")
	self:UpdateAnchor("other")

	-- reset and force roster update
	previouslyFoundUnit = nil
	self:GROUP_ROSTER_UPDATE()
end

do
	function plugin:GetUnitToken(playerType, playerName)
		if playerType == "tank" then
			for unit in plugin:IterateGroup(true) do
				if not UnitIsUnit("player", unit) and UnitGroupRolesAssigned(unit) == "TANK" then
					return unit
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
			if not db.onlyWhenYouAreTank or (db.onlyWhenYouAreTank and UnitGroupRolesAssigned("player") == "TANK") then
				local token = self:GetUnitToken(db.otherPlayerType, db.otherPlayerName)
				if token ~= previouslyFoundUnit then
					previouslyFoundUnit = token
					self:UpdateAnchor("other", token)
				end
			end
		end
		UpdateRegisteredSounds()
	end

	function plugin:UpdateAnchor(unitType, unitToken)
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

		anchor:ClearAllPoints()
		anchor:Hide()

		local anchorDB = self.db.profile[unitType]
		if anchorDB.disabled then
			return
		end

		anchor:SetSize(anchorDB.width, anchorDB.height)
		anchor:UpdateAnchorPosition()
		anchor:Show()

		UpdateTestAuras(unitType)

		if not unitToken and unitType == "other" then
			if not db.onlyWhenYouAreTank or (db.onlyWhenYouAreTank and UnitGroupRolesAssigned("player") == "TANK") then
				unitToken = self:GetUnitToken(db.otherPlayerType, db.otherPlayerName)
			end
		end
		UpdateAuraContainer(unitType, unitToken, anchors[unitType])
	end
end

--------------------------------------------------------------------------------
-- Container
--

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

	local playerCooldownDurationBinding = C_DurationUtil.CreateDurationTextBinding()
	do
		playerCooldownDurationBinding.breakpoints = {
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
		formatter:SetBreakpoints(playerCooldownDurationBinding.breakpoints)
		playerCooldownDurationBinding:SetFormatter(formatter)
		playerCooldownDurationBinding.formatter = formatter -- there's no 'binding:GetFormatter()'

		local colorCurve = C_CurveUtil.CreateColorCurve()
		colorCurve:SetType(Enum.LuaCurveType.Step)
		playerCooldownDurationBinding:SetTextColorCurve(colorCurve, Enum.DurationTextBindingProperty.RemainingDuration)
	end

	local otherCooldownDurationBinding = C_DurationUtil.CreateDurationTextBinding()
	do
		otherCooldownDurationBinding.breakpoints = {
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
		formatter:SetBreakpoints(otherCooldownDurationBinding.breakpoints)
		otherCooldownDurationBinding:SetFormatter(formatter)
		otherCooldownDurationBinding.formatter = formatter -- there's no 'binding:GetFormatter()'

		local colorCurve = C_CurveUtil.CreateColorCurve()
		colorCurve:SetType(Enum.LuaCurveType.Step)
		otherCooldownDurationBinding:SetTextColorCurve(colorCurve, Enum.DurationTextBindingProperty.RemainingDuration)
	end

	local function BorderGetWidth(border)
		return border.plainWidth
	end

	local function BorderGetHeight(border)
		return border.plainHeight
	end

	function InitializeAuraFrame(unitType, aura, optionsDB)
		optionsDB = optionsDB or aura:GetParent().db

		aura:EnableMouse(optionsDB.showTooltip)
		aura:SetSize(optionsDB.width, optionsDB.height) -- CustomAuraContainerFlowLayoutDescription:ApplyElementLayout doesn't set size

		local icon = aura:CreateTexture(nil, "BACKGROUND")
		icon:SetAllPoints()
		aura:SetIcon(icon)
		aura.icon = icon

		local cooldown = CreateFrame("Cooldown", nil, aura, "CooldownFrameTemplate")
		cooldown:SetAllPoints()
		cooldown:SetReverse(true)
		cooldown:SetDrawEdge(false)
		cooldown:SetDrawBling(false)
		cooldown:SetDrawSwipe(optionsDB.showCooldown)
		cooldown:SetHideCountdownNumbers(true)
		aura.cooldown = cooldown
		aura:SetDurationCooldown(cooldown)

		local duration = cooldown:CreateFontString(nil, "OVERLAY")
		duration:SetPoint("CENTER")
		do
			local flags = {}
			if optionsDB.cooldownTextMonochrome then
				flags[#flags + 1] = "MONOCHROME"
			end
			if optionsDB.cooldownTextOutline ~= "NONE" then
				flags[#flags + 1] = optionsDB.cooldownTextOutline
			end
			if optionsDB.cooldownTextSlug then
				flags[#flags + 1] = "SLUG"
			end
			if #flags > 0 then
				flags = table.concat(flags, ",")
			else
				flags = nil
			end
			duration:SetFont(LibSharedMedia:Fetch(FONT, optionsDB.cooldownTextFontName), optionsDB.cooldownTextFontSize, flags)
		end
		aura.duration = duration

		if unitType == "player" then
			aura.durationBinding = playerCooldownDurationBinding:Copy()
			aura.durationBinding:SetFontString(duration)
			aura.durationBinding.breakpoints = playerCooldownDurationBinding.breakpoints
			aura.durationBinding.formatter = playerCooldownDurationBinding.formatter
		else
			aura.durationBinding = otherCooldownDurationBinding:Copy()
			aura.durationBinding:SetFontString(duration)
			aura.durationBinding.breakpoints = otherCooldownDurationBinding.breakpoints
			aura.durationBinding.formatter = otherCooldownDurationBinding.formatter
		end
		aura.durationOptions = {
			binding = aura.durationBinding
		}

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
		stacks:SetPoint(optionsDB.countTextAnchorPoint, aura, optionsDB.countTextAnchorPoint, optionsDB.countTextAnchorXOffset, optionsDB.countTextAnchorYOffset)
		do
			local flags = {}
			if optionsDB.countTextMonochrome then
				flags[#flags + 1] = "MONOCHROME"
			end
			if optionsDB.countTextOutline ~= "NONE" then
				flags[#flags + 1] = optionsDB.countTextOutline
			end
			if optionsDB.countTextSlug then
				flags[#flags + 1] = "SLUG"
			end
			if #flags > 0 then
				flags = table.concat(flags, ",")
			else
				flags = nil
			end
			stacks:SetFont(LibSharedMedia:Fetch(FONT, optionsDB.countTextFontName), optionsDB.countTextFontSize, flags)
		end
		aura.stacks = stacks
		if optionsDB.showCountText then
			aura:SetApplicationCount(stacks)
		else
			stacks:Hide()
		end

		if unitType == "other" then
			local tankIndicator = overlayFrame:CreateTexture(nil, "OVERLAY")
			tankIndicator:SetPoint("CENTER", aura, "TOP", 0, -3)
			aura.tankIndicator = tankIndicator
		end
	end

	local borderOptions = {
		style = Enum.CustomAuraButtonDispelTypeTextureStyle.PreserveAsset,
		showWhenHarmful = true,
		showWhenHelpful = true,
		showWithoutDispelType = true,
	}

	local dispelIconOptions = {
		style = Enum.CustomAuraButtonDispelTypeTextureStyle.Icon,
	}

	local backdropTextureUVs = { -- ripped from Blizzard_SharedXML/Backdrop.lua
		TopLeftCorner = true,
		TopRightCorner = true,
		BottomLeftCorner = true,
		BottomRightCorner = true,
		TopEdge = true,
		BottomEdge = true,
		LeftEdge = true,
		RightEdge = true,
		-- Center = true, -- not used
	}

	function UpdateAuraFrame(aura, optionsDB)
		aura:SetSize(optionsDB.width, optionsDB.height)

		do
			-- icon aspect ratio and zoom calcs
			local baseZoom = 0.86
			local zoom = baseZoom * (1 - optionsDB.zoom)
			local zoomedOffset = 1 - ((1 - zoom) / 2)
			local offsetX, offsetY = zoomedOffset, zoomedOffset

			local width, height = optionsDB.width, optionsDB.height
			if width > height then
				offsetY = 1 - (1 - (height / width) * zoom) / 2
			elseif height > width then
				offsetX = 1 - (1 - (width / height) * zoom) / 2
			end

			local left, right, top, bottom = 1 - offsetX, offsetX, 1 - offsetY, offsetY
			aura.icon:SetTexCoord(left, right, top, bottom)
		end

		local cooldown = aura:GetDurationCooldown()
		cooldown:SetDrawSwipe(optionsDB.showCooldown)

		local duration = aura.duration
		if optionsDB.showCooldownText then
			local flags = {}
			if optionsDB.cooldownTextMonochrome then
				flags[#flags + 1] = "MONOCHROME"
			end
			if optionsDB.cooldownTextOutline ~= "NONE" then
				flags[#flags + 1] = optionsDB.cooldownTextOutline
			end
			if optionsDB.cooldownTextSlug then
				flags[#flags + 1] = "SLUG"
			end
			if #flags > 0 then
				flags = table.concat(flags, ",")
			else
				flags = nil
			end
			duration:SetFont(LibSharedMedia:Fetch(FONT, optionsDB.cooldownTextFontName), optionsDB.cooldownTextFontSize, flags)

			local textColor = CreateColor(unpack(optionsDB.cooldownTextColor))

			local formatter = aura.durationBinding.formatter
			if optionsDB.cooldownTextDecimals > 0 then
				aura.durationBinding.breakpoints[4].threshold = optionsDB.cooldownTextDecimals - 0.001
				aura.durationBinding.breakpoints[5].threshold = optionsDB.cooldownTextDecimals
				formatter:SetBreakpoints(aura.durationBinding.breakpoints)
			else
				formatter:SetBreakpoints(noDecimalBreakpoints)
			end

			local curve = aura.durationBinding:GetTextColorCurve()
			curve:ClearPoints()

			if optionsDB.cooldownEmphasizeTime > 0 then
				local emphasizedColor = CreateColor(unpack(optionsDB.cooldownEmphasizeColor))
				curve:AddPoint(0.1, emphasizedColor)
				curve:AddPoint(optionsDB.cooldownEmphasizeTime - 0.1, emphasizedColor)
				curve:AddPoint(optionsDB.cooldownEmphasizeTime, textColor)
			else
				curve:AddPoint(0, textColor)
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
			aura.border:SetBackdrop({
				edgeFile = LibSharedMedia:Fetch("border", optionsDB.borderName),
				edgeSize = optionsDB.borderSize,
			})

			if optionsDB.borderDispelColor then
				for pieceName in pairs(backdropTextureUVs) do -- logic copied from Blizzard_SharedXML/Backdrop.lua
					local borderRegion = aura.border[pieceName]
					if borderRegion then
						aura:AddDispelTypeTexture(borderRegion, borderOptions)
					end
				end
			else
				local color = optionsDB.borderColor
				aura.border:SetBackdropBorderColor(color[1], color[2], color[3], color[4])
			end
		else
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
		stacks:ClearAllPoints()
		stacks:SetPoint(optionsDB.countTextAnchorPoint, aura, optionsDB.countTextAnchorPoint, optionsDB.countTextAnchorXOffset, optionsDB.countTextAnchorYOffset)
		do
			local flags = {}
			if optionsDB.countTextMonochrome then
				flags[#flags + 1] = "MONOCHROME"
			end
			if optionsDB.countTextOutline ~= "NONE" then
				flags[#flags + 1] = optionsDB.countTextOutline
			end
			if optionsDB.countTextSlug then
				flags[#flags + 1] = "SLUG"
			end
			if #flags > 0 then
				flags = table.concat(flags, ",")
			else
				flags = nil
			end
			stacks:SetFont(LibSharedMedia:Fetch(FONT, optionsDB.countTextFontName), optionsDB.countTextFontSize, flags)

			local textColor = optionsDB.countTextColor
			stacks:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
		end
		if optionsDB.showCountText then
			aura:SetApplicationCount(stacks)
		else
			stacks:Hide()
			aura:ClearApplicationCount()
		end

		if aura.tankIndicator then
			local size = optionsDB.height / 3
			aura.tankIndicator:SetShown(db.tankIndicator)
			aura.tankIndicator:SetSize(size, size)
			aura.tankIndicator:SetAtlas(size > 36 and "icons_64x64_tank" or "icons_16x16_tank")
		end
	end

	local FlowDirection = AnchorUtil.FlowDirection
	local FlowLayoutAxis = AnchorUtil.FlowLayoutAxis
	function UpdateAuraContainer(unitType, unitToken, parent)
		local optionsDB = db[unitType]

		local auraContainer = containers[unitType]
		if not auraContainer then
			auraContainer = CreateFrame("AuraContainer", "BigWigsAuraContainer"..(unitType:gsub("^%l", string.upper)), parent, "CustomAuraContainerTemplate")
			auraContainer.db = optionsDB

			auraContainer:AddAuraGroup("debuffs", "HARMFUL", {
				maxFrameCount = optionsDB.maxIcons,
				initializeFrame = GenerateClosure(InitializeAuraFrame, unitType),
				sortMethod = 4, -- Enum.UnitAuraSortRule.ExpirationOnly
				sortDirection = 0, -- Enum.UnitAuraSortDirection.Normal
				layout = {
					elementSpacing = optionsDB.spacing,
					elementWidth = optionsDB.width,
					elementHeight = optionsDB.height,
				},
			})

			containers[unitType] = auraContainer
		end

		-- These won't trigger an container update, so update them first
		for index = 1, auraContainer:GetAuraGroupFrameCount("debuffs") do
			local aura = auraContainer:GetAuraGroupFrame("debuffs", index)
			if aura:CanBeAccessedInContext() then
				UpdateAuraFrame(aura, optionsDB)
			end
		end

		auraContainer:SetEnabled(not optionsDB.disabled and unitToken ~= nil)

		if unitToken then
			auraContainer:SetUnit(unitToken)
		end

		auraContainer:ClearAllPoints()
		local axis, point, x, y
		if optionsDB.growthDirection == "RIGHT" or optionsDB.growthDirection == "CENTER_HORIZONTAL" then
			axis = FlowLayoutAxis.Horizontal
			point, x, y = "LEFT", FlowDirection.Right, FlowDirection.Down
		elseif optionsDB.growthDirection == "LEFT" then
			axis = FlowLayoutAxis.Horizontal
			point, x, y = "RIGHT", FlowDirection.Left, FlowDirection.Down
		elseif optionsDB.growthDirection == "UP" or optionsDB.growthDirection == "CENTER_VERTICAL" then
			axis = FlowLayoutAxis.Vertical
			point, x, y = "BOTTOM", FlowDirection.Right, FlowDirection.Up
		elseif optionsDB.growthDirection == "DOWN" then
			axis = FlowLayoutAxis.Vertical
			point, x, y = "TOP", FlowDirection.Right, FlowDirection.Down
		end
		auraContainer:SetFlowLayoutAxis(axis)
		auraContainer:SetFlowLayoutAnchorPoint(point)
		auraContainer:SetFlowLayoutGrowthDirection(x, y)

		if optionsDB.growthDirection == "CENTER_HORIZONTAL" or optionsDB.growthDirection == "CENTER_VERTICAL" then
			auraContainer:SetPoint("CENTER")
		else
			auraContainer:SetPoint(point)
		end

		auraContainer:SetAuraGroupMaxFrameCount("debuffs", optionsDB.maxIcons)
		auraContainer:SetAuraGroupCandidateFilters("debuffs", {
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
			}
		})
		auraContainer:SetAuraGroupLayout("debuffs", {
			elementSpacing = optionsDB.spacing,
			elementWidth = optionsDB.width,
			elementHeight = optionsDB.height,
		})
	end
end

--------------------------------------------------------------------------------
-- Test Auras
--

do
	local dispelTypeList = { "Magic", "Curse", "Disease", "Poison", "Enrage", "Bleed", "None" }
	local privateAuraSpellList = { 407221, 418720, 421828, 428970, 406317 }

	local methods = { -- pretty annoying
		GetApplicationBar = false,
		SetApplicationBar = false,
		ClearApplicationBar = false,
		GetApplicationCount = false,
		SetApplicationCount = function(self, fontString) fontString:Show() end,
		ClearApplicationCount = false,
		GetDispelTypeTextureCount = false,
		GetDispelTypeTexture = false,
		AddDispelTypeTexture = function(self, region, options)
			-- replicate ApplyDispelTypeTextureStyle from Blizzard_CustomAuraButton.lua
			if options.style == Enum.CustomAuraButtonDispelTypeTextureStyle.Icon then
				if self.dispelType ~= "None" and self.dispelType ~= "Enrage" then -- no icons for these
					AuraUtil.SetAuraDispelTypeIcon(region, self.dispelType)
					region:SetVertexColor(1, 1, 1, 1)
				else
					region:SetTexture(nil)
				end
			elseif options.style == Enum.CustomAuraButtonDispelTypeTextureStyle.PreserveAsset then
				AuraUtil.SetAuraBorderColor(region, self.dispelType)
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
		SetDurationText = false,
		ClearDurationText = false,
		GetDurationBar = false,
		SetDurationBar = false,
		ClearDurationBar = false,
		GetIcon = false,
		SetIcon = false,
		ClearIcon = false,
		GetSpellName = false,
		etSpellName = false,
		ClearSpellName = false,
		GetAuraBorder = false,
		SetAuraBorder = false,
		ClearAuraBorder = false,
	}
	local noop = function() end

	local finishTestAura
	local function createTestAura(unitType)
		local aura = CreateFrame("Frame", nil, anchors[unitType])
		aura:SetFrameStrata("MEDIUM")
		aura:SetFixedFrameStrata(true)
		aura:SetFrameLevel(1000)
		aura:SetFixedFrameLevel(true)
		aura:Hide()

		for name, func in next, methods do
			aura[name] = func or noop
		end

		InitializeAuraFrame(unitType, aura, db[unitType])
		aura.cooldown:SetScript("OnCooldownDone", GenerateClosure(finishTestAura, aura))

		return aura
	end

	local function resetTestAura(_, aura)
		aura:ClearAllPoints()
		aura:Hide()
		aura.cooldown:Clear()
		aura.durationBinding:SetEnabled(false)
	end

	local pools = {
		player = CreateUnsecuredObjectPool(GenerateClosure(createTestAura, "player"), resetTestAura),
		other = CreateUnsecuredObjectPool(GenerateClosure(createTestAura, "other"), resetTestAura),
	}

	function finishTestAura(aura)
		pools[aura.unitType]:Release(aura)
		UpdateTestAuras(aura.unitType)
	end

	local function activateTestAura(unitType, index)
		local pool = pools[unitType]
		local aura = pool:Acquire()

		-- Setup test aura info
		local spellId = privateAuraSpellList[math.random(#privateAuraSpellList)]
		local dispelType = dispelTypeList[math.random(#dispelTypeList)]

		local icon = C_Spell.GetSpellTexture(spellId)
		local applications = math.random(0, 5)

		local duration = C_DurationUtil.CreateDuration()
		duration:SetTimeFromStart(GetTime(), CONFIG_MODE_DURATION)

		aura.icon:SetTexture(icon)
		aura.cooldown:SetCooldownFromDurationObject(duration)
		aura.durationBinding:SetDuration(duration)
		aura.durationBinding:SetEnabled(true)
		aura.stacks:SetText(applications > 1 and applications or "")
		aura.dispelType = dispelType
		aura.unitType = unitType

		-- aura:SetAuraInstance("player", {
		-- 	applications = 0,
		-- 	auraInstanceID = spellIndex,
		-- 	dispelName = dispelType,
		-- 	duration = CONFIG_MODE_DURATION,
		-- 	expirationTime = GetTime() + CONFIG_MODE_DURATION,
		-- 	icon = C_Spell.GetSpellTexture(spellId),
		-- 	isBossAura = true,
		-- 	isHarmful = true,
		-- 	name = C_Spell.GetSpellName(spellId),
		-- 	spellId = spellId,
		-- })

		aura:Show()
	end

	function UpdateTestAuras(unitType)
		local anchor = anchors[unitType]
		local pool = pools[unitType]
		local numActive = pool:GetNumActive()
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
				local aura = pool:GetNextActive(lastAura)
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
		if inConfigureMode then
			plugin:BigWigs_StartConfigureMode(nil, plugin.moduleName)
		end
	end

	function plugin:CreateTestAura()
		for unitType in next, anchors do
			if not db[unitType].disabled then
				if pools[unitType]:GetNumActive() < db[unitType].maxIcons then
					activateTestAura(unitType)
					UpdateTestAuras(unitType)
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Aura Sounds
--

do
	local auraSounds = {}
	local registeredUnits = {}
	local soundsNeedingUpdated = {}

	local frame = CreateFrame("Frame")
	frame:SetScript("OnEvent", function(self, event, restrictionType, state)
		if state ~= 0 then return end -- Enum.AddOnRestrictionState.Inactive

		for index, soundRestrictionType in next, soundsNeedingUpdated do
			if soundRestrictionType == restrictionType then
				soundsNeedingUpdated[index] = nil
				AddAuraSound(index)
			end
		end
		if not next(soundsNeedingUpdated) then
			self:UnregisterEvent(event)
		end
	end)

	local IsAddOnRestrictionActive = C_RestrictedActions.IsAddOnRestrictionActive
	local function getAddOnRestriction()
		if IsAddOnRestrictionActive then
			if IsAddOnRestrictionActive(1) then -- Encounter
				return 1
			elseif IsAddOnRestrictionActive(2) and IsAddOnRestrictionActive(0) then -- ChallengeMode and Combat
				return 0
			end
		end
	end

	function UpdateRegisteredSounds()
		for index, unit in next, registeredUnits do
			local auraDB = db.sounds[index]
			local checkUnit = plugin:GetUnitToken(auraDB.unit, auraDB.playerName)
			if unit ~= checkUnit then
				AddAuraSound(index)
			end
		end
	end

	function AddAuraSound(index)
		local restrictionType = getAddOnRestriction()
		if restrictionType ~= nil then
			soundsNeedingUpdated[index] = restrictionType
			frame:RegisterEvent("ADDON_RESTRICTION_STATE_CHANGED")
			return
		end

		RemoveAuraSound(index)

		local info = db.sounds[index]
		if not info or not info.enabled then return end

		local unit = info.unit
		local trigger = info.trigger
		local duration = tonumber(info.duration)

		if unit == "tank" then
			unit = plugin:GetUnitToken("tank")
		elseif unit == "name" then
			unit = plugin:GetUnitToken("name", info.playerName)
		end

		local soundFile
		if trigger < 3 then
			soundFile = LibSharedMedia:Fetch("sound", info.sound, true)
		elseif duration and duration > 0 and duration <= 30 and info.voice then -- countdown
			trigger = 0
			local path = [[Interface\AddOns\BigWigs\Media\Sounds\AuraCountdowns\%s\%s_Countdown%d.ogg]]
			soundFile = path:format(info.voice, info.voice, duration)
		end
		if unit and soundFile then
			local auraSoundID = C_UnitAuras.AddAuraSound(trigger, {
				unitToken = unit,
				spellID = info.spellID,
				soundFileName = type(soundFile) == "string" and soundFile or nil,
				soundFileID = type(soundFile) == "number" and soundFile or nil,
				outputChannel = "master",
			})
			if auraSoundID and (info.unit == "tank" or info.unit == "name") then
				registeredUnits[index] = unit
			end
			auraSounds[index] = auraSoundID
			return auraSoundID
		end
	end

	function RemoveAuraSound(index, remove)
		local auraSoundID = auraSounds[index]
		if auraSoundID then
			C_UnitAuras.RemoveAuraSound(auraSoundID)
			auraSounds[index] = nil
			registeredUnits[index] = nil
		end
		if remove then
			table.remove(db.sounds, index)
			table.remove(auraSounds, index)
			table.remove(registeredUnits, index)
		end
	end

	function AddAllAuraSounds()
		for index = 1, #db.sounds do
			AddAuraSound(index)
		end
	end

	function RemoveAllAuraSounds()
		for index = 1, #db.sounds do
			RemoveAuraSound(index)
		end
	end
end
