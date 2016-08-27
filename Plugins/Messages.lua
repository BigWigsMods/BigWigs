-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Messages", "LibSink-2.0")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local media = LibStub("LibSharedMedia-3.0")

local labels = {}

local seModule = nil
local colorModule = nil

local normalAnchor = nil
local emphasizeAnchor = nil
local emphasizeCountdownAnchor = nil

local BWMessageFrame = nil

local db = nil

local floor = math.floor

local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs: Plugins")
plugin.displayName = L.messages

--------------------------------------------------------------------------------
-- Anchors
--

local defaultPositions = {
	BWMessageAnchor = {"CENTER"},
	BWEmphasizeMessageAnchor = {"TOP", "RaidWarningFrame", "BOTTOM", 0, 45},
	BWEmphasizeCountdownMessageAnchor = {"TOP", "RaidWarningFrame", "BOTTOM", 0, -150},
}

local function onDragStart(self) self:StartMoving() end
local function onDragStop(self)
	self:StopMovingOrSizing()
	local s = self:GetEffectiveScale()
	db[self.x] = self:GetLeft() * s
	db[self.y] = self:GetTop() * s
end

local function showAnchors()
	normalAnchor:Show()
	emphasizeAnchor:Show()
	emphasizeCountdownAnchor:Show()
	seModule.anchorEmphasizedCountdownText:Show()
end

local function hideAnchors()
	normalAnchor:Hide()
	emphasizeAnchor:Hide()
	emphasizeCountdownAnchor:Hide()
end

local function resetAnchors()
	normalAnchor:Reset()
	emphasizeAnchor:Reset()
	emphasizeCountdownAnchor:Reset()
end

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	sink20OutputSink = "BigWigs",
	font = nil,
	monochrome = nil,
	outline = "THICKOUTLINE",
	align = "CENTER",
	fontSize = nil,
	usecolors = true,
	scale = 1.0,
	chat = nil,
	useicons = true,
	classcolor = true, -- XXX non-functional
	growUpwards = nil,
	emphasizedMessages = {
		sink20OutputSink = "BigWigsEmphasized",
	},
	displaytime = 3,
	fadetime = 2,
}

local fakeEmphasizeMessageAddon = {}
LibStub("LibSink-2.0"):Embed(fakeEmphasizeMessageAddon)

plugin.pluginOptions = {
	type = "group",
	name = L.messages,
	childGroups = "tab",
	args = {
		output = {
			type = "group",
			name = L.output,
			order = 2,
			childGroups = "tab",
			args = {
				normal = plugin:GetSinkAce3OptionsDataTable(),
				emphasized = fakeEmphasizeMessageAddon:GetSinkAce3OptionsDataTable(),
			},
		}
	},
}
plugin.pluginOptions.args.output.args.normal.name = L.normalMessages
plugin.pluginOptions.args.output.args.normal.order = 1
plugin.pluginOptions.args.output.args.normal.disabled = nil
plugin.pluginOptions.args.output.args.emphasized.name = L.emphasizedMessages
plugin.pluginOptions.args.output.args.emphasized.order = 2
plugin.pluginOptions.args.output.args.emphasized.disabled = nil
-- Kill chat outputs
plugin.pluginOptions.args.output.args.normal.args.Channel = nil
plugin.pluginOptions.args.output.args.emphasized.args.Channel = nil
plugin.pluginOptions.args.output.args.normal.args.ChatFrame = nil
plugin.pluginOptions.args.output.args.emphasized.args.ChatFrame = nil

local function updateProfile()
	db = plugin.db.profile
	if normalAnchor then
		normalAnchor:RefixPosition()
		emphasizeAnchor:RefixPosition()
		emphasizeCountdownAnchor:RefixPosition()
		BWMessageFrame:ClearAllPoints()
		local align = db.align == "CENTER" and "" or db.align
		BWMessageFrame:SetPoint("TOP"..align, normalAnchor, "BOTTOM"..align)
		for i = 1, 4 do
			local font = labels[i]
			if font then
				font.animFade:SetStartDelay(db.displaytime)
				font.icon.animFade:SetStartDelay(db.displaytime)
				font.animFade:SetDuration(db.fadetime)
				font.icon.animFade:SetDuration(db.fadetime)
			end
		end
	end
	plugin:SetSinkStorage(db)
	fakeEmphasizeMessageAddon:SetSinkStorage(db.emphasizedMessages)
	if not db.font then
		db.font = media:GetDefault("font")
	end
	if not db.fontSize then
		local _, size = GameFontNormalHuge:GetFont()
		db.fontSize = size
	end

	-- Kill chat outputs
	if db.sink20OutputSink == "Channel" or db.sink20OutputSink == "ChatFrame" then
		db.sink20OutputSink = "BigWigs"
		db.sink20ScrollArea = nil
	end
	if db.emphasizedMessages.sink20OutputSink == "Channel" or db.emphasizedMessages.sink20OutputSink == "ChatFrame" then
		db.emphasizedMessages.sink20OutputSink = "BigWigsEmphasized"
		db.emphasizedMessages.sink20ScrollArea = nil
	end
end

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnRegister()
	self:RegisterSink("BigWigsEmphasized", L.bwEmphasized, L.emphasizedSinkDescription, "EmphasizedPrint")
	self:RegisterSink("BigWigs", "BigWigs", L.sinkDescription, "Print")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()
end

do
	local function createAnchor(frameName, title)
		local display = CreateFrame("Frame", frameName, UIParent)
		display.x, display.y = frameName .. "_x", frameName .. "_y"
		display:EnableMouse(true)
		display:SetClampedToScreen(true)
		display:SetMovable(true)
		display:RegisterForDrag("LeftButton")
		display:SetWidth((frameName == "BWEmphasizeCountdownMessageAnchor") and 50 or 200)
		display:SetHeight((frameName == "BWEmphasizeCountdownMessageAnchor") and 50 or 20)
		local bg = display:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(display)
		bg:SetColorTexture(0, 0, 0, 0.3)
		display.background = bg
		local header = display:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		header:SetText(title)
		if frameName == "BWEmphasizeCountdownMessageAnchor" then
			header:SetPoint("BOTTOM", display, "TOP", 0, 5)
			header:SetJustifyV("TOP")
			seModule.anchorEmphasizedCountdownText = display:CreateFontString(nil, "OVERLAY")
			seModule.anchorEmphasizedCountdownText:SetFont(media:Fetch("font", seModule.db.profile.font), seModule.db.profile.fontSize, seModule.db.profile.outline ~= "NONE" and seModule.db.profile.outline)
			seModule.anchorEmphasizedCountdownText:SetPoint("CENTER")
			seModule.anchorEmphasizedCountdownText:SetText("5")
			seModule.anchorEmphasizedCountdownText:SetTextColor(seModule.db.profile.fontColor.r, seModule.db.profile.fontColor.g, seModule.db.profile.fontColor.b)
		else
			header:SetAllPoints(display)
			header:SetJustifyV("MIDDLE")
		end
		header:SetJustifyH("CENTER")
		display:SetScript("OnDragStart", onDragStart)
		display:SetScript("OnDragStop", onDragStop)
		display:SetScript("OnMouseUp", function(self, button)
			if button ~= "LeftButton" then return end
			if self:GetName() == "BWEmphasizeCountdownMessageAnchor" or self:GetName() == "BWEmphasizeMessageAnchor" then
				seModule:SendMessage("BigWigs_SetConfigureTarget", seModule)
			else
				plugin:SendMessage("BigWigs_SetConfigureTarget", plugin)
			end
		end)
		display.Reset = function(self)
			db[self.x] = nil
			db[self.y] = nil
			self:RefixPosition()
		end
		display.RefixPosition = function(self)
			self:ClearAllPoints()
			if db[self.x] and db[self.y] then
				local s = self:GetEffectiveScale()
				self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", db[self.x] / s, db[self.y] / s)
			else
				self:SetPoint(unpack(defaultPositions[self:GetName()]))
			end
		end
		display:RefixPosition()
		display:Hide()
		return display
	end

	local function createSlots()
		BWMessageFrame = CreateFrame("Frame", "BWMessageFrame", UIParent)
		BWMessageFrame:SetWidth(UIParent:GetWidth())
		BWMessageFrame:SetHeight(80)
		local align = db.align == "CENTER" and "" or db.align
		if db.growUpwards then
			BWMessageFrame:SetPoint("BOTTOM"..align, normalAnchor, "TOP"..align)
		else
			BWMessageFrame:SetPoint("TOP"..align, normalAnchor, "BOTTOM"..align)
		end
		BWMessageFrame:SetScale(db.scale or 1)
		BWMessageFrame:SetFrameStrata("HIGH")
		BWMessageFrame:SetToplevel(true)
		for i = 1, 4 do
			local fs = BWMessageFrame:CreateFontString(nil, "ARTWORK")
			fs:SetWidth(0)
			fs:SetHeight(0)
			fs.elapsed = 0
			fs:Hide()

			fs.anim = fs:CreateAnimationGroup()
			fs.anim:SetScript("OnFinished", function(self)
				self:GetParent():Hide()
				if not labels[1]:IsShown() and not labels[2]:IsShown() and not labels[3]:IsShown() and not labels[4]:IsShown() then
					BWMessageFrame:Hide()
				end
			end)
			fs.animFade = fs.anim:CreateAnimation("Alpha")
			fs.animFade:SetFromAlpha(1)
			fs.animFade:SetToAlpha(0)
			fs.animFade:SetStartDelay(db.displaytime)
			fs.animFade:SetDuration(db.fadetime)

			local icon = BWMessageFrame:CreateTexture(nil, "ARTWORK")
			icon:SetPoint("RIGHT", fs, "LEFT")
			icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
			icon:Hide()
			fs.icon = icon

			icon.anim = icon:CreateAnimationGroup()
			icon.anim:SetScript("OnFinished", function(self) self:GetParent():Hide() end)
			icon.animFade = icon.anim:CreateAnimation("Alpha")
			icon.animFade:SetFromAlpha(1)
			icon.animFade:SetToAlpha(0)
			icon.animFade:SetStartDelay(db.displaytime)
			icon.animFade:SetDuration(db.fadetime)

			labels[i] = fs
		end
	end

	function plugin:OnPluginEnable()
		seModule = BigWigs:GetPlugin("Super Emphasize", true)
		colorModule = BigWigs:GetPlugin("Colors", true)

		if not normalAnchor then
			normalAnchor = createAnchor("BWMessageAnchor", L.messages)
			emphasizeAnchor = createAnchor("BWEmphasizeMessageAnchor", L.emphasizedMessages)
			emphasizeCountdownAnchor = createAnchor("BWEmphasizeCountdownMessageAnchor", L.emphasizedCountdown)
			createSlots()
			createAnchor, createSlots = nil, nil
		end

		self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)

		self:RegisterMessage("BigWigs_ResetPositions", resetAnchors)
		self:RegisterMessage("BigWigs_SetConfigureTarget")
		self:RegisterMessage("BigWigs_Message")
		self:RegisterMessage("BigWigs_EmphasizedMessage")
		self:RegisterMessage("BigWigs_EmphasizedCountdownMessage")
		self:RegisterMessage("BigWigs_StartConfigureMode", showAnchors)
		self:RegisterMessage("BigWigs_StopConfigureMode", hideAnchors)
	end
end

function plugin:BigWigs_SetConfigureTarget(event, module)
	if module == self then
		normalAnchor.background:SetColorTexture(0.2, 1, 0.2, 0.3)
		emphasizeAnchor.background:SetColorTexture(0, 0, 0, 0.3)
		emphasizeCountdownAnchor.background:SetColorTexture(0, 0, 0, 0.3)
	elseif module == seModule then
		normalAnchor.background:SetColorTexture(0, 0, 0, 0.3)
		emphasizeAnchor.background:SetColorTexture(0.2, 1, 0.2, 0.3)
		emphasizeCountdownAnchor.background:SetColorTexture(0.2, 1, 0.2, 0.3)
	else
		normalAnchor.background:SetColorTexture(0, 0, 0, 0.3)
		emphasizeAnchor.background:SetColorTexture(0, 0, 0, 0.3)
		emphasizeCountdownAnchor.background:SetColorTexture(0, 0, 0, 0.3)
	end
end

do
	local updateMessageTimers = function(info, value)
		plugin.db.profile[info[#info]] = value
		for i = 1, 4 do
			local font = labels[i]
			if font then
				font.animFade:SetStartDelay(db.displaytime)
				font.icon.animFade:SetStartDelay(db.displaytime)
				font.animFade:SetDuration(db.fadetime)
				font.icon.animFade:SetDuration(db.fadetime)
			end
		end
	end
	local updateAnchor = function(info, value)
		plugin.db.profile[info[#info]] = value
		BWMessageFrame:ClearAllPoints()
		local align = plugin.db.profile.align == "CENTER" and "" or db.align
		if plugin.db.profile.growUpwards then
			BWMessageFrame:SetPoint("BOTTOM"..align, normalAnchor, "TOP"..align)
		else
			BWMessageFrame:SetPoint("TOP"..align, normalAnchor, "BOTTOM"..align)
		end
		for i = 1, 4 do
			local font = labels[i]
			font:ClearAllPoints()
		end
	end

	plugin.pluginOptions.args.more = {
		type = "group",
		name = L.general,
		order = 1,
		get = function(info) return plugin.db.profile[info[#info]] end,
		set = function(info, value) plugin.db.profile[info[#info]] = value end,
		args = {
			font = {
				type = "select",
				name = L.font,
				order = 1,
				values = media:List("font"),
				itemControl = "DDI-Font",
				get = function()
					for i, v in next, media:List("font") do
						if v == plugin.db.profile.font then return i end
					end
				end,
				set = function(info, value)
					local list = media:List("font")
					plugin.db.profile.font = list[value]
				end,
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
			align = {
				type = "select",
				name = L.align,
				values = {
					LEFT = L.left,
					CENTER = L.center,
					RIGHT = L.right,
				},
				width = "half",
				style = "radio",
				order = 3,
				set = updateAnchor,
			},
			fontSize = {
				type = "range",
				name = L.fontSize,
				order = 4,
				max = 200, softMax = 72,
				min = 1,
				step = 1,
				width = "full",
			},
			usecolors = {
				type = "toggle",
				name = L.useColors,
				desc = L.useColorsDesc,
				order = 5,
			},
			useicons = {
				type = "toggle",
				name = L.useIcons,
				desc = L.useIconsDesc,
				order = 6,
			},
			growUpwards = {
				type = "toggle",
				name = L.growingUpwards,
				desc = L.growingUpwardsDesc,
				order = 7,
				set = updateAnchor,
			},
			monochrome = {
				type = "toggle",
				name = L.monochrome,
				desc = L.monochromeDesc,
				order = 8,
			},
		--	classcolor = {
		--		type = "toggle",
		--		name = L.classColors,
		--		desc = L.classColorsDesc,
		--		order = 9,
		--	},
			newline1 = {
				type = "description",
				name = "\n",
				order = 10,
			},
			displaytime = {
				type = "range",
				name = L.displayTime,
				desc = L.displayTimeDesc,
				min = 1,
				max = 30,
				step = 0.5,
				order = 11,
				set = updateMessageTimers,
			},
			fadetime = {
				type = "range",
				name = L.fadeTime,
				desc = L.fadeTimeDesc,
				min = 1,
				max = 30,
				step = 0.5,
				order = 12,
				set = updateMessageTimers,
			},
		},
	}
end

-------------------------------------------------------------------------------
-- Event Handlers
--

do
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
		-- move 4 -> 1
		local old = labels[4]
		labels[4] = labels[3]
		labels[3] = labels[2]
		labels[2] = labels[1]
		labels[1] = old
		-- reposition
		local align = db.align == "CENTER" and "" or db.align
		old:ClearAllPoints()
		old:SetPoint("TOP"..align)
		for i = 2, 4 do
			local lbl = labels[i]
			lbl:ClearAllPoints()
			lbl:SetPoint("TOP"..align, labels[i - 1], "BOTTOM"..align)
		end
		-- new message at 1
		return labels[1]
	end

	local function getNextSlotUp()
		-- move 1 -> 4
		local old = labels[1]
		labels[1] = labels[2]
		labels[2] = labels[3]
		labels[3] = labels[4]
		labels[4] = old
		-- reposition
		local align = db.align == "CENTER" and "" or db.align
		old:ClearAllPoints()
		old:SetPoint("BOTTOM"..align)
		for i = 1, 3 do
			local lbl = labels[i]
			lbl:ClearAllPoints()
			lbl:SetPoint("BOTTOM"..align, labels[i + 1], "TOP"..align)
		end
		-- new message at 4
		return labels[4]
	end

	function plugin:Print(addon, text, r, g, b, font, size, _, _, _, icon)
		BWMessageFrame:SetScale(db.scale or 1)
		BWMessageFrame:Show()

		local slot = db.growUpwards and getNextSlotUp() or getNextSlotDown()

		local flags = nil
		if db.monochrome and db.outline ~= "NONE" then
			flags = "MONOCHROME," .. db.outline
		elseif db.monochrome then
			flags = "MONOCHROME"
		elseif db.outline ~= "NONE" then
			flags = db.outline
		end
		slot:SetFont(media:Fetch("font", db.font), db.fontSize, flags)

		slot:SetText(text)
		slot:SetTextColor(r, g, b, 1)
		slot:SetHeight(slot:GetStringHeight())

		if icon then
			local h = slot:GetHeight()
			slot.icon:SetWidth(h)
			slot.icon:SetHeight(h)
			slot.icon:SetTexture(icon)
			slot.icon.anim:Stop()
			slot.icon:Show()
			slot.icon.anim:Play()
		else
			slot.icon:Hide()
		end
		slot.anim:Stop()
		slot:SetAlpha(1)
		slot.icon:SetAlpha(1)
		slot.elapsed = 0
		slot.anim:SetScript("OnUpdate", bounceAnimation)
		slot:Show()
		slot.anim:Play()
	end
end

do
	local emphasizedText, updater, frame = nil, nil, nil
	function plugin:EmphasizedPrint(addon, text, r, g, b, font, size, _, _, _, icon)
		if not updater then
			frame = CreateFrame("Frame", "BWEmphasizeMessageFrame", UIParent)
			frame:SetFrameStrata("HIGH")
			frame:SetPoint("TOP", emphasizeAnchor, "BOTTOM")
			frame:SetWidth(UIParent:GetWidth())
			frame:SetHeight(80)

			emphasizedText = frame:CreateFontString(nil, "OVERLAY", "ZoneTextFont")
			emphasizedText:SetPoint("TOP")

			updater = frame:CreateAnimationGroup()
			updater:SetScript("OnFinished", function() frame:Hide() end)

			local anim = updater:CreateAnimation("Alpha")
			anim:SetFromAlpha(1)
			anim:SetToAlpha(0)
			anim:SetDuration(3.5)
			anim:SetStartDelay(1.5)
		end

		local flags = nil
		if seModule.db.profile.monochrome and seModule.db.profile.outline ~= "NONE" then
			flags = "MONOCHROME," .. seModule.db.profile.outline
		elseif seModule.db.profile.monochrome then
			flags = "MONOCHROME"
		elseif seModule.db.profile.outline ~= "NONE" then
			flags = seModule.db.profile.outline
		end

		emphasizedText:SetFont(media:Fetch("font", seModule.db.profile.font), seModule.db.profile.fontSize, flags)
		emphasizedText:SetText(text)
		emphasizedText:SetTextColor(r, g, b)
		updater:Stop()
		frame:Show()
		updater:Play()
	end
	function plugin:BigWigs_EmphasizedMessage(event, ...)
		fakeEmphasizeMessageAddon:Pour(...)
	end
end

do
	local emphasizedCountdownText, updater, frame = nil, nil, nil
	function plugin:EmphasizedCountdownPrint(text)
		if not updater then
			if seModule.anchorEmphasizedCountdownText then seModule.anchorEmphasizedCountdownText:Hide() end
			frame = CreateFrame("Frame", "BWEmphasizeCountdownMessageFrame", UIParent)
			frame:SetFrameStrata("HIGH")
			frame:SetPoint("CENTER", emphasizeCountdownAnchor, "CENTER")
			frame:SetWidth(80)
			frame:SetHeight(80)

			emphasizedCountdownText = frame:CreateFontString(nil, "OVERLAY")
			emphasizedCountdownText:SetPoint("CENTER")

			updater = frame:CreateAnimationGroup()
			updater:SetScript("OnFinished", function() frame:Hide() end)

			local anim = updater:CreateAnimation("Alpha")
			anim:SetFromAlpha(1)
			anim:SetToAlpha(0)
			anim:SetDuration(3.5)
			anim:SetStartDelay(1.5)
		end

		local flags = nil
		if seModule.db.profile.monochrome and seModule.db.profile.outline ~= "NONE" then
			flags = "MONOCHROME," .. seModule.db.profile.outline
		elseif seModule.db.profile.monochrome then
			flags = "MONOCHROME"
		elseif seModule.db.profile.outline ~= "NONE" then
			flags = seModule.db.profile.outline
		end

		emphasizedCountdownText:SetFont(media:Fetch("font", seModule.db.profile.font), seModule.db.profile.fontSize, flags)
		emphasizedCountdownText:SetText(text)
		emphasizedCountdownText:SetTextColor(seModule.db.profile.fontColor.r, seModule.db.profile.fontColor.g, seModule.db.profile.fontColor.b)
		updater:Stop()
		frame:Show()
		updater:Play()
	end
	function plugin:BigWigs_EmphasizedCountdownMessage(event, ...)
		plugin:EmphasizedCountdownPrint(...)
	end
end

function plugin:BigWigs_Message(event, module, key, text, color, icon)
	if not text then return end

	local r, g, b = 1, 1, 1 -- Default to white.
	if db.usecolors then
		if type(color) == "table" then
			if color.r and color.g and color.b then
				r, g, b = color.r, color.g, color.b
			else
				r, g, b = unpack(color)
			end
		elseif colorModule then
			r, g, b = colorModule:GetColor(color, module, key)
		end
	end

	if not db.useicons then icon = nil end

	if seModule and seModule:IsSuperEmphasized(module, key) then
		if seModule.db.profile.upper then
			text = text:upper()
			text = text:gsub("(:%d+|)T", "%1t") -- Fix texture paths that need to end in lowercase |t
		end
		fakeEmphasizeMessageAddon:Pour(text, r, g, b)
	else
		self:Pour(text, r, g, b, nil, nil, nil, nil, nil, icon)
	end
	if db.chat then
		-- http://www.wowpedia.org/UI_escape_sequences
		-- |TTexturePath:size1:size2:xoffset:yoffset:dimx:dimy:coordx1:coordx2:coordy1:coordy2:red:green:blue|t
		if icon then text = "|T"..icon..":15:15:0:0:64:64:4:60:4:60|t"..text end
		DEFAULT_CHAT_FRAME:AddMessage(text, r, g, b)
	end
end
