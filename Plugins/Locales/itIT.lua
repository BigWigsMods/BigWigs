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
L.disable = "Disabilita"
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
L.font = "Carattere"
L["Restart"] = "Riavvia"
L["Restarts emphasized bars so they start from the beginning and count from 10."] = "Riavvia le barre Enfatizzate in modo che partano dall'inizio e contino fino a 10."
L["Fill"] = "Riempi"
L["Fills the bars up instead of draining them."] = "Riempi le barre invece di svuotarle man mano che passano i secondi."

L["Local"] = "Locale"
L["%s: Timer [%s] finished."] = "%s: Timer [%s] Terminato."
L["Custom bar '%s' started by %s user %s."] = "Barra personalizzata '%s' creata da utente %s - %s."

L["Pull"] = "Ingaggio"
L["Pulling!"] = "Ingaggio!"
L["Pull timer started by %s user %s."] = "Timer Ingaggio iniziato da utente %s - %s."
L["Pull in %d sec"] = "Ingaggio tra %d sec"
L["Sending a pull timer to Big Wigs and DBM users."] = "Invio di un timer di Ingaggio agli utenti di Big Wigs e DBM."
L["Sending custom bar '%s' to Big Wigs and DBM users."] = "Invio barra personalizzata '%s' agli utenti di Big Wigs e DBM."
L["This function requires raid leader or raid assist."] = "Questa funzione richiede Capo Incursione o Assistente Incursione."
L["Must be between 1 and 60. A correct example is: /pull 5"] = "Deve essere tra 1 e 60. Un'esempio corretto è: /pull 5"
L["Incorrect format. A correct example is: /raidbar 20 text"] = "Formato non corretto. Un'esempio corretto è: /raidbar 20 testo"
L["Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Specificato tempo non valido. <time> può essere sia un numero in secondi, una coppia M:S , o Mm. Per esempio 5, 1:20 or 2m."
L["This function can't be used during an encounter."] = "Questa funzione non può essere usata durante uno scontro con un boss."
L["Pull timer cancelled by %s."] = "Barra d'ingaggio cancellata da %s."



-- These localization strings are translated on WoWAce: http://www.wowace.com/addons/big-wigs/localization/
--@localization(locale="itIT", namespace="Plugins", format="lua_additive_table", handle-unlocalized="ignore")@

