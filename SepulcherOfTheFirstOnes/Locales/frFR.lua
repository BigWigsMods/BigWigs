local L = BigWigs:NewBossLocale("Vigilant Guardian", "frFR")
if not L then return end
if L then
	L.sentry = "Tank ennemi"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "frFR")
if L then
	L.custom_on_stop_timers = "Toujours afficher les bars de technique"
	L.custom_on_stop_timers_desc = "Skolex peut retarder l'utilisation d'une technique. Lorsque cette option est active, les bars de techinique resteront toujours visible sur l'écran."

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

	L.custom_on_ring_timers = "Chronomètre individual du Halo"
	L.custom_on_ring_timers_desc = "Halo de Désintégration déclenche une suite d'anneaux, ce option affichera une bar pour chaque anneau dès qu'il commencera à bouger. Utilise les préréences du Halo de Désintégration."
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "frFR")
if L then
	L.necrotic_ritual = "Rituel"
	L.runecarvers_deathtouch = "Toucher de la mort"
	L.windswept_wings = "Rafale"
	L.wild_stampede = "Ruée"
	L.withering_seeds = "Graines"
	L.hand_of_destruction = "Main"
	L.nighthunter_marks_additional_desc = "|cFFFF0000Marque de priorité pour les melées sur la première.|r"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "frFR")
if L then
	L.protoform_cascade = "Frontal"
	L.cosmic_shift = "Poussée"
	L.cosmic_shift_mythic = "Echange: %s"
	L.unstable_mote = "Granules"
	L.mote = "Granule"

	L.custom_on_nameplate_fixate = "Icône de barre d'unité fixée"
	L.custom_on_nameplate_fixate_desc = "Affiche une icône sur la barre de nom d'unité des Automas pourvoyeurs qui vous fixent.\n\nNécessite d'avoir activé les barres de noms des unités ennemies et un addon de barres de noms compatible (KuiNameplates, Plater)."

	L.harmonic = "Ecarter"
	L.melodic = "Rapprocher"
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
	L.seismic_tremors = "Exposition + Détonation"
	L.earthbreaker_missiles = "Projectiles"
	L.crushing_prism = "Primes"
	L.prism = "Prisme"
	L.ephemeral_fissure = "Fissure"

	L.bomb_dropped = "Bombe lachée"

	L.custom_on_stop_timers = "Toujours afficher les bars de technique"
	L.custom_on_stop_timers_desc = "Halondrus peut retarder ces techniques. Lorsque cette option est active, les bards de ces techniques sont toujours visible à l'écran."
end

L = BigWigs:NewBossLocale("Lords of Dread", "frFR")
if L then
	L.unto_darkness = "Phase AoE"
	L.cloud_of_carrion = "Nuée"
	L.empowered_cloud_of_carrion = "Nuée ++" -- Empowered Cloud of Carrion
	L.leeching_claws = "Devant le boss (M)"
	L.infiltration_of_dread = "Ombre a trouvé"
	L.infiltration_removed = "Ombre trouvé en %.1fs" -- "Imposters found in 1.1s" s = seconds
	L.fearful_trepidation = "Peurs"
	L.slumber_cloud = "Nuages"
	L.anguishing_strike = "Devant le boss (K)"

	L.custom_on_repeating_biting_wound = "Morsure Béante"
	L.custom_on_repeating_biting_wound_desc = "Morsure Béante indique un message avec une icone {rt7} pour la rendre plus visible."
end

L = BigWigs:NewBossLocale("Rygelon", "frFR")
if L then
	L.celestial_collapse = "Quasars"
	L.manifest_cosmos = "Noyaux"
	L.stellar_shroud = "Absorption des soins"
	L.knock = "Repousse" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "frFR")
if L then
	L.rune_of_damnation_countdown = "Compte à rebours"
	L.rune_of_damnation_countdown_desc = "Compte à rebours pour les joueurs qui sont affecté par Rune de Damnation"
	L.jump = "Plonger"

	L.relentless_domination = "Domination"
	L.chains_of_oppression = "Tirer les chaînes"
	L.unholy_attunement = "Pylônes"
	L.shattering_blast = "Exposion sur tank"
	L.rune_of_compulsion = "Contrainte"
	--L.desolation = "Azeroth Soak"
	L.chains_of_anguish = "Chaînes - Ecartez-vous"
	L.chain = "Chaîne"
	L.chain_target = "Chaîne de %s!"
	L.chains_remaining = "%d/%d Chaînes cassées"
	L.rune_of_domination = "Absorption de groupe"

	L.final = "Dernier %s avant changement de phase" -- Final Unholy Attunement/Domination (last spell of a stage)

	 L.azeroth_health = "Soin d'Azeroth"
	 L.azeroth_health_desc = "Avertissement de Soin d'Azeroth"

	L.azeroth_new_health_plus = "Soin d'Azeroth: +%.1f%% (%d)"
	L.azeroth_new_health_minus = "Soin d'Azeroth: -%.1f%%  (%d)"

	L.mythic_blood_soak_stage_1 = "Etape 1 Sychronizer l'absorption de sang"
	L.mythic_blood_soak_stage_2 = "Etape 2 Sychronizer l'absorption de sang"
	L.mythic_blood_soak_stage_3 = "Etape 3 Sychronizer l'absorption de sang"
	L.mythic_blood_soak_stage_1_desc = "Affiche une bar pour se synchronizer avec le Soin d'Azeroth, utilisé par Echo lors de leur first kill"
	L.mythic_blood_soak_bar = "Soin d'Azeroth"

	L.floors_open = "Etages ouvert"
	L.floors_open_desc = "Chronomètre jusqu'à l'ouverture des étages et quand vous pourrez tomber dans les trous."

	L.mythic_dispel_stage_4 = "Chronomètre Dissipation"
	L.mythic_dispel_stage_4_desc = "Chronomètre indiquant quand faire la disspation lors de la dernière étape, utilisé par Echo lors de leur first kill"
	L.mythic_dispel_bar = "Dissipation"
end
