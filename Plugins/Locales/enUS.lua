local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "enUS")

L.general = "General"
L.comma = ", "

L.positionX = "X Position"
L.positionY = "Y Position"
L.positionExact = "Exact Positioning"
L.positionDesc = "Type in the box or move the slider if you need exact positioning from the anchor."
L.width = "Width"
L.height = "Height"
L.sizeDesc = "Normally you set the size by dragging the anchor. If you need an exact size you can use this slider or type the value into the box, which has no maximum."
L.fontSizeDesc = "Adjust the font size using the slider or type the value into the box which has a much higher maximum of 200."
L.disableDesc = "You are about to disable the feature '%s' which is |cffff4411not recommended|r.\n\nAre you sure you want to do this?"
L.transparency = "Transparency"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "AltPower"
L.altPowerDesc = "The AltPower display will only appear for bosses that apply AltPower to players, which is extremely rare. The display measures the amount of 'Alternative Power' you and your group has, displaying it in a list. To move the display around, please use the test button below."
L.toggleDisplayPrint = "The display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."
L.disabled = "Disabled"
L.disabledDisplayDesc = "Disable the display for all modules that use it."
L.resetAltPowerDesc = "Reset all the options related to AltPower, including the position of the AltPower anchor."
L.test = "Test"
L.altPowerTestDesc = "Show the 'Alternative Power' display, allowing you to move it, and simulating the power changes you would see on a boss encounter."
L.yourPowerBar = "Your Power Bar"
L.barColor = "Bar color"
L.barTextColor = "Bar text color"
L.additionalWidth = "Additional Width"
L.additionalHeight = "Additional Height"
L.additionalSizeDesc = "Add to the size of the standard display by adjusting this slider, or type the value into the box which has a much higher maximum of 100."
L.yourPowerTest = "Your Power: %d" -- Your Power: 42
L.yourAltPower = "Your %s: %d" -- e.g. Your Corruption: 42
L.player = "Player %d" -- Player 7
L.disableAltPowerDesc = "Globally disable the AltPower display, it will never show for any boss encounter."

-----------------------------------------------------------------------
-- AutoReply.lua
--

L.autoReply = "Auto Reply"
L.autoReplyDesc = "Automatically reply to whispers when engaged in a boss encounter."
L.responseType = "Response Type"
L.autoReplyFinalReply = "Also whisper when leaving combat"
L.guildAndFriends = "Guild & Friends"
L.everyoneElse = "Everyone else"

L.autoReplyBasic = "I'm busy in combat with a boss encounter."
L.autoReplyNormal = "I'm busy in combat with '%s'."
L.autoReplyAdvanced = "I'm busy in combat with '%s' (%s) and %d/%d people are alive."
L.autoReplyExtreme = "I'm busy in combat with '%s' (%s) and %d/%d people are alive: %s"

L.autoReplyLeftCombatBasic = "I am no longer in combat with a boss encounter."
L.autoReplyLeftCombatNormalWin = "I won against '%s'."
L.autoReplyLeftCombatNormalWipe = "I lost against '%s'."
L.autoReplyLeftCombatAdvancedWin = "I won against '%s' with %d/%d people alive."
L.autoReplyLeftCombatAdvancedWipe = "I lost against '%s' at: %s"

-----------------------------------------------------------------------
-- Bars.lua
--

L.bars = "Bars"
L.style = "Style"
L.bigWigsBarStyleName_Default = "Default"
L.resetBarsDesc = "Reset all the options related to bars, including the position of the bar anchors."

L.nameplateBars = "Nameplate Bars"
L.nameplateAutoWidth = "Match width of nameplate"
L.nameplateAutoWidthDesc = "Sets the width of nameplate bars to the with of their parent nameplate."
L.nameplateOffsetY = "Y Offset"
L.nameplateOffsetYDesc = "Offset from the top of the nameplate for upwards bars and the bottom of the nameplate for downwards bars."
L.nameplateAlphaDesc = "Control how transparent the nameplate bars should be."

L.clickableBars = "Clickable Bars"
L.clickableBarsDesc = "BigWigs bars are click-through by default. This way you can target objects or launch targetted AoE spells behind them, change the camera angle, and so on, while your cursor is over the bars. |cffff4411If you enable clickable bars, this will no longer work.|r The bars will intercept any mouse clicks you perform on them.\n"
L.interceptMouseDesc = "Enables bars to receive mouse clicks."
L.modifier = "Modifier"
L.modifierDesc = "Hold down the selected modifier key to enable click actions on the timer bars."
L.modifierKey = "Only with modifier key"
L.modifierKeyDesc = "Allows bars to be click-through unless the specified modifier key is held down, at which point the mouse actions described below will be available."

L.temporaryCountdownDesc = "Temporarily enable countdown on the ability associated with this bar."
L.report = "Report"
L.reportDesc = "Reports the current bars status to the active group chat; either instance chat, raid, party or say, as appropriate."
L.remove = "Remove"
L.removeBarDesc = "Temporarily removes this bar."
L.removeOther = "Remove other"
L.removeOtherBarDesc = "Temporarily removes all other bars (except this one)."

L.emphasizeAt = "Emphasize at... (seconds)"
L.growingUpwards = "Grow upwards"
L.growingUpwardsDesc = "Toggle growing upwards or downwards from the anchor."
L.texture = "Texture"
L.emphasize = "Emphasize"
L.emphasizeMultiplier = "Size Multiplier"
L.emphasizeMultiplierDesc = "If you disable the bars moving to the emphasize anchor, this option will decide what size the emphasized bars will be by multiplying the size of the normal bars."

L.enable = "Enable"
L.move = "Move"
L.moveDesc = "Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change size and color."
L.emphasizedBars = "Emphasized bars"
L.align = "Align"
L.alignText = "Align Text"
L.alignTime = "Align Time"
L.left = "Left"
L.center = "Center"
L.right = "Right"
L.time = "Time"
L.timeDesc = "Whether to show or hide the time left on the bars."
L.textDesc = "Whether to show or hide the text displayed on the bars."
L.icon = "Icon"
L.iconDesc = "Shows or hides the bar icons."
L.iconPosition = "Icon Position"
L.iconPositionDesc = "Choose where on the bar the icon should be positioned."
L.font = "Font"
L.restart = "Restart"
L.restartDesc = "Restarts emphasized bars so they start from the beginning and count from 10."
L.fill = "Fill"
L.fillDesc = "Fills the bars up instead of draining them."
L.spacing = "Spacing"
L.spacingDesc = "Change the space between each bar."
L.visibleBarLimit = "Visible bar limit"
L.visibleBarLimitDesc = "Set the maximum amount of bars that are visible at the same time."

L.localTimer = "Local"
L.timerFinished = "%s: Timer [%s] finished."
L.customBarStarted = "Custom bar '%s' started by %s user %s."
L.sendCustomBar = "Sending custom bar '%s' to BigWigs and DBM users."

L.requiresLeadOrAssist = "This function requires raid leader or raid assist."
L.encounterRestricted = "This function can't be used during an encounter."
L.wrongCustomBarFormat = "Incorrect format. A correct example is: /raidbar 20 text"
L.wrongTime = "Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."

L.wrongBreakFormat = "Must be between 1 and 60 minutes. A correct example is: /break 5"
L.sendBreak = "Sending a break timer to BigWigs and DBM users."
L.breakStarted = "Break timer started by %s user %s."
L.breakStopped = "Break timer cancelled by %s."
L.breakBar = "Break time"
L.breakMinutes = "Break ends in %d |4minute:minutes;!"
L.breakSeconds = "Break ends in %d |4second:seconds;!"
L.breakFinished = "Break time is now over!"

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.bossBlock = "Boss Block"
L.bossBlockDesc = "Configure the various things you can block during a boss encounter.\n\n"
L.bossBlockAudioDesc = "Configure what audio to mute during a boss encounter.\n\nAny option here that is |cff808080greyed out|r has been disabled in WoW's sound options.\n\n"
L.movieBlocked = "You've seen this movie before, skipping it."
L.blockEmotes = "Block middle-screen emotes"
L.blockEmotesDesc = "Some bosses show emotes for certain abilities, these messages are both way too long and descriptive. We try to produce smaller, more fitting messages that do not interfere with the gameplay, and don't tell you specifically what to do.\n\nPlease note: Boss emotes will still be visible in chat if you wish to read them."
L.blockMovies = "Block repeated movies"
L.blockMoviesDesc = "Boss encounter movies will only be allowed to play once (so you can watch each one) and will then be blocked."
L.blockFollowerMission = "Block follower mission popups"
L.blockFollowerMissionDesc = "Follower mission popups show for a few things, but mainly when a follower mission is completed.\n\nThese popups can cover up critical parts of your UI during a boss fight, so we recommend blocking them."
L.blockGuildChallenge = "Block guild challenge popups"
L.blockGuildChallengeDesc = "Guild challenge popups show for a few things, mainly when a group in your guild completes a heroic dungeon or a challenge mode dungeon.\n\nThese popups can cover up critical parts of your UI during a boss fight, so we recommend blocking them."
L.blockSpellErrors = "Block spell failed messages"
L.blockSpellErrorsDesc = "Messages such as \"Spell is not ready yet\" that usually show at the top of the screen will be blocked."
L.audio = "Audio"
L.music = "Music"
L.ambience = "Ambient Sounds"
L.sfx = "Sound Effects"
L.errorSpeech = "Error Speech"
L.disableMusic = "Mute music (recommended)"
L.disableAmbience = "Mute ambient sounds (recommended)"
L.disableSfx = "Mute sound effects (not recommended)"
L.disableErrorSpeech = "Mute error speech (recommended)"
L.disableAudioDesc = "The '%s' option in WoW's sound options will be turned off, then turned back on when the boss encounter is over. This can help you focus on warning sounds from BigWigs."
L.blockTooltipQuests = "Block tooltip quest objectives"
L.blockTooltipQuestsDesc = "When you need to kill a boss for a quest, it will usually show as '0/1 complete' in the tooltip when you place your mouse over the boss. This will be hidden whilst in combat with that boss to prevent the tooltip growing very large."
L.blockObjectiveTracker = "Hide quest tracker"
L.blockObjectiveTrackerDesc = "The quest objective tracker will be hidden during a boss encounter to clear up screen space.\n\nThis will NOT happen if you are in a mythic+ or are tracking an achievement."

L.blockTalkingHead = "Hide 'Talking Head' NPC dialog popup"
L.blockTalkingHeadDesc = "The 'Talking Head' is a popup dialog box that has an NPC head and NPC chat text at the middle-bottom of your screen that |cffff4411sometimes|r shows when an NPC is talking.\n\nYou can choose the different types of instances where this should be blocked from showing.\n\n|cFF33FF99Please Note:|r\n 1) This feature will allow the NPC voice to continue playing so you can still hear it.\n 2) For safety, only specific talking heads will be blocked. Anything special or unique, such as a one-time quest, will not be blocked."
L.blockTalkingHeadDungeons = "Normal & Heroic Dungeons"
L.blockTalkingHeadMythics = "Mythic & Mythic+ Dungeons"
L.blockTalkingHeadRaids = "Raids"
L.blockTalkingHeadTimewalking = "Timewalking (Dungeons & Raids)"
L.blockTalkingHeadScenarios = "Scenarios"

L.userNotifySfx = "Sound Effects were disabled by BossBlock, forcing it back on."
L.userNotifyMusic = "Music was disabled by BossBlock, forcing it back on."
L.userNotifyAmbience = "Ambience was disabled by BossBlock, forcing it back on."
L.userNotifyErrorSpeech = "Error speech was disabled by BossBlock, forcing it back on."

L.subzone_grand_bazaar = "Grand Bazaar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "Port of Zandalar" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "Eastern Transept" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "Colors"

L.text = "Text"
L.textShadow = "Text Shadow"
L.flash = "Flash"
L.normal = "Normal"
L.emphasized = "Emphasized"

L.reset = "Reset"
L.resetDesc = "Resets the above colors to their defaults."
L.resetAll = "Reset all"
L.resetAllDesc = "If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."

L.red = "Red"
L.redDesc = "General encounter warnings."
L.blue = "Blue"
L.blueDesc = "Warnings for things that affect you directly such as a debuff being applied to you."
L.orange = "Orange"
L.yellow = "Yellow"
L.green = "Green"
L.greenDesc = "Warnings for good things that happen such as a debuff being removed from you."
L.cyan = "Cyan"
L.cyanDesc = "Warnings for encounter status changes such as advancing to the next stage."
L.purple = "Purple"
L.purpleDesc = "Warnings for tank specific abilities such as stacks of a tank debuff."

-----------------------------------------------------------------------
-- Countdown.lua
--

L.textCountdown = "Text countdown"
L.textCountdownDesc = "Show a visual counter during a count down."
L.countdownColor = "Countdown color"
L.countdownVoice = "Countdown voice"
L.countdownTest = "Test countdown"
L.countdownAt = "Countdown at... (seconds)"
L.countdownAt_desc = "Choose how much time should be remaining on a boss ability (in seconds) when the countdown begins."
L.countdown = "Countdown"
L.countdownDesc = "The countdown feature involves a spoken audio countdown and a visual text countdown. It is rarely enabled by default, but you can enable it for any boss ability when looking at the specific boss encounter settings."
L.countdownAudioHeader = "Spoken Audio Countdown"
L.countdownTextHeader = "Visual Text Countdown"
L.resetCountdownDesc = "Resets all the above countdown settings to their defaults."
L.resetAllCountdownDesc = "If you've selected custom countdown voices for any boss encounter settings, this button will reset ALL of them as well as resetting all the above countdown settings to their defaults."

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infoBox = "InfoBox"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Route output from this addon through the BigWigs message display. This display supports icons, colors and can show up to 4 messages on the screen at a time. Newly inserted messages will grow in size and shrink again quickly to notify the user."
L.emphasizedSinkDescription = "Route output from this addon through the BigWigs Emphasized message display. This display supports text and colors, and can only show one message at a time."
L.resetMessagesDesc = "Reset all the options related to messages, including the position of the message anchors."

L.bwEmphasized = "BigWigs Emphasized"
L.messages = "Messages"
L.emphasizedMessages = "Emphasized messages"
L.emphasizedDesc = "The point of an emphasized message is to get your attention by being a large message in the middle of your screen. It is rarely enabled by default, but you can enable it for any boss ability when looking at the specific boss encounter settings."
L.uppercase = "UPPERCASE"
L.uppercaseDesc = "All emphasized messages will be converted to UPPERCASE."

L.useIcons = "Use icons"
L.useIconsDesc = "Show icons next to messages."
L.classColors = "Class colors"
L.classColorsDesc = "Messages will sometimes contain player names. Enabling this option will color those names using class colors."
L.chatFrameMessages = "Chat frame messages"
L.chatFrameMessagesDesc = "Outputs all BigWigs messages to the default chat frame in addition to the display setting."

L.fontSize = "Font size"
L.none = "None"
L.thin = "Thin"
L.thick = "Thick"
L.outline = "Outline"
L.monochrome = "Monochrome"
L.monochromeDesc = "Toggles the monochrome flag, removing any smoothing of the font edges."
L.fontColor = "Font color"

L.displayTime = "Display time"
L.displayTimeDesc = "How long to display a message, in seconds"
L.fadeTime = "Fade time"
L.fadeTimeDesc = "How long to fade out a message, in seconds"

-----------------------------------------------------------------------
-- Proximity.lua
--

L.customRange = "Custom range indicator"
L.proximityTitle = "%d yd / %d |4player:players;" -- yd = yards (short)
L.proximity_name = "Proximity"
L.soundDelay = "Sound delay"
L.soundDelayDesc = "Specify how long BigWigs should wait between repeating the specified sound when someone is too close to you."

L.resetProximityDesc = "Reset all the options related to proximity, including the position of the proximity anchor."

L.close = "Close"
L.closeProximityDesc = "Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."
L.lock = "Lock"
L.lockDesc = "Locks the display in place, preventing moving and resizing."
L.title = "Title"
L.titleDesc = "Shows or hides the title."
L.background = "Background"
L.backgroundDesc = "Shows or hides the background."
L.toggleSound = "Toggle sound"
L.toggleSoundDesc = "Toggle whether or not the proximity window should beep when you're too close to another player."
L.soundButton = "Sound button"
L.soundButtonDesc = "Shows or hides the sound button."
L.closeButton = "Close button"
L.closeButtonDesc = "Shows or hides the close button."
L.showHide = "Show/hide"
L.abilityName = "Ability name"
L.abilityNameDesc = "Shows or hides the ability name above the window."
L.tooltip = "Tooltip"
L.tooltipDesc = "Shows or hides a spell tooltip if the Proximity display is currently tied directly to a boss encounter ability."

-----------------------------------------------------------------------
-- Pull.lua
--

L.countdownType = "Countdown Type"
L.combatLog = "Automatic Combat Logging"
L.combatLogDesc = "Automatically start logging combat when a pull timer is started and end it when the encounter ends."

L.pull = "Pull"
L.engageSoundTitle = "Play a sound when a boss encounter has started"
L.pullStartedSoundTitle = "Play a sound when the pull timer is started"
L.pullFinishedSoundTitle = "Play a sound when the pull timer is finished"
L.pullStarted = "Pull timer started by %s user %s."
L.pullStopped = "Pull timer cancelled by %s."
L.pullStoppedCombat = "Pull timer cancelled because you entered combat."
L.pullIn = "Pull in %d sec"
L.sendPull = "Sending a pull timer to BigWigs and DBM users."
L.wrongPullFormat = "Must be between 1 and 60 seconds. A correct example is: /pull 5"
L.countdownBegins = "Begin Countdown"
L.countdownBegins_desc = "Choose how much time should be remaining on the pull timer (in seconds) when the countdown begins."

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L.icons = "Icons"
L.raidIconsDescription = "Some encounters might include elements such as bomb-type abilities targetted on a specific player, a player being chased, or a specific player might be of interest in other ways. Here you can customize which raid icons should be used to mark these players.\n\nIf an encounter only has one ability that is worth marking for, only the first icon will be used. One icon will never be used for two different abilities on the same encounter, and any given ability will always use the same icon next time.\n\n|cffff4411Note that if a player has already been marked manually, BigWigs will never change their icon.|r"
L.primary = "Primary"
L.primaryDesc = "The first raid target icon that a encounter script should use."
L.secondary = "Secondary"
L.secondaryDesc = "The second raid target icon that a encounter script should use."

-----------------------------------------------------------------------
-- Sound.lua
--

L.Sounds = "Sounds"
L.soundsDesc = "BigWigs uses the 'Master' sound channel to play all of its sounds. If you find that sounds are too quiet or too loud, open WoW's sound settings and adjust the 'Master Volume' slider to a level you like.\n\nBelow you can globally configure the different sounds that play for specific actions, or set them to 'None' to disable them. If you only want to change a sound for a specific boss ability, that can be done at the boss encounter settings.\n\n"
L.oldSounds = "Old Sounds"

L.Alarm = "Alarm"
L.Info = "Info"
L.Alert = "Alert"
L.Long = "Long"
L.Warning = "Warning"
L.onyou = "A spell, buff, or debuff is on you"
L.underyou = "You need to move out of a spell under you"

L.sound = "Sound"

L.customSoundDesc = "Play the selected custom sound instead of the one supplied by the module."
L.resetSoundDesc = "Resets the above sounds to their defaults."
L.resetAllCustomSound = "If you've customized sounds for any boss encounter settings, this button will reset ALL of them so the sounds defined here will be used instead."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossDefeatDurationPrint = "Defeated '%s' after %s."
L.bossWipeDurationPrint = "Wiped on '%s' after %s."
L.newBestTime = "New best time!"
L.bossStatistics = "Boss Statistics"
L.bossStatsDescription = "Recording of various boss-related statistics such as the amount of times a boss had been killed, the amount of wipes, total time that combat lasted, or the fastest boss kill. These statistics can be viewed on each boss's configuration screen, but will be hidden for bosses that have no recorded statistics."
L.enableStats = "Enable Statistics"
L.chatMessages = "Chat Messages"
L.printBestTimeOption = "Best Time Notification"
L.printDefeatOption = "Defeat Time"
L.printWipeOption = "Wipe Time"
L.countDefeats = "Count Defeats"
L.countWipes = "Count Wipes"
L.recordBestTime = "Remember Best Time"
L.createTimeBar = "Show 'Best Time' bar"
L.bestTimeBar = "Best Time"
L.printHealthOption = "Boss Health"
L.healthPrint = "Health: %s."
L.healthFormat = "%s (%.1f%%)"

-----------------------------------------------------------------------
-- Victory.lua
--

L.Victory = "Victory"
L.victoryHeader = "Configure the actions that should be taken after you defeat a boss encounter."
L.victorySound = "Play a victory sound"
L.victoryMessages = "Show boss defeat messages"
L.victoryMessageBigWigs = "Show the BigWigs message"
L.victoryMessageBigWigsDesc = "The BigWigs message is a simple \"boss has been defeated\" message."
L.victoryMessageBlizzard = "Show the Blizzard message"
L.victoryMessageBlizzardDesc = "The Blizzard message is a very large \"boss has been defeated\" animation in the middle of your screen."
L.defeated = "%s has been defeated"

-----------------------------------------------------------------------
-- Wipe.lua
--

L.wipe = "Wipe"
L.wipeSoundTitle = "Play a sound when you wipe"
L.respawn = "Respawn"
L.showRespawnBar = "Show respawn bar"
L.showRespawnBarDesc = "Show a bar after you wipe on a boss displaying the time until the boss respawns."
