------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsTest")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Test"] = true,
	["Test Bar "] = true,
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
	["Test Bar "] = "테스트 바 ",
	["Testing"] = "테스트중",
	["OMG Bear!"] = "OMG 생성!",
	["*RAWR*"] = "*공격대경고*",
	["Victory!"] = "승리!",
	["Commands for testing bars, messages and synchronization."] = "바, 메세지와 동기화 테스트 관련 명령어입니다.",
	["Local test"] = "로컬 테스트",
	["Perform a local test of BigWigs."] = "BigWigs의 로컬 테스트를 수행합니다.",
	["Sync test"] = "동기화 테스트",
	["Perform a sync test of BigWigs."] = "BigWigs의 동기화 테스트를 수행합니다.",
	["Testing Sync"] = "동기화 테스트 중",
} end)

L:RegisterTranslations("zhCN", function() return {
	["Test"] = "测试",
	["Test Bar "] = "测试记时条",
	["Testing"] = "测试中……",
	["OMG Bear!"] = "OMG! Bear!",
	["*RAWR*"] = "*团队通知*",
	["Victory!"] = "胜利！",
	["Commands for testing bars, messages and synchronization."] = "测试计时条、信息及同步指令。",
	["Local test"] = "本地测试",
	["Perform a local test of BigWigs."] = "执行 BigWigs 本地测试。",
	["Sync test"] = "同步测试",
	["Perform a sync test of BigWigs."] = "执行 BigWigs 同步测试（需要权限）。",
	["Testing Sync"] = "同步测试中……",
} end)

L:RegisterTranslations("zhTW", function() return {
	["Test"] = "測試",
	["Test Bar "] = "測試計時條",
	["Testing"] = "測試中",
	["OMG Bear!"] = "天哪! 蘇聯北極熊!",
	["*RAWR*"] = "*RAWR*",
	["Victory!"] = "勝利!",
	["Commands for testing bars, messages and synchronization."] = "測試選項",
	["Local test"] = "本地測試",
	["Perform a local test of BigWigs."] = "執行 BigWigs 本地測試",
	["Sync test"] = "同步測試",
	["Perform a sync test of BigWigs."] = "執行 BigWigs 同步測試（需要助手或領隊權限）",
	["Testing Sync"] = "同步測試中",
} end)

L:RegisterTranslations("deDE", function() return {
	["Test"] = "Test",
	["Test Bar "] = "Test Balken ",
	["Testing"] = "Teste",
	["OMG Bear!"] = "OMG Bär!",
	["*RAWR*"] = "RAWR",
	["Victory!"] = "Sieg!",
	["Commands for testing bars, messages and synchronization."] = "Optionen für den Test von BigWigs.",
	["Local test"] = "Lokaler Test",
	["Perform a local test of BigWigs."] = "Lokalen Test von BigWigs durchführen.",
	["Sync test"] = "Synchronisations-Test",
	["Perform a sync test of BigWigs."] = "Sychronisations-Test durchführen.",
	["Testing Sync"] = "Teste Synchronisation",
} end)

L:RegisterTranslations("frFR", function() return {
	["Test"] = "Test",
	["Test Bar "] = "Barre de test ",
	["Testing"] = "Test",
	["OMG Bear!"] = "Un ours !",
	["*RAWR*"] = "*GRRR*",
	["Victory!"] = "Victoire !",
	["Commands for testing bars, messages and synchronization."] = "Options concernant les tests.",
	["Local test"] = "Tester localement",
	["Perform a local test of BigWigs."] = "Effectue un test local de BigWigs.",
	["Sync test"] = "Tester la synchronisation",
	["Perform a sync test of BigWigs."] = "Effectue un test de synchronisation de BigWigs.",
	["Testing Sync"] = "Test de synchro",
} end)

L:RegisterTranslations("esES", function() return {
	["Test"] = "Probar",
	["Test Bar "] = "Barra de prueba",
	["Testing"] = "Probando",
	["OMG Bear!"] = "¡¡¡ Oh dios mío, un oso praderil !!!",
	["*RAWR*"] = "*RAAAAWRRR*",
	["Victory!"] = "¡Victoria!",
	["Commands for testing bars, messages and synchronization."] = "Comandos para probar las barras, mensajes y sincronización.",
	["Local test"] = "Prueba local",
	["Perform a local test of BigWigs."] = "Realiza una prueba local de BigWigs.",
	["Sync test"] = "Prueba de sinc.",
	["Perform a sync test of BigWigs."] = "Realiza una prueba de sincronización de BigWigs.",
	["Testing Sync"] = "Probando sinc.",
} end)
-- Translated by wow.playhard.ru translators
L:RegisterTranslations("ruRU", function() return {
	["Test"] = "Тест",
	["Test Bar "] = "Тестовая полоса",
	["Testing"] = "Тестирование",
	["OMG Bear!"] = "Не может быть!",
	["*RAWR*"] = "*МДЯ*",
	["Victory!"] = "Победа!",
	["Commands for testing bars, messages and synchronization."] = "Команды для тестирования полос, сообщений и синхронизации.",
	["Local test"] = "Локальный тест",
	["Perform a local test of BigWigs."] = "Локальный тест BigWigsа",
	["Sync test"] = "Синх тест",
	["Perform a sync test of BigWigs."] = "Синх тест BigWigsа",
	["Testing Sync"] = "Тестирование синхр",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewModule("Test")
plugin.revision = tonumber(("$Revision$"):sub(12, -3))
plugin.external = true

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
		self:Bar(L["Testing Sync"], 10, "Spell_Frost_FrostShock", true, 0, 0, 1)
	end
end

function plugin:BigWigs_Test()
	self:Bar(("%s%d"):format(L["Test Bar "], 4), 30, 34976)

	self:Message(L["Testing"], "Attention", true, "Long", nil, 25596)
	self:DelayedMessage(10, L["OMG Bear!"], "Important", true, "Alert", nil, 7903)
	self:DelayedMessage(20, L["*RAWR*"], "Urgent", true, "Alarm", nil, 27006)
	self:DelayedMessage(30, L["Victory!"], "Bosskill", true, "Victory", nil, 34976)

	self:Bar(("%s%d"):format(L["Test Bar "], 3), 20, 27006)
	self:Bar(("%s%d"):format(L["Test Bar "], 2), 10, 7903)
	self:Bar(("%s%d"):format(L["Test Bar "], 1), 5, 25596, true, 1, 0, 0)
end

