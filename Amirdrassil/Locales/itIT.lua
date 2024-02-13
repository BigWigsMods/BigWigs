local L = BigWigs:NewBossLocale("Gnarlroot", "itIT")
if not L then return end
if L then
	L.tortured_scream = "Urlo Torturato"
end

L = BigWigs:NewBossLocale("Igira the Cruel", "itIT")
if L then
	L.blistering_spear = "Lance"
	L.blistering_spear_single = "Lancia"
	L.blistering_torment = "Catena"
	L.twisting_blade = "Lame"
	L.marked_for_torment = "Tormento"
end

L = BigWigs:NewBossLocale("Volcoross", "itIT")
if L then
	L.custom_off_all_scorchtail_crash = "Mostra tutti i lanci"
	L.custom_off_all_scorchtail_crash_desc = "Mostra cronometri e messaggi per tutti i lanci di Schianto di Codarsa invece che quelli solo dalla tua parte."

	L.flood_of_the_firelands_single_wait = "Aspetta" -- Wait 3, Wait 2, Wait 1 countdown before soak debuff is applied
	L.scorchtail_crash = "Schianto di Codarsa"
	L.serpents_fury = "Fiamme"
	L.coiling_flames_single = "Fiamme"
end

L = BigWigs:NewBossLocale("Council of Dreams", "itIT")
if L then
	L.agonizing_claws_debuff = "{421022} (Debuff)"

	L.custom_off_combined_full_energy = "Barre delle piene combinate (Solo mitico)"
	L.custom_off_combined_full_energy_desc = "Combina le barre delle abilità che i boss usano a piena energia in una sola barra, solo se le lanciano contemporaneamente."

	L.special_mechanic_bar = "%s [Ulti] (%d)"

	L.constricting_thicket = "Viticci"
	L.poisonous_javelin = "Giavellotto"
	L.song_of_the_dragon = "Canzone"
	L.polymorph_bomb = "Papere"
	L.polymorph_bomb_single = "Papera"
end

L = BigWigs:NewBossLocale("Larodar, Keeper of the Flame", "itIT")
if L then
	L.custom_on_repeating_yell_smoldering_suffocation = "Ripeti soffocamento della Vita in Urla"
	L.custom_on_repeating_yell_smoldering_suffocation_desc = "Ripeti i messaggi in urla per soffocamento Infuocato per far sapere agli altri quando sei sotto il 75% di vita."

	L.blazing_coalescence_on_player_note = "Quando è su di te"
	L.blazing_coalescence_on_boss_note = "Quando è sul boss"

	L.scorching_roots = "Radici"
	L.charred_brambles = "Radici curabili"
	L.blazing_thorns = "Spine Fiammeggianti"
end

L = BigWigs:NewBossLocale("Nymue, Weaver of the Cycle", "itIT")
if L then
	L.mythic_add_death = "%s Ucciso"

	L.continuum = "Nuove linee"
	L.surging_growth = "Nuovi assorbimenti"
	L.ephemeral_flora = "Assorbimento rosso"
	L.viridian_rain = "Danno+bombe"
	L.threads = "Fili" -- From the spell description of Impending Loom (429615) "threads of energy"
end

L = BigWigs:NewBossLocale("Smolderon", "itIT")
if L then
	L.brand_of_damnation = "Assorbimento del tank"
	L.lava_geysers = "Geysers"
end

L = BigWigs:NewBossLocale("Tindral Sageswift, Seer of the Flame", "itIT")
if L then
	L.seed_soaked = "Seme assorbito"
	L.all_seeds_soaked = "Semi fatti!"

	L.blazing_mushroom = "Funghi"
	L.fiery_growth = "Dissipa"
	L.mass_entanglement = "Radici"
	L.incarnation_moonkin = "Forma di Lunagufo"
	L.incarnation_tree_of_flame = "Forma albero"
	L.flaming_germination = "Semi"
	L.flare_bomb = "Piume"
	L.too_close_to_edge = "Troppo vicino al bordo"
	L.taking_damage_from_edge = "Prendendo danno dal bordo"
	L.flying_available = "Adesso puoi volare"

	L.fly_time = "Tempo di volo"
	L.fly_time_desc = "Mostra un messaggio che dice quanto ci hai messo ad arrivare sull'altra piattaforma nelle interfasi."
	L.fly_time_msg = "Tempo in volo: %.2f" -- Fly Time: 32.23
end

L = BigWigs:NewBossLocale("Fyrakk the Blazing", "itIT")
if L then
	L.spirits_trigger = "Spirito dei Kaldorei"

	L.fyralaths_bite = "Frontale"
	L.fyralaths_bite_mythic = "Frontali"
	L.darkflame_shades = "Ombre"
	L.darkflame_cleave = "Assorbimenti mitici"

	L.incarnate_intermission = "Sbalzo"

	L.incarnate = "Vola via"
	L.molten_gauntlet = "Guanto lungo fuso"
	L.mythic_debuffs = "Gabbie" -- Shadow Cage & Molten Eruption

	L.greater_firestorm_shortened_bar = "Tempesta di fuoco [S]" -- G for Greater
	L.greater_firestorm_message_full = "Tempesta di fuoco [Superiore]"
	L.eternal_firestorm_shortened_bar = "Tempesta di fuoco [E]" -- E for Eternal
	L.eternal_firestorm_message_full = "Tempesta di fuoco [Eterna]"

	L.eternal_firestorm_swirl = "Pozzo di Tempesta di fuoco eterna"
	L.eternal_firestorm_swirl_desc = "Mostra i timer per quando le tempeste di fuoco eterne rilasceranno le pozze da evitare."

	--L.flame_orb = "Flame Orb"
	--L.shadow_orb = "Shadow Orb"
	--L.orb_message_flame = "You are Flame"
	--L.orb_message_shadow = "You are Shadow"
end
