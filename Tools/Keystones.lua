-- This module is WIP, expect all code to be awful
local L, LoaderPublic
do
	local _, tbl = ...
	L = tbl.API:GetLocale("BigWigs")
	LoaderPublic = tbl.loaderPublic
end

local LibKeystone = LibStub("LibKeystone")
local LibSpec = LibStub("LibSpecialization")

local guildList, partyList = {}, {}
local WIDTH_NAME, WIDTH_LEVEL, WIDTH_MAP, WIDTH_RATING = 150, 24, 66, 42

local GetMapUIInfo, GetRealZoneText = C_ChallengeMode.GetMapUIInfo, GetRealZoneText

local specs = {}
do
	local function addToTable(specID, _, _, playerName)
		specs[playerName] = specID
	end
	LibSpec:Register(specs, addToTable)
	LibSpec.RegisterGuild(specs, addToTable)
end

local roleIcons = {
	TANK = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Role_Tank:16:16|t",
	HEALER = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Role_Healer:16:16|t",
	DAMAGER = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Role_Damage:16:16|t",
}
local hiddenIcon = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Private:16:16|t"
local dungeonNames = {
	[500] = L.keystoneShortName_TheRookery, -- ROOK
	[504] = L.keystoneShortName_DarkflameCleft, -- DFC
	[499] = L.keystoneShortName_PrioryOfTheSacredFlame, -- PRIORY
	[506] = L.keystoneShortName_CinderbrewMeadery, -- BREW
	[525] = L.keystoneShortName_OperationFloodgate, -- FLOOD
	[382] = L.keystoneShortName_TheaterOfPain, -- TOP
	[247] = L.keystoneShortName_TheMotherlode, -- ML
	[370] = L.keystoneShortName_OperationMechagonWorkshop, -- WORK

	[542] = L.keystoneShortName_EcoDomeAldani, -- ALDANI
	[378] = L.keystoneShortName_HallsOfAtonement, -- HOA
	[503] = L.keystoneShortName_AraKaraCityOfEchoes, -- ARAK
	[392] = L.keystoneShortName_TazaveshSoleahsGambit, -- GAMBIT
	[391] = L.keystoneShortName_TazaveshStreetsOfWonder, -- STREET
	[505] = L.keystoneShortName_TheDawnbreaker, -- DAWN

	-- XXX remove below after 11.2 (and remove GetRealZoneText code from keystone tooltip)
	[1594] = L.keystoneShortName_TheMotherlode,
	[2097] = L.keystoneShortName_OperationMechagonWorkshop,
	[2293] = L.keystoneShortName_TheaterOfPain,
	[2648] = L.keystoneShortName_TheRookery,
	[2649] = L.keystoneShortName_PrioryOfTheSacredFlame,
	[2651] = L.keystoneShortName_DarkflameCleft,
	[2661] = L.keystoneShortName_CinderbrewMeadery,
	[2773] = L.keystoneShortName_OperationFloodgate,
}
local teleports = BigWigsLoader.isNext and {
	[2830] = 1237215, -- Eco-Dome Al'dani
	[2287] = 354465, -- Halls of Atonement
	[2660] = 445417, -- Ara-Kara, City of Echoes
	[2441] = 367416, -- Tazavesh, the Veiled Market
	[2662] = 445414, -- The Dawnbreaker
	[2649] = 445444, -- Priory of the Sacred Flame
	[2773] = 1216786, -- Operation: Floodgate
} or {
	[1594] = UnitFactionGroup("player") == "Alliance" and 467553 or 467555, -- The MOTHERLODE!!
	[2097] = 373274, -- Operation: Mechagon
	[2293] = 354467, -- Theater of Pain
	[2648] = 445443, -- The Rookery
	[2649] = 445444, -- Priory of the Sacred Flame
	[2651] = 445441, -- Darkflame Cleft
	[2661] = 445440, -- Cinderbrew Meadery
	[2773] = 1216786, -- Operation: Floodgate
}
local cellsCurrentlyShowing = {}
local cellsAvailable = {}
local RequestData
local prevTab = 1

local mainPanel = CreateFrame("Frame", nil, UIParent, "PortraitFrameFlatTemplate")
mainPanel:Hide()
mainPanel:SetSize(350, 320)
mainPanel:SetPoint("LEFT", 15, 0)
mainPanel:SetFrameStrata("DIALOG")
mainPanel:SetMovable(true)
mainPanel:EnableMouse(true)
mainPanel:RegisterForDrag("LeftButton")
mainPanel:SetTitle(L.keystoneTitle)
mainPanel:SetTitleOffsets(0, 0)
mainPanel:SetBorder("HeldBagLayout")
mainPanel:SetPortraitTextureSizeAndOffset(38, -5, 0)
mainPanel:SetPortraitTextureRaw("Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid.tga")
mainPanel:SetScript("OnDragStart", function(self)
	if prevTab == 3 and InCombatLockdown() then
		LoaderPublic.Print(L.youAreInCombat)
		return
	end
	self:StartMoving()
end)
mainPanel:SetScript("OnDragStop", function(self)
	if prevTab == 3 and InCombatLockdown() then
		LoaderPublic.Print(L.youAreInCombat)
		return
	end
	self:StopMovingOrSizing()
end)

local UpdateMyKeystone
do
	local GetMaxPlayerLevel = GetMaxPlayerLevel
	local GetWeeklyResetStartTime = C_DateAndTime.GetWeeklyResetStartTime
	local GetOwnedKeystoneLevel, GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneLevel, C_MythicPlus.GetOwnedKeystoneChallengeMapID
	local GetPlayerMythicPlusRatingSummary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary
	local GetRealmName = GetRealmName

	local myKeyLevel, myKeyMap, myRating = 0, 0, 0
	UpdateMyKeystone = function(_, event, id)
		if LoaderPublic.UnitLevel("player") ~= GetMaxPlayerLevel() or (event == "PLAYER_INTERACTION_MANAGER_FRAME_HIDE" and id ~= 3 and id ~= 49) then -- 3 = Gossip (key downgrade NPC), 49 = WeeklyRewards (vault)
			return
		end

		if type(BigWigs3DB.myKeystones) ~= "table" then
			BigWigs3DB.myKeystones = {}
		end
		local resetStart = GetWeeklyResetStartTime()
		if type(BigWigs3DB.prevWeeklyReset) ~= "number" or resetStart ~= BigWigs3DB.prevWeeklyReset then
			BigWigs3DB.prevWeeklyReset = resetStart
			BigWigs3DB.myKeystones = {}
		end

		local keyLevel = GetOwnedKeystoneLevel()
		if type(keyLevel) == "number" then
			myKeyLevel = keyLevel
		end
		-- Keystone instance ID
		local keyChallengeMapID = GetOwnedKeystoneChallengeMapID()
		if type(keyChallengeMapID) == "number" then
			myKeyMap = keyChallengeMapID
		end
		-- M+ rating
		local playerRatingSummary = GetPlayerMythicPlusRatingSummary("player")
		if type(playerRatingSummary) == "table" and type(playerRatingSummary.currentSeasonScore) == "number" then
			myRating = playerRatingSummary.currentSeasonScore
		end

		local guid = LoaderPublic.UnitGUID("player")
		local name = LoaderPublic.UnitName("player")
		local realm = GetRealmName()
		BigWigs3DB.myKeystones[guid] = {
			keyLevel = myKeyLevel,
			keyMap = myKeyMap,
			playerRating = myRating,
			specId = specs[name] or 0,
			name = name,
			realm = realm,
		}
	end
	mainPanel:SetScript("OnEvent", UpdateMyKeystone)
end
-- If only PLAYER_LOGOUT would work for keystone info, sigh :(
mainPanel:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE")
mainPanel:RegisterEvent("PLAYER_ENTERING_WORLD")

local tab1 = CreateFrame("Button", nil, mainPanel, "PanelTabButtonTemplate")
tab1:SetSize(50, 26)
tab1:SetPoint("BOTTOMLEFT", 10, -25)
tab1.Text:SetText(L.keystoneTabOnline)

local tab2 = CreateFrame("Button", nil, mainPanel, "PanelTabButtonTemplate")
tab2:SetSize(50, 26)
tab2:SetPoint("LEFT", tab1, "RIGHT", 4, 0)
tab2.Text:SetText(L.keystoneTabAlts)

local tab3 = CreateFrame("Button", nil, mainPanel, "PanelTabButtonTemplate")
tab3:SetSize(50, 26)
tab3:SetPoint("LEFT", tab2, "RIGHT", 4, 0)
tab3.Text:SetText(L.keystoneTabTeleports)

local function WipeCells()
	for cell in next, cellsCurrentlyShowing do
		cell:Hide()
		cell:ClearAllPoints()
		cellsAvailable[#cellsAvailable+1] = cell
	end
	cellsCurrentlyShowing = {}
end
mainPanel.CloseButton:SetScript("OnClick", function()
	if prevTab == 3 and InCombatLockdown() then
		LoaderPublic.Print(L.youAreInCombat)
		return
	end
	WipeCells()
	mainPanel:Hide()
end)

local scrollArea = CreateFrame("ScrollFrame", nil, mainPanel, "ScrollFrameTemplate")
scrollArea:SetPoint("TOPLEFT", mainPanel, "TOPLEFT", 8, -30)
scrollArea:SetPoint("BOTTOMRIGHT", mainPanel, "BOTTOMRIGHT", -24, 5)

local scrollChild = CreateFrame("Frame", nil, scrollArea)
scrollArea:SetScrollChild(scrollChild)
scrollChild:SetSize(scrollArea:GetWidth(), 320)
scrollChild:SetPoint("LEFT")

local partyHeader = scrollChild:CreateFontString(nil, nil, "GameFontNormalLarge")
partyHeader:SetPoint("TOP", scrollChild, "TOP", 0, -0)
partyHeader:SetText(L.keystoneHeaderParty)
partyHeader:SetJustifyH("CENTER")

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
	GameTooltip:SetText(L.keystoneRefreshParty)
	GameTooltip:Show()
end)
partyRefreshButton:SetScript("OnLeave", GameTooltip_Hide)

local guildHeader = scrollChild:CreateFontString(nil, nil, "GameFontNormalLarge")
guildHeader:SetText(L.keystoneHeaderGuild)
guildHeader:SetJustifyH("CENTER")

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
	GameTooltip:SetText(L.keystoneRefreshGuild)
	GameTooltip:Show()
end)
guildRefreshButton:SetScript("OnLeave", GameTooltip_Hide)

local OnEnterShowTooltip = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(self.tooltip)
	GameTooltip:Show()
end
local function CreateCell()
	local cell = cellsAvailable[#cellsAvailable]
	if cell then
		cellsAvailable[#cellsAvailable] = nil
		cell:Show()
		cellsCurrentlyShowing[cell] = true
		return cell
	else
		cell = CreateFrame("Frame", nil, scrollChild)
		cell:SetSize(20, 20)
		cell:SetScript("OnEnter", OnEnterShowTooltip)
		cell:SetScript("OnLeave", GameTooltip_Hide)

		cell.text = cell:CreateFontString(nil, nil, "GameFontNormal")
		cell.text:SetAllPoints(cell)
		cell.text:SetJustifyH("CENTER")

		local bg = cell:CreateTexture()
		bg:SetAllPoints(cell)
		bg:SetColorTexture(0, 0, 0, 0.6)

		cellsCurrentlyShowing[cell] = true
		return cell
	end
end

local teleportButtons = {}
for mapID, spellID in next, teleports do
	local button = CreateFrame("Button", nil, nil, "SecureActionButtonTemplate")
	teleportButtons[#teleportButtons+1] = button
	button.text = GetRealZoneText(mapID)
	button.spellID = spellID
	button:SetAttribute("type", "spell")
	button:SetAttribute("spell", spellID)
	button:Hide()
	button:SetSize(240, 20)
	--button:SetScript("OnEnter", OnEnterShowTooltip)
	--button:SetScript("OnLeave", GameTooltip_Hide)
	button:EnableMouse(true)
	button:RegisterForClicks("AnyDown", "AnyUp")

	local text = button:CreateFontString(nil, nil, "GameFontNormal")
	text:SetAllPoints(button)
	text:SetJustifyH("CENTER")
	text:SetText(button.text)

	button.bg = button:CreateTexture()
	button.bg:SetAllPoints(button)
	button.bg:SetColorTexture(0, 0, 0, 0.6)

	button.cdbar = button:CreateTexture()
	button.cdbar:SetPoint("TOPLEFT")
	button.cdbar:SetPoint("BOTTOMLEFT")
	button.cdbar:SetColorTexture(1, 1, 1, 0.6)
	button.cdbar:Hide()
end
table.sort(teleportButtons, function(buttonA, buttonB)
	return buttonA.text < buttonB.text
end)
for i = 2, #teleportButtons do
	teleportButtons[i]:SetPoint("TOP", teleportButtons[i-1], "BOTTOM", 0, -6)
end

tab1:SetScript("OnClick", function(self)
	if prevTab == 3 then
		if InCombatLockdown() then
			LoaderPublic.Print(L.youAreInCombat)
			return
		else
			teleportButtons[1]:ClearAllPoints()
			for i = 1, #teleportButtons do
				teleportButtons[i]:SetParent(nil)
				teleportButtons[i]:Hide()
			end
		end
	end
	prevTab = 1
	WipeCells()
	RequestData()

	partyHeader:SetText(L.keystoneHeaderParty)
	partyRefreshButton:Show()
	guildHeader:Show()
	guildRefreshButton:Show()

	-- Select tab 1
	self.Left:Hide()
	self.Middle:Hide()
	self.Right:Hide()
	self:Disable()
	self:SetDisabledFontObject(GameFontHighlightSmall)

	local offsetY = self.selectedTextY or -3
	if self.isTopTab then
		offsetY = -offsetY - 7
	end

	self.Text:SetPoint("CENTER", self, "CENTER", (self.selectedTextX or 0), offsetY)

	self.LeftActive:Show()
	self.MiddleActive:Show()
	self.RightActive:Show()

	-- Deselect tab 2
	tab2.Left:Show()
	tab2.Middle:Show()
	tab2.Right:Show()
	tab2:Enable()

	offsetY = tab2.deselectedTextY or 2
	if tab2.isTopTab then
		offsetY = -offsetY - 6
	end

	tab2.Text:SetPoint("CENTER", tab2, "CENTER", (tab2.deselectedTextX or 0), offsetY)

	tab2.LeftActive:Hide()
	tab2.MiddleActive:Hide()
	tab2.RightActive:Hide()

	-- Deselect tab 3
	tab3.Left:Show()
	tab3.Middle:Show()
	tab3.Right:Show()
	tab3:Enable()

	offsetY = tab3.deselectedTextY or 2
	if tab3.isTopTab then
		offsetY = -offsetY - 6
	end

	tab3.Text:SetPoint("CENTER", tab3, "CENTER", (tab3.deselectedTextX or 0), offsetY)

	tab3.LeftActive:Hide()
	tab3.MiddleActive:Hide()
	tab3.RightActive:Hide()

	PlaySound(841) -- SOUNDKIT.IG_CHARACTER_INFO_TAB
end)
tab2:SetScript("OnClick", function(self)
	if prevTab == 3 then
		if InCombatLockdown() then
			LoaderPublic.Print(L.youAreInCombat)
			return
		else
			teleportButtons[1]:ClearAllPoints()
			for i = 1, #teleportButtons do
				teleportButtons[i]:SetParent(nil)
				teleportButtons[i]:Hide()
			end
		end
	end
	prevTab = 2
	WipeCells()

	partyHeader:SetText(L.keystoneHeaderMyCharacters)
	partyRefreshButton:Hide()
	guildHeader:Hide()
	guildRefreshButton:Hide()

	-- Select tab 2
	self.Left:Hide()
	self.Middle:Hide()
	self.Right:Hide()
	self:Disable()
	self:SetDisabledFontObject(GameFontHighlightSmall)

	local offsetY = self.selectedTextY or -3
	if self.isTopTab then
		offsetY = -offsetY - 7
	end

	self.Text:SetPoint("CENTER", self, "CENTER", (self.selectedTextX or 0), offsetY)

	self.LeftActive:Show()
	self.MiddleActive:Show()
	self.RightActive:Show()

	-- Deselect tab 1
	tab1.Left:Show()
	tab1.Middle:Show()
	tab1.Right:Show()
	tab1:Enable()

	offsetY = tab1.deselectedTextY or 2
	if tab1.isTopTab then
		offsetY = -offsetY - 6
	end

	tab1.Text:SetPoint("CENTER", tab1, "CENTER", (tab1.deselectedTextX or 0), offsetY)

	tab1.LeftActive:Hide()
	tab1.MiddleActive:Hide()
	tab1.RightActive:Hide()

	-- Deselect tab 3
	tab3.Left:Show()
	tab3.Middle:Show()
	tab3.Right:Show()
	tab3:Enable()

	offsetY = tab3.deselectedTextY or 2
	if tab3.isTopTab then
		offsetY = -offsetY - 6
	end

	tab3.Text:SetPoint("CENTER", tab3, "CENTER", (tab3.deselectedTextX or 0), offsetY)

	tab3.LeftActive:Hide()
	tab3.MiddleActive:Hide()
	tab3.RightActive:Hide()

	-- Begin Display of alts
	UpdateMyKeystone()

	if BigWigs3DB.myKeystones then
		local sortedplayerList = {}
		for _, pData in next, BigWigs3DB.myKeystones do
			local decoratedName = nil
			local nameTooltip = pData.name .. " [" .. pData.realm .. "]"
			local specID = pData.specId
			if specID > 0 then
				local _, specName, _, specIcon, role, classFile, className = GetSpecializationInfoByID(specID)
				local color = C_ClassColor.GetClassColor(classFile):GenerateHexColor()
				decoratedName = format("|T%s:16:16:0:0:64:64:4:60:4:60|t%s|c%s%s|r", specIcon, roleIcons[role] or "", color, pData.name)
				nameTooltip = format("|c%s%s|r [%s] |A:classicon-%s:16:16|a%s |T%s:16:16:0:0:64:64:4:60:4:60|t%s %s%s", color, pData.name, pData.realm, classFile, className, specIcon, specName, roleIcons[role] or "", roleIcons[role] and _G[role] or "")
			end
			sortedplayerList[#sortedplayerList+1] = {
				name = pData.name, decoratedName = decoratedName, nameTooltip = nameTooltip,
				level = pData.keyLevel, levelTooltip = L.keystoneLevelTooltip:format(pData.keyLevel),
				map = dungeonNames[pData.keyMap] or pData.keyMap > 0 and pData.keyMap or "-", mapTooltip = L.keystoneMapTooltip:format(pData.keyMap > 1000 and GetRealZoneText(pData.keyMap) or pData.keyMap > 0 and GetMapUIInfo(pData.keyMap) or"-"),
				rating = pData.playerRating, ratingTooltip = L.keystoneRatingTooltip:format(pData.playerRating),
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
				cellLevel:SetPoint("TOPLEFT", partyHeader, "CENTER", 3, -12)
				cellMap:SetPoint("LEFT", cellLevel, "RIGHT", 6, 0)
				cellRating:SetPoint("LEFT", cellMap, "RIGHT", 6, 0)
			else
				cellName:SetPoint("TOP", prevName, "BOTTOM", 0, -6)
				cellLevel:SetPoint("TOP", prevLevel, "BOTTOM", 0, -6)
				cellMap:SetPoint("TOP", prevMap, "BOTTOM", 0, -6)
				cellRating:SetPoint("TOP", prevRating, "BOTTOM", 0, -6)
			end
			cellName:SetWidth(WIDTH_NAME)
			cellName.text:SetText(sortedplayerList[i].decoratedName or sortedplayerList[i].name)
			cellName.tooltip = sortedplayerList[i].nameTooltip
			cellLevel:SetWidth(WIDTH_LEVEL)
			cellLevel.text:SetText(sortedplayerList[i].level == -1 and hiddenIcon or sortedplayerList[i].level)
			cellLevel.tooltip = sortedplayerList[i].levelTooltip
			cellMap:SetWidth(WIDTH_MAP)
			cellMap.text:SetText(sortedplayerList[i].map)
			cellMap.tooltip = sortedplayerList[i].mapTooltip
			cellRating:SetWidth(WIDTH_RATING)
			cellRating.text:SetText(sortedplayerList[i].rating)
			cellRating.tooltip = sortedplayerList[i].ratingTooltip
			prevName, prevLevel, prevMap, prevRating = cellName, cellLevel, cellMap, cellRating

			if i == tableSize then
				-- Calculate scroll height
				local contentsHeight = partyHeader:GetTop() - prevName:GetBottom()
				local newHeight = 10 + contentsHeight + 10 -- 10 top padding + content + 10 bottom padding
				scrollChild:SetHeight(newHeight)
			end
		end
	end

	PlaySound(841) -- SOUNDKIT.IG_CHARACTER_INFO_TAB
end)
tab3:SetScript("OnClick", function(self)
	if InCombatLockdown() then
		LoaderPublic.Print(L.youAreInCombat)
		return
	end
	prevTab = 3
	WipeCells()

	partyHeader:SetText(L.keystoneTabTeleports)
	partyRefreshButton:Hide()
	guildHeader:Hide()
	guildRefreshButton:Hide()

	teleportButtons[1]:ClearAllPoints()
	teleportButtons[1]:SetPoint("TOP", scrollChild, "TOP", 0, -30)
	for i = 1, #teleportButtons do
		teleportButtons[i]:SetParent(scrollChild)
		teleportButtons[i]:Show()
		if not IsSpellKnown(teleportButtons[i].spellID) then
			teleportButtons[i].bg:SetColorTexture(1, 0, 0, 0.6)
		else
			teleportButtons[i].bg:SetColorTexture(0, 0, 0, 0.6)
			local cd = C_Spell.GetSpellCooldown(teleportButtons[i].spellID)
			if cd.startTime > 0 and cd.duration > 0 then
				local remaining = (cd.startTime + cd.duration) - GetTime()
				local percentage = remaining / cd.duration
				teleportButtons[i].cdbar:Show()
				teleportButtons[i].cdbar:SetWidth(percentage * teleportButtons[i]:GetWidth())
			else
				teleportButtons[i].cdbar:Hide()
			end
		end
	end

	-- Calculate scroll height
	local contentsHeight = partyHeader:GetTop() - teleportButtons[#teleportButtons]:GetBottom()
	local newHeight = 10 + contentsHeight + 10 -- 10 top padding + content + 10 bottom padding
	scrollChild:SetHeight(newHeight)

	-- Select tab 3
	self.Left:Hide()
	self.Middle:Hide()
	self.Right:Hide()
	self:Disable()
	self:SetDisabledFontObject(GameFontHighlightSmall)

	local offsetY = self.selectedTextY or -3
	if self.isTopTab then
		offsetY = -offsetY - 7
	end

	self.Text:SetPoint("CENTER", self, "CENTER", (self.selectedTextX or 0), offsetY)

	self.LeftActive:Show()
	self.MiddleActive:Show()
	self.RightActive:Show()

	-- Deselect tab 1
	tab1.Left:Show()
	tab1.Middle:Show()
	tab1.Right:Show()
	tab1:Enable()

	offsetY = tab1.deselectedTextY or 2
	if tab1.isTopTab then
		offsetY = -offsetY - 6
	end

	tab1.Text:SetPoint("CENTER", tab1, "CENTER", (tab1.deselectedTextX or 0), offsetY)

	tab1.LeftActive:Hide()
	tab1.MiddleActive:Hide()
	tab1.RightActive:Hide()

	-- Deselect tab 2
	tab2.Left:Show()
	tab2.Middle:Show()
	tab2.Right:Show()
	tab2:Enable()

	offsetY = tab2.deselectedTextY or 2
	if tab2.isTopTab then
		offsetY = -offsetY - 6
	end

	tab2.Text:SetPoint("CENTER", tab2, "CENTER", (tab2.deselectedTextX or 0), offsetY)

	tab2.LeftActive:Hide()
	tab2.MiddleActive:Hide()
	tab2.RightActive:Hide()

	PlaySound(841) -- SOUNDKIT.IG_CHARACTER_INFO_TAB
end)

SLASH_BigWigsTestKS1 = "/bwtemp" -- temp
function RequestData()
	partyList = {}
	guildList = {}
	mainPanel:Show()
	LibKeystone.Request("PARTY")
	LibSpec.RequestGuildSpecialization()
	C_Timer.After(0.1, function() LibKeystone.Request("GUILD") end)
	tab1:Click()
end
SlashCmdList.BigWigsTestKS = RequestData

local function UpdateCells(playerList, isGuildList)
	local sortedplayerList = {}
	for pName, pData in next, playerList do
		if not isGuildList or (isGuildList and not partyList[pName]) then
			local decoratedName = nil
			local nameTooltip = pName
			local specID = specs[pName]
			if specID then
				local _, specName, _, specIcon, role, classFile, className = GetSpecializationInfoByID(specID)
				local color = C_ClassColor.GetClassColor(classFile):GenerateHexColor()
				decoratedName = format("|T%s:16:16:0:0:64:64:4:60:4:60|t%s|c%s%s|r", specIcon, roleIcons[role] or "", color, gsub(pName, "%-.+", "*"))
				nameTooltip = format("|c%s%s|r |A:classicon-%s:16:16|a%s |T%s:16:16:0:0:64:64:4:60:4:60|t%s %s%s", color, pName, classFile, className, specIcon, specName, roleIcons[role] or "", roleIcons[role] and _G[role] or "")
			end
			sortedplayerList[#sortedplayerList+1] = {
				name = pName, decoratedName = decoratedName, nameTooltip = nameTooltip,
				level = pData[1], levelTooltip = L.keystoneLevelTooltip:format(pData[1] == -1 and L.keystoneHiddenTooltip or pData[1]),
				map = dungeonNames[pData[2]] or pData[2] > 0 and pData[2] or pData[2] == -1 and hiddenIcon or "-", mapTooltip = L.keystoneMapTooltip:format(pData[2] > 1000 and GetRealZoneText(pData[2]) or pData[2] > 0 and GetMapUIInfo(pData[2]) or pData[2] == -1 and L.keystoneHiddenTooltip or "-"),
				rating = pData[3], ratingTooltip = L.keystoneRatingTooltip:format(pData[3]),
			}
		end
	end
	-- Sort list by level descending, or by name if equal level
	table.sort(sortedplayerList, function(a, b)
		local firstLevel = a.level == -1 and 1 or a.level
		local secondLevel = b.level == -1 and 1 or b.level
		if firstLevel > secondLevel then
			return true
		elseif firstLevel == secondLevel then
			return a.name < b.name
		end
	end)

	local prevName, prevLevel, prevMap, prevRating = nil, nil, nil, nil
	local tableSize = #sortedplayerList
	for i = 1, tableSize do
		local cellName, cellLevel, cellMap, cellRating = CreateCell(), CreateCell(), CreateCell(), CreateCell()
		if i == 1 then
			cellName:SetPoint("RIGHT", cellLevel, "LEFT", -6, 0)
			cellLevel:SetPoint("TOPLEFT", isGuildList and guildHeader or partyHeader, "CENTER", 3, -12)
			cellMap:SetPoint("LEFT", cellLevel, "RIGHT", 6, 0)
			cellRating:SetPoint("LEFT", cellMap, "RIGHT", 6, 0)
		else
			cellName:SetPoint("TOP", prevName, "BOTTOM", 0, -6)
			cellLevel:SetPoint("TOP", prevLevel, "BOTTOM", 0, -6)
			cellMap:SetPoint("TOP", prevMap, "BOTTOM", 0, -6)
			cellRating:SetPoint("TOP", prevRating, "BOTTOM", 0, -6)
		end
		cellName:SetWidth(WIDTH_NAME)
		cellName.text:SetText(sortedplayerList[i].decoratedName or sortedplayerList[i].name)
		cellName.tooltip = sortedplayerList[i].nameTooltip
		cellLevel:SetWidth(WIDTH_LEVEL)
		cellLevel.text:SetText(sortedplayerList[i].level == -1 and hiddenIcon or sortedplayerList[i].level)
		cellLevel.tooltip = sortedplayerList[i].levelTooltip
		cellMap:SetWidth(WIDTH_MAP)
		cellMap.text:SetText(sortedplayerList[i].map)
		cellMap.tooltip = sortedplayerList[i].mapTooltip
		cellRating:SetWidth(WIDTH_RATING)
		cellRating.text:SetText(sortedplayerList[i].rating)
		cellRating.tooltip = sortedplayerList[i].ratingTooltip
		prevName, prevLevel, prevMap, prevRating = cellName, cellLevel, cellMap, cellRating

		if i == tableSize then
			-- Calculate scroll height
			local contentsHeight = partyHeader:GetTop() - prevName:GetBottom()
			local newHeight = 10 + contentsHeight + 10 -- 10 top padding + content + 10 bottom padding
			scrollChild:SetHeight(newHeight)
		end
	end

	if not isGuildList then
		guildHeader:ClearAllPoints()
		local y = 24 + tableSize*26
		guildHeader:SetPoint("TOP", partyHeader, "BOTTOM", 0, -y)
	end
end

LibKeystone.Register({}, function(keyLevel, keyMap, playerRating, playerName, channel)
	if channel == "PARTY" then
		partyList[playerName] = {keyLevel, keyMap, playerRating}

		if mainPanel:IsShown() and not tab1:IsEnabled() then
			WipeCells()
			UpdateCells(partyList)
			UpdateCells(guildList, true)
		end
	elseif channel == "GUILD" then
		guildList[playerName] = {keyLevel, keyMap, playerRating}

		if mainPanel:IsShown() and not tab1:IsEnabled() then
			WipeCells()
			UpdateCells(partyList)
			UpdateCells(guildList, true)
		end
	end
end)
