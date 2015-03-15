
local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs")
local mod, public = {}, {}
local bwFrame = CreateFrame("Frame")

-----------------------------------------------------------------------
-- Generate our version variables
--

local REPO = "REPO"
local ALPHA = "ALPHA"
local RELEASE = "RELEASE"
local BIGWIGS_RELEASE_TYPE, MY_BIGWIGS_REVISION, BIGWIGS_RELEASE_STRING

do
	-- START: MAGIC WOWACE VOODOO VERSION STUFF
	local releaseType = RELEASE
	local myRevision = 1
	local releaseString = ""
	--@alpha@
	-- The following code will only be present in alpha ZIPs.
	releaseType = ALPHA
	--@end-alpha@

	-- This will (in ZIPs), be replaced by the highest revision number in the source tree.
	myRevision = tonumber("@project-revision@")

	-- If myRevision ends up NOT being a number, it means we're running a SVN copy.
	if type(myRevision) ~= "number" then
		myRevision = -1
		releaseType = REPO
	end

	-- Then build the release string, which we can add to the interface option panel.
	local majorVersion = GetAddOnMetadata("BigWigs", "Version") or "4.?"
	if releaseType == REPO then
		releaseString = L.sourceCheckout:format(majorVersion)
	elseif releaseType == RELEASE then
		releaseString = L.officialRelease:format(majorVersion, myRevision)
	elseif releaseType == ALPHA then
		releaseString = L.alphaRelease:format(majorVersion, myRevision)
	end
	BIGWIGS_RELEASE_TYPE = releaseType
	MY_BIGWIGS_REVISION = myRevision
	BIGWIGS_RELEASE_STRING = releaseString
	-- END: MAGIC WOWACE VOODOO VERSION STUFF
end

-----------------------------------------------------------------------
-- Locals
--

local ldb = nil
local tooltipFunctions = {}
local next, tonumber = next, tonumber
local SendAddonMessage, Ambiguate, CTimerAfter, CTimerNewTicker = SendAddonMessage, Ambiguate, C_Timer.After, C_Timer.NewTicker
local IsInInstance, GetCurrentMapAreaID, SetMapToCurrentZone = IsInInstance, GetCurrentMapAreaID, SetMapToCurrentZone
local GetAreaMapInfo, GetInstanceInfo = GetAreaMapInfo, GetInstanceInfo

-- Try to grab unhooked copies of critical funcs (hooked by some crappy addons)
public.GetCurrentMapAreaID = GetCurrentMapAreaID
public.SetMapToCurrentZone = SetMapToCurrentZone
public.GetAreaMapInfo = GetAreaMapInfo
public.GetInstanceInfo = GetInstanceInfo
public.SendAddonMessage = SendAddonMessage
public.SendChatMessage = SendChatMessage
public.CTimerAfter = CTimerAfter
public.CTimerNewTicker = CTimerNewTicker

-- Version
local usersAlpha = {}
local usersRelease = {}
local usersDBM = {}
-- Only set highestReleaseRevision if we're actually using a release of BigWigs.
-- If we set this as an alpha user we will alert release users with out-of-date warnings
-- and class them as out-of-date in /bwv (if our alpha version is higher). But they may be
-- using the latest available release version of BigWigs. This method ensures they are
-- classed as up-to-date in /bwv if they use the latest available release of BigWigs
-- even if our alpha is revisions ahead.
local highestReleaseRevision = BIGWIGS_RELEASE_TYPE == RELEASE and MY_BIGWIGS_REVISION or -1
-- The highestAlphaRevision is so we can alert old alpha users (we didn't previously)
local highestAlphaRevision = BIGWIGS_RELEASE_TYPE == ALPHA and MY_BIGWIGS_REVISION or -1

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
}

do
	local c = "BigWigs_Classic"
	local bc = "BigWigs_BurningCrusade"
	local wotlk = "BigWigs_WrathOfTheLichKing"
	local cata = "BigWigs_Cataclysm"
	local mop = "BigWigs_MistsOfPandaria"
	local lw = "LittleWigs"

	local tbl = {
		[696]=c, [755]=c,
		[775]=bc, [780]=bc, [779]=bc, [776]=bc, [799]=bc, [782]=bc, [466]=bc,
		[604]=wotlk, [543]=wotlk, [535]=wotlk, [529]=wotlk, [527]=wotlk, [532]=wotlk, [531]=wotlk, [609]=wotlk, [718]=wotlk,
		[752]=cata, [758]=cata, [754]=cata, [824]=cata, [800]=cata, [773]=cata,
		[896]=mop, [897]=mop, [886]=mop, [930]=mop, [953]=mop, [862]=mop,

		[877]=lw, [871]=lw, [874]=lw, [885]=lw, [867]=lw, [919]=lw, -- MoP
		[964]=lw, [969]=lw, [984]=lw, [987]=lw, [989]=lw, [993]=lw, [995]=lw, [1008]=lw -- WoD
	}

	public.fakeWorldZones = fakeWorldZones
	public.zoneTbl = {}
	for k,v in next, tbl do
		if fakeWorldZones[k] then
			public.zoneTbl[k] = v
		else
			public.zoneTbl[GetAreaMapInfo(k)] = v
		end
	end
end

-- GLOBALS: _G, ADDON_LOAD_FAILED, BigWigs, BigWigs3DB, BigWigs3IconDB, BigWigsLoader, BigWigsOptions, CreateFrame, CUSTOM_CLASS_COLORS, error, GetAddOnEnableState, GetAddOnInfo
-- GLOBALS: GetAddOnMetadata, GetLocale, GetNumGroupMembers, GetRealmName, GetSpecialization, GetSpecializationRole, GetSpellInfo, GetTime, GRAY_FONT_COLOR, InCombatLockdown
-- GLOBALS: InterfaceOptionsFrameOkay, IsAddOnLoaded, IsAltKeyDown, IsControlKeyDown, IsEncounterInProgress, IsInGroup, IsInRaid, IsLoggedIn, IsPartyLFG, IsSpellKnown, LFGDungeonReadyPopup
-- GLOBALS: LibStub, LoadAddOn, message, PlaySoundFile, print, RAID_CLASS_COLORS, RaidNotice_AddMessage, RaidWarningFrame, RegisterAddonMessagePrefix, RolePollPopup, select, SetMapByID, strsplit
-- GLOBALS: tostring, tremove, type, UnitAffectingCombat, UnitClass, UnitGroupRolesAssigned, UnitIsDeadOrGhost, UnitName, UnitSetRole, unpack, SLASH_BigWigs1, SLASH_BigWigs2
-- GLOBALS: SLASH_BigWigsVersion1, UnitBuff, wipe, WorldMapFrame

-----------------------------------------------------------------------
-- Utility
--

local function IsAddOnEnabled(addon)
	local character = UnitName("player")
	return GetAddOnEnableState(character, addon) > 0
end

local function sysprint(msg)
	print("|cFF33FF99Big Wigs|r: "..msg)
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
	for player, version in next, usersRelease do
		i = i + 1
		if version < highestReleaseRevision then
			add = true
			break
		end
	end
	if not add then
		for player, version in next, usersAlpha do
			i = i + 1
			-- If this person's alpha version isn't SVN (-1) and it's lower than the highest found release version minus 1 because
			-- of tagging, or it's lower than the highest found alpha version (with a 10 revision leeway) then that person is out-of-date
			if version ~= -1 and (version < (highestReleaseRevision - 1) or version < (highestAlphaRevision - 10)) then
				add = true
				break
			end
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
				enableZones[instanceId] = true

				if not loadOnZone[instanceId] then loadOnZone[instanceId] = {} end
				loadOnZone[instanceId][#loadOnZone[instanceId] + 1] = addon

				if override then
					loadOnZone[override][#loadOnZone[override] + 1] = addon
				else
					if not menus[zone] then menus[zone] = true end
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
					-- register the zone for enabling.
					enableZones[zoneOrBoss] = "world"

					currentZone = zoneOrBoss

					if not loadOnZone[zoneOrBoss] then loadOnZone[zoneOrBoss] = {} end
					loadOnZone[zoneOrBoss][#loadOnZone[zoneOrBoss] + 1] = addon

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

	local num = tonumber(GetCVar("Sound_NumChannels")) or 0
	if num < 64 then
		SetCVar("Sound_NumChannels", 64) -- XXX temp until Blizz stops screwing with us
	end
end

function mod:ADDON_LOADED(addon)
	if addon ~= "BigWigs" then return end

	bwFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	bwFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
	bwFrame:RegisterEvent("LFG_PROPOSAL_SHOW")

	-- Role Updating
	bwFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	local _, class = UnitClass("player")
	if class == "WARRIOR" then -- Handle Gladiator Stance
		bwFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	end
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
		if not BigWigs3DB.has61reset then -- XXX 6.1 reset for DB change
			for k,v in next, BigWigs3DB.namespaces do
				if k:find("BigWigs_Bosses_", nil, true) or k == "BigWigs_Plugins_Super Emphasize" or k == "BigWigs_Plugins_Colors" or k == "BigWigs_Plugins_Sounds" then
					BigWigs3DB.namespaces[k] = nil
				end
			end
			CTimerAfter(7, function()
				sysprint(L.temp61Reset)
			end)
			BigWigs3DB.has61reset = true
		end

		-- Somewhat ugly, but saves loading AceDB with the loader instead of with the core
		if BigWigs3DB.profileKeys and BigWigs3DB.profiles then
			local name = UnitName("player")
			local realm = GetRealmName()
			if name and realm and BigWigs3DB.profileKeys[name.." - "..realm] then
				local key = BigWigs3DB.profiles[BigWigs3DB.profileKeys[name.." - "..realm]]
				self.isFakingDBM = key.fakeDBMVersion
				self.isShowingZoneMessages = key.showZoneMessages
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

	bwFrame:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil
	public.hasLoaded = true -- XXX temp
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
		LittleWigs_ShadoPanMonastery = "LittleWigs",
		LittleWigs_ScarletHalls = "LittleWigs",
		LittleWigs_ScarletMonastery = "LittleWigs",
		LittleWigs_MogushanPalace = "LittleWigs",
		LittleWigs_TempleOfTheJadeSerpent = "LittleWigs",
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
				if meta and (meta == "BigWigs_Core" or meta == "BigWigs_Plugins") then
					delayedMessages[#delayedMessages+1] = "The addon '|cffffff00"..name.."|r' is forcing Big Wigs to load prematurely, notify the Big Wigs authors!"
				end
			end
			for j = 1, select("#", GetAddOnDependencies(i)) do
				local meta = select(j, GetAddOnDependencies(i))
				if meta and (meta == "BigWigs_Core" or meta == "BigWigs_Plugins") then
					delayedMessages[#delayedMessages+1] = "The addon '|cffffff00"..name.."|r' is forcing Big Wigs to load prematurely, notify the Big Wigs authors!"
				end
			end
		end

		if old[name] then
			delayedMessages[#delayedMessages+1] = L.removeAddon:format(name, old[name])
		end
	end

	local L = GetLocale()
	if L == "ptBR" then
		delayedMessages[#delayedMessages+1] = "We *really* need help translating Big Wigs! Think you can help us? Please check out our translator website: goo.gl/nwR5cy"
	elseif L == "zhTW" then
	--	delayedMessages[#delayedMessages+1] = "Think you can translate Big Wigs into Traditional Chinese (zhTW)? Check out our easy translator tool: goo.gl/nwR5cy"
	elseif L == "ruRU" then
	--	delayedMessages[#delayedMessages+1] = "Think you can translate Big Wigs into Russian (ruRU)? Check out our easy translator tool: goo.gl/nwR5cy"
	elseif L == "itIT" then
	--	delayedMessages[#delayedMessages+1] = "Think you can translate Big Wigs into Italian (itIT)? Check out our easy translator tool: goo.gl/nwR5cy"
	elseif L == "deDE" then
	--	delayedMessages[#delayedMessages+1] = "Think you can translate Big Wigs into German (deDE)? Check out our easy translator tool: goo.gl/nwR5cy"
	elseif L == "koKR" then
	--	delayedMessages[#delayedMessages+1] = "Think you can translate Big Wigs into Korean (koKR)? Check out our easy translator tool: goo.gl/nwR5cy"
	end

	CTimerAfter(11, function()
		--local _, _, _, _, _, _, year = GetAchievementInfo(8482) -- Mythic Garrosh
		--if year == 13 and (L == "enUS" or L == "enGB") then
		--	sysprint("We're looking for a new end-game raider to join our developer team! See [goo.gl/aajTfo] for more info.")
		--end
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
	local DBMdotRevision = "13295" -- The changing version of the local client, changes with every alpha revision using an SVN keyword.
	local DBMdotDisplayVersion = "6.1.2" -- Same as above but is changed between alpha and release cycles e.g. "N.N.N" for a release and "N.N.N alpha" for the alpha duration
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

-- Role Updating
function mod:ACTIVE_TALENT_GROUP_CHANGED()
	if IsInGroup() then
		if IsPartyLFG() then return end

		local tree = GetSpecialization()
		if not tree then return end -- No spec selected

		local role = GetSpecializationRole(tree)
		if IsSpellKnown(152276) and UnitBuff("player", (GetSpellInfo(156291))) then -- Gladiator Stance
			role = "DAMAGER"
		end
		if UnitGroupRolesAssigned("player") ~= role then
			if InCombatLockdown() or UnitAffectingCombat("player") then
				bwFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
				return
			end
			UnitSetRole("player", role)
		end
	end
end
mod.UPDATE_SHAPESHIFT_FORM = mod.ACTIVE_TALENT_GROUP_CHANGED

-- Merged LFG_ProposalTime addon by Freebaser
do
	local prev
	function mod:LFG_PROPOSAL_SHOW()
		if not prev then
			local BD = {
				bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
				tile = true,
				tileSize = 32,
				insets = {left = -1, right = -1, top = -1, bottom = -1},
			}

			local timerBar = CreateFrame("StatusBar", nil, LFGDungeonReadyPopup)
			timerBar:SetPoint("TOP", LFGDungeonReadyPopup, "BOTTOM", 0, -5)
			timerBar:SetSize(190, 9)
			timerBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar", "BORDER")
			timerBar:SetStatusBarColor(1,.1,0)
			timerBar:SetBackdrop(BD)
			timerBar:SetMinMaxValues(0, 40)
			timerBar:Show()

			local spark = timerBar:CreateTexture(nil, "OVERLAY")
			spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
			spark:SetSize(32, 32)
			spark:SetBlendMode("ADD")
			spark:SetPoint("LEFT", timerBar:GetStatusBarTexture(), "RIGHT", -15, 0)

			local border = timerBar:CreateTexture(nil, "ARTWORK")
			border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border")
			border:SetSize(256, 64)
			border:SetPoint("TOP", timerBar, 0, 28)

			timerBar.text = timerBar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
			timerBar.text:SetPoint("CENTER", timerBar, "CENTER")

			self.LFG_PROPOSAL_SHOW = function()
				prev = GetTime() + 40
				-- Play in Master for those that have SFX off or very low.
				-- We can't do PlaySound("ReadyCheck", "Master") as PlaySound is throttled, and Blizz already plays it.
				PlaySoundFile("Sound\\Interface\\levelup2.ogg", "Master")
			end
			self:LFG_PROPOSAL_SHOW()

			timerBar:SetScript("OnUpdate", function(f)
				local timeLeft = prev - GetTime()
				if timeLeft > 0 then
					f:SetValue(timeLeft)
					f.text:SetFormattedText("Big Wigs: %.1f", timeLeft)
				end
			end)
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
		if bwPrefix == "VR" or bwPrefix == "VRA" or bwPrefix == "VQ" or bwPrefix == "VQA" then
			self:VersionCheck(bwPrefix, bwMsg, sender)
		elseif bwPrefix then
			public:SendMessage("BigWigs_AddonMessage", bwPrefix, bwMsg, sender)
		end
	elseif prefix == "D4" then
		local dbmPrefix, arg1, arg2, arg3, arg4 = strsplit("\t", msg)
		if dbmPrefix == "V" or dbmPrefix == "H" then
			self:DBM_VersionCheck(dbmPrefix, Ambiguate(sender, "none"), arg1, arg2, arg3)
		elseif dbmPrefix == "U" or dbmPrefix == "PT" or dbmPrefix == "M" or dbmPrefix == "BT" then
			public:SendMessage("DBM_AddonMessage", Ambiguate(sender, "none"), dbmPrefix, arg1, arg2, arg3, arg4)
		end
	end
end

do
	local timer = nil
	local function sendMsg()
		if IsInGroup() then
			SendAddonMessage("BigWigs", (BIGWIGS_RELEASE_TYPE == RELEASE and "VR:%d" or "VRA:%d"):format(MY_BIGWIGS_REVISION), IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- LE_PARTY_CATEGORY_INSTANCE = 2
		end
		timer = nil
	end

	local hasWarned, hasReallyWarned, hasExtremelyWarned = nil, nil, nil
	local function printOutOfDate(tbl, isAlpha)
		if hasExtremelyWarned then return end
		local warnedOutOfDate, warnedReallyOutOfDate, warnedExtremelyOutOfDate = 0, 0, 0
		for k,v in next, tbl do
			if (v-isAlpha) > MY_BIGWIGS_REVISION then
				warnedOutOfDate = warnedOutOfDate + 1
				if warnedOutOfDate > 1 and not hasWarned then
					hasWarned = true
					sysprint(isAlpha == 10 and L.alphaOutdated or L.newReleaseAvailable)
				end
				if ((v-isAlpha) - MY_BIGWIGS_REVISION) > 120 then
					warnedReallyOutOfDate = warnedReallyOutOfDate + 1
					if warnedReallyOutOfDate > 1 and not hasReallyWarned then
						hasReallyWarned = true
						sysprint(L.extremelyOutdated)
						RaidNotice_AddMessage(RaidWarningFrame, (L.extremelyOutdated):gsub("|", "\124"), {r=1,g=1,b=1}) -- XXX wowace packager doesn't keep my escape codes and RW doesn't like pipes :(
					end
					if ((v-isAlpha) - MY_BIGWIGS_REVISION) > 300 then
						warnedExtremelyOutOfDate = warnedExtremelyOutOfDate + 1
						if warnedExtremelyOutOfDate > 1 and not hasExtremelyWarned then
							hasExtremelyWarned = true
							sysprint(L.severelyOutdated)
							message(L.severelyOutdated)
						end
					end
				end
			end
		end
	end

	function mod:VersionCheck(prefix, message, sender)
		if prefix == "VR" or prefix == "VQ" then
			if prefix == "VQ" then
				if timer then timer:Cancel() end
				timer = CTimerNewTicker(3, sendMsg, 1)
			end
			message = tonumber(message)
			-- XXX The > 13k check is a hack for now until I find out what addon is sending a stupidly large version (20032). This is probably being done to farm BW versions, when a version of 0 should be used.
			if not message or message == 0 or message > 13700 then return end -- Allow addons to query Big Wigs versions by using a version of 0, but don't add them to the user list.
			usersRelease[sender] = message
			usersAlpha[sender] = nil
			if message > highestReleaseRevision then highestReleaseRevision = message end
			if MY_BIGWIGS_REVISION ~= -1 and message > MY_BIGWIGS_REVISION then
				printOutOfDate(usersRelease, 0)
			end
		elseif prefix == "VRA" or prefix == "VQA" then
			if prefix == "VQA" then
				if timer then timer:Cancel() end
				timer = CTimerNewTicker(3, sendMsg, 1)
			end
			message = tonumber(message)
			-- XXX The > 13k check is a hack for now until I find out what addon is sending a stupidly large version (20032). This is probably being done to farm BW versions, when a version of 0 should be used.
			if not message or message == 0 or message > 13700 then return end -- Allow addons to query Big Wigs versions by using a version of 0, but don't add them to the user list.
			usersAlpha[sender] = message
			usersRelease[sender] = nil
			if message > highestAlphaRevision then highestAlphaRevision = message end
			if BIGWIGS_RELEASE_TYPE == ALPHA and MY_BIGWIGS_REVISION ~= -1 and (message-10) > MY_BIGWIGS_REVISION then
				printOutOfDate(usersAlpha, 10)
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
			if WorldMapFrame:IsShown() then
				local prevId = GetCurrentMapAreaID()
				SetMapToCurrentZone()
				id = GetCurrentMapAreaID()
				SetMapByID(prevId)
			else
				SetMapToCurrentZone()
				id = GetCurrentMapAreaID()
			end
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
		if zoneAddon and inside and not fakeWorldZones[id] and not warnedThisZone[id] and not IsAddOnEnabled(zoneAddon) then
			warnedThisZone[id] = true
			local msg = L.missingAddOn:format(zoneAddon)
			sysprint(msg)
			RaidNotice_AddMessage(RaidWarningFrame, msg:gsub("|", "\124"), {r=1,g=1,b=1}) -- XXX wowace packager doesn't keep my escape codes and RW doesn't like pipes :(
		end
	end
end

do
	local grouped = nil
	function mod:GROUP_ROSTER_UPDATE()
		local groupType = (IsInGroup(2) and 3) or (IsInRaid() and 2) or (IsInGroup() and 1) -- LE_PARTY_CATEGORY_INSTANCE = 2
		if (not grouped and groupType) or (grouped and groupType and grouped ~= groupType) then
			grouped = groupType
			SendAddonMessage("BigWigs", (BIGWIGS_RELEASE_TYPE == RELEASE and "VQ:%d" or "VQA:%d"):format(MY_BIGWIGS_REVISION), groupType == 3 and "INSTANCE_CHAT" or "RAID")
			SendAddonMessage("D4", "H\t", groupType == 3 and "INSTANCE_CHAT" or "RAID") -- Also request DBM versions
			self:ZONE_CHANGED_NEW_AREA()
			self:ACTIVE_TALENT_GROUP_CHANGED() -- Force role check
		elseif grouped and not groupType then
			grouped = nil
			wipe(usersRelease)
			wipe(usersAlpha)
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
		SendAddonMessage("BigWigs", (BIGWIGS_RELEASE_TYPE == RELEASE and "VQ:%d" or "VQA:%d"):format(MY_BIGWIGS_REVISION), IsInGroup(2) and "INSTANCE_CHAT" or "RAID")
		SendAddonMessage("D4", "H\t", IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- Also request DBM versions
	end

	-- Core is loaded, nil these to force checking BigWigs.db.profile.option
	self.isFakingDBM = nil
	self.isShowingZoneMessages = nil
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
			label = "Big Wigs",
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
			tt:AddLine("Big Wigs")
			local h = nil
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

	local function coloredNameVersion(name, version, alpha)
		if version == -1 then
			version = "|cFFCCCCCC(SVN)|r"
		elseif not version then
			version = ""
		else
			version = ("|cFFCCCCCC(%s%s)|r"):format(version, alpha and "-alpha" or "")
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
		if usersRelease[player] then
			if usersRelease[player] < highestReleaseRevision then
				ugly[#ugly + 1] = coloredNameVersion(player, usersRelease[player])
			else
				good[#good + 1] = coloredNameVersion(player, usersRelease[player])
			end
			usesBossMod = true
		elseif usersAlpha[player] then
			-- If this person's alpha version isn't SVN (-1) and it's higher or the same as the highest found release version minus 1 because
			-- of tagging, or it's higher or the same as the highest found alpha version (with a 10 revision leeway) then that person's good
			if (usersAlpha[player] >= (highestReleaseRevision - 1) and usersAlpha[player] >= (highestAlphaRevision - 10)) or usersAlpha[player] == -1 then
				good[#good + 1] = coloredNameVersion(player, usersAlpha[player], ALPHA)
			else
				ugly[#ugly + 1] = coloredNameVersion(player, usersAlpha[player], ALPHA)
			end
			usesBossMod = true
		end
		if usersDBM[player] then
			crazy[#crazy+1] = coloredNameVersion(player, usersDBM[player])
			usesBossMod = true
		end
		if not usesBossMod then
			bad[#bad+1] = coloredNameVersion(player)
		end
	end

	if #good > 0 then print(L.upToDate, unpack(good)) end
	if #ugly > 0 then print(L.outOfDate, unpack(ugly)) end
	if #crazy > 0 then print(L.dbmUsers, unpack(crazy)) end
	if #bad > 0 then print(L.noBossMod, unpack(bad)) end
end

BigWigsLoader = public -- Set global

