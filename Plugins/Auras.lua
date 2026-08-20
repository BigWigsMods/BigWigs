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

local CONFIG_MODE_DURATION = 10

local db
local containers = {}
local anchors = { player = {}, other = {} }
local inConfigureMode = false
local previouslyFoundUnit = nil

local InitializeAuraFrame, UpdateAuraFrame, UpdateTestAura
local UpdateAuraContainer
local UpdateSoundOptions, UpdateRegisteredSounds
local AddAuraSound, RemoveAuraSound, AddAllAuraSounds, RemoveAllAuraSounds

--------------------------------------------------------------------------------
-- Profile
--

plugin.defaultDB = {
	player = {
		disabled = false,

		size = 64,
		spacing = 6,
		showCooldown = true,
		showTooltip = true,

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

		showCooldownText = true,
		cooldownTextFontName = "Noto Sans Medium", -- Only dealing with numbers so we can use this on all locales
		cooldownTextFontSize = 16,
		cooldownTextOutline = "OUTLINE",
		cooldownTextMonochrome = false,
		cooldownTextSlug = true,
		cooldownTextMillisecondsThreshold = 3,
		cooldownTextColor = {1, 1, 1, 1},

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
	},
	other = {
		disabled = true,

		size = 64,
		spacing = 6,
		showCooldown = true,
		showTooltip = true,

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

		showCooldownText = true,
		cooldownTextFontName = "Noto Sans Medium",
		cooldownTextFontSize = 16,
		cooldownTextOutline = "OUTLINE",
		cooldownTextMonochrome = false,
		cooldownTextSlug = true,
		cooldownTextMillisecondsThreshold = 3,
		cooldownTextColor = {1, 1, 1, 1},

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
		anchorYOffset = 120,
		anchorRelativeTo = "UIParent",
	},
	otherPlayerType = "tank",
	onlyWhenYouAreTank = false,
	otherPlayerName = "",

	sounds = {},
}
plugin.defaultGlobalDB = {
	showHelpTip = true,
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

local function MergeTable(dst, src)
	for k, v in pairs(src) do
		dst[k] = v
	end
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

	if db.player.size < 24 or db.player.size > 256 then
		db.player.size = plugin.defaultDB.player.size
	end
	if db.other.size < 24 or db.other.size > 256 then
		db.other.size = plugin.defaultDB.other.size
	end

	if db.player.spacing < 0 or db.player.spacing > 50 then
		db.player.spacing = plugin.defaultDB.player.spacing
	end
	if db.other.spacing < 0 or db.other.spacing > 50 then
		db.other.spacing = plugin.defaultDB.other.spacing
	end

	if db.player.cooldownTextFontSize < 8 or db.player.cooldownTextFontSize > 200 then
		db.player.cooldownTextFontSize = plugin.defaultDB.player.cooldownTextFontSize
	end
	if db.other.cooldownTextFontSize < 8 or db.other.cooldownTextFontSize > 200 then
		db.other.cooldownTextFontSize = plugin.defaultDB.other.cooldownTextFontSize
	end
	ValidateColor(db.other.cooldownTextColor, plugin.defaultDB.other.cooldownTextColor, 0)
	ValidateColor(db.player.cooldownTextColor, plugin.defaultDB.player.cooldownTextColor, 0)

	if db.player.countTextFontSize < 8 or db.player.countTextFontSize > 200 then
		db.player.countTextFontSize = plugin.defaultDB.player.countTextFontSize
	end
	if db.other.countTextFontSize < 8 or db.other.countTextFontSize > 200 then
		db.other.countTextFontSize = plugin.defaultDB.other.countTextFontSize
	end
	ValidateColor(db.other.countTextColor, plugin.defaultDB.other.countTextColor, 0)
	ValidateColor(db.player.countTextColor, plugin.defaultDB.player.countTextColor, 0)

	if db.player.borderSize < 1 or db.player.borderSize > 32 then
		db.player.borderSize = plugin.defaultDB.player.borderSize
	end
	if db.player.borderOffset < 0 or db.player.borderOffset > 32 then
		db.player.borderOffset = plugin.defaultDB.player.borderOffset
	end

	if db.other.borderSize < 1 or db.other.borderSize > 32 then
		db.other.borderSize = plugin.defaultDB.other.borderSize
	end
	if db.other.borderOffset < 0 or db.other.borderOffset > 32 then
		db.other.borderOffset = plugin.defaultDB.other.borderOffset
	end

	-- Validate player anchors
	do
		if not BigWigsAPI.IsValidFramePoint(db.player.anchorPoint) or not BigWigsAPI.IsValidFramePoint(db.player.anchorRelPoint) then
			db.player.anchorPoint = plugin.defaultDB.player.anchorPoint
			db.player.anchorRelPoint = plugin.defaultDB.player.anchorRelPoint
			db.player.anchorXOffset = plugin.defaultDB.player.anchorXOffset
			db.player.anchorYOffset = plugin.defaultDB.player.anchorYOffset
			db.player.anchorRelativeTo = plugin.defaultDB.player.anchorRelativeTo
		end

		local x = math.floor(db.player.anchorXOffset+0.5)
		if x ~= db.player.anchorXOffset then
			db.player.anchorXOffset = x
		end
		local y = math.floor(db.player.anchorYOffset+0.5)
		if y ~= db.player.anchorYOffset then
			db.player.anchorYOffset = y
		end

		if db.player.anchorRelativeTo ~= plugin.defaultDB.player.anchorRelativeTo then
			local frame = _G[db.player.anchorRelativeTo]
			if type(frame) ~= "table" or type(frame.GetObjectType) ~= "function" or type(frame.IsForbidden) ~= "function" or frame:IsForbidden() then
				db.player.anchorPoint = plugin.defaultDB.player.anchorPoint
				db.player.anchorRelPoint = plugin.defaultDB.player.anchorRelPoint
				db.player.anchorXOffset = plugin.defaultDB.player.anchorXOffset
				db.player.anchorYOffset = plugin.defaultDB.player.anchorYOffset
				db.player.anchorRelativeTo = plugin.defaultDB.player.anchorRelativeTo
			end
		end
	end

	-- Validate other anchors
	do
		if not BigWigsAPI.IsValidFramePoint(db.other.anchorPoint) or not BigWigsAPI.IsValidFramePoint(db.other.anchorRelPoint) then
			db.other.anchorPoint = plugin.defaultDB.other.anchorPoint
			db.other.anchorRelPoint = plugin.defaultDB.other.anchorRelPoint
			db.other.anchorXOffset = plugin.defaultDB.other.anchorXOffset
			db.other.anchorYOffset = plugin.defaultDB.other.anchorYOffset
			db.other.anchorRelativeTo = plugin.defaultDB.other.anchorRelativeTo
		end
		local x = math.floor(db.other.anchorXOffset+0.5)
		if x ~= db.other.anchorXOffset then
			db.other.anchorXOffset = x
		end
		local y = math.floor(db.other.anchorYOffset+0.5)
		if y ~= db.other.anchorYOffset then
			db.other.anchorYOffset = y
		end

		if db.other.anchorRelativeTo ~= plugin.defaultDB.other.anchorRelativeTo then
			local frame = _G[db.other.anchorRelativeTo]
			if type(frame) ~= "table" or type(frame.GetObjectType) ~= "function" or type(frame.IsForbidden) ~= "function" or frame:IsForbidden() then
				db.other.anchorPoint = plugin.defaultDB.other.anchorPoint
				db.other.anchorRelPoint = plugin.defaultDB.other.anchorRelPoint
				db.other.anchorXOffset = plugin.defaultDB.other.anchorXOffset
				db.other.anchorYOffset = plugin.defaultDB.other.anchorYOffset
				db.other.anchorRelativeTo = plugin.defaultDB.other.anchorRelativeTo
			end
		end
	end

	if db.player.maxIcons < 1 or db.player.maxIcons > 5 then
		db.player.maxIcons = plugin.defaultDB.player.maxIcons
	else
		local numPlayer = math.floor(db.player.maxIcons+0.5)
		if numPlayer ~= db.player.maxIcons then
			db.player.maxIcons = numPlayer
		end
	end

	if db.other.maxIcons < 1 or db.other.maxIcons > 5 then
		db.other.maxIcons = plugin.defaultDB.other.maxIcons
	else
		local numOther = math.floor(db.other.maxIcons+0.5)
		if numOther ~= db.other.maxIcons then
			db.other.maxIcons = numOther
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

local function reset(section)
	MergeTable(plugin.db.profile[section], plugin.defaultDB[section])
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
	end
	local function IsAurasOnYouDisabledOrAnchorPointIsDefault()
		return db.player.disabled or db.player.anchorRelativeTo == plugin.defaultDB.player.anchorRelativeTo
	end
	local function IsAurasOnOthersDisabledOrAnchorPointIsDefault()
		return db.other.disabled or db.other.anchorRelativeTo == plugin.defaultDB.other.anchorRelativeTo
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
						dialogControl = "SharedDropdown",
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
				get = function(info)
					return db.player[info[#info]]
				end,
				set = function(info, value)
					db.player[info[#info]] = value
					updateProfile()
				end,
				order = 4,
				args = {
					aurasOnYouDesc = {
						type = "description",
						name = L.aurasDesc,
						order = 1,
						width = "full",
						fontSize = "medium",
					},
					disabled = {
						type = "toggle",
						name = L.disabled,
						width = 1.6,
						order = 2,
					},
					emptyspace = {
						type = "description",
						name = "",
						order = 3,
					},
					size = {
						type = "range",
						name = L.iconSize,
						min = 24, max = 256, step = 1,
						width = 1.6,
						order = 4,
						disabled = IsAnchorDisabled,
					},
					spacing = {
						type = "range",
						name = L.iconSpacing,
						min = 0, max = 50, step = 1,
						width = 1.6,
						order = 5,
						disabled = IsAnchorDisabled,
					},
					growthDirection = {
						type = "select",
						name = L.growthDirection,
						values = {
							LEFT = L.LEFT,
							RIGHT = L.RIGHT,
							UP = L.UP,
							DOWN = L.DOWN,
						},
						width = 1.6,
						order = 6,
						disabled = IsAnchorDisabled,
					},
					maxIcons = {
						type = "range",
						name = L.maxIcons,
						desc = L.maxIconsDesc,
						min = 1, max = 5, step = 1,
						width = 1.6,
						order = 7,
						disabled = IsAnchorDisabled,
					},
					showTooltip = {
						type = "toggle",
						name = L.iconTooltip,
						desc = L.iconTooltipDesc,
						order = 8,
						disabled = IsAnchorDisabled,
					},
					showCooldown = {
						type = "toggle",
						name = L.showCooldown,
						desc = L.showCooldownSwipeDesc,
						width = 1.6,
						order = 9,
						disabled = IsAnchorDisabled,
					},
					cooldownText = {
						type = "group",
						inline = true,
						name = L.cooldownText,
						disabled = function(info) return db.player.disabled or not db.player.showCooldownText end,
						order = 10,
						args = {
							showCooldownText = {
								type = "toggle",
								name = L.showCooldownText,
								disabled = function(info) return db.player.disabled end,
								order = 1,
							},
							cooldownTextFontName = {
								type = "select",
								name = L.font,
								values = LibSharedMedia:List(FONT),
								itemControl = "DDI-Font",
								get = function()
									for i, v in next, LibSharedMedia:List(FONT) do
										if v == db.player.cooldownTextFontName then return i end
									end
								end,
								set = function(_, value)
									local list = LibSharedMedia:List(FONT)
									db.player.cooldownTextFontName = list[value]
									updateProfile()
								end,
								order = 2,
							},
							cooldownTextFontSize = {
								type = "range",
								name = L.fontSize,
								desc = L.fontSizeDesc,
								softMax = 100, max = 200, min = 8, step = 1,
								order = 3,
							},
							cooldownTextOutline = {
								type = "select",
								name = L.outline,
								values = {
									NONE = L.none,
									OUTLINE = L.thin,
									THICKOUTLINE = L.thick,
								},
								order = 4,
							},
							cooldownTextMonochrome = {
								type = "toggle",
								name = L.monochrome,
								desc = L.monochromeDesc,
								order = 5,
							},
							cooldownTextSlug = {
								type = "toggle",
								name = L.slugRendering,
								desc = L.slugRenderingDesc,
								order = 6,
							},
							cooldownTextColor = {
								type = "color",
								name = L.fontColor,
								order = 7,
								get = function(info)
									local colorTable = db.player.cooldownTextColor
									return colorTable[1], colorTable[2], colorTable[3], colorTable[4]
								end,
								set = function(_, r, g, b, a)
									db.player.cooldownTextColor = {r, g, b, a}
									updateProfile()
								end,
								hasAlpha = true,
							},
						},
					},
					dispelTypeOptions = {
						type = "group",
						inline = true,
						name = L.dispelType,
						order = 11,
						disabled = function(info) return db.player.disabled or not db.player.showDispelType end,
						args = {
							showDispelType = {
								type = "toggle",
								name = L.showDispelType,
								desc = L.showDispelTypeDesc,
								order = 1,
								width = 1.2,
								disabled = function(info) return db.player.disabled end,
							},
							dispelTypeSize = {
								type = "range",
								name = L.iconSize,
								order = 2,
								min = 1,
								max = 64,
								step = 1,
							},
							dispelTypeAnchorPoint = {
								type = "select",
								name = L.position,
								values = BigWigsAPI.GetFramePointList(),
								order = 3,
							},
							dispelTypeAnchorXOffset = {
								type = "range",
								name = L.offsetX,
								min = -100, max = 100, step = 1,
								order = 4,
							},
							dispelTypeAnchorYOffset = {
								type = "range",
								name = L.offsetY,
								min = -100, max = 100, step = 1,
								order = 5,
							},
						},
					},
					borderOptions = {
						type = "group",
						inline = true,
						name = L.border,
						order = 12,
						disabled = function(info)
							return db.player.disabled or db.player.borderName == "None"
						end,
						args = {
							borderName = {
								type = "select",
								name = L.borderName,
								order = 1,
								values = LibSharedMedia:List("border"),
								get = function()
									for i, v in next, LibSharedMedia:List("border") do
										if v == db.player.borderName then return i end
									end
								end,
								set = function(_, value)
									local list = LibSharedMedia:List("border")
									db.player.borderName = list[value]
									updateProfile()
								end,
								width = 1,
								disabled = function(info) return db.player.disabled end,
							},
							borderSize = {
								type = "range",
								name = L.borderSize,
								order = 2,
								min = 1,
								max = 32,
								step = 1,
							},
							borderOffset = {
								type = "range",
								name = L.borderOffset,
								order = 3,
								min = 0,
								max = 32,
								step = 1,
							},
						},
					},
					countText = {
						type = "group",
						inline = true,
						name = L.countText,
						order = 13,
						disabled = function(info) return db.player.disabled or not db.player.showCountText end,
						args = {
							showCountText = {
								type = "toggle",
								name = L.showCountText,
								disabled = function(info) return db.player.disabled end,
								order = 1,
							},
							countTextFontName = {
								type = "select",
								name = L.font,
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
								order = 2,
							},
							countTextFontSize = {
								type = "range",
								name = L.fontSize,
								desc = L.fontSizeDesc,
								min = 8, max = 200, softMax = 100, step = 1,
								order = 3,
							},
							countTextOutline = {
								type = "select",
								name = L.outline,
								values = {
									NONE = L.none,
									OUTLINE = L.thin,
									THICKOUTLINE = L.thick,
								},
								order = 4,
							},
							countTextMonochrome = {
								type = "toggle",
								name = L.monochrome,
								desc = L.monochromeDesc,
								order = 5,
							},
							countTextSlug = {
								type = "toggle",
								name = L.slugRendering,
								desc = L.slugRenderingDesc,
								order = 6,
							},
							countTextAnchorPoint = {
								type = "select",
								name = L.position,
								values = BigWigsAPI.GetFramePointList(),
								order = 10,
							},
							countTextAnchorXOffset = {
								type = "range",
								name = L.offsetX,
								min = -100, max = 100, step = 1,
								order = 11,
							},
							countTextAnchorYOffset = {
								type = "range",
								name = L.offsetY,
								min = -100, max = 100, step = 1,
								order = 12,
							},
							countTextColor = {
								type = "color",
								name = L.fontColor,
								order = 13,
								get = function(info)
									local colorTable = db.player.countTextColor
									return colorTable[1], colorTable[2], colorTable[3], colorTable[4]
								end,
								set = function(_, r, g, b, a)
									db.player.countTextColor  = {r, g, b, a}
									updateProfile()
								end,
								hasAlpha = true,
							},
						},
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
						func = function()
							reset("player")
							updateProfile()
						end,
						order = 101,
					},
				},
			},
			other = {
				type = "group",
				name = L.bossDebuffsOnTank,
				get = function(info)
					return db.other[info[#info]]
				end,
				set = function(info, value)
					db.other[info[#info]] = value
					updateProfile()
				end,
				order = 5,
				args = {
					aurasOnAnotherDesc = {
						type = "description",
						name = L.aurasOnAnotherDesc,
						order = 1,
						width = "full",
						fontSize = "medium",
					},
					disabled = {
						type = "toggle",
						name = L.disabled,
						set = function(_, value)
							db.other.disabled = value
							updateProfile()
						end,
						width = 1.6,
						order = 2,
					},
					emptyspace = {
						type = "description",
						name = "",
						order = 3,
					},
					otherPlayerType = {
						type = "select",
						name = L.chooseAPlayer,
						values = {
							tank = L.theOtherTank,
							player = L.playerInYourGroup,
						},
						get = function() return db.otherPlayerType end,
						set = function(_, value)
							db.otherPlayerType = value
							db.otherPlayerName = ""
							plugin:UpdateAnchors("other")
						end,
						disabled = IsAnchorDisabled,
						width = 1.3,
						order = 4,
					},
					smallseparator = {
						type = "description",
						name = "",
						width = 0.1,
						order = 5,
					},
					otherPlayerName = {
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
						get = function() return db.otherPlayerName end,
						set = function(_, value)
							db.otherPlayerName = value
							plugin:UpdateAnchors("other")
						end,
						hidden = function()
							return db.otherPlayerType == "tank"
						end,
						disabled = IsAnchorDisabled,
						width = 1.6,
						order = 6,
					},
					otherPlayerIsTankLabel = {
						type = "description",
						name = function()
							return L.theOtherTankDesc:format(FindTank("tank") or L.none)
						end,
						hidden = function()
							return db.otherPlayerType == "player"
						end,
						disabled = IsAnchorDisabled,
						width = 1.6,
						order = 7,
					},
					onlyWhenYouAreTank = {
						type = "toggle",
						name = L.onlyWhenYouAreTank,
						get = function() return db.onlyWhenYouAreTank end,
						set = function(_, value)
							db.onlyWhenYouAreTank = value
							updateProfile()
						end,
						hidden = function()
							return db.otherPlayerType == "player"
						end,
						disabled = IsAnchorDisabled,
						width = "full",
						order = 8,
					},
					emptylines = {
						type = "description",
						name = "\n\n",
						order = 9,
					},
					size = {
						type = "range",
						name = L.iconSize,
						min = 24, max = 256, step = 1,
						width = 1.6,
						order = 10,
						disabled = IsAnchorDisabled,
					},
					spacing = {
						type = "range",
						name = L.iconSpacing,
						min = 0, max = 50, step = 1,
						width = 1.6,
						order = 11,
						disabled = IsAnchorDisabled,
					},
					growthDirection = {
						type = "select",
						name = L.growthDirection,
						values = {
							LEFT = L.LEFT,
							RIGHT = L.RIGHT,
							UP = L.UP,
							DOWN = L.DOWN,
						},
						width = 1.6,
						order = 12,
						disabled = IsAnchorDisabled,
					},
					maxIcons = {
						type = "range",
						name = L.maxIcons,
						desc = L.maxIconsDesc,
						min = 1, max = 5, step = 1,
						width = 1.6,
						order = 13,
						disabled = IsAnchorDisabled,
					},
					showCooldown = {
						type = "toggle",
						name = L.showCooldown,
						desc = L.showCooldownSwipeDesc,
						width = 1.6,
						order = 14,
						disabled = IsAnchorDisabled,
					},
					showTooltip = {
						type = "toggle",
						name = L.iconTooltip,
						desc = L.iconTooltipDesc,
						order = 15,
						disabled = IsAnchorDisabled,
					},
					cooldownText = {
						type = "group",
						inline = true,
						name = L.cooldownText,
						order = 16,
						disabled = function(info) return db.other.disabled or not db.other.showCooldownText end,
						args = {
							showCooldownText = {
								type = "toggle",
								name = L.showCooldownText,
								disabled = function(info) return db.other.disabled end,
								order = 1,
							},
							cooldownTextFontName = {
								type = "select",
								name = L.font,
								values = LibSharedMedia:List(FONT),
								itemControl = "DDI-Font",
								get = function()
									for i, v in next, LibSharedMedia:List(FONT) do
										if v == db.other.cooldownTextFontName then return i end
									end
								end,
								set = function(_, value)
									local list = LibSharedMedia:List(FONT)
									db.other.cooldownTextFontName = list[value]
									updateProfile()
								end,
								order = 2,
							},
							cooldownTextFontSize = {
								type = "range",
								name = L.fontSize,
								desc = L.fontSizeDesc,
								softMax = 100, max = 200, min = 8, step = 1,
								order = 3,
							},
							cooldownTextOutline = {
								type = "select",
								name = L.outline,
								values = {
									NONE = L.none,
									OUTLINE = L.thin,
									THICKOUTLINE = L.thick,
								},
								order = 4,
							},
							cooldownTextMonochrome = {
								type = "toggle",
								name = L.monochrome,
								desc = L.monochromeDesc,
								order = 5,
							},
							cooldownTextSlug = {
								type = "toggle",
								name = L.slugRendering,
								desc = L.slugRenderingDesc,
								order = 6,
							},
							cooldownTextColor = {
								type = "color",
								name = L.fontColor,
								order = 7,
								get = function(info)
									local colorTable = db.other.cooldownTextColor
									return colorTable[1], colorTable[2], colorTable[3], colorTable[4]
								end,
								set = function(_, r, g, b, a)
									db.other.cooldownTextColor = {r, g, b, a}
									updateProfile()
								end,
								hasAlpha = true,
							},
						},
					},
					dispelTypeOptions = {
						type = "group",
						inline = true,
						name = L.dispelType,
						order = 17,
						disabled = function(info) return db.other.disabled or not db.other.showDispelType end,
						args = {
							showDispelType = {
								type = "toggle",
								name = L.showDispelType,
								desc = L.showDispelTypeDesc,
								order = 1,
								width = 1.2,
								disabled = function(info) return db.other.disabled end,
							},
							dispelTypeSize = {
								type = "range",
								name = L.iconSize,
								order = 2,
								min = 1,
								max = 64,
								step = 1,
							},
							dispelTypeAnchorPoint = {
								type = "select",
								name = L.position,
								values = BigWigsAPI.GetFramePointList(),
								order = 3,
							},
							dispelTypeAnchorXOffset = {
								type = "range",
								name = L.offsetX,
								min = -100, max = 100, step = 1,
								order = 4,
							},
							dispelTypeAnchorYOffset = {
								type = "range",
								name = L.offsetY,
								min = -100, max = 100, step = 1,
								order = 5,
							},
						},
					},
					borderOptions = {
						type = "group",
						inline = true,
						name = L.border,
						order = 18,
						disabled = function(info)
							return db.other.disabled or db.other.borderName == "None"
						end,
						args = {
							borderName = {
								type = "select",
								name = L.borderName,
								order = 1,
								values = LibSharedMedia:List("border"),
								get = function()
									for i, v in next, LibSharedMedia:List("border") do
										if v == db.other.borderName then return i end
									end
								end,
								set = function(_, value)
									local list = LibSharedMedia:List("border")
									db.other.borderName = list[value]
									updateProfile()
								end,
								width = 1,
								disabled = function(info) return db.other.disabled end,
							},
							borderSize = {
								type = "range",
								name = L.borderSize,
								order = 2,
								min = 1,
								max = 32,
								step = 1,
							},
							borderOffset = {
								type = "range",
								name = L.borderOffset,
								order = 3,
								min = 0,
								max = 32,
								step = 1,
							},
						},
					},
					countText = {
						type = "group",
						inline = true,
						name = L.countText,
						order = 19,
						args = {
							showCountText = {
								type = "toggle",
								name = L.showCountText,
								order = 1,
							},
							countTextFontName = {
								type = "select",
								name = L.font,
								values = LibSharedMedia:List(FONT),
								itemControl = "DDI-Font",
								get = function()
									for i, v in next, LibSharedMedia:List(FONT) do
										if v == db.other.countTextFontName then return i end
									end
								end,
								set = function(_, value)
									local list = LibSharedMedia:List(FONT)
									db.other.countTextFontName = list[value]
									updateProfile()
								end,
								order = 2,
							},
							countTextFontSize = {
								type = "range",
								name = L.fontSize,
								desc = L.fontSizeDesc,
								min = 8, max = 200, softMax = 100, step = 1,
								order = 3,
							},
							countTextOutline = {
								type = "select",
								name = L.outline,
								values = {
									NONE = L.none,
									OUTLINE = L.thin,
									THICKOUTLINE = L.thick,
								},
								order = 4,
							},
							countTextMonochrome = {
								type = "toggle",
								name = L.monochrome,
								desc = L.monochromeDesc,
								order = 5,
							},
							countTextSlug = {
								type = "toggle",
								name = L.slugRendering,
								desc = L.slugRenderingDesc,
								order = 6,
							},
							countTextAnchorPoint = {
								type = "select",
								name = L.position,
								values = BigWigsAPI.GetFramePointList(),
								order = 10,
							},
							countTextAnchorXOffset = {
								type = "range",
								name = L.offsetX,
								min = -100, max = 100, step = 1,
								order = 11,
							},
							countTextAnchorYOffset = {
								type = "range",
								name = L.offsetY,
								min = -100, max = 100, step = 1,
								order = 12,
							},
							countTextColor = {
								type = "color",
								name = L.fontColor,
								order = 13,
								get = function(info)
									local colorTable = db.other.countTextColor
									return colorTable[1], colorTable[2], colorTable[3], colorTable[4]
								end,
								set = function(_, r, g, b, a)
									db.other.countTextColor  = {r, g, b, a}
									updateProfile()
								end,
								hasAlpha = true,
							},
						},
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
						func = function()
							reset("other")
							updateProfile()
						end,
						order = 101,
					},
				},
			},
			sounds = {
				type = "group",
				name = L.auraSounds,
				order = 6,
				args = {
				},
			},
			exactPositioning = {
				type = "group",
				name = L.positionExact,
				order = 10,
				childGroups = "tab",
				args = {
					player = {
						type = "group",
						name = L.bossDebuffsOnYou,
						get = function(info)
							return db.player[info[#info]]
						end,
						set = function(info, value)
							db.player[info[#info]] = value
							local anchor = anchors.player[1]
							if anchor then
								anchor:UpdateAnchorPosition()
							end
						end,
						order = 1,
						args = {
							anchorXOffset = {
								type = "range",
								name = L.positionX,
								desc = L.positionDesc,
								min = -2048, max = 2048, step = 1,
								width = 3,
								order = 1,
								disabled = IsAnchorDisabled,
							},
							anchorYOffset = {
								type = "range",
								name = L.positionY,
								desc = L.positionDesc,
								min = -2048, max = 2048, step = 1,
								width = 3,
								order = 2,
								disabled = IsAnchorDisabled,
							},
							anchorRelativeTo = {
								type = "input",
								name = L.customAnchorPoint,
								set = function(_, value)
									local anchorDB = db.player
									local defaultDB = plugin.defaultDB.player
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
									local anchor = anchors.player[1]
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
								width = 3,
								order = 3,
								disabled = IsAnchorDisabled,
							},
							anchorPoint = {
								type = "select",
								name = L.sourcePoint,
								values = BigWigsAPI.GetFramePointList(),
								width = 1.5,
								order = 4,
								disabled = IsAurasOnYouDisabledOrAnchorPointIsDefault,
							},
							anchorRelPoint = {
								type = "select",
								name = L.destinationPoint,
								values = BigWigsAPI.GetFramePointList(),
								width = 1.5,
								order = 5,
								disabled = IsAurasOnYouDisabledOrAnchorPointIsDefault,
							},
						},
					},
					other = {
						type = "group",
						name = L.bossDebuffsOnTank,
						get = function(info)
							return db.other[info[#info]]
						end,
						set = function(info, value)
							db.other[info[#info]] = value
							local anchor = anchors.other[1]
							if anchor then
								anchor:UpdateAnchorPosition()
							end
						end,
						order = 2,
						args = {
							anchorXOffset = {
								type = "range",
								name = L.positionX,
								desc = L.positionDesc,
								min = -2048, max = 2048, step = 1,
								width = 3,
								order = 1,
								disabled = IsAnchorDisabled,
							},
							anchorYOffset = {
								type = "range",
								name = L.positionY,
								desc = L.positionDesc,
								min = -2048, max = 2048, step = 1,
								width = 3,
								order = 2,
								disabled = IsAnchorDisabled,
							},
							anchorRelativeTo = {
								type = "input",
								name = L.customAnchorPoint,
								set = function(_, value)
									local anchorDB = db.other
									local defaultDB = plugin.defaultDB.other
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
									local anchor = anchors.other[1]
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
								width = 3,
								order = 3,
								disabled = IsAnchorDisabled,
							},
							anchorPoint = {
								type = "select",
								name = L.sourcePoint,
								values = BigWigsAPI.GetFramePointList(),
								width = 1.5,
								order = 4,
								disabled = IsAurasOnOthersDisabledOrAnchorPointIsDefault,
							},
							anchorRelPoint = {
								type = "select",
								name = L.destinationPoint,
								values = BigWigsAPI.GetFramePointList(),
								width = 1.5,
								order = 5,
								disabled = IsAurasOnOthersDisabledOrAnchorPointIsDefault,
							},
						},
					},
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

		local bg = display:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(display)
		bg:SetColorTexture(0, 0, 0, parent.hasTestIcon and 0 or 0.3)
		display.bg = bg

		local header = display:CreateFontString()
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

		for _, unitAnchors in next, anchors do
			for i = 1, #unitAnchors do
				local anchor = unitAnchors[i]
				if not anchor.configModeFrame then
					anchor.configModeFrame = createDragAnchor(anchor)
					anchor.configModeFrame.text:SetText(anchor.hasTestIcon and "" or (anchor.unitType == "player" and L.aurasTestAnchorText or L.aurasTestTankAnchorText):format(i))
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
	tip:SetPoint("BOTTOM", anchors.player[1], "TOP", 0, 20)
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

	if not db.player.disabled and self.db.global.showHelpTip and anchors.player[1] then
		self:CreateTestAura()
		self:ScheduleRepeatingTimer(function() plugin:CreateTestAura() end, 10.2)
		if ShowHelpTip then
			ShowHelpTip()
		end
	end
end

function plugin:OnPluginDisable()
	for _, unitAnchors in next, anchors do
		for i = 1, #unitAnchors do
			local anchor = unitAnchors[i]
			anchor:ClearAllPoints()
			anchor:Hide()
		end
	end

	RemoveAllAuraSounds()
end

--------------------------------------------------------------------------------
-- Anchors
--

local function UpdateAnchorPosition(anchor)
	local anchorDB = plugin.db.profile[anchor.unitType]

	local scale = anchor:GetScale()
	anchor:ClearAllPoints()

	local index = anchor:GetID()
	if index == 1 then
		local relativeTo = anchorDB.anchorRelativeTo
		local point, relPoint = anchorDB.anchorPoint, anchorDB.anchorRelPoint
		local x, y = anchorDB.anchorXOffset, anchorDB.anchorYOffset
		anchor:SetPoint(point, relativeTo, relPoint, x / scale, y / scale)
	else
		local relativeTo = anchors[anchor.unitType][index - 1]
		local point, relPoint
		local x, y = 0, 0
		if anchorDB.growthDirection == "RIGHT" then
			point, relPoint = "LEFT", "RIGHT"
			x = anchorDB.spacing
		elseif anchorDB.growthDirection == "LEFT" then
			point, relPoint = "RIGHT", "LEFT"
			x = -anchorDB.spacing
		elseif anchorDB.growthDirection == "UP" then
			point, relPoint = "BOTTOM", "TOP"
			y = anchorDB.spacing
		elseif anchorDB.growthDirection == "DOWN" then
			point, relPoint = "TOP", "BOTTOM"
			y = -anchorDB.spacing
		end
		anchor:SetPoint(point, relativeTo, relPoint, x / scale, y / scale)
	end
end

function plugin:UpdateAllAnchors()
	self:UpdateAnchors("player", "player")
	self:UpdateAnchors("other")

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
			if db.otherPlayerType == "tank" and (not db.onlyWhenYouAreTank or (db.onlyWhenYouAreTank and UnitGroupRolesAssigned("player") == "TANK")) then
				local token = self:GetUnitToken(db.otherPlayerType, db.otherPlayerName)
				if token ~= previouslyFoundUnit then
					previouslyFoundUnit = token
					self:UpdateAnchors("other", token)
				end
			end
		end
		UpdateRegisteredSounds()
	end

	function plugin:UpdateAnchors(unitType, unitToken)
		for i = 1, #anchors[unitType] do
			local anchor = anchors[unitType][i]
			anchor:ClearAllPoints()
			anchor:Hide()
		end

		local anchorDB = self.db.profile[unitType]
		if anchorDB.disabled then
			return
		end

		for index = 1, anchorDB.maxIcons do
			local anchor = anchors[unitType][index]
			if not anchor then
				anchor = CreateFrame("Frame", "BigWigsAurasAnchor" .. (unitType:gsub("^%l", string.upper)) .. index, UIParent, nil, index)
				anchor:SetFrameStrata("MEDIUM")
				anchor:SetFixedFrameStrata(true)
				anchor:SetFrameLevel(1000)
				anchor:SetFixedFrameLevel(true)
				anchor:SetMovable(true)
				anchor:SetClampedToScreen(true)

				anchor.unitType = unitType
				anchor.UpdateAnchorPosition = UpdateAnchorPosition

				anchors[unitType][index] = anchor
			end

			anchor:SetSize(anchorDB.size, anchorDB.size)
			anchor:UpdateAnchorPosition()
			anchor:Show()

			UpdateTestAura(unitType, index)
		end

		if not unitToken and unitType == "other" then
			if db.otherPlayerType ~= "tank" or (db.onlyWhenYouAreTank and (not db.onlyWhenYouAreTank or UnitGroupRolesAssigned("player") ~= "TANK")) then
				unitToken = self:GetUnitToken(db.otherPlayerType, db.otherPlayerName)
			end
		end
		UpdateAuraContainer(unitType, unitToken, anchors[unitType][1])
	end
end

--------------------------------------------------------------------------------
-- Container
--

local function GetAtlasBorderSize(size)
	local scale = size / 32 * 2
	return size + (5 * scale)
end

do
	-- local durationFormater do
	-- 	-- a copy of DefaultAuraDurationFormatter
	-- 	local maxIntervalSecondsMultiplier = 1.5
	-- 	local maxIntervalCurve = C_CurveUtil.CreateCurve()
	-- 	maxIntervalCurve:AddPoint(1 + (maxIntervalSecondsMultiplier * SECONDS_PER_MIN), Enum.SecondsFormatterInterval.Minutes)
	-- 	maxIntervalCurve:AddPoint(1 + (maxIntervalSecondsMultiplier * SECONDS_PER_HOUR), Enum.SecondsFormatterInterval.Hours)
	-- 	maxIntervalCurve:AddPoint(1 + (maxIntervalSecondsMultiplier * SECONDS_PER_DAY), Enum.SecondsFormatterInterval.Days)

	-- 	durationFormater = C_StringUtil.CreateSecondsFormatter()
	-- 	durationFormater:SetDefaultAbbreviation(Enum.SecondsFormatterAbbreviation.OneLetter)
	-- 	durationFormater:SetMinInterval(Enum.SecondsFormatterInterval.Seconds)
	-- 	durationFormater:SetMaxIntervalCurve(maxIntervalCurve)
	-- 	durationFormater:SetDesiredUnitCount(1)

	-- 	-- changes
	-- 	durationFormater:SetStripIntervalWhitespace(Enum.SecondsFormatterIntervalWhitespace.Strip)
	-- 	durationFormater:SetMillisecondsThreshold(3)
	-- end

	function InitializeAuraFrame(aura, optionsDB)
		optionsDB = optionsDB or aura:GetParent().db
		local size = optionsDB.size

		aura:EnableMouse(optionsDB.showTooltip)
		aura:SetSize(size, size) -- CustomAuraContainerFlowLayoutDescription:ApplyElementLayout doesn't set size

		local icon = aura:CreateTexture(nil, "BACKGROUND")
		icon:SetAllPoints()
		icon:SetTexCoord(0.07, 0.93, 0.07, 0.93) -- TODO: this needs an option
		aura:SetIcon(icon)
		aura.icon = icon

		local cooldown = CreateFrame("Cooldown", nil, aura, "CooldownFrameTemplate")
		cooldown:SetAllPoints()
		cooldown:SetReverse(true)
		cooldown:SetDrawEdge(false)
		cooldown:SetDrawBling(false)
		cooldown:SetDrawSwipe(optionsDB.showCooldown)
		aura.cooldown = cooldown
		aura:SetDurationCooldown(cooldown)

		local duration = cooldown:GetCountdownFontString()
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
		cooldown:SetHideCountdownNumbers(not optionsDB.showCooldownText)
		cooldown:SetCountdownMillisecondsThreshold(optionsDB.cooldownTextMillisecondsThreshold)

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
		Center = true,
	}

	function UpdateAuraFrame(aura, optionsDB)
		aura:SetSize(optionsDB.size, optionsDB.size)

		local cooldown = aura:GetDurationCooldown()
		cooldown:SetDrawSwipe(optionsDB.showCooldown)
		cooldown:SetHideCountdownNumbers(not optionsDB.showCooldownText)
		cooldown:SetCountdownMillisecondsThreshold(optionsDB.cooldownTextMillisecondsThreshold)

		local duration = cooldown:GetCountdownFontString()
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

			local textColor = optionsDB.cooldownTextColor
			duration:SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
		end

		aura:ClearDispelTypeTextures()

		if optionsDB.borderName ~= "None" then
			-- Corner-anchoring to the aura would make GetWidth() secret, and SetBackdrop does arithmetic on it
			local borderSize = optionsDB.size + optionsDB.borderOffset * 2
			aura.border:ClearAllPoints()
			aura.border:SetPoint("CENTER")
			aura.border:SetSize(borderSize, borderSize)
			aura.border:SetBackdrop({
				edgeFile = LibSharedMedia:Fetch("border", optionsDB.borderName),
				edgeSize = optionsDB.borderSize,
			})

			for pieceName in pairs(backdropTextureUVs) do -- logic copied from Blizzard_SharedXML/Backdrop.lua
				local borderRegion = aura.border[pieceName]
				if borderRegion and pieceName ~= "Center" then
					aura:AddDispelTypeTexture(borderRegion, borderOptions)
				end
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
				initializeFrame = InitializeAuraFrame,
				candidateFilters = {
					maxDuration = math.huge, -- filter anything without a duration
					isBossOrRoleAura = true,
				},
				sortMethod = 4, -- Enum.UnitAuraSortRule.ExpirationOnly
				sortDirection = 0, -- Enum.UnitAuraSortDirection.Normal
				layout = {
					elementSpacing = optionsDB.spacing,
					elementWidth = optionsDB.size,
					elementHeight = optionsDB.size,
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

		auraContainer:SetEnabled(not optionsDB.disabled)
		auraContainer:SetUnit(unitToken or "none")

		auraContainer:ClearAllPoints()
		local axis, point, x, y
		if optionsDB.growthDirection == "RIGHT" then
			axis = FlowLayoutAxis.Horizontal
			point, x, y = "LEFT", FlowDirection.Right, FlowDirection.Down
		elseif optionsDB.growthDirection == "LEFT" then
			axis = FlowLayoutAxis.Horizontal
			point, x, y = "RIGHT", FlowDirection.Left, FlowDirection.Down
		elseif optionsDB.growthDirection == "UP" then
			axis = FlowLayoutAxis.Vertical
			point, x, y = "BOTTOM", FlowDirection.Right, FlowDirection.Up
		elseif optionsDB.growthDirection == "DOWN" then
			axis = FlowLayoutAxis.Vertical
			point, x, y = "TOP", FlowDirection.Right, FlowDirection.Down
		end
		auraContainer:SetPoint(point)
		auraContainer:SetFlowLayoutAxis(axis)
		auraContainer:SetFlowLayoutAnchorPoint(point)
		auraContainer:SetFlowLayoutGrowthDirection(x, y)

		auraContainer:SetAuraGroupMaxFrameCount("debuffs", optionsDB.maxIcons)
		auraContainer:SetAuraGroupLayout("debuffs", {
			elementSpacing = optionsDB.spacing,
			elementWidth = optionsDB.size,
			elementHeight = optionsDB.size,
		})
	end
end

--------------------------------------------------------------------------------
-- Test Auras
--

do
	local testAuras = { player = {}, other = {} }
	local testCount = 1
	local auraFramePool = {}

	local dispelTypeInfo = AuraUtil.GetDebuffDisplayInfoTable()
	local dispelTypeList = { "Magic", "Curse", "Disease", "Poison", "Enrage", "Bleed", [0] = "None" }
	local privateAuraSpellList = { 407221, 418720, 421828, 428970, 406317 }

	local function releaseFrame(frame)
		frame:ClearAllPoints()
		local anchor = frame:GetParent()
		frame:SetParent(nil)
		frame:SetScript("OnUpdate", nil)
		frame.cooldown:Clear()
		frame.timerID = nil
		frame:Hide()
		anchor.hasTestIcon = nil
		if anchor.configModeFrame then
			anchor.configModeFrame.text:SetText((anchor.unitType == "player" and L.aurasTestAnchorText or L.aurasTestTankAnchorText):format(anchor:GetID()))
			anchor.configModeFrame.bg:SetColorTexture(0, 0, 0, 0.3)
		end

		-- Pull it out of the active list
		local active = testAuras[frame.unitType]
		for i = #active, 1, -1 do
			if active[i] == frame then
				table.remove(active, i)
				break
			end
		end
		-- And put it back in the pool
		table.insert(auraFramePool, frame)
	end

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

	local function getTestAura(unitType, index)
		local aura = table.remove(auraFramePool)
		if not aura then
			aura = CreateFrame("Frame", nil, UIParent)
			aura:SetFrameStrata("MEDIUM")
			aura:SetFixedFrameStrata(true)
			aura:SetFrameLevel(1000)
			aura:SetFixedFrameLevel(true)
			aura:SetClampedToScreen(true)
			for name, func in next, methods do
				aura[name] = func or noop
			end
			InitializeAuraFrame(aura, db[unitType])
		end

		-- Setup test aura info
		local spellIndex = (index - 1) % #privateAuraSpellList + 1
		local spellId = privateAuraSpellList[spellIndex]
		local dispelType = dispelTypeList[(index - 1) % 7]

		local icon = C_Spell.GetSpellTexture(spellId)
		local duration = CONFIG_MODE_DURATION
		local expirationTime = GetTime() + duration
		local applications = math.random(0, 5)

		aura.icon:SetTexture(icon)
		aura.cooldown:SetCooldownFromExpirationTime(expirationTime, CONFIG_MODE_DURATION)
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

		local tbl = {}
		aura.timerID = tbl
		-- We don't want to use ScheduleTimer as we don't want the timer to cancel if this plugin is disabled
		local onDelay = function()
			if tbl == aura.timerID then
				releaseFrame(aura)
			end
		end
		plugin:SimpleTimer(onDelay, duration)

		return aura
	end

	function UpdateTestAura(unitType, index)
		local aura = testAuras[unitType][index]
		if not aura then return end

		UpdateAuraFrame(aura, db[unitType])
		aura:Show()
	end

	function plugin:CreateTestAura()
		for unitType, unitAnchors in next, anchors do
			if not db[unitType].disabled then
				local auras = testAuras[unitType]

				local aura = getTestAura(unitType, testCount)
				table.insert(auras, 1, aura) -- Pop it on
				testCount = testCount + 1
				if testCount > 10 then
					testCount = 1
				end

				for i = 1, math.min(#auras, db[unitType].maxIcons) do
					local frame = auras[i]
					frame:ClearAllPoints()
					frame:SetParent(unitAnchors[i])
					frame:SetPoint("CENTER")
					if unitAnchors[i].configModeFrame then
						unitAnchors[i].configModeFrame.text:SetText("")
						unitAnchors[i].configModeFrame.bg:SetColorTexture(0, 0, 0, 0)
					end
					unitAnchors[i].hasTestIcon = true
					UpdateTestAura(unitType, i)
				end
				for i = #auras, db[unitType].maxIcons + 1, -1 do
					local frame = auras[i]
					if frame then
						releaseFrame(frame)
					end
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
