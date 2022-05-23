local L = BigWigs:NewBossLocale("Vigilant Guardian", "ptBR")
if not L then return end
if L then
	L.sentry = "Tank Add"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "ptBR")
if L then
	L.custom_on_stop_timers = "Sempre mostrar barras de habilidade"
	L.custom_on_stop_timers_desc = "Skolex pode atrasar suas habilidades. Se esta opção for ativada, as barras para essas habilidades permanecem."

	L.tank_combo_desc = "Temporizador de habilidade para Gorja da Fenda/Dilacerar com 100 de energia."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "ptBR")
if L then
	L.sparknova = "Nova Centelhante de Hiperluz" -- Hyperlight Sparknova
	L.relocation = "Tank Bomb" -- Glyph of Relocation
	L.relocation_count = "%s S%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	L.wormholes = "Rasgos Dimensionais" -- Interdimensional Wormholes
	L.wormhole = "Rasgo Dimensional" -- Interdimensional Wormhole
	L.rings = "Aneis S%d" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "ptBR")
if L then
	L.staggering_barrage = "Bombardeio Cambaleante" -- Staggering Barrage
	L.obliteration_arc = "Arco da Obliteração" -- Obliteration Arc

	L.disintergration_halo = "Anéis" -- Disintegration Halo
	L.rings_x = "Anéis x%d"
	L.rings_enrage = "Anéis (Frenesi)"
	L.ring_count = "Anel (%d/%d)"

	L.custom_on_ring_timers = "Temporizador de anel individual"
	L.custom_on_ring_timers_desc = "Halo Desintegrador aciona um conjunto de anéis, esta opção mostrará barras quando cada um dos anéis começar a se mover. Usa as configurações do Halo Desintegrador."
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "ptBR")
if L then
	L.necrotic_ritual = "Ritual Necrótico"
	L.runecarvers_deathtouch = "Toque Mortal"
	L.windswept_wings = "Vento"
	L.wild_stampede = "Debandada"
	L.withering_seeds = "Sementes"
	L.hand_of_destruction = "Mão"
	L.nighthunter_marks_additional_desc = "|cFFFF0000Marcando com prioridade jogadores corpo a corpo nas primeiras marcações e usando a posição do grupo de raide como prioridade secundária.|r"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "ptBR")
if L then
	L.protoform_cascade = "Frontal"
	L.cosmic_shift = "Recuo"
	L.cosmic_shift_mythic = "Mudança: %s"
	L.unstable_mote = "Grânulos"
	L.mote = "Grânulo"

	L.custom_on_nameplate_fixate = "Icone de fixar nas placas de identificação"
	L.custom_on_nameplate_fixate_desc = "Mostra um ícone na placa de identificação em Automa de Aquisições que estão fixados em você.\n\nRequer o uso de placas de identificação de inimigos e um addon de placas de identificação suportado (KuiNameplates, Plater)."

	L.harmonic = "Empurrão"
	L.melodic = "Puxão"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "ptBR")
if L then
	L.custom_off_repeating_blasphemy = "Repetição de Blasfêmia"
	L.custom_off_repeating_blasphemy_desc = "Repetição de Blasfêmia fala mensagems com ícones {rt1}, {rt3} para encontrar pares para remover seus debuffs."

	L.kingsmourne_hungers = "Régio Lamento"
	L.blasphemy = "Marcas"
	L.befouled_barrier = "Barreira"
	L.wicked_star = "Estrela"
	L.domination_word_pain = "PD:Dor"
	L.army_of_the_dead = "Exército"
	L.grim_reflections = "Adds de Medo"
	L.march_of_the_damned = "Paredes"
	L.dire_blasphemy = "Marcas"

	L.remnant_active = "Remanescente ativo"
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "ptBR")
if L then
	L.seismic_tremors = "Grânulos + Tremores"
	L.earthbreaker_missiles = "Mísseis"
	L.crushing_prism = "Prismas"
	L.prism = "Prisma"
	L.ephemeral_fissure = "Fenda"

	L.bomb_dropped = "Bomba Derrubada"

	L.custom_on_stop_timers = "Sempre mostrar barras de habilidade"
	L.custom_on_stop_timers_desc = "Skolex pode atrasar suas habilidades. Se esta opção for ativada, as barras para essas habilidades permanecem."
end

L = BigWigs:NewBossLocale("Lords of Dread", "ptBR")
if L then
	L.unto_darkness = "Fase de AOE"
	L.cloud_of_carrion = "Podridão"
	L.empowered_cloud_of_carrion = "Grande podridão" -- Empowered Cloud of Carrion
	L.leeching_claws = "Frontal (M)"
	L.infiltration_of_dread = "Among Us"
	L.infiltration_removed = "Impostores encontrados em %.1fs" -- "Imposters found in 1.1s" s = seconds
	L.fearful_trepidation = "Medos"
	L.slumber_cloud = "Núvems"
	L.anguishing_strike = "Frontal (K)"

	L.custom_on_repeating_biting_wound = "Repetição de Feridas penetrantes"
	L.custom_on_repeating_biting_wound_desc = "Repetição de feridas penetrantes fala mensagems com ícone {rt7} para torná-lo mais visível."
end

L = BigWigs:NewBossLocale("Rygelon", "ptBR")
if L then
	L.celestial_collapse = "Quasares"
	L.manifest_cosmos = "Núcleos"
	L.stellar_shroud = "Absorve Cura"
	L.knock = "Empurrão" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "ptBR")
if L then
	L.rune_of_damnation_countdown = "Contagem"
	L.rune_of_damnation_countdown_desc = "Contagem para jogadores afetados por Runa de Danação"
	L.jump = "Pule dentro"

	L.relentless_domination = "Dominação"
	L.chains_of_oppression = "Puxão de Correntes"
	L.unholy_attunement = "Pilares"
	L.shattering_blast = "Impacto no Tank"
	L.rune_of_compulsion = "Enfeitiçar"
	L.desolation = "Soak de Azeroth"
	L.chains_of_anguish = "Espalhar Correntes"
	L.chain = "Corrente"
	L.chain_target = "Acorrentando %s!"
	L.chains_remaining = "%d/%d Correntes Quebradas"
	L.rune_of_domination = "Soak em Grupo"

	L.final = "%s Final" -- Final Unholy Attunement/Domination (last spell of a stage)

	L.azeroth_health = "Saúde de Azeroth"
	L.azeroth_health_desc = "Avisos para Saúde de Azeroth"

	L.azeroth_new_health_plus = "Saúde de Azeroth: +%.1f%% (%d)"
	L.azeroth_new_health_minus = "Saúde de Azeroth: -%.1f%%  (%d)"

	L.mythic_blood_soak_stage_1 = "Estágio 1, Temporizadores para soaks de sangue"
	L.mythic_blood_soak_stage_2 = "Estágio 2, Temporizadores para soaks de sangue"
	L.mythic_blood_soak_stage_3 = "Estágio 3, Temporizadores para soaks de sangue"
	L.mythic_blood_soak_stage_1_desc = "Mostra uma barra com temporizadores quando está em um bom momento para curar azeroth, usado pela Echo em sua primeira morte"
	L.mythic_blood_soak_bar = "Cure Azeroth"

	L.floors_open = "Abertura de chão"
	L.floors_open_desc = "Tempo até que o chão se abra e você possa cair em buracos abertos."

	L.mythic_dispel_stage_4 = "Tempos de Dispell"
	L.mythic_dispel_stage_4_desc = "Temporizadores para quando fazer dispell no último estágio, usado pela Echo em sua primeira morte"
	L.mythic_dispel_bar = "Dispels"
end
