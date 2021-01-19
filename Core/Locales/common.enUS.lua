local L = BigWigsAPI:NewLocale("BigWigs: Common", "enUS")

-- Prototype.lua common words
L.you = "%s on YOU"
L.you_icon = "%s on |T13700%d:0|tYOU"
L.underyou = "%s under YOU"
L.other = "%s: %s"
L.onboss = "%s on BOSS"
L.buff_boss = "Buff on BOSS: %s"
L.buff_other = "Buff on %s: %s"
L.on = "%s on %s"
L.stack = "%dx %s on %s"
L.stackyou = "%dx %s on YOU"
L.cast = "<Cast: %s>"
L.casting = "Casting %s"
L.soon = "%s soon"
L.count = "%s (%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.near = "%s near YOU"
L.on_group = "%s on GROUP"

L.phase = "Phase %d"
L.stage = "Stage %d"
L.normal = "Normal mode"
L.heroic = "Heroic mode"
L.mythic = "Mythic mode"
L.active = "Active" -- When a boss becomes active, after speech finishes
L.general = "General" -- General settings, i.e. things that apply to normal, heroic and mythic mode.

L.duration = "%s for %s sec"
L.over = "%s Over"
L.removed = "%s Removed"
L.removed_from = "%s Removed From %s"
L.removed_by = "%s removed by %s" -- spell removed by player
L.incoming = "%s Incoming"
L.interrupted = "%s Interrupted"
L.interrupted_by = "%s interrupted by %s" -- spell interrupted by player
L.no = "No %s"
L.intermission = "Intermission"
L.percent = "%d%% - %s" -- 20% - spell

-- Add related
L.add_spawned = "Add Spawned"
L.spawned = "%s Spawned"
L.spawning = "%s Spawning"
L.next_add = "Next Add"
L.add_killed = "Add killed (%d/%d)"
L.add_remaining = "Add killed, %d remaining"
L.add = "Add"
L.adds = "Adds"
L.big_add = "Big Add" -- singular
L.big_adds = "Big Adds" -- plural
L.small_add = "Small Add" -- singular
L.small_adds = "Small Adds" -- plural

-- Mob related
L.mob_killed = "%s killed (%d/%d)"
L.mob_remaining = "%s killed, %d remaining"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%s engaged - %s in %d min"
L.custom_start_s = "%s engaged - %s in %d sec"
L.custom_end = "%s goes %s"
L.custom_min = "%s in %d min"
L.custom_sec = "%s in %d sec"

L.focus_only = "|cffff0000Focus target alerts only.|r "
L.trash = "Trash"

-- Common raid marking locale
L.marker = "%s Marker"
L.marker_player_desc = "Mark players affected by %s with %s, requires promoted or leader."
L.marker_npc_desc = "Mark %s with %s, requires promoted or leader."

-- Ability where two players have to move close to each other
L.link = "Link"
L.link_with = "Linked with %s"
L.link_with_icon = "Linked with |T13700%d:0|t%s"
L.link_short = "Linked: %s"
L.link_both = "%s linked with %s"
L.link_removed = "Link removed"

-- Abbreviated numbers
L.amount_one = "%dB" -- Billions 1,000,000,000
L.amount_two = "%dM" -- Millions 1,000,000
L.amount_three = "%dK" -- Thousands 1,000
L.seconds = "%.1fs" -- 1.1 seconds

-- Common ability name replacements
L.laser = "Laser" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.bomb = "Bomb" -- Used for debuffs that make players explode
L.fixate = "Fixate" -- Used when a boss or add is chasing/fixated on a player
L.knockback = "Knockback" -- Used when an abily knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.traps = "Traps" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
