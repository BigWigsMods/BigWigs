if not BigWigsLoader.isRetail then return end -- Retail only module

-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin, L = BigWigs:NewPlugin("PrivateAuras")
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

local MAX_AURAS = 3
local CONFIG_MODE_DURATION = 10

local db
local anchors = { player = {}, other = {} }
local inConfigureMode = false

local GetUnitToken, UpdateTestAura

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
		showCountdownText = true,
		countdownTextScale = 1,
		-- showDurationText = false,
		growthDirection = "RIGHT",

		anchorPoint = "CENTER",
		anchorRelPoint = "CENTER",
		anchorXOffset = 100,
		anchorYOffset = 100,
		anchorRelativeTo = "UIParent",
	},
	other = {
		disabled = true,

		size = 64,
		spacing = 6,
		showBorder = true,
		showCooldown = true,
		showCountdownText = true,
		countdownTextScale = 1,
		-- showDurationText = false,
		growthDirection = "RIGHT",

		anchorPoint = "CENTER",
		anchorRelPoint = "CENTER",
		anchorXOffset = 100,
		anchorYOffset = -150,
		anchorRelativeTo = "UIParent",
	},
	otherPlayerType = "tank",
	otherPlayerName = "",
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

	-- TODO more setting validation?

	C_UnitAuras.TriggerPrivateAuraShowDispelType(db.showDispelType)

	plugin:UpdateAllAnchors()
	if inConfigureMode then -- update visible anchors
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
		if key == "showCountdownText" then
			return not optionDB.showCooldown
		elseif key == "countdownTextScale" then
			return not optionDB.showCooldown or not optionDB.showCountdownText
		elseif key == "anchorPoint" or key == "anchorRelPoint" then
			return optionDB.anchorRelativeTo == plugin.defaultDB[unitType].anchorRelativeTo
		end
	end
	local roleIcons = {
		["TANK"] = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Role_Tank:0|t",
		["HEALER"] = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Role_Healer:0|t",
		["DAMAGER"] = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Role_Damage:0|t",
		["NONE"] = "",
	}

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
					C_UnitAuras.TriggerPrivateAuraShowDispelType(value)
				end,
				width = "full",
				order = 3,
			},
			player = {
				type = "group",
				name = "XX Auras On You",
				get = function(info)
					return db.player[info[#info]]
				end,
				set = function(info, value)
					db.player[info[#info]] = value
					plugin:UpdateAnchors("player")
				end,
				order = 10,
				args = {
					heading = {
						type = "description",
						name = "XX Customize the icons for auras that apply to you." .. "\n\n",
						order = 0.5,
						width = "full",
						fontSize = "medium",
					},
					disabled = {
						type = "toggle",
						name = L.disabled,
						set = function(_, value)
							db.player.disabled = value
							updateProfile()
						end,
						width = 1.6,
						order = 0.6,
					},
					sep1 = {
						type = "description",
						name = "",
						order = 0.7,
					},
					size = {
						type = "range",
						name = L.iconSize,
						min = 24, max = 512, step = 1,
						width = 1.6,
						order = 1,
						disabled = IsAnchorDisabled,
					},
					spacing = {
						type = "range",
						name = L.iconSpacing,
						min = 0, max = 50, step = 1,
						width = 1.6,
						order = 2,
						disabled = IsAnchorDisabled,
					},
					showBorder = {
						type = "toggle",
						name = L.showBorder,
						desc = L.showBorderDesc,
						width = 1.6,
						order = 3,
						disabled = IsAnchorDisabled,
					},
					showCooldown = {
						type = "toggle",
						name = L.showCooldown,
						width = 1.6,
						order = 4,
						disabled = IsAnchorDisabled,
					},
					showCountdownText = {
						type = "toggle",
						name = L.showCountdownText,
						width = 1.6,
						order = 5,
						disabled = IsAnchorDisabled,
					},
					countdownTextScale = {
						type = "range",
						name = L.countdownTextScale,
						min = 0.1, max = 4, step = 0.1, isPercent = true,
						width = 1.6,
						order = 6,
						disabled = IsAnchorDisabled,
					},
					-- showDurationText = {
					-- 	type = "toggle",
					-- 	name = L.showDurationText,
					-- 	width = 1.6,
					-- 	order = 7,
					-- 	disabled = IsAnchorDisabled,
					-- },
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
						order = 8,
						disabled = IsAnchorDisabled,
					},
					line1 = {
						type = "header",
						name = "",
						order = 10,
					},
					reset = {
						type = "execute",
						name = L.resetAll,
						desc = L.resetDesc,
						func = function()
							plugin.db:ResetProfile()
							updateProfile()
						end,
						order = -1,
					},
				},
			},
			other = {
				type = "group",
				name = "XX Auras On Another",
				get = function(info)
					return db.other[info[#info]]
				end,
				set = function(info, value)
					db.other[info[#info]] = value
					plugin:UpdateAnchors("other")
				end,
				order = 15,
				args = {
					heading = {
						type = "description",
						name = "XX Choose a specific player and then customize the icons for auras that apply to them." .. "\n\n",
						order = 0.1,
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
						order = 0.2,
					},
					sep1 = {
						type = "description",
						name = "",
						order = 0.3,
					},
					otherPlayerType = {
						type = "select",
						name = "XX Player Target",
						values = {
							tank = "XX Other Tank",
							player = "XX Player Name",
						},
						get = function() return db.otherPlayerType end,
						set = function(_, value)
							db.otherPlayerType = value
							db.otherPlayerName = ""
							plugin:UpdateAnchors("other")
						end,
						disabled = IsAnchorDisabled,
						-- width = 1.6,
						order = 0.4,
					},
					otherPlayerName = {
						type = "select",
						name = "XX Player Name",
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
						width = 2.2,
						order = 0.5,
					},
					otherPlayerIsTankLabel = {
						type = "description",
						name = function()
							return ("XX Show private auras that are on the other tank when you are a tank. (Current: %s)"):format(GetUnitToken("tank") or L.none)
						end,
						hidden = function()
							return db.otherPlayerType == "player"
						end,
						disabled = IsAnchorDisabled,
						width = 2.2,
						order = 0.5,
					},
					sep2 = {
						type = "description",
						name = "",
						order = 0.9,
					},
					size = {
						type = "range",
						name = L.iconSize,
						min = 24, max = 512, step = 1,
						width = 1.6,
						order = 1,
						disabled = IsAnchorDisabled,
					},
					spacing = {
						type = "range",
						name = L.iconSpacing,
						min = 0, max = 50, step = 1,
						width = 1.6,
						order = 2,
						disabled = IsAnchorDisabled,
					},
					showBorder = {
						type = "toggle",
						name = L.showBorder,
						desc = L.showBorderDesc,
						width = 1.6,
						order = 3,
						disabled = IsAnchorDisabled,
					},
					showCooldown = {
						type = "toggle",
						name = L.showCooldown,
						width = 1.6,
						order = 4,
						disabled = IsAnchorDisabled,
					},
					showCountdownText = {
						type = "toggle",
						name = L.showCountdownText,
						width = 1.6,
						order = 5,
						disabled = IsAnchorDisabled,
					},
					countdownTextScale = {
						type = "range",
						name = L.countdownTextScale,
						min = 0.1, max = 4, step = 0.1, isPercent = true,
						width = 1.6,
						order = 6,
						disabled = IsAnchorDisabled,
					},
					-- showDurationText = {
					-- 	type = "toggle",
					-- 	name = L.showDurationText,
					-- 	width = 1.6,
					-- 	order = 7,
					-- 	disabled = IsAnchorDisabled,
					-- },
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
						order = 8,
						disabled = IsAnchorDisabled,
					},
					line1 = {
						type = "header",
						name = "",
						order = 10,
					},
					reset = {
						type = "execute",
						name = L.resetAll,
						desc = L.resetDesc,
						func = function()
							plugin.db:ResetProfile()
							updateProfile()
						end,
						order = -1,
					},
				},
			},
			exactPositioning = {
				type = "group",
				name = L.positionExact,
				order = 20,
				childGroups = "tab",
				args = {
					player = {
						type = "group",
						name = "XX PA ON YOU",
						inline = true,
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
								width = 3.2,
								order = 1,
								disabled = IsAnchorDisabled,
							},
							anchorYOffset = {
								type = "range",
								name = L.positionY,
								desc = L.positionDesc,
								min = -2048, max = 2048, step = 1,
								width = 3.2,
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
								width = 3.2,
								order = 3,
								disabled = IsAnchorDisabled,
							},
							anchorPoint = {
								type = "select",
								name = L.sourcePoint,
								values = BigWigsAPI.GetFramePointList(),
								width = 1.6,
								order = 4,
								disabled = IsAnchorDisabled,
							},
							anchorRelPoint = {
								type = "select",
								name = L.destinationPoint,
								values = BigWigsAPI.GetFramePointList(),
								width = 1.6,
								order = 5,
								disabled = IsAnchorDisabled,
							},
						},
					},
					other = {
						type = "group",
						name = "XX PA ON OTHERS",
						inline = true,
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
								width = 3.2,
								order = 1,
								disabled = IsAnchorDisabled,
							},
							anchorYOffset = {
								type = "range",
								name = L.positionY,
								desc = L.positionDesc,
								min = -2048, max = 2048, step = 1,
								width = 3.2,
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
								width = 3.2,
								order = 3,
								disabled = IsAnchorDisabled,
							},
							anchorPoint = {
								type = "select",
								name = L.sourcePoint,
								values = BigWigsAPI.GetFramePointList(),
								width = 1.6,
								order = 4,
								disabled = IsAnchorDisabled,
							},
							anchorRelPoint = {
								type = "select",
								name = L.destinationPoint,
								values = BigWigsAPI.GetFramePointList(),
								width = 1.6,
								order = 5,
								disabled = IsAnchorDisabled,
							},
						},
					},
				},
			},
		},
	}

	local function OnDragStart(self)
		local anchor = self.dragAnchor
		anchor:StartMoving()
	end
	local function OnDragStop(self)
		local anchor = self.dragAnchor
		anchor:StopMovingOrSizing()

		local point, _, relPoint, x, y = anchor:GetPoint()
		x = math.floor(x + 0.5)
		y = math.floor(y + 0.5)

		local anchorDB = anchor.db
		anchorDB.anchorPoint = point
		anchorDB.anchorRelPoint = relPoint
		anchorDB.anchorXOffset = x
		anchorDB.anchorYOffset = y
		anchor:UpdateAnchorPosition()

		if BigWigsOptions and BigWigsOptions:IsOpen() then
			plugin:UpdateGUI()
		end
	end

	local function createDragAnchor(parent)
		local display = CreateFrame("Frame", nil, UIParent)
		display:SetPoint("TOPLEFT", parent)
		display:SetPoint("BOTTOMRIGHT", parent)
		display:Hide()

		display:EnableMouse(true)
		display:RegisterForDrag("LeftButton")
		display:SetScript("OnDragStart", OnDragStart)
		display:SetScript("OnDragStop", OnDragStop)

		local bg = display:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(display)
		bg:SetColorTexture(0, 0, 0, 0.3)

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

		for unitType, unitAnchors in pairs(anchors) do
			for index, anchor in ipairs(unitAnchors) do
				if not anchor.configModeFrame then
					anchor.configModeFrame = createDragAnchor(anchor)
					anchor.configModeFrame.text:SetText(L.privateAurasTestAnchorText:format(index))
					anchor.configModeFrame.dragAnchor = unitAnchors[1]
				end
				anchor.configModeFrame:Show()
			end
		end
	end

	function plugin:BigWigs_StopConfigureMode(_, mode)
		if mode and mode ~= self.moduleName then return end
		inConfigureMode = false

		for _, unitAnchors in pairs(anchors) do
			for _, anchor in ipairs(unitAnchors) do
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

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_OnPluginDisable", "RemoveAllAnchors")
	self:RegisterMessage("BigWigs_StartConfigureMode")
	self:RegisterMessage("BigWigs_StopConfigureMode")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()

	self:RegisterEvent("GROUP_ROSTER_UPDATE")
end

function plugin:GROUP_ROSTER_UPDATE()
	if not InCombatLockdown() then
		self:UpdateAnchors("other")
	end
end

--------------------------------------------------------------------------------
-- Anchors
--

local function UpdateAnchorPosition(anchor)
	local anchorDB = anchor.db

	anchor:ClearAllPoints()

	local index = anchor:GetID()
	if index == 1 then
		local relativeTo = anchorDB.anchorRelativeTo
		local point, relPoint = anchorDB.anchorPoint, anchorDB.anchorRelPoint
		local x, y = anchorDB.anchorXOffset, anchorDB.anchorYOffset
		anchor:SetPoint(point, relativeTo, relPoint, x, y)
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
		anchor:SetPoint(point, relativeTo, relPoint, x, y)
	end
end

function GetUnitToken(targetType, playerName)
	-- XXX at what point does UnitIsUnit start to return a secret?
	if targetType == "player" then
		for unit in plugin:IterateGroup(true) do
			if UnitIsUnit(playerName, unit) then
				return unit
			end
		end
		return nil
	elseif targetType == "tank" then
		for unit in plugin:IterateGroup(true) do
			if not UnitIsUnit("player", unit) and UnitGroupRolesAssigned(unit) == "TANK" then
				return unit
			end
		end
		return nil
	end
end

function plugin:RemoveAllAnchors()
	for _, unitAnchors in pairs(anchors) do
		for _, anchor in ipairs(unitAnchors) do
			if anchor.anchorId then
				C_UnitAuras.RemovePrivateAuraAnchor(anchor.anchorId)
				anchor.anchorId = nil
			end
			anchor:ClearAllPoints()
			anchor:Hide()
		end
	end
end

function plugin:UpdateAllAnchors()
	self:UpdateAnchors("player")
	self:UpdateAnchors("other")
end

function plugin:UpdateAnchors(unitType)
	for _, anchor in ipairs(anchors[unitType]) do
		if anchor.anchorId then
			C_UnitAuras.RemovePrivateAuraAnchor(anchor.anchorId)
			anchor.anchorId = nil
		end
		anchor:ClearAllPoints()
		anchor:Hide()
	end

	local anchorDB = db[unitType]
	if anchorDB.disabled then
		return
	end

	local scale = anchorDB.countdownTextScale
	local width = anchorDB.size * (1 / scale)
	local height = anchorDB.size * (1 / scale)
	local borderScale = width / 32 * 2 -- scale the dispel type border
	if not anchorDB.showBorder then
		borderScale = -10000 -- hide the border
	end
	local unitToken = unitType == "player" and unitType or GetUnitToken(db.otherPlayerType, db.otherPlayerName)

	for index = 1, MAX_AURAS do
		local anchor = anchors[unitType][index]
		if not anchor then
			anchor = CreateFrame("Frame", "BigWigsPrivateAurasAnchor" .. (unitType:gsub("^%l", string.upper)) .. index, UIParent, nil, index)
			anchor:SetFrameStrata("HIGH")
			anchor:SetMovable(true)

			anchor.db = anchorDB
			anchor.unitType = unitType
			anchor.UpdateAnchorPosition = UpdateAnchorPosition

			anchors[unitType][index] = anchor
		end

		anchor:SetSize(width, height)
		anchor:SetScale(scale)
		anchor:UpdateAnchorPosition()
		anchor:Show()

		UpdateTestAura(unitType, index)

		if unitToken and not inConfigureMode then
			-- re-registers on BigWigs_StopConfigureMode, don't really want to spam this when moving anchors or whatnot
			anchor.anchorId = C_UnitAuras.AddPrivateAuraAnchor({
				unitToken = unitToken,
				auraIndex = index,
				parent = anchor,
				showCountdownFrame = anchorDB.showCooldown,
				showCountdownNumbers = anchorDB.showCountdownText,
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
				-- durationAnchor = anchorDB.showDurationText and {
				-- 	point = "TOP",
				-- 	relativeTo = anchor,
				-- 	relativePoint = "BOTTOM",
				-- 	offsetX = 0,
				-- 	offsetY = 0,
				-- } or nil,
			})
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
		frame:SetParent(nil)
		frame:SetScript("OnUpdate", nil)
		frame.cooldown:Clear()
		if frame.timer then
			frame.timer:Cancel()
			frame.timer = nil
		end
		frame:Hide()

		-- pull it out of the active list
		local active = testAuras[frame.unitType]
		for i = #active, 1, -1 do
			if active[i] == frame then
				table.remove(active, i)
				break
			end
		end
		-- and put it back in the pool
		table.insert(auraFramePool, frame)
	end

	-- local function DurationOnUpdate(self)
	-- 	self.duration:SetFormattedText(SecondsToTimeAbbrev(self.timeLeft))
	-- 	self.timeLeft = math.max(self.expirationTime - GetTime(), 0)
	-- end

	local function getTestAura(unitType, index)
		local aura = table.remove(auraFramePool)
		if not aura then
			aura = CreateFrame("Frame", nil, UIParent)
			aura:SetFrameStrata("HIGH")

			local icon = aura:CreateTexture(nil, "BACKGROUND")
			icon:SetAllPoints()
			aura.icon = icon

			local cooldown = CreateFrame("Cooldown", nil, aura, "CooldownFrameTemplate")
			cooldown:SetAllPoints()
			cooldown:SetReverse(true)
			cooldown:SetDrawBling(false)
			cooldown:SetDrawEdge(false)
			aura.cooldown = cooldown

			-- local duration = aura:CreateFontString(nil, "BACKGROUND")
			-- duration:SetPoint("TOP", aura, "BOTTOM", 0, 0)
			-- duration:SetFontObject("GameFontNormalSmall")
			-- duration:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
			-- aura.duration = duration

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
		-- aura.timeLeft = duration
		aura.expirationTime = expirationTime
		aura.timer = plugin:ScheduleTimer(function() releaseFrame(aura) end, duration)
		aura.unitType = unitType

		return aura
	end

	function UpdateTestAura(unitType, index)
		local aura = testAuras[unitType][index]
		if not aura then return end

		local anchorDB = db[unitType]

		if anchorDB.showCooldown then
			aura.cooldown:SetHideCountdownNumbers(not anchorDB.showCountdownText)
			aura.cooldown:SetCooldownFromExpirationTime(aura.expirationTime, CONFIG_MODE_DURATION)
			aura.cooldown:Show()
		else
			aura.cooldown:Hide()
		end

		-- if anchorDB.showDurationText then
		-- 	frame:SetScript("OnUpdate", DurationOnUpdate)
		-- 	DurationOnUpdate(frame, 0)
		-- 	frame.duration:Show()
		-- else
		-- 	frame.duration:SetText("")
		-- 	frame.duration:Hide()
		-- end

		local scale = anchorDB.countdownTextScale
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
		for unitType, unitAnchors in pairs(anchors) do
			if not db[unitType].disabled then
				local auras = testAuras[unitType]

				local aura = getTestAura(unitType, testCount)
				table.insert(auras, 1, aura) -- pop it on
				testCount = testCount + 1
				if testCount > 10 then
					testCount = 1
				end

				for i = 1, math.min(#auras, MAX_AURAS) do
					local frame = auras[i]
					frame:ClearAllPoints()
					frame:SetParent(unitAnchors[i])
					frame:SetPoint("CENTER")
					UpdateTestAura(unitType, i)
				end
				for i = #auras, MAX_AURAS + 1, -1  do
					local frame = auras[i]
					if frame then
						releaseFrame(frame)
					end
				end
			end
		end
	end
end
