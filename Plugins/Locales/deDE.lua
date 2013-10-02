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
L.disable = "Deaktivieren"
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
L.font = "Schriftart"
L["Restart"] = "Neu starten"
L["Restarts emphasized bars so they start from the beginning and count from 10."] = "Startet die hervorgehobenen Leisten neu, so dass sie bis 10 hochzählen anstatt von 10 herunter."
L["Fill"] = "Füllen"
L["Fills the bars up instead of draining them."] = "Füllt die Leisten anstatt sie zu entleeren."

L["Local"] = "Lokal"
L["%s: Timer [%s] finished."] = "%s: Timer [%s] beendet."
L["Custom bar '%s' started by %s user %s."] = "Custombar '%s' wurde von gestartet von %s Nutzer %s."

L["Pull"] = "Pull"
L["Pulling!"] = "Pull!"
L["Pull timer started by %s user %s."] = "Pull Timer wurde von %s-User %s gestartet."
L["Pull in %d sec"] = "Pull in %d sec"
L["Sending a pull timer to Big Wigs and DBM users."] = "Sende Pull-Timer an Big Wigs und DBM Nutzer."
L["Sending custom bar '%s' to Big Wigs and DBM users."] = "Sende Custombar '%s' an Big Wigs und DBM Nutzer."
L["This function requires raid leader or raid assist."] = "Diese Funktion benötigt Schlachtzugsleiter oder -assistent."
L["Must be between 1 and 60. A correct example is: /pull 5"] = "Muss zwischen 1 und 60 sein. Beispiel: /pull 5"
L["Incorrect format. A correct example is: /raidbar 20 text"] = "Ungültiges Format. Beispiel: /raidbar 20 text"
L["Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Ungültige Zeitangabe. <time> kann eine Zahl in Sekunden, ein M:S paarung, oder Mm sein. Beispiel: 5, 1:20 or 2m."
L["This function can't be used during an encounter."] = "Diese Funktion kann während des Bosskampfes nicht genutzt werden."
L["Pull timer cancelled by %s."] = "Pull-Timer von %s abgebrochen."


-- These localization strings are translated on WoWAce: http://www.wowace.com/addons/big-wigs/localization/
--@localization(locale="deDE", namespace="Plugins", format="lua_additive_table", handle-unlocalized="ignore")@

