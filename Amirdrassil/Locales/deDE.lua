local L = BigWigs:NewBossLocale("Gnarlroot", "deDE")
if not L then return end
if L then
	L.tortured_scream = "Schrei"
end

L = BigWigs:NewBossLocale("Igira the Cruel", "deDE")
if L then
	L.blistering_spear = "Speere"
	L.blistering_spear_single = "Speer"
	L.blistering_torment = "Kette"
	L.twisting_blade = "Klingen"
	L.marked_for_torment = "Qualen"
end

L = BigWigs:NewBossLocale("Volcoross", "deDE")
if L then
	L.custom_off_all_scorchtail_crash = "Alle Zauber anzeigen"
	L.custom_off_all_scorchtail_crash_desc = "Zeigt Timer und Nachrichten für alle Zauber von Sengschweifsturz an, statt nur die Zauber auf Deiner Seite."

	L.flood_of_the_firelands_single_wait = "Warten" -- Wait 3, Wait 2, Wait 1 countdown before soak debuff is applied
	L.scorchtail_crash = "Schweifschlag"
	L.serpents_fury = "Flammen"
	L.coiling_flames_single = "Flamme"
end

L = BigWigs:NewBossLocale("Council of Dreams", "deDE")
if L then
	L.agonizing_claws_debuff = "{421022} (Debuff)"

	L.custom_off_combined_full_energy = "Gemeinsame Leisten bei voller Energie (nur Mythisch)"
	L.custom_off_combined_full_energy_desc = "Bündelt die Leisten der Fähigkeiten bei voller Energie in einer Leiste, wenn diese zur gleichen Zeit auftreten."

	L.special_mechanic_bar = "%s [Ult] (%d)"

	L.constricting_thicket = "Ranken"
	L.poisonous_javelin = "Wurfspeer"
	L.song_of_the_dragon = "Lied"
	L.polymorph_bomb = "Enten"
	L.polymorph_bomb_single = "Ente"
end

L = BigWigs:NewBossLocale("Larodar, Keeper of the Flame", "deDE")
if L then
	L.custom_on_repeating_yell_smoldering_suffocation = "Ersticken Gesundheit wiederholen"
	L.custom_on_repeating_yell_smoldering_suffocation_desc = "Gibt wiederholt Chatnachrichten für Qualmendes Ersticken aus um mitzuteilen, dass unter 75% Gesundheit erreicht sind."

	L.blazing_coalescence_on_player_note = "Wenn es auf Dir ist"
	L.blazing_coalescence_on_boss_note = "Wenn es auf dem Boss ist"

	L.scorching_roots = "Wurzeln"
	L.charred_brambles = "Wurzeln heilbar"
	L.blazing_thorns = "Dornenspirale"
end

L = BigWigs:NewBossLocale("Nymue, Weaver of the Cycle", "deDE")
if L then
	L.mythic_add_death = "%s getötet"

	L.continuum = "Neue Fäden"
	L.surging_growth = "Neue Soaks"
	L.ephemeral_flora = "Roter Soak"
	L.viridian_rain = "Schaden + Bomben"
	L.threads = "Fäden" -- From the spell description of Impending Loom (429615) "threads of energy"
end

L = BigWigs:NewBossLocale("Smolderon", "deDE")
if L then
	L.brand_of_damnation = "Tank Soak"
	L.lava_geysers = "Geysire"
end

L = BigWigs:NewBossLocale("Tindral Sageswift, Seer of the Flame", "deDE")
if L then

	L.seed_soaked = "Samen gesoaked"
	L.all_seeds_soaked = "Samen fertig!"

	L.blazing_mushroom = "Pilze"
	L.fiery_growth = "Dispels"
	L.mass_entanglement = "Wurzeln"
	L.incarnation_moonkin = "Mondkingestalt"
	L.incarnation_tree_of_flame = "Treantgestalt"
	L.flaming_germination = "Samen"
	L.flare_bomb = "Federn"
	L.too_close_to_edge = "Zu nah am Rand"
	L.taking_damage_from_edge = "Du kriegst Schaden vom Rand"
	L.flying_available = "Du kannst jetzt fliegen"

	L.fly_time = "Flugdauer"
	L.fly_time_desc = "Zeigt eine Nachricht mit der Dauer des Fluges von einer Plattform zur nächsten in den Zwischenphasen an."
	L.fly_time_msg = "Flugdauer: %.2f" -- Fly Time: 32.23
end

L = BigWigs:NewBossLocale("Fyrakk the Blazing", "deDE")
if L then
	L.spirits_trigger = "Geist der Kaldorei"

	L.fyralaths_bite = "Frontal"
	L.fyralaths_bite_mythic = "Frontals"
	L.darkflame_shades = "Schemen"
	L.darkflame_cleave = "Mythische Soaks"

	L.incarnate_intermission = "Zurückstoßen"

	L.incarnate = "Abheben"
	L.molten_gauntlet = "Fäuste"
	L.mythic_debuffs = "Käfige" -- Shadow Cage & Molten Eruption

	L.greater_firestorm_shortened_bar = "Feuersturm [G]" -- G for Greater
	L.greater_firestorm_message_full = "Feuersturm [Groß]"
	L.eternal_firestorm_shortened_bar = "Feuersturm [E]" -- E for Eternal
	L.eternal_firestorm_message_full = "Feuersturm [Ewig]"

	L.eternal_firestorm_swirl = "Ewiger Feuersturm Wirbel"
	L.eternal_firestorm_swirl_desc = "Zeigt Timer für die Wirbel des Ewigen Feuersturms, denen ausgewichen werden muss."

	L.flame_orb = "Flammenkugel"
	L.shadow_orb = "Schattenkugel"
	L.orb_message_flame = "Du bist Flamme"
	L.orb_message_shadow = "Du bist Schatten"
end
