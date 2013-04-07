local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "itIT")
if not L then return end

-----------------------------------------------------------------------
-- Bars.lua
--

L["Style"] = "Stile"
L.bigWigsBarStyleName_Default = "Predefinito"

L["Clickable Bars"] = "Barre Cliccabili"
L.clickableBarsDesc = "Le barre di Big Wigs non sono cliccabili di default. In questo modo puoi selezionare o lanciare le abilità anche dietro le barre, cambiare l'angolo della telecamera, e così via, mentre il cursore è su una barra.|cffff4411Se abiliti le Barre Cliccabili, questo non funzionerà più.|r Le barre intercetteranno i click del mouse.\n"
L["Enables bars to receive mouse clicks."] = "Abilita le barre ad intercettare i Click del Mouse"
L["Modifier"] = "Modificatore"
L["Hold down the selected modifier key to enable click actions on the timer bars."] = "Premi il modificatore selezionato per abilitare i click sulle barre dei timer."
L["Only with modifier key"] = "Solo con il tasto modificatore"
L["Allows bars to be click-through unless the specified modifier key is held down, at which point the mouse actions described below will be available."] = "Lascia le barre non cliccabili a meno che non sia premuto il tasto modificatore, a questo punto l'azione descritta sotto sarà disponibile."

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = "SUPER ENFATIZZA temporaneamente la barra ed ogni messaggio associato alla sua durata."
L["Report"] = "Riporta"
L["Reports the current bars status to the active group chat; either instance chat, raid, party or say, as appropriate."] = "Riporta lo status della barra attuale nella finestra attiva di chat; che sia la chat dell'incursione, dell'istanza, del gruppo o del canale Parla, il più appropriato."
L["Remove"] = "Rimuovi"
L["Temporarily removes the bar and all associated messages."] = "Rimuove temporaneamente la barra e tutti i messaggi ad essa associati."
L["Remove other"] = "Rimuovi le Altre"
L["Temporarily removes all other bars (except this one) and associated messages."] = "Rimuove temporaneamente tutte le altre barra (tranne questa) e i messaggi ad esse associati."
L["Disable"] = "Disabilita"
L["Permanently disables the boss encounter ability option that spawned this bar."] = "Disabilita in modo permanente l'abilità del boss che ha generato questa barra."

L["Emphasize at... (seconds)"] = "Enfatizza a... (secondi)"
L["Scale"] = "Scala"
L["Grow upwards"] = "Cresci verso l'altro"
L["Toggle bars grow upwards/downwards from anchor."] = "Alterna la crescita delle barre verso l'alto o verso il basso a partire dall'ancora."
L["Texture"] = "Texture"
L["Emphasize"] = "Enfatizza"
L["Enable"] = "Attiva"
L["Move"] = "Muovi"
L.moveDesc = "Muovi le Barre Enfatizzate all'Ancoraggio di Enfatizzazione. Se questa opzione non è abilitata. le barre enfatizzate cambieranno semplicemente scalatura e colore."
L["Regular bars"] = "Barre Normali"
L["Emphasized bars"] = "Barre Enfatizzate"
L["Align"] = "Allineamento"
L["Left"] = "Sinistra"
L["Center"] = "Centro"
L["Right"] = "Destra"
L["Time"] = "Tempo Rimasto"
L["Whether to show or hide the time left on the bars."] = "Visualizza o nasconde il tempo rimasto sulle barre."
L["Icon"] = "Icona"
L["Shows or hides the bar icons."] = "Visualizza o nasconde le icone delle Barre."
L["Font"] = "Carattere"
L["Restart"] = "Riavvia"
L["Restarts emphasized bars so they start from the beginning and count from 10."] = "Riavvia le barre Enfatizzate in modo che partano dall'inizio e contino fino a 10."
L["Fill"] = "Riempi"
L["Fills the bars up instead of draining them."] = "Riempi le barre invece di svuotarle man mano che passano i secondi."

L["Local"] = "Locale"
L["%s: Timer [%s] finished."] = "%s: Timer [%s] Terminato."
L["Custom bar '%s' started by %s user '%s'."] = "Barra personalizzata '%s' creata dall'utente '%s'."

L["Pull"] = "Ingaggio"
L["Pulling!"] = "Ingaggio!"
L["Pull timer started by %s user '%s'."] = "Timer Ingaggio iniziato dall'utente '%s'."
L["Pull in %d sec"] = "Ingaggio tra %d sec"
L["Sending a pull timer to Big Wigs and DBM users."] = "Invio di un timer di Ingaggio agli utenti di Big Wigs e DBM."
L["Sending custom bar '%s' to Big Wigs and DBM users."] = "Invio barra personalizzata '%s' agli utenti di Big Wigs e DBM."
L["This function requires raid leader or raid assist."] = "Questa funzione richiede Capo Incursione o Assistente Incursione."
L["Must be between 1 and 60. A correct example is: /pull 5"] = "Deve essere tra 1 e 60. Un'esempio corretto è: /pull 5"
L["Incorrect format. A correct example is: /raidbar 20 text"] = "Formato non corretto. Un'esempio corretto è: /raidbar 20 testo"
L["Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Specificato tempo non valido. <time> può essere sia un numero in secondi, una coppia M:S , o Mm. Per esempio 5, 1:20 or 2m."
L["This function can't be used during an encounter."] = "Questa funzione non può essere usata durante uno scontro con un boss."

L.customBarSlashPrint = "Questa funzionalità è stata rinominata. Usa il comando /raidbar per inciare una barra personalizzata alla tua incursione oppure /localbar per una barra visibile solo a te stesso."

-----------------------------------------------------------------------
-- Colors.lua
--

L.Colors = "Colori"

L.Messages = "Messaggi"
L.Bars = "Barre"
L.Background = "Sfondo"
L.Text = "Testo"
L.TextShadow = "Ombra Testo"
L.Flash = "Lampeggio"
L.Normal = "Normale"
L.Emphasized = "Enfatizzato"

L.Reset = "Reimposta"
L["Resets the above colors to their defaults."] = "Reimposta i colori qui sopra ai parametri originali."
L["Reset all"] = "Reimposta tutto"
L["If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."] = "Se hai modificato qualsiasi parametro dei combattimenti, questo pulsante riporterà TUTTO alle impostazioni originali."

L.Important = "Importante"
L.Personal = "Personale"
L.Urgent = "Urgente"
L.Attention = "Attenzione"
L.Positive = "Positivo"
L.Neutral = "Neutrale"

-----------------------------------------------------------------------
-- Emphasize.lua
--

L["Super Emphasize"] = "SUPER ENFATIZZAZIONE"
L.superEmphasizeDesc = "Aumenta la visualizzazione di un messaggio o di un timer di un'abilità speciale di un boss..\n\n Qui puoi configurare esattamente cosa deve accadere quando abiliti la SUPER ENFATIZZAZIONE nelle opzioni di un'abilità di un boss.\n\n|cffff4411Attenzione: la SUPER ENFATIZZAZIONE è disattivata di default per tutte le abilità.|r\n"
L["UPPERCASE"] = "TUTTO MAIUSCOLO"
L["Uppercases all messages related to a super emphasized option."] = "Converte in Maiuscolo tutto il messaggio"
L["Double size"] = "Raddoppia la Dimensione"
L["Doubles the size of super emphasized bars and messages."] = "Raddoppa la dimensione della barra e del messaggio"
L["Countdown"] = "Conto alla Rovescia"
L["If a related timer is longer than 5 seconds, a vocal and visual countdown will be added for the last 5 seconds. Imagine someone counting down \"5... 4... 3... 2... 1... COUNTDOWN!\" and big numbers in the middle of your screen."] = "Se un timer è maggiore di 5 secondi, un avviso vocale e un conto alla rovescia verrranno aggiunti negli ultimi 5 secondi. Immagina qualcuno che conta \'5... 4... 3... 2... 1... ABILITÀ!\' e dei grandi numeri in mezzo al tuo schermo."

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Indirizza l'uscita dei messaggi sul visualizzatore di Messaggi Normali di Big Wigs. Questa visualizzazione supporta icone, colori e può visualizzare fino a 4 messaggi sullo schermo. I messaggi più recenti cresceranno in dimensioni per avvertire l'utente."
L.emphasizedSinkDescription = "Indirizza l'uscita dei messaggi attraverso il visualizzatore di Messaggi ENFATIZZATI di Big Wigs. Questo metodo supporta testi, colori e può visualizzare un solo messaggio per volta."
L.emphasizedCountdownSinkDescription = "Indirizza l'uscita da questo addon verso la visualizzazione del Recupero Messaggi Enfatizzati. Questa visualizzazione supporta testi e colori, e può visualizzare solo un messaggio alla volta."

L["Big Wigs Emphasized"] = "Big Wigs Enfatizzato"
L["Messages"] = "Messaggi"
L["Normal messages"] = "Messaggi Normali"
L["Emphasized messages"] = "Messaggi Enfatizzati"
L["Output"] = "Uscita"
L["Emphasized countdown"] = "Recupero Messaggi Enfatizzati"

L["Use colors"] = "Usa Colori"
L["Toggles white only messages ignoring coloring."] = "Abilita solo messaggi bianchi ignorando i colori"

L["Use icons"] = "Usa Icone"
L["Show icons next to messages, only works for Raid Warning."] = "Visualizza le icone vicino ai messaggi, funziona soltanto per gli Avvertimenti di Incursione."

L["Class colors"] = "Colore delle Classi"
L["Colors player names in messages by their class."] = "Colora i nomi dei giocatori con il colore della loro classe."

L["Font size"] = "Dimensione Carattere"
L["None"] = "Nessuno"
L["Thin"] = "Fine"
L["Thick"] = "Spesso"
L["Outline"] = "Sottolineato"
L["Monochrome"] = "Monocromatico"
L["Toggles the monochrome flag on all messages, removing any smoothing of the font edges."] = "Abilita il flag monocromatico su tutti i messaggi, rimuovendo ogni effetto di smussatura degli angoli dei caratteri"

L["Display time"] = "Tempo di Visualizzazione"
L["How long to display a message, in seconds"] = "Per quanto tempo deve essere visualizzato il messaggio, in secondi"
L["Fade time"] = "Tempo di Scomparsa"
L["How long to fade out a message, in seconds"] = "Dopo quanti secondi il messaggio deve scomparire, in secondi"
L["Font color"] = "Colore carattere"

-----------------------------------------------------------------------
-- Proximity.lua
--

L["Custom range indicator"] = "Indicatore di Distanza Personalizzato"
L.proximityTitle = "%d m / %d |4giocatore:giocatori;"
L["Proximity"] = "Prossimità"
L["Sound"] = "Suono"
L["Disabled"] = "Disabilitato"
L["Disable the proximity display for all modules that use it."] = "Disabilita il monitor di prossimità per tutti i moduli che lo usano."
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "Il monitor di prossimità verrà visualizzzato la prossima volta. Per disabilitarlo completamente per questo combattimento, devi disabilitarlo nelle opzioni del combattimento."
L["Sound delay"] = "Ritardo del Suono"
L["Specify how long Big Wigs should wait between repeating the specified sound when someone is too close to you."] = "Specifica per quanto tempo Big Wigs dovrebbe aspettare per ripetere il suono quando qualcuno è vicino a te."

L.proximity = "Monitor di Prossimità"
L.proximity_desc = "Visualizza il monitor di prossimità al momento opportuno durante il combattimento, con i giocatori che stanno troppo vicino a te."

L["Close"] = "Chiudi"
L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = "Chiude il Monitor di Prossimità.\n\nPer disabilitarlo completamente per tutti gli incontri, devi andare nelle impostazioni dei singoli combattimenti e disabilitare l'opzione 'Prossimità"
L["Lock"] = "Blocca"
L["Locks the display in place, preventing moving and resizing."] = "Blocca il Monitor, impedendo che venga spostato e ridimensionato."
L["Title"] = "Titolo"
L["Shows or hides the title."] = "Visualizza o nasconde il titolo"
L["Background"] = "Sfondo"
L["Shows or hides the background."] = "Visualizza o nasconde il titolo"
L["Toggle sound"] = "Abilita Suono"
L["Toggle whether or not the proximity window should beep when you're too close to another player."] = "Abilita quando il monitor di prossimità deve emettere un suono se sei troppo vicino ad altri giocatori."
L["Sound button"] = "Pulsante del Suono"
L["Shows or hides the sound button."] = "Visualizza o nasconde il pulsante del Suono"
L["Close button"] = "Pulsante di Chiusura"
L["Shows or hides the close button."] = "Visualizza o nasconde il pulsante di Chiusura"
L["Show/hide"] = "Visulizza/Nascondi"
L["Ability name"] = "Nome dell'Abilità"
L["Shows or hides the ability name above the window."] = "Visualizza o nasconde il nome dell'abilità sopra la finestra"
L["Tooltip"] = "ToolTip"
L["Shows or hides a spell tooltip if the Proximity display is currently tied directly to a boss encounter ability."] = "Visualizza o nasconde il tooltip dell'abilità nel display di prossimità ed è strettamente legato all'abilità del boss."

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L["Icons"] = "Icone"

L.raidIconDescription = "Alcuni combattimenti possono includere elementi come bombe su giocatori specifici, un giocatore inseguito da qualcosa, che interessano un giocatore. Qui puoi personalizzare quali Simboli devono essere applicati sui giocatori.|r"
L["Primary"] = "Primario"
L["The first raid target icon that a encounter script should use."] = "Il primo Simbolo che l'automazione del combattimento dovrebbe usare."
L["Secondary"] = "Secondario"
L["The second raid target icon that a encounter script should use."] = "Il secondo Simbolo che l'automazione del combattimento dovrebbe usare."

L["Star"] = "Stella"
L["Circle"] = "Cerchio"
L["Diamond"] = "Diamante"
L["Triangle"] = "Triangolo"
L["Moon"] = "Luna"
L["Square"] = "Quadrato"
L["Cross"] = "X"
L["Skull"] = "Teschio"
L["|cffff0000Disable|r"] = "|cffff0000Disabilitato|r"

-----------------------------------------------------------------------
-- Sound.lua
--

L.soundDefaultDescription = "Con questa opzione, Big Wigs userà solo i suoni predefiniti Blizzard che indicano un avviso. Ricorda che solo alcuni messaggi utilizzeranno i suoni durante un combattimento."

L.Sounds = "Suoni"

L.Alarm = "Allarme"
L.Info = "Informazioni"
L.Alert = "Avvertimento"
L.Long = "Lungo"
L.Warning = "Avviso"
L.Victory = "Vittoria"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Imposta il suono da usare per %q.\n\nCtrl-Clic per ascoltare un suono."
L["Default only"] = "Solo Suoni Predefiniti"

L.customSoundDesc = "Riproduci il suono personalizzato scelto invece che quelli proposti dal modulo"
L.resetAllCustomSound = "Se hai personalizzzato i suoni per qualsiasi boss, questo pulsante reimposterà TUTTI i suoni predefiniti e quindi verranno usati i suoni definiti qui."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossKillDurationPrint = "Sconfitto '%s' dopo %s."
L.bossWipeDurationPrint = "Tentativo fallito su '%s' dopo %s."
L.newBestKill = "Nuova uccisione rapida!"
L.bossStatistics = "Statistiche del Boss"
L.bossStatsDescription = "Tiene il conto di varie statistiche relative ad ogni singolo boss, tipo il numero di volte che è stato sconfitto, il numero di tentativi falliti(wipes), quanto è durato il combattimento, o l'uccisione più veloce. Queste statistiche possono essere viste nella finestra di configurazione di ogni singolo boss, ma saranno nascoste per quei boss di cui non c'é nessuna informazione statistica."
L.enableStats = "Abilita Statistiche"
L.chatMessages = "Messaggi Chat"
L.printBestKillOption = "Notifica Miglior Uccisione"
L.printKillOption = "Tempo Uccisione"
L.printWipeOption = "Tempo Tentativo Fallito"
L.countKills = "Numero Uccisioni"
L.countWipes = "Numero Tentativi Falliti"
L.recordBestKills = "Ricorda Miglior Uccisione"

