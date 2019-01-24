
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
	fontName = plugin:GetDefaultFont(),
	fontSize = 12,
	fontOutline = "",
}

--------------------------------------------------------------------------------
-- Options
--
do
	local disabled = function() return plugin.db.profile.disabled end
	plugin.pluginOptions = {
		name = L.infoBox,
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
		},
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
		plugin:UpdateGUI()
	end)
	display:SetScript("OnHide", function(self)
		inTestMode = false
		opener = nil
		nameList = {}
		for i = 1, 40 do
			self.text[i]:SetText("")
		end
		for i = 1, 40, 2 do
			self.bar[i]:Hide()
		end
		self.title:SetText(L.infoBox)
	end)

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
	close:SetNormalTexture("Interface\\AddOns\\BigWigs\\Media\\Textures\\icons\\close")
	close:SetScript("OnClick", function()
		BigWigs:Print(L.toggleDisplayPrint)
		plugin:Close()
	end)

	local header = display:CreateFontString(nil, "OVERLAY")
	header:SetFont(plugin:GetDefaultFont(12))
	header:SetShadowOffset(1, -1)
	header:SetTextColor(1,0.82,0,1)
	header:SetPoint("BOTTOMLEFT", display, "TOPLEFT", 2, 2)
	display.title = header

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

local function resetAnchor()
	display:ClearAllPoints()
	display:SetPoint("CENTER", UIParent, "CENTER", -300, -80)
	db.posx = nil
	db.posy = nil
end

local function updateProfile()
	db = plugin.db.profile

	if display then
		plugin:RestyleWindow()
	end
end

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_ShowInfoBox")
	self:RegisterMessage("BigWigs_HideInfoBox", "Close")
	self:RegisterMessage("BigWigs_SetInfoBoxTitle")
	self:RegisterMessage("BigWigs_SetInfoBoxLine")
	self:RegisterMessage("BigWigs_SetInfoBoxTable")
	self:RegisterMessage("BigWigs_SetInfoBoxTableWithBars")
	self:RegisterMessage("BigWigs_SetInfoBoxBar")
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

function plugin:BigWigs_ShowInfoBox(_, module, title, TEMP)
	if opener then
		display:Hide()
	end

	opener = module or self
	for unit in self:IterateGroup() do
		nameList[#nameList+1] = self:UnitName(unit)
	end
	display.title:SetText(title)
	display:Show()

	if TEMP then
		display.xxx1:Show()
		display.xxx2:Show()
		display.xxx3:Show()
	else
		display.xxx1:Hide()
		display.xxx2:Hide()
		display.xxx3:Hide()
	end
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
			return x > y
		else
			return px > py
		end
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
				return x > y
			else
				return sortingTbl[x][3] > sortingTbl[y][3]
			end
		else
			return px > py
		end
	end
	local next = next
	local Timer = C_Timer.After
	local reschedule = false
	local function update()
		if next(sortingTbl) then
			Timer(0.1, update)
		else
			reschedule = false
			return
		end

		for i = 1, 5 do
			local n = nameList[i]
			local result = sortingTbl[n]
			if result then
				local t = result[3] + 0.1
				result[3] = t
				local duration = result[2]
				local remaining = duration - t
				plugin:BigWigs_SetInfoBoxBar(nil, nil, i*2, remaining/duration)
			end
		end
	end
	function plugin:BigWigs_SetInfoBoxTableWithBars(_, _, tbl)
		sortingTbl = tbl
		tsort(nameList, sortBarsFunc)
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
		display:Hide()
		sortingTbl = {}
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
