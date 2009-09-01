local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs:Extras", "deDE")

if not L then return end


-- Custombars.lua

L["Local"] = "Lokal"
L["%s: Timer [%s] finished."] = "%s: Timer [%s] beendet."
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Ungültige Zeit (|cffff0000%q|r) oder fehlender Leistentext in eigener Leiste, gestartet von |cffd9d919%s|r. <Zeit> kann entweder eine Zahl in Sekunden, eine M:S Kombination oder Mm sein. Beispiele: 5, 1:20 or 2m."

-- Version.lua

L["should_upgrade"] = "Dies scheint eine ältere Version von Big Wigs zu sein. Es wird ein Update empfohlen, bevor du einen Kampf mit einem Boss beginnst."
L["out_of_date"] = "Die folgenden Spieler scheinen eine ältere Version zu haben: %s."
L["not_using"] = "Gruppenmitglieder, die nicht Big Wigs benutzen: %s."

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

L.font = "Fonts\\FRIZQT__.TTF"

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
--L["Sound button"] = true
--L["Shows or hides the sound button."] = true
--L["Close button"] = true
--L["Shows or hides the close button."] = true
--L["Show/hide"] = true
