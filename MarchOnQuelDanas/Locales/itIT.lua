local L = BigWigs:NewBossLocale("Belo'ren, Child of Al'ar", "itIT")
if not L then return end
if L then
	L.infused_quills = "Piume"
	L.voidlight_convergence = "Scambio Colori"
	L.light_void_dive = "Picchiata Luce/Vuoto"
end

L = BigWigs:NewBossLocale("Midnight Falls", "itIT")
if L then
	L.deaths_dirge = "Gioco di memoria"
	L.heavens_glaives = "Lame"
    L.heavens_lance = "Lancia"
	L.the_dark_archangel = "Detonazione"
	L.prism_kicks = "Interruzioni"
	L.dark_constellation = "Stelle"
	L.dark_rune = "Runa"
	L.dark_rune_bar = "Risolvi il gioco"

	L.starsplinter = "Schegge" -- Mythic intermission and P4 bar text
	L.starsplinter_you = "Scheggia"

	L.left = "[S] %s" -- left/west group bars in p3
	L.right = "[D] %s" -- right/east group bars in p3

	L.custom_select_limit_warnings = "[Mitico] Limita avvisi della fase 3"
	L.custom_select_limit_warnings_desc = "Mostra avvisi delle abilità solo del tuo lato."
	L.custom_select_limit_warnings_value1 = "Gruppi 1 e 2 vanno a sinistra, gruppi 3 e 4 vanno a destra."
	L.custom_select_limit_warnings_value2 = "Gruppi dispari a sinistra, gruppi pari a destra."
	L.custom_select_limit_warnings_value3 = "Mostra avvisi per entrambi i lati."
	L.custom_select_limit_warnings_value4 = "Mostra avvisi solo per il lato sinistro."
	L.custom_select_limit_warnings_value5 = "Mostra avvisi solo per il lato destro."
end
