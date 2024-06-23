local _, addonTable = ...
local sharing = {}

-------------------------------------------------------------------------------
-- Libraries
--

local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")
local AceGUI = LibStub("AceGUI-3.0")

-------------------------------------------------------------------------------
-- Custom Widgets
--

do
	local Type, Version = "NoAcceptMultiline", 1
	local function Constructor()
		local multiLineEditBox = AceGUI:Create("MultiLineEditBox")
		multiLineEditBox.type = Type
		multiLineEditBox.button:Hide()
		multiLineEditBox.button.Show = function() end -- Prevent the button from being shown again
		return multiLineEditBox
	end
	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

do
	local function OnTextChanged(self, userInput)
		if userInput then
			self = self.obj
			self:Fire("OnEnterPressed", self.editBox:GetText())
		end
	end

	local Type, Version = "ImportStringMultiline", 1
	local function Constructor()
		local multiLineEditBox = AceGUI:Create("MultiLineEditBox")
		multiLineEditBox.type = Type
		multiLineEditBox.editBox:SetScript("OnTextChanged", OnTextChanged)
		multiLineEditBox.button:Hide()
		multiLineEditBox.button.Show = function() end -- Prevent the button from being shown again
		return multiLineEditBox
	end
	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

-------------------------------------------------------------------------------
-- Locals
--

local L = BigWigsAPI:GetLocale("BigWigs")
local myLocale = GetLocale()
local sharingVersion = "BW1"

-- Position Args
local barPositionsToExport = {
	"normalPosition",
	"expPosition",
}

local messagePositionsToExport = {
	"normalPosition",
	"emphPosition",
}

-- Settings Args
local barSettingsToExport = {
	"fontName",
	"fontSize",
	"fontSizeEmph",
	"fontSizeNameplate",
	"texture",
	"monochrome",
	"outline",
	"growup",
	"text",
	"time",
	"alignText",
	"alignTime",
	"icon",
	"iconPosition",
	"fill",
	"barStyle",
	"emphasize",
	"emphasizeMove",
	"emphasizeGrowup",
	"emphasizeRestart",
	"emphasizeTime",
	"emphasizeMultiplier",
	"normalWidth",
	"normalHeight",
	"expWidth",
	"expHeight",
	"spacing",
	"visibleBarLimit",
	"visibleBarLimitEmph",
	-- "nameplateWidth", -- Do nameplate bars need their own export checkbox?
	-- "nameplateAutoWidth",
	-- "nameplateHeight",
	-- "nameplateAlpha",
	-- "nameplateOffsetY",
	-- "nameplateGrowUp",
	-- XXX Clickable Bars are not exported right now. Separate checkbox?
	-- "interceptMouse",
	-- "onlyInterceptOnKeypress",
	-- "interceptKey",
	-- "LeftButton",
	-- "MiddleButton",
	-- "RightButton",
}

local messageSettingsToExport = {
	"fontName",
	"emphFontName",
	"monochrome",
	"emphMonochrome",
	"outline",
	"emphOutline",
	"align",
	"fontSize",
	"emphFontSize",
	"chat",
	"useicons",
	"classcolor",
	"growUpwards",
	"displaytime",
	"fadetime",
	"emphUppercase",
	-- "disabled",
	-- "emphDisabled",
}

-- Color Args
local barColorsToExport = {
	"barBackground",
	"barText",
	"barTextShadow",
	"barColor",
	"barEmphasized",
}

local messageColorsToExport = {
	"red",
	"blue",
	"orange",
	"yellow",
	"green",
	"cyan",
	"purple",
}

-- Default Options
local sharingExportOptionsSettings = {
	exportBarPositions = true,
	exportMessagePositions = true,
	exportBarSettings = true,
	exportMessageSettings = true,
	exportBarColors = true,
	exportMessageColors = true,
}

local sharingImportOptionsSettings = {}

-- Import String Storage
local importStringOptions = {}
local importedTableData = nil

-------------------------------------------------------------------------------
-- Functions
--

local function exportProfileColorSettings(argsToExport)
	local export = {}
	local colorSettings = BigWigs:GetPlugin("Colors")
	for i = 1, #argsToExport do
		export[argsToExport[i]] = colorSettings.db.profile[argsToExport[i]]["BigWigs_Plugins_Colors"]["default"]
	end
	return export
end

local function exportProfileSettings(argsToExport, pluginProfile)
	local export = {}
	for i = 1, #argsToExport do
		export[argsToExport[i]] = pluginProfile[argsToExport[i]]
	end
	return export
end

local function GetExportString()
	local exportOptions = {
		version = sharingVersion, -- :GetVersionString() contains more info than I prefer, using our own version within the plugin.
	}

	local barSettings = BigWigs:GetPlugin("Bars")
	local messageSettings = BigWigs:GetPlugin("Messages")

	if sharingExportOptionsSettings.exportBarPositions then
		exportOptions["barPositions"] = exportProfileSettings(barPositionsToExport, barSettings.db.profile)
	end

	if sharingExportOptionsSettings.exportMessagePositions then
		exportOptions["messagePositions"] = exportProfileSettings(messagePositionsToExport, messageSettings.db.profile)
	end

	if sharingExportOptionsSettings.exportBarSettings then
		exportOptions["barSettings"] = exportProfileSettings(barSettingsToExport, barSettings.db.profile)
	end

	if sharingExportOptionsSettings.exportMessageSettings then
		exportOptions["messageSettings"] = exportProfileSettings(messageSettingsToExport, messageSettings.db.profile)
	end

	if sharingExportOptionsSettings.exportMessageColors then
		exportOptions["messageColors"] = exportProfileColorSettings(messageColorsToExport)
	end

	if sharingExportOptionsSettings.exportBarColors then
		exportOptions["barColors"] = exportProfileColorSettings(barColorsToExport)
	end

	local serialized = LibSerialize:Serialize(exportOptions)
	local compressed = LibDeflate:CompressDeflate(serialized)
	local compressedForPrint = LibDeflate:EncodeForPrint(compressed)
	return sharingVersion..":"..compressedForPrint
end

local function isImportStringAvailable()
	return not not importedTableData
end

local function IsOptionInString(key)
	if importStringOptions[key] then
		return true
	end
	return false
end

local function IsOptionGroupAvailable(group)
	if group == "bars" then
		if IsOptionInString("barPositions") or IsOptionInString("barSettings") or IsOptionInString("barColors") then
			return true
		end
	end
	if group == "messages" then
		if IsOptionInString("messagePositions") or IsOptionInString("messageSettings") or IsOptionInString("messageColors") then
			return true
		end
	end
	if group == "any" then
		if IsOptionGroupAvailable("bars") or IsOptionGroupAvailable("messages") then
			return true
		end
	end
	return false
end

do

	local function PreProcess(data)
		importedTableData = data
		for k, v in pairs(data) do
			importStringOptions[k] = true
		end
		return true
	end

	--- Decodes and stores an import string
	-- When an import string is passed to this function, it will decode the string
	-- and store the data in the importStringOptions table.
	-- Afterwards you can call :SaveData to save the data to the BigWigs profile.
	-- @param string The import string to decode.
	-- @return True if the import string was successfully decoded
	function sharing:DecodeImportString(string)
		if type(string) ~= "string" then return end
		importStringOptions = {}
		importedTableData = nil

		local versionPlain, importData = string:match("^(%w+):(.+)$")
		if versionPlain ~= sharingVersion then return end
		local decodedForPrint = LibDeflate:DecodeForPrint(importData)
		if not decodedForPrint then return end
		local decompressed = LibDeflate:DecompressDeflate(decodedForPrint)
		if not decompressed then return end
		local success, data = LibSerialize:Deserialize(decompressed)
		if not success or not data.version or data.version ~= sharingVersion then return end
		local importSucceeded = PreProcess(data)
		return importSucceeded
	end
end


do
	local comma = (myLocale == "zhTW" or myLocale == "zhCN") and "，" or ", "
	local function SaveImportedTable(tableData)
		local data = tableData
		local imported = {}
		local barPlugin = BigWigs:GetPlugin("Bars")
		local messageplugin = BigWigs:GetPlugin("Messages")
		local colorplugin = BigWigs:GetPlugin("Colors")

		-- Colors are stored for each plugin/module (e.g. BigWigs_Plugins_Colors for the defaults, BigWigs_Bosses_* for bosses)
		-- We only want to modify the defaults with these imports right now.
		local function importColorSettings(sharingOptionKey, dataKey, settingsToExport, plugin, message)
			if sharingImportOptionsSettings[sharingOptionKey] and data[dataKey] then
				for k in next, plugin.db.profile do
					plugin.db.profile[k]["BigWigs_Plugins_Colors"]["default"] = nil -- Reset defaults only
				end
				for k, v in pairs(data[dataKey]) do
					plugin.db.profile[k]["BigWigs_Plugins_Colors"]["default"] = v
				end
				table.insert(imported, message)
			end
		end

		local function importSettings(sharingOptionKey, dataKey, settingsToExport, plugin, message)
			if sharingImportOptionsSettings[sharingOptionKey] and data[dataKey] then
				local profile = plugin.db.profile
				for i = 1, #settingsToExport do
					profile[settingsToExport[i]] = nil -- Reset current settings
				end
				for k, v in pairs(data[dataKey]) do
					plugin.db.profile[k] = v
				end
				table.insert(imported, message)
			end
		end

		importSettings('importBarPositions', 'barPositions', barPositionsToExport, barPlugin, L.imported_bar_positions)
		importSettings('importBarSettings', 'barSettings', barSettingsToExport, barPlugin, L.imported_bar_settings)
		importColorSettings('importBarColors', 'barColors', barColorsToExport, colorplugin, L.imported_bar_colors)
		importSettings('importMessagePositions', 'messagePositions', messagePositionsToExport, messageplugin, L.imported_message_positions)
		importSettings('importMessageSettings', 'messageSettings', messageSettingsToExport, messageplugin, L.imported_message_settings)
		importColorSettings('importMessageColors', 'messageColors', messageColorsToExport, colorplugin, L.imported_message_colors)

		if #imported == 0 then
			BigWigs:Print(L.no_import_message)
			return
		end

		BigWigs:SendMessage("BigWigs_ProfileUpdate")
		local importMessage = L.import_success:format(table.concat(imported, comma))
		BigWigs:Print(importMessage)
	end

	--- Saves the currently loaded import string to the BigWigs profile.
	-- After importing a string with :DecodeImportString, this function
	-- will save the data to the BigWigs profile.
	function sharing:SaveData()
		if not importedTableData then
			BigWigs:Print(L.no_string_available)
			return
		end
		-- Custom Popup to confirm import?
		SaveImportedTable(importedTableData)
	end
end

--------------------------------------------------------------------------------
-- Options
--

local sharingOptions = {
	importSection = {
		type="group",
		name = L.import,
		order = 5,
		get = function(i) return sharingImportOptionsSettings[i[#i]] end,
		set = function(i, value) sharingImportOptionsSettings[i[#i]] = value end,
		args = {
			importStringInfo = {
				type = "description",
				name = L.import_info,
				order = 1,
				width = "full",
			},
			importString = {
				type = "input",
				multiline = 5,
				name = L.import_string,
				desc = L.import_string_desc,
				order = 2,
				width = "full",
				set = function(i, value)
					local processed = sharing:DecodeImportString(value)
					sharingImportOptionsSettings[i[#i]] = value
				end,
				get = function(i) return sharingImportOptionsSettings[i[#i]] end,
				control = "ImportStringMultiline",
			},
			importInfo = {
				type = "description",
				name = function() return IsOptionGroupAvailable("any") and L.import_info_active or L.import_info_none end,
				order = 4.5,
				hidden = function() return not isImportStringAvailable() and not sharingImportOptionsSettings["importString"] end,
				width = "full",
			},
			bars = {
				type = "group",
				name = L.BAR,
				inline = true,
				order = 5,
				hidden = function() return (not isImportStringAvailable() or not IsOptionGroupAvailable("bars")) end,
				args = {
					importBarPositions = {
						type = "toggle",
						name = L.position,
						desc = L.position_import_bars_desc,
						order = 1,
						width = 1,
						disabled = function() return not IsOptionInString("barPositions") end,
					},
					importBarSettings = {
						type = "toggle",
						name = L.settings,
						desc = L.settings_import_bars_desc,
						order = 5,
						width = 1,
						disabled = function() return not IsOptionInString("barSettings") end,
					},
					importBarColors = {
						type = "toggle",
						name = L.colors,
						desc = L.colors_import_bars_desc,
						order = 10,
						width = 1,
						disabled = function() return not IsOptionInString("barColors") end,
					},
				},
			},
			messages = {
				type = "group",
				name = L.MESSAGE,
				inline = true,
				order = 10,
				hidden = function() return (not isImportStringAvailable() or not IsOptionGroupAvailable("messages")) end,
				args = {
					importMessagePositions = {
						type = "toggle",
						name = L.position,
						desc = L.position_import_messages_desc,
						order = 1,
						width = 1,
						disabled = function() return not IsOptionInString("messagePositions") end,
					},
					importMessageSettings = {
						type = "toggle",
						name =	L.settings,
						desc = L.settings_import_messages_desc,
						order = 5,
						width = 1,
						disabled = function() return not IsOptionInString("messageSettings") end,
					},
					importMessageColors = {
						type = "toggle",
						name = L.colors,
						desc = L.colors_import_messages_desc,
						order = 10,
						width = 1,
						disabled = function() return not IsOptionInString("messageColors") end,
					},
				},
			},
			acceptImportButton = {
				type = "execute",
				name = L.import,
				order = 100,
				width = "full",
				func = function()
					sharing:SaveData()
				end,
				hidden = function()
					return (not isImportStringAvailable() and not IsOptionGroupAvailable("any"))
				end,
				disabled = function()
					local isSomethingSelected = false
					for k, v in pairs(sharingImportOptionsSettings) do
						if k ~= "importString" and v then
							isSomethingSelected = true
							break
						end
					end
					return not isSomethingSelected
				end,
				confirm = true,
				confirmText = L.confirm_import,
			},
		},
	},
	exportSection = {
		type="group",
		name = L.export,
		order = 10,
		get = function(i) return sharingExportOptionsSettings[i[#i]] end,
		set = function(i, value) sharingExportOptionsSettings[i[#i]] = value end,
		args = {
			exportInfo = {
				type = "description",
				name = L.export_info,
				order = 1,
				width = "full",
			},
			bars = {
				type = "group",
				name = L.BAR,
				inline = true,
				order = 2,
				args = {
					exportBarPositions = {
						type = "toggle",
						name = L.position,
						desc = L.position_export_bars_desc,
						order = 1,
						width = 1,
					},
					exportBarSettings = {
						type = "toggle",
						name = L.settings,
						desc = L.settings_export_bars_desc,
						order = 5,
						width = 1,
					},
					exportBarColors = {
						type = "toggle",
						name = L.colors,
						desc = L.colors_export_bars_desc,
						order = 10,
						width = 1,
					},
				},
			},
			messages = {
				type = "group",
				name = L.MESSAGE,
				inline = true,
				order = 10,
				args = {
					exportMessagePositions = {
						type = "toggle",
						name = L.position,
						desc = L.position_export_messages_desc,
						order = 1,
						width = 1,
					},
					exportMessageSettings = {
						type = "toggle",
						name = L.settings,
						desc = L.settings_export_messages_desc,
						order = 5,
						width = 1,
					},
					exportMessageColors = {
						type = "toggle",
						name = L.colors,
						desc = L.colors_export_messages_desc,
						order = 10,
						width = 1,
					},
				},

			},
			exportString = {
				type = "input",
				multiline = 5,
				name = L.export_string,
				desc = L.export_string_desc,
				order = 100,
				width = "full",
				get = function()
					return GetExportString()
				end,
				set = function() end,
				control = "NoAcceptMultiline",
			},
		},
	},
}

addonTable.sharingOptions = sharingOptions
