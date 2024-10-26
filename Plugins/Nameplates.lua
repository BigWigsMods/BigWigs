--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Nameplates")
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
plugin.displayName = L.nameplates

local db = nil
local media = LibStub("LibSharedMedia-3.0")
local FONT = media.MediaType and media.MediaType.FONT or "font"

local nameplateIcons, iconFrameCache, nameplateTexts, textFrameCache = {}, {}, {}, {}
local startNameplateIcon, showNameplateText
local rearrangeNameplateIcons, rearrangeNameplateTexts
local removeFrame, frameStopped

local validFramePoints = {
	["TOPLEFT"] = L.TOPLEFT, ["TOPRIGHT"] = L.TOPRIGHT, ["BOTTOMLEFT"] = L.BOTTOMLEFT, ["BOTTOMRIGHT"] = L.BOTTOMRIGHT,
	["TOP"] = L.TOP, ["BOTTOM"] = L.BOTTOM, ["LEFT"] = L.LEFT, ["RIGHT"] = L.RIGHT, ["CENTER"] = L.CENTER,
}
local validGrowDirections = {
	RIGHT = L.RIGHT,
	LEFT = L.LEFT,
	UP = L.UP,
	DOWN = L.DOWN,
}
local inverseAnchorPoint = {
	TOPLEFT = "BOTTOMRIGHT",
	TOPRIGHT = "BOTTOMLEFT",
	BOTTOMLEFT = "TOPRIGHT",
	BOTTOMRIGHT = "TOPLEFT",
	TOP = "BOTTOM",
	BOTTOM = "TOP",
	LEFT = "RIGHT",
	RIGHT = "LEFT",
	CENTER = "CENTER",
}
local glowValues = {
	pixel = L.pixelGlow,
	autocast = L.autocastGlow,
	buttoncast = L.buttonGlow,
	proc = L.procGlow,
}

local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local GetCVar = C_CVar.GetCVar
local UnitCanAttack = BigWigsLoader.UnitCanAttack
local UnitTokenFromGUID = BigWigsLoader.UnitTokenFromGUID

local LibCustomGlow = LibStub("LibCustomGlow-1.0")
local glowFunctions = {
	pixel = LibCustomGlow.PixelGlow_Start,
	autocast = LibCustomGlow.AutoCastGlow_Start,
	buttoncast = LibCustomGlow.ButtonGlow_Start,
	proc = LibCustomGlow.ProcGlow_Start
}
local glowStopFunctions = {
	pixel = LibCustomGlow.PixelGlow_Stop,
	autocast = LibCustomGlow.AutoCastGlow_Stop,
	buttoncast = LibCustomGlow.ButtonGlow_Stop,
	proc = LibCustomGlow.ProcGlow_Stop
}

--------------------------------------------------------------------------------
-- Profile
--

local iconDefaults = {
	iconGrowDirection = "LEFT",
	iconGrowDirectionStart = "LEFT",
	iconSpacing = 1,
	iconWidth = 15,
	iconHeight = 15,
	iconOffsetX = 0,
	iconOffsetY = 0,
	iconAutoScale = true,
	iconCooldownNumbers = true,
	iconFontName = "Noto Sans Regular", -- Only dealing with numbers so we can use this on all locales
	iconFontSize = 7,
	iconFontColor = {1, 1, 1, 1},
	iconFontOutline = "OUTLINE",
	iconFontMonochrome = false,
	iconCooldownEdge = true,
	iconCooldownSwipe = true,
	iconCooldownInverse = false,
	iconExpireGlow = true,
	iconExpireGlowType = "pixel",
	iconZoom = 0,
	iconAspectRatio = true,
	iconDesaturate = false,
	iconColor = {1, 1, 1, 1},
	iconGlowColor = {0.95, 0.95, 0.32, 1},
	iconGlowFrequency = 0.25,
	iconGlowPixelLines = 8,
	iconGlowPixelLength = 4,
	iconGlowPixelThickness = 1,
	iconGlowAutoCastParticles = 8,
	iconGlowAutoCastScale = 1,
	iconGlowProcStartAnim = true,
	iconGlowProcAnimDuration = 1,
	iconGlowTimeLeft = 0,
	iconBorder = true,
	iconBorderSize = 1,
	iconBorderColor = {0, 0, 0, 1},
}

local textDefaults = {
	textGrowDirection = "UP",
	textGrowDirectionStart = "TOP",
	textSpacing = 0,
	textOffsetX = 0,
	textOffsetY = 0,
	textFontName = plugin:GetDefaultFont(),
	textFontSize = 18,
	textFontColor = {1, 1, 1, 1},
	textOutline = "THICKOUTLINE",
	textMonochrome = false,
	textUppercase = true,
}

plugin.defaultDB = {
}
for k, v in next, iconDefaults do
	plugin.defaultDB[k] = v
end
for k, v in next, textDefaults do
	plugin.defaultDB[k] = v
end

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

	if not validGrowDirections[db.iconGrowDirection] then
		db.iconGrowDirection = plugin.defaultDB.iconGrowDirection
	end
	if not validFramePoints[db.iconGrowDirectionStart] then
		db.iconGrowDirectionStart = plugin.defaultDB.iconGrowDirectionStart
	end
	if db.iconSpacing < 0 or db.iconSpacing > 20 then
		db.iconSpacing = plugin.defaultDB.iconSpacing
	end
	if db.iconWidth < 12 or db.iconWidth > 50 then
		db.iconWidth = plugin.defaultDB.iconWidth
	end
	if db.iconHeight < 12 or db.iconHeight > 50 then
		db.iconHeight = plugin.defaultDB.iconHeight
	end
	if db.iconOffsetX < -100 or db.iconOffsetX > 100 then
		db.iconOffsetX = plugin.defaultDB.iconOffsetX
	end
	if db.iconOffsetY < -100 or db.iconOffsetY > 100 then
		db.iconOffsetY = plugin.defaultDB.iconOffsetY
	end
	if not media:IsValid(FONT, db.iconFontName) then
		db.iconFontName = plugin.defaultDB.iconFontName
	end
	if db.iconFontSize < 6 or db.iconFontSize > 200 then
		db.iconFontSize = plugin.defaultDB.iconFontSize
	end
	for i = 1, 4 do
		local n = db.iconFontColor[i]
		if type(n) ~= "number" or n < 0 or n > 1 then
			db.iconFontColor = plugin.defaultDB.iconFontColor
			break -- If 1 entry is bad, reset the whole table
		end
	end
	if db.iconFontOutline ~= "NONE" and db.iconFontOutline ~= "OUTLINE" and db.iconFontOutline ~= "THICKOUTLINE" then
		db.iconFontOutline = plugin.defaultDB.iconFontOutline
	end
	if not glowValues[db.iconExpireGlowType] then
		db.iconExpireGlowType = plugin.defaultDB.iconExpireGlowType
	end
	if db.iconGlowFrequency < -2 or db.iconGlowFrequency > 2 then
		db.iconGlowFrequency = plugin.defaultDB.iconGlowFrequency
	end
	if db.iconGlowPixelLines < 1 or db.iconGlowPixelLines > 15 then
		db.iconGlowPixelLines = plugin.defaultDB.iconGlowPixelLines
	end
	if db.iconGlowPixelLength < 1 or db.iconGlowPixelLength > 20 then
		db.iconGlowPixelLength = plugin.defaultDB.iconGlowPixelLength
	end
	if db.iconGlowPixelThickness < 1 or db.iconGlowPixelThickness > 5 then
		db.iconGlowPixelThickness = plugin.defaultDB.iconGlowPixelThickness
	end
	if db.iconGlowAutoCastParticles < 1 or db.iconGlowAutoCastParticles > 15 then
		db.iconGlowAutoCastParticles = plugin.defaultDB.iconGlowAutoCastParticles
	end
	if db.iconGlowAutoCastScale < 0.5 or db.iconGlowAutoCastScale > 3 then
		db.iconGlowAutoCastScale = plugin.defaultDB.iconGlowAutoCastScale
	end
	if db.iconGlowProcAnimDuration < 0.1 or db.iconGlowProcAnimDuration > 3 then
		db.iconGlowProcAnimDuration = plugin.defaultDB.iconGlowProcAnimDuration
	end
	if db.iconGlowTimeLeft < 0 or db.iconGlowTimeLeft > 3 then
		db.iconGlowTimeLeft = plugin.defaultDB.iconGlowTimeLeft
	end
	if db.iconZoom < 0 or db.iconZoom > 0.5 then
		db.iconZoom = plugin.defaultDB.iconZoom
	end
	for i = 1, 4 do
		local n = db.iconColor[i]
		if type(n) ~= "number" or n < 0 or n > 1 then
			db.iconColor = plugin.defaultDB.iconColor
			break -- If 1 entry is bad, reset the whole table
		end
	end
	if db.iconColor[4] < 0.3 then -- Limit lowest alpha value
		db.iconColor = plugin.defaultDB.iconColor
	end
	for i = 1, 4 do
		local n = db.iconGlowColor[i]
		if type(n) ~= "number" or n < 0 or n > 1 then
			db.iconGlowColor = plugin.defaultDB.iconGlowColor
			break -- If 1 entry is bad, reset the whole table
		end
	end
	if db.iconBorderSize < 1 or db.iconBorderSize > 5 then
		db.iconBorderSize = plugin.defaultDB.iconBorderSize
	end
	for i = 1, 4 do
		local n = db.iconBorderColor[i]
		if type(n) ~= "number" or n < 0 or n > 1 then
			db.iconBorderColor = plugin.defaultDB.iconBorderColor
			break -- If 1 entry is bad, reset the whole table
		end
	end

	if not validGrowDirections[db.textGrowDirection] then
		db.textGrowDirection = plugin.defaultDB.textGrowDirection
	end
	if not validFramePoints[db.textGrowDirectionStart] then
		db.textGrowDirectionStart = plugin.defaultDB.textGrowDirectionStart
	end
	if db.textSpacing < 0 or db.textSpacing > 20 then
		db.textSpacing = plugin.defaultDB.textSpacing
	end
	if db.textOffsetX < -150 or db.textOffsetX > 150 then
		db.textOffsetX = plugin.defaultDB.textOffsetX
	end
	if db.textOffsetY < -150 or db.textOffsetY > 150 then
		db.textOffsetY = plugin.defaultDB.textOffsetY
	end
	if not media:IsValid(FONT, db.textFontName) then
		db.textFontName = plugin:GetDefaultFont()
	end
	if db.textFontSize < 10 or db.textFontSize > 200 then
		db.textFontSize = plugin.defaultDB.textFontSize
	end
	for i = 1, 4 do
		local n = db.textFontColor[i]
		if type(n) ~= "number" or n < 0 or n > 1 then
			db.textFontColor = plugin.defaultDB.textFontColor
			break -- If 1 entry is bad, reset the whole table
		end
	end
	if db.textFontColor[4] < 0.3 then -- Limit lowest alpha value
		db.textFontColor = plugin.defaultDB.textFontColor
	end
	if db.textOutline ~= "NONE" and db.textOutline ~= "OUTLINE" and db.textOutline ~= "THICKOUTLINE" then
		db.textOutline = plugin.defaultDB.textOutline
	end
end

local function setDefaults(options)
	local defaults = options
	for k, value in next, defaults do
		db[k] = value
	end
	updateProfile()
end

--------------------------------------------------------------------------------
-- Text Frames
--

local function getTextFrame()
	local textFrame

	if next(textFrameCache) then
		textFrame = table.remove(textFrameCache)
	else
		textFrame = CreateFrame("Frame", nil, UIParent)
		textFrame:SetPoint("CENTER")
		textFrame:SetFrameStrata("MEDIUM")
		textFrame:SetFixedFrameStrata(true)
		textFrame:SetFrameLevel(5600)
		textFrame:SetFixedFrameLevel(true)

		local fontString = textFrame:CreateFontString()
		fontString:SetPoint("CENTER")
		fontString:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
		textFrame.fontString = fontString
	end

	function textFrame:SetText(text)
		local textString = text
		if db.textUppercase then
			textString = string.upper(textString)
			textString = string.gsub(textString, "(:%d+|)T", "%1t") -- Fix texture paths that need to end in lowercase |t
		end
		self.fontString:SetText(textString)
		local flags = nil
		if db.textMonochrome and db.textOutline ~= "NONE" then
			flags = "MONOCHROME," .. db.textOutline
		elseif db.textMonochrome then
			flags = "MONOCHROME"
		elseif db.textOutline ~= "NONE" then
			flags = db.textOutline
		end
		self.fontString:SetFont(media:Fetch(FONT, db.textFontName), db.textFontSize, flags)
		self.fontString:SetTextColor(db.textFontColor[1], db.textFontColor[2], db.textFontColor[3], db.textFontColor[4])
		local w, h = self.fontString:GetWidth(), self.fontString:GetHeight()
		self:SetSize(w, h)
	end

	function textFrame:Set(key, data)
		if not self.data then
			self.data = {}
		end
		self.data[key] = data
	end

	function textFrame:Get(key)
		return self.data and self.data[key]
	end

	function textFrame:SetDuration(duration)
		local time = GetTime()
		if type(duration) == "table" then
			self.expires = time + duration[1]
		else
			self.expires = time + duration
		end
	end

	function textFrame:GetRemaining()
		return self.expires - GetTime()
	end

	function textFrame:HideFrame()
		self:Hide()
		table.insert(textFrameCache, self)
	end

	function textFrame:StartNameplate()
		self:Show()
	end

	function textFrame:StopNameplate()
		self:HideFrame()
		frameStopped(self, true)
	end

	return textFrame
end

--------------------------------------------------------------------------------
-- Icon Frames
--

local function iconLoop(updater)
	local iconFrame = updater.parent
	iconFrame.repeater:SetStartDelay(1)

	-- Rounding to 1 decimal place first as the timer is not precise to the 10000th of a second
	-- This fixes things if there is 0.0000003 left when it would tick
	local remaining = math.floor(iconFrame:GetRemaining() * 10 + 0.5) / 10
	local timeToDisplay = math.ceil(remaining)
	if timeToDisplay > 0 then
		if db.iconCooldownNumbers then
			iconFrame.countdownNumber:SetText(timeToDisplay)
		end
		if db.iconGlowTimeLeft > 0 and timeToDisplay <= db.iconGlowTimeLeft and not iconFrame.activeGlow then
			iconFrame:StartGlow(db.iconExpireGlowType)
		end
	else
		iconFrame.countdownNumber:Hide()
		iconFrame.updater:Stop()
		if db.iconExpireGlow and not iconFrame.activeGlow then
			iconFrame:StartGlow(db.iconExpireGlowType)
		end
	end
end

local function GetBorderBackdrop(size)
	local borderBackdrop = {
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		edgeSize = size,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	}
	return borderBackdrop
end

local function getGlowSettings(glowType)
	if glowType == "pixel" then
		return {db.iconGlowColor, db.iconGlowPixelLines, db.iconGlowFrequency, db.iconGlowPixelLength, db.iconGlowPixelThickness}
	elseif glowType == "autocast" then
		return {db.iconGlowColor, db.iconGlowAutoCastParticles, db.iconGlowFrequency, db.iconGlowAutoCastScale}
	elseif glowType == "proc" then
		return {{color = db.iconGlowColor, startAnim = db.iconGlowProcStartAnim, duration = db.iconGlowProcAnimDuration}}
	elseif glowType == "buttoncast" then
		return {db.iconGlowColor, db.iconGlowFrequency}
	end
end

local function getIconFrame()
	local iconFrame

	if next(iconFrameCache) then
		iconFrame = table.remove(iconFrameCache)
	else
		iconFrame = CreateFrame("Frame", nil, UIParent)
		iconFrame:SetPoint("CENTER")
		iconFrame:SetIgnoreParentScale(true)
		iconFrame:SetFrameStrata("MEDIUM")
		iconFrame:SetFixedFrameStrata(true)
		iconFrame:SetFrameLevel(5500)
		iconFrame:SetClampedToScreen(true)
		iconFrame:SetSize(db.iconWidth, db.iconHeight)

		local icon = iconFrame:CreateTexture()
		icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
		icon:SetSnapToPixelGrid(false)
		icon:SetTexelSnappingBias(0)
		icon:SetAllPoints(iconFrame)
		iconFrame.icon = icon

		local cooldown = CreateFrame("Cooldown", nil, iconFrame, "CooldownFrameTemplate")
		iconFrame.cooldown = cooldown
		cooldown:SetAllPoints(icon)
		cooldown:SetDrawBling(false)
		cooldown:SetDrawEdge(db.iconCooldownEdge)
		cooldown:SetDrawSwipe(db.iconCooldownSwipe)
		cooldown:SetReverse(db.iconCooldownInverse)
		cooldown:SetHideCountdownNumbers(true) -- Blizzard
		cooldown.noCooldownCount = true -- OmniCC

		local countdownNumber = cooldown:CreateFontString(nil, "OVERLAY")
		countdownNumber:SetPoint("CENTER")
		countdownNumber:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
		countdownNumber:SetJustifyH("CENTER")
		iconFrame.countdownNumber = countdownNumber

		local border = CreateFrame("Frame", nil, iconFrame, "BackdropTemplate")
		border:SetPoint("TOPLEFT", iconFrame, "TOPLEFT")
		border:SetPoint("BOTTOMRIGHT", iconFrame, "BOTTOMRIGHT")
		border:Hide()
		iconFrame.border = border

		local updater = iconFrame:CreateAnimationGroup()
		updater:SetLooping("REPEAT")
		updater.parent = iconFrame
		updater:SetScript("OnLoop", iconLoop)
		local anim = updater:CreateAnimation()
		anim:SetDuration(0)
		iconFrame.updater = updater
		iconFrame.repeater = anim
	end

	function iconFrame:SetDuration(duration)
		self.countdownNumber:Hide()
		self.cooldown:Clear()
		local startTime, fullDuration
		local time = GetTime()
		if type(duration) == "table" then
			self.expires = time + duration[1]
			fullDuration = duration[2]
			startTime = self.expires - duration[2]
		else
			self.expires = time + duration
			fullDuration = duration
			startTime = time
		end
		local remaining = self:GetRemaining()
		if remaining > 0 then
			self.cooldown:SetCooldown(startTime, fullDuration)
			if db.iconCooldownNumbers then
				local flags = nil
				if db.iconFontMonochrome and db.iconFontOutline ~= "NONE" then
					flags = "MONOCHROME," .. db.iconFontOutline
				elseif db.iconFontMonochrome then
					flags = "MONOCHROME"
				elseif db.iconFontOutline ~= "NONE" then
					flags = db.iconFontOutline
				end
				self.countdownNumber:SetFont(media:Fetch(FONT, db.iconFontName), db.iconFontSize, flags)
				self.countdownNumber:SetTextColor(db.iconFontColor[1], db.iconFontColor[2], db.iconFontColor[3], db.iconFontColor[4])

				local timeToDisplay = math.ceil(remaining)
				self.countdownNumber:SetText(timeToDisplay)
				self.countdownNumber:Show()
			end
		end
	end

	function iconFrame:Set(key, data)
		if not self.data then
			self.data = {}
		end
		self.data[key] = data
	end

	function iconFrame:Get(key)
		return self.data and self.data[key]
	end

	function iconFrame:SetIcon(icon)
		self.icon:SetTexture(icon)
		-- icon aspect ratio and zoom calcs
		local baseZoom = 0.86 -- (0.07, 0.93, 0.07, 0.93) is the default texture coords
		local zoom = baseZoom * (1 - db.iconZoom)
		local zoomedOffset = 1 - ((1 - zoom) / 2)
		local offsetX, offsetY = zoomedOffset, zoomedOffset

		if db.iconAspectRatio then
			local width, height = self:GetSize()
			if width > height then
				offsetY = 1 - (1 - (height / width) * zoom) / 2
			elseif height > width then
				offsetX = 1 - (1 - (width / height) * zoom) / 2
			end
		end

		local left, right, top, bottom = 1 - offsetX, offsetX, 1 - offsetY, offsetY
		self.icon:SetTexCoord(left, right, top, bottom)
	end

	function iconFrame:SetIconColor(r, g, b, a)
		self.icon:SetVertexColor(r, g, b, a)
	end

	function iconFrame:SetDesaturated(desaturate)
		self.icon:SetDesaturated(desaturate)
	end

	function iconFrame:ShowBorder(show, color)
		if show then
			self.border:SetBackdrop(GetBorderBackdrop(db.iconBorderSize))
			self.border:SetBackdropBorderColor(color[1], color[2], color[3], color[4])
			self.border:Show()
		else
			self.border:Hide()
		end
	end

	function iconFrame:StartGlow(glowType)
		self:StopGlows()
		local glowFunction = glowFunctions[glowType]
		local glowOptions = getGlowSettings(glowType)
		if glowFunction then
			self.glowTimer = C_Timer.NewTimer(0.05, function() -- delay so the frame is shown before the glow
				glowFunction(self, unpack(glowOptions))
				self.activeGlow = glowType
			 end)
		end
	end

	function iconFrame:StopGlows()
		if self.glowTimer then
			self.glowTimer:Cancel()
			self.glowTimer = nil
		end
		if not self.activeGlow then return end
		local stopFunction = glowStopFunctions[self.activeGlow]
		if stopFunction then
			stopFunction(self)
		end
		self.activeGlow = nil
	end

	function iconFrame:Start()
		local remaining = self:GetRemaining()
		local startDelay = remaining - math.floor(remaining)
		self.repeater:SetStartDelay(startDelay)
		self.updater:Play()

		if remaining <= 0 then
			self.countdownNumber:Hide()
			if db.iconExpireGlow and not iconFrame.activeGlow then
				self:StartGlow(db.iconExpireGlowType)
			end
		elseif db.iconCooldownNumbers then
			self.countdownNumber:Show()
		end
		self:Show()
	end

	function iconFrame:GetRemaining()
		return self.expires - GetTime()
	end

	function iconFrame:HideFrame()
		self:StopGlows()
		self.updater:Stop()
		self:Hide()
		table.insert(iconFrameCache, self)
	end

	function iconFrame:StopNameplate()
		self:HideFrame()
		frameStopped(self)
	end

	return iconFrame
end

--------------------------------------------------------------------------------
-- Options
--

do
	local function resetNameplates()
		local guids = {}
		for guid, _ in next, nameplateIcons do
			guids[guid] = true
		end
		for guid, _ in next, nameplateTexts do
			guids[guid] = true
		end
		for guid in next, guids do
			local unit = UnitTokenFromGUID(guid)
			if unit and UnitCanAttack("player", unit) then -- Mind control protection
				plugin:NAME_PLATE_UNIT_REMOVED(nil, unit)
				plugin:NAME_PLATE_UNIT_ADDED(nil, unit)
			end
		end
	end

	local checkCooldownTimerDisabled = function() return not db.iconCooldownNumbers end

	local testCount = 0
	local testIcons = {
		"Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_legacy.tga",
		"Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid.tga",
		"Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_party.tga",
	}
	plugin.pluginOptions = {
		type = "group",
		name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Nameplates:20|t ".. L.nameplates,
		childGroups = "tab",
		get = function(info)
			return db[info[#info]]
		end,
		set = function(info, value)
			db[info[#info]] = value
			updateProfile()
		end,
		order = 2,
		args = {
			testIconButton = {
				type = "execute",
				name = L.testNameplateIconBtn,
				desc = L.testNameplateIconBtn_desc,
				func = function()
					local guid = plugin:UnitGUID("target")
					if guid and UnitCanAttack("player", "target") then
						testCount = testCount + 1
						local testNumber = (testCount%3)+1
						local key = "test"..testNumber
						startNameplateIcon(plugin, guid, key, random(50, 200)/10, testIcons[testNumber])
					else
						BigWigs:Print(L.noNameplateTestTarget)
					end
				end,
				width = 1,
				order = 1,
			},
			testTextButton = {
				type = "execute",
				name = L.testNameplateTextBtn,
				desc = L.testNameplateTextBtn_desc,
				func = function()
					local guid = plugin:UnitGUID("target")
					if guid and UnitCanAttack("player", "target") then
						for i = 1, 40 do
							local unit = ("nameplate%d"):format(i)
							if plugin:UnitGUID(unit) == guid then
								testCount = testCount + 1
								local testNumber = (testCount%3)+1
								local key = "test"..testNumber
								showNameplateText(plugin, guid, key, 5, L.fixate_test, true)
							end
						end
					else
						BigWigs:Print(L.noNameplateTestTarget)
					end
				end,
				width = 1,
				order = 2,
			},
			stopTestButton = {
				type = "execute",
				name = L.stopTestNameplateBtn,
				desc = L.stopTestNameplateBtn_desc,
				func = function()
					plugin:StopModuleNameplates(nil, plugin)
				end,
				width = 1,
				order = 3,
			},
			nameplateIconSettings = {
				type = "group",
				name = L.nameplateIconSettings,
				childGroups = "tab",
				order = 10,
				set = function(info, value)
					db[info[#info]] = value
					resetNameplates()
				end,
				args = {
					general = {
						type = "group",
						name = L.general,
						order = 1,
						args = {
							anchoringHeader = {
								type = "header",
								name = L.anchoring,
								order = 1,
								width = "full",
							},
							iconGrowDirectionStart = {
								type = "select",
								values = validFramePoints,
								name = L.growStartPosition,
								desc = L.growStartPositionDesc,
								order = 2,
								width = 1.5,
							},
							iconGrowDirection = {
								type = "select",
								name = L.growDirection,
								desc = L.growDirectionDesc,
								order = 3,
								width = 1.5,
								values = validGrowDirections,
							},
							iconOffsetX = {
								type = "range",
								name = L.positionX,
								desc = L.positionDesc,
								order = 4,
								max = 100,
								min = -100,
								step = 1,
								width = 1,
							},
							iconOffsetY = {
								type = "range",
								name = L.positionY,
								desc = L.positionDesc,
								order = 5,
								max = 100,
								min = -100,
								step = 1,
								width = 1,
							},
							iconSpacing = {
								type = "range",
								name = L.spacing,
								desc = L.iconSpacingDesc,
								order = 6,
								min = 0,
								max = 20,
								step = 1,
								width = 1,
							},
							iconHeader = {
								type = "header",
								name = L.icon,
								order = 10,
							},
							iconWidth = {
								type = "range",
								name = L.width,
								order = 11,
								min = 12,
								max = 50,
								step = 1,
								width = 1,
							},
							iconHeight = {
								type = "range",
								name = L.height,
								order = 12,
								min = 12,
								max = 50,
								step = 1,
								width = 1,
							},
							iconAspectRatio = {
								type = "toggle",
								name = L.keepAspectRatio,
								desc = L.keepAspectRatioDesc,
								order = 13,
								width = 1,
							},
							iconColor = {
								type = "color",
								name = L.iconColor,
								desc = L.iconColorDesc,
								order = 14,
								hasAlpha = true,
								width = 1,
								get = function()
									return db.iconColor[1], db.iconColor[2], db.iconColor[3], db.iconColor[4]
								end,
								set = function(_, r, g, b, a)
									db.iconColor = {r, g, b, a < 0.3 and 0.3 or a}
									resetNameplates()
								end,
							},
							iconDesaturate = {
								type = "toggle",
								name = L.desaturate,
								desc = L.desaturateDesc,
								order = 15,
								width = 1,
							},
							iconZoom = {
								type = "range",
								name = L.zoom,
								desc = L.zoomDesc,
								order = 16,
								min = 0,
								max = 0.5,
								step = 0.01,
								width = 1,
								isPercent = true,
							},
							iconBorder = {
								type = "toggle",
								name = L.showBorder,
								desc = L.showBorderDesc,
								order = 17,
								width = 1,
							},
							iconBorderColor = {
								type = "color",
								name = L.borderColor,
								order = 18,
								hasAlpha = true,
								width = 1,
								disabled = function() return not db.iconBorder end,
								get = function()
									return db.iconBorderColor[1], db.iconBorderColor[2], db.iconBorderColor[3], db.iconBorderColor[4]
								end,
								set = function(_, r, g, b, a)
									db.iconBorderColor = {r, g, b, a}
									resetNameplates()
								end,
							},
							iconBorderSize = {
								type = "range",
								name = L.borderSize,
								order = 19,
								min = 1,
								max = 5,
								step = 1,
								width = 1,
								disabled = function() return not db.iconBorder end,
							},
							resetHeader = {
								type = "header",
								name = "",
								order = 100,
							},
							reset = {
								type = "execute",
								name = L.resetAll,
								desc = L.resetNameplateIconsDesc,
								func = function()
									setDefaults(iconDefaults)
									if plugin:UnitGUID("target") then
										plugin:NAME_PLATE_UNIT_REMOVED(nil, "target")
										plugin:NAME_PLATE_UNIT_ADDED(nil, "target")
									end
								end,
								order = 101,
							},
						},
					},
					cooldown = {
						type = "group",
						name = L.cooldown,
						order = 2,
						args = {
							iconCooldownSwipe = {
								type = "toggle",
								name = L.showCooldownSwipe,
								desc = L.showCooldownSwipeDesc,
								order = 1,
							},
							iconCooldownEdge =	{
								type = "toggle",
								name = L.showCooldownEdge,
								desc = L.showCooldownEdgeDesc,
								order = 2,
							},
							iconCooldownInverse = {
								type = "toggle",
								name = L.inverse,
								desc = L.inverseSwipeDesc,
								order = 3,
								disabled = function() return not db.iconCooldownSwipe end,
							},
							iconCooldownNumbers = {
								type = "toggle",
								name = L.showNumbers,
								desc = L.showNumbersDesc,
								order = 4,
								width = "full",
							},
							iconFontName = {
								type = "select",
								name = L.font,
								order = 5,
								values = media:List(FONT),
								itemControl = "DDI-Font",
								get = function()
									for i, v in next, media:List(FONT) do
										if v == db.iconFontName then return i end
									end
								end,
								set = function(_, value)
									local list = media:List(FONT)
									db.iconFontName = list[value]
									resetNameplates()
								end,
								width = 2,
								disabled = checkCooldownTimerDisabled,
							},
							iconFontOutline = {
								type = "select",
								name = L.outline,
								order = 6,
								values = {
									NONE = L.none,
									OUTLINE = L.thin,
									THICKOUTLINE = L.thick,
								},
								disabled = checkCooldownTimerDisabled,
							},
							iconFontColor = {
								type = "color",
								name = L.fontColor,
								hasAlpha = true,
								get = function()
									return db.iconFontColor[1], db.iconFontColor[2], db.iconFontColor[3], db.iconFontColor[4]
								end,
								set = function(_, r, g, b, a)
									db.iconFontColor = {r, g, b, a}
									resetNameplates()
								end,
								order = 7,
								disabled = checkCooldownTimerDisabled,
							},
							iconFontSize = {
								type = "range",
								name = L.fontSize,
								desc = L.fontSizeDesc,
								order = 8,
								softMax = 100, max = 200, min = 6, step = 1,
								disabled = checkCooldownTimerDisabled,
							},
							iconFontMonochrome = {
								type = "toggle",
								name = L.monochrome,
								desc = L.monochromeDesc,
								order = 9,
								disabled = checkCooldownTimerDisabled,
							},
						},
					},
					glow = {
						type = "group",
						name = L.glow,
						order = 3,
						args = {
							iconExpireGlow = {
								type = "toggle",
								name = L.enableExpireGlow,
								desc = L.enableExpireGlowDesc,
								order = 1,
							},
							iconGlowColor = {
								type = "color",
								name = L.glowColor,
								order = 2,
								hasAlpha = true,
								disabled = function() return not db.iconExpireGlow end,
								get = function()
									return db.iconGlowColor[1], db.iconGlowColor[2], db.iconGlowColor[3], db.iconGlowColor[4]
								end,
								set = function(_, r, g, b, a)
									db.iconGlowColor = {r, g, b, a}
									resetNameplates()
								end,
							},
							iconExpireGlowType = {
								type = "select",
								name = L.glowType,
								desc = L.glowTypeDesc,
								order = 3,
								disabled = function() return not db.iconExpireGlow end,
								values = glowValues,
							},
							iconGlowFrequency = {
								type = "range",
								name = L.speed,
								desc = L.animation_speed_desc,
								order = 4,
								min = -2,
								max = 2,
								step = 0.05,
								width = 1.5,
								hidden = function() return db.iconExpireGlowType == "proc" end,
								disabled = function() return not db.iconExpireGlow end,
							},
							iconGlowPixelLines = {
								type = "range",
								name = L.lines,
								desc = L.lines_glow_desc,
								order = 5,
								min = 1,
								max = 15,
								step = 1,
								width = 1.5,
								disabled = function() return not db.iconExpireGlow end,
								hidden = function() return db.iconExpireGlowType ~= "pixel" end,
							},
							iconGlowAutoCastParticles = {
								type = "range",
								name = L.intensity,
								desc = L.intensity_glow_desc,
								order = 6,
								min = 1,
								max = 15,
								step = 1,
								width = 1.5,
								disabled = function() return not db.iconExpireGlow end,
								hidden = function() return db.iconExpireGlowType ~= "autocast" end,
							},
							iconGlowPixelThickness = {
								type = "range",
								name = L.thickness,
								desc = L.thickness_glow_desc,
								order = 7,
								min = 1,
								max = 5,
								step = 1,
								width = 1.5,
								disabled = function() return not db.iconExpireGlow end,
								hidden = function() return db.iconExpireGlowType ~= "pixel" end,
							},
							iconGlowAutoCastScale = {
								type = "range",
								name = L.scale,
								desc = L.scale_glow_desc,
								order = 8,
								min = 0.5,
								max = 3,
								step = 0.05,
								width = 1.5,
								isPercent = true,
								disabled = function() return not db.iconExpireGlow end,
								hidden = function() return db.iconExpireGlowType ~= "autocast" end,
							},
							iconGlowProcStartAnim = {
								type = "toggle",
								name = L.startAnimation,
								desc = L.startAnimation_glow_desc,
								order = 9,
								disabled = function() return not db.iconExpireGlow end,
								hidden = function() return db.iconExpireGlowType ~= "proc" end,
							},
							iconGlowProcAnimDuration = {
								type = "range",
								name = L.speed,
								desc = L.animation_speed_desc,
								order = 10,
								min = 0.1,
								max = 3,
								step = 0.1,
								width = 1.5,
								disabled = function() return not db.iconExpireGlow end,
								hidden = function() return db.iconExpireGlowType ~= "proc" end,
							},
							iconGlowPixelLength ={
								type = "range",
								name = L.length,
								desc = L.length_glow_desc,
								order = 11,
								min = 1,
								max = 20,
								step = 1,
								width = 1.5,
								disabled = function() return not db.iconExpireGlow end,
								hidden = function() return db.iconExpireGlowType ~= "pixel" end,
							},
							iconGlowTimeLeft = {
								type = "range",
								name = L.glowAt,
								desc = L.glowAt_desc,
								order = 12,
								min = 0,
								max = 3,
								step = 1,
								width = 2,
							},
						},
					},
					advanced = {
						type = "group",
						name = L.advanced,
						order = 4,
						args = {
							iconAutoScale = {
								type = "toggle",
								name = L.autoScale,
								desc = L.autoScaleDesc,
								order = 1,
							},
						},
					},
				},
			},
			nameplateTextSettings = {
				type = "group",
				name = L.nameplateTextSettings,
				order = 20,
				set = function(info, value)
					db[info[#info]] = value
					resetNameplates()
				end,
				args = {
					anchoringHeader = {
						type = "header",
						name = L.anchoring,
						order = 1,
						width = "full",
					},
					textGrowDirectionStart = {
						type = "select",
						values = validFramePoints,
						name = L.growStartPosition,
						desc = L.growStartPositionDesc,
						order = 2,
						width = 1.5,
					},
					textGrowDirection = {
						type = "select",
						name = L.growDirection,
						desc = L.growDirectionDesc,
						order = 3,
						width = 1.5,
						values = validGrowDirections,
					},
					textOffsetX = {
						type = "range",
						name = L.positionX,
						desc = L.positionDesc,
						order = 4,
						max = 150, softMax = 100,
						min = -150, softMin = -100,
						step = 1,
						width = 1,
					},
					textOffsetY = {
						type = "range",
						name = L.positionY,
						desc = L.positionDesc,
						order = 5,
						max = 150, softMax = 100,
						min = -150, softMin = -100,
						step = 1,
						width = 1,
					},
					textSpacing = {
						type = "range",
						name = L.spacing,
						desc = L.iconSpacingDesc,
						order = 6,
						min = 0,
						max = 20,
						step = 1,
						width = 1,
					},
					fontHeader = {
						type = "header",
						name = L.font,
						order = 20,
					},
					textFontName = {
						type = "select",
						name = L.font,
						order = 22,
						values = media:List(FONT),
						itemControl = "DDI-Font",
						get = function()
							for i, v in next, media:List(FONT) do
								if v == db.textFontName then return i end
							end
						end,
						set = function(_, value)
							local list = media:List(FONT)
							db.textFontName = list[value]
							resetNameplates()
						end,
						width = 2,
					},
					textOutline = {
						type = "select",
						name = L.outline,
						order = 23,
						values = {
							NONE = L.none,
							OUTLINE = L.thin,
							THICKOUTLINE = L.thick,
						},
					},
					textFontColor = {
						type = "color",
						name = L.fontColor,
						hasAlpha = true,
						get = function()
							return db.textFontColor[1], db.textFontColor[2], db.textFontColor[3], db.textFontColor[4]
						end,
						set = function(_, r, g, b, a)
							db.textFontColor = {r, g, b, a < 0.3 and 0.3 or a}
							resetNameplates()
						end,
						order = 24,
					},
					textFontSize = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						order = 25,
						softMax = 100, max = 200, min = 10, step = 1,
					},
					textMonochrome = {
						type = "toggle",
						name = L.monochrome,
						desc = L.monochromeDesc,
						order = 26,
					},
					textUppercase = {
						type = "toggle",
						name = L.uppercase,
						desc = L.uppercaseDesc,
						order = 27,
						hidden = function() -- Hide this option for CJK languages
							local loc = GetLocale()
							if loc == "zhCN" or loc == "zhTW" or loc == "koKR" then
								return true
							end
						end,
					},
					resetHeader = {
						type = "header",
						name = "",
						order = 100,
					},
					reset = {
						type = "execute",
						name = L.resetAll,
						desc = L.resetNameplateTextDesc,
						func = function()
							setDefaults(textDefaults)
							if plugin:UnitGUID("target") then
								plugin:NAME_PLATE_UNIT_REMOVED(nil, "target")
								plugin:NAME_PLATE_UNIT_ADDED(nil, "target")
							end
						end,
						order = 101,
					},
				},
			},
		},
	}

end

--------------------------------------------------------------------------------
-- Anchor arrangements
--

do
	-- returns table of timer texts ordered by time remaining
	local function getOrder(timers)
		local timerKeys = {}
		for key, _ in pairs(timers) do
			timerKeys[#timerKeys+1] = key
		end
		table.sort(timerKeys, function(a, b)
			return timers[a].nameplateFrame:GetRemaining() < timers[b].nameplateFrame:GetRemaining()
		end)
		return timerKeys
	end

	rearrangeNameplateIcons = function(guid, nameplateFromStart)
		local unitIcons = nameplateIcons[guid]
		if unitIcons then
			local unit = UnitTokenFromGUID(guid)
			if unit then
				local nameplate = nameplateFromStart or GetNamePlateForUnit(unit)
				if nameplate then
					local sorted = getOrder(nameplateIcons[guid])
					local offsetY = db.iconOffsetY
					local offsetX = db.iconOffsetX
					local growDirection = db.iconGrowDirection
					local iconPoint = inverseAnchorPoint[db.iconGrowDirectionStart]
					local nameplatePoint = db.iconGrowDirectionStart
					for i, key in ipairs(sorted) do
						local icon = unitIcons[key].nameplateFrame

						if i > 1 then -- Only use setup offset for first icon
							local growOffset = db.iconSpacing
							if growDirection == "UP" then
								growOffset = growOffset + db.iconHeight
								offsetY = offsetY + growOffset
							elseif growDirection == "DOWN" then
								growOffset = -(growOffset + db.iconHeight)
								offsetY = offsetY + growOffset
							elseif growDirection == "LEFT" then
								growOffset = -(growOffset + db.iconWidth)
								offsetX = offsetX + growOffset
							else -- RIGHT
								growOffset = growOffset + db.iconWidth
								offsetX = offsetX + growOffset
							end
						end

						icon:ClearAllPoints()
						icon:SetPoint(iconPoint, nameplate, nameplatePoint, offsetX, offsetY)
					end
				end
			end
		end
	end

	rearrangeNameplateTexts = function(guid, nameplateFromStart)
		local unitTexts = nameplateTexts[guid]
		if unitTexts then
			local unit = UnitTokenFromGUID(guid)
			if unit then
				local nameplate = nameplateFromStart or GetNamePlateForUnit(unit)
				if nameplate then
					local sorted = getOrder(nameplateTexts[guid])
					local offsetY = db.textOffsetY
					local offsetX = db.textOffsetX
					local growDirection = db.textGrowDirection
					local textPoint = inverseAnchorPoint[db.textGrowDirectionStart]
					local nameplatePoint = db.textGrowDirectionStart
					for i, key in ipairs(sorted) do
						local text = unitTexts[key].nameplateFrame
						local w, h = text:GetSize()
						if i > 1 then -- Only use setup offset after first icon
							local growOffset = db.textSpacing
							if growDirection == "UP" then
								growOffset = growOffset + h
								offsetY = offsetY + growOffset
							elseif growDirection == "DOWN" then
								growOffset = -(growOffset + h)
								offsetY = offsetY + growOffset
							elseif growDirection == "LEFT" then
								growOffset = -(growOffset + w)
								offsetX = offsetX + growOffset
							else -- RIGHT
								growOffset = growOffset + w
								offsetX = offsetX + growOffset
							end
						end
						text:ClearAllPoints()
						text:SetPoint(textPoint, nameplate, nameplatePoint, offsetX, offsetY)
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Delete Data Functions
--

local function nameplateIconCascadeDelete(guid, key)
	nameplateIcons[guid][key] = nil
	if not next(nameplateIcons[guid]) then
		nameplateIcons[guid] = nil
	end
end

local function nameplateTextCascadeDelete(guid, key)
	nameplateTexts[guid][key] = nil
	if not next(nameplateTexts[guid]) then
		nameplateTexts[guid] = nil
	end
end

function frameStopped(frame, isText)
	local unitGUID = frame:Get("bigwigs:unitGUID")
	local key = frame:Get("bigwigs:key")
	if isText then
		nameplateTextCascadeDelete(unitGUID, key)
		rearrangeNameplateTexts(unitGUID)
	else
		nameplateIconCascadeDelete(unitGUID, key)
		rearrangeNameplateIcons(unitGUID)
	end
end


--------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	updateProfile()

	self:RegisterMessage("BigWigs_StartNameplate", "StartNameplate")
	self:RegisterMessage("BigWigs_StopNameplate", "StopNameplate")
	self:RegisterMessage("BigWigs_ClearNameplate", "StopUnitNameplate")
	self:RegisterMessage("BigWigs_StopBars", "StopModuleNameplates")
	self:RegisterMessage("BigWigs_OnBossDisable", "StopModuleNameplates")
	self:RegisterMessage("BigWigs_OnBossWipe", "StopModuleNameplates")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)

	self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
end

function plugin:OnPluginDisable()
	for _, icons in next, nameplateIcons do
		for _, frameInfo in next, icons do
			if frameInfo.nameplateFrame then
				frameInfo.nameplateFrame:StopNameplate()
			end
		end
	end
	for _, texts in next, nameplateTexts do
		for _, frameInfo in next, texts do
			if frameInfo.nameplateFrame then
				frameInfo.nameplateFrame:StopNameplate()
			end
		end
	end
	nameplateIcons = {}
	nameplateTexts = {}
end

--------------------------------------------------------------------------------
-- Stopping Icons
--

function removeFrame(frameInfo)
	if frameInfo.deletionTimer then
		frameInfo.deletionTimer:Cancel()
		frameInfo.deletionTimer = nil
	end
	if frameInfo.nameplateFrame then
		frameInfo.nameplateFrame:StopNameplate()
	else
		if frameInfo.text then
			nameplateTextCascadeDelete(frameInfo.unitGUID, frameInfo.key)
		else
			nameplateIconCascadeDelete(frameInfo.unitGUID, frameInfo.key)
		end
	end
end

function plugin:StopNameplate(_, module, guid, key, text)
	local frameInfo
	if text then
		frameInfo = nameplateTexts[guid] and nameplateTexts[guid][key]
	else
		frameInfo = nameplateIcons[guid] and nameplateIcons[guid][key]
	end
	if frameInfo and frameInfo.module == module then
		removeFrame(frameInfo)
	end
end

function plugin:StopUnitNameplate(_, _, guid)
	local icons = nameplateIcons[guid] or {}
	local texts = nameplateTexts[guid] or {}
	for _, frameInfo in next, icons do
		removeFrame(frameInfo)
	end
	for _, frameInfo in next, texts do
		removeFrame(frameInfo)
	end
end

function plugin:StopModuleNameplates(_, module)
	for _, icons in next, nameplateIcons do
		for _, frameInfo in next, icons do
			if frameInfo.module == module then
				removeFrame(frameInfo)
			end
		end
	end
	for _, texts in next, nameplateTexts do
		for _, frameInfo in next, texts do
			if frameInfo.module == module then
				removeFrame(frameInfo)
			end
		end
	end
end

-----------------------------------------------------------------------
-- Start Nameplates
--

local function createNameplateText(_, guid, key, length, text)
	local textFrame = getTextFrame()

	textFrame:Set("bigwigs:key", key)
	textFrame:Set("bigwigs:unitGUID", guid)
	textFrame:SetText(text)
	textFrame:SetDuration(length)
	textFrame:StartNameplate()

	return textFrame
end

local function createNameplateIcon(module, guid, key, length, icon)
	local iconFrame = getIconFrame()
	local width = db.iconWidth
	local height = db.iconHeight

	iconFrame:SetSize(width, height)
	local target = module:UnitGUID("target")
	if guid == target then
		iconFrame:SetFrameLevel(5555)
		if db.iconAutoScale then
			iconFrame:SetScale(GetCVar("nameplateSelectedScale"))
		end
	else
		iconFrame:SetFrameLevel(5500)
		if db.iconAutoScale then
			iconFrame:SetScale(GetCVar("nameplateGlobalScale"))
		end
	end
	iconFrame:Set("bigwigs:key", key)
	iconFrame:Set("bigwigs:unitGUID", guid)
	iconFrame:ShowBorder(db.iconBorder, db.iconBorderColor)

	iconFrame:SetIcon(icon)
	iconFrame:SetIconColor(db.iconColor[1], db.iconColor[2], db.iconColor[3], db.iconColor[4])
	iconFrame:SetDesaturated(db.iconDesaturate)

	iconFrame.cooldown:SetDrawEdge(db.iconCooldownEdge)
	iconFrame.cooldown:SetDrawSwipe(db.iconCooldownSwipe)
	iconFrame.cooldown:SetReverse(db.iconCooldownInverse)

	iconFrame:SetDuration(length)
	iconFrame:Start()

	return iconFrame
end

local function getLength(length)
	local time = GetTime()
	local expirationTime, timerDuration
	if type(length) == "table" then
		expirationTime = time + length[1]
		timerDuration = length[1]
	else
		expirationTime = time + length
		timerDuration = length
	end
	return expirationTime, timerDuration
end

function startNameplateIcon(module, guid, key, length, icon)
	local time = GetTime()
	local expirationTime, timerDuration = getLength(length)

	local currentIcon = nameplateIcons[guid] and nameplateIcons[guid][key]
	if currentIcon and currentIcon.exp < time and timerDuration <= 0 then
		-- Avoid restarting an already expired icon and its animations if the timer is 0 or less
		return
	end

	plugin:StopNameplate(nil, module, guid, key)

	if not nameplateIcons[guid] then
		nameplateIcons[guid] = {}
	end
	local frameInfo = {
		module = module,
		key = key,
		length = timerDuration,
		exp = expirationTime,
		icon = icon,
		unitGUID = guid,
	}
	nameplateIcons[guid][key] = frameInfo

	local unit = UnitTokenFromGUID(guid)
	if unit and UnitCanAttack("player", unit) then -- Mind control protection
		local nameplate = GetNamePlateForUnit(unit)
		if nameplate then
			local nameplateIcon = createNameplateIcon(module, guid, key, length, icon)
			frameInfo.nameplateFrame = nameplateIcon
			rearrangeNameplateIcons(guid, nameplate)
		end
	end
end

function showNameplateText(module, guid, key, length, text)
	plugin:StopNameplate(nil, module, guid, key, text)
	local expirationTime, timerDuration = getLength(length)

	nameplateTexts[guid] = nameplateTexts[guid] or {}
	local textInfo = {
		module = module,
		key = key,
		length = timerDuration,
		exp = expirationTime,
		text = text,
		unitGUID = guid,
	}
	nameplateTexts[guid][key] = textInfo

	local unit = UnitTokenFromGUID(guid)
	if unit and UnitCanAttack("player", unit) then -- Mind control protection
		local nameplate = GetNamePlateForUnit(unit)
		if nameplate then
			local nameplateText = createNameplateText(module, guid, key, length, text)
			textInfo.nameplateFrame = nameplateText
			rearrangeNameplateTexts(guid, nameplate)
		end
	end
end

function plugin:StartNameplate(_, module, guid, key, length, customIconOrText)
	if not module:CheckOption(key, "NAMEPLATE") then return end
	if not customIconOrText or type(customIconOrText) == "number" then
		local icon = customIconOrText or module:SpellTexture(key)
		startNameplateIcon(module, guid, key, length, icon)
	elseif type(customIconOrText) == "string" then
		showNameplateText(module, guid, key, length, customIconOrText)
	end
end

-------------------------------------------------------------------------------
-- Nameplate management
--

do
	local function handleFrame(guid, frameInfo)
		local remainingTime = frameInfo.exp - GetTime()
		if frameInfo.text then
			local nameplateFrame = createNameplateText(
				frameInfo.module,
				frameInfo.unitGUID,
				frameInfo.key,
				remainingTime,
				frameInfo.text
			)
			frameInfo.nameplateFrame = nameplateFrame
		else
			local nameplateFrame = createNameplateIcon(
				frameInfo.module,
				frameInfo.unitGUID,
				frameInfo.key,
				{remainingTime, frameInfo.length},
				frameInfo.icon
			)
			frameInfo.nameplateFrame = nameplateFrame
			if frameInfo.deletionTimer then
				frameInfo.deletionTimer:Cancel()
				frameInfo.deletionTimer = nil
			end
		end
	end

	function plugin:NAME_PLATE_UNIT_ADDED(_, unit)
		local guid = self:UnitGUID(unit)
		local unitIcons = nameplateIcons[guid]
		if unitIcons then
			for _, frameInfo in next, unitIcons do
				handleFrame(guid, frameInfo)
			end
		end
		local unitTexts = nameplateTexts[guid]
		if unitTexts then
			for _, frameInfo in next, unitTexts do
				handleFrame(guid, frameInfo)
			end
		end
		rearrangeNameplateIcons(guid)
		rearrangeNameplateTexts(guid)
	end
end

function plugin:NAME_PLATE_UNIT_REMOVED(_, unit)
	local guid = self:UnitGUID(unit)
	local unitIcons = nameplateIcons[guid]
	if unitIcons then
		for _, frameInfo in next, unitIcons do
			if frameInfo.nameplateFrame then
				frameInfo.nameplateFrame:HideFrame()
				frameInfo.nameplateFrame = nil
			end
		end
	end
	local unitTexts = nameplateTexts[guid]
	if unitTexts then
		for _, frameInfo in next, unitTexts do
			if frameInfo.nameplateFrame then
				frameInfo.nameplateFrame:HideFrame()
				frameInfo.nameplateFrame = nil
			end
		end
	end
end

do
	local prevTarget = nil
	function plugin:PLAYER_TARGET_CHANGED()
		local guid = self:UnitGUID("target")
		if nameplateIcons[guid] then
			for _, tbl in next, nameplateIcons[guid] do
				if tbl.nameplateFrame then
					tbl.nameplateFrame:SetFrameLevel(5555)
					if db.iconAutoScale then
						tbl.nameplateFrame:SetScale(GetCVar("nameplateSelectedScale"))
					end
				end
			end
		end
		if prevTarget and nameplateIcons[prevTarget] then
			for _, tbl in next, nameplateIcons[prevTarget] do
				if tbl.nameplateFrame then
					tbl.nameplateFrame:SetFrameLevel(5500)
					if db.iconAutoScale then
						tbl.nameplateFrame:SetScale(GetCVar("nameplateGlobalScale"))
					end
				end
			end
		end
		prevTarget = guid
	end
end
