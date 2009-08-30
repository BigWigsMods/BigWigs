local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs:Extras", "enUS", true)

-- Custombars.lua

L["Local"] = true
L["%s: Timer [%s] finished."] = true
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = true

-- Version.lua
L["should_upgrade"] = "This seems to be an older version of Big Wigs. It is recommended that you upgrade before entering into combat with a boss."
L["out_of_date"] = "Players that might be running an old version: %s."
L["not_using"] = "Players that might not be using Big Wigs: %s."


-- Proximity.lua

L["Proximity"] = true
L["Close Players"] = true
L["Options for the Proximity Display."] = true
L["|cff777777Nobody|r"] = true
L["Sound"] = true
L["Play sound on proximity."] = true
L["Disabled"] = true
L["Disable the proximity display for all modules that use it."] = true
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = true
L["The proximity display has been locked, you need to right click the Big Wigs icon, go to Extras -> Proximity -> Display and toggle the Lock option if you want to move it or access the other options."] = true

L.proximity = "Proximity display"
L.proximity_desc = "Show the proximity window when appropriate for this encounter, listing players who are standing too close to you."

L.font = "Fonts\\FRIZQT__.TTF"

L["Close"] = true
L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = true
L["Test"] = true
L["Perform a Proximity test."] = true
L["Display"] = true
L["Options for the Proximity display window."] = true
L["Lock"] = true
L["Locks the display in place, preventing moving and resizing."] = true
L["Title"] = true
L["Shows or hides the title."] = true
L["Background"] = true
L["Shows or hides the background."] = true
L["Toggle sound"] = true
L["Toggle whether or not the proximity window should beep when you're too close to another player."] = true
L["Sound button"] = true
L["Shows or hides the sound button."] = true
L["Close button"] = true
L["Shows or hides the close button."] = true
L["Show/hide"] = true

