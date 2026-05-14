if not BigWigsAPI.IsLocale("deDE") then return end
BigWigsAPI.SetBossModuleLocale("Belo'ren, Child of Al'ar", {
	infused_quills = "Federkiele",
	voidlight_convergence = "Farbwechsel",
	light_void_dive = "Licht/Leerensturz",
})

BigWigsAPI.SetBossModuleLocale("Midnight Falls", {
	deaths_dirge = "Memory Spiel",
	heavens_glaives = "Gleven",
	heavens_lance = "Lanze",
	the_dark_archangel = "Großer Knall",
	prism_kicks = "Unterbrechungen",
	dark_constellation = "Sterne",
	dark_rune_bar = "Löse das Spiel",

	left = "[L] %s", -- left/west group bars in p3
	right = "[R] %s", -- right/east group bars in p3

	custom_select_limit_warnings = "[Mythisch] Phase 3 Warnungen einschränken",
	custom_select_limit_warnings_desc = "Nur Warnungen für Fähigkeiten auf Deiner Seite anzeigen.",
	custom_select_limit_warnings_value1 = "Gruppen 1 & 2 links, Gruppen 3 & 4 rechts.",
	custom_select_limit_warnings_value2 = "Ungerade Gruppen links, gerade Gruppen rechts.",
	custom_select_limit_warnings_value3 = "Warnungen für beide Seiten anzeigen.",
	custom_select_limit_warnings_value4 = "Nur Warnungen für linke Seite anzeigen.",
	custom_select_limit_warnings_value5 = "Nur Warnungen für rechte Seite anzeigen.",

	dark_quasar_stage1_note = "Nur Phase 1",
	dark_quasar_intermission_note = "Nur Zwischenphase",
})
