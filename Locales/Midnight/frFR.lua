-- March on Quel'Danas

BigWigsAPI.SetBossModuleLocale("Belo'ren, Child of Al'ar", {
	color_swaps = "Changements de couleur",
	["1241292"] = "Plongeon Lumineux / Vide",
})

BigWigsAPI.SetBossModuleLocale("Midnight Falls", {
	deaths_dirge = "Jeu de mémoire",
	heavens_glaives = "Glaives",
	heavens_lance = "Lance",
	the_dark_archangel = "Gros Boom",
	prism_kicks = "Kicks",
	dark_constellation = "Étoiles",
	dark_rune_bar = "Résoudre le Jeu",

	left = "[G] %s", -- left/west group bars in p3
	right = "[D] %s", -- right/east group bars in p3

	custom_select_limit_warnings = "[Mythique] Restreindre les avertissements de P3",
	custom_select_limit_warnings_desc = "N'afficher que les avertissements de sorts de votre côté.",
	custom_select_limit_warnings_value1 = "Groupes 1 & 2 à gauche, groupes 3 & 4 à droite.",
	custom_select_limit_warnings_value2 = "Groupes impaires à gauche, groupes paires à droite.",
	custom_select_limit_warnings_value3 = "Afficher les avertissements des deux côtés.",
	custom_select_limit_warnings_value4 = "N'afficher que les avertissements du côté gauche.",
	custom_select_limit_warnings_value5 = "N'afficher que les avertissements du côté droit.",
})

-- Midnight World

BigWigsAPI.SetBossModuleLocale("Thorm'belan", {
	ball = "Balle",
	ball_incoming = "Arrivée de la balle - Ne la laissez pas toucher le sol",
	ball_fail = "ECHEC - La balle a touché le sol",
	tendrils = "Vrilles",
	tendrils_incoming = "COURREZ pour casser les vrilles",
})

-- The Voidspire

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
