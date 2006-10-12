
assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.0"):new("BigWigsOptions")
local tablet = AceLibrary("Tablet-2.0")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["|cff00ff00Module running|r"] = true,
	["|cffeda55fClick|r to reset all running modules. |cffeda55fShift+Click|r to disable them. |cffeda55fCtrl+Shift+Click|r to disable Big Wigs completely."] = true,
	["|cffeda55fClick|r to enable."] = true,
	["Big Wigs is currently disabled."] = true,
	["Active boss modules"] = true,
	["Hidden"] = true,
	["Shown"] = true,
	["minimap"] = true,
	["Minimap"] = true,
	["Toggle the minimap button."] = true,
	["All running modules have been reset."] = true,
	["All running modules have been disabled."] = true,
	["%s reset."] = true,
	["%s disabled."] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00모듈 실행중|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fShift+Click|r to disable them. |cffeda55fCtrl+Shift+Click|r to disable Big Wigs completely."] = "|cffeda55f클릭|r : 모두 초기화 |cffeda55f쉬프트+클릭|r 비활성화 |cffeda55f컨트롤+쉬프트+클릭|r : BigWigs 비활성화.",
	["|cffeda55fClick|r to enable."] = "|cffeda55f클릭|r : 모듈 활성화.",
	["Big Wigs is currently disabled."] = "BigWigs가 비활성화 되어 있습니다.",
	["Active boss modules"] = "보스 모듈 활성화",
	["Hidden"] = "숨김",
	["Shown"] = "표시",
	["Minimap"] = "미니맵",
	["Toggle the minimap button."] = "미니맵 버튼 토글",
	["All running modules have been reset."] = "모든 실행중인 모듈을 초기화합니다.",
	["All running modules have been disabled."] = "모든 실행중인 모듈을 비활성화 합니다.",
	["%s reset."] = "%s 초기화되었습니다.",
	["%s disabled."] = "%s 비활성화 되었습니다.",
} end)

L:RegisterTranslations("zhCN", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00模块运行中|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fShift+Click|r to disable them. |cffeda55fCtrl+Shift+Click|r to disable Big Wigs completely."] = "你可以点击图标重置所有运行中的模块。",
	["Active boss modules"] = "激活首领模块",
	["Hidden"] = "隐藏",
	["Shown"] = "显示",
	["Minimap"] = "小地图",
	["Toggle the minimap button."] = "切换是否显示小地图图标。",
	["All running modules have been reset."] = "所有运行中的模块都已重置。",
} end)

L:RegisterTranslations("deDE", function() return {
	["|cff00ff00Module running|r"] = "|cff00ff00Modul aktiviert|r",
	["|cffeda55fClick|r to reset all running modules. |cffeda55fShift+Click|r to disable them. |cffeda55fCtrl+Shift+Click|r to disable Big Wigs completely."] = "Klicken, um alle laufenden Module zur\195\188ckzusetzen. Shift-Klick um alle laufenden Module zu beenden.",
	["Active boss modules"] = "Aktive Boss Module",
	["Hidden"] = "Versteckt",
	["Shown"] = "Angezeigt",
	["Minimap"] = "Minimap",
	["Toggle the minimap button."] = "Minimap Button anzeigen.",
	["All running modules have been reset."] = "Alle laufenden Module wurden zur\195\188ckgesetzt.",
	["All running modules have been disabled."] = "Alle laufenden Module wurden beendet.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local deuce = BigWigs:NewModule("Options Menu")
deuce.consoleCmd = not FuBar and L["minimap"]
deuce.consoleOptions = not FuBar and {
	type = "toggle",
	name = L["Minimap"],
	desc = L["Toggle the minimap button."],
	get = function() return BigWigsOptions.minimapFrame and BigWigsOptions.minimapFrame:IsVisible() or false end,
	set = function(v) if v then BigWigsOptions:Show() else BigWigsOptions:Hide() end end,
	map = {[false] = L["Hidden"], [true] = L["Shown"]},
	hidden = function() return FuBar and true end,
}

----------------------------
--      FuBar Plugin      --
----------------------------

BigWigsOptions = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0", "FuBarPlugin-2.0")
BigWigsOptions.name = "FuBar - BigWigs"
BigWigsOptions:RegisterDB("BigWigsFubarDB")

BigWigsOptions.hasIcon = "Interface\\AddOns\\BigWigs\\Icons\\core-enabled"
BigWigsOptions.defaultMinimapPosition = 180
BigWigsOptions.clickableTooltip = true
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
	if IsShiftKeyDown() then
		deuce.core:ToggleModuleActive(module, false)
		self:Print(string.format(L["%s disabled."], module:ToString()))
	else
		deuce.core:BigWigs_RebootModule(module)
		self:Print(string.format(L["%s reset."], module:ToString()))
	end
end

function BigWigsOptions:OnTooltipUpdate()
	if BigWigs:IsActive() then
		local cat = tablet:AddCategory("text", L["Active boss modules"])
		for name, module in deuce.core:IterateModules() do
			if module:IsBossModule() and deuce.core:IsModuleActive(module) then
				cat:AddLine("text", name, "func", function(mod) BigWigsOptions:ModuleAction(mod) end, "arg1", module)
			end
		end
		tablet:SetHint(L["|cffeda55fClick|r to reset all running modules. |cffeda55fShift+Click|r to disable them. |cffeda55fCtrl+Shift+Click|r to disable Big Wigs completely."])
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
		if IsShiftKeyDown() then
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
		self:UpdateTooltip()
	end
end

