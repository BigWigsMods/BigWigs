if not BigWigsAPI.IsLocale("frFR") then return end
BigWigsAPI.SetBossModuleLocale("Vorasius", {
	shadowclaw_slam = "Coups",
})

BigWigsAPI.SetBossModuleLocale("Lightblinded Vanguard", {
	aura_of_wrath = "Colère", -- Short for Aura of Wrath
	execution_sentence = "Exécution", -- Short for Execution Sentence
	executes_mythic = "Exécution + Esquive",
	judgement_red = "Jugement [R]", -- R for the Red icon.
	aura_of_devotion = "Dévotion", -- Short for Aura of Devotion
	judgement_blue = "Jugement [B]", -- B for the Blue icon.
	aura_of_peace = "Paix", -- Short for Aura of Peace
	tyrs_wrath_mythic = "Absorption + Exécution",
	divine_toll_mythic = "Esquive + Absorption",

	empowered_searing_radiance = "Radiance ardente renforcée",
	empowered_searing_radiance_desc = "Affiche le chrono de la radiance ardente renforcée.",

	empowered_avengers_shield = "Bouclier du vengeur renforcé",
	empowered_avengers_shield_desc = "Affiche le chrono du bouclier du vengeur renforcé.",

	empowered_divine_storm = "Tempête divine renforcée",
	empowered_divine_storm_desc = "Affiche le chrono de la tempête divine renforcée.",
	tornadoes = "Tornades", -- The renamed empowered Divine Storm

	empowered = "[R] %s", -- Empowered version of an ability, [E] Avengers Shield
})

BigWigsAPI.SetBossModuleLocale("Crown of the Cosmos", {
	grasp_of_emptiness = "Obélisques",
	interrupting_tremor = "Interruption",
	ravenous_abyss = "Sortir",
	silverstrike_barrage = "Lignes",
	cosmic_barrier = "Barrière",
	voidstalker_sting = "Piqûre",
	aspect_of_the_end = "Liens",
	devouring_cosmos = "Prochaine plateforme",
})
