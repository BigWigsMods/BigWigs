local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "itIT")
if not L then return end

L.comma = ", "
--L.width = "Width"
--L.height = "Height"
--L.sizeDesc = "Normally you set the size by dragging the anchor. If you need an exact size you can use this slider or type the value into the box, which has no maximum."

L.abilityName = "Nome dell'Abilità"
L.abilityNameDesc = "Visualizza o nasconde il nome dell'abilità sopra la finestra"
L.Alarm = "Allarme"
L.Alert = "Avvertimento"
L.align = "Allineamento"
--L.alignText = "Align Text"
--L.alignTime = "Align Time"
L.altPowerTitle = "AltPower"
L.background = "Sfondo"
L.backgroundDesc = "Visualizza o nasconde il titolo"
L.bars = "Barre"
L.bestTimeBar = "Migliore"
L.bigWigsBarStyleName_Default = "Predefinito"
L.blockEmotes = "Blocca gli emote a mezzo-schermo"
L.blockEmotesDesc = [=[Alcuni boss mostrano delle emote per determinate abilità; questi messaggi sono sia troppo lunghi che troppo descrittivi. Cerchiamo di produrre messaggi più compatti e puliti che non interferiscono con lo svolgimento del gioco, e non dicono specificatamente cosa fare.

Nota bene: gli emote dei Boss sono sempre visibili nella chat se vuoi leggerli.]=]
L.blockGuildChallenge = "Blocca i popup delle sfide di Gilda"
L.blockGuildChallengeDesc = [=[I popup delle Sfide di Gilda vengono mostrati per vari avvisi, principalmente quando la tua gilda completa una spedizione eroica o una spedizione in modalità sfida.

Questi popup possono coprire parti critiche o importanti della tua UI durante il combattimento contro un boss, raccomandiamo quindi di bloccarli.]=]
L.blockMovies = "Blocca filmati già visti"
L.blockMoviesDesc = "I filmati dei boss (ove presenti) verranno fatti vedere solo la prima volta che si attivano per visualizzarli; dalle volte successive questi video verranno cancellati automaticamente."
L.blockSpellErrors = "Blocca i messaggi di errore degli incantesimi"
L.blockSpellErrorsDesc = "Messaggi tipo \"Questo incantesimo non è ancora pronto\" che in genere vengono mostrati in alto nello schermo verranno bloccati."
L.bossBlock = "Blocco Boss"
L.bossBlockDesc = "Configura le varie opzioni che puoi bloccare durante gli scontri con i boss."
L.bossDefeatDurationPrint = "Sconfitto '%s' dopo %s."
L.bossStatistics = "Statistiche del Boss"
L.bossStatsDescription = "Tiene il conto di varie statistiche relative ad ogni singolo boss, tipo il numero di volte che è stato sconfitto, il numero di tentativi falliti(wipes), quanto è durato il combattimento, o l'uccisione più veloce. Queste statistiche possono essere viste nella finestra di configurazione di ogni singolo boss, ma saranno nascoste per quei boss di cui non c'é nessuna informazione statistica."
L.bossWipeDurationPrint = "Tentativo fallito su '%s' dopo %s."
L.breakBar = "Tempo di pausa"
L.breakFinished = "Il tempo di pausa è finito"
L.breakMinutes = "La Pausa finisce tra %d |4minuto:minuti!"
L.breakSeconds = "La Pausa finisce tra %d |4secondo:secondi!"
L.breakStarted = "Pausa annunciata da %s utente %s."
L.breakStopped = "Tempo di pausa cancellato da %s."
L.bwEmphasized = "BigWigs Enfatizzato"
L.center = "Centro"
L.chatMessages = "Messaggi Chat"
L.classColors = "Colore delle Classi"
L.classColorsDesc = "Colora i nomi dei giocatori in base alla loro classe."
L.clickableBars = "Barre Cliccabili"
L.clickableBarsDesc = [=[Le barre di BigWigs non sono cliccabili di default. In questo modo puoi selezionare o lanciare le abilità anche dietro le barre, cambiare l'angolo della telecamera, e così via, mentre il cursore è su una barra.|cffff4411Se abiliti le Barre Cliccabili, questo non funzionerà più.|r Le barre intercetteranno i click del mouse.
]=]
L.close = "Chiudi"
L.closeButton = "Pulsante di Chiusura"
L.closeButtonDesc = "Visualizza o nasconde il pulsante di Chiusura"
L.closeProximityDesc = [=[Chiude il Monitor di Prossimità.

Per disabilitarlo completamente per tutti gli incontri, devi andare nelle impostazioni dei singoli combattimenti e disabilitare l'opzione 'Prossimità]=]
L.colors = "Colori"
-- L.combatLog = "Automatic Combat Logging"
-- L.combatLogDesc = "Automatically start logging combat when a pull timer is started and end it when the encounter ends."
L.countDefeats = "Numero Uccisioni"
L.countdownAt = "Conto alla rovescia in... (secondi)"
L.countdownColor = "Colore conto alla rovescia"
L.countdownTest = "Test conto alla rovescia"
-- L.countdownType = "Countdown Type"
L.countdownVoice = "Voce contro alla rovescia"
L.countWipes = "Numero Fallimenti:"
L.createTimeBar = "Mostra la barra 'Miglior Tempo'"
L.customBarStarted = "Barra personalizzata '%s' creata da utente %s - %s."
L.customRange = "Indicatore di Distanza Personalizzato"
L.customSoundDesc = "Riproduci il suono personalizzato scelto invece che quelli proposti dal modulo"
L.defeated = "%s è stato sconfitto!"
L.disable = "Disabilita"
L.disabled = "Disabilitato"
L.disabledDisplayDesc = "Disattiva il monitor per tutti gli scontri che lo usano."
L.disableDesc = "Disabilita in modo permanente l'abilità del boss che ha generato questa barra."
L.displayTime = "Tempo di Visualizzazione"
L.displayTimeDesc = "Per quanto tempo deve essere visualizzato il messaggio, in secondi"
L.emphasize = "Enfatizza"
L.emphasizeAt = "Enfatizza a... (secondi)"
L.emphasized = "Enfatizzato"
L.emphasizedBars = "Barre Enfatizzate"
L.emphasizedCountdownSinkDescription = "Indirizza l'uscita da questo addon verso la visualizzazione del Recupero Messaggi Enfatizzati. Questa visualizzazione supporta testi e colori, e può visualizzare solo un messaggio alla volta."
L.emphasizedMessages = "Messaggi Enfatizzati"
L.emphasizedSinkDescription = "Indirizza l'uscita dei messaggi attraverso il visualizzatore di Messaggi ENFATIZZATI di BigWigs. Questo metodo supporta testi, colori e può visualizzare un solo messaggio per volta."
L.enable = "Attiva"
L.enableStats = "Abilita Statistiche"
L.encounterRestricted = "Questa funzione non può essere usata durante uno scontro con un boss."
L.fadeTime = "Tempo di Scomparsa"
L.fadeTimeDesc = "Dopo quanti secondi il messaggio deve scomparire, in secondi"
L.fill = "Riempi"
L.fillDesc = "Riempi le barre invece di svuotarle man mano che passano i secondi."
L.flash = "Lampeggio"
L.font = "Carattere"
L.fontColor = "Colore carattere"
L.fontSize = "Dimensione Carattere"
L.general = "Generale"
L.growingUpwards = "Cresci verso l'altro"
L.growingUpwardsDesc = "Attiva o disattiva il riempimento crescente o decrescente rispetto al punto di ancoraggio."
L.icon = "Icona"
L.iconDesc = "Visualizza o nasconde le icone delle Barre."
L.icons = "Icone"
L.Info = "Informazioni"
L.interceptMouseDesc = "Abilita le barre ad intercettare i Click del Mouse"
L.left = "Sinistra"
L.localTimer = "Locale"
L.lock = "Blocca"
L.lockDesc = "Blocca il Monitor, impedendo che venga spostato e ridimensionato."
L.Long = "Lungo"
L.messages = "Messaggi"
L.modifier = "Modificatore"
L.modifierDesc = "Premi il modificatore selezionato per abilitare i click sulle barre dei timer."
L.modifierKey = "Solo con il tasto modificatore"
L.modifierKeyDesc = "Lascia le barre non cliccabili a meno che non sia premuto il tasto modificatore, a questo punto l'azione descritta sotto sarà disponibile."
L.monochrome = "Monocromatico"
L.monochromeDesc = "Abilita il flag monocromatico, rimuovendo ogni effetto di smussatura degli angoli dei caratteri."
L.move = "Muovi"
L.moveDesc = "Muovi le Barre Enfatizzate all'Ancoraggio di Enfatizzazione. Se questa opzione non è abilitata, le barre enfatizzate cambieranno semplicemente scalatura e colore."
L.movieBlocked = "Hai già visto questo video, lo salto."
L.newBestTime = "Nuovo record!"
L.none = "Nessuno"
L.normal = "Normale"
L.normalMessages = "Messaggi Normali"
L.outline = "Sottolineato"
L.output = "Uscita"
L.positionDesc = "Scrivi nel riquadro o sposta l'indicatore se devi posizionare esattamente la barra dall'ancoraggio."
L.positionExact = "Posizionamento Esatto"
L.positionX = "Posizione X"
L.positionY = "Posizione Y"
L.primary = "Primario"
L.primaryDesc = "Il primo Simbolo che l'automazione del combattimento dovrebbe usare."
L.printBestTimeOption = "Notifica Miglior Tempo"
L.printDefeatOption = "Tempo Uccisione"
L.printWipeOption = "Tempo Fallimento"
L.proximity = "Monitor di Prossimità"
L.proximity_desc = "Visualizza il monitor di prossimità al momento opportuno durante il combattimento, con i giocatori che stanno troppo vicino a te."
L.proximity_name = "Prossimità"
L.proximityTitle = "%d m / %d |4giocatore:giocatori;"
L.pull = "Ingaggio"
L.pullIn = "Ingaggio tra %d sec"
--L.engageSoundTitle = "Play a sound when a boss encounter has started"
--L.pullStartedSoundTitle = "Play a sound when the pull timer is started"
--L.pullFinishedSoundTitle = "Play a sound when the pull timer is finished"
L.pullStarted = "Timer Ingaggio iniziato da utente %s - %s."
L.pullStopped = "Barra d'ingaggio cancellata da %s."
--L.pullStoppedCombat = "Pull timer cancelled because you entered combat."
L.raidIconsDesc = [=[Alcuni combattimenti richiedono di evidenziare alcuni giocatori di particolare interesse nell'incontro con dei simboli. Per esempio effetti di tipo 'bomba' o 'controllo della mente'. Se disattivi questa opzione, non metterai nessun simbolo.

|cffff4411Si applica solo quando sei il capogruppo della spedizione o sei stato stato promosso!|r]=]
L.raidIconsDescription = [=[Alcuni combattimenti possono includere elementi come bombe su giocatori specifici, un giocatore inseguito da qualcosa, o un giocatore che può essere fondamentale seguire. Qui puoi personalizzare quali Simboli devono essere applicati sui giocatori

If an encounter only has one ability that is worth marking for, only the first icon will be used. One icon will never be used for two different abilities on the same encounter, and any given ability will always use the same icon next time.

|cffff4411Note that if a player has already been marked manually, BigWigs will never change their icon.|r]=]
L.recordBestTime = "Ricorda Miglior Tempo"
L.regularBars = "Barre Normali"
L.remove = "Rimuovi"
L.removeDesc = "Rimuove temporaneamente la barra e tutti i messaggi ad essa associati."
L.removeOther = "Rimuovi le Altre"
L.removeOtherDesc = "Rimuove temporaneamente tutte le altre barra (tranne questa) e i messaggi ad esse associati."
L.report = "Riporta"
L.reportDesc = "Riporta lo status della barra attuale nella finestra attiva di chat; che sia la chat dell'incursione, dell'istanza, del gruppo o del canale Parla, il più appropriato."
L.requiresLeadOrAssist = "Questa funzione richiede Capo Incursione o Assistente Incursione."
L.reset = "Reimposta"
L.resetAll = "Reimposta tutto"
L.resetAllCustomSound = "Se hai personalizzzato i suoni per qualsiasi boss, questo pulsante reimposterà TUTTI i suoni predefiniti e quindi verranno usati i suoni definiti qui."
L.resetAllDesc = "Se hai modificato qualsiasi parametro dei combattimenti, questo pulsante riporterà TUTTO alle impostazioni originali."
L.resetDesc = "Reimposta i colori qui sopra ai parametri originali."
-- L.respawn = "Respawn"
L.restart = "Riavvia"
L.restartDesc = "Riavvia le barre Enfatizzate in modo che partano dall'inizio e contino fino a 10."
L.right = "Destra"
L.secondary = "Secondario"
L.secondaryDesc = "Il secondo Simbolo che l'automazione del combattimento dovrebbe usare."
L.sendBreak = "Invia un timer di pausa a tutti gli utenti BigWigs e DBM."
L.sendCustomBar = "Invio barra personalizzata '%s' agli utenti di BigWigs e DBM."
L.sendPull = "Invio di un timer di Ingaggio agli utenti di BigWigs e DBM."
L.showHide = "Visulizza/Nascondi"
L.showRespawnBar = "Mostra barra reinizializzazione"
L.showRespawnBarDesc = "Mostra una barra dopo un wipe dal boss che mostra il tempo rimanente prima che il boss si reinizializzi."
L.sinkDescription = "Indirizza l'uscita dei messaggi sul visualizzatore di Messaggi Normali di BigWigs. Questa visualizzazione supporta icone, colori e può visualizzare fino a 4 messaggi sullo schermo. I messaggi più recenti cresceranno in dimensioni per avvertire l'utente."
L.sound = "Suono"
L.soundButton = "Pulsante del Suono"
L.soundButtonDesc = "Visualizza o nasconde il pulsante del Suono"
L.soundDelay = "Ritardo del Suono"
L.soundDelayDesc = "Specifica per quanto tempo BigWigs dovrebbe aspettare per ripetere il suono quando qualcuno è vicino a te."
L.soundDesc = "I messaggi possono essere visualizzati insieme a dei suoni. Alcuni trovano più semplice associare il suono all'abilità che viene mostrata nel messaggio piuttosto che leggere il messaggio stesso."
L.Sounds = "Suoni"
L.style = "Stile"
L.superEmphasize = "SUPER ENFATIZZAZIONE"
L.superEmphasizeDesc = [=[Aumenta la visualizzazione di un messaggio o di un timer di un'abilità speciale di un boss..

 Qui puoi configurare esattamente cosa deve accadere quando abiliti la SUPER ENFATIZZAZIONE nelle opzioni di un'abilità di un boss.

|cffff4411Attenzione: la SUPER ENFATIZZAZIONE è disattivata di default per tutte le abilità.|r
]=]
L.superEmphasizeDisableDesc = "Disabilita la Super Enfatizzazione per tutti i moduli che la usano."
L.tempEmphasize = "SUPER ENFATIZZA temporaneamente la barra ed ogni messaggio associato alla sua durata."
L.text = "Testo"
L.textCountdown = "Testo conto alla rovescia"
L.textCountdownDesc = "Mostra un conteggio visuale durante il conto alla rovescia."
L.textShadow = "Ombra Testo"
L.texture = "Texture"
L.thick = "Spesso"
L.thin = "Fine"
L.time = "Tempo Rimasto"
L.timeDesc = "Visualizza o nasconde il tempo rimasto sulle barre."
L.timerFinished = "%s: Timer [%s] Terminato."
L.title = "Titolo"
L.titleDesc = "Visualizza o nasconde il titolo"
L.toggleDisplayPrint = "Mostra il monitor per la prossima volta. Per disabilitarlo completamente in questo scontro, devi deselezionarlo dalle opzioni dello scontro specifico."
L.toggleSound = "Abilita Suono"
L.toggleSoundDesc = "Abilita quando il monitor di prossimità deve emettere un suono se sei troppo vicino ad altri giocatori."
L.tooltip = "ToolTip"
L.tooltipDesc = "Visualizza o nasconde il tooltip dell'abilità nel display di prossimità ed è strettamente legato all'abilità del boss."
L.uppercase = "TUTTO MAIUSCOLO"
L.uppercaseDesc = "Converte in Maiuscolo tutto il messaggio"
L.useColors = "Usa Colori"
L.useColorsDesc = "Abilita solo messaggi bianchi ignorando i colori"
L.useIcons = "Usa Icone"
L.useIconsDesc = "Mostra le icone accanto ai messaggi."
L.Victory = "Vittoria"
L.victoryHeader = "Configura le azioni da eseguire quando sconfiggi un boss."
L.victoryMessageBigWigs = "Mostra il messaggio BigWigs"
L.victoryMessageBigWigsDesc = "Il messaggio BigWigs è un semplice \"Il boss è stato sconfitto\"."
L.victoryMessageBlizzard = "Mostra il messaggio Blizzard"
L.victoryMessageBlizzardDesc = "Il messaggio Blizzard è un'animazione molto grande \"Il boss è stato sconfitto\" al centro dello schermo."
L.victoryMessages = "Mostra i messaggi alla sconfitta di un boss"
L.victorySound = "Riproduci un suono quando hai vinto"
L.Warning = "Avviso"
--L.wipe = "Wipe"
--L.wipeSoundTitle = "Play a sound when you wipe"
L.wrongBreakFormat = "Deve essere tra 1 e 60 minuti. Un'esempio corretto è /break 5"
L.wrongCustomBarFormat = "Formato non corretto. Un'esempio corretto è: /raidbar 20 testo"
L.wrongPullFormat = "Deve essere tra 1 e 60 secondi. Un'esempio corretto è: /pull 5"
L.wrongTime = "Specificato tempo non valido. <time> può essere sia un numero in secondi, una coppia M:S , o Mm. Per esempio 5, 1:20 or 2m."

-----------------------------------------------------------------------
-- AutoReply.lua
--

--L.autoReply = "Auto Reply"
--L.autoReplyDesc = "Automatically reply to whispers when engaged in a boss encounter."
--L.responseType = "Response Type"
--L.autoReplyFinalReply = "Also whisper when leaving combat"
--L.guildAndFriends = "Guild & Friends"
--L.everyoneElse = "Everyone else"

--L.autoReplyBasic = "I'm busy in combat with a boss encounter."
--L.autoReplyNormal = "I'm busy in combat with '%s'."
--L.autoReplyAdvanced = "I'm busy in combat with '%s' (%s) and %d/%d people are alive."
--L.autoReplyExtreme = "I'm busy in combat with '%s' (%s) and %d/%d people are alive: %s"

--L.autoReplyLeftCombatBasic = "I am no longer in combat with a boss encounter."
--L.autoReplyLeftCombatNormalWin = "I won against '%s'."
--L.autoReplyLeftCombatNormalWipe = "I lost against '%s'."
--L.autoReplyLeftCombatAdvancedWin = "I won against '%s' with %d/%d people alive."
--L.autoReplyLeftCombatAdvancedWipe = "I lost against '%s' at: %s"

-----------------------------------------------------------------------
-- Bars.lua
--

--L.spacing = "Spacing"
--L.spacingDesc = "Change the space between each bar."
--L.emphasizeMultiplier = "Size Multiplier"
--L.emphasizeMultiplierDesc = "If you disable the bars moving to the emphasize anchor, this option will decide what size the emphasized bars will be by multiplying the size of the normal bars."
--L.iconPosition = "Icon Position"
--L.iconPositionDesc = "Choose where on the bar the icon should be positioned."
--L.visibleBarLimit = "Visible bar limit"
--L.visibleBarLimitDesc = "Set the maximum amount of bars that are visible at the same time."
--L.textDesc = "Whether to show or hide the text displayed on the bars."

-----------------------------------------------------------------------
-- BossBlock.lua
--

--L.disableSfx = "Disable sound effects"
--L.disableSfxDesc = "The 'Sound Effects' option in WoW's sound options will be turned off, then turned back on when the boss encounter is over. This can help you focus on warning sounds from BigWigs."
--L.blockTooltipQuests = "Block tooltip quest objectives"
--L.blockTooltipQuestsDesc = "When you need to kill a boss for a quest, it will usually show as '0/1 complete' in the tooltip when you place your mouse over the boss. This will be hidden whilst in combat with that boss to prevent the tooltip growing very large."
--L.blockFollowerMission = "Blocca i popup della Guarnigione" -- Rename to follower mission
--L.blockFollowerMissionDesc = "I popup della Guarnigione appaiono per certe attività, ma principalmente quando un seguace completa una missione.\n\n\Questi popup possono coprire parti critiche o importanti della tua UI durante il combattimento contro un boss, raccomandiamo quindi di bloccarli."
--L.blockObjectiveTracker = "Hide quest tracker"
--L.blockObjectiveTrackerDesc = "The quest objective tracker will be hidden during a boss encounter to clear up screen space.\n\nThis will NOT happen if you are in a mythic+ or are tracking an achievement."

L.subzone_grand_bazaar = "Gran Bazar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "Porto di Zandalar" -- Battle of Dazar'alor raid (Battle for Azeroth)
--L.subzone_eastern_transept = "Eastern Transept" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

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
-- InfoBox.lua
--

--L.infoBox = "InfoBox"

-----------------------------------------------------------------------
-- Statistics.lua
--

--L.printHealthOption = "Boss Health"
--L.healthPrint = "Health: %s."
--L.healthFormat = "%s (%.1f%%)"
