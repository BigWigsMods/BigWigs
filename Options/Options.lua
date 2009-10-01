local BigWigs = BigWigs
BigWigsOptions = BigWigs:NewModule("Options", "AceEvent-3.0")
local options = BigWigsOptions
options:SetEnabledState(true)

local C = BigWigs.C

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs")

local icon = LibStub("LibDBIcon-1.0", true)
local ac = LibStub("AceConfig-3.0")
local acr = LibStub("AceConfigRegistry-3.0")
local acd = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local zoneframes = {}

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
				-- This won't hide the game menu if you opened options from there.
				-- We don't care yet, this is temporary.
				InterfaceOptionsFrame:Hide()

				if not BigWigs:IsEnabled() then
					-- We may be reached through the blizzard interface options these days, even if bigwigs isn't enabled, so ....
					BigWigs:Enable()
				end
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
		},
		footer = {
			type = "description",
			name = L["|cffccccccMooses don't appreciate being prodded with long pointy sticks.\nContact us on irc.freenode.net/#wowace. [Ammo] and vhaarr can service all your needs.|r\n|cff44ff44"] .. BIGWIGS_RELEASE_STRING .. "|r",
			order = 51,
			width = "full",
			fontSize = "medium",
		},
	},
}

local SetZoneMenus = nil -- function defined later


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
	--SetZoneMenus(BigWigsLoader:GetZoneMenus())

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
end


function options:Open()
	for i, button in next, InterfaceOptionsFrameAddOns.buttons do
		if button.element and button.element.name == "Big Wigs" and button.element.collapsed then
			OptionsListButtonToggle_OnClick(button.toggle)
			break
		end
	end
	local enableModule = nil
	for name, module in BigWigs:IterateBossModules() do
		if module:IsEnabled() then
			local menu = module.otherMenu or module.zoneName
			if zoneframes[menu] then
				acd:SelectGroup("Big Wigs: "..menu, module.name)
				InterfaceOptionsFrame_OpenToCategory(zoneframes[menu])
				return
			end
		end
	end
	InterfaceOptionsFrame_OpenToCategory("Big Wigs")
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

local showBossOptions = nil

local function getOptionNameAndDesc(module, bossOption)
	local customBossOptions = BigWigs:GetCustomBossOptions()
	local option = bossOption
	local t = type(option)
	if t == "table" then option = option[1]; t = type(option) end
	if t == "string" then
		if customBossOptions[option] then
			return option, customBossOptions[option][1], customBossOptions[option][2]
		else
			return option, module.locale[option], module.locale[option .. "_desc"]
		end
	elseif t == "number" then
		local spellName = GetSpellInfo(option)
		if not spellName then error(("Invalid option %d in module %s."):format(option, module.displayName)) end
		return option, spellName, getSpellDescription(option)
	end
end

local function getAdvancedToggleOption(parent, module, bossOption)
	local dbKey, name, desc = getOptionNameAndDesc(module, bossOption)
	local back = AceGUI:Create("Button")
	back:SetText("Back")
	back:SetWidth(350)
	back:SetCallback("OnClick", function()
		showBossOptions(parent, nil, parent:GetUserData("bossIndex"))
	end)
	local check = AceGUI:Create("CheckBox")
	check:SetLabel(name)
	check:SetValue(module.db.profile[dbKey])
	check:SetWidth(350)
	check:SetUserData("key", dbKey)
	check:SetDescription(desc)

	return back, check
end

local function getDefaultToggleOption(parent, module, bossOption)
	local dbKey, name, desc = getOptionNameAndDesc(module, bossOption)
	local check = AceGUI:Create("CheckBox")
	check:SetLabel(name)
	check:SetValue(module.db.profile[dbKey])
	check:SetWidth(300)
	check:SetUserData("key", dbKey)
	check:SetDescription(desc)
	local customBossOptions = BigWigs:GetCustomBossOptions()
	if customBossOptions[dbKey] then
		return check
	else
		local button = AceGUI:Create("Button")
		button:SetText("+")
		button:SetWidth(40)
		button:SetCallback("OnClick", function()
			parent:ReleaseChildren()
			parent:AddChildren(getAdvancedToggleOption(parent, module, bossOption))
		end)
		return check, button
	end
end

function showBossOptions(widget, event, group)
	widget:ReleaseChildren()
	local modules = widget:GetUserData("list")
	local module = BigWigs:GetBossModule(modules[group])
	widget:SetUserData("bossIndex", group)
	if not module.toggleOptions then
		print("No toggle options for " .. module.displayName .. ".")
	else
		for i, option in next, module.toggleOptions do
			widget:AddChildren(getDefaultToggleOption(widget, module, option))
		end
	end
end

local zoneOptions = {}

local function loadZone(k, v)
	local zone = k.arg
	BigWigsLoader:LoadZone(zone)
	acr:NotifyChange(zone)
end

local zoneModules = {}

local function getLoadButton(zone)
	if not BigWigsLoader:HasZone(zone) then return end
	local button = AceGUI:Create("Button")
	button:SetLabel(L["Load"])
	button:SetCallback("OnClick", loadZone)
	button:SetUserData("zone", zone)
	button:SetFullWidth(true)
	return button
end

local function onZoneShow(frame)
	local zone = frame.name
	local dropdown = AceGUI:Create("DropdownGroup")
	dropdown.frame:SetParent(frame)
	dropdown.frame:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, 4)
	dropdown.frame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
	dropdown:SetWidth(400) -- XXX wtf fullwidth doesn't work!
	--dropdown:SetFullWidth(true)
	--dropdown:SetFullHeight(true)
	dropdown:SetCallback("OnGroupSelected", showBossOptions)
	dropdown:SetLayout("Flow")
	local list = {}
	for i, module in next, zoneModules[zone] do
		tinsert(list, module.displayName)
	end
	dropdown:SetUserData("list", list)
	dropdown:SetGroupList(list)
	dropdown:SetGroup(1)
	dropdown.frame:Show()
	frame.container = dropdown
end

local function onZoneHide(frame)
	frame.container:ReleaseChildren()
	frame.container:Release()
	frame.container = nil
end

local registered = {}
function options:BigWigs_BossModuleRegistered(message, moduleName, module)
	if registered[module.name] then return end
	registered[module.name] = true
	if not module.toggleOptions then return end
	local zone = module.otherMenu or module.zoneName
	if not zone then print(module.name) end
	if not zoneModules[zone] then
		local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
		frame.name = zone
		frame.parent = "Big Wigs"
		frame.addonname = "BigWigs"
		frame:Hide()
		frame:SetScript("OnShow", onZoneShow)
		frame:SetScript("OnHide", onZoneHide)
		zoneframes[zone] = frame
		InterfaceOptions_AddCategory(frame)
		zoneModules[zone] = {}
	end
	tinsert(zoneModules[zone], module)
end

function options:BigWigs_PluginRegistered(message, moduleName, module)
	if registered[module.name] then return end
	registered[module.name] = true
	if not module.pluginOptions then return end
	if module.pluginOptions then
		pluginOptions.args[module.name] = module.pluginOptions
	end
end

