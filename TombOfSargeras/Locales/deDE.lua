local L = BigWigs:NewBossLocale("Harjatan the Bludger", "deDE")
if not L then return end
if L then
	L.custom_on_fixate_plates = "Fixiert-Symbol auf Gegnerischen Namensplaketten"
	L.custom_on_fixate_plates_desc = "Zeigt ein Symbol auf der Namensplakette des Gegerns, der sich auf dich fixiert hat.\nErfordert die Verwendung von Gegnerischen Namensplaketten. Diese Funktion wird derzeit nur von KuiNameplates unterstützt."
end

L = BigWigs:NewBossLocale("Demonic Inquisition", "deDE")
if L then
	L.custom_on_stop_timers = "Fähigkeitsleisten immer anzeigen"
	L.custom_on_stop_timers_desc = "Dämonische Inquisition beherrst Zauber, welche von Unterbrechungen und anderen Zauberwirkungen verzögert werden. Wenn diese Option aktiviert ist, bleiben die Leisten dieser Fähigkeiten auf deinem Bildschirm."
end

L = BigWigs:NewBossLocale("The Desolate Host", "deDE")
if L then
	L.infobox_players = "Spieler"
	L.armor_remaining = "%s Verbleibend (%d)" -- Bonecage Armor Remaining (#)
	L.tormentingCriesSay = "Schreie" -- Tormenting Cries (short say)
end

L = BigWigs:NewBossLocale("Maiden of Vigilance", "deDE")
if L then
	L.infusionChanged = "Infusion VERÄNDERT: %s"
	L.sameInfusion = "Gleiche Infusion: %s"
	L.fel = "Teufel"
	L.light = "Licht"
	L.felHammer = "Teufelshammer" -- Better name for "Hammer of Obliteration"
	L.lightHammer = "Lichthammer" -- Better name for "Hammer of Creation"
end

L = BigWigs:NewBossLocale("Fallen Avatar", "deDE")
if L then
	L.touch_impact = "Einschlag Berührung" -- Touch of Sargeras Impact (short)

	L.custom_on_stop_timers = "Fähigkeitsleisten immer anzeigen"
	L.custom_on_stop_timers_desc = "Gefallener Avatar wählt seine nächste nicht-abklingende Fähigkeit zufällig aus. Wenn diese Option aktiviert ist, bleiben die Leisten dieser Fähigkeiten auf deinem Bildschirm."

	--L.energy_leak = "Energy Leak"
	--L.energy_leak_desc = "Display a warning when energy has leaked onto the boss in phase 1."
	--L.energy_leak_msg = "Energy Leak! (%d)"
end

L = BigWigs:NewBossLocale("Kil'jaeden", "deDE")
if L then
	L.singularityImpact = "Singularität-Aufprall"
	L.obeliskExplosion = "Obelisk-Explosion"

	L.darkness = "Dunkelheit" -- Shorter name for Darkness of a Thousand Souls (238999)
	L.reflectionErupting = "Reflexion: Eruptiv" -- Shorter name for Shadow Reflection: Erupting (236710)
	L.reflectionWailing = "Reflexion: Klagen" -- Shorter name for Shadow Reflection: Wailing (236378)
	L.reflectionHopeless = "Reflexion: Hoffnungslos" -- Shorter name for Shadow Reflection: Hopeless (237590)
end

L = BigWigs:NewBossLocale("Tomb of Sargeras Trash", "deDE")
if L then
	L.chaosbringer = "Höllenchaosbringer"
	L.rez = "Rez das Grabauge"
	L.seacaller = "Seeruferin der Gezeitenschuppen"
	L.custodian = "Unterwasserverwalter"
	L.dresanoth = "Dresanoth",
	L.sentry = "Wachposten"
end
