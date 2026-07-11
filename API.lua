local addonTbl
do
	local _
	_, addonTbl = ...
end
local API = {}
addonTbl.API = API
local type, next, error = type, next, error

local function CopyTable(settingsTable)
	local copy = {}
	for key, value in next, settingsTable do
		if type(value) == "table" then
			copy[key] = CopyTable(value)
		else
			copy[key] = value
		end
	end
	return copy
end

--------------------------------------------------------------------------------
-- Addons creating bars
--

-- Allows addons to show a custom bar to the user
function API.CreateBarFromAddon(addonName, barText, barIcon, barTime)
	if type(addonName) ~= "string" or #addonName < 3 then error("Invalid addon name for bar creation.") end
	if type(barText) ~= "string" or #barText < 3 then error("Invalid text for bar creation.") end
	local iconType = type(barIcon)
	if iconType ~= "string" and iconType ~= "number" then error("Invalid icon for bar creation.") end
	if type(barTime) ~= "number" then error("Invalid bar time for bar creation.") end
	local L = API:GetLocale("BigWigs")
	addonTbl.loaderPublic.Print(L.showAddonBar:format(addonName, barText))
	addonTbl.LoadAndEnableCore()
	addonTbl.loaderPublic:SendMessage("BigWigs_StartBar", nil, nil, barText, barTime, barIcon)
	addonTbl.loaderPublic:SendMessage("BigWigs_Timer", nil, nil, barTime, barTime, barText, 0, barIcon, false, true)
end

-- Allows addons to send custom bars to the group
function API.SendBarToGroup(addonName, barText, barTime)
	if type(addonName) ~= "string" or #addonName < 3 then error("Invalid addon name for bar creation.") end
	if type(barText) ~= "string" or #barText < 3 then error("Invalid text for bar creation.") end
	if type(barTime) ~= "number" or barTime < 3 then error("Invalid bar time for bar creation.") end
	addonTbl.LoadAndEnableCore()
	local bars = BigWigs:GetPlugin("Bars", true)
	if bars then
		bars:SendCustomBarToGroup(barText, barTime)
	end
end

--------------------------------------------------------------------------------
-- Bar Styles
--

do
	local currentAPIVersion = 1
	local errorWrongAPI = "The bar style API version is now %d; the bar style %q needs to be updated for this version of BigWigs."
	local errorAlreadyExist = "Trying to register %q as a bar styler, but it already exists."
	local function noop() end
	local barStyles = {}
	-- For more on bar styles, visit: https://github.com/BigWigsMods/BigWigs/wiki/Custom-Bar-Styles
	function API:RegisterBarStyle(key, styleData)
		if type(key) ~= "string" then error("Bar style must be a string.") end
		if type(styleData) ~= "table" then error("Bar style data must be a table.") end
		if type(styleData.version) ~= "number" then error("Bar style version must be a number.") end
		if type(styleData.apiVersion) ~= "number" then error("Bar style apiVersion must be a number.") end
		if type(styleData.GetStyleName) ~= "function" then error("Bar style GetStyleName must be a function.") end
		if type(styleData:GetStyleName()) ~= "string" then error("Bar style GetStyleName() return must be a string.") end
		if styleData.apiVersion ~= currentAPIVersion then error(errorWrongAPI:format(currentAPIVersion, key)) end
		if barStyles[key] and barStyles[key].version == styleData.version then error(errorAlreadyExist:format(key)) end
		if not barStyles[key] or barStyles[key].version < styleData.version then
			if not styleData.ApplyStyle then styleData.ApplyStyle = noop end
			if not styleData.BarStopped then styleData.BarStopped = noop end
			if not styleData.GetSpacing then styleData.GetSpacing = noop end
			barStyles[key] = styleData
		end
	end
	function API:GetBarStyle(key)
		if type(key) ~= "string" then error("Bar style must be a string.") end
		local style = barStyles[key]
		if style then
			return style
		end
	end
	function API:GetBarStyleList()
		local list = {}
		for k, v in next, barStyles do
			list[k] = v:GetStyleName()
		end
		return list
	end
end

--------------------------------------------------------------------------------
-- Configuration
--

do
	local list = {
		["PrivateAuras"] = true,
	}
	function API.OpenConfigToPanel(panel)
		if list[panel] then
			addonTbl.LoadCoreAndOptions()
			if BigWigsOptions then
				BigWigsOptions:Close()
				BigWigsOptions:Open(panel)
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Countdown
--

do
	local voices = {}
	function API:RegisterCountdown(id, name, data)
		if not data then data, name = name, id end
		if type(id) ~= "string" then error("Countdown name must be a string.") end
		if type(data) ~= "table" or #data < 5 or #data > 10 then error("Countdown data must be an indexed table with 5-10 entries.") end
		if voices[id] then error(("Countdown %q already registered."):format(id)) end

		voices[id] = { name = name }
		for i = 1, #data do
			voices[id][i] = data[i]
		end
	end
	function API:GetCountdownList()
		local list = {}
		for k, v in next, voices do
			list[k] = v.name
		end
		return list
	end
	function API:HasCountdown(id)
		return voices[id] and true
	end
	function API:GetCountdownSound(id, index)
		return voices[id] and voices[id][index]
	end
end

--------------------------------------------------------------------------------
-- Locale
--

do
	local tbl = {}
	local myRegion = GetLocale()
	function API:NewLocale(locale, region)
		if region == "enUS" or region == myRegion then
			if not tbl[locale] then
				tbl[locale] = {}
			end
			return tbl[locale]
		end
	end
	function API:GetLocale(locale)
		if tbl[locale] then
			return tbl[locale]
		end
	end
end

do
	local localeTable = {}
	function API.GetBossModuleLocale(moduleName)
		if localeTable[moduleName] then
			return CopyTable(localeTable[moduleName])
		end
	end
	function API.SetBossModuleLocale(moduleName, moduleLocaleTable)
		if API.IsLocale("enUS") then error("This function is for non-default locales only.") return end
		if type(moduleName) ~= "string" then error("Module name must be a string.") return end
		if type(moduleLocaleTable) ~= "table" then error("Locale must be a table.") return end
		if localeTable[moduleName] then error(("Locale table for module %q already exists."):format(moduleName)) return end
		localeTable[moduleName] = moduleLocaleTable
	end
end

do
	local currentLocale = GetLocale()
	function API.IsLocale(localeName)
		return localeName == currentLocale
	end
end

--------------------------------------------------------------------------------
-- Profile import/export
--

-- addonName: Input the name of YOUR addon, i.e. the addon making the profile request
-- optionalCustomProfileName: Providing this optional name will create a new profile by that name (if it doesn't already exist) and then swap to it.
-- optionalCallbackFunction: You can supply a callback function that will return false if the user declined the profile import, and true if the user accepted.
function API.RegisterProfile(addonName, profileString, optionalCustomProfileName, optionalCallbackFunction)
	if type(addonName) ~= "string" or #addonName < 3 then error("Invalid addon name for profile import.") return end
	if type(profileString) ~= "string" or #profileString < 3 then error("Invalid profile string for profile import.") return end
	if optionalCustomProfileName and (type(optionalCustomProfileName) ~= "string" or #optionalCustomProfileName < 3) then error("Invalid custom profile name for the string you want to import.") return end
	if optionalCallbackFunction and type(optionalCallbackFunction) ~= "function" then error("Invalid custom callback function for the string you want to import.") return end
	addonTbl.LoadCoreAndOptions()
	local valid, bossExport = BigWigsOptions.VerifyAddOnProfileString(profileString)
	if not valid or bossExport then error("Invalid profile string for profile import.") return end
	BigWigsOptions.SaveImportStringDataFromAddOn(addonName, profileString, optionalCustomProfileName, optionalCallbackFunction)
end

-- addonName: Input the name of YOUR addon, i.e. the addon making the profile request
-- optionalCallbackFunction: You can supply a callback function that will return false if the user declined the profile import, and true if the user accepted.
---- WARNING: If you're calling this API from some UI profile installer, we strongly recommend using a callback function, as this is an async process.
---- You may want to have your UI state "Waiting..." while the import is in progress, and then continue whenever your callback function is triggered.
---- This is required as we may need to load multiple addons with bosses in them to apply the profiles, and loading them all in the same execution path could lock up the game.
function API.ImportBossOptions(addonName, bossString, optionalCallbackFunction)
	if type(addonName) ~= "string" or #addonName < 3 then error("Invalid addon name for boss import.") return end
	if type(bossString) ~= "string" or #bossString < 3 then error("Invalid boss string for import.") return end
	if optionalCallbackFunction and type(optionalCallbackFunction) ~= "function" then error("Invalid custom callback function for the string you want to import.") return end
	addonTbl.LoadCoreAndOptions()
	local valid, bossExport = BigWigsOptions.VerifyAddOnProfileString(bossString)
	if not valid or not bossExport then error("Invalid boss string for import.") return end
	BigWigsOptions.SaveImportStringDataFromAddOn(addonName, bossString, nil, optionalCallbackFunction)
end

-- addonName: Input the name of YOUR addon, i.e. the addon making the profile request.
-- profileName: The profile name you are requesting.
function API.RequestProfile(addonName, profileName)
	if type(addonName) ~= "string" or #addonName < 3 then error("Invalid addon name for profile request.") return end
	if type(profileName) ~= "string" then error("Invalid profile name for profile request.") return end
	if not API.IsValidProfile(profileName) then error("The profile being requested doesn't exist.") return end
	local L = API:GetLocale("BigWigs")
	addonTbl.loaderPublic.Print(L.requestAddonProfile:format(addonName, profileName))
	addonTbl.LoadCoreAndOptions()
	return BigWigsOptions.RequestProfile(addonName, profileName)
end

-- profileName: The profile name to check the validity of.
function API.IsValidProfile(profileName)
	if type(profileName) ~= "string" then error("Cannot check the validity of a profile that isn't a string.") return end
	local profileList = {}
	addonTbl.loaderPublic.db:GetProfiles(profileList)
	for i = 1, #profileList do
		if profileList[i] == profileName then
			return true
		end
	end
	return false
end

-- Fetch the name of the current profile
function API.GetProfileName()
	local name = addonTbl.loaderPublic.db:GetCurrentProfile()
	return name
end

do
	local popup = CreateFrame("Frame", nil, UIParent)
	popup:Hide()
	popup:SetPoint("CENTER", UIParent, "CENTER")
	popup:SetSize(320, 72)
	popup:EnableMouse(true) -- Do not allow click-through on the frame
	popup:SetFrameStrata("TOOLTIP")
	popup:SetFrameLevel(120) -- Lots of room to draw under it
	popup:SetFixedFrameStrata(true)
	popup:SetFixedFrameLevel(true)

	local border = CreateFrame("Frame", nil, popup, "DialogBorderOpaqueTemplate")
	border:SetAllPoints(popup)

	local textFrame = popup:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	textFrame:SetSize(290, 0)
	textFrame:SetPoint("TOP", 0, -16)
	textFrame:SetText("BigWigs")

	local function newButton(newText)
		local button = CreateFrame("Button", nil, popup)
		button:SetSize(128, 21)
		button:SetNormalFontObject(GameFontNormal)
		button:SetHighlightFontObject(GameFontHighlight)
		button:SetNormalTexture(130763) -- "Interface\\Buttons\\UI-DialogBox-Button-Up"
		button:GetNormalTexture():SetTexCoord(0.0, 1.0, 0.0, 0.71875)
		button:SetPushedTexture(130761) -- "Interface\\Buttons\\UI-DialogBox-Button-Down"
		button:GetPushedTexture():SetTexCoord(0.0, 1.0, 0.0, 0.71875)
		button:SetHighlightTexture(130762) -- "Interface\\Buttons\\UI-DialogBox-Button-Highlight"
		button:GetHighlightTexture():SetTexCoord(0.0, 1.0, 0.0, 0.71875)
		button:SetText(newText)
		return button
	end

	local acceptButton = newButton(ACCEPT)
	acceptButton:SetPoint("BOTTOMRIGHT", popup, "BOTTOM", -6, 16)
	local cancelButton = newButton(CANCEL)
	cancelButton:SetPoint("LEFT", acceptButton, "RIGHT", 13, 0)
	popup:SetScript("OnKeyDown", function(_, key)
		if key == "ESCAPE" then
			cancelButton:Click()
		end
	end)

	-- addonName: Input the name of YOUR addon, i.e. the addon making the profile request
	-- profileName: If the profile you're trying to swap to doesn't exist, this function will return false, it will return true if the profile was found and the popup was displayed to the user
	-- optionalCallbackFunction: You can supply a callback function that will return false if the user declined the profile import, and true if the user accepted.
	function API.SwapProfile(addonName, profileName, optionalCallbackFunction)
		if type(addonName) ~= "string" or #addonName < 3 then error("Invalid addon name for profile import.") return end
		if type(profileName) ~= "string" then error("Invalid profile name for profile import.") return end
		if not API.IsValidProfile(profileName) then return false end
		if optionalCallbackFunction and type(optionalCallbackFunction) ~= "function" then error("Invalid custom callback function for the profile you want to swap to.") return end
		if profileName == API.GetProfileName() then error("You cannot swap to the same profile.") return end
		popup:Show()
		textFrame:SetText(API:GetLocale("BigWigs").confirm_profile_swap:format(addonName, profileName))
		local height = 61 + textFrame:GetHeight()
		popup:SetHeight(height)

		acceptButton:ClearAllPoints()
		acceptButton:SetPoint("BOTTOMRIGHT", popup, "BOTTOM", -6, 16)

		acceptButton:SetScript("OnClick", function()
			popup:Hide()
			acceptButton:SetScript("OnClick", nil)
			cancelButton:SetScript("OnClick", nil)
			addonTbl.loaderPublic.db:SetProfile(profileName)
			if optionalCallbackFunction then
				optionalCallbackFunction(true)
			end
		end)
		cancelButton:SetScript("OnClick", function()
			popup:Hide()
			cancelButton:SetScript("OnClick", nil)
			acceptButton:SetScript("OnClick", nil)
			if optionalCallbackFunction then
				optionalCallbackFunction(false)
			end
		end)
		return true
	end
end

--------------------------------------------------------------------------------
-- Slash commands
--

do
	local slashTable = {}
	local slashNoUpdatesTable = {}
	local strsub = string.sub
	-- Registers a slash command
	function API.RegisterSlashCommand(rawSlashName, slashFunc, noUpdates)
		local slashName = strsub(rawSlashName, 2)
		if not slashTable[slashName] then
			_G["SLASH_"..slashName.."1"] = rawSlashName
			SlashCmdList[slashName] = function(text)
				local func = slashTable[slashName]
				func(text)
				if slashTable[slashName] ~= func then -- Did this slash command load an addon that changed what the slash command does?
					slashTable[slashName](text) -- Then call the new function also
				end
			end
		end
		if not slashNoUpdatesTable[slashName] then
			slashTable[slashName] = slashFunc
			if noUpdates then
				slashNoUpdatesTable[slashName] = true
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Specialization (LibSpecialization)
--

do
	local listID, listRole, listPosition = {}, {}, {}
	do
		local LibSpec = LibStub("LibSpecialization", true)
		if LibSpec then
			local function addToTable(specID, role, position, playerName)
				listID[playerName] = specID
				listRole[playerName] = role
				listPosition[playerName] = position
			end
			local lsTable = {}
			LibSpec.RegisterGroup(lsTable, addToTable)
			LibSpec.RegisterGuild(lsTable, addToTable)
		end
	end
	function API.GetSpecializationID(playerName)
		return listID[playerName]
	end
	function API.GetSpecializationRole(playerName)
		return listRole[playerName]
	end
	function API.GetSpecializationPosition(playerName)
		return listPosition[playerName]
	end
end

--------------------------------------------------------------------------------
-- Spell renames
--

do
	local tbl = {}
	-- This function provides external addons with the spell renames that we use in our modules
	function API.GetSpellRename(spellId)
		return tbl[spellId]
	end
	function API.SetSpellRename(spellId, text)
		if type(spellId) ~= "number" then error("Invalid spell ID for spell rename.") end
		if type(text) ~= "string" or #text < 3 then error("Invalid spell text for spell rename.") end
		tbl[spellId] = text
	end
end

--------------------------------------------------------------------------------
-- Tools/Plugins option tables
--

do -- Tools
	local tbl = {}
	-- Get all AceGUI option tables under the "Tools" category
	function API.GetToolOptions()
		return CopyTable(tbl)
	end
	-- Register an AceGUI options table for a module under the "Tools" category
	function API.RegisterToolOptions(key, settingsTable)
		if type(key) ~= "string" then error("The key needs to be a string.") end
		if type(settingsTable) ~= "table" then error("The settings table needs to be a table.") end
		tbl[key] = settingsTable
	end
end

do -- Plugins
	local tbl = {}
	-- Get all AceGUI option tables under the "Tools" category
	function API.GetPluginOptions()
		return CopyTable(tbl)
	end
	-- Register an AceGUI options table for a module under the "Tools" category
	function API.RegisterPluginOptions(key, settingsTable)
		if type(key) ~= "string" then error("The key needs to be a string.") end
		if type(settingsTable) ~= "table" then error("The settings table needs to be a table.") end
		tbl[key] = settingsTable
	end
end

--------------------------------------------------------------------------------
-- Tooltip
--

do
	local bwTooltip = CreateFrame("GameTooltip", "BigWigsTooltip", UIParent, "GameTooltipTemplate")
	function API.GetTooltip()
		return bwTooltip
	end
end

--------------------------------------------------------------------------------
-- Utility
--

do
	local floor = math.floor
	function API.SecondsToTime(seconds, noFloat)
		local L = API:GetLocale("BigWigs")
		if seconds > 60 then
			local min = floor(seconds/60)
			local sec = seconds % 60
			return L.shortMinutesAndSeconds:format(min, sec)
		elseif seconds < 10 and not noFloat then
			local sec = floor(seconds * 10) / 10 -- Turn 9.965 into 9.9 not 10
			return L.shortSubTenSeconds:format(sec)
		else
			return L.shortSecondsOnly:format(seconds)
		end
	end
end

--------------------------------------------------------------------------------
-- Validation
--

do
	local validFramePoints = {
		["TOPLEFT"] = true, ["TOPRIGHT"] = true, ["BOTTOMLEFT"] = true, ["BOTTOMRIGHT"] = true,
		["TOP"] = true, ["BOTTOM"] = true, ["LEFT"] = true, ["RIGHT"] = true, ["CENTER"] = true,
	}
	function API.IsValidFramePoint(point)
		return validFramePoints[point]
	end
	function API.GetFramePointList()
		local list = {}
		local L = API:GetLocale("BigWigs")
		for k in next, validFramePoints do
			list[k] = L[k]
		end
		return list
	end
end

do
	local pcall = pcall
	local dummy = UIParent:CreateFontString()
	dummy:Hide()
	local IsKnownFile = C_UIFileAsset and C_UIFileAsset.IsKnownFile -- XXX [Mainline:✓ MoP:✗ Wrath:✗ TBC:✗ Vanilla:✗]
	function API.IsValidMediaPath(mediaPath)
		if IsKnownFile then
			local result = IsKnownFile(mediaPath)
			return result
		else
			local result = pcall(dummy.SetFont, dummy, mediaPath, 10)
			return result
		end
	end
end

--------------------------------------------------------------------------------
-- Versions
--

do
	-- Returns the BigWigs version as a number
	function API.GetVersion()
		return addonTbl.version, addonTbl.guildVersion
	end
	-- Returns the BigWigs version hash from Git as a string
	function API.GetVersionHash()
		return addonTbl.versionHash
	end
end

--------------------------------------------------------------------------------
-- Voice
--

do
	local addons = {}
	function API.RegisterVoicePack(pack)
		if type(pack) ~= "string" then error("Voice pack name must be a string.") return end

		if not addons[pack] then
			addons[pack] = true
		else
			error(("Voice pack %s already registered."):format(pack))
		end
	end

	function API.HasVoicePack()
		if next(addons) then
			return true
		end
	end
end

-------------------------------------------------------------------------------
-- Global
--

BigWigsAPI = setmetatable({}, { __index = API, __newindex = function() end, __metatable = false })
