local L = BigWigs:NewBossLocale("Atramedes", "esES")
if L then
	L.tracking_me = "Tracking on ME!"

	L.ground_phase = "Fase en el suelo"
	L.ground_phase_desc = "Aviso cuando Atramedes aterriza."
	L.air_phase = "Fase aérea"
	L.air_phase_desc = "Aviso cuando Atramedes despega."

	L.air_phase_trigger = "Yes, run! With every step your heart quickens. The beating, loud and thunderous... Almost deafening. You cannot escape!"

	L.sonicbreath_cooldown = "~Aliento sónico"
end

L = BigWigs:NewBossLocale("Chimaeron", "esES")
if L then
	L.bileotron_engage = "El Bilistrón se activa y empieza a emitir una sustancia de olor asqueroso."

	L.next_system_failure = "Siguiente fallo del sistema"
	L.break_message = "%2$dx Romper en %1$s"

	L.mortality_report = "¡%s está al %d%% de vida, %s pronto!"

	L.warmup = "Calentamiento"
	L.warmup_desc = "Temporizador para Calentamiento"
end

L = BigWigs:NewBossLocale("Magmaw", "esES")
if L then
	L.inferno = (GetSpellInfo(92191))
	L.inferno_desc = "Invoca Ensamblaje osario llameante"

	L.pillar_of_flame_cd = "~Columna de llamas"

	L.slump = "Cae"
	L.slump_desc = "Cae hacia delante exponiendose a sí mismo"

	L.slump_trigger = "¡%s cae hacia delante y deja expuestas sus tenazas!"
end

L = BigWigs:NewBossLocale("Maloriak", "esES")
if L then
	--heroic
	L.darkSludge = (GetSpellInfo(92987))
	L.darkSludge_desc = ("Aviso cuando estas en %s."):format((GetSpellInfo(92987)))

	--normal
	L.final_phase = "Fase final"

	L.release_aberration_message = "%s adds restantes!"
	L.release_all = "%s adds liberados!"

	L.bitingchill_say = "Escalofrío cortante en MI!"

	L.flashfreeze = "~Congelación apresurada"

	L.phase = "Fase"
	L.phase_desc = "Advertencia para cambios de fase."
	L.next_phase = "Siguiente fase"

	L.you = "%s en TI!"
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

	L.shadowblaze_trigger = "Flesh turns to ash!"

	L.cinder_say = "¡Cenizas explosivas en MI!"

	L.chromatic_prototype = "Chromatic Prototype" -- 3 adds name
end

L = BigWigs:NewBossLocale("Omnotron Defense System", "esES")
if L then
	L.nef = "Lord Victor Nefarius"
	L.nef_desc = "Avisos para las abilidades de Lord Victor Nefarius"
	L.switch = "Cambio"
	L.switch_desc = "Advertencia para los cambios"

	L.next_switch = "Siguiente cambio"

	L.nef_trigger1 = "Were you planning on using Toxitron's chemicals to damage the other constructs? Clever plan, let me ruin that for you."
	L.nef_trigger2 = "Stupid Dwarves and your fascination with runes! Why would you create something that would help your enemy?"

	L.nef_next = "~Siguiente bufo de habilidad"

	L.acquiring_target = "Eligiendo objetivo"

	L.cloud_message = "¡Nube en TI!"
end
