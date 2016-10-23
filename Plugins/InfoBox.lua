--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("InfoBox")
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs: Plugins")
local media = LibStub("LibSharedMedia-3.0")
plugin.displayName = "InfoBox"

local opener, display = nil, nil

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
-- Frame Creation
--

do
	display = CreateFrame("Frame", "BigWigsInfoBox", UIParent)
	display:SetSize(150, 100)
	display:SetClampedToScreen(true)
	display:EnableMouse(true)
	display:SetScript("OnMouseUp", function(self, button)
		if inTestMode and button == "LeftButton" then
			plugin:SendMessage("BigWigs_SetConfigureTarget", plugin)
		end
	end)
	display:SetScript("OnHide", function()
		for i = 1, 10 do
			display.text[i]:SetText("")
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

	local header = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	header:SetPoint("BOTTOMLEFT", display, "TOPLEFT", 2, 2)
	display.title = header

	display.text = {}
	for i = 1, 10 do
		local text = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		text:SetSize(75, 20)
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

	display:Hide()
end

-------------------------------------------------------------------------------
-- Initialization
--

local function resetAnchor()
	display:ClearAllPoints()
	display:SetPoint("CENTER", UIParent, "CENTER", -300, -80)
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
			display:SetPoint("CENTER", UIParent, "CENTER", -300, -80)
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

function plugin:BigWigs_SetConfigureTarget(_, module)
	if module == self then
		display.background:SetColorTexture(0.2, 1, 0.2, 0.3)
	else
		display.background:SetColorTexture(0, 0, 0, 0.3)
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

function plugin:Test()
	display.title:SetText("InfoBox") -- L.infoBox
	for i = 1, 10 do
		display.text[i]:SetText(i)
	end
	display:Show()
end
