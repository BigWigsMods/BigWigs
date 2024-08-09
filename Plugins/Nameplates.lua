--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Nameplates")
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

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

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
local CL = BigWigsAPI:GetLocale("BigWigs: Common")
plugin.displayName = L.nameplates

local media = LibStub("LibSharedMedia-3.0")
local FONT = media.MediaType and media.MediaType.FONT or "font"

local db = nil
local nameplateIcons = {}
local rearrangeNameplateAnchors, nameplateCascadeDelete, iconStopped, StartNameplateIcon
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit

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

--------------------------------------------------------------------------------
-- Icon Frames
--

local iconFrameCache = {}
local function recycleIconFrame(frame)
	table.insert(iconFrameCache, frame)
end

local function iconLoop(updater)
	local iconFrame = updater.parent
	iconFrame.repeater:SetStartDelay(0)

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

	if (next(iconFrameCache)) then
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
		cooldown:SetHideCountdownNumbers(true)

		local textFrame = CreateFrame("Frame", nil, iconFrame)
		textFrame:SetAllPoints(iconFrame)
		textFrame:SetPoint("CENTER")
		textFrame:SetFrameLevel(cooldown:GetFrameLevel() + 1)

		local countdownNumber = textFrame:CreateFontString(nil, "OVERLAY")
		countdownNumber:SetPoint("CENTER")
		countdownNumber:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
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
		anim:SetDuration(1)
		iconFrame.updater = updater
		iconFrame.repeater = anim
	end

	function iconFrame:SetDuration(duration)
		self.countdownNumber:Hide()
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

	function iconFrame:HideIcon()
		self:StopGlows()
		self.updater:Stop()
		self:Hide()
		recycleIconFrame(self)
	end

	function iconFrame:StopIcon()
		self:HideIcon()
		iconStopped(self)
	end

	return iconFrame
end


--------------------------------------------------------------------------------
-- Profile
--

plugin.defaultDB = {
	iconGrowDirection = "LEFT",
	iconGrowDirectionStart = "LEFT",
	iconSpacing = 1,
	nameplateIconWidth = 15,
	nameplateIconHeight = 15,
	nameplateIconOffsetX = 0,
	nameplateIconOffsetY = -4,
	nameplateIconCooldownTimer = true,
	nameplateIconCooldownTimerFontName = plugin:GetDefaultFont(),
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

--------------------------------------------------------------------------------
-- Options
--

do
	local function resetIconFrames()
		for guid, _ in next, nameplateIcons do
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
			testButton = {
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
								StartNameplateIcon(plugin, guid, key, random(50, 200)/10, testIcons[testNumber])
							end
						end
					else
						BigWigs:Print(L.noNameplateTestTarget)
					end
				end,
				width = 1.5,
				order = 1,
			},
			stopTestButton = {
				type = "execute",
				name = L.stopTestNameplateIconBtn,
				desc = L.stopTestNameplateIconBtn_desc,
				func = function()
					plugin:StopModuleNameplates(nil, plugin)
				end,
				width = 1.5,
				order = 1,
			},
			nameplateIconSettings = {
				type = "group",
				name = L.nameplateIconSettings,
				order = 10,
				set = function(info, value)
					db[info[#info]] = value
					resetIconFrames()
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
							resetIconFrames()
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
							resetIconFrames()
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
							resetIconFrames()
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
							resetIconFrames()
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
						order = 31,
						width = 1,
					},
					nameplateIconCooldownEdge =	{
						type = "toggle",
						name = L.showCooldownEdge,
						order = 32,
						width = 1,
					},
					nameplateIconCooldownInverse = {
						type = "toggle",
						name = L.inverse,
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
							resetIconFrames()
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
							plugin.db:ResetProfile()
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
			return timers[a].nameplateIcon:GetRemaining() < timers[b].nameplateIcon:GetRemaining()
		end)
		return timerKeys
	end

	rearrangeNameplateAnchors = function(guid)
		local unit = findUnitByGUID(guid)
		if not unit then return end
		local nameplate = GetNamePlateForUnit(unit)
		local unitTimers = nameplateIcons[guid]
		if unitTimers then
			local sorted = getOrder(nameplateIcons[guid])
			local offsetY = db.nameplateIconOffsetY
			local offsetX = db.nameplateIconOffsetX
			local growDirection = db.iconGrowDirection
			local iconPoint = inverseAnchorPoint[db.iconGrowDirectionStart]
			local nameplatePoint = db.iconGrowDirectionStart
			for i, key in ipairs(sorted) do
				local icon = unitTimers[key].nameplateIcon

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
end

--------------------------------------------------------------------------------
-- Delete Data Functions
--

local function nameplateCascadeDelete(guid, key)
	nameplateIcons[guid][key] = nil
	if not next(nameplateIcons[guid]) then
		nameplateIcons[guid] = nil
	end
end

local function createDeletionTimer(iconInfo, remaining)
	return C_Timer.NewTimer(remaining, function()
		nameplateCascadeDelete(iconInfo.unitGUID, iconInfo.key)
	end)
end

function iconStopped(icon)
	local unitGUID = icon:Get("bigwigs:unitGUID")
	local key = icon:Get("bigwigs:key")
	nameplateCascadeDelete(unitGUID, key)
	rearrangeNameplateAnchors(unitGUID)
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
	self:RegisterMessage("BigWigs_OnPluginDisable", "StopModuleNameplates")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)

	self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
end

function plugin:OnPluginDisable()
	for _, icons in next, nameplateIcons do
		for _, iconInfo in next, icons do
			if iconInfo.nameplateIcon then
				iconInfo.nameplateIcon:StopIcon()
			end
		end
	end
	nameplateIcons = {}
end

--------------------------------------------------------------------------------
-- Stopping Icons
--

local function removeIcon(iconInfo, guid, key)
	if iconInfo.deletionTimer then
		iconInfo.deletionTimer:Cancel()
		iconInfo.deletionTimer = nil
	end
	if iconInfo.nameplateIcon then
		iconInfo.nameplateIcon:StopIcon()
	else
		nameplateCascadeDelete(guid, key)
	end
end

function plugin:StopNameplate(_, module, guid, key, text)
	if not text then
		local iconInfo = nameplateIcons[guid] and nameplateIcons[guid][key]
		if iconInfo and iconInfo.module == module then
			removeIcon(iconInfo, guid, key)
		end
	end
end

function plugin:StopUnitNameplate(_, _, guid)
	if not nameplateIcons[guid] then return end
	for key, iconInfo in next, nameplateIcons[guid] do
		removeIcon(iconInfo, guid, key)
	end
end

function plugin:StopModuleNameplates(_, module)
	for guid, icons in next, nameplateIcons do
		for key, iconInfo in next, icons do
			if iconInfo.module == module then
				removeIcon(iconInfo, guid, key)
			end
		end
	end
end

-----------------------------------------------------------------------
-- Start Icons
--

local function createNameplateIcon(module, guid, key, lenght, icon, hideOnExpire)
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

	iconFrame:SetDuration(lenght)
	iconFrame:Start()

	return iconFrame
end

function StartNameplateIcon(module, guid, key, length, icon, hideOnExpire)
	local time = GetTime()
    local expirationTime, timerDuration

	if type(length) == "table" then
		expirationTime = time + length[1]
		timerDuration = length[1]
	else
		expirationTime = time + length
		timerDuration = length
	end

    local currentIcon = nameplateIcons[guid] and nameplateIcons[guid][key]
    if currentIcon and currentIcon.exp < time and timerDuration <= 0 then
		-- Avoid restarting an already expired icon and its animations if the timer is 0 or less
        return
    end

	plugin:StopNameplate(nil, module, guid, key)

	nameplateIcons[guid] = nameplateIcons[guid] or {}
	local iconInfo = {
		module = module,
		key = key,
		length = timerDuration,
		exp = expirationTime,
		icon = icon,
		unitGUID = guid,
		hideOnExpire = hideOnExpire,
	}
	nameplateIcons[guid][key] = iconInfo

	local unit = findUnitByGUID(guid)
	if unit then
		local nameplateIcon = createNameplateIcon(module, guid, key, length, icon, hideOnExpire)
		iconInfo.nameplateIcon = nameplateIcon
		rearrangeNameplateAnchors(guid)
	else
		local remaining = expirationTime - GetTime()
		iconInfo.deletionTimer = createDeletionTimer(iconInfo, remaining)
	end
end

function plugin:StartNameplate(_, module, guid, key, length, customIconOrText, hideOnExpire)
	if not module:CheckOption(key, "NAMEPLATE") then return end
	if not customIconOrText or type(customIconOrText) == "number" then
		local icon = customIconOrText or GetSpellTexture(key)
		StartNameplateIcon(module, guid, key, length, icon, hideOnExpire)
	end
end

-------------------------------------------------------------------------------
-- Nameplate management
--

function plugin:NAME_PLATE_UNIT_ADDED(_, unit)
	local guid = self:UnitGUID(unit)
	local unitIcons = nameplateIcons[guid]
	if not unitIcons then return end
	local inCombat = UnitAffectingCombat(unit)
	for _, iconInfo in next, unitIcons do
		if not inCombat and iconInfo.module ~= plugin then -- Don't stop test icons
			self:StopNameplateIcon(nil, iconInfo.module, guid, iconInfo.key)
		else
			local remainingTime = iconInfo.exp - GetTime()
			local nameplateIcon = createNameplateIcon(
				iconInfo.module,
				iconInfo.unitGUID,
				iconInfo.key,
				{remainingTime, iconInfo.length},
				iconInfo.icon,
				iconInfo.hideOnExpire
			)
			iconInfo.nameplateIcon = nameplateIcon
			if iconInfo.deletionTimer then
				iconInfo.deletionTimer:Cancel()
				iconInfo.deletionTimer = nil
			end
		end
	end
	rearrangeNameplateAnchors(guid)
end

function plugin:NAME_PLATE_UNIT_REMOVED(_, unit)
	local guid = self:UnitGUID(unit)
	local unitIcons = nameplateIcons[guid]
	if not unitIcons then return end
	for _, iconInfo in next, unitIcons do
		if iconInfo.nameplateIcon then
			iconInfo.nameplateIcon:HideIcon()
		end
		if iconInfo.hideOnExpire then
			local remaining = iconInfo.exp - GetTime()
			if remaining > 0 then
				iconInfo.deletionTimer = createDeletionTimer(iconInfo, remaining)
			else
				nameplateCascadeDelete(guid, iconInfo.key)
			end
		end
		iconInfo.nameplateIcon = nil
	end
end
