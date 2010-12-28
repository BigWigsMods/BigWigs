local L = BigWigs:NewBossLocale("Atramedes", "esES")
if L then
	L.tracking_me = "Tracking on ME!"

	L.shield = "Ancient Dwarven Shield"
	L.shield_desc = "Warning for the remaining Ancient Dwarven Shields."
	L.shield_message = "%d Ancient Dwarven Shield left"

	L.ground_phase = "Fase en el suelo"
	L.ground_phase_desc = "Aviso cuando Atramedes aterriza."
	L.air_phase = "Fase aérea"
	L.air_phase_desc = "Aviso cuando Atramedes despega."

	L.air_phase_trigger = "Yes, run! With every step your heart quickens. The beating, loud and thunderous... Almost deafening. You cannot escape!"

	L.sonicbreath_cooldown = "~Aliento sónico"
end

L = BigWigs:NewBossLocale("Chimaeron", "esES")
if L then
	L.bileotron_engage = "The Bile-O-Tron springs to life and begins to emit a foul smelling substance."

	L.next_system_failure = "Siguiente fallo del sistema"
	L.break_message = "%2$dx Romper en %1$s"

	L.warmup = "Entrar en calor"
	L.warmup_desc = "Contador para entrar en calor"
end

L = BigWigs:NewBossLocale("Magmaw", "esES")
if L then
	L.inferno = (GetSpellInfo(92191))
	L.inferno_desc = "Summons Blazing Bone Construct"

	L.slump = "Slump"
	L.slump_desc = "Slumps forward exposing itself"

	L.slump_trigger = "%s slumps forward, exposing his pincers!"
end

L = BigWigs:NewBossLocale("Maloriak", "esES")
if L then
	--heroic
	L.darkSludge = (GetSpellInfo(92987))
	L.darkSludge_desc = ("Warning for when you stand in %s."):format((GetSpellInfo(92987)))

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

	L.red_phase = "|cFFFF0000Red|r fase"
	L.blue_phase_trigger = "¿Cómo afecta el cambio extremo de temperatura al cuerpo mortal? ¡Debo averiguarlo! ¡Por la ciencia!"
	L.blue_phase = "|cFF809FFEBlue|r fase"
	L.green_phase_trigger = "Este es un poco inestable, pero ¿acaso hay progreso sin fracaso?"
	L.green_phase = "|cFF33FF00Green|r fase"
	L.dark_phase = "|cFF660099Dark|r fase"
	L.dark_phase_trigger = "Your mixtures are weak, Maloriak! They need a bit more... kick!"
end

L = BigWigs:NewBossLocale("Nefarian", "esES")
if L then
	L.phase = "Phases"
	L.phase_desc = "Warnings for the Phase changes."

	L.phase_two_trigger = "Curse you, mortals! Such a callous disregard for one's possessions must be met with extreme force!"

	L.chromatic_prototype = "Chromatic Prototype" -- 3 adds name
end

L = BigWigs:NewBossLocale("Omnotron Defense System", "esES")
if L then
	L.nef = "Lord Victor Nefarius"
	L.nef_desc = "Warnings for Lord Victor Nefarius abilities"
	L.switch = "Switch"
	L.switch_desc = "Warning for Switches"

	L.next_switch = "Next Switch"

	L.nef_trigger1 = "Were you planning on using Toxitron's chemicals to damage the other constructs? Clever plan, let me ruin that for you."
	L.nef_trigger2 = "Stupid Dwarves and your fascination with runes! Why would you create something that would help your enemy?"

	L.nef_next = "~Next ability buff"

	L.acquiring_target = "Acquiring Target"

	L.cloud_message = "Cloud on YOU!"
end
