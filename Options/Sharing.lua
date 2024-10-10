local sharingModule = {}

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
	local function OnEditFocusGainedHighlight(frame)
		AceGUI:SetFocus(frame.obj)
		frame.obj:Fire("OnEditFocusGained")
		frame.obj.editBox.obj:HighlightText()
	end

	local Type, Version = "NoAcceptMultiline", 1
	local function Constructor()
		local multiLineEditBox = AceGUI:Create("MultiLineEditBox")
		multiLineEditBox.type = Type
		multiLineEditBox.button:Hide()
		multiLineEditBox.button.Show = function() end -- Prevent the button from being shown again
		multiLineEditBox.editBox:SetScript("OnEditFocusGained", OnEditFocusGainedHighlight)
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
local BigWigs = BigWigs
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

local countdownPositionsToExport = {
	"position",
}

-- Settings Args
local barSettingsToExport = {
	"fontName",
	"fontSize",
	"fontSizeEmph",
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

local countdownSettingsToExport = {
	"fontName",
	"fontSize",
	"outline",
	"monochrome",
	"voice",
	"countdownTime",
	-- "bossCountdowns", -- Not exporting boss specific settings
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

local countdownColorsToExport = {
	"fontColor",
}

local nameplateSettingsToExport = {
	-- Icons
	"iconGrowDirection",
	"iconGrowDirectionStart",
	"iconSpacing",
	"iconWidth",
	"iconHeight",
	"iconOffsetX",
	"iconOffsetY",
	"iconAutoScale",
	"iconCooldownNumbers",
	"iconFontName",
	"iconFontSize",
	"iconFontColor",
	"iconFontOutline",
	"iconFontMonochrome",
	"iconCooldownEdge",
	"iconCooldownSwipe",
	"iconCooldownInverse",
	"iconExpireGlow",
	"iconExpireGlowType",
	"iconZoom",
	"iconAspectRatio",
	"iconDesaturate",
	"iconColor",
	"iconGlowColor",
	"iconGlowFrequency",
	"iconGlowPixelLines",
	"iconGlowPixelLength",
	"iconGlowPixelThickness",
	"iconGlowAutoCastParticles",
	"iconGlowAutoCastScale",
	"iconGlowProcStartAnim",
	"iconGlowProcAnimDuration",
	"iconGlowTimeLeft",
	"iconBorder",
	"iconBorderSize",
	"iconBorderColor",

	-- Text
	"textGrowDirection",
	"textGrowDirectionStart",
	"textSpacing",
	"textOffsetX",
	"textOffsetY",
	"textFontName",
	"textFontSize",
	"textFontColor",
	"textOutline",
	"textMonochrome",
	"textUppercase",
}

-- Default Options
local sharingExportOptionsSettings = {
	exportBarPositions = true,
	exportMessagePositions = true,
	exportCountdownPositions = true,
	exportBarSettings = true,
	exportMessageSettings = true,
	exportCountdownSettings = true,
	exportBarColors = true,
	exportMessageColors = true,
	exportCountdownColors = true,
	exportNameplateSettings = true,
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
	local countdownSettings = BigWigs:GetPlugin("Countdown")
	local nameplateSettings = BigWigs:GetPlugin("Nameplates")

	if sharingExportOptionsSettings.exportBarPositions then
		exportOptions["barPositions"] = exportProfileSettings(barPositionsToExport, barSettings.db.profile)
	end

	if sharingExportOptionsSettings.exportMessagePositions then
		exportOptions["messagePositions"] = exportProfileSettings(messagePositionsToExport, messageSettings.db.profile)
	end

	if sharingExportOptionsSettings.exportCountdownPositions then
		exportOptions["countdownPositions"] = exportProfileSettings(countdownPositionsToExport, countdownSettings.db.profile)
	end

	if sharingExportOptionsSettings.exportBarSettings then
		exportOptions["barSettings"] = exportProfileSettings(barSettingsToExport, barSettings.db.profile)
	end

	if sharingExportOptionsSettings.exportMessageSettings then
		exportOptions["messageSettings"] = exportProfileSettings(messageSettingsToExport, messageSettings.db.profile)
	end

	if sharingExportOptionsSettings.exportCountdownSettings then
		exportOptions["countdownSettings"] = exportProfileSettings(countdownSettingsToExport, countdownSettings.db.profile)
	end

	if sharingExportOptionsSettings.exportMessageColors then
		exportOptions["messageColors"] = exportProfileColorSettings(messageColorsToExport)
	end

	if sharingExportOptionsSettings.exportBarColors then
		exportOptions["barColors"] = exportProfileColorSettings(barColorsToExport)
	end

	if sharingExportOptionsSettings.exportCountdownColors then
		exportOptions["countdownColors"] = exportProfileSettings(countdownColorsToExport, countdownSettings.db.profile) -- Not part of color plugin
	end

	if sharingExportOptionsSettings.exportNameplateSettings then
		exportOptions["nameplateSettings"] = exportProfileSettings(nameplateSettingsToExport, nameplateSettings.db.profile)
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
	if group == "countdown" then
		if IsOptionInString("countdownPositions") or IsOptionInString("countdownSettings") or IsOptionInString("countdownColors") then
			return true
		end
	end
	if group == "other" then
		if IsOptionInString("nameplateSettings") then
			return true
		end
	end
	if group == "any" then
		if IsOptionGroupAvailable("bars") or IsOptionGroupAvailable("messages") or IsOptionGroupAvailable("countdown") or IsOptionGroupAvailable("other") then
			return true
		end
	end
	return false
end

do

	local function PreProcess(data)
		importedTableData = data
		for k, _ in pairs(data) do
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
	function sharingModule:DecodeImportString(string)
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
	local comma = (GetLocale() == "zhTW" or GetLocale() == "zhCN") and "，" or ", "
	local function SaveImportedTable(tableData)
		local data = tableData
		local chatMessages = {}
		local barPlugin = BigWigs:GetPlugin("Bars")
		local messageplugin = BigWigs:GetPlugin("Messages")
		local countdownPlugin = BigWigs:GetPlugin("Countdown")
		local colorplugin = BigWigs:GetPlugin("Colors")
		local nameplatePlugin = BigWigs:GetPlugin("Nameplates")

		-- Colors are stored for each plugin/module (e.g. BigWigs_Plugins_Colors for the defaults, BigWigs_Bosses_* for bosses)
		-- We only want to modify the defaults with these imports right now.
		local function importColorSettings(sharingOptionKey, dataKey, settingsToExport, plugin, chatMessageToPrint)
			if sharingImportOptionsSettings[sharingOptionKey] and data[dataKey] then
				for i = 1, #settingsToExport do
					plugin.db.profile[settingsToExport[i]]["BigWigs_Plugins_Colors"]["default"] = nil -- Reset defaults only
				end
				for k, v in pairs(data[dataKey]) do
					plugin.db.profile[k]["BigWigs_Plugins_Colors"]["default"] = v
				end
				table.insert(chatMessages, chatMessageToPrint)
			end
		end

		local function importSettings(sharingOptionKey, dataKey, settingsToImport, plugin, chatMessageToPrint)
			if sharingImportOptionsSettings[sharingOptionKey] and data[dataKey] then
				for i = 1, #settingsToImport do -- Only import settings that match entries in our table
					local nameOfSetting = settingsToImport[i]
					local value = data[dataKey][nameOfSetting]
					if type(value) ~= "nil" then -- We need to store values set to false
						plugin.db.profile[nameOfSetting] = value
					end
				end
				table.insert(chatMessages, chatMessageToPrint)
			end
		end

		importSettings('importBarPositions', 'barPositions', barPositionsToExport, barPlugin, L.imported_bar_positions)
		importSettings('importBarSettings', 'barSettings', barSettingsToExport, barPlugin, L.imported_bar_settings)
		importColorSettings('importBarColors', 'barColors', barColorsToExport, colorplugin, L.imported_bar_colors)
		importSettings('importMessagePositions', 'messagePositions', messagePositionsToExport, messageplugin, L.imported_message_positions)
		importSettings('importMessageSettings', 'messageSettings', messageSettingsToExport, messageplugin, L.imported_message_settings)
		importColorSettings('importMessageColors', 'messageColors', messageColorsToExport, colorplugin, L.imported_message_colors)
		importSettings('importCountdownPositions', 'countdownPositions', countdownPositionsToExport, countdownPlugin, L.imported_countdown_position)
		importSettings('importCountdownSettings', 'countdownSettings', countdownSettingsToExport, countdownPlugin, L.imported_countdown_settings)
		importSettings('importCountdownColors', 'countdownColors', countdownColorsToExport, countdownPlugin, L.imported_countdown_color) -- Not part of color plugin
		importSettings('importNameplateSettings', 'nameplateSettings', nameplateSettingsToExport, nameplatePlugin, L.imported_nameplate_settings)

		if #chatMessages == 0 then
			BigWigs:Print(L.no_import_message)
			return
		end

		BigWigs:SendMessage("BigWigs_ProfileUpdate")
		local importMessage = L.import_success:format(table.concat(chatMessages, comma))
		BigWigs:Print(importMessage)
	end

	--- Saves the currently loaded import string to the BigWigs profile.
	-- After importing a string with :DecodeImportString, this function
	-- will save the data to the BigWigs profile.
	function sharingModule:SaveData()
		if not importedTableData then
			BigWigs:Print(L.no_string_available)
			return
		end
		-- Custom Popup to confirm import?
		SaveImportedTable(importedTableData)
	end

	local function ImportStringFromAddOn(string)
		sharingModule:DecodeImportString(string)
		sharingImportOptionsSettings.importString = string
		if IsOptionInString("barPositions") then
			sharingImportOptionsSettings.importBarPositions = true
		end
		if IsOptionInString("barSettings") then
			sharingImportOptionsSettings.importBarSettings = true
		end
		if IsOptionInString("barColors") then
			sharingImportOptionsSettings.importBarColors = true
		end
		if IsOptionInString("messagePositions") then
			sharingImportOptionsSettings.importMessagePositions = true
		end
		if IsOptionInString("messageSettings") then
			sharingImportOptionsSettings.importMessageSettings = true
		end
		if IsOptionInString("messageColors") then
			sharingImportOptionsSettings.messageColors = true
		end
		if IsOptionInString("countdownPositions") then
			sharingImportOptionsSettings.importCountdownPositions = true
		end
		if IsOptionInString("countdownSettings") then
			sharingImportOptionsSettings.importCountdownSettings = true
		end
		if IsOptionInString("countdownColors") then
			sharingImportOptionsSettings.importCountdownColors = true
		end
		if IsOptionInString("nameplateSettings") then
			sharingImportOptionsSettings.importNameplateSettings = true
		end
		sharingModule:SaveData()
	end
	local _, addonTable = ...
	addonTable.SaveImportStringDataFromAddOn = ImportStringFromAddOn
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
					sharingModule:DecodeImportString(value)
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
			countdown = {
				type = "group",
				name = L.COUNTDOWN,
				inline = true,
				order = 15,
				hidden = function() return (not isImportStringAvailable() or not IsOptionGroupAvailable("countdown")) end,
				args = {
					importCountdownPositions = {
						type = "toggle",
						name = L.position,
						desc = L.position_import_countdown_desc,
						order = 1,
						width = 1,
						disabled = function() return not IsOptionInString("countdownPositions") end,
					},
					importCountdownSettings = {
						type = "toggle",
						name =	L.settings,
						desc = L.settings_import_countdown_desc,
						order = 5,
						width = 1,
						disabled = function() return not IsOptionInString("countdownSettings") end,
					},
					importCountdownColors = {
						type = "toggle",
						name = L.colors,
						desc = L.color_import_countdown_desc,
						order = 10,
						width = 1,
						disabled = function() return not IsOptionInString("countdownColors") end,
					},
				},
			},
			otherSettings = {
				type = "group",
				name = L.other_settings,
				inline = true,
				order = 20,
				hidden = function() return (not isImportStringAvailable() or not IsOptionGroupAvailable("other")) end,
				args = {
					importNameplateSettings = {
						type = "toggle",
						name = L.NAMEPLATE,
						desc = L.nameplate_settings_import_desc,
						order = 1,
						width = 1,
						disabled = function() return not IsOptionInString("nameplateSettings") end,
					},
				},
			},
			acceptImportButton = {
				type = "execute",
				name = L.import,
				order = 100,
				width = "full",
				func = function()
					sharingModule:SaveData()
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
				confirm = function()
					local profileName = BigWigs.db:GetCurrentProfile()
					return L.confirm_import:format(profileName)
				end,
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
			countdown = {
				type = "group",
				name = L.COUNTDOWN,
				inline = true,
				order = 15,
				args = {
					exportCountdownPositions = {
						type = "toggle",
						name = L.position,
						desc = L.position_export_countdown_desc,
						order = 1,
						width = 1,
					},
					exportCountdownSettings = {
						type = "toggle",
						name = L.settings,
						desc = L.settings_export_countdown_desc,
						order = 5,
						width = 1,
					},
					exportCountdownColors = {
						type = "toggle",
						name = L.colors,
						desc = L.color_export_countdown_desc,
						order = 10,
						width = 1,
					},
				},
			},
			otherSettings = {
				type = "group",
				name = L.other_settings,
				inline = true,
				order = 15,
				args = {
					exportNameplateSettings = {
						type = "toggle",
						name = L.NAMEPLATE,
						desc = L.nameplate_settings_export_desc,
						order = 20,
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

local _, addonTable = ...
addonTable.sharingOptions = sharingOptions
