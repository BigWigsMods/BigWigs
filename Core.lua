------------------------------
--      Are you local?      --
------------------------------

local BB = nil
local L = AceLibrary("AceLocale-2.2"):new("BigWigs")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["%s mod enabled"] = true,
	["%s has been defeated"] = true,     -- "<boss> has been defeated"
	["%s have been defeated"] = true,    -- "<bosses> have been defeated"

	["Debug enabled, output routed to %s."] = true,
	["Debug disabled."] = true,

	-- AceConsole strings
	["Bosses"] = true,
	["Options for bosses in %s."] = true, -- "Options for bosses in <zone>"
	["Options for %s (r%s)."] = true,     -- "Options for <boss> (<revision>)"
	["Plugins"] = true,
	["Options for plugins."] = true,
	["Extras"] = true,
	["Options for extras."] = true,
	["Active"] = true,
	["Activate or deactivate this module."] = true,
	["Reboot"] = true,
	["Reboot this module."] = true,
	["Debugging"] = true,
	["Show debug messages."] = true,
	["Options"] = true,
	bosskill_cmd = "kill",
	bosskill_name = "Boss death",
	bosskill_desc = "Announce when the boss has been defeated.",

	["Load"] = true,
	["Load All"] = true,
	["Load all %s modules."] = true,

	-- AceConsole zone commands
	["Karazhan"] = true,
	["Zul'Gurub"] = "ZG",
	["Molten Core"] = "MC",
	["Blackwing Lair"] = "BWL",
	["Ahn'Qiraj"] = "AQ40",
	["Ruins of Ahn'Qiraj"] = "AQ20",
	["Naxxramas"] = "Naxxramas",
	["Azeroth"] = "Azeroth",
	["Outland"] = "Outland",
} end)

L:RegisterTranslations("frFR", function() return {
	["%s mod enabled"] = "Module %s activ\195\169",
	["%s has been defeated"] = "%s a \195\169t\195\169 vaincu",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s ont \195\169t\195\169 vaincu",    -- "<bosses> have been defeated"

	["Debug enabled, output routed to %s."] = "D\195\169boguage activ\195\169, output dirig\195\169 vers %s.",
	["Debug disabled."] = "D\195\169boguage d\195\169sactiv\195\169.",

	-- AceConsole strings
	["Bosses"] = "Boss",
	["Options for bosses in %s."] = "Options des boss dans %s.", -- "Options for bosses in <zone>"
	["Options for %s (r%s)."] = "Options pour %s (r%s).",     -- "Options for <boss> (<revision>)"
	-- ["Plugins"] = true,
	["Options for plugins."] = "Options pour les plugins.",
	-- ["Extras"] = true,
	["Options for extras."] ="Options pour les extras.",
	["Active"] = "Actif",
	["Activate or deactivate this module."] = "Activer ou d\195\169sactiver ce module.",
	["Reboot"] = "Red\195\169marrer",
	["Reboot this module."] = "Red\195\169marrer ce module.",
	["Debugging"] = "D\195\169boguage",
	["Show debug messages."] = "Afficher les messages de d\195\169boguage.",
	--["Options"] = true,
	--bosskill_cmd = "kill",
	bosskill_name = "D\195\169faite du boss",
	bosskill_desc = "Pr\195\169viens quand le boss est vaincu.",

	["Load"] = "Charger",
	["Load All"] = "Tout charger",
	["Load all %s modules."] = "Charge tous les modules \"%s\".",

	-- AceConsole zone commands
	["Karazhan"] = "Karazhan",
	["Zul'Gurub"] = "ZG",
	["Molten Core"] = "MC",
	["Blackwing Lair"] = "BWL",
	["Ahn'Qiraj"] = "AQ40",
	["Ruins of Ahn'Qiraj"] = "AQ20",
	["Naxxramas"] = "Naxxramas",
	["Azeroth"] = "Azeroth",
	["Outland"] = "Outreterre",
} end)
  
L:RegisterTranslations("deDE", function() return {
	["%s mod enabled"] = "%s Modul aktiviert",
	["%s has been defeated"] = "%s wurde besiegt",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s wurden besiegt",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "Bosse",
	["Options for bosses in %s."] = "Optionen f\195\188r Bosse in %s.", -- "Options for bosses in <zone>"
	["Options for %s (r%s)."] = "Optionen f\195\188r %s (r%s).",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "Plugins",
	["Options for plugins."] = "Optionen f\195\188r Plugins.",
	["Extras"] = "Extras",
	["Options for extras."] = "Optionen f\195\188r Extras.",
	-- ["toggle"] = true,
	["Active"] = "Aktivieren",
	["Activate or deactivate this module."] = "Aktiviert oder deaktiviert dieses Modul.",
	-- ["reboot"] = true,
	["Reboot"] = "Neustarten",
	["Reboot this module."] = "Startet dieses Modul neu.",
	-- ["debug"] = true,
	["Debugging"] = "Debugging",
	["Show debug messages."] = "Zeige Debug Nachrichten.",
	["Options"] = "Optionen",
	-- bosskill_cmd = "kill",
	bosskill_name = "Boss besiegt",
	bosskill_desc = "Melde, wenn ein Boss besiegt wurde.",

	["Load"] = "Laden",
	["Load All"] = "Alle Laden",
	["Load all %s modules."] = "Alle %s Module laden.",

	-- AceConsole zone commands
	-- ["Karazhan"] = true,
	["Zul'Gurub"] = "ZG",
	["Molten Core"] = "MC",
	["Blackwing Lair"] = "BWL",
	["Ahn'Qiraj"] = "AQ40",
	["Ruins of Ahn'Qiraj"] = "AQ20",
	["Naxxramas"] = "Naxxramas",
	["Azeroth"] = "Azeroth",
	["Outland"] = "Scherbenwelt",
} end)

L:RegisterTranslations("koKR", function() return {
	["%s mod enabled"] = "%s 모듈 시작",
	["%s has been defeated"] = "<%s> 물리쳤습니다.",     -- "<boss> has been defeated"
	["%s have been defeated"] = "<%s> 물리쳤습니다.",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "보스들",
	["Options for bosses in %s."] = "%s 에 보스들을 위한 설정", -- "Options for bosses in <zone>"
	["Options for %s (r%s)."] = "%s에 대한 설정(r%s).",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "플러그인들",
	["Options for plugins."] = "플러그인 설정",
	["Extras"] = "기타",
	["Options for extras."] = "기타 설정.",
	["Active"] = "활성화",
	["Activate or deactivate this module."] = "활성화 혹은 모둘 발견",
	["Reboot"] = "재시작",
	["Reboot this module."] = "모듈 재시작",
	["Debugging"] = "디버깅",
	["Show debug messages."] = "디버그 메세지 표시",
	["Options"] = "설정",
	bosskill_name = "보스 사망",
	bosskill_desc = "보스를 물리쳤을 때 알림",

	["Load"] = "불러오기",
	["Load All"] = "모두 불러오기",
	["Load all %s modules."] = "모든 %s 모듈들을 불러옵니다.",

	-- AceConsole zone commands
	["Zul'Gurub"] = "ZG",
	["Molten Core"] = "MC",
	["Blackwing Lair"] = "BWL",
	["Ahn'Qiraj"] = "AQ40",
	["Ruins of Ahn'Qiraj"] = "AQ20",
	["Naxxramas"] = "낙스라마스",
--	["Azeroth"] = "아제로스",
	["Outland"] = "아웃랜드",
} end)

L:RegisterTranslations("zhCN", function() return {
	["%s mod enabled"] = "%s模块已开启",
	["%s has been defeated"] = "%s被击败了！",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s被击败了！",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "首领",
	["Options for bosses in %s."] = "%s首领模块设置。", -- "Options for bosses in <zone>"
	["Options for %s (r%s)."] = "%s模块设置 版本(r%s).",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "插件",
	["Options for plugins."] = "插件设置。",
	["Extras"] = "额外",
	["Options for extras."] = "额外的设置",
	["Active"] = "激活",
	["Activate or deactivate this module."] = "激活或关闭此模块。",
	["Reboot"] = "重启",
	["Reboot this module."] = "重启此模块",
	["Debugging"] = "除错",
	["Show debug messages."] = "显示除错信息。",
	bosskill_name = "首领死亡",
	bosskill_desc = "首领死亡时提示",

	["Load"] = "载入",
	["Load All"] = "载入所有",
	["Load all %s modules."] = "载入所有%s的模块",

	bosskill_name = "首领死亡",
	bosskill_desc = "首领被击败时发出提示",

	-- AceConsole zone commands
	["Zul'Gurub"] = "祖尔格拉布",
	["Molten Core"] = "熔火之心",
	["Blackwing Lair"] = "黑翼之巢",
	["Ahn'Qiraj"] = "安其拉",
	["Ruins of Ahn'Qiraj"] = "安其拉废墟",
	["Naxxramas"] = "纳克萨玛斯",
--	["Azeroth"] = true,
} end)

L:RegisterTranslations("zhTW", function() return {
	["%s mod enabled"] = "%s模組已開啟",
	["%s has been defeated"] = "%s被擊敗了！",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s被擊敗了！",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "首領",
	["Options for bosses in %s."] = "%s首領模組選項。", -- "Options for bosses in <zone>"
	["Options for %s (r%s)."] = "%s模組選項 版本(r%s).",     -- "Options for <boss> (<revision>)"
	["Extras"] = "其他",
	["Options for extras."] = "其他模組選項",
	["Plugins"] = "插件",
	["Options for plugins."] = "插件選項。",
	["Active"] = "啟動",
	["Activate or deactivate this module."] = "開啟或關閉此模組。",
	["Reboot"] = "重啟",
	["Reboot this module."] = "重啟此模組",
	["Debugging"] = "除錯",
	["Show debug messages."] = "顯示除錯訊息。",

	bosskill_name = "首領死亡",
	bosskill_desc = "首領被擊敗時發出提示。",

	-- AceConsole zone commands
	["Zul'Gurub"] = "ZG",
	["Molten Core"] = "MC",
	["Blackwing Lair"] = "BWL",
	["Ahn'Qiraj"] = "TAQ",
	["Ruins of Ahn'Qiraj"] = "RAQ",
	["Naxxramas"] = "NAX",
	["Azeroth"] = "艾澤拉斯",
--	["Outland"] = true,
} end)

---------------------------------
--      Addon Declaration      --
---------------------------------

BigWigs = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDebug-2.0", "AceModuleCore-2.0", "AceConsole-2.0", "AceDB-2.0")
BigWigs:SetModuleMixins("AceDebug-2.0", "AceEvent-2.0", "CandyBar-2.0")
BigWigs:RegisterDB("BigWigsDB", "BigWigsDBPerChar")
BigWigs.cmdtable = {type = "group", handler = BigWigs, args = {
	[L["Bosses"]] = {
		type = "header",
		name = L["Bosses"],
		order = 2,
	},
	["spacer"] = {
		type = "header",
		name = " ",
		order = 200,
	},
	[L["Options"]] = {
		type = "header",
		name = L["Options"],
		order = 201,
	},
	[L["Plugins"]] = {
		type = "group",
		name = L["Plugins"],
		desc = L["Options for plugins."],
		args = {},
		disabled = function() return not BigWigs:IsActive() end,
		order = 202,
	},
	[L["Extras"]] = {
		type = "group",
		name = L["Extras"],
		desc = L["Options for extras."],
		args = {},
		disabled = function() return not BigWigs:IsActive() end,
		order = 203,
	},
}}

BigWigs:RegisterChatCommand({"/bw", "/BigWigs"}, BigWigs.cmdtable, "BIGWIGS")

BigWigs.debugFrame = ChatFrame5
BigWigs.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigs:OnInitialize()
	if not self.version then self.version = GetAddOnMetadata("BigWigs", "Version") end
	self.version = (self.version or "2.0") .. " |cffff8888r" .. self.revision .. "|r"
end

-- This works because after a reloadui, GetNumRaidMembers() will return the real
-- number. At initial login (or relog), it will say 0, but you will get a "You
-- have joined a raid group" message, so our LoadOnDemand addon loads Core
-- anyway.
function BigWigs:OnEnable(first)
	if not first or GetNumRaidMembers() > 0 then
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


function BigWigs:ToggleModuleDebugging(enable)
	local frame = self.debugFrame or ChatFrame5
	if enable then
		self:Print(string.format(L["Debug enabled, output routed to %s."], frame:GetName()))
	else
		self:Print(L["Debug disabled."])
	end
	for name, module in self:IterateModules() do
		if type(module.SetDebugging) == "function" then
			module:SetDebugging( enable )
			module.debugFrame = frame
		end
	end
end
function BigWigs:OnDebugEnable() self:ToggleModuleDebugging(true) end
function BigWigs:OnDebugDisable() self:ToggleModuleDebugging(false) end

-------------------------------
--      Module Handling      --
-------------------------------

function BigWigs:RegisterModule(name, module)
	if module:IsRegistered() then
		error(string.format("%q is already registered.", name))
		return
	end

	if module:IsBossModule() then self:ToggleModuleActive(module, false) end

	-- Set up DB
	local opts
	if module:IsBossModule() and module.toggleoptions then
		opts = {}
		for _,v in pairs(module.toggleoptions) do if v ~= -1 then opts[v] = true end end
	end

	if module.db and type(module.RegisterDefaults) == "function" then
		module:RegisterDefaults("profile", opts or module.defaultDB or {})
	else
		self:RegisterDefaults(name, "profile", opts or module.defaultDB or {})
	end

	if not module.db then module.db = self:AcquireDBNamespace(name) end

	-- Set up AceConsole
	if module:IsBossModule() then
		local cons
		local revision = type(module.revision) == "number" and module.revision or -1
		local L2 = AceLibrary("AceLocale-2.2"):new("BigWigs"..name)
		if module.toggleoptions then
			local m = module
			cons = {
				type = "group",
				name = name,
				desc = string.format(L["Options for %s (r%s)."], name, revision),
				args = {
					[L["Active"]] = {
						type = "toggle",
						name = L["Active"],
						order = 1,
						desc = L["Activate or deactivate this module."],
						get = function() return m.core:IsModuleActive(m) end,
						set = function() m.core:ToggleModuleActive(m) end,
					},
					[L["Reboot"]] = {
						type = "execute",
						name = L["Reboot"],
						order = 2,
						desc = L["Reboot this module."],
						func = function() m.core:TriggerEvent("BigWigs_RebootModule", m) end,
						disabled = function() return not m.core:IsModuleActive(m) end,
					},
					[L["Debugging"]] = {
						type = "toggle",
						name = L["Debugging"],
						desc = L["Show debug messages."],
						order = 3,
						get = function() return m:IsDebugging() end,
						set = function(v) m:SetDebugging(v) end,
						hidden = function() return not BigWigs:IsDebugging() end,
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
					if l:HasTranslation(v.."_validate") then
						cons.args[l[v.."_cmd"]] = {
							type = "text",
							order = v == "bosskill" and -1 or x,
							name = l[v.."_name"],
							desc = l[v.."_desc"],
							get = function() return m.db.profile[val] end,
							set = function(v) m.db.profile[val] = v end,
							validate = l[v.."_validate"],
						}
					else
						cons.args[l[v.."_cmd"]] = {
							type = "toggle",
							order = v == "bosskill" and -1 or x,
							name = l[v.."_name"],
							desc = l[v.."_desc"],
							get = function() return m.db.profile[val] end,
							set = function(v) m.db.profile[val] = v end,
						}
					end
				end
			end
		end

		if cons or module.consoleOptions then
			if module.external then
				self.cmdtable.args[L["Extras"]].args[L2["cmd"]] = cons or module.consoleOptions
			else
				local zonename = type(module.zonename) == "table" and module.zonename[1] or module.zonename
				local zone = zonename
				if module.otherMenu then
					zone = L[module.otherMenu] or error(string.format("Invalid otherMenu value from %s.", module:ToString()))
					zonename = zone
				end
				if not self.cmdtable.args[zone] then
					self.cmdtable.args[zone] = {
						type = "group",
						name = zonename,
						desc = string.format(L["Options for bosses in %s."], zonename),
						args = {},
						disabled = function() return not BigWigs:IsActive() end,
					}
				end
				self.cmdtable.args[zone].args[L2["cmd"]] = cons or module.consoleOptions
			end
		end
	elseif module.consoleOptions then
		if module.external then
			self.cmdtable.args[L["Extras"]].args[module.consoleCmd or name] = cons or module.consoleOptions
		else
			self.cmdtable.args[L["Plugins"]].args[module.consoleCmd or name] = cons or module.consoleOptions
		end
	end

	module.registered = true
	if type(module.OnRegister) == "function" then
		module:OnRegister()
	end

	self:TriggerEvent("BigWigs_ModuleRegistered", module.name)

	-- Set up target monitoring, in case the monitor module has already initialized
	if module.zonename and module.enabletrigger then
		self:TriggerEvent("BigWigs_RegisterForTargetting", module.zonename, module.enabletrigger)
	end
end


function BigWigs:EnableModule(module, nosync)
	local m = self:GetModule(module)
	if m and m:IsBossModule() and not self:IsModuleActive(module) then
		self:ToggleModuleActive(module, true)
		self:TriggerEvent("BigWigs_Message", string.format(L["%s mod enabled"], m:ToString() or "??"), "Core", true)
		if not nosync then
			if not BB then BB = AceLibrary("Babble-Boss-2.2") end
			self:TriggerEvent("BigWigs_SendSync", (m.external and "EnableExternal " or "EnableModule ") .. (m.synctoken or BB:GetReverseTranslation(module)))
		end
	end
end


function BigWigs:BigWigs_RebootModule(module)
	self:ToggleModuleActive(module, false)
	self:ToggleModuleActive(module, true)
end


function BigWigs:BigWigs_RecvSync(sync, module)
	if (sync == "EnableModule" or sync == "EnableExternal") and module then
		if not BB then BB = AceLibrary("Babble-Boss-2.2") end
		local name = BB:HasTranslation(module) and BB[module] or module
		if self:HasModule(name) and self:GetModule(name).zonename == GetRealZoneText() then
			self:EnableModule(name, true)
		end
	end
end


function BigWigs:BigWigs_TargetSeen(mobname, unit)
	local zone = GetRealZoneText()
	for name,module in self:IterateModules() do
		if module:IsBossModule() and self:ZoneIsTrigger(module, zone) and self:MobIsTrigger(module, mobname)
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


