
local L = BigWigsAPI:GetLocale("BigWigs")
local mod, public = {}, {}
local bwFrame = CreateFrame("Frame")

local ldb = LibStub("LibDataBroker-1.1")
local ldbi = LibStub("LibDBIcon-1.0")

local strfind = string.find

-----------------------------------------------------------------------
-- Generate our version variables
--

local BIGWIGS_VERSION = 379
local CONTENT_PACK_VERSIONS = {
	["LittleWigs"] = {11, 1, 21},
	["BigWigs_Classic"] = {11, 1, 2},
	["BigWigs_WrathOfTheLichKing"] = {11, 1, 2},
	["BigWigs_Cataclysm"] = {11, 1, 2},
}
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
	tbl.version = BIGWIGS_VERSION
	public.isRetail = tbl.isRetail
	public.isClassic = tbl.isClassic
	public.isVanilla = tbl.isVanilla
	public.season = tbl.season
	public.isSeasonOfDiscovery = tbl.isSeasonOfDiscovery
	public.isTBC = tbl.isTBC
	public.isWrath = tbl.isWrath
	public.isCata = tbl.isCata
	public.dbmPrefix = "D5"
	public.littlewigsVersionString = L.missingAddOnPopup:format("LittleWigs")

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
	tbl.versionHash = myGitHash

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
local Ambiguate, UnitNameUnmodified, UnitGUID = Ambiguate, UnitNameUnmodified, UnitGUID
local debugstack, print = debugstack, print
local myLocale = GetLocale()
local myName = UnitNameUnmodified("player")

-- Try to grab unhooked copies of critical funcs (hooked by some crappy addons)
public.date = date
public.Ambiguate = Ambiguate
public.CTimerAfter = CTimerAfter
public.CTimerNewTicker = CTimerNewTicker
public.CTimerNewTimer = C_Timer.NewTimer
public.DoCountdown = C_PartyInfo.DoCountdown
public.GetBestMapForUnit = GetBestMapForUnit
public.GetInstanceInfo = GetInstanceInfo
public.GetMapInfo = GetMapInfo
public.GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID
public.GetSpellCooldown = C_Spell.GetSpellCooldown
public.GetSpellDescription = C_Spell.GetSpellDescription
public.GetSpellLink = C_Spell.GetSpellLink
public.GetSpellName = C_Spell.GetSpellName
public.GetSpellTexture = C_Spell.GetSpellTexture
public.IsItemInRange = C_Item.IsItemInRange
public.PlaySoundFile = PlaySoundFile
public.RegisterAddonMessagePrefix = RegisterAddonMessagePrefix
public.SendAddonMessage = SendAddonMessage
public.SetRaidTarget = SetRaidTarget
public.SendChatMessage = SendChatMessage
public.UnitCanAttack = UnitCanAttack
public.UnitDetailedThreatSituation = UnitDetailedThreatSituation
public.UnitThreatSituation = UnitThreatSituation
public.UnitGUID = UnitGUID
public.UnitHealth = UnitHealth
public.UnitHealthMax = UnitHealthMax
public.UnitIsDeadOrGhost = UnitIsDeadOrGhost
public.UnitName = UnitNameUnmodified
public.UnitSex = UnitSex
public.UnitTokenFromGUID = UnitTokenFromGUID
public.isTestBuild = GetCurrentRegion() == 72 or GetCurrentRegion() == 90 or (IsPublicTestClient and IsPublicTestClient()) -- PTR/beta
do
	local _, _, _, build = GetBuildInfo()
	public.isBeta = build >= 120000
	public.isNext = build >= 110105
end

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
	[-2274]=true, -- Khaz Algar
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
	local lw_delves = "LittleWigs_Delves"
	local lw_cs = "LittleWigs_CurrentSeason"
	local cap = "Capping"

	if public.isVanilla then
		public.currentExpansion = {
			name = c,
			bigWigsBundled = {},
			littlewigsDefault = lw_c,
			littleWigsBundled = {},
			zones = {},
		}
	elseif public.isTBC then
		public.currentExpansion = {
			name = bc,
			bigWigsBundled = {},
			littlewigsDefault = lw_bc,
			littleWigsBundled = {},
			zones = {},
		}
	elseif public.isWrath then
		public.currentExpansion = {
			name = wotlk,
			bigWigsBundled = {},
			littlewigsDefault = lw_wotlk,
			littleWigsBundled = {},
			zones = {},
		}
	elseif public.isCata then
		public.currentExpansion = {
			name = cata,
			bigWigsBundled = {},
			littlewigsDefault = lw_cata,
			littleWigsBundled = {},
			zones = {},
		}
	--elseif public.isBeta and public.isTestBuild then -- Retail Beta
	--	public.currentExpansion = { -- Change on new expansion releases
	--		name = tww,
	--		bigWigsBundled = {
	--			[df] = true,
	--			[tww] = true,
	--		},
	--		littlewigsDefault = lw_cs,
	--		littleWigsBundled = {
	--			[lw_df] = true,
	--			[lw_tww] = true,
	--			[lw_delves] = true,
	--			[lw_cs] = true,
	--		},
	--		littleWigsExtras = {
	--			lw_delves,
	--			lw_cs,
	--		},
	--		zones = {
	--			[2657] = "BigWigs_NerubarPalace",
	--		}
	--	}
	else -- Retail
		public.currentExpansion = { -- Change on new expansion releases
			name = tww,
			bigWigsBundled = {
				[tww] = true,
			},
			littlewigsDefault = lw_cs,
			littleWigsBundled = {
				[lw_tww] = true,
				[lw_delves] = true,
				[lw_cs] = true,
			},
			littleWigsExtras = {
				lw_delves,
				lw_cs,
			},
			zones = {
				[2657] = "BigWigs_NerubarPalace",
				[2769] = "BigWigs_LiberationOfUndermine",
			}
		}
	end

	public.zoneTbl = {
		[533] = public.isVanilla and c or wotlk, -- Naxxramas
		[249] = public.isVanilla and c or wotlk, -- Onyxia's Lair
		[568] = (public.isTBC or public.isWrath) and bc or lw_cata, -- Zul'Aman
		[-947] = public.isClassic and c or bfa, -- Azeroth (Fake Menu)

		--[[ BigWigs: Classic ]]--
		[48] = public.isSeasonOfDiscovery and c or nil, -- Blackfathom Deeps [Classic Season of Discovery Only]
		[90] = public.isSeasonOfDiscovery and c or nil, -- Gnomeregan [Classic Season of Discovery Only]
		[109] = public.isSeasonOfDiscovery and c or nil, -- Sunken Temple [Classic Season of Discovery Only]
		[309] = c, -- Zul'Gurub [Classic Only, dungeon has a different ID]
		[409] = c, -- Molten Core
		[469] = c, -- Blackwing Lair
		[509] = c, -- Ruins of Ahn'Qiraj
		[531] = c, -- Ahn'Qiraj Temple
		[2789] = public.isSeasonOfDiscovery and c or nil, -- The Tainted Scar (Lord Kazzak) [Classic Season of Discovery Only]
		[2791] = public.isSeasonOfDiscovery and c or nil, -- Storm Cliffs (Azuregos) [Classic Season of Discovery Only]
		[2804] = public.isSeasonOfDiscovery and c or nil, -- The Crystal Vale (Thunderaan) [Classic Season of Discovery Only]
		[2832] = public.isSeasonOfDiscovery and c or nil, -- Nightmare Grove (Emeriss/Lethon/Taerar/Ysondre) [Classic Season of Discovery Only]
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
		[-2274] = tww, -- Khaz Algar (Fake Menu)
		[2657] = tww, -- Nerub'ar Palace
		[2769] = tww, -- Liberation of Undermine

		--[[ LittleWigs: Classic ]]--
		[33] = not (public.isVanilla or public.isTBC or public.isWrath) and lw_cata or nil, -- Shadowfang Keep
		--[34] = lw_c, -- The Stockade
		[36] = public.isRetail and {lw_c, lw_cata} or public.isCata and lw_cata or lw_c, -- Deadmines
		--[43] = lw_c, -- Wailing Caverns
		--[47] = lw_c, -- Razorfen Kraul
		--[48] = lw_c, -- Blackfathom Deeps
		--[70] = lw_c, -- Uldaman
		--[90] = lw_c, -- Gnomeregan
		--[109] = lw_c, -- Sunken Temple
		--[129] = lw_c, -- Razorfen Downs
		--[189] = lw_c, -- Scarlet Monastery
		[209] = lw_c, -- Zul'Farrak
		[229] = lw_c, -- Blackrock Spire
		--[230] = lw_c, -- Blackrock Depths
		--[289] = lw_c, -- Scholomance
		[329] = lw_c, -- Stratholme
		--[349] = lw_c, -- Maraudon
		--[389] = lw_c, -- Ragefire Chasm
		[429] = lw_c, -- Dire Maul
		[2784] = public.isSeasonOfDiscovery and lw_c or nil, -- Demon Fall Canyon [Classic Season of Discovery Only]
		[2875] = public.isSeasonOfDiscovery and lw_c or nil, -- Karazhan Crypts [Classic Season of Discovery Only]
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
		[940] = lw_cata, -- Hour of Twilight
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
		[1594] = public.isRetail and {lw_bfa, lw_cs} or lw_bfa, -- The Motherlode!!
		[1771] = lw_bfa, -- Tol Dagor
		[1841] = lw_bfa, -- Underrot
		[1862] = lw_bfa, -- Waycrest Manor
		[2097] = public.isRetail and {lw_bfa, lw_cs} or lw_bfa, -- Operation: Mechagon
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
		[2293] = public.isRetail and {lw_s, lw_cs} or lw_s, -- Theater of Pain
		[2441] = lw_s, -- Tazavesh, the Veiled Market
		--[[ LittleWigs: Dragonflight ]]--
		[2451] = lw_df, -- Uldaman: Legacy of Tyr
		[2515] = lw_df, -- The Azure Vault
		[2516] = lw_df, -- The Nokhud Offensive
		[2519] = lw_df, -- Neltharus
		[2520] = lw_df, -- Brackenhide Hollow
		[2521] = lw_df, -- Ruby Life Pools
		[2526] = lw_df, -- Algeth'ar Academy
		[2527] = lw_df, -- Halls of Infusion
		[2579] = lw_df, -- Dawn of the Infinite
		--[[ LittleWigs: The War Within ]]--
		[2648] = public.isRetail and {lw_tww, lw_cs} or lw_tww, -- The Rookery
		[2649] = public.isRetail and {lw_tww, lw_cs} or lw_tww, -- Priory of the Sacred Flame
		[2651] = public.isRetail and {lw_tww, lw_cs} or lw_tww, -- Darkflame Cleft
		[2652] = lw_tww, -- The Stonevault
		[2660] = lw_tww, -- Ara-Kara, City of Echoes
		[2661] = public.isRetail and {lw_tww, lw_cs} or lw_tww, -- Cinderbrew Meadery
		[2662] = lw_tww, -- The Dawnbreaker
		[2669] = lw_tww, -- City of Threads
		[2710] = lw_tww, -- Awakening the Machine
		[2773] = public.isRetail and {lw_tww, lw_cs} or lw_tww, -- Operation: Floodgate
		--[[ LittleWigs: Delves ]]--
		[2664] = lw_delves, -- Fungal Folly
		[2679] = lw_delves, -- Mycomancer Cavern
		[2680] = lw_delves, -- Earthcrawl Mines
		[2681] = lw_delves, -- Kriegval's Rest
		[2682] = lw_delves, -- Zekvir's Lair
		[2683] = lw_delves, -- The Waterworks
		[2684] = lw_delves, -- The Dread Pit
		[2685] = lw_delves, -- Skittering Breach
		[2686] = lw_delves, -- Nightfall Sanctum
		[2687] = lw_delves, -- The Sinkhole
		[2688] = lw_delves, -- The Spiral Weave
		[2689] = lw_delves, -- Tak-Rethan Abyss
		[2690] = lw_delves, -- The Underkeep
		[2815] = lw_delves, -- Excavation Site 9
		[2826] = lw_delves, -- Sidestreet Sluice
		[2831] = lw_delves, -- Demolition Dome

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
		[-2022] = -1978, [-2023] = -1978, [-2024] = -1978, [-2085] = -1978, [-2133] = -1978, [-2200] = -1978, -- Dragon Isles
		[-2214] = -2274, [-2215] = -2274, [-2213] = -2274, [-2248] = -2274, [-2346] = -2274, -- Khaz Algar
	}
end

-----------------------------------------------------------------------
-- Utility
--

local GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local EnableAddOn = C_AddOns.EnableAddOn
local GetAddOnInfo = C_AddOns.GetAddOnInfo
local LoadAddOn = C_AddOns.LoadAddOn
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local GetAddOnDependencies = C_AddOns.GetAddOnDependencies
local GetAddOnOptionalDependencies = C_AddOns.GetAddOnOptionalDependencies
local GetNumAddOns = C_AddOns.GetNumAddOns
local IsAddOnLoadOnDemand = C_AddOns.IsAddOnLoadOnDemand
local GetAddOnEnableState = C_AddOns.GetAddOnEnableState
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

local function loadCoreAndOptions()
	loadAndEnableCore()
	load(BigWigsOptions, "BigWigs_Options")
end

do
	local _, tbl = ...
	tbl.LoadCoreAndOptions = loadCoreAndOptions
end

local function loadCoreAndOpenOptions()
	loadCoreAndOptions()
	if BigWigsOptions then
		BigWigsOptions:Open()
	end
end

local function Popup(msg, focus)
	local frame = CreateFrame("Frame")
	frame:SetFrameStrata("DIALOG")
	frame:SetToplevel(true)
	frame:SetSize(400, 150)
	frame:SetPoint("CENTER", "UIParent", "CENTER")
	local text = frame:CreateFontString(nil, "ARTWORK", "GameFontRedLarge")
	text:SetSize(380, 0)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("TOP")
	text:SetNonSpaceWrap(true)
	text:SetPoint("TOP", 0, -16)
	local border = CreateFrame("Frame", nil, frame, focus and "DialogBorderOpaqueTemplate" or "DialogBorderTemplate")
	border:SetAllPoints(frame)
	local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	button:SetSize(128, 32)
	button:SetPoint("BOTTOM", 0, 16)
	button:SetScript("OnClick", function(self)
		self:GetParent():Hide()
	end)
	button:SetText(L.okay)
	button:SetNormalFontObject("DialogButtonNormalText")
	button:SetHighlightFontObject("DialogButtonHighlightText")

	text:SetText(msg)
	frame:Show()
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
	tt:AddLine(L.tooltipHint, 0.2, 1, 0.2, true)
end

-----------------------------------------------------------------------
-- Version listing functions
--

tooltipFunctions[#tooltipFunctions+1] = function(tt)
	for _, version in next, usersVersion do
		if version < highestFoundVersion then
			tt:AddLine(L.oldVersionsInGroup, 1, 1, 1, true)
			break
		end
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

		if GetAddOnEnableState(name, myName) == 2 then -- if addonState ~= "DISABLED" then (only works when disabled on ALL characters)
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
			local minVersion = GetAddOnMetadata(i, "X-BigWigs-Minimum")
			if minVersion and GetAddOnDependencies(i) == "BigWigs" then -- Safety
				local version = tonumber(minVersion)
				if version and version > BIGWIGS_VERSION then
					Popup(L.outOfDateContentPopup:format(name), true)
					local msg = L.outOfDateContentRaidWarning:format(name, version, BIGWIGS_VERSION)
					sysprint(msg)
					RaidNotice_AddMessage(RaidWarningFrame, msg, {r=1,g=1,b=1}, 90)
				end
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
							loadCoreAndOptions()
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

		-- check LittleWigs version
		if name == "LittleWigs" then
			if GetAddOnMetadata(i, "X-LittleWigs-Repo") then
				public.usingLittleWigsRepo = true
				public.littlewigsVersionString = L.littlewigsSourceCheckout
			else
				local version = GetAddOnMetadata(i, "Version")
				if version then
					local alpha = strfind(version, "-", nil, true)
					if alpha then
						public.littlewigsVersionString = L.littlewigsAlphaRelease:format(version)
					else
						public.littlewigsVersionString = L.littlewigsOfficialRelease:format(version)
					end
				end
			end
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

	if C_EventUtils.IsEventValid("PLAYER_MAP_CHANGED") then
		bwFrame:RegisterEvent("PLAYER_MAP_CHANGED")
	end
	bwFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	bwFrame:RegisterEvent("GROUP_FORMED")
	bwFrame:RegisterEvent("GROUP_LEFT")
	bwFrame:RegisterEvent("START_PLAYER_COUNTDOWN")
	bwFrame:RegisterEvent("CANCEL_PLAYER_COUNTDOWN")
	TimerTracker:UnregisterEvent("START_PLAYER_COUNTDOWN")
	TimerTracker:UnregisterEvent("CANCEL_PLAYER_COUNTDOWN")

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
	ldbi:Register("BigWigs", dataBroker, BigWigsIconDB)

	-- Updates for BigWigsStatsDB, 11.0.0
	if type(BigWigsStatsDB) == "table" then
		local knownStats = {
			["story"]=true, ["timewalk"]=true, ["LFR"]=true, ["normal"]=true, ["heroic"]=true, ["mythic"]=true,
			["10N"]=true, ["25N"]=true, ["10H"]=true, ["25H"]=true,
			["SOD"]=true, ["level1"]=true, ["level2"]=true, ["level3"]=true, ["hardcore"]=true,
			["10"]=true,["25"]=true,["10h"]=true,["25h"]=true,["flex"]=true,["lfr"]=true,
			["N10"]=true, ["N25"]=true,["H10"]=true,["H25"]=true,
		}
		local thingsToModify = {}
		local lookup = {["10N"]="N10", ["25N"]="N25", ["10H"]="H10", ["25H"]="H25"}
		-- BigWigsStatsDB[instanceId][journalId][diff].[best|kills|wipes|fkWipes|fkDuration|fkDate|bestDate]
		for instanceId, encounters in next, BigWigsStatsDB do
			for journalId, difficulties in next, encounters do
				for diff, statEntry in next, difficulties do
					if diff == "normal" and (instanceId == 2789 or instanceId == 2791 or instanceId == 109 or instanceId == 90 or instanceId == 48) then
						-- Kazzak, Azuregos, Sunken Temple, Gnomeregan, Blackfathom Deeps
						if not thingsToModify[instanceId] then thingsToModify[instanceId] = {} end
						if not thingsToModify[instanceId][journalId] then thingsToModify[instanceId][journalId] = {} end
						thingsToModify[instanceId][journalId][diff] = true
					elseif lookup[diff] then
						if not thingsToModify[instanceId] then thingsToModify[instanceId] = {} end
						if not thingsToModify[instanceId][journalId] then thingsToModify[instanceId][journalId] = {} end
						thingsToModify[instanceId][journalId][diff] = true
					elseif not knownStats[diff] then
						sysprint("Unknown stat: ".. tostring(diff))
						geterrorhandler()("BigWigs: Unknown stat: ".. tostring(diff))
					end
				end
			end
		end
		for instanceId, encounters in next, thingsToModify do
			for journalId, difficulties in next, encounters do
				for diff, statEntry in next, difficulties do
					if diff == "normal" and (instanceId == 2789 or instanceId == 2791 or instanceId == 109 or instanceId == 90 or instanceId == 48) then
						-- Kazzak, Azuregos, Sunken Temple, Gnomeregan, Blackfathom Deeps
						BigWigsStatsDB[instanceId][journalId].SOD = BigWigsStatsDB[instanceId][journalId][diff]
						BigWigsStatsDB[instanceId][journalId][diff] = nil
					elseif lookup[diff] then
						BigWigsStatsDB[instanceId][journalId][lookup[diff]] = BigWigsStatsDB[instanceId][journalId][diff]
						BigWigsStatsDB[instanceId][journalId][diff] = nil
					end
				end
			end
		end
		-- Add old stats to new stats? [10,25,10h,25h,flex,lfr]
	end

	if BigWigs3DB then
		-- Somewhat ugly, but saves loading AceDB with the loader instead of with the core
		if BigWigs3DB.profileKeys and BigWigs3DB.profiles then
			local realm = GetRealmName()
			if myName and realm and BigWigs3DB.profileKeys[myName.." - "..realm] then
				local key = BigWigs3DB.profiles[BigWigs3DB.profileKeys[myName.." - "..realm]]
				if key then
					self.isFakingDBM = key.fakeDBMVersion
					self.isShowingZoneMessages = key.showZoneMessages
				end
				if BigWigs3DB.namespaces and BigWigs3DB.namespaces.BigWigs_Plugins_Sounds and BigWigs3DB.namespaces.BigWigs_Plugins_Sounds.profiles and BigWigs3DB.namespaces.BigWigs_Plugins_Sounds.profiles[BigWigs3DB.profileKeys[myName.." - "..realm]] then
					self.isSoundOn = BigWigs3DB.namespaces.BigWigs_Plugins_Sounds.profiles[BigWigs3DB.profileKeys[myName.." - "..realm]].sound
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
	if num < 90 then
		C_CVar.SetCVar("Sound_NumChannels", "90") -- 64 is the default, enforce a little higher as a minimum to prevent sound clipping issues with addons
	end
	num = tonumber(C_CVar.GetCVar("Sound_MaxCacheSizeInBytes")) or 0
	if num < 134217728 then
		C_CVar.SetCVar("Sound_MaxCacheSizeInBytes", "134217728") -- "Large (128MB)" is the default, enforce it as a minimum
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

function mod:START_PLAYER_COUNTDOWN(...)
	loadAndEnableCore()
	public:SendMessage("Blizz_StartCountdown", ...)
end
function mod:CANCEL_PLAYER_COUNTDOWN(...)
	loadAndEnableCore()
	public:SendMessage("Blizz_StopCountdown", ...)
end

-- We can't do our addon loading in ADDON_LOADED as the target addons may be registering that
-- which would break that event for those addons. Use this event instead.
function mod:UPDATE_FLOATING_CHAT_WINDOWS()
	bwFrame:UnregisterEvent("UPDATE_FLOATING_CHAT_WINDOWS")
	self.UPDATE_FLOATING_CHAT_WINDOWS = nil

	self:GROUP_FORMED()
	self:PLAYER_ENTERING_WORLD()
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
		BigWigs_Aberrus = "BigWigs_Dragonflight",
		BigWigs_Amirdrassil = "BigWigs_Dragonflight",
		BigWigs_DragonIsles = "BigWigs_Dragonflight",
		BigWigs_VaultOfTheIncarnates = "BigWigs_Dragonflight",
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
		BigWigs_Dragonflight = true,
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
		LittleWigs_Dragonflight = true,
		-- Dynamic content
		BigWigs_NerubarPalace = true,
		BigWigs_LiberationOfUndermine = true,
	}
	-- Try to teach people not to force load our modules.
	for i = 1, GetNumAddOns() do
		local name, _, _, _, addonState = GetAddOnInfo(i)
		if GetAddOnEnableState(name, myName) == 2 and not IsAddOnLoadOnDemand(i) then -- if addonState ~= "DISABLED" and not IsAddOnLoadOnDemand(i) then (only works when disabled on ALL characters)
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
						Popup(msg, true)
					end
				end
			else
				local msg = L.removeAddOn:format(name, old[name])
				delayedMessages[#delayedMessages+1] = msg
				Popup(msg, true)
			end
		end

		if reqFuncAddons[name] then
			foundReqAddons[name] = true -- A required functional addon is found
		end

		if name == public.currentExpansion.name then
			printMissingExpansionAddon = false
		end

		-- Version checking
		local addonToCheck = CONTENT_PACK_VERSIONS[name]
		if addonToCheck then
			local meta = GetAddOnMetadata(i, "Version")
			local _, wowMajorStr, wowMinorStr, actualVersionStr, possibleRepoHash = strsplit("v.-", meta) -- v1.2.3-hash returns "", 1, 2, 3, hash
			local wowMajor, wowMinor, actualVersion = tonumber(wowMajorStr), tonumber(wowMinorStr), tonumber(actualVersionStr)
			if wowMajor and wowMinor and actualVersion then
				local versionDifference = addonToCheck[3] - actualVersion
				if addonToCheck[1] ~= wowMajor or addonToCheck[2] ~= wowMinor or versionDifference > 0 then -- Any version difference = chat print
					delayedMessages[#delayedMessages+1] = L.outOfDateAddOnRaidWarning:format(name,
						wowMajorStr, wowMinorStr, actualVersionStr, possibleRepoHash and "-"..possibleRepoHash or "",
						addonToCheck[1], addonToCheck[2], addonToCheck[3]
					)
				end
				if addonToCheck[1] ~= wowMajor or addonToCheck[2] ~= wowMinor or versionDifference >= 3 then -- Large version difference = popup
					Popup(L.outOfDateAddOnPopup:format(name), true)
				end
			elseif not strfind(meta, "@", nil, true) then -- Don't error for repo users
				geterrorhandler()(("BigWigs: Failed version check of %q. Got %q with split values of %q, %q, %q."):format(name, meta, tostring(wowMajorStr), tostring(wowMinorStr), tostring(actualVersionStr)))
			end
		end
	end

	if not public.usingBigWigsRepo and not guildDisableContentWarnings then -- We're not using BigWigs Git, but required functional addons are missing? Show a warning
		for k in next, reqFuncAddons do -- List of required addons (core/plugins/options)
			if not foundReqAddons[k] then -- A required functional addon is missing
				delayedMessages[#delayedMessages+1] = L.missingAddOnRaidWarning:format(k)
				Popup(L.missingAddOnPopup:format(k), true)
			end
		end
	end

	if printMissingExpansionAddon and public.isClassic then
		delayedMessages[#delayedMessages+1] = L.missingAddOnRaidWarning:format(public.currentExpansion.name)
		Popup(L.missingAddOnPopup:format(public.currentExpansion.name), true)
	else
		printMissingExpansionAddon = false
	end

	local locales = {
		--ruRU = "Russian (ruRU)",
		--zhCN = "Simplified Chinese (zhCN)",
		--zhTW = "Traditional Chinese (zhTW)",
		itIT = "Italian (itIT)",
		--koKR = "Korean (koKR)",
		esES = "Spanish (esES)",
		esMX = "Spanish (esMX)",
		--deDE = "German (deDE)",
		ptBR = "Portuguese (ptBR)",
		--frFR = "French (frFR)",
	}
	local realms = {
		--[542] = locales.frFR, -- frFR
		[3207] = locales.ptBR, [3208] = locales.ptBR, [3209] = locales.ptBR, [3210] = locales.ptBR, [3234] = locales.ptBR, -- ptBR
		[1425] = locales.esMX, [1427] = locales.esMX, [1428] = locales.esMX, -- esMX
		[1309] = locales.itIT, [1316] = locales.itIT, -- itIT
		[1378] = locales.esES, [1379] = locales.esES, [1380] = locales.esES, [1381] = locales.esES, [1382] = locales.esES, [1383] = locales.esES, -- esES
	}
	local language = locales[myLocale]
	local realmLanguage = realms[GetRealmID()]
	if public.isRetail and (language or realmLanguage) then
		delayedMessages[#delayedMessages+1] = ("BigWigs is missing translations for %s."):format(language or realmLanguage)
		delayedMessages[#delayedMessages+1] = "Can you help?"
		delayedMessages[#delayedMessages+1] = "Ask us on Discord for more info."
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
						RaidNotice_AddMessage(RaidWarningFrame, L.missingAddOnRaidWarning:format(public.currentExpansion.name), {r=1,g=1,b=1}, 120)
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
	local DBMdotRevision = "20250329042744" -- The changing version of the local client, changes with every new zip using the project-date-integer packager replacement.
	local DBMdotDisplayVersion = "11.1.12" -- "N.N.N" for a release and "N.N.N alpha" for the alpha duration.
	local DBMdotReleaseRevision = "20250329000000" -- Hardcoded time, manually changed every release, they use it to track the highest release version, a new DBM release is the only time it will change.
	local protocol = 3
	local versionPrefix = "V"
	local PForceDisable = 16

	local timer = nil
	local function sendDBMMsg()
		if IsInGroup() then
			local realm = GetRealmName()
			local normalizedPlayerRealm = realm:gsub("[%s-]+", "") -- Has to mimic DBM code
			local msg = myName.. "-" ..normalizedPlayerRealm.."\t"..protocol.."\t".. versionPrefix .."\t".. DBMdotRevision.."\t"..DBMdotReleaseRevision.."\t"..DBMdotDisplayVersion.."\t"..myLocale.."\ttrue\t"..PForceDisable
			local result = SendAddonMessage(dbmPrefix, msg, IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- LE_PARTY_CATEGORY_INSTANCE = 2
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
			if bwMsg == "Break" then
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
			if subPrefix == "BT" then
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
	{ Name = "NotInGuild", Type = "SendAddonMessageResult", EnumValue = 10 },
]]
local ResetVersionWarning
do
	local timer = nil
	local function sendMsg()
		if IsInGroup() then
			local result = SendAddonMessage("BigWigs", versionResponseString, IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- LE_PARTY_CATEGORY_INSTANCE = 2
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
					RaidNotice_AddMessage(RaidWarningFrame, msg, {r=1,g=1,b=1}, 40 + (diff * 10))
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
	local RegisterUnitTargetEvents, UnregisterUnitTargetEvents
	local areEventsRegistered = false
	do
		local eventFrames = {
			CreateFrame("Frame"), CreateFrame("Frame"), CreateFrame("Frame"), CreateFrame("Frame"), CreateFrame("Frame"), CreateFrame("Frame"),
			CreateFrame("Frame"), CreateFrame("Frame"), CreateFrame("Frame"), CreateFrame("Frame"), CreateFrame("Frame"), CreateFrame("Frame"),
		}
		local UnitIsPlayer = UnitIsPlayer
		local function UNIT_TARGET(frame, event, unit)
			local unitTarget = unit.."target"
			local guid = UnitGUID(unitTarget)
			if guid and not UnitIsPlayer(unitTarget) then
				local _, _, _, _, _, mobIdString = strsplit("-", guid)
				local mobId = tonumber(mobIdString)
				if mobId then
					local zoneId = worldBosses[mobId]
					if zoneId and loadAndEnableCore() then
						loadZone(zoneId)
						BigWigs:Enable()
					end

					public:SendMessage("BigWigs_UNIT_TARGET", mobId, unitTarget, guid)
				end
			end
		end
		for i = 1, 12 do
			eventFrames[i]:SetScript("OnEvent", UNIT_TARGET)
		end
		function RegisterUnitTargetEvents()
			areEventsRegistered = true
			eventFrames[1]:RegisterUnitEvent("UNIT_TARGET", "raid1", "raid2", "raid3", "raid4")
			eventFrames[2]:RegisterUnitEvent("UNIT_TARGET", "raid5", "raid6", "raid7", "raid8")
			eventFrames[3]:RegisterUnitEvent("UNIT_TARGET", "raid9", "raid10", "raid11", "raid12")
			eventFrames[4]:RegisterUnitEvent("UNIT_TARGET", "raid13", "raid14", "raid15", "raid16")
			eventFrames[5]:RegisterUnitEvent("UNIT_TARGET", "raid17", "raid18", "raid19", "raid20")
			eventFrames[6]:RegisterUnitEvent("UNIT_TARGET", "raid21", "raid22", "raid23", "raid24")
			eventFrames[7]:RegisterUnitEvent("UNIT_TARGET", "raid25", "raid26", "raid27", "raid28")
			eventFrames[8]:RegisterUnitEvent("UNIT_TARGET", "raid29", "raid30", "raid31", "raid32")
			eventFrames[9]:RegisterUnitEvent("UNIT_TARGET", "raid33", "raid34", "raid35", "raid36")
			eventFrames[10]:RegisterUnitEvent("UNIT_TARGET", "raid37", "raid38", "raid39", "raid40")
			eventFrames[11]:RegisterUnitEvent("UNIT_TARGET", "party1", "party2", "party3", "party4")
			eventFrames[12]:RegisterUnitEvent("UNIT_TARGET", "player")
		end
		function UnregisterUnitTargetEvents()
			areEventsRegistered = false
			for i = 1, 12 do
				eventFrames[i]:UnregisterEvent("UNIT_TARGET")
			end
		end
	end

	local warnedThisZone = {}
	function mod:PLAYER_ENTERING_WORLD() -- Raid bosses
		-- Zone checking
		local _, instanceType, _, _, _, _, _, id = GetInstanceInfo()

		-- Module loading
		if enableZones[id] then
			if loadAndEnableCore() then
				loadZone(id)
			end
			RegisterUnitTargetEvents()
			bwFrame:UnregisterEvent("ZONE_CHANGED")
		else
			if BigWigs3DB and BigWigs3DB.breakTime then -- Break timer restoration
				loadAndEnableCore()
			end
			if disabledZones and disabledZones[id] then -- We have content for the zone but it is disabled in the addons menu
				local msg = L.disabledAddOn:format(disabledZones[id])
				sysprint(msg)
				Popup(msg)
				RaidNotice_AddMessage(RaidWarningFrame, msg, {r=1,g=1,b=1}, 15)
				-- Only print once
				warnedThisZone[id] = true
				disabledZones[id] = nil
			end
			if instanceType == "none" then
				bwFrame:RegisterEvent("ZONE_CHANGED")
				self:ZONE_CHANGED()
			else
				bwFrame:UnregisterEvent("ZONE_CHANGED")
				UnregisterUnitTargetEvents()
			end
		end

		-- Lacking zone modules
		if (BigWigs and BigWigs.db.profile.showZoneMessages == false) or mod.isShowingZoneMessages == false then return end
		local zoneAddon = public.zoneTbl[id]
		if type(zoneAddon) == "table" then
			-- default to the expansion addon for current season modules
			zoneAddon = zoneAddon[1]
		end
		if zoneAddon and id > 0 and not fakeZones[id] and not warnedThisZone[id] then
			if public.usingBigWigsRepo and public.currentExpansion.bigWigsBundled[zoneAddon] then return end -- If we are a BW Git user, then bundled content can't be missing, so return
			if strfind(zoneAddon, "LittleWigs", nil, true) and public.usingLittleWigsRepo then return end -- If we are a LW Git user, then nothing can be missing, so return
			if public.currentExpansion.zones[id] then
				if guildDisableContentWarnings then return end
				zoneAddon = public.currentExpansion.zones[id] -- Current BigWigs content has individual zone specific addons
			elseif public.currentExpansion.littleWigsBundled[zoneAddon] then
				zoneAddon = "LittleWigs" -- Bundled LittleWigs content is stored in the main addon
			end
			if public:GetAddOnState(zoneAddon) == "MISSING" then
				warnedThisZone[id] = true
				Popup(L.missingAddOnPopup:format(zoneAddon))
				local msg = L.missingAddOnRaidWarning:format(zoneAddon)
				sysprint(msg)
				RaidNotice_AddMessage(RaidWarningFrame, msg, {r=1,g=1,b=1}, 20)
			end
		end
	end
	function mod:PLAYER_MAP_CHANGED(oldId, newId)
		if oldId ~= -1 then -- Skip non-delve events
			if enableZones[newId] then
				CTimerAfter(0, mod.PLAYER_ENTERING_WORLD) -- Unfortunately, GetInstanceInfo() is not accurate until 1 frame later
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
			if not areEventsRegistered then
				RegisterUnitTargetEvents()
			end
		elseif areEventsRegistered then
			UnregisterUnitTargetEvents()
		end
	end
end

do
	local grouped = nil
	function mod:GROUP_FORMED()
		local groupType = (IsInGroup(2) and 3) or (IsInRaid() and 2) or (IsInGroup() and 1) -- LE_PARTY_CATEGORY_INSTANCE = 2
		if (not grouped and groupType) or (grouped and groupType and grouped ~= groupType) then
			grouped = groupType
			local result = SendAddonMessage("BigWigs", versionQueryString, groupType == 3 and "INSTANCE_CHAT" or "RAID")
			if type(result) == "number" and result ~= 0 then
				sysprint("Failed to ask for versions. Error code: ".. result)
				geterrorhandler()("BigWigs: Failed to ask for versions. Error code: ".. result)
			end
			local realm = GetRealmName()
			local normalizedPlayerRealm = realm:gsub("[%s-]+", "") -- Has to mimic DBM code
			local dbmResult = SendAddonMessage(dbmPrefix, myName.. "-" ..normalizedPlayerRealm.."\t1\tH\t", groupType == 3 and "INSTANCE_CHAT" or "RAID") -- Also request DBM versions
			if type(dbmResult) == "number" and dbmResult ~= 0 then
				sysprint("Failed to ask for _ versions. Error code: ".. dbmResult)
				geterrorhandler()("BigWigs: Failed to ask for _ versions. Error code: ".. dbmResult)
			end
		elseif grouped and not groupType then
			grouped = nil
			ResetVersionWarning()
			usersVersion = {}
			usersHash = {}
		end
	end
	mod.GROUP_LEFT = mod.GROUP_FORMED
end

function mod:BigWigs_BossModuleRegistered(_, _, module)
	if module.worldBoss then
		local id = -(module.mapId)
		enableZones[id] = "world"
		if type(module.worldBoss) == "table" then
			for i = 1, #module.worldBoss do
				worldBosses[module.worldBoss[i]] = id
			end
		else
			worldBosses[module.worldBoss] = id
		end
	elseif type(module.instanceId) == "table" then
		for i = 1, #module.instanceId do
			enableZones[module.instanceId[i]] = true
		end
	else
		enableZones[module.instanceId] = true
	end

	local id = module.otherMenu or module.instanceId or -(module.mapId)
	if type(id) == "table" then
		-- for multi-zone modules, create a menu for each zone
		for i = 1, #id do
			if type(menus[id[i]]) ~= "table" then menus[id[i]] = {} end
			menus[id[i]][#menus[id[i]]+1] = module
		end
	else
		if type(menus[id]) ~= "table" then menus[id] = {} end
		menus[id][#menus[id]+1] = module
	end
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

function public:IsAddOnEnabled(name)
	local addonState = GetAddOnEnableState(name, myName)
	return addonState == 2
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
local UnitInPartyIsAI = UnitInPartyIsAI
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
		list[1] = myName
		unit = "party%d"
	else
		unit = "raid%d"
	end
	for i = 1, GetNumGroupMembers() do
		local unitToken = (unit):format(i)
		if not UnitInPartyIsAI or not UnitInPartyIsAI(unitToken) then -- Filter AI units from version list
			local n, s = UnitNameUnmodified(unitToken)
			if n and s and s ~= "" then n = n.."-"..s end
			if n then list[#list+1] = n end
		end
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

-- XXX Temp locale compat
local tempLocale = BigWigsAPI:NewLocale("BigWigs: Plugins", myLocale)
if tempLocale then
	for k,v in next, L do
		tempLocale[k] = v
	end
end
