local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "ptBR")
if not L then return end

L.general = "Geral"
L.comma = ", "

L.positionX = "Posição X"
L.positionY = "Posição Y"
L.positionExact = "Posicionamento Exato"
L.positionDesc = "Digite na caixa ou mova o cursor se precisa posicionamento exato para a âncora."
L.width = "Largura"
L.height = "Altura"
L.sizeDesc = "Normalmente você define o tamanho arrastando a âncora. Se você precisa de um tamanho exato, você pode usar este controle deslizante ou digitar o valor na caixa, que não tem um tamanho máximo."

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "Poder alternativo"
L.toggleDisplayPrint = "Esta exibição será usada da próxima vez. Para desativá-la completamente para esse encontro, você precisa desativar isto nas opções de encontro."
L.disabled = "Desativado"
L.disabledDisplayDesc = "Desativa a exibição para todos os módulos que usam ela."

-----------------------------------------------------------------------
-- AutoReply.lua
--

L.autoReply = "Auto Resposta"
L.autoReplyDesc = "Responde automaticamente aos sussurros quando ocupado em uma luta com o Chefe."
L.responseType = "Tipo de Resposta"
L.autoReplyFinalReply = "Também sussurra ao sair de combate"
L.guildAndFriends = "Guilda & Amigos"
L.everyoneElse = "Todos os outros"

L.autoReplyBasic = "Estou ocupado lutando contra um Chefe."
L.autoReplyNormal = "Estou ocupado lutando com '%s'."
L.autoReplyAdvanced = "Estou ocupado lutando com '%s' (%s) e %d/%d pessoas estão vivas."
L.autoReplyExtreme = "Estou ocupado lutando com '%s' (%s) e %d/%d pessoas estão vivas: %s"

L.autoReplyLeftCombatBasic = "Não estou mais lutando contra um Chefe."
L.autoReplyLeftCombatNormalWin = "Eu venci '%s'."
L.autoReplyLeftCombatNormalWipe = "Eu perdi para '%s'."
L.autoReplyLeftCombatAdvancedWin = "Eu venci '%s' com %d/%d pessoas vivas."
L.autoReplyLeftCombatAdvancedWipe = "Eu perdi para '%s' at: %s"

-----------------------------------------------------------------------
-- Bars.lua
--

L.bars = "Barras"
L.style = "Estilo"
L.bigWigsBarStyleName_Default = "Padrão"

L.clickableBars = "Barras clicáveis"
L.clickableBarsDesc = "As barras do BigWigs são clicáveis por padrão. Desta forma você pode mirar em objetos e lançar feitiços AoE através delas, trocar o ângulo da câmera, e assim sucessivamente, sem precisar do cursor estar em cima das barras. |cffff4411Se habilitar as barras clicáveis, isto deixará de funcionar.|r As barras interceptarão qualquer clique do mouse feito nelas."
L.interceptMouseDesc = "Ativa as barras para receber cliques do mouse."
L.modifier = "Modificador"
L.modifierDesc = "Segure a tecla de modificação selecionada para ativar o cliques nas barras de contagem."
L.modifierKey = "Somente com uma tecla de modificação"
L.modifierKeyDesc = "Permite que as barras sejam clicáveis se estiver com a tecla de modificação pressionada, deste jeito as ações do mouse descritas abaixo estarão disponíveis."

L.tempEmphasize = "Temporariamente enfatiza a barra e as mensagens associadas a ela durante sua duração."
L.report = "Reportar"
L.reportDesc = "Reporta o status das barras para o chat de grupo ativo; seja em um bate-papo de instância, raide, grupo ou falar, o que for mais adequado."
L.remove = "Remover"
L.removeDesc = "Temporariamente remove a barra e todas as mensagens associadas a ela."
L.removeOther = "Remover outro"
L.removeOtherDesc = "Temporariamente fecha todas as barras (exceto esta) e as mensagens associadas a elas."
L.disable = "Desativar"
L.disableDesc = "Desativa permanentemente a opção da habilidade de encontro do chefe que criou esta barra."

L.emphasizeAt = "Enfatizar em... (segundos)"
L.growingUpwards = "Crescimento para cima"
L.growingUpwardsDesc = "Alterna crescimento para cima ou para baixo a partir da âncora."
L.texture = "Textura"
L.emphasize = "Enfatizar"
L.emphasizeMultiplier = "Multiplicador de Tamanho"
L.emphasizeMultiplierDesc = "Se você desabilitar as barras movendo-as para a âncora em destaque, esta opção irá decidir qual tamanho as barras em destaque terão, ao se multiplicar o tamanho das barras normais."
L.enable = "Habilitar"
L.move = "Mover"
L.moveDesc = "Move barras enfatizadas para a âncora de Enfatizar. Se esta opção estiver desativada, barras enfatizadas terão apenas sua cor e tamanho alterados."
L.regularBars = "Barras regulares"
L.emphasizedBars = "Barras enfatizadas"
L.align = "Alinhamento"
L.alignText = "Alinhar texto"
L.alignTime = "Alinhar tempo"
L.left = "Esquerda"
L.center = "Centro"
L.right = "Direita"
L.time = "Tempo"
L.timeDesc = "Mostra ou oculta o tempo restante nas barras."
--L.textDesc = "Whether to show or hide the text displayed on the bars."
L.icon = "ícone"
L.iconDesc = "Mostra ou oculta os ícones das barras."
L.iconPosition = "Posição do ícone"
L.iconPositionDesc = "Escolha onde na barra o ícone deve ser posicionado."
L.font = "Fonte"
L.restart = "Reiniciar"
L.restartDesc = "Reinicia as barras enfatizadas para que comecem novamente e conta a partir de 10."
L.fill = "Completar"
L.fillDesc = "Completa as barras ao invés de drena-las."
L.spacing = "Espaçamento"
L.spacingDesc = "Muda o espaço entre cada barra."
--L.visibleBarLimit = "Visible bar limit"
--L.visibleBarLimitDesc = "Set the maximum amount of bars that are visible at the same time."

L.localTimer = "Local"
L.timerFinished = "%s: Contador [%s] terminado."
L.customBarStarted = "Barra personalizada '%s' iniciada por %s pelo usuário %s."
L.sendCustomBar = "Enviando barra personalizada '%s' para usuários BigWigs e DBM."

L.requiresLeadOrAssist = "Esta funcionalidade só pode ser usada por um líder ou assistente de raide."
L.encounterRestricted = "Esta funcionalidade não pode ser usada durante um encontro."
L.wrongCustomBarFormat = "Formato incorreto. Um exemplo correto seria: /raidbar 20 texto"
L.wrongTime = "Tempo inválido. <time> pode ser tanto um número em segundos, um par M:S, ou Mm. Por exemplo: 5, 1:20 ou 2m."

L.wrongBreakFormat = "Deve estar entre 1 e 60 minutos. Um exemplo seria: /break 5"
L.sendBreak = "Enviando contador de intervalo para usuários BigWigs e DBM."
L.breakStarted = "Intervalo iniciado por %s pelo usuário %s."
L.breakStopped = "Intervalo cancelado por %s."
L.breakBar = "Intervalo"
L.breakMinutes = "Intervalo acaba em %d |4minuto:minutos;!"
L.breakSeconds = "Intervalo acaba em %d |4segundo:segundos;!"
L.breakFinished = "Intervalo acabou!"

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.bossBlock = "Bloqueio de Chefe"
L.bossBlockDesc = "Configura diversas coisas que você pode bloquear durante um encontro com um chefe."
L.movieBlocked = "Você já viu esta animação anteriormente, pulando ela."
L.blockEmotes = "Bloqueia frases no meio da tela"
L.blockEmotesDesc = "Alguns chefes usam frases de efeito para certas habilidades, essas mensagens são muito longas e descritivas. Nós tentamos produzir mensagens menores, mais apropriadas que não interferem com sua jogabilidade, e não te dizem especificamente o que fazer.\n\nObservação: Frases de chefes ainda serão vistas no bate-papo se quiser lê-las."
L.blockMovies = "Bloquear vídeos repetidos"
L.blockMoviesDesc = "Vídeos de encontros com chefes só irão ser reproduzidos uma vez (para que possa assistir cada um) e então serão bloqueados."
--L.blockFollowerMission = "Bloqueia avisos da guarnição" -- Rename to follower mission
--L.blockFollowerMissionDesc = "Avisos da guarnição aparecem para algumas coisas, mas principalmente quando uma missão de seguidor é completada.\n\nEsses avisos podem cobrir partes essenciais de sua interface durante uma luta contra um chefe, então recomendamos bloqueá-las."
L.blockGuildChallenge = "Bloquear avisos de desafios de guilda"
L.blockGuildChallengeDesc = "Avisos de desafio de guilda aparecem por alguns motivos, principalmente quando um grupo em sua guilda completa uma masmorra heroica ou uma masmorra em modo desafio.\n\nEsses avisos podem cobrir partes essenciais de sua interface durante uma luta contra um chefe, então recomendamos bloqueá-los."
L.blockSpellErrors = "Bloquear mensagens sobre feitiços que falharam."
L.blockSpellErrorsDesc = "Mensagens do tipo \"O feitiço não está pronto ainda\" que normalmente aparecem no topo da tela serão bloqueados."
--L.disableSfx = "Disable sound effects"
--L.disableSfxDesc = "The 'Sound Effects' option in WoW's sound options will be turned off, then turned back on when the boss encounter is over. This can help you focus on warning sounds from BigWigs."
--L.blockTooltipQuests = "Block tooltip quest objectives"
--L.blockTooltipQuestsDesc = "When you need to kill a boss for a quest, it will usually show as '0/1 complete' in the tooltip when you place your mouse over the boss. This will be hidden whilst in combat with that boss to prevent the tooltip growing very large."
--L.blockObjectiveTracker = "Hide quest tracker"
--L.blockObjectiveTrackerDesc = "The quest objective tracker will be hidden during a boss encounter to clear up screen space.\n\nThis will NOT happen if you are in a mythic+ or are tracking an achievement."

L.subzone_grand_bazaar = "Grande Bazar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "Porto de Zandalar" -- Battle of Dazar'alor raid (Battle for Azeroth)
--L.subzone_eastern_transept = "Eastern Transept" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "Cores"

L.text = "Texto"
L.textShadow = "Sombra do texto"
L.flash = "Piscar"
L.normal = "Normal"
L.emphasized = "Enfatizado"

L.reset = "Reiniciar"
L.resetDesc = "Reinicia as cores padrões"
L.resetAll = "Reiniciar tudo"
L.resetAllDesc = "Se você personalizou as cores para os ajustes de algum encontro de chefe, este botão reiniciará TODOS ELES e usará as cores padrões."

--L.red = "Red"
--L.redDesc = "General encounter warnings."
--L.blue = "Blue"
--L.blueDesc = "Warnings for things that affect you directly such as a debuff being applied to you."
--L.orange = "Orange"
--L.yellow = "Yellow"
--L.green = "Green"
--L.greenDesc = "Warnings for good things that happen such as a debuff being removed from you."
--L.cyan = "Cyan"
--L.cyanDesc = "Warnings for encounter status changes such as advancing to the next stage."
--L.purple = "Purple"
--L.purpleDesc = "Warnings for tank specific abilities such as stacks of a tank debuff."

-----------------------------------------------------------------------
-- Emphasize.lua
--

L.superEmphasize = "Super enfatizar"
L.superEmphasizeDesc = "Melhora as mensagens e barras relacionadas a uma habilidade de encontro de chefe específica.\n\nAqui você configura exatamente o que deverá acontecer quando ativar a opção de super enfatizar na sessão avançada para uma habilidade de encontro de chefe.\n\n|cffff4411Nota: Super enfatizar está desabilitado por padrão para todas as habilidades.|r"
L.uppercase = "MAIÚSCULAS"
L.uppercaseDesc = "Maiúsculas em todas as mensagens relacionadas a opção super enfatizada."
L.superEmphasizeDisableDesc = "Desabilita super enfatizar para todos os módulos que usam ele."
L.textCountdown = "Texto de contagem regressiva"
L.textCountdownDesc = "Mostrar um contador visual durante uma contagem regressiva."
L.countdownColor = "Cor da contagem regressiva"
L.countdownVoice = "Voz da contagem regressiva"
L.countdownTest = "Teste de contagem regressiva"
L.countdownAt = "Contagem regressiva em... (segundos)"

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infoBox = "Caixa de Informações"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Redireciona a saída deste addOn pela exibição de mensagens do BigWigs. Ela dá suporte a ícones, cores e pode mostrar até 4 mensagens na tela de uma vez. Mensagens novas crescerão de tamanho e encolherão de novo rapidamente para notificar o usuário."
L.emphasizedSinkDescription = "Redireciona a saída deste addOn pela exibição de mensagens enfatizadas do BigWigs. Ele dá suporte a texto e cores, e só exibe uma mensagem por vez."
L.emphasizedCountdownSinkDescription = "Redireciona a saída deste addOn pela exibição de contagem regressiva enfatizada do BigWigs. Ele dá suporte a texto e cores, e só exibe uma mensagem por vez."

L.bwEmphasized = "BigWigs enfatizado"
L.messages = "Mensagens"
L.normalMessages = "Mensagens normais"
L.emphasizedMessages = "Mensagens enfatizadas"
L.output = "Saída"

L.useColors = "Usar cores"
L.useColorsDesc = "Alterna entre mensagens em branco ou coloridas."
L.useIcons = "Usar ícones"
L.useIconsDesc = "Exibir ícones ao lado das mensagens."
L.classColors = "Cores de classe"
L.classColorsDesc = "Colore nomes de jogadores pela classe deles."

L.fontSize = "Tamanho da fonte"
L.none = "Nenhum"
L.thin = "Fino"
L.thick = "Grosso"
L.outline = "Contorno"
L.monochrome = "Monocromático"
L.monochromeDesc = "Alterna o sinalizador de monocromático, removendo as melhorias das fontes."
L.fontColor = "Cor do texto"

L.displayTime = "Tempo de exibição"
L.displayTimeDesc = "Tempo de exibição da mensagem, em segundos"
L.fadeTime = "Tempo até esmaecer"
L.fadeTimeDesc = "Tempo até esmaecer a mensagem, em segundos."

-----------------------------------------------------------------------
-- Proximity.lua
--

L.customRange = "Indicador de distância personalizado"
L.proximityTitle = "%d m / %d |4jogador:jogadores;"
L.proximity_name = "Proximidade"
L.soundDelay = "Atraso de som"
L.soundDelayDesc = "Especifique o tempo que BigWigs deverá esperar para repetir o som de quando alguem está muito perto de você."

L.proximity = "Exibição de proximidade"
L.proximity_desc = "Mostra a janela de proximidade quando for apropriada para este encontro, listando os jogadores que estão muito pertos de você."

L.close = "Fechar"
L.closeProximityDesc = "Fecha a janela de aproximação.\n\nPara desativa-la completamente para um encontro, tem que ir nas opções deste encontro e desativar a opção de 'Proximidade'."
L.lock = "Bloquear"
L.lockDesc = "Trava a janela no lugar, prevenindo movimento e mudança de tamanho."
L.title = "Título"
L.titleDesc = "Mostra ou oculta o título."
L.background = "Fundo"
L.backgroundDesc = "Mostra ou oculta o fundo"
L.toggleSound = "Ativa o som"
L.toggleSoundDesc = "Alterna se a janela de proximidade deve ou não apitar quando você está muito próximo de outro jogador."
L.soundButton = "Botão de som"
L.soundButtonDesc = "Mostra ou oculta o botão de som"
L.closeButton = "Botão de fechar"
L.closeButtonDesc = "Mostra ou oculta o botão de fechar"
L.showHide = "Mostrar/ocultar"
L.abilityName = "Nome da habilidade"
L.abilityNameDesc = "Mostra ou oculta o nome da habilidade acima da janela."
L.tooltip = "Dica de feitiço"
L.tooltipDesc = "Mostra ou oculta a dica do feitiço se a janela de aproximação estiver associada diretamente a uma habilidade de chefe."

-----------------------------------------------------------------------
-- Pull.lua
--

L.countdownType = "Tipo de contagem regressiva"
L.combatLog = "Registro de combate automático"
L.combatLogDesc = "Inicia automaticamente o registro de combate quando um contador de pull é iniciado e termina ele quando o encontro termina."

L.pull = "Pull"
L.engageSoundTitle = "Tocar um som quando uma luta contra um Chefe começou"
L.pullStartedSoundTitle = "Tocar um som quando o temporizador for iniciado"
L.pullFinishedSoundTitle = "Tocar um som quando o temporizador terminar"
L.pullStarted = "Pull iniciado por %s pelo usuário %s."
L.pullStopped = "Pull cancelado por %s."
L.pullStoppedCombat = "Temporizador cancelado porque você entrou em combate."
L.pullIn = "Pull em %d seg"
L.sendPull = "Enviando contador de pull para usuários BigWigs e DBM."
L.wrongPullFormat = "Deve estar entre 1 e 60 segundos. Um exemplo correto seria: /pull 5"

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L.icons = "Ícones"
L.raidIconsDesc = "Alguns scripts de encontros usam os ícones de raide para marcar jogadores que são de interesse especial para seu grupo. Por exemplo, os efeitos tipo 'bomba' e controle mental. Se esta opção estiver desativada, não marcará nada.\n\n|cffff4411Somente aplicará as marcas se você for assistente ou líder!|r"
L.raidIconsDescription = "Alguns encontros podem conter elementos de tipo 'bomba' focando em um jogador em especial, um jogador sendo perseguido, ou um jogador específico sendo de interesse em outros sentidos. Aqui você pode configurar quais ícones de raide devem ser usados para marcar esses jogadores.\n\nSe um encontro tem somente uma habilidade que exige marcação, somente o primeiro ícone será usado. Um ícone nunca será usado para duas habilidades diferentes no mesmo encontro, e uma mesma habilidade usará o mesmo ícone todas as vezes.\n\n|cffff4411Note que se um jogador já foi marcado manualmente o BigWigs não mudará seu ícone.|r"
L.primary = "Primário"
L.primaryDesc = "O primeiro ícone de raide que um script usará."
L.secondary = "Secundário"
L.secondaryDesc = "O segundo ícone de raide que um script usará."

-----------------------------------------------------------------------
-- Sound.lua
--

L.Sounds = "Sons"

L.Alarm = "Alarme"
L.Info = "Info"
L.Alert = "Alerta"
L.Long = "Longo"
L.Warning = "Aviso"

L.sound = "Som"
L.soundDesc = "As mensagens podem conter um som. Para algumas pessoas fica mais fácil escutar quando aprendem que tal som aparece com tal mensagem, ao invés de ler a mensagem."

L.customSoundDesc = "Reproduzir um som personalizado ao invés do padrão do módulo"
L.resetAllCustomSound = "Se você personalizou sons para qualquer configuração de encontro, este botão ira redefinir TODOS eles para que os sons definidos aqui sejam utilizados."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossDefeatDurationPrint = "Derrotou '%s' após '%s'"
L.bossWipeDurationPrint = "Foi derrotado por '%s' após %s"
L.newBestTime = "Novo recorde!"
L.bossStatistics = "Estatísticas do chefe."
L.bossStatsDescription = "Gravar várias estatísticas dos encontros, como o número de vezes que um chefe foi morto, quantas derrotas, tempo total de combate, ou a morte mais rápida. Estas estatísticas podem ser visualizadas na tela de cada chefe, mas estará oculta para chefes que não têm estatísticas gravadas."
L.enableStats = "Habilitar estatísticas"
L.chatMessages = "Conversas"
L.printBestTimeOption = "Notificação de melhor tempo"
L.printDefeatOption = "Tempo de luta"
L.printWipeOption = "Tempo até ser derrotado"
L.countDefeats = "Contador de vitórias "
L.countWipes = "Contador de derrotas"
L.recordBestTime = "Gravar recorde"
L.createTimeBar = "Mostrar barra do melhor tempo"
L.bestTimeBar = "Melhor tempo"
L.printHealthOption = "Vida do chefe"
L.healthPrint = "Vida: %s."
L.healthFormat = "%s (%.1f%%)"

-----------------------------------------------------------------------
-- Victory.lua
--

L.Victory = "Vitória"
L.victoryHeader = "Configura as ações que devem ser tomadas após vencer um encontro."
L.victorySound = "Toca um som de vitória"
L.victoryMessages = "Mostrar mensagens de vitória"
L.victoryMessageBigWigs = "Mostra a mensagem do BigWigs"
L.victoryMessageBigWigsDesc = "A mensagem do BigWigs é uma simples mensagem de \"chefe foi derrotado\"."
L.victoryMessageBlizzard = "Mostra a mensagem da Blizzard"
L.victoryMessageBlizzardDesc = "A mensagem da Blizzard é uma animação com \"chefe foi derrotado\" bem grande no meio da tela."
L.defeated = "%s foi derrotado"

-----------------------------------------------------------------------
-- Wipe.lua
--

L.wipe = "Derrota"
L.wipeSoundTitle = "Tocar um som quando você for derrotado"
L.respawn = "Respawn"
L.showRespawnBar = "Mostrar barra de respawn"
L.showRespawnBarDesc = "Mostra uma barra depois de você ser derrotado num chefe informando o tempo até que o chefe renasça."
