if not BigWigsLoader.isRetail then return end -- Retail only module

-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin, L = BigWigs:NewPlugin("PrivateAuras")
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

local CONFIG_MODE_DURATION = 10

local db
local anchors = { player = {}, other = {} }
local inConfigureMode = false
local previouslyFoundUnit = nil

local UpdateTestAura

--------------------------------------------------------------------------------
-- Profile
--

plugin.defaultDB = {
	showDispelType = true,

	player = {
		disabled = false,

		size = 64,
		spacing = 6,
		showBorder = true,
		showCooldown = true,
		showCooldownText = true,
		cooldownTextScale = 1,
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
		showBorder = true,
		showCooldown = true,
		showCooldownText = true,
		cooldownTextScale = 1,
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
		elseif type(v) == "table" then
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

	if db.player.cooldownTextScale < 0.1 or db.player.cooldownTextScale > 4 then
		db.player.cooldownTextScale = plugin.defaultDB.player.cooldownTextScale
	end
	if db.other.cooldownTextScale < 0.1 or db.other.cooldownTextScale > 4 then
		db.other.cooldownTextScale = plugin.defaultDB.other.cooldownTextScale
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

	if db.player.maxIcons < 2 or db.player.maxIcons > 5 then
		db.player.maxIcons = plugin.defaultDB.player.maxIcons
	else
		local numPlayer = math.floor(db.player.maxIcons+0.5)
		if numPlayer ~= db.player.maxIcons then
			db.player.maxIcons = numPlayer
		end
	end

	if db.other.maxIcons < 2 or db.other.maxIcons > 5 then
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

	if not db.player.disabled or not db.other.disabled then
		C_UnitAuras.TriggerPrivateAuraShowDispelType(db.showDispelType)
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
			if not UnitIsUnit("player", unit) and UnitGroupRolesAssigned(unit) == "TANK" and not UnitInPartyIsAI(unit) then
				local colorTbl = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
				local name = plugin:UnitName(unit)
				local _, class = UnitClass(unit)
				local tbl = class and colorTbl[class] or GRAY_FONT_COLOR
				return ("%s|cFF%02x%02x%02x%s|r"):format(roleIcons.TANK, tbl.r*255, tbl.g*255, tbl.b*255, name)
			end
		end
	end

	plugin.pluginOptions = {
		type = "group",
		name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Private:20|t ".. L.privateAuras,
		childGroups = "tab",
		handler = plugin,
		order = 3,
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
			},
			testButton = {
				type = "execute",
				name = L.createTestAura,
				func = "CreateTestAura",
				width = 1.5,
				order = 2,
			},
			showDispelType = {
				type = "toggle",
				name = L.showDispelType,
				desc = L.showDispelTypeDesc,
				get = function() return db.showDispelType end,
				set = function(_, value)
					db.showDispelType = value
					updateProfile()
				end,
				width = "full",
				order = 3,
				disabled = function()
					if db.player.disabled and db.other.disabled then
						return true
					end
				end,
			},
			player = {
				type = "group",
				name = L.aurasOnYou,
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
						name = L.aurasOnYouDesc,
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
					showBorder = {
						type = "toggle",
						name = L.showBorder,
						desc = L.showBorderDesc,
						width = 1.6,
						order = 6,
						disabled = IsAnchorDisabled,
					},
					showCooldown = {
						type = "toggle",
						name = L.showCooldown,
						desc = L.showCooldownSwipeDesc,
						width = 1.6,
						order = 7,
						disabled = IsAnchorDisabled,
					},
					showCooldownText = {
						type = "toggle",
						name = L.showCooldownText,
						width = 1.6,
						order = 8,
						disabled = IsAnchorDisabled,
					},
					cooldownTextScale = {
						type = "range",
						name = L.cooldownTextScale,
						min = 0.1, max = 4, step = 0.1, isPercent = true,
						width = 1.6,
						order = 9,
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
						order = 10,
						disabled = IsAnchorDisabled,
					},
					maxIcons = {
						type = "range",
						name = L.maxIcons,
						desc = L.maxIconsDesc,
						min = 2, max = 5, step = 1,
						width = 1.6,
						order = 11,
						disabled = IsAnchorDisabled,
					},
					resetHeader = {
						type = "header",
						name = "",
						order = 12,
					},
					reset = {
						type = "execute",
						name = L.resetAll,
						desc = L.resetDesc,
						func = function()
							plugin.db:ResetProfile()
							updateProfile()
						end,
						order = 13,
					},
				},
			},
			other = {
				type = "group",
				name = L.aurasOnAnother,
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
							if value then
								plugin:UnregisterEvent("GROUP_ROSTER_UPDATE")
							else
								plugin:RegisterEvent("GROUP_ROSTER_UPDATE")
							end
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
					showBorder = {
						type = "toggle",
						name = L.showBorder,
						desc = L.showBorderDesc,
						width = 1.6,
						order = 12,
						disabled = IsAnchorDisabled,
					},
					showCooldown = {
						type = "toggle",
						name = L.showCooldown,
						desc = L.showCooldownSwipeDesc,
						width = 1.6,
						order = 13,
						disabled = IsAnchorDisabled,
					},
					showCooldownText = {
						type = "toggle",
						name = L.showCooldownText,
						width = 1.6,
						order = 14,
						disabled = IsAnchorDisabled,
					},
					cooldownTextScale = {
						type = "range",
						name = L.cooldownTextScale,
						min = 0.1, max = 4, step = 0.1, isPercent = true,
						width = 1.6,
						order = 15,
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
						order = 16,
						disabled = IsAnchorDisabled,
					},
					maxIcons = {
						type = "range",
						name = L.maxIcons,
						desc = L.maxIconsDesc,
						min = 2, max = 5, step = 1,
						width = 1.6,
						order = 17,
						disabled = IsAnchorDisabled,
					},
					resetHeader = {
						type = "header",
						name = "",
						order = 18,
					},
					reset = {
						type = "execute",
						name = L.resetAll,
						desc = L.resetDesc,
						func = function()
							plugin.db:ResetProfile()
							updateProfile()
						end,
						order = 19,
					},
				},
			},
			exactPositioning = {
				type = "group",
				name = L.positionExact,
				order = 6,
				childGroups = "tab",
				args = {
					player = {
						type = "group",
						name = L.aurasOnYou,
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
						name = L.aurasOnAnother,
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
end

--------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnRegister()
	self.displayName = L.privateAuras
end

do
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
		tipText:SetText(L.privateAurasHelpTip)
		local button = CreateFrame("Button", nil, tip, "SharedButtonTemplate")
		button:SetSize(130, 32)
		button:SetPoint("BOTTOM", 0, 6)
		button:SetText(L.settings)
		button:SetScript("OnClick", function(self)
			self:GetParent():Hide()
			plugin:CancelAllTimers()
			plugin:SendMessage("BigWigs_StartConfigureMode", plugin.moduleName)
			BigWigsAPI.OpenConfigToPanel("PrivateAuras")
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

		if not db.other.disabled then
			self:RegisterEvent("GROUP_ROSTER_UPDATE")
		end

		if not db.player.disabled and self.db.global.showHelpTip and anchors.player[1] then
			self:CreateTestAura()
			self:ScheduleRepeatingTimer(function() plugin:CreateTestAura() end, 10.2)
			if ShowHelpTip then
				ShowHelpTip()
			end
		end
	end
end

function plugin:OnPluginDisable()
	for _, unitAnchors in next, anchors do
		for i = 1, #unitAnchors do
			local anchor = unitAnchors[i]
			if anchor.anchorId then
				C_UnitAuras.RemovePrivateAuraAnchor(anchor.anchorId)
				anchor.anchorId = nil
			end
			anchor:ClearAllPoints()
			anchor:Hide()
		end
	end
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
end

do
	local function GetUnitToken()
		if db.otherPlayerType == "player" then
			local playerName = db.otherPlayerName
			if playerName ~= "" and UnitExists(playerName) then
				for unit in plugin:IterateGroup(true) do
					if UnitIsUnit(playerName, unit) then
						return unit
					end
				end
			end
		elseif db.otherPlayerType == "tank" and (not db.onlyWhenYouAreTank or (db.onlyWhenYouAreTank and UnitGroupRolesAssigned("player") == "TANK")) then
			for unit in plugin:IterateGroup(true) do
				if not UnitIsUnit("player", unit) and UnitGroupRolesAssigned(unit) == "TANK" then
					return unit
				end
			end
		end
	end

	function plugin:GROUP_ROSTER_UPDATE()
		local token = GetUnitToken()
		if token ~= previouslyFoundUnit then
			previouslyFoundUnit = token
			self:UpdateAnchors("other", token)
		end
	end

	function plugin:UpdateAnchors(unitType, token)
		for i = 1, #anchors[unitType] do
			local anchor = anchors[unitType][i]
			if anchor.anchorId then
				C_UnitAuras.RemovePrivateAuraAnchor(anchor.anchorId)
				anchor.anchorId = nil
			end
			anchor:ClearAllPoints()
			anchor:Hide()
		end

		local anchorDB = self.db.profile[unitType]
		if anchorDB.disabled then
			return
		end

		local scale = anchorDB.cooldownTextScale
		local width = anchorDB.size * (1 / scale)
		local height = anchorDB.size * (1 / scale)
		local borderScale = width / 32 * 2 -- Scale the dispel type border
		if not anchorDB.showBorder then
			borderScale = -10000 -- Hide the border
		end
		local unitToken = token or GetUnitToken()

		for index = 1, anchorDB.maxIcons do
			local anchor = anchors[unitType][index]
			if not anchor then
				anchor = CreateFrame("Frame", "BigWigsPrivateAurasAnchor" .. (unitType:gsub("^%l", string.upper)) .. index, UIParent, nil, index)
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

			anchor:SetSize(width, height)
			anchor:SetScale(scale)
			anchor:UpdateAnchorPosition()
			anchor:Show()

			UpdateTestAura(unitType, index)

			if unitToken then
				anchor.anchorId = C_UnitAuras.AddPrivateAuraAnchor({
					unitToken = unitToken,
					auraIndex = index,
					parent = anchor,
					showCountdownFrame = anchorDB.showCooldown,
					showCountdownNumbers = anchorDB.showCooldownText,
					iconInfo = {
						iconAnchor = {
							point = "CENTER",
							relativeTo = anchor,
							relativePoint = "CENTER",
							offsetX = 0,
							offsetY = 0,
						},
						iconWidth = width,
						iconHeight = height,
						borderScale = borderScale,
					},
				})
			end
		end
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
			anchor.configModeFrame.text:SetText(L.privateAurasTestAnchorText:format(anchor:GetID()))
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

	local function getTestAura(unitType, index)
		local aura = table.remove(auraFramePool)
		if not aura then
			aura = CreateFrame("Frame", nil, UIParent)
			aura:SetFrameStrata("MEDIUM")
			aura:SetFixedFrameStrata(true)
			aura:SetFrameLevel(1000)
			aura:SetFixedFrameLevel(true)
			aura:SetClampedToScreen(true)

			local icon = aura:CreateTexture(nil, "BACKGROUND")
			icon:SetAllPoints()
			aura.icon = icon

			local cooldown = CreateFrame("Cooldown", nil, aura, "CooldownFrameTemplate")
			cooldown:SetAllPoints()
			cooldown:SetReverse(true)
			cooldown:SetDrawBling(false)
			cooldown:SetDrawEdge(false)
			aura.cooldown = cooldown

			local dispelIcon = aura:CreateTexture(nil, "OVERLAY")
			dispelIcon:SetPoint("CENTER")
			aura.dispelIcon = dispelIcon
		end

		-- Setup test aura info
		local spellIndex = (index - 1) % #privateAuraSpellList + 1
		local icon = C_Spell.GetSpellTexture(privateAuraSpellList[spellIndex])
		local dispelType = dispelTypeList[(index - 1) % 7]
		local duration = CONFIG_MODE_DURATION
		local expirationTime = GetTime() + duration

		aura.icon:SetTexture(icon)
		aura.dispelType = dispelType
		aura.expirationTime = expirationTime
		aura.unitType = unitType
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

		local anchorDB = db[unitType]

		if anchorDB.showCooldown then
			aura.cooldown:SetHideCountdownNumbers(not anchorDB.showCooldownText)
			aura.cooldown:SetCooldownFromExpirationTime(aura.expirationTime, CONFIG_MODE_DURATION)
			aura.cooldown:Show()
		else
			aura.cooldown:Hide()
		end

		local scale = anchorDB.cooldownTextScale
		local size = anchorDB.size * (1 / scale)

		if anchorDB.showBorder then
			-- Apply the dispel type border (from Blizzard_PrivateAurasUI)
			local borderScale = size / 32 * 2
			local borderSize = size + (5 * borderScale)
			aura.dispelIcon:SetSize(borderSize, borderSize)

			local info = dispelTypeInfo[aura.dispelType] or dispelTypeInfo.None
			local atlas = db.showDispelType and info.dispelAtlas or info.basicAtlas
			aura.dispelIcon:SetAtlas(atlas)
			aura.dispelIcon:Show()
		else
			aura.dispelIcon:Hide()
		end

		aura:SetSize(size, size)
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
