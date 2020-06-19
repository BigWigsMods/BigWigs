local L = BigWigs:NewBossLocale("Azuregos", "deDE")
if not L then return end
if L then
	L.bossName = "Azuregos"

	L.teleport = "Teleport"
	L.teleport_desc = "Warnung f\195\188r Azuregos Teleport."
	L.teleport_trigger = "Tretet mir"
	L.teleport_message = "Teleport!"
end

L = BigWigs:NewBossLocale("Lord Kazzak", "deDE")
if L then
	L.bossName = "Lord Kazzak"

	L.supreme = "Supreme Mode"
	L.supreme_desc = "Warnung vor Supreme Mode."
	L.engage_trigger = "F\195\188r die Legion! F\195\188r Kil'jaeden!"
	L.engage_message = "Lord Kazzak angegriffen! Supreme Mode in 3 Minuten!"
	L.supreme1min  = "Supreme Mode in 1 Minute!"
	L.supreme30sec = "Supreme Mode in 30 Sekunden!"
	L.supreme10sec = "Supreme Mode in 10 Sekunden!"
	L.bartext = "Supreme Mode"
end

local L = BigWigs:NewBossLocale("Emeriss", "deDE")
if L then
	L.bossName = "Smariss"

	-- L.engage_trigger = "Hope is a DISEASE of the soul! This land shall wither and die!"
end

local L = BigWigs:NewBossLocale("Lethon", "deDE")
if L then
	L.bossName = "Lethon"

	-- L.engage_trigger = "I can sense the SHADOW on your hearts. There can be no rest for the wicked!"
end

local L = BigWigs:NewBossLocale("Taerar", "deDE")
if L then
	L.bossName = "Taerar"

	-- L.engage_trigger = "Peace is but a fleeting dream! Let the NIGHTMARE reign!"
end

local L = BigWigs:NewBossLocale("Ysondre", "deDE")
if L then
	L.bossName = "Ysondre"

	-- L.engage_trigger = "The strands of LIFE have been severed! The Dreamers must be avenged!"
end
