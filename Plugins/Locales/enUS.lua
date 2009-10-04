local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "enUS", true)

-- Bars2.lua

L["Bars"] = true
L["Normal Bars"] = true
L["Emphasized Bars"] = true
L["Options for the timer bars."] = true
L["Toggle anchors"] = true
L["Show or hide the bar anchors for both normal and emphasized bars."] = true
L["Scale"] = true
L["Set the bar scale."] = true
L["Grow upwards"] = true
L["Toggle bars grow upwards/downwards from anchor."] = true
L["Texture"] = true
L["Set the texture for the timer bars."] = true
L["Test"] = true
L["Close"] = true
L["Emphasize"] = true
L["Emphasize bars that are close to completion (<10sec). Also note that bars started at less than 15 seconds initially will be emphasized right away."] = true
L["Enable"] = true
L["Enables emphasizing bars."] = true
L["Move"] = true
L["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = true
L["Set the scale for emphasized bars."] = true
L["Reset position"] = true
L["Reset the anchor positions, moving them to their default positions."] = true
L["Test"] = true
L["Creates a new test bar."] = true
L["Hide"] = true
L["Hides the anchors."] = true
L["Flash"] = true
L["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = true
L["Regular bars"] = true
L["Emphasized bars"] = true
L["Align"] = true
L["How to align the bar labels."] = true
L["Left"] = true
L["Center"] = true
L["Right"] = true
L["Time"] = true
L["Whether to show or hide the time left on the bars."] = true
L["Icon"] = true
L["Shows or hides the bar icons."] = true
L["Font"] = true
L["Set the font for the timer bars."] = true

L["Local"] = true
L["%s: Timer [%s] finished."] = true
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = true

-- Colors.lua

L["Colors"] = true

L["Messages"] = true
L["Bars"] = true
L["Short"] = true
L["Long"] = true
L["Short bars"] = true
L["Long bars"] = true
L["Color "] = true
L["Number of colors"] = true
L["Background"] = true
L["Text"] = true
L["Reset"] = true

L["Bar"] = true
L["Change the normal bar color."] = true
L["Emphasized bar"] = true
L["Change the emphasized bar color."] = true

L["Colors of messages and bars."] = true
L["Change the color for %q messages."] = true
L["Change the %s color."] = true
L["Change the bar background color."] = true
L["Change the bar text color."] = true
L["Resets all colors to defaults."] = true

L["Important"] = true
L["Personal"] = true
L["Urgent"] = true
L["Attention"] = true
L["Positive"] = true
L["Bosskill"] = true
L["Core"] = true

L["color_upgrade"] = "Your color values for messages and bars have been reset in order to smooth the upgrade from last version. If you want to tweak them again, right click on Big Wigs and go to Plugins -> Colors."

-- Messages.lua

L.sinkDescription = "Route output from this addon through the Big Wigs message display. This display supports icons, colors and can show up to 4 messages on the screen at a time. Newly inserted messages will grow in size and shrink again quickly to notify the user."

L["Messages"] = true
L["Options for message display."] = true

L["BigWigs Anchor"] = true
L["Output Settings"] = true

L["Show anchor"] = true
L["Show the message anchor frame.\n\nNote that the anchor is only usable if you select 'BigWigs' as Output."] = true

L["Use colors"] = true
L["Toggles white only messages ignoring coloring."] = true

L["Scale"] = true
L["Set the message frame scale."] = true

L["Use icons"] = true
L["Show icons next to messages, only works for Raid Warning."] = true

L["Class colors"] = true
L["Colors player names in messages by their class."] = true

L["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = true
L["White"] = true

L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = true

L["Chat frame"] = true

L["Test"] = true
L["Close"] = true

L["Reset position"] = true
L["Reset the anchor position, moving it to the center of your screen."] = true

L["Spawns a new test warning."] = true
L["Hide"] = true
L["Hides the anchors."] = true


-- RaidIcon.lua

L["Icons"] = true
L["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."] = true

L.raidIconDescription = "Some encounters might include elements such as bomb-type abilities targetted on a specific player, a player being chased, or a specific player might be of interest in other ways. Here you can customize which raid icons should be used to mark these players.\n\nIf an encounter only has one ability that is worth marking for, only the first icon will be used. One icon will never be used for two different abilities on the same encounter, and any given ability will always use the same icon next time.\n\n|cffff4411Note that if a player has already been marked manually, Big Wigs will never change his icon.|r"
L["Primary"] = true
L["The first raid target icon that a encounter script should use."] = true
L["Secondary"] = true
L["The second raid target icon that a encounter script should use."] = true

L["Star"] = true
L["Circle"] = true
L["Diamond"] = true
L["Triangle"] = true
L["Moon"] = true
L["Square"] = true
L["Cross"] = true
L["Skull"] = true
L["|cffff0000Disable|r"] = true

-- RaidWarn.lua
L["RaidWarning"] = true

L["Whisper"] = true
L["Toggle whispering warnings to players."] = true

L["raidwarning_desc"] = "Lets you configure where BigWigs should send its boss messages in addition to the local output."

-- Sound.lua

L.soundDefaultDescription = "With this option set, Big Wigs will only use the default Blizzard raid warning sound for messages that come with a sound alert. Note that only some messages from encounter scripts will trigger a sound alert."

L["Sounds"] = true
L["Options for sounds."] = true

L["Alarm"] = true
L["Info"] = true
L["Alert"] = true
L["Long"] = true
L["Victory"] = true

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = true
L["Default only"] = true

-- Proximity.lua

L["%d yards"] = true
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

L.proximityfont = "Fonts\\FRIZQT__.TTF"

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

-- Tips.lua
L["Cool!"] = true
L["Tips"] = true
L["Configure how the raiding tips should be displayed."] = true
L["Tip of the raid will show by default when you zone in to a raid instance, you are not in combat, and your raid group has more than 9 players in it. Only one tip will be shown per session, typically.\n\nHere you can tweak how to display that tip, either using the pimped out window (default), or outputting it to chat. If you play with raid leaders who overuse the |cffff4411/sendtip command|r, you might want to show them in chat frame instead!"] = true
L["If you don't want to see any tips, ever, you can toggle them off here. Tips sent by your raid leader will also be blocked by this, so be careful."] = true
L["Automatic tips"] = true
L["If you don't want to see the awesome tips we have, contributed by some of the best PvE players in the world, pop up when you zone in to a raid instance, you can disable this option."] = true
L["Manual tips"] = true
L["Raid leaders have the ability to show the players in the raid a manual tip with the /sendtip command. If you have a raid leader who spams these things, or for some other reason you just don't want to see them, you can disable it with this option."] = true
L["Output to chat frame"] = true
L["By default the tips will be shown in their own, awesome window in the middle of your screen. If you toggle this, however, the tips will ONLY be shown in your chat frame as pure text, and the window will never bother you again."] = true
L["Usage: /sendtip <index|\"Custom tip\">"] = true
L["You must be the raid leader to broadcast a tip."] = true
L["Tip index out of bounds, accepted indexes range from 1 to %d."] = true

