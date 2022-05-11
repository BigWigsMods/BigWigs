
if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
	print("|cFF33FF99BigWigs|r: You're trying to run the Classic version of BigWigs on a live server.")
	return
end

local L = BigWigsAPI:GetLocale("BigWigs")
local mod, public = {}, {}
local bwFrame = CreateFrame("Frame")

local ldb = LibStub("LibDataBroker-1.1")
local ldbi = LibStub("LibDBIcon-1.0")

local strfind = string.find

public.isClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
public.isBC = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC

-----------------------------------------------------------------------
-- Generate our version variables
--

local BIGWIGS_VERSION = 38
local BIGWIGS_RELEASE_STRING, BIGWIGS_VERSION_STRING = "", ""
local versionQueryString, versionResponseString = "Q^%d^%s^%d^%s", "V^%d^%s^%d^%s"
local customGuildName = false
local BIGWIGS_GUILD_VERSION = 0
local guildWarnMessage = ""

do
	-- START: MAGIC PACKAGER VOODOO VERSION STUFF
	local _, tbl = ...
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
	if strfind(myGitHash, "@", nil, true) then
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

	-- Format is "V:version^hash^guildVersion^guildName"
	local isVersionNumber = type(tbl.guildVersion) == "number"
	local isGuildString = type(tbl.guildName) == "string"
	local isGuildWarnString = type(tbl.guildWarn) == "string"
	if isVersionNumber and isGuildString and isGuildWarnString and tbl.guildVersion > 0 and tbl.guildName:gsub(" ", "") ~= "" then
		customGuildName = tbl.guildName
		BIGWIGS_GUILD_VERSION = tbl.guildVersion
		guildWarnMessage = tbl.guildWarn
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
local next, tonumber, type, strsplit = next, tonumber, type, strsplit
local SendAddonMessage, Ambiguate, CTimerAfter, CTimerNewTicker = C_ChatInfo.SendAddonMessage, Ambiguate, C_Timer.After, C_Timer.NewTicker
local GetInstanceInfo, GetBestMapForUnit, GetMapInfo = GetInstanceInfo, C_Map.GetBestMapForUnit, C_Map.GetMapInfo
local UnitName, UnitGUID = UnitName, UnitGUID
local debugstack, print = debugstack, print

-- Try to grab unhooked copies of critical funcs (hooked by some crappy addons)
public.GetBestMapForUnit = GetBestMapForUnit
public.GetMapInfo = GetMapInfo
public.GetInstanceInfo = GetInstanceInfo
public.SendAddonMessage = SendAddonMessage
public.SendChatMessage = SendChatMessage
public.CTimerAfter = CTimerAfter
public.CTimerNewTicker = CTimerNewTicker
public.UnitName = UnitName
public.UnitGUID = UnitGUID
public.SetRaidTarget = SetRaidTarget
public.UnitHealth = UnitHealth
public.UnitHealthMax = UnitHealthMax
public.UnitDetailedThreatSituation = UnitDetailedThreatSituation

-- Version
local usersHash = {}
local usersVersion = {}
local usersGuildVersion = {}
local usersGuildName = {}
local usersDBM = {}
local highestFoundVersion = BIGWIGS_VERSION
local highestFoundGuildVersion = BIGWIGS_GUILD_VERSION

-- Loading
local isMouseDown = true
local loadOnCoreEnabled = {} -- BigWigs modulepacks that should load when a hostile zone is entered or the core is manually enabled, this would be the default plugins Bars, Messages etc
local loadOnZone = {} -- BigWigs modulepack that should load on a specific zone
local loadOnSlash = {} -- BigWigs modulepacks that can load from a chat command
local menus = {} -- contains the menus for BigWigs, once the core is loaded they will get injected
local enableZones = {} -- contains the zones in which BigWigs will enable
local disabledZones -- contains the zones in which BigWigs will enable, but the user has disabled the addon
local worldBosses = {} -- contains the list of world bosses per zone that should enable the core
local fakeZones = { -- Fake zones used as GUI menus
	[-1945]=true, -- Outland
	[-424]=true, -- Pandaria
	[-572]=true, -- Draenor
	[-619]=true, -- Broken Isles
	[-947]=true, -- Azeroth
	[-1647]=true, -- Shadowlands
}

do
	local c = "BigWigs_Classic"
	local bc = public.isBC and "BigWigs_BurningCrusade"
	local lw_c = "LittleWigs_Classic"
	local lw_bc = public.isBC and "LittleWigs_BurningCrusade"

	public.zoneTbl = {
		--[[ BigWigs: Classic ]]--
		[409] = c, -- Molten Core
		[469] = c, -- Blackwing Lair
		[309] = c, -- Zul'Gurub
		[509] = c, -- Ruins of Ahn'Qiraj
		[531] = c, -- Ahn'Qiraj Temple
		[249] = c, -- Onyxia's Lair
		[533] = c, -- Naxxramas
		[-947] = c, -- Azeroth (Fake)
		[-1447] = c, -- Azshara
		[-1419] = c, -- Blasted Lands
		[-1425] = c, -- The Hinterlands
		[-1431] = c, -- Duskwood
		[-1440] = c, -- Ashenvale
		[-1444] = c, -- Feralas
		--[[ BigWigs: The Burning Crusade ]]--
		[-1945] = bc, -- Outland (Fake Menu)
		[-1944] = bc, -- Hellfire Peninsula
		[-1948] = bc, -- Shadowmoon Valley
		[565] = bc, -- Gruul's Lair
		[532] = bc, -- Karazhan
		[548] = bc, -- Coilfang: Serpentshrine Cavern
		[550] = bc, -- Tempest Keep
		[544] = bc, -- Magtheridon's Lair
		[534] = bc, -- The Battle for Mount Hyjal
		[564] = bc, -- Black Temple
		[568] = bc, -- Zul'Aman
		[580] = bc, -- The Sunwell

		--[[ LittleWigs: Classic ]]--
		[33] = lw_c, -- Shadowfang Keep
		[34] = lw_c, --	The Stockade
		[36] = lw_c, -- Deadmines
		[43] = lw_c, --	Wailing Caverns
		[47] = lw_c, --	Razorfen Kraul
		[48] = lw_c, --	Blackfathom Deeps
		[70] = lw_c, --	Uldaman
		[90] = lw_c, --	Gnomeregan
		[109] = lw_c, -- Sunken Temple
		[129] = lw_c, -- Razorfen Downs
		[189] = lw_c, -- Scarlet Monastery
		[209] = lw_c, -- Zul'Farrak
		[229] = lw_c, -- Blackrock Spire
		[230] = lw_c, -- Blackrock Depths
		[289] = lw_c, -- Scholomance
		[329] = lw_c, -- Stratholme
		[349] = lw_c, -- Maraudon
		[389] = lw_c, -- Ragefire Chasm
		[429] = lw_c, -- Dire Maul
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
	}

	public.zoneTblWorld = {
		[-1447] = -947, [-1419] = -947, [-1425] = -947, [-1431] = -947, [-1440] = -947, [-1444] = -947, -- Azeroth
		[-1948] = -1945, [-1944] = -1945, -- Outland
	}
end

-----------------------------------------------------------------------
-- Utility
--

local EnableAddOn, GetAddOnEnableState, GetAddOnInfo, IsAddOnLoaded, LoadAddOn = EnableAddOn, GetAddOnEnableState, GetAddOnInfo, IsAddOnLoaded, LoadAddOn
local GetAddOnMetadata, IsInGroup, IsInRaid, UnitAffectingCombat = GetAddOnMetadata, IsInGroup, IsInRaid, UnitAffectingCombat
local UnitIsDeadOrGhost, UnitSetRole = UnitIsDeadOrGhost, UnitSetRole

local reqFuncAddons = {
	BigWigs_Core = true,
	BigWigs_Options = true,
	BigWigs_Plugins = true,
}

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

-----------------------------------------------------------------------
-- LDB Plugin
--

local dataBroker = ldb:NewDataObject("BigWigs",
	{type = "launcher", label = "BigWigs", icon = "Interface\\AddOns\\BigWigs\\Media\\Icons\\core-disabled"}
)

function dataBroker.OnClick(self, button)
	-- If you are a dev and need the BigWigs options loaded to do something, please come talk to us on Discord about your use case
	if button == "RightButton" then
		if isMouseDown then
			loadCoreAndOpenOptions()
		else
			local trace = debugstack(2)
			public.mstack = trace
			sysprint("|cFFff0000WARNING!|r")
			sysprint("One of your addons was prevented from force loading the BigWigs options.")
			sysprint("Contact us on the BigWigs Discord about this, it should not be happening.")
		end
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
						if strfind(name, "BigWigs", nil, true) then
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

	local function iterateWorldBosses(addon, ...)
		for i = 1, select("#", ...), 2 do
			local rawZone, zoneBoss = select(i, ...)
			local zone, boss = tonumber(rawZone:trim()), tonumber(zoneBoss:trim())
			if zone and boss then
				local tbl = GetMapInfo(-zone)
				if tbl and tbl.name then -- Protect live client from beta client ids
					-- register the zone for enabling.
					enableZones[zone] = "world"
					if not loadOnZone[zone] then loadOnZone[zone] = {} end
					loadOnZone[zone][#loadOnZone[zone] + 1] = addon
					worldBosses[boss] = zone
				end
			else
				local name = GetAddOnInfo(addon)
				sysprint(("The zone ID %q and/or world boss ID %q from the addon %q was not parsable."):format(tostring(rawZone), tostring(zoneBoss), name))
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
		if reqFuncAddons[addon] then
			local trace = debugstack(2)
			public.lstack = trace
			--sysprint("|cFFff0000WARNING!|r")
			--sysprint("One of your addons is force loading the BigWigs options.")
			--sysprint("Contact us on the BigWigs Discord about this, it should not be happening.")
			reqFuncAddons = {}
		end
		return
	end

	--bwFrame:RegisterEvent("GLOBAL_MOUSE_DOWN")
	--bwFrame:RegisterEvent("GLOBAL_MOUSE_UP")

	bwFrame:RegisterEvent("ZONE_CHANGED")
	bwFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	bwFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

	bwFrame:RegisterEvent("CHAT_MSG_ADDON")
	C_ChatInfo.RegisterAddonMessagePrefix("BigWigs")
	C_ChatInfo.RegisterAddonMessagePrefix(public.isBC and "D4BC" or "D4C") -- DBM

	-- LibDBIcon setup
	if type(BigWigsIconClassicDB) ~= "table" then
		BigWigsIconClassicDB = {}
	end
	ldbi:Register("BigWigs", dataBroker, BigWigsIconClassicDB)

	if BigWigsClassicDB then
		-- Somewhat ugly, but saves loading AceDB with the loader instead of with the core
		if BigWigsClassicDB.profileKeys and BigWigsClassicDB.profiles then
			local name = UnitName("player")
			local realm = GetRealmName()
			if name and realm and BigWigsClassicDB.profileKeys[name.." - "..realm] then
				local key = BigWigsClassicDB.profiles[BigWigsClassicDB.profileKeys[name.." - "..realm]]
				if key then
					self.isFakingDBM = key.fakeDBMVersion
					self.isShowingZoneMessages = key.showZoneMessages
				end
				if BigWigsClassicDB.namespaces and BigWigsClassicDB.namespaces.BigWigs_Plugins_Sounds and BigWigsClassicDB.namespaces.BigWigs_Plugins_Sounds.profiles and BigWigsClassicDB.namespaces.BigWigs_Plugins_Sounds.profiles[BigWigsClassicDB.profileKeys[name.." - "..realm]] then
					self.isSoundOn = BigWigsClassicDB.namespaces.BigWigs_Plugins_Sounds.profiles[BigWigsClassicDB.profileKeys[name.." - "..realm]].sound
				end
			end
		end
		-- Cleanup function.
		-- TODO: look into having a way for our boss modules not to create a table when no options are changed.
		if BigWigsClassicDB.namespaces then
			for k,v in next, BigWigsClassicDB.namespaces do
				if strfind(k, "BigWigs_Bosses_", nil, true) and not next(v) then
					BigWigsClassicDB.namespaces[k] = nil
				end
			end
		end
		BigWigsClassicDB.discord = nil -- XXX 9.0.2
	end
	self:BigWigs_CoreOptionToggled(nil, "fakeDBMVersion", self.isFakingDBM)

	local num = tonumber(GetCVar("Sound_NumChannels")) or 0
	if num < 64 then
		SetCVar("Sound_NumChannels", "64") -- Blizzard keeps screwing with addon sound priority so we force this minimum
	end
	num = tonumber(GetCVar("Sound_MaxCacheSizeInBytes")) or 0
	if num < 67108864 then
		SetCVar("Sound_MaxCacheSizeInBytes", "67108864") -- Set the cache to the "Small (64MB)" setting as a minimum
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
		BigWigs_Ulduar = "BigWigs",
		BigWigs_Yogg_Brain = "BigWigs",
		BigWigs_TheEye = "BigWigs",
		-- BigWigs_Sunwell = "BigWigs",
		BigWigs_SSC = "BigWigs",
		-- BigWigs_Outland = "BigWigs",
		BigWigs_Northrend = "BigWigs",
		-- BigWigs_Naxxramas = "BigWigs",
		BigWigs_MC = "BigWigs",
		-- BigWigs_Karazhan = "BigWigs",
		-- BigWigs_Hyjal = "BigWigs",
		BigWigs_Coliseum = "BigWigs",
		BigWigs_Citadel = "BigWigs",
		BigWigs_LK_Valkyr_Marker = "BigWigs",
		BigWigs_BWL = "BigWigs",
		-- BigWigs_BlackTemple = "BigWigs",
		BigWigs_AQ20 = "BigWigs",
		BigWigs_AQ40 = "BigWigs",
		BigWigs_Baradin = "BigWigs",
		BigWigs_Bastion = "BigWigs",
		BigWigs_Blackwing = "BigWigs",
		BigWigs_DragonSoul = "BigWigs",
		BigWigs_Firelands = "BigWigs",
		BigWigs_Throne = "BigWigs",
		bigwigs_zonozzicons = "BigWigs",
		BigWigs_EndlessSpring = "BigWigs",
		BigWigs_HeartOfFear = "BigWigs",
		BigWigs_Mogushan = "BigWigs",
		BigWigs_Pandaria = "BigWigs",
		BigWigs_SiegeOfOrgrimmar = "BigWigs",
		BigWigs_ThroneOfThunder = "BigWigs",
		BigWigs_Draenor = "BigWigs",
		BigWigs_Highmaul = "BigWigs",
		BigWigs_BlackrockFoundry = "BigWigs",
		BigWigs_HellfireCitadel = "BigWigs",
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
		BigWigs_Antorus = "BigWigs",
		BigWigs_ArgusInvasionPoints = "BigWigs",
		BigWigs_BrokenIsles = "BigWigs",
		BigWigs_Nighthold = "BigWigs",
		BigWigs_Nightmare = "BigWigs",
		BigWigs_TombOfSargeras = "BigWigs",
		BigWigs_TrialOfValor = "BigWigs",
		BigWigs_SiegeOfZuldazar = "BigWigs",
		FS_Core = "Abandoned", -- abandoned addon breaking the load order
		BigWigs_Nyalotha = "BigWigs",

		-- Classic Cleanse
		BigWigs_Azeroth = "BigWigs",
		BigWigs_BattleOfDazaralor = "BigWigs",
		BigWigs_BurningCrusade = "BigWigs",
		BigWigs_Cataclysm = "BigWigs",
		BigWigs_Classic = "BigWigs",
		BigWigs_CrucibleOfStorms = "BigWigs",
		BigWigs_EternalPalace = "BigWigs",
		BigWigs_Legion = "BigWigs",
		BigWigs_MistsOfPandaria = "BigWigs",
		BigWigs_Uldir = "BigWigs",
		BigWigs_WarlordsOfDraenor = "BigWigs",
		BigWigs_WrathOfTheLichKing = "BigWigs",
	}
	local delayedMessages = {}

	local warning = "The addon '|cffffff00%s|r' is forcing %s to load prematurely, notify the BigWigs authors!"
	local dontForceLoadList = {
		BigWigs_Core = true,
		BigWigs_Plugins = true,
		BigWigs_Options = true,
		BigWigs_Onyxia = true,
		BigWigs_MoltenCore = true,
		BigWigs_World = true,
		BigWigs_BlackwingLair = true,
		BigWigs_ZulGurub = true,
		BigWigs_AhnQirajRuins = true,
		BigWigs_AhnQirajTemple = true,
		BigWigs_Naxxramas = true,
		BigWigs_Outland = true,
		BigWigs_Karazhan = true,
		BigWigs_Serpentshrine = true,
		BigWigs_TempestKeep = true,
		BigWigs_Hyjal = true,
		BigWigs_BlackTemple = true,
		LittleWigs = true,
	}
	-- Try to teach people not to force load our modules.
	for i = 1, GetNumAddOns() do
		local name = GetAddOnInfo(i)
		if IsAddOnEnabled(i) and not IsAddOnLoadOnDemand(i) then
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
			delayedMessages[#delayedMessages+1] = L.removeAddon:format(name, old[name])
			Popup(L.removeAddon:format(name, old[name]))
		end
	end

	local L = GetLocale()
	local locales = {
		--ruRU = "Russian (ruRU)",
		--itIT = "Italian (itIT)",
		--koKR = "Korean (koKR)",
		--esES = "Spanish (esES)",
		--esMX = "Spanish (esMX)",
		--deDE = "German (deDE)",
		--ptBR = "Portuguese (ptBR)",
		--frFR = "French (frFR)",
	}
	if locales[L] then
		delayedMessages[#delayedMessages+1] = ("BigWigs is missing translations for %s. Can you help? Visit git.io/vpBye or ask us on Discord for more info."):format(locales[L])
	end

	local myGitHash = "@project-abbreviated-hash@" -- The ZIP packager will replace this with the Git hash.
	-- If we find "@" then we're running from Git directly.
	if not strfind(myGitHash, "@", nil, true) then
		local bType = ""
		--@version-classic@
		bType = "c"
		--@end-version-classic@
		--@version-bcc@
		bType = "bcc"
		--@end-version-bcc@
		if public.isBC and bType == "c" then
			delayedMessages[#delayedMessages+1] = "|cFFff0000WARNING!|r You've installed the wrong version of BigWigs."
			delayedMessages[#delayedMessages+1] = "You are playing on Burning Crusade Classic, but have installed BigWigs for original Classic."
			delayedMessages[#delayedMessages+1] = "We recommend avoiding unofficial addon updaters, and using the official CurseForge app to avoid such issues."
		elseif public.isClassic and bType == "bcc" then
			delayedMessages[#delayedMessages+1] = "|cFFff0000WARNING!|r You've installed the wrong version of BigWigs."
			delayedMessages[#delayedMessages+1] = "You are playing on Classic, but have installed BigWigs for Burning Crusade Classic."
			delayedMessages[#delayedMessages+1] = "We recommend avoiding unofficial addon updaters, and using the official CurseForge app to avoid such issues."
		end
	end

	if #delayedMessages > 0 then
		function mod:LOADING_SCREEN_DISABLED()
			bwFrame:UnregisterEvent("LOADING_SCREEN_DISABLED")
			CTimerAfter(0, function() -- Timers aren't fully functional until 1 frame after loading is done
				CTimerAfter(15, function()
					for i = 1, #delayedMessages do
						sysprint(delayedMessages[i])
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

	local pcall, geterrorhandler = pcall, geterrorhandler
	function public:SendMessage(msg, ...)
		if callbackMap[msg] then
			for k,v in next, callbackMap[msg] do
				if type(v) == "function" then
					local success, errorMsg = pcall(v, msg, ...)
					if not success then
						geterrorhandler()(("BigWigs: One of your addons caused an error on the %q callback:\n%s"):format(msg, errorMsg))
					end
				else
					local success, errorMsg = pcall(k[v], k, msg, ...)
					if not success then
						geterrorhandler()(("BigWigs: One of your addons caused an error on the %q callback:\n%s"):format(msg, errorMsg))
					end
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
	local DBMdotRevision         -- The changing version of the local client, changes with every new zip using the project-date-integer packager replacement.
	local DBMdotDisplayVersion   -- "N.N.N" for a release and "N.N.N alpha" for the alpha duration.
	local DBMdotReleaseRevision  -- Hardcoded time, manually changed every release, they use it to track the highest release version, a new DBM release is the only time it will change.
	if public.isBC then
		DBMdotRevision = "20220511054957"
		DBMdotDisplayVersion = "2.5.35"
		DBMdotReleaseRevision = "20220511000000"
	else
		DBMdotRevision = "20220511054957"
		DBMdotDisplayVersion = "1.14.21"
		DBMdotReleaseRevision = "20220511000000"
	end

	local timer, prevUpgradedUser = nil, nil
	local function sendMsg()
		if IsInGroup() then
			SendAddonMessage(public.isBC and "D4BC" or "D4C", "V\t"..DBMdotRevision.."\t"..DBMdotReleaseRevision.."\t"..DBMdotDisplayVersion.."\t"..GetLocale().."\t".."true", IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- LE_PARTY_CATEGORY_INSTANCE = 2
		end
		timer, prevUpgradedUser = nil, nil
	end
	function mod:DBM_VersionCheck(prefix, sender, revision, releaseRevision, displayVersion)
		if prefix == "H" and (BigWigs and BigWigs.db.profile.fakeDBMVersion or self.isFakingDBM) then
			if timer then timer:Cancel() end
			timer = CTimerNewTicker(3.3, sendMsg, 1)
		elseif prefix == "V" then
			usersDBM[sender] = displayVersion
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
	elseif prefix == "D4C" or prefix == "D4BC" then
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
				if not customGuildName then
					local msg = L.warnSeveralReleases:format(diff)
					sysprint(msg)
					Popup(msg)
					RaidNotice_AddMessage(RaidWarningFrame, msg, {r=1,g=1,b=1}, 40)
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
		elseif BigWigsClassicDB and BigWigsClassicDB.breakTime then -- Break timer restoration
			loadAndEnableCore()
		else
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
		if zoneAddon and strfind(zoneAddon, "LittleWigs_", nil, true) and public.isBC then
			zoneAddon = "LittleWigs" -- Collapse into one addon
			if id > 0 and not fakeZones[id] and not warnedThisZone[id] and not IsAddOnEnabled(zoneAddon) then
				warnedThisZone[id] = true
				local msg = L.missingAddOn:format(zoneAddon)
				sysprint(msg)
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
			SendAddonMessage("BigWigs", versionQueryString, groupType == 3 and "INSTANCE_CHAT" or "RAID")
			SendAddonMessage(public.isBC and "D4BC" or "D4C", "H\t", groupType == 3 and "INSTANCE_CHAT" or "RAID") -- Also request DBM versions
			self:ZONE_CHANGED()
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
	dataBroker.icon = "Interface\\AddOns\\BigWigs\\Media\\Icons\\core-enabled"

	-- Send a version query on enable, should fix issues with joining a group then zoning into an instance,
	-- which kills your ability to receive addon comms during the loading process.
	if IsInGroup() then
		SendAddonMessage("BigWigs", versionQueryString, IsInGroup(2) and "INSTANCE_CHAT" or "RAID")
		SendAddonMessage(public.isBC and "D4BC" or "D4C", "H\t", IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- Also request DBM versions
	end

	-- Core is loaded, nil these to force checking BigWigs.db.profile.option
	self.isFakingDBM = nil
	self.isShowingZoneMessages = nil
	self.isSoundOn = nil
end
public.RegisterMessage(mod, "BigWigs_CoreEnabled")

function mod:BigWigs_CoreDisabled()
	dataBroker.icon = "Interface\\AddOns\\BigWigs\\Media\\Icons\\core-disabled"
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
