
local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs")
local mod, public = {}, {}
local bwFrame = CreateFrame("Frame")

-----------------------------------------------------------------------
-- Generate our version variables
--

local BIGWIGS_VERSION = 14
local BIGWIGS_RELEASE_STRING = ""
local versionQueryString, versionResponseString = "Q:%d-%s", "V:%d-%s"

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
	-- Format is "V:version-hash"
	versionQueryString = versionQueryString:format(BIGWIGS_VERSION, myGitHash)
	versionResponseString = versionResponseString:format(BIGWIGS_VERSION, myGitHash)
	-- END: MAGIC PACKAGER VOODOO VERSION STUFF
end

-----------------------------------------------------------------------
-- Locals
--

local ldb = nil
local tooltipFunctions = {}
local next, tonumber = next, tonumber
local SendAddonMessage, Ambiguate, CTimerAfter, CTimerNewTicker = SendAddonMessage, Ambiguate, C_Timer.After, C_Timer.NewTicker
local IsInInstance, GetCurrentMapAreaID, SetMapToCurrentZone = IsInInstance, GetCurrentMapAreaID, SetMapToCurrentZone
local GetAreaMapInfo, GetInstanceInfo, GetPlayerMapAreaID = GetAreaMapInfo, GetInstanceInfo, GetPlayerMapAreaID

-- Try to grab unhooked copies of critical funcs (hooked by some crappy addons)
public.GetCurrentMapAreaID = GetCurrentMapAreaID
public.GetPlayerMapAreaID = GetPlayerMapAreaID
public.SetMapToCurrentZone = SetMapToCurrentZone
public.GetAreaMapInfo = GetAreaMapInfo
public.GetCurrentMapDungeonLevel = GetCurrentMapDungeonLevel
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
local worldBosses = {} -- contains the list of world bosses per zone that should enable the core
local fakeWorldZones = { -- Fake world zones used for world boss translations and loading
	[466]=true, -- Outland
	[862]=true, -- Pandaria
	[962]=true, -- Draenor
	[1007]=true, -- Broken Isles
}

do
	local c = "BigWigs_Classic"
	local bc = "BigWigs_BurningCrusade"
	local wotlk = "BigWigs_WrathOfTheLichKing"
	local cata = "BigWigs_Cataclysm"
	local mop = "BigWigs_MistsOfPandaria"
	local wod = "BigWigs_WarlordsOfDraenor"
	local l = "BigWigs_Legion"
	local lw_c = "LittleWigs_Classic"
	local lw_bc = "LittleWigs_BurningCrusade"
	local lw_wotlk = "LittleWigs_WrathOfTheLichKing"
	local lw_cata = "LittleWigs_Cataclysm"
	local lw_mop = "LittleWigs_MistsOfPandaria"
	local lw_wod = "LittleWigs_WarlordsOfDraenor"
	local lw_l = "LittleWigs_Legion"

	local tbl = {
		[696]=c, [755]=c, [766]=c, [717]=c,
		[775]=bc, [780]=bc, [779]=bc, [776]=bc, [799]=bc, [782]=bc, [466]=bc,
		[604]=wotlk, [543]=wotlk, [535]=wotlk, [529]=wotlk, [527]=wotlk, [532]=wotlk, [531]=wotlk, [609]=wotlk, [718]=wotlk,
		[752]=cata, [758]=cata, [754]=cata, [824]=cata, [800]=cata, [773]=cata,
		[896]=mop, [897]=mop, [886]=mop, [930]=mop, [953]=mop, [862]=mop,
		[994]=wod, [988]=wod, [1026]=wod, [962]=wod,
		[1094]=l, [1088]=l, [1007]=l, [1114]=l,

		[756]=lw_c, -- Classic
		[710]=lw_bc, [722]=lw_bc, [723]=lw_bc, [724]=lw_bc, [725]=lw_bc, [726]=lw_bc, [727]=lw_bc, [728]=lw_bc, [729]=lw_bc, [730]=lw_bc, [731]=lw_bc, [732]=lw_bc, [733]=lw_bc, [734]=lw_bc, [797]=lw_bc, [798]=lw_bc, -- TBC
		[520]=lw_wotlk, [521]=lw_wotlk, [522]=lw_wotlk, [523]=lw_wotlk, [524]=lw_wotlk, [525]=lw_wotlk, [526]=lw_wotlk, [528]=lw_wotlk, [530]=lw_wotlk, [533]=lw_wotlk, [534]=lw_wotlk, [536]=lw_wotlk, [542]=lw_wotlk, [601]=lw_wotlk, [602]=lw_wotlk, [603]=lw_wotlk, -- WotLK
		[747]=lw_cata, [757]=lw_cata, [767]=lw_cata, [768]=lw_cata, [769]=lw_cata, [820]=lw_cata, -- Cataclysm
		[877]=lw_mop, [871]=lw_mop, [874]=lw_mop, [885]=lw_mop, [867]=lw_mop, [919]=lw_mop, -- MoP
		[964]=lw_wod, [969]=lw_wod, [984]=lw_wod, [987]=lw_wod, [989]=lw_wod, [993]=lw_wod, [995]=lw_wod, [1008]=lw_wod, -- WoD
		[1041]=lw_l, [1042]=lw_l, [1045]=lw_l, [1046]=lw_l, [1065]=lw_l, [1066]=lw_l, [1067]=lw_l, [1079]=lw_l, [1081]=lw_l, [1087]=lw_l -- Legion
	}

	public.zoneTblWorld = {
		[-473] = 466, [-465] = 466, -- Outland
		[-807] = 862, [-809] = 862, [-928] = 862, [-929] = 862, [-951] = 862, -- Pandaria
		[-948] = 962, [-949] = 962, [-949] = 962, [-945] = 962, -- Draenor
		[-1015] = 1007, [-1017] = 1007, -- Broken Isles
	}
	public.fakeWorldZones = fakeWorldZones
	public.zoneTbl = {}
	for k,v in next, tbl do
		if fakeWorldZones[k] then
			public.zoneTbl[k] = v
		else
			local instanceId = GetAreaMapInfo(k)
			if instanceId then -- Protect live client from beta client ids
				public.zoneTbl[instanceId] = v
			end
		end
	end
end

-- GLOBALS: _G, ADDON_LOAD_FAILED, BigWigs, BigWigs3DB, BigWigs3IconDB, BigWigsLoader, BigWigsOptions, CreateFrame, CUSTOM_CLASS_COLORS, error, GetAddOnEnableState, GetAddOnInfo
-- GLOBALS: GetAddOnMetadata, GetLocale, GetNumGroupMembers, GetRealmName, GetSpecialization, GetSpecializationRole, GetSpellInfo, GetTime, GRAY_FONT_COLOR, InCombatLockdown
-- GLOBALS: InterfaceOptionsFrameOkay, IsAddOnLoaded, IsAltKeyDown, IsControlKeyDown, IsEncounterInProgress, IsInGroup, IsInRaid, IsLoggedIn, IsPartyLFG, IsSpellKnown, LFGDungeonReadyPopup
-- GLOBALS: LibStub, LoadAddOn, message, PlaySoundFile, print, RAID_CLASS_COLORS, RaidNotice_AddMessage, RaidWarningFrame, RegisterAddonMessagePrefix, RolePollPopup, select, strsplit
-- GLOBALS: tostring, tremove, type, UnitAffectingCombat, UnitClass, UnitGroupRolesAssigned, UnitIsConnected, UnitIsDeadOrGhost, UnitName, UnitSetRole, unpack, SLASH_BigWigs1, SLASH_BigWigs2
-- GLOBALS: SLASH_BigWigsVersion1, UnitBuff, wipe

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

	local loaded, reason = LoadAddOn(index)
	if not loaded then
		sysprint(ADDON_LOAD_FAILED:format(GetAddOnInfo(index), _G["ADDON_"..reason]))
	end
	return loaded
end

local function loadAddons(tbl)
	if not tbl then return end
	for _, index in next, tbl do
		if not IsAddOnLoaded(index) and load(nil, index) then
			local name = GetAddOnInfo(index)
			public:SendMessage("BigWigs_ModulePackLoaded", name)
		end
	end
	tbl = nil
end

local function loadZone(zone)
	if not zone then return end
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
	if not BigWigsOptions and (InCombatLockdown() or UnitAffectingCombat("player")) then
		sysprint(L.blizzRestrictionsConfig)
		return
	end
	loadAndEnableCore()
	load(BigWigsOptions, "BigWigs_Options")
	if BigWigsOptions then
		BigWigsOptions:Open()
	end
end

-----------------------------------------------------------------------
-- Version listing functions
--

tooltipFunctions[#tooltipFunctions+1] = function(tt)
	local add, i = nil, 0
	for player, version in next, usersVersion do
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
	local loadOnZoneAddons = {} -- Will contain all names of addons with an X-BigWigs-LoadOn-ZoneId directive
	local loadOnWorldBoss = {} -- Packs that should load when targetting a specific mob

	for i = 1, GetNumAddOns() do
		local name = GetAddOnInfo(i)
		if IsAddOnEnabled(i) then
			local meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-CoreEnabled")
			if meta then
				loadOnCoreEnabled[#loadOnCoreEnabled + 1] = i
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-ZoneId")
			if meta then
				loadOnZoneAddons[#loadOnZoneAddons + 1] = i
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
		elseif reqFuncAddons[name] then
			sysprint(L.coreAddonDisabled:format(name))
		end

		if next(loadOnSlash) then
			ChatFrame_ImportAllListsToHash() -- Add our slashes to the hash.
		end
	end

	local function iterateZones(addon, override, ...)
		for i = 1, select("#", ...) do
			local rawZone = select(i, ...)
			local zone = tonumber(rawZone:trim())
			if zone then
				-- register the zone for enabling.
				local instanceId = fakeWorldZones[zone] and zone or GetAreaMapInfo(zone)
				if instanceId then -- Protect live client from beta client ids
					enableZones[instanceId] = true

					if not loadOnZone[instanceId] then loadOnZone[instanceId] = {} end
					loadOnZone[instanceId][#loadOnZone[instanceId] + 1] = addon

					if override then
						loadOnZone[override][#loadOnZone[override] + 1] = addon
					else
						if not menus[zone] then menus[zone] = true end
					end
				end
			else
				local name = GetAddOnInfo(addon)
				sysprint(("The zone ID %q from the addon %q was not parsable."):format(tostring(rawZone), name))
			end
		end
	end

	local currentZone = nil
	local function iterateWorldBosses(addon, override, ...)
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

					if override then
						loadOnZone[override][#loadOnZone[override] + 1] = addon
					end
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

	for _, index in next, loadOnZoneAddons do
		local menu = tonumber(GetAddOnMetadata(index, "X-BigWigs-Menu"))
		if menu then
			if not loadOnZone[menu] then loadOnZone[menu] = {} end
			if not menus[menu] then menus[menu] = true end
		end
		local zones = GetAddOnMetadata(index, "X-BigWigs-LoadOn-ZoneId")
		if zones then
			iterateZones(index, menu, strsplit(",", zones))
		end
	end

	for _, index in next, loadOnWorldBoss do
		local menu = tonumber(GetAddOnMetadata(index, "X-BigWigs-Menu"))
		if menu then
			if not loadOnZone[menu] then loadOnZone[menu] = {} end
			if not menus[menu] then menus[menu] = true end
		end
		local zones = GetAddOnMetadata(index, "X-BigWigs-LoadOn-WorldBoss")
		if zones then
			iterateWorldBosses(index, menu, strsplit(",", zones))
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
	RegisterAddonMessagePrefix("BigWigs")
	RegisterAddonMessagePrefix("D4") -- DBM

	local icon = LibStub("LibDBIcon-1.0", true)
	if icon and ldb then
		if not BigWigs3IconDB then BigWigs3IconDB = {} end
		icon:Register("BigWigs", ldb, BigWigs3IconDB)
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
				if k:find("BigWigs_Bosses_", nil, true) and not next(v) then
					BigWigs3DB.namespaces[k] = nil
				end
			end
		end
	end
	self:UpdateDBMFaking(nil, "fakeDBMVersion", self.isFakingDBM)

	if self.isSoundOn ~= false then -- Only if sounds are enabled
		local num = tonumber(GetCVar("Sound_NumChannels")) or 0
		if num < 64 then
			SetCVar("Sound_NumChannels", 64) -- Blizzard keeps screwing with addon sound priority so we force this minimum
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
			message(L.removeAddon:format(name, old[name]))
		end
	end

	local L = GetLocale()
	if L == "ptBR" then
		--delayedMessages[#delayedMessages+1] = "We *really* need help translating BigWigs! Think you can help us? Please check out our translator website: goo.gl/nwR5cy"
	elseif L == "zhTW" then
		--delayedMessages[#delayedMessages+1] = "Think you can translate BigWigs into Traditional Chinese (zhTW)? Check out our easy translator tool: goo.gl/nwR5cy"
	elseif L == "itIT" then
		--delayedMessages[#delayedMessages+1] = "Think you can translate BigWigs into Italian (itIT)? Check out our easy translator tool: goo.gl/nwR5cy"
	elseif L == "koKR" then
		--delayedMessages[#delayedMessages+1] = "Think you can translate BigWigs into Korean (koKR)? Check out our easy translator tool: goo.gl/nwR5cy"
	end

	CTimerAfter(11, function()
		local _, _, _, _, month, _, year = GetAchievementInfo(10043) -- Mythic Archimonde
		if year == 15 and month < 10 then
			sysprint("We're looking for an end-game raider to join our GitHub developer team: goo.gl/aajTfo")
		end
		for _, msg in next, delayedMessages do
			sysprint(msg)
		end
		delayedMessages = nil
	end)
end

-----------------------------------------------------------------------
-- DBM version collection & faking
--

do
	-- This is a crapfest mainly because DBM's actual handling of versions is a crapfest, I'll try explain how this works...
	local DBMdotRevision = "15286" -- The changing version of the local client, changes with every alpha revision using an SVN keyword.
	local DBMdotDisplayVersion = "7.0.10" -- Same as above but is changed between alpha and release cycles e.g. "N.N.N" for a release and "N.N.N alpha" for the alpha duration
	local DBMdotReleaseRevision = DBMdotRevision -- This is manually changed by them every release, they use it to track the highest release version, a new DBM release is the only time it will change.

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
			if BigWigs and BigWigs.db.profile.fakeDBMVersion or self.isFakingDBM then
				-- If there are people with newer versions than us, suddenly we've upgraded!
				local rev, dotRev = tonumber(revision), tonumber(DBMdotRevision)
				if rev and displayVersion and rev ~= 99999 and rev > dotRev and not displayVersion:find("alpha", nil, true) then -- Failsafes
					if not prevUpgradedUser then
						prevUpgradedUser = sender
					elseif prevUpgradedUser ~= sender then
						DBMdotRevision = revision -- Update our local rev with the highest possible rev found.
						DBMdotReleaseRevision = releaseRevision -- Update our release rev with the highest found, this should be the same for alpha users and latest release users.
						DBMdotDisplayVersion = displayVersion -- Update to the latest display version.
						-- Re-send the addon message.
						if timer then timer:Cancel() end
						timer = CTimerNewTicker(1, sendMsg, 1)
					end
				end
			end
		end
	end
	function mod:UpdateDBMFaking(_, key, value)
		if key == "fakeDBMVersion" and value and IsInGroup() then
			self:DBM_VersionCheck("H") -- Send addon message if feature is being turned on inside a raid/group.
		end
	end
end

-----------------------------------------------------------------------
-- Callback handler
--

do
	local callbackMap = {}
	function public:RegisterMessage(msg, func)
		if type(msg) ~= "string" then error(":RegisterMessage(message, function) attempted to register invalid message, must be a string!") end
		if not callbackMap[msg] then callbackMap[msg] = {} end
		callbackMap[msg][self] = func or msg
	end
	function public:UnregisterMessage(msg)
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
	public.RegisterMessage(mod, "BigWigs_OnBossReboot", UnregisterAllMessages)
	public.RegisterMessage(mod, "BigWigs_OnPluginDisable", UnregisterAllMessages)
	public.RegisterMessage(mod, "BigWigs_BossModuleRegistered")
	public.RegisterMessage(mod, "BigWigs_CoreOptionToggled", "UpdateDBMFaking")
	public.RegisterMessage(mod, "BigWigs_CoreEnabled")
	public.RegisterMessage(mod, "BigWigs_CoreDisabled")
end

-----------------------------------------------------------------------
-- Events
--

bwFrame:SetScript("OnEvent", function(frame, event, ...)
	mod[event](mod, ...)
end)
bwFrame:RegisterEvent("ADDON_LOADED")
bwFrame:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS")

do
	-- Role Updating
	local prev = 0
	function mod:ACTIVE_TALENT_GROUP_CHANGED(player)
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
				-- We can't do PlaySound("ReadyCheck", "Master") as PlaySound is throttled, and Blizz already plays it.
				-- Only play via the "Master" channel if we have sounds turned on
				if (BigWigs and BigWigs:GetPlugin("Sounds") and BigWigs:GetPlugin("Sounds").db.profile.sound) or self.isSoundOn ~= false then
					PlaySoundFile("Sound\\Interface\\levelup2.ogg", "Master")
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

-- Misc
function mod:CHAT_MSG_ADDON(prefix, msg, channel, sender)
	if channel ~= "RAID" and channel ~= "PARTY" and channel ~= "INSTANCE_CHAT" then
		return
	elseif prefix == "BigWigs" then
		local bwPrefix, bwMsg = msg:match("^(%u-):(.+)")
		sender = Ambiguate(sender, "none")
		if bwPrefix == "V" or bwPrefix == "Q" then
			self:VersionCheck(bwPrefix, bwMsg, sender)
		elseif bwPrefix then
			if msg == "T:BWPull" or msg == "T:BWBreak" then loadAndEnableCore() end -- Force enable the core when receiving a break/pull timer.
			public:SendMessage("BigWigs_AddonMessage", bwPrefix, bwMsg, sender)
		end
	elseif prefix == "D4" then
		local dbmPrefix, arg1, arg2, arg3, arg4 = strsplit("\t", msg)
		if dbmPrefix == "V" or dbmPrefix == "H" then
			self:DBM_VersionCheck(dbmPrefix, Ambiguate(sender, "none"), arg1, arg2, arg3)
		elseif dbmPrefix == "U" or dbmPrefix == "PT" or dbmPrefix == "M" or dbmPrefix == "BT" then
			if dbmPrefix == "PT" or dbmPrefix == "BT" then loadAndEnableCore() end
			public:SendMessage("DBM_AddonMessage", Ambiguate(sender, "none"), dbmPrefix, arg1, arg2, arg3, arg4)
		end
	end
end

do
	local timer = nil
	local function sendMsg()
		if IsInGroup() then
			SendAddonMessage("BigWigs", versionResponseString, IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- LE_PARTY_CATEGORY_INSTANCE = 2
		end
		timer = nil
	end

	local hasWarned, hasReallyWarned, hasExtremelyWarned = nil, nil, nil
	local function printOutOfDate(tbl)
		if hasExtremelyWarned then return end
		local warnedOutOfDate, warnedReallyOutOfDate, warnedExtremelyOutOfDate = 0, 0, 0
		for k,v in next, tbl do
			if v > BIGWIGS_VERSION then
				warnedOutOfDate = warnedOutOfDate + 1
				if warnedOutOfDate > 1 and not hasWarned then
					hasWarned = true
					sysprint(L.getNewRelease)
				end
				if (v - 1) > BIGWIGS_VERSION then -- 2+ releases
					warnedReallyOutOfDate = warnedReallyOutOfDate + 1
					if warnedReallyOutOfDate > 1 and not hasReallyWarned then
						hasReallyWarned = true
						sysprint(L.warnTwoReleases)
						RaidNotice_AddMessage(RaidWarningFrame, L.warnTwoReleases, {r=1,g=1,b=1})
					end
					if (v - 2) > BIGWIGS_VERSION then -- Currently at 3+ releases since it's a quiet period, always adjust this higher for busy periods.
						warnedExtremelyOutOfDate = warnedExtremelyOutOfDate + 1
						if warnedExtremelyOutOfDate > 1 and not hasExtremelyWarned then
							hasExtremelyWarned = true
							sysprint(L.warnSeveralReleases)
							message(L.warnSeveralReleases)
						end
					end
				end
			end
		end
	end

	function mod:VersionCheck(prefix, msg, sender)
		if prefix == "Q" then
			if timer then timer:Cancel() end
			timer = CTimerNewTicker(3, sendMsg, 1)
		end
		if prefix == "V" or prefix == "Q" then -- V = version response, Q = version query
			local verString, hash = msg:match("^(%d+)%-(.+)$")
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
	local queueLoad = {}
	local warnedThisZone = {}
	function mod:PLAYER_REGEN_ENABLED()
		self:ACTIVE_TALENT_GROUP_CHANGED() -- Force role check
		bwFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")

		local shouldPrint = false
		for k,v in next, queueLoad do
			if v == "unloaded" and loadAndEnableCore() then
				shouldPrint = true
				queueLoad[k] = "loaded"
				if BigWigs:IsEnabled() and loadOnZone[k] then
					loadZone(k)
				else
					BigWigs:Enable()
				end
			end
		end
		if shouldPrint then
			sysprint(L.finishedLoading)
		end
	end

	local UnitGUID = UnitGUID
	function mod:UNIT_TARGET(unit)
		local guid = UnitGUID(unit.."target")
		if guid then
			local _, _, _, _, _, id = strsplit("-", guid)
			local mobId = tonumber(id)
			if mobId and worldBosses[mobId] then
				local id = worldBosses[mobId]
				if InCombatLockdown() or UnitAffectingCombat("player") then
					if not queueLoad[id] then
						queueLoad[id] = "unloaded"
						bwFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
						sysprint(L.blizzRestrictionsZone)
					end
				else
					queueLoad[id] = "loaded"
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
	end

	function mod:ZONE_CHANGED_NEW_AREA()
		-- Zone checking
		local id
		local inside = IsInInstance()
		if not inside then
			id = -(GetPlayerMapAreaID("player") or 0)
		else
			local _, _, _, _, _, _, _, instanceId = GetInstanceInfo()
			id = instanceId
		end

		-- Module loading
		if enableZones[id] then
			if not inside and enableZones[id] == "world" then
				if BigWigs and BigWigs:IsEnabled() and not UnitIsDeadOrGhost("player") and (not BigWigsOptions or not BigWigsOptions:InConfigureMode()) and (not BigWigs3DB or not BigWigs3DB.breakTime) then
					BigWigs:Disable() -- Might be leaving an LFR and entering a world enable zone, disable first
				end
				bwFrame:RegisterEvent("UNIT_TARGET")
				self:UNIT_TARGET("player")
			elseif inside then
				bwFrame:UnregisterEvent("UNIT_TARGET")
				if not IsEncounterInProgress() and IsLoggedIn() and (InCombatLockdown() or UnitAffectingCombat("player")) then
					if not queueLoad[id] then
						queueLoad[id] = "unloaded"
						bwFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
						sysprint(L.blizzRestrictionsZone)
					end
				else
					queueLoad[id] = "loaded"
					if loadAndEnableCore() then
						if BigWigs:IsEnabled() and loadOnZone[id] then
							loadZone(id)
						else
							BigWigs:Enable()
						end
					end
				end
			end
		else
			bwFrame:UnregisterEvent("UNIT_TARGET")
			if BigWigs and BigWigs:IsEnabled() and not UnitIsDeadOrGhost("player") and (not BigWigsOptions or not BigWigsOptions:InConfigureMode()) and (not BigWigs3DB or not BigWigs3DB.breakTime) then
				BigWigs:Disable() -- Alive in a non-enable zone, disable
			end
		end

		-- Lacking zone modules
		if (BigWigs and BigWigs.db.profile.showZoneMessages == false) or self.isShowingZoneMessages == false then return end
		local zoneAddon = public.zoneTbl[id]
		if zoneAddon and zoneAddon ~= "BigWigs_Legion" then
			if zoneAddon:find("LittleWigs_", nil, true) then zoneAddon = "LittleWigs" end -- Collapse into one addon
			if inside and not fakeWorldZones[id] and not warnedThisZone[id] and not IsAddOnEnabled(zoneAddon) then
				warnedThisZone[id] = true
				local msg = L.missingAddOn:format(zoneAddon)
				sysprint(msg)
				RaidNotice_AddMessage(RaidWarningFrame, msg, {r=1,g=1,b=1})
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
			wipe(usersVersion)
			wipe(usersHash)
			self:ZONE_CHANGED_NEW_AREA()
		end
	end
end

function mod:BigWigs_BossModuleRegistered(_, _, module)
	if module.worldBoss then
		enableZones[module.zoneId] = "world"
		worldBosses[module.worldBoss] = module.zoneId
	else
		enableZones[GetAreaMapInfo(module.zoneId)] = true
	end

	local id = module.otherMenu or module.zoneId
	if type(menus[id]) ~= "table" then menus[id] = {} end
	menus[id][#menus[id]+1] = module
end

function mod:BigWigs_CoreEnabled()
	if ldb then
		ldb.icon = "Interface\\AddOns\\BigWigs\\Textures\\icons\\core-enabled"
	end

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

function mod:BigWigs_CoreDisabled()
	if ldb then
		ldb.icon = "Interface\\AddOns\\BigWigs\\Textures\\icons\\core-disabled"
	end
end

-----------------------------------------------------------------------
-- API
--

function public:RegisterTooltipInfo(func)
	for i, v in next, tooltipFunctions do
		if v == func then
			error(("The function %q has already been registered."):format(func))
		end
	end
	tooltipFunctions[#tooltipFunctions+1] = func
end

function public:GetReleaseString()
	return BIGWIGS_RELEASE_STRING
end

function public:GetZoneMenus()
	return menus
end

function public:LoadZone(zone)
	loadZone(zone)
end

-----------------------------------------------------------------------
-- LDB Plugin
--

do
	local ldb11 = LibStub("LibDataBroker-1.1", true)
	if ldb11 then
		ldb = ldb11:NewDataObject("BigWigs", {
			type = "launcher",
			label = "BigWigs",
			icon = "Interface\\AddOns\\BigWigs\\Textures\\icons\\core-disabled",
		})

		function ldb.OnClick(self, button)
			if button == "RightButton" then
				loadCoreAndOpenOptions()
			else
				loadAndEnableCore()
				if IsAltKeyDown() then
					if IsControlKeyDown() then
						BigWigs:Disable()
					else
						for name, module in BigWigs:IterateBossModules() do
							if module:IsEnabled() then module:Disable() end
						end
						sysprint(L.modulesDisabled)
					end
				else
					for name, module in BigWigs:IterateBossModules() do
						if module:IsEnabled() then module:Reboot() end
					end
					sysprint(L.modulesReset)
				end
			end
		end

		function ldb.OnTooltipShow(tt)
			tt:AddLine("BigWigs")
			if BigWigs and BigWigs:IsEnabled() then
				local added = nil
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
			for i, v in next, tooltipFunctions do
				v(tt)
			end
			tt:AddLine(L.tooltipHint, 0.2, 1, 0.2, 1)
		end
	end
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

	local m = {}
	local unit
	if not IsInRaid() then
		m[1] = UnitName("player")
		unit = "party%d"
	else
		unit = "raid%d"
	end
	for i = 1, GetNumGroupMembers() do
		local n, s = UnitName((unit):format(i))
		if n and s and s ~= "" then n = n.."-"..s end
		if n then m[#m+1] = n end
	end

	local good = {} -- highest release users
	local ugly = {} -- old version users
	local bad = {} -- no boss mod
	local crazy = {} -- DBM users

	for i, player in next, m do
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

BigWigsLoader = public -- Set global
