local L = BigWigsAPI:NewLocale("BigWigs", "itIT")
if not L then return end

-- Core.lua
L.berserk = "Infuriato"
L.berserk_desc = "Visualizza un timer e un avviso quando il boss si infurierà."
L.altpower = "Visualizza Potere Alternativo"
L.altpower_desc = "Mostra la finestra del Potere Alternativo, che mostra l'ammontare di Potere Alternativo che ogni membro del gruppo ha."
L.infobox = "Riquadro informazioni"
L.infobox_desc = "Mostra un riquadro con informazioni sul combattimento."
L.stages = "Fasi"
L.stages_desc = "Abilita le funzioni relative alle varie fasi del boss come per esempio avvisi di cambio di fase, barre della durata della fase, ecc."
L.warmup = "Pre-ingaggio"
L.warmup_desc = "Conto alla rovescia per l'inizio del combattimento con il boss."
L.proximity = "Monitor di Prossimità"
L.proximity_desc = "Visualizza il monitor di prossimità al momento opportuno durante il combattimento, con i giocatori che stanno troppo vicino a te."
L.adds = "Adds"
L.adds_desc = "Abilita le varie funzioni relative agli add che usciranno durante il boss."
--L.health = "Health"
--L.health_desc = "Enable functions for displaying various health information during the boss encounter."

L.already_registered = "|cffff0000ATTENZIONE:|r |cff00ff00%s|r (|cffffff00%s|r) esiste già come modulo di BigWigs, ma qualcosa sta cercando di caricarlo di nuovo. Questo solitamente significa che hai due copie di questo modulo nella cartella addons a causa di qualche aggiornamento sbagliato. È consigliabile reinstallare BigWigs cancellando tutte le cartelle BigWigs."
L.testNameplate = "Bersaglio rilevato, creo una barra di test sulla barra del bersaglio. |cFF33FF99Questa funzione è usata raramente, di solito è solo una barra, e serve per tracciare i tempi di recupero mentre si combattono più boss/add che lanciano la stessa magia.|r"

-- Loader / Options.lua
L.officialRelease = "Stai usando una versione ufficiale di BigWigs %s (%s)"
L.alphaRelease = "Stai usando una VERSIONE ALPHA di BigWigs %s (%s)"
L.sourceCheckout = "Stai usando una versione di BigWigs %s presa direttamente dal repository."
L.guildRelease = "Stai utilizzando la versione %d di BigWigs creata per la tua Gilda, basata sulla versione %d dell'addon ufficiale."
L.getNewRelease = "BigWigs non è aggiornato (/bwv) ma puoi farlo semplicemente usando CurseForge Client. In alternativa puoi aggiornarlo manualmente da curseforge.com o wowinterface.com."
L.warnTwoReleases = "BigWigs è indietro di due versioni! La tua versione può avere dei bug, funzioni mancanti, o timer sbagliati. Ti consigliamo di aggiornare."
L.warnSeveralReleases = "|cffff0000BigWigs è vecchio di %d versioni!! Ti consigliamo FORTEMENTE di aggiornare per evitare problemi di sincronizzazione con gli altri giocatori!|r"
L.warnOldBase = "Stai utilizzando una versione di BigWigs per la gilda (%d), ma la tua versione base (%d) è vecchia di %d versioni. Potrebbe avere dei problemi."

L.tooltipHint = "|cffeda55fClic-Destro|r per aprire le Opzioni."
L.activeBossModules = "Moduli dei Combattimenti Attivi:"

L.oldVersionsInGroup = "Hai giocatori nel tuo gruppo con versioni obsolete oppure senza BigWigs. Puoi avere maggiori dettagli scrivendo /bwv."
L.upToDate = "Aggiornati:"
L.outOfDate = "Obsoleti:"
L.dbmUsers = "Utilizzatori DBM:"
L.noBossMod = "Nessun Boss mod:"
L.offline = "Disconnesso"

L.missingAddOn = "L'addon |cFF436EEE%s|r è mancante!"
L.disabledAddOn = "L'addon |cFF436EEE%s|r è disattivato, i timer non saranno mostrati."
L.removeAddOn = "Per favore rimuovi '|cFF436EEE%s|r' perché è stato rimpiazzato da '|cFF436EEE%s|r'."
L.alternativeName = "%s (|cFF436EEE%s|r)"

L.expansionNames = {
	"Classiche", -- Classic
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
L.currentSeason = "Stagione attuale"

-- Media.lua (These are the names of the sounds in the dropdown list in the "sounds" section)
L.Beware = "Attenti! (Algalon)"
L.FlagTaken = "Bandiera catturata (PvP)"
L.Destruction = "Distruzione (Kil'jaeden)"
L.RunAway = "Scappa ragazzina, scappa!!! (Lupo Cattivo)"
L.spell_on_you = "BigWigs: Abilità su di te"
L.spell_under_you = "BigWigs: Abilità sotto di te"

-- Options.lua
L.options = "Opzioni"
--L.optionsKey = "ID: %s" -- The ID that messages/bars/options use
L.raidBosses = "Boss delle Incursioni"
L.dungeonBosses = "Boss delle Spedizioni"
L.introduction = "Benvenuto in BigWigs, dove imposti i combattimenti dei boss. Allacciati le cinture, Prendi le patatine e goditi il viaggio. Non mangia i tuoi bambini, ma ti aiuta a preparare i nuovi boss in modo completo per le tue incursioni."
L.toggleAnchorsBtnShow = "Mostra Ancoraggi"
L.toggleAnchorsBtnHide = "Nascondi Ancoraggi"
L.toggleAnchorsBtnShow_desc = "Mostra tutti i punti di ancoraggio, permettendoti di muovere le barre, i messaggi e quant'altro."
L.toggleAnchorsBtnHide_desc = "Nasconde tutti i punti di ancoraggio. bloccando tutto sul posto."
L.testBarsBtn = "Crea Barra Test"
L.testBarsBtn_desc = "Crea una barra test per provare le tue impostazioni attuali."
L.sound = "Suoni"
L.minimapIcon = "Icona MiniMappa"
L.minimapToggle = "Visualizza/Nasconde l'icona di BigWigs nella minimappa."
--L.compartmentMenu = "No compartment icon"
--L.compartmentMenu_desc = "Turning this option off will make BigWigs show up in the addon compartment menu. We recommend leaving this option enabled."
L.configure = "Configura"
L.test = "Prova"
L.resetPositions = "Ripristina le Posizioni"
L.colors = "Colori"
L.selectEncounter = "Seleziona il Combattimento"
L.listAbilities = "Elenca le Abilità nella Chat"

L.dbmFaker = "Fingi di usare DBM"
L.dbmFakerDesc = "Se un'utente DBM effettua un controllo di versione per vedere chi usa DBM, ti vedranno nella lista. Utile per quelle gilde che obbligano ad usare DBM."
L.zoneMessages = "Mostra messaggi di zona"
L.zoneMessagesDesc = "Disabilitando questa opzione BigWigs non mostrerà più i messaggi per avvisare che esistono moduli con timer/barre ecc. disponibili ma che tu non hai installato. Raccomandiamo di lasciare attiva questa opzione perché è una notifica che vedrai solo quando verranno creati timer e quant'altro per una nuova zona che potresti trovare utile."
L.englishSayMessages = "Abilita solo messaggi in inglese in chat dici"
L.englishSayMessagesDesc = "Tutti i messaggi in 'dici' e 'urla' che mandi durante un boss saranno sempre in inglese. Può essere utile se ti trovi in un gruppo con lingue diverse."

L.slashDescTitle = "|cFFFED000Comandi Slash:|r"
L.slashDescPull = "|cFFFED000/pull:|r Invia un conto alla rovescia per l'ingaggio alla tua incursione."
L.slashDescBreak = "|cFFFED000/break:|r Invia un timer di pausa a tutta la tua incursione."
L.slashDescRaidBar = "|cFFFED000/raidbar:|r Invia una barra personalizzata alla tua Incursione."
L.slashDescLocalBar = "|cFFFED000/localbar:|r Crea una barra personale solo per te stesso."
L.slashDescRange = "|cFFFED000/range:|r Apri l'indicatore di prossimità."
L.slashDescVersion = "|cFFFED000/bwv:|r Esegui un controllo di versione di BigWigs."
L.slashDescConfig = "|cFFFED000/bw:|r Apri la configurazione di BigWigs."

L.gitHubDesc = "|cFF33FF99BigWigs è un software open source in hosting su GitHub. Siamo sempre alla ricerca di nuove persone per aiutarci e tutti sono benvenuti per ispezionare il nostro codice, contribuire allo sviluppo e inviare segnalazioni di bug. BigWigs è grande grazie all'aiuto della community di WoW.|r"

L.BAR = "Barre"
L.MESSAGE = "Messaggi"
L.ICON = "Icona"
L.SAY = "Parla"
L.FLASH = "Lampeggio"
L.EMPHASIZE = "Enfatizza"
L.ME_ONLY = "Solo quando su di me"
L.ME_ONLY_desc = "Quando abiliti questa opzione i messaggi per questa abilità verranno mostrati solo quando affliggono te stesso e non gli altri. Per esempio, 'Bomba: Giocatore' verrà mostrato solo se è su di te."
L.PULSE = "Pulsazione"
L.PULSE_desc = "In aggiunta al Lampeggio sullo schermo, puoi avere anche un'icona relativa a questa specifica abilità piazzata momentaneamente al centro dello schermo per aiutarti a focalizzare la tua attenzione."
L.MESSAGE_desc = "Molte abilità dei boss hanno uno o più messaggi di BigWigs sullo schermo. Se disabiliti questa opzione, nessun messaggio allegato a quest'opzione verrà visualizzato."
L.BAR_desc = "Le Barre vengono visualizzate al momento giusto in alcuni combattimenti. Se questa abilità è accompagnata da una barra che tu preferisci nascondere, disabilita questa opzione."
L.FLASH_desc = "Alcune abilità sono più importanti di altre. Se vuoi che lo schermo lampeggi quando questa abilità sta per essere lanciata o è usata, seleziona questa opzione."
L.ICON_desc = "BigWigs può evidenziare i giocatori affetti da alcune abilità con un simbolo. Questo rende più facile vederli."
L.SAY_desc = "I messaggi sul canale 'Parla' sono facili da identificare grazie ai fumetti che creano. BigWigs userà un mesaggio sul canale 'Parla' per avvisare chi sta vicino a te."
L.EMPHASIZE_desc = "Abilitando questa opzione verrà enfatizzato qualsiasi messaggio associato con questa abilità. rendendoli più grandi e visibili. Puoi impostare la dimensione e il carattere dei messaggi enfatizzati nelle opzioni principali alla voce \"Messaggi\"."
L.PROXIMITY = "Monitor di Prossimità"
L.PROXIMITY_desc = "A volte le abilità richiedono che si stia lontano o vicino. Il Monitor di prossimità è nato per questa necessità e ti mette in condizione di capire quando sei al sicuro."
L.ALTPOWER = "Visualizzazione potere alternativo"
L.ALTPOWER_desc = "Alcuni scontri usano la meccanica del potere alternativo sui membri del gruppo. La visualizzazione del potere alternativo mostra un breve riassunto su chi ha meno/più potere alternativo, che può essere utile per tattiche specifiche o per le assegnazioni."
L.TANK = "Solo Difensori"
L.TANK_desc = "Alcune abilità sono rilevanti solo per i Difensori. Se vuoi vedere questi avvertimenti anche se non è il tuo ruolo, disabilita questa opzione."
L.HEALER = "Solo Guaritori"
L.HEALER_desc = "Alcune abilità sono rilevanti solo per i Guaritori. Se vuoi vedere questi avvertimenti anche se non è il tuo ruolo, disabilita questa opzione."
L.TANK_HEALER = "Solo Difensori e Guaritori"
L.TANK_HEALER_desc = "Alcune abilità sono rilevanti solo per i Difensori e i Guaritori. Se vuoi vedere questi avvertimenti anche se non è il tuo ruolo, disabilita questa opzione."
L.DISPEL = "Solo Dissolutori"
L.DISPEL_desc = "Se vuoi vedere gli avvisi per questa abilità, anche se non puoi dissiparla, disabilita questa opzione."
L.VOICE = "Voce"
L.VOICE_desc = "Se hai un plugin vocale installato, questa opzione lo indurrà a riprodurre un file sonoro per annunciarti l'avvertimento."
L.COUNTDOWN = "Conto alla rovescia"
L.COUNTDOWN_desc = "Se abilitato, un conto alla rovescia vocale e visuale verrà aggiunto per gli ultimi 5 secondi. Immagina qualcuno che esegue un conto alla rovescia \"5... 4... 3... 2... 1...\" con numeri grandi proprio nel centro dello schermo."
L.CASTBAR_COUNTDOWN = "Conto alla rovescia (Solo barre dei lanci)"
L.CASTBAR_COUNTDOWN_desc = "Se abilitato, un avviso verbale e visivo saranno aggiunti per negli ultimi 5 secondi delle barre dei lanci."
L.INFOBOX = L.infobox
L.INFOBOX_desc = L.infobox_desc
L.SOUND = "Suono"
L.SOUND_desc = "Le abilità dei boss di solito riproducono dei suoni per aiutarti ad avvertirle. Se disattivi questa opzione non verrà riprodotto alcun suono."
L.CASTBAR = "Barra di lancio"
L.CASTBAR_desc = "Le barre di lancio sono mostrate su alcuni boss, per avvertirti di abilità in arrivo. Se questa abilità è accompagnata da una barra di lancio che vuoi nascondere, disattiva questa opzione."
L.SAY_COUNTDOWN = "Dici il conto alla rovescia"
L.SAY_COUNTDOWN_desc = "I fumetti delle chat sono facili da vedere. BigWigs scriverà messaggi multipli per mostrare il conto alla rovescia ai tuoi alleati vicini."
L.ME_ONLY_EMPHASIZE = "Enfatizza (solo per me)"
L.ME_ONLY_EMPHASIZE_desc = "Se attivo enfatizzerà tutti i messaggi associati a questa abilità SOLO se lanciati su di te, rendendoli più grandi e più visibili."
L.NAMEPLATEBAR = "Barre dei nomi"
L.NAMEPLATEBAR_desc = "Le barre sono mostrate vicino alle barre dei nomi se più di un nemico lancia la stessa abilità. Se questa abilità è associata ad una barra dei nomi che vuoi nascondere, disattiva questa opzione."
L.PRIVATE = "Auree privata"
L.PRIVATE_desc = "Le auree private non possono essere tracciare normalmente, ma il suono ''su di te'' può essere impostato nella tabella dei suoni."

L.advanced = "Opzioni Avanzate"
L.back = "<< Indietro"

L.tank = "|cFFFF0000Messaggio solo per Difensori.|r "
L.healer = "|cFFFF0000Messaggio solo per Guaritori.|r "
L.tankhealer = "|cFFFF0000Messaggio per Difensori e Guaritori.|r "
L.dispeller = "|cFFFF0000Messaggio solo per Dissolutori Magici.|r "

-- Statistics
L.statistics = "Statistiche"
L.LFR = "RDI"
L.normal = "Normale"
L.heroic = "Eroica"
L.mythic = "Mitica"
L.wipes = "Fallimenti:"
L.kills = "Uccisioni:"
L.best = "Migliore:"
