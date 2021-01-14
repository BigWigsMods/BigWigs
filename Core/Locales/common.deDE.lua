local L = BigWigsAPI:NewLocale("BigWigs: Common", "deDE")
if not L then return end

-- Prototype.lua common words
L.you = "%s auf DIR"
L.you_icon = "%s auf |T13700%d:0|tDIR"
L.underyou = "%s unter DIR"
L.other = "%s: %s"
L.onboss = "%s auf dem BOSS"
L.buff_boss = "Buff auf BOSS: %s"
L.buff_other = "Buff auf %s: %s"
L.on = "%s auf %s"
L.stack = "%dx %s auf %s"
L.stackyou = "%dx %s auf DIR"
L.cast = "<Wirkt %s>"
L.casting = "Wirkt %s"
L.soon = "%s bald"
L.count = "%s (%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.near = "%s in DEINER Nähe"
L.on_group = "%s auf GRUPPE"

L.phase = "Phase %d"
L.stage = "Phase %d"
L.normal = "Normaler Modus"
L.heroic = "Heroischer Modus"
L.mythic = "Mythischer Modus"
L.active = "Aktiv" -- When a boss becomes active, after speech finishes
L.general = "Allgemein" -- General settings, i.e. things that apply to normal, heroic and mythic mode.

L.duration = "%s für %s Sek"
L.over = "%s vorbei"
L.removed = "%s entfernt"
L.removed_from = "%s wurde von %s entfernt"
L.removed_by = "%s wurde durch %s entfernt" -- spell removed by player
L.incoming = "%s steht bevor"
L.interrupted = "%s unterbrochen"
L.interrupted_by = "%s wurde von %s unterbrochen" -- spell interrupted by player
L.no = "Kein %s"
L.intermission = "Zwischenphase"
L.percent = "%d%% - %s" -- 20% - spell

-- Add related
L.add_spawned = "Add erschienen"
L.spawned = "%s erschienen"
L.spawning = "%s entsteht"
L.next_add = "Nächstes Add"
L.add_killed = "Add getötet (%d/%d)"
L.add_remaining = "Add getötet, noch %d übrig"
L.add = "Add"
L.adds = "Adds"
L.big_add = "Großes Add" -- singular
L.big_adds = "Große Adds" -- plural
L.small_add = "Kleines Add" -- singular
L.small_adds = "Kleine Adds" -- plural

-- Mob related
L.mob_killed = "%s getötet (%d/%d)"
L.mob_remaining = "%s getötet, noch %d übrig"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%s angegriffen – %s in %d Min"
L.custom_start_s = "%s angegriffen – %s in %d Sek"
L.custom_end = "%s wird zum %s"
L.custom_min = "%s in %d Min"
L.custom_sec = "%s in %d Sek"

L.focus_only = "|cffff0000Warnungen nur für Fokusziel.|r "
L.trash = "Trash"

-- Common raid marking locale
L.marker = "%s markieren"
L.marker_player_desc = "Markiert Spieler, die von %s betroffen sind, mit %s. Benötigt Leiter oder Assistent."
L.marker_npc_desc = "Markiert %s mit %s. Benötigt Leiter oder Assistent."

-- Ability where two players have to move close to each other
--L.link = "Link"
L.link_with = "Verbunden mit %s"
L.link_short = "Verbunden: %s"
L.link_both = "%s verbunden mit %s"
L.link_removed = "Verbindung entfernt"

-- Abbreviated numbers
L.amount_one = "%dB" -- Billions 1,000,000,000
L.amount_two = "%dM" -- Millions 1,000,000
L.amount_three = "%dK" -- Thousands 1,000
L.seconds = "%.1fs" -- 1.1 seconds

-- Common ability name replacements
L.laser = "Laser" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.bomb = "Bombe" -- Used for debuffs that make players explode
L.fixate = "Fixieren" -- Used when a boss or add is chasing/fixated on a player
