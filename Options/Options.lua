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
			name = L["Welcome to Big Wigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group.\n"],
			fontSize = "medium",
			order = 10,
			width = "full",
		},
		configure = {
			type = "execute",
			name = L["Configure ..."],
			desc = L["Closes the interface options window and lets you configure displays for things like bars and messages.\n\nIf you want to customize more behind-the-scenes things, you can expand Big Wigs in the left tree and find the 'Customize ...' subsection."],
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
			desc = L["Messages might come with a sound. Some people find it easier to listen for these after they've learned which sound goes with which message, as opposed to reading the actual messages.\n\n|cffff4411Even when off, the default raid warning sound might be played by incoming raid warnings from other players. That sound, however, is different from the sounds we use.|r"],
			order = 21,
			width = "full",
		},
		showBlizzardWarnings = {
			type = "toggle",
			name = L["Blizzard warnings"],
			desc = L["Blizzard provides their own messages for some abilities on some encounters. In our opinion, these messages are both way too long and descriptive. We try to produce smaller, more fitting messages that do not interfere with the gameplay, and that don't tell you specifically what to do.\n\n|cffff4411When off, Blizzards warnings will not be shown in the middle of the screen, but they will still show in your chat frame.|r"],
			order = 22,
			width = "full",
		},
		separator2 = {
			type = "description",
			name = " ",
			order = 30,
			width = "full",
		},
		raidicon = {
			type = "toggle",
			name = L["Raid icons"],
			desc = L["Some encounter scripts use raid icons to mark players that are of special interest to your group. For example 'bomb'-type effects and mind control. If you turn this off, you won't mark anyone.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r"],
			order = 31,
			width = "full",
		},
		whisper = {
			type = "toggle",
			name = L["Whisper warnings"],
			desc = L["Send a whisper notification to fellow players about certain encounter abilities that affect them. Think 'bomb'-type effects and such.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r"],
			order = 32,
			width = "full",
		},
		broadcast = {
			type = "toggle",
			name = L["Broadcast"],
			desc = L["Broadcast all messages from Big Wigs to the raid warning channel.\n\n|cffff4411Only applies if you are raid leader or in a 5-man party!|r"],
			order = 33,
		},
		useraidchannel = {
			type = "toggle",
			name = L["Raid channel"],
			desc = L["Use the raid channel instead of raid warning for broadcasting messages."],
			order = 34,
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
		separator4 = {
			type = "description",
			name = " ",
			order = 50,
			width = "full",
			hidden = function() return not icon end,
		},
		footer = {
			type = "description",
			name = "|cff44ff44" .. BIGWIGS_RELEASE_STRING .. "|r",
			order = 51,
			width = "full",
			fontSize = "medium",
		},
	},
}

function options:OnInitialize()
	BigWigsLoader:RemoveInterfaceOptions()

	ac:RegisterOptionsTable("BigWigs", acOptions)
	acd:AddToBlizOptions("BigWigs", "Big Wigs")
	ac:RegisterOptionsTable("Big Wigs: Plugins", pluginOptions)
	acd:AddToBlizOptions("Big Wigs: Plugins", L["Customize ..."], "Big Wigs")
	
	self:RegisterMessage("BigWigs_BossModuleRegistered")
	self:RegisterMessage("BigWigs_PluginRegistered")
end

function options:OnEnable()
	for name, module in BigWigs:IterateBossModules() do
		self:BigWigs_BossModuleRegistered("BigWigs_BossModuleRegistered", name, module)
	end
	for name, module in BigWigs:IteratePlugins() do
		self:BigWigs_PluginRegistered("BigWigs_PluginRegistered", name, module)
	end
	self:RegisterMessage("BigWigs_SetConfigureTarget")
	self:RegisterMessage("BigWigs_StartConfigureMode")
	self:RegisterMessage("BigWigs_StopConfigureMode")
	self:RegisterMessage("BigWigs_BossModuleRegistered")
	self:RegisterMessage("BigWigs_PluginRegistered")

	local zones = BigWigsLoader:GetZoneMenus()
	if zones then
		for zone in pairs(zones) do self:NewZonePanel(zone) end
	end
end


function options:Open()
	for i, button in next, InterfaceOptionsFrameAddOns.buttons do
		if button.element and button.element.name == "Big Wigs" and button.element.collapsed then
			OptionsListButtonToggle_OnClick(button.toggle)
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

local showBossOptions = nil

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
	for k, toggle in ipairs(slaves) do
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

local messageDesc = "Most encounter abilities come with one or more messages that Big Wigs will show on your screen. If you disable this option, none of the messages attached to this option, if any, will be displayed."
local barDesc = "Bars are shown for some encounter abilities when appropriate. If this ability is accompanied by a bar that you want to hide, disable this option."
local fnsDesc = "Some abilities might be more important than others. If you want your screen to flash and shake when this ability is imminent or used, check this option."
local iconDesc = "Big Wigs can mark characters affected by abilities with an icon. This makes them easier to spot."
local whisperDesc = "Some effects are important enough that Big Wigs will send a whisper to the affected person."
local sayDesc = "Chat bubbles are easy to spot. Big Wigs will use a say message to announce people nearby about an effect on you."
local pingDesc = "Sometimes locations can be important, Big Wigs will ping the minimap so people know where you are."
local emphasizeDesc = "Enabling this will SUPER EMPHASIZE any messages or bars associated with this encounter ability. Messages will be bigger, bars will flash and have a different color, sounds will be used to count down when the ability is imminent. Basically you will notice it."

local function getAdvancedToggleOption(scrollFrame, dropdown, module, bossOption)
	local dbKey, name, desc = getOptionDetails(module, bossOption)
	local back = AceGUI:Create("Button")
	back:SetText("<< Back")
	back:SetFullWidth(true)
	back:SetCallback("OnClick", function()
		wipe(slaves) -- important, mastertoggled is called from the parent that has no slaves as well
		showBossOptions(dropdown, nil, dropdown:GetUserData("bossIndex"))
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
	group:SetTitle("Advanced options")

	
	local dbv = module.toggleDefaults[dbKey]
	
	do
		wipe(slaves)
		if bit.band(dbv, C.MESSAGE) == C.MESSAGE then
			local message = getSlaveToggle("Messages", messageDesc, dbKey, module, C.MESSAGE, check)
			group:AddChildren(message)
			table.insert(slaves, message)
		end
		if bit.band(dbv, C.BAR) == C.BAR then
			local bar = getSlaveToggle("Bars", barDesc, dbKey, module, C.BAR, check)
			group:AddChildren(bar)
			table.insert(slaves, bar)
		end
		if bit.band(dbv, C.FLASHNSHAKE) == C.FLASHNSHAKE then
			local fns = getSlaveToggle("Flash and shake", fnsDesc, dbKey, module, C.FLASHNSHAKE, check)
			group:AddChildren(fns)
			table.insert(slaves, fns)
		end
		if bit.band(dbv, C.ICON) == C.ICON then
			local icon = getSlaveToggle("Icon", iconDesc, dbKey, module, C.ICON, check)
			group:AddChildren(icon)
			table.insert(slaves, icon)
		end
		if bit.band(dbv, C.WHISPER) == C.WHISPER then
			local whisper = getSlaveToggle("Whisper", whisperDesc, dbKey, module, C.WHISPER, check)
			group:AddChildren(whisper)
			table.insert(slaves, whisper)
		end
		if bit.band(dbv, C.SAY) == C.SAY then
			local say = getSlaveToggle("Say", sayDesc, dbKey, module, C.SAY, check)
			group:AddChildren(say)
			table.insert(slaves, say)
		end
		if bit.band(dbv, C.PING) == C.PING then
			local ping = getSlaveToggle("Ping", pingDesc, dbKey, module, C.PING, check)
			group:AddChildren(ping)
			table.insert(slaves, ping)
		end
		local emp = getSlaveToggle("Emphasize", emphasizeDesc, dbKey, module, C.EMPHASIZE, check)
		group:AddChildren(emp)
		table.insert(slaves, emp)
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

function showBossOptions(widget, event, group)
	local scrollFrame = widget:GetUserData("parent")
	scrollFrame:ReleaseChildren()
	local modules = zoneModules[widget:GetUserData("zone")]
	local module = BigWigs:GetBossModule(modules[group])
	widget:SetUserData("bossIndex", group)
	if not module.toggleOptions then
		print("No toggle options for " .. module.displayName .. ".")
	else
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
end

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
	local dropdown = AceGUI:Create("DropdownGroup")
	dropdown:SetLayout("Fill")
	dropdown:SetCallback("OnGroupSelected", showBossOptions)
	table.sort(zoneModules[zone])
	dropdown:SetUserData("zone", zone)
	dropdown:SetGroupList(zoneModules[zone])
	local scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scroll:SetFullWidth(true)
	scroll:SetFullHeight(true)
	dropdown:AddChild(scroll)
	sframe:AddChild(dropdown)
	sframe.frame:SetParent(frame)
	sframe:ResumeLayout()
	sframe:DoLayout()
	sframe.frame:Show()
	frame.container = sframe
	dropdown:SetUserData("parent", scroll)
	dropdown:SetGroup(1)
end

local function onZoneHide(frame)
	frame.container:ReleaseChildren()
	frame.container:Release()
	frame.container = nil
end

do
	local panels = {}
	local noop = function() end
	function options:NewZonePanel(zone)
		if not panels[zone] then
			local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
			frame.name = zone
			frame.parent = "Big Wigs"
			frame.addonname = "BigWigs"
			frame.okay = noop
			frame.cancel = noop
			frame.default = noop
			frame.refresh = noop
			frame:Hide()
			frame:SetScript("OnShow", onZoneShow)
			frame:SetScript("OnHide", onZoneHide)
			InterfaceOptions_AddCategory(frame)
			panels[zone] = frame
		end
		return panels[zone]
	end
end

local registered = {}
function options:BigWigs_BossModuleRegistered(message, moduleName, module)
	if registered[module.name] then return end
	registered[module.name] = true
	if not module.toggleOptions then return end
	local zone = module.otherMenu or module.zoneName
	if not zone then error(module.name .. " doesn't have any valid zone set!") end
	self:NewZonePanel(zone)
	if not zoneModules[zone] then zoneModules[zone] = {} end
	tinsert(zoneModules[zone], module.displayName)
end

function options:BigWigs_PluginRegistered(message, moduleName, module)
	if registered[module.name] then return end
	registered[module.name] = true
	if not module.pluginOptions then return end
	if module.pluginOptions then
		pluginOptions.args[module.name] = module.pluginOptions
	end
end

