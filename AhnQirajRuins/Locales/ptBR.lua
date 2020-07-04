local L = BigWigs:NewBossLocale("Kurinnaxx", "ptBR")
if not L then return end
if L then
	L.bossName = "Korinnaxx"
end

local L = BigWigs:NewBossLocale("General Rajaxx", "ptBR")
if L then
	L.bossName = "General Rajaxx"

	L.wave = "Avisos de Onda"
	L.wave_desc = "Anuncia mensagens de aviso da aproximação das ondas."

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

local L = BigWigs:NewBossLocale("Moam", "ptBR")
if L then
	L.bossName = "Moam"
end

local L = BigWigs:NewBossLocale("Buru the Gorger", "ptBR")
if L then
	L.bossName = "Buru, o Banqueteador"

	L.fixate = "Fixar"
	L.fixate_desc = "Fixa-se em um alvo, ignorando a ameaça de outros agressores."
end

local L = BigWigs:NewBossLocale("Ayamiss the Hunter", "ptBR")
if L then
	L.bossName = "Ayamiss, o Caçador"
end

local L = BigWigs:NewBossLocale("Ossirian the Unscarred", "ptBR")
if L then
	L.bossName = "Ossirian, o Intocado"

	L.debuff = "Fraqueza"
	-- L.debuff_desc = "Warn for various weakness types."
end

local L = BigWigs:NewBossLocale("Ruins of Ahn'Qiraj Trash", "ptBR")
if L then
	L.guardian = "Guardião Anubisath"
end
