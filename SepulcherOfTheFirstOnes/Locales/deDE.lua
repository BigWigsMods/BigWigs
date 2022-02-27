local L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "deDE")
if not L then return end
if L then
	L.traps = "Fallen" -- Stasis Trap
	L.sparknova = "Funkennova" -- Hyperlight Sparknova
	L.relocation = "Tank Bombe" -- Glyph of Relocation
	L.wormholes = "Wumrlöcher" -- Interdimensional Wormholes
	L.wormhole = "Wurmloch" -- Interdimensional Wormhole
	L.rings = "Ringe P%d" -- Forerunner Rings // Added P1, P2, P3 etc to help identify what rings
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "deDE")
if L then
	L.staggering_barrage = "Bombardement" -- Staggering Barrage
	L.domination_core = "Add" -- Domination Core
	L.obliteration_arc = "Bogen" -- Obliteration Arc

	L.disintergration_halo = "Ringe" -- Disintegration Halo
	L.rings_x = "Ringe x%d"
	L.rings_enrage = "Ringe (Berserker)"
	L.ring_count = "Ring (%d/%d)"

	L.shield_removed = "%s entfernt nach %.1fs" -- "Shield removed after 1.1s" s = seconds
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "deDE")
if L then
	L.necrotic_ritual = "Ritual"
	L.runecarvers_deathtouch = "Todesberührung"
	L.windswept_wings = "Stürme"
	L.wild_stampede = "Stampede"
	L.withering_seeds = "Samen"
	L.hand_of_destruction = "Hand"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "deDE")
if L then
	L.protoform_cascade = "Frontal"
	L.cosmic_shift = "Rückstoß"
	L.unstable_mote = "Partikel"
	L.mote = "Partikel"

	L.custom_on_nameplate_fixate = "Fixieren-Symbol an Namensplaketten"
	L.custom_on_nameplate_fixate_desc = "Zeigt ein Symbol an der Namensplakette des Dich fixierenden Akquisitionsautomas an.\n\nBenötigt die Nutzung von gegnerischen Namensplaketten sowie ein unterstütztes Addon (KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "deDE")
if L then
	L.custom_off_repeating_blasphemy = "Blasphemie wiederholen"
	L.custom_off_repeating_blasphemy_desc = "Gibt wiederholt Blasphemie Chatnachrichten mit Symbolen {rt1}, {rt3} aus um das entgegengesetzte Mal zu finden."

	L.kingsmourne_hungers = "Königsgram"
	L.blasphemy = "Male"
	L.befouled_barrier = "Barriere"
	L.wicked_star = "Stern"
	L.domination_word_pain = "WdH:Schmerz"
	L.army_of_the_dead = "Armee"
	L.grim_reflections = "Furcht Adds"
	L.march_of_the_damned = "Wände"
	L.dire_blasphemy = "Male"
	L.beacon_of_hope = "Flamme"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "deDE")
if L then
	L.tank_combo_desc = "Timer für die Fähigkeiten Rissschlund/Verwunden bei 100 Energie."
end
