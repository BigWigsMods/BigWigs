
------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.0"):new("BigWigsTest")
local BB = AceLibrary("Babble-Boss-2.0")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["test"] = true,
	["Test"] = true,
	["Test Bar"] = true,
	["Test Bar 2"] = true,
	["Test Bar 3"] = true,
	["Test Bar 4"] = true,
	["Testing"] = true,
	["OMG Bear!"] = true,
	["*RAWR*"] = true,
	["Victory!"] = true,
	["Options for testing."] = true,
	["local"] = true,
	["Local test"] = true,
	["Perform a local test of BigWigs."] = true,
	["sync"] = true,
	["Sync test"] = true,
	["Perform a sync test of BigWigs."] = true,
	["Testing Sync"] = true,
} end)

L:RegisterTranslations("zhCN", function() return {
	["Test"] = "测试",
	["Test Bar"] = "测试计时条",
	["Test Bar 2"] = "测试计时条2",
	["Test Bar 3"] = "测试计时条3",
	["Test Bar 4"] = "测试计时条4",
	["Testing"] = "测试中",
	["OMG Bear!"] = "老天！熊！",
	["*RAWR*"] = "*RAWR*",
	["Victory!"] = "胜利！",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsTest = BigWigs:NewModule(L["Test"])
BigWigsTest.revision = tonumber(string.sub("$Revision$", 12, -3))

BigWigsTest.consoleCmd = L["test"]
BigWigsTest.consoleOptions = {
	type = "group",
	name = L["Test"],
	desc = L["Options for testing."],
	args   = {
		[L["local"]] = {
			type = "execute",
			name = L["Local test"],
			desc = L["Perform a local test of BigWigs."],
			func = function() BigWigsTest:TriggerEvent("BigWigs_Test") end,
		},
		[L["sync"]] = {
			type = "execute",
			name = L["Sync test"],
			desc = L["Perform a sync test of BigWigs."],
			func = function() BigWigsTest:TriggerEvent("BigWigs_SyncTest") end,
		},		
	}
}

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
		self:TriggerEvent("BigWigs_Message", L["Testing Sync"], "Positive")
		self:TriggerEvent("BigWigs_StartBar", self, L["Testing Sync"], 10, "Interface\\Icons\\Spell_Frost_FrostShock", true, "Green", "Blue", "Yellow", "Red")
	end
end


function BigWigsTest:BigWigs_Test()
	self:TriggerEvent("BigWigs_StartBar", self, L["Test Bar"], 15, "Interface\\Icons\\Spell_Nature_ResistNature")
	self:TriggerEvent("BigWigs_Message", L["Testing"], "Attention", nil, "Long")
	self:ScheduleEvent("BigWigs_Message", 5, L["OMG Bear!"], "Important", nil, "Alert")
	self:ScheduleEvent("BigWigs_Message", 10, L["*RAWR*"], "Urgent", nil, "Alarm")
	self:ScheduleEvent("BigWigs_Message", 15, L["Victory!"], "Bosskill", nil, "Victory")

	self:TriggerEvent("BigWigs_StartBar", self, L["Test Bar 2"], 10, "Interface\\Icons\\Spell_Nature_ResistNature")
	self:TriggerEvent("BigWigs_StartBar", self, L["Test Bar 3"], 5, "Interface\\Icons\\Spell_Nature_ResistNature")
	self:TriggerEvent("BigWigs_StartBar", self, L["Test Bar 4"], 3, "Interface\\Icons\\Spell_Nature_ResistNature", true, "black")
end
