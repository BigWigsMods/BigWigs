-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Messages", "LibSink-2.0")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local media = LibStub("LibSharedMedia-3.0")

local scaleUpTime = 0.2
local scaleDownTime = 0.4
local labels = {}

local seModule = nil
local colorModule = nil

local normalAnchor = nil
local emphasizeAnchor = nil

local db = nil

local floor = math.floor

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")

--------------------------------------------------------------------------------
-- Anchors
--

local defaultPositions = {
	BWMessageAnchor = {"CENTER"},
	BWEmphasizeMessageAnchor = {"TOP", "RaidWarningFrame", "BOTTOM", 0, 45},
}

local function onDragStart(self) self:StartMoving() end
local function onDragStop(self)
	self:StopMovingOrSizing()
	local s = self:GetEffectiveScale()
	db[self.x] = self:GetLeft() * s
	db[self.y] = self:GetTop() * s
end

local function createAnchor(frameName, title)
	local display = CreateFrame("Frame", frameName, UIParent)
	display.x, display.y = frameName .. "_x", frameName .. "_y"
	display:EnableMouse(true)
	display:SetClampedToScreen(true)
	display:SetMovable(true)
	display:RegisterForDrag("LeftButton")
	display:SetWidth(200)
	display:SetHeight(20)
	local bg = display:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints(display)
	bg:SetBlendMode("BLEND")
	bg:SetTexture(0, 0, 0, 0.3)
	display.background = bg
	local header = display:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	header:SetText(title)
	header:SetAllPoints(display)
	header:SetJustifyH("CENTER")
	header:SetJustifyV("MIDDLE")
	display:SetScript("OnDragStart", onDragStart)
	display:SetScript("OnDragStop", onDragStop)
	display:SetScript("OnMouseUp", function(self, button)
		if button ~= "LeftButton" then return end
		plugin:SendMessage("BigWigs_SetConfigureTarget", plugin)
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

local function createAnchors()
	normalAnchor = createAnchor("BWMessageAnchor", L["Messages"])
	emphasizeAnchor = createAnchor("BWEmphasizeMessageAnchor", L["Emphasized messages"])

	createAnchors = nil
	createAnchor = nil
end

local function showAnchors()
	if createAnchors then createAnchors() end
	normalAnchor:Show()
	emphasizeAnchor:Show()
end

local function hideAnchors()
	normalAnchor:Hide()
	emphasizeAnchor:Hide()
end

local function resetAnchors()
	normalAnchor:Reset()
	emphasizeAnchor:Reset()
end

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	sink20OutputSink = "BigWigs",
	font = nil,
	monochrome = nil,
	outline = "THICKOUTLINE",
	fontSize = nil,
	usecolors = true,
	scale = 1.0,
	chat = nil,
	useicons = true,
	classcolor = true,
	emphasizedMessages = {
		sink20OutputSink = "BigWigsEmphasized",
	},
}

local fakeEmphasizeMessageAddon = {}
LibStub("LibSink-2.0"):Embed(fakeEmphasizeMessageAddon)

plugin.pluginOptions = {
	type = "group",
	name = L["Output"],
	childGroups = "tab",
	args = {
		normal = plugin:GetSinkAce3OptionsDataTable(),
		emphasized = fakeEmphasizeMessageAddon:GetSinkAce3OptionsDataTable(),
	},
}
plugin.pluginOptions.args.normal.name = L["Normal messages"]
plugin.pluginOptions.args.normal.order = 1
plugin.pluginOptions.args.emphasized.name = L["Emphasized messages"]
plugin.pluginOptions.args.emphasized.order = 2

local function updateProfile()
	db = plugin.db.profile
	if normalAnchor then
		normalAnchor:RefixPosition()
		emphasizeAnchor:RefixPosition()
	end
end

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnRegister()
	db = self.db.profile

	fakeEmphasizeMessageAddon:SetSinkStorage(db.emphasizedMessages)
	self:RegisterSink("BigWigsEmphasized", "Big Wigs Emphasized", L.emphasizedSinkDescription, "EmphasizedPrint")
	self:SetSinkStorage(self.db.profile)
	self:RegisterSink("BigWigs", "Big Wigs", L.sinkDescription, "Print")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)

	if not db.font then
		db.font = media:GetDefault("font")
	end
	if not db.fontSize then
		local _, size = GameFontNormalHuge:GetFont()
		db.fontSize = size
	end
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_ResetPositions", resetAnchors)
	self:RegisterMessage("BigWigs_SetConfigureTarget")
	self:RegisterMessage("BigWigs_Message")
	self:RegisterMessage("BigWigs_EmphasizedMessage")
	self:RegisterMessage("BigWigs_StartConfigureMode", showAnchors)
	self:RegisterMessage("BigWigs_StopConfigureMode", hideAnchors)

	seModule = BigWigs:GetPlugin("Super Emphasize", true)
	colorModule = BigWigs:GetPlugin("Colors", true)

	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
end

function plugin:BigWigs_SetConfigureTarget(event, module)
	if module == self then
		normalAnchor.background:SetTexture(0.2, 1, 0.2, 0.3)
		emphasizeAnchor.background:SetTexture(0.2, 1, 0.2, 0.3)
	else
		normalAnchor.background:SetTexture(0, 0, 0, 0.3)
		emphasizeAnchor.background:SetTexture(0, 0, 0, 0.3)
	end
end

do
	local pluginOptions = nil
	function plugin:GetPluginConfig()
		if not pluginOptions then
			pluginOptions = {
				type = "group",
				get = function(info)
					local key = info[#info]
					if key == "font" then
						for i, v in next, media:List("font") do
							if v == db.font then return i end
						end
					elseif key == "outline" then
						return plugin.db.profile[key] or "NONE"
					end
					return plugin.db.profile[key]
				end,
				set = function(info, value)
					local key = info[#info]
					if key == "font" then
						local list = media:List("font")
						db.font = list[value]
					elseif key == "outline" then
						if value == "NONE" then value = nil end
						plugin.db.profile[key] = value
					else
						plugin.db.profile[key] = value
					end
				end,
				args = {
					font = {
						type = "select",
						name = L["Font"],
						order = 1,
						values = media:List("font"),
						width = "full",
						itemControl = "DDI-Font",
					},
					outline = {
						type = "select",
						name = L["Outline"],
						order = 2,
						values = {
							NONE = L["None"],
							OUTLINE = L["Thin"],
							THICKOUTLINE = L["Thick"],
						},
						width = "full",
					},
					fontSize = {
						type = "range",
						name = L["Font size"],
						order = 3,
						max = 40,
						min = 8,
						step = 1,
						width = "full",
					},
					chat = {
						type = "toggle",
						name = L["Chat frame"],
						desc = L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."],
						order = 4,
					},
					usecolors = {
						type = "toggle",
						name = L["Use colors"],
						desc = L["Toggles white only messages ignoring coloring."],
						order = 5,
					},
					monochrome = {
						type = "toggle",
						name = L["Monochrome"],
						desc = L["Toggles the monochrome flag on all messages, removing any smoothing of the font edges."],
						order = 6,
					},
					classcolor = {
						type = "toggle",
						name = L["Class colors"],
						desc = L["Colors player names in messages by their class."],
						order = 7,
					},
					useicons = {
						type = "toggle",
						name = L["Use icons"],
						desc = L["Show icons next to messages, only works for Raid Warning."],
						order = 8,
					},
				},
			}
		end
		return pluginOptions
	end
end

--------------------------------------------------------------------------------
-- Message frame
--

local function newFontString(frame, i)
	local fs = frame:CreateFontString(nil, "ARTWORK")
	fs:SetWidth(0)
	fs:SetHeight(0)
	fs.elapsed = 0
	fs:Hide()
	local icon = frame:CreateTexture(nil, "ARTWORK")
	icon:SetPoint("RIGHT", fs, "LEFT")
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	icon:Hide()
	fs.icon = icon
	return fs
end

local function onUpdate(self, elapsed)
	local show = nil
	for i, v in next, labels do
		if v:IsShown() then
			v.elapsed = v.elapsed + elapsed
			if v.bounce then
				local min = db.fontSize
				local max = min + 10
				if v.elapsed <= scaleUpTime then
					v:SetTextHeight(floor(min + ((max - min) * v.elapsed / scaleUpTime)))
				elseif v.elapsed <= scaleDownTime then
					v:SetTextHeight(floor(max - ((max - min) * (v.elapsed - scaleUpTime) / (scaleDownTime - scaleUpTime))))
				else
					v:SetTextHeight(min)
					v.bounce = nil
				end
			elseif v:GetAlpha() == 0 then
				v:Hide()
				v.icon:Hide()
			elseif v.elapsed > 7 then
				local a = math.max(1 - ((v.elapsed - 7) / 3), 0)
				v:SetAlpha(a)
				v.icon:SetAlpha(a)
			end
			show = true
		end
	end
	if not show then self:Hide() end
end

local function createSlots()
	local frame = CreateFrame("Frame", "BWMessageFrame", UIParent)
	frame:SetWidth(UIParent:GetWidth())
	frame:SetHeight(80)
	frame:SetPoint("TOP", normalAnchor, "BOTTOM")
	frame:SetScale(db.scale or 1)
	frame:SetFrameStrata("HIGH")
	frame:SetToplevel(true)
	frame:SetScript("OnUpdate", onUpdate)
	for i = 1, 4 do
		labels[i] = newFontString(frame, i)
	end
	newFontString = nil
	createSlots = nil
	return frame
end

local function getNextSlot()
	-- move 4 -> 1
	local old = labels[4]
	labels[4] = labels[3]
	labels[3] = labels[2]
	labels[2] = labels[1]
	labels[1] = old
	-- reposition
	for i = 1, 4 do
		if i == 1 then
			labels[i]:SetPoint("TOP")
		else
			labels[i]:SetPoint("TOP", labels[i - 1], "BOTTOM")
		end
	end
	-- new message at 1
	return labels[1]
end

-------------------------------------------------------------------------------
-- Event Handlers
--

do
	local parentFrame = nil
	function plugin:Print(addon, text, r, g, b, font, size, _, _, _, icon)
		if createAnchors then createAnchors() end
		if createSlots then parentFrame = createSlots() end
		parentFrame:SetScale(db.scale or 1)
		parentFrame:Show()

		local slot = getNextSlot()

		local flags = nil
		if db.monochrome and db.outline then flags = "MONOCHROME," .. db.outline
		elseif db.monochrome then flags = "MONOCHROME"
		elseif db.outline then flags = db.outline
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
			slot.icon:Show()
		else
			slot.icon:Hide()
		end
		slot:SetAlpha(1)
		slot.icon:SetAlpha(1)
		slot.elapsed = 0
		slot.bounce = true
		slot:Show()
	end
end
do
	local emphasizedText = nil
	local frame = nil
	function plugin:EmphasizedPrint(addon, text, r, g, b, font, size, _, _, _, icon)
		if createAnchors then createAnchors() end
		if not emphasizedText then
			frame = CreateFrame("Frame", "BWEmphasizeMessageFrame", UIParent)
			frame:SetFrameStrata("HIGH")
			frame:SetPoint("TOP", emphasizeAnchor, "BOTTOM")
			frame:SetWidth(UIParent:GetWidth())
			frame:SetHeight(80)
			frame:SetScript("OnUpdate", FadingFrame_OnUpdate)
			FadingFrame_OnLoad(frame)
			FadingFrame_SetFadeInTime(frame, 0.2)
			-- XXX is 1.5 + 3.5 fade enough for a super emphasized message?
			FadingFrame_SetHoldTime(frame, 1.5)
			FadingFrame_SetFadeOutTime(frame, 3.5)
			emphasizedText = frame:CreateFontString(nil, "OVERLAY", "ZoneTextFont")
			emphasizedText:SetPoint("TOP")
		end
		emphasizedText:SetText(text)
		emphasizedText:SetTextColor(r, g, b)
		FadingFrame_Show(frame)
	end
	function plugin:BigWigs_EmphasizedMessage(event, ...)
		fakeEmphasizeMessageAddon:Pour(...)
	end
end

function plugin:BigWigs_Message(event, module, key, text, color, _, sound, broadcastonly, icon)
	if broadcastonly or not text then return end

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

	if icon and db.useicons then
		local _, _, gsiIcon = GetSpellInfo(icon)
		icon = gsiIcon or icon
	else
		icon = nil
	end

	if seModule and module and key and seModule:IsSuperEmphasized(module, key) then
		if seModule.db.profile.upper then
			text = text:upper()
		end
		fakeEmphasizeMessageAddon:Pour(text, r, g, b)
	else
		self:Pour(text, r, g, b, nil, nil, nil, nil, nil, icon)
	end
	if db.chat then
		print("|cff" .. string.format("%02x%02x%02x", r * 255, g * 255, b * 255) .. text .. "|r")
	end
end

