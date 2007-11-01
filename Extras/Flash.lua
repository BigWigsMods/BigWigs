assert(BigWigs, "BigWigs not found!")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsFlash")
local display = nil

L:RegisterTranslations("enUS", function() return {
	["Flash"] = true,
	["Flash the screen blue when something important happens that directly affects you."] = true,
	["Toggle Flash on or off."] = true,

	["Test"] = true,
	["Perform a Flash test."] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Flash"] = "번쩍임",
	["Flash the screen blue when something important happens that directly affects you."] = "당신에게 직접적으로 중요한 무언가가 영향을 미칠때 화면을 파란색으로 번쩍입니다.",
	["Toggle Flash on or off."] = "번쩍임을 켜거나 끕니다.",

	--["Test"] = true,
	--["Perform a Flash test."] = true,
} end)

L:RegisterTranslations("frFR", function() return {
	["Flash"] = "Flash",
	["Flash the screen blue when something important happens that directly affects you."] = "Fais flasher l'écran en bleu quand quelque chose d'important vous affecte directement.",
	["Toggle Flash on or off."] = "Fais flasher ou non l'écran.",

	["Test"] = "Test",
	["Perform a Flash test."] = "Effectue un test du flash.",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Flash"] = "屏幕闪烁通知",
	["Flash the screen blue when something important happens that directly affects you."] = "如有重要事件影响到你，屏幕将会蓝色闪烁以告知玩家。",
	["Toggle Flash on or off."] = "启用或禁用屏幕闪烁通知。",

	["Test"] = "测试",
	["Perform a Flash test."] = "进行屏幕闪烁通知测试。",
} end)
----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule("Flash")
mod.revision = tonumber(("$Revision$"):sub(12, -3))
mod.defaultDB = {
	flash = false,
}
mod.external = true
mod.consoleCmd = L["Flash"]
mod.consoleOptions = {
	type = "group",
	name = L["Flash"],
	desc = L["Flash the screen blue when something important happens that directly affects you."],
	args = {
		[L["Flash"]] = {
			type = "toggle",
			name = L["Flash"],
			desc = L["Toggle Flash on or off."],
			get = function() return mod.db.profile.flash end,
			set = function(v)
				mod.db.profile.flash = v
			end,
		},
		[L["Test"]] = {
			type = "execute",
			name = L["Test"],
			desc = L["Perform a Flash test."],
			handler = mod,
			func = "BigWigs_Personal",
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("BigWigs_Personal")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_Personal()
	if self.db.profile.flash then
		if not display then --frame creation
			display = CreateFrame("Frame", "BWFlash", UIParent)
			display:SetFrameStrata("BACKGROUND")
			display:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",})
			display:SetBackdropColor(0,0,1,0.4)
			display:SetPoint("CENTER", UIPARENT, "CENTER")
			display:SetWidth(2000)
			display:SetHeight(2000)
			display:Hide()
		 end

		self:ScheduleEvent("BWFlash1", display.Show, 0.1, display)
		self:ScheduleEvent("BWFlash2", display.SetBackdropColor, 0.17, display, 0, 0, 1, 0.5)
		self:ScheduleEvent("BWFlash3", display.SetBackdropColor, 0.24, display, 0, 0, 1, 0.6)
		self:ScheduleEvent("BWFlash4", display.SetBackdropColor, 0.31, display, 0, 0, 1, 0.7)
		self:ScheduleEvent("BWFlash5", display.SetBackdropColor, 0.38, display, 0, 0, 1, 0.6)
		self:ScheduleEvent("BWFlash6", display.SetBackdropColor, 0.45, display, 0, 0, 1, 0.5)
		self:ScheduleEvent("BWFlash7", display.SetBackdropColor, 0.52, display, 0, 0, 1, 0.4)
		self:ScheduleEvent("BWFlash8", display.Hide, 0.57, display)
	end
end
