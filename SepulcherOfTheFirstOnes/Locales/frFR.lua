local L = BigWigs:NewBossLocale("Vigilant Guardian", "frFR")
if not L then return end
if L then
	--L.sentry = "Tank Add"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "frFR")
if L then
	L.custom_on_stop_timers = "Toujours afficher les compétences du boss"
	L.custom_on_stop_timers_desc = "Il se peut que les timers soient décalés selon le déroulement du combnat. Quand cette option est activée, les compétences utilisées par le boss resteront affichées."

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

	L.custom_on_ring_timers = "Décomptes Individuels de Halo de Désintégration"
	L.custom_on_ring_timers_desc = "Halo de Désintégration va déclencher un combo d'anneaux. Ainsi des barres seront affichées pour chaque anneau qui apparaîtra."
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "frFR")
if L then
	L.necrotic_ritual = "Rituel"
	L.runecarvers_deathtouch = "Toucher de la mort"
	L.windswept_wings = "Rafale"
	L.wild_stampede = "Ruée"
	L.withering_seeds = "Graines"
	L.hand_of_destruction = "Main"
	L.nighthunter_marks_additional_desc = "|cFFFF0000Pose des marques sur les joueurs en priorisant les corps à corps et ensuite selon la position des joueurs.|r"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "frFR")
if L then
	L.protoform_cascade = "Frontal"
	L.cosmic_shift = "Poussée"
	L.cosmic_shift_mythic = "Poussée (Mythique): %s"
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
	L.seismic_tremors = "Secousses Sismiques"
	L.earthbreaker_missiles = "Missiles"
	L.crushing_prism = "Prismes écrasants"
	L.prism = "Prisme"
	L.ephemeral_fissure = "Fissure"

	L.bomb_dropped = "Bombe posée"

	L.custom_on_stop_timers = "Toujours afficher les compétences du boss"
	L.custom_on_stop_timers_desc = "Il se peut que les timers soient décalés selon le déroulement du combnat. Quand cette option est activée, les compétences utilisées par le boss resteront affichées."
end

L = BigWigs:NewBossLocale("Lords of Dread", "frFR")
if L then
	L.unto_darkness = "AoE Phase"
	L.cloud_of_carrion = "Nuée de charognards"
	L.empowered_cloud_of_carrion = "Aura de charognards" -- Empowered Cloud of Carrion
	L.leeching_claws = "Frontal (M)"
	L.infiltration_of_dread = "Among Us"
	L.infiltration_removed = "Imposteurs trouvés en %.1fs" -- "Imposters found in 1.1s" s = seconds
	L.fearful_trepidation = "Fears"
	L.slumber_cloud = "Nuages"
	L.anguishing_strike = "Frontal (K)"

	L.custom_on_repeating_biting_wound = "Répéter Morsures Béantes
	L.custom_on_repeating_biting_wound_desc = "Cocher cette option permet d'avoir plus de visibilité si l'on est affecté par le débuff morsures béantes en affichant une {rt7} au dessus de votre tête."
end

L = BigWigs:NewBossLocale("Rygelon", "frFR")
if L then
	L.celestial_collapse = "Quasars"
	L.manifest_cosmos = "Cores"
	L.stellar_shroud = "Absorption de soins"
	L.knock = "Knock" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "frFR")
if L then
	L.rune_of_damnation_countdown = "Décompte"
	L.rune_of_damnation_countdown_desc = "Décompte pour les joueurs affectés par la Rune de damnation "
	L.jump = "Sautes"

	L.relentless_domination = "Domination"
	L.chains_of_oppression = "Pull Chains"
	L.unholy_attunement = "Pylones"
	L.shattering_blast = "Tank Blast"
	L.rune_of_compulsion = "Charme"
	L.desolation = "Azeroth Soak"
	L.chains_of_anguish = "Spread Chaînes"
	L.chain = "Chaîne"
	L.chain_target = "Enchaîné (Stacks) %s!"
	L.chains_remaining = "%d/%d Chaînes Cassées"
	L.rune_of_domination = "Groupes Soaks"

	L.final = "Final %s" -- Final Unholy Attunement/Domination (last spell of a stage)

	L.azeroth_health = "Vie d'Azeroth"
	L.azeroth_health_desc = "Avertissement vie d'Azeroth"

	L.azeroth_new_health_plus = "Vie d'Azeroth: +%.1f%% (%d)"
	L.azeroth_new_health_minus = "Vie d'Azeroth: -%.1f%%  (%d)"

	L.mythic_blood_soak_stage_1 = "Stage 1 Blood Soak timings"
	L.mythic_blood_soak_stage_1_desc = "Show a bar for timings when healing azeroth is at a good time, used by Echo on their first kill"
	L.mythic_blood_soak_stage_2 = "Stage 2 Blood Soak timings"
	L.mythic_blood_soak_stage_2_desc = L.mythic_blood_soak_stage_1_desc
	L.mythic_blood_soak_stage_3 = "Stage 3 Blood Soak timings"
	L.mythic_blood_soak_stage_3_desc = L.mythic_blood_soak_stage_1_desc
	L.mythic_blood_soak_bar = "Soigner Azeroth"

	L.floors_open = "Sol Ouvert"
	L.floors_open_desc = "Affiche le temps restant avant que le sol s'ouvre afin de vous avertir."

	L.mythic_dispel_stage_4 = "Dispel Timers"
	L.mythic_dispel_stage_4_desc = "Affiche les timers pour dispell pendant la dernière phase. Utilisé par Echo"
	L.mythic_dispel_bar = "Dispels"
end
