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

local L = AceLibrary("AceLocale-2.2"):new("BigWigs")
local icon = LibStub("LibDBIcon-1.0", true)

local customBossOptions = {}
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
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
	["Active"] = true,
	["Activate or deactivate this module."] = true,
	["Reboot"] = true,
	["Reboot this module."] = true,
	["Options"] = true,
	["Minimap icon"] = true,
	["Toggle show/hide of the minimap icon."] = true,
	["Advanced"] = true,
	["You shouldn't really need to touch these options, but if you want to tweak them then you're welcome to do so!"] = true,

	["Toggles whether or not the boss module should warn about %s."] = true,
	bosskill = "Boss death",
	bosskill_desc = "Announce when the boss has been defeated.",
	enrage = "Enrage",
	enrage_desc = "Warn when the boss enters an enraged state.",
	berserk = "Berserk",
	berserk_desc = "Warn when the boss goes Berserk.",

	["Load"] = true,
	["Load All"] = true,
	["Load all %s modules."] = true,

	already_registered = "|cffff0000WARNING:|r |cff00ff00%s|r (|cffffff00%d|r) already exists as a boss module in Big Wigs, but something is trying to register it again (at revision |cffffff00%d|r). This usually means you have two copies of this module in your addons folder due to some addon updater failure. It is recommended that you delete any Big Wigs folders you have and then reinstall it from scratch.",
} end)

L:RegisterTranslations("frFR", function() return {
	["%s has been defeated"] = "%s a été vaincu(e)",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s ont été vaincu(e)s",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "Boss",
	["Options for bosses in %s."] = "Options concernant les boss |2 %s.", -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = "Options concernant %s (r%d).",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "Plugins",
	["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "Les plugins s'occupent des composants centraux de Big Wigs - comme l'affichage des messages, les barres temporelles, ainsi que d'autres composants essentiels.",
	["Extras"] = "Extras",
	["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "Les extras sont des plugins tiers et incorporés dont Big Wigs peut se passer pour fonctionner correctement.",
	["Active"] = "Actif",
	["Activate or deactivate this module."] = "Active ou désactive ce module.",
	["Reboot"] = "Redémarrer",
	["Reboot this module."] = "Redémarre ce module.",
	["Options"] = "Options",
	["Minimap icon"] = "Icône de la minicarte",
	["Toggle show/hide of the minimap icon."] = "Affiche ou non l'icône sur la minicarte.",
	["Advanced"] = "Avancés",
	["You shouldn't really need to touch these options, but if you want to tweak them then you're welcome to do so!"] = "Vous n'avez normalement pas besoin de toucher à ces options, mais si vous voulez les peaufinez, n'hésitez pas !",

	["Toggles whether or not the boss module should warn about %s."] = "Permet ou non au module de boss de vous prévenir à propos |2 %s.",
	bosskill = "Défaite du boss",
	bosskill_desc = "Prévient quand le boss est vaincu.",
	enrage = "Enrager",
	enrage_desc = "Prévient quand le boss devient enragé.",
	berserk = "Berserk",
	berserk_desc = "Prévient quand le boss devient fou furieux.",

	["Load"] = "Charger",
	["Load All"] = "Tout charger",
	["Load all %s modules."] = "Charge tous les modules |2 %s.",

	already_registered = "|cffff0000ATTENTION :|r |cff00ff00%s|r (|cffffff00%d|r) existe déjà en tant que module de boss dans Big Wigs, mais quelque chose essaye de l'enregistrer à nouveau (à la révision |cffffff00%d|r). Cela signifie souvent que vous avez deux copies de ce module dans votre répertoire AddOns suite à une mauvaise mise à jour d'un gestionnaire d'addons. Il est recommandé de supprimer tous les répertoires de Big Wigs et de le réinstaller complètement.",
} end)

L:RegisterTranslations("deDE", function() return {
	["%s has been defeated"] = "%s wurde besiegt!",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s wurden besiegt!",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "Bosse",
	["Options for bosses in %s."] = "Optionen für Bosse in %s.", -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = "Optionen für %s (r%d).",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "Plugins",
	["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "Plugins stellen die Grundfunktionen von Big Wigs zur Verfügung - wie das Anzeigen von Nachrichten, Timerleisten und anderen, essentiellen Funktionen.",
	["Extras"] = "Extras",
	["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "Extras sind externe und eingebaute zusätzliche Plugins, ohne die Big Wigs auch korrekt funktioniert.",
	["Active"] = "Aktivieren",
	["Activate or deactivate this module."] = "Aktiviert oder deaktiviert dieses Modul.",
	["Reboot"] = "Neustarten",
	["Reboot this module."] = "Startet dieses Modul neu.",
	["Options"] = "Optionen",
	["Minimap icon"] = "Minimap Symbol",
	["Toggle show/hide of the minimap icon."] = "Zeigt oder versteckt das Minimap Symbol.",
	["Advanced"] = "Erweitert",
	["You shouldn't really need to touch these options, but if you want to tweak them then you're welcome to do so!"] = "Diese Optionen musst du nicht unbedingt verändern, aber du kannst es natürlich, wenn du willst!",

	bosskill = "Boss besiegt",
	bosskill_desc = "Meldet, wenn ein Boss besiegt wurde.",
	enrage = "Wutanfall",
	enrage_desc = "Meldet, wenn ein Boss einen Wutanfall bekommt.",
	berserk = "Berserker",
	berserk_desc = "Meldet, wenn ein Boss zum Berserker wird.",

	["Load"] = "Laden",
	["Load All"] = "Alle laden",
	["Load all %s modules."] = "Alle %s Module laden.",

	already_registered = "|cffff0000WARNUNG:|r |cff00ff00%s|r (|cffffff00%d|r) existiert bereits als Boss Modul in Big Wigs, aber irgend etwas versucht es erneut anzumelden (als Revision |cffffff00%d|r). Dies bedeutet, dass du zwei Kopien des Moduls aufgrund eines Fehlers beim Aktualisieren in deinem Addon-Ordner hast. Es wird empfohlen, jegliche Big Wigs Ordner zu löschen und dann von Grund auf neu zu installieren.",
} end)

L:RegisterTranslations("koKR", function() return {
	["%s has been defeated"] = "%s 물리침",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s 물리침",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "보스",
	["Options for bosses in %s."] = "%s에 보스들을 위한 옵션입니다.", -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = "%s에 대한 옵션입니다 (r%d).",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "플러그인",
	["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "Big Wigs의 주요 기능을 다루는 플러그인 입니다. - 메세지 및 타이머 바 표시 기능, 기타 주요 기능 등.",
	["Extras"] = "기타",
	["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "Big Wigs가 제대로 작동할 수 있도록 하는 플러그인입니다.",
	["Active"] = "활성화",
	["Activate or deactivate this module."] = "해당 모듈을 활성화/비활성화 합니다.",
	["Reboot"] = "재시작",
	["Reboot this module."] = "해당 모듈을 재시작합니다.",
	["Options"] = "옵션",
	["Minimap icon"] = "미니맵 아이콘",
	["Toggle show/hide of the minimap icon."] = "미니맵 아이콘을 표시/숨김으로 전환합니다.",
	["Advanced"] = "고급",
	["You shouldn't really need to touch these options, but if you want to tweak them then you're welcome to do so!"] = "경보, 아이콘, 차단에 대한 고급 설정입니다. 정말로 필요하지 않은 이상 건들지 않는 것이 좋습니다.",

	bosskill = "보스 사망",
	bosskill_desc = "보스를 물리쳤을 때 알림니다.",
	enrage = "격노",
	enrage_desc = "보스가 격노 상태로 변경 시 경고합니다.",
	berserk = "광폭화",
	berserk_desc = "보스가 언제 광폭화가 되는지 경고합니다.",

	["Load"] = "불러오기",
	["Load All"] = "모두 불러오기",
	["Load all %s modules."] = "모든 %s 모듈들을 불러옵니다.",

	already_registered = "|cffff0000경고:|r |cff00ff00%s|r (|cffffff00%d|r) 이미 Big Wigs 에서 보스 모듈로 존재하지만, 다시 등록이 필요합니다 (revision에 |cffffff00%d|r). 이 것은 일반적으로 애드온 업데이트 실패로 인하여 이 모듈이 당신의 애드온 폴더에 두개의 사본이 있는 것을 뜻합니다. 당신이 가지고 있는 Big Wigs 폴더의 삭제와 재설치를 권장합니다.",
} end)

L:RegisterTranslations("zhCN", function() return {
	["%s has been defeated"] = "%s被击败了！",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s被击败了！",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "首领模块",
	["Options for bosses in %s."] = "%s首领模块选项。", -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = "%s首领模块版本（r%d）。",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "插件",
	["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "插件是 Big Wigs 最关键的核心 - 比如信息显示，记时条以及其他必要的功能。",
	["Extras"] = "附加功能",
	["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "附加功能是第三方捆绑插件，是 Big Wigs 功能的一个增强。",
	["Active"] = "激活",
	["Activate or deactivate this module."] = "激活或关闭此模块。",
	["Reboot"] = "重置",
	["Reboot this module."] = "重置此模块。",
	["Options"] = "选项",
	["Minimap icon"] = "迷你地图图标",
	["Toggle show/hide of the minimap icon."] = "开启或关闭迷你地图图标。",
	["Advanced"] = "高级",
	["You shouldn't really need to touch these options, but if you want to tweak them then you're welcome to do so!"] = "并不需要去修改这些选项，但如果想进行调整我们欢迎这样做！",

	bosskill = "首领死亡",
	bosskill_desc = "首领被击杀时显示提示信息。",
	enrage = "激怒",
	enrage_desc = "首领进入激怒状态时发出警报。",
	berserk = "狂暴",
	berserk_desc = "当首领进入狂暴状态时发出警报。",

	["Load"] = "加载",
	["Load All"] = "加载所有",
	["Load all %s modules."] = "加载所有%s模块。",

	already_registered = "|cffff0000警告：|r |cff00ff00%s|r（|cffffff00%d|r）在 Big Wigs 中已经存在首领模块，但存在（版本 |cffffff00%d|r）模块仍试图重新注册。可能由于更新失败的原因，通常表示您有两份模块拷贝在您的插件文件夹中。建议您删除所有 Big Wigs 文件夹并重新全新安装。",
} end)

L:RegisterTranslations("zhTW", function() return {
	["%s has been defeated"] = "%s被擊敗了！",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s被擊敗了！",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "首領模組",
	["Options for bosses in %s."] = "%s首領模組選項。", -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = "%s模組選項版本（r%d）。",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "插件",
	["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "插件是 Big Wigs 的核心功能 - 如訊息顯示、計時條以及其他必要的功能。",
	["Extras"] = "附加功能",
	["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "附加功能是第三方插件，增強 Big Wigs 的功能。",
	["Active"] = "啟動",
	["Activate or deactivate this module."] = "打開或關閉此模組。",
	["Reboot"] = "重啟",
	["Reboot this module."] = "重啟此模組。",
	["Options"] = "選項",
	["Minimap icon"] = "小地圖圖示",
	["Toggle show/hide of the minimap icon."] = "開啟或關閉小地圖圖示。",
	["Advanced"] = "進階",
	["You shouldn't really need to touch these options, but if you want to tweak them then you're welcome to do so!"] = "並不需要去修改這些選項，但如果想進行調整我們歡迎這樣做！",

	bosskill = "首領死亡",
	bosskill_desc = "首領被擊敗時發出提示。",
	enrage = "狂怒",
	enrage_desc = "當首領狂怒時發出警報。",
	berserk = "狂暴",
	berserk_desc = "當首領狂暴時發出警報。",

	["Load"] = "載入",
	["Load All"] = "載入全部",
	["Load all %s modules."] = "載入全部%s模組。",

	already_registered = "|cffff0000警告：|r |cff00ff00%s|r（|cffffff00%d|r）在 Big Wigs 中已經存在首領模組，但存在（版本 |cffffff00%d|r）模組仍試圖重新註冊。可能由於更新失敗的原因，通常表示您有兩份模組拷貝在您插件的檔案夾中。建議您刪除所有 Big Wigs 檔案夾並重新安裝。",
} end)

L:RegisterTranslations("esES", function() return {
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

	-- already_registered = "|cffff0000WARNING:|r |cff00ff00%s|r (|cffffff00%d|r) already exists as a boss module in Big Wigs, but something is trying to register it again (at revision |cffffff00%d|r). This usually means you have two copies of this module in your addons folder due to some addon updater failure. It is recommended that you delete any Big Wigs folders you have and then reinstall it from scratch.",
} end)

L:RegisterTranslations("ruRU", function() return {
	["%s has been defeated"] = "%s побеждён",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s побеждены",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "Боссы",
	["Options for bosses in %s."] = "Опции для боссов в %s.", -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = "Опции для %s (r%d).",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "Плагины",
	["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "Плагины - это основная особенность Big Wigs,они показывают сообщения, время в полосках и другие важные моменты при битве с боссами.",
	["Extras"] = "Дополнения",
	["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "Дополнительные настройки для рейдов без которых Big Wigs не будет должным образом работать",
	["Active"] = "Активен",
	["Activate or deactivate this module."] = "Активация или деактивация модуля",
	["Reboot"] = "Перезагрузка",
	["Reboot this module."] = "Перезагрузка данного модуля",
	["Options"] = "Опции",
	["Minimap icon"] = "Иконка у мини-карты",
	["Toggle show/hide of the minimap icon."] = "Показать/скрыть иконку у мини-карты.",
	["Advanced"] = "Расширенные настройки",
	["You shouldn't really need to touch these options, but if you want to tweak them then you're welcome to do so!"] = "Вам не нужно трогать данную опцию, но если вы хотите подстроить, тогда вперёд!",

	bosskill = "Смерть босса",
	bosskill_desc = "Объявлять о смерти босса.",
	enrage = "Исступление",
	enrage_desc = "Предупреждать, когда босс входит в состояние исступления.",
	berserk = "Берсерк",
	berserk_desc = "Предупреждать, когда босс входит в состояние берсерк.",

	["Load"] = "Загрузить",
	["Load All"] = "Загрузить все",
	["Load all %s modules."] = "Загрузить все модули %s.",

	already_registered = "|cffff0000Внимание:|r |cff00ff00%s|r (|cffffff00%d|r) уже существует как модуль босса Big Wigs,но чтото снова пытается его зарегистрировать (ревизия |cffffff00%d|r). Это обычно означает, что у вас две копии этого модуля в папке модификации, возможно из-за ошибки обновления программой обновления модификаций. Мы рекомендуем вам удалить все папки Big Wigs , а затем установить его заново с нуля.",
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
		bosses = {
			type = "header",
			name = L["Bosses"],
			order = 1,
		},
		spacer = {
			type = "header",
			name = " ",
			order = 200,
		},
		options = {
			type = "header",
			name = L["Options"],
			order = 201,
		},
		extras = {
			type = "group",
			name = L["Extras"],
			desc = L["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."],
			args = {},
			disabled = "~IsActive",
			order = 203,
		},
		advanced = {
			type = "group",
			name = L["Advanced"],
			desc = L["You shouldn't really need to touch these options, but if you want to tweak them then you're welcome to do so!"],
			args = {},
			disabled = "~IsActive",
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
			for i,v in next, module.toggleoptions do
				local t = type(v)
				if t == "string"  then
					opts[v] = true
				elseif t == "number" and v > 0 then
					local n = GetSpellInfo(v)
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

		-- Set up AceConsole.
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
				for i, v in next, module.toggleoptions do
					local x = i + 100
					local t = type(v)
					if t == "number" and v < 0 then
						cons.args[i] = {
							type = "header",
							order = x,
							name = " ",
						}
					elseif t == "number" and v > 0 then
						local spellName = GetSpellInfo(v)
						if not spellName then error(("Invalid option %d in module %s."):format(v, name)) end
						cons.args[spellName] = {
							type = "toggle",
							order = x,
							name = spellName,
							desc = L["Toggles whether or not the boss module should warn about %s."]:format(spellName),
						}
					elseif t == "string" then
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
					options.args.extras.args[module.consoleCmd] = cons
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
					options.args[zone].args[module.consoleCmd] = cons
				end
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


