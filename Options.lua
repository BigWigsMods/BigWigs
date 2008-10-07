
assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local LC = AceLibrary("AceLocale-2.2"):new("BigWigs")
local L = AceLibrary("AceLocale-2.2"):new("BigWigsOptions")
local waterfall = AceLibrary:HasInstance("Waterfall-1.0") and AceLibrary("Waterfall-1.0") or nil
local dew = AceLibrary("Dewdrop-2.0")
local BigWigs = BigWigs

local hint = nil
local _G = getfenv(0)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["|cff00ff00Module running|r"] = true,
	["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = true,
	["|cffeda55fClick|r to enable."] = true,
	["|cffeda55fShift-Click|r to open configuration window."] = true,
	["Big Wigs is currently disabled."] = true,
	["Active boss modules:"] = true,
	["All running modules have been reset."] = true,
	["All running modules have been disabled."] = true,
	["Menu"] = true,
	["Menu options."] = true,
} end)

L:RegisterTranslations("frFR", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00Module actif|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = "|cffeda55fClic|r pour redémarrer les modules actifs. |cffeda55fAlt+Clic|r pour les désactiver. |cffeda55fCtrl-Alt+Clic|r pour désactiver complètement Big Wigs.",
	["|cffeda55fClick|r to enable."] = "|cffeda55fClic|r pour activer.",
	["|cffeda55fShift-Click|r to open configuration window."] = "|cffeda55fShift-Clic|r pour ouvrir la fenêtre de configuration.",
	["Big Wigs is currently disabled."] = "Big Wigs est actuellement désactivé.",
	["Active boss modules:"] = "Modules de boss actifs :",
	["All running modules have been reset."] = "Tous les modules actifs ont été réinitialisés.",
	["All running modules have been disabled."] = "Tous les modules actifs ont été désactivés.",
	["Menu"] = "Menu",
	["Menu options."] = "Options du menu.",
} end)

L:RegisterTranslations("koKR", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00모듈 실행중|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = "|cffeda55f클릭|r : 모두 초기화 |cffeda55f알트-클릭|r 비활성화 |cffeda55f컨트롤-알트-클릭|r : BigWigs 비활성화.",
	["|cffeda55fClick|r to enable."] = "|cffeda55f클릭|r : 모듈 활성화.",
	["|cffeda55fShift-Click|r to open configuration window."] = "|cffeda55fSHIFT-클릭|r : 환경설정 열기.",
	["Big Wigs is currently disabled."] = "BigWigs가 비활성화 되어 있습니다.",
	["Active boss modules:"] = "사용중인 보스 모듈:",
	["All running modules have been reset."] = "모든 실행중인 모듈을 초기화합니다.",
	["All running modules have been disabled."] = "모든 실행중인 모듈을 비활성화 합니다.",
	["Menu"] = "메뉴",
	["Menu options."] = "메뉴 설정.",
} end)

L:RegisterTranslations("zhCN", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00首领模块运行中|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = "你可以|cffeda55f点击|r图标重置所有运行中的模块；\n或者|cffeda55fAlt-点击|r可以禁用所有首领模块；\n或者 |cffeda55fCtrl-Alt-点击|r 可以禁用 BigWigs 所有功能。",
	["|cffeda55fClick|r to enable."] = "|cffeda55f点击|r启用。",
	["|cffeda55fShift-Click|r to open configuration window."] = "|cffeda55fShift-点击|r打开设置面板。",
	["Big Wigs is currently disabled."] = "BigWigs 当前已被禁用。",
	["Active boss modules:"] = "激活首领模块：",
	["All running modules have been reset."] = "所有运行中的模块都已重置。",
	["All running modules have been disabled."] = "所有运行中的模块都已禁用。",
	["Menu"] = "目录",
	["Menu options."] = "目录设置。",
} end)

L:RegisterTranslations("zhTW", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00模組運作中|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = "|cffeda55f點擊|r圖示重置所有運作中的模組。|cffeda55fAlt+點擊|r圖示關閉所有運作中的模組。|cffeda55fCtrl-Alt+點擊|r圖示關閉 BigWigs。",
	["|cffeda55fClick|r to enable."] = "|cffeda55f點擊|r圖示開啟 BigWigs。",
	["|cffeda55fShift-Click|r to open configuration window."] = "|cffeda55fShift-點擊|r 開啟設置視窗。",
	["Big Wigs is currently disabled."] = "Big Wigs 目前關閉。",
	["Active boss modules:"] = "啟動首領模組",
	["All running modules have been reset."] = "所有運行中的模組都已重置。",
	["All running modules have been disabled."] = "所有運行中的模組都已關閉。",
	["Menu"] = "選單",
	["Menu options."] = "選單設置",
} end)

L:RegisterTranslations("deDE", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00Modul aktiv|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = "|cffeda55fKlicken|r, um alle laufenden Module zurückzusetzen. |cffeda55fAlt+Klick|r um alle laufenden Module zu beenden. |cffeda55fStrg-Alt+Klick|r um BigWigs komplett zu beenden.",
	["|cffeda55fClick|r to enable."] = "|cffeda55fKlicken|r um zu aktivieren.",
	["|cffeda55fShift-Click|r to open configuration window."] = "|cffeda55fShift-Klick|r zum öffnen des Konfigurationsfensters.",
	["Big Wigs is currently disabled."] = "Big Wigs ist gegenwärtig deaktiviert.",
	["Active boss modules:"] = "Aktive Boss Module:",
	["All running modules have been reset."] = "Alle laufenden Module wurden zurückgesetzt.",
	["All running modules have been disabled."] = "Alle laufenden Module wurden beendet.",
	["Menu"] = "Menü",
	["Menu options."] = "Menü-Optionen",
} end)

L:RegisterTranslations("esES", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00Módulo activo|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = "|cffeda55fClic|r para reiniciar los módulos activos.|n|cffeda55fAlt+Clic|r para desactivarlos.|n|cffeda55fCtrl-Alt+Clic|r para desactivar por completo BigWigs.|n",
	["|cffeda55fClick|r to enable."] = "|cffeda55fClic|r para activar.",
	["|cffeda55fShift-Click|r to open configuration window."] = "|cffeda55fShift-Clic|r para abrir la ventana de configuración.",
	["Big Wigs is currently disabled."] = "Big Wigs está desactivado.",
	["Active boss modules:"] = "Módulos de jefe activos :",
	["All running modules have been reset."] = "Todos los módulos activos han sido reiniciados.",
	["All running modules have been disabled."] = "Todos los módulos activos han sido desactivados.",
	["Menu"] = "Menú",
	["Menu options."] = "Opciones del menú.",
} end)
-- Translated by wow.playhard.ru translators
L:RegisterTranslations("ruRU", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00Модуль запущен|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = "|cffeda55fКлик|r чтобы сбросить все запущенные модули. |cffeda55fAlt-Клик|r чтобы отключить их. |cffeda55fCtrl-Alt-Клик|r чтобы отключить Big Wigs полностью.",
	["|cffeda55fClick|r to enable."] = "|cffeda55fКлик|r чтобы включить.",
	["|cffeda55fShift-Click|r to open configuration window."] = "|cffeda55fShift-Клик|r чтобы открыть окно настроек.",
	["Big Wigs is currently disabled."] = "Big Wigs в данный момент отключен",
	["Active boss modules:"] = "Активные модули боссов:",
	["All running modules have been reset."] = "Все запущенные модули сброшены",
	["All running modules have been disabled."] = "Все запущенные модули отключены",
	["Menu"] = "Меню",
	["Menu options."] = "Опции меню",
} end)

----------------------------
--      FuBar Plugin      --
----------------------------

local ldb = LibStub("LibDataBroker-1.1"):NewDataObject("BigWigs", {
	type = "data source",
	text = "Big Wigs",
	icon = "Interface\\AddOns\\BigWigs\\Icons\\core-enabled",
})

BigWigsOptions = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0")
local BigWigsOptions = BigWigsOptions

-----------------------------
--      Menu Handling      --
-----------------------------

function BigWigsOptions:OnInitialize()
	hint = L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."]
	if waterfall then
		hint = hint .. " " .. L["|cffeda55fShift-Click|r to open configuration window."]
	end

	-- Register with waterfall if it's available.
	if waterfall then
		waterfall:Register(
			"BigWigs",
			"aceOptions", BigWigs.cmdtable,
			"treeType","SECTIONS",
			"colorR", .6, "colorG", .5, "colorB", .8
		)
	end
end

-----------------------------
--      Icon Handling      --
-----------------------------

function BigWigsOptions:OnEnable()
	self:RegisterEvent("BigWigs_CoreEnabled", "CoreState")
	self:RegisterEvent("BigWigs_CoreDisabled", "CoreState")

	self:CoreState()
end

function BigWigsOptions:CoreState()
	if BigWigs:IsActive() then
		ldb.icon = "Interface\\AddOns\\BigWigs\\Icons\\core-enabled"
	else
		ldb.icon = "Interface\\AddOns\\BigWigs\\Icons\\core-disabled"
	end
end

-----------------------------
--      FuBar Methods      --
-----------------------------

-- God, blizzard sucks some times.
local zoneFunctions = {"GetRealZoneText", "GetZoneText"}

function ldb.OnClick(self, button)
	if button == "RightButton" then
		dew:Open(self,
			"children", function()
				dew:FeedAceOptionsTable(BigWigs.cmdtable)
			end
		)
	else
		if BigWigs:IsActive() then
			if IsAltKeyDown() then
				if IsControlKeyDown() then
					BigWigs:ToggleActive(false)
				else
					for name, module in BigWigs:IterateModules() do
						if module:IsBossModule() and BigWigs:IsModuleActive(module) then
							BigWigs:ToggleModuleActive(module, false)
						end
					end
					BigWigs:Print(L["All running modules have been disabled."])
				end
			elseif IsShiftKeyDown() and waterfall then
				local subGroup = nil
				for i = 1, #zoneFunctions do
					local zone = _G[zoneFunctions[i]]()
					if zone and self.OnMenuRequest.args[zone] then
						subGroup = zone
						break
					end
				end
				waterfall:Open("BigWigs", subGroup)
			else
				for name, module in BigWigs:IterateModules() do
					if module:IsBossModule() and BigWigs:IsModuleActive(module) then
						BigWigs:BigWigs_RebootModule(module)
					end
				end
				BigWigs:Print(L["All running modules have been reset."])
			end
		else
			BigWigs:ToggleActive(true)
		end
	end
end

function ldb.OnTooltipShow(tt)
	tt:AddLine("Big Wigs")
	if BigWigs:IsActive() then
		local added = nil
		for name, module in BigWigs:IterateModules() do
			if module:IsBossModule() and BigWigs:IsModuleActive(module) then
				if not added then
					tt:AddLine(L["Active boss modules:"], 1, 1, 1)
					added = true
				end
				tt:AddLine(name)
			end
		end
		tt:AddLine(hint, 0.2, 1, 0.2, 1)
	else
		tt:AddLine(L["Big Wigs is currently disabled."])
		tt:AddLine(L["|cffeda55fClick|r to enable."], 0.2, 1, 0.2)
	end
end

