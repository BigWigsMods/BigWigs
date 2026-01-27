local InstanceSharing = {}

-------------------------------------------------------------------------------
-- Libraries
--

local AceGUI = LibStub("AceGUI-3.0")
local acd = LibStub("AceConfigDialog-3.0")
local acr = LibStub("AceConfigRegistry-3.0")

-------------------------------------------------------------------------------
-- Custom Widgets
--

do
	local Type, Version = "BossDropdownGroup", 1
	local function Constructor()
		local dropdownGroup = AceGUI:Create("DropdownGroup")

		local dropdown = dropdownGroup.dropdown.frame
		local titletext = dropdownGroup.titletext
		titletext:SetParent(dropdown)
		titletext:ClearAllPoints()
		titletext:SetPoint("TOPRIGHT", dropdown, "TOPLEFT", -4, -5)
		titletext:SetJustifyH("LEFT")
		titletext:SetHeight(18)

		local dropdownGroupFrame = dropdownGroup.frame
		local exportInstanceBtn = CreateFrame("Button", nil, dropdownGroupFrame, "UIPanelButtonTemplate")
		exportInstanceBtn.parentGroup = dropdownGroup
		exportInstanceBtn:SetPoint("TOPLEFT", 10, -4)
		exportInstanceBtn:SetScript("OnClick", function(self)
			local colorModule = BigWigs:GetPlugin("Colors")
			local soundModule = BigWigs:GetPlugin("Sounds")
			local parent = self.parentGroup
			local modules = parent:GetUserData("moduleList")
			local allBossesDb = {}
			for i, module in ipairs(modules) do
				if module.SetupOptions then module:SetupOptions() end

				-- Flags
				if module.db and module.db.profile then
					allBossesDb[module.name] = CopyTable(allBossesDb[module.name] or {})
					allBossesDb[module.name].flags = module.db.profile
				else
					error(("Module %s does not have a db.profile table."):format(module.name))
				end

				-- Colors
				for colorSettingName, savedModules in pairs(colorModule.db.profile) do
					for colorSettingsModuleName, settings in pairs(savedModules) do
						if colorSettingsModuleName == module.name then
							allBossesDb[module.name].colors = CopyTable(allBossesDb[module.name].colors or {})
							allBossesDb[module.name].colors[colorSettingName] = settings
							break
						end
					end
				end

				-- Sounds
				for soundSettingName, savedSoundModules in pairs(soundModule.db.profile) do
					for soundSettingsModuleName, settings in pairs(savedSoundModules) do
						if soundSettingsModuleName == module.name then
							allBossesDb[module.name].sounds = CopyTable(allBossesDb[module.name].sounds or {})
							allBossesDb[module.name].sounds[soundSettingName] = settings
							break
						end
					end
				end
			end
			local exportInfo = {
				zone = parent:GetUserData("zone"),
				exportTable = allBossesDb,
			}
			InstanceSharing:OpenExportFrame(exportInfo)
		end)
		exportInstanceBtn:SetHeight(20)
		local font = exportInstanceBtn.Text:GetFont()
		exportInstanceBtn.Text:SetFont(font, 12)
		exportInstanceBtn:SetTextToFit("Share")
		exportInstanceBtn:SetNormalFontObject("DialogButtonNormalText")
		exportInstanceBtn:SetHighlightFontObject("DialogButtonHighlightText")
		dropdownGroup.exportInstanceBtn = exportInstanceBtn

		return dropdownGroup
	end
	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

-------------------------------------------------------------------------------
-- Locals
--

local exportFrame = nil
local L = BigWigsAPI:GetLocale("BigWigs")
local instanceExportPrefix = "BWIS1"
local isMidnight = BigWigsLoader.isMidnight

-- String/Data storage
local lastImportData, lastExportData = nil, nil

-- Default checkbox settings
-- local defaultSettings = {
-- 	doFlags = not isMidnight and true or false,
-- 	doSounds = not isMidnight and true or false,
-- 	doColors = not isMidnight and true or false,
-- 	doPrivateAuras = isMidnight and true or false,
-- }

-- to test
local defaultSettings = {
	doFlags = true,
	doSounds = true,
	doColors = true,
	doPrivateAuras = true,
}

local exportSettings = CopyTable(defaultSettings)
local importSettings = CopyTable(defaultSettings)

local applyImport, verifyImportString = nil, nil

-------------------------------------------------------------------------------
-- Options
--

local function getImportSettings(widget)
	return {
		name = "",
		type = "group",
		get = function(i) return importSettings[i[#i]] end,
		set = function(i, value) importSettings[i[#i]] = value end,
		args = {
			importString = {
				type = "input",
				name = "Import String",
				multiline = 3,
				width = "full",
				order = 1,
				set = function(i, value)
					verifyImportString(value)
					importSettings[i[#i]] = value
				end,
				control = "ImportStringMultiline",
			},
			doFlags = {
				type = "toggle",
				name = "Flags",
				desc = "Import settings which control things like 'show bar', 'play sound', 'show message' etc.\nThese cover most checkboxes in an abilities settings.",
				order = 10,
				width = 1,
				-- hidden = isMidnight,
				disabled = function() return not lastImportData or not lastImportData.includeFlags end,
			},
			separator1 = {
				type = "description",
				name = "",
				order = 20,
				width = "full",
			},
			doSounds = {
				type = "toggle",
				name = "Sounds",
				desc = "Import which sounds to play for abilities.",
				order = 30,
				width = 1,
				-- hidden = isMidnight,
				disabled = function() return not lastImportData or not lastImportData.includeSounds end,
			},
			doPrivateAuras = {
				type = "toggle",
				name = "Private Auras",
				desc = "Import the configured Private Auras sounds.",
				order = 31,
				width = 1,
				hidden = not isMidnight,
				disabled = function() return not lastImportData or not lastImportData.includePrivateAuras end,
			},
			separator2 = {
				type = "description",
				name = "",
				order = 40,
				width = "full",
			},
			doColors = {
				type = "toggle",
				name = "Colors",
				desc = "Import the color settings for bars and messages.",
				order = 50,
				width = 1,
				-- hidden = isMidnight,
				disabled = function() return not lastImportData or not lastImportData.includeColors end,
			},
			separator3 = {
				type = "description",
				name = "",
				order = 60,
				width = "full",
			},
			acceptImportButton = {
				type = "execute",
				name = L.import,
				order = 100,
				width = "full",
				func = function()
					local success = applyImport()
					if success then
						BigWigsOptions:Open()
						exportFrame:Hide()
					end
				end,
				disabled = function()
					local isSomethingSelected = false
					for k, v in pairs(importSettings) do
						if k ~= "importString" and v then
							isSomethingSelected = true
							break
						end
					end
					return not isSomethingSelected or not lastImportData
				end,
				confirm = function()
					local zoneName = GetRealZoneText(lastImportData.zone)
					local profileName = BigWigsLoader.db:GetCurrentProfile()
					return L.confirm_instance_import:format(profileName, zoneName)
				end,
			},
		},
	}
end

local function getExportSettings()
	return {
		name = "",
		type = "group",
		get = function(i) return exportSettings[i[#i]] end,
		set = function(i, value) exportSettings[i[#i]] = value end,
		args = {
			exportString = {
				type = "input",
				name = "Export String",
				desc = "The export string for sharing your instance options.",
				multiline = 4,
				width = "full",
				order = 1,
				get = function() return InstanceSharing:GetInstanceExportString() end,
				set = function() end,
				control = "NoAcceptMultiline",
			},
			doFlags = {
				type = "toggle",
				name = "Flags",
				desc = "Export settings which control things like 'show bar', 'play sound', 'show message' etc.\nThese cover most checkboxes in an abilities settings.",
				order = 10,
				width = 1,
				-- hidden = isMidnight,
			},
			separator1 = {
				type = "description",
				name = "",
				order = 20,
				width = "full",
			},
			doSounds = {
				type = "toggle",
				name = "Sounds",
				desc = "Export which sounds to play for abilities.",
				order = 30,
				width = 1,
				-- hidden = isMidnight,
			},
			doPrivateAuras = {
				type = "toggle",
				name = "Private Auras",
				desc = "Export the configured Private Auras sounds.",
				order = 31,
				width = 1,
				-- hidden = not isMidnight,
			},
			separator2 = {
				type = "description",
				name = "",
				order = 40,
				width = "full",
			},
			doColors = {
				type = "toggle",
				name = "Colors",
				desc = "Export the color settings for bars and messages.",
				order = 50,
				width = 1,
				-- hidden = isMidnight,
			},
		},
	}
end

local function onExportTabGroupSelected(widget, callback, tab)
	widget:PauseLayout()
	widget:ReleaseChildren()

	if tab == "import" then
		importSettings.importString = nil
		exportFrame:SetStatusText("Paste a valid import string")

		acr:RegisterOptionsTable("Import Instance Tab", getImportSettings(widget))
		acd:Open("Import Instance Tab", widget)
	else
		local zoneName = GetRealZoneText(lastExportData.zone)
		exportFrame:SetStatusText("Exporting |cFFBB66FF"..zoneName.."|r")

		acr:RegisterOptionsTable("Export Instance Tab", getExportSettings(widget))
		acd:Open("Export Instance Tab", widget)
	end

	widget:ResumeLayout()
	widget:PerformLayout()
end

local function exportPopup(_, exportInfo)
	local frame = exportFrame
	if not frame then
		local f = AceGUI:Create("Frame")

		f:SetTitle("BigWigs Share")
		f:SetLayout("Flow")
		f:SetWidth(400)
		f:SetHeight(380)
		f:EnableResize(false)
		frame = f
	end
	exportFrame = frame

	frame:SetStatusText("Paste a valid import string")

	local tabs = AceGUI:Create("TabGroup")
	tabs:SetLayout("Flow")
	tabs:SetFullWidth(true)
	tabs:SetFullHeight(true)
	tabs:SetTabs({
		{ text = "Import", value = "import" },
		{ text = "Export", value = "export" },
	})
	tabs:SetCallback("OnGroupSelected", onExportTabGroupSelected)
	tabs:SelectTab("import")
	lastExportData = {data = exportInfo.exportTable, zone = exportInfo.zone}

	frame:AddChild(tabs)

	frame:SetCallback("OnClose",function(widget)
		tabs:SelectTab("import")
		BigWigsOptions:Open()
		widget.frame:Hide()
	end)

	frame:Show()
	BigWigsOptions:Close()
end

InstanceSharing.OpenExportFrame = exportPopup

-------------------------------------------------------------------------------
-- Functions
--

function InstanceSharing:CreateExportString(exportTable, prefix)
    local serialized = C_EncodingUtil.SerializeCBOR(exportTable);
    local compressed = C_EncodingUtil.CompressString(serialized, Enum.CompressionMethod.Deflate);
    local encoded = C_EncodingUtil.EncodeBase64(compressed);
    return prefix..":"..encoded;
end

function InstanceSharing:GetInstanceExportString()
	local exportFlags =  exportSettings.doFlags
	local exportSounds = exportSettings.doSounds
	local exportColors = exportSettings.doColors
	local exportPrivateAuras = exportSettings.doPrivateAuras

	-- Get the data and make a string
	local exportTable = lastExportData.data
	local filteredExportTable = {
		includeFlags = exportFlags,
		includeSounds = exportSounds,
		includeColors = exportColors,
		includePrivateAuras = exportPrivateAuras,
		zone = lastExportData.zone,
		exportData = {},
		version = instanceExportPrefix,
	}

	for optionsTable, doExport in pairs({flags = exportFlags, sounds = exportSounds or exportPrivateAuras, colors = exportColors}) do
		if doExport then
			for moduleName, settings in pairs(exportTable) do
				if settings[optionsTable] then
					filteredExportTable.exportData[moduleName] = filteredExportTable.exportData[moduleName] or {}
					filteredExportTable.exportData[moduleName][optionsTable] = CopyTable(settings[optionsTable] or {})
					if optionsTable == "sounds" and not (exportSounds and exportPrivateAuras) then -- Filter away extra sound options if only one is selected
						local count = 0
						for key, value in pairs(filteredExportTable.exportData[moduleName][optionsTable]) do
							local shouldKeep = (key == "privateaura" and exportPrivateAuras) or (key ~= "privateaura" and exportSounds)
							if not shouldKeep then
								filteredExportTable.exportData[moduleName][optionsTable][key] = nil
							else
								count = count + 1
							end
						end
						if count == 0 then
							filteredExportTable.exportData[moduleName][optionsTable] = nil
						end
					end
				end
			end
		end
	end

	local exportString = InstanceSharing:CreateExportString(filteredExportTable, instanceExportPrefix)
	return exportString
end

do
	local function parseImportString(string)
		if type(string) ~= "string" then return end
		local preFix, importData = string:match("^(%w+):(.+)$")
		if preFix ~= instanceExportPrefix then return end
		local decode_success, decodedForPrint = xpcall(C_EncodingUtil.DecodeBase64, function() return end, importData)
		if not decode_success or not decodedForPrint then return end
		local decomp_success, decompressed =  xpcall(C_EncodingUtil.DecompressString, function() return end, decodedForPrint, Enum.CompressionMethod.Deflate)
		if not decomp_success or not decompressed then return end
		local deserialize_success, data = xpcall(C_EncodingUtil.DeserializeCBOR, function() return end, decompressed)
		if not deserialize_success or not data then return end
		lastImportData = data
		return true
	end


	function verifyImportString(value)
		lastImportData = nil
		local hasImports = parseImportString(value)
		if hasImports then
			local zoneName = GetRealZoneText(lastImportData.zone)
			exportFrame:SetStatusText("Importing |cFFBB66FF"..zoneName.."|r")
		else
			exportFrame:SetStatusText("Paste a valid import string")
		end
	end
end

local function ImportSounds(soundSettings, privateAuras)
	local soundModule = BigWigs:GetPlugin("Sounds", true)
	if not soundModule then return end

	for soundSettingName, savedModules in pairs(soundModule.db.profile) do
		if soundSettingName ~= "privateaura" or privateAuras then -- only import private auras if the user allowed it
			if soundSettings[soundSettingName] then
				soundModule.db.profile[soundSettingName][moduleName] = CopyTable(soundSettings[soundSettingName])
			else
				soundModule.db.profile[soundSettingName][moduleName] = nil
			end
		end
	end
end

local function ImportPrivateAuras(privateAuraSettings)
	local soundModule = BigWigs:GetPlugin("Sounds", true)
	if not soundModule then return end

end

local function ImportFlags(flagSettings)
	local module = BigWigs:GetBossModule(moduleName:sub(16))
	if module then
		if module.SetupOptions then module:SetupOptions() end
		if module.db and module.db.profile then
			for key, value in pairs(module.db.profile) do
				if flagSettings[key] then
					module.db.profile[key] = CopyTable(flagSettings[key])
				end
			end
		end
	end
end

local function ImportColors(colorSettings)
	local colorModule = BigWigs:GetPlugin("Colors", true)
	if not colorModule then return end

	for colorSettingName, savedModules in pairs(colorModule.db.profile) do
		if colorSettings[colorSettingName] then
			colorModule.db.profile[colorSettingName][moduleName] = CopyTable(colorSettings[colorSettingName])
		else
			colorModule.db.profile[colorSettingName][moduleName] = nil
		end
	end
end

function applyImport()
	local flags = importSettings.doFlags
	local sounds = importSettings.doSounds
	local colors = importSettings.doColors
	local privateAuras = importSettings.doPrivateAuras

	if not (flags or sounds or colors or privateAuras) then
		return -- Nothing to import
	end

	-- Prepare modules and plugins to import to
	BigWigsLoader:LoadZone(lastImportData.zone)

	for moduleName, data in pairs(lastImportData.exportData) do
		if flags and data.flags then
			ImportFlags(data.flags)
		end
		if sounds and data.sounds then
			ImportSounds(data.sounds)
		end
		if privateAuras and data.sounds then
			ImportPrivateAuras(data.sounds)
		end
		if colors and data.colors then
			ImportColors(data.colors)
		end
	end

	-- success!
	return true
end

