local L = BigWigs:NewBossLocale("The Tarragrue", "ptBR")
if not L then return end
if L then
	L.chains = "Correntes" -- Chains of Eternity (Chains)
	L.remnants = "Resquícios" -- Remnant of Forgotten Torments (Remnants)

	L.physical_remnant = "Resquício Físico"
	L.magic_remnant = "Resquício Mágico"
	L.fire_remnant = "Resquício de Fogo"
	L.fire = "Fogo"
	L.magic = "Mágico"
	L.physical = "Físico"
end

L = BigWigs:NewBossLocale("The Eye of the Jailer", "ptBR")
if L then
	L.chains = "Correntes" -- Short for Dragging Chains
	L.pool = "Poça" -- Spreading Misery
	L.pools = "Poças" -- Spreading Misery (multiple)
	L.death_gaze = "Mirada da Morte" -- Short for Titanic Death Gaze
end

L = BigWigs:NewBossLocale("The Nine", "ptBR")
if L then
	L.fragments = "Fragmentos" -- Short for Fragments of Destiny
	L.fragment = "Fragmento" -- Singular Fragment of Destiny
	L.run_away = "Corra pra longe" -- Wings of Rage
	L.song = "Canção" -- Short for Song of Dissolution
	L.go_in = "Vá para dentro" -- Reverberating Refrain
	L.valkyr = "Val'kyren" -- Short for Call of the Val'kyr
	L.blades = "Lâminas" -- Agatha's Eternal Blade
	L.big_bombs = "Bombas Grandes" -- Daschla's Mighty Impact
	L.big_bomb = "Bomba Grande" -- Attached to the countdown
	L.shield = "Escudo" -- Annhylde's Bright Aegis
	L.soaks = "Soaks" -- Aradne's Falling Strike
	L.small_bombs = "Bombas Pequenas" -- Brynja's Mournful Dirge
	L.recall = "Revocação" -- Short for Word of Recall

	L.blades_yell = "Morram pela minha lâmina!"
	L.soaks_yell = "Vocês estão em desvantajem!"
	L.shield_yell = "Meu escudo jamais estremece!"

	L.berserk_stage1 = "Estágio 1 do Berserk"
	L.berserk_stage2 = "Estágio 2 do Berserk"

	L.image_special = "%s [Skyja]" -- Stage 2 boss name
end

L = BigWigs:NewBossLocale("Remnant of Ner'zhul", "ptBR")
if L then
	L.cones = "Cones" -- Grasp of Malice
	L.orbs = "Orbes" -- Orb of Torment
	L.orb = "Orbe" -- Orb of Torment
end

L = BigWigs:NewBossLocale("Soulrender Dormazain", "ptBR")
if L then
	L.custom_off_nameplate_defiance = "Ícone de placa de identificação para Defiance"
	L.custom_off_nameplate_defiance_desc = "Mostra um ícone na placa de identificação do Górjuro que tem Defiance.\n\nRequer o uso de Placas de Identificação Inimigas e um addon suportado (KuiNameplates, Plater)."

	L.custom_off_nameplate_tormented = "Ícone de placa de identificação para Atormentado"
	L.custom_off_nameplate_tormented_desc = "Mostra um ícone na placa de identificação do Górjuro que tem Atormentado.\n\nRequer o uso de Placas de Identificação Inimigas e um addon suportado (KuiNameplates, Plater)."

	L.cones = "Cones" -- Torment
	L.dance = "Dança" -- Encore of Torment
	L.brands = "Marcas" -- Brand of Torment
	L.brand = "Marca" -- Single Brand of Torment
	L.spike = "Espeto" -- Short for Agonizing Spike
	L.chains = "Correntes" -- Hellscream
	L.chain = "Corrente" -- Soul Manacles
	L.souls = "Almas" -- Rendered Soul

	L.chains_remaining = "%d Correntes restantes"
	L.all_broken = "Todas as Correntes foram quebradas"
end

L = BigWigs:NewBossLocale("Painsmith Raznal", "ptBR")
if L then
	L.hammer = "Martelo" -- Short for Rippling Hammer
	L.axe = "Machado" -- Short for Cruciform Axe
	L.scythe = "Foice" -- Short for Dualblade Scythe
	L.trap = "Armadilha" -- Short for Flameclasp Trap
	L.chains = "Correntes" -- Short for Shadowsteel Chains
	L.embers = "Brasas" -- Short for Shadowsteel Embers
	-- L.adds_embers = "Embers (%d) - Adds Next!"
	-- L.adds_killed = "Adds killed in %.2fs"
	-- L.spikes = "Spiked Death" -- Soft enrage spikes
end

L = BigWigs:NewBossLocale("Guardian of the First Ones", "ptBR")
if L then
	L.custom_on_stop_timers = "Sempre mostrar barras de habilidade"
	L.custom_on_stop_timers_desc = "O Guardião pode atrasar suas habilidades. Quando essa opção estiver habilitada, as barras para essas habilidades irão permanecer na sua tela."
end

L = BigWigs:NewBossLocale("Fatescribe Roh-Kalo", "ptBR")
if L then
	L.rings = "Anéis"
	L.rings_active = "Anéis Ativos" -- for when they activate/are movable
	L.runes = "Runas"

	L.grimportent_countdown = "Contagem Regressiva"
	L.grimportent_countdown_desc = "Contagem Regressiva para jogadores que estão afetados pelo Augúrio Temível"
	L.grimportent_countdown_bartext = "Vá para a runa!"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "ptBR")
if L then
	L.spikes = "Espetos" -- Short for Glacial Spikes
	L.spike = "Espeto"
	L.miasma = "Miasma" -- Short for Sinister Miasma

	L.custom_on_nameplate_fixate = "Ícone de placa de identificação para Fixação"
	L.custom_on_nameplate_fixate_desc = "Mostra um ícone na placa de identificação para quando os Devotados Atagelo estão fixados em você.\n\nRequer o uso de Placas de Identificação Inimigas e um addon suportado  (KuiNameplates, Plater)."
end

L = BigWigs:NewBossLocale("Sylvanas Windrunner", "ptBR")
if L then
	L.chains_active = "Correntes Ativas"
	L.chains_active_desc = "Mostra uma barra para quando as Correntes da Dominação forem ativadas"

	L.custom_on_nameplate_fixate = "Ícone de placa de identificação para Fixação"
	L.custom_on_nameplate_fixate_desc = "Mostra um ícone na placa de identificação para quando as Sentinelas Sombrias estão fixadas em você.\n\nRequer o uso de Placas de Identificação Inimigas e um addon suportado  (KuiNameplates, Plater)."

	L.chains = "Correntes" -- Short for Domination Chains
	L.chain = "Corrente" -- Single Domination Chain
	L.darkness = "Trevas" -- Short for Veil of Darkness
	L.arrow = "Seta" -- Short for Wailing Arrow
	L.wave = "Onda" -- Short for Haunting Wave
	L.dread = "Pavor" -- Short for Crushing Dread
	L.orbs = "Orbes" -- Dark Communion
	L.curse = "Maldição" -- Short for Curse of Lethargy
	L.pools = "Poças" -- Banshee's Bane
	L.scream = "Grito" -- Banshee Scream

	L.knife_fling = "Olha a faca!" -- "Death-touched blades fling out"
end

