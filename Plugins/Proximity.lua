-----------------------------------------------------------------------
--      Module Declaration
-----------------------------------------------------------------------

local plugin = BigWigs:NewPlugin("Proximity")
if not plugin then return end

-----------------------------------------------------------------------
--      Are you local?
-----------------------------------------------------------------------

local AceGUI = nil

local mute = "Interface\\AddOns\\BigWigs\\Textures\\icons\\mute"
local unmute = "Interface\\AddOns\\BigWigs\\Textures\\icons\\unmute"

local db = nil

local lockWarned = nil
local active = nil -- The module we're currently tracking proximity for.
local anchor = nil
local lastplayed = 0 -- When we last played an alarm sound for proximity.
local tooClose = {} -- List of players who are too close.

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


local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")

--------------------------------------------------------------------------------
-- Options
--

local function updateSoundButton()
	if not anchor then return end
	if active and active.proximitySilent then
		anchor.sound:SetNormalTexture(mute)
	else
		anchor.sound:SetNormalTexture(plugin.db.profile.sound and unmute or mute)
	end
end

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
plugin.external = true

----
-- proximity repeater frame
----
local repeater = CreateFrame("Frame", nil, UIParent)
repeater:Hide()
repeater.elapsed = 0
repeater:SetScript("OnUpdate", function( self, elapsed ) 
	self.elapsed = self.elapsed + elapsed
	if repeater.elapsed >= .5 then
		repeater.elapsed = 0
		plugin:UpdateProximity()
	end
end )

-----------------------------------------------------------------------
--      Initialization
-----------------------------------------------------------------------

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
	
	db = self.db.profile
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_OnBossDisable")
	self:RegisterMessage("BigWigs_OnPluginDisable", "BigWigs_OnBossDisable")
	self:RegisterMessage("BigWigs_ShowProximity")
	self:RegisterMessage("BigWigs_HideProximity")
	self:RegisterMessage("BigWigs_StartConfigureMode", "TestProximity")
	self:RegisterMessage("BigWigs_StopConfigureMode", "CloseProximity")
	self:RegisterMessage("BigWigs_SetConfigureTarget")
end

function plugin:OnPluginDisable()
	self:CloseProximity()
end

-------------------------------------------------------------------------------
-- Options
--

function plugin:BigWigs_SetConfigureTarget(event, module)
	if not anchor then self:SetupFrames() end
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
		disable:SetValue(db.disabled)
		disable:SetLabel(L["Disabled"])
		disable:SetCallback("OnEnter", onControlEnter)
		disable:SetCallback("OnLeave", onControlLeave)
		disable:SetCallback("OnValueChanged", checkboxCallback)
		disable:SetUserData("tooltip", L["Disable the proximity display for all modules that use it."])
		disable:SetUserData("key", "disabled")
		disable:SetFullWidth(true)

		local lock = AceGUI:Create("CheckBox")
		lock:SetValue(db.lock)
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
			title:SetValue(db.showTitle)
			title:SetLabel(L["Title"])
			title:SetCallback("OnEnter", onControlEnter)
			title:SetCallback("OnLeave", onControlLeave)
			title:SetCallback("OnValueChanged", checkboxCallback)
			title:SetUserData("tooltip", L["Shows or hides the title."])
			title:SetUserData("key", "showTitle")
			title:SetRelativeWidth(0.5)

			local background = AceGUI:Create("CheckBox")
			background:SetValue(db.showBackground)
			background:SetLabel(L["Background"])
			background:SetCallback("OnEnter", onControlEnter)
			background:SetCallback("OnLeave", onControlLeave)
			background:SetCallback("OnValueChanged", checkboxCallback)
			background:SetUserData("tooltip", L["Shows or hides the background."])
			background:SetUserData("key", "showBackground")
			background:SetRelativeWidth(0.5)

			local sound = AceGUI:Create("CheckBox")
			sound:SetValue(db.showSound)
			sound:SetLabel(L["Sound button"])
			sound:SetCallback("OnEnter", onControlEnter)
			sound:SetCallback("OnLeave", onControlLeave)
			sound:SetCallback("OnValueChanged", checkboxCallback)
			sound:SetUserData("tooltip", L["Shows or hides the sound button."])
			sound:SetUserData("key", "showSound")
			sound:SetRelativeWidth(0.5)

			local close = AceGUI:Create("CheckBox")
			close:SetValue(db.showClose)
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

-----------------------------------------------------------------------
--      Event Handlers
-----------------------------------------------------------------------

function plugin:BigWigs_ShowProximity(event, module)
	if active then error("The proximity window is already running for another module.") end
	active = module
	self:OpenProximity()
end

function plugin:BigWigs_HideProximity(event, module)
	active = nil
	self:CloseProximity()
end

OnOptionToggled = function(module)
	if active and active == module then
		if active.db.profile.proximity then
			plugin:OpenProximity()
		else
			plugin:CloseProximity()
		end
	end
end

function plugin:BigWigs_OnBossDisable(event, module)
	if active and active == module then
		self:BigWigs_HideProximity(active)
	end
end

-----------------------------------------------------------------------
--      Util
-----------------------------------------------------------------------

function plugin:CloseProximity()
	if anchor then anchor:Hide() end
	repeater:Hide()
end

function plugin:OpenProximity()
	if self.db.profile.disabled then return end
	if active and (not active.proximityCheck or not active.db.profile.proximity) then return end
	if not anchor then self:SetupFrames()
	else updateSoundButton() end

	wipe(tooClose)
	anchor.text:SetText(L["|cff777777Nobody|r"])
	anchor.header:SetText(active and active.proximityHeader or L["Close Players"])
	anchor:Show()
	repeater:Show()
end

function plugin:TestProximity()
	if active then error("The proximity module is already running for another boss module.") end
	self:OpenProximity()
end

function plugin:UpdateProximity()
	local num = GetNumRaidMembers()
	for i = 1, num do
		local n = GetRaidRosterInfo(i)
		if UnitExists(n) and not UnitIsDeadOrGhost(n) and not UnitIsUnit(n, "player") then
			if not active or not active.proximityCheck or active.proximityCheck == "bandage" then
				for i, v in next, bandages do
					if IsItemInRange(v, n) == 1 then
						table.insert(tooClose, coloredNames[n])
						break
					end
				end
			elseif active and type(active.proximityCheck) == "function" then
				if active.proximityCheck(n) then
					table.insert(tooClose, coloredNames[n])
				end
			end
		end
		if #tooClose > 4 then break end
	end

	if #tooClose == 0 then
		anchor.text:SetText(L["|cff777777Nobody|r"])
	else
		anchor.text:SetText(table.concat(tooClose, "\n"))
		wipe(tooClose)
		if not self.db.profile.sound or (active and active.proximitySilent) then return end
		local t = time()
		if t > lastplayed + 1 then
			lastplayed = t
			self:SendMessage("BigWigs_Sound", "Alarm")
		end
	end
end

------------------------------
--    Create the Anchor     --
------------------------------

local function onDragStart(self) self:StartMoving() end
local function onDragStop(self)
	self:StopMovingOrSizing()
	plugin:SavePosition()
end
local function OnDragHandleMouseDown(self) self.frame:StartSizing("BOTTOMRIGHT") end
local function OnDragHandleMouseUp(self, button) self.frame:StopMovingOrSizing() end
local function onResize(self, width, height)
	plugin.db.profile.width = width
	plugin.db.profile.height = height
end

local function setConfigureTarget(self, button)
	if button ~= "LeftButton" then return end
	plugin:SendMessage("BigWigs_SetConfigureTarget", plugin)
end

local locked = nil
function lockDisplay()
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
function unlockDisplay()
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

function plugin:SetupFrames()
	if anchor then return end

	local display = CreateFrame("Frame", "BigWigsProximityAnchor", UIParent)
	display:SetWidth(self.db.profile.width)
	display:SetHeight(self.db.profile.height)
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
	close:SetScript("OnEnter", onControlEnter)
	close:SetScript("OnLeave", onControlLeave)
	close:SetScript("OnClick", function()
		if active then
			BigWigs:Print(L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."])
		end
		plugin:CloseProximity()
	end)
	close:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\close")
	display.close = close

	local sound = CreateFrame("Button", nil, display)
	sound:SetPoint("BOTTOMLEFT", display, "TOPLEFT", 2, 2)
	sound:SetHeight(16)
	sound:SetWidth(16)
	sound.tooltipHeader = L["Toggle sound"]
	sound.tooltipText = L["Toggle whether or not the proximity window should beep when you're too close to another player."]
	sound:SetScript("OnEnter", onControlEnter)
	sound:SetScript("OnLeave", onControlLeave)
	sound:SetScript("OnClick", toggleSound)
	display.sound = sound

	local header = display:CreateFontString(nil, "OVERLAY")
	header:SetFontObject(GameFontNormal)
	header:SetText(L["Close Players"])
	header:SetPoint("BOTTOM", display, "TOP", 0, 4)
	display.header = header

	local text = display:CreateFontString(nil, "OVERLAY")
	text:SetFontObject(GameFontNormal)
	text:SetFont(L["proximityfont"], 12)
	text:SetText("")
	text:SetAllPoints(display)
	display.text = text

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
	self:RestyleWindow()

	local x = self.db.profile.posx
	local y = self.db.profile.posy
	if x and y then
		local s = display:GetEffectiveScale()
		display:ClearAllPoints()
		display:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
	else
		self:ResetAnchor()
	end
end

function plugin:RestyleWindow()
	if not anchor then return end
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

function plugin:ResetAnchor()
	if not anchor then self:SetupFrames() end
	anchor:ClearAllPoints()
	anchor:SetPoint("CENTER", UIParent, "CENTER")
	self.db.profile.posx = nil
	self.db.profile.posy = nil
end

function plugin:SavePosition()
	if not anchor then self:SetupFrames() end
	local s = anchor:GetEffectiveScale()
	self.db.profile.posx = anchor:GetLeft() * s
	self.db.profile.posy = anchor:GetTop() * s
end

