local L = BigWigs:NewBossLocale("Vigilant Guardian", "deDE")
if not L then return end
if L then
	L.sentry = "Tank Add"
	L.materium = "Kleine Adds"
	L.shield = "Schild" -- Global locale canidate?
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "deDE")
if L then
	L.tank_combo_desc = "Timer für die Fähigkeiten Rissschlund/Verwunden bei 100 Energie."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "deDE")
if L then
	L.traps = "Fallen" -- Stasis Trap
	L.sparknova = "Funkennova" -- Hyperlight Sparknova
	L.relocation = "Tank Bombe" -- Glyph of Relocation
	L.relocation_count = "%s P%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	L.wormholes = "Wurmlöcher" -- Interdimensional Wormholes
	L.wormhole = "Wurmloch" -- Interdimensional Wormhole
	L.rings = "Ringe P%d" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
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

	L.custom_on_ring_timers = "Individuelle Kranz Timer"
	L.custom_on_ring_timers_desc = "Desintegrationskranz löst Ringe aus. Dies zeigt Leisten für den Bewegungsbeginn jedes Rings. Nutzt die Einstellungen von Desintegrationskranz."

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
	L.protoform_cascade = "Kreis"
	L.cosmic_shift = "Rückstoß"
	L.cosmic_shift_mythic = "Verschiebung: %s"
	L.unstable_mote = "Partikel"
	L.mote = "Partikel"

	L.custom_on_nameplate_fixate = "Fixieren-Symbol an Namensplaketten"
	L.custom_on_nameplate_fixate_desc = "Zeigt ein Symbol an der Namensplakette des Dich fixierenden Akquisitionsautomas an.\n\nBenötigt die Nutzung von gegnerischen Namensplaketten sowie ein unterstütztes Addon (KuiNameplates, Plater)."

	L.harmonic = "Drücken"
	L.melodic = "Ziehen"
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "deDE")
if L then
	L.seismic_tremors = "Partikel + Beben" -- Seismic Tremors
	L.earthbreaker_missiles = "Geschosse" -- Earthbreaker Missiles
	L.crushing_prism = "Prismen" -- Crushing Prism
	L.prism = "Prisma"

	L.bomb_dropped = "Bombe fallen gelassen"

	L.custom_on_stop_timers = "Fähigkeiten Leisten immer anzeigen"
	L.custom_on_stop_timers_desc = "Halondrus kann Fähigkeiten verzögern. Wenn diese Option aktiviert ist, bleiben die Leisten für diese Fähigkeiten bestehen."
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

	L.remnant_active = "Überrest aktiv"
end

L = BigWigs:NewBossLocale("Lords of Dread", "deDE")
if L then
	L.unto_darkness = "AoE Phase"-- Unto Darkness
	L.cloud_of_carrion = "Fäulnis" -- Cloud of Carrion
	L.empowered_cloud_of_carrion = "Große Fäulnis" -- Empowered Cloud of Carrion
	L.manifest_shadows = "Adds" -- Manifest Shadows
	L.leeching_claws = "Frontal (M)" -- Leeching Claws
	L.infiltration_of_dread = "Unter uns" -- Infiltration of Dread
	L.infiltration_removed = "Verräter gefunden in %.1fs" -- "Imposters found in 1.1s" s = seconds
	L.fearful_trepidation = "Furcht" -- Fearful Trepidation
	L.slumber_cloud = "Wolken" -- Slumber Cloud
	L.anguishing_strike = "Frontal (K)" -- Anguishing Strike

	L.custom_on_repeating_biting_wound = "Beißende Wunden wiederholen"
	L.custom_on_repeating_biting_wound_desc = "Gibt wiederholt Beißende Wunden Chatnachrichten mit Symbol {rt7} aus, um es sichtbarer zu machen."
end

L = BigWigs:NewBossLocale("Rygelon", "deDE")
if L then
	L.celestial_collapse = "Quasare" -- Celestial Collapse
	L.manifest_cosmos = "Kerne" -- Manifest Cosmos
	L.stellar_shroud = "Heilung absorbiert" -- Stellar Shroud
	L.knock = "Rückstoß" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "deDE")
if L then
	L.rune_of_damnation_countdown = "Countdown"
	L.rune_of_damnation_countdown_desc = "Countdown für Spieler welche von Rune der Verdammnis betroffen sind."
	L.jump = "Reinspringen"

	--L.relentless_domination = "Domination"
	L.chains_of_oppression = "Ketten zerreißen"
	L.unholy_attunement = "Pylonen"
	--L.shattering_blast = "Tank Blast"
	L.rune_of_compulsion = "Übernommene"
	--L.desolation = "Azeroth Soak"
	L.chains_of_anguish = "Ketten auseinander"
	L.chain = "Kette"
	L.chain_target = "Kette auf %s!"
	L.chains_remaining = "%d/%d Ketten gebrochen"
	L.rune_of_domination = "Gruppensoak"

	--L.final = "Final %s" -- Final Unholy Attunement/Domination (last spell of a stage)

	-- L.azeroth_health = "Azeroth Health"
	-- L.azeroth_health_desc = "Azeroth Health Warnings"

	-- L.azeroth_new_health_plus = "Azeroth Health: +%.1f%% (%d)"
	-- L.azeroth_new_health_minus = "Azeroth Health: -%.1f%%  (%d)"

	-- L.mythic_blood_soak_stage_1 = "Stage 1 Blood Soak timings"
	-- L.mythic_blood_soak_stage_2 = "Stage 2 Blood Soak timings"
	-- L.mythic_blood_soak_stage_3 = "Stage 3 Blood Soak timings"
	-- L.mythic_blood_soak_stage_1_desc = "Show a bar for timings when healing azeroth is at a good time, used by Echo on their first kill"
	-- L.mythic_blood_soak_bar = "Heal Azeroth"

	-- L.floors_open = "Floors Open"
	-- L.floors_open_desc = "Time until the floors opens up and you can fall into opened holes."

	-- L.mythic_dispel_stage_4 = "Dispel Timers"
	-- L.mythic_dispel_stage_4_desc = "Timers for when to do dispels in the last stage, used by Echo on their first kill"
	-- L.mythic_dispel_bar = "Dispels"
end
