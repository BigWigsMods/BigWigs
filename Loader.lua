
local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs")
local loader = LibStub("AceAddon-3.0"):NewAddon("BigWigsLoader")

-----------------------------------------------------------------------
-- Generate our version variables
--

local REPO = "REPO"
local ALPHA = "ALPHA"
local RELEASE = "RELEASE"
local BIGWIGS_RELEASE_TYPE, BIGWIGS_RELEASE_REVISION

do
	-- START: MAGIC WOWACE VOODOO VERSION STUFF
	local releaseType = RELEASE
	local releaseRevision = nil
	local releaseString = nil
	--@alpha@
	-- The following code will only be present in alpha ZIPs.
	releaseType = ALPHA
	--@end-alpha@

	-- This will (in ZIPs), be replaced by the highest revision number in the source tree.
	releaseRevision = tonumber("@project-revision@")

	-- If the releaseRevision ends up NOT being a number, it means we're running a SVN copy.
	if type(releaseRevision) ~= "number" then
		releaseRevision = -1
		releaseType = REPO
	end

	-- Then build the release string, which we can add to the interface option panel.
	local majorVersion = GetAddOnMetadata("BigWigs", "Version") or "4.?"
	if releaseType == REPO then
		releaseString = L.sourceCheckout:format(majorVersion)
	elseif releaseType == RELEASE then
		releaseString = L.officialRelease:format(majorVersion, releaseRevision)
	elseif releaseType == ALPHA then
		releaseString = L.alphaRelease:format(majorVersion, releaseRevision)
	end
	BIGWIGS_RELEASE_TYPE = releaseType
	BIGWIGS_RELEASE_REVISION = releaseRevision
	loader.BIGWIGS_RELEASE_STRING = releaseString
	-- END: MAGIC WOWACE VOODOO VERSION STUFF
end

-----------------------------------------------------------------------
-- Locals
--

local ldb = nil
local tooltipFunctions = {}
local pName = UnitName("player")
local next = next
local loaderUtilityFrame = CreateFrame("Frame")

-- Try to grab unhooked copies of critical loading funcs (hooked by some crappy addons)
local GetCurrentMapAreaID = GetCurrentMapAreaID
local SetMapToCurrentZone = SetMapToCurrentZone
loader.GetCurrentMapAreaID = GetCurrentMapAreaID
loader.SetMapToCurrentZone = SetMapToCurrentZone

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
local highestReleaseRevision = BIGWIGS_RELEASE_TYPE == RELEASE and BIGWIGS_RELEASE_REVISION or -1
-- The highestAlphaRevision is so we can alert old alpha users (we didn't previously)
local highestAlphaRevision = BIGWIGS_RELEASE_TYPE == ALPHA and BIGWIGS_RELEASE_REVISION or -1

-- Loading
local loadOnZoneAddons = {} -- Will contain all names of addons with an X-BigWigs-LoadOn-Zone directive. Filled in OnInitialize, garbagecollected in OnEnable.
local loadOnCoreEnabled = {} -- BigWigs modulepacks that should load when a hostile zone is entered or the core is manually enabled, this would be the default plugins Bars, Messages etc
local loadOnZone = {} -- BigWigs modulepack that should load on a specific zone
local loadOnCoreLoaded = {} -- BigWigs modulepacks that should load when the core is loaded
local loadOnWorldBoss = {} -- Packs that should load when targetting a specific mob
-- XXX shouldn't really be named "menus", it's actually panels in interface options now
local menus = {} -- contains the main menus for BigWigs, once the core is loaded they will get injected
local enableZones = {} -- contains the zones in which BigWigs will enable
local worldBosses = {} -- contains the list of world bosses per zone that should enable the core

do
	local c = "BigWigs_Classic"
	local bc = "BigWigs_BurningCrusade"
	local wotlk = "BigWigs_WrathOfTheLichKing"
	local cata = "BigWigs_Cataclysm"
	local lw = "LittleWigs"

	loader.zoneTbl = {
		[696]=c, [755]=c,
		[775]=bc, [780]=bc, [779]=bc, [776]=bc, [465]=bc, [473]=bc, [799]=bc, [782]=bc,
		[604]=wotlk, [543]=wotlk, [535]=wotlk, [529]=wotlk, [527]=wotlk, [532]=wotlk, [531]=wotlk, [609]=wotlk, [718]=wotlk,
		[752]=cata, [758]=cata, [754]=cata, [824]=cata, [800]=cata, [773]=cata,

		[877]=lw, [871]=lw, [874]=lw, [885]=lw, [867]=lw, [919]=lw,
	}
end

-----------------------------------------------------------------------
-- Utility
--

local function sysprint(msg)
	print("|cFF33FF99Big Wigs|r: "..msg)
end

local getGroupMembers = nil
do
	local members = {}
	function getGroupMembers()
		local raid = GetNumGroupMembers()
		local party = GetNumSubgroupMembers()
		if raid == 0 and party == 0 then return end
		wipe(members)
		if raid > 0 then
			for i = 1, raid do
				local n = GetRaidRosterInfo(i)
				if n then members[#members + 1] = n end
			end
		elseif party > 0 then
			members[#members + 1] = pName
			for i = 1, 4 do
				local n = UnitName("party" .. i)
				if n then members[#members + 1] = n end
			end
		end
		return members
	end
end

local function load(obj, name)
	if obj then return true end
	-- Verify that the addon isn't disabled
	local _, _, _, enabled = GetAddOnInfo(name)
	if not enabled then
		sysprint("Error loading " .. name .. " ("..name.." is not enabled)")
		return
	end
	-- Load the addon
	local succ, err = LoadAddOn(name)
	if not succ then
		sysprint("Error loading " .. name .. " (" .. err .. ")")
		return
	end
	return true
end

local function loadAddons(tbl)
	if not tbl then return end
	for i, addon in next, tbl do
		if not IsAddOnLoaded(addon) and load(nil, addon) then
			loader:SendMessage("BigWigs_ModulePackLoaded", addon)
		end
	end
	tbl = nil
end

local function loadZone(zone)
	if not zone then return end
	loadAddons(loadOnZone[zone])
end

local function loadAndEnableCore()
	load(BigWigs, "BigWigs_Core")
	if not BigWigs then return end
	BigWigs:Enable()
end

local function loadCoreAndOpenOptions()
	if not BigWigsOptions and (InCombatLockdown() or UnitAffectingCombat("player")) then
		sysprint(L.blizzRestrictionsConfig)
		return
	end
	loadAndEnableCore()
	load(BigWigsOptions, "BigWigs_Options")
	if not BigWigsOptions then return end
	BigWigsOptions:Open()
end

-----------------------------------------------------------------------
-- Version listing functions
--

local function versionTooltipFunc(tt)
	-- Try to avoid calling getGroupMembers as long as possible.
	-- XXX We should just get a file-local boolean flag that we update
	-- whenever we receive a version reply from someone. That way we
	-- reduce the processing required to open a simple tooltip.
	local add = nil
	for player, version in next, usersRelease do
		if version < highestReleaseRevision then
			add = true
			break
		end
	end
	if not add then
		for player, version in next, usersAlpha do
			-- If this person's alpha version isn't SVN (-1) and it's lower than the highest found release version minus 1 because
			-- of tagging, or it's lower than the highest found alpha version (with a 10 revision leeway) then that person is out-of-date
			if version ~= -1 and (version < (highestReleaseRevision - 1) or version < (highestAlphaRevision - 10)) then
				add = true
				break
			end
		end
	end
	if not add then
		local m = getGroupMembers()
		if m then
			for i, player in next, m do
				if not usersRelease[player] and not usersAlpha[player] then
					add = true
					break
				end
			end
		end
	end
	if add then
		tt:AddLine(L.oldVersionsInGroup, 1, 0, 0, 1)
	end
end

-----------------------------------------------------------------------
-- Loader initialization
--

local reqFuncAddons = {
	BigWigs_Core = true,
	BigWigs_Options = true,
	BigWigs_Plugins = true,
}

function loader:OnInitialize()
	for i = 1, GetNumAddOns() do
		local name, _, _, enabled = GetAddOnInfo(i)
		if enabled and not IsAddOnLoaded(i) and IsAddOnLoadOnDemand(i) then
			local meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-CoreEnabled")
			if meta then
				loadOnCoreEnabled[#loadOnCoreEnabled + 1] = name
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-CoreLoaded")
			if meta then
				loadOnCoreLoaded[#loadOnCoreLoaded + 1] = name
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-ZoneId")
			if meta then
				loadOnZoneAddons[#loadOnZoneAddons + 1] = name
			end
			meta = GetAddOnMetadata(i, "X-BigWigs-LoadOn-WorldBoss")
			if meta then
				loadOnWorldBoss[#loadOnWorldBoss + 1] = name
			end
		elseif not enabled and reqFuncAddons[name] then
			sysprint(L["coreAddonDisabled"])
		end
	end

	-- register for these messages OnInit so we receive these messages when the core and modules oninitialize fires
	self:RegisterMessage("BigWigs_BossModuleRegistered")
	self:RegisterMessage("BigWigs_CoreLoaded")

	local icon = LibStub("LibDBIcon-1.0", true)
	if icon and ldb then
		if not BigWigs3IconDB then BigWigs3IconDB = {} end
		icon:Register("BigWigs", ldb, BigWigs3IconDB)
	end
	self:RegisterTooltipInfo(versionTooltipFunc)

	-- Cleanup function.
	-- TODO: look into having a way for our boss modules not to create a table when no options are changed.
	if BigWigs3DB and BigWigs3DB.namespaces then
		for k,v in next, BigWigs3DB.namespaces do
			if k:find("BigWigs_Bosses_", nil, true) and not next(v) then
				BigWigs3DB.namespaces[k] = nil
			end
		end
	end

	self.OnInitialize = nil
end

do
	local function iterateZones(addon, override, ...)
		for i = 1, select("#", ...) do
			local rawZone = select(i, ...)
			local zone = tonumber(rawZone:trim())
			if zone then
				-- register the zone for enabling.
				enableZones[zone] = true

				if not loadOnZone[zone] then loadOnZone[zone] = {} end
				loadOnZone[zone][#loadOnZone[zone] + 1] = addon

				if override then
					loadOnZone[override][#loadOnZone[override] + 1] = addon
				else
					if not menus[zone] then menus[zone] = true end
				end
			else
				sysprint(("The zone ID %q from the addon %q was not parsable."):format(tostring(rawZone), tostring(addon)))
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
					else
						if not menus[zoneOrBoss] then menus[zoneOrBoss] = true end
					end
				else
					worldBosses[zoneOrBoss] = currentZone
					currentZone = nil
				end
			else
				sysprint(("The zone ID %q from the addon %q was not parsable."):format(tostring(rawZoneOrBoss), tostring(addon)))
			end
		end
	end

	function loader:OnEnable()
		for i, name in next, loadOnZoneAddons do
			local menu = tonumber(GetAddOnMetadata(name, "X-BigWigs-Menu"))
			if menu then
				if not loadOnZone[menu] then loadOnZone[menu] = {} end
				if not menus[menu] then menus[menu] = true end
			end
			local zones = GetAddOnMetadata(name, "X-BigWigs-LoadOn-ZoneId")
			if zones then
				iterateZones(name, menu, strsplit(",", zones))
			end
		end
		loadOnZoneAddons, iterateZones = nil, nil
		for i, name in next, loadOnWorldBoss do
			local menu = tonumber(GetAddOnMetadata(name, "X-BigWigs-Menu"))
			if menu then
				if not loadOnZone[menu] then loadOnZone[menu] = {} end
				if not menus[menu] then menus[menu] = true end
			end
			local zones = GetAddOnMetadata(name, "X-BigWigs-LoadOn-WorldBoss")
			if zones then
				iterateWorldBosses(name, menu, strsplit(",", zones))
			end
		end
		loadOnWorldBoss, iterateWorldBosses = nil, nil

		local old = { -- XXX temp print
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
		}

		-- Try to teach people not to force load our modules.
		for i = 1, GetNumAddOns() do
			local name, _, _, enabled = GetAddOnInfo(i)
			if enabled and not IsAddOnLoadOnDemand(i) then
				for j = 1, select("#", GetAddOnOptionalDependencies(i)) do
					local meta = select(j, GetAddOnOptionalDependencies(i))
					if meta and (meta == "BigWigs_Core" or meta == "BigWigs_Plugins") then
						print("|cFF33FF99Big Wigs|r: The addon '|cffffff00"..name.."|r' is forcing Big Wigs to load prematurely, notify the Big Wigs authors!")
					end
				end
				for j = 1, select("#", GetAddOnDependencies(i)) do
					local meta = select(j, GetAddOnDependencies(i))
					if meta and (meta == "BigWigs_Core" or meta == "BigWigs_Plugins") then
						print("|cFF33FF99Big Wigs|r: The addon '|cffffff00"..name.."|r' is forcing Big Wigs to load prematurely, notify the Big Wigs authors!")
					end
				end
			end

			-- XXX temp print for old stuff
			if old[name] then
				AutoCompleteInfoDelayer:HookScript("OnFinished", function()
					print(L.removeAddon:format(name, old[name]))
				end)
			end

			-- XXX disable addons that break us
			if name == "ReckonersProMending" then -- Dead addon is dead.
				DisableAddOn("ReckonersProMending")
				AutoCompleteInfoDelayer:HookScript("OnFinished", function()
					print("The AddOn 'Reckoner's ProMending' has been disabled due to incompatibility, please remove it.")
				end)
			end
		end

		local L = GetLocale() -- XXX temp
		if L == "ptBR" then
			AutoCompleteInfoDelayer:HookScript("OnFinished", function()
				print("Think you can translate Big Wigs into Brazilian Portuguese (ptBR)? Check out our easy translator tool: www.wowace.com/addons/big-wigs/localization/")
			end)
		elseif L == "esMX" then
			AutoCompleteInfoDelayer:HookScript("OnFinished", function()
				print("Think you can translate Big Wigs into Latin American Spanish (esMX)? Check out our easy translator tool: www.wowace.com/addons/big-wigs/localization/")
			end)
		end

		loaderUtilityFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		loaderUtilityFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
		loaderUtilityFrame:RegisterEvent("LFG_PROPOSAL_SHOW")

		-- Role Updating
		loaderUtilityFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		RolePollPopup:UnregisterEvent("ROLE_POLL_BEGIN")

		loaderUtilityFrame:RegisterEvent("CHAT_MSG_ADDON")
		self:RegisterMessage("BigWigs_AddonMessage")
		self:RegisterMessage("DBM_AddonMessage") -- DBM
		RegisterAddonMessagePrefix("BigWigs")
		RegisterAddonMessagePrefix("D4") -- DBM

		self:RegisterMessage("BigWigs_CoreEnabled")
		self:RegisterMessage("BigWigs_CoreDisabled")

		self:RegisterMessage("BigWigs_CoreOptionToggled", "UpdateDBMFaking")
		-- Somewhat ugly, but saves loading AceDB with the loader instead of with the core
		if BigWigs3DB and BigWigs3DB.profileKeys and BigWigs3DB.profiles then
			local name = UnitName("player")
			local realm = GetRealmName()
			if name and realm and BigWigs3DB.profileKeys[name.." - "..realm] then
				local key = BigWigs3DB.profiles[BigWigs3DB.profileKeys[name.." - "..realm]]
				self.isFakingDBM = key.fakeDBMVersion
				self.isShowingZoneMessages = key.showZoneMessages
			end
		end
		self:UpdateDBMFaking(nil, "fakeDBMVersion", self.isFakingDBM)

		self:GROUP_ROSTER_UPDATE()
		self:ZONE_CHANGED_NEW_AREA()
		self.OnEnable = nil
	end
end

-----------------------------------------------------------------------
-- DBM version collection & faking
--

do
	-- This is a crapfest mainly because DBM's actual handling of versions is a crapfest, I'll try explain how this works...
	local DBMdotRevision = "10680" -- The changing version of the local client, changes with every alpha revision using an SVN keyword.
	local DBMdotReleaseRevision = "10680" -- This is manually changed by them every release, they use it to track the highest release version, a new DBM release is the only time it will change.
	local DBMdotDisplayVersion = "5.4.4" -- Same as above but is changed between alpha and release cycles e.g. "N.N.N" for a release and "N.N.N alpha" for the alpha duration
	function loader:DBM_AddonMessage(channel, sender, prefix, revision, releaseRevision, displayVersion)
		if prefix == "H" and (BigWigs and BigWigs.db.profile.fakeDBMVersion or self.isFakingDBM) then
			SendAddonMessage("D4", "V\t"..DBMdotRevision.."\t"..DBMdotReleaseRevision.."\t"..DBMdotDisplayVersion.."\t"..GetLocale(), IsInGroup(2) and "INSTANCE_CHAT" or "RAID")
		elseif prefix == "V" then
			usersDBM[sender] = displayVersion
			-- If there are people with newer versions than us, suddenly we've upgraded!
			local rev, dotRev = tonumber(revision), tonumber(DBMdotRevision)
			if rev and displayVersion and rev ~= 99999 and rev > dotRev then -- Failsafes
				DBMdotRevision = revision -- Update our local rev with the highest possible rev found including alphas.
				DBMdotReleaseRevision = releaseRevision -- Update our release rev with the highest found, this should be the same for alpha users and latest release users.
				DBMdotDisplayVersion = displayVersion -- Update to the latest display version, including alphas.
				self:DBM_AddonMessage(nil, nil, "H") -- Re-send addon message.
			end
		end
	end
	function loader:UpdateDBMFaking(_, key, value)
		if key == "fakeDBMVersion" and value and IsInGroup() then
			self:DBM_AddonMessage(nil, nil, "H") -- Send addon message if feature is being turned on inside a raid/group.
		end
	end
end

-----------------------------------------------------------------------
-- Callback handler
--

do
	local callbackMap = {}
	function loader:RegisterMessage(msg, func)
		if type(msg) ~= "string" then error(":RegisterMessage(message, function) attempted to register invalid message, must be a string!") end
		if not callbackMap[msg] then callbackMap[msg] = {} end
		callbackMap[msg][self] = func or msg
	end
	function loader:UnregisterMessage(msg)
		if type(msg) ~= "string" then error(":UnregisterMessage(message) attempted to unregister an invalid message, must be a string!") end
		if not callbackMap[msg] then return end
		callbackMap[msg][self] = nil
		if not next(callbackMap[msg]) then
			callbackMap[msg] = nil
		end
	end

	function loader:SendMessage(msg, ...)
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
					loader.UnregisterMessage(module, k)
				end
			end
		end
	end
	loader:RegisterMessage("BigWigs_OnBossDisable", UnregisterAllMessages)
	loader:RegisterMessage("BigWigs_OnPluginDisable", UnregisterAllMessages)
end

-----------------------------------------------------------------------
-- Events
--

loaderUtilityFrame:SetScript("OnEvent", function(_, event, ...)
	loader[event](loader, ...)
end)

-- Role Updating
function loader:ACTIVE_TALENT_GROUP_CHANGED()
	if IsInGroup() then
		local _, _, diff = GetInstanceInfo()
		if IsPartyLFG() and diff ~= 14 then return end

		local tree = GetSpecialization()
		if not tree then return end -- No spec selected

		local role = GetSpecializationRole(tree)
		if UnitGroupRolesAssigned("player") ~= role then
			if InCombatLockdown() or UnitAffectingCombat("player") then
				loaderUtilityFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
				return
			end
			UnitSetRole("player", role)
		end
	end
end

-- LFG/R Timer
function loader:LFG_PROPOSAL_SHOW()
	if not self.LFGFrame then
		local f = CreateFrame("Frame", nil, LFGDungeonReadyDialog)
		f:SetPoint("BOTTOM", LFGDungeonReadyDialog, "BOTTOM", 0, -60)
		f:SetSize(100, 100)
		f:Show()
		f.start = GetTime()
		self.LFGFrame = f

		local text = f:CreateFontString(nil, "OVERLAY")
		text:SetPoint("CENTER", f, "CENTER")
		text:SetFont(TextStatusBarText:GetFont(), 11, "OUTLINE")
		text:SetText(40)
		f.text = text

		f:SetScript("OnUpdate", function(frame)
			local t = GetTime() - frame.start
			frame.text:SetFormattedText("Big Wigs: %.1f", 40-t)
		end)

		self.LFG_PROPOSAL_SHOW = function() loader.LFGFrame.start = GetTime() end
	end
end

-- Misc
function loader:CHAT_MSG_ADDON(prefix, msg, _, sender)
	if prefix == "BigWigs" then
		local bwPrefix, bwMsg = msg:match("^(%u-):(.+)")
		if bwPrefix then
			self:SendMessage("BigWigs_AddonMessage", bwPrefix, bwMsg, sender)
		end
	elseif prefix == "D4" then
		self:SendMessage("DBM_AddonMessage", sender, strsplit("\t", msg))
	end
end

do
	local warnedOutOfDate, warnedExtremelyOutOfDate = nil, nil

	loaderUtilityFrame.timer = loaderUtilityFrame:CreateAnimationGroup()
	loaderUtilityFrame.timer:SetScript("OnFinished", function()
		if IsInGroup() then
			SendAddonMessage("BigWigs", (BIGWIGS_RELEASE_TYPE == RELEASE and "VR:%d" or "VRA:%d"):format(BIGWIGS_RELEASE_REVISION), IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- LE_PARTY_CATEGORY_INSTANCE = 2
		end
	end)
	local anim = loaderUtilityFrame.timer:CreateAnimation()
	anim:SetDuration(3)

	function loader:BigWigs_AddonMessage(event, prefix, message, sender)
		if prefix == "VR" or prefix == "VQ" then
			if prefix == "VQ" then
				loaderUtilityFrame.timer:Stop()
				loaderUtilityFrame.timer:Play()
			end
			message = tonumber(message)
			-- XXX The > 14k check is a hack for now until I find out what addon is sending a stupidly large version (20032). This is probably being done to farm BW versions, when a version of 0 should be used.
			if not message or message == 0 or message > 14000 then return end -- Allow addons to query Big Wigs versions by using a version of 0, but don't add them to the user list.
			usersRelease[sender] = message
			usersAlpha[sender] = nil
			if message > highestReleaseRevision then highestReleaseRevision = message end
			if BIGWIGS_RELEASE_TYPE == RELEASE and BIGWIGS_RELEASE_REVISION ~= -1 and message > BIGWIGS_RELEASE_REVISION then
				if not warnedOutOfDate then
					sysprint(L.newReleaseAvailable)
					warnedOutOfDate = true
				end
				if not warnedExtremelyOutOfDate and (message - BIGWIGS_RELEASE_REVISION) > 120 then
					warnedExtremelyOutOfDate = true
					sysprint(L.extremelyOutdated)
					RaidNotice_AddMessage(RaidWarningFrame, L.extremelyOutdated, {r=1,g=1,b=1})
				end
			end
		elseif prefix == "VRA" or prefix == "VQA" then
			if prefix == "VQA" then
				loaderUtilityFrame.timer:Stop()
				loaderUtilityFrame.timer:Play()
			end
			message = tonumber(message)
			-- XXX The > 14k check is a hack for now until I find out what addon is sending a stupidly large version (20032). This is probably being done to farm BW versions, when a version of 0 should be used.
			if not message or message == 0 or message > 14000 then return end -- Allow addons to query Big Wigs versions by using a version of 0, but don't add them to the user list.
			usersAlpha[sender] = message
			usersRelease[sender] = nil
			if message > highestAlphaRevision then highestAlphaRevision = message end
			if BIGWIGS_RELEASE_TYPE == ALPHA and BIGWIGS_RELEASE_REVISION ~= -1 and ((message-10) > BIGWIGS_RELEASE_REVISION or highestReleaseRevision > BIGWIGS_RELEASE_REVISION) then
				if not warnedOutOfDate then
					sysprint(L.alphaOutdated)
					warnedOutOfDate = true
				end
				if not warnedExtremelyOutOfDate and ((message - BIGWIGS_RELEASE_REVISION) > 120 or (highestReleaseRevision - BIGWIGS_RELEASE_REVISION) > 120) then
					warnedExtremelyOutOfDate = true
					sysprint(L.extremelyOutdated)
					RaidNotice_AddMessage(RaidWarningFrame, L.extremelyOutdated, {r=1,g=1,b=1})
				end
			end
		end
	end
end

do
	local queueLoad = {}
	-- Kazzak, Doomwalker, Salyis's Warband, Sha of Anger, Nalak, Oondasta
	local warnedThisZone = {[465]=true,[473]=true,[807]=true,[809]=true,[928]=true,[929]=true} -- World Bosses
	function loader:PLAYER_REGEN_ENABLED()
		self:ACTIVE_TALENT_GROUP_CHANGED() -- Force role check
		loaderUtilityFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")

		local shouldPrint = false
		for k,v in next, queueLoad do
			if v == "unloaded" and load(BigWigs, "BigWigs_Core") then
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

	function loader:PLAYER_TARGET_CHANGED()
		local guid = UnitGUID("target")
		if guid then
			local mobId = tonumber(guid:sub(6, 10), 16)
			if worldBosses[mobId] then
				local id = worldBosses[mobId]
				if InCombatLockdown() or UnitAffectingCombat("player") then
					if not queueLoad[id] then
						queueLoad[id] = "unloaded"
						loaderUtilityFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
						sysprint(L.blizzRestrictionsZone)
					end
				else
					queueLoad[id] = "loaded"
					if load(BigWigs, "BigWigs_Core") then
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

	function loader:ZONE_CHANGED_NEW_AREA()
		-- Zone checking
		local inside = IsInInstance()
		local id
		if not inside and WorldMapFrame:IsShown() then
			local prevId = GetCurrentMapAreaID()
			SetMapToCurrentZone()
			id = GetCurrentMapAreaID()
			SetMapByID(prevId)
		else
			SetMapToCurrentZone()
			id = GetCurrentMapAreaID()
		end

		-- Module loading
		if enableZones[id] then
			if enableZones[id] == "world" then
				if BigWigs and not UnitIsDeadOrGhost("player") then
					BigWigs:Disable() -- Might be leaving an LFR and entering a world enable zone, disable first
				end
				loaderUtilityFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
				self:PLAYER_TARGET_CHANGED()
			else
				loaderUtilityFrame:UnregisterEvent("PLAYER_TARGET_CHANGED")
				if not IsEncounterInProgress() and (InCombatLockdown() or UnitAffectingCombat("player")) then
					if not queueLoad[id] then
						queueLoad[id] = "unloaded"
						loaderUtilityFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
						sysprint(L.blizzRestrictionsZone)
					end
				else
					queueLoad[id] = "loaded"
					if load(BigWigs, "BigWigs_Core") then
						if BigWigs:IsEnabled() and loadOnZone[id] then
							loadZone(id)
						else
							BigWigs:Enable()
						end
					end
				end
			end
		else
			loaderUtilityFrame:UnregisterEvent("PLAYER_TARGET_CHANGED")
			if BigWigs and not UnitIsDeadOrGhost("player") then
				BigWigs:Disable() -- Alive in a non-enable zone, disable
			end
		end

		-- Lacking zone modules
		if (BigWigs and BigWigs.db.profile.showZoneMessages == false) or self.isShowingZoneMessages == false then return end
		local zoneAddon = self.zoneTbl[id]
		if zoneAddon and not warnedThisZone[id] then
			local _, _, _, enabled = GetAddOnInfo(zoneAddon)
			if not enabled then
				warnedThisZone[id] = true
				local msg = L.missingAddOn:format(zoneAddon)
				sysprint(msg)
				RaidNotice_AddMessage(RaidWarningFrame, msg, {r=1,g=1,b=1})
			end
		end
	end
end

do
	local grouped = nil
	function loader:GROUP_ROSTER_UPDATE()
		local groupType = (IsInGroup(2) and 3) or (IsInRaid() and 2) or (IsInGroup() and 1) -- LE_PARTY_CATEGORY_INSTANCE = 2
		if (not grouped and groupType) or (grouped and groupType and grouped ~= groupType) then
			grouped = groupType
			SendAddonMessage("BigWigs", (BIGWIGS_RELEASE_TYPE == RELEASE and "VQ:%d" or "VQA:%d"):format(BIGWIGS_RELEASE_REVISION), groupType == 3 and "INSTANCE_CHAT" or "RAID")
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

function loader:BigWigs_BossModuleRegistered(_, _, module)
	if module.worldBoss then
		enableZones[module.zoneId] = "world"
		worldBosses[module.worldBoss] = module.zoneId
	else
		enableZones[module.zoneId] = true
	end

	local id = module.otherMenu or module.zoneId
	if type(menus[id]) ~= "table" then menus[id] = {} end
	menus[id][#menus[id]+1] = module
end

function loader:BigWigs_CoreEnabled()
	if ldb then
		ldb.icon = "Interface\\AddOns\\BigWigs\\Textures\\icons\\core-enabled"
	end

	-- Send a version query on enable, should fix issues with joining a group then zoning into an instance,
	-- which kills your ability to receive addon comms during the loading process.
	if IsInGroup() then
		SendAddonMessage("BigWigs", (BIGWIGS_RELEASE_TYPE == RELEASE and "VQ:%d" or "VQA:%d"):format(BIGWIGS_RELEASE_REVISION), IsInGroup(2) and "INSTANCE_CHAT" or "RAID")
		SendAddonMessage("D4", "H\t", IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- Also request DBM versions
	end

	-- Core is loaded, nil these to force checking BigWigs.db.profile.option
	self.isFakingDBM = nil
	self.isShowingZoneMessages = nil

	loadAddons(loadOnCoreEnabled)

	-- core is enabled, unconditionally load the zones
	loadZone(GetCurrentMapAreaID())
end

function loader:BigWigs_CoreDisabled()
	if ldb then
		ldb.icon = "Interface\\AddOns\\BigWigs\\Textures\\icons\\core-disabled"
	end
end

function loader:BigWigs_CoreLoaded()
	loadAddons(loadOnCoreLoaded)
end

-----------------------------------------------------------------------
-- API
--

function loader:RegisterTooltipInfo(func)
	for i, v in next, tooltipFunctions do
		if v == func then
			error(("The function %q has already been registered."):format(func))
		end
	end
	tooltipFunctions[#tooltipFunctions+1] = func
end

function loader:GetZoneMenus()
	return menus
end

function loader:LoadZone(zone)
	loadZone(zone)
end

-----------------------------------------------------------------------
-- LDB Plugin
--

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

-----------------------------------------------------------------------
-- Slash commands
--

hash_SlashCmdList["/bw"] = nil
hash_SlashCmdList["/bigwigs"] = nil
SLASH_BigWigs1 = "/bw"
SLASH_BigWigs2 = "/bigwigs"
SlashCmdList.BigWigs = loadCoreAndOpenOptions

do
	local hexColors = nil
	local coloredNames = setmetatable({}, {__index =
		function(self, key)
			if type(key) == "nil" then return nil end
			local _, class = UnitClass(key)
			if class then
				self[key] = hexColors[class] .. key:gsub("%-.+", "*") .. "|r" -- Replace server names with *
			else
				self[key] = "|cffcccccc" .. key:gsub("%-.+", "*") .. "|r" -- Replace server names with *
			end
			return self[key]
		end
	})
	local function coloredNameVersion(name, version, alpha)
		if version == -1 then version = "svn" alpha = nil end
		return ("%s|cffcccccc(%s%s)|r"):format(coloredNames[name], version or "unknown", alpha and "-alpha" or "")
	end
	local function showVersions()
		local m = getGroupMembers()
		if not m then return end
		if not hexColors then
			hexColors = {}
			for k, v in next, (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS) do
				hexColors[k] = "|cff" .. ("%02x%02x%02x"):format(v.r * 255, v.g * 255, v.b * 255)
			end
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
				bad[#bad+1] = coloredNames[player]
			end
		end
		if #good > 0 then print(L.upToDate, unpack(good)) end
		if #ugly > 0 then print(L.outOfDate, unpack(ugly)) end
		if #crazy > 0 then print(L.dbmUsers, unpack(crazy)) end
		if #bad > 0 then print(L.noBossMod, unpack(bad)) end
	end

	SLASH_BIGWIGSVERSION1 = "/bwv"
	SlashCmdList.BIGWIGSVERSION = showVersions
end

-----------------------------------------------------------------------
-- Interface options
--

do
	local frame = CreateFrame("Frame", nil, UIParent)
	frame.name = "Big Wigs"
	frame:Hide()
	loader.RemoveInterfaceOptions = function()
		for k, f in next, INTERFACEOPTIONS_ADDONCATEGORIES do
			if f == frame then
				tremove(INTERFACEOPTIONS_ADDONCATEGORIES, k)
				break
			end
		end
		frame:SetScript("OnShow", nil)
		loader.RemoveInterfaceOptions = nil
	end
	frame:SetScript("OnShow", function()
		if not BigWigsOptions and (InCombatLockdown() or UnitAffectingCombat("player")) then
			sysprint(L.blizzRestrictionsConfig)
			return
		end

		loader:RemoveInterfaceOptions()
		loadCoreAndOpenOptions()
		InterfaceOptionsFrameOkay:Click()
		loadCoreAndOpenOptions()
	end)

	InterfaceOptions_AddCategory(frame)
end

BigWigsLoader = loader -- Set global

