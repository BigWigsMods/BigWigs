
------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.0"):new("BigWigsTest")

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

L:RegisterTranslations("koKR", function() return {
--	["test"] = "테스트",
	["Test"] = "테스트",
	["Test Bar"] = "테스트 바",
	["Test Bar 2"] = "테스트 바 2",
	["Test Bar 3"] = "테스트 바 3",
	["Test Bar 4"] = "테스트 바 4",
	["Testing"] = "테스트중",
	["OMG Bear!"] = "OMG Bear!",
	["*RAWR*"] = "*공격대경고*",
	["Victory!"] = "승리!",
	["Options for testing."] = "테스트 설정",
--	["local"] = "지역",
	["Local test"] = "지역 테스트",
	["Perform a local test of BigWigs."] = "BigWigs의 지역 테스트 실행",
--	["sync"] = "동기화",
	["Sync test"] = "동기화 테스트",
	["Perform a sync test of BigWigs."] = "BigWigs의 동기화 테스트 실행",
	["Testing Sync"] = "동기화 테스트 중",
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
	["Options for testing."] = "测试选项",
	["Local test"] = "本地测试",
	["Perform a local test of BigWigs."] = "执行一次本地测试。",
	["Sync test"] = "同步测试",
	["Perform a sync test of BigWigs."] = "执行一次同步测试（需要助力或更高权限）。",
	["Testing Sync"] = "同步测试中",
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
			disabled = function() return ( not IsRaidLeader() and not IsRaidOfficer() ) end,
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
	self:TriggerEvent("BigWigs_Message", L["Testing"], "Attention", true, "Long")
	self:ScheduleEvent("BigWigs_Message", 5, L["OMG Bear!"], "Important", true, "Alert")
	self:ScheduleEvent("BigWigs_Message", 10, L["*RAWR*"], "Urgent", true, "Alarm")
	self:ScheduleEvent("BigWigs_Message", 15, L["Victory!"], "Bosskill", true, "Victory")

	self:TriggerEvent("BigWigs_StartBar", self, L["Test Bar 2"], 10, "Interface\\Icons\\Spell_Nature_ResistNature")
	self:TriggerEvent("BigWigs_StartBar", self, L["Test Bar 3"], 5, "Interface\\Icons\\Spell_Nature_ResistNature")
	self:TriggerEvent("BigWigs_StartBar", self, L["Test Bar 4"], 3, "Interface\\Icons\\Spell_Nature_ResistNature", true, "black")
end
