local L = BigWigs:NewBossLocale("Gnarlroot", "frFR")
if not L then return end
if L then
	L.tortured_scream = "Cri torturé"
end

L = BigWigs:NewBossLocale("Igira the Cruel", "frFR")
if L then
	L.blistering_spear = "Lances"
	L.blistering_spear_single = "Lance"
	L.blistering_torment = "Chaine"
	L.twisting_blade = "Lames"
	L.marked_for_torment = "Tourment"
end

L = BigWigs:NewBossLocale("Volcoross", "frFR")
if L then
	L.custom_off_all_scorchtail_crash = "Afficher toutes les incantations"
	L.custom_off_all_scorchtail_crash_desc = "Afficher les timers et les messages pour tous les impacts de Brûlequeue au lieu d'afficher uniquement ceux de votre côté."

	L.flood_of_the_firelands_single_wait = "Attendez" -- Wait 3, Wait 2, Wait 1 countdown before soak debuff is applied
	L.scorchtail_crash = "Coup de queue"
	L.serpents_fury = "Flammes"
	L.coiling_flames_single = "Flamme"
end

L = BigWigs:NewBossLocale("Council of Dreams", "frFR")
if L then
	L.agonizing_claws_debuff = "{421022} (Affaiblissement)"

	L.custom_off_combined_full_energy = "Toutes les barres d'énergie combinées (seulement en mythique)"
	L.custom_off_combined_full_energy_desc = "Combine les barres d'énergie des techniques que chaque boss utilise en une seule barre, uniquement si les techniques sont lancées en même temps."

	L.special_mechanic_bar = "%s [Ult] (%d)"

	L.constricting_thicket = "Vignes"
	L.poisonous_javelin = "Javelot"
	L.song_of_the_dragon = "Chant"
	L.polymorph_bomb = "Canards"
	L.polymorph_bomb_single = "Canard"
end

L = BigWigs:NewBossLocale("Larodar, Keeper of the Flame", "frFR")
if L then
	L.custom_on_repeating_yell_smoldering_suffocation = "Répéter les messages sur la suffocation ardente"
	L.custom_on_repeating_yell_smoldering_suffocation_desc = "Répète les messages en /crier à propos des suffocations ardentes pour prévenir les autres joueurs quand vous êtes en dessous de 75% de points de vie."

	L.blazing_coalescence_on_player_note = "Lorsque c'est sur vous"
	L.blazing_coalescence_on_boss_note = "Lors que c'est sur le boss"

	L.scorching_roots = "Enracinements"
	L.charred_brambles = "Racines soignables"
	L.blazing_thorns = "Spirale d'épines"
end

L = BigWigs:NewBossLocale("Nymue, Weaver of the Cycle", "frFR")
if L then
	L.mythic_add_death = "%s Tué"

	L.continuum = "Nouvelles lignes"
	L.surging_growth = "Nouveaux Soaks"
	L.ephemeral_flora = "Soak rouge"
	L.viridian_rain = "Dégats + Bombes"
	L.threads = "Fils" -- From the spell description of Impending Loom (429615) "threads of energy"
end

L = BigWigs:NewBossLocale("Smolderon", "frFR")
if L then
	L.brand_of_damnation = "Tank Soak"
	L.lava_geysers = "Geysers"
end

L = BigWigs:NewBossLocale("Tindral Sageswift, Seer of the Flame", "frFR")
if L then
	L.seed_soaked = "Graines soaked"
	L.all_seeds_soaked = "Toutes les graines ont été soaked !"

	L.blazing_mushroom = "Champignons"
	L.fiery_growth = "Dissipations"
	L.mass_entanglement = "Enracinements"
	L.incarnation_moonkin = "Forme de célénien"
	L.incarnation_tree_of_flame = "Forme d'arbre"
	L.flaming_germination = "Graines"
	L.flare_bomb = "Plumes"
	L.too_close_to_edge = "Trop proche du bord"
	L.taking_damage_from_edge = "Prends des dégats du bord"
	L.flying_available = "Vous pouvez maintenant voler"

	L.fly_time = "Temps en vol"
	L.fly_time_desc = "Affiche un message qui indique combien de temps vous avez pris pour voler d'une plateforme à une autre."
	L.fly_time_msg = "Temps en vol : %.2f" -- Fly Time: 32.23
end

L = BigWigs:NewBossLocale("Fyrakk the Blazing", "frFR")
if L then
	L.spirits_trigger = "Esprit des Kaldorei"

	L.fyralaths_bite = "Frontal"
	L.fyralaths_bite_mythic = "Frontals"
	L.darkflame_shades = "Ombres"
	L.darkflame_cleave = "Mythique Soaks"

	L.incarnate_intermission = "Renversement"

	L.incarnate = "Envole-toi ailleurs"
	L.molten_gauntlet = "Gantelet"
	L.mythic_debuffs = "Cages" -- Shadow Cage & Molten Eruption

	L.greater_firestorm_shortened_bar = "Tempête de feu [S]" -- G for Greater
	L.greater_firestorm_message_full = "Tempête de feu [Supérieure]"
	L.eternal_firestorm_shortened_bar = "Tempête de feu [E]" -- E for Eternal
	L.eternal_firestorm_message_full = "Tempête de feu [Éternelle]"

	--L.eternal_firestorm_swirl = "Eternal Firestorm Pools"
	--L.eternal_firestorm_swirl_desc = "Show timers for when the Eternal Firestorm will spawn the pools that you need to avoid standing in."

	--L.flame_orb = "Flame Orb"
	--L.shadow_orb = "Shadow Orb"
	--L.orb_message_flame = "You are Flame"
	--L.orb_message_shadow = "You are Shadow"
end
