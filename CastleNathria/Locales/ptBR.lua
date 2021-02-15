local L = BigWigs:NewBossLocale("Shriekwing", "ptBR")
if not L then return end
if L then
	L.pickup_lantern = "%s pegou a lanterna!"
	L.dropped_lantern = "Lanterna derrubada por %s!"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "ptBR")
if L then
	L.killed = "%s Morto"
end

L = BigWigs:NewBossLocale("Sun King's Salvation", "ptBR")
if L then
	L.shield_removed = "%s removido depois de %.1fs" -- "Shield removed after 1.1s" s = seconds
	L.shield_remaining = "%s restante: %s (%.1f%%)" -- "Shield remaining: 2.1K (5.3%)"
end

L = BigWigs:NewBossLocale("Hungering Destroyer", "ptBR")
if L then
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	L.custom_on_repeating_yell_miasma = "Repetir grito da quantidade de vida com Miasma"
	L.custom_on_repeating_yell_miasma_desc = "Mensagens gritadas repetitivas para o Miasma, para ajudar os outros saberem quando você está abaixo de 75% de vida."

	L.custom_on_repeating_say_laser = "Repetir dizer Ejeção Volátil"
	L.custom_on_repeating_say_laser_desc = "Mensagens ditas repetitivas para Ejeção Volátil, para ajudar os outros a se moverem."

	L.tempPrint = "Nós adicionamos gritos de vida para o Miasma. Se você antes usava uma WeakAura para isso, você pode querer exclui-la para prevenir gritos duplos."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "ptBR")
if L then
	L.tear = "Rasgo" -- Short for Dimensional Tear
	L.spirits = "Espíritos" -- Short for Fleeting Spirits
	L.seeds = "Sementes" -- Short for Seeds of Extinction
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "ptBR")
if L then
	L.times = "%dx %s"

	L.level = "%s (Nível |cffffff00%d|r)"
	L.full = "%s (|cffff0000CHEIO|r)"

	L.anima_adds = "Adds da Ânima Concentrada"
	L.anima_adds_desc = "Mostra um temporizador para quando os adds surgem dos debuffs de Ânima Concentrada."

	L.custom_off_experimental = "Habilitar funcionalidades experimentais"
	L.custom_off_experimental_desc = "Essas funcionalidades |cffff0000não foram testadas|r e podem causar |cffff0000spam|r."

	L.anima_tracking = "Rastreamento de Ânima |cffff0000(Experimental)|r"
	L.anima_tracking_desc = "Mensagens e barras para rastrear os níveis de ânima nos contêiners.|n|cffaaff00Dica: Você pode desativar a caixa de informação ou as barras, dependendo da sua preferência."

	L.custom_on_stop_timers = "Sempre mostrar as barras de habilidade"
	L.custom_on_stop_timers_desc = "Somente para testes por enquanto"

	L.desires = "Desejos"
	L.bottles = "Garrafas"
	L.sins = "Pecados"
end

L = BigWigs:NewBossLocale("The Council of Blood", "ptBR")
if L then
	L.macabre_start_emote = "Assumam seus lugares na Dança Macabra!" -- [RAID_BOSS_EMOTE] Take your places for the Danse Macabre!#Dance Controller#4#false"
	L.custom_on_repeating_dark_recital = "Repetir Recital Sombrio"
	L.custom_on_repeating_dark_recital_desc = "Repetir Recital Sombrio diz mensagens com ícones {rt1}, {rt2} para encontrar seu parceiro de dança."

	L.custom_off_select_boss_order = "Marcar ordem de chefes"
	L.custom_off_select_boss_order_desc = "Marca a ordem que a raide usará pra matar os chefes com uma cruz {rt7}. Requer líder de raide ou assistente para marcar."
	L.custom_off_select_boss_order_value1 = "Niklaus -> Frieda -> Stavros"
	L.custom_off_select_boss_order_value2 = "Frieda -> Niklaus -> Stavros"
	L.custom_off_select_boss_order_value3 = "Stavros -> Niklaus -> Frieda"
	L.custom_off_select_boss_order_value4 = "Niklaus -> Stavros -> Frieda"
	L.custom_off_select_boss_order_value5 = "Frieda -> Stavros -> Niklaus"
	L.custom_off_select_boss_order_value6 = "Stavros -> Frieda -> Niklaus"

	L.dance_assist = "Assistente de Dança"
	L.dance_assist_desc = "Mostra avisos direcionais para o estágio da dança."
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t Dance pra Frente |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t Dance pra Direita |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t Dance pra Baixo |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t Dance pra Esquerda |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "Quadril pra frente!" -- Prance Forward!
	L.dance_yell_right = "Requebra pra direita!" -- Shimmy right!
	L.dance_yell_down = "Rebola embaixo!" -- Boogie down!
	L.dance_yell_left = "Quebra pra esquerda!" -- Sashay left!
end

L = BigWigs:NewBossLocale("Sludgefist", "ptBR")
if L then
	L.stomp_shift = "Pisada & Mudança" -- Destructive Stomp + Seismic Shift

	L.fun_info = "Informação de Dano"
	L.fun_info_desc = "Mostra uma mensagem dizendo o quanto de vida o chefe perdeu duarnte o Impacto Destrutivo."

	L.health_lost = "Punholodo perdeu %.1f%%!"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "ptBR")
if L then
	L.first_blade = "Primeira Lâmina"
	L.second_blade = "Segunda Lâmina"

	L.skirmishers = "Escaramuçadores" -- Short for Stone Legion Skirmishers

	L.custom_on_stop_timers = "Sempre mostrar barras de habilidades"
	L.custom_on_stop_timers_desc = "Somente para testes por enquanto"

	L.goliath_short = "Golias"
	L.goliath_desc = "Mostra avisos e temporizadores para quando forem surgir os Golias da Legião de Pedra."

	L.commando_short = "Comando"
	L.commando_desc = "Mostra avisos de quando um Comando da Legião de Pedra é morto."
end

L = BigWigs:NewBossLocale("Sire Denathrius", "ptBR")
if L then
	L.add_spawn = "Cabalistas Carmesim respondem ao chamado de Denathrius." -- [RAID_BOSS_EMOTE] Crimson Cabalists answer the call of Denathrius.#Sire Denathrius#4#true"

	L.infobox_stacks = "%d |4Pilha:Pilhas;: %d |4jogador:jogadores;" -- 4 Stacks: 5 players // 1 Stack: 1 player

	L.custom_on_repeating_nighthunter = "Repetir grito de Caçador Noturno"
	L.custom_on_repeating_nighthunter_desc = "Mensagens gritadas repetitivas para a habilidade Caçador Noturno usando ícones {rt1} ou {rt2} ou {rt3} para encontrar seu alinhamento se você for fazer o soak."

	L.custom_on_repeating_impale = "Repetir dizer Impalado"
	L.custom_on_repeating_impale_desc = "Dizer mensagens repetitivas para a habilidade Impalar, usando '1' ou '22' ou '333' ou '4444' para deixar claro em qual ordem você será acertado."

	L.hymn_stacks = "Hino Nathriano"
	L.hymn_stacks_desc = "Alertas para a quantidade de pilhas de Hino Nathriano que estão em você."

	L.ravage_target = "Reflexão: Barra de Conjuração no Alvo de Assolar"
	L.ravage_target_desc = "Uma barra de conjuração mostrando o tempo até a reflexão marcar a localização para Assolar."
	L.ravage_targeted = "Assolar no Alvo" -- Text on the bar for when Ravage picks its location to target in stage 3

	L.no_mirror = "Sem Espelho: %d" -- Player amount that does not have the Through the Mirror
	L.mirror = "Espelho: %d" -- Player amount that does have the Through the Mirror
end

L = BigWigs:NewBossLocale("Castle Nathria Trash", "ptBR")
if L then
	--[[ Pre Shriekwing ]]--
	L.moldovaak = "Moldovaak"
	L.caramain = "Caraman"
	L.sindrel = "Sindrel"
	L.hargitas = "Hargitas"

	--[[ Shriekwing -> Huntsman Altimor ]]--
	L.gargon = "Gargono Colossal"
	L.hawkeye = "Espia Nathriano"
	L.overseer = "Feitora do Canil"

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	L.feaster = "Devorador Medonho"
	L.rat = "Rato de Tamanho Anormal"
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	L.deplina = "Deplina"
	L.dragost = "Dragost"
	L.kullan = "Kullan"

	--[[ Shriekwing -> Xy'mox ]]--
	L.antiquarian = "Antiquária Sinistra"
	L.conservator = "Conservador Nathriano"
	L.archivist = "Arquivista-chefe Nathriana"

	--[[ Sludgefist -> Stone Legion Generals ]]--
	L.goliath = "Golias da Legião de Pedra"
end
