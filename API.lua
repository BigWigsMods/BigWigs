local addonTbl
do
	local _
	_, addonTbl = ...
end
local API = {}
addonTbl.API = API
local type, next, error = type, next, error

--------------------------------------------------------------------------------
-- Addons creating bars
--

-- Allows addons to show a bar to the user
function API.CreateBarFromAddon(addonName, text, icon, barTime)
	if type(addonName) ~= "string" or #addonName < 3 then error("Invalid addon name for bar creation.") end
	if type(text) ~= "string" or #text < 3 then error("Invalid text for bar creation.") end
	local iconType = type(icon)
	if iconType ~= "string" and iconType ~= "number" then error("Invalid icon for bar creation.") end
	if type(barTime) ~= "number" then error("Invalid bar time for bar creation.") end
	local L = API:GetLocale("BigWigs")
	addonTbl.loaderPublic.Print(L.showAddonBar:format(addonName, text))
	addonTbl.LoadAndEnableCore()
	addonTbl.loaderPublic:SendMessage("BigWigs_StartBar", nil, nil, text, barTime, icon)
	addonTbl.loaderPublic:SendMessage("BigWigs_Timer", nil, nil, barTime, barTime, text, 0, icon, false, true)
end

--------------------------------------------------------------------------------
-- Addons creating messages
--

-- Allows addons to show a message to the user
function API.CreateMessageFromAddon(addonName, text, icon)
	if type(addonName) ~= "string" or #addonName < 3 then error("Invalid addon name for message creation.") end
	if type(text) ~= "string" or #text < 3 then error("Invalid text for message creation.") end
	local iconType = type(icon)
	if iconType ~= "string" and iconType ~= "number" then error("Invalid icon for message creation.") end
	addonTbl.LoadAndEnableCore()
	addonTbl.loaderPublic:SendMessage("BigWigs_Message", nil, nil, text, "yellow", icon)
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

--------------------------------------------------------------------------------
-- Profile imports
--

do
	-- A custom profile name and callback function is completely optional
	-- When specified, a callback function will be called with a boolean as the first arg. True if the user accepted, false otherwise
	local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
	function API.RegisterProfile(addonName, profileString, optionalCustomProfileName, optionalCallbackFunction)
		if optionalCustomProfileName == "QuaziiUI" or IsAddOnLoaded("QuaziiUI") then error("This profile is blocked from being imported until it stops tampering with BigWigs bitflag options.") end
		if type(addonName) ~= "string" or #addonName < 3 then error("Invalid addon name for profile import.") end
		if type(profileString) ~= "string" or #profileString < 3 then error("Invalid profile string for profile import.") end
		if optionalCustomProfileName and (type(optionalCustomProfileName) ~= "string" or #optionalCustomProfileName < 3) then error("Invalid custom profile name for the string you want to import.") end
		if optionalCallbackFunction and type(optionalCallbackFunction) ~= "function" then error("Invalid custom callback function for the string you want to import.") end
		addonTbl.LoadCoreAndOptions()
		BigWigsOptions:SaveImportStringDataFromAddOn(addonName, profileString, optionalCustomProfileName, optionalCallbackFunction)
	end
end

--------------------------------------------------------------------------------
-- Slash commands
--

do
	local slashTable = {}
	local sub = string.sub
	-- Registers a slash command
	function API.RegisterSlashCommand(rawSlashName, slashFunc)
		local slashName = sub(rawSlashName, 2)
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
		slashTable[slashName] = slashFunc
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
-- Tools option tables
--

do
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
	local tbl = {}
	-- Get all AceGUI option tables under the "Tools" category
	function API.GetToolOptionTables()
		return CopyTable(tbl)
	end
	-- Register an AceGUI options table for a module under the "Tools" category
	function API.SetToolOptionsTable(key, settingsTable)
		if type(key) ~= "string" then error("The key needs to be a string.") end
		if type(settingsTable) ~= "table" then error("The settings table needs to be a table.") end
		tbl[key] = settingsTable
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
