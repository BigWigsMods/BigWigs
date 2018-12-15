local L = BigWigs:NewBossLocale("MOTHER", "deDE")
if not L then return end
if L then
	L.sideLaser = "(Seite) Strahlen" -- short for: (location) Uldir Defensive Beam
	L.upLaser = "(Decke) Strahlen"
	L.mythic_beams = "Strahlen"
end

L = BigWigs:NewBossLocale("Zek'voz, Herald of N'zoth", "deDE")
if L then
	L.surging_darkness_eruption = "Eruption (%d)"
	L.mythic_adds = "Mythische Adds"
	L.mythic_adds_desc = "Zeigt Timer für das Erscheinen der mythischen Adds (sowohl Silithidkrieger als auch Nerubische Leerenweber erscheinen gleichzeitig)."
end

L = BigWigs:NewBossLocale("Zul", "deDE")
if L then
	L.crawg_msg = "Kroggs" -- Short for 'Bloodthirsty Crawg'
	L.crawg_desc = "Warnungen und Timer für das Erscheinen der Blutrünstigen Kroggs."

	L.bloodhexer_msg = "Bluthexerin" -- Short for 'Nazmani Bloodhexer'
	L.bloodhexer_desc = "Warnungen und Timer für das Erscheinen der Bluthexerin der Nazmani."

	L.crusher_msg = "Zermalmerin" -- Short for 'Nazmani Crusher'
	L.crusher_desc = "Warnungen und Timer für das Erscheinen der Zermalmerin der Nazmani."

	L.custom_off_decaying_flesh_marker = "Verwesendes Fleisch markieren"
	L.custom_off_decaying_flesh_marker_desc = "Markiert die von Verwesendes Fleisch betroffenen Gegner mit {rt8}, benötigt Assistent oder Schlachtzugsleiter."
end

L = BigWigs:NewBossLocale("Mythrax the Unraveler", "deDE")
if L then
	L.destroyer_cast = "%s (Zerstörer der N'raqi)" -- npc id: 139381
	L.xalzaix_returned = "Xalzaix erwacht!" -- npc id: 138324
	L.add_blast = "Add Schlag"
	L.boss_blast = "Boss Schlag"
end

L = BigWigs:NewBossLocale("G'huun", "deDE")
if L then
	L.orbs_deposited = "Kugel (%d/3) platziert - %.1f Sek"
	L.orb_spawning = "Kugel erscheint"
	L.orb_spawning_side = "Kugel erscheint (%s)"
	L.left = "Links"
	L.right = "Rechts"

	L.custom_on_fixate_plates = "Symbol an Namensplaketten fixierender Gegner"
	L.custom_on_fixate_plates_desc = "Zeigt ein Symbol an der Namensplakette des Dich fixierenden Ziels an.\nBenötigt die Verwendung gegnerischer Namensplaketten. Diese Funktion wird derzeit nur von KuiNameplates unterstützt."
end

L = BigWigs:NewBossLocale("Uldir Trash", "deDE")
if L then
	L.watcher = "Verderbter Hüter"
	L.ascendant = "Aszendentin der Nazmani"
	L.dominator = "Dominatorin der Nazmani"
end
