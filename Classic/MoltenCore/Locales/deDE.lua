local L = BigWigs:NewBossLocale("Lucifron", "deDE")
if not L then return end
if L then
	L.bossName = "Lucifron"

	-- L.mc_bar = "MC: %s"
end

L = BigWigs:NewBossLocale("Magmadar", "deDE")
if L then
	L.bossName = "Magmadar"
end

L = BigWigs:NewBossLocale("Gehennas", "deDE")
if L then
	L.bossName = "Gehennas"
end

L = BigWigs:NewBossLocale("Garr", "deDE")
if L then
	L.bossName = "Garr"
end

L = BigWigs:NewBossLocale("Baron Geddon", "deDE")
if L then
	L.bossName = "Baron Geddon"
end

L = BigWigs:NewBossLocale("Shazzrah", "deDE")
if L then
	L.bossName = "Shazzrah"
end

L = BigWigs:NewBossLocale("Sulfuron Harbinger", "deDE")
if L then
	L.bossName = "Sulfuronherold"
end

L = BigWigs:NewBossLocale("Golemagg the Incinerator", "deDE")
if L then
	L.bossName = "Golemagg der Verbrenner"
end

L = BigWigs:NewBossLocale("Majordomo Executus", "deDE")
if L then
	L.bossName = "Majordomus Exekutus"

	L.disabletrigger = "Haltet ein, Sterbliche"
	L.power_next = "Nächste Fähigkeit"
end

L = BigWigs:NewBossLocale("Ragnaros", "deDE")
if L then
	L.bossName = "Ragnaros"

	L.warmup_message = "RP gestartet, aktiv in ~73s"

	L.engage_trigger = "NUN ZU EUCH, INSEKTEN"
	L.submerge_trigger = "KOMMT HERBEI, MEINE DIENER"

	L.knockback_message = "Rückstoß!"
	L.knockback_bar = "Rückstoß"

	L.submerge = "Untertauchen"
	L.submerge_desc = "Warnt, wenn Ragnaros untertaucht."
	L.submerge_message = "Ragnaros untergetaucht für 90 sek!"
	L.submerge_bar = "Untertauchen"

	L.emerge = "Auftauchen"
	L.emerge_desc = "Warnt, wenn Ragnaros auftaucht."
	L.emerge_message = "Ragnaros aufgetaucht! Untertauchen in 3 min!"
	L.emerge_bar = "Auftauchen"
end

