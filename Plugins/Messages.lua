----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewPlugin("Messages", "$Revision$", "LibSink-2.0")
if not plugin then return end

------------------------------
--      Are you local?      --
------------------------------

local minHeight = 20
local maxHeight = 30
local scaleUpTime = 0.2
local scaleDownTime = 0.4
local labels = {}

local colorModule = nil
local messageFrame = nil
local anchor = nil
local floor = math.floor

local AceGUI = LibStub("AceGUI-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Plugins")

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
	bg:SetTexture(0, 0, 0, 0.3)
	local header = anchor:CreateFontString(nil, "OVERLAY")
	header:SetFontObject(GameFontNormal)
	header:SetText(L["Messages"])
	header:SetAllPoints(anchor)
	header:SetJustifyH("CENTER")
	header:SetJustifyV("MIDDLE")
	local close = CreateFrame("Button", nil, anchor)
	close:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT", 3, 3)
	close:SetHeight(14)
	close:SetWidth(14)
	close.tooltipHeader = L["Hide"]
	close.tooltipText = L["Hides the anchors."]
	close:SetScript("OnEnter", onControlEnter)
	close:SetScript("OnLeave", onControlLeave)
	close:SetScript("OnClick", function() anchor:Hide() end)
	close:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\close")
	anchor:SetScript("OnDragStart", onDragStart)
	anchor:SetScript("OnDragStop", onDragStop)
	anchor:Hide()
	createMsgFrame()
end

local function resetAnchor()
	if anchor then
		anchor:ClearAllPoints()
		anchor:SetPoint("TOP", RaidWarningFrame, "BOTTOM", 0, 45) --Below the Blizzard raid warnings
	end
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
}

------------------------------
--      Initialization      --
------------------------------

function plugin:OnRegister()
	self:SetSinkStorage(self.db.profile)

	self:RegisterSink("BigWigs", "BigWigs", nil, "Print")
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_Message")
	self:RegisterMessage("BigWigs_TemporaryConfig", function()
		if not anchor then createAnchor() end
		if anchor:IsShown() then
			anchor:Hide()
		else
			anchor:Show()
		end
	end)

	colorModule = BigWigs:GetPlugin("Colors", true)
end

function plugin:OnPluginDisable() if anchor then anchor:Hide() end end

do
	local function onControlEnter(widget, event, value)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(widget.frame, "ANCHOR_CURSOR")
		GameTooltip:AddLine(widget.text and widget.text:GetText() or widget.label:GetText())
		GameTooltip:AddLine(widget:GetUserData("tooltip"), 1, 1, 1, 1)
		GameTooltip:Show()
	end
	local function onControlLeave() GameTooltip:Hide() end

	-- XXX We need a new SinkLib that doesn't give out options but only access to functions
	-- XXX we can use to generate options with.
	-- Or, we can use AceConfig and insert an option table into the container, I guess.
	-- Actually, just leaving the options as they are in a table and using aceconfig to
	-- generate the whole thing means less code in the modules but more processing
	-- in acegui, I guess. Also we might not get it looking "just right".

	local function checkboxCallback(widget, event, value)
		local key = widget:GetUserData("key")
		plugin.db.profile[key] = value and true or false
	end

	function plugin:GetPluginConfig()
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

		return chat, colors, classColors, icons
	end
end

--------------------------------------------------------------------------------
-- Message frame
--

local function newFontString(i)
	local fs = messageFrame:CreateFontString(nil, "ARTWORK")
	fs:SetFontObject(GameFontNormalHuge)
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
				v.scrollTime = v.scrollTime + elapsed
				if v.scrollTime <= scaleUpTime then
					v:SetTextHeight(floor(minHeight + ((maxHeight - minHeight) * v.scrollTime / scaleUpTime)))
				elseif v.scrollTime <= scaleDownTime then
					v:SetTextHeight(floor(maxHeight - ((maxHeight - minHeight) * (v.scrollTime - scaleUpTime) / (scaleDownTime - scaleUpTime))))
				else
					v:SetTextHeight(minHeight)
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
		table.insert(labels, fs)
		if i == 1 then
			fs:SetPoint("TOP")
		else
			fs:SetPoint("TOP", labels[i - 1], "BOTTOM")
		end
	end
end

------------------------------
--      Event Handlers      --
------------------------------

function plugin:Print(addon, text, r, g, b, _, _, _, _, _, icon)
	if not anchor then createAnchor() end
	if not messageFrame then createMsgFrame() end
	messageFrame:SetScale(self.db.profile.scale)
	messageFrame:Show()
	if icon then text = "|T"..icon..":20:20:-5|t"..text end
	
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

	slot:SetText(text)
	slot:SetTextColor(r, g, b, 1)
	slot.scrollTime = 0
	slot:SetTextHeight(minHeight)
	FadingFrame_Show(slot)
end

function plugin:BigWigs_Message(event, text, color, _, sound, broadcastonly, icon)
	if broadcastonly or not text then return end

	local db = self.db.profile
	local r, g, b = 1, 1, 1 -- Default to white.
	if db.usecolors then
		if type(color) == "table" and color.r and color.g and color.b then
			r, g, b = color.r, color.g, color.b
		elseif colorModule and colorModule:HasMessageColor(color) then
			r, g, b = colorModule:MsgColor(color)
		end
	end

	if icon and db.useicons then
		local _, _, gsiIcon = GetSpellInfo(icon)
		icon = gsiIcon or icon
	else
		icon = nil
	end

	self:Pour(text, r, g, b, nil, nil, nil, nil, nil, icon)
	if db.chat then
		-- FIXME: fix bigwigs customprint, or a special print function in this module
		BigWigs:Print( text )
		-- BigWigs:CustomPrint(r, g, b, nil, nil, nil, text)
	end
end

