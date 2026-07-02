local sharingModule = {}

-------------------------------------------------------------------------------
-- Libraries
--

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
local importingInstances = false
local sharingVersion = "BW2"
local bossSharingVersion = "BWB1"

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
	"spacing",
	"visibleBarLimit",
	"visibleBarLimitEmph",
	"normalWidth",
	"normalHeight",
	"expWidth",
	"expHeight",
	"spellIndicators",
	"spellIndicatorsSize",
	"spellIndicatorsPosition",
	"spellIndicatorsOffset",
	"normalCopyCustomAnchorWidth",
	"expCopyCustomAnchorWidth",
}

local messageSettingsToExport = {
	"fontName",
	"emphFontName",
	"monochrome",
	"emphMonochrome",
	"slugRendering",
	"emphSlugRendering",
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
}

local countdownSettingsToExport = {
	"textEnabled",
	"fontName",
	"outline",
	"fontSize",
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

-- Nameplates
local nameplateSettingsToExport = {
	-- Icons
	"iconGrowDirection",
	"iconGrowDirectionStart",
	"iconGrowDirectionTarget",
	"iconGrowDirectionStartTarget",
	"iconSpacing",
	"iconSpacingTarget",
	"iconOffsetX",
	"iconOffsetY",
	"iconOffsetXTarget",
	"iconOffsetYTarget",
	"iconWidthTarget",
	"iconHeightTarget",
	"iconWidthOthers",
	"iconHeightOthers",
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
	"iconGlowOffsetX",
	"iconGlowOffsetY",
	"iconBorder",
	"iconBorderName",
	"iconBorderOffset",
	"iconBorderSize",
	"iconBorderColor",
	"iconFrameStrata",
	"iconEmphasizeTime",
	"iconEmphasizeFontColor",
	"iconEmphasizeFontSize",

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

-- MythicPlus
local mythicPlusSettingsToExport = {
	-- General
	"countVoice",
	"countBegin",
	"countStartSound",
	"countEndSound",
	-- Who has a key?
	"instanceKeysPosition",
	"instanceKeysFontName",
	"instanceKeysFontSize",
	"instanceKeysMonochrome",
	"instanceKeysGrowUpwards",
	"instanceKeysOutline",
	"instanceKeysAlign",
	"instanceKeysColor",
	"instanceKeysOtherDungeonColor",
	"instanceKeysShowAllPlayers",
	"instanceKeysShowDungeonEnd",
	"instanceKeysHideTitle",
	-- Progress %
	"progressTooltipFormat",
	"progressNameplate",
	"progressNameplateFormat",
	"progressNameplateTargetOffsetX",
	"progressNameplateTargetOffsetY",
	"progressNameplateOtherOffsetX",
	"progressNameplateOtherOffsetY",
	"progressNameplateFontName",
	"progressNameplateFontSize",
	"progressNameplateFontColorTarget",
	"progressNameplateFontColorOther",
	"progressNameplateOutline",
	"progressNameplateMonochrome",
	"progressNameplateSlugRendering",
}

-- BattleRes
local battleResSettingsToExport = {
	"disabled",
	"mode",
	"lock",
	"size",
	"position",
	"textXPositionDuration",
	"textYPositionDuration",
	"textXPositionCharges",
	"textYPositionCharges",
	"fontName",
	"durationFontSize",
	"durationEmphasizeFontSize",
	"chargesNoneFontSize",
	"chargesAvailableFontSize",
	"durationAlign",
	"chargesAlign",
	"monochrome",
	"outline",
	"borderName",
	"borderColor",
	"borderOffset",
	"borderSize",
	"durationColor",
	"durationEmphasizeColor",
	"chargesNoneColor",
	"chargesAvailableColor",
	"newResAvailableSound",
	"durationEmphasizeTime",
	"iconColor",
	"iconTextureFromSpellID",
	"iconDesaturate",
	"cooldownEdge",
	"cooldownSwipe",
	"cooldownInverse",
	"durationCustomText",
	"chargesCustomText",
}

-- PrivateAuras
local privateAurasSettingsToExport = {
	"showDispelType",
	"player",
	"other",
	"otherPlayerType",
	"onlyWhenYouAreTank",
}

-- CombatTimer
local combatTimerSettingsToExport = {
	-- Any Combat
	"anyCombatDisabled",
	"anyCombatLocked",
	"anyCombatWidth",
	"anyCombatHeight",
	"anyCombatPosition",
	"anyCombatFontName",
	"anyCombatFontSize",
	"anyCombatMonochrome",
	"anyCombatOutline",
	"anyCombatAlign",
	"anyCombatColor",
	"anyCombatColorInactive",
	"anyCombatBackgroundColor",
	"anyCombatBackgroundColorInactive",
	"anyCombatBorderColor",
	"anyCombatBorderColorInactive",
	"anyCombatBorderSize",
	"anyCombatBorderOffset",
	"anyCombatBorderName",
	"anyCombatInactive",
	"anyCombatTextFormat",
	"anyCombatHistoryAmount",
	"anyCombatHistoryResetConditions",
	"anyCombatHistoryTimeFormat",
	"anyCombatHistoryHiddenInCombat",
	"anyCombatCustomText",

	-- Boss Combat
	"bossCombatDisabled",
	"bossCombatLocked",
	"bossCombatWidth",
	"bossCombatHeight",
	"bossCombatPosition",
	"bossCombatFontName",
	"bossCombatFontSize",
	"bossCombatMonochrome",
	"bossCombatOutline",
	"bossCombatAlign",
	"bossCombatColor",
	"bossCombatColorInactive",
	"bossCombatBackgroundColor",
	"bossCombatBackgroundColorInactive",
	"bossCombatBorderColor",
	"bossCombatBorderColorInactive",
	"bossCombatBorderSize",
	"bossCombatBorderOffset",
	"bossCombatBorderName",
	"bossCombatInactive",
	"bossCombatTextFormat",
	"bossCombatHistoryAmount",
	"bossCombatHistoryResetConditions",
	"bossCombatHistoryTimeFormat",
	"bossCombatCustomText",

	-- Boss Stages
	"bossStagesDisabled",
	"bossStagesLocked",
	"bossStagesWidth",
	"bossStagesHeight",
	"bossStagesPosition",
	"bossStagesFontName",
	"bossStagesFontSize",
	"bossStagesMonochrome",
	"bossStagesOutline",
	"bossStagesAlign",
	"bossStagesColor",
	"bossStagesColorInactive",
	"bossStagesBackgroundColor",
	"bossStagesBackgroundColorInactive",
	"bossStagesBorderColor",
	"bossStagesBorderColorInactive",
	"bossStagesBorderSize",
	"bossStagesBorderOffset",
	"bossStagesBorderName",
	"bossStagesInactive",
	"bossStagesTextFormat",
	"bossStagesHistoryTimeFormat",
	"bossStagesCustomText",
}

-- Default Options
local encounterExportOptionsSettings = {}
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
	exportMythicPlusSettings = true,
	exportBattleResSettings = true,
	exportPrivateAurasSettings = true,
	exportCombatTimerSettings = true,
}

local sharingImportOptionsSettings = {}

-- Import String Storage
local importStringOptions = {}
local importedTableData = nil

-------------------------------------------------------------------------------
-- Functions
--

local function getInstanceLabel(id)
	local raidName = GetRealZoneText(id)
	if raidName and raidName ~= "" then
		return raidName
	end
	BigWigs:Error('Missing instance name for ID: '..id..', Please report this to the BigWigs authors.')
    return tostring(id)
end

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

do
	local function GetExportString(requestAll)
		local exportOptions = {
			version = sharingVersion, -- :GetVersionString() contains more info than I prefer, using our own version within the plugin.
		}

		local barSettings = BigWigs:GetPlugin("Bars")
		local messageSettings = BigWigs:GetPlugin("Messages")
		local countdownSettings = BigWigs:GetPlugin("Countdown")

		if requestAll or sharingExportOptionsSettings.exportBarPositions then
			exportOptions["barPositions"] = exportProfileSettings(barPositionsToExport, barSettings.db.profile)
		end

		if requestAll or sharingExportOptionsSettings.exportMessagePositions then
			exportOptions["messagePositions"] = exportProfileSettings(messagePositionsToExport, messageSettings.db.profile)
		end

		if requestAll or sharingExportOptionsSettings.exportCountdownPositions then
			exportOptions["countdownPositions"] = exportProfileSettings(countdownPositionsToExport, countdownSettings.db.profile)
		end

		if requestAll or sharingExportOptionsSettings.exportBarSettings then
			exportOptions["barSettings"] = exportProfileSettings(barSettingsToExport, barSettings.db.profile)
		end

		if requestAll or sharingExportOptionsSettings.exportMessageSettings then
			exportOptions["messageSettings"] = exportProfileSettings(messageSettingsToExport, messageSettings.db.profile)
		end

		if requestAll or sharingExportOptionsSettings.exportCountdownSettings then
			exportOptions["countdownSettings"] = exportProfileSettings(countdownSettingsToExport, countdownSettings.db.profile)
		end

		if requestAll or sharingExportOptionsSettings.exportMessageColors then
			exportOptions["messageColors"] = exportProfileColorSettings(messageColorsToExport)
		end

		if requestAll or sharingExportOptionsSettings.exportBarColors then
			exportOptions["barColors"] = exportProfileColorSettings(barColorsToExport)
		end

		if requestAll or sharingExportOptionsSettings.exportCountdownColors then
			exportOptions["countdownColors"] = exportProfileSettings(countdownColorsToExport, countdownSettings.db.profile) -- Not part of color plugin
		end

		if requestAll or sharingExportOptionsSettings.exportNameplateSettings then
			local nameplateSettings = BigWigs:GetPlugin("Nameplates", true)
			if nameplateSettings then
				exportOptions["nameplateSettings"] = exportProfileSettings(nameplateSettingsToExport, nameplateSettings.db.profile)
			end
		end

		if requestAll or sharingExportOptionsSettings.exportMythicPlusSettings then
			local db = BigWigsLoader.db:GetNamespace("MythicPlus", true)
			if db then
				exportOptions["mythicPlusSettings"] = exportProfileSettings(mythicPlusSettingsToExport, db.profile)
			end
		end

		if requestAll or sharingExportOptionsSettings.exportBattleResSettings then
			local plugin = BigWigs:GetPlugin("BattleRes", true)
			if plugin then
				exportOptions["battleResSettings"] = exportProfileSettings(battleResSettingsToExport, plugin.db.profile)
			end
		end

		if requestAll or sharingExportOptionsSettings.exportPrivateAurasSettings then
			local plugin = BigWigs:GetPlugin("PrivateAuras", true)
			if plugin then
				exportOptions["privateAurasSettings"] = exportProfileSettings(privateAurasSettingsToExport, plugin.db.profile)
			end
		end

		if requestAll or sharingExportOptionsSettings.exportCombatTimerSettings then
			local db = BigWigsLoader.db:GetNamespace("CombatTimer", true)
			if db then
				exportOptions["combatTimerSettings"] = exportProfileSettings(combatTimerSettingsToExport, db.profile)
			end
		end

		local serialized = C_EncodingUtil.SerializeCBOR(exportOptions)
		local compressed = C_EncodingUtil.CompressString(serialized, 0) -- Enum.CompressionMethod.Deflate = 0
		local encoded = C_EncodingUtil.EncodeBase64(compressed)
		return sharingVersion..":"..encoded
	end
	local _, addonTable = ...
	addonTable.GetExportString = function(requestAll) return GetExportString(requestAll) end
end

do
	local function GetEncounterExportString(requestAll)
		local exportOptions = {
			version = bossSharingVersion,
			bossExport = true,
			exportTable = {}
		}

		local colorModule = BigWigs:GetPlugin("Colors")
		local soundModule = BigWigs:GetPlugin("Sounds")

		for k, v in pairs(encounterExportOptionsSettings) do
			if v == true then
				BigWigsLoader:LoadZone(k)
				local modules = BigWigs:GetBossModulesForInstanceID(k)
				if modules then
					exportOptions.exportTable[k] = {}
					local instanceSettings = exportOptions.exportTable[k]
					for _, module in ipairs(modules) do
						if module.SetupOptions then module:SetupOptions() end

						-- Flags
						if module.db and module.db.profile and module.db.profile.toggles then
							instanceSettings[module.name] = CopyTable(instanceSettings[module.name] or {})
							instanceSettings[module.name].flags = module.db.profile.toggles
						else
							error(("Module %s does not have a db.profile table."):format(module.name))
						end

						-- Renames
						if module.db and module.db.profile and module.db.profile.renames then
							instanceSettings[module.name] = CopyTable(instanceSettings[module.name] or {})
							instanceSettings[module.name].renames = module.db.profile.renames
						end

						-- Colors
						for colorSettingName, savedModules in pairs(colorModule.db.profile) do
							for colorSettingsModuleName, settings in pairs(savedModules) do
								if colorSettingsModuleName == module.name then
									instanceSettings[module.name].colors = CopyTable(instanceSettings[module.name].colors or {})
									instanceSettings[module.name].colors[colorSettingName] = settings
									break
								end
							end
						end

						-- Sounds
						for soundSettingName, savedSoundModules in pairs(soundModule.db.profile) do
							for soundSettingsModuleName, settings in pairs(savedSoundModules) do
								if soundSettingsModuleName == module.name then
									instanceSettings[module.name].sounds = CopyTable(instanceSettings[module.name].sounds or {})
									instanceSettings[module.name].sounds[soundSettingName] = settings
									break
								end
							end
						end
					end
				end
			end
		end

		local serialized = C_EncodingUtil.SerializeCBOR(exportOptions)
		local compressed = C_EncodingUtil.CompressString(serialized, 0) -- Enum.CompressionMethod.Deflate = 0
		local encoded = C_EncodingUtil.EncodeBase64(compressed)
		return bossSharingVersion..":"..encoded
	end
	local _, addonTable = ...
	addonTable.GetEncounterExportString = function(requestAll) return GetEncounterExportString(requestAll) end
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

local function IsBossImport()
	return importStringOptions.bossExport
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
		if IsOptionInString("nameplateSettings") or IsOptionInString("mythicPlusSettings") or IsOptionInString("battleResSettings") or
		IsOptionInString("privateAurasSettings") or IsOptionInString("combatTimerSettings") then
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
	local _, addonTable = ...

	local function setupBossOptions(exportOptions)
		sharingImportOptionsSettings = {}

		local instances = {}
		for instanceID, modules in pairs(exportOptions.exportTable) do
			instances[instanceID] = getInstanceLabel(instanceID)
		end

		local options = {}
		for k, v in pairs(BigWigsLoader.zoneTbl) do
			if v == BigWigsLoader.currentExpansion.name and instances[k] then
				options.raids = options.raids or {
					type = "multiselect",
					name = L.raids_section,
					values = {},
					order = 10,
				}
				options.raids.values[k] = instances[k]
			end
		end

		for k, v in pairs(BigWigsLoader.currentExpansion.currentSeason) do
			if instances[k] then
				options.seasonaldungeons = options.seasonaldungeons or {
					type = "multiselect",
					name = L.seasonal_dungeons_section,
					values = {},
					order = 20,
				}
				options.seasonaldungeons.values[k] = instances[k]
			end
		end

		for k, v in pairs(BigWigsLoader.zoneTbl) do
			if v == BigWigsLoader.currentExpansion.littleWigsName and instances[k] then
				options.expansiondungeons = options.expansiondungeons or {
					type = "multiselect",
					name = L.expansion_dungeons_section,
					values = {},
					order = 30,
				}
				options.expansiondungeons.values[k] = instances[k]
			end
		end

		addonTable.sharingOptions.importSection.args.bossSettings.args = options
	end

	local function PreProcess(data)
		importedTableData = data
		for k in next, data do
			importStringOptions[k] = true
		end
		if data.bossExport then
			setupBossOptions(data)
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
		if (versionPlain ~= sharingVersion and versionPlain ~= bossSharingVersion) then return end
		local decodedForPrint = C_EncodingUtil.DecodeBase64(importData)
		if not decodedForPrint then return end
		local decompressed = C_EncodingUtil.DecompressString(decodedForPrint, 0) -- Enum.CompressionMethod.Deflate = 0
		if not decompressed then return end
		local data = C_EncodingUtil.DeserializeCBOR(decompressed)
		if not data then return end
		local expectedVersion = data.bossExport and bossSharingVersion or sharingVersion
		if versionPlain ~= expectedVersion then return end -- version prefix does not match expected version
		if data.version ~= expectedVersion then return end -- encoded version does not match expected version
		local importSucceeded = PreProcess(data)
		return importSucceeded
	end
end


do
	local comma = (GetLocale() == "zhTW" or GetLocale() == "zhCN") and "，" or ", "
	local function SaveImportedGeneralSettings(tableData)
		local data = tableData
		local chatMessages = {}
		local barPlugin = BigWigs:GetPlugin("Bars")
		local messageplugin = BigWigs:GetPlugin("Messages")
		local countdownPlugin = BigWigs:GetPlugin("Countdown")
		local colorplugin = BigWigs:GetPlugin("Colors")

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

		importSettings("importBarPositions", "barPositions", barPositionsToExport, barPlugin, L.imported_bar_positions)
		importSettings("importBarSettings", "barSettings", barSettingsToExport, barPlugin, L.imported_bar_settings)
		importColorSettings("importBarColors", "barColors", barColorsToExport, colorplugin, L.imported_bar_colors)
		importSettings("importMessagePositions", "messagePositions", messagePositionsToExport, messageplugin, L.imported_message_positions)
		importSettings("importMessageSettings", "messageSettings", messageSettingsToExport, messageplugin, L.imported_message_settings)
		importColorSettings("importMessageColors", "messageColors", messageColorsToExport, colorplugin, L.imported_message_colors)
		importSettings("importCountdownPositions", "countdownPositions", countdownPositionsToExport, countdownPlugin, L.imported_countdown_position)
		importSettings("importCountdownSettings", "countdownSettings", countdownSettingsToExport, countdownPlugin, L.imported_countdown_settings)
		importSettings("importCountdownColors", "countdownColors", countdownColorsToExport, countdownPlugin, L.imported_countdown_color) -- Not part of color plugin
		do
			local nameplatePlugin = BigWigs:GetPlugin("Nameplates", true)
			if nameplatePlugin then
				importSettings("importNameplateSettings", "nameplateSettings", nameplateSettingsToExport, nameplatePlugin, L.imported_nameplate_settings)
			end
		end
		do
			local db = BigWigsLoader.db:GetNamespace("MythicPlus", true)
			if db then
				importSettings("importMythicPlusSettings", "mythicPlusSettings", mythicPlusSettingsToExport, {db = db}, L.imported_mythicplus_settings)
			end
		end
		do
			local plugin = BigWigs:GetPlugin("BattleRes", true)
			if plugin then
				importSettings("importBattleResSettings", "battleResSettings", battleResSettingsToExport, plugin, L.imported_battleres_settings)
			end
		end
		do
			local plugin = BigWigs:GetPlugin("PrivateAuras", true)
			if plugin then
				importSettings("importPrivateAurasSettings", "privateAurasSettings", privateAurasSettingsToExport, plugin, L.imported_privateAuras_settings)
			end
		end
		do
			local db = BigWigsLoader.db:GetNamespace("CombatTimer", true)
			if db then
				importSettings("importCombatTimerSettings", "combatTimerSettings", combatTimerSettingsToExport, {db = db}, L.imported_combattimer_settings)
			end
		end

		if #chatMessages == 0 then
			BigWigs:Print(L.no_import_message)
			return
		end

		BigWigs:SendMessage("BigWigs_ProfileUpdate")
		local importMessage = L.import_success:format(table.concat(chatMessages, comma))
		BigWigs:Print(importMessage)
	end

	local function SaveImportedBossSettings(tableData)
		local data = tableData
		local chatMessages = {}
		local soundModule = BigWigs:GetPlugin("Sounds", true)
		local colorModule = BigWigs:GetPlugin("Colors", true)

		local function ImportSounds(soundSettings, moduleName)
			if not soundModule then return end

			local sDB = soundModule.db.profile
			for soundSettingName in next, sDB do
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
			if not soundModule or not privateAuraSettings then return end
			local sDB = soundModule.db.profile["privateaura"]
			sDB[moduleName] = CopyTable(privateAuraSettings)
		end

		local function ImportFlags(flagSettings, module)
			if module then
				if module.SetupOptions then module:SetupOptions() end
				if module.db and module.db.profile and module.db.profile.toggles then
					for key, value in pairs(module.db.profile.toggles) do
						if flagSettings and flagSettings[key] then
							module.db.profile.toggles[key] = flagSettings[key]
						else -- wipe to set default
							module.db.profile.toggles[key] = nil
						end
					end
				end
			end
		end

		local function ImportRenames(renameSettings, module)
			if module then
				if module.SetupOptions then module:SetupOptions() end
				if module.db and module.db.profile and module.db.profile.renames then
					for renamesKey, renamesTable in next, renameSettings do
						if module:IsRenameAvailable(renamesKey) and type(renamesTable) == "table" and #renamesTable == module:GetRenameCount(renamesKey) then
							for renameCount = 1, module:GetRenameCount(renamesKey) do
								local renameType = type(renamesTable[renameCount])
								if renameType == "string" or renameType == "number" then
									module.db.profile.renames[renamesKey][renameCount] = renamesTable[renameCount]
								end
							end
						end
					end
				end
			end
		end

		local function ImportColors(colorSettings, moduleName)
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

		local importInstanceQueue = {}
		for instanceID, modules in pairs(data.exportTable) do
			if sharingImportOptionsSettings[instanceID] then
				table.insert(importInstanceQueue, instanceID)
			end
		end

		local timer
		local finalizeImport = function()
			if timer then
				timer:Cancel()
			end
			importingInstances = false
			if #chatMessages == 0 then
				BigWigs:Print(L.no_import_message)
				return
			end

			BigWigs:SendMessage("BigWigs_ProfileUpdate")
			local importMessage = L.import_success:format(table.concat(chatMessages, comma))
			BigWigs:Print(importMessage)
		end

		local function ImportInstanceLoop()
			local nextInstanceID = table.remove(importInstanceQueue)
			if not nextInstanceID then
				return finalizeImport()
			end
			BigWigsLoader:LoadZone(nextInstanceID)
			local modules = data.exportTable[nextInstanceID]
			for moduleName, settings in pairs(modules) do
				local module = BigWigs:GetBossModule(moduleName:sub(16))
				if module and module:IsZoneID(nextInstanceID) then
					ImportFlags(settings.flags, module)
					ImportRenames(settings.renames, module)

					ImportColors(settings.colors, moduleName)
					ImportSounds(settings.sounds, moduleName)
					ImportPrivateAuras(settings.privateAuras, moduleName)
				end
			end
			table.insert(chatMessages, getInstanceLabel(nextInstanceID))
		end
		importingInstances = true
		timer = BigWigsLoader.CTimerNewTicker(0, ImportInstanceLoop)
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
		if IsBossImport() then
			SaveImportedBossSettings(importedTableData)
		else
			SaveImportedGeneralSettings(importedTableData)
		end
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
			sharingImportOptionsSettings.importMessageColors = true
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
		if IsOptionInString("mythicPlusSettings") then
			sharingImportOptionsSettings.importMythicPlusSettings = true
		end
		if IsOptionInString("battleResSettings") then
			sharingImportOptionsSettings.importBattleResSettings = true
		end
		if IsOptionInString("privateAurasSettings") then
			sharingImportOptionsSettings.importPrivateAurasSettings = true
		end
		if IsOptionInString("combatTimerSettings") then
			sharingImportOptionsSettings.importCombatTimerSettings = true
		end
		if IsBossImport() then
			for instanceID in next, importedTableData.exportTable do
				sharingImportOptionsSettings[instanceID] = true
			end
		end
		sharingModule:SaveData()
	end
	local _, addonTable = ...
	addonTable.SaveImportStringDataFromAddOn = ImportStringFromAddOn
end

--------------------------------------------------------------------------------
-- Options
--

local addonTable
do
	local _
	_, addonTable = ...
end

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
				name = function() return (IsOptionGroupAvailable("any") or IsBossImport()) and L.import_info_active or L.import_info_none end,
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
						disabled = function() return not IsOptionInString("nameplateSettings") or not BigWigs:GetPlugin("Nameplates", true) end,
					},
					importMythicPlusSettings = {
						type = "toggle",
						name = L.keystoneModuleName,
						desc = L.mythicplus_settings_import_desc,
						order = 2,
						width = 1,
						disabled = function() return not IsOptionInString("mythicPlusSettings") or not BigWigsLoader.db:GetNamespace("MythicPlus", true) end,
					},
					importBattleResSettings = {
						type = "toggle",
						name = L.battleResTitle,
						desc = L.battleres_settings_import_desc,
						order = 3,
						width = 1,
						disabled = function() return not IsOptionInString("battleResSettings") or not BigWigs:GetPlugin("BattleRes", true) end,
					},
					importPrivateAurasSettings = {
						type = "toggle",
						name = L.privateAuras,
						desc = L.privateAuras_settings_import_desc,
						order = 4,
						width = 1,
						disabled = function() return not IsOptionInString("privateAurasSettings") or not BigWigs:GetPlugin("PrivateAuras", true) end,
					},
					importCombatTimerSettings = {
						type = "toggle",
						name = L.combatTimerTitle,
						desc = L.combattimer_settings_import_desc,
						order = 5,
						width = 1,
						disabled = function() return not IsOptionInString("combatTimerSettings") or not BigWigsLoader.db:GetNamespace("CombatTimer", true) end,
					},
				},
			},
			bossSettings = {
				type = "group",
				name = L.encounter_settings,
				inline = true,
				order = 25,
				hidden = function() return (not isImportStringAvailable() or not IsBossImport()) end,

				get = function(i, key) return sharingImportOptionsSettings[key] end,
				set = function(i, key, value) sharingImportOptionsSettings[key] = value end,
				args = {
					-- Filled up with boss settings by the import field
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
					if importingInstances then return true end
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
					local profileName = BigWigsLoader.db:GetCurrentProfile()
					return L.confirm_import:format(profileName)
				end,
			},
		},
	},
	exportCoreSection = {
		type="group",
		name = L.export_core,
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
						order = 1,
						width = 1,
						get = function(i) return BigWigs:GetPlugin("Nameplates", true) and sharingExportOptionsSettings[i[#i]] end,
						hidden = function() return not BigWigs:GetPlugin("Nameplates", true) end,
					},
					exportMythicPlusSettings = {
						type = "toggle",
						name = L.keystoneModuleName,
						desc = L.mythicplus_settings_export_desc,
						order = 2,
						width = 1,
						get = function(i) return BigWigsLoader.db:GetNamespace("MythicPlus", true) and sharingExportOptionsSettings[i[#i]] end,
						hidden = function() return not BigWigsLoader.db:GetNamespace("MythicPlus", true) end,
					},
					exportBattleResSettings = {
						type = "toggle",
						name = L.battleResTitle,
						desc = L.battleres_settings_export_desc,
						order = 3,
						width = 1,
						get = function(i)
							local plugin = BigWigs:GetPlugin("BattleRes", true)
							if plugin and not plugin.db.profile.disabled then
								return sharingExportOptionsSettings[i[#i]]
							end
						end,
						disabled = function()
							local plugin = BigWigs:GetPlugin("BattleRes", true)
							if not plugin or plugin.db.profile.disabled then
								return true
							end
						end,
						hidden = function() return not BigWigs:GetPlugin("BattleRes", true) end,
					},
					exportPrivateAurasSettings = {
						type = "toggle",
						name = L.privateAuras,
						desc = L.privateAuras_settings_export_desc,
						order = 4,
						width = 1,
						get = function(i)
							local plugin = BigWigs:GetPlugin("PrivateAuras", true)
							if plugin and (not plugin.db.profile.player.disabled or not plugin.db.profile.other.disabled) then
								return sharingExportOptionsSettings[i[#i]]
							end
						end,
						disabled = function()
							local plugin = BigWigs:GetPlugin("PrivateAuras", true)
							if not plugin or (plugin.db.profile.player.disabled and plugin.db.profile.other.disabled) then
								return true
							end
						end,
						hidden = function() return not BigWigs:GetPlugin("PrivateAuras", true) end,
					},
					exportCombatTimerSettings = {
						type = "toggle",
						name = L.combatTimerTitle,
						desc = L.combattimer_settings_export_desc,
						order = 5,
						width = 1,
						get = function(i)
							local db = BigWigsLoader.db:GetNamespace("CombatTimer", true)
							if db and (not db.profile.anyCombatDisabled or not db.profile.bossCombatDisabled or not db.profile.bossStagesDisabled) then
								return sharingExportOptionsSettings[i[#i]]
							end
						end,
						disabled = function()
							local db = BigWigsLoader.db:GetNamespace("CombatTimer", true)
							if not db or (db.profile.anyCombatDisabled and db.profile.bossCombatDisabled and db.profile.bossStagesDisabled) then
								return true
							end
						end,
						hidden = function() return not BigWigsLoader.db:GetNamespace("CombatTimer", true) end,
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
					return addonTable.GetExportString()
				end,
				set = function() end,
				control = "NoAcceptMultiline",
			},
		},
	},
	exportBossSection = {
		type="group",
		name = L.export_bosses,
		order = 20,
		get = function(i, key) return encounterExportOptionsSettings[key] end,
		set = function(i, key, value) encounterExportOptionsSettings[key] = value end,
		args = {
			exportInfo = {
				type = "description",
				name = L.export_bosses_info,
				order = 1,
				width = "full",
			},
			raidExport = {
				type = "multiselect",
				name = L.raids_section,
				values = function ()
					local options = {}
					for k, v in pairs(BigWigsLoader.zoneTbl) do
						if k > 0 then -- skip world zones
							if v == BigWigsLoader.currentExpansion.name then
								options[k] = getInstanceLabel(k)
							end
						end
					end
					return options
				end,
				order = 10,
			},
			seasonalDungeonsExport = {
				type = "multiselect",
				name = L.seasonal_dungeons_section,
				values = function ()
					local options = {}
					for k, v in pairs(BigWigsLoader.currentExpansion.currentSeason) do
						options[k] = getInstanceLabel(k)
					end
					return options
				end,
				order = 20,
			},
			expansionDungeonsExport = {
				type = "multiselect",
				name = L.expansion_dungeons_section,
				values = function ()
					local options = {}
					for k, v in pairs(BigWigsLoader.zoneTbl) do
						if v == BigWigsLoader.currentExpansion.littleWigsName then
							options[k] = getInstanceLabel(k)
						end
					end
					return options
				end,
				order = 30,
			},
			exportString = {
				type = "input",
				multiline = 5,
				name = L.export_string,
				desc = L.export_string_desc,
				order = 100,
				width = "full",
				get = function()
					return addonTable.GetEncounterExportString()
				end,
				set = function() end,
				control = "NoAcceptMultiline",
			},
		},
	}
}

addonTable.sharingOptions = sharingOptions
addonTable.sharingVersion = sharingVersion
addonTable.bossSharingVersion = bossSharingVersion
