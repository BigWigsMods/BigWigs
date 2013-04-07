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
--L["Reports the current bars status to the active group chat; either instance chat, raid, party or say, as appropriate."] = "Reports the current bars status to the active group chat; either instance chat, raid, party or say, as appropriate."
L["Remove"] = "Remover"
L["Temporarily removes the bar and all associated messages."] = "Temporariamente fecha a barra e todas as mensagens associadas"
L["Remove other"] = "Remover outro"
L["Temporarily removes all other bars (except this one) and associated messages."] = "Temporariamente fecha todas as barras (exceto esta) e as mensagens associadas."
L["Disable"] = "Desativar"
L["Permanently disables the boss encounter ability option that spawned this bar."] = "Desativa permanentemente a habilidade de encontro para que não de opção de que reapareça esta barra"

--L["Emphasize at... (seconds)"] = "Emphasize at... (seconds)"
L["Scale"] = "Escala"
L["Grow upwards"] = "Aumentar crescentemente"
L["Toggle bars grow upwards/downwards from anchor."] = "Alterna entre aumentar as barras crescentemente/decrescentemente des do encaixe."
L["Texture"] = "Textura"
L["Emphasize"] = "Enfatizar"
L["Enable"] = "Habilitar"
L["Move"] = "Mover"
--L.moveDesc = "Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color."
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
L["Custom bar '%s' started by %s user '%s'."] = "Custom bar '%s' started by %s user '%s'."

L["Pull"] = "Pull"
L["Pulling!"] = "Pulling!"
L["Pull timer started by %s user '%s'."] = "Pull timer started by %s user '%s'."
L["Pull in %d sec"] = "Pull in %d sec"
L["Sending a pull timer to Big Wigs and DBM users."] = "Sending a pull timer to Big Wigs and DBM users."
L["Sending custom bar '%s' to Big Wigs and DBM users."] = "Sending custom bar '%s' to Big Wigs and DBM users."
L["This function requires raid leader or raid assist."] = "This function requires raid leader or raid assist."
L["Must be between 1 and 60. A correct example is: /pull 5"] = "Must be between 1 and 60. A correct example is: /pull 5"
L["Incorrect format. A correct example is: /raidbar 20 text"] = "Incorrect format. A correct example is: /raidbar 20 text"
L["Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."
L["This function can't be used during an encounter."] = "This function can't be used during an encounter."

L.customBarSlashPrint = "This functionality has been renamed. Use /raidbar to send a custom bar to your raid or /localbar for a bar only you can see."

-----------------------------------------------------------------------
-- Colors.lua
--

L.Colors = "Cores"

L.Messages = "Mensagens"
L.Bars = "Barras"
L.Background = "Fundo"
L.Text = "Texto"
--L.TextShadow = "Text Shadow"
--L.Flash = "Flash"
L.Normal = "Normal"
L.Emphasized = "Enfatizado"

L.Reset = "Reiniciar"
L["Resets the above colors to their defaults."] = "Reinicia as cores padrões"
L["Reset all"] = "Reiniciar tudo"
L["If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."] = "Se você personalizou as cores e os ajustes de alguns encontros de chefe, este botão reiniciará TUDO e usará as cores padrões."

L.Important = "Importante"
L.Personal = "Pessoal"
L.Urgent = "Urgente"
L.Attention = "Atenção"
L.Positive = "Positivo"
--L.Neutral = "Neutral"

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

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Seguir o padrão do addon deixando as mensagens serem mostradas do jeito padrão do Big Wigs. Isto suporta icones, cores e podem mostrar até 4 mensagens na tela de uma vez. Após inserir as mensagens crescerão de tamanho e encolherão de novo rápidamente para notificar o usuario."
L.emphasizedSinkDescription = "Seguir o padrão de mensagens enfatizadas do Big Wigs. Isto suporta texto e cores, e só podem aparecer uma vez."
L.emphasizedCountdownSinkDescription = "Route output from this addon through the Big Wigs Emphasized Countdown message display. This display supports text and colors, and can only show one message at a time."

--L["Big Wigs Emphasized"] = "Big Wigs Emphasized"
L["Messages"] = "Mensagens"
L["Normal messages"] = "Mensagens normais"
L["Emphasized messages"] = "Mensagens enfatizadas"
L["Output"] = "Saida"
L["Emphasized countdown"] = "Emphasized countdown"

L["Use colors"] = "Usar cores"
L["Toggles white only messages ignoring coloring."] = "Mensagens somente de cor branca, ignorando as cores."

L["Use icons"] = "Usar icones"
L["Show icons next to messages, only works for Raid Warning."] = "Mostra os icones após a mensagem, só funciona em alertas de raid."

L["Class colors"] = "Cores das classes"
L["Colors player names in messages by their class."] = "Colore o nome do jogador nas mensagens, com a cor se sua classe"

L["Font size"] = "Tamanho da fonte"
L["None"] = "Nenhuma"
L["Thin"] = "Fino"
L["Thick"] = "Grosso"
L["Outline"] = "Contorno"
L["Monochrome"] = "Monocromo"
L["Toggles the monochrome flag on all messages, removing any smoothing of the font edges."] = "Troca o indicador monocromo de todas as mensagens, removendo qualquer embelezamento das fontes."
L["Font color"] = "Font color"

-----------------------------------------------------------------------
-- Proximity.lua
--

L["Custom range indicator"] = "Indicador de distância personalizado"
L.proximityTitle = "%d yd / %d |4player:players;" -- yd = yards (short)
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

L.Sounds = "Sons"

L.Alarm = "Alarme"
L.Info = "Info"
L.Alert = "Alerta"
L.Long = "Longo"
--L.Warning = "Warning"
L.Victory = "Vitória"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Ajuste o som a se usar para %q.\n\nCtrl-Clique em um som para previsualizar."
L["Default only"] = "Somente padrões"

L.customSoundDesc = "Play the selected custom sound instead of the one supplied by the module"
L.resetAllCustomSound = "If you've customized sounds for any boss encounter settings, this button will reset ALL of them so the sounds defined here will be used instead."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossKillDurationPrint = "Defeated '%s' after %s."
L.bossWipeDurationPrint = "Wiped on '%s' after %s."
L.newBestKill = "New best kill!"
L.bossStatistics = "Boss Statistics"
L.bossStatsDescription = "Recording of various boss-related statistics such as the amount of times a boss had been killed, the amount of wipes, total time that combat lasted, or the fastest boss kill. These statistics can be viewed on each boss's configuration screen, but will be hidden for bosses that have no recorded statistics."
L.enableStats = "Enable Statistics"
L.chatMessages = "Chat Messages"
L.printBestKillOption = "Best Kill Notification"
L.printKillOption = "Kill Time"
L.printWipeOption = "Wipe Time"
L.countKills = "Count Kills"
L.countWipes = "Count Wipes"
L.recordBestKills = "Remember Best Kills"

