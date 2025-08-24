local L = BigWigs:NewBossLocale("Cauldron of Carnage", "ptBR")
if not L then return end
if L then
	L.custom_on_fade_out_bars = "Desvanecer barras"
	L.custom_on_fade_out_bars_desc = "Desvanece as barras do chefe que está fora de alcance."

	L.bomb_explosion = "Explosão da Bomba"
	L.bomb_explosion_desc = "Exibe um cronômetro para a explosão das bombas."

	L.eruption_stomp = "Pisada" -- Abreviação de Pisada Eruptiva
	L.thunderdrum_salvo = "Tamborilar" -- Abreviação de Salva do Tamborilar trovejante

	L.static_charge_high = "%d - Você está se movendo demais"
end

L = BigWigs:NewBossLocale("Rik Reverb", "ptBR")
if L then
	L.amplification = "Amplificadores"
	L.echoing_chant = "Ecos"
	L.faulty_zap = "Zap"
	L.sparkblast_ignition = "Barris"
end

L = BigWigs:NewBossLocale("Stix Bunkjunker", "ptBR")
if L then
	L.rolled_on_you = "%s rolou sobre VOCÊ" -- PlayerX rolou sobre você
	L.rolled_from_you = "Rolou sobre %s" -- (você) rolou sobre PlayerX
	L.garbage_dump_message = "VOCÊ atingiu o CHEFE por %s"

	L.electromagnetic_sorting = "Classificação" -- Abreviação de Electromagnetic Sorting
	L.muffled_doomsplosion = "Bomba abafada"
	L.short_fuse = "Explosão da Bomba"
	L.incinerator = "Círculos de Fogo"
end

L = BigWigs:NewBossLocale("Sprocketmonger Lockenstock", "ptBR")
if L then
	L.foot_blasters = "Minas"
	L.unstable_shrapnel = "Mina Soak"
	L.screw_up = "Brocas"
	L.screw_up_single = "Broca" -- Singular de Brocas
	L.sonic_ba_boom = "Dano em Massa"
	L.polarization_generator = "Cores"

	L.polarization_soon = "Cor em breve: %s"
	L.polarization_soon_change = "TROCA de cor em breve: %s"

	L.activate_inventions = "Ativar: %s"
	L.blazing_beam = "Feixes"
	L.rocket_barrage = "Foguetes"
	L.mega_magnetize = "Ímãs"
	L.jumbo_void_beam = "Feixes Gigantes"
	L.void_barrage = "Esferas"
	L.everything = "Tudo"

	L.under_you_comment = "Debaixo de Você" -- Indica que esta configuração é para dano de área sob o jogador
end

L = BigWigs:NewBossLocale("The One-Armed Bandit", "ptBR")
if L then
	--L.rewards = "Prizes" -- Fabulous Prizes
	L.rewards_desc = "Quando dois Tokens são travados, o \"Prêmio Fabuloso\" é concedido.\nMensagens informarão qual prêmio foi obtido.\nA caixa de informações mostrará quais prêmios ainda estão disponíveis."
	L.deposit_time = "Tempo para entregar fichas:" -- Tempo restante para depositar as fichas

	L.pay_line = "Moedas"
	L.shock = "Choque"
	L.flame = "Chama"
	L.coin = "Moeda"

	L.withering_flames = "Chamas" -- Abreviação de Chamas Fenecentes

	L.cheat = "Ativar: %s" -- Trapacear: Bobinas, Trapacear: Debuffs, Trapacear: Dano em Massa, Trapacear: Lançamento Final
	L.linked_machines = "Bobinas"
	L.linked_machine = "Bobina" -- Singular de Bobinas
	L.hot_hot_heat = "Debuffs Fogo"
	L.explosive_jackpot = "Cast Final"
end

L = BigWigs:NewBossLocale("Mug'Zee, Heads of Security", "ptBR")
if L then
	L.earthshaker_gaol = "Prisões"
	L.frostshatter_boots = "Botas Gélidas" -- Abreviação de Botas Estilhagelo
	L.frostshatter_spear = "Lanças Gélidas" -- Abreviação de Lança Estilhagelo
	L.stormfury_finger_gun = "Pistola de Raios" -- Abreviação de Arma de Dedo da Fúria da Tempestade
	L.molten_gold_knuckles = "Ataque Frontal do Tank"
	L.unstable_crawler_mines = "Minas"
	L.goblin_guided_rocket = "Foguete"
	L.double_whammy_shot = "Soak do Tank"
	L.electro_shocker = "Eletrochoque"
end

L = BigWigs:NewBossLocale("Chrome King Gallywix", "ptBR")
if L then
	L.story_phase_trigger = "Tá achando que ganhou?" -- Tá achando que ganhou? Não. Tenho mais uma coisinha pra você.

	L.scatterblast_canisters = "Soak em Cone"
	L.fused_canisters = "Soak em Grupo"
	L.tick_tock_canisters = "Soaks"
	L.total_destruction = "DESTRUIÇÃO!"

	L.duds = "FALH-4" -- Abreviação de Bomba FALH-4 de 700kg
	L.all_duds_detontated = "Todas as Bombas FALH-4 detonadas"
	L.duds_remaining = "%d |FALH-4 restante:FALH-4 restantes;" -- 1 FALH-4 restante | 2 FALH-4 restante
	L.duds_soak = "Absorver FALH-4 (%d restantes)"
end
