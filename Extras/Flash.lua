assert(BigWigs, "BigWigs not found!")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsFlash")

L:RegisterTranslations("enUS", function() return {
	["Flash"] = true,
	["Flash the screen when something important happens that affects you."] = true,
	["Toggle Flash on or off."] = true,
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
	desc = L["Flash the screen when something important happens that affects you."],
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
		self:ScheduleEvent("BWFlash2", drawInTwo, 0.15)
		self:ScheduleEvent("BWFlash3", drawInThree, 0.2)
		self:ScheduleEvent("BWFlash4", drawInFour, 0.25)
		self:ScheduleEvent("BWFlash5", drawOutOne, 0.3)
		self:ScheduleEvent("BWFlash6", drawOutTwo, 0.35)
		self:ScheduleEvent("BWFlash7", drawOutThree, 0.4)
		self:ScheduleEvent("BWFlash8", drawOutFour, 0.45)
	end
end
