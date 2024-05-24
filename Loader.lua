
local L = BigWigsAPI:GetLocale("BigWigs")
local mod, public = {}, {}
local bwFrame = CreateFrame("Frame")

local ldb = LibStub("LibDataBroker-1.1")
local ldbi = LibStub("LibDBIcon-1.0")

local strfind = string.find

-----------------------------------------------------------------------
-- Generate our version variables
--

local BIGWIGS_VERSION = 331
local BIGWIGS_RELEASE_STRING, BIGWIGS_VERSION_STRING
local versionQueryString, versionResponseString = "Q^%d^%s^%d^%s", "V^%d^%s^%d^%s"
local customGuildName = false
local BIGWIGS_GUILD_VERSION = 0
local guildWarnMessage = ""
local guildDisableContentWarnings = false

do
	local _, tbl = ...
	tbl.loaderPublic = public
	tbl.loaderPrivate = mod
	public.isRetail = tbl.isRetail
	public.isClassic = tbl.isClassic
	public.isVanilla = tbl.isVanilla
	public.isTBC = tbl.isTBC
	public.isWrath = tbl.isWrath
	public.isCata = tbl.isCata
	public.dbmPrefix = "D5"

	-- START: MAGIC PACKAGER VOODOO VERSION STUFF
	local REPO = "REPO"
	local ALPHA = "ALPHA"

	local releaseType
	local myGitHash = "@project-abbreviated-hash@" -- The ZIP packager will replace this with the Git hash.
	local releaseString
	--@alpha@
	-- The following code will only be present in alpha ZIPs.
	releaseType = ALPHA
	--@end-alpha@

	-- If we find "@" then we're running from Git directly.
	if strfind(myGitHash, "@", nil, true) then
		myGitHash = "repo"
		releaseType = REPO
		public.usingBigWigsRepo = true
	end

	if releaseType == REPO then
		releaseString = L.sourceCheckout:format(BIGWIGS_VERSION)
	elseif releaseType == ALPHA then
		releaseString = L.alphaRelease:format(BIGWIGS_VERSION, myGitHash)
	else -- Release
		releaseString = L.officialRelease:format(BIGWIGS_VERSION, myGitHash)
	end

	-- Format is "V:version^hash^guildVersion^guildName"
	local isVersionNumber = type(tbl.guildVersion) == "number"
	local isGuildString = type(tbl.guildName) == "string"
	local isGuildWarnString = type(tbl.guildWarn) == "string"
	if isVersionNumber and isGuildString and isGuildWarnString and tbl.guildVersion > 0 and tbl.guildName:gsub(" ", "") ~= "" then
		customGuildName = tbl.guildName
		BIGWIGS_GUILD_VERSION = tbl.guildVersion
		guildWarnMessage = tbl.guildWarn
		guildDisableContentWarnings = tbl.guildDisableContentWarnings
		releaseString = L.guildRelease:format(BIGWIGS_GUILD_VERSION, BIGWIGS_VERSION)
		versionQueryString = versionQueryString:format(BIGWIGS_VERSION, myGitHash, tbl.guildVersion, tbl.guildName)
		versionResponseString = versionResponseString:format(BIGWIGS_VERSION, myGitHash, tbl.guildVersion, tbl.guildName)
		BIGWIGS_VERSION_STRING = ("%d/%d-%s"):format(BIGWIGS_GUILD_VERSION, BIGWIGS_VERSION, myGitHash)
	else
		versionQueryString = versionQueryString:format(BIGWIGS_VERSION, myGitHash, 0, "")
		versionResponseString = versionResponseString:format(BIGWIGS_VERSION, myGitHash, 0, "")
		BIGWIGS_VERSION_STRING = ("%d-%s"):format(BIGWIGS_VERSION, myGitHash)
	end

	BIGWIGS_RELEASE_STRING = releaseString
	-- END: MAGIC PACKAGER VOODOO VERSION STUFF
end

-----------------------------------------------------------------------
-- Locals
--

local tooltipFunctions = {}
local next, tonumber, type, strsplit, strsub = next, tonumber, type, strsplit, string.sub
local SendAddonMessage, RegisterAddonMessagePrefix, CTimerAfter, CTimerNewTicker = C_ChatInfo.SendAddonMessage, C_ChatInfo.RegisterAddonMessagePrefix, C_Timer.After, C_Timer.NewTicker
local GetInstanceInfo, GetBestMapForUnit, GetMapInfo = GetInstanceInfo, C_Map.GetBestMapForUnit, C_Map.GetMapInfo
local Ambiguate, UnitName, UnitGUID = Ambiguate, UnitName, UnitGUID
local debugstack, print = debugstack, print
local myLocale = GetLocale()

-- Try to grab unhooked copies of critical funcs (hooked by some crappy addons)
public.Ambiguate = Ambiguate
public.CTimerAfter = CTimerAfter
public.CTimerNewTicker = CTimerNewTicker
public.DoCountdown = C_PartyInfo.DoCountdown
public.GetBestMapForUnit = GetBestMapForUnit
public.GetInstanceInfo = GetInstanceInfo
public.GetMapInfo = GetMapInfo
public.GetSpellCooldown = C_Spell and C_Spell.GetSpellCooldown or GetSpellCooldown
public.GetSpellDescription = C_Spell and C_Spell.GetSpellDescription or GetSpellDescription
public.GetSpellLink = C_Spell and C_Spell.GetSpellLink or GetSpellLink
public.GetSpellName = C_Spell and C_Spell.GetSpellName or GetSpellInfo
public.GetSpellTexture = C_Spell and C_Spell.GetSpellTexture or GetSpellTexture
public.IsItemInRange = IsItemInRange
public.PlaySoundFile = PlaySoundFile
public.RegisterAddonMessagePrefix = RegisterAddonMessagePrefix
public.SendAddonMessage = SendAddonMessage
public.SetRaidTarget = SetRaidTarget
public.SendChatMessage = SendChatMessage
public.UnitDetailedThreatSituation = UnitDetailedThreatSituation
public.UnitGUID = UnitGUID
public.UnitHealth = UnitHealth
public.UnitHealthMax = UnitHealthMax
public.UnitName = UnitName
public.isTestBuild = GetCurrentRegion() == 72 -- PTR/beta
public.isBeta = select(4, GetBuildInfo()) >= 110000 -- XXX remove when TWW launches

-- Version
local usersHash = {}
local usersVersion = {}
local usersGuildVersion = {}
local usersGuildName = {}
local usersDBM = {}
local highestFoundVersion = BIGWIGS_VERSION
local highestFoundGuildVersion = BIGWIGS_GUILD_VERSION
local dbmPrefix = public.dbmPrefix

-- Loading
local isMouseDown = false
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
	[1716]=true, -- Broken Shore Mage Tower
	[-947]=true, -- Azeroth
	[-1647]=true, -- Shadowlands
	[-1978]=true, -- Dragon Isles
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
	local s = "BigWigs_Shadowlands"
	local df = "BigWigs_Dragonflight"
	local tww = "BigWigs_TheWarWithin"
	local lw_c = "LittleWigs_Classic"
	local lw_bc = "LittleWigs_BurningCrusade"
	local lw_wotlk = "LittleWigs_WrathOfTheLichKing"
	local lw_cata = "LittleWigs_Cataclysm"
	local lw_mop = "LittleWigs_MistsOfPandaria"
	local lw_wod = "LittleWigs_WarlordsOfDraenor"
	local lw_l = "LittleWigs_Legion"
	local lw_bfa = "LittleWigs_BattleForAzeroth"
	local lw_s = "LittleWigs_Shadowlands"
	local lw_df = "LittleWigs_Dragonflight"
	local lw_tww = "LittleWigs_TheWarWithin"
	local lw_cs = "LittleWigs_CurrentSeason"
	local cap = "Capping"

	if public.isVanilla then
		public.currentExpansion = {
			name = c,
			littlewigsName = lw_c,
			littlewigsDefault = lw_c,
			zones = {},
		}
	elseif public.isTBC then
		public.currentExpansion = {
			name = bc,
			littlewigsName = lw_bc,
			littlewigsDefault = lw_bc,
			zones = {},
		}
	elseif public.isWrath then
		public.currentExpansion = {
			name = wotlk,
			littlewigsName = lw_wotlk,
			littlewigsDefault = lw_wotlk,
			zones = {},
		}
	elseif public.isCata then
		public.currentExpansion = {
			name = cata,
			littlewigsName = lw_cata,
			littlewigsDefault = lw_cata,
			zones = {},
		}
	elseif public.isBeta then -- TWW Alpha/Beta
		public.currentExpansion = { -- Change on new expansion releases
			name = tww,
			littlewigsName = lw_tww,
			littlewigsDefault = lw_tww,
			zones = {
				[2657] = "BigWigs_NerubarPalace",
			}
		}
	else
		public.currentExpansion = { -- Change on new expansion releases
			name = df,
			littlewigsName = lw_df,
			littlewigsDefault = lw_cs,
			zones = {
				[2522] = "BigWigs_VaultOfTheIncarnates",
				[2569] = "BigWigs_Aberrus",
				[2549] = "BigWigs_Amirdrassil",
			}
		}
	end

	public.zoneTbl = {
		[533] = public.isVanilla and c or wotlk, -- Naxxramas
		[249] = public.isVanilla and c or wotlk, -- Onyxia's Lair
		[568] = (public.isTBC or public.isWrath) and bc or lw_cata, -- Zul'Aman
		[-947] = public.isClassic and c or bfa, -- Azeroth (Fake Menu)

		--[[ BigWigs: Classic ]]--
		[48] = c, -- Blackfathom Deeps [Classic Season of Discovery Only]
		[90] = c, -- Gnomeregan [Classic Season of Discovery Only]
		[109] = c, -- Sunken Temple [Classic Season of Discovery Only]
		[309] = c, -- Zul'Gurub [Classic Only]
		[409] = c, -- Molten Core
		[469] = c, -- Blackwing Lair
		[509] = c, -- Ruins of Ahn'Qiraj
		[531] = c, -- Ahn'Qiraj Temple
		--[[ BigWigs: The Burning Crusade ]]--
		[-101] = bc, -- Outland (Fake Menu)
		[-1945] = bc, -- Outland (Fake Menu) [Classic Only]
		[565] = bc, -- Gruul's Lair
		[532] = bc, -- Karazhan
		[548] = bc, -- Coilfang: Serpentshrine Cavern
		[550] = bc, -- Tempest Keep
		[544] = bc, -- Magtheridon's Lair
		[534] = bc, -- The Battle for Mount Hyjal
		[564] = bc, -- Black Temple
		[580] = bc, -- The Sunwell
		--[[ BigWigs: Wrath of the Lich King ]]--
		[616] = wotlk, -- The Eye of Eternity
		[603] = wotlk, -- Ulduar
		[624] = wotlk, -- Vault of Archavon
		[649] = wotlk, -- Trial of the Crusader
		[724] = wotlk, -- The Ruby Sanctum
		[631] = wotlk, -- Icecrown Citadel
		[615] = wotlk, -- The Obsidian Sanctum
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
		[1861] = bfa, -- Uldir
		[2070] = bfa, -- Battle Of Dazar'alor
		[2096] = bfa, -- Crucible of Storms
		[2164] = bfa, -- The Eternal Palace
		[2217] = bfa, -- Ny'alotha, the Waking City
		--[[ BigWigs: Shadowlands ]]--
		[-1647] = s, -- Shadowlands (Fake Menu)
		[2296] = s, -- Castle Nathria
		[2450] = s, -- Sanctum of Domination
		[2481] = s, -- Sepulcher of the First Ones
		--[[ BigWigs: Dragonflight ]]--
		[-1978] = df, -- Dragon Isles (Fake Menu)
		[2522] = df, -- Vault of the Incarnate
		[2569] = df, -- Aberrus, the Shadowed Crucible
		[2549] = df, -- Amirdrassil, the Dream's Hope
		--[[ BigWigs: The War Within ]]--
		[2657] = tww, -- Nerub'ar Palace

		--[[ LittleWigs: Classic ]]--
		[33] = lw_c, -- Shadowfang Keep
		--[34] = lw_c, -- The Stockade
		[36] = lw_c, -- Deadmines
		--[43] = lw_c, -- Wailing Caverns
		--[47] = lw_c, -- Razorfen Kraul
		--[48] = lw_c, -- Blackfathom Deeps
		--[70] = lw_c, -- Uldaman
		--[90] = lw_c, -- Gnomeregan
		--[109] = lw_c, -- Sunken Temple
		--[129] = lw_c, -- Razorfen Downs
		--[189] = lw_c, -- Scarlet Monastery
		--[209] = lw_c, -- Zul'Farrak
		--[229] = lw_c, -- Blackrock Spire
		--[230] = lw_c, -- Blackrock Depths
		--[289] = lw_c, -- Scholomance
		--[329] = lw_c, -- Stratholme
		--[349] = lw_c, -- Maraudon
		--[389] = lw_c, -- Ragefire Chasm
		--[429] = lw_c, -- Dire Maul
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
		[1007] = lw_mop, -- Scholomance
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
		[1716] = lw_l, -- Broken Shore Mage Tower (Fake Menu)
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
		[2212] = lw_bfa, -- Horrific Vision of Orgrimmar
		[2213] = lw_bfa, -- Horrific Vision of Stormwind
		--[[ LittleWigs: Shadowlands ]]--
		[2284] = lw_s, -- Sanguine Depths
		[2285] = lw_s, -- Spires of Ascension
		[2286] = lw_s, -- The Necrotic Wake
		[2287] = lw_s, -- Halls of Atonement
		[2289] = lw_s, -- Plaguefall
		[2290] = lw_s, -- Mists of Tirna Scithe
		[2291] = lw_s, -- De Other Side
		[2293] = lw_s, -- Theater of Pain
		[2441] = lw_s, -- Tazavesh, the Veiled Market
		--[[ LittleWigs: Dragonflight ]]--
		[2451] = {lw_df, lw_cs}, -- Uldaman: Legacy of Tyr
		[2515] = {lw_df, lw_cs}, -- The Azure Vault
		[2516] = {lw_df, lw_cs}, -- The Nokhud Offensive
		[2519] = {lw_df, lw_cs}, -- Neltharus
		[2520] = {lw_df, lw_cs}, -- Brackenhide Hollow
		[2521] = {lw_df, lw_cs}, -- Ruby Life Pools
		[2526] = {lw_df, lw_cs}, -- Algeth'ar Academy
		[2527] = {lw_df, lw_cs}, -- Halls of Infusion
		[2579] = lw_df, -- Dawn of the Infinite
		--[[ LittleWigs: The War Within ]]--
		[2648] = lw_tww, -- The Rookery
		[2649] = lw_tww, -- Priory of the Sacred Flame
		[2651] = lw_tww, -- Darkflame Cleft
		[2652] = lw_tww, -- The Stonevault
		[2660] = lw_tww, -- Ara-Kara, City of Echoes
		[2661] = lw_tww, -- Cinderbrew Meadery
		[2662] = lw_tww, -- The Dawnbreaker
		[2669] = lw_tww, -- City of Threads

		--[[ Capping ]]--
		[30] = cap, -- Alterac Valley
		[2197] = cap, -- Alterac Valley (Korrak's Revenge)
		[2107] = cap, -- Arathi Basin
		[1681] = cap, -- Arathi Basin (Snowy PvP Brawl)
		[2177] = cap, -- Arathi Basin (Players vs AI Brawl)
		[529] = cap, -- Arathi Basin (Classic)
		[1191] = cap, -- Ashran
		[2245] = cap, -- Deepwind Gorge
		[566] = cap, -- Eye of the Storm
		[968] = cap, -- Eye of the Storm (Rated BG)
		[761] = cap, -- Gilneas
		[628] = cap, -- Isle of Conquest
		[726] = cap, -- Twin Peaks
		[2106] = cap, -- Warsong Gulch
		[489] = cap, -- Warsong Gulch (Classic)
		[2118] = cap, -- Wintergrasp
	}

	public.zoneTblWorld = {
		-- Classic
		[-1447] = -947, [-1419] = -947, [-1425] = -947, [-1431] = -947, [-1440] = -947, [-1444] = -947, -- Azeroth
		[-1948] = -1945, [-1944] = -1945, -- Outland

		-- Retail
		[-104] = -101, [-100] = -101, -- Outland
		[-376] = -424, [-379] = -424, [-504] = -424, [-507] = -424, [-554] = -424, -- Pandaria
		[-542] = -572, [-543] = -572, [-534] = -572, -- Draenor
		[-630] = -619, [-634] = -619, [-641] = -619, [-650] = -619, [-680] = -619, -- Broken Isles
		[-942] = -947, -- Azeroth/BfA
		[-1536] = -1647, [-1565] = -1647, [-1525] = -1647, [-1533] = -1647, -- Shadowlands
		[-2022] = -1978, [-2023] = -1978, [-2024] = -1978, [-2085] = -1978, -- Dragon Isles
	}
end

-----------------------------------------------------------------------
-- Utility
--

local GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local EnableAddOn = C_AddOns.EnableAddOn or EnableAddOn
local GetAddOnInfo = C_AddOns.GetAddOnInfo or GetAddOnInfo
local LoadAddOn = C_AddOns.LoadAddOn or LoadAddOn
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded or IsAddOnLoaded
local GetAddOnDependencies = C_AddOns.GetAddOnDependencies or GetAddOnDependencies
local GetAddOnOptionalDependencies = C_AddOns.GetAddOnOptionalDependencies or GetAddOnOptionalDependencies
local GetNumAddOns = C_AddOns.GetNumAddOns or GetNumAddOns
local IsAddOnLoadOnDemand = C_AddOns.IsAddOnLoadOnDemand or IsAddOnLoadOnDemand
local IsInGroup, IsInRaid = IsInGroup, IsInRaid
public.EnableAddOn = EnableAddOn

local reqFuncAddons = {
	BigWigs_Core = true,
	BigWigs_Options = true,
	BigWigs_Plugins = true,
}

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

	if reqFuncAddons[index] then
		reqFuncAddons[index] = nil
		if index == "BigWigs_Core" then
			reqFuncAddons.BigWigs_Plugins = nil
		end
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
	if loadOnZone[zone] then
		loadAddons(loadOnZone[zone])
	end
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

C_PartyInfo.DoCountdown = function(num) -- Overwrite Blizz countdown
	loadAndEnableCore()
	if SlashCmdList.BIGWIGSPULL then
		SlashCmdList.BIGWIGSPULL(num)
	end
end

-----------------------------------------------------------------------
-- LDB Plugin
--

local dataBroker = ldb:NewDataObject("BigWigs",
	{type = "launcher", label = "BigWigs", icon = "Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_disabled.tga"}
)

function dataBroker.OnClick(self, button)
	-- If you are a dev and need the BigWigs options loaded to do something, please come talk to us on Discord about your use case
	if button == "RightButton" then
		--if isMouseDown then
			loadCoreAndOpenOptions()
		--else
		--	local trace = debugstack(2)
		--	public.mstack = trace
		--	sysprint("|cFFff0000WARNING!|r")
		--	sysprint("One of your addons was prevented from force loading the BigWigs options.")
		--	sysprint("Contact us on the BigWigs Discord about this, it should not be happening.")
		--end
	end
end

function dataBroker.OnTooltipShow(tt)
	tt:AddLine("BigWigs")
	if BigWigs and BigWigs:IsEnabled() then
		local added = false
		for _, module in BigWigs:IterateBossModules() do
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
	local loadOnInstanceAddons = {} -- Will contain all names of addons with an X-BigWigs-LoadOn-InstanceId directive
	local loadOnWorldBoss = {} -- Addons that should load when targetting a specific mob
	local extraMenus = {} -- Addons that contain extra zone menus to appear in the GUI
	local noMenus = {} -- Addons that contain zones that shouldn't create a menu
	local blockedMenus = {} -- Zones that shouldn't create a menu

	for i = 1, GetNumAddOns() do
		local name, _, _, _, addonState = GetAddOnInfo(i)
		if reqFuncAddons[name] then
			EnableAddOn(i) -- Make sure it wasn't left disabled for whatever reason
		end

		if addonState ~= "DISABLED" then
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
					local slashName = "BIGWIGS"..strsub(slash, 2) -- strip the "/"
					_G["SLASH_"..slashName.."1"] = slash
					SlashCmdList[slashName] = function(text)
						if strfind(name, "BigWigs", nil, true) then
							-- Attempting to be smart. Only load core & config if it's a BW plugin.
							loadAndEnableCore()
							load(BigWigsOptions, "BigWigs_Options")
						end
						if load(nil, i) then -- Load the addon/plugin
							-- Call the slash command again, which should have been set by the addon.
							-- Authors, do NOT delay setting it in OnInitialize/OnEnable/etc.
							ChatFrame_ImportListToHash(SlashCmdList, hash_SlashCmdList)
							local func = hash_SlashCmdList[slash]
							if func then
								func(text)
								return
							end
						end
						-- Addon didn't register the slash command for whatever reason, print the default invalid slash message.
						local info = ChatTypeInfo["SYSTEM"]
						DEFAULT_CHAT_FRAME:AddMessage(HELP_TEXT_SIMPLE, info.r, info.g, info.b, info.id)
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
					if id and id > 0 and public.zoneTbl[id] then
						if not disabledZones then disabledZones = {} end
						disabledZones[id] = name
					end
				end
			end
		end

		-- check if LittleWigs is installed from source
		if name == "LittleWigs" and GetAddOnMetadata(i, "X-LittleWigs-Repo") then
			public.usingLittleWigsRepo = true
		end

		if next(loadOnSlash) then
			ChatFrame_ImportListToHash(SlashCmdList, hash_SlashCmdList) -- Add our slashes to the hash.
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
	if addon ~= "BigWigs" then
		-- If you are a dev and need the BigWigs options loaded to do something, please come talk to us on Discord about your use case
		--if reqFuncAddons[addon] then
		--	local trace = debugstack(2)
		--	public.lstack = trace
		--	sysprint("|cFFff0000WARNING!|r")
		--	sysprint("One of your addons is force loading the BigWigs options.")
		--	sysprint("Contact us on the BigWigs Discord about this, it should not be happening.")
		--	reqFuncAddons = {}
		--end
		return
	end

	--bwFrame:RegisterEvent("GLOBAL_MOUSE_DOWN")
	--bwFrame:RegisterEvent("GLOBAL_MOUSE_UP")

	bwFrame:RegisterEvent("ZONE_CHANGED")
	bwFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	bwFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
	if C_EventUtils.IsEventValid("START_PLAYER_COUNTDOWN") then
		bwFrame:RegisterEvent("START_PLAYER_COUNTDOWN")
		bwFrame:RegisterEvent("CANCEL_PLAYER_COUNTDOWN")
		TimerTracker:UnregisterEvent("START_PLAYER_COUNTDOWN")
		TimerTracker:UnregisterEvent("CANCEL_PLAYER_COUNTDOWN")
	end

	bwFrame:RegisterEvent("CHAT_MSG_ADDON")
	local oldResult, result = RegisterAddonMessagePrefix("BigWigs")
	if type(result) == "number" and result > 2 then
		sysprint("Failed to register the BigWigs addon message prefix. Error code: ".. result)
		geterrorhandler()("BigWigs: Failed to register the BigWigs addon message prefix. Error code: ".. result)
	end
	RegisterAddonMessagePrefix(dbmPrefix) -- DBM

	-- LibDBIcon setup
	if type(BigWigsIconDB) ~= "table" then
		BigWigsIconDB = {}
	end
	ldbi:Register("BigWigs", dataBroker, BigWigsIconDB, "Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid.tga")

	-- XXX Classic DB Migration
	-- Overwrite BigWigs3DB with BigWigsClassicDB
	if type(BigWigsClassicDB) == "table" then
		if not public.isRetail and next(BigWigsClassicDB) then
			BigWigs3DB = BigWigsClassicDB
		end
		BigWigsClassicDB = nil
	end
	-- Merge BigWigsStatsClassicDB into BigWigsStatsDB
	if type(BigWigsStatsClassicDB) == "table" then
		if not BigWigsStatsDB then
			BigWigsStatsDB = {}
		end
		local encounterToJournal = {
			[655]=-655,[662]=-662,[784]=-784,[785]=-785,[786]=-786,[787]=-787,[788]=-788,[789]=-789,[790]=-790,[791]=-791,[792]=-792,[793]=-793, -- No EJ for Opera, Nightbane and all of ZG
			[663]=1519,[664]=1520,[665]=1521,[666]=1522,[667]=1523,[668]=1524,[669]=1525,[670]=1526,[671]=1527,[672]=1528,[610]=1529,[611]=1530,[612]=1531,[613]=1532,[614]=1533,[615]=1534,[616]=1535,[617]=1536,[718]=1537,[719]=1538,[720]=1539,[721]=1540,[722]=1541,[723]=1542,[709]=1543,[711]=1544,[712]=1545,[714]=1546,[710]=1547,[713]=1548,[715]=1549,[716]=1550,[717]=1551,[1107]=1601,[1110]=1602,[1116]=1603,[1117]=1604,[1112]=1605,[1115]=1606,[1113]=1607,[1109]=1608,[1121]=1609,[1118]=1610,[1111]=1611,[1108]=1612,[1120]=1613,[1119]=1614,[1114]=1615,[1084]=1651,
			[652]=1553,[653]=1554,[654]=1555,[656]=1557,[658]=1559,[657]=1560,[659]=1561,[661]=1563,[649]=1564,[650]=1565,[651]=1566,[623]=1567,[624]=1568,[625]=1569,[626]=1570,[627]=1571,[628]=1572,[730]=1573,[731]=1574,[732]=1575,[733]=1576,[618]=1577,[619]=1578,[620]=1579,[621]=1580,[622]=1581,[601]=1582,[602]=1583,[603]=1584,[604]=1585,[605]=1586,[606]=1587,[607]=1588,[608]=1589,[609]=1590,[724]=1591,[725]=1592,[726]=1593,[727]=1594,[728]=1595,[729]=1596,[1189]=186,[1190]=187,[1191]=188,[1192]=189,[1193]=190,[1194]=191,
			[1126]=1597,[1127]=1598,[1128]=1599,[1129]=1600,[1090]=1616,[1094]=1617,[1088]=1618,[1087]=1619,[1086]=1621,[1089]=1622,[1085]=1623,[1101]=1624,[1100]=1625,[1099]=1626,[1096]=1628,[1097]=1629,[1104]=1630,[1102]=1631,[1095]=1632,[1103]=1633,[1098]=1634,[1105]=1635,[1106]=1636,[1132]=1637,[1136]=1638,[1139]=1639,[1142]=1640,[1140]=1641,[1137]=1642,[1131]=1643,[1135]=1644,[1141]=1645,[1133]=1646,[1138]=1647,[1134]=1648,[1143]=1649,[1130]=1650,[1150]=1652,
		}
		local sDB = BigWigsStatsDB -- BigWigsStatsDB[instanceId][journalId][diff].[best|kills|wipes]
		for instanceId, encounters in next, BigWigsStatsClassicDB do
			if not sDB[instanceId] then sDB[instanceId] = {} end
			for engageId, difficulties in next, encounters do
				local olddb = difficulties.raid -- should be the only possible entry
				local id = encounterToJournal[engageId] -- need to convert engageId -> journalId
				if olddb and id then
					if not sDB[instanceId][id] then sDB[instanceId][id] = { normal = {} } end
					if not sDB[instanceId][id].normal then sDB[instanceId][id].normal = {} end
					local newdb = sDB[instanceId][id].normal
					if olddb.best and (not newdb.best or olddb.best < newdb.best) then
						newdb.best = olddb.best
					end
					if olddb.kills then
						newdb.kills = (newdb.kills or 0) + olddb.kills
					end
					if olddb.wipes then
						newdb.wipes = (newdb.wipes or 0) + olddb.wipes
					end
				end
			end
		end
		BigWigsStatsClassicDB = nil
	end

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
				if strfind(k, "BigWigs_Bosses_", nil, true) and not next(v) then
					BigWigs3DB.namespaces[k] = nil
				end
			end
		end
	end
	self:BigWigs_CoreOptionToggled(nil, "fakeDBMVersion", self.isFakingDBM)

	local num = tonumber(C_CVar.GetCVar("Sound_NumChannels")) or 0
	if num < 64 then
		C_CVar.SetCVar("Sound_NumChannels", "64") -- Blizzard keeps screwing with addon sound priority so we force this minimum
	end
	num = tonumber(C_CVar.GetCVar("Sound_MaxCacheSizeInBytes")) or 0
	if num < 67108864 then
		C_CVar.SetCVar("Sound_MaxCacheSizeInBytes", "67108864") -- Set the cache to the "Small (64MB)" setting as a minimum
	end

	--bwFrame:UnregisterEvent("ADDON_LOADED")
	--self.ADDON_LOADED = nil
end

function mod:GLOBAL_MOUSE_DOWN(button)
	if button == "RightButton" then
		isMouseDown = true
	end
end

function mod:GLOBAL_MOUSE_UP(button)
	if button == "RightButton" then
		isMouseDown = false
	end
end

function mod:START_PLAYER_COUNTDOWN(initiatedBy, timeSeconds, totalTime)
	loadAndEnableCore()
	if BigWigs and BigWigs.GetPlugin then -- XXX Clean this up
		BigWigs:GetPlugin("Pull"):START_PLAYER_COUNTDOWN(nil, initiatedBy, timeSeconds, totalTime)
	end
end
function mod:CANCEL_PLAYER_COUNTDOWN(initiatedBy)
	loadAndEnableCore()
	if BigWigs and BigWigs.GetPlugin then -- XXX Clean this up
		BigWigs:GetPlugin("Pull"):CANCEL_PLAYER_COUNTDOWN(nil, initiatedBy)
	end
end

-- We can't do our addon loading in ADDON_LOADED as the target addons may be registering that
-- which would break that event for those addons. Use this event instead.
function mod:UPDATE_FLOATING_CHAT_WINDOWS()
	bwFrame:UnregisterEvent("UPDATE_FLOATING_CHAT_WINDOWS")
	self.UPDATE_FLOATING_CHAT_WINDOWS = nil

	self:GROUP_ROSTER_UPDATE()
	self:PLAYER_ENTERING_WORLD()
	self:ZONE_CHANGED()
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
		BigWigs_TayakIcons = "BigWigs",
		BigWigs_PizzaBar = "BigWigs",
		BigWigs_ShaIcons = "BigWigs",
		BigWigs_LeiShi_Marker = "BigWigs",
		BigWigs_NoPluginWarnings = "BigWigs",
		LFG_ProposalTime = "BigWigs",
		CourtOfStarsGossipHelper = "LittleWigs",
		BigWigs_DispelResist = "Abandoned",
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
		BigWigs_Azeroth = "BigWigs_BattleForAzeroth",
		BigWigs_BattleOfDazaralor = "BigWigs_BattleForAzeroth",
		BigWigs_CrucibleOfStorms = "BigWigs_BattleForAzeroth",
		BigWigs_EternalPalace = "BigWigs_BattleForAzeroth",
		BigWigs_Nyalotha = "BigWigs_BattleForAzeroth",
		BigWigs_Uldir = "BigWigs_BattleForAzeroth",
		BigWigs_Shadowlands = "BigWigs_Shadowlands",
		BigWigs_CastleNathria = "BigWigs_Shadowlands",
		BigWigs_SanctumOfDomination = "BigWigs_Shadowlands",
		BigWigs_SepulcherOfTheFirstOnes = "BigWigs_Shadowlands",
	}
	local delayedMessages = {}
	local foundReqAddons = {} -- Deciding whether or not we show a warning for core/options/plugins addons not existing
	local printMissingExpansionAddon = true

	local warning = "The addon '|cffffff00%s|r' is forcing %s to load prematurely, notify the BigWigs authors!"
	local dontForceLoadList = {
		-- Static content
		BigWigs_Core = true,
		BigWigs_Plugins = true,
		BigWigs_Options = true,
		BigWigs_Classic = true,
		BigWigs_BurningCrusade = true,
		BigWigs_WrathOfTheLichKing = true,
		BigWigs_Cataclysm = true,
		BigWigs_MistsOfPandaria = true,
		BigWigs_WarlordsOfDraenor = true,
		BigWigs_Legion = true,
		BigWigs_BattleForAzeroth = true,
		BigWigs_Shadowlands = true,
		LittleWigs = true,
		LittleWigs_Classic = true,
		LittleWigs_BurningCrusade = true,
		LittleWigs_WrathOfTheLichKing = true,
		LittleWigs_Cataclysm = true,
		LittleWigs_MistsOfPandaria = true,
		LittleWigs_WarlordsOfDraenor = true,
		LittleWigs_Legion = true,
		LittleWigs_BattleForAzeroth = true,
		LittleWigs_Shadowlands = true,
		-- Dynamic content
		BigWigs_DragonIsles = true,
		BigWigs_VaultOfTheIncarnates = true,
		BigWigs_Aberrus = true,
	}
	-- Try to teach people not to force load our modules.
	for i = 1, GetNumAddOns() do
		local name, _, _, _, addonState = GetAddOnInfo(i)
		if addonState ~= "DISABLED" and not IsAddOnLoadOnDemand(i) then
			for j = 1, select("#", GetAddOnOptionalDependencies(i)) do
				local meta = select(j, GetAddOnOptionalDependencies(i))
				local addonName = tostring(meta)
				if dontForceLoadList[addonName] then
					delayedMessages[#delayedMessages+1] = warning:format(name, addonName)
				end
			end
			for j = 1, select("#", GetAddOnDependencies(i)) do
				local meta = select(j, GetAddOnDependencies(i))
				local addonName = tostring(meta)
				if dontForceLoadList[addonName] then
					delayedMessages[#delayedMessages+1] = warning:format(name, addonName)
				end
			end
		end

		if old[name] then
			if name == "BigWigs_Shadowlands" then
				local meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-InstanceId")
				if not meta then
					local msg = L.removeAddOn:format(name, old[name])
					delayedMessages[#delayedMessages+1] = msg
					if not BasicMessageDialog:IsShown() then -- Don't overwrite other messages with this as the message is confusing, show it last
						Popup(msg)
					end
				end
			else
				local msg = L.removeAddOn:format(name, old[name])
				delayedMessages[#delayedMessages+1] = msg
				Popup(msg)
			end
		end

		if reqFuncAddons[name] then
			foundReqAddons[name] = true -- A required functional addon is found
		end

		if name == public.currentExpansion.name then
			printMissingExpansionAddon = false
		end
	end

	if not public.usingBigWigsRepo and not guildDisableContentWarnings then -- We're not using BigWigs Git, but required functional addons are missing? Show a warning
		for k in next, reqFuncAddons do -- List of required addons (core/plugins/options)
			if not foundReqAddons[k] then -- A required functional addon is missing
				local msg = L.missingAddOn:format(k)
				delayedMessages[#delayedMessages+1] = msg
				Popup(msg)
			end
		end
	end

	if printMissingExpansionAddon and public.isClassic then
		local msg = L.missingAddOn:format(public.currentExpansion.name)
		delayedMessages[#delayedMessages+1] = msg
		Popup(msg)
	else
		printMissingExpansionAddon = false
	end

	local locales = {
		--ruRU = "Russian (ruRU)",
		--zhCN = "Simplified Chinese (zhCN)",
		--zhTW = "Traditional Chinese (zhTW)",
		--itIT = "Italian (itIT)",
		--koKR = "Korean (koKR)",
		--esES = "Spanish (esES)",
		--esMX = "Spanish (esMX)",
		--deDE = "German (deDE)",
		--ptBR = "Portuguese (ptBR)",
		--frFR = "French (frFR)",
	}
	local realms = {
		--[3207] = locales.ptBR, [3208] = locales.ptBR, [3209] = locales.ptBR, [3210] = locales.ptBR, [3234] = locales.ptBR, -- ptBR
		--[1425] = locales.esMX, [1427] = locales.esMX, [1428] = locales.esMX, -- esMX
		--[1309] = locales.itIT, [1316] = locales.itIT, -- itIT
		--[1378] = locales.esES, [1379] = locales.esES, [1380] = locales.esES, [1381] = locales.esES, [1382] = locales.esES, [1383] = locales.esES, -- esES
	}
	local language = locales[myLocale]
	local realmLanguage = realms[GetRealmID()]
	if public.isRetail and (language or realmLanguage) then
		delayedMessages[#delayedMessages+1] = ("BigWigs is missing translations for %s. Can you help? Ask us on Discord for more info."):format(language or realmLanguage)
	end

	if #delayedMessages > 0 then
		function mod:LOADING_SCREEN_DISABLED()
			bwFrame:UnregisterEvent("LOADING_SCREEN_DISABLED")
			CTimerAfter(0, function() -- Timers aren't fully functional until 1 frame after loading is done
				CTimerAfter(15, function()
					for i = 1, #delayedMessages do
						sysprint(delayedMessages[i])
					end
					if printMissingExpansionAddon then
						RaidNotice_AddMessage(RaidWarningFrame, L.missingAddOn:format(public.currentExpansion.name), {r=1,g=1,b=1}, 120)
					end
					delayedMessages = nil
				end)
			end)
			self.LOADING_SCREEN_DISABLED = nil
		end
		bwFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
	end
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

	local securecallfunction = securecallfunction
	function public:SendMessage(msg, ...)
		if callbackMap[msg] then
			for k,v in next, callbackMap[msg] do
				if type(v) == "function" then
					securecallfunction(v, msg, ...)
				else
					securecallfunction(k[v], k, msg, ...)
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
	local DBMdotRevision = "20240521061442" -- The changing version of the local client, changes with every new zip using the project-date-integer packager replacement.
	local DBMdotDisplayVersion = "10.2.42" -- "N.N.N" for a release and "N.N.N alpha" for the alpha duration.
	local DBMdotReleaseRevision = "20240520000000" -- Hardcoded time, manually changed every release, they use it to track the highest release version, a new DBM release is the only time it will change.
	local protocol = 3
	local versionPrefix = "V"
	local PForceDisable = 10

	local timer = nil
	local function sendDBMMsg()
		if IsInGroup() then
			local name = UnitName("player")
			local realm = GetRealmName()
			local normalizedPlayerRealm = realm:gsub("[%s-]+", "") -- Has to mimic DBM code
			local msg = name.. "-" ..normalizedPlayerRealm.."\t"..protocol.."\t".. versionPrefix .."\t".. DBMdotRevision.."\t"..DBMdotReleaseRevision.."\t"..DBMdotDisplayVersion.."\t"..myLocale.."\ttrue\t"..PForceDisable
			local _, result = SendAddonMessage(dbmPrefix, msg, IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- LE_PARTY_CATEGORY_INSTANCE = 2
			if type(result) == "number" and result ~= 0 then
				if result == 9 then
					timer = CTimerNewTicker(3, sendDBMMsg, 1)
					return
				else
					sysprint("Failed to send initial _ version. Error code: ".. result)
					geterrorhandler()("BigWigs: Failed to send initial _ version. Error code: ".. result)
				end
			end
		end
		timer = nil
	end
	function mod:DBM_VersionCheck(prefix, sender, _, _, displayVersion)
		if prefix == "H" and (BigWigs and BigWigs.db and BigWigs.db.profile.fakeDBMVersion or self.isFakingDBM) then
			if timer then timer:Cancel() end
			timer = CTimerNewTicker(3.3, sendDBMMsg, 1)
		elseif prefix == "V" then
			usersDBM[sender] = displayVersion
		end
	end
end

function mod:BigWigs_CoreOptionToggled(_, key, value)
	if key == "fakeDBMVersion" and value and IsInGroup() then
		self:DBM_VersionCheck("H") -- Send addon message if feature is being turned on inside a raid/group.
	end
end
public.RegisterMessage(mod, "BigWigs_CoreOptionToggled")

-----------------------------------------------------------------------
-- Events
--

bwFrame:SetScript("OnEvent", function(_, event, ...)
	mod[event](mod, ...)
end)
bwFrame:RegisterEvent("ADDON_LOADED")
bwFrame:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS")

function mod:CHAT_MSG_ADDON(prefix, msg, channel, sender)
	if channel ~= "RAID" and channel ~= "PARTY" and channel ~= "INSTANCE_CHAT" then
		return
	elseif prefix == "BigWigs" then
		local bwPrefix, bwMsg, extra, guildVersion, guildName = strsplit("^", msg)
		sender = Ambiguate(sender, "none")
		if bwPrefix == "V" or bwPrefix == "Q" then
			self:VersionCheck(bwPrefix, bwMsg, extra, guildVersion, guildName, sender)
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
	elseif prefix == dbmPrefix then
		local _, _, subPrefix, arg1, arg2, arg3, arg4 = strsplit("\t", msg)
		sender = Ambiguate(sender, "none")
		if subPrefix == "V" or subPrefix == "H" then
			self:DBM_VersionCheck(subPrefix, sender, arg1, arg2, arg3)
		elseif subPrefix == "U" or subPrefix == "PT" or subPrefix == "M" or subPrefix == "BT" then
			if subPrefix == "PT" then
				local _, _, _, instanceId = UnitPosition("player")
				local _, _, _, tarInstanceId = UnitPosition(sender)
				if instanceId == tarInstanceId then
					loadAndEnableCore() -- Force enable the core when receiving a pull timer.
				end
			elseif subPrefix == "BT" then
				loadAndEnableCore() -- Force enable the core when receiving a break timer.
			end
			public:SendMessage("DBM_AddonMessage", sender, subPrefix, arg1, arg2, arg3, arg4)
		end
	end
end

--[[
	{ Name = "Success", Type = "SendAddonMessageResult", EnumValue = 0 },
	{ Name = "InvalidPrefix", Type = "SendAddonMessageResult", EnumValue = 1 },
	{ Name = "InvalidMessage", Type = "SendAddonMessageResult", EnumValue = 2 },
	{ Name = "AddonMessageThrottle", Type = "SendAddonMessageResult", EnumValue = 3 },
	{ Name = "InvalidChatType", Type = "SendAddonMessageResult", EnumValue = 4 },
	{ Name = "NotInGroup", Type = "SendAddonMessageResult", EnumValue = 5 },
	{ Name = "TargetRequired", Type = "SendAddonMessageResult", EnumValue = 6 },
	{ Name = "InvalidChannel", Type = "SendAddonMessageResult", EnumValue = 7 },
	{ Name = "ChannelThrottle", Type = "SendAddonMessageResult", EnumValue = 8 },
	{ Name = "GeneralError", Type = "SendAddonMessageResult", EnumValue = 9 },
]]
local ResetVersionWarning
do
	local timer = nil
	local function sendMsg()
		if IsInGroup() then
			local _, result = SendAddonMessage("BigWigs", versionResponseString, IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- LE_PARTY_CATEGORY_INSTANCE = 2
			if type(result) == "number" and result ~= 0 then
				if result == 9 then
					timer = CTimerNewTicker(3, sendMsg, 1)
					return
				else
					sysprint("Failed to send initial version. Error code: ".. result)
					geterrorhandler()("BigWigs: Failed to send initial version. Error code: ".. result)
				end
			end
		end
		timer = nil
	end

	local hasWarned = 0
	local hasGuildWarned = false
	local verTimer = nil
	local verGuildTimer = nil
	function ResetVersionWarning()
		hasWarned = 0
		hasGuildWarned = false
		if verTimer then verTimer:Cancel() end -- We may have left the group whilst a warning is about to show
		if verGuildTimer then verGuildTimer:Cancel() end
		verTimer = nil
		verGuildTimer = nil
	end

	local function printOutOfDate(tbl)
		if hasWarned == 3 then return end
		local warnedOutOfDate, warnedReallyOutOfDate, warnedExtremelyOutOfDate = 0, 0, 0
		for _,version in next, tbl do
			if version > BIGWIGS_VERSION then
				warnedOutOfDate = warnedOutOfDate + 1
				if (version - 1) > BIGWIGS_VERSION then -- 2+ releases
					warnedReallyOutOfDate = warnedReallyOutOfDate + 1
					if (version - 2) > BIGWIGS_VERSION then -- 3+ releases
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
				if not customGuildName then
					local msg = L.warnSeveralReleases:format(diff)
					sysprint(msg)
					Popup(msg)
					RaidNotice_AddMessage(RaidWarningFrame, msg, {r=1,g=1,b=1}, 60)
				else
					sysprint(L.warnOldBase:format(BIGWIGS_GUILD_VERSION, BIGWIGS_VERSION, diff))
				end
			end, 1)
		elseif warnedReallyOutOfDate > 1 and hasWarned < 2 and not customGuildName then
			if verTimer then verTimer:Cancel() end
			verTimer = CTimerNewTicker(3, function()
				hasWarned = 2
				verTimer = nil
				sysprint(L.warnTwoReleases)
				RaidNotice_AddMessage(RaidWarningFrame, L.warnTwoReleases, {r=1,g=1,b=1}, 20)
			end, 1)
		elseif warnedOutOfDate > 1 and hasWarned < 1 and not customGuildName then
			if verTimer then verTimer:Cancel() end
			verTimer = CTimerNewTicker(3, function()
				hasWarned = 1
				verTimer = nil
				sysprint(L.getNewRelease)
			end, 1)
		end
	end

	local function printGuildOutOfDate(tbl)
		if hasGuildWarned then return end
		local warnedOutOfDate = 0
		for k,v in next, tbl do
			if v > BIGWIGS_GUILD_VERSION and usersGuildName[k] == customGuildName then
				warnedOutOfDate = warnedOutOfDate + 1
			end
		end
		if warnedOutOfDate > 1 and not hasGuildWarned then
			if verGuildTimer then verGuildTimer:Cancel() end
			verGuildTimer = CTimerNewTicker(3, function()
				hasGuildWarned = true
				verGuildTimer = nil
				sysprint(guildWarnMessage)
				Popup(guildWarnMessage)
			end, 1)
		end
	end

	function mod:VersionCheck(prefix, verString, hash, guildVerString, guildName, sender)
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

				local guildVersion = tonumber(guildVerString)
				if guildVersion and guildVersion > 0 then
					usersGuildVersion[sender] = guildVersion
					usersGuildName[sender] = guildName
					if customGuildName and customGuildName == guildName then
						if guildVersion > highestFoundGuildVersion then
							highestFoundGuildVersion = guildVersion
						end
						if guildVersion > BIGWIGS_GUILD_VERSION then
							printGuildOutOfDate(usersGuildVersion)
						end
					end
				end

				if version > BIGWIGS_VERSION then
					printOutOfDate(usersVersion)
				end
			end
		end
	end
end

do
	local warnedThisZone = {}
	function mod:PLAYER_ENTERING_WORLD() -- Raid bosses
		-- Zone checking
		local _, _, _, _, _, _, _, id = GetInstanceInfo()

		-- Module loading
		if enableZones[id] then
			if loadAndEnableCore() then
				loadZone(id)
			end
		elseif BigWigs3DB and BigWigs3DB.breakTime then -- Break timer restoration
			loadAndEnableCore()
		else
			if disabledZones and disabledZones[id] then -- We have content for the zone but it is disabled in the addons menu
				local msg = L.disabledAddOn:format(disabledZones[id])
				sysprint(msg)
				Popup(msg)
				RaidNotice_AddMessage(RaidWarningFrame, msg, {r=1,g=1,b=1}, 15)
				-- Only print once
				warnedThisZone[id] = true
				disabledZones[id] = nil
			end
		end

		-- Lacking zone modules
		if (BigWigs and BigWigs.db.profile.showZoneMessages == false) or self.isShowingZoneMessages == false then return end
		local zoneAddon = public.zoneTbl[id]
		if type(zoneAddon) == "table" then
			-- default to the expansion addon for current season modules
			zoneAddon = zoneAddon[1]
		end
		if zoneAddon and id > 0 and not fakeZones[id] and not warnedThisZone[id] then
			if zoneAddon == public.currentExpansion.name and public.isRetail and public.usingBigWigsRepo then return end -- If we are a BW Git user, then current content can't be missing, so return
			if strfind(zoneAddon, "LittleWigs", nil, true) and public.usingLittleWigsRepo then return end -- If we are a LW Git user, then nothing can be missing, so return
			if public.currentExpansion.zones[id] then
				if guildDisableContentWarnings then return end
				zoneAddon = public.currentExpansion.zones[id] -- Current BigWigs content has individual zone specific addons
			elseif zoneAddon == public.currentExpansion.littlewigsName and public.isRetail then
				zoneAddon = "LittleWigs" -- Current LittleWigs content is stored in the main addon
			end
			if public:GetAddOnState(zoneAddon) == "MISSING" then
				warnedThisZone[id] = true
				local msg = L.missingAddOn:format(zoneAddon)
				sysprint(msg)
				Popup(msg)
				RaidNotice_AddMessage(RaidWarningFrame, msg, {r=1,g=1,b=1}, 15)
			end
		end
	end
end

do
	function mod:UNIT_TARGET(unit)
		local unitTarget = unit.."target"
		local guid = UnitGUID(unitTarget)
		if guid then
			local _, _, _, _, _, mobId = strsplit("-", guid)
			mobId = tonumber(mobId)
			local id = mobId and worldBosses[mobId]
			if id and loadAndEnableCore() then
				loadZone(id)
				BigWigs:Enable(unitTarget)
			end
		end
	end
	function mod:ZONE_CHANGED() -- For world bosses, not useful for raids as it fires after loading has ended
		local id = 0
		local mapId = GetBestMapForUnit("player")
		if mapId then
			id = -mapId -- Use map id for world bosses
		end

		-- Module loading
		if enableZones[id] == "world" then
			bwFrame:RegisterEvent("UNIT_TARGET")
		else
			bwFrame:UnregisterEvent("UNIT_TARGET")
		end
	end
end

do
	local grouped = nil
	function mod:GROUP_ROSTER_UPDATE()
		local groupType = (IsInGroup(2) and 3) or (IsInRaid() and 2) or (IsInGroup() and 1) -- LE_PARTY_CATEGORY_INSTANCE = 2
		if (not grouped and groupType) or (grouped and groupType and grouped ~= groupType) then
			grouped = groupType
			local _, result = SendAddonMessage("BigWigs", versionQueryString, groupType == 3 and "INSTANCE_CHAT" or "RAID")
			if type(result) == "number" and result ~= 0 then
				sysprint("Failed to ask for versions. Error code: ".. result)
				geterrorhandler()("BigWigs: Failed to ask for versions. Error code: ".. result)
			end
			local name = UnitName("player")
			local realm = GetRealmName()
			local normalizedPlayerRealm = realm:gsub("[%s-]+", "") -- Has to mimic DBM code
			_, result = SendAddonMessage(dbmPrefix, name.. "-" ..normalizedPlayerRealm.."\t1\tH\t", groupType == 3 and "INSTANCE_CHAT" or "RAID") -- Also request DBM versions
			if type(result) == "number" and result ~= 0 then
				sysprint("Failed to ask for _ versions. Error code: ".. result)
				geterrorhandler()("BigWigs: Failed to ask for _ versions. Error code: ".. result)
			end
		elseif grouped and not groupType then
			grouped = nil
			ResetVersionWarning()
			usersVersion = {}
			usersHash = {}
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
	local _, _, _, _, _, _, _, id = GetInstanceInfo()
	local zoneAddon = public.zoneTbl[id]
	if type(zoneAddon) == "table" then
		-- default to the expansion addon for current season modules
		zoneAddon = zoneAddon[1]
	end
	if zoneAddon and zoneAddon:find("LittleWigs", nil, true) then
		dataBroker.icon = "Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_party.tga"
	elseif zoneAddon and zoneAddon:find("BigWigs", nil, true) and zoneAddon ~= public.currentExpansion.name then
		dataBroker.icon = "Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_legacy.tga"
	else -- Current raids, world content, anything else
		dataBroker.icon = "Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid.tga"
	end

	-- Core is loaded, nil these to force checking BigWigs.db.profile.option
	self.isFakingDBM = nil
	self.isShowingZoneMessages = nil
	self.isSoundOn = nil

	-- Make sure we've loaded everything. git checkout installs will load core
	-- immediately, but won't hit loadAndEnableCore until a boss module loads.
	-- E.g., LoD assets not being available for local, break, and pull bars.
	loadAddons(loadOnCoreEnabled)
end
public.RegisterMessage(mod, "BigWigs_CoreEnabled")

function mod:BigWigs_CoreDisabled()
	dataBroker.icon = "Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_disabled.tga"
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

function public:GetAddOnState(name)
	local _, _, _, _, addonState = GetAddOnInfo(name)
	return addonState
end

-----------------------------------------------------------------------
-- Slash commands
--

SLASH_BigWigs1 = "/bw"
SLASH_BigWigs2 = "/bigwigs"
SlashCmdList.BigWigs = function()
	-- If you are a dev and need the BigWigs options loaded to do something, please come talk to us on Discord about your use case
	--local trace = debugstack(2)
	--if strfind(trace, "[string \"*:OnEnterPressed\"]:1: in function <[string \"*:OnEnterPressed\"]:1>", nil, true) then
		loadCoreAndOpenOptions()
	--else
	--	public.stack = trace
	--	sysprint("|cFFff0000WARNING!|r")
	--	sysprint("One of your addons was prevented from force loading the BigWigs options.")
	--	sysprint("Contact us on the BigWigs Discord about this, it should not be happening.")
	--	return
	--end
end

SLASH_BigWigsVersion1 = "/bwv"
SlashCmdList.BigWigsVersion = function()
	if not IsInGroup() then
		sysprint(BIGWIGS_RELEASE_STRING)
		return
	end

	local function coloredNameVersion(name, version, hash, guildVersion)
		if not version then
			version = ""
		elseif guildVersion then
			version = ("|cFFCCCCCC(%d/%d%s)|r"):format(guildVersion, version, hash and "-"..hash or "") -- %d because BigWigs versions are always stored as a number
		else
			version = ("|cFFCCCCCC(%s%s)|r"):format(version, hash and "-"..hash or "") -- %s because DBM users are stored as a string
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
	local dbm = {} -- DBM users

	for i = 1, #list do
		local player = list[i]
		local usesBossMod = nil
		if usersVersion[player] then
			usesBossMod = true
			if customGuildName == usersGuildName[player] then
				if usersGuildVersion[player] < highestFoundGuildVersion then
					ugly[#ugly + 1] = coloredNameVersion(player, usersVersion[player], usersHash[player], usersGuildVersion[player])
				else
					good[#good + 1] = coloredNameVersion(player, usersVersion[player], usersHash[player], usersGuildVersion[player])
				end
			else
				if usersVersion[player] < highestFoundVersion then
					ugly[#ugly + 1] = coloredNameVersion(player, usersVersion[player], usersHash[player])
				else
					good[#good + 1] = coloredNameVersion(player, usersVersion[player], usersHash[player])
				end
			end
		end
		if usersDBM[player] then
			dbm[#dbm+1] = coloredNameVersion(player, usersDBM[player])
			usesBossMod = true
		end
		if not usesBossMod then
			bad[#bad+1] = coloredNameVersion(player, UnitIsConnected(player) == false and L.offline)
		end
	end

	if #good > 0 then print(L.upToDate, unpack(good)) end
	if #ugly > 0 then print(L.outOfDate, unpack(ugly)) end
	if #dbm > 0 then print(L.dbmUsers, unpack(dbm)) end
	if #bad > 0 then print(L.noBossMod, unpack(bad)) end
end

-------------------------------------------------------------------------------
-- Global
--

BigWigsLoader = setmetatable({}, { __index = public, __newindex = function() end, __metatable = false })
