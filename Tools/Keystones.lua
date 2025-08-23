local L, BigWigsLoader, BigWigsAPI, db

--------------------------------------------------------------------------------
-- Saved Settings
--

local UpdateProfile, UpdateProfileFont, ResetInstanceKeys
do
	local _, tbl = ...
	BigWigsAPI = tbl.API
	L = BigWigsAPI:GetLocale("BigWigs")
	BigWigsLoader = tbl.loaderPublic

	local defaultVoice = "English: Amy"
	do
		local locale = GetLocale()
		if locale ~= "enUS" then
			defaultVoice = ("%s: Default (Female)"):format(locale)
		end
	end
	local validFramePoints = {
		["TOPLEFT"] = true, ["TOPRIGHT"] = true, ["BOTTOMLEFT"] = true, ["BOTTOMRIGHT"] = true,
		["TOP"] = true, ["BOTTOM"] = true, ["LEFT"] = true, ["RIGHT"] = true, ["CENTER"] = true,
	}

	local loc = GetLocale()
	local isWest = loc ~= "koKR" and loc ~= "zhCN" and loc ~= "zhTW" and true
	local fontName = isWest and "Noto Sans Regular" or LibStub("LibSharedMedia-3.0"):GetDefault("font")

	local defaults = {
		autoSlotKeystone = true,
		countVoice = defaultVoice,
		countBegin = 5,
		countStartSound = "BigWigs: Long",
		countEndSound = "BigWigs: Alarm",
		showViewerDungeonEnd = true,
		hideFromGuild = false,
		viewerKeybind = "",
		windowHeight = 320,
		viewerPosition = {"LEFT", "LEFT", 15, 0},
		instanceKeysPosition = {"BOTTOM", "TOP", 0, -86},
		instanceKeysFontName = fontName,
		instanceKeysFontSize = 16,
		instanceKeysMonochrome = false,
		instanceKeysGrowUpwards = false,
		instanceKeysOutline = "OUTLINE",
		instanceKeysAlign = "CENTER",
		instanceKeysColor = {1, 1, 1, 1},
		instanceKeysOtherDungeonColor = {1, 1, 1, 0.5},
		instanceKeysShowAllPlayers = false,
		instanceKeysShowDungeonEnd = false,
	}
	db = BigWigsLoader.db:RegisterNamespace("MythicPlus", {profile = defaults})

	function UpdateProfile()
		for k, v in next, db.profile do
			local defaultType = type(defaults[k])
			if defaultType == "nil" then
				db.profile[k] = nil
			elseif type(v) ~= defaultType then
				db.profile[k] = defaults[k]
			end
		end
		if db.profile.countBegin < 3 or db.profile.countBegin > 9 then
			db.profile.countBegin = defaults.countBegin
		end
		if db.profile.windowHeight < 320 or db.profile.windowHeight > 620 then
			db.profile.windowHeight = defaults.windowHeight
		end
		if type(db.profile.viewerPosition[1]) ~= "string" or type(db.profile.viewerPosition[2]) ~= "string"
		or type(db.profile.viewerPosition[3]) ~= "number" or type(db.profile.viewerPosition[4]) ~= "number"
		or not validFramePoints[db.profile.viewerPosition[1]] or not validFramePoints[db.profile.viewerPosition[2]] then
			db.profile.viewerPosition = defaults.viewerPosition
		else
			local x = math.floor(db.profile.viewerPosition[3]+0.5)
			if x ~= db.profile.viewerPosition[3] then
				db.profile.viewerPosition[3] = x
			end
			local y = math.floor(db.profile.viewerPosition[4]+0.5)
			if y ~= db.profile.viewerPosition[4] then
				db.profile.viewerPosition[4] = y
			end
		end
		if type(db.profile.instanceKeysPosition[1]) ~= "string" or type(db.profile.instanceKeysPosition[2]) ~= "string"
		or type(db.profile.instanceKeysPosition[3]) ~= "number" or type(db.profile.instanceKeysPosition[4]) ~= "number"
		or not validFramePoints[db.profile.instanceKeysPosition[1]] or not validFramePoints[db.profile.instanceKeysPosition[2]] then
			db.profile.instanceKeysPosition = defaults.instanceKeysPosition
		else
			local x = math.floor(db.profile.instanceKeysPosition[3]+0.5)
			if x ~= db.profile.instanceKeysPosition[3] then
				db.profile.instanceKeysPosition[3] = x
			end
			local y = math.floor(db.profile.instanceKeysPosition[4]+0.5)
			if y ~= db.profile.instanceKeysPosition[4] then
				db.profile.instanceKeysPosition[4] = y
			end
		end
		if db.profile.instanceKeysFontSize < 14 or db.profile.instanceKeysFontSize > 200 then
			db.profile.instanceKeysFontSize = defaults.instanceKeysFontSize
		end
		if db.profile.instanceKeysOutline ~= "NONE" and db.profile.instanceKeysOutline ~= "OUTLINE" and db.profile.instanceKeysOutline ~= "THICKOUTLINE" then
			db.profile.instanceKeysOutline = defaults.instanceKeysOutline
		end
		if db.profile.instanceKeysAlign ~= "LEFT" and db.profile.instanceKeysAlign ~= "CENTER" and db.profile.instanceKeysAlign ~= "RIGHT" then
			db.profile.instanceKeysAlign = defaults.instanceKeysAlign
		end
		for i = 1, 4 do
			local n = db.profile.instanceKeysColor[i]
			if type(n) ~= "number" or n < 0 or n > 1 then
				db.profile.instanceKeysColor = defaults.instanceKeysColor
				break -- If 1 entry is bad, reset the whole table
			end
		end
		if db.profile.instanceKeysColor[4] < 0.3 then -- Limit lowest alpha value
			db.profile.instanceKeysColor = defaults.instanceKeysColor
		end
		for i = 1, 4 do
			local n = db.profile.instanceKeysOtherDungeonColor[i]
			if type(n) ~= "number" or n < 0 or n > 1 then
				db.profile.instanceKeysOtherDungeonColor = defaults.instanceKeysOtherDungeonColor
				break -- If 1 entry is bad, reset the whole table
			end
		end
		if db.profile.instanceKeysOtherDungeonColor[4] < 0.3 then -- Limit lowest alpha value
			db.profile.instanceKeysOtherDungeonColor = defaults.instanceKeysOtherDungeonColor
		end
	end
	function UpdateProfileFont()
		if not LibStub("LibSharedMedia-3.0"):IsValid("font", db.profile.instanceKeysFontName) then
			db.profile.instanceKeysFontName = defaults.instanceKeysFontName
		end
	end
	UpdateProfile()

	function ResetInstanceKeys()
		db.profile.instanceKeysPosition = defaults.instanceKeysPosition
		db.profile.instanceKeysFontName = defaults.instanceKeysFontName
		db.profile.instanceKeysFontSize = defaults.instanceKeysFontSize
		db.profile.instanceKeysMonochrome = defaults.instanceKeysMonochrome
		db.profile.instanceKeysGrowUpwards = defaults.instanceKeysGrowUpwards
		db.profile.instanceKeysOutline = defaults.instanceKeysOutline
		db.profile.instanceKeysAlign = defaults.instanceKeysAlign
		db.profile.instanceKeysColor = defaults.instanceKeysColor
		db.profile.instanceKeysOtherDungeonColor = defaults.instanceKeysOtherDungeonColor
		db.profile.instanceKeysShowAllPlayers = defaults.instanceKeysShowAllPlayers
		db.profile.instanceKeysShowDungeonEnd = defaults.instanceKeysShowDungeonEnd
	end
end

--------------------------------------------------------------------------------
-- Data
--

local roleIcons = {
	TANK = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Role_Tank:16:16|t",
	HEALER = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Role_Healer:16:16|t",
	DAMAGER = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Role_Damage:16:16|t",
}
local hiddenIcon = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Private:16:16|t"
local dungeonNamesTiny = {
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
}
local dungeonNamesTrimmed = {
	[500] = L.keystoneShortName_TheRookery_Bar, -- ROOK
	[504] = L.keystoneShortName_DarkflameCleft_Bar, -- DFC
	[499] = L.keystoneShortName_PrioryOfTheSacredFlame_Bar, -- PRIORY
	[506] = L.keystoneShortName_CinderbrewMeadery_Bar, -- BREW
	[525] = L.keystoneShortName_OperationFloodgate_Bar, -- FLOOD
	[382] = L.keystoneShortName_TheaterOfPain_Bar, -- TOP
	[247] = L.keystoneShortName_TheMotherlode_Bar, -- ML
	[370] = L.keystoneShortName_OperationMechagonWorkshop_Bar, -- WORK
	[542] = L.keystoneShortName_EcoDomeAldani_Bar, -- ALDANI
	[378] = L.keystoneShortName_HallsOfAtonement_Bar, -- HOA
	[503] = L.keystoneShortName_AraKaraCityOfEchoes_Bar, -- ARAK
	[392] = L.keystoneShortName_TazaveshSoleahsGambit_Bar, -- GAMBIT
	[391] = L.keystoneShortName_TazaveshStreetsOfWonder_Bar, -- STREET
	[505] = L.keystoneShortName_TheDawnbreaker_Bar, -- DAWN
}
local dungeonMapWithMultipleKeys = {
	[2441] = true, -- Tazavesh, the Veiled Market
}
local teleportList = {
	-- Current Season (Built Automatically)
	{},
	-- The War Within
	{
		[2648] = 445443, -- The Rookery
		[2649] = 445444, -- Priory of the Sacred Flame
		[2651] = 445441, -- Darkflame Cleft
		[2652] = 445269, -- The Stonevault
		[2660] = 445417, -- Ara-Kara, City of Echoes
		[2661] = 445440, -- Cinderbrew Meadery
		[2662] = 445414, -- The Dawnbreaker
		[2669] = 445416, -- City of Threads
		[2773] = 1216786, -- Operation: Floodgate
		[2830] = 1237215, -- Eco-Dome Al'dani
	},
	-- Dragonflight
	{
		[2451] = 393222, -- Uldaman: Legacy of Tyr
		[2515] = 393279, -- The Azure Vault
		[2516] = 393262, -- The Nokhud Offensive
		[2519] = 393276, -- Neltharus
		[2520] = 393267, -- Brackenhide Hollow
		[2521] = 393256, -- Ruby Life Pools
		[2526] = 393273, -- Algeth'ar Academy
		[2527] = 393283, -- Halls of Infusion
		[2579] = 424197, -- Dawn of the Infinite
	},
	-- Shadowlands
	{
		[2284] = 354469, -- Sanguine Depths
		[2285] = 354466, -- Spires of Ascension
		[2286] = 354462, -- The Necrotic Wake
		[2287] = 354465, -- Halls of Atonement
		[2289] = 354463, -- Plaguefall
		[2290] = 354464, -- Mists of Tirna Scithe
		[2291] = 354468, -- De Other Side
		[2293] = 354467, -- Theater of Pain
		[2441] = 367416, -- Tazavesh, the Veiled Market
	},
	-- Battle for Azeroth
	{
		[1763] = 424187, -- Atal'Dazar
		[1754] = 410071, -- Freehold
		--[1762] = lw_bfa, -- King's Rest
		--[1864] = lw_bfa, -- Shrine of the Storm
		[1822] = UnitFactionGroup("player") == "Alliance" and 445418 or 464256, -- Siege of Boralus
		--[1877] = lw_bfa, -- Temple of Sethraliss
		[1594] = UnitFactionGroup("player") == "Alliance" and 467553 or 467555, -- The MOTHERLODE!!
		--[1771] = lw_bfa, -- Tol Dagor
		[1841] = 410074, -- The Underrot
		[1862] = 424167, -- Waycrest Manor
		[2097] = 373274, -- Operation: Mechagon
	},
	-- Legion
	{
		--[1544] = lw_l, -- Assault on Violet Hold
		--[1677] = lw_l, -- Cathedral of Eternal Night
		[1571] = 393766, -- Court of Stars
		[1651] = 373262, -- Return to Karazhan
		[1501] = 424153, -- Black Rook Hold
		--[1516] = lw_l, -- The Arcway
		[1466] = 424163, -- Darkheart Thicket
		[1458] = 410078, -- Neltharion's Lair
		--[1456] = lw_l, -- Eye of Azshara
		--[1492] = lw_l, -- Maw of Souls
		[1477] = 393764, -- Halls of Valor
		--[1493] = lw_l, -- Vault of the Wardens
		--[1753] = lw_l, -- Seat of the Triumvirate
	},
	-- Warlords of Draenor
	{
		[1209] = 159898, -- Skyreach
		[1176] = 159899, -- Shadowmoon Burial Grounds
		[1208] = 159900, -- Grimrail Depot
		[1279] = 159901, -- The Everbloom
		[1195] = 159896, -- Iron Docks
		[1182] = 159897, -- Auchindoun
		[1175] = 159895, -- Bloodmaul Slag Mines
		[1358] = 159902, -- Upper Blackrock Spire
	},
	-- Mists of Pandaria
	{
		[959] = 131206, -- Shado-Pan Monastery
		[960] = 131204, -- Temple of the Jade Serpent
		[961] = 131205, -- Stormstout Brewery
		[962] = 131225, -- Gate of the Setting Sun
		[994] = 131222, -- Mogu'shan Palace
		[1001] = 131231, -- Scarlet Halls
		[1007] = 131232, -- Scholomance
		[1011] = 131228, -- Siege of Niuzao Temple
		--[1112] = lw_mists, -- Pursuing the Black Harvest
		[1004] = 131229, -- Scarlet Monastery
	},
	-- Cataclysm
	{
		--[859] = lw_cata, -- Zul'Gurub
		[643] = 424142, -- Throne of the Tides
		--[644] = lw_cata, -- Halls of Origination
		--[645] = lw_cata, -- Blackrock Caverns
		--[755] = lw_cata, -- Lost City of the Tol'vir
		--[725] = lw_cata, -- The Stonecore
		--[938] = lw_cata, -- End Time
		--[939] = lw_cata, -- Well of Eternity
		--[940] = lw_cata, -- Hour of Twilight
		[657] = 410080, -- The Vortex Pinnacle
		[670] = 445424, -- Grim Batol
	},
}
for mapID in next, BigWigsLoader.currentExpansion.currentSeason do -- Automatically build the current season list
	for expansionIndex = 2, #teleportList do
		if teleportList[expansionIndex][mapID] then
			teleportList[1][mapID] = teleportList[expansionIndex][mapID]
			break
		end
	end
end

--------------------------------------------------------------------------------
-- Locals
--

local LibKeystone = LibStub("LibKeystone")
local LibSpec = LibStub("LibSpecialization")
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

local guildList, partyList = {}, {}
local WIDTH_NAME, WIDTH_LEVEL, WIDTH_MAP, WIDTH_RATING = 150, 24, 66, 42

local GetMapUIInfo = C_ChallengeMode.GetMapUIInfo

if db.profile.hideFromGuild then
	LibKeystone.SetGuildHidden(true)
end
local specializationPlayerList = {}
do
	local function addToTable(specID, _, _, playerName)
		specializationPlayerList[playerName] = specID
	end
	LibSpec.RegisterGroup(specializationPlayerList, addToTable)
	LibSpec.RegisterGuild(specializationPlayerList, addToTable)
end

--------------------------------------------------------------------------------
-- GUI Widgets
--

local cellsCurrentlyShowing = {}
local cellsAvailable = {}
local tab1, tab2

local mainPanel = CreateFrame("Frame", nil, UIParent, "PortraitFrameTemplate")
mainPanel:Hide()
mainPanel:SetSize(350, db.profile.windowHeight)
do
	local point, relPoint = db.profile.viewerPosition[1], db.profile.viewerPosition[2]
	local x, y = db.profile.viewerPosition[3], db.profile.viewerPosition[4]
	mainPanel:SetPoint(point, UIParent, relPoint, x, y)
end
mainPanel:SetFrameStrata("MEDIUM")
mainPanel:SetFixedFrameStrata(true)
mainPanel:SetFrameLevel(9500)
mainPanel:SetFixedFrameLevel(true)
mainPanel:SetClampedToScreen(true)
mainPanel:SetMovable(true)
mainPanel:EnableMouse(true)
mainPanel:RegisterForDrag("LeftButton")
mainPanel:SetTitle(L.keystoneTitle)
mainPanel:SetTitleOffsets(0, 0)
mainPanel:SetBorder("HeldBagLayout")
mainPanel:SetPortraitTextureSizeAndOffset(38, -5, 0)
mainPanel:SetPortraitTextureRaw("Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid.tga")
mainPanel:SetScript("OnDragStart", mainPanel.StartMoving)
mainPanel:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	local point, _, relPoint, x, y = self:GetPoint()
	x = math.floor(x+0.5)
	y = math.floor(y+0.5)
	db.profile.viewerPosition = {point, relPoint, x, y}
end)
mainPanel:SetResizable(true)
mainPanel:SetResizeBounds(350, 320, 350, 620)
do
	local function OnMouseDown(self)
		self:GetParent():StartSizing("BOTTOMRIGHT")
		GameTooltip_Hide()
	end
	local function OnMouseUp(self)
		local parent = self:GetParent()
		parent:StopMovingOrSizing()
		local height = parent:GetHeight()
		height = math.floor(height+0.5)
		db.profile.windowHeight = height
		parent:SetHeight(height)
	end

	local drag = CreateFrame("Frame", nil, mainPanel)
	drag:SetWidth(12)
	drag:SetHeight(12)
	drag:SetPoint("BOTTOMRIGHT", -3, 5)
	drag:EnableMouse(true)
	drag:SetScript("OnMouseDown", OnMouseDown)
	drag:SetScript("OnMouseUp", OnMouseUp)
	drag:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(L.dragToResize)
		GameTooltip:Show()
	end)
	drag:SetScript("OnLeave", GameTooltip_Hide)
	local tex = drag:CreateTexture(nil, "OVERLAY")
	tex:SetTexture("Interface\\AddOns\\BigWigs\\Media\\Icons\\draghandle")
	tex:SetAllPoints(drag)

	local text = mainPanel.TitleContainer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	text:SetJustifyH("RIGHT")
	text:SetText("/key")
	text:SetSize(50, 30)
	text:SetTextColor(0.65, 0.65, 0.65)
	text:SetPoint("RIGHT", -26, 0)
end

local UpdateMyKeystone
do
	local GetMaxPlayerLevel = GetMaxPlayerLevel
	local GetWeeklyResetStartTime = C_DateAndTime.GetWeeklyResetStartTime
	local GetOwnedKeystoneLevel, GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneLevel, C_MythicPlus.GetOwnedKeystoneChallengeMapID
	local GetPlayerMythicPlusRatingSummary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary
	local GetRealmName = GetRealmName

	local myKeyLevel, myKeyMap, myRating = 0, 0, 0
	UpdateMyKeystone = function(self, event, id, isReloadingUi)
		if event == "PLAYER_ENTERING_WORLD" then
			if id or isReloadingUi then
				if SLASH_KEYSTONE3 then
					SLASH_KEYSTONE3 = nil
				end
			end
			if BigWigsLoader.UnitLevel("player") ~= GetMaxPlayerLevel() then
				return
			end
		elseif event == "PLAYER_INTERACTION_MANAGER_FRAME_HIDE" and id ~= 3 and id ~= 49 then -- 3 = Gossip (key downgrade NPC), 49 = WeeklyRewards (vault)
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

		local guid = BigWigsLoader.UnitGUID("player")
		local name = BigWigsLoader.UnitName("player")
		local realm = GetRealmName()
		BigWigs3DB.myKeystones[guid] = {
			keyLevel = myKeyLevel,
			keyMap = myKeyMap,
			playerRating = myRating,
			specId = specializationPlayerList[name] or 0,
			name = name,
			realm = realm,
		}
	end
	mainPanel:SetScript("OnEvent", UpdateMyKeystone)
end
-- If only PLAYER_LOGOUT would work for keystone info, sigh :(
mainPanel:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE")
mainPanel:RegisterEvent("PLAYER_ENTERING_WORLD")

local function WipeCells()
	for cell in next, cellsCurrentlyShowing do
		cell:Hide()
		cell:ClearAttributes()
		cell.tooltip = nil
		cell:ClearAllPoints()
		cellsAvailable[#cellsAvailable+1] = cell
	end
	cellsCurrentlyShowing = {}
end
local headersAvailable = {}
local headersCurrentlyShowing = {}
local function WipeHeaders()
	for i = 1, #headersCurrentlyShowing do
		local header = headersCurrentlyShowing[i]
		header:Hide()
		header:ClearAllPoints()
		headersAvailable[#headersAvailable+1] = header
	end
	headersCurrentlyShowing = {}
end

local teleportButtons = {}
local UnregisterLibKeystone
mainPanel.CloseButton:SetScript("OnClick", function(self)
	UnregisterLibKeystone()
	self:UnregisterAllEvents()
	tab2:SetScript("OnUpdate", nil)
	WipeCells()
	WipeHeaders()
	mainPanel:Hide()
	tab1:Enable() -- Enable tab1 so :Click always works when we open the main panel again
end)
mainPanel.CloseButton:UnregisterAllEvents() -- Remove events registered by the template
mainPanel.CloseButton:SetScript("OnEvent", mainPanel.CloseButton.Click)

local scrollArea = CreateFrame("ScrollFrame", nil, mainPanel, "ScrollFrameTemplate")
scrollArea:SetPoint("TOPLEFT", mainPanel, "TOPLEFT", 8, -30)
scrollArea:SetPoint("BOTTOMRIGHT", mainPanel, "BOTTOMRIGHT", -24, 5)

local scrollChild = CreateFrame("Frame", nil, scrollArea)
scrollArea:SetScrollChild(scrollChild)
scrollChild:SetSize(scrollArea:GetWidth(), 320)
scrollChild:SetPoint("LEFT")

local partyRefreshButton = CreateFrame("Button", nil, scrollChild)
partyRefreshButton:Hide()
partyRefreshButton:SetSize(20, 20)
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

-- Refresh button for Guild section
local guildRefreshButton = CreateFrame("Button", nil, scrollChild)
guildRefreshButton:Hide()
guildRefreshButton:SetSize(20, 20)
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
	GameTooltip:SetOwner(self, "ANCHOR_TOP")
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
		cell = CreateFrame("Button", nil, scrollChild, "InsecureActionButtonTemplate")
		cell:SetSize(20, 20)
		cell:SetScript("OnEnter", OnEnterShowTooltip)
		cell:SetScript("OnLeave", GameTooltip_Hide)
		cell:RegisterForClicks("AnyDown", "AnyUp")

		cell.text = cell:CreateFontString(nil, nil, "GameFontNormal")
		cell.text:SetAllPoints(cell)
		cell.text:SetJustifyH("CENTER")

		local bg = cell:CreateTexture()
		bg:SetAllPoints(cell)
		bg:SetColorTexture(0, 0, 0, 0.6)
		cell.bg = bg

		cellsCurrentlyShowing[cell] = true
		return cell
	end
end
local function CreateHeader()
	local header = headersAvailable[#headersAvailable]
	if header then
		headersAvailable[#headersAvailable] = nil
		headersCurrentlyShowing[#headersCurrentlyShowing+1] = header
		header:Show()
		return header
	else
		header = scrollChild:CreateFontString(nil, nil, "GameFontNormalLarge")
		header:SetJustifyH("CENTER")
		headersCurrentlyShowing[#headersCurrentlyShowing+1] = header
		return header
	end
end

do
	local function OnEnter(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		if InCombatLockdown() then
			GameTooltip:SetText(L.keystoneTeleportInCombat)
		else
			local spellName = BigWigsLoader.GetSpellName(self.spellID)
			if not BigWigsLoader.IsSpellKnownOrInSpellBook(self.spellID) then
				GameTooltip:SetText(L.keystoneTeleportNotLearned:format(spellName))
			else
				local cd = BigWigsLoader.GetSpellCooldown(self.spellID)
				if cd.startTime > 0 and cd.duration > 0 then
					local remainingSeconds = (cd.startTime + cd.duration) - GetTime()
					local hours = math.floor(remainingSeconds / 3600)
					remainingSeconds = remainingSeconds % 3600
					local minutes = math.floor(remainingSeconds / 60)
					GameTooltip:SetText(L.keystoneTeleportOnCooldown:format(spellName, hours, minutes))
				else
					GameTooltip:SetText(L.keystoneTeleportReady:format(spellName))
				end
			end
		end
		GameTooltip:Show()
	end

	local GetRealZoneText = GetRealZoneText
	local prevButton = nil
	for expansionIndex = 1, #teleportList do
		if not teleportButtons[expansionIndex] then
			teleportButtons[expansionIndex] = {}
		end

		for mapID, spellID in next, teleportList[expansionIndex] do
			local button = CreateFrame("Button", nil, scrollChild, "InsecureActionButtonTemplate")
			teleportButtons[expansionIndex][#teleportButtons[expansionIndex]+1] = button
			button.text = GetRealZoneText(mapID)
			button.spellID = spellID
			button:SetAttribute("type", "spell")
			button:SetAttribute("spell", spellID)
			button:Hide()
			button:SetSize(90, 48)
			button:SetScript("OnEnter", OnEnter)
			button:SetScript("OnLeave", GameTooltip_Hide)
			button:RegisterForClicks("AnyDown", "AnyUp")
			button:SetHitRectInsets(-52, 0, 0, 0) -- Allow clicking the icon to work

			local text = button:CreateFontString(nil, nil, "GameFontNormal")
			text:SetPoint("CENTER")
			text:SetSize(86, 44) -- Button size minus 4
			text:SetJustifyH("CENTER")
			text:SetText(button.text)
			while text:IsTruncated() do -- For really long single words like "MOTHERLODE!!"
				text:SetTextScale(text:GetTextScale() - 0.01)
			end

			local icon = button:CreateTexture()
			icon:SetSize(48, 48)
			icon:SetPoint("RIGHT", button, "LEFT", -4, 0)
			local texture = BigWigsLoader.GetSpellTexture(spellID)
			icon:SetTexture(texture)
			icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
			button.icon = icon

			local bg = button:CreateTexture(nil, nil, nil, -5)
			bg:SetAllPoints(button)
			bg:SetColorTexture(0, 0, 0, 0.6)

			button.cdbar = button:CreateTexture(nil, nil, nil, 5)
			button.cdbar:SetPoint("TOPLEFT")
			button.cdbar:SetPoint("BOTTOMLEFT")
			button.cdbar:SetColorTexture(1, 1, 1, 0.6)
			button.cdbar:Hide()
		end
		table.sort(teleportButtons[expansionIndex], function(buttonA, buttonB)
			return buttonA.text < buttonB.text
		end)
		if expansionIndex > 1 then
			teleportButtons[expansionIndex][1]:SetPoint("TOP", prevButton, "BOTTOM", 0, -36)
		end
		for i = 2, #teleportButtons[expansionIndex] do
			if i % 2 == 0 then
				teleportButtons[expansionIndex][i]:SetPoint("LEFT", teleportButtons[expansionIndex][i-1], "RIGHT", 60, 0)
			else
				prevButton = teleportButtons[expansionIndex][i]
				prevButton:SetPoint("TOP", teleportButtons[expansionIndex][i-2], "BOTTOM", 0, -6)
			end
		end
	end
end

--------------------------------------------------------------------------------
-- GUI Tabs
--

local RegisterLibKeystone
do
	local function SelectTab(tab)
		tab2:SetScript("OnUpdate", nil)
		WipeCells()
		WipeHeaders()
		for expansionIndex = 1, #teleportButtons do
			local list = teleportButtons[expansionIndex]
			for i = 1, #list do
				list[i]:Hide()
			end
		end

		partyRefreshButton:ClearAllPoints()
		partyRefreshButton:Hide()
		guildRefreshButton:ClearAllPoints()
		guildRefreshButton:Hide()

		tab.Left:Hide()
		tab.Middle:Hide()
		tab.Right:Hide()
		tab:Disable()
		tab:SetDisabledFontObject(GameFontHighlightSmall)

		tab.Text:SetPoint("CENTER", tab, "CENTER", 0, -3)

		tab.LeftActive:Show()
		tab.MiddleActive:Show()
		tab.RightActive:Show()

		PlaySound(841) -- SOUNDKIT.IG_CHARACTER_INFO_TAB
	end
	local function DeselectTab(tab)
		tab.Left:Show()
		tab.Middle:Show()
		tab.Right:Show()
		tab:Enable()

		tab.Text:SetPoint("CENTER", tab, "CENTER", 0, 2)

		tab.LeftActive:Hide()
		tab.MiddleActive:Hide()
		tab.RightActive:Hide()
	end

	local tab3, tab4

	-- Tab 1 (Online)
	tab1 = CreateFrame("Button", nil, mainPanel, "PanelTabButtonTemplate")
	tab1:SetSize(50, 26)
	tab1:SetPoint("BOTTOMLEFT", 10, -25)
	tab1:SetClampedToScreen(true)
	tab1.Text:SetText(L.keystoneTabOnline)
	tab1:UnregisterAllEvents() -- Remove events registered by the template
	tab1:RegisterEvent("CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN")
	-- Tab 1 Event Handler (Used for auto slotting the keystone)
	do
		local HasSlottedKeystone, SlotKeystone = C_ChallengeMode.HasSlottedKeystone, C_ChallengeMode.SlotKeystone
		local GetOwnedKeystoneMapID = C_MythicPlus.GetOwnedKeystoneMapID
		local GetContainerNumSlots, GetContainerItemLink, PickupContainerItem = C_Container.GetContainerNumSlots, C_Container.GetContainerItemLink, C_Container.PickupContainerItem
		tab1:SetScript("OnEvent", function()
			if db.profile.autoSlotKeystone and not HasSlottedKeystone() then
				local _, _, _, _, _, _, _, instanceID = BigWigsLoader.GetInstanceInfo()
				if GetOwnedKeystoneMapID() == instanceID then
					for currentBag = 0, 4 do -- 0=Backpack, 1/2/3/4=Bags
						local slots = GetContainerNumSlots(currentBag)
						for currentSlot = 1, slots do
							local itemLink = GetContainerItemLink(currentBag, currentSlot)
							if itemLink and itemLink:find("Hkeystone", nil, true) then
								PickupContainerItem(currentBag, currentSlot)
								SlotKeystone()
								BigWigsLoader.Print(L.keystoneAutoSlotMessage:format(itemLink))
							end
						end
					end
				end
			end
		end)
	end
	-- Tab 1 Click Handler
	tab1:SetScript("OnClick", function(self)
		SelectTab(self)
		DeselectTab(tab2)
		DeselectTab(tab3)
		DeselectTab(tab4)

		local partyHeader = CreateHeader()
		partyHeader:SetText(L.keystoneHeaderParty)
		partyHeader:SetPoint("TOP", scrollChild, "TOP", 0, -0)
		partyRefreshButton:SetPoint("LEFT", partyHeader, "RIGHT", 5, 0)
		partyRefreshButton:Show()

		local guildHeader = CreateHeader()
		guildHeader:SetText(L.keystoneHeaderGuild)
		guildRefreshButton:SetPoint("LEFT", guildHeader, "RIGHT", 5, 0)
		guildRefreshButton:Show()

		mainPanel.CloseButton:RegisterEvent("PLAYER_LEAVING_WORLD") -- Hide when changing zone
		mainPanel.CloseButton:RegisterEvent("CHALLENGE_MODE_START") -- Hide when starting Mythic+
		mainPanel.CloseButton:RegisterEvent("PLAYER_REGEN_DISABLED") -- Hide when you enter combat

		partyList = {}
		guildList = {}
		RegisterLibKeystone()
		LibSpec.RequestGuildSpecialization()
		LibKeystone.Request("PARTY")
		C_Timer.After(0.2, function() LibKeystone.Request("GUILD") end)
	end)

	-- Tab 2 (Teleports)
	tab2 = CreateFrame("Button", nil, mainPanel, "PanelTabButtonTemplate")
	tab2:SetSize(50, 26)
	tab2:SetPoint("LEFT", tab1, "RIGHT", 4, 0)
	tab2:SetClampedToScreen(true)
	tab2.Text:SetText(L.keystoneTabTeleports)
	tab2:UnregisterAllEvents() -- Remove events registered by the template
	tab2:RegisterEvent("CHALLENGE_MODE_RESET")
	-- Tab 2 Event Handler (Used for handling the initial countdown)
	do
		local GetActiveKeystoneInfo, GetActiveChallengeMapID = C_ChallengeMode.GetActiveKeystoneInfo, C_ChallengeMode.GetActiveChallengeMapID
		tab2:SetScript("OnEvent", function(self, event)
			if event == "CHALLENGE_MODE_START" then
				local keyLevel = GetActiveKeystoneInfo()
				local challengeMapID = GetActiveChallengeMapID()
				local challengeMapName, _, _, icon = GetMapUIInfo(challengeMapID)
				BigWigsLoader:SendMessage("BigWigs_StartCountdown", self, nil, "mythicplus", 9, nil, db.profile.countVoice, 9, nil, db.profile.countBegin)
				if keyLevel and keyLevel > 0 then
					local msg = L.keystoneStartBar:format(dungeonNamesTrimmed[challengeMapID] or "?", keyLevel)
					BigWigsLoader:SendMessage("BigWigs_StartBar", nil, nil, msg, 9, icon)
					BigWigsLoader:SendMessage("BigWigs_Timer", nil, nil, 9, 9, msg, 0, icon, false, true)
				else
					BigWigsLoader:SendMessage("BigWigs_StartBar", nil, nil, L.keystoneModuleName, 9, icon)
					BigWigsLoader:SendMessage("BigWigs_Timer", nil, nil, 9, 9, L.keystoneModuleName, 0, icon, false, true)
				end
				BigWigsLoader.CTimerAfter(9, function()
					BigWigsLoader:SendMessage("BigWigs_Message", self, nil, L.keystoneStartBar:format(challengeMapName, keyLevel), "cyan", icon)
					BigWigsLoader.Print(L.keystoneStartMessage:format(challengeMapName, keyLevel))
					local soundName = db.profile.countEndSound
					if soundName ~= "None" then
						local sound = LibSharedMedia:Fetch("sound", soundName, true)
						if sound then
							BigWigsLoader.PlaySoundFile(sound)
						end
					end
				end)
				BigWigsLoader:SendMessage("BigWigs_Message", self, nil, BigWigsAPI:GetLocale("BigWigs: Common").custom_sec:format(L.keystoneStartBar:format(dungeonNamesTrimmed[challengeMapID], keyLevel), 9), "cyan", icon)
				local soundName = db.profile.countStartSound
				if soundName ~= "None" then
					local sound = LibSharedMedia:Fetch("sound", soundName, true)
					if sound then
						BigWigsLoader.PlaySoundFile(sound)
					end
				end
			else -- CHALLENGE_MODE_RESET
				local _, _, diffID = BigWigsLoader.GetInstanceInfo()
				if diffID == 8 then
					TimerTracker:UnregisterEvent("START_TIMER")
					BigWigsLoader.CTimerAfter(1, function()
						TimerTracker:RegisterEvent("START_TIMER")
						self:UnregisterEvent("CHALLENGE_MODE_START")
					end)
					self:RegisterEvent("CHALLENGE_MODE_START")
				end
			end
		end)
	end
	-- Tab 2 Click Handler
	do
		local UnitCastingInfo = UnitCastingInfo
		local function OnUpdate()
			local _, _, _, startTimeMs, endTimeMs, _, _, _, spellId = UnitCastingInfo("player")
			if spellId then
				for expansionIndex = 1, #teleportButtons do
					local list = teleportButtons[expansionIndex]
					for i = 1, #list do
						local button = list[i]
						if spellId == button.spellID then
							local startTimeSec = startTimeMs / 1000
							local endTimeSec = endTimeMs / 1000
							local castDuration = endTimeSec - startTimeSec
							if castDuration > 0 then
								local percentage = (GetTime() - startTimeSec) / castDuration
								if percentage > 1 then percentage = 1 elseif percentage < 0 then percentage = 0 end
								button.cdbar:SetColorTexture(0, 0, 1, 0.6)
								button.cdbar:Show()
								button.cdbar:SetWidth(percentage * button:GetWidth())
							else
								button.cdbar:Hide()
							end
						end
					end
				end
			else
				for expansionIndex = 1, #teleportButtons do
					local list = teleportButtons[expansionIndex]
					for i = 1, #list do
						local button = list[i]
						local cd = BigWigsLoader.GetSpellCooldown(button.spellID)
						if cd and cd.startTime > 0 and cd.duration > 2 and BigWigsLoader.IsSpellKnownOrInSpellBook(button.spellID) then
							local remaining = (cd.startTime + cd.duration) - GetTime()
							local percentage = remaining / cd.duration
							button.cdbar:SetColorTexture(1, 0, 0, 0.6)
							button.cdbar:Show()
							button.cdbar:SetWidth(percentage * button:GetWidth())
						else
							button.cdbar:Hide()
						end
					end
				end
			end
		end
		tab2:SetScript("OnClick", function(self)
			SelectTab(self)
			DeselectTab(tab1)
			DeselectTab(tab3)
			DeselectTab(tab4)

			local currentSeasonHeader = CreateHeader()
			currentSeasonHeader:SetText(L.littleWigsExtras.LittleWigs_CurrentSeason)
			currentSeasonHeader:SetPoint("TOP", scrollChild, "TOP", 0, -0)

			teleportButtons[1][1]:ClearAllPoints()
			teleportButtons[1][1]:SetPoint("TOPRIGHT", scrollChild, "TOP", 0, -40)
			self:SetScript("OnUpdate", OnUpdate)

			local numExpansions = #L.expansionNames
			for expansionIndex = 1, #teleportButtons do
				if expansionIndex > 1 then
					local expansionNameHeader = CreateHeader()
					expansionNameHeader:SetText(L.expansionNames[numExpansions - (expansionIndex - 2)])
					local distanceBetween = currentSeasonHeader:GetBottom() - teleportButtons[expansionIndex][1]:GetTop()
					expansionNameHeader:SetPoint("TOP", scrollChild, "TOP", 0, -(distanceBetween - 10))
				end
				local list = teleportButtons[expansionIndex]
				for i = 1, #list do
					local button = list[i]
					button:Show()
					button.cdbar:Hide()
					if not BigWigsLoader.IsSpellKnownOrInSpellBook(button.spellID) then
						button.icon:SetTexture(136813)
					else
						local texture = BigWigsLoader.GetSpellTexture(button.spellID)
						button.icon:SetTexture(texture)
					end
				end
			end

			-- Calculate scroll height
			local contentsHeight = currentSeasonHeader:GetTop() - teleportButtons[#teleportButtons][#teleportButtons[#teleportButtons]]:GetBottom() -- The bottom of the last teleport button
			local newHeight = 10 + contentsHeight + 10 -- 10 top padding + content + 10 bottom padding
			scrollChild:SetHeight(newHeight)
		end)
	end

	-- Tab 3 (Alts)
	tab3 = CreateFrame("Button", nil, mainPanel, "PanelTabButtonTemplate")
	tab3:SetSize(50, 26)
	tab3:SetPoint("LEFT", tab2, "RIGHT", 4, 0)
	tab3:SetClampedToScreen(true)
	tab3.Text:SetText(L.keystoneTabAlts)
	tab3:UnregisterAllEvents() -- Remove events registered by the template
	tab3:RegisterEvent("CHALLENGE_MODE_COMPLETED")
	-- Tab 3 Event Handler (Used for automatically showing the window when the dungeon ends)
	do
		local function Open() mainPanel:Show() tab1:Click() end
		tab3:SetScript("OnEvent", function()
			if db.profile.showViewerDungeonEnd and not BigWigsLoader.isTestBuild then
				BigWigsLoader.CTimerAfter(5, Open)
			end
		end)
	end
	-- Tab 3 Click Handler
	tab3:SetScript("OnClick", function(self)
		SelectTab(self)
		DeselectTab(tab1)
		DeselectTab(tab2)
		DeselectTab(tab4)

		local myCharactersHeader = CreateHeader()
		myCharactersHeader:SetText(L.keystoneHeaderMyCharacters)
		myCharactersHeader:SetPoint("TOP", scrollChild, "TOP", 0, -0)

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
					decoratedName = ("|T%s:16:16:0:0:64:64:4:60:4:60|t%s|c%s%s|r"):format(specIcon, roleIcons[role] or "", color, pData.name)
					nameTooltip = ("|c%s%s|r [%s] |A:classicon-%s:16:16|a%s |T%s:16:16:0:0:64:64:4:60:4:60|t%s %s%s"):format(color, pData.name, pData.realm, classFile, className, specIcon, specName, roleIcons[role] or "", roleIcons[role] and _G[role] or "")
				end
				local challengeMapName, _, _, _, _, mapID = GetMapUIInfo(pData.keyMap)
				sortedplayerList[#sortedplayerList+1] = {
					name = pData.name, decoratedName = decoratedName, nameTooltip = nameTooltip,
					level = pData.keyLevel, levelTooltip = L.keystoneLevelTooltip:format(pData.keyLevel),
					map = dungeonNamesTiny[pData.keyMap] or pData.keyMap > 0 and pData.keyMap or "-", mapTooltip = L.keystoneMapTooltip:format(challengeMapName or "-"), mapID = mapID,
					rating = pData.playerRating, ratingTooltip = L.keystoneRatingTooltip:format(pData.playerRating),
				}
			end
			-- Sort list by level descending, or by name if equal level
			table.sort(sortedplayerList, function(a, b)
				if a.level > b.level then
					return true
				elseif a.level == b.level then
					if a.rating ~= b.rating then -- If both levels are equal then sort by rating first, then sort by name
						return a.rating > b.rating
					else
						return a.name < b.name
					end
				end
			end)

			local prevName, prevLevel, prevMap, prevRating = nil, nil, nil, nil
			local tableSize = #sortedplayerList
			local _, _, _, _, _, _, _, instanceID = BigWigsLoader.GetInstanceInfo()
			for i = 1, tableSize do
				local cellName, cellLevel, cellMap, cellRating = CreateCell(), CreateCell(), CreateCell(), CreateCell()
				if i == 1 then
					cellName:SetPoint("RIGHT", cellLevel, "LEFT", -6, 0)
					cellLevel:SetPoint("TOPLEFT", myCharactersHeader, "CENTER", 3, -12)
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
					local contentsHeight = myCharactersHeader:GetTop() - prevName:GetBottom()
					local newHeight = 10 + contentsHeight + 10 -- 10 top padding + content + 10 bottom padding
					scrollChild:SetHeight(newHeight)
				end
			end
		end
	end)

	-- Tab 4 (History)
	tab4 = CreateFrame("Button", nil, mainPanel, "PanelTabButtonTemplate")
	tab4:SetSize(50, 26)
	tab4:SetPoint("LEFT", tab3, "RIGHT", 4, 0)
	tab4:SetClampedToScreen(true)
	tab4.Text:SetText(L.keystoneTabHistory)
	tab4:UnregisterAllEvents() -- Remove events registered by the template
	-- Tab 4 Click Handler
	tab4:SetScript("OnClick", function(self)
		SelectTab(self)
		DeselectTab(tab1)
		DeselectTab(tab2)
		DeselectTab(tab3)

		local thisWeekHeader = CreateHeader()
		thisWeekHeader:SetText(L.keystoneHeaderThisWeek)
		thisWeekHeader:SetPoint("TOP", scrollChild, "TOP", 0, -0)
		local olderHeader = CreateHeader()
		olderHeader:SetText(L.keystoneHeaderOlder)
		olderHeader:SetPoint("TOP", thisWeekHeader, "BOTTOM", 0, -50) -- Make sure the header shows even with no runs

		-- Begin Display of history
		local runs = C_MythicPlus.GetRunHistory(true, true)
		local tableSize = #runs
		local runsThisWeek, olderRuns = 0, 0
		local scoreThisWeek, olderScore = 0, 0
		local highestScoreByMap = {}
		for i = 1, tableSize do
			if not highestScoreByMap[runs[i].mapChallengeModeID] then
				highestScoreByMap[runs[i].mapChallengeModeID] = 0
			end
			if runs[i].runScore > highestScoreByMap[runs[i].mapChallengeModeID] then
				local diff = runs[i].runScore - highestScoreByMap[runs[i].mapChallengeModeID]
				highestScoreByMap[runs[i].mapChallengeModeID] = runs[i].runScore
				runs[i].gained = diff
				if runs[i].thisWeek then
					runsThisWeek = runsThisWeek + 1
					scoreThisWeek = scoreThisWeek + diff
				else
					olderRuns = olderRuns + 1
					olderScore = olderScore + diff
				end
			else
				runs[i].gained = 0
				if runs[i].thisWeek then
					runsThisWeek = runsThisWeek + 1
				else
					olderRuns = olderRuns + 1
				end
			end
		end

		local cellRunsThisWeek, cellScoreThisWeek = CreateCell(), CreateCell()
		cellRunsThisWeek:SetPoint("RIGHT", cellScoreThisWeek, "LEFT", -6, 0)
		cellScoreThisWeek:SetPoint("TOPLEFT", thisWeekHeader, "CENTER", 3, -12)
		cellRunsThisWeek:SetWidth(120)
		cellRunsThisWeek.text:SetText(L.keystoneHistoryRuns:format(runsThisWeek))
		cellRunsThisWeek.tooltip = L.keystoneHistoryRunsThisWeekTooltip:format(runsThisWeek)
		cellScoreThisWeek:SetWidth(120)
		cellScoreThisWeek.text:SetText(L.keystoneHistoryScore:format(scoreThisWeek))
		cellScoreThisWeek.tooltip = L.keystoneHistoryScoreThisWeekTooltip:format(scoreThisWeek)

		local cellRunsOlder, cellScoreOlder = CreateCell(), CreateCell()
		cellRunsOlder:SetPoint("RIGHT", cellScoreOlder, "LEFT", -6, 0)
		cellScoreOlder:SetPoint("TOPLEFT", olderHeader, "CENTER", 3, -12)
		cellRunsOlder:SetWidth(120)
		cellRunsOlder.text:SetText(L.keystoneHistoryRuns:format(olderRuns))
		cellRunsOlder.tooltip = L.keystoneHistoryRunsOlderTooltip:format(olderRuns)
		cellScoreOlder:SetWidth(120)
		cellScoreOlder.text:SetText(L.keystoneHistoryScore:format(olderScore))
		cellScoreOlder.tooltip = L.keystoneHistoryScoreOlderTooltip:format(olderScore)

		local firstOldRun = false
		local prevMapName, prevLevel, prevScore, prevGainedScore, prevInTime = nil, nil, nil, nil, nil
		for i = tableSize, 1, -1 do
			local cellMapName, cellLevel, cellScore, cellGainedScore, cellInTime = CreateCell(), CreateCell(), CreateCell(), CreateCell(), CreateCell()
			if runs[i].thisWeek then
				if i == tableSize then
					cellMapName:SetPoint("TOPLEFT", cellRunsThisWeek, "BOTTOMLEFT", 0, -12)
					cellLevel:SetPoint("LEFT", cellMapName, "RIGHT", 6, 0)
					cellScore:SetPoint("LEFT", cellLevel, "RIGHT", 6, 0)
					cellGainedScore:SetPoint("LEFT", cellScore, "RIGHT", 6, 0)
					cellInTime:SetPoint("LEFT", cellGainedScore, "RIGHT", 6, 0)
				else
					cellMapName:SetPoint("TOP", prevMapName, "BOTTOM", 0, -6)
					cellLevel:SetPoint("TOP", prevLevel, "BOTTOM", 0, -6)
					cellScore:SetPoint("TOP", prevScore, "BOTTOM", 0, -6)
					cellGainedScore:SetPoint("TOP", prevGainedScore, "BOTTOM", 0, -6)
					cellInTime:SetPoint("TOP", prevInTime, "BOTTOM", 0, -6)
				end
			else
				if not firstOldRun then
					firstOldRun = true
					if runsThisWeek == 0 then
						olderHeader:SetPoint("TOP", thisWeekHeader, "BOTTOM", 0, -50)
					else
						local y = 50 + runsThisWeek*26
						olderHeader:SetPoint("TOP", thisWeekHeader, "BOTTOM", 0, -y)
					end
					cellMapName:SetPoint("TOPLEFT", cellRunsOlder, "BOTTOMLEFT", 0, -12)
					cellLevel:SetPoint("LEFT", cellMapName, "RIGHT", 6, 0)
					cellScore:SetPoint("LEFT", cellLevel, "RIGHT", 6, 0)
					cellGainedScore:SetPoint("LEFT", cellScore, "RIGHT", 6, 0)
					cellInTime:SetPoint("LEFT", cellGainedScore, "RIGHT", 6, 0)
				else
					cellMapName:SetPoint("TOP", prevMapName, "BOTTOM", 0, -6)
					cellLevel:SetPoint("TOP", prevLevel, "BOTTOM", 0, -6)
					cellScore:SetPoint("TOP", prevScore, "BOTTOM", 0, -6)
					cellGainedScore:SetPoint("TOP", prevGainedScore, "BOTTOM", 0, -6)
					cellInTime:SetPoint("TOP", prevInTime, "BOTTOM", 0, -6)
				end
			end

			cellMapName:SetWidth(WIDTH_MAP+24)
			cellMapName.text:SetText(dungeonNamesTiny[runs[i].mapChallengeModeID] or runs[i].mapChallengeModeID)
			cellMapName.tooltip = L.keystoneMapTooltip:format(GetMapUIInfo(runs[i].mapChallengeModeID) or "-")
			cellLevel:SetWidth(WIDTH_LEVEL)
			cellLevel.text:SetText(runs[i].level)
			cellLevel.tooltip = L.keystoneLevelTooltip:format(runs[i].level)
			cellScore:SetWidth(WIDTH_RATING)
			cellScore.text:SetText(runs[i].runScore)
			cellScore.tooltip = L.keystoneScoreTooltip:format(runs[i].runScore)
			cellGainedScore:SetWidth(WIDTH_RATING)
			cellGainedScore.text:SetText("+".. runs[i].gained)
			cellGainedScore.tooltip = L.keystoneScoreGainedTooltip:format(runs[i].gained)
			cellInTime:SetWidth(WIDTH_LEVEL)
			cellInTime.text:SetText(runs[i].completed and "|T136814:0|t" or "|T136813:0|t")
			cellInTime.tooltip = runs[i].completed and L.keystoneCompletedTooltip or L.keystoneFailedTooltip
			prevMapName, prevLevel, prevScore, prevGainedScore, prevInTime = cellMapName, cellLevel, cellScore, cellGainedScore, cellInTime

			if i == 1 then
				-- Calculate scroll height
				local contentsHeight = thisWeekHeader:GetTop() - prevMapName:GetBottom()
				local newHeight = 10 + contentsHeight + 10 -- 10 top padding + content + 10 bottom padding
				scrollChild:SetHeight(newHeight)
			end
		end
	end)
end

do
	local function GetTeleportTextForSpellID(spellID)
		if spellID == 0 then
			return ""
		else
			local spellName = BigWigsLoader.GetSpellName(spellID)
			if not BigWigsLoader.IsSpellKnownOrInSpellBook(spellID) then
				return L.keystoneClickToTeleportNotLearned
			else
				local cd = BigWigsLoader.GetSpellCooldown(spellID)
				if cd.startTime > 0 and cd.duration > 0 then
					return L.keystoneClickToTeleportCooldown
				else
					return L.keystoneClickToTeleportNow
				end
			end
		end
	end

	local function SortTableByLevelThenRatingThenName(a, b)
		local firstLevel = a.level == -1 and 1 or a.level
		local secondLevel = b.level == -1 and 1 or b.level
		if firstLevel > secondLevel then
			return true
		elseif firstLevel == secondLevel then
			if a.rating ~= b.rating then -- If both levels are equal then sort by rating first, then sort by name
				return a.rating > b.rating
			else
				return a.name < b.name
			end
		end
	end

	local guildCellsCurrentlyShowing = {}
	local function UpdateCellsForOnlineTab(playerList, isGuildList)
		local sortedplayerList = {}
		for pName, pData in next, playerList do
			if not isGuildList or (isGuildList and not partyList[pName]) then
				local decoratedName = nil
				local nameTooltip = pName
				local specID = specializationPlayerList[pName]
				if specID then
					local _, specName, _, specIcon, role, classFile, className = GetSpecializationInfoByID(specID)
					local color = C_ClassColor.GetClassColor(classFile):GenerateHexColor()
					decoratedName = ("|T%s:16:16:0:0:64:64:4:60:4:60|t%s|c%s%s|r"):format(specIcon, roleIcons[role] or "", color, pName:gsub("%-.+", "*"))
					nameTooltip = ("|c%s%s|r |A:classicon-%s:16:16|a%s |T%s:16:16:0:0:64:64:4:60:4:60|t%s %s%s\n%s"):format(color, pName, classFile, className, specIcon, specName, roleIcons[role] or "", roleIcons[role] and _G[role] or "", L.keystoneClickToWhisper)
				end
				local challengeMapName, _, _, _, _, mapID = GetMapUIInfo(pData[2])
				local teleportSpellID = mapID and teleportList[1][mapID] or 0
				sortedplayerList[#sortedplayerList+1] = {
					name = pName, decoratedName = decoratedName, nameTooltip = nameTooltip,
					level = pData[1], levelTooltip = L.keystoneLevelTooltip:format(pData[1] == -1 and L.keystoneHiddenTooltip or pData[1]),
					map = pData[2] == -1 and hiddenIcon or dungeonNamesTiny[pData[2]] or "-",
					mapTooltip = L.keystoneMapTooltip:format(pData[2] == -1 and L.keystoneHiddenTooltip or challengeMapName or "-") .. GetTeleportTextForSpellID(teleportSpellID),
					mapID = mapID,
					rating = pData[3], ratingTooltip = L.keystoneRatingTooltip:format(pData[3]),
				}
			end
		end
		if #sortedplayerList == 0 then return end -- The guild list can be empty

		-- Sort list by level descending, or by name if equal level
		table.sort(sortedplayerList, SortTableByLevelThenRatingThenName)

		local prevName, prevLevel, prevMap, prevRating = nil, nil, nil, nil
		local tableSize = #sortedplayerList
		local _, _, _, _, _, _, _, instanceID = BigWigsLoader.GetInstanceInfo()
		for i = 1, tableSize do
			local cellName, cellLevel, cellMap, cellRating = CreateCell(), CreateCell(), CreateCell(), CreateCell()
			if i == 1 then
				cellName:SetPoint("RIGHT", cellLevel, "LEFT", -6, 0)
				cellLevel:SetPoint("TOPLEFT", isGuildList and headersCurrentlyShowing[2] or headersCurrentlyShowing[1], "CENTER", 3, -12)
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
			cellName:SetAttribute("type", "macro")
			cellName:SetAttribute("macrotext", "/run ChatFrame_SendTell(\"".. sortedplayerList[i].name .."\")")
			cellLevel:SetWidth(WIDTH_LEVEL)
			cellLevel.text:SetText(sortedplayerList[i].level == -1 and hiddenIcon or sortedplayerList[i].level)
			cellLevel.tooltip = sortedplayerList[i].levelTooltip
			cellMap:SetWidth(WIDTH_MAP)
			if sortedplayerList[i].mapID then
				cellMap:SetAttribute("type", "spell")
				cellMap:SetAttribute("spell", teleportList[1][sortedplayerList[i].mapID])
			end
			cellMap.text:SetText(sortedplayerList[i].map)
			cellMap.tooltip = sortedplayerList[i].mapTooltip
			cellRating:SetWidth(WIDTH_RATING)
			cellRating.text:SetText(sortedplayerList[i].rating)
			cellRating.tooltip = sortedplayerList[i].ratingTooltip
			prevName, prevLevel, prevMap, prevRating = cellName, cellLevel, cellMap, cellRating
			if isGuildList then
				local num = #guildCellsCurrentlyShowing
				guildCellsCurrentlyShowing[num+1] = cellName
				guildCellsCurrentlyShowing[num+2] = cellLevel
				guildCellsCurrentlyShowing[num+3] = cellMap
				guildCellsCurrentlyShowing[num+4] = cellRating
			end
		end

		-- Calculate scroll height
		local contentsHeight = headersCurrentlyShowing[1]:GetTop() - prevName:GetBottom()
		local newHeight = 10 + contentsHeight + 10 -- 10 top padding + content + 10 bottom padding
		scrollChild:SetHeight(newHeight)

		if not isGuildList then
			local y = 24 + tableSize*26
			headersCurrentlyShowing[2]:SetPoint("TOP", headersCurrentlyShowing[1], "BOTTOM", 0, -y)
		end
	end

	local function WipeGuildCells()
		for i = 1, #guildCellsCurrentlyShowing do
			local cell = guildCellsCurrentlyShowing[i]
			cell:Hide()
			cell.tooltip = nil
			cell:ClearAllPoints()
			cellsCurrentlyShowing[cell] = nil
			cellsAvailable[#cellsAvailable+1] = cell
		end
	end

	local function LibKeystoneFunction(keyLevel, keyMap, playerRating, playerName, channel)
		if channel == "PARTY" then
			if not partyList[playerName] or partyList[playerName][1] ~= keyLevel or partyList[playerName][2] ~= keyMap or partyList[playerName][3] ~= playerRating then
				partyList[playerName] = {keyLevel, keyMap, playerRating}

				if not tab1:IsEnabled() then -- Only if tab 1 (online) is showing
					WipeCells()
					guildCellsCurrentlyShowing = {}
					UpdateCellsForOnlineTab(partyList)
					UpdateCellsForOnlineTab(guildList, true)
				end
			end
		elseif channel == "GUILD" then
			if not guildList[playerName] or guildList[playerName][1] ~= keyLevel or guildList[playerName][2] ~= keyMap or guildList[playerName][3] ~= playerRating then
				guildList[playerName] = {keyLevel, keyMap, playerRating}

				if not tab1:IsEnabled() then -- Only if tab 1 (online) is showing
					WipeGuildCells()
					guildCellsCurrentlyShowing = {}
					UpdateCellsForOnlineTab(guildList, true)
				end
			end
		end
	end
	local LibKeystoneTable = {}
	function RegisterLibKeystone()
		LibKeystone.Register(LibKeystoneTable, LibKeystoneFunction)
	end
	function UnregisterLibKeystone()
		LibKeystone.Unregister(LibKeystoneTable)
	end
end

--------------------------------------------------------------------------------
-- Who has a key?
--

local instanceKeysWidgets = {testing = false, nameList = {}, playerListText = {}}
do
	local main = CreateFrame("Frame", nil, UIParent)
	main:SetSize(200, 40)
	do
		local point, relPoint = db.profile.instanceKeysPosition[1], db.profile.instanceKeysPosition[2]
		local x, y = db.profile.instanceKeysPosition[3], db.profile.instanceKeysPosition[4]
		main:SetPoint(point, UIParent, relPoint, x, y)
	end
	main:SetFrameStrata("MEDIUM")
	main:SetFixedFrameStrata(true)
	main:SetFrameLevel(9400)
	main:SetFixedFrameLevel(true)
	main:SetClampedToScreen(true)
	main:EnableMouse(false)
	main:SetMovable(false)
	main:RegisterForDrag("LeftButton")
	main:SetScript("OnDragStart", function(self)
		if self:IsMovable() then
			self:StartMoving()
		end
	end)
	main:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local point, _, relPoint, x, y = self:GetPoint()
		x = math.floor(x+0.5)
		y = math.floor(y+0.5)
		db.profile.instanceKeysPosition = {point, relPoint, x, y}
	end)
	instanceKeysWidgets.main = main

	local bg = main:CreateTexture()
	bg:SetAllPoints(main)
	bg:SetColorTexture(0, 0, 0, 0.3)
	bg:Hide()
	instanceKeysWidgets.bg = bg

	local header = main:CreateFontString()
	header:SetPoint(db.profile.instanceKeysAlign, 0, 0)
	header:SetJustifyH(db.profile.instanceKeysAlign)

	local flags = nil
	if db.profile.instanceKeysMonochrome and db.profile.instanceKeysOutline ~= "NONE" then
		flags = "MONOCHROME," .. db.profile.instanceKeysOutline
	elseif db.profile.instanceKeysMonochrome then
		flags = "MONOCHROME"
	elseif db.profile.instanceKeysOutline ~= "NONE" then
		flags = db.profile.instanceKeysOutline
	end
	header:SetFont(LibSharedMedia:Fetch("font", db.profile.instanceKeysFontName), db.profile.instanceKeysFontSize, flags)
	header:SetFormattedText("|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|t%s", L.instanceKeysTitle)
	header:SetTextColor(db.profile.instanceKeysColor[1], db.profile.instanceKeysColor[2], db.profile.instanceKeysColor[3], db.profile.instanceKeysColor[4])
	instanceKeysWidgets.header = header

	for i = 1, 5 do
		local playerListText = main:CreateFontString()
		if db.profile.instanceKeysGrowUpwards then
			playerListText:SetJustifyV("BOTTOM")
			playerListText:SetPoint(
				db.profile.instanceKeysAlign == "LEFT" and "BOTTOMLEFT" or db.profile.instanceKeysAlign == "RIGHT" and "BOTTOMRIGHT" or "BOTTOM", i == 1 and header or instanceKeysWidgets.playerListText[i-1],
				db.profile.instanceKeysAlign == "LEFT" and "TOPLEFT" or db.profile.instanceKeysAlign == "RIGHT" and "TOPRIGHT" or "TOP", 0, 6
			)
		else
			playerListText:SetJustifyV("TOP")
			playerListText:SetPoint(
				db.profile.instanceKeysAlign == "LEFT" and "TOPLEFT" or db.profile.instanceKeysAlign == "RIGHT" and "TOPRIGHT" or "TOP", i == 1 and header or instanceKeysWidgets.playerListText[i-1],
				db.profile.instanceKeysAlign == "LEFT" and "BOTTOMLEFT" or db.profile.instanceKeysAlign == "RIGHT" and "BOTTOMRIGHT" or "BOTTOM", 0, -6
			)
		end
		playerListText:SetJustifyH(db.profile.instanceKeysAlign)
		playerListText:SetTextColor(db.profile.instanceKeysColor[1], db.profile.instanceKeysColor[2], db.profile.instanceKeysColor[3], db.profile.instanceKeysColor[4])
		playerListText:SetFont(LibSharedMedia:Fetch("font", db.profile.instanceKeysFontName), db.profile.instanceKeysFontSize, flags)
		playerListText:SetText(" ")
		instanceKeysWidgets.playerListText[i] = playerListText
	end

	main:Hide()

	local function SortTableByLevelThenName(a, b)
		local firstLevel = a.level == -1 and 1 or a.level
		local secondLevel = b.level == -1 and 1 or b.level
		if firstLevel < secondLevel then
			return true
		elseif firstLevel == secondLevel then
			return a.name < b.name
		end
	end
	local currentInstanceID = nil
	local function ReceivePartyData(keyLevel, keyMap, _, playerName, channel)
		if channel == "PARTY" and (not instanceKeysWidgets.nameList[playerName] or instanceKeysWidgets.nameList[playerName][1] ~= keyLevel or instanceKeysWidgets.nameList[playerName][2] ~= keyMap) then
			local _, classFile = UnitClass(playerName)
			local color = classFile and C_ClassColor.GetClassColor(classFile):GenerateHexColor() or "FFFFFFFF"
			local decoratedName
			local _, _, _, _, _, keyMapInstanceID = GetMapUIInfo(keyMap)
			if dungeonMapWithMultipleKeys[keyMapInstanceID] or (db.profile.instanceKeysShowAllPlayers and keyMapInstanceID ~= currentInstanceID) then
				decoratedName = L.instanceKeysDisplayWithDungeon:format(color, playerName:gsub("%-.+", ""), keyLevel, dungeonNamesTrimmed[keyMap] or keyMap)
			else
				decoratedName = L.instanceKeysDisplay:format(color, playerName:gsub("%-.+", ""), keyLevel)
			end
			instanceKeysWidgets.nameList[playerName] = {keyLevel, keyMap, decoratedName}

			local sortedPlayerList = {}
			for pName, pData in next, instanceKeysWidgets.nameList do
				if UnitInParty(pName) then -- Safety check, in case we're forming a group inside a dungeon and people keep leaving
					local _, _, _, _, _, playerMapInstanceID = GetMapUIInfo(pData[2])
					local inCurrentDungeon = playerMapInstanceID == currentInstanceID
					if inCurrentDungeon or db.profile.instanceKeysShowAllPlayers then
						main:RegisterEvent("PLAYER_LEAVING_WORLD") -- Hide when changing zone
						main:RegisterEvent("CHALLENGE_MODE_START") -- Hide when starting Mythic+
						main:RegisterEvent("PLAYER_REGEN_DISABLED") -- Hide when you enter combat
						main:Show()
						sortedPlayerList[#sortedPlayerList+1] = {name = pName, decoratedName = pData[3], level = pData[1], inCurrentDungeon = inCurrentDungeon}
					end
				end
			end

			table.sort(sortedPlayerList, SortTableByLevelThenName)
			local namesToShow, otherDungeons = {}, {false, false, false, false, false}
			for i = 1, 5 do
				local name = sortedPlayerList[i] and sortedPlayerList[i].decoratedName
				if name then
					namesToShow[#namesToShow+1] = name
					if not sortedPlayerList[i].inCurrentDungeon then
						otherDungeons[i] = true
						if not instanceKeysWidgets.testing then
							instanceKeysWidgets.playerListText[i]:SetTextColor(db.profile.instanceKeysOtherDungeonColor[1], db.profile.instanceKeysOtherDungeonColor[2], db.profile.instanceKeysOtherDungeonColor[3], db.profile.instanceKeysOtherDungeonColor[4])
							instanceKeysWidgets.playerListText[i]:SetText(name)
						end
					elseif not instanceKeysWidgets.testing then
						instanceKeysWidgets.playerListText[i]:SetTextColor(db.profile.instanceKeysColor[1], db.profile.instanceKeysColor[2], db.profile.instanceKeysColor[3], db.profile.instanceKeysColor[4])
						instanceKeysWidgets.playerListText[i]:SetText(name)
					end
				elseif not instanceKeysWidgets.testing then
					instanceKeysWidgets.playerListText[i]:SetText(" ")
				end
			end
			if namesToShow[1] then
				instanceKeysWidgets.namesToShow = namesToShow
				instanceKeysWidgets.otherDungeons = otherDungeons
			else
				instanceKeysWidgets.namesToShow = nil
				instanceKeysWidgets.otherDungeons = nil
				if not instanceKeysWidgets.testing then
					instanceKeysWidgets.main:Hide()
				end
			end
		end
	end
	local whosKeyTable = {}
	local function Delay() -- Difficulty info isn't accurate until 1 frame after PEW
		local _, _, diffID, _, _, _, _, instanceID = BigWigsLoader.GetInstanceInfo()
		if diffID == 23 then
			instanceKeysWidgets.namesToShow = nil
			instanceKeysWidgets.otherDungeons = nil
			instanceKeysWidgets.nameList = {}
			currentInstanceID = instanceID
			UpdateProfileFont() -- We delay this to allow enough time for other addons to register their fonts into LSM
			local fontFlags = nil
			if db.profile.instanceKeysMonochrome and db.profile.instanceKeysOutline ~= "NONE" then
				fontFlags = "MONOCHROME," .. db.profile.instanceKeysOutline
			elseif db.profile.instanceKeysMonochrome then
				fontFlags = "MONOCHROME"
			elseif db.profile.instanceKeysOutline ~= "NONE" then
				fontFlags = db.profile.instanceKeysOutline
			end
			header:SetFont(LibSharedMedia:Fetch("font", db.profile.instanceKeysFontName), db.profile.instanceKeysFontSize, fontFlags)
			for i = 1, 5 do
				instanceKeysWidgets.playerListText[i]:SetFont(LibSharedMedia:Fetch("font", db.profile.instanceKeysFontName), db.profile.instanceKeysFontSize, fontFlags)
			end
			main:RegisterEvent("CHALLENGE_MODE_COMPLETED")
			LibKeystone.Register(whosKeyTable, ReceivePartyData)
			LibKeystone.Request("PARTY")
		end
	end
	main:SetScript("OnEvent", function(self, event)
		if instanceKeysWidgets.testing then
			instanceKeysWidgets.testing = false
			instanceKeysWidgets.main:Hide()
			instanceKeysWidgets.main:EnableMouse(false)
			instanceKeysWidgets.main:SetMovable(false)
			instanceKeysWidgets.bg:Hide()
		end
		if event == "PLAYER_ENTERING_WORLD" then
			BigWigsLoader.CTimerAfter(0, Delay)
		elseif event == "CHALLENGE_MODE_COMPLETED" then
			if db.profile.instanceKeysShowDungeonEnd then
				BigWigsLoader.CTimerAfter(5, Delay)
			end
		else
			LibKeystone.Unregister(whosKeyTable)
			self:Hide()
			instanceKeysWidgets.nameList = {}
			instanceKeysWidgets.namesToShow = nil
			instanceKeysWidgets.otherDungeons = nil
			self:UnregisterEvent("PLAYER_LEAVING_WORLD")
			self:UnregisterEvent("CHALLENGE_MODE_START")
			self:UnregisterEvent("CHALLENGE_MODE_COMPLETED")
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
	end)
	main:RegisterEvent("PLAYER_ENTERING_WORLD")
end

--------------------------------------------------------------------------------
-- Options Table
--

do
	local viewerKeybindFrame = CreateFrame("Button", "BWViewerKeybindFrame")
	viewerKeybindFrame:SetSize(1, 1)
	viewerKeybindFrame:Hide()

	local function UpdateWidgets()
		LibKeystone.SetGuildHidden(db.profile.hideFromGuild)
		mainPanel:ClearAllPoints()
		do
			local point, relPoint = db.profile.viewerPosition[1], db.profile.viewerPosition[2]
			local x, y = db.profile.viewerPosition[3], db.profile.viewerPosition[4]
			mainPanel:SetPoint(point, UIParent, relPoint, x, y)
		end
		mainPanel:SetSize(350, db.profile.windowHeight)

		local fontFlags = nil
		if db.profile.instanceKeysMonochrome and db.profile.instanceKeysOutline ~= "NONE" then
			fontFlags = "MONOCHROME," .. db.profile.instanceKeysOutline
		elseif db.profile.instanceKeysMonochrome then
			fontFlags = "MONOCHROME"
		elseif db.profile.instanceKeysOutline ~= "NONE" then
			fontFlags = db.profile.instanceKeysOutline
		end

		instanceKeysWidgets.header:SetJustifyH(db.profile.instanceKeysAlign)
		instanceKeysWidgets.header:ClearAllPoints()
		instanceKeysWidgets.header:SetPoint(db.profile.instanceKeysAlign, 0, 0)
		instanceKeysWidgets.header:SetFont(LibSharedMedia:Fetch("font", db.profile.instanceKeysFontName), db.profile.instanceKeysFontSize, fontFlags)
		instanceKeysWidgets.header:SetTextColor(db.profile.instanceKeysColor[1], db.profile.instanceKeysColor[2], db.profile.instanceKeysColor[3], db.profile.instanceKeysColor[4])
		for i = 1, 5 do
			instanceKeysWidgets.playerListText[i]:SetJustifyH(db.profile.instanceKeysAlign)
			instanceKeysWidgets.playerListText[i]:ClearAllPoints()
			if db.profile.instanceKeysGrowUpwards then
				instanceKeysWidgets.playerListText[i]:SetJustifyV("BOTTOM")
				instanceKeysWidgets.playerListText[i]:SetPoint(
					db.profile.instanceKeysAlign == "LEFT" and "BOTTOMLEFT" or db.profile.instanceKeysAlign == "RIGHT" and "BOTTOMRIGHT" or "BOTTOM", i == 1 and instanceKeysWidgets.header or instanceKeysWidgets.playerListText[i-1],
					db.profile.instanceKeysAlign == "LEFT" and "TOPLEFT" or db.profile.instanceKeysAlign == "RIGHT" and "TOPRIGHT" or "TOP", 0, 6
				)
			else
				instanceKeysWidgets.playerListText[i]:SetJustifyV("TOP")
				instanceKeysWidgets.playerListText[i]:SetPoint(
					db.profile.instanceKeysAlign == "LEFT" and "TOPLEFT" or db.profile.instanceKeysAlign == "RIGHT" and "TOPRIGHT" or "TOP", i == 1 and instanceKeysWidgets.header or instanceKeysWidgets.playerListText[i-1],
					db.profile.instanceKeysAlign == "LEFT" and "BOTTOMLEFT" or db.profile.instanceKeysAlign == "RIGHT" and "BOTTOMRIGHT" or "BOTTOM", 0, -6
				)
			end
			instanceKeysWidgets.playerListText[i]:SetFont(LibSharedMedia:Fetch("font", db.profile.instanceKeysFontName), db.profile.instanceKeysFontSize, fontFlags)
			instanceKeysWidgets.playerListText[i]:SetTextColor(db.profile.instanceKeysColor[1], db.profile.instanceKeysColor[2], db.profile.instanceKeysColor[3], db.profile.instanceKeysColor[4])
			if not instanceKeysWidgets.testing and instanceKeysWidgets.namesToShow and instanceKeysWidgets.namesToShow[i] and instanceKeysWidgets.otherDungeons[i] then
				instanceKeysWidgets.playerListText[i]:SetTextColor(db.profile.instanceKeysOtherDungeonColor[1], db.profile.instanceKeysOtherDungeonColor[2], db.profile.instanceKeysOtherDungeonColor[3], db.profile.instanceKeysOtherDungeonColor[4])
			end
		end

		instanceKeysWidgets.main:ClearAllPoints()
		do
			local point, relPoint = db.profile.instanceKeysPosition[1], db.profile.instanceKeysPosition[2]
			local x, y = db.profile.instanceKeysPosition[3], db.profile.instanceKeysPosition[4]
			instanceKeysWidgets.main:SetPoint(point, UIParent, relPoint, x, y)
		end

		if instanceKeysWidgets.testing then
			instanceKeysWidgets.playerListText[1]:SetText(L.instanceKeysTest8)
			instanceKeysWidgets.playerListText[2]:SetText(L.instanceKeysTest10)
			for i = 3, 5 do
				instanceKeysWidgets.playerListText[i]:SetText("")
			end
		end

		if not InCombatLockdown() then
			ClearOverrideBindings(viewerKeybindFrame)
			if db.profile.viewerKeybind ~= "" then
				SetOverrideBindingClick(viewerKeybindFrame, true, db.profile.viewerKeybind, "BWViewerKeybindFrame")
			end
		else
			viewerKeybindFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
	end

	local function voiceSorting()
		local list = BigWigsAPI.GetCountdownList()
		local sorted = {}
		for k in next, list do
			if k ~= "none" and k ~= "simple" then
				sorted[#sorted + 1] = k
			end
		end
		table.sort(sorted, function(a, b) return list[a] < list[b] end)
		table.insert(sorted, 1, "none")
		table.insert(sorted, 2, "simple")
		return sorted
	end

	local function soundGet(info)
		for i, v in next, LibSharedMedia:List("sound") do
			if v == db.profile[info[#info]] then
				return i
			end
		end
	end
	local function soundSet(info, value)
		db.profile[info[#info]] = LibSharedMedia:List("sound")[value]
	end

	local function ShowViewer()
		if not mainPanel:IsShown() then
			mainPanel:Show()
			tab1:Click()
		else
			mainPanel.CloseButton:Click()
		end
	end

	BigWigsLoader:RegisterMessage("BigWigs_ProfileUpdate", function()
		UpdateProfile()
		UpdateProfileFont()
		UpdateWidgets()
	end)

	BigWigsAPI.RegisterSlashCommand("/key", ShowViewer)
	BigWigsAPI.RegisterSlashCommand("/bwkey", ShowViewer)

	viewerKeybindFrame:SetScript("OnClick", ShowViewer)
	if db.profile.viewerKeybind ~= "" then
		SetOverrideBindingClick(viewerKeybindFrame, true, db.profile.viewerKeybind, "BWViewerKeybindFrame")
	end
	viewerKeybindFrame:SetScript("OnEvent", function(self, event)
		self:UnregisterEvent(event)
		ClearOverrideBindings(self)
		if db.profile.viewerKeybind ~= "" then
			SetOverrideBindingClick(self, true, db.profile.viewerKeybind, "BWViewerKeybindFrame")
		end
	end)

	local function GetSettings(info)
		return db.profile[info[#info]]
	end
	local function UpdateSettings(info, value)
		local key = info[#info]
		db.profile[key] = value
	end
	local function UpdateSettingsAndWidgets(info, value)
		local key = info[#info]
		db.profile[key] = value
		UpdateWidgets()
	end
	local function GetColor(info)
		local colorTable = db.profile[info[#info]]
		return colorTable[1], colorTable[2], colorTable[3], colorTable[4]
	end
	local function UpdateColorAndWidgets(info, r, g, b, a)
		local key = info[#info]
		db.profile[key] = {r, g, b, a < 0.3 and 0.3 or a}
		UpdateWidgets()
	end
	BigWigsAPI.SetToolOptionsTable("MythicPlus", {
		type = "group",
		childGroups = "tab",
		name = L.keystoneModuleName,
		get = GetSettings,
		set = UpdateSettings,
		args = {
			explainer = {
				type = "description",
				name = L.keystoneExplainer,
				order = 0,
				width = "full",
				fontSize = "large",
			},
			general = {
				type = "group",
				name = L.general,
				order = 1,
				args = {
					autoSlotKeystone = {
						type = "toggle",
						name = L.keystoneAutoSlot,
						desc = L.keystoneAutoSlotDesc,
						order = 1,
						width = "full",
					},
					spacer = {
						type = "description",
						name = "\n\n",
						order = 2,
						width = "full",
					},
					countdown = {
						type = "group",
						name = L.countdown,
						order = 3,
						inline = true,
						width = "full",
						args = {
							countdownExplainer = {
								type = "description",
								name = L.keystoneCountdownExplainer,
								order = 1,
								width = "full",
							},
							countBegin = {
								name = L.countdownBegins,
								desc = L.keystoneCountdownBeginsDesc,
								type = "range", min = 3, max = 9, step = 1,
								order = 2,
								width = 1
							},
							countVoice = {
								name = L.countdownVoice,
								type = "select",
								values = BigWigsAPI.GetCountdownList,
								sorting = voiceSorting,
								order = 3,
								width = 2,
							},
							countStartSound = {
								type = "select",
								name = L.keystoneCountdownBeginsSound,
								order = 4,
								get = soundGet,
								set = soundSet,
								values = LibSharedMedia:List("sound"),
								width = 2.5,
								itemControl = "DDI-Sound",
							},
							countEndSound = {
								type = "select",
								name = L.keystoneCountdownEndsSound,
								order = 5,
								get = soundGet,
								set = soundSet,
								values = LibSharedMedia:List("sound"),
								width = 2.5,
								itemControl = "DDI-Sound",
							},
						},
					},
				},
			},
			keystoneViewer = {
				type = "group",
				name = L.keystoneViewerTitle,
				order = 2,
				args = {
					explainViewer = {
						type = "description",
						name = L.keystoneViewerExplainer,
						order = 1,
						width = "full",
					},
					openViewer = {
						type = "execute",
						name = L.keystoneViewerOpen,
						func = ShowViewer,
						order = 2,
						width = 1.5,
					},
					spacerViewer = {
						type = "description",
						name = "\n\n",
						order = 3,
						width = "full",
					},
					showViewerDungeonEnd = {
						type = "toggle",
						name = L.keystoneAutoShowEndOfRun,
						desc = L.keystoneAutoShowEndOfRunDesc,
						order = 4,
						width = "full",
					},
					hideFromGuild = {
						type = "toggle",
						name = L.keystoneHideGuildTitle,
						desc = L.keystoneHideGuildDesc,
						order = 5,
						width = "full",
						set = function(info, value)
							local key = info[#info]
							db.profile[key] = value
							LibKeystone.SetGuildHidden(value)
						end,
						confirm = function(_, value)
							if value then
								return L.keystoneHideGuildWarning
							end
						end,
					},
					explainViewerKeybinding = {
						type = "description",
						name = L.keystoneViewerKeybindingExplainer,
						order = 6,
						width = "full",
					},
					viewerKeybind = {
						type = "keybinding",
						name = L.keybinding,
						desc = L.keystoneViewerKeybindingDesc,
						order = 7,
						set = UpdateSettingsAndWidgets,
					},
				},
			},
			instanceKeys = {
				type = "group",
				name = L.instanceKeysTitle,
				order = 3,
				get = GetSettings,
				set = UpdateSettingsAndWidgets,
				args = {
					explainInstanceKeys = {
						type = "description",
						name = L.instanceKeysDesc,
						order = 1,
						width = "full",
					},
					anchorsButton = {
						type = "execute",
						name = function()
							if instanceKeysWidgets.testing then
								return L.toggleAnchorsBtnHide
							else
								return L.toggleAnchorsBtnShow
							end
						end,
						desc = function()
							if instanceKeysWidgets.testing then
								return L.toggleAnchorsBtnHide_desc
							else
								return L.toggleMessagesAnchorsBtnShow_desc
							end
						end,
						func = function()
							if instanceKeysWidgets.testing then
								instanceKeysWidgets.testing = false
								instanceKeysWidgets.main:EnableMouse(false)
								instanceKeysWidgets.main:SetMovable(false)
								instanceKeysWidgets.bg:Hide()
								if instanceKeysWidgets.namesToShow then
									for i = 1, 5 do
										if i <= #instanceKeysWidgets.namesToShow then
											instanceKeysWidgets.playerListText[i]:SetText(instanceKeysWidgets.namesToShow[i])
											if instanceKeysWidgets.otherDungeons[i] then
												instanceKeysWidgets.playerListText[i]:SetTextColor(db.profile.instanceKeysOtherDungeonColor[1], db.profile.instanceKeysOtherDungeonColor[2], db.profile.instanceKeysOtherDungeonColor[3], db.profile.instanceKeysOtherDungeonColor[4])
											else
												instanceKeysWidgets.playerListText[i]:SetTextColor(db.profile.instanceKeysColor[1], db.profile.instanceKeysColor[2], db.profile.instanceKeysColor[3], db.profile.instanceKeysColor[4])
											end
										else
											instanceKeysWidgets.playerListText[i]:SetText("")
										end
									end
								else
									instanceKeysWidgets.main:Hide()
								end
							else
								instanceKeysWidgets.testing = true
								instanceKeysWidgets.main:Show()
								instanceKeysWidgets.main:EnableMouse(true)
								instanceKeysWidgets.main:SetMovable(true)
								instanceKeysWidgets.bg:Show()
								instanceKeysWidgets.playerListText[1]:SetText(L.instanceKeysTest8)
								instanceKeysWidgets.playerListText[1]:SetTextColor(db.profile.instanceKeysColor[1], db.profile.instanceKeysColor[2], db.profile.instanceKeysColor[3], db.profile.instanceKeysColor[4])
								instanceKeysWidgets.playerListText[2]:SetText(L.instanceKeysTest10)
								instanceKeysWidgets.playerListText[2]:SetTextColor(db.profile.instanceKeysColor[1], db.profile.instanceKeysColor[2], db.profile.instanceKeysColor[3], db.profile.instanceKeysColor[4])
								for i = 3, 5 do
									instanceKeysWidgets.playerListText[i]:SetText("")
								end
							end
						end,
						width = 1.5,
						order = 2,
					},
					instanceKeysFontName = {
						type = "select",
						name = L.font,
						order = 3,
						values = LibSharedMedia:List("font"),
						itemControl = "DDI-Font",
						get = function()
							for i, v in next, LibSharedMedia:List("font") do
								if v == db.profile.instanceKeysFontName then return i end
							end
						end,
						set = function(_, value)
							local list = LibSharedMedia:List("font")
							db.profile.instanceKeysFontName = list[value]
							UpdateWidgets()
						end,
						width = 2,
					},
					instanceKeysOutline = {
						type = "select",
						name = L.outline,
						order = 4,
						values = {
							NONE = L.none,
							OUTLINE = L.thin,
							THICKOUTLINE = L.thick,
						},
					},
					instanceKeysFontSize = {
						type = "range",
						name = L.fontSize,
						desc = L.fontSizeDesc,
						order = 5,
						width = 2,
						softMax = 100, max = 200, min = 14, step = 1,
					},
					instanceKeysMonochrome = {
						type = "toggle",
						name = L.monochrome,
						desc = L.monochromeDesc,
						order = 6,
					},
					instanceKeysAlign = {
						type = "select",
						name = L.align,
						values = {
							L.LEFT,
							L.CENTER,
							L.RIGHT,
						},
						style = "radio",
						order = 7,
						get = function() return db.profile.instanceKeysAlign == "LEFT" and 1 or db.profile.instanceKeysAlign == "RIGHT" and 3 or 2 end,
						set = function(_, value)
							db.profile.instanceKeysAlign = value == 1 and "LEFT" or value == 3 and "RIGHT" or "CENTER"
							UpdateWidgets()
						end,
					},
					instanceKeysColor = {
						type = "color",
						name = L.fontColor,
						get = GetColor,
						set = UpdateColorAndWidgets,
						hasAlpha = true,
						order = 8,
					},
					instanceKeysGrowUpwards = {
						type = "toggle",
						name = L.growingUpwards,
						desc = L.growingUpwardsDesc,
						order = 9,
					},
					extrasHeader = {
						type = "header",
						name = "",
						order = 10,
					},
					instanceKeysShowAllPlayers = {
						type = "toggle",
						name = L.instanceKeysShowAll,
						desc = L.instanceKeysShowAllDesc,
						width = 2,
						order = 11,
						set = function(info, value)
							local key = info[#info]
							db.profile[key] = value
							instanceKeysWidgets.nameList = {}
							LibKeystone.Request("PARTY")
						end,
						confirm = function(_, value)
							if value then
								return L.instanceKeysShowAllDesc
							end
						end,
					},
					instanceKeysOtherDungeonColor = {
						type = "color",
						name = L.instanceKeysOtherDungeonColor,
						desc = L.instanceKeysOtherDungeonColorDesc,
						get = GetColor,
						set = UpdateColorAndWidgets,
						hasAlpha = true,
						order = 12,
						disabled = function() return not db.profile.instanceKeysShowAllPlayers end,
					},
					instanceKeysShowDungeonEnd = {
						type = "toggle",
						name = L.keystoneAutoShowEndOfRun,
						desc = L.instanceKeysEndOfRunDesc,
						set = UpdateSettings,
						order = 13,
						width = "full",
					},
					resetHeader = {
						type = "header",
						name = "",
						order = 14,
					},
					reset = {
						type = "execute",
						name = L.reset,
						desc = L.resetDesc,
						func = function()
							ResetInstanceKeys()
							UpdateWidgets()
							if not instanceKeysWidgets.testing then
								instanceKeysWidgets.nameList = {}
								LibKeystone.Request("PARTY")
							end
						end,
						order = 15,
					},
				},
			},
		},
	})
end
