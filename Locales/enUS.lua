local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs", "enUS", true, "raw")

-- Core.lua
L["%s has been defeated"] = true

L.bosskill = "Boss death"
L.bosskill_desc = "Announce when the boss has been defeated."
L.berserk = "Berserk"
L.berserk_desc = "Show a bar and timed warnings for when the boss will go berserk."
L.stages = "Stages"
L.stages_desc = "Enable functions related to the various stages/phases of the boss like proximity, bars, etc."

L.already_registered = "|cffff0000WARNING:|r |cff00ff00%s|r (|cffffff00%s|r) already exists as a module in Big Wigs, but something is trying to register it again. This usually means you have two copies of this module in your addons folder due to some addon updater failure. It is recommended that you delete any Big Wigs folders you have and then reinstall it from scratch."

-- Loader / Options.lua
L["You are running an official release of Big Wigs %s (revision %d)"] = true
L["You are running an ALPHA RELEASE of Big Wigs %s (revision %d)"] = true
L["You are running a source checkout of Big Wigs %s directly from the repository."] = true
L["There is a new release of Big Wigs available (/bwv). You can visit curse.com, wowinterface.com, wowace.com or use the Curse Updater to get the new release."] = true
L["Your alpha version of Big Wigs is out of date (/bwv)."] = true

L.tooltipHint = "|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fRight-Click|r to access options."
L["Active boss modules:"] = true
L["All running modules have been reset."] = true
L["All running modules have been disabled."] = true

L["There are people in your group with older versions or without Big Wigs. You can get more details with /bwv."] = true
L["Up to date:"] = true
L["Out of date:"] = true
L["No Big Wigs 3.x:"] = true

L["Waiting until combat ends to finish loading due to Blizzard combat restrictions."] = true
L["Combat has ended, Big Wigs has now finished loading."] = true
L["Due to Blizzard restrictions the config must first be opened out of combat, before it can be accessed in combat."] = true

L["Please note that this zone requires the -[[|cFF436EEE%s|r]]- plugin for timers to be displayed."] = true

L.coreAddonDisabled = "Big Wigs won't function properly since the addon %s is disabled. You can enable it from the addon control panel at the character selection screen."

-- Options.lua
L["Customize ..."] = true
L["Profiles"] = true
L.introduction = "Welcome to Big Wigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group."
L["Configure ..."] = true
L.configureDesc = "Closes the interface options window and lets you configure displays for things like bars and messages.\n\nIf you want to customize more behind-the-scenes things, you can expand Big Wigs in the left tree and find the 'Customize ...' subsection."
L["Sound"] = true
L.soundDesc = "Messages might come with a sound. Some people find it easier to listen for these after they've learned which sound goes with which message, as opposed to reading the actual messages.\n\n|cffff4411Even when off, the default raid warning sound might be played by incoming raid warnings from other players. That sound, however, is different from the sounds we use.|r"
L["Show Blizzard warnings"] = true
L.blizzardDesc = "Blizzard provides their own messages for some abilities on some encounters. In our opinion, these messages are both way too long and descriptive. We try to produce smaller, more fitting messages that do not interfere with the gameplay, and that don't tell you specifically what to do.\n\n|cffff4411When off, Blizzards warnings will not be shown in the middle of the screen, but they will still show in your chat frame.|r"
L["Flash Screen"] = true
L.flashDesc = "Certain abilities are important enough to need your full attention. When these abilities affect you Big Wigs can flash the screen."
L["Raid icons"] = true
L.raidiconDesc = "Some encounter scripts use raid icons to mark players that are of special interest to your group. For example 'bomb'-type effects and mind control. If you turn this off, you won't mark anyone.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r"
L["Minimap icon"] = true
L["Toggle show/hide of the minimap icon."] = true
L["Configure"] = true
L["Test"] = true
L["Reset positions"] = true
L["Colors"] = true
L["Select encounter"] = true
L["List abilities in group chat"] = true
L["Block boss movies"] = true
L["After you've seen a boss movie once, Big Wigs will prevent it from playing again."] = true
L["Prevented boss movie '%d' from playing."] = true
L["Pretend I'm using DBM"] = true
L.pretendDesc = "If a DBM user does a version check to see who's using DBM, they will see you on the list. Useful for guilds that force using DBM."
L["Create custom DBM bars"] = true
L.dbmBarDesc = "If a DBM user sends a pull timer or a custom 'pizza' bar, it will be shown in Big Wigs."
L.chatMessages = "Chat frame messages"
L.chatMessagesDesc = "Outputs all BigWigs messages to the default chat frame in addition to the display setting."

L.slashDescTitle = "|cFFFED000Slash Commands:|r"
L.slashDescPull = "|cFFFED000/pull:|r Sends a pull countdown to your raid."
L.slashDescRaidBar = "|cFFFED000/raidbar:|r Sends a custom bar to your raid."
L.slashDescLocalBar = "|cFFFED000/localbar:|r Creates a custom bar only you can see."
L.slashDescRange = "|cFFFED000/range:|r Opens the range indicator."
L.slashDescVersion = "|cFFFED000/bwv:|r Performs a Big Wigs version check."
L.slashDescConfig = "|cFFFED000/bw:|r Opens the Big Wigs configuration."

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
L.MESSAGE_desc = "Most encounter abilities come with one or more messages that Big Wigs will show on your screen. If you disable this option, none of the messages attached to this option, if any, will be displayed."
L.BAR_desc = "Bars are shown for some encounter abilities when appropriate. If this ability is accompanied by a bar that you want to hide, disable this option."
L.FLASH_desc = "Some abilities might be more important than others. If you want your screen to flash when this ability is imminent or used, check this option."
L.ICON_desc = "Big Wigs can mark characters affected by abilities with an icon. This makes them easier to spot."
L.SAY_desc = "Chat bubbles are easy to spot. Big Wigs will use a say message to announce people nearby about an effect on you."
L.EMPHASIZE_desc = "Enabling this will SUPER EMPHASIZE any messages or bars associated with this encounter ability. Messages will be bigger, bars will flash and have a different color, sounds will be used to count down when the ability is imminent. Basically you will notice it."
L.PROXIMITY = "Proximity display"
L.PROXIMITY_desc = "Abilities will sometimes require you to spread out. The proximity display will be set up specifically for this ability so that you will be able to tell at-a-glance whether or not you are safe."
L.TANK = "Tank Only"
L.TANK_desc = "Some abilities are only important for tanks. If you want to see warnings for this ability regardless of your role, disable this option."
L.HEALER = "Healer Only"
L.HEALER_desc = "Some abilities are only important for healers. If you want to see warnings for this ability regardless of your role, disable this option."
L.TANK_HEALER = "Tank & Healer Only"
L.TANK_HEALER_desc = "Some abilities are only important for tanks and healers. If you want to see warnings for this ability regardless of your role, disable this option."
L.DISPEL = "Dispeller Only"
L.DISPEL_desc = "If you want to see warnings for this ability even when you cannot dispel it, disable this option."
L["Advanced options"] = true
L["<< Back"] = true

L.tank = "|cFFFF0000Tank alerts only.|r "
L.healer = "|cFFFF0000Healer alerts only.|r "
L.tankhealer = "|cFFFF0000Tank & Healer alerts only.|r "
L.dispeller = "|cFFFF0000Dispeller alerts only.|r "

L.About = "About"
L.Developers = "Developers"
L.Maintainers = "Maintainers"
L.License = "License"
L.Website = "Website"
L.Contact = "Contact"
L["See license.txt in the main Big Wigs folder."] = true
L["irc.freenode.net in the #wowace channel"] = true
L["Thanks to the following for all their help in various fields of development"] = true

-- Statistics
L.statistics = "Statistics"
L.norm25 = "25"
L.heroic25 = "25h"
L.norm10 = "10"
L.heroic10 = "10h"
L.lfr = "LFR"
L.wipes = "Wipes:"
L.kills = "Kills:"
L.bestkill = "Best Kill:"

