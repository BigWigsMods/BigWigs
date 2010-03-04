-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Proximity")
if not plugin then return end

plugin.defaultDB = {
	posx = nil,
	posy = nil,
	showTitle = true,
	showBackground = true,
	showSound = true,
	showClose = true,
	lock = nil,
	width = 100,
	height = 80,
	sound = true,
	disabled = nil,
	proximity = true,
}

-------------------------------------------------------------------------------
-- Locals
--

local AceGUI = nil

local mute = "Interface\\AddOns\\BigWigs\\Textures\\icons\\mute"
local unmute = "Interface\\AddOns\\BigWigs\\Textures\\icons\\unmute"

local inConfigMode = nil
local activeProximityFunction = nil
local anchor = nil

local OnOptionToggled = nil -- Function invoked when the proximity option is toggled on a module.

local hexColors = {}
for k, v in pairs(RAID_CLASS_COLORS) do
	hexColors[k] = ("|cff%02x%02x%02x"):format(v.r * 255, v.g * 255, v.b * 255)
end

-- Helper table to cache colored player names.
local coloredNames = setmetatable({}, {__index =
	function(self, key)
		if type(key) == "nil" then return nil end
		local _, class = UnitClass(key)
		if class then
			self[key] = hexColors[class] .. key .. "|r"
			return self[key]
		else
			return key
		end
	end
})

-------------------------------------------------------------------------------
-- Range functions
--

local bandages = {
	34722, -- Heavy Frostweave Bandage
	34721, -- Frostweave Bandage
	21991, -- Heavy Netherweave Bandage
	21990, -- Netherweave Bandage
	14530, -- Heavy Runecloth Bandage
	14529, -- Runecloth Bandage
	8545, -- Heavy Mageweave Bandage
	8544, -- Mageweave Bandage
	6451, -- Heavy Silk Bandage
	6450, -- Silk Bandage
	3531, -- Heavy Wool Bandage
	3530, -- Wool Bandage
	2581, -- Heavy Linen Bandage
	1251, -- Linen Bandage
}

local ranges = {
	[15] = function(unit)
		for i, v in next, bandages do
			local r = IsItemInRange(v, unit)
			if type(r) == "number" then
				if r == 1 then return true end
				break
			end
		end
	end,
}

do
	local checkInteractDistance = nil
	local _, r = UnitRace("player")
	if r == "Tauren" then
		checkInteractDistance = { [3] = 6, [2] = 7, [4] = 25 }
	elseif r == "Scourge" then
		checkInteractDistance = { [3] = 7, [2] = 8, [4] = 27 }
	else
		checkInteractDistance = { [3] = 8, [2] = 9, [4] = 28 }
	end
	for index, range in pairs(checkInteractDistance) do
		ranges[range] = function(unit) return CheckInteractDistance(unit, index) end
	end

	local spells = {
		DEATHKNIGHT = { 61999, 49892, 49016 }, -- Raise Ally works even on players that are alive oO
		DRUID = { 5185, 467, 1126 },
		-- HUNTER = { 34477 }, -- Misdirect is like 100y range, so forget it!
		HUNTER = {},
		MAGE = { 475, 1459 },
		PALADIN = { 635, 19740, 20473 },
		PRIEST = { 2050, 1243 },
		ROGUE = { 57934 },
		SHAMAN = { 331, 526 },
		WARRIOR = { 50720 }, -- Can't use Intervene since it has a minimum range.
		WARLOCK = { 5697 },
	}
	local _, class = UnitClass("player")
	local mySpells = spells[class]
	-- Gift of the Naaru
	if r == "Draenei" then tinsert(mySpells, 28880) end
	if mySpells then
		for i, spell in next, mySpells do
			local name, _, _, _, _, _, _, minRange, range = GetSpellInfo(spell)
			if name and range then
				local works = IsSpellInRange(name, "player")
				if type(works) == "number" then
					range = math.floor(range + 0.5)
					if range == 0 then range = 5 end
					if not ranges[range] then
						ranges[range] = function(unit)
							if IsSpellInRange(name, unit) == 1 then return true end
						end
					end
				end
			end
		end
	end
end
local function getClosestRangeFunction(toRange)
	if ranges[toRange] then return ranges[toRange], toRange end
	local closest = 15
	local closestDiff = math.abs(toRange - 15)
	for range, func in pairs(ranges) do
		local diff = math.abs(toRange - range)
		if diff < closestDiff then
			closest = range
			closestDiff = diff
		end
	end
	return ranges[closest], closest
end

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")

--------------------------------------------------------------------------------
-- Options
--

local function updateSoundButton()
	if not anchor then return end
	anchor.sound:SetNormalTexture(plugin.db.profile.sound and unmute or mute)
end
local function toggleSound()
	plugin.db.profile.sound = not plugin.db.profile.sound
	updateSoundButton()
end

-------------------------------------------------------------------------------
-- Display Window
--

local function onDragStart(self) self:StartMoving() end
local function onDragStop(self)
	self:StopMovingOrSizing()
	local s = self:GetEffectiveScale()
	plugin.db.profile.posx = self:GetLeft() * s
	plugin.db.profile.posy = self:GetTop() * s
end
local function OnDragHandleMouseDown(self) self.frame:StartSizing("BOTTOMRIGHT") end
local function OnDragHandleMouseUp(self, button) self.frame:StopMovingOrSizing() end
local function onResize(self, width, height)
	plugin.db.profile.width = width
	plugin.db.profile.height = height
end

local function setConfigureTarget(self, button)
	if not inConfigMode or button ~= "LeftButton" then return end
	plugin:SendMessage("BigWigs_SetConfigureTarget", plugin)
end

local locked = nil
local function lockDisplay()
	if locked then return end
	anchor:EnableMouse(false)
	anchor:SetMovable(false)
	anchor:SetResizable(false)
	anchor:RegisterForDrag()
	anchor:SetScript("OnSizeChanged", nil)
	anchor:SetScript("OnDragStart", nil)
	anchor:SetScript("OnDragStop", nil)
	anchor:SetScript("OnMouseUp", nil)
	anchor.drag:Hide()
	locked = true
end
local function unlockDisplay()
	if not locked then return end
	anchor:EnableMouse(true)
	anchor:SetMovable(true)
	anchor:SetResizable(true)
	anchor:RegisterForDrag("LeftButton")
	anchor:SetScript("OnSizeChanged", onResize)
	anchor:SetScript("OnDragStart", onDragStart)
	anchor:SetScript("OnDragStop", onDragStop)
	anchor:SetScript("OnMouseUp", setConfigureTarget)
	anchor.drag:Show()
	locked = nil
end

local function onControlEnter(self)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:AddLine(self.tooltipHeader)
	GameTooltip:AddLine(self.tooltipText, 1, 1, 1, 1)
	GameTooltip:Show()
end
local function onControlLeave() GameTooltip:Hide() end

local function onNormalClose()
	if active then
		BigWigs:Print(L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."])
	end
	plugin:Close()
end

local function breakThings()
	anchor.sound:SetScript("OnEnter", nil)
	anchor.sound:SetScript("OnLeave", nil)
	anchor.sound:SetScript("OnClick", nil)
	anchor.close:SetScript("OnEnter", nil)
	anchor.close:SetScript("OnLeave", nil)
	anchor.close:SetScript("OnClick", nil)
end

local function makeThingsWork()
	anchor.sound:SetScript("OnEnter", onControlEnter)
	anchor.sound:SetScript("OnLeave", onControlLeave)
	anchor.sound:SetScript("OnClick", toggleSound)
	anchor.close:SetScript("OnEnter", onControlEnter)
	anchor.close:SetScript("OnLeave", onControlLeave)
	anchor.close:SetScript("OnClick", onNormalClose)
end

local function ensureDisplay()
	if anchor then return end

	local display = CreateFrame("Frame", "BigWigsProximityAnchor", UIParent)
	display:SetWidth(plugin.db.profile.width)
	display:SetHeight(plugin.db.profile.height)
	display:SetMinResize(100, 30)
	display:SetClampedToScreen(true)
	local bg = display:CreateTexture(nil, "PARENT")
	bg:SetAllPoints(display)
	bg:SetBlendMode("BLEND")
	bg:SetTexture(0, 0, 0, 0.3)
	display.background = bg

	local close = CreateFrame("Button", nil, display)
	close:SetPoint("BOTTOMRIGHT", display, "TOPRIGHT", -2, 2)
	close:SetHeight(16)
	close:SetWidth(16)
	close.tooltipHeader = L["Close"]
	close.tooltipText = L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."]
	close:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\close")
	display.close = close

	local sound = CreateFrame("Button", nil, display)
	sound:SetPoint("BOTTOMLEFT", display, "TOPLEFT", 2, 2)
	sound:SetHeight(16)
	sound:SetWidth(16)
	sound.tooltipHeader = L["Toggle sound"]
	sound.tooltipText = L["Toggle whether or not the proximity window should beep when you're too close to another player."]
	display.sound = sound

	local header = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	header:SetText(L["Proximity"])
	header:SetPoint("BOTTOM", display, "TOP", 0, 4)
	display.header = header

	local text = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	text:SetFont(L["proximityfont"], 12)
	text:SetText("")
	text:SetAllPoints(display)
	display.text = text
	display:SetScript("OnShow", function() text:SetText("|cff777777:-)|r") end)

	local drag = CreateFrame("Frame", nil, display)
	drag.frame = display
	drag:SetFrameLevel(display:GetFrameLevel() + 10) -- place this above everything
	drag:SetWidth(16)
	drag:SetHeight(16)
	drag:SetPoint("BOTTOMRIGHT", display, -1, 1)
	drag:EnableMouse(true)
	drag:SetScript("OnMouseDown", OnDragHandleMouseDown)
	drag:SetScript("OnMouseUp", OnDragHandleMouseUp)
	drag:SetAlpha(0.5)
	display.drag = drag

	local tex = drag:CreateTexture(nil, "BACKGROUND")
	tex:SetTexture("Interface\\AddOns\\BigWigs\\Textures\\draghandle")
	tex:SetWidth(16)
	tex:SetHeight(16)
	tex:SetBlendMode("ADD")
	tex:SetPoint("CENTER", drag)

	anchor = display

	local x = plugin.db.profile.posx
	local y = plugin.db.profile.posy
	if x and y then
		local s = display:GetEffectiveScale()
		display:ClearAllPoints()
		display:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	else
		display:ClearAllPoints()
		display:SetPoint("CENTER", UIParent)
	end

	plugin:RestyleWindow()
end

function plugin:RestyleWindow()
	updateSoundButton()
	if self.db.profile.showTitle then
		anchor.header:Show()
	else
		anchor.header:Hide()
	end
	if self.db.profile.showBackground then
		anchor.background:Show()
	else
		anchor.background:Hide()
	end
	if self.db.profile.showSound then
		anchor.sound:Show()
	else
		anchor.sound:Hide()
	end
	if self.db.profile.showClose then
		anchor.close:Show()
	else
		anchor.close:Hide()
	end
	if self.db.profile.lock then
		locked = nil
		lockDisplay()
	else
		locked = true
		unlockDisplay()
	end
end

-------------------------------------------------------------------------------
-- Proximity Updater
--

local updater = nil
do
	local tooClose = {} -- List of players who are too close.
	local lastplayed = 0 -- When we last played an alarm sound for proximity.

	local function updateProximity()
		local num = GetNumRaidMembers()
		for i = 1, num do
			local n = GetRaidRosterInfo(i)
			if n and UnitExists(n) and not UnitIsDeadOrGhost(n) and not UnitIsUnit(n, "player") and activeProximityFunction(n) then
				tooClose[#tooClose + 1] = coloredNames[n]
			end
			if #tooClose > 4 or i > 25 then break end
		end

		if #tooClose == 0 then
			anchor.text:SetText("|cff777777:-)|r")
		else
			anchor.text:SetText(table.concat(tooClose, "\n"))
			wipe(tooClose)
			if not plugin.db.profile.sound then return end
			local t = GetTime()
			if t > lastplayed + 1 then
				lastplayed = t
				plugin:SendMessage("BigWigs_Sound", "Alarm")
			end
		end
	end

	updater = CreateFrame("Frame")
	updater:Hide()
	local total = 0
	updater:SetScript("OnUpdate", function(self, elapsed)
		total = total + elapsed
		if total >= .5 then
			total = 0
			updateProximity()
		end
	end)
end

local function updateProfile()
	if not anchor then return end

	anchor:SetWidth(plugin.db.profile.width)
	anchor:SetHeight(plugin.db.profile.height)

	local x = plugin.db.profile.posx
	local y = plugin.db.profile.posy
	if x and y then
		local s = anchor:GetEffectiveScale()
		anchor:ClearAllPoints()
		anchor:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	else
		anchor:ClearAllPoints()
		anchor:SetPoint("CENTER", UIParent)
	end
end

local function resetAnchor()
	anchor:ClearAllPoints()
	anchor:SetPoint("CENTER", UIParent)
	anchor:SetWidth(plugin.defaultDB.width)
	anchor:SetHeight(plugin.defaultDB.height)
	plugin.db.profile.posx = nil
	plugin.db.profile.posy = nil
	plugin.db.profile.width = nil
	plugin.db.profile.height = nil
end

-------------------------------------------------------------------------------
--      Initialization
--

function plugin:OnRegister()
	BigWigs:RegisterBossOption("proximity", L["proximity"], L["proximity_desc"], OnOptionToggled)
	if CUSTOM_CLASS_COLORS then
		local function update()
			wipe(coloredNames)
			for k, v in pairs(CUSTOM_CLASS_COLORS) do
				hexColors[k] = ("|cff%02x%02x%02x"):format(v.r * 255, v.g * 255, v.b * 255)
			end
		end
		CUSTOM_CLASS_COLORS:RegisterCallback(update)
		update()
	end
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_ShowProximity")
	self:RegisterMessage("BigWigs_HideProximity", "Close")
	self:RegisterMessage("BigWigs_OnBossDisable")

	self:RegisterMessage("BigWigs_StartConfigureMode")
	self:RegisterMessage("BigWigs_StopConfigureMode")
	self:RegisterMessage("BigWigs_SetConfigureTarget")
	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	self:RegisterMessage("BigWigs_ResetPositions", resetAnchor)
end

function plugin:OnPluginDisable()
	self:Close()
end

-------------------------------------------------------------------------------
-- Options
--

function plugin:BigWigs_StartConfigureMode()
	inConfigMode = true
	self:Test()
end

function plugin:BigWigs_StopConfigureMode()
	inConfigMode = nil
	self:Close()
end

function plugin:BigWigs_SetConfigureTarget(event, module)
	ensureDisplay()
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
		plugin:RestyleWindow()
	end

	function plugin:GetPluginConfig()
		if not AceGUI then AceGUI = LibStub("AceGUI-3.0") end
		local disable = AceGUI:Create("CheckBox")
		disable:SetValue(self.db.profile.disabled)
		disable:SetLabel(L["Disabled"])
		disable:SetCallback("OnEnter", onControlEnter)
		disable:SetCallback("OnLeave", onControlLeave)
		disable:SetCallback("OnValueChanged", checkboxCallback)
		disable:SetUserData("tooltip", L["Disable the proximity display for all modules that use it."])
		disable:SetUserData("key", "disabled")
		disable:SetFullWidth(true)

		local lock = AceGUI:Create("CheckBox")
		lock:SetValue(self.db.profile.lock)
		lock:SetLabel(L["Lock"])
		lock:SetCallback("OnEnter", onControlEnter)
		lock:SetCallback("OnLeave", onControlLeave)
		lock:SetCallback("OnValueChanged", checkboxCallback)
		lock:SetUserData("tooltip", L["Locks the display in place, preventing moving and resizing."])
		lock:SetUserData("key", "lock")
		lock:SetFullWidth(true)

		local showHide = AceGUI:Create("InlineGroup")
		showHide:SetTitle(L["Show/hide"])
		showHide:SetFullWidth(true)

		do
			local title = AceGUI:Create("CheckBox")
			title:SetValue(self.db.profile.showTitle)
			title:SetLabel(L["Title"])
			title:SetCallback("OnEnter", onControlEnter)
			title:SetCallback("OnLeave", onControlLeave)
			title:SetCallback("OnValueChanged", checkboxCallback)
			title:SetUserData("tooltip", L["Shows or hides the title."])
			title:SetUserData("key", "showTitle")
			title:SetRelativeWidth(0.5)

			local background = AceGUI:Create("CheckBox")
			background:SetValue(self.db.profile.showBackground)
			background:SetLabel(L["Background"])
			background:SetCallback("OnEnter", onControlEnter)
			background:SetCallback("OnLeave", onControlLeave)
			background:SetCallback("OnValueChanged", checkboxCallback)
			background:SetUserData("tooltip", L["Shows or hides the background."])
			background:SetUserData("key", "showBackground")
			background:SetRelativeWidth(0.5)

			local sound = AceGUI:Create("CheckBox")
			sound:SetValue(self.db.profile.showSound)
			sound:SetLabel(L["Sound button"])
			sound:SetCallback("OnEnter", onControlEnter)
			sound:SetCallback("OnLeave", onControlLeave)
			sound:SetCallback("OnValueChanged", checkboxCallback)
			sound:SetUserData("tooltip", L["Shows or hides the sound button."])
			sound:SetUserData("key", "showSound")
			sound:SetRelativeWidth(0.5)

			local close = AceGUI:Create("CheckBox")
			close:SetValue(self.db.profile.showClose)
			close:SetLabel(L["Close button"])
			close:SetCallback("OnEnter", onControlEnter)
			close:SetCallback("OnLeave", onControlLeave)
			close:SetCallback("OnValueChanged", checkboxCallback)
			close:SetUserData("tooltip", L["Shows or hides the close button."])
			close:SetUserData("key", "showClose")
			close:SetRelativeWidth(0.5)

			showHide:AddChildren(title, background, sound, close)
		end
		return disable, lock, showHide
	end
end

-------------------------------------------------------------------------------
-- Events
--

do
	local opener = nil
	function plugin:BigWigs_ShowProximity(event, module, range)
		if self.db.profile.disabled or type(range) ~= "number" then return end
		opener = module
		self:Open(range)
	end

	function plugin:BigWigs_OnBossDisable(event, module)
		if module ~= opener then return end
		self:Close()
	end
end

-------------------------------------------------------------------------------
-- API
--

function plugin:Close()
	activeProximityFunction = nil
	if anchor then
		anchor.header:SetText(L["Proximity"])
		-- Just in case we were the last target of
		-- configure mode, reset the background color.
		anchor.background:SetTexture(0, 0, 0, 0.3)
		anchor:Hide()
	end
	updater:Hide()
end

function plugin:Open(range)
	if type(range) ~= "number" then error("Range needs to be a number!") end
	-- Make sure the anchor is there
	ensureDisplay()
	-- Get the best range function for the given range
	local func, actualRange = getClosestRangeFunction(range)
	activeProximityFunction = func
	-- Update the header to reflect the actual range we're checking
	anchor.header:SetText(L["%d yards"]:format(actualRange))
	-- Unbreak the sound+close buttons
	makeThingsWork()
	-- Start the show!
	anchor:Show()
	updater:Show()
end

function plugin:Test()
	-- Make sure the anchor is there
	ensureDisplay()
	-- Close ourselves in case we entered configure mode DURING a boss fight.
	self:Close()
	-- Break the sound+close buttons
	breakThings()
	anchor:Show()
end

-------------------------------------------------------------------------------
-- Slash command
--

SlashCmdList.BigWigs_Proximity = function(input)
	if not plugin:IsEnabled() then BigWigs:Enable() end
	input = input:trim()
	if input == "" or input == "?" or input == "ranges" then
		print("Available ranges (in yards) for the promixity display:")
		local t = {}
		for range in pairs(ranges) do t[#t + 1] = range end
		print(table.concat(t, ", "))
		print("Example: /proximity " .. tostring(t[1]))
	else
		local range = tonumber(input)
		if not range then return end
		plugin:Open(range)
	end
end
SLASH_BigWigs_Proximity1 = "/proximity"
SLASH_BigWigs_Proximity2 = "/bwproximity" -- In case some other addon already has /proximity

