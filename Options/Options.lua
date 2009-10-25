local BigWigs = BigWigs
BigWigsOptions = BigWigs:NewModule("Options", "AceEvent-3.0")
local options = BigWigsOptions
options:SetEnabledState(true)

local C = BigWigs.C

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs")
local common = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Common")

local icon = LibStub("LibDBIcon-1.0", true)
local ac = LibStub("AceConfig-3.0")
local acr = LibStub("AceConfigRegistry-3.0")
local acd = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")

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
				HideUIPanel(InterfaceOptionsFrame)
				HideUIPanel(GameMenuFrame)
				if not BigWigs:IsEnabled() then BigWigs:Enable() end
				options:SendMessage("BigWigs_StartConfigureMode")
				options:SendMessage("BigWigs_SetConfigureTarget", BigWigs:GetPlugin("Bars"))
			end,
			order = 11,
			width = "full",
		},
		separator = {
			type = "description",
			name = " ",
			order = 20,
			width = "full",
		},
		sound = {
			type = "toggle",
			name = L["Sound"],
			desc = L.soundDesc,
			order = 21,
			width = "full",
		},
		flashshake = {
			type = "toggle",
			name = L["Flash and shake"],
			desc = L.fnsDesc,
			order = 22,
			width = "full",
		},
		raidicon = {
			type = "toggle",
			name = L["Raid icons"],
			desc = L.raidiconDesc,
			order = 23,
			width = "full",
		},
		separator2 = {
			type = "description",
			name = " ",
			order = 30,
			width = "full",
		},
		showBlizzardWarnings = {
			type = "toggle",
			name = L["Show Blizzard warnings"],
			desc = L.blizzardDesc,
			order = 31,
			width = "full",
		},
		showBossmodChat = {
			type = "toggle",
			name = L["Show addon warnings"],
			desc = L.addonwarningDesc,
			order = 32,
			width = "full",
		},
		whisper = {
			type = "toggle",
			name = L["Whisper warnings"],
			desc = L.whisperDesc,
			order = 33,
			width = "full",
		},
		broadcast = {
			type = "toggle",
			name = L["Broadcast"],
			desc = L.broadcastDesc,
			order = 34,
		},
		useraidchannel = {
			type = "toggle",
			name = L["Raid channel"],
			desc = L["Use the raid channel instead of raid warning for broadcasting messages."],
			order = 35,
			disabled = function() return not BigWigs.db.profile.broadcast end,
		},
		separator3 = {
			type = "description",
			name = " ",
			order = 40,
			width = "full",
		},
		minimap = {
			type = "toggle",
			name = L["Minimap icon"],
			desc = L["Toggle show/hide of the minimap icon."],
			order = 41,
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
	},
}

local profileOptions
local function getProfileOptions()
	if not profileOptions then
		profileOptions = LibStub("AceDBOptions-3.0"):GetOptionsTable(BigWigs.db)
	end
	return profileOptions
end

function options:OnInitialize()
	BigWigsLoader:RemoveInterfaceOptions()

	ac:RegisterOptionsTable("BigWigs", acOptions)
	local mainOpts = acd:AddToBlizOptions("BigWigs", "Big Wigs")
	mainOpts:HookScript("OnShow", function()
		BigWigs:Enable()
	end)
	
	local bossEntry = self:GetPanel(L["Big Wigs Encounters"])
	bossEntry:SetScript("OnShow", function(self)
		BigWigs:Enable()
		-- First we need to expand ourselves if collapsed.
		for i, button in next, InterfaceOptionsFrameAddOns.buttons do
			if button.element and button.element.name == L["Big Wigs Encounters"] then
				if button.element.collapsed then
					OptionsListButtonToggle_OnClick(button.toggle)
				end
				break
			end
		end
		-- InterfaceOptionsFrameAddOns.buttons has changed here to include the zones
		-- if we were collapsed.
		-- So now we need to select the first zone.
		for i, button in next, InterfaceOptionsFrameAddOns.buttons do
			if button.element and button.element.parent == L["Big Wigs Encounters"] then
				InterfaceOptionsFrame_OpenToCategory(button.element.name)
				break
			end
		end
	end)
	
	local about = self:GetPanel(L["About"], "Big Wigs")
	about:SetScript("OnShow", function(frame)
		local fields = {
			L["Main Developers"],
			L["Maintainers"],
			L["License"],
			L["Website"],
			L["Contact"],
		}
		local fieldData = {
			"Ammo, Rabbit",
			"Funkydude",
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
		subtitle:SetText(notes .. " |cff44ff44" .. BIGWIGS_RELEASE_STRING .. "|r")

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

	local zones = BigWigsLoader:GetZoneMenus()
	local tmp = {}
	local sorted = {}
	for zone in pairs(zones) do tmp[zone] = true end
	for zone in pairs(zoneModules) do tmp[zone] = true end
	for zone in pairs(tmp) do tinsert(sorted, zone) end
	table.sort(sorted)
	for i, zone in next, sorted do self:GetZonePanel(zone) end
	tmp = nil
	sorted = nil
end


function options:Open()
	for i, button in next, InterfaceOptionsFrameAddOns.buttons do
		if button.element and button.element.name == "Big Wigs" then
			if button.element.collapsed then
				OptionsListButtonToggle_OnClick(button.toggle)
			end
			break
		end
	end
	for name, module in BigWigs:IterateBossModules() do
		if module:IsEnabled() then
			local menu = module.otherMenu or module.zoneName
			InterfaceOptionsFrame_OpenToCategory(menu)
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
	local configMode = nil

	local function widgetSelect(widget, callback, tab)
		if widget:GetUserData("tab") == tab then return end
		local plugin = BigWigs:GetPlugin(tab)
		if not plugin then return end
		widget:SetUserData("tab", tab)
		tabs:PauseLayout()
		tabs:ReleaseChildren()
		tabs:AddChildren(plugin:GetPluginConfig())
		tabs:ResumeLayout()
		frame:DoLayout()
		options:SendMessage("BigWigs_SetConfigureTarget", plugin)
	end
	local function onTestClick() BigWigs:Test() end
	local function onResetClick() options:SendMessage("BigWigs_ResetPositions") end
	local function createPluginFrame()
		if frame then return end
		frame = AceGUI:Create("Window")
		frame:SetWidth(320)
		frame:SetHeight(640)
		frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 12, -12)
		frame:SetTitle(L["Configure"])
		frame:SetCallback("OnClose", function(widget, callback)
			options:SendMessage("BigWigs_StopConfigureMode")
		end)

		local test = AceGUI:Create("Button")
		test:SetText(L["Test"])
		test:SetCallback("OnClick", onTestClick)
		test:SetFullWidth(true)
		
		local reset = AceGUI:Create("Button")
		reset:SetText(L["Reset positions"])
		reset:SetCallback("OnClick", onResetClick)
		reset:SetFullWidth(true)

		frame:AddChildren(test, reset)
		for name, module in BigWigs:IteratePlugins() do
			if module.GetPluginConfig then
				table.insert(plugins, {
					value = name,
					text = name,
				})
			end
		end
		tabs = AceGUI:Create("TabGroup")
		tabs:SetLayout("Flow")
		tabs:SetTabs(plugins)
		tabs:SetCallback("OnGroupSelected", widgetSelect)
		tabs:SetUserData("tab", "")
		tabs:SetFullWidth(true)
		tabs:SetFullHeight(true)
		frame:AddChild(tabs)
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
		end
	end

	function options:BigWigs_StopConfigureMode()
		configMode = nil
		if frame then
			frame:Hide()
			frame:ReleaseChildren()
			frame:Release()
		end
		frame = nil
		wipe(plugins)
	end
end

local getSpellDescription
do
	local cache = {}
	local scanner = CreateFrame("GameTooltip")
	scanner:SetOwner(WorldFrame, "ANCHOR_NONE")
	local lcache, rcache = {}, {}
	for i = 1, 4 do
		lcache[i], rcache[i] = scanner:CreateFontString(), scanner:CreateFontString()
		lcache[i]:SetFontObject(GameFontNormal); rcache[i]:SetFontObject(GameFontNormal)
		scanner:AddFontStrings(lcache[i], rcache[i])
	end
	function getSpellDescription(spellId)
		if cache[spellId] then return cache[spellId] end
		scanner:ClearLines()
		scanner:SetHyperlink("spell:"..spellId)
		for i = scanner:NumLines(), 1, -1  do
			local desc = lcache[i] and lcache[i]:GetText()
			if desc then
				cache[spellId] = desc
				return desc
			end
		end
	end
end

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

local showToggleOptions = nil

local function getOptionDetails(module, bossOption)
	local customBossOptions = BigWigs:GetCustomBossOptions()
	local option = bossOption
	local t = type(option)
	if t == "table" then option = option[1]; t = type(option) end
	local bf = module.toggleDefaults[option]
	if t == "string" then
		if customBossOptions[option] then
			return option, customBossOptions[option][1], customBossOptions[option][2], bf
		else
			return option, module.locale[option], module.locale[option .. "_desc"], bf
		end
	elseif t == "number" then
		local spellName = GetSpellInfo(option)
		if not spellName then error(("Invalid option %d in module %s."):format(option, module.displayName)) end
		return spellName, spellName, getSpellDescription(option), bf
	end
end

local slaves = {}
local getMasterOption, masterOptionToggled, getSlaveOption, slaveOptionToggled

function getMasterOption(self)
	local key = self:GetUserData("key")
	local module = self:GetUserData("module")
	if module.db.profile[key] == 0 then
		return false -- nothing go away
	end
	if bit.band(module.db.profile[key], module.toggleDefaults[key]) == module.toggleDefaults[key] then
		return true -- all default baby
	end
	return nil -- some options set
end

function masterOptionToggled(self, event, value)
	if value == nil then self:SetValue(false) end -- toggling the master toggles all (we just pretend to be a tristate)
	local key = self:GetUserData("key")
	local module = self:GetUserData("module")
	if value then
		module.db.profile[key] = module.toggleDefaults[key]
	else
		module.db.profile[key] = 0
	end
	for k, toggle in next, slaves do
		toggle:SetValue(getSlaveOption(toggle))
	end
end

function getSlaveOption(self)
	local key = self:GetUserData("key")
	local module = self:GetUserData("module")
	local flag = self:GetUserData("flag")
	return bit.band(module.db.profile[key], flag) == flag
end

function slaveOptionToggled(self, event, value)
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
	toggle:SetFullWidth(true)
	toggle:SetDescription(desc)
	toggle:SetUserData("key", key)
	toggle:SetUserData("module", module)
	toggle:SetUserData("flag", flag)
	toggle:SetUserData("master", master)
	toggle:SetCallback("OnValueChanged", slaveOptionToggled)
	toggle:SetValue(getSlaveOption(toggle))
	return toggle
end

local function getAdvancedToggleOption(scrollFrame, dropdown, module, bossOption)
	local dbKey, name, desc = getOptionDetails(module, bossOption)
	local back = AceGUI:Create("Button")
	back:SetText(L["<< Back"])
	back:SetFullWidth(true)
	back:SetCallback("OnClick", function()
		wipe(slaves) -- important, mastertoggled is called from the parent that has no slaves as well
		showToggleOptions(dropdown, nil, dropdown:GetUserData("bossIndex"))
	end)
	local check = AceGUI:Create("CheckBox")
	check:SetLabel(colorize[name])
	check:SetTriState(true)

	check:SetFullWidth(true)
	check:SetUserData("key", dbKey)
	check:SetDescription(desc)
	check:SetUserData("module", module)
	check:SetUserData("option", bossOption)
	check:SetCallback("OnValueChanged", masterOptionToggled)
	check:SetValue(getMasterOption(check))
	
	local group = AceGUI:Create("InlineGroup")
	group:SetFullWidth(true)
	group:SetTitle(L["Advanced options"])

	local dbv = module.toggleDefaults[dbKey]

	do
		wipe(slaves)
		if bit.band(dbv, C.MESSAGE) == C.MESSAGE then
			local message = getSlaveToggle(L["MESSAGE"], L["MESSAGE_desc"], dbKey, module, C.MESSAGE, check)
			group:AddChildren(message)
			table.insert(slaves, message)
		end
		if bit.band(dbv, C.BAR) == C.BAR then
			local bar = getSlaveToggle(L["BAR"], L["BAR_desc"], dbKey, module, C.BAR, check)
			group:AddChildren(bar)
			table.insert(slaves, bar)
		end
		if bit.band(dbv, C.FLASHSHAKE) == C.FLASHSHAKE then
			local fns = getSlaveToggle(L["FLASHSHAKE"], L["FLASHSHAKE_desc"], dbKey, module, C.FLASHSHAKE, check)
			group:AddChildren(fns)
			table.insert(slaves, fns)
		end
		if bit.band(dbv, C.ICON) == C.ICON then
			local icon = getSlaveToggle(L["ICON"], L["ICON_desc"], dbKey, module, C.ICON, check)
			group:AddChildren(icon)
			table.insert(slaves, icon)
		end
		if bit.band(dbv, C.WHISPER) == C.WHISPER then
			local whisper = getSlaveToggle(L["WHISPER"], L["WHISPER_desc"], dbKey, module, C.WHISPER, check)
			group:AddChildren(whisper)
			table.insert(slaves, whisper)
		end
		if bit.band(dbv, C.SAY) == C.SAY then
			local say = getSlaveToggle(L["SAY"], L["SAY_desc"], dbKey, module, C.SAY, check)
			group:AddChildren(say)
			table.insert(slaves, say)
		end
		if bit.band(dbv, C.PING) == C.PING then
			local ping = getSlaveToggle(L["PING"], L["PING_desc"], dbKey, module, C.PING, check)
			group:AddChildren(ping)
			table.insert(slaves, ping)
		end
--[[ XXX - Add this again when we're ready for it
		local emp = getSlaveToggle(L["EMPHASIZE"], L["EMPHASIZE_desc"], dbKey, module, C.EMPHASIZE, check)
		group:AddChildren(emp)
		table.insert(slaves, emp)
--]]
	end
	return back, check, group
end

local function buttonClicked(widget)
	local scrollFrame = widget:GetUserData("scrollFrame")
	local dropdown = widget:GetUserData("dropdown")
	local module = widget:GetUserData("module")
	local bossOption = widget:GetUserData("bossOption")
	scrollFrame:ReleaseChildren()
	scrollFrame:AddChildren(getAdvancedToggleOption(scrollFrame, dropdown, module, bossOption))
	scrollFrame:DoLayout()
end

local function getDefaultToggleOption(scrollFrame, dropdown, module, bossOption)
	local dbKey, name, desc = getOptionDetails(module, bossOption)
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

local function populateToggleOptions(widget, module)
	local scrollFrame = widget:GetUserData("parent")
	scrollFrame:ReleaseChildren()
	for i, option in next, module.toggleOptions do
		local o = option
		if type(o) == "table" then o = option[1] end
		if module.optionHeaders and module.optionHeaders[o] then
			local heading = module.optionHeaders[o]
			local text = nil
			if type(heading) == "number" then text = GetSpellInfo(heading)
			elseif common[heading] then text = common[heading]
			else text = BigWigs:Translate(heading) end
			local header = AceGUI:Create("Heading")
			header:SetText(text)
			header:SetFullWidth(true)
			scrollFrame:AddChild(header)
		end
		scrollFrame:AddChildren(getDefaultToggleOption(scrollFrame, widget, module, option))
	end
	scrollFrame:DoLayout()
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

local sorted = {}
local function onZoneShow(frame)
	local zone = frame.name

	-- Make sure all the bosses for this zone are loaded.
	BigWigsLoader:LoadZone(zone)

	local sframe = AceGUI:Create("SimpleGroup")
	sframe:PauseLayout()
	sframe:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, 8)
	sframe:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
	sframe:SetLayout("Fill")
	sframe:SetFullWidth(true)

	local scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scroll:SetFullWidth(true)
	scroll:SetFullHeight(true)
	
	local hasZones = zone and zoneModules[zone] and true or nil
	local group = nil
	if hasZones then
		group = AceGUI:Create("DropdownGroup")
		group:SetLayout("Fill")
		group:SetCallback("OnGroupSelected", showToggleOptions)
		table.sort(zoneModules[zone])
		group:SetUserData("zone", zone)
		group:SetGroupList(zoneModules[zone])
	else
		group = AceGUI:Create("SimpleGroup")
		group:SetLayout("Fill")
		group:SetUserData("module", frame.module)
	end
	group:AddChild(scroll)
	sframe:AddChild(group)
	group:SetUserData("parent", scroll)
	sframe.frame:SetParent(frame)
	sframe:ResumeLayout()
	sframe:DoLayout()
	sframe.frame:Show()
	frame.container = sframe

	if hasZones then
		local enabledModule = nil
		for name, module in BigWigs:IterateBossModules() do
			if module:IsEnabled() then
				enabledModule = module.moduleName
			end
		end
		if enabledModule and zoneModules[zone][enabledModule] then
			group:SetGroup(enabledModule)
		else
			-- select first one
			wipe(sorted)
			for k, v in pairs(zoneModules[zone]) do
				table.insert(sorted, k)
			end
			table.sort(sorted)
			group:SetGroup(sorted[1])
		end
	else
		populateToggleOptions(group, frame.module)
	end
end

local function onZoneHide(frame)
	frame.container:ReleaseChildren()
	frame.container:Release()
	frame.container = nil
end

do
	local panels = {}
	local noop = function() end
	function options:GetPanel(id, parent)
		if not panels[id] then
			local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
			frame.name = id
			frame.parent = parent
			frame.addonname = "BigWigs"
			frame.okay = noop
			frame.cancel = noop
			frame.default = noop
			frame.refresh = noop
			frame:Hide()
			InterfaceOptions_AddCategory(frame)
			panels[id] = frame
			return panels[id], true
		end
		return panels[id]
	end
	
	function options:GetZonePanel(zone)
		local panel, created = self:GetPanel(zone, L["Big Wigs Encounters"])
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
		if module.toggleOptions then
			if module:IsBossModule() then
				local zone = module.otherMenu or module.zoneName
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
	end
end


