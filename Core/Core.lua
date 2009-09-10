BigWigs = LibStub("AceAddon-3.0"):NewAddon("BigWigs", "AceEvent-3.0", "AceTimer-3.0")
local addon = BigWigs

addon:SetEnabledState(false) -- we're disabled by default
addon:SetDefaultModuleState(false) -- our modules too


-- locale stuff for BZ or BB conditionals
local LOCALE = GetLocale()
if LOCALE == "enGB" then
	LOCALE = "enUS"
end
local BB, BZ

local GetSpellInfo = GetSpellInfo

local AL = LibStub("AceLocale-3.0")
local L = AL:GetLocale("BigWigs")
local icon = LibStub("LibDBIcon-1.0", true)

local ac = LibStub("AceConfig-3.0")
local acr = LibStub("AceConfigRegistry-3.0")
local acd = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")

local customBossOptions = {}
local pName = UnitName("player")


BigWigs.revision = tonumber(("$Revision$"):sub(12, -3))

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
		BigWigs.db.profile[info[#info]] = value
	end,
	args = {
		heading = {
			type = "description",
			name = "Welcome to Big Wigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group.\n\n|cffff0000Note that some (!) of these options do not work at the moment. Please don't file bug reports for things concerning the Big Wigs interface right now, come talk to us on IRC instead.|r\n",
			fontSize = "medium",
			order = 10,
			width = "full",
		},
		configure = {
			type = "execute",
			name = "Configure ...",
			desc = "Closes the interface options window and lets you configure displays for things like bars and messages.",
			func = function()
				-- This won't hide the game menu if you opened options from there.
				-- We don't care yet, this is temporary.
				InterfaceOptionsFrame:Hide()

				if not BigWigs:IsEnabled() then
					print("This is weird, we're accessing the options but BigWigs is not enabled.")
					return
				end
				BigWigs:SendMessage("BigWigs_StartConfigureMode")
				BigWigs:SendMessage("BigWigs_SetConfigureTarget", BigWigs:GetPlugin("Bars"))
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
			name = "Sound |cffff0000(!)|r",
			desc = "Messages might come with warning sounds of different kinds. Some people find it easier to just listen for these sounds after they've learned which sound goes with which message, instead of reading the actual message on screen.",
			order = 21,
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
			name = "Raid icons |cffff0000(!)|r",
			desc = "Some boss modules use raid icons to mark players in your group that are of special interest to your raid. Things like 'bomb'-type effects and mind control are examples of this. If you turn this off, you won't mark anyone.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r",
			order = 31,
			width = "full",
		},
		whisper = {
			type = "toggle",
			name = "Whisper warnings |cffff0000(!)|r",
			desc = "Send a whisper notification to fellow players about certain boss encounter abilities that affect them personally. Think 'bomb'-type effects and such.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r",
			order = 32,
			width = "full",
		},
		broadcast = {
			type = "toggle",
			name = "Broadcast |cffff0000(!)|r",
			desc = "Broadcast all messages from Big Wigs to the raid warning channel.\n\n|cffff4411Only applies if you are the group leader, NOT if you are promoted!|r",
			order = 33,
			width = "full",
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

-------------------------------------------------------------------------------
-- Events
--

local function enableBossModule(module, noSync)
	if not module:IsEnabled() then
		module:Enable()
		-- XXX DEBUG
		module:SendMessage("BigWigs_Message", string.format("Enabled: %q", module.displayName), "Core")
		if not noSync then
			module:Sync("EnableModule", module:GetName())
		end
	end
end

local function rebootModule(message, module)
	if not module then return end
	module:Disable()
	module:Enable()
end

-- Since this is from addon comms, it's the only place where we allow the module NAME to be passed, instead of the
-- actual module object. ALL other APIs should take module objects as arguments.
local function recvSync(message, sync, moduleName, sender)
	if not moduleName then return end
	if sync == "EnableModule" then
		if sender == pName then return end
		local module = BigWigs:GetBossModule(moduleName, true)
		if not module then return end
		enableBossModule(module, true)
	elseif (sync == "Death" or sync == "MultiDeath") then
		local mod = BigWigs:GetBossModule(moduleName, true)
		if mod and mod:IsEnabled() then
			if mod.db.profile.bosskill then
				mod:IfMessage(L["%s has been defeated"]:format(mod.displayName), "Bosskill", nil, "Victory")
			end
			mod:PrimaryIcon(false)
			mod:SecondaryIcon(false)
			mod:Disable()
		end
	end
end

local function targetSeen(message, unit, module)
	if not module or module:IsEnabled() then return end
	if not module.VerifyEnable or module:VerifyEnable(unit) then
		enableBossModule(module)
	end
end

------------------------------
--      Initialization      --
------------------------------

function addon:OnInitialize()
	local defaults = {
		profile = {
			sound = true,
			raidicon = true,
			whisper = false,
			raidwarning = false,
			broadcast = false,
		}
	}
	self.db = LibStub("AceDB-3.0"):New("BigWigs3DB", defaults, true)

	if not self.version then self.version = GetAddOnMetadata("BigWigs", "Version") end
	self.version = (self.version or "2.0") .. " |cffff8888r" .. self.revision .. "|r"

	if LOCALE ~= "enUS" and ( not BZ or not BB ) and LibStub("LibBabble-Boss-3.0", true) and LibStub("LibBabble-Zone-3.0", true) then
		BZ = LibStub("LibBabble-Zone-3.0"):GetUnstrictLookupTable()
		BB = LibStub("LibBabble-Boss-3.0"):GetUnstrictLookupTable()
	end
	
	self:RegisterBossOption("bosskill", L["bosskill"], L["bosskill_desc"])
	self:RegisterBossOption("berserk", L["berserk"], L["berserk_desc"])

	BigWigsLoader:RemoveInterfaceOptions()

	ac:RegisterOptionsTable("BigWigs", acOptions)
	acd:AddToBlizOptions("BigWigs", "Big Wigs")
	ac:RegisterOptionsTable("Big Wigs: Plugins", pluginOptions)
	acd:AddToBlizOptions("Big Wigs: Plugins", "Customize ...", "Big Wigs")
	
	-- this should ALWAYS be the last action of OnInitialize, it will trigger the loader to 
	-- enable the foreign language pack, and other packs that want to be loaded when the core loads
	self:SendMessage("BigWigs_CoreLoaded")
	self.OnInitialize = nil
end

function addon:OnEnable()
	if LOCALE ~= "enUS" and (not BZ or not BB) then
		BZ = LibStub("LibBabble-Zone-3.0"):GetUnstrictLookupTable()
		BB = LibStub("LibBabble-Boss-3.0"):GetUnstrictLookupTable()
	end
	self:RegisterMessage("BigWigs_TargetSeen", targetSeen)
	self:RegisterMessage("BigWigs_RebootModule", rebootModule)
	self:RegisterMessage("BigWigs_RecvSync", recvSync)

	self:RegisterMessage("BigWigs_SetConfigureTarget")
	self:RegisterMessage("BigWigs_StartConfigureMode")
	self:RegisterMessage("BigWigs_StopConfigureMode")

	self:RegisterMessage("BigWigs_Test")
	
	self:SendMessage("BigWigs_CoreEnabled")
	-- enable modules that require enabling
	-- the cores etc are set to disabled by default, and require manual enabling
	self.pluginCore:Enable() 
	self.bossCore:Enable() 	
end

function addon:OnDisable()
	self:SendMessage("BigWigs_CoreDisabled")
	-- these require manual disabling
	self.pluginCore:Disable()
	self.bossCore:Disable()
end

function addon:Print(...)
	print("|cff33ff99BigWigs|r:", ...)
end

-------------------------------
--      API                  --
-------------------------------

function addon:Translate(boss)
	if LOCALE ~= "enUS" and BB and BB[boss] then return BB[boss] end
	return boss
end

function addon:RegisterBossOption(key, name, desc, func)
	if customBossOptions[key] then
		error("The custom boss option %q has already been registered."):format(key)
	end
	customBossOptions[key] = { name, desc, func }
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
		addon:SendMessage("BigWigs_SetConfigureTarget", plugin)
	end
	local function onTestClick() BigWigs:SendMessage("BigWigs_Test") end
	local function onResetClick() BigWigs:SendMessage("BigWigs_ResetPositions") end
	local function createPluginFrame()
		if frame then return end
		frame = AceGUI:Create("Window")
		frame:SetWidth(320)
		frame:SetHeight(640)
		frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 12, -12)
		frame:SetTitle("Configure")
		frame:SetCallback("OnClose", function(widget, callback)
			addon:SendMessage("BigWigs_StopConfigureMode")
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
	function addon:BigWigs_SetConfigureTarget(event, module)
		tabs:SelectTab(module:GetName())
	end

	function addon:InConfigureMode() return configMode end
	function addon:BigWigs_StartConfigureMode(event)
		configMode = true
		createPluginFrame()
		frame:Show()
	end

	function addon:BigWigs_StopConfigureMode()
		configMode = nil
		frame:Hide()
		frame:ReleaseChildren()
		frame:Release()
		frame = nil
		wipe(plugins)
	end
end

-------------------------------
--      Module Handling      --
-------------------------------

do
	function addon:New(module)
		error(("Module %q, using deprecated :New() API. Notify the author for an update."):format(module))
	end

	local zoneModules = {}

	local function new(core, module, zone, ...)
		if core:GetModule(module, true) then
			local oldM = core:GetModule(module)
			print(L["already_registered"]:format(module, core.moduleName))
		else
			local m = core:NewModule(module, ...)
			if zone then m.zoneName = zone end
			return m
		end
	end

	-- A wrapper for :NewModule to present users with more information in the
	-- case where a module with the same name has already been registered.
	function addon:NewBoss(module, zone, ...)
		return new(self.bossCore, module, zone, ...)
	end
	function addon:NewPlugin(module, ...)
		return new(self.pluginCore, module, nil, ...)
	end
	
	function addon:IterateBossModules() return self.bossCore:IterateModules() end
	function addon:GetBossModule(...) return self.bossCore:GetModule(...) end
	
	function addon:IteratePlugins() return self.pluginCore:IterateModules() end
	function addon:GetPlugin(...) return self.pluginCore:GetModule(...) end

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
		local scannerCache = {}
		function getSpellDescription(spellId)
			scanner:ClearLines()
			scanner:SetHyperlink("spell:"..spellId)
			for k in pairs(scannerCache) do scannerCache[k] = nil end
			for i = scanner:NumLines(), 1, -1  do
				local desc = lcache[i] and lcache[i]:GetText()
				if desc then return desc end
			end
		end
	end

	local function fillBossOptions(module)
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

	-- called from the loader
	function addon:SetZoneMenus(zones)
		for zone, v in pairs(zones) do
			if not zoneModules[zone] then
				ac:RegisterOptionsTable(zone, populateZoneOptions)
				acd:AddToBlizOptions(zone, zone, "Big Wigs")
				zoneModules[zone] = {}
			end
		end
	end
	
	function addon:RegisterBossModule(module)
		local name = module.name
		if not module.displayName then module.displayName = module.moduleName end
		
		-- Translate the bossmodule if appropriate
		if LOCALE ~= "enUS" and BB and BZ then
			module.zoneName = BZ[module.zoneName] or module.zoneName
			if module.otherMenu then
				module.otherMenu = BZ[module.otherMenu]
			end
			if module.displayName and BB[module.displayName] then
				module.displayName = BB[module.displayName]
			end
			if module.optionHeaders then
				for k, v in pairs(module.optionHeaders) do
					if type(v) == "string" and BB[v] then
						module.optionHeaders[k] = BB[v]
					end
				end
			end
		end
		
		if module.optionHeaders then
			local CL = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Common")
			for k, v in pairs(module.optionHeaders) do
				if type(v) == "string" and CL[v] then
					module.optionHeaders[k] = CL[v]
				end
			end
		end

		if module.toggleOptions then
			local opts = {}
			for i,v in next, module.toggleOptions do
				local t = type(v)
				if t == "string"  then
					opts[v] = true
				elseif t == "number" and v > 0 then
					local n = GetSpellInfo(v)
					if not n then error(("Invalid spell ID %d in the toggleOptions for module %s."):format(v, name)) end
					opts[n] = true
				end
			end
			module.db = self.db:RegisterNamespace(name, { profile = opts })

			local zone = module.otherMenu or module.zoneName
			if not zoneModules[zone] then
				ac:RegisterOptionsTable(zone, populateZoneOptions)
				acd:AddToBlizOptions(zone, zone, "Big Wigs")
				zoneModules[zone] = {}
			end
			tinsert(zoneModules[zone], module)
		end

		-- Call the module's OnRegister (which is our OnInitialize replacement)
		if type(module.OnRegister) == "function" then
			module:OnRegister()
		end
		self:SendMessage("BigWigs_BossModuleRegistered", name, module)
	end

	function addon:RegisterPlugin(module)
		local name = module.name
		if type(module.defaultDB) == "table" then
			module.db = self.db:RegisterNamespace(name, { profile = module.defaultDB } )
		end
		if module.pluginOptions then
			pluginOptions.args[name] = module.pluginOptions
		end
		-- Call the module's OnRegister (which is our OnInitialize replacement)
		if type(module.OnRegister) == "function" then
			module:OnRegister()
		end
		self:SendMessage("BigWigs_PluginRegistered", name, module)
	end
	
end

--- Test 
do
	local spells = nil
	local colors = {"Important", "Personal", "Urgent", "Attention", "Positive", "Bosskill", "Core"}
	local sounds = {"Long", "Info", "Alert", "Alarm", "Victory", false, false, false, false, false, false}
	local messageFormat = "%s: %s %s"

	local tests = {}

	local function SendTestMessage( message )
		if tests[message] then
			addon:SendMessage( unpack(tests[message]) )
			wipe(tests[message])
		end
	end

	function addon:BigWigs_Test()
		if not spells then
			spells = {}
			for i = 2, MAX_SKILLLINE_TABS do
				local _, _, offset, numSpells = GetSpellTabInfo(i)
				if not offset then break end
				for s = offset + 1, offset + numSpells do
					local spell = GetSpellName(s, BOOKTYPE_SPELL)
					tinsert(spells, spell)
				end
			end
		end
		local spell = spells[math.random(1, #spells)]
		local name, rank, icon = GetSpellInfo(spell.."()")
		local time = math.random(11, 45)
		local color = colors[math.random(1, #colors)]
		local sound = sounds[math.random(1, #sounds)]
		self:SendMessage("BigWigs_StartBar", self, name, time, icon)
		local formatted = messageFormat:format(color, name, sound and "("..sound..")" or "")
		-- FIXME: ScheduleTimer only allows for one argument
		tests[formatted] = { "BigWigs_Message", formatted, color, true, sound, nil, icon }
		self:ScheduleTimer(SendTestMessage, time, formatted )
	end
end


---- Module Cores ----

-- This is the Boss Module Core for BigWigs3
local bossCore = BigWigs:NewModule("Bosses")
BigWigs.bossCore = bossCore
bossCore:SetDefaultModuleLibraries("AceEvent-3.0", "AceTimer-3.0")
bossCore:SetDefaultModuleState(false)

function bossCore:OnDisable()
	for name, mod in self:IterateModules() do
		mod:Disable()
	end
end

-- Plugin Core for BigWigs3
local pluginCore = BigWigs:NewModule("Plugins")

BigWigs.pluginCore = pluginCore
pluginCore:SetDefaultModuleLibraries("AceEvent-3.0", "AceTimer-3.0")
pluginCore:SetDefaultModuleState(false)
function pluginCore:OnEnable()
	for name, mod in self:IterateModules() do
		mod:Enable()
	end
end

