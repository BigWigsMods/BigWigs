--------------------------------------------------------------------------------
-- Module Declaration
--

local LULZ = false
if not LULZ then return end

local plugin = BigWigs:NewPlugin("InfoBox")
if not plugin then return end

plugin.defaultDB = {
	disabled = false,
	lock = false,
}

--------------------------------------------------------------------------------
-- Locals
--

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")
local media = LibStub("LibSharedMedia-3.0")
--plugin.displayName = L.altPowerTitle

function plugin:RestyleWindow(dirty)
	--[[if db.lock then
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
			newFlags = "" -- "MONOCHROME", XXX monochrome only is disabled for now as it causes a client crash
		else
			newFlags = db.fontOutline
		end

		display.title:SetFont(curFont, db.fontSize, newFlags)
		for i = 1, 25 do
			display.text[i]:SetFont(curFont, db.fontSize, newFlags)
		end
	end]]
end

-------------------------------------------------------------------------------
-- Options
--

-------------------------------------------------------------------------------
-- Initialization
--

local function resetAnchor()
	--[[display:ClearAllPoints()
	display:SetPoint("CENTER", UIParent, "CENTER", 300, -80)
	db.posx = nil
	db.posy = nil]]
end

local function updateProfile()
	db = plugin.db.profile

	--[[if not db.font then
		db.font = media:GetDefault("font")
	end
	if not db.fontSize then
		local _, size = GameFontNormal:GetFont()
		db.fontSize = size
	end
	if not db.fontOutline then
		local _, _, flags = GameFontNormal:GetFont()
		db.fontOutline = flags
	end

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
	end]]
end

function plugin:OnPluginEnable()
	--self:RegisterMessage("BigWigs_ShowAltPower")
	--self:RegisterMessage("BigWigs_HideAltPower", "Close")
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

do
	--[[local function createFrame()
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
			BigWigs:Print(L.toggleDisplayPrint)
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
	end]]

	function plugin:BigWigs_ShowAltPower(event, module, title, sorting, sync)
		if db.disabled then return end

		if createFrame then createFrame() createFrame = nil end
		self:Close()

		opener = module

		display:Show()
	end

	function plugin:Test()
		if createFrame then createFrame() createFrame = nil end
		self:Close()


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

function plugin:Close()
	
end

function plugin:BigWigs_OnBossDisable(_, module)
	if module == opener then
		self:Close()
	end
end

