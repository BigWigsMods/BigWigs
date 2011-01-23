local L = BigWigs:NewBossLocale("Atramedes", "esES")
if L then
	L.tracking_me = "Tracking on ME!"

	L.ground_phase = "Fase en tierra"
	L.ground_phase_desc = "Aviso cuando Atramedes aterriza."
	L.air_phase = "Fase aérea"
	L.air_phase_desc = "Aviso cuando Atramedes despega."

	L.air_phase_trigger = "Yes, run! With every step your heart quickens. The beating, loud and thunderous... Almost deafening. You cannot escape!"

	L.sonicbreath_cooldown = "~Aliento sónico"
end

L = BigWigs:NewBossLocale("Chimaeron", "esES")
if L then
	L.bileotron_engage = "El Bilistrón se activa y empieza a emitir una sustancia de olor asqueroso."
	L.win_trigger = "El Bilistrón hace señales afirmativas y se apaga de forma permanente."	

	L.next_system_failure = "Siguiente fallo del sistema"
	L.break_message = "%2$dx Romper en %1$s"

	L.phase2_message = "¡Fase de mortalidad pronto!"

	L.warmup = "Calentamiento"
	L.warmup_desc = "Temporizador para Calentamiento"
end

L = BigWigs:NewBossLocale("Magmaw", "esES")
if L then
	L.inferno = inferno
	L.inferno_desc = "Invoca Ensamblaje osario llameante."

	L.pillar_of_flame_cd = "~Columna de llamas"

	L.blazing_message = "¡Add entrante!"
	L.blazing_bar = "Siguiente esqueleto"

	L.slump = "Cae (Rodeo)"
	L.slump_desc = "Cae hacia delante exponiendose a sí mismo, permitiendo que el rodeo empiece."

	L.slump_bar = "Próximo rodeo"
	L.slump_message = "¡Yeepah, móntalo!"
	L.slump_trigger = "¡%s cae hacia delante y deja expuestas sus tenazas!"

	L.infection_message = "¡Estás infectado!"

	L.expose_trigger = "¡%s acaba empalado en el pincho y deja expuesta la cabeza!"
	L.expose_message = "¡Cabeza expuesta!"
end

L = BigWigs:NewBossLocale("Maloriak", "esES")
if L then
	--heroic
	L.sludge = "Fango oscuro"
	L.sludge_desc = "Aviso para cuando estas en Fango oscuro."
	L.sludge_message = "¡Fango en TI!"

	--normal
	L.final_phase = "Fase final"

	L.release_aberration_message = "%s adds restantes!"
	L.release_all = "%s adds liberados!"

	L.bitingchill_say = "¡Escalofrío cortante en MI!"

	L.flashfreeze = "~Congelación apresurada"
	L.next_blast = "~Explosión agostadora"

	L.phase = "Fase"
	L.phase_desc = "Advertencia para cambios de fase."
	L.next_phase = "Siguiente fase"
	L.green_phase_bar = "Fase Verde"

	L.red_phase_trigger = "Mezclar y agitar, aplicar calor..."
	L.red_phase = "Fase |cFFFF0000Roja|r"
	L.blue_phase_trigger = "¿Cómo afecta el cambio extremo de temperatura al cuerpo mortal? ¡Debo averiguarlo! ¡Por la ciencia!"
	L.blue_phase = "Fase |cFF809FFEAzul|r"
	L.green_phase_trigger = "Este es un poco inestable, pero ¿acaso hay progreso sin fracaso?"
	L.green_phase = "Fase |cFF33FF00Verde|r"
	L.dark_phase = "|cFF660099Dark|r fase"
	L.dark_phase_trigger = "Your mixtures are weak, Maloriak! They need a bit more... kick!"
end

L = BigWigs:NewBossLocale("Nefarian", "esES")
if L then
	L.phase = "Fases"
	L.phase_desc = "Aviso para los cambios de fase."

	L.phase_two_trigger = "Curse you, mortals! Such a callous disregard for one's possessions must be met with extreme force!"

	L.phase_three_trigger = "I have tried to be an accommodating host, but you simply will not die! Time to throw all pretense aside and just... KILL YOU ALL!"

	L.crackle_trigger = "The air crackles with electricity!"
	L.crackle_message = "¡Electrocutar pronto!"

	L.onyxia_power_message = "¡Explosión pronto!"

	L.cinder_say = "¡Cenizas explosivas en MI!"

	L.chromatic_prototype = "Chromatic Prototype" -- 3 adds name
end

L = BigWigs:NewBossLocale("Omnotron Defense System", "esES")
if L then
	L.nef = "Lord Victor Nefarius"
	L.nef_desc = "Avisos para las abilidades de Lord Victor Nefarius"
	L.switch = "Cambio"
	L.switch_desc = "Advertencia para los cambios"
	L.switch_message = "%s %s"

	L.next_switch = "Siguiente cambio"

	L.nef_next = "~Siguiente bufo de habilidad"

	L.acquiring_target = "Eligiendo objetivo"

	L.bomb_message = "¡Un moco te persigue a TI!"
	L.cloud_say = "¡Nube en MI!"
	L.cloud_message = "¡Nube en TI!"
	L.protocol_message = "¡Bomba de veneno!"

	L.iconomnotron = "Icono en el jefe activo"
	L.iconomnotron_desc = "Coloca el icono principal de raid en el jefe activo (requiere ayudante o lider)."
end

