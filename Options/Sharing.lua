local _, addonTable = ...
local sharing = {}

-------------------------------------------------------------------------------
-- Libraries
--

local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")
local AceGUI = LibStub("AceGUI-3.0")

-------------------------------------------------------------------------------
-- Custom Widget
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


-------------------------------------------------------------------------------
-- Locals
--

local L = BigWigsAPI:GetLocale("BigWigs")
local sharingVersion = "BW1"

-- Anchor Args
local barAnchorsToExport = {
	"BigWigsAnchor_x",
	"BigWigsAnchor_y",
	"BigWigsEmphasizeAnchor_x",
	"BigWigsEmphasizeAnchor_y",
}

local messageAnchorsToExport = {
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
	"font",
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
	"BigWigsAnchor_width",
	"BigWigsAnchor_height",
	"BigWigsEmphasizeAnchor_width",
	"BigWigsEmphasizeAnchor_height",
	"nameplateWidth", -- Do nameplate bars need their own export checkbox?
	"nameplateAutoWidth",
	"nameplateHeight",
	"nameplateAlpha",
	"nameplateOffsetY",
	"nameplateGrowUp",
	"spacing",
	"visibleBarLimit",
	"visibleBarLimitEmph",
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
	"disabled",
	"emphDisabled",
	-- Anchor Settings
	-- "normalPosition",
	-- "emphPosition",
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
local sharingOptions = {
	exportBarAnchors = true,
	exportMessageAnchors = true,
	exportBarSettings = true,
	exportMessageSettings = true,
	exportBarColors = true,
	exportMessageColors = true,
}

-- Import String Storage
local importStringOptions = {}
local importedTableData = nil

-------------------------------------------------------------------------------
-- Functions
--

local function exportProfileSettings(args, pluginProfile)
	local export = {}
	for i, v in ipairs(args) do
		export[v] = pluginProfile[v]
	end
	return export
end

local function GetExportString()
	local exportOptions = {
		version = sharingVersion, -- :GetVersionString() contains more info than I prefer, using our own version within the plugin.
	}

	local barSettings = BigWigs:GetPlugin("Bars")
	local messageSettings = BigWigs:GetPlugin("Messages")
	local colorSettings = BigWigs:GetPlugin("Colors")

	if sharingOptions.exportBarAnchors then
		exportOptions["barAnchors"] = exportProfileSettings(barAnchorsToExport, barSettings.db.profile)
	end

	if sharingOptions.exportMessageAnchors then
		exportOptions["messageAnchors"] = exportProfileSettings(messageAnchorsToExport, messageSettings.db.profile)
	end

	if sharingOptions.exportBarSettings then
		exportOptions["barSettings"] = exportProfileSettings(barSettingsToExport, barSettings.db.profile)
	end

	if sharingOptions.exportMessageSettings then
		exportOptions["messageSettings"] = exportProfileSettings(messageSettingsToExport, messageSettings.db.profile)
	end

	if sharingOptions.exportMessageColors then
		exportOptions["messageColors"] = exportProfileSettings(messageColorsToExport, colorSettings.db.profile)
	end

	if sharingOptions.exportBarColors then
		exportOptions["barColors"] = exportProfileSettings(barColorsToExport, colorSettings.db.profile)
	end

	local serialized = LibSerialize:Serialize(exportOptions)
	local compressed = LibDeflate:CompressDeflate(serialized)
	local compressedForPrint = LibDeflate:EncodeForPrint(compressed)
	return sharingVersion..":"..compressedForPrint
end

local function IsOptionInString(key)
	if importStringOptions[key] then
		return true
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

		local version, importData = string:match("^(%w+):(.+)$")
		if version ~= sharingVersion then return end
		local decodedForPrint = LibDeflate:DecodeForPrint(importData)
		if not decodedForPrint then return end
		local decompressed = LibDeflate:DecompressDeflate(decodedForPrint)
		if not decompressed then return end
		local success, data = LibSerialize:Deserialize(decompressed)
		if not success then return end
		local importSucceeded = PreProcess(data)
		return importSucceeded
	end
end


do
	local function SaveImportedTable(tableData)
		local data = tableData
		local imported = {}
		local barPlugin = BigWigs:GetPlugin("Bars")
		local messageplugin = BigWigs:GetPlugin("Messages")
		local colorplugin = BigWigs:GetPlugin("Colors")

		local function resetCurrentSettings(plugin, args)
			local profile = plugin.db.profile
			for i, v in ipairs(args) do
				profile[v] = nil
			end
		end

		local function importSettings(sharingOptionKey, dataKey, settingsToExport, plugin, message)
			if sharingOptions[sharingOptionKey] and data[dataKey] then
				resetCurrentSettings(plugin, settingsToExport)
				for k, v in pairs(data[dataKey]) do
					plugin.db.profile[k] = v
				end
				table.insert(imported, message)
			end
		end

		importSettings('importBarAnchors', 'barAnchors', barAnchorsToExport, barPlugin, L.importedBarAnchors)
		importSettings('importBarSettings', 'barSettings', barSettingsToExport, barPlugin, L.importedBarSettings)
		importSettings('importBarColors', 'barColors', barColorsToExport, colorplugin, L.importedBarColors)
		importSettings('importMessageAnchors', 'messageAnchors', messageAnchorsToExport, messageplugin, L.importedMessageAnchors)
		importSettings('importMessageSettings', 'messageSettings', messageSettingsToExport, messageplugin, L.importedMessageSettings)
		importSettings('importMessageColors', 'messageColors', messageColorsToExport, colorplugin, L.importedMessageColors)

		if #imported == 0 then
			BigWigs:Print(L.noImportMessage)
			return
		end

		BigWigs:SendMessage("BigWigs_ProfileUpdate")
		local importMessage = L.importSuccess:format(table.concat(imported, ", "))
		BigWigs:Print(importMessage)
	end

	--- Saves the currently loaded import string to the BigWigs profile.
	-- After importing a string with :DecodeImportString, this function
	-- will save the data to the BigWigs profile.
	function sharing:SaveData()
		if not importedTableData then
			BigWigs:Print(L.noStringAvailable)
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
		get = function(i) return sharingOptions[i[#i]] end,
		set = function(i, value) sharingOptions[i[#i]] = value end,
		args = {
			importString = {
				type = "input",
				multiline = 5,
				name = L.importString,
				order = 1,
				width = "full",
				pattern = "^(%w+):(.+)$",
				set = function(i, value)
					local processed = sharing:DecodeImportString(value)
					sharingOptions[i[#i]] = value
				end,
				get = function(i) return sharingOptions[i[#i]] end,
			},
			bars = {
				type = "group",
				name = L.BAR,
				inline = true,
				order = 5,
				args = {
					importBarAnchors = {
						type = "toggle",
						name = L.anchors,
						desc = L.anchors_import_desc:format(L.barSmall),
						order = 1,
						width = 1,
						disabled = function() return not IsOptionInString("barAnchors") end,
					},
					importBarSettings = {
						type = "toggle",
						name = L.settings,
						desc = L.settings_import_desc:format(L.barSmall),
						order = 5,
						width = 1,
						disabled = function() return not IsOptionInString("barSettings") end,
					},
					importBarColors = {
						type = "toggle",
						name = L.colors,
						desc = L.colors_import_desc:format(L.barSmall),
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
				args = {
					importMessageAnchors = {
						type = "toggle",
						name = L.anchors,
						desc = L.anchors_import_desc:format(L.messageSmall),
						order = 1,
						width = 1,
						disabled = function() return not IsOptionInString("messageAnchors") end,
					},
					importMessageSettings = {
						type = "toggle",
						name =	L.settings,
						desc = L.settings_import_desc:format(L.messageSmall),
						order = 5,
						width = 1,
						disabled = function() return not IsOptionInString("messageSettings") end,
					},
					importMessageColors = {
						type = "toggle",
						name = L.colors,
						desc = L.colors_import_desc:format(L.messageSmall),
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
					sharingOptions["importString"] = nil
				end,
				disabled = function() return not importedTableData end,
				confirm = true,
				confirmText = L.confirmImport,
			},
		},
	},
	exportSection = {
		type="group",
		name = L.export,
		order = 10,
		get = function(i) return sharingOptions[i[#i]] end,
		set = function(i, value) sharingOptions[i[#i]] = value end,
		args = {
			bars = {
				type = "group",
				name = L.BAR,
				inline = true,
				order = 1,
				args = {
					exportBarAnchors = {
						type = "toggle",
						name = L.anchors,
						desc = L.anchors_export_desc:format(L.barSmall),
						order = 1,
						width = 1,
					},
					exportBarSettings = {
						type = "toggle",
						name = L.settings,
						desc = L.settings_export_desc:format(L.barSmall),
						order = 5,
						width = 1,
					},
					exportBarColors = {
						type = "toggle",
						name = L.colors,
						desc = L.colors_export_desc:format(L.barSmall),
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
					exportMessageAnchors = {
						type = "toggle",
						name = L.anchors,
						desc = L.anchors_export_desc:format(L.messageSmall),
						order = 1,
						width = 1,
					},
					exportMessageSettings = {
						type = "toggle",
						name = L.settings,
						desc = L.settings_export_desc:format(L.messageSmall),
						order = 5,
						width = 1,
					},
					exportMessageColors = {
						type = "toggle",
						name = L.colors,
						desc = L.colors_export_desc:format(L.messageSmall),
						order = 10,
						width = 1,
					},
				},

			},
			exportString = {
				type = "input",
				multiline = 5,
				name = L.exportString,
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
BigWigsSharing = sharing -- Set global so other addons can import/save data using using BigWigsSharing:DecodeImportString() and BigWigsSharing:SaveData().
