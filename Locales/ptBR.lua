local L = BigWigsAPI:NewLocale("BigWigs", "ptBR")
if not L then return end

-- Core.lua
L.berserk = "Frenesi"
L.berserk_desc = "Mostra uma barra e um contador para quando o chefe entrar em Frenesi."
L.altpower = "Alterar como o poder é mostrado"
L.altpower_desc = "Mostra a janela alternativa de poder, que mostra o quanto de poder alternativo os membros do grupo têm."
L.infobox = "Caixa de informações"
L.infobox_desc = "Exibe uma caixa com informações relacionadas ao encontro."
L.stages = "Estágios"
L.stages_desc = "Ativar funções relacionadas às várias fases do encontro com o chefe, como alertas de mudança de fase, barras de temporizador de duração da fase, etc."
L.warmup = "Preparar"
L.warmup_desc = "Tempo até o combate com o chefe começar."
L.proximity = "Exibição de proximidade"
L.proximity_desc = "Mostra a janela de proximidade quando for apropriada para este encontro, listando os jogadores que estão muito pertos de você."
L.adds = "Adds"
L.adds_desc = "Ativar funções relacionadas aos vários adds que aparecerão durante o encontro com o chefe."
L.health = "Vida"
L.health_desc = "Ativa funções para exibir várias informações de vida durante o encontro com o chefe."

L.already_registered = "|cffff0000ATENÇÃO:|r |cff00ff00%s|r (|cffffff00%s|r) já existe como um módulo do BigWigs, mas as vezes ele tenta registra-lo novamente. Isso normalmente significa que você tem duas cópias deste módulo na sua pasta de addons devido a alguma falha ao atualizar um addon. É recomendado que você delete todas as pastas do BigWigs existentes e reinstale-o novamente."

-- Loader / Options.lua
L.okay = "Ok"
L.officialRelease = "Você está executando uma versão oficial do BigWigs %s (%s)"
L.alphaRelease = "Você está executando uma versão ALPHA do BigWigs %s (%s)"
L.sourceCheckout = "Você está executando uma cópia de código do BigWigs %s diretamente do repositório."
L.littlewigsOfficialRelease = "Você está executando uma versão oficial do LittleWigs (%s)"
L.littlewigsAlphaRelease = "Você está executando uma versão ALPHA do LittleWigs (%s)"
L.littlewigsSourceCheckout = "Você está executando uma cópia de código do LittleWigs diretamente do repositório."
L.guildRelease = "Você está usando a versão %d do BigWigs feito para sua guilda, baseado na versão %d do addon oficial."
L.getNewRelease = "Seu BigWigs está desatualizado (/bwv) mas você pode facilmente atualizá-lo usando o CurseForge Client. Como alternativa, você pode atualizar manualmente em curseforge.com ou wowinterface.com."
L.warnTwoReleases = "Seu BigWigs está 2 versões desatualizado! Sua versão provavelmente contém bugs, faltam funcionalidades, ou possui contadores incorretos. É extremamente recomendado uma atualização."
L.warnSeveralReleases = "|cffff0000Seu BigWigs está %d versões desatualizado!! Nós recomendamos EXTREMAMENTE a atualização para prevenir problemas de sincronização com outros jogadores!|r"
L.warnOldBase = "Você está usando uma versão de guilda do BigWigs (%d), mas sua versão base (%d) está %d versões desatualizada. Isso pode causar problemas."

L.tooltipHint = "|cffeda55fClique-Direito|r para acessar as opções."
L.activeBossModules = "Módulos de chefes ativos:"

L.oldVersionsInGroup = "Há pessoas com |cffff0000versões antigas|r do BigWigs. Você pode conseguir mais detalhes usando /bwv."
L.upToDate = "Atualizado:"
L.outOfDate = "Desatualizado:"
L.dbmUsers = "Usuários do DBM:"
L.noBossMod = "Sem mod de chefes:"
L.offline = "Desconectado"

L.missingAddOnPopup = "O addon |cFF436EEE%s|r está faltando!"
L.missingAddOnRaidWarning = "Está faltando o |cFF436EEE%s|r addon! Nenhum temporizador será mostrado nesta área!"
L.outOfDateAddOnPopup = "O |cFF436EEE%s|r addon está desatualizado!"
L.outOfDateAddOnRaidWarning = "O |cFF436EEE%s|r addon está desatualizado! Você tem v%d.%d.%d a versão mais nova é v%d.%d.%d!"
L.disabledAddOn = "Você desabilitou o addOn |cFF436EEE%s|r, contadores não serão exibidos."
L.removeAddOn = "Por favor remova '|cFF436EEE%s|r' porque este foi substituído por '|cFF436EEE%s|r'."
L.alternativeName = "%s (|cFF436EEE%s|r)"
L.outOfDateContentPopup = "AVISO!\nVocê atualizou |cFF436EEE%s|r mas você também precisa atualizar o principal |cFF436EEEBigWigs|r addon.\nIgnorar este aviso irá ocasionar quebra de funionalidades."
L.outOfDateContentRaidWarning = "|cFF436EEE%s|r requer a versão %d do principal |cFF436EEEBigWigs|r addon para funcionar corretamente, mas você está na versão %d."

L.expansionNames = {
	"Classic", -- Classic
	"The Burning Crusade", -- The Burning Crusade
	"Wrath of the Lich King", -- Wrath of the Lich King
	"Cataclysm", -- Cataclysm
	"Mists of Pandaria", -- Mists of Pandaria
	"Warlords of Draenor", -- Warlords of Draenor
	"Legion", -- Legion
	"Battle for Azeroth", -- Battle for Azeroth
	"Shadowlands", -- Shadowlands
	"Dragonflight", -- Dragonflight
	"The War Within", -- The War Within
}
L.littleWigsExtras = {
	["LittleWigs_Delves"] = "Delves",
	["LittleWigs_CurrentSeason"] = "Temporada Atual",
}

-- Media.lua (These are the names of the sounds in the dropdown list in the "sounds" section)
L.Beware = "Cuidado (Algalon)"
L.FlagTaken = "Bandeira capturada (JvJ)"
L.Destruction = "Destruição (Kil'jaeden)"
L.RunAway = "Corra, garotinha! (Lobo Mau)"
L.spell_on_you = "BigWigs: Feitiço em você"
L.spell_under_you = "BigWigs: Feitiço debaixo de você"

-- Options.lua
L.options = "Opções"
L.optionsKey = "ID: %s" -- The ID that messages/bars/options use
L.raidBosses = "Chefes de Raide"
L.dungeonBosses = "Chefes de Masmorra"
L.introduction = "Bem-vindo ao BigWigs, onde os encontros com chefes vagam. Por favor, aperte seu cinto, prepare um lanchinho e desfrute do passeio. Não iremos acabar com todos os problemas, mas vamos ajudar a se preparar para todos esses novos encontros de chefe como um jantar chique para todo o seu grupo de raide."
L.sound = "Som"
L.minimapIcon = "Ícone do minimapa"
L.minimapToggle = "Altera mostrar/ocultar o ícone do minimapa."
L.compartmentMenu = "Sem icone de compartimento"
L.compartmentMenu_desc = "Desativar esta opção fará com que BigWigs apareça no menu do compartimento de Addons. Recomendamos deixar esta opção habilitada."
L.configure = "Configurar"
L.resetPositions = "Resetar posições"
L.selectEncounter = "Selecionar Encontro"
L.privateAuraSounds = "Sons de Auras Privadas"
L.privateAuraSounds_desc = "Auras privadas não podem ser rastreadas normalmente, mas você pode definir um som para ser reproduzido quando você for alvo da habilidade."
L.listAbilities = "Listar habilidades no bate-papo do grupo"

L.dbmFaker = "Faz de conta que eu estou usando DBM"
L.dbmFakerDesc = "Se um usuário do DBM tem uma versão que verifica quem está usando DBM, ele irá vê-lo na lista. Útil para guildas que forçam usar o DBM."
L.zoneMessages = "Mostrar mensagens da zona atual"
L.zoneMessagesDesc = "Desativar isso irá parar de mostrar mensagens quando você entra em uma zona que BigWigs possui contadores, mas você não o instalou. Nós recomendamos que você deixe ligado, pois é a única notificação que você vai receber se nós criarmos contadores para uma nova zona que você ache útil."
L.englishSayMessages = "Mensagens de 'Diz' apenas em inglês"
L.englishSayMessagesDesc = "Todas as mensagens 'Diz' e 'Grita' que você enviar no bate-papo durante um encontro com o chefe serão sempre em inglês. Pode ser útil se você estiver com um grupo de jogadores de idiomas mistos."

L.slashDescTitle = "|cFFFED000Comandos com barra:|r"
L.slashDescPull = "|cFFFED000/pull:|r Envia uma contagem regressiva do pull para a raide."
L.slashDescBreak = "|cFFFED000/break:|r Envia uma pausa dos contadores para a raide."
L.slashDescRaidBar = "|cFFFED000/raidbar:|r Envia uma barra personalizada para a raide."
L.slashDescLocalBar = "|cFFFED000/localbar:|r Cria uma barra personalizada que apenas você pode ver."
L.slashDescRange = "|cFFFED000/range:|r Abre o indicador de distância."
L.slashDescVersion = "|cFFFED000/bwv:|r Realiza uma verificação da versão do BigWigs."
L.slashDescConfig = "|cFFFED000/bw:|r Abre a configuração do BigWigs."

L.gitHubDesc = "|cFF33FF99BigWigs é um software de código aberto hospedado no GitHub. Nós sempre estamos procurando por novas pessoas para ajudar e todos são bem-vindos para dar uma olhada no nosso código, fazer contribuições e reportar erros. BigWigs é incrível como é hoje, na maioria das vezes, devido a toda comunidade do WoW que nos ajuda.|r"

L.BAR = "Barras"
L.MESSAGE = "Mensagens"
L.ICON = "Ícone"
L.SAY = "Diz"
L.FLASH = "Piscar"
L.EMPHASIZE = "Enfatizar"
L.ME_ONLY = "Apenas quando em mim"
L.ME_ONLY_desc = "Quando você ativar esta opção, mensagens para esta habilidade serão exibidas somente quando afetar você. Por exemplo: 'Bomba: Jogador' só será mostrado se for em você."
L.PULSE = "Pulso"
L.PULSE_desc = "Além de piscar na tela, você também pode ter um ícone relacionado com esta habilidade específica exibido momentaneamente no centro da tela para tentar chamar a sua atenção."
L.MESSAGE_desc = "A maioria das habilidades de encontro vem com uma ou mais mensagens que BigWigs irá mostrar na tela. Se você desativar esta opção, nenhuma das mensagens anexadas a esta opção, se houverem, serão exibidas."
L.BAR_desc = "Quando apropriado, barras são exibidas para algumas habilidades de encontro. Se essa habilidade é acompanhada por uma barra que você deseja ocultar, desabilite esta opção."
L.FLASH_desc = "Algumas habilidades podem ser mais importantes do que outras. Se você quiser que sua tela pisque quando essa habilidade está próxima ou for usada, marque esta opção."
L.ICON_desc = "BigWigs pode marcar os personagens afetados pelas habilidades com um ícone. Isso os torna mais fáceis de detectar."
L.SAY_desc = "Balões de mensagem são fáceis de detectar. BigWigs mostrará uma mensagem de /falar para anunciar as pessoas próximas sobre um efeito em você."
L.EMPHASIZE_desc = "Ativando esta opção, irá enfatizar quaisquer mensagens associadas a esta habilidade, fazendo-a maior e mais visível. Você pode ajustar o tamanho e a fonte da mensagem enfatizada nas opções principais em \"Mensagens\""
L.PROXIMITY = "Exibição de proximidade"
L.PROXIMITY_desc = "Habilidades as vezes requerem que vocês se espalhem. A exibição de proximidade será criada especialmente para essa habilidade, assim você pode ver rapidamente se está seguro ou não."
L.ALTPOWER = "Exibição de poder alternativo"
L.ALTPOWER_desc = "Alguns encontros usarão a mecânica de poder alternativo em jogadores em seu grupo. A exibição de poder alternativo fornece uma visão geral de quem tem o menor/maior poder, podendo ser útil para táticas ou atribuições específicas."
L.TANK = "Apenas Tanques"
L.TANK_desc = "Algumas habilidades são importantes apenas para os tanques. Se você quiser ver avisos para essa habilidade, independentemente do seu papel, desative esta opção."
L.HEALER = "Apenas Curandeiros"
L.HEALER_desc = "Algumas habilidades são importantes apenas para os curandeiros. Se você quiser ver avisos para essa habilidade, independentemente do seu papel, desative esta opção."
L.TANK_HEALER = "Apenas Tanques e Curandeiros"
L.TANK_HEALER_desc = "Algumas habilidades são importantes apenas para os tanques e curandeiros. Se você quiser ver avisos para essa habilidade, independentemente do seu papel, desative esta opção."
L.DISPEL = "Apenas Dissipadores"
L.DISPEL_desc = "Se você quiser ver avisos para essa habilidade, mesmo quando você não pode dissipa-lo, desative esta opção."
L.VOICE = "Voz"
L.VOICE_desc = "Se você tiver um plugin de voz instalado, esta opção lhe permitirá reproduzir um arquivo de som que fala este aviso em voz alta para você."
L.COUNTDOWN = "Contagem Regressiva"
L.COUNTDOWN_desc = "Se ativado, uma contagem regressiva sonora e visual será adicionado para os últimos 5 segundos. Imagine alguém contando regressivamente \"5... 4... 3... 2... 1...\" com um número grande no meio da tela."
L.CASTBAR_COUNTDOWN = "Contagem regressiva (Apenas barras de lançamento)"
L.CASTBAR_COUNTDOWN_desc = "Se ativado, uma contagem regressiva vocal e visual será adicionada nos últimos 5 segundos das barras de lançamento."
L.INFOBOX = L.infobox
L.INFOBOX_desc = L.infobox_desc
L.SOUND = L.sound
L.SOUND_desc = "Habilidades de chefe normalmente tocam sons para lhe ajudar a vê-las. Se você desabilitar esta opção, nenhum dos sons anexados a ele irão tocar."
L.CASTBAR = "Barras de Conjuração"
L.CASTBAR_desc = "Barras de Conjuração são mostradas as vezes em alguns chefes, normalmente para chamar a atenção para uma habilidade crítica. Se essa habilidade vem acompanhada de uma barra de conjuração que você quer esconder, desabilite essa opção."
L.SAY_COUNTDOWN = "Dizer Contagem Regressiva"
L.SAY_COUNTDOWN_desc = "Bolhas de bate-papo são fáceis de ver. BigWigs irá usar o bate-papo dizer para enviar várias mensagens de contagem regressiva para alertar pessoas ao seu redor que uma habilidade está para expirar."
L.ME_ONLY_EMPHASIZE = "Enfatizar (somente a mim)"
L.ME_ONLY_EMPHASIZE_desc = "Habilitar isso irá enfatizar qualquer mensagem associada a essa habilidade SOMENTE se for conjurada em você, fazenda elas mais largas e mais visíveis."
L.NAMEPLATE = "Placas Identificadoras"
L.NAMEPLATE_desc = "Se habilitado, recursos como ícones e texto relacionados a essa habilidade específica serão exibidos em suas placas de identificação. Isso torna mais fácil ver qual NPC específico está lançando uma habilidade quando há vários NPCs que a lançam."
L.PRIVATE = "Aura Privada"
L.PRIVATE_desc = "Auras privadas não podem ser rastreadas normalmente, mas o som \"em você\" (Aviso) pode ser definido na guia Som."

L.advanced_options = "Opções Avançadas"
L.back = "<< Voltar"

L.tank = "|cFFFF0000Alertas para Tanques apenas.|r "
L.healer = "|cFFFF0000Alertas para Curandeiros apenas.|r "
L.tankhealer = "|cFFFF0000Alertas para Tanques e Curandeiros.|r "
L.dispeller = "|cFFFF0000Alerta para Dissipadores apenas.|r "

-- Sharing.lua
L.import = "Importar"
L.import_info = "Depois de adicionar o código de importação, você pode selecionar quais configurações você gostaria de importar.\nSe as configurações não estiverem disponíveis no código importado, elas não poderão ser selecionadas.\n\n|cffff4411Essa importação afetará somente as configurações específicas do chefe.|r"
L.import_info_active = "Escolha quais partes você gostaria de importar e clique no botão importar."
L.import_info_none = "|cFFFF0000O código de importação está incompatível ou desatualizado.|r"
L.export = "Exportar"
L.export_info = "Selecione quais configurações você gostaria de exportar e compartilhar com os outros.\n\n|cffff4411Você só pode compartilhar configurações gerais e elas não afetam as configurações específicas de chefes.|r"
L.export_string = "Exportar Código"
L.export_string_desc = "Copie o código BigWigs se você quiser compartilhar suas configurações."
L.import_string = "Importar Configurações"
L.import_string_desc = "Cole o código BigWigs aqui para fazer a importação."
L.position = "Posição"
L.settings = "Configurações"
L.other_settings = "Outras configurações"
L.nameplate_settings_import_desc = "Importar configurações de todas as placas de identificação."
L.nameplate_settings_export_desc = "Exportar configurações de todas as placas de identificação."
L.position_import_bars_desc = "Importar as posições (âncoras) das barras."
L.position_import_messages_desc = "Importar as posições (âncoras) das mensagens."
L.position_import_countdown_desc = "Importar as posições (âncoras) dos contadores."
L.position_export_bars_desc = "Exportar as posições (âncoras) das barras."
L.position_export_messages_desc = "Exportar as posições (âncoras) das mensagens."
L.position_export_countdown_desc = "Exportar as posições (âncoras) do contador."
L.settings_import_bars_desc = "Importar as configurações gereais das barras como tamanho, fonte, etc."
L.settings_import_messages_desc = "Importar as configurações gerais das mensagens como tamanho, fonte, etc."
L.settings_import_countdown_desc = "Importar as configurações gerais do contador como voz, tamanho, fonte, etc."
L.settings_export_bars_desc = "Exportar as configurações gerais das barras como tamanho, fonte, etc."
L.settings_export_messages_desc = "Exportar as configurações gerais das mensagens como tamanho, fonte, etc."
L.settings_export_countdown_desc = "Exportar a configuração geral do contador como voz, tamanho, fonte, etc."
L.colors_import_bars_desc = "Importar as cores das barras."
L.colors_import_messages_desc = "Importar as cores das mensagens."
L.color_import_countdown_desc = "Importar a cor do contador."
L.colors_export_bars_desc = "Exportar as cores das barras."
L.colors_export_messages_desc = "Exportar as cores das mensagens."
L.color_export_countdown_desc = "Exportar a cor do contador."
L.confirm_import = "As configurações selecionadas que você está prestes a importar substituirão as configurações do perfil atualmente selecionado:\n\n|cFF33FF99\"%s\"|r\n\nVocê tem certeza que deseja fazer isso?"
L.confirm_import_addon = "O addon |cFF436EEE\"%s\"|r deseja importar automaticamente novas configurações do BigWigs que substituirão as configuraçoes do seu perfil do BigWigs atualmente selecionado:\n\n|cFF33FF99\"%s\"|r\n\nVocê tem certeza que deseja fazer isso?"
L.confirm_import_addon_new_profile = "O addon |cFF436EEE\"%s\"|r deseja criar automaticamente um novo perfil BigWigs chamado:\n\n|cFF33FF99\"%s\"|r\n\nAceitar esse novo perfil também mudará para ele."
L.confirm_import_addon_edit_profile = "O addon |cFF436EEE\"%s\"|r deseja editar automaticamente um de seus perfis BigWings chamado:\n\n|cFF33FF99\"%s\"|r\n\nAceitar essa mudança também mudará para ele."
L.no_string_available = "Nenhum código de importação armazenado para importar. Primeiro adicione um código de importação."
L.no_import_message = "Nenhuma configuração foi importada."
L.import_success = "Importado: %s" -- Imported: Bar Anchors, Message Colors
L.imported_bar_positions = "Posição das Barras"
L.imported_bar_settings = "Configuração das Barras"
L.imported_bar_colors = "Cores das Barras"
L.imported_message_positions = "Posição das Mensagens"
L.imported_message_settings = "Configurações das Mensagens"
L.imported_message_colors = "Cores das Mensagens"
L.imported_countdown_position = "Posição do Contador"
L.imported_countdown_settings = "Configurações do Contador"
L.imported_countdown_color = "Cores do Contador"
L.imported_nameplate_settings = "Configurações de Placas Identificadoras"

-- Statistics
L.statistics = "Estatísticas"
L.defeat = "Derrotado"
L.defeat_desc = "A quantidade total de vezes que você foi derrotado por esse chefe."
L.victory = "Vitória"
L.victory_desc = "A quantidade total de vezes que você venceu a luta com esse chefe."
L.fastest = "Rápido"
L.fastest_desc = "A vitória mais rápida e a data em que ocorreu. (Ano/Mês/Dia)"
L.first = "Primeiro"
L.first_desc = "A primeira vez que você venceu a luta com esse chefe, formatado como:\n[Quantidade de derrotas antes da primeira vitória] - [Duração do combate] - [Ano/Mês/Dia da vitória]"

-- Difficulty levels for statistics display on bosses
L.unknown = "Desconhecido"
L.LFR = "LDR"
L.normal = "Normal"
L.heroic = "Heroico"
L.mythic = "Mítico"
L.timewalk = "Caminhada Temporal"
L.story = "Histórias"
L.mplus = "Mítica+ %d"
L.SOD = "Temporada de Descobertas"
L.hardcore = "Hardcore"
L.level1 = "Nível 1"
L.level2 = "Nível 2"
L.level3 = "Nível 3"
L.N10 = "Normal 10"
L.N25 = "Normal 25"
L.H10 = "Heroico 10"
L.H25 = "Heroico 25"



-----------------------------------------------------------------------
-- PLUGINS
-----------------------------------------------------------------------

L.general = "Geral"
L.advanced = "Avançado"
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
L.UP = "Cima"
L.DOWN = "Baixo"
L.TOP = "Topo"
L.RIGHT = "Direita"
L.BOTTOM = "Base"
L.LEFT = "Esquerda"
L.TOPRIGHT = "Superior Direito"
L.TOPLEFT = "Superior Esquerdo"
L.BOTTOMRIGHT = "Inferior Direito"
L.BOTTOMLEFT = "Inferior Esquerdo"
L.CENTER = "Centro"
L.customAnchorPoint = "Avançado: Ponto de âncora personalizado"
L.sourcePoint = "Ponto de Origem"
L.destinationPoint = "Ponto de Destino"

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
L.emphasize = L.EMPHASIZE
L.emphasizeMultiplier = "Multiplicador de Tamanho"
L.emphasizeMultiplierDesc = "Se você desabilitar as barras movendo-as para a âncora em destaque, esta opção irá decidir qual tamanho as barras em destaque terão, ao se multiplicar o tamanho das barras normais."

L.enable = "Habilitar"
L.move = "Mover"
L.moveDesc = "Move barras enfatizadas para a âncora de Enfatizar. Se esta opção estiver desativada, barras enfatizadas terão apenas sua cor e tamanho alterados."
L.emphasizedBars = "Barras enfatizadas"
L.align = "Alinhamento"
L.alignText = "Alinhar texto"
L.alignTime = "Alinhar tempo"
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
L.visibleBarLimitDesc = "Configrua a quantidade máxima de barras visíveis ao mesmo tempo."

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
L.blockTooltipQuestsDesc = "Quando você precisa matar um chefe para uma missão, normalmente irá mostrar '0/1 completo' na barra de dica quando você passa o mouse pelo chefe. Isso será escondido quando em combate com o chefe para prevenir que a barra de dica fique muito grande."
L.blockObjectiveTracker = "Esconder rastreador de missão"
L.blockObjectiveTrackerDesc = "O rastreador de objetivos de missão será escondido durante um encontro de chefe para liberar espaço na tela.\n\nIsso NÃO irá acontecer se você estiver em uma Mítica+ ou estiver rastreando uma conquista."

L.blockTalkingHead = "Esconder o popup de diálogo 'Cabeça Falante' do NPC"
L.blockTalkingHeadDesc = "A 'Cabeça Falante' é um popup de diálogo que tem uma cabeça do NPC e um texto de chat embaixo no meio da tela que |cffff4411às vezes|r é mostrada quando um NPC está falando.\n\nVocê pode escolher diferentes tipos de instâncias para quando isso deve ser bloqueado de ser mostrado.\n\n|cFF33FF99Por favor note que:|r\n 1) Essa funcionalidade irá permitir que a voz do NPC continue reproduzindo para que você continue a ouvi-lo.\n 2) Por segurança, somente cabeças falantes específicas serão bloqueadas. Qualquer uma especial ou única, como as missões de uma única vez, não serão bloqueadas."
L.blockTalkingHeadDungeons = "Masmorras Normal & Heróica"
L.blockTalkingHeadMythics = "Masmorras Míticas & Míticas+"
L.blockTalkingHeadRaids = "Raides"
L.blockTalkingHeadTimewalking = "Caminhada Temporal (Masmorras & Raides)"
L.blockTalkingHeadScenarios = "Cenários"

L.redirectPopups = "Redirecionar banners pop-up para mensagens do BigWigs"
L.redirectPopupsDesc = "Banners pop-up no meio da sua tela, como o banner '|cFF33FF99slot de baú desbloqueado|r', serão exibidos como mensagens do BigWigs. Esses banners podem ser bastante grandes, durar muito tempo e impedir sua capacidade de clicar através deles."
L.redirectPopupsColor = "Cor da mensagem redirecionada"
L.blockDungeonPopups = "Bloquear banners pop-up em masmorras"
L.blockDungeonPopupsDesc = "Os banners de pop-up que aparecem ao entrar em uma masmorra às vezes podem conter textos muito longos. Ativar essa função os bloqueará completamente."
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
L.expiring_normal = "Normal"
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
L.greenDesc = "Alertas para coisas boas que acontecem, como efeitos negativos sendo removidos de você."
L.cyan = "Ciano"
L.cyanDesc = "Alertas para troca de status do encontro, como ao avançar para a próxima fase do chefe."
L.purple = "Roxo"
L.purpleDesc = "Alertas para habilidades específicas de tanque, como stacks de efeitos negativos no tanque."

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

L.infobox_short = "Caixa de Informações"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Redireciona a saída deste addOn pela exibição de mensagens do BigWigs. Ela dá suporte a ícones, cores e pode mostrar até 4 mensagens na tela de uma vez. Mensagens novas crescerão de tamanho e encolherão de novo rapidamente para notificar o usuário."
L.emphasizedSinkDescription = "Redireciona a saída deste addOn pela exibição de mensagens enfatizadas do BigWigs. Ele dá suporte a texto e cores, e só exibe uma mensagem por vez."
L.resetMessagesDesc = "Reinicia todas as opções relacionadas a mensagens, incluindo a posição de âncora das mensagens."
L.toggleMessagesAnchorsBtnShow_desc = "Mostra todas as âncoras de movimentação, permitindo que você mova as mensagens."

L.testMessagesBtn = "Criar Mensagem de Teste"
L.testMessagesBtn_desc = "Cria uma mensagem para você testar suas configurações de exibição atuais."

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

L.nameplates = "Placas de Identificação"
L.testNameplateIconBtn = "Mostrar ícone de teste"
L.testNameplateIconBtn_desc = "Cria um ícone de teste para você testar suas configurações de exibição atuais na placa de identificação de seu alvo."
L.testNameplateTextBtn = "Mostrar texto de teste"
L.testNameplateTextBtn_desc = "Cria um texto de teste para você testar suas configurações de texto atuais na placa de identificação de seu alvo."
L.stopTestNameplateBtn = "Parar testes"
L.stopTestNameplateBtn_desc = "Para o ícone e os testes de texto em suas placas de identificação."
L.noNameplateTestTarget = "Você precisa ter um alvo hostil que possa ser atacado selecionado para testar a funcionalidade da placa de identificação."
L.anchoring = "Ancoragem"
L.growStartPosition = "Posição inicial do crescimento"
L.growStartPositionDesc = "A posição inicial para o primeiro ícone."
L.growDirection = "Direção de crescimento"
L.growDirectionDesc = "A direção que os ícones irão crescer a partir da posição inicial."
L.iconSpacingDesc = "Muda o espaço entre cada ícone."
L.nameplateIconSettings = "Configurações de ícone"
L.keepAspectRatio = "Manter proporção"
L.keepAspectRatioDesc = "Manter a proporção do ícone 1:1 ao invés de esticá-lo para caber no tamanho do quadro."
L.iconColor = "Cor do ícone"
L.iconColorDesc = "Mudar a cor da textura do ícone."
L.desaturate = "Desaturar"
L.desaturateDesc = "Desaturar a textura do ícone."
L.zoom = "Zoom"
L.zoomDesc = "Aumentar a textura do ícone."
L.showBorder = "Mostrar borda"
L.showBorderDesc = "Mostrar uma borda ao redor do ícone."
L.borderColor = "Cor da borda"
L.borderSize = "Tamanho da borda"
L.showNumbers = "Mostrar números"
L.showNumbersDesc = "Mostrar números no ícone."
L.cooldown = "Tempo de recarga"
L.showCooldownSwipe = "Mostrar varredura"
L.showCooldownSwipeDesc = "Mostrar uma varredura no ícone quando o tempo de recarga estiver ativo."
L.showCooldownEdge = "Mostrar borda"
L.showCooldownEdgeDesc = "Mostrar uma borda no tempo de recarga quando o tempo de recarga estiver ativo."
L.inverse = "Inverter"
L.inverseSwipeDesc = "Inverter as animações do tempo de recarga."
L.glow = "Brilho"
L.enableExpireGlow = "Habilitar brilho ao expirar"
L.enableExpireGlowDesc = "Mostrar um brilho ao redor do ícone quando o tempo de recarga tiver expirado."
L.glowColor = "Cor do brilho"
L.glowType = "Tipo de brilho"
L.glowTypeDesc = "Mudar o tipo de brilho que será mostrado ao redor do ícone."
L.resetNameplateIconsDesc = "Reiniciar todas as opções relacionadas aos ícones de placa de identificação."
L.nameplateTextSettings = "Configurações de texto"
L.fixate_test = "Teste de Fixar" -- Texto que exibe para testar no quadro
L.resetNameplateTextDesc = "Reiniciar todas as opções relacionadas ao texto da placa de identificação."
L.glowAt = "Começar brilho (segundos)"
L.glowAt_desc = "Escolha quantos segundos no tempo de recarga devem restar quando o brilho começar."
L.headerIconSizeTarget = "Tamanho do íncone do seu alvo atual"
L.headerIconSizeOthers = "Tamanho do íncone de todos os outros alvos"

-- Tipos de brilho como parte de LibCustomGlow
L.pixelGlow = "Brilho de Pixel"
L.autocastGlow = "Brilho de Auto-Conjuração"
L.buttonGlow = "Brilho de Botão"
L.procGlow = "Brilho de Proc"
L.speed = "Velocidade"
L.animation_speed_desc = "A velocidade com que a animação de brilho será reproduzida."
L.lines = "Linhas"
L.lines_glow_desc = "O número de linhas na animação de brilho."
L.intensity = "Intensidade"
L.intensity_glow_desc = "A intensidade do efeito de brilho, quanto maior, mais faíscas."
L.length = "Comprimento"
L.length_glow_desc = "O comprimento das linhas na animação de brilho."
L.thickness = "Espessura"
L.thickness_glow_desc = "A espessura das linhas na animação de brilho."
L.scale = "Escala"
L.scale_glow_desc = "A escala das faíscas na animação."
L.startAnimation = "Iniciar Animação"
L.startAnimation_glow_desc = "Esse brilho tem uma animação inicial, isso irá habilitar/desabilitar essa animação."

-----------------------------------------------------------------------
-- Proximity.lua
--

L.customRange = "Indicador de distância personalizado"
L.proximityTitle = "%d m / %d |4jogador:jogadores;"
L.proximity_name = "Proximidade"
L.soundDelay = "Atraso de som"
L.soundDelayDesc = "Especifique o tempo que BigWigs deverá esperar para repetir o som de quando alguém está muito perto de você."

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
L.pullStartedBy = "Temporizador de pull iniciado por %s."
L.pullStopped = "Pull cancelado por %s."
L.pullStoppedCombat = "Temporizador cancelado porque você entrou em combate."
L.pullIn = "Pull em %d seg"
L.sendPull = "Enviando um temporizador de pull para seu grupo."
L.wrongPullFormat = "Temporizador de pull inválido. Um exemplo correto seria: /pull 5"
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
L.privateaura = "Sempre que uma 'Aura Privada' está em você"

L.customSoundDesc = "Reproduzir um som personalizado ao invés do padrão do módulo."
L.resetSoundDesc = "Reinicia os sons acima para os padrões."
L.resetAllCustomSound = "Se você personalizou sons para qualquer configuração de encontro, este botão ira redefinir TODOS eles para que os sons definidos aqui sejam utilizados."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossStatistics = "Estatísticas do chefe."
L.bossStatsDescription = "Gravação de várias estatísticas relacionadas a chefes, como a quantidade de vezes que você foi vitorioso, a quantidade de vezes que foi derrotado, a data da primeira vitória, e a vitória mais rápida. Estas estatísticas podem ser visualizadas na tela de cada chefe, mas estará oculta para chefes que não têm estatísticas gravadas."
L.createTimeBar = "Mostrar barra do melhor tempo"
L.bestTimeBar = "Melhor tempo"
L.healthPrint = "Vida: %s."
L.healthFormat = "%s (%.1f%%)"
L.chatMessages = "Conversas"
L.newFastestVictoryOption = "Nova vitória mais rápida"
L.victoryOption = "Você foi vitorioso"
L.defeatOption = "Você foi derrotado"
L.bossHealthOption = "Vida do chefe"
L.bossVictoryPrint = "Você foi vitorioso contra '%s' após %s." -- You were victorious against 'BOSS_NAME' after COMBAT_DURATION.
L.bossDefeatPrint = "Você foi derrotado por '%s' após %s." -- You were defeated by 'BOSS_NAME' after COMBAT_DURATION.
L.newFastestVictoryPrint = "Nova vitória mais rápida: (-%s)" -- New fastest victory: (-COMBAT_DURATION)

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
