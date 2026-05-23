if not BigWigsAPI.IsLocale("esMX") then return end
BigWigsAPI.SetBossModuleLocale("Belo'ren, Child of Al'ar", {
	quills = "Péndolas",
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
	custom_select_limit_warnings_value2 = "Grupos impares izquierda, grupos pares derecha",
	custom_select_limit_warnings_value3 = "Muestra alertas para ambos lados.",
	custom_select_limit_warnings_value4 = "Muestra alertas solo para el lado izquierdo.",
	custom_select_limit_warnings_value5 = "Muestra alertas solo pra el lado derecho.",
})
