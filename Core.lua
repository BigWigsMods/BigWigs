
------------------------------
--      Are you local?      --
------------------------------

local BZ = AceLibrary("Babble-Zone-2.0")
local BB = AceLibrary("Babble-Boss-2.0")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs")


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
	["Options for %s (r%s) in %s."] = true,     -- "Options for <boss> (<revision>) in <zone>"
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
	["%s mod enabled"] = "%s Modul aktiviert",
	["Target monitoring enabled"] = "Ziel\195\188berwachung aktiviert",
	["Target monitoring disabled"] = "Ziel\195\188berwachung deaktiviert",
	["%s has been defeated"] = "%s wurde besiegt",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s wurden besiegt",    -- "<bosses> have been defeated"
	-- ["plugin"] = true,
	["Plugins"] = "Plugins",
	["Options for plugins."] = "Optionen f\195\188r Plugins.",
	-- ["toggle"] = true,
	["Active"] = "Aktivieren",
	["Activate or deactivate this module."] = "Aktiviere oder deaktiviere dieses Modul.",
	-- ["reboot"] = true,
	["Reboot"] = "Neustarten",
	["Reboot this module."] = "Starte dieses Modul neu.",
	-- ["debug"] = true,
	["Debugging"] = "Debugging",
	["Show debug messages."] = "Zeige Debug Nachrichten.",
	bosskill_cmd = "kill",
	bosskill_name = "Boss besiegt",
	bosskill_desc = "Melde, wenn ein Boss besiegt wurde.",

	-- AceConsole zone commands
	["Zul'Gurub"] = "ZG",
	["Molten Core"] = "MC",
	["Blackwing Lair"] = "BWL",
	["Ahn'Qiraj"] = "AQ40",
	["Ruins of Ahn'Qiraj"] = "AQ20",
	["Onyxia's Lair"] = "Onyxia",
	["Naxxramas"] = "Naxxramas",
	-- ["Silithus"] = true,
	["Outdoor Raid Bosses"] = "Outdoor",
	["Outdoor Raid Bosses Zone"] = "Outdoor Raid Bosses", -- DO NOT EVER TRANSLATE untill I find a more elegant option
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
	["%s has been defeated"] = "%s被击败了！",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s被击败了！",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["boss"] = "boss",
	["Bosses"] = "首领",
	["Options for boss modules."] = "首领模块设置。",
	["Options for bosses in %s."] = "%s首领模块设置。", -- "Options for bosses in <zone>"
	["Options for %s (r%s) in %s."] = "%s (%s) %s 首领模块设置",     -- "Options for <boss> (<revision>) in <zone>"
	["plugin"] = "plugin",
	["Plugins"] = "插件",
	["Options for plugins."] = "插件设置。",
	["toggle"] = "toggle",
	["Active"] = "激活",
	["Activate or deactivate this module."] = "激活或关闭此模块。",
	["reboot"] = "reboot",
	["Reboot"] = "重启",
	["Reboot this module."] = "重启此模块",
	["debug"] = "debug",
	["Debugging"] = "除错",
	["Show debug messages."] = "显示除错信息。",

	bosskill_name = "首领死亡",
	bosskill_desc = "首领被击败时发出提示",

	-- AceConsole zone commands
	["Zul'Gurub"] = "ZG",
	["Molten Core"] = "MC",
	["Blackwing Lair"] = "BWL",
	["Ahn'Qiraj"] = "AQ40",
	["Ruins of Ahn'Qiraj"] = "AQ20",
	["Onyxia's Lair"] = "Onyxia",
	["Naxxramas"] = "Naxxramas",
	["Silithus"] = "Silithus",
	["Outdoor Raid Bosses"] = "Outdoor",
	["Outdoor Raid Bosses Zone"] = "Outdoor Raid Bosses", -- DO NOT EVER TRANSLATE untill I find a more elegant option
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
BigWigs.revision = tonumber(string.sub("$Revision$", 12, -3))

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
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
		self.core:ToggleModuleActive(self, false)
	end
end


------------------------------
--      Initialization      --
------------------------------

function BigWigs:OnInitialize()
	if not self.version then self.version = GetAddOnMetadata("BigWigs", "Version") end
	local rev = self.revision
	for name,module in self:IterateModules() do
		self:RegisterModule(name,module)
		rev = math.max(rev, module.revision)
	end
	self.version = (self.version or "2.0").. " |cffff8888r"..rev.."|r"
	self:RegisterEvent("ADDON_LOADED")
end


function BigWigs:OnEnable()
	self:RegisterEvent("BigWigs_TargetSeen")
	self:RegisterEvent("BigWigs_RebootModule")
	self:RegisterEvent("BigWigs_RecvSync", 10)
end


-------------------------------
--      Module Handling      --
-------------------------------

function BigWigs:ADDON_LOADED(addon)
	local gname = GetAddOnMetadata(addon, "X-BigWigsModule")
	if not gname then return end

	local g = getglobal(gname)
	self:RegisterModule(g.name, g)
	g.external = true
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
		local revision = type(module.revision) == "number" and module.revision or -1
		local zonename = type(module.zonename) == "table" and module.zonename[1] or module.zonename
		local zone = BZ:HasReverseTranslation(zonename) and L(BZ:GetReverseTranslation(zonename)) or L(zonename)
		local L2 = AceLibrary("AceLocale-2.0"):new("BigWigs"..name)
		if module.toggleoptions then
			local m = module

			cons = {
				type = "group",
				name = name.." ("..revision..")",
				desc = string.format(L"Options for %s (r%s) in %s.", name, revision, zonename),
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

	-- Set up target monitoring, in case the monitor module has already initialized
	self:TriggerEvent("BigWigs_RegisterForTargetting", module.zonename, module.enabletrigger)
end


function BigWigs:EnableModule(module, nosync)
	local m = self:GetModule(module)
	if m and m:IsBossModule() and not self:IsModuleActive(module) then
		self:ToggleModuleActive(module, true)
		self:TriggerEvent("BigWigs_Message", string.format(L"%s mod enabled", m:ToString() or "??"), "Cyan", true)
		if not nosync then self:TriggerEvent("BigWigs_SendSync", (m.external and "EnableExternal " or "EnableModule ") .. (m.synctoken or BB:GetReverseTranslation(module))) end
	end
end


function BigWigs:BigWigs_RebootModule(module)
	self:ToggleModuleActive(module, false)
	self:ToggleModuleActive(module, true)
end


function BigWigs:BigWigs_RecvSync(sync, module)
	if sync == "EnableModule" and module then
		local name = BB:HasTranslation(module) and BB(module) or module
		if self:HasModule(name) and self:GetModule(name).zonename == GetRealZoneText() then self:EnableModule(name, true) end
	elseif sync == "EnableExternal" and module then
		local name = BB:HasTranslation(module) and BB(module) or module
		if self:HasModule(name) and self:GetModule(name).zonename == GetRealZoneText() then self:EnableModule(name, true) end
	end
end


function BigWigs:BigWigs_TargetSeen(mobname, unit)
	for name,module in self:IterateModules() do
		if module:IsBossModule() and self:ZoneIsTrigger(module, GetRealZoneText()) and self:MobIsTrigger(module, mobname)
			and (not module.VerifyEnable or module:VerifyEnable(unit)) then
				self:EnableModule(name)
		end
	end
end


function BigWigs:ZoneIsTrigger(module, zone)
	local t = module.zonename
	if type(t) == "string" then return zone == t
	elseif type(t) == "table" then
		for _,mzone in pairs(t) do if mzone == zone then return true end end
	end
end


function BigWigs:MobIsTrigger(module, name)
	local t = module.enabletrigger
	if type(t) == "string" then return name == t
	elseif type(t) == "table" then
		for _,mob in pairs(t) do if mob == name then return true end end
	end
end


