local L = BigWigs:NewBossLocale("Shriekwing", "esMX")
if not L then return end
if L then
	L.pickup_lantern = "%s recogió la linterna!"
	L.dropped_lantern = "Linterna soltada por %s!"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "esMX")
if L then
	L.killed = "%s Muerto"
end

L = BigWigs:NewBossLocale("Sun King's Salvation", "esMX")
if L then
	L.shield_removed = "%s removido después de %.1fs" -- "Shield removed after 1.1s" s = seconds
	L.shield_remaining = "%s restante: %s (%.1f%%)" -- "Shield remaining: 2.1K (5.3%)"
end

L = BigWigs:NewBossLocale("Hungering Destroyer", "esMX")
if L then
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	L.custom_on_repeating_yell_miasma = "Repetir alerta de vida de Miasma en /gritar"
	L.custom_on_repeating_yell_miasma_desc = "Repite en /gritar mensajes para Miasma Glotona for Gluttonous Miasma para que los demás sepan cuando estás por debajo del 75% de salud."

	L.custom_on_repeating_say_laser = "Repeating Volatile Ejection Say"
	L.custom_on_repeating_say_laser_desc = "Repeating en /decir mensajes para for Eyección volátil para ayudar al entrar en el rango de chat de los jugadores que no vieron tu primer mensaje."

	L.tempPrint = "Hemos añadido alertas de /gritar para alertar la salud para Miasma. Si antes usabas un WeakAura para esto, es posible que quieras eliminarla para evitar mensajes repetiros en /gritar."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "esMX")
if L then
	L.tear = "Ruptura" -- Short for Dimensional Tear
	L.spirits = "Espíritus" -- Short for Fleeting Spirits
	L.seeds = "Semillas" -- Short for Seeds of Extinction
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "esMX")
if L then
	L.times = "%dx %s"

	L.level = "%s (Nivel |cffffff00%d|r)"
	L.full = "%s (|cffff0000LLENO|r)"

	L.anima_adds = "Esbirros de ánima concentrada"
	L.anima_adds_desc = "Muestra un temporizador cuando los esbirros aparecen del debuff de Ánima Concentrada."

	L.custom_off_experimental = "Habilitar funcionalidades experimentales"
	L.custom_off_experimental_desc = "Estas funcionalidades |cffff0000no fueron probadas|r y pueden causar |cffff0000spam|r."

	L.anima_tracking = "Rastreo de Anima |cffff0000(Experimental)|r"
	L.anima_tracking_desc = "Mensajes y barras para rastrear los niveles de anima en los contenedores.|n|cffaaff00Consejo: Puede que quieras deshabilitar el cuadro o las barras de información, dependiendo de tu preferencia."

	L.custom_on_stop_timers = "Siempre mostrar las barras de habilidad"
	L.custom_on_stop_timers_desc = "Sólo para pruebas por el momento"

	L.desires = "Deseos"
	L.bottles = "Botellas"
	L.sins = "Pecados"
end

L = BigWigs:NewBossLocale("The Council of Blood", "esMX")
if L then
	L.custom_on_repeating_dark_recital = "Repetir Recital Oscuro"
	L.custom_on_repeating_dark_recital_desc = "Repite mensajes en decir para la habilidad Recital oscuro con íconos {rt1}, {rt2} para que encuentres a tu pareja mientras danzas."

	L.custom_off_select_boss_order = "Marcar orden de asesinato del Jefe"
	L.custom_off_select_boss_order_desc = "Marca el orden en que la banda matará a los jefes con una X {rt7}. Requiere ayudante o líder para marcar."
	L.custom_off_select_boss_order_value1 = "Niklaus -> Frida -> Stavros"
	L.custom_off_select_boss_order_value2 = "Frida -> Niklaus -> Stavros"
	L.custom_off_select_boss_order_value3 = "Stavros -> Niklaus -> Frida"
	L.custom_off_select_boss_order_value4 = "Niklaus -> Stavros -> Frida"
	L.custom_off_select_boss_order_value5 = "Frida -> Stavros -> Niklaus"
	L.custom_off_select_boss_order_value6 = "Stavros -> Frida -> Niklaus"

	L.dance_assist = "Asistente de danza"
	L.dance_assist_desc = "Muestra advertencias direccionales para la fase de baile."
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t Baila hacia adelante |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t Baila a la derecha |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t Baila hacia abajo |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t Baila a la izquierda |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "Un paso al frente" -- Prance Forward!
	L.dance_yell_right = "Hombros a la derecha" -- Shimmy right!
	L.dance_yell_down = "A bailar" -- Boogie down! // Yelled by Niklaus & Frieda
	L.dance_yell_down_2 = "A mover las caderas" -- Boogie down! // Yelled by Stavros
	L.dance_yell_left = "Chassé a la izquierda" -- Sashay left!
end

L = BigWigs:NewBossLocale("Sludgefist", "esMX")
if L then
	L.stomp_shift = "Pisotón & Falla" -- Destructive Stomp + Seismic Shift

	L.fun_info = "Información de daño"
	L.fun_info_desc = "Muestra un mensaje que indica cuánta salud perdió el jefe durante Impacto Destructivo."

	L.health_lost = "Fangopuño perdió %.1f%%!"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "esMX")
if L then
	L.first_blade = "Primera Cuchilla"
	L.second_blade = "Segunda cuchilla"

	L.skirmishers = "Comandos" -- Short for Stone Legion Skirmishers
	L.eruption = "Erupción" -- Short for Reverberating Eruption

	L.custom_on_stop_timers = "Siempre mostrar las barras de habilidad"
	L.custom_on_stop_timers_desc = "Sólo para pruebas por el momento"

	L.goliath_short = "Goliat"
	L.goliath_desc = "Muestra avisos y temporizadores para cuando el Goliat de la Legión Pétrea está apunto de aparecer."

	L.commando_short = "Comando"
	L.commando_desc = "Muestra avisos cuando un Comando de la Legión Pétrea es eliminado."
end

L = BigWigs:NewBossLocale("Sire Denathrius", "esMX")
if L then
	L.infobox_stacks = "%d |4Acumulación:Acumulaciones;: %d |4jugador:jugadores;" -- 4 Stacks: 5 players // 1 Stack: 1 player

	L.custom_on_repeating_nighthunter = "Repetir gritar Cazador nocturno"
	L.custom_on_repeating_nighthunter_desc = "Repite mensajes en gritar para la habilidad Cazador nocturno utilizando íconos {rt1} o {rt2} o {rt3} para encontrar tu línea más fácilmente si tienes que hacer soak."

	L.custom_on_repeating_impale = "Repetir decir Empalar"
	L.custom_on_repeating_impale_desc = "Repite mensajes en decir para la habilidad empalar utilizando '1' or '22' or '333' or '4444' para dejar claro en qué orden te afectará."

	L.hymn_stacks = "Himno nathriano"
	L.hymn_stacks_desc = "Alerta el número de acumulaciones actuales de Himno nathriano en ti."

	L.ravage_target = "Reflejo: Devastar Barra de lanzamiento"
	L.ravage_target_desc = "Barra de lanzamiento que muestra el tiempo hasta que el reflejo apunta a un lugar para Devastar."
	L.ravage_targeted = "Destrozar dirigido" -- Text on the bar for when Ravage picks its location to target in stage 3

	L.no_mirror = "Sin espejo: %d" -- Player amount that does not have the Through the Mirror
	L.mirror = "Espejo: %d" -- Player amount that does have the Through the Mirror
end

L = BigWigs:NewBossLocale("Castle Nathria Trash", "esMX")
if L then
	--[[ Pre Shriekwing ]]--
	L.moldovaak = "Moldovaak"
	L.caramain = "Caramain"
	L.sindrel = "Sindrel"
	L.hargitas = "Hargitas"

	--[[ Shriekwing -> Huntsman Altimor ]]--
	L.gargon = "Gargon descomunal"
	L.hawkeye = "Ojohalcón de Nathria"
	L.overseer = "Sobrestante de perrera"

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	L.feaster = "Descarnador aterrador"
	L.rat = "Rata de tamaño inusual"
	L.miasma = "Miasma" -- Short for Gluttonous Miasma

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	L.deplina = "Deplina"
	L.dragost = "Dragost"
	L.kullan = "Kullan"

	--[[ Shriekwing -> Xy'mox ]]--
	L.antiquarian = "Anticuaria siniestra"
	L.conservator = "Conservador de Nathria"
	L.archivist = "Archivista de Nathria"
	L.hierarch = "Jerarca de la corte"

	--[[ Sludgefist -> Stone Legion Generals ]]--
	L.goliath = "Goliat de la Legión Pétrea"
end
