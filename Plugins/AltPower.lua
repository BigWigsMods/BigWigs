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
}

--------------------------------------------------------------------------------
-- Locals
--

local playerTbl, nameList, raidList = {}, {}, plugin:GetPartyList()
local maxPlayers = 0
local display, updater = nil, nil
local opener = nil
local UpdateDisplay
local tsort = table.sort
local UnitPower = UnitPower
local db

-------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_OpenAltPower")
	self:RegisterMessage("BigWigs_CloseAltPower", "Close")
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
		display:SetSize(220, 80)
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

		local header = display:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		header:SetText("AltPower")
		header:SetPoint("BOTTOM", display, "TOP", 0, 4)

		display.text = {}
		for i = 1, 25 do
			local text = display:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
			text:SetFont("Fonts\\FRIZQT__.TTF", 12) -- XXX Fix font
			text:SetText("")
			text:SetSize(110, 14)
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

	function plugin:BigWigs_OpenAltPower(_, module)
		if not IsInGroup() then return end -- Solo runs of old content
		if createFrame then createFrame() createFrame = nil end
		self:Close()

		maxPlayers = GetNumGroupMembers()
		opener = module
		raidList = IsInRaid() and self:GetRaidList() or self:GetPartyList()
		for i = 1, maxPlayers do
			nameList[i] = UnitName(raidList[i])
		end
		display:Show()
		updater:Play()
		UpdateDisplay()
	end

	function plugin:Test()
		if createFrame then createFrame() createFrame = nil end
		-- Close ourselves in case we entered configure mode DURING a boss fight.
		self:Close()
		raidList = self:GetRaidList()
		for i = 1, 10 do
			local name = raidList[i]
			display.text[i]:SetFormattedText("[%d] %s", 100-i, name)
		end
		display:Show()
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
		return playerTbl[x] > playerTbl[y]
	end

	function UpdateDisplay()
		for i = 1, maxPlayers do
			local unit = raidList[i]
			local fullName = nameList[i]
			playerTbl[fullName] = UnitPower(unit, 10) -- ALTERNATE_POWER_INDEX = 10
		end
		--tsort(nameList)
		tsort(nameList, sortTbl)
		for i = 1, 10 do
			local name = nameList[i]
			if not name then return end
			display.text[i]:SetFormattedText("[%d] %s", playerTbl[name], name)
		end
	end
end

function plugin:Close()
	if not updater then return end
	updater:Stop()
	display:Hide()
	wipe(playerTbl)
	wipe(nameList)
	opener = nil
	for i = 1, 25 do
		display.text[i]:SetText("")
	end
end

function plugin:BigWigs_OnBossDisable(_, module)
	if module == opener then
		self:Close()
	end
end

