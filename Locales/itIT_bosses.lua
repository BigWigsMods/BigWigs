-- March on Quel'Danas

BigWigsAPI.SetBossModuleLocale("Belo'ren, Child of Al'ar", {
	color_swaps = "Scambio Colori",
	["1241292"] = "Picchiata Luce/Vuoto",
})

BigWigsAPI.SetBossModuleLocale("Midnight Falls", {
	deaths_dirge = "Gioco di memoria",
	heavens_glaives = "Lame",
	heavens_lance = "Lancia",
	the_dark_archangel = "Detonazione",
	prism_kicks = "Interruzioni",
	dark_constellation = "Stelle",
	dark_rune_bar = "Risolvi il gioco",

	left = "[S] %s", -- left/west group bars in p3
	right = "[D] %s", -- right/east group bars in p3

	custom_select_limit_warnings = "[Mitico] Limita avvisi della fase 3",
	custom_select_limit_warnings_desc = "Mostra avvisi delle abilità solo del tuo lato.",
	custom_select_limit_warnings_value1 = "Gruppi 1 e 2 vanno a sinistra, gruppi 3 e 4 vanno a destra.",
	custom_select_limit_warnings_value2 = "Gruppi dispari a sinistra, gruppi pari a destra.",
	custom_select_limit_warnings_value3 = "Mostra avvisi per entrambi i lati.",
	custom_select_limit_warnings_value4 = "Mostra avvisi solo per il lato sinistro.",
	custom_select_limit_warnings_value5 = "Mostra avvisi solo per il lato destro.",
})

-- Midnight World

BigWigsAPI.SetBossModuleLocale("Thorm'belan", {
	ball_incoming = "Palla in arrivo - Non lasciarla cadere",
	ball_fail = "FALLITO - La palla ha toccato terra",
	tendrils = "Viticci",
	tendrils_incoming = "CORRERE VIA per spezzare i viticci",
})

-- The Voidspire

BigWigsAPI.SetBossModuleLocale("Vorasius", {
	shadowclaw_slam = "Urto",
})

BigWigsAPI.SetBossModuleLocale("Lightblinded Vanguard", {
	aura_of_wrath = "Ira", -- Short for Aura of Wrath
	execution_sentence = "Esecuzione", -- Short for Execution Sentence
	executes_mythic = "Esecuzioni + Schiva",
	judgement_red = "Giudizio [R]", -- R for the Red icon.
	aura_of_devotion = "Devozione", -- Short for Aura of Devotion
	judgement_blue = "Giudizio [B]", -- B for the Blue icon.
	aura_of_peace = "Pace", -- Short for Aura of Peace
	tyrs_wrath_mythic = "Assorbimenti + Esecuzioni",
	divine_toll_mythic = "Schiva + Assorbimenti",

	empowered_searing_radiance = "Radiosità Rovente potenziata",
	empowered_searing_radiance_desc = "Mostra il timer per la Radiosità Rovente Potenziata.",

	empowered_avengers_shield = "Scudo del Vendicatore potenziato",
	empowered_avengers_shield_desc = "Mostra il timer per lo Scudo del Vendicatore potenziato.",

	empowered_divine_storm = "Tempesta Divina potenziata",
	empowered_divine_storm_desc = "Mostra il timer per la Tempesta Divina potenziata.",
	tornadoes = "Tornadi", -- The renamed empowered Divine Storm

	empowered = "[P] %s", -- Empowered version of an ability, [E] Avengers Shield
})

BigWigsAPI.SetBossModuleLocale("Crown of the Cosmos", {
	grasp_of_emptiness = "Obelischi",
	interrupting_tremor = "Interruzione",
	ravenous_abyss = "Uscire",
	silverstrike_barrage = "Linee",
	cosmic_barrier = "Barriera",
	voidstalker_sting = "Punture",
	aspect_of_the_end = "Catene",
	devouring_cosmos = "Prossima Piattaforma",
})
