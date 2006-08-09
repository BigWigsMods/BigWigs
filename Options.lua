
assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.0"):new("BigWigsOptions")
local Tablet = AceLibrary("Tablet-2.0")
local Dewdrop = AceLibrary("Dewdrop-2.0")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["|cff00ff00Module running|r"] = true,
--	tablethint = "You can disable a currently running module by clicking on its name.  Loaded modules will have a check next to them in their respective sub-menus.",
	tablethint = "You can reset all running modules by clicking on the icon.",
	["Active boss modules"] = true,
	["Hidden"] = true,
	["Shown"] = true,
	["minimap"] = true,
	["Minimap"] = true,
	["Toggle the minimap button."] = true,
	["All running modules have been reset."] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["minimap"] = "미니맵",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local deuce = BigWigs:NewModule("Options Menu")
deuce.consoleCmd = not FuBar and L"minimap"
deuce.consoleOptions = not FuBar and {
	type = "toggle",
	name = "Minimap",
	desc = "Toggle the minimap button.",
	get = function() return BigWigsOptions.minimapFrame:IsShown() end,
	set = function(v) if v then BigWigsOptions:Show() else BigWigsOptions:Hide() end end,
	map = {[false] = L"Hidden", [true] = L"Shown"},
	hidden = function() return FuBar and true end,
}


----------------------------
--      FuBar Plugin      --
----------------------------

BigWigsOptions = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0", "FuBarPlugin-2.0")
BigWigsOptions.name = "FuBar - BigWigs"
BigWigsOptions:RegisterDB("BigWigsFubarDB")

--~~ BigWigsOptions.hideWithoutStandby = true
BigWigsOptions.hasIcon = "Interface\\Icons\\INV_Misc_Orb_05"
--~~ BigWigsOptions.hasNoText  = true
BigWigsOptions.defaultMinimapPosition = 180
BigWigsOptions.cannotDetachTooltip = true

-- total hack
BigWigsOptions.OnMenuRequest = deuce.core.cmdtable
local args = AceLibrary("FuBarPlugin-2.0"):GetAceOptionsDataTable(BigWigsOptions)
for k,v in pairs(args) do
	if BigWigsOptions.OnMenuRequest.args[k] == nil then
		DEFAULT_CHAT_FRAME:AddMessage(k)
		BigWigsOptions.OnMenuRequest.args[k] = v
	end
end
-- end hack

-----------------------------
--      FuBar Methods      --
-----------------------------

function BigWigsOptions:OnTooltipUpdate()
	local cat = Tablet:AddCategory("text", L"Active boss modules")

	for name, module in deuce.core:IterateModules() do
		if deuce.core:IsModuleActive(module) and module:IsBossModule() then
			cat:AddLine("text", name)
		end
	end

	Tablet:SetHint(L"tablethint")
end

function BigWigsOptions:OnClick()
	for name, module in deuce.core:IterateModules() do
		if deuce.core:IsModuleActive(module) and module:IsBossModule() then
			deuce.core:BigWigs_RebootModule(module)
		end
	end
	self:Print(L"All running modules have been reset.")
end