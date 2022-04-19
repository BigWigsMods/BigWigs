local L = BigWigs:NewBossLocale("Vigilant Guardian", "itIT")
if not L then return end
if L then
	L.sentry = "Add da Tankare"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "itIT")
if L then
	--L.custom_on_stop_timers = "Always show ability bars"
	--L.custom_on_stop_timers_desc = "Skolex can delay its abilities. When this option is enabled, the bars for those abilities will stay on your screen."

	L.tank_combo_desc = "Conto alla Rovescia per il lancio di Fendifauce/Squartamento al raggiungimento di 100 energia."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "itIT")
if L then
	L.sparknova = "Nova Scintillante" -- Hyperlight Sparknova
	L.relocation = "Bomba sul Difensore" -- Glyph of Relocation
	L.relocation_count = "%s S%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	L.wormholes = "Tunnel Spaziotemporali" -- Interdimensional Wormholes
	L.wormhole = "Tunnel Spaziotemporale" -- Interdimensional Wormhole
	L.rings = "Anelli S%d" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "itIT")
if L then
	L.staggering_barrage = "Raffica" -- Staggering Barrage
	L.obliteration_arc = "Arco" -- Obliteration Arc

	L.disintergration_halo = "Anelli" -- Disintegration Halo
	L.rings_x = "Anello x%d"
	L.rings_enrage = "Anelli (Enrage)"
	L.ring_count = "Anello (%d/%d)"

	L.custom_on_ring_timers = "Timer Individuali Aureola"
	L.custom_on_ring_timers_desc = "Aureola Disintegrante attiva una serie di anelli, verranno mostrate barre per quando questi anelli inizieranno a muoversi. Usa le impostazioni di Aureola Disintegrante."
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "itIT")
if L then
	L.necrotic_ritual = "Rituale"
	L.runecarvers_deathtouch = "Tocco Mortale"
	L.windswept_wings = "Spazzata"
	L.wild_stampede = "Impeto"
	L.withering_seeds = "Semi"
	L.hand_of_destruction = "Mano"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "itIT")
if L then
	L.protoform_cascade = "Frontale"
	L.cosmic_shift = "Respingimento"
	L.cosmic_shift_mythic = "Cambio: %s"
	L.unstable_mote = "Granuli"
	L.mote = "Granulo"

	L.custom_on_nameplate_fixate = "Icona Barra del Nome Fissa"
	L.custom_on_nameplate_fixate_desc = "Mostra un'icona sulla Barra del nome dell'Automa dell'Acquisizione che ha preso te come bersaglio.\n\nRichiede l'uso delle B arre del Nome del Nemico e un'addon per nameplates supportato (KuiNameplates, Plater)."

	L.harmonic = "Spingere"
	L.melodic = "Tirare"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "itIT")
if L then
	L.custom_off_repeating_blasphemy = "Ripetizione Blasfemia"
	L.custom_off_repeating_blasphemy_desc = "Ripetizione Blasfemia fa parlare il personaggio con le icone {rt1}, {rt3} per trovare la corrispondenza che elimina il tuo maleficio."

	L.kingsmourne_hungers = "Fame di Dominanima"
	L.blasphemy = "Marchi"
	L.befouled_barrier = "Barriera"
	L.wicked_star = "Stella"
	L.domination_word_pain = "Parola del Dominio: Dolore "
	L.army_of_the_dead = "Armata"
	L.grim_reflections = "Controlla Adds"
	L.march_of_the_damned = "Muri"
	L.dire_blasphemy = "Simboli"

	L.remnant_active = "Residuo Attivo"
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "itIT")
if L then
	L.seismic_tremors = "Granuli + Tremori"
	L.earthbreaker_missiles = "Missili"
	L.crushing_prism = "Prismi"
	L.prism = "Prisma"
	L.ephemeral_fissure = "Fessura"

	L.bomb_dropped = "Bomba rilasciata"

	L.custom_on_stop_timers = "Mostra sempre le barre delle abilità"
	L.custom_on_stop_timers_desc = "Halondrus può ritardare le sue abilità. Quando questa opzione è attiva, le barre per le sue abilità rimarranno a schermo."
end

L = BigWigs:NewBossLocale("Lords of Dread", "itIT")
if L then
	L.unto_darkness = "Fase AoE"
	L.cloud_of_carrion = "Nube Necrotica"
	L.empowered_cloud_of_carrion = "Nube Potenziata" -- Empowered Cloud of Carrion
	L.leeching_claws = "Frontale (Mal'Ganis)"
	L.infiltration_of_dread = "Tra di Noi"
	L.infiltration_removed = "Impostori trovati in %.1fs" -- "Imposters found in 1.1s" s = seconds
	L.fearful_trepidation = "Trepidazione"
	L.slumber_cloud = "Nubi"
	L.anguishing_strike = "Frontale (Kintessa)"

	L.custom_on_repeating_biting_wound = "Accumulo Ferite Pungenti"
	L.custom_on_repeating_biting_wound_desc = "Accumulo Ferite Pungenti fa' parlare con messaggi ed icone {rt7} per renderlo più visibile."
end

L = BigWigs:NewBossLocale("Rygelon", "itIT")
if L then
	L.celestial_collapse = "Quasars"
	L.manifest_cosmos = "Nuclei"
	L.stellar_shroud = "Assorbimento Cure"
	L.knock = "Rinculo" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "itIT")
if L then
	L.rune_of_damnation_countdown = "Conto alla rovescia"
	L.rune_of_damnation_countdown_desc = "Conto alla rovescia per i giocatori afflitti da Runa della Dannazione"
	L.jump = "Salta dentro"

	L.relentless_domination = "Dominazione"
	L.chains_of_oppression = "Tirare le Catene"
	L.unholy_attunement = "Piloni"
	L.shattering_blast = "Esplosione sul Tank"
	L.rune_of_compulsion = "Ammaliamenti"
	--L.desolation = "Azeroth Soak"
	L.chains_of_anguish = "Distribuire le Catene"
	L.chain = "Catena"
	L.chain_target = "Incatenato: %s!"
	L.chains_remaining = "%d/%d Catene Spezzate"
	L.rune_of_domination = "Assorbimento di Gruppo"

	L.final = "Ultimo %s" -- Final Unholy Attunement/Domination (last spell of a stage)

	L.azeroth_health = "Salute di Azeroth"
	L.azeroth_health_desc = "Avvisi per Salute di Azeroth"

	L.azeroth_new_health_plus = "Salute di Azeroth: +%.1f%% (%d)"
	L.azeroth_new_health_minus = "Salute di Azeroth: -%.1f%%  (%d)"

	L.mythic_blood_soak_stage_1 = "Timing per gli assorbimenti del Sangue in Fase 1"
	L.mythic_blood_soak_stage_2 = "Timing per gli assorbimenti del Sangue in Fase 2"
	L.mythic_blood_soak_stage_3 = "Timing per gli assorbimenti del Sangue in Fase 3"
	L.mythic_blood_soak_stage_1_desc = "Mostra una barra per illustrare quale è il timing migliore per curare Azeroth, usata dall'Eco dopo la prima uccisione"
	L.mythic_blood_soak_bar = "Cura Azeroth"

	L.floors_open = "Pavimento Aperto"
	L.floors_open_desc = "Timer per l'apertura del pavimento per poi successivamente saltare dentro i buchi."

	L.mythic_dispel_stage_4 = "Timer per le Dissoluzioni"
	L.mythic_dispel_stage_4_desc = "Timers for when to do dispels nell'ultima fase, usata dagli Echo on their first kill"
	L.mythic_dispel_bar = "Dissoluzioni"
end
