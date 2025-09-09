
local BigWigs = BigWigs
local options = {}

local C = BigWigs.C
local loader = BigWigsLoader
local API = BigWigsAPI

local L = API:GetLocale("BigWigs")
local CL = API:GetLocale("BigWigs: Common")

local ldbi = LibStub("LibDBIcon-1.0")
local acr = LibStub("AceConfigRegistry-3.0")
local acd = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local adbo = LibStub("AceDBOptions-3.0")
local lds = LibStub("LibDualSpec-1.0", true)

options.SendMessage = loader.SendMessage
local UnitName = loader.UnitName

local bwTooltip = CreateFrame("GameTooltip", "BigWigsOptionsTooltip", UIParent, "GameTooltipTemplate")
bwTooltip:SetScript("OnUpdate", function(self, elapsed)
	-- basically GameTooltip_OnUpdate
	self.updateTooltipTimer = (self.updateTooltipTimer or 0.2) - elapsed
	if self.updateTooltipTimer > 0 then return end
	self.updateTooltipTimer = 0.2

	local owner = self:GetOwner()
	local widget = owner and owner.obj
	if widget and widget:GetUserData("updateTooltip") then
		widget:Fire("OnEnter")
	elseif self.shouldRefreshData then -- TOOLTIP_DATA_UPDATE
		self:RefreshData()
	end
end)
local function bwTooltip_Hide()
	-- common OnLeave handler
	bwTooltip:Hide()
end

local colorModule
local soundModule
local configFrame

local showToggleOptions, getAdvancedToggleOption = nil, nil
local toggleOptionsStatusTable, lastOptionsTab = {}, nil

local C_EncounterJournal_GetSectionInfo = loader.isClassic and function(key)
	local info = (loader.isCata or loader.isMists) and C_EncounterJournal.GetSectionInfo(key)
	if info then
		-- Cataclysm only has section info for Cataclysm content, return it if found
		-- Mists has all dungeon content, but is missing pre-Cata raids
		return info
	end
	info = API:GetLocale("BigWigs: Encounter Info")[key]
	if info then
		-- Options uses a few more fields, so copy the entry and include them
		local tbl = {}
		for k,v in next, info do
			tbl[k] = v
		end
		tbl.spellID = 0
		tbl.link = ("|cff66bbff|Hjournal:2:%d:1|h[%s]|h|r"):format(key, tbl.title)
		return tbl
	end
end or C_EncounterJournal.GetSectionInfo

local aceConfigTableMainBigWigsTab = {
	type = "group",
	name = "BigWigs",
	get = function(info)
		return loader.db.profile[info[#info]]
	end,
	set = function(info, value)
		local key = info[#info]
		loader.db.profile[key] = value
	end,
	args = {
		general = {
			order = 0,
			type = "group",
			name = "BigWigs",
			args = {
				introduction = {
					type = "description",
					name = L.introduction,
					order = 12,
					fontSize = "medium",
					width = "full",
				},
				minimap = {
					type = "toggle",
					name = L.minimapIcon,
					desc = L.minimapToggle,
					order = 13,
					get = function() return not BigWigsIconDB.hide end,
					set = function(_, v)
						if v then
							BigWigsIconDB.hide = nil
							ldbi:Show("BigWigs")
						else
							BigWigsIconDB.hide = true
							ldbi:Hide("BigWigs")
						end
					end,
					width = 1.5,
				},
				compartment = {
					type = "toggle",
					name = L.compartmentMenu,
					desc = L.compartmentMenu_desc,
					order = 14,
					get = function() return not ldbi:IsButtonInCompartment("BigWigs") end,
					set = function(_, v)
						if v then
							ldbi:RemoveButtonFromCompartment("BigWigs")
						else
							ldbi:AddButtonToCompartment("BigWigs")
						end
					end,
					hidden = not ldbi:IsButtonCompartmentAvailable(),
				},
				separator3 = {
					type = "description",
					name = " ",
					order = 30,
					width = "full",
				},
				showZoneMessages = {
					type = "toggle",
					name = L.zoneMessages,
					desc = L.zoneMessagesDesc,
					order = 32,
					width = "full",
				},
				fakeDBMVersion = {
					type = "toggle",
					name = L.dbmFaker,
					desc = L.dbmFakerDesc,
					order = 33,
					width = "full",
				},
				separator4 = {
					type = "description",
					name = " ",
					order = 40,
					width = "full",
				},
				englishSayMessages = {
					type = "toggle",
					name = L.englishSayMessages,
					desc = L.englishSayMessagesDesc,
					order = 41,
					width = "full",
					disabled = function()
						local myLocale = GetLocale()
						return myLocale == "enUS" or myLocale == "enGB"
					end,
				},
				slashDescTitle = {
					type = "description",
					name = "\n".. L.slashDescTitle,
					fontSize = "large",
					order = 43,
					width = "full",
				},
				slashDescPull = {
					type = "description",
					name = "  ".. L.slashDescPull,
					fontSize = "medium",
					order = 44,
					width = "full",
				},
				slashDescBreak = {
					type = "description",
					name = "  ".. L.slashDescBreak,
					fontSize = "medium",
					order = 45,
					width = "full",
				},
				slashDescBar = {
					type = "description",
					name = "  ".. L.slashDescRaidBar,
					fontSize = "medium",
					order = 46,
					width = "full",
				},
				slashDescLocalBar = {
					type = "description",
					name = "  ".. L.slashDescLocalBar,
					fontSize = "medium",
					order = 47,
					width = "full",
				},
				slashDescRange = {
					type = "description",
					name = "  ".. L.slashDescRange,
					fontSize = "medium",
					order = 48,
					width = "full",
				},
				slashDescVersion = {
					type = "description",
					name = "  ".. L.slashDescVersion,
					fontSize = "medium",
					order = 49,
					width = "full",
				},
				slashDescConfig = {
					type = "description",
					name = "  ".. L.slashDescConfig,
					fontSize = "medium",
					order = 50,
					width = "full",
				},
				gitHubDesc = {
					type = "description",
					name = "\n".. L.gitHubDesc .."\n",
					fontSize = "medium",
					order = 51,
					width = "full",
				},
				discord = {
					type = "input",
					get = function() return "discord.gg/jGveg85" end,
					set = function() end,
					name = "Discord",
					order = 52,
					width = 0.75,
				},
				github = {
					type = "input",
					get = function() return "github.com/BigWigsMods" end,
					set = function() end,
					name = "GitHub",
					order = 53,
					width = 0.95,
				},
				curseforge = {
					type = "input",
					get = function() return "curseforge.com/wow/addons/big-wigs" end,
					set = function() end,
					name = "CurseForge",
					order = 54,
					width = 1.32,
				},
			},
		},
	},
}

local ConstructMainBigWigsTab
do
	local ConstructToolsTab
	do
		local aceConfigTableToolsTab = {
			type = "group",
			name = L.tools,
			get = function(info)
				return loader.db.profile[info[#info]]
			end,
			set = function(info, value)
				local key = info[#info]
				loader.db.profile[key] = value
			end,
			args = {
				tools = {
					order = 1,
					type = "group",
					name = L.tools,
					args = {
						toolsDesc = {
							type = "description",
							name = L.toolsDesc,
							fontSize = "large",
							order = 0,
							width = "full",
						},
					},
					hidden = loader.isVanilla,
				},
			},
		}
		function ConstructToolsTab()
			for key, optionsTable in next, API.GetToolOptions() do
				aceConfigTableToolsTab.args.tools.args[key] = optionsTable
			end
			return aceConfigTableToolsTab
		end
	end

	local addonName, addonTable = ...
	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	local function Initialize(_, _, addon)
		if addon ~= addonName then return end
		f:UnregisterEvent("ADDON_LOADED")

		aceConfigTableMainBigWigsTab.args.general.args.profileOptions = {
			type = "group",
			childGroups = "tab",
			order = 100,
			args = {
				profile = adbo:GetOptionsTable(loader.db),
				export = addonTable.sharingOptions.exportSection,
				import = addonTable.sharingOptions.importSection,
			},
		}
		aceConfigTableMainBigWigsTab.args.general.args.profileOptions.name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Profile:20|t " .. aceConfigTableMainBigWigsTab.args.general.args.profileOptions.args.profile.name
		aceConfigTableMainBigWigsTab.args.general.args.profileOptions.args.profile.order = 1

		if lds then
			lds:EnhanceOptions(aceConfigTableMainBigWigsTab.args.general.args.profileOptions.args.profile, loader.db)
		end

		acr:RegisterOptionsTable("BigWigs", ConstructMainBigWigsTab, true)
		acr:RegisterOptionsTable("BigWigsTools", ConstructToolsTab, true)
		acd:SetDefaultSize("BigWigs", 858, 660)
		acd:SetDefaultSize("BigWigsTools", 858, 660)

		colorModule = BigWigs:GetPlugin("Colors")
		soundModule = BigWigs:GetPlugin("Sounds")
		acr:RegisterOptionsTable("BigWigs: Colors Override", colorModule:SetColorOptions("dummy", "dummy"), true)
		acr:RegisterOptionsTable("BigWigs: Sounds Override", soundModule:SetSoundOptions("dummy", "dummy"), true)

		loader.RegisterMessage(options, "BigWigs_PluginOptionsReady")
		local pluginOptions = BigWigs:GetPluginOptions()
		for pluginName, optionsTbl in next, pluginOptions do
			options:BigWigs_PluginOptionsReady(nil, pluginName, optionsTbl[1], optionsTbl[2])
		end

		-- Wait with nilling, we don't know how many addons will load during this same execution.
		loader.CTimerAfter(5, function() f:SetScript("OnEvent", nil) end)
	end
	f:SetScript("OnEvent", Initialize)
end

local spellDescriptionUpdater = CreateFrame("Frame")
local visibleSpellDescriptionWidgets = {}
spellDescriptionUpdater:SetScript("OnEvent", function(_, _, spellId)
	local scrollFrame = nil
	for widget, widgetSpellId in next, visibleSpellDescriptionWidgets do
		if spellId == widgetSpellId then
			scrollFrame = widget:GetUserData("scrollFrame")
			local module, bossOption = widget:GetUserData("module"), widget:GetUserData("option")
			local _, _, desc = BigWigs:GetBossOptionDetails(module, bossOption)
			widget:SetDescription(desc)
		end
	end
	if scrollFrame then
		scrollFrame:PerformLayout()
	end
end)

function options:Open()
	if not configFrame then
		options:OpenConfig()
	end
end

function options:Close()
	if configFrame then
		configFrame:Hide()
	end
end

function options:IsOpen()
	return configFrame and true or false
end

-------------------------------------------------------------------------------
-- Plugin options
--

local function getMasterOption(self)
	local key = self:GetUserData("key")
	local module = self:GetUserData("module")
	if type(key) == "string" and key:find("^custom_") then
		return module.db.profile[key]
	end
	if type(module.db.profile[key]) ~= "number" then
		module.db.profile[key] = module.toggleDefaults[key]
	end
	if module.db.profile[key] == 0 then
		return false -- nothing go away
	end
	if bit.band(module.db.profile[key], module.toggleDefaults[key]) == module.toggleDefaults[key] then
		return true -- all default baby
	end
	return nil -- some options set
end

local notNumberError = "The option %q for module %q either has a mismatched current value (%q) or target value (%q)."
local function getSlaveOption(self)
	local key = self:GetUserData("key")
	local module = self:GetUserData("module")
	local flag = self:GetUserData("flag")
	local current = module.db.profile[key]
	if type(current) ~= "number" or type(flag) ~= "number" then
		error(notNumberError:format(tostring(key), tostring(module.moduleName), tostring(current), tostring(flag)))
	end
	return bit.band(current, flag) == flag
end

local function masterOptionToggled(self, event, value)
	if value == nil then self:SetValue(false) end -- toggling the master toggles all (we just pretend to be a tristate)
	local key = self:GetUserData("key")
	local module = self:GetUserData("module")
	local keyIsString = type(key) == "string"
	if keyIsString and key:find("custom_select", nil, true) then
		module.db.profile[key] = value or 1
	elseif keyIsString and key:find("custom_", nil, true) then
		module.db.profile[key] = value or false
	else
		if value then
			-- If an option is disabled by default using the "OFF" toggle flag, then when we turn it on, we want all the default flags on also
			module.db.profile[key] = module.toggleDisabled and module.toggleDisabled[key] or module.toggleDefaults[key]
		else
			module.db.profile[key] = 0
		end
		local dropdown = self:GetUserData("dropdown")
		-- This data ONLY exists if we're looking at the advanced options tab,
		-- we force a refresh of all checkboxes when enabling/disabling the master option.
		if dropdown then
			local scrollFrame = self:GetUserData("scrollFrame")
			local bossOption = self:GetUserData("option")
			visibleSpellDescriptionWidgets = {}
			scrollFrame:ReleaseChildren()
			scrollFrame:AddChildren(getAdvancedToggleOption(scrollFrame, dropdown, module, bossOption))
			scrollFrame:PerformLayout()
		end
	end

	-- After :SetValue so it's not overwritten
	self.text:SetTextColor(1, 0.82, 0)
end

local function slaveOptionToggled(self, event, value)
	local key = self:GetUserData("key")
	local module = self:GetUserData("module")
	local flag = self:GetUserData("flag")
	local master = self:GetUserData("master")
	if value then
		module.db.profile[key] = module.db.profile[key] + flag
	else
		module.db.profile[key] = module.db.profile[key] - flag
	end
	master:SetValue(getMasterOption(master))

	-- After :SetValue so it's not overwritten
	master.text:SetTextColor(1, 0.82, 0)
	self.text:SetTextColor(1, 0.82, 0)
end

local function slaveOptionMouseOver(self, event, value)
	bwTooltip:SetOwner(self.frame, "ANCHOR_TOP")
	if self:GetUserData("label") then
		bwTooltip:AddLine(self:GetUserData("label"))
	end
	bwTooltip:AddLine(self:GetUserData("desc"), 1, 1, 1, true)
	bwTooltip:Show()
end

local function getSlaveToggle(label, desc, key, module, flag, master, width, icon, ...)
	local toggle = AceGUI:Create("CheckBox")
	toggle:SetLabel(label)
	toggle:SetRelativeWidth(width)
	toggle:SetHeight(30)

	if icon then
		if ... then
			toggle:SetImage(icon, ...)
		else
			if type(icon) == "string" then
				toggle:SetImage(icon) -- custom icon
				toggle:SetUserData("label", "|T"..icon..":20|t "..label)
			else
				toggle:SetImage(icon, 0.07, 0.93, 0.07, 0.93)
			end
		end
	end
	toggle:SetUserData("key", key)
	toggle:SetUserData("desc", desc)
	toggle:SetUserData("module", module)
	toggle:SetUserData("flag", flag)
	toggle:SetUserData("master", master)
	toggle:SetCallback("OnValueChanged", slaveOptionToggled)
	toggle:SetCallback("OnEnter", slaveOptionMouseOver)
	toggle:SetCallback("OnLeave", bwTooltip_Hide)
	toggle:SetValue(getSlaveOption(toggle))
	toggle.text:SetTextColor(1, 0.82, 0) -- After :SetValue so it's not overwritten
	return toggle
end

local function hasOptionFlag(dbKey, module, key)
	-- Check the actual option table instead of using toggleDefaults
	for _, opTbl in next, module.toggleOptions do
		if type(opTbl) == "table" and opTbl[1] == dbKey then
			for i = 2, #opTbl do
				if opTbl[i] == key then
					return true
				end
			end
		end
	end
end

local function advancedToggles(dbKey, module, check)
	local dbv = module.toggleDisabled and module.toggleDisabled[dbKey] or module.toggleDefaults[dbKey]
	local advOpts = {}

	local isPrivateAura = hasOptionFlag(dbKey, module, "PRIVATE")

	if dbKey ~= "altpower" and dbKey ~= "infobox" then
		-- Emphasize
		if not isPrivateAura or hasOptionFlag(dbKey, module, "ME_ONLY_EMPHASIZE") then
			advOpts[#advOpts+1] = getSlaveToggle(L.EMPHASIZE, L.EMPHASIZE_desc, dbKey, module, C.EMPHASIZE, check, 0.3, module:GetMenuIcon("EMPHASIZE"))
			advOpts[#advOpts+1] = getSlaveToggle(L.ME_ONLY_EMPHASIZE, L.ME_ONLY_EMPHASIZE_desc, dbKey, module, C.ME_ONLY_EMPHASIZE, check, 0.5, module:GetMenuIcon("ME_ONLY_EMPHASIZE"))
		else
			advOpts[#advOpts+1] = getSlaveToggle(L.EMPHASIZE, L.EMPHASIZE_desc, dbKey, module, C.EMPHASIZE, check, 0.8, module:GetMenuIcon("EMPHASIZE"))
		end
		--

		-- Bar & Countdown
		advOpts[#advOpts+1] = getSlaveToggle(L.BAR, L.BAR_desc, dbKey, module, C.BAR, check, 0.3, module:GetMenuIcon("BAR"))
		advOpts[#advOpts+1] = getSlaveToggle(L.COUNTDOWN, L.COUNTDOWN_desc, dbKey, module, C.COUNTDOWN, check, 0.5, module:GetMenuIcon("COUNTDOWN"))
		--

		-- Cast Bars & Cast Countdowns
		if hasOptionFlag(dbKey, module, "CASTBAR") then
			advOpts[#advOpts+1] = getSlaveToggle(L.CASTBAR, L.CASTBAR_desc, dbKey, module, C.CASTBAR, check, 0.3, module:GetMenuIcon("CASTBAR"))
			advOpts[#advOpts+1] = getSlaveToggle(L.CASTBAR_COUNTDOWN, L.CASTBAR_COUNTDOWN_desc, dbKey, module, C.CASTBAR_COUNTDOWN, check, 0.5, module:GetMenuIcon("CASTBAR_COUNTDOWN"))
		end
		--

		-- Messages & Sound
		if not isPrivateAura or hasOptionFlag(dbKey, module, "ME_ONLY") then
			advOpts[#advOpts+1] = getSlaveToggle(L.MESSAGE, L.MESSAGE_desc, dbKey, module, C.MESSAGE, check, 0.3, module:GetMenuIcon("MESSAGE"))
			advOpts[#advOpts+1] = getSlaveToggle(L.ME_ONLY, L.ME_ONLY_desc, dbKey, module, C.ME_ONLY, check, 0.4, module:GetMenuIcon("ME_ONLY"))
			advOpts[#advOpts+1] = getSlaveToggle(L.SOUND, L.SOUND_desc, dbKey, module, C.SOUND, check, 0.3, module:GetMenuIcon("SOUND"))
		else
			advOpts[#advOpts+1] = getSlaveToggle(L.MESSAGE, L.MESSAGE_desc, dbKey, module, C.MESSAGE, check, 0.3, module:GetMenuIcon("MESSAGE"))
			advOpts[#advOpts+1] = getSlaveToggle(L.SOUND, L.SOUND_desc, dbKey, module, C.SOUND, check, 0.5, module:GetMenuIcon("SOUND"))
		end
		--
	end

	if hasOptionFlag(dbKey, module, "NAMEPLATE") then
		advOpts[#advOpts+1] = getSlaveToggle(L.NAMEPLATE, L.NAMEPLATE_desc, dbKey, module, C.NAMEPLATE, check, 0.3, module:GetMenuIcon("NAMEPLATE"))
	end

	-- Flash & Pulse
	if bit.band(dbv, C.FLASH) == C.FLASH and hasOptionFlag(dbKey, module, "FLASH") then
		advOpts[#advOpts+1] = getSlaveToggle(L.FLASH, L.FLASH_desc, dbKey, module, C.FLASH, check, 0.3, module:GetMenuIcon("FLASH"))
		advOpts[#advOpts+1] = getSlaveToggle(L.PULSE, L.PULSE_desc, dbKey, module, C.PULSE, check, 0.5, module:GetMenuIcon("PULSE"))
	end
	--

	if dbKey ~= "altpower" and dbKey ~= "infobox" then
		if API:HasVoicePack() then
			advOpts[#advOpts+1] = getSlaveToggle(L.VOICE, L.VOICE_desc, dbKey, module, C.VOICE, check, 0.3, module:GetMenuIcon("VOICE"))
		end
	end

	for i, key in next, BigWigs:GetOptions() do
		local flag = C[key]
		if bit.band(dbv, flag) == flag then
			local name, desc = BigWigs:GetOptionDetails(key)
			-- All on by default, check if we should add a GUI widget
			if key == "ICON" or key == "SAY" or key == "SAY_COUNTDOWN" or key == "PROXIMITY" or key == "ALTPOWER" or key == "INFOBOX" then
				if hasOptionFlag(dbKey, module, key) then
					advOpts[#advOpts+1] = getSlaveToggle(name, desc, dbKey, module, flag, check, 0.3, module:GetMenuIcon(key))
				end
			elseif key ~= "MESSAGE" and key ~= "BAR" and key ~= "FLASH" and key ~= "VOICE" then
				advOpts[#advOpts+1] = getSlaveToggle(name, desc, dbKey, module, flag, check, 0.3)
			end
		end
	end

	return unpack(advOpts)
end

local function advancedTabSelect(widget, callback, tab)
	if widget:GetUserData("tab") == tab then return end
	widget:SetUserData("tab", tab)
	visibleSpellDescriptionWidgets = {}
	widget:PauseLayout()
	widget:ReleaseChildren()
	local module = widget:GetUserData("module")
	local key = widget:GetUserData("key")
	local master = widget:GetUserData("master")

	if tab == "options" then
		widget:AddChildren(advancedToggles(key, module, master))
	elseif tab == "sounds" then
		local group = AceGUI:Create("SimpleGroup")
		group:SetFullWidth(true)
		widget:AddChild(group)
		soundModule:SetSoundOptions(module.name, key, module.db.profile[key])
		acd:Open("BigWigs: Sounds Override", group)
	elseif tab == "colors" then
		local group = AceGUI:Create("SimpleGroup")
		group:SetFullWidth(true)
		widget:AddChild(group)
		colorModule:SetColorOptions(module.name, key, module.toggleDefaults[key])
		acd:Open("BigWigs: Colors Override", group)
	end
	widget:ResumeLayout()
	widget:GetUserData("scrollFrame"):PerformLayout()
	widget:PerformLayout()
end

local advancedTabs = {
	{
		text = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Sliders:20|t ".. L.advanced_options,
		value = "options",
	},
	{
		text = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Colors:20|t ".. L.colors,
		value = "colors",
	},
	{
		text = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Sounds:20|t ".. L.sound,
		value = "sounds",
	},
}

function getAdvancedToggleOption(scrollFrame, dropdown, module, bossOption)
	local dbKey, name, desc, icon, alternativeName = BigWigs:GetBossOptionDetails(module, bossOption)
	local widgets = {}

	local back = AceGUI:Create("Button")
	back:SetText(L.back)
	back:SetFullWidth(true)
	back:SetCallback("OnClick", function()
		showToggleOptions(dropdown, nil, dropdown:GetUserData("bossIndex"), true)
	end)
	widgets[#widgets + 1] = back

	-- Add a small text label to the top right displaying the spell ID or key
	local idLabel = AceGUI:Create("Label")
	if type(dbKey) == "number" then
		idLabel.label:SetFormattedText(L.optionsKey, dbKey)
	else
		idLabel.label:SetFormattedText(L.optionsKey, "\""..dbKey.."\"")
	end
	idLabel:SetColor(0.65, 0.65, 0.65)
	idLabel:SetFullWidth(true)
	idLabel.label:SetJustifyH("RIGHT")
	widgets[#widgets + 1] = idLabel

	local check = AceGUI:Create("CheckBox")
	check:SetLabel(alternativeName and L.alternativeName:format(name, alternativeName) or name)
	check:SetTriState(true)
	check:SetFullWidth(true)
	check:SetDescription(desc)
	check:SetUserData("key", dbKey)
	check:SetUserData("scrollFrame", scrollFrame)
	check:SetUserData("dropdown", dropdown)
	check:SetUserData("module", module)
	check:SetUserData("option", bossOption)
	check:SetCallback("OnValueChanged", masterOptionToggled)
	check:SetValue(getMasterOption(check))
	check.text:SetTextColor(1, 0.82, 0) -- After :SetValue so it's not overwritten
	if icon then
		check:SetImage(icon, 0.07, 0.93, 0.07, 0.93)
	end
	widgets[#widgets + 1] = check

	-- Create role-specific secondary checkbox
	for i, key in next, BigWigs:GetRoleOptions() do
		local flag = C[key]
		local dbv = module.toggleDisabled and module.toggleDisabled[dbKey] or module.toggleDefaults[dbKey]
		if bit.band(dbv, flag) == flag then
			local roleName, roleDesc = BigWigs:GetOptionDetails(key)
			local roleRestrictionCheckbox
			if key == "TANK" or key == "HEALER" or key == "DISPEL" then
				roleRestrictionCheckbox = getSlaveToggle(roleName, roleDesc, dbKey, module, flag, check, 0.3, module:GetMenuIcon(key))
			else
				roleRestrictionCheckbox = getSlaveToggle(roleName, roleDesc, dbKey, module, flag, check, 0.3) -- No icon
			end
			roleRestrictionCheckbox:SetDescription(roleDesc)
			roleRestrictionCheckbox:SetFullWidth(true)
			roleRestrictionCheckbox:SetUserData("desc", nil) -- Remove tooltip set by getSlaveToggle() function
			widgets[#widgets + 1] = roleRestrictionCheckbox
		end
	end

	if hasOptionFlag(dbKey, module, "PRIVATE") then
		local privateAuraText = AceGUI:Create("Label")
		privateAuraText:SetText(L.PRIVATE_desc)
		privateAuraText:SetColor(1, 0.75, 0.79)
		privateAuraText:SetImage(module:GetMenuIcon("PRIVATE"))
		privateAuraText:SetFullWidth(true)
		privateAuraText:SetHeight(30)
		widgets[#widgets + 1] = privateAuraText
	end

	local tabs = AceGUI:Create("TabGroup")
	tabs:SetLayout("Flow")
	tabs:SetTabs(advancedTabs)
	tabs:SetFullWidth(true)
	tabs:SetCallback("OnGroupSelected", advancedTabSelect)
	tabs:SetUserData("tab", "")
	tabs:SetUserData("key", dbKey)
	tabs:SetUserData("module", module)
	tabs:SetUserData("master", check)
	tabs:SetUserData("scrollFrame", scrollFrame)
	tabs:SelectTab("options")
	widgets[#widgets + 1] = tabs

	return unpack(widgets)
end

local function buttonClicked(widget)
	visibleSpellDescriptionWidgets = {}
	-- save scroll bar position
	toggleOptionsStatusTable.restore_scrollvalue = toggleOptionsStatusTable.scrollvalue
	toggleOptionsStatusTable.restore_offset = toggleOptionsStatusTable.offset

	local scrollFrame = widget:GetUserData("scrollFrame")
	local dropdown = widget:GetUserData("dropdown")
	local module = widget:GetUserData("module")
	local bossOption = widget:GetUserData("bossOption")
	scrollFrame:ReleaseChildren()
	scrollFrame:SetScroll(0)
	scrollFrame:AddChildren(getAdvancedToggleOption(scrollFrame, dropdown, module, bossOption))
	scrollFrame:PerformLayout()
end

local function flagOnEnter(widget)
	bwTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
	bwTooltip:SetText(widget:GetUserData("tooltipText"), 1, 1, 1, true)
	bwTooltip:Show()
end

local function customDropdownWithBoolValueChanged(widget, _, value)
	if value == 0 then value = false end
	local key = widget:GetUserData("key")
	local module = widget:GetUserData("module")
	module.db.profile[key] = value or false
end

local function customDropdownValueChanged(widget, _, value)
	local key = widget:GetUserData("key")
	local module = widget:GetUserData("module")
	module.db.profile[key] = value or 1
end

local function getDefaultToggleOption(scrollFrame, dropdown, module, bossOption)
	local dbKey, name, desc, icon, alternativeName = BigWigs:GetBossOptionDetails(module, bossOption)

	-- jesus this is so hacky. should probably be "custom_select_" with values as a
	-- :GetBossOptionDetails return, but this keeps changes to a minimum for now
	if type(dbKey) == "string" and dbKey:find("^custom_off_select_") then
		local moduleLocale = module:GetLocale()
		local values = { [0] = CL.disabled }
		local i = 1
		local value = moduleLocale[dbKey.."_value"..i]
		repeat
			values[i] = value
			i = i + 1
			value = moduleLocale[dbKey.."_value"..i]
		until not value

		local customDropdown = AceGUI:Create("Dropdown")
		if desc then
			-- The label will truncate at ~74 chars, but showing the desc in a tooltip seems awkward
			customDropdown:SetLabel(("%s: |cffffffff%s|r"):format(name, desc))
		else
			customDropdown:SetLabel(name)
		end
		customDropdown:SetMultiselect(false)
		customDropdown:SetList(values)
		customDropdown:SetFullWidth(true)
		customDropdown:SetUserData("key", dbKey)
		customDropdown:SetUserData("module", module)
		customDropdown:SetCallback("OnValueChanged", customDropdownWithBoolValueChanged)
		customDropdown:SetValue(module.db.profile[dbKey] or 0)

		return customDropdown
	end

	if type(dbKey) == "string" and dbKey:find("^custom_select_") then
		local moduleLocale = module:GetLocale()
		local values = {}
		local i = 1
		local value = moduleLocale[dbKey.."_value"..i]
		repeat
			values[i] = value
			i = i + 1
			value = moduleLocale[dbKey.."_value"..i]
		until not value

		local customDropdown = AceGUI:Create("Dropdown")
		if desc then
			-- The label will truncate at ~74 chars, be careful
			customDropdown:SetLabel(("%s: |cffffffff%s|r"):format(name, desc))
		else
			customDropdown:SetLabel(name)
		end
		customDropdown:SetMultiselect(false)
		customDropdown:SetList(values)
		customDropdown:SetUserData("key", dbKey)
		customDropdown:SetUserData("module", module)
		customDropdown:SetCallback("OnValueChanged", customDropdownValueChanged)
		customDropdown:SetValue(module.db.profile[dbKey] or 1)

		if icon then
			local iconWidget = AceGUI:Create("Icon")
			iconWidget:SetImage(icon, 0.07, 0.93, 0.07, 0.93)
			iconWidget:SetImageSize(20, 20)
			iconWidget:SetRelativeWidth(0.05)
			customDropdown:SetRelativeWidth(0.88)
			return iconWidget, customDropdown
		else
			customDropdown:SetFullWidth(true)
			return customDropdown
		end
	end

	local check = AceGUI:Create("CheckBox")
	check:SetLabel(alternativeName and L.alternativeName:format(name, alternativeName) or name)
	check:SetTriState(true)
	check:SetRelativeWidth(0.85)
	check:SetUserData("key", dbKey)
	check:SetUserData("module", module)
	check:SetUserData("option", bossOption)
	check:SetUserData("scrollFrame", scrollFrame)
	check:SetDescription(desc)
	check:SetCallback("OnValueChanged", masterOptionToggled)
	check.frame:SetHitRectInsets(0, 250, 0, 0) -- Reduce checkbox "hit" area
	check:SetCallback("OnRelease", function(widget) widget.frame:SetHitRectInsets(0, 0, 0, 0) end) -- Reset hit area to default
	check:SetValue(getMasterOption(check))
	check.text:SetTextColor(1, 0.82, 0) -- After :SetValue so it's not overwritten
	if icon then check:SetImage(icon, 0.07, 0.93, 0.07, 0.93) end

	local spellId = nil
	if type(dbKey) == "number" then
		if dbKey < 0 then
			-- the "why did you use an ej id instead of the spell directly" check
			-- headers and other non-spell entries don't load async
			local info = C_EncounterJournal_GetSectionInfo(-dbKey)
			if info.spellID > 0 then
				spellId = info.spellID
			end
		else
			spellId = dbKey
		end
	else
		local moduleLocale = module:GetLocale(true)
		local title, description = moduleLocale[dbKey], moduleLocale[dbKey .. "_desc"]
		if type(title) == "number" and not description then
			spellId = title
		elseif type(description) == "number" then
			spellId = description
		end
	end
	if spellId then
		visibleSpellDescriptionWidgets[check] = spellId
	end

	if type(dbKey) == "string" and dbKey:find("^custom_") then
		return check
	end

	local flagIcons = {}
	local showFlags = {
		"TANK_HEALER", "TANK", "HEALER", "DISPEL",
		"EMPHASIZE", "ME_ONLY", "ME_ONLY_EMPHASIZE", "COUNTDOWN", "CASTBAR_COUNTDOWN", "FLASH", "ICON", "SAY", "SAY_COUNTDOWN",
		"PROXIMITY", "INFOBOX", "ALTPOWER", "NAMEPLATE", "PRIVATE",
	}
	for i = 1, #showFlags do
		local key = showFlags[i]
		if hasOptionFlag(dbKey, module, key) then
			local iconWidget = AceGUI:Create("Icon")
			iconWidget:SetWidth(16)
			iconWidget:SetImageSize(16, 16)
			iconWidget:SetUserData("tooltipText", L[key])
			iconWidget:SetCallback("OnEnter", flagOnEnter)
			iconWidget:SetCallback("OnLeave", bwTooltip_Hide)

			if key == "TANK_HEALER" then
				-- add both "TANK" and "HEALER" icons
				local icon1 = AceGUI:Create("Icon")
				icon1:SetWidth(16)
				icon1:SetImage(module:GetMenuIcon("TANK"))
				icon1:SetImageSize(16, 16)
				icon1:SetUserData("tooltipText", L[key])
				icon1:SetCallback("OnEnter", flagOnEnter)
				icon1:SetCallback("OnLeave", bwTooltip_Hide)
				icon1.frame:SetParent(check.frame)
				icon1.frame:Show()
				flagIcons[#flagIcons+1] = icon1
				-- first icon, don't bother with SetPoint

				iconWidget:SetImage(module:GetMenuIcon("HEALER"))
			else
				iconWidget:SetImage(module:GetMenuIcon(key))
			end

			iconWidget.frame:SetParent(check.frame)
			iconWidget.frame:Show()

			flagIcons[#flagIcons+1] = iconWidget
			if #flagIcons > 1 then
				iconWidget:SetPoint("LEFT", flagIcons[#flagIcons-1].frame, "RIGHT", 1, 0)
			end
		end
	end

	if #flagIcons > 0 then
		-- flagIcons[1]:SetPoint("LEFT", check.text, "RIGHT", -(#flagIcons * (16+1)) - 30, 0)
		flagIcons[1]:SetPoint("LEFT", check.text, "LEFT", check.text:GetStringWidth() + 5, 0)

		-- need to clean these up since they are not added to a container
		check:SetUserData("icons", flagIcons)
		check:SetCallback("OnRelease", function(widget)
			for _, iconWidget in next, widget:GetUserData("icons") do
				iconWidget:Release()
			end
			widget.frame:SetHitRectInsets(0, 0, 0, 0) -- Reset hit area to default, set this again as it will overwrite the OnRelease above
		end)
	end

	local button = AceGUI:Create("Button")
	button:SetText(">>")
	button:SetRelativeWidth(0.15)
	button:SetUserData("scrollFrame", scrollFrame)
	button:SetUserData("dropdown", dropdown)
	button:SetUserData("module", module)
	button:SetUserData("bossOption", bossOption)
	button:SetCallback("OnClick", buttonClicked)

	return check, button
end

local listAbilitiesInChat
do
	local SendChatMessage = loader.SendChatMessage
	local function output(channel, ...)
		if channel then
			SendChatMessage(strjoin(" ", ...), channel)
		else
			print(...)
		end
	end

	local function printList(channel, header, list)
		if #list == 0 then return end
		if header then
			output(channel, header, unpack(list))
		else
			output(channel, unpack(list))
		end
	end

	function listAbilitiesInChat(widget)
		local module = widget:GetUserData("module")
		local channel = IsInGroup(2) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup() and "PARTY"
		local abilities = {}
		local header = nil
		output(channel, "BigWigs: ", module.displayName or module.moduleName or module.name)
		local currentSize = 0
		for i, option in next, module.toggleOptions do
			local o = type(option) == "table" and option[1] or option

			if module.optionHeaders and module.optionHeaders[o] then
				-- print what we have so far
				printList(channel, header, abilities)
				abilities = {}
				header = module.optionHeaders[o]
				currentSize = #header
			end

			local link
			if type(o) == "number" then
				if o > 0 then
					local spellLink = loader.GetSpellLink(o)
					if type(spellLink) == "string" and spellLink:find("Hspell", nil, true) then
						link = spellLink -- Use Blizz link if valid...
					else -- ...or make our own
						local spellName = loader.GetSpellName(o)
						link = ("\124cff71d5ff\124Hspell:%d:0\124h[%s]\124h\124r"):format(o, spellName)
						--BigWigs:Error(("Failed to fetch the link for spell id %d, tell the authors."):format(o))
					end
				else
					local tbl = C_EncounterJournal_GetSectionInfo(-o)
					if not tbl or not tbl.link then
						BigWigs:Error(("Failed to fetch the link for journal id (-)%d, tell the authors."):format(-o))
					else
						link = tbl.link
					end
				end
			elseif type(o) == "string" then -- Attempt to build links for strings that are just basic spell renaming
				local moduleLocale = module:GetLocale()
				if moduleLocale then
					local name, desc, icon = moduleLocale[o], moduleLocale[o.."_desc"], moduleLocale[o.."_icon"]
					if name and type(desc) == "number" and desc == icon then
						if desc > 0 then
							local spellName = loader.GetSpellName(desc)
							link = ("\124cff71d5ff\124Hspell:%d:0\124h[%s]\124h\124r"):format(desc, spellName)
						end
					end
				end
			end

			if link then
				if currentSize + #link + 1 > 255 then
					printList(channel, header, abilities)
					abilities = {}
					currentSize = 0
				end
				abilities[#abilities + 1] = link
				currentSize = currentSize + #link + 1
			end
		end
		printList(channel, header, abilities)
	end
end

local function SecondsToTime(time)
	local m = math.floor(time/60)
	local s = time % 60
	return ("%d:%02d"):format(m, s)
end

local function privateAuraOnEnter(widget)
	bwTooltip:SetOwner(widget.frame, "ANCHOR_RIGHT")
	bwTooltip:SetSpellByID(widget:GetUserData("spellId"))
	bwTooltip:Show()
end

local function privateAuraDropdownValueChanged(widget, _, value)
	local key = widget:GetUserData("key")
	local default = widget:GetUserData("default")
	local module = widget:GetUserData("module")
	local soundList = LibStub("LibSharedMedia-3.0"):List("sound")
	value = soundList[value]
	if value == default then
		value = nil
	end

	local sDB = soundModule.db.profile["privateaura"]
	if not sDB[module.name] then
		sDB[module.name] = {}
	end
	sDB[module.name][key] = value
end

local populatePrivateAuraOptions
local function privateAuraResetOnClick(widget)
	local sDB = soundModule.db.profile["privateaura"]
	for module, paOptions in next, widget:GetUserData("privateAuraSoundOptions") do
		sDB[module.name] = nil
	end
	populatePrivateAuraOptions(widget:GetUserData("scrollFrame"))
end

function populatePrivateAuraOptions(widget)
	local scrollFrame = widget:GetUserData("parent")
	scrollFrame:ReleaseChildren()
	scrollFrame:PauseLayout()

	local text = AceGUI:Create("Label")
	text:SetText(L.privateAuraSounds_desc)
	text:SetColor(1, 0.75, 0.79)
	text:SetImage("Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Private")
	text:SetFullWidth(true)
	text:SetHeight(30)
	scrollFrame:AddChild(text)

	local privateAuraSoundOptions = widget:GetUserData("privateAuraSoundOptions")
	local soundList = LibStub("LibSharedMedia-3.0"):List("sound")
	local defaultSound = soundModule:GetDefaultSound("privateaura")
	local sDB = soundModule.db.profile["privateaura"]
	-- preserve module order
	for _, module in ipairs(widget:GetUserData("moduleList")) do
		local paOptions = privateAuraSoundOptions[module]
		if paOptions then
			if module.SetupOptions then module:SetupOptions() end -- init the db

			local header = AceGUI:Create("Heading")
			header:SetText(module.displayName)
			header:SetFullWidth(true)
			scrollFrame:AddChild(header)
			for _, option in ipairs(paOptions) do
				local spellId = option[1]
				local key = spellId
				local id = option.tooltip or spellId

				local name = loader.GetSpellName(id)
				local texture = loader.GetSpellTexture(id)

				local icon = AceGUI:Create("Icon")
				icon:SetImage(texture, 0.07, 0.93, 0.07, 0.93)
				icon:SetImageSize(40, 40)
				icon:SetRelativeWidth(0.1)
				icon:SetUserData("spellId", id)
				icon:SetUserData("updateTooltip", true)
				icon:SetCallback("OnEnter", privateAuraOnEnter)
				icon:SetCallback("OnLeave", bwTooltip_Hide)

				local dropdown = AceGUI:Create("SharedDropdown")
				if option.mythic then
					dropdown:SetLabel(name .. "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Mythic:20|t")
				else
					dropdown:SetLabel(name)
				end
				dropdown:SetList(soundList, nil, "DDI-Sound")
				dropdown:SetRelativeWidth(0.88)
				dropdown:SetUserData("key", key)
				dropdown:SetUserData("default", defaultSound)
				dropdown:SetUserData("module", module)
				dropdown:SetCallback("OnValueChanged", privateAuraDropdownValueChanged)
				local value = sDB[module.name] and sDB[module.name][key] or defaultSound
				for i, v in next, soundList do
					if v == value then
						dropdown:SetValue(i)
						break
					end
				end

				scrollFrame:AddChildren(icon, dropdown)
			end
		end
	end

	local reset = AceGUI:Create("Button")
	reset:SetFullWidth(true)
	reset:SetText(L.reset)
	reset:SetUserData("label", L.reset)
	reset:SetUserData("desc", L.resetSoundDesc)
	reset:SetUserData("scrollFrame", widget)
	reset:SetUserData("privateAuraSoundOptions", privateAuraSoundOptions)
	reset:SetCallback("OnEnter", slaveOptionMouseOver)
	reset:SetCallback("OnLeave", bwTooltip_Hide)
	reset:SetCallback("OnClick", privateAuraResetOnClick)
	scrollFrame:AddChild(reset)

	scrollFrame:ResumeLayout()
	scrollFrame:PerformLayout()
end

local function statsDefeatLabelOnEnter(self)
	bwTooltip:SetOwner(self.frame, "ANCHOR_TOP")
	bwTooltip:AddLine(L.defeat_desc, 1, 1, 1)
	bwTooltip:Show()
end

local function statsVictoryLabelOnEnter(self)
	bwTooltip:SetOwner(self.frame, "ANCHOR_TOP")
	bwTooltip:AddLine(L.victory_desc, 1, 1, 1)
	bwTooltip:Show()
end

local function statsFastestLabelOnEnter(self)
	bwTooltip:SetOwner(self.frame, "ANCHOR_TOP")
	bwTooltip:AddLine(L.fastest_desc, 1, 1, 1)
	bwTooltip:Show()
end

local function statsFirstLabelOnEnter(self)
	bwTooltip:SetOwner(self.frame, "ANCHOR_TOP")
	bwTooltip:AddLine(L.first_desc, 1, 1, 1)
	bwTooltip:Show()
end

local function toggleOptionsTabSelected(widget, callback, tab)
	widget:PauseLayout()
	widget:ReleaseChildren()

	local module = widget:GetUserData("module")
	local scrollFrame = widget:GetUserData("scrollFrame")
	local dropdown = widget:GetUserData("dropdown")
	local tabOptions = widget:GetUserData("tabOptions")
	for i, option in next, tabOptions[tab] do
		local o = option
		if type(o) == "table" then o = option[1] end
		if module.optionHeaders and module.optionHeaders[o] then
			local header = AceGUI:Create("Heading")
			header:SetText(module.optionHeaders[o])
			header:SetFullWidth(true)
			widget:AddChild(header)
		end
		widget:AddChildren(getDefaultToggleOption(scrollFrame, dropdown, module, option))
	end

	-- Store last active tab
	lastOptionsTab = tab

	widget:ResumeLayout()
	scrollFrame:PerformLayout()
	widget:PerformLayout()
end

local function populateToggleOptions(widget, module)
	visibleSpellDescriptionWidgets = {}
	local scrollFrame = widget:GetUserData("parent")
	scrollFrame:ReleaseChildren()
	scrollFrame:PauseLayout()

	-- Add a small text label to the top right displaying the boss encounter ID
	local encounterID, multiple = module:GetEncounterID()
	if encounterID then
		local idLabel = AceGUI:Create("Label")
		idLabel.label:SetFormattedText(L.optionsKey, multiple and module:TableToString({module:GetEncounterID()}) or encounterID)
		idLabel:SetColor(0.65, 0.65, 0.65)
		idLabel:SetFullWidth(true)
		idLabel.label:SetJustifyH("RIGHT")
		scrollFrame:AddChild(idLabel)
	end

	local sDB = BigWigsStatsDB
	local journalID = module:GetJournalID()
	if not journalID and module:GetAllowWin() and encounterID then
		journalID = -(encounterID) -- Fallback to show stats for modules with no journal ID, but set to allow win
	end
	local instanceID = module:GetZoneID()
	if journalID and instanceID and instanceID > 0 and sDB and sDB[instanceID] and sDB[instanceID][journalID] then
		sDB = sDB[instanceID][journalID]

		if next(sDB) then -- Create statistics table
			local statGroup = AceGUI:Create("InlineGroup")
			statGroup:SetTitle(L.statistics)
			statGroup:SetLayout("Flow")
			statGroup:SetFullWidth(true)
			scrollFrame:AddChild(statGroup)

			local emptyFirstColumnLabel = AceGUI:Create("Label")
			emptyFirstColumnLabel:SetWidth(110)
			emptyFirstColumnLabel:SetText("")
			statGroup:AddChild(emptyFirstColumnLabel)

			local defeatColumnLabel = AceGUI:Create("InteractiveLabel")
			defeatColumnLabel:SetWidth(83)
			defeatColumnLabel:SetText(L.defeat)
			defeatColumnLabel:SetCallback("OnEnter", statsDefeatLabelOnEnter)
			defeatColumnLabel:SetCallback("OnLeave", bwTooltip_Hide)
			statGroup:AddChild(defeatColumnLabel)

			local victoryColumnLabel = AceGUI:Create("InteractiveLabel")
			victoryColumnLabel:SetWidth(83)
			victoryColumnLabel:SetText(L.victory)
			victoryColumnLabel:SetCallback("OnEnter", statsVictoryLabelOnEnter)
			victoryColumnLabel:SetCallback("OnLeave", bwTooltip_Hide)
			statGroup:AddChild(victoryColumnLabel)

			local fastestColumnLabel = AceGUI:Create("InteractiveLabel")
			fastestColumnLabel:SetWidth(130)
			fastestColumnLabel:SetText(L.fastest)
			fastestColumnLabel:SetCallback("OnEnter", statsFastestLabelOnEnter)
			fastestColumnLabel:SetCallback("OnLeave", bwTooltip_Hide)
			statGroup:AddChild(fastestColumnLabel)

			local firstColumnLabel = AceGUI:Create("InteractiveLabel")
			firstColumnLabel:SetWidth(140)
			firstColumnLabel:SetText(L.first)
			firstColumnLabel:SetCallback("OnEnter", statsFirstLabelOnEnter)
			firstColumnLabel:SetCallback("OnLeave", bwTooltip_Hide)
			statGroup:AddChild(firstColumnLabel)

			-- Headers
			local displayOrder = {
				"story", "timewalk", "LFR", "normal", "heroic", "mythic",
				"N10", "N25", "H10", "H25",
				"SOD", "level1", "level2", "level3", "hardcore",
				"solotier8", "solotier11",
			}
			for diff, tbl in next, sDB do -- Unknown Stats
				local found = false
				for i = 1, #displayOrder do
					if displayOrder[i] == diff then
						found = true
						break
					end
				end
				if not found then
					local difficultyText = AceGUI:Create("Label")
					difficultyText:SetWidth(110)
					difficultyText:SetText(L.unknown)
					statGroup:AddChild(difficultyText)

					local defeatsLabel = AceGUI:Create("Label")
					defeatsLabel:SetWidth(83)
					defeatsLabel:SetText(tbl.wipes or (not tbl.kills and "-" or "0"))
					statGroup:AddChild(defeatsLabel)

					local victoriesLabel = AceGUI:Create("Label")
					victoriesLabel:SetWidth(83)
					victoriesLabel:SetText(tbl.kills or "-")
					statGroup:AddChild(victoriesLabel)

					local fastestVictoryLabel = AceGUI:Create("Label")
					fastestVictoryLabel:SetWidth(130)
					local value = tbl.best and SecondsToTime(tbl.best)
					local bestDate = tbl.bestDate
					if not value then
						fastestVictoryLabel:SetText("-")
					elseif value and bestDate then
						fastestVictoryLabel:SetFormattedText("%s (%s)", value, bestDate)
					elseif value then
						fastestVictoryLabel:SetText(value)
					end
					statGroup:AddChild(fastestVictoryLabel)

					local firstKillDataLabel = AceGUI:Create("Label")
					firstKillDataLabel:SetWidth(140)
					if not tbl.fkDate then
						firstKillDataLabel:SetText("-")
					else
						local text = table.concat({tbl.fkWipes or "0", SecondsToTime(tbl.fkDuration), tbl.fkDate}, " - ")
						firstKillDataLabel:SetText(text)
					end
					statGroup:AddChild(firstKillDataLabel)
				end
			end

			for i = 1, #displayOrder do -- Known Stats
				local diff = displayOrder[i]
				local tbl = sDB[diff]
				if tbl then
					local difficultyText = AceGUI:Create("Label")
					difficultyText:SetWidth(110)
					difficultyText:SetText(L[diff] or "?")
					statGroup:AddChild(difficultyText)

					local defeatsLabel = AceGUI:Create("Label")
					defeatsLabel:SetWidth(83)
					defeatsLabel:SetText(tbl.wipes or (not tbl.kills and "-" or "0"))
					statGroup:AddChild(defeatsLabel)

					local victoriesLabel = AceGUI:Create("Label")
					victoriesLabel:SetWidth(83)
					victoriesLabel:SetText(tbl.kills or "-")
					statGroup:AddChild(victoriesLabel)

					local fastestVictoryLabel = AceGUI:Create("Label")
					fastestVictoryLabel:SetWidth(130)
					local value = tbl.best and SecondsToTime(tbl.best)
					local bestDate = tbl.bestDate
					if not value then
						fastestVictoryLabel:SetText("-")
					elseif value and bestDate then
						fastestVictoryLabel:SetText(("%s (%s)"):format(value, bestDate))
					elseif value then
						fastestVictoryLabel:SetText(value)
					end
					statGroup:AddChild(fastestVictoryLabel)

					local firstKillDataLabel = AceGUI:Create("Label")
					firstKillDataLabel:SetWidth(140)
					if not tbl.fkDate then
						firstKillDataLabel:SetText("-")
					else
						local text = table.concat({tbl.fkWipes or "0", SecondsToTime(tbl.fkDuration), tbl.fkDate}, " - ")
						firstKillDataLabel:SetText(text)
					end
					statGroup:AddChild(firstKillDataLabel)
				end
			end
		end -- End statistics table
	end

	if module.SetupOptions then module:SetupOptions() end

	local tabs = {}
	if module.optionHeaders then
		for _, optionHeader in next, module.optionHeaders do
			if type(optionHeader) == "table" and optionHeader.tabName then
				table.insert(tabs, optionHeader)
			end
		end
	end

	if #tabs > 0 then -- tabs!
		local generalTabExists = nil
		local tabbedOptions = {}
		local tabInfo, tabOptions  = {}, {}
		for _, tab in next, tabs do
			local text = tab.tabName
			if text == "general" or text == CL.general then
				generalTabExists = text
			end
			local tabData = tab[1]
			table.insert(tabInfo, { text = text, value = text })
			tabOptions[text] = tabData
			for _, option in next, tabData do
				tabbedOptions[option] = true
			end
		end

		for _, option in next, module.toggleOptions do
			local o = option
			if type(o) == "table" then o = option[1] end
			if not tabbedOptions[o] then -- Any options that are not assigned will go to the general tab
				if not generalTabExists then
					local value = "general"
					table.insert(tabInfo, 1, { text = CL.general, value = value })
					generalTabExists = value
				end
				tabOptions[generalTabExists] = tabOptions[generalTabExists] or {}
				table.insert(tabOptions[generalTabExists], option)
			end
		end

		local tabsWidget = AceGUI:Create("TabGroup")
		tabsWidget:SetLayout("Flow")
		tabsWidget:SetTabs(tabInfo)
		tabsWidget:SetFullWidth(true)
		tabsWidget:SetCallback("OnGroupSelected", toggleOptionsTabSelected)
		tabsWidget:SetUserData("module", module)
		tabsWidget:SetUserData("scrollFrame", scrollFrame)
		tabsWidget:SetUserData("dropdown", widget)
		tabsWidget:SetUserData("tabOptions", tabOptions)
		tabsWidget:SelectTab(lastOptionsTab and lastOptionsTab or tabInfo[1].value)

		scrollFrame:AddChild(tabsWidget)
	else -- no tabs
		for i, option in next, module.toggleOptions do
			local o = option
			if type(o) == "table" then o = option[1] end
			if module.optionHeaders and module.optionHeaders[o] then
				local header = AceGUI:Create("Heading")
				header:SetText(module.optionHeaders[o])
				header:SetFullWidth(true)
				scrollFrame:AddChild(header)
			end
			scrollFrame:AddChildren(getDefaultToggleOption(scrollFrame, widget, module, option))
		end
	end

	local list = AceGUI:Create("Button")
	list:SetFullWidth(true)
	list:SetText(L.listAbilities)
	list:SetUserData("module", module)
	list:SetCallback("OnClick", listAbilitiesInChat)
	scrollFrame:AddChild(list)

	scrollFrame:ResumeLayout()
	scrollFrame:PerformLayout()
end

function showToggleOptions(widget, event, group, noScrollReset)
	widget:SetUserData("bossIndex", group)
	-- reset scroll bar if not hitting the back button
	if not noScrollReset then
		toggleOptionsStatusTable.restore_offset = nil
		toggleOptionsStatusTable.restore_scrollvalue = nil
		lastOptionsTab = nil
	end
	toggleOptionsStatusTable.offset = toggleOptionsStatusTable.restore_offset
	toggleOptionsStatusTable.scrollvalue = toggleOptionsStatusTable.restore_scrollvalue

	if group == "Private Aura Sounds" then
		populatePrivateAuraOptions(widget)
	else
		populateToggleOptions(widget, BigWigs:GetBossModule(group, true))
	end
end

local function onZoneShow(treeWidget, instanceIdOrMapId)
	-- Make sure all the bosses for this zone are loaded.
	loader:LoadZone(instanceIdOrMapId)

	-- Grab the module list from this zone
	local moduleList = loader:GetZoneMenus()[instanceIdOrMapId]
	if type(moduleList) ~= "table" then return end -- No modules registered

	local zoneList, zoneSort, privateAuraSoundOptions = {}, {}, nil
	do
		for i = 1, #moduleList do
			local module = moduleList[i]
			zoneList[module.moduleName] = module.displayName
			zoneSort[i] = module.moduleName
			if module.privateAuraSoundOptions then
				if not privateAuraSoundOptions then privateAuraSoundOptions = {} end
				privateAuraSoundOptions[module] = module.privateAuraSoundOptions
			end
		end

		-- Add the private aura plugin module
		if privateAuraSoundOptions then
			local moduleName = "Private Aura Sounds"
			zoneList[moduleName] = ("|cffffbfc9%s|r"):format(L.privateAuraSounds)
			zoneSort[#zoneSort+1] = moduleName
		end
	end

	local outerContainer = AceGUI:Create("SimpleGroup")
	outerContainer:PauseLayout() -- Stop drawing (improves performance) until we've added everything
	outerContainer:SetLayout("Fill")
	outerContainer:SetFullWidth(true)
	treeWidget:AddChild(outerContainer)

	local innerContainer = AceGUI:Create("DropdownGroup")
	innerContainer:SetTitle(L.selectEncounter)
	innerContainer:SetLayout("Flow")
	innerContainer:SetCallback("OnGroupSelected", showToggleOptions)
	innerContainer:SetUserData("zone", instanceIdOrMapId)
	innerContainer:SetUserData("moduleList", moduleList)
	innerContainer:SetUserData("privateAuraSoundOptions", privateAuraSoundOptions)
	innerContainer:SetGroupList(zoneList, zoneSort)

	-- scroll is where we actually put stuff in case things
	-- overflow vertically
	local scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scroll:SetFullWidth(true)
	scroll:SetFullHeight(true)
	scroll:SetStatusTable(toggleOptionsStatusTable)
	innerContainer:SetUserData("parent", scroll)
	innerContainer:AddChild(scroll)

	outerContainer:AddChild(innerContainer)

	outerContainer:ResumeLayout()
	outerContainer:PerformLayout() -- Everything added, gogo

	-- Find the first enabled module and select that in the dropdown if possible.
	local index = 1
	for i = 1, #zoneSort do
		local name = zoneSort[i]
		local m = BigWigs:GetBossModule(name, true)
		if m and m:IsEnabled() and m:GetJournalID() then
			index = i
			break
		end
	end
	innerContainer:SetGroup(zoneSort[index])
	innerContainer:DoLayout() -- One last refresh to adjust height
end

do
	local expansionHeader
	if loader.isVanilla then
		expansionHeader = {
			"Classic",
		}
	elseif loader.isTBC then
		expansionHeader = {
			"Classic",
			"BurningCrusade",
		}
	elseif loader.isWrath then
		expansionHeader = {
			"Classic",
			"BurningCrusade",
			"WrathOfTheLichKing",
		}
	elseif loader.isCata then
		expansionHeader = {
			"Classic",
			"BurningCrusade",
			"WrathOfTheLichKing",
			"Cataclysm",
		}
	elseif loader.isMists then
		expansionHeader = {
			"Classic",
			"BurningCrusade",
			"WrathOfTheLichKing",
			"Cataclysm",
			"MistsOfPandaria",
		}
	--elseif loader.isBeta then
	--	expansionHeader = {
	--		"Classic",
	--		"BurningCrusade",
	--		"WrathOfTheLichKing",
	--		"Cataclysm",
	--		"MistsOfPandaria",
	--		"WarlordsOfDraenor",
	--		"Legion",
	--		"BattleForAzeroth",
	--		"Shadowlands",
	--		"Dragonflight",
	--		"TheWarWithin",
	--	}
	else
		expansionHeader = {
			"Classic",
			"BurningCrusade",
			"WrathOfTheLichKing",
			"Cataclysm",
			"MistsOfPandaria",
			"WarlordsOfDraenor",
			"Legion",
			"BattleForAzeroth",
			"Shadowlands",
			"Dragonflight",
			"TheWarWithin",
		}
	end

	local statusTable = {}
	local GetBestMapForUnit = loader.GetBestMapForUnit
	local GetMapInfo = loader.GetMapInfo
	local remappedZones = loader.remappedZones

	local function onTreeGroupSelected(widget, event, value)
		visibleSpellDescriptionWidgets = {}
		widget:ReleaseChildren()
		local instanceIdOrMapId = value:match("\001(-?%d+)$")
		local bigwigsContent = value:match("(BigWigs_%a+)$")
		if instanceIdOrMapId then
			onZoneShow(widget, tonumber(instanceIdOrMapId))
		elseif bigwigsContent and not loader.currentExpansion.bigWigsBundled[value] then -- Any BigWigs content except bundled expansion headers
			local addonState = loader:GetAddOnState(bigwigsContent)
			local disabled = not loader:IsAddOnEnabled(bigwigsContent)
			local string = addonState == "MISSING" and L.missingAddOnPopup or disabled and L.disabledAddOn
			if string then
				local container = AceGUI:Create("SimpleGroup")
				container:SetFullWidth(true)
				widget:AddChild(container)

				local missing = AceGUI:Create("Label")
				missing:SetText(string:format(bigwigsContent))
				missing:SetFontObject(GameFontHighlight)
				missing:SetFullWidth(true)
				container:AddChild(missing)

				if disabled then
					local reload = AceGUI:Create("Button")
					reload:SetText(L.enable)
					reload:SetAutoWidth(true)
					reload:SetUserData("addonName", bigwigsContent)
					reload:SetCallback("OnClick", function(reloadWidget)
						loader.EnableAddOn(reloadWidget:GetUserData("addonName"))
						C_UI.Reload()
					end)
					container:AddChild(reload)
				end
			end
		elseif value:match("^LittleWigs_") then -- All LittleWigs content addons, all come from 1 zip
			if loader.currentExpansion.littleWigsBundled[value] then -- bundled content is included in LittleWigs
				value = "LittleWigs"
			end
			local addonState = loader:GetAddOnState(value)
			local disabled = not loader:IsAddOnEnabled(value)
			local string = addonState == "MISSING" and L.missingAddOnPopup or disabled and L.disabledAddOn
			if not loader.usingLittleWigsRepo and string then
				local container = AceGUI:Create("SimpleGroup")
				container:SetFullWidth(true)
				widget:AddChild(container)

				local missing = AceGUI:Create("Label")
				missing:SetText(string:format(value))
				missing:SetFontObject(GameFontHighlight)
				missing:SetFullWidth(true)
				container:AddChild(missing)

				if disabled then
					local reload = AceGUI:Create("Button")
					reload:SetText(L.enable)
					reload:SetAutoWidth(true)
					reload:SetUserData("addonName", value)
					reload:SetCallback("OnClick", function(reloadWidget)
						loader.EnableAddOn(reloadWidget:GetUserData("addonName"))
						C_UI.Reload()
					end)
					container:AddChild(reload)
				end
			end
		else
			statusTable.groups[value] = true
			widget:RefreshTree()
		end
	end

	local function addModuleToOptions(zoneAddon, treeTbl, addonNameToHeader, value, zoneName)
		local parent = zoneAddon and addonNameToHeader[zoneAddon] -- Get expansion number for this zone
		local treeParent = treeTbl[parent] -- Grab appropriate expansion name
		if treeParent and treeParent.enabled then -- third-party plugins can add empty zones if you don't have the expansion addon enabled
			if not treeParent.children then treeParent.children = {} end -- Create sub menu table
			tinsert(treeParent.children, { -- Add new instance/zone sub menu
				value = value,
				text = zoneName,
			})
		end
	end

	local currentlyOpenContainer
	local function onTabGroupSelected(widget, event, value)
		visibleSpellDescriptionWidgets = {}
		widget:ReleaseChildren()

		if value == "options" then
			configFrame:SetTitle("BigWigs")
			configFrame:SetStatusText(" "..loader:GetReleaseString())
			-- Embed the AceConfig options in our AceGUI frame
			local container = AceGUI:Create("SimpleGroup")
			container.type = "BigWigsOptions" -- We want ACD to create a ScrollFrame, so we change the type to bypass it's group control check
			container:SetFullHeight(true)
			container:SetFullWidth(true)

			-- Have to use :Open instead of just :FeedGroup because some widget types (range, color) call :Open to refresh on change
			currentlyOpenContainer = container
			acd:Open("BigWigs", container)

			widget:AddChild(container)
		elseif value == "tools" then
			configFrame:SetTitle("BigWigs")
			configFrame:SetStatusText(" "..loader:GetReleaseString())
			-- Embed the AceConfig options in our AceGUI frame
			local container = AceGUI:Create("SimpleGroup")
			container.type = "BigWigsOptions" -- We want ACD to create a ScrollFrame, so we change the type to bypass it's group control check
			container:SetFullHeight(true)
			container:SetFullWidth(true)

			-- Have to use :Open instead of just :FeedGroup because some widget types (range, color) call :Open to refresh on change
			currentlyOpenContainer = container
			acd:Open("BigWigsTools", container)

			widget:AddChild(container)
		else
			currentlyOpenContainer = nil
			local treeTbl = {}
			local addonNameToHeader = {}
			local defaultHeader
			if value == "bigwigs" then
				configFrame:SetTitle("BigWigs")
				configFrame:SetStatusText(" "..loader:GetReleaseString())
				defaultHeader = loader.currentExpansion.name
				for i = 1, #expansionHeader do
					local addonName = "BigWigs_" .. expansionHeader[i]
					treeTbl[i] = {
						text = L.expansionNames[i],
						value = addonName,
						enabled = true,
					}
					addonNameToHeader[addonName] = i
				end
			elseif value == "littlewigs" then
				configFrame:SetTitle("LittleWigs")
				configFrame:SetStatusText(" "..loader.littlewigsVersionString)
				defaultHeader = loader.currentExpansion.littlewigsDefault
				-- add an entry for each expansion
				for i = 1, #expansionHeader do
					local addonName = "LittleWigs_" .. expansionHeader[i]
					treeTbl[i] = {
						text = L.expansionNames[i],
						value = addonName,
						enabled = true,
					}
					addonNameToHeader[addonName] = i
				end
				-- add any extra LittleWigs menus
				if loader.currentExpansion.littleWigsExtras then
					for i = 1, #loader.currentExpansion.littleWigsExtras do
						local addonName = loader.currentExpansion.littleWigsExtras[i]
						treeTbl[#treeTbl + 1] = {
							text = L.littleWigsExtras[addonName],
							value = addonName,
							enabled = true,
						}
						addonNameToHeader[addonName] = #treeTbl
					end
				end
			end

			do
				local zoneToId, alphabeticalZoneList = {}, {}
				for k in next, loader:GetZoneMenus() do
					local zoneName
					if k < 0 then
						local tbl = GetMapInfo(-k)
						if tbl then
							zoneName = tbl.name
						else
							zoneName = tostring(k)
						end
					else
						zoneName = GetRealZoneText(k)
						if zoneName == "" then
							-- if GetRealZoneText returns an empty string it's probably due to having a module enabled for a zone that doesn't exist.
							-- use the zone key as the menu name in that case instead of the empty string.
							zoneName = tostring(k)
						end
					end
					if zoneName then
						if zoneToId[zoneName] then
							zoneName = zoneName .. "1" -- When instances exist more than once (Karazhan)
						end
						zoneToId[zoneName] = k
						alphabeticalZoneList[#alphabeticalZoneList+1] = zoneName
					end
				end

				for k, v in next, loader.currentExpansion.zones do -- Parse current content zones
					local zoneName = GetRealZoneText(k)
					if not zoneToId[zoneName] and not loader.usingBigWigsRepo then -- If we have no registered menus for current content, and not using the Git repo
						alphabeticalZoneList[#alphabeticalZoneList+1] = zoneName -- We want to create sub menus in the GUI for disabled/missing BigWigs current content addons
						zoneToId[zoneName] = {k, v}
					end
				end

				sort(alphabeticalZoneList) -- Make alphabetical
				for i = 1, #alphabeticalZoneList do
					local zoneName = alphabeticalZoneList[i]
					local entry = zoneToId[zoneName]
					local name, id
					if type(entry) == "table" then
						id = entry[1]
						name = entry[2]
					else
						id = entry
					end

					-- add zones to options
					addModuleToOptions(loader.zoneTbl[id], treeTbl, addonNameToHeader, name or id, zoneName)
					if loader.currentExpansion.currentSeason[id] then
						addModuleToOptions(loader.currentExpansion.currentSeason[id], treeTbl, addonNameToHeader, name or id, zoneName)
					end
				end
			end

			local tree = AceGUI:Create("TreeGroup")
			tree:SetFullWidth(true)
			tree:SetFullHeight(true)
			tree:SetStatusTable(statusTable)
			tree:SetTree(treeTbl)
			tree:SetLayout("Fill")
			tree:SetCallback("OnGroupSelected", onTreeGroupSelected)

			-- Do we have content for the zone we're in? Then open straight to that zone.
			local _, instanceType, _, _, _, _, _, id = loader.GetInstanceInfo()
			if remappedZones[id] then
				id = remappedZones[id]
			end
			local zoneAddon = loader.currentExpansion.currentSeason[id] or loader.zoneTbl[id]
			local parent = zoneAddon and addonNameToHeader[zoneAddon]
			if instanceType == "none" then
				local mapId = GetBestMapForUnit("player")
				if mapId then
					id = loader.zoneTblWorld[-mapId]
					parent = zoneAddon and addonNameToHeader[zoneAddon]
				end
			end

			if parent then
				local moduleList = id and loader:GetZoneMenus()[id]
				local current = treeTbl[parent].value
				tree:SelectByValue(moduleList and ("%s\001%d"):format(current, id) or current)
			else
				tree:SelectByValue(defaultHeader)
			end

			widget:AddChild(tree)
		end
	end

	function options:ConfigTableChange(_, appName)
		if (appName == "BigWigs" or appName == "BigWigsTools") and currentlyOpenContainer then
			acd:Open(appName, currentlyOpenContainer)
		end
	end
	acr.RegisterCallback(options, "ConfigTableChange")

	function options:OpenConfig()
		spellDescriptionUpdater:RegisterEvent("SPELL_TEXT_UPDATE")

		local bw = AceGUI:Create("Frame")
		configFrame = bw
		bw:SetTitle("BigWigs")
		bw:SetStatusText(" "..loader:GetReleaseString())
		bw:SetWidth(858)
		bw:SetHeight(660)
		bw:EnableResize(false)
		bw:SetLayout("Flow")
		bw:SetCallback("OnClose", function(widget)
			visibleSpellDescriptionWidgets = {}
			statusTable = {}
			currentlyOpenContainer = nil
			configFrame = nil
			spellDescriptionUpdater:UnregisterEvent("SPELL_TEXT_UPDATE")
			widget:ReleaseChildren()
			AceGUI:Release(widget)
			options:SendMessage("BigWigs_CloseGUI")
		end)

		local tabs = AceGUI:Create("TabGroup")
		tabs:SetLayout("Flow")
		tabs:SetFullWidth(true)
		tabs:SetFullHeight(true)
		tabs:SetTabs({
			{ text = L.options, value = "options" },
			{ text = L.tools, value = "tools" },
			{ text = L.raidBosses, value = "bigwigs" },
			{ text = L.dungeonBosses, value = "littlewigs" },
		})
		tabs:SetCallback("OnGroupSelected", onTabGroupSelected)
		tabs:SelectTab("options")
		bw:AddChild(tabs)

		bw:Show()
		self:SendMessage("BigWigs_OpenGUI")
	end
end

do
	local registered, subPanelRegistry = {}, {}
	function options:BigWigs_PluginOptionsReady(_, pluginName, pluginOptions, subPanelOptions)
		if not registered[pluginName] then
			if type(pluginOptions) == "table" then
				registered[pluginName] = true
				aceConfigTableMainBigWigsTab.args.general.args[pluginName] = pluginOptions
			elseif type(subPanelOptions) == "table" then
				registered[pluginName] = true
				local key = subPanelOptions.key
				local opts = subPanelOptions.options
				if type(opts) == "function" then
					subPanelRegistry[key] = opts
				else
					aceConfigTableMainBigWigsTab.args[key] = opts
				end
			end
		end
	end

	function ConstructMainBigWigsTab()
		for key, optionsTableFunction in next, subPanelRegistry do
			local optionsTable = securecallfunction(optionsTableFunction)
			if type(optionsTable) == "table" and xpcall(acr.ValidateOptionsTable, geterrorhandler(), acr, optionsTable, optionsTable.name) then
				aceConfigTableMainBigWigsTab.args[key] = optionsTable
			end
		end
		for key, optionsTable in next, API.GetPluginOptions() do
			aceConfigTableMainBigWigsTab.args[key] = optionsTable
		end
		return aceConfigTableMainBigWigsTab
	end
end

do
	local popup = CreateFrame("Frame", nil, UIParent)
	popup:Hide()
	popup:SetPoint("CENTER", UIParent, "CENTER")
	popup:SetSize(320, 72)
	popup:EnableMouse(true) -- Do not allow click-through on the frame
	popup:SetFrameStrata("TOOLTIP")
	popup:SetFrameLevel(110) -- Lots of room to draw under it
	popup:SetFixedFrameStrata(true)
	popup:SetFixedFrameLevel(true)

	local border = CreateFrame("Frame", nil, popup, "DialogBorderOpaqueTemplate")
	border:SetAllPoints(popup)

	local textFrame = popup:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	textFrame:SetSize(290, 0)
	textFrame:SetPoint("TOP", 0, -16)

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

	local _, addonTable = ...
	-- DO NOT USE THIS DIRECTLY. This code may not be loaded
	-- Use BigWigsAPI.RegisterProfile(addonName, profileString, optionalCustomProfileName, optionalCallbackFunction)
	function options:SaveImportStringDataFromAddOn(addonName, profileString, optionalCustomProfileName, optionalCallbackFunction)
		if type(addonName) ~= "string" or #addonName < 3 then error("Invalid addon name for profile import.") end
		if type(profileString) ~= "string" or #profileString < 3 then error("Invalid profile string for profile import.") end
		if optionalCustomProfileName and (type(optionalCustomProfileName) ~= "string" or #optionalCustomProfileName < 3) then error("Invalid custom profile name for the string you want to import.") end
		if optionalCallbackFunction and type(optionalCallbackFunction) ~= "function" then error("Invalid custom callback function for the string you want to import.") end
		-- All AceConfigDialog code, go there for original
		popup:Show()
		local profileName = loader.db:GetCurrentProfile()
		if not optionalCustomProfileName or profileName == optionalCustomProfileName then
			optionalCustomProfileName = nil
			textFrame:SetText(L.confirm_import_addon:format(addonName, profileName))
		else
			local profiles = loader.db:GetProfiles()
			local found = false
			for i = 1, #profiles do
				local name = profiles[i]
				if name == optionalCustomProfileName then
					found = true
					break
				end
			end
			if found then
				textFrame:SetText(L.confirm_import_addon_edit_profile:format(addonName, optionalCustomProfileName))
			else
				textFrame:SetText(L.confirm_import_addon_new_profile:format(addonName, optionalCustomProfileName))
			end
		end
		local height = 61 + textFrame:GetHeight()
		popup:SetHeight(height)

		acceptButton:ClearAllPoints()
		acceptButton:SetPoint("BOTTOMRIGHT", popup, "BOTTOM", -6, 16)

		acceptButton:SetScript("OnClick", function()
			popup:Hide()
			acceptButton:SetScript("OnClick", nil)
			cancelButton:SetScript("OnClick", nil)
			if optionalCustomProfileName then
				loader.db:SetProfile(optionalCustomProfileName)
			end
			addonTable.SaveImportStringDataFromAddOn(profileString)
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
	end
end

BigWigsOptions = options -- Set global
