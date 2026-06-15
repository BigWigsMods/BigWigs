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
