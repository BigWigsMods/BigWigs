local L = BigWigs:NewBossLocale("Beth'tilac", "ptBR")
if not L then return end
if L then
	L.flare = GetSpellInfo(100936)
	L.flare_desc = "Mostra uma barra de tempo para o AoE."
	L.devastate_message = "Devastação #%d"
	L.drone_bar = "Soldade de Teia"
	L.drone_message = "Soldado de teia apareceu!"
	L.kiss_message = "Beijo"
	L.spinner_warn = "Tecelã #%d"
end

L = BigWigs:NewBossLocale("Lord Rhyolith", "ptBR")
if L then
	L.armor = "Armadura Obsidiana"
	L.armor_desc = "Avisar quando os stacks de armadura estiverem= desaparecendo do Rhyolith."
	L.armor_message = "%d%% armadura restante"
	L.armor_gone_message = "Armadura destruida!"

	L.adds_header = "Adds"
	L.big_add_message = "Add grande apareceu!"
	L.small_adds_message = "Adds pequenos apareceram!"

	L.phase2_warning = "Fase 2 iminente!"

	L.molten_message = "%dx stacks no chefe!"

	L.stomp_message = "Pisotear! Pisotear! Pisotear!"
	L.stomp = "Pisoteio!"
end

L = BigWigs:NewBossLocale("Alysrazor", "ptBR")
if L then
	L.claw_message = "%2$dx Garras em %1$s"
	L.fullpower_soon_message = "Poder máximo iminente!"
	L.halfpower_soon_message = "Fase 4 iminente!"
	L.encounter_restart = "E lá vamos nós dinovo ..."
	L.no_stacks_message = "Não sei se você se importa, más você não tem nenhuma pena!"
	L.moonkin_message = "Pare de fingir e consiga algumas penas de verdade"
	L.molt_bar = "Próxima Muda"

	L.meteor = "Meteóro"
	L.meteor_desc = "Avisa quando um meteóro de lava é invocado."
	L.meteor_message = "Meteóro!"

	L.stage_message = "Fase %d"
	L.kill_message = "Agora ou nunca - Matem-no!"
	L.engage_message = "Alysrazor iniciado - Fase 2 em ~%d min"

	L.worm_emote = "Vermes de lava ígneos surgiram do solo!"
	L.phase2_soon_emote = "Alysrazor começou a voar rápido em círculos."

	L.flight = "Assistente de vôo"
	L.flight_desc = "Mostra uma barra com a duração das 'Asas de Fogo' em você, é ideal usar isso com a opção de Super Enfatizar."

	L.initiate = "Iniciante apareceu"
	L.initiate_desc = "Mostra contadores para reaparição dos novatos flamejantes."
	L.initiate_both = "Ambos novatos flamejantes"
	L.initiate_west = "Novato Flamejante a Oeste"
	L.initiate_east = "Novato Flamejante a Leste"
end

L = BigWigs:NewBossLocale("Shannox", "ptBR")
if L then
	L.safe = "%s está salvo"
	L.wary_dog = "%s está desconfiado!"
	L.crystal_trap = "Prisão de cristal"

	L.traps_header = "Armadilhas"
	L.immolation = "Armadilha Imolante no cachorro"
	L.immolation_desc = "Alerta quando Face da Fúria pisar numa armadilha imolante, ganhando o bônus 'Desconfiado'."
	L.immolationyou = "Armadilha Imolante debaixo de VOCÊ"
	L.immolationyou_desc = "Alerta quando uma armadilha imolante aparece debaixo de você."
	L.immolationyou_message = "Armadilha Imolante"
	L.crystal = "Armadilha de cristal"
	L.crystal_desc = "Avisa quando Shannox lançar uma armadilha de cristal debaixo de você."
end

L = BigWigs:NewBossLocale("Baleroc", "ptBR")
if L then
	L.torment = "Stack de Tormento no seu Foco"
	L.torment_desc = "Avisa quando seu /foco ganha outro stack de Tormento."

	L.blade_bar = "~Próxima espada"
	L.shard_message = "Fragmento roxo (%d)!"
	L.focus_message = "Seu foco tem %d stacks!"
	L.link_message = "Linkado"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "ptBR")
if L then
	L.seed_explosion = "Você explodirá em instantes!"
	L.seed_bar = "Você explode!"
	L.adrenaline_message = "Adrenalina x%d!"
	L.leap_say = "Salto em MIM!"
end

L = BigWigs:NewBossLocale("Ragnaros", "ptBR")
if L then
	L.intermission_end_trigger1 = "Sulfuras trará sua ruína."
	L.intermission_end_trigger2 = "Ajoelhem-se, mortais! Isso acaba agora."
	L.intermission_end_trigger3 = "Chega! Vou acabar com isso."
	L.phase4_trigger = "Cedo demais!... vocês vieram cedo demais..." --verificar
	L.seed_explosion = "Explosão de sementes!"
	L.intermission_bar = "Intervalo!"
	L.intermission_message = "Intervalo... Tem bolacha?"
	L.sons_left = "%d |4filhos restante:filhos restantes;"
	L.engulfing_close = "Parte mais próxima submergida!"
	L.engulfing_middle = "Parte central submergida!"
	L.engulfing_far = "Parte mais longe submergida"
	L.hand_bar = "Rebote"
	L.ragnaros_back_message = "Raggy voltou, se preparem!"

	L.wound = "Ferida de Queimadura"
	L.wound_desc = "Alerta somente para tanques. Conta os stacks de ferida de queimadura e mostra uma barra com sua duração."
	L.wound_message = "%2$dx Ferida em %1$s"
end

