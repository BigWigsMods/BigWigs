--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Alt Power")
if not plugin then return end

plugin.defaultDB = {
	posx = nil,
	posy = nil,
	expanded = false,
	disabled = false,
	lock = false,
}

--------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")
local media = LibStub("LibSharedMedia-3.0")
plugin.displayName = L.altPowerTitle

local powerList, sortedUnitList, roleColoredList = nil, nil, nil
local unitList = nil
local maxPlayers = 0
local display, updater = nil, nil
local opener = nil
local inTestMode = nil
local sortDir = nil
local repeatSync = nil
local syncPowerList = nil
local UpdateDisplay
local tsort = table.sort
local min = math.min
local UnitPower = UnitPower
local db = nil
local roleIcons = {
	["TANK"] = INLINE_TANK_ICON,
	["HEALER"] = INLINE_HEALER_ICON,
	["DAMAGER"] = INLINE_DAMAGER_ICON,
	["NONE"] = "",
}

local function colorize(power)
	local ratio = power/100*510
	local r, g = min(ratio, 255), min(510-ratio, 255)
	if sortDir == "AZ" then -- red to green
		return r, g
	else -- green to red
		return g, r
	end
end

function plugin:RestyleWindow()
	if db.lock then
		display:SetMovable(false)
		display:RegisterForDrag()
		display:SetScript("OnDragStart", nil)
		display:SetScript("OnDragStop", nil)
	else
		display:SetMovable(true)
		display:RegisterForDrag("LeftButton")
		display:SetScript("OnDragStart", function(self) self:StartMoving() end)
		display:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing()
			local s = self:GetEffectiveScale()
			db.posx = self:GetLeft() * s
			db.posy = self:GetTop() * s
		end)
	end
end

-------------------------------------------------------------------------------
-- Options
--

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
					else
						return db[key]
					end
				end,
				set = function(info, value)
					local key = info[#info]
					if key == "font" then
						db.font = media:List("font")[value]
					else
						db[key] = value
					end
					plugin:RestyleWindow()
				end,
				args = {
					disabled = {
						type = "toggle",
						name = L.disabled,
						--desc = L.disabledDesc,
						order = 1,
					},
					lock = {
						type = "toggle",
						name = L.lock,
						desc = L.lockDesc,
						order = 2,
					},
					font = {
						type = "select",
						name = L.font,
						order = 3,
						values = media:List("font"),
						width = "full",
						itemControl = "DDI-Font",
						disabled = true,
					},
					fontSize = {
						type = "range",
						name = L.fontSize,
						order = 4,
						max = 40,
						min = 8,
						step = 1,
						width = "full",
						disabled = true,
					},
					--[[showHide = {
						type = "group",
						name = L.showHide,
						inline = true,
						order = 5,
						get = function(info)
							local key = info[#info]
							return db.objects[key]
						end,
						set = function(info, value)
							local key = info[#info]
							db.objects[key] = value
							plugin:RestyleWindow()
						end,
						args = {
							title = {
								type = "toggle",
								name = L.title,
								desc = L.titleDesc,
								order = 1,
							},
							background = {
								type = "toggle",
								name = L.background,
								desc = L.backgroundDesc,
								order = 2,
							},
							sound = {
								type = "toggle",
								name = L.soundButton,
								desc = L.soundButtonDesc,
								order = 3,
							},
							close = {
								type = "toggle",
								name = L.closeButton,
								desc = L.closeButtonDesc,
								order = 4,
							},
							ability = {
								type = "toggle",
								name = L.abilityName,
								desc = L.abilityNameDesc,
								order = 5,
							},
							tooltip = {
								type = "toggle",
								name = L.tooltip,
								desc = L.tooltipDesc,
								order = 6,
							}
						},
					},]]
				},
			}
		end
		return pluginOptions
	end
end

-------------------------------------------------------------------------------
-- Initialization
--

local function updateProfile()
	db = plugin.db.profile
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_StartSyncingPower")
	self:RegisterMessage("BigWigs_ShowAltPower")
	self:RegisterMessage("BigWigs_HideAltPower", "Close")
	self:RegisterMessage("BigWigs_OnBossDisable")

	self:RegisterMessage("BigWigs_StartConfigureMode", "Test")
	self:RegisterMessage("BigWigs_StopConfigureMode", "Close")
	self:RegisterMessage("BigWigs_SetConfigureTarget")

	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()
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
		display:SetScript("OnMouseUp", function(self, button)
			if inTestMode and button == "LeftButton" then
				plugin:SendMessage("BigWigs_SetConfigureTarget", plugin)
			end
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
		expand:SetNormalTexture(db.expanded and "Interface\\AddOns\\BigWigs\\Textures\\icons\\arrows_up" or "Interface\\AddOns\\BigWigs\\Textures\\icons\\arrows_down")
		expand:SetScript("OnClick", function()
			if db.expanded then
				plugin:Contract()
			else
				plugin:Expand()
			end
		end)
		display.expand = expand

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
		plugin:RestyleWindow()
	end

	-- This module is rarely used, and opened once during an encounter where it is.
	-- We will prefer on-demand variables over permanent ones.
	function plugin:BigWigs_ShowAltPower(event, module, title, sorting)
		if db.disabled or not IsInGroup() then return end -- Solo runs of old content

		if createFrame then createFrame() createFrame = nil end
		self:Close()

		BigWigs:AddSyncListener(self, "BWPower", 0)
		maxPlayers = GetNumGroupMembers()
		opener = module
		sortDir = sorting
		unitList = IsInRaid() and self:GetRaidList() or self:GetPartyList()
		powerList, sortedUnitList, roleColoredList, syncPowerList = {}, {}, {}, {}
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
			display.title:SetFormattedText("%s: %s", L.altPowerTitle, title)
		else
			display.title:SetText(L.altPowerTitle)
		end
		display:Show()
		updater:Play()
		UpdateDisplay()
	end

	function plugin:Test()
		if createFrame then createFrame() createFrame = nil end
		self:Close()

		sortDir = "AZ"
		unitList = self:GetRaidList()
		for i = 1, db.expanded and 25 or 10 do
			local power = 100-(i*(db.expanded and 4 or 10))
			local r, g = colorize(power)
			display.text[i]:SetFormattedText("|cFF%02x%02x00[%d]|r %s", r, g, power, unitList[i])
		end
		display.title:SetText(L.altPowerTitle)
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
		elseif sortDir == "AZ" then
			return px > py
		else
			return px < py
		end
	end

	function UpdateDisplay()
		for i = 1, maxPlayers do
			local unit = unitList[i]
			powerList[unit] = syncPowerList and (syncPowerList[unit] or -1) or UnitPower(unit, 10) -- ALTERNATE_POWER_INDEX = 10
		end
		tsort(sortedUnitList, sortTbl)
		for i = 1, db.expanded and 25 or 10 do
			local unit = sortedUnitList[i]
			if not unit then return end

			local power = powerList[unit]
			local r, g = colorize(power)
			display.text[i]:SetFormattedText("|cFF%02x%02x00[%d]|r %s", r, g, power, roleColoredList[unit])
		end
	end
end

function plugin:Expand()
	db.expanded = true
	display:SetHeight(210)
	display.expand:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\arrows_up")
	if inTestMode then
		self:Test()
	else
		UpdateDisplay()
	end
end

function plugin:Contract()
	db.expanded = false
	display:SetHeight(80)
	display.expand:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\arrows_down")
	for i = 11, 25 do
		display.text[i]:SetText("")
	end
	if inTestMode then
		self:Test()
	end
end

function plugin:Close()
	if not updater then return end
	updater:Stop()
	display:Hide()
	if repeatSync then
		self:CancelTimer(repeatSync)
		repeatSync = nil
	end
	BigWigs:ClearSyncListeners(self)
	powerList, sortedUnitList, roleColoredList, syncPowerList = nil, nil, nil, nil
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

do
	local power = -1
	local function sendPower()
		local newPower = UnitPower("player", 10) -- ALTERNATE_POWER_INDEX = 10
		if newPower ~= power then
			power = newPower
			BigWigs:Transmit("BWPower", newPower)
		end
	end

	function plugin:BigWigs_StartSyncingPower()
		power = -1
		if not repeatSync then
			repeatSync = self:ScheduleRepeatingTimer(sendPower, 1)
		end
	end

	function plugin:OnSync(sync, amount, nick)
		local curPower = tonumber(amount)
		if curPower then
			for i = 1, maxPlayers do
				local unit = unitList[i]
				if nick == self:UnitName(unit) then
					syncPowerList[unit] = curPower
					break
				end
			end
		end
	end
end

