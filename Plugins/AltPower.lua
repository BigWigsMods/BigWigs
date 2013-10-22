--------------------------------------------------------------------------------
-- Module Declaration
--

local LULZ = false
if not LULZ then return end
print"alt power loaded"

local plugin = BigWigs:NewPlugin("Alt Power")
if not plugin then return end

plugin.defaultDB = {
	posx = nil,
	posy = nil,
	expanded = false,
}

--------------------------------------------------------------------------------
-- Locals
--

local powerList, sortedUnitList, roleColoredList = nil, nil, nil
local unitList = nil
local maxPlayers = 0
local display, updater = nil, nil
local opener = nil
local inTestMode = nil
local UpdateDisplay
local tsort = table.sort
local UnitPower = UnitPower
local db = nil
local roleIcons = {
	["TANK"] = INLINE_TANK_ICON,
	["HEALER"] = INLINE_HEALER_ICON,
	["DAMAGER"] = INLINE_DAMAGER_ICON,
	["NONE"] = "",
}

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_ShowAltPower")
	self:RegisterMessage("BigWigs_HideAltPower", "Close")
	self:RegisterMessage("BigWigs_OnBossDisable")

	self:RegisterMessage("BigWigs_StartConfigureMode", "Test")
	self:RegisterMessage("BigWigs_StopConfigureMode", "Close")
	self:RegisterMessage("BigWigs_SetConfigureTarget")

	db = self.db.profile
end

function plugin:OnPluginDisable()
	self:Close()
end

-------------------------------------------------------------------------------
-- Event Handlers
--

do
	local function createFrame()
		display = CreateFrame("Frame", "BigWigsAltPower", UIParent)
		display:SetSize(230, db.expanded and 210 or 80)
		display:SetClampedToScreen(true)
		display:EnableMouse(true)
		display:SetMovable(true)
		display:RegisterForDrag("LeftButton")
		display:SetScript("OnDragStart", function(self) self:StartMoving() end)
		display:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing()
			local s = self:GetEffectiveScale()
			db.posx = self:GetLeft() * s
			db.posy = self:GetTop() * s
		end)

		updater = display:CreateAnimationGroup()
		updater:SetLooping("REPEAT")
		updater:SetScript("OnLoop", UpdateDisplay)
		local anim = updater:CreateAnimation()
		anim:SetDuration(2)

		local bg = display:CreateTexture(nil, "PARENT")
		bg:SetAllPoints(display)
		bg:SetBlendMode("BLEND")
		bg:SetTexture(0, 0, 0, 0.3)
		display.background = bg

		local close = CreateFrame("Button", nil, display)
		close:SetPoint("BOTTOMRIGHT", display, "TOPRIGHT", -2, 2)
		close:SetHeight(16)
		close:SetWidth(16)
		close:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\close")
		close:SetScript("OnClick", function()
			--BigWigs:Print(L.toggleProximityPrint)
			plugin:Close()
		end)

		local expand = CreateFrame("Button", nil, display)
		expand:SetPoint("BOTTOMLEFT", display, "TOPLEFT", 2, 2)
		expand:SetHeight(16)
		expand:SetWidth(16)
		expand:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\arrows")
		expand:SetScript("OnClick", function()
			if db.expanded then
				plugin:Contract()
			else
				plugin:Expand()
			end
		end)

		local header = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		header:SetPoint("BOTTOM", display, "TOP", 0, 4)
		display.title = header

		display.text = {}
		for i = 1, 25 do
			local text = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			text:SetText("")
			text:SetSize(115, 16)
			text:SetJustifyH("LEFT")
			if i == 1 then
				text:SetPoint("TOPLEFT", display, "TOPLEFT", 5, 0)
			elseif i % 2 == 0 then
				text:SetPoint("LEFT", display.text[i-1], "RIGHT")
			else
				text:SetPoint("TOP", display.text[i-2], "BOTTOM")
			end
			display.text[i] = text
		end

		local x = db.posx
		local y = db.posy
		if x and y then
			local s = display:GetEffectiveScale()
			display:ClearAllPoints()
			display:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
		else
			display:ClearAllPoints()
			display:SetPoint("CENTER", UIParent, "CENTER", 300, -80)
		end
	end

	-- This module is rarely used, and opened once during an encounter where it is.
	-- We will prefer on-demand variables over permanent ones.
	function plugin:BigWigs_OpenAltPower(event, module, title)
		if not IsInGroup() then return end -- Solo runs of old content
		if createFrame then createFrame() createFrame = nil end
		self:Close()

		maxPlayers = GetNumGroupMembers()
		opener = module
		unitList = IsInRaid() and self:GetRaidList() or self:GetPartyList()
		powerList, sortedUnitList, roleColoredList = {}, {}, {}
		local UnitClass, UnitGroupRolesAssigned = UnitClass, UnitGroupRolesAssigned
		local colorTbl = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
		for i = 1, maxPlayers do
			local unit = unitList[i]
			sortedUnitList[i] = unit

			local name = self:UnitName(unit, true) or "???"
			local _, class = UnitClass(unit)
			local tbl = class and colorTbl[class] or GRAY_FONT_COLOR
			roleColoredList[unit] = ("%s|cFF%02x%02x%02x%s|r"):format(roleIcons[UnitGroupRolesAssigned(unit)], tbl.r*255, tbl.g*255, tbl.b*255, name)
		end
		if title then
			display.title:SetFormattedText("Alt Power: %s", title)
		else
			display.title:SetText("Alt Power")
		end
		display:Show()
		updater:Play()
		UpdateDisplay()
	end

	function plugin:Test()
		if createFrame then createFrame() createFrame = nil end
		self:Close()

		unitList = self:GetRaidList()
		for i = 1, db.expanded and 25 or 10 do
			display.text[i]:SetFormattedText("[%d] %s", 100-i, unitList[i])
		end
		display.title:SetText("Alt Power")
		display:Show()
		inTestMode = true
	end
end

function plugin:BigWigs_SetConfigureTarget(event, module)
	if module == self then
		display.background:SetTexture(0.2, 1, 0.2, 0.3)
	else
		display.background:SetTexture(0, 0, 0, 0.3)
	end
end

do
	local function sortTbl(x,y)
		local px, py = powerList[x], powerList[y]
		if px == py then
			return x > y
		else
			return px > py
		end
	end

	function UpdateDisplay()
		for i = 1, maxPlayers do
			local unit = unitList[i]
			powerList[unit] = UnitPower(unit, 10) -- ALTERNATE_POWER_INDEX = 10
		end
		tsort(sortedUnitList, sortTbl)
		for i = 1, db.expanded and 25 or 10 do
			local name = sortedUnitList[i]
			if not name then return end
			display.text[i]:SetFormattedText("[%d] %s", powerList[name], roleColoredList[name])
		end
	end
end

function plugin:Expand()
	db.expanded = true
	display:SetHeight(210)
	if inTestMode then
		self:Test()
	end
end

function plugin:Contract()
	db.expanded = false
	display:SetHeight(80)
	for i = 11, 25 do
		display.text[i]:SetText("")
	end
end

function plugin:Close()
	if not updater then return end
	updater:Stop()
	display:Hide()
	powerList, sortedUnitList, roleColoredList = nil, nil, nil
	unitList = nil
	opener = nil
	inTestMode = nil
	for i = 1, 25 do
		display.text[i]:SetText("")
	end
end

function plugin:BigWigs_OnBossDisable(_, module)
	if module == opener then
		self:Close()
	end
end

