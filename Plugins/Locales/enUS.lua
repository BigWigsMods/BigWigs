local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "enUS", true)

-----------------------------------------------------------------------
-- Bars.lua
--

L["Clickable Bars"] = true
L.clickableBarsDesc = "Big Wigs bars are click-through by default. This way you can target objects or launch targetted AoE spells behind them, change the camera angle, and so on, while your cursor is over the bars. |cffff4411If you enable clickable bars, this will no longer work.|r The bars will intercept any mouse clicks you perform on them.\n"
L["Enables bars to receive mouse clicks."] = true

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = true
L["Report"] = true
L["Reports the current bars status to the active group chat; either battleground, raid, party or guild, as appropriate."] = true
L["Remove"] = true
L["Temporarily removes the bar and all associated messages."] = true
L["Remove other"] = true
L["Temporarily removes all other bars (except this one) and associated messages."] = true
L["Disable"] = true
L["Permanently disables the boss encounter ability option that spawned this bar."] = true

L["Scale"] = true
L["Grow upwards"] = true
L["Toggle bars grow upwards/downwards from anchor."] = true
L["Texture"] = true
L["Emphasize"] = true
L["Enable"] = true
L["Move"] = true
L["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = true
L["Flash"] = true
L["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = true
L["Regular bars"] = true
L["Emphasized bars"] = true
L["Align"] = true
L["Left"] = true
L["Center"] = true
L["Right"] = true
L["Time"] = true
L["Whether to show or hide the time left on the bars."] = true
L["Icon"] = true
L["Shows or hides the bar icons."] = true
L["Font"] = true

L["Local"] = true
L["%s: Timer [%s] finished."] = true
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = true

-----------------------------------------------------------------------
-- Colors.lua
--

L["Colors"] = true

L["Messages"] = true
L["Bars"] = true
L["Background"] = true
L["Text"] = true
L["Flash and shake"] = true
L["Normal"] = true
L["Emphasized"] = true

L["Reset"] = true
L["Resets the above colors to their defaults."] = true
L["Reset all"] = true
L["If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."] = true

L["Important"] = true
L["Personal"] = true
L["Urgent"] = true
L["Attention"] = true
L["Positive"] = true

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Route output from this addon through the Big Wigs message display. This display supports icons, colors and can show up to 4 messages on the screen at a time. Newly inserted messages will grow in size and shrink again quickly to notify the user."
L.emphasizedSinkDescription = "Route output from this addon through the Big Wigs Emphasized message display. This display supports text and colors, and can only show one message at a time."

L["Messages"] = true
L["Normal messages"] = true
L["Emphasized messages"] = true
L["Output"] = true

L["Use colors"] = true
L["Toggles white only messages ignoring coloring."] = true

L["Use icons"] = true
L["Show icons next to messages, only works for Raid Warning."] = true

L["Class colors"] = true
L["Colors player names in messages by their class."] = true

L["Chat frame"] = true
L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = true

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L["Icons"] = true

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

-----------------------------------------------------------------------
-- Sound.lua
--

L.soundDefaultDescription = "With this option set, Big Wigs will only use the default Blizzard raid warning sound for messages that come with a sound alert. Note that only some messages from encounter scripts will trigger a sound alert."

L["Sounds"] = true

L["Alarm"] = true
L["Info"] = true
L["Alert"] = true
L["Long"] = true
L["Victory"] = true

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = true
L["Default only"] = true

-----------------------------------------------------------------------
-- Proximity.lua
--

L["%d yards"] = true
L["Proximity"] = true
L["Sound"] = true
L["Disabled"] = true
L["Disable the proximity display for all modules that use it."] = true
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = true

L.proximity = "Proximity display"
L.proximity_desc = "Show the proximity window when appropriate for this encounter, listing players who are standing too close to you."
L.proximityfont = "Fonts\\FRIZQT__.TTF"

L["Close"] = true
L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = true
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

-----------------------------------------------------------------------
-- Tips.lua
--

L["|cff%s%s|r says:"] = true
L["Cool!"] = true
L["Tips"] = true
L["Tip of the Raid"] = true
L["Tip of the raid will show by default when you zone in to a raid instance, you are not in combat, and your raid group has more than 9 players in it. Only one tip will be shown per session, typically.\n\nHere you can tweak how to display that tip, either using the pimped out window (default), or outputting it to chat. If you play with officers who overuse the |cffff4411/sendtip command|r, you might want to show them in chat frame instead!"] = true
L["If you don't want to see any tips, ever, you can toggle them off here. Tips sent by your raid officers will also be blocked by this, so be careful."] = true
L["Automatic tips"] = true
L["If you don't want to see the awesome tips we have, contributed by some of the best PvE players in the world, pop up when you zone in to a raid instance, you can disable this option."] = true
L["Manual tips"] = true
L["Raid officers have the ability to show manual tips with the /sendtip command. If you have an officer who spams these things, or for some other reason you just don't want to see them, you can disable it with this option."] = true
L["Output to chat frame"] = true
L["By default the tips will be shown in their own, awesome window in the middle of your screen. If you toggle this, however, the tips will ONLY be shown in your chat frame as pure text, and the window will never bother you again."] = true
L["Usage: /sendtip <index|\"Custom tip\">"] = true
L["You must be an officer in the raid to broadcast a tip."] = true
L["Tip index out of bounds, accepted indexes range from 1 to %d."] = true

-----------------------------------------------------------------------
-- Emphasize.lua
--

L["Super Emphasize"] = true
L.superEmphasizeDesc = "Boosts related messages or bars of a specific boss encounter ability.\n\nHere you configure exactly what should happen when you toggle on the Super Emphasize option in the advanced section for a boss encounter ability.\n\n|cffff4411Note that Super Emphasize is off by default for all abilities.|r\n"
L["UPPERCASE"] = true
L["Uppercases all messages related to a super emphasized option."] = true
L["Double size"] = true
L["Doubles the size of super emphasized bars and messages."] = true
L["Countdown"] = true
L["If a related timer is longer than 5 seconds, a vocal and visual countdown will be added for the last 5 seconds. Imagine someone counting down \"5... 4... 3... 2... 1... COUNTDOWN!\" and big numbers in the middle of your screen."] = true
L["Flash"] = true
L["Flashes the screen red during the last 3 seconds of any related timer."] = true
