local L = BigWigs:NewBossLocale("Hydross the Unstable", "esES")
if not L then return end
if L then
	L.start_trigger = "¡No puedo permitir que interferáis!"

	L.mark = "Marca de Hydross"
	L.mark_desc = "Mostrar avisos y contadores de Marca de Hydross."

	L.stance = "Cambios de Actitud"
	L.stance_desc = "Avisar cuando Hydross cambia de actitud. (Corrupto/Purificado)"
	L.poison_stance = "¡Hydross - Actitud corrupta!"
	L.water_stance = "¡Hydross - Actitud purificada!"

	L.debuff_warn = "¡Marca - %s%%!"
end

L = BigWigs:NewBossLocale("Fathom-Lord Karathress", "esES")
if L then
	L.enrage_trigger = "¡Guardias, atención! Tenemos visita..."

	L.totem = "Tótem escupefuego"
	L.totem_desc = "Avisar sobre Tótem escupefuego y sobre quién lo lanza."
	L.totem_message1 = "Mareavess: Tótem escupefuego"
	L.totem_message2 = "Karathress: Tótem escupefuego"
	L.heal_message = "¡Caribdis - Ola de sanación!"

	L.priest = "Guardia de las profundidades Caribdis"
end

L = BigWigs:NewBossLocale("Leotheras the Blind", "esES")
if L then
	L.enrage_trigger = "¡Al fin acaba mi destierro!"

	L.phase = "Fase demonio"
	L.phase_desc = "Tiempos estimados para fase demonio."
	L.phase_trigger = "¡Desaparece, elfo pusilánime. ¡Yo mando ahora!"
	L.phase_demon = "Fase demonio durante 60 seg"
	L.phase_demonsoon = "¡Fase demonio en 5 seg!"
	L.phase_normalsoon = "Fase normal en 5 seg"
	L.phase_normal = "¡Fase normal!"
	L.demon_bar = "<Fase demonio>"
	L.demon_nextbar = "~Fase demonio"

	L.mindcontrol = "Control mental (Mind Control)"
	L.mindcontrol_desc = "Avisar qué jugadores están siendo controlados mentalmente."
	L.mindcontrol_warning = "Control mental"

	L.image = "Imagen"
	L.image_desc = "Alertas de división de imagen al 15%."
	L.image_trigger = "¡No... no! ¿Qué has hecho? ¡Yo soy el maestro! ¿Me oyes? ¡Yo... ahggg! No...puedo contenerme."
	L.image_message = "¡15% - Imagen creada!"
	L.image_warning = "Imagen en breve"

	L.whisper = "Silbido insidioso (Insidious Whisper)"
	L.whisper_desc = "Avisar quién tiene Silbido insidioso."
	L.whisper_message = "Demonio"
	L.whisper_bar = "<Demonios desaparecen>"
	L.whisper_soon = "~Demonios"
end

L = BigWigs:NewBossLocale("The Lurker Below", "esES")
if L then
	L.engage_warning = "%s Activado - Se sumerge en ~90seg"

	L.dive = "Sumergida (Dive)"
	L.dive_desc = "Temporizadores para cuando El Rondador de abajo se sumerge."
	L.dive_warning = "Se sumerge en ~%dseg"
	L.dive_bar = "~Se sumerge"
	L.dive_message = "Se sumerge - Vuelve en 60sec"

	L.spout = "Chorro (Spout)"
	L.spout_desc = "Temporizadores para Chorro, puede no ser del todo preciso."
	L.spout_message = "¡Lanzando Chorro!"
	L.spout_warning = "Posible Chorro en ~3seg"
	L.spout_bar = "~Chorro"

	L.emerge_warning = "Vuelve en %dseg"
	L.emerge_message = "Vuelve - Se sumerge en ~90sec"
	L.emerge_bar = "~Vuelve a superficie"
end

L = BigWigs:NewBossLocale("Morogrim Tidewalker", "esES")
if L then
	L.grave_bar = "<Sepultura de agua> "
	L.grave_nextbar = "~Sepultura de agua"

	L.murloc = "Múrlocs"
	L.murloc_desc = "Avisar de Múrlocs entrantes."
	L.murloc_bar = "~Múrlocs"
	L.murloc_message = "¡Vienen los Múrlocs!"
	L.murloc_soon_message = "Múrlocs en breve"
	L.murloc_engaged = "%s Activado, Múrlocs en ~40seg"

	L.globules = "Glóbulos"
	L.globules_desc = "Avisar cuando aparecen glóbulos de agua."
	L.globules_trigger1 = "Pronto acabará."
	L.globules_trigger2 = "¡No os podéis esconder!"
	L.globules_message = "¡Glóbulos!"
	L.globules_warning = "Glóbulos en breve"
	L.globules_bar = "Glóbulos"
end

L = BigWigs:NewBossLocale("Lady Vashj", "esES")
if L then
	L.engage_trigger1 = "No quería rebajarme y tener contacto con vuestra clase, pero no me dejáis elección..."
	L.engage_trigger2 = "¡Os desprecio, desechos de la superficie!"
	L.engage_trigger3 = "¡Victoria para Lord Illidan!"
	L.engage_trigger4 = "¡Os partiré de cabo a rabo!"
	L.engage_trigger5 = "¡Muerte para los intrusos!"
	L.engage_message = "Entrando en fase 1"

	L.phase = "Fases"
	L.phase_desc = "Avisar sobre cambios de fase."
	L.phase2_trigger = "¡Ha llegado el momento! ¡Que no quede ni uno en pie!"
	L.phase2_soon_message = "Fase 2 en breve"
	L.phase2_message = "¡Fase 2 - Entran refuerzos!"
	L.phase3_trigger = "Os vendrá bien cubriros."
	L.phase3_message = "¡Fase 3 - Enfurecer en 4min!"

	L.elemental = "Elementales máculos (Tainted Elemental)"
	L.elemental_desc = "Avisar cuando aparecen Elementales máculos durante la fase 2."
	L.elemental_bar = "~Elementales máculos"
	L.elemental_soon_message = "Elementales máculos en breve"

	L.strider = "Zancudos Colmillo Torcido (Coilfang Striders)"
	L.strider_desc = "Avisar cuando aparecen Zancudos Colmillo Torcido durante la fase 2."
	L.strider_bar = "~Zancudo"
	L.strider_soon_message = "Zancudo Colmillo Torcido en breve"

	L.naga = "Élite Colmillo Torcido (Coilfang Elite)"
	L.naga_desc = "Avisar cuando aparecen Élites Colmillo Torcido durante la fase 2."
	L.naga_bar = "~Élite Naga"
	L.naga_soon_message = "Élite Colmillo Torcido en breve"

	L.barrier_desc = "Avisar cuand caen las Barreras mágicas."
	L.barrier_down_message = "¡Barrera %d/4 caída!"
end

