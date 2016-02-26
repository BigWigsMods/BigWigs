local L = BigWigs:NewBossLocale("Gruul", "esES") or BigWigs:NewBossLocale("Gruul", "esMX")
if not L then return end
if L then
L.first_ability = "Machaque o Embate"

end

L = BigWigs:NewBossLocale("Oregorger", "esES") or BigWigs:NewBossLocale("Oregorger", "esMX")
if L then
L.roll_message = "Rueda %d - %d cajas para acabar!"

end

L = BigWigs:NewBossLocale("The Blast Furnace", "esES") or BigWigs:NewBossLocale("The Blast Furnace", "esMX")
if L then
L.bombs_dropped = "¡Bombas arrojadas! (%d)"
L.bombs_dropped_p2 = "¡Ingeniero muerto, bombas arrojadas!"
L.custom_off_firecaller_marker = "Marcador de Clamafuegos"
L.custom_off_firecaller_marker_desc = [=[Marca los Clamafuegos con {rt7}{rt6}, requiere ayudante o líder.
|cFFFF0000Sólo 1 persona en la raid debería tener activa esta opción para prevenir conflictos con las marcas.|r
|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over the mobs is the fastest way to mark them.|r]=]
L.custom_on_shieldsdown_marker = "Marcador de Escudos abajo"
L.custom_on_shieldsdown_marker_desc = "Marca una Elementalista primigenia vulnerable con {rt8}, requiere ayudante o líder."
L.engineer = "Ingeniero del horno aparece"
L.engineer_desc = "Durante la primera fase, 2 Ingenieros del horno aparecerán repetidamente. 1 en cada lado de la sala."
L.firecaller = "Clamafuegos aparece"
L.firecaller_desc = "Durante la fase dos, 2 Clamafuegos aparecerán repetidamente, 1 en cada lado de la sala."
L.guard = "Guardia de seguridad aparece"
L.guard_desc = "Durante la primera fase, 2 Guardias de seguridad aparecerán repetidamente, 1 en cada lado de la sala. Durante la fase dos, 1 Guardia de seguridad aparecerá repetidamente en la entrada de la sala."
L.heat_increased_message = "¡Calor aumentado! Reventar cada %ss"
L.operator = "Operador de fuelles aparece"
L.operator_desc = "Durante la primera fase, 2 Operadores de fuelles aparecerán repetidamente, 1 en cada lado de la sala."

end

L = BigWigs:NewBossLocale("Flamebender Ka'graz", "esES") or BigWigs:NewBossLocale("Flamebender Ka'graz", "esMX")
if L then
L.custom_off_wolves_marker = "Marcador de Lobos de ceniza"
L.custom_off_wolves_marker_desc = "Marca los Lobos de ceniza con {rt3}{rt4}{rt5}{rt6}, requiere ayudante o líder."
L.molten_torrent_self = "Torrente de magma en ti"
L.molten_torrent_self_bar = "¡Explotas!"
L.molten_torrent_self_desc = "Cuenta atrás especial cuando Torrente de magma te afecte."

end

L = BigWigs:NewBossLocale("Kromog", "esES") or BigWigs:NewBossLocale("Kromog", "esMX")
if L then
L.custom_off_hands_marker = "Marcador de tanque en Tierra enredadora"
L.custom_off_hands_marker_desc = "Marca la Tierra enredadora que atrapa a los tanques con {rt7}{rt8}, requiere ayudante o líder."
L.destroy_pillars = "Destruye pilares"
L.prox = "Proximidad a tanque"
L.prox_desc = "Abre una ventana de proximidad de 15 metros a otros tanques para ayudarte con el daño de la habilidad Puños de piedra."

end

L = BigWigs:NewBossLocale("Beastlord Darmac", "esES") or BigWigs:NewBossLocale("Beastlord Darmac", "esMX")
if L then
L.custom_off_conflag_marker = "Marcador de Conflagración"
L.custom_off_conflag_marker_desc = [=[Marca los objetivos de Conflagración con {rt1}{rt2}{rt3}, requiere ayudante o líder.
|cFFFF0000Sólo 1 persona en la raid debería tener activada esta opción para prevenir conflictos con las marcas.|r]=]
L.custom_off_pinned_marker = "Marcador de Inmovilizar"
L.custom_off_pinned_marker_desc = [=[Marca los fijados por las lanzas con {rt8}{rt7}{rt6}{rt5}{rt4}, requiere ayudante o líder.
|cFFFF0000Sólo 1 persona en la raid debería activar esta opción para prevenir conflictos con las marcas.|r
|cFFADFF2FCONSEJO: Si eres el encargado de activar esta opción, mover rápidamente el ratón sobre las lanzas es la manera más rápida de marcarlos.|r]=]
L.next_mount = "¡Montará pronto!"

end

L = BigWigs:NewBossLocale("Operator Thogar", "esES") or BigWigs:NewBossLocale("Operator Thogar", "esMX")
if L then
L.adds_train = "Tren de adds"
L.big_add_train = "Tren de add grande"
L.cannon_train = "Tren del cañón"
L.custom_on_firemender_marker = "Ensalmadora de fuego Grom'kar"
L.custom_on_firemender_marker_desc = "Marca las Ensalmadoras de fuego Grom'kar con {rt7}, requiere ayudante o líder."
L.custom_on_manatarms_marker = "Marcador de Hombre de armas Grom'kar"
L.custom_on_manatarms_marker_desc = "Marca los Hombres de armas con {rt8}, requiere ayudante o líder."
L.deforester = "Deforestador"
L.lane = "Carril %s: %s"
L.random = "Trenes aleatorios"
L.train = "Tren"
L.trains = "Avisos de tren"
L.trains_desc = "Muestra contadores y mensajes para cada carril cuando el próximo tren esté llegando. Los carriles están numerados desde el jefe a la entrada, p.ej, Jefe 1 2 3 4 Entrada."
L.train_you = "Tren por tu vía! (%d)"

end

L = BigWigs:NewBossLocale("The Iron Maidens", "esES") or BigWigs:NewBossLocale("The Iron Maidens", "esMX")
if L then
L.custom_off_heartseeker_marker = "Marcador de Buscacorazones empapado de sangre"
L.custom_off_heartseeker_marker_desc = "Marca los objetivos de Buscacorazones con {rt1}{rt2}{rt3}, requiere ayudante o líder."
L.power_message = "¡%d Furia de hierro!"
L.ship = "Saltar al barco"
L.ship_trigger = "se prepara para controlar el cañón principal de El Acorator!"

end

L = BigWigs:NewBossLocale("Blackhand", "esES") or BigWigs:NewBossLocale("Blackhand", "esMX")
if L then
L.custom_off_markedfordeath_marker = "Marcador de Marcado para morir"
L.custom_off_markedfordeath_marker_desc = "Marca los objetivos de Marcado para morir con {rt1}{rt2}{rt3}, requiere ayudante o líder."
L.custom_off_massivesmash_marker = "Marcador de Machaque devastador masivo"
L.custom_off_massivesmash_marker_desc = "Marca el tanque que ha sido golpeado por el Machaque devastador masivo con {rt6}, requiere ayudante o líder."

end

L = BigWigs:NewBossLocale("Blackrock Foundry Trash", "esES") or BigWigs:NewBossLocale("Blackrock Foundry Trash", "esMX")
if L then
L.beasttender = "Amansabestias Señor del Trueno"
L.brute = "Bruto de tienda de desechos"
L.earthbinder = "Vinculador terrestre de la Horda de Hierro"
L.enforcer = "Déspota Roca Negra"
L.furnace = "Residuo del Horno de Fundición"
L.furnace_msg1 = "Hmm, no está un poco tostado?"
L.furnace_msg2 = "Hagamos una buena barbacoa!"
L.furnace_msg3 = "Esto no puede ser bueno..."
L.gnasher = "Rechinador Esquirla Oscura"
L.gronnling = "Gronnito obrero"
L.guardian = "Guardián del taller"
L.hauler = "Transportista ogron"
L.mistress = "Maestra de forja Palmafuego"
L.taskmaster = "Capataz de la Horda de Hierro"

end

