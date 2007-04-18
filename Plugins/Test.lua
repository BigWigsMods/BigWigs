------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsTest")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Test"] = true,
	["Test Bar %d"] = true,
	["Testing"] = true,
	["OMG Bear!"] = true,
	["*RAWR*"] = true,
	["Victory!"] = true,
	["Commands for testing bars, messages and synchronization."] = true,
	["Local test"] = true,
	["Perform a local test of BigWigs."] = true,
	["Sync test"] = true,
	["Perform a sync test of BigWigs."] = true,
	["Testing Sync"] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Test"] = "테스트",
	["Test Bar %d"] = "테스트 바 %d",
	["Testing"] = "테스트중",
	["OMG Bear!"] = "OMG 생성!",
	["*RAWR*"] = "*공격대경고*",
	["Victory!"] = "승리!",
	["Commands for testing bars, messages and synchronization."] = "바, 메세지와 동기화 테스트 관련 명령어입니다.",
	["Local test"] = "내부 테스트",
	["Perform a local test of BigWigs."] = "BigWigs의 내부 테스트를 수행합니다.",
	["Sync test"] = "동기화 테스트",
	["Perform a sync test of BigWigs."] = "BigWigs의 동기화 테스트를 수행합니다.",
	["Testing Sync"] = "동기화 테스트 중",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Test"] = "测试",
	["Test Bar %d"] = "测试计时条%d",
	["Testing"] = "测试中",
	["OMG Bear!"] = "老天！熊！",
	["*RAWR*"] = "*RAWR*",
	["Victory!"] = "胜利！",
	["Commands for testing bars, messages and synchronization."] = "测试选项",
	["Local test"] = "本地测试",
	["Perform a local test of BigWigs."] = "执行一次本地测试。",
	["Sync test"] = "同步测试",
	["Perform a sync test of BigWigs."] = "执行一次同步测试（需要助力或更高权限）。",
	["Testing Sync"] = "同步测试中",
} end)

L:RegisterTranslations("zhTW", function() return {
	["Test"] = "測試",
	["Test Bar %d"] = "測試計時條%d",
	["Testing"] = "測試中",
	["OMG Bear!"] = "天哪！蘇聯北極熊！",
	["*RAWR*"] = "*RAWR*",
	["Victory!"] = "勝利！",
	["Commands for testing bars, messages and synchronization."] = "測試選項",
	["Local test"] = "本地測試",
	["Perform a local test of BigWigs."] = "執行一次本地測試。",
	["Sync test"] = "同步測試",
	["Perform a sync test of BigWigs."] = "執行一次同步測試（需要助手或領隊權限）。",
	["Testing Sync"] = "同步測試中",
} end)

L:RegisterTranslations("deDE", function() return {
	["Test"] = "Test",
	["Test Bar %d"] = "Test Balken %d",
	["Testing"] = "Teste",
	["OMG Bear!"] = "OMG B\195\164r!",
	["*RAWR*"] = "RAWR",
	["Victory!"] = "Sieg!",
	["Commands for testing bars, messages and synchronization."] = "Optionen f\195\188r den Test von BigWigs.",
	["Local test"] = "Lokaler Test",
	["Perform a local test of BigWigs."] = "Lokalen Test von BigWigs durchf\195\188hren.",
	["Sync test"] = "Synchronisations-Test",
	["Perform a sync test of BigWigs."] = "Sychronisations-Test durchf\195\188hren.",
	["Testing Sync"] = "Teste Synchronisation",
} end)

L:RegisterTranslations("frFR", function() return {
	["Test"] = "Test",
	["Test Bar %d"] = "Barre de test %d",
	["Testing"] = "Test",
	["OMG Bear!"] = "Un ours !",
	["*RAWR*"] = "*GRRR*",
	["Victory!"] = "Victoire !",
	["Commands for testing bars, messages and synchronization."] = "Options concernant les tests.",
	["Local test"] = "Test local",
	["Perform a local test of BigWigs."] = "Effectue un test local de BigWigs.",
	["Sync test"] = "Test de synchronisation",
	["Perform a sync test of BigWigs."] = "Effectue un test de synchronisation de BigWigs.",
	["Testing Sync"] = "Test synchro",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewModule("Test")
plugin.revision = tonumber(string.sub("$Revision$", 12, -3))

plugin.consoleCmd = L["Test"]
plugin.consoleOptions = {
	type = "group",
	name = L["Test"],
	desc = L["Commands for testing bars, messages and synchronization."],
	handler = plugin,
	args = {
		["local"] = {
			type = "execute",
			name = L["Local test"],
			desc = L["Perform a local test of BigWigs."],
			func = "BigWigs_Test",
		},
		["sync"] = {
			type = "execute",
			name = L["Sync test"],
			desc = L["Perform a sync test of BigWigs."],
			func = "BigWigs_SyncTest",
			disabled = function() return ( not IsRaidLeader() and not IsRaidOfficer() ) end,
		},
	}
}

function plugin:OnEnable()
	self:RegisterEvent("BigWigs_Test")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "TestSync", 5)
	self:RegisterEvent("BigWigs_SyncTest")
end

function plugin:BigWigs_SyncTest()
	self:TriggerEvent("BigWigs_SendSync", "TestSync")
end

function plugin:BigWigs_RecvSync(sync)
	if sync == "TestSync" then
		self:Message(L["Testing Sync"], "Positive")
		self:Bar(L["Testing Sync"], 10, "Spell_Frost_FrostShock", true, "Green", "Blue", "Yellow", "Red")
	end
end

function plugin:BigWigs_Test()
	self:Bar(L["Test Bar %d"]:format(1), 15, "Spell_Nature_ResistNature")

	self:Message(L["Testing"], "Attention", true, "Long")
	self:DelayedMessage(5, L["OMG Bear!"], "Important", true, "Alert")
	self:DelayedMessage(10, L["*RAWR*"], "Urgent", true, "Alarm")
	self:DelayedMessage(15, L["Victory!"], "Bosskill", true, "Victory")

	self:Bar(L["Test Bar %d"]:format(2), 10, "Spell_Nature_ResistNature")
	self:Bar(L["Test Bar %d"]:format(3), 5, "Spell_Nature_ResistNature")
	self:Bar(L["Test Bar %d"]:format(4), 3, "Spell_Nature_ResistNature", true, "black")
end

