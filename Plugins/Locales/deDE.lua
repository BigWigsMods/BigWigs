local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "deDE")
if not L then return end

-----------------------------------------------------------------------
-- Bars.lua
--

L["Style"] = "Stil"
L.bigWigsBarStyleName_Default = "Standard"

L["Clickable Bars"] = "Interaktive Leisten"
L.clickableBarsDesc = "Big Wigs Leisten sind standardmäßig nicht anklickbar. Dies ermöglicht es, das Ziel zu wechseln, AoE-Zauber zu setzen und die Kameraperspektive zu ändern, während sich die Maus über den Leisten befindet. |cffff4411Die Aktivierung der Interaktiven Leisten verhindert dieses Verhalten.|r Die Leisten werden jeden Mausklick abfangen, oben beschriebene Aktionen können dann nur noch außerhalb der Leistenanzeige ausgeführt werden.\n"
L["Enables bars to receive mouse clicks."] = "Aktiviert die Interaktiven Leisten."
L["Modifier"] = "Modifikator"
L["Hold down the selected modifier key to enable click actions on the timer bars."] = "Wenn die Modifikatortaste gedrückt gehalten wird, können Klickaktionen auf die Leisten ausgeführt werden."
L["Only with modifier key"] = "Nur mit Modifikatortaste"
L["Allows bars to be click-through unless the specified modifier key is held down, at which point the mouse actions described below will be available."] = "Erlaubt nicht-interaktive Leisten solange bis die Modifikatortaste gedrückt gehalten wird und dann die unten aufgeführten Mausaktionen verfügbar werden."

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = "Hebt zeitweilig Leisten und zugehörige Nachrichten stark hervor."
L["Report"] = "Berichten"
L["Reports the current bars status to the active group chat; either instance chat, raid, party or say, as appropriate."] = "Gibt den aktuellen Leistenstatus im Instanz-, Schlachtzugs-, Gruppen- oder Say-Chat aus."
L["Remove"] = "Entfernen"
L["Temporarily removes the bar and all associated messages."] = "Entfernt zeitweilig die Leiste und alle zugehörigen Nachrichten aus der Anzeige."
L["Remove other"] = "Andere entfernen"
L["Temporarily removes all other bars (except this one) and associated messages."] = "Entfernt zeitweilig alle anderen Leisten (außer der Angeklickten) und zugehörigen Nachrichten aus der Anzeige."
L["Disable"] = "Deaktivieren"
L["Permanently disables the boss encounter ability option that spawned this bar."] = "Deaktiviert die Option, die diese Leiste erzeugt hat, zukünftig permanent."

L["Emphasize at... (seconds)"] = "Hervorheben bei... (Sekunden)"
L["Scale"] = "Skalierung"
L["Grow upwards"] = "Nach oben erweitern"
L["Toggle bars grow upwards/downwards from anchor."] = "Legt fest, ob sich die Leisten von der Verankerung aus nach oben oder unten erweitern."
L["Texture"] = "Textur"
L["Emphasize"] = "Hervorheben"
L["Enable"] = "Aktiviert"
L["Move"] = "Bewegen"
L.moveDesc = "Bewegt hervorgehobene Leisten zum hervorgehobenen Anker. Ist diese Option nicht aktiv, werden hervorgehobene Leisten lediglich in Größe und Farbe geändert."
L["Regular bars"] = "Normale Leisten"
L["Emphasized bars"] = "Hervorgehobene Leisten"
L["Align"] = "Ausrichtung"
L["Left"] = "Links"
L["Center"] = "Mittig"
L["Right"] = "Rechts"
L["Time"] = "Zeit"
L["Whether to show or hide the time left on the bars."] = "Bestimmt, ob die verbleibende Zeit auf den Leisten angezeigt wird."
L["Icon"] = "Symbol"
L["Shows or hides the bar icons."] = "Zeigt oder versteckt die Symbole auf den Leisten."
L["Font"] = "Schriftart"
L["Restart"] = "Neu starten"
L["Restarts emphasized bars so they start from the beginning and count from 10."] = "Startet die hervorgehobenen Leisten neu, so dass sie bis 10 hochzählen anstatt von 10 herunter."
L["Fill"] = "Füllen"
L["Fills the bars up instead of draining them."] = "Füllt die Leisten anstatt sie zu entleeren."

L["Local"] = "Lokal"
L["%s: Timer [%s] finished."] = "%s: Timer [%s] beendet."
L["Custom bar '%s' started by %s user '%s'."] = "Custombar '%s' wurde von gestartet von %s Nutzer '%s'."

L["Pull"] = "Pull"
L["Pulling!"] = "Pull!"
L["Pull timer started by %s user '%s'."] = "Pull Timer wurde von %s-User '%s' gestartet."
L["Pull in %d sec"] = "Pull in %d sec"
L["Sending a pull timer to Big Wigs and DBM users."] = "Sende Pull-Timer an Big Wigs und DBM Nutzer."
L["Sending custom bar '%s' to Big Wigs and DBM users."] = "Sende Custombar '%s' an Big Wigs und DBM Nutzer."
L["This function requires raid leader or raid assist."] = "Diese Funktion benötigt Schlachtzugsleiter oder -assistent."
L["Must be between 1 and 60. A correct example is: /pull 5"] = "Muss zwischen 1 und 60 sein. Beispiel: /pull 5"
L["Incorrect format. A correct example is: /raidbar 20 text"] = "Ungültiges Format. Beispiel: /raidbar 20 text"
L["Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Ungültige Zeitangabe. <time> kann eine Zahl in Sekunden, ein M:S paarung, oder Mm sein. Beispiel: 5, 1:20 or 2m."
L["This function can't be used during an encounter."] = "Diese Funktion kann während des Bosskampfes nicht genutzt werden."

L.customBarSlashPrint = "Diese Funktion wurde umbenannt. Verwende /raidbar um eine Custombar an den Raid zu senden oder /localbar um die Leiste nur bei Dir anzuzeigen."

-----------------------------------------------------------------------
-- Colors.lua
--

L.Colors = "Farben"

L.Messages = "Nachrichten"
L.Bars = "Leisten"
L.Background = "Hintergrund"
L.Text = "Text"
L.TextShadow = "Textschatten"
L.Flash = "Aufleuchten"
L.Normal = "Normal"
L.Emphasized = "Hervorgehoben"

L.Reset = "Zurücksetzen"
L["Resets the above colors to their defaults."] = "Setzt die obenstehenden Farben auf ihre Ausgangswerte zurück."
L["Reset all"] = "Alle zurücksetzen"
L["If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."] = "Falls du veränderte Farbeinstellungen für Bosse benutzt, wird dieser Button ALLE zurücksetzen, so dass erneut die hier festgelegten Farben verwendet werden."

L.Important = "Wichtig"
L.Personal = "Persönlich"
L.Urgent = "Dringend"
L.Attention = "Achtung"
L.Positive = "Positiv"
L.Neutral = "Neutral"

-----------------------------------------------------------------------
-- Emphasize.lua
--

L["Super Emphasize"] = "Stark hervorheben"
L.superEmphasizeDesc = "Verstärkt zugehörige Nachrichten oder Leisten einer bestimmten Begegnung.\n\nHier kannst du genau bestimmen, was passieren soll, wenn du in den erweiterten Optionen einer Bossfähigkeit 'Stark hervorheben' aktivierst.\n\n|cffff4411Beachte, dass 'Stark hervorheben' standardmäßig für alle Fähigkeiten deaktiviert ist.|r\n"
L["UPPERCASE"] = "GROSSBUCHSTABEN"
L["Uppercases all messages related to a super emphasized option."] = "Schreibt alle Nachrichten in Großbuchstaben, die die zugehörige 'Stark hervorheben'-Option aktiviert haben."
L["Double size"] = "Doppelte Größe"
L["Doubles the size of super emphasized bars and messages."] = "Verdoppelt die Größe von 'Stark hervorgehobenen' Leisten und Nachrichten."
L["Countdown"] = "Countdown"
L["If a related timer is longer than 5 seconds, a vocal and visual countdown will be added for the last 5 seconds. Imagine someone counting down \"5... 4... 3... 2... 1... COUNTDOWN!\" and big numbers in the middle of your screen."] = "Falls ein zugehöriger Timer länger als 5 Sekunden dauert, wird ein visueller und auditiver Countdown die letzten 5 Sekunden begleiten. Stell dir vor, jemand würde \"5... 4... 3... 2... 1... COUNTDOWN!\" herunterzählen und große Nummern in die Mitte des Bildschirm setzen."

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Sendet die Big Wigs Ausgabe durch die normale Big Wigs Nachrichtenanzeige. Diese Anzeige unterstützt Symbole, Farben und kann 4 Nachrichten gleichzeitig anzeigen. Neuere Nachrichten werden größer und schrumpfen dann wieder schnell, um die Aufmerksamkeit dementsprechend zu lenken."
L.emphasizedSinkDescription = "Sendet die Big Wigs Ausgabe durch Big Wigs 'stark hervorgehobene' Nachrichtenanzeige. Diese Anzeige unterstützt Text und Farbe und kann nur eine Nachricht gleichzeitig anzeigen."
L.emphasizedCountdownSinkDescription = "Sendet Ausgaben dieses Addons durch Big Wigs 'stark hervorgehobene' Countdown Nachrichtenanzeige. Hierbei werden Text sowie Farben unterstützt und es wird immer nur eine Zeile gleichzeitig angezeigt."

L["Big Wigs Emphasized"] = "Big Wigs-Hervorgehobene Einstellungen"
L["Messages"] = "Nachrichten"
L["Normal messages"] = "Normale Nachrichten"
L["Emphasized messages"] = "Hervorgehobene Nachrichten"
L["Output"] = "Ausgabe"
L["Emphasized countdown"] = "Hervorgehobener Countdown"

L["Use colors"] = "Farben verwenden"
L["Toggles white only messages ignoring coloring."] = "Wählt, ob Nachrichten farbig oder weiß angezeigt werden."

L["Use icons"] = "Symbole benutzen"
L["Show icons next to messages, only works for Raid Warning."] = "Zeigt Symbole neben Nachrichten an."

L["Class colors"] = "Klassenfarben"
L["Colors player names in messages by their class."] = "Färbt Spielernamen in Nachrichten nach deren Klasse ein."

L["Font size"] = "Schriftgröße"
L["None"] = "Nichts"
L["Thin"] = "Dünn"
L["Thick"] = "Dick"
L["Outline"] = "Kontur"
L["Monochrome"] = "Monochrom"
L["Toggles the monochrome flag on all messages, removing any smoothing of the font edges."] = "Schaltet den Monochrom-Filter in allen Nachrichten an/aus, der die Schriftenkantenglättung entfernt."
L["Font color"] = "Schriftfarbe"

L["Display time"] = "Anzeigedauer"
L["How long to display a message, in seconds"] = "Bestimmt, wie lange (in Sekunden) Nachrichten angezeigt werden."
L["Fade time"] = "Ausblendedauer"
L["How long to fade out a message, in seconds"] = "Bestimmt, wie lange (in Sekunden) das Ausblenden der Nachrichten dauert."

-----------------------------------------------------------------------
-- Proximity.lua
--

L["Custom range indicator"] = "Eigene Reichweitenanzeige"
L.proximityTitle = "%d m / %d Spieler"
L["Proximity"] = "Nähe"
L["Sound"] = "Sound"
L["Disabled"] = "Deaktivieren"
L["Disable the proximity display for all modules that use it."] = "Deaktiviert die Anzeige naher Spieler für alle Module, die sie benutzen."
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "Die Anzeige naher Spieler wird beim nächsten Mal angezeigt werden. Um sie für diesen Boss vollständig zu deaktivieren, musst du die Option 'Nähe' im Bossmodul ausschalten."
L["Sound delay"] = "Soundverzögerung"
L["Specify how long Big Wigs should wait between repeating the specified sound when someone is too close to you."] = "Gibt an, wie lange Big Wigs zwischen den Soundwiederholungen wartet, wenn jemand zu nahe steht."

L.proximity = "Nähe"
L.proximity_desc = "Zeigt das Fenster für nahe Spieler an. Es listet alle Spieler auf, die dir zu nahe stehen."

L["Close"] = "Schließen"
L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = "Schließt die Anzeige naher Spieler.\n\nFalls du die Anzeige für alle Bosse deaktivieren willst, musst du die Option 'Nähe' seperat in den jeweiligen Bossmodulen ausschalten."
L["Lock"] = "Sperren"
L["Locks the display in place, preventing moving and resizing."] = "Sperrt die Anzeige und verhindert weiteres Verschieben und Anpassen der Größe."
L["Title"] = "Titel"
L["Shows or hides the title."] = "Zeigt oder versteckt den Titel der Anzeige."
L["Background"] = "Hintergrund"
L["Shows or hides the background."] = "Zeigt oder versteckt den Hintergrund der Anzeige."
L["Toggle sound"] = "Sound an/aus"
L["Toggle whether or not the proximity window should beep when you're too close to another player."] = "Schaltet den Sound ein oder aus, der gespielt wird, wenn du zu nahe an einem anderen Spieler stehst."
L["Sound button"] = "Sound-Button"
L["Shows or hides the sound button."] = "Zeigt oder versteckt den Sound-Button."
L["Close button"] = "Schließen-Button"
L["Shows or hides the close button."] = "Zeigt oder versteckt den Schließen-Button."
L["Show/hide"] = "Zeigen/Verstecken"
L["Ability name"] = "Fähigkeitsname"
L["Shows or hides the ability name above the window."] = "Zeigt oder versteckt den Fähigkeitsnamen über dem Fenster."
L["Tooltip"] = "Tooltip"
L["Shows or hides a spell tooltip if the Proximity display is currently tied directly to a boss encounter ability."] = "Zeigt oder versteckt den Zaubertooltip, wenn die Näheanzeige direkt an eine Bossfähigkeit gebunden ist."

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L["Icons"] = "Symbole"

L.raidIconDescription = "Einige Begegnungen schließen Elemente wie 'Bomben'-Fähigkeiten ein, die einen bestimmten Spieler zum Ziel haben, ihn verfolgen oder er ist in sonst einer Art und Weise interessant. Hier kannst du bestimmen, welche Schlachtzugs-Symbole benutzt werden sollen, um die Spieler zu markieren.\n\nFalls nur ein Symbol benötigt wird, wird nur das erste benutzt. Ein Symbol wird niemals für zwei verschiedene Fähigkeiten innerhalb einer Begegnung benutzt.\n\n|cffff4411Beachte, dass ein manuell markierter Spieler von Big Wigs nicht ummarkiert wird.|r"
L["Primary"] = "Erstes Symbol"
L["The first raid target icon that a encounter script should use."] = "Das erste Schlachtzugs-Symbol, das verwendet wird."
L["Secondary"] = "Zweites Symbol"
L["The second raid target icon that a encounter script should use."] = "Das zweite Schlachtzugs-Symbol, das verwendet wird."

L["Star"] = "Stern"
L["Circle"] = "Kreis"
L["Diamond"] = "Diamant"
L["Triangle"] = "Dreieck"
L["Moon"] = "Mond"
L["Square"] = "Quadrat"
L["Cross"] = "Kreuz"
L["Skull"] = "Totenkopf"
L["|cffff0000Disable|r"] = "|cffff0000Deaktiviert|r"

-----------------------------------------------------------------------
-- Sound.lua
--

L.soundDefaultDescription = "Falls diese Option aktiviert ist, wird Big Wigs nur die Standard-Raidsounds von Blizzard für Nachrichten benutzen. Beachte, dass nicht alle Nachrichten einer Begegnung einen Sound auslösen."

L.Sounds = "Sounds"

L.Alarm = "Alarm"
L.Info = "Info"
L.Alert = "Warnung"
L.Long = "Lang"
L.Warning = "Warnung"
L.Victory = "Sieg"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Legt den Sound fest, der für %q verwendet wird.\n\nStrg-Klicken, um reinzuhören."
L["Default only"] = "Nur Standards"

L.customSoundDesc = "Den speziell gewählten Sound anstatt des vom Modul bereitgestellten abspielen"
L.resetAllCustomSound = "Wenn Du die Sounds für Bossbegegnungen geändert hast, werden diese ALLE über diese Schaltfläche zurückgesetzt, sodass stattdessen die hier gewählten genutzt werden."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossKillDurationPrint = "'%s' wurde nach %s besiegt."
L.bossWipeDurationPrint = "An '%s' nach %s gescheitert."
L.newBestKill = "Neue Rekordzeit!"
L.bossStatistics = "Boss-Statistiken"
L.bossStatsDescription = "Zeichnet verschiedene Statistiken der Bossbegegnungen wie die Anzahl der Siege und Niederlagen, sowie die Kampfdauer oder die Rekordzeiten auf. Diese Statistiken können, falls vorhanden, in der Konfiguration der einzelnen Bosse eingesehen werden. Andernfalls werden diese ausgeblendet."
L.enableStats = "Statistiken aktivieren"
L.chatMessages = "Chatnachrichten"
L.printBestKillOption = "Benachrichtigung über besten Kill"
L.printKillOption = "Siegesdauer"
L.printWipeOption = "Niederlagendauer"
L.countKills = "Siege zählen"
L.countWipes = "Niederlagen zählen"
L.recordBestKills = "Beste Siege speichern"

