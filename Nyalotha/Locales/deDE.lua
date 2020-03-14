local L = BigWigs:NewBossLocale("Maut", "deDE")
if not L then return end
if L then
	L.stage2_over = "Phase 2 vorbei - %.1f Sek"
end

L = BigWigs:NewBossLocale("Shad'har the Insatiable", "deDE")
if L then
	L.custom_on_stop_timers = "Fähigkeitenleisten immer anzeigen"
	L.custom_on_stop_timers_desc = "Shad'har wählt die nächste Off-Colldown-Fähigkeit zufällig aus. Wenn diese Option ausgewählt ist, werden die Leisten für diese Fähigkeiten auf dem Bildschirm angezeigt bleiben."
end

L = BigWigs:NewBossLocale("Drest'agath", "deDE")
if L then
	L.adds_desc = "Warnungen und Nachrichten für Augen, Tentakel und Schlunde von Drest'agath."
	-- L.adds_icon = "achievement_nzothraid_drestagath"

	L.eye_killed = "Auge getötet!"
	L.tentacle_killed = "Tentakel getötet!"
	L.maw_killed = "Schlund getötet!"
end

L = BigWigs:NewBossLocale("Il'gynoth, Corruption Reborn", "deDE")
if L then
	L.custom_on_fixate_plates = "Fixieren-Symbol an gegnerischen Namensplaketten"
	L.custom_on_fixate_plates_desc = "Zeigt ein Symbol an der Namensplakette des Dich fixierenden Ziels an.\nBenötigt die Verwendung gegnerischer Namensplaketten. Diese Funktion wird derzeit nur von KuiNameplates unterstützt."
end

L = BigWigs:NewBossLocale("Vexiona", "deDE")
if L then
	L.killed = "%s getötet"
end

L = BigWigs:NewBossLocale("Ra-den the Despoiled", "deDE")
if L then
	L.essences = "Essenzen"
	L.essences_desc = "Ra-den beschwört regelmäßig Essenzen aus anderen Reichen. Wenn diese Essenzen Ra-den erreichen verstärken sie ihn entsprechend."
end

L = BigWigs:NewBossLocale("Carapace of N'Zoth", "deDE")
if L then
	L.player_membrane = "Spieler Membran" -- In stage 3
	L.boss_membrane = "Boss Membran" -- In stage 3
end

L = BigWigs:NewBossLocale("N'Zoth, the Corruptor", "deDE")
if L then
	L.realm_switch = "Reich gewechselt" -- When you leave the Mind of N'zoth

	L.custom_on_repeating_paranoia_say = "Wiederholte Paranoia Ansage"
	L.custom_on_repeating_paranoia_say_desc = "Spammt eine Nachricht im Sagen-Chat, damit anderen Dich während Paranoia meiden."
	-- L.custom_on_repeating_paranoia_say_icon = 315927

	L.gateway_yell = "Warnung: Herzkammer kompromittiert. Feindliche Kräfte dringen ein." -- Yelled by MOTHER to trigger mythic only stage
	L.gateway_open = "Tor geöffnet!"

	L.laser_left = "Laser (Links)"
	L.laser_right = "Laser (Rechts)"
end
