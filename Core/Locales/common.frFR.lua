local L = BigWigsAPI:NewLocale("BigWigs: Common", "frFR")
if not L then return end

L.add = "Add"
L.add_killed = "Add tué (%d/%d)"
L.add_remaining = "Add tué, il en reste %d"
L.adds = "Adds"
L.add_spawned = "Add apparu"
L.big_add = "Gros add"
L.cast = "<%s incanté>"
L.casting = "%s en incantation"
L.count = "%s (%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.custom_end = "%s devient %s"
L.custom_min = "%s dans %d min."
L.custom_sec = "%s dans %d sec."
L.custom_start = "%s engagé - %s dans %d min."
L.custom_start_s = "%s engagé - %s dans %d sec."
L.duration = "%s pendant %s sec."
L.focus_only = "|cffff0000Alertes de la cible de focalisation uniquement.|r "
L.general = "Général" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
L.heroic = "Mode héroïque"
L.incoming = "Arrivée |2 %s"
L.intermission = "Intervalle"
L.interrupted = "%s interrompu"
L.interrupted_by = "%s interrompu par %s" -- spell interrupted by player
L.mob_killed = "%s tué (%d/%d)"
L.mob_remaining = "%s tué, il en reste %d"
L.mythic = "Mode mythique"
L.near = "%s près de VOUS"
L.next_add = "Prochain Add"
L.no = "Sans %s"
L.normal = "Mode normal"
L.on = "%s sur %s"
L.onboss = "%s sur le BOSS"
L.other = "%s : %s"
L.over = "%s terminé"
L.percent = "%d%% - %s" -- 20% - spell
L.phase = "Phase %d"
L.removed = "%s enlevé"
L.removed_from = "%s enlevé de %s"
L.removed_by = "%s enlevé par %s" -- spell removed by player
L.small_adds = "Petits adds"
L.soon = "%s bientôt"
L.spawned = "%s apparu"
L.spawning = "Apparition |2 %s"
L.stack = "%dx %s sur %s"
L.stackyou = "%dx %s sur VOUS"
L.stage = "Phase %d"
L.trash = "Trash"
L.underyou = "%s en dessous de VOUS"
L.you = "%s sur VOUS"
L.you_icon = "%s sur |T13700%d:0|tVOUS"

L.active = "Actif" -- When a boss becomes active, after speech finishes

-- Common raid marking locale
L.marker = "Marquage %s"
L.marker_player_desc = "Marque les joueurs affectés par %s avec %s. Nécessite d'être assistant ou chef de raid."
L.marker_npc_desc = "Marque %s avec %s. Nécessite d'être assistant ou chef de raid."

-- Ability where two players have to move close to each other
L.link = "Lié(e) avec %s"
L.link_short = "Lié : %s"
L.link_both = "%s est lié(e) avec %s"
L.link_removed = "Lien enlevé"

-- Abbreviated numbers
L.amount_one = "%dB" -- Billions 1,000,000,000
L.amount_two = "%dM" -- Millions 1,000,000
L.amount_three = "%dK" -- Thousands 1,000
L.seconds = "%.1fs" -- 1.1 seconds
