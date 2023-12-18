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
	L.umbral_destruction = "Soak"
	L.heart_stopper = "Heal Absorbs"
	L.heart_stopper_single = "Heal Absorb"
end

L = BigWigs:NewBossLocale("Volcoross", "frFR")
if L then
	L.custom_off_all_scorchtail_crash = "Afficher toutes les incantations"
	L.custom_off_all_scorchtail_crash_desc = "Afficher les timers et les messages pour tous les impacts de Brûlequeue au lieu d'afficher uniquement ceux de votre côté."

	L.flood_of_the_firelands = "Soaks"
	L.flood_of_the_firelands_single_wait = "Attendez" -- Wait 3, Wait 2, Wait 1 countdown before soak debuff is applied
	L.flood_of_the_firelands_single = "Soak"
	L.scorchtail_crash = "Coup de queue"
	L.serpents_fury = "Flammes"
	L.coiling_flames_single = "Flamme"
end

L = BigWigs:NewBossLocale("Council of Dreams", "frFR")
if L then
	--L.agonizing_claws_debuff = "{421022} (Debuff)"

	--L.ultimate_boss = "Ultimate (%s)"
	--L.special_bar = "Ult [%s] (%d)"
	--L.special_mythic_bar = "Ult [%s/%s] (%d)"
	--L.special_mechanic_bar = "%s [Ult] (%d)"

	L.poisonous_javelin = "Javelot"
	L.song_of_the_dragon = "Chant"
	L.polymorph_bomb = "Canards"
	L.polymorph_bomb_single = "Canard"
end

L = BigWigs:NewBossLocale("Larodar, Keeper of the Flame", "frFR")
if L then
	--L.custom_on_repeating_yell_smoldering_suffocation = "Repeating Suffocation Health Yell"
	--L.custom_on_repeating_yell_smoldering_suffocation_desc = "Repeating yell messages for Smoldering Suffocation to let others know when you are below 75% health."

	L.blazing_coalescence_on_player_note = "Lorsque c'est sur vous"
	L.blazing_coalescence_on_boss_note = "Lors que c'est sur le boss"

	L.scorching_roots = "Enracinements"
	--L.charred_brambles = "Roots Healable"
	--L.blazing_thorns = "Spiral of Eruptions"
	L.falling_embers = "Soaks"
	L.flash_fire = "Heal Absorbs"
	L.flash_fire_single = "Heal Absorb"
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
	L.suppressive_ember = "Heal Absorbs"
	L.suppressive_ember_single = "Heal Absorb"
	L.flare_bomb = "Plumes"
end

L = BigWigs:NewBossLocale("Fyrakk the Blazing", "frFR")
if L then
	L.spirits_trigger = "Esprit des Kaldorei"

	L.fyralaths_bite = "Frontal"
	L.fyralaths_bite_mythic = "Frontals"
	L.fyralaths_mark = "Marque"
	L.darkflame_shades = "Ombres"
	L.darkflame_cleave = "Mythique Soaks"

	L.incarnate_intermission = "Renversement"

	L.incarnate = "Envole-toi ailleurs"
	--L.molten_gauntlet = "Gauntlet"
	L.mythic_debuffs = "Cages" -- Shadow Cage & Molten Eruption

	L.greater_firestorm_shortened_bar = "Tempête de feu [S]" -- G for Greater
	L.greater_firestorm_message_full = "Tempête de feu [Supérieure]"
	L.eternal_firestorm_shortened_bar = "Tempête de feu [E]" -- E for Eternal
	L.eternal_firestorm_message_full = "Tempête de feu [Éternelle]"

	L.eternal_firestorm_swirl = "Tempête de feu tourbillonnante"
	L.eternal_firestorm_swirl_desc = "Compteur pour les tempêtes de feu tourbillonnantes"
	L.eternal_firestorm_swirl_bartext = "Tourbillons"
end
