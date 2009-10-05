local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "deDE")

if not L then return end

-- Bars.lua

L["Scale"] = "Skalierung"
L["Grow upwards"] = "Nach oben erweitern"
L["Toggle bars grow upwards/downwards from anchor."] = "Legt fest, ob sich die Leisten von der Verankerung aus nach oben oder unten erweitern."
L["Texture"] = "Textur"
L["Emphasize"] = "Hervorheben"
L["Enable"] = "Aktiviert"
L["Move"] = "Bewegen"
L["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = "Bewegt hervorgehobene Leisten zur Verankerung für hervorgehobene Leisten. Wenn diese Option deaktiviert ist, werden hervorgehobene Leisten nur ihre Größe und Farbe ändern und möglicherweise anfangen zu blinken."
L["Flash"] = "Blinken"
L["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = "Lässt den Hintergrund der hervorgehobenen Leisten blinken, um sie leichter zu erkennen."
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

L["Local"] = "Lokal"
L["%s: Timer [%s] finished."] = "%s: Timer [%s] beendet."
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Ungültige Zeit (|cffff0000%q|r) oder fehlender Leistentext in eigener Leiste, gestartet von |cffd9d919%s|r. <Zeit> kann entweder eine Zahl in Sekunden, eine M:S Kombination oder Mm sein. Beispiele: 5, 1:20 or 2m."

-- Colors.lua

L["Colors"] = "Farben"

L["Messages"] = "Nachrichten"
L["Bars"] = "Anzeigebalken"
L["Background"] = "Hintergrund"
L["Text"] = "Text"
L["Reset"] = "Zurücksetzen"

L["Bar"] = "Balken"
L["Change the normal bar color."] = "Ändert die normale Farbe der Anzeigebalken."
L["Emphasized bar"] = "Betonte Balken"
L["Change the emphasized bar color."] = "Ändert die Farbe der betonten Balken."

L["Colors of messages and bars."] = "Farben der Nachrichten und Anzeigebalken."
L["Change the color for %q messages."] = "Ändert die Farbe für %q Nachrichten."
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

-- Messages.lua

L.sinkDescription = "Tunnelt die Ausgabe durch die Big Wigs Nachrichtenanzeige. Diese Anzeige unterstützt Symbole, Farben und kann 4 Nachrichten gleichzeitig anzeigen. Neuere Nachrichten werden größer und schrumpfen wieder schnell, um den Nutzer darauf aufmerksam zu machen."

L["Messages"] = "Nachrichten"

L["Use colors"] = "Farben verwenden"
L["Toggles white only messages ignoring coloring."] = "Wählt, ob Nachrichten farbig oder weiß angezeigt werden."

L["Use icons"] = "Symbole benutzen"
L["Show icons next to messages, only works for Raid Warning."] = "Zeigt Symbole neben Nachrichten an."

L["Class colors"] = "Klassenfarben"
L["Colors player names in messages by their class."] = "Färbt Spielernamen in Nachrichten nach deren Klasse ein."

L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "Gibt alle Big Wigs Nachrichten im Standard-Chatfenster aus, zusätzlich zu der Einstellung von 'Ausgabe'."

-- RaidIcon.lua

L["Icons"] = "Symbole"
L["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."] = "Bestimmt, welches Symbol Big Wigs benutzen soll, wenn es Schlachtzugs-Symbole auf Spielern platziert (für wichtige Boss Fähigkeiten)."

L.raidIconDescription = "Einige Begegnungen schließen Elemente wie 'Bombe'-Fähigkeiten ein, die einen bestimmten Spieler zum Ziel haben oder ein Spieler wird verfolgt oder er ist in sonst einer Art und Weise interessant. Hier kannst du bestimmen, welche Schlachtzugs-Symbole benutzt werden sollen, um die Spieler zu markieren.\n\nFalls nur ein Symbol benötigt wird, wird nur das erste benutzt. Ein Symbol wird niemals für zwei verschiedene Fähigkeiten innerhalb einer Begegnung benutzt.\n\n|cffff4411Beachte, dass ein manuell markierter Spieler von Big Wigs nicht ummarkiert wird.|r"
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

-- RaidWarn.lua
L["RaidWarning"] = "Raidwarnung"

L["Whisper"] = "Flüstern"
L["Toggle whispering warnings to players."] = "Warnungen an andere Spieler flüstern."

L["raidwarning_desc"] = "Bestimmt, wie Big Wigs die Boss-Nachrichten (zusätzlich zur lokalen Anzeige) an andere Spieler verschickt."

-- Sound.lua

L.soundDefaultDescription = "Falls diese Option aktiviert ist, wird Big Wigs nur die Standard-Raidsounds von Blizzard für Nachrichten benutzen. Beachte, dass nicht alle Nachrichten einer Begegnung einen Sound auslösen."

L["Sounds"] = "Sounds"
L["Options for sounds."] = "Optionen für die Sounds."

L["Alarm"] = "Alarm"
L["Info"] = "Info"
L["Alert"] = "Warnung"
L["Long"] = "Lang"
L["Victory"] = "Sieg"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Legt den Sound fest, der für %q verwendet wird.\n\nStrg-Klicken, um reinzuhören."
L["Default only"] = "Nur Standards"

-- Proximity.lua

L["%d yards"] = "%d Meter"
L["Proximity"] = "Nähe"
L["Sound"] = "Sound"
L["Disabled"] = "Deaktivieren"
L["Disable the proximity display for all modules that use it."] = "Deaktiviert die Anzeige naher Spieler für alle Module, die sie benutzen."
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "Die Anzeige naher Spieler wird beim nächsten Mal angezeigt werden. Um sie für diesen Boss vollständig zu deaktivieren, musst du die Option 'Nähe' im Bossmodul ausschalten."

L.proximity = "Nähe"
L.proximity_desc = "Zeigt das Fenster für nahe Spieler an. Es listet alle Spieler auf, die dir zu nahe stehen."

L.proximityfont = "Fonts\\FRIZQT__.TTF"

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

-- Tips.lua
L["Cool!"] = "Cool!"
L["Tips"] = "Tips"
L["Configure how the raiding tips should be displayed."] = "Bestimmt, wie die Raidtips aussehen sollen."
L["Tip of the raid will show by default when you zone in to a raid instance, you are not in combat, and your raid group has more than 9 players in it. Only one tip will be shown per session, typically.\n\nHere you can tweak how to display that tip, either using the pimped out window (default), or outputting it to chat. If you play with raid leaders who overuse the |cffff4411/sendtip command|r, you might want to show them in chat frame instead!"] = "Der Tip des Tages wird normalerweise angezeigt, sobald du eine Raidinstanz betrittst, nicht im Kampf bist und dein Schlachtzug mehr als 9 Spieler hat. Nur ein Tip wird pro Sitzung angezeigt.\n\nHier kannst du einstellen, wie der Tip aussehen soll: Indem ein spezielles Fenster benutzt wird (voreingestellt) oder er in den Chat geschrieben wird. Falls du mit Schlachtzugsleitern spielst, die den |cffff4411/sendtip Befehl|r überstrapazieren, wirst du die Tips wahrscheinlich im Chatfenster unterbringen wollen!"
L["If you don't want to see any tips, ever, you can toggle them off here. Tips sent by your raid leader will also be blocked by this, so be careful."] = "Falls du keine Tips sehen möchtest, kannst du sie hier ausschalten. Tips, die von deinem Schlachtzugsleiter geschickt werden, werden ebenso geblockt, sei also vorsichtig."
L["Automatic tips"] = "Automatische Tips"
L["If you don't want to see the awesome tips we have, contributed by some of the best PvE players in the world, pop up when you zone in to a raid instance, you can disable this option."] = "Falls du wirklich keine genialen Tips von uns sehen möchtest, die von den besten PvE-Spielern er Welt beigesteuert wurden, kannst du dies hier deaktivieren."
L["Manual tips"] = "Manuelle Tips"
L["Raid leaders have the ability to show the players in the raid a manual tip with the /sendtip command. If you have a raid leader who spams these things, or for some other reason you just don't want to see them, you can disable it with this option."] = "Schlachtzugsleiter haben die Möglichkeit, den Spielern einen manuellen Tip mit dem /sendtip Befehl anzuzeigen. Falls du einen Schlachtzugsleiter hast, der diese Dinger spammt oder du willst sie aus anderen Gründen nicht mehr sehen, kannst du sie hier deaktivieren."
L["Output to chat frame"] = "Ausgabe ins Chatfenster"
L["By default the tips will be shown in their own, awesome window in the middle of your screen. If you toggle this, however, the tips will ONLY be shown in your chat frame as pure text, and the window will never bother you again."] = "Standardmäßig werden Tips in ihrem eigenen, genialen Fenster in der Bildschirmmitte angezeigt. Falls du diese Option aktivierst, werden die Tips NUR als Text in deinem Chatfenster angezeigt und das Fenster wird dich nicht weiter stören."
L["Usage: /sendtip <index|\"Custom tip\">"] = "Verwendung: /sendtip <index|\"Neuer Tip\">"
L["You must be the raid leader to broadcast a tip."] = "Du musst Schlachtzugsleiter sein, um Tips zu versenden."
L["Tip index out of bounds, accepted indexes range from 1 to %d."] = "Tip Index verboten, akzeptierte Indizes rangieren von 1 bis %d."
