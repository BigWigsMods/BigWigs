--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:New("Bars 2", "$Revision$")
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Plugins")

local colors = nil
local dew = AceLibrary("Dewdrop-2.0")
local candy = LibStub("LibCandyBar-3.0")
local media = LibStub("LibSharedMedia-3.0")
local mType = media.MediaType and media.MediaType.STATUSBAR or "statusbar"
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
plugin.consoleOptions = {
	type = "group",
	name = L["Bars"],
	desc = L["Options for the timer bars."],
	handler = plugin,
	pass = true,
	get = getOption,
	set = setOption,
	args = {
		anchor = {
			type = "execute",
			name = L["Toggle anchors"],
			desc = L["Show or hide the bar anchors for both normal and emphasized bars."],
			order = 1,
			func = "ShowAnchors",
		},
		reset = {
			type = "execute",
			name = L["Reset position"],
			desc = L["Reset the anchor positions, moving them to their default positions."],
			order = 2,
			func = "ResetAnchors",
		},
		font = {
			type = "text",
			name = L["Font"],
			desc = L["Set the font for the timer bars."],
			validate = media:List("font"),
			order = 3,
		},
		texture = {
			type = "text",
			name = L["Texture"],
			desc = L["Set the texture for the timer bars."],
			validate = media:List(mType),
			order = 4,
		},
		align = {
			type = "text",
			name = L["Align"],
			desc = L["How to align the bar labels."],
			validate = {
				LEFT = L["Left"],
				CENTER = L["Center"],
				RIGHT = L["Right"],
			},
			order = 5,
		},
		time = {
			type = "toggle",
			name = L["Time"],
			desc = L["Whether to show or hide the time left on the bars."],
			order = 6,
		},
		icon = {
			type = "toggle",
			name = L["Icon"],
			desc = L["Shows or hides the bar icons."],
			order = 7,
		},
		spacer = {
			type = "header",
			name = " ",
			order = 50,
		},
		normal_header = {
			type = "header",
			name = L["Regular bars"],
			order = 99,
		},
		growup = {
			type = "toggle",
			name = L["Grow upwards"],
			desc = L["Toggle bars grow upwards/downwards from anchor."],
			order = 100,
		},
		scale = {
			type = "range",
			name = L["Scale"],
			desc = L["Set the bar scale."],
			min = 0.2,
			max = 2.0,
			step = 0.1,
			order = 103,
		},
		spacer2 = {
			type = "header",
			name = " ",
			order = 200,
		},
		emp_header = {
			type = "header",
			name = L["Emphasized bars"],
			order = 299,
		},
		emphasize = {
			type = "toggle",
			name = L["Enable"],
			desc = L["Enables emphasizing bars."],
			order = 300,
		},
		emphasizeFlash = {
			type = "toggle",
			name = L["Flash"],
			desc = L["Flashes the background of emphasized bars, which could make it easier for you to spot them."],
			order = 301,
			disabled = shouldDisableEmphasizeOption,
		},
		emphasizeMove = {
			type = "toggle",
			name = L["Move"],
			desc = L["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."],
			order = 302,
			disabled = shouldDisableEmphasizeOption,
		},
		emphasizeGrowup = {
			type = "toggle",
			name = L["Grow upwards"],
			desc = L["Toggle bars grow upwards/downwards from anchor."],
			order = 303,
			disabled = shouldDisableEmphasizeOption,
		},
		emphasizeScale = {
			type = "range",
			name = L["Scale"],
			desc = L["Set the scale for emphasized bars."],
			min = 0.2,
			max = 2.0,
			step = 0.1,
			disabled = shouldDisableEmphasizeOption,
			order = 304,
		},
	},
}

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

local function menu() dew:FeedAceOptionsTable(plugin.consoleOptions) end
local function displayOnMouseDown(self, button)
	if button == "RightButton" then
		dew:Open(self, "children", menu)
	end
end

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
	local test = CreateFrame("Button", nil, display)
	test:SetPoint("BOTTOMLEFT", display, "BOTTOMLEFT", 3, 3)
	test:SetHeight(14)
	test:SetWidth(14)
	test.tooltipHeader = L["Test"]
	test.tooltipText = L["Creates a new test bar."]
	test:SetScript("OnEnter", onControlEnter)
	test:SetScript("OnLeave", onControlLeave)
	test:SetScript("OnClick", function() plugin:TriggerEvent("BigWigs_Test") end)
	test:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\test")
	local close = CreateFrame("Button", nil, display)
	close:SetPoint("BOTTOMLEFT", test, "BOTTOMRIGHT", 4, 0)
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
	display:SetScript("OnMouseDown", displayOnMouseDown)
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
	media:Register(mType, "Otravi", "Interface\\AddOns\\BigWigs\\Textures\\otravi")
	media:Register(mType, "Smooth", "Interface\\AddOns\\BigWigs\\Textures\\smooth")
	media:Register(mType, "Glaze", "Interface\\AddOns\\BigWigs\\Textures\\glaze")
	media:Register(mType, "Charcoal", "Interface\\AddOns\\BigWigs\\Textures\\Charcoal")
	media:Register(mType, "BantoBar", "Interface\\AddOns\\BigWigs\\Textures\\default")
	candy.RegisterCallback(self, "LibCandyBar_Stop", barStopped)
	
	db = self.db.profile
	normalAnchor = createAnchor("BigWigsAnchor", L["Normal Bars"])
	emphasizeAnchor = createAnchor("BigWigsEmphasizeAnchor", L["Emphasized Bars"])
end

function plugin:OnEnable()
	if not media:Fetch(mType, db.texture, true) then db.texture = "BantoBar" end
	self:RegisterEvent("BigWigs_StartBar")
	self:RegisterEvent("BigWigs_StopBar")
	self:RegisterEvent("BigWigs_StopBars", "Ace2_AddonDisabled")
	self:RegisterEvent("Ace2_AddonDisabled")
	colors = BigWigs:GetModule("Colors")
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

function plugin:Ace2_AddonDisabled(module) stop(module) end
function plugin:BigWigs_StopBar(module, text) stop(module, text) end

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

function plugin:BigWigs_StartBar(module, text, time, icon)
	stop(module, text)
	local bar = candy:New(media:Fetch(mType, db.texture), 200, 14)
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

