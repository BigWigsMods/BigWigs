-- March on Quel'Danas

BigWigsAPI.SetBossModuleLocale("Belo'ren, Child of Al'ar", {
	color_swaps = "Farbwechsel",
	["1241292"] = "Licht/Leerensturz",
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
})

-- Midnight World

BigWigsAPI.SetBossModuleLocale("Thorm'belan", {
	ball_incoming = "Ball kommt - Er darf den Boden nicht berühren",
	ball_fail = "FEHLSCHLAG - Ball hat den Boden berührt",
	tendrils = "Ranken",
	tendrils_incoming = "WEGLAUFEN um die Ranken zu zerreißen",
})

-- The Voidspire

BigWigsAPI.SetBossModuleLocale("Vorasius", {
	shadowclaw_slam = "Hiebe",
})

BigWigsAPI.SetBossModuleLocale("Lightblinded Vanguard", {
	aura_of_wrath = "Zorn", -- Short for Aura of Wrath
	execution_sentence = "Todesurteil", -- Short for Execution Sentence
	executes_mythic = "Hinrichtungen  + Ausweichen",
	judgement_red = "Richturteil [R]", -- R for the Red icon.
	aura_of_devotion = "Hingabe", -- Short for Aura of Devotion
	judgement_blue = "Richturteil [B]", -- B for the Blue icon.
	aura_of_peace = "Frieden", -- Short for Aura of Peace
	tyrs_wrath_mythic = "Absorption + Hinrichtungen",
	divine_toll_mythic = "Ausweichen + Absorption",

	empowered_searing_radiance = "Ermächtigtes Versengendes Strahlen",
	empowered_searing_radiance_desc = "Zeigt den Timer für das ermächtigte Versengende Strahlen.",

	empowered_avengers_shield = "Ermächtigter Schild des Rächers",
	empowered_avengers_shield_desc = "Zeigt den Timer für den ermächtigten Schild des Rächers.",

	empowered_divine_storm = "Ermächtigter Göttlicher Sturm",
	empowered_divine_storm_desc = "Zeigt den Timer für den ermächtigten Göttlichen Sturm.",
	tornadoes = "Tornados", -- The renamed empowered Divine Storm

	empowered = "[E] %s", -- Empowered version of an ability, [E] Avengers Shield
})

BigWigsAPI.SetBossModuleLocale("Crown of the Cosmos", {
	grasp_of_emptiness = "Obelisken",
	interrupting_tremor = "Unterbrechung",
	ravenous_abyss = "Herausbewegen",
	silverstrike_barrage = "Linien",
	cosmic_barrier = "Barriere",
	voidstalker_sting = "Stiche",
	aspect_of_the_end = "Verbindungen",
	devouring_cosmos = "Nächste Plattform",
})
