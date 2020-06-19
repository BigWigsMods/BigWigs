local L = BigWigs:NewBossLocale("Azuregos", "esES") or BigWigs:NewBossLocale("Azuregos", "esMX")
if not L then return end
if L then
	L.bossName = "Azuregos"

	--L.teleport = "Teleport Alert"
	--L.teleport_desc = "Warn for teleport."
	--L.teleport_trigger = "Come, little ones"
	--L.teleport_message = "Teleport!"
end

L = BigWigs:NewBossLocale("Lord Kazzak", "esES") or BigWigs:NewBossLocale("Lord Kazzak", "esMX")
if L then
	L.bossName = "Lord Kazzak"

	--L.supreme = "Supreme Alert"
	--L.supreme_desc = "Warn for Supreme Mode"
	--L.engage_trigger = "For the Legion! For Kil'Jaeden!"
	--L.engage_message = "Lord Kazzak engaged, 3mins until Supreme!"
	--L.supreme1min = "Supreme mode in 1 minute!"
	--L.supreme30sec = "Supreme mode in 30 seconds!"
	--L.supreme10sec = "Supreme mode in 10 seconds!"
	--L.bartext = "Supreme mode"
end
