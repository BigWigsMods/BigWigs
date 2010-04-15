local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs", "enUS", true, true)

-- Core.lua
L["%s has been defeated"] = true

L.bosskill = "Boss death"
L.bosskill_desc = "Announce when the boss has been defeated."
L.berserk = "Berserk"
L.berserk_desc = "Show a timer bar for and timed warnings for when the boss will go berserk."

L.already_registered = "|cffff0000WARNING:|r |cff00ff00%s|r (|cffffff00%s|r) already exists as a module in Big Wigs, but something is trying to register it again. This usually means you have two copies of this module in your addons folder due to some addon updater failure. It is recommended that you delete any Big Wigs folders you have and then reinstall it from scratch."

-- Loader / Options.lua
L["You are running an official release of Big Wigs %s (revision %d)"] = true
L["You are running an ALPHA RELEASE of Big Wigs %s (revision %d)"] = true
L["You are running a source checkout of Big Wigs %s directly from the repository."] = true
L["There is a new release of Big Wigs available. You can visit curse.com, wowinterface.com, wowace.com or use the Curse Updater to get the new release."] = true

L.tooltipHint = "|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fRight-Click|r to access options."
L["Active boss modules:"] = true
L["All running modules have been reset."] = true
L["All running modules have been disabled."] = true

L["There are people in your group with older versions or without Big Wigs. You can get more details with /bwv."] = true
L["Up to date:"] = true
L["Out of date:"] = true
L["No Big Wigs 3.x:"] = true

-- Options.lua
L["Big Wigs Encounters"] = true
L["Customize ..."] = true
L["Profiles"] = true
L.introduction = "Welcome to Big Wigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group."
L["Configure ..."] = true
L.configureDesc = "Closes the interface options window and lets you configure displays for things like bars and messages.\n\nIf you want to customize more behind-the-scenes things, you can expand Big Wigs in the left tree and find the 'Customize ...' subsection."
L["Sound"] = true
L.soundDesc = "Messages might come with a sound. Some people find it easier to listen for these after they've learned which sound goes with which message, as opposed to reading the actual messages.\n\n|cffff4411Even when off, the default raid warning sound might be played by incoming raid warnings from other players. That sound, however, is different from the sounds we use.|r"
L["Show Blizzard warnings"] = true
L.blizzardDesc = "Blizzard provides their own messages for some abilities on some encounters. In our opinion, these messages are both way too long and descriptive. We try to produce smaller, more fitting messages that do not interfere with the gameplay, and that don't tell you specifically what to do.\n\n|cffff4411When off, Blizzards warnings will not be shown in the middle of the screen, but they will still show in your chat frame.|r"
L["Show addon warnings"] = true
L.addonwarningDesc = "Big Wigs and other boss encounter addons can broadcast their messages to the group over the raid warning channel. These messages are typically wrapped in three stars (***), which is what Big Wigs looks for when deciding if it should block a message or not.\n\n|cffff4411Turning this option on can result in lots of spam and is not recommended.|r"
L["Flash and shake"] = true
L["Flash"] = true
L["Shake"] = true
L.fnsDesc = "Certain abilities are important enough to need your full attention. When these abilities affect you Big Wigs can flash and shake the screen.\n\n|cffff4411If you are playing with the nameplates turned on the shaking function will not work due to Blizzard restrictions, the screen will only flash then.|r"
L["Raid icons"] = true
L.raidiconDesc = "Some encounter scripts use raid icons to mark players that are of special interest to your group. For example 'bomb'-type effects and mind control. If you turn this off, you won't mark anyone.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r"
L["Whisper warnings"] = true
L.whisperDesc = "Send a whisper notification to fellow players about certain encounter abilities that affect them. Think 'bomb'-type effects and such.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r"
L["Broadcast"] = true
L.broadcastDesc = "Broadcast all messages from Big Wigs to the raid warning channel.\n\n|cffff4411In raids this only applies if you're promoted, but in parties it will work regardless.|r"
L["Raid channel"] = true
L["Use the raid channel instead of raid warning for broadcasting messages."] = true
L["Minimap icon"] = true
L["Toggle show/hide of the minimap icon."] = true
L["Configure"] = true
L["Test"] = true
L["Reset positions"] = true
L["Options for %s."] = true -- XXX used ?
L["Colors"] = true
L["Select encounter"] = true

L["BAR"] = "Bars"
L["MESSAGE"] = "Messages"
L["ICON"] = "Icon"
L["WHISPER"] = "Whisper"
L["SAY"] = "Say"
L["FLASHSHAKE"] = "Flash'n'shake"
L["PING"] = "Ping"
L["EMPHASIZE"] = "Emphasize"
L["MESSAGE_desc"] = "Most encounter abilities come with one or more messages that Big Wigs will show on your screen. If you disable this option, none of the messages attached to this option, if any, will be displayed."
L["BAR_desc"] = "Bars are shown for some encounter abilities when appropriate. If this ability is accompanied by a bar that you want to hide, disable this option."
L["FLASHSHAKE_desc"] = "Some abilities might be more important than others. If you want your screen to flash and shake when this ability is imminent or used, check this option."
L["ICON_desc"] = "Big Wigs can mark characters affected by abilities with an icon. This makes them easier to spot."
L["WHISPER_desc"] = "Some effects are important enough that Big Wigs will send a whisper to the affected person."
L["SAY_desc"] = "Chat bubbles are easy to spot. Big Wigs will use a say message to announce people nearby about an effect on you."
L["PING_desc"] = "Sometimes locations can be important, Big Wigs will ping the minimap so people know where you are."
L["EMPHASIZE_desc"] = "Enabling this will SUPER EMPHASIZE any messages or bars associated with this encounter ability. Messages will be bigger, bars will flash and have a different color, sounds will be used to count down when the ability is imminent. Basically you will notice it."
L["Advanced options"] = true
L["<< Back"] = true

L["About"] = true
L["Main Developers"] = true
L["Maintainers"] = true
L["License"] = true
L["Website"] = true
L["Contact"] = true
L["See license.txt in the main Big Wigs folder."] = true
L["irc.freenode.net in the #wowace channel"] = true
L["Thanks to the following for all their help in various fields of development"] = true
