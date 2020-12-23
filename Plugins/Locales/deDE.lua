local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "deDE")
if not L then return end

L.comma = ", "
L.width = "Breite"
L.height = "Höhe"
L.sizeDesc = "Normal wird die Größe festgelegt, indem du den Anker bewegst. Falls du eine exakte Größe benötigst, bewege diesen Schieber oder trage den Wert in das Feld ein, diese Zahl kann beliebig groß sein."

L.abilityName = "Fähigkeitsname"
L.abilityNameDesc = "Zeigt oder versteckt den Fähigkeitsnamen über dem Fenster."
L.Alarm = "Alarm"
L.Alert = "Warnung"
L.align = "Ausrichtung"
L.alignText = "Textausrichtung"
L.alignTime = "Zeitausrichtung"
L.altPowerTitle = "Alternative Energien"
L.background = "Hintergrund"
L.backgroundDesc = "Zeigt oder versteckt den Hintergrund der Anzeige."
L.bars = "Leisten"
L.nameplateBars = "Leisten an Namensplaketten"
L.nameplateAutoWidth = "Breite der Namensplaketten verwenden"
L.nameplateAutoWidthDesc = "Legt die Breite der Leisten auf die Breite der zugehörigen Namensplaketten fest."
L.nameplateOffsetY = "Y Versatz"
L.nameplateOffsetYDesc = "Versatz von der Oberkante der Namensplakette bei darüber angezeigten Leisten und von der Unterkante der Namensplakette bei darunter angezeigten Leisten."
L.bestTimeBar = "Bestzeit"
L.bigWigsBarStyleName_Default = "Standard"
L.blockEmotes = "Hinweise in der Bildschirmmitte blockieren"
L.blockEmotesDesc = [=[Einige Bosse zeigen sehr lange und ungenaue Hinweise für spezielle Fähigkeiten an. BigWigs versucht kürzere und passendere Mitteilungen zu erstellen, die den Spielfluss weniger beeinflussen.

Hinweis: Bossmitteilungen werden weiterhin im Chat sichtbar sein und können dort gelesen werden.]=]
L.blockGuildChallenge = "Popups von Gildenherausforderungen blockieren"
L.blockGuildChallengeDesc = [=[Popups von Gildenherausforderungen zeigen hauptsächlich den Abschluss eines heroischen Dungeons oder des Herausforderungsmodus an.

Da diese Popups während des Bosskampfes ablenken und das Interface überdecken können, sollten sie blockiert werden.]=]
L.blockMovies = "Wiederholte Filmsequenzen blockieren"
L.blockMoviesDesc = "Filmsequenzen aus Bossbegegnungen werden einmalig wiedergegeben (sodass jede angeschaut werden kann) und danach blockiert."
L.blockSpellErrors = "Hinweise zu fehlgeschlagenen Zaubern blockieren"
L.blockSpellErrorsDesc = "Nachrichten wie \"Fähigkeit noch nicht bereit\", welche normalerweise oben auf dem Bildschirm auftauchen, werden blockiert."
L.bossBlock = "Boss Block"
L.bossBlockDesc = "Legt fest, was während einer Bossbegegnung blockiert wird."
L.bossDefeatDurationPrint = "'%s' wurde nach %s besiegt."
L.bossStatistics = "Boss-Statistiken"
L.bossStatsDescription = "Zeichnet verschiedene Statistiken der Bossbegegnungen wie die Anzahl der Siege und Niederlagen, sowie die Kampfdauer oder die Rekordzeiten auf. Diese Statistiken können, falls vorhanden, in der Konfiguration der einzelnen Bosse eingesehen werden. Andernfalls werden diese ausgeblendet."
L.bossWipeDurationPrint = "An '%s' nach %s gescheitert."
L.breakBar = "Pause"
L.breakFinished = "Die Pause ist vorbei!"
L.breakMinutes = "Pause endet in %d |4Minute:Minuten;!"
L.breakSeconds = "Pause endet in %d |4Sekunde:Sekunden;!"
L.breakStarted = "Pause wurde von %s-Nutzer %s gestartet."
L.breakStopped = "Pause wurde von %s abgebrochen."
L.bwEmphasized = "BigWigs Hervorgehoben"
L.center = "Mittig"
L.chatMessages = "Chatnachrichten"
L.classColors = "Klassenfarben"
L.classColorsDesc = "Färbt Spielernamen nach deren Klasse ein."
L.clickableBars = "Interaktive Leisten"
L.clickableBarsDesc = [=[BigWigs-Leisten sind standardmäßig nicht anklickbar. Dies ermöglicht es, das Ziel zu wechseln, AoE-Zauber zu setzen und die Kameraperspektive zu ändern, während sich die Maus über den Leisten befindet. |cffff4411Die Aktivierung der Interaktiven Leisten verhindert dieses Verhalten.|r Die Leisten werden jeden Mausklick abfangen, oben beschriebene Aktionen können dann nur noch außerhalb der Leistenanzeige ausgeführt werden.
]=]
L.close = "Schließen"
L.closeButton = "Schließen-Button"
L.closeButtonDesc = "Zeigt oder versteckt den Schließen-Button."
L.closeProximityDesc = [=[Schließt die Anzeige naher Spieler.

Falls du die Anzeige für alle Bosse deaktivieren willst, musst du die Option 'Nähe' seperat in den jeweiligen Bossmodulen ausschalten.]=]
L.colors = "Farben"
L.combatLog = "Automatische Kampfaufzeichnung"
L.combatLogDesc = "Startet automatisch die Aufzeichnung des Kampfes, wenn ein Pull-Timer gestartet wurde und beendet die Aufzeichnung, wenn der Bosskampf endet."
L.countDefeats = "Siege zählen"
L.countdownAt = "Countdown ab... (Sekunden)"
L.countdownColor = "Countdown-Farbe"
L.countdownTest = "Countdown testen"
L.countdownType = "Countdowntyp"
L.countdownVoice = "Countdown-Stimme"
L.countWipes = "Niederlagen zählen"
L.createTimeBar = "Bestzeittimer anzeigen"
L.customBarStarted = "Custombar '%s' wurde von gestartet von %s Nutzer %s."
L.customRange = "Eigene Reichweitenanzeige"
L.customSoundDesc = "Den speziell gewählten Sound anstatt des vom Modul bereitgestellten abspielen."
L.defeated = "%s wurde besiegt!"
L.disable = "Deaktivieren"
L.disabled = "Deaktivieren"
L.disabledDisplayDesc = "Deaktiviert die Anzeige für alle Module, die sie benutzen."
L.disableDesc = "Deaktiviert die Option, die diese Leiste erzeugt hat, zukünftig permanent."
L.displayTime = "Anzeigedauer"
L.displayTimeDesc = "Bestimmt, wie lange (in Sekunden) Nachrichten angezeigt werden."
L.emphasize = "Hervorheben"
L.emphasizeAt = "Hervorheben bei... (Sekunden)"
L.emphasized = "Hervorgehoben"
L.emphasizedBars = "Hervorgehobene Leisten"
L.emphasizedCountdownSinkDescription = "Sendet Ausgaben dieses Addons durch BigWigs’ Anzeige für hervorgehobene Countdown-Nachrichten. Diese Anzeige unterstützt Text und Farbe und kann nur eine Nachricht gleichzeitig anzeigen."
L.emphasizedMessages = "Hervorgehobene Nachrichten"
L.emphasizedSinkDescription = "Sendet Ausgaben dieses Addons durch BigWigs’ Anzeige für hervorgehobene Nachrichten. Diese Anzeige unterstützt Text und Farbe und kann nur eine Nachricht gleichzeitig anzeigen."
L.enable = "Aktiviert"
L.enableStats = "Statistiken aktivieren"
L.encounterRestricted = "Diese Funktion kann während des Bosskampfes nicht genutzt werden."
L.fadeTime = "Ausblendedauer"
L.fadeTimeDesc = "Bestimmt, wie lange (in Sekunden) das Ausblenden der Nachrichten dauert."
L.fill = "Füllen"
L.fillDesc = "Füllt die Leisten anstatt sie zu entleeren."
L.flash = "Aufleuchten"
L.font = "Schriftart"
L.fontColor = "Schriftfarbe"
L.fontSize = "Schriftgröße"
L.general = "Allgemein"
L.growingUpwards = "Nach oben erweitern"
L.growingUpwardsDesc = "Legt fest, ob die Leisten aufwärts oder abwärts vom Ankerpunkt angezeigt werden."
L.icon = "Symbol"
L.iconDesc = "Zeigt oder versteckt die Symbole auf den Leisten."
L.icons = "Symbole"
L.Info = "Info"
L.interceptMouseDesc = "Aktiviert die Interaktiven Leisten."
L.left = "Links"
L.localTimer = "Lokal"
L.lock = "Fixieren"
L.lockDesc = "Fixiert die Anzeige und verhindert weiteres Verschieben und Anpassen der Größe."
L.Long = "Lang"
L.messages = "Nachrichten"
L.modifier = "Modifikator"
L.modifierDesc = "Wenn die Modifikatortaste gedrückt gehalten wird, können Klickaktionen auf die Leisten ausgeführt werden."
L.modifierKey = "Nur mit Modifikatortaste"
L.modifierKeyDesc = "Erlaubt nicht-interaktive Leisten solange bis die Modifikatortaste gedrückt gehalten wird und dann die unten aufgeführten Mausaktionen verfügbar werden."
L.monochrome = "Monochrom"
L.monochromeDesc = "Schaltet den Monochrom-Filter an/aus, der die Schriftenkantenglättung entfernt."
L.move = "Bewegen"
L.moveDesc = "Bewegt hervorgehobene Leisten zum hervorgehobenen Anker. Ist diese Option nicht aktiv, werden hervorgehobene Leisten lediglich in Größe und Farbe geändert."
L.movieBlocked = "Da Du diese Zwischensequenz bereits gesehen hast, wird sie übersprungen."
L.newBestTime = "Neue Bestzeit!"
L.none = "Nichts"
L.normal = "Normal"
L.normalMessages = "Normale Nachrichten"
L.outline = "Kontur"
L.output = "Ausgabe"
L.positionDesc = "Zur exakten Positionierung vom Ankerpunkt einen Wert in der Box eingeben oder den Schieberegler bewegen."
L.positionExact = "Exakte Positionierung"
L.positionX = "X-Position"
L.positionY = "Y-Position"
L.primary = "Erstes Symbol"
L.primaryDesc = "Das erste Schlachtzugssymbol, das verwendet wird."
L.printBestTimeOption = "Benachrichtigung über Bestzeit"
L.printDefeatOption = "Siegesdauer"
L.printWipeOption = "Niederlagendauer"
L.proximity = "Näheanzeige"
L.proximity_desc = "Zeigt das Fenster für nahe Spieler an. Es listet alle Spieler auf, die dir zu nahe stehen."
L.proximity_name = "Nähe"
L.proximityTitle = "%d m / %d Spieler"
L.pull = "Pull"
L.pullIn = "Pull in %d Sek."
L.engageSoundTitle = "Spiele  einen Sound ab, sobald ein Bosskampf beginnt"
L.pullStartedSoundTitle = "Spiele einen Sound ab, sobald ein Pull-Timer gestartet wurde"
L.pullFinishedSoundTitle = "Spiele einen Sound ab, sobald ein Pull-Timer abgelaufen ist"
L.pullStarted = "Pull-Timer wurde von %s-Nutzer %s gestartet."
L.pullStopped = "Pull-Timer von %s abgebrochen."
L.pullStoppedCombat = "Pull-Timer wurde abgebrochen, weil du einen Kampf begonnen hast."
L.raidIconsDesc = [=[Einige Bossmodule benutzen Schlachtzugssymbole, um Spieler zu markieren, die von speziellem Interesse für deine Gruppe sind. Beispiele wären Bombeneffekte und Gedankenkontrolle. Wenn du diese Option ausschaltest, markierst du niemanden mehr.

|cffff4411Trifft nur zu, sofern du Schlachtzugsleiter oder Assistent bist.|r]=]
L.raidIconsDescription = [=[Einige Begegnungen schließen Elemente wie 'Bombenfähigkeiten' ein, die einen bestimmten Spieler zum Ziel haben, ihn verfolgen oder er ist in sonst einer Art und Weise interessant. Hier kannst du bestimmen, welche Schlachtzugs-Symbole benutzt werden sollen, um die Spieler zu markieren.

Falls nur ein Symbol benötigt wird, wird nur das erste benutzt. Ein Symbol wird niemals für zwei verschiedene Fähigkeiten innerhalb einer Begegnung benutzt.

|cffff4411Beachte, dass ein manuell markierter Spieler von BigWigs nicht ummarkiert wird.|r]=]
L.recordBestTime = "Bestzeiten speichern"
L.regularBars = "Normale Leisten"
L.remove = "Entfernen"
L.removeDesc = "Entfernt zeitweilig die Leiste und alle zugehörigen Nachrichten aus der Anzeige."
L.removeOther = "Andere entfernen"
L.removeOtherDesc = "Entfernt zeitweilig alle anderen Leisten (außer der Angeklickten) und zugehörigen Nachrichten aus der Anzeige."
L.report = "Berichten"
L.reportDesc = "Gibt den aktuellen Leistenstatus im Instanz-, Schlachtzugs-, Gruppen- oder Sagen-Chat aus."
L.requiresLeadOrAssist = "Diese Funktion benötigt Schlachtzugsleiter oder -assistent."
L.reset = "Zurücksetzen"
L.resetAll = "Alle zurücksetzen"
L.resetAllCustomSound = "Wenn Du die Sounds für Bossbegegnungen geändert hast, werden diese ALLE über diese Schaltfläche zurückgesetzt, sodass stattdessen die hier gewählten genutzt werden."
L.resetAllDesc = "Falls du veränderte Farbeinstellungen für Bosse benutzt, wird dieser Button ALLE zurücksetzen, so dass erneut die hier festgelegten Farben verwendet werden."
L.resetDesc = "Setzt die obenstehenden Farben auf ihre Ausgangswerte zurück."
L.respawn = "Erneutes Erscheinen"
L.restart = "Neu starten"
L.restartDesc = "Startet die hervorgehobenen Leisten neu, so dass sie bis 10 hochzählen anstatt von 10 herunter."
L.right = "Rechts"
L.secondary = "Zweites Symbol"
L.secondaryDesc = "Das zweite Schlachtzugssymbol, das verwendet wird."
L.sendBreak = "Sende Pausentimer an BigWigs- und DBM-Nutzer."
L.sendCustomBar = "Sende Custombar '%s' an BigWigs- und DBM-Nutzer."
L.sendPull = "Sende Pull-Timer an BigWigs- und DBM-Nutzer."
L.showHide = "Zeigen/Verstecken"
L.showRespawnBar = "Erneutes-Erscheinen-Leiste anzeigen"
L.showRespawnBarDesc = "Zeigt eine Leiste, nachdem ihr an einem Boss gestorben seid, die die Zeit bis zum erneuten Erscheinen des Bosses anzeigt."
L.sinkDescription = "Sendet die BigWigs-Ausgabe durch die normale BigWigs-Nachrichtenanzeige. Diese Anzeige unterstützt Symbole, Farben und kann 4 Nachrichten gleichzeitig anzeigen. Neuere Nachrichten werden größer und schrumpfen dann wieder schnell, um die Aufmerksamkeit dementsprechend zu lenken."
L.sound = "Sound"
L.soundButton = "Sound-Button"
L.soundButtonDesc = "Zeigt oder versteckt den Sound-Button."
L.soundDelay = "Soundverzögerung"
L.soundDelayDesc = "Gibt an, wie lange BigWigs zwischen den Soundwiederholungen wartet, wenn jemand zu nahe steht."
L.soundDesc = "Nachrichten können zusammen mit Sounds erscheinen. Manche Leute finden es einfacher, darauf zu hören, welcher Sound mit welcher Nachricht einher geht, anstatt die Nachricht zu lesen."
L.Sounds = "Sounds"
L.style = "Stil"
L.superEmphasize = "Stark hervorheben"
L.superEmphasizeDesc = [=[Verstärkt zugehörige Nachrichten oder Leisten einer bestimmten Begegnung.

Hier kannst du genau bestimmen, was passieren soll, wenn du in den erweiterten Optionen einer Bossfähigkeit 'Stark hervorheben' aktivierst.

|cffff4411Beachte, dass 'Stark hervorheben' standardmäßig für alle Fähigkeiten deaktiviert ist.|r
]=]
L.superEmphasizeDisableDesc = "Deaktiviert starkes Hervorheben für alle Module, die es benutzen."
L.tempEmphasize = "Hebt zeitweilig Leisten und zugehörige Nachrichten stark hervor."
L.text = "Text"
L.textCountdown = "Countdown-Text"
L.textCountdownDesc = "Zeige einen sichtbaren Zähler während eines Countdowns."
L.textShadow = "Textschatten"
L.texture = "Textur"
L.thick = "Dick"
L.thin = "Dünn"
L.time = "Zeit"
L.timeDesc = "Bestimmt, ob die verbleibende Zeit auf den Leisten angezeigt wird."
L.timerFinished = "%s: Timer [%s] beendet."
L.title = "Titel"
L.titleDesc = "Zeigt oder versteckt den Titel der Anzeige."
L.toggleDisplayPrint = "Die Anzeige wird das nächste Mal wieder erscheinen. Um sie für diesen Bosskampf komplett zu deaktivieren, musst Du sie in den Bosskampf-Optionen ausschalten."
L.toggleSound = "Sound an/aus"
L.toggleSoundDesc = "Schaltet den Sound ein oder aus, der gespielt wird, wenn du zu nahe an einem anderen Spieler stehst."
L.tooltip = "Tooltip"
L.tooltipDesc = "Zeigt oder versteckt den Zaubertooltip, wenn die Näheanzeige direkt an eine Bossfähigkeit gebunden ist."
L.uppercase = "GROSSBUCHSTABEN"
L.uppercaseDesc = "Schreibt alle Nachrichten in Großbuchstaben, die die zugehörige Option 'Stark hervorheben' aktiviert haben."
L.useColors = "Farben verwenden"
L.useColorsDesc = "Wählt, ob Nachrichten farbig oder weiß angezeigt werden."
L.useIcons = "Symbole verwenden"
L.useIconsDesc = "Zeigt Symbole neben Nachrichten an."
L.Victory = "Sieg"
L.victoryHeader = "Konfiguriert die Aktionen, die nach einem erfolgreichen Bosskampf stattfinden."
L.victoryMessageBigWigs = "Die Mitteilung von BigWigs anzeigen"
L.victoryMessageBigWigsDesc = "Die Mitteilung von BigWigs ist eine einfache Boss-wurde-besiegt-Mitteilung."
L.victoryMessageBlizzard = "Die Blizzard-Mitteilung anzeigen"
L.victoryMessageBlizzardDesc = "Die Blizzard-Mitteilung ist eine sehr große Boss-wurde-besiegt-Animation in der Mitte deines Bildschirms."
L.victoryMessages = "Boss-besiegt-Nachrichten zeigen"
L.victorySound = "Spiele einen Sieg-Sound"
L.Warning = "Warnung"
L.wipe = "Niederlage"
L.wipeSoundTitle = "Spiele bei einer Niederlage einen Sound ab"
L.wrongBreakFormat = "Muss zwischen 1 und 60 Minuten liegen. Beispiel: /break 5"
L.wrongCustomBarFormat = "Ungültiges Format. Beispiel: /raidbar 20 text"
L.wrongPullFormat = "Muss zwischen 1 und 60 Sekunden liegen. Beispiel: /pull 5"
L.wrongTime = "Ungültige Zeitangabe. <time> kann eine Zahl in Sekunden, ein M:S paarung, oder Mm sein. Beispiel: 5, 1:20 or 2m."

-----------------------------------------------------------------------
-- AltPower.lua
--

L.resetAltPowerDesc = "Setzt alle Optionen im Zusammenhang mit Alternative Energie zurück, inklusive der Position des Ankers für Alternative Energie."

-----------------------------------------------------------------------
-- AutoReply.lua
--

L.autoReply = "Automatisch Antworten"
L.autoReplyDesc = "Automatisch auf Flüsternachrichten antworten, wenn ich mich in einem Bosskampf befinde."
L.responseType = "Antwortart"
L.autoReplyFinalReply = "Auch flüstern wenn ich den Kampf verlassen habe"
L.guildAndFriends = "Gilde & Freunde"
L.everyoneElse = "Jeden"

L.autoReplyBasic = "Ich befinde mich in einem Bosskampf."
L.autoReplyNormal = "Ich kämpfe gerade gegen '%s'."
L.autoReplyAdvanced = "Ich kämpfe gerade gegen '%s' (%s) und %d/%d Spieler sind noch am Leben."
L.autoReplyExtreme = "Ich kämpfe gerade gegen '%s' (%s) und %d/%d Spieler sind noch am Leben: %s"

L.autoReplyLeftCombatBasic = "Ich befinde mich nicht mehr im Bosskampf."
L.autoReplyLeftCombatNormalWin = "Ich habe gegen '%s' gewonnen."
L.autoReplyLeftCombatNormalWipe = "Ich habe gegen '%s' verloren."
L.autoReplyLeftCombatAdvancedWin = "Ich habe gegen '%s' gewonnen und %d/%d Spieler sind noch am leben."
L.autoReplyLeftCombatAdvancedWipe = "Ich habe gegen '%s' verloren: %s"

-----------------------------------------------------------------------
-- Bars.lua
--

L.spacing = "Abstand"
L.spacingDesc = "Verändert den Abstand zwischen den Leisten."
L.emphasizeMultiplier = "Größenmultiplikator"
L.emphasizeMultiplierDesc = "Wenn das Bewegen der Leisten zu den hervorgehobenen Leisten deaktiviert ist, entscheidet diese Option welche Größe die hervorgehobenen Leisten multipliziert mit den normalen Leisten haben."
L.iconPosition = "Symbolposition"
L.iconPositionDesc = "Wähle, wo sich das Symbol auf der Leiste befinden soll."
L.visibleBarLimit = "Maximale Leistenanzahl"
L.visibleBarLimitDesc = "Legt die maximale Anzahl der Leisten fest, welche gleichzeitig angezeigt werden."
L.textDesc = "Text in den Leisten anzeigen oder verstecken."
L.resetBarsDesc = "Setzt alle Optionen im Zusammenhang mit Leisten zurück, inklusive der Position der Anker für Leisten."

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.audio = "Audio"
L.music = "Musik"
L.ambience = "Umgebungsgeräusche"
L.sfx = "Soundeffekte"
L.disableMusic = "Musik stummschalten (empfohlen)"
L.disableAmbience = "Umgebungsgeräusche stummschalten (empfohlen)"
L.disableSfx = "Soundeffekte stummschalten (nicht empfohlen)"
L.disableAudioDesc = "Die Option '%s' im WoW Soundmenü wird deaktiviert und erst nach dem Bosskampf wieder aktiviert. Dies kann helfen sich auf die BigWigs Sounds zu konzentrieren."
L.blockTooltipQuests = "Questziele im Tooltip blockieren"
L.blockTooltipQuestsDesc = "Wenn zum Abschluss einer Quest ein Boss getötet werden muss, wird der Fortschritt normalerweise im MouseOver-Tooltip mit '0/1 abgeschlossen' angezeigt. Dieser Fortschritt wird im Kampf versteckt, damit der Tooltip nicht zu groß wird."
L.blockFollowerMission = "Popups der Anhänger blockieren"
L.blockFollowerMissionDesc = "Popups der Anhänger zeigen hauptsächlich abgeschlossene Missionen von Anhängern an.\n\nDa diese Popups während des Bosskampfes ablenken und das Interface überdecken können, sollten sie blockiert werden."
L.blockObjectiveTracker = "Questverfolgung ausblenden"
L.blockObjectiveTrackerDesc = "Die Liste mit verfolgten Quests wird im Bosskampf ausgeblendet um Anzeigeplatz zu sparen.\n\nDies passiert NICHT in Mythic+ oder beim Verfolgen eines Erfolges."

L.subzone_grand_bazaar = "Der Große Basar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "Der Hafen von Zandalar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "Östliches Transept" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.red = "Rot"
L.redDesc = "Allgemeine Bosswarnungen."
L.blue = "Blau"
L.blueDesc = "Warnungen für Dinge welche Dich direkt betreffen wie Zauber auf Dir."
L.orange = "Orange"
L.yellow = "Gelb"
L.green = "Grün"
L.greenDesc = "Warnungen für positive Dinge wie ein von Dir entfernter Zauber."
L.cyan = "Cyan"
L.cyanDesc = "Warnungen für Statusänderungen im Bosskampf wie Phasenwechsel."
L.purple = "Violett"
L.purpleDesc = "Warnungen für tankspezifische Fähigkeiten wie ein stapelnder Tankdebuff."

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infoBox = "InfoBox"

-----------------------------------------------------------------------
-- Messages.lua
--

L.resetMessagesDesc = "Setzt alle Optionen im Zusammenhang mit Nachrichten zurück, inklusive der Position der Anker für Nachrichten."

-----------------------------------------------------------------------
-- Proximity.lua
--

L.resetProximityDesc = "Setzt alle Optionen im Zusammenhang mit Nähe zurück, inklusive der Position des Ankers für Nähe."

-----------------------------------------------------------------------
-- Sound.lua
--

L.resetSoundDesc = "Setzt die obigen Sounds auf ihren Standard zurück."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.printHealthOption = "Bossgesundheit"
L.healthPrint = "Gesundheit: %s."
L.healthFormat = "%s (%.1f%%)"
