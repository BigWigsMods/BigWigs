-- March on Quel'Danas

BigWigsAPI.SetBossModuleLocale("Belo'ren, Child of Al'ar", {
	color_swaps = "Cambio de color",
	["1241292"] = "Caída de luz/vacío",
})

BigWigsAPI.SetBossModuleLocale("Midnight Falls", {
	deaths_dirge = "Juego de memoria",
	heavens_glaives = "Gujas",
	heavens_lance = "Lanza",
	the_dark_archangel = "Gran explosión",
	prism_kicks = "Cortes",
	dark_constellation = "Estrellas",
	dark_rune_bar = "Resolver el juego",

	left = "[I] %s", -- left/west group bars in p3
	right = "[D] %s", -- right/east group bars in p3

	custom_select_limit_warnings = "[Mítico] Restringir avisos de fase 3",
	custom_select_limit_warnings_desc = "Solo mostrar avisos de las habilidades en tu lado.",
	custom_select_limit_warnings_value1 = "Grupos 1 y 2 van a la izquierda, grupos 3 y 4 a la derecha.",
	custom_select_limit_warnings_value2 = "Grupos impares izquierda, pares derecha.",
	custom_select_limit_warnings_value3 = "Mostrar avisos para ambos lados.",
	custom_select_limit_warnings_value4 = "Solo mostrar avisos del lado izquierdo.",
	custom_select_limit_warnings_value5 = "Solo mostrar avisos del lado derecho.",
})

-- Midnight World

BigWigsAPI.SetBossModuleLocale("Thorm'belan", {
	--ball_incoming = "Ball Incoming - Don't let it touch the ground",
	--ball_fail = "FAIL - Ball touched the ground",
	--tendrils = "Tendrils",
	--tendrils_incoming = "RUN AWAY to snap tendrils",
})

-- The Voidspire

BigWigsAPI.SetBossModuleLocale("Vorasius", {
	shadowclaw_slam = "Embates",
})

BigWigsAPI.SetBossModuleLocale("Vaelgor & Ezzorak", {
	nullzone = "Ataduras",
})

BigWigsAPI.SetBossModuleLocale("Lightblinded Vanguard", {
	aura_of_wrath = "Cólera", -- Short for Aura of Wrath
	execution_sentence = "Ejecuciones", -- Short for Execution Sentence
	executes_mythic = "Ejecuciones + esquivar",
	judgement_red = "Sentencia [R]", -- R for the Red icon.
	aura_of_devotion = "Devoción", -- Short for Aura of Devotion
	judgement_blue = "Sentencia [A]", -- B for the Blue icon.
	aura_of_peace = "Paz", -- Short for Aura of Peace
	tyrs_wrath_mythic = "Absorciones + Sentencias",
	divine_toll_mythic = "Esquivar + Absorciones",

	empowered_searing_radiance = "Radiancia abrasadora potenciada",
	empowered_searing_radiance_desc = "Enseñar el temporizador de Radiancia abrasadora potenciada.",

	empowered_avengers_shield = "Escudo de vengador potenciado",
	empowered_avengers_shield_desc = "Enseñar el temporizador de Escudo de vengador potenciado.",

	empowered_divine_storm = "Tormenta divina potenciada",
	empowered_divine_storm_desc = "Enseñar el temporizador de Tormenta divina potenciada.",
	tornadoes = "Tempestad", -- The renamed empowered Divine Storm

	empowered = "[P] %s", -- Empowered version of an ability, [E] Avengers Shield
})

BigWigsAPI.SetBossModuleLocale("Crown of the Cosmos", {
	grasp_of_emptiness = "Obeliscos",
	interrupting_tremor = "Interrumpir",
	ravenous_abyss = "Salir",
	silverstrike_barrage = "Líneas",
	cosmic_barrier = "Barrera",
	voidstalker_sting = "Picaduras",
	aspect_of_the_end = "Ataduras",
	devouring_cosmos = "Siguiente plataforma",
})
