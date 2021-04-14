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

	-- L.engage_trigger = "For the Legion! For Kil'Jaeden!"

	-- L.supreme_mode = "Supreme Mode"
end

local L = BigWigs:NewBossLocale("Emeriss", "esES") or BigWigs:NewBossLocale("Emeriss", "esMX")
if L then
	L.bossName = "Emeriss"

	-- L.engage_trigger = "Hope is a DISEASE of the soul! This land shall wither and die!"
end

local L = BigWigs:NewBossLocale("Lethon", "esES") or BigWigs:NewBossLocale("Lethon", "esMX")
if L then
	L.bossName = "Lethon"

	-- L.engage_trigger = "I can sense the SHADOW on your hearts. There can be no rest for the wicked!"
end

local L = BigWigs:NewBossLocale("Taerar", "esES") or BigWigs:NewBossLocale("Taerar", "esMX")
if L then
	L.bossName = "Taerar"

	-- L.engage_trigger = "Peace is but a fleeting dream! Let the NIGHTMARE reign!"
end

local L = BigWigs:NewBossLocale("Ysondre", "esES") or BigWigs:NewBossLocale("Ysondre", "esMX")
if L then
	L.bossName = "Ysondre"

	-- L.engage_trigger = "The strands of LIFE have been severed! The Dreamers must be avenged!"
end
