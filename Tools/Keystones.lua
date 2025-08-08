local L, BigWigsLoader, BigWigsAPI, db

--------------------------------------------------------------------------------
-- Settings
--

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

	local defaults = {
		autoSlotKeystone = true,
		countVoice = defaultVoice,
		countBegin = 5,
		countStartSound = "BigWigs: Long",
		countEndSound = "BigWigs: Alarm",
		autoShowZoneIn = true,
		autoShowEndOfRun = true,
		hideFromGuild = false,
	}
	db = BigWigsLoader.db:RegisterNamespace("MythicPlus", {profile = defaults})
	for k, v in next, db do
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
if db.profile.hideFromGuild then
	LibKeystone.SetGuildHidden(true)
end
local LibSpec = LibStub("LibSpecialization")
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

local guildList, partyList = {}, {}
local WIDTH_NAME, WIDTH_LEVEL, WIDTH_MAP, WIDTH_RATING = 150, 24, 66, 42

local GetMapUIInfo = C_ChallengeMode.GetMapUIInfo

local specs = {}
do
	local function addToTable(specID, _, _, playerName)
		specs[playerName] = specID
	end
	LibSpec.RegisterGroup(specs, addToTable)
	LibSpec.RegisterGuild(specs, addToTable)
end

--------------------------------------------------------------------------------
-- GUI widgets
--

local cellsCurrentlyShowing = {}
local cellsAvailable = {}
local tab1

local mainPanel = CreateFrame("Frame", nil, UIParent, "PortraitFrameTemplate")
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
mainPanel:SetScript("OnDragStart", mainPanel.StartMoving)
mainPanel:SetScript("OnDragStop", mainPanel.StopMovingOrSizing)

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
			elseif not id and not isReloadingUi then -- Don't show when logging in (arg1) or reloading UI (arg2)
				BigWigsLoader.CTimerAfter(0, function() -- Difficulty info isn't accurate until 1 frame after PEW
					local _, _, diffID = BigWigsLoader.GetInstanceInfo()
					if diffID == 23 and GetWeeklyResetStartTime() > 1754625600 and db.profile.autoShowZoneIn and not BigWigsLoader.isTestBuild then
						mainPanel:Show()
						tab1:Click()
					end
				end)
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

tab1 = CreateFrame("Button", nil, mainPanel, "PanelTabButtonTemplate")
tab1:SetSize(50, 26)
tab1:SetPoint("BOTTOMLEFT", 10, -25)
tab1.Text:SetText(L.keystoneTabOnline)
tab1:UnregisterAllEvents() -- Remove events registered by the template
tab1:RegisterEvent("CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN")
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

local tab2 = CreateFrame("Button", nil, mainPanel, "PanelTabButtonTemplate")
tab2:SetSize(50, 26)
tab2:SetPoint("LEFT", tab1, "RIGHT", 4, 0)
tab2.Text:SetText(L.keystoneTabTeleports)
tab2:UnregisterAllEvents() -- Remove events registered by the template
tab2:RegisterEvent("CHALLENGE_MODE_RESET")
do
	local dungeonNamesForBar = {
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
	local GetActiveKeystoneInfo, GetActiveChallengeMapID = C_ChallengeMode.GetActiveKeystoneInfo, C_ChallengeMode.GetActiveChallengeMapID
	tab2:SetScript("OnEvent", function(self, event)
		if event == "CHALLENGE_MODE_START" then
			local keyLevel = GetActiveKeystoneInfo()
			local challengeMapID = GetActiveChallengeMapID()
			local challengeMapName, _, _, icon = GetMapUIInfo(challengeMapID)
			BigWigsLoader:SendMessage("BigWigs_StartCountdown", self, nil, "mythicplus", 9, nil, db.profile.countVoice, 9, nil, db.profile.countBegin)
			if keyLevel and keyLevel > 0 then
				local msg = L.keystoneStartBar:format(dungeonNamesForBar[challengeMapID] or "?", keyLevel)
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
			BigWigsLoader:SendMessage("BigWigs_Message", self, nil, BigWigsAPI:GetLocale("BigWigs: Common").custom_sec:format(L.keystoneStartBar:format(dungeonNamesForBar[challengeMapID], keyLevel), 9), "cyan", icon)
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

local tab3 = CreateFrame("Button", nil, mainPanel, "PanelTabButtonTemplate")
tab3:SetSize(50, 26)
tab3:SetPoint("LEFT", tab2, "RIGHT", 4, 0)
tab3.Text:SetText(L.keystoneTabAlts)
tab3:UnregisterAllEvents() -- Remove events registered by the template
tab3:RegisterEvent("CHALLENGE_MODE_COMPLETED")
do
	local function Open() mainPanel:Show() tab1:Click() end
	tab3:SetScript("OnEvent", function()
		if db.profile.autoShowEndOfRun and not not BigWigsLoader.isTestBuild then
			BigWigsLoader.CTimerAfter(2, Open)
		end
	end)
end

local tab4 = CreateFrame("Button", nil, mainPanel, "PanelTabButtonTemplate")
tab4:SetSize(50, 26)
tab4:SetPoint("LEFT", tab3, "RIGHT", 4, 0)
tab4.Text:SetText(L.keystoneTabHistory)
tab4:UnregisterAllEvents() -- Remove events registered by the template

local function WipeCells()
	for cell in next, cellsCurrentlyShowing do
		cell:Hide()
		cell:ClearAttributes()
		cell.tooltip = nil
		cell.isGuildList = nil
		if cell.isGlowing then
			cell.isGlowing = nil
			LibStub("LibCustomGlow-1.0").PixelGlow_Stop(cell)
		end
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
mainPanel.CloseButton:SetScript("OnClick", function(self)
	self:UnregisterAllEvents()
	tab2:SetScript("OnUpdate", nil)
	WipeCells()
	WipeHeaders()
	mainPanel:Hide()
	tab1:Enable() -- Enable tab1 so :Click always works when we open the main panel again
end)
mainPanel.CloseButton:UnregisterAllEvents() -- Remove events registered by the template
mainPanel.CloseButton:SetScript("OnEvent", function(self)
	if mainPanel:IsShown() then
		self:Click()
	end
end)

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
-- Tab click handlers
--

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

	-- Tab 1 (Online)
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
		LibSpec.RequestGuildSpecialization()
		LibKeystone.Request("PARTY")
		C_Timer.After(0.2, function() LibKeystone.Request("GUILD") end)
	end)

	-- Tab 2 (Teleports)
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
					decoratedName = format("|T%s:16:16:0:0:64:64:4:60:4:60|t%s|c%s%s|r", specIcon, roleIcons[role] or "", color, pData.name)
					nameTooltip = format("|c%s%s|r [%s] |A:classicon-%s:16:16|a%s |T%s:16:16:0:0:64:64:4:60:4:60|t%s %s%s", color, pData.name, pData.realm, classFile, className, specIcon, specName, roleIcons[role] or "", roleIcons[role] and _G[role] or "")
				end
				local challengeMapName, _, _, _, _, mapID = GetMapUIInfo(pData.keyMap)
				sortedplayerList[#sortedplayerList+1] = {
					name = pData.name, decoratedName = decoratedName, nameTooltip = nameTooltip,
					level = pData.keyLevel, levelTooltip = L.keystoneLevelTooltip:format(pData.keyLevel),
					map = dungeonNames[pData.keyMap] or pData.keyMap > 0 and pData.keyMap or "-", mapTooltip = L.keystoneMapTooltip:format(challengeMapName or "-"), mapID = mapID,
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
				if instanceID == sortedplayerList[i].mapID then
					cellName.isGlowing = true
					LibStub("LibCustomGlow-1.0").PixelGlow_Start(cellName, nil, nil, 0.06) -- If you're in the dungeon of this players key, glow
				end
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

		-- Begin Display of history
		local runs = C_MythicPlus.GetRunHistory(true, true)
		local tableSize = #runs
		local highestScoreByMap = {}
		for i = 1, tableSize do
			if not highestScoreByMap[runs[i].mapChallengeModeID] then
				highestScoreByMap[runs[i].mapChallengeModeID] = 0
			end
			if runs[i].runScore > highestScoreByMap[runs[i].mapChallengeModeID] then
				local diff = runs[i].runScore - highestScoreByMap[runs[i].mapChallengeModeID]
				highestScoreByMap[runs[i].mapChallengeModeID] = runs[i].runScore
				runs[i].gained = diff
			else
				runs[i].gained = 0
			end
		end
		local totalThisWeek = 0
		local firstOldRun = false
		local prevMapName, prevLevel, prevScore, prevGainedScore, prevInTime = nil, nil, nil, nil, nil
		for i = tableSize, 1, -1 do
			local cellMapName, cellLevel, cellScore, cellGainedScore, cellInTime = CreateCell(), CreateCell(), CreateCell(), CreateCell(), CreateCell()
			if runs[i].thisWeek then
				totalThisWeek = totalThisWeek + 1
				if i == tableSize then
					cellMapName:SetPoint("RIGHT", cellLevel, "LEFT", -6, 0)
					cellLevel:SetPoint("RIGHT", cellScore, "LEFT", -6, 0)
					cellScore:SetPoint("TOPLEFT", thisWeekHeader, "CENTER", -6, -12)
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
					if totalThisWeek == 0 then
						totalThisWeek = 1
					end
					local y = 24 + totalThisWeek*26
					olderHeader:SetPoint("TOP", thisWeekHeader, "BOTTOM", 0, -y)

					cellMapName:SetPoint("RIGHT", cellLevel, "LEFT", -6, 0)
					cellLevel:SetPoint("RIGHT", cellScore, "LEFT", -6, 0)
					cellScore:SetPoint("TOPLEFT", olderHeader, "CENTER", -6, -12)
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

			cellMapName:SetWidth(WIDTH_MAP)
			cellMapName.text:SetText(dungeonNames[runs[i].mapChallengeModeID] or runs[i].mapChallengeModeID)
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
		if InCombatLockdown() then
			return L.keystoneTeleportInCombat
		else
			local spellName = BigWigsLoader.GetSpellName(spellID)
			if not BigWigsLoader.IsSpellKnownOrInSpellBook(spellID) then
				return L.keystoneTeleportNotLearned:format(spellName)
			else
				local cd = BigWigsLoader.GetSpellCooldown(spellID)
				if cd.startTime > 0 and cd.duration > 0 then
					local remainingSeconds = (cd.startTime + cd.duration) - GetTime()
					local hours = math.floor(remainingSeconds / 3600)
					remainingSeconds = remainingSeconds % 3600
					local minutes = math.floor(remainingSeconds / 60)
					return L.keystoneTeleportOnCooldown:format(spellName, hours, minutes)
				else
					return L.keystoneTeleportReady:format(spellName)
				end
			end
		end
	end

	local function UpdateCellsForOnlineTab(playerList, isGuildList)
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
				local challengeMapName, _, _, _, _, mapID = GetMapUIInfo(pData[2])
				local teleportSpellID = teleportList[1][mapID]
				sortedplayerList[#sortedplayerList+1] = {
					name = pName, decoratedName = decoratedName, nameTooltip = nameTooltip,
					level = pData[1], levelTooltip = L.keystoneLevelTooltip:format(pData[1] == -1 and L.keystoneHiddenTooltip or pData[1]),
					map = pData[2] == -1 and hiddenIcon or dungeonNames[pData[2]] or "-",
					mapTooltip = L.keystoneMapTooltip:format(pData[2] == -1 and L.keystoneHiddenTooltip or challengeMapName or "-") .."\n".. GetTeleportTextForSpellID(teleportSpellID),
					mapID = mapID,
					rating = pData[3], ratingTooltip = L.keystoneRatingTooltip:format(pData[3]),
				}
			end
		end
		if #sortedplayerList == 0 then return end -- The guild list can be empty

		-- Sort list by level descending, or by name if equal level
		table.sort(sortedplayerList, function(a, b)
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
		end)

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
			cellName.isGuildList = isGuildList
			if not isGuildList and instanceID == sortedplayerList[i].mapID then
				cellName.isGlowing = true
				LibStub("LibCustomGlow-1.0").PixelGlow_Start(cellName, nil, nil, 0.06) -- If you're in the dungeon of this players key, glow
			end
			cellLevel:SetWidth(WIDTH_LEVEL)
			cellLevel.text:SetText(sortedplayerList[i].level == -1 and hiddenIcon or sortedplayerList[i].level)
			cellLevel.tooltip = sortedplayerList[i].levelTooltip
			cellLevel.isGuildList = isGuildList
			cellMap:SetWidth(WIDTH_MAP)
			cellMap:SetAttribute("type", "spell")
			cellMap:SetAttribute("spell", teleportList[1][sortedplayerList[i].mapID])
			cellMap.text:SetText(sortedplayerList[i].map)
			cellMap.tooltip = sortedplayerList[i].mapTooltip
			cellMap.isGuildList = isGuildList
			cellRating:SetWidth(WIDTH_RATING)
			cellRating.text:SetText(sortedplayerList[i].rating)
			cellRating.tooltip = sortedplayerList[i].ratingTooltip
			cellRating.isGuildList = isGuildList
			prevName, prevLevel, prevMap, prevRating = cellName, cellLevel, cellMap, cellRating
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
		for cell in next, cellsCurrentlyShowing do
			if cell.isGuildList then
				cell:Hide()
				cell.tooltip = nil
				cell.isGuildList = nil
				cell:ClearAllPoints()
				cellsCurrentlyShowing[cell] = nil
				cellsAvailable[#cellsAvailable+1] = cell
			end
		end
	end

	LibKeystone.Register({}, function(keyLevel, keyMap, playerRating, playerName, channel)
		if channel == "PARTY" then
			if not partyList[playerName] or partyList[playerName][1] ~= keyLevel or partyList[playerName][2] ~= keyMap or partyList[playerName][3] ~= playerRating then
				partyList[playerName] = {keyLevel, keyMap, playerRating}

				if mainPanel:IsShown() and not tab1:IsEnabled() then
					WipeCells()
					UpdateCellsForOnlineTab(partyList)
					UpdateCellsForOnlineTab(guildList, true)
				end
			end
		elseif channel == "GUILD" then
			if not guildList[playerName] or guildList[playerName][1] ~= keyLevel or guildList[playerName][2] ~= keyMap or guildList[playerName][3] ~= playerRating then
				guildList[playerName] = {keyLevel, keyMap, playerRating}

				if mainPanel:IsShown() and not tab1:IsEnabled() then
					WipeGuildCells()
					UpdateCellsForOnlineTab(guildList, true)
				end
			end
		end
	end)
end

do
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

	BigWigsAPI.RegisterSlashCommand("/key", ShowViewer)
	BigWigsAPI.RegisterSlashCommand("/bwkey", ShowViewer)

	BigWigsAPI.SetToolOptionsTable("MythicPlus", {
		type = "group",
		childGroups = "tab",
		name = L.keystoneModuleName,
		get = function(info)
			return db.profile[info[#info]]
		end,
		set = function(info, value)
			local key = info[#info]
			db.profile[key] = value
		end,
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
					suggestions = { -- XXX temp
						type = "description",
						name = "\n\n\n|cFF33FF99Want more features? Have some ideas?\nSubmit your suggestions on our Discord!|r",
						order = 4,
						width = "full",
						fontSize = "medium",
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
					autoShowZoneIn = {
						type = "toggle",
						name = L.keystoneAutoShowZoneIn,
						desc = L.keystoneAutoShowZoneInDesc,
						order = 4,
						width = "full",
					},
					autoShowEndOfRun = {
						type = "toggle",
						name = L.keystoneAutoShowEndOfRun,
						desc = L.keystoneAutoShowEndOfRunDesc,
						order = 5,
						width = "full",
					},
					hideFromGuild = {
						type = "toggle",
						name = L.keystoneHideGuildTitle,
						desc = L.keystoneHideGuildDesc,
						order = 6,
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
				},
			},
		},
	})
end
