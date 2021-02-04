-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Messages")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local media = LibStub("LibSharedMedia-3.0")
local sink = LibStub("LibSink-2.0")
local FONT = media.MediaType and media.MediaType.FONT or "font"

local labels = {}

local colorModule = nil

local normalMessageAnchor, normalMessageFrame = nil, nil
local emphMessageAnchor, emphMessageFrame, emphMessageText = nil, nil, nil

local labelsPrimaryPoint, labelsSecondaryPoint = nil, nil

local db = nil

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
plugin.displayName = L.messages

--------------------------------------------------------------------------------
-- Profile
--

plugin.defaultDB = {
	fontName = plugin:GetDefaultFont(),
	emphFontName = plugin:GetDefaultFont(),
	monochrome = false,
	emphMonochrome = false,
	outline = "THICKOUTLINE",
	emphOutline = "THICKOUTLINE",
	align = "CENTER",
	fontSize = 20,
	emphFontSize = 48,
	chat = false,
	useicons = true,
	classcolor = true,
	growUpwards = true,
	displaytime = 3,
	fadetime = 2,
	emphUppercase = true,
	disabled = false,
	emphDisabled = false,
	-- Designed by default to grow up into the errors frame (which should be disabled in the BossBlock plugin in 99% of situations)
	-- Should not enter the RaidWarningFrame by default (since we grow upwards), which we don't want to block view of
	-- By order from top to bottom:
	-- >> UIErrorsFrame (anchored to top of UIParent)
	-- >> Our message frame (placed at bottom of UIErrorsFrame, growing upwards)
	-- >> RaidWarningFrame (anchored to bottom of UIErrorsFrame)
	-- >> RaidBossEmoteFrame (anchored to bottom of RaidWarningFrame)
	-- 122 (UIErrorsFrame Y position) + 60 (UIErrorsFrame height) = 182
	-- Worth noting: RaidWarningFrame height = 70 & RaidBossEmoteFrame height = 80
	normalPosition = {"TOP", "TOP", 0, -182},
	emphPosition = {"CENTER", "CENTER", 0, 0},
}

local function updateProfile()
	db = plugin.db.profile

	if db.fontSize < 10 or db.fontSize > 200 then
		db.fontSize = plugin.defaultDB.fontSize
	end
	if db.emphFontSize < 20 or db.emphFontSize > 200 then
		db.emphFontSize = plugin.defaultDB.emphFontSize
	end
	if db.displaytime < 1 or db.displaytime > 10 then
		db.displaytime = plugin.defaultDB.displaytime
	end
	if db.fadetime < 1 or db.fadetime > 10 then
		db.fadetime = plugin.defaultDB.fadetime
	end

	local emphFlags = nil
	if db.emphMonochrome and db.emphOutline ~= "NONE" then
		emphFlags = "MONOCHROME," .. db.emphOutline
	elseif db.emphMonochrome then
		emphFlags = "MONOCHROME"
	elseif db.emphOutline ~= "NONE" then
		emphFlags = db.emphOutline
	end
	emphMessageText:SetFont(media:Fetch(FONT, db.emphFontName), db.emphFontSize, emphFlags)

	normalMessageAnchor:RefixPosition()
	emphMessageAnchor:RefixPosition()
	normalMessageFrame:ClearAllPoints()
	local align = db.align == "CENTER" and "" or db.align
	if db.growUpwards then
		labelsPrimaryPoint, labelsSecondaryPoint = "BOTTOM"..align, "TOP"..align
	else
		labelsPrimaryPoint, labelsSecondaryPoint = "TOP"..align, "BOTTOM"..align
	end
	normalMessageFrame:SetPoint(labelsPrimaryPoint, normalMessageAnchor, labelsSecondaryPoint)

	local flags = nil
	if db.monochrome and db.outline ~= "NONE" then
		flags = "MONOCHROME," .. db.outline
	elseif db.monochrome then
		flags = "MONOCHROME"
	elseif db.outline ~= "NONE" then
		flags = db.outline
	end
	for i = 1, 4 do
		local font = labels[i]
		font.animFade:SetStartDelay(db.displaytime)
		font.icon.animFade:SetStartDelay(db.displaytime)
		font.animFade:SetDuration(db.fadetime)
		font.icon.animFade:SetDuration(db.fadetime)
		font.icon:SetSize(db.fontSize, db.fontSize)
		font:SetHeight(db.fontSize)
		font:SetFont(media:Fetch(FONT, db.fontName), db.fontSize, flags)
	end

	-- XXX temp 9.0.2
	db.BWEmphasizeMessageAnchor_y = nil
	db.BWEmphasizeMessageAnchor_x = nil
	db.BWMessageAnchor_y = nil
	db.BWMessageAnchor_x = nil
	db.BWEmphasizeCountdownMessageAnchor_y = nil
	db.BWEmphasizeCountdownMessageAnchor_x = nil
	db.sink20OutputSink = nil
	db.emphasizedMessages = nil
end

--------------------------------------------------------------------------------
-- Anchors & Frames
--

local function showAnchors()
	normalMessageAnchor:Show()
	emphMessageAnchor:Show()
end

local function hideAnchors()
	normalMessageAnchor:Hide()
	emphMessageAnchor:Hide()
end

do
	local function OnDragStart(self)
		self:StartMoving()
	end
	local function OnDragStop(self)
		self:StopMovingOrSizing()
		local point, _, relPoint, x, y = self:GetPoint()
		plugin.db.profile[self.position] = {point, relPoint, x, y}
		plugin:UpdateGUI() -- Update X/Y if GUI is open.
	end
	local function RefixPosition(self)
		self:ClearAllPoints()
		local point, relPoint = plugin.db.profile[self.position][1], plugin.db.profile[self.position][2]
		local x, y = plugin.db.profile[self.position][3], plugin.db.profile[self.position][4]
		self:SetPoint(point, UIParent, relPoint, x, y)
	end

	local function createAnchor(position, title, titleSize, width, height, saveHeader)
		local display = CreateFrame("Frame", nil, UIParent)
		display:EnableMouse(true)
		display:SetClampedToScreen(true)
		display:SetMovable(true)
		display:RegisterForDrag("LeftButton")
		display:SetWidth(width)
		display:SetHeight(height)
		display:SetFrameStrata("HIGH")
		display:SetFixedFrameStrata(true)
		display:SetFrameLevel(5)
		display:SetFixedFrameLevel(true)
		display:SetScript("OnDragStart", OnDragStart)
		display:SetScript("OnDragStop", OnDragStop)
		display.RefixPosition = RefixPosition
		local point, relPoint = plugin.defaultDB[position][1], plugin.defaultDB[position][2]
		local x, y = plugin.defaultDB[position][3], plugin.defaultDB[position][4]
		display:SetPoint(point, UIParent, relPoint, x, y)
		display.position = position
		display:Hide()
		local bg = display:CreateTexture()
		bg:SetAllPoints(display)
		bg:SetColorTexture(0, 0, 0, 0.3)
		local header = display:CreateFontString()
		header:SetFont(plugin:GetDefaultFont(titleSize))
		header:SetShadowOffset(1, -1)
		header:SetTextColor(1,0.82,0,1)
		header:SetText(title)
		header:SetPoint("CENTER", display, "CENTER")
		header:SetJustifyV("MIDDLE")
		header:SetJustifyH("CENTER")
		if saveHeader then
			display.header = header
		end
		return display
	end

	normalMessageAnchor = createAnchor("normalPosition", L.messages, 12, 200, 20)
	emphMessageAnchor = createAnchor("emphPosition", L.emphasizedMessages, 48, 650, 80, true)

	normalMessageFrame = CreateFrame("Frame", nil, UIParent)
	normalMessageFrame:SetWidth(2000)
	normalMessageFrame:SetHeight(80)
	normalMessageFrame:SetFrameStrata("FULLSCREEN_DIALOG")
	normalMessageFrame:SetFixedFrameStrata(true)
	normalMessageFrame:SetFrameLevel(20) -- Behind GUI (level 100) & behind emphasized messages (level 30)
	normalMessageFrame:SetFixedFrameLevel(true)

	local function FontFinish(self)
		self:GetParent():Hide()
		if not labels[1]:IsShown() and not labels[2]:IsShown() and not labels[3]:IsShown() and not labels[4]:IsShown() then
			normalMessageFrame:Hide()
		end
	end
	local function IconFinish(self)
		self:GetParent():Hide()
	end

	for i = 1, 4 do
		local fs = normalMessageFrame:CreateFontString()
		fs:SetWidth(0)
		fs:SetHeight(0)
		fs.elapsed = 0
		fs:Hide()

		fs.anim = fs:CreateAnimationGroup()
		fs.anim:SetScript("OnFinished", FontFinish)
		fs.animFade = fs.anim:CreateAnimation("Alpha")
		fs.animFade:SetFromAlpha(1)
		fs.animFade:SetToAlpha(0)

		local icon = normalMessageFrame:CreateTexture()
		icon:SetPoint("RIGHT", fs, "LEFT")
		icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		icon:Hide()
		fs.icon = icon

		icon.anim = icon:CreateAnimationGroup()
		icon.anim:SetScript("OnFinished", IconFinish)
		icon.animFade = icon.anim:CreateAnimation("Alpha")
		icon.animFade:SetFromAlpha(1)
		icon.animFade:SetToAlpha(0)

		labels[i] = fs
	end
end

--------------------------------------------------------------------------------
-- Options
--

plugin.pluginOptions = {
	type = "group",
	name = L.messages,
	childGroups = "tab",
	get = function(info) return plugin.db.profile[info[#info]] end,
	set = function(info, value)
		plugin.db.profile[info[#info]] = value
		updateProfile()
	end,
	args = {
		normal = {
			type = "group",
			name = L.messages,
			order = 1,
			args = {
				fontName = {
					type = "select",
					name = L.font,
					order = 1,
					values = media:List(FONT),
					itemControl = "DDI-Font",
					get = function()
						for i, v in next, media:List(FONT) do
							if v == plugin.db.profile.fontName then return i end
						end
					end,
					set = function(_, value)
						local list = media:List(FONT)
						plugin.db.profile.fontName = list[value]
						updateProfile()
					end,
					width = 2,
				},
				outline = {
					type = "select",
					name = L.outline,
					order = 2,
					values = {
						NONE = L.none,
						OUTLINE = L.thin,
						THICKOUTLINE = L.thick,
					},
				},
				fontSize = {
					type = "range",
					name = L.fontSize,
					desc = L.fontSizeDesc,
					order = 3,
					max = 200, softMax = 72,
					min = 10,
					step = 1,
					width = 2,
				},
				monochrome = {
					type = "toggle",
					name = L.monochrome,
					desc = L.monochromeDesc,
					order = 4,
				},
				align = {
					type = "select",
					name = L.align,
					values = {
						L.left,
						L.center,
						L.right,
					},
					style = "radio",
					order = 5,
					get = function() return plugin.db.profile.align == "LEFT" and 1 or plugin.db.profile.align == "RIGHT" and 3 or 2 end,
					set = function(_, value)
						plugin.db.profile.align = value == 1 and "LEFT" or value == 3 and "RIGHT" or "CENTER"
						updateProfile()
					end,
				},
				useicons = {
					type = "toggle",
					name = L.useIcons,
					desc = L.useIconsDesc,
					order = 6,
				},
				classcolor = {
					type = "toggle",
					name = L.classColors,
					desc = L.classColorsDesc,
					order = 7,
				},
				growUpwards = {
					type = "toggle",
					name = L.growingUpwards,
					desc = L.growingUpwardsDesc,
					order = 8,
				},
				displaytime = {
					type = "range",
					name = L.displayTime,
					desc = L.displayTimeDesc,
					min = 1,
					max = 10,
					step = 0.5,
					order = 9,
				},
				fadetime = {
					type = "range",
					name = L.fadeTime,
					desc = L.fadeTimeDesc,
					min = 1,
					max = 10,
					step = 0.5,
					order = 10,
				},
				newline1 = {
					type = "description",
					name = "\n",
					order = 11,
				},
				chat = {
					type = "toggle",
					name = L.chatMessages,
					desc = L.chatMessagesDesc,
					order = 12,
					width = 2,
				},
				disabled = {
					type = "toggle",
					name = L.disabled,
					--desc = "XXX",
					order = 13,
					confirm = function(_, value)
						if value then
							return L.disableDesc:format(L.messages)
						end
					end,
				},
				header1 = {
					type = "header",
					name = "",
					order = 14,
				},
				reset = {
					type = "execute",
					name = L.resetAll,
					desc = L.resetMessagesDesc,
					func = function() plugin.db:ResetProfile() end,
					order = 15,
				},
			},
		},
		emphasized = {
			type = "group",
			name = L.emphasizedMessages,
			order = 2,
			args = {
				heading = {
					type = "description",
					name = L.emphasizedDesc.. "\n\n",
					order = 1,
					width = "full",
					fontSize = "medium",
				},
				emphFontName = {
					type = "select",
					name = L.font,
					order = 2,
					values = media:List(FONT),
					itemControl = "DDI-Font",
					get = function()
						for i, v in next, media:List(FONT) do
							if v == plugin.db.profile.emphFontName then return i end
						end
					end,
					set = function(_, value)
						local list = media:List(FONT)
						plugin.db.profile.emphFontName = list[value]
						updateProfile()
					end,
				},
				emphOutline = {
					type = "select",
					name = L.outline,
					order = 3,
					values = {
						NONE = L.none,
						OUTLINE = L.thin,
						THICKOUTLINE = L.thick,
					},
				},
				emphFontSize = {
					type = "range",
					name = L.fontSize,
					desc = L.fontSizeDesc,
					order = 4,
					softMax = 100, max = 200, min = 20, step = 1,
				},
				emphMonochrome = {
					type = "toggle",
					name = L.monochrome,
					desc = L.monochromeDesc,
					order = 5,
				},
				emphUppercase = {
					type = "toggle",
					name = L.uppercase,
					desc = L.uppercaseDesc,
					order = 6,
					width = 2,
					hidden = function() -- Hide this option for CJK languages
						local loc = GetLocale()
						if loc == "zhCN" or loc == "zhTW" or loc == "koKR" then
							return true
						end
					end,
				},
				emphDisabled = {
					type = "toggle",
					name = L.disabled,
					--desc = "XXX",
					order = 7,
					confirm = function(_, value)
						if value then
							return L.disableDesc:format(L.emphasizedMessages)
						end
					end,
				},
			},
		},
		exactPositioning = {
			type = "group",
			name = L.positionExact,
			order = 3,
			childGroups = "tab",
			args = {
				normalPositioning = {
					type = "group",
					name = L.messages,
					order = 1,
					inline = true,
					args = {
						posx = {
							type = "range",
							name = L.positionX,
							desc = L.positionDesc,
							min = -2048,
							max = 2048,
							step = 1,
							order = 1,
							width = "full",
							get = function()
								return plugin.db.profile.normalPosition[3]
							end,
							set = function(_, value)
								plugin.db.profile.normalPosition[3] = value
								normalMessageAnchor:RefixPosition()
							end,
						},
						posy = {
							type = "range",
							name = L.positionY,
							desc = L.positionDesc,
							min = -2048,
							max = 2048,
							step = 1,
							order = 2,
							width = "full",
							get = function()
								return plugin.db.profile.normalPosition[4]
							end,
							set = function(_, value)
								plugin.db.profile.normalPosition[4] = value
								normalMessageAnchor:RefixPosition()
							end,
						},
					},
				},
				emphPositioning = {
					type = "group",
					name = L.emphasizedMessages,
					order = 2,
					inline = true,
					args = {
						posx = {
							type = "range",
							name = L.positionX,
							desc = L.positionDesc,
							min = -2048,
							max = 2048,
							step = 1,
							order = 1,
							width = "full",
							get = function()
								return plugin.db.profile.emphPosition[3]
							end,
							set = function(_, value)
								plugin.db.profile.emphPosition[3] = value
								emphMessageAnchor:RefixPosition()
							end,
						},
						posy = {
							type = "range",
							name = L.positionY,
							desc = L.positionDesc,
							min = -2048,
							max = 2048,
							step = 1,
							order = 2,
							width = "full",
							get = function()
								return plugin.db.profile.emphPosition[4]
							end,
							set = function(_, value)
								plugin.db.profile.emphPosition[4] = value
								emphMessageAnchor:RefixPosition()
							end,
						},
					},
				},
			},
		},
	},
}

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnRegister()
	sink.RegisterSink(self, "BigWigsEmphasized", L.bwEmphasized, L.emphasizedSinkDescription, "EmphasizedPrint")
	sink.RegisterSink(self, "BigWigs", "BigWigs", L.sinkDescription, "Print")
end

function plugin:OnPluginEnable()
	colorModule = BigWigs:GetPlugin("Colors", true)

	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()

	self:RegisterMessage("BigWigs_Message")
	self:RegisterMessage("BigWigs_StartConfigureMode", showAnchors)
	self:RegisterMessage("BigWigs_StopConfigureMode", hideAnchors)
end

-------------------------------------------------------------------------------
-- Event Handlers
--

do
	local floor = math.floor
	local scaleUpTime, scaleDownTime = 0.2, 0.4
	local function bounceAnimation(anim, elapsed)
		local self = anim:GetParent()
		self.elapsed = self.elapsed + elapsed
		local min = db.fontSize
		local max = min + 10
		if self.elapsed <= scaleUpTime then
			self:SetTextHeight(floor(min + ((max - min) * self.elapsed / scaleUpTime)))
		elseif self.elapsed <= scaleDownTime then
			self:SetTextHeight(floor(max - ((max - min) * (self.elapsed - scaleUpTime) / (scaleDownTime - scaleUpTime))))
		else
			self:SetTextHeight(min)
			anim:SetScript("OnUpdate", nil)
		end
	end

	local function getNextSlotDown()
		for i = 4, 1, -1 do
			labels[i]:ClearAllPoints()
		end
		-- move 4 -> 1
		local old = labels[4]
		labels[4] = labels[3]
		labels[3] = labels[2]
		labels[2] = labels[1]
		labels[1] = old
		-- reposition
		old:SetPoint(labelsPrimaryPoint)
		for i = 2, 4 do
			labels[i]:SetPoint(labelsPrimaryPoint, labels[i - 1], labelsSecondaryPoint)
		end
		-- new message at 1
		return old
	end

	local function getNextSlotUp()
		for i = 1, 4 do
			labels[i]:ClearAllPoints()
		end
		-- move 1 -> 4
		local old = labels[1]
		labels[1] = labels[2]
		labels[2] = labels[3]
		labels[3] = labels[4]
		labels[4] = old
		-- reposition
		old:SetPoint(labelsPrimaryPoint)
		for i = 3, 1, -1 do
			labels[i]:SetPoint(labelsPrimaryPoint, labels[i + 1], labelsSecondaryPoint)
		end
		-- new message at 4
		return old
	end

	function plugin:Print(_, text, r, g, b, _, _, _, _, _, icon)
		normalMessageFrame:Show()

		local slot = db.growUpwards and getNextSlotUp() or getNextSlotDown()
		local slotIcon = slot.icon
		slot:SetText(text)
		slot:SetTextColor(r, g, b, 1)

		if icon then
			slotIcon:SetTexture(icon)
			slotIcon.anim:Stop()
			slotIcon:Show()
			slotIcon.anim:Play()
		else
			slotIcon:Hide()
		end
		slot.anim:Stop()
		slot:SetAlpha(1)
		slotIcon:SetAlpha(1)
		slot.elapsed = 0
		slot.anim:SetScript("OnUpdate", bounceAnimation)
		slot:Show()
		slot.anim:Play()
	end
end

do
	emphMessageFrame = CreateFrame("Frame", nil, UIParent)
	emphMessageFrame:SetFrameStrata("FULLSCREEN_DIALOG")
	emphMessageFrame:SetFixedFrameStrata(true)
	emphMessageFrame:SetFrameLevel(30) -- Behind GUI (level 100)
	emphMessageFrame:SetFixedFrameLevel(true)
	emphMessageFrame:SetPoint("CENTER", emphMessageAnchor, "CENTER")
	emphMessageFrame:SetWidth(2000)
	emphMessageFrame:SetHeight(80)
	emphMessageFrame:Hide()

	emphMessageText = emphMessageFrame:CreateFontString()
	emphMessageText:SetPoint("CENTER", emphMessageFrame, "CENTER")

	local updater = emphMessageFrame:CreateAnimationGroup()
	updater:SetScript("OnFinished", function()
		emphMessageFrame:Hide()
		emphMessageAnchor.header:Show() -- Show the header again, for config mode
	end)

	local anim = updater:CreateAnimation("Alpha")
	anim:SetFromAlpha(1)
	anim:SetToAlpha(0)
	anim:SetDuration(2)
	anim:SetStartDelay(1.1)

	function plugin:EmphasizedPrint(_, text, r, g, b)
		emphMessageAnchor.header:Hide() -- Hide the header, for config mode
		emphMessageText:SetText(text)
		emphMessageText:SetTextColor(r, g, b)
		updater:Stop()
		emphMessageFrame:Show()
		updater:Play()
	end
end

do
	local unpack, type = unpack, type
	local format, upper, gsub = string.format, string.upper, string.gsub
	function plugin:BigWigs_Message(event, module, key, text, color, icon, emphasized)
		if not text then return end

		local r, g, b = 1, 1, 1 -- Default to white.
		if type(color) == "table" then
			if color.r and color.g and color.b then
				r, g, b = color.r, color.g, color.b
			else
				r, g, b = unpack(color)
			end
		elseif colorModule then
			r, g, b = colorModule:GetColor(color, module, key)
		end

		if not db.useicons then icon = nil end

		if emphasized and not db.emphDisabled then
			if db.emphUppercase then
				text = upper(text)
				text = gsub(text, "(:%d+|)T", "%1t") -- Fix texture paths that need to end in lowercase |t
			end
			self:EmphasizedPrint(nil, text, r, g, b)
		elseif not db.disabled then
			self:Print(nil, text, r, g, b, nil, nil, nil, nil, nil, icon)
		end
		if db.chat then
			-- http://www.wowpedia.org/UI_escape_sequences
			-- |TTexturePath:size1:size2:xoffset:yoffset:dimx:dimy:coordx1:coordx2:coordy1:coordy2:red:green:blue|t
			if icon then
				text = format("|T%s:15:15:0:0:64:64:4:60:4:60|t%s", icon, text)
			end
			DEFAULT_CHAT_FRAME:AddMessage(text, r, g, b)
		end
	end
end
