
local L = BigWigsAPI:GetLocale("BigWigs")
local mod, public = {}, {}
local bwFrame = CreateFrame("Frame")

local ldb = LibStub("LibDataBroker-1.1")
local ldbi = LibStub("LibDBIcon-1.0")

-----------------------------------------------------------------------
-- Generate our version variables
--

local BIGWIGS_VERSION = 152
local BIGWIGS_RELEASE_STRING, BIGWIGS_VERSION_STRING = "", ""
local versionQueryString, versionResponseString = "Q^%d^%s", "V^%d^%s"

do
	-- START: MAGIC PACKAGER VOODOO VERSION STUFF
	local REPO = "REPO"
	local ALPHA = "ALPHA"
	local RELEASE = "RELEASE"

	local releaseType = RELEASE
	local myGitHash = "@project-abbreviated-hash@" -- The ZIP packager will replace this with the Git hash.
	local releaseString = ""
	--@alpha@
	-- The following code will only be present in alpha ZIPs.
	releaseType = ALPHA
	--@end-alpha@

	-- If we find "@" then we're running from Git directly.
	if myGitHash:find("@", nil, true) then
		myGitHash = "repo"
		releaseType = REPO
	end

	if releaseType == REPO then
		releaseString = L.sourceCheckout:format(BIGWIGS_VERSION)
	elseif releaseType == RELEASE then
		releaseString = L.officialRelease:format(BIGWIGS_VERSION, myGitHash)
	elseif releaseType == ALPHA then
		releaseString = L.alphaRelease:format(BIGWIGS_VERSION, myGitHash)
	end
	BIGWIGS_RELEASE_STRING = releaseString
	BIGWIGS_VERSION_STRING = ("%d-%s"):format(BIGWIGS_VERSION, myGitHash)
	-- Format is "V:version-hash"
	versionQueryString = versionQueryString:format(BIGWIGS_VERSION, myGitHash)
	versionResponseString = versionResponseString:format(BIGWIGS_VERSION, myGitHash)
	-- END: MAGIC PACKAGER VOODOO VERSION STUFF
end

-----------------------------------------------------------------------
-- Locals
--

local tooltipFunctions = {}
local next, tonumber, strsplit = next, tonumber, strsplit
local SendAddonMessage, Ambiguate, CTimerAfter, CTimerNewTicker = C_ChatInfo.SendAddonMessage, Ambiguate, C_Timer.After, C_Timer.NewTicker
local GetInstanceInfo, GetBestMapForUnit, GetMapInfo = GetInstanceInfo, C_Map.GetBestMapForUnit, C_Map.GetMapInfo
local UnitName = UnitName

-- Try to grab unhooked copies of critical funcs (hooked by some crappy addons)
public.GetBestMapForUnit = GetBestMapForUnit
public.GetMapInfo = GetMapInfo
public.GetInstanceInfo = GetInstanceInfo
public.SendAddonMessage = SendAddonMessage
public.SendChatMessage = SendChatMessage
public.CTimerAfter = CTimerAfter
public.CTimerNewTicker = CTimerNewTicker

-- Version
local usersHash = {}
local usersVersion = {}
local usersDBM = {}
local highestFoundVersion = BIGWIGS_VERSION

-- Loading
local loadOnCoreEnabled = {} -- BigWigs modulepacks that should load when a hostile zone is entered or the core is manually enabled, this would be the default plugins Bars, Messages etc
local loadOnZone = {} -- BigWigs modulepack that should load on a specific zone
local loadOnSlash = {} -- BigWigs modulepacks that can load from a chat command
local menus = {} -- contains the menus for BigWigs, once the core is loaded they will get injected
local enableZones = {} -- contains the zones in which BigWigs will enable
local disabledZones -- contains the zones in which BigWigs will enable, but the user has disabled the addon
local worldBosses = {} -- contains the list of world bosses per zone that should enable the core
local fakeZones = { -- Fake zones used as GUI menus
	[-101]=true, -- Outland
	[-424]=true, -- Pandaria
	[-572]=true, -- Draenor
	[-619]=true, -- Broken Isles
	[-947]=true, -- Azeroth
}

do
	local c = "BigWigs_Classic"
	local bc = "BigWigs_BurningCrusade"
	local wotlk = "BigWigs_WrathOfTheLichKing"
	local cata = "BigWigs_Cataclysm"
	local mop = "BigWigs_MistsOfPandaria"
	local wod = "BigWigs_WarlordsOfDraenor"
	local l = "BigWigs_Legion"
	local bfa = "BigWigs_BattleForAzeroth"
	local lw_c = "LittleWigs_Classic"
	local lw_bc = "LittleWigs_BurningCrusade"
	local lw_wotlk = "LittleWigs_WrathOfTheLichKing"
	local lw_cata = "LittleWigs_Cataclysm"
	local lw_mop = "LittleWigs_MistsOfPandaria"
	local lw_wod = "LittleWigs_WarlordsOfDraenor"
	local lw_l = "LittleWigs_Legion"
	local lw_bfa = "LittleWigs_BattleForAzeroth"

	public.zoneTbl = {
		--[[ BigWigs: Classic ]]--
		[409] = c, -- Molten Core
		[469] = c, -- Blackwing Lair
		[509] = c, -- Ruins of Ahn'Qiraj
		[531] = c, -- Ahn'Qiraj Temple
		--[[ BigWigs: The Burning Crusade ]]--
		[-101] = bc, -- Outland (Fake Menu)
		[565] = bc, -- Gruul's Lair
		[532] = bc, -- Karazhan
		[548] = bc, -- Coilfang: Serpentshrine Cavern
		[550] = bc, -- Tempest Keep
		[544] = bc, -- Magtheridon's Lair
		[534] = bc, -- The Battle for Mount Hyjal
		[564] = bc, -- Black Temple
		--[[ BigWigs: Wrath of the Lich King ]]--
		[533] = wotlk, -- Naxxramas
		[616] = wotlk, -- The Eye of Eternity
		[603] = wotlk, -- Ulduar
		[624] = wotlk, -- Vault of Archavon
		[649] = wotlk, -- Trial of the Crusader
		[724] = wotlk, -- The Ruby Sanctum
		[631] = wotlk, -- Icecrown Citadel
		[615] = wotlk, -- The Obsidian Sanctum
		[249] = wotlk, -- Onyxia's Lair
		--[[ BigWigs: Cataclysm ]]--
		[671] = cata, -- The Bastion of Twilight
		[669] = cata, -- Blackwing Descent
		[754] = cata, -- Throne of the Four Winds
		[757] = cata, -- Baradin Hold
		[720] = cata, -- Firelands
		[967] = cata, -- Dragon Soul
		--[[ BigWigs: Mists of Pandaria ]]--
		[-424] = mop, -- Pandaria (Fake Menu)
		[1009] = mop, -- Heart of Fear
		[996] = mop, -- Terrace of Endless Spring
		[1008] = mop, -- Mogu'shan Vaults
		[1098] = mop, -- Throne of Thunder
		[1136] = mop, -- Siege of Orgrimmar
		--[[ BigWigs: Warlords of Draenor ]]--
		[-572] = wod, -- Draenor (Fake Menu)
		[1228] = wod, -- Highmaul
		[1205] = wod, -- Blackrock Foundry
		[1448] = wod, -- Hellfire Citadel
		--[[ BigWigs: Legion ]]--
		[-619] = l, -- Broken Isles (Fake Menu)
		[1520] = l, -- The Emerald Nightmare
		[1648] = l, -- Trial of Valor
		[1530] = l, -- The Nighthold
		[1676] = l, -- Tomb of Sargeras
		[1712] = l, -- Antorus, the Burning Throne
		[1779] = l, -- Invasion Points
		--[[ BigWigs: Battle for Azeroth ]]--
		[-947] = bfa, -- Azeroth (Fake Menu)
		[1861] = bfa, -- Uldir
		[2070] = bfa, -- Battle Of Dazar'alor
		[2096] = bfa, -- Crucible of Storms
		[2164] = bfa, -- The Eternal Palace

		--[[ LittleWigs: Classic ]]--
		[33] = lw_c, -- Shadowfang Keep
		[36] = lw_c, -- Deadmines
		--[[ LittleWigs: The Burning Crusade ]]--
		[540] = lw_bc, -- Hellfire Citadel: The Shattered Halls
		[542] = lw_bc, -- Hellfire Citadel: The Blood Furnace
		[543] = lw_bc, -- Hellfire Citadel: Ramparts
		[546] = lw_bc, -- Coilfang: The Underbog
		[545] = lw_bc, -- Coilfang: The Steamvault
		[547] = lw_bc, -- Coilfang: The Slave Pens
		[553] = lw_bc, -- Tempest Keep: The Botanica
		[554] = lw_bc, -- Tempest Keep: The Mechanar
		[552] = lw_bc, -- Tempest Keep: The Arcatraz
		[556] = lw_bc, -- Auchindoun: Sethekk Halls
		[555] = lw_bc, -- Auchindoun: Shadow Labyrinth
		[557] = lw_bc, -- Auchindoun: Mana-Tombs
		[558] = lw_bc, -- Auchindoun: Auchenai Crypts
		[269] = lw_bc, -- Opening of the Dark Portal
		[560] = lw_bc, -- The Escape from Durnholde
		[585] = lw_bc, -- Magister's Terrace
		--[[ LittleWigs: Wrath of the Lich King ]]--
		[576] = lw_wotlk, -- The Nexus
		[578] = lw_wotlk, -- The Oculus
		[608] = lw_wotlk, -- Violet Hold
		[595] = lw_wotlk, -- The Culling of Stratholme
		[619] = lw_wotlk, -- Ahn'kahet: The Old Kingdom
		[604] = lw_wotlk, -- Gundrak
		[574] = lw_wotlk, -- Utgarde Keep
		[575] = lw_wotlk, -- Utgarde Pinnacle
		[602] = lw_wotlk, -- Halls of Lightning
		[601] = lw_wotlk, -- Azjol-Nerub
		[658] = lw_wotlk, -- Pit of Saron
		[599] = lw_wotlk, -- Halls of Stone
		[600] = lw_wotlk, -- Drak'Tharon Keep
		[650] = lw_wotlk, -- Trial of the Champion
		[668] = lw_wotlk, -- Halls of Reflection
		[632] = lw_wotlk, -- The Forge of Souls
		--[[ LittleWigs: Cataclysm ]]--
		[568] = lw_cata, -- Zul'Aman
		[859] = lw_cata, -- Zul'Gurub
		[643] = lw_cata, -- Throne of the Tides
		[644] = lw_cata, -- Halls of Origination
		[645] = lw_cata, -- Blackrock Caverns
		[755] = lw_cata, -- Lost City of the Tol'vir
		[725] = lw_cata, -- The Stonecore
		[938] = lw_cata, -- End Time
		[939] = lw_cata, -- Well of Eternity
		[657] = lw_cata, -- The Vortex Pinnacle
		[670] = lw_cata, -- Grim Batol
		--[[ LittleWigs: Mists of Pandaria ]]--
		[959] = lw_mop, -- Shado-Pan Monastery
		[960] = lw_mop, -- Temple of the Jade Serpent
		[961] = lw_mop, -- Stormstout Brewery
		[962] = lw_mop, -- Gate of the Setting Sun
		[994] = lw_mop, -- Mogu'shan Palace
		[1001] = lw_mop, -- Scarlet Halls
		[1011] = lw_mop, -- Siege of Niuzao Temple
		[1112] = lw_mop, -- Pursuing the Black Harvest
		[1004] = lw_mop, -- Scarlet Monastery
		--[[ LittleWigs: Warlords of Draenor ]]--
		[1209] = lw_wod, -- Skyreach
		[1176] = lw_wod, -- Shadowmoon Burial Grounds
		[1208] = lw_wod, -- Grimrail Depot
		[1279] = lw_wod, -- The Everbloom
		[1195] = lw_wod, -- Iron Docks
		[1182] = lw_wod, -- Auchindoun
		[1175] = lw_wod, -- Bloodmaul Slag Mines
		[1358] = lw_wod, -- Upper Blackrock Spire
		--[[ LittleWigs: Legion ]]--
		[1544] = lw_l, -- Assault on Violet Hold
		[1677] = lw_l, -- Cathedral of Eternal Night
		[1571] = lw_l, -- Court of Stars
		[1651] = lw_l, -- Return to Karazhan
		[1501] = lw_l, -- Black Rook Hold
		[1516] = lw_l, -- The Arcway
		[1466] = lw_l, -- Darkheart Thicket
		[1458] = lw_l, -- Neltharion's Lair
		[1456] = lw_l, -- Eye of Azshara
		[1492] = lw_l, -- Maw of Souls
		[1477] = lw_l, -- Halls of Valor
		[1493] = lw_l, -- Vault of the Wardens
		[1753] = lw_l, -- Seat of the Triumvirate
		--[[ LittleWigs: Battle for Azeroth ]]--
		[1763] = lw_bfa, -- Atal'Dazar
		[1754] = lw_bfa, -- Freehold
		[1762] = lw_bfa, -- King's Rest
		[1864] = lw_bfa, -- Shrine of the Storm
		[1822] = lw_bfa, -- Siege of Boralus
		[1877] = lw_bfa, -- Temple of Sethraliss
		[1594] = lw_bfa, -- The Undermine
		[1771] = lw_bfa, -- Tol Dagor
		[1841] = lw_bfa, -- Underrot
		[1862] = lw_bfa, -- Waycrest Manor
		[2097] = lw_bfa, -- Operation: Mechagon
	}

	public.zoneTblWorld = {
		[-104] = -101, [-100] = -101, -- Outland
		[-376] = -424, [-379] = -424, [-504] = -424, [-507] = -424, [-554] = -424, -- Pandaria
		[-542] = -572, [-543] = -572, [-534] = -572, -- Draenor
		[-630] = -619, [-634] = -619, [-641] = -619, [-650] = -619, [-680] = -619, -- Broken Isles
		[-942] = -947, -- Azeroth/BfA
	}
end

-- GLOBALS: _G, ADDON_LOAD_FAILED, BigWigs, BigWigs3DB, BigWigsIconDB, BigWigsLoader, BigWigsOptions, ChatFrame_ImportAllListsToHash, ChatTypeInfo, CreateFrame, CUSTOM_CLASS_COLORS, DEFAULT_CHAT_FRAME, error
-- GLOBALS: GetAddOnEnableState, GetAddOnInfo, GetAddOnMetadata, GetLocale, GetNumGroupMembers, GetRealmName, GetSpecialization, GetSpecializationRole, GetTime, GRAY_FONT_COLOR, hash_SlashCmdList, InCombatLockdown
-- GLOBALS: IsAddOnLoaded, IsAltKeyDown, IsControlKeyDown, IsEncounterInProgress, IsInGroup, IsInRaid, IsLoggedIn, IsPartyLFG, IsSpellKnown, LFGDungeonReadyPopup
-- GLOBALS: LibStub, LoadAddOn, message, PlaySound, print, RAID_CLASS_COLORS, RaidNotice_AddMessage, RaidWarningFrame, RegisterAddonMessagePrefix, RolePollPopup, select, StopSound
-- GLOBALS: tostring, tremove, type, UnitAffectingCombat, UnitClass, UnitGroupRolesAssigned, UnitIsConnected, UnitIsDeadOrGhost, UnitSetRole, unpack, SLASH_BigWigs1, SLASH_BigWigs2
-- GLOBALS: SLASH_BigWigsVersion1, wipe

-----------------------------------------------------------------------
-- Utility
--

local function IsAddOnEnabled(addon)
	local character = UnitName("player")
	return GetAddOnEnableState(character, addon) > 0
end

local function sysprint(msg)
	print("|cFF33FF99BigWigs|r: "..msg)
end

local function load(obj, index)
	if obj then return true end

	if loadOnSlash[index] then
		if not IsAddOnLoaded(index) then -- Check if we need remove our slash handler stub.
			for _, slash in next, loadOnSlash[index] do
				hash_SlashCmdList[slash] = nil
			end
		end
		loadOnSlash[index] = nil
	end

	EnableAddOn(index) -- Make sure it wasn't left disabled for whatever reason
	local loaded, reason = LoadAddOn(index)
	if not loaded then
		sysprint(ADDON_LOAD_FAILED:format(GetAddOnInfo(index), _G["ADDON_"..reason]))
	end
	return loaded
end

local function loadAddons(tbl)
	if not tbl[1] then return end

	for i = 1, #tbl do
		local index = tbl[i]
		if not IsAddOnLoaded(index) and load(nil, index) then
			local name = GetAddOnInfo(index)
			public:SendMessage("BigWigs_ModulePackLoaded", name)
		end
	end
	for i = #tbl, 1, -1 do
		tbl[i] = nil
	end
end

local function loadZone(zone)
	if not loadOnZone[zone] then return end
	loadAddons(loadOnZone[zone])
end

local function loadAndEnableCore()
	local loaded = load(BigWigs, "BigWigs_Core")
	if not BigWigs then return end
	loadAddons(loadOnCoreEnabled)
	BigWigs:Enable()
	return loaded
end

local function loadCoreAndOpenOptions()
	loadAndEnableCore()
	load(BigWigsOptions, "BigWigs_Options")
	if BigWigsOptions then
		BigWigsOptions:Open()
	end
end

local function Popup(msg)
	BasicMessageDialog.Text:SetText(msg)
	BasicMessageDialog:Show()
end

-----------------------------------------------------------------------
-- LDB Plugin
--

local dataBroker = ldb:NewDataObject("BigWigs",
	{type = "launcher", label = "BigWigs", icon = "Interface\\AddOns\\BigWigs\\Media\\Textures\\icons\\core-disabled"}
)

function dataBroker.OnClick(self, button)
	if button == "RightButton" then
		loadCoreAndOpenOptions()
	end
end

function dataBroker.OnTooltipShow(tt)
	tt:AddLine("BigWigs")
	if BigWigs and BigWigs:IsEnabled() then
		local added = false
		for name, module in BigWigs:IterateBossModules() do
			if module:IsEnabled() then
				if not added then
					tt:AddLine(L.activeBossModules, 1, 1, 1)
					added = true
				end
				tt:AddLine(module.displayName)
			end
		end
	end
	for i = 1, #tooltipFunctions do
		tooltipFunctions[i](tt)
	end
	tt:AddLine(L.tooltipHint, 0.2, 1, 0.2, 1)
end

-----------------------------------------------------------------------
-- Version listing functions
--

tooltipFunctions[#tooltipFunctions+1] = function(tt)
	local add, i = false, 0
	for _, version in next, usersVersion do
		i = i + 1
		if version < highestFoundVersion then
			add = true
			break
		end
	end
	if not add and i ~= GetNumGroupMembers() then
		add = true
	end
	if add then
		tt:AddLine(L.oldVersionsInGroup, 1, 0, 0, 1)
	end
end

-----------------------------------------------------------------------
-- Loader initialization
--

do
	local reqFuncAddons = {
		BigWigs_Core = true,
		BigWigs_Options = true,
		BigWigs_Plugins = true,
	}
	local loadOnInstanceAddons = {} -- Will contain all names of addons with an X-BigWigs-LoadOn-InstanceId directive
	local loadOnWorldBoss = {} -- Addons that should load when targetting a specific mob
	local extraMenus = {} -- Addons that contain extra zone menus to appear in the GUI
	local noMenus = {} -- Addons that contain zones that shouldn't create a menu
	local blockedMenus = {} -- Zones that shouldn't create a menu

	for i = 1, GetNumAddOns() do
		local name = GetAddOnInfo(i)
		if reqFuncAddons[name] then
			EnableAddOn(i) -- Make sure it wasn't left disabled for whatever reason
		end

		if IsAddOnEnabled(i) then
			local meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-CoreEnabled")
			if meta then
				if name == "BigWigs_Plugins" then -- Always first
					table.insert(loadOnCoreEnabled, 1, i)
				else
					loadOnCoreEnabled[#loadOnCoreEnabled + 1] = i
				end
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-InstanceId")
			if meta then
				loadOnInstanceAddons[#loadOnInstanceAddons + 1] = i
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-ExtraMenu")
			if meta then
				extraMenus[#extraMenus + 1] = i
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-NoMenu")
			if meta then
				noMenus[#noMenus + 1] = i
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-WorldBoss")
			if meta then
				loadOnWorldBoss[#loadOnWorldBoss + 1] = i
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-Slash")
			if meta then
				loadOnSlash[i] = {}
				local tbl = {strsplit(",", meta)}
				for j=1, #tbl do
					local slash = tbl[j]:trim():upper()
					_G["SLASH_"..slash..1] = slash
					SlashCmdList[slash] = function(text)
						if name:find("BigWigs", nil, true) then
							-- Attempting to be smart. Only load core & config if it's a BW plugin.
							loadAndEnableCore()
							load(BigWigsOptions, "BigWigs_Options")
						end
						if load(nil, i) then -- Load the addon/plugin
							-- Call the slash command again, which should have been set by the addon.
							-- Authors, do NOT delay setting it in OnInitialize/OnEnable/etc.
							ChatFrame_ImportAllListsToHash()
							local func = hash_SlashCmdList[slash]
							if func then
								func(text)
							else
								-- Addon didn't register the slash command for whatever reason, print the default invalid slash message.
								local info = ChatTypeInfo["SYSTEM"]
								DEFAULT_CHAT_FRAME:AddMessage(HELP_TEXT_SIMPLE, info.r, info.g, info.b, info.id)
							end
						end
					end
					loadOnSlash[i][j] = slash
				end
			end
		else
			local meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-InstanceId")
			if meta then -- Disabled content
				for j = 1, select("#", strsplit(",", meta)) do
					local rawId = select(j, strsplit(",", meta))
					local id = tonumber(rawId:trim())
					if id and id > 0 then
						if public.zoneTbl[id] then
							if not disabledZones then disabledZones = {} end
							disabledZones[id] = name
						end
					end
				end
			end
		end

		if next(loadOnSlash) then
			ChatFrame_ImportAllListsToHash() -- Add our slashes to the hash.
		end
	end

	local function iterateInstanceIds(addon, ...)
		for i = 1, select("#", ...) do
			local rawId = select(i, ...)
			local id = tonumber(rawId:trim())
			if id then
				local instanceName = GetRealZoneText(id)
				-- register the instance id for enabling.
				if instanceName and instanceName ~= "" then -- Protect live client from beta client ids
					enableZones[id] = true

					if not loadOnZone[id] then loadOnZone[id] = {} end
					loadOnZone[id][#loadOnZone[id] + 1] = addon

					if not menus[id] and not blockedMenus[id] then menus[id] = true end
				end
			else
				local name = GetAddOnInfo(addon)
				sysprint(("The instance ID %q from the addon %q was not parsable."):format(tostring(rawId), name))
			end
		end
	end

	local currentZone = nil
	local function iterateWorldBosses(addon, ...)
		for i = 1, select("#", ...) do
			local rawZoneOrBoss = select(i, ...)
			local zoneOrBoss = tonumber(rawZoneOrBoss:trim())
			if zoneOrBoss then
				if not currentZone then
					currentZone = zoneOrBoss

					-- register the zone for enabling.
					enableZones[currentZone] = "world"

					if not loadOnZone[currentZone] then loadOnZone[currentZone] = {} end
					loadOnZone[currentZone][#loadOnZone[currentZone] + 1] = addon
				else
					worldBosses[zoneOrBoss] = currentZone
					currentZone = nil
				end
			else
				local name = GetAddOnInfo(addon)
				sysprint(("The zone ID %q from the addon %q was not parsable."):format(tostring(rawZoneOrBoss), name))
			end
		end
	end

	local function addExtraMenus(addon, ...)
		for i = 1, select("#", ...) do
			local rawMenu = select(i, ...)
			local id = tonumber(rawMenu:trim())
			if id then
				local name
				if id < 0 then
					local tbl = GetMapInfo(-id)
					if tbl then
						name = tbl.name
					else
						name = tostring(id)
					end
				else
					name = GetRealZoneText(id)
				end
				if name and name ~= "" then -- Protect live client from beta client ids
					if not loadOnZone[id] then loadOnZone[id] = {} end
					loadOnZone[id][#loadOnZone[id] + 1] = addon

					if not menus[id] then menus[id] = true end
				end
			else
				local name = GetAddOnInfo(addon)
				sysprint(("The extra menu ID %q from the addon %q was not parsable."):format(tostring(rawMenu), name))
			end
		end
	end

	local function blockMenus(addon, ...)
		for i = 1, select("#", ...) do
			local rawMenu = select(i, ...)
			local id = tonumber(rawMenu:trim())
			if id then
				local name
				if id < 0 then
					local tbl = GetMapInfo(-id)
					if tbl then
						name = tbl.name
					else
						name = tostring(id)
					end
				else
					name = GetRealZoneText(id)
				end
				if name and name ~= "" and not blockedMenus[id] then -- Protect live client from beta client ids
					blockedMenus[id] = true
				end
			else
				local name = GetAddOnInfo(addon)
				sysprint(("The block menu ID %q from the addon %q was not parsable."):format(tostring(rawMenu), name))
			end
		end
	end

	for i = 1, #extraMenus do
		local index = extraMenus[i]
		local data = GetAddOnMetadata(index, "X-BigWigs-ExtraMenu")
		if data then
			addExtraMenus(index, strsplit(",", data))
		end
	end

	for i = 1, #noMenus do
		local index = noMenus[i]
		local data = GetAddOnMetadata(index, "X-BigWigs-NoMenu")
		if data then
			blockMenus(index, strsplit(",", data))
		end
	end

	for i = 1, #loadOnInstanceAddons do
		local index = loadOnInstanceAddons[i]
		local instancesIds = GetAddOnMetadata(index, "X-BigWigs-LoadOn-InstanceId")
		if instancesIds then
			iterateInstanceIds(index, strsplit(",", instancesIds))
		end
	end

	for i = 1, #loadOnWorldBoss do
		local index = loadOnWorldBoss[i]
		local zones = GetAddOnMetadata(index, "X-BigWigs-LoadOn-WorldBoss")
		if zones then
			iterateWorldBosses(index, strsplit(",", zones))
		end
	end
end

function mod:ADDON_LOADED(addon)
	if addon ~= "BigWigs" then return end

	bwFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	bwFrame:RegisterEvent("RAID_INSTANCE_WELCOME")
	bwFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
	bwFrame:RegisterEvent("LFG_PROPOSAL_SHOW")

	-- Role Updating
	bwFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	RolePollPopup:UnregisterEvent("ROLE_POLL_BEGIN")

	bwFrame:RegisterEvent("CHAT_MSG_ADDON")
	C_ChatInfo.RegisterAddonMessagePrefix("BigWigs")
	C_ChatInfo.RegisterAddonMessagePrefix("D4") -- DBM

	-- LibDBIcon setup
	if type(BigWigsIconDB) ~= "table" then
		BigWigsIconDB = {}
	end
	ldbi:Register("BigWigs", dataBroker, BigWigsIconDB)

	if BigWigs3DB then
		-- Somewhat ugly, but saves loading AceDB with the loader instead of with the core
		if BigWigs3DB.profileKeys and BigWigs3DB.profiles then
			local name = UnitName("player")
			local realm = GetRealmName()
			if name and realm and BigWigs3DB.profileKeys[name.." - "..realm] then
				local key = BigWigs3DB.profiles[BigWigs3DB.profileKeys[name.." - "..realm]]
				if key then
					self.isFakingDBM = key.fakeDBMVersion
					self.isShowingZoneMessages = key.showZoneMessages
				end
				if BigWigs3DB.namespaces and BigWigs3DB.namespaces.BigWigs_Plugins_Sounds and BigWigs3DB.namespaces.BigWigs_Plugins_Sounds.profiles and BigWigs3DB.namespaces.BigWigs_Plugins_Sounds.profiles[BigWigs3DB.profileKeys[name.." - "..realm]] then
					self.isSoundOn = BigWigs3DB.namespaces.BigWigs_Plugins_Sounds.profiles[BigWigs3DB.profileKeys[name.." - "..realm]].sound
				end
			end
		end
		-- Cleanup function.
		-- TODO: look into having a way for our boss modules not to create a table when no options are changed.
		if BigWigs3DB.namespaces then
			for k,v in next, BigWigs3DB.namespaces do
				if k:find("BigWigs_Bosses_", nil, true) and (not next(v) or not BigWigs3DB.wipe80) then -- XXX temp boss DB wipe for 8.0.1
					BigWigs3DB.namespaces[k] = nil
				end
				-- XXX start temp 8.0.1 color conversion
				if k == "BigWigs_Plugins_Colors" then
					for profiles, profileList in next, v do
						for name, tbl in next, profileList do
							if tbl["Positive"] then
								tbl["green"] = tbl["Positive"]
								tbl["Positive"] = nil
							end
							if tbl["Personal"] then
								tbl["blue"] = tbl["Personal"]
								tbl["Personal"] = nil
							end
							if tbl["Important"] then
								tbl["red"] = tbl["Important"]
								tbl["Important"] = nil
							end
							if tbl["Urgent"] then
								tbl["orange"] = tbl["Urgent"]
								tbl["Urgent"] = nil
							end
							if tbl["Neutral"] then
								tbl["cyan"] = tbl["Neutral"]
								tbl["Neutral"] = nil
							end
							if tbl["Attention"] then
								tbl["yellow"] = tbl["Attention"]
								tbl["Attention"] = nil
							end
						end
					end
				end
				-- XXX end temp 8.0.1 color conversion
			end
		end
		BigWigs3DB.wipe80 = true -- XXX temp boss DB wipe for 8.0.1
		if not BigWigs3DB.discord or BigWigs3DB.discord < 15 then
			BigWigs3DB.discord = (BigWigs3DB.discord or 0) + 1
			CTimerAfter(11, function() sysprint("We are now on Discord: https://discord.gg/jGveg85") end)
		end
		BigWigs3DB.fPrint = nil -- XXX temp 7.3.5
	end
	self:BigWigs_CoreOptionToggled(nil, "fakeDBMVersion", self.isFakingDBM)

	if self.isSoundOn ~= false then -- Only if sounds are enabled
		local num = tonumber(C_CVar.GetCVar("Sound_NumChannels")) or 0
		if num < 64 then
			C_CVar.SetCVar("Sound_NumChannels", "64") -- Blizzard keeps screwing with addon sound priority so we force this minimum
		end
	end

	bwFrame:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil
end

-- We can't do our addon loading in ADDON_LOADED as the target addons may be registering that
-- which would break that event for those addons. Use this event instead.
function mod:UPDATE_FLOATING_CHAT_WINDOWS()
	bwFrame:UnregisterEvent("UPDATE_FLOATING_CHAT_WINDOWS")
	self.UPDATE_FLOATING_CHAT_WINDOWS = nil

	self:GROUP_ROSTER_UPDATE()
	self:ZONE_CHANGED_NEW_AREA()

	-- Break timer restoration
	if BigWigs3DB and BigWigs3DB.breakTime then
		loadAndEnableCore()
	end
end

-- Various temporary printing stuff
do
	local old = {
		BigWigs_Ulduar = "BigWigs_WrathOfTheLichKing",
		BigWigs_Yogg_Brain = "BigWigs_WrathOfTheLichKing",
		BigWigs_TheEye = "BigWigs_BurningCrusade",
		BigWigs_Sunwell = "BigWigs_BurningCrusade",
		BigWigs_SSC = "BigWigs_BurningCrusade",
		BigWigs_Outland = "BigWigs_BurningCrusade",
		BigWigs_Northrend = "BigWigs_WrathOfTheLichKing",
		BigWigs_Naxxramas = "BigWigs_WrathOfTheLichKing",
		BigWigs_MC = "BigWigs_Classic",
		BigWigs_Karazhan = "BigWigs_BurningCrusade",
		BigWigs_Hyjal = "BigWigs_BurningCrusade",
		BigWigs_Coliseum = "BigWigs_WrathOfTheLichKing",
		BigWigs_Citadel = "BigWigs_WrathOfTheLichKing",
		BigWigs_LK_Valkyr_Marker = "BigWigs_WrathOfTheLichKing",
		BigWigs_BWL = "BigWigs_Classic",
		BigWigs_BlackTemple = "BigWigs_BurningCrusade",
		BigWigs_AQ20 = "BigWigs_Classic",
		BigWigs_AQ40 = "BigWigs_Classic",
		BigWigs_Baradin = "BigWigs_Cataclysm",
		BigWigs_Bastion = "BigWigs_Cataclysm",
		BigWigs_Blackwing = "BigWigs_Cataclysm",
		BigWigs_DragonSoul = "BigWigs_Cataclysm",
		BigWigs_Firelands = "BigWigs_Cataclysm",
		BigWigs_Throne = "BigWigs_Cataclysm",
		bigwigs_zonozzicons = "BigWigs_Cataclysm",
		BigWigs_EndlessSpring = "BigWigs_MistsOfPandaria",
		BigWigs_HeartOfFear = "BigWigs_MistsOfPandaria",
		BigWigs_Mogushan = "BigWigs_MistsOfPandaria",
		BigWigs_Pandaria = "BigWigs_MistsOfPandaria",
		BigWigs_SiegeOfOrgrimmar = "BigWigs_MistsOfPandaria",
		BigWigs_ThroneOfThunder = "BigWigs_MistsOfPandaria",
		BigWigs_Draenor = "BigWigs_WarlordsOfDraenor",
		BigWigs_Highmaul = "BigWigs_WarlordsOfDraenor",
		BigWigs_BlackrockFoundry = "BigWigs_WarlordsOfDraenor",
		BigWigs_HellfireCitadel = "BigWigs_WarlordsOfDraenor",
		LittleWigs_ShadoPanMonastery = "LittleWigs",
		LittleWigs_ScarletHalls = "LittleWigs",
		LittleWigs_ScarletMonastery = "LittleWigs",
		LittleWigs_MogushanPalace = "LittleWigs",
		LittleWigs_TempleOfTheJadeSerpent = "LittleWigs",
		LittleWigs_TBC = "LittleWigs",
		LittleWigs_Auchindoun = "LittleWigs",
		LittleWigs_Coilfang = "LittleWigs",
		LittleWigs_CoT = "LittleWigs",
		LittleWigs_HellfireCitadel = "LittleWigs",
		LittleWigs_MagistersTerrace = "LittleWigs",
		LittleWigs_TempestKeep = "LittleWigs",
		LittleWigs_LK = "LittleWigs",
		LittleWigs_Coldarra = "LittleWigs",
		LittleWigs_Dalaran = "LittleWigs",
		LittleWigs_Dragonblight = "LittleWigs",
		LittleWigs_Frozen_Halls = "LittleWigs",
		LittleWigs_Howling_Fjord = "LittleWigs",
		LittleWigs_Icecrown = "LittleWigs",
		LittleWigs_Stratholme = "LittleWigs",
		LittleWigs_Storm_Peaks = "LittleWigs",
		["LittleWigs_Zul'Drak"] = "LittleWigs",
		LittleWigs_Cataclysm = "LittleWigs",
		BigWigs_TayakIcons = "BigWigs",
		BigWigs_PizzaBar = "BigWigs",
		BigWigs_ShaIcons = "BigWigs",
		BigWigs_LeiShi_Marker = "BigWigs",
		BigWigs_NoPluginWarnings = "BigWigs",
		LFG_ProposalTime = "BigWigs",
		CourtOfStarsGossipHelper = "LittleWigs",
		BigWigs_DispelResist = "",
		BigWigs_Voice_HeroesOfTheStorm = "BigWigs_Countdown_HeroesOfTheStorm",
		BigWigs_Voice_Overwatch = "BigWigs_Countdown_Overwatch",
		BigWigs_AutoReply = "BigWigs",
		BigWigs_AutoReply2 = "BigWigs",
		BigWigs_Antorus = "BigWigs_Legion",
		BigWigs_ArgusInvasionPoints = "BigWigs_Legion",
		BigWigs_BrokenIsles = "BigWigs_Legion",
		BigWigs_Nighthold = "BigWigs_Legion",
		BigWigs_Nightmare = "BigWigs_Legion",
		BigWigs_TombOfSargeras = "BigWigs_Legion",
		BigWigs_TrialOfValor = "BigWigs_Legion",
		BigWigs_SiegeOfZuldazar = "BigWigs",
		FS_Core = "Abandoned", -- abandoned addon breaking the load order
	}
	local delayedMessages = {}

	-- Try to teach people not to force load our modules.
	for i = 1, GetNumAddOns() do
		local name = GetAddOnInfo(i)
		if IsAddOnEnabled(i) and not IsAddOnLoadOnDemand(i) then
			for j = 1, select("#", GetAddOnOptionalDependencies(i)) do
				local meta = select(j, GetAddOnOptionalDependencies(i))
				if meta and (meta == "BigWigs_Core" or meta == "BigWigs_Plugins" or meta == "BigWigs_Options") then
					delayedMessages[#delayedMessages+1] = "The addon '|cffffff00"..name.."|r' is forcing BigWigs to load prematurely, notify the BigWigs authors!"
				end
			end
			for j = 1, select("#", GetAddOnDependencies(i)) do
				local meta = select(j, GetAddOnDependencies(i))
				if meta and (meta == "BigWigs_Core" or meta == "BigWigs_Plugins" or meta == "BigWigs_Options") then
					delayedMessages[#delayedMessages+1] = "The addon '|cffffff00"..name.."|r' is forcing BigWigs to load prematurely, notify the BigWigs authors!"
				end
			end
		end

		if old[name] then
			delayedMessages[#delayedMessages+1] = L.removeAddon:format(name, old[name])
			Popup(L.removeAddon:format(name, old[name]))
		end
	end

	local L = GetLocale()
	local locales = {
		--ruRU = "Russian (ruRU)",
		itIT = "Italian (itIT)",
		--koKR = "Korean (koKR)",
		esES = "Spanish (esES)",
		esMX = "Spanish (esMX)",
		--deDE = "German (deDE)",
		ptBR = "Portuguese (ptBR)",
		--frFR = "French (frFR)",
	}
	if locales[L] then
		delayedMessages[#delayedMessages+1] = ("BigWigs is missing translations for %s. Can you help? Visit git.io/vpBye or ask us on Discord for more info."):format(locales[L])
	end

	CTimerAfter(11, function()
		--local _, _, _, _, month, _, year = GetAchievementInfo(10043) -- Mythic Archimonde
		--if year == 15 and month < 10 then
		--	sysprint("We're looking for an end-game raider to join our GitHub developer team: goo.gl/aajTfo")
		--end
		for _, msg in next, delayedMessages do
			sysprint(msg)
		end
		delayedMessages = nil
	end)
end

-----------------------------------------------------------------------
-- Callback handler
--

do
	local callbackMap = {}
	function public:RegisterMessage(msg, func)
		if self == BigWigsLoader then
			error(".RegisterMessage(addon, message, function) attempted to register a function to BigWigsLoader, you might be using : instead of . to register the callback.")
		end

		if type(msg) ~= "string" then
			error(":RegisterMessage(message, function) attempted to register invalid message, must be a string!")
		end

		local funcType = type(func)
		if funcType == "string" then
			if not self[func] then error((":RegisterMessage(message, function) attempted to register the function '%s' but it doesn't exist!"):format(func)) end
		elseif funcType == "nil" then
			if not self[msg] then error((":RegisterMessage(message, function) attempted to register the function '%s' but it doesn't exist!"):format(msg)) end
		elseif funcType ~= "function" then
			error(":RegisterMessage(message, function) attempted to register an invalid function!")
		end

		if not callbackMap[msg] then callbackMap[msg] = {} end
		callbackMap[msg][self] = func or msg
	end
	function public:UnregisterMessage(msg)
		if self == BigWigsLoader then
			error(".UnregisterMessage(addon, message, function) attempted to unregister a function from BigWigsLoader, you might be using : instead of . to register the callback.")
		end

		if type(msg) ~= "string" then error(":UnregisterMessage(message) attempted to unregister an invalid message, must be a string!") end
		if not callbackMap[msg] then return end
		callbackMap[msg][self] = nil
		if not next(callbackMap[msg]) then
			callbackMap[msg] = nil
		end
	end

	function public:SendMessage(msg, ...)
		if callbackMap[msg] then
			for k,v in next, callbackMap[msg] do
				if type(v) == "function" then
					v(msg, ...)
				else
					k[v](k, msg, ...)
				end
			end
		end
	end

	local function UnregisterAllMessages(_, module)
		for k,v in next, callbackMap do
			for j in next, v do
				if j == module then
					public.UnregisterMessage(module, k)
				end
			end
		end
	end
	public.RegisterMessage(mod, "BigWigs_OnBossDisable", UnregisterAllMessages)
	public.RegisterMessage(mod, "BigWigs_OnBossWipe", UnregisterAllMessages)
	public.RegisterMessage(mod, "BigWigs_OnPluginDisable", UnregisterAllMessages)
end

-----------------------------------------------------------------------
-- DBM version collection & faking
--

do
	-- This is a crapfest mainly because DBM's actual handling of versions is a crapfest, I'll try explain how this works...
	local DBMdotRevision = "20190710045001" -- The changing version of the local client, changes with every alpha revision using an SVN keyword.
	local DBMdotDisplayVersion = "8.2.3" -- "N.N.N" for a release and "N.N.N alpha" for the alpha duration. Unless they fuck up their release and leave the alpha text in it.
	local DBMdotReleaseRevision = "20190709000000" -- This is manually changed by them every release, they use it to track the highest release version, a new DBM release is the only time it will change.

	local timer, prevUpgradedUser = nil, nil
	local function sendMsg()
		if IsInGroup() then
			SendAddonMessage("D4", "V\t"..DBMdotRevision.."\t"..DBMdotReleaseRevision.."\t"..DBMdotDisplayVersion.."\t"..GetLocale().."\t".."true", IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- LE_PARTY_CATEGORY_INSTANCE = 2
		end
		timer, prevUpgradedUser = nil, nil
	end
	function mod:DBM_VersionCheck(prefix, sender, revision, releaseRevision, displayVersion)
		if prefix == "H" and (BigWigs and BigWigs.db.profile.fakeDBMVersion or self.isFakingDBM) then
			if timer then timer:Cancel() end
			timer = CTimerNewTicker(3.3, sendMsg, 1)
		elseif prefix == "V" then
			usersDBM[sender] = displayVersion
			--if BigWigs and BigWigs.db.profile.fakeDBMVersion or self.isFakingDBM then
			--	-- If there are people with newer versions than us, suddenly we've upgraded!
			--	local rev, dotRev = tonumber(revision), tonumber(DBMdotRevision)
			--	if rev and displayVersion and rev ~= 99999 and rev > dotRev and not displayVersion:find("alpha", nil, true) then -- Failsafes
			--		if not prevUpgradedUser then
			--			prevUpgradedUser = sender
			--		elseif prevUpgradedUser ~= sender then
			--			DBMdotRevision = revision -- Update our local rev with the highest possible rev found.
			--			DBMdotReleaseRevision = releaseRevision -- Update our release rev with the highest found, this should be the same for alpha users and latest release users.
			--			DBMdotDisplayVersion = displayVersion -- Update to the latest display version.
			--			-- Re-send the addon message.
			--			if timer then timer:Cancel() end
			--			timer = CTimerNewTicker(1, sendMsg, 1)
			--		end
			--	end
			--end
		end
	end
	function mod:BigWigs_CoreOptionToggled(_, key, value)
		if key == "fakeDBMVersion" and value and IsInGroup() then
			self:DBM_VersionCheck("H") -- Send addon message if feature is being turned on inside a raid/group.
		end
	end
	public.RegisterMessage(mod, "BigWigs_CoreOptionToggled")
end

-----------------------------------------------------------------------
-- Events
--

bwFrame:SetScript("OnEvent", function(_, event, ...)
	mod[event](mod, ...)
end)
bwFrame:RegisterEvent("ADDON_LOADED")
bwFrame:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS")

do
	-- Role Updating
	local prev = 0
	function mod:PLAYER_REGEN_ENABLED()
		bwFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self:ACTIVE_TALENT_GROUP_CHANGED() -- Force role check
	end
	function mod:ACTIVE_TALENT_GROUP_CHANGED()
		if IsInGroup() then
			if IsPartyLFG() then return end

			local tree = GetSpecialization()
			if not tree then return end -- No spec selected

			local role = GetSpecializationRole(tree)
			if role and UnitGroupRolesAssigned("player") ~= role then
				if InCombatLockdown() or UnitAffectingCombat("player") then
					bwFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
					return
				end
				-- ACTIVE_TALENT_GROUP_CHANGED fires twice when changing spec, leaving the talent tree, and entering the new tree. We throttle this to prevent a double role chat message.
				-- It should only fire once when joining a group (triggered from GROUP_ROSTER_UPDATE)
				-- This will fail when logging in/reloading in a group because GetSpecializationRole is nil since WoW v7 when GROUP_ROSTER_UPDATE fires
				-- However, your role seems to be saved internally and preserved, so is this really an issue?
				local t = GetTime()
				if (t-prev) > 2 then
					prev = t
					UnitSetRole("player", role)
				end
			end
		end
	end
end

-- Merged LFG_ProposalTime addon by Freebaser
do
	local prev
	function mod:LFG_PROPOSAL_SHOW()
		if not prev then
			local timerBar = CreateFrame("StatusBar", nil, LFGDungeonReadyPopup)
			timerBar:SetPoint("TOP", LFGDungeonReadyPopup, "BOTTOM", 0, -5)
			local tex = timerBar:CreateTexture()
			tex:SetTexture(137012) -- Interface\\TargetingFrame\\UI-StatusBar
			timerBar:SetStatusBarTexture(tex)
			timerBar:SetSize(190, 9)
			timerBar:SetStatusBarColor(1, 0.1, 0)
			timerBar:SetMinMaxValues(0, 40)
			timerBar:Show()

			local bg = timerBar:CreateTexture(nil, "BACKGROUND")
			bg:SetAllPoints(timerBar)
			bg:SetColorTexture(0, 0, 0, 0.7)

			local spark = timerBar:CreateTexture(nil, "OVERLAY")
			spark:SetTexture(130877) -- Interface\\CastingBar\\UI-CastingBar-Spark
			spark:SetSize(32, 32)
			spark:SetBlendMode("ADD")
			spark:SetPoint("LEFT", tex, "RIGHT", -15, 0)

			local border = timerBar:CreateTexture(nil, "OVERLAY")
			border:SetTexture(130874) -- Interface\\CastingBar\\UI-CastingBar-Border
			border:SetSize(256, 64)
			border:SetPoint("TOP", timerBar, 0, 28)

			timerBar.text = timerBar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
			timerBar.text:SetPoint("CENTER", timerBar, "CENTER")

			self.LFG_PROPOSAL_SHOW = function()
				prev = GetTime() + 40
				-- Play in Master for those that have SFX off or very low.
				-- Using false as third arg to avoid the "only one of each sound at a time" throttle.
				-- Only play via the "Master" channel if we have sounds turned on
				if (BigWigs and BigWigs:GetPlugin("Sounds") and BigWigs:GetPlugin("Sounds").db.profile.sound) or self.isSoundOn ~= false then
					local _, id = PlaySound(8960, "Master", false) -- SOUNDKIT.READY_CHECK
					if id then
						StopSound(id-1) -- Should work most of the time to stop the blizz sound
					end
				end
			end
			self:LFG_PROPOSAL_SHOW()

			timerBar:SetScript("OnUpdate", function(f)
				local timeLeft = prev - GetTime()
				if timeLeft > 0 then
					f:SetValue(timeLeft)
					f.text:SetFormattedText("BigWigs: %.1f", timeLeft)
				end
			end)

			-- USE THIS CALLBACK TO SKIN THIS WINDOW! NO NEED FOR UGLY HAX! E.g.
			-- local name, addon = ...
			-- if BigWigsLoader then
			-- 	BigWigsLoader.RegisterMessage(addon, "BigWigs_FrameCreated", function(event, frame, name) print(name.." frame created.") end)
			-- end
			public:SendMessage("BigWigs_FrameCreated", timerBar, "QueueTimer")
		end
	end
end

function mod:CHAT_MSG_ADDON(prefix, msg, channel, sender)
	if channel ~= "RAID" and channel ~= "PARTY" and channel ~= "INSTANCE_CHAT" then
		return
	elseif prefix == "BigWigs" then
		local bwPrefix, bwMsg, extra = strsplit("^", msg)
		sender = Ambiguate(sender, "none")
		if bwPrefix == "V" or bwPrefix == "Q" then
			self:VersionCheck(bwPrefix, bwMsg, extra, sender)
		elseif bwPrefix == "B" then
			public:SendMessage("BigWigs_BossComm", bwMsg, extra, sender)
		elseif bwPrefix == "P" then
			if bwMsg == "Pull" then
				local _, _, _, instanceId = UnitPosition("player")
				local _, _, _, tarInstanceId = UnitPosition(sender)
				if instanceId == tarInstanceId then
					loadAndEnableCore() -- Force enable the core when receiving a pull timer.
				end
			elseif bwMsg == "Break" then
				loadAndEnableCore() -- Force enable the core when receiving a break timer.
			end
			public:SendMessage("BigWigs_PluginComm", bwMsg, extra, sender)
		end
	elseif prefix == "D4" then
		local dbmPrefix, arg1, arg2, arg3, arg4 = strsplit("\t", msg)
		sender = Ambiguate(sender, "none")
		if dbmPrefix == "V" or dbmPrefix == "H" then
			self:DBM_VersionCheck(dbmPrefix, sender, arg1, arg2, arg3)
		elseif dbmPrefix == "U" or dbmPrefix == "PT" or dbmPrefix == "M" or dbmPrefix == "BT" then
			if dbmPrefix == "PT" then
				local _, _, _, instanceId = UnitPosition("player")
				local _, _, _, tarInstanceId = UnitPosition(sender)
				if instanceId == tarInstanceId then
					loadAndEnableCore() -- Force enable the core when receiving a pull timer.
				end
			elseif dbmPrefix == "BT" then
				loadAndEnableCore() -- Force enable the core when receiving a break timer.
			end
			public:SendMessage("DBM_AddonMessage", sender, dbmPrefix, arg1, arg2, arg3, arg4)
		end
	end
end

local ResetVersionWarning
do
	local timer = nil
	local function sendMsg()
		if IsInGroup() then
			SendAddonMessage("BigWigs", versionResponseString, IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- LE_PARTY_CATEGORY_INSTANCE = 2
		end
		timer = nil
	end

	local hasWarned = 0
	local verTimer = nil
	function ResetVersionWarning()
		hasWarned = 0
		if verTimer then verTimer:Cancel() end -- We may have left the group whilst a warning is about to show
		verTimer = nil
	end

	local function printOutOfDate(tbl)
		if hasWarned == 3 then return end
		local warnedOutOfDate, warnedReallyOutOfDate, warnedExtremelyOutOfDate = 0, 0, 0
		for k,v in next, tbl do
			if v > BIGWIGS_VERSION then
				warnedOutOfDate = warnedOutOfDate + 1
				if (v - 1) > BIGWIGS_VERSION then -- 2+ releases
					warnedReallyOutOfDate = warnedReallyOutOfDate + 1
					if (v - 2) > BIGWIGS_VERSION then -- 3+ releases
						warnedExtremelyOutOfDate = warnedExtremelyOutOfDate + 1
					end
				end
			end
		end
		if warnedExtremelyOutOfDate > 1 then
			if verTimer then verTimer:Cancel() end
			verTimer = CTimerNewTicker(3, function()
				hasWarned = 3
				verTimer = nil
				local diff = highestFoundVersion - BIGWIGS_VERSION
				local msg = L.warnSeveralReleases:format(diff)
				sysprint(msg)
				Popup(msg)
				RaidNotice_AddMessage(RaidWarningFrame, msg, {r=1,g=1,b=1}, 40)
			end, 1)
		elseif warnedReallyOutOfDate > 1 and hasWarned < 2 then
			if verTimer then verTimer:Cancel() end
			verTimer = CTimerNewTicker(3, function()
				hasWarned = 2
				verTimer = nil
				sysprint(L.warnTwoReleases)
				RaidNotice_AddMessage(RaidWarningFrame, L.warnTwoReleases, {r=1,g=1,b=1}, 20)
			end, 1)
		elseif warnedOutOfDate > 1 and hasWarned < 1 then
			if verTimer then verTimer:Cancel() end
			verTimer = CTimerNewTicker(3, function()
				hasWarned = 1
				verTimer = nil
				sysprint(L.getNewRelease)
			end, 1)
		end
	end

	function mod:VersionCheck(prefix, verString, hash, sender)
		if prefix == "Q" then
			if timer then timer:Cancel() end
			timer = CTimerNewTicker(3, sendMsg, 1)
		end
		if prefix == "V" or prefix == "Q" then -- V = version response, Q = version query
			local version = tonumber(verString)
			if version and version > 0 then -- Allow addons to query BigWigs versions by using a version of 0, but don't add them to the user list.
				usersVersion[sender] = version
				usersHash[sender] = hash
				if version > highestFoundVersion then highestFoundVersion = version end
				if version > BIGWIGS_VERSION then
					printOutOfDate(usersVersion)
				end
			end
		end
	end
end

do
	local warnedThisZone = {}

	local UnitGUID = UnitGUID
	function mod:UNIT_TARGET(unit)
		local guid = UnitGUID(unit.."target")
		if guid then
			local _, _, _, _, _, mobId = strsplit("-", guid)
			mobId = tonumber(mobId)
			local id = mobId and worldBosses[mobId]
			if id then
				if loadAndEnableCore() then
					if BigWigs:IsEnabled() then
						loadZone(id)
					else
						BigWigs:Enable()
					end
				end
			end
		end
	end

	function mod:ZONE_CHANGED_NEW_AREA()
		-- Zone checking
		local _, instanceType, _, _, _, _, _, id = GetInstanceInfo()
		if instanceType == "none" then
			local mapId = GetBestMapForUnit("player")
			if mapId then
				id = -mapId -- Use map id for world bosses
			end
		end

		-- Module loading
		if enableZones[id] then
			if id > 0 then
				bwFrame:UnregisterEvent("UNIT_TARGET")
				if loadAndEnableCore() then
					if BigWigs:IsEnabled() and loadOnZone[id] then
						loadZone(id)
					else
						BigWigs:Enable()
					end
				end
			elseif enableZones[id] == "world" then
				if BigWigs and BigWigs:IsEnabled() and not UnitIsDeadOrGhost("player") and (not BigWigsOptions or not BigWigsOptions:IsOpen()) and (not BigWigs3DB or not BigWigs3DB.breakTime) then
					BigWigs:Disable() -- Might be leaving an LFR and entering a world enable zone, disable first
				end
				bwFrame:RegisterEvent("UNIT_TARGET")
				self:UNIT_TARGET("player")
			end
		else
			bwFrame:UnregisterEvent("UNIT_TARGET")
			if BigWigs and BigWigs:IsEnabled() and not UnitIsDeadOrGhost("player")
			and (not BigWigsOptions or not BigWigsOptions:IsOpen()) -- Not if the GUI is open
			and (not BigWigsAnchor or (not next(BigWigsAnchor.bars) and not next(BigWigsEmphasizeAnchor.bars))) then -- Not if bars are showing
				BigWigs:Disable() -- Alive in a non-enable zone, disable
			end
			if disabledZones and disabledZones[id] then -- We have content for the zone but it is disabled in the addons menu
				local msg = L.disabledAddOn:format(disabledZones[id])
				sysprint(msg)
				Popup(msg)
				-- Only print once
				warnedThisZone[id] = true
				disabledZones[id] = nil
			end
		end

		-- Lacking zone modules
		if (BigWigs and BigWigs.db.profile.showZoneMessages == false) or self.isShowingZoneMessages == false then return end
		local zoneAddon = public.zoneTbl[id]
		if zoneAddon and zoneAddon ~= "BigWigs_BattleForAzeroth" then
			if zoneAddon:find("LittleWigs_", nil, true) then zoneAddon = "LittleWigs" end -- Collapse into one addon
			if id > 0 and not fakeZones[id] and not warnedThisZone[id] and not IsAddOnEnabled(zoneAddon) then
				warnedThisZone[id] = true
				local msg = L.missingAddOn:format(zoneAddon)
				sysprint(msg)
				RaidNotice_AddMessage(RaidWarningFrame, msg, {r=1,g=1,b=1}, 15)
			end
		end
	end
	mod.RAID_INSTANCE_WELCOME = mod.ZONE_CHANGED_NEW_AREA -- Entirely for Onyxia's Lair loading
end

do
	local grouped = nil
	function mod:GROUP_ROSTER_UPDATE()
		local groupType = (IsInGroup(2) and 3) or (IsInRaid() and 2) or (IsInGroup() and 1) -- LE_PARTY_CATEGORY_INSTANCE = 2
		if (not grouped and groupType) or (grouped and groupType and grouped ~= groupType) then
			grouped = groupType
			SendAddonMessage("BigWigs", versionQueryString, groupType == 3 and "INSTANCE_CHAT" or "RAID")
			SendAddonMessage("D4", "H\t", groupType == 3 and "INSTANCE_CHAT" or "RAID") -- Also request DBM versions
			self:ZONE_CHANGED_NEW_AREA()
			self:ACTIVE_TALENT_GROUP_CHANGED() -- Force role check
		elseif grouped and not groupType then
			grouped = nil
			ResetVersionWarning()
			wipe(usersVersion)
			wipe(usersHash)
			self:ZONE_CHANGED_NEW_AREA()
		end
	end
end

function mod:BigWigs_BossModuleRegistered(_, _, module)
	if module.worldBoss then
		local id = -(module.mapId)
		enableZones[id] = "world"
		worldBosses[module.worldBoss] = id
	else
		enableZones[module.instanceId] = true
	end

	local id = module.otherMenu or module.instanceId or -(module.mapId)
	if type(menus[id]) ~= "table" then menus[id] = {} end
	menus[id][#menus[id]+1] = module
end
public.RegisterMessage(mod, "BigWigs_BossModuleRegistered")

function mod:BigWigs_CoreEnabled()
	dataBroker.icon = "Interface\\AddOns\\BigWigs\\Media\\Textures\\icons\\core-enabled"

	-- Send a version query on enable, should fix issues with joining a group then zoning into an instance,
	-- which kills your ability to receive addon comms during the loading process.
	if IsInGroup() then
		SendAddonMessage("BigWigs", versionQueryString, IsInGroup(2) and "INSTANCE_CHAT" or "RAID")
		SendAddonMessage("D4", "H\t", IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- Also request DBM versions
	end

	-- Core is loaded, nil these to force checking BigWigs.db.profile.option
	self.isFakingDBM = nil
	self.isShowingZoneMessages = nil
	self.isSoundOn = nil
end
public.RegisterMessage(mod, "BigWigs_CoreEnabled")

function mod:BigWigs_CoreDisabled()
	dataBroker.icon = "Interface\\AddOns\\BigWigs\\Media\\Textures\\icons\\core-disabled"
end
public.RegisterMessage(mod, "BigWigs_CoreDisabled")

-----------------------------------------------------------------------
-- API
--

function public:RegisterTooltipInfo(func)
	for i = 1, #tooltipFunctions do
		if tooltipFunctions[i] == func then
			error(("The function %q has already been registered."):format(func))
		end
	end
	tooltipFunctions[#tooltipFunctions+1] = func
end

function public:GetReleaseString()
	return BIGWIGS_RELEASE_STRING
end

function public:GetVersionString()
	return BIGWIGS_VERSION_STRING
end

function public:GetZoneMenus()
	return menus
end

function public:LoadZone(zone)
	loadZone(zone)
end

-----------------------------------------------------------------------
-- Slash commands
--

SLASH_BigWigs1 = "/bw"
SLASH_BigWigs2 = "/bigwigs"
SlashCmdList.BigWigs = loadCoreAndOpenOptions

SLASH_BigWigsVersion1 = "/bwv"
SlashCmdList.BigWigsVersion = function()
	if not IsInGroup() then
		sysprint(BIGWIGS_RELEASE_STRING)
		return
	end

	local function coloredNameVersion(name, version, hash)
		if not version then
			version = ""
		else
			version = ("|cFFCCCCCC(%s%s)|r"):format(version, hash and "-"..hash or "")
		end

		local _, class = UnitClass(name)
		local tbl = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class] or GRAY_FONT_COLOR
		name = name:gsub("%-.+", "*") -- Replace server names with *
		return ("|cFF%02x%02x%02x%s|r%s"):format(tbl.r*255, tbl.g*255, tbl.b*255, name, version)
	end

	local list = {}
	local unit
	if not IsInRaid() then
		list[1] = UnitName("player")
		unit = "party%d"
	else
		unit = "raid%d"
	end
	for i = 1, GetNumGroupMembers() do
		local n, s = UnitName((unit):format(i))
		if n and s and s ~= "" then n = n.."-"..s end
		if n then list[#list+1] = n end
	end

	local good = {} -- highest release users
	local ugly = {} -- old version users
	local bad = {} -- no boss mod
	local crazy = {} -- DBM users

	for i = 1, #list do
		local player = list[i]
		local usesBossMod = nil
		if usersVersion[player] then
			if usersVersion[player] < highestFoundVersion then
				ugly[#ugly + 1] = coloredNameVersion(player, usersVersion[player], usersHash[player])
			else
				good[#good + 1] = coloredNameVersion(player, usersVersion[player], usersHash[player])
			end
			usesBossMod = true
		end
		if usersDBM[player] then
			crazy[#crazy+1] = coloredNameVersion(player, usersDBM[player])
			usesBossMod = true
		end
		if not usesBossMod then
			bad[#bad+1] = coloredNameVersion(player, UnitIsConnected(player) == false and L.offline)
		end
	end

	if #good > 0 then print(L.upToDate, unpack(good)) end
	if #ugly > 0 then print(L.outOfDate, unpack(ugly)) end
	if #crazy > 0 then print(L.dbmUsers, unpack(crazy)) end
	if #bad > 0 then print(L.noBossMod, unpack(bad)) end
end

-------------------------------------------------------------------------------
-- Global
--

BigWigsLoader = setmetatable({}, { __index = public, __newindex = function() end, __metatable = false })
