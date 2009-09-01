local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs:Plugins", "deDE")

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

L["color_upgrade"] = "Deine Farben Einstellungen für Nachrichten und Balken wurden zurückgesetzt um Probleme beim Aktualisieren von der letzten version zu vermeiden. Wenn du sie wieder ändern möchtest, rechtsklick auf Big Wigs und geh zu Plugins -> Farben."

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
