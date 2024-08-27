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
L.sizeDesc = "Normalmente você define o tamanho arrastando a âncora. Se você precisa de um tamanho exato, você pode usar este controle deslizante ou digitar o valor na caixa."
L.fontSizeDesc = "Ajusta o tamanho da fonte usando a barra deslizante ou digitando o valor na caixa que tem um limite muito maior de 200."
L.disabled = "Desativado"
L.disableDesc = "Você está prestes a desabilitar a função '%s' e isso |cffff4411não é recomendado|r.\n\nVocê tem certeza disso?"

-- Anchor Points
--L.UP = "Up"
--L.DOWN = "Down"
--L.TOP = "Top"
--L.RIGHT = "Right"
--L.BOTTOM = "Bottom"
--L.LEFT = "Left"
--L.TOPRIGHT = "Top Right"
--L.TOPLEFT = "Top Left"
--L.BOTTOMRIGHT = "Bottom Right"
--L.BOTTOMLEFT = "Bottom Left"
--L.CENTER = "Center"
--L.customAnchorPoint = "Advanced: Custom anchor point"
--L.sourcePoint = "Source Point"
--L.destinationPoint = "Destination Point"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "PoderAlt"
L.altPowerDesc = "A janela de PoderAlt só vai aparecer pra chefes que aplicam PoderAlt em jogadores, isso é extremamente raro. A janela calcula a quantidade do 'Poder Alternativo' que você e seu grupo tem, mostrando isso em uma lista. Para mover a janela, por favor use o botão de teste abaixo."
L.toggleDisplayPrint = "Esta exibição será usada da próxima vez. Para desativá-la completamente para esse encontro, você precisa desativar isto nas opções de encontro."
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
L.testBarsBtn = "Criar Barra de Teste"
L.testBarsBtn_desc = "Criar uma barra para você testar suas configurações de exibição atuais"

L.toggleAnchorsBtnShow = "Mostrar Âncoras de Movimentação"
L.toggleAnchorsBtnHide = "Esconder Âncoras de Movimentação"
L.toggleAnchorsBtnHide_desc = "Esconde todas as âncoras de movimentação, travando tudo em seu lugar."
L.toggleBarsAnchorsBtnShow_desc = "Mostra todas as âncoras de movimentação, permitindo que você mova as barras."

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
L.toggleMessagesAnchorsBtnShow_desc = "Mostra todas as âncoras de movimentação, permitindo que você mova as mensagens."

--L.testMessagesBtn = "Create Test Message"
--L.testMessagesBtn_desc = "Creates a message for you to test your current display settings with."

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
-- Nameplates.lua
--

--L.nameplates = "Nameplates"
--L.testNameplateIconBtn = "Show Test Icon"
--L.testNameplateIconBtn_desc = "Creates a test icon for you to test your current display settings with on your targeted nameplate."
--L.testNameplateTextBtn = "Show Text Test"
--L.testNameplateTextBtn_desc = "Creates a test text for you to test your current text settings with on your targeted nameplate."
--L.stopTestNameplateBtn = "Stop Tests"
--L.stopTestNameplateBtn_desc = "Stops the icon and text tests on your nameplates."
--L.noNameplateTestTarget = "You need to have a hostile target which is attackable selected to test nameplate functionality."
--L.anchoring = "Anchoring"
--L.growStartPosition = "Grow Start Position"
--L.growStartPositionDesc = "The starting position for the first icon."
--L.growDirection = "Grow Direction"
--L.growDirectionDesc = "The direction the icons will grow from the starting position."
--L.iconSpacingDesc = "Change the space between each icon."
--L.nameplateIconSettings = "Icon Settings"
--L.keepAspectRatio = "Keep Aspect Ratio"
--L.keepAspectRatioDesc = "Keep the aspect ratio of the icon 1:1 instead of stretching it to fit the size of the frame."
--L.iconColor = "Icon Color"
--L.iconColorDesc = "Change the color of the icon texture."
--L.desaturate = "Desaturate"
--L.desaturateDesc = "Desaturate the icon texture."
--L.zoom = "Zoom"
--L.zoomDesc = "Zoom the icon texture."
--L.showBorder = "Show Border"
--L.showBorderDesc = "Show a border around the icon."
--L.borderColor = "Border Color"
--L.borderSize = "Border Size"
--L.timer = "Timer"
--L.showTimer = "Show Timer"
--L.showTimerDesc = "Show a text timer on the icon."
--L.cooldown = "Cooldown"
--L.showCooldownSwipe = "Show Swipe"
--L.showCooldownSwipeDesc = "Show a swipe on the icon when the cooldown is active."
--L.showCooldownEdge = "Show Edge"
--L.showCooldownEdgeDesc = "Show an edge on the cooldown when the cooldown is active."
--L.inverse = "Inverse"
--L.inverseSwipeDesc = "Invert the cooldown animations."
--L.iconGlow = "Icon Glow"
--L.enableExpireGlow = "Enable Expire Glow"
--L.enableExpireGlowDesc = "Show a glow around the icon when the cooldown has expired."
--L.glowColor = "Glow Color"
--L.glowType = "Glow Type"
--L.glowTypeDesc = "Change the type of glow that is shown around the icon."
--L.resetNameplateIconsDesc = "Reset all the options related to nameplate icons."
--L.nameplateTextSettings = "Text Settings"
--L.fixate_test = "Fixate Test" -- Text that displays to test on the frame
--L.resetNameplateTextDesc = "Reset all the options related to nameplate text."

-- Glow types as part of LibCustomGlow
--L.pixelGlow = "Pixel Glow"
--L.autocastGlow = "Autocast Glow"
--L.buttonGlow = "Button Glow"
--L.procGlow = "Proc Glow"
--L.speed = "Speed"
--L.animation_speed_desc = "The speed at which the glow animation plays."
--L.lines = "Lines"
--L.lines_glow_desc = "The number of lines in the glow animation."
--L.intensity = "Intensity"
--L.intensity_glow_desc = "The intensity of the glow effect, higher means more sparks."
--L.lenght = "Length"
--L.lenght_glow_desc = "The length of the lines in the glow animation."
--L.thickness = "Thickness"
--L.thickness_glow_desc = "The thickness of the lines in the glow animation."
--L.scale = "Scale"
--L.scale_glow_desc = "The scale of the sparks in the animation."
--L.startAnimation = "Start Animation"
--L.startAnimation_glow_desc = "This glow has a starting animation, this will enable/disable that animation."

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
--L.pullStartedBy = "Pull timer started by %s."
L.pullStopped = "Pull cancelado por %s."
L.pullStoppedCombat = "Temporizador cancelado porque você entrou em combate."
L.pullIn = "Pull em %d seg"
--L.sendPull = "Sending a pull timer to your group."
--L.wrongPullFormat = "Invalid pull timer. A correct example is: /pull 5"
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
--L.privateaura = "Whenever a 'Private Aura' is on you"

L.sound = "Som"

L.customSoundDesc = "Reproduzir um som personalizado ao invés do padrão do módulo."
L.resetSoundDesc = "Reinicia os sons acima para os padrões."
L.resetAllCustomSound = "Se você personalizou sons para qualquer configuração de encontro, este botão ira redefinir TODOS eles para que os sons definidos aqui sejam utilizados."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossStatistics = "Estatísticas do chefe."
L.bossStatsDescription = "Recording of various boss-related statistics such as the amount of times you were victorious, the amount of times you were defeated, date of first victory, and the fastest victory. Estas estatísticas podem ser visualizadas na tela de cada chefe, mas estará oculta para chefes que não têm estatísticas gravadas."
L.createTimeBar = "Mostrar barra do melhor tempo"
L.bestTimeBar = "Melhor tempo"
L.healthPrint = "Vida: %s."
L.healthFormat = "%s (%.1f%%)"
L.chatMessages = "Conversas"
--L.newFastestVictoryOption = "New fastest victory"
--L.victoryOption = "You were victorious"
--L.defeatOption = "You were defeated"
L.bossHealthOption = "Vida do chefe"
--L.bossVictoryPrint = "You were victorious against '%s' after %s." -- You were victorious against 'BOSS_NAME' after COMBAT_DURATION.
--L.bossDefeatPrint = "You were defeated by '%s' after %s." -- You were defeated by 'BOSS_NAME' after COMBAT_DURATION.
--L.newFastestVictoryPrint = "New fastest victory: (-%s)" -- New fastest victory: (-COMBAT_DURATION)

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
