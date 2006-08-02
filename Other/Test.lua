
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
		self:TriggerEvent("BigWigs_StartBar", self, "Testing Sync", 10, 1, "Interface\\Icons\\Spell_Frost_FrostShock", "Green", "Blue", "Yellow", "Red")
	end
end


function BigWigsTest:BigWigs_Test()
	self:TriggerEvent("BigWigs_StartBar", self, L"Test Bar", 15, 1, "Interface\\Icons\\Spell_Nature_ResistNature", "Red", "Orange", "Yellow", "Green")
	self:TriggerEvent("BigWigs_Message", L"Testing", "Green", nil, "Long")
	self:ScheduleEvent("BigWigs_Message", 5, L"OMG Bear!", "Yellow", nil, "Alert")
	self:ScheduleEvent("BigWigs_Message", 10, L"*RAWR*", "Orange", nil, "Alarm")
	self:ScheduleEvent("BigWigs_Message", 15, L"Victory!", "Green", nil, "Victory")

	self:TriggerEvent("BigWigs_StartBar", self, L"Test Bar 2", 10, 2, "Interface\\Icons\\Spell_Nature_ResistNature", "green", "yellow", "orange", "red")
	self:TriggerEvent("BigWigs_StartBar", self, L"Test Bar 3", 5, 3, "Interface\\Icons\\Spell_Nature_ResistNature", "yellow")
	self:TriggerEvent("BigWigs_StartBar", self, L"Test Bar 4", 3, 4, "Interface\\Icons\\Spell_Nature_ResistNature", "red")
end



---------------------------------------------------------------------


------------------------------
--      Are you local?      --
------------------------------

local L2 = AceLibrary("AceLocale-2.0"):new("BigWigsDebug")
local BB = AceLibrary("Babble-Boss-2.0")


----------------------------
--      Localization      --
----------------------------

L2:RegisterTranslations("enUS", function() return {
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

local L2 = AceLibrary("AceLocale-2.0"):new("BigWigsDebug")
L2:RegisterTranslations("enUS", function() return {} end)
BigWigsDebug = BigWigs:NewModule("Debug", "Metrognome-2.0")
BigWigsDebug.zonename = "Silithus"
BigWigsDebug.enabletrigger = "Aurel Goldleaf"


function BigWigsDebug:OnInitialize()
	self:RegisterEvent("BigWigs_DebugDisable")
	self:RegisterMetro("BigWigs_Debug_Metro", BigWigsDebug.MetroTester, 7, BigWigsDebug)
end


function BigWigsDebug:OnEnable()
	self:StartMetro("BigWigs_Debug_Metro", 1)
	self:ScheduleEvent("BigWigs_DebugDisable", 5)
	self:ScheduleEvent("BigWigs_Message", 7, "TriggerDelayedEvent fired", "Yellow", nil, "Alert")

	self:TriggerEvent("BigWigs_Message", "Debug start", "Green", nil, "Alert")
	self:TriggerEvent("BigWigs_StartBar", self, "Debug test", 5, 1, "Interface\\Icons\\Spell_Nature_ResistNature", "Green")
	self:TriggerEvent("BigWigs_StartBar", self, "Message", 7, 2, "Interface\\Icons\\Spell_Nature_ResistNature", "Red", "Orange", "Yellow", "Green")
end


function BigWigsDebug:MetroTester()
	self:TriggerEvent("BigWigs_Message", "Metrognome timer fired", "Yellow", nil, "Alert")
end


function BigWigsDebug:BigWigs_DebugDisable()
	self:TriggerEvent("BigWigs_Message", "Disabling debug module", "Yellow", nil, "Alert")
	self.core:ToggleModuleActive(self, false)
end

