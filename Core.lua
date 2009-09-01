------------------------------
--      Are you local?      --
------------------------------

local bboss = LibStub("LibBabble-Boss-3.0")
local bzone = LibStub("LibBabble-Zone-3.0")

local GetSpellInfo = GetSpellInfo
local BZ = bzone:GetUnstrictLookupTable()
local BB = bboss:GetUnstrictLookupTable()
local BBR = bboss:GetReverseLookupTable()

-- Set two globals to make it easier on the boss modules.
_G.BZ = bzone:GetLookupTable()
_G.BB = bboss:GetLookupTable()

local AL = LibStub("AceLocale-3.0")
local AL2 = AceLibrary("AceLocale-2.2") -- used for backwards compat
local L = AL:GetLocale("BigWigs")
local icon = LibStub("LibDBIcon-1.0", true)

local ac = LibStub("AceConfig-3.0")
local acd = LibStub("AceConfigDialog-3.0")

local customBossOptions = {}
local pName = UnitName("player")

---------------------------------
--      Addon Declaration      --
---------------------------------

BigWigs = AceLibrary("AceAddon-2.0"):new(
	"AceEvent-2.0",
	"AceModuleCore-2.0",
	"AceConsole-2.0",
	"AceDB-2.0"
)

BigWigs.revision = tonumber(("$Revision$"):sub(12, -3))
local BigWigs = BigWigs

BigWigs:SetModuleMixins("AceEvent-2.0")

local acOptions = {
	type = "group",
	name = "Big Wigs",
	args = {
		heading = {
			type = "description",
			name = "Welcome to Big Wigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group.\n\nLets try to put the most common toggle options right here in the root. Below are some examples, but others could include things like showing anchors, toggling the proximity monitor and toggling sounds, for example.\n\nClicking the LDB plugin should pop open the interface options, expand our toplevel category and select the relevant zone and boss module that is currently active, just like we used to do with Waterfall.",
			fontSize = "medium",
			order = 1,
			width = "full",
		},
		enable = {
			type = "toggle",
			name = "Enable",
			desc = "NOOP Mooses don't appreciate being prodded with long pointy sticks.",
			order = 2,
			get = function() return true end,
			set = function() end,
			width = "full",
		},
		whispers = {
			type = "toggle",
			name = "Whisper warnings",
			desc = "NOOP Toggles whether you will send a whisper notification to fellow players about certain boss encounter abilities that affect them personally. Think 'bomb'-type effects and such.",
			order = 3,
			get = function() return true end,
			set = function() end,
			width = "full",
		},
		note = {
			type = "description",
			name = "This looks horrible, here's what I want:\n\n1. spacer between heading and options.\n2. The description for each checkbox should be in smaller text below the checkbox, indented to be parallel vertically with the checkbox label. This text should also be smaller than the label and probably in the same color as the header.",
			fontSize = "medium",
			order = 4,
			width = "full",
		},
	},
}

local options = {
	type = "group",
	handler = BigWigs,
	args = {
		extras = {
			type = "group",
			name = L["Extras"],
			desc = L["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."],
			args = {},
			order = 203,
		},
		advanced = {
			type = "group",
			name = L["Advanced"],
			desc = L["You shouldn't really need to touch these options, but if you want to tweak them then you're welcome to do so!"],
			args = {},
			order = 203,
		},
		minimap = {
			type = "toggle",
			name = L["Minimap icon"],
			desc = L["Toggle show/hide of the minimap icon."],
			get = function() return not _G.BigWigsDB.minimap.hide end,
			set = function(v)
				if v then
					_G.BigWigsDB.minimap.hide = nil
					icon:Show("BigWigs")
				else
					_G.BigWigsDB.minimap.hide = true
					icon:Hide("BigWigs")
				end
			end,
			order = 205,
			hidden = function() return not icon end,
		},
	},
}

BigWigs.cmdtable = options

------------------------------
--      Initialization      --
------------------------------

function BigWigs:OnInitialize()
	self:RegisterDB("BigWigsDB")

	self:RegisterChatCommand("/bw", "/BigWigs", options, "BIGWIGS")

	if not self.version then self.version = GetAddOnMetadata("BigWigs", "Version") end
	self.version = (self.version or "2.0") .. " |cffff8888r" .. self.revision .. "|r"

	self:RegisterBossOption("bosskill", L["bosskill"], L["bosskill_desc"])
	self:RegisterBossOption("enrage", L["enrage"], L["enrage_desc"])
	self:RegisterBossOption("berserk", L["berserk"], L["berserk_desc"])

	ac:RegisterOptionsTable("BigWigs", acOptions)
	acd:AddToBlizOptions("BigWigs", "Big Wigs")
end

function BigWigs:OnEnable(first)
	-- We only really enable ourselves if we are told to do so by BigWigsLoD.
	if not first then
		-- this will trigger the LoadWithCore to load
		self:TriggerEvent("BigWigs_CoreEnabled")

		-- Enable all disabled modules that are not boss modules.
		for name, module in self:IterateModules() do
			if type(module.IsBossModule) ~= "function" or not module:IsBossModule() then
				self:ToggleModuleActive(module, true)
			end
		end

		self:RegisterEvent("BigWigs_TargetSeen")
		self:RegisterEvent("BigWigs_RebootModule")
		self:RegisterEvent("BigWigs_RecvSync")
	else
		self:ToggleActive(false)
	end
end

function BigWigs:OnDisable()
	-- Disable all modules
	for name, module in self:IterateModules() do
		self:ToggleModuleActive(module, false)
	end

	self:TriggerEvent("BigWigs_CoreDisabled")
end

-------------------------------
--      API                  --
-------------------------------

function BigWigs:RegisterBossOption(key, name, desc, func)
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
	local active = {
		type = "toggle",
		name = L["Active"],
		order = 1,
		desc = L["Activate or deactivate this module."],
	}
	local headerSpacer = {
		type = "header",
		order = 50,
		name = " ",
	}
	local zoneModules = {}

	-- A wrapper for :NewModule to present users with more information in the
	-- case where a module with the same name has already been registered.
	function BigWigs:New(module, revision, ...)
		local r = nil
		if type(revision) == "string" then r = tonumber(revision:sub(12, -3))
		else r = revision end
		if type(r) ~= "number" then
			error(("Trying to register module %q without a valid revision."):format(module))
		end
		if self.modules[module] then
			local oldM = self:GetModule(module)
			print(L["already_registered"]:format(module, oldM.revision, r))
		else
			local m = self:NewModule(module, ...)
			m.revision = r
			return m
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
				config.args[spellName] = {
					type = "toggle",
					name = spellName,
					desc = L["Toggles whether or not the boss module should warn about %s."]:format(spellName),
					order = order,
					width = "full",
				}
				order = order + 1
				local desc = getSpellDescription(v)
				if desc and #desc > 10 then
					config.args[spellName .. "_description"] = {
						type = "description",
						name = desc,
						order = order,
						image = icon,
						imageWidth = 16,
						imageHeight = 16,
						width = "full",
						fontSize = "small",
					}
					order = order + 1
				end
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

	-- We can't use the AceModuleCore :OnModuleCreated, since the properties on the
	-- module has not been set when it's triggered.
	function BigWigs:RegisterModule(module)
		local name = module.name
		local rev = module.revision
		if type(rev) ~= "number" then
			error(("%q does not have a valid revision field."):format(name))
		end

		if module:IsBossModule() then
			self:ToggleModuleActive(module, false)
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
			self:RegisterDefaults(name, "profile", opts)
			for i in ipairs(opts) do opts[i] = nil end
			module.db = self:AcquireDBNamespace(name)
		elseif type(module.defaultDB) == "table" then
			self:RegisterDefaults(name, "profile", module.defaultDB)
			module.db = self:AcquireDBNamespace(name)
		end

		if module.toggleOptions then
			local zone = nil
			if module.otherMenu then
				zone = BZ[module.otherMenu]
			else
				zone = type(module.zonename) == "table" and module.zonename[1] or module.zonename
			end
			if zone then
				if not zoneModules[zone] then
					ac:RegisterOptionsTable(zone, populateZoneOptions)
					acd:AddToBlizOptions(zone, zone, "Big Wigs")
					zoneModules[zone] = {}
				end
				tinsert(zoneModules[zone], module)
			end
		elseif module.consoleOptions then
			if module.external then
				options.args.extras.args[module.consoleCmd or name] = module.consoleOptions
			else
				options.args[module.consoleCmd or name] = module.consoleOptions
				options.args[module.consoleCmd or name].order = 202
			end
		elseif module.pluginOptions then
			options.args[module.consoleCmd or name] = module.pluginOptions
			options.args[module.consoleCmd or name].order = 202
		elseif module.advancedOptions then
			options.args.advanced.args[module.consoleCmd or name] = module.advancedOptions
		end

		if type(module.OnRegister) == "function" then
			module:OnRegister()
		end

		self:TriggerEvent("BigWigs_ModuleRegistered", name)
	end
end

function BigWigs:EnableModule(moduleName, noSync)
	local m = self:GetModule(moduleName)
	if m and m:IsBossModule() and not self:IsModuleActive(m) then
		self:ToggleModuleActive(m, true)
		if not noSync then
			local token = m.synctoken or BBR[moduleName] or nil
			if not token then return end
			m:Sync(m.external and "EnableExternal" or "EnableModule", token)
		end
	end
end

function BigWigs:BigWigs_RebootModule(module)
	self:ToggleModuleActive(module, false)
	self:ToggleModuleActive(module, true)
end

function BigWigs:BigWigs_RecvSync(sync, module, sender)
	if not module then return end
	if sync == "EnableModule" or sync == "EnableExternal" then
		if sender == pName then return end
		local name = BB[module] or module
		if self:HasModule(name) then
			self:EnableModule(name, true)
		end
	elseif (sync == "Death" or sync == "MultiDeath") and self:HasModule(module) and self:IsModuleActive(module) then
		local mod = self:GetModule(module)
		if mod.db.profile.bosskill then
			if sync == "Death" then
				mod:Message(L["%s has been defeated"]:format(module), "Bosskill", nil, "Victory")
			else
				mod:Message(L["%s have been defeated"]:format(module), "Bosskill", nil, "Victory")
			end
		end
		mod:TriggerEvent("BigWigs_RemoveRaidIcon")
		self:ToggleModuleActive(mod, false)
	end
end

function BigWigs:BigWigs_TargetSeen(mobname, unit, moduleName)
	local m = self:GetModule(moduleName)
	if not m then return end
	if self:IsModuleActive(m) then return end
	if not m.VerifyEnable or m:VerifyEnable(unit) then
		self:EnableModule(moduleName)
	end
end


