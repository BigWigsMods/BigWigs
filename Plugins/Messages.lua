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
local messageFrame = nil
local anchor = nil
local floor = math.floor

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")

--------------------------------------------------------------------------------
-- Anchor
--

local function onDragStart(self) self:StartMoving() end
local function onDragStop(self)
	self:StopMovingOrSizing()
	local s = self:GetEffectiveScale()
	plugin.db.profile.posx = self:GetLeft() * s
	plugin.db.profile.posy = self:GetTop() * s
end

local function onControlEnter(self)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:AddLine(self.tooltipHeader)
	GameTooltip:AddLine(self.tooltipText, 1, 1, 1, 1)
	GameTooltip:Show()
end
local function onControlLeave() GameTooltip:Hide() end

local createMsgFrame
local function createAnchor()
	anchor = CreateFrame("Frame", "BigWigsMessageAnchor", UIParent)
	anchor:EnableMouse(true)
	anchor:SetMovable(true)
	anchor:RegisterForDrag("LeftButton")
	anchor:SetWidth(120)
	anchor:SetHeight(20)
	anchor:ClearAllPoints()
	local x = plugin.db.profile.posx
	local y = plugin.db.profile.posy
	local s = anchor:GetEffectiveScale()
	if not x or not y then
		anchor:SetPoint("TOP", RaidWarningFrame, "BOTTOM", 0, 45) --Below the Blizzard raid warnings
	else
		anchor:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	end
	local bg = anchor:CreateTexture(nil, "PARENT")
	bg:SetAllPoints(anchor)
	bg:SetBlendMode("BLEND")
	bg:SetTexture(0.2, 1, 0.2, 0.3)
	anchor.background = bg
	local header = anchor:CreateFontString(nil, "OVERLAY")
	header:SetFontObject(GameFontNormal)
	header:SetText(L["Messages"])
	header:SetAllPoints(anchor)
	header:SetJustifyH("CENTER")
	header:SetJustifyV("MIDDLE")
	anchor:SetScript("OnDragStart", onDragStart)
	anchor:SetScript("OnDragStop", onDragStop)
	anchor:SetScript("OnMouseUp", function(self, button)
		if button ~= "LeftButton" then return end
		plugin:SendMessage("BigWigs_SetConfigureTarget", plugin)
	end)
	anchor:Hide()
	createMsgFrame()
end

local function resetAnchor()
	anchor:ClearAllPoints()
	anchor:SetPoint("TOP", RaidWarningFrame, "BOTTOM", 0, 45) --Below the Blizzard raid warnings
	plugin.db.profile.posx = nil
	plugin.db.profile.posy = nil
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
	posx = nil,
	posy = -150,
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
	if not anchor then return end
	local x = plugin.db.profile.posx
	local y = plugin.db.profile.posy
	local s = anchor:GetEffectiveScale()
	if not x or not y then
		anchor:SetPoint("TOP", RaidWarningFrame, "BOTTOM", 0, 45) --Below the Blizzard raid warnings
	else
		anchor:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	end
end

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnRegister()
	fakeEmphasizeMessageAddon:SetSinkStorage(self.db.profile.emphasizedMessages)
	self:RegisterSink("BigWigsEmphasized", "Big Wigs Emphasized", L.emphasizedSinkDescription, "EmphasizedPrint")
	self:SetSinkStorage(self.db.profile)
	self:RegisterSink("BigWigs", "Big Wigs", L.sinkDescription, "Print")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)

	if not plugin.db.profile.font then
		plugin.db.profile.font = media:GetDefault("font")
	end
	if not plugin.db.profile.fontSize then
		local _, size = GameFontNormalHuge:GetFont()
		plugin.db.profile.fontSize = size
	end
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_ResetPositions", resetAnchor)
	self:RegisterMessage("BigWigs_SetConfigureTarget")
	self:RegisterMessage("BigWigs_Message")
	self:RegisterMessage("BigWigs_EmphasizedMessage")
	self:RegisterMessage("BigWigs_StartConfigureMode", function()
		if not anchor then createAnchor() end
		anchor:Show()
	end)
	self:RegisterMessage("BigWigs_StopConfigureMode", function()
		anchor:Hide()
	end)

	seModule = BigWigs:GetPlugin("Super Emphasize", true)
	colorModule = BigWigs:GetPlugin("Colors", true)

	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
end

function plugin:BigWigs_SetConfigureTarget(event, module)
	if module == self then
		anchor.background:SetTexture(0.2, 1, 0.2, 0.3)
	else
		anchor.background:SetTexture(0, 0, 0, 0.3)
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
							if v == plugin.db.profile.font then return i end
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
						plugin.db.profile.font = list[value]
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

local function newFontString(i)
	local fs = messageFrame:CreateFontString(nil, "ARTWORK")
	fs:SetWidth(800)
	fs:SetHeight(0)
	fs.lastUsed = 0
	FadingFrame_SetFadeInTime(fs, 0.2)
	FadingFrame_SetHoldTime(fs, 10)
	FadingFrame_SetFadeOutTime(fs, 3)
	fs:Hide()
	return fs
end

local function onUpdate(self, elapsed)
	local show = nil
	for i, v in next, labels do
		if v:IsShown() then
			if v.scrollTime then
				local min = v.minHeight
				local max = min + 10
				v.scrollTime = v.scrollTime + elapsed
				if v.scrollTime <= scaleUpTime then
					v:SetTextHeight(floor(min + ((max - min) * v.scrollTime / scaleUpTime)))
				elseif v.scrollTime <= scaleDownTime then
					v:SetTextHeight(floor(max - ((max - min) * (v.scrollTime - scaleUpTime) / (scaleDownTime - scaleUpTime))))
				else
					v:SetTextHeight(min)
					v.scrollTime = nil
				end
			end
			FadingFrame_OnUpdate(v)
			show = true
		end
	end
	if not show then self:Hide() end
end

function createMsgFrame()
	messageFrame = CreateFrame("Frame", "BWMessageFrame", UIParent)
	messageFrame:SetWidth(512)
	messageFrame:SetHeight(80)
	messageFrame:SetPoint("TOP", anchor, "BOTTOM")
	messageFrame:SetScale(plugin.db.profile.scale or 1)
	messageFrame:SetFrameStrata("HIGH")
	messageFrame:SetToplevel(true)
	messageFrame:SetScript("OnUpdate", onUpdate)
	for i = 1, 4 do
		local fs = newFontString(i)
		labels[i] = fs
		if i == 1 then
			fs:SetPoint("TOP")
		else
			fs:SetPoint("TOP", labels[i - 1], "BOTTOM")
		end
	end
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:Print(addon, text, r, g, b, font, size, _, _, _, icon)
	if not anchor then createAnchor() end
	if not messageFrame then createMsgFrame() end
	messageFrame:SetScale(self.db.profile.scale)
	messageFrame:Show()

	-- move 4 -> 1
	local old = labels[4]
	labels[4] = labels[3]
	labels[3] = labels[2]
	labels[2] = labels[1]
	labels[1] = old

	-- reposition
	for i = 1, 4 do
		labels[i]:ClearAllPoints()
		if i == 1 then
			labels[i]:SetPoint("TOP")
		else
			labels[i]:SetPoint("TOP", labels[i - 1], "BOTTOM")
		end
	end
	-- new message at 1
	local slot = labels[1]

	local flags = nil
	if plugin.db.profile.monochrome and plugin.db.profile.outline then flags = "MONOCHROME," .. plugin.db.profile.outline
	elseif plugin.db.profile.monochrome then flags = "MONOCHROME"
	elseif plugin.db.profile.outline then flags = plugin.db.profile.outline
	end
	slot:SetFont(media:Fetch("font", plugin.db.profile.font), plugin.db.profile.fontSize, flags)

	slot.minHeight = select(2, slot:GetFont())
	if icon then text = "|T"..icon..":" .. slot.minHeight .. ":" .. slot.minHeight .. ":-5|t"..text end
	slot:SetText(text)
	slot:SetTextColor(r, g, b, 1)
	slot.scrollTime = 0
	FadingFrame_Show(slot)
end
do
	local emphasizedText = nil
	local frame = nil
	function plugin:EmphasizedPrint(addon, text, r, g, b, font, size, _, _, _, icon)
		if not emphasizedText then
			frame = CreateFrame("Frame", nil, UIParent)
			frame:SetFrameStrata("HIGH")
			frame:SetPoint("CENTER")
			frame:SetWidth(UIParent:GetWidth())
			frame:SetHeight(100)
			frame:SetScript("OnUpdate", FadingFrame_OnUpdate)
			FadingFrame_OnLoad(frame)
			FadingFrame_SetFadeInTime(frame, 0.2)
			-- XXX is 1.5 + 3.5 fade enough for a super emphasized message?
			FadingFrame_SetHoldTime(frame, 1.5)
			FadingFrame_SetFadeOutTime(frame, 3.5)
			emphasizedText = frame:CreateFontString("BigWigsEmphasizedMessage", "OVERLAY", "ZoneTextFont")
			emphasizedText:SetWidth(UIParent:GetWidth())
			emphasizedText:SetHeight(100)
			emphasizedText:SetPoint("CENTER")
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
	if self.db.profile.usecolors then
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

	if icon and self.db.profile.useicons then
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
	if self.db.profile.chat then
		BigWigs:Print("|cff" .. string.format("%02x%02x%02x", r * 255, g * 255, b * 255) .. text .. "|r")
	end
end

