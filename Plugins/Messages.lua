----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewPlugin("Messages", "$Revision$", "LibSink-2.0")
if not plugin then return end

------------------------------
--      Are you local?      --
------------------------------

local dew = AceLibrary("Dewdrop-2.0")

local minHeight = 20
local maxHeight = 30
local scaleUpTime = 0.2
local scaleDownTime = 0.4
local labels = {}

local colorModule = nil
local messageFrame = nil
local anchor = nil
local floor = math.floor

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

local function menu() dew:FeedAceOptionsTable(plugin.consoleOptions) end
local function displayOnMouseDown(self, button)
	if button == "RightButton" then
		dew:Open(self, "children", menu)
	end
end
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
	local test = CreateFrame("Button", nil, anchor)
	test:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT", 3, 3)
	test:SetHeight(14)
	test:SetWidth(14)
	test.tooltipHeader = L["Test"]
	test.tooltipText = L["Spawns a new test warning."]
	test:SetScript("OnEnter", onControlEnter)
	test:SetScript("OnLeave", onControlLeave)
	test:SetScript("OnClick", function() plugin:SendMessage("BigWigs_Test") end)
	test:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\test")
	local close = CreateFrame("Button", nil, anchor)
	close:SetPoint("BOTTOMLEFT", test, "BOTTOMRIGHT", 4, 0)
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
	anchor:SetScript("OnMouseDown", displayOnMouseDown)
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
plugin.consoleCmd = L["Messages"]

local function bwAnchorDisabled()
	return plugin.db.profile.sink20OutputSink ~= "BigWigs"
end

plugin.consoleOptions = {
	type = "group",
	name = L["Messages"],
	desc = L["Options for message display."],
	handler = plugin,
	pass = true,
	get = function(key)
		if key == "anchor" then
			return anchor and anchor:IsShown()
		else
			return plugin.db.profile[key]
		end
	end,
	set = function(key, val)
		if key == "anchor" then
			if not anchor then createAnchor() end
			if val then
				anchor:Show()
			else
				anchor:Hide()
			end
		else
			plugin.db.profile[key] = val
		end
	end,
	args = {
		anchor = {
			type = "toggle",
			name = L["Show anchor"],
			desc = L["Show the message anchor frame.\n\nNote that the anchor is only usable if you select 'BigWigs' as Output."],
			disabled = bwAnchorDisabled,
			order = 1,
		},
		reset = {
			type = "execute",
			name = L["Reset position"],
			desc = L["Reset the anchor position, moving it to the center of your screen."],
			func = resetAnchor,
			disabled = bwAnchorDisabled,
			order = 2,
		},
		scale = {
			type = "range",
			name = L["Scale"],
			desc = L["Set the message frame scale."],
			min = 0.2,
			max = 5.0,
			step = 0.1,
			disabled = bwAnchorDisabled,
			order = 3,
		},
		spacer = {
			type = "header",
			name = " ",
			order = 4,
		},
		generalHeader = {
			type = "header",
			name = L["Output Settings"],
			order = 10,
		},
		chat = {
			type = "toggle",
			name = L["Chat frame"],
			desc = L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."],
			order = 101,
		},
		usecolors = {
			type = "toggle",
			name = L["Use colors"],
			desc = L["Toggles white only messages ignoring coloring."],
			map = {[true] = L["|cffff0000Co|cffff00fflo|cff00ff00r|r"], [false] = L["White"]},
			order = 102,
			disabled = function() return not colorModule end,
		},
		classcolor = {
			type = "toggle",
			name = L["Class colors"],
			desc = L["Colors player names in messages by their class."],
			order = 103,
		},
		useicons = {
			type = "toggle",
			name = L["Use icons"],
			desc = L["Show icons next to messages, only works for Raid Warning."],
			order = 104,
		},
	},
}

------------------------------
--      Initialization      --
------------------------------

function plugin:OnRegister()
	self:SetSinkStorage(self.db.profile)

	self:RegisterSink("BigWigs", "BigWigs", nil, "Print")

	self.consoleOptions.args.output = self:GetSinkAce2OptionsDataTable().output
	self.consoleOptions.args.output.order = 100
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

