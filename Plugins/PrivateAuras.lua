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
local CONFIG_MODE_DURATION = 5

local db
local anchors = {}
local inConfigureMode = false

local UpdateAnchorPosition

--------------------------------------------------------------------------------
-- Profile
--

plugin.defaultDB = {
	disabled = false,
	showDispelType = true,
	iconBorder = true,

	size = 64,
	spacing = 6,
	growthDirection = "RIGHT",
	showCooldown = true,
	showCountdownText = true,
	showDurationText = false,

	anchorPoint = "BOTTOM",
	anchorRelPoint = "TOP",
	anchorXOffset = 0,
	anchorYOffset = -262,
	anchorRelativeTo = "UIParent",
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

	-- TODO more setting validation

	if not db.disabled then
		C_UnitAuras.TriggerPrivateAuraShowDispelType(db.showDispelType)
	end
	plugin:UpdateAnchors()
end

--------------------------------------------------------------------------------
-- Options
--

do
	local function disabled()
		return db.disabled
	end

	plugin.pluginOptions = {
		type = "group",
		name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Private:20|t ".. L.privateAuras,
		childGroups = "tab",
		handler = plugin,
		get = function(info) return db[info[#info]] end,
		set = function(info, value) db[info[#info]] = value end,
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
					C_UnitAuras.TriggerPrivateAuraShowDispelType(db.showDispelType)
				end,
				width = "full",
				order = 3,
				disabled = function() return disabled() or not db.iconBorder end,
			},
			iconBorder = {
				type = "toggle",
				name = L.showBorder,
				desc = L.showBorderDesc,
				set = function(info, value)
					db[info[#info]] = value
					plugin:UpdateAnchors()
				end,
				width = "full",
				order = 4,
				disabled = disabled,
			},
			display = {
				type = "group",
				name = L.general,
				get = function(info)
					return db[info[#info]]
				end,
				set = function(info, value)
					db[info[#info]] = value
					plugin:UpdateAnchors()
				end,
				order = 10,
				args = {
					size = {
						type = "range",
						name = L.iconSize,
						min = 24, max = 512, step = 1,
						width = 1.6,
						order = 1,
						disabled = disabled,
					},
					spacing = {
						type = "range",
						name = L.iconSpacing,
						min = 0, max = 50, step = 1,
						width = 1.6,
						order = 2,
						disabled = disabled,
					},
					showCooldown = {
						type = "toggle",
						name = L.showCooldown,
						width = 1.6,
						order = 3,
						disabled = disabled,
					},
					showCountdownText = {
						type = "toggle",
						name = L.showCountdownText,
						width = 1.6,
						order = 4,
						disabled = function() return disabled() or not db.showCooldown end,
					},
					-- showDurationText = {
					-- 	type = "toggle",
					-- 	name = L.showDurationText,
					-- 	width = 1.6,
					-- 	order = 5,
					-- 	disabled = disabled,
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
						order = 6,
						disabled = disabled,
					},
					resetHeader = {
						type = "header",
						name = "",
						order = 7,
					},
					reset = {
						type = "execute",
						name = L.resetAll,
						desc = L.resetDesc,
						func = function() plugin.db:ResetProfile() updateProfile() end,
						order = 8,
					},
					disabledSpacer = {
						type = "description",
						name = "\n\n\n\n\n\n\n",
						order = 9,
						width = "full",
						fontSize = "medium",
					},
					disabled = {
						type = "toggle",
						name = L.disabled,
						set = function(_, value)
							db.disabled = value
							updateProfile()
						end,
						width = "full",
						order = 10,
						confirm = function(_, value)
							if value then
								return L.disableDesc:format(L.privateAuras)
							end
						end,
					},
				},
			},
			exactPositioning = {
				type = "group",
				name = L.positionExact,
				get = function(info)
					return db[info[#info]]
				end,
				set = function(info, value)
					db[info[#info]] = value
					UpdateAnchorPosition(1)
				end,
				order = 20,
				args = {
					anchorXOffset = {
						type = "range",
						name = L.positionX,
						desc = L.positionDesc,
						min = -2048, max = 2048, step = 1,
						width = 3.2,
						order = 1,
						disabled = disabled,
					},
					anchorYOffset = {
						type = "range",
						name = L.positionY,
						desc = L.positionDesc,
						min = -2048, max = 2048, step = 1,
						width = 3.2,
						order = 2,
						disabled = disabled,
					},
					anchorRelativeTo = {
						type = "input",
						name = L.customAnchorPoint,
						set = function(_, value)
							if value ~= plugin.defaultDB.anchorRelativeTo then
								db.anchorPoint = "CENTER"
								db.anchorRelPoint = "CENTER"
								db.anchorXOffset = 0
								db.anchorYOffset = 0
								db.anchorRelativeTo = value
							else
								db.anchorPoint = plugin.defaultDB.anchorPoint
								db.anchorRelPoint = plugin.defaultDB.anchorRelPoint
								db.anchorXOffset = plugin.defaultDB.anchorXOffset
								db.anchorYOffset = plugin.defaultDB.anchorYOffset
								db.anchorRelativeTo = plugin.defaultDB.anchorRelativeTo
							end
							UpdateAnchorPosition(1)
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
						disabled = disabled,
					},
					anchorPoint = {
						type = "select",
						name = L.sourcePoint,
						values = BigWigsAPI.GetFramePointList(),
						width = 1.6,
						order = 4,
						disabled = function() return disabled() or db.anchorRelativeTo == plugin.defaultDB.anchorRelativeTo end,
					},
					anchorRelPoint = {
						type = "select",
						name = L.destinationPoint,
						values = BigWigsAPI.GetFramePointList(),
						width = 1.6,
						order = 5,
						disabled = function() return disabled() or db.anchorRelativeTo == plugin.defaultDB.anchorRelativeTo end,
					},
				},
			},
		},
	}

	local function OnDragStart(self)
		anchors[1]:StartMoving()
	end
	local function OnDragStop(self)
		local anchor = anchors[1]
		anchor:StopMovingOrSizing()
		local point, _, relPoint, x, y = anchor:GetPoint()
		x = math.floor(x + 0.5)
		y = math.floor(y + 0.5)

		db.anchorPoint = point
		db.anchorRelPoint = relPoint
		db.anchorXOffset = x
		db.anchorYOffset = y
		UpdateAnchorPosition(1)

		if BigWigsOptions and BigWigsOptions:IsOpen() then
			plugin:UpdateGUI()
		end
	end

	local function createDragAnchor(anchor, index)
		local display = CreateFrame("Frame", nil, UIParent)
		display:SetPoint("TOPLEFT", anchor)
		display:SetPoint("BOTTOMRIGHT", anchor)
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
		header:SetText(L.privateAurasTestAnchorText:format(index))
		header:SetPoint("CENTER", display, "CENTER")
		header:SetJustifyH("CENTER")
		header:SetJustifyV("MIDDLE")

		return display
	end

	function plugin:BigWigs_StartConfigureMode(_, mode)
		if mode and mode ~= self.moduleName then return end
		inConfigureMode = true

		for index, anchor in ipairs(anchors) do
			if not anchor.configMode then
				anchor.configMode = createDragAnchor(anchor, index)
			end
			anchor.configMode:Show()
		end
	end

	function plugin:BigWigs_StopConfigureMode(_, mode)
		if mode and mode ~= self.moduleName then return end
		inConfigureMode = false

		for _, anchor in ipairs(anchors) do
			if anchor.configMode then
				anchor.configMode:Hide()
			end
		end

		self:UpdateAnchors()
	end
end

--------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnRegister()
	self.displayName = L.privateAuras
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_OnPluginDisable", "RemoveAnchors")
	self:RegisterMessage("BigWigs_StartConfigureMode")
	self:RegisterMessage("BigWigs_StopConfigureMode")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()
end

--------------------------------------------------------------------------------
-- Anchors
--

function UpdateAnchorPosition(index)
	local anchor = anchors[index]
	if not anchor then return end

	anchor:ClearAllPoints()
	if index == 1 then
		local relativeTo = db.anchorRelativeTo
		local point, relPoint = db.anchorPoint, db.anchorRelPoint
		local x, y = db.anchorXOffset, db.anchorYOffset
		anchor:SetPoint(point, relativeTo, relPoint, x, y)
	else
		local relativeTo = anchors[index - 1]
		local point, relPoint
		local x, y = 0, 0
		if db.growthDirection == "RIGHT" then
			point, relPoint = "LEFT", "RIGHT"
			x = db.spacing
		elseif db.growthDirection == "LEFT" then
			point, relPoint = "RIGHT", "LEFT"
			x = -db.spacing
		elseif db.growthDirection == "UP" then
			point, relPoint = "BOTTOM", "TOP"
			y = db.spacing
		elseif db.growthDirection == "DOWN" then
			point, relPoint = "TOP", "BOTTOM"
			y = -db.spacing
		end
		anchor:SetPoint(point, relativeTo, relPoint, x, y)
	end
end

function plugin:RemoveAnchors()
	for index, anchor in next, anchors do
		if anchor.anchorId then
			C_UnitAuras.RemovePrivateAuraAnchor(anchor.anchorId)
			anchor.anchorId = nil
		end
		anchor:ClearAllPoints()
		anchor:Hide()
	end
end

function plugin:UpdateAnchors()
	self:RemoveAnchors()

	if db.disabled then
		return
	end

	local width = db.size
	local height = db.size
	local borderScale = db.size / 32 * 2 -- scale the dispel type border
	if not db.iconBorder then
		borderScale = -10000 -- hide the border
	end

	for index = 1, MAX_AURAS do
		local anchor = anchors[index]
		if not anchor then
			anchor = CreateFrame("Frame", "BigWigsPrivateAurasAnchor" .. index, UIParent)
			anchor:SetFrameStrata("HIGH")
			anchor:SetMovable(true)
			-- anchor:SetResizable(true)
			anchors[index] = anchor
		end
		UpdateAnchorPosition(index)

		anchor:SetSize(width, height)
		anchor:Show()

		if not inConfigureMode then -- re-registers on BigWigs_StopConfigureMode
			anchor.anchorId = C_UnitAuras.AddPrivateAuraAnchor({
				unitToken = "player",
				auraIndex = index,
				parent = anchor,
				showCountdownFrame = db.showCooldown,
				showCountdownNumbers = db.showCountdownText,
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
				-- durationAnchor = db.showDurationText and {
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
	local testCount = 1
	local testAuras = {}

	local dispelTypeList = { "Magic", "Curse", "Disease", "Poison", "Enrage", "Bleed", [0] = "None" }
	local privateAuraSpellList = { 407221, 418720, 421828, 428970, 406317 }

	local icons = {}
	local function releaseFrame(frame)
		frame:ClearAllPoints()
		frame:SetScript("OnUpdate", nil)
		frame.cooldown:Clear()
		frame:Hide()
		if frame.timer then
			frame.timer:Cancel()
			frame.timer = nil
		end

		-- pull it out of the active list
		for i = #testAuras, 1, -1 do
			if testAuras[i] == frame then
				table.remove(testAuras, i)
				break
			end
		end
		-- and put it back in the pool
		table.insert(icons, frame)
	end

	local function DurationOnUpdate(self)
		self.duration:SetFormattedText(SecondsToTimeAbbrev(self.timeLeft))
		self.timeLeft = math.max(self.expirationTime - GetTime(), 0)
	end

	local function getDebuffFrame(index)
		local frame = table.remove(icons)
		if not frame then
			frame = CreateFrame("Frame", nil, UIParent)
			frame:SetFrameStrata("HIGH")

			local icon = frame:CreateTexture(nil, "BACKGROUND")
			icon:SetAllPoints()
			frame.icon = icon

			local cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
			cooldown:SetAllPoints()
			cooldown:SetReverse(true)
			cooldown:SetDrawBling(false)
			cooldown:SetDrawEdge(false)
			frame.cooldown = cooldown

			local duration = frame:CreateFontString(nil, "BACKGROUND")
			duration:SetPoint("TOP", frame, "BOTTOM", 0, 0)
			duration:SetFontObject("GameFontNormalSmall")
			duration:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
			frame.duration = duration

			local dispelIcon = frame:CreateTexture(nil, "OVERLAY")
			dispelIcon:SetPoint("CENTER")
			frame.dispelIcon = dispelIcon
		end

		-- Set our aura values
		local spellIndex = (index - 1) % #privateAuraSpellList + 1
		local icon = C_Spell.GetSpellTexture(privateAuraSpellList[spellIndex])
		local dispelType = dispelTypeList[(index - 1) % 7]
		local duration = CONFIG_MODE_DURATION
		local expirationTime = GetTime() + duration

		-- Setup the fake private aura
		frame.icon:SetTexture(icon)

		if db.showCooldown then
			frame.cooldown:SetHideCountdownNumbers(not db.showCountdownText)
			frame.cooldown:SetCooldownDuration(duration)
			frame.cooldown:Show()
		else
			frame.cooldown:Hide()
		end

		if db.showDurationText then
			frame.timeLeft = duration
			frame.expirationTime = expirationTime
			frame:SetScript("OnUpdate", DurationOnUpdate)
			DurationOnUpdate(frame, 0)
			frame.duration:Show()
		else
			frame.duration:SetText("")
			frame.duration:Hide()
		end

		frame.timer = C_Timer.NewTimer(duration, function()
			releaseFrame(frame)
		end)

		if db.iconBorder then
			-- Apply the dispel type border (from Blizzard_PrivateAurasUI)
			local borderScale = db.size / 32 * 2
			local borderSize = db.size + (5 * borderScale)
			frame.dispelIcon:SetSize(borderSize, borderSize)
			local DEBUFF_DISPLAY_INFO = AuraUtil.GetDebuffDisplayInfoTable()
			local info = DEBUFF_DISPLAY_INFO[dispelType] or DEBUFF_DISPLAY_INFO.None
			local atlas = db.showDispelType and info.dispelAtlas or info.basicAtlas
			frame.dispelIcon:SetAtlas(atlas)
			frame.dispelIcon:Show()
		else
			frame.dispelIcon:Hide()
		end

		return frame
	end

	function plugin:CreateTestAura()
		table.insert(testAuras, 1, getDebuffFrame(testCount)) -- pop it on
		testCount = testCount + 1
		if testCount > 10 then
			testCount = 1
		end

		for i = 1, math.min(#testAuras, MAX_AURAS) do
			local frame = testAuras[i]
			frame:ClearAllPoints()
			frame:SetPoint("CENTER", anchors[i], "CENTER")
			frame:SetSize(db.size, db.size)
			frame:Show()
		end
		for i = #testAuras, MAX_AURAS + 1, -1  do
			releaseFrame(testAuras[i])
		end
	end
end
