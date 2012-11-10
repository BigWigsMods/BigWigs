local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "ptBR")
if not L then return end
-----------------------------------------------------------------------
-- Bars.lua
--


L["Style"] = "Estilo"
L.bigWigsBarStyleName_Default = "Padrão"

L["Clickable Bars"] = "Barras clicaveis"
L.clickableBarsDesc = "As barras do Big Wigs são clicaveis por padrão. Desta forma você pode mirar em objetos e lançar feitiços AoE atrás deles, trocar o ângulo da câmera, e assim sucessivamente, sem precisar do cursor estar em cima das barras. |cffff4411Se habilitar as barras clicaveis, isto deixará de funcionar.|r as barras interceptarão qualquer clique do mouse que chegar a elas.\n"
L["Enables bars to receive mouse clicks."] = "Ativa as barras para receber cliques do mouse"
L["Modifier"] = "Modificação"
L["Hold down the selected modifier key to enable click actions on the timer bars."] = "Segure a tecla de modificação selecionada para ativar ações de cliques nas barras de tempo."
L["Only with modifier key"] = "Somente com uma tecla de modificação"
L["Allows bars to be click-through unless the specified modifier key is held down, at which point the mouse actions described below will be available."] = "Permite que as barras sejão clicaveis se estiver com a tecla de modificação pressionada, deste jeito as ações do mouse descritas abaixo estarão disponíveis."

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = "Temporariamente Super Enfatiza a barra e as mensagens associadas para a duração."
L["Report"] = "Reportar"
L["Reports the current bars status to the active group chat; either battleground, raid, party or guild, as appropriate."] = "Reporta o estado das barras atuais no chat do grupo ativo; cb, raide, grupo ou guilda, o mais apropriado."
L["Remove"] = "Remover"
L["Temporarily removes the bar and all associated messages."] = "Temporariamente fecha a barra e todas as mensagens associadas"
L["Remove other"] = "Remover outro"
L["Temporarily removes all other bars (except this one) and associated messages."] = "Temporariamente fecha todas as barras (exceto esta) e as mensagens associadas."
L["Disable"] = "Desativar"
L["Permanently disables the boss encounter ability option that spawned this bar."] = "Desativa permanentemente a habilidade de encontro para que não de opção de que reapareça esta barra"

L["Scale"] = "Escala"
L["Grow upwards"] = "Aumentar crescentemente"
L["Toggle bars grow upwards/downwards from anchor."] = "Alterna entre aumentar as barras crescentemente/decrescentemente des do encaixe."
L["Texture"] = "Textura"
L["Emphasize"] = "Enfatizar"
L["Enable"] = "Habilitar"
L["Move"] = "Mover"
L["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = "Move as barras enfatizadas aol encaixe de Enfatizar. Se esta opcção estiver desabilitada, as barras enfatizadas simplesmente mudarão a cor e a escala, e pode ser que comecem a piscar."
L["Flash"] = "Piscada"
L["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = "Pisca o fundo da barra enfatizada, fazendo-a mais facil de se ver"
L["Regular bars"] = "Barras regulares"
L["Emphasized bars"] = "Barras enfatizadas"
L["Align"] = "Alinhação"
L["Left"] = "Esquerda"
L["Center"] = "Centro"
L["Right"] = "Direita"
L["Time"] = "Tempo"
L["Whether to show or hide the time left on the bars."] = "Oculta ou mostra o tempo restante nas barras."
L["Icon"] = "Icono"
L["Shows or hides the bar icons."] = "Mostra ou oculta os icones das barras."
L["Font"] = "Fonte"
L["Restart"] = "Reiniciar"
L["Restarts emphasized bars so they start from the beginning and count from 10."] = "Reinicia as barras enfatizadas para que comecem desde o principio e conta desde 10."
L["Fill"] = "Completar"
L["Fills the bars up instead of draining them."] = "Completa as barras ao envés de drenar."

L["Local"] = "Local"
L["%s: Timer [%s] finished."] = "%s: Contador [%s] terminado."
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Tempo inválido (|cffff0000%q|r) ou texto faltoso da barra personalizada iniciada por |cffd9d919%s|r. <time> pode ser um número em segundos, um par M:S, ou Mm. Por exemplo 5, 1:20 ou 2m."

-----------------------------------------------------------------------
-- Colors.lua
--

L["Colors"] = "Cores"

L["Messages"] = "Mensagens"
L["Bars"] = "Barras"
L["Background"] = "Fundo"
L["Text"] = "Texto"
L["Flash and shake"] = "Piscar e tremer"
L["Normal"] = "Normal"
L["Emphasized"] = "Enfatizado"

L["Reset"] = "Reiniciar"
L["Resets the above colors to their defaults."] = "Reinicia as cores padrões"
L["Reset all"] = "Reiniciar tudo"
L["If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."] = "Se você personalizou as cores e os ajustes de alguns encontros de chefe, este botão reiniciará TUDO e usará as cores padrões."

L["Important"] = "Importante"
L["Personal"] = "Pessoal"
L["Urgent"] = "Urgente"
L["Attention"] = "Atenção"
L["Positive"] = "Positivo"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Seguir o padrão do addon deixando as mensagens serem mostradas do jeito padrão do Big Wigs. Isto suporta icones, cores e podem mostrar até 4 mensagens na tela de uma vez. Após inserir as mensagens crescerão de tamanho e encolherão de novo rápidamente para notificar o usuario."
L.emphasizedSinkDescription = "Seguir o padrão de mensagens enfatizadas do Big Wigs. Isto suporta texto e cores, e só podem aparecer uma vez."

L["Messages"] = "Mensagens"
L["Normal messages"] = "Mensagens normais"
L["Emphasized messages"] = "Mensagens enfatizadas"
L["Output"] = "Saida"

L["Use colors"] = "Usar cores"
L["Toggles white only messages ignoring coloring."] = "Mensagens somente de cor branca, ignorando as cores."

L["Use icons"] = "Usar icones"
L["Show icons next to messages, only works for Raid Warning."] = "Mostra os icones após a mensagem, só funciona em alertas de raid."

L["Class colors"] = "Cores das classes"
L["Colors player names in messages by their class."] = "Colore o nome do jogador nas mensagens, com a cor se sua classe"

L["Chat frame"] = "Janela de chat"
L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "Coloca todas as mensagens do BigWigs na janela de chat padrão, em adição da configuração de amostra"

L["Font size"] = "Tamanho da fonte"
L["None"] = "Nenhuma"
L["Thin"] = "Fino"
L["Thick"] = "Grosso"
L["Outline"] = "Contorno"
L["Monochrome"] = "Monocromo"
L["Toggles the monochrome flag on all messages, removing any smoothing of the font edges."] = "Troca o indicador monocromo de todas as mensagens, removendo qualquer embelezamento das fontes."
-----------------------------------------------------------------------
-- RaidIcon.lua
--

L["Icons"] = "Icones"

L.raidIconDescription = "Elementos de tipo 'bomba' e similares em um jogador podem ser de interesse especial. Aqui você pode configurar como se deveria marcar com icones algunos personagens.\n\nSó se usa um icone para cada encontro se usará o primario, nunca se usará o mesmo icone para 2 habilidades distintas, para isto esta o icone secundario.\n\n|cffff4411Nota: Se um jogador foi marcado manualmente o Big Wigs nunca trocará seu icone.|r"
L["Primary"] = "Primário"
L["The first raid target icon that a encounter script should use."] = "O primeiro objetivo da raide, este icone será usado"
L["Secondary"] = "Secundário"
L["The second raid target icon that a encounter script should use."] = "O segundo objetivo da raide, este icone será usado"

L["Star"] = "Estrela"
L["Circle"] = "Círculo"
L["Diamond"] = "Diamante"
L["Triangle"] = "Triângulo"
L["Moon"] = "Lua"
L["Square"] = "Quadrado"
L["Cross"] = "Cruz"
L["Skull"] = "Caveira"
L["|cffff0000Disable|r"] = "|cffff0000Desativar|r"

-----------------------------------------------------------------------
-- Sound.lua
--

L.soundDefaultDescription = "Com esta opção habilitada, Big Wigs usará somente o som padrão da Blizzard para os alertas de raide e para mensagens que chegão com um alerta de som. Nota: Somente algumas mensagens dos scripts de encontros usarão alerta de som."

L["Sounds"] = "Sons"

L["Alarm"] = "Alarme"
L["Info"] = "Info"
L["Alert"] = "Alerta"
L["Long"] = "Longo"
L["Victory"] = "Vitória"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Ajuste o som a se usar para %q.\n\nCtrl-Clique em um som para previsualizar."
L["Default only"] = "Somente padrões"

-----------------------------------------------------------------------
-- Proximity.lua
--

L["|T%s:20:20:-5|tAbility name"] = "|T%s:20:20:-5|tNome da habilidade"
L["Custom range indicator"] = "Indicador de distância personalizado"
L["%d yards"] = "%d yrd/mtr"
L["Proximity"] = "Aproximação"
L["Sound"] = "Som"
L["Disabled"] = "Desativado"
L["Disable the proximity display for all modules that use it."] = "Desativa a janela de aproximação em todos os módulos que a use."
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "A janela de aproximação aparecerá na próxima vez. Para desativala completamente neste encontro, você deve apagala das opções de encontros."
L["Sound delay"] = "Atraso de som"
L["Specify how long Big Wigs should wait between repeating the specified sound when someone is too close to you."] = "Especifique o tempo que Big Wigs deverá esperar entre cada repetição de som quando alguem está muito perto de você."

L.proximity = "Visualizar aproximação"
L.proximity_desc = "Mostra a janela de aproximação quando for apropiada para este encontro, lista os jogadores que estão muito pertos de você."

L["Close"] = "Fechar"
L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = "Fecha a janela de aproximação.\n\nPara desativala completamente para um encontro, tem que ir nas opções deste encontro e desativar a opção de 'Aproximação'."
L["Lock"] = "Bloquear"
L["Locks the display in place, preventing moving and resizing."] = "Trava a janela no lugar, previnindo que se mova e redimensione"
L["Title"] = "Título"
L["Shows or hides the title."] = "Mostra/oculta o título"
L["Background"] = "Fundo"
L["Shows or hides the background."] = "Mostra/oculta o fundo"
L["Toggle sound"] = "Trocar som"
L["Toggle whether or not the proximity window should beep when you're too close to another player."] = "Ativada ou não a janela de aproximação, deverá emitir um beep se estiver perto de outro jogador."
L["Sound button"] = "Botão de som"
L["Shows or hides the sound button."] = "Mostra/oculta o botão de som"
L["Close button"] = "Botão fechar"
L["Shows or hides the close button."] = "Mostra/oculta o botão de fechar"
L["Show/hide"] = "Mostrar/ocultar"
L["Ability name"] = "Nome da habilidade"
L["Shows or hides the ability name above the window."] = "Mostra/oculta o nome da habilidade em cima da janela"
L["Tooltip"] = "Tooltip"
L["Shows or hides a spell tooltip if the Proximity display is currently tied directly to a boss encounter ability."] = "Mostra/oculta o tooltip do feitiço se a janela de aproximação estiver empatada com uma habilidade de chefe."

-----------------------------------------------------------------------
-- Tips.lua
--

L["|cff%s%s|r says:"] = "|cff%s%s|r disse:"
L["Cool!"] = "Legal!"
L["Tips"] = "Conselhos"
L["Tip of the Raid"] = "Conselho de raide"
L["Tip of the raid will show by default when you zone in to a raid instance, you are not in combat, and your raid group has more than 9 players in it. Only one tip will be shown per session, typically.\n\nHere you can tweak how to display that tip, either using the pimped out window (default), or outputting it to chat. If you play with officers who overuse the |cffff4411/sendtip command|r, you might want to show them in chat frame instead!"] = "Os conselhos de raide se mostrarão por padrão quando entrar em uma zona dentro de uma instancia de raide, se não estiver em combate, e seu grupo de raid tiver mais de 9 jogadores nele. Somente um conselho aparecerá por sessão, normalmente.\n\nAqui poderá descobrir como visualizar estes conselhos, ou usar a janela amigável (padrão), o visualizalos no chat. Se você joga com oficiais, queira usar o |cffff4411comando /sendtip |r, e poderá ver o que querem mostrando-o no chat ao envés da janela!."
L["If you don't want to see any tips, ever, you can toggle them off here. Tips sent by your raid officers will also be blocked by this, so be careful."] = "Se não quer ver nenhum conselho, sempre, poderá desativalo aqui. Os conselhos enviados por seus oficiais de raide tambem são bloqueados por isto, seja cuidadoso."
L["Automatic tips"] = "Conselhos automáticos"
L["If you don't want to see the awesome tips we have, contributed by some of the best PvE players in the world, pop up when you zone in to a raid instance, you can disable this option."] = "Se não quer ver os formidaveis conselhos que temos, contribuido por alguns dos melhores jogadores de PvE do mundo, em uma janela quando entrar em uma zona de raide, você pode desativar esta opção."
L["Manual tips"] = "Conselhos manuais"
L["Raid officers have the ability to show manual tips with the /sendtip command. If you have an officer who spams these things, or for some other reason you just don't want to see them, you can disable it with this option."] = "Os oficiais de raid tem a habilidade de mostrar manualmente conselhos com o comando /sendtip. Se tem um oficial que spama isto, ou por outras razões que não queira ver, você pode desativar com esta opção."
L["Output to chat frame"] = "Saida na janela de chat"
L["By default the tips will be shown in their own, awesome window in the middle of your screen. If you toggle this, however, the tips will ONLY be shown in your chat frame as pure text, and the window will never bother you again."] = "Por padrão os conselhos se mostrarão para todos, em uma formidavel janelainha no meio da tela. Se quer mudar isto, porem, os conselhos SÓ serão mostrados em seu chat como texto puro, e a janela nunca aparecerá novamente."
L["Usage: /sendtip <index|\"Custom tip\">"] = "Use: /sendtip <index|\"Conselho personalizado\">"
L["You must be an officer in the raid to broadcast a tip."] = "Você deve ser um oficial de raide para mandar um conselho"
L["Tip index out of bounds, accepted indexes range from 1 to %d."] = "índice de conselhos fora do límite, índices aceitados: 1 a %d."

-----------------------------------------------------------------------
-- Emphasize.lua
--

L["Super Emphasize"] = "Super Enfatizar"
L.superEmphasizeDesc = "Da um aviso muito mais facil de se ver as mensagens ou barras relacionadas com uma habilidade de um encontro.\n\nAquí você configura exatamente o que deverá ocurrer quando trocar para ativado a opção de Super Enfatizar na sessão avançada para uma habilidade de um encontro de um chefe.\n\n|cffff4411Nota: Super Enfatizar está desabilitado por padrão para todas as habilidades.|r\n"
L["UPPERCASE"] = "MAIÚSCULAS"
L["Uppercases all messages related to a super emphasized option."] = "Maiúsculas emm todas as mensagens relacionadas com a opção super enfatizada."
L["Double size"] = "Tamanho dobrado"
L["Doubles the size of super emphasized bars and messages."] = "Dobra o tamanho das barras super enfatizadas e as mensagens"
L["Countdown"] = "Contador"
L["If a related timer is longer than 5 seconds, a vocal and visual countdown will be added for the last 5 seconds. Imagine someone counting down \"5... 4... 3... 2... 1... COUNTDOWN!\" and big numbers in the middle of your screen."] = "Se um contador é relativamente maior que 5 segundos, uma conta vocal e visual será feita para os últimos 5 segundos. Imagine alguma contagem \"5... 4... 3... 2... 1... BOOM!\" e grandes números no meio da tela."
L["Flash"] = "Piscar"
L["Flashes the screen red during the last 3 seconds of any related timer."] = "Pisca a tela na cor roxa durante os últimos 3 segundos de um contador relacionado."

