local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs", "enUS", true)

-- Core.lua
L["%s has been defeated"] = true     -- "<boss> has been defeated"
L["%s have been defeated"] = true    -- "<bosses> have been defeated"
L["Bosses"] = true
L["Options for bosses in %s."] = true -- "Options for bosses in <zone>"
L["Options for %s (r%d)."] = true     -- "Options for <boss> (<revision>)"
L["Plugins"] = true
L["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = true
L["Extras"] = true
L["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = true
L["Active"] = true
L["Activate or deactivate this module."] = true
L["Reboot"] = true
L["Reboot this module."] = true
L["Options"] = true
L["Minimap icon"] = true
L["Toggle show/hide of the minimap icon."] = true
L["Advanced"] = true
L["You shouldn't really need to touch these options, but if you want to tweak them then you're welcome to do so!"] = true

L["Toggles whether or not the boss module should warn about %s."] = true
L.bosskill = "Boss death"
L.bosskill_desc = "Announce when the boss has been defeated."
L.enrage = "Enrage"
L.enrage_desc = "Warn when the boss enters an enraged state."
L.berserk = "Berserk"
L.berserk_desc = "Warn when the boss goes Berserk."

L["Load"] = true
L["Load All"] = true
L["Load all %s modules."] = true

L.already_registered = "|cffff0000WARNING:|r |cff00ff00%s|r (|cffffff00%d|r) already exists as a boss module in Big Wigs, but something is trying to register it again (at revision |cffffff00%d|r). This usually means you have two copies of this module in your addons folder due to some addon updater failure. It is recommended that you delete any Big Wigs folders you have and then reinstall it from scratch."

-- Options.lua
L["|cff00ff00Module running|r"] = true
L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them."] = true
L["Active boss modules:"] = true
L["All running modules have been reset."] = true
L["Menu"] = true
L["Menu options."] = true


