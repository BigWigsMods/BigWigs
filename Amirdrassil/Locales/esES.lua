local L = BigWigs:NewBossLocale("Gnarlroot", "esES")
if not L then return end
if L then
	L.tortured_scream = "Grito de Tortura"
end

L = BigWigs:NewBossLocale("Igira the Cruel", "esES")
if L then
	L.blistering_spear = "Lanzas"
	L.blistering_spear_single = "Lanza"
	L.blistering_torment = "Cadena"
	L.twisting_blade = "Espadas"
	L.marked_for_torment = "Tormento"
end

L = BigWigs:NewBossLocale("Volcoross", "esES")
if L then
	L.custom_off_all_scorchtail_crash = "Enseñar todos los lanzamientos"
	L.custom_off_all_scorchtail_crash_desc = "Enseñar temporizadores y mensajes para todos los lanzamientos de Choque Abrasacola en vez de solo los de tu lado."

	L.flood_of_the_firelands_single_wait = "Espera" -- Wait 3, Wait 2, Wait 1 countdown before soak debuff is applied
	L.scorchtail_crash = "Golpe de Cola"
	L.serpents_fury = "Llamas"
	L.coiling_flames_single = "Llamas"
end

L = BigWigs:NewBossLocale("Council of Dreams", "esES")
if L then
	L.agonizing_claws_debuff = "{421022} (Perjuicio)"

	L.custom_off_combined_full_energy = "Barras de Energia Completamente Combinadas (Solo Mítico)"
	L.custom_off_combined_full_energy_desc = "Combinar las barras de las habilidades que los jefes usan a plena energía en una unica barra, solo si se van a lanzar a la vez."

	L.special_mechanic_bar = "%s [Def] (%d)" -- Def is used for "Definitiva"

	L.constricting_thicket = "Matorral"
	L.poisonous_javelin = "Jabalina"
	L.song_of_the_dragon = "Canción"
	L.polymorph_bomb = "Patos"
	L.polymorph_bomb_single = "Pato"
end

L = BigWigs:NewBossLocale("Larodar, Keeper of the Flame", "esES")
if L then
	L.custom_on_repeating_yell_smoldering_suffocation = "Repitiendo Aviso de Salud de Asfixia Humeante"
	L.custom_on_repeating_yell_smoldering_suffocation_desc = "Repitiendo Aviso por Asfixia Humeante para informar al resto que estar por debajo del 75% de salud"

	L.blazing_coalescence_on_player_note = "Cuando esta en ti"
	L.blazing_coalescence_on_boss_note = "Cuando esta en el boss"

	L.scorching_roots = "Raíces"
	L.charred_brambles = "Raíces Curables"
	L.blazing_thorns = "Espinas llameantes"
end

L = BigWigs:NewBossLocale("Nymue, Weaver of the Cycle", "esES")
if L then
	L.mythic_add_death = "%s Muerto"

	L.continuum = "Nuevas Lineas"
	L.surging_growth = "Nuevos Soaks"
	L.ephemeral_flora = "Soak Rojo"
	L.viridian_rain = "Daño + Bombas"
	L.threads = "Hilos" -- From the spell description of Impending Loom (429615) "threads of energy"
end

L = BigWigs:NewBossLocale("Smolderon", "esES")
if L then
	L.brand_of_damnation = "Sokeo de Tanque"
	L.lava_geysers = "Géiseres"
end

L = BigWigs:NewBossLocale("Tindral Sageswift, Seer of the Flame", "esES")
if L then
	L.seed_soaked = "Semilla soakeada"
	L.all_seeds_soaked = "Semillas acabadas!"

	L.blazing_mushroom = "Hongos"
	L.fiery_growth = "Disipaciones"
	L.mass_entanglement = "Raíces"
	L.incarnation_moonkin = "Forma de lechúcico lunar"
	L.incarnation_tree_of_flame = "Forma de antárbol"
	L.flaming_germination = "Semillas"
	L.flare_bomb = "Plumas"
	L.too_close_to_edge = "Demasiado cerca del borde"
	L.taking_damage_from_edge = "Recibiendo daño del borde"
	L.flying_available = "Puedes volar ahora"

	--L.fly_time = "Fly Time"
	--L.fly_time_desc = "Display a message showing you how long you took to fly over to the other platform in the intermissions."
	--L.fly_time_msg = "Fly Time: %.2f" -- Fly Time: 32.23
end

L = BigWigs:NewBossLocale("Fyrakk the Blazing", "esES")
if L then
	L.spirits_trigger = "Espíritu de los kaldorei"

	L.fyralaths_bite = "Frontal"
	L.fyralaths_bite_mythic = "Frontales"
	L.darkflame_shades = "Sombras"
	L.darkflame_cleave = "Soaks de Mítico"

	L.incarnate_intermission = "Empuje hacia arriba"

	L.incarnate = "Salto al cielo"
	L.molten_gauntlet = "Guantelete"
	L.mythic_debuffs = "Jaulas" -- Shadow Cage & Molten Eruption

	L.greater_firestorm_shortened_bar = "Tormenta de fuego [S]" -- S for "Superior"
	L.greater_firestorm_message_full = "Tormenta de fuego [Superior]"
	L.eternal_firestorm_shortened_bar = "Tormenta de fuego [E]" -- E for "Eterna"
	L.eternal_firestorm_message_full = "Tormenta de fuego [Eterna]"

	--L.eternal_firestorm_swirl = "Eternal Firestorm Pools"
	--L.eternal_firestorm_swirl_desc = "Show timers for when the Eternal Firestorm will spawn the pools that you need to avoid standing in."

	--L.flame_orb = "Flame Orb"
	--L.shadow_orb = "Shadow Orb"
	--L.orb_message_flame = "You are Flame"
	--L.orb_message_shadow = "You are Shadow"
end
