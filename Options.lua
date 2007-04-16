
assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local BZ = AceLibrary("Babble-Zone-2.2")
local LC = AceLibrary("AceLocale-2.2"):new("BigWigs")
local L = AceLibrary("AceLocale-2.2"):new("BigWigsOptions")
local waterfall = AceLibrary:HasInstance("Waterfall-1.0") and AceLibrary("Waterfall-1.0") or nil

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
	["Active boss modules: %s."] = true,
	["All running modules have been reset."] = true,
	["All running modules have been disabled."] = true,
	["Menu"] = true,
	["Menu options."] = true,
} end)

L:RegisterTranslations("frFR", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00Module d\195\169marr\195\169|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = "|cffeda55fClic|r pour red\195\169marrer les modules actifs. |cffeda55fAlt+Clic|r pour les d\195\169sactiver. |cffeda55fCtrl-Alt+Clic|r pour d\195\169sactiver Big Wigs compl\195\168tement.",
	["|cffeda55fClick|r to enable."] = "|cffeda55fClic|r pour activer.",
	["|cffeda55fShift-Click|r to open configuration window."] = "|cffeda55fShift-Clic|r pour ouvrir la fen\195\170tre de configuration.",
	["Big Wigs is currently disabled."] = "Big Wigs est actuellement d\195\169sactiv\195\169.",
	["Active boss modules: %s."] = "Modules de boss actifs: %s.",
	["All running modules have been reset."] = "Tous les modules actifs ont \195\169t\195\169 red\195\169marr\195\169s.",
	["All running modules have been disabled."] = "Tous les modules ont \195\169t\195\169 d\195\169sactiv\195\169s.",
	--["Menu"] = true,
	["Menu options."] = "Options du menu.",
} end)

L:RegisterTranslations("koKR", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00모듈 실행중|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = "|cffeda55f클릭|r : 모두 초기화 |cffeda55f알트-클릭|r 비활성화 |cffeda55f컨트롤-알트-클릭|r : BigWigs 비활성화.",
	["|cffeda55fClick|r to enable."] = "|cffeda55f클릭|r : 모듈 활성화.",
	["|cffeda55fShift-Click|r to open configuration window."] = "|cffeda55fSHIFT-클릭|r : 환경설정 열기.",
	["Big Wigs is currently disabled."] = "BigWigs가 비활성화 되어 있습니다.",
	--["Active boss modules: %s."] = "보스 모듈 활성화",
	["All running modules have been reset."] = "모든 실행중인 모듈을 초기화합니다.",
	["All running modules have been disabled."] = "모든 실행중인 모듈을 비활성화 합니다.",
	["Menu"] = "메뉴",
	["Menu options."] = "메뉴 설정.",
} end)

L:RegisterTranslations("zhCN", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00模块运行中|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = "|cffeda55f点击|r图标重置所有运行中的模块。|cffeda55fAlt+点击|r图标关闭所有运行中的模块。|cffeda55fCtrl-Alt+点击|r图标关闭BigWigs。",
	["|cffeda55fClick|r to enable."] = "|cffeda55f点击|r图标开启BigWigs。",
	["|cffeda55fShift-Click|r to open configuration window."] = "|cffeda55fShift-Click|r to open configuration window.",
	["Big Wigs is currently disabled."] = "Big Wigs目前关闭。",
	--["Active boss modules: %s."] = "激活首领模块",
	["All running modules have been reset."] = "所有运行中的模块都已重置。",
	["All running modules have been disabled."] = "所有运行中的模块都已关闭。",
} end)

L:RegisterTranslations("zhTW", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00模組運作中|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = "|cffeda55f點擊|r圖示重置所有運作中的模組。|cffeda55fAlt+點擊|r圖示關閉所有運作中的模組。|cffeda55fCtrl-Alt+點擊|r圖示關閉BigWigs。",
	["|cffeda55fClick|r to enable."] = "|cffeda55f點擊|r圖示開啟BigWigs。",
	["|cffeda55fShift-Click|r to open configuration window."] = "|cffeda55fShift-Click|r to open configuration window.",
	["Big Wigs is currently disabled."] = "Big Wigs目前關閉。",
	--["Active boss modules: %s."] = "啟動首領模組",
	["All running modules have been reset."] = "所有運行中的模組都已重置。",
	["All running modules have been disabled."] = "所有運行中的模組都已關閉。",
} end)

L:RegisterTranslations("deDE", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00Modul aktiv|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = "|cffeda55fKlicken|r, um alle laufenden Module zur\195\188ckzusetzen. |cffeda55fAlt+Klick|r um alle laufenden Module zu beenden. |cffeda55fStrg-Alt+Klick|r um BigWigs komplett zu beenden.",
	["|cffeda55fClick|r to enable."] = "|cffeda55fKlicken|r um zu aktivieren.",
	["|cffeda55fShift-Click|r to open configuration window."] = "|cffeda55fShift-Click|r to open configuration window.",
	["Big Wigs is currently disabled."] = "Big Wigs ist gegenw\195\164rtig deaktiviert.",
	["Active boss modules: %s."] = "Aktive Boss Module: %s.",
	["All running modules have been reset."] = "Alle laufenden Module wurden zur\195\188ckgesetzt.",
	["All running modules have been disabled."] = "Alle laufenden Module wurden beendet.",
} end)

----------------------------
--      FuBar Plugin      --
----------------------------

BigWigsOptions = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceDB-2.0", "FuBarPlugin-2.0")

BigWigsOptions.hasIcon = true

-----------------------------
--      Menu Handling      --
-----------------------------

function BigWigsOptions:OnInitialize()
	self:RegisterDB("BigWigsFubarDB")

	hint = L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."]
	if waterfall then
		hint = hint .. " " .. L["|cffeda55fShift-Click|r to open configuration window."]
	end

	self.hasNoColor = true
	self.hasIcon = "Interface\\AddOns\\BigWigs\\Icons\\core-enabled"
	self.defaultMinimapPosition = 180
	self.clickableTooltip = true
	self.hideWithoutStandby = true
	self.hideMenuTitle = true
	self.OnMenuRequest = BigWigs.cmdtable
	self.overrideTooltip = true

	BigWigs.hideMenuTitle = true

	-- XXX Total hack :(
	local args = AceLibrary("FuBarPlugin-2.0"):GetAceOptionsDataTable(self)
	if not BigWigsOptions.OnMenuRequest.args[L["Menu"]] then
		BigWigsOptions.OnMenuRequest.args[L["Menu"]] = {
			type = "group",
			name = L["Menu"],
			desc = L["Menu options."],
			args = args,
			order = 300,
		}
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
		self:SetIcon("Interface\\AddOns\\BigWigs\\Icons\\core-enabled")
	else
		self:SetIcon("Interface\\AddOns\\BigWigs\\Icons\\core-disabled")
	end

	self:UpdateTooltip()
end

-----------------------------
--      FuBar Methods      --
-----------------------------

-- God, blizzard sucks some times.
local zoneFunctions = {"GetRealZoneText", "GetZoneText", "GetSubZoneText"}

function BigWigsOptions:OnClick()
	if BigWigs:IsActive() then
		if IsAltKeyDown() then
			if IsControlKeyDown() then
				BigWigs:ToggleActive(false)
				self:UpdateTooltip()
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
				if BZ:HasReverseTranslation(zone) then
					zone = BZ:GetReverseTranslation(zone)
					zone = LC:HasTranslation(zone) and LC[zone] or nil
					if zone then
						subGroup = zone
						break
					end
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

	self:UpdateTooltip()
end

local tooltipVisible = nil
function BigWigsOptions:OnTooltipUpdate()
	if tooltipVisible then self:OnEnter() end
end

function BigWigsOptions:OnEnter()
	if self:IsMinimapAttached() then
		GameTooltip:SetOwner(self.minimapFrame, "ANCHOR_CURSOR")
	else
		GameTooltip:SetOwner(self.frame, "ANCHOR_CURSOR")
	end
	if BigWigs:IsActive() then
		local x = {}
		for name, module in BigWigs:IterateModules() do
			if module:IsBossModule() and BigWigs:IsModuleActive(module) then
				table.insert(x, name)
			end
		end
		if #x > 0 then
			GameTooltip:AddLine(L["Active boss modules: %s."]:format(table.concat(x, ", ")), 1, 1, 1, 1, 1)
			GameTooltip:AddLine("")
		end
		GameTooltip:AddLine(hint, 0.2, 1, 0.2, 1, 1)
	else
		GameTooltip:AddLine(L["Big Wigs is currently disabled."])
		GameTooltip:AddLine(L["|cffeda55fClick|r to enable."], 0.2, 1, 0.2, 1, 1)
	end

	GameTooltip:Show()

	tooltipVisible = true
end

function BigWigsOptions:OnLeave()
	GameTooltip:Hide()
	tooltipVisible = nil
end

