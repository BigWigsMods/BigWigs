local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "itIT")
if not L then return end

L.comma = ", "
L.width = "Larghezza"
L.height = "Altezza"
--L.sizeDesc = "Normally you set the size by dragging the anchor. If you need an exact size you can use this slider or type the value into the box, which has no maximum."
--L.fontSizeDesc = "Adjust the font size using the slider or type the value into the box which has a much higher maximum of 200."
--L.disableDesc = "You are about to disable the feature '%s' which is |cffff4411not recommended|r.\n\nAre you sure you want to do this?"
L.transparency = "Trasparenza"

L.abilityName = "Nome dell'Abilità"
L.abilityNameDesc = "Visualizza o nasconde il nome dell'abilità sopra la finestra"
L.Alarm = "Allarme"
L.Alert = "Avvertimento"
L.align = "Allineamento"
L.alignText = "Allinea il Testo"
L.alignTime = "Allinea il Tempo"
L.altPowerTitle = "AltPower"
L.background = "Sfondo"
L.backgroundDesc = "Visualizza o nasconde il titolo"
L.bars = "Barre"
L.nameplateBars = "Barre dei nomi"
L.nameplateAutoWidth = "Stessa larghezza della barra dei nomi"
L.nameplateAutoWidthDesc = "Imposta la larghezza delle barre del nome alla larghezza della barra corrispondente."
L.nameplateOffsetY = "Distanza Y"
L.nameplateOffsetYDesc = "Distanza dal punto superiore della barra dei nomi verso l'alto e dal punto inferiore della barra dei nomi verso il basso."
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
L.bossDefeatDurationPrint = "Sconfitto '%s' dopo %s."
L.bossStatistics = "Statistiche del Boss"
L.bossStatsDescription = "Tiene il conto di varie statistiche relative ad ogni singolo boss, tipo il numero di volte che è stato sconfitto, il numero di tentativi falliti (wipes), quanto è durato il combattimento, o l'uccisione più veloce. Queste statistiche possono essere viste nella finestra di configurazione di ogni singolo boss, ma saranno nascoste per quei boss di cui non c'é nessuna informazione statistica."
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
L.classColorsDesc = "I messaggi possono contenere i nomi dei giocatori. Attivando questa opzione verranno colorati con il colore della classe."
L.clickableBars = "Barre Cliccabili"
L.clickableBarsDesc = [=[Le barre di BigWigs non sono cliccabili di default. In questo modo puoi selezionare o lanciare le abilità anche dietro le barre, cambiare l'angolo della telecamera, e così via, mentre il cursore è su una barra. |cffff4411Se abiliti le Barre Cliccabili, questo non funzionerà più.|r Le barre intercetteranno i click del mouse.
]=]
L.close = "Chiudi"
L.closeButton = "Pulsante di Chiusura"
L.closeButtonDesc = "Visualizza o nasconde il pulsante di Chiusura"
L.closeProximityDesc = [=[Chiude il Monitor di Prossimità.

Per disabilitarlo completamente per tutti gli incontri, devi andare nelle impostazioni dei singoli combattimenti e disabilitare l'opzione 'Prossimità]=]
L.colors = "Colori"
L.combatLog = "Registro di combattimento automatico"
L.combatLogDesc = "Inizia a registrare il combattimento automaticamente quando parte un pull timer e lo interrompe quando termina lo scontro."
L.countDefeats = "Numero Uccisioni"
L.countdownAt = "Conto alla rovescia in... (secondi)"
L.countdownColor = "Colore conto alla rovescia"
L.countdownTest = "Test conto alla rovescia"
L.countdownType = "Tipo di conto alla rovescia"
L.countdownVoice = "Voce contro alla rovescia"
L.countWipes = "Numero Fallimenti:"
L.createTimeBar = "Mostra la barra 'Miglior Tempo'"
L.customBarStarted = "Barra personalizzata '%s' creata da utente %s - %s."
L.customRange = "Indicatore di Distanza Personalizzato"
L.customSoundDesc = "Riproduci il suono personalizzato scelto invece che quelli proposti dal modulo."
L.defeated = "%s è stato sconfitto!"
L.disabled = "Disabilitato"
L.disabledDisplayDesc = "Disattiva il monitor per tutti gli scontri che lo usano."
L.displayTime = "Tempo di Visualizzazione"
L.displayTimeDesc = "Per quanto tempo deve essere visualizzato il messaggio, in secondi"
L.emphasize = "Enfatizza"
L.emphasizeAt = "Enfatizza a... (secondi)"
L.emphasized = "Enfatizzato"
L.emphasizedBars = "Barre Enfatizzate"
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
L.outline = "Sottolineato"
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
L.engageSoundTitle = "Riproduci un suono quando inizia il combattimento con un boss"
L.pullStartedSoundTitle = "Riproduci un suono quando comincia il timer di ingaggio"
L.pullFinishedSoundTitle = "Riproduci un suono quando termina il timer di ingaggio"
L.pullStarted = "Timer ingaggio iniziato da utente %s - %s."
L.pullStopped = "Timer ingaggio cancellato da %s."
L.pullStoppedCombat = "Timer ingaggio cancellato perchè è iniziato il combattimento."
L.raidIconsDesc = [=[Alcuni combattimenti richiedono di evidenziare alcuni giocatori di particolare interesse nell'incontro con dei simboli. Per esempio effetti di tipo 'bomba' o 'controllo della mente'. Se disattivi questa opzione, non metterai nessun simbolo.

|cffff4411Si applica solo quando sei il capogruppo della spedizione o sei stato stato promosso!|r]=]
L.raidIconsDescription = [=[Alcuni combattimenti possono includere elementi come bombe su giocatori specifici, un giocatore inseguito da qualcosa, o un giocatore che può essere fondamentale seguire. Qui puoi personalizzare quali Simboli devono essere applicati sui giocatori

If an encounter only has one ability that is worth marking for, only the first icon will be used. One icon will never be used for two different abilities on the same encounter, and any given ability will always use the same icon next time.

|cffff4411Note that if a player has already been marked manually, BigWigs will never change their icon.|r]=]
L.recordBestTime = "Ricorda Miglior Tempo"
L.remove = "Rimuovi"
L.removeOther = "Rimuovi le Altre"
L.report = "Riporta"
L.reportDesc = "Riporta lo status della barra attuale nella finestra attiva di chat; che sia la chat dell'incursione, dell'istanza, del gruppo o del canale Parla, il più appropriato."
L.requiresLeadOrAssist = "Questa funzione richiede Capo Incursione o Assistente Incursione."
L.reset = "Reimposta"
L.resetAll = "Reimposta tutto"
L.resetAllCustomSound = "Se hai personalizzzato i suoni per qualsiasi boss, questo pulsante reimposterà TUTTI i suoni predefiniti e quindi verranno usati i suoni definiti qui."
L.resetAllDesc = "Se hai modificato qualsiasi parametro dei combattimenti, questo pulsante riporterà TUTTO alle impostazioni originali."
L.resetDesc = "Reimposta i colori qui sopra ai parametri originali."
L.respawn = "Respawn"
L.restart = "Riavvia"
L.restartDesc = "Riavvia le barre Enfatizzate in modo che partano dall'inizio e contino fino a 10."
L.right = "Destra"
L.secondary = "Secondario"
L.secondaryDesc = "Il secondo Simbolo che l'automazione del combattimento dovrebbe usare."
L.sendBreak = "Invia un timer di pausa a tutti gli utenti BigWigs e DBM."
L.sendCustomBar = "Invio barra personalizzata '%s' agli utenti di BigWigs e DBM."
L.sendPull = "Invio di un timer di Ingaggio agli utenti di BigWigs e DBM."
L.showHide = "Visulizza/Nascondi"
L.showRespawnBar = "Mostra barra di respawn"
L.showRespawnBarDesc = "Mostra una barra dopo un wipe dal boss che mostra il tempo rimanente prima che il boss ricompaia."
L.sinkDescription = "Indirizza l'uscita dei messaggi sul visualizzatore di Messaggi Normali di BigWigs. Questa visualizzazione supporta icone, colori e può visualizzare fino a 4 messaggi sullo schermo. I messaggi più recenti cresceranno in dimensioni per avvertire l'utente."
L.sound = "Suono"
L.soundButton = "Pulsante del Suono"
L.soundButtonDesc = "Visualizza o nasconde il pulsante del Suono"
L.soundDelay = "Ritardo del Suono"
L.soundDelayDesc = "Specifica per quanto tempo BigWigs dovrebbe aspettare per ripetere il suono quando qualcuno è vicino a te."
L.Sounds = "Suoni"
L.style = "Stile"
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
L.wipe = "Fallimento"
L.wipeSoundTitle = "Riproduci un suono dopo un tentativo fallito"
L.wrongBreakFormat = "Deve essere tra 1 e 60 minuti. Un'esempio corretto è /break 5"
L.wrongCustomBarFormat = "Formato non corretto. Un'esempio corretto è: /raidbar 20 testo"
L.wrongPullFormat = "Deve essere tra 1 e 60 secondi. Un'esempio corretto è: /pull 5"
L.wrongTime = "Specificato tempo non valido. <time> può essere sia un numero in secondi, una coppia M:S , o Mm. Per esempio 5, 1:20 or 2m."

-----------------------------------------------------------------------
-- AltPower.lua
--

--L.altPowerDesc = "The AltPower display will only appear for bosses that apply AltPower to players, which is extremely rare. The display measures the amount of 'Alternative Power' you and your group has, displaying it in a list. To move the display around, please use the test button below."
--L.resetAltPowerDesc = "Reset all the options related to AltPower, including the position of the AltPower anchor."
--L.test = "Test"
--L.altPowerTestDesc = "Show the 'Alternative Power' display, allowing you to move it, and simulating the power changes you would see on a boss encounter."
--L.yourPowerBar = "Your Power Bar"
--L.barColor = "Bar color"
--L.barTextColor = "Bar text color"
--L.additionalWidth = "Additional Width"
--L.additionalHeight = "Additional Height"
--L.additionalSizeDesc = "Add to the size of the standard display by adjusting this slider, or type the value into the box which has a much higher maximum of 100."
--L.yourPowerTest = "Your Power: %d" -- Your Power: 42
--L.yourAltPower = "Your %s: %d" -- e.g. Your Corruption: 42
--L.player = "Player %d" -- Player 7
--L.disableAltPowerDesc = "Globally disable the AltPower display, it will never show for any boss encounter."

-----------------------------------------------------------------------
-- AutoReply.lua
--

L.autoReply = "Risposta automatica"
L.autoReplyDesc = "Risponde automaticamente ai sussuri durante il combattimento con un boss."
L.responseType = "Ripo di risposta"
L.autoReplyFinalReply = "Sussurra anche quando esci dal combattimento"
L.guildAndFriends = "Gilda e Amici"
L.everyoneElse = "Tutti gli altri"

L.autoReplyBasic = "Sono occupato in un combattimento con un boss."
L.autoReplyNormal = "Sono occupato in un combattimento con '%s'."
L.autoReplyAdvanced = "Sono occupato in un combattimento con '%s' (%s) e %d/%d persone sono vive."
L.autoReplyExtreme = "Sono occupato in un combattimento con '%s' (%s) e %d/%d persone sono vive: %s"

L.autoReplyLeftCombatBasic = "Non sono più in combattimento con un boss."
L.autoReplyLeftCombatNormalWin = "Ho sconfitto '%s'."
L.autoReplyLeftCombatNormalWipe = "Sono stato sconfitto da '%s'."
L.autoReplyLeftCombatAdvancedWin = "Ho sconfitto '%s' con %d/%d persone vive."
L.autoReplyLeftCombatAdvancedWipe = "Sono stato sconfitto da '%s' al: %s"

-----------------------------------------------------------------------
-- Bars.lua
--

L.spacing = "Spaziatura"
L.spacingDesc = "Cambia la distanza tra le barre."
L.emphasizeMultiplier = "Moltiplicatore di dimensioni"
--L.emphasizeMultiplierDesc = "If you disable the bars moving to the emphasize anchor, this option will decide what size the emphasized bars will be by multiplying the size of the normal bars."
--L.temporaryCountdownDesc = "Temporarily enable countdown on the ability associated with this bar."
L.removeBarDesc = "Rimuovi temporaneamente questa barra."
L.removeOtherBarDesc = "Rimuovi temporaneamente tutte le altre barre (tranne questa)."
L.iconPosition = "Posizione Icona"
L.iconPositionDesc = "Scegli dove l'icona deve essere posizionata sulla barra."
L.visibleBarLimit = "Limite barra visibile"
L.visibleBarLimitDesc = "Scegli il numero massimo di barre che devono essere visibili contemporaneamente."
L.textDesc = "Mostra o nascondi il testo delle barre."
L.resetBarsDesc = "Azzera tutte le opzioni delle barre, compresi gli ancoraggi delle barre."
L.nameplateAlphaDesc = "Regola la trasparenza della barra dei nomi."

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.bossBlock = "Blocco Boss"
L.bossBlockDesc = "Configura le varie opzioni che puoi bloccare durante gli scontri con i boss.\n\n"
--L.bossBlockAudioDesc = "Configure what audio to mute during a boss encounter.\n\nAny option here that is |cff808080greyed out|r has been disabled in WoW's sound options.\n\n"

L.audio = "Audio"
L.music = "Musica"
L.ambience = "Audio ambientale"
L.sfx = "Effetti audio"
L.errorSpeech = "Messaggi d'errore"
L.disableMusic = "Togli la musica (raccomandato)"
L.disableAmbience = "Togli i suoni ambientali (raccomandato)"
L.disableSfx = "Togli gli effetti sonori (non raccomandato)"
--L.disableErrorSpeech = "Mute error speech (recommended)"
--L.disableAudioDesc = "The '%s' option in WoW's sound options will be turned off, then turned back on when the boss encounter is over. This can help you focus on warning sounds from BigWigs."
--L.blockTooltipQuests = "Block tooltip quest objectives"
--L.blockTooltipQuestsDesc = "When you need to kill a boss for a quest, it will usually show as '0/1 complete' in the tooltip when you place your mouse over the boss. This will be hidden whilst in combat with that boss to prevent the tooltip growing very large."
--L.blockFollowerMission = "Blocca i popup della Guarnigione" -- Rename to follower mission
--L.blockFollowerMissionDesc = "I popup della Guarnigione appaiono per certe attività, ma principalmente quando un seguace completa una missione.\n\n\Questi popup possono coprire parti critiche o importanti della tua UI durante il combattimento contro un boss, raccomandiamo quindi di bloccarli."
L.blockObjectiveTracker = "Nascondi registro missioni"
--L.blockObjectiveTrackerDesc = "The quest objective tracker will be hidden during a boss encounter to clear up screen space.\n\nThis will NOT happen if you are in a mythic+ or are tracking an achievement."

--L.blockTalkingHead = "Hide 'Talking Head' NPC dialog popup"
--L.blockTalkingHeadDesc = "The 'Talking Head' is a popup dialog box that has an NPC head and NPC chat text at the middle-bottom of your screen that |cffff4411sometimes|r shows when an NPC is talking.\n\nYou can choose the different types of instances where this should be blocked from showing.\n\n|cFF33FF99Please Note:|r\n 1) This feature will allow the NPC voice to continue playing so you can still hear it.\n 2) For safety, only specific talking heads will be blocked. Anything special or unique, such as a one-time quest, will not be blocked."
--L.blockTalkingHeadDungeons = "Normal & Heroic Dungeons"
--L.blockTalkingHeadMythics = "Mythic & Mythic+ Dungeons"
--L.blockTalkingHeadRaids = "Raids"
--L.blockTalkingHeadTimewalking = "Timewalking (Dungeons & Raids)"
--L.blockTalkingHeadScenarios = "Scenarios"

L.subzone_grand_bazaar = "Gran Bazar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "Porto di Zandalar" -- Battle of Dazar'alor raid (Battle for Azeroth)
--L.subzone_eastern_transept = "Eastern Transept" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.red = "Rosso"
L.redDesc = "Avvisi generali di combattimento."
L.blue = "Blu"
L.blueDesc = "Avvisi per effetti diretti, come una magia su di te"
L.orange = "Arancione"
L.yellow = "Giallo"
L.green = "Verde"
L.greenDesc = "Avvisi per effetti benefici, come una magia rimossa da te."
L.cyan = "Azzurro"
L.cyanDesc = "Avvisi per modifiche di stato come un cambio di fase."
L.purple = "Viola"
L.purpleDesc = "Avvisi per abilità specifiche da difensore come un debuff sul tank."

-----------------------------------------------------------------------
-- Countdown.lua
--

--L.countdownAt_desc = "Choose how much time should be remaining on a boss ability (in seconds) when the countdown begins."
--L.countdown = "Countdown"
--L.countdownDesc = "The countdown feature involves a spoken audio countdown and a visual text countdown. It is rarely enabled by default, but you can enable it for any boss ability when looking at the specific boss encounter settings."
--L.countdownAudioHeader = "Spoken Audio Countdown"
--L.countdownTextHeader = "Visual Text Countdown"
--L.resetCountdownDesc = "Resets all the above countdown settings to their defaults."
--L.resetAllCountdownDesc = "If you've selected custom countdown voices for any boss encounter settings, this button will reset ALL of them as well as resetting all the above countdown settings to their defaults."

-----------------------------------------------------------------------
-- InfoBox.lua
--

--L.infoBox = "InfoBox"

-----------------------------------------------------------------------
-- Messages.lua
--

--L.emphasizedDesc = "The point of an emphasized message is to get your attention by being a large message in the middle of your screen. It is rarely enabled by default, but you can enable it for any boss ability when looking at the specific boss encounter settings."
--L.resetMessagesDesc = "Reset all the options related to messages, including the position of the message anchors."
L.uppercase = "TUTTO MAIUSCOLO"
--L.uppercaseDesc = "All emphasized messages will be converted to UPPERCASE."
L.chatMessages = "Messaggi Riquadro Chat"
L.chatMessagesDesc = "Invia tutti i messaggi di BigWigs alla chat oltre che nei settaggi di visualizzazione."

-----------------------------------------------------------------------
-- Proximity.lua
--

--L.resetProximityDesc = "Reset all the options related to proximity, including the position of the proximity anchor."

-----------------------------------------------------------------------
-- Pull.lua
--

--L.countdownBegins = "Begin Countdown"
--L.countdownBegins_desc = "Choose how much time should be remaining on the pull timer (in seconds) when the countdown begins."

-----------------------------------------------------------------------
-- Sound.lua
--

--L.soundsDesc = "BigWigs uses the 'Master' sound channel to play all of its sounds. If you find that sounds are too quiet or too loud, open WoW's sound settings and adjust the 'Volume principale' slider to a level you like.\n\nBelow you can globally configure the different sounds that play for specific actions, or set them to 'None' to disable them. If you only want to change a sound for a specific boss ability, that can be done at the boss encounter settings.\n\n"
--L.oldSounds = "Old Sounds"
--L.resetSoundDesc = "Resets the above sounds to their defaults."
--L.onyou = "A spell, buff, or debuff is on you"
--L.underyou = "You need to move out of a spell under you"

-----------------------------------------------------------------------
-- Statistics.lua
--

L.printHealthOption = "Salute Boss"
L.healthPrint = "Salute: %s."
L.healthFormat = "%s (%.1f%%)"
