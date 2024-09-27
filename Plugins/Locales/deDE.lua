local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "deDE")
if not L then return end

L.general = "Allgemein"
L.advanced = "Erweitert"
L.comma = ", "

L.positionX = "X-Position"
L.positionY = "Y-Position"
L.positionExact = "Exakte Positionierung"
L.positionDesc = "Zur exakten Positionierung vom Ankerpunkt einen Wert in der Box eingeben oder den Schieberegler bewegen."
L.width = "Breite"
L.height = "Höhe"
L.sizeDesc = "Normalerweise wird die Größe festgelegt, indem Du den Anker bewegst. Falls Du eine exakte Größe benötigst, bewege diesen Schieber oder trage den Wert in das Feld ein."
L.fontSizeDesc = "Schriftgröße über den Schieberegler oder durch Eingabe eines Wertes in der Box (maximal 200) festlegen."
L.disabled = "Deaktivieren"
L.disableDesc = "Du bist dabei, das Feature '%s' zu deaktivieren, was |cffff4411nicht empfohlen|r wird.\n\nBist Du sicher, dass Du das tun willst?"

-- Anchor Points
L.UP = "Hoch"
L.DOWN = "Runter"
L.TOP = "Oben"
L.RIGHT = "Rechts"
L.BOTTOM = "Unten"
L.LEFT = "Links"
L.TOPRIGHT = "Oben Rechts"
L.TOPLEFT = "Oben Links"
L.BOTTOMRIGHT = "Unten Rechts"
L.BOTTOMLEFT = "Unten Links"
L.CENTER = "Mitte"
L.customAnchorPoint = "Erweitert: Benutzerdefinierter Ankerpunkt"
L.sourcePoint = "Ursprungspunkt"
L.destinationPoint = "Zielpunkt"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "Alternative Energien"
L.altPowerDesc = "Die Anzeige alternativer Energien wird nur bei Bossen aktiv, welche Spieler mit alternativen Energien belegen, was selten der Fall ist. Die Anzeige informiert in einer Liste über die 'Alternativen Energien', welche Deine Gruppe und Du habt. Nutze den folgenden Testbutton um die Anzeige zu verschieben."
L.toggleDisplayPrint = "Die Anzeige wird das nächste Mal wieder erscheinen. Um sie für diesen Bosskampf komplett zu deaktivieren, musst Du sie in den Bosskampf-Optionen ausschalten."
L.disabledDisplayDesc = "Deaktiviert die Anzeige für alle Module, die sie benutzen."
L.resetAltPowerDesc = "Setzt alle Optionen im Zusammenhang mit Alternative Energie zurück, inklusive der Position des Ankers für Alternative Energie."
L.test = "Test"
L.altPowerTestDesc = "Zeigt die Anzeige der 'Alternative Energien' und ermöglicht das Verschieben. Gleichzeitig wird eine Vorschau der Energieänderung wie in einem Bosskampf gegeben."
L.yourPowerBar = "Deine Energie Leiste"
L.barColor = "Farbe der Leiste"
L.barTextColor = "Textfarbe der Leiste"
L.additionalWidth = "Zusätzliche Breite"
L.additionalHeight = "Zusätzliche Höhe"
L.additionalSizeDesc = "Vergrößert die Standardanzeige über den Schieberegler oder durch Eingabe eines Wertes in der Box (maximal 100)."
L.yourPowerTest = "Deine Energie: %d" -- Your Power: 42
L.yourAltPower = "Dein(e) %s: %d" -- e.g. Your Corruption: 42
L.player = "Spieler %d" -- Player 7
L.disableAltPowerDesc = "Die Anzeige alternativer Energien komplett deaktivieren, sodass sie bei keiner Bossbegegnung angezeigt wird."

-----------------------------------------------------------------------
-- AutoReply.lua
--

L.autoReply = "Automatisch antworten"
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
L.autoReplyLeftCombatAdvancedWin = "Ich habe gegen '%s' gewonnen und %d/%d Spieler waren noch am leben."
L.autoReplyLeftCombatAdvancedWipe = "Ich habe gegen '%s' verloren bei: %s"

-----------------------------------------------------------------------
-- Bars.lua
--

L.bars = "Leisten"
L.style = "Stil"
L.bigWigsBarStyleName_Default = "Standard"
L.resetBarsDesc = "Setzt alle Optionen im Zusammenhang mit Leisten zurück, inklusive der Position der Anker für Leisten."
L.testBarsBtn = "Testleiste erstellen"
L.testBarsBtn_desc = "Erstellt eine Leiste zum Testen der aktuellen Einstellungen an."

L.toggleAnchorsBtnShow = "Anker einblenden"
L.toggleAnchorsBtnHide = "Anker ausblenden"
L.toggleAnchorsBtnHide_desc = "Blendet alle Ankerpunkte aus und fixiert alle Anzeigen."
L.toggleBarsAnchorsBtnShow_desc = "Zeigt alle Bewegungs-Anker zum Bewegen der Leisten."

L.emphasizeAt = "Hervorheben bei... (Sekunden)"
L.growingUpwards = "Nach oben erweitern"
L.growingUpwardsDesc = "Legt fest, ob die Leisten aufwärts oder abwärts vom Ankerpunkt angezeigt werden."
L.texture = "Textur"
L.emphasize = "Hervorheben"
L.emphasizeMultiplier = "Größenmultiplikator"
L.emphasizeMultiplierDesc = "Wenn das Bewegen der Leisten zu den hervorgehobenen Leisten deaktiviert ist, entscheidet diese Option welche Größe die hervorgehobenen Leisten multipliziert mit den normalen Leisten haben."

L.enable = "Aktiviert"
L.move = "Bewegen"
L.moveDesc = "Bewegt hervorgehobene Leisten zum hervorgehobenen Anker. Ist diese Option nicht aktiv, werden hervorgehobene Leisten lediglich in Größe und Farbe geändert."
L.emphasizedBars = "Hervorgehobene Leisten"
L.align = "Ausrichtung"
L.alignText = "Textausrichtung"
L.alignTime = "Zeitausrichtung"
L.left = "Links"
L.center = "Mittig"
L.right = "Rechts"
L.time = "Zeit"
L.timeDesc = "Bestimmt, ob die verbleibende Zeit auf den Leisten angezeigt wird."
L.textDesc = "Text in den Leisten anzeigen oder verstecken."
L.icon = "Symbol"
L.iconDesc = "Zeigt oder versteckt die Symbole auf den Leisten."
L.iconPosition = "Symbolposition"
L.iconPositionDesc = "Wähle, wo sich das Symbol auf der Leiste befinden soll."
L.font = "Schriftart"
L.restart = "Neu starten"
L.restartDesc = "Startet die hervorgehobenen Leisten neu, sodass diese vom Start anfangen und von 10 herunterzählen."
L.fill = "Füllen"
L.fillDesc = "Füllt die Leisten anstatt sie zu entleeren."
L.spacing = "Abstand"
L.spacingDesc = "Verändert den Abstand zwischen den Leisten."
L.visibleBarLimit = "Maximale Leistenanzahl"
L.visibleBarLimitDesc = "Legt die maximale Anzahl der Leisten fest, welche gleichzeitig angezeigt werden."

L.localTimer = "Lokal"
L.timerFinished = "%s: Timer [%s] beendet."
L.customBarStarted = "Custombar '%s' wurde gestartet von %s Nutzer %s."
L.sendCustomBar = "Sende Custombar '%s' an BigWigs- und DBM-Nutzer."

L.requiresLeadOrAssist = "Diese Funktion benötigt Schlachtzugsleiter oder -assistent."
L.encounterRestricted = "Diese Funktion kann während des Bosskampfes nicht genutzt werden."
L.wrongCustomBarFormat = "Ungültiges Format. Beispiel: /raidbar 20 text"
L.wrongTime = "Ungültige Zeitangabe. <Zeit> kann eine Zahl in Sekunden, eine M:S Paarung, oder Mm sein. Beispiel: 5, 1:20 oder 2m."

L.wrongBreakFormat = "Muss zwischen 1 und 60 Minuten liegen. Beispiel: /break 5"
L.sendBreak = "Sende Pausentimer an BigWigs- und DBM-Nutzer."
L.breakStarted = "Pause wurde von %s-Nutzer %s gestartet."
L.breakStopped = "Pause wurde von %s abgebrochen."
L.breakBar = "Pause"
L.breakMinutes = "Pause endet in %d |4Minute:Minuten;!"
L.breakSeconds = "Pause endet in %d |4Sekunde:Sekunden;!"
L.breakFinished = "Die Pause ist vorbei!"

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.bossBlock = "Boss Block"
L.bossBlockDesc = "Legt fest, was während einer Bossbegegnung blockiert wird.\n\n"
L.bossBlockAudioDesc = "Konfiguriert, welche Sounds während Bossbegegnungen stummgeschaltet werden.\n\nJede hier |cff808080ausgegraute|r Option wurde in den WoW Soundeinstellungen deaktiviert.\n\n"
L.movieBlocked = "Da Du diese Zwischensequenz bereits gesehen hast, wird sie übersprungen."
L.blockEmotes = "Hinweise in der Bildschirmmitte blockieren"
L.blockEmotesDesc = "Einige Bosse zeigen sehr lange und ungenaue Hinweise für spezielle Fähigkeiten an. BigWigs versucht kürzere und passendere Mitteilungen zu erstellen, die den Spielfluss weniger beeinflussen.\n\nHinweis: Bossmitteilungen werden weiterhin im Chat sichtbar sein und können dort gelesen werden."
L.blockMovies = "Wiederholte Filmsequenzen blockieren"
L.blockMoviesDesc = "Filmsequenzen aus Bossbegegnungen werden einmalig wiedergegeben (sodass jede angeschaut werden kann) und danach blockiert."
L.blockFollowerMission = "Popups der Anhänger blockieren"
L.blockFollowerMissionDesc = "Popups der Anhänger zeigen hauptsächlich abgeschlossene Missionen von Anhängern an.\n\nDa diese Popups während des Bosskampfes ablenken und das Interface überdecken können, sollten sie blockiert werden."
L.blockGuildChallenge = "Popups von Gildenherausforderungen blockieren"
L.blockGuildChallengeDesc = "Popups von Gildenherausforderungen zeigen hauptsächlich den Abschluss eines heroischen Dungeons oder des Herausforderungsmodus an.\n\nDa diese Popups während des Bosskampfes ablenken und das Interface überdecken können, sollten sie blockiert werden."
L.blockSpellErrors = "Hinweise zu fehlgeschlagenen Zaubern blockieren"
L.blockSpellErrorsDesc = "Nachrichten wie \"Fähigkeit noch nicht bereit\", welche normalerweise oben auf dem Bildschirm auftauchen, werden blockiert."
L.blockZoneChanges = "Zonenwechsel Nachrichten blockieren"
L.blockZoneChangesDesc = "Die Nachrichten in der oberen Mitte des Bildschirms wenn eine neue Zone betreten wird wie '|cFF33FF99Sturmwind|r' oder '|cFF33FF99Orgrimmar|r' werden blockiert."
L.audio = "Audio"
L.music = "Musik"
L.ambience = "Umgebungsgeräusche"
L.sfx = "Soundeffekte"
L.errorSpeech = "Audiofehlermeldungen"
L.disableMusic = "Musik stummschalten (empfohlen)"
L.disableAmbience = "Umgebungsgeräusche stummschalten (empfohlen)"
L.disableSfx = "Soundeffekte stummschalten (nicht empfohlen)"
L.disableErrorSpeech = "Audiofehlermeldungen stummschalten (empfohlen)"
L.disableAudioDesc = "Die Option '%s' im WoW Soundmenü wird deaktiviert und erst nach dem Bosskampf wieder aktiviert. Dies kann helfen sich auf die BigWigs Sounds zu konzentrieren."
L.blockTooltipQuests = "Questziele im Tooltip blockieren"
L.blockTooltipQuestsDesc = "Wenn zum Abschluss einer Quest ein Boss getötet werden muss, wird der Fortschritt normalerweise im MouseOver-Tooltip mit '0/1 abgeschlossen' angezeigt. Dieser Fortschritt wird im Kampf versteckt, damit der Tooltip nicht zu groß wird."
L.blockObjectiveTracker = "Questverfolgung ausblenden"
L.blockObjectiveTrackerDesc = "Die Liste mit verfolgten Quests wird im Bosskampf ausgeblendet um Anzeigeplatz zu sparen.\n\nDies passiert NICHT in Mythic+ oder beim Verfolgen eines Erfolges."

L.blockTalkingHead = "'Sprechende Dialoge' NPC Popup verstecken"
L.blockTalkingHeadDesc = "Die 'Sprechenden Dialoge' sind Popup Dialogboxen, welche |cffff4411manchmal|r mit dem Kopf des NPCs und einem Chattext in der unteren Mitte des Bildschirms angezeigt werden, während ein NPC spricht.\n\nEs kann festgelegt werden, in welchen Instanztypen diese Dialoge blockiert werden.\n\n|cFF33FF99Bitte beachten:|r\n 1) Diese Funktion behält die NPC Stimme bei, sodass diese gehört werden kann.\n 2) Sicherheitshalber werden nur spezifische Dialoge blockiert. Spezielle oder einmalige Dialoge wie Einmal-Quests werden nicht blockiert."
L.blockTalkingHeadDungeons = "Normale & Heroische Dungeons"
L.blockTalkingHeadMythics = "Mythische & Mythisch+ Dungeons"
L.blockTalkingHeadRaids = "Schlachtzüge"
L.blockTalkingHeadTimewalking = "Zeitwanderung (Dungeons & Schlachtzüge)"
L.blockTalkingHeadScenarios = "Szenarien"

L.redirectPopups = "Popup Banner als BigWigs Nachrichten ausgeben"
L.redirectPopupsDesc = "Popup Banner in der Mitte des Bildschirms wie das '|cFF33FF99Platz für Schatzkammer aufgewertet|r' Banner werden stattdessen als BigWigs Nachrichten angezeigt. Diese Banner können recht groß und lange Zeit angezeigt werden, was die Möglichkeit blockiert durch diese hindurch zu Klicken."
L.redirectPopupsColor = "Farbe der ausgegebenen Nachricht"
L.blockDungeonPopups = "Popup Banner in Instanzen blockieren"
L.blockDungeonPopupsDesc = "Die Popup Banner beim Betreten einer Instanz können sehr lange Texte enthalten. Die Aktivierung dieser Option blockiert diese komplett."
L.itemLevel = "Gegenstandsstufe %d"

L.userNotifySfx = "Soundeffekte wurden von BossBlock deaktiviert, Aktivierung wird erzwungen."
L.userNotifyMusic = "Musik wurde von BossBlock deaktiviert, Aktivierung wird erzwungen."
L.userNotifyAmbience = "Umgebungsgeräusche wurden von BossBlock deaktiviert, Aktivierung wird erzwungen."
L.userNotifyErrorSpeech = "Audiofehlermeldungen wurden von BossBlock deaktiviert, Aktivierung wird erzwungen."

L.subzone_grand_bazaar = "Der Große Basar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "Der Hafen von Zandalar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "Östliches Transept" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "Farben"

L.text = "Text"
L.textShadow = "Textschatten"
L.normal = "Normal"
L.emphasized = "Hervorgehoben"

L.reset = "Zurücksetzen"
L.resetDesc = "Setzt die obenstehenden Farben auf ihre Ausgangswerte zurück."
L.resetAll = "Alle zurücksetzen"
L.resetAllDesc = "Falls Du veränderte Farbeinstellungen für Bosse benutzt, wird dieser Button ALLE zurücksetzen, sodass erneut die hier festgelegten Farben verwendet werden."

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
-- Countdown.lua
--

L.textCountdown = "Countdown-Text"
L.textCountdownDesc = "Zeige einen sichtbaren Zähler während eines Countdowns."
L.countdownColor = "Countdown-Farbe"
L.countdownVoice = "Countdown-Stimme"
L.countdownTest = "Countdown testen"
L.countdownAt = "Countdown ab... (Sekunden)"
L.countdownAt_desc = "Verbleibende Zeit einer Bossfähigkeit (in Sekunden) wählen, wenn der Countdown beginnt."
L.countdown = "Countdown"
L.countdownDesc = "Die Countdown Funktion besteht aus einem gesprochenen Audio-Countdown sowie einem visuellen Text-Coutdown. Sie ist selten standardmäßig aktiviert, aber kann für jede Bossfähigkeit in den jeweiligen Einstellungen der Bosse aktiviert werden."
L.countdownAudioHeader = "Gesprochener Audio-Countdown"
L.countdownTextHeader = "Visueller Text-Countdown"
L.resetCountdownDesc = "Setzt alle obigen Countdown Einstellungen auf ihre Standardwerte zurück."
L.resetAllCountdownDesc = "Wenn Du veränderte Countdowns für Bossbegegnungen gewählt hast, wird dieser Button ALLE zurücksetzen und die obigen Countdown Einstellungen auf ihre Standardwerte zurücksetzen."

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infoBox = "InfoBox"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Sendet die BigWigs-Ausgabe durch die normale BigWigs-Nachrichtenanzeige. Diese Anzeige unterstützt Symbole, Farben und kann 4 Nachrichten gleichzeitig anzeigen. Neuere Nachrichten werden größer und schrumpfen dann wieder schnell, um die Aufmerksamkeit dementsprechend zu lenken."
L.emphasizedSinkDescription = "Sendet Ausgaben dieses Addons durch BigWigs’ Anzeige für hervorgehobene Nachrichten. Diese Anzeige unterstützt Text und Farbe und kann nur eine Nachricht gleichzeitig anzeigen."
L.resetMessagesDesc = "Setzt alle Optionen im Zusammenhang mit Nachrichten zurück, inklusive der Position der Anker für Nachrichten."
L.toggleMessagesAnchorsBtnShow_desc = "Zeigt alle Bewegungs-Anker zum Bewegen der Nachrichten."

L.testMessagesBtn = "Testnachricht erstellen"
L.testMessagesBtn_desc = "Erstellt eine Nachricht zum Testen der aktuellen Anzeigeeinstellungen."

L.bwEmphasized = "BigWigs Hervorgehoben"
L.messages = "Nachrichten"
L.emphasizedMessages = "Hervorgehobene Nachrichten"
L.emphasizedDesc = "Hervorgehobene Nachrichten dienen dazu die Aufmerksamkeit zu erregen, indem eine große Nachricht in der Bildschirmmitte angezeigt wird. Diese sind selten standardmäßig aktiviert, aber können für jegliche Bossfähigkeiten in den Einstellungen des jeweiligen Bosses aktiviert werden."
L.uppercase = "GROSSBUCHSTABEN"
L.uppercaseDesc = "Alle hervorgehobenen Nachrichten werden in GROSSBUCHSTABEN konvertiert."

L.useIcons = "Symbole verwenden"
L.useIconsDesc = "Zeigt Symbole neben Nachrichten an."
L.classColors = "Klassenfarben"
L.classColorsDesc = "Teilweise enthalten Nachrichten Spielernamen. Durch Aktivierung dieser Option werden die Namen in Ihrer Klassenfarbe angezeigt."
L.chatFrameMessages = "Chatfenster-Nachrichten"
L.chatFrameMessagesDesc = "Gibt alle BigWigs-Nachrichten im Standard-Chatfenster aus, zusätzlich zu der Einstellung unter 'Ausgabe'."

L.fontSize = "Schriftgröße"
L.none = "Nichts"
L.thin = "Dünn"
L.thick = "Dick"
L.outline = "Kontur"
L.monochrome = "Monochrom"
L.monochromeDesc = "Schaltet den Monochrom-Filter an/aus, der die Schriftenkantenglättung entfernt."
L.fontColor = "Schriftfarbe"

L.displayTime = "Anzeigedauer"
L.displayTimeDesc = "Bestimmt, wie lange (in Sekunden) Nachrichten angezeigt werden."
L.fadeTime = "Ausblendedauer"
L.fadeTimeDesc = "Bestimmt, wie lange (in Sekunden) das Ausblenden der Nachrichten dauert."

-----------------------------------------------------------------------
-- Nameplates.lua
--

L.nameplates = "Namensplaketten"
L.testNameplateIconBtn = "Testsymbol anzeigen"
L.testNameplateIconBtn_desc = "Erstellt ein Testsymbol zum Testen der aktuellen Symboleinstellungen an der anvisierten Namensplakette."
L.testNameplateTextBtn = "Testtext anzeigen"
L.testNameplateTextBtn_desc = "Erstellt einen Testtext zum Testen der aktuellen Texteinstellungen an der anvisierten Namensplakette."
L.stopTestNameplateBtn = "Tests stoppen"
L.stopTestNameplateBtn_desc = "Stoppt die Symbol- und Texttests an den Namensplaketten."
L.noNameplateTestTarget = "Es muss ein feindliches angreifbares Ziel zum Testen der Namensplaketten-Funktionen anvisiert werden."
L.anchoring = "Verankerung"
L.growStartPosition = "Startposition der Symbole"
L.growStartPositionDesc = "Die Startposition für das erste Symbol."
L.growDirection = "Richtung der Symbole"
L.growDirectionDesc = "Die Richtung in welche die Symbole von der Startposition wachsen."
L.iconSpacingDesc = "Abstand zwischen den Symbolen ändern."
L.nameplateIconSettings = "Symboleinstellungen"
L.keepAspectRatio = "Seitenverhältnis beibehalten"
L.keepAspectRatioDesc = "Behält das Seitenverhältnis des Symbols 1:1 bei, anstatt es in den Rahmen passend zu Strecken."
L.iconColor = "Symbolfarbe"
L.iconColorDesc = "Ändert die Farbe der Symboltextur."
L.desaturate = "Entsättigen"
L.desaturateDesc = "Entsättigt die Symboltextur."
L.zoom = "Zoom"
L.zoomDesc = "Zoomt die Symboltextur."
L.showBorder = "Rand anzeigen"
L.showBorderDesc = "Zeigt einen Rand um das Symbol."
L.borderColor = "Randfarbe"
L.borderSize = "Randgröße"
L.showNumbers = "Zahlen anzeigen"
L.showNumbersDesc = "Zeigt Zahlen auf dem Symbol an."
L.cooldown = "Abklingzeit"
L.showCooldownSwipe = "Zirkel anzeigen"
L.showCooldownSwipeDesc = "Zeigt einen Zirkel auf der Abklingzeit, wenn diese aktiv ist."
L.showCooldownEdge = "Kante hervorheben"
L.showCooldownEdgeDesc = "Hebt die Kante des Zirkels auf der Abklingzeit hervor, wenn diese aktiv ist."
L.inverse = "Invertieren"
L.inverseSwipeDesc = "Invertiert die Abklingzeit Animationen."
L.glow = "Leuchten"
L.enableExpireGlow = "Aktiviere Leuchten beim Ablaufen"
L.enableExpireGlowDesc = "Zeigt ein Leuchten um das Symbol wenn die Abklingzeit abgelaufen ist."
L.glowColor = "Leuchtfarbe"
L.glowType = "Leuchttyp"
L.glowTypeDesc = "Ändert den Leuchttyp der um das Symbol angezeigt wird."
L.resetNameplateIconsDesc = "Setzt alle Optionen für Namensplaketten-Symbole zurück."
L.nameplateTextSettings = "Texteinstellungen"
L.fixate_test = "Fixierung Test" -- Text that displays to test on the frame
L.resetNameplateTextDesc = "Setzt die Optionen für Namensplaketten-Texte zurück."
L.autoScale = "Automatischer Maßstab"
L.autoScaleDesc = "Ändert den Maßstab automatisch in Abhängigkeit vom Maßstab der Namensplakette."
L.glowAt = "Leuchten beginnen (Sekunden)"
L.glowAt_desc = "Legt fest, bei welcher verbleibenden Abklingzeit in Sekunden das Leuchten beginnt."

-- Glow types as part of LibCustomGlow
L.pixelGlow = "Pixel-Leuchten"
L.autocastGlow = "Autozauber-Leuchten"
L.buttonGlow = "Button-Leuchten"
L.procGlow = "Proc-Leuchten"
L.speed = "Geschwindigkeit"
L.animation_speed_desc = "Die Geschwindigkeit der Leuchtanimation."
L.lines = "Linien"
L.lines_glow_desc = "Die Anzahl der Linien in der Leuchtanimation."
L.intensity = "Intensität"
L.intensity_glow_desc = "Die Intensität des Leuchteffektes, höher bedeutet mehr Funken."
L.length = "Länge"
L.length_glow_desc = "Die Länge der Linien in der Leuchtanimation."
L.thickness = "Dicke"
L.thickness_glow_desc = "Die Dicke der Linien in der Leuchtanimation."
L.scale = "Maßstab"
L.scale_glow_desc = "Der Maßstab der Funken in der Animation."
L.startAnimation = "Startanimation"
L.startAnimation_glow_desc = "Dieses Leuchten hat eine Startanimation, dies aktiviert/deaktiviert diese Animation."

-----------------------------------------------------------------------
-- Proximity.lua
--

L.customRange = "Eigene Näherungsanzeige"
L.proximityTitle = "%d m / %d Spieler"
L.proximity_name = "Nähe"
L.soundDelay = "Soundverzögerung"
L.soundDelayDesc = "Gibt an, wie lange BigWigs zwischen den Soundwiederholungen wartet, wenn jemand zu nahe steht."

L.resetProximityDesc = "Setzt alle Optionen im Zusammenhang mit Nähe zurück, inklusive der Position des Ankers für Nähe."

L.close = "Schließen"
L.closeProximityDesc = "Schließt die Anzeige naher Spieler.\n\nFalls Du die Anzeige für alle Bosse deaktivieren willst, musst Du die Option 'Nähe' seperat in den jeweiligen Bossmodulen ausschalten."
L.lock = "Fixieren"
L.lockDesc = "Fixiert die Anzeige und verhindert weiteres Verschieben und Anpassen der Größe."
L.title = "Titel"
L.titleDesc = "Zeigt oder versteckt den Titel der Anzeige."
L.background = "Hintergrund"
L.backgroundDesc = "Zeigt oder versteckt den Hintergrund der Anzeige."
L.toggleSound = "Sound an/aus"
L.toggleSoundDesc = "Schaltet den Sound ein oder aus, der gespielt wird, wenn Du zu nahe an einem anderen Spieler stehst."
L.soundButton = "Sound-Button"
L.soundButtonDesc = "Zeigt oder versteckt den Sound-Button."
L.closeButton = "Schließen-Button"
L.closeButtonDesc = "Zeigt oder versteckt den Schließen-Button."
L.showHide = "Zeigen/Verstecken"
L.abilityName = "Fähigkeitsname"
L.abilityNameDesc = "Zeigt oder versteckt den Fähigkeitsnamen über dem Fenster."
L.tooltip = "Tooltip"
L.tooltipDesc = "Zeigt oder versteckt den Zaubertooltip, wenn die Näheanzeige direkt an eine Bossfähigkeit gebunden ist."

-----------------------------------------------------------------------
-- Pull.lua
--

L.countdownType = "Countdowntyp"
L.combatLog = "Automatische Kampfaufzeichnung"
L.combatLogDesc = "Startet automatisch die Aufzeichnung des Kampfes, wenn ein Pull-Timer gestartet wurde und beendet die Aufzeichnung, wenn der Bosskampf endet."

L.pull = "Pull"
L.engageSoundTitle = "Spiele  einen Sound ab, sobald ein Bosskampf beginnt"
L.pullStartedSoundTitle = "Spiele einen Sound ab, sobald ein Pull-Timer gestartet wurde"
L.pullFinishedSoundTitle = "Spiele einen Sound ab, sobald ein Pull-Timer abgelaufen ist"
L.pullStartedBy = "Pull-Timer gestartet von %s."
L.pullStopped = "Pull-Timer von %s abgebrochen."
L.pullStoppedCombat = "Pull-Timer wurde abgebrochen, weil Du einen Kampf begonnen hast."
L.pullIn = "Pull in %d Sek."
L.sendPull = "Sendet einen Pull-Timer an die Gruppe."
L.wrongPullFormat = "Ungültiger Pull-Timer. Ein korrektes Beispiel ist: /pull 5"
L.countdownBegins = "Countdown starten"
L.countdownBegins_desc = "Verbleibende Zeit des Pulltimers (in Sekunden) wählen, wenn der Countdown beginnt."

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L.icons = "Symbole"
L.raidIconsDescription = "Einige Begegnungen schließen Elemente wie 'Bombenfähigkeiten' ein, die einen bestimmten Spieler zum Ziel haben, ihn verfolgen oder er ist in sonst einer Art und Weise interessant. Hier kannst du bestimmen, welche Schlachtzugs-Symbole benutzt werden sollen, um die Spieler zu markieren.\n\nFalls nur ein Symbol benötigt wird, wird nur das erste benutzt. Ein Symbol wird niemals für zwei verschiedene Fähigkeiten innerhalb einer Begegnung benutzt.\n\n|cffff4411Beachte, dass ein manuell markierter Spieler von BigWigs nicht ummarkiert wird.|r"
L.primary = "Erstes Symbol"
L.primaryDesc = "Das erste Schlachtzugssymbol, das verwendet wird."
L.secondary = "Zweites Symbol"
L.secondaryDesc = "Das zweite Schlachtzugssymbol, das verwendet wird."

-----------------------------------------------------------------------
-- Sound.lua
--

L.Sounds = "Sounds"
L.soundsDesc = "BigWigs nutzt den 'Haupt'-Soundkanal um die Sounds wiederzugeben. Wenn die Sounds zu leise oder zu laut sind, kann dies in den WoW Soundoptionen mit dem Schieberegler 'Gesamtlautstärke' angepasst werden.\n\nFolgend können global die verschiedenen Sounds für spezifische Aktionen konfiguriert, oder zum Deaktivieren auf 'None' gesetzt werden. Wenn der Sound einer spezifischen Bossfähigkeit geändert werden soll, kann dies in den Einstellungen der Bossbegegnung eingestellt werden.\n\n"
L.oldSounds = "Alte Sounds"

L.Alarm = "Alarm"
L.Info = "Info"
L.Alert = "Alarmruf"
L.Long = "Lang"
L.Warning = "Warnung"
L.onyou = "Ein Zauber, Stärkungs- oder Schwächungszauber ist auf Dir"
L.underyou = "Du musst aus einem Zauber unter Dir herauslaufen"
L.privateaura = "Immer wenn eine 'Private Aura' auf Dir ist"

L.sound = "Sound"

L.customSoundDesc = "Den speziell gewählten Sound anstatt des vom Modul bereitgestellten abspielen."
L.resetSoundDesc = "Setzt die obigen Sounds auf ihren Standard zurück."
L.resetAllCustomSound = "Wenn Du Sounds für Bossbegegnungen geändert hast, werden diese ALLE über diese Schaltfläche zurückgesetzt, sodass stattdessen die hier gewählten genutzt werden."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossStatistics = "Boss-Statistiken"
L.bossStatsDescription = "Aufzeichnung verschiedener Boss-bezogener Statistiken wie die Anzahl der Siege, die Anzahl der Niederlagen, das Datum des ersten Sieges und der schnellste Sieg. Diese Statistiken können, falls vorhanden, in der Konfiguration der einzelnen Bosse eingesehen werden. Andernfalls werden diese ausgeblendet."
L.createTimeBar = "Bestzeittimer anzeigen"
L.bestTimeBar = "Bestzeit"
L.healthPrint = "Gesundheit: %s."
L.healthFormat = "%s (%.1f%%)"
L.chatMessages = "Chatnachrichten"
L.newFastestVictoryOption = "Neuer schnellster Sieg"
L.victoryOption = "Du warst erfolgreich"
L.defeatOption = "Du wurdest besiegt"
L.bossHealthOption = "Bossgesundheit"
L.bossVictoryPrint = "Du hast '%s' nach %s besiegt." -- You were victorious against 'BOSS_NAME' after COMBAT_DURATION.
L.bossDefeatPrint = "Du wurdest von '%s' nach %s besiegt." -- You were defeated by 'BOSS_NAME' after COMBAT_DURATION.
L.newFastestVictoryPrint = "Neuer schnellster Sieg: (-%s)" -- New fastest victory: (-COMBAT_DURATION)

-----------------------------------------------------------------------
-- Victory.lua
--

L.Victory = "Sieg"
L.victoryHeader = "Konfiguriert die Aktionen, die nach einem erfolgreichen Bosskampf stattfinden."
L.victorySound = "Spiele einen Sieges-Sound"
L.victoryMessages = "Nachrichten nach Sieg über einen Boss zeigen"
L.victoryMessageBigWigs = "Die Mitteilung von BigWigs anzeigen"
L.victoryMessageBigWigsDesc = "Die Mitteilung von BigWigs ist eine einfache \"Boss wurde besiegt\" Mitteilung."
L.victoryMessageBlizzard = "Die Blizzard-Mitteilung anzeigen"
L.victoryMessageBlizzardDesc = "Die Blizzard-Mitteilung ist eine sehr große \"Boss wurde besiegt\" Animation in der Mitte deines Bildschirms."
L.defeated = "%s wurde besiegt!"

-----------------------------------------------------------------------
-- Wipe.lua
--

L.wipe = "Niederlage"
L.wipeSoundTitle = "Spiele bei einer Niederlage einen Sound ab"
L.respawn = "Erneutes Erscheinen"
L.showRespawnBar = "Erneutes-Erscheinen-Leiste anzeigen"
L.showRespawnBarDesc = "Zeigt nach einer Niederlage eine Leiste mit der Zeit bis zum erneuten Erscheinen des Bosses an."
