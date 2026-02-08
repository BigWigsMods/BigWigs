local InstanceSharing = {}

local function CopyTable(tbl)
	local copy = {}
	for key, value in next, tbl do
		if type(value) == "table" then
			copy[key] = CopyTable(value)
		else
			copy[key] = value
		end
	end
	return copy
end

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
			InstanceSharing:OpenExportFrame(exportInfo, dropdownGroup)
		end)
		exportInstanceBtn:SetHeight(20)
		local font = exportInstanceBtn.Text:GetFont()
		exportInstanceBtn.Text:SetFont(font, 12)
		exportInstanceBtn:SetTextToFit(BigWigsAPI:GetLocale("BigWigs").share)
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
local isRetail = BigWigsLoader.isRetail

-- String/Data storage
local lastImportData, lastExportData = nil, nil

-- Default checkbox settings
local defaultSettings = {
	doFlags = not isRetail and true or false,
	doSounds = not isRetail and true or false,
	doColors = not isRetail and true or false,
	doPrivateAuras = isRetail and true or false,
}

local exportSettings = CopyTable(defaultSettings)
local importSettings = CopyTable(defaultSettings)

local applyImport, verifyImportString, GetSelectedInstanceName = nil, nil, nil

local bossWidget = nil

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
				name = L.import_string,
				desc = L.import_string_desc,
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
				name = L.sharing_flags,
				desc = L.sharing_flags_desc,
				order = 10,
				width = 1,
				disabled = function() return isRetail or not lastImportData or not lastImportData.includeFlags end,
			},
			separator1 = {
				type = "description",
				name = "",
				order = 20,
				width = "full",
			},
			doSounds = {
				type = "toggle",
				name = L.Sounds,
				desc = L.sharing_sounds_desc,
				order = 30,
				width = 1,
				disabled = function() return isRetail or not lastImportData or not lastImportData.includeSounds end,
			},
			doPrivateAuras = {
				type = "toggle",
				name = L.sharing_private_auras,
				desc = L.sharing_private_auras_desc,
				order = 31,
				width = 1,
				hidden = not isRetail,
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
				name = L.colors,
				desc = L.sharing_colors_desc,
				order = 50,
				width = 1,
				disabled = function() return isRetail or not lastImportData or not lastImportData.includeColors end,
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
						if bossWidget then
							bossWidget:SetGroup(bossWidget.localstatus.selected) -- refreshes the displayed settings
						end
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
					local zoneName = GetSelectedInstanceName(lastImportData.zone)
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
				name = L.export_string,
				desc = L.export_string_desc,
				multiline = 4,
				width = "full",
				order = 1,
				get = function() return InstanceSharing:GetInstanceExportString() end,
				set = function() end,
				control = "NoAcceptMultiline",
			},
			doFlags = {
				type = "toggle",
				name = L.sharing_flags,
				desc = L.sharing_export_flags_desc,
				order = 10,
				width = 1,
				disabled = function() return isRetail end,
			},
			separator1 = {
				type = "description",
				name = "",
				order = 20,
				width = "full",
			},
			doSounds = {
				type = "toggle",
				name = L.Sounds,
				desc = L.sharing_export_sounds_desc,
				order = 30,
				width = 1,
				disabled = function() return isRetail end,
			},
			doPrivateAuras = {
				type = "toggle",
				name = L.sharing_private_auras,
				desc = L.sharing_export_private_auras_desc,
				order = 31,
				width = 1,
				hidden = not isRetail,
			},
			separator2 = {
				type = "description",
				name = "",
				order = 40,
				width = "full",
			},
			doColors = {
				type = "toggle",
				name = L.colors,
				desc = L.sharing_export_colors_desc,
				order = 50,
				width = 1,
				disabled = function() return isRetail end,
			},
		},
	}
end

local function onExportTabGroupSelected(widget, callback, tab)
	widget:PauseLayout()
	widget:ReleaseChildren()

	if tab == "import" then
		importSettings.importString = nil
		exportFrame:SetStatusText(L.status_text_paste_import)

		acr:RegisterOptionsTable("Import Instance Tab", getImportSettings(widget))
		acd:Open("Import Instance Tab", widget)
	else
		local zoneName = GetSelectedInstanceName(lastExportData.zone)
		exportFrame:SetStatusText(L.exporting_instance:format(zoneName))

		acr:RegisterOptionsTable("Export Instance Tab", getExportSettings(widget))
		acd:Open("Export Instance Tab", widget)
	end

	widget:ResumeLayout()
	widget:PerformLayout()
end

local function CloseExportFrame(widget)
	if widget then
		widget:ReleaseChildren()
		AceGUI:Release(widget)
		exportFrame = nil
	end
end

local function exportPopup(_, exportInfo, dropdownGroup)
	local frame = exportFrame
	bossWidget = dropdownGroup

	if not frame then
		local f = AceGUI:Create("Frame")

		f:SetTitle(L.sharing_window_title)
		f:SetLayout("Flow")
		f:SetWidth(400)
		f:SetHeight(380)
		f:EnableResize(false)
		frame = f
	end
	exportFrame = frame

	frame:SetStatusText(L.status_text_paste_import)

	local tabs = AceGUI:Create("TabGroup")
	tabs:SetLayout("Flow")
	tabs:SetFullWidth(true)
	tabs:SetFullHeight(true)
	tabs:SetTabs({
		{ text = L.import, value = "import" },
		{ text = L.export, value = "export" },
	})
	tabs:SetCallback("OnGroupSelected", onExportTabGroupSelected)
	tabs:SelectTab("import")
	lastExportData = {data = exportInfo.exportTable, zone = exportInfo.zone}

	frame:AddChild(tabs)

	frame:SetCallback("OnClose",function(self)
		CloseExportFrame(exportFrame)
	end)
	BigWigsLoader.RegisterMessage(InstanceSharing, "BigWigs_CloseGUI", function()
		CloseExportFrame(exportFrame)
	 end)


	frame:Show()
end

InstanceSharing.OpenExportFrame = exportPopup

-------------------------------------------------------------------------------
-- Functions
--

local GetMapInfo = C_Map.GetMapInfo
function GetSelectedInstanceName(zoneId)
	if zoneId < 0 then
		local tbl = GetMapInfo(-zoneId)
		if tbl then
			return tbl.name
		end
	else
		return GetRealZoneText(zoneId)
	end
end

function InstanceSharing:CreateExportString(exportTable, prefix)
	local serialized = C_EncodingUtil.SerializeCBOR(exportTable)
	local compressed = C_EncodingUtil.CompressString(serialized, 0) -- Enum.CompressionMethod.Deflate = 0
	local encoded = C_EncodingUtil.EncodeBase64(compressed)
	return prefix..":"..encoded
end

function InstanceSharing:GetInstanceExportString()
	local exportFlags = exportSettings.doFlags
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
	local parseImportString
	do
		local function dummy() end
		function parseImportString(string)
			if type(string) ~= "string" then return end
			local preFix, importData = string:match("^(%w+):(.+)$")
			if preFix ~= instanceExportPrefix then return end
			local decode_success, decodedForPrint = xpcall(C_EncodingUtil.DecodeBase64, dummy, importData)
			if not decode_success or not decodedForPrint then return end
			local decomp_success, decompressed = xpcall(C_EncodingUtil.DecompressString, dummy, decodedForPrint, 0) -- Enum.CompressionMethod.Deflate = 0
			if not decomp_success or not decompressed then return end
			local deserialize_success, data = xpcall(C_EncodingUtil.DeserializeCBOR, dummy, decompressed)
			if not deserialize_success or not data then return end
			if data.version ~= instanceExportPrefix then return end -- encoded version does not match expected version
			lastImportData = data
			return true
		end
	end

	function verifyImportString(value)
		lastImportData = nil
		local hasImports = parseImportString(value)
		local zoneName = hasImports and BigWigsLoader.zoneTbl[lastImportData.zone] and GetSelectedInstanceName(lastImportData.zone)
		if zoneName and zoneName ~= "" then
			exportFrame:SetStatusText(L.importing_instance:format(zoneName))
		else
			lastImportData = nil -- reset the import due to invalid zone
			exportFrame:SetStatusText(L.status_text_paste_import)
		end
	end
end

local function ImportSounds(soundSettings, moduleName)
	local soundModule = BigWigs:GetPlugin("Sounds", true)
	if not soundModule then return end

	local sDB = soundModule.db.profile
	for soundSettingName, _ in pairs(sDB) do
		if soundSettingName ~= "privateaura" then -- private auras are handled separately inside ImportPrivateAuras
			if soundSettings and soundSettings[soundSettingName] then
				sDB[soundSettingName][moduleName] = CopyTable(soundSettings[soundSettingName])
			else -- wipe to set default
				sDB[soundSettingName][moduleName] = nil
			end
		end
	end
end

local function ImportPrivateAuras(privateAuraSettings, moduleName)
	local soundModule = BigWigs:GetPlugin("Sounds", true)
	if not soundModule or not privateAuraSettings then return end

	local sDB = soundModule.db.profile["privateaura"]
	sDB[moduleName] = CopyTable(privateAuraSettings)
end

local function ImportFlags(flagSettings, moduleName)
	local module = BigWigs:GetBossModule(moduleName:sub(16))
	if module then
		if module.SetupOptions then module:SetupOptions() end
		if module.db and module.db.profile then
			for key, value in pairs(module.db.profile) do
				if flagSettings and flagSettings[key] then
					module.db.profile[key] = flagSettings[key]
				else -- wipe to set default
					module.db.profile[key] = nil
				end
			end
		end
	end
end

local function ImportColors(colorSettings, moduleName)
	local colorModule = BigWigs:GetPlugin("Colors", true)
	if not colorModule then return end

	local cDB = colorModule.db.profile
	for colorSettingName in next, cDB do
		for k in next, cDB[colorSettingName][moduleName] do
			if colorSettings and colorSettings[colorSettingName] and colorSettings[colorSettingName][k] then
				cDB[colorSettingName][moduleName][k] = CopyTable(colorSettings[colorSettingName][k])
			else -- wipe to set default
				cDB[colorSettingName][moduleName][k] = nil
			end
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
		if flags then
			ImportFlags(data.flags, moduleName)
		end
		if sounds then
			ImportSounds(data.sounds, moduleName)
		end
		if privateAuras then
			local privateAuraSounds = data.sounds and data.sounds.privateaura
			ImportPrivateAuras(privateAuraSounds, moduleName)
		end
		if colors then
			ImportColors(data.colors, moduleName)
		end
	end

	BigWigs:SendMessage("BigWigs_ProfileUpdate")
	-- success!
	return true
end

