local L = BigWigs:NewBossLocale("Battle of Dazar'alor Trash", "deDE")
if not L then return end
if L then
	L.prelate = "Prälat Akk'al"
	L.flamespeaker = "Flammensprecher der Rastari"
	L.hulk = "Auferstandener Koloss"
	L.enforcer = "Ewiger Vollstrecker"
	L.punisher = "Bestrafer der Rastari"
	L.vessel = "Gefäß für Bwonsamdi"
	L.victim = "%s hat DICH mit %s gestochen!"
	L.witness = "%s hat %s mit %s gestochen!"
end

L = BigWigs:NewBossLocale("Champion of the Light Horde", "deDE")
if L then
	L.disorient_desc = "Leiste für den Zauber |cff71d5ff[Blendender Glaube]|r.\nDas ist wahrscheinlich die Leiste, auf welcher du den Countdown möchtest." -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Champion of the Light Alliance", "deDE")
if L then
	L.disorient_desc = "Leiste für den Zauber |cff71d5ff[Blendender Glaube]|r.\nDas ist wahrscheinlich die Leiste, auf welcher du den Countdown möchtest." -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Jadefire Masters Horde", "deDE")
if L then
	L.custom_on_fixate_plates = "Fixieren-Symbol über gegnerischen Namensplaketten"
	L.custom_on_fixate_plates_desc = "Zeigt ein Symbol an der Namensplakette des Dich fixierenden Ziels an.\nBenötigt die Verwendung gegnerischer Namensplaketten. Diese Funktion wird derzeit nur von KuiNameplates unterstützt."

	L.absorb = "Absorbtion"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "Zauber"
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)"

	L.interrupted_after = "%s wurde unterbrochen von %s (%.1f Sekunde/n verbleibend)"
end

L = BigWigs:NewBossLocale("Jadefire Masters Alliance", "deDE")
if L then
	L.custom_on_fixate_plates = "Fixieren-Symbol über gegnerischen Namensplaketten"
	L.custom_on_fixate_plates_desc = "Zeigt ein Symbol an der Namensplakette des Dich fixierenden Ziels an.\nBenötigt die Verwendung gegnerischer Namensplaketten. Diese Funktion wird derzeit nur von KuiNameplates unterstützt."

	L.absorb = "Absorbtion"
	L.absorb_text = "%s (|cff%s%.0f%%|r)"
	L.cast = "Zauber"
	L.cast_text = "%.1fs (|cff%s%.0f%%|r)"

	L.interrupted_after = "%s wurde unterbrochen von %s (%.1f Sekunde/n verbleibend)"
end

L = BigWigs:NewBossLocale("Opulence", "deDE")
if L then
	L.room = "Raum (%d/8)"
	L.no_jewel = "Kein Juwel:"

	L.custom_on_fade_out_bars = "Blende Leisten für Phase 1 aus."
	L.custom_on_fade_out_bars_desc = "Blende Leisten aus, welche zu dem Konstrukt gehören, das während Phase 1 nicht in deinem Gang ist."

	L.custom_on_hand_timers = "Die Hand von In'zashi"
	L.custom_on_hand_timers_desc = "Zeige Warnungen und Leisten für Fähigkeiten von Die Hand von In'zashi."
	L.hand_cast = "Hand: %s"

	L.custom_on_bulwark_timers = "Yalats Bollwerk"
	L.custom_on_bulwark_timers_desc = "Zeige Warnungen und Leisten für Fähigkeiten von Yalats Bollwerk."
	L.bulwark_cast = "Bollwerk: %s"
end

L = BigWigs:NewBossLocale("Conclave of the Chosen", "deDE")
if L then
	L.custom_on_fixate_plates = "Mal der Beute Symbol an Namensplaketten fixierender Gegner"
	L.custom_on_fixate_plates_desc = "Zeigt ein Symbol an der Namensplakette des Dich fixierenden Ziels an.\nBenötigt die Verwendung gegnerischer Namensplaketten. Diese Funktion wird derzeit nur von KuiNameplates unterstützt."
	L.killed = "%s getötet!"
	L.count_of = "%s (%d/%d)"
end

L = BigWigs:NewBossLocale("King Rastakhan", "deDE")
if L then
	L.leap_cancelled = "Sprung abgebrochen"
end

L = BigWigs:NewBossLocale("High Tinker Mekkatorque", "deDE")
if L then
	L.gigavolt_alt_text = "Bombe"

	L.custom_off_sparkbot_marker = "Funkenbot Marker"
	L.custom_off_sparkbot_marker_desc = "Markiere Funkenbots mit {rt4}{rt5}{rt6}{rt7}{rt8}."

	L.custom_on_repeating_shrunk_say = "Wiederholende Schrumpfen-Ansage" -- Shrunk = 284168
	L.custom_on_repeating_shrunk_say_desc = "Spamme Schrumpfen während |cff71d5ff[Geschrumpft]|r. Eventuell hören sie dann auf dich zu zertreten."

	L.custom_off_repeating_tampering_say = "Wiederholende Manipulation!-Ansage" -- Tampering = 286105
	L.custom_off_repeating_tampering_say_desc = "Spamme deinen Namen während du einen Roboter kontrollierst."
end

L = BigWigs:NewBossLocale("Stormwall Blockade", "deDE")
if L then
	L.killed = "%s getötet!"

	L.custom_on_fade_out_bars = "Blende Leisten für Phase 1 aus"
	L.custom_on_fade_out_bars_desc = "Blende Leisten aus, welche zu dem Boss gehören, der während Phase 1 nicht auf deinem Boot aktiv ist."
end

L = BigWigs:NewBossLocale("Lady Jaina Proudmoore", "deDE")
if L then
	L.starbord_ship_emote = "Ein Korsar von Kul Tiras nähert sich von Rechts!"
	L.port_side_ship_emote = "Ein Korsar von Kul Tiras nähert sich von Links!"

	L.starbord_txt = "Rechts" -- starboard
	L.port_side_txt = "Links" -- port

	L.custom_on_stop_timers = "Zeige Fähigkeitenleisten immer"
	L.custom_on_stop_timers_desc = "Jaina wählt die nächste Off-Colldown-Fähigkeit zufällig aus. Wenn diese Option ausgewählt ist, werden die Leisten für diese Fähigkeiten auf dem Bildschirm angezeigt bleiben."

	L.frozenblood_player = "%s (%d Spieler)"

	L.intermission_stage2 = "Phase 2 - %.1f Sekunden"
end
