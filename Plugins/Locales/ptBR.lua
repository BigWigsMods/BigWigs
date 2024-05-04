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
L.fontSizeDesc = "Ajusta o tamanho da fonte usando a barra deslizante ou digitando o valor na caixa que tem um limite muito maior de 200."
L.disableDesc = "Você está prestes a desabilitar a função '%s' e isso |cffff4411não é recomendado|r.\n\nVocê tem certeza disso?"
L.transparency = "Transparência"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "PoderAlt"
L.altPowerDesc = "A janela de PoderAlt só vai aparecer pra chefes que aplicam PoderAlt em jogadores, isso é extremamente raro. A janela calcula a quantidade do 'Poder Alternativo' que você e seu grupo tem, mostrando isso em uma lista. Para mover a janela, por favor use o botão de teste abaixo."
L.toggleDisplayPrint = "Esta exibição será usada da próxima vez. Para desativá-la completamente para esse encontro, você precisa desativar isto nas opções de encontro."
L.disabled = "Desativado"
L.disabledDisplayDesc = "Desativa a exibição para todos os módulos que usam ela."
L.resetAltPowerDesc = "Reinicia todas as opções relacionadas a PoderAlt, incluindo a posição de âncora do PoderAlternativo."
L.test = "Testar"
L.altPowerTestDesc = "Mostra a janela de 'Poder Alternativo', permitindo que você mova, e simula a mudança de poderes que você veria no encontro de chefe."
L.yourPowerBar = "Sua barra de poder"
L.barColor = "Cor da barra"
L.barTextColor = "Cor do texto da barra"
L.additionalWidth = "Largura adicional"
L.additionalHeight = "Altura adicional"
L.additionalSizeDesc = "Adiciona tamanho a janela padrão ao ajustar essa barra deslizante, ou digite o valor na caixa que tem um limite muito maior de 100."
L.yourPowerTest = "Seu Poder: %d" -- Your Power: 42
L.yourAltPower = "Seu %s: %d" -- e.g. Your Corruption: 42
L.player = "Jogador %d" -- Player 7
L.disableAltPowerDesc = "Desativa globalmente a janela de PoderAlt, nunca mais será mostrada em encontros de chefes."

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
L.resetBarsDesc = "Reinicia todas as opções relacionadas a barras, incluindo a posição de âncora das barras."

L.nameplateBars = "Barras de Identificação"
L.nameplateAutoWidth = "Combinar a largura da placa de identificação"
L.nameplateAutoWidthDesc = "Configura a largura da barra de identificação com a largura da barra de identificação pai."
L.nameplateOffsetY = "Deslocamento Y"
L.nameplateOffsetYDesc = "Deslocamento de cima da barra de identificação para cima e a de baixo da barra de identificação para baixo das barras."
L.nameplateAlphaDesc = "Controla o quão transparente serão as barras de identificação."

L.clickableBars = "Barras clicáveis"
L.clickableBarsDesc = "As barras do BigWigs são clicáveis por padrão. Desta forma você pode mirar em objetos e lançar feitiços AoE através delas, trocar o ângulo da câmera, e assim sucessivamente, sem precisar do cursor estar em cima das barras. |cffff4411Se habilitar as barras clicáveis, isto deixará de funcionar.|r As barras interceptarão qualquer clique do mouse feito nelas."
L.interceptMouseDesc = "Ativa as barras para receber cliques do mouse."
L.modifier = "Modificador"
L.modifierDesc = "Segure a tecla de modificação selecionada para ativar o cliques nas barras de contagem."
L.modifierKey = "Somente com uma tecla de modificação"
L.modifierKeyDesc = "Permite que as barras sejam clicáveis se estiver com a tecla de modificação pressionada, deste jeito as ações do mouse descritas abaixo estarão disponíveis."

L.temporaryCountdownDesc = "Habilita temporariamente a contagem na habilidade associada a essa barra."
L.report = "Reportar"
L.reportDesc = "Reporta o status das barras para o chat de grupo ativo; seja em um bate-papo de instância, raide, grupo ou falar, o que for mais adequado."
L.remove = "Remover"
L.removeBarDesc = "Remove temporariamente as barras."
L.removeOther = "Remover outro"
L.removeOtherBarDesc = "Temporariamente remove todas as outras barras (exceto esta)."

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
L.emphasizedBars = "Barras enfatizadas"
L.align = "Alinhamento"
L.alignText = "Alinhar texto"
L.alignTime = "Alinhar tempo"
L.left = "Esquerda"
L.center = "Centro"
L.right = "Direita"
L.time = "Tempo"
L.timeDesc = "Mostra ou oculta o tempo restante nas barras."
L.textDesc = "Quando mostrar ou esconder o texto mostrado nas barras."
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
L.visibleBarLimit = "Limite de barra visível"
L.visibleBarLimitDesc = "Configrua a quantiadde máxima de barras visíveis ao mesmo tempo."

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
L.bossBlockDesc = "Configura diversas coisas que você pode bloquear durante um encontro com um chefe.\n\n"
L.bossBlockAudioDesc = "Configura qual audio irá se desativar durante um encontro de chefe.\n\nQualquer opção aqui que estiver |cff808080em cinza|r foi desabilitada nas opções de som do WoW.\n\n"
L.movieBlocked = "Você já viu esta animação anteriormente, pulando ela."
L.blockEmotes = "Bloqueia frases no meio da tela"
L.blockEmotesDesc = "Alguns chefes usam frases de efeito para certas habilidades, essas mensagens são muito longas e descritivas. Nós tentamos produzir mensagens menores, mais apropriadas que não interferem com sua jogabilidade, e não te dizem especificamente o que fazer.\n\nObservação: Frases de chefes ainda serão vistas no bate-papo se quiser lê-las."
L.blockMovies = "Bloquear vídeos repetidos"
L.blockMoviesDesc = "Vídeos de encontros com chefes só irão ser reproduzidos uma vez (para que possa assistir cada um) e então serão bloqueados."
L.blockFollowerMission = "Bloqueia avisos das missões de seguidores" -- Rename to follower mission
L.blockFollowerMissionDesc = "Avisos da guarnição aparecem para algumas coisas, mas principalmente quando uma missão de seguidor é completada.\n\nEsses avisos podem cobrir partes essenciais de sua interface durante uma luta contra um chefe, então recomendamos bloqueá-las."
L.blockGuildChallenge = "Bloquear avisos de desafios de guilda"
L.blockGuildChallengeDesc = "Avisos de desafio de guilda aparecem por alguns motivos, principalmente quando um grupo em sua guilda completa uma masmorra heroica ou uma masmorra em modo desafio.\n\nEsses avisos podem cobrir partes essenciais de sua interface durante uma luta contra um chefe, então recomendamos bloqueá-los."
L.blockSpellErrors = "Bloquear mensagens sobre feitiços que falharam."
L.blockSpellErrorsDesc = "Mensagens do tipo \"O feitiço não está pronto ainda\" que normalmente aparecem no topo da tela serão bloqueados."
L.blockZoneChanges = "Bloquear mensagens de troca de zona"
L.blockZoneChangesDesc = "As mensagens que aparecem na parte central superior da tela quando você entra em uma nova zona como '|cFF33FF99Ventobravo|r' ou '|cFF33FF99Orgrimmar|r' serão bloqueadas."
L.audio = "Áudio"
L.music = "Música"
L.ambience = "Som ambiente"
L.sfx = "Efeitos sonoros"
L.errorSpeech = "Sons de erro"
L.disableMusic = "Desativar música (recomendado)"
L.disableAmbience = "Desativar sons ambiente (recomendado)"
L.disableSfx = "Desativar efeitos sonoros (não recomendado)"
L.disableErrorSpeech = "Desativar sons de diálogo de erros (recomendado)"
L.disableAudioDesc = "A opção '%s' do WoW será desligada, e depois será ligado novamente quando a luta contra o chefe acabar. Isso pode ajudar você a focar nos sons de alertas do BigWigs."
L.blockTooltipQuests = "Bloqueia a dica de objetivos de missões"
L.blockTooltipQuestsDesc = "Quando você precisa matar um chefe para uma missão, normalmente irá mostrar '0/1 completo' na barra de dica quando você passa o mouse pelo chefe. Isso será escondido quando em combate com o chefe para prevenir que a bara de dica fique muito grande."
L.blockObjectiveTracker = "Esconder rastreador de missão"
L.blockObjectiveTrackerDesc = "O rastreador de objetivos de missão será escondido durante um encontro de chefe para liberar espaço na tela.\n\nIsso NÃO irá acontecer se você estiver em uma Mítica+ ou estiver rastreando uma conquista."

L.blockTalkingHead = "Esconder o popup de diálogo 'Cabeça Falante' do NPC"
L.blockTalkingHeadDesc = "A 'Cabeça Falante' é um popup de diálogo que tem uma cabeça do NPC e um texto de chat embaixo no meio da tela que |cffff4411às vezes|r é mostrada quando um NPC está falando.\n\nVocê pode escolher diferentes tipos de instâncias para quando isso deve ser bloqueado de ser mostrado.\n\n|cFF33FF99Por favor note que:|r\n 1) Essa funcionalidade irá permitir que a vozd o NPC continue reproduzindo para que você continue a ouvi-lo.\n 2) Por segurança, somente cabeças falantes específicas serão bloqueadas. Qualquer uma especial ou única, como as missões de uma única vez, não serão bloqueadas."
L.blockTalkingHeadDungeons = "Masmorras Normal & Heróica"
L.blockTalkingHeadMythics = "Masmorras Míticas & Míticas+"
L.blockTalkingHeadRaids = "Raides"
L.blockTalkingHeadTimewalking = "Caminhada Temporal (Masmorras & Raides)"
L.blockTalkingHeadScenarios = "Cenários"

L.redirectPopups = "Redirecionar banners pop-up para mensagens do BigWigs"
L.redirectPopupsDesc = "Banners de pop-up no meio da sua tela, como o banner '|cFF33FF99novo espaço no grande cofre desbloqueado|r' ou o banner que você vê ao entrar em uma masmorra Mítico+ será bloqueado e, em vez disso, exibido como mensagens do BigWigs. Esses banners podem ser bastante grandes, durar muito tempo e impedir sua capacidade de clicar através deles."
L.redirectPopupsColor = "Cor da mensagem redirecionada"
L.blockDungeonPopups = "Bloquear banners pop-up em masmorras"
L.blockDungeonPopupsDesc = "Os banners de pop-up que aparecem ao entrar em uma masmorra às vezes podem conter textos muito longos. Ativar essa função os bloqueará completamente em vez de redirecioná-los para mensagens do BigWigs."
L.itemLevel = "Nível do Item: %d"

L.userNotifySfx = "Os Efeitos Sonoros estavam desativados pelo BossBlock e agora estão sendo reativados."
L.userNotifyMusic = "A Música estava desativada pelo BossBlock e agora está sendo reativada."
L.userNotifyAmbience = "A Ambiência estava desativada pelo BossBlock e agora está sendo reativada."
L.userNotifyErrorSpeech = "A fala de erro estava desativada pelo BossBlock e agora está sendo reativada."

L.subzone_grand_bazaar = "Grande Bazar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "Porto de Zandalar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "Transepto Oriental" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "Cores"

L.text = "Texto"
L.textShadow = "Sombra do texto"
L.normal = "Normal"
L.emphasized = "Enfatizado"

L.reset = "Reiniciar"
L.resetDesc = "Reinicia as cores padrões"
L.resetAll = "Reiniciar tudo"
L.resetAllDesc = "Se você personalizou as cores para os ajustes de algum encontro de chefe, este botão reiniciará TODOS ELES e usará as cores padrões."

L.red = "Vermelho"
L.redDesc = "Alertas de encontros em geral."
L.blue = "Azul"
L.blueDesc = "Alertas para coisas que lhe afetam diretamente, como efeitos negativo que são aplicados em você."
L.orange = "Laranja"
L.yellow = "Amarelo"
L.green = "Verde"
L.greenDesc = "Alertas para coisas boas que acontecem, como efeitos negativos que sendo removidos de você."
L.cyan = "Ciano"
L.cyanDesc = "Alertas para troca de status do encontro, como ao avançar para a próxima fase do chefe."
L.purple = "Roxo"
L.purpleDesc = "Alertas para habilidades específicas de tanque, como pilhas de efeitos negativos no tanque."

-----------------------------------------------------------------------
-- Countdown.lua
--

L.textCountdown = "Texto de contagem regressiva"
L.textCountdownDesc = "Mostrar um contador visual durante uma contagem regressiva."
L.countdownColor = "Cor da contagem regressiva"
L.countdownVoice = "Voz da contagem regressiva"
L.countdownTest = "Teste de contagem regressiva"
L.countdownAt = "Contagem regressiva em... (segundos)"
L.countdownAt_desc = "Escolhe quanto tempo deve restar para a habilidade do chefe (em segundos) para começar a contagem."
L.countdown = "Contagem"
L.countdownDesc = "A funcionalidade de contagem reproduz um áudio de contagem e um texto visual. Isso é raramente habilitado por padrão, mas você pode habilitar para qualquer habilidade de chefe quando estiver olhando as configurações de habilidades específicas de chefes."
L.countdownAudioHeader = "Áudio Falado na Contagem"
L.countdownTextHeader = "Texto Visual na Contagem"
L.resetCountdownDesc = "Reinicia todas as configurações de contagem acima aos seus valores padrões."
L.resetAllCountdownDesc = "Se você selecionou alguma voz customizada de contagem para alguma configuração de chefe, esse botão irá reiniciar TODAS elas também, incluindo as opções acima para os padrões."

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infoBox = "Caixa de Informações"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Redireciona a saída deste addOn pela exibição de mensagens do BigWigs. Ela dá suporte a ícones, cores e pode mostrar até 4 mensagens na tela de uma vez. Mensagens novas crescerão de tamanho e encolherão de novo rapidamente para notificar o usuário."
L.emphasizedSinkDescription = "Redireciona a saída deste addOn pela exibição de mensagens enfatizadas do BigWigs. Ele dá suporte a texto e cores, e só exibe uma mensagem por vez."
L.resetMessagesDesc = "Reinicia todas as opções relacionadas a mensagens, incluindo a posição de âncora das mensagens."

L.bwEmphasized = "BigWigs enfatizado"
L.messages = "Mensagens"
L.emphasizedMessages = "Mensagens enfatizadas"
L.emphasizedDesc = "O objetivo das mensagens enfatizadas é ter a sua atenção, pois ela é uma mensagem grande no meio da tela. Isso é raramente habilitado por padrão, mas você pode habilitar para qualquer habilidade de chefe quando estiver olhando as configurações de habilidades específicas de chefes."
L.uppercase = "MAIÚSCULAS"
L.uppercaseDesc = "Todas as mensagens enfatizadas serão convertidas para letras MAIÚSCULAS."

L.useIcons = "Usar ícones"
L.useIconsDesc = "Exibir ícones ao lado das mensagens."
L.classColors = "Cores de classe"
L.classColorsDesc = "As mensagens as vezes terão os nomes dos jogadores. Habilitar essa opção irá colorir esses nomes usando as cores de classe."
L.chatFrameMessages = "Mensagens no chat"
L.chatFrameMessagesDesc = "Mostra todas as mensagens na janela de chat padrão além da tela de configuração."

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

L.resetProximityDesc = "Reinicia todas as opções relacionadas a proximidade, incluindo a posição de âncora de proximidade."

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
--L.pullStartedBy = "Pull timer started by %s."
L.pullStopped = "Pull cancelado por %s."
L.pullStoppedCombat = "Temporizador cancelado porque você entrou em combate."
L.pullIn = "Pull em %d seg"
L.sendPull = "Enviando contador de pull para usuários BigWigs e DBM."
L.wrongPullFormat = "Deve estar entre 1 e 60 segundos. Um exemplo correto seria: /pull 5"
L.countdownBegins = "Iniciar Contagem"
L.countdownBegins_desc = "Escolhe quanto tempo deve restar de tempo de pull (em segundos) para começar a contagem."

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L.icons = "Ícones"
L.raidIconsDescription = "Alguns encontros podem conter elementos de tipo 'bomba' focando em um jogador em especial, um jogador sendo perseguido, ou um jogador específico sendo de interesse em outros sentidos. Aqui você pode configurar quais ícones de raide devem ser usados para marcar esses jogadores.\n\nSe um encontro tem somente uma habilidade que exige marcação, somente o primeiro ícone será usado. Um ícone nunca será usado para duas habilidades diferentes no mesmo encontro, e uma mesma habilidade usará o mesmo ícone todas as vezes.\n\n|cffff4411Note que se um jogador já foi marcado manualmente o BigWigs não mudará seu ícone.|r"
L.primary = "Primário"
L.primaryDesc = "O primeiro ícone de raide que um script usará."
L.secondary = "Secundário"
L.secondaryDesc = "O segundo ícone de raide que um script usará."

-----------------------------------------------------------------------
-- Sound.lua
--

L.Sounds = "Sons"
L.soundsDesc = "BigWigs usa o canal de som 'Geral' para reproduzir todos os sons. Se você acha que os sons estão muito baixos ou muito altos, abra as configurações de som do WoW e ajuste o 'Volume geral' para um nível que você goste.\n\nAbaixo você pode configurar globalmente os diferentes sons que irão reproduzir para ações específicas, ou configurar eles para 'Nenhum' para desabilita-los. Se você quer mudar somente o som para uma habilidade específica de chefe, isso pode ser feito nas configurações de encontro do chefe.\n\n"
L.oldSounds = "Sons antigos"

L.Alarm = "Alarme"
L.Info = "Info"
L.Alert = "Alerta"
L.Long = "Longo"
L.Warning = "Aviso"
L.onyou = "Um feitiço, buff, ou debuff em você"
L.underyou = "Você precisa se mover do feitiço embaixo de você"

L.sound = "Som"

L.customSoundDesc = "Reproduzir um som personalizado ao invés do padrão do módulo."
L.resetSoundDesc = "Reinicia os sons acima para os padrões."
L.resetAllCustomSound = "Se você personalizou sons para qualquer configuração de encontro, este botão ira redefinir TODOS eles para que os sons definidos aqui sejam utilizados."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossDefeatDurationPrint = "Derrotou '%s' após '%s'"
L.bossWipeDurationPrint = "Foi derrotado por '%s' após %s"
L.newBestTime = "Novo recorde!"
L.bossStatistics = "Estatísticas do chefe."
L.bossStatsDescription = "Grava várias estatísticas dos encontros, como o número de vezes que um chefe foi morto, quantas derrotas, tempo total de combate, ou a morte mais rápida. Estas estatísticas podem ser visualizadas na tela de cada chefe, mas estará oculta para chefes que não têm estatísticas gravadas."
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
