local L = BigWigs:NewBossLocale("Azuregos", "koKR")
if not L then return end
if L then
	L.bossName = "아주어고스"

	L.teleport = "소환 경고"
	L.teleport_desc = "소환에 대한 경고"
	L.teleport_trigger = "오너라, 조무래기들아! 덤벼봐라!"
	L.teleport_message = "강제 소환!"
end

L = BigWigs:NewBossLocale("Lord Kazzak", "koKR")
if L then
	L.bossName = "군주 카자크"

	L.supreme = "무적 경고"
	L.supreme_desc = "무적 모드에 대한 경고"
	L.engage_trigger = "군단을 위하여! 킬제덴을 위하여!" --CHECK
	L.engage_message = "카쟈크 전투 개시, 3분 후 무적!"
	L.supreme1min = "무적 모드 - 1 분전!"
	L.supreme30sec = "무적 모드 - 30 초전!"
	L.supreme10sec = "무적 모드 - 10 초전!"
	L.bartext = "무적 모드"
end
