
local L = BigWigs:NewBossLocale("Atramedes", "esES")
if not L then return end
if L then
	L.tracking_me = "\194\161Rastreando en MI!"

	L.ground_phase = "Fase en tierra"
	L.ground_phase_desc = "Aviso cuando Atramedes aterriza."
	L.air_phase = "Fase a\195\169rea"
	L.air_phase_desc = "Aviso cuando Atramedes despega."

	L.air_phase_trigger = "Yes, run! With every step your heart quickens. The beating, loud and thunderous... Almost deafening. You cannot escape!"

	L.sonicbreath_cooldown = "~Aliento s\195\179nico"
end

L = BigWigs:NewBossLocale("Chimaeron", "esES")
if L then
	L.bileotron_engage = "El Bilistrón se activa y empieza a emitir una sustancia de olor asqueroso."
	L.win_trigger = "El Bilistrón hace señales afirmativas y se apaga de forma permanente."

	L.next_system_failure = "Siguiente fallo del sistema"
	L.break_message = "%2$dx Romper en %1$s"

	L.phase2_message = "\194\161Fase de mortalidad pronto!"

	L.warmup = "Calentamiento"
	L.warmup_desc = "Temporizador para Calentamiento"
end

L = BigWigs:NewBossLocale("Magmaw", "esES")
if L then
	-- heroic
	L.blazing = "Skeleton Adds"
	L.blazing_desc = "Invoca Ensamblaje osario llameante."
	L.blazing_message = "\194\161Add entrante!"
	L.blazing_bar = "Siguiente esqueleto"

	L.phase2 = "Fase 2"
	L.phase2_desc = "Aviso para la transici\195\179n de la fase 2 y visualiza el comprobador de rango."
	L.phase2_message = "\194\161Fase 2!"
	L.phase2_yell = "Inconceivable! You may actually defeat my lava worm! Perhaps I can help... tip the scales."

	-- normal
	L.pillar_of_flame_cd = "~Columna de llamas"

	L.slump = "Cae (Rodeo)"
	L.slump_desc = "Cae hacia delante exponiendose a s\195\173 mismo, permitiendo que el rodeo empiece."
	L.slump_bar = "Pr\195\179ximo rodeo"
	L.slump_message = "\194\161Yeepah, m\195\179ntalo!"
	L.slump_trigger = "¡%s cae hacia delante y deja expuestas sus tenazas!"

	L.infection_message = "\194\161Est\195\161s infectado!"

	L.expose_trigger = "cabeza"
	L.expose_message = "\194\161Cabeza expuesta!"

	L.spew_bar = "~Next Spew"
	L.spew_warning = "Lava Spew Soon!"
end

L = BigWigs:NewBossLocale("Maloriak", "esES")
if L then
	--heroic
	L.sludge = "Fango oscuro"
	L.sludge_desc = "Aviso para cuando estas en Fango oscuro."
	L.sludge_message = "\194\161Fango en TI!"

	--normal
	L.final_phase = "Fase final"

	L.release_aberration_message = "%s adds restantes!"
	L.release_all = "%s adds liberados!"

	L.bitingchill_say = "\194\161Escalofr\195\173o cortante en MI!"

	L.flashfreeze = "~Congelaci\195\179n apresurada"
	L.next_blast = "~Explosi\195\179n agostadora"

	L.phase = "Fase"
	L.phase_desc = "Advertencia para cambios de fase."
	L.next_phase = "Siguiente fase"
	L.green_phase_bar = "Fase Verde"

	L.red_phase_trigger = "Mezclar y agitar, aplicar calor..."
	L.red_phase_emote_trigger = "roja"
	L.red_phase = "Fase |cFFFF0000Roja|r"
	L.blue_phase_trigger = "¿Cómo afecta el cambio extremo de temperatura al cuerpo mortal? ¡Debo averiguarlo! ¡Por la ciencia!"
	L.blue_phase_emote_trigger = "azul"
	L.blue_phase = "Fase |cFF809FFEAzul|r"
	L.green_phase_trigger = "Este es un poco inestable, pero ¿acaso hay progreso sin fracaso?"
	L.green_phase_emote_trigger = "verde"
	L.green_phase = "Fase |cFF33FF00Verde|r"
	L.dark_phase_trigger = "Your mixtures are weak, Maloriak! They need a bit more... kick!"
	L.dark_phase_emote_trigger = "oscure" --verificar
	L.dark_phase = "|cFF660099Dark|r fase"
end

L = BigWigs:NewBossLocale("Nefarian", "esES")
if L then
	L.phase = "Fases"
	L.phase_desc = "Aviso para los cambios de fase."

	L.phase_two_trigger = "Curse you, mortals! Such a callous disregard for one's possessions must be met with extreme force!"

	L.phase_three_trigger = "I have tried to be an accommodating host, but you simply will not die! Time to throw all pretense aside and just... KILL YOU ALL!"

	L.crackle_trigger = "The air crackles with electricity!"
	L.crackle_message = "\194\161Electrocutar pronto!"

	L.onyxia_power_message = "\194\161Explosi\195\179n pronto!"

	L.cinder_say = "\194\161Cenizas explosivas en MI!"

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

	L.bomb_message = "\194\161Un moco te persigue a TI!"
	L.cloud_say = "\194\161Nube en MI!"
	L.cloud_message = "\194\161Nube en TI!"
	L.protocol_message = "\194\161Bomba de veneno!"

	L.iconomnotron = "Icono en el jefe activo"
	L.iconomnotron_desc = "Coloca el icono principal de raid en el jefe activo (requiere ayudante o lider)."
end

