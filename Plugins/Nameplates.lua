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
local removeFrame, nameplateIconCascadeDelete, frameStopped

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


local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local findUnitByGUID
do
	local unitTable = {
		"nameplate1", "nameplate2", "nameplate3", "nameplate4", "nameplate5", "nameplate6", "nameplate7", "nameplate8", "nameplate9", "nameplate10",
		"nameplate11", "nameplate12", "nameplate13", "nameplate14", "nameplate15", "nameplate16", "nameplate17", "nameplate18", "nameplate19", "nameplate20",
		"nameplate21", "nameplate22", "nameplate23", "nameplate24", "nameplate25", "nameplate26", "nameplate27", "nameplate28", "nameplate29", "nameplate30",
		"nameplate31", "nameplate32", "nameplate33", "nameplate34", "nameplate35", "nameplate36", "nameplate37", "nameplate38", "nameplate39", "nameplate40",
	}
	local unitTableCount = #unitTable
	findUnitByGUID = function(id)
		for i = 1, unitTableCount do
			local unit = unitTable[i]
			local guid = plugin:UnitGUID(unit)
			if guid == id then
				return unit
			end
		end
	end
end

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
-- Text Frames
--

local function getTextFrame()
	local textFrame

	if next(textFrameCache) then
		textFrame = table.remove(textFrameCache)
	else

		textFrame = CreateFrame("Frame", nil, UIParent)
		textFrame:SetPoint("CENTER")
		-- textFrame:SetSize(db.nameplateIconWidth, db.nameplateIconHeight)

		local fontString = textFrame:CreateFontString(nil, "OVERLAY")
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
		self.fontString:SetTextColor(unpack(db.textFontColor))
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
		if db.nameplateIconCooldownTimer then
			iconFrame.countdownNumber:SetText(timeToDisplay)
		end
	else
		iconFrame.countdownNumber:Hide()
		iconFrame.updater:Stop()
		if iconFrame.hideOnExpire then
			iconFrame:StopIcon()
		elseif db.nameplateIconExpireGlow and not iconFrame.activeGlow then
			iconFrame:StartGlow(db.nameplateIconExpireGlowType)
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

local function getIconFrame()
	local iconFrame

	if next(iconFrameCache) then
		iconFrame = table.remove(iconFrameCache)
	else
		iconFrame = CreateFrame("Frame", nil, UIParent)
		iconFrame:SetPoint("CENTER")
		iconFrame:SetSize(db.nameplateIconWidth, db.nameplateIconHeight)

		local icon = iconFrame:CreateTexture(nil, "ARTWORK")
		icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
		icon:SetSnapToPixelGrid(false)
		icon:SetTexelSnappingBias(0)
		icon:SetAllPoints(iconFrame)
		iconFrame.icon = icon

		local cooldown = CreateFrame("Cooldown", nil, iconFrame, "CooldownFrameTemplate")
		iconFrame.cooldown = cooldown
		cooldown:SetAllPoints(icon)
		cooldown:SetDrawBling(false)
		cooldown:SetDrawEdge(db.nameplateIconCooldownEdge)
		cooldown:SetDrawSwipe(db.nameplateIconCooldownSwipe)
		cooldown:SetReverse(db.nameplateIconCooldownInverse)
		cooldown:SetFrameLevel(100)
		cooldown:SetHideCountdownNumbers(true) -- Blizzard
		cooldown.noCooldownCount = true -- OmniCC

		local textFrame = CreateFrame("Frame", nil, iconFrame)
		textFrame:SetAllPoints(iconFrame)
		textFrame:SetPoint("CENTER")
		textFrame:SetFrameLevel(cooldown:GetFrameLevel() + 1)

		local countdownNumber = textFrame:CreateFontString(nil, "OVERLAY")
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
			if db.nameplateIconCooldownTimer then
				local flags = nil
				if db.nameplateIconCooldownTimerMonochrome and db.nameplateIconCooldownTimerOutline ~= "NONE" then
					flags = "MONOCHROME," .. db.nameplateIconCooldownTimerOutline
				elseif db.nameplateIconCooldownTimerMonochrome then
					flags = "MONOCHROME"
				elseif db.nameplateIconCooldownTimerOutline ~= "NONE" then
					flags = db.nameplateIconCooldownTimerOutline
				end
				self.countdownNumber:SetFont(media:Fetch(FONT, db.nameplateIconCooldownTimerFontName), db.nameplateIconCooldownTimerFontSize, flags)
				self.countdownNumber:SetTextColor(unpack(db.nameplateIconCooldownTimerFontColor))

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
		local zoom = baseZoom * (1 - db.nameplateIconZoom)
		local zoomedOffset = 1 - ((1 - zoom) / 2)
		local offsetX, offsetY = zoomedOffset, zoomedOffset

		if db.nameplateIconAspectRatio then
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

	function iconFrame:SetHideOnExpire(hideOnExpire)
		self.hideOnExpire = hideOnExpire
	end

	function iconFrame:ShowBorder(show, color, size)
		if show then
			self.border:SetBackdrop(GetBorderBackdrop(db.nameplateIconBorderSize))
			self.border:SetBackdropBorderColor(unpack(color))
			self.border:Show()
		else
			self.border:Hide()
		end
	end

	function iconFrame:StartGlow(glowType)
		self:StopGlows()
		local glowFunction = glowFunctions[glowType]
		if glowFunction then
			self.glowTimer = C_Timer.NewTimer(0.05, function()  -- delay so the frame is shown before the glow
				glowFunction(self, db.nameplateIconGlowColor)
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
			if db.nameplateIconExpireGlow and not iconFrame.activeGlow then
				self:StartGlow(db.nameplateIconExpireGlowType)
			end
		elseif db.nameplateIconCooldownTimer then
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
-- Profile
--

local iconDefaults = {
	iconGrowDirection = "LEFT",
	iconGrowDirectionStart = "LEFT",
	iconSpacing = 1,
	nameplateIconWidth = 15,
	nameplateIconHeight = 15,
	nameplateIconOffsetX = 0,
	nameplateIconOffsetY = -4,
	nameplateIconCooldownTimer = true,
	nameplateIconCooldownTimerFontName = "Noto Sans Regular", -- Only dealing with numbers so we can use this on all locales
	nameplateIconCooldownTimerFontSize = 7,
	nameplateIconCooldownTimerFontColor = {1, 1, 1, 1},
	nameplateIconCooldownTimerOutline = "OUTLINE",
	nameplateIconCooldownTimerMonochrome = false,
	nameplateIconCooldownEdge = true,
	nameplateIconCooldownSwipe = true,
	nameplateIconCooldownInverse = false,
	nameplateIconExpireGlow = true,
	nameplateIconExpireGlowType = "pixel",
	nameplateIconZoom = 0,
	nameplateIconAspectRatio = true,
	nameplateIconDesaturate = false,
	nameplateIconColor = {1, 1, 1, 1},
	nameplateIconGlowColor = {0.95, 0.95, 0.32, 1},
	nameplateIconBorder = true,
	nameplateIconBorderSize = 1,
	nameplateIconBorderColor = {0, 0, 0, 1},
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

plugin.defaultDB = {}
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

	-- Add validations
end

local function setDefaults(options)
	local defaults = options
	local db = plugin.db.profile
	for k, value  in next, defaults do
		db[k] = value
	end
	updateProfile()
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
		for guid, _ in next, guids do
			local unit = findUnitByGUID(guid)
			if unit then
				plugin:NAME_PLATE_UNIT_REMOVED(nil, unit)
				plugin:NAME_PLATE_UNIT_ADDED(nil, unit)
			end
		end
	end

	local checkCooldownTimerDisabled = function() return not db.nameplateIconCooldownTimer end

	local testCount = 0
	local testIcons = {
		"Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_legacy.tga",
		"Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid.tga",
		"Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_party.tga",
	}
	plugin.pluginOptions = {
		type = "group",
		name = L.nameplates,
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
						for i = 1, 40 do
							local unit = ("nameplate%d"):format(i)
							if plugin:UnitGUID(unit) == guid then
								local t = GetTime()
								testCount = testCount + 1
								local testNumber = (testCount%3)+1
								local key = "test"..testNumber
								startNameplateIcon(plugin, guid, key, random(50, 200)/10, testIcons[testNumber])
							end
						end
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
								local t = GetTime()
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
				order = 1,
			},
			stopTestButton = {
				type = "execute",
				name = L.stopTestNameplateBtn,
				desc = L.stopTestNameplateBtn_desc,
				func = function()
					plugin:StopModuleNameplates(nil, plugin)
				end,
				width = 1,
				order = 1,
			},
			nameplateIconSettings = {
				type = "group",
				name = L.nameplateIconSettings,
				order = 10,
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
					nameplateIconOffsetX = {
						type = "range",
						name = L.positionX,
						desc = L.positionDesc,
						order = 4,
						min = -50,
						max = 50,
						step = 1,
						width = 1,
					},
					nameplateIconOffsetY = {
						type = "range",
						name = L.positionY,
						desc = L.positionDesc,
						order = 5,
						min = -50,
						max = 50,
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
					nameplateIconWidth = {
						type = "range",
						name = L.width,
						order = 11,
						min = 8,
						max = 50,
						step = 1,
						width = 1,
					},
					nameplateIconHeight = {
						type = "range",
						name = L.height,
						order = 12,
						min = 8,
						max = 50,
						step = 1,
						width = 1,
					},
					nameplateIconAspectRatio = {
						type = "toggle",
						name = L.keepAspectRatio,
						desc = L.keepAspectRatioDesc,
						order = 13,
						width = 1,
					},
					nameplateIconColor = {
						type = "color",
						name = L.iconColor,
						desc = L.iconColorDesc,
						order = 14,
						hasAlpha = true,
						width = 1,
						get = function(info)
							return unpack(plugin.db.profile.nameplateIconColor)
						end,
						set = function(info, r, g, b, a)
							plugin.db.profile.nameplateIconColor = {r, g, b, a}
							resetNameplates()
						end,
					},
					nameplateIconDesaturate = {
						type = "toggle",
						name = L.desaturate,
						desc = L.desaturateDesc,
						order = 15,
						width = 1,
					},
					nameplateIconZoom = {
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
					nameplateIconBorder = {
						type = "toggle",
						name = L.showBorder,
						desc = L.showBorderDesc,
						order = 17,
						width = 1,
					},
					nameplateIconBorderColor = {
						type = "color",
						name = L.borderColor,
						order = 18,
						hasAlpha = true,
						width = 1,
						disabled = function() return not db.nameplateIconBorder end,
						get = function(info)
							return unpack(plugin.db.profile.nameplateIconBorderColor)
						end,
						set = function(info, r, g, b, a)
							plugin.db.profile.nameplateIconBorderColor = {r, g, b, a}
							resetNameplates()
						end,
					},
					nameplateIconBorderSize = {
						type = "range",
						name = L.borderSize,
						order = 19,
						min = 1,
						max = 5,
						step = 1,
						width = 1,
						disabled = function() return not db.nameplateIconBorder end,
					},
					cooldownTimerHeader = {
						type = "header",
						name = L.timer,
						order = 20,
					},
					nameplateIconCooldownTimer = {
						type = "toggle",
						name = L.showTimer,
						desc = L.showTimerDesc,
						order = 21,
						width = 1.4,
					},
					nameplateIconCooldownTimerFontName = {
						type = "select",
						name = L.font,
						order = 22,
						values = media:List(FONT),
						itemControl = "DDI-Font",
						get = function()
							for i, v in next, media:List(FONT) do
								if v == db.nameplateIconCooldownTimerFontName then return i end
							end
						end,
						set = function(_, value)
							local list = media:List(FONT)
							db.nameplateIconCooldownTimerFontName = list[value]
							resetNameplates()
						end,
						width = 2,
						disabled = checkCooldownTimerDisabled,
					},
					nameplateIconCooldownTimerOutline = {
						type = "select",
						name = L.outline,
						order = 23,
						values = {
							NONE = L.none,
							OUTLINE = L.thin,
							THICKOUTLINE = L.thick,
						},
						disabled = checkCooldownTimerDisabled,
					},
					nameplateIconCooldownTimerFontColor = {
						type = "color",
						name = L.fontColor,
						hasAlpha = true,
						get = function(info)
							return unpack(db.nameplateIconCooldownTimerFontColor)
						end,
						set = function(info, r, g, b, a)
							db.nameplateIconCooldownTimerFontColor = {r, g, b, a}
							resetNameplates()
						end,
						order = 24,
						disabled = checkCooldownTimerDisabled,
					},
					nameplateIconCooldownTimerFontSize = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						order = 25,
						softMax = 100, max = 200, min = 5, step = 1,
						disabled = checkCooldownTimerDisabled,
					},
					nameplateIconCooldownTimerMonochrome = {
						type = "toggle",
						name = L.monochrome,
						desc = L.monochromeDesc,
						order = 26,
						disabled = checkCooldownTimerDisabled,
					},
					cooldownSwipeHeader = {
						type = "header",
						name = L.cooldown,
						order = 30,
					},
					nameplateIconCooldownSwipe = {
						type = "toggle",
						name = L.showCooldownSwipe,
						desc = L.showCooldownSwipeDesc,
						order = 31,
						width = 1,
					},
					nameplateIconCooldownEdge =	{
						type = "toggle",
						name = L.showCooldownEdge,
						desc = L.showCooldownEdgeDesc,
						order = 32,
						width = 1,
					},
					nameplateIconCooldownInverse = {
						type = "toggle",
						name = L.inverse,
						desc = L.inverseSwipeDesc,
						order = 33,
						width = 1,
						disabled = function() return not db.nameplateIconCooldownSwipe end,
					},
					glowHeader = {
						type = "header",
						name = L.iconGlow,
						order = 40,
					},
					nameplateIconExpireGlow = {
						type = "toggle",
						name = L.enableExpireGlow,
						desc = L.enableExpireGlowDesc,
						order = 41,
						width = 1,
					},
					nameplateIconGlowColor = {
						type = "color",
						name = L.glowColor,
						order = 42,
						hasAlpha = true,
						width = 1,
						disabled = function()
							-- proc has no glow color option
							return not db.nameplateIconExpireGlow or db.nameplateIconExpireGlowType == "proc"
						end,
						get = function(info)
							return unpack(plugin.db.profile.nameplateIconGlowColor)
						end,
						set = function(info, r, g, b, a)
							plugin.db.profile.nameplateIconGlowColor = {r, g, b, a}
							resetNameplates()
						end,
					},
					nameplateIconExpireGlowType = {
						type = "select",
						name = L.glowType,
						desc = L.glowTypeDesc,
						order = 43,
						width = 1,
						disabled = function() return not db.nameplateIconExpireGlow end,
						values = {
							pixel = L.pixelGlow,
							autocast = L.autocastGlow,
							buttoncast = L.buttonGlow,
							proc = L.procGlow,
						},
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
						min = -50,
						max = 50,
						step = 1,
						width = 1,
					},
					textOffsetY = {
						type = "range",
						name = L.positionY,
						desc = L.positionDesc,
						order = 5,
						min = -50,
						max = 50,
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
						get = function(info)
							return unpack(db.textFontColor)
						end,
						set = function(info, r, g, b, a)
							db.textFontColor = {r, g, b, a}
							resetNameplates()
						end,
						order = 24,
					},
					textFontSize = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						order = 25,
						softMax = 100, max = 200, min = 5, step = 1,
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

	rearrangeNameplateIcons = function(guid)
		local unit = findUnitByGUID(guid)
		if not unit then return end
		local nameplate = GetNamePlateForUnit(unit)
		local unitIcons = nameplateIcons[guid]
		if unitIcons then
			local sorted = getOrder(nameplateIcons[guid])
			local offsetY = db.nameplateIconOffsetY
			local offsetX = db.nameplateIconOffsetX
			local growDirection = db.iconGrowDirection
			local iconPoint = inverseAnchorPoint[db.iconGrowDirectionStart]
			local nameplatePoint = db.iconGrowDirectionStart
			for i, key in ipairs(sorted) do
				local icon = unitIcons[key].nameplateFrame

				if i > 1 then -- Only use setup offset for first icon
					local growOffset = db.iconSpacing
					if db.iconGrowDirection == "UP" then
						growOffset = growOffset + db.nameplateIconHeight
						offsetY = offsetY + growOffset
					elseif db.iconGrowDirection == "DOWN" then
						growOffset = -(growOffset + db.nameplateIconHeight)
						offsetY = offsetY + growOffset
					elseif db.iconGrowDirection == "LEFT" then
						growOffset = -(growOffset + db.nameplateIconWidth)
						offsetX = offsetX + growOffset
					else -- RIGHT
						growOffset = growOffset + db.nameplateIconWidth
						offsetX = offsetX + growOffset
					end
				end

				icon:ClearAllPoints()
				icon:SetParent(nameplate)
				icon:SetPoint(iconPoint, nameplate, nameplatePoint, offsetX, offsetY)
			end
		end
	end

	rearrangeNameplateTexts = function(guid)
		local unit = findUnitByGUID(guid)
		if not unit then return end
		local nameplate = GetNamePlateForUnit(unit)
		local unitTexts = nameplateTexts[guid]
		if unitTexts then
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
					if db.textGrowDirection == "UP" then
						growOffset = growOffset + h
						offsetY = offsetY + growOffset
					elseif db.textGrowDirection == "DOWN" then
						growOffset = -(growOffset + h)
						offsetY = offsetY + growOffset
					elseif db.textGrowDirection == "LEFT" then
						growOffset = -(growOffset + w)
						offsetX = offsetX + growOffset
					else -- RIGHT
						growOffset = growOffset + w
						offsetX = offsetX + growOffset
					end
				end
				text:ClearAllPoints()
				text:SetParent(nameplate)
				text:SetPoint(textPoint, nameplate, nameplatePoint, offsetX, offsetY)
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

local function createDeletionTimer(frameInfo, remaining)
	return C_Timer.NewTimer(remaining, function()
		if frameInfo.text then
			removeFrame(frameInfo)
		else
			nameplateIconCascadeDelete(frameInfo.unitGUID, frameInfo.key)
		end
	end)
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

function plugin:OnRegister()
	updateProfile()

	-- Pre-create some frames
	local dummyFrames = {}
	for i = 1, 5 do
		dummyFrames[i] = {icon = getIconFrame(), text = getTextFrame()}
	end
	for i = 1, 5 do
		dummyFrames[i].icon:HideFrame()
		dummyFrames[i].text:HideFrame()
	end
end

function plugin:OnPluginEnable()
	updateProfile()

	self:RegisterMessage("BigWigs_StartNameplate", "StartNameplate")
	self:RegisterMessage("BigWigs_StopNameplate", "StopNameplate")
	self:RegisterMessage("BigWigs_ClearNameplate", "StopUnitNameplate")
	self:RegisterMessage("BigWigs_StopBars", "StopModuleNameplates")
	self:RegisterMessage("BigWigs_OnBossDisable", "StopModuleNameplates")
	self:RegisterMessage("BigWigs_OnBossWipe", "StopModuleNameplates")
	self:RegisterMessage("BigWigs_OnPluginDisable", "StopModuleNameplates")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)

	self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
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
-- Start Namepaltes
--

local function createNameplateText(module, guid, key, length, text)
	local textFrame = getTextFrame()

	textFrame:Set("bigwigs:key", key)
	textFrame:Set("bigwigs:unitGUID", guid)
	textFrame:SetText(text)
	textFrame:SetDuration(length)
	textFrame:StartNameplate()

	return textFrame
end

local function createNameplateIcon(module, guid, key, length, icon, hideOnExpire)
	local iconFrame = getIconFrame()
	local width = db.nameplateIconWidth
	local height = db.nameplateIconHeight

	iconFrame:SetSize(width, height)
	iconFrame:Set("bigwigs:key", key)
	iconFrame:Set("bigwigs:unitGUID", guid)
	iconFrame:SetHideOnExpire(hideOnExpire)
	iconFrame:ShowBorder(db.nameplateIconBorder, db.nameplateIconBorderColor)

	iconFrame:SetIcon(icon)
	iconFrame:SetIconColor(unpack(db.nameplateIconColor))
	iconFrame:SetDesaturated(db.nameplateIconDesaturate)

	iconFrame.cooldown:SetDrawEdge(db.nameplateIconCooldownEdge)
	iconFrame.cooldown:SetDrawSwipe(db.nameplateIconCooldownSwipe)
	iconFrame.cooldown:SetReverse(db.nameplateIconCooldownInverse)

	iconFrame:SetDuration(length)
	iconFrame:Start()

	return iconFrame
end

local function getLenght(length)
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

function startNameplateIcon(module, guid, key, length, icon, hideOnExpire)
	local time = GetTime()
    local expirationTime, timerDuration = getLenght(length)

    local currentIcon = nameplateIcons[guid] and nameplateIcons[guid][key]
    if currentIcon and currentIcon.exp < time and timerDuration <= 0 then
		-- Avoid restarting an already expired icon and its animations if the timer is 0 or less
        return
    end

	plugin:StopNameplate(nil, module, guid, key)

	nameplateIcons[guid] = nameplateIcons[guid] or {}
	local frameInfo = {
		module = module,
		key = key,
		length = timerDuration,
		exp = expirationTime,
		icon = icon,
		unitGUID = guid,
		hideOnExpire = hideOnExpire,
	}
	nameplateIcons[guid][key] = frameInfo

	local unit = findUnitByGUID(guid)
	if unit then
		local nameplateIcon = createNameplateIcon(module, guid, key, length, icon, hideOnExpire)
		frameInfo.nameplateFrame = nameplateIcon
		rearrangeNameplateIcons(guid)
	elseif hideOnExpire then
		local remaining = expirationTime - time
		frameInfo.deletionTimer = createDeletionTimer(frameInfo, remaining)
	end
end

function showNameplateText(module, guid, key, length, text, hideOnExpire)
	plugin:StopNameplate(nil, module, guid, key, text)
	local time = GetTime()
    local expirationTime, timerDuration = getLenght(length)

	nameplateTexts[guid] = nameplateTexts[guid] or {}
	local textInfo = {
		module = module,
		key = key,
		length = timerDuration,
		exp = expirationTime,
		text = text,
		unitGUID = guid,
		hideOnExpire = hideOnExpire,
	}
	nameplateTexts[guid][key] = textInfo

	if hideOnExpire then
		local remaining = expirationTime - time
		textInfo.deletionTimer = createDeletionTimer(textInfo, remaining)
	end

	local unit = findUnitByGUID(guid)
	if unit then
		local nameplateText = createNameplateText(module, guid, key, length, text, hideOnExpire)
		textInfo.nameplateFrame = nameplateText
		rearrangeNameplateTexts(guid)
	end
end

function plugin:StartNameplate(_, module, guid, key, length, customIconOrText, hideOnExpire)
	if not module:CheckOption(key, "NAMEPLATE") then return end
	if not customIconOrText or type(customIconOrText) == "number" then
		local icon = customIconOrText or module:SpellTexture(key)
		startNameplateIcon(module, guid, key, length, icon, hideOnExpire)
	elseif type(customIconOrText) == "string" then
		showNameplateText(module, guid, key, length, customIconOrText, hideOnExpire)
	end
end

-------------------------------------------------------------------------------
-- Nameplate management
--

do
	local function handleFrame(guid, frameInfo, inCombat)
		if not inCombat and frameInfo.module ~= plugin then
			-- Don't re-pop when you've wiped but do re-pop for test icons
			plugin:StopNameplate(nil, frameInfo.module, guid, frameInfo.key, frameInfo.text)
			return
		end
		local remainingTime = frameInfo.exp - GetTime()
		if frameInfo.text then
			local nameplateFrame = createNameplateText(
				frameInfo.module,
				frameInfo.unitGUID,
				frameInfo.key,
				remainingTime,
				frameInfo.text,
				frameInfo.hideOnExpire
			)
			frameInfo.nameplateFrame = nameplateFrame
		else
			local nameplateFrame = createNameplateIcon(
				frameInfo.module,
				frameInfo.unitGUID,
				frameInfo.key,
				{remainingTime, frameInfo.length},
				frameInfo.icon,
				frameInfo.hideOnExpire
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
		local unitIcons = nameplateIcons[guid] or {}
		local unitTexts = nameplateTexts[guid] or {}
		local inCombat = UnitAffectingCombat(unit)
		for _, frameInfo in next, unitIcons do
			handleFrame(guid, frameInfo, inCombat)
		end
		for _, frameInfo in next, unitTexts do
			handleFrame(guid, frameInfo, inCombat)
		end
		rearrangeNameplateIcons(guid)
		rearrangeNameplateTexts(guid)
	end
end

do
	local function handleFrame(guid, frameInfo)
		if frameInfo.nameplateFrame then
			frameInfo.nameplateFrame:HideFrame()
		end
		if frameInfo.hideOnExpire and not frameInfo.text then
			local remaining = frameInfo.exp - GetTime()
			if remaining > 0 then
				frameInfo.deletionTimer = createDeletionTimer(frameInfo, remaining)
			else
				nameplateIconCascadeDelete(guid, frameInfo.key)
			end
		end
		frameInfo.nameplateFrame = nil
	end

	function plugin:NAME_PLATE_UNIT_REMOVED(_, unit)
		local guid = self:UnitGUID(unit)
		local unitIcons = nameplateIcons[guid] or {}
		local unitTexts = nameplateTexts[guid] or {}
		for _, frameInfo in next, unitIcons do
			handleFrame(guid, frameInfo)
		end
		for _, frameInfo in next, unitTexts do
			handleFrame(guid, frameInfo)
		end
	end
end
