assert(BigWigs, "BigWigs not found!")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsFlash")

L:RegisterTranslations("enUS", function() return {
	["Flash"] = true,
	["Flash the screen blue when something important happens that directly affects you."] = true,
	["Toggle Flash on or off."] = true,

	["Test"] = true,
	["Perform a Flash test."] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Flash"] = "번쩍임",
	--["Flash the screen blue when something important happens that directly affects you."] = true,
	["Toggle Flash on or off."] = "번쩍임을 켜거나 끕니다.",
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
--      Frame Creation      --
------------------------------

local display = CreateFrame("Frame", "BWFlash", UIParent)
display:SetFrameStrata("BACKGROUND")
display:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",})
display:SetBackdropColor(0,0,1,0.4)
display:SetPoint("CENTER", UIPARENT, "CENTER")
display:SetWidth(2000)
display:SetHeight(2000)
display:Hide()

------------------------------
--      Event Handlers      --
------------------------------

local function drawInOne()
	display:Show()
end

local function drawInTwo()
	display:SetBackdropColor(0,0,1,0.5)
end

local function drawInThree()
	display:SetBackdropColor(0,0,1,0.6)
end

local function drawInFour()
	display:SetBackdropColor(0,0,1,0.7)
end

local function drawOutOne()
	display:SetBackdropColor(0,0,1,0.6)
end

local function drawOutTwo()
	display:SetBackdropColor(0,0,1,0.5)
end

local function drawOutThree()
	display:SetBackdropColor(0,0,1,0.4)
end

local function drawOutFour()
	display:Hide()
end

function mod:BigWigs_Personal()
	if self.db.profile.flash then
		self:ScheduleEvent("BWFlash1", drawInOne, 0.1)
		self:ScheduleEvent("BWFlash2", drawInTwo, 0.17)
		self:ScheduleEvent("BWFlash3", drawInThree, 0.24)
		self:ScheduleEvent("BWFlash4", drawInFour, 0.31)
		self:ScheduleEvent("BWFlash5", drawOutOne, 0.38)
		self:ScheduleEvent("BWFlash6", drawOutTwo, 0.45)
		self:ScheduleEvent("BWFlash7", drawOutThree, 0.52)
		self:ScheduleEvent("BWFlash8", drawOutFour, 0.57)
	end
end
