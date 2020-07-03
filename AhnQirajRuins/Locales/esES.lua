local L = BigWigs:NewBossLocale("Kurinnaxx", "esMX") or BigWigs:NewBossLocale("Kurinnaxx", "esMX")
if not L then return end
if L then
	L.bossName = "Kurinnaxx"
end

local L = BigWigs:NewBossLocale("General Rajaxx", "esMX") or BigWigs:NewBossLocale("General Rajaxx", "esMX")
if L then
	L.bossName = "General Rajaxx"

	-- L.wave = "Waves Warnings"
	-- L.wave_desc = "Warn for incoming waves"

	-- L.wave_trigger1a = "Kill first, ask questions later... Incoming!"
	-- L.wave_trigger1b = "Remember, Rajaxx, when I said I'd kill you last?"
	-- L.wave_trigger3 = "The time of our retribution is at hand! Let darkness reign in the hearts of our enemies!"
	-- L.wave_trigger4 = "No longer will we wait behind barred doors and walls of stone! No longer will our vengeance be denied! The dragons themselves will tremble before our wrath!"
	-- L.wave_trigger5 = "Fear is for the enemy! Fear and death!"
	-- L.wave_trigger6 = "Staghelm will whimper and beg for his life, just as his whelp of a son did! One thousand years of injustice will end this day!"
	-- L.wave_trigger7 = "Fandral! Your time has come! Go and hide in the Emerald Dream and pray we never find you!"
	-- L.wave_trigger8 = "Impudent fool! I will kill you myself!"

	-- L.wave_message = "Wave (%d/8)"
end

local L = BigWigs:NewBossLocale("Moam", "esMX") or BigWigs:NewBossLocale("Moam", "esMX")
if L then
	L.bossName = "Moam"
end

local L = BigWigs:NewBossLocale("Buru the Gorger", "esMX") or BigWigs:NewBossLocale("Buru the Gorger", "esMX")
if L then
	L.bossName = "Buru el Manducador"

	L.fixate = "Fijar"
	L.fixate_desc = "Se fija en un objetivo e ignora la amenaza de otros atacantes."
end

local L = BigWigs:NewBossLocale("Ayamiss the Hunter", "esES") or BigWigs:NewBossLocale("Ayamiss the Hunter", "esMX")
if L then
	L.bossName = "Ayamiss el Cazador"
end

local L = BigWigs:NewBossLocale("Ossirian the Unscarred", "esMX") or BigWigs:NewBossLocale("Ossirian the Unscarred", "esMX")
if L then
	L.bossName = "Osirio el Sinmarcas"

	L.debuff = "Debilidad"
	--L.debuff_desc = "Warn for various weakness types."
end

local L = BigWigs:NewBossLocale("Ruins of Ahn'Qiraj Trash", "esMX") or BigWigs:NewBossLocale("Ruins of Ahn'Qiraj Trash", "esMX")
if L then
	L.guardian = "Guardián Anubisath"
end
