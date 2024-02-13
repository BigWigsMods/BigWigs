local L = BigWigs:NewBossLocale("Gnarlroot", "esMX")
if not L then return end
if L then
	L.tortured_scream = "Grito"
end

L = BigWigs:NewBossLocale("Igira the Cruel", "esMX")
if L then
	L.blistering_spear = "Lanzas"
	L.blistering_spear_single = "Lanza"
	L.blistering_torment = "Cadena"
	L.twisting_blade = "Espadas"
	L.marked_for_torment = "Tormento"
end

L = BigWigs:NewBossLocale("Volcoross", "esMX")
if L then
	L.custom_off_all_scorchtail_crash = "Mostrar todos los lanzamientos"
	L.custom_off_all_scorchtail_crash_desc = "Mostrar temporizadores y mensajes para todos los lanzamientos de Choque Abrasacola en lugar de solo para tu lado."

	L.flood_of_the_firelands_single_wait = "Espera" -- Wait 3, Wait 2, Wait 1 countdown before soak debuff is applied
	L.scorchtail_crash = "Golpe de Cola"
	L.serpents_fury = "Llamas"
	L.coiling_flames_single = "Llamas"
end

L = BigWigs:NewBossLocale("Council of Dreams", "esMX")
if L then
	L.agonizing_claws_debuff = "{421022} (Perjuicio)"

	--L.custom_off_combined_full_energy = "Combined Full Energy Bars (Mythic only)"
	--L.custom_off_combined_full_energy_desc = "Combine the bars of the abilities that the bosses use at full energy into one bar, only if they will be cast at the same time."

	L.special_mechanic_bar = "%s [Def] (%d)"

	--L.constricting_thicket = "Vines"
	L.poisonous_javelin = "Jabalina"
	L.song_of_the_dragon = "Canción"
	L.polymorph_bomb = "Patos"
	L.polymorph_bomb_single = "Pato"
end

L = BigWigs:NewBossLocale("Larodar, Keeper of the Flame", "esMX")
if L then
	L.custom_on_repeating_yell_smoldering_suffocation = "Repetición de Avisos de Salud por Asfixia Humeante"
	L.custom_on_repeating_yell_smoldering_suffocation_desc = "Repetir mensajes de aviso para Asfixia Humeante para informar a los demás cuando estás por debajo del 75% de salud."

	L.blazing_coalescence_on_player_note = "Cuando está en ti"
	L.blazing_coalescence_on_boss_note = "Cuando está en el jefe"

	L.scorching_roots = "Raíces"
	--L.charred_brambles = "Roots Healable"
	--L.blazing_thorns = "Spiral of Thorns"
end

L = BigWigs:NewBossLocale("Nymue, Weaver of the Cycle", "esMX")
if L then
	L.mythic_add_death = "%s Eliminado"

	L.continuum = "Nuevas Lineas"
	L.surging_growth = "Nuevos Soaks"
	L.ephemeral_flora = "Soak Rojo"
	L.viridian_rain = "Daño + Bombas"
	L.threads = "Hilos" -- From the spell description of Impending Loom (429615) "threads of energy"
end

L = BigWigs:NewBossLocale("Smolderon", "esMX")
if L then
	L.brand_of_damnation = "Soak de Tanke"
	L.lava_geysers = "Géiseres"
end

L = BigWigs:NewBossLocale("Tindral Sageswift, Seer of the Flame", "esMX")
if L then
	L.seed_soaked = "Semilla sokeada"
	L.all_seeds_soaked = "Semillas hechas!"

	L.blazing_mushroom = "Hongos"
	L.fiery_growth = "Disipaciones"
	L.mass_entanglement = "Raíces"
	L.incarnation_moonkin = "Forma de lechúcico lunar"
	L.incarnation_tree_of_flame = "Forma de Árbol"
	L.flaming_germination = "Semillas"
	L.flare_bomb = "Plumas"
	--L.too_close_to_edge = "Too close to the edge"
	--L.taking_damage_from_edge = "Taking damage from the edge"
	--L.flying_available = "You can fly now"

	--L.fly_time = "Fly Time"
	--L.fly_time_desc = "Display a message showing you how long you took to fly over to the other platform in the intermissions."
	--L.fly_time_msg = "Fly Time: %.2f" -- Fly Time: 32.23
end

L = BigWigs:NewBossLocale("Fyrakk the Blazing", "esMX")
if L then
	L.spirits_trigger = "Espíritu de los kaldorei"

	L.fyralaths_bite = "Frontal"
	L.fyralaths_bite_mythic = "Frontales"
	L.darkflame_shades = "Sombras"
	L.darkflame_cleave = "Soaks Míticos"

	L.incarnate_intermission = "Salto"

	L.incarnate = "Volar Lejos"
	L.molten_gauntlet = "Guantelete"
	L.mythic_debuffs = "Jaulas" -- Shadow Cage & Molten Eruption

	L.greater_firestorm_shortened_bar = "Tormenta de fuego [S]" -- S for Greater (Superior)
	L.greater_firestorm_message_full = "Tormenta de fuego [Superior]"
	L.eternal_firestorm_shortened_bar = "Tormenta de fuego [E]" -- E for Eternal (Eterna)
	L.eternal_firestorm_message_full = "Tormenta de fuego [Eterna]"

	--L.eternal_firestorm_swirl = "Eternal Firestorm Pools"
	--L.eternal_firestorm_swirl_desc = "Show timers for when the Eternal Firestorm will spawn the pools that you need to avoid standing in."

	--L.flame_orb = "Flame Orb"
	--L.shadow_orb = "Shadow Orb"
	--L.orb_message_flame = "You are Flame"
	--L.orb_message_shadow = "You are Shadow"
end
