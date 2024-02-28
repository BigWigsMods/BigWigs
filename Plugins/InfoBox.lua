
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

function plugin:RestyleWindow()
	if db.lock then
		display:EnableMouse(false)
	else
		display:EnableMouse(true)
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
	for i = 1, 10 do
		display.text[i]:SetFont(font, db.fontSize, flags)
	end
end

-------------------------------------------------------------------------------
-- Options
--

plugin.defaultDB = {
	disabled = false,
	lock = false,
	position = {"CENTER", "CENTER", -450, -40},
	--fontName = plugin:GetDefaultFont(),
	--fontSize = 12,
	fontOutline = "",
}

-------------------------------------------------------------------------------
-- Frame Creation
--

do
	display = CreateFrame("Frame", nil, UIParent)
	display:SetSize(infoboxWidth, infoboxHeight)
	display:SetFrameStrata("MEDIUM")
	display:SetFixedFrameStrata(true)
	display:SetFrameLevel(130)
	display:SetFixedFrameLevel(true)
	display:SetClampedToScreen(true)
	display:EnableMouse(true)
	display:SetMovable(true)
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
		--plugin:UpdateGUI() -- Update X/Y if GUI is open.
	end)

	local function dragStart()
		if display:IsMovable() then
			display:StartMoving()
		end
	end
	local function dragStop()
		display:StopMovingOrSizing()
		local point, _, relPoint, x, y = display:GetPoint()
		db.position = {point, relPoint, x, y}
		--plugin:UpdateGUI() -- Update X/Y if GUI is open.
	end
	local display2 = CreateFrame("Frame", nil, display)
	display2:Hide()
	display2:SetSize(infoboxWidth, infoboxHeight)
	display2:SetPoint("LEFT", display, "RIGHT")
	display2:SetFrameStrata("MEDIUM")
	display2:SetFixedFrameStrata(true)
	display2:SetFrameLevel(130)
	display2:SetFixedFrameLevel(true)
	display2:SetClampedToScreen(true)
	display2:EnableMouse(true)
	display2:SetMovable(true)
	display2:RegisterForDrag("LeftButton")
	display2:SetScript("OnDragStart", dragStart)
	display2:SetScript("OnDragStop", dragStop)
	display.display2 = display2
	local display3 = CreateFrame("Frame", nil, display)
	display3:Hide()
	display3:SetSize(infoboxWidth, infoboxHeight)
	display3:SetPoint("TOP", display, "BOTTOM")
	display3:SetFrameStrata("MEDIUM")
	display3:SetFixedFrameStrata(true)
	display3:SetFrameLevel(130)
	display3:SetFixedFrameLevel(true)
	display3:SetClampedToScreen(true)
	display3:EnableMouse(true)
	display3:SetMovable(true)
	display3:RegisterForDrag("LeftButton")
	display3:SetScript("OnDragStart", dragStart)
	display3:SetScript("OnDragStop", dragStop)
	display.display3 = display3
	local display4 = CreateFrame("Frame", nil, display)
	display4:Hide()
	display4:SetSize(infoboxWidth, infoboxHeight)
	display4:SetPoint("TOPLEFT", display, "BOTTOMRIGHT")
	display4:SetFrameStrata("MEDIUM")
	display4:SetFixedFrameStrata(true)
	display4:SetFrameLevel(130)
	display4:SetFixedFrameLevel(true)
	display4:SetClampedToScreen(true)
	display4:EnableMouse(true)
	display4:SetMovable(true)
	display4:RegisterForDrag("LeftButton")
	display4:SetScript("OnDragStart", dragStart)
	display4:SetScript("OnDragStop", dragStop)
	display.display4 = display4

	local bg = display:CreateTexture()
	bg:SetAllPoints(display)
	bg:SetColorTexture(0, 0, 0, 0.3)
	display.background = bg

	local xxx1 = display:CreateTexture()
	xxx1:SetPoint("LEFT", display, "RIGHT")
	xxx1:SetColorTexture(0, 0, 0, 0.3)
	xxx1:SetSize(infoboxWidth, infoboxHeight)
	xxx1:Hide()
	display.xxx1 = xxx1

	local xxx2 = display:CreateTexture()
	xxx2:SetPoint("TOP", display, "BOTTOM")
	xxx2:SetColorTexture(0, 0, 0, 0.3)
	xxx2:SetSize(infoboxWidth, infoboxHeight)
	xxx2:Hide()
	display.xxx2 = xxx2

	local xxx3 = display:CreateTexture()
	xxx3:SetPoint("TOPLEFT", display, "BOTTOMRIGHT")
	xxx3:SetColorTexture(0, 0, 0, 0.3)
	xxx3:SetSize(infoboxWidth, infoboxHeight)
	xxx3:Hide()
	display.xxx3 = xxx3

	local close = CreateFrame("Button", nil, display)
	close:SetPoint("BOTTOMRIGHT", display, "TOPRIGHT", -2, 2)
	close:SetHeight(16)
	close:SetWidth(16)
	close:SetNormalTexture("Interface\\AddOns\\BigWigs\\Media\\Icons\\close")
	close:SetScript("OnClick", function()
		BigWigs:Print(L.toggleDisplayPrint)
		plugin:Close()
	end)
	display.close = close

	local header = display:CreateFontString(nil, "OVERLAY")
	header:SetFont(plugin:GetDefaultFont(12))
	header:SetShadowOffset(1, -1)
	header:SetTextColor(1,0.82,0,1)
	header:SetPoint("BOTTOMLEFT", display, "TOPLEFT", 2, 2)
	header:SetText(L.infoBox)
	display.title = header

	local headerFrame = CreateFrame("Frame", nil, display)
	headerFrame:Show()
	headerFrame:SetWidth(infoboxWidth)
	headerFrame:SetHeight(18)
	headerFrame:SetPoint("BOTTOMLEFT", display, "TOPLEFT")
	headerFrame:SetFrameStrata("MEDIUM")
	headerFrame:SetFixedFrameStrata(true)
	headerFrame:SetFrameLevel(130)
	headerFrame:SetFixedFrameLevel(true)
	headerFrame:SetClampedToScreen(true)
	headerFrame:EnableMouse(true)
	headerFrame:SetMovable(true)
	headerFrame:RegisterForDrag("LeftButton")
	headerFrame:SetScript("OnDragStart", dragStart)
	headerFrame:SetScript("OnDragStop", dragStop)
	display.headerFrame = headerFrame

	display.text = {}
	for i = 1, 20 do
		local text = display:CreateFontString(nil, "OVERLAY")
		text:SetFont(plugin:GetDefaultFont(12))
		text:SetShadowOffset(1, -1)
		text:SetTextColor(1,0.82,0,1)
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
	for i = 21, 40 do
		local text = display:CreateFontString(nil, "OVERLAY")
		text:SetFont(plugin:GetDefaultFont(12))
		text:SetShadowOffset(1, -1)
		text:SetTextColor(1,0.82,0,1)
		text:SetSize(infoboxWidth/2, infoboxHeight/5)
		if i % 2 == 0 then
			text:SetPoint("LEFT", display.text[i-1], "RIGHT", -5, 0)
			text:SetJustifyH("RIGHT")
		else
			text:SetPoint("LEFT", display.text[i-19], "RIGHT")
			text:SetJustifyH("LEFT")
		end
		display.text[i] = text
	end

	local bgLayer, bgLevel = bg:GetDrawLayer()
	display.bar = {}
	for i = 1, 40, 2 do
		local bar = display:CreateTexture(nil, bgLayer, nil, bgLevel + 1)
		bar:SetSize(infoboxWidth, infoboxHeight/5-1)
		bar:SetColorTexture(0, 1, 0, 0.3)
		bar:Hide()
		if i == 1 then
			bar:SetPoint("TOPLEFT", display, "TOPLEFT", 0, -1)
		elseif i == 21 then
			bar:SetPoint("TOPLEFT", display, "TOPRIGHT", 0, -1)
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

local function updateProfile()
	db = plugin.db.profile

	db.posx = nil
	db.posy = nil

	display:ClearAllPoints()
	local point, relPoint = db.position[1], db.position[2]
	local x, y = db.position[3], db.position[4]
	display:SetPoint(point, UIParent, relPoint, x, y)

	--plugin:RestyleWindow()
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_ShowInfoBox")
	self:RegisterMessage("BigWigs_HideInfoBox", "Close")

	self:RegisterMessage("BigWigs_OnBossDisable")
	self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossDisable")

	self:RegisterMessage("BigWigs_StartConfigureMode", "Test")
	self:RegisterMessage("BigWigs_StopConfigureMode", "Close")

	self:RegisterMessage("BigWigs_ProfileUpdate", updateProfile)
	updateProfile()
end

function plugin:OnPluginDisable()
	self:Close()
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:BigWigs_ShowInfoBox(_, module, title, lines)
	if opener then
		self:Close()
	end

	self:RegisterMessage("BigWigs_SetInfoBoxTitle")
	self:RegisterMessage("BigWigs_SetInfoBoxLine")
	self:RegisterMessage("BigWigs_SetInfoBoxTable")
	self:RegisterMessage("BigWigs_SetInfoBoxTableWithBars")
	self:RegisterMessage("BigWigs_SetInfoBoxBar")

	opener = module or self
	for unit in self:IterateGroup() do
		nameList[#nameList+1] = self:UnitName(unit)
	end
	display.title:SetText(title)
	display:Show()

	if lines then
		if type(lines) == "number" then
			if lines <= 5 then
				display.xxx1:Hide()
				display.xxx2:Hide()
				display.xxx3:Hide()
				display.display2:Hide()
				display.display3:Hide()
				display.display4:Hide()
				display.close:SetPoint("BOTTOMRIGHT", display, "TOPRIGHT", -2, 2)
				display.headerFrame:SetWidth(infoboxWidth)
			elseif lines >= 11 then
				display.xxx1:Show()
				display.xxx2:Show()
				display.xxx3:Show()
				display.display2:Show()
				display.display3:Show()
				display.display4:Show()
				display.close:SetPoint("BOTTOMRIGHT", display, "TOPRIGHT", infoboxWidth-2, 2)
				display.headerFrame:SetWidth(infoboxWidth*2)
			else
				display.xxx1:Hide()
				display.xxx2:Show()
				display.xxx3:Hide()
				display.display2:Hide()
				display.display3:Show()
				display.display4:Hide()
				display.close:SetPoint("BOTTOMRIGHT", display, "TOPRIGHT", -2, 2)
				display.headerFrame:SetWidth(infoboxWidth)
			end
		else
			display.xxx1:Show()
			display.xxx2:Show()
			display.xxx3:Show()
			display.display2:Show()
			display.display3:Show()
			display.display4:Show()
			display.close:SetPoint("BOTTOMRIGHT", display, "TOPRIGHT", infoboxWidth-2, 2)
			display.headerFrame:SetWidth(infoboxWidth*2)
		end
	else
		display.xxx1:Hide()
		display.xxx2:Hide()
		display.xxx3:Hide()
		display.display2:Hide()
		display.display3:Hide()
		display.display4:Hide()
		display.close:SetPoint("BOTTOMRIGHT", display, "TOPRIGHT", -2, 2)
		display.headerFrame:SetWidth(infoboxWidth)
	end
end

function plugin:BigWigs_SetInfoBoxTitle(_, _, text)
	display.title:SetText(text)
end

function plugin:BigWigs_SetInfoBoxLine(_, _, line, text, r, g, b)
	display.text[line]:SetText(text)
	if r then
		display.text[line]:SetTextColor(r, g, b, 1)
	else
		display.text[line]:SetTextColor(1, 0.82, 0, 1)
	end
	local row = line
	if line % 2 == 0 then
		row = line-1
	end
	self:BigWigs_ResizeInfoBoxRow(row)
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
	local sortingTbl = {}
	local function sortFunc(x,y)
		local px, py = sortingTbl[x] or -1, sortingTbl[y] or -1
		if px == py then
			return x < y
		else
			return px > py
		end
	end
	local function sortFuncReverse(x,y)
		local px, py = sortingTbl[x] or -1, sortingTbl[y] or -1
		if px == py then
			return x < y
		else
			return px < py
		end
	end
	local tsort = table.sort
	local colors = plugin:GetColoredNameTable()
	function plugin:BigWigs_SetInfoBoxTable(_, _, tbl, tableEntries, lineStart, reverseOrder)
		sortingTbl = tbl
		tsort(nameList, reverseOrder and sortFuncReverse or sortFunc)
		local line = lineStart or 1
		for i = 1, tableEntries or 5 do
			local n = nameList[i]
			local result = tbl[n]
			if result then
				display.text[line]:SetText(colors[n])
				display.text[line+1]:SetText(result)
			else
				display.text[line]:SetText("")
				display.text[line+1]:SetText("")
			end
			self:BigWigs_ResizeInfoBoxRow(line)
			line = line + 2
		end
	end

	local function sortBarsFunc(x,y)
		local px, py = sortingTbl[x] and sortingTbl[x][1] or -1, sortingTbl[y] and sortingTbl[y][1] or -1
		if px == py then
			if px == -1 then
				return x < y
			else
				return sortingTbl[x][2] < sortingTbl[y][2]
			end
		else
			return px > py
		end
	end
	local function sortBarsReverseFunc(x,y)
		local px, py = sortingTbl[x] and sortingTbl[x][1], sortingTbl[y] and sortingTbl[y][1]
		if px == py then
			if px then -- Have data
				if sortingTbl[x][2] == sortingTbl[y][2] then
					return x < y -- Expiration is the same, sort by name
				else
					return sortingTbl[x][2] < sortingTbl[y][2] -- Sory by expiration
				end
			else
				return x < y -- No data, sort by name
			end
		elseif px == 0 or not py then
			-- Special case, always place 0 stacks first when in reverse
			-- Also always place entries with data before entries without (px has data in this case)
			return true
		elseif not px then
			return false -- Always place entries with data before entries without (py has data in this case)
		else
			return sortingTbl[x][2] < sortingTbl[y][2]
		end
	end
	local next = next
	local Timer = C_Timer.After
	local GetTime = GetTime
	local reschedule = false
	local function update()
		if next(sortingTbl) then
			Timer(0.1, update)
		else
			reschedule = false
			return
		end

		local t = GetTime()
		for i = 1, 5 do
			local n = nameList[i]
			local result = sortingTbl[n]
			if result then
				local endTime = result[2]
				local remaining = endTime - t
				plugin:BigWigs_SetInfoBoxBar(nil, nil, i*2, remaining/result[3])
			end
		end
	end
	function plugin:BigWigs_SetInfoBoxTableWithBars(_, _, tbl, reverseOrder)
		sortingTbl = tbl
		tsort(nameList, reverseOrder and sortBarsReverseFunc or sortBarsFunc)
		local line = 1
		for i = 1, 5 do
			local n = nameList[i]
			local result = tbl[n]
			if result then
				display.text[line]:SetText(colors[n])
				display.text[line+1]:SetText(result[1])
			else
				display.text[line]:SetText("")
				display.text[line+1]:SetText("")
				self:BigWigs_SetInfoBoxBar(nil, nil, i*2, 0)
			end
			self:BigWigs_ResizeInfoBoxRow(line)
			line = line + 2
		end
		if not reschedule then
			reschedule = true
			Timer(0.1, update)
		end
	end

	function plugin:Close()
		inTestMode = false
		opener = nil
		nameList, sortingTbl = {}, {}
		display:Hide()
		for i = 1, 40 do
			display.text[i]:SetText("")
		end
		for i = 1, 40, 2 do
			display.bar[i]:Hide()
		end
		display.title:SetText(L.infoBox)
		self:UnregisterMessage("BigWigs_SetInfoBoxTitle")
		self:UnregisterMessage("BigWigs_SetInfoBoxLine")
		self:UnregisterMessage("BigWigs_SetInfoBoxTable")
		self:UnregisterMessage("BigWigs_SetInfoBoxTableWithBars")
		self:UnregisterMessage("BigWigs_SetInfoBoxBar")
	end
end

function plugin:BigWigs_SetInfoBoxBar(_, _, line, percentage, r, g, b, a)
	local bar = display.bar[line]
	percentage = min(1, percentage)
	if percentage > 0 then
		if r then
			bar:SetColorTexture(r, g, b, a)
		else
			bar:SetColorTexture(0.5, 0.5, 0.5, 0.5)
		end
		bar:SetWidth(percentage * infoboxWidth)
		bar:Show()
	else
		bar:Hide()
	end
end

function plugin:BigWigs_OnBossDisable(_, module)
	if module == opener then
		self:Close()
	end
end

function plugin:Test()
	inTestMode = true
	self:BigWigs_ShowInfoBox(nil, self, L.infoBox, 5)
	self:BigWigs_SetInfoBoxLine(nil, nil, 1, L.test)
	self:BigWigs_SetInfoBoxLine(nil, nil, 2, 1)
	self:BigWigs_SetInfoBoxLine(nil, nil, 3, L.test)
	self:BigWigs_SetInfoBoxLine(nil, nil, 4, 2)
	self:BigWigs_SetInfoBoxLine(nil, nil, 5, L.test)
	self:BigWigs_SetInfoBoxLine(nil, nil, 6, 3)
	self:BigWigs_SetInfoBoxLine(nil, nil, 7, L.test)
	self:BigWigs_SetInfoBoxLine(nil, nil, 8, 4)
	self:BigWigs_SetInfoBoxLine(nil, nil, 9, L.test)
	self:BigWigs_SetInfoBoxLine(nil, nil, 10, 5)
end
