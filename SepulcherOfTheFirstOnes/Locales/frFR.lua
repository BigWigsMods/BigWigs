local L = BigWigs:NewBossLocale("Vigilant Guardian", "frFR")
if not L then return end
if L then
	--L.sentry = "Tank Add"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "frFR")
if L then
	L.tank_combo_desc = "Timer pour les cast de Mâche-faille/Pourfendre à 100 d'energie."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "frFR")
if L then
	L.sparknova = "Nova éclair" -- Hyperlight Sparknova
	L.relocation = "Bombe sur le tank" -- Glyph of Relocation
	L.relocation_count = "%s S%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	L.wormholes = "Tunnels spatiotemporels" -- Interdimensional Wormholes
	L.wormhole = "Tunnel spatiotemporel" -- Interdimensional Wormhole
	L.rings = "Anneaux S%d" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "frFR")
if L then
	L.staggering_barrage = "Barrage" -- Staggering Barrage
	L.obliteration_arc = "Arc" -- Obliteration Arc

	L.disintergration_halo = "Anneaux" -- Disintegration Halo
	L.rings_x = "Anneaux x%d"
	L.rings_enrage = "Anneaux (Enragé)"
	L.ring_count = "Anneau (%d/%d)"

	--L.custom_on_ring_timers = "Individual Halo Timers"
	--L.custom_on_ring_timers_desc = "Disintegration Halo triggers a set of rings, this will show bars for when each of the rings starts moving. Uses settings from Disintegration Halo."
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "frFR")
if L then
	L.necrotic_ritual = "Rituel"
	L.runecarvers_deathtouch = "Toucher de la mort"
	L.windswept_wings = "Rafale"
	L.wild_stampede = "Ruée"
	L.withering_seeds = "Graines"
	L.hand_of_destruction = "Main"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "frFR")
if L then
	L.protoform_cascade = "Frontal"
	L.cosmic_shift = "Poussée"
	--L.cosmic_shift_mythic = "Shift: %s"
	L.unstable_mote = "Granules"
	L.mote = "Granule"

	L.custom_on_nameplate_fixate = "Icône de barre d'unité fixée"
	L.custom_on_nameplate_fixate_desc = "Affiche une icône sur la barre de nom d'unité des Automas pourvoyeurs qui vous fixent.\n\nNécessite d'avoir activé les barres de noms des unités ennemies et un addon de barres de noms compatible (KuiNameplates, Plater)."

	--L.harmonic = "Push"
	--L.melodic = "Pull"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "frFR")
if L then
	L.custom_off_repeating_blasphemy = "Répéter Blasphème"
	L.custom_off_repeating_blasphemy_desc = "Répéter Blasphème affiche un message en /dire avec les icônes {rt1}, {rt3} pour trouver une marque permettant d'enlever le débuff."

	L.kingsmourne_hungers = "Deuilleroi"
	L.blasphemy = "Marques"
	L.befouled_barrier = "Barrière"
	L.wicked_star = "Etoile"
	L.domination_word_pain = "MD : Douleur"
	L.army_of_the_dead = "Armée"
	L.grim_reflections = "Adds qui fear"
	L.march_of_the_damned = "Murs"
	L.dire_blasphemy = "Marques"

	L.remnant_active = "Vestige actif"
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "frFR")
if L then
	--L.seismic_tremors = "Motes + Tremors"
	--L.earthbreaker_missiles = "Missiles"
	--L.crushing_prism = "Prisms"
	--L.prism = "Prism"
	L.ephemeral_fissure = "Fissure"

	-- L.bomb_dropped = "Bomb dropped"

	--L.custom_on_stop_timers = "Always show ability bars"
	--L.custom_on_stop_timers_desc = "Halondrus can delay its abilities. When this option is enabled, the bars for those abilities will stay on your screen."
end

L = BigWigs:NewBossLocale("Lords of Dread", "frFR")
if L then
	--L.unto_darkness = "AoE Phase"
	--L.cloud_of_carrion = "Carrion"
	--L.empowered_cloud_of_carrion = "Big Carrion" -- Empowered Cloud of Carrion
	--L.leeching_claws = "Frontal (M)"
	--L.infiltration_of_dread = "Among Us"
	--L.infiltration_removed = "Imposters found in %.1fs" -- "Imposters found in 1.1s" s = seconds
	--L.fearful_trepidation = "Fears"
	--L.slumber_cloud = "Clouds"
	--L.anguishing_strike = "Frontal (K)"

	--L.custom_on_repeating_biting_wound = "Repeating Biting Wound"
	--L.custom_on_repeating_biting_wound_desc = "Repeating Biting Wound say messages with icons {rt7} to make it more visible."
end

L = BigWigs:NewBossLocale("Rygelon", "frFR")
if L then
	--L.celestial_collapse = "Quasars"
	--L.manifest_cosmos = "Cores"
	--L.stellar_shroud = "Heal Absorb"
	--L.knock = "Knock" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "frFR")
if L then
	--L.rune_of_damnation_countdown = "Countdown"
	--L.rune_of_damnation_countdown_desc = "Countdown for the players who are affected by Rune of Damnation"
	--L.jump = "Jump In"

	--L.relentless_domination = "Domination"
	--L.chains_of_oppression = "Pull Chains"
	--L.unholy_attunement = "Pylons"
	--L.shattering_blast = "Tank Blast"
	--L.rune_of_compulsion = "Charms"
	--L.desolation = "Azeroth Soak"
	--L.chains_of_anguish = "Spread Chains"
	--L.chain = "Chain"
	--L.chain_target = "Chaining %s!"
	--L.chains_remaining = "%d/%d Chains Broken"
	--L.rune_of_domination = "Group Soaks"

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
