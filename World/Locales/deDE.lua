local L = BigWigs:NewBossLocale("Azuregos", "deDE")
if not L then return end
if L then
	L.teleport = "Teleport"
	L.teleport_desc = "Warnung f\195\188r Azuregos Teleport."
	L.teleport_trigger = "Tretet mir"
	L.teleport_message = "Teleport!"
end

L = BigWigs:NewBossLocale("Lord Kazzak", "deDE")
if L then
	L.supreme = "Supreme Mode"
	L.supreme_desc = "Warnung vor Supreme Mode."
	L.engage_trigger = "F\195\188r die Legion! F\195\188r Kil'jaeden!"
	L.engage_message = "Lord Kazzak angegriffen! Supreme Mode in 3 Minuten!"
	L.supreme1min  = "Supreme Mode in 1 Minute!"
	L.supreme30sec = "Supreme Mode in 30 Sekunden!"
	L.supreme10sec = "Supreme Mode in 10 Sekunden!"
	L.bartext = "Supreme Mode"
end
