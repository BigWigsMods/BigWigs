BigWigs = LibStub("AceAddon-3.0"):NewAddon("BigWigs", "AceEvent-3.0")
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
local AL2 = AceLibrary("AceLocale-2.2") -- used for backwards compat
local L = AL:GetLocale("BigWigs")
local icon = LibStub("LibDBIcon-1.0", true)

local ac = LibStub("AceConfig-3.0")
local acd = LibStub("AceConfigDialog-3.0")

local customBossOptions = {}
local pName = UnitName("player")


BigWigs.revision = tonumber(("$Revision$"):sub(12, -3))

local pluginOptions = {
	type = "group",
	childGroups = "tab",
	args = {},
}

local acOptions = {
	type = "group",
	name = "Big Wigs",
	args = {
		heading = {
			type = "description",
			name = "Welcome to Big Wigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group.\n\n|cffff0000Note that some (!) of these options do not work at the moment. Please don't file bug reports for things concerning the Big Wigs interface right now, come talk to us on IRC instead.|r\n",
			fontSize = "medium",
			order = 1,
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

				-- Enable all disabled modules that are not boss modules.
				BigWigs.pluginCore:Enable()
				for name, module in BigWigs:IteratePlugins() do
					module:Enable()
				end
				BigWigs:SendMessage("BigWigs_TemporaryConfig")
			end,
			order = 10,
			width = "full",
		},
		separator = {
			type = "description",
			name = " ",
			order = 20,
			width = "full",
		},
		whispers = {
			type = "toggle",
			name = "Whisper warnings |cffff0000(!)|r",
			desc = "Toggles whether you will send a whisper notification to fellow players about certain boss encounter abilities that affect them personally. Think 'bomb'-type effects and such.",
			order = 31,
			get = function() return true end,
			set = function() end,
			width = "full",
		},
		raidicons = {
			type = "toggle",
			name = "Raid icons |cffff0000(!)|r",
			desc = "Some boss modules use raid icons to mark players in your group that are of special interest to your raid. Things like 'bomb'-type effects and mind control are examples of this. If you turn this off, you won't mark anyone. Note that you need to be promoted to assistant or be the raid leader in order to set these raid icons.",
			order = 32,
			get = function() return true end,
			set = function() end,
			width = "full",
		},
		sound = {
			type = "toggle",
			name = "Sound |cffff0000(!)|r",
			desc = "Some boss messages come with warning sounds of different kinds. Some people find it easier to just listen for these sounds after they've learned which sound goes with which message, instead of reading the actual message on screen.",
			order = 33,
			get = function() return true end,
			set = function() end,
			width = "full",
		},
		separator2 = {
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
			get = function() return not BigWigs.db.profile.minimap.hide end,
			set = function(info, v)
				if v then
					BigWigs.db.profile.minimap.hide = nil
					icon:Show("BigWigs")
				else
					BigWigs.db.profile.minimap.hide = true
					icon:Hide("BigWigs")
				end
			end,
			hidden = function() return not icon end,
			width = "full",
		},
		footer = {
			type = "description",
			name = "\n\n\n|cffccccccMooses don't appreciate being prodded with long pointy sticks.\nContact us on #wowace. [Ammo] and vhaarr can service all your needs.|r",
			order = 42,
			width = "full",
		},
	},
}

------------------------------
--      Initialization      --
------------------------------

function addon:OnInitialize()
	local defaults = {
		profile = {}
	}
	self.db = LibStub("AceDB-3.0"):New("BigWigs3DB", defaults, "Default")

	if not self.version then self.version = GetAddOnMetadata("BigWigs", "Version") end
	self.version = (self.version or "2.0") .. " |cffff8888r" .. self.revision .. "|r"
	
	-- once OnInitialize is fired, we have BZ and BB available if we're not in english locale
	if LOCALE ~= "enUS" then
		BZ = LibStub("LibBabble-Zone-3.0"):GetLookupTable()
		BB = LibStub("LibBabble-Boss-3.0"):GetLookupTable()
	end

	self:RegisterBossOption("bosskill", L["bosskill"], L["bosskill_desc"])
	self:RegisterBossOption("enrage", L["enrage"], L["enrage_desc"])
	self:RegisterBossOption("berserk", L["berserk"], L["berserk_desc"])

	BigWigsLoader:RemoveInterfaceOptions()
	
	ac:RegisterOptionsTable("BigWigs", acOptions)
	acd:AddToBlizOptions("BigWigs", "Big Wigs")
	ac:RegisterOptionsTable("Big Wigs: Plugins", pluginOptions)
	acd:AddToBlizOptions("Big Wigs: Plugins", "Customize ...", "Big Wigs")
	
	-- this should ALWAYS be the last action of OnInitialize, it will trigger the loader to 
	-- enable the foreign language pack, and other packs that want to be loaded when the core loads
	self:SendMessage("BigWigs_CoreLoaded")
end

function addon:OnEnable()
	self:SendMessage("BigWigs_CoreEnabled")
	
	-- enable modules that require enabling
	-- the cores etc are set to disabled by default, and require manual enabling
	self.pluginCore:Enable() 
	self.bossCore:Enable() 
	
	self:RegisterMessage("BigWigs_TargetSeen")
	self:RegisterMessage("BigWigs_RebootModule")
	self:RegisterMessage("BigWigs_RecvSync")
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

function addon:RegisterBossOption(key, name, desc, func)
	if customBossOptions[key] then
		error("The custom boss option %q has already been registered."):format(key)
	end
	customBossOptions[key] = { name, desc, func }
end

-------------------------------
--      Module Handling      --
-------------------------------

do
	local opts = {}
	local zoneModules = {}

	-- A wrapper for :NewModule to present users with more information in the
	-- case where a module with the same name has already been registered.
	function addon:NewBoss(module, revision, ...)
		local r = nil
		if type(revision) == "string" then r = tonumber(revision:sub(12, -3))
		else r = revision end
		if type(r) ~= "number" then
			error(("Trying to register module %q without a valid revision."):format(module))
		end
		if self:GetBossModule(module, true) then
			local oldM = self:GetBossModule(module)
			print(L["already_registered"]:format(module, oldM.revision, r))
		else
			local m = self.bossCore:NewModule(module, ...)
			m.revision = r
			return m
		end
	end

	function addon:New(module, revision, ...)
		error(("Module %q, using deprecated :New() API. Notify the author for an update."):format(module))
	end
	
	function addon:NewPlugin(module, revision, ...)
		local r = nil
		if type(revision) == "string" then r = tonumber(revision:sub(12, -3))
		else r = revision end
		if type(r) ~= "number" then
			error(("Trying to register module %q without a valid revision."):format(module))
		end
		if self:GetPlugin(module, true) then
			local oldM = self:GetPlugin(module)
			print(L["already_registered"]:format(module, oldM.revision, r))
		else
			local m = self.pluginCore:NewModule(module, ...)
			m.revision = r
			return m
		end
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
			name = module.name,
			desc = L["Options for %s (r%d)."]:format(module.name, module.revision),
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
				if not spellName then error(("Invalid option %d in module %s."):format(v, module.name)) end
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
				local alEntry = "BigWigs"..module.name
				local ML, ML2 = nil, nil
				if AL2.registry[alEntry] then
					ML2 = AL2:new(alEntry)
				elseif AL:GetLocale(alEntry, true) then
					ML = AL:GetLocale(alEntry)
				end
				local optName, optDesc, optOrder
				if customBossOptions[v] then
					optName = customBossOptions[v][1]
					optDesc = customBossOptions[v][2]
				elseif ML2 then
					optName = ML2:HasTranslation(v) and ML2[v]
					local descKey = v.."_desc" -- String concatenation ftl! Not sure how we can get rid of this.
					optDesc = ML2:HasTranslation(descKey) and ML2[descKey] or v
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
	local function populateZoneOptions(uiType, library, zone)
		zoneOptions[zone] = zoneOptions[zone] or {
			type = "group",
			childGroups = "select",
			args = {},
		}
		for i, module in next, zoneModules[zone] do
			if not zoneOptions[zone].args[module.name] then
				zoneOptions[zone].args[module.name] = fillBossOptions(module)
			end
		end
		wipe(zoneModules[zone])
		return zoneOptions[zone]
	end

	function addon:RegisterBossModule(module)
		local name = module.name
		local rev = module.revision
		if type(rev) ~= "number" then
			error(("%q does not have a valid revision field."):format(name))
		end

		
		if module.toggleOptions then
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
			for i in ipairs(opts) do opts[i] = nil end
		elseif type(module.defaultDB) == "table" then
			module.db = self.db:RegisterNamespace(name, { profile = module.defaultDB } )
		end
		
		-- Translate the bossmodule if appropriate
		if LOCALE ~= "enUS" and BB and BZ then
			if type(module.bossName) == "table" then
				for k, boss in pairs(module.bossName) do
					module.bossName[k] = BB[boss] or boss
				end
			else
				module.bossName = BB[module.bossName] or module.bossName
			end
			if type(module.zoneName) == "table" then
				for k, zone in pairs(module.zoneName) do
					module.zoneName[k] = BZ[zone] or zone
				end
			else
				module.zoneName = BZ[module.zoneName] or module.zoneName
			end
			if module.otherMenu then
				module.otherMenu = BZ[module.otherMenu]
			end
		end
		if not module.displayName then -- fix up a pretty display name
			if type(module.bossName) == "table" then
				module.displayName = table.concat(module.bossName, ", ")
			else
				module.displayName = module.bossName
			end
		end
		if module.toggleOptions then
			local zone = nil
			if module.otherMenu then
				zone = module.otherMenu
			else
				zone = type(module.zoneName) == "table" and module.zoneName[1] or module.zoneName
			end
			if zone then
				if not zoneModules[zone] then
					ac:RegisterOptionsTable(zone, populateZoneOptions)
					acd:AddToBlizOptions(zone, zone, "Big Wigs")
					zoneModules[zone] = {}
				end
				tinsert(zoneModules[zone], module)
			end
		elseif module.pluginOptions then
			pluginOptions.args[name] = module.pluginOptions
		end
	
		-- Call the module's OnRegister (which is our OnInitialize replacement)
		if type(module.OnRegister) == "function" then
			module:OnRegister()
		end
		self:SendMessage("BigWigs_BossModuleRegistered", name, module)
	end
	
	-- FIXME: this is a straight copy of RegisterBossModule just to get this working quick
	function addon:RegisterPlugin(module)
		local name = module.name
		local rev = module.revision
		if type(rev) ~= "number" then
			error(("%q does not have a valid revision field."):format(name))
		end
		
		if module.toggleOptions then
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
			module.db = self.db:RegisterNamespace(name, opts)
			for i in ipairs(opts) do opts[i] = nil end
		elseif type(module.defaultDB) == "table" then
			module.db = self.db:RegisterNamespace(name, { profile = module.defaultDB } )
		end
		
		-- Translate the bossmodule if appropriate
		if LOCALE ~= "enUS" and BB and BZ then
			if type(module.bossName) == "table" then
				for k, boss in pairs(module.bossName) do
					module.bossName[k] = BB[boss] or boss
				end
			else
				module.bossName = BB[module.bossName] or module.bossName
			end
			if type(module.zoneName) == "table" then
				for k, zone in pairs(module.zoneName) do
					module.zoneName[k] = BZ[zone] or zone
				end
			else
				module.zoneName = BZ[module.zoneName] or module.zoneName
			end
			if module.otherMenu then
				module.otherMenu = BZ[module.otherMenu]
			end
		end
		if not module.displayName then -- fix up a pretty display name
			if type(module.bossName) == "table" then
				module.displayName = table.concat(module.bossName, ", ")
			else
				module.displayName = module.bossName
			end
		end
		if module.toggleOptions then
			local zone = nil
			if module.otherMenu then
				zone = module.otherMenu
			else
				zone = type(module.zoneName) == "table" and module.zoneName[1] or module.zoneName
			end
			if zone then
				if not zoneModules[zone] then
					ac:RegisterOptionsTable(zone, populateZoneOptions)
					acd:AddToBlizOptions(zone, zone, "Big Wigs")
					zoneModules[zone] = {}
				end
				tinsert(zoneModules[zone], module)
			end
		elseif module.pluginOptions then
			pluginOptions.args[name] = module.pluginOptions
		end
	
		-- Call the module's OnRegister (which is our OnInitialize replacement)
		if type(module.OnRegister) == "function" then
			module:OnRegister()
		end
		self:SendMessage("BigWigs_PluginRegistered", name, module)
	end
	
end

function addon:EnableBossModule(moduleName, noSync)
	local m = self:GetBossModule(moduleName, true)
	if m and not m:IsEnabled() then
		m:Enable()
		if not noSync then
			local token = moduleName or nil
			if not token then return end
			m:Sync(m.external and "EnableExternal" or "EnableModule", token)
		end
	end
end

function addon:BigWigs_RebootModule(message, module)
	local mod = self:GetBossModule(module)
	mod:Disable()
	mod:Enable()
end

function addon:BigWigs_RecvSync(message, sync, module, sender)
	if not module then return end
	if sync == "EnableModule" or sync == "EnableExternal" then
		if sender == pName then return end
		if self:GetBossModule(module, true) then
			self:EnableBossModule(module, true)
		end
	elseif (sync == "Death" or sync == "MultiDeath") then
		local mod = self:GetBossModule(module, true)
		if mod and mod:IsEnabled() then
			if mod.db.profile.bosskill then
				if sync == "Death" then
					mod:Message(L["%s has been defeated"]:format(module), "Bosskill", nil, "Victory")
				else
					mod:Message(L["%s have been defeated"]:format(module), "Bosskill", nil, "Victory")
				end
			end
			mod:PrimaryIcon(false)
			mod:SecondaryIcon(false)
			mod:Disable()
		end
	end
end

function addon:BigWigs_TargetSeen(message, mobname, unit, moduleName)
	local m = self:GetBossModule(moduleName)
	if not m or m:IsEnabled() then return end
	if not m.VerifyEnable or m:VerifyEnable(unit) then
		self:EnableBossModule(m)
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

