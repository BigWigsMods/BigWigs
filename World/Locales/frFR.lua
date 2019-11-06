local L = BigWigs:NewBossLocale("Azuregos", "frFR")
if not L then return end
if L then
	L.teleport = "Alerte T\195\169l\195\169portation"
	L.teleport_desc = "Pr\195\169viens quand Azuregos t\195\169l\195\169porte quelqu'un."
	L.teleport_trigger = "Venez m'affronter, mes petits\194\160"
	L.teleport_message = "T\195\169l\195\169portation !"
end

L = BigWigs:NewBossLocale("Lord Kazzak", "frFR")
if L then
	L.supreme = "Alerte Supr\195\170me"
	L.supreme_desc = "Pr\195\169viens r\195\169guli\195\168rement de l'approche du mode Supr\195\170me."
	L.engage_trigger = "Pour la L\195\169gion ! Pour Kil'Jaeden !"
	L.engage_message = "Seigneur Kazzak engag\195\169 - 3 minutes avant Supr\195\170me !"
	L.supreme1min = "Mode Supr\195\170me dans 1 minute !"
	L.supreme30sec = "Mode Supr\195\170me dans 30 secondes !"
	L.supreme10sec = "Mode Supr\195\170me dans 10 secondes !"
	L.bartext = "Mode Supr\195\170me"
end
