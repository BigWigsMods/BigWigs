
------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.0"):new("BigWigsTest")
local BB = AceLibrary("Babble-Boss-2.0")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Test"] = true,
	["Test Bar"] = true,
	["Test Bar 2"] = true,
	["Test Bar 3"] = true,
	["Test Bar 4"] = true,
	["Testing"] = true,
	["OMG Bear!"] = true,
	["*RAWR*"] = true,
	["Victory!"] = true,
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsTest = BigWigs:NewModule(L"Test")


function BigWigsTest:OnEnable()
	self:RegisterEvent("BigWigs_Test")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "TestSync", 5)
	self:RegisterEvent("BigWigs_SyncTest")
end


function BigWigsTest:BigWigs_SyncTest()
	self:TriggerEvent("BigWigs_SendSync", "TestSync")
end


function BigWigsTest:BigWigs_RecvSync(sync)
	if sync == "TestSync" then
		self:TriggerEvent("BigWigs_Message", "Testing Sync", "Green")
		self:TriggerEvent("BigWigs_StartBar", self, "Testing Sync", 10, "Interface\\Icons\\Spell_Frost_FrostShock", "Green", "Blue", "Yellow", "Red")
	end
end


function BigWigsTest:BigWigs_Test()
	self:TriggerEvent("BigWigs_StartBar", self, L"Test Bar", 15, "Interface\\Icons\\Spell_Nature_ResistNature", "Red", "Orange", "Yellow", "Green")
	self:TriggerEvent("BigWigs_Message", L"Testing", "Green", nil, "Long")
	self:ScheduleEvent("BigWigs_Message", 5, L"OMG Bear!", "Yellow", nil, "Alert")
	self:ScheduleEvent("BigWigs_Message", 10, L"*RAWR*", "Orange", nil, "Alarm")
	self:ScheduleEvent("BigWigs_Message", 15, L"Victory!", "Green", nil, "Victory")

	self:TriggerEvent("BigWigs_StartBar", self, L"Test Bar 2", 10, "Interface\\Icons\\Spell_Nature_ResistNature", "green", "yellow", "orange", "red")
	self:TriggerEvent("BigWigs_StartBar", self, L"Test Bar 3", 5, "Interface\\Icons\\Spell_Nature_ResistNature", "yellow")
	self:TriggerEvent("BigWigs_StartBar", self, L"Test Bar 4", 3, "Interface\\Icons\\Spell_Nature_ResistNature", "red")
end


