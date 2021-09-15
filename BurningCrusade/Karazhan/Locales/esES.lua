local L = BigWigs:NewBossLocale("Attumen the Huntsman Raid", "esES") or BigWigs:NewBossLocale("Attumen the Huntsman Raid", "esMX")
if not L then return end
if L then
	L.phase = "Fases"
	L.phase_desc = "Avisar sobre cambios de fase."
	L.phase2_trigger = "¡%s llama a su maestro!"
	L.phase2_message = "Fase 2 - %s & Attumen"
	L.phase3_trigger = "¡Ven, Medianoche, vamos a dispersar a estos pusilánimes!"
	L.phase3_message = "Fase 3"
end

L = BigWigs:NewBossLocale("The Curator Raid", "esES") or BigWigs:NewBossLocale("The Curator Raid", "esMX")
if L then
	L.engage_trigger = "La colección es solo para los invitados."

	L.weaken_message = "¡Evocación - Debilidad durante 20sec!"
	L.weaken_fade_message = "¡Evocación Finalizada - Debilidad desaparecida!"
	L.weaken_fade_warning = "¡Evocación en ~5 seg!"
end

L = BigWigs:NewBossLocale("Maiden of Virtue Raid", "esES") or BigWigs:NewBossLocale("Maiden of Virtue Raid", "esMX")
if L then
	L.engage_trigger = "No se tolerará tu comportamiento."
	L.engage_message = "¡Doncella en combate! Arrepentimiento en ~33 seg"

	L.repentance_message = "Sig. Arrepentimiento en ~33 seg"
	L.repentance_warning = "¡Arrepentimiento en breve!"
end

L = BigWigs:NewBossLocale("Prince Malchezaar", "esES") or BigWigs:NewBossLocale("Prince Malchezaar", "esMX")
if L then
	L.wipe_bar = "Reaparición"

	L.phase = "Fases"
	L.phase_desc = "Avisar cambios de fase."
	L.phase1_trigger = "La locura os ha traído ante mi. ¡Seré vuestro fin!"
	L.phase2_trigger = "¡Estúpidos! El tiempo es el fuego en el que arderéis!"
	L.phase3_trigger = "¿Cómo podéis esperar rebelaros ante un poder tan aplastante?"
	L.phase1_message = "¡Fase 1 - Infernal en ~40seg!"
	L.phase2_message = "60% - Fase 2"
	L.phase3_message = "30% - Fase 3 "

	L.infernal = "Infernales"
	L.infernal_desc = "Muestra temporizadores para la invocación de Infernales."
	L.infernal_bar = "~Llega infernal"
	L.infernal_warning = "¡Infernal llega en 20seg!"
	L.infernal_message = "¡Aterrizó Infernal - Llamas infernales en 5seg!"
	L.infernal_trigger1 = "sino a todas las legiones bajo mi mando"
	L.infernal_trigger2 = "todas las dimensiones"
end

L = BigWigs:NewBossLocale("Moroes Raid", "esES") or BigWigs:NewBossLocale("Moroes Raid", "esMX")
if L then
	L.engage_trigger = "Mm, visita inesperada. Hay que hacer los preparativos..."
	L.engage_message = "%s Activado - Desvanecer en ~35sec!"
end

L = BigWigs:NewBossLocale("Netherspite", "esES") or BigWigs:NewBossLocale("Netherspite", "esMX")
if L then
	L.phase = "Fases"
	L.phase_desc = "Avisar cuando Rencor abisal cambia de fase."
	L.phase1_message = "Retirada - Aliento abisal terminado"
	L.phase1_bar = "~Retirada"
	L.phase1_trigger = "%s grita en retirada, abriendo las puertas al vacío."
	L.phase2_message = "Cólera - ¡Aliento abisal en breve!"
	L.phase2_bar = "~Cólera"
	L.phase2_trigger = "¡%s monta en cólera alimentada por el vacío!"

	L.voidzone_warn = "¡Zona de vacío (%d)!"
end

L = BigWigs:NewBossLocale("Nightbane Raid", "esES") or BigWigs:NewBossLocale("Nightbane Raid", "esMX")
if L then
	L.name = "Nocturno"

	L.phase = "Fases"
	L.phase_desc = "Avisa cuando Nocturno cambia de fase."
	L.airphase_trigger = "Miserable alimaña. ¡Te exterminaré del aire!"
	L.landphase_trigger1 = "¡Ya basta! Voy a aterrizar y a aplastarte yo mismo."
	L.landphase_trigger2 = "¡Insectos! ¡Os enseñaré mi fuerza de cerca!"
	L.airphase_message = "¡Volando!"
	L.landphase_message = "¡Aterrizando!"
	L.summon_trigger = "Un ser antiguo se despierta en la distancia..."

	L.engage_trigger = "¡Necios! ¡Voy a acabar rápidamente con tu sufrimiento!"
end

L = BigWigs:NewBossLocale("Romulo & Julianne", "esES") or BigWigs:NewBossLocale("Romulo & Julianne", "esMX")
if L then
	L.name = "Romulo & Julianne"

	L.phase = "Fases"
	L.phase_desc = "Avisa cuando entra en una nueva fase."
	L.phase1_trigger = "¿Qué demonio sois que me atormentáis de questa manera?"
	L.phase1_message = "Acto I - Julianne"
	L.phase2_trigger = "¿Me provocáis? ¡Mi carga recibiréis pues!"
	L.phase2_message = "Acto II - Romulo"
	L.phase3_trigger = "Adelante, gentil noche, ¡devuélveme a mi Romulo!"
	L.phase3_message = "Acto III - Ambos"

	L.poison = "Veneno"
	L.poison_desc = "Avisa sobre jugadores envenenados."
	L.poison_message = "Envenenado"

	L.heal = "Curación"
	L.heal_desc = "Avisa cuando Julianne lanza Afección eterna."
	L.heal_message = "¡Julianne lanzando curación!"

	L.buff = "Auto-Beneficio"
	L.buff_desc = "Avisa cuando Romulo y Julianne reciben activan su propio beneficio."
	L.buff1_message = "¡Romulo gana Arrojo!"
	L.buff2_message = "¡Julianne gana Devoción!"
end

L = BigWigs:NewBossLocale("Shade of Aran", "esES") or BigWigs:NewBossLocale("Shade of Aran", "esMX")
if L then
	L.adds = "Elementales"
	L.adds_desc = "Avisa de la aparación de los elementales de agua."
	L.adds_message = "¡Llegada de Elementales!"
	L.adds_warning = "Elementales Pronto"
	L.adds_bar = "Elementales"

	L.drink = "Beber"
	L.drink_desc = "Avisa de cuando Aran comienza a beber."
	L.drink_warning = "¡Maná bajo - Beber pronto!"
	L.drink_message = "¡Bebiendo - Polimorfia de área!"
	L.drink_bar = "~Piroexplosión"

	L.blizzard = "Ventisca"
	L.blizzard_desc = "Avisa de cuando ventisca está siendo lanzada."
	L.blizzard_message = "¡Ventisca!"

	L.pull = "Atracción/Deflagración Arcana"
	L.pull_desc = "Avisar de la atracción y la Deflagración Arcana."
	L.pull_message = "¡Deflagración Arcana!"
	L.pull_bar = "Deflagración Arcana"
end

L = BigWigs:NewBossLocale("Terestian Illhoof", "esES") or BigWigs:NewBossLocale("Terestian Illhoof", "esMX")
if L then
	L.engage_trigger = "Ah, justo a tiempo. ¡Los rituales van a empezar!"

	L.weak = "Debilidad"
	L.weak_desc = "Avisa de estado de debilidad."
	L.weak_message = "¡Debilidad durante ~45seg!"
	L.weak_warning1 = "¡Debilidad finaliza en ~5seg!"
	L.weak_warning2 = "¡Debilidad finalizada!"
	L.weak_bar = "~Debilidad finaliza"
end

L = BigWigs:NewBossLocale("The Big Bad Wolf", "esES") or BigWigs:NewBossLocale("The Big Bad Wolf", "esMX")
if L then
	L.name = "El Gran Lobo Malvado"

	L.riding_bar = "%s Corriendo"
end

L = BigWigs:NewBossLocale("The Crone", "esES") or BigWigs:NewBossLocale("The Crone", "esMX")
if L then
	L.name = "La Vieja Bruja"

	L.engage_trigger = "^¡Oh, Tito, solo tenemos que buscar la manera de volver a casa!"

	L.spawns = "Activación"
	L.spawns_desc = "Contadores para cuando los persoanjes se activan."
	L.spawns_warning = "¡%s en 5 sec!"

	L.roar = "Rugido"
	L.tinhead = "Cabezalata"
	L.strawman = "Espantapájaros"
	L.tito = "Tito"
end

