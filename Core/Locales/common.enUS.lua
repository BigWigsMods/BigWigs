local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs: Common", "enUS", true, "raw")

-- Prototype.lua common words
L.you = "%s on YOU!"
L.underyou = "%s under YOU!"
L.other = "%s: %s"
L.onboss = "%s on BOSS!"
L.on = "%s on %s"
L.stack = "%dx %s on %s"
L.stackyou = "%dx %s on YOU"
L.cast = "<Cast: %s>"
L.casting = "Casting %s!"
L.soon = "%s soon!"
L.count = "%s (%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.near = "%s near YOU!"

L.phase = "Phase %d"
L.stage = "Stage %d"
L.normal = "Normal mode"
L.heroic = "Heroic mode"
L.hard = "Hard mode"
L.mythic = "Mythic mode"
L.general = "General" -- General settings, i.e. things that apply to normal, heroic and mythic mode.

L.duration = "%s for %s sec"
L.over = "%s Over!"
L.removed = "%s Removed"
L.incoming = "%s Incoming!"
L.interrupted = "%s Interrupted"
L.no = "No %s!"
L.intermission = "Intermission"

-- Add related
L.add_spawned = "Add Spawned!"
L.spawned = "%s Spawned"
L.spawning = "%s Spawning!"
L.next_add = "Next Add"
L.add_killed = "Add killed! (%d/%d)"
L.add_remaining = "Add killed, %d remaining"
L.add = "Add"
L.adds = "Adds"
L.big_add = "Big Add"
L.small_adds = "Small Adds"

-- Mob related
L.mob_killed = "%s killed! (%d/%d)"
L.mob_remaining = "%s killed, %d remaining"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%s engaged - %s in %d min"
L.custom_start_s = "%s engaged - %s in %d sec"
L.custom_end = "%s goes %s!"
L.custom_min = "%s in %d min"
L.custom_sec = "%s in %d sec!"

L.focus_only = "|cffff0000Focus target alerts only.|r "
L.trash = "Trash"

-- Common raid marking locale
L.marker = "%s Marker"
L.marker_player_desc = "Mark players affected by %s with %s, requires promoted or leader."
L.marker_npc_desc = "Mark %s with %s, requires promoted or leader."
