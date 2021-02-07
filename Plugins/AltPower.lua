--------------------------------------------------------------------------------
-- Module Declaration
--

local oldPlugin = BigWigs:NewPlugin("Alt Power") -- XXX temp 9.0.2
oldPlugin.defaultDB = {}

local plugin = BigWigs:NewPlugin("AltPower")
if not plugin then return end

do
	local name = plugin:GetDefaultFont()
	local _, size = plugin:GetDefaultFont(12)
	plugin.defaultDB = {
		position = {"CENTER", "CENTER", 450, -160},
		fontName = name,
		fontSize = size,
		outline = "NONE",
		additionalWidth = 0,
		additionalHeight = 0,
		barColor = {0.2, 0, 1, 0.5},
		barTextColor = {1, 0.82, 0},
		backgroundColor = {0, 0, 0, 0.3},
		monochrome = false,
		expanded = false,
		disabled = false,
		lock = false,
	}
end

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
local currentTitle = nil
local inTestMode = nil
local sortDir = nil
local repeatSync = nil
local syncPowerList = nil
local syncPowerMaxList = nil
local UpdateDisplay
local tsort, min = table.sort, math.min
local UnitPower, IsInGroup = UnitPower, IsInGroup
local db = nil
local roleIcons = { -- 337497 = Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES
	-- INLINE_TANK_ICON="|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:16:16:0:0:64:64:0:19:22:41|t"
	["TANK"] = "|T337497:0:0:0:0:64:64:0:19:22:41|t",
	-- INLINE_HEALER_ICON="|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:16:16:0:0:64:64:20:39:1:20|t"
	["HEALER"] = "|T337497:0:0:0:0:64:64:20:39:1:20|t",
	-- INLINE_DAMAGER_ICON="|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES.blp:16:16:0:0:64:64:20:39:22:41|t"
	["DAMAGER"] = "|T337497:0:0:0:0:64:64:20:39:22:41|t",
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
	display:ClearAllPoints()
	local point, relPoint = db.position[1], db.position[2]
	local x, y = db.position[3], db.position[4]
	display:SetPoint(point, UIParent, relPoint, x, y)

	if db.lock then
		display:SetMovable(false)
	else
		display:SetMovable(true)
	end

	local font = media:Fetch(FONT, db.fontName)
	local flags = nil
	if db.monochrome and db.outline ~= "NONE" then
		flags = "MONOCHROME," .. db.outline
	elseif db.monochrome then
		flags = "MONOCHROME"
	elseif db.outline ~= "NONE" then
		flags = db.outline
	end

	display.bar:SetColorTexture(db.barColor[1], db.barColor[2], db.barColor[3], db.barColor[4])
	display.bg:SetColorTexture(db.backgroundColor[1], db.backgroundColor[2], db.backgroundColor[3], db.backgroundColor[4])
	display.title:SetFont(font, db.fontSize, flags)
	display.title:SetTextColor(db.barTextColor[1], db.barTextColor[2], db.barTextColor[3], 1)
	display.title:SetHeight(16+db.additionalHeight)
	for i = 1, 26 do
		display.text[i]:SetFont(font, db.fontSize, flags)
		display.text[i]:SetSize(115+db.additionalWidth, 16+db.additionalHeight)
	end
	-- 240 = 115*2 + (5*2 padding - left and right)
	-- 210 = 16*13 + (1*2 padding - top and bottom)
	-- 82 = 16*5 + (1*2 padding - top and bottom)
	display:SetSize(240+(db.additionalWidth*2), db.expanded and 210+(db.additionalHeight*13) or 82+(db.additionalHeight*5))
end

-------------------------------------------------------------------------------
-- Options
--

do
	local disabled = function() return plugin.db.profile.disabled end
	plugin.pluginOptions = {
		name = L.altPowerTitle,
		type = "group",
		childGroups = "tab",
		get = function(info)
			return db[info[#info]]
		end,
		set = function(info, value)
			local entry = info[#info]
			db[entry] = value
			plugin:RestyleWindow()
		end,
		args = {
			general = {
				type = "group",
				name = L.general,
				order = 1,
				args = {
					heading = {
						type = "description",
						name = L.altPowerDesc .."\n\n",
						order = 1,
						width = "full",
						fontSize = "medium",
					},
					test = {
						type = "execute",
						name = L.test,
						desc = L.altPowerTestDesc,
						func = function() 
							plugin:Test()
						end,
						width = 1.5,
						order = 2,
						disabled = disabled,
					},
					lock = {
						type = "toggle",
						name = L.lock,
						desc = L.lockDesc,
						order = 3,
						disabled = disabled,
					},
					barHeader = {
						type = "header",
						name = L.yourPowerBar,
						order = 4,
					},
					barColor = {
						type = "color",
						name = L.barColor,
						get = function(info)
							return db.barColor[1], db.barColor[2], db.barColor[3], db.barColor[4]
						end,
						set = function(info, r, g, b, a)
							db.barColor = {r, g, b, a}
							plugin:RestyleWindow()
						end,
						hasAlpha = true,
						width = 1.5,
						order = 5,
						disabled = disabled,
					},
					barTextColor = {
						type = "color",
						name = L.barTextColor,
						get = function(info)
							return db.barTextColor[1], db.barTextColor[2], db.barTextColor[3]
						end,
						set = function(info, r, g, b)
							db.barTextColor = {r, g, b}
							plugin:RestyleWindow()
						end,
						width = 1.5,
						order = 6,
						disabled = disabled,
					},
					generalHeader = {
						type = "header",
						name = L.general,
						order = 7,
					},
					backgroundColor = {
						type = "color",
						name = L.background,
						get = function(info)
							return db.backgroundColor[1], db.backgroundColor[2], db.backgroundColor[3], db.backgroundColor[4]
						end,
						set = function(info, r, g, b, a)
							db.backgroundColor = {r, g, b, a}
							plugin:RestyleWindow()
						end,
						hasAlpha = true,
						order = 8,
						disabled = disabled,
					},
					fontName = {
						type = "select",
						name = L.font,
						order = 9,
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
						width = 2,
						disabled = disabled,
					},
					monochrome = {
						type = "toggle",
						name = L.monochrome,
						desc = L.monochromeDesc,
						order = 10,
						disabled = disabled,
					},
					fontSize = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						order = 11,
						max = 200, softMax = 25,
						min = 1,
						step = 1,
						disabled = disabled,
					},
					outline = {
						type = "select",
						name = L.outline,
						order = 12,
						values = {
							NONE = L.none,
							OUTLINE = L.thin,
							THICKOUTLINE = L.thick,
						},
						disabled = disabled,
					},
					additionalWidth = {
						type = "range",
						name = L.additionalWidth,
						desc = L.additionalSizeDesc,
						order = 13,
						max = 100, softMax = 50,
						min = 0,
						step = 1,
						width = 1.5,
						disabled = disabled,
					},
					additionalHeight = {
						type = "range",
						name = L.additionalHeight,
						desc = L.additionalSizeDesc,
						order = 14,
						max = 100, softMax = 20,
						min = 0,
						step = 1,
						width = 1.5,
						disabled = disabled,
					},
					resetHeader = {
						type = "header",
						name = "",
						order = 15,
					},
					reset = {
						type = "execute",
						name = L.resetAll,
						desc = L.resetAltPowerDesc,
						func = function() 
							plugin:Contract()
							plugin.db:ResetProfile()
						end,
						order = 16,
					},
					spacer = {
						type = "description",
						name = "\n\n",
						order = 17,
						width = "full",
						fontSize = "medium",
					},
					disabled = {
						type = "toggle",
						name = L.disabled,
						desc = L.disableAltPowerDesc,
						order = 18,
						set = function(_, value)
							db.disabled = value
							if value then
								plugin:Close()
							end
						end,
						confirm = function(_, value)
							if value then
								return L.disableDesc:format(L.altPowerTitle)
							end
						end,
					},
				},
			},
			exactPositioning = {
				type = "group",
				name = L.positionExact,
				order = 2,
				disabled = disabled,
				args = {
					posx = {
						type = "range",
						name = L.positionX,
						desc = L.positionDesc,
						min = -2048,
						max = 2048,
						step = 1,
						order = 1,
						width = "full",
						get = function()
							return db.position[3]
						end,
						set = function(_, value)
							db.position[3] = value
							plugin:RestyleWindow()
						end,
					},
					posy = {
						type = "range",
						name = L.positionY,
						desc = L.positionDesc,
						min = -2048,
						max = 2048,
						step = 1,
						order = 2,
						width = "full",
						get = function()
							return db.position[4]
						end,
						set = function(_, value)
							db.position[4] = value
							plugin:RestyleWindow()
						end,
					},
				},
			},
		},
	}
end

-------------------------------------------------------------------------------
-- Initialization
--

local function updateProfile()
	db = plugin.db.profile
	oldPlugin.db:ResetProfile(nil, true) -- XXX temp 9.0.2 // no callbacks

	plugin:RestyleWindow()
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_StartSyncingPower")
	self:RegisterMessage("BigWigs_ShowAltPower")
	self:RegisterMessage("BigWigs_HideAltPower", "Close")
	self:RegisterMessage("BigWigs_OnBossDisable")
	self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossDisable")

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
		display = CreateFrame("Frame", nil, UIParent)
		display:SetSize(230, 80)
		display:SetClampedToScreen(true)
		display:EnableMouse(true)
		display:SetFrameStrata("MEDIUM")
		display:SetFixedFrameStrata(true)
		display:SetFrameLevel(125)
		display:SetFixedFrameLevel(true)
		display:RegisterForDrag("LeftButton")
		display:SetScript("OnDragStart", function(self)
			if self:IsMovable() then
				self:StartMoving()
			end
		end)
		display:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing()
			local point, _, relPoint, x, y = self:GetPoint()
			db.position = {point, relPoint, x, y}
			plugin:UpdateGUI() -- Update X/Y if GUI is open.
		end)
		display:Hide()

		local bg = display:CreateTexture()
		bg:SetPoint("BOTTOMLEFT", display, "BOTTOMLEFT")
		bg:SetPoint("BOTTOMRIGHT", display, "BOTTOMRIGHT")
		display.bg = bg

		local close = CreateFrame("Button", nil, display)
		close:SetPoint("BOTTOMRIGHT", display, "TOPRIGHT", -2, 2)
		close:SetSize(16, 16)
		close:SetNormalTexture("Interface\\AddOns\\BigWigs\\Media\\Icons\\close")
		close:SetScript("OnClick", function()
			if inTestMode then
				plugin:Close()
			else
				display:Hide() -- Don't call :Close as that would disable syncing (if enabled)
				BigWigs:Print(L.toggleDisplayPrint)
			end
		end)

		local expand = CreateFrame("Button", nil, display)
		expand:SetPoint("BOTTOMLEFT", display, "TOPLEFT", 2, 2)
		expand:SetSize(16, 16)
		expand:SetNormalTexture("Interface\\AddOns\\BigWigs\\Media\\Icons\\arrows_down")
		expand:SetScript("OnClick", function()
			if db.expanded then
				plugin:Contract()
			else
				plugin:Expand()
			end
		end)
		display.expand = expand

		local header = display:CreateFontString()
		header:SetShadowOffset(1, -1)
		header:SetTextColor(1,0.82,0,1)
		header:SetPoint("BOTTOM", display, "TOP", 0, 4)
		header:SetHeight(16)
		bg:SetPoint("TOP", header, "TOP", 0, 2)
		display.title = header

		local bar = display:CreateTexture(nil, nil, nil, 1) -- above background
		bar:SetPoint("LEFT", expand, "RIGHT", 4, 0)
		bar:SetPoint("BOTTOM", header, "BOTTOM")
		bar:SetPoint("TOP", header, "TOP")
		display.bar = bar

		display.text = {}
		for i = 1, 26 do
			local text = display:CreateFontString()
			text:SetShadowOffset(1, -1)
			text:SetTextColor(1,0.82,0,1)
			text:SetSize(115, 16)
			text:SetJustifyH("LEFT")
			if i == 1 then
				text:SetPoint("TOPLEFT", display, "TOPLEFT", 5, -1)
			elseif i % 2 == 0 then
				text:SetPoint("LEFT", display.text[i-1], "RIGHT")
			else
				text:SetPoint("TOP", display.text[i-2], "BOTTOM")
			end
			display.text[i] = text
		end

		display:SetScript("OnEvent", GROUP_ROSTER_UPDATE)
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
		currentTitle = title
		maxPlayers = 0 -- Force an update via GROUP_ROSTER_UPDATE
		display:Show()
		GROUP_ROSTER_UPDATE()
		UpdateDisplay()
	end
end

do
	local classList = {"HUNTER","WARRIOR","ROGUE","MAGE","PRIEST","SHAMAN","WARLOCK","DEMONHUNTER","DEATHKNIGHT","DRUID","MONK","PALADIN"}
	local roleList = {"DAMAGER","TANK","DAMAGER","DAMAGER","HEALER","HEALER","DAMAGER","TANK","DAMAGER","HEALER","HEALER","DAMAGER"}
	local function testUpdate()
		if inTestMode then
			plugin:SimpleTimer(testUpdate, 3)
		else
			return
		end

		local amount = math.random(1,100)
		display.bar:SetWidth((amount/100) * (200+(db.additionalWidth*2)))
		display.title:SetFormattedText(L.yourPowerTest, amount)

		local colorTbl = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
		local sortedUnitListTest, powerListTest = {}, {}
		local amount = db.expanded and 26 or 10
		for i = 1, amount do
			sortedUnitListTest[i] = i
			powerListTest[i] = math.random(1, 99)
		end
		tsort(sortedUnitListTest, function(x,y)
			local px, py = powerListTest[x], powerListTest[y]
			if px == py then
				return x > y
			else
				return px > py
			end
		end)
		for i = 1, amount do
			local unitNumber = sortedUnitListTest[i]
			local tableSize = #classList
			local tableEntry = unitNumber % tableSize
			if tableEntry == 0 then tableEntry = tableSize end
			local class = classList[tableEntry]
			local role = roleList[tableEntry]
			local power = powerListTest[unitNumber]
			local r, g = colorize(power, 100)
			local name = (L.player):format(unitNumber)
			local classColorTbl = class and colorTbl[class] or GRAY_FONT_COLOR
			display.text[i]:SetFormattedText("|cFF%02x%02x00[%d]|r %s|cFF%02x%02x%02x%s|r", r, g, power, roleIcons[role], classColorTbl.r*255, classColorTbl.g*255, classColorTbl.b*255, name)
		end
	end
	function plugin:Test()
		if not inTestMode then
			self:Close()

			display:Show()
			inTestMode = true
			testUpdate()
		end
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
			-- If we don't have sync data (players not using BigWigs) use whatever (potentially incorrect) data Blizz gives us.
			powerList[unit] = syncPowerList and syncPowerList[unit] or UnitPower(unit, 10) -- Enum.PowerType.Alternate = 10
			powerMaxList[unit] = syncPowerMaxList and syncPowerMaxList[unit] or UnitPowerMax(unit, 10) -- Enum.PowerType.Alternate = 10
		end
		local power = UnitPower("player", 10)
		local percent = power / UnitPowerMax("player", 10)
		display.bar:SetWidth(percent * (200+(db.additionalWidth*2)))
		display.title:SetFormattedText(L.yourAltPower, currentTitle, power)
		tsort(sortedUnitList, sortTbl)
		for i = 1, db.expanded and 26 or 10 do
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
	display:SetHeight(210+(db.additionalHeight*13))
	display.expand:SetNormalTexture("Interface\\AddOns\\BigWigs\\Media\\Icons\\arrows_up")
	if not inTestMode then
		UpdateDisplay()
	end
end

function plugin:Contract()
	db.expanded = false
	display:SetHeight(82+(db.additionalHeight*5))
	display.expand:SetNormalTexture("Interface\\AddOns\\BigWigs\\Media\\Icons\\arrows_down")
	for i = 11, 26 do
		display.text[i]:SetText("")
	end
end

function plugin:Close()
	if repeatSync then
		self:UnregisterEvent("GROUP_ROSTER_UPDATE")
		self:CancelTimer(repeatSync)
		repeatSync = nil
	end

	if updater then self:CancelTimer(updater) end
	updater = nil
	display:UnregisterEvent("GROUP_ROSTER_UPDATE")
	display:Hide()
	self:UnregisterMessage("BigWigs_PluginComm")
	for i = 1, 26 do
		display.text[i]:SetText("")
	end

	powerList, powerMaxList, sortedUnitList, roleColoredList, syncPowerList, syncPowerMaxList = nil, nil, nil, nil, nil, nil
	unitList, opener, inTestMode, currentTitle = nil, nil, nil, nil
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
			if display:IsShown() then
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
