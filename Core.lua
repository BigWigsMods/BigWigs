
------------------------------
--      Are you local?      --
------------------------------

local BZ = AceLibrary("Babble-Zone-2.0")
local BB = AceLibrary("Babble-Boss-2.0")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs")

local enablezones, enablemobs = {}, {}

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["%s mod enabled"] = true,
	["Target monitoring enabled"] = true,
	["Target monitoring disabled"] = true,
	["%s has been defeated"] = true,     -- "<boss> has been defeated"
	["%s have been defeated"] = true,    -- "<bosses> have been defeated"

	-- AceConsole strings
	["boss"] = true,
	["Bosses"] = true,
	["Options for boss modules."] = true,
	["Options for bosses in %s."] = true, -- "Options for bosses in <zone>"
	["Options for %s in %s."] = true,     -- "Options for <boss> in <zone>"
	["plugin"] = true,
	["Plugins"] = true,
	["Options for plugins."] = true,
	["toggle"] = true,
	["Active"] = true,
	["Activate or deactivate this module."] = true,
	["reboot"] = true,
	["Reboot"] = true,
	["Reboot this module."] = true,
	["debug"] = true,
	["Debugging"] = true,
	["Show debug messages."] = true,
	bosskill_cmd = "kill",
	bosskill_name = "Boss death",
	bosskill_desc = "Announce when boss is defeated",

	-- AceConsole zone commands
	["Zul'Gurub"] = "ZG",
	["Molten Core"] = "MC",
	["Blackwing Lair"] = "BWL",
	["Ahn'Qiraj"] = "AQ40",
	["Ruins of Ahn'Qiraj"] = "AQ20",
	["Onyxia's Lair"] = "Onyxia",
	["Naxxramas"] = "Naxxramas",
	["Silithus"] = true,
	["Outdoor Raid Bosses"] = "Outdoor",
	["Outdoor Raid Bosses Zone"] = "Outdoor Raid Bosses", -- DO NOT EVER TRANSLATE untill I find a more elegant option
} end)


L:RegisterTranslations("deDE", function() return {
	["%s mod enabled"] = "%s mod aktiviert",
	["Target monitoring enabled"] = "Ziel\195\188berwachung aktiviert",
	["Target monitoring disabled"] = "Ziel\195\188berwachung deaktiviert",
} end)


L:RegisterTranslations("koKR", function() return {
	["%s mod enabled"] = "%s 모듈을 시작",
	["Target monitoring enabled"] = "타겟 확인 시작",
	["Target monitoring disabled"] = "타겟 확인 꺼짐",
} end)


L:RegisterTranslations("zhCN", function() return {
	["%s mod enabled"] = "%s模块已开启",
	["Target monitoring enabled"] = "目标监视已开启",
	["Target monitoring disabled"] = "目标监视已关闭",
} end)


---------------------------------
--      Addon Declaration      --
---------------------------------

BigWigs = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDebug-2.0", "AceModuleCore-2.0", "AceConsole-2.0", "AceDB-2.0")
BigWigs:SetModuleMixins("AceDebug-2.0", "AceEvent-2.0", "CandyBar-2.0")
BigWigs:RegisterDB("BigWigsDB", "BigWigsDBPerChar")
BigWigs.cmdtable = {type = "group", handler = BigWigs, args = {
	[L"boss"] = {
		type = "group",
		name = L"Bosses",
		desc = L"Options for boss modules.",
		args = {},
	},
	[L"plugin"] = {
		type = "group",
		name = L"Plugins",
		desc = L"Options for plugins.",
		args = {},
	},
}}
BigWigs:RegisterChatCommand({"/bw", "/BigWigs"}, BigWigs.cmdtable)
BigWigs.debugFrame = ChatFrame5


--------------------------------
--      Module Prototype      --
--------------------------------

BigWigs.modulePrototype.core = BigWigs
BigWigs.modulePrototype.debugFrame = ChatFrame5
BigWigs.modulePrototype.revision = 1 -- To be overridden by the module!


function BigWigs.modulePrototype:IsBossModule()
	return self.zonename and self.enabletrigger and true
end


function BigWigs.modulePrototype:GenericBossDeath(msg)
	if msg == string.format(UNITDIESOTHER, self:ToString()) then
		if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(L"%s has been defeated", self:ToString()), "Green", nil, "Victory") end
		self.core:ToggleModuleActive(self, false)
	end
end


------------------------------
--      Initialization      --
------------------------------

function BigWigs:OnInitialize()
	for name,module in self:IterateModules() do self:RegisterModule(name,module) end
	self:RegisterEvent("ADDON_LOADED")
end


function BigWigs:OnEnable()
	self:RegisterEvent("BigWigs_RebootModule")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "EnableModule", 10)
end


-------------------------------
--      Module Handling      --
-------------------------------

function BigWigs:ADDON_LOADED(addon)
	local gname = GetAddOnMetadata(addon, "X-BigWigsModule")
	if not gname then return end

	local g = getglobal(gname)
	self:RegisterModule(g.name, g)
end


function BigWigs:RegisterModule(name,module)
	if module:IsBossModule() then self:ToggleModuleActive(module, false) end

	-- Set up DB
	local opts
	if module:IsBossModule() and module.toggleoptions then
		opts = {}
		for _,v in pairs(module.toggleoptions) do if v ~= -1 then opts[v] = true end end
	end

	if module.db then module:RegisterDefaults("profile", opts or module.defaultDB or {})
	else self:RegisterDefaults(name, "profile", opts or module.defaultDB or {}) end

	if not module.db then module.db = self:AcquireDBNamespace(name) end

	-- Set up AceConsole
	if module:IsBossModule() then
		local cons
		local zonename = type(module.zonename) == "table" and module.zonename[1] or module.zonename
		local zone = BZ:HasReverseTranslation(zonename) and L(BZ:GetReverseTranslation(zonename)) or L(zonename)
		local L2 = AceLibrary("AceLocale-2.0"):new("BigWigs"..name)
		if module.toggleoptions then
			local m = module

			cons = {
				type = "group",
				name = name,
				desc = string.format(L"Options for %s in %s.", name, zonename),
--~~ 					disabled = function() return not m.core:IsModuleActive(m) end,
				args = {
					[L"toggle"] = {
						type = "toggle",
						name = L"Active",
						order = 1,
						desc = L"Activate or deactivate this module.",
						get = function() return m.core:IsModuleActive(m) end,
						set = function() m.core:ToggleModuleActive(m) end,
					},
					[L"reboot"] = {
						type = "execute",
						name = L"Reboot",
						order = 2,
						desc = L"Reboot this module.",
						func = function() m.core:TriggerEvent("BigWigs_RebootModule", m) end,
						hidden = function() return not m.core:IsModuleActive(m) end,
					},
					[L"debug"] = {
						type = "toggle",
						name = L"Debugging",
						desc = L"Show debug messages.",
						order = 3,
						get = function() return m:IsDebugging() end,
						set = function(v) m:SetDebugging(v) end,
						hidden = function() return not m:IsDebugging() and not BigWigs:IsDebugging() end,
					},
				},
			}
			local x = 10
			for _,v in pairs(module.toggleoptions) do
				local val = v
				x = x + 1
				if x == 11 and v ~= "bosskill" then
					cons.args["headerblankspotthingy"] = {
						type = "header",
						order = 4,
					}
				end
				if v == -1 then
					cons.args["blankspacer"..x] = {
						type = "header",
						order = x,
					}
				else
					local l = v == "bosskill" and L or L2
					cons.args[l(v.."_cmd")] = {
						type = "toggle",
						order = v == "bosskill" and -1 or x,
						name = l(v.."_name"),
						desc = l(v.."_desc"),
						get = function() return m.db.profile[val] end,
						set = function(v) m.db.profile[val] = v end,
					}
				end
			end
		end

		if cons or module.consoleOptions then
			if not self.cmdtable.args[L"boss"].args[zone] then
				self.cmdtable.args[L"boss"].args[zone] = {
					type = "group",
					name = zonename,
					desc = string.format(L"Options for bosses in %s.", zonename),
					args = {},
				}
			end

			self.cmdtable.args[L"boss"].args[zone].args[L2"cmd"] = cons or module.consoleOptions
		end
	elseif module.consoleOptions then
		self.cmdtable.args[L"plugin"].args[module.consoleCmd or name] = cons or module.consoleOptions
	end

	-- Set up target monitoring
	local z = module.zonename

	if type(z) == "string" then enablezones[z] = true
	elseif type(z) == "table" then
		for _,zone in pairs(z) do enablezones[zone] = true end
	end

	local t = module.enabletrigger
	if type(t) == "string" then enablemobs[t] = module
	elseif type(t) == "table" then
		for _,mob in pairs(t) do enablemobs[mob] = module end
	end
end


function BigWigs:EnableModule(module)
	local m = self:GetModule(module)
	if m and m:IsBossModule() and not self:IsModuleActive(module) then
		self:ToggleModuleActive(module, true)
		self:TriggerEvent("BigWigs_Message", string.format(L"%s mod enabled", m:ToString() or "??"), "Cyan", true)
		self:TriggerEvent("BigWigs_SendSync", "EnableModule " .. (BB:HasReverseTranslation(module) == true and BB:GetReverseTranslation(module) or module))
	end
end


function BigWigs:BigWigs_RebootModule(module)
	self:ToggleModuleActive(module, false)
	self:ToggleModuleActive(module, true)
end


function BigWigs:BigWigs_RecvSync(sync, module)
	if sync == "EnableModule" and module then
		local m = self:GetModule(BB:HasTranslation(module) == true and BB:GetTranslation(module) or module)
		if m.zonename == GetRealZoneText() then self:EnableModule(BB:HasTranslation(module) == true and BB:GetTranslation(module) or module) end
	end
end


