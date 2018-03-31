
-- GLOBALS: UIParent, GameFontNormal, BigWigs

--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("InfoBox")
if not plugin then return end

--------------------------------------------------------------------------------
-- Locals
--

local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
local media = LibStub("LibSharedMedia-3.0")
local FONT = media.MediaType and media.MediaType.FONT or "font"
plugin.displayName = L.infoBox

local min = math.min

local opener, display = nil, nil
local nameList = {}
local infoboxWidth = 150
local infoboxHeight = 100

local db = nil
local inTestMode = false

function plugin:RestyleWindow(dirty)
	if db.lock then
		display:EnableMouse(false)
	else
		display:EnableMouse(true)
	end

	local font, size, flags = GameFontNormal:GetFont()
	local curFont = media:Fetch(FONT, db.font)
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
		for i = 1, 10 do
			display.text[i]:SetFont(curFont, db.fontSize, newFlags)
		end
	end
end

-------------------------------------------------------------------------------
-- Options
--

do
	local font = media:GetDefault(FONT)
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
	display:SetSize(infoboxWidth, infoboxHeight)
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
	display:SetScript("OnMouseUp", function(self, button)
		if inTestMode and button == "LeftButton" then
			plugin:SendMessage("BigWigs_SetConfigureTarget", plugin)
		end
	end)
	display:SetScript("OnHide", function(self)
		inTestMode = false
		opener = nil
		nameList = {}
		for i = 1, 10 do
			self.text[i]:SetText("")
		end
		for i = 1, 9, 2 do
			self.bar[i]:Hide()
		end
		self.title:SetText(L.infoBox)
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
		text:SetSize(infoboxWidth/2, infoboxHeight/5)
		if i == 1 then
			text:SetPoint("TOPLEFT", display, "TOPLEFT", 5, 0)
			text:SetJustifyH("LEFT")
		elseif i % 2 == 0 then
			text:SetPoint("LEFT", display.text[i-1], "RIGHT", -5, 0)
			text:SetJustifyH("RIGHT")
		else
			text:SetPoint("TOPLEFT", display.text[i-2], "BOTTOMLEFT")
			text:SetJustifyH("LEFT")
		end
		display.text[i] = text
	end

	local bgLayer, bgLevel = bg:GetDrawLayer()
	display.bar = {}
	for i = 1, 9, 2 do
		local bar = display:CreateTexture(nil, bgLayer, nil, bgLevel + 1)
		bar:SetSize(infoboxWidth, infoboxHeight/5-1)
		bar:SetColorTexture(0, 1, 0, 0.3)
		if i == 1 then
			bar:SetPoint("TOPLEFT", display, "TOPLEFT", 0, -1)
		else
			bar:SetPoint("TOPLEFT", display.bar[i-1], "BOTTOMLEFT", 0, -1)
		end
		display.bar[i] = bar
		display.bar[i+1] = bar
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

		--plugin:RestyleWindow()
	end
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_ShowInfoBox")
	self:RegisterMessage("BigWigs_HideInfoBox", "Close")
	self:RegisterMessage("BigWigs_SetInfoBoxTitle")
	self:RegisterMessage("BigWigs_SetInfoBoxLine")
	self:RegisterMessage("BigWigs_SetInfoBoxTable")
	self:RegisterMessage("BigWigs_SetInfoBoxBar")
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

function plugin:BigWigs_ShowInfoBox(_, module, title)
	if opener then
		display:Hide()
	end

	opener = module or self
	for unit in self:IterateGroup() do
		nameList[#nameList+1] = self:UnitName(unit)
	end
	display.title:SetText(title)
	display:Show()
end

function plugin:BigWigs_SetInfoBoxTitle(_, _, text)
	display.title:SetText(text)
end

function plugin:BigWigs_SetInfoBoxLine(_, _, line, text)
	display.text[line]:SetText(text)
	local row = line
	if line % 2 == 0 then
		row = line-1
	end
	plugin:BigWigs_ResizeInfoBoxRow(row)
end

function plugin:BigWigs_ResizeInfoBoxRow(row)
	local rowWidth = infoboxWidth-5 -- Adjust for margin right
	-- Get text width [left]
	display.text[row]:SetSize(rowWidth, infoboxHeight/5)
	display.text[row+1]:SetSize(0, infoboxHeight/5)
	local leftTextWidth = display.text[row]:GetStringWidth()
	-- Get text width [right]
	display.text[row]:SetSize(0, infoboxHeight/5)
	display.text[row+1]:SetSize(rowWidth, infoboxHeight/5)
	local rightTextWidth = display.text[row+1]:GetStringWidth()

	-- Size accordingly
	if leftTextWidth + rightTextWidth > rowWidth then -- Too much info: Prune something
		if leftTextWidth > rowWidth and rightTextWidth > rowWidth then -- 50%/50% - Both too big
			display.text[row]:SetSize((rowWidth/2), infoboxHeight/5)
			display.text[row+1]:SetSize((rowWidth/2), infoboxHeight/5)
		elseif leftTextWidth > 0  and rightTextWidth > rowWidth*0.80 then -- Show most of right text
			display.text[row]:SetSize(rowWidth*0.20, infoboxHeight/5)
			display.text[row+1]:SetSize((rowWidth*0.80), infoboxHeight/5)
		elseif leftTextWidth > 0 then -- Show all of right text, partially left
			display.text[row]:SetSize(rowWidth-rightTextWidth, infoboxHeight/5)
			display.text[row+1]:SetSize(rightTextWidth, infoboxHeight/5)
		else-- show all of right text, no left text
			display.text[row]:SetSize(0, infoboxHeight/5)
			display.text[row+1]:SetSize(rowWidth, infoboxHeight/5)
		end
	elseif leftTextWidth + rightTextWidth <= rowWidth then -- Fits, yay!
		display.text[row]:SetSize(leftTextWidth, infoboxHeight/5)
		display.text[row+1]:SetSize(rowWidth-leftTextWidth, infoboxHeight/5)
	end
end

do
	local sortingTbl = nil
	local function sortFunc(x,y)
		local px, py = sortingTbl[x] or -1, sortingTbl[y] or -1
		return px > py
	end
	local tsort = table.sort
	local colors = plugin:GetColoredNameTable()
	function plugin:BigWigs_SetInfoBoxTable(_, _, tbl)
		sortingTbl = tbl
		tsort(nameList, sortFunc)
		local line = 1
		for i = 1, 5 do
			local n = nameList[i]
			local result = tbl[n]
			display.text[line]:SetText(result and colors[n] or "")
			display.text[line+1]:SetText(result or "")
			plugin:BigWigs_ResizeInfoBoxRow(line)
			line = line + 2
		end
	end
end

function plugin:BigWigs_SetInfoBoxBar(_, _, line, percentage, r, g, b, a)
	local bar = display.bar[line]
	percentage = min(1, percentage)
	bar:SetColorTexture(r or 0.5, g or 0.5, b or 0.5, a or 0.5)
	if percentage > 0 then
		bar:SetWidth(percentage * infoboxWidth)
		bar:Show()
	else
		bar:Hide()
	end
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
	inTestMode = true
	for i = 1, 10 do
		display.text[i]:SetText(i)
	end
	display:Show()
end
