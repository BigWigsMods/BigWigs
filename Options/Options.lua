
local BigWigs = BigWigs
local options = {}

local C = BigWigs.C

local L = BigWigsAPI:GetLocale("BigWigs")

local ldbi = LibStub("LibDBIcon-1.0")
local acr = LibStub("AceConfigRegistry-3.0")
local acd = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local adbo = LibStub("AceDBOptions-3.0")
local lds = LibStub("LibDualSpec-1.0", true)

local loader = BigWigsLoader
local API = BigWigsAPI
options.SendMessage = loader.SendMessage
local UnitName = loader.UnitName

local bwTooltip = CreateFrame("GameTooltip", "BigWigsOptionsTooltip", UIParent, "GameTooltipTemplate")

local colorModule
local soundModule
local configFrame, isPluginOpen

local showToggleOptions, getAdvancedToggleOption = nil, nil
local toggleOptionsStatusTable = {}

local C_EncounterJournal_GetSectionInfo = loader.isClassic and function(key)
	local info = loader.isCata and C_EncounterJournal.GetSectionInfo(key)
	if info then
		-- Cataclysm only has section info for Cataclysm content, return it if found
		return info
	end
	info = BigWigsAPI:GetLocale("BigWigs: Encounter Info")[key]
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

local getOptions
local acOptions = {
	type = "group",
	name = "BigWigs",
	get = function(info)
		return BigWigs.db.profile[info[#info]]
	end,
	set = function(info, value)
		local key = info[#info]
		BigWigs.db.profile[key] = value
		options:SendMessage("BigWigs_CoreOptionToggled", key, value)
	end,
	args = {
		general = {
			order = 20,
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
				anchorsButton = {
					type = "execute",
					name = function()
						if options:InConfigureMode() then
							return L.toggleAnchorsBtnHide
						else
							return L.toggleAnchorsBtnShow
						end
					end,
					desc = function()
						if options:InConfigureMode() then
							return L.toggleAnchorsBtnHide_desc
						else
							return L.toggleAnchorsBtnShow_desc
						end
					end,
					func = function()
						if not BigWigs:IsEnabled() then BigWigs:Enable() end
						if options:InConfigureMode() then
							options:SendMessage("BigWigs_StopConfigureMode")
						else
							options:SendMessage("BigWigs_StartConfigureMode")
						end
					end,
					width = 1.5,
					order = 12.4,
				},
				testButton = {
					type = "execute",
					name = L.testBarsBtn,
					desc = L.testBarsBtn_desc,
					func = function()
						BigWigs:Test()
					end,
					width = 1.5,
					order = 12.5,
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
							ldbi:AddButtonToCompartment("BigWigs", "Interface\\AddOns\\BigWigs\\Media\\Icons\\core-enabled")
						end
					end,
					hidden = loader.isClassic,
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

do
	local addonName = ...
	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	local function Initialize(_, _, addon)
		if addon ~= addonName then return end
		f:UnregisterEvent("ADDON_LOADED")

		acOptions.args.general.args.profileOptions = adbo:GetOptionsTable(BigWigs.db)
		acOptions.args.general.args.profileOptions.order = 100
		acOptions.args.general.args.profileOptions.name = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Profile:20|t " .. acOptions.args.general.args.profileOptions.name
		if lds then
			lds:EnhanceOptions(acOptions.args.general.args.profileOptions, BigWigs.db)
		end

		acr:RegisterOptionsTable("BigWigs", getOptions, true)
		acd:SetDefaultSize("BigWigs", 858, 660)

		acr.RegisterCallback(options, "ConfigTableChange")

		colorModule = BigWigs:GetPlugin("Colors")
		soundModule = BigWigs:GetPlugin("Sounds")
		acr:RegisterOptionsTable("BigWigs: Colors Override", colorModule:SetColorOptions("dummy", "dummy"), true)
		acr:RegisterOptionsTable("BigWigs: Sounds Override", soundModule:SetSoundOptions("dummy", "dummy"), true)

		loader.RegisterMessage(options, "BigWigs_BossModuleRegistered", "Register")
		loader.RegisterMessage(options, "BigWigs_PluginRegistered", "Register")

		for name, module in BigWigs:IterateBossModules() do
			options:Register("BigWigs_BossModuleRegistered", name, module)
		end
		for name, module in BigWigs:IteratePlugins() do
			options:Register("BigWigs_PluginRegistered", name, module)
		end

		loader.RegisterMessage(options, "BigWigs_StartConfigureMode")
		loader.RegisterMessage(options, "BigWigs_StopConfigureMode")

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

do
	local configMode = nil
	function options:InConfigureMode() return configMode end
	function options:BigWigs_StartConfigureMode()
		configMode = true
	end
	function options:BigWigs_StopConfigureMode()
		configMode = nil
	end
end

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
	if type(key) == "string" and key:find("custom_", nil, true) then
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

local function slaveOptionMouseLeave()
	bwTooltip:Hide()
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
	toggle:SetCallback("OnLeave", slaveOptionMouseLeave)
	toggle:SetValue(getSlaveOption(toggle))
	toggle.text:SetTextColor(1, 0.82, 0) -- After :SetValue so it's not overwritten
	return toggle
end

local icons = {
	MESSAGE = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Messages",
	ME_ONLY = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\MeOnly",
	SOUND = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Sounds",
	ICON = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Markers",
	FLASH = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Flash",
	PULSE = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Pulse",
	PROXIMITY = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Proximity",
	ALTPOWER = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\AltPower",
	INFOBOX = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Info",
	COUNTDOWN = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Countdown",
	CASTBAR_COUNTDOWN = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Countdown",
	SAY = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Say",
	SAY_COUNTDOWN = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\SayCountdown",
	VOICE = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Voice",
	BAR = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Bars",
	CASTBAR = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Bars",
	NAMEPLATEBAR = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Bars",
	TANK = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Role_Tank",
	HEALER = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Role_Healer",
	EMPHASIZE = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\EmphasizeMessage",
	ME_ONLY_EMPHASIZE = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\EmphasizeMessageMeOnly",
	DISPEL = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Dispel",
	PRIVATE = "Interface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Private",
}

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

	if bit.band(dbv, C.MESSAGE) == C.MESSAGE then
		-- Emphasize
		advOpts[#advOpts+1] = getSlaveToggle(L.EMPHASIZE, L.EMPHASIZE_desc, dbKey, module, C.EMPHASIZE, check, 0.3, icons.EMPHASIZE)
		advOpts[#advOpts+1] = getSlaveToggle(L.ME_ONLY_EMPHASIZE, L.ME_ONLY_EMPHASIZE_desc, dbKey, module, C.ME_ONLY_EMPHASIZE, check, 0.5, icons.ME_ONLY_EMPHASIZE)
		--

		-- Bar & Countdown
		advOpts[#advOpts+1] = getSlaveToggle(L.BAR, L.BAR_desc, dbKey, module, C.BAR, check, 0.3, icons.BAR)
		advOpts[#advOpts+1] = getSlaveToggle(L.COUNTDOWN, L.COUNTDOWN_desc, dbKey, module, C.COUNTDOWN, check, 0.5, icons.COUNTDOWN)
		--

		-- Cast Bars & Cast Countdowns
		if bit.band(dbv, C.CASTBAR) == C.CASTBAR and hasOptionFlag(dbKey, module, "CASTBAR") then
			advOpts[#advOpts+1] = getSlaveToggle(L.CASTBAR, L.CASTBAR_desc, dbKey, module, C.CASTBAR, check, 0.3, icons.CASTBAR)
			advOpts[#advOpts+1] = getSlaveToggle(L.CASTBAR_COUNTDOWN, L.CASTBAR_COUNTDOWN_desc, dbKey, module, C.CASTBAR_COUNTDOWN, check, 0.5, icons.CASTBAR_COUNTDOWN)
		end
		--

		-- Messages & Sound
		advOpts[#advOpts+1] = getSlaveToggle(L.MESSAGE, L.MESSAGE_desc, dbKey, module, C.MESSAGE, check, 0.3, icons.MESSAGE)
		advOpts[#advOpts+1] = getSlaveToggle(L.ME_ONLY, L.ME_ONLY_desc, dbKey, module, C.ME_ONLY, check, 0.4, icons.ME_ONLY)
		advOpts[#advOpts+1] = getSlaveToggle(L.SOUND, L.SOUND_desc, dbKey, module, C.SOUND, check, 0.3, icons.SOUND)
		--
	end

	if bit.band(dbv, C.NAMEPLATEBAR) == C.NAMEPLATEBAR and hasOptionFlag(dbKey, module, "NAMEPLATEBAR") then
		advOpts[#advOpts+1] = getSlaveToggle(L.NAMEPLATEBAR, L.NAMEPLATEBAR_desc, dbKey, module, C.NAMEPLATEBAR, check, 0.3, icons.NAMEPLATEBAR)
	end

	-- Flash & Pulse
	if bit.band(dbv, C.FLASH) == C.FLASH and hasOptionFlag(dbKey, module, "FLASH") then
		advOpts[#advOpts+1] = getSlaveToggle(L.FLASH, L.FLASH_desc, dbKey, module, C.FLASH, check, 0.3, icons.FLASH)
		advOpts[#advOpts+1] = getSlaveToggle(L.PULSE, L.PULSE_desc, dbKey, module, C.PULSE, check, 0.5, icons.PULSE)
	end
	--

	if bit.band(dbv, C.MESSAGE) == C.MESSAGE then
		if API:HasVoicePack() then
			advOpts[#advOpts+1] = getSlaveToggle(L.VOICE, L.VOICE_desc, dbKey, module, C.VOICE, check, 0.3, icons.VOICE)
		end
	end

	for i, key in next, BigWigs:GetOptions() do
		local flag = C[key]
		if bit.band(dbv, flag) == flag then
			local name, desc = BigWigs:GetOptionDetails(key)
			-- All on by default, check if we should add a GUI widget
			if key == "ICON" or key == "SAY" or key == "SAY_COUNTDOWN" or key == "PROXIMITY" or key == "ALTPOWER" or key == "INFOBOX" then
				if hasOptionFlag(dbKey, module, key) then
					advOpts[#advOpts+1] = getSlaveToggle(name, desc, dbKey, module, flag, check, 0.3, icons[key])
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
		text = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\Menus\\Sliders:20|t ".. L.advanced,
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
			if key == "TANK" then
				roleRestrictionCheckbox = getSlaveToggle(roleName, roleDesc, dbKey, module, flag, check, 0.3, icons.TANK)
			elseif key == "HEALER" then
				roleRestrictionCheckbox = getSlaveToggle(roleName, roleDesc, dbKey, module, flag, check, 0.3, icons.HEALER)
			elseif key == "DISPEL" then
				roleRestrictionCheckbox = getSlaveToggle(roleName, roleDesc, dbKey, module, flag, check, 0.3, icons.DISPEL)
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
		privateAuraText:SetImage(icons.PRIVATE)
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

local function flagOnLeave()
	bwTooltip:Hide()
end

local function getDefaultToggleOption(scrollFrame, dropdown, module, bossOption)
	local dbKey, name, desc, icon, alternativeName = BigWigs:GetBossOptionDetails(module, bossOption)

	-- jesus this is so hacky. should probably be "custom_select_" with values as a
	-- :GetBossOptionDetails return, but this keeps changes to a minimum for now
	if type(dbKey) == "string" and dbKey:find("^custom_off_select_") then
		local L = module:GetLocale()
		local values = { [0] = _G.ADDON_DISABLED }
		local i = 1
		local value = L[dbKey.."_value"..i]
		repeat
			values[i] = value
			i = i + 1
			value = L[dbKey.."_value"..i]
		until not value

		local dropdown = AceGUI:Create("Dropdown")
		if desc then
			-- The label will truncate at ~74 chars, but showing the desc in a tooltip seems awkward
			dropdown:SetLabel(("%s: |cffffffff%s|r"):format(name, desc))
		else
			dropdown:SetLabel(name)
		end
		dropdown:SetMultiselect(false)
		dropdown:SetList(values)
		dropdown:SetFullWidth(true)
		dropdown:SetUserData("key", dbKey)
		dropdown:SetUserData("module", module)
		dropdown:SetCallback("OnValueChanged", function(widget, _, value)
			if value == 0 then value = false end
			local key = widget:GetUserData("key")
			local module = widget:GetUserData("module")
			module.db.profile[key] = value or false
		end)
		dropdown:SetValue(module.db.profile[dbKey] or 0)

		return dropdown
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
		local L = module:GetLocale(true)
		local title, description = L[dbKey], L[dbKey .. "_desc"]
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
		"PROXIMITY", "INFOBOX", "ALTPOWER", "NAMEPLATEBAR", "PRIVATE",
	}
	for i = 1, #showFlags do
		local key = showFlags[i]
		if hasOptionFlag(dbKey, module, key) then
			local icon = AceGUI:Create("Icon")
			icon:SetWidth(16)
			icon:SetImageSize(16, 16)
			icon:SetUserData("tooltipText", L[key])
			icon:SetCallback("OnEnter", flagOnEnter)
			icon:SetCallback("OnLeave", flagOnLeave)

			if key == "TANK_HEALER" then
				-- add both "TANK" and "HEALER" icons
				local icon1 = AceGUI:Create("Icon")
				icon1:SetWidth(16)
				icon1:SetImage(icons.TANK)
				icon1:SetImageSize(16, 16)
				icon1:SetUserData("tooltipText", L[key])
				icon1:SetCallback("OnEnter", flagOnEnter)
				icon1:SetCallback("OnLeave", flagOnLeave)
				icon1.frame:SetParent(check.frame)
				icon1.frame:Show()
				flagIcons[#flagIcons+1] = icon1
				-- first icon, don't bother with SetPoint

				icon:SetImage(icons.HEALER)
			else
				if type(icons[key]) == "string" then
					icon:SetImage(icons[key]) -- custom icon
				else
					icon:SetImage(icons[key], 0.07, 0.93, 0.07, 0.93)
				end
			end

			icon.frame:SetParent(check.frame)
			icon.frame:Show()

			flagIcons[#flagIcons+1] = icon
			if #flagIcons > 1 then
				icon:SetPoint("LEFT", flagIcons[#flagIcons-1].frame, "RIGHT", 1, 0)
			end
		end
	end

	if #flagIcons > 0 then
		-- flagIcons[1]:SetPoint("LEFT", check.text, "RIGHT", -(#flagIcons * (16+1)) - 30, 0)
		flagIcons[1]:SetPoint("LEFT", check.text, "LEFT", check.text:GetStringWidth() + 5, 0)

		-- need to clean these up since they are not added to a container
		check:SetUserData("icons", flagIcons)
		check:SetCallback("OnRelease", function(widget)
			for _, icon in next, widget:GetUserData("icons") do
				icon:Release()
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
				local L = module:GetLocale()
				if L then
					local name, desc, icon = L[o], L[o.."_desc"], L[o.."_icon"]
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
	local m = floor(time/60)
	local s = mod(time, 60)
	return ("%d:%02d"):format(m, s)
end

local function populateToggleOptions(widget, module)
	visibleSpellDescriptionWidgets = {}
	local scrollFrame = widget:GetUserData("parent")
	scrollFrame:ReleaseChildren()
	scrollFrame:PauseLayout()

	local id = module.instanceId

	local sDB = BigWigsStatsDB
	local journalId = module:GetJournalID()
	if journalId and id and id > 0 and BigWigs:GetPlugin("Statistics").db.profile.enabled and sDB and sDB[id] and sDB[id][journalId] then
		sDB = sDB[id][journalId]

		if next(sDB) then -- Create statistics table
			local statGroup = AceGUI:Create("InlineGroup")
			statGroup:SetTitle(L.statistics)
			statGroup:SetLayout("Flow")
			statGroup:SetFullWidth(true)
			scrollFrame:AddChild(statGroup)

			local statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText("")
			statGroup:AddChild(statistics)

			local difficulties = {}

			-- Headers
			local displayOrder = { "LFR", "normal", "heroic", "mythic", "10N", "25N", "10H", "25H" }
			for _, diff in ipairs(displayOrder) do
				if sDB[diff] then
					difficulties[#difficulties+1] = diff
					statistics = AceGUI:Create("Label")
					statistics:SetWidth(100)
					statistics:SetText(L[diff])
					statGroup:AddChild(statistics)
				end
			end

			statistics = AceGUI:Create("Label")
			statistics:SetFullWidth(true)
			statistics:SetText("")
			statGroup:AddChild(statistics)

			-- Wipes
			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(L.wipes)
			statGroup:AddChild(statistics)

			for _, diff in ipairs(difficulties) do
				statistics = AceGUI:Create("Label")
				statistics:SetWidth(100)
				statistics:SetText(sDB[diff] and sDB[diff].wipes or "-")
				statGroup:AddChild(statistics)
			end

			statistics = AceGUI:Create("Label")
			statistics:SetFullWidth(true)
			statistics:SetText("")
			statGroup:AddChild(statistics)

			-- Kills
			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(L.kills)
			statGroup:AddChild(statistics)

			for _, diff in ipairs(difficulties) do
				statistics = AceGUI:Create("Label")
				statistics:SetWidth(100)
				statistics:SetText(sDB[diff] and sDB[diff].kills or "-")
				statGroup:AddChild(statistics)
			end

			statistics = AceGUI:Create("Label")
			statistics:SetFullWidth(true)
			statistics:SetText("")
			statGroup:AddChild(statistics)

			-- Best Time
			statistics = AceGUI:Create("Label")
			statistics:SetWidth(100)
			statistics:SetText(L.best)
			statGroup:AddChild(statistics)

			for _, diff in ipairs(difficulties) do
				statistics = AceGUI:Create("Label")
				statistics:SetWidth(100)
				local value = sDB[diff] and sDB[diff].best and SecondsToTime(sDB[diff].best)
				statistics:SetText(value or "-")
				statGroup:AddChild(statistics)
			end
		end -- End statistics table
	end

	-- Add a small text label to the top right displaying the boss encounter ID
	if module:GetEncounterID() then
		local idLabel = AceGUI:Create("Label")
		idLabel.label:SetFormattedText(L.optionsKey, module:GetEncounterID())
		idLabel:SetColor(0.65, 0.65, 0.65)
		idLabel:SetFullWidth(true)
		idLabel.label:SetJustifyH("RIGHT")
		scrollFrame:AddChild(idLabel)
	end

	if module.SetupOptions then module:SetupOptions() end
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
	local module = BigWigs:GetBossModule(group)
	widget:SetUserData("bossIndex", group)
	-- reset scroll bar if not hitting the back button
	if not noScrollReset then
		toggleOptionsStatusTable.restore_offset = nil
		toggleOptionsStatusTable.restore_scrollvalue = nil
	end
	toggleOptionsStatusTable.offset = toggleOptionsStatusTable.restore_offset
	toggleOptionsStatusTable.scrollvalue = toggleOptionsStatusTable.restore_scrollvalue
	populateToggleOptions(widget, module)
end

local function onZoneShow(treeWidget, id)
	-- Make sure all the bosses for this zone are loaded.
	loader:LoadZone(id)

	-- Grab the module list from this zone
	local moduleList = loader:GetZoneMenus()[id]
	if type(moduleList) ~= "table" then return end -- No modules registered

	local zoneList, zoneSort = {}, {}
	for i = 1, #moduleList do
		local module = moduleList[i]
		zoneList[module.moduleName] = module.displayName
		zoneSort[i] = module.moduleName
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
	innerContainer:SetUserData("zone", id)
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
		local m = BigWigs:GetBossModule(name)
		if m:IsEnabled() and m:GetJournalID() then
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
	elseif loader.isBeta then
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
		}
	end

	local statusTable = {}
	local playerName = nil
	local GetBestMapForUnit = loader.GetBestMapForUnit
	local GetMapInfo = loader.GetMapInfo

	local function onControlEnter(widget)
		bwTooltip:SetOwner(widget.frame, "ANCHOR_TOPRIGHT")
		bwTooltip:SetText(widget.text:GetText(), 1, 0.82, 0, true)
		bwTooltip:AddLine(widget:GetUserData("desc"), 1, 1, 1, true)
		bwTooltip:Show()
	end

	local function onControlLeave()
		bwTooltip:Hide()
	end

	local function toggleAnchors(widget)
		if not BigWigs:IsEnabled() then BigWigs:Enable() end
		if options:InConfigureMode() then
			widget:SetText(L.toggleAnchorsBtnShow)
			widget:SetUserData("desc", L.toggleAnchorsBtnShow_desc)
			options:SendMessage("BigWigs_StopConfigureMode")
		else
			widget:SetText(L.toggleAnchorsBtnHide)
			widget:SetUserData("desc", L.toggleAnchorsBtnHide_desc)
			options:SendMessage("BigWigs_StartConfigureMode")
		end
		onControlLeave()
		onControlEnter(widget)
	end

	local function onTreeGroupSelected(widget, event, value)
		visibleSpellDescriptionWidgets = {}
		widget:ReleaseChildren()
		local zoneId = value:match("\001(-?%d+)$")
		local bigwigsContent = value:match("(BigWigs_%a+)$")
		if zoneId then
			onZoneShow(widget, tonumber(zoneId))
		elseif bigwigsContent and (loader.isClassic or value ~= loader.currentExpansion.name) then -- Any BigWigs content, but skip when clicking the current expansion header
			local addonState = loader:GetAddOnState(bigwigsContent)
			local string = addonState == "MISSING" and L.missingAddOn or addonState == "DISABLED" and L.disabledAddOn
			if string then
				local container = AceGUI:Create("SimpleGroup")
				container:SetFullWidth(true)
				widget:AddChild(container)

				local missing = AceGUI:Create("Label")
				missing:SetText(string:format(bigwigsContent))
				missing:SetFontObject(GameFontHighlight)
				missing:SetFullWidth(true)
				container:AddChild(missing)

				if addonState == "DISABLED" then
					local reload = AceGUI:Create("Button")
					reload:SetText(BigWigsAPI:GetLocale("BigWigs: Plugins").enable)
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
			if loader.isRetail and (value == loader.currentExpansion.littlewigsName or value == loader.currentExpansion.littlewigsDefault) then
				value = "LittleWigs"
			end
			local addonState = loader:GetAddOnState(value)
			local string = addonState == "MISSING" and L.missingAddOn or addonState == "DISABLED" and L.disabledAddOn
			if not loader.usingLittleWigsRepo and string then
				local container = AceGUI:Create("SimpleGroup")
				container:SetFullWidth(true)
				widget:AddChild(container)

				local missing = AceGUI:Create("Label")
				missing:SetText(string:format(value))
				missing:SetFontObject(GameFontHighlight)
				missing:SetFullWidth(true)
				container:AddChild(missing)

				if addonState == "DISABLED" then
					local reload = AceGUI:Create("Button")
					reload:SetText(BigWigsAPI:GetLocale("BigWigs: Plugins").enable)
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

	local function onTabGroupSelected(widget, event, value)
		visibleSpellDescriptionWidgets = {}
		widget:ReleaseChildren()

		if value == "options" then
			-- Embed the AceConfig options in our AceGUI frame
			local container = AceGUI:Create("SimpleGroup")
			container.type = "BigWigsOptions" -- We want ACD to create a ScrollFrame, so we change the type to bypass it's group control check
			container:SetFullHeight(true)
			container:SetFullWidth(true)

			-- Have to use :Open instead of just :FeedGroup because some widget types (range, color) call :Open to refresh on change
			isPluginOpen = container
			acd:Open("BigWigs", container)

			widget:AddChild(container)
		else
			isPluginOpen = nil
			local treeTbl = {}
			local addonNameToHeader = {}
			local defaultHeader
			if value == "bigwigs" then
				defaultHeader = loader.currentExpansion.name
				for i = 1, #expansionHeader do
					local value = "BigWigs_" .. expansionHeader[i]
					treeTbl[i] = {
						text = L.expansionNames[i],
						value = value,
						enabled = true,
					}
					addonNameToHeader[value] = i
				end
			elseif value == "littlewigs" then
				defaultHeader = loader.currentExpansion.littlewigsDefault
				for i = 1, #expansionHeader do
					local value = "LittleWigs_" .. expansionHeader[i]
					treeTbl[i] = {
						text = L.expansionNames[i],
						value = value,
						enabled = true,
					}
					addonNameToHeader[value] = i
				end
				-- add default LittleWigs to options if it doesn't match the current expansion's LittleWigs
				if loader.currentExpansion.littlewigsName ~= loader.currentExpansion.littlewigsDefault then
					treeTbl[#treeTbl + 1] = {
						text = L.currentSeason,
						value = defaultHeader,
						enabled = true,
					}
					addonNameToHeader[defaultHeader] = #treeTbl
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
					local zoneAddon = loader.zoneTbl[id]
					if type(zoneAddon) == "table" then
						for j = 1, #zoneAddon do
							addModuleToOptions(zoneAddon[j], treeTbl, addonNameToHeader, name or id, zoneName)
						end
					else
						addModuleToOptions(zoneAddon, treeTbl, addonNameToHeader, name or id, zoneName)
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
			local zoneAddon = loader.zoneTbl[id]
			if type(zoneAddon) == "table" then
				-- on Retail default to Current Season, on Classic default to the expansion addon
				zoneAddon = loader.isRetail and zoneAddon[#zoneAddon] or zoneAddon[1]
			end
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
				local value = treeTbl[parent].value
				tree:SelectByValue(moduleList and ("%s\001%d"):format(value, id) or value)
			else
				tree:SelectByValue(defaultHeader)
			end

			widget:AddChild(tree)
		end
	end

	function options:OpenConfig()
		playerName = UnitName("player")
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
			spellDescriptionUpdater:UnregisterEvent("SPELL_TEXT_UPDATE")
			widget:ReleaseChildren()
			AceGUI:Release(widget)
			statusTable = {}
			isPluginOpen = nil
			configFrame = nil
			options:SendMessage("BigWigs_CloseGUI")
		end)

		--local anchors = AceGUI:Create("Button")
		--if self:InConfigureMode() then
		--	anchors:SetText(L.toggleAnchorsBtnHide)
		--	anchors:SetUserData("desc", L.toggleAnchorsBtnHide_desc)
		--else
		--	anchors:SetText(L.toggleAnchorsBtnShow)
		--	anchors:SetUserData("desc", L.toggleAnchorsBtnShow_desc)
		--end
		--anchors:SetRelativeWidth(0.5)
		--anchors:SetCallback("OnClick", toggleAnchors)
		--anchors:SetCallback("OnEnter", onControlEnter)
		--anchors:SetCallback("OnLeave", onControlLeave)
		--
		--local testing = AceGUI:Create("Button")
		--testing:SetText(L.testBarsBtn)
		--testing:SetUserData("desc", L.testBarsBtn_desc)
		--testing:SetRelativeWidth(0.5)
		--testing:SetCallback("OnClick", BigWigs.Test)
		--testing:SetCallback("OnEnter", onControlEnter)
		--testing:SetCallback("OnLeave", onControlLeave)
		--
		--bw:AddChildren(anchors, testing)

		local tabs = AceGUI:Create("TabGroup")
		tabs:SetLayout("Flow")
		tabs:SetFullWidth(true)
		tabs:SetFullHeight(true)
		tabs:SetTabs({
			{ text = L.options, value = "options" },
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
	local registered, subPanelRegistry, pluginRegistry = {}, {}, {}
	function options:Register(_, _, module)
		if registered[module.name] then return end
		registered[module.name] = true
		if module.pluginOptions then
			if type(module.pluginOptions) == "function" then
				pluginRegistry[module.name] = module.pluginOptions
			else
				acOptions.args.general.args[module.name] = module.pluginOptions
			end
		elseif module.subPanelOptions then
			local key = module.subPanelOptions.key
			local opts = module.subPanelOptions.options
			if type(opts) == "function" then
				subPanelRegistry[key] = opts
			else
				acOptions.args[key] = opts
			end
		end
	end

	function getOptions()
		for key, opts in next, pluginRegistry do
			acOptions.args.general.args[key] = opts()
		end
		for key, opts in next, subPanelRegistry do
			acOptions.args[key] = opts()
		end
		return acOptions
	end
end

function options:ConfigTableChange(_, appName)
	if appName == "BigWigs" and isPluginOpen then
		acd:Open("BigWigs", isPluginOpen)
	end
end

BigWigsOptions = options -- Set global
