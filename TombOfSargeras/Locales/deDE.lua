local L = BigWigs:NewBossLocale("Harjatan the Bludger", "deDE")
if not L then return end
if L then
	L.custom_on_fixate_plates = "Fixiert-Symbol auf Gegnerischen Namensplaketten"
	L.custom_on_fixate_plates_desc = "Zeigt ein Symbol auf der Namensplakette des Gegerns, der sich auf dich fixiert hat.\nErfordert die Verwendung von Gegnerischen Namensplaketten. Diese Funktion wird derzeit nur von KuiNameplates unterstützt."
end

L = BigWigs:NewBossLocale("Demonic Inquisition", "deDE")
if L then
	L.custom_on_fixate_plates = "Fixiert-Symbol auf Gegnerischen Namensplaketten"
	L.custom_on_fixate_plates_desc = "Zeigt ein Symbol auf der Namensplakette des Gegerns, der sich auf dich fixiert hat.\nErfordert die Verwendung von Gegnerischen Namensplaketten. Diese Funktion wird derzeit nur von KuiNameplates unterstützt."

	L.infobox_title_prisoners = "%d |4Gefangener:Gefangene;"

	L.custom_on_stop_timers = "Fähigkeitsleisten immer anzeigen"
	L.custom_on_stop_timers_desc = "Dämonische Inquisition beherrst Zauber, welche von Unterbrechungen und anderen Zauberwirkungen verzögert werden. Wenn diese Option aktiviert ist, bleiben die Leisten dieser Fähigkeiten auf deinem Bildschirm."
end

L = BigWigs:NewBossLocale("Mistress Sassz'ine", "deDE")
if L then
	L.inks_fed_count = "Tinte (%d/%d)"
	L.inks_fed = "Tinte gefüttert: %s" -- %s = List of players
end

L = BigWigs:NewBossLocale("The Desolate Host", "deDE")
if L then
	L.infobox_players = "Spieler"
	L.armor_remaining = "%s Verbleibend (%d)" -- Bonecage Armor Remaining (#)
	L.custom_on_mythic_armor = "Knochenkäfigrüstung auf Reanimierter Templern auf dem Schwierigkeitsgrad Mythisch ignorieren"
	--L.custom_on_mythic_armor_desc = "Leave this option enabled if you are offtanking Reanimated Templars to ignore warnings and counting the Bonecage Armor on the Ranimated Templars"
	L.custom_on_armor_plates = "Knochenkäfigrüstung-Symbol auf gegnerischen Namensplaketten"
	L.custom_on_armor_plates_desc = "Zeigt ein Symbol auf den Namensplaketten von Reanimierten Templern, welche Knochenkäfigrüstung haben.\nErfordert die Verwendung von Gegnerischen Namensplaketten. Diese Funktion wird derzeit nur von KuiNameplates unterstützt."
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
	L.absorb = "Absorption"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "Wirkt"
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)" -- s = seconds
	L.stacks = "Stapel"
end

L = BigWigs:NewBossLocale("Fallen Avatar", "deDE")
if L then
	L.touch_impact = "Einschlag Berührung" -- Touch of Sargeras Impact (short)

	L.custom_on_stop_timers = "Fähigkeitsleisten immer anzeigen"
	L.custom_on_stop_timers_desc = "Gefallener Avatar wählt seine nächste nicht-abklingende Fähigkeit zufällig aus. Wenn diese Option aktiviert ist, bleiben die Leisten dieser Fähigkeiten auf deinem Bildschirm."

	L.energy_leak = "Energieleck"
	L.energy_leak_desc = "Zeigt eine Warnung, wenn Energie auf den Boss in Phase 1 zuströmt."
	L.energy_leak_msg = "Energieleck! (%d)"

	L.warmup_trigger = "Diese Hülle diente einst" -- Diese Hülle diente einst als Gefäß der Macht von Sargeras. Aber es ist der Tempel selbst, um den es uns geht. Und mit seiner Hilfe werden wir Eure Welt zu Asche verbrennen!

	L.absorb = "Absorption"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "Wirkt"
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)" -- s = seconds
end

L = BigWigs:NewBossLocale("Kil'jaeden", "deDE")
if L then
	L.singularityImpact = "Singularität-Aufprall"
	L.obeliskExplosion = "Obelisk-Explosion"
	L.obeliskExplosion_desc = "Timer für die Explosion der Obelisken"

	L.darkness = "Dunkelheit" -- Shorter name for Darkness of a Thousand Souls (238999)
	L.reflectionErupting = "Reflexion: Eruptiv" -- Shorter name for Shadow Reflection: Erupting (236710)
	L.reflectionWailing = "Reflexion: Klagen" -- Shorter name for Shadow Reflection: Wailing (236378)
	L.reflectionHopeless = "Reflexion: Hoffnungslos" -- Shorter name for Shadow Reflection: Hopeless (237590)

	L.rupturingKnock = "Zurückstoßung von Zerreißende Singularität"
	L.rupturingKnock_desc = "Zeigt einen Timer für die Zurückstoßung."

	L.meteorImpact_desc = "Zeigt einen Timer für einschlagende Meteore."

	--L.shadowsoul = "Shadowsoul Health Tracker"
	--L.shadowsoul_desc = "Show the info box displaying the current health of the 5 Shadowsoul adds."

	--L.custom_on_track_illidan = "Automatically Track Humanoids"
	--L.custom_on_track_illidan_desc = "If you are a hunter or a feral druid, this option will automatically enable tracking of humanoids so you can track Illidan."

	--L.custom_on_zoom_in = "Automatically Zoom Minimap"
	--L.custom_on_zoom_in_desc = "This feature will set the minimap zoom to level 4 to make it easier to track Illidan, and then restore it to your previous level once the stage has ended."
end

L = BigWigs:NewBossLocale("Tomb of Sargeras Trash", "deDE")
if L then
	L.rune = "Orcische Rune"
	L.chaosbringer = "Höllenchaosbringer"
	L.rez = "Rez das Grabauge"
	L.erduval = "Erdu'val"
	L.varah = "Hippogryphenfürstin Varah"
	L.seacaller = "Seeruferin der Gezeitenschuppen"
	L.custodian = "Unterwasserverwalter"
	L.dresanoth = "Dresanoth"
	L.stalker = "Der Schreckenspirscher"
	L.darjah = "Kriegsfürst Darjah"
	L.sentry = "Wachposten"
	L.acolyte = "Geisterhafte Akolythin"
	L.ryul = "Ryul der Schwindende"
	L.countermeasure = "Defensive Gegenmaßnahmen"
end
