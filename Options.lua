
assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsOptions")
local tablet = AceLibrary("Tablet-2.0")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["|cff00ff00Module running|r"] = true,
	["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt+Click|r to disable them. |cffeda55fCtrl+Alt+Click|r to disable Big Wigs completely."] = true,
	["|cffeda55fClick|r to enable."] = true,
	["Big Wigs is currently disabled."] = true,
	["Active boss modules"] = true,
	["hidden"] = true,
	["shown"] = true,
	["minimap"] = true,
	["Minimap"] = true,
	["Toggle the minimap button."] = true,
	["All running modules have been reset."] = true,
	["All running modules have been disabled."] = true,
	["%s reset."] = true,
	["%s disabled."] = true,
	["%s icon is now %s."] = true,
	["Show it again with /bw plugin minimap."] = true,
} end)

L:RegisterTranslations("frFR", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00Module d\195\169marr\195\169|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt+Click|r to disable them. |cffeda55fCtrl+Alt+Click|r to disable Big Wigs completely."] = "|cffeda55fClic|r pour red\195\169marrer les modules actifs. |cffeda55fAlt+Clic|r pour les d\195\169sactiver. |cffeda55fCtrl+Alt+Clic|r pour d\195\169sactiver Big Wigs compl\195\168tement.",
	["|cffeda55fClick|r to enable."] = "|cffeda55fClic|r pour activer.",
	["Big Wigs is currently disabled."] = "Big Wigs est actuellement d\195\169sactiv\195\169.",
	["Active boss modules"] = "Modules de boss actifs",
	["hidden"] = "cach\195\169e",
	["shown"] = "affich\195\169e",
	-- ["minimap"] = true,
	-- ["Minimap"] = true,
	["Toggle the minimap button."] = "Afficher ou masquer le bouton sur la minimap.",
	["All running modules have been reset."] = "Tous les modules actifs ont \195\169t\195\169 red\195\169marr\195\169s.",
	["All running modules have been disabled."] = "Tous les modules ont \195\169t\195\169 d\195\169sactiv\195\169s.",
	["%s reset."] = "%s red\195\169marr\195\169.",
	["%s disabled."] = "%s d\195\169sactiv\195\169.",
	["%s icon is now %s."] = "L'ic\195\180ne de %s est d\195\169sormais %s.",
	["Show it again with /bw plugin minimap."] = "Vous pouvez la r\195\169afficher avec /bw plugin minimap.",
  } end)
  
L:RegisterTranslations("koKR", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00모듈 실행중|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt+Click|r to disable them. |cffeda55fCtrl+Alt+Click|r to disable Big Wigs completely."] = "|cffeda55f클릭|r : 모두 초기화 |cffeda55f알트+클릭|r 비활성화 |cffeda55f컨트롤+알트+클릭|r : BigWigs 비활성화.",
	["|cffeda55fClick|r to enable."] = "|cffeda55f클릭|r : 모듈 활성화.",
	["Big Wigs is currently disabled."] = "BigWigs가 비활성화 되어 있습니다.",
	["Active boss modules"] = "보스 모듈 활성화",
	["hidden"] = "숨김",
	["shown"] = "표시",
	["Minimap"] = "미니맵",
	["Toggle the minimap button."] = "미니맵 버튼 토글",
	["All running modules have been reset."] = "모든 실행중인 모듈을 초기화합니다.",
	["All running modules have been disabled."] = "모든 실행중인 모듈을 비활성화 합니다.",
	["%s reset."] = "%s 초기화되었습니다.",
	["%s disabled."] = "%s 비활성화 되었습니다.",
	["%s icon is now %s."] = "%s 아이콘은 현재 %s 입니다.",
	["Show it again with /bw plugin minimap."] = "/bw plugin minimap 명령으로 다시 나타납니다.",
} end)

L:RegisterTranslations("zhCN", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00模块运行中|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt+Click|r to disable them. |cffeda55fCtrl+Alt+Click|r to disable Big Wigs completely."] = "|cffeda55f点击|r图标重置所有运行中的模块。|cffeda55fAlt+点击|r图标关闭所有运行中的模块。|cffeda55fCtrl+Alt+点击|r图标关闭BigWigs。",
	["|cffeda55fClick|r to enable."] = "|cffeda55f点击|r图标开启BigWigs。",
	["Big Wigs is currently disabled."] = "Big Wigs目前关闭。",
	["Active boss modules"] = "激活首领模块",
	["hidden"] = "隐藏",
	["shown"] = "显示",
	["Minimap"] = "小地图",
	["Minimap"] = "小地图",
	["Toggle the minimap button."] = "切换是否显示小地图图标。",
	["All running modules have been reset."] = "所有运行中的模块都已重置。",
	["All running modules have been disabled."] = "所有运行中的模块都已关闭。",
	["%s reset."] = "%s重置。",
	["%s disabled."] = "%s关闭。",
} end)


L:RegisterTranslations("zhTW", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00模組運作中|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt+Click|r to disable them. |cffeda55fCtrl+Alt+Click|r to disable Big Wigs completely."] = "|cffeda55f點擊|r圖示重置所有運作中的模組。|cffeda55fAlt+點擊|r圖示關閉所有運作中的模組。|cffeda55fCtrl+Alt+點擊|r圖示關閉BigWigs。",
	["|cffeda55fClick|r to enable."] = "|cffeda55f點擊|r圖示開啟BigWigs。",
	["Big Wigs is currently disabled."] = "Big Wigs目前關閉。",
	["Active boss modules"] = "啟動首領模組",
	["hidden"] = "隱藏",
	["shown"] = "顯示",
	["Minimap"] = "小地圖",
	["Minimap"] = "小地圖",
	["Toggle the minimap button."] = "切換是否顯示小地圖圖標。",
	["All running modules have been reset."] = "所有運行中的模組都已重置。",
	["All running modules have been disabled."] = "所有運行中的模組都已關閉。",
	["%s reset."] = "%s重置。",
	["%s disabled."] = "%s關閉。",
} end)

L:RegisterTranslations("deDE", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00Modul aktiviert|r",
--	["|cffeda55fClick|r to reset all running modules. |cffeda55fShift+Click|r to disable them. |cffeda55fCtrl+Shift+Click|r to disable Big Wigs completely."] = "|cffeda55fKlicken|r, um alle laufenden Module zur\195\188ckzusetzen. |cffeda55fShift+Klick|r um alle laufenden Module zu beenden. |cffeda55fStrg+Shift+Klick|r um BigWigs komplett zu beenden.",
	["|cffeda55fClick|r to enable."] = "|cffeda55fKlicken|r um zu aktivieren.",
	["Big Wigs is currently disabled."] = "Big Wigs ist gegenw\195\164rtig deaktiviert.",
	["Active boss modules"] = "Aktive Boss Module",
	["hidden"] = "versteckt",
	["shown"] = "angezeigt",
	-- ["minimap"] = true,
	["Minimap"] = "Minimap",
	["Toggle the minimap button."] = "Minimap Button anzeigen.",
	["All running modules have been reset."] = "Alle laufenden Module wurden zur\195\188ckgesetzt.",
	["All running modules have been disabled."] = "Alle laufenden Module wurden beendet.",
	["%s reset."] = "%s zur\195\188ckgesetzt.",
	["%s disabled."] = "%s beendet.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local deuce = BigWigs:NewModule("Options Menu")
deuce.hasFuBar = IsAddOnLoaded("FuBar") and FuBar
deuce.consoleCmd = not deuce.hasFuBar and L["minimap"]
deuce.consoleOptions = not deuce.hasFuBar and {
	type = "toggle",
	name = L["Minimap"],
	desc = L["Toggle the minimap button."],
	get = function() return BigWigsOptions.minimapFrame and BigWigsOptions.minimapFrame:IsVisible() or false end,
	set = function(v)
		if v then
			BigWigsOptions:Show()
		else
			BigWigsOptions:Hide()
			BigWigs:Print(L["Show it again with /bw plugin minimap."])
		end
	end,
	map = {[false] = L["hidden"], [true] = L["shown"]},
	message = L["%s icon is now %s."],
	hidden = function() return deuce.hasFuBar end,
}

----------------------------
--      FuBar Plugin      --
----------------------------

BigWigsOptions = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0", "FuBarPlugin-2.0")
BigWigsOptions.name = "FuBar - BigWigs"
BigWigsOptions:RegisterDB("BigWigsFubarDB")

BigWigsOptions.hasNoColor = true
BigWigsOptions.hasIcon = "Interface\\AddOns\\BigWigs\\Icons\\core-enabled"
BigWigsOptions.defaultMinimapPosition = 180
BigWigsOptions.clickableTooltip = true
BigWigsOptions.hideWithoutStandby = true
--BigWigsOptions.hasNoText = true

-- XXX total hack
BigWigsOptions.OnMenuRequest = deuce.core.cmdtable
local args = AceLibrary("FuBarPlugin-2.0"):GetAceOptionsDataTable(BigWigsOptions)
for k,v in pairs(args) do
	if BigWigsOptions.OnMenuRequest.args[k] == nil then
		BigWigsOptions.OnMenuRequest.args[k] = v
	end
end
-- XXX end hack

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
		self:SetIcon("Interface\\AddOns\\BigWigs\\Icons\\core-enabled")
	else
		self:SetIcon("Interface\\AddOns\\BigWigs\\Icons\\core-disabled")
	end

	self:UpdateTooltip()
end

-----------------------------
--      FuBar Methods      --
-----------------------------

function BigWigsOptions:ModuleAction(module)
	if IsAltKeyDown() then
		deuce.core:ToggleModuleActive(module, false)
		self:Print(string.format(L["%s disabled."], module:ToString()))
	else
		deuce.core:BigWigs_RebootModule(module)
		self:Print(string.format(L["%s reset."], module:ToString()))
	end
	self:UpdateTooltip()
end

function BigWigsOptions:OnTooltipUpdate()
	if BigWigs:IsActive() then
		local cat = tablet:AddCategory("text", L["Active boss modules"])
		for name, module in deuce.core:IterateModules() do
			if module:IsBossModule() and deuce.core:IsModuleActive(module) then
				cat:AddLine("text", name, "func", function(mod) BigWigsOptions:ModuleAction(mod) end, "arg1", module)
			end
		end
		tablet:SetHint(L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt+Click|r to disable them. |cffeda55fCtrl+Alt+Click|r to disable Big Wigs completely."])
	else
		-- use a text line for this, since the hint is not shown when we are
		-- detached.
		local cat = tablet:AddCategory("colums", 1)
		cat:AddLine("text", L["Big Wigs is currently disabled."], "func", function() BigWigsOptions:OnClick() end)
		tablet:SetHint(L["|cffeda55fClick|r to enable."])
	end
end

function BigWigsOptions:OnClick()
	if BigWigs:IsActive() then
		if IsAltKeyDown() then
			if IsControlKeyDown() then
				BigWigs:ToggleActive(false)
				self:UpdateTooltip()
			else
				for name, module in deuce.core:IterateModules() do
					if module:IsBossModule() and deuce.core:IsModuleActive(module) then
						deuce.core:ToggleModuleActive(module, false)
					end
				end
				self:Print(L["All running modules have been disabled."])
			end
		else
			for name, module in deuce.core:IterateModules() do
				if module:IsBossModule() and deuce.core:IsModuleActive(module) then
					deuce.core:BigWigs_RebootModule(module)
				end
			end
			self:Print(L["All running modules have been reset."])
		end
	else
		BigWigs:ToggleActive(true)
	end

	self:UpdateTooltip()
end

