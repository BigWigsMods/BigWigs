local LibKeystone = LibStub("LibKeystone")
local LibSpec = LibStub("LibSpecialization")

local guildList, partyList = {}, {}

local specs = {}
do
	local function addToTable(specID, _, _, playerName)
		specs[playerName] = specID
	end
	LibSpec:Register(specs, addToTable)
	LibSpec.RegisterGuild(specs, addToTable)
end

local roleIcons = {
	TANK = INLINE_TANK_ICON,
	HEALER = INLINE_HEALER_ICON,
	DAMAGER = INLINE_DAMAGER_ICON,
}
local dungeonNames = {
	[1594] = "MTHR",
	[2097] = "MECH",
	[2293] = "TOP",
	[2648] = "ROOK",
	[2649] = "PRI",
	[2651] = "DARK",
	[2661] = "BREW",
	[2773] = "FLOOD",
}
local cellsCurrentlyShowing = {}

local mainPanel = CreateFrame("Frame", nil, UIParent, "SettingsFrameTemplate")
mainPanel:Hide()
mainPanel:SetSize(400, 350)
mainPanel:SetPoint("LEFT", 50)
mainPanel:SetFrameStrata("DIALOG")
mainPanel:SetMovable(true)
mainPanel:EnableMouse(true)
mainPanel:RegisterForDrag("LeftButton")
mainPanel.NineSlice.Text:SetText("BigWigs Keystones")
mainPanel.ClosePanelButton:SetScript("OnClick", function() mainPanel:Hide() end)
mainPanel:SetScript("OnDragStart", mainPanel.StartMoving)
mainPanel:SetScript("OnDragStop", mainPanel.StopMovingOrSizing)
mainPanel:SetScript("OnHide", function() cellsCurrentlyShowing = {} end)

local scrollArea = CreateFrame("ScrollFrame", nil, mainPanel, "ScrollFrameTemplate")
scrollArea:SetPoint("TOPLEFT", mainPanel, "TOPLEFT", 8, -30)
scrollArea:SetPoint("BOTTOMRIGHT", mainPanel, "BOTTOMRIGHT", -25, 5)

local scrollChild = CreateFrame("Frame", nil, scrollArea)
scrollArea:SetScrollChild(scrollChild)
scrollChild:SetSize(400, 350)

local partyHeader = scrollChild:CreateFontString(nil, nil, "GameFontNormalLarge")
partyHeader:SetPoint("TOP", scrollChild, "TOP", 0, -0)
partyHeader:SetText("Party")

local partyRefreshButton = CreateFrame("Button", nil, scrollChild)
partyRefreshButton:SetSize(20, 20)
partyRefreshButton:SetPoint("LEFT", partyHeader, "RIGHT", 5, 0)
partyRefreshButton:SetNormalTexture("Interface\\Buttons\\UI-RefreshButton")
partyRefreshButton:SetPushedTexture("Interface\\Buttons\\UI-RefreshButton-Down")
partyRefreshButton:SetHighlightTexture("Interface\\Buttons\\UI-RefreshButton")
partyRefreshButton:SetScript("OnClick", function()
	partyList = {}
	LibKeystone.Request("PARTY")
end)
partyRefreshButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("Refresh Party")
	GameTooltip:Show()
end)
partyRefreshButton:SetScript("OnLeave", GameTooltip_Hide)

local guildHeader = scrollChild:CreateFontString(nil, nil, "GameFontNormalLarge")
guildHeader:SetText("Guild")

-- Refresh button for Guild section
local guildRefreshButton = CreateFrame("Button", nil, scrollChild)
guildRefreshButton:SetSize(20, 20)
guildRefreshButton:SetPoint("LEFT", guildHeader, "RIGHT", 5, 0)
guildRefreshButton:SetNormalTexture("Interface\\Buttons\\UI-RefreshButton")
guildRefreshButton:SetPushedTexture("Interface\\Buttons\\UI-RefreshButton-Down")
guildRefreshButton:SetHighlightTexture("Interface\\Buttons\\UI-RefreshButton")
guildRefreshButton:SetScript("OnClick", function()
	guildList = {}
	LibSpec.RequestGuildSpecialization()
	C_Timer.After(0.1, function() LibKeystone.Request("GUILD") end)
end)
guildRefreshButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("Refresh Guild")
	GameTooltip:Show()
end)
guildRefreshButton:SetScript("OnLeave", GameTooltip_Hide)

local hiddenCellTable = {}
local OnLeaveFunction = function(self)
	if self.tooltip then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.tooltip)
		GameTooltip:Show()
	end
end
local OnHideFunction = function(self)
	self:ClearAllPoints()
	hiddenCellTable[#hiddenCellTable+1] = self
end
local function CreateCell()
	local cell = hiddenCellTable[#hiddenCellTable]
	if cell then
		hiddenCellTable[#hiddenCellTable] = nil
		cell:Show()
		return cell
	else
		cell = CreateFrame("Frame", nil, scrollChild)
		cell:SetSize(20, 20)
		cell:SetScript("OnEnter", OnLeaveFunction)
		cell:SetScript("OnLeave", GameTooltip_Hide)
		cell:SetScript("OnHide", OnHideFunction)

		cell.text = cell:CreateFontString(nil, nil, "GameFontNormal")
		cell.text:SetPoint("CENTER")

		local bg = cell:CreateTexture()
		bg:SetAllPoints(cell)
		bg:SetColorTexture(0, 0, 0, 0.6)

		return cell
	end
end

SLASH_BigWigsTestKS1 = "/bwtemp" -- temp
SlashCmdList.BigWigsTestKS = function()
	partyList = {}
	guildList = {}
	mainPanel:Show()
	LibKeystone.Request("PARTY")
	LibSpec.RequestGuildSpecialization()
	C_Timer.After(0.1, function() LibKeystone.Request("GUILD") end)
end

local nameWidth, levelWidth, mapWidth, ratingWidth = 160, 24, 90, 42
local function WipeCells()
	for cell in next, cellsCurrentlyShowing do
		cell:Hide()
	end
	cellsCurrentlyShowing = {}
end
local function UpdateCells(playerList)
	local sortedplayerList = {}
	for pName, pData in next, playerList do
		local decoratedName = nil
		local nameTooltip = pName
		local specID = specs[pName]
		if specID then
			local _, specName, _, specIcon, role, classFile, className = GetSpecializationInfoByID(specID)
			local color = C_ClassColor.GetClassColor(classFile)
			decoratedName = format("|T%d:0|t%s|c%s%s|r", specIcon, roleIcons[role] or "", color:GenerateHexColor(), gsub(pName, "%-.+", "*"))
			nameTooltip = format("%s|c%s%s|r |A:classicon-%s:12:12|a%s |T%d:0|t%s", roleIcons[role] or "", color:GenerateHexColor(), pName, classFile, className, specIcon, specName)
		end
		sortedplayerList[#sortedplayerList+1] = {
			name = pName, decoratedName = decoratedName, nameTooltip = nameTooltip,
			level = pData[1], levelTooltip = ("Keystone level: |cFFFFFFFF%d|r"):format(pData[1]),
			map = dungeonNames[pData[2]] or pData[2] > 0 and pData[2] or "-", mapTooltip = ("Dungeon: |cFFFFFFFF%s|r"):format(pData[2] > 0 and GetRealZoneText(pData[2]) or "-"),
			rating = pData[3], ratingTooltip = ("Mythic+ rating: |cFFFFFFFF%d|r"):format(pData[3]),
		}
	end
	-- Sort list by level descending, or by name if equal level
	table.sort(sortedplayerList, function(a, b)
		if a.level > b.level then
			return true
		elseif a.level == b.level then
			return a.name < b.name
		end
	end)

	local prevName, prevLevel, prevMap, prevRating = nil, nil, nil, nil
	local tableSize = #sortedplayerList
	for i = 1, tableSize do
		local cellName, cellLevel, cellMap, cellRating = CreateCell(), CreateCell(), CreateCell(), CreateCell()
		if i == 1 then
			cellName:SetPoint("RIGHT", cellLevel, "LEFT", -6, 0)
			cellLevel:SetPoint("TOP", playerList == partyList and partyHeader or guildHeader, "BOTTOM", 0, -12)
			cellMap:SetPoint("LEFT", cellLevel, "RIGHT", 6, 0)
			cellRating:SetPoint("LEFT", cellMap, "RIGHT", 6, 0)
		else
			cellName:SetPoint("TOP", prevName, "BOTTOM", 0, -6)
			cellLevel:SetPoint("TOP", prevLevel, "BOTTOM", 0, -6)
			cellMap:SetPoint("TOP", prevMap, "BOTTOM", 0, -6)
			cellRating:SetPoint("TOP", prevRating, "BOTTOM", 0, -6)
		end
		cellName:SetWidth(nameWidth)
		cellName.text:SetText(sortedplayerList[i].decoratedName or sortedplayerList[i].name)
		cellName.tooltip = sortedplayerList[i].nameTooltip
		cellsCurrentlyShowing[cellName] = true
		cellLevel:SetWidth(levelWidth)
		cellLevel.text:SetText(sortedplayerList[i].level)
		cellLevel.tooltip = sortedplayerList[i].levelTooltip
		cellsCurrentlyShowing[cellLevel] = true
		cellMap:SetWidth(mapWidth)
		cellMap.text:SetText(sortedplayerList[i].map)
		cellMap.tooltip = sortedplayerList[i].mapTooltip
		cellsCurrentlyShowing[cellMap] = true
		cellRating:SetWidth(ratingWidth)
		cellRating.text:SetText(sortedplayerList[i].rating)
		cellRating.tooltip = sortedplayerList[i].ratingTooltip
		cellsCurrentlyShowing[cellRating] = true
		prevName, prevLevel, prevMap, prevRating = cellName, cellLevel, cellMap, cellRating

		if i == tableSize then
			-- Calculate scroll height
			local contentsHeight = partyHeader:GetTop() - prevName:GetBottom()
			local newHeight = 10 + contentsHeight + 10 -- 10 top padding + content + 10 bottom padding
			scrollChild:SetHeight(newHeight)
		end
	end

	if playerList == partyList then
		guildHeader:ClearAllPoints()
		local y = 24 + tableSize*26
		guildHeader:SetPoint("TOP", partyHeader, "BOTTOM", 0, -y)
	end
end

LibKeystone.Register({}, function(keyLevel, keyMap, playerRating, playerName, channel)
	if channel == "PARTY" then
		partyList[playerName] = {keyLevel, keyMap, playerRating}

		if mainPanel:IsShown() then
			WipeCells()
			UpdateCells(partyList)
			UpdateCells(guildList)
		end
	elseif channel == "GUILD" then
		guildList[playerName] = {keyLevel, keyMap, playerRating}

		if mainPanel:IsShown() then
			WipeCells()
			UpdateCells(partyList)
			UpdateCells(guildList)
		end
	end
end)
