local _, addonTbl = ...
local L = addonTbl.API:NewLocale("BigWigs", "enUS")

-- API.lua
L.showAddonBar = "The addon '%s' created the '%s' bar."

-- Core.lua
L.berserk = "Berserk"
L.berserk_desc = "Show a bar and timed warnings for when the boss will go berserk."
L.altpower = "Alternate power display"
L.altpower_desc = "Show the alternate power window, which displays the amount of alternate power that your group members have."
L.infobox = "Information Box"
L.infobox_desc = "Display a box with information related to the encounter."
L.stages = "Stages"
L.stages_desc = "Enable functions related to the various stages of the boss encounter such as stage change warnings, stage duration timer bars, etc."
L.warmup = "Warmup"
L.warmup_desc = "Time until combat with the boss starts."
L.proximity = "Proximity display"
L.proximity_desc = "Show the proximity window when appropriate for this encounter, listing players who are standing too close to you."
L.adds = "Adds"
L.adds_desc = "Enable functions related to the various adds that will spawn during the boss encounter."
L.health = "Health"
L.health_desc = "Enable functions for displaying various health information during the boss encounter."
L.energy = "Energy"
L.energy_desc = "Enable functions for displaying information about the various energy levels during the boss encounter."

L.already_registered = "|cffff0000WARNING:|r |cff00ff00%s|r (|cffffff00%s|r) already exists as a module in BigWigs, but something is trying to register it again. This usually means you have two copies of this module in your addons folder due to some addon updater failure. It is recommended that you delete any BigWigs folders you have and then reinstall it from scratch."

-- Loader / Options.lua
L.okay = "Okay"
L.officialRelease = "You are running an official release of BigWigs %s (%s)."
L.alphaRelease = "You are running an ALPHA RELEASE of BigWigs %s (%s)."
L.sourceCheckout = "You are running a source checkout of BigWigs %s directly from the repository."
L.littlewigsOfficialRelease = "You are running an official release of LittleWigs (%s)."
L.littlewigsAlphaRelease = "You are running an ALPHA RELEASE of LittleWigs (%s)."
L.littlewigsSourceCheckout = "You are running a source checkout of LittleWigs directly from the repository."
L.guildRelease = "You are running version %d of BigWigs made for your guild, based on version %d of the official addon."
L.getNewRelease = "Your BigWigs is old (/bwv) but you can easily update it using the CurseForge Client. Alternatively, you can update manually from curseforge.com or addons.wago.io."
L.warnTwoReleases = "Your BigWigs is 2 releases out of date! Your version may have bugs, missing features, or completely incorrect timers. It is strongly recommended you update."
L.warnSeveralReleases = "|cffff0000Your BigWigs is %d releases out of date!! We HIGHLY recommend you update to prevent syncing issues with other players!|r"
L.warnOldBase = "You are using a guild version of BigWigs (%d), but your base version (%d) is %d releases out of date. This may cause issues."

L.tooltipHint = "|cffeda55fRight-Click|r to access options."
L.activeBossModules = "Active boss modules:"

L.oldVersionsInGroup = "There are people in your group with |cffff0000older versions|r of BigWigs. You can get more details with /bwv."
L.upToDate = "Up to date:"
L.outOfDate = "Out of date:"
L.dbmUsers = "DBM users:"
L.noBossMod = "No boss mod:"
L.offline = "Offline"

L.missingAddOnPopup = "The |cFF436EEE%s|r addon is missing!"
L.missingAddOnRaidWarning = "The |cFF436EEE%s|r addon is missing! No timers will be displayed in this zone!"
L.outOfDateAddOnPopup = "The |cFF436EEE%s|r addon is out of date!"
L.outOfDateAddOnRaidWarning = "The |cFF436EEE%s|r addon is out of date! You have v%d.%d.%d but the latest is v%d.%d.%d!"
L.disabledAddOn = "You have the |cFF436EEE%s|r addon disabled, timers will not be shown."
L.removeAddOn = "Please remove '|cFF436EEE%s|r' as it's been replaced by '|cFF436EEE%s|r'."
L.alternativeName = "%s (|cFF436EEE%s|r)"
L.outOfDateContentPopup = "WARNING!\nYou updated |cFF436EEE%s|r but you also need to update the main |cFF436EEEBigWigs|r addon.\nIgnoring this will result in broken functionality."
L.outOfDateContentRaidWarning = "|cFF436EEE%s|r requires version %d of the main |cFF436EEEBigWigs|r addon to function correctly, but you're on version %d."
L.addOnLoadFailedWithReason = "BigWigs failed to load the addon |cFF436EEE%s|r with reason %q. Tell the BigWigs devs!"
L.addOnLoadFailedUnknownError = "BigWigs encountered an error when loading the addon |cFF436EEE%s|r. Tell the BigWigs devs!"

L.expansionNames = {
	"Classic", -- Classic
	"The Burning Crusade", -- The Burning Crusade
	"Wrath of the Lich King", -- Wrath of the Lich King
	"Cataclysm", -- Cataclysm
	"Mists of Pandaria", -- Mists of Pandaria
	"Warlords of Draenor", -- Warlords of Draenor
	"Legion", -- Legion
	"Battle for Azeroth", -- Battle for Azeroth
	"Shadowlands", -- Shadowlands
	"Dragonflight", -- Dragonflight
	"The War Within", -- The War Within
}
L.littleWigsExtras = {
	["LittleWigs_Delves"] = "Delves",
	["LittleWigs_CurrentSeason"] = "Current Season",
}

-- Media.lua (These are the names of the sounds in the dropdown list in the "sounds" section)
L.Beware = "Beware (Algalon)"
L.FlagTaken = "Flag Taken (PvP)"
L.Destruction = "Destruction (Kil'jaeden)"
L.RunAway = "Run Away Little Girl (Big Bad Wolf)"
L.spell_on_you = "BigWigs: Spell on you"
L.spell_under_you = "BigWigs: Spell under you"
L.simple_no_voice = "Simple (No Voice)"

-- Options.lua
L.options = "Options"
L.optionsKey = "ID: %s" -- The ID that messages/bars/options use
L.raidBosses = "Raid Bosses"
L.dungeonBosses = "Dungeon Bosses"
L.introduction = "Welcome to BigWigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group."
L.sound = "Sound"
L.minimapIcon = "Minimap icon"
L.minimapToggle = "Toggle show/hide of the minimap icon."
L.compartmentMenu = "No compartment icon"
L.compartmentMenu_desc = "Turning this option off will make BigWigs show up in the addon compartment menu. We recommend leaving this option enabled."
L.configure = "Configure"
L.resetPositions = "Reset positions"
L.selectEncounter = "Select encounter"
L.privateAuraSounds = "Private Aura Sounds"
L.privateAuraSounds_desc = "Private auras can't be tracked normally, but you can set a sound to be played when you are targeted with the ability."
L.listAbilities = "List abilities in group chat"

L.dbmFaker = "Pretend I'm using DBM"
L.dbmFakerDesc = "If a DBM user does a version check to see who's using DBM, they will see you on the list. Useful for guilds that force using DBM."
L.zoneMessages = "Show zone messages"
L.zoneMessagesDesc = "Disabling this will stop showing messages when you enter a zone that BigWigs has timers for, but you don't have installed. We recommend you leave this turned on as it's the only notification you will get if we suddenly create timers for a new zone that you find useful."
L.englishSayMessages = "English-only say messages"
L.englishSayMessagesDesc = "All the 'say' and 'yell' messages that you send in chat during a boss encounter will always be in English. Can be useful if you are with a mixed language group of players."

L.slashDescTitle = "|cFFFED000Slash Commands:|r"
L.slashDescPull = "|cFFFED000/pull:|r Sends a pull countdown to your raid."
L.slashDescBreak = "|cFFFED000/break:|r Sends a break timer to your raid."
L.slashDescRaidBar = "|cFFFED000/raidbar:|r Sends a custom bar to your raid."
L.slashDescLocalBar = "|cFFFED000/localbar:|r Creates a custom bar only you can see."
L.slashDescRange = "|cFFFED000/range:|r Opens the range indicator."
L.slashDescVersion = "|cFFFED000/bwv:|r Performs a BigWigs version check."
L.slashDescConfig = "|cFFFED000/bw:|r Opens the BigWigs configuration."

L.gitHubDesc = "|cFF33FF99BigWigs is open source software hosted on GitHub. We are always looking for new people to help us out and everyone is welcome to inspect our code, make contributions and submit bug reports. BigWigs is as great as it is today largely in part to the great WoW community helping us out.|r"

L.BAR = "Bars"
L.MESSAGE = "Messages"
L.ICON = "Icon"
L.SAY = "Say"
L.FLASH = "Flash"
L.EMPHASIZE = "Emphasize"
L.ME_ONLY = "Only when on me"
L.ME_ONLY_desc = "When you enable this option messages for this ability will only be shown when they affect you. For example, 'Bomb: Player' will only be shown if it's on you."
L.PULSE = "Pulse"
L.PULSE_desc = "In addition to flashing the screen, you can also have an icon related to this specific ability momentarily shown in the middle of your screen to try grab your attention."
L.MESSAGE_desc = "Most encounter abilities come with one or more messages that BigWigs will show on your screen. If you disable this option, none of the messages attached to this option, if any, will be displayed."
L.BAR_desc = "Bars are shown for some encounter abilities when appropriate. If this ability is accompanied by a bar that you want to hide, disable this option."
L.FLASH_desc = "Some abilities might be more important than others. If you want your screen to flash when this ability is imminent or used, check this option."
L.ICON_desc = "BigWigs can mark characters affected by abilities with an icon. This makes them easier to spot."
L.SAY_desc = "Chat bubbles are easy to spot. BigWigs will use a say message to announce people nearby about an effect on you."
L.EMPHASIZE_desc = "Enabling this will emphasize any messages associated with this ability, making them larger and more visible. You can set the size and font of emphasized messages in the main options under \"Messages\"."
L.PROXIMITY = "Proximity display"
L.PROXIMITY_desc = "Abilities will sometimes require you to spread out. The proximity display will be set up specifically for this ability so that you will be able to tell at-a-glance whether or not you are safe."
L.ALTPOWER = "Alternate power display"
L.ALTPOWER_desc = "Some encounters will use the alternate power mechanic on players in your group. The alternate power display provides a quick overview of who has the least/most alternate power, which can be useful for specific tactics or assignments."
L.TANK = "Tank Only"
L.TANK_desc = "Some abilities are only important for tanks. If you want to see warnings for this ability regardless of your role, disable this option."
L.HEALER = "Healer Only"
L.HEALER_desc = "Some abilities are only important for healers. If you want to see warnings for this ability regardless of your role, disable this option."
L.TANK_HEALER = "Tank & Healer Only"
L.TANK_HEALER_desc = "Some abilities are only important for tanks and healers. If you want to see warnings for this ability regardless of your role, disable this option."
L.DISPEL = "Dispeller Only"
L.DISPEL_desc = "If you want to see warnings for this ability even when you cannot dispel it, disable this option."
L.VOICE = "Voice"
L.VOICE_desc = "If you have a voice plugin installed, this option will enable it to play a sound file that speaks this warning out loud for you."
L.COUNTDOWN = "Countdown"
L.COUNTDOWN_desc = "If enabled, a vocal and visual countdown will be added for the last 5 seconds. Imagine someone counting down \"5... 4... 3... 2... 1...\" with a big number in the middle of your screen."
L.CASTBAR_COUNTDOWN = "Countdown (cast bars only)"
L.CASTBAR_COUNTDOWN_desc = "If enabled, a vocal and visual countdown will be added for the last 5 seconds of the cast bars."
L.INFOBOX = L.infobox
L.INFOBOX_desc = L.infobox_desc
L.SOUND = L.sound
L.SOUND_desc = "Boss abilities usually play sounds to help you notice them. If you disable this option, none of the sounds attached to it will play."
L.CASTBAR = "Cast Bars"
L.CASTBAR_desc = "Cast bars are sometimes shown on certain bosses, usually to bring attention to a critical ability incoming. If this ability is accompanied by a cast bar that you want to hide, disable this option."
L.SAY_COUNTDOWN = "Say Countdown"
L.SAY_COUNTDOWN_desc = "Chat bubbles are easy to spot. BigWigs will use multiple say messages counting down to alert people nearby that an ability on you is about to expire."
L.ME_ONLY_EMPHASIZE = "Emphasize (me only)"
L.ME_ONLY_EMPHASIZE_desc = "Enabling this will emphasize any messages associated with this ability ONLY if it is casted on you, making them larger and more visible."
L.NAMEPLATE = "Nameplates"
L.NAMEPLATE_desc = "If enabled, features such as icons and text related to this specific ability will show on your nameplates. This makes it easier to see which specific NPC is casting an ability when there are multiple NPCs that cast it."
L.PRIVATE = "Private Aura"
L.PRIVATE_desc = "These settings are for general cast alerts and bars only!\n\nYou can change the sound to play when you are targeted by this ability by selecting \"Private Aura Sounds\" in the \"Select encounter\" dropdown in the top right."

L.advanced_options = "Advanced options"
L.back = "<< Back"

L.tank = "|cFFFF0000Tank alerts only.|r "
L.healer = "|cFFFF0000Healer alerts only.|r "
L.tankhealer = "|cFFFF0000Tank & Healer alerts only.|r "
L.dispeller = "|cFFFF0000Dispeller alerts only.|r "

-- Sharing.lua
L.import = "Import"
L.import_info = "After entering a string you can select what settings you would like to import.\nIf settings are not available in the import string they will not be selectable.\n\n|cffff4411This import will only affect the general settings and does not affect boss specific settings.|r"
L.import_info_active = "Choose what parts you would like to import and then click the import button."
L.import_info_none = "|cFFFF0000The import string is incompatible or out of date.|r"
L.export = "Export"
L.export_info = "Select which settings you would like to export and share with others.\n\n|cffff4411You can only share general settings and these have no effect on boss specific settings.|r"
L.export_string = "Export String"
L.export_string_desc = "Copy this BigWigs string if you want to share your settings."
L.import_string = "Import String"
L.import_string_desc = "Paste the BigWigs string you want to import here."
L.position = "Position"
L.settings = "Settings"
L.other_settings = "Other Settings"
L.nameplate_settings_import_desc = "Import all nameplate settings."
L.nameplate_settings_export_desc = "Export all nameplate settings."
L.position_import_bars_desc = "Import the position (anchors) of the bars."
L.position_import_messages_desc = "Import the position (anchors) of the messages."
L.position_import_countdown_desc = "Import the position (anchors) of the countdown."
L.position_export_bars_desc = "Export the position (anchors) of the bars."
L.position_export_messages_desc = "Export the position (anchors) of the messages."
L.position_export_countdown_desc = "Export the position (anchors) of the countdown."
L.settings_import_bars_desc = "Import the general bar settings such as size, font, etc."
L.settings_import_messages_desc = "Import the general message settings such as size, font, etc."
L.settings_import_countdown_desc = "Import the general countdown settings such as voice, size, font, etc."
L.settings_export_bars_desc = "Export the general bar settings such as size, font, etc."
L.settings_export_messages_desc = "Export the general message settings such as size, font, etc."
L.settings_export_countdown_desc = "Export the general countdown settings such as voice, size, font, etc."
L.colors_import_bars_desc = "Import the colors of the bars."
L.colors_import_messages_desc = "Import the colors of the messages."
L.color_import_countdown_desc = "Import the color of the countdown."
L.colors_export_bars_desc = "Export the colors of the bars."
L.colors_export_messages_desc = "Export the colors of the messages."
L.color_export_countdown_desc = "Export the color of the countdown."
L.confirm_import = "The selected settings you are about to import will overwrite the settings in your currently selected profile:\n\n|cFF33FF99\"%s\"|r\n\nAre you sure you want to do this?"
L.confirm_import_addon = "The addon |cFF436EEE\"%s\"|r wants to automatically import new BigWigs settings that will overwrite the settings in your currently selected BigWigs profile:\n\n|cFF33FF99\"%s\"|r\n\nAre you sure you want to do this?"
L.confirm_import_addon_new_profile = "The addon |cFF436EEE\"%s\"|r wants to automatically create a new BigWigs profile called:\n\n|cFF33FF99\"%s\"|r\n\nAccepting this new profile will also swap to it."
L.confirm_import_addon_edit_profile = "The addon |cFF436EEE\"%s\"|r wants to automatically edit one of your BigWigs profiles called:\n\n|cFF33FF99\"%s\"|r\n\nAccepting these changes will also swap to it."
L.no_string_available = "No import string stored to import. First import a string."
L.no_import_message = "No settings were imported."
L.import_success = "Imported: %s" -- Imported: Bar Anchors, Message Colors
L.imported_bar_positions = "Bar Positions"
L.imported_bar_settings = "Bar Settings"
L.imported_bar_colors = "Bar Colors"
L.imported_message_positions = "Message Positions"
L.imported_message_settings = "Message Settings"
L.imported_message_colors = "Message Colors"
L.imported_countdown_position = "Countdown Position"
L.imported_countdown_settings = "Countdown Settings"
L.imported_countdown_color = "Countdown Color"
L.imported_nameplate_settings = "Nameplate Settings"
L.imported_mythicplus_settings = "Mythic+ Settings"
L.mythicplus_settings_import_desc = "Import all Mythic+ settings."
L.mythicplus_settings_export_desc = "Export all Mythic+ settings."

-- Statistics
L.statistics = "Statistics"
L.defeat = "Defeat"
L.defeat_desc = "The total amount of times you've been defeated by this boss encounter."
L.victory = "Victory"
L.victory_desc = "The total amount of times you were victorious against this boss encounter."
L.fastest = "Fastest"
L.fastest_desc = "The fastest victory and the date it occured on. (Year/Month/Day)"
L.first = "First"
L.first_desc = "The first time you were victorious against this boss encounter, formatted as:\n[Amount of defeats prior to first victory] - [Combat duration] - [Year/Month/Day of victory]"

-- Difficulty levels for statistics display on bosses
L.unknown = "Unknown"
L.LFR = "LFR"
L.normal = "Normal"
L.heroic = "Heroic"
L.mythic = "Mythic"
L.timewalk = "Timewalking"
L.solotier8 = "Solo Tier 8"
L.solotier11 = "Solo Tier 11"
L.story = "Story"
L.mplus = "Mythic+ %d"
L.SOD = "Season of Discovery"
L.hardcore = "Hardcore"
L.level1 = "Level 1"
L.level2 = "Level 2"
L.level3 = "Level 3"
L.N10 = "Normal 10"
L.N25 = "Normal 25"
L.H10 = "Heroic 10"
L.H25 = "Heroic 25"

-----------------------------------------------------------------------
-- TOOLS
-----------------------------------------------------------------------

L.tools = "Tools"
L.toolsDesc = "BigWigs provides various tools or \"quality of life\" features to speed up and simplify the process of fighting bosses."

-----------------------------------------------------------------------
-- AutoRole.lua
--

L.autoRoleTitle = "Auto Role"
L.autoRoleExplainer = "Whenever you join a group, or you change your talent specialization whilst being in a group, BigWigs will automatically adjust your group role (Tank, Healer, Damager) accordingly.\n\n"

-----------------------------------------------------------------------
-- Keystones.lua
--

L.keystoneTitle = "BigWigs Keystones"
L.keystoneHeaderParty = "Party"
L.keystoneRefreshParty = "Refresh Party"
L.keystoneHeaderGuild = "Guild"
L.keystoneRefreshGuild = "Refresh Guild"
L.keystoneLevelTooltip = "Keystone level: |cFFFFFFFF%s|r"
L.keystoneMapTooltip = "Dungeon: |cFFFFFFFF%s|r"
L.keystoneRatingTooltip = "Mythic+ rating: |cFFFFFFFF%d|r"
L.keystoneHiddenTooltip = "The player has chosen to hide this information."
L.keystoneTabOnline = "Online"
L.keystoneTabAlts = "Alts"
L.keystoneTabTeleports = "Teleports"
L.keystoneHeaderMyCharacters = "My Characters"
L.keystoneTeleportNotLearned = "The teleport spell '|cFFFFFFFF%s|r' is |cFFFF4411not learned|r yet."
L.keystoneTeleportOnCooldown = "The teleport spell '|cFFFFFFFF%s|r' is currently |cFFFF4411on cooldown|r for %d |4hour:hours; and %d |4minute:minutes;."
L.keystoneTeleportReady = "The teleport spell '|cFFFFFFFF%s|r' is |cFF33FF99ready|r, click to cast it."
L.keystoneTeleportInCombat = "You cannot teleport here whilst you are in combat."
L.keystoneTabHistory = "History"
L.keystoneHeaderThisWeek = "This Week"
L.keystoneHeaderOlder = "Older"
L.keystoneScoreGainedTooltip = "Score Gained: |cFFFFFFFF+%d|r\nDungeon Score: |cFFFFFFFF%d|r"
L.keystoneCompletedTooltip = "Completed in time: |cFFFFFFFF%d min %d sec|r\nTime Limit: |cFFFFFFFF%d min %d sec|r"
L.keystoneFailedTooltip = "Failed to complete in time: |cFFFFFFFF%d min %d sec|r\nTime Limit: |cFFFFFFFF%d min %d sec|r"
L.keystoneExplainer = "A collection of various tools to improve the Mythic+ experience."
L.keystoneAutoSlot = "Auto insert keystone"
L.keystoneAutoSlotDesc = "Automatically insert your keystone into the slot when opening the keystone holder."
L.keystoneAutoSlotMessage = "Automatically inserted %s into the keystone slot."
L.keystoneAutoSlotFrame = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:14:14|t Keystone Auto Inserted"
L.keystoneModuleName = "Mythic+"
L.keystoneStartBar = "%s +%d" -- Format is SHORT_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "ROOK +12"
L.keystoneStartMessage = "%s +%d begins now!" -- Format is LONG_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "The Rookery +12 begins now!"
L.keystoneCountdownExplainer = "When you start a Mythic+ dungeon a countdown will play. Choose what voice you'd like to hear and when you want the countdown to start.\n\n"
L.keystoneCountdownBeginsDesc = "Choose how much time should be remaining on the Mythic+ start timer when the countdown will begin to play."
L.keystoneCountdownBeginsSound = "Play a sound when the Mythic+ countdown starts"
L.keystoneCountdownEndsSound = "Play a sound when the Mythic+ countdown ends"
L.keystoneViewerTitle = "Keystone Viewer"
L.keystoneHideGuildTitle = "Hide my keystone from my guild members"
L.keystoneHideGuildDesc = "|cffff4411Not recommended.|r This feature will prevent your guild members seeing what keystone you have. Anyone in your group will still be able to see it."
L.keystoneHideGuildWarning = "Disabling the ability for your guild members to see your keystone is |cffff4411not recommended|r.\n\nAre you sure you want to do this?"
L.keystoneAutoShowEndOfRun = "Show when the Mythic+ is over"
L.keystoneAutoShowEndOfRunDesc = "Automatically show the keystone viewer when when the Mythic+ dungeon is over.\n\n|cFF33FF99This can help you see what new keystones your party has received.|r"
L.keystoneViewerExplainer = "You can open the keystone viewer using the |cFF33FF99/key|r command or by clicking the button below.\n\n"
L.keystoneViewerOpen = "Open the keystone viewer"
L.keystoneViewerKeybindingExplainer = "\n\nYou can also set a keybinding to open the keystone viewer:\n\n"
L.keystoneViewerKeybindingDesc = "Choose a keybinding to open the keystone viewer."
L.keystoneClickToWhisper = "Click to open a whisper dialog"
L.keystoneClickToTeleportNow = "\nClick to teleport here"
L.keystoneClickToTeleportCooldown = "\nCannot teleport, spell on cooldown"
L.keystoneClickToTeleportNotLearned = "\nCannot teleport, spell not learned"
L.keystoneHistoryRuns = "%d Total"
L.keystoneHistoryRunsThisWeekTooltip = "Total amount of dungeons this week: |cFFFFFFFF%d|r"
L.keystoneHistoryRunsOlderTooltip = "Total amount of dungeons before this week: |cFFFFFFFF%d|r"
L.keystoneHistoryScore = "+%d Score"
L.keystoneHistoryScoreThisWeekTooltip = "Total score gained this week: |cFFFFFFFF+%d|r"
L.keystoneHistoryScoreOlderTooltip = "Total score gained before this week: |cFFFFFFFF+%d|r"
L.keystoneTimeUnder = "|cFF33FF99-%02d:%02d|r"
L.keystoneTimeOver = "|cFFFF4411+%02d:%02d|r"
L.keystoneTeleportTip = "Click the dungeon name below to |cFF33FF99TELEPORT|r directly to the dungeon entrance."

-- It doesn't really matter what you call it as long as it's recognizable and limited to ~6 characters
L.keystoneShortName_TheRookery = "ROOK"
L.keystoneShortName_DarkflameCleft = "DFC"
L.keystoneShortName_PrioryOfTheSacredFlame = "PRIORY"
L.keystoneShortName_CinderbrewMeadery = "BREW"
L.keystoneShortName_OperationFloodgate = "FLOOD"
L.keystoneShortName_TheaterOfPain = "TOP"
L.keystoneShortName_TheMotherlode = "ML"
L.keystoneShortName_OperationMechagonWorkshop = "WORK"
L.keystoneShortName_EcoDomeAldani = "ECODOME"
L.keystoneShortName_HallsOfAtonement = "HOA"
L.keystoneShortName_AraKaraCityOfEchoes = "ARAK"
L.keystoneShortName_TazaveshSoleahsGambit = "GAMBIT"
L.keystoneShortName_TazaveshStreetsOfWonder = "STREET"
L.keystoneShortName_TheDawnbreaker = "DAWN"

-- These short names are for the bar that shows during the Mythic+ countdown
-- Use the real dungeon names but make them shorter to fit on the bar better
L.keystoneShortName_TheRookery_Bar = "Rookery"
L.keystoneShortName_DarkflameCleft_Bar = "Darkflame"
L.keystoneShortName_PrioryOfTheSacredFlame_Bar = "Priory"
L.keystoneShortName_CinderbrewMeadery_Bar = "Cinderbrew"
L.keystoneShortName_OperationFloodgate_Bar = "Floodgate"
L.keystoneShortName_TheaterOfPain_Bar = "Theater"
L.keystoneShortName_TheMotherlode_Bar = "Motherlode"
L.keystoneShortName_OperationMechagonWorkshop_Bar = "Workshop"
L.keystoneShortName_EcoDomeAldani_Bar = "Eco-Dome"
L.keystoneShortName_HallsOfAtonement_Bar = "Halls"
L.keystoneShortName_AraKaraCityOfEchoes_Bar = "Ara-Kara"
L.keystoneShortName_TazaveshSoleahsGambit_Bar = "Gambit"
L.keystoneShortName_TazaveshStreetsOfWonder_Bar = "Streets"
L.keystoneShortName_TheDawnbreaker_Bar = "Dawnbreaker"

-- Instance Keys "Who has a key?"
L.instanceKeysTitle = "Who has a key?"
L.instanceKeysDesc = "When you enter a Mythic dungeon, the players that have a keystone for that dungeon will be displayed as a list.\n\n"
L.instanceKeysTest8 = "|cFF00FF98Monk:|r +8"
L.instanceKeysTest10 = "|cFFFF7C0ADruid:|r +10"
L.instanceKeysDisplay = "|c%s%s:|r +%d" -- "PLAYER_NAME: +DUNGEON_LEVEL"
L.instanceKeysDisplayWithDungeon = "|c%s%s:|r +%d (%s)" -- "PLAYER_NAME: +DUNGEON_LEVEL (DUNGEON_NAME)"
L.instanceKeysShowAll = "Always show all players"
L.instanceKeysShowAllDesc = "Enabling this option will show all players in the list, even if their keystone doesn't belong to the dungeon you are in."
L.instanceKeysOtherDungeonColor = "Other dungeon color"
L.instanceKeysOtherDungeonColorDesc = "Choose the font color for players that have keystones that don't belong to the dungeon you are in."
L.instanceKeysEndOfRunDesc = "By default the list will only show when you enter a mythic dungeon. Enabling this option will also show the list when the Mythic+ is over."

-----------------------------------------------------------------------
-- LFGTimer.lua
--

L.lfgTimerTitle = "LFG Timer"
L.lfgTimerExplainer = "Whenever the LFG queue popup appears, BigWigs will create a timer bar telling you how long you have to accept the queue.\n\n"
L.lfgUseMaster = "Play LFG ready sound on 'Master' audio channel"
L.lfgUseMasterDesc = "When this option is enabled the LFG ready sound will play over the 'Master' audio channel. If you disable this option it will play over the '%s' audio channel instead."

-----------------------------------------------------------------------
-- PLUGINS
-----------------------------------------------------------------------

L.general = "General"
L.advanced = "Advanced"
L.comma = ", "
L.reset = "Reset"
L.resetDesc = "Reset the above settings to their default values."
L.resetAll = "Reset all"

L.positionX = "X Position"
L.positionY = "Y Position"
L.positionExact = "Exact Positioning"
L.positionDesc = "Type in the box or move the slider if you need exact positioning from the anchor."
L.width = "Width"
L.height = "Height"
L.size = "Size"
L.sizeDesc = "Normally you set the size by dragging the anchor. If you need an exact size you can use this slider or type the value into the box."
L.fontSizeDesc = "Adjust the font size using the slider or type the value into the box which has a much higher maximum of 200."
L.disabled = "Disabled"
L.disableDesc = "You are about to disable the feature '%s' which is |cffff4411not recommended|r.\n\nAre you sure you want to do this?"
L.keybinding = "Keybinding"
L.dragToResize = "Drag to resize"

-- Anchor Points / Grow Directions
L.UP = "Up"
L.DOWN = "Down"
L.TOP = "Top"
L.RIGHT = "Right"
L.BOTTOM = "Bottom"
L.LEFT = "Left"
L.TOPRIGHT = "Top Right"
L.TOPLEFT = "Top Left"
L.BOTTOMRIGHT = "Bottom Right"
L.BOTTOMLEFT = "Bottom Left"
L.CENTER = "Center"
L.customAnchorPoint = "Advanced: Custom anchor point"
L.sourcePoint = "Source Point"
L.destinationPoint = "Destination Point"
L.drawStrata = "Strata"
L.medium = "Medium"
L.low = "Low"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "AltPower"
L.altPowerDesc = "The AltPower display will only appear for bosses that apply AltPower to players, which is extremely rare. The display measures the amount of 'Alternative Power' you and your group has, displaying it in a list. To move the display around, please use the test button below."
L.toggleDisplayPrint = "The display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."
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
L.testBarsBtn = "Create Test Bar"
L.testBarsBtn_desc = "Creates a bar for you to test your current display settings with."

L.toggleAnchorsBtnShow = "Show Moving Anchors"
L.toggleAnchorsBtnHide = "Hide Moving Anchors"
L.toggleAnchorsBtnHide_desc = "Hide all the moving anchors, locking everything in place."
L.toggleBarsAnchorsBtnShow_desc = "Show all the moving anchors, allowing you to move the bars."

L.emphasizeAt = "Emphasize at... (seconds)"
L.growingUpwards = "Grow upwards"
L.growingUpwardsDesc = "Toggle growing upwards or downwards from the anchor."
L.texture = "Texture"
L.emphasize = L.EMPHASIZE
L.emphasizeMultiplier = "Size Multiplier"
L.emphasizeMultiplierDesc = "If you disable the bars moving to the emphasize anchor, this option will decide what size the emphasized bars will be by multiplying the size of the normal bars."

L.enable = "Enable"
L.move = "Move"
L.moveDesc = "Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change size and color."
L.emphasizedBars = "Emphasized bars"
L.align = "Align"
L.alignText = "Align Text"
L.alignTime = "Align Time"
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
L.blockZoneChanges = "Block zone changed messages"
L.blockZoneChangesDesc = "The messages that show in the middle-top of the screen when you move into a new zone such as '|cFF33FF99Stormwind|r' or '|cFF33FF99Orgrimmar|r' will be blocked."
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

L.redirectPopups = "Redirect popup banners to BigWigs messages"
L.redirectPopupsDesc = "Popup banners in the middle of your screen such as the '|cFF33FF99vault slot unlocked|r' banner will instead be displayed as BigWigs messages. These banners can be quite large, last a long time, and block your ability to click through them."
L.redirectPopupsColor = "Color of the redirected message"
L.blockDungeonPopups = "Block dungeon popup banners"
L.blockDungeonPopupsDesc = "The popup banners that show when entering a dungeon can sometimes contain text which is very long. Enabling this feature will completely block them."
L.itemLevel = "Item Level %d"
L.newRespawnPoint = "New Respawn Point"

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
L.expiring_normal = "Normal"
L.emphasized = "Emphasized"

L.resetColorsDesc = "Resets the above colors to their defaults."
L.resetAllColorsDesc = "If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."

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

L.infobox_short = "InfoBox"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "Route output from this addon through the BigWigs message display. This display supports icons, colors and can show up to 4 messages on the screen at a time. Newly inserted messages will grow in size and shrink again quickly to notify the user."
L.emphasizedSinkDescription = "Route output from this addon through the BigWigs Emphasized message display. This display supports text and colors, and can only show one message at a time."
L.resetMessagesDesc = "Reset all the options related to messages, including the position of the message anchors."
L.toggleMessagesAnchorsBtnShow_desc = "Show all the moving anchors, allowing you to move the messages."

L.testMessagesBtn = "Create Test Message"
L.testMessagesBtn_desc = "Creates a message for you to test your current display settings with."

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

L.messagesOptInHeaderOff = "Boss mod messages 'opt-in' mode: Enabling this option will turn off messages across ALL of your boss modules.\n\nYou will need to go through each one and manually turn on the messages you want.\n\n"
L.messagesOptInHeaderOn = "Boss mod messages 'opt-in' mode is |cFF33FF99ACTIVE|r. To see boss mod messages, go into the settings of a specific boss ability and turn on the '|cFF33FF99Messages|r' option.\n\n"
L.messagesOptInTitle = "Boss mod messages 'opt-in' mode"
L.messagesOptInWarning = "|cffff4411WARNING!|r\n\nEnabling 'opt-in' mode will turn off messages across ALL of your boss modules. You will need to go through each one and manually turn on the messages you want.\n\nYour UI will now reload, are you sure?"

-----------------------------------------------------------------------
-- Nameplates.lua
--

L.nameplates = "Nameplates"
L.testNameplateIconBtn = "Show Test Icon"
L.testNameplateIconBtn_desc = "Creates a test icon for you to test your current display settings with on your targeted nameplate."
L.testNameplateTextBtn = "Show Text Test"
L.testNameplateTextBtn_desc = "Creates a test text for you to test your current text settings with on your targeted nameplate."
L.stopTestNameplateBtn = "Stop Tests"
L.stopTestNameplateBtn_desc = "Stops the icon and text tests on your nameplates."
L.noNameplateTestTarget = "You need to have a hostile target which is attackable selected to test nameplate functionality."
L.anchoring = "Anchoring"
L.growStartPosition = "Grow Start Position"
L.growStartPositionDesc = "The starting position for the first icon."
L.growDirection = "Grow Direction"
L.growDirectionDesc = "The direction the icons will grow from the starting position."
L.iconSpacingDesc = "Change the space between each icon."
L.nameplateIconSettings = "Icon Settings"
L.keepAspectRatio = "Keep Aspect Ratio"
L.keepAspectRatioDesc = "Keep the aspect ratio of the icon 1:1 instead of stretching it to fit the size of the frame."
L.iconColor = "Icon Color"
L.iconColorDesc = "Change the color of the icon texture."
L.desaturate = "Desaturate"
L.desaturateDesc = "Desaturate the icon texture."
L.zoom = "Zoom"
L.zoomDesc = "Zoom the icon texture."
L.showBorder = "Show Border"
L.showBorderDesc = "Show a border around the icon."
L.borderColor = "Border Color"
L.borderSize = "Border Size"
L.borderOffset = "Border Offset"
L.borderName = "Border Name"
L.showNumbers = "Show Numbers"
L.showNumbersDesc = "Show numbers on the icon."
L.cooldown = "Cooldown"
L.cooldownEmphasizeHeader = "By default, Emphasize is disabled (0 seconds). Setting it to 1 second or higher will enable Emphasize. This will allow you to set a different font color and font size for those numbers."
L.showCooldownSwipe = "Show Swipe"
L.showCooldownSwipeDesc = "Show a swipe on the icon when the cooldown is active."
L.showCooldownEdge = "Show Edge"
L.showCooldownEdgeDesc = "Show an edge on the cooldown when the cooldown is active."
L.inverse = "Inverse"
L.inverseSwipeDesc = "Invert the cooldown animations."
L.glow = "Glow"
L.enableExpireGlow = "Enable Expire Glow"
L.enableExpireGlowDesc = "Show a glow around the icon when the cooldown has expired."
L.glowColor = "Glow Color"
L.glowType = "Glow Type"
L.glowTypeDesc = "Change the type of glow that is shown around the icon."
L.resetNameplateIconsDesc = "Reset all the options related to nameplate icons."
L.nameplateTextSettings = "Text Settings"
L.fixate_test = "Fixate Test" -- Text that displays to test on the frame
L.resetNameplateTextDesc = "Reset all the options related to nameplate text."
L.glowAt = "Begin Glow (seconds)"
L.glowAt_desc = "Choose how many seconds on the cooldown should be remaining when the glow begins."
L.offsetX = "Offset X"
L.offsetY = "Offset Y"
L.headerIconSizeTarget = "Icon size of your current target"
L.headerIconSizeOthers = "Icon size of all other targets"
L.headerIconPositionTarget = "Icon position of your current target"
L.headerIconPositionOthers = "Icon position of all other targets"

-- Glow types as part of LibCustomGlow
L.pixelGlow = "Pixel Glow"
L.autocastGlow = "Autocast Glow"
L.buttonGlow = "Button Glow"
L.procGlow = "Proc Glow"
L.speed = "Speed"
L.animation_speed_desc = "The speed at which the glow animation plays."
L.lines = "Lines"
L.lines_glow_desc = "The number of lines in the glow animation."
L.intensity = "Intensity"
L.intensity_glow_desc = "The intensity of the glow effect, higher means more sparks."
L.length = "Length"
L.length_glow_desc = "The length of the lines in the glow animation."
L.thickness = "Thickness"
L.thickness_glow_desc = "The thickness of the lines in the glow animation."
L.scale = "Scale"
L.scale_glow_desc = "The scale of the sparks in the animation."
L.startAnimation = "Start Animation"
L.startAnimation_glow_desc = "This glow has a starting animation, this will enable/disable that animation."

L.nameplateOptInHeaderOff = "\n\n\n\nBoss mod nameplates 'opt-in' mode: Enabling this option will turn off nameplates across ALL of your boss modules.\n\nYou will need to go through each one and manually turn on the nameplates you want.\n\n"
L.nameplateOptInHeaderOn = "\n\n\n\nBoss mod nameplates 'opt-in' mode is |cFF33FF99ACTIVE|r. To see boss mod nameplates, go into the settings of a specific boss ability and turn on the '|cFF33FF99Nameplates|r' option.\n\n"
L.nameplateOptInTitle = "Boss mod nameplates 'opt-in' mode"
L.nameplateOptInWarning = "|cffff4411WARNING!|r\n\nEnabling 'opt-in' mode will turn off nameplates across ALL of your boss modules. You will need to go through each one and manually turn on the nameplates you want.\n\nYour UI will now reload, are you sure?"

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
L.pullStartedMessageTitle = "Show a message when the pull timer is started"
L.pullFinishedSoundTitle = "Play a sound when the pull timer is finished"
L.pullStartedBy = "Pull timer started by %s."
L.pullStopped = "Pull timer cancelled by %s."
L.pullStoppedCombat = "Pull timer cancelled because you entered combat."
L.pullIn = "Pull in %d sec"
L.sendPull = "Sending a pull timer to your group."
L.wrongPullFormat = "Invalid pull timer. A correct example is: /pull 5"
L.countdownBegins = "Begin Countdown"
L.countdownBegins_desc = "Choose how much time should be remaining on the pull timer (in seconds) when the countdown begins."
L.pullExplainer = "\n|cFF33FF99/pull|r will start a normal pull timer.\n|cFF33FF99/pull 7|r will start a 7 second pull timer, you can use any number.\nAlternatively, you can also set a keybinding below.\n\n"
L.pullKeybindingDesc = "Choose a keybinding for starting a pull timer."

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
L.privateaura = "Whenever a 'Private Aura' is on you"

L.customSoundDesc = "Play the selected custom sound instead of the one supplied by the module."
L.resetSoundDesc = "Resets the above sounds to their defaults."
L.resetAllCustomSound = "If you've customized sounds for any boss encounter settings, this button will reset ALL of them so the sounds defined here will be used instead."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossStatistics = "Boss Statistics"
L.bossStatsDescription = "Recording of various boss-related statistics such as the amount of times you were victorious, the amount of times you were defeated, date of first victory, and the fastest victory. These statistics can be viewed on each boss's configuration screen, but will be hidden for bosses that have no recorded statistics."
L.createTimeBar = "Show 'Best Time' bar"
L.bestTimeBar = "Best Time"
L.healthPrint = "Health: %s."
L.healthFormat = "%s (%.1f%%)"
L.chatMessages = "Chat Messages"
L.newFastestVictoryOption = "New fastest victory"
L.victoryOption = "You were victorious"
L.defeatOption = "You were defeated"
L.bossHealthOption = "Boss health"
L.bossVictoryPrint = "You were victorious against '%s' after %s." -- You were victorious against 'BOSS_NAME' after COMBAT_DURATION.
L.bossDefeatPrint = "You were defeated by '%s' after %s." -- You were defeated by 'BOSS_NAME' after COMBAT_DURATION.
L.newFastestVictoryPrint = "New fastest victory: (-%s)" -- New fastest victory: (-COMBAT_DURATION)

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
