local _, addonTbl = ...
local L = addonTbl.API:NewLocale("BigWigs", "itIT")
if not L then return end

L.tempRenameFeat = "Ora puoi |cFF436EEErinominare|r qualsiasi abilità dei boss aprendo le sue opzioni avanzate (>>) e cliccando sulla scheda Rinomina."

-- API.lua
L.showAddonBar = "L'addon '|cFF436EEE%s|r' ha creato la barra '%s'."
L.requestAddonProfile = "L' addon '|cFF436EEE%s|r' ha realizzato una copia della stringa da esportare per il tuo profilo chiamata |cFF33FF99'%s'|r."
L.shortMinutesAndSeconds = "%d Min %d Sec" -- 1 Minute 2 Seconds
L.shortSecondsOnly = "%d Sec" -- 28 Seconds
L.shortSubTenSeconds = "%.1f Sec" -- 3.2 Seconds
L.accept = "Accetta"
L.cancel = "Annulla"
L.confirm_profile_swap = "L' addon |cFF436EEE\"%s\"|r vuole cambiare automaticamente il tuo profilo di BigWigs in un altro profilo chiamato:\n\n|cFF33FF99\"%s\"|r\n\nSei sicuro di volerlo fare?"

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
L.health = "Salute"
L.health_desc = "Abilita le funzioni per visualizzare le varie informazioni che riguardano la Salute durante l'incontro col boss"
L.energy = "Energia"
L.energy_desc = "Abilita le funzioni per visualizzare informazioni sui vari livelli di energia durante l'incontro col boss."

L.already_registered = "|cffff0000ATTENZIONE:|r |cff00ff00%s|r (|cffffff00%s|r) esiste già come modulo di BigWigs, ma qualcosa sta cercando di caricarlo di nuovo. Questo solitamente significa che hai due copie di questo modulo nella cartella addons a causa di qualche aggiornamento sbagliato. È consigliabile reinstallare BigWigs cancellando tutte le cartelle BigWigs."

-- Loader / Options.lua
L.okay = "OK"
L.officialRelease = "Stai usando una versione ufficiale di BigWigs %s (%s)."
L.alphaRelease = "Stai usando una VERSIONE ALPHA di BigWigs %s (%s)."
L.sourceCheckout = "Stai usando una versione di BigWigs %s presa direttamente dal repository."
L.littlewigsOfficialRelease = "Stai usando una versione ufficiale di LittleWigs (%s)."
L.littlewigsAlphaRelease = "Stai usando una VERSIONE ALPHA di LittleWigs (%s)."
L.littlewigsSourceCheckout = "Stai usando una versione di LittleWigs presa direttamente dal repository."
L.guildRelease = "Stai utilizzando la versione %d di BigWigs creata per la tua Gilda, basata sulla versione %d dell'addon ufficiale."
L.getNewRelease = "BigWigs non è aggiornato (/bwv) ma puoi farlo semplicemente usando CurseForge Client. In alternativa puoi aggiornarlo manualmente da curseforge.com o addons.wago.io."
L.warnTwoReleases = "BigWigs è indietro di due versioni! La tua versione può avere dei bug, funzioni mancanti, o timer sbagliati. Ti consigliamo di aggiornare."
L.warnSeveralReleases = "|cffff0000BigWigs è vecchio di %d versioni!! Ti consigliamo FORTEMENTE di aggiornare per evitare problemi di sincronizzazione con gli altri giocatori!|r"
L.warnOldBase = "Stai utilizzando una versione di BigWigs per la gilda (%d), ma la tua versione base (%d) è vecchia di %d versioni. Potrebbe avere dei problemi."

L.tooltipHint = "|cffeda55fClic-Destro|r per aprire le Opzioni."
L.activeBossModules = "Moduli dei Combattimenti Attivi:"

L.oldVersionsInGroup = "Hai giocatori nel tuo gruppo con |cffff0000versioni vecchie|r di BigWigs. Puoi avere maggiori dettagli scrivendo /bwv."
L.upToDate = "Aggiornati:"
L.outOfDate = "Obsoleti:"
L.dbmUsers = "Utilizzatori DBM:"
L.noBossMod = "Nessun Boss mod:"
L.offline = "Disconnesso"

L.missingAddOnPopup = "L'addon |cFF436EEE%s|r è mancante!"
L.missingAddOnRaidWarning = "L'addon |cFF436EEE%s|r è mancante! Nessun timer sarà visualizzato in questa zona!"
L.outOfDateAddOnPopup = "L'addon |cFF436EEE%s|r non è aggiornato!"
L.outOfDateAddOnRaidWarning = "L'addon |cFF436EEE%s|r non è aggiornato! Tu hai v%d.%d.%d ma il piu recente è v%d.%d.%d!"
L.disabledAddOn = "L'addon |cFF436EEE%s|r è disattivato, i timer non saranno mostrati."
L.removeAddOn = "Per favore rimuovi '|cFF436EEE%s|r' perché è stato rimpiazzato da '|cFF436EEE%s|r'."
L.outOfDateContentPopup = "WARNING!\nHai aggiornato |cFF436EEE%s|r ma devi anche aggiornare l'addon principale|cFF436EEEBigWigs|r.\nIgnorando questo poterà a funzionalità anomala e non funzionante."
L.outOfDateContentRaidWarning = "|cFF436EEE%s|r richiede la versione %d dell' addon principale |cFF436EEEBigWigs|r per funzionare correttamente, tu hai la versione %d installata attualmente."
L.addOnLoadFailedWithReason = "BigWigs ha fallito di caricare l'addon |cFF436EEE%s|r per %q. Digli ai devs di BigWigs!"
L.addOnLoadFailedUnknownError = "BigWigs ha trovato un errore quando cercava di caricare l'addon |cFF436EEE%s|r. Digli ai devs di BigWigs!"
L.newFeatures = "Nuove funzioni di BigWigs:"
L.parentheses = "%s (%s)"

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
	"Midnight", -- Midnight
}
L.littleWigsExtras = {
	["LittleWigs_Delves"] = "Scorribande",
	["LittleWigs_CurrentSeason"] = "Stagione attuale",
}
L.dayNamesShort = {
	"DOM", -- Sunday
	"LUN", -- Monday
	"MAR", -- Tuesday
	"MER", -- Wednesday
	"GIO", -- Thursday
	"VEN", -- Friday
	"SAB", -- Saturday
}
L.dayNames = {
	"Domenica",
	"Lunedì",
	"Martedì",
    "Mercoledì",
	"Giovedì",
	"Venerdì",
	"Sabato",
}
L.monthNames = {
	"Gennaio",
	"Febbraio",
	"Marzo",
	"Aprile",
	"Maggio",
	"Giugno",
	"Luglio",
	"Agosto",
	"Settembre",
	"Ottobre",
	"Novembere",
	"Dicembre",
}
L.dateFormat = "%s %d %s %d" -- Date format: "Monday 1 January 2025"

-- Media.lua (These are the names of the sounds in the dropdown list in the "sounds" section)
L.Beware = "Attenti! (Algalon)"
L.FlagTaken = "Bandiera catturata (PvP)"
L.Destruction = "Distruzione (Kil'jaeden)"
L.RunAway = "Scappa ragazzina, scappa!!! (Lupo Cattivo)"
L.spell_on_you = "BigWigs: Abilità su di te"
L.spell_under_you = "BigWigs: Abilità sotto di te"
L.simple_no_voice = "Simple (Senza Voce)"

-- Options.lua
L.options = "Opzioni"
L.optionsKey = "ID: %s" -- L'ID che i messaggi/barre/opzioni useranno
L.raidBosses = "Boss delle Incursioni"
L.dungeonBosses = "Boss delle Spedizioni"
L.introduction = "Benvenuto in BigWigs, dove imposti i combattimenti dei boss. Allacciati le cinture, Prendi le patatine e goditi il viaggio. Non mangia i tuoi bambini, ma ti aiuta a preparare i nuovi boss in modo completo per le tue incursioni."
L.sound = "Suono"
L.minimapIcon = "Icona MiniMappa"
L.minimapToggle = "Visualizza/Nasconde l'icona di BigWigs nella minimappa."
L.compartmentMenu = "No Icona menu addon"
L.compartmentMenu_desc = "Disattivando quest'opzione farà in modo che BigWigs figurerà nella zona addon del menu. Consigliamo di lasciare quest'opzione abilitata."
L.configure = "Configura"
L.resetPositions = "Ripristina le Posizioni"
L.selectEncounter = "Seleziona il Combattimento"
L.primary_aura_spellId = "\n|cFFFFFF99ID spell primario: %d|r"
L.secondary_aura_spellIds = "|cFFFFFF99ID spell secondarie: %s|r"
L.onApplied = "All'applicazione"
L.onDose = "Ad ogni carica"
L.onRemoved = "Alla rimozione"
L.privateAuraSounds = "Suoni per le Aura Private"
L.privateAuraSounds_desc = "Le aure private non possono essere tracciate normalmente, ma puoi impostare un suono da riprodurre quando il debuff dell'abilità ti viene applicato."
L.listAbilities = "Elenca le Abilità nella Chat"
L.parenthesesID = "%s |cffA5A5A5(ID: %s)|r"

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
L.SOUND = L.sound
L.SOUND_desc = "Le abilità dei boss di solito riproducono dei suoni per aiutarti ad avvertirle. Se disattivi questa opzione non verrà riprodotto alcun suono."
L.CASTBAR = "Barra di lancio"
L.CASTBAR_desc = "Le barre di lancio sono mostrate su alcuni boss, per avvertirti di abilità in arrivo. Se questa abilità è accompagnata da una barra di lancio che vuoi nascondere, disattiva questa opzione."
L.SAY_COUNTDOWN = "Dici il conto alla rovescia"
L.SAY_COUNTDOWN_desc = "I fumetti delle chat sono facili da vedere. BigWigs scriverà messaggi multipli per mostrare il conto alla rovescia ai tuoi alleati vicini."
L.ME_ONLY_EMPHASIZE = "Enfatizza (solo per me)"
L.ME_ONLY_EMPHASIZE_desc = "Se attivo enfatizzerà tutti i messaggi associati a questa abilità SOLO se lanciati su di te, rendendoli più grandi e più visibili."
L.NAMEPLATE = "Barre delle unità"
L.NAMEPLATE_desc = "Se Abilitata, opzioni come icone e testi relativi a questa abilità specifica verrano visualizzate sulle tue barre delle unità. Questo rende più facile vedere quale NPC sta usando un abilità quando ci sono molteplici NPC che la usano."
L.PRIVATE = "Auree privata"
L.PRIVATE_desc = "Le auree private non possono essere tracciate normalmente, ma il suono ''su di te'' può essere impostato nella tabella dei suoni."

L.advanced_options = "Opzioni Avanzate"
L.back = "<< Indietro"

L.tank = "|cFFFF0000Messaggio solo per Difensori.|r "
L.healer = "|cFFFF0000Messaggio solo per Guaritori.|r "
L.tankhealer = "|cFFFF0000Messaggio per Difensori e Guaritori.|r "
L.dispeller = "|cFFFF0000Messaggio solo per Dissolutori Magici.|r "

L.renames = "Rinomina"
L.noteLabel = "%s (|cFFFFFF99%s|r)"
L.renameLabel = "%s (|cFF3366FF%s|r)"
L.renameHeader = "Imposta un nome personalizzato per l'abilità. Questo testo verrà usato al posto del nome dell'incantesimo in tutti i messaggi e in tutte le barre.\n\n"
L.spellName = "Nome dell'Incantesimo"
L.spellNameResetDesc = "Questa abilità ha un nome personalizzato predefinito, clicca su questo pulsante per usare il nome originale (di solito il nome di un incantesimo)."

-- Sharing.lua
L.import = "Importa"
L.import_info = "Dopo che immetti una stringa puoi selezione quali impostazioni vuoi importate. \n Se impostazioni non sono disponibili nella stringa di importazione non saranno selezionabili."
L.import_info_active = "Scegli cosa vuoi importare e poi clicca sul pulsante importa."
L.import_info_none = "|cFFFF0000 La stringa di importo non è compatibile o non è aggiornata.|r"
L.export = "Esporta"
L.export_core = "Esporta Impostazioni Generali"
L.export_info = "Seleziona quali impostazioni vorresti esportare e condividere con gli altri.\n\n|cffff4411 Puoi solo condividere impostazioni generali e quelle non hanno nessun effetto sulle impostazioni specifiche ai boss.|r"
L.export_string = "Esporta Stringa"
L.export_string_desc = "Copia questa stringa BigWigs se vuoi condividere le tue impostazioni."
L.import_string = "Importa Stringa"
L.import_string_desc = "Incolla la stringa BigWigs che vuoi importare qua."
L.position = "Posizione"
L.settings = "Impostazioni"
L.other_settings = "Altre Impostazioni"
L.nameplate_settings_import_desc = "Importa tutte le impostazioni delle barre delle unità."
L.nameplate_settings_export_desc = "Esporta tutte le impostazioni delle barre delle unità."
L.position_import_bars_desc = "Importa la posizone (ancoraggi) delle barre."
L.position_import_messages_desc = "Importa la posizone (ancoraggi) dei messaggi."
L.position_import_countdown_desc = "Importa la posizone (ancoraggi) del conto alla rovescia."
L.position_export_bars_desc = "Esporta la posizone (ancoraggi) delle barre."
L.position_export_messages_desc = "Esporta la posizone (ancoraggi) dei messaggi."
L.position_export_countdown_desc = "Esporta la posizone (ancoraggi) del conto alla rovescia."
L.settings_import_bars_desc = "Importa le impostazioni generali delle barre come dimensioni, font, ecc."
L.settings_import_messages_desc = "Importa le impostazioni generali dei messaggi come dimensioni, font, ecc."
L.settings_import_countdown_desc = "Importa le impostazioni generali del conto alla rovescia come dimensioni, font, ecc."
L.settings_export_bars_desc = "Esporta le impostazioni generali delle barre come dimensioni, font, ecc."
L.settings_export_messages_desc = "Esporta le impostazioni generali dei messaggi come dimensioni, font, ecc."
L.settings_export_countdown_desc = "Esporta le impostazioni generali del conto alla rovescia come dimensioni, font, ecc."
L.colors_import_bars_desc = "Importa i colori delle barre."
L.colors_import_messages_desc = "Importa i colori dei messaggi."
L.color_import_countdown_desc = "Importa i colori del conto alla rovescia."
L.colors_export_bars_desc = "Esporta i colori delle barre."
L.colors_export_messages_desc = "Esporta i colori dei messaggi."
L.color_export_countdown_desc = "Esporta i colori del conto alla rovescia."
L.confirm_import = "Le impostazioni selezionate che stai per importare sovrascriverrano le importazioni nel tuo profilo attualmente selezionato:\n\n|cFF33FF99\"%s\"|r\n\nSei sicuro che vuoi farlo?"
L.confirm_import_addon = "L'addon |cFF436EEE\"%s\"|r vuole importare automaticamente nuove impostazioni BigWigs che sovrascriverrano le importazioni nel tuo profilo attualmente selezionato:\n\n|cFF33FF99\"%s\"|r\n\nSei sicuro che vuoi farlo?"
L.confirm_import_addon_new_profile = "L'addon |cFF436EEE\"%s\"|r vuole creare automaticamente un nuovo profilo BigWigs chiamato:\n\n|cFF33FF99\"%s\"|r\n\nAccettando queste modifiche creerà un nuovo profilo che diventerà quello attivo."
L.confirm_import_addon_edit_profile = "L'addon |cFF436EEE\"%s\"|r vuole modificare automaticamente uno dei tuoi profili BigWigs chiamato:\n\n|cFF33FF99\"%s\"|r\n\nAccettando queste modifiche creerà un nuovo profilo che diventerà quello attivo."
L.no_string_available = "Nessuna stringa di importa. Prima Importa una stringa."
L.no_import_message = "Nessun impostazione è stata importata."
L.import_success = "Importato: %s" -- Imported: Bar Anchors, Message Colors
L.imported_bar_positions = "Posizone barre"
L.imported_bar_settings = "Impostazioni barre"
L.imported_bar_colors = "Colori barre"
L.imported_message_positions = "Posizioni Messaggi"
L.imported_message_settings = "Impostazioni Messaggi"
L.imported_message_colors = "Colori Messaggi"
L.imported_countdown_position = "Posizione Conto alla rovescia"
L.imported_countdown_settings = "Impostazioni Conto alla rovescia"
L.imported_countdown_color = "Colori Conto alla rovescia"
L.imported_nameplate_settings = "Impostazioni barre delle unità"
L.imported_mythicplus_settings = "Impostazzioni Mythic+"
L.mythicplus_settings_import_desc = "Importare tutte le impostazzioni Mythic+."
L.mythicplus_settings_export_desc = "esportare tutte le impostazzioni Mythic+."
L.imported_battleres_settings = "impostazzioni Resurrezioni in Combattimento"
L.battleres_settings_import_desc = "Importare tutte le impostazzioni Resurrezioni in Combattimento."
L.battleres_settings_export_desc = "esportare tutte le impostazzioni Resurrezioni in Combattimento."
L.imported_privateAuras_settings = "Impostazioni Aure Private"
L.privateAuras_settings_import_desc = "Importa tutte le impostazioni delle Aure Private."
L.privateAuras_settings_export_desc = "Esporta tutte le impostazioni delle Aure Private."
L.imported_combattimer_settings = "Impostazioni Timer di Combattimento"
L.combattimer_settings_import_desc = "Importa tutte le impostazioni del Timer di Combattimento."
L.combattimer_settings_export_desc = "Esporta tutte le impostazioni del Timer di Combattimento."
L.export_bosses = "Esporta Boss"
L.export_bosses_info = "La configurazione di tutti i boss nelle zone selezionate qui sotto verrà esportata."
L.raids_section = "Incursioni"
L.expansion_dungeons_section = "Spedizioni dell'Espansione"
L.seasonal_dungeons_section = "Spedizioni Stagionali"
L.confirm_import_addon_boss_settings = "L'addon |cFF436EEE\"%s\"|r vuole cambiare automaticamente le tue impostazioni dei boss di BigWigs per tutti i boss nelle seguenti zone:\n\n|cFFFFFF99%s|r\n\nQuesto verrà applicato al seguente profilo:\n\n|cFF33FF99\"%s\"|r\n\nSei sicuro di volerlo fare?"

-- InstanceSharing.lua
L.sharing_window_title = "Condividi Impostazioni dei Boss"
L.sharing_flags = "Impostazioni Generali"
L.sharing_flags_desc = "Importa le impostazioni che controllano cose come 'mostra barra', 'riproduci suono', 'mostra messaggio' ecc.\nCoprono la maggior parte delle caselle di spunta nelle impostazioni di un'abilità."
L.sharing_export_flags_desc = "Esporta le impostazioni che controllano cose come 'mostra barra', 'riproduci suono', 'mostra messaggio' ecc.\nCoprono la maggior parte delle caselle di spunta nelle impostazioni di un'abilità."
L.sharing_renames_desc = "Importa i nomi personalizzati configurati."
L.sharing_export_renames_desc = "Esporta i nomi personalizzati configurati."
L.sharing_sounds_desc = "Importa quali suoni riprodurre per le abilità."
L.sharing_export_sounds_desc = "Esporta quali suoni riprodurre per le abilità."
L.sharing_auras_desc = "Importa i suoni configurati per le aure."
L.sharing_export_private_auras_desc = "Esporta i suoni configurati per le Aure Private."
L.sharing_colors_desc = "Importa le impostazioni dei colori per barre e messaggi."
L.sharing_export_colors_desc = "Esporta le impostazioni dei colori per barre e messaggi."
L.confirm_instance_import = "Le impostazioni selezionate che stai per importare sovrascriveranno quelle del tuo profilo attualmente selezionato:\n\n|cFF33FF99\"%s\"|r\n\nIstanza:\n|cFFBB66FF\"%s\"|r\n\nSei sicuro di volerlo fare?"
L.status_text_paste_import = "Incolla una stringa di importazione valida"
L.exporting_instance = "Esportazione di |cFFBB66FF%s|r" -- Exporting Molten Core
L.importing_instance = "Importazione di |cFFBB66FF%s|r" -- Importing Molten Core
L.share = "Condividi"

-- Statistics
L.statistics = "Statistiche"
L.defeat = "Sconfitta"
L.defeat_desc = "Numero di volte che sei stato sconfitto da questo Boss."
L.victory = "Vittoria"
L.victory_desc = "Numero di volte che sei stato vittorioso contro questo Boss."
L.fastest = "Più Veloce"
L.fastest_desc = "La vittoria più veloce e la data in cui è successa (Anno/Mese/Giorno)"
L.first = "Primo"
L.first_desc = "La prima volta che sei stato vittorioso contro questo Boss, formattato come:\n[Numero di sconfitte prima della prima vittoria] - [Durata combattimento] - [Anno/Mese/Giorno della vittoria]"

-- Difficulty levels for statistics display on bosses
L.unknown = "Non Trovato"
L.LFR = "RDI"
L.normal = "Normale"
L.heroic = "Eroica"
L.mythic = "Mitica"
L.LFR_timerun = "|A:timerunning-glues-icon:14:14|aRDI"
L.normal_timerun = "|A:timerunning-glues-icon:14:14|aNormale"
L.heroic_timerun = "|A:timerunning-glues-icon:14:14|aEroica"
L.mythic_timerun = "|A:timerunning-glues-icon:14:14|aMitica"
L.timewalk = "Viaggi nel tempo"
L.solotier8 = "Solo Tier 8"
L.solotier11 = "Solo Tier 11"
L.story = "Storia"
L.mplus = "Mitica+ %d"
L.SOD = "Stagione della scoperta"
L.hardcore = "Hardcore"
L.level1 = "Livello 1"
L.level2 = "Livello 2"
L.level3 = "Livello 3"
L.N10 = "Normale 10"
L.N25 = "Normale 25"
L.H10 = "Eroico 10"
L.H25 = "Eroico 25"
L.titan = "Titan" -- Chinese-only "Titan Reforged" servers
L.mythic_flex = "Mitica (Flex)" -- Mythic (Flexible 15-25 player raids)
L.world = "Mondo" -- World (The first difficulty for Lairs in Retail WoW, essentially the same as LFR since its World -> Normal -> Heroic -> Mythic)

-----------------------------------------------------------------------
-- TOOLS
-----------------------------------------------------------------------

L.tools = "Utensili"
L.toolsDesc = "BigWigs fornisce diversi utensili o \"quality of life\" caratteristiche per velocizzare e simplificare il processo delle uccisioni dei bosses."

L.reloadUIWarning = "Modificare questa funzione ricaricherà l'interfaccia, mostrando la schermata di caricamento per un momento. Sei sicuro?"
L.qualityOfLife = "Qualità della Vita"
L.notYetImplemented = "Non Ancora Implementato" -- When a feature hasn't been implemented yet

-----------------------------------------------------------------------
-- AutoInvite.lua
--

L.autoInviteTitle = "Invito Automatico"
L.autoInviteDesc = "Invita automaticamente i giocatori nel tuo gruppo quando ti sussurrano una parola chiave specifica tra quelle nell'elenco qui sotto."
L.yes = "Sì"
L.no = "No"
L.addWords = "Aggiungi Parole"
L.removeWords = "Rimuovi Parole (Clicca per Eliminare)"
L.invalidWordWarning = "La parola deve essere in minuscolo e non essere già presente nell'elenco."
L.groupIsFullConvertToRaid = "Il gruppo è pieno. Convertire in incursione?"
L.whisperToPlayerMyGroupIsFull = "[BigWigs] Il mio gruppo ora è pieno."
L.keywordDetectedInvitingPlayer = "Parola chiave rilevata, invito %s."

-----------------------------------------------------------------------
-- AutoRole.lua
--

L.autoRoleTitle = "Auto Ruolo"
L.autoRoleExplainer = "Quando ti unisci ad un gruppo, o cambii le tue spec mentre sei gia in gruppo, BigWigs cambierà automaticamente il tuo ruolo nel gruppo (Tank, Healer, DPS).\n\n"

-----------------------------------------------------------------------
-- BattleRes.lua
--

L.battleResTitle = "Resurrezione in Combattimento"
L.battleResDesc = "Un'icona che mostra quante cariche di resurrezione in combattimento sono disponibili e il tempo mancante alla prossima carica."
L.battleResDesc2 = "\nLa tua |cFF33FF99Cronologia Resurrezioni in Combattimento|r può essere consultata nel tooltip quando porti il mouse sopra l'icona.\nNota: Il tooltip viene mostrato solo quando sei fuori dal combattimento.\n\n"
L.battleResHistory = "Cronologia Resurrezioni in Combattimento:"
L.battleResResetAll = "Reimposta tutte le impostazioni Resurrezioni in Combattimento ai loro valori predefiniti."
L.battleResDurationText = "Testo Durata"
L.battleResChargesText = "Testo Cariche"
L.battleResNoCharges = "0 cariche disponibili"
L.battleResHasCharges = "1 o più cariche disponibili"
L.battleResPlaySound = "Riproduci un suono quando ottieni una nuova carica"
L.iconTextureSpellID = "|T%d:0:0:0:0:64:64:4:60:4:60|t Grafica Icona (ID Incantesimo)"
L.iconTextureSpellIDError = "Devi inserire un ID incantesimo valido da usare come grafica dell'icona."
L.battleResModeIcon = "Modalità: Icona"
L.battleResModeText = "Modalità: Solo Testo"
L.battleResModeTextTooltip = "Viene mostrato uno sfondo temporaneo per aiutarti a spostare la funzione Resurrezioni in Combattimento e per vedere dove si trova l'area attiva al passaggio del mouse."

-----------------------------------------------------------------------
-- CombatTimer.lua
--

L.combatTimerTitle = "Timer di Combattimento"
L.anyCombatTimer = "Timer per Qualsiasi Combattimento"
L.anyCombatTimerDesc = "Un timer che mostra da quanto tempo sei in combattimento, con un tooltip per vedere la cronologia dei combattimenti."
L.anyCombatTimerTooltip = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|tCronologia Combattimenti"
L.bossCombatTimer = "Timer di Combattimento con il Boss"
L.bossCombatTimerDesc = "Un timer che mostra da quanto tempo sei in combattimento con un boss, con un tooltip per vedere la cronologia dei combattimenti con i boss."
L.bossCombatTimerTooltip = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|tCronologia Combattimenti con i Boss"
L.bossStagesTimer = "Timer delle Fasi del Boss"
L.bossStagesTimerDesc = "Un timer che si azzera ogni volta che il combattimento con un boss cambia fase, con un tooltip per vedere la cronologia delle fasi del boss. Attivo solo sui boss con più fasi."
L.bossStagesTimerTooltip = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|tCronologia Fasi del Boss"
L.instanceTimer = "Timer dell'Istanza"
L.instanceTimerDesc = "Un timer che mostra da quanto tempo sei in un'istanza (spedizione/incursione/ecc.), con un tooltip per vedere la cronologia delle istanze."
L.instanceTimerTooltip = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|tCronologia Istanze"

L.backgroundColor = "Colore Sfondo"
L.inactive = "Inattivo"
L.whenInactive = "Quando Inattivo"
L.doNothing = "Non Fare Nulla"
L.hide = "Nascondi"
L.colorFade = "Colore/Scomparsa"
L.inProgress = "In corso"
L.textFormat = "Formato del testo"
L.tooltipHistoryMaxLines = "Cronologia: Righe massime"
L.tooltipHistoryMaxLinesDesc = "Scegli quante righe di cronologia deve mostrare il tooltip."
L.tooltipHistoryResetConditions = "Cronologia: Condizioni di reimpostazione"
L.tooltipHistoryResetConditionsDesc = "Scegli le condizioni in base alle quali la cronologia del tooltip deve essere reimpostata."
L.enteringRaid = "Ingresso in un'incursione"
L.enteringDungeon = "Ingresso in una spedizione"
L.startingMythicKeystone = "Inizio di una Mitica+"
L.historyTimeFormat = "Cronologia: Formato dell'ora"
L.twelveHour = "12 ore"
L.twentyFourHour = "24 ore"
L.hideTooltipInCombat = "Nascondi il tooltip in combattimento"
L.customText = "Testo personalizzato (deve contenere %s)"

-----------------------------------------------------------------------
-- Keystones.lua
--

L.keys = "Chiavi"

L.keystoneTitle = "BigWigs Chiavi del Potere"
L.keystoneHeaderParty = "Gruppo"
L.keystoneRefreshParty = "Aggiorna Gruppo"
L.keystoneHeaderGuild = "Gilda"
L.keystoneRefreshGuild = "Aggiorna Gilda"
L.keystoneLevelTooltip = "Livello della chiave: |cFFFFFFFF%s|r"
L.keystoneMapTooltip = "Spedizione: |cFFFFFFFF%s|r"
L.keystoneRatingTooltip = "Punteggio Mitica+: |cFFFFFFFF%d|r"
L.keystoneHiddenTooltip = "Il giocatore ha scelto di nascondere questa informazione."
L.keystoneTabOnline = "Connessi"
L.keystoneTabAlts = "Alt"
L.keystoneTabTeleports = "Teletrasporti"
L.keystoneHeaderMyCharacters = "I Miei Personaggi"
L.keystoneTeleportNotLearned = "L'incantesimo di teletrasporto '|cFFFFFFFF%s|r' |cFFFF4411non è ancora stato appreso|r."
L.keystoneTeleportOnCooldown = "L'incantesimo di teletrasporto '|cFFFFFFFF%s|r' è attualmente |cFFFF4411in recupero|r per %d |4ora:ore; e %d |4minuto:minuti;."
L.keystoneTeleportReady = "L'incantesimo di teletrasporto '|cFFFFFFFF%s|r' è |cFF33FF99pronto|r, clicca per lanciarlo."
L.keystoneTeleportInCombat = "Non puoi teletrasportarti qui mentre sei in combattimento."
L.keystoneTabHistory = "Cronologia"
L.keystoneHeaderThisWeek = "Questa Settimana"
L.keystoneHeaderOlder = "Precedenti"
L.keystoneScoreGainedTooltip = "Punteggio Guadagnato: |cFFFFFFFF+%d|r\nPunteggio Spedizione: |cFFFFFFFF%d|r"
L.keystoneCompletedTooltip = "Completata in tempo: |cFFFFFFFF%d min %d sec|r\nTempo Limite: |cFFFFFFFF%d min %d sec|r"
L.keystoneFailedTooltip = "Non completata in tempo: |cFFFFFFFF%d min %d sec|r\nTempo Limite: |cFFFFFFFF%d min %d sec|r"
L.keystoneExplainer = "Una raccolta di strumenti vari per migliorare l'esperienza in Mitica+."
L.keystoneAutoSlot = "Inserisci automaticamente la chiave"
L.keystoneAutoSlotDesc = "Inserisce automaticamente la tua chiave nell'alloggiamento quando apri la Fonte del Potere."
L.keystoneAutoSlotMessage = "%s inserita automaticamente nell'alloggiamento per le chiavi."
L.keystoneAutoSlotFrame = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:14:14|t Chiave Inserita Automaticamente"
L.keystoneModuleName = "Mitica+"
L.keystoneStartBar = "%s +%d" -- Format is SHORT_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "ROOK +12"
L.keystoneStartMessage = "%s +%d inizia adesso!" -- Format is LONG_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "The Rookery +12 begins now!"
L.keystoneCountdownExplainer = "Quando inizi una spedizione Mitica+ verrà riprodotto un conto alla rovescia. Scegli quale voce vuoi sentire e quando vuoi che il conto alla rovescia cominci.\n\n"
L.keystoneCountdownBeginsDesc = "Scegli quanto tempo deve mancare al timer di inizio della Mitica+ perché il conto alla rovescia cominci."
L.keystoneCountdownBeginsSound = "Riproduci un suono quando inizia il conto alla rovescia della Mitica+"
L.keystoneCountdownEndsSound = "Riproduci un suono quando termina il conto alla rovescia della Mitica+"
L.keystoneViewerTitle = "Visualizzatore Chiavi"
L.keystoneHideGuildTitle = "Nascondi la mia chiave ai membri della gilda"
L.keystoneHideGuildDesc = "|cffff4411Non raccomandato.|r Questa funzione impedirà ai membri della tua gilda di vedere quale chiave possiedi. Chiunque sia nel tuo gruppo potrà comunque vederla."
L.keystoneHideGuildWarning = "Impedire ai membri della tua gilda di vedere la tua chiave |cffff4411non è raccomandato|r.\n\nSei sicuro di volerlo fare?"
L.keystoneAutoShowEndOfRun = "Mostra quando la Mitica+ è finita"
L.keystoneAutoShowEndOfRunDesc = "Mostra automaticamente il visualizzatore chiavi quando la spedizione Mitica+ è finita.\n\n|cFF33FF99Può aiutarti a vedere quali nuove chiavi ha ricevuto il tuo gruppo.|r"
L.keystoneViewerExplainer = "Puoi aprire il visualizzatore chiavi usando il comando |cFF33FF99/key|r oppure cliccando il pulsante qui sotto.\n\n"
L.keystoneViewerOpen = "Apri il visualizzatore chiavi"
L.keystoneViewerKeybindingExplainer = "\n\nPuoi anche impostare una scorciatoia da tastiera per aprire il visualizzatore chiavi:\n\n"
L.keystoneViewerKeybindingDesc = "Scegli una scorciatoia da tastiera per aprire il visualizzatore chiavi."
L.keystoneClickToWhisper = "Clicca per aprire una finestra di sussurro"
L.keystoneClickToTeleportNow = "\nClicca per teletrasportarti qui"
L.keystoneClickToTeleportCooldown = "\nTeletrasporto impossibile, incantesimo in recupero"
L.keystoneClickToTeleportNotLearned = "\nTeletrasporto impossibile, incantesimo non appreso"
L.keystoneHistoryRuns = "Totale: %d"
L.keystoneHistoryRunsThisWeekTooltip = "Numero totale di spedizioni questa settimana: |cFFFFFFFF%d|r"
L.keystoneHistoryRunsOlderTooltip = "Numero totale di spedizioni prima di questa settimana: |cFFFFFFFF%d|r"
L.keystoneHistoryScore = "Punteggio: +%d"
L.keystoneHistoryScoreThisWeekTooltip = "Punteggio totale guadagnato questa settimana: |cFFFFFFFF+%d|r"
L.keystoneHistoryScoreOlderTooltip = "Punteggio totale guadagnato prima di questa settimana: |cFFFFFFFF+%d|r"
L.keystoneTimeUnder = "|cFF33FF99-%02d:%02d|r"
L.keystoneTimeOver = "|cFFFF4411+%02d:%02d|r"
L.keystoneTeleportTip = "Clicca sul nome della spedizione qui sotto per |cFF33FF99TELETRASPORTARTI|r direttamente all'ingresso della spedizione."
L.keystoneTimerunner = "|A:timerunning-glues-icon:14:14|aQuesto è un personaggio Corridore nel Tempo." -- Note: Timerunning is a mode like "Legion Remix", it is NOT the same as Timewalking
L.keystoneSlashKeys = "Registra anche il comando slash |cFF33FF99/keys|r"
L.keystoneSlashKeystone = "Registra anche il comando slash |cFF33FF99/keystone|r"
L.unavailableWhilstInCombat = "Non disponibile durante il combattimento"

-- It doesn't really matter what you call it as long as it's recognizable and limited to ~6 characters
L.keystoneShortName_TheRookery = "CORVERIA"
L.keystoneShortName_DarkflameCleft = "FdFO"
L.keystoneShortName_PrioryOfTheSacredFlame = "PdFS"
L.keystoneShortName_CinderbrewMeadery = "MELIFICIO"
L.keystoneShortName_OperationFloodgate = "PARATOIA"
L.keystoneShortName_TheaterOfPain = "TdD"
L.keystoneShortName_TheMotherlode = "VM"
L.keystoneShortName_OperationMechagonWorkshop = "OFFICINA"
L.keystoneShortName_EcoDomeAldani = "ESA"
L.keystoneShortName_HallsOfAtonement = "SDR"
L.keystoneShortName_AraKaraCityOfEchoes = "ARAK"
L.keystoneShortName_TazaveshSoleahsGambit = "AZZARDO"
L.keystoneShortName_TazaveshStreetsOfWonder = "STRADE"
L.keystoneShortName_TheDawnbreaker = "ALBA"
L.keystoneShortName_BlackRookHold = "FC"
L.keystoneShortName_CourtOfStars = "CDS"
L.keystoneShortName_DarkheartThicket = "BC"
L.keystoneShortName_EyeOfAzshara = "ODA"
L.keystoneShortName_HallsOfValor = "SDV"
L.keystoneShortName_MawOfSouls = "MOS"
L.keystoneShortName_NeltharionsLair = "ADN"
L.keystoneShortName_TheArcway = "ARC"
L.keystoneShortName_VaultOfTheWardens = "VOTW"
L.keystoneShortName_ReturnToKarazhanLower = "LOWR"
L.keystoneShortName_ReturnToKarazhanUpper = "KS"
L.keystoneShortName_CathedralOfEternalNight = "COEN"
L.keystoneShortName_SeatOfTheTriumvirate = "SEGGIO"
L.keystoneShortName_WindrunnerSpire = "PDV"
L.keystoneShortName_MagistersTerrace = "TDM"
L.keystoneShortName_MaisaraCaverns = "CDM"
L.keystoneShortName_NexusPointXenas = "PDNX"
L.keystoneShortName_AlgetharAcademy = "ADA"
L.keystoneShortName_Skyreach = "VDC"
L.keystoneShortName_PitOfSaron = "FDS"
L.keystoneShortName_KingsRest = "RdR"
L.keystoneShortName_TempleOfSethraliss = "TDS"
L.keystoneShortName_RubyLifePools = "PDVDR"
L.keystoneShortName_TheBlindingVale = "VA"
L.keystoneShortName_VoidscarArena = "ASV"
L.keystoneShortName_DenOfNalorakk = "TDN"
L.keystoneShortName_MurderRow = "TdI"
L.keystoneShortName_AltarOfFangs = "ADZ"

-- These short names are for the bar that shows during the Mythic+ countdown
-- Use the real dungeon names but make them shorter to fit on the bar better
L.keystoneShortName_TheRookery_Bar = "Corveria"
L.keystoneShortName_DarkflameCleft_Bar = "Faglia di Fiammoscura"
L.keystoneShortName_PrioryOfTheSacredFlame_Bar = "Prioria della Fiamma Sacra"
L.keystoneShortName_CinderbrewMeadery_Bar = "Idromelificio Cinereo"
L.keystoneShortName_OperationFloodgate_Bar = "Operazione: Paratoia"
L.keystoneShortName_TheaterOfPain_Bar = "Teatro del Dolore"
L.keystoneShortName_TheMotherlode_Bar = "Vena Madre"
L.keystoneShortName_OperationMechagonWorkshop_Bar = "Operazione: Meccagon - Officina"
L.keystoneShortName_EcoDomeAldani_Bar = "Ecosfera Al'dani"
L.keystoneShortName_HallsOfAtonement_Bar = "Sale della Redenzione"
L.keystoneShortName_AraKaraCityOfEchoes_Bar = "Ara-Kara, Città degli Echi"
L.keystoneShortName_TazaveshSoleahsGambit_Bar = "Tazavesh: Azzardo di So'leah"
L.keystoneShortName_TazaveshStreetsOfWonder_Bar = "Tazavesh: Strade delle Meraviglie"
L.keystoneShortName_TheDawnbreaker_Bar = "Alba Infranta"
L.keystoneShortName_BlackRookHold_Bar = "Forte Corvonero"
L.keystoneShortName_CourtOfStars_Bar = "Corte delle Stelle"
L.keystoneShortName_DarkheartThicket_Bar = "Boschetto Cuortetro"
L.keystoneShortName_EyeOfAzshara_Bar = "Occhio di Azshara"
L.keystoneShortName_HallsOfValor_Bar = "Sale del Valore"
L.keystoneShortName_MawOfSouls_Bar = "Fauci delle Anime"
L.keystoneShortName_NeltharionsLair_Bar = "Antro di Neltharion"
L.keystoneShortName_TheArcway_Bar = "Arcavia"
L.keystoneShortName_VaultOfTheWardens_Bar = "Segrete delle Custodi"
L.keystoneShortName_ReturnToKarazhanLower_Bar = "Ritorno a Karazhan Inferiore"
L.keystoneShortName_ReturnToKarazhanUpper_Bar = "Ritorno a Karazhan Superiore"
L.keystoneShortName_CathedralOfEternalNight_Bar = "Cattedrale della Notte Eterna"
L.keystoneShortName_SeatOfTheTriumvirate_Bar = "Seggio del Triumvirato"
L.keystoneShortName_WindrunnerSpire_Bar = "Pinnacolo dei Ventolesto"
L.keystoneShortName_MagistersTerrace_Bar = "Terrazza dei Magistri"
L.keystoneShortName_MaisaraCaverns_Bar = "Caverne di Maisara"
L.keystoneShortName_NexusPointXenas_Bar = "Punta del Nexus Xenas"
L.keystoneShortName_AlgetharAcademy_Bar = "Accademia di Algeth'ar"
L.keystoneShortName_Skyreach_Bar = "Vetta dei Cieli"
L.keystoneShortName_PitOfSaron_Bar = "Fossa di Saron"
L.keystoneShortName_KingsRest_Bar = "Requie dei Re"
L.keystoneShortName_TempleOfSethraliss_Bar = "Tempio di Sethraliss"
L.keystoneShortName_RubyLifePools_Bar = "Pozze della Vita di Rubino"
L.keystoneShortName_TheBlindingVale_Bar = "Valle Accecante"
L.keystoneShortName_VoidscarArena_Bar = "Arena Sfregiavuoto"
L.keystoneShortName_DenOfNalorakk_Bar = "Tana di Nalorakk"
L.keystoneShortName_MurderRow_Bar = "Traversa degli Intrighi"
L.keystoneShortName_AltarOfFangs_Bar = "Altare delle Zanne"

-- Instance Keys "Who has a key?"
L.instanceKeysTitle = "Chi ha una chiave?"
L.instanceKeysDesc = "Quando entri in una spedizione mitica, i giocatori che possiedono una chiave per quella spedizione verranno mostrati in un elenco.\n\n"
L.instanceKeysTest8 = "|cFF00FF98Monaco:|r +8"
L.instanceKeysTest10 = "|cFFFF7C0ADruido:|r +10"
L.instanceKeysDisplay = "|c%s%s:|r +%d" -- "PLAYER_NAME: +DUNGEON_LEVEL"
L.instanceKeysDisplayWithDungeon = "|c%s%s:|r +%d (%s)" -- "PLAYER_NAME: +DUNGEON_LEVEL (DUNGEON_NAME)"
L.instanceKeysShowAll = "Mostra sempre tutti i giocatori"
L.instanceKeysShowAllDesc = "Attivando questa opzione verranno mostrati tutti i giocatori nell'elenco, anche se la loro chiave non appartiene alla spedizione in cui ti trovi."
L.instanceKeysOtherDungeonColor = "Colore altre spedizioni"
L.instanceKeysOtherDungeonColorDesc = "Scegli il colore del carattere per i giocatori che hanno chiavi non appartenenti alla spedizione in cui ti trovi."
L.instanceKeysEndOfRunDesc = "Per impostazione predefinita l'elenco viene mostrato solo quando entri in una spedizione mitica. Attivando questa opzione l'elenco verrà mostrato anche al termine della Mitica+."
L.instanceKeysHideTitle = "Nascondi titolo"
L.instanceKeysHideTitleDesc = "Nasconde il titolo \"Chi ha una chiave?\"."

-- Challenges UI Decoration
L.partyRatingHeader = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|tValutazione Gruppo"
L.dungeonScoreString = "|c%s%03d|r |cFFFFFFFF+%02d|r |cFF%s%02d:%02d|r |c%s(%s)|r"
L.dungeonScoreNoDataString = "|cFFFFFFFFNessun dato|r |c%s(%s)|r"
L.dungeonTeleportHeader = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|tTeletrasporto"

-- Progress %
L.progressPercent = "Progresso %"
L.progressPercentDesc = "Strumenti per aiutarti a calcolare quanto progresso otterrai nella Mitica+ da ogni NPC che uccidi."
L.progressPercentTooltip = "Mostra la percentuale di progresso nei tooltip quando passi il mouse sugli NPC nemici"
L.progressPercentTooltipText = {
	"|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|tProgresso: %s%%",
	"|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|tProgresso: %s%% (%d)",
	"|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|tProgresso: %s%% (%d/%d)",
}
L.progressPercentNameplate = "Mostra la percentuale di progresso sulle barre delle unità degli NPC nemici"
L.progressCurrentPull = "Ingaggio Attuale"
L.progressCurrentPullDesc = "Mostra il progresso totale che otterrai dal gruppo di NPC con cui sei attualmente in combattimento.\n\nNON ANCORA FUNZIONANTE!"
L.settingsForCurrentTarget = "Impostazioni per il tuo bersaglio attuale"
L.settingsForOtherTargets = "Impostazioni per tutti gli altri bersagli"

-----------------------------------------------------------------------
-- LFGTimer.lua
--

L.lfgTimerTitle = "LFG Timer"
L.lfgTimerExplainer = "Whenever the LFG queue popup appears, BigWigs will create a timer bar telling you how long you have to accept the queue.\n\n"
L.lfgUseMaster = "Play LFG ready sound on 'Master' audio channel"
L.lfgUseMasterDesc = "When this option is enabled the LFG ready sound will play over the 'Master' audio channel. If you disable this option it will play over the '%s' audio channel instead."

-----------------------------------------------------------------------
-- PLUGINS
-----------------------------------------------------------------------

L.general = "Generale"
L.advanced = "Advanzate"
L.comma = ", "
L.reset = "Reimposta"
L.resetDesc = "Reimposta le impostazioni qui sopra ai loro valori predefiniti."
L.resetAll = "Reimposta tutto"
L.startTest = "Avvia Test"
L.stopTest = "Ferma Test"
L.always = "Sempre"
L.never = "Mai"

L.positionX = "Posizione X"
L.positionY = "Posizione Y"
L.positionExact = "Posizionamento Esatto"
L.positionDesc = "Scrivi nel riquadro o sposta l'indicatore se devi posizionare esattamente la barra dell'ancoraggio."
L.copyCustomAnchorWidth = "Copia la larghezza dell'ancoraggio personalizzato"
L.copyCustomAnchorWidthDesc = "Sovrascrive la tua impostazione di larghezza con la larghezza dell'ancoraggio personalizzato."
L.width = "Larghezza"
L.height = "Altezza"
L.size = "Dimensione"
L.sizeDesc = "In genere regoli la dimesione trascinando l'ancora. Se hai necessità di una dimensione specifica puoi usare la barra slide o digitare i valori nella casella."
L.fontSizeDesc = "Regola la dimensione del carattere usando la barra slide o digitando i valori nella casella che ha un valore molto maggiore di 200."
L.disabled = "Disabilitato"
L.disableDesc = "Stai per disabilitare la funzionalità '%s' che |cffff4411non è consigliata|r.\n\nSei sicuro di questo?"
L.keybinding = "Scorciatoia da tastiera"
L.dragToResize = "Trascina per ridimensionare"
L.cannotMoveInCombat = "Non puoi spostarlo mentre sei in combattimento."

-- Anchor Points
L.UP = "Su"
L.DOWN = "Giù"
L.TOP = "Sopra"
L.RIGHT = "Destra"
L.BOTTOM = "Sotto"
L.LEFT = "Sinistra"
L.TOPRIGHT = "In alto a destra"
L.TOPLEFT = "In alto a sinistra"
L.BOTTOMRIGHT = "In basso a destra"
L.BOTTOMLEFT = "In basso a sinistra"
L.CENTER = "Centro"
L.CENTER_HORIZONTAL = "Centro-Orizzontale"
L.CENTER_VERTICAL = "Centro-Verticale"
L.customAnchorPoint = "Avanzato: Punto di ancoraggio personalizzato"
L.sourcePoint = "Punto di origine"
L.destinationPoint = "Punto di Destinazione"
L.drawStrata = "Strati"
L.medium = "Medio"
L.low = "Basso"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "Potere Alternativo"
L.altPowerDesc = "Il Potere Alternativo verrà mostrato solo per quei boss che applicano Potere Alternativo ai giocatori, cosa estremamente rara. Il display misura l'ammontare di 'Potere Alternativo' tuo e del tuo gruppo, mostrandolo in una lista. Per muovere il riquadro, usa il pulsante di test qui sotto."
L.toggleDisplayPrint = "Mostra il monitor per la prossima volta. Per disabilitarlo completamente in questo scontro, devi deselezionarlo dalle opzioni dello scontro specifico."
L.disabledDisplayDesc = "Disattiva il monitor per tutti gli scontri che lo usano."
L.resetAltPowerDesc = "Reimposta tutte le opzioni relative al Potere Alternativo, compreso il posizionamento dell'ancora di Potere Alternativo."
L.test = "Test"
L.altPowerTestDesc = "Mostra il display 'Potere Alternativo', permettendoti di muoverlo, e simulando i cambiamenti di potere che potresti vedere durante lo scontro con il boss."
L.yourPowerBar = "La tua Barra Potere"
L.barColor = "Colore Barra"
L.barTextColor = "Colore Testo Barra"
L.additionalWidth = "Profondità Addizionale"
L.additionalHeight = "Altezza Addizionale"
L.additionalSizeDesc = "Regola la dimensione del display predefinito usando la barra slide o digitando i valori nella casella che ha un valore molto maggiore di 100."
L.yourPowerTest = "Tuo Potere: %d" -- Tuo Potere: 42
L.yourAltPower = "Tuo %s: %d" -- esempio: Tua Corruzione: 42
L.player = "Giocatore %d" -- Giocatore 7
L.disableAltPowerDesc = "Disabilita totalmente il display del Potere Alternativo, non verrà mai mostrato in nessuno scontro contro i boss."

-----------------------------------------------------------------------
-- Auras.lua
--

L.auras = "Aure" -- Buffs/Debuffs
L.privateAuras = "Aure Private"
L.privateAurasDesc1 = "Le 'Aure Private' sono un tipo speciale di debuff che gli addon non possono rilevare né automatizzare in alcun modo. Ormai questi debuff sono usati in tutti i moderni combattimenti contro i boss.\n\n"
L.privateAurasDesc2 = "BigWigs può aiutarti a tenere traccia di quando ti vengono applicate, mostrandole come icone. |cFF33FF99Questo ti aiuta visualizzando i debuff critici separatamente dai tuoi debuff normali.|r\n\n"
L.aurasDesc = "BigWigs può aiutarti a tenere traccia di quando ti vengono applicati i debuff dei boss, mostrandoli come icone.\n|cFF33FF99Questo ti aiuta visualizzando i debuff critici separatamente dai tuoi debuff normali.|r\n\n"
L.disabledDuringTrash = "Disabilitato durante il Trash"

L.createTestAura = "Crea Aura di Prova"
L.showDispelType = "Mostra Indicatore del Tipo di Dissolvenza"
L.showDispelTypeDesc = "Mostra un'icona sull'aura se ha un tipo di dissolvenza."
L.dispelType = "Indicatore del Tipo di Dissolvenza"
L.iconSize = "Dimensione Icona"
L.iconSpacing = "Spaziatura Icone"
L.showCooldown = "Mostra Spirale di Recupero"
L.showCooldownText = "Mostra Testo di Recupero"
L.cooldownDecimalsThreshold = "Soglia Decimali"
L.cooldownDecimalsThresholdDesc = "A quale soglia in secondi devono essere mostrati i decimali."
L.cooldownTextScale = "Scala Testo di Recupero"
L.growthDirection = "Direzione di Crescita delle Icone"
L.aurasOnYou = "Aure su di Te"
L.aurasOnYouDesc = "Personalizza le icone per le aure che ti vengono applicate.\n\n"
L.aurasOnAnother = "Aure su un Altro Giocatore"
L.aurasOnAnotherDesc = "Scegli un giocatore specifico e poi personalizza le icone per le aure che gli vengono applicate.\n\n"
L.chooseAPlayer = "Scegli un giocatore"
L.theOtherTank = "Trova automaticamente un tank"
L.theOtherTankDesc = "Mostra i debuff del boss sul primo tank diverso da te presente nel tuo gruppo. (Attuale: %s)"
L.onlyWhenYouAreTank = "Mostra solo quando anche tu sei un tank"
L.playerInYourGroup = "Un giocatore del tuo gruppo"
L.tankIndicator = "Indicatore Tank"
L.maxIcons = "Numero Massimo di Icone"
L.maxIconsDesc = "Il numero massimo di icone che verranno mostrate."
L.privateAurasHelpTip = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|tBigWigs: Ora puoi vedere i debuff delle tue aure private come icone, o anche le aure private di un altro giocatore (ad es. un tank)."
L.aurasHelpTip = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|tBigWigs: Ora puoi vedere i tuoi debuff del boss come icone, o anche i debuff del boss di un altro giocatore (ad es. un tank)."

L.aurasTestAnchorText = "Aure\nGiocatore"
L.aurasTestTankAnchorText = "Aure\nTank"

L.auraSounds = "Suoni delle Aure"
L.addAuraSpell = "Aggiungi Incantesimo"
L.addAuraSpellDesc = "Puoi aggiungere gli incantesimi che conosci attualmente indicandone il nome, ma è sempre meglio usare l'ID dell'incantesimo preso dai log."
L.invalidSpell = "Incantesimo non valido"
L.bossDebuffsOnYou = "Debuff del Boss su di Te"
L.bossDebuffsOnTank = "Debuff del Boss sul Tank"
L.showCountText = "Mostra Stack"
L.cooldownText = "Durata del Recupero"
L.countText = "Applicazioni"
L.selectPlayer = "Seleziona Giocatore"
L.myself = "Me stesso"
L.trigger = "Attivazione"
L.remove = "Rimuovi"
L.auraCountdownDesc = "Se abilitato, verrà aggiunto un conto alla rovescia vocale negli ultimi 3 secondi dell'aura."
L.auraDuration = "Durata dell'Aura"
L.auraDurationDesc = "La durata in secondi per cui l'aura rimarrà attiva."
L.currentUnit = "(Attuale: %s)"

-----------------------------------------------------------------------
-- AutoReply.lua
--

L.autoReply = "Risposta automatica"
L.autoReplyDesc = "Risponde automaticamente ai sussuri durante il combattimento con un boss."
L.responseType = "Tipo di risposta"
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

L.bars = "Barre"
L.style = "Stile"
L.bigWigsBarStyleName_Default = "Predefinito"
L.bigWigsBarStyleName_Blizzard = "Blizzard"
L.resetBarsDesc = "Azzera tutte le opzioni delle barre, compresi gli ancoraggi delle barre."
L.testBarsBtn = "Crea Barra Test"
L.testBarsBtn_desc = "Crea una barra test per provare le tue impostazioni attuali."

L.toggleAnchorsBtnShow = "Mostra Ancoraggi"
L.toggleAnchorsBtnHide = "Nascondi Ancoraggi"
L.toggleAnchorsBtnHide_desc = "Nasconde tutti i punti di ancoraggio. bloccando tutto sul posto."
L.toggleBarsAnchorsBtnShow_desc = "Mostra tutti i punti di ancoraggio, permettendoti di muovere le barre."

L.emphasizeAt = "Enfatizza a... (secondi)"
L.growingUpwards = "Cresci verso l'altro"
L.growingUpwardsDesc = "Attiva o disattiva il riempimento crescente o decrescente rispetto al punto di ancoraggio."
L.texture = "Texture"
L.emphasize = L.EMPHASIZE
L.emphasizeMultiplier = "Moltiplicatore di dimensioni"
L.emphasizeMultiplierDesc = "Se disabiliti le barre muovendole dall'ancora di enfatizzazione, questa opzione deciderà la dimensione delle barre enfatizzate moltiplicando la dimensione delle barre normali."

L.enable = "Attiva"
L.move = "Muovi"
L.moveDesc = "Muovi le Barre Enfatizzate all'Ancoraggio di Enfatizzazione. Se questa opzione non è abilitata, le barre enfatizzate cambieranno semplicemente scalatura e colore."
L.emphasizedBars = "Barre Enfatizzate"
L.align = "Allineamento"
L.alignText = "Allinea il Testo"
L.alignTime = "Allinea il Tempo"
L.time = "Tempo Rimasto"
L.timeDesc = "Visualizza o nasconde il tempo rimasto sulle barre."
L.textDesc = "Mostra o nascondi il testo delle barre."
L.icon = "Icona"
L.iconDesc = "Visualizza o nasconde le icone delle Barre."
L.iconPosition = "Posizione Icona"
L.iconPositionDesc = "Scegli dove l'icona deve essere posizionata sulla barra."
L.iconTooltip = "Tooltip Icona"
L.iconTooltipDesc = "Mostra un tooltip con le informazioni sull'abilità del boss quando passi il mouse sopra l'icona."
L.font = "Carattere"
L.restart = "Riavvia"
L.restartDesc = "Riavvia le barre Enfatizzate in modo che partano dall'inizio e contino fino a 10."
L.fill = "Riempi"
L.fillDesc = "Riempi le barre invece di svuotarle man mano che passano i secondi."
L.spacing = "Spaziatura"
L.spacingDesc = "Cambia la distanza tra le barre."
L.visibleBarLimit = "Limite barre visibili"
L.visibleBarLimitDesc = "Scegli il numero massimo di barre che devono essere visibili contemporaneamente."

L.localTimer = "Locale"
L.timerFinished = "%s: Timer [%s] Terminato."
L.customBarStarted = "Barra personalizzata '%s' creata da utente %s - %s."
L.sendCustomBar = "Invio barra personalizzata '%s' agli utenti di BigWigs e DBM."

L.requiresLeadOrAssist = "Questa funzione richiede Capo Incursione o Assistente Incursione."
L.encounterRestricted = "Questa funzione non può essere usata durante uno scontro con un boss."
L.wrongCustomBarFormat = "Formato non corretto. Un'esempio corretto è: /raidbar 20 testo"
L.wrongTime = "Specificato tempo non valido. <time> può essere sia un numero in secondi, una coppia M:S , o Mm. Per esempio 5, 1:20 or 2m."

L.wrongBreakFormat = "Deve essere tra 1 e 60 minuti. Un'esempio corretto è /break 5"
L.sendBreak = "Invia un timer di pausa a tutti gli utenti BigWigs e DBM."
L.breakStarted = "Pausa annunciata da %s utente %s."
L.breakStopped = "Tempo di pausa cancellato da %s."
L.breakBar = "Tempo di pausa"
L.breakMinutes = "La Pausa finisce tra %d |4minuto:minuti!"
L.breakSeconds = "La Pausa finisce tra %d |4secondo:secondi!"
L.breakFinished = "Il tempo di pausa è finito"

L.indicatorTitle = "Indicatori Incantesimi"
L.indicatorType_Deadly = "Letale"
L.indicatorType_Bleed = "Sanguinamento"
L.indicatorType_Magic = "Magia"
L.indicatorType_Dispels = "Dissolvenze"
L.indicatorType_Tank = "Difensore"
L.indicatorType_Healer = "Guaritore"
L.indicatorType_Damager = "Assaltatore"

L.spellIndicatorsPosition = "Posizione Indicatori Incantesimi"
L.spellIndicatorsPositionDesc = "Scegli dove gli indicatori degli incantesimi devono essere posizionati sulla barra."
L.spellIndicatorsOffset = "Scostamento Indicatori Incantesimi"
L.spellIndicatorSize = "Dimensione Indicatori Incantesimi"
L.spellIndicatorSizeDropdown_Large1 = "Grande (1 indicatore)"
L.spellIndicatorSizeDropdown_Large2 = "Grande (2 indicatori)"
L.spellIndicatorSizeDropdown_Large3 = "Grande (3 indicatori)"
L.spellIndicatorSizeDropdown_Small4 = "Piccolo (4 indicatori)"
L.spellIndicatorSizeDropdown_Small2 = "Piccolo (2 indicatori)"

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.bossBlock = "Blocco Boss"
L.bossBlockDesc = "Configura le varie opzioni che puoi bloccare durante gli scontri con i boss.\n\n"
L.bossBlockAudioDesc = "Configura quali audio silenziare durante uno scontro.\n\nQualsiasi opzione che è |cff808080colorata in grigio|r è stata disabilitata nel pannello opzioni suono di WoW.\n\n"
L.movieBlocked = "Hai già visto questo video, lo salto."
L.blockEmotes = "Blocca gli emote a metà schermo"
L.blockEmotesDesc = "Alcuni boss mostrano delle emote per determinate abilità; questi messaggi sono sia troppo lunghi che troppo descrittivi. Cerchiamo di produrre messaggi più compatti e puliti che non interferiscono con lo svolgimento del gioco, e non dicono specificatamente cosa fare.\n\nNota bene: gli emote dei Boss sono sempre visibili nella chat se vuoi leggerli."
L.blockMovies = "Blocca filmati già visti"
L.blockMoviesDesc = "I filmati dei boss (ove presenti) verranno fatti vedere solo la prima volta che si attivano per visualizzarli; dalle volte successive questi video verranno cancellati automaticamente."
L.blockFollowerMission = "Blocca i popup della Guarnigione" -- Rename to follower mission
L.blockFollowerMissionDesc = "I popup della Guarnigione appaiono per certe attività, ma principalmente quando un seguace completa una missione.\n\nQuesti popup possono coprire parti critiche o importanti della tua UI durante il combattimento contro un boss, raccomandiamo quindi di bloccarli."
L.blockGuildChallenge = "Blocca i popup delle sfide di Gilda"
L.blockGuildChallengeDesc = "I popup delle Sfide di Gilda vengono mostrati per vari avvisi, principalmente quando la tua gilda completa una spedizione eroica o una spedizione in modalità sfida.\n\nQuesti popup possono coprire parti critiche o importanti della tua UI durante il combattimento contro un boss, raccomandiamo quindi di bloccarli."
L.blockSpellErrors = "Blocca i messaggi di errore degli incantesimi"
L.blockSpellErrorsDesc = "Messaggi tipo \"Questo incantesimo non è ancora pronto\" che in genere vengono mostrati in alto nello schermo verranno bloccati."
L.blockZoneChanges = "Messaggi di cambio blocco zona"
L.blockZoneChangesDesc = "I messaggi mostrati al centro in alto dello schermo quando ti muovi in una nuova zona come '|cFF33FF99Roccavento|r' o '|cFF33FF99Orgrimmar|r' saranno bloccati."
L.audio = "Audio"
L.music = "Musica"
L.ambience = "Audio ambientale"
L.sfx = "Effetti audio"
L.errorSpeech = "Messaggi d'errore"
L.disableMusic = "Togli la musica (raccomandato)"
L.disableAmbience = "Togli i suoni ambientali (raccomandato)"
L.disableSfx = "Togli gli effetti sonori (non raccomandato)"
L.disableErrorSpeech = "Togli Messaggi d'Errore (raccomandato)"
L.disableAudioDesc = "L'opzione '%s' nel pannello delle opzioni del suono di WoW's verrà disabilitata, per riabilitarla quando lo scontro con il boss si è concluso. Questo ti aiuta a focalizzarti sui suoni di avviso di BigWigs."
L.blockTooltipQuests = "Blocca tooltip obbiettivi missione"
L.blockTooltipQuestsDesc = "Quando devi uccidere un boss per una missione, vedrai qualcosa come '0/1 completato' nel tooltip quando porti il mouse sopra il boss. Questa opzione lo disabilita durante il combattimento, evitando che il tooltip diventi troppo grande."
L.blockObjectiveTracker = "Nascondi registro missioni"
L.blockObjectiveTrackerDesc = "Il registro delle missioni verrà nascosto durante lo scontro con il boss per liberare spazio sullo schermo.\n\nNON FUNZIONA se ti trovi in una Mitica+ o se stai tracciando un'impresa."

L.blockTalkingHead = "Nascondi popup PNG 'Testa Parlante'"
L.blockTalkingHeadDesc = "La 'Testa Palante' è una finestra popup di dialogo composta dalla testa di un PNG e una finestra di testo nella parte inferiore dello schermo che |cffff4411a volte|r mostra quando un PNG sta parlando.\n\nPuoi scegliere in quale tipo di istanza bloccare la sua comparsa.\n\n|cFF33FF99Nota importante:|r\n 1) Questa funzionalità permetterà sempre al PNG di parlare.\n 2) Solo alcune teste parlanti verranno bloccate. Qualsiasi cosa speciale o unica, come una quest non ripetibile, non verrà bloccata."
L.blockTalkingHeadDungeons = "Spedizioni Normali & Eroiche"
L.blockTalkingHeadMythics = "Spedizioni Mitiche & Mitiche+"
L.blockTalkingHeadRaids = "Incursioni"
L.blockTalkingHeadTimewalking = "Viaggi nel Tempo (Spedizioni & Incursioni)"
L.blockTalkingHeadScenarios = "Scenari"

L.redirectPopups = "Reindirizza i banner popup nelle su bigwigs"
L.redirectPopupsDesc = "I banner popup in mezzo al tuo schermo per esempio '|cFF33FF99slot della Gran Banca sbloccato|r' verrano invece visualizzati come messaggi BigWigs. Questi banner possono essere abbastanza grandi, durare molto, e bloccare la possibilità di cliccarci attraverso."
L.redirectPopupsColor = "Colore dei messaggi reindirizzati"
L.blockDungeonPopups = "Blocca i banner popup dei dungeon"
L.blockDungeonPopupsDesc = "I banner popup mostrati quando entri in un dungeon a volte possono contenere messaggi molto lunghi. Abilitando questa impostazione li bloccherà completamente."
L.itemLevel = "Livello oggetto: %d"
L.newRespawnPoint = "Nuovo Punto di Rinascita"
L.playerLevel = "Livello %d"

L.userNotifySfx = "Gli Effetti sonori sono disabilitati dal Blocco Boss, li riattivo forzatamente."
L.userNotifyMusic = "La Musica è stata disabilitata dal Blocco Boss, la riattivo forzatamente."
L.userNotifyAmbience = "Gli Effetti Ambientali sono disabilitati dal Blocco Boss, li riattivo forzatamente."
L.userNotifyErrorSpeech = "I messaggi di Errore sono disabilitati dal Blocco Boss, li riattivo forzatamente."

L.subzone_grand_bazaar = "Gran Bazar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "Porto di Zandalar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "Transetto Orientale" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "Colori"

L.text = "Testo"
L.textShadow = "Ombra Testo"
L.expiring_normal = "Normale"
L.emphasized = "Enfatizzato"

L.resetColorsDesc = "Reimposta i colori qui sopra ai parametri originali."
L.resetAllColorsDesc = "Se hai modificato qualsiasi parametro dei combattimenti, questo pulsante riporterà TUTTO alle impostazioni originali."

L.red = "Rosso"
L.redDesc = "Avvisi generali di combattimento."
L.blue = "Blu"
L.blueDesc = "Avvisi per effetti diretti, come una magia su di te."
L.orange = "Arancione"
L.yellow = "Giallo"
L.green = "Verde"
L.greenDesc = "Avvisi per effetti benefici, come una magia rimossa da te."
L.cyan = "Azzurro"
L.cyanDesc = "Avvisi per modifiche di stato come un cambio di fase."
L.purple = "Viola"
L.purpleDesc = "Avvisi per abilità specifiche da difensore come un maleficio sul tank."

-----------------------------------------------------------------------
-- Countdown.lua
--

L.textCountdown = "Testo conto alla rovescia"
L.textCountdownDesc = "Mostra un conteggio visuale durante il conto alla rovescia."
L.countdownColor = "Colore conto alla rovescia"
L.countdownVoice = "Voce contro alla rovescia"
L.countdownTest = "Test conto alla rovescia"
L.countdownAt = "Conto alla rovescia in... (secondi)"
L.countdownAt_desc = "Scegli quanto tempo dovrebbe rimanere su un'abilità di un boss (in secondi) quando inizia il conto alla rovescia."
L.countdown = "Conto alla rovescia"
L.countdownDesc = "La funzionalità Conto alla rovescia prevede un conteggio scritto e un messaggio audio. Raramente è abilitata come opzione predefinita, ma puoi abilitarla per qualsiasi abilità del boss nelle opzioni specifiche di quel boss."
L.countdownAudioHeader = "Conto alla Rovescia Audio"
L.countdownTextHeader = "Conto alla Rovescia Visivo"
L.resetCountdownDesc = "Reimposta tutte le impostazioni dei Conti alla Rovescia alle loro opzioni predefinite."
L.resetAllCountdownDesc = "Se hai scelto delle voci personalizzate in qualsiasi impostazione dei boss, questo pulsante le cancellerà TUTTE così come tutte le altre modifiche riportandole ai valori predefiniti."

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infobox_short = "InfoBox"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Indirizza l'uscita dei messaggi sul visualizzatore di Messaggi Normali di BigWigs. Questa visualizzazione supporta icone, colori e può visualizzare fino a 4 messaggi sullo schermo. I messaggi più recenti cresceranno in dimensioni per avvertire l'utente."
L.emphasizedSinkDescription = "Indirizza l'uscita dei messaggi attraverso il visualizzatore di Messaggi ENFATIZZATI di BigWigs. Questo metodo supporta testi, colori e può visualizzare un solo messaggio per volta."
L.resetMessagesDesc = "Reimposta tutte le opzioni relative ai messaggi, compresa la posizione dei messaggi d'ancoraggio."
L.toggleMessagesAnchorsBtnShow_desc = "Mostra tutti i punti di ancoraggio, permettendoti di muovere i messaggi."

L.testMessagesBtn = "Create Messaggio di Prova"
L.testMessagesBtn_desc = "Crea un messaggio per testare le tue impostazioni di visualizzazione attuali."

L.bwEmphasized = "BigWigs Enfatizzato"
L.messages = "Messaggi"
L.emphasizedMessages = "Messaggi Enfatizzati"
L.emphasizedDesc = "Lo scopo dei messaggi enfatizzati è richiamare la tua attenzione con un messaggio a grandezza maggiore rispetto al solito. Raramente è abilitata come opzione predefinita, ma puoi abilitarla per qualsiasi abilità del boss nelle opzioni specifiche di quel boss."
L.uppercase = "TUTTO MAIUSCOLO"
L.uppercaseDesc = "Tutti i messaggi enfatizzati verranno convertiti in MAIUSCOLO."

L.useIcons = "Usa Icone"
L.useIconsDesc = "Mostra le icone accanto ai messaggi."
L.classColors = "Colore delle Classi"
L.classColorsDesc = "I messaggi possono contenere i nomi dei giocatori. Attivando questa opzione verranno colorati con il colore della classe."
L.chatFrameMessages = "Messaggi Riquadro Chat"
L.chatFrameMessagesDesc = "Invia tutti i messaggi di BigWigs alla chat oltre che nei settaggi di visualizzazione."
L.chatFrameChoice = "Scegli il Riquadro Chat"
L.chatFrame = "Riquadro Chat %d: %s" -- "Chat Frame 1: General" or "Chat Frame 2: Combat Log" etc.

L.fontSize = "Dimensione Carattere"
L.none = "Nessuno"
L.thin = "Fine"
L.thick = "Spesso"
L.outline = "Sottolineato"
L.monochrome = "Monocromatico"
L.monochromeDesc = "Abilita il flag monocromatico, rimuovendo ogni effetto di smussatura degli angoli dei caratteri."
L.fontColor = "Colore carattere"
L.slugRendering = "Rendering Slug"
L.slugRenderingDesc = "I caratteri vengono renderizzati tramite la libreria slug. A volte questo li rende più nitidi alle dimensioni grandi, ma può modificare la dimensione del contorno. |cFF33FF99Consulta sluglibrary.com per maggiori informazioni.|r"

L.displayTime = "Tempo di Visualizzazione"
L.displayTimeDesc = "Per quanto tempo deve essere visualizzato il messaggio, in secondi."
L.fadeTime = "Tempo di Scomparsa"
L.fadeTimeDesc = "Dopo quanti secondi il messaggio deve scomparire, in secondi."

L.messagesOptInHeaderOff = "Modalità 'opt-in' dei messaggi del boss mod: attivando questa opzione i messaggi verranno disattivati in TUTTI i tuoi moduli dei boss.\n\nDovrai entrare in ciascuno di essi e attivare manualmente i messaggi che desideri.\n\n"
L.messagesOptInHeaderOn = "La modalità 'opt-in' dei messaggi del boss mod è |cFF33FF99ATTIVA|r. Per vedere i messaggi del boss mod, vai nelle impostazioni di una specifica abilità del boss e attiva l'opzione '|cFF33FF99Messaggi|r'.\n\n"
L.messagesOptInTitle = "Modalità 'opt-in' dei messaggi del boss mod"
L.messagesOptInWarning = "|cffff4411ATTENZIONE!|r\n\nAttivare la modalità 'opt-in' disattiverà i messaggi in TUTTI i tuoi moduli dei boss. Dovrai passare in rassegna ogni modulo e attivare manualmente i messaggi che desideri.\n\nLa tua interfaccia verrà ora ricaricata, sei sicuro?"

-----------------------------------------------------------------------
-- Nameplates.lua
--

L.nameplates = "Barre delle unità"
L.testNameplateIconBtn = "Mostra Icona di Prova"
L.testNameplateIconBtn_desc = "Crea un icona di prova per testare le tue impostazioni di visualizzazione attuali sulla barra dell' unità bersaglio."
L.testNameplateTextBtn = "Mostra Testo di Prova"
L.testNameplateTextBtn_desc = "Crea un testo di prova per visualizzare le tue impostazioni di visualizzazione attuali sulla barra dell'unità bersaglio."
L.stopTestNameplateBtn = "Ferma I test"
L.stopTestNameplateBtn_desc = "Ferma le icone e testi di prova sulle tue barre delle unità."
L.noNameplateTestTarget = "Devi avere un bersaglio ostile che è attaccabile per testare questa funzionalità delle barre delle unità"
L.anchoring = "Ancoraggio"
L.growStartPosition = "Cresci dalla posizione iniziale"
L.growStartPositionDesc = "Posizione di partenza della prima icona."
L.growDirection = "Direzione di Crescità"
L.growDirectionDesc = "La direzione in cui le icone cresceranno dalla posizione iniziale."
L.iconSpacingDesc = "Modifica lo spazio fra ogni icona."
L.nameplateIconSettings = "Impostaizoni Icone"
L.keepAspectRatio = "Mantieni le proporzioni"
L.keepAspectRatioDesc = "Mantieni le proporzioni dell'icona a 1:1 invece di espanderla per riempire l'area del riquardo."
L.iconColor = "Colore Icona"
L.iconColorDesc = "Cambia il colore della grafica dell'icona."
L.desaturate = "Desatura"
L.desaturateDesc = "Desatura la grafica dell'icona."
L.zoom = "Zoom"
L.zoomDesc = "Zoom della grafica dell' icona."
L.showBorder = "Mostra Contorno"
L.showBorderDesc = "Mostra un contorno intorno all'icona."
L.border = "Contorno"
L.borderColor = "Colore del contorno"
L.borderSize = "Dimensione del contorno"
L.borderOffset = "Scostamento del contorno"
L.borderName = "Nome del contorno"
L.borderDispelColor = "Colora il contorno in base al tipo di dissolvenza"
L.showNumbers = "Mostra numeri"
L.showNumbersDesc = "Mostra numeri sull'icona."
L.cooldown = "Recupero"
L.cooldownEmphasizeHeader = "Per impostazione predefinita, Enfatizza è disattivato (0 secondi). Impostalo a 1 secondo o più per attivare Enfatizza. Questo ti permetterà di impostare un colore e una dimensione del carattere diversi per quei numeri."
L.showCooldownSwipe = "Mostra Linea"
L.showCooldownSwipeDesc = "Mostra una linea sull'icona quando il recupero è in corso."
L.showCooldownEdge = "Mostra orlo"
L.showCooldownEdgeDesc = "Mostra un orlo sull'icona quando il recupero è in corso."
L.inverse = "Invertito"
L.inverseSwipeDesc = "Inverti le animazioni di recupero."
L.glow = "Splendore"
L.enableExpireGlow = "Abilità splendore allo scadere"
L.enableExpireGlowDesc = "Mostra uno splendore intorno all' icona quando il recupero è terminato."
L.glowColor = "Colore Splendore"
L.glowType = "Tipo di Splendore"
L.glowTypeDesc = "Cambia il tipo di splendore che viene mostrato intorno all' icona."
L.resetNameplateIconsDesc = "Resetta tutte le opzioni associate con le icone sulle barre delle unità."
L.nameplateTextSettings = "Impostazioni testo"
L.fixate_test = "Fissato Prova" -- Text that displays to test on the frame
L.resetNameplateTextDesc = "Resetta tutte le opzioni associate con il testo dulle barre delle unità."
L.glowAt = "Inizia Spendlore (secondi)"
L.glowAt_desc = "Scegli quanti secondi di recupero rimanenti dovrebbero esserci quando lo splendore inizia a vedersi."
L.offsetX = "Scostamento X"
L.offsetY = "Scostamento Y"
L.headerIconSizeTarget = "Dimensione dell'icona del tuo bersaglio attuale"
L.headerIconSizeOthers = "Dimensione dell'icona di tutti gli altri bersagli"
L.headerIconPositionTarget = "Posizione dell'icona del tuo bersaglio attuale"
L.headerIconPositionOthers = "Posizione dell'icona di tutti gli altri bersagli"

-- Glow types as part of LibCustomGlow
L.pixelGlow = "Spendlore Pixel"
L.autocastGlow = "Splendore cast automatico"
L.buttonGlow = "Splendore bottone"
L.procGlow = "Splendore proc"
L.speed = "Velocità"
L.animation_speed_desc = "La velocità con cui l'animazione dello splendore viene visualizzata."
L.lines = "Linee"
L.lines_glow_desc = "Il numoer di linee nell'animazione dello splendore."
L.intensity = "Intensità"
L.intensity_glow_desc = "L'intensità dell'effeto dello splendore, più alto vuol dire più scintille."
L.length = "Lunghezza"
L.length_glow_desc = "La lunghezza delle linee nell'animazione splendore."
L.thickness = "Spessore"
L.thickness_glow_desc = "Lo spessore delle linee nell'animazione dello splendore."
L.scale = "Scala"
L.scale_glow_desc = "La Scala delle scintille presenti nell'animazione."
L.startAnimation = "Inizia Animazione"
L.startAnimation_glow_desc = "Questo Splendore ha un animazione iniziale, questo abilità/disabilità questa animazione."

L.nameplateOptInHeaderOff = "\n\n\n\nModalità 'opt-in' delle barre delle unità del boss mod: attivare questa opzione disattiverà le barre delle unità in TUTTI i tuoi moduli dei boss.\n\nDovrai passare in rassegna ogni modulo e attivare manualmente le barre delle unità che desideri.\n\n"
L.nameplateOptInHeaderOn = "\n\n\n\nLa modalità 'opt-in' delle barre delle unità del boss mod è |cFF33FF99ATTIVA|r. Per vedere le barre delle unità del boss mod, vai nelle impostazioni di una specifica abilità del boss e attiva l'opzione '|cFF33FF99Barre delle unità|r'.\n\n"
L.nameplateOptInTitle = "Modalità 'opt-in' delle barre delle unità del boss mod"
L.nameplateOptInWarning = "|cffff4411ATTENZIONE!|r\n\nAttivare la modalità 'opt-in' disattiverà le barre delle unità in TUTTI i tuoi moduli dei boss. Dovrai passare in rassegna ogni modulo e attivare manualmente le barre delle unità che desideri.\n\nLa tua interfaccia verrà ora ricaricata, sei sicuro?"

-----------------------------------------------------------------------
-- Proximity.lua
--

L.customRange = "Indicatore di Distanza Personalizzato"
L.proximityTitle = "%d m / %d |4giocatore:giocatori;" -- yd = yards (short)
L.proximity_name = "Prossimità"
L.soundDelay = "Ritardo del Suono"
L.soundDelayDesc = "Specifica per quanto tempo BigWigs dovrebbe aspettare per ripetere il suono quando qualcuno è vicino a te."

L.resetProximityDesc = "Reimposta tutte le opzione relative alla prossimità, compreso il posizionamento dell'ancora di prossimità."

L.close = "Chiudi"
L.closeProximityDesc = "Chiude il Monitor di Prossimità.\n\nPer disabilitarlo completamente per tutti gli incontri, devi andare nelle impostazioni dei singoli combattimenti e disabilitare l'opzione 'Prossimità."
L.lock = "Blocca"
L.lockDesc = "Blocca il Monitor, impedendo che venga spostato e ridimensionato."
L.title = "Titolo"
L.titleDesc = "Visualizza o nasconde il titolo."
L.background = "Sfondo"
L.backgroundDesc = "Visualizza o nasconde il titolo."
L.toggleSound = "Abilita Suono"
L.toggleSoundDesc = "Abilita quando il monitor di prossimità deve emettere un suono se sei troppo vicino ad altri giocatori."
L.soundButton = "Pulsante del Suono"
L.soundButtonDesc = "Visualizza o nasconde il pulsante del Suono."
L.closeButton = "Pulsante di Chiusura"
L.closeButtonDesc = "Visualizza o nasconde il pulsante di Chiusura."
L.showHide = "Visulizza/Nascondi"
L.abilityName = "Nome dell'Abilità"
L.abilityNameDesc = "Visualizza o nasconde il nome dell'abilità sopra la finestra."
L.tooltip = "ToolTip"
L.tooltipDesc = "Visualizza o nasconde il tooltip dell'abilità nel display di prossimità ed è strettamente legato all'abilità del boss."

-----------------------------------------------------------------------
-- Pull.lua
--

L.countdownType = "Tipo di conto alla rovescia"
L.combatLog = "Registro di combattimento automatico"
L.combatLogDesc = "Inizia a registrare il combattimento automaticamente quando parte un pull timer e lo interrompe quando termina lo scontro."

L.pull = "Ingaggio"
L.engageSoundTitle = "Riproduci un suono quando inizia il combattimento con un boss"
L.pullStartedSoundTitle = "Riproduci un suono quando comincia il timer di ingaggio"
L.pullStartedMessageTitle = "Mostra un messaggio quando comincia il timer di ingaggio"
L.pullFinishedSoundTitle = "Riproduci un suono quando termina il timer di ingaggio"
L.pullStartedBy = "Time di ingaggio iniziato da %s."
L.pullStopped = "Timer ingaggio cancellato da %s."
L.pullStoppedCombat = "Timer ingaggio cancellato perchè è iniziato il combattimento."
L.pullIn = "Ingaggio tra %d sec"
L.sendPull = "Manda un timer di ingaggio al tuo gruppo."
L.wrongPullFormat = "Formato di timer di ingaggio non valido. Un formato corretto è: /pull 5"
L.countdownBegins = "Inizia Conto alla Rovescia"
L.countdownBegins_desc = "Scegli quanto tempo dovrebbe rimanere al timer di Ingaggio (in secondi) quando inizia il conto alla rovescia."
L.pullExplainer = "\n|cFF33FF99/pull|r avvierà un normale timer di ingaggio.\n|cFF33FF99/pull 7|r avvierà un timer di ingaggio di 7 secondi, puoi usare qualsiasi numero.\nIn alternativa, puoi anche impostare una scorciatoia da tastiera qui sotto.\n\n"
L.pullKeybindingDesc = "Scegli una scorciatoia da tastiera per avviare un timer di ingaggio."

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L.icons = "Icone"
L.raidIconsDescription = "Alcuni combattimenti possono includere elementi come bombe su giocatori specifici, un giocatore inseguito da qualcosa, o un giocatore che può essere fondamentale seguire. Qui puoi personalizzare quali Simboli devono essere applicati sui giocatori\n\nSe uno scontro ha una sola abilità che deve essere marchiata, verrà usata solo la prima icona. Un'icona non verrà mai usata due volte per due abilità differenti nello stesso scontro, e tutte queste abilità useranno la stessa icona negli scontri successivi.\n\n|cffff4411Da segnalare che se un giocatore è stato marchiato manualmente, BigWigs non cambierà mai quell'icona.|r"
L.primary = "Primario"
L.primaryDesc = "Il primo Simbolo che l'automazione del combattimento dovrebbe usare."
L.secondary = "Secondario"
L.secondaryDesc = "Il secondo Simbolo che l'automazione del combattimento dovrebbe usare."

-----------------------------------------------------------------------
-- Sound.lua
--

L.Sounds = "Suoni"
L.soundsDesc = "BigWigs usa il canale audio 'Master' per riprodurre tutti i suoni. Se il suono risulta troppo debole o alto, apri le impostazioni audio di WoW e aggiusta il 'Volume principale' ad un livello soddisfacente per te.\n\nSotto puoi configurare globalmente i vari suoni riprodotti per specifiche azioni, o impostare 'Nessuno' per disabilitarli. Se vuoi solo cambiare un suono per un'abilità specifica di un boss, puoi farlo dal pannello opzioni per quel boss.\n\n"
L.oldSounds = "Vecchi Suoni"

L.Alarm = "Allarme"
L.Info = "Informazioni"
L.Alert = "Avvertimento"
L.Long = "Lungo"
L.Warning = "Avviso"
L.onyou = "Un'Incantesimo, un potenziamento o un depotenziamento su di te"
L.underyou = "Devi muoverti fuori dall'incantesimo sotto di te"
L.privateaura = "Quando una 'Aura Privata' è su di te"

L.customSoundDesc = "Riproduci il suono personalizzato scelto invece che quelli proposti dal modulo."
L.resetSoundDesc = "Reimposta i suoni precedenti ai loro valori predefiniti."
L.resetAllCustomSound = "Se hai personalizzzato i suoni per qualsiasi boss, questo pulsante reimposterà TUTTI i suoni predefiniti e quindi verranno usati i suoni definiti qui."
L.soundResetPrint = "Il modulo '|cFF436EEE%s|r' usa un suono personalizzato chiamato '|cFF436EEE%s|r' che non esiste più. Reimposto al valore predefinito."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossStatistics = "Statistiche del Boss"
L.bossStatsDescription = "Registrazione di varie statistiche relative ai boss, come il numero di volte in cui sei stato vittorioso, il numero di volte in cui sei stato sconfitto, la data della prima vittoria e la vittoria più veloce. Queste statistiche possono essere consultate nella schermata di configurazione di ogni boss, ma saranno nascoste per i boss di cui non è stata registrata alcuna statistica."
L.createTimeBar = "Mostra la barra 'Miglior Tempo'"
L.bestTimeBar = "Migliore"
L.healthPrint = "Salute: %s."
L.healthFormat = "%s (%.1f%%)"
L.chatMessages = "Messaggi Riquadro Chat"
L.newFastestVictoryOption = "Nuova vittoria più veloce"
L.victoryOption = "Sei stato vittorioso"
L.defeatOption = "Sei stato Sconfitto"
L.bossHealthOption = "Salute Boss"
L.bossVictoryPrint = "Sei stato vittorioso contro '%s' dopo %s." -- You were victorious against 'BOSS_NAME' after COMBAT_DURATION.
L.bossDefeatPrint = "Sei stato sconfitto da '%s' dopo %s." -- You were defeated by 'BOSS_NAME' after COMBAT_DURATION.
L.newFastestVictoryPrint = "Nuova vittoria più veloce: (-%s)" -- New fastest victory: (-COMBAT_DURATION)

-----------------------------------------------------------------------
-- Timeline.lua
--

L.timeline = "Linea temporale"
L.blizzTimelineSettings = "Impostazioni della linea temporale di Blizzard"
L.blizzTimelineSettingsNote = "|cffff4411Queste opzioni controllano solo le impostazioni di Blizzard e sono qui per comodità.|r"
L.enableBlizzTimeline = "Attiva la linea temporale di Blizz"
L.enableBlizzTimelineDesc = "Mostrerà tutti i timer dei combattimenti con i boss sulla linea temporale di Blizzard."
L.show_bars = "Mostra le barre da"
L.bigwigsEnhancedTimers = "Timer avanzati di BigWigs mostrati come barre di BigWigs |cFF33FF99(raccomandato)|r"
L.blizzBasicAsBars = "Timer base di Blizzard mostrati come barre di BigWigs"
L.blizzBasicAsBlizzTimeline = "Timer base di Blizzard mostrati sulla linea temporale di Blizzard"
L.developerMode = "Modalità Sviluppatore"
L.enhancedModeWarning = "ATTENZIONE!\n\nDisattivare la modalità avanzata disabiliterà molte funzioni di BigWigs, tra cui:\n\nColori barre, rinomina degli incantesimi, contatori, suoni/voci personalizzati, conti alla rovescia, attivazione/disattivazione delle barre, messaggi extra, ecc."
L.blizzTimelineEnhancedWarning = "ATTENZIONE!\n\nLa linea temporale di Blizzard non supporta le funzioni avanzate di BigWigs. NON vedrai gli incantesimi rinominati e i timer saranno imprecisi.\n\nSei sicuro di volerla attivare?"

-----------------------------------------------------------------------
-- Victory.lua
--

L.Victory = "Vittoria"
L.victoryHeader = "Configura le azioni da eseguire quando sconfiggi un boss."
L.victorySound = "Riproduci un suono quando hai vinto"
L.victoryMessages = "Mostra i messaggi alla sconfitta di un boss"
L.victoryMessageBigWigs = "Mostra il messaggio BigWigs"
L.victoryMessageBigWigsDesc = "Il messaggio BigWigs è un semplice \"Il boss è stato sconfitto\"."
L.victoryMessageBlizzard = "Mostra il messaggio Blizzard"
L.victoryMessageBlizzardDesc = "Il messaggio Blizzard è un'animazione molto grande \"Il boss è stato sconfitto\" al centro dello schermo."
L.defeated = "%s è stato sconfitto!"

-----------------------------------------------------------------------
-- Wipe.lua
--

L.wipe = "Fallimento"
L.wipeSoundTitle = "Riproduci un suono dopo un tentativo fallito"
L.respawn = "Rinascita"
L.showRespawnBar = "Mostra barra di rinascita"
L.showRespawnBarDesc = "Mostra una barra dopo un fallimento dal boss che mostra il tempo rimanente prima che il boss ricompaia."
