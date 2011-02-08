
local L = BigWigs:NewBossLocale("Atramedes", "esES")
if not L then return end
if L then
	L.ground_phase = "Fase en tierra"
	L.ground_phase_desc = "Avisa cuando Atramedes aterriza."
	L.air_phase = "Fase a\195\169rea"
	L.air_phase_desc = "Avisa cuando Atramedes despega."

	L.air_phase_trigger = "¡Sí, corred! Con cada paso, vuestros corazones se aceleran. El latido, fuerte y clamoroso... Casi ensordecedor. ¡No podéis escapar!"

	L.sonicbreath_cooldown = "(CD) Aliento s\195\179nico"
end

L = BigWigs:NewBossLocale("Chimaeron", "esES")
if L then
	L.bileotron_engage = "El Bilistrón se activa y empieza a emitir una sustancia de olor asqueroso."
	L.win_trigger = "El Bilistrón hace señales afirmativas y se apaga de forma permanente."

	L.next_system_failure = "(CD) Siguiente fallo del sistema"
	L.break_message = "%2$dx Romper en %1$s"

	L.phase2_message = "\194\161Fase de Mortalidad pronto!"

	L.warmup = "Calentamiento"
	L.warmup_desc = "Temporizador para Calentamiento"
end

L = BigWigs:NewBossLocale("Magmaw", "esES")
if L then
	-- heroic
	L.blazing = "Esqueletos"
	L.blazing_desc = "Invoca Ensamblaje osario llameante."
	L.blazing_message = "\194\161Add inminente!"
	L.blazing_bar = "Siguiente esqueleto"

	L.phase2 = "Fase 2"
	L.phase2_desc = "Aviso para la transici\195\179n de la fase 2 y visualiza el comprobador de rango."
	L.phase2_message = "\194\161Fase 2!"
	L.phase2_yell = "Inconceivable! You may actually defeat my lava worm! Perhaps I can help... tip the scales."

	-- normal
	L.pillar_of_flame_cd = "(CD) Columna de llamas"

	L.slump = "Cae (Rodeo)"
	L.slump_desc = "Cae hacia delante exponiendose a s\195\173 mismo, permitiendo que el rodeo empiece."
	L.slump_bar = "Pr\195\179ximo rodeo"
	L.slump_message = "\194\161Yeepah, m\195\179ntalo!"
	L.slump_trigger = "¡%s cae hacia delante y deja expuestas sus tenazas!"

	L.infection_message = "\194\161Est\195\161s infectado!"

	L.expose_trigger = "cabeza"
	L.expose_message = "\194\161Cabeza expuesta!"

	L.spew_bar = "(CD) Pr\195\179ximo V\195\179mito"
	L.spew_warning = "\194\161V\195\179mito de lava pronto!"
end

L = BigWigs:NewBossLocale("Maloriak", "esES")
if L then
	--heroic
	L.sludge = "Fango oscuro"
	L.sludge_desc = "Avisa cuando pisas Fango oscuro."
	L.sludge_message = "\194\161Fango en TI!"

	--normal
	L.final_phase = "Fase final"

	L.release_aberration_message = "\194\161%s adds restantes!"
	L.release_all = "\194\161%s adds liberados!"

	L.bitingchill_say = "\194\161Escalofr\195\173o cortante en MI!"

	L.flashfreeze = "(CD) Congelaci\195\179n apresurada"
	L.next_blast = "(CD) Explosi\195\179n agostadora"

	L.phase = "Fase"
	L.phase_desc = "Avisa los cambios de fase."
	L.next_phase = "Siguiente fase"
	L.green_phase_bar = "Fase Verde"

	L.red_phase_trigger = "Mezclar y agitar, aplicar calor..."
	L.red_phase_emote_trigger = "rojo"
	L.red_phase = "Fase |cFFFF0000Roja|r"
	L.blue_phase_trigger = "¿Cómo afecta el cambio extremo de temperatura al cuerpo mortal? ¡Debo averiguarlo! ¡Por la ciencia!"
	L.blue_phase_emote_trigger = "azul"
	L.blue_phase = "Fase |cFF809FFEAzul|r"
	L.green_phase_trigger = "Este es un poco inestable, pero ¿acaso hay progreso sin fracaso?"
	L.green_phase_emote_trigger = "verde"
	L.green_phase = "Fase |cFF33FF00Verde|r"
	L.dark_phase_trigger = "Your mixtures are weak, Maloriak! They need a bit more... kick!"
	L.dark_phase_emote_trigger = "oscuro"
	L.dark_phase = "Fase |cFF660099Oscura|r"
end

L = BigWigs:NewBossLocale("Nefarian", "esES")
if L then
	L.phase = "Fases"
	L.phase_desc = "Avisa los cambios de fase."

	L.phase_two_trigger = "¡Os maldigo, mortales! ¡Ese cruel menosprecio por las posesiones de uno debe ser castigado con fuerza extrema!"

	L.phase_three_trigger = "He intentado ser un buen anfitrión, pero ¡no morís! Es hora de dejarnos de tonterías y simplemente... ¡MATAROS A TODOS!"

	L.crackle_trigger = "¡El aire crepita cargado de electricidad!"
	L.crackle_message = "\194\161Electrocutar pronto!"

	L.shadowblaze_message = "Fuego"

	L.onyxia_power_message = "\194\161Explosi\195\179n pronto!"

	L.chromatic_prototype = "Prototipo cromático" -- 3 adds name
end

L = BigWigs:NewBossLocale("Omnotron Defense System", "esES")
if L then
	L.nef = "Lord Victor Nefarius"
	L.nef_desc = "Avisos para las abilidades de Lord Victor Nefarius"
	
	L.pool = "Generador de poder sobrecargado"
	
	L.switch = "Cambio"
	L.switch_desc = "Avisa los cambios"
	L.switch_message = "%s %s"

	L.next_switch = "Siguiente cambio"

	L.nef_trigger1 = "Were you planning on using Toxitron's chemicals to damage the other constructs? Clever plan, let me ruin that for you."
	L.nef_trigger2 = "Stupid Dwarves and your fascination with runes! Why would you create something that would help your enemy?"

	L.nef_next = "(CD) Siguiente bufo de habilidad"

	L.acquiring_target = "Eligiendo objetivo"

	L.bomb_message = "\194\161Un moco TE persigue!"
	L.cloud_message = "\194\161Nube en TI!"
	L.protocol_message = "\194\161Bomba de veneno inminente!"

	L.iconomnotron = "Icono en el jefe activo"
	L.iconomnotron_desc = "Coloca el icono principal de raid en el jefe activo (requiere ayudante o lider)."
end

