local _, addonTbl = ...
local L = addonTbl.API:NewLocale("BigWigs", "itIT")
if not L then return end

-- API.lua
--L.showAddonBar = "The addon '%s' created the '%s' bar."

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
--L.energy_desc = "Enable functions for displaying information about the various energy levels during the boss encounter."

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
--L.outOfDateAddOnRaidWarning = "L'addon |cFF436EEE%s|r non è aggiornato! You have v%d.%d.%d but the latest is v%d.%d.%d!"
L.disabledAddOn = "L'addon |cFF436EEE%s|r è disattivato, i timer non saranno mostrati."
L.removeAddOn = "Per favore rimuovi '|cFF436EEE%s|r' perché è stato rimpiazzato da '|cFF436EEE%s|r'."
L.alternativeName = "%s (|cFF436EEE%s|r)"
L.outOfDateContentPopup = "WARNING!\nHai aggiornato |cFF436EEE%s|r ma devi anche aggiornare l'addon principale|cFF436EEEBigWigs|r.\nIgnorando questo poterà a funzionalità anomala e non funzionante."
L.outOfDateContentRaidWarning = "|cFF436EEE%s|r richiede la versione %d dell' addon principale |cFF436EEEBigWigs|r per funzionare correttamente, tu hai la versione %d installata attualmente."
--L.addOnLoadFailedWithReason = "BigWigs failed to load the addon |cFF436EEE%s|r with reason %q. Tell the BigWigs devs!"
--L.addOnLoadFailedUnknownError = "BigWigs encountered an error when loading the addon |cFF436EEE%s|r. Tell the BigWigs devs!"

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
L.littleWigsExtras = {
	["LittleWigs_Delves"] = "Scorribande",
	["LittleWigs_CurrentSeason"] = "Stagione attuale",
}

-- Media.lua (These are the names of the sounds in the dropdown list in the "sounds" section)
L.Beware = "Attenti! (Algalon)"
L.FlagTaken = "Bandiera catturata (PvP)"
L.Destruction = "Distruzione (Kil'jaeden)"
L.RunAway = "Scappa ragazzina, scappa!!! (Lupo Cattivo)"
L.spell_on_you = "BigWigs: Abilità su di te"
L.spell_under_you = "BigWigs: Abilità sotto di te"
--L.simple_no_voice = "Simple (No Voice)"

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
L.privateAuraSounds = "Suoni per le Aura Private"
L.privateAuraSounds_desc = "Le Aure Private non possono essere visualizzate normalmente, ma puoi impostare un suono che suonerà quando sei il bersaglio dell'abilità."
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

-- Sharing.lua
L.import = "Importa"
L.import_info = "Dopo che immetti una stringa puoi selezione quali impostazioni vuoi importate. \n Se impostazioni non sono disponibili nella stringa di importazione non saranno selezionabili.\n\n|cffff4411 Quest Importazione impatterà solo le impostazioni generali e non impatta le impostazioni specifiche a ogni boss.|r"
L.import_info_active = "Choose what parts you would like to import and then click the import button."
L.import_info_none = "|cFFFF0000 La stringa di importo non è compatibile o non è aggiornata.|r"
L.export = "Esporta"
L.export_info = "Seleziona quali impostazioni vorresti esportare e condividere con gli altri.\n\n|cffff4411 Puoi solo condividere impostazioni generali e quelle non hanno nessun effetto sulle impostazioni specifiche ai boss.|r"
L.export_string = "Esporta Stringa"
L.export_string_desc = "Copia questa stringa BigWigs se vuoi condividere le tue impostazioni."
L.import_string = "Improta Stringa"
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
--L.imported_mythicplus_settings = "Mythic+ Settings"
--L.mythicplus_settings_import_desc = "Import all Mythic+ settings."
--L.mythicplus_settings_export_desc = "Export all Mythic+ settings."

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
L.timewalk = "Viaggi nel tempo"
--L.solotier8 = "Solo Tier 8"
--L.solotier11 = "Solo Tier 11"
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

-----------------------------------------------------------------------
-- TOOLS
-----------------------------------------------------------------------

--L.tools = "Tools"
--L.toolsDesc = "BigWigs provides various tools or \"quality of life\" features to speed up and simplify the process of fighting bosses. Expand the menu by clicking the |cFF33FF99+|r icon to see them all."

-----------------------------------------------------------------------
-- AutoRole.lua
--

--L.autoRoleTitle = "Auto Role"
--L.autoRoleExplainer = "Whenever you join a group, or you change your talent specialization whilst being in a group, BigWigs will automatically adjust your group role (Tank, Healer, Damager) accordingly.\n\n"

-----------------------------------------------------------------------
-- Keystones.lua
--

--L.keystoneTitle = "BigWigs Keystones"
--L.keystoneHeaderParty = "Party"
--L.keystoneRefreshParty = "Refresh Party"
--L.keystoneHeaderGuild = "Guild"
--L.keystoneRefreshGuild = "Refresh Guild"
--L.keystoneLevelTooltip = "Keystone level: |cFFFFFFFF%s|r"
--L.keystoneMapTooltip = "Dungeon: |cFFFFFFFF%s|r"
--L.keystoneRatingTooltip = "Mythic+ rating: |cFFFFFFFF%d|r"
--L.keystoneHiddenTooltip = "The player has chosen to hide this information."
--L.keystoneTabOnline = "Online"
--L.keystoneTabAlts = "Alts"
--L.keystoneTabTeleports = "Teleports"
--L.keystoneHeaderMyCharacters = "My Characters"
--L.keystoneTeleportNotLearned = "The teleport spell '|cFFFFFFFF%s|r' is |cFFFF4411not learned|r yet."
--L.keystoneTeleportOnCooldown = "The teleport spell '|cFFFFFFFF%s|r' is currently |cFFFF4411on cooldown|r for %d |4hour:hours; and %d |4minute:minutes;."
--L.keystoneTeleportReady = "The teleport spell '|cFFFFFFFF%s|r' is |cFF33FF99ready|r, click to cast it."
--L.keystoneTeleportInCombat = "You cannot teleport here whilst you are in combat."
--L.keystoneTabHistory = "History"
--L.keystoneHeaderThisWeek = "This Week"
--L.keystoneHeaderOlder = "Older"
--L.keystoneScoreTooltip = "Dungeon Score: |cFFFFFFFF%d|r"
--L.keystoneScoreGainedTooltip = "Score Gained: |cFFFFFFFF+%d|r"
--L.keystoneCompletedTooltip = "Completed in time"
--L.keystoneFailedTooltip = "Failed to complete in time"
--L.keystoneExplainer = "A collection of various tools to improve the Mythic+ experience."
--L.keystoneAutoSlot = "Auto slot keystone"
--L.keystoneAutoSlotDesc = "Automatically place your keystone into the slot when opening the keystone holder."
--L.keystoneAutoSlotMessage = "Automatically placed %s into the keystone slot."
--L.keystoneModuleName = "Mythic+"
--L.keystoneStartBar = "%s +%d" -- Format is SHORT_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "ROOK +12"
--L.keystoneStartMessage = "%s +%d begins now!" -- Format is LONG_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "The Rookery +12 begins now!"
--L.keystoneCountdownExplainer = "When you start a Mythic+ dungeon a countdown will play. Choose what voice you'd like to hear and when you want the countdown to start.\n\n"
--L.keystoneCountdownBeginsDesc = "Choose how much time should be remaining on the Mythic+ start timer when the countdown will begin to play."
--L.keystoneCountdownBeginsSound = "Play a sound when the Mythic+ countdown starts"
--L.keystoneCountdownEndsSound = "Play a sound when the Mythic+ countdown ends"
--L.keystoneViewerTitle = "Keystone Viewer"
--L.keystoneHideGuildTitle = "Hide my keystone from my guild members"
--L.keystoneHideGuildDesc = "|cffff4411Not recommended.|r This feature will prevent your guild members seeing what keystone you have. Anyone in your group will still be able to see it."
--L.keystoneHideGuildWarning = "Disabling the ability for your guild members to see your keystone is |cffff4411not recommended|r.\n\nAre you sure you want to do this?"
--L.keystoneAutoShowEndOfRun = "Show when the Mythic+ is over"
--L.keystoneAutoShowEndOfRunDesc = "Automatically show the keystone viewer when when the Mythic+ dungeon is over.\n\n|cFF33FF99This can help you see what new keystones your party has received.|r"
--L.keystoneViewerExplainer = "You can open the keystone viewer using the |cFF33FF99/key|r command or by clicking the button below.\n\n"
--L.keystoneViewerOpen = "Open the keystone viewer"
--L.keystoneViewerKeybindingExplainer = "\n\nYou can also set a keybinding to open the keystone viewer:\n\n"
--L.keystoneViewerKeybindingDesc = "Choose a keybinding to open the keystone viewer."
--L.keystoneClickToWhisper = "Click to open a whisper dialog"
--L.keystoneClickToTeleportNow = "\nClick to teleport here"
--L.keystoneClickToTeleportCooldown = "\nCannot teleport, spell on cooldown"
--L.keystoneClickToTeleportNotLearned = "\nCannot teleport, spell not learned"
--L.keystoneHistoryRuns = "%d Total"
--L.keystoneHistoryRunsThisWeekTooltip = "Total amount of dungeons this week: |cFFFFFFFF%d|r"
--L.keystoneHistoryRunsOlderTooltip = "Total amount of dungeons before this week: |cFFFFFFFF%d|r"
--L.keystoneHistoryScore = "+%d Score"
--L.keystoneHistoryScoreThisWeekTooltip = "Total score gained this week: |cFFFFFFFF+%d|r"
--L.keystoneHistoryScoreOlderTooltip = "Total score gained before this week: |cFFFFFFFF+%d|r"

-- It doesn't really matter what you call it as long as it's recognizable and limited to ~6 characters
--L.keystoneShortName_TheRookery = "ROOK"
--L.keystoneShortName_DarkflameCleft = "DFC"
--L.keystoneShortName_PrioryOfTheSacredFlame = "PRIORY"
--L.keystoneShortName_CinderbrewMeadery = "BREW"
--L.keystoneShortName_OperationFloodgate = "FLOOD"
--L.keystoneShortName_TheaterOfPain = "TOP"
--L.keystoneShortName_TheMotherlode = "ML"
--L.keystoneShortName_OperationMechagonWorkshop = "WORK"
--L.keystoneShortName_EcoDomeAldani = "ALDANI"
--L.keystoneShortName_HallsOfAtonement = "HOA"
--L.keystoneShortName_AraKaraCityOfEchoes = "ARAK"
--L.keystoneShortName_TazaveshSoleahsGambit = "GAMBIT"
--L.keystoneShortName_TazaveshStreetsOfWonder = "STREET"
--L.keystoneShortName_TheDawnbreaker = "DAWN"

-- These short names are for the bar that shows during the Mythic+ countdown
-- Use the real dungeon names but make them shorter to fit on the bar better
--L.keystoneShortName_TheRookery_Bar = "Rookery"
--L.keystoneShortName_DarkflameCleft_Bar = "Darkflame"
--L.keystoneShortName_PrioryOfTheSacredFlame_Bar = "Priory"
--L.keystoneShortName_CinderbrewMeadery_Bar = "Cinderbrew"
--L.keystoneShortName_OperationFloodgate_Bar = "Floodgate"
--L.keystoneShortName_TheaterOfPain_Bar = "Theater"
--L.keystoneShortName_TheMotherlode_Bar = "Motherlode"
--L.keystoneShortName_OperationMechagonWorkshop_Bar = "Workshop"
--L.keystoneShortName_EcoDomeAldani_Bar = "Al'dani"
--L.keystoneShortName_HallsOfAtonement_Bar = "Halls"
--L.keystoneShortName_AraKaraCityOfEchoes_Bar = "Ara-Kara"
--L.keystoneShortName_TazaveshSoleahsGambit_Bar = "Gambit"
--L.keystoneShortName_TazaveshStreetsOfWonder_Bar = "Streets"
--L.keystoneShortName_TheDawnbreaker_Bar = "Dawnbreaker"

-- Instance Keys "Who has a key?"
--L.instanceKeysTitle = "Who has a key?"
--L.instanceKeysDesc = "When you enter a Mythic dungeon, the players that have a keystone for that dungeon will be displayed as a list.\n\n"
--L.instanceKeysTest8 = "|cFF00FF98Monk:|r +8"
--L.instanceKeysTest10 = "|cFFFF7C0ADruid:|r +10"
--L.instanceKeysDisplay = "|c%s%s:|r +%d" -- "PLAYER_NAME: +DUNGEON_LEVEL"
--L.instanceKeysDisplayWithDungeon = "|c%s%s:|r +%d (%s)" -- "PLAYER_NAME: +DUNGEON_LEVEL (DUNGEON_NAME)"
--L.instanceKeysShowAll = "Always show all players"
--L.instanceKeysShowAllDesc = "Enabling this option will show all players in the list, even if their keystone doesn't belong to the dungeon you are in."
--L.instanceKeysOtherDungeonColor = "Other dungeon color"
--L.instanceKeysOtherDungeonColorDesc = "Choose the font color for players that have keystones that don't belong to the dungeon you are in."
--L.instanceKeysEndOfRunDesc = "By default the list will only show when you enter a mythic dungeon. Enabling this option will also show the list when the Mythic+ is over."

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
--L.resetDesc = "Reset the above settings to their default values."
L.resetAll = "Reimposta tutto"

L.positionX = "Posizione X"
L.positionY = "Posizione Y"
L.positionExact = "Posizionamento Esatto"
L.positionDesc = "Scrivi nel riquadro o sposta l'indicatore se devi posizionare esattamente la barra dell'ancoraggio."
L.width = "Larghezza"
L.height = "Altezza"
--L.size = "Size"
L.sizeDesc = "In genere regoli la dimesione trascinando l'ancora. Se hai necessità di una dimensione specifica puoi usare la barra slide o digitare i valori nella casella."
L.fontSizeDesc = "Regola la dimensione del carattere usando la barra slide o digitando i valori nella casella che ha un valore molto maggiore di 200."
L.disabled = "Disabilitato"
L.disableDesc = "Stai per disabilitare la funzionalità '%s' che |cffff4411non è consigliata|r.\n\nSei sicuro di questo?"
--L.keybinding = "Keybinding"
--L.dragToResize = "Drag to resize"

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
L.customAnchorPoint = "Avanzato: Punto di ancoraggio personalizzato"
L.sourcePoint = "Punto di origine"
L.destinationPoint = "Punto di Destinazione"
--L.drawStrata = "Draw Strata"
--L.medium = "MEDIUM"
--L.low = "LOW"

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
--L.newRespawnPoint = "New Respawn Point"

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

L.fontSize = "Dimensione Carattere"
L.none = "Nessuno"
L.thin = "Fine"
L.thick = "Spesso"
L.outline = "Sottolineato"
L.monochrome = "Monocromatico"
L.monochromeDesc = "Abilita il flag monocromatico, rimuovendo ogni effetto di smussatura degli angoli dei caratteri."
L.fontColor = "Colore carattere"

L.displayTime = "Tempo di Visualizzazione"
L.displayTimeDesc = "Per quanto tempo deve essere visualizzato il messaggio, in secondi."
L.fadeTime = "Tempo di Scomparsa"
L.fadeTimeDesc = "Dopo quanti secondi il messaggio deve scomparire, in secondi."

--L.messagesOptInHeaderOff = "Boss mod messages 'opt-in' mode: Enabling this option will turn off messages across ALL of your boss modules.\n\nYou will need to go through each one and manually turn on the messages you want.\n\n"
--L.messagesOptInHeaderOn = "Boss mod messages 'opt-in' mode is |cFF33FF99ACTIVE|r. To see boss mod messages, go into the settings of a specific boss ability and turn on the '|cFF33FF99Messages|r' option.\n\n"
--L.messagesOptInTitle = "Boss mod messages 'opt-in' mode"
--L.messagesOptInWarning = "|cffff4411WARNING!|r\n\nEnabling 'opt-in' mode will turn off messages across ALL of your boss modules. You will need to go through each one and manually turn on the messages you want.\n\nYour UI will now reload, are you sure?"

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
L.borderColor = "Colore del contorno"
L.borderSize = "Dimensione del contorno"
--L.borderOffset = "Border Offset"
--L.borderName = "Border Name"
L.showNumbers = "Mostra numeri"
L.showNumbersDesc = "Mostra numeri sull'icona."
L.cooldown = "Recupero"
--L.cooldownEmphasizeHeader = "By default, Emphasize is disabled (0 seconds). Setting it to 1 second or higher will enable Emphasize. This will allow you to set a different font color and font size for those numbers."
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
--L.offsetX = "Offset X"
--L.offsetY = "Offset Y"
--L.headerIconSizeTarget = "Icon size of your current target"
--L.headerIconSizeOthers = "Icon size of all other targets"
--L.headerIconPositionTarget = "Icon position of your current target"
--L.headerIconPositionOthers = "Icon position of all other targets"

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

--L.nameplateOptInHeaderOff = "\n\n\n\nBoss mod nameplates 'opt-in' mode: Enabling this option will turn off nameplates across ALL of your boss modules.\n\nYou will need to go through each one and manually turn on the nameplates you want.\n\n"
--L.nameplateOptInHeaderOn = "\n\n\n\nBoss mod nameplates 'opt-in' mode is |cFF33FF99ACTIVE|r. To see boss mod nameplates, go into the settings of a specific boss ability and turn on the '|cFF33FF99Nameplates|r' option.\n\n"
--L.nameplateOptInTitle = "Boss mod nameplates 'opt-in' mode"
--L.nameplateOptInWarning = "|cffff4411WARNING!|r\n\nEnabling 'opt-in' mode will turn off nameplates across ALL of your boss modules. You will need to go through each one and manually turn on the nameplates you want.\n\nYour UI will now reload, are you sure?"

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
L.pullFinishedSoundTitle = "Riproduci un suono quando termina il timer di ingaggio"
L.pullStartedBy = "Time di ingaggio iniziato da %s."
L.pullStopped = "Timer ingaggio cancellato da %s."
L.pullStoppedCombat = "Timer ingaggio cancellato perchè è iniziato il combattimento."
L.pullIn = "Ingaggio tra %d sec"
L.sendPull = "Manda un timer di ingaggio al tuo gruppo."
L.wrongPullFormat = "Formato di timer di ingaggio non valido. Un formato corretto è: /pull 5"
L.countdownBegins = "Inizia Conto alla Rovescia"
L.countdownBegins_desc = "Scegli quanto tempo dovrebbe rimanere al timer di Ingaggio (in secondi) quando inizia il conto alla rovescia."
--L.pullExplainer = "\n|cFF33FF99/pull|r will start a normal pull timer.\n|cFF33FF99/pull 7|r will start a 7 second pull timer, you can use any number.\nAlternatively, you can also set a keybinding below.\n\n"
--L.pullKeybindingDesc = "Choose a keybinding for starting a pull timer."

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

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossStatistics = "Statistiche del Boss"
--L.bossStatsDescription = "Recording of various boss-related statistics such as the amount of times you were victorious, the amount of times you were defeated, date of first victory, and the fastest victory. Queste statistiche possono essere viste nella finestra di configurazione di ogni singolo boss, ma saranno nascoste per quei boss di cui non c'é nessuna informazione statistica."
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
