assert(BigWigs, "BigWigs not found!")

--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:New("Bars 2", "$Revision$")
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigsBars2")

local candy = LibStub("LibCandyBar-3.0")
local media = LibStub("LibSharedMedia-3.0")
local mType = media.MediaType and media.MediaType.STATUSBAR or "statusbar"
local db = nil
local normalAnchor, emphasizeAnchor = nil, nil

--------------------------------------------------------------------------------
-- Localization
--

L:RegisterTranslations("enUS", function() return {
	["Bars"] = true,
	["Emphasized Bars"] = true,
	["Options for the timer bars."] = true,
	["Toggle anchors"] = true,
	["Show or hide the bar anchors for both normal and emphasized bars."] = true,
	["Scale"] = true,
	["Set the bar scale."] = true,
	["Grow upwards"] = true,
	["Toggle bars grow upwards/downwards from anchor."] = true,
	["Texture"] = true,
	["Set the texture for the timer bars."] = true,
	["Test"] = true,
	["Close"] = true,
	["Emphasize"] = true,
	["Emphasize bars that are close to completion (<10sec). Also note that bars started at less than 15 seconds initially will be emphasized right away."] = true,
	["Enable"] = true,
	["Enables emphasizing bars."] = true,
	["Set the scale for emphasized bars."] = true,
	["Reset position"] = true,
	["Reset the anchor positions, moving them to their default positions."] = true,
} end)

--------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	scale = 1.0,
	texture = "BantoBar",
	growup = true,
	emphasize = true,
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
		texture = {
			type = "text",
			name = L["Texture"],
			desc = L["Set the texture for the timer bars."],
			validate = media:List(mType),
			order = 3,
			get = getOption,
			set = setOption,
			passValue = "texture",
		},
		spacer = {
			type = "header",
			name = " ",
			order = 50,
		},
		normal_header = {
			type = "header",
			name = "Regular bars",
			order = 99,
		},
		growup = {
			type = "toggle",
			name = L["Grow upwards"],
			desc = L["Toggle bars grow upwards/downwards from anchor."],
			order = 100,
			get = getOption,
			set = setOption,
			passValue = "growup",
		},
		scale = {
			type = "range",
			name = L["Scale"],
			desc = L["Set the bar scale."],
			min = 0.2,
			max = 2.0,
			step = 0.1,
			order = 103,
			get = getOption,
			set = setOption,
			passValue = "scale",
		},
		spacer2 = {
			type = "header",
			name = " ",
			order = 200,
		},
		emp_header = {
			type = "header",
			name = "Emphasized bars",
			order = 299,
		},
		emphasize = {
			type = "toggle",
			name = L["Enable"],
			desc = L["Enables emphasizing bars."],
			get = getOption,
			set = setOption,
			passValue = "emphasize",
			order = 300,
		},
		emphasizeGrowup = {
			type = "toggle",
			name = L["Grow upwards"],
			desc = L["Toggle bars grow upwards/downwards from anchor."],
			order = 301,
			get = getOption,
			set = setOption,
			passValue = "emphasizeGrowup",
			disabled = shouldDisableEmphasizeOption,
		},
		emphasizeScale = {
			type = "range",
			name = L["Scale"],
			desc = L["Set the scale for emphasized bars."],
			min = 0.2,
			max = 2.0,
			step = 0.1,
			get = getOption,
			set = setOption,
			passValue = "emphasizeScale",
			disabled = shouldDisableEmphasizeOption,
			order = 302,
		},
	},
}

--------------------------------------------------------------------------------
-- Bar arrangement
--

local function barSorter(a, b)
	return a.remaining > b.remaining and true or false
end
local tmp = {}
local function rearrangeBars(anchor)
	wipe(tmp)
	for bar in pairs(anchor.bars) do
		table.insert(tmp, bar)
	end
	table.sort(tmp, barSorter)
	local lastBar = nil
	local up = anchor == normalAnchor and db.growup or db.emphasizeGrowup
	for i, bar in ipairs(tmp) do
		bar:ClearAllPoints()
		if up then
			bar:SetPoint("BOTTOMLEFT", lastBar or anchor, "TOPLEFT")
			bar:SetPoint("BOTTOMRIGHT", lastBar or anchor, "TOPRIGHT")
		else
			bar:SetPoint("TOPLEFT", lastBar or anchor, "BOTTOMLEFT")
			bar:SetPoint("TOPRIGHT", lastBar or anchor, "BOTTOMRIGHT")
		end
		lastBar = bar
	end
end

local function barStopped(event, bar)
	local a = bar:Get("anchor")
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
	BigWigsEmphasizeAnchor = {"CENTER", "UIParent", "CENTER", 0, 400},
}

local function onDragHandleMouseDown(self) self:GetParent():StartSizing("BOTTOMRIGHT") end
local function onDragHandleMouseUp(self, button) self:GetParent():StopMovingOrSizing() end
local function onResize(self, width)
	db[self.w] = width
	rearrangeBars(self)
end
local function onMouseDown(self, button)
	if button == "RightButton" then showBarConfig() end
end
local function onDragStart(self) self:StartMoving() end
local function onDragStop(self)
	self:StopMovingOrSizing()
	local s = self:GetEffectiveScale()
	db[self.x] = self:GetLeft() * s
	db[self.y] = self:GetTop() * s
end

local function createAnchor(frameName, title)
	local display = CreateFrame("Frame", frameName, UIParent)
	local wKey, xKey, yKey = frameName .. "_width", frameName .. "_x", frameName .. "_y"
	display.w, display.x, display.y = wKey, xKey, yKey
	display:EnableMouse(true)
	display:SetMovable(true)
	display:SetResizable(true)
	display:RegisterForDrag("LeftButton")
	display:SetWidth(db[wKey] or 200)
	display:SetHeight(20)
	display:SetMinResize(80, 20)
	display:SetMaxResize(1920, 20)
	display:SetScript("OnSizeChanged", onResize)
	display:SetScript("OnDragStart", onDragStart)
	display:SetScript("OnDragStop", onDragStop)
	display:SetScript("OnMouseDown", displayOnMouseDown)
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
	normalAnchor = createAnchor("BigWigsAnchor", "Normal Bars")
	emphasizeAnchor = createAnchor("BigWigsEmphasizeAnchor", "Emphasized Bars")
end

function plugin:OnEnable()
	if not media:Fetch(mType, db.texture, true) then db.texture = "BantoBar" end
	self:RegisterEvent("BigWigs_StartBar")
	self:RegisterEvent("BigWigs_StopBar")
	self:RegisterEvent("Ace2_AddonDisabled")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function stopBars(bars, module, text)
	local dirty = nil
	for k in pairs(bars) do
		if k:Get("module") == module and (not text or k.candyBarLabel:GetText() == text) then
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
	local f = CreateFrame("Frame")
	local total = 0
	f:SetScript("OnUpdate", function(self, elapsed)
		local dirty = nil
		for k in pairs(normalAnchor.bars) do
			if k.remaining <= 10 then
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
	bar:Set("module", module)
	bar:Set("anchor", normalAnchor)
	bar:SetColor(0.25, 0.33, 0.68, 1)
	bar:SetLabel(text)
	bar:SetDuration(time)
	bar:SetTimeVisibility(true)
	bar:SetIcon(icon)
	bar:SetScale(db.scale)
	if db.emphasize and time < 15 then
		self:EmphasizeBar(bar)
	end
	bar:Start()
	rearrangeBars(bar:Get("anchor"))
end

--------------------------------------------------------------------------------
-- Emphasize
--

function plugin:EmphasizeBar(bar)
	normalAnchor.bars[bar] = nil
	emphasizeAnchor.bars[bar] = true
	bar:Set("anchor", emphasizeAnchor)
	bar:SetColor(1, 0, 0, 1)
	bar:SetScale(db.emphasizeScale)
end

