local BigWigs = BigWigs
BigWigsOptions = BigWigs:NewModule("Options", "AceEvent-3.0")
local options = BigWigsOptions
options:SetEnabledState(true)

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs")

local icon = LibStub("LibDBIcon-1.0", true)
local ac = LibStub("AceConfig-3.0")
local acr = LibStub("AceConfigRegistry-3.0")
local acd = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")

local pluginOptions = {
	name = "Customize ...",
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
			name = "Welcome to Big Wigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group.\n",
			fontSize = "medium",
			order = 10,
			width = "full",
		},
		configure = {
			type = "execute",
			name = "Configure ...",
			desc = "Closes the interface options window and lets you configure displays for things like bars and messages.\n\nIf you want to customize more behind-the-scenes things, you can expand Big Wigs in the left tree and find the 'Customize ...' subsection.",
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
			name = "Sound",
			desc = "Messages might come with a sound. Some people find it easier to listen for these after they've learned which sound goes with which message, as opposed to reading the actual messages.\n\n|cffff4411Even when off, the default raid warning sound might be played by incoming raid warnings from other players. That sound, however, is different from the sounds we use.|r",
			order = 21,
			width = "full",
		},
		showBlizzardWarnings = {
			type = "toggle",
			name = "Blizzard warnings",
			desc = "Blizzard provides their own messages for some abilities on some encounters. In our opinion, these messages are both way too long and descriptive. We try to produce smaller, more fitting messages that do not interfere with the gameplay, and that don't tell you specifically what to do.\n\n|cffff4411When off, Blizzards warnings will not be shown in the middle of the screen, but they will still show in your chat frame.|r",
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
			name = "Raid icons",
			desc = "Some encounter scripts use raid icons to mark players that are of special interest to your group. For example 'bomb'-type effects and mind control. If you turn this off, you won't mark anyone.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r",
			order = 31,
			width = "full",
		},
		whisper = {
			type = "toggle",
			name = "Whisper warnings",
			desc = "Send a whisper notification to fellow players about certain encounter abilities that affect them. Think 'bomb'-type effects and such.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r",
			order = 32,
			width = "full",
		},
		broadcast = {
			type = "toggle",
			name = "Broadcast",
			desc = "Broadcast all messages from Big Wigs to the raid warning channel.\n\n|cffff4411Only applies if you are raid leader or in a 5-man party!|r",
			order = 33,
		},
		useraidchannel = {
			type = "toggle",
			name = "Raid channel",
			desc = "Use the raid channel instead of raid warning for broadcasting messages.",
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
			name = "|cffccccccMooses don't appreciate being prodded with long pointy sticks.\nContact us on irc.freenode.net/#wowace. [Ammo] and vhaarr can service all your needs.|r\n|cff44ff44" .. BIGWIGS_RELEASE_STRING .. "|r",
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
	acd:AddToBlizOptions("Big Wigs: Plugins", "Customize ...", "Big Wigs")
	
	self:RegisterMessage("BigWigs_BossModuleRegistered")
	self:RegisterMessage("BigWigs_PluginRegistered")
end

function options:OnEnable()
	SetZoneMenus(BigWigsLoader:GetZoneMenus())

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
		frame:SetTitle("Configure")
		frame:SetCallback("OnClose", function(widget, callback)
			options:SendMessage("BigWigs_StopConfigureMode")
		end)

		local test = AceGUI:Create("Button")
		test:SetText("Test")
		test:SetCallback("OnClick", onTestClick)
		test:SetFullWidth(true)
		
		local reset = AceGUI:Create("Button")
		reset:SetText("Reset positions")
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
	local scanner = CreateFrame("GameTooltip")
	scanner:SetOwner(WorldFrame, "ANCHOR_NONE")
	local lcache, rcache = {}, {}
	for i = 1, 4 do
		lcache[i], rcache[i] = scanner:CreateFontString(), scanner:CreateFontString()
		lcache[i]:SetFontObject(GameFontNormal); rcache[i]:SetFontObject(GameFontNormal)
		scanner:AddFontStrings(lcache[i], rcache[i])
	end
	function getSpellDescription(spellId)
		scanner:ClearLines()
		scanner:SetHyperlink("spell:"..spellId)
		for i = scanner:NumLines(), 1, -1  do
			local desc = lcache[i] and lcache[i]:GetText()
			if desc then return desc end
		end
	end
end

local function fillBossOptions(module)
	local customBossOptions = BigWigs:GetCustomBossOptions()
	local config = {
		type = "group",
		name = module.displayName,
		desc = ("Options for %s."):format(module.displayName),
		get = function(info) return module.db.profile[info[#info]] end,
		set = function(info, v) module.db.profile[info[#info]] = v end,
		args = {},
	}
	local order = 1
	for i, v in next, module.toggleOptions do
		local t = type(v)
		if module.optionHeaders and module.optionHeaders[v] then
			local n
			if type(module.optionHeaders[v]) == "number" then
				n = GetSpellInfo(module.optionHeaders[v])
			else
				n = module.optionHeaders[v]
			end
			config.args[v .. "_header"] = {
				type = "header",
				name = n,
				order = order,
				width = "full",
			}
			order = order + 1
		end
		if t == "number" and v < 0 then
			config.args["separator" .. i] = {
				type = "description",
				order = order,
				name = " ",
				width = "full",
			}
			order = order + 1
		elseif t == "number" and v > 0 then
			local spellName, _, icon = GetSpellInfo(v)
			if not spellName then error(("Invalid option %d in module %s."):format(v, module.displayName)) end
			local desc = getSpellDescription(v)
			config.args[spellName] = {
				type = "toggle",
				name = spellName,
				desc = desc,
				order = order,
				width = "full",
				--[[image = icon,
				imageWidth = 16,
				imageHeight = 16,]]
				descStyle = "inline",
			}
			order = order + 1
		elseif t == "string" then
			local ML = module.locale
			local optName, optDesc, optOrder
			if customBossOptions[v] then
				optName = customBossOptions[v][1]
				optDesc = customBossOptions[v][2]
			elseif ML then
				optName = ML[v]
				local descKey = v.."_desc" -- String concatenation ftl! Not sure how we can get rid of this.
				optDesc = ML[descKey] or v
			end
			if optName then
				config.args[v] = {
					type = "toggle",
					order = order,
					name = optName,
					desc = optDesc,
					width = "full",
				}
				order = order + 1
			end
		end
	end
	return config
end

local zoneOptions = {}
local flagforloadbutton = {}

local function loadZone(k, v)
	local zone = k.arg
	BigWigsLoader:LoadZone(zone)
	acr:NotifyChange(zone)
end

local zoneModules = {}

local function populateZoneOptions(uiType, library, zone)
	zoneOptions[zone] = zoneOptions[zone] or {
		type = "group",
		childGroups = "select",
		args = {},
	}
	-- add us a load button
	zoneOptions[zone].args.load = {
		name = L["Load"],
		desc = L["Load all %s modules."]:format(zone),
		order = 1,
		type = "execute",
		func = loadZone,
		disabled = function() return not BigWigsLoader:HasZone(zone) end,
		arg = zone
	}
	for i, module in next, zoneModules[zone] do
		if not zoneOptions[zone].args[module.name] then
			zoneOptions[zone].args[module.name] = fillBossOptions(module)
		end
	end
	wipe(zoneModules[zone])
	return zoneOptions[zone]
end

function SetZoneMenus(zones)
	for zone, v in pairs(zones) do
		if not zoneModules[zone] then
			ac:RegisterOptionsTable(zone, populateZoneOptions)
			acd:AddToBlizOptions(zone, zone, "Big Wigs")
			zoneModules[zone] = {}
		end
	end
end

local registered = {}
function options:BigWigs_BossModuleRegistered(message, moduleName, module)
	if registered[module.name] then return end
	registered[module.name] = true
	if not module.toggleOptions then return end
	local zone = module.otherMenu or module.zoneName
	if not zone then print(module.name) end
	if not zoneModules[zone] then
		ac:RegisterOptionsTable(zone, populateZoneOptions)
		acd:AddToBlizOptions(zone, zone, "Big Wigs")
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

