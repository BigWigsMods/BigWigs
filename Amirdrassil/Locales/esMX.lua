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
	L.umbral_destruction = "Soak"
	L.heart_stopper = "Absorciones de sanación"
	L.heart_stopper_single = "Absorcion de sanación"
end

L = BigWigs:NewBossLocale("Volcoross", "esMX")
if L then
	L.custom_off_all_scorchtail_crash = "Mostrar todos los lanzamientos"
	L.custom_off_all_scorchtail_crash_desc = "Mostrar temporizadores y mensajes para todos los lanzamientos de Choque Abrasacola en lugar de solo para tu lado."

	L.flood_of_the_firelands = "Soaks"
	L.flood_of_the_firelands_single_wait = "Espera" -- Wait 3, Wait 2, Wait 1 countdown before soak debuff is applied
	L.flood_of_the_firelands_single = "Soak"
	L.scorchtail_crash = "Golpe de Cola"
	L.serpents_fury = "Llamas"
	L.coiling_flames_single = "Llamas"
end

L = BigWigs:NewBossLocale("Council of Dreams", "esMX")
if L then
	L.agonizing_claws_debuff = "{421022} (Perjuicio)"

	L.ultimate_boss = "Definitiva (%s)"
	L.special_bar = "Def [%s] (%d)"
	L.special_mythic_bar = "Def [%s/%s] (%d)"
	L.special_mechanic_bar = "%s [Def] (%d)"

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
	L.blazing_thorns = "Esquivas"
	L.falling_embers = "Soaks"
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
	L.suppressive_ember = "Absorciones de sanación"
	L.suppressive_ember_single = "Absorcion de sanación"
	L.flare_bomb = "Plumas"
end

L = BigWigs:NewBossLocale("Fyrakk the Blazing", "esMX")
if L then
	L.spirits_trigger = "Espíritu de los kaldorei"

	L.fyralaths_bite = "Frontal"
	L.fyralaths_bite_mythic = "Frontales"
	L.fyralaths_mark = "Marca"
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

	L.eternal_firestorm_swirl = "Remolinos de Tormenta de Fuego eterna"
	L.eternal_firestorm_swirl_desc = "Temporizadores para los Remolinos de Tormenta de Fuego eterna."
	L.eternal_firestorm_swirl_bartext = "Remolinos"
end
