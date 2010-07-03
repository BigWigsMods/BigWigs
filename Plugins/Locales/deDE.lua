local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "deDE")

if not L then return end

-----------------------------------------------------------------------
-- Bars.lua
--

L["Clickable Bars"] = "Interaktive Leisten"
L.clickableBarsDesc = "Big Wigs Leisten sind standardmäßig nicht anklickbar. Dies ermöglicht es, das Ziel zu wechseln, AoE-Zauber zu setzen und die Kameraperspektive zu ändern, während sich die Maus über den Leisten befindet. |cffff4411Die Aktivierung der Interaktiven Leisten verhindert dieses Verhalten.|r Die Leisten werden jeden Mausklick abfangen, oben beschriebene Aktionen können dann nur noch außerhalb der Leistenanzeige ausgeführt werden.\n"
L["Enables bars to receive mouse clicks."] = "Aktiviert die Interaktiven Leisten."

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = "Hebt zeitweilig Leisten und zugehörige Nachrichten stark hervor."
L["Report"] = "Berichten"
L["Reports the current bars status to the active group chat; either battleground, raid, party or guild, as appropriate."] = "Gibt den aktuellen Status der Leiste in den aktiven Chat aus: Entweder Schlachtzugs-, Schlachtfeld-, Gruppen- oder Gildenchat."
L["Remove"] = "Entfernen"
L["Temporarily removes the bar and all associated messages."] = "Entfernt zeitweilig die Leiste und alle zugehörigen Nachrichten aus der Anzeige."
L["Remove other"] = "Andere entfernen"
L["Temporarily removes all other bars (except this one) and associated messages."] = "Entfernt zeitweilig alle anderen Leisten (außer der Angeklickten) und zugehörigen Nachrichten aus der Anzeige."
L["Disable"] = "Deaktivieren"
L["Permanently disables the boss encounter ability option that spawned this bar."] = "Deaktiviert die Option, die diese Leiste erzeugt hat, zukünftig permanent."

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

-----------------------------------------------------------------------
-- Colors.lua
--

L["Colors"] = "Farben"

L["Messages"] = "Nachrichten"
L["Bars"] = "Leisten"
L["Background"] = "Hintergrund"
L["Text"] = "Text"
L["Flash and shake"] = "Flash'n'shake"
L["Normal"] = "Normal"
L["Emphasized"] = "Hervorgehoben"

L["Reset"] = "Zurücksetzen"
L["Resets the above colors to their defaults."] = "Setzt die obenstehenden Farben auf ihre Ausgangswerte zurück."
L["Reset all"] = "Alle zurücksetzen"
L["If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."] = "Falls du veränderte Farbeinstellungen für Bosse benutzt, wird dieser Button ALLE zurücksetzen, so dass erneut die hier festgelegten Farben verwendet werden."

L["Important"] = "Wichtig"
L["Personal"] = "Persönlich"
L["Urgent"] = "Dringend"
L["Attention"] = "Achtung"
L["Positive"] = "Positiv"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Tunnelt die Big Wigs Ausgabe durch die normale Big Wigs Nachrichtenanzeige. Diese Anzeige unterstützt Symbole, Farben und kann 4 Nachrichten gleichzeitig anzeigen. Neuere Nachrichten werden größer und schrumpfen dann wieder schnell, um die Aufmerksamkeit dementsprechend zu lenken."
L.emphasizedSinkDescription = "Tunnelt die Big Wigs Ausgabe durch Big Wigs 'stark hervorgehobene' Nachrichtenanzeige. Diese Anzeige unterstützt Text und Farbe und kann nur eine Nachricht gleichzeitig anzeigen."

L["Messages"] = "Nachrichten"
L["Normal messages"] = "Normale Nachrichten"
L["Emphasized messages"] = "Hervorgehobene Nachrichten"
L["Output"] = "Ausgabe"

L["Use colors"] = "Farben verwenden"
L["Toggles white only messages ignoring coloring."] = "Wählt, ob Nachrichten farbig oder weiß angezeigt werden."

L["Use icons"] = "Symbole benutzen"
L["Show icons next to messages, only works for Raid Warning."] = "Zeigt Symbole neben Nachrichten an."

L["Class colors"] = "Klassenfarben"
L["Colors player names in messages by their class."] = "Färbt Spielernamen in Nachrichten nach deren Klasse ein."

L["Chat frame"] = "Chatfenster"
L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "Gibt alle Big Wigs Nachrichten im Standard-Chatfenster aus, zusätzlich zu der Einstellung unter 'Ausgabe'."

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

L["Sounds"] = "Sounds" 

L["Alarm"] = "Alarm"
L["Info"] = "Info"
L["Alert"] = "Warnung"
L["Long"] = "Lang"
L["Victory"] = "Sieg"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "Legt den Sound fest, der für %q verwendet wird.\n\nStrg-Klicken, um reinzuhören."
L["Default only"] = "Nur Standards"

-----------------------------------------------------------------------
-- Proximity.lua
--

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

-----------------------------------------------------------------------
-- Tips.lua
--

L["|cff%s%s|r says:"] = "|cff%s%s|r sagt:"
L["Cool!"] = "Cool!"
L["Tips"] = "Tips"
L["Tip of the Raid"] = "Tip des Tages"
L["Tip of the raid will show by default when you zone in to a raid instance, you are not in combat, and your raid group has more than 9 players in it. Only one tip will be shown per session, typically.\n\nHere you can tweak how to display that tip, either using the pimped out window (default), or outputting it to chat. If you play with officers who overuse the |cffff4411/sendtip command|r, you might want to show them in chat frame instead!"] = "Der Tip des Tages wird normalerweise angezeigt, sobald du eine Raidinstanz betrittst, nicht im Kampf bist und dein Schlachtzug mehr als 9 Spieler hat. Nur ein Tip wird pro Sitzung angezeigt.\n\nHier kannst du einstellen, wie der Tip aussehen soll: Indem ein spezielles Fenster benutzt wird (voreingestellt) oder er in den Chat geschrieben wird. Falls du mit Schlachtzugsleitern spielst, die den |cffff4411/sendtip Befehl|r überstrapazieren, wirst du die Tips wahrscheinlich im Chatfenster unterbringen wollen!"
L["If you don't want to see any tips, ever, you can toggle them off here. Tips sent by your raid officers will also be blocked by this, so be careful."] = "Falls du keine Tips sehen möchtest, kannst du sie hier ausschalten. Tips, die von deinen Schlachtzugsleitern geschickt werden, werden ebenso geblockt, sei also vorsichtig."
L["Automatic tips"] = "Automatische Tips"
L["If you don't want to see the awesome tips we have, contributed by some of the best PvE players in the world, pop up when you zone in to a raid instance, you can disable this option."] = "Falls du wirklich keine der genialen Tips sehen möchtest, die von den weltweit besten PvE-Spielern beigesteuert wurden, kannst du die Funktion hier deaktivieren."
L["Manual tips"] = "Manuelle Tips"
L["Raid officers have the ability to show manual tips with the /sendtip command. If you have an officer who spams these things, or for some other reason you just don't want to see them, you can disable it with this option."] = "Schlachtzugsleiter haben die Möglichkeit, den Spielern einen manuellen Tip via /sendtip anzuzeigen. Falls du Schlachtzugsleiter hast, der die Dinger spammen oder du sie aus anderen Gründen nicht mehr sehen willst, kannst du die Funktion hier deaktivieren."
L["Output to chat frame"] = "Ausgabe ins Chatfenster"
L["By default the tips will be shown in their own, awesome window in the middle of your screen. If you toggle this, however, the tips will ONLY be shown in your chat frame as pure text, and the window will never bother you again."] = "Standardmäßig werden Tips in einem eigenen, genialen Fenster in der Bildschirmmitte angezeigt. Falls du diese Option aktivierst, werden die Tips NUR als Text in deinem Chatfenster angezeigt."
L["Usage: /sendtip <index|\"Custom tip\">"] = "Verwendung: /sendtip <index|\"Neuer Tip\">"
L["You must be an officer in the raid to broadcast a tip."] = "Du musst mindestens Assistent sein, um Tips zu versenden."
L["Tip index out of bounds, accepted indexes range from 1 to %d."] = "Tip Index verboten, akzeptierte Indizes rangieren von 1 bis %d."

-----------------------------------------------------------------------
-- Emphasize.lua
--

L["Super Emphasize"] = "Stark hervorheben"
L.superEmphasizeDesc = "Verstärkt zugehörige Nachrichten oder Leisten einer bestimmten Begegnung.\n\nHier kannst du genau bestimmen, was passieren soll, wenn du in den erweiterten Optionen einer Bossfähigkeit 'Stark hervorheben' aktivierst.\n\n|cffff4411Beachte, dass 'Stark hervorheben' standardmäßig für alle Fähigkeiten deaktiviert ist.|r\n"
L["UPPERCASE"] = "GROßBUCHSTABEN"
L["Uppercases all messages related to a super emphasized option."] = "Schreibt alle Nachrichten in Großbuchstaben, die die zugehörige 'Stark hervorheben'-Option aktiviert haben."
L["Double size"] = "Doppelte Größe"
L["Doubles the size of super emphasized bars and messages."] = "Verdoppelt die Größe von 'Stark hervorgehobenen' Leisten und Nachrichten."
L["Countdown"] = "Countdown"
L["If a related timer is longer than 5 seconds, a vocal and visual countdown will be added for the last 5 seconds. Imagine someone counting down \"5... 4... 3... 2... 1... COUNTDOWN!\" and big numbers in the middle of your screen."] = "Falls ein zugehöriger Timer länger als 5 Sekunden dauert, wird ein visueller und auditiver Countdown die letzten 5 Sekunden begleiten. Stell dir vor, jemand würde \"5... 4... 3... 2... 1... COUNTDOWN!\" herunterzählen und große Nummern in die Mitte des Bildschirm setzen."
L["Flash"] = "Aufblitzen"
L["Flashes the screen red during the last 3 seconds of any related timer."] = "Lässt den Bildschirm während der letzten 3 Sekunden eines zugehörigen Timers rot aufblitzen."
