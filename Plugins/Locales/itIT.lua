local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "itIT")
if not L then return end
-----------------------------------------------------------------------
-- Bars.lua
--

L["Style"] = "Stile"
L.bigWigsBarStyleName_Default = "Default"

L["Clickable Bars"] = "Barre Cliccabili"
L.clickableBarsDesc = "Le barre di Big Wigs non sono cliccabili di default. In questo modo puoi targettare o lanciare le magie anche dietro le barre, cambiare l'angolo della telecamera, e cosi' via, mentre il cursore e' su una barra.|cffff4411Se abiliti le Barre Cliccabili, questo non funzionera' piu'.|r Le barre intercetteranno i click del mouse.\n"
L["Enables bars to receive mouse clicks."] = "Abilita le barre ad intercettare i Click del Mouse"
L["Modifier"] = "Modificatore"
L["Hold down the selected modifier key to enable click actions on the timer bars."] = "Premi il modificatore selezionato per abilitare i click sulle barre dei timer."
L["Only with modifier key"] = "Solo con il tasto modificatore"
L["Allows bars to be click-through unless the specified modifier key is held down, at which point the mouse actions described below will be available."] = "Lascia le barre non cliccabili a meno che non sia premuto il tasto modificatore, a questo punto l'azione descritta sotto sara' disponibile."

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = "SUPER ENFATIZZA temporaneamente la barra ed ogni messaggio associato alla sua durata."
L["Report"] = "Riporta"
L["Reports the current bars status to the active group chat; either battleground, raid, party or guild, as appropriate."] = "Riporta in chat lo stato corrente della barra; anche campo di battaglia, incursione, gruppo o gilda."
L["Remove"] = "Rimuovi"
L["Temporarily removes the bar and all associated messages."] = "Rimuove temporaneamente la barra e tutti i messaggi ad essa associati."
L["Remove other"] = "Rimuovi le Altre"
L["Temporarily removes all other bars (except this one) and associated messages."] = "Rimuove temporaneamente tutte le altre barra (tranne questa) e i messaggi ad esse associati."
L["Disable"] = "Disabilita"
L["Permanently disables the boss encounter ability option that spawned this bar."] = "Disabilita in modo permanente l'abilita' del boss che ha generato questa barra."

L["Scale"] = "Scala"
L["Grow upwards"] = "Cresci verso l'altro"
L["Toggle bars grow upwards/downwards from anchor."] = "Alterna la crescita delle barre verso l'alto o verso il basso a partire dall'ancora."
L["Texture"] = "Texture"
L["Emphasize"] = "Enfatizza"
L["Enable"] = "Attiva"
L["Move"] = "Muovi"
L["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = "Muovi le barre enfatizzate verso l'Ancora Enfatizzata. Se quest'opzione è disattiva, le barre enfatizzate cambieranno semplicemente dimensione e colore, e forse lampeggieranno."
L["Flash"] = "Lampeggia"
L["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = "Fa lampeggiare lo sfondo delle barre Enfatizzate, per renderle piu' visibili."
L["Regular bars"] = "Barre Normali"
L["Emphasized bars"] = "Barre Enfatizzate"
L["Align"] = "Allineamento"
L["Left"] = "Sinistra"
L["Center"] = "Centro"
L["Right"] = "Destra"
L["Time"] = "Tempo Rimasto"
L["Whether to show or hide the time left on the bars."] = "Visualizzare o nascondere il tempo rimasto sulle barre."
L["Icon"] = "Icona"
L["Shows or hides the bar icons."] = "Visualizzare o nascondere le icone delle Barre."
L["Font"] = "Carattere"
L["Restart"] = "Riavvia"
L["Restarts emphasized bars so they start from the beginning and count from 10."] = "Riavvia le barre Enfatizzate in modo che partano dall'inizio e contino fino a 10."
L["Fill"] = "Riempi"
L["Fills the bars up instead of draining them."] = "Riempi le barre invece di svuotarle man mano che passano i secondi."

L["Local"] = "Locale"
L["%s: Timer [%s] finished."] = "%s: Timer [%s] Finito."
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Tempo non Valido (|cffff0000%q|r) o testo mancante in una barra customizzata avviata da |cffd9d919%s|r. <time> puo' essere o un numero di secondi, una coppia M:S , oppure Mm. As esempio 5, 1:20 o 2m."

-----------------------------------------------------------------------
-- Colors.lua
--

L["Colors"] = "Colori"

L["Messages"] = "Messaggi"
L["Bars"] = "Barre"
L["Background"] = "Sfondo"
L["Text"] = "Testo"
L["Flash and shake"] = "Lampeggia e Vibra"
L["Normal"] = "Normale"
L["Emphasized"] = "Enfatizzato"

L["Reset"] = "Reimposta"
L["Resets the above colors to their defaults."] = "Reimposta i colori qui sopra ai parametri originali."
L["Reset all"] = "Reimposta tutto"
L["If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."] = "Se hai modificato qualsiasi parametro dei combattimenti, questo bottone riportera' TUTTO alle impostazioni originali."

L["Important"] = "Importante"
L["Personal"] = "Personale"
L["Urgent"] = "Urgente"
L["Attention"] = "Attenzione"
L["Positive"] = "Positivo"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Indirizza l'uscita dei messaggi sul visualizzatore di Messaggi Normali di Big Wigs. Questa visualizzazione supporta icone, colori e puo' visualizzare fino a 4 messaggi sullo schermo. I messaggi piu' nuovi cresceranno in dimensioni per avvertire l'utente."
L.emphasizedSinkDescription = "Indirizza l'uscita dei messaggi attraverso il visualizzatore di Messaggi ENFATIZZATI di Big Wigs. Questo metodo supporta testi, colori e puo' visualizzare un solo messaggio per volta."

L["Messages"] = "Messaggi"
L["Normal messages"] = "Messaggi Normali"
L["Emphasized messages"] = "Messaggi Enfatizzati"
L["Output"] = "Uscita"

L["Use colors"] = "Usa Colori"
L["Toggles white only messages ignoring coloring."] = "Abilita solo messaggi bianchi ignorando i colori"

L["Use icons"] = "Usa Icone"
L["Show icons next to messages, only works for Raid Warning."] = "Visualizza le icone vicino ai messaggi, funziona soltanto per gli Avvertimenti di Incursione."

L["Class colors"] = "Colore delle Classi"
L["Colors player names in messages by their class."] = "Colora i nomi dei giocatori con il colore della loro classe."

L["Chat frame"] = "Frame della Chat"
L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "Invia tutti i messaggi di Big Wigs alla chat oltre che nei settaggi di visualizzazione."

L["Font size"] = "Dimensione Carattere"
L["None"] = "Nessuno"
L["Thin"] = "Fine"
L["Thick"] = "Spesso"
L["Outline"] = "Delineato"
L["Monochrome"] = "MonoCromatico"
L["Toggles the monochrome flag on all messages, removing any smoothing of the font edges."] = "Abilita il flag monocromatico su tutti i messaggi, rimuovendo ogni effetto di smussatura degli angoli dei caratteri"

L["Display time"] = "Tempo di Visualizzazione"
L["How long to display a message, in seconds"] = "Per quanto tempo deve essere visualizzato il messaggio, in secondi"
L["Fade time"] = "Tempo di Scomparsa"
L["How long to fade out a message, in seconds"] = "Dopo quanti secondi il messaggio deve scomparire"

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L["Icons"] = "Icone"

L.raidIconDescription = "Alcuni combattimenti possono includere elementi come bombe su giocatori specifici, un giocatore inseguito da qualcosa, che interessano un giocatore. Qui puoi personalizzare quali Marchi devono essere applicati sui giocatori.|r"
L["Primary"] = "Primaria"
L["The first raid target icon that a encounter script should use."] = "Il primo Marchio che l'automazione del combattimento dovrebbe usare."
L["Secondary"] = "Secondaria"
L["The second raid target icon that a encounter script should use."] = "Il secondo Marchio che l'automazione del combattimento dovrebbe usare."

L["Star"] = "Stella"
L["Circle"] = "Cerchio"
L["Diamond"] = "Diamante"
L["Triangle"] = "Triangolo"
L["Moon"] = "Luna"
L["Square"] = "Quadrato"
L["Cross"] = "X"
L["Skull"] = "Teschio"
L["|cffff0000Disable|r"] = "|cffff0000Disabilitata|r"

-----------------------------------------------------------------------
-- Sound.lua
--

L.soundDefaultDescription = "Con questa opzione, Big Wigs usera' solo i suoni di default Blizzard che indicano un avviso. Ricorda che solo alcuni messaggi utilizzeranno i suoni durante un combattimento."

L["Sounds"] = "Suoni"

L["Alarm"] = "Allarme"
L["Info"] = "Informazioni"
L["Alert"] = "Avvertimento"
L["Long"] = "Lungo"
L["Victory"] = "Vittoria"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Imposta il suono da usare per %q.\n\nCtrl-Click per ascoltare un suono."
L["Default only"] = "Solo Suoni Standard"

-----------------------------------------------------------------------
-- Proximity.lua
--

L["|T%s:20:20:-5|tAbility name"] = "|T%s:20:20:-5|tNome Abilita'"
L["Custom range indicator"] = "Indicatore di Distanza Personalizzato"
L["%d yards"] = "%d metri"
L["Proximity"] = "Prossimita'"
L["Sound"] = "Suono"
L["Disabled"] = "Disabilitato"
L["Disable the proximity display for all modules that use it."] = "Disabilita il modulo di prossimita' per tutti i moduli che lo usano."
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "Il display di prossimita' verra' visualizzzato la prossima volta. Per disabilitarlo completamente per questo combattimento, devi disabilitarlo nelle opzioni del combattimento."
L["Sound delay"] = "Ritardo del Suono"
L["Specify how long Big Wigs should wait between repeating the specified sound when someone is too close to you."] = "Specifica per quanto tempo Big Wigs dovrebbe aspettare per ripetere il suono quando qualcuno e' vicino a te."

L.proximity = "Display di Prossimita'"
L.proximity_desc = "Visualizza la finestra di prossimita' al momento opportuno durante il combattimento, con i giocatori che stanno troppo vicino a te."

L["Close"] = "Chiudi"
L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = "Chiude il Display di prossimita'.\n\nPer disabilitarlo completamente per tutti gli incontri, devi andare nelle impostazioni dei singoli combattimenti e disabilitare l'opzione 'Prossimita''"
L["Lock"] = "Blocca"
L["Locks the display in place, preventing moving and resizing."] = "Blocca il Display, impedendo che venga spostato e ridimensionato."
L["Title"] = "Titolo"
L["Shows or hides the title."] = "Visualizza o nasconde il titolo"
L["Background"] = "Sfondo"
L["Shows or hides the background."] = "Visualizza o nasconde il titolo"
L["Toggle sound"] = "Abilita Suono"
L["Toggle whether or not the proximity window should beep when you're too close to another player."] = "Abilita quando il monitor di prossimita' deve emettere un suono se sei troppo vicino ad altri giocatori."
L["Sound button"] = "Bottone del Suono"
L["Shows or hides the sound button."] = "Visualizza o nasconde il bottone del Suono"
L["Close button"] = "Bottone di Chiusura"
L["Shows or hides the close button."] = "Visualizza o nasconde il bottone di Chiusura"
L["Show/hide"] = "Visaulizza/Nascondi"
L["Ability name"] = "Nome dell'Abilita'"
L["Shows or hides the ability name above the window."] = "Visualizza o nasconde il nome dell'abilita' sopra la finestra"
L["Tooltip"] = "ToolTip"
L["Shows or hides a spell tooltip if the Proximity display is currently tied directly to a boss encounter ability."] = "Visualizza o nasconde il tooltip dell'abilita' nel display di prossimita' ed e' strettamente legato all'abilita' del boss."

-----------------------------------------------------------------------
-- Tips.lua
--

L["|cff%s%s|r says:"] = "|cff%s%s|r dice:"
L["Cool!"] = "Ottimo!"
L["Tips"] = "Suggerimenti"
L["Tip of the Raid"] = "Suggerimenti dell'Incursore"
L["Tip of the raid will show by default when you zone in to a raid instance, you are not in combat, and your raid group has more than 9 players in it. Only one tip will be shown per session, typically.\n\nHere you can tweak how to display that tip, either using the pimped out window (default), or outputting it to chat. If you play with officers who overuse the |cffff4411/sendtip command|r, you might want to show them in chat frame instead!"] = "I suggerimenti dell'Incursione verrranno visualizzati quando entri in un'Incursione se non sei in combattimento e il tuo gruppo ha piu' di 9 giocatori. Verra' visualizzato un suggerimento per Incursione.\n\nQui puoi impostare come vengono visualizzati i suggerimenti; se con un popup (default) oppure in chat. Se giochi con ufficiali che ne abusano del |cffff4411comando /sendtip|r, potresti volerli visualizzare in chat!"
L["If you don't want to see any tips, ever, you can toggle them off here. Tips sent by your raid officers will also be blocked by this, so be careful."] = "Se non vuoi vedere nessun suggerimento, puoi disabilitarli qui. Anche i suggerimenti inviati dagli Ufficiali o dal Capo Incrusione verranno bloccati."
L["Automatic tips"] = "Suggerimenti Automatici"
L["If you don't want to see the awesome tips we have, contributed by some of the best PvE players in the world, pop up when you zone in to a raid instance, you can disable this option."] = "Se non vuoi vedere i magnifici suggerimenti che abbiamo, forniti dai migliori giocatori PVE al mondo, puoi disabilitare quest'opzione."
L["Manual tips"] = "Suggerimenti Manuali"
L["Raid officers have the ability to show manual tips with the /sendtip command. If you have an officer who spams these things, or for some other reason you just don't want to see them, you can disable it with this option."] = "Gli ufficiali di Incursione hanno l'abilita' usare il /sendtip. Se hai un Ufficiale che spamma queste cose, o per qualche ragione non vuoi vedere i suggerimenti, puoi disabilitarli con questa opzione."
L["Output to chat frame"] = "Visualizza in Chat"
L["By default the tips will be shown in their own, awesome window in the middle of your screen. If you toggle this, however, the tips will ONLY be shown in your chat frame as pure text, and the window will never bother you again."] = "Di default, i Suggerimenti verranno visualizzati nel loro popup in centro allo schermo. Se abiliti quest'opzione, verranno visualizzati SOLO in chat, e la finestra non ti disturbera' piu'"
L["Usage: /sendtip <index|\"Custom tip\">"] = "Utilizzo: /sendtip <index|\"Suggerimento personalizzato\">"
L["You must be an officer in the raid to broadcast a tip."] = "Devi essere un Ufficiale di Incursione per inviare un suggerimento."
L["Tip index out of bounds, accepted indexes range from 1 to %d."] = "L'indice dei suggerimenti hanno un range accettato da 1 a %d"

-----------------------------------------------------------------------
-- Emphasize.lua
--

L["Super Emphasize"] = "SUPER ENFATIZZAZIONE"
L.superEmphasizeDesc = "Aumenta la visualizzazione di un messaggio o di un timer di un'abilita' speciale di un boss..\n\n Qui puoi configurare esattamente cosa deve accadere quando abiliti la SUPER ENFATIZZAZIONE nelle opzioni di una spell di un boss.\n\n|cffff4411Attenzione la SUPER ENFATIZZAZIONE e' disattivata di default per tutte le abilita'.|r\n"
L["UPPERCASE"] = "TUTTO MAIUSCOLO"
L["Uppercases all messages related to a super emphasized option."] = "Converte in Maiuscolo tutto il messaggio"
L["Double size"] = "Raddoppia la Dimensione"
L["Doubles the size of super emphasized bars and messages."] = "Raddoppa la dimensione della barra e del messaggio"
L["Countdown"] = "Conto alla Rovescia"
L["If a related timer is longer than 5 seconds, a vocal and visual countdown will be added for the last 5 seconds. Imagine someone counting down \"5... 4... 3... 2... 1... COUNTDOWN!\" and big numbers in the middle of your screen."] = "Se un timer e' maggiore di 5 secondi, un avviso vocale e un conto alla rovescia verrranno aggiunti negli ultimi 5 secondi. Immagina qualcuno che conta \'5... 4... 3... 2... 1... ABILITA'!\' e dei grandi numeri in mezzo al tuo schermo."
L["Flash"] = "Lampeggia"
L["Flashes the screen red during the last 3 seconds of any related timer."] = "Fa lampeggiare tutto lo schermo di rosso durante gli ultimi 3 secondi di un timer."

