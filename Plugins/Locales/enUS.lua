local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "enUS", true)

-----------------------------------------------------------------------
-- Bars.lua
--

L["Style"] = true
L.bigWigsBarStyleName_Default = "Default"

L["Clickable Bars"] = true
L.clickableBarsDesc = "Big Wigs bars are click-through by default. This way you can target objects or launch targetted AoE spells behind them, change the camera angle, and so on, while your cursor is over the bars. |cffff4411If you enable clickable bars, this will no longer work.|r The bars will intercept any mouse clicks you perform on them.\n"
L["Enables bars to receive mouse clicks."] = true
L["Modifier"] = true
L["Hold down the selected modifier key to enable click actions on the timer bars."] = true
L["Only with modifier key"] = true
L["Allows bars to be click-through unless the specified modifier key is held down, at which point the mouse actions described below will be available."] = true

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = true
L["Report"] = true
L["Reports the current bars status to the active group chat; either instance chat, raid, party or say, as appropriate."] = true
L["Remove"] = true
L["Temporarily removes the bar and all associated messages."] = true
L["Remove other"] = true
L["Temporarily removes all other bars (except this one) and associated messages."] = true
L["Disable"] = true
L["Permanently disables the boss encounter ability option that spawned this bar."] = true

L["Emphasize at... (seconds)"] = true
L["Scale"] = true
L["Grow upwards"] = true
L["Toggle bars grow upwards/downwards from anchor."] = true
L["Texture"] = true
L["Emphasize"] = true
L["Enable"] = true
L["Move"] = true
L.moveDesc = "Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color."
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
L["Restart"] = true
L["Restarts emphasized bars so they start from the beginning and count from 10."] = true
L["Fill"] = true
L["Fills the bars up instead of draining them."] = true

L["Local"] = true
L["%s: Timer [%s] finished."] = true
L["Custom bar '%s' started by %s user '%s'."] = true

L["Pull"] = true
L["Pulling!"] = true
L["Pull timer started by %s user '%s'."] = true
L["Pull in %d sec"] = true
L["Sending a pull timer to Big Wigs and DBM users."] = true
L["Sending custom bar '%s' to Big Wigs and DBM users."] = true
L["This function requires raid leader or raid assist."] = true
L["Must be between 1 and 60. A correct example is: /pull 5"] = true
L["Incorrect format. A correct example is: /raidbar 20 text"] = true
L["Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = true
L["This function can't be used during an encounter."] = true

L.customBarSlashPrint = "This functionality has been renamed. Use /raidbar to send a custom bar to your raid or /localbar for a bar only you can see."

-----------------------------------------------------------------------
-- Colors.lua
--

L.Colors = "Colors"

L.Messages = "Messages"
L.Bars = "Bars"
L.Background = "Background"
L.Text = "Text"
L.TextShadow = "Text Shadow"
L.Flash = "Flash"
L.Normal = "Normal"
L.Emphasized = "Emphasized"

L.Reset = "Reset"
L["Resets the above colors to their defaults."] = true
L["Reset all"] = true
L["If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."] = true

L.Important = "Important"
L.Personal = "Personal"
L.Urgent = "Urgent"
L.Attention = "Attention"
L.Positive = "Positive"
L.Neutral = "Neutral"

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

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Route output from this addon through the Big Wigs message display. This display supports icons, colors and can show up to 4 messages on the screen at a time. Newly inserted messages will grow in size and shrink again quickly to notify the user."
L.emphasizedSinkDescription = "Route output from this addon through the Big Wigs Emphasized message display. This display supports text and colors, and can only show one message at a time."
L.emphasizedCountdownSinkDescription = "Route output from this addon through the Big Wigs Emphasized Countdown message display. This display supports text and colors, and can only show one message at a time."

L["Big Wigs Emphasized"] = true
L["Messages"] = true
L["Normal messages"] = true
L["Emphasized messages"] = true
L["Output"] = true
L["Emphasized countdown"] = true

L["Use colors"] = true
L["Toggles white only messages ignoring coloring."] = true

L["Use icons"] = true
L["Show icons next to messages, only works for Raid Warning."] = true

L["Class colors"] = true
L["Colors player names in messages by their class."] = true

L["Font size"] = true
L["None"] = true
L["Thin"] = true
L["Thick"] = true
L["Outline"] = true
L["Monochrome"] = true
L["Toggles the monochrome flag on all messages, removing any smoothing of the font edges."] = true
L["Font color"] = true

L["Display time"] = true
L["How long to display a message, in seconds"] = true
L["Fade time"] = true
L["How long to fade out a message, in seconds"] = true

-----------------------------------------------------------------------
-- Proximity.lua
--

L["Custom range indicator"] = true
L.proximityTitle = "%d yd / %d |4player:players;" -- yd = yards (short)
L["Proximity"] = true
L["Sound"] = true
L["Disabled"] = true
L["Disable the proximity display for all modules that use it."] = true
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = true
L["Sound delay"] = true
L["Specify how long Big Wigs should wait between repeating the specified sound when someone is too close to you."] = true

L.proximity = "Proximity display"
L.proximity_desc = "Show the proximity window when appropriate for this encounter, listing players who are standing too close to you."

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
L["Ability name"] = true
L["Shows or hides the ability name above the window."] = true
L["Tooltip"] = true
L["Shows or hides a spell tooltip if the Proximity display is currently tied directly to a boss encounter ability."] = true

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

L.Sounds = "Sounds"

L.Alarm = "Alarm"
L.Info = "Info"
L.Alert = "Alert"
L.Long = "Long"
L.Warning = "Warning"
L.Victory = "Victory"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = true
L["Default only"] = true

L.customSoundDesc = "Play the selected custom sound instead of the one supplied by the module"
L.resetAllCustomSound = "If you've customized sounds for any boss encounter settings, this button will reset ALL of them so the sounds defined here will be used instead."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossKillDurationPrint = "Defeated '%s' after %s."
L.bossWipeDurationPrint = "Wiped on '%s' after %s."
L.newBestKill = "New best kill!"
L.bossStatistics = "Boss Statistics"
L.bossStatsDescription = "Recording of various boss-related statistics such as the amount of times a boss had been killed, the amount of wipes, total time that combat lasted, or the fastest boss kill. These statistics can be viewed on each boss's configuration screen, but will be hidden for bosses that have no recorded statistics."
L.enableStats = "Enable Statistics"
L.chatMessages = "Chat Messages"
L.printBestKillOption = "Best Kill Notification"
L.printKillOption = "Kill Time"
L.printWipeOption = "Wipe Time"
L.countKills = "Count Kills"
L.countWipes = "Count Wipes"
L.recordBestKills = "Remember Best Kills"

