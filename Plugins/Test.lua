
------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsTest")

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

L:RegisterTranslations("zhTW", function() return {
	["Test"] = "測試",
	["Test Bar"] = "測試計時條",
	["Test Bar 2"] = "測試計時條2",
	["Test Bar 3"] = "測試計時條3",
	["Test Bar 4"] = "測試計時條4",
	["Testing"] = "測試中",
	["OMG Bear!"] = "天哪！蘇聯北極熊！",
	["*RAWR*"] = "*RAWR*",
	["Victory!"] = "勝利！",
	["Options for testing."] = "測試選項",
	["Local test"] = "本地測試",
	["Perform a local test of BigWigs."] = "執行一次本地測試。",
	["Sync test"] = "同步測試",
	["Perform a sync test of BigWigs."] = "執行一次同步測試（需要助手或領隊權限）。",
	["Testing Sync"] = "同步測試中",
} end)

L:RegisterTranslations("deDE", function() return {
	-- ["test"] = true,
	--["Test"] = "Test",
	["Test Bar"] = "Test Balken",
	["Test Bar 2"] = "Test Balken 2",
	["Test Bar 3"] = "Test Balken 3",
	["Test Bar 4"] = "Test Balken 4",
	["Testing"] = "Teste",
	["OMG Bear!"] = "OMG B\195\164r!",
	["*RAWR*"] = "RAWR",
	["Victory!"] = "Sieg!",
	["Options for testing."] = "Optionen f\195\188r den Test von BigWigs.",
	["local"] = "Lokal",
	["Local test"] = "Lokaler Test",
	["Perform a local test of BigWigs."] = "Lokalen Test durchf\195\188hren.",
	--["sync"] = "sync",
	["Sync test"] = "Synchronisations-Test",
	["Perform a sync test of BigWigs."] = "Sychronisations-Test durchf\195\188hren.",
	["Testing Sync"] = "Synchronisation testen",
} end)

L:RegisterTranslations("frFR", function() return {
	--["test"] = "test",
	--["Test"] = "Test",
	["Test Bar"] = "Barre de test",
	["Test Bar 2"] = "Barre de test 2",
	["Test Bar 3"] = "Barre de test 3",
	["Test Bar 4"] = "Barre de test 4",
	["Testing"] = "Test",
	["OMG Bear!"] = "Un ours !",
	["*RAWR*"] = "*GRRR*",
	["Victory!"] = "Victoire !",
	["Options for testing."] = "Options concernant les tests.",
	--["local"] = "local",
	["Local test"] = "Test local",
	["Perform a local test of BigWigs."] = "Effectue un test local de BigWigs.",
	--["sync"] = "sync",
	["Sync test"] = "Test de synchronisation",
	["Perform a sync test of BigWigs."] = "Effectue un test de synchronisation de BigWigs.",
	["Testing Sync"] = "Test synchro",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsTest = BigWigs:NewModule(L["Test"])
BigWigsTest.revision = tonumber(string.sub("$Revision: 14954 $", 12, -3))

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
