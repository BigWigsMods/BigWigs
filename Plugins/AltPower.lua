--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Alt Power")
if not plugin then return end

plugin.defaultDB = {
	posx = nil,
	posy = nil,
	fontName = plugin:GetDefaultFont(),
	fontSize = select(2, plugin:GetDefaultFont(12)),
	fontOutline = "",
	monochrome = false,
	expanded = false,
	disabled = false,
	lock = false,
}

--------------------------------------------------------------------------------
-- Locals
--

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
local media = LibStub("LibSharedMedia-3.0")
local FONT = media.MediaType and media.MediaType.FONT or "font"
plugin.displayName = L.altPowerTitle

local powerList, powerMaxList, sortedUnitList, roleColoredList = nil, nil, nil, nil
local unitList = nil
local maxPlayers = 0
local display, updater = nil, nil
local opener = nil
local inTestMode = nil
local sortDir = nil
local repeatSync = nil
local syncPowerList = nil
local syncPowerMaxList = nil
local UpdateDisplay
local tsort, min = table.sort, math.min
local UnitPower, IsInGroup = UnitPower, IsInGroup
local db = nil
local roleIcons = {
	["TANK"] = INLINE_TANK_ICON,
	["HEALER"] = INLINE_HEALER_ICON,
	["DAMAGER"] = INLINE_DAMAGER_ICON,
	["NONE"] = "",
}

local function colorize(power, powerMax)
	if power == -1 then return 0, 255 end
	if not powerMax or powerMax == 0 then
		powerMax = 100
		if power > powerMax then
			powerMax = power
		end
	end
	local ratio = power/powerMax*510
	local r, g = min(ratio, 255), min(510-ratio, 255)
	if sortDir == "AZ" then -- red to green
		return r, g
	else -- green to red
		return g, r
	end
end

function plugin:RestyleWindow()
	if not display then return end

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

	if db.lock then
		display:SetMovable(false)
		display:RegisterForDrag()
		display:SetScript("OnDragStart", nil)
		display:SetScript("OnDragStop", nil)
	else
		display:SetMovable(true)
		display:RegisterForDrag("LeftButton")
		display:SetScript("OnDragStart", function(f) f:StartMoving() end)
		display:SetScript("OnDragStop", function(f)
			f:StopMovingOrSizing()
			local s = f:GetEffectiveScale()
			db.posx = f:GetLeft() * s
			db.posy = f:GetTop() * s
			plugin:UpdateGUI() -- Update X/Y if GUI is open.
		end)
	end

	local font = media:Fetch(FONT, db.fontName)
	local flags
	if db.monochrome and db.fontOutline ~= "" then
		flags = "MONOCHROME," .. db.fontOutline
	elseif db.monochrome then
		flags = "MONOCHROME"
	else
		flags = db.fontOutline
	end

	display.title:SetFont(font, db.fontSize, flags)
	for i = 1, 25 do
		display.text[i]:SetFont(font, db.fontSize, flags)
	end
end

-------------------------------------------------------------------------------
-- Options
--

do
	local disabled = function() return plugin.db.profile.disabled end
	plugin.pluginOptions = {
		name = L.altPowerTitle,
		type = "group",
		get = function(info)
			return db[info[#info]]
		end,
		set = function(info, value)
			local entry = info[#info]
			db[entry] = value
			plugin:RestyleWindow()
		end,
		args = {
			disabled = {
				type = "toggle",
				name = L.disabled,
				desc = L.disabledDisplayDesc,
				order = 1,
			},
			lock = {
				type = "toggle",
				name = L.lock,
				desc = L.lockDesc,
				order = 2,
				disabled = disabled,
			},
			font = {
				type = "select",
				name = L.font,
				order = 3,
				values = media:List(FONT),
				itemControl = "DDI-Font",
				get = function()
					for i, v in next, media:List(FONT) do
						if v == db.fontName then return i end
					end
				end,
				set = function(_, value)
					db.fontName = media:List(FONT)[value]
					plugin:RestyleWindow()
				end,
				disabled = disabled,
			},
			fontOutline = {
				type = "select",
				name = L.outline,
				order = 4,
				values = {
					[""] = L.none,
					OUTLINE = L.thin,
					THICKOUTLINE = L.thick,
				},
				disabled = disabled,
			},
			fontSize = {
				type = "range",
				name = L.fontSize,
				order = 5,
				max = 200, softMax = 72,
				min = 1,
				step = 1,
				disabled = disabled,
			},
			monochrome = {
				type = "toggle",
				name = L.monochrome,
				desc = L.monochromeDesc,
				order = 6,
				disabled = disabled,
			},
			--[[showHide = {
				type = "group",
				name = L.showHide,
				inline = true,
				order = 7,
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
			exactPositioning = {
				type = "group",
				name = L.positionExact,
				order = 8,
				inline = true,
				args = {
					posx = {
						type = "range",
						name = L.positionX,
						desc = L.positionDesc,
						min = 0,
						max = 2048,
						step = 1,
						order = 1,
						width = "full",
					},
					posy = {
						type = "range",
						name = L.positionY,
						desc = L.positionDesc,
						min = 0,
						max = 2048,
						step = 1,
						order = 2,
						width = "full",
					},
				},
			},
			reset = {
				type = "execute",
				name = L.resetAll,
				desc = L.resetAltPowerDesc,
				func = function() 
					plugin.db:ResetProfile()
				end,
				order = 9,
			},
		},
	}
end

-------------------------------------------------------------------------------
-- Initialization
--

local function resetAnchor()
	display:ClearAllPoints()
	display:SetPoint("CENTER", UIParent, "CENTER", 300, -80)
	db.posx = nil
	db.posy = nil
	plugin:Contract()
end

local function updateProfile()
	db = plugin.db.profile

	plugin:RestyleWindow()
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_StartSyncingPower")
	self:RegisterMessage("BigWigs_ShowAltPower")
	self:RegisterMessage("BigWigs_HideAltPower", "Close")
	self:RegisterMessage("BigWigs_OnBossDisable")
	self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossDisable")

	self:RegisterMessage("BigWigs_StartConfigureMode", "Test")
	self:RegisterMessage("BigWigs_StopConfigureMode", "Close")

	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	self:RegisterMessage("BigWigs_ResetPositions", resetAnchor)
	updateProfile()
end

function plugin:OnPluginDisable()
	self:Close()
end

-------------------------------------------------------------------------------
-- Event Handlers
--

do
	-- Realistically this should never fire during an encounter, we're just compensating for someone leaving the group
	-- whilst the display is shown (more likely to happen in LFR). The display should not be shown outside of an encounter
	-- where the event seems to fire frequently, which would make this very inefficient.
	local function GROUP_ROSTER_UPDATE()
		if not IsInGroup() then plugin:Close() return end

		local players = GetNumGroupMembers()
		if players ~= maxPlayers then
			if updater then plugin:CancelTimer(updater) end

			if repeatSync then
				syncPowerList = {}
				syncPowerMaxList = {}
			end
			maxPlayers = players
			unitList = IsInRaid() and plugin:GetRaidList() or plugin:GetPartyList()
			powerList, powerMaxList, sortedUnitList, roleColoredList = {}, {}, {}, {}

			local UnitClass, UnitGroupRolesAssigned = UnitClass, UnitGroupRolesAssigned
			local colorTbl = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
			for i = 1, players do
				local unit = unitList[i]
				sortedUnitList[i] = unit

				local name = plugin:UnitName(unit, true) or "???"
				local _, class = UnitClass(unit)
				local tbl = class and colorTbl[class] or GRAY_FONT_COLOR
				roleColoredList[unit] = ("%s|cFF%02x%02x%02x%s|r"):format(roleIcons[UnitGroupRolesAssigned(unit)], tbl.r*255, tbl.g*255, tbl.b*255, name)
			end
			updater = plugin:ScheduleRepeatingTimer(UpdateDisplay, 1)
		end

		if repeatSync then
			plugin:RosterUpdateForHiddenDisplay() -- Maybe a player logged back on after a DC, force sync refresh to send them our power.
		end
	end

	do
		-- USE THIS CALLBACK TO SKIN THIS WINDOW! NO NEED FOR UGLY HAX! E.g.
		-- local addonName, addonTable = ...
		-- if BigWigsLoader then
		-- 	BigWigsLoader.RegisterMessage(addonTable, "BigWigs_FrameCreated", function(event, frame, name) print(name.." frame created.") end)
		-- end
		display = CreateFrame("Frame", "BigWigsAltPower", UIParent)
		display:SetSize(230, 80)
		display:SetClampedToScreen(true)
		display:EnableMouse(true)
		display:Hide()

		local bg = display:CreateTexture()
		bg:SetAllPoints(display)
		bg:SetColorTexture(0, 0, 0, 0.3)
		display.background = bg

		local close = CreateFrame("Button", nil, display)
		close:SetPoint("BOTTOMRIGHT", display, "TOPRIGHT", -2, 2)
		close:SetHeight(16)
		close:SetWidth(16)
		close:SetNormalTexture("Interface\\AddOns\\BigWigs\\Media\\Textures\\icons\\close")
		close:SetScript("OnClick", function()
			BigWigs:Print(L.toggleDisplayPrint)
			plugin:Close()
		end)

		local expand = CreateFrame("Button", nil, display)
		expand:SetPoint("BOTTOMLEFT", display, "TOPLEFT", 2, 2)
		expand:SetHeight(16)
		expand:SetWidth(16)
		expand:SetNormalTexture("Interface\\AddOns\\BigWigs\\Media\\Textures\\icons\\arrows_down")
		expand:SetScript("OnClick", function()
			if db.expanded then
				plugin:Contract()
			else
				plugin:Expand()
			end
		end)
		display.expand = expand

		local header = display:CreateFontString(nil, "OVERLAY")
		header:SetShadowOffset(1, -1)
		header:SetTextColor(1,0.82,0,1)
		header:SetPoint("BOTTOM", display, "TOP", 0, 4)
		display.title = header

		display.text = {}
		for i = 1, 25 do
			local text = display:CreateFontString(nil, "OVERLAY")
			text:SetShadowOffset(1, -1)
			text:SetTextColor(1,0.82,0,1)
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

		display:SetScript("OnEvent", GROUP_ROSTER_UPDATE)
		display:SetScript("OnShow", function(self)
			self:SetSize(230, db.expanded and 210 or 80)
			self.expand:SetNormalTexture(db.expanded and "Interface\\AddOns\\BigWigs\\Media\\Textures\\icons\\arrows_up" or "Interface\\AddOns\\BigWigs\\Media\\Textures\\icons\\arrows_down")
		end)
	end

	-- This module is rarely used, and opened once during an encounter where it is.
	-- We will prefer on-demand variables over permanent ones.
	function plugin:BigWigs_ShowAltPower(event, module, title, sorting, sync)
		if db.disabled or not IsInGroup() then return end -- Solo runs of old content

		self:RestyleWindow()
		self:Close()

		if sync then
			self:RegisterMessage("BigWigs_PluginComm")
		end

		display:RegisterEvent("GROUP_ROSTER_UPDATE")

		opener = module
		sortDir = sorting
		maxPlayers = 0 -- Force an update via GROUP_ROSTER_UPDATE
		if title then
			display.title:SetText(title)
		else
			display.title:SetText(L.altPowerTitle)
		end
		display:Show()
		GROUP_ROSTER_UPDATE()
		UpdateDisplay()
	end
end

function plugin:Test()
	self:Close()

	sortDir = "AZ"
	unitList = self:GetRaidList()
	for i = 1, db.expanded and 25 or 10 do
		local power = 100-(i*(db.expanded and 4 or 10))
		local r, g = colorize(power, 100)
		display.text[i]:SetFormattedText("|cFF%02x%02x00[%d]|r %s", r, g, power, unitList[i])
	end
	display.title:SetText(L.altPowerTitle)
	display:Show()
	inTestMode = true
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
			-- If we don't have sync data (players not using BigWigs) use whatever (potentially incorrect) data Blizz gives us.
			powerList[unit] = syncPowerList and syncPowerList[unit] or UnitPower(unit, 10) -- Enum.PowerType.Alternate = 10
			powerMaxList[unit] = syncPowerMaxList and syncPowerMaxList[unit] or UnitPowerMax(unit, 10) -- Enum.PowerType.Alternate = 10
		end
		tsort(sortedUnitList, sortTbl)
		for i = 1, db.expanded and 25 or 10 do
			local unit = sortedUnitList[i]
			if unit then
				local power = powerList[unit]
				local powerMax = powerMaxList[unit]
				local r, g = colorize(power, powerMax)
				display.text[i]:SetFormattedText("|cFF%02x%02x00[%d]|r %s", r, g, power, roleColoredList[unit])
			else
				display.text[i]:SetText("")
			end
		end
	end
end

function plugin:Expand()
	db.expanded = true
	display:SetHeight(210)
	display.expand:SetNormalTexture("Interface\\AddOns\\BigWigs\\Media\\Textures\\icons\\arrows_up")
	if inTestMode then
		self:Test()
	else
		UpdateDisplay()
	end
end

function plugin:Contract()
	db.expanded = false
	display:SetHeight(80)
	display.expand:SetNormalTexture("Interface\\AddOns\\BigWigs\\Media\\Textures\\icons\\arrows_down")
	for i = 11, 25 do
		display.text[i]:SetText("")
	end
	if inTestMode then
		self:Test()
	end
end

function plugin:Close()
	if repeatSync then
		self:UnregisterEvent("GROUP_ROSTER_UPDATE")
		self:CancelTimer(repeatSync)
		repeatSync = nil
	end

	if display then
		if updater then self:CancelTimer(updater) end
		updater = nil
		display:UnregisterEvent("GROUP_ROSTER_UPDATE")
		display:Hide()
		self:UnregisterMessage("BigWigs_PluginComm")
		for i = 1, 25 do
			display.text[i]:SetText("")
		end
	end

	powerList, powerMaxList, sortedUnitList, roleColoredList, syncPowerList, syncPowerMaxList = nil, nil, nil, nil, nil, nil
	unitList, opener, inTestMode = nil, nil, nil
end

function plugin:BigWigs_OnBossDisable(_, module)
	if module == opener then
		self:Close()
	end
end

do
	local power = -1
	local powerMax = -1
	local function sendPower()
		local newPower = UnitPower("player", 10) -- Enum.PowerType.Alternate = 10
		local newPowerMax = UnitPowerMax("player", 10) -- Enum.PowerType.Alternate = 10
		if newPower ~= power then
			power = newPower
			plugin:Sync("AltPower", newPower)
		end
		if newPowerMax ~= powerMax then
			powerMax = newPowerMax
			plugin:Sync("AltPowerMax", newPowerMax)
		end
	end

	function plugin:RosterUpdateForHiddenDisplay()
		-- This is for people that don't show the AltPower display (event isn't registered to the display as it normally would be).
		-- It will force sending the current power for those that do have the display shown but just had their power list reset by a
		-- GROUP_ROSTER_UPDATE. Or someone DCd and is logging back on, so send an update.
		if not IsInGroup() then plugin:Close() return end
		self:CancelTimer(repeatSync)
		power = -1
		repeatSync = self:ScheduleRepeatingTimer(sendPower, 1)
	end

	function plugin:BigWigs_StartSyncingPower(_, module)
		if not IsInGroup() then return end
		power = -1
		opener = module
		if not repeatSync then
			repeatSync = self:ScheduleRepeatingTimer(sendPower, 1)
			if display and display:IsShown() then
				syncPowerList = {}
				syncPowerMaxList = {}
			else
				self:RegisterEvent("GROUP_ROSTER_UPDATE", "RosterUpdateForHiddenDisplay")
			end
		end
	end

	function plugin:BigWigs_PluginComm(_, msg, amount, sender)
		if msg == "AltPower" then
			local curPower = tonumber(amount)
			if curPower then
				for i = 1, maxPlayers do
					local unit = unitList[i]
					if sender == self:UnitName(unit) then
						syncPowerList[unit] = curPower
						break
					end
				end
			end
		elseif msg == "AltPowerMax" then
			local curPowerMax = tonumber(amount)
			if curPowerMax then
				for i = 1, maxPlayers do
					local unit = unitList[i]
					if sender == self:UnitName(unit) then
						syncPowerMaxList[unit] = curPowerMax
						break
					end
				end
			end
		end
	end
end

-- We run this last to prevent the AltPower module breaking if some addon listening to this event causes an error
plugin:SendMessage("BigWigs_FrameCreated", display, "AltPower")
