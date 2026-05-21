if not BigWigsAPI.IsLocale("ptBR") then return end
BigWigsAPI.SetBossModuleLocale("Belo'ren, Child of Al'ar", {
	quills = "Cálamos",
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
