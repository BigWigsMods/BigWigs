local L = BigWigs:NewBossLocale("The Prophet Skeram", "deDE")
if not L then return end
if L then
	L.bossName = "Der Prophet Skeram"
end

local L = BigWigs:NewBossLocale("Silithid Royalty", "deDE")
if L then
	L.bossName = "Adel der Silithiden"
end

local L = BigWigs:NewBossLocale("Battleguard Sartura", "deDE")
if L then
	L.bossName = "Schlachtwache Sartura"
end

local L = BigWigs:NewBossLocale("Fankriss the Unyielding", "deDE")
if L then
	L.bossName = "Fankriss der Unnachgiebige"
end

L = BigWigs:NewBossLocale("Viscidus", "deDE")
if L then
	L.bossName = "Viscidus"

	L.freeze = "Frost-Stati"
	L.freeze_desc = "Warnungen für die verschiedenen Frost-Stati."

	L.freeze_trigger1 = "wird langsamer!"
	L.freeze_trigger2 = "friert ein!"
	L.freeze_trigger3 = "ist tiefgefroren!"
	L.freeze_trigger4 = "geht die Puste aus!" -- CHECK
	L.freeze_trigger5 = "ist kurz davor, zu zerspringen!"

	L.freeze_warn1 = "Erste Frostphase!"
	L.freeze_warn2 = "Zweite Frostphase!"
	L.freeze_warn3 = "Viscidus ist eingefroren!"
	L.freeze_warn4 = "Bricht zusammen - macht weiter!"
	L.freeze_warn5 = "Bricht zusammen - fast geschafft!"
	L.freeze_warn_melee = "%d Nahkampfattacken - %d weitere nötig"
	L.freeze_warn_frost = "%d Frostattacken - %d weitere nötig"
end

local L = BigWigs:NewBossLocale("Princess Huhuran", "deDE")
if L then
	L.bossName = "Prinzessin Huhuran"
end

local L = BigWigs:NewBossLocale("The Twin Emperors", "deDE")
if L then
	L.bossName = "Zwillingsimperatoren"
end

L = BigWigs:NewBossLocale("Ouro", "deDE")
if L then
	L.bossName = "Ouro"

	L.engage_message = "Ouro attackiert! Mögliches Untertauchen in 90 Sek!"

	L.emerge = "Auftauchen"
	L.emergewarn = "15 Sek bis möglichem Untertauchen!"
	L.emergewarn2 = "15 Sek bis Untertauchen von Ouro!"
	L.emergebartext = "Ouro taucht unter"

	L.submerge = "Untertauchen"
	L.possible_submerge_bar = "Mögliches Untertauchen"

	L.scarab = "Verschwinden der Skarabäen"
	L.scarab_desc = "Vor Verschwinden der Skarabäen warnen."
	L.scarabdespawn = "Skarabäen verschwinden in 10 Sekunden"
	L.scarabbar = "Skarabäen verschwinden"
end

L = BigWigs:NewBossLocale("C'Thun", "deDE")
if L then
	L.bossName = "C'Thun"

	L.tentacle = "Tentakel"
	L.tentacle_desc = "Warnungen für Tentakel"

	L.giant = "Riesige Augen"
	L.giant_desc = "Warnungen für Riesige Augen"

	L.weakened = "Geschwächt"
	L.weakened_desc = "Warnungen für geschwächten Status"

	L.weakenedtrigger = "%s ist geschwächt!"

	L.weakened_msg = "C'Thun ist für 45 Sek geschwächt"
	L.invulnerable2 = "Party endet in 5 Sekunden"
	L.invulnerable1 = "Party ist vorbei - C'Thun unverwundbar"

	L.giant3 = "Riesiges Auge - 10 Sekc"
	L.giant2 = "Riesiges Auge - 5 Sek"
	L.giant1 = "Riesiges Auge - Tötet es!"

	L.startwarn = "C'Thun attackiert! - 45 Sek bis Dunkles Starren und Augen"

	L.tentacleParty = "Tentakelparty!"
	L.barWeakened = "C'Thun ist geschwächt!"
	L.barGiant = "Riesiges Auge!"

	L.groupwarning = "Dunkles Starren auf Gruppe %s (%s)"
	L.phase2starting = "Das Auge ist tot! Der Körper ist dran!"
end

L = BigWigs:NewBossLocale("Ahn'Qiraj Trash", "deDE")
if L then
	L.anubisath = "Anubisath"
	L.sentinel = "Wächter des Anubisath"
	L.defender = "Verteidiger des Anubisath"
	L.crawler = "Schwarmkriecher der Vekniss"
end
