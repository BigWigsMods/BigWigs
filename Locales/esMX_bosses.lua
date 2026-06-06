-- March on Quel'Danas

BigWigsAPI.SetBossModuleLocale("Belo'ren, Child of Al'ar", {
	color_swaps = "Cambio de Color",
	["1241292"] = "Llamas de Luz/Vacío",
})

BigWigsAPI.SetBossModuleLocale("Midnight Falls", {
	deaths_dirge = "Juego de Memoria",
	heavens_glaives = "Gujas",
	heavens_lance = "Lanzas",
	the_dark_archangel = "Explosión",
	prism_kicks = "Cortes",
	dark_constellation = "Estrellas",
	dark_rune_bar = "Resuelve el Juego",

	left = "[I] %s", -- left/west group bars in p3
	right = "[D] %s", -- right/east group bars in p3

	custom_select_limit_warnings = "[Mítico] Restricciones de Alertas de la Fase 3.",
	custom_select_limit_warnings_desc = "Solo muestra Alertas de habilidades en tu lado.",
	custom_select_limit_warnings_value1 = "Grupos 1 & 2 izquierda, grupos 3 & 4 derecha.",
	custom_select_limit_warnings_value2 = "Grupos impares izquierda, grupos pares derecha.",
	custom_select_limit_warnings_value3 = "Muestra alertas para ambos lados.",
	custom_select_limit_warnings_value4 = "Muestra alertas solo para el lado izquierdo.",
	custom_select_limit_warnings_value5 = "Muestra alertas solo pra el lado derecho.",
})

-- Midnight World

BigWigsAPI.SetBossModuleLocale("Thorm'belan", {
	ball_incoming = "Se acerca Pelota - Que no toque el piso",
	ball_fail = "FALLASTE - La Pelota toco el piso",
	tendrils = "Enredaderas",
	tendrils_incoming = "CORRE para romper las enredaderas",
})

-- The Voidspire

BigWigsAPI.SetBossModuleLocale("Vorasius", {
	shadowclaw_slam = "Embates",
})

BigWigsAPI.SetBossModuleLocale("Lightblinded Vanguard", {
	aura_of_wrath = "Cólera", -- Short for Aura of Wrath
	execution_sentence = "Ejecución", -- Short for Execution Sentence
	executes_mythic = "Ejecuciones + Esquivar",
	judgement_red = "Sentencia [R]", -- R for the Red icon.
	aura_of_devotion = "Devoción", -- Short for Aura of Devotion
	judgement_blue = "Sentencia [B]", -- B for the Blue icon.
	aura_of_peace = "Paz", -- Short for Aura of Peace
	tyrs_wrath_mythic = "Absorciones + Ejecuciones",
	divine_toll_mythic = "Esquivar + Absorciones",

	empowered_searing_radiance = "Escudo de Vengador Potenciado",
	empowered_searing_radiance_desc = "Muestra el temporizador para el Escudo de Vengador Potenciado.",

	empowered_avengers_shield = "Escudo de Vengador Potenciado",
	empowered_avengers_shield_desc = "Muestra el temporizador para el Escudo de Vengador Potenciado.",

	empowered_divine_storm = "Tormenta Divina Potenciada",
	empowered_divine_storm_desc = "Muestra el temporizador de la Tormenta Divina Potenciada.",
	tornadoes = "Tornados", -- The renamed empowered Divine Storm

	empowered = "[P] %s", -- Empowered version of an ability, [E] Avengers Shield
})

BigWigsAPI.SetBossModuleLocale("Crown of the Cosmos", {
	grasp_of_emptiness = "Obeliscos",
	interrupting_tremor = "Cortes",
	ravenous_abyss = "Muevanse",
	silverstrike_barrage = "Flechas",
	cosmic_barrier = "Barrera",
	voidstalker_sting = "Picadura",
	aspect_of_the_end = "Cadenas",
	devouring_cosmos = "Siguiente Plataforma",
})
