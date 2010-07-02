-------------------------------------------------------------------------------
-- Module Declaration
--


local plugin = BigWigs:NewPlugin("Messages", "LibSink-2.0")
if not plugin then return end

-------------------------------------------------------------------------------
-- Locals
--

local scaleUpTime = 0.2
local scaleDownTime = 0.4
local labels = {}

local seModule = nil
local colorModule = nil
local messageFrame = nil
local anchor = nil
local floor = math.floor

local AceGUI = nil

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
	local function onControlEnter(widget, event, value)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(widget.frame, "ANCHOR_CURSOR")
		GameTooltip:AddLine(widget.text and widget.text:GetText() or widget.label:GetText())
		GameTooltip:AddLine(widget:GetUserData("tooltip"), 1, 1, 1, 1)
		GameTooltip:Show()
	end
	local function onControlLeave() GameTooltip:Hide() end

	local function checkboxCallback(widget, event, value)
		local key = widget:GetUserData("key")
		plugin.db.profile[key] = value and true or false
	end

	function plugin:GetPluginConfig()
		if not AceGUI then AceGUI = LibStub("AceGUI-3.0") end

		local chat = AceGUI:Create("CheckBox")
		chat:SetLabel(L["Chat frame"])
		chat:SetValue(self.db.profile.chat and true or false)
		chat:SetCallback("OnEnter", onControlEnter)
		chat:SetCallback("OnLeave", onControlLeave)
		chat:SetCallback("OnValueChanged", checkboxCallback)
		chat:SetUserData("key", "chat")
		chat:SetUserData("tooltip", L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."])

		local colors = AceGUI:Create("CheckBox")
		colors:SetLabel(L["Use colors"])
		colors:SetValue(self.db.profile.usecolors and true or false)
		colors:SetCallback("OnEnter", onControlEnter)
		colors:SetCallback("OnLeave", onControlLeave)
		colors:SetCallback("OnValueChanged", checkboxCallback)
		colors:SetUserData("key", "usecolors")
		colors:SetUserData("tooltip", L["Toggles white only messages ignoring coloring."])

		local classColors = AceGUI:Create("CheckBox")
		classColors:SetLabel(L["Class colors"])
		classColors:SetValue(self.db.profile.classcolor and true or false)
		classColors:SetCallback("OnEnter", onControlEnter)
		classColors:SetCallback("OnLeave", onControlLeave)
		classColors:SetCallback("OnValueChanged", checkboxCallback)
		classColors:SetUserData("key", "classcolor")
		classColors:SetUserData("tooltip", L["Colors player names in messages by their class."])

		local icons = AceGUI:Create("CheckBox")
		icons:SetLabel(L["Use icons"])
		icons:SetValue(self.db.profile.useicons and true or false)
		icons:SetCallback("OnEnter", onControlEnter)
		icons:SetCallback("OnLeave", onControlLeave)
		icons:SetCallback("OnValueChanged", checkboxCallback)
		icons:SetUserData("key", "useicons")
		icons:SetUserData("tooltip", L["Show icons next to messages, only works for Raid Warning."])
--[[
		local normal = AceGUI:Create("InlineGroup")
		normal:SetTitle(L["Normal messages"])
		normal:SetFullWidth(true)

		do
			
			normal:AddChildren()
		end
		
		local emphasized = AceGUI:Create("InlineGroup")
		emphasized:SetTitle(L["Emphasized messages"])
		emphasized:SetFullWidth(true)
		
		do
		
			emphasized:AddChildren()
		end
]]
		return chat, colors, classColors, icons
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

	local f = font or GameFontNormalHuge
	local face, size, flags = f:GetFont()
	slot:SetFont(face, size, "THICKOUTLINE")

	--slot:SetFontObject(font or GameFontNormalHuge)
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

