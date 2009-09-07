--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Bars", "$Revision$")
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Plugins")

local AceGUI = LibStub("AceGUI-3.0")

local colors = nil
local candy = LibStub("LibCandyBar-3.0")
local media = LibStub("LibSharedMedia-3.0")
local db = nil
local normalAnchor, emphasizeAnchor = nil, nil
local empUpdate = nil -- emphasize updater frame

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	scale = 1.0,
	texture = "BantoBar",
	font = "Friz Quadrata TT",
	growup = true,
	time = true,
	align = "LEFT",
	icon = true,
	emphasize = true,
	emphasizeFlash = true,
	emphasizeMove = true,
	emphasizeScale = 1.5,
	emphasizeGrowup = nil,
	BigWigsAnchor_width = 200,
	BigWigsEmphasizeAnchor_width = 300,
}

local function getOption(key) return plugin.db.profile[key] end
local function setOption(key, value) plugin.db.profile[key] = value end
local function shouldDisableEmphasizeOption() return not plugin.db.profile.emphasize end

--------------------------------------------------------------------------------
-- Bar arrangement
--

local function barSorter(a, b)
	return a.remaining < b.remaining and true or false
end
local tmp = {}
local function rearrangeBars(anchor)
	wipe(tmp)
	for bar in pairs(anchor.bars) do
		table.insert(tmp, bar)
	end
	table.sort(tmp, barSorter)
	local lastDownBar, lastUpBar = nil, nil
	local up = nil
	if anchor == normalAnchor then up = db.growup else up = db.emphasizeGrowup end
	for i, bar in ipairs(tmp) do
		bar:ClearAllPoints()
		if up or (db.emphasizeGrowup and bar:Get("bigwigs:emphasized")) then
			bar:SetPoint("BOTTOMLEFT", lastUpBar or anchor, "TOPLEFT")
			bar:SetPoint("BOTTOMRIGHT", lastUpBar or anchor, "TOPRIGHT")
			lastUpBar = bar
		else
			bar:SetPoint("TOPLEFT", lastDownBar or anchor, "BOTTOMLEFT")
			bar:SetPoint("TOPRIGHT", lastDownBar or anchor, "BOTTOMRIGHT")
			lastDownBar = bar
		end
	end
	if #tmp > 0 then
		empUpdate:Show()
	else
		empUpdate:Hide()
	end
end

local function barStopped(event, bar)
	local a = bar:Get("bigwigs:anchor")
	if a and a.bars and a.bars[bar] then
		a.bars[bar] = nil
		rearrangeBars(a)
	end
end

--------------------------------------------------------------------------------
-- Anchors
--
local defaultPositions = {
	BigWigsAnchor = {"CENTER", "UIParent", "CENTER", 0, -50},
	BigWigsEmphasizeAnchor = {"TOP", RaidWarningFrame, "BOTTOM", 0, -35}, --Below the default BigWigs message frame
}

local function onDragHandleMouseDown(self) self:GetParent():StartSizing("BOTTOMRIGHT") end
local function onDragHandleMouseUp(self, button) self:GetParent():StopMovingOrSizing() end
local function onResize(self, width)
	db[self.w] = width
	rearrangeBars(self)
end
local function onDragStart(self) self:StartMoving() end
local function onDragStop(self)
	self:StopMovingOrSizing()
	local s = self:GetEffectiveScale()
	db[self.x] = self:GetLeft() * s
	db[self.y] = self:GetTop() * s
end

local function onControlEnter(self)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:AddLine(self.tooltipHeader)
	GameTooltip:AddLine(self.tooltipText, 1, 1, 1, 1)
	GameTooltip:Show()
end
local function onControlLeave() GameTooltip:Hide() end

local function createAnchor(frameName, title)
	local display = CreateFrame("Frame", frameName, UIParent)
	local wKey, xKey, yKey = frameName .. "_width", frameName .. "_x", frameName .. "_y"
	display.w, display.x, display.y = wKey, xKey, yKey
	display:EnableMouse(true)
	display:SetClampedToScreen(true)
	display:SetMovable(true)
	display:SetResizable(true)
	display:RegisterForDrag("LeftButton")
	display:SetWidth(db[wKey] or 200)
	display:SetHeight(20)
	display:SetMinResize(80, 20)
	display:SetMaxResize(1920, 20)
	display:ClearAllPoints()
	if db[xKey] and db[yKey] then
		local s = display:GetEffectiveScale()
		display:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", db[xKey] / s, db[yKey] / s)
	else
		display:SetPoint(unpack(defaultPositions[frameName]))
	end
	local bg = display:CreateTexture(nil, "PARENT")
	bg:SetAllPoints(display)
	bg:SetBlendMode("BLEND")
	bg:SetTexture(0, 0, 0, 0.3)
	local header = display:CreateFontString(nil, "OVERLAY")
	header:SetFontObject(GameFontNormal)
	header:SetText(title)
	header:SetAllPoints(display)
	header:SetJustifyH("CENTER")
	header:SetJustifyV("MIDDLE")
	local drag = CreateFrame("Frame", nil, display)
	drag:SetFrameLevel(display:GetFrameLevel() + 10)
	drag:SetWidth(16)
	drag:SetHeight(16)
	drag:SetPoint("BOTTOMRIGHT", display, -1, 1)
	drag:EnableMouse(true)
	drag:SetScript("OnMouseDown", onDragHandleMouseDown)
	drag:SetScript("OnMouseUp", onDragHandleMouseUp)
	drag:SetAlpha(0.5)
	local tex = drag:CreateTexture(nil, "BACKGROUND")
	tex:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\draghandle")
	tex:SetWidth(16)
	tex:SetHeight(16)
	tex:SetBlendMode("ADD")
	tex:SetPoint("CENTER", drag)
	local close = CreateFrame("Button", nil, display)
	close:SetPoint("BOTTOMLEFT", display, "BOTTOMLEFT", 3, 3)
	close:SetHeight(14)
	close:SetWidth(14)
	close.tooltipHeader = L["Hide"]
	close.tooltipText = L["Hides the anchors."]
	close:SetScript("OnEnter", onControlEnter)
	close:SetScript("OnLeave", onControlLeave)
	close:SetScript("OnClick", function() plugin:ShowAnchors() end)
	close:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\close")
	display:SetScript("OnSizeChanged", onResize)
	display:SetScript("OnDragStart", onDragStart)
	display:SetScript("OnDragStop", onDragStop)
	display.bars = {}
	display:Hide()
	return display
end

function plugin:ShowAnchors()
	if normalAnchor:IsShown() then
		normalAnchor:Hide()
		emphasizeAnchor:Hide()
	else
		normalAnchor:Show()
		emphasizeAnchor:Show()
	end
end

function plugin:ResetAnchors()
	normalAnchor:ClearAllPoints()
	normalAnchor:SetPoint(unpack(defaultPositions[normalAnchor:GetName()]))
	db[normalAnchor.x] = nil
	db[normalAnchor.y] = nil
	db[normalAnchor.w] = nil
	normalAnchor:SetWidth(self.defaultDB[normalAnchor.w])
	emphasizeAnchor:ClearAllPoints()
	emphasizeAnchor:SetPoint(unpack(defaultPositions[emphasizeAnchor:GetName()]))
	db[emphasizeAnchor.x] = nil
	db[emphasizeAnchor.y] = nil
	db[emphasizeAnchor.w] = nil
	emphasizeAnchor:SetWidth(self.defaultDB[emphasizeAnchor.w])
end

--------------------------------------------------------------------------------
-- Initialization
--
function plugin:OnRegister()
	media:Register("statusbar", "Otravi", "Interface\\AddOns\\BigWigs\\Textures\\otravi")
	media:Register("statusbar", "Smooth", "Interface\\AddOns\\BigWigs\\Textures\\smooth")
	media:Register("statusbar", "Glaze", "Interface\\AddOns\\BigWigs\\Textures\\glaze")
	media:Register("statusbar", "Charcoal", "Interface\\AddOns\\BigWigs\\Textures\\Charcoal")
	media:Register("statusbar", "BantoBar", "Interface\\AddOns\\BigWigs\\Textures\\default")
	candy.RegisterCallback(self, "LibCandyBar_Stop", barStopped)
	
	db = self.db.profile
end

function plugin:OnPluginEnable()
	if not normalAnchor then
		normalAnchor = createAnchor("BigWigsAnchor", L["Normal Bars"])
		emphasizeAnchor = createAnchor("BigWigsEmphasizeAnchor", L["Emphasized Bars"])
	end
	
	if not media:Fetch("statusbar", db.texture, true) then db.texture = "BantoBar" end
	self:RegisterMessage("BigWigs_StartBar")
	self:RegisterMessage("BigWigs_StopBar")
	self:RegisterMessage("BigWigs_StopBars", "BigWigs_OnBossDisable")
	self:RegisterMessage("BigWigs_OnBossDisable")
	self:RegisterMessage("BigWigs_OnPluginDisable", "BigWigs_OnBossDisable")
	self:RegisterMessage("BigWigs_TemporaryConfig", "ShowAnchors")
	colors = BigWigs:GetPlugin("Colors")
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
		local tex = AceGUI:Create("Dropdown")
		do
			local list = media:List("statusbar")
			local selected = nil
			for k, v in pairs(list) do
				if v == db.texture then
					selected = k
					break
				end
			end
			tex:SetList(list)
			tex:SetValue(selected)
			tex:SetLabel(L["Texture"])
			tex:SetCallback("OnValueChanged", textureChanged)
			tex:SetFullWidth(true)
		end
	
		local font = AceGUI:Create("Dropdown")
		do
			local list = media:List("font")
			local selected = nil
			for k, v in pairs(list) do
				if v == db.font then
					selected = k
					break
				end
			end
			font:SetList(list)
			font:SetValue(selected)
			font:SetLabel(L["Font"])
			font:SetCallback("OnValueChanged", fontChanged)
			font:SetFullWidth(true)
		end

		local align = AceGUI:Create("Dropdown")
		align:SetList({ ["LEFT"] = L["Left"], ["CENTER"] = L["Center"], ["RIGHT"] = L["Right"] })
		align:SetValue(db.align)
		align:SetLabel(L["Align"])
		align:SetCallback("OnValueChanged", alignChanged)
		align:SetFullWidth(true)

		local icon = AceGUI:Create("CheckBox")
		icon:SetValue(db.icon)
		icon:SetLabel(L["Icon"])
		icon:SetUserData("key", "icon")
		icon:SetCallback("OnValueChanged", checkboxCallback)
		icon:SetUserData("tooltip", L["Shows or hides the bar icons."])
		icon:SetCallback("OnEnter", onControlEnter)
		icon:SetCallback("OnLeave", onControlLeave)
		icon:SetRelativeWidth(0.5)
	
		local duration = AceGUI:Create("CheckBox")
		duration:SetValue(db.time)
		duration:SetLabel(L["Time"])
		duration:SetUserData("key", "time")
		duration:SetCallback("OnValueChanged", checkboxCallback)
		duration:SetUserData("tooltip", L["Whether to show or hide the time left on the bars."])
		duration:SetCallback("OnEnter", onControlEnter)
		duration:SetCallback("OnLeave", onControlLeave)
		duration:SetRelativeWidth(0.5)

		local normal = AceGUI:Create("InlineGroup")
		normal:SetTitle(L["Regular bars"])
		normal:SetFullWidth(true)
		
		do
			local growup = AceGUI:Create("CheckBox")
			growup:SetValue(db.growup)
			growup:SetLabel(L["Grow upwards"])
			growup:SetUserData("key", "growup")
			growup:SetCallback("OnValueChanged", checkboxCallback)
			growup:SetUserData("tooltip", L["Toggle bars grow upwards/downwards from anchor."])
			growup:SetCallback("OnEnter", onControlEnter)
			growup:SetCallback("OnLeave", onControlLeave)
			growup:SetRelativeWidth(0.5)
		
			local scale = AceGUI:Create("Slider")
			scale:SetValue(db.scale)
			scale:SetSliderValues(0.2, 2.0, 0.1)
			scale:SetLabel(L["Scale"])
			scale:SetUserData("key", "scale")
			scale:SetCallback("OnValueChanged", scaleChanged)
			scale:SetFullWidth(true)
			normal:AddChildren(growup, scale)
		end

		local emphasize = AceGUI:Create("InlineGroup")
		emphasize:SetTitle(L["Emphasized bars"])
		emphasize:SetFullWidth(true)
		
		do
			local enable = AceGUI:Create("CheckBox")
			enable:SetValue(db.emphasize)
			enable:SetLabel(L["Enable"])
			enable:SetUserData("key", "emphasize")
			enable:SetCallback("OnValueChanged", checkboxCallback)
			enable:SetRelativeWidth(0.5)
		
			local flash = AceGUI:Create("CheckBox")
			flash:SetValue(db.emphasizeFlash)
			flash:SetLabel(L["Flash"])
			flash:SetUserData("key", "emphasizeFlash")
			flash:SetCallback("OnValueChanged", checkboxCallback)
			flash:SetUserData("tooltip", L["Flashes the background of emphasized bars, which could make it easier for you to spot them."])
			flash:SetCallback("OnEnter", onControlEnter)
			flash:SetCallback("OnLeave", onControlLeave)
			flash:SetRelativeWidth(0.5)
		
			local move = AceGUI:Create("CheckBox")
			move:SetValue(db.emphasizeMove)
			move:SetLabel(L["Move"])
			move:SetUserData("key", "emphasizeMove")
			move:SetCallback("OnValueChanged", checkboxCallback)
			move:SetUserData("tooltip", L["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."])
			move:SetCallback("OnEnter", onControlEnter)
			move:SetCallback("OnLeave", onControlLeave)
			move:SetRelativeWidth(0.5)

			local growup = AceGUI:Create("CheckBox")
			growup:SetValue(db.emphasizeGrowup)
			growup:SetLabel(L["Grow upwards"])
			growup:SetUserData("key", "emphasizeGrowup")
			growup:SetCallback("OnValueChanged", checkboxCallback)
			growup:SetUserData("tooltip", L["Toggle bars grow upwards/downwards from anchor."])
			growup:SetCallback("OnEnter", onControlEnter)
			growup:SetCallback("OnLeave", onControlLeave)
			growup:SetRelativeWidth(0.5)

			local scale = AceGUI:Create("Slider")
			scale:SetValue(db.emphasizeScale)
			scale:SetSliderValues(0.2, 2.0, 0.1)
			scale:SetLabel(L["Scale"])
			scale:SetUserData("key", "emphasizeScale")
			scale:SetCallback("OnValueChanged", scaleChanged)
			scale:SetFullWidth(true)
		
			emphasize:AddChildren(enable, flash, move, growup, scale)
		end
		
		return tex, font, align, icon, duration, normal, emphasize
	end
end

--------------------------------------------------------------------------------
-- Colors
--

local function colorNormal() return unpack(colors.db.profile.barColor) end
local function colorEmphasized() return unpack(colors.db.profile.barEmphasized) end
local function colorText() return unpack(colors.db.profile.barText) end
local function colorBackground() return unpack(colors.db.profile.barBackground) end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function stopBars(bars, module, text)
	local dirty = nil
	for k in pairs(bars) do
		if k:Get("bigwigs:module") == module and (not text or k.candyBarLabel:GetText() == text) then
			k:Stop()
			dirty = true
		end
	end
	return dirty
end

local function stop(module, text)
	local d = stopBars(normalAnchor.bars, module, text)
	if d then rearrangeBars(normalAnchor) end
	d = stopBars(emphasizeAnchor.bars, module, text)
	if d then rearrangeBars(emphasizeAnchor) end
end

function plugin:BigWigs_OnBossDisable(message, module) stop(module) end
function plugin:BigWigs_StopBar(message, module, text) stop(module, text) end

do
	empUpdate = CreateFrame("Frame")
	empUpdate:Hide()
	local total = 0
	empUpdate:SetScript("OnUpdate", function(self, elapsed)
		if not db.emphasize then return end
		local dirty = nil
		for k in pairs(normalAnchor.bars) do
			if not k:Get("bigwigs:emphasized") and k.remaining <= 10 then
				plugin:EmphasizeBar(k)
				dirty = true
			end
		end
		if dirty then
			rearrangeBars(normalAnchor)
			rearrangeBars(emphasizeAnchor)
		end
	end)
end

function plugin:BigWigs_StartBar(message, module, text, time, icon)
	stop(module, text)
	local bar = candy:New(media:Fetch("statusbar", db.texture), 200, 14)
	normalAnchor.bars[bar] = true
	bar.candyBarBackground:SetVertexColor(colorBackground())
	bar:Set("bigwigs:module", module)
	bar:Set("bigwigs:anchor", normalAnchor)
	bar:SetColor(colorNormal())
	bar.candyBarLabel:SetTextColor(colorText())
	bar.candyBarLabel:SetJustifyH(db.align)
	bar.candyBarLabel:SetFont(media:Fetch("font", db.font), 10)
	bar.candyBarDuration:SetFont(media:Fetch("font", db.font), 10)
	bar:SetLabel(text)
	bar:SetClampedToScreen(true)
	bar:SetDuration(time)
	bar:SetTimeVisibility(db.time)
	bar:SetIcon(db.icon and icon or nil)
	bar:SetScale(db.scale)
	if db.emphasize and time < 15 then
		self:EmphasizeBar(bar)
	end
	bar:Start()
	rearrangeBars(bar:Get("bigwigs:anchor"))
end

--------------------------------------------------------------------------------
-- Emphasize
--

local function flash(self)
	local r, g, b, a = self.candyBarBackground:GetVertexColor()
	if self:Get("bigwigs:down") then
		r = r - 0.05
		if r <= 0 then self:Set("bigwigs:down", nil) end
	else
		r = r + 0.05
		if r >= 1 then self:Set("bigwigs:down", true) end
	end
	self.candyBarBackground:SetVertexColor(r, g, b, a)
end

function plugin:EmphasizeBar(bar)
	if db.emphasizeMove then
		normalAnchor.bars[bar] = nil
		emphasizeAnchor.bars[bar] = true
		bar:Set("bigwigs:anchor", emphasizeAnchor)
		bar:Start() -- restart the bar -> remaining time is a full length bar again after moving it to the emphasize anchor
	end
	if db.emphasizeFlash then
		bar:AddUpdateFunction(flash)
	end
	bar:SetColor(colorEmphasized())
	bar:SetScale(db.emphasizeScale)
	bar:Set("bigwigs:emphasized", true)
end

