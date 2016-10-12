--------------------------------------------------------------------------------
-- Module Declaration
--

local LULZ = false
if not LULZ then return end

local plugin = BigWigs:NewPlugin("InfoBox")
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs: Plugins")
local media = LibStub("LibSharedMedia-3.0")
plugin.displayName = "InfoBox"

local opener = nil
local display = nil

function plugin:RestyleWindow(dirty)
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

	local font, size, flags = GameFontNormal:GetFont()
	local curFont = media:Fetch("font", db.font)
	if dirty or curFont ~= font or db.fontSize ~= size or db.fontOutline ~= flags then
		local newFlags
		if db.monochrome and db.fontOutline ~= "" then
			newFlags = "MONOCHROME," .. db.fontOutline
		elseif db.monochrome then
			newFlags = "MONOCHROME"
		else
			newFlags = db.fontOutline
		end

		display.title:SetFont(curFont, db.fontSize, newFlags)
		for i = 1, 25 do
			display.text[i]:SetFont(curFont, db.fontSize, newFlags)
		end
	end
end

-------------------------------------------------------------------------------
-- Options
--

do
	local font = media:GetDefault("font")
	local _, size, flags = GameFontNormal:GetFont()

	plugin.defaultDB = {
		disabled = false,
		lock = false,
		font = font,
		fontSize = size,
		fontOutline = flags,
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
end

local function updateProfile()
	db = plugin.db.profile

	if display then
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
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_ShowInfoBox")
	self:RegisterMessage("BigWigs_HideInfoBox", "Close")
	self:RegisterMessage("BigWigs_SetInfoBoxLine")
	self:RegisterMessage("BigWigs_OnBossDisable")
	self:RegisterMessage("BigWigs_OnBossReboot", "BigWigs_OnBossDisable")

	self:RegisterMessage("BigWigs_OnBossEngage")
	self:RegisterMessage("BigWigs_OnBossWin")
	self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossWin")

	self:RegisterMessage("BigWigs_StartConfigureMode", "Test")
	self:RegisterMessage("BigWigs_StopConfigureMode", "Close")
	self:RegisterMessage("BigWigs_SetConfigureTarget")

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
	local function createFrame()
		display = CreateFrame("Frame", "BigWigsInfoBox", UIParent)
		display:SetSize(200, 80)
		display:SetClampedToScreen(true)
		display:EnableMouse(true)
		display:SetScript("OnMouseUp", function(self, button)
			if inTestMode and button == "LeftButton" then
				plugin:SendMessage("BigWigs_SetConfigureTarget", plugin)
			end
		end)

		local bg = display:CreateTexture()
		bg:SetAllPoints(display)
		bg:SetColorTexture(0, 0, 0, 0.3)
		display.background = bg

		local close = CreateFrame("Button", nil, display)
		close:SetPoint("BOTTOMRIGHT", display, "TOPRIGHT", -2, 2)
		close:SetHeight(16)
		close:SetWidth(16)
		close:SetNormalTexture("Interface\\AddOns\\BigWigs\\Textures\\icons\\close")
		close:SetScript("OnClick", function()
			BigWigs:Print(L.toggleDisplayPrint)
			plugin:Close()
		end)

		local timer = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		timer:SetPoint("BOTTOMLEFT", display, "TOPLEFT")
		timer:SetHeight(16)
		timer:SetWidth(50)
		timer:SetText("0:00")
		display.timer = timer

		local header = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		header:SetPoint("BOTTOM", display, "TOP", 0, 4)
		display.title = header

		display.text = {}
		for i = 1, 25 do
			local text = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			text:SetText("")
			text:SetSize(100, 16)
			if i == 1 then
				text:SetPoint("TOPLEFT", display, "TOPLEFT", 5, 0)
				text:SetJustifyH("LEFT")
			elseif i % 2 == 0 then
				text:SetPoint("LEFT", display.text[i-1], "RIGHT", -5, 0)
				text:SetJustifyH("RIGHT")
			else
				text:SetPoint("TOP", display.text[i-2], "BOTTOM")
				text:SetJustifyH("LEFT")
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

	function plugin:Test()
		if createFrame then createFrame() createFrame = nil end
		display.title:SetText("InfoBox") -- L.infoBox
		display.timer:SetText("0:00")
		display.text[1]:SetText("BigWigs")
		display.text[2]:SetText("beta")
		display.text[3]:SetText("test")
		display.text[4]:SetText("mode")
		for i = 5, 25 do
			display.text[i]:SetText("")
		end
		display:Show()
	end
end

function plugin:BigWigs_SetConfigureTarget(_, module)
	if module == self then
		display.background:SetColorTexture(0.2, 1, 0.2, 0.3)
	else
		display.background:SetColorTexture(0, 0, 0, 0.3)
	end
end

do
	local floor = math.floor
	local tformat = "%d:%02d"
	local schedule = nil
	local function updateFunc()
		elapsed = elapsed + 1
		local m = floor(elapsed/60)
		local s = elapsed - (m*60)
		display.timer:SetFormattedText(tformat, m, s)
	end
	function plugin:BigWigs_OnBossEngage(_, module)
		if module.journalId then
			if schedule then self:CancelTimer(schedule) end
			local elapsed = 0
			display.timer:SetText("0:00")
			schedule = self:ScheduleRepeatingTimer(updateFunc, 1)
		end
	end
	function plugin:BigWigs_OnBossWin(_, module)
		if module.journalId then
			self:CancelTimer(schedule)
			schedule = nil
		end
	end
end

function plugin:BigWigs_ShowInfoBox(_, module)
	opener = module
	display:Show()
end

function plugin:BigWigs_SetInfoBoxLine(_, module, line, text)
	display.text[line]:SetText(text)
end

function plugin:Close()
	display:Hide()
end

function plugin:BigWigs_OnBossDisable(_, module)
	if module == opener then
		self:Close()
	end
end

