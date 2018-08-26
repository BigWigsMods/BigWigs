local L = BigWigsAPI:NewLocale("BigWigs: Common", "esES") or BigWigsAPI:NewLocale("BigWigs: Common", "esMX")
if not L then return end

L.add = "Esbirro"
L.add_killed = "Esbirro muerto (%d/%d)"
L.add_remaining = "Esbirro muerto, %d restantes"
L.adds = "Esbirros"
L.add_spawned = "Aparece Esbirro"
L.big_add = "Esbirro grande"
L.cast = "<Lanza %s>"
L.casting = "Lanzando %s"
L.count = "%s (%d)"
L.count_icon = "%s (%d|T13700%d:0|t)"
L.count_rticon = "%s (%d{rt%d})"
L.custom_end = "%s entra en %s"
L.custom_min = "%s en %d min"
L.custom_sec = "%s en %d seg"
L.custom_start = "%s iniciado - %s en %d min"
L.custom_start_s = "%s iniciado - %s en %d seg"
L.duration = "%s durante %s sec"
L.focus_only = "|cffff0000Alertas sólo para objetivos en Foco.|r "
L.general = "General" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
L.heroic = "Modo heroico"
L.incoming = "%s inminente"
L.intermission = "Intermedio"
L.interrupted = "%s interrumpido"
L.interrupted_by = "%s interrupido por %s" -- hechizo interrumpido por jugador
L.mob_killed = "%s muerto (%d/%d)"
L.mob_remaining = "%s muerto, %d restantes"
L.mythic = "Modo mítico"
L.near = "%s cerca de TI"
L.next_add = "Siguiente Esbirro"
L.no = "No %s"
L.normal = "Modo normal"
L.on = "%s en %s"
L.onboss = "%s en el JEFE"
L.other = "%s: %s"
L.over = "%s terminado"
L.percent = "%d%% - %s" -- 20% - spell
L.phase = "Fase %d"
L.removed = "%s eliminado"
L.removed_from = "%s eliminado de %s"
L.removed_by = "%s eliminado por %s" -- hechizo eliminado por jugador
L.small_adds = "Esbirros pequeños"
L.soon = "%s pronto"
L.spawned = "%s Apareció"
L.spawning = "%s aparece"
L.stack = "%dx %s en %s"
L.stackyou = "%dx %s en TI"
L.stage = "Fase %d"
L.trash = "Basura"
L.underyou = "%s debajo de TI"
L.you = "%s en TI"

L.active = "Activo" -- Cuando un jefe se activa, después de que acabe el diálogo

-- Common raid marking locale
L.marker = "%s Marcador"
L.marker_player_desc = "Marca jugadores afectados por %s con %s, requiere ayudante o líder."
L.marker_npc_desc = "Marca %s con %s, requiere ayudante o líder."

-- Ability where two players have to move close to each other
L.link = "Enlazado con %s"
L.link_short = "Enlazado: %s"
L.link_both = "%s enlazado con %s"
L.link_removed = "Enlace eliminado"

-- Abbreviated numbers
L.amount_one = "%dB"
L.amount_two = "%dM"
L.amount_three = "%dK"
