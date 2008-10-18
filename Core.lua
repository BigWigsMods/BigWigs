------------------------------
--      Are you local?      --
------------------------------

_G.BigWigsFubarDB = nil --temp, expire after XX time

local bboss = LibStub("LibBabble-Boss-3.0")
local bzone = LibStub("LibBabble-Zone-3.0")

local BZ = bzone:GetUnstrictLookupTable()
local BB = bboss:GetUnstrictLookupTable()
local BBR = bboss:GetReverseLookupTable()

-- Set two globals to make it easier on the boss modules.
_G.BZ = bzone:GetLookupTable()
_G.BB = bboss:GetLookupTable()

local L = AceLibrary("AceLocale-2.2"):new("BigWigs")
local icon = LibStub("LibDBIcon-1.0", true)

local customBossOptions = {}
local waterfall = AceLibrary:HasInstance("Waterfall-1.0") and AceLibrary("Waterfall-1.0") or nil
----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["%s mod enabled"] = true,
	["%s has been defeated"] = true,     -- "<boss> has been defeated"
	["%s have been defeated"] = true,    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = true,
	["Options for bosses in %s."] = true, -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = true,     -- "Options for <boss> (<revision>)"
	["Plugins"] = true,
	["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = true,
	["Extras"] = true,
	["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = true,
	["GUI"] = true,
	["Open the waterfall GUI."] = true,
	["Active"] = true,
	["Activate or deactivate this module."] = true,
	["Reboot"] = true,
	["Reboot this module."] = true,
	["Options"] = true,
	["Minimap icon"] = true,
	["Toggle show/hide of the minimap icon."] = true,

	bosskill = "Boss death",
	bosskill_desc = "Announce when the boss has been defeated.",
	enrage = "Enrage",
	enrage_desc = "Warn when the boss enters an enraged state.",
	berserk = "Berserk",
	berserk_desc = "Warn when the boss goes Berserk.",

	["Load"] = true,
	["Load All"] = true,
	["Load all %s modules."] = true,
} end)

L:RegisterTranslations("frFR", function() return {
	["%s mod enabled"] = "Module %s activé",
	["%s has been defeated"] = "%s a été vaincu(e)",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s ont été vaincu(e)s",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "Boss",
	["Options for bosses in %s."] = "Options concernant les boss dans %s.", -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = "Options concernant %s (r%d).",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "Plugins",
	["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "Les plugins s'occupent des composants centraux de Big Wigs - comme l'affichage des messages, les barres temporelles, ainsi que d'autres composants essentiels.",
	["Extras"] = "Extras",
	["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "Les extras sont des plugins tiers et incorporés dont Big Wigs peut se passer pour fonctionner correctement.",
	--["GUI"] = true,
	--["Open the waterfall GUI."] = true,
	["Active"] = "Actif",
	["Activate or deactivate this module."] = "Active ou désactive ce module.",
	["Reboot"] = "Redémarrer",
	["Reboot this module."] = "Redémarre ce module.",
	["Options"] = "Options",

	bosskill = "Défaite du boss",
	bosskill_desc = "Prévient quand le boss est vaincu.",
	enrage = "Enrager",
	enrage_desc = "Prévient quand le boss devient enragé.",
	berserk = "Berserk",
	berserk_desc = "Prévient quand le boss passe en berserk.",

	["Load"] = "Charger",
	["Load All"] = "Tout charger",
	["Load all %s modules."] = "Charge tous les modules \"%s\".",
} end)

L:RegisterTranslations("deDE", function() return {
	["%s mod enabled"] = "%s Modul aktiviert",
	["%s has been defeated"] = "%s wurde besiegt",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s wurden besiegt",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "Bosse",
	["Options for bosses in %s."] = "Optionen für Bosse in %s.", -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = "Optionen für %s (r%d).",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "Plugins",
	["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "Plugins stellen die Grundfunktionen von Big Wigs zur verfügung -  wie das Anzeigen von Nachrichten, Zeitbalken, und weiteren benötigten Funktionen.",
	["Extras"] = "Extras",
	["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "Extras sind Externe Plugin Addons und eingebaute zusätzliche Plugins ohne die Big Wigs auch korrekt funktioniert.",
	--["GUI"] = true,
	--["Open the waterfall GUI."] = true,
	["Active"] = "Aktivieren",
	["Activate or deactivate this module."] = "Aktiviert oder deaktiviert dieses Modul.",
	["Reboot"] = "Neustarten",
	["Reboot this module."] = "Startet dieses Modul neu.",
	["Options"] = "Optionen",

	bosskill = "Boss besiegt",
	bosskill_desc = "Melde, wenn ein Boss besiegt wurde.",
	enrage = "Wutanfall",
	enrage_desc = "Melde, wenn ein Boss in einen Wutanfall Status geht.",
	berserk = "Berserker",
	berserk_desc = "Melde, wenn ein Boss in den Berserker Status geht.",

	["Load"] = "Laden",
	["Load All"] = "Alle Laden",
	["Load all %s modules."] = "Alle %s Module laden.",
} end)

L:RegisterTranslations("koKR", function() return {
	["%s mod enabled"] = "%s 모듈 시작",
	["%s has been defeated"] = "%s 물리침",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s 물리침",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "보스",
	["Options for bosses in %s."] = "%s에 보스들을 위한 설정입니다.", -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = "%s에 대한 설정입니다 (r%d).",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "플러그인",
	["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "Big Wigs의 주요 기능을 다루는 플러그인 입니다. - 메세지 및 타이머 바 표시 기능, 기타 주요 기능 등.",
	["Extras"] = "기타",
	["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "기타의 것은 Big Wigs가 제대로 작용할 서드파티와 플러그 접속식을 함께 포함합니다.",
	["GUI"] = "GUI",
	["Open the waterfall GUI."] = "waterfall GUI 설정창을 엽니다.",
	["Active"] = "활성화",
	["Activate or deactivate this module."] = "해당 모듈을 활성화/비활성화 합니다.",
	["Reboot"] = "재시작",
	["Reboot this module."] = "해당 모듈을 재시작합니다.",
	["Options"] = "설정",
	["Minimap icon"] = "미니맵 아이콘",
	["Toggle show/hide of the minimap icon."] = "미니맵 아이콘을 표시/숨김으로 전환합니다.",

	bosskill = "보스 사망",
	bosskill_desc = "보스를 물리쳤을 때 알림니다.",
	enrage = "격노",
	enrage_desc = "보스가 격노 상태로 변경 시 경고합니다.",
	berserk = "광폭화",
	berserk_desc = "보스가 언제 광폭화가 되는지 경고합니다.",

	["Load"] = "불러오기",
	["Load All"] = "모두 불러오기",
	["Load all %s modules."] = "모든 %s 모듈들을 불러옵니다.",
} end)

L:RegisterTranslations("zhCN", function() return {
	["%s mod enabled"] = "%s 模块已启用。",
	["%s has been defeated"] = "%s被击败了！",
	["%s have been defeated"] = "%s被击败了！",

	-- AceConsole strings
	["Bosses"] = "首领模块",
	["Options for bosses in %s."] = "%s首领模块设置。",
	["Options for %s (r%d)."] = "%s首领模块版本（r%d）。",
	["Plugins"] = "综合设置",
	["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "他们是 BigWigs 最关键的核心 - 比如信息显示，记时条以及其他必要的功能。",
	["Extras"] = "附加功能",
	["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "附加功能是第三方插件，是 BigWigs 功能的一个增强。",
	["GUI"] = "图形界面",
	["Open the waterfall GUI."] = "打开 Waterfall 图形界面。",
	["Active"] = "激活",
	["Activate or deactivate this module."] = "激活或关闭此模块。",
	["Reboot"] = "重置",
	["Reboot this module."] = "重置此模块。",
	["Options"] = "设置",

	bosskill = "首领死亡",
	bosskill_desc = "首领被击杀时显示提示信息。",
	enrage = "狂暴",
	enrage_desc = "首领进入狂暴状态时发出警报。",
	berserk = "无敌",
	berserk_desc = "当首领进入无敌状态时发出警报。",

	["Load"] = "加载",
	["Load All"] = "加载所有",
	["Load all %s modules."] = "加载所有%s模块。",
} end)

L:RegisterTranslations("zhTW", function() return {
	["%s mod enabled"] = "%s模組已啟用",
	["%s has been defeated"] = "%s被擊敗了",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s被擊敗了",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "首領模組",
	["Options for bosses in %s."] = "%s首領模組選項", -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = "%s模組選項 版本(r%d)",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "插件",
	["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "插件是 Big Wigs 的核心功能 - 如訊息顯示、計時條以及其他必要的功能",
	["Extras"] = "附加功能",
	["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "附加功能是第三方插件，增強 Big Wigs 的功能",
	--["GUI"] = true,
	--["Open the waterfall GUI."] = true,
	["Active"] = "啟動",
	["Activate or deactivate this module."] = "開啟或關閉此模組",
	["Reboot"] = "重啟",
	["Reboot this module."] = "重啟此模組",
	["Options"] = "選項",

	bosskill = "首領死亡",
	bosskill_desc = "首領被擊敗時發出提示",
	enrage = "狂怒",
	enrage_desc = "當首領狂怒時發出警報",
	berserk = "狂暴",
	berserk_desc = "當首領狂暴時發出警報",

	["Load"] = "載入",
	["Load All"] = "載入全部",
	["Load all %s modules."] = "載入全部%s模組",
} end)

L:RegisterTranslations("esES", function() return {
	["%s mod enabled"] = "Módulo %s activado",
	["%s has been defeated"] = "%s ha sido derrotado",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s han sido derrotados",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "Jefes",
	["Options for bosses in %s."] = "Opciones para jefes de %s.", -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = "Opciones para %s (r%d).",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "Plugins",
	["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "Los plugins administran las características de BigWigs sobre cómo mostrar mensajes, barras de tiempo y otras características esenciales.",
	["Extras"] = "Extras",
	["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "Extras son utilidades y plugins de terceros. BigWigs puede funcionar con o sin ellos.",
	--["GUI"] = true,
	--["Open the waterfall GUI."] = true,
	["Active"] = "Activo",
	["Activate or deactivate this module."] = "Activa o desactiva este módulo.",
	["Reboot"] = "Reiniciar",
	["Reboot this module."] = "Reiniciar el módulo.",
	["Options"] = "Opciones",

	bosskill = "Derrota del jefe",
	bosskill_desc = "Avisa cuando el jefe ha sido derrotado.",
	enrage = "Enfurecer (Enrage)",
	enrage_desc = "Avisa cuando el jefe entra en un estado enfurecido.",
	berserk = "Rabia (Berserk)",
	berserk_desc = "Avisa cuando el jefe entra en un estado rabioso.",

	["Load"] = "Cargar",
	["Load All"] = "Cargar todo",
	["Load all %s modules."] = "Cargar todos los módulos de %s.",
} end)

L:RegisterTranslations("ruRU", function() return {
	["%s mod enabled"] = "%s модуль включен",
	["%s has been defeated"] = "%s был побежден",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s были побеждены",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "Боссы",
	["Options for bosses in %s."] = "Опции для боссов в %s.", -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = "Опции для %s (r%d).",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "Плагины",
	["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "Плагины это основная особенность Big Wigsf - они показывают сообщения, время на барах, и другие важные особенности на боссах.",
	--["GUI"] = true,
	--["Open the waterfall GUI."] = true,
	["Extras"] = "Дополнение",
	["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "Дополнительные настройки для рейдов без которых  Big Wigs не будет должным образом работать",
	["Active"] = "Активен",
	["Activate or deactivate this module."] = "Активация или деактивация модуля",
	["Reboot"] = "Перезагрузка",
	["Reboot this module."] = "Перезагрузка данного модуля",
	["Options"] = "Опции",

	bosskill = "Смерть босса",
	bosskill_desc = "Объявляет что босс побежден.",
	enrage = "Исступление",
	enrage_desc = "Предупреждает когда босс входит в состояние Исступления.",
	berserk = "Берсерк",
	berserk_desc = "Предупреждет когда Босс входит в состояние Берсерк.",

	["Load"] = "Загрузить",
	["Load All"] = "Загрузить все",
	["Load all %s modules."] = "Загружает все %s модули.",
} end)

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

local options = {
	type = "group",
	handler = BigWigs,
	args = {
		[L["Bosses"]] = {
			type = "header",
			name = L["Bosses"],
			order = 1,
		},
		spacer = {
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
			desc = L["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."],
			args = {},
			disabled = "~IsActive",
			order = 202,
		},
		[L["Extras"]] = {
			type = "group",
			name = L["Extras"],
			desc = L["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."],
			args = {},
			disabled = "~IsActive",
			order = 203,
		},
		["GUI"] = waterfall and {
			type = "execute",
			name = L["GUI"],
			desc = L["Open the waterfall GUI."],
			func = function() waterfall:Open("BigWigs") end,
			order = 204,
		},
		["Minimap"] = {
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
			for i,v in ipairs(module.toggleoptions) do
				if type(v) == "string" then
					opts[v] = true
				end
			end
			self:RegisterDefaults(name, "profile", opts)
			for i in ipairs(opts) do opts[i] = nil end
			module.db = self:AcquireDBNamespace(name)
		elseif type(module.defaultDB) == "table" then
			self:RegisterDefaults(name, "profile", module.defaultDB)
			module.db = self:AcquireDBNamespace(name)
		end

		-- Set up AceConsole
		if module:IsBossModule() then
			local cons = module.consoleOptions
			local ML = AceLibrary("AceLocale-2.2"):new("BigWigs"..name)
			if module.toggleoptions then
				cons = {
					type = "group",
					name = name,
					desc = L["Options for %s (r%d)."]:format(name, rev),
					pass = true,
					get = function(key)
						if key == "active" then
							return self:IsModuleActive(module)
						else
							return module.db.profile[key]
						end
					end,
					set = function(key, value)
						if key == "active" then
							self:ToggleModuleActive(module)
						else
							module.db.profile[key] = value

							-- Invoke any custom boss option function handlers.
							if customBossOptions[key] and type(customBossOptions[key][3]) == "function" then
								customBossOptions[key][3](module)
							end
						end
					end,
					args = {
						active = active,
						reboot = {
							type = "execute",
							name = L["Reboot"],
							order = 2,
							desc = L["Reboot this module."],
							func = "BigWigs_RebootModule",
							passValue = module,
							disabled = "~IsModuleActive",
						},
						headerSpacer = headerSpacer,
					},
				}
				local customBossOptionOrder = -100
				for i, v in ipairs(module.toggleoptions) do
					local x = i + 100
					if type(v) == "number" then
						cons.args[i] = {
							type = "header",
							order = x,
							name = " ",
						}
					elseif type(v) == "string" then
						local optName, optDesc, optOrder
						if customBossOptions[v] then
							optName = customBossOptions[v][1]
							optDesc = customBossOptions[v][2]
							optOrder = customBossOptionOrder
							customBossOptionOrder = customBossOptionOrder + 1
						else
							optName = ML:HasTranslation(v) and ML[v]
							local descKey = v.."_desc" -- String concatenation ftl! Not sure how we can get rid of this.
							optDesc = ML:HasTranslation(descKey) and ML[descKey] or v
							optOrder = x
						end
						if optName then
							cons.args[v] = {
								type = "toggle",
								order = optOrder,
								name = optName,
								desc = optDesc,
							}
							if optOrder > 0 and ML:HasTranslation(v.."_validate") then
								cons.args[v].type = "text"
								cons.args[v].validate = ML[v.."_validate"]
							end
						end
					end
				end
			end

			if cons then
				if module.external then
					options.args[L["Extras"]].args[ML["cmd"]] = cons
				else
					local zone = nil
					if module.otherMenu then
						zone = BZ[module.otherMenu]
					else
						zone = type(module.zonename) == "table" and module.zonename[1] or module.zonename
					end
					if not options.args[zone] then
						options.args[zone] = {
							type = "group",
							name = zone,
							desc = L["Options for bosses in %s."]:format(zone),
							args = {},
							disabled = "~IsActive",
						}
					end
					options.args[zone].args[ML["cmd"]] = cons
				end
			end
		elseif module.consoleOptions then
			if module.external then
				options.args[L["Extras"]].args[module.consoleCmd or name] = module.consoleOptions
			else
				options.args[L["Plugins"]].args[module.consoleCmd or name] = module.consoleOptions
			end
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
		m:Message(L["%s mod enabled"]:format(moduleName or "??"), "Core", true)
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

function BigWigs:BigWigs_RecvSync(sync, module)
	if not module then return end
	if sync == "EnableModule" or sync == "EnableExternal" then
		local name = BB[module] or module
		if self:HasModule(name) then
			self:EnableModule(name, true)
		end
	elseif (sync == "BWBossDeath" or sync == "BWMultiBossDeath") and self:HasModule(module) then
		local mod = self:GetModule(module)
		if mod.db.profile.bosskill then
			if sync == "BWBossDeath" then
				mod:Message(L["%s has been defeated"]:format(module), "Bosskill", nil, "Victory")
			else
				mod:Message(L["%s have been defeated"]:format(module), "Bosskill", nil, "Victory")
			end
		end
		mod:TriggerEvent("BigWigs_RemoveRaidIcon")
		self:ToggleModuleActive(mod, false)
	end
end

do
	local function mobIsTrigger(module, name)
		local t = module.enabletrigger
		if type(t) == "string" then return name == t
		elseif type(t) == "table" then
			for i,mob in ipairs(t) do if mob == name then return true end end
		end
	end

	function BigWigs:BigWigs_TargetSeen(mobname, unit)
		for name, module in self:IterateModules() do
			if not self:IsModuleActive(module) and (name == mobname or (module:IsBossModule() and mobIsTrigger(module, mobname)
				and (not module.VerifyEnable or module:VerifyEnable(unit)))) then
				self:EnableModule(name)
			end
		end
	end
end

