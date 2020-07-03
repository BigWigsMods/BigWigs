local L = BigWigs:NewBossLocale("Azuregos", "frFR")
if not L then return end
if L then
	L.bossName = "Azuregos"

	L.teleport = "Alerte T\195\169l\195\169portation"
	L.teleport_desc = "Pr\195\169viens quand Azuregos t\195\169l\195\169porte quelqu'un."
	L.teleport_trigger = "Venez m'affronter, mes petits\194\160"
	L.teleport_message = "T\195\169l\195\169portation !"
end

L = BigWigs:NewBossLocale("Lord Kazzak", "frFR")
if L then
	L.bossName = "Seigneur Kazzak"

	L.engage_trigger = "Pour la L\195\169gion ! Pour Kil'Jaeden !"

	L.supreme_mode = "Mode Supr\195\170me"
end

local L = BigWigs:NewBossLocale("Emeriss", "frFR")
if L then
	L.bossName = "Emeriss"

	-- L.engage_trigger = "Hope is a DISEASE of the soul! This land shall wither and die!"
end

local L = BigWigs:NewBossLocale("Lethon", "frFR")
if L then
	L.bossName = "Léthon"

	-- L.engage_trigger = "I can sense the SHADOW on your hearts. There can be no rest for the wicked!"
end

local L = BigWigs:NewBossLocale("Taerar", "frFR")
if L then
	L.bossName = "Taerar"

	-- L.engage_trigger = "Peace is but a fleeting dream! Let the NIGHTMARE reign!"
end

local L = BigWigs:NewBossLocale("Ysondre", "frFR")
if L then
	L.bossName = "Ysondre"

	-- L.engage_trigger = "The strands of LIFE have been severed! The Dreamers must be avenged!"
end
