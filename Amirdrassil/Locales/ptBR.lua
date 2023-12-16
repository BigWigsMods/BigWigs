local L = BigWigs:NewBossLocale("Gnarlroot", "ptBR")
if not L then return end
if L then
	L.tortured_scream = "Grito"
end

L = BigWigs:NewBossLocale("Igira the Cruel", "ptBR")
if L then
	L.blistering_spear = "Lanças"
	L.blistering_spear_single = "Lança"
	L.blistering_torment = "Corrente"
	L.twisting_blade = "Lâminas"
	L.marked_for_torment = "Tormento"
	L.umbral_destruction = "Soak"
	L.heart_stopper = "Absorção de Cura"
	L.heart_stopper_single = "Absorção de Cura"
end

L = BigWigs:NewBossLocale("Volcoross", "ptBR")
if L then
	L.custom_off_all_scorchtail_crash = "Mostrar Todas as Conjurações"
	L.custom_off_all_scorchtail_crash_desc = "Mostra temporizadores e mensagens para todas as conjurações de Colisão de Escauda em vez de apenas para o seu lado."

	L.flood_of_the_firelands = "Soaks"
	L.flood_of_the_firelands_single_wait = "Aguarde" -- Aguarde 3, Aguarde 2, Aguarde 1 contagem regressiva antes que o debuff de absorção seja aplicado
	L.flood_of_the_firelands_single = "Soak"
	L.scorchtail_crash = "Impacto da Cauda"
	L.serpents_fury = "Chamas"
	L.coiling_flames_single = "Chama"
end

L = BigWigs:NewBossLocale("Council of Dreams", "ptBR")
if L then
	L.agonizing_claws_debuff = "{421022} (Debuff)"

	L.ultimate_boss = "Supremo (%s)"
	L.special_bar = "Supremo [%s] (%d)"
	L.special_mythic_bar = "Supremo [%s/%s] (%d)"
	L.special_mechanic_bar = "%s [Supremo] (%d)"

	L.poisonous_javelin = "Zagaia"
	L.song_of_the_dragon = "Canção"
	L.polymorph_bomb = "Patos"
	L.polymorph_bomb_single = "Pato"
end

L = BigWigs:NewBossLocale("Larodar, Keeper of the Flame", "ptBR")
if L then
	L.custom_on_repeating_yell_smoldering_suffocation = "Yell Repetido para Sufocação Ardente"
	L.custom_on_repeating_yell_smoldering_suffocation_desc = "Mensagens repetidas de yell para Sufocação Fumegante, para informar aos outros quando você estiver abaixo de 75% de vida."

	L.blazing_coalescence_on_player_note = "Quando estiver em você"
	L.blazing_coalescence_on_boss_note = "Quando estiver no chefe"

	L.scorching_roots = "Raízes"
	L.blazing_thorns = "Esquivar"
	L.falling_embers = "Soaks"
end

L = BigWigs:NewBossLocale("Nymue, Weaver of the Cycle", "ptBR")
if L then
	L.mythic_add_death = "%s Morto"

	L.continuum = "Novas Linhas"
	L.surging_growth = "Novos soaks"
	L.ephemeral_flora = "Soak Vermelho"
	L.viridian_rain = "Dano + Bombas"
	L.threads = "Fios" -- Da descrição do feitiço Fiação Manifesta (429615) "fios de energia"
end

L = BigWigs:NewBossLocale("Smolderon", "ptBR")
if L then
	L.brand_of_damnation = "Soak do Tank"
	L.lava_geysers = "Gêiseres"
end

L = BigWigs:NewBossLocale("Tindral Sageswift, Seer of the Flame", "ptBR")
if L then
	L.seed_soaked = "Semente feita"
	L.all_seeds_soaked = "Sementes Concluídas!"
	L.blazing_mushroom = "Cogumelos"
	L.fiery_growth = "Dissipar"
	L.mass_entanglement = "Raízes"
	L.incarnation_moonkin = "Forma de Luniscante"
	L.incarnation_tree_of_flame = "Forma de Árvore"
	L.flaming_germination = "Sementes"
	L.suppressive_ember = "Absorção de Cura"
	L.suppressive_ember_single = "Absorção de Cura"
	L.flare_bomb = "Penas"
end

L = BigWigs:NewBossLocale("Fyrakk the Blazing", "ptBR")
if L then
	L.spirits_trigger = "Espírito dos Kaldorei"

	L.fyralaths_bite = "Frontal"
	L.fyralaths_bite_mythic = "Frontais"
	L.fyralaths_mark = "Marca"
	L.darkflame_shades = "Sombras"
	L.darkflame_cleave = "Soaks Míticos"

	L.incarnate_intermission = "Empurrão pra Cima"

	L.incarnate = "Voar para Longe"
	L.molten_gauntlet = "Manopla"
	L.mythic_debuffs = "Gaiolas" -- Gaiola Sombria e Erupção Derretida

	L.greater_firestorm_shortened_bar = "Tempestade de Fogo [G]" -- G de Grande
	L.greater_firestorm_message_full = "Tempestade de Fogo [Grande]"
	L.eternal_firestorm_shortened_bar = "Tempestade de Fogo [E]" -- E de Eterna
	L.eternal_firestorm_message_full = "Tempestade de Fogo [Eterna]"

	L.eternal_firestorm_swirl = "Pezinho Tempestade de Fogo Eterna"
	L.eternal_firestorm_swirl_desc = "Temporizadores para Pezinhos da Tempestade de Fogo Eterna."
	L.eternal_firestorm_swirl_bartext = "Pezinho"
end
