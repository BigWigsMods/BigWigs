-- March on Quel'Danas

BigWigsAPI.SetBossModuleLocale("Belo'ren, Child of Al'ar", {
	color_swaps = "Troca de cores",
	["1241292"] = "Mergulho Luz/Caos",
})

BigWigsAPI.SetBossModuleLocale("Midnight Falls", {
	deaths_dirge = "Jogo da Memória",
	heavens_glaives = "Glaives",
	heavens_lance = "Lança",
	the_dark_archangel = "Grande Explosão",
	prism_kicks = "Cortes",
	dark_constellation = "Estrelas",
	dark_rune_bar = "Resolva o Enigma",

	left = "[E] %s", -- left/west group bars in p3
	right = "[D] %s", -- right/east group bars in p3

	custom_select_limit_warnings = "[Mítico] Restringir Avisos de Estágio 3",
	custom_select_limit_warnings_desc = "Exibir avisos apenas para habilidades do seu lado.",
	custom_select_limit_warnings_value1 = "Os grupos 1 e 2 vão para a esquerda, os grupos 3 e 4 vão para a direita..",
	custom_select_limit_warnings_value2 = "Grupos ímpares à esquerda, grupos pares à direita..",
	custom_select_limit_warnings_value3 = "Exibir avisos para ambos os lados.",
	custom_select_limit_warnings_value4 = "Exibir avisos apenas para o lado esquerdo.",
	custom_select_limit_warnings_value5 = "Exibir avisos apenas para o lado direito.",
})

-- Midnight World

BigWigsAPI.SetBossModuleLocale("Thorm'belan", {
	ball_incoming = "Bola Chegando - Não deixe tocar no chão",
	ball_fail = "FALHA - A bola tocou no chão",
	tendrils = "Gavinhas",
	tendrils_incoming = "CORRA para romper as gavinhas",
})

-- The Voidspire

BigWigsAPI.SetBossModuleLocale("Vorasius", {
	shadowclaw_slam = "Golpes",
})

BigWigsAPI.SetBossModuleLocale("Vaelgor & Ezzorak", {
	nullzone = "Correntes",
})

BigWigsAPI.SetBossModuleLocale("Lightblinded Vanguard", {
	aura_of_wrath = "Fúria", -- Short for Aura of Wrath
	execution_sentence = "Execuções", -- Short for Execution Sentence
	executes_mythic = "Execuções + Esquiva",
	judgement_red = "Julgamento [V]", -- R for the Red icon.
	aura_of_devotion = "Devoção", -- Short for Aura of Devotion
	judgement_blue = "Julgamento [A]", -- B for the Blue icon.
	aura_of_peace = "Paz", -- Short for Aura of Peace
	tyrs_wrath_mythic = "Absorções + Execuções",
	divine_toll_mythic = "Esquiva + Absorções",

	empowered_searing_radiance = "Resplendor Calcinante Potencializado",
	empowered_searing_radiance_desc = "Mostra o temporizador para o Resplendor Calcinante potencializado.",

	empowered_avengers_shield = "Escudo do Vingador Potencializado",
	empowered_avengers_shield_desc = "Mostra o temporizador para o Escudo do Vingador potencializado.",

	empowered_divine_storm = "Tempestade Divina Potencializada",
	empowered_divine_storm_desc = "Mostra o temporizador para a Tempestade Divina potencializada.",
	tornadoes = "Tornados", -- The renamed empowered Divine Storm

	empowered = "[P] %s", -- Empowered version of an ability, [E] Avengers Shield
})

BigWigsAPI.SetBossModuleLocale("Crown of the Cosmos", {
	grasp_of_emptiness = "Obeliscos",
	interrupting_tremor = "Corte",
	ravenous_abyss = "Afaste-se",
	silverstrike_barrage = "Linhas",
	cosmic_barrier = "Barreira",
	voidstalker_sting = "Ferroadas",
	aspect_of_the_end = "Correntes",
	devouring_cosmos = "Próxima Plataforma",
})

-- The Venomous Abyss

BigWigsAPI.SetBossModuleLocale("Nek'zali the Soulcoiler", {
	--possession_barrage = "Barrage",
})

BigWigsAPI.SetBossModuleLocale("The Lost Explorers", {
	--trader_gebbo = "Gebbo",
	--first_mate_nama = "Nama",
	--scrollsage_iku = "Iku",
})

BigWigsAPI.SetBossModuleLocale("Vashnik the Malignant", {
	--malignant_catalyst = "Catalyst", -- Short for Malignant Catalyst
})

BigWigsAPI.SetBossModuleLocale("The Twin Fangs", {
	--coiling_toxin = "Toxin", -- Short for Coiling Toxin
	--corrosive_spit = "Spit", -- Short for Corrosive Spit
})

BigWigsAPI.SetBossModuleLocale("Ula'tek", {
	--mephitic_thrash = "Sweep",
	--call_of_the_serpent = "Eggs",
	--gore_rattle = "Tail",
	--grasping_fangs = "Tethers",
	--circling_prey = "Platform Break",
	--p3_knock_up = "Knock Up",

	--toxic_womb = "Wretch Spawn",
	--fester_burst = "Wretch Bubble",
	--toxic_incubation = "Wretch Waves",

	--count_amount_side = "%s (%d/%d) %s",
	--count_side = "%s (%d) %s",
	--fester_burst_count = "%s (%d-%d)",

	--custom_select_limit_warnings = "Spectral Coils Group",
	--custom_select_limit_warnings_desc = "Only show bars for your soak group (left or right).  Right side is first in stage one, left side is first in intermission.",
	--custom_select_limit_warnings_value1 = "Show warnings for both sides.",
	--custom_select_limit_warnings_value2 = "Show warnings for left side only.",
	--custom_select_limit_warnings_value3 = "Show warnings for right side only.",
	--custom_select_limit_warnings_value4 = "Odd groups left, even groups right.",
	--custom_select_limit_warnings_value5 = "Mythic: Groups 1 & 2 go left, groups 3 & 4 go right. Others: Groups 1/2/3 go left, groups 4/5/6 go right.",
})
