local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "deDE")

if not L then return end

-- Bars2.lua

L["Bars"] = "Leisten"
L["Normal Bars"] = "Normale Leisten"
L["Emphasized Bars"] = "Hervorgehobene Leisten"
L["Options for the timer bars."] = "Optionen für die Timerleisten."
L["Toggle anchors"] = "Verankerungen"
L["Show or hide the bar anchors for both normal and emphasized bars."] = "Zeigt oder versteckt die Verankerungen für normale und hervorgehobene Leisten."
L["Scale"] = "Skalierung"
L["Set the bar scale."] = "Justiert die Skalierung der Leisten."
L["Grow upwards"] = "Nach oben erweitern"
L["Toggle bars grow upwards/downwards from anchor."] = "Legt fest, ob sich die Leisten von der Verankerung aus nach oben oder unten erweitern."
L["Texture"] = "Textur"
L["Set the texture for the timer bars."] = "Legt eine Textur für die Leisten fest."
L["Test"] = "Test"
L["Close"] = "Schließen"
L["Emphasize"] = "Hervorheben"
L["Emphasize bars that are close to completion (<10sec). Also note that bars started at less than 15 seconds initially will be emphasized right away."] = "Hervorgehobene Balken, die kurz vor dem Auslaufen sind (<10 Sek). Beachte, dass Leisten, die mit weniger als 15 Sekunden beginnen, automatisch hervorgehoben werden."
L["Enable"] = "Aktiviert"
L["Enables emphasizing bars."] = "Aktiviert die hervorgehobenen Leisten."
L["Move"] = "Bewegen"
L["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = "Bewegt hervorgehobene Leisten zur Verankerung für hervorgehobene Leisten. Wenn diese Option deaktiviert ist, werden hervorgehobene Leisten nur ihre Größe und Farbe ändern und möglicherweise anfangen zu blinken."
L["Set the scale for emphasized bars."] = "Justiert die Skalierung der hervorgehobenen Leisten."
L["Reset position"] = "Position zurücksetzen"
L["Reset the anchor positions, moving them to their default positions."] = "Setzt die Positionen der Verankerungen auf ihre Ausgangsstellung zurück."
L["Test"] = "Test"
L["Creates a new test bar."] = "Erstellt eine neue Testleiste."
L["Hide"] = "Verstecken"
L["Hides the anchors."] = "Versteckt die Verankerungen."
L["Flash"] = "Blinken"
L["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = "Lässt den Hintergrund der hervorgehobenen Leisten blinken, um sie leichter zu erkennen."
L["Regular bars"] = "Normale Leisten"
L["Emphasized bars"] = "Hervorgehobene Leisten"
L["Align"] = "Ausrichtung"
L["How to align the bar labels."] = "Bestimmt, wie der Text auf den Leisten ausgerichtet ist."
L["Left"] = "Links"
L["Center"] = "Mittig"
L["Right"] = "Rechts"
L["Time"] = "Zeit"
L["Whether to show or hide the time left on the bars."] = "Bestimmt, ob die verbleibende Zeit auf den Leisten angezeigt wird."
L["Icon"] = "Symbol"
L["Shows or hides the bar icons."] = "Zeigt oder versteckt die Symbole auf den Leisten."
L["Font"] = "Schriftart"
L["Set the font for the timer bars."] = "Legt die Schriftart des Textes auf den Leisten fest."

L["Local"] = "Lokal"
L["%s: Timer [%s] finished."] = "%s: Timer [%s] beendet."
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Ungültige Zeit (|cffff0000%q|r) oder fehlender Leistentext in eigener Leiste, gestartet von |cffd9d919%s|r. <Zeit> kann entweder eine Zahl in Sekunden, eine M:S Kombination oder Mm sein. Beispiele: 5, 1:20 or 2m."

-- Colors.lua

L["Colors"] = "Farben"

L["Messages"] = "Nachrichten"
L["Bars"] = "Anzeigebalken"
L["Short"] = "Kurz"
L["Long"] = "Lang"
L["Short bars"] = "Kurze Anzeigebalken"
L["Long bars"] = "Lange Anzeigebalken"
L["Color "] =  "Farbe "
L["Number of colors"] = "Anzahl der Farben"
L["Background"] = "Hintergrund"
L["Text"] = "Text"
L["Reset"] = "Zurücksetzen"

L["Bar"] = "Balken"
L["Change the normal bar color."] = "Ändert die normale Farbe der Anzeigebalken."
L["Emphasized bar"] = "Betonte Balken"
L["Change the emphasized bar color."] = "Ändert die Farbe der betonten Balken."

L["Colors of messages and bars."] = "Farben der Nachrichten und Anzeigebalken."
L["Change the color for %q messages."] = "Ändert die Farbe für %q Nachrichten."
L["Change the %s color."] = "Ändert die %s Farbe."
L["Change the bar background color."] = "Ändert die Hintergrundfarbe der Anzeigebalken."
L["Change the bar text color."] = "Ändert die Textfarbe der Anzeigebalken."
L["Resets all colors to defaults."] = "Setzt alle Farben auf Standard zurück."

L["Important"] = "Wichtig"
L["Personal"] = "Persönlich"
L["Urgent"] = "Dringend"
L["Attention"] = "Achtung"
L["Positive"] = "Positiv"
L["Bosskill"] = "Boss besiegt"
L["Core"] = "Kern"

L["color_upgrade"] = "Deine Farben für Nachrichten und Balken wurden zurückgesetzt, um Probleme mit der Aktualisierung des Addons zu vermeiden. Wenn du sie ändern möchtest, rechtsklicke auf das BigWigs-Symbol und gehe zu Plugins -> Farben."

-- Messages.lua

L["Messages"] = "Nachrichten"
L["Options for message display."] = "Optionen für die Anzeige von Nachrichten."

L["BigWigs Anchor"] = "Big Wigs Verankerung"
L["Output Settings"] = "Ausgabeeinstellungen"

L["Show anchor"] = "Verankerung anzeigen"
L["Show the message anchor frame.\n\nNote that the anchor is only usable if you select 'BigWigs' as Output."] = "Die Verankerung des Nachrichtenfensters anzeigen.\n\nDie Verankerung wird nur benutzt, wenn du unter 'Ausgabe' -> 'BigWigs' auswählst."

L["Use colors"] = "Farben verwenden"
L["Toggles white only messages ignoring coloring."] = "Wählt, ob Nachrichten farbig oder weiß angezeigt werden."

L["Scale"] = "Skalierung"
L["Set the message frame scale."] = "Legt die Skalierung des Nachrichtenfensters fest."

L["Use icons"] = "Symbole benutzen"
L["Show icons next to messages, only works for Raid Warning."] = "Zeigt Symbole neben Nachrichten an."

L["Class colors"] = "Klassenfarben"
L["Colors player names in messages by their class."] = "Färbt Spielernamen in Nachrichten nach deren Klasse ein."

L["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000Fa|cffff00ffr|cff00ff00be|r"
L["White"] = "Weiß"

L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "Gibt alle Big Wigs Nachrichten im Standard-Chatfenster aus, zusätzlich zu der Einstellung von 'Ausgabe'."

L["Chat frame"] = "Chatfenster"

L["Test"] = "Test"
L["Close"] = "Schließen"

L["Reset position"] = "Position zurücksetzen"
L["Reset the anchor position, moving it to the center of your screen."] = "Setzt die Position der Verankerung zur Mitte deines Interfaces zurück."

L["Spawns a new test warning."] = "Erzeugt eine neue Testnachricht."
L["Hide"] = "Schließen"
L["Hides the anchors."] = "Versteckt die Verankerung."


-- RaidIcon.lua

L["Raid Icons"] = "Schlachtzugs-Symbole"
L["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."] = "Bestimmt, welches Symbol Big Wigs benutzen soll, wenn es Schlachzugs-Symbole auf Spielern platziert (für wichtige Boss Fähigkeiten)."

L["RaidIcon"] = "Schlachtzugs-Symbol"

L["Place"] = "Platzierung"
L["Place Raid Icons"] = "Schlachtzugs-Symbole platzieren"
L["Toggle placing of Raid Icons on players."] = "Setzt Schlachtzugs-Symbole auf Spieler."

L["Icon"] = "Symbol"
L["Set Icon"] = "Symbol platzieren"
L["Set which icon to place on players."] = "Wählt, welches Symbol auf Spieler gesetzt wird."

L["Use the %q icon when automatically placing raid icons for boss abilities."] = "Benutze das %q Symbol, wenn automatisch ein Schlachtzugs-Symbol für Boss Fähigkeiten verteilt wird."

L["Star"] = "Stern"
L["Circle"] = "Kreis"
L["Diamond"] = "Diamant"
L["Triangle"] = "Dreieck"
L["Moon"] = "Mond"
L["Square"] = "Quadrat"
L["Cross"] = "Kreuz"
L["Skull"] = "Totenkopf"

-- RaidWarn.lua
L["RaidWarning"] = "Raidwarnung"

L["Whisper"] = "Flüstern"
L["Toggle whispering warnings to players."] = "Warnungen an andere Spieler flüstern."

L["raidwarning_desc"] = "Bestimmt, wie Big Wigs die Boss-Nachrichten (zusätzlich zur lokalen Anzeige) an andere Spieler verschickt."

-- Sound.lua

L["Sounds"] = "Sounds"
L["Options for sounds."] = "Optionen für die Sounds."

L["Alarm"] = "Alarm"
L["Info"] = "Info"
L["Alert"] = "Warnung"
L["Long"] = "Lang"
L["Victory"] = "Sieg"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Legt den Sound fest, der für %q verwendet wird.\n\nStrg-Klicken, um reinzuhören."
L["Use sounds"] = "Sounds verwenden"
L["Toggle all sounds on or off."] = "Schaltet alle Sounds ein oder aus."
L["Default only"] = "Nur Standards"
L["Use only the default sound."] = "Verwendet nur die Standard-Sounds."

-- Proximity.lua

L["Proximity"] = "Nähe"
L["Close Players"] = "Nahe Spieler"
L["Options for the Proximity Display."] = "Optionen für die Anzeige naher Spieler."
L["|cff777777Nobody|r"] = "|cff777777Niemand|r"
L["Sound"] = "Sound"
L["Play sound on proximity."] = "Spielt einen Sound ab, wenn du zu nahe an einem anderen Spieler stehst."
L["Disabled"] = "Deaktivieren"
L["Disable the proximity display for all modules that use it."] = "Deaktiviert die Anzeige naher Spieler für alle Module, die sie benutzen."
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "Die Anzeige naher Spieler wird beim nächsten Mal angezeigt werden. Um sie für diesen Boss vollständig zu deaktivieren, musst du die Option 'Nähe' im Bossmodul ausschalten."
L["The proximity display has been locked, you need to right click the Big Wigs icon, go to Extras -> Proximity -> Display and toggle the Lock option if you want to move it or access the other options."] = "Die Anzeige naher Spieler wurde gesperrt. Falls du das Fenster wieder bewegen oder Zugang zu den anderen Optionen haben willst, musst du das Big Wigs Symbol rechts-klicken, zu Extras -> Nähe -> Anzeige gehen und die Option 'Sperren' ausschalten."

L.proximity = "Nähe"
L.proximity_desc = "Zeigt das Fenster für nahe Spieler an. Es listet alle Spieler auf, die dir zu nahe stehen."

L.proximityfont = "Fonts\\FRIZQT__.TTF"

L["Close"] = "Schließen"
L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = "Schließt die Anzeige naher Spieler.\n\nFalls du die Anzeige für alle Bosse deaktivieren willst, musst du die Option 'Nähe' seperat in den jeweiligen Bossmodulen ausschalten."
L["Test"] = "Test"
L["Perform a Proximity test."] = "Führt einen Test der Anzeige naher Spieler durch."
L["Display"] = "Anzeige"
L["Options for the Proximity display window."] = "Optionen für das Fenster der Anzeige naher Spieler."
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