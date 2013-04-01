
local BIGWIGS_AUTHORS = "7destiny, pettigrow, ananhaid, mojosdojo, tekkub, jongt23, fenlis, Wetxius, StingerSoft, shyva, cwdg, gamefaq, yoshimo, sayclub, saroz, nevcairiel, s8095324, handdol, chuanhsing, durcyn, scorpio0920, kebinusan, _yusaku_, dynaletik, flyflame, onyxmaster, grimwald, zhTW, lcf_hell, chinkuwaila, starinnia, next96, arrowmaster, tnt2ray, Leialyn, ackis, moonsorrow, fryguy, xinsonic, jerry, beerke, hk2717, tsigo, mecdemort, ulic, Carlos, pigmonkey, cremor, mysticalos, a9012456, stanzilla, Dynaletik, gnarfoz, Cybersea, cronan, hyperactiveChipmunk, nirek, neriak, darchon, darkwings, hshh, otravi, mikk, yhpdoit, kergoth, kjheng, AnarkiQ3, Gothwin, Swix, dessa, erwanoops, valdriethien, profalbert, ethancentaurai, phyber, kyahx, nymbia, oxman, oojoo, zealotonastick, thiana, Zidomo, Anadale, Adam77, tain, lucen, tazmanyak, Traeumer, kemayo, ckknight, archarodim, silverwind, coalado."

local BigWigs = BigWigs
local options = BigWigs:NewModule("Options")
options:SetEnabledState(true)

-- Embed callback handler
options.RegisterMessage = BigWigs.RegisterMessage
options.UnregisterMessage = BigWigs.UnregisterMessage
options.SendMessage = BigWigs.SendMessage

local colorize = nil
do
	local r, g, b
	colorize = setmetatable({}, { __index =
		function(self, key)
			if not r then r, g, b = GameFontNormal:GetTextColor() end
			self[key] = "|cff" .. string.format("%02x%02x%02x", r * 255, g * 255, b * 255) .. key .. "|r"
			return self[key]
		end
	})
end

local C = BigWigs.C

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs")

local icon = LibStub("LibDBIcon-1.0", true)
local ac = LibStub("AceConfig-3.0")
local acd = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")

local colorModule
local soundModule

local showToggleOptions, getAdvancedToggleOption = nil, nil
local zoneModules = {}

local pluginOptions = {
	name = L["Customize ..."],
	type = "group",
	childGroups = "tab",
	args = {},
}

local acOptions = {
	type = "group",
	name = "Big Wigs",
	get = function(info)
		return BigWigs.db.profile[info[#info]]
	end,
	set = function(info, value)
		local key = info[#info]
		BigWigs.db.profile[key] = value
		options:SendMessage("BigWigs_CoreOptionToggled", key, value)
	end,
	args = {
		heading = {
			type = "description",
			name = L.introduction,
			fontSize = "medium",
			order = 10,
			width = "full",
		},
		configure = {
			type = "execute",
			name = L["Configure ..."],
			desc = L.configureDesc,
			func = function()
				InterfaceOptionsFrameOkay:Click()
				if not BigWigs:IsEnabled() then BigWigs:Enable() end
				options:SendMessage("BigWigs_StartConfigureMode")
				options:SendMessage("BigWigs_SetConfigureTarget", BigWigs:GetPlugin("Bars"))
			end,
			order = 11,
			width = "double",
		},
		customize = {
			type = "execute",
			name = L["Customize ..."],
			func = function()
				InterfaceOptionsFrame_OpenToCategory(L["Customize ..."])
			end,
			order = 11.5,
		},
		separator = {
			type = "description",
			name = " ",
			order = 12,
			width = "full",
		},
		minimap = {
			type = "toggle",
			name = L["Minimap icon"],
			desc = L["Toggle show/hide of the minimap icon."],
			order = 13,
			get = function() return not BigWigs3IconDB.hide end,
			set = function(info, v)
				if v then
					BigWigs3IconDB.hide = nil
					icon:Show("BigWigs")
				else
					BigWigs3IconDB.hide = true
					icon:Hide("BigWigs")
				end
			end,
			hidden = function() return not icon end,
			width = "full",
		},
		separator2 = {
			type = "description",
			name = " ",
			order = 14,
			width = "full",
		},
		sound = {
			type = "toggle",
			name = L["Sound"],
			desc = L.soundDesc,
			order = 21,
			width = "full",
		},
		flash = {
			type = "toggle",
			name = L["Flash Screen"],
			desc = L.flashDesc,
			order = 22,
			width = "full",
		},
		raidicon = {
			type = "toggle",
			name = L["Raid icons"],
			desc = L.raidiconDesc,
			set = function(info, value)
				local key = info[#info]
				local plugin = BigWigs:GetPlugin("Raid Icons")
				plugin:Disable()
				BigWigs.db.profile[key] = value
				options:SendMessage("BigWigs_CoreOptionToggled", key, value)
				plugin:Enable()
			end,
			order = 24,
			width = "full",
		},
		chat = {
			type = "toggle",
			name = L.chatMessages,
			desc = L.chatMessagesDesc,
			order = 25,
			width = "full",
			get = function() return BigWigs:GetPlugin("Messages").db.profile.chat end,
			set = function(_, v) BigWigs:GetPlugin("Messages").db.profile.chat = v end,
		},
		separator3 = {
			type = "description",
			name = " ",
			order = 30,
			width = "full",
		},
		showBlizzardWarnings = {
			type = "toggle",
			name = L["Show Blizzard warnings"],
			desc = L.blizzardDesc,
			set = function(info, value)
				local key = info[#info]
				local plugin = BigWigs:GetPlugin("BossBlock")
				plugin:Disable()
				BigWigs.db.profile[key] = value
				options:SendMessage("BigWigs_CoreOptionToggled", key, value)
				plugin:Enable()
			end,
			order = 31,
			width = "full",
		},
		blockmovies = {
			type = "toggle",
			name = L["Block boss movies"],
			desc = L["After you've seen a boss movie once, Big Wigs will prevent it from playing again."],
			order = 33,
			width = "full",
		},
		separator4 = {
			type = "description",
			name = " ",
			order = 40,
			width = "full",
		},
		fakeDBMVersion = {
			type = "toggle",
			name = L["Pretend I'm using DBM"],
			desc = L.pretendDesc,
			order = 41,
			width = "full",
		},
		customDBMbars = {
			type = "toggle",
			name = L["Create custom DBM bars"],
			desc = L.dbmBarDesc,
			order = 42,
			width = "full",
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
		slashDescBar = {
			type = "description",
			name = "  ".. L.slashDescRaidBar,
			fontSize = "medium",
			order = 45,
			width = "full",
		},
		slashDescLocalBar = {
			type = "description",
			name = "  ".. L.slashDescLocalBar,
			fontSize = "medium",
			order = 46,
			width = "full",
		},
		slashDescRange = {
			type = "description",
			name = "  ".. L.slashDescRange,
			fontSize = "medium",
			order = 47,
			width = "full",
		},
		slashDescVersion = {
			type = "description",
			name = "  ".. L.slashDescVersion,
			fontSize = "medium",
			order = 48,
			width = "full",
		},
		slashDescConfig = {
			type = "description",
			name = "  ".. L.slashDescConfig,
			fontSize = "medium",
			order = 49,
			width = "full",
		},
	},
}

local profileOptions
local function getProfileOptions()
	if not profileOptions then
		profileOptions = LibStub("AceDBOptions-3.0"):GetOptionsTable(BigWigs.db)
		LibStub("LibDualSpec-1.0"):EnhanceOptions(profileOptions, BigWigs.db)
	end
	return profileOptions
end

local function translateZoneID(id)
	if not id or type(id) ~= "number" then return end
	local name
	if id < 10 then
		name = select(id, GetMapContinents())
	else
		name = GetMapNameByID(id)
	end
	if not name then
		print(("Big Wigs: Tried to translate %q as a zone ID, but it could not be resolved into a name."):format(tostring(id)))
	end
	return name
end

local function findPanel(name, parent)
	for i, button in next, InterfaceOptionsFrameAddOns.buttons do
		if button.element then
			if name and button.element.name == name then return button
			elseif parent and button.element.parent == parent then return button
			end
		end
	end
end

function options:OnInitialize()
	BigWigsLoader:RemoveInterfaceOptions()

	ac:RegisterOptionsTable("BigWigs", acOptions)
	local mainOpts = acd:AddToBlizOptions("BigWigs", "Big Wigs")
	mainOpts:HookScript("OnShow", function()
		BigWigs:Enable()
		local p = findPanel("Big Wigs")
		if p and p.element.collapsed then OptionsListButtonToggle_OnClick(p.toggle) end
	end)

	local about = self:GetPanel(L["About"], "Big Wigs")
	about:SetScript("OnShow", function(frame)
		local fields = {
			L["Developers"],
			L["License"],
			L["Website"],
			L["Contact"],
		}
		local fieldData = {
			"Ammo, Funkydude, Maat, Nebula169, Rabbit",
			L["See license.txt in the main Big Wigs folder."],
			"http://www.wowace.com/addons/big-wigs/",
			L["irc.freenode.net in the #wowace channel"],
		}
		local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", 16, -16)
		title:SetText(L["About"])

		local subtitle = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		subtitle:SetWidth(frame:GetWidth() - 24)
		subtitle:SetJustifyH("LEFT")
		subtitle:SetJustifyV("TOP")
		local noteKey = "Notes"
		if GetAddOnMetadata("BigWigs", "Notes-" .. GetLocale()) then noteKey = "Notes-" .. GetLocale() end
		local notes = GetAddOnMetadata("BigWigs", noteKey)
		subtitle:SetText(notes .. " |cff44ff44" .. BigWigsLoader.BIGWIGS_RELEASE_STRING .. "|r")

		local anchor = nil
		for i, field in next, fields do
			local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			title:SetWidth(120)
			if not anchor then
				title:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -16)
			else
				title:SetPoint("TOP", anchor, "BOTTOM", 0, -6)
				title:SetPoint("LEFT", subtitle)
			end
			title:SetNonSpaceWrap(true)
			title:SetJustifyH("LEFT")
			title:SetText(field)
			local detail = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
			detail:SetPoint("TOPLEFT", title, "TOPRIGHT")
			detail:SetWidth(frame:GetWidth() - 144)
			detail:SetJustifyH("LEFT")
			detail:SetJustifyV("TOP")
			detail:SetText(fieldData[i])

			anchor = detail
		end
		local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		title:SetPoint("TOP", anchor, "BOTTOM", 0, -16)
		title:SetPoint("LEFT", subtitle)
		title:SetWidth(frame:GetWidth() - 24)
		title:SetJustifyH("LEFT")
		title:SetJustifyV("TOP")
		title:SetText(L["Thanks to the following for all their help in various fields of development"])
		local detail = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		detail:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
		detail:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -24, -24)
		detail:SetJustifyH("LEFT")
		detail:SetJustifyV("TOP")
		detail:SetText(BIGWIGS_AUTHORS)

		frame:SetScript("OnShow", nil)
	end)

	ac:RegisterOptionsTable("Big Wigs: Plugins", pluginOptions)
	acd:AddToBlizOptions("Big Wigs: Plugins", L["Customize ..."], "Big Wigs")

	ac:RegisterOptionsTable("Big Wigs: Profiles", getProfileOptions)
	acd:AddToBlizOptions("Big Wigs: Profiles", L["Profiles"], "Big Wigs")

	colorModule = BigWigs:GetPlugin("Colors")
	soundModule = BigWigs:GetPlugin("Sounds")
	ac:RegisterOptionsTable("Big Wigs: Colors Override", colorModule:SetColorOptions("dummy", "dummy"))
	ac:RegisterOptionsTable("Big Wigs: Sounds Override", soundModule:SetSoundOptions("dummy", "dummy"))
end

function options:OnEnable()
	for name, module in BigWigs:IterateBossModules() do
		self:Register("BigWigs_BossModuleRegistered", name, module)
	end
	for name, module in BigWigs:IteratePlugins() do
		self:Register("BigWigs_PluginRegistered", name, module)
	end
	self:RegisterMessage("BigWigs_BossModuleRegistered", "Register")
	self:RegisterMessage("BigWigs_PluginRegistered", "Register")

	self:RegisterMessage("BigWigs_SetConfigureTarget")
	self:RegisterMessage("BigWigs_StartConfigureMode")
	self:RegisterMessage("BigWigs_StopConfigureMode")

	local tmp, tmpZone = {}, {}
	for k in next, BigWigsLoader:GetZoneMenus() do
		local zone = translateZoneID(k)
		tmp[zone] = k
		tmpZone[#tmpZone+1] = zone
	end
	for k in next, zoneModules do
		local zone = translateZoneID(k)
		tmp[zone] = k
		tmpZone[#tmpZone+1] = zone
	end
	table.sort(tmpZone)
	for i=1, #tmpZone do
		local zone = tmpZone[i]
		self:GetZonePanel(tmp[zone])
	end
end

function options:Open()
	for name, module in BigWigs:IterateBossModules() do
		if module:IsEnabled() then
			local menu = translateZoneID(module.otherMenu) or translateZoneID(module.zoneId)
			if not menu then return end
			InterfaceOptionsFrame_OpenToCategory(self:GetZonePanel(module.otherMenu or module.zoneId))
		end
	end
	if not InterfaceOptionsFrame:IsShown() then
		InterfaceOptionsFrame_OpenToCategory("Big Wigs")
	end
end

-------------------------------------------------------------------------------
-- Plugin options
--

do
	local frame = nil
	local plugins = {}
	local tabs = nil
	local tabSection = nil
	local configMode = nil
	local acId = "Big Wigs Configure Mode Plugin %s"

	local function widgetSelect(widget, callback, tab)
		if widget:GetUserData("tab") == tab then return end
		local plugin = BigWigs:GetPlugin(tab)
		if not plugin then return end
		widget:SetUserData("tab", tab)
		acd:Open(acId:format(tab), tabSection)
		local scroll = widget:GetUserData("scroll")
		scroll:PerformLayout()
		options:SendMessage("BigWigs_SetConfigureTarget", plugin)
	end
	local function onTestClick() BigWigs:Test() end
	local function onResetClick() options:SendMessage("BigWigs_ResetPositions") end
	local function createPluginFrame()
		if frame then return end
		frame = AceGUI:Create("Window")
		frame:EnableResize(nil)
		frame:SetWidth(410)
		frame:SetHeight(515)
		frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 12, -12)
		frame:SetTitle(L["Configure"])
		frame:SetCallback("OnClose", function(widget, callback)
			options:SendMessage("BigWigs_StopConfigureMode")
		end)
		frame:SetLayout("Fill")

		local scroll = AceGUI:Create("ScrollFrame")
		scroll:SetLayout("Flow")
		scroll:SetFullWidth(true)

		local test = AceGUI:Create("Button")
		test:SetText(L["Test"])
		test:SetCallback("OnClick", onTestClick)
		test:SetFullWidth(true)

		local reset = AceGUI:Create("Button")
		reset:SetText(L["Reset positions"])
		reset:SetCallback("OnClick", onResetClick)
		reset:SetFullWidth(true)

		scroll:AddChildren(test, reset)
		for name, module in BigWigs:IteratePlugins() do
			if module.GetPluginConfig then
				plugins[#plugins + 1] = {
					value = name,
					text = name,
				}
				ac:RegisterOptionsTable(acId:format(name), module:GetPluginConfig())
			end
		end
		tabs = AceGUI:Create("TabGroup")
		tabs:SetTabs(plugins)
		tabs:SetCallback("OnGroupSelected", widgetSelect)
		tabs:SetUserData("tab", "")
		tabs:SetUserData("scroll", scroll)
		tabs:SetFullWidth(true)

		tabSection = AceGUI:Create("SimpleGroup")
		tabSection:SetFullWidth(true)
		tabs:AddChild(tabSection)

		scroll:AddChild(tabs)
		frame:AddChild(scroll)
	end
	function options:BigWigs_SetConfigureTarget(event, module)
		if frame then
			tabs:SelectTab(module:GetName())
		end
	end

	function options:InConfigureMode() return configMode end
	function options:BigWigs_StartConfigureMode(event, hideFrame)
		configMode = true
		if not hideFrame then
			createPluginFrame()
			frame:Show()
			frame:PerformLayout()
		end
	end

	function options:BigWigs_StopConfigureMode()
		configMode = nil
		if frame then
			frame:ReleaseChildren()
			frame:Hide()
			frame:Release()
		end
		frame = nil
		wipe(plugins)
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
		error(notNumberError:format(tostringall(key, module.moduleName, current, flag)))
	end
	return bit.band(current, flag) == flag
end

local function masterOptionToggled(self, event, value)
	if value == nil then self:SetValue(false) end -- toggling the master toggles all (we just pretend to be a tristate)
	local key = self:GetUserData("key")
	local module = self:GetUserData("module")
	if type(key) == "string" and key:find("custom_", nil, true) then
		module.db.profile[key] = value
	else
		if value then
			module.db.profile[key] = module.toggleDefaults[key]
		else
			module.db.profile[key] = 0
		end
		local scrollFrame = self:GetUserData("scrollFrame")
		-- This data ONLY exists if we're looking at the advanced options tab,
		-- we force a refresh of all checkboxes when enabling/disabling the master option.
		if scrollFrame then
			local dropdown = self:GetUserData("dropdown")
			local module = self:GetUserData("module")
			local bossOption = self:GetUserData("option")
			scrollFrame:ReleaseChildren()
			scrollFrame:AddChildren(getAdvancedToggleOption(scrollFrame, dropdown, module, bossOption))
			scrollFrame:PerformLayout()
		end
	end
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
end

local function getSlaveToggle(label, desc, key, module, flag, master)
	local toggle = AceGUI:Create("CheckBox")
	toggle:SetLabel(colorize[label])
	if flag == C.MESSAGE or flag == C.ME_ONLY or flag == C.FLASH or flag == C.PULSE then
		toggle:SetRelativeWidth(0.5)
	else
		toggle:SetFullWidth(true)
	end
	toggle:SetDescription(desc)
	toggle:SetUserData("key", key)
	toggle:SetUserData("module", module)
	toggle:SetUserData("flag", flag)
	toggle:SetUserData("master", master)
	toggle:SetCallback("OnValueChanged", slaveOptionToggled)
	toggle:SetValue(getSlaveOption(toggle))
	return toggle
end

local function advancedToggles(dbKey, module, check)
	local dbv = module.toggleDefaults[dbKey]
	local advancedOptions = {}
	for i, key in next, BigWigs:GetOptions() do
		local flag = C[key]
		if bit.band(dbv, flag) == flag then
			if key == "MESSAGE" then
				local messageGroup = AceGUI:Create("InlineGroup")
				messageGroup:SetLayout("Flow")
				messageGroup:SetFullWidth(true)

				local name, desc = BigWigs:GetOptionDetails(key)
				local message = getSlaveToggle(name, desc, dbKey, module, flag, check)
				messageGroup:AddChild(message)

				local onMe = getSlaveToggle(L["ME_ONLY"], L["ME_ONLY_desc"], dbKey, module, C.ME_ONLY, check)
				messageGroup:AddChild(onMe)

				advancedOptions[#advancedOptions + 1] = messageGroup
			elseif key == "FLASH" then
				local flashGroup = AceGUI:Create("InlineGroup")
				flashGroup:SetLayout("Flow")
				flashGroup:SetFullWidth(true)

				local name, desc = BigWigs:GetOptionDetails(key)
				local flash = getSlaveToggle(name, desc, dbKey, module, flag, check)
				flashGroup:AddChild(flash)

				local pulse = getSlaveToggle(L["PULSE"], L["PULSE_desc"], dbKey, module, C.PULSE, check)
				flashGroup:AddChild(pulse)

				advancedOptions[#advancedOptions + 1] = flashGroup
			else
				local name, desc = BigWigs:GetOptionDetails(key)
				advancedOptions[#advancedOptions + 1] = getSlaveToggle(name, desc, dbKey, module, flag, check)
			end
		end
	end
	advancedOptions[#advancedOptions + 1] = getSlaveToggle(L["EMPHASIZE"], L["EMPHASIZE_desc"], dbKey, module, C.EMPHASIZE, check)

	return unpack(advancedOptions)
end

local function advancedTabSelect(widget, callback, tab)
	if widget:GetUserData("tab") == tab then return end
	widget:SetUserData("tab", tab)
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
		soundModule:SetSoundOptions(module.name, key, module.toggleDefaults[key])
		acd:Open("Big Wigs: Sounds Override", group)
	elseif tab == "colors" then
		local group = AceGUI:Create("SimpleGroup")
		group:SetFullWidth(true)
		widget:AddChild(group)
		colorModule:SetColorOptions(module.name, key, module.toggleDefaults[key])
		acd:Open("Big Wigs: Colors Override", group)
	end
	widget:ResumeLayout()
	widget:GetUserData("scrollFrame"):PerformLayout()
	widget:PerformLayout()
end

local advancedTabs = {
	{
		text = L["Advanced options"],
		value = "options",
	},
	{
		text = L["Colors"],
		value = "colors",
	},
	{
		text = L["Sound"],
		value = "sounds",
	},
}

function getAdvancedToggleOption(scrollFrame, dropdown, module, bossOption)
	local dbKey, name, desc = BigWigs:GetBossOptionDetails(module, bossOption)
	local back = AceGUI:Create("Button")
	back:SetText(L["<< Back"])
	back:SetFullWidth(true)
	back:SetCallback("OnClick", function()
		showToggleOptions(dropdown, nil, dropdown:GetUserData("bossIndex"))
	end)
	local check = AceGUI:Create("CheckBox")
	check:SetLabel(colorize[name])
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

	-- Create role-specific secondary checkbox
	local roleRestrictionCheckbox = nil
	for i, key in next, BigWigs:GetRoleOptions() do
		local flag = C[key]
		if bit.band(module.toggleDefaults[dbKey], flag) == flag then
			local name, desc = BigWigs:GetOptionDetails(key)
			roleRestrictionCheckbox = getSlaveToggle(name, desc, dbKey, module, flag, check)
		end
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

	if roleRestrictionCheckbox then
		return back, check, roleRestrictionCheckbox, tabs
	else
		return back, check, tabs
	end
end

local function buttonClicked(widget)
	local scrollFrame = widget:GetUserData("scrollFrame")
	local dropdown = widget:GetUserData("dropdown")
	local module = widget:GetUserData("module")
	local bossOption = widget:GetUserData("bossOption")
	scrollFrame:ReleaseChildren()
	scrollFrame:AddChildren(getAdvancedToggleOption(scrollFrame, dropdown, module, bossOption))
	scrollFrame:PerformLayout()
end

local function getDefaultToggleOption(scrollFrame, dropdown, module, bossOption)
	local dbKey, name, desc, icon = BigWigs:GetBossOptionDetails(module, bossOption)

	local check = AceGUI:Create("CheckBox")
	check:SetLabel(colorize[name])
	check:SetTriState(true)
	check:SetRelativeWidth(0.85)
	check:SetUserData("key", dbKey)
	check:SetUserData("module", module)
	check:SetUserData("option", bossOption)
	check:SetDescription(desc)
	check:SetCallback("OnValueChanged", masterOptionToggled)
	check:SetValue(getMasterOption(check))
	if type(icon) == "string" then check:SetImage(icon, 0.07, 0.93, 0.07, 0.93) end

	if type(dbKey) == "string" and dbKey:find("^custom_") then
		return check
	else
		local button = AceGUI:Create("Button")
		button:SetText(">>")
		button:SetRelativeWidth(0.15)
		-- userdata baby
		button:SetUserData("scrollFrame", scrollFrame)
		button:SetUserData("dropdown", dropdown)
		button:SetUserData("module", module)
		button:SetUserData("bossOption", bossOption)
		button:SetCallback("OnClick", buttonClicked)
		return check, button
	end
end

local listAbilitiesInChat = nil
do
	local function output(channel, ...)
		if channel then
			SendChatMessage(strjoin(" ", ...), channel)
		else
			print(...)
		end
	end

	local function printList(channel, header, list)
		if #list == 0 then return end
		if header then output(channel, header, unpack(list))
		else output(channel, unpack(list)) end
	end

	function listAbilitiesInChat(widget)
		local module = widget:GetUserData("module")
		local channel = nil
		if UnitInRaid("player") then channel = "RAID"
		elseif GetNumSubgroupMembers() > 0 then channel = "PARTY" end
		local abilities = {}
		local header = nil
		output(channel, "Big Wigs: ", module.displayName or module.moduleName or module.name)
		local currentSize = 0
		for i, option in next, module.toggleOptions do
			local o = option
			if type(o) == "table" then o = option[1] end
			if module.optionHeaders and module.optionHeaders[o] then
				-- print what we have so far
				printList(channel, header, abilities)
				wipe(abilities)
				header = module.optionHeaders[o]
				currentSize = #header
			end
			if type(o) == "number" then
				if o > 0 then
					local l = GetSpellLink(o)
					if currentSize + #l + 1 > 255 then
						printList(channel, header, abilities)
						wipe(abilities)
						currentSize = 0
					end
					abilities[#abilities + 1] = l
					currentSize = currentSize + #l + 1
				else
					local l = select(9, EJ_GetSectionInfo(-o))
					if currentSize + #l + 1 > 255 then
						printList(channel, header, abilities)
						wipe(abilities)
						currentSize = 0
					end
					abilities[#abilities + 1] = l
					currentSize = currentSize + #l + 1
				end
			end
		end
		printList(channel, header, abilities)
	end
end

local function populateToggleOptions(widget, module)
	local scrollFrame = widget:GetUserData("parent")
	scrollFrame:ReleaseChildren()

	local sDB = BigWigsStatisticsDB
	if module.encounterId and module.zoneId and BigWigs:GetPlugin("Statistics").db.profile.enabled and sDB and sDB[module.zoneId] and sDB[module.zoneId][module.encounterId] then
		sDB = sDB[module.zoneId][module.encounterId]

		-- Create statistics table
		local statGroup = AceGUI:Create("InlineGroup")
		statGroup:SetTitle(L.statistics)
		statGroup:SetLayout("Flow")
		statGroup:SetFullWidth(true)
		scrollFrame:AddChild(statGroup)

		local statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText("")
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(L.norm25)
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(L.heroic25)
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(L.norm10)
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(L.heroic10)
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(L.lfr)
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetFullWidth(true)
		statistics:SetText("")
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(L.wipes)
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(sDB["25"] and sDB["25"].wipes or "-")
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(sDB["25h"] and sDB["25h"].wipes or "-")
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(sDB["10"] and sDB["10"].wipes or "-")
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(sDB["10h"] and sDB["10h"].wipes or "-")
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(sDB.lfr and sDB.lfr.wipes or "-")
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetFullWidth(true)
		statistics:SetText("")
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(L.kills)
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(sDB["25"] and sDB["25"].kills or "-")
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(sDB["25h"] and sDB["25h"].kills or "-")
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(sDB["10"] and sDB["10"].kills or "-")
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(sDB["10h"] and sDB["10h"].kills or "-")
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(sDB.lfr and sDB.lfr.kills or "-")
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetFullWidth(true)
		statistics:SetText("")
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(L.bestkill)
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(sDB["25"] and sDB["25"].best and SecondsToTime(sDB["25"].best) or "-")
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(sDB["25h"] and sDB["25h"].best and SecondsToTime(sDB["25h"].best) or "-")
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(sDB["10"] and sDB["10"].best and SecondsToTime(sDB["10"].best) or "-")
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(sDB["10h"] and sDB["10h"].best and SecondsToTime(sDB["10h"].best) or "-")
		statGroup:AddChild(statistics)

		statistics = AceGUI:Create("Label")
		statistics:SetWidth(90)
		statistics:SetText(sDB.lfr and sDB.lfr.best and SecondsToTime(sDB.lfr.best) or "-")
		statGroup:AddChild(statistics)
		-- End statistics table
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
	list:SetText(L["List abilities in group chat"])
	list:SetUserData("module", module)
	list:SetCallback("OnClick", listAbilitiesInChat)
	scrollFrame:AddChild(list)
	scrollFrame:PerformLayout()
end

function showToggleOptions(widget, event, group)
	if widget:GetUserData("zone") then
		local modules = zoneModules[widget:GetUserData("zone")]
		local module = BigWigs:GetBossModule(group)
		widget:SetUserData("bossIndex", group)
		populateToggleOptions(widget, module)
	else
		populateToggleOptions(widget, widget:GetUserData("module"))
	end
end

local onZoneShow
do
	local sorted = {}
	function onZoneShow(frame)
		local zone = frame.id

		-- Make sure all the bosses for this zone are loaded.
		BigWigsLoader:LoadZone(zone)

		-- Does this zone have multiple encounters?
		local multiple = zone and zoneModules[zone] and true or nil

		-- This zone has no modules, nor is the panel related
		-- to a module.
		if not multiple and not frame.module then
			error(("We wanted to show options for the zone %q, but it does not have any modules registered."):format(tostring(zone)))
			return
		end

		local outerContainer = AceGUI:Create("SimpleGroup")
		outerContainer:PauseLayout()
		outerContainer:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
		outerContainer:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
		outerContainer:SetLayout("Fill")
		outerContainer:SetFullWidth(true)

		local innerContainer = nil
		if multiple then
			innerContainer = AceGUI:Create("DropdownGroup")
			innerContainer:SetTitle(L["Select encounter"])
			innerContainer:SetLayout("Flow")
			innerContainer:SetCallback("OnGroupSelected", showToggleOptions)
			innerContainer:SetUserData("zone", zone)

			-- Sort the encounters for this zone, so we don't have
			-- to do it twice.
			wipe(sorted)
			for k, v in next, zoneModules[zone] do
				sorted[#sorted + 1] = k
			end
			table.sort(sorted)
			innerContainer:SetGroupList(zoneModules[zone], sorted)
		else
			innerContainer = AceGUI:Create("SimpleGroup")
			innerContainer:SetLayout("Fill")
			innerContainer:SetUserData("module", frame.module)
		end

		-- scroll is where we actually put stuff in case things
		-- overflow vertically
		local scroll = AceGUI:Create("ScrollFrame")
		scroll:SetLayout("Flow")
		scroll:SetFullWidth(true)
		scroll:SetFullHeight(true)
		innerContainer:SetUserData("parent", scroll)
		innerContainer:AddChild(scroll)

		outerContainer:AddChild(innerContainer)

		outerContainer:ResumeLayout()
		outerContainer:PerformLayout()

		-- Need to parent the AceGUI container to the actual
		-- zone panel frame so that the AceGUI container will
		-- show at all.
		outerContainer.frame:SetParent(frame)
		outerContainer.frame:Show()

		-- Need a reference to the outer container so that we can
		-- release all children when the zone panel is hidden.
		frame.container = outerContainer

		if multiple then
			-- Find the first enabled module and select that in the
			-- dropdown if possible.
			local index = 1
			for i, v in next, sorted do
				local m = BigWigs:GetBossModule(v)
				if m:IsEnabled() then
					index = i
					break
				end
			end
			innerContainer:SetGroup(sorted[index])
		else
			populateToggleOptions(innerContainer, frame.module)
		end
	end
end

local function onZoneHide(frame)
	if frame.container then
		frame.container:ReleaseChildren()
		frame.container:Release()
		frame.container = nil
	end
end

do
	local addonNameToHeader = {
		BigWigs_Classic = "Big Wigs ".. EJ_GetTierInfo(1),
		BigWigs_BurningCrusade = "Big Wigs ".. EJ_GetTierInfo(2),
		BigWigs_WrathOfTheLichKing = "Big Wigs ".. EJ_GetTierInfo(3),
		BigWigs_Cataclysm = "Big Wigs ".. EJ_GetTierInfo(4),
		BigWigs_MistsOfPandaria = "Big Wigs |cFF62B1F6".. EJ_GetTierInfo(5) .."|r",
		LittleWigs = "Little Wigs",
	}

	local panels = {}
	local noop = function() end
	function options:GetPanel(zone, parent, zoneId, setScript)
		if parent and parent ~= "Big Wigs" and not panels[parent] then -- This zone doesn't have a parent panel, create it first
			self:GetPanel(parent, nil, nil, true)
		end
		if not panels[zone] then
			local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
			frame.name = zone
			frame.id = zoneId
			frame.parent = parent
			frame.addonname = "BigWigs"
			frame.okay = noop
			frame.cancel = noop
			frame.default = noop
			frame.refresh = noop
			frame:Hide()
			InterfaceOptions_AddCategory(frame)
			if setScript then
				frame:SetScript("OnShow", function(self)
					BigWigs:Enable()
					-- First we need to expand ourselves if collapsed.
					local p = findPanel(self.name)
					if p and p.element.collapsed then OptionsListButtonToggle_OnClick(p.toggle) end
					-- InterfaceOptionsFrameAddOns.buttons has changed here to include the zones
					-- if we were collapsed.
					-- So now we need to select the first zone.
					p = findPanel(nil, self.name)
					if p then InterfaceOptionsFrame_OpenToCategory(p.element.name) end
				end)
			end

			panels[zone] = frame
			return panels[zone], true
		end
		return panels[zone]
	end

	function options:GetZonePanel(zoneId)
		local zoneName = translateZoneID(zoneId)
		local parent = BigWigsLoader.zoneList[zoneId] and addonNameToHeader[BigWigsLoader.zoneList[zoneId]] or addonNameToHeader.BigWigs_MistsOfPandaria
		local panel, created = self:GetPanel(zoneName, parent, zoneId)
		if created then
			panel:SetScript("OnShow", onZoneShow)
			panel:SetScript("OnHide", onZoneHide)
		end
		return panel
	end
end

do
	local registered = {}
	function options:Register(message, moduleName, module)
		if registered[module.name] then return end
		registered[module.name] = true
		if module.toggleOptions or module.GetOptions then
			if module:IsBossModule() then
				local zone = module.otherMenu or module.zoneId
				if not zone then error(module.name .. " doesn't have any valid zone set!") end
				if not zoneModules[zone] then zoneModules[zone] = {} end
				zoneModules[zone][module.moduleName] = module.displayName
			else
				local panel, created = self:GetPanel(moduleName, "Big Wigs")
				if created then
					panel:SetScript("OnShow", onZoneShow)
					panel:SetScript("OnHide", onZoneHide)
					panel.module = module
				end
			end
		end
		if module.pluginOptions then
			pluginOptions.args[module.name] = module.pluginOptions
		end
		if module.subPanelOptions then
			local key = module.subPanelOptions.key
			local name = module.subPanelOptions.name
			local options = module.subPanelOptions.options
			ac:RegisterOptionsTable(key, options)
			acd:AddToBlizOptions(key, name, "Big Wigs")
		end
	end
end

BigWigsOptions = options -- Set global

