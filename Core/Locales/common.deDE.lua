local L = BigWigsAPI:NewLocale("BigWigs: Common", "deDE")
if not L then return end

L.add = "Add"
L.add_killed = "Add getötet (%d/%d)"
L.add_remaining = "Add getötet, noch %d übrig"
L.adds = "Adds"
L.add_spawned = "Add erschienen"
L.big_add = "Großes Add"
L.cast = "<Wirkt %s>"
L.casting = "Wirkt %s"
L.count = "%s (%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.custom_end = "%s wird zum %s"
L.custom_min = "%s in %d Min"
L.custom_sec = "%s in %d Sek"
L.custom_start = "%s angegriffen – %s in %d Min"
L.custom_start_s = "%s angegriffen – %s in %d Sek"
L.duration = "%s für %s sec"
L.focus_only = "|cffff0000Warnungen nur für Fokusziel.|r "
L.general = "Allgemein" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
L.heroic = "Heroischer Modus"
L.incoming = "%s steht bevor"
L.intermission = "Zwischenphase"
L.interrupted = "%s unterbrochen"
L.interrupted_by = "%s wurde von %s unterbrochen" -- spell interrupted by player
L.mob_killed = "%s getötet (%d/%d)"
L.mob_remaining = "%s getötet, noch %d übrig"
L.mythic = "Mythischer Modus"
L.near = "%s in DEINER Nähe"
L.next_add = "Nächstes Add"
L.no = "Kein %s"
L.normal = "Normaler Modus"
L.on = "%s auf %s"
L.onboss = "%s auf dem BOSS"
L.other = "%s: %s"
L.over = "%s vorbei"
L.percent = "%d%% - %s" -- 20% - spell
L.phase = "Phase %d"
L.removed = "%s entfernt"
L.removed_from = "%s wurde von %s entfernt"
L.removed_by = "%s wurde durch %s entfernt" -- spell removed by player
L.small_adds = "Kleine Adds"
L.soon = "%s bald"
L.spawned = "%s erschienen"
L.spawning = "%s entsteht"
L.stack = "%dx %s auf %s"
L.stackyou = "%dx %s auf DIR"
L.stage = "Phase %d"
L.trash = "Trash"
L.underyou = "%s unter DIR"
L.you = "%s auf DIR"
L.you_icon = "%s auf |T13700%d:0|tDIR"

L.active = "Aktiv" -- When a boss becomes active, after speech finishes

-- Common raid marking locale
L.marker = "%s markieren"
L.marker_player_desc = "Markiert Spieler, die von %s betroffen sind, mit %s. Benötigt Leiter oder Assistent."
L.marker_npc_desc = "Markiert %s mit %s. Benötigt Leiter oder Assistent."

-- Ability where two players have to move close to each other
L.link = "Verbunden mit %s"
L.link_short = "Verbunden: %s"
L.link_both = "%s verbunden mit %s"
L.link_removed = "Verbindung entfernt"

-- Abbreviated numbers
L.amount_one = "%dB" -- Billions 1,000,000,000
L.amount_two = "%dM" -- Millions 1,000,000
L.amount_three = "%dK" -- Thousands 1,000
--L.seconds = "%.1fs" -- 1.1 seconds
