local AceGUI = LibStub("AceGUI-3.0")
local instanceExportPrefix = "BWIS1"

local function createExportString(exportTable)
    local serialized = C_EncodingUtil.SerializeCBOR(exportTable);
    local compressed = C_EncodingUtil.CompressString(serialized, Enum.CompressionMethod.Deflate);
    local encoded = C_EncodingUtil.EncodeBase64(compressed);
    return instanceExportPrefix..":"..encoded;
end

local isMidnight = BigWigsLoader.isMidnight
local exportFrame = nil
local lastImportData = nil
local lastExportData = nil
do
    local function  updateExportString(widget, event, value)
        local tab = widget.parent
        local exportFlags =  tab.checks.flags and tab.checks.flags:GetValue()
        local exportSounds = tab.checks.sounds and tab.checks.sounds:GetValue()
        local exportColors = tab.checks.colors and tab.checks.colors:GetValue()
        local exportPrivateAuras = tab.checks.privateAuras and tab.checks.privateAuras:GetValue()
        local textBox = tab.multiline
        local exportTable = lastExportData.data
        local filteredExportTable = {
            includeFlags = exportFlags,
            includeSounds = exportSounds,
            includeColors = exportColors,
            includePrivateAuras = exportPrivateAuras,
			zone = lastExportData.zone,
            exportData = {},
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
        local exportString = createExportString(filteredExportTable)
        textBox:SetText(exportString)
    end

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
		return {
            flags =  lastImportData.includeFlags,
            colors = lastImportData.includeColors,
            sounds = lastImportData.includeSounds,
            privateAuras = lastImportData.includePrivateAuras,
        }
    end


    local function verifyImportString(widget, event, value)
        local tab = widget.parent
        local multiline = tab.multiline
        lastImportData = nil
        local hasImports = parseImportString(value)
        if hasImports then
			tab.importButton:SetDisabled(false)
			for checkName, check in pairs(tab.importChecks) do
				check:SetDisabled(not hasImports[checkName])
				check:SetValue(hasImports[checkName])
			end
        else
			tab.importButton:SetDisabled(true)
			for _, check in pairs(tab.importChecks) do
				check:SetDisabled(true)
			end
        end
    end

	local function ApplyImport(widget)
		local tab = widget.parent
		local flags = tab.importChecks.flags:GetValue()
		local sounds = tab.importChecks.sounds:GetValue()
		local colors = tab.importChecks.colors:GetValue()
        local privateAuras = tab.importChecks.privateAuras:GetValue()
		local soundModule = BigWigs:GetPlugin("Sounds")
		local colorModule = BigWigs:GetPlugin("Colors")
		BigWigsLoader:LoadZone(lastImportData.zone)
		for moduleName, data in pairs(lastImportData.exportData) do
			if flags and data.flags then
				local module = BigWigs:GetBossModule(moduleName:sub(16))
				if module then
					if module.SetupOptions then module:SetupOptions() end
					if module.db and module.db.profile then
						for key, value in pairs(module.db.profile) do
							if data.flags[key] then
								module.db.profile[key] = data.flags[key]
							end
						end
					end
				end
			end
			if sounds then
				for soundSettingName, savedModules in pairs(soundModule.db.profile) do
                    if soundSettingName ~= "privateaura" or privateAuras then -- only import private auras if the user allowed it
                        if data.sounds and data.sounds[soundSettingName] then
                            soundModule.db.profile[soundSettingName][moduleName] = data.sounds[soundSettingName]
                        else
                            soundModule.db.profile[soundSettingName][moduleName] = nil
                        end
                    end
				end
			end
			if colors then
				for colorSettingName, savedModules in pairs(colorModule.db.profile) do
					if data.colors and data.colors[colorSettingName] then
						colorModule.db.profile[colorSettingName][moduleName] = data.colors[colorSettingName]
					else
						colorModule.db.profile[colorSettingName][moduleName] = nil
					end
				end
			end
		end
        BigWigsOptions:Open()
        exportFrame:Hide()
	end

	local function onExportTabGroupSelected(widget, callback, tab)
		widget:PauseLayout()
		widget:ReleaseChildren()

        local multiline
		if tab == "import" then
			multiline = AceGUI:Create("ImportStringMultiline")
            multiline:SetCallback("OnEnterPressed", verifyImportString)
		else -- export
			multiline = AceGUI:Create("NoAcceptMultiline")
		end
        multiline:DisableButton(true)
        multiline:SetLabel("")
        multiline:SetFullWidth(true)
		widget:AddChild(multiline)
        widget.multiline = multiline

        if tab == "export" then
			-- In Midnight we only show the PA export for now.
			if not isMidnight then
				local flagsCheck = AceGUI:Create("CheckBox")
				flagsCheck:SetLabel("Flags")
				flagsCheck:SetFullWidth(true)
				flagsCheck:SetCallback("OnValueChanged", updateExportString)
				widget:AddChild(flagsCheck)

				local soundsCheck = AceGUI:Create("CheckBox")
				soundsCheck:SetLabel("Sounds")
				soundsCheck:SetValue(true)
				soundsCheck:SetWidth(150)
				soundsCheck:SetCallback("OnValueChanged", updateExportString)
				widget:AddChild(soundsCheck)
			end

            local privateAuraCheck = AceGUI:Create("CheckBox")
			privateAuraCheck:SetLabel("Private Auras")
			privateAuraCheck:SetValue(true)
            privateAuraCheck:SetWidth(150)
            privateAuraCheck:SetCallback("OnValueChanged", updateExportString)
			widget:AddChild(privateAuraCheck)

			if not isMidnight then
				local colorsCheck = AceGUI:Create("CheckBox")
				colorsCheck:SetLabel("Colors")
				colorsCheck:SetValue(true)
				colorsCheck:SetFullWidth(true)
				colorsCheck:SetCallback("OnValueChanged", updateExportString)
				widget:AddChild(colorsCheck)
			end

            widget.checks = {flags = flagsCheck, sounds = soundsCheck, colors = colorsCheck, privateAuras = privateAuraCheck}
			updateExportString(multiline)
		else
			-- In Midnight we only show the PA export for now.
			if not isMidnight then
				local flagsCheck = AceGUI:Create("CheckBox")
				flagsCheck:SetLabel("Flags")
				flagsCheck:SetValue(true)
				flagsCheck:SetFullWidth(true)
				flagsCheck:SetDisabled(true)
				widget:AddChild(flagsCheck)

				local soundsCheck = AceGUI:Create("CheckBox")
				soundsCheck:SetLabel("Sounds")
				soundsCheck:SetValue(true)
				soundsCheck:SetDisabled(true)
				soundsCheck:SetWidth(150)
				widget:AddChild(soundsCheck)
			end

			local privateAuraCheck = AceGUI:Create("CheckBox")
			privateAuraCheck:SetLabel("Private Auras")
			privateAuraCheck:SetValue(true)
			privateAuraCheck:SetDisabled(true)
            privateAuraCheck:SetWidth(150)
			widget:AddChild(privateAuraCheck)

			if not isMidnight then
				local colorsCheck = AceGUI:Create("CheckBox")
				colorsCheck:SetLabel("Colors")
				colorsCheck:SetValue(true)
				colorsCheck:SetDisabled(true)
				colorsCheck:SetValue(not isMidnight)
				colorsCheck:SetFullWidth(true)
				widget:AddChild(colorsCheck)
			end

			local importButton = AceGUI:Create("Button")
			importButton:SetText("Import")
            importButton:SetCallback("OnClick", function(self)
				ApplyImport(self)
			end)
			importButton:SetDisabled(true)
			widget:AddChild(importButton)

			widget.importButton = importButton
			widget.importChecks = {flags = flagsCheck, sounds = soundsCheck, colors = colorsCheck, privateAuras = privateAuraCheck}
		end

		widget:ResumeLayout()
		widget:PerformLayout()
	end

	local function exportPopup(exportInfo)
		local frame = exportFrame
		if not frame then
			local f = AceGUI:Create("Frame")

			f:SetTitle("BigWigs Export")
			f:SetLayout("Flow")
			f.frame:SetSize(400, 300)
			frame = f
        end
        frame:SetStatusText("")

		if exportInfo.zone then
			local zoneName = GetRealZoneText(exportInfo.zone)
            frame:SetStatusText("Exporting "..zoneName)
		end

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
		exportFrame = frame
	end

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
		-- local exporttext = dropdownGroupFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		-- exporttext:SetPoint("TOPLEFT", 4, -5)
		-- exporttext:SetJustifyH("LEFT")
		-- exporttext:SetHeight(18)
		-- exporttext:SetText("Export/Import")

		-- local exportTextWidth = exporttext:GetWidth()
		-- TODO: Fix boss export
		-- local exportBossBtn = CreateFrame("Button", nil, dropdownGroupFrame, "UIPanelButtonTemplate")
		-- exportBossBtn.parentGroup = dropdownGroup
		-- exportBossBtn:SetPoint("TOPLEFT", exportTextWidth + 4, -4)
		-- exportBossBtn:SetScript("OnClick", function(self)
		-- 	local parent = self.parentGroup
		-- 	local modules = parent:GetUserData("moduleList")
		-- 	local currentModule = parent:GetUserData("bossIndex")
		-- 	local bossDb = nil
		-- 	for i, module in ipairs(modules) do
		-- 		if module.moduleName == currentModule then
		-- 			bossDb = module.db.profile
		-- 			break
		-- 		end
		-- 	end
		-- end)
		-- exportBossBtn:SetHeight(20)
		-- local font = exportBossBtn.Text:GetFont()
		-- exportBossBtn.Text:SetFont(font, 12)
		-- exportBossBtn:SetTextToFit("Boss")
		-- exportBossBtn:SetNormalFontObject("DialogButtonNormalText")
		-- exportBossBtn:SetHighlightFontObject("DialogButtonHighlightText")
		-- dropdownGroup.exportBossBtn = exportBossBtn

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
			exportPopup(exportInfo)
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
